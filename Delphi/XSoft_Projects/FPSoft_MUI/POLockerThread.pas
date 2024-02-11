unit POLockerThread;

{$I DEFINES.INC}

interface

uses
  ZConnection,
  Windows,
{IFDEF THREADSDBGOUTPUT}
  SysUtils,
{ENDIF}
  Classes;

type
  TPOLockerThread = class(TThread)
  private
    { Private declarations }
    POLTL  : TZConnection;
    PLHost : string;
    PLUser : string;
    PLPort : integer;
    PLPwd  : string;
    PLDb   : string;
    PLProt : string;
  protected
    procedure Execute; override;
  public
    POTGC      : TZConnection;
    POTOPrefix : string;
    POTUID     : integer;
    POFilter   : string;
  end;

implementation

uses
	ZDataset,	 // for ZQuery
  GlobalVars,
  Forms,      // for Application
	ZDbcIntfs;  // for EZSQLException

procedure TPOLockerThread.Execute;
var
  POLTQ : TZQuery;
  RCNeeded  : boolean;
begin
{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- POLockerThread thread started (' + IntToStr(GetCurrentThreadId) + ')'));
{$ENDIF}

  RCNeeded := false;
  POLTL := TZConnection.Create(nil);

  // initialization of connection
  POLTL.HostName	:= POTGC.HostName;
  POLTL.User			:= POTGC.User;
  POLTL.Port			:= POTGC.Port;
  POLTL.Password	:= POTGC.Password;
  POLTL.Database	:= POTGC.Database;
  POLTL.Protocol	:= POTGC.Protocol;

  POTGC := nil;

  PLHost := POLTL.HostName;
  PLUser := POLTL.User;
  PLPort := POLTL.Port;
  PLPwd  := POLTL.Password;
  PLDb   := POLTL.Database;
  PLProt := POLTL.Protocol;

  POLTL.ClientCodepage := rsCharsetSetUp;
  SetUpEncryption(POLTL);

  try
  	POLTL.Connect;
  except
		on e: EZSQLException do begin
			ShowError(Application.MainForm, 'Ошибка при инициализации соединения для блокировки заявок.', e.ErrorCode, e.StatusCode, e.Message);
	    Exit;
    end;
  end;

  POLTQ := TZQuery.Create(nil);
  POLTQ.Connection	:= POLTL;

	while not Terminated do begin

//    POLockEvent.WaitFor(50000); // wait for 50 seconds
    POLockEvent.WaitFor(MinInt(50000, cto)); // wait for 50 seconds

    if not Assigned(POLTL) then begin
    	POLTL := TZConnection.Create(nil);

      POLTL.HostName	:= PLHost;
      POLTL.User			:= PLUser;
      POLTL.Port			:= PLPort;
      POLTL.Password	:= PLPwd;
      POLTL.Database 	:= PLDb;
      POLTL.Protocol	:= PLProt;

      POLTL.ClientCodepage := rsCharsetSetUp;
      SetUpEncryption(POLTL);

      try
  	    POLTL.Connect;
      except
  	    on e:Exception do begin
        	POLTL.Free;
          POLTL := nil;
          Continue;
        end;
      end;
    end;

    if Assigned(POLTL) then begin
{$IFDEF THREADSDBGOUTPUT}
      OutputDebugString('=== Reconnecting POLocker thread''s connection ... ===');
{$ENDIF}
			CheckAndReconnect(POLTL, false);
    end;

    if not Assigned(POLTQ) then begin
      POLTQ := TZQuery.Create(nil);
      POLTQ.Connection	:= POLTL;
    end;

    RCNeeded := false;
//

    if not Terminated then begin
      POLTQ.SQL.Text := 'UPDATE`' + POTOPrefix + 'po`SET rsvdby=:fUID,dtby=DATE_ADD(NOW(),INTERVAL 70 SECOND)WHERE' + POFilter;
      POLTQ.ParamByName('fUID').AsInteger   := POTUID;
{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- POLockerThread - POFilter=' + POFilter));
{$ENDIF}
      try
	  	  POLTQ.ExecSQL;
      except
  	    on e: EZSQLException do begin
          RCNeeded := (e.ErrorCode = 1053) or (e.ErrorCode = 2006);
  		  end;
      end;
    end; // if not Terminated then begin
  end; // while not terminated
{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- POLockerThread - Main loop left'));
{$ENDIF}

  // unlock all pos locked by active user
  POLTQ.SQL.Text := 'UPDATE`' + POTOPrefix + 'po`SET rsvdby=NULL,dtby=NULL WHERE rsvdby=:fUID';
  POLTQ.ParamByName('fUID').AsInteger  := POTUID;
  try
	  POLTQ.ExecSQL;
  finally
    POLTQ.Free;
  end;

  POLTL.Disconnect;
  POLTL.Free;
{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- POLockerThread - thread closed'));
{$ENDIF}


end;

end.
