unit FPUnsavedExitWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sLabel, ExtCtrls, sPanel;

type
  TFPUnsavedExitForm = class(TForm)
    sPanel1: TsPanel;
    sLabel1: TsLabel;
    btnSaveAndClose: TsButton;
    btnClose: TsButton;
    btnCancel: TsButton;
    procedure btnSaveAndCloseClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    SaveIt : boolean;
  end;

var
  FPUnsavedExitForm: TFPUnsavedExitForm;

implementation

{$R *.dfm}

procedure TFPUnsavedExitForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFPUnsavedExitForm.btnCloseClick(Sender: TObject);
begin
	SaveIt := false;
  ModalResult := mrOK;
end;

procedure TFPUnsavedExitForm.btnSaveAndCloseClick(Sender: TObject);
begin
	SaveIt := true;
  ModalResult := mrOK;
end;

procedure TFPUnsavedExitForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then ModalResult := mrCancel;
end;

end.
