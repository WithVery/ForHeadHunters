unit UserOrgTransferWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  Dialogs, VirtualTrees, StdCtrls, sButton, ExtCtrls, sPanel;

type
  TUserOrgTransferForm = class(TForm)
    OrgsTree: TVirtualStringTree;
    sPanel1: TsPanel;
    SaveButton: TsButton;
    CancelButton: TsButton;
    sPanel2: TsPanel;
    procedure FormCreate(Sender: TObject);
    procedure OrgsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
	function GetPONode(ANode : PVirtualNode; APID : integer) : PVirtualNode;
  public
    { Public declarations }
    CurOrgID  : integer;
    CurUserID : integer;
    procedure InitForm;
  end;

//var
//  UserOrgTransferForm: TUserOrgTransferForm;

implementation

{$R *.dfm}
Uses
	ZDbcIntfs;

	function TUserOrgTransferForm.GetPONode(ANode : PVirtualNode; APID : integer) : PVirtualNode;
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

procedure TUserOrgTransferForm.InitForm;
var
  OData		: POrgData;
  ONode		: PVirtualNode;
  PONode	: PVirtualNode;
  PID			: integer;
begin

  FPMainDataset.SQL.Text := 'SELECT ID,SeniorID,Abbr,Prefix FROM`orgs`WHERE ID<>:fID ORDER BY SeniorID,ID ASC';
  FPMainDAtaset.ParamByName('fID').AsInteger := CurOrgID;
  FPMainDataset.Open;

  while not FPMainDataset.Eof do begin

  	PID	:= FPMainDataset.FieldByName('SeniorID').AsInteger;
    if PID = 0 then begin
    	PONode := nil
    end
    else begin
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
end;
procedure TUserOrgTransferForm.OrgsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  OData	: POrgData;
begin
	CellText := '';

  if Node = nil then
  	Exit;

	OData := Sender.GetNodeData(Node);
  CellText := OData.ShortName;
end;

procedure TUserOrgTransferForm.SaveButtonClick(Sender: TObject);
var
  Node : PVirtualNode;
  NodeData : POrgData;
  NoError : boolean;
begin
  Node := OrgsTree.GetFirstChild(nil);

  while Node <> nil do begin
    if Node.CheckState = csCheckedNormal then begin
      NodeData := OrgsTree.GetNodeData(Node);

      NoError := true;
      FPMainDataset.SQL.Text := 'INSERT INTO uofp(`UserID`,`OrgID`,`FPPrivs`)VALUES(:fUserID,:fOrgID,"a")ON DUPLICATE KEY UPDATE UserID=:fUserID';
      FPMainDataset.ParamByName('fUserID').AsInteger := CurUserID;
      FPMainDataset.ParamByName('fOrgID').AsInteger  := NodeData.ID;// CurOrgID;
      try
      FPMainDataset.ExecSQL;
      FPMainDataset.SQL.Text := 'COMMIT';
      FPMainDataset.ExecSQL;
      except
  	    on e: EZSQLException do begin
		      GlobalVars.ShowError(Self, 'При сохранении информации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
	      end;
      end;

      if NoError  then begin
        Application.MessageBox('Добавление пользователя прошло успешно.', 'Завершение операции', MB_OK or MB_ICONINFORMATION);
        ModalResult := mrOk;
      end
    end;
    Node := OrgsTree.GetNextSibling(Node);
  end;
  ModalResult := mrOK;
end;

procedure TUserOrgTransferForm.FormCreate(Sender: TObject);
begin
	OrgsTree.NodeDataSize	:= SizeOf(TOrgData);
end;

end.
