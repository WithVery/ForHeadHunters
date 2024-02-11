unit UsersWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  PwdChangeWindow,
  UserAccessWindow,
  UserEditWindow,
  Dialogs, ImgList, acAlphaImageList, ComCtrls, ToolWin, sToolBar, VirtualTrees,
  ExtCtrls, sPanel, System.ImageList;

type
  TUsersForm = class(TForm)
    UsersList: TVirtualStringTree;
    ToolBar: TsToolBar;
    NewUserToolButton: TToolButton;
    AccessSetUpToolButton: TToolButton;
    ImagesList: TsAlphaImageList;
    ChangeUserPwdToolButton: TToolButton;
    UserEditToolButton: TToolButton;
    UserDelToolButton: TToolButton;
    ToOtherOrgToolButton: TToolButton;
    sPanel1: TsPanel;
    procedure FormCreate(Sender: TObject);
    procedure UsersListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure UsersListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure AccessSetUpToolButtonClick(Sender: TObject);
    procedure ChangeUserPwdToolButtonClick(Sender: TObject);
    procedure NewUserToolButtonClick(Sender: TObject);
    procedure UserEditToolButtonClick(Sender: TObject);
    procedure UserDelToolButtonClick(Sender: TObject);
    procedure UsersListDblClick(Sender: TObject);
    procedure UsersListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UsersListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToOtherOrgToolButtonClick(Sender: TObject);
  private
    { Private declarations }
    CurNode       : PVirtualNode;
    PwdChangeForm : TPwdChangeForm;
    UserAccessForm: TUserAccessForm;
    MX, MY        : integer;
    procedure EnableBtns;
  public
    { Public declarations }
    UPrefix : string;
	  UOrgID  : integer;
    procedure InitForm;
  end;

//var
//  UsersForm: TUsersForm;

implementation

{$R *.dfm}
Uses
  UserOrgTransferWindow,
	StrUtils,
  GlobalVars;

procedure TUsersForm.InitForm;
var
  NewNode     : PVirtualNode;
  NewNodeData : PUserData;
begin

  UsersList.TreeOptions.AutoOptions := UsersList.TreeOptions.AutoOptions - [toAutoSort];
  UsersList.Align := alClient;
  UsersList.NodeDataSize  := SizeOf(TUserData);

  FPMainDataset.SQL.Text := 'SELECT * FROM (SELECT users.UserID AS UID,users.login,users.FirstNAme,users.MiddleName,users.FamilyName,uofp.FPPrivs FROM users LEFT JOIN uofp USING (UserID) WHERE OrgID=:fOrgID)' +
  'AS tb2 LEFT JOIN (SELECT ' + UPrefix + 'postsdir.ID AS PostID,Abbr,tbl2.UserID AS UID FROM ' + UPrefix + 'postsdir LEFT JOIN ' +
  '(SELECT PostID,UserID FROM ' + UPrefix + 'psts LEFT JOIN (SELECT pstsid,userid FROM ' + UPrefix + 'pstsfills LEFT JOIN users USING(UserID)WHERE(Now()>=startdate)AND((Now()<enddate)or(enddate is NULL))) AS tbl1 ' +
  'ON tbl1.pstsid=' + UPrefix + 'psts.id)AS tbl2 ON tbl2.PostID=' + UPrefix + 'postsdir.ID) AS tb3 USING(UID)';// LOCK IN SHARE MODE';
  FPMAinDataset.ParamByName('fOrgId').AsInteger := UOrgID;

  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    NewNode             		:= UsersList.AddChild(nil);
    NewNodeData         		:= UsersList.GetNodeData(NewNode);
    NewNodeData.Index				:= FPMainDataset.FieldByName('UID').AsInteger;
    NewNodeData.FirstName		:= FPMainDataset.FieldByName('FirstName').AsString;
    NewNodeData.MiddleName	:= FPMainDataset.FieldByName('MiddleName').AsString;
    NewNodeData.FamilyName	:= FPMainDataset.FieldByName('FamilyName').AsString;
    NewNodeData.Name				:= GetShortFIO(NewNodeData.FamilyName, NewNodeData.FirstName, NewNodeData.MiddleName);
    NewNodeData.Login   		:= FPMainDataset.FieldByName('Login').AsString;
    NewNodeData.Post    		:= FPMainDataset.FieldByName('Abbr').AsString;
    NewNodeData.Access  		:= FPMainDataset.FieldByName('FPPrivs').AsString;
    FPMainDataset.Next;
  end;

  UsersList.SortTree(0, sdAscending);

