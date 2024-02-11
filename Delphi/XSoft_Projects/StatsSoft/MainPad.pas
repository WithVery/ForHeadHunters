unit MainPad;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  StatGroupWindow,
  ZConnection,
  uLkJSON,
  ActiveX,
  ZDataset,
  IniFiles,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, VirtualTrees, StdCtrls, sComboBox,
  sButton, Mask, sMaskEdit, sCustomComboEdit, sTooledit, Menus, ImgList,
  acAlphaImageList, Buttons, sBitBtn, sLabel, sToolBar, sSplitter, sScrollBox, sSkinManager, ActnList, DKLang,
  System.Actions, System.ImageList;

type
  TVTCustomEditor = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TEdit;           // Базовый класс для каждого типа редактора
    FTree: TVirtualStringTree;  // Ссылка на дерево, вызвавшее редактирование
    FNode: PVirtualNode;        // Редактируемый узел
    FColumn: Integer;           // Его колонка, в которой оно происходит
    // for tracking editing value
    FDecSepAlreadyPresent : boolean;              // Sign of the value
    FSignAlreadyPresent   : boolean;            // Decimal separator
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
  public
    destructor Destroy; override;
    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;

type
  TMainStatForm = class(TForm)
    StatsList: TVirtualStringTree;
    WeeksCombo: TsComboBox;
    EndDateEdit: TsDateEdit;
    StatListPopUpMenu: TPopupMenu;
    AddStat: TMenuItem;
    ImageList1: TImageList;
    StatProp: TMenuItem;
    TBImageList: TsAlphaImageList;
    SwitchViewBtn: TsBitBtn;
    PrintStatBtn: TsBitBtn;
    StatAddBtn: TsBitBtn;
    StatPropBtn: TsBitBtn;
    StatDelBtn: TsBitBtn;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    TileGraphsBtn: TsBitBtn;
    sButton1: TsButton;
    sToolBar1: TsToolBar;
    btnCTPT: TsButton;
    btnCTPSep: TToolButton;
    btnCTPF: TsButton;
    StartDateEdit: TsDateEdit;
    DelBtnMenuItem: TMenuItem;
    btnRefreshWeeks: TsBitBtn;
    btnCTPRefresh: TsBitBtn;
    N1: TMenuItem;
    GroupStatCreate: TMenuItem;
    GroupStatDel: TMenuItem;
    GroupStatProp: TMenuItem;
    StatusBar: TStatusBar;
    ToolButton4: TToolButton;
    sButton4: TsButton;
    ShowKindComboBox: TsComboBox;
    ChangeViewModeBtn: TsBitBtn;
    Splitter1: TsSplitter;
    ScrollBox: TsScrollBox;
    btnAbout: TsBitBtn;
    RTimer: TTimer;
    mm: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    miSettings: TMenuItem;
    miAcccess: TMenuItem;
    miGeneral: TMenuItem;
    al: TActionList;
    acCloseAllWindows: TAction;
    miWindows: TMenuItem;
    miAlignStatWindows: TMenuItem;
    miCloseAllWindows: TMenuItem;
    sBitBtn1: TsBitBtn;
    lc: TDKLanguageController;
    procedure FormCreate(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure StatsListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure StatsListDblClick(Sender: TObject);
    procedure StatsListPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure AddStatClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StatsListKeyPress(Sender: TObject; var Key: Char);
    procedure StatsListEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure StatsListNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure Button1Click(Sender: TObject);
    procedure StatsListEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure StatsListCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
    procedure StatListPopUpMenuPopup(Sender: TObject);
    procedure StatPropClick(Sender: TObject);
    procedure SwitchViewBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure TileGraphsBtnClick(Sender: TObject);
    procedure StatsListClick(Sender: TObject);
    procedure StatsListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure StatAddBtnClick(Sender: TObject);
    procedure DelBtnMenuItemClick(Sender: TObject);
    procedure StatDelBtnClick(Sender: TObject);
    procedure StatPropBtnClick(Sender: TObject);
    procedure btnRefreshWeeksClick(Sender: TObject);
    procedure btnCTPRefreshClick(Sender: TObject);
    procedure GroupStatCreateClick(Sender: TObject);
    procedure StatsListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure GroupStatPropClick(Sender: TObject);
    procedure GroupStatDelClick(Sender: TObject);
    procedure StatsListDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure StatsListDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure StatsListDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure StatsListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StatsListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ChangeViewModeBtnClick(Sender: TObject);
    procedure StatsListEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure oSplitter1Moved(Sender: TObject);
    procedure StatsListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormDestroy(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure RTimerTimer(Sender: TObject);
    procedure miAcccessClick(Sender: TObject);
    procedure miGeneralClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure acCloseAllWindowsExecute(Sender: TObject);
    procedure StatsListBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
      var ContentRect: TRect);
  private
    { Private declarations }
    i : integer;
    ServerAddress : string;
    ServerPort    : integer;
    UserName      : string;
    UserPwd       : string;
    SeledNode     : PVirtualNode;
    ShowWithPosts : integer;
    Dragging      : boolean;
    StatListWidth	: integer;
    SOrgID        : integer;
    SSubID        : integer;
    DSubID        : integer;
    function  GetValuesFromDatabase(Dataset : TZQuery; StatID : integer; DatesList : array of TDateTime; var Vals : TList): boolean;
    procedure ChildWinCloseMsg(var Msg: TMessage);        message CM_CHILDFORMCLOSE;
    procedure OnGroupAdded(var Msg: TMessage);            message CM_GROUPADDEDFROMAS;
    procedure OnStatAdded(var Msg: TMessage);             message CM_STATADDEDFROMAS;
    procedure OnStatNameChanged(var Msg: TMessage);       message CM_STATNAMECHANGED;
    procedure OnStatValChanged(var Msg: TMessage);        message CM_STVALCHANGEDFROMAS;
    procedure OnDateRangeChanged(var Msg: TMessage);      message CM_DATE_RANGE_CHANGED;

    procedure UnshowStat(AID, AType : integer);
    function  GetStatValue(StName: string; Dt : string) : string;
    function  GetGroupNodeByGroupID(SomeGroupID: integer): PVirtualNode;
    function  GetOrgNodeByID(AOrgID: integer): PVirtualNode;
    function  GetOrgByStatNode(AStatNode: PVirtualNode): PVirtualNode;
    function  GetNodeByOrgAndSubdivID(AOrgID: integer; ASubDivID: integer): PVirtualNode;
    procedure InitStatsList;
    procedure InitWEs(AOrgID, Awe : integer);
    procedure ClearStatsList;       // clear the statslist and close all open window stats
    procedure FillComboWithOrgs(AList : TComboBox; ACurOrgID : integer; AUserID: integer);
		procedure SetUpNumOfWeeks;
		procedure LoadValues(var aStat: PStat);
    procedure OpenStatByNode(Node: PVirtualNode);
    procedure SwitchFPStats(aVisible : boolean);
    procedure SwitchStatHeader(aHeaderVisible : boolean);
    function  GetDateFromCol(aNode : PVirtualNode; nCol : integer) : TDate;
    procedure LoadAllStats;

    // VirtualStringTree edit helpers
    procedure OnVSTEndEdit(var Msg: TMessage);             message UM_VST_END_EDIT;
  public
    { Public declarations }
    Date1 : TDate;
    FIsEditing  : boolean;
    function GetStatValuesOfNodeByID(SomeStatID, SomeStatType: integer): PAStatValue; // return array of values for a Node
    procedure InitDB;
    function GetStatNodeByID(AStatID, AStatType: integer): PVirtualNode;
  end;

var
  MainStatForm: TMainStatForm;

implementation

{$R *.dfm}

uses
	PadWin,
  NewStatWindow,
  Chart,
  Series,
  TeEngine,
  ZDbcIntfs,
  LoginWindow,
  ErrorWindow,
  AboutWindow,
  Printers,
	AccessWindow,
	WEEditWindow,
  ClipBrd,
  StrUtils;

procedure TMainStatForm.CMDialogKey(var Msg: TWMKEY);
begin
  if not ((ActiveControl is TEdit) or (Msg.Charcode = VK_TAB)) then
    inherited;
end;

function  TMainStatForm.GetDateFromCol(aNode : PVirtualNode; nCol : integer) : TDate;
var
  i : integer;
  NodeData :PStat;
  PDates   : POrgDates;
begin
  result := 0;
  NodeData := StatsList.GetNodeData(aNode);
  if NodeData.kind <> SVK_ORG then
    i := NodeData.OrgID  // it's a normal stat
  else
    i := NodeData.ID;     // it's an org
  if i < Length(arrOrgPfxs) then begin
    PDates := arrOrgDates[i];
    if PDates <> nil then begin
      i := StatsList.Header.Columns.Count - 1 - nCol;
      if (i >= 0) and (i < Length(PDates.StatDates)) then begin
        result := PDates.StatDates[i];
      end;
    end;
  end;
end;

procedure TMainStatForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  {$IFNDEF PROJECTISDLL}
  Params.ExStyle  := Params.ExStyle or WS_Ex_AppWindow;
  Params.WndParent:= 0;
  {$ENDIF}
end;

procedure TMainStatForm.OnGroupAdded(var Msg: TMessage);
var
  CurGroupID  : integer;
  GroupNode   : PVirtualNode;
  NewStatNode : PVirtualNode;
  NewStatData : PStat;
begin
  FPMainDataset.Close;
  FPMainDataset.SQL.Text := 'SELECT * FROM statgroups WHERE ID=' + IntToStr(Msg.WParam);
  FPMainDataset.Open;
//  FPMainDataset.First;
  if not FPMainDataset.Eof then begin
    CurGroupID  := FPMainDataset.FieldByName('ID').AsInteger;
    GroupNode   := GetGroupNodeByGroupID(CurGroupID);
    if GroupNode <> nil then
      Exit;
//    NewStatNode := StatsList.AddChild(GroupNode);
    NewStatNode := StatsList.InsertNode(GroupNode, amAddChildLast);

    NewStatData := StatsList.GetNodeData(NewStatNode);
    NewStatData.ID := FPMainDataset.FieldByName('ID').AsInteger;
    NewStatData.ShortDescription  := FPMainDataset.FieldByName('Description').AsString;
    SetLength(NewStatData.Values, 0);
    NewStatData.FullDescription   := FPMainDataset.FieldByName('FullDescription').AsString;
    NewStatData.kind  := SVK_GROUP;
    StatsList.ReinitNode(NewStatNode, true);
  end;
end;

procedure TMainStatForm.OnStatAdded(var Msg: TMessage);
var
  CurGroupID  : integer;
  GroupNode   : PVirtualNode;
  NewStatNode : PVirtualNode;
  NewStatData : PStat;
begin
  FPMainDataset.Close;
  FPMainDataset.SQL.Text := 'SELECT * FROM statdescr WHERE StatID=' + IntToStr(Msg.WParam);
  FPMainDataset.Open;
//  FPMainDataset.First;
  if not FPMainDataset.Eof then begin
    CurGroupID  := FPMainDataset.FieldByName('GroupID').AsInteger;
    GroupNode   := GetGroupNodeByGroupID(CurGroupID);
//    NewStatNode := StatsList.AddChild(GroupNode);
    NewStatNode := StatsList.InsertNode(GroupNode, amAddChildLast);
    NewStatData := StatsList.GetNodeData(NewStatNode);

    NewStatData.ID               := FPMainDataset.FieldByName('StatID').AsInteger;
    NewStatData.ShortDescription := FPMainDataset.FieldByName('ShortName').AsString;
    SetLength(NewStatData.Values, 0);
    NewStatData.FullDescription  := FPMainDataset.FieldByName('Description').AsString;
    NewStatData.kind             := SVK_STAT;
    NewStatData.Shown            := false;
    NewStatData.ValuesLoaded     := true;
    NewStatData.MinYValue        := FPMainDataset.FieldByName('MinYValue').AsExtended;
    NewStatData.MaxYValue        := FPMainDataset.FieldByName('MaxYValue').AsExtended;
    NewStatData.MinYAuto         := FPMainDataset.FieldByName('MinYAuto').AsInteger = 1;
    NewStatData.MaxYAuto         := FPMainDataset.FieldByName('MaxYAuto').AsInteger = 1;
    StatsList.ReinitNode(NewStatNode, true);
  end;
end;

procedure TMainStatForm.OnStatNameChanged(var Msg: TMessage);
var
//  tmpStr    : string;
  PStatDesc : PStat;
  StatNode  : PVirtualNode;
  NodeData  : PStat;
begin
  PStatDesc := PStat(pointer(msg.WParam));
  StatNode := GetStatNodeByID(PStatDesc.ID, PStatDesc.kind);
  if StatNode <> nil then begin
    NodeData := StatsList.GetNodeData(StatNode);
    NodeData.FullDescription := PStatDesc.FullDescription;
    NodeData.ShortDescription := PStatDesc.ShortDescription;
    StatsList.InvalidateNode(StatNode);
    StatsList.Invalidate;
  end;
end;

procedure TMainStatForm.OnStatValChanged(var Msg: TMessage);
var
//  tmpStr    : string;
  PStatVal  : PStatValue;
  StatNode  : PVirtualNode;
  NodeData  : PStat;
  i         : integer;
  SmallWin  : TSmallWin;
begin
  PStatVal := PStatValue(pointer(msg.WParam));
  StatNode := GetStatNodeByID(msg.LParam, SVK_STAT);
  if StatNode = nil then
    Exit;

  if StatNode <> nil then begin
    NodeData := StatsList.GetNodeData(StatNode);
    for I := Low(NodeData.Values) to High(NodeData.Values) do
      if NodeData.Values[i].Date = PStatVal.Date then begin
        NodeData.Values[i].Value := PStatVal.Value;
        break;
      end;
    if i > High(NodeData.Values) then begin
      i := Length(NodeData.Values);
      SetLength(NodeData.Values, i+1);
      NodeData.Values[i].Date := PStatVal.Date;
      NodeData.Values[i].Value := PStatVal.Value;
    end;
    StatsList.InvalidateNode(StatNode);
    StatsList.Invalidate;
  end;

  // rebuild da Gaph if needed
  if NodeData.Shown then begin
    for I := 0 to ScrollBox.ControlCount - 1 do begin
      if (ScrollBox.Controls[i] is TSmallWin) then
        if TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID then begin
          SmallWin := TSmallWin(ScrollBox.Controls[i]);
          SmallWin.MinYAuto := NodeData.MinYAuto;
          SmallWin.MaxYAuto := NodeData.MaxYAuto;
          SmallWin.MinYValue  := NodeData.MinYValue;
          SmallWin.MaxYValue  := NodeData.MaxYValue;
          PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(NodeData.Values)), 0);
          break;
        end;
    end;
  end; // if NodeData.Shown ...
end;

function TMainStatForm.GetGroupNodeByGroupID(SomeGroupID: integer): PVirtualNode;
var
  TmpNode  : PVirtualNode;
  NodeData  : PStat;
begin
  Result := nil;
  TmpNode := StatsList.GetFirstChild(nil);
  while TmpNode <> nil do begin
    NodeData := StatsList.GetNodeData(TmpNode);
    if (NodeData.kind = SVK_GROUP) and (NodeData.ID = SomeGroupID) then begin
      Result := TmpNode;
      break;
    end;
    TmpNode := TmpNode.NextSibling;
  end; // while TmpNode <>
end;

function  TMainStatForm.GetOrgNodeByID(AOrgID: integer): PVirtualNode;
var
  TmpNode  : PVirtualNode;
  NodeData  : PStat;
begin
  Result := nil;
  TmpNode := StatsList.GetFirstChild(nil);
  while TmpNode <> nil do begin
    NodeData := StatsList.GetNodeData(TmpNode);
    if (NodeData.kind = SVK_ORG) and (NodeData.ID = AOrgID) then begin
      Result := TmpNode;
      break;
    end;
    TmpNode := TmpNode.NextSibling;
  end; // while TmpNode <>
