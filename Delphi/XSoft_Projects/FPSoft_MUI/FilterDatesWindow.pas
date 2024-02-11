unit FilterDatesWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, StdCtrls, sRadioButton, sCheckBox, sEdit, sLabel, sComboBox, sButton, Mask, sMaskEdit, sCustomComboEdit, sCurrEdit,
  sCurrencyEdit, sSpinEdit, sTooledit;

type
  TFilterDatesForm = class(TForm)
    cmbOper1: TsComboBox;
    lblOper1: TsLabel;
    slblVal1: TsLabel;
    ckbOper2: TsCheckBox;
    rbAND: TsRadioButton;
    rbOR: TsRadioButton;
    cmbOper2: TsComboBox;
    lblVal2: TsLabel;
    pnl: TsPanel;
    btnApply: TsButton;
    btnDeactivate: TsButton;
    deVal1: TsDateEdit;
    teVal1: TsTimePicker;
    deVal2: TsDateEdit;
    teVal2: TsTimePicker;
    procedure ckbOper2Click(Sender: TObject);
    procedure btnDeactivateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    //function GetFilterResult : boolean;
    DeactivateIt : boolean;
    procedure SecOpReset;
  end;

implementation

{$R *.dfm}

procedure TFilterDatesForm.SecOpReset;
begin
 rbAND.Enabled    := ckbOper2.Checked;
 rbOR.Enabled     := ckbOper2.Checked;
 cmbOper2.Enabled := ckbOper2.Checked;
 deVal2.Enabled   := ckbOper2.Checked;
 teVal2.Enabled   := ckbOper2.Checked;
 lblVal2.Enabled  := ckbOper2.Checked;
end;

procedure TFilterDatesForm.btnDeactivateClick(Sender: TObject);
begin
 DeactivateIt := true;
 ModalResult  := mrOK;
end;

procedure TFilterDatesForm.ckbOper2Click(Sender: TObject);
begin
	SecOpReset;
end;

procedure TFilterDatesForm.FormCreate(Sender: TObject);
begin
	DeactivateIt := false;
end;

procedure TFilterDatesForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

end.
