unit UserAccessWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, StdCtrls, sButton, ExtCtrls, sPanel, sLabel, sSplitter;

Type
  PUserAccessData = ^TUserAccessData;
  TUserAccessData = record
    RightName   : string;
    AccessKey   : char;
    Enabled     : boolean;
  end;

type
  TUserAccessForm = class(TForm)
    AccessTree: TVirtualStringTree;
    sPanel1: TsPanel;
    SaveButton: TsButton;
    CloseButton: TsButton;
    MainPanel: TsPanel;
    OrgSplitter: TsSplitter;
    OrgsTree: TVirtualStringTree;
    OrgPanel: TsPanel;
    OrgsLabel: TsLabel;
    sPanel4: TsPanel;
    AccessLabel: TsLabel;
    procedure FormCreate(Sender: TObject);
    procedure AccessTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure CloseButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure AccessTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure OrgsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure OrgsTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormShow(Sender: TObject);
    procedure OrgsTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    UpdateIsIP : boolean;
    procedure EnableSubTree(InitNode : PVirtualNode; AEnabled : boolean = true);
    function  FindNode(InitNode : PVirtualNode; AccessRight:char) : PVirtualNode;
    procedure CheckSubTree(InitNode : PVirtualNode; AChecked : Boolean; AEnabled : boolean);
		procedure FlushRights;
    procedure SetUpAccessTree(Node: PVirtualNode);

  public
    { Public declarations }
    AccessRightString : string;
    UserLogin         : string;
    UUUserID          : integer;
    OrgID             : integer;
    procedure SetUpRights;
  end;

//var
//  UserAccessForm: TUserAccessForm;

implementation

{$R *.dfm}

Uses
	ZDbcIntfs,
  GlobalVars;

procedure TUserAccessForm.SetUpAccessTree(Node: PVirtualNode);
begin
  if Node.CheckState = csUncheckedNormal then begin
  	FlushRights;
    AccessTree.Enabled	:= false;
  end
  else begin
	  SetUpRights;
  end;
	AccessTree.Enabled	:= Node.CheckState = csCheckedNormal;
end;

procedure TUserAccessForm.FlushRights;
  procedure FlushBranch(InitNode : PVirtualNode);
  var
    Node : PVirtualNode;
  begin
	  Node   := AccessTree.GetFirstChild(InitNode);
  	while (Node <> nil) do begin
      if (Node.CheckType = ctCheckBox) then
      	Node.CheckState := csUncheckedNormal;
    	if Node.ChildCount > 0 then begin
      	FlushBranch(Node);
	    end;
      AccessTree.RepaintNode(Node);
      Node := AccessTree.GetNextSibling(Node);
	  end; // while Node <> nil ...
  end; // procedure FlushBranch

begin
  FlushBranch(nil);
end;

function TUserAccessForm.FindNode(InitNode : PVirtualNode; AccessRight : char) : PVirtualNode;
var
  Node : PVirtualNode;
begin
  Result := nil;
  Node   := AccessTree.GetFirstChild(InitNode);
  while (Node <> nil) and (Result = nil) do begin
    if PUserAccessData(AccessTree.GetNodeData(Node)).AccessKey = AccessRight then begin
      Result := Node;
      break;
    end;
    if Node.ChildCount > 0 then begin
      Result := FindNode(Node, AccessRight);
    end;
    if Result = nil then
      Node := AccessTree.GetNextSibling(Node);
  end; // while Node <> nil ...
end;

procedure TUserAccessForm.AccessTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  TmpNode : PVirtualNode;
//  TmpNodeData : PUserAccessData;
begin
  if UpdateIsIP then
    Exit;

  if PUserAccessData(AccessTree.GetNodeData(Node)).AccessKey = 'a' then begin
    Node.CheckState := csCheckedNormal;
    TmpNode := FindNode(nil, 'b');
