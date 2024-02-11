unit IncSrcUpdateThread;

{$I DEFINES.INC}

interface

uses
  ZConnection,
  ZDataset,							// for TZQuery
  Windows, 							// for PostMessage
  Forms,								// for TForm
  SysUtils, 						// for Exception
  Classes;

type
  TIncSrcUpdateThread = class(TThread)
  public
    UConnection : TZConnection;
    PrntFrmHndl : cardinal;
    UIncSrcID		: integer;
    UOPrefix    : string;

  private
    { Private declarations }
    ULConnection	: TZConnection;
    ULDataset			: TZQuery;
    ULIncSrcID		: integer;

  protected
    procedure Execute; override;
  end;

implementation

uses
	GlobalVars;

{ IncSrcUpdateThread }

procedure TIncSrcUpdateThread.Execute;
begin
  ULIncSrcID := UIncSrcID;
  UIncSrcID	 := 0;

	ULConnection := TZConnection.Create(nil);

  ULConnection.HostName	:= UConnection.HostName;
  ULConnection.User			:= UConnection.User;
  ULConnection.Port			:= UConnection.Port;
  ULConnection.Password	:= UConnection.Password;
  ULConnection.Database := UConnection.Database;
  ULConnection.Protocol	:= UConnection.Protocol;

  UConnection := nil;

  ULConnection.ClientCodepage := rsCharsetSetUp;
  SetUpEncryption(ULConnection);

  try
  	ULConnection.Connect;
  except
  	on e:Exception do begin
    	ULConnection.Free;
	    Exit;
    end;
  end;

  if not Terminated then begin
		ULDataset							:= TZQuery.Create(nil);
  	ULDataset.Connection	:= ULConnection;
  end;

  if not Terminated then begin
  	ULDataset.SQL.Text := '(SELECT 1 FROM`' + UOPrefix + CASH_LINK + '`WHERE incsrcid=:fID LIMIT 1)UNION(SELECT 1 FROM`' + UOPrefix + BILL1_LINK + '`WHERE incsrcid=:fID LIMIT 1)';
    ULDataset.ParamByName('fID').AsInteger := ULIncSrcID;
  end;

  if not Terminated then begin
  	ULDataset.Open;
  end;


  if (not Terminated) and (ULDataset.RecordCount = 0) then begin
	  PostMessage(PrntFrmHndl, UM_OKTODELINCSRC, ISF_OKTODELETE, ULIncSrcID);
  end;

  ULDataset.Free;
	ULConnection.Free;
end;

end.
