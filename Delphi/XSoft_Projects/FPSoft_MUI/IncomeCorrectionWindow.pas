unit IncomeCorrectionWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sCheckBox, AdvEdit,
  AdvMoneyEdit, sLabel, Vcl.ExtCtrls, sPanel;

type
  TIncomeCorrectionForm = class(TForm)
    sPanel1: TsPanel;
    DescrLabel: TsLabel;
    PriceLabel: TsLabel;
    sLabel2: TsLabel;
    AmountLabel: TsLabel;
    AmountTotal: TAdvMoneyEdit;
    CancelButton: TButton;
    DescrMemo: TMemo;
    OKButton: TButton;
    PriceEdit: TAdvMoneyEdit;
    AmntEdit: TAdvMoneyEdit;
    procedure AmntEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IncomeCorrectionForm: TIncomeCorrectionForm;

implementation

{$R *.dfm}

procedure TIncomeCorrectionForm.AmntEditChange(Sender: TObject);
begin
	AmountTotal.Value := PriceEdit.Value * AmntEdit.Value;
  AmountTotal.Repaint;
  if(AmountTotal.Value >= 0) then begin
  	AmountTotal.Font.Color := clBlack
  end
  else begin
	  AmountTotal.Font.Color	:= clRed;
  end;

end;

end.
