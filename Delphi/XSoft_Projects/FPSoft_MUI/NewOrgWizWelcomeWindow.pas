unit NewOrgWizWelcomeWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  Dialogs, StdCtrls, ComCtrls, sRichEdit, ExtCtrls, sPanel, sButton, sMemo,
  sEdit, sLabel;

type
  TNewOrgWizWelcomeForm = class(TForm)
    NextStepButton: TsButton;
    FinishButton: TsButton;
    CancelButton: TsButton;
    sPanel1: TsPanel;
    WelcomeMsg: TsMemo;
    OrgLabel: TsLabel;
    OrgNameEdit: TsEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CancelButtonClick(Sender: TObject);
    procedure FinishButtonClick(Sender: TObject);
    procedure NextStepButtonClick(Sender: TObject);
    procedure OrgNameEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure OKButtonEnable;
  public
    { Public declarations }
    FinishPressed : boolean;
  end;

//var
//  NewOrgWizWelcomeForm: TNewOrgWizWelcomeForm;

implementation

{$R *.dfm}

procedure TNewOrgWizWelcomeForm.OKButtonEnable;
begin
  NextStepButton.Enabled := ORgNameEdit.Text <> '';
  FinishButton.Enabled   := NextStepButton.Enabled;
end;


procedure TNewOrgWizWelcomeForm.FinishButtonClick(Sender: TObject);
begin
  FinishPressed := true;
  ModalResult   := mrOK;
end;

procedure TNewOrgWizWelcomeForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin ModalResult := mrCancel; Key := 0; end;
  end;
end;

procedure TNewOrgWizWelcomeForm.FormShow(Sender: TObject);
begin
 OKButtonEnable;
end;

procedure TNewOrgWizWelcomeForm.NextStepButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TNewOrgWizWelcomeForm.OrgNameEditChange(Sender: TObject);
begin
 OKButtonEnable;
end;

procedure TNewOrgWizWelcomeForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
