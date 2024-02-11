unit StaffList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, acAlphaImageList, StdCtrls, Buttons, sBitBtn, VirtualTrees,
  sButton, ExtCtrls, sPanel;

type
  TStaffListForm = class(TForm)
    StaffListVT: TVirtualStringTree;
    AssignBtn: TsBitBtn;
    CancelBtn: TsBitBtn;
    sPanel1: TsPanel;
    Edit1: TEdit;
    sAlphaImageList1: TsAlphaImageList;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure StaffListVTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Type
  PStaffListNode = ^TStaffListNode;
  TStaffListNode = record
    StaffID       : integer;
    StaffFullName : string;
  end;

var
  StaffListForm: TStaffListForm;

implementation

{$R *.dfm}

procedure TStaffListForm.FormCreate(Sender: TObject);
begin
  StaffListVT.NodeDataSize := SizeOf(TStaffListNode);
end;

procedure TStaffListForm.StaffListVTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PStaffListNode;
begin
  NodeData := Sender.GetNodeData(Node);
  CellText := NodeData.StaffFullName;
end;

end.