end;

function  TMainStatForm.GetOrgByStatNode(AStatNode: PVirtualNode): PVirtualNode;
var
  TmpNode  : PVirtualNode;
  NodeData  : PStat;
begin
  Result := nil;

  if AStatNode = nil then Exit;
  TmpNode := AStatNode.Parent;

  while TmpNode <> nil do begin
    NodeData := StatsList.GetNodeData(TmpNode);
    if (NodeData.kind = SVK_ORG) then begin
      Result := TmpNode;
      break;
    end;
    TmpNode := TmpNode.Parent;
  end; // while TmpNode <>
end;

function  TMainStatForm.GetNodeByOrgAndSubdivID(AOrgID: integer; ASubDivID: integer): PVirtualNode;
var
  TmpNode  : PVirtualNode;
  NodeData : PStat;
begin
//
  TmpNode := GetOrgNodeByID(AOrgID);
  Result := TmpNode;
  if TmpNode <> nil then TmpNode := TmpNode.FirstChild;

  while TmpNode <> nil do begin
    NodeData := StatsList.GetNodeData(TmpNode);
    if (NodeData.kind <> SVK_STAT) and (NodeData.ID = ASubDivID) then begin
      Result := TmpNode;
      break;
    end;
    TmpNode := TmpNode.NextSibling;
  end;
end;

function TMainStatForm.GetStatValuesOfNodeByID(SomeStatID, SomeStatType: integer): PAStatValue;
var
  Node      : PVirtualNode;
  NodeData  : PStat;
begin
  Node := GetStatNodeByID(SomeStatID, SomeStatType);
  if (Node <> nil) then begin
    NodeData := StatsList.GetNodeData(Node);
    Result := Addr(NodeData.Values);
  end
  else
    Result := nil;
end;


procedure TMainStatForm.FormCreate(Sender: TObject);
var
  NodeData  : PStat;
  NewNode   : PVirtualNode;
  i         : integer;
  EndDate   : TDateTime;
  LogInForm : TLogInForm;

  UserName      : string;
  UserPwd       : string;
  DBUser        : string;
  DBPassword    : string;
  ServerPort    : integer;

  DBPasswordUE  : string;
  UserPwdUE     : string;

  Period        : string;
  Periods       : string;

begin
{$IFDEF NCP}
  btnCTPSep.Destroy;
  btnCTPF.Destroy;
  btnCTPT.Destroy;
  StartDateEdit.Destroy;
  EndDateEdit.Destroy;
  btnCTPRefresh.Destroy;
{$ENDIF}

  WeekStartsAt := 4; // temporarily

	StatListWidth := 200;
  StatusBar.Panels[0].Width := 250;
  StatusBar.Panels[1].Width := 250;
  StatusBar.Panels[0].Text  := rsUser + ' ' + UserLoginName;
  StatusBar.Panels[1].Text  := rsAccessLevel + ' ' + rsFull;

  StatShowMode := true;

  StatsList.Header.Columns[0].Text := rsTitle;
  StatsList.Header.Options := StatsList.Header.Options - [hoVisible];
  StatsList.ScrollBarOptions.ScrollBars := ssVertical;

  ShowKindComboBox.ItemIndex := 0;
  ShowWithPosts := ShowKindComboBox.ItemIndex;


  EndDate := GetPrevWEDay(Date + 1);
  StatsList.NodeDataSize := SizeOf(TStat);
  // misc
  WeeksCombo.Clear;
{$IFDEF MONTHLY}
  Period  := rsMonth;
  Periods := rsMonths;
{$ELSE}
  Period  := rsWeek;
  Periods := rsWeeks;
{$ENDIF}
  WeeksCombo.AddItem('3 ' + Period,  nil);
  WeeksCombo.AddItem('13 ' + Periods, nil);
  WeeksCombo.AddItem('26 ' + Periods, nil);
  WeeksCombo.AddItem('52 ' + Period, nil);

  WeeksCombo.ItemIndex := 1;

  CurNumOfWeeks := 13;
{$IFNDEF NCP}
  EndDateEdit.Date := EndDate;
{$ENDIF}
end;

procedure TMainStatForm.FormDestroy(Sender: TObject);
begin
  FPMainDataset := nil;
end;

procedure TMainStatForm.FormResize(Sender: TObject);
begin
  if StatShowMode then begin
		StatsList.Header.Columns[0].Width := StatsList.ClientWidth - 5;
	end
  else
    StatsList.Width := Width;
end;

procedure TMainStatForm.FormShow(Sender: TObject);
begin
  // temporarily remove the "settings" menu item
  miGeneral.Clear;

	SetUpNumOfWeeks;

  if StatShowMode then begin
    StatsList.Header.Columns[0].Width := StatsList.ClientWidth - 5
  end
  else begin
    StatsList.Header.Columns[0].Width := StatListWidth div 2;
  end;

    // parsing server parameters
	  try
		  FPMainDataset.SQL.Text:= 'SHOW VARIABLES LIKE "connect_timeout"';
  		FPMainDataset.Open;
	    i := FPMainDataset.FieldByName('Value').AsInteger;
  	  if i > 0 then begin
    	  cto := i * 1000;
	    end;
  	except
 	  	on e: EZSQLException do begin
	    	//ShowError(Self, rsConnSetupErr, e.ErrorCode, e.StatusCode, e.Message);
	      Exit;
  	  end;
	  end;

    RTimer.Enabled := true;
    RTimer.Interval := (cto div 5) * 4;

{$IFDEF WVT}
  SwitchViewBtn.Visible := true;
{$ELSE}
  SwitchViewBtn.Visible := false;
{$ENDIF}

end;

procedure TMainStatForm.TileGraphsBtnClick(Sender: TObject);
Var
  WinNums : Integer;
  i       : integer;
  j       : integer;
  StepX   : integer;
  StepY   : Integer;
  CX      : integer;
  CY      : integer;
begin
  WinNums := 0;
  for I := 0 to ScrollBox.ControlCount - 1 do begin
    if (ScrollBox.Controls[i] is TSmallWin) and (TSmallWin(ScrollBox.Controls[i]).Visible) then begin
      Inc(WinNums);
    end;
  end;

  j := 1;
  while j * j < WinNums do Inc(j);
  StepX := ScrollBox.ClientWidth  div j;
  StepY := ScrollBox.ClientHeight div j;

  CX := 0; CY := 0;
  for i := 0 to ScrollBox.ControlCount - 1 do begin
    if (ScrollBox.Controls[i] is TSmallWin) then begin
      if TSmallWin(ScrollBox.Controls[i]).Visible then begin
        TSmallWin(ScrollBox.Controls[i]).Left   := StepX * CX;
        TSmallWin(ScrollBox.Controls[i]).Top    := StepY * CY;
        TSmallWin(ScrollBox.Controls[i]).Width  := StepX - 1;
        TSmallWin(ScrollBox.Controls[i]).Height := StepY - 1;
        if CX < j - 1 then begin
          Inc(CX)
        end
        else begin
          Inc(CY);
          CX := 0;
        end;
      end;
    end;
  end;
end;

procedure TMainStatForm.oSplitter1Moved(Sender: TObject);
begin
  StatListWidth := Splitter1.Left;
  StatsList.Header.Columns[0].Width := StatsList.ClientWidth - 5;
end;

procedure TMainStatForm.StatDelBtnClick(Sender: TObject);
var
  Node: PVirtualNode;
  NodeData : PStat;
  i : integer;
begin
  if Application.MessageBox(PWideChar(rsSureToDeleteStat + CRLF + rsAllDataToDelete), PWideChar(rsConfirmDelete), MB_ICONWARNING or MB_OKCANCEL) = IDOK then begin
    Node := StatsList.GetFirstSelected;
    NodeData := StatsList.GetNodeData(Node);
    // Deleteing data from DB
    FPMainDataset.SQL.Text := 'DELETE FROM statvalues WHERE StatID='+IntToStr(NodeData.ID);
    FPMainDataset.ExecSQL;
    FPMainDataset.SQL.Text := 'DELETE FROM statdescr WHERE StatID='+IntToStr(NodeData.ID);
    FPMainDataset.ExecSQL;
    // removing graph from the scrollBox if it's there
    for I := 0 to ScrollBox.ControlCount - 1 do begin
        if (ScrollBox.Controls[i] is TSmallWin) then
          if TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID then begin
            TSmallWin(ScrollBox.Controls[i]).Free;
            break;
          end;
     end;
    StatsList.DeleteNode(Node);
  end;
end;

procedure TMainStatForm.StatListPopUpMenuPopup(Sender: TObject);
Var
  NodeData : PStat;
  Node: PVirtualNode;
  P   : TPoint;
begin
  P := StatsList.ScreenToClient(StatListPopupMenu.PopupPoint);
  Node := StatsList.GetNodeAt(P.X, P.Y);
  if ShowWithPosts = 1 then begin
    StatListPopupMenu.Items[3].Visible	:= false;
    StatListPopupMenu.Items[4].Caption  := rsPostCreate;
    StatListPopupMenu.Items[4].Visible	:= false;
    StatListPopupMenu.Items[5].Caption  := rsPostProperties;
    StatListPopupMenu.Items[5].Visible	:= false;
    StatListPopupMenu.Items[6].Caption  := rsPostDelete;
    StatListPopupMenu.Items[6].Visible	:= false;
  end
  else begin
    StatListPopupMenu.Items[3].Visible	:= true;
    StatListPopupMenu.Items[4].Caption  := rsGroupCreate;
    StatListPopupMenu.Items[4].Visible	:= true;
    StatListPopupMenu.Items[4].Enabled	:= true;
    StatListPopupMenu.Items[5].Caption  := rsGroupProperties;
    StatListPopupMenu.Items[5].Visible	:= true;
    StatListPopupMenu.Items[6].Caption  := rsGroupDelete;
    StatListPopupMenu.Items[6].Visible	:= true;
  end;

  if Node = nil then begin
    StatListPopupMenu.Items[1].Enabled := false;
    StatListPopupMenu.Items[2].Enabled := false;
    StatsList.ClearSelection;
    StatPropBtn.Enabled := false;
    StatDelBtn.Enabled  := false;
    StatListPopupMenu.Items[5].Enabled := false;
    StatListPopupMenu.Items[6].Enabled := false;
  end
  else begin
    NodeData := StatsList.GetNodeData(Node); // check whether it's a statgroup/post or a mere stat
    if NodeData.kind = SVK_STAT then begin               // Item is a Stat
      StatListPopupMenu.Items[1].Enabled := true;
      StatListPopupMenu.Items[2].Enabled := true;
      StatListPopupMenu.Items[5].Enabled := false;
      StatListPopupMenu.Items[6].Enabled := false;
      StatAddBtn.Enabled  := true;
      StatPropBtn.Enabled := true;
      StatDelBtn.Enabled  := true;
    end
    else begin                                    // item is a Group/post
      StatListPopupMenu.Items[1].Enabled := false;
      StatListPopupMenu.Items[2].Enabled := false;
      if ShowWithPosts > 0 then begin
	      StatListPopupMenu.Items[5].Enabled := false;
  	    StatListPopupMenu.Items[6].Enabled := false;
      end
      else begin
	      StatListPopupMenu.Items[5].Enabled := NodeData.kind = SVK_GROUP; //true;
  	    StatListPopupMenu.Items[6].Enabled := NodeData.kind = SVK_GROUP; //true;
      end;
      StatPropBtn.Enabled := false;
      StatDelBtn.Enabled := false;
    end;
  end;
end;

procedure TMainStatForm.StatPropBtnClick(Sender: TObject);
begin
  StatPropClick(Sender);
end;

procedure TMainStatForm.StatPropClick(Sender: TObject);
var
  NewStatForm         : TNewStatForm;
  CurNode             : PVirtualNode;
  NodeData            : PStat;
  OldFullDescription  : string;
  OldShortDescription : string;
//  StatWin             : TSmallWin;
  i                   : integer;
  ONode               : PVirtualNode;
  OData               : PStat;
  Caps                : string;
  SmallWin            : TSmallWin;
begin
//  CurNode := StatsList.GetFirstSelected;
//  CurNode := StatsList.FocusedNode;
  CurNode := SeledNode;
  NodeData := StatsList.GetNodeData(CurNode);

  NewStatForm := TNewStatForm.Create(nil);
  NewStatForm.Position                := poOwnerFormCenter;
  NewStatForm.Caption                 := rsStatProperties;
  OldFullDescription                  := NodeData.FullDescription;
  OldShortDescription                 := NodeData.ShortDescription;
  NewStatForm.ShortStatNameEdit.Text  := OldShortDescription;
  NewStatForm.FullStatNameMemo.Text   := OldFullDescription;
  NewStatForm.MinAutoCheckBox.Checked := NodeData.MinYAuto;
  NewStatForm.MinYEdit.Text           := FloatToStr(NodeData.MinYValue);
  NewStatForm.MaxAutoCheckBox.Checked := NodeData.MaxYAuto;
  NewStatForm.MaxYEdit.Text           := FloatToStr(NodeData.MaxYValue);
  NewStatForm.UDCheckBox.Checked      := NodeData.UpsideDown;
  NewStatForm.CurUserID               := NodeData.UserID;

  ONode := GetOrgByStatNode(CurNode);
  i := 0;
  if ONode <> nil then begin
    OData := StatsList.GetNodeData(ONode);
    i     := Odata.ID;
  end;

  FillComboWithOrgs(TComboBox(NewStatForm.OrgCombo), i, SUserID);
  NewStatForm.OrgCombo.Enabled := false;

  if NewStatForm.UDCheckBox.Checked then
    NewStatForm.MinAutoCheckBoxClick(sender);

  if (NewStatForm.ShowModal = mrOK) then begin
    NodeData.ShortDescription := Trim(NewStatForm.ShortStatNameEdit.Text);
    NodeData.FullDescription  := Trim(NewStatForm.FullStatNameMemo.Text);
    NodeData.MinYAuto         := NewStatForm.MinAutoCheckBox.Checked;
    NodeData.MaxYAuto         := NewStatForm.MaxAutoCheckBox.Checked;
    NodeData.MinYValue        := StrToFloat(NewStatForm.MinYEdit.Text);
    NodeData.MaxYValue        := StrToFloat(NewStatForm.MaxYEdit.Text);
    NodeData.UpsideDown       := NewStatForm.UDCheckBox.Checked;
    NodeData.UserID           := NewStatForm.CurUserID;

    StatsList.InvalidateNode(CurNode);
    // Dumping to the DB
    with FPMainDataset do begin
      SQL.Text := 'UPDATE statdescr SET Description=:fd,ShortName=:sd,MinYAuto=:minya,MaxYAuto=:maxya,MinYValue=:minyv,MaxYValue=:maxyv,UpsideDown=:pUpsideDown,UserID=:fUID WHERE StatID=:fSID';

      ParamByName('fd').AsString            := NodeData.FullDescription;
      ParamByName('sd').AsString            := NodeData.ShortDescription;
      ParamByName('minya').AsInteger        := Integer(NodeData.MinYAuto);
      ParamByName('maxya').AsInteger        := Integer(NodeData.MaxYAuto);
      ParamByName('minyv').AsFloat          := NodeData.MinYValue;
      ParamByName('maxyv').AsFloat          := NodeData.MaxYValue;
      ParamByName('pUpsideDown').AsInteger  := Integer(NodeData.UpsideDown);
      ParamByName('fSID').AsInteger         := NodeData.ID;
      ParamByName('fUID').AsInteger         := NodeData.UserID;
      ExecSQL;
    end;
  end;
  NewStatForm.Free;

  for i := 0 to ScrollBox.ControlCount - 1 do begin
    if (ScrollBox.Controls[i] is TSmallWin) then begin
      if TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID then begin
        SmallWin := TSmallWin(ScrollBox.Controls[i]);
        SmallWin.MinYAuto   := NodeData.MinYAuto;
        SmallWin.MaxYAuto   := NodeData.MaxYAuto;
        SmallWin.MinYValue  := NodeData.MinYValue;
        SmallWin.MaxYValue  := NodeData.MaxYValue;
        SmallWin.mInverted  := NodeData.UpsideDown;
        SmallWin.Caption    := NodeData.ShortDescription + ' ' + NodeData.PostName + ' ' + NodeData.UserName;
        PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(NodeData.Values)), 0);
      end;
      if TSmallWin(ScrollBox.Controls[i]).ID2 = NodeData.ID then begin
        SmallWin := TSmallWin(ScrollBox.Controls[i]);
        SmallWin.MinYAuto2  := NodeData.MinYAuto;
        SmallWin.MaxYAuto2  := NodeData.MaxYAuto;
        SmallWin.MinYValue2 := NodeData.MinYValue;
        SmallWin.MaxYValue2 := NodeData.MaxYValue;
        SmallWin.mInverted2 := NodeData.UpsideDown;
        PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(NodeData.Values)), 0);
      end;
    end;
  end;
  StatsList.SetFocus;
