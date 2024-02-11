unit AccessWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, Grids, BaseGrid, AdvGrid, StdCtrls, sLabel, VirtualTrees, sGroupBox, sButton, sRadioButton, ComCtrls,
  ImgList, acAlphaImageList, sCheckBox, DKLang, AdvUtil,
  System.ImageList, AdvObj;

type
  TAccessForm = class(TForm)
    pnl: TsPanel;
    vstUsers: TVirtualStringTree;
    lblUserList: TsLabel;
    lblOrgList: TsLabel;
    lblStatsList: TsLabel;
    rbFullAccess: TsRadioButton;
    rbFullRead: TsRadioButton;
    rbSettings: TsRadioButton;
    btnOK: TsButton;
    btnCancel: TsButton;
    gbPrivs: TsGroupBox;
    vstOrgs: TVirtualStringTree;
    btnSave: TsButton;
    btnUserAdd: TsButton;
    ilUsers: TsAlphaImageList;
    btnUserDel: TsButton;
    btnUserEdit: TsButton;
    btnUserOrgAdd: TsButton;
    btnUserOrgDel: TsButton;
    cbShowArchedUsers: TsCheckBox;
    lc: TDKLanguageController;
    asgStats: TAdvStringGrid;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstUsersGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstOrgsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstOrgsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstUsersChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure rbFullAccessClick(Sender: TObject);
    procedure rbFullReadClick(Sender: TObject);
    procedure rbSettingsClick(Sender: TObject);
    procedure asgStatsGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure asgStatsCheckBoxClick(Sender: TObject; ACol, ARow: Integer; State: Boolean);
    procedure asgStatsCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
    procedure vstUsersFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure btnUserAddClick(Sender: TObject);
    procedure vstUsersCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnUserEditClick(Sender: TObject);
    procedure vstUsersDblClick(Sender: TObject);
    procedure btnUserDelClick(Sender: TObject);
    procedure vstUsersPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure cbShowArchedUsersClick(Sender: TObject);
    procedure btnUserOrgAddClick(Sender: TObject);
    procedure btnUserOrgDelClick(Sender: TObject);
  private
    { Private declarations }
    CurOrgID  : integer;
    CurOrgPfx : string;
    CurUserID : integer;
		SQLError  : boolean;
    procedure PullUsersForOrg(AOID : integer);
    procedure PullStatsForOrg(AOID : integer);
    procedure SetPrivsButtons(UID : integer);
		procedure SetPrivstoGrid(OID, UID : integer; AData : pointer);
		procedure SaveCurStatPrivs(CurNode : pointer);
		procedure EditSelectedUser;
  public
    { Public declarations }
    OrgPrivs  : array of string;  // Priviledges of current user for different orgs
    UserPrivs : array of string;
  end;

implementation

{$R *.dfm}

uses
  ZDbcIntfs,
	ErrorWindow,
  UserEditWindow,
  OrgvsUsersWindow,
	GlobalVars;

procedure TAccessForm.asgStatsCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
begin
	CanEdit := ACol > 1;
end;

procedure TAccessForm.asgStatsCheckBoxClick(Sender: TObject; ACol, ARow: Integer; State: Boolean);
var
  Data : PStat;
  GID  : integer;
  i    : integer;
begin
	if asgStats.IsNode(ARow) then begin // group property pressed
    Data := PStat(asgStats.Objects[0, ARow]);
    if Data <> nil then begin
    	if (Data.flags = 1) and (ACol = 3) then begin // if we have an FP
      	asgStats.SetCheckBoxState(ACol, ARow, false);
        exit;
      end;

    	GID := Data.ID;
      i := ARow + 1;
      while (i < asgStats.RowCount) and (not asgStats.IsNode(i)) do begin
      	Data := PStat(asgStats.Objects[0, i]);
        if Data.SecondGraph = GID then begin
          asgStats.SetCheckBoxState(ACol, i, state);
          inc(i);
        end
        else
        	break
      end;
    end;
  end
  else begin // stat value pressed
    Data := PStat(asgStats.Objects[0, ARow]);
	 	if (Data.flags = 1) and (ACol = 3) then begin // if we have an FP
     	asgStats.SetCheckBoxState(ACol, ARow, false);
       exit;
    end;
  	// if we uncheck a stat within a group we have to uncheck the group checkbox
  	if not state and not asgStats.IsNode(ARow) then begin
	    if (Data <> nil) and (Data.SecondGraph > 0) then begin
    	  i := ARow - 1;
      	while (i > 1) and (not asgStats.IsNode(i)) do dec(i); //begin
        if asgStats.IsNode(i) then asgStats.SetCheckBoxState(ACol, i, state);
  	  end;
    end;
  end;
end;

procedure TAccessForm.asgStatsGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
	HAlign := taLeftJustify;
	if ACol in [2,3] then HAlign := taCenter; // Read/Write columns
end;

procedure TAccessForm.btnOKClick(Sender: TObject);
var
	CurNode : PVirtualNode;
begin
	CurNode := vstUsers.GetFirstSelected;
  if(CurNode <> nil) then
		SaveCurStatPrivs(CurNode);
  ModalResult := mrOK;
end;

procedure TAccessForm.btnUserAddClick(Sender: TObject);
var
  uef  : TUserEditForm;
  Node : PVirtualNode;
  Data : PUserData;
