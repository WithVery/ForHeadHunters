unit AssetVsFundsWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  Dialogs, StdCtrls, sButton, sListBox, sLabel, sComboBox, ExtCtrls, sPanel, VirtualTrees;

type
	PAVFN = ^TAVFN;
  TAVFN = record
    link    : string;
    name    : string;
    balance : extended;
  end;

  TAssetVsFundsForm = class(TForm)
    Tree: TVirtualStringTree;
    procedure FormShow(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure TreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure TreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure TreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    PANode : PVirtualNode;
    CurAssetIndex : integer;
    CurAssetName  : string;
    procedure AssetWasChanged(var Msg: TMessage); message UM_AVF_ASSETCHANGED;
    procedure AssetChanged;
  public
    { Public declarations }
    DefAssName	: string;
    DefAssLink	: string;
    AssetList		: TList;
    FundList		: TList;
    AvFPrefix   : string;
    wfndfnd     : boolean;
  end;

implementation

uses
  ClipBrd,
	VTCustomEditor;//,
//	GlobalVars;

{$R *.dfm}
procedure TAssetVsFundsForm.AssetWasChanged(var Msg: TMessage);
begin
  AssetChanged;
end;

procedure TAssetVsFundsForm.AssetChanged;
var
	CurAssetLink : string;
  CurItem			: integer;
  Node : PVirtualNode;
  NodeData : PAVFN;
  ABalance : extended;
  FBalance : extended;
begin
//	FundsList.Clear;
//  CurItem	:= AssetCombo.ItemIndex;
  CurItem	:= CurAssetIndex;
  if CurItem < 0 then
  	Exit;
  CurAssetLink := PVTResourceData(AssetList[CurAssetIndex]).link; // GetLinkOfFondByName(AssetList, AssetCombo.Items[CurItem]);
  FBalance := 0;
  //
  // Tree initialization
  //
  Tree.Clear;

  Tree.NodeDataSize := SizeOf(TAVFN);
  Node := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(Node);
  NodeData.link := 'aname';
  NodeData.name := 'Актив';

  PANode := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(PANode);
  NodeData.link := CurAssetLink;
  CurAssetName := PVTResourceData(AssetList[CurAssetIndex]).name;
  NodeData.name := CurAssetName;
  ABalance := PVTResourceData(AssetList[CurAssetIndex]).balance;
  NodeData.balance := ABalance;

  Node := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(Node);
  NodeData.link := 'fname';
  NodeData.name := 'Фонды';

	FPMainDataset.SQL.Text := 'SELECT fundlink FROM ' + AvFPrefix + 'fundsvsassets LEFT JOIN ' + AvFPrefix + 'fond ON fundlink = link WHERE assetlink=:fAssetLink AND arched=0';
  FPMainDataset.ParamByName('fAssetLink').AsString := CurAssetLink;
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
	  Node := Tree.AddChild(nil);
  	NodeData := Tree.GetNodeData(Node);
	  NodeData.link := FPMainDataset.FieldByName('fundlink').AsString;
  	NodeData.name := GetNameOfFondByLink(FundList, NodeData.link);
  	NodeData.balance :=  GetBalanceOfFondByLink(FundList, NodeData.link);
    FBalance := FBalance + NodeData.balance;
    FPMainDataset.Next;
  end;

  Node := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(Node);
  NodeData.link := 'ftot';
  NodeData.name := 'Итого по фондам';
 	NodeData.balance :=  FBalance;

  Node := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(Node);
  NodeData.link := 'bal';
  NodeData.name := 'Баланс по Активу';
  NodeData.balance := ABalance - FBalance;
end;

procedure TAssetVsFundsForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_ESCAPE then
  	CloseButtonClick(Sender);
end;

procedure TAssetVsFundsForm.FormShow(Sender: TObject);
var
	i	: integer;
  Node : PVirtualNode;
  NodeData : PAVFN;
begin
	Tree.Align := alClient;
	AssetList := CompFondList(AvFPrefix + 'bank', 0, CFL_WITHGROUPS, CFL_IGNOREPOS, AvFPrefix);
	FundList 	:= CompFondList(AvFPrefix + 'fond', 0, CFL_WITHGROUPS, CFL_IGNOREPOS, AvFPrefix, true); // it's processed in AssetComboChange function (?)
	for I := 0 to AssetList.Count - 1 do begin
 		if (PVTResourceData(AssetList[i]).name = DefAssName) then CurAssetIndex := i;
  end;
	AssetChanged;
end;

procedure TAssetVsFundsForm.TreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin

  with Sender do begin
    if Assigned(Node) then begin
      Tree.EditNode(Node, 1);
    end;
  end;
end;

procedure TAssetVsFundsForm.TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
var
	i : integer;
begin
  EditLink := TVTCustomEditor.Create;
	VTCEAssetList := TStringList.Create;
	for I := 0 to AssetList.Count - 1 do begin
 		if (PVTResourceData(AssetList[i]).link <> AvFPrefix + BILL1_LINK)
{$IFDEF FAFH}
    and (wfndfnd or (not (wfndfnd or PVTResourceData(AssetList[i]).fnd)))
{$ENDIF}
    then
    	VTCEAssetList.Add(PVTResourceData(AssetList[i]).name);
  end;
end;

procedure TAssetVsFundsForm.TreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
	Allowed := (Column = 0) and (Node = PANode);
end;

procedure TAssetVsFundsForm.TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
	NodeData : PAVFN;
begin
	if assigned(Node) then begin
		NodeData := Sender.GetNodeData(Node);
		case Column of
    	0 : begin
      	CellText := NodeData.Name
	    end;
  	  1 : begin
    		if (NodeData.link = 'aname') or ((NodeData.link = 'fname')) then cellText := ''
      	else CellText := MyFloatToStr(NodeData.balance);
	    end;
  	end;
  end;
end;

procedure TAssetVsFundsForm.TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Node : PVirtualNode;
  Data : PAVFN;
  Str  : string;

begin
  if ((Key = VK_INSERT) or (Char(Key) = 'C') or (Char(Key) = 'c')) and ([ssCtrl] = Shift) then begin
  	str := '';
    Node := Tree.GetFirstChild(nil);
    while Node <> nil do begin
      Data := Tree.GetNodeData(Node);
      Str := Str + Data.name + #9;
      if not((Data.link = 'aname') or (Data.link = 'fname')) then
      	Str := Str + MyCleanStr(MyFloatToStr(Data.balance));
      Str := Str + #$D#$A;
      Node := Tree.GetNextSibling(Node);
    end;
    if Str <> '' then Clipboard.SetTextBuf(PWideChar(Str));
  end;
end;

procedure TAssetVsFundsForm.TreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  VTEditNode: PAVFN;
  i : integer;
begin
  VTEditNode := Sender.GetNodeData(Node);
  if CurAssetName <> NewText then begin
		for i := 0 to AssetList.Count - 1 do begin
 			if (PVTResourceData(AssetList[i]).name = NewText) then CurAssetIndex := i;
	  end;
  	PostMessage(self.Handle, UM_AVF_ASSETCHANGED, 0, 0);
  end;
end;

procedure TAssetVsFundsForm.TreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
Var
  NodeData : PAVFN;
begin
  NodeData := Sender.GetNodeData(Node);
	if (NodeData.link = 'aname') or (NodeData.link = 'fname') or (NodeData.link = 'ftot') or (NodeData.link = 'bal') then TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
end;

procedure TAssetVsFundsForm.CloseButtonClick(Sender: TObject);
begin
	ModalResult := mrCancel;
end;

end.