(*
    if Node.CheckState = csCheckedNormal then begin
//      TmpNode.States := TmpNode.States + [vsDisabled];
      EnableSubTree(TmpNode, false);
    end
    else begin
//      TmpNode.States := TmpNode.States - [vsDisabled];
      EnableSubTree(TmpNode, true);
    end;
*)
//    if not (Node.CheckState = csCheckedNormal) then begin
      TmpNode.CheckState := csUncheckedNormal;
      EnableSubTree(TmpNode, false);
//      CheckSubTree(Node, false, false);
      CheckSubTree(TmpNode, false, false);
//    end;
  end
  else if PUserAccessData(AccessTree.GetNodeData(Node)).AccessKey = 'b' then begin
    UpdateIsIP := true;
    TmpNode := FindNode(nil, 'a');
    TmpNode.CheckState := csUncheckedNormal;

    if Node.CheckState = csCheckedNormal then begin
//      EnableSubTree(TmpNode, false);
      CheckSubTree(Node, true, false);
    end
    else begin
//      TmpNode.States := TmpNode.States - [vsDisabled];
//      EnableSubTree(Node, true);
      CheckSubTree(Node, true, true);
    end;

(*
    if Node.CheckState = csCheckedNormal then begin
//      TmpNode.States := TmpNode.States + [vsDisabled];
      TmpNode.CheckState := csUncheckedNormal;
//      EnableSubTree(TmpNode, false);
      CheckSubTree(Node, true, false);
    end
    else begin
//      TmpNode.States := TmpNode.States - [vsDisabled];
//      EnableSubTree(TmpNode, true);
      CheckSubTree(Node, false, true);
    end;
*)
    UpdateIsIP := false;
  end
  else begin
    EnableSubTree(Node, Node.CheckState = csCheckedNormal);
//    CheckSubTree(Node, Node.CheckState = csCheckedNormal, true);
//    CheckSubTree(Node, Node.CheckState = csCheckedNormal, false);
  end;
  AccessTree.Invalidate;
end;

procedure TUserAccessForm.AccessTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  CellText := PUserAccessData(Sender.GetNodeData(Node)).RightName;
end;

procedure TUserAccessForm.CloseButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TUserAccessForm.FormCreate(Sender: TObject);
	function GetPONode(ANode : PVirtualNode; APID : integer) : PVirtualNode;
	var
		TN : PVirtualNode;
	  RN : PVirtualNode;
  	OD : POrgData;
	begin

		RN := nil;
		TN := OrgsTree.GetFirstChild(ANode);

		while TN <> nil do begin
  		OD := OrgsTree.GetNodeData(TN);
	    if OD.ID = APID then begin
  	  	RN := TN;
    	  Break;
	    end
  	  else if TN.ChildCount > 0 then begin
    	  RN := GetPONode(TN, APID);
      	if RN <> nil then begin
      		break
	      end;
  	  end;
    	TN := OrgsTree.GetNextSibling(TN);
	  end; // while
  	Result := RN;
	end;

var
  NewNode       : PVirtualNode;
  NewNodeData   : PUserAccessData;
  NewNode2      : PVirtualNode;
  NewNodeData2  : PUserAccessData;
  NewNode3      : PVirtualNode;
  NewNodeData3  : PUserAccessData;
  NewNode4      : PVirtualNode;
  NewNodeData4  : PUserAccessData;
  NewNode11     : PVirtualNode;
  NewNodeData11 : PUserAccessData;

  OData		: POrgData;
  ONode		: PVirtualNode;
  PONode	: PVirtualNode;
  PID			: integer;