begin
	uef := TUserEditForm.Create(nil);
  uef.Caption := 'Новый пользователь';
  uef.UEPrefix := CurOrgPfx;
  uef.PostCombo.Clear;

  // Setting up Posts combo
  FPMainDataset.SQL.Text := 'SELECT Abbr FROM ' + CurOrgPfx + 'postsdir ORDER BY Abbr';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    uef.PostCombo.Items.Add(FPMainDataset.FieldByName('Abbr').AsString);
    FPMainDataset.Next;
  end;

  uef.PostCombo.ItemIndex := 0;
  uef.UpdateUser          := false;
  uef.SetOKButton;
  uef.ShowModal;

  if uef.UpdOK then begin
  	Node 						:= vstUsers.AddChild(nil);
    Data						:= vstUsers.GetNodeData(Node);
    Data.Index      := uef.NewUserID;
    Data.Login			:= uef.LoginEdit.Text;
    Data.Access			:= '';
	  Data.FirstName	:= MyFirstLetterUp(uef.FirstNameEdit.Text);
  	Data.MiddleName	:= MyFirstLetterUp(uef.MiddleNameEdit.Text);
	  Data.FamilyName	:= MyFirstLetterUp(uef.FamilyNameEdit.Text);
  	Data.Name				:= GetShortFIO(Data.FamilyName, Data.FirstName, Data.MiddleName);
	  Data.Post				:= MyFirstLetterUp(uef.PostCombo.Text);

    vstUsers.ClearSelection;
    vstUsers.Selected[Node] 	:= true;
    vstUsers.FocusedNode			:= Node;
    vstUsers.SortTree(0, sdAscending);
    vstUsers.ScrollIntoView(Node, false);
  end;
end;

procedure TAccessForm.btnUserDelClick(Sender: TObject);
var
  UNode : PVirtualNode;
  UData : PUserData;
  OData : PStat;
  ONode : PVirtualNode;
  bCanDelete : boolean;
  bSQLError  : boolean;
begin
  UNode := vstUsers.GetFirstSelected;
  if UNode = nil then Exit;

  UData  := vstUsers.GetNodeData(UNode);
  // check the possibility of full deletion
  bCanDelete := true;
  bSQLError  := false;

  ONode := vstOrgs.GetFirstChild(nil);
  while ONode <> nil do begin
    OData := vstOrgs.GetNodeData(ONode);

	  FPMainDataset.SQL.Text := 'SELECT`index`FROM ' + OData.saux + 'po WHERE origin=:flogin LIMIT 1'; // redo it to UserID !!!
    FPMainDataset.ParamByName('flogin').AsString := UData.Login;
	  FPMainDataset.Open;
  	if FPMainDataset.RecordCount > 0 then begin
      bCanDelete := false;
      break;
	  end;
    ONode := vstOrgs.GetNextSibling(ONode);
  end;
	try
	  if bCanDelete then begin // we can delete user
      if MessageBox(Self.Handle, PWideChar(rsSureToDeleteUser + ' ' + UData.Name + '?' + CRLF + rsUserToRemoveTotally), PWideChar(rsUserDelete), MB_ICONWARNING or MB_YESNO) = mrYES then begin
				FPMainDataset.SQL.Text  := 'START TRANSACTION';
				FPMainDataset.ExecSQL;

	    	FPMainDataset.SQL.Text := 'DELETE FROM users WHERE UserID=:fuid';
 		    FPMainDataset.ParamByName('fuid').AsInteger := UData.Index;
				FPMainDataset.ExecSQL;

	    	FPMainDataset.SQL.Text := 'DELETE FROM uofp WHERE UserID=:fuid';
 		    FPMainDataset.ParamByName('fuid').AsInteger := UData.Index;
				FPMainDataset.ExecSQL;

	    	FPMainDataset.SQL.Text := 'DELETE FROM uos WHERE UserID=:fuid';
 		    FPMainDataset.ParamByName('fuid').AsInteger := UData.Index;
				FPMainDataset.ExecSQL;
      end
      else
        exit;
    end
    else begin
      MessageBox(Self.Handle, PWideChar(rsUserImpossibleToDelete + ' ' + UData.Name + ' ' + rsUserPOsExist + CRLF +
    													rsUserToArchive), PWideChar(rsUserDelete), MB_ICONWARNING or MB_OK);
    	FPMainDataset.SQL.Text := 'UPDATE users SET`arched`=1 WHERE UserID=:fuid';
 	    FPMainDataset.ParamByName('fuid').AsInteger := UData.Index;
			FPMainDataset.ExecSQL;
    end;
	except
  	on e: EZSQLException do begin
			ErrorForm := TErrorForm.Create(Self);
    	ErrorForm.ErrorExplanationMemo.Text 	:= rsFAileToUpdateUserInfo + ' ' + rsServerAnswerBelow;
		  ErrorForm.ErrorMemo.Text	 						:= rsError + ' ' + IntToStr(e.ErrorCode) + ', ';
    	if e.StatusCode <> '' then ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + rsStatus + ' ' + e.StatusCode + ', ';
		  ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + e.Message;
    	ErrorForm.ShowModal;
		  ErrorForm.Free;
    	bSQLError := true;
		end;
  end;

	if bSQLError then begin
		FPMainDataset.SQL.Text  := 'ROLLBACK';
    try
    	FPMainDataset.ExecSQL;
    finally
  		  	// do nothing here - everything has already done
    end;
	end
  else begin
		FPMainDataset.SQL.Text  := 'COMMIT';
    try
    	FPMainDataset.ExecSQL;
    except
  		on e: EZSQLException do begin
  	  	bSQLError := true;
      end;
   	end;
	end;

	// save the privs - end of
  if not bSQLError then begin
    if bCanDelete then begin
      vstUsers.DeleteNode(UNode);
		  CurUserID := -1;
    end
    else begin
      UData.arched := true;
      UData.Access := '';
      SetLEngth(UData.StatsAccess, 0);
      vstUsers.RepaintNode(UNode);
    end;
  	SetPrivsButtons(CurUserID);
    vstUsers.SetFocus;
  end;
