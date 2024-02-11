unit WEEditWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  Dialogs, ExtCtrls, sPanel, ComCtrls, sListView, StdCtrls, sButton, sLabel, VirtualTrees, sListBox, sMonthCalendar, DKLang;

type
  TWEEditForm = class(TForm)
    pnl: TsPanel;
    vstOrgs: TVirtualStringTree;
    lblOrgList: TsLabel;
    btnCancel: TsButton;
    btnOK: TsButton;
    lblWEList: TsLabel;
    lblNextWE: TsLabel;
    mc: TsMonthCalendar;
    vstWED: TVirtualStringTree;
    lc: TDKLanguageController;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstOrgsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstOrgsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstWEDChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstWEDGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    { Private declarations }
    CurOrgID : integer;
    CurWEDay : integer;
		procedure ChangeWEDate(CD : integer);
  public
    { Public declarations }
  end;

type
	PDOW = ^TDOW;
  TDOW = record
  	ID : integer;
    Title : string;
  end;

//var
//  WEEditForm: TWEEditForm;

implementation

{$R *.dfm}

procedure TWEEditForm.FormCreate(Sender: TObject);
var
	Node : PVirtualNode;
  Data : PDOW;
begin
  vstOrgs.NodeDataSize := SizeOF(TOrgData);
  vstWED.NodeDataSize := SizeOF(TDOW);

  Node := vstWED.AddChild(nil);
  Data := vstWED.GetNodeData(Node);
  Data.ID := 1;
  Data.Title := 'Понедельник';

  Node := vstWED.AddChild(nil);
  Data := vstWED.GetNodeData(Node);
  Data.ID := 2;
  Data.Title := 'Вторник';

  Node := vstWED.AddChild(nil);
  Data := vstWED.GetNodeData(Node);
  Data.ID := 3;
  Data.Title := 'Среда';

  Node := vstWED.AddChild(nil);
  Data := vstWED.GetNodeData(Node);
  Data.ID := 4;
  Data.Title := 'Четверг';

  Node := vstWED.AddChild(nil);
  Data := vstWED.GetNodeData(Node);
  Data.ID := 5;
  Data.Title := 'Пятница';

  Node := vstWED.AddChild(nil);
  Data := vstWED.GetNodeData(Node);
  Data.ID := 6;
  Data.Title := 'Суббота';

  Node := vstWED.AddChild(nil);
  Data := vstWED.GetNodeData(Node);
  Data.ID := 7;
  Data.Title := 'Воскресенье';

	CurOrgID := -1;
  CurWEDay := -1;
end;

procedure TWEEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin
      ModalResult := mrCancel;
    end; // VK_ESCAPE
  else
    inherited;
  end; // Case
end;

procedure TWEEditForm.vstOrgsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
	Data : POrgData;
begin
	if Node = nil then begin
	  CurOrgID  := -1;
  end
  else begin
  	Data := Sender.GetNodeData(Node);
    CurOrgID := Data.ID;
  end;

  ChangeWEDate(Data.swe);
end;

procedure TWEEditForm.ChangeWEDate(CD : integer);
var
	Node : PVirtualNode;
  Data : PDOW;
begin
  mc.ShowSelectAlways := false;
  vstWED.ClearSelection;
	CurWEDay := -1;
  if (CD < 1) and (CD > 7) then Exit;

  Node := vstWED.GetFirstChild(nil);
  while Node <> nil do begin
    Data := vstWED.GetNodeData(Node);
    if Data.ID = CD then begin
    	vstWED.Selected[Node] := true;
      break;
    end;
    Node := vstWED.GetNextSibling(Node);
  end;
end;

procedure TWEEditForm.vstOrgsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;   var CellText: string);
var
	Data : POrgData;
begin
	if Node <> nil then begin
    Data := Sender.GetNodeData(Node);
    CellText := Data.ShortName;
  end;
end;

procedure TWEEditForm.vstWEDChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
	Data : PDOW;
begin
  mc.ShowSelectAlways := false;
	CurWEDay := -1;
  if Node = nil then Exit;
  Data := Sender.GetNodeData(Node);

	CurWEDay := Data.ID;
  mc.CalendarDate := GetNextWEDay(now, CurWEDay);
  mc.ShowSelectAlways := true;

  case CurWEDay of
    1 : mc.Weekends := [dowMonday];
    2 : mc.Weekends := [dowTuesday];
    3 : mc.Weekends := [dowWednesday];
    4 : mc.Weekends := [dowThursday];
    5 : mc.Weekends := [dowFriday];
    6 : mc.Weekends := [dowSaturday];
    7 : mc.Weekends := [dowSunday];
  end;
end;

procedure TWEEditForm.vstWEDGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
	Data : PDOW;
begin
  if Node = nil then Exit;
  Data := Sender.GetNodeData(Node);
  CellText := Data.Title
end;

end.
