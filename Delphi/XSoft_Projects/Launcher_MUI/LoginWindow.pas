unit LoginWindow;

{I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, acPNG, ExtCtrls, StdCtrls, ErrorWindow, ZConnection, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, jpeg, sPanel, sLabel,
	GlobalVars,
	StrUtils,
  DECUtil, DECCipher, DECHash, DECFmt,
  AAndUThread, // for TAAndUThread
  LoadingProgressWindow, // for loadingprogressform
  IdStack, // for EIdSocketError
  IdMultipartFormData,
  sGroupBox, sButton, sEdit, Buttons, sBitBtn, sCheckBox, sSkinManager, Menus, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, ComCtrls,
  sStatusBar, DKLang;//, Menus;

const
  SmallHeight : integer = 290; //280;
  BigHeight   : integer = 385; //366;
  ba1         : integer = 4;
  ba2         : integer = 8;


  ACipherClass : TDECCipherClass = TCipher_Rijndael;
  ACipherMode  : TCipherMode = cmCBCx;
  AHashClass   : TDECHashClass = THash_Whirlpool;
  ATextFormat  : TDECFormatClass = TFormat_Mime64;
  AKDFIndex    : LongWord = 1;


type

  TLogInForm = class(TForm)
    sPanel1: TsPanel;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    ServerLabel: TsLabelFX;
    ShowPropButton: TsButton;
    OKButton: TsBitBtn;
    UserLoginEdit: TsEdit;
    UserPasswordEdit: TsEdit;
    CancelButton: TsBitBtn;
    ServerNameEdit: TsEdit;
    sSkinManager1: TsSkinManager;
    SaveButton: TsBitBtn;
    HTTP: TIdHTTP;
    SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    SB: TsStatusBar;
    lc: TDKLanguageController;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowPropButtonClick(Sender: TObject);
    procedure SaveSettingsButtonClick(Sender: TObject);
    procedure UserLoginEditKeyPress(Sender: TObject; var Key: Char);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UserPasswordEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    PropShown  : boolean;
    Connection : TZConnection;
    DS				 : TZQuery;
//    TDS        : TZQuery;
    PRName     : string;
    AUT        : TAAndUThread;
    DF         : TLoadingProgressForm;

    UpdIsIP    : boolean;

    procedure OnUpdNeeded(var Msg: TMessage); message UM_UPDNEEDED;
    procedure OnUpdFailed(var Msg: TMessage); message UM_UPDFAILED;
    procedure OnUpdNotNeeded(var Msg: TMessage); message UM_UPDNOTNEEDED;
    procedure OnUpdDwnldStarted(var Msg: TMessage); message UM_UPDDWNLDSTARTED;
    procedure OnUpdDwnldIP(var Msg: TMessage); message UM_UPDDWNLDIP;
    procedure OnUpdDwnldCmpltd(var Msg: TMessage); message UM_UPDDWNLDCMPLTD;
    procedure OnUpdStarted(var Msg: TMessage); message UM_UPDSTARTED;
    procedure OnUpdIP(var Msg: TMessage); message UM_UPDIP;
    procedure OnUpdDelTmpFls(var Msg: TMessage); message UM_UPDDELTMPFLS;
    procedure OnUpdPCmpltd(var Msg: TMessage); message UM_UPDCMPLTD;

    procedure	SaveConIniParams;
    procedure EnableControls(aEnable: boolean);
    function Decrypt(const AText: String; const APassword: String): String; overload;
    function Encrypt(const AText: String; const APassword: String): String; overload;

    //procedure LoadResourceStrings(wLang : LangID);
  public
    { Public declarations }
  end;

var
  LogInForm: TLogInForm;

implementation

{$R *.dfm}
uses
  abzipkit,
	ZDbcIntfs;   // for EZSQLException

procedure DeleteFilesFromPath(APath: string);
var
  XSearch: TSearchRec;
  FA      : integer;
begin
  FA := integer(faAnyFile) or integer(faReadOnly) or integer(faDirectory);
  FindFirst(APath + '\*.*', FA, XSearch);
  DeleteFile(APath + '\' + XSearch.Name);
  while FindNext(XSearch) = 0 do DeleteFile(APath + '\' + XSearch.Name);
  FindClose(XSearch);
end;

(*
procedure TLogInForm.LoadResourceStrings(wLang : LangID);
begin
  rsCriticalError := GetStringRes(nrsCriticalError, wLang);
end;
*)

procedure TLogInForm.EnableControls(aEnable : boolean);
begin
  OKButton.Enabled          := aEnable;
  UserLoginEdit.Enabled     := aEnable;
  UserPasswordEdit.Enabled  := aEnable;
  UserPasswordEdit.Enabled  := aEnable;
  ServerNameEdit.Enabled    := aEnable;
  ShowPropButton.Enabled    := aEnable;
  SaveButton.Enabled        := aEnable;
  CancelButton.Enabled      := aEnable;

  UpdIsIP := not aEnable;
end;

procedure TLogInForm.OnUpdNeeded(var Msg: TMessage);
begin
  SB.SimpleText := rsDwldingUpdates;
end;

procedure TLogInForm.OnUpdNotNeeded(var Msg: TMessage);
begin
  SB.SimpleText := rsNoUpdates;
  EnableControls(true);
  UserPasswordEdit.SetFocus;
end;

procedure TLogInForm.OnUpdFailed(var Msg: TMessage);
begin
  SB.SimpleText := '';
  ShowError(Self, rsUpdateError, Msg.WParam, '', string((pointer(Msg.LParam))^));

  Dispose(pointer(Msg.LParam));
  EnableControls(true);
  Invalidate;
end;

procedure TLogInForm.OnUpdDwnldStarted(var Msg: TMessage);
begin
  DF := TLoadingProgressForm.Create(self);
  DF.PB.MinValue := 0;
  DF.PB.MaxValue := Msg.WParam shl 32 or Msg.LParam;
  DF.PB.Progress := 0;
  DF.Lbl.Caption := rsDwldingUpdates;
  DF.Show
end;

procedure TLogInForm.OnUpdDwnldIP(var Msg: TMessage);
begin
  if Assigned(DF) then begin
    DF.PB.Progress := Msg.WParam shl 32 or Msg.LParam;
    DF.PB.Invalidate;
  end;
end;

procedure TLogInForm.OnUpdDwnldCmpltd(var Msg: TMessage);
begin
  SB.SimpleText := rsUpdatesDownloaded;
  if Assigned(DF) then
    DF.Free;
end;

procedure TLogInForm.OnUpdStarted(var Msg: TMessage);
begin
  DF := TLoadingProgressForm.Create(self);
  DF.PB.MinValue := 0;
  DF.PB.MaxValue := Msg.WParam;
  DF.PB.Progress := 0;
  DF.Lbl.Caption := rsInstallingUpdates;
  DF.Show
end;

procedure TLogInForm.OnUpdIP(var Msg: TMessage);
begin
  if Assigned(DF) then
    DF.PB.Progress := Msg.WParam;
end;

procedure TLogInForm.OnUpdDelTmpFls(var Msg: TMessage);
begin
  DF.Lbl.Caption := rsRemovingTempFiles; // 'Удаление временных файлов...';
  DF.Lbl.Repaint;
end;

procedure TLogInForm.OnUpdPCmpltd(var Msg: TMessage);
begin
  SB.SimpleText :=  rsUpdatesInstalled; //'Обновления установлены';
  if Assigned(DF) then
    DF.Free;
  EnableControls(true);
end;

procedure TLogInForm.SaveSettingsButtonClick(Sender: TObject);
begin
  SaveConIniParams;
end;

procedure TLogInForm.ShowPropButtonClick(Sender: TObject);
begin
  if not PropShown then begin
    ShowPropButton.Caption := '<<';
    ShowPropButton.Down    := true;
    Height 			           := BigHeight;
    ServerNameEdit.Visible := true;
    ServerLabel.Visible    := true;
    SaveButton.Visible     := true;
  end
  else begin
    ShowPropButton.Caption := '>>';
    ShowPropButton.Down    := false;
    Height                 := SmallHeight;
    ServerNameEdit.Visible := false;
    ServerLabel.Visible    := false;
    SaveButton.Visible     := false;
  end;
  PropShown := not PropShown;
end;

procedure TLogInForm.UserLoginEditKeyPress(Sender: TObject; var Key: Char);
begin
	if (Key = chr(13)) and (UserLoginEdit.Text	<> '') then begin
	  Key:= #0;
		UserPasswordEdit.SetFocus
  end;
end;

procedure TLogInForm.UserPasswordEditKeyPress(Sender: TObject; var Key: Char);
begin
	if (Key = chr(13)) and (UserLoginEdit.Text <> '') and (UserPasswordEdit.Text <> '')  then begin
	  Key:= #0;
    OKButtonClick(Sender);
  end;
end;

procedure	TLogInForm.SaveConIniParams;
begin
  try
		ConIniFile.WriteString('General',  'AuthSvr',  ServerNameEdit.Text);
		ConIniFile.WriteString('General',  'LastUser', UserLoginEdit.Text);
  Except
  	on E : EIniFileException do begin
    	ConIniFileIsRO := true;
      SaveButton.Enabled := false;
    end;
  end;
end;

procedure TLogInForm.CancelButtonClick(Sender: TObject);
begin
	Close;
end;

procedure TLogInForm.FormCreate(Sender: TObject);
var
//  FV      : string;
  request : TIdMultiPartFormDataStream;
  RespStr : string;
  s       : string;
  SS      : TMemoryStream;
  UZ      : TAbZipKit;
  ts      : string;

  FA : integer;
  XSearch : TSearchRec;

  FTA : TStringList;
  i : integer;
  Error : boolean;

begin
  // load proper language
    LangManager.ScanForLangFiles(ExtractFileDir(ParamStr(0)), '*.lng', False);
		//LangManager.LanguageID := 2057; //ENG (UK)
    //LangManager.LanguageID := 3082; //ESP (Inernational)

	if(not SetThreadLocale(LangManager.LanguageID)) then
	  halt;

	LoadResourceStrings(LangManager.LanguageID);

	// Initial hiding of the properties part
	PropShown 	:= true;
  ShowPropButtonClick(Sender);

  // pulling the connection data
  if WorkingWithIni then begin
		ServerNameEdit.Text := ConIniFile.ReadString('General', 'AuthSvr', '127.0.0.1');
    UserLoginEdit.Text  := ConIniFile.ReadString('General', 'LastUser', '');
    PRName              := ConIniFile.ReadString('General', 'Program', '');
  end
  else begin
		ServerNameEdit.Text := '127.0.0.1';
    UserLoginEdit.Text  := '';
    PRName              := '';
  end;

  if (oid = '') or (PRName = '') then  begin
    ShowError(nil, rsCriticalError, 0, '', rsIncorrectGUIDError);
    Halt;
  end;

  if not ConIniFileIsRO then begin
    SaveConIniParams;
  end
  else begin
    SaveButton.Enabled := false;
  end;

  // Initializing the connections
  Connection := TZconnection.Create(nil);
  DS         := TZQuery.Create(Self);

end;

procedure TLogInForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin Close; Key := 0; end;
  end;
end;

procedure TLogInForm.FormShow(Sender: TObject);
begin
  // check for upgrades
  EnableControls(false);

  UpdIsIP := true;

  AUT := TAAndUThread.Create(TRUE);
  AUT.AAUMainForm     := Self.Handle;
  AUT.ProgName        := PRName;
  AUT.SIP             := ServerNameEdit.Text;

  AUT.Priority				:= tpLower;
  AUT.FreeOnTerminate	:= true;

  AUT.Resume;
  SB.SimpleText := rsCheckingForUpdates;

end;

procedure TLogInForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if UpdIsIP then CanClose := false;
end;

procedure TLogInForm.OKButtonClick(Sender: TObject);
var
  RespStr : string;
  Error   : boolean;
  k       : string;
  s       : string;
  ss      : string;
  request : TIdMultiPartFormDataStream;

  //
	PwdStr 				: string;
  ErrorMessage  : string;
  i             : integer;
  port          : integer;
  EncConn       : boolean;

  si : _STARTUPINFOW;
  pi : _PROCESS_INFORMATION;

begin
  // getting data from HTTP
  if Assigned(Connection) and Connection.Connected then
    Connection.Disconnect;

  error := false;

  request:= TIdMultiPartFormDataStream.Create;
  HTTP.Request.BasicAuthentication := true;
  HTTP.Request.Username := 'Galina';
  HTTP.Request.Password := 'W3ExUm1rAw94';

  try
    request.AddFormField('oid', oid);
    RespStr := HTTP.Post('https://' + ServerNameEdit.Text + '/systema/', request);
  except
    on e:EIdSocketError do begin
      ShowError(Self, rsConnectionError, e.LastError, '', e.Message);
      error := true;
    end;
  end;

  request.Free;

  if Error then begin
    Exit;
  end;

  k := MidStr(oid, trunc(sqrt(ba1)) + ba2 * 2, ba2 * 2 + 2) +  MidStr(oid, trunc(sqrt(ba1)), ba2 * 2 + 2);
  s := ReplaceStr(RespStr, '<html>', '');
  s := ReplaceStr(s, '</html>', '');
  s := ReplaceStr(s, '<header>', '');
  s := ReplaceStr(s, '</header>', '');
  s := Trim(s);
  RespStr := s;
  if s <> '' then begin
    s := Decrypt(s, k);
  end
  else begin
    ShowMessage(rsIncorrectData);
    Exit;
  end;
    // setting up the connection
  Connection.Protocol	:= 'mysql';
  Connection.LibraryLocation:=ExtractFilePath(Application.ExeName)+'libmariadb.dll';
  Connection.ClientCodepage := 'cp1251'; // rsCharsetSetUp;

  // DB Server adress
  i := Pos(';', s);
  if i = 0 then begin
    ShowMessage(rsIncorrectData);
  end;
  Connection.HostName := LeftStr(s, i - 1);
  s := MidStr(s, i + 1, Length(s));

  // DB server port
  i := Pos(';', s);
  if i = 0 then begin
    ShowMessage(rsIncorrectData);
  end;
  TryStrToInt(LeftStr(s, i - 1), port);
  Connection.Port			:= port;
  s := MidStr(s, i + 1, Length(s));

  // DB Username 
  i := Pos(';', s);
  if i = 0 then begin
    ShowMessage(rsIncorrectData);
  end;
  Connection.User			:= LeftStr(s, i - 1);
  s := MidStr(s, i + 1, Length(s));

  // DB pwd
  i := Pos(';', s);
  if i = 0 then begin
    ShowMessage(rsIncorrectData);
  end;
  Connection.Password := LeftStr(s, i - 1);
  s := MidStr(s, i + 1, Length(s));

  // Database name
  i := Pos(';', s);
  if (i = 0) then begin
    if s = '' then begin
      ShowMessage(rsIncorrectDataRcvd);
      Connection.Database	:= '';
      Exit;
    end
    else begin
      Connection.Database	:= s;
    end;
  end
  else begin
    Connection.Database := LeftStr(s, i - 1);
    s := MidStr(s, i + 1, Length(s));
  end;

  // Encrypt connection flag
  i := Pos(';', s);
  if (i = 0) then begin
    ShowMessage(rsIncorrectData);
  end;
  TryStrToInt(LeftStr(s, i - 1), port);
  EncConn := boolean(port);
  s := MidStr(s, i + 1, Length(s));

  if EncConn then begin
    Connection.Properties.Values['MYSQL_SSL']      := 'TRUE';
    Connection.Properties.Values['MYSQL_SSL_KEY']  := SSLDATAFOLDER + 'client-key.pem';
    Connection.Properties.Values['MYSQL_SSL_CERT'] := SSLDATAFOLDER + 'client-cert.pem';
    Connection.Properties.Values['MYSQL_SSL_CA']   := SSLDATAFOLDER + 'ca-cert.pem';
  end;

  try
//    ShowMessage('коннект');
    Connection.Connect;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, rsConnectionError, e.ErrorCode, e.StatusCode, e.Message);
      error := true;
    end;
  end;

  if Error then
    Exit;

  DS.Connection	:= Connection;
  DS.SQL.Text:= 'SET old_passwords=FALSE';
  try
    DS.ExecSQL;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, rsConnectionError, e.ErrorCode, e.StatusCode, e.Message);
      error := true;
    end;
  end;

  if error then
    Exit;

  DS.SQL.Text := 'SELECT 1 FROM users WHERE Login=:fLogin AND PASSWORD(:fPWD)=Password';
  DS.ParamByName('fLogin').AsAnsiString := UserLoginEdit.Text;
  DS.ParamByName('fPWD').AsString 	:= UserPasswordEdit.Text;
  try
    DS.Open;
  except
		on e: EZSQLException do begin
			ShowError(Self, rsAuthorError, e.ErrorCode, e.StatusCode, e.Message);
	    error := true;
    end;
  end;

  if not Error then begin
    if DS.RecordCount = 0 then begin
			ShowError(Self, rsAuthorError, 0, '', rsCheckLoginPwd);
    end
    else begin
      ss := '"' + ExtractFileDir(Application.ExeName) + '\' + PRName + '.exe"';
      if not CreateProcess(nil, PWideChar(ss + ' ' + RespStr + ' ' + UserLoginEdit.Text + ' ' + UserPasswordEdit.Text), nil, nil, true, 0, nil, nil, si, pi) then begin
		  	ShowError(Self, rsFailedToLaunchFile, GetLastError, '', rsFile + ': ' + ss);
      end;
      if WorkingWithIni then begin
        try
          ConIniFile.WriteString('General', 'LastUser', UserLoginEdit.Text);
        finally

        end;
      end;
      Halt
    end;
  end;
end;

function TLoginForm.Encrypt(const AText: String; const APassword: String): String;
var
  ASalt: Binary;
  AData: Binary;
  APass: Binary;
begin
  with ValidCipher(ACipherClass).Create, Context do
  try
    ASalt := RandomBinary(16);
    APass := ValidHash(AHashClass).KDFx(APassword[1], Length(APassword) * SizeOf(APassword[1]), ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);
    Mode := ACipherMode;
    Init(APass);
    SetLength(AData, Length(AText) * SizeOf(AText[1]));
    Encode(AText[1], AData[1], Length(AData));
    Result := ValidFormat(ATextFormat).Encode(ASalt + AData + CalcMAC);
  finally
    Free;
    ProtectBinary(ASalt);
    ProtectBinary(AData);
    ProtectBinary(APass);
  end;
end;

function TLoginForm.Decrypt(const AText: String; const APassword: String): String;
var
  ASalt: Binary;
  AData: Binary;
  ACheck: Binary;
  APass: Binary;
  ALen: Integer;
begin
  with ValidCipher(ACipherClass).Create, Context do begin
    try
      ASalt := ValidFormat(ATextFormat).Decode(AText);
      ALen := Length(ASalt) - 16 - BufferSize;
      AData := System.Copy(ASalt, 17, ALen);
      ACheck := System.Copy(ASalt, ALen + 17, BufferSize);
      SetLength(ASalt, 16);
      APass := ValidHash(AHashClass).KDFx(APassword[1], Length(APassword) * SizeOf(APassword[1]), ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);
      Mode := ACipherMode;
      Init(APass);
      SetLength(Result, ALen div SizeOf(AText[1]));
      Decode(AData[1], Result[1], ALen);
      if ACheck <> CalcMAC then
        raise Exception.Create('Invalid data');
    finally
      Free;
      ProtectBinary(ASalt);
      ProtectBinary(AData);
      ProtectBinary(ACheck);
      ProtectBinary(APass);
    end;
  end; // with
end;

end.
