unit IncomeEnteringWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, sSpinEdit, Mask, sMaskEdit, sCustomComboEdit,
  GlobalVars,
  Clipbrd, 	// for TClipboard
  sTooledit, sLabel, MoneyEdit, AdvEdit, AdvMoneyEdit, sComboBox, VirtualTrees, sCheckBox, ExtCtrls, sPanel,
  sButton, Vcl.ComCtrls, sComboBoxes;

type
  TIncomeEnteringForm = class(TForm)
    PriceLabel: TsLabel;
    sLabel2: TsLabel;
    AdvMoneyEdit: TAdvMoneyEdit;
    TypeLabel: TsLabel;
    TypeCombo: TsComboBox;
    DestLabel: TsLabel;
    DescrMemo: TMemo;
    DescrLabel: TsLabel;
    OKButton: TButton;
    CancelButton: TButton;
    DebtorLabel: TsLabel;
    ArrearsLabel: TsLabel;
    DebtorCombo: TsComboBox;
    DestCombo: TsComboBox;
    SpecIncCB: TsCheckBox;
    sLabel5: TsLabel;
    sPanel1: TsPanel;
    ArrearsTree: TVirtualStringTree;
    RestMoneyLabel: TsLabel;
    RestMoneyEdit: TAdvMoneyEdit;
    AutoCloseCheckBox: TsCheckBox;
    IncSrcCombo: TsComboBox;
    IncSrcLabel: TsLabel;
    PriceEdit: TAdvMoneyEdit;
    AmountLabel: TsLabel;
    AmountEdit: TAdvMoneyEdit;
    PercentEdit: TAdvMoneyEdit;
    PercentLabel: TsLabel;
    OrgLabel: TsLabel;
    OrgCombo: TsComboBox;
    IncomeTree: TVirtualStringTree;
    IncomeLineAddButton: TsButton;
    IncomeLineDeleteButton: TsButton;
    ClientsCB: TsComboBox;
    ClientsLabel: TsLabel;
    procedure FormCreate(Sender: TObject);
    procedure DescrMemoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AdvMoneyEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
    procedure TypeComboChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DebtorComboChange(Sender: TObject);
    procedure ArrearsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure ArrearsTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AdvMoneyEditChange(Sender: TObject);
    procedure ArrearsTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure AutoCloseCheckBoxClick(Sender: TObject);
    procedure PriceEditChange(Sender: TObject);
    procedure AmountEditChange(Sender: TObject);
    procedure PriceEditContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure PriceEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OrgComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IncomeTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure IncomeLineAddButtonClick(Sender: TObject);
    procedure IncomeTreeCreateEditor(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure IncomeTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure IncomeTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: string);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure IncomeLineDeleteButtonClick(Sender: TObject);
    procedure IncomeTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure IncomeTreeEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure ClientsCBChange(Sender: TObject);
    procedure ClientsCBSelect(Sender: TObject);
  private
    { Private declarations }
    CurMoment       : TDateTime;
    DebtList        : TList;
    DebtorList      : TList;
	  DestList				: TList;
	  Clipboard				: TClipboard;
    CurOIPrefix     : string;
    istep           : integer;
    bEditingIsIP    : Boolean;
    GrandTotal      : extended;

    Heights : array [0..1] of integer;
    procedure PullDebtors(Sender: TObject);
    Procedure SetOKBtn;
    Procedure FondUpdate(flink: string; balance: Extended);
    procedure ClearArrearsTree;
    procedure OnVSTEndEdit(var Msg: TMessage); message UM_VST_END_EDIT;
    procedure OnVSTCancelEdit(var Msg: TMessage); message UM_VST_CANCEL_EDIT;
    procedure IncomeLineAdd;
    procedure IncomeLineDelete;
    procedure PopulateClientsList;
  protected
    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
  public
    { Public declarations }
    OrgsList        : TList;
  end;

var
  IncomeEnteringForm: TIncomeEnteringForm;

implementation

{$R *.dfm}

uses //MainFPForm,
//  VirtualTrees,
  VTIncomeEnteringCustomEditor,
  StrUtils,
	ZDbcIntfs, // for EZSQLException
  ZConnection,
  ZDataset;

procedure TIncomeEnteringForm.ClearArrearsTree;
Var
	Node			: PVirtualNode;
  NodeData	: PArrearData;
begin
  Node := ArrearsTree.GetFirstChild(nil);
  while Node <> nil do begin
  	Node.CheckState := csUncheckedNormal;
    NodeData := ArrearsTree.GetNodeData(Node);
    NodeData.SumToClose := 0;
    ArrearsTree.RepaintNode(Node);
    Node := ArrearsTree.GetNextSibling(Node);
  end;
end;