end;

procedure TMainStatForm.StatsListBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode;
  CellRect: TRect; var ContentRect: TRect);
begin
TargetCanvas.Font.Color := clSilver;
end;

procedure TMainStatForm.StatsListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
	Data : PStat;
begin
	if (Node <> nil) and (PStat(StatsList.GetNodeData(Node)).kind = SVK_STAT) then begin
    StatPropBtn.Enabled := true;
    StatDelBtn.Enabled	:= true;
    Data := StatsList.GetNodeData(Node);
    if Data.kind = SVK_ORG then SOrgID := Data.ID;
  end
  else begin
    StatPropBtn.Enabled := false;
    StatDelBtn.Enabled	:= false;
  end;
end;

procedure TMainStatForm.StatsListClick(Sender: TObject);
begin
  if StatsList.SelectedCount < 1 then begin // nothing selected
    SeledNode := nil;
    StatsList.ClearSelection;
  end
  else begin
    SeledNode := StatsList.GetFirstSelected;
  end;
end;

procedure TMainStatForm.StatsListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  NodeData1 : PStat;
  NodeData2 : PStat;
begin
  NodeData1 := Sender.GetNodeData(Node1);
  NodeData2 := Sender.GetNodeData(Node2);
  result    := -(NodeData1.kind - NodeData2.kind);
end;

procedure TMainStatForm.StatsListCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TVTCustomEditor.Create;
end;

procedure TMainStatForm.LoadValues(var aStat: PStat);
begin
  if aStat.flags = STF_FP then begin // if the stat is an FP stat
  	if CurNumOfWeeks > 0 then begin
      if aStat.kind = SVK_GROUP then begin
				FPTmpDataset.SQL.Text := 'SELECT td,sum(Value)as Value FROM(SELECT`index`,Date(`to`)AS`td`FROM`' + arrOrgPfxs[aStat.OrgID] + 'fp`WHERE`aprvd`=1 ORDER BY`to`DESC LIMIT 13)AS T1 LEFT JOIN statvalues ON T1.td=statvalues.Date WHERE StatID IN(SELECT StatID FROM Statdescr WHERE GroupID=:fsid)GROUP BY td';
  	    FPTmpDataset.ParamByName('fsid').AsInteger := aStat.ID;
      end
      else begin
	      FPTmpDataset.SQL.Text := 'SELECT td,Value FROM(SELECT`index`,Date(`to`)AS`td`FROM`' + arrOrgPfxs[aStat.OrgID] + 'fp`WHERE`aprvd`=1 ORDER BY`to`DESC LIMIT ' + IntToStr(CurNumOfWeeks) +')AS T1 LEFT JOIN statvalues ON T1.td=statvalues.Date WHERE StatID=:fsid';
  	    FPTmpDataset.ParamByName('fsid').AsInteger := aStat.ID;
      end;
      // Parsing data from DB
      try
        FPTmpDataset.Open;
      except
        on E: EZSQLException do begin
    	    //ShowError(Self, rsFailedToGetStatValues, e.ErrorCode, e.StatusCode, e.Message);
          Exit;
        end;
      end;

      //ShowMessage('NodeData.ID=' + IntToStr(NodeData.ID));
      SetLength(aStat.Values, 0);
      i := 0;
      while not FPTmpDataset.EOF do begin
        SetLength(aStat.Values, i + 1);
        with aStat.Values[i] do begin
          Value := FPTmpDataset.FieldByName('Value').AsFloat;
          Date  := FPTmpDataset.FieldByName('td').AsDateTime;
        end;
        Inc(i);
        FPTmpDataset.Next;
      end;
    end
    else begin  // time range is set up insteaed of Number of Weeks

    end;
	end
  else if aStat.flags = STF_US then begin // "usual" statistic
  	if CurNumOfWeeks > 0 then begin
      if aStat.kind = SVK_GROUP then begin
//				FPTmpDataset.SQL.Text := 'SELECT td,sum(Value)as Value FROM(SELECT`index`,Date(`to`)AS`td`FROM`fp`WHERE`aprvd`=1 ORDER BY `to`DESC LIMIT 13)AS T1 LEFT JOIN statvalues ON T1.td=statvalues.Date where StatID in (SELECT StatID from Statdescr Where GroupID=:fsid) group by td';
//  	    FPTmpDataset.ParamByName('fsid').AsInteger := aStat.ID;
      end
      else begin
	      FPTmpDataset.SQL.Text := 'SELECT wed,Value FROM(SELECT`wed`FROM`wes`WHERE`OrgID`=:fOrgID ORDER BY`wed`DESC LIMIT ' + IntToStr(CurNumOfWeeks) +')AS T1 LEFT JOIN statvalues ON T1.wed=statvalues.Date WHERE StatID=:fsid';
  	    FPTmpDataset.ParamByName('fOrgID').AsInteger := aStat.OrgID;
  	    FPTmpDataset.ParamByName('fsid').AsInteger   := aStat.ID;
      end;
      // Parsing data from DB
      try
        FPTmpDataset.Open;
      except
        on E: EZSQLException do begin
    	    //ShowError(Self, rsFailedToGetStatValues, e.ErrorCode, e.StatusCode, e.Message);
          Exit;
        end;
      end;

      //ShowMessage('NodeData.ID=' + IntToStr(NodeData.ID));
      SetLength(aStat.Values, 0);
      i := 0;
      while not FPTmpDataset.EOF do begin
        SetLength(aStat.Values, i + 1);
        with aStat.Values[i] do begin
          Value := FPTmpDataset.FieldByName('Value').AsFloat;
          Date  := FPTmpDataset.FieldByName('wed').AsDateTime;
        end;
        Inc(i);
        FPTmpDataset.Next;
      end;
    end
    else begin  // time range is set up insteaed of Number of Weeks

    end;
  end;
end;

procedure TMainStatForm.OpenStatByNode(Node: PVirtualNode);
var
  NodeData  : PStat;
  i         : integer;
  NewPadWin : TSmallWin;
  TmpNode   : PVirtualNode;
begin
  NodeData := StatsList.GetNodeData(Node);
  if (NodeData = nil) or ((NodeData.kind <> SVK_STAT) and ((NodeData.kind = SVK_GROUP) and (NodeData.flags <> 1))) then Exit;
  NewPadWin := nil;
  if not NodeData.ValuesLoaded then begin      // The values not loaded : initialize it!
  	LoadValues(NodeData);
  end;
  if (NodeData.flags = 1) and (Length(NodeData.Values) = 0) then begin
    MessageBox(0, PWideChar(rsDataNotFound), PWideChar(rsFailedToLoadStat), MB_OK or MB_ICONERROR);
    Exit;
  end;

  if not NodeData.Shown then begin      // The values not shown : initialize it!
    NewPadWin := TSmallWin.Create(ScrollBox);
    NewPadWin.Visible := false;
    NewPadWin.Parent := ScrollBox;

    // new version
    NewPadWin.Title := NodeData.ShortDescription;
    NewPadWin.ID    := NodeData.ID;
    NewPadWin.OrgID := NodeData.OrgID;
    NewPadWin.bIsFP := NodeData.flags = STF_FP;
    NewPadWin.StatType := NodeData.kind;

    // pull name and post for current stat
    if NodeData.UserName = '' then begin
		  with FPMainDataset do begin
				SQL.Text := 'SELECT tbl2.*,postsdir.Abbr FROM postsdir JOIN';
				SQL.Text := SQL.Text + '(SELECT PostID,userid,FName,MName,FamilyName FROM psts JOIN(SELECT pstsid,userid,FirstName AS FName,MiddleName AS MName,FamilyName FROM pstsfills JOIN ';
				SQL.Text := SQL.Text + 'users USING(UserID)WHERE users.UserID=:fuid and(Now()>=startdate)AND((Now()<enddate)or(enddate is NULL)))AS tbl1 ON tbl1.pstsid=psts.id)AS tbl2 ON tbl2.PostID=postsdir.ID';
	  		ParamByName('fuid').AsInteger := NodeData.UserID;
		  	Open;

        if not FPMainDataset.Eof then begin
    			NodeData.PostName := FieldByName('Abbr').AsString;
    			NodeData.UserName := GetShortFIO(FieldByName('FamilyName').AsString, FieldByName('FName').AsString, FieldByName('MName').AsString);
        end;
		  end;
    end;
    // pull name and post for current stat - end of

    NewPadWin.mInverted := NodeData.UpsideDown;
    NewPadWin.Caption   := NodeData.ShortDescription + '. ' + NodeData.PostName + '. ' + NodeData.UserName;
    NewPadWin.MinYAuto  := NodeData.MinYAuto;
    NewPadWin.MaxYAuto  := NodeData.MaxYAuto;
    NewPadWin.MinYValue := NodeData.MinYValue;
    NewPadWin.MaxYValue := NodeData.MaxYValue;
    NewPadWin.Priv      := NodeData.saux;  // keep privileges for first stat only.


    NodeData.Shown := true;
    NodeData.ValuesLoaded := true;
    NewPadWin.MainStatGrid := Addr(StatsList);
    StatsList.RepaintNode(TmpNode);
  end
  else begin  // The stat is shown. We have to find it and bring to front
    for i := 0 to ScrollBox.ControlCount - 1 do begin
      if (ScrollBox.Controls[i] is TSmallWin) then begin
        if TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID then begin
          NewPadWin := TSmallWin(ScrollBox.Controls[i]);
          break;
        end;
      end;
    end;
  end;

  if (NodeData.SecondGraph <> 0) and (NewPadWin <> nil) then begin
    TmpNode := GetStatNodeByID(NodeData.SecondGraph, NodeData.kind);
    if TmpNode <> nil then begin
      NodeData              := StatsList.GetNodeData(TmpNode);
      if not NodeData.ValuesLoaded then begin
        LoadVAlues(NodeData);
      end;
      NewPadWin.TwoGraphs   := true;
      NewPadWin.Title2      := NodeData.ShortDescription;
      NewPadWin.MinYAuto2   := NodeData.MinYAuto;
      NewPadWin.MaxYAuto2   := NodeData.MaxYAuto;
      NewPadWin.MinYValue2  := NodeData.MinYValue;
      NewPadWin.MaxYValue2  := NodeData.MaxYValue;
      NewPadWin.ID2         := NodeData.ID;
      NewPadWin.mInverted2  := NodeData.UpsideDown;
    end;
  end;

  if NewPadWin <> nil then begin
    PostMessage(NewPadWin.Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(NodeData.Values)), 0);
    NewPadWin.Width  := 400;
    NewPadWin.Height := 400;
    NewPadWin.Top    := NewStatWinY;
    NewPadWin.Left   := NewStatWinX;

    NewStatWinY      := (NewStatWinY + NewStatWinShiftY) mod (ScrollBox.Height - NewPadWin.Height);
    NewStatWinX      := (NewStatWinX + NewStatWinShiftX) mod (ScrollBox.Width  - NewPadWin.Width);

    NewPadWin.Visible	:= true;
    NewPadWin.BringToFront;
  end;
end;

procedure TMainStatForm.StatsListDblClick(Sender: TObject);
var
  CurNode   : PVirtualNode;
begin

  CurNode := StatsList.GetFirstSelected;
  if(CurNode <> nil) and (StatShowMode) then begin
    OpenStatByNode(CurNode);
  end;

end;

procedure TMainStatForm.StatsListDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  NodeData : PStat;
  PNode    : PVirtualNode;
begin
  Allowed := false;
  if Node = nil then Exit;
  SOrgID := 0;
  SSubID := 0;

  NodeData := Sender.GetNodeData(Node);
  if NodeData.kind = SVK_STAT then begin
    Allowed := true;
    PNode := Node.Parent;
    if PNode <> nil then begin
      NodeData := Sender.GetNodeData(PNode);
      if NodeData.kind = SVK_GROUP then begin
        SSubID := NodeData.ID;
        PNode := PNode.Parent;
      end;
      if PNode <> nil then begin
        NodeData := Sender.GetNodeData(PNode);
        SOrgID := NodeData.ID;
      end;
    end;
  end;
end;

procedure TMainStatForm.StatsListDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
                Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  NodeToMove  : PVirtualNode;
  NewGroup    : integer;
begin
  if Source is TVirtualStringTree then begin
    NodeToMove := TVirtualStringTree(Sender).GetFirstSelected;
////    if Sender.DropTargetNode = nil then
////      NewGroup := 0
////    else
////      NewGroup := PStat((Sender as TVirtualStringTree).GetNodeData(Sender.DropTargetNode)).ID;
      // updating DB
    if ShowWithPosts = 1 then
//      FPMainDataset.SQL.Text := 'UPDATE statdescr SET PostID=' + IntToStr(NewGroup) + ' WHERE StatID=' +
      FPMainDataset.SQL.Text := 'UPDATE statdescr SET PostID=' + IntToStr(DSubID) + ' WHERE StatID=' +
                              IntToStr(PStat((Sender as TVirtualStringTree).GetNodeData(NodeToMove)).ID)
    else
//      FPMainDataset.SQL.Text := 'UPDATE statdescr SET GroupID=' + IntToStr(NewGroup) + ' WHERE StatID=' +
      FPMainDataset.SQL.Text := 'UPDATE statdescr SET GroupID=' + IntToStr(DSubID) + ' WHERE StatID=' +
                              IntToStr(PStat((Sender as TVirtualStringTree).GetNodeData(NodeToMove)).ID);
    FPMainDataset.ExecSQL;

    TVirtualStringTree(Sender).MoveTo(NodeToMove, Sender.DropTargetNode, amAddChildLast, False);
    TVirtualStringTree(Sender).SortTree(0, sdAscending, false);
    TVirtualStringTree(Sender).Refresh;
  end;
end;

