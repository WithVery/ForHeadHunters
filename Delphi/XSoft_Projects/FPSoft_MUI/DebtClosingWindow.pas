unit DebtClosingWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, sButton, sMemo, AdvEdit, AdvMoneyEdit, Mask, sMaskEdit, sCustomComboEdit, sTooledit,
  ExtCtrls, sPanel;

type
  TDebtClosingForm = class(TForm)
    DebtorLabel: TLabel;
    TitleEdit: TsEdit;
    Label1: TLabel;
    Label2: TLabel;
    ReasonMemo: TsMemo;
    OKButton: TsButton;
    CancelButton: TsButton;
    Label3: TLabel;
    ShipDTEdit: TsDateEdit;
    AmountEdit: TAdvMoneyEdit;
    Label4: TLabel;
    DescrEdit: TsEdit;
    sPanel1: TsPanel;
    Label5: TLabel;
    DTEdit: TsDateEdit;
    procedure ReasonMemoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DebtClosingForm: TDebtClosingForm;

implementation

{$R *.dfm}

procedure TDebtClosingForm.ReasonMemoChange(Sender: TObject);
begin
  OKButton.Enabled := ReasonMemo.Text <> '';
end;

end.
