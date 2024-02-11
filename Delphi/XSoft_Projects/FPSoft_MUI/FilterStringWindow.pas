unit FilterStringWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, StdCtrls, sRadioButton, sCheckBox, sEdit, sLabel, sComboBox, sButton;

type
  TFilterStringForm = class(TForm)
    cmbOper: TsComboBox;
    lblVal: TsLabel;
    edtVal: TsEdit;
    pnl: TsPanel;
    btnApply: TsButton;
    btnDeactivate: TsButton;
    procedure btnDeactivateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    //function GetFilterResult : boolean;
    DeactivateIt : boolean;
  end;

implementation

{$R *.dfm}

procedure TFilterStringForm.btnDeactivateClick(Sender: TObject);
begin
 DeactivateIt := true;
 ModalResult  := mrOK;
end;

procedure TFilterStringForm.FormCreate(Sender: TObject);
begin
	DeactivateIt := false;
end;

procedure TFilterStringForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

end.
