unit AssetTransferWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sLabel, Mask, sMaskEdit, sCustomComboEdit, sTooledit, sComboBox, sMemo, sButton, AdvEdit,
  AdvMoneyEdit, ExtCtrls, sPanel;

type
  TAssetTransferForm = class(TForm)
    AmountEdit: TAdvMoneyEdit;
    CancelButton: TsButton;
    OKButton: TsButton;
    DescrMemo: TsMemo;
    FromCombo: TsComboBox;
    sLabel3: TsLabel;
    sLabel2: TsLabel;
    ToCombo: TsComboBox;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    sPanel1: TsPanel;
    OrgCombo: TsComboBox;
    OrgLabel: TsLabel;
    FromAvailLabel: TsLabel;
    FromAvailMoneyEdit: TAdvMoneyEdit;
    procedure FormCreate(Sender: TObject);
    procedure FromComboChange(Sender: TObject);
    procedure ToComboChange(Sender: TObject);
    procedure AmountEditChange(Sender: TObject);
    procedure DescrMemoChange(Sender: TObject);
    procedure AmountEditExit(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure TypeComboChange(Sender: TObject);
    procedure OrgComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FromList    : TList;
    ToList      : TList;
    FromBalance : extended;
    ToBalance   : extended;
    Name        : string;
    Post        : string;
    FromFund    : string;
    FromAsset   : string;
    ToFund      : string;
    ToAsset     : string;
    CurOrgPost  : string;
    procedure OKButtonEnable;
    procedure FillDescrMemo;
  public
    { Public declarations }
    CurATPrefix  : string;
    OrgsList    : TList;
    ATWithFndr  : boolean;
    ParentHWND  : HWND;
    procedure ResetForm(Sender: TObject);
  end;

implementation

{$R *.dfm}

Uses
	ZDbcIntfs, // for EZSQLException
  GlobalVars;

procedure TAssetTransferForm.ResetForm(Sender: TObject);
var
	i: integer;
begin
  AmountEdit.Value	:= 0.00;
  FromComboChange(Sender);
  ToComboChange(Sender);
end;

procedure TAssetTransferForm.FillDescrMemo;
begin
  DescrMemo.Text := 'Перевод собственных средств.' + CRLF +
                    'Источник: '    + FromCombo.Items[FromCombo.ItemIndex] + '.' + CRLF +
                    'Назначение: '  + ToCombo.Items[ToCombo.ItemIndex] + '.' + CRLF +
                    'Подпись: '     + FPNameOfUser + ', ' + CurOrgPost + '.';
end;

procedure TAssetTransferForm.OKButtonClick(Sender: TObject);
var
  Sum             : extended;
  TransferReason  : string;
  i								: integer;
  NoError         : boolean;
  FromAssetName   : string;
  ToAssetName     : string;

begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

// NB. Since 1.2.4.55 only funds are transferred with this form. Assets are transferred automatically.
  Sum := AmountEdit.Value;
  // transaction initialization
	FPMainDataset.SQL.Text := 'BEGIN';
  try
  	FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
		  ShowError(Self, 'Невозможно заблокировать таблицу.', e.ErrorCode, e.StatusCode, e.Message);
			FPMainDataset.SQL.Text := 'ROLLBACK';
		  FPMainDataset.ExecSQL;
	    Exit;
    end;
  end;

  NoError := true;

  if FromAsset <> ToAsset then begin
  	FromAssetName := FromCombo.Items[FromCombo.ItemIndex];
  	ToAssetName   := ToCombo.Items[ToCombo.ItemIndex];
    NoError := AssetsTransfer(FromAsset, ToAsset, sum, 'Перевод средств с фонда "' + FromAssetName + '" в фонд "' + ToAssetName + '"' , CurATPrefix);
  end;

  if not NoError then begin
    FPMainDataset.SQL.Text := 'ROLLBACK';
    try
      FPMainDataset.ExecSQL;
    finally

    end;
    ModalResult := mrCancel;
    Exit;
  end;

  try
	  // updating FROM fund
  	// pulling last balance from the asset/fond table
	  FPMainDataset.SQL.Text := 'SELECT balance FROM`' + FromFund + '`WHERE`index`>1 ORDER BY`index`DESC LIMIT 1';
    FPMainDataset.Open;
    FromBalance := FPMainDataset.FieldByName('balance').AsExtended;

	  FromBalance := FromBalance - Sum;
  	for I := 0 to FromList.Count - 1 do begin
	  	if PVTResourceData(FromList.Items[i]).name = FromCombo.Items[FromCombo.ItemIndex] then begin
	  	  PVTResourceData(FromList.Items[i]).balance := FromBalance;
        break
		  end;
    end;

		FPMainDataset.SQL.Text := 'INSERT INTO`' + FromFund + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fReason,0,:fBalance,Now(),:fDescr,0,:fSum';
{$IFDEF USERID}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';

  	FPMainDataset.ParamByName('fReason').AsString  := 'transfer';
	  FPMainDataset.ParamByName('fBalance').AsFloat  := FromBalance;
  	FPMainDataset.ParamByName('fDescr').AsString   := DescrMemo.Text;
	  FPMainDataset.ParamByName('fSum').AsFloat      := Sum;
{$IFDEF USERID}
		FPMainDataset.ParamByName('fUserID').AsInteger := FPUserID;
{$ENDIF}
  	FPMainDataset.ExecSQL;
	  fond_update(FromFund, FromBalance);

    // updating TO asset
  	// pulling last balance from the asset/fond table
	  FPMainDataset.SQL.Text := 'SELECT balance FROM`' + ToFund + '`WHERE`index`>1 ORDER BY`index`DESC LIMIT 1';
    FPMainDataset.Open;
    ToBalance := FPMainDataset.FieldByName('balance').AsExtended;

	  ToBalance := ToBalance + Sum;
  	for I := 0 to ToList.Count - 1 do
	  	if PVTResourceData(ToList.Items[i]).name = ToCombo.Items[ToCombo.ItemIndex] then begin
  	  	PVTResourceData(ToList.Items[i]).balance := ToBalance;
		  end;

    TransferReason := 'transfer';
  	FPMainDataset.SQL.Text := 'INSERT INTO`' + ToFund + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fReason,0,:fBalance,Now(),:fDescr,:fSum,0';
{$IFDEF USERID}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
  	FPMainDataset.ParamByName('fReason').AsString  := TransferReason;
	  FPMainDataset.ParamByName('fBalance').AsFloat  := ToBalance;
  	FPMainDataset.ParamByName('fDescr').AsString   := DescrMemo.Text;
	  FPMainDataset.ParamByName('fSum').AsFloat      := Sum;
{$IFDEF USERID}
		FPMainDataset.ParamByName('fUserID').AsInteger 			:= FPUserID;
{$ENDIF}
  	FPMainDataset.ExecSQL;
	  fond_update(ToFund, ToBalance);

  except
   	on e: EZSQLException do begin
	    ShowError(Self, 'Во время обновления данных произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
			FPMainDataset.SQL.Text := 'ROLLBACK';
      FPMainDataset.ExecSQL;
      ModalResult := mrCancel;
      Exit;
 	  end;
  end; // try

  // commit transaction if everything is OK so far
	FPMainDataset.SQL.Text := 'COMMIT';
  FPMainDataset.ExecSQL;

//  ModalResult := mrOk;
  if (ParentHWND <> 0) then begin
    SendMessage(ParentHWND, UM_FUNDTRANSFERRED, 0, 0);
  end;

  if FromAsset <> ToAsset then begin
    MessageBox(self.Handle, PWideChar('ВНИМАНИЕ!' + CRLF + 'Вы перевели сумму ' + MyFloatToStr(sum) + ' актива "' + FromAssetName + '" на актив "' + ToAssetName +'"' + CRLF + 'Не забудьте ФАКТИЧЕСКИ осуществить перевод этих средств!'), 'Перевод средств', MB_ICONWARNING or MB_OK);
  end;

  ModalResult := mrOK;
//	ResetForm(Sender);
end;

procedure TAssetTransferForm.OKButtonEnable;
begin
  OKButton.Enabled  := (AmountEdit <> nil) and (DescrMemo <> nil) and (DescrMemo.Text <> '') and
    (AmountEdit.Text <> '') and (AmountEdit.Value>0) and ((round(FromBalance*100))>=(round(AmountEdit.Value*100))) and
    (FromCombo.ItemIndex <> ToCombo.ItemIndex);
end;

procedure TAssetTransferForm.OrgComboChange(Sender: TObject);
var
  OrgData : PVTResourceData;
//  DebData : PContrData;
  i       : integer;
  POData    : PPOData;
  CredData  : PContrData;
begin
  if OrgCombo.ItemIndex < 0 then
    Exit;

  OrgData := PVTResourceData(OrgsList[OrgCombo.ItemIndex]);
  CurATPrefix := OrgData.prefix;
  ATWithFndr  := PrivPresentMO(OrgData.descr, 'b0');

  FPMainDataset.SQL.Text := 'SELECT ' + OrgData.prefix + 'postsdir.Abbr FROM ' + OrgData.prefix + 'postsdir JOIN (' +
    'SELECT PostID,userid,FName,MName,FamilyName FROM ' + OrgData.prefix + 'psts JOIN' +
	  '(SELECT pstsid,userid,FirstName AS FName,MiddleName AS MName,FamilyName FROM ' + OrgData.prefix + 'pstsfills JOIN allusers ' +
	  'USING(UserID)WHERE allusers.login=:fLogin and (Now()>=startdate)AND((Now()<enddate)or(enddate is NULL)))AS tbl1 ' +
	  'ON tbl1.pstsid=' + OrgData.prefix + 'psts.id)AS tbl2 ON tbl2.PostID=' + OrgData.prefix + 'postsdir.ID';// LOCK IN SHARE MODE';
  FPMainDataset.ParamByName('fLogin').AsString := FPLogin;
  try
    FPMainDataset.Open;
    CurOrgPost := FPMainDataset.FieldByName('Abbr').AsString;
  except
    on e: EZSQLException do begin
		  ShowError(Self, 'Ошибка обращения к базе.', e.ErrorCode, e.StatusCode, e.Message);
    	ModalResult := mrCancel;
    end;
  end;

  TypeComboChange(Sender);
end;

procedure TAssetTransferForm.ToComboChange(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to ToList.Count - 1 do
    if PVTResourceData(ToList.Items[i]).name = ToCombo.Items[ToCombo.ItemIndex] then begin
      ToBalance := PVTResourceData(ToList.Items[i]).balance;
      ToFund    := PVTResourceData(ToList.Items[i]).link;
      ToAsset   := PVTResourceData(ToList.Items[i]).alink;
      break;
    end;
  OKButtonEnable;
  FillDescrMemo;
end;

procedure TAssetTransferForm.TypeComboChange(Sender: TObject);
var
	i	: integer;

begin
	//
  FromList.Clear;
  ToList.Clear;

  FromList := CompFondList(CurATPrefix + 'fond', 0, CFL_IGNOREGROUPS, CFL_CONSIDERPOS, CurATPrefix, true, true);

  ToList.Assign(FromList);

  FillComboWithEntities(TComboBox(FromCombo), FromList, CurATPrefix, ATWithFndr);
  FromComboChange(Sender);
  FillComboWithEntities(TComboBox(ToCombo), ToList, CurATPrefix, ATWithFndr);

	ResetForm(Sender);
end;

procedure TAssetTransferForm.AmountEditChange(Sender: TObject);
begin
  OKButtonEnable;
end;

procedure TAssetTransferForm.AmountEditExit(Sender: TObject);
begin
  if round(FromBalance * 100) < round(AMountEdit.Value * 100) then
    Application.MessageBox('Сумма свободных средств меньше запрашиваемой к переводу.', 'Проверьте правильность ввода данных', MB_OK or MB_ICONERROR);
end;

procedure TAssetTransferForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAssetTransferForm.DescrMemoChange(Sender: TObject);
begin
  OKButtonEnable;
end;

procedure TAssetTransferForm.FormCreate(Sender: TObject);
var
  i : integer;
begin
  ParentHWND := 0;
  OrgsList  := TList.Create;
  FromList   := TList.Create;
  ToList   := TList.Create;
end;

procedure TAssetTransferForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin ModalResult := mrCancel; Key := 0; end;
  end;
end;

procedure TAssetTransferForm.FormShow(Sender: TObject);
begin
	TypeComboChange(Sender);
  OrgComboChange(Sender);
end;

procedure TAssetTransferForm.FromComboChange(Sender: TObject);
var
  i : integer;
begin
  for I := 0 to FromList.Count - 1 do begin
    if PVTResourceData(FromList.Items[i]).name = FromCombo.Items[FromCombo.ItemIndex] then begin
      FromBalance := PVTResourceData(FromList.Items[i]).balance;
      FromFund    := PVTResourceData(FromList.Items[i]).link;
      FromAsset   := PVTResourceData(FromList.Items[i]).alink;
      FromAvailMoneyEdit.Value := FromBalance;
      break;
    end;
  end;
  OKButtonEnable;
  FillDescrMemo;
end;

end.