procedure TMainStatForm.StatsListDragOver(Sender: TBaseVirtualTree; Source: TObject;  Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  ParentID    : integer;
  ParentNode  : PVirtualNode;
  Data        : PStat;
  OData       : PStat;

begin
  Accept := false;
  ParentNode := TVirtualStringTree(Source).GetFirstSelected.Parent;
  if TComponent(Source).Name = 'StatsList' then begin
    DSubID := 0;
    if PStat(TVirtualStringTree(Source).GetNodeData(TVirtualStringTree(Source).GetFirstSelected)).kind = SVK_STAT then begin // only stat nodes can be moved
      ParentNode := Sender.DropTargetNode;
      if ParentNode <> nil then begin
        Data := Sender.GetNodeData(ParentNode);
        if Data.kind = SVK_GROUP then begin
          if Data.ID <> SSubID then begin // if it's a different group then we have to check if it's the same org
            ParentNode := ParentNode.Parent;
            if ParentNode <> nil then begin
              OData := Sender.GetNodeData(ParentNode);
              Accept := OData.ID = SOrgID; // we can move stat only within the same org
              if Accept then DSubID := Data.ID; // we remember the new grop/post for the stat
            end;
          end;
        end
        else if Data.kind = SVK_ORG then begin
          Accept := (Data.ID = SOrgID) and (SSubID <> 0); // we can move stat only within the same org
        end;
      end;
    end; // if ... = SVK_GROUP
  end;
end;

procedure TMainStatForm.StatsListEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  Node1 : PVirtualNode;
  Data1 : PStat;
begin
  FIsEditing := false;
  Sender.InvalidateNode(Node);
  case FLastKey of
    VK_UP : begin
      Node1 := Sender.GetPreviousSibling(Node);
      if Node1 <> nil then begin
        Sender.Selected[Node1] := true;
        Sender.FocusedNode     := Node1;
      end;
    end; // VK_UP
    VK_RETURN, VK_DOWN : begin
      //Node1 := Sender.GetNextSibling(Node);
      Node1 := Sender.GetNextVisible(Node);
      if Node1 <> nil then begin
        Data1 := Sender.GetNodeData(Node1);
        while (Node1 <> nil) and (Data1.kind <> SVK_STAT) do begin
          Node1 := Sender.GetNextVisible(Node1);
          if Node1 <> nil then Data1 := Sender.GetNodeData(Node1);
        end;
        if Node1 <> nil then begin
          Sender.Selected[Node1] := true;
          Sender.FocusedNode     := Node1;
        end;
      end;
    end; // VK_RETURN
    VK_LEFT : begin
      if Node <> nil then begin
        Sender.Selected[Node] := true;
        Sender.FocusedNode    := Node;
        Sender.FocusedColumn  := TVirtualStringTree(Sender).Header.Columns.GetPreviousVisibleColumn(Column, true);
      end;
    end;
    VK_RIGHT, VK_TAB : begin
      if Node <> nil then begin
        Sender.Selected[Node] := true;
        Sender.FocusedNode    := Node;
        Sender.FocusedColumn  := TVirtualStringTree(Sender).Header.Columns.GetNextVisibleColumn(Column, true);
      end;
    end; // VK_LEFT
  end; // CASE
  if Sender.Visible then
    Sender.SetFocus;
end;

procedure TMainStatForm.StatsListEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  Data : PStat;
  Date : TDate;
  Priv : string;
begin
  Data := Sender.GetNodeData(Node);
  Date := GetDateFromCol(Node, Column);
  Priv := Data.saux;
  Allowed := PrivPresentMO(Priv, 'bw') and (Column > 0) and (Data.kind = SVK_STAT) and (Date > 0);
end;

procedure TMainStatForm.StatsListEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  SecondStatID : integer;
  CurNode : PVirtualNode;
  NodeData : PStat;
  S, T : TObject;
begin

  S := Sender;
  T := Target;
  if T = nil then
    Exit;
  if TComponent(T).Name = 'Chart' then begin
      T := TWinControl(T).Parent;
  end
  else
    Exit;

  CurNode := StatsList.GetFirstSelected;
  NodeData := StatsList.GetNodeData(CurNode);
  if not NodeData.ValuesLoaded then begin
    LoadValues(NodeData);
  end;

  TSmallWin(T).Title2     := NodeData.ShortDescription;
  TSmallWin(T).ID2        := NodeData.ID;
  TSmallWin(T).MinYAuto2  := NodeData.MinYAuto;
  TSmallWin(T).MaxYAuto2  := NodeData.MaxYAuto;
  TSmallWin(T).MinYValue2 := NodeData.MinYValue;
  TSmallWin(T).MaxYValue2 := NodeData.MaxYValue;
  TSmallWin(T).mInverted2 := NodeData.UpsideDown;

  CurNode := GetStatNodeByID(TSmallWin(T).ID, TSmallWin(T).StatType);
  if CurNode <> nil then begin
    NodeData := StatsList.GetNodeData(CurNode);
    NodeData.SecondGraph := TSmallWin(T).ID2;
  end;

// new version
  PostMessage(TSmallWin(T).Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(NodeData.Values)), 0);
  FPMainDataset.SQL.Text := 'UPDATE statdescr SET SecondStatID=' + IntToStr(TSmallWin(T).ID2) + ' WHERE StatID=' + IntToStr(TSmallWin(T).ID);
  FPMainDataset.ExecSQL;
end;

procedure TMainStatForm.StatsListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  NodeData : PStat;
  StatName : string;
  CellDate : TDateTime;
  i        : integer;
{$IFDEF MONTHLY}
  Year, Month, Day : word;
{$ENDIF}
//  PDates   : POrgDates;
begin
  CellText := '';
  NodeData := StatsList.GetNodeData(Node);
  StatName := NodeData.ShortDescription;
  if Column = 0 then
    CellText := StatName
  else begin
    if NodeData.kind = SVK_ORG then begin // we show the date here
      CellDate := GetDateFromCol(Node, Column);
      if(CellDate > 0) then
{$IFDEF MONTHLY}
        //CellText := DateToStr(CellDate);
        DecodeDate(CellDate, Year, Month, Day);
        CellText := MonthNameShort[Month] + ' ' + IntToStr(Year mod 2000);
{$ELSE}
        CellText := DateToStr(CellDate);
{$ENDIF}
    end
    else if NodeData.kind = SVK_GROUP then begin // we don't need any values so far for visualisation
      CellText := '';
    end
    else if NodeData.kind = SVK_STAT then begin
      CellDate := GetDateFromCol(Node, Column);

      if CellDate > 0 then begin
        for i := Low(NodeData.Values) to High(NodeData.Values) do
          if NodeData.Values[i].Date = CellDate then begin
            CellText := FloatToStr(NodeData.Values[i].Value);
            break;
          end;
      end;
    end;
  end;
end;

procedure TMainStatForm.StatsListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CurDate   : TDateTime;
  ArrValues : PAStatValue;
  j,i       : integer;
  t,q,w     : integer;
  NodeData  : PStat;
  s, NewText: string;
  s1        : string;
  Column    : integer;
  ij        : integer;
  NewVal    : double;
  Changes   : boolean;
begin
  SeledNode := TVirtualStringTree(Sender).GetFirstSelected;
  if Key = VK_INSERT then begin
    if (SeledNode <> nil) and (Shift = [ssShift])  then begin
      if StatShowMode then Key := 0;
      if (SeledNode <> nil) and (PStat(TVirtualStringTree(Sender).GetNodeData(SeledNode)).kind = SVK_STAT) and (not StatShowMode) then begin // table on the main screen?
        Column := TVirtualStringTree(Sender).FocusedColumn;
        NodeData := TVirtualStringTree(Sender).GetNodeData(SeledNode);
        Changes := false;

        s := Clipboard.AsText;
        while s <> '' do begin
          NewText := '';
          i := Pos(CRLF, s);
          if(0 < i) then begin
            NewText := LeftStr(s, i - 1);
            s := MidStr(s, i + 2, Length(s));
          end
          else begin
            NewText := s;
            s  := '';
          end;
(*==========================*)
        //  Date1 := StrToDate(TVirtualStringTree(Sender).Header.Columns[Column].Text);
          Date1 := GetDateFromCol(SeledNode, Column);
          Inc(Column);
          ij    := Length(NodeData.Values);
          i     := ij;
          s1    := '';
          for i := 1 to Length(NewText) do begin
            if 0 < Pos(NewText[i], AllowedChars) then s1 := s1 + NewText[i];
          end;

          NewText := s1;
          if TryStrToFloat(NewText, NewVal) then begin
            Changes := true;
            if Length(NodeData.Values) > 0 then begin
              for I := Low(NodeData.Values) to High(NodeData.Values) do begin
                if TDate(NodeData.Values[i].Date) = Date1 then begin
                  NodeData.Values[i].Value := NewVal;
                  StatValueToDB(FPMainDataset, NodeData.ID, Date1, NodeData.Values[i].Value);
                  break;
                end; // if
              end // for
            end;
            if (ij = 0) or (ij > High(NodeData.Values)) then begin
              SetLength(NodeData.Values, ij + 1);
              NodeData.Values[ij].Value := NewVal;
              NodeData.Values[ij].Date  := Date1;
              StatValueToDB(FPMainDataset, NodeData.ID, Date1, NodeData.Values[ij].Value);
            end; // if ij=0
          end
            //ShowMessage(s1);
(*==========================*)
        end;
        // Update Stat
        if Changes then begin
          for i := 0 to ScrollBox.ControlCount - 1 do begin
            if (ScrollBox.Controls[i] is TSmallWin) and ((TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID) or (TSmallWin(ScrollBox.Controls[i]).ID2 = NodeData.ID)) then
              PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(NodeData.Values)), Integer(Addr(Date1)));
          end;
        end;
      end;
    end;
  end
  else if Key = VK_RIGHT then begin
    if (SeledNode <> nil) and (Shift = [ssShift])  then begin
      if StatShowMode then Key := 0;
      if PStat(TVirtualStringTree(Sender).GetNodeData(SeledNode)).kind <> SVK_STAT then begin
        if (not TVirtualStringTree(Sender).Expanded[SeledNode]) then begin
          TVirtualStringTree(Sender).Expanded[SeledNode] := true;
          Key := 0;
        end;
      end;
    end;
  end
  else if Key = VK_LEFT then begin
     if (SeledNode <> nil) and (Shift = [ssShift]) then begin
      if StatShowMode then Key := 0;
      if PStat(TVirtualStringTree(Sender).GetNodeData(SeledNode)).kind <> SVK_STAT then begin
        if TVirtualStringTree(Sender).Expanded[SeledNode] then begin
          TVirtualStringTree(Sender).Expanded[SeledNode] := false;
        end;
      end;
    end;
  end
  else if Key = VK_RETURN then begin
     if SeledNode <> nil then begin
      if StatShowMode then Key := 0;
      i := PStat(TVirtualStringTree(Sender).GetNodeData(SeledNode)).kind;
      j := integer(PStat(TVirtualStringTree(Sender).GetNodeData(SeledNode)).flags = STF_FP);
      if (i = SVK_STAT) or (j = STF_FP) then begin
        OpenStatByNode(SeledNode);
      end;
    end;
  end
  else if Key = VK_DELETE then begin
//    if (SeledNode <> nil) and (not StatShowMode) and (PStat(TVirtualStringTree(Sender).GetNodeData(SeledNode)).kind <> 1) then begin
    if (SeledNode <> nil) and (not StatShowMode) and (PStat(TVirtualStringTree(Sender).GetNodeData(SeledNode)).kind = 0) then begin
//      CurDate := StrToDate(TVirtualStringTree(Sender).Header.Columns[TVirtualStringTree(Sender).FocusedColumn].Text);
			CurDate := GetDateFromCol(SeledNode, TVirtualStringTree(Sender).FocusedColumn);

      NodeData := TVirtualStringTree(Sender).GetNodeData(SeledNode);
      if CurDate > 0 then begin
        t := Low(NodeData.Values);
        q := High(NodeData.Values);
        for i := t to q do
          if NodeData.Values[i].Date = CurDate then break;
        for j := i to q - 1 do begin
          NodeData.Values[j].Date  := NodeData.Values[j + 1].Date;
          NodeData.Values[j].Value := NodeData.Values[j + 1].Value;
        end;
        if i <= q then begin
          SetLength(NodeData.Values, Length(NodeData.Values)-1);
          DeleteStatValueFromDB(FPMainDataset, NodeData.ID, CurDate);
          TVirtualStringTree(Sender).RepaintNode(SeledNode);
            // searching for the open graph to update it
          for I := 0 to ScrollBox.ControlCount - 1 do begin
            if (ScrollBox.Controls[i] is TSmallWin) and ((TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID) or (TSmallWin(ScrollBox.Controls[i]).ID2 = NodeData.ID)) then
              PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(NodeData.Values)), 0);
          end;
        end;
      end;
    end;
  end; // VK_DELETE
  inherited;
end;

procedure TMainStatForm.StatsListKeyPress(Sender: TObject; var Key: Char);
var
  TmpNode : PVirtualNode;
begin
  if Pos(key, AllowedChars) = 0 then begin
    inherited;
    Exit;
  end;

  TmpNode := TVirtualStringTree(Sender).GetFirstSelected;
  if PStat(TVirtualStringTree(Sender).GetNodeData(TmpNode)).kind <> SVK_STAT then Exit;

  FIsEditing := true;
  FFirstChar := Key;
  TVirtualStringTree(Sender).EditNode(TmpNode, TVirtualStringTree(Sender).FocusedColumn);
end;

procedure TMainStatForm.StatsListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SeledNode := StatsList.GetNodeAt(X, Y);
end;

procedure TMainStatForm.StatsListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  if StatsList.GetNodeAt(X, Y) = nil then begin
    StatsList.ClearSelection;
    StatsList.FocusedNode := nil;
  end
end;

procedure TMainStatForm.StatsListNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  NodeData : PStat;
  i, ij : integer;
begin
  NodeData := Sender.GetNodeData(Node);

//  Date1 := StrToDate(TVirtualStringTree(Sender).Header.Columns[Column].Text);
  Date1 := GetDateFromCol(Node, Column);
  ij    := Length(NodeData.Values);
  i     := ij;
  if Length(NodeData.Values) > 0 then begin
    for I := Low(NodeData.Values) to High(NodeData.Values) do begin
      if TDate(NodeData.Values[i].Date) = Date1 then begin
        NodeData.Values[i].Value := StrToFloat(NewText);
        StatValueToDB(FPMainDataset, NodeData.ID, Date1, NodeData.Values[i].Value);
        break;
      end; // if
    end // for
  end;
  if (ij = 0) or (ij > High(NodeData.Values)) then begin
    SetLength(NodeData.Values, ij + 1);
    NodeData.Values[ij].Value := StrToFloat(NewText);
    NodeData.Values[ij].Date  := Date1;
    StatValueToDB(FPMainDataset, NodeData.ID, Date1, NodeData.Values[ij].Value);
  end; // if ij=0
  for i := 0 to ScrollBox.ControlCount - 1 do begin
    if (ScrollBox.Controls[i] is TSmallWin) and ((TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID) or (TSmallWin(ScrollBox.Controls[i]).ID2 = NodeData.ID)) then
			PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(NodeData.Values)), Integer(Addr(Date1)));
  end;
end;

procedure TMainStatForm.StatsListPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  NodeData : PStat;
begin
  NodeData := StatsList.GetNodeData(Node);
  if NodeData.kind = SVK_ORG then begin
    TargetCanvas.Font.Style := [fsBold];
  end
  else if NodeData.kind = SVK_GROUP then begin
    TargetCanvas.Font.Style := [fsBold];
    TargetCanvas.Font.Color := clBlue;
  end
  else if NodeData.kind = SVK_STAT then begin
    TargetCanvas.Font.Color := clBlack;
    if NodeData.Shown then begin
      TargetCanvas.Font.Style := [fsBold];
    end;
  end
end;

procedure TMainStatForm.SwitchFPStats(aVisible : boolean);
var
  ONode : PVirtualNode;
  SNode : PVirtualNode;
  OData : PStat;
  SData : PStat;
begin
  ONode := StatsList.GetFirstChild(nil);
  while ONode <> nil do begin
    OData := StatsList.GetNodeData(ONode);
    if OData.kind = SVK_ORG then begin
      SNode := StatsList.GetFirstChild(ONode);
      while SNode <> nil do begin
        SData := StatsList.GetNodeData(SNode);
        if (SData.kind = SVK_GROUP) and (SData.flags = STF_FP) then begin
          StatsList.IsVisible[SNode] := aVisible;
        end;
        SNode := StatsList.GetNextSibling(SNode);
      end;
    end
    else begin
      OData := StatsList.GetNodeData(ONode);
      if (OData.kind = SVK_GROUP) and (OData.flags = STF_FP) then begin
        StatsList.IsVisible[ONode] := aVisible;
      end;
    end;
    ONode := StatsList.GetNextSibling(ONode);
  end;
end;

procedure TMainStatForm.SwitchStatHeader(aHeaderVisible : boolean);
var
  i : integer;
