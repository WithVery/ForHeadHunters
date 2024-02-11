unit PushToDBThread;

{$I DEFINES.INC}

interface

uses
  ZConnection,
{$IFDEF THREADSDBGOUTPUT}
  windows, // for OutputDebugString
{$ENDIF}
  SysUtils,  // for Exception
	ZDbcIntfs, // for EZDBCException
  SyncObjs,  // for wrSignaled

  ZDataset,
  Classes;

type
  PLogInfo = ^TLogInfo;
  TLogInfo = record
    ldt   : TDateTime;
    lcode : integer;
    ltype	: integer;
    ldata	: string;
    lsrc	: string;
  end;

  TPushToDBThread = class(TThread)
  public
    ToLog : TList;

    UPTBConnection	: TZConnection;
    procedure SetSDF(aSDF: string);
    procedure SetEC(aEC: boolean);

  private
    { Private declarations }
    UPTBLConnection	: TZConnection;
	  LDataset	: TZQuery;

    ULHost : string;
    ULUser : string;
    ULPort : integer;
    ULPwd  : string;
    ULDb   : string;
    ULProt : string;
    EncConn : boolean;
    SSLDATAFOLDER : string;

		procedure SetUpEncryption(var AConn: TZConnection);

  protected
    procedure Execute; override;
    function ExitIt: boolean;
  end;

var
  PushToDBEvent		: TEvent;
  PushToDBCS			: TCriticalSection;

implementation

{ TPushToDBThread }
uses   GlobalVars;

procedure TPushToDBThread.SetSDF(aSDF: string);
begin
	SSLDATAFOLDER := aSDF;
end;

procedure TPushToDBThread.SetEC(aEC: boolean);
begin
	EncConn := aEC;
end;

procedure TPushToDBThread.SetUpEncryption(var AConn: TZConnection);
begin
  {$I SetUpEncryption.inc}
end;

function TPushToDBThread.ExitIt: boolean;
begin
  Result := Terminated;
  if Result then begin
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- TPushToDBThread - Exit Signal caught!!!');
{$ENDIF}
  end;
end;

procedure TPushToDBThread.Execute;

var
  RCNeeded  : boolean;
  tlc       : integer;
  LogInfo		: PLogInfo;

begin
  { Place thread code here }
  RCNeeded := false;

  PushToDBCS.Enter;
	ToLog := TList.Create;
  PushToDBCS.Leave;

{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- Update thread (' + IntToStr(GetCurrentThreadId) + ') started ---'));
{$ENDIF}
	UPTBLConnection := TZConnection.Create(nil);

  UPTBLConnection.HostName	:= UPTBConnection.HostName;
  UPTBLConnection.User			:= UPTBConnection.User;
  UPTBLConnection.Port			:= UPTBConnection.Port;
  UPTBLConnection.Password	:= UPTBConnection.Password;
  UPTBLConnection.Database 	:= UPTBConnection.Database;
  UPTBLConnection.Protocol	:= UPTBConnection.Protocol;

  UPTBConnection := nil;

  ULHost := UPTBLConnection.HostName;
  ULUser := UPTBLConnection.User;
  ULPort := UPTBLConnection.Port;
  ULPwd  := UPTBLConnection.Password;
  ULDb   := UPTBLConnection.Database;
  ULProt := UPTBLConnection.Protocol;

  UPTBLConnection.ClientCodepage := rsCharsetSetUp;
  SetUpEncryption(UPTBLConnection);

  try
  	UPTBLConnection.Connect;
  except
  	on e:Exception do begin
    	UPTBLConnection.Free;
	    Exit;
    end;
  end;

  LDataset := TZQuery.Create(nil);
  LDataset.Connection	:= UPTBLConnection;
  //tlc := 0;
  while not ExitIt do begin

		if PushToDBEvent.WaitFor(200) <> wrSignaled then continue;

    PushToDBCS.Enter;
    tlc := ToLog.Count;
    PushToDBCS.Leave;

		if (tlc = 0) then continue;

    if not Assigned(UPTBLConnection) then begin // if Connetion is not allocated for some reason
    	UPTBLConnection := TZConnection.Create(nil);

      UPTBLConnection.HostName := ULHost;
      UPTBLConnection.User		 := ULUser;
      UPTBLConnection.Port		 := ULPort;
      UPTBLConnection.Password := ULPwd;
      UPTBLConnection.Database := ULDb;
      UPTBLConnection.Protocol := ULProt;

      UPTBLConnection.ClientCodepage := rsCharsetSetUp;
      SetUpEncryption(UPTBLConnection);

      try
  	    UPTBLConnection.Connect;
      except
  	    on e:Exception do begin
        	UPTBLConnection.Free;
          Continue;
        end;
      end;
    end;

    if Assigned(UPTBLConnection) and ((not UPTBLConnection.Connected) or RCNeeded) then begin
{$IFDEF THREADSDBGOUTPUT}
      OutputDebugString('=== Reconnecting PushToDB thread''s connection ... ===');
{$ENDIF}
      try
		    SetUpEncryption(UPTBLConnection);
        UPTBLConnection.Reconnect
      except
  	    on e:Exception do begin
          Continue;
        end;
      end;
    end;

    RCNeeded := false;

    if not Assigned(LDataset) then begin
      LDataset := TZQuery.Create(nil);
      LDataset.Connection	:= UPTBLConnection;
    end;

    PushToDBCS.Enter;
    LogInfo := ToLog[0];
    LDataset.SQL.Text := 'INSERT INTO`log`(`sdt`,`code`,`type`,`data`,`src`,`cdt`)VALUES(NOW(),:fcode,:ftype,:fdata,:fsrc,:fcdt)';
    LDataset.ParamByName('fcode').AsInteger := LogInfo^.lcode;
    LDataset.ParamByName('ftype').AsInteger := LogInfo^.ltype;
    LDataset.ParamByName('fdata').AsString  := LogInfo^.ldata;
    LDataset.ParamByName('fsrc').AsString   := LogInfo^.lsrc;
    LDataset.ParamByName('fcdt').AsDateTime := LogInfo^.ldt;
    PushToDBCS.Leave;

		try
			LDataset.ExecSQL;
    except
    	on e: EZSQLException do begin
{$IFDEF THREADSDBGOUTPUT}
      	OutputDebugString(PWideChar(IntToStr(e.ErrorCode) + ': ' + e.StatusCode + ' ' + e.Message));
{$ENDIF}
        RCNeeded := (e.ErrorCode = 1053) or (e.ErrorCode = 2006);
        continue;
			end;
		end; // try

    PushToDBCS.Enter;
    ToLog.Delete(0);
    tlc := ToLog.Count;
    PushToDBCS.Leave;

    if tlc > 0 then PushToDBEvent.SetEvent; // we have to process the whole queue
  end; // while (not ExitIt) and (not Terminated)

  try
	  LDataset.Free;
	  UPTBLConnection.Free;
    ToLog.Free;
  finally

  end;

{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString('---- TPushToDBThread thread leaving');
{$ENDIF}
end;

end.