end;

procedure TUsersForm.AccessSetUpToolButtonClick(Sender: TObject);
var
  TmpOrgID  : integer;
begin
  UserAccessForm:= TUserAccessForm.Create(Self);
  UserAccessForm.Caption           := 'Права доступа : ' + PUserData(UsersList.GetNodeData(CurNode)).Name;
  UserAccessForm.UUUserID          := PUserData(UsersList.GetNodeData(CurNode)).Index;
  UserAccessForm.Userlogin         := PUserData(UsersList.GetNodeData(CurNode)).Login;
  UserAccessForm.AccessRightString := PUserData(UsersList.GetNodeData(CurNode)).Access;
  UserAccessForm.OrgID             := UOrgID;

  UserAccessForm.SetUpRights;
  if UserAccessForm.ShowModal = mrOK then begin
    PUserData(UsersList.GetNodeData(CurNode)).Access  := UserAccessForm.AccessRightString;
    UsersList.RepaintNode(CurNode);
  end;
  UserAccessForm.Free;
end;

procedure TUsersForm.ChangeUserPwdToolButtonClick(Sender: TObject);
var
  PwdChangeForm: TPwdChangeForm;
begin
    PwdChangeForm := TPwdChangeForm.Create(Self);
    PwdChangeForm.Caption := 'Смена пароля: ' + PUSerData(UsersList.GetNodeData(CurNode)).Name;
    PwdChangeForm.Login   := PUSerData(UsersList.GetNodeData(CurNode)).Login;
    PwdChangeForm.User    := PUserData(UsersList.GetNodeData(CurNode)).Name;
    PwdChangeForm.ShowModal;
    PwdChangeForm.Free;
end;

procedure TUsersForm.EnableBtns;
begin
  UserEditToolButton.Enabled   		:= CurNode <> nil;
  UserDelToolButton.Enabled   		:= CurNode <> nil;
  AccessSetUpToolButton.Enabled   := CurNode <> nil;
  ChangeUserPwdToolButton.Enabled := CurNode <> nil;
  ToOtherOrgToolButton.Enabled    := CurNode <> nil;
end;

procedure TUsersForm.FormCreate(Sender: TObject);
var
  NewNode     : PVirtualNode;
  NewNodeData : PUserData;
begin
//
//

end;

procedure TUsersForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin ModalResult := mrCancel; Key := 0; end;
  end;
end;

procedure TUsersForm.NewUserToolButtonClick(Sender: TObject);
var
  UserEditForm  : TUserEditForm;
  Node 			    : PVirtualNode;
  NodeData    	: PUserData;