begin
  if aHeaderVisible then begin
    for i := 0 to CurNumOfWeeks - 1 do begin
      StatsList.Header.Columns.Add;
      StatsList.Header.Columns[i + 1].Width := 100;
      StatsList.Header.Columns[i + 1].Alignment := taRightJustify;
    end;
    StatsList.Header.Options := StatsList.Header.Options - [hoAutoResize];
  end
  else begin
    while StatsList.Header.Columns.Count > 1 do begin
      StatsList.Header.Columns.Delete(StatsList.Header.Columns.Count - 1);
    end;
    StatsList.FocusedColumn := 0;
    StatsList.Header.Options := StatsList.Header.Options + [hoAutoResize];
  end;
end;

procedure TMainStatForm.LoadAllStats;
var
	ONode : PVirtualNode;
  GNode : PVirtualNode;
  SNode : PVirtualNode;
  SData : PStat;
  i     : integer;
begin
  ONode := StatsList.GetFirstChild(nil);
  while ONode <> nil do begin
	  GNode := StatsList.GetFirstChild(ONode);
  	while GNode <> nil do begin
    	if PStat(StatsList.GetNodeData(GNode)).kind = SVK_GROUP then begin
	      SNode := StatsList.GetFirstChild(GNode)
  	  end
    	else begin
      	SNode := GNode;
	    end;
	    while SNode <> nil do begin
  	    SData := StatsList.GetNodeData(SNode);
        if not SData.ValuesLoaded then begin
	        SData.ValuesLoaded := true;
          LoadValues(sData);
        end;

	      for i := 0 to ScrollBox.ControlCount - 1 do begin
  	      if (ScrollBox.Controls[i] is TSmallWin) then
    	      if TSmallWin(ScrollBox.Controls[i]).ID = SData.ID then
      	      PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_NUMOFWEEKSCHANGED, 0, 0);
	      end; // for i:=0...
  	    SNode := StatsList.GetNextSibling(SNode);
    	end; // while CurNode <> nil

	    if PStat(StatsList.GetNodeData(GNode)).kind = SVK_GROUP then begin
  	    GNode := GNode.NextSibling
    	end
	    else if SNode <> nil then begin
  	    GNode := SNode.NextSibling
    	end
	    else begin
  	    GNode := nil;
    	end;
	  end; // while Node <> nil do begin
  	ONode := ONode.NextSibling;
  end;  // while ONode <> nil
end;

procedure TMainStatForm.SwitchViewBtnClick(Sender: TObject);
var
  i : integer;
begin
  SwitchFPStats(not StatShowMode);
  SwitchStatHeader(StatShowMode);

  if StatShowMode then begin // switching to TABLE mode
    SwitchViewBtn.ImageIndex := 0;
    SwitchViewBtn.Hint := rsHntShowGraphs;
    StatsList.TreeOptions.SelectionOptions := StatsList.TreeOptions.SelectionOptions - [toFullRowSelect];
    TileGraphsBtn.Enabled := false;
    ScrollBox.Width := 10;
    StatsList.Width := Self.Width;
//    StatsList.Header.Options := StatsList.Header.Options + [hoVisible];
    StatsList.ScrollBarOptions.ScrollBars := ssBoth;
    StatsList.Header.Columns[0].Width := StatListWidth;
    Splitter1.Visible := false;
    LoadAllStats;
  end
  else begin
    StatsList.TreeOptions.SelectionOptions := StatsList.TreeOptions.SelectionOptions + [toFullRowSelect];
    SwitchViewBtn.ImageIndex := 1;
    SwitchViewBtn.Hint := rsHntValuesShow;
    TileGraphsBtn.Enabled := true;
    StatsList.Width := StatListWidth;
    StatsList.Header.Columns[0].Width := StatsList.ClientWidth - 5;
    i := StatsList.FocusedColumn;
    while i > 0 do begin
      StatsList.FocusedColumn := StatsList.Header.Columns.GetPreviousVisibleColumn(i, true);
      i := StatsList.FocusedColumn;
    end;
//    StatsList.Header.Options := StatsList.Header.Options - [hoVisible];
    StatsList.ScrollBarOptions.ScrollBars := ssVertical;
    Splitter1.Visible := true;
  end;
  StatShowMode := not StatShowMode;
  StartDateEdit.Enabled := StatShowMode;
  EndDateEdit.Enabled   := StartDateEdit.Enabled;
  btnCTPRefresh.Enabled   := StartDateEdit.Enabled;

  if StatsList.Visible then
    StatsList.SetFocus;
end;

function TMainStatForm.GetValuesFromDatabase(Dataset : TZQuery; StatID : integer; DatesList : array of TDateTime; var Vals : TList): boolean;
Var
  i : integer;
  Year, Month, Day : Word;
  Date1, Date2 : string;
  StatValue : PStatValue;
begin

//!  DecodeDate(DatesList[Low(Dates)], Year, Month, Day);
//!  Date1 := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
//!  DecodeDate(DatesList[High(Dates)], Year, Month, Day);
//!  Date2 := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

// flushing the values list
//!  for i := 0 to Vals.Count - 1 do begin
//!    StatValue := Vals[i];
//!    Dispose(StatValue);
//!  end;
//!  Vals.Clear;

//!  for i := Low(Dates) to High(Dates) do begin
//!    New(StatValue);
//!    StatValue.Value := Random (100);
//!    StatValue.Date  := DatesList[Low(Dates)];
//!    Vals.Add(StatValue);
//!  End;

  Result := true;
end;

procedure TMainStatForm.GroupStatCreateClick(Sender: TObject);
var
  StatGroupForm: TStatGroupForm;
  NodeData  : PStat;
  NewNode   : PVirtualNode;
  CurOID    : integer;
begin
  StatGroupForm := TStatGroupForm.Create(nil);
  StatGroupForm.FullDescrMemo.Text  := '';
  StatGroupForm.DescrEdit.Text      := '';

  StatGroupForm.OKButton.Enabled := false;
  FillComboWithOrgs(TComboBox(StatGroupForm.OrgCombo), CurOID, SUserID);

  StatGroupForm.ShowModal;
  if StatGroupForm.ModalResult <> mrOK then begin
    StatGroupForm.Free;
    Exit;
  end;

  if StatGroupForm.ModalResult = mrOK then begin
    CurOID := integer(StatGroupForm.OrgCombo.Items.Objects[StatGroupForm.OrgCombo.ItemIndex]);

    FPMainDataset.SQL.Text := 'INSERT INTO statgroups(Description,OrgID,FullDescription)VALUES(:fDescr,:fOrgID,:fFullDescr)';
    FPMainDataset.ParamByName('fOrgID').AsInteger     := CurOID;
    FPMainDataset.ParamByName('fDescr').AsString      := StatGroupForm.DescrEdit.Text;
    FPMainDataset.ParamByName('fFullDescr').AsString  := StatGroupForm.FullDescrMemo.Text;
    FPMainDataset.ExecSQL;
  end;

  StatGroupForm.Free;
  // Updating the StatsList
  FPMainDataset.Close;
  FPMainDataset.SQL.Text :=  'SELECT * FROM statgroups WHERE OrgID=' + IntToStr(CurOID) + ' ORDER BY ID DESC LIMIT 1';
  FPMainDataset.Open;

  if not FPMainDataset.Eof then begin
    NewNode  := StatsList.InsertNode(GetOrgNodeByID(CurOID), amAddChildLast);
    NodeData := StatsList.GetNodeData(NewNode);
    NodeData.ShortDescription := FPMainDataset.FieldByName('Description').AsString;
    NodeData.kind := SVK_GROUP;
    NodeData.ID   := FPMainDataset.FieldByName('ID').AsInteger;
    NodeData.FullDescription := FPMainDataset.FieldByName('FullDescription').AsString;
    StatsList.SortTree(0, sdAscending, false);
  end;
  FPMainDataset.ExecSQL;
end;

procedure TMainStatForm.GroupStatDelClick(Sender: TObject);
var
  GroupID   : integer;
  NodeData  : PStat;
  Node      : PVirtualNode;
  OldSDescr : string;
  OldFDescr : string;
begin
  Node := SeledNode;
  if Node = nil then Exit;
  if IDOK <> MessageBox(Self.Handle, PWideChar(rsSureToDeleteGroup + CRLF + rsStatsAndDataToSave), PWideChar(rsConfirmDelete), MB_OKCANCEL or MB_ICONEXCLAMATION ) then
  	Exit;

  // correcting the tree
  GroupID := PStat(StatsList.GetNodeData(Node)).ID;
  StatsList.MoveTo(Node, nil, amAddChildLast, true);
  //StatsList.DeleteNode(Node, True);
  StatsList.DeleteNode(Node); // 111
  StatsList.SortTree(0, sdAscending, false);
  // updating DB
  // Ungrouping stats
  FPMainDataset.SQL.Text := 'UPDATE statdescr SET GroupID=0 WHERE GroupID=' + IntToStr(GroupID);
  FPMainDataset.ExecSQL;
  // removing the group itself
  FPMainDataset.SQL.Text := 'DELETE FROM statgroups WHERE ID=' + IntToStr(GroupID);
  FPMainDataset.ExecSQL;
end;

procedure TMainStatForm.GroupStatPropClick(Sender: TObject);
var
  StatGroupForm: TStatGroupForm;
  NodeData   : PStat;
  Node       : PVirtualNode;
  OldSDescr  : string;
  OldFDescr  : string;
  OrgNodeData   : PStat;
  OrgNode       : PVirtualNode;

begin
  Node := StatsList.GetFirstSelected;
  Node := SeledNode;
  if Node = nil then Exit;

  OrgNode := Node.Parent;
  if OrgNode = nil then Exit;

  NodeData := StatsList.GetNodeData(Node);
  OrgNodeData := StatsList.GetNodeData(OrgNode);
  OldSDescr := NodeData.ShortDescription;
  OldFDescr := NodeData.FullDescription;

  StatGroupForm := TStatGroupForm.Create(nil);

  StatGroupForm.DescrEdit.Text      := OldSDescr;
  StatGroupForm.FullDescrMemo.Text  := OldFDescr;

  StatGroupForm.OKButton.Enabled := true;
  FillComboWithOrgs(TComboBox(StatGroupForm.OrgCombo), OrgNodeData.ID, SUserID);
  StatGroupForm.OrgCombo.Enabled := false;

  StatGroupForm.ShowModal;

  if (StatGroupForm.ModalResult = mrOK) and (not ((StatGroupForm.FullDescrMemo.Text = OldFDescr) and (StatGroupForm.DescrEdit.Text = OldSDescr))) then begin
    FPMainDataset.SQL.Text := 'UPDATE statgroups SET Description=:fDescription,FullDescription=:fFullDescription WHERE ID=' + IntToStr(NodeData.ID);
    FPMainDataset.ParamByName('fDescription').AsString      := StatGroupForm.DescrEdit.Text;
    FPMainDataset.ParamByName('fFullDescription').AsString  := StatGroupForm.FullDescrMemo.Text;
    FPMainDataset.ExecSQL;
    NodeData.ShortDescription := StatGroupForm.DescrEdit.Text;
    NodeData.FullDescription  := StatGroupForm.FullDescrMemo.Text;
    StatsList.RepaintNode(Node);
  end;
  StatGroupForm.Free;
end;

procedure TMainStatForm.DelBtnMenuItemClick(Sender: TObject);
var
  Node     : PVirtualNode;
  NodeData : PStat;
  i        : integer;
begin
  if Application.MessageBox(PWideChar(rsSureToDeleteStat + CRLF + rsAllDataToDelete), PWideChar(rsConfirmDelete), MB_OKCANCEL) = IDOK then begin
    Node := SeledNode;
    NodeData := StatsList.GetNodeData(Node);
    // Deleteing data from DB
    FPMainDataset.SQL.Text := 'DELETE FROM statvalues WHERE StatID=' + IntToStr(NodeData.ID);
    FPMainDataset.ExecSQL;
    FPMainDataset.SQL.Text := 'DELETE FROM statdescr WHERE StatID=' + IntToStr(NodeData.ID);
    FPMainDataset.ExecSQL;
    // removing graph from the scrollBox if it's there
    for I := 0 to ScrollBox.ControlCount - 1 do begin
        if (ScrollBox.Controls[i] is TSmallWin) then
          if TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID then begin
            TSmallWin(ScrollBox.Controls[i]).Free;
            break;
          end;
     end;
    StatsList.DeleteNode(Node);
  end;
end;

procedure TMainStatForm.StatAddBtnClick(Sender: TObject);
begin
  AddStatClick(Sender);
end;

procedure TMainStatForm.PrintBtnClick(Sender: TObject);
var
  i : integer;
  Chart : TChart;
  Series1 : TLineSeries;
begin
  for I := 0 to ScrollBox.ControlCount - 1 do begin
    if (ScrollBox.Controls[i] is TSmallWin) then begin
      Chart := TChart.Create(nil);
      Series1 := TLineSeries.Create(nil);
      Chart.Assign(TSmallWin(ScrollBox.Controls[i]).Chart);
      Chart.Visible := true;
      Chart.Parent := TWinControl(ScrollBox.Controls[i]);
      Chart.BringToFront;
      Printer.Title := '';
      Chart.Height := 1000;
      Chart.Width := Round(Chart.Height * 0.7);
      Chart.LeftAxis.Assign(TSmallWin(ScrollBox.Controls[i]).Chart.LeftAxis);
      Chart.Axes.Bottom.Assign(TSmallWin(ScrollBox.Controls[i]).Chart.BottomAxis);
      Series1.Assign(TSmallWin(ScrollBox.Controls[i]).Chart.Series[0]);
      Chart.AddSeries(Series1);
      Chart.Axes.Left.TicksInner.Visible := false;
      Chart.Axes.Left.MinorTicks.Visible := false;
      Chart.Axes.Left.Grid.Visible := false;
      Chart.LeftAxis.Axis.Width := 1;
      Chart.Axes.Left.Ticks.Width := 1;
      Chart.Axes.Left.TickLength := 1;
      Chart.Axes.Bottom.TicksInner.Visible := false;
      Chart.Axes.Bottom.MinorTicks.Visible := false;
      Chart.Axes.Bottom.Grid.Visible := true;
      Chart.Axes.Bottom.Grid.Width := 1;
      Chart.Axes.Bottom.Ticks.Width := 1;
      Chart.Axes.Bottom.TickLength := 1;
      Chart.BottomAxis.Axis.Width := 1;
      Chart.Title.Font.Size := 6;
      Chart.Title.Visible := true;
      Chart.Title.Caption := '';
      Chart.PrintMargins := Rect(Point(0,0), Point(0,0));
      Chart.BottomAxis.LabelsFont.Size := Round((Printer.PageHeight / 842) * 120);
      Chart.BottomAxis.LabelsFont.Style :=  [fsUnderline];
      Chart.Axes.Bottom.LabelsFont.Style := [fsUnderline];
      Chart.Axes.left.LabelsFont.Size := Round((Printer.PageHeight / 842) * 12);
      Chart.PrintPortrait;
      Chart.Free;
      break;
    end;
  end;
end;

procedure TMainStatForm.RTimerTimer(Sender: TObject);
begin
  CheckAndReconnect(FPConnection);
end;

procedure TMainStatForm.btnCTPRefreshClick(Sender: TObject);
var
  StartDate     : TDate;
  StartThursday : TDate;
  EndDate       : TDate;
  EndThursday   : TDate;
  CurDate       : TDate;

  PDates        : POrgDates;

  i, j             : integer;
  NodeData         : PStat;
  CurNode          : PVirtualNode;
  Node             : PVirtualNode;
  ONode            : PVirtualNode;
  Date1, Date2     : string;
  Year, Month, Day : Word;
{$IFDEF MONTHLY}
  YearEnd, MonthEnd, DayEnd : Word;
{$ENDIF}

