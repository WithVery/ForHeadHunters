unit FPFundsListWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, VirtualTrees;

type
  TFPFundsListForm = class(TForm)
    FundsTree: TVirtualStringTree;
    sPanel1: TsPanel;
    procedure FormCreate(Sender: TObject);
    procedure FundsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FundsTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FundsTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(Var Params : TCreateParams); override;
  public
    { Public declarations }
    FPAllocHadle : HWND;
    function GetNodeByFundName(AFundName : string) : PVirtualNode;
  end;

//var
//  FPFundsListForm: TFPFundsListForm;

implementation

uses
  GlobalVars;

{$R *.dfm}

Procedure TFPFundsListForm.CreateParams(Var Params : TCreateParams);
Begin
  inherited CreateParams(Params);
  Params.WndParent := 0;
End;

procedure TFPFundsListForm.FormCreate(Sender: TObject);
begin
  FundsTree.NodeDataSize := sizeof(TFFLData)
end;

procedure TFPFundsListForm.FormHide(Sender: TObject);
begin
  PostMessage(FPAllocHadle, UM_FP_FUNDSLISTHIDE, 0, 0);
end;

procedure TFPFundsListForm.FundsTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1 : PFFLData;
  Data2 : PFFLData;
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

procedure TFPFundsListForm.FundsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  NodeData : PFFLData;
begin
  CellText := '';
  if Node = nil then
    Exit;

  NodeData := Sender.GetNodeData(Node);
  case Column of
    0: CellText := NodeData.name;
    1: CellText := MyFloatToStr(NodeData.InAmnt);
    2: CellText := MyFloatToStr(NodeData.FPAmnt);
    3: CellText := MyFloatToStr(NodeData.POAmnt);
    4: CellText := MyFloatToStr(NodeData.InAmnt + NodeData.FPAmnt - NodeData.POAmnt);
  end;
end;

procedure TFPFundsListForm.FundsTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
Var
  NodeData : PFFLData;
begin
  NodeData := Sender.GetNodeData(Node);
  if Round((NodeData.InAmnt + NodeData.FPAmnt - NodeData.POAmnt) * 100) < 0 then begin
    TargetCanvas.Font.Color := clRed;
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
  end;
  if NodeDAta.IsInFP then begin
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
  end;
end;

function TFPFundsListForm.GetNodeByFundName(AFundName : string) : PVirtualNode;
var
  TN : PVirtualNode;
  SN : string;
begin
  Result := nil;
  TN := FundsTree.GetFirstChild(nil);
  while TN <> nil do begin
    if PFFLData(FundsTree.GetNodeData(TN)).name = AFundName then begin
      Result := TN;
      break;
    end;
    TN := FundsTree.GetNextSibling(TN);
  end;
end;


end.