end;

procedure TAccessForm.EditSelectedUser;
var
  uef : TUserEditForm;
  Node : PVirtualNode;
  Data : PUserData;
begin
  Node := vstUsers.GetFirstSelected;
  if Node = nil then Exit;

  Data  := vstUsers.GetNodeData(Node);

	uef := TUserEditForm.Create(nil);
  uef.Caption             := rsUserDataChange;
  uef.UEPrefix            := CurOrgPfx;
	uef.LoginEdit.Text 			:= Data.Login;
  uef.LoginEdit.Enabled		:= false;
  uef.FamilyNameEdit.Text	:= Data.FamilyName;
  uef.FirstNameEdit.Text	:= Data.FirstName;
  uef.MiddleNameEdit.Text	:= Data.MiddleName;
  uef.OldPost             := Data.Post;
  uef.UserID              := Data.Index;
  uef.SaveButton.Caption  := rsSaveData;
  uef.UpdateUser       	  := true;
  uef.PostCombo.Clear;

  // Setting up Posts combo
  FPMainDataset.SQL.Text := 'SELECT Abbr FROM ' + CurOrgPfx + 'postsdir ORDER BY Abbr';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    uef.PostCombo.Items.Add(FPMainDataset.FieldByName('Abbr').AsString);
    FPMainDataset.Next;
  end;
  uef.PostCombo.ItemIndex := MaxInt(uef.PostCombo.Items.IndexOf(Data.Post), 0);

  uef.SetOKButton;
  uef.ShowModal;

  if uef.UpdOK then begin
	  Data.FirstName	:= MyFirstLetterUp(uef.FirstNameEdit.Text);
  	Data.MiddleName	:= MyFirstLetterUp(uef.MiddleNameEdit.Text);
	  Data.FamilyName	:= MyFirstLetterUp(uef.FamilyNameEdit.Text);
  	Data.Name				:= GetShortFIO(Data.FamilyName, Data.FirstName, Data.MiddleName);
	  Data.Post				:= MyFirstLetterUp(uef.PostCombo.Text);

    vstUsers.ClearSelection;
    vstUsers.Selected[Node] 	:= true;
    vstUsers.FocusedNode			:= Node;
    vstUsers.SortTree(0, sdAscending);
    vstUsers.ScrollIntoView(Node, false);
  end;
end;

procedure TAccessForm.btnUserEditClick(Sender: TObject);
begin
	EditSelectedUser;
end;

procedure TAccessForm.btnUserOrgAddClick(Sender: TObject);
var
  avo : TOrgvsUsersForm;
  OData : PStat;
  ONode : PVirtualNode;
  UData : PUserData;
  UNode : PVirtualNode;
  vst   : TVirtualStringTree;
  it    : integer;
  jt    : integer;
  kt    : integer;
  bOk   : boolean;
begin
  ONode := vstOrgs.GetFirstSelected;
  if ONode = nil then Exit;
  OData := vstOrgs.GetNodeData(ONode);

  avo := TOrgvsUsersForm.Create(nil);
  avo.cmbOrgs.Clear;
  avo.cmbOrgs.Items.Add(OData.ShortDescription);
  avo.cmbOrgs.ItemIndex := 0;
  avo.loid := CurOrgID;

  // pulling useres
	FPMainDataset.SQL.Text := 'SELECT users.UserID as UID,Login,FamilyName,FirstName,MiddleName,T2.OrgID AS OID FROM users LEFT JOIN(SELECT users.UserID,uos.OrgID FROM`users`LEFT JOIN`uos`ON users.UserID=uos.UserID WHERE arched=0 AND uos.OrgID=:fOID) T2 ON users.UserID=T2.UserID';
  FPMainDataset.ParamByName('fOID').AsInteger := OData.ID;
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
  	with FPMainDataset do begin
    	it := FPMainDataset.FieldByName('UID').AsInteger;
    	if FieldByName('OID').IsNull then
        vst := avo.vstUsersAll
      else begin // in this case we also need a list of org users
        vst := avo.vstUsersOrg;
        if Length(avo.aiBO) < it + 1 then begin