//  index		    	: integer;
begin
	UserEditForm := TUserEditForm.Create(nil);
  UserEditForm.Caption := 'Новый пользователь';
  USerEditForm.UEPrefix := UPrefix;
  UserEditForm.UEOID    := UOrgID;
  UserEditForm.PostCombo.Clear;

  // Setting up Posts combo
  FPMainDataset.SQL.Text := 'SELECT Abbr FROM ' + UPrefix + 'postsdir';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    UserEditForm.PostCombo.Items.Add(FPMainDataset.FieldByName('Abbr').AsString);
    FPMainDataset.Next;
  end;

  UserEditForm.PostCombo.ItemIndex := 0;
  UserEditForm.UpdateUser          := false;
  UserEditForm.SetOKButton;
  UserEditForm.ShowModal;

  if UserEditForm.UpdOK then begin
  	Node 								:= UsersList.AddChild(nil);
    NodeData						:= UsersList.GetNodeData(Node);
    NodeData.Index      := UserEditForm.NewUserID;
    NodeData.Login			:= UserEditForm.LoginEdit.Text;
    NodeData.Access			:= 'a';
	  NodeData.FirstName	:= MyFirstLetterUp(UserEditForm.FirstNameEdit.Text);
  	NodeData.MiddleName	:= MyFirstLetterUp(UserEditForm.MiddleNameEdit.Text);
	  NodeData.FamilyName	:= MyFirstLetterUp(UserEditForm.FamilyNameEdit.Text);
  	NodeData.Name				:= GetShortFIO(NodeData.FamilyName, NodeData.FirstName, NodeData.MiddleName);
	  NodeData.Post				:= MyFirstLetterUp(UserEditForm.PostCombo.Text);

    UsersList.ClearSelection;
    UsersList.Selected[Node] 	:= true;
    UsersList.FocusedNode			:= Node;
    UsersList.SortTree(0, sdAscending);
    USersList.ScrollIntoView(Node, false);
  end;
end;

procedure TUsersForm.ToOtherOrgToolButtonClick(Sender: TObject);
var
	Node			: PVirtualNode;
  NodeData	: PUserData;
  UOTF: TUserOrgTransferForm;
  COID  : integer;
begin
	Node := UsersList.GetFirstSelected;
  if Node = nil then
  	Exit;

  NodeData := UsersList.GetNodeData(Node);
  UOTF := TUserOrgTransferForm.Create(nil);
  UOTF.CurOrgID  := UOrgID;
  UOTF.CurUserID := NodeData.Index;
  UOTF.InitForm;
  UOTF.Caption := 'Добавить пользователя "' + NodeDAta.Name + '" в организации';
  UOTF.ShowModal;
  UOTF.Free;
end;

procedure TUsersForm.UserDelToolButtonClick(Sender: TObject);
var
	Node			: PVirtualNode;
  NodeData	: PUserData;
  index			: integer;
  Error			: boolean;
