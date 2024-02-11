unit OrgvsUsersWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sComboBox, sButton, sLabel, VirtualTrees, ExtCtrls, sPanel, DKLang;

type
  TOrgvsUsersForm = class(TForm)
    pnl: TsPanel;
    vstUsersAll: TVirtualStringTree;
    lblUserAll: TsLabel;
    btnOrgAdd: TsButton;
    btnOrgRemove: TsButton;
    lblOrg: TsLabel;
    cmbOrgs: TsComboBox;
    vstUsersOrg: TVirtualStringTree;
    lblUsersOrg: TsLabel;
    btnOk: TsButton;
    btnCancel: TsButton;
    lc: TDKLanguageController;
    procedure vstUsersCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstUsersGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormCreate(Sender: TObject);
    procedure vstUsersAllChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstUsersOrgChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure btnOrgAddClick(Sender: TObject);
    procedure btnOrgRemoveClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
    aiAO: array of integer; // list of users that have access to the org AFTER editing
  public
    { Public declarations }
    aiBO: array of integer; // list of users that have access to the org BEFORE editing
    loid : integer;
  end;

var
  OrgvsUsersForm: TOrgvsUsersForm;

implementation

{$R *.dfm}

uses
  ZDbcIntfs,
	ErrorWindow,
	GlobalVars;

procedure TOrgvsUsersForm.vstUsersGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data : PUserData;
begin
  if Node <> nil then begin
    Data := Sender.GetNodeData(Node);
    CellText := Data.Name;
  end;
end;

procedure TOrgvsUsersForm.vstUsersOrgChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  btnOrgRemove.Enabled := Node <> nil;
end;

procedure TOrgvsUsersForm.btnOkClick(Sender: TObject);
var
	Node      : PVirtualNode;
  Data      : PUserData;
  i         : integer;
  storem    : string;
  stoadd    : string;
  bSQLError : boolean;
begin
	// collect current list of users
  SetLength(aiAO, 0);
  Node := vstUsersOrg.GetFirstChild(nil);

  while Node <> nil do begin
  	Data := vstUsersOrg.GetNodeData(Node);
	 	if Length(aiAO) < Data.Index then SetLength(aiAO, Data.Index + 1);
  	aiAO[Data.Index] := 1;
    Node := vstUsersOrg.GetNextSibling(Node);
  end;

  // compiling ID to remove
  for i := 1 to Length(aiBO) - 1 do begin
    if aiBO[i] > 0 then begin
      if (Length(aiAO) < i + 1) or (aiAO[i] = 0) then begin
        if storem <> '' then storem := storem + ',';
        storem := storem + inttostr(i);
      end;
    end;
  end;

	//ShowMessage(svals);
  // compiling ID to add
  stoadd := '';
  for i := 1 to Length(aiAO) - 1 do begin
    if aiAO[i] > 0 then begin
      if (Length(aiBO) < i + 1) or (aiBO[i] = 0) then begin
        if stoadd <> '' then stoadd := stoadd + ',';
        stoadd := stoadd + '(' + inttostr(i) + ',' + inttostr(loid) + ')';
      end;
    end;
  end;
	//ShowMessage(svals);

  // save the privs
	bSQLError := false;
	FPMainDataset.SQL.Text  := 'START TRANSACTION';
	try
		FPMainDataset.ExecSQL;

    // set new privilege to "uos" and "statprivs" table
    if storem <> '' then begin
			FPMainDataset.SQL.Text := 'DELETE FROM statprivs WHERE OrgID=:foid AND UserID IN(' + storem + ')';
  	  FPMainDataset.ParamByName('foid').AsInteger := loid;
    	FPMainDataset.ExecSQL;

			FPMainDataset.SQL.Text := 'DELETE FROM uos WHERE OrgID=:foid AND UserID IN(' + storem + ')';
  	  FPMainDataset.ParamByName('foid').AsInteger := loid;
    	FPMainDataset.ExecSQL;
    end;

    if stoadd <> '' then begin
	    FPMainDataset.SQL.Text := 'INSERT INTO uos(UserID,OrgID)VALUES' + stoadd;
  	  FPMainDataset.ExecSQL;
    end;

	except
  	on e: EZSQLException do begin
			ErrorForm := TErrorForm.Create(Self);
    	ErrorForm.ErrorExplanationMemo.Text 	:= rsFailedToStartTransation +  ' ' + rsServerAnswerBelow;
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
  if not bSQLError then ModalResult := mrOk else Modalresult := mrCancel;
