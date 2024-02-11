unit PersonIncomeWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, sPanel, Vcl.StdCtrls,
  sRadioButton, sEdit, MoneyEdit, sComboBox, sButton, AdvEdit, AdvMoneyEdit,
  sCheckBox;

type
  TPersonIncomeForm = class(TForm)
    Label1: TLabel;
    PersonEdit: TsEdit;
    Label2: TLabel;
    SourceRadioBtn: TsRadioButton;
    OtherRadioBtn: TsRadioButton;
    OtherEdit: TsEdit;
    Label3: TLabel;
    OkButton: TsButton;
    CancelButton: TsButton;
    AmountEdit: TAdvMoneyEdit;
    SourcesCombo: TComboBox;
    PrintCheckBox: TsCheckBox;
    procedure SourceRadioBtnClick(Sender: TObject);
    procedure OtherRadioBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PersonIncomeForm: TPersonIncomeForm;

implementation

{$R *.dfm}

procedure TPersonIncomeForm.FormShow(Sender: TObject);
begin
  SourceRadioBtn.Checked := true;
end;

procedure TPersonIncomeForm.OkButtonClick(Sender: TObject);
begin
//
end;

procedure TPersonIncomeForm.OtherRadioBtnClick(Sender: TObject);
begin
  SourcesCombo.Enabled := false;
  OtherEdit.Enabled := true;
end;

procedure TPersonIncomeForm.SourceRadioBtnClick(Sender: TObject);
begin
  SourcesCombo.Enabled := true;
  OtherEdit.Enabled := false;
end;

end.