//          jt := Length(avo.aiBO);
//        	SetLength(avo.aiBO, it + 1);
//          for kt := jt to Length(avo.aiBO) do avo.aiBO[kt] := 0;
        	SetLength(avo.aiBO, it + 1);
        end;
				avo.aiBO[it] := 1;
      end;

			UNode            := vst.AddChild(nil);
  		UData         	 := vst.GetNodeData(UNode);
    	UData.Index			 := FPMainDataset.FieldByName('UID').AsInteger;
      UData.Login      := FieldByName('Login').AsString;
			UData.FirstName	 := FieldByName('FirstName').AsString;
  		UData.MiddleName := FieldByName('MiddleName').AsString;
    	UData.FamilyName := FieldByName('FamilyName').AsString;
		  UData.Name			 := GetShortFIO(UData.FamilyName, UData.FirstName, UData.MiddleName);
			Next;
    end;
  end;
  avo.vstUsersOrg.SortTree(0, sdAscending);
	avo.vstUsersAll.SortTree(0, sdAscending);
  // pulling users - end of

  bOk := avo.ShowModal = mrOk;
  avo.Destroy;
  if bOk then begin
		PullUsersForOrg(CurOrgID);
  end;
end;

procedure TAccessForm.btnUserOrgDelClick(Sender: TObject);
var
	Node      : PVirtualNode;
  Data      : PUserData;
  bSQLError : boolean;
begin
	if CurOrgID = -1 then Exit;

  Node := vstUsers.GetFirstSelected;
  if Node = nil then Exit;

 	Data := vstUsers.GetNodeData(Node);

  // save the privs
	bSQLError := false;
	FPMainDataset.SQL.Text  := 'START TRANSACTION';
	try
		FPMainDataset.ExecSQL;

    // set new privilege to "uos" and "statprivs" table
		FPMainDataset.SQL.Text := 'DELETE FROM statprivs WHERE OrgID=:foid AND UserID=:fuid';
  	FPMainDataset.ParamByName('foid').AsInteger := CurOrgID;
  	FPMainDataset.ParamByName('fuid').AsInteger := Data.Index;
    FPMainDataset.ExecSQL;

		FPMainDataset.SQL.Text := 'DELETE FROM uos WHERE OrgID=:foid AND UserID=:fuid';
  	FPMainDataset.ParamByName('foid').AsInteger := CurOrgID;
  	FPMainDataset.ParamByName('fuid').AsInteger := Data.Index;
    FPMainDataset.ExecSQL;

	except
  	on e: EZSQLException do begin
			ErrorForm := TErrorForm.Create(Self);
    	ErrorForm.ErrorExplanationMemo.Text 	:= rsFaileToDeleteUserInfo + ' ' + rsServerAnswerBelow;
		  ErrorForm.ErrorMemo.Text	 						:= rsError + ' ' + IntToStr(e.ErrorCode) + ', ';
    	if e.StatusCode <> '' then ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + rsStatus + ' ' + e.StatusCode + ', ';
		  ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + e.Message;
    	ErrorForm.ShowModal;
		  ErrorForm.Free;

    	bSQLError := true;
		end;
  end;

	if bSQLError then begin
		FPMainDataset.SQL.Text  := 'ROLLBACK';
    try
    	FPMainDataset.ExecSQL;
    finally
  		  	// do nothing here - everything has already done
    end;
	end
  else begin
		FPMainDataset.SQL.Text  := 'COMMIT';
    try
    	FPMainDataset.ExecSQL;
    except
  		on e: EZSQLException do begin
  	  	bSQLError := true;
      end;
   	end;
	end;
	// save the privs - end of
  if not bSQLError then begin
		vstUsers.DeleteNode(Node);
    CurUserID := -1;
		SetPrivsButtons(CurUserID);
  end;
end;

procedure TAccessForm.cbShowArchedUsersClick(Sender: TObject);
var
  UNode : PVirtualNode;
  UData : PUserData;
begin
  UNode := vstUsers.GetFirstChild(nil);
  if UNode = nil then Exit;

  while UNode <> nil do begin
	  UData  := vstUsers.GetNodeData(UNode);
    if UData.arched then begin
      if cbShowArchedUsers.Checked then
      	UNode.States := UNode.States + [vsVisible]
      else
      	UNode.States := UNode.States - [vsVisible];
    end;
    UNode := vstUsers.GetNextSibling(UNode);
  end;
	vstUsers.Repaint;
end;

procedure TAccessForm.SaveCurStatPrivs(CurNode : pointer);
var
	SData : PStat;
	UData : PUserData;
  UNode : PVirtualNode;
  CurFullPrivs : string;
  sSQLVals : string;
  sTmp : string;
  bCheckState : boolean;
  i : integer;
