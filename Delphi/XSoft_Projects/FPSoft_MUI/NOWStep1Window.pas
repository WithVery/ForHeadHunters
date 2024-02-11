unit NOWStep1Window;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sMemo, sButton, ExtCtrls, sPanel, VirtualTrees,
  Globalvars,
  sRadioButton, sLabel;

type
  TNOWStep1Form = class(TForm)
    sPanel1: TsPanel;
    FinishButton: TsButton;
    NextStepButton: TsButton;
    CancelButton: TsButton;
    PrevStepButton: TsButton;
    sLabel1: TsLabel;
    NoParentRadio: TsRadioButton;
    HasParentRadio: TsRadioButton;
    WOrgTree: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure WOrgTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure NoParentRadioClick(Sender: TObject);
    procedure HasParentRadioClick(Sender: TObject);
    procedure FinishButtonClick(Sender: TObject);
    procedure WOrgTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure CancelButtonClick(Sender: TObject);
    procedure NextStepButtonClick(Sender: TObject);
    procedure PrevStepButtonClick(Sender: TObject);
  private
    { Private declarations }
    function GetCurPrntID : integer;
    procedure OkButtonEnable;
  public
    { Public declarations }
    FinishPressed   : boolean;
    NextStepPressed : boolean;
    PrevStepPressed : boolean;
    CurPrntID       : integer;
  end;

implementation

{$R *.dfm}

procedure TNOWStep1Form.OkButtonEnable;
begin
  CurPrntID := GetCurPrntID;
  FinishButton.Enabled  := (CurPrntID > 0) or NoParentRadio.Checked;

end;

procedure TNOWStep1Form.PrevStepButtonClick(Sender: TObject);
begin
  NextStepPressed := false;
  PrevStepPressed := true;
  FinishPressed   := false;
  ModalResult := mrOK;
end;

function TNOWStep1Form.GetCurPrntID : integer;
var
  OData	: POrgData;
  Node  : PVirtualNode;
begin
  if not WOrgTree.Enabled then begin
    result := 0;
    Exit;
  end;

  Node := WOrgTree.GetFirstSelected;

  if Node = nil then begin
    Result := 0;
  	Exit;
  end;

	OData := WOrgTree.GetNodeData(Node);
  Result := OData.ID;
end;

procedure TNOWStep1Form.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TNOWStep1Form.FinishButtonClick(Sender: TObject);
begin
  NextStepPressed := false;
  PrevStepPressed := false;
  FinishPressed   := true;
  ModalResult := mrOK;
end;

procedure TNOWStep1Form.FormCreate(Sender: TObject);
	function GetPONode(ANode : PVirtualNode; APID : integer) : PVirtualNode;
	var
		TN : PVirtualNode;
	  RN : PVirtualNode;
  	OD : POrgData;
	begin

		RN := nil;
		TN := WOrgTree.GetFirstChild(ANode);

		while TN <> nil do begin
  		OD := WOrgTree.GetNodeData(TN);
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
    	TN := WOrgTree.GetNextSibling(TN);
	  end; // while
  	Result := RN;
	end;

var
  OData		: POrgData;
  ONode		: PVirtualNode;
  PONode	: PVirtualNode;
  PID			: integer;

begin
  FinishPressed   := false;
  NextStepPressed := false;
  PrevStepPressed := false;

  WOrgTree.NodeDataSize := SizeOF(TOrgData);

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

		ONode						:= WOrgTree.AddChild(PONode);
	  ONode.CheckType := ctCheckBox;

  	OData						:= WOrgTree.GetNodeData(ONode);
	  OData.ID				:= FPMainDataset.FieldByName('id').AsInteger;
	  OData.ShortName	:= FPMainDataset.FieldByName('Abbr').AsString;
    OData.Prefix    := FPMainDataset.FieldByName('Prefix').AsString;

    FPMainDataset.Next;
  end;

  WOrgTree.FullExpand;

end;

procedure TNOWStep1Form.HasParentRadioClick(Sender: TObject);
begin
  WOrgTree.Enabled  := HasParentRadio.checked;
  CurPrntID := GetCurPrntID;
  OkButtonEnable;
end;

procedure TNOWStep1Form.NextStepButtonClick(Sender: TObject);
begin
  NextStepPressed := true;
  PrevStepPressed := false;
  FinishPressed   := false;
  ModalREsult := mrOk;
end;

procedure TNOWStep1Form.NoParentRadioClick(Sender: TObject);
begin
  WOrgTree.Enabled  := not NoParentRadio.checked;
  OkButtonEnable;
end;

procedure TNOWStep1Form.WOrgTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  CurPrntID := GetCurPrntID;
  OkButtonEnable;
end;

procedure TNOWStep1Form.WOrgTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  OData	: POrgData;
begin
	CellText := '';

  if Node = nil then
  	Exit;

	OData := Sender.GetNodeData(Node);
  CellText := OData.ShortName;
end;

end.