begin
  StartDate := StartDateEdit.Date;
  EndDate   := EndDateEdit.Date;
  if (StartDate < 0.1) and (EndDate < 0.1) then begin
    Application.MessageBox(PWideChar(rsErrAtLeastOneDataNeeded), PWideChar(rsErrInput), MB_ICONERROR or MB_OK);
    Exit;
  end;

  if (EndDate > 0.1) and (StartDate >= EndDate) then begin
    Application.MessageBox(PWideChar(rsErrStartIsToBeLess), PWideChar(rsErrInput), MB_ICONERROR or MB_OK);
    Exit;
  end;

  CurNumOfWeeks := NumOfWeeks[WeeksCombo.ItemIndex];

  if StartDate < 0.1 then begin // if the StartDateEdit is empty
    if IsAWEDay(EndDate) then
      EndThursday := EndDate
    else
      EndThursday := GetPrevWEDay(EndDate);
{$IFDEF MONTHLY}
    StartThursday := EndThursday;
    for i := 1 to CurNumOfWeeks do
      StartThursday := GetPrevWEDay(StartThursday);
{$ELSE}
    StartThursday := EndThursday - CurNumOfWeeks * 7;
{$ENDIF}
  end
  else if EndDate < 0.1 then begin
    if IsAWEDay(StartDate) then
      StartThursday := StartDate
    else
      StartThursday := GetNextWEDay(StartDate);
{$IFDEF MONTHLY}
    EndThursday := StartThursday;
    Date1 := DateToStr(StartThursday);
    Date2 := DateToStr(EndThursday);
    for i := 2 to CurNumOfWeeks do begin
      EndThursday := GetNextWEDay(EndThursday + 1);
      Date2 := DateToStr(EndThursday);
    end;
{$ELSE}
    EndThursday   := StartThursday + CurNumOfWeeks * 7;
{$ENDIF}
  end
  else begin
    if IsAWEDay(StartDate) then begin
      StartThursday := StartDate
    end
    else begin
      StartThursday := GetNextWEDay(StartDate);
    end;

    if IsAWEDay(EndDate) then begin
      EndThursday := EndDate
    end
    else begin
      EndThursday := GetPrevWEDay(EndDate);
    end;

    if (EndThursday < StartThursday) then begin
      Application.MessageBox(PWideChar(rsDatesRangeErrorMessageTooShortPeriodMonthly), PWideChar(rsDatesRangeError), MB_OK or MB_ICONERROR);
      Exit;
    end;

{$IFDEF MONTHLY}
    DecodeDate(StartThursday, Year, Month, Day);
    DecodeDate(EndThursday, YearEnd, MonthEnd, DayEnd);
    i := MonthEnd + 12 * (YearEnd - Year) - Month + 1;
    //if (Year = 1900) and (Month < 12) then begin
    if (i <= 12) then begin
      Application.MessageBox(PWideChar(rsDatesRangeErrorMessageTooShortPeriodMonthly), PWideChar(rsDatesRangeError), MB_OK or MB_ICONERROR);
      Exit;
    end;
    CurNumOfWeeks := i; //(Year - 1900) * 12 + Month;
{$ELSE}
    CurNumOfWeeks := Round(EndThursday - StartThursday) div 7 + 1;
    if (CurNumOfWeeks) <= 6 then begin
      Application.MessageBox(PWideChar(rsDatesRangeErrorMessageTooShortPeriodWeekly), PWideChar(rsDatesRangeError), MB_OK or MB_ICONERROR);
      Exit;
    end

{$ENDIF}
  end;

  StartDate := StartThursday;
  EndDate   := EndThursday;

  Date1 := DateToStr(StartThursday);
  Date2 := DateToStr(EndThursday);

  // pulling data from DB
  CurDate := EndThursday;
  SetLength(Dates, CurNumOfWeeks);
  Dates[Low(Dates)] := CurDate;
  for i := Low(Dates) + 1 to High(Dates) do begin
    //Dates[i] := EndDate - i * 7;
    CurDate := GetPrevWEDay(CurDate -1 );
    Dates[i] := CurDate;
  end;
//  for i := Low(Dates) to High(Dates) do begin
//    Dates[i] := EndDate - i * 7;
//  end;

  for i := 0 to Length(arrOrgPfxs) - 1 do begin
  	if arrOrgs[i] then begin
    	PDates := arrOrgDates[i];
      if PDates <> nil then begin
        SetLength(PDates.FPDates,   0);
        SetLength(PDates.StatDates, 0);
      end
      else begin
	    	New(PDates);
				arrOrgDates[i] := PDates;
      end;

      for j := Low(Dates) to High(Dates) do begin
        SetLength(PDates.StatDates, j + 1);
        PDates.StatDates[j] := Dates[j];// := EndDate - i * 7;
      end;

    end;
  end;

//          SetLength(PDates.FPDates, j + 1);
//        	PDates.FPDates[j] := int(FPTmpDataset.FieldByName('to').AsDateTime);


(*
  for I := 1 to StatsList.Header.Columns.Count - 1 do begin
    StatsList.Header.Columns[1].Free;
  end;

// Adjusting the amount of columns
  for i := Low(Dates) to High(Dates) do begin
    StatsList.Header.Columns.Add;
    StatsList.Header.Columns[i + 1].Text      :=  DayToStr(Dates[CurNumOfWeeks - i - 1]);
    StatsList.Header.Columns[i + 1].Width     := 60;
    StatsList.Header.Columns[i + 1].Alignment := taRightJustify;
  end;
*)

  ONode := StatsList.GetFirstChild(nil);
  while ONode <> nil do begin

    Node := StatsList.GetFirstChild(ONode);
    while Node <> nil do begin
      if PStat(StatsList.GetNodeData(Node)).kind = SVK_GROUP then begin
        CurNode := StatsList.GetFirstChild(Node)
      end
      else begin
        CurNode := Node;
      end;

      while CurNode <> nil do begin
        NodeData := StatsList.GetNodeData(CurNode);
        SetLength(NodeData.Values, 0);

        DecodeDate(Dates[Low(Dates)], Year, Month, Day);
        Date1 := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

        DecodeDate(Dates[High(Dates)], Year, Month, Day);
        Date2 := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

        FPTmpDataset.SQL.Text := 'SELECT date,value FROM statvalues WHERE StatID=' + IntToStr(NodeData.ID) + ' AND DATE>="' + Date2 + '"AND DATE<="' + Date1 + '"ORDER BY Date ASC';
      // Parsing data from DB
        try
          FPTmpDataset.Open;
        except
          on E: EZSQLException do begin
  	        //ShowError(Self, rsFailedToGetStatValues, e.ErrorCode, e.StatusCode, e.Message); // 111
            Exit;
          end;
        end;

        i := 0;
        while not FPTmpDataset.EOF do begin
          SetLength(NodeData.Values, i + 1);
          With NodeData.Values[i] do begin
            Value := FPTmpDataset.FieldByName('Value').AsFloat;
            Date  := FPTmpDataset.FieldByName('Date').AsDateTime;
          end;
          Inc(i);
          FPTmpDataset.Next;
        End;

        for I := 0 to ScrollBox.ControlCount - 1 do begin
          if (ScrollBox.Controls[i] is TSmallWin) then
            if TSmallWin(ScrollBox.Controls[i]).ID = NodeData.ID then
              PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_NUMOFWEEKSCHANGED, Integer(Addr(NodeData.Values)), Integer(Addr(Date1)));
        end;
        CurNode := StatsList.GetNextSibling(CurNode);
      end; // while CurNode <> nil do begin

      if PStat(StatsList.GetNodeData(Node)).kind = SVK_GROUP then
        Node := Node.NextSibling //MainListNode;
      else if CurNode <> nil then
        Node := CurNode.NextSibling
      else
        Node := nil;
    end; // while Node <> nil do begin
    ONode := ONode.NextSibling;
  end; // while ONode <> nil
end;

procedure TMainStatForm.SetUpNumOfWeeks;
var
	i, j : integer;
  PDates            : POrgDates;
begin
  CurNumOfWeeks := NumOfWeeks[WeeksCombo.ItemIndex];

  for i := 0 to Length(arrOrgPfxs) - 1 do begin
  	if arrOrgs[i] then begin
    	PDates := arrOrgDates[i];
      if PDates <> nil then begin
        SetLength(PDates.FPDates,   0);
        SetLength(PDates.StatDates, 0);
      end
      else begin
	    	New(PDates);
				arrOrgDates[i] := PDates;
      end;

      // pull FP dates
		  FPTmpDataset.SQL.Text := 'SELECT DATE(`to`)AS`to`FROM`' + arrOrgPfxs[i] + 'fp`WHERE aprvd=1 ORDER BY`to`DESC LIMIT ' + IntToStr(CurNumOfWeeks);// + ')as T1';
      try
	      FPTmpDataset.Open;
        j := 0;
        while not FPTmpDataset.Eof do begin
          SetLength(PDates.FPDates, j + 1);
        	PDates.FPDates[j] := int(FPTmpDataset.FieldByName('to').AsDateTime);
          Inc(j);
          FPTmpDataset.Next;
        end;
      except
        on E: EZSQLException do begin
     	    //ShowError(Self, rsFailedToLoadFPDates, e.ErrorCode, e.StatusCode, e.Message); // 111
          Exit;
        end;
      end;
		  //FP part - end of

      // pull normal stats WEs
      // pull FP dates
		  FPTmpDataset.SQL.Text := 'SELECT`wed`FROM`wes`WHERE OrgID=:forgid ORDER BY`wed`DESC LIMIT ' + IntToStr(CurNumOfWeeks);
      FPTmpDataset.ParamByName('forgid').AsInteger := i;
      try
	      FPTmpDataset.Open;
        j := 0;
        while not FPTmpDataset.Eof do begin
          SetLength(PDates.StatDates, j + 1);
        	PDates.StatDates[j] := int(FPTmpDataset.FieldByName('wed').AsDateTime);
          Inc(j);
          FPTmpDataset.Next;
        end;
      except
        on E: EZSQLException do begin
     	    // ShowError(Self, rsFailedToLoadStatDates, e.ErrorCode, e.StatusCode, e.Message); // 111
          Exit;
        end;
      end;
    end;
  end;

	PostMessage(Handle, CM_DATE_RANGE_CHANGED, 0, 0);
end;

procedure TMainStatForm.OnDateRangeChanged(var Msg: TMessage);
var
	ONode : PVirtualNode;
  GNode : PVirtualNode;
  SNode : PVirtualNode;
  SData : PStat;
  i     : integer;
begin
  ONode := StatsList.GetFirstChild(nil);
  while ONode <> nil do begin
	  GNode := StatsList.GetFirstChild(ONode);
  	while GNode <> nil do begin
    	if PStat(StatsList.GetNodeData(GNode)).kind = SVK_GROUP then begin
	      SNode := StatsList.GetFirstChild(GNode)
  	  end
    	else begin
      	SNode := GNode;
	    end;
	    while SNode <> nil do begin
  	    SData := StatsList.GetNodeData(SNode);
        if SData.ValuesLoaded then begin
	        SData.ValuesLoaded := false; // flush the loaded flag
          LoadValues(sData);
        end;

	      for i := 0 to ScrollBox.ControlCount - 1 do begin
  	      if (ScrollBox.Controls[i] is TSmallWin) then
    	      if TSmallWin(ScrollBox.Controls[i]).ID = SData.ID then
      	      PostMessage(TSmallWin(ScrollBox.Controls[i]).Handle, CM_NUMOFWEEKSCHANGED, 0, 0);
	      end; // for i:=0...
  	    SNode := StatsList.GetNextSibling(SNode);
    	end; // while CurNode <> nil

	    if PStat(StatsList.GetNodeData(GNode)).kind = SVK_GROUP then begin
  	    GNode := GNode.NextSibling
    	end
	    else if SNode <> nil then begin
  	    GNode := SNode.NextSibling
    	end
	    else begin
  	    GNode := nil;
    	end;
	  end; // while Node <> nil do begin
  	ONode := ONode.NextSibling;
  end;  // while ONode <> nil
end;

procedure TMainStatForm.btnRefreshWeeksClick(Sender: TObject);
begin
	SetUpNumOfWeeks;
end;

procedure TMainStatForm.FillComboWithOrgs(AList : TComboBox; ACurOrgID : integer; AUserID : integer);
var
  i  : integer;
  j  : integer;
  ci : integer;
begin
  AList.Items.Clear;
  ci := 0;

  FPMainDataset.SQL.Text := 'SELECT Abbr,ID FROM orgs LEFT JOIN uos ON orgs.ID=uos.OrgID WHERE uos.UserID=:fuid ORDER BY ID';
  FPMainDataset.ParamByName('fuid').AsInteger	:= AUserID;

  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    i := AList.Items.Add(FPMainDataset.FieldByName('Abbr').AsString);
    AList.Items.Objects[i] := TObject(FPMainDataset.FieldByName('ID').AsInteger);
    if integer(AList.Items.Objects[i]) = ACurOrgID then ci := i;
    FPMainDataset.Next;
  end;

  AList.Enabled := AList.Items.Count > 1;
  if AList.Items.Count > 0 then
    AList.ItemIndex := ci;

end;


procedure TMainStatForm.btnAboutClick(Sender: TObject);
var
  AboutForm : TAboutBox;
begin
  AboutForm := TAboutBox.Create(nil);
  AboutForm.ShowModal;
  AboutForm.Free;
end;

procedure TMainStatForm.acCloseAllWindowsExecute(Sender: TObject);
var
  i : integer;
begin
  // rebuild da Gaph if needed
    for I := 0 to ScrollBox.ControlCount - 1 do begin
      TForm(ScrollBox.Controls[i]).Close;
    end;
end;

procedure TMainStatForm.AddStatClick(Sender: TObject);
var
  NewStatForm : TNewStatForm;
  NewNode     : PVirtualNode;
  NodeToAddTo : PVirtualNode;
  NodeData    : PStat;
  NewStatID   : integer;
  CurOID      : integer;
  CurGroupID  : integer;
  CUsrID      : integer;
  i           : integer;
begin

  FPMainDataset.SQL.Text := 'SELECT Max(StatID)as MaxStatID FROM statdescr';
  FPMainDataset.Open;
  if FPMainDataset.RecordCount > 0 then begin
