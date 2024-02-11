unit CreditingWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sComboBox, sButton, sMemo, sEdit, Mask, sMaskEdit, sCustomComboEdit, sTooledit, sLabel, sGroupBox,
  sRadioButton, AdvEdit, AdvMoneyEdit, ExtCtrls, sPanel;

type
  TCreditingForm = class(TForm)
    DtLabel: TsLabel;
    AmountLabel: TsLabel;
    CredLabel: TsLabel;
    DescrLabel: TsLabel;
    Dt: TsDateEdit;
    DescrMemo: TsMemo;
    OKButton: TsButton;
    CancelButton: TsButton;
    CredCombo: TsComboBox;
    CommodityRadio: TsRadioButton;
    MoneyRadio: TsRadioButton;
    TypeCreditGroup: TsGroupBox;
    AmountEdit: TAdvMoneyEdit;
    MoneyGroupBox: TsGroupBox;
    sLabel6: TsLabel;
    FundCombo: TsComboBox;
    sPanel1: TsPanel;
    RecDTEdit: TsDateEdit;
    RecDtLabel: TsLabel;
    OrgLabel: TsLabel;
    OrgCombo: TsComboBox;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CommodityRadioClick(Sender: TObject);
    procedure MoneyRadioClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AssComboChange(Sender: TObject);
    procedure FundComboChange(Sender: TObject);
    procedure RecDTEditExit(Sender: TObject);
    procedure DtExit(Sender: TObject);
    procedure RecDTEditChange(Sender: TObject);
    procedure DtChange(Sender: TObject);
    procedure OrgComboChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    HeightCommodity   : integer;
    HeightMoney       : integer;
    FundList          : TList;
    LocalFormatString	: TFormatSettings;
    istep             : integer;
    imonpos, icompos  : integer;
    procedure OKBtnEnable;
  public
    { Public declarations }
    CurOCPrefix : string;
    OrgsList : TList;
    FixOrgCombo : boolean;
    DefCred     : string;   // default creditor
    procedure InitForm;
  end;

implementation

{$R *.dfm}

Uses
  StrUtils,
	ZDbcIntfs, // for EZSQLException
  GlobalVars;

procedure TCreditingForm.OKBtnEnable;
var
	TmpDate	: TDateTime;
begin
  OKButton.Enabled  := (AmountEdit <> nil) and (DescrMemo <> nil) and (DescrMemo.Text <> '') and
    (AmountEdit.Text <> '') and (RecDTEdit<> nil) and (Dt<>nil) and (AmountEdit.Value <> 0) and (CredCombo.ItemIndex >= 0) and
    ((MoneyRadio.Checked and (FundCombo.ItemIndex >= 0)) or (CommodityRadio.Checked)) and
    (TryStrToDate(RecDTEdit.Text, TmpDate, LocalFormatString)) and (TryStrToDate(Dt.Text, TmpDate, LocalFormatString)) and
    (RecDTEdit.Date <= DT.Date);
end;

