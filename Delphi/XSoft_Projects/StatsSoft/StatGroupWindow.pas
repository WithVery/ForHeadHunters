unit StatGroupWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sComboBox, sLabel, ExtCtrls, sPanel, DKLang;

type
  TStatGroupForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    FullDescrMemo: TMemo;
    DescrEdit: TEdit;
    OKButton: TsButton;
    CancelButton: TsButton;
    OrgLabel: TsLabel;
    OrgCombo: TsComboBox;
    sPanel1: TsPanel;
    lc: TDKLanguageController;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StatGroupForm: TStatGroupForm;

implementation

{$R *.dfm}

procedure TStatGroupForm.FormCreate(Sender: TObject);
begin
//  OKButton.Enabled := DescrEdit.Text <> '';
end;

procedure TStatGroupForm.FormDestroy(Sender: TObject);
begin
  OKButton.Enabled := DescrEdit.Text <> '';
end;

procedure TStatGroupForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  OKButton.Enabled := DescrEdit.Text <> '';
  if Key = VK_ESCAPE then
    Self.ModalResult := mrCancel;
end;

procedure TStatGroupForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  OKButton.Enabled := DescrEdit.Text <> '';
end;

procedure TStatGroupForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  OKButton.Enabled := DescrEdit.Text <> '';
end;

end.