begin
  if CurNode = nil then Exit;

	UNode := CurNode; //vstUsers.GetFirstSelected;

	UData := vstUsers.GetNodeData(UNode);
	if rbFullAccess.Checked then begin
  	CurFullPrivs := 'b'
  end
  else if rbFullread.Checked then begin
  	CurFullPrivs := 'a'
  end
  else begin
  	CurFullPrivs := ''
  end;

  // save the privs
	SQLError := false;
	FPMainDataset.SQL.Text  := 'START TRANSACTION';
	try
		FPMainDataset.ExecSQL;
    if UData.Access = '' then begin // remove old "stat-by-stat" privileges
    	FPMainDataset.SQL.Text := 'DELETE FROM statprivs WHERE UserID=:fuid AND OrgID=:foid';
      FPMainDataset.ParamByName('fuid').AsInteger := UData.Index;
      FPMainDataset.ParamByName('foid').AsInteger := CurOrgID;
      FPMainDataset.ExecSQL;
    end;

    // set new privilege to "uos" table
    FPMainDataset.SQL.Text := 'UPDATE uos SET sp=:fsp WHERE UserID=:fuid AND OrgID=:foid';
    FPMainDataset.ParamByName('fsp').AsString   := CurFullPrivs;
    FPMainDataset.ParamByName('fuid').AsInteger := UData.Index;
    FPMainDataset.ParamByName('foid').AsInteger := CurOrgID;
    FPMainDataset.ExecSQL;

    if CurFullPrivs = '' then begin // we have to insert new privileges to statprivs table
    	FPMainDataset.SQL.Text := 'INSERT INTO statprivs(UserID,OrgID,StatID,cw)VALUES';
      sSqlVals := '';
      // pull data from grid
			for i := 1 to asgStats.RowCount - 1 do begin
  			if asgStats.IsNode(i) then continue;

        SData := PStat(asgStats.Objects[0, i]);

        sTmp := '';
		    asgStats.GetCheckBoxState(2, i, bCheckState);
  		  if bCheckState then sTmp := sTmp + 'r';
    		asgStats.GetCheckBoxState(3, i, bCheckState);
  		  if bCheckState then sTmp := sTmp + 'w';
        if sTmp <> '' then begin // we need it only at least one privilege set up
	      	if sSqlVals <> '' then sSqlVals := sSqlVals + ',';
  	      sSqlVals := sSqlVals + '(' + IntToStr(UData.Index) + ',' + IntToStr(CurOrgID) + ',' + IntToStr(SData.ID) + ',"' + sTmp + '")';
        end;
		end;
    if sSqlVals <> '' then begin
	  	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + sSqlVals;
	    FPMainDataset.ExecSQL;
      end;
    end

	except
  	on e: EZSQLException do begin
			ErrorForm := TErrorForm.Create(Self);
    	ErrorForm.ErrorExplanationMemo.Text 	:= rsFailedToStartTransation + ' ' + rsServerAnswerBelow;
		  ErrorForm.ErrorMemo.Text	 						:= rsError + ' ' + IntToStr(e.ErrorCode) + ', ';
    	if e.StatusCode <> '' then ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + rsStatus + ' ' + e.StatusCode + ', ';
		  ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + e.Message;
    	ErrorForm.ShowModal;
		  ErrorForm.Free;

    	SQLError := true;
		end;
  end;

	if SQLError then begin
		FPMainDataset.SQL.Text  := 'ROLLBACK';
    try
    	FPMainDataset.ExecSQL;
    finally
  		  	// do nothing here - everything has already done
    end;
	end
  else begin
		FPMainDataset.SQL.Text  := 'COMMIT';
    try
    	FPMainDataset.ExecSQL;
    except
  		on e: EZSQLException do begin
  	  	SQLError := true;
      end;
   	end;
	end;
	// save the privs - end of
  if not SQLError then begin
  	UData.Access := CurFullPrivs;
  end;
end;

procedure TAccessForm.FormCreate(Sender: TObject);
begin
	SetLength(OrgPrivs, 0);
  vstUsers.NodeDataSize := SizeOf(TUserData);
  vstOrgs.NodeDataSize := SizeOF(TStat);
end;

procedure TAccessForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin
      ModalResult := mrCancel;
    end; // VK_ESCAPE
  else
    inherited;
  end; // Case
end;

procedure TAccessForm.FormShow(Sender: TObject);
begin
	// pull orgs
	asgStats.Options := asgStats.Options + [goEditing];
	CurOrgID  := -1;
  CurOrgPfx := '';

  PullStatsForOrg(CurOrgID);
end;

procedure TAccessForm.vstOrgsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
	Data : PStat;
begin
	if Node = nil then begin
	  CurOrgID  := -1;
    CurOrgPfx := '';
  end
  else begin
  	Data := Sender.GetNodeData(Node);
    CurOrgID := Data.ID;
    CurOrgPfx := Data.saux;
  end;
  PullStatsForOrg(CurOrgID);
  PullUsersForOrg(CurOrgID);
end;

procedure TAccessForm.vstOrgsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
	Data : PStat;
begin
	if Node <> nil then begin
    Data := Sender.GetNodeData(Node);
    CellText := Data.ShortDescription;
  end;
end;

procedure TAccessForm.vstUsersChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
	Data : PUserData;
begin
  CurUserID := -1;
  btnUserDel.Enabled  := false;
  btnUserEdit.Enabled := false;
  if Node <> nil then begin
		Data := Sender.GetNodeData(Node);
    CurUserID := Data.Index;
    SetPrivsButtons(CurUserID);
    btnUserDel.Enabled  := not Data.arched;
    btnUserEdit.Enabled := true;
  end
end;

procedure TAccessForm.vstUsersCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  D1 : PUserData;
  D2 : PUserData;
begin
	D1 := Sender.GetNodeData(Node1);
  D2 := Sender.GetNodeData(Node2);
	Result := AnsiCompareText(D1.Name, D2.Name);
end;

procedure TAccessForm.vstUsersDblClick(Sender: TObject);
begin
	EditSelectedUser;
end;

procedure TAccessForm.vstUsersFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
var
  UData : PUserData;
  SData : PStat;
  CurFullPrivs  : string;
  CurStatsPrivs : array of string;
  i : integer;
  sid : integer;
  bStateChanged : boolean;
  bCheckState   : boolean;