procedure TCreditingForm.OKButtonClick(Sender: TObject);
var
  TmpStr1   : string;
  TmpStr2   : string;
  TmpStr    : string;
  TmpStrA   : string;
  Bal       : extended;
  Sum       : extended;
  BalF      : extended;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  if FixOrgCombo then begin
	  if ((AmountEdit.Text <> '') and (DescrMemo.Text <> '')) then begin
  	  Self.ModalResult := mrOK;
    	Self.CloseModal;
	  end
  	else begin
    	MessageDlg('Все поля должны быть заполнены', mtError, [mbOK], 0);
	  end;
    Exit;
  end;


  // Starting transaction
	FPMainDataset.SQL.Text := 'START TRANSACTION';
  try
  	FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
		  ShowError(Self, 'Невозможно заблокировать таблицу. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
			FPMainDataset.SQL.Text := 'ROLLBACK';
		  FPMainDataset.ExecSQL;
	    Exit;
    end;
  end;

// main transaction
  try
	  Sum := AmountEdit.Value;
  	FPMainDataset.SQL.Text :='INSERT INTO ' + CurOCPrefix + 'topay(`index`,`creditor`,`status`,`data`,`date`,`shipdate`,`paydate`,`summ`,`closed`,`lastdate`,`UserID`)VALUES(NULL,:fCredID,"0",:fDescr,:fDate,:fRecDate,:fPaydate,:fSum,0,Null,:fUserID)';
	  FPMainDataset.ParamByName('fCredID').AsInteger := PContrData(CredCombo.Items.Objects[CredCombo.ItemIndex]).Index;
  	FPMainDataset.ParamByName('fDescr').AsString   := DescrMemo.Text;
	  FPMainDataset.ParamByName('fDate').AsDate      := now;
  	FPMainDataset.ParamByName('fRecDate').AsDate   := RecDTEdit.Date;
	  FPMainDataset.ParamByName('fPayDate').AsDate   := DT.Date;
  	FPMainDataset.ParamByName('fSum').AsFloat      := Sum;
  	FPMainDataset.ParamByName('fUserID').AsFloat   := FPUserID;
	  FPMainDataset.ExecSQL;

  	if MoneyRadio.Checked then begin
    	TmpStr1 := '';

    	TmpStr1 := PVTResourceData(FundList.Items[FundCombo.ItemIndex]).link;

	    FPMainDataset.SQL.Text  := 'SELECT link FROM`'+ TmpStr1 + '`ORDER by`index`LIMIT 1';
  	  FPMainDataset.Open;
	    TmpStr := FPMainDataset.FieldByName('link').AsString; // fund

  	  FPMainDataset.SQL.Text  := 'SELECT name FROM`'+ TmpStr + '`WHERE`link`=:fLink';
    	FPMainDataset.ParamByName('fLink').AsString := TmpStr1;
	    FPMainDataset.Open;
    	TmpStr2 := FPMainDataset.FieldByName('name').AsString;

    	TmpStrA := PVTResourceData(FundList.Items[FundCombo.ItemIndex]).alink;

	    FPMainDataset.SQL.Text  := 'SELECT balance FROM`'+ TmpStrA + '`WHERE`index`>1 ORDER by`index`DESC LIMIT 1';
  	  FPMainDataset.Open;
	    Bal := FPMainDataset.FieldByName('balance').AsFloat + Sum;

      if (TmpStrA = CurOCPrefix + CASH_LINK) or (TmpStrA = CurOCPrefix + BILL1_LINK) then begin
				FPMainDataset.SQL.Text  := 'INSERT INTO `'+ TmpStrA + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`amount`,`price`,`data`,`in`,`out`,`incsrcid`,`pct`';
{$IFDEF USERID}
				FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
    		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
		    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fType,0,:fBal,Now(),0,0,:fDescr,:fSum,0,0,0';
{$IFDEF USERID}
		    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
		    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      end
      else begin
				FPMainDataset.SQL.Text  := 'INSERT INTO `'+ TmpStrA + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
				FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
    		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
		    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fType,0,:fBal,Now(),:fDescr,:fSum,0';
{$IFDEF USERID}
		    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
		    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      end;

  	  FPMainDataset.ParamByName('fType').AsString  	:= TmpStrA;
    	FPMainDataset.ParamByName('fBal').AsFloat     := Bal;
	    FPMainDataset.ParamByName('fDescr').AsString  := ReplaceStr('Кредит: ' + DescrMemo.Text + Chr(13) + 'Внесено на фонд: ' + TmpStr2, Chr(13), '<br>');
  	  FPMainDataset.ParamByName('fSum').AsFloat     := AmountEdit.Value;
{$IFDEF USERID}
			FPMainDataset.ParamByName('fUserID').AsInteger:= FPUserID;
{$ENDIF}
      FPMainDataset.ExecSQL;

	    Fond_Update(TmpStrA, Bal);

  	  FPMainDataset.SQL.Text  :=  'SELECT balance FROM`'+ TmpStr1 + '`WHERE`index`>1 ORDER by`index`DESC LIMIT 1';
    	FPMainDataset.Open;
  	  if not FPMainDataset.Eof then
    	  BalF := FPMainDataset.FieldByName('balance').AsFloat + Sum
	    else
  	    BalF := Sum;

    	FPMainDataset.SQL.Text := 'INSERT INTO`'+ TmpStr1 + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
			FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
   		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,"credit",0,:fBalF,Now(),:fDescr,:fSum,0';
{$IFDEF USERID}
	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
	    FPMainDataset.ParamByName('fBalF').AsFloat    := BalF;
  	  FPMainDataset.ParamByName('fDescr').AsString  := 'Кредит: ' + DescrMemo.Text;
    	FPMainDataset.ParamByName('fSum').AsFloat     := Sum;
{$IFDEF USERID}
			FPMainDataset.ParamByName('fUserID').AsInteger:= FPUserID;
{$ENDIF}
     	FPMainDataset.ExecSQL;

  	  Fond_Update(TmpStr1, BalF);
  	end; // if MoneyRadio.Checked then begin

  except // catching up exception
   	on e: EZSQLException do begin
	    ShowError(Self, 'Во время обновления данных произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
			FPMainDataset.SQL.Text := 'ROLLBACK';
      FPMainDataset.ExecSQL;
      ModalResult := mrCancel;
      Exit;
 	  end;
  end; // try

  // commit transaction if everything is OK so far
	FPMainDataset.SQL.Text := 'COMMIT';
  try
    FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
      ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
			FPMainDataset.SQL.Text := 'ROLLBACK';
      try
        FPMainDataset.ExecSQL;
      finally

      end;
    end;
  end;

  ModalResult := mrOk;
end;

procedure TCreditingForm.OrgComboChange(Sender: TObject);
var
  OrgData : PVTResourceData;
begin
  if OrgCombo.ItemIndex < 0 then
    Exit;

  OrgData := PVTResourceData(OrgsList[OrgCombo.ItemIndex]);
  CurOCPrefix := OrgData.prefix;

  InitForm;
end;

procedure TCreditingForm.RecDTEditChange(Sender: TObject);
begin
  OKBtnEnable;
end;

procedure TCreditingForm.RecDTEditExit(Sender: TObject);
var
  TmpDate	: TDateTime;
begin
	TryStrToDate(RecDtEdit.Text, TmpDate, LocalFormatString);
  RecDtEdit.Date	:= round(TmpDate);
end;

procedure TCreditingForm.AssComboChange(Sender: TObject);
begin
  OKBtnEnable;
end;

procedure TCreditingForm.CommodityRadioClick(Sender: TObject);
begin
  MoneyGroupBox.Visible := false;
  Height                := HeightCommodity;
  DescrLabel.Top := icompos;
  DescrMemo.Top  := DescrLabel.Top + DescrLabel.Height + istep;
  OKBtnEnable;
end;

procedure TCreditingForm.DtChange(Sender: TObject);
begin
  OKBtnEnable;
end;

procedure TCreditingForm.DtExit(Sender: TObject);
var
  TmpDate	: TDateTime;
begin
	TryStrToDate(Dt.Text, TmpDate, LocalFormatString);
  Dt.Date	:= round(TmpDate);
end;

procedure TCreditingForm.FormCreate(Sender: TObject);
var
  i, j : integer;
begin
  GetLocaleFormatSettings(0, LocalFormatString);

  istep := 3;

  MoneyGroupBox.Top := TypeCreditGroup.Top + TypeCreditGroup.Height + istep;

  icompos := MoneyGroupBox.Top;

  DescrLabel.Top := MoneyGroupBox.Top + MoneyGroupBox.Height + istep;
  DescrMemo.Top  := DescrLabel.Top + DescrLabel.Height + istep;
  imonpos := DescrLabel.Top;

  j := OKButton.Top + OKButton.Height;
  i := Self.Height - (ClientRect.Bottom - ClientRect.Top) + (ClientRect.Bottom - j);

  HeightCommodity := DescrMemo.Top + DescrMemo.Height + istep + OKButton.Height + i + (ClientRect.Bottom - j);
  HeightMoney     := DescrMemo.Top + DescrMemo.Height + istep + OKButton.Height + i + (ClientRect.Bottom - j);
  HeightCommodity := HeightMoney - (MoneyGroupBox.Height + istep);

  OrgsList := TList.Create;
  OrgCombo.Clear;

  MoneyGroupBox.Visible := false;
  Height := HeightCommodity;

  Dt.Date := now;
  DescrMemo.Clear;

end;

procedure TCreditingForm.FormDestroy(Sender: TObject);
begin
  FundList.Free;
end;

procedure TCreditingForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TCreditingForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  OKBtnEnable;
end;

procedure TCreditingForm.FormShow(Sender: TObject);
var
	i : integer;
begin
  OrgComboChange(Sender);
  OrgCombo.Enabled := (OrgsList.Count > 1) and not FixOrgCombo;

  if CredCombo.Enabled and (DefCred <> '') then begin
    i := CredCombo.IndexOf(DefCred);
    if (i >= 0) then
      CredCombo.ItemIndex := i;
  end;

  if FixOrgCombo then
    Height := Height - 49;

end;

procedure TCreditingForm.FundComboChange(Sender: TObject);
begin
  OKBtnEnable;
end;

procedure TCreditingForm.MoneyRadioClick(Sender: TObject);
begin
  MoneyGroupBox.Visible := true;
  Height                := HeightMoney;
  DescrLabel.Top := imonpos;
  DescrMemo.Top  := DescrLabel.Top + DescrLabel.Height + istep;
  OKBtnEnable;
end;

procedure TCreditingForm.InitForm;
var
  CredData  : PContrData;
  i         : integer;
begin

  CredCombo.Clear;

  FPMainDataset.SQL.Text := 'SELECT`index`,`name`,`status`FROM`' + CurOCPrefix + 'creditor`ORDER BY`name`';
  FPMainDataset.Open;
  if FPMainDataset.RecordCount > 0 then begin
    while not FPMainDataset.Eof do begin
      New(CredData);
      CredData.index  := FPMainDataset.FieldByName('index').AsInteger;
      CredData.Status := FPMainDataset.FieldByName('status').AsInteger;
      CredCombo.AddItem(FPMainDataset.FieldByName('name').AsString, TObject(CredData));
      FPMainDataset.Next;
    end;
    CredCombo.ItemIndex := 0;
  end;

  CommodityRadio.Checked := true;

  FundList  := TList.Create;
  FundList  := CompFondList(CurOCPrefix + 'fond', 0, CFL_WITHGROUPS, CFL_IGNOREPOS, CurOCPrefix, true);

  // filter out funds without assets
  i := 0;
  while i < FundList.Count do begin
    if(PVTResourceData(FundList.Items[i]).sub = 1) or (PVTResourceData(FundList.Items[i]).alink = '') then
    	FundList.Delete(i)
    else
    	Inc(i);
  end;

  FundCombo.Clear;
  for i := 0 to FundList.Count - 1 do begin
    FundCombo.Items.Add(PVTResourceData(FundList[i]).name);
  end;

  FundCombo.Enabled := FundCombo.Items.Count > 0;

  OKBtnEnable;
end;

end.
