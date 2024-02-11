unit DebtorEditWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, sButton, ExtCtrls, sPanel, sComboBox;

type
  TDebtorEditForm = class(TForm)
    DebtKindCombo: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CancelButton: TsButton;
    OKButton: TsButton;
    NameEdit: TsEdit;
    PhoneEdit: TsEdit;
    ContactPersonEdit: TsEdit;
    Label4: TLabel;
    sPanel1: TsPanel;
    DebtStatusCombo: TsComboBox;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure DebtKindComboChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CancelButtonClick(Sender: TObject);
    procedure DebtStatusComboChange(Sender: TObject);

  private
    { Private declarations }
    DefaultFormColor : TColor;

  public
    { Public declarations }
  end;

var
  DebtorEditForm: TDebtorEditForm;

implementation

{$R *.dfm}

uses GlobalVars;

procedure TDebtorEditForm.CancelButtonClick(Sender: TObject);
begin
//
  ModalResult := mrCancel;
end;

procedure TDebtorEditForm.DebtKindComboChange(Sender: TObject);
var
  ContrData : PContrData;
  iindex    : integer;
begin
  case TComboBox(Sender).ItemIndex of
    0 : begin OKButton.Caption := 'Добавить';
          NameEdit.Text := '';
          ContactPersonEdit.Text := '';
          PhoneEdit.Text := '';
          DebtStatusCombo.ItemIndex := 0;
    end
    else begin
      With DebtKindCombo do begin
        iindex := ItemIndex;
        OKButton.Caption := 'Сохранить';
        ContrData := PContrData(Items.Objects[ItemIndex]);
        NameEdit.Text := Items[iindex];
        ContactPersonEdit.Text := ContrData.Person;
        PhoneEdit.Text := ContrData.Phone;
        DebtStatusCombo.ItemIndex := ContrData.Status;
      end;
    end;
  end;
  DebtStatusComboChange(Sender);
end;

procedure TDebtorEditForm.DebtStatusComboChange(Sender: TObject);
begin
  case DebtStatusCombo.ItemIndex of
    0 : begin
      Self.Color := DefaultFormColor; // clBtnFace;
    end;
    1 : begin                                          //clRed;
      Self.Color := TColor($AAFFAA);
    end;
    2 : begin                                          //clRed;
      Self.Color := TColor($AAFFFF);
    end;
    3 : begin                                          //clRed;
      Self.Color := TColor($AAAAFF);
    end;
    else
      Self.Color := DefaultFormColor; // clBtnFace;
  end;
end;

procedure TDebtorEditForm.FormCreate(Sender: TObject);
begin
  DefaultFormColor := TForm(Sender).Color;
end;

procedure TDebtorEditForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin CancelButtonClick(Sender); Key := 0; end;
  end;
end;

procedure TDebtorEditForm.OKButtonClick(Sender: TObject);
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  if ((NameEdit.Text <> '') AND (ContactPersonEdit.Text <> '') AND (PhoneEdit.Text<>'')) then begin
    Self.ModalResult := mrOK;
    Self.CloseModal;
  end
  else begin
    MessageDlg('Все поля должны быть заполнены', mtError, [mbOK], 0);
  end;
end;

End.