//    FPMainDataset.First;
    NewStatID := FPMainDataset.FieldByName('MaxStatID').AsInteger + 1;
  end
  else begin
    NewStatID := 1;
  end;

  NodeToAddTo := nil;
  NewNode := StatsList.GetFirstSelected;
  if(NewNode <> nil) then begin
    NodeData := StatsList.GetNodeData(NewNode);
    if NodeData.kind = 1 then begin // i.e. the node is a group
    	NodeToAddTo := NewNode;
      CurGroupID  := NodeData.ID;
    end
    else begin
      CurGroupID  := 0;
    end;
  end;

  NewStatForm := TNewStatForm.Create(nil);
  NewStatForm.Position := poOwnerFormCenter;
  NewStatForm.ShortStatNameEdit.Text := '';
  NewStatForm.FullStatNameMemo.Text := '';
  NewStatForm.MinAutoCheckBox.Checked := true;
  NewStatForm.MaxAutoCheckBox.Checked := true;
  NewStatForm.MinYEdit.Text := '0';
  NewStatForm.MaxYEdit.Text := '0';
  NewStatForm.ButtonOK.Enabled := false;
  // fill up orgs combo to know where to add new stat
  //FillComboWithOrgs(TComboBox(NewStatForm.OrgCombo), 0, SUserID);
  FillComboWithOrgs(TComboBox(NewStatForm.OrgCombo), NodeData.OrgID, SUserID);

  if NewStatForm.ShowModal = mrOK then begin
    CurOID := integer(NewStatForm.OrgCombo.Items.Objects[NewStatForm.OrgCombo.ItemIndex]);
    CUsrID := NewStatForm.CurUserID;
    // Dumping to the DB
    FPMainDataset.SQL.Text :=
      'INSERT INTO statdescr(OrgID,StatID,GroupID,Description,ShortName,MinYAuto,MaxYAuto,MinYValue,MaxYValue,UserID)VALUES(:oid,:sid,:gid,:fd,:sd,:minya,:maxya,:minyv,:maxyv,:fuid)';
    FPMainDataset.ParamByName('oid').AsInteger    := CurOID;
    FPMainDataset.ParamByName('sid').AsInteger    := NewStatID;
    FPMainDataset.ParamByName('gid').AsInteger    := CurGroupID;
    FPMainDataset.ParamByName('fd').AsString      := Trim(NewStatForm.FullStatNameMemo.Text);
    FPMainDataset.ParamByName('sd').AsString      := Trim(NewStatForm.ShortStatNameEdit.Text);
    FPMainDataset.ParamByName('minya').AsInteger  := integer(NewStatForm.MinAutoCheckBox.Checked);
    FPMainDataset.ParamByName('maxya').AsInteger  := integer(NewStatForm.MaxAutoCheckBox.Checked);
    FPMainDataset.ParamByName('minyv').AsFloat    := StrToFloat(NewStatForm.MinYEdit.Text);
    FPMainDataset.ParamByName('maxyv').AsFloat    := StrToFloat(NewStatForm.MaxYEdit.Text);
    FPMainDataset.ParamByName('fuid').AsInteger   := CUsrID;
    FPMainDataset.ExecSQL;

    if NodeToAddTo = nil then
    	NodeToAddTo := GetOrgNodeByID(CurOID);

    NewNode := StatsList.InsertNode(NodeToAddTo, amAddChildLast);
    NodeData := StatsList.GetNodeData(NewNode);

    NodeData.ID               := NewStatID;
    NodeData.ShortDescription := NewStatForm.ShortStatNameEdit.Text;
    NodeData.FullDescription  := NewStatForm.FullStatNameMemo.Text;
    NodeData.MinYAuto         := NewStatForm.MinAutoCheckBox.Checked;
    NodeData.MaxYAuto         := NewStatForm.MaxAutoCheckBox.Checked;
    NodeData.MinYValue        := StrToFloat(NewStatForm.MinYEdit.Text);
    NodeData.MaxYValue        := StrToFloat(NewStatForm.MaxYEdit.Text);
    NodeData.UserID           := CUsrID;
    NodeData.OrgID            := CurOID;
    NodeData.Shown            := false;

    StatsList.ReinitNode(NewNode, false);

  end;
  NewStatForm.Free;
end;

procedure TMainStatForm.Button1Click(Sender: TObject);
var
  i : integer;
  Chart : TChart;
  Series1 : TLineSeries;
begin
  for I := 0 to ScrollBox.ControlCount - 1 do begin
    if (ScrollBox.Controls[i] is TSmallWin) then begin
      Chart := TChart.Create(nil);
      Series1 := TLineSeries.Create(nil);
      Chart.Assign(TSmallWin(ScrollBox.Controls[i]).Chart);
      Chart.Visible := true;
      Chart.Parent := TWinControl(ScrollBox.Controls[i]);
      Chart.BringToFront;
      Chart.Height := TWinControl(ScrollBox.Controls[i]).ClientHeight;
      Chart.LeftAxis.Assign(TSmallWin(ScrollBox.Controls[i]).Chart.LeftAxis);
      Chart.Axes.Bottom.Assign(TSmallWin(ScrollBox.Controls[i]).Chart.BottomAxis);
      Series1.Assign(TSmallWin(ScrollBox.Controls[i]).Chart.Series[0]);
      Chart.AddSeries(Series1);
      Chart.Axes.Left.TicksInner.Visible := false;
      Chart.Axes.Left.MinorTicks.Visible := false;
      Chart.Axes.Left.Grid.Visible := false;
      Chart.LeftAxis.Axis.Width := 1;
      Chart.Axes.Left.Ticks.Width := 1;
      Chart.Axes.Left.TickLength := 1;
      Chart.Axes.Bottom.TicksInner.Visible := false;
      Chart.Axes.Bottom.MinorTicks.Visible := false;
      Chart.Axes.Bottom.Grid.Visible := true;
      Chart.Axes.Bottom.Ticks.Width := 1;
      Chart.Axes.Bottom.TickLength := 1;
      Chart.BottomAxis.Axis.Width := 1;
      Chart.Title.Font.Size := 6;
      Chart.Title.Visible := true;
      Chart.PrintMargins := Rect(Point(0,0),Point(0,0));
      Chart.BottomAxis.LabelsFont.Size := 4;
      Chart.Axes.Bottom.LabelsFont.Style := [fsUnderline];
      Chart.Axes.left.LabelsFont.Size := 4;
      Chart.LeftAxis.LabelsFont.Size := 4;
      Chart.Width := Round(Chart.Height * 0.7);
      Chart.PrintPortrait;
      Chart.Free;
      break;
    end;
  end;
end;

procedure TMainStatForm.ChangeViewModeBtnClick(Sender: TObject);
begin
  if ShowWithPosts = ShowKindComboBox.ItemIndex then
    Exit
  else begin
    ShowWithPosts := ShowKindComboBox.ItemIndex;
    ClearStatsList;
    InitStatsList;
  end;
end;

procedure TMainStatForm.ChildWinCloseMsg(var Msg: TMessage);
begin
	UnshowStat(Msg.WParam, Msg.LParam);
end;

procedure TMainStatForm.UnShowStat(AID, AType : integer);
var
  NodeData    : PStat;
  TmpNode     : PVirtualNode;
  TmpNode1    : PVirtualNode;
begin
  TmpNode := GetStatNodeByID(AID, AType);
  if TmpNode = nil then Exit;

  NodeData := StatsList.GetNodeData(TmpNode);
  NodeData.Shown := false;
  StatsList.RepaintNode(TmpNode);
end;

function TMainStatForm.GetStatValue(StName: string; Dt : string) : string;
var
  NewPadWin : TSmallWin;
  i   : integer;
  ij : integer;
  Val : extended;
begin
  NewPadWin := nil;

  for I := 0 to ScrollBox.ControlCount - 1 do begin
    if (ScrollBox.Controls[i] is TSmallWin) then
      if TSmallWin(ScrollBox.Controls[i]).Caption = StName then begin
        NewPadWin := TSmallWin(ScrollBox.Controls[i]);
        break;
      end;
  end;

  if NewPadWin <> nil then begin
    for ij := 0 to NewPadWin.Chart.SeriesList[0].Count-1 do
      if NewPadWin.Chart.SeriesList[0].XLabel[ij] = Dt then begin
        Val := NewPadWin.Chart.SeriesList[0].YValue[ij];
        NewPadWin.Chart.Update;
        break;
      end;
    if ij > NewPadWin.Chart.SeriesList[0].Count-1 then
      Result := ''
    else
      Result := FloatToStr(Val);
  end
  else
    Result := '';
end;

procedure TVTCustomEditor.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  C     : Char;
  TmpLen : integer;
begin
  case Key of
    VK_LEFT, VK_TAB, VK_RIGHT, VK_UP, VK_RETURN, VK_DOWN : begin
      FLastKey := Key;
      Key := 0;
      if FTree.Parent <> nil then
        PostMessage(FTree.Parent.Handle, UM_VST_END_EDIT, 0, 0);
    end;
    VK_BACK: begin
      TmpLen := Length(FEdit.Text);
      if TmpLen > 0 then begin
        C := FEdit.Text[TmpLen];
        if C = FormatSettings.DecimalSeparator then
          FDecSepAlreadyPresent := false;
        if (C = '-') or (Length(FEdit.Text) = 1) then
          FSignAlreadyPresent := false;
        FEdit.Text := LeftStr(FEdit.Text, Length(FEdit.Text) -1);
        FEdit.SelStart  := Length(FEdit.Text);
      end;
    end; // VK_BACK
    VK_ESCAPE : begin
      FTree.CancelEditNode;
      //FTree.SetFocus; /// 111
      Key := 0;
      ///Exit;
      inherited;
    end; // VK_ESCAPE
  else
    inherited;
  end; // Case
end;

procedure TVTCustomEditor.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Pos(Key, AllowedChars) <= 0 then Key := #0;
  case Key of
    '-' : begin
      if FSignAlreadyPresent then begin
        Key := #0;
      end
      else FSignAlreadyPresent := true;
    end; // '-'
    '.', ',' : begin
      if FDecSepAlreadyPresent then begin
        Key := #0;
      end
      else begin
        FSignAlreadyPresent := true;
        FDecSepAlreadyPresent := true;
        Key := FormatSettings.DecimalSeparator;
      end; // if FDecSepAlreadyPresent
    end; // '.', ','
  end; // case Key of
end;

procedure TVTCustomEditor.CMDialogKey(var Msg: TWMKEY);
var
  Key : Word;
begin
  if (Msg.Charcode = VK_TAB) then begin
    Key := Msg.CharCode;
    EditKeyDown(Self, Key, []);
  end;
  inherited;
end;

destructor TVTCustomEditor.Destroy;
begin
  FreeAndNil(FEdit);
  if FTree.Parent <> nil then
    PostMessage(FTree.Parent.Handle, UM_VST_END_EDIT, 0, 0);
  inherited;
end;

function TVTCustomEditor.BeginEdit: Boolean;
begin
  Result := True;
  with FEdit do begin
    AutoSelect := false;
    if FFirstChar <> #0 then
      Text := FFirstChar;
    FDecSepAlreadyPresent := false;
    FSignAlreadyPresent := true;
    case FFirstChar of
      '.', ',' : begin
        FDecSepAlreadyPresent := true;
        FSignAlreadyPresent := true;
        Text := FormatSettings.DecimalSeparator;
      end; // '.', ','
    end; // case Text
    if FFirstChar <> #0 then
      SelStart  := 1
    else
      SelStart := Length(Text);
    Show;
    if FEdit.Visible then
      FEdit.SetFocus;
  end;
end;

function TVTCustomEditor.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
end;

function TVTCustomEditor.EndEdit: Boolean;
var
  Txt   : String;
  value : extended;
begin
  Result := True;
  Txt := FEdit.Text;
  // Изменяем текст узла (поле Value у TVTEditNode) через событие OnNewText у дерева
  try
    Result := TryStrtoFloat(FEdit.Text, Value);
  except
    on E: EConvertError do
      Result := False;
  end;
  if Result then begin
    FTree.Text[FNode, FColumn] := Txt;
    FEdit.Hide;
  end;
end;

function TVTCustomEditor.GetBounds: TRect;
begin
  Result := Ftree.GetDisplayRect(FNode, 1, FALSE, True, FALSE);
  Result.Left   := Result.Left   + 10;
  Result.Top    := Result.Top    + 10;
  Result.Bottom := Result.Bottom + 10;
  Result.Right  := Result.Right  + 10;
end;

function TVTCustomEditor.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  ComboStyle  : integer;
  Pt          : TRect;
  Point1, Point2 : TPoint;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FreeAndNil(FEdit);
  FEdit := TEdit.Create(nil);
  Pt := Ftree.GetDisplayRect(FNode, Column, FALSE);
  Point1 := pt.TopLeft;
  Point2 := pt.BottomRight;

  FEdit.Color := TColor($AAAAFF);
  with FEdit do begin
    Top       := Point1.Y - 2;
    Left      := Point1.X - 2;
    Width     := Ftree.Header.Columns[Column].Width + 3;
    Alignment := taRightJustify;

    Margins.Left   := 5;
    Margins.Right  := 0;
    Margins.Top    := 0;
    Margins.Bottom := 0;

    AlignWithMargins := true;
    Visible          := False;
    Parent           := FTree;
    Text             := FTree.Text[FNode, FColumn];

    Font.Style  := Font.Style + [fsBold];
    //OnKeyDown   := EditKeyDown;
    //OnKeyPress  := EditKeyPress;
    OnKeyDown   := nil;
    OnKeyUp   := EditKeyDown;

  end;
  SetWindowRgn(FEdit.Handle, CreateRectRgn(2, 2, FEdit.Width - 2, FEdit.Height - 2), True);
end;

procedure TVTCustomEditor.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TVTCustomEditor.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, Dummy);
end;

procedure TMainStatForm.OnVSTEndEdit(var Msg: TMessage);
begin
  StatsList.EndEditNode;
  StatsList.SetFocus;
end;

procedure TMainStatForm.ClearStatsList;
var
  SmallWindowFound  : boolean;
  i                 : integer;
begin
  SmallWindowFound := true;
  while (ScrollBox.ControlCount > 0) and SmallWindowFound do begin
    SmallWindowFound := false;
    for I := 0 to ScrollBox.ControlCount - 1 do begin
      if (ScrollBox.Controls[i] is TSmallWin) then begin
        TSmallWin(ScrollBox.Controls[i]).Free;
        SmallWindowFound := true;
        break;
      end;
    end;
  end;
  StatsList.Clear;
end;

procedure TMainStatForm.InitStatsList;
var
  NewOrgNode  : PVirtualNode;
  NodeOrgData : PStat;
  NewGPNode  : PVirtualNode;
  NodeGPData : PStat;
  NewSNode  : PVirtualNode;
  NodeSData : PStat;
  Year, Month, Day : Word;
  Date1, Date2 : string;
  COID         : integer;
  OrgsList     : string;
	scp : string;
  bAddAnyway : boolean;
  GroupID : integer;
  CurGroupID : integer;
  js: TlkJSONobject;
  ws: TlkJSONstring;
  s : string;
  we : integer;
  bMnuDeled : boolean;

begin
  // 106
  OrgsList := '';
  // pulling orgs from DB
  // new version, security awared

  bMnuDeled := false;

  try
	  bAddAnyway := false;

	  FPMainDataset.SQL.Text := 'SELECT Abbr,ID,prefix,sp,cs FROM orgs LEFT JOIN uos ON orgs.ID=uos.OrgID WHERE uos.UserID=:fuid ORDER BY ID';
		FPMainDataset.ParamByName('fuid').AsInteger	:= SUserID;

    FPMainDataset.Open;
	  while not FPMainDataset.EOF do begin
      COID := FPMainDataset.FieldByName('ID').AsInteger;
      scp  := FPMainDataset.FieldByName('sp').AsString;

(*
      s := '';
      js := TlkJSON.ParseText(FPMainDataset.FieldByName('cs').AsString) as TlkJSONobject;
      if(js <> nil) then begin
        // stats period setting
        ws := js.Field['statsperiod'] as TlkJSONstring;
        if(ws <> nil) then begin
          gStatsWeekly := ws.Value <> 'monthly';
        end;

        // end of the week day
        ws := js.Field['we'] as TlkJSONstring;
        if(ws <> nil) then
          s := ws.Value;
      end;

      if gStatsWeekly then begin
        if s = '' then begin
          we := 4;
        end
        else begin
          we := StrToInt(s);
        end;
      end;
*)
      s := '';
      if gStatsWeekly then begin
        js := TlkJSON.ParseText(FPMainDataset.FieldByName('cs').AsString) as TlkJSONobject;
        if(js <> nil) then begin
          // end of the week day
          ws := js.Field['we'] as TlkJSONstring;
          if(ws <> nil) then
            s := ws.Value;
        end;

        if s = '' then begin
          we := 4;
        end
        else begin
          we := StrToInt(s);
        end;
      end;

      if Length(arrOrgPfxs) < COID + 1 then SetLength(arrOrgPfxs, COID + 1);
      if Length(arrOrgs)    < COID + 1 then SetLength(arrOrgs,    COID + 1);
      if Length(arrOrgsWEs) < COID + 1 then SetLength(arrOrgsWEs, COID + 1);
			arrOrgPfxs[COID] := FPMainDataset.FieldByName('Prefix').AsString;
      arrOrgs[COID]    := true;
      arrOrgsWEs[COID] := we;
      InitWEs(COID, we);

      if (scp <> 'b') and not bMnuDeled then begin // remove the Setup menu item
        mm.Items.Remove(miSettings);
        bMnuDeled := true;
      end;

      if (scp = 'b') or (scp = 'a') then begin
		  	bAddAnyway := true;
        (*
    		FPTmpDataset.SQL.Text := 'SELECT statgroups.Description as GroupName,statgroups.isfp,UserID,T1.* FROM(';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT * FROM`statdescr`WHERE GroupID>0 AND OrgID=:foid ORDER BY OrgID,GroupID)';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + ' UNION ';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT * FROM`statdescr`WHERE GroupID=0 AND OrgID=:foid ORDER BY OrgID,GroupID)) AS T1 ';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'LEFT JOIN statgroups ON T1.GroupID=statgroups.ID';
        *)
