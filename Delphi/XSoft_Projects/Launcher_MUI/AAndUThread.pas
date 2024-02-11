unit AAndUThread;

interface

uses
  SysUtils,   
  IdHTTP,     // for TIdHTTP
  IdStack,    // for EIdSocketError
  IdMultipartFormData, // for TIdMultiPartFormDataStream
  IdIOHandler, IdIOHandlerSocket,         //
  IdComponent, // for TWorkMode
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL,  // for SSL
  Windows,    // for PostMessage
  Forms,
  StrUtils,
  GlobalVars,  // for GetVersion
  abzipkit,    // for TAbZipKit;
  Classes;

type
  TAAndUThread = class(TThread)
  private
    { Private declarations }
    FV         : string;
    HTTP       : TIdHTTP;
    SSLHandler : TIdSSLIOHandlerSocketOpenSSL;
    SS         : TMemoryStream;
    UZ         : TAbZipKit;

    procedure onBeginWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure onEndWork(ASender: TObject; AWorkMode: TWorkMode);
  protected
    procedure Execute; override;
  public
    AAUMainForm : HWND;
    ProgName    : string;
    SIP         : string;
  end;

implementation

procedure TAAndUThread.onBeginWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  PostMessage(AAUMainForm, UM_UPDDWNLDSTARTED, NativeUInt(AWorkCountMax shr 32), AWorkCountMax and $00000000FFFFFFFF);
end;

procedure TAAndUThread.onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  PostMessage(AAUMainForm, UM_UPDDWNLDIP, NativeUInt(AWorkCount shr 32), AWorkCount and $00000000FFFFFFFF);
end;

procedure TAAndUThread.onEndWork(ASender: TObject; AWorkMode: TWorkMode);
begin
  PostMessage(AAUMainForm, UM_UPDDWNLDCMPLTD, 0, 0);
end;

procedure TAAndUThread.Execute;
var
  request : TIdMultiPartFormDataStream;
  RespStr : string;
  s       : string;
  ts      : string;
  FTA     : TStringList;
  i       : integer;
  Error   : boolean;
  FA      : integer;
  XSearch : TSearchRec;
  EC      : integer;  // error code
  EM      : ^string;  // error message