procedure TIncomeEnteringForm.ClientsCBChange(Sender: TObject);
begin
  SetOKBtn;
end;

procedure TIncomeEnteringForm.ClientsCBSelect(Sender: TObject);
begin
  SetOKBtn;
end;

Procedure TIncomeEnteringForm.FondUpdate(flink:string; balance: Extended);
var
  T_Dataset : TZQuery;
  TmpLink   : string;
  TmpLink1  : string;
  TotBal    : Extended;

begin

  T_Dataset := TZQuery.Create(nil);
  T_Dataset.Connection := FPConnection;


  T_Dataset.Close;
  T_Dataset.SQL.Text := 'SELECT link FROM ' + flink + ' ORDER BY `index` LIMIT 1';
  T_Dataset.Open;
  if T_Dataset.RecordCount = 0 then begin
    T_Dataset.Close;
    T_Dataset.Free;
    Exit;
  end;
  TmpLink   := T_Dataset.FieldByName('link').AsAnsiString; //AsString;
  TmpLink1  := ReplaceStr(FloatToStr(balance), ',', '.');

  T_Dataset.Close;
  T_Dataset.SQL.Text := 'UPDATE ' + TmpLink + ' SET balance=' + TmpLink1 + ' WHERE link="' + flink +'" LIMIT 1';
  T_Dataset.ExecSQL;

  T_Dataset.SQL.Text := 'SELECT link FROM '+ Tmplink + ' ORDER BY `index` LIMIT 1';
  T_Dataset.Open;
  if T_Dataset.RecordCount = 0 then begin
    T_Dataset.Close;
    T_Dataset.Free;
    Exit;
  end;

  TmpLink1 := T_Dataset.FieldByName('link').AsString;
  T_Dataset.Close;

  if TmpLink1 <> 'root' then begin
    TotBal := 0;
  	T_Dataset.SQL.Text := 'SELECT balance FROM ' + TmpLink;
    T_Dataset.Open;
    while Not T_Dataset.Eof do begin
      TotBal := TotBal + T_Dataset.FieldByName('balance').AsExtended;
      T_Dataset.Next;
    end;
    FondUpdate(TmpLink, TotBal);
  end;
  T_Dataset.Close;
  T_Dataset.Free;
end;

Procedure TIncomeEnteringForm.SetOKBtn;
begin
  OKButton.Enabled := (0 < GrandTotal) and (0 <= ClientsCB.ItemIndex);
end;

procedure TIncomeEnteringForm.TypeComboChange(Sender: TObject);
begin
  SetOKBtn;
  Self.Height := Heights[TypeCombo.ItemIndex];
  Case TypeCombo.ItemIndex of
    0: begin
      DebtorLabel.Visible   	:= false;
      DebtorCombo.Visible   	:= false;
      ArrearsLabel.Visible  	:= false;
      ArrearsTree.Visible			:= false;
      RestMoneyLabel.Visible	:= false;
      RestMoneyEdit.Visible		:= false;
		  AutoCloseCheckBox.Visible	:= false;
    end;
    1: begin
      DebtorLabel.Visible   		:= true;
      DebtorCombo.Visible   		:= true;
      PullDebtors(Sender);
    	DebtorComboChange(Sender);
      ArrearsLabel.Visible  		:= true;
      ArrearsTree.Visible				:= true;
      RestMoneyLabel.Visible		:= true;
      RestMoneyEdit.Visible			:= true;
		  AutoCloseCheckBox.Visible	:= true;
    end
  End; // case
end;

procedure TIncomeEnteringForm.AdvMoneyEditChange(Sender: TObject);
begin
  RestMoneyEdit.Value := AdvMoneyEdit.Value;
  ClearArrearsTree;
  SetOKBtn;

end;

procedure TIncomeEnteringForm.AdvMoneyEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SetOKBtn;
end;

procedure TIncomeEnteringForm.AmountEditChange(Sender: TObject);
begin
	AdvMoneyEdit.Value := PriceEdit.Value * AmountEdit.Value;
  AdvMoneyEdit.Repaint;
  if(AdvMoneyEdit.Value >= 0) then begin
  	AdvMoneyEdit.Font.Color := clBlack
  end
  else begin
	  AdvMoneyEdit.Font.Color	:= clRed;
  end;
end;

procedure TIncomeEnteringForm.ArrearsTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
	NodeData	: PArrearData;
begin
 	if Node = nil then
  	Exit;
  NodeData := Sender.GetNodeData(Node);
	if  Node.CheckState = csCheckedNormal then begin
    if Round(RestMoneyEdit.Value * 100) = 0 then begin
  	  Application.MessageBox('Не осталось средств для закрытия этой задолженности.', 'Приход средств', MB_ICONINFORMATION or MB_OK);
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
end;

procedure TIncomeEnteringForm.ArrearsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
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

