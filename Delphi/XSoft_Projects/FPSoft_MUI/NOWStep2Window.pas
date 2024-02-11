unit NOWStep2Window;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, StdCtrls, sRadioButton, sButton, sLabel, ExtCtrls,
  GlobalVars,
  sPanel;

type
  TNOWStep2Form = class(TForm)
    sPanel1: TsPanel;
    sLabel1: TsLabel;
    FinishButton: TsButton;
    NextStepButton: TsButton;
    CancelButton: TsButton;
    PrevStepButton: TsButton;
    NoTemplateRadio: TsRadioButton;
    HasTemplateRadio: TsRadioButton;
    WOrgTree: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FinishButtonClick(Sender: TObject);
    procedure HasTemplateRadioClick(Sender: TObject);
    procedure NextStepButtonClick(Sender: TObject);
    procedure NoTemplateRadioClick(Sender: TObject);
    procedure WOrgTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure WOrgTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure PrevStepButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetCurTmpltID;
  public
    { Public declarations }
    FinishPressed   : boolean;
    NextStepPressed : boolean;
    PrevStepPressed : boolean;
    TmpltOrgID      : integer;
  end;

//var
//  NOWStep2Form: TNOWStep2Form;

implementation

{$R *.dfm}
procedure TNOWStep2Form.GetCurTmpltID;
var
  OData	: POrgData;
  Node  : PVirtualNode;
begin
  if not WOrgTree.Enabled then begin
    TmpltOrgID := 0;
    Exit;
  end;

  WOrgTree.GetFirstSelected;

  if Node = nil then begin
    TmpltOrgID := 0;
  	Exit;
  end;

	OData := WOrgTree.GetNodeData(Node);
  TmpltOrgID := OData.ID;
end;

procedure TNOWStep2Form.HasTemplateRadioClick(Sender: TObject);
begin
  WOrgTree.Enabled  := HasTemplateRadio.checked;
  GetCurTmpltID;
end;

procedure TNOWStep2Form.NextStepButtonClick(Sender: TObject);
begin
  NextStepPressed := true;
  PrevStepPressed := false;
  FinishPressed   := false;
  ModalREsult := mrOk;
end;

procedure TNOWStep2Form.NoTemplateRadioClick(Sender: TObject);
begin
  WOrgTree.Enabled  := not NoTemplateRadio.checked;
end;

procedure TNOWStep2Form.PrevStepButtonClick(Sender: TObject);
begin
  NextStepPressed := false;
  PrevStepPressed := true;
  FinishPressed   := false;
  ModalREsult := mrOk;
end;

procedure TNOWStep2Form.WOrgTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  GetCurTmpltID;
end;

procedure TNOWStep2Form.WOrgTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  OData	: POrgData;
begin
	CellText := '';

  if Node = nil then
  	Exit;

	OData := Sender.GetNodeData(Node);
  CellText := OData.ShortName;
end;

procedure TNOWStep2Form.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TNOWStep2Form.FinishButtonClick(Sender: TObject);
begin
  NextStepPressed := false;
  PrevStepPressed := false;
  FinishPressed   := true;
  ModalResult := mrOK;
end;

procedure TNOWStep2Form.FormCreate(Sender: TObject);
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

end.
