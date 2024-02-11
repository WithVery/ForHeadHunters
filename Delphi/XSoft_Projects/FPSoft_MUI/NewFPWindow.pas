unit NewFPWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, Mask, sMaskEdit, sCustomComboEdit, sTooledit,
  sEdit, sSpinEdit, slabel, ExtCtrls, sPanel, sCheckBox;

type
  TNewFPForm = class(TForm)
    NumEdit: TEdit;
    StartDateEdit: TsDateEdit;
    EndDateEdit: TsDateEdit;
    Label2: TLabel;
    Label3: TLabel;
    OKButton: TsButton;
    CancleButton: TsButton;
    StartTimePicker: TsTimePicker;
    EndTimePicker: TsTimePicker;
    sLabel1: TsLabel;
    sPanel1: TsPanel;
    ckbCopyIncPlan: TsCheckBox;
    procedure OKButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewFPForm: TNewFPForm;

implementation

{$R *.dfm}

procedure TNewFPForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then begin
  	ModalResult := mrCancel;
    Key	:= 0;
  end
  else
  	inherited;
  OKButton.Enabled := int(StartDateEdit.Date) < int(EndDateEdit.Date);
end;

procedure TNewFPForm.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOk;
//  Close;
end;

end.