begin
	Node := UsersList.GetFirstSelected;
  if Node = nil then
  	Exit;

	if (IDYES <> Application.MessageBox(PWideChar('Этот пользователь больше не сможет войти в систему.' + CRLF + 'Удалить?'),
  							'Удаление пользователя', MB_ICONWARNING or MB_YESNO)) then
  	Exit;

  NodeData := USersList.GetNodeData(Node);
  index := NodeData.Index;
  FPMainDataset.SQL.Text := 'START TRANSACTION';
  FPMainDataset.ExecSQL;

  Error := false;
  FPMainDataset.SQL.Text := 'INSERT INTO usersdeled SELECT * FROM users WHERE UserID=:fIndex';
  FPMainDataset.ParamByName('fIndex').AsInteger := index;

  try
	  FPMainDataset.ExecSQL;
  except
	  Error := true;
  end;

  if not Error then begin
	  FPMainDataset.SQL.Text := 'DELETE FROM users WHERE UserID=:fIndex';
  	FPMainDataset.ParamByName('fIndex').AsInteger := index;
	  try
		  FPMainDataset.ExecSQL;
	  except
		  Error := true;
	  end;
  end;

  if not Error then
	  FPMainDataset.SQL.Text := 'COMMIT'
  else
	  FPMainDataset.SQL.Text := 'ROLLBACK';

  try
    FPMainDataset.ExecSQL;
  finally

  end;

  if Error then begin
		Application.MessageBox('При удалении пользователя произошла ошибка.' + #13 + 'Обратитесь к разработчикам.', 'Удаление пользователя', MB_ICONWARNING or MB_OK);
    Exit;
  end;
  UsersList.DeleteNode(Node);
  CurNode := UsersList.GetFirstSelected;
  EnableBtns;
end;

procedure TUsersForm.UserEditToolButtonClick(Sender: TObject);
var
  Node 		    	: PVirtualNode;
  NodeData    	: PUserData;
//  index		    	: integer;
  UserEditForm  : TUserEditForm;
begin
  Node := UsersList.GetFirstSelected;
  if Node = nil then
  	Exit;

  NodeData 													:= UsersList.GetNodeData(Node);

	UserEditForm 											:= TUserEditForm.Create(nil);
  USerEditForm.UEPrefix             := UPrefix;
  UserEditForm.UEOID                := UOrgID;
	UserEditForm.LoginEdit.Text 			:= NodeData.Login;
  UserEditForm.LoginEdit.Enabled		:= false;
  UserEditForm.FamilyNameEdit.Text	:= NodeData.FamilyName;
  UserEditForm.FirstNameEdit.Text		:= NodeData.FirstName;
  UserEditForm.MiddleNameEdit.Text	:= NodeData.MiddleName;
  UserEditForm.OldPost              := NodeData.Post;
  UserEditForm.UserID               := NodeData.Index;
  UserEditForm.PostCombo.Clear;

  FPMainDataset.SQL.Text := 'SELECT Abbr FROM ' + UPrefix + 'postsdir ORDER BY Abbr';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    UserEditForm.PostCombo.Items.Add(FPMainDataset.FieldByName('Abbr').AsString);
    FPMainDataset.Next;
  end;
  UserEditForm.PostCombo.ItemIndex := MaxInt(UserEditForm.PostCombo.Items.IndexOf(NodeData.Post), 0);

  UserEditForm.Caption            := 'Изменение личных данных пользователя';
  UserEditForm.SaveButton.Caption	:= 'Сохранить данные';
  UserEditForm.UpdateUser       	:= true;
  UserEditForm.SetOKButton;
  UserEditForm.ShowModal;
  if UserEditForm.UpdOK then begin
	  NodeData.FirstName	:= MyFirstLetterUp(UserEditForm.FirstNameEdit.Text);
  	NodeData.MiddleName	:= MyFirstLetterUp(UserEditForm.MiddleNameEdit.Text);
	  NodeData.FamilyName	:= MyFirstLetterUp(UserEditForm.FamilyNameEdit.Text);
  	NodeData.Name				:= GetShortFIO(NodeData.FamilyName, NodeData.FirstName, NodeData.MiddleName);
	  NodeData.Post				:= MyFirstLetterUp(UserEditForm.PostCombo.Text);
    UsersList.RepaintNode(Node);
  end;
end;

procedure TUsersForm.UsersListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  CurNode := Node;
  EnableBtns;
end;

procedure TUsersForm.UsersListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1 : PUserData;
  Data2 : PUserData;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  if Data1.Name > Data2.Name then
    Result := 1
  else if Data1.Name < Data2.Name then
    Result := -1
  else
    Result := 0;
end;

procedure TUsersForm.UsersListDblClick(Sender: TObject);
begin
  if CurNode = nil then
    Exit;
  if (USersList.Header.Columns[2].Left < MX) and (USersList.Header.Columns[2].Left + USersList.Header.Columns[2].Width > MX) then begin
    AccessSetUpToolButtonClick(Sender)
  end
  else begin
    UserEditToolButtonClick(Sender)
  end;
end;

procedure TUsersForm.UsersListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  case Column of
    0: CellText := PUserData(Sender.GetNodeData(Node)).Name;
    1: CellText := PUserData(Sender.GetNodeData(Node)).Post;
    2: begin
         if PUserData(Sender.GetNodeData(Node)).Access = 'a' then
           CellText := 'Только подача заявок'
         else if PUserData(Sender.GetNodeData(Node)).Access = 'b' then
           CellText := 'Полный доступ'
         else
           CellText := '<...>';
    end // 2
  else
    CellText := '';
  end;

end;

procedure TUsersForm.UsersListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MX := X;
  MY := Y;
end;

end.
