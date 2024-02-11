unit DebtingCreditingWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sMemo, sComboBoxes, sEdit, sLabel, Mask,
  sMaskEdit, sCustomComboEdit, sTooledit, sComboBox;

type
  TDebtingForm = class(TForm)
    Dt: TsDateEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    AmountEdit: TsEdit;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    DescrMemo: TsMemo;
    OKButton: TsButton;
    CancelButton: TsButton;
    DebCredCombo: TsComboBox;
    procedure DebCredComboDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DebtingForm: TDebtingForm;

implementation

{$R *.dfm}
uses GlobalVars;

procedure TDebtingForm.DebCredComboDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ContrData : PContrData;
begin
  with TsComboBox(Control) do begin
    ContrData := PContrData(Items.Objects[Index]);
    case ContrData.Status of
			1 : begin                                          //clRed;
				canvas.Font.Color := clGreen;
			end;
			2 : begin                                          //clRed;
				canvas.Font.Color := clOlive;
			end;
			3 : begin                                          //clRed;
				canvas.Font.Color := TColor($AAAAFF);
			end;
    end;
    if odSelected in State then begin
      Canvas.Brush.Color := clSilver;
      Canvas.FillRect(Rect);
    end;
    Canvas.TextOut(Rect.Left, Rect.Top, Items[index]);
  end;
end;

procedure TDebtingForm.OKButtonClick(Sender: TObject);
begin
  if ((AmountEdit.Text <> '') AND (DescrMemo.Text <> '')) then begin
    Self.ModalResult := mrOK;
    Self.CloseModal;
  end
  else
    MessageDlg('Все поля должны быть заполнены', mtError, [mbOK], 0);

end;

end.