begin
  UpdateIsIP := false;
  AccessTree.Align := alClient;
  AccessTree.NodeDataSize := SizeOf(TUserAccessData);
  // Filling the Access tree

  NewNode               := AccessTree.AddChild(nil);
  NewNode.CheckType     := ctCheckBox;
  NewNodeData           := AccessTree.GetNodeData(NewNode);
  NewNodeData.RightName := 'Только подача заявок';
  NewNodeData.AccessKey := 'a';

  NewNode               := AccessTree.AddChild(nil);
  NewNodeData           := AccessTree.GetNodeData(NewNode);
  NewNodeData.RightName := 'Полный доступ';
  NewNodeData.AccessKey := 'b';
  NewNode.CheckType     := ctCheckBox; //ctTriStateCheckBox;

  NewNode3              := AccessTree.AddChild(NewNode);
  NewNodeData3           := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName := 'Просмотр прихода';
  NewNodeData3.AccessKey := 'z';
  NewNode3.CheckType    := ctCheckBox;

  NewNode2                := AccessTree.AddChild(NewNode);
  NewNodeData2            := AccessTree.GetNodeData(NewNode2);
  NewNodeData2.RightName  := 'Панель';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Запись прихода';
  NewNodeData3.AccessKey  := 'd';
  NewNode3.CheckType := ctCheckBox;

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Проведение расходов';
  NewNodeData3.AccessKey  := 'f';
  NewNode3.CheckType := ctCheckBox;

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Перевод собственных средств';
  NewNodeData3.AccessKey  := 'h';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Редактирование источников дохода';
  NewNodeData3.AccessKey  := 'y';

  NewNode11                := AccessTree.AddChild(NewNode);
  NewNodeData11            := AccessTree.GetNodeData(NewNode11);
  NewNodeData11.RightName  := 'Меню';

  NewNode2                := AccessTree.AddChild(NewNode11);
  NewNode2.CheckType      := ctCheckBox;
  NewNodeData2            := AccessTree.GetNodeData(NewNode2);
  NewNodeData2.RightName  := 'Доступ к меню';
  NewNodeData2.AccessKey  := 'e';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Работа с фондами/активами учредителя';
  NewNodeData3.AccessKey  := '0';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Просмотр активов';
  NewNodeData3.AccessKey  := 'g';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Создание активов';
  NewNodeData4.AccessKey  := 'k';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Просмотр фондов';
  NewNodeData3.AccessKey  := 'i';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Создание фондов и перенос их в архив/из архива';
  NewNodeData4.AccessKey  := 'x';
  NewNode4.CheckType      := ctCheckBox;

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Просмотр финансового планирования';
  NewNodeData3.AccessKey  := 'm';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Создание нового ФП';
  NewNodeData4.AccessKey  := 'o';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Изменение ФП';
  NewNodeData4.AccessKey  := 'q';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Одобрение ФП';
  NewNodeData4.AccessKey  := 's';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Одобрение срочных заявок';
  NewNodeData4.AccessKey  := 'u';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Поиск';
  NewNodeData3.AccessKey  := 'j';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Просмотр заявок';
  NewNodeData3.AccessKey  := 'l';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Управление доступом';
  NewNodeData3.AccessKey  := 'n';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Просмотр дебиторов';
  NewNodeData3.AccessKey  := 'p';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Создание дебиторов';
  NewNodeData4.AccessKey  := 'r';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Дебетование';
  NewNodeData4.AccessKey  := 'w';

  NewNode3                := AccessTree.AddChild(NewNode2);
  NewNode3.CheckType      := ctCheckBox;
  NewNodeData3            := AccessTree.GetNodeData(NewNode3);
  NewNodeData3.RightName  := 'Просмотр кредиторов';
  NewNodeData3.AccessKey  := 't';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Создание кредиторов';
  NewNodeData4.AccessKey  := 'v';

  NewNode4                := AccessTree.AddChild(NewNode3);
  NewNode4.CheckType      := ctCheckBox;
  NewNodeData4            := AccessTree.GetNodeData(NewNode4);
  NewNodeData4.RightName  := 'Кредитование';
  NewNodeData4.AccessKey  := 'c';

  AccessTree.FullExpand;