//  sSQLvals      : string;
//  sTmp          : string;
begin
  if (OldNode <> nil) and (OldNode <> NewNode) then begin
  	UData := vstUsers.GetNodeData(OldNode);
    SetLength(CurStatsPrivs, 0);
    bStateChanged := false;

    // check which buttons is in check state
    if rbFullAccess.Checked then begin
      CurFullPrivs := 'b'
    end
    else if rbFullread.Checked then begin
      CurFullPrivs := 'a'
    end
    else begin
      CurFullPrivs := ''
    end;

    if UData.Access <> CurFullPrivs then begin
      bStateChanged := true
    end
    else if CurFullPrivs = '' then begin
	    for i := 1 to asgStats.RowCount - 1 do begin
  	  	if not asgStats.IsNode(i) then begin
	  	  	SData := PStat(asgStats.Objects[0, i]);
      	  sid := SData.ID;
        	if sid > Length(CurStatsPrivs) - 1 then SetLength(CurStatsPrivs, sid + 1);

	        asgStats.GetCheckBoxState(2, i, bCheckState);
  	      if bCheckState then CurStatsPrivs[sid] := CurStatsPrivs[sid] + 'r';
    	    asgStats.GetCheckBoxState(3, i, bCheckState);
      	  if bCheckState then CurStatsPrivs[sid] := CurStatsPrivs[sid] + 'w';
	      end;
  	  end; // for i:=...

      bCheckState := true;
      for i := 0 to Length(CurStatsPrivs) - 1 do begin
      	if CurStatsPrivs[i] <> '' then begin
          bCheckState := true;
          break;
        end;
      end;
      if bCheckState then SetLength(CurStatsPrivs, 0); // if everything is '' we do not need the array

      bCheckState := true;
      for i := 0 to Length(UData.StatsAccess) - 1 do begin
      	if UData.StatsAccess[i] <> '' then begin
          bCheckState := true;
          break;
        end;
      end;
      if bCheckState then SetLength(UData.StatsAccess, 0); // if everything is '' we do not need the array

	    if Length(UData.StatsAccess) <> Length(CurStatsPrivs) then begin
  	    bStateChanged := true
      end
    	else begin
	    	for i := 1 to Length(CurStatsPrivs) - 1 do begin
  	      if UData.StatsAccess[i] <> CurStatsPrivs[i] then begin
    	      bStateChanged := true;
      	    break;
        	end;
	      end;
  	  end;
    end;
		if bStateChanged then begin // save the data.
			bStateChanged := Application.MessageBox(PWideChar(rsUserSaveData + ' ' + UData.Name + '?'), PWideChar(rsUserAccessSetupSchanged), MB_ICONWARNING or MB_YESNO) = IDYES;
    end;

		if bStateChanged then begin // save the data.
			SaveCurStatPrivs(OldNode);
		end; // if bStateChanged
  end;
end;

procedure TAccessForm.vstUsersGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data : PUserData;
begin
  if Node <> nil then begin
    Data := Sender.GetNodeData(Node);
    CellText := Data.Name;
  end;
end;

procedure TAccessForm.vstUsersPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data : PUserData;
begin
  Data := vstUsers.GetNodeData(Node);
  if Data.arched then begin
    TargetCanvas.Font.Style := [fsItalic];
  end;
end;

procedure TAccessForm.PullUsersForOrg(AOID : integer);
var
	Node  : PVirtualNode;
  Data  : PUserData;
  error : boolean;
begin

	vstUsers.Clear;
  CurUserID := -1;
  error := false;

	FPMainDataset.SQL.Text := 'SELECT users.UserID as UID,Login,FamilyName,FirstName,MiddleName,sp,arched FROM users LEFT JOIN uos ON users.UserID=uos.UserID WHERE uos.OrgID=:forgid ORDER BY FamilyName,FirstName,MiddleName';// LOCK IN SHARE MODE';
  FPMainDataset.ParamByName('forgid').AsInteger	:= AOID;

  try
  	FPMainDataset.Open;
  except
		on e: EZSQLException do begin
			ShowError(Self, rsAuthorError, e.ErrorCode, e.StatusCode, e.Message);
	    error := true;
    end;
  end;

	if not error then begin
  	while not FPMainDataset.Eof do begin
		 	with FPMainDataset do begin
				Node            := vstUsers.AddChild(nil);
  			Data         		:= vstUsers.GetNodeData(Node);
    		Data.Index			:= FPMainDataset.FieldByName('UID').AsInteger;
        Data.Login      := FPMainDataset.FieldByName('Login').AsString;
			  Data.FirstName	:= FPMainDataset.FieldByName('FirstName').AsString;
  			Data.MiddleName	:= FPMainDataset.FieldByName('MiddleName').AsString;
    		Data.FamilyName	:= FPMainDataset.FieldByName('FamilyName').AsString;
		  	Data.Name				:= GetShortFIO(Data.FamilyName, Data.FirstName, Data.MiddleName);
			  Data.Access  		:= FPMainDataset.FieldByName('sp').AsString;
    		Data.arched			:= Boolean(FPMainDataset.FieldByName('arched').AsInteger);
        if Data.arched and not cbShowArchedUsers.Checked then begin
          Node.States := Node.States - [vsVisible]
        end;

			  Next;
    	end;
		end;
  end;
  vstUsers.SortTree(1, sdAscending);
  SetPrivsButtons(CurUserID);
