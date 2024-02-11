unit AttSaverThread;

{$I DEFINES.INC}

interface

uses
  ZConnection,
  Forms,
  windows,
  SysUtils,
{$IFDEF TESTDLLTHREADS}
  Dialogs,
{$ENDIF}
  IdStack,    // for EIdSocketError
  IdMultipartFormData, // for TIdMultiPartFormDataStream
  IdIOHandler, IdIOHandlerSocket,         //
  IdComponent, // for TWorkMode
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL,  // for SSL
  IdHTTP,
  GlobalVars,
  Classes;

type
  TAttSaverThread = class(TThread)
  public
    ASConnection		: TZConnection;

  private
    { Private declarations }
    ULHTTP: TIdHTTP;
    SSLHandler : TIdSSLIOHandlerSocketOpenSSL;

    ALHost : string;
    ALUser : string;
    ALPort : integer;
    ALPwd  : string;
    ALDb   : string;
    ALProt : string;

  protected
{$IFDEF DEBUGAST}
    df		 : TextFile;
    dfname : string;
    dfec	 : integer;
//    dfenabled : boolean;
{$ENDIF}
    procedure Execute; override;
  end;

implementation

{ TAttSaverThread }

procedure TAttSaverThread.Execute;
var
  PONum				: integer;
  AttName			: string;

  FStream			: TMemoryStream;
  Stream      : TIdMultipartFormDataStream;

  ALOrgID     : integer;
  ALPOAttID		: integer;
  ALFileName  : string;

  NoError     : boolean;
  LCT					: TDateTime;
  h, m, s, ms : word;
  CCT					: TDateTime;
  ch, cm, cs, cms : word;

  resp        : string;
	bInProgress : boolean;
  hostaddr    : string;

begin

{$IFDEF DEBUGAST}
    dfname := APPDATAFOLDER + '\' + 'ats.log';
    try
	  	AssignFile(df, dfname);
      ReWrite(df);
      CloseFile(df);
    except
			on e: EInOutError do begin
				ShowError(nil, 'Ошибка при инициализации соединения.', e.ErrorCode, '', e.Message);
	    end;
    end;
{$ENDIF}

{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- AttSaver thread (' + IntToStr(GetCurrentThreadId) + ') started ---'));
{$ENDIF}

  NoError := true;
	ULHTTP  := TIdHTTP.Create(nil);

  ULHTTP.ProtocolVersion := pv1_1;
  ULHTTP.Request.BasicAuthentication := true;
  ULHTTP.Request.Username := 'Galina';
  ULHTTP.Request.Password := 'W3ExUm1rAw94';

  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSLHandler.SSLOptions.Mode := sslmUnassigned;

  ULHTTP.IOHandler := SSLHandler;


{$IFDEF DEBUGAST}
  try
	 	AssignFile(df, dfname);
  	Append(df);
    Write(df, 'Журнал потока сохранения приложений: начало работы. ' + DateToStr(Now) + ' ' + TimeToStr(Now) + ' ');
    if NoError then WriteLn(df, 'Успешно') else WriteLn(df, 'Ошибка');
  finally
    CloseFile(df);
  end;
{$ENDIF}

	LCT := now;
  DecodeTime(LCT, h, m, s, ms);

  bInProgress := false;
  if(encconn) then
	  hostaddr := 'https://'
  else
	  hostaddr := 'http://';
  hostaddr := hostaddr + GFPHTTPHost + ':' + IntToStr(GFPHTTPPort) + '/atts/attupload.php';
	while NoError and (not Terminated) do begin
  	if not bInProgress then
	    AttSaveEvent.WaitFor(40);

    AttSaveCS.Enter;
    if (AttsToSave.Count = 0) or Terminated then begin
    	bInProgress := false;
			AttSaveCS.Leave;
      continue;
  	end
  	else begin
    	bInProgress := true;
    end;

//    NoError := true;
    if not Terminated then begin
  	  ALFileName := PAttToSave(AttsToSave[0]).ATS_Name;
      ALPOAttID  := PAttToSave(AttsToSave[0]).ATS_POAttID;
      ALOrgID    := PAttToSave(AttsToSave[0]).ATS_OrgID;

			FStream := TMemoryStream.Create;
      Fstream.LoadFromStream(PAttToSave(AttsToSave[0]).ATS_Stream);

      PAttToSave(AttsToSave[0]).ATS_Stream.Free;
      AttsToSave.Delete(0);
      AttSaveCS.Leave; // leaving critical section
    end;
{$IFDEF THREADSDBGOUTPUT}
    if Terminated then begin
      OutputDebugString('---- Saver thread - Terminated! 2');
    end;
{$ENDIF}

    if NoError and not Terminated then begin
      ULHTTP.HandleRedirects := True;
			ULHTTP.Request.ContentType := 'multipart/form-data';
		  Stream  := TIdMultipartFormDataStream.Create;

      Stream.AddFormField('oguid', oid);
      Stream.AddFormField('oid',   IntToStr(ALOrgID));
      Stream.AddFormField('aid',   IntToStr(ALPOAttID));
      // old Indy version
    	//Stream.AddObject('filename', 'application/octet-stream', FStream, IntToStr(Fstream.Size));
      // new indy version
      Stream.AddObject('filename', 'application/octet-stream', '', FStream, IntToStr(Fstream.Size));

      try
				resp := ULHTTP.Post(hostaddr, Stream);
      except

      end;

      OutputDebugString(PWideChar(resp));

      Stream.Free;
      FStream.Free;
    end;

{$IFDEF THREADSDBGOUTPUT}
    if Terminated then begin
      OutputDebugString('---- Saver thread - Terminated! 3');
    end;
{$ENDIF}
  end; // while not Terminated -- main loop

{$IFDEF DEBUGAST}
  try
	 	AssignFile(df, dfname);
  	Append(df);
    Write(df, 'Журнал потока сохранения приложений: завершение работы. ' + DateToStr(Now) + ' ' + TimeToStr(Now));
  finally
    CloseFile(df);
  end;
{$ENDIF}

	ULHTTP.Free;
end;

end.