(* // don't need it right now but we'll need it later DEFINITELY
	OrgsTree.NodeDataSize	:= SizeOf(TOrgData);

  FPMainDataset.SQL.Text := 'SELECT ID,SeniorID,Abbr,Prefix FROM orgs ORDER BY SeniorID,ID ASC';
  FPMainDataset.Open;

  while not FPMainDataset.Eof do begin

  	PID	:= FPMainDataset.FieldByName('SeniorID').AsInteger;
    if PID = 0 then begin
    	PONode := nil
    end
    else begin
//      PONode := GetPONode(OrgsTree.RootNode, PID);
      PONode := GetPONode(nil, PID);
    end;

		ONode						:= OrgsTree.AddChild(PONode);
	  ONode.CheckType := ctCheckBox;

  	OData						:= OrgsTree.GetNodeData(ONode);
	  OData.ID				:= FPMainDataset.FieldByName('id').AsInteger;
	  OData.ShortName	:= FPMainDataset.FieldByName('Abbr').AsString;
    OData.Prefix    := FPMainDataset.FieldByName('Prefix').AsString;

    FPMainDataset.Next;
  end;

  OrgsTree.FullExpand;
*)
	OrgPanel.Visible		:= false;
  OrgSplitter.Visible	:= false;
  AccessLabel.Visible	:= false;

end;

procedure TUserAccessForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin ModalResult := mrCancel; Key := 0; end;
  end;
end;

procedure TUserAccessForm.FormShow(Sender: TObject);
var
	PONode : PVirtualNode;
begin

//	if AccessRightString = 'a' then begin
//
//  end
//  else if AccessRightString = 'b' then begin
//
//  end;

end;

procedure TUserAccessForm.OrgsTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data : POrgData;
begin
	if Node = nil then
  	Exit;

  Data := Sender.GetNodeData(Node);
	AccessRightString := Data.FPPrivs;

  SetUpAccessTree(Node);

end;

procedure TUserAccessForm.OrgsTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
	if Node = OrgsTree.GetFirstSelected then
		SetUpAccessTree(Node);
end;

procedure TUserAccessForm.OrgsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  OData	: POrgData;
begin
	CellText := '';

  if Node = nil then
  	Exit;

	OData := Sender.GetNodeData(Node);
  CellText := OData.ShortName;
end;

procedure TUserAccessForm.SetUpRights;
var
  i: integer;
  Node  : PVirtualNode;
  TmpNode : PVirtualNode;
begin
	FlushRights;

  if AccessRightString = 'a' then begin
    UpdateIsIP := true;
    Node := FindNode(nil, AccessRightString[1]);
    if Node <> nil then
      Node.CheckState := csCheckedNormal;

//    Node.CheckState := csCheckedNormal;
    TmpNode := FindNode(nil, 'b');
    TmpNode.CheckState := csUncheckedNormal;
    EnableSubTree(TmpNode, false);
    CheckSubTree(TmpNode, false, false);
    UpdateIsIP := false;
  end
  else if AccessRightString = 'b' then begin
    UpdateIsIP := true;

    Node := FindNode(nil, AccessRightString[1]);
    if Node <> nil then
      Node.CheckState := csCheckedNormal;

    TmpNode := FindNode(nil, 'a');
    TmpNode.CheckState := csUncheckedNormal;

//    if Node.CheckState = csCheckedNormal then begin
    CheckSubTree(Node, true, false);
//    end
//    else begin
//      CheckSubTree(Node, true, true);
//    end;
    UpdateIsIP := false;
  end
  else begin


  for i := 1 to Length(AccessRightString) do begin
    Node := FindNode(nil, AccessRightString[i]);
    if Node <> nil then
      Node.CheckState := csCheckedNormal;
  end;
  end;
end;