procedure TIncomeEnteringForm.ArrearsTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
	NodeData : PArrearData;
begin
	if Node = nil then
    Exit;
  NodeData	:= Sender.GetNodeData(Node);
  if NodeData.PayDate <= TDate(now) then
    TargetCanvas.Font.Color := clRed;
end;

procedure TIncomeEnteringForm.AutoCloseCheckBoxClick(Sender: TObject);
var
	Node				: PVirtualNode;
  NodeData		: PArrearData;
  CurrentSum	: extended;
begin
	if AutoCloseCheckBox.Checked then begin // calculate off all arrears
	  Node 			:= ArrearsTree.GetFirstChild(nil);
    CurrentSum := AdvMoneyEdit.Value;
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

end;

procedure TIncomeEnteringForm.DebtorComboChange(Sender: TObject);
var
  Node			: PVirtualNode;
  NodeData	: PArrearData;
  ToColTbl  : string;
begin
//
  ArrearsTree.Clear;
  if DebtorCombo.ItemIndex < 0 then
  	Exit;

  ToColTbl := CurOIPrefix + 'tocollect';

  FPMainDataset.SQL.Text  := 'SELECT `index`,`paydate`,`summ`,`data`,`closed` FROM `' + ToColTbl + '` WHERE `debtor`=:fDebtorNum AND `closed`>=0 ORDER BY `paydate`';
  FPMainDataset.ParamByName('fDebtorNum').AsInteger := PVTResourceData(DebtorList[DebtorCombo.ItemIndex]).index;
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
  RestMoneyEdit.Value := Self.AdvMoneyEdit.Value;
end;

procedure TIncomeEnteringForm.DescrMemoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SetOkBtn;
end;

procedure TIncomeEnteringForm.FormCreate(Sender: TObject);
var
  j 			: integer;
  ResData : PVTResourceData;
  i       : integer;
  OrgData : PVTResourceData;

begin


  IncomeTree.NodeDataSize := SizeOf(TIncomeEntity);

	ArrearsTree.NodeDataSize := SizeOf(TArrearData);

  CurMoment   							:= now;
  DebtorLabel.Visible   		:= false;
  DebtorCombo.Visible   		:= false;
  ArrearsLabel.Visible  		:= false;
  ArrearsTree.Visible				:= false;
  RestMoneyEdit.Visible			:= false;
  RestMoneyLabel.Visible		:= false;
  AutoCloseCheckBox.Visible	:= false;

  VTIncSourcesNames  := TStringList.Create;
  VTIncSourcesIDs    := TList.Create;
  VTIncSourcesPrices := TList.Create;


{$IFNDEF FORPERFORMIA}
	PercentLabel.Visible	:= false;
  PercentEdit.Visible		:= false;
{$ENDIF}

  OrgCombo.Width  := TypeCombo.Width - (OrgCombo.Left - TypeCombo.Left);
  OrgsList := TList.Create;
  OrgCombo.Clear;

  istep := 3;

  TypeLabel.Top := OrgCombo.Top + OrgCombo.Height + istep;
  TypeCombo.Top := TypeLabel.Top;

  DestLabel.Top := TypeCombo.Top + TypeCombo.Height + istep;
  DestCombo.Top := DestLabel.Top;

  IncSrcLabel.Top := DestCombo.Top + DestCombo.Height + istep;
  IncSrcCombo.Top := IncSrcLabel.Top;

  DescrLabel.Top := IncSrcCombo.Top + IncSrcCombo.Height + istep;
  DescrMemo.Top  := DescrLabel.Top;

  DebtorLabel.Top := DescrMemo.Top + DescrMemo.Height + istep;
  DebtorCombo.Top := DebtorLabel.Top;

  ArrearsLabel.Top := DebtorCombo.Top + DebtorCombo.Height + istep;
  ArrearsTree.Top  := ArrearsLabel.Top;

  RestMoneyLabel.Top := ArrearsTree.Top + ArrearsTree.Height + istep;
  RestMoneyEdit.Top  := RestMoneyLabel.Top;

  AutoCloseCheckBox.Top := RestMoneyEdit.Top + RestMoneyEdit.Height + istep;

  j := OKButton.Top + OKButton.Height;
  i := Self.Height - (ClientRect.Bottom - ClientRect.Top) + (ClientRect.Bottom - j);
  Heights[0] := DescrMemo.Top + DescrMemo.Height + istep + OKButton.Height + i + (ClientRect.Bottom - j);
  Heights[1] := AutoCloseCheckBox.Top + AutoCloseCheckBox.Height + istep + OKButton.Height + i + (ClientRect.Bottom - j);
  Self.Height           		:= Heights[0]; //  * Screen.PixelsPerInch div 96;

  TypeCombo.Clear;
  FPMainDataset.SQL.Text  := 'SELECT name,link,sub,balance FROM inopertype WHERE`index`>1 AND`index`<>3 order by`index`ASC';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    TypeCombo.Items.Add(FPMainDataset.FieldByName('name').AsString);
    FPMainDataset.Next;
  end; // while not ...
  TypeCombo.ItemIndex := 0;
