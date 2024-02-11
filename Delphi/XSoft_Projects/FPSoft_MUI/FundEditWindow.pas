unit FundEditWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sCheckBox, sMemo, sLabel, sEdit, sComboBox, ExtCtrls, sPanel, AdvEdit, AdvMoneyEdit;

type
  TFundEditForm = class(TForm)
    TitleEdit: TsEdit;
    TitleLabel: TsLabel;
    DescrMemo: TsMemo;
    DescrLabel: TsLabel;
    IsFolderCB: TsCheckBox;
    OkButton: TsButton;
    CancelButton: TsButton;
    AssetCombo: TsComboBox;
    sPanel1: TsPanel;
    FP1MoneyLabel: TsLabel;
    FP1MoneyEdit: TAdvMoneyEdit;
    FP1PctLabel: TsLabel;
    FP1PctEdit: TAdvMoneyEdit;
    AssLabel: TsLabel;
    FndrCheckBox: TsCheckBox;
    procedure OkButtonClick(Sender: TObject);
    procedure TitleEditKeyPress(Sender: TObject; var Key: Char);
    procedure TitleEditContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure TitleEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure IsFolderCBClick(Sender: TObject);
    procedure TitleEditChange(Sender: TObject);
    procedure DescrMemoChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FndrCheckBoxClick(Sender: TObject);
    procedure AssetComboChange(Sender: TObject);
  private
    { Private declarations }
    AssList	 : TList;
    AssStr	 : string;
		CashStr	 : string;
		DisbCashStr	: string;
    Bill1Str : string;
    aoldindex	 : integer;
    procedure SetOkBtn;
    procedure PopulateAssetCombo;
  public
    { Public declarations }
    OrgPrefix	: string;
    Prefix		: string;
    isfund    : boolean;
    isFndr    : boolean;
    isObjFnd  : boolean;
    procedure SetupSize;
    procedure SetupAssetList;
    function GetAssListCount : integer;
    procedure SetupAsset(al:string);
  end;

//var
//  FundEditForm: TFundEditForm;

implementation

{$R *.dfm}

uses
  ClipBrd,
	GlobalVars;

procedure TFundEditForm.SetOkBtn;
begin
  if OkButton <> nil then begin
    OkButton.Enabled := (TitleEdit <> nil) and (TitleEdit.Text <> '') and
    ((AssetCombo.Visible and ((AssetCombo.Enabled and (AssetCombo.Items.Count > 0)) or (not AssetCombo.Enabled))) or (not AssetCombo.Visible));
  end;

end;

function TFundEditForm.GetAssListCount : integer;
begin
  Result := 0;
  if Assigned(AssList) then
    Result := AssList.Count;
end;

procedure TFundEditForm.SetupSize;
var
  c : integer;
  d : integer;
begin
  c := 2;
  if isfund then begin
    d := OkButton.Top - FndrCheckBox.Top;
    FndrCheckBox.Visible := false;
  end
  else begin
    FndrCheckBox.Visible := IsFndr;
    if IsFndr then begin
      d := FndrCheckBox.Top - AssLabel.Top;
      FndrCheckBox.Top := AssLabel.Top;
    end
    else begin
      d := OkButton.Top - AssLabel.Top;
    end;
  end;
  Height := Height - d + c;
end;

procedure TFundEditForm.IsFolderCBClick(Sender: TObject);
begin
  exit;
// 100!
//  it sohould be blocked only if the parent is subfolder
end;

procedure TFundEditForm.AssetComboChange(Sender: TObject);
begin
  if(AssetCombo.ItemIndex > 0) then begin
    isObjFnd := PVTResourceData(AssetCombo.Items.Objects[AssetCombo.ItemIndex]).fnd;
  end;
end;

procedure TFundEditForm.DescrMemoChange(Sender: TObject);
begin
  SetOkBtn;
end;

procedure TFundEditForm.SetupAssetList;
var
	i : integer;
begin
	AssStr      := OrgPrefix + 'asset';
	CashStr     := OrgPrefix + CASH_LINK;
	DisbCashStr := OrgPrefix + DISBCASH_LINK;
  Bill1Str    := OrgPrefix + BILL1_LINK;

  AssList   := CompFondList(AssStr, 0, CFL_WITHGROUPS, CFL_IGNOREPOS, OrgPrefix);
  PopulateAssetCombo;
end;

procedure TFundEditForm.SetupAsset(al:string);
var
	i : integer;
begin
  for i := 0 to AssetCombo.Items.Count - 1 do begin
    if PVTResourceData(AssetCombo.Items.Objects[i]).link = al then begin
    	AssetCombo.ItemIndex := i;
      break;
    end;
  end;
end;

procedure TFundEditForm.PopulateAssetCombo;
begin
  if isfund then begin
    FillComboWithEntities(TComboBox(AssetCombo), AssList, OrgPrefix, IsFndr);
  AssetComboChange(self);
  end;
  if(AssetCombo.Items.Count > 0) then
    aoldindex := 0
  else
    aoldindex := -1;

  SetOkBtn;
end;

procedure TFundEditForm.FndrCheckBoxClick(Sender: TObject);
begin
  if AssetCombo.Visible then PopulateAssetCombo;
end;

procedure TFundEditForm.FormCreate(Sender: TObject);
begin
  AssList := TList.Create;
end;

procedure TFundEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then begin
  	ModalResult := mrCancel;
  end;
end;

procedure TFundEditForm.OkButtonClick(Sender: TObject);
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  if (TitleEdit.Text <> '') then begin
    Self.ModalResult := mrOK;
    Self.CloseModal;
  end
  else begin
    MessageDlg('Все поля должны быть заполнены', mtError, [mbOK], 0);
  end;
end;

procedure TFundEditForm.TitleEditChange(Sender: TObject);
begin
  SetOkBtn;
end;

procedure TFundEditForm.TitleEditContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
 handled := true;
end;

procedure TFundEditForm.TitleEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(Clipboard) and ((((Char(Key) = 'V') or (Char(Key) = 'v')) and (ssCtrl in Shift)) or ((Key = VK_INSERT ) and (ssShift in Shift))) then
    Clipboard.Clear;
end;

procedure TFundEditForm.TitleEditKeyPress(Sender: TObject; var Key: Char);
begin
  if (Length(Prefix + Translitit(TitleEdit.Text)) >= 62) and (not (Ord(Key) in [VK_BACK, VK_CLEAR])) then
  	Key := #0; //Chr(0);
 	inherited;
end;

end.
