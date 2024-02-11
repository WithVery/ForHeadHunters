unit LoginNameCheckThread;

{$I DEFINES.INC}

interface

uses
  ZConnection,
  ZDataset,
//  Forms,
  Classes;

type
  TLoginNameCheckThread = class(TThread)
  public
    GLNCConnection  : TZConnection;
    GLNCLogin	      : string;
    GLNCPHandle     : Cardinal;
  private
    { Private declarations }
    LNCConnection	  : TZConnection;
    LNCDataset			: TZQuery;
  protected
    procedure Execute; override;
  end;

implementation

uses
  SysUtils,
  Windows,
	GlobalVars;
{ TLoginNameCheck }

procedure TLoginNameCheckThread.Execute;
begin
  { Place thread code here }
	LNCConnection := TZConnection.Create(nil);

  LNCConnection.HostName	:= GLNCConnection.HostName;
  LNCConnection.User			:= GLNCConnection.User;
  LNCConnection.Port			:= GLNCConnection.Port;
  LNCConnection.Password	:= GLNCConnection.Password;
  LNCConnection.Database  := GLNCConnection.Database;
  LNCConnection.Protocol	:= GLNCConnection.Protocol;

  GLNCConnection := nil;

  LNCConnection.ClientCodepage := rsCharsetSetUp;
  SetUpEncryption(LNCConnection);

  try
  	LNCConnection.Connect;
  except
  	on e: Exception do begin
  	  PostMessage(GLNCPHandle, UM_LOGINNAMECHECKFAILED, 0, 0);
	    Exit;
    end;
  end;

  if not Terminated then begin
		LNCDataset						:= TZQuery.Create(nil);
  	LNCDataset.Connection	:= LNCConnection;
  	LNCDataset.SQL.Text		:= 'SET CHARSET cp1251';

	  try
  		LNCDataset.ExecSQL;
	  except
  		on e: Exception do begin
  		  PostMessage(GLNCPHandle, UM_LOGINNAMECHECKFAILED, 0, 0);
	    	Exit;
	    end;
  	end;
  end;

  if not Terminated then begin
  	LNCDataset.SQL.Text := 'SELECT 1 FROM allusers WHERE login=:flogin LIMIT 1';
    LNCDataset.ParamByName('flogin').AsString := GLNCLogin;
  end;

  if not Terminated then begin
	  try
	  	LNCDataset.Open;
	  except
  		on e: Exception do begin
  		  PostMessage(GLNCPHandle, UM_LOGINNAMECHECKFAILED, 0, 0);
	    	Exit;
	    end;
  	end;
  end;

  if (not Terminated) and (LNCDataset.RecordCount = 0) then begin
	  PostMessage(GLNCPHandle, UM_LOGINNAMEOK, 0, 0);
  end
  else begin
	  PostMessage(GLNCPHandle, UM_LOGINNAMENOTOK, 0, 0);
  end;

  LNCDataset.Free;
	LNCConnection.Free;
end;

end.
