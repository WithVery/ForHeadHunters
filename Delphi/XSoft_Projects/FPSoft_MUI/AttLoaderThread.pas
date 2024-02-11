unit AttLoaderThread;

{$I DEFINES.INC}

interface

uses
  GlobalVars,
  Windows, // for PostMessage
{$IFDEF STOREATTASFILES}
  IdStack,    // for EIdSocketError
  IdMultipartFormData, // for TIdMultiPartFormDataStream
  IdIOHandler, IdIOHandlerSocket,         //
  IdComponent, // for TWorkMode
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL,  // for SSL
  IdHTTP,
{$ENDIF}
  Classes;

type
  TAttLoaderThread = class(TThread)
  public
    POWndHandle : cardinal;
	  AttID       : integer;
  	OrgID       : integer;

  private
    { Private declarations }
    ULHTTP: TIdHTTP;
    SSLHandler : TIdSSLIOHandlerSocketOpenSSL;

    procedure onBeginWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure onEndWork(ASender: TObject; AWorkMode: TWorkMode);

  protected
    procedure Execute; override;
  end;

implementation

{ AttLoaderThread }

Uses
	SysUtils,	// for Exception
  SyncObjs; // for wrSignaled etc.

procedure TAttLoaderThread.Execute;
var
{$IFDEF STOREATTASFILES}
  AttStream		: TMemoryStream;
  LoadingAtt  : PAttInfo;
{$ENDIF}

  Error			  : boolean;
  AttURL    : string;
  ErrorMessage : ^string;

begin
{$IFDEF TESTDLLTHREADS}
  OutputDebugString(PWideChar('---- AttLoaderThread thread (' + IntToStr(GetCurrentThreadId) + ')'));
{$ENDIF}

	AttStream  := TMemoryStream.Create;

	ULHTTP  := TIdHTTP.Create(nil);
  ULHTTP.ProtocolVersion := pv1_1;
  ULHTTP.Request.BasicAuthentication := true;
  ULHTTP.Request.Username := 'Galina';
  ULHTTP.Request.Password := 'W3ExUm1rAw94';
	ULHTTP.HandleRedirects := True;

  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSLHandler.SSLOptions.Mode := sslmUnassigned;

  ULHTTP.IOHandler := SSLHandler;

  ULHTTP.OnWork      := onWork;
  ULHTTP.OnWorkBegin := OnBeginWork;
  ULHTTP.OnWorkEnd   := OnEndWork;

	// pull files from the web-server
	if(encconn) then
		AttURL := 'https://'
  else
		AttURL := 'http://';

	AttURL := AttURL + GFPHTTPHost + ':' + IntToStr(GFPHTTPPort) + '/atts/attdwload.php';

  while not Terminated do begin

    AttNeededEvent.WaitFor(40);
    LoadingAttsCS.Enter;
    if LoadingAtts.Count > 0 then begin
    	LoadingAtt := LoadingAtts[0];
      LoadingAtts.Delete(0);
    end
    else begin
    	LoadingAtt := nil;
    end;
    LoadingAttsCS.Leave;

    if LoadingAtt = nil then continue;

	  AttStream.Clear;
		OrgID := LoadingAtt.OrgID;
		AttID := LoadingAtt.POAttID;
  	AttURL := AttURL + '?oguid=' + oid + '&oid=' + IntToStr(OrgID) + '&aid=' + IntToStr(AttID);

    Error := false;

	  try
			ULHTTP.Get(AttURL, AttStream);
	  except
	    on e: Exception do begin
  	    New(ErrorMessage);
    	  if E is EIdHTTPProtocolException then begin
	        ErrorMessage^ := (e as EIdHTTPProtocolException).Message;
  	    end
    	  else begin
        	ErrorMessage^ := e.Message;
	      end;
	  	  Error := true;
  	  	PostMessage(POWndHandle, UM_ATT_LOADINGFAILED, AttID, integer(ErrorMessage));
	    end;
  	end;

		if Terminated then break;
    if Error then continue;

		New(LoadingAtt);
  	LoadingAtt.POAttID := AttID;
	  LoadingAtt.Stream := TMemoryStream.Create;
  	LoadingAtt.Stream.LoadFromStream(AttStream);
	  PostMessage(POWndHandle, UM_ATT_LOADED, integer(LoadingAtt), 0);
  end; // while not Terminated

  // free all resources
	try
	  AttStream.Free;
		ULHTTP.Free;
  finally

  end;

end; // TAttLoaderThread.Execute;

procedure TAttLoaderThread.onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
	  PostMessage(POWndHandle, UM_ATT_LOAD_IP, integer(AWorkCount), 0);
end;

procedure TAttLoaderThread.onBeginWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
	  PostMessage(POWndHandle, UM_ATT_LOAD_STARTED, integer(AWorkCountMax), 0);
end;

procedure TAttLoaderThread.onEndWork(ASender: TObject; AWorkMode: TWorkMode);
begin
(*
  G1.Visible := false;
*)
end;


end.
