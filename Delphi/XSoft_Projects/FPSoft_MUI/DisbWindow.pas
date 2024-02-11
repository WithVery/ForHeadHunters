unit DisbWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars, // for PPOData definition
  Dialogs, Mask, sMaskEdit, sCustomComboEdit, sTooledit, StdCtrls, sComboBox, sMemo, sButton,
  AdvObj,
  AdvEdit, AdvMoneyEdit,
  sLabel, sGroupBox, sEdit, ExtCtrls, sPanel, sCheckBox, VirtualTrees;

type
  TDisbForm = class(TForm)
    sLabel3: TsLabel;
    AmountLabel: TsLabel;
    DtLabel: TsLabel;
    FPLabel: TsLabel;
    AmountEdit: TAdvMoneyEdit;
    CancelButton: TsButton;
    OKButton: TsButton;
    DescrMemo: TsMemo;
    POCombo: TsComboBox;
    Dt: TsDateEdit;
    POGroupBox: TsGroupBox;
    ApprSumEdit: TsEdit;
    FondLabel: TsLabel;
    TypeCombo: TsComboBox;
    TypeLabel: TsLabel;
    AssCombo: TsComboBox;
    AssLabel: TsLabel;
    CreditorLabel: TsLabel;
    sPanel1: TsPanel;
    ArrearsTree: TVirtualStringTree;
    ArrearsLabel: TLabel;
    RestMoneyLabel: TsLabel;
    RestMoneyEdit: TAdvMoneyEdit;
    AutoCloseCheckBox: TsCheckBox;
    OrgCombo: TsComboBox;
    OrgLabel: TsLabel;
    ByCashCB: TsCheckBox;
    CreditorCombo: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure POComboChange(Sender: TObject);
    procedure TypeComboChange(Sender: TObject);
    procedure CreditorCombo1Change(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure AmountEditChange(Sender: TObject);
    procedure ArrearsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure ArrearsTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ArrearsTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure AutoCloseCheckBoxClick(Sender: TObject);
    procedure OrgComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ByCashCBClick(Sender: TObject);
    procedure CreditorComboChange(Sender: TObject);
    procedure CreditorComboKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FondList  			: TList;
    AssList   			: TList;
    TypeList  			: TList;
    HeightCollapsed : integer;
    HeightExpanded  : integer;
		CurPONum        : integer;
    CurPOData       : PPOData;
//    CreditorIsValid : boolean;
    procedure OKButtonEnable;
    function AnyItemChecked : boolean;
    function CreditorIsValid : boolean;
    procedure FixControlStates(AI : integer);
  public
    { Public declarations }
    CurDPrefix : string;
    OrgsList   : TList;
    procedure InitForm(Sender: TObject);
  end;

//var
//  DisbForm: TDisbForm;

implementation

{$R *.dfm}

Uses
	ZDbcIntfs;//, // for EZSQLException

function TDisbForm.AnyItemChecked : boolean;
var
	Node : PVirtualNode;
begin
	if AutoCloseCheckBox.Checked then begin
		Result := true;
    Exit;
  end
  else
		Result := false;
	Node	:= ArrearsTree.GetFirstChild(nil);
  while Node <> nil do begin
  	if Node.CheckState = csCheckedNormal then begin
    	Result := true;
      break;
    end;
    Node := ArrearsTree.GetNextSibling(Node);
  end;
end;

function TDisbForm.CreditorIsValid : boolean;
begin
 Result := (CreditorCombo.ItemIndex <> -1) and (CreditorCombo.Text = CreditorCombo.Items[CreditorCombo.ItemIndex]);
end;

procedure TDisbForm.InitForm(Sender: TObject);
const
  vstep : integer = 4;

var
  i,j     : integer;
begin
	AmountEdit.Value := 0;
  DT.Date := now;

  j := OKButton.Top + OKButton.Height;
  i := Self.Height - (ClientRect.Bottom - ClientRect.Top) + (ClientRect.Bottom - j);
  HeightCollapsed := POGroupBox.Top + TypeLabel.Top + TypeLabel.Height + (3 * vstep) + OKButton.Height + i + (ClientRect.Bottom - j);
  HeightExpanded := POGroupBox.Top + AutoCloseCheckBox.Top + AutoCloseCheckBox.Height + 2*vstep + OKButton.Height + i + (ClientRect.Bottom - j);


  Self.Height := HeightCollapsed;
  Height 		:= HeightCollapsed;
  ApprSumEdit.Font.Color := clRed;

  // "Type of an operation" list - filling
  TypeList  := CompFondList('outopertype', 0, CFL_WITHGROUPS, CFL_IGNOREPOS, CurDPrefix);
  TypeCombo.Clear;
  for i := 0 to TypeList.Count - 1 do begin
    if PVTResourceData(TypeList[i]).link <> 'debitors' then // skiping the Займ line
	    TypeCombo.AddItem(PVTResourceData(TypeList[i]).name, TypeList[i]);
  end;
  TypeCombo.ItemIndex := 0;
  TypeComboChange(Sender);

  OrgComboChange(Sender);

  OKButtonEnable;
end;

procedure TDisbForm.OKButtonEnable;
var
  OKEnabled : boolean;
	ApprSum		: extended;
begin
	try
  	OKEnabled  := (not (AmountEdit.Value<0)) and (TryStrToFloat(MyCleanStr(ApprSumEdit.Text), ApprSum)) and
    	(ApprSum >= AmountEdit.Value) and
    	(DescrMemo.Text <> '') and
  	  (
    	  ((TypeCombo.ItemIndex = 2) and (CreditorIsValid) and AnyItemChecked) or ((TypeCombo.ItemIndex <> 2))

	    );
  finally
	  OKButton.Enabled := OKEnabled;
  end;

end;

procedure TDisbForm.FixControlStates(Ai : integer);
begin
  POCombo.Enabled           := Ai > 0;
  TypeCombo.Enabled         := Ai > 0;
  AmountEdit.Enabled        := Ai > 0;

  CreditorCombo.Enabled     := Ai > 0;
  AssCombo.Enabled          := Ai > 0;
  ArrearsTree.Enabled       := Ai > 0;
  AutoCloseCheckBox.Enabled := Ai > 0;
  OKButton.Enabled          := Ai > 0;
  if Ai = 0 then begin
	  Application.MessageBox('В этой организации нет неоплаченных заявок', 'Списание средств', MB_ICONINFORMATION or MB_OK);
  end;
end;


procedure TDisbForm.OrgComboChange(Sender: TObject);
var
  OrgData : PVTResourceData;
  i       : integer;
  j       : integer;
  POData    : PPOData;
  CredData  : PContrData;
begin
  if OrgCombo.ItemIndex < 0 then
    Exit;

  OrgData := PVTResourceData(OrgsList[OrgCombo.ItemIndex]);
  CurDPrefix := OrgData.prefix;

// clearing everything possible
  ApprSumEdit.Text  := '';
  AmountEdit.Clear;
  CreditorCombo.Clear;
  ArrearsTree.Clear;
  AssCombo.Clear;
  RestMoneyEdit.Clear;
  FondList.Clear;

  FondList  := CompFondList(CurDPrefix + 'fond',  0, CFL_WITHGROUPS, CFL_CONSIDERPOS, CurDPrefix, true);
  AssList   := CompFondList(CurDPrefix + 'asset', 0, CFL_WITHGROUPS, CFL_IGNOREPOS, CurDPrefix);

  for i := 0 to AssList.Count - 1 do begin
    if(PVTResourceData(AssList.Items[i]).link = 'debitors')
    	then break;
    if(PVTResourceData(AssList.Items[i]).sub = 1) or (PVTResourceData(AssList.Items[i]).link = CASH_LINK) then
    	continue;
    AssCombo.AddItem(PVTResourceData(AssList[i]).name, AssList[i]);
  end;
  AssCombo.ItemIndex := 0;

  // getting list of approved POs
  POCombo.Clear;
  i := 0;
  FPMainDataset.SQL.Text := 'SELECT`index`,`date`,`re`,`origin`,`status`,`fp`,`suma`,`fond`,`note`,`bycash`,`assetlink`FROM ' + CurDPrefix + 'po LEFT JOIN ' + CurDPrefix + 'fundsvsassets ON fundlink=fond WHERE`status`=2 OR`status`=4';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    New(POData);
    POData.index    := FPMainDataset.FieldByName('index').AsInteger;
    POData.re       := FPMainDataset.FieldByName('re').AsString;
    POData.Day      := FPMainDataset.FieldByName('date').AsDateTime;
    POData.origin   := FPMainDataset.FieldByName('origin').AsString;
    POData.FPNum    := FPMainDataset.FieldByName('fp').AsInteger;
    POData.SumA     := FPMainDataset.FieldByName('suma').AsExtended;
    POData.FondLink := FPMainDataset.FieldByName('fond').AsString;
    POData.Note			:= FPMainDataset.FieldByName('note').AsString;
    POData.bycash   := boolean(FPMainDataset.FieldByName('bycash').AsInteger);
    POData.alink    := FPMainDataset.FieldByName('assetlink').AsString;

    if POData.FondLink = '0' then
      POData.FondName := 'расходов'
    else begin
      for j := 0 to FondList.Count - 1 do begin
        if PVTResourceData(FondList[j]).link = POData.FondLink then begin
          POData.FondName     := 'фонда "' + PVTResourceData(FondList[j]).name + '"';
          POData.FondBalance  := PVTResourceData(FondList[j]).balance;
        end;
      end
    end; //else for POData.FondLink = '0'

    FPTmpDataset.SQL.Text := 'SELECT tbl2.*,' + CurDPrefix + 'postsdir.Abbr FROM ' + CurDPrefix + 'postsdir JOIN ' +
      '(SELECT PostID,userid,FName,MName,FamilyName FROM ' + CurDPrefix + 'psts JOIN ' +
    	'(SELECT pstsid,userid,FirstName AS FName,MiddleName AS MName,FamilyName FROM ' + CurDPrefix + 'pstsfills JOIN allusers ' +
	    'USING(UserID)WHERE allusers.login=:fLogin and(Now()>=startdate)AND((Now()<enddate)or(enddate is NULL)))AS tbl1 ' +
      'ON tbl1.pstsid=' + CurDPrefix + 'psts.id)AS tbl2 ON tbl2.PostID=' + CurDPrefix + 'postsdir.ID';// LOCK IN SHARE MODE';
    FPTmpDataset.ParamByName('fLogin').AsString := POData.origin;
    FPTmpDataset.Open;
    POData.Post  := FPTmpDataset.FieldByName('Abbr').AsString;
    POData.Name  := GetShortFIO(FPTmpDataset.FieldByName('FamilyName').AsString, FPTmpDataset.FieldByName('FName').AsString,
    								 FPTmpDataset.FieldByName('MName').AsString);

    POCombo.AddItem(IntToStr(POData.index) + ': ' + POData.re, TObject(POData));
    Inc(i);
    FPMainDataset.Next;
  end;

  FixControlStates(i);
  if i = 0 then begin // if no POs for the org
    Exit;
  end;

  POCombo.ItemIndex := 0;
  POComboChange(Sender);

  // Getting list of creditors
  CreditorCombo.Clear;
  FPMainDataset.SQL.Text := 'SELECT`' + CurDPrefix + 'creditor`.`index`,`' + CurDPrefix + 'creditor`.`name`FROM`' + CurDPrefix + 'creditor`LEFT JOIN`' + CurDPrefix + 'topay`ON`' + CurDPrefix + 'creditor`.`index`=`' + CurDPrefix + 'topay`.`creditor`WHERE`' + CurDPrefix + 'topay`.`summ`IS NOT NULL GROUP BY`' + CurDPrefix + 'creditor`.`name`ORDER BY`' + CurDPrefix + 'creditor`.`name`';// LOCK IN SHARE MODE';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    New(CredData);
    CredData.index  := FPMainDataset.FieldByName('index').AsInteger;
    CreditorCombo.AddItem(FPMainDataset.FieldByName('name').AsString, TObject(CredData));
    FPMainDataset.Next;
  end;
  CreditorCombo.ItemIndex := 0;
  CreditorComboChange(Sender);

  OKButtonEnable;
end;

procedure TDisbForm.AmountEditChange(Sender: TObject);
begin
  RestMoneyEdit.Value := AmountEdit.Value;
	if AutoCloseCheckBox.Checked then begin
    AutoCloseCheckBoxClick(Sender);
  end;
  OKButtonEnable;
end;

procedure TDisbForm.ArrearsTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
	NodeData	: PArrearData;
begin
 	if Node = nil then
  	Exit;
  NodeData := Sender.GetNodeData(Node);
	if  Node.CheckState = csCheckedNormal then begin
    if Round(RestMoneyEdit.Value*100) = 0 then begin
  	  Application.MessageBox('Не осталось средств для закрытия этой задолженности.', 'Списание средств', MB_ICONINFORMATION or MB_OK);
      Node.CheckState := csUncheckedNormal;
    end;
    if Round(NodeData.SumToClose*100) = 0 then begin
    	if NodeData.Amount > RestMoneyEdit.Value then
				NodeData.SumToClose := RestMoneyEdit.Value
      else
				NodeData.SumToClose := NodeData.Amount;
		  RestMoneyEdit.Value := RestMoneyEdit.Value - NodeData.SumToClose;
    end;
  end
	else begin
	  RestMoneyEdit.Value := RestMoneyEdit.Value + NodeData.SumToClose;
		NodeData.SumToClose := 0;
  end;
	OKButtonEnable;
end;

procedure TDisbForm.ArrearsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
	NodeData	: PArrearData;
begin
  CellText := '';
  if Node = nil then
    Exit;
  NodeData := Sender.GetNodeData(Node);
  case Column of
  	0	: CellText := DateToStr(NodeData.PayDate);
    1	: CellText := MyFloatToStr(NodeData.Amount);
    2	: if Round(NodeData.SumToClose * 100) <> 0 then CellText := MyFloatToStr(NodeData.SumToClose);
  end;
end;

procedure TDisbForm.ArrearsTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType);
var
	NodeData : PArrearData;
