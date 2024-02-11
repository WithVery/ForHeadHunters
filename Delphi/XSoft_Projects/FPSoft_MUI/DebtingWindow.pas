unit DebtingWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sMemo, sComboBoxes, sEdit, sLabel, Mask,
  sMaskEdit, sCustomComboEdit, sTooledit, sComboBox, AdvEdit, AdvMoneyEdit, ExtCtrls, sPanel;

type
  TDebtingForm = class(TForm)
    Dt: TsDateEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    DescrMemo: TsMemo;
    OKButton: TsButton;
    CancelButton: TsButton;
    DebCredCombo: TsComboBox;
    AmountEdit: TAdvMoneyEdit;
    sPanel1: TsPanel;
    ShipDt: TsDateEdit;
    sLabel5: TsLabel;
    OrgCombo: TsComboBox;
    OrgLabel: TsLabel;
//    procedure DebCredComboDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure OKButtonClick(Sender: TObject);
    procedure AmountEditChange(Sender: TObject);
    procedure DebCredComboChange(Sender: TObject);
    procedure DescrMemoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure ShipDtChange(Sender: TObject);
    procedure DtChange(Sender: TObject);
    procedure ShipDtExit(Sender: TObject);
    procedure DtExit(Sender: TObject);
    procedure OrgComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    LocalFormatString	: TFormatSettings;
    procedure SetOKButton;
  public
    ShipDateOnly : boolean;
    CurOrgPrefix : string;
    FixOrgCombo  : boolean;
    OrgsList     : TList;
    DefOrg  : string;
  end;

const
  Heights : array [0..1] of integer = (306, 335);

implementation

{$R *.dfm}
uses GlobalVars;

procedure TDebtingForm.SetOKButton;
var
	TmpDate	: TDateTime;
begin
  if ShipDateOnly then
    OKButton.Enabled  := (TryStrToDate(ShipDt.Text, TmpDate, LocalFormatString)) and (ShipDt.Date <= DT.Date)
  else
    OKButton.Enabled := (AmountEdit<>nil) and (DebCredCombo<>nil) and (DescrMemo<>nil) and (ShipDt<> nil) and (Dt<>nil) and
    (AmountEdit.Value > 0) and (DebCredCombo.ItemIndex >= 0) and (DescrMemo.Text <> '') and
    (TryStrToDate(ShipDt.Text, TmpDate, LocalFormatString)) and (TryStrToDate(Dt.Text, TmpDate, LocalFormatString)) and
    (ShipDt.Date <= DT.Date);
end;

procedure TDebtingForm.ShipDtChange(Sender: TObject);
begin
	SetOKButton
end;

procedure TDebtingForm.ShipDtExit(Sender: TObject);
var
  TmpDate	: TDateTime;
begin
	TryStrToDate(ShipDt.Text, TmpDate, LocalFormatString);
  ShipDt.Date	:= round(TmpDate);
end;

procedure TDebtingForm.AmountEditChange(Sender: TObject);
begin
  SetOKButton;
end;

procedure TDebtingForm.DebCredComboChange(Sender: TObject);
begin
  SetOKButton;
end;

procedure TDebtingForm.DescrMemoKeyPress(Sender: TObject; var Key: Char);
begin
  SetOKButton;
end;

procedure TDebtingForm.DtChange(Sender: TObject);
begin
	SetOKButton
end;

procedure TDebtingForm.DtExit(Sender: TObject);
var
  TmpDate	: TDateTime;
begin
	TryStrToDate(Dt.Text, TmpDate, LocalFormatString);
  Dt.Date	:= round(TmpDate);
end;

procedure TDebtingForm.FormCreate(Sender: TObject);
begin
  OrgsList := TList.Create;
  OrgCombo.Clear;
  FixOrgCombo  := false;

  ShipDt.Date	:= now;
  Dt.Date 		:= now;
  AmountEdit.Text := '';
  DescrMemo.Clear;
  DebCredCombo.Clear;

  GetLocaleFormatSettings(0, LocalFormatString);
  ShipDateOnly := false;
	SetOKButton;
end;

procedure TDebtingForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TDebtingForm.FormShow(Sender: TObject);
var
  i : integer;
begin
  OrgComboChange(Sender);

  OrgCombo.Enabled := (OrgsList.Count > 1) and not FixOrgCombo;

  if DebCredCombo.Enabled and (DefOrg <> '') then begin
    i := DebCredCombo.IndexOf(DefOrg);
    if i >= 0 then
      DebCredCombo.ItemIndex := i;
  end;
end;

procedure TDebtingForm.OKButtonClick(Sender: TObject);
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  if ((AmountEdit.Text <> '') and (DescrMemo.Text <> '')) then begin
    Self.ModalResult := mrOK;
    Self.CloseModal;
  end
  else begin
    MessageDlg('Все поля должны быть заполнены', mtError, [mbOK], 0);
  end;
end;

procedure TDebtingForm.OrgComboChange(Sender: TObject);
var
  OrgData : PVTResourceData;
  DebData : PContrData;
begin
  if OrgCombo.ItemIndex < 0 then
    Exit;

  OrgData := PVTResourceData(OrgsList[OrgCombo.ItemIndex]);
  CurOrgPrefix := OrgData.prefix;

  DebCredCombo.Clear;

  FPMainDataset.SQL.Text := 'SELECT`index`,`name`,`status`FROM '+ CurOrgPrefix + 'debtor WHERE`status`<"3"ORDER BY`name`';
  FPMainDataset.Open;
  if FPMainDataset.RecordCount > 0 then begin
    while not FPMainDataset.Eof do begin
      New(DebData);
      DebData.index  := FPMainDataset.FieldByName('index').AsInteger;
      DebData.Status := FPMainDataset.FieldByName('status').AsInteger;
      DebCredCombo.AddItem(FPMainDataset.FieldByName('name').AsString, TObject(DebData));
      FPMainDataset.Next;
    end;
    DebCredCombo.ItemIndex := 0;
  end;
end;

end.
