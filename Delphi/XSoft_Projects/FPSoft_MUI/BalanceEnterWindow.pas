unit BalanceEnterWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sEdit, sLabel, AdvEdit, AdvMoneyEdit, ExtCtrls, sPanel;

type
  TBalanceEnterForm = class(TForm)
    sLabel1: TsLabel;
    OKButton: TsButton;
    CancelButton: TsButton;
    MoneyEdit: TAdvMoneyEdit;
    sPanel1: TsPanel;
    procedure OKButtonClick(Sender: TObject);
    procedure MoneyEditChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    Procedure OKBtnEnable;

  public
    { Public declarations }
  end;

var
  BalanceEnterForm: TBalanceEnterForm;

implementation

{$R *.dfm}

procedure TBalanceEnterForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then begin
  	ModalResult := mrCancel;
  end;
end;

procedure TBalanceEnterForm.MoneyEditChange(Sender: TObject);
begin
  OKBtnEnable;
end;

procedure TBalanceEnterForm.OKBtnEnable;
begin
  OKButton.Enabled := (MoneyEdit.Value <> 0);
end;

procedure TBalanceEnterForm.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