end;

procedure TOrgvsUsersForm.btnOrgAddClick(Sender: TObject);
var
  UNode : PVirtualNode;
  UData : PUserData;
  ONode : PVirtualNode;
  OData : PUserData;
begin
  UNode := vstUsersAll.GetFirstSelected;
  if UNode = nil then Exit;

  UData := vstUsersAll.GetNodeData(UNode);

  vstUsersOrg.BeginUpdate;
  ONode 						:= vstUsersOrg.AddChild(nil);
  OData						  := vstUsersOrg.GetNodeData(ONode);
  OData.Index       := UData.Index;
  OData.Login			  := UData.Login;
  OData.Access			:= UData.Access;
	OData.FirstName	  := UData.FirstName;
  OData.MiddleName	:= UData.MiddleName;
	OData.FamilyName	:= UData.FamilyName;
  OData.Name				:= UData.Name;
	OData.Post				:= UData.Post;
  vstUsersOrg.EndUpdate;

  vstUsersOrg.ClearSelection;
  vstUsersOrg.Selected[ONode] := true;
  vstUsersOrg.FocusedNode			:= ONode;

  vstUsersAll.DeleteNode(UNode);
  btnOrgAdd.Enabled := vstUsersAll.GetFirstSelected <> nil;
end;

procedure TOrgvsUsersForm.btnOrgRemoveClick(Sender: TObject);
var
  ONode : PVirtualNode;
  OData : PUserData;
  ANode : PVirtualNode;
  AData : PUserData;
begin
  ONode := vstUsersOrg.GetFirstSelected;
  if ONode = nil then Exit;

  OData := vstUsersAll.GetNodeData(ONode);

  vstUsersAll.BeginUpdate;
  ANode 						:= vstUsersAll.AddChild(nil);
  AData						  := vstUsersAll.GetNodeData(ANode);
  AData.Index       := OData.Index;
  AData.Login			  := OData.Login;
  AData.Access			:= OData.Access;
	AData.FirstName	  := OData.FirstName;
  AData.MiddleName	:= OData.MiddleName;
	AData.FamilyName	:= OData.FamilyName;
  AData.Name				:= OData.Name;
	AData.Post				:= OData.Post;
  vstUsersAll.EndUpdate;

  vstUsersAll.ClearSelection;
  vstUsersAll.Selected[ANode] := true;
  vstUsersAll.FocusedNode			:= ANode;

  vstUsersOrg.DeleteNode(ONode);
  btnOrgRemove.Enabled := vstUsersOrg.GetFirstSelected <> nil;
end;

procedure TOrgvsUsersForm.FormCreate(Sender: TObject);
begin
  vstUsersAll.NodeDataSize := SizeOf(TUserData);
  vstUsersOrg.NodeDataSize := SizeOf(TUserData);

  btnOrgAdd.Enabled    := false;
  btnOrgRemove.Enabled := false;
end;

procedure TOrgvsUsersForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin
      ModalResult := mrCancel;
    end; // VK_ESCAPE
  else
    inherited;
  end; // Case
end;

procedure TOrgvsUsersForm.vstUsersAllChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  btnOrgAdd.Enabled := Node <> nil;
end;

procedure TOrgvsUsersForm.vstUsersCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  D1 : PUserData;
  D2 : PUserData;
begin
	D1 := Sender.GetNodeData(Node1);
  D2 := Sender.GetNodeData(Node2);
	Result := AnsiCompareText(D1.Name, D2.Name);
end;

end.