(*
    		FPTmpDataset.SQL.Text := '(SELECT statgroups.Description as GroupName,statgroups.isfp,UserID,T1.* FROM(';
        FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'SELECT * FROM`statdescr`WHERE GroupID>0 AND OrgID=:foid) AS T1 ';
        //FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'LEFT JOIN statgroups ON T1.GroupID=statgroups.ID ORDER BY OrgID,GroupID)';
        FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'LEFT JOIN statgroups ON T1.GroupID=statgroups.ID ORDER BY OrgID,GroupName)';
        FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'UNION ';
        FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT statgroups.Description as GroupName,statgroups.isfp,UserID,T1.* FROM(';
        FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'SELECT * FROM`statdescr`WHERE GroupID=0 AND OrgID=:foid) AS T1 ';
        //FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'LEFT JOIN statgroups ON T1.GroupID=statgroups.ID ORDER BY OrgID,GroupID)';
        FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'LEFT JOIN statgroups ON T1.GroupID=statgroups.ID ORDER BY OrgID,GroupName)';
*)

(*
select * from (
	(
		SELECT statgroups.Description as GroupName,statgroups.isfp,T01.* FROM
			(SELECT * FROM`statdescr`WHERE GroupID>0 AND OrgID=1) AS T01 LEFT JOIN statgroups ON T01.GroupID=statgroups.ID ORDER BY GroupName
	)
	UNION
	(
		SELECT statgroups.Description as GroupName,statgroups.isfp,T02.* FROM
			(SELECT * FROM`statdescr`WHERE GroupID=0 AND OrgID=1) AS T02 LEFT JOIN statgroups ON T02.GroupID=statgroups.ID ORDER BY GroupName
	)
) as T3 order by groupname
*)

    		FPTmpDataset.SQL.Text := 'SELECT * FROM (';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT statgroups.Description as GroupName,statgroups.isfp,T01.* FROM';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT * FROM`statdescr`WHERE GroupID>0 AND OrgID=:foid) AS T01 LEFT JOIN statgroups ON T01.GroupID=statgroups.ID'; // ORDER BY GroupName';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + ')UNION(';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'SELECT statgroups.Description as GroupName,statgroups.isfp,T02.* FROM';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT * FROM`statdescr`WHERE GroupID=0 AND OrgID=:foid) AS T02 LEFT JOIN statgroups ON T02.GroupID=statgroups.ID'; // ORDER BY GroupName';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + ')';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + ') AS T3 ORDER BY GroupName'; // ORDER BY groupname';

		  	FPTmpDataset.ParamByName('foid').AsInteger	:= COID;
      end
      else begin
    		FPTmpDataset.SQL.Text := 'SELECT statgroups.Description as GroupName,statgroups.isfp,UserID,T1.* FROM(';
//    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT statdescr.*,statprivs.cw FROM`statdescr`LEFT JOIN`statprivs`ON statdescr.StatID=statprivs.StatID WHERE statprivs.UserID=:fuid AND GroupID>0 AND statdescr.OrgID=:foid) ORDER BY OrgID,GroupID';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT statdescr.*,statprivs.cw FROM`statdescr`LEFT JOIN`statprivs`ON statdescr.StatID=statprivs.StatID WHERE statprivs.UserID=:fuid AND GroupID>0 AND statdescr.OrgID=:foid)';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + ' UNION ';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + '(SELECT statdescr.*,statprivs.cw FROM`statdescr`LEFT JOIN`statprivs`ON statdescr.StatID=statprivs.StatID WHERE statprivs.UserID=:fuid AND GroupID=0 AND statdescr.OrgID=:foid)) AS T1 ';
    		FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + 'LEFT JOIN statgroups ON T1.GroupID=statgroups.ID ORDER BY OrgID,GroupID';
		  	FPTmpDataset.ParamByName('fuid').AsInteger	:= SUserID;
		  	FPTmpDataset.ParamByName('foid').AsInteger	:= COID;
      end;

      FPTmpDataset.Open;
      if (FPTmpDataset.RecordCount > 0) or bAddAnyway then begin
      	// add the org if we have at least one stat

	      NewOrgNode  := StatsList.InsertNode(nil, amAddChildLast);
        NodeOrgData := StatsList.GetNodeData(NewOrgNode);

	      NodeOrgData.ID               := COID;
	      NodeOrgData.OrgID            := NodeOrgData.ID;
    	  NodeOrgData.ShortDescription := FPMainDataset.FieldByName('Abbr').AsString;

      	NodeOrgData.saux             := arrOrgPfxs[COID];
  	    NodeOrgData.FullDescription  := FPMainDataset.FieldByName('sp').AsString;
        NodeOrgData.SecondGraph      := we;

	      NodeOrgData.kind := SVK_ORG;
  	    SetLength(NodeOrgData.Values, 0);
    	  NodeOrgData.Shown := true;
      	NodeOrgData.ValuesLoaded := false;

        GroupID := 0;
			  while not FPTmpDataset.EOF do begin
        	CurGroupID := FPTmpDataset.FieldByName('GroupID').AsInteger;
          if (CurGroupID <> 0) and (FPTmpDataset.FieldByName('isfp').AsInteger <> STF_FP) then begin
	          if (GroupID <> CurGroupID) then begin
		        	// if we change a group, we can have to add it
  		        NewGPNode  := StatsList.InsertNode(NewOrgNode, amAddChildLast);
	    	      NodeGPData := StatsList.GetNodeData(NewGPNode);

        	    NodeGPData.ID               := FPTmpDataset.FieldByName('GroupID').AsInteger;
		          NodeGPData.OrgID            := COID;
          	  NodeGPData.FullDescription  := '';
            	NodeGPData.ShortDescription := FPTmpDataset.FieldByName('GroupName').AsString;
		          NodeGPData.kind             := SVK_GROUP;
              NodeGPData.MinYAuto         := true;
              NodeGPData.MaxYAuto         := true;
              NodeGPData.flags            := FPTmpDataset.FieldByName('isfp').AsInteger;
    		      NodeGPData.Shown            := false;
      		    NodeGPData.ValuesLoaded     := false;
  		        SetLength(NodeGPData.Values, 0);
        	  end
          end
          else begin
  	        NewGPNode  := NewOrgNode;
          end;

          // add the stat
		      NewSNode  := StatsList.InsertNode(NewGpNode, amAddChildLast);
      		NodeSData := StatsList.GetNodeData(NewSNode);
      		NodeSData.ID               := FPTmpDataset.FieldByName('StatID').AsInteger;
          NodeSData.OrgID            := COID;
      		NodeSData.UserID           := FPTmpDataset.FieldByName('UserID').AsInteger;
          NodeSData.flags            := FPTmpDataset.FieldByName('isfp').AsInteger; /// ???
      		NodeSData.FullDescription  := FPTmpDataset.FieldByName('Description').AsString;
      		NodeSData.ShortDescription := FPTmpDataset.FieldByName('ShortName').AsString;
      		NodeSData.MinYAuto         := FPTmpDataset.FieldByName('MinYAuto').AsInteger = 1;
      		NodeSData.MaxYAuto         := FPTmpDataset.FieldByName('MaxYAuto').AsInteger = 1;
      		NodeSData.MinYValue        := FPTmpDataset.FieldByName('MinYValue').AsExtended;
      		NodeSData.MaxYValue        := FPTmpDataset.FieldByName('MaxYValue').AsExtended;
      		NodeSData.SecondGraph      := FPTmpDataset.FieldByName('SecondStatID').AsInteger;
		      if (scp = 'b') or (scp = 'a') then begin
	  	      NodeSData.saux := scp;
          end
          else begin
	  	      NodeSData.saux := FPTmpDataset.FieldByName('cw').AsString;
          end;

      		NodeSData.kind := SVK_STAT;
      		SetLength(NodeSData.Values, 0);
      		NodeSData.UpsideDown := Boolean(FPTmpDataset.FieldByName('UpsideDown').AsInteger);
          // add the stat - end of

          GroupID := CurGroupID;
        	FPTmpDataset.Next;
        end;
      end;

      FPMainDataset.Next
  	end; // while FPMainDataset

  except

  end;

	SetLength(arrOrgDates, Length(arrOrgPfxs));
end;

procedure TMainStatForm.miAcccessClick(Sender: TObject);
var
  Af    : TAccessForm;
  NodeO : PVirtualNode;
  NodeN : PVirtualNode;
  DataO : PStat;
  DataN : PStat;
begin
  Af := TAccessForm.Create(nil);
  NodeO := StatsList.GetFirstChild(nil);

  while NodeO <> nil do begin
    DataO := StatsList.GetNodeData(NodeO);
    NodeN := Af.vstOrgs.AddChild(nil);
    DataN := Af.vstOrgs.GetNodeData(NodeN);
    DataN.ID               := DataO.ID;
    DataN.ShortDescription := DataO.ShortDescription;
    DataN.FullDescription  := DataO.FullDescription;
    DataN.saux             := DataO.saux;
    if Length(Af.OrgPrivs) <= DataN.ID then SetLength(Af.OrgPrivs, DataN.ID + 1);
    Af.OrgPrivs[DataN.ID] := DataN.FullDescription;
    NodeO := StatsList.GetNextSibling(NodeO);
  end;
  af.ShowModal;
  af.Destroy;
end;

procedure TMainStatForm.miExitClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TMainStatForm.miGeneralClick(Sender: TObject);
var
  wef : TWEEditForm;
  NodeD : PVirtualNode;
  DataD : PStat;
  NodeO : PVirtualNode;
  DataO : POrgData;
begin
  wef := TWEEditForm.Create(nil);

  NodeD := StatsList.GetFirstChild(nil);
  while NodeD <> nil do begin
    DataD := StatsList.GetNodeData(NodeD);

    NodeO := wef.vstOrgs.AddChild(nil);
    DataO := wef.vstOrgs.GetNodeData(NodeO);

    DataO.ID := DataD.ID;
    DataO.ShortName := DataD.ShortDescription;
    DataO.swe := DataD.SecondGraph;

    NodeD := StatsList.GetNextSibling(NodeD);
  end;
  wef.ShowModal;
  wef.Destroy;
end;

procedure TMainStatForm.InitDB;
begin
    // setting up connection to DB server
  Connection := FPConnection;
  Connection := nil;

  // initializing of TZQuery instantiations
  FPMainDataset := TZQuery.Create(nil);
  FPMainDataset.Connection := FPConnection;

  FPTmpDataset := TZQuery.Create(nil);
  FPTmpDataset.Connection := FPConnection;

  with FPMainDataset do begin
    FPMainDataset.ReadOnly := False;
    //FPMainDataset.SQL.Text := 'SET CHARSET ' + rsCharsetSetUp;
    FPMainDataset.SQL.Text := 'SET CHARSET cp1251';

//  Handling error in case of the error
    try
      FPMainDataset.ExecSQL;
    except
      on E: EZSQLException do begin
  	    // ShowError(Self, rsFailedToSetupCodePage, e.ErrorCode, e.StatusCode, e.Message); // 111
        Exit;
      end;
    end;
  end;
  InitStatsList;
end;

function TMainStatForm.GetStatNodeByID(AStatID, AStatType: integer): PVirtualNode;
var
  OrgNode : PVirtualNode;
  OrgData : PStat;
  SubNode : PVirtualNode;
  SubData : PStat;
  TmpNode : PVirtualNode;
  TmpData : PStat;
  found   : boolean;
begin
  Result := nil;
  found := false;
  OrgNode := StatsList.GetFirstChild(nil);
  while (OrgNode <> nil) and (not found) do begin
    SubNode := StatsList.GetFirstChild(OrgNode);
    while (SubNode <> nil) and (not found) do begin
      SubData := StatsList.GetNodeData(SubNode);
      if SubData.kind = SVK_GROUP then begin
      	if (SubData.kind = AStatType) and (SubData.ID = AStatID) then begin
          Result := SubNode;
          found := true;
          break;
        end
        else begin
	        TmpNode := StatsList.GetFirstChild(SubNode);
  	      while (TmpNode <> nil) and (not found) do begin
    	      TmpData := StatsList.GetNodeData(TmpNode);
      	    if (TmpData.ID = AStatID) and (TmpData.kind = AStatType) then begin
        	    Result := TmpNode;
          	  found := true;
	            break;
  	        end;
    	      TmpNode := StatsList.GetNextSibling(TmpNode);
      	  end;
        end;
      end
      else if SubNode <> nil then begin
        SubData := StatsList.GetNodeData(SubNode);
        if (SubData.ID = AStatID) and (SubData.kind = AStatType) then begin
          Result := SubNode;
          found := true;
          break;
        end;
      end;
      SubNode := StatsList.GetNextSibling(SubNode);
    end; // while (SubNode <> nil)
    OrgNode := StatsList.GetNextSibling(OrgNode);
  end;
end;

procedure TMainStatForm.InitWEs(AOrgID, Awe : integer);
var
  swe    : integer;
  st     : TDate;
  lastwe : TDate;
  cwe    : TDate;
  i      : integer;
begin
  FPTmpDataset.SQL.Text := 'SELECT NOW() AS ct';
  FPTmpDataset.Open;
  if not FPTmpDAtaset.Eof then begin
    st := int(FPTmpDataset.FieldByName('ct').AsDateTime);
  end;

  FPTmpDataset.SQL.Text := 'SELECT wed,DAYOFWEEK(wed)-1 AS dow FROM wes WHERE OrgID=:forgid ORDER BY wed DESC LIMIT 1';
  FPTmpDataset.ParamByName('forgid').AsInteger := AOrgID;
  FPTmpDataset.Open;
  if not FPTmpDAtaset.Eof then begin
    lastwe := FPTmpDataset.FieldByName('wed').AsDateTime;
    swe    := FPTmpDataset.FieldByName('dow').AsInteger;
    if swe = 0 then swe := 7; // Mysql thinks that 0 is a Sunday, but we don't
  end;

  i := 0;
  if Awe = swe then begin // just add missing WEs
    if(st = GetNextWEDay(st, Awe)) then
      cwe := st
    else
      cwe := GetPrevWEDay(st, Awe);
    while (cwe > lastwe) and (i < 54) do begin
      FPTmpDataset.SQL.Text := 'INSERT INTO wes(wed,OrgID)VALUES(:fwed,:forgid)';
      FPTmpDataset.ParamByName('fwed').AsDate      := cwe;
      FPTmpDataset.ParamByName('forgid').AsInteger := AOrgID;
      FPTmpDataset.ExecSQL;
      cwe := GetPrevWEDay(cwe, Awe);
      Inc(i);
    end;
  end
  else begin              // add missing WEs considering minimal week length
    cwe := GetPrevWEDay(st, Awe);
    while (cwe > lastwe + 5) and (i < 54)  do begin
      FPTmpDataset.SQL.Text := 'INSERT INTO wes(wed,OrgID)VALUES(:fwed,:forgid) ON DUPLICATE KEY UPDATE wed=wed';
      FPTmpDataset.ParamByName('fwed').AsDate      := cwe;
      FPTmpDataset.ParamByName('forgid').AsInteger := AOrgID;
      FPTmpDataset.ExecSQL;
      cwe := GetPrevWEDay(cwe, Awe);
      Inc(i);
    end;
  end;
end;


end.