begin
  // checking for updates
  FV := GetVersion(ProgName + '.exe'); // GetVersion('fp.exe');
  if FV = '' then begin
    New(EM);
    EC  := 0;
    EM^ := 'Невозможно получить номер текущей версии.';
    PostMessage(AAUMainForm, UM_UPDFAILED, EC, integer(EM));
    Exit;
  end;

  HTTP := TIdHTTP.Create(nil);
  HTTP.ProtocolVersion := pv1_1;
  HTTP.Request.BasicAuthentication := true;
  HTTP.Request.Username := 'Galina';
  HTTP.Request.Password := 'W3ExUm1rAw94';


  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  SSLHandler.SSLOptions.Mode   := sslmUnassigned;
  SSLHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];

  HTTP.IOHandler := SSLHandler;

  request := TIdMultiPartFormDataStream.Create;
  request.AddFormField('oid', oid);
  request.AddFormField('pn', ProgName);
  request.AddFormField('cv', FV);

  try
    RespStr := HTTP.Post('https://' + SIP + '/systema/updater/', request);
  except
    on e: Exception do begin
      New(EM);
      if E is EIdSocketError then begin
        EC := (e as EIdSocketError).LastError;
        EM^ := (e as EIdSocketError).Message;
      end
      else begin
        EC  := 0;
        EM^ := e.Message;
      end;
      PostMessage(AAUMainForm, UM_UPDFAILED, EC, integer(EM));
      Exit;
    end;
  end;

	s := ReplaceStr(RespStr, '<html>', '');
  s := ReplaceStr(s, '</html>', '');
  s := ReplaceStr(s, '<header>', '');
  s := ReplaceStr(s, '</header>', '');
  s := Trim(s);
  RespStr := s;
  if s <> '' then begin
    PostMessage(AAUMainForm, UM_UPDNEEDED, 0, 0);
  end
  else begin
    PostMessage(AAUMainForm, UM_UPDNOTNEEDED, 0, 0);
    Exit;
  end;

  SS := TMemoryStream.Create;

  HTTP.OnWorkBegin := OnBeginWork;
  HTTP.OnWork      := OnWork;
  HTTP.OnWorkEnd   := OnEndWork;

  try
    HTTP.Get('https://' + SIP + '/systema/' + oid + '/'  + ProgName + '/' + s + '/' + ProgName + '_update.zip', SS);
  except
    on e: Exception do begin
      New(EM);
      if E is EIdHTTPProtocolException then begin
        EC := (e as EIdHTTPProtocolException).ErrorCode;
        EM^ := (e as EIdHTTPProtocolException).Message;
      end
      else begin
        EC  := 0;
        EM^ := e.Message;
      end;
      PostMessage(AAUMainForm, UM_UPDFAILED, EC, integer(EM));
      Exit;
    end;
  end;

  try
    SS.SaveToFile(UTmpFolder + ProgName + '_updater.zip.' + s);
  except
    on e: Exception do begin
      New(EM);
      EC  := 0;
      EM^ := e.Message;
      PostMessage(AAUMainForm, UM_UPDFAILED, EC, integer(EM));
      Exit;
    end;
  end;
  SS.Free;

  UZ := TAbZipKit.Create(nil);

  ts := UTmpFolder + ProgName + '_updater.zip.' + s;
  UZ.OpenArchive(ts);
  PostMessage(AAUMainForm, UM_UPDSTARTED, UZ.Count, 0);

  RespStr := ts + '_\';

  if not DirectoryExists(RespStr) then begin
    if not CreateDir(RespStr) then begin
      New(EM);
      EC  := GetLastError;
      EM^ := 'Невозможно создать временный каталог.';
      PostMessage(AAUMainForm, UM_UPDFAILED, EC, integer(EM));
      Exit;
    end;
  end;

  UZ.BaseDirectory := RespStr;
  try
    UZ.ExtractFiles('*.*');
  except
    on e: Exception do begin
      New(EM);
      EC  := 0;
      EM^ := e.Message;
      PostMessage(AAUMainForm, UM_UPDFAILED, EC, integer(EM));
      Exit;
    end;
  end;
  UZ.CloseArchive;
  UZ.Free;
  UZ := nil;

  FTA := TStringList.Create;

  FA := integer(faAnyFile) or integer(faReadOnly) or integer(faDirectory);
  FindFirst(RespStr + '\*.*', FA, XSearch);
  if (XSearch.Name <> '.') and (XSearch.Name <> '..') then
    FTA.Add(XSearch.Name);

  while FindNext(XSearch) = 0 do begin
    if (XSearch.Name <> '.') and (XSearch.Name <> '..') then
      FTA.Add(XSearch.Name);
  end;
  SysUtils.FindClose(XSearch);


  for i := 0 to FTA.Count - 1 do begin
    // rename the old file
    MoveFile(PWideChar(ExtractFilePath(Application.ExeName) + FTA[i]), PWideChar(ExtractFilePath(Application.ExeName) + FTA[i] + '.old'));
    // move downloaded file
    if not MoveFile(PWideChar(RespStr + FTA[i]), PWideChar(ExtractFilePath(Application.ExeName) + FTA[i])) then begin
    	Application.MessageBox(PWideChar('Невозможно скопировать файл ' + RespStr + FTA[i] + ' в ' + ExtractFilePath(Application.ExeName) + FTA[i] + '. Код ошибки: ' + IntToStr(GetLastError)), 'Ошибка установки обновления', MB_ICONERROR or MB_OK);
    end;
    PostMessage(AAUMainForm, UM_UPDIP, i + 1, 0);
  end;

  PostMessage(AAUMainForm, UM_UPDDELTMPFLS, 0, 0);
  for i := 0 to FTA.Count - 1 do begin
    DeleteFile(PWideChar(ExtractFilePath(Application.ExeName) + FTA[i] + '.old'));
  end;

  try
    SysUtils.DeleteFile(ts);
    SysUtils.DeleteFile(RespStr);
    RemoveDirectory(PWideChar(RespStr));
  except
    on e: Exception do begin
      New(EM);
      EC  := 0;
      EM^ := e.Message;
      PostMessage(AAUMainForm, UM_UPDFAILED, EC, integer(EM));
      Exit;
    end;
  end;

  PostMessage(AAUMainForm, UM_UPDCMPLTD, 0, 0);
  FTA.Clear;
  FTA.Free;
end;

end.