begin
	if Node = nil then
    Exit;
  NodeData	:= Sender.GetNodeData(Node);
  if NodeData.PayDate <= TDate(now) then
    TargetCanvas.Font.Color := clRed;
end;

procedure TDisbForm.AutoCloseCheckBoxClick(Sender: TObject);
var
	Node				: PVirtualNode;
  NodeData		: PArrearData;
  CurrentSum	: extended;
begin
//
	if AutoCloseCheckBox.Checked then begin // calculate off all arrears
//  Clear off all possible changes made in manual mode
	  Node 			:= ArrearsTree.GetFirstChild(nil);
  	while Node <> nil do begin
      Node.CheckType := ctNone;
	    NodeData	:= ArrearsTree.GetNodeData(Node);
      NodeData.SumToClose := 0;
      NodeData.Checked	:= false;
      ArrearsTree.RepaintNode(Node);
		  Node := ArrearsTree.GetNextSibling(Node);
	  end;

//  main clearing process
	  Node 			:= ArrearsTree.GetFirstChild(nil);
    CurrentSum := AmountEdit.Value;
  	while Node <> nil do begin
	    NodeData	:= ArrearsTree.GetNodeData(Node);
      Node.CheckType := ctNone;
      if CurrentSum > 0 then begin
      	if CurrentSum > NodeData.Amount then begin
          NodeData.SumToClose := NodeData.Amount;
          CurrentSum := CurrentSum - NodeData.Amount;
          NodeData.Checked	:= true;
        end
        else begin
          NodeData.SumToClose := CurrentSum;
          CurrentSum := 0;
          NodeData.Checked	:= true;
        end;
      end;
      ArrearsTree.RepaintNode(Node);
		  Node := ArrearsTree.GetNextSibling(Node);
	  end;
    RestMoneyEdit.Value := CurrentSum;
    RestMoneyEdit.Repaint;
  end
  else begin
	  Node 			:= ArrearsTree.GetFirstChild(nil);