end;

procedure TIncomeEnteringForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VTIncSourcesNames);
  DebtList.Free;
  DebtorList.Free;
  OrgsList.Free;
  VTIncSourcesIDs.Free;
  VTIncSourcesPrices.Free;
end;

procedure TIncomeEnteringForm.IncomeLineAdd;
var
  Node : PVirtualNode;
  NodeData : PIncomeEntity;
  Pid : ^integer;

begin
  Node := IncomeTree.AddChild(nil);
  NodeData := IncomeTree.GetNodeData(Node);
  NodeData.IsText := VTIncSourcesNames[0];
  Pid := VTIncSourcesIDs[0];
  NodeData.IsID   := PId^;
  NodeData.price  := extended(VTIncSourcesPrices[0]^);
  NodeData.amount := 1;
  IncomeTree.Selected[Node] := true;
  IncomeTree.EditNode(Node, 0);
end;

procedure TIncomeEnteringForm.IncomeLineDelete;
var
  Nodes : TNodeArray;
  Node : PVirtualNode;
begin
  Nodes := IncomeTree.GetSortedSelection(false);
  if 0 < Length(Nodes) then begin
    IncomeTree.DeleteNodes(Nodes);
  end;
end;

procedure TIncomeEnteringForm.IncomeLineDeleteButtonClick(Sender: TObject);
begin
  IncomeLineDelete;
end;

procedure TIncomeEnteringForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ssCtrl in Shift then begin
    if (Key = VK_INSERT) then begin
      IncomeTree.SetFocus;
      IncomeLineAdd;
      Key := 0;
    end
    else if (Key = VK_DELETE) then begin
      IncomeLineDelete;
      Key := 0;
    end
  end;
end;

procedure TIncomeEnteringForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if (Key = VK_ESCAPE) then begin
    if bEditingIsIP then begin
      IncomeTree.SetFocus;
    end
    else begin
      ModalResult := mrCancel;
    end;
  end;
end;

procedure TIncomeEnteringForm.FormShow(Sender: TObject);
begin
  OrgComboChange(Sender);
end;

procedure TIncomeEnteringForm.IncomeTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with Sender do begin
    if Assigned(Node) then begin
      IncomeTree.EditNode(Node, IncomeTree.FocusedColumn);
    end;
  end;
end;

procedure TIncomeEnteringForm.IncomeTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  bEditingIsIP := true;
  EditLink := TVTIncomeEnteringCustomEditor.Create;
end;

procedure TIncomeEnteringForm.IncomeTreeEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  N : PVirtualNode;
  Data : PIncomeEntity;
begin
//  GrandTotal;
  GrandTotal := 0;
  N := IncomeTree.GetFirst;
  while N <> nil do begin
    Data := IncomeTree.GetNodeData(N);
    GrandTotal := GrandTotal + Data.price * Data.amount;
    N := IncomeTree.GetNext(N);
  end;
  SetOKBtn;
end;

procedure TIncomeEnteringForm.IncomeTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column < 3;
end;

procedure TIncomeEnteringForm.IncomeTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  NodeData : PIncomeEntity;
begin
  NodeData := Sender.GetNodeData(Node);
  case Column of
    0 : begin
      CellText := NodeData.IsText;
    end;
    1 : begin
      CellText := MyFloatToStr(NodeData.price);
    end;
    2 : begin
      CellText := IntToStr(NodeData.amount);
    end;
    3 : begin
      CellText := MyFloatToStr(NodeData.price * NodeData.amount);
    end;
  end;
end;

procedure TIncomeEnteringForm.IncomeTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  NodeData : PIncomeEntity;
  i : integer;
  Pid : ^integer;
  Pprice : ^extended;
begin
  NodeData := Sender.GetNodeData(Node);
  case Column of
    0 : begin
      NodeData.IsText := NewText;

      if VTIncSourcesNames.Find(NodeData.IsText, i) then begin
        Pid := VTIncSourcesIDs[i];
        NodeData.IsID := Pid^;
        Pprice := VTIncSourcesPrices[i];
        NodeData.price := Pprice^;
      end;
    end;
    1 : begin
      NodeData.price := StrToFloat(NewText);
    end;
    2 : begin
      NodeData.amount := StrToInt(NewText);
    end;
  end;
end;