end;

procedure TAccessForm.rbFullAccessClick(Sender: TObject);
begin
  asgStats.Enabled     := false;
end;

procedure TAccessForm.rbFullReadClick(Sender: TObject);
begin
  asgStats.Enabled     := false;
end;

procedure TAccessForm.rbSettingsClick(Sender: TObject);
begin
  asgStats.Enabled := true;
end;

procedure TAccessForm.SetPrivsButtons(UID : integer);
var
	Node : PVirtualNode;
  Data : PUserData;
begin
  rbFullAccess.Checked  := false;
  rbFullRead.Checked    := false;
  rbSettings.Checked    := false;
  gbPrivs.Enabled       := false;
  asgStats.Enabled      := false;
  btnUserDel.Enabled    := false;
  btnUserEdit.Enabled   := false;
	btnUserOrgDel.Enabled := false;

  if UID > 0 then begin
    Node := vstUsers.GetFirstSelected;
    if Node <> nil then begin
    	Data := vstUsers.GetNodeData(Node);
      if not Data.arched then begin
			  gbPrivs.Enabled := true;
    	  if Data.Access = 'b' then rbFullAccess.Checked := true
      	else if Data.Access = 'a' then rbFullread.Checked := true
	      else begin
  	    	rbSettings.Checked := true;
				  asgStats.Enabled   := true;
      	end;
	    	SetPrivsToGrid(CurOrgID, CurUserID, Data);
      end;
    end;
	  btnUserDel.Enabled    := true;
  	btnUserEdit.Enabled   := true;
    btnUserOrgDel.Enabled := true;
  end;
end;

procedure TAccessForm.SetPrivstoGrid(OID, UID : integer; AData : pointer);
var
	i    : integer;
	Data : PStat;
  sid  : integer;
	UData : PUserData;
begin
	//clear all the checkboxes
  for i := 1 to asgStats.RowCount - 1 do begin
  	asgStats.SetCheckBoxState(2, i, false);
  	asgStats.SetCheckBoxState(3, i, false);
	end; // for i:=...

  // pull data
	UData := AData;
	SetLength(UData.StatsAccess, 0);
//	FPMainDataset.SQL.Text := 'SELECT statdescr.StatID AS StatID,T2.cw AS cw FROM statdescr LEFT JOIN (SELECT statdescr.StatID,statprivs.cw FROM`statdescr`left join`statprivs`on statdescr.StatID=statprivs.StatID where statprivs.UserID=:fUID) T2 on statdescr.StatID=T2.StatID where OrgID=:fOID';
	FPMainDataset.SQL.Text := 'SELECT statdescr.StatID,T2.cw FROM statdescr LEFT JOIN(SELECT statdescr.StatID,statprivs.cw FROM`statdescr`LEFT JOIN`statprivs`ON statdescr.StatID=statprivs.StatID WHERE statprivs.UserID=:fUID) T2 ON statdescr.StatID=T2.StatID WHERE OrgID=:fOID';
  FPMainDataset.ParamByName('fUID').AsInteger := UID;
  FPMainDataset.ParamByName('fOID').AsInteger := OID;
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
  	with FPMainDataset do begin
      sid := FieldByName('StatID').AsInteger;
      if sid > Length(UData.StatsAccess) - 1 then begin
      	SetLength(UData.StatsAccess, sid + 1);
      end;
      UData.StatsAccess[sid] := FieldByName('cw').AsString;

      for i := 1 to asgStats.RowCount - 1 do begin
      	if not asgStats.IsNode(i) then begin
	        Data := PStat(asgStats.Objects[0, i]);
          if Data.ID = sid then begin
	          Data.FullDescription := UData.StatsAccess[sid];
            if Pos('r', Data.FullDescription) > 0 then begin
              asgStats.SetCheckBoxState(2, i, true);
            end
            else begin
              asgStats.SetCheckBoxState(2, i, false);
            end;
            if Pos('w', Data.FullDescription) > 0 then begin
              asgStats.SetCheckBoxState(3, i, true);
            end
            else begin
              asgStats.SetCheckBoxState(3, i, false);
            end;
	        	break;
          end; // if Data.ID = sid
        end;
      end; // for i:=...
			Next;
    end;
  end;
end;

procedure TAccessForm.PullStatsForOrg(AOID : integer);
var
  Data : PStat;
  error : boolean;
  i : integer;
  j : integer;
  bWithGroups : boolean;
  iFlags      : integer;
  CurGroupID : integer;