//    NodeData	:= ArrearsTree.GetNodeData(Node);
  	while Node <> nil do begin
      NodeData	:= ArrearsTree.GetNodeData(Node);
      Node.CheckType :=	ctCheckBox;
      if NodeData.SumToClose > 0 then
      	Node.CheckState := csCheckedNormal
      else
      	Node.CheckState := csUncheckedNormal;
      ArrearsTree.RepaintNode(Node);
		  Node := ArrearsTree.GetNextSibling(Node);
	  end;
  end;
	OKButtonEnable;
end;

procedure TDisbForm.ByCashCBClick(Sender: TObject);
var
//  podata : PPOData;
  LA     : string;
  i      : integer;

begin
  if ByCashCB.Checked <> CurPOData.bycash then begin
    if IDYES <> Application.MessageBox('Вы уверены, что хотите изменить способ расхода по данной заявке?', 'Изменение типа расхода', MB_YESNO or MB_ICONWARNING) then begin
      ByCashCB.Checked := not ByCashCB.Checked;
      Exit;
    end
  end;
    if not ByCashCB.Checked then begin
    LA := CurPOData.alink;
    end
    else begin
      LA := CurDPrefix + DISBCASH_LINK;
    end;

  if LA <> '' then begin
  	for i := 0 to AssCombo.Items.Count - 1 do begin
      if LA = PVTResourceData(AssCombo.Items.Objects[i]).link then begin
      	AssCombo.ItemIndex := i;
        break;
      end;
    end;
  end;