procedure TIncomeEnteringForm.OKButtonClick(Sender: TObject);
var
  TmpStr  	: String;
  PersAcc   : string;
  IncType		: string;
  NewAccBal : Extended;
  NewPersBal: Extended;
  Node			: PVirtualNode;
  NodeData	: PArrearData;
  IncSrcID	: integer;
  TransUUID : string;
  PersonId  : integer;
  TransIdx  : integer;
  PID       : ^integer;
  IncomeData : PIncomeEntity;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

//  IncSrcID	:= integer(IncSrcCombo.Items.Objects[IncSrcCombo.ItemIndex]);
  case TypeCombo.ItemIndex of
    0: begin
		  // transaction initialization
			//FPMainDataset.SQL.Text := 'START TRANSACTION';

      Node := IncomeTree.GetFirst;
      if not Assigned(Node) then begin
        ModalResult := mrCancel;
        Exit;
      end;

		  try
        FPConnection.StartTransaction;
      // pulling last balance from the asset/fond table
        TmpStr  := GetLinkOfFondByName(DestList, DestCombo.Items[DestCombo.ItemIndex]);
        FPMainDataset.SQL.Text := 'SELECT balance FROM`' + TmpStr + '`WHERE`index`>1 ORDER BY`index`DESC LIMIT 1';
        FPMainDataset.Open;
        NewAccBal := FPMainDataset.FieldByName('balance').AsExtended; // AdvMoneyEdit.Value;

        PersAcc := CurOIPrefix + 'person_balances';
        NewPersBal := 0;
        // pulling last person's balance
        FPMainDataset.SQL.Text := 'SELECT balance FROM`' + PersAcc + '`WHERE`PersonID`=:fPersonID ORDER BY`idx`DESC LIMIT 1';
        FPMainDataset.ParamByName('fPersonID').AsInteger	:= PersonId;
        FPMainDataset.Open;
        if 0 < FPMainDataset.RecordCount then begin
          NewPersBal := FPMainDataset.FieldByName('balance').AsExtended;
        end
        else begin
          NewPersBal := 0;
        end;