begin

	bWithGroups := false;

	asgStats.RemoveCheckBoxColumn(2);
	asgStats.RemoveCheckBoxColumn(3);

  asgStats.UnHideRowsAll;
  asgStats.UnGroup;
  asgStats.MergedColumns.Clear;
  asgStats.ColCount  := 5;
  asgStats.RowCount  := 2;
  asgStats.FixedRows := 1;

  asgStats.ColumnHeaders.Clear;
  asgStats.ColumnHeaders.Add('');
  asgStats.ColumnHeaders.Add('');
  asgStats.ColumnHeaders.Add(rsGroupStat);
  asgStats.ColumnHeaders.Add(rsRead);
  asgStats.ColumnHeaders.Add(rsWrite);

  asgStats.ColWidths[0]  := 20; //ReadColWidth(sIniSection, 0, 20); 	//20;
  asgStats.ColWidths[1]  := 20; //ReadColWidth(sIniSection, 0, 20); 	//20;
  asgStats.ColWidths[2]  := 200;// ReadColWidth(sIniSection, 1, 20); 	//20;
  asgStats.ColWidths[3]  := 60; //ReadColWidth(sIniSection, 2, 200); //120;
  asgStats.ColWidths[4]  := 60; //ReadColWidth(sIniSection, 3, 60); 	//200;

  error := false;

  btnUserAdd.Enabled    := AOID > 0;
  btnUserOrgAdd.Enabled := AOID > 0;
  if AOID < 0 then begin
		asgStats.RemoveCols(1, 1);
  	Exit;
  end;


	FPMainDataset.SQL.Text := 'SELECT ID,statgroups.description,StatID,ShortName,isfp FROM statgroups INNER JOIN statdescr WHERE statgroups.ID=statdescr.GroupID AND statgroups.OrgID=:fOID';
  FPMainDataset.ParamByName('fOID').AsInteger	:= AOID;

  try
  	FPMainDataset.Open;
  except
		on e: EZSQLException do begin
			ShowError(Self, rsFailedToLoadStatList, e.ErrorCode, e.StatusCode, e.Message);
	    error := true;
    end;
  end;

  i := 1;
  if error then exit;

	if not error then begin
  	if not FPMainDataset.Eof then bWithGroups := true else bWithGroups := false;

  	while not FPMainDataset.Eof do begin
		 	with FPMainDataset do begin
       	asgStats.AddRow;
		    asgStats.Cells[0, i] := '';
		    asgStats.Cells[1, i] := FieldByName('description').AsString;
 		    asgStats.Cells[2, i] := FieldByName('ShortName').AsString;
   		  asgStats.Cells[3, i] := '';
    	  asgStats.Cells[4, i] := '';

        New(Data);
        Data.ID := FieldByName('StatID').AsInteger;
        Data.kind := SVK_STAT;
        Data.SecondGraph := FieldByName('ID').AsInteger; // here it's a group #
        Data.flags       := FieldByName('isfp').AsInteger; // do we have an FP group here?
  			asgStats.Objects[0, i] := TObject(Data);

        inc(i);

			  Next;
    	end;
		end;

    if bWithGroups then begin
	    if asgStats.Cells[0, asgStats.RowCount - 1] = ''  then begin
  	  	asgStats.RemoveRows(asgStats.RowCount - 1, 1);
    	end;
	  	asgStats.SortSettings.AutoSortForGrouping := false;
  	  asgStats.Group(1);
    end
    else begin
      asgStats.RemoveCols(1, 1);
    end;
  end;

  if (asgStats.RowCount > 2) then begin
	  for j := 1 to asgStats.RowCount - 1 do begin
  	  asgStats.AddCheckBox(2, j, false, false);
    	asgStats.AddCheckBox(3, j, false, false);
	  end;
  end;

  j := asgStats.RowCount - 1;
//  while asgStats.Cells[0, j] = '' do Dec(j);
  while (asgStats.Objects[0, j] = nil) and (j > 1) do Dec(j);

  while j > 1 do begin
    Data     := PStat(asgStats.Objects[0, j]);
    if Data = nil then break;
  	CurGroupID := Data.SecondGraph; // group ID
    iFlags := Data.flags;
	  while j > 0 do begin
  	  if asgStats.IsNode(j) then break else Dec(j);
    end;
    if j > 0 then begin
    	New(Data);
      Data.ID := CurGroupID;
      Data.kind := SVK_GROUP;
      Data.flags := iFlags;
  		asgStats.Objects[0, j] := TObject(Data);
      Dec(j);
    end;
  end;

	FPMainDataset.SQL.Text := 'SELECT StatID,ShortName FROM statdescr WHERE GroupID=0 AND OrgID=:fOID';
  FPMainDataset.ParamByName('fOID').AsInteger	:= AOID;

  try
  	FPMainDataset.Open;
  except
		on e: EZSQLException do begin
			ShowError(Self, rsFailedToLoadUngroupedStatList, e.ErrorCode, e.StatusCode, e.Message);
	    error := true;
    end;
  end;

	if not error then begin
  	i := asgStats.RowCount;
    Dec(i, integer(not bWithGroups));
  	while not FPMainDataset.Eof do begin
		 	with FPMainDataset do begin
       	asgStats.AddRow;
		    asgStats.Cells[0, i] := '';
 		    asgStats.Cells[1, i] := FieldByName('ShortName').AsString;
        asgStats.AddCheckBox(2, i, false, false);
        asgStats.AddCheckBox(3, i, false, false);

        New(Data);
        Data.ID := FieldByName('StatID').AsInteger;
        Data.kind := SVK_STAT;
        Data.SecondGraph := 0; // here it's a group #
  			asgStats.Objects[0, i] := TObject(Data);

        inc(i);

			  FPMainDataset.Next;
    	end;
		end;
  end;
	if (asgStats.Cells[1, asgStats.RowCount - 1] = '') and (asgStats.RowCount > 2) then begin
  	asgStats.RemoveRows(asgStats.RowCount - 1, 1);
  end;
end;

end.