end;

procedure TDisbForm.CreditorCombo1Change(Sender: TObject);
Var
  Node			: PVirtualNode;
  NodeData	: PArrearData;

Begin

  if CreditorCombo.ItemIndex < 0 then
    Exit;

  ArrearsTree.Clear;
  AutoCloseCheckBox.Checked := false;

  if CreditorCombo.ItemIndex < 0 then
  	Exit;

  FPMainDataset.SQL.Text  := 'SELECT`index`,`paydate`,`summ`,`data`,`closed`FROM`' + CurDPrefix + 'topay`WHERE`creditor`=:fCreditorNum AND`closed`>=0 ORDER BY`paydate`';
	FPMainDataset.ParamByName('fCreditorNum').AsInteger := PContrData(CreditorCombo.Items.Objects[CreditorCombo.ItemIndex]).Index;

  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    Node 								:= ArrearsTree.AddChild(nil);
		Node.CheckType  		:= ctCheckBox;
    NodeData						:= ArrearsTree.GetNodeData(Node);
    NodeData.index			:= FPMainDataset.FieldByName('index').AsInteger;
    NodeData.PayDate		:= FPMainDataset.FieldByName('paydate').AsDateTime;
    NodeData.Amount			:= FPMainDataset.FieldByName('summ').AsExtended - FPMainDataset.FieldByName('closed').AsExtended;
    NodeData.Checked		:= false;
    NodeData.SumToClose	:= 0;
    FPMainDataset.Next;
  end; // while not ...

  OKButtonEnable;