procedure TUserAccessForm.SaveButtonClick(Sender: TObject);
  procedure CompileAccessString(InitNode : PVirtualNode; var AAccessString : string);
  var
    Node : PVirtualNode;
  begin
    Node := AccessTree.GetFirstChild(InitNode);
    while Node <> nil do begin
      if (Node.CheckType = ctCheckBox) and (Node.CheckState = csCheckedNormal) and (not (vsDisabled in Node.States)) then
        AAccessString := AAccessString + PUserAccessData(AccessTree.GetNodeData(Node)).AccessKey;
      if Node.ChildCount > 0 then
        CompileAccessString(Node, AAccessString);
      Node := AccessTree.GetNextSibling(Node);
    end;
  end; // procedure CompileAccessString

var
  TmpNode       : PVirtualNode;
  ErrorMessage  : string;
  NoError       : boolean;
begin
  AccessRightString := '';
  TmpNode := FindNode(nil, 'a');
  if TmpNode.CheckState = csCheckedNormal then
    AccessRightString := 'a'
  else begin
    TmpNode := FindNode(nil, 'b');
    if TmpNode.CheckState = csCheckedNormal then
      AccessRightString := 'b'
    else
      CompileAccessString(TmpNode, AccessRightString);
  end;
  if AccessRightString <> '' then begin

    NoError := true;

    try
      FPMainDataset.SQL.Text := 'BEGIN';
      FPMainDataset.ExecSQL;
    	FPMainDataset.SQL.Text := 'INSERT INTO uofp(`UserID`,`OrgID`,`FPPrivs`)VALUES(:fUserID,:fOrgID,:fFPPrivs)ON DUPLICATE KEY UPDATE FPPrivs=:fFPPrivs';
	    FPMainDataset.ParamByName('fUserID').AsInteger := UUUserID;
  	  FPMainDataset.ParamByName('fOrgID').AsInteger  := OrgID;
      FPMainDataset.ParamByName('fFPPrivs').AsString := AccessRightString;
      FPMainDataset.ExecSQL;

      FPMainDataset.SQL.Text := 'COMMIT';
      FPMainDataset.ExecSQL;
    except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'При сохранении информации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
	    end;
    end;

    if NoError  then begin
      Application.MessageBox('Изменение прав прошло успешно.', 'Завершение операции', MB_OK or MB_ICONINFORMATION);
      ModalResult := mrOk;
    end
    else begin
      try
        FPMainDataset.SQL.Text := 'ROLLBACK';
        FPMainDataset.ExecSQL;
      finally

      end;
    end;
  end;
end;

Procedure TUserAccessForm.EnableSubTree(InitNode : PVirtualNode; AEnabled : boolean = true);
Var
  Node : PVirtualNode;
begin
  Node := AccessTree.GetFirstChild(InitNode);
  while Node <> nil do begin
    if Node.ChildCount > 0 then
      EnableSubTree(Node, AEnabled);
    if AEnabled then
      Node.States := Node.States - [vsDisabled]
    else begin // if we're disabling it, we're unchecking it;
      Node.States := Node.States + [vsDisabled];
      Node.CheckState := csUncheckedNormal;
    end;
    Node := AccessTree.GetNextSibling(Node);
  end;

end;

Procedure TUserAccessForm.CheckSubTree(InitNode : PVirtualNode; AChecked : Boolean; AEnabled : boolean);
Var
  Node : PVirtualNode;
begin
  Node := AccessTree.GetFirstChild(InitNode);
  while Node <> nil do begin
    if Node.CheckType = ctCheckBox then begin
      if AChecked then
        Node.CheckState := csCheckedNormal
      else
        Node.CheckState := csUncheckedNormal;
      if (AEnabled) then
        Node.States := Node.States - [vsDisabled]
      else
        Node.States := Node.States + [vsDisabled];
      end;
    if (Node.CheckType = ctCheckBox) and ((InitNode.CheckType = ctCheckBox)and(Node.CheckState = csUncheckedNormal)) then
      Node.States := Node.States + [vsDisabled];
    if Node.ChildCount > 0 then
      CheckSubTree(Node, AChecked, AEnabled);
    Node := AccessTree.GetNextSibling(Node);
  end;

end;

end.
