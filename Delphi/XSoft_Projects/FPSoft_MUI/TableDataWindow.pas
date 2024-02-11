unit TableDataWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, Spin, sLabel, ExtCtrls, sPanel;

type
  TTableDataForm = class(TForm)
    Panel: TsPanel;
    lblRows: TsLabel;
    lblColumns: TsLabel;
    spnRows: TSpinEdit;
    spnColumns: TSpinEdit;
    btnOk: TsButton;
    btnCancel: TsButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TableDataForm: TTableDataForm;

implementation

{$R *.dfm}

procedure TTableDataForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
	if Key = chr(VK_ESCAPE) then
    ModalResult := mrCancel;
end;

end.
