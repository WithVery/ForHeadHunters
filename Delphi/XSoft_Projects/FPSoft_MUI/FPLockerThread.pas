unit FPLockerThread;

{$I DEFINES.INC}

interface

uses
  ZConnection,
  Windows,
  SysUtils,
  Classes;

type
  TFPLockerThread = class(TThread)
  private
    { Private declarations }
    FPLTL : TZConnection;
    LHost : string;
    LUser : string;
    LPort : integer;
    LPwd  : string;
    LDb   : string;
    LProt : string;
  protected
    procedure Execute; override;
  public
    FPTGC      : TZConnection;
    FPTNum     : integer;
    FPTOPrefix : string;
    FPTUID     : integer;
  end;

implementation

{ FPLockerThread }

uses
	ZDataset,	 // for ZQuery
  GlobalVars,
  Forms,        // for Application
	ZDbcIntfs;    // for EZSQLException



procedure TFPLockerThread.Execute;
var
  FPLTQ    : TZQuery;
  RCNeeded : boolean;
begin
{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- FPLockerThread thread (' + IntToStr(GetCurrentThreadId) + ')'));
{$ENDIF}

  FPLTL := TZConnection.Create(nil);
  // initialization of connection
  FPLTL.HostName	:= FPTGC.HostName;
  FPLTL.User			:= FPTGC.User;
  FPLTL.Port			:= FPTGC.Port;
  FPLTL.Password	:= FPTGC.Password;
  FPLTL.Database	:= FPTGC.Database;
  FPLTL.Protocol	:= FPTGC.Protocol;

  FPTGC := nil;
  RCNeeded := false;

  SetUpEncryption(FPLTL);

  LHost := FPLTL.HostName;
  LUser := FPLTL.User;
  LPort := FPLTL.Port;
  LPwd  := FPLTL.Password;
  LDb   := FPLTL.Database;
  LProt := FPLTL.Protocol;

  FPLTL.ClientCodepage := rsCharsetSetUp;
  SetupEncryption(FPLTL);
  try
  	FPLTL.Connect;
  except
		on e: EZSQLException do begin
			ShowError(Application.MainForm, 'Ошибка при инициализации соединения для блокировки финплана.', e.ErrorCode, e.StatusCode, e.Message);
	    Exit;
    end;
  end;

  FPLTQ := TZQuery.Create(nil);
  FPLTQ.Connection	:= FPLTL;

	while not Terminated do begin

    FPLockEvent.WaitFor(50000); // wait for 50 seconds
//
    if not Assigned(FPLTL) then begin
    	FPLTL := TZConnection.Create(nil);

      FPLTL.HostName	:= LHost;
      FPLTL.User			:= LUser;
      FPLTL.Port			:= LPort;
      FPLTL.Password	:= LPwd;
      FPLTL.Database 	:= LDb;
      FPLTL.Protocol	:= LProt;

      FPLTL.ClientCodepage := rsCharsetSetUp;
      SetupEncryption(FPLTL);

      try
  	    FPLTL.Connect;
      except
  	    on e:Exception do begin
        	FPLTL.Free;
          FPLTL := nil;
          Continue;
        end;
      end;
    end;

    if Assigned(FPLTL) and ((not FPLTL.Connected) or RCNeeded) then begin
{$IFDEF THREADSDBGOUTPUT}
          OutputDebugString('=== Reconnecting FPLocker thread''s connection ... ===');
{$ENDIF}
      try
		    SetUpEncryption(FPLTL);
        FPLTL.Reconnect
      except
  	    on e:Exception do begin
          Continue;
        end;
      end;
    end;

    if not Assigned(FPLTQ) then begin
      FPLTQ := TZQuery.Create(nil);
      FPLTQ.Connection	:= FPLTL;
    end;

    RCNeeded := false;
//
    if not Terminated then begin
      FPLTQ.SQL.Text := 'UPDATE`' + FPTOPrefix + 'fp`SET rsvdby=:fUID,dtby=DATE_ADD(NOW(),INTERVAL 70 SECOND)WHERE`index`=:fFPID';
      FPLTQ.ParamByName('fUID').AsInteger  := FPTUID;
      FPLTQ.ParamByName('fFPID').AsInteger := FPTNum;
      try
	  	  FPLTQ.ExecSQL;
      except
  	    on e: EZSQLException do begin
          RCNeeded := (e.ErrorCode = 1053) or (e.ErrorCode = 2006);
  		  end;
      end;
    end; // if not Terminated then begin
  end; // while not terminated

{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- FPLockerThread - Main loop left'));
{$ENDIF}

  FPLTQ.SQL.Text := 'UPDATE`' + FPTOPrefix + 'fp`SET rsvdby=NULL,dtby=NULL WHERE`index`=:fFPID';
  FPLTQ.ParamByName('fFPID').AsInteger := FPTNum;
  try
	  FPLTQ.ExecSQL;
  finally
    FPLTQ.Free;
  end;

  FPLTL.Disconnect;
  FPLTL.Free;
{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- FPLockerThread - thread closed'));
{$ENDIF}
end;

end.
