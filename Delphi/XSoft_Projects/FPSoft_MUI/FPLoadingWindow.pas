unit FPLoadingWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ZConnection,
  GlobalVars,
  MainFPWin,
  Dialogs, sSkinManager, StdCtrls, sButton;

type
  TFPLoadingForm = class(TForm)
    procedure FormCreate(Sender: TObject);
//    procedure CreateParams(var Params: TCreateParams);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FPMainForm: TMainFPForm;

  protected
    procedure CreateParams(var Params: TCreateParams); override;

  public
    { Public declarations }
    Connection 	: TZConnection;
    UserID			: integer;

    function LoadFPForm(AParent: TWinControl; AConnection:TZConnection; AUserID: integer; AppHandle: THandle=0):boolean;
  end;

var
  FPLoadingForm: TFPLoadingForm;

implementation

{$R *.dfm}

uses
  TypeTrans,
  ZDataset;

procedure TFPLoadingForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle  := Params.ExStyle or WS_Ex_AppWindow;
//  Params.WndParent:= GetDesktopWindow;
  Params.WndParent:= 0;
end;

procedure TFPLoadingForm.FormCreate(Sender: TObject);
//var
//  ww : extended;
begin
//  LoadFPForm(self, Connection, 2); //1); //13);
end;

procedure TFPLoadingForm.FormShow(Sender: TObject);
begin

  LoadFPForm(self, Connection, UserID); //1); //13);
end;

function TFPLoadingForm.LoadFPForm(AParent: TWinControl; AConnection:TZConnection; AUserID: integer; AppHandle: THandle=0):boolean;
begin
  Result := false;
  if AppHandle <> 0 then begin  // if it's loaded from DLL
    Application.Handle := AppHandle;
  end;
  if AConnection = nil then
    Exit;

  FPMainForm := TMainFPForm.Create(AParent);
//  FPMainForm.Parent := AParent;
  FPMainForm.Parent := nil;
  if (AParent.Handle <> 0) then begin
    with FPMainForm do begin
      Connection    := AConnection;
      UserID  			:= AUserID;
      InitDB;
      Show;
    end;
  end;
end;

end.