//	  	try
        while Assigned(Node) do begin
          IncomeData := IncomeTree.GetNodeData(Node);

					// pulling last balance from the asset/fond table
          NewAccBal := NewAccBal + IncomeData.price * IncomeData.amount; // AdvMoneyEdit.Value;
          PVTResourceData(DestList[DestCombo.ItemIndex]).balance := NewAccBal;

          if SpecIncCB.Checked then
            IncType	:= 'specinc'
          else
            IncType	:= TmpStr;

          TransUUID := CreateUUID;

          FPMainDataset.SQL.Text := 'INSERT INTO ' + TmpStr + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`amount`,`price`,`data`,`in`,`out`,`incsrcid`,`pct`';
{$IFDEF USERID}
          FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
          FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`TransId`)';
          FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,"' + IncType + '",0,:fbalance,NOW(),:famount,:fprice,:fdescr,:fsum,0,:fincsrcid,:fpct';
{$IFDEF USERID}
          FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
          FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fTransId)';
  //      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';

          FPMainDataset.ParamByName('fbalance').AsFloat  		:= NewAccBal;
          FPMainDataset.ParamByName('fdescr').AsString   		:= IncomeData.IsText; //DescrMemo.Text;
          FPMainDataset.ParamByName('famount').AsFloat      := IncomeData.amount; //AmountEdit.Value;
          FPMainDataset.ParamByName('fprice').AsFloat      	:= IncomeData.price; //PriceEdit.Value;
          FPMainDataset.ParamByName('fsum').AsFloat      		:= IncomeData.price * IncomeData.amount; //AdvMoneyEdit.Value;
          FPMainDataset.ParamByName('fincsrcid').AsInteger	:= IncSrcID;
          FPMainDataset.ParamByName('fpct').AsFloat      		:= PercentEdit.Value;
  {$IFDEF USERID}
          FPMainDataset.ParamByName('fUserID').AsInteger 		:= FPUserID;
  {$ENDIF}
          FPMainDataset.ParamByName('fTransId').AsString    := TransUUID;

          FPMainDataset.ExecSQL;
          FondUpdate(TmpStr, NewAccBal);

          // get transaction ID
          FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() AS lid';
          FPMainDataset.Open;
          if not FPMainDataset.Eof then begin
            TransIdx := FPMainDataset.FieldByName('lid').AsInteger;
          end
          else begin
            TransIdx := 0;
          end;

          if 0 < TransIdx then begin
            // get person ID
            PersonId := ClientsCB.ItemIndex;
            if (0 < PersonId) and (PersonId < ClientsCB.Items.Count) then begin
              PersonId := integer(pointer(ClientsCB.Items.Objects[PersonId]));
            end;

            if 0 < PersonId then begin
              NewPersBal := NewPersBal + IncomeData.amount * IncomeData.price;
              // update person's balance
              FPMainDataset.SQL.Text := 'INSERT INTO ' + PersAcc + '(`UserID`,`PersonID`,`ServiceID`,`price`,`amount`,`income`,`balance`,`refidx`,`iscash`)';
              FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(:fUserId,:fPersonId,:fServiceId,:fPrice,:fAmount,:fIncome,:fBalance,:fRefIdx,:fIsCash)';
              FPMainDataset.ParamByName('fUserID').AsInteger 		:= FPUserID;
              FPMainDataset.ParamByName('fPersonID').AsInteger	:= PersonId;
              FPMainDataset.ParamByName('fServiceID').AsInteger	:= IncomeData.IsID;
              FPMainDataset.ParamByName('fPrice').AsFloat      	:= IncomeData.price;
              FPMainDataset.ParamByName('fAmount').AsInteger    := IncomeData.amount;
              FPMainDataset.ParamByName('fIncome').AsFloat      := IncomeData.amount * IncomeData.price;
              FPMainDataset.ParamByName('fbalance').AsFloat  		:= NewPersBal;
              FPMainDataset.ParamByName('fRefIdx').AsInteger    := TransIdx;
              FPMainDataset.ParamByName('fIsCash').AsInteger    := integer(DestCombo.ItemIndex = 0);
              FPMainDataset.ExecSQL;
            end;
          end;
          Node := IncomeTree.GetNext(Node);
        end; // while
        FPCOnnection.Commit
      except
        on e: EZSQLException do begin
          GlobalVars.ShowError(Self, 'Во время записи прихода произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
          FPConnection.Rollback;
          ModalResult := mrCancel;
          Exit;
        end;
      end; // try
    end; // 0:

    1: begin
		  // transaction initialization
			FPMainDataset.SQL.Text := 'START TRANSACTION';
		  try
		  	FPMainDataset.ExecSQL;
	  	except
    		on e: EZSQLException do begin
		    	GlobalVars.ShowError(Self, 'Невозможно заблокировать таблицу. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
					FPMainDataset.SQL.Text := 'ROLLBACK';
			  	FPMainDataset.ExecSQL;
	  	    Exit;
	  	  end;
		  end;

	  	try
	      TmpStr  := GetLinkOfFondByName(DestList, DestCombo.Items[DestCombo.ItemIndex]);
  	// pulling last balance from the asset/fond table
			  FPMainDataset.SQL.Text := 'SELECT balance FROM`' + TmpStr + '`WHERE`index`>1 ORDER BY`index`DESC LIMIT 1';
		    FPMainDataset.Open;
		    NewAccBal := FPMainDataset.FieldByName('balance').AsExtended  + AdvMoneyEdit.Value;

    	  PVTResourceData(DestList[DestCombo.ItemIndex]).balance := NewAccBal;
				if SpecIncCB.Checked then
					IncType	:= 'specinc'
			  else
					IncType	:= TmpStr;

// updating DB
			// updating the aggregate income
	      FPMainDataset.SQL.Text := 'INSERT INTO`' + TmpStr + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`amount`,`price`,`data`,`in`,`out`,`incsrcid`,`pct`)' +
																								    	' VALUES(NULL,NULL,0,:flink,0,:fbal,Now(),:famount,:fprice,:fdescr,:fsum,0,:fincsrcid,:fpct)'; // ,:fSum,0)';
  		  FPMainDataset.ParamByName('flink').AsString  			:= IncType;
    		FPMainDataset.ParamByName('fbal').AsFloat     		:= NewAccBal;
	      FPMainDataset.ParamByName('fDescr').AsString  		:= DescrMemo.Text + ' От дебитора: ' + DebtorCombo.Items[DebtorCombo.ItemIndex];
	      FPMainDataset.ParamByName('famount').AsFloat      := AmountEdit.Value;
  	    FPMainDataset.ParamByName('fprice').AsFloat      	:= PriceEdit.Value;
    	  FPMainDataset.ParamByName('fsum').AsFloat      		:= AdvMoneyEdit.Value;
      	FPMainDataset.ParamByName('fincsrcid').AsInteger	:= IncSrcID;
	      FPMainDataset.ParamByName('fpct').AsFloat      		:= PercentEdit.Value;
  		  FPMainDataset.ExecSQL;
      // updating asset
   		  FondUpdate(TmpStr, NewAccBal);

	      Node := ArrearsTree.GetFirstChild(nil);
  	    while Node <> nil do begin
    	  	NodeData := ArrearsTree.GetNodeData(Node);
      	  if (Node.CheckState = csCheckedNormal) or (AutoCloseCheckBox.Checked and (NodeData.SumToClose > 0)) then begin
      			// Updating data for debtor's arrears
		      	Debt_CalcMO(CurOIPrefix, NodeData.index, NodeData.SumToClose, DayToStr(CurMoment, '-'));
	        end;
  	    	Node	:= ArrearsTree.GetNextSibling(Node);
    	  end;
		  except
		   	on e: EZSQLException do begin
	  		  GlobalVars.ShowError(Self, 'Во время обновления данных произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
					FPMainDataset.SQL.Text := 'ROLLBACK';
    		  FPMainDataset.ExecSQL;
		      ModalResult := mrCancel;
    		  Exit;
		 	  end;
		  end; // try

	  	// commit transaction if everything is OK so far
			FPMainDataset.SQL.Text := 'COMMIT';
  		FPMainDataset.ExecSQL;
    end; // 1:
  end;

  DescrMemo.Clear;

  PriceEdit.Text 		:= '';
  AmountEdit.Text		:= '';
  AdvMoneyEdit.Text := '';
  CurMoment   			:= now;

  AutoCloseCheckBox.Checked := false;
  DebtorComboChange(Sender);
  PriceEdit.SetFocus;

  IncomeTree.Clear;
  ClientsCB.SetFocus;
  GrandTotal := 0;
  SetOKBtn;
end;

procedure TIncomeEnteringForm.PopulateClientsList;
var
  cplink : string;
  pIDX   : ^integer;
begin
  cplink := CurOIPrefix + 'persons';
  FPMainDataset.SQL.Text := 'SELECT idx,FamilyName,FirstName,MiddleName FROM`' + cplink + '`'; //ORDER by FamilyName,FirstName,MiddleName';

  FPMainDataset.Open;

  if FPMainDataset.RecordCount = 0 then begin
    GlobalVars.ShowError(Self, 'Список контрагентов пуст.', 0, '', '');
    FPMainDataset.Close;
    Exit;
  end;

  while not FPMainDataset.Eof do begin
    with FPMainDataset do begin
      ClientsCB.AddItem(FieldByName('FamilyName').AsString + ' ' + FieldByName('FirstName').AsString + ' ' + FieldByName('MiddleName').AsString, TObject(FieldByName('idx').AsInteger));
      Next;
    end;
  end;
  FPMainDataset.Close;
end;

procedure TIncomeEnteringForm.OrgComboChange(Sender: TObject);
var
  ResData  : PVTResourceData;
  i        : integer;
  Str      : string;

  pISID    : ^integer;
  pISPrice : ^extended;

begin
  if OrgCombo.ItemIndex < 0 then
    Exit;

  ResData := PVTResourceData(OrgsList[OrgCombo.ItemIndex]);
  CurOIPrefix := ResData.prefix;

  // test test test
  PopulateClientsList;
  // test test test

  // populating DestCombo
  DestList := TList.Create;
  // cash
  Str := CurOIPrefix + 'asset';
  FPMainDataset.SQL.Text := 'SELECT name,balance FROM ' + CurOIPrefix + 'asset WHERE link="' + CurOIPrefix + CASH_LINK + '"';
  FPMainDataset.Open;

  New(ResData);
  ResData.name    := FPMainDataset.FieldByName('name').AsString;
  ResData.link    := CurOIPrefix + CASH_LINK;
  ResData.sub     := 0;
  ResData.level   := 0;
  ResData.balance := FPMainDataset.FieldByName('balance').AsExtended;
  DestList.Add(ResData);

  // gso
  FPMainDataset.SQL.Text := 'SELECT name,balance FROM '+ CurOIPrefix + 'bank WHERE link="' + CurOIPrefix + BILL1_LINK + '"';
  FPMainDataset.Open;

  New(ResData);
  ResData.name    := Trim(FPMainDataset.FieldByName('name').AsAnsiString); //AsString;
  ResData.link    := CurOIPrefix + BILL1_LINK;
  ResData.sub     := 0;
  ResData.level   := 0;
  ResData.balance := FPMainDataset.FieldByName('balance').AsExtended;
  DestList.Add(ResData);

  DestCombo.Clear;
	for i := 0 to DestList.Count - 1 do begin
  	DestCombo.Items.Add(PVTResourceData(DestList[i]).name);
  end;
  DestCombo.ItemIndex	:= 0;

  VTIncSourcesNames.Clear;
  VTIncSourcesIDs.Clear;
  VTIncSourcesPrices.Clear;

  // pulling Income Sources
  IncSrcCombo.Clear;
  FPMainDataset.SQL.Text  := 'SELECT ID,title,price FROM ' + CurOIPrefix + 'incomesources ORDER BY ID ASC';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    VTIncSourcesNames.Add(FPMainDataset.FieldByName('title').AsString);
    New(pISID);
    pISID^ := FPMainDataset.FieldByName('ID').AsInteger;
    VTIncSourcesIDs.Add(pISID);
    New(pISPrice);
    pISPrice^ := FPMainDataset.FieldByName('price').AsExtended;
    VTIncSourcesPrices.Add(pISPrice);

    FPMainDataset.Next;
  end; // while not ...
  if IncSrcCombo.Items.Count > 0 then begin
  	IncSrcCombo.ItemIndex := 0;
  end
  else begin
  	IncSrcCombo.Enabled := false;
  end;

// pulling debtors if needed
  if TypeCombo.ItemIndex > 0 then
    PullDebtors(Sender);

  SetOKBtn;
end;

procedure TIncomeEnteringForm.PriceEditChange(Sender: TObject);
begin

	AdvMoneyEdit.Value := PriceEdit.Value * AmountEdit.Value;
  AdvMoneyEdit.Repaint;
  if(AdvMoneyEdit.Value >= 0) then begin
  	AdvMoneyEdit.Font.Color := clBlack
  end
  else begin
	  AdvMoneyEdit.Font.Color	:= clRed;
  end;

end;

procedure TIncomeEnteringForm.PriceEditContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
	Handled := true;
end;

procedure TIncomeEnteringForm.PriceEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  TmpFloat 	: extended;
  TmpStr		: string;
begin
//
  if((Chr(Key) in ['v', 'V', 'м', 'М']) and (ssCtrl in Shift)) or ((Key = VK_INSERT) and (ssShift in Shift)) then begin
	  Clipbrd.Clipboard.Open;
  	if (Clipboard.HasFormat(CF_TEXT)) then begin
	    TmpStr	:= Clipbrd.Clipboard.AsText;
	    TmpStr	:= ReplaceStr(TmpStr, CRLF, '');
    	if TryStrToFloat(TmpStr, TmpFloat) then begin
         PriceEdit.Value := TmpFloat;
      end;
    end;
	  Clipbrd.Clipboard.Close;
  end;
end;

procedure TIncomeEnteringForm.PullDebtors(Sender: TObject);
var
  k : integer;
  ResData : PVTResourceData;
  sToCollect  : string;
  sDebtor     : string;
begin

  DebtorList	:= TList.Create;
  DebtorCombo.Clear;
  sToCollect  := CurOIPrefix + 'tocollect';
  sDebtor     := CurOIPrefix + 'debtor';
  FPMainDataset.SQL.Text	:= 'SELECT DISTINCT ' + sToCollect + '.debtor,' + sDebtor + '.name FROM ' + sToCollect + ' INNER JOIN ' + sDebtor + ' ON ' + sToCollect + '.debtor = ' + sDebtor + '.`index`WHERE ' + sToCollect + '.closed>-1 ORDER BY debtor';// LOCK IN SHARE MODE';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    New(ResData);
    ResData.name    := FPMainDataset.FieldByName('name').AsString;
    ResData.index   := FPMainDataset.FieldByName('debtor').AsInteger;
    DebtorList.Add(ResData);
    DebtorCombo.Items.Add(ResData.name);
    FPMainDataset.Next;
  end; // while not ...
  DebtorCombo.ItemIndex := 0;
  DebtorComboChange(Sender);
end;

procedure TIncomeEnteringForm.IncomeLineAddButtonClick(Sender: TObject);
begin
  IncomeLineAdd;
end;

procedure TIncomeEnteringForm.CMDialogKey(var Msg: TWMKEY);
var
  Key : Word;
begin
  if (Msg.Charcode = VK_TAB) then begin
    if IncomeTree.Focused or bEditingIsIP then begin
      IncomeTree.EndEditNode;
      if Assigned(IncomeTree.FocusedNode) and (IncomeTree.FocusedColumn < 2) then begin
        IncomeTree.FocusedColumn  := IncomeTree.Header.Columns.GetNextVisibleColumn(IncomeTree.FocusedColumn, true);
        IncomeTree.EditNode(IncomeTree.FocusedNode, IncomeTree.FocusedColumn);
      end;
    end
    else begin
      inherited;
    end;
  end
  else if msg.CharCode = VK_ESCAPE then begin
    IncomeTree.CancelEditNode;
  end
  else begin
    inherited;
  end;
end;


procedure TIncomeEnteringForm.OnVSTCancelEdit(var Msg: TMessage);
begin
  Application.ProcessMessages;
  IncomeTree.CancelEditNode;
end;

procedure TIncomeEnteringForm.OnVSTEndEdit(var Msg: TMessage);
var
  NodeArray: TNodeArray;
  Node : PVirtualNode;
begin
  Application.ProcessMessages;
  bEditingIsIP := false;
  IncomeTree.EndEditNode;
  if IncomeTree.FocusedColumn < 2 then begin
		IncomeTree.FocusedColumn  := IncomeTree.Header.Columns.GetNextVisibleColumn(IncomeTree.FocusedColumn, true);
    IncomeTree.EditNode(IncomeTree.FocusedNode, IncomeTree.FocusedColumn);
  end;
end;

end.
