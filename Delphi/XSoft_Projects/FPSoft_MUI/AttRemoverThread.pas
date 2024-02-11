unit AttRemoverThread;

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
  SyncObjs,
  Classes;

type
  TAttRemoverThread = class(TThread)
  public
    IDsToRemove : string;

  private
    { Private declarations }
    ULHTTP: TIdHTTP;
    SSLHandler : TIdSSLIOHandlerSocketOpenSSL;

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

{ TAttRemoverThread }

procedure TAttRemoverThread.Execute;
var
  ARPONum			: integer;
  AROrgID     : integer;
  ARIDs       : string;

  Stream      : TIdMultipartFormDataStream;


  LCT					: TDateTime;
  h, m, s, ms : word;
  CCT					: TDateTime;
  ch, cm, cs, cms : word;

  resp        : string;
//	bInProgress : boolean;
  hostaddr    : string;
  wRes        : TWaitResult;

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

//  NoError := true;
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

	ARIDs := '';
  if(encconn) then
	  hostaddr := 'https://'
  else
	  hostaddr := 'http://';
  hostaddr := hostaddr + GFPHTTPHost + ':' + IntToStr(GFPHTTPPort) + '/atts/attremove.php';
//  hostaddr := hostaddr + '109.120.139.45/atts/attremove.php';
//	while NoError and (not Terminated) do begin
	while not Terminated do begin
    wRes := AttRemoveEvent.WaitFor(40);

    if not (wRes = wrSignaled) then continue;
    

    AttRemoveCS.Enter;
    if ARIDs <> '' then
     ARIDs := ARIDs + ',';
    ARIDs := ARIDs + AttsToRemove;
    AttsToRemove := '';
    AttRemoveCS.Leave;

    if (ARIDs = '') or Terminated then continue;

{$IFDEF THREADSDBGOUTPUT}
    if Terminated then begin
      OutputDebugString('---- Saver thread - Terminated! 2');
    end;
{$ENDIF}

    if not Terminated then begin
      ULHTTP.HandleRedirects := True;
			ULHTTP.Request.ContentType := 'multipart/form-data';

		  Stream  := TIdMultipartFormDataStream.Create;
      Stream.AddFormField('oguid', oid);
      Stream.AddFormField('oid',   IntToStr(AROrgID));
      Stream.AddFormField('aids',  ARIDs);

      try
				resp := ULHTTP.Post(hostaddr, Stream);
      except

      end;
      OutputDebugString(PWideChar(resp));
      ARIDs := '';

      Stream.Free;
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
