unit IncomeSourceEditWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sMemo, sLabel, sEdit, ExtCtrls, sPanel, sButton,
  GlobalVars,
  VirtualTrees, AdvEdit;

type

  TIncomeSourceEditForm = class(TForm)
    OKButton: TsButton;
    CancelButton: TsButton;
    Panel: TsPanel;
    Tree: TVirtualStringTree;
    procedure TitleEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure TreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure TreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure TreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
  private
    { Private declarations }
    procedure OnVSTEndEdit(var Msg: TMessage); message UM_VST_END_EDIT;
    procedure SetOKButton;
  public
    { Public declarations }
  protected
    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
  public
    IncomeSourceData : TIncSrcData;
  end;

var
  IncomeSourceEditForm: TIncomeSourceEditForm;

implementation

{$R *.dfm}

uses
  VTIncomeSourceCustomEditor;

procedure TIncomeSourceEditForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ORD(Key) = VK_ESCAPE then begin
    ModalResult := MrCancel;
  end
end;

procedure TIncomeSourceEditForm.FormShow(Sender: TObject);
var
  Node: PVirtualNode;
  NodeData : PIncomeSourceProperty;
begin
	SetOKButton;

  Tree.NodeDataSize := SizeOf(TIncomeSourceProperty);

  Node := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(Node);
  NodeData.kind := 'name';
  NodeData.name := 'Статья';
  NodeData.description := IncomeSourceData.Title;

  Node := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(Node);
  NodeData.kind := 'price';
  NodeData.name := 'Цена';
  NodeData.price := IncomeSourceData.Price;

  Node := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(Node);
  NodeData.kind := 'descr';
  NodeData.name := 'Описание';
  NodeData.description := IncomeSourceData.Descr;


end;

procedure TIncomeSourceEditForm.SetOKButton;
begin
//	OKButton.Enabled := (TitleEdit <> nil) and (TitleEdit.Text <> '');
end;

procedure TIncomeSourceEditForm.CMDialogKey(var Msg: TWMKEY);
var
  Key : Word;
begin
  if (Msg.Charcode = VK_TAB) then begin
    Tree.EndEditNode;
  end;
  inherited;
end;


procedure TIncomeSourceEditForm.TitleEditChange(Sender: TObject);
begin
	SetOKButton;
end;

procedure TIncomeSourceEditForm.TreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin

  with Sender do begin
    if Assigned(Node) then begin
      Tree.EditNode(Node, 1);
    end;
  end;

end;

procedure TIncomeSourceEditForm.TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
 EditLink := TVTIncomeSourceCustomEditor.Create;
end;

procedure TIncomeSourceEditForm.TreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
	Allowed := (Column = 1); // and (Node = PANode);
end;

procedure TIncomeSourceEditForm.TreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  TreeChange(Sender,Node);
  inherited;
end;

procedure TIncomeSourceEditForm.TreeFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
begin
//  Tree.EndEditNode;
  inherited;
end;

procedure TIncomeSourceEditForm.TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  NodeData : PIncomeSourceProperty;
begin
  NodeData := Sender.GetNodeData(Node);
  if NodeData <> nil then begin
    if Column = 0 then begin
      CellText := NodeData.name;
    end
    else begin
      if (NodeData.kind = 'name') then begin
        CellText := NodeData.description;
      end
      else if NodeData.kind = 'price' then begin
        CellText := MyFloatToStr(NodeData.Price);
      end
      else if NodeData.kind = 'descr' then begin
        CellText := NodeData.description;
      end;
    end;
  end;
end;

procedure TIncomeSourceEditForm.OnVSTEndEdit(var Msg: TMessage);
var
  NodeArray: TNodeArray;
  Node : PVirtualNode;
begin
  Tree.EndEditNode;
  NodeArray := Tree.GetSortedSelection(false);
  if (0 < Length(NodeArray)) then begin
    Node := NodeArray[Low(NodeArray)];
    Tree.ClearSelection;
    Node := Tree.GetNextSibling(Node);
    Tree.Selected[Node] := true;
  end;
end;


procedure TIncomeSourceEditForm.TreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  NodeData : PIncomeSourceProperty;
begin
  NodeData := Sender.GetNodeData(Node);
  if NodeData.kind = 'price' then begin
    NodeData.Price := StrToInt(NewText);
    IncomeSourceData.Price := NodeData.Price;
  end
  else begin
    NodeData.description := NewText;
    if NodeData.kind = 'name' then begin
      IncomeSourceData.Title := NodeData.description;
    end
    else if NodeData.kind = 'descr' then begin
      IncomeSourceData.Descr := NodeData.description;
    end
  end;
end;

end.