end;

procedure TDisbForm.CreditorComboChange(Sender: TObject);
Var
  Node			: PVirtualNode;
  NodeData	: PArrearData;

Begin

  if CreditorCombo.ItemIndex < 0 then
    Exit;

  ArrearsTree.Clear;
  AutoCloseCheckBox.Checked := false;

//  if CreditorCombo.ItemIndex < 0 then
  if not CreditorIsValid then
  	Exit;

  FPMainDataset.SQL.Text  := 'SELECT`index`,`paydate`,`summ`,`data`,`closed`FROM`' + CurDPrefix + 'topay`WHERE`creditor`=:fCreditorNum AND`closed`>=0 ORDER BY`paydate`';
	FPMainDataset.ParamByName('fCreditorNum').AsInteger := PContrData(CreditorCombo.Items.Objects[CreditorCombo.ItemIndex]).Index;

  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    Node 								:= ArrearsTree.AddChild(nil);
		Node.CheckType  		:= ctCheckBox;
    NodeData						:= ArrearsTree.GetNodeData(Node);
    NodeData.index			:= FPMainDataset.FieldByName('index').AsInteger;
    NodeData.PayDate		:= FPMainDataset.FieldByName('paydate').AsDateTime;
    NodeData.Amount			:= FPMainDataset.FieldByName('summ').AsExtended - FPMainDataset.FieldByName('closed').AsExtended;
    NodeData.Checked		:= false;
    NodeData.SumToClose	:= 0;
    FPMainDataset.Next;
  end; // while not ...

  OKButtonEnable;
end;

procedure TDisbForm.CreditorComboKeyPress(Sender: TObject; var Key: Char);
begin
	if not CreditorIsValid then ArrearsTree.Clear;
end;

procedure TDisbForm.FormCreate(Sender: TObject);
begin
	ArrearsTree.NodeDataSize := SizeOf(TArrearData);

  AssList   := TList.Create;
  FondList  := TList.Create;
  TypeList  := TList.Create;
  POGroupBox.Caption := '';
  FondLabel.Caption  := '';
  FPLabel.Caption    := '';

  OrgsList := TList.Create;



end;

procedure TDisbForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin ModalResult := mrCancel; Key := 0; end;
  end;
end;

procedure TDisbForm.FormShow(Sender: TObject);
begin
	InitForm(Sender);
end;

procedure TDisbForm.OKButtonClick(Sender: TObject);
var
  AssLink   : string;
  Fond_Link : string;
  Fond_Name : string;
  OperType  : string;
  OperTypeID: integer;
  nfid      : integer;
  Bal       : extended;
  Sum       : extended;
  BalF      : extended;
///  PONum     : integer;
  ToPayID   : integer;
  sNote			: string;

  Node			: PVirtualNode;
  NodeData	: PArrearData;

  NoError   : boolean;

begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  Sum       := AmountEdit.Value;
  if (Sum <= 0) and (not CurPOData.bycash) then begin //if Sum = 0 just mark the PO as paid for
	  // transaction initialization
		FPMainDataset.SQL.Text := 'BEGIN';
	  try
  		FPMainDataset.ExecSQL;
	  except
  	 	on e: EZSQLException do begin
	  	  GlobalVars.ShowError(Self, 'Невозможно заблокировать таблицу. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
				FPMainDataset.SQL.Text := 'ROLLBACK';
		  	FPMainDataset.ExecSQL;
	     Exit;
  	  end;
		end;
    // main transaction
  	try
	    FPMainDataset.SQL.Text  := 'UPDATE ' + CurDPrefix + 'po SET `status`=`status`+1,`note`=:fNote WHERE `index`=' + IntToStr(CurPONum);
  	  FPMainDataset.ParamByName('fNote').AsString	:= sNote;
    	FPMainDataset.ExecSQL;
	  	InitForm(Sender);
	  except
  	 	on e: EZSQLException do begin
	  	  GlobalVars.ShowError(Self, 'Во время обновления данных произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
				FPMainDataset.SQL.Text := 'ROLLBACK';
  	    FPMainDataset.ExecSQL;
    	  ModalResult := mrCancel;
	      Exit;
 		  end;
	  end;

	  // commit transaction if everything is OK so far
		FPMainDataset.SQL.Text := 'COMMIT';
	  FPMainDataset.ExecSQL;

  	Exit;
  end; // if Sum<=0 then begin

  if CurPOData.bycash then begin
    AssLink  := CurDPrefix + DISBCASH_LINK;
  end
  else
  	AssLink  := CurPOData.alink;
		
 	Fond_Link  := CurPOData.FondLink;
  Fond_Name  := CurPOData.FondName;
 	OperType   := PVTResourceData(TypeCombo.Items.Objects[TypeCombo.ItemIndex]).link;
  OperTypeID := PVTResourceData(TypeCombo.Items.Objects[TypeCombo.ItemIndex]).index;

  // transaction initialization
	FPMainDataset.SQL.Text := 'BEGIN';
  try
 		FPMainDataset.ExecSQL; // 1
  except
 	 	on e: EZSQLException do begin
  	  GlobalVars.ShowError(Self, 'Невозможно заблокировать таблицу. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
			FPMainDataset.SQL.Text := 'ROLLBACK';
	  	FPMainDataset.ExecSQL;
			Exit;
 	  end;
	end;

  // if the way of disburse (cash/bank) was changed from original
  // we have either to return cash to the bank account or to transfer asset to disursment cash
  NoError   := true;
  if (ByCashCB.Checked <> CurPOData.bycash) and (round(Sum * 100) > 0) then begin
    if ByCashCB.Checked then begin // money will be spent as cash and we have to transfer money to disb cash first
      NoError := AssetsTransfer(AssLink, CurDPrefix + DISBCASH_LINK, Sum, 'Изменение типа расхода по заявке № ' + IntToStr(CurPONum), CurDPrefix);
      AssLink := CurDPrefix + DISBCASH_LINK;
    end
    else begin                     // money will be spent from bank and we have to return money on bank account from disb cash
      NoError := AssetsTransfer(CurDPrefix + DISBCASH_LINK, AssLink, Sum, 'Изменение типа расхода по заявке № ' + IntToStr(CurPONum), CurDPrefix);
    end;
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

	try // minus money from asset to be paid off
	  FPMainDataset.SQL.Text  := 'SELECT balance FROM`'+ AssLink + '`WHERE`index`>1 ORDER BY`index`DESC LIMIT 1';
 		FPMainDataset.Open;
 		Bal := FPMainDataset.FieldByName('balance').AsExtended - Sum;
	  if (Fond_Link <> '0') and (Fond_Link <> '') then begin
			FPMainDataset.SQL.Text  := 'SELECT balance FROM`' + Fond_Link + '`WHERE`index`>1 ORDER BY`index`DESC LIMIT 1';
   		FPMainDataset.Open;
 		  BalF := FPMainDataset.FieldByName('balance').AsExtended - Sum;
	  end;
  	if (round(Bal * 100) >= 0) and (round(BalF * 100) >= 0) then begin
 	  // take money off the cash or bank account
      if(round(Sum * 100) > 0) then begin
				FPMainDataset.SQL.Text  := 'INSERT INTO`'+ AssLink + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fOpertype,0,:fBal,Now(),:fDescr,0,:fSum';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';

{$IFDEF USERID}
      	FPMainDataset.ParamByName('fUserID').AsInteger 			:= FPUserID;
{$ENDIF}
	 		  FPMainDataset.ParamByName('fOpertype').AsString := OperType;
  	 		FPMainDataset.ParamByName('fBal').AsFloat       := Bal;
	  	  if (Fond_Link <> '0') and (Fond_Link <> '') then
 		  	  FPMainDataset.ParamByName('fDescr').AsString	:= DescrMemo.Text + ' (с фонда "' + Fond_Name + '")'
	   		else
  	    	FPMainDataset.ParamByName('fDescr').AsString  := DescrMemo.Text + ' (из расходов)';

	  	  if OperType = 'credit' then begin
      		FPMainDataset.ParamByName('fDescr').AsString := FPMainDataset.ParamByName('fDescr').AsString + CRLF + ' Кредитору: ' + CreditorCombo.Text;
	      end;

		 	  FPMainDataset.ParamByName('fSum').AsFloat	:= Sum;
    		FPMainDataset.ExecSQL;

	 			fond_update(AssLink, Bal);

	  	  if (Fond_Link <> '0') and (Fond_Link <> '') then begin
  				FPMainDataset.SQL.Text  := 'INSERT INTO`'+ Fond_Link + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
        	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
        	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fOpertype,0,:fBalF,Now(),:fDescr,0,:fSum';
{$IFDEF USERID}
      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';

{$IFDEF USERID}
      		FPMainDataset.ParamByName('fUserID').AsInteger 			:= FPUserID;
{$ENDIF}
	  	    FPMainDataset.ParamByName('fOpertype').AsString := OperType;
  	  	  FPMainDataset.ParamByName('fBalF').AsFloat      := BalF;
    	  	FPMainDataset.ParamByName('fDescr').AsString    := DescrMemo.Text;
	      	FPMainDataset.ParamByName('fSum').AsFloat       := Sum;
		      FPMainDataset.ExecSQL;

          // get `index` of last added line
          nfid := 0;
					if NoError then begin
	 			  	// Getting last ID
			  		FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
			    	try                     // saving filename only - the file will be saved later
		  				FPMainDataset.Open;
				      if not FPMainDataset.Eof then
		  			  	nfid := FPMainDataset.FieldByName('ID').AsInteger;
			      except
  						on e: EZSQLException do begin
					  		GlobalVars.ShowError(Self, 'Произошла ошибка при получении индекса.', e.ErrorCode, e.StatusCode, e.Message + ' @ SELECT_LAST_ID');
	    			    NoError := false;
			        end;
      			end;
			    end; //
          // get `index` of last added line - end of

  		 		fond_update(Fond_Link, BalF);
    		end;

		    FPMainDataset.SQL.Text	:= 'UPDATE ' + CurDPrefix + 'po SET`status`=`status`+1,`note`=:fNote,`pd`=Now(),`sump`=:fsump,`bycash`=:fbycash,`fi`=:ffi,`otid`=:fotid WHERE`index`='+ IntToStr(CurPONum);
  		  FPMainDataset.ParamByName('fNote').AsString    := sNote;
  		  FPMainDataset.ParamByName('fsump').AsFloat     := Sum;
  		  FPMainDataset.ParamByName('fbycash').AsInteger := Ord(ByCashCB.Checked);
  		  FPMainDataset.ParamByName('ffi').AsInteger     := nfid;
  		  FPMainDataset.ParamByName('fotid').AsInteger   := OperTypeID;
    		FPMainDataset.ExecSQL;

		    if OperType = 'credit' then begin
  		    Node := ArrearsTree.GetFirstChild(nil);
    		  while Node <> nil do begin
      			NodeData := ArrearsTree.GetNodeData(Node);
        		if (Node.CheckState = csCheckedNormal) or (AutoCloseCheckBox.Checked and (NodeData.SumToClose > 0)) then begin
      				// Updating data for debtor's arrears
	  		    	Cred_CalcMO(CurDPrefix, NodeData.index, NodeData.SumToClose, CurPONum, DT.Text);
			      end;
  	  	  	Node	:= ArrearsTree.GetNextSibling(Node);
    	  	end;
	    	end;
      end; // if(round(Sum * 100) > 0) then begin

      // in case the disbursed amount less than approved amount, the difference is to be returned to proper account
      if (ByCashCB.Checked) and (CurPOData.bycash) and ((round((CurPOData.SumA - Sum) * 100) > 0) or (round(Sum * 100) = 0)) then begin
	      NoError := AssetsTransfer(CurDPrefix + DISBCASH_LINK, CurPOData.alink, CurPOData.SumA - Sum, 'Возврат неиспользованных средств на счёт ' (*+ IntToStr(PONum)*), CurDPrefix);
      end;

      if NoError then begin // commit transaction if everything is OK so far
				FPMainDataset.SQL.Text := 'COMMIT';
			  FPMainDataset.ExecSQL;
      end;

	    if ID_NO = Application.MessageBox('Провести ещё одну заявку?', 'Операци проведена успешно', MB_YESNO or MB_ICONINFORMATION) then begin
	  	  ModalResult := mrCancel;
	    end
    	else
			  POCombo.DeleteSelected;
			if POCombo.ItemIndex > POCombo.Items.Count - 1 then
				POCombo.ItemIndex := POCombo.Items.Count - 1
      else if POCombo.ItemIndex < 0 then
				POCombo.ItemIndex := 0;

      FixControlStates(POCombo.Items.Count);

			if POCombo.Items.Count > 0 then
				POComboChange(Sender);
	  end // if (Bal>=0) and (BalF>=0) then begin
  	else begin
  		if (round(Bal * 100) < 0) then //and (round(BalF*100)>=0) then begin
	    	Application.MessageBox('В указанном активе недостаточно средств', 'Проверьте правильность данных', MB_OK or MB_ICONERROR)
	    else
		    Application.MessageBox('В указанном фонде недостаточно средств', 'Проверьте правильность данных', MB_OK or MB_ICONERROR);
    	// rollback the select clauses
			FPMainDataset.SQL.Text := 'ROLLBACK';
	  	FPMainDataset.ExecSQL;
	  end; // else

  except
   	on e: EZSQLException do begin
	    GlobalVars.ShowError(Self, 'Во время обновления данных произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
//      FPConnection.Rollback;
			FPMainDataset.SQL.Text := 'ROLLBACK';

      FPMainDataset.ExecSQL;
      ModalResult := mrCancel;
      Exit;
 	  end;
  end; // try
end;

procedure TDisbForm.POComboChange(Sender: TObject);
var
  LinkedAsset : string;
  i						: integer;

begin
  OKButtonEnable;
  if POCombo.ItemIndex < 0 then begin
    POGroupBox.Caption  := '';
    FPLabel.Caption     := '';
    FondLabel.Caption   := '';
    Exit;
  end;

  CurPOData 					:= PPOData(POCombo.Items.Objects[POCombo.ItemIndex]);
  POGroupBox.Caption  := 'Заявка № ' + IntToStr(CurPOData.index) + ' от ' + DateToStr(CurPOData.Day) + '. ' +
    										 'Автор: ' + CurPOData.Name + ', ' + CurPOData.Post;
  DescrMemo.Text 			:= 'По заявке № ' + IntToStr(CurPOData.index) + ' от ' + DateToStr(CurPOData.Day) + Chr(13) + Chr(10) +
    										 'Автор: ' + CurPOData.Name+ ', ' + CurPOData.Post + Chr(13) + Chr(10) + 'Тема: ' + CurPOData.re;
  if CurPOData.FPNum = -1 then
    FPLabel.Caption := 'Одобрено вне ФП'
  else
    FPLabel.Caption := 'Одобрено на ФП № ' + IntToStr(CurPOData.FPNum);
  ApprSumEdit.Text  := MyFloatToStr(CurPOData.SumA);
  FondLabel.Caption := 'из ' + CurPOData.FondName;
  AmountEdit.Value  := CurPOData.SumA;

  ArrearsTree.Clear;
  AutoCloseCheckBox.Checked := false;
  CreditorComboChange(Sender);

	RestMoneyEdit.Value := AmountEdit.Value;

// section for working with fond-asset connection
// if fund is assigned to an asset than we have to lock asset combo
  ByCashCB.Checked := CurPOData.bycash;
  if not CurPOData.bycash then begin
    LinkedAsset := CurPOData.alink;
  end
  else begin
    LinkedAsset := CurDPrefix + DISBCASH_LINK;
  end;

	AssCombo.Enabled := LinkedAsset = '';
  if LinkedAsset <> '' then begin
  	for i := 0 to AssCombo.Items.Count - 1 do begin
      if LinkedAsset = PVTResourceData(AssCombo.Items.Objects[i]).link then begin
      	AssCombo.ItemIndex := i;
        break;
      end;
    end;
  end;
  if (LinkedAsset = '') or (CurPOData.FondLink = '') then begin
		Application.MessageBox('Эту заявку невозможно провести, обратитесь к разработчикам', 'Ошибка базы данных', MB_OK or MB_ICONERROR);
    OKButton.Enabled := false;
  end;
  CurPONum  := CurPOData.index;
end;

procedure TDisbForm.TypeComboChange(Sender: TObject);
begin
  if TypeCombo.ItemIndex in [2] then begin
    Height := HeightExpanded;
    if TypeCombo.ItemIndex = 2 then begin
      CreditorLabel.Visible := true;
      CreditorCombo.Visible := true;
      // new part with auto filling
      ArrearsLabel.Visible	:= true;
      ArrearsTree.Visible		:= true;
      RestMoneyLabel.Visible	:= true;
      RestMoneyEdit.Visible		:= true;
      AutoCloseCheckBox.Visible	:= true;
    end
    else begin
      CreditorLabel.Visible := false;
      CreditorCombo.Visible := false;
      // new part with auto filling
      ArrearsLabel.Visible	:= false;
      ArrearsTree.Visible		:= false;
      RestMoneyLabel.Visible	:= false;
      RestMoneyEdit.Visible		:= false;
      AutoCloseCheckBox.Visible	:= false;
    end;
  end
  else begin
    Height := HeightCollapsed;
  end;
  OKButtonEnable;
end;

end.
