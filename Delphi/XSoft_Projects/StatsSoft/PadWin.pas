unit PadWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  StdCtrls, // for TEdit
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, VirtualTrees, Menus,
  sSkinProvider, DKLang, VclTee.TeeGDIPlus;

type
  TVTCustomEditor1 = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TEdit;           // Базовый класс для каждого типа редактора
    FTree: TVirtualStringTree;  // Ссылка на дерево, вызвавшее редактирование
    FNode: PVirtualNode;        // Редактируемый узел
    FColumn: Integer;           // Его колонка, в которой оно происходит
    // for tracking editing value
    FDecSepAlreadyPresent : boolean;              // Sign of the value
    FSignAlreadyPresent   : boolean;              // Decimal separator
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
  TSmallWin = class(TForm)
    Chart: TChart;
    ValuesGrid: TVirtualStringTree;
    Splitter: TSplitter;
    PopupMenu1: TPopupMenu;
    Showvalues1: TMenuItem;
    Series1: TLineSeries;
    VerticalGridShowHide: TMenuItem;
    HorizontalGridShowHide: TMenuItem;
    N1: TMenuItem;
    PrintStatMenuItem: TMenuItem;
    PrintDialog: TPrintDialog;
    N2: TMenuItem;
    DelSecondGraphMenuItem: TMenuItem;
    sSkinProvider1: TsSkinProvider;
    ShowValuesOnGraph: TMenuItem;
    lc: TDKLanguageController;
    procedure FormCreate(Sender: TObject);
    procedure ChartClick(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure ValuesGridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
          Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure ValuesGridEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure ValuesGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure ValuesGridNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure ChartDblClick(Sender: TObject);
    procedure Showvalues1Click(Sender: TObject);
    procedure ValuesGridKeyPress(Sender: TObject; var Key: Char);
    procedure ValuesGridEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;  Column: TColumnIndex);
    procedure ValuesGridCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure ValuesGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure VerticalGridShowHideClick(Sender: TObject);
    procedure HorizontalGridShowHideClick(Sender: TObject);
    procedure PrintStatMenuItemClick(Sender: TObject);
    procedure ValuesGridClick(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ChartDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DelSecondGraphMenuItemClick(Sender: TObject);
    procedure ShowValuesOnGraphClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    SelectedDate  : TDate;
    procedure OnGraphRebuildNeeded(var Message: TMessage); message CM_GRAPHREBUILDNEEDED;
    procedure OnNumOfWeeksChanged(var Message: TMessage);  message CM_NUMOFWEEKSCHANGED;
    procedure OnVSTEndEdit(var Msg: TMessage);             message UM_VST_END_EDIT;
    procedure OnVSTSelectItem(var Msg: TMessage);          message UM_VST_SELECT_ITEM;

  public
    { Public declarations }
    swPost        : string;
    swName        : string;
    TwoGraphs     : Boolean;   // flag for two graphs
    // settings for a first graph
    Title         : string;
    ID            : integer;
    StatType      : integer;
    OrgID         : integer;
    bIsFP         : boolean;
    dFrom         : TDate;
    dTo           : TDate;
    MinYAuto      : boolean;
    MaxYAuto      : boolean;
    MinYValue     : Extended;
    MaxYValue     : Extended;
    mInverted     : boolean;
    Priv          : string;

    // settings for a second graph
    Title2        : string;
    ID2           : integer;
    StatType2     : integer;
    MinYAuto2     : boolean;
    MaxYAuto2     : boolean;
    MinYValue2    : Extended;
    MaxYValue2    : Extended;
    mInverted2    : boolean;
    FIsEditing    : boolean;
    MainStatGrid  : ^TBaseVirtualTree;
    PadWinSeledNode : PVirtualNode;
    procedure GraphRebuild(DatesAndValuesList : PAStatValue; DatesList : array of TDate; bInverted : boolean = false; SecondGraph : boolean = false);
    function GetID : integer;
    Procedure InitGraphByID(StatID: integer; StatType: integer; DatesList : TDates; bInverted:boolean = false; bTwoGraphs: boolean = false);
  end;

  // for Values list
  PStatDate = ^TStatDate;
  TStatDate =  record
    Date : TDate;
  end;

var
  PNodeData : PStatDate;

implementation

{$R *.dfm}

uses  MainPad,
	PrintSetupWindow,
//  GlobalVars,
	Printers,
  ZDbcIntfs,
	StrUtils;

procedure TSmallWin.ChartClick(Sender: TObject);
begin
  BringToFront;
end;

procedure TSmallWin.ChartDblClick(Sender: TObject);
begin
  if Splitter.Visible then
    Popupmenu1.Items[0].Caption := 'Показать значения'
  else
    Popupmenu1.Items[0].Caption := 'Скрыть значения';
  Splitter.Visible   := not Splitter.Visible;
  ValuesGrid.Visible := not ValuesGrid.Visible;
end;

procedure TSmallWin.ChartDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  TwoGraphs := true; // set up a flag
  Chart.Legend.Visible := true;

  Popupmenu1.Items[6].Visible := true; // make menu items related to second graph visible
  Popupmenu1.Items[7].Visible := true;

end;

procedure TSmallWin.DelSecondGraphMenuItemClick(Sender: TObject);
var
  Node : PVirtualNode;
begin
  TwoGraphs := false; // set up a flag

  Popupmenu1.Items[6].Visible := false;
  Popupmenu1.Items[7].Visible := false;
  FPMainDataset.SQL.Text := 'UPDATE statdescr SET SecondStatID=0 where StatID=' + IntToStr(ID);
  FPMainDataset.ExecSQL;

  Node := TMainStatForm(MainStatGrid.Parent).GetStatNodeByID(ID, StatType);
  PStat(MainStatGrid.GetNodeData(Node)).SecondGraph := 0;
  PostMessage(Self.Handle, CM_GRAPHREBUILDNEEDED, 0, 0);
end;

procedure TSmallWin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SendMessage(Self.Parent.Parent.Handle, CM_CHILDFORMCLOSE, ID, StatType);
  Hide;
  CanClose := false;
end;

procedure TSmallWin.FormCreate(Sender: TObject);
var
//  Line : TLineSeries;
  PrevDefined : boolean;
  ValueFound : boolean;
  MaxY : extended;
  MinY : extended;
  j : integer;
  curval  : extended;
  CurDate     : TDate;
  i           : integer;
begin
  Popupmenu1.Items[1].Checked := true;
  Popupmenu1.Items[2].Checked := true;
  ValuesGrid.Clear;
  ValuesGrid.NodeDataSize := SizeOf(TStatDate);
  ValuesGrid.Header.Columns[0].Text := 'Дата';
  ValuesGrid.Header.Columns[1].Text := 'Значение';
  ValuesGrid.Header.Columns[0].Width := (ValuesGrid.Width div 2) - 3;
  Chart.Legend.Visible := false;

  Splitter.Visible   := false;
  ValuesGrid.Visible := false;
  if TwoGraphs then begin
    Popupmenu1.Items[6].Visible := true;
    Popupmenu1.Items[7].Visible := true;
  end
  else begin
    Popupmenu1.Items[6].Visible := false;
    Popupmenu1.Items[7].Visible := false;
  end;
end;

procedure TSmallWin.FormDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  CurNode   : PVirtualNode;
  NodeData  : PStat;
begin
  if TwoGraphs then begin
    Accept := false
  end
  else if TComponent(Source).Name = 'StatsList' then begin
    CurNode  := TVirtualStringTree(Source).GetFirstSelected;
    NodeData := TVirtualStringTree(Source).GetNodeData(CurNode);
    Accept   := NodeData.ID <> ID
  end
  else begin
      Accept := false;
  end;
end;

function TSmallWin.GetID : integer;
begin
  Result := ID;
end;

procedure TSmallWin.Showvalues1Click(Sender: TObject);
begin
  if Splitter.Visible then
    Popupmenu1.Items[0].Caption := rsHntValuesShow
  else
    Popupmenu1.Items[0].Caption := rsHntValuesHide;

  Splitter.Visible    := not Splitter.Visible;
  ValuesGrid.Visible  := not ValuesGrid.Visible;
  ValuesGrid.Sort(nil, 0, sdAscending, false);
end;

procedure TSmallWin.ShowValuesOnGraphClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
	Chart.Series[0].Marks.Visible := TMenuItem(Sender).Checked;
end;

procedure TSmallWin.SplitterMoved(Sender: TObject);
begin
  ValuesGrid.Width := Splitter.Left;
end;

procedure TSmallWin.ValuesGridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  if Column = 0 then begin
    TargetCanvas.Brush.Color := clSilver;
    TargetCanvas.FillRect(CellRect);
    TargetCanvas.Font.Color  := clSilver;
  end;
end;

procedure TSmallWin.ValuesGridClick(Sender: TObject);
begin
  FFirstChar := #0;
end;

procedure TSmallWin.ValuesGridCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TVTCustomEditor1.Create;
end;

procedure TSmallWin.ValuesGridEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  Node1 : PVirtualNode;
  idx   : integer;
begin
  FIsEditing := false;
  Sender.InvalidateNode(Node);
  case FLastKey of
    VK_UP : begin
      Node1 := Sender.GetPreviousSibling(Node);
      if Node1 <> nil then begin
        Sender.Selected[Node1] := true;
        Sender.FocusedNode := Node1;
      end;
    end; // VK_UP
    VK_RETURN, VK_DOWN, VK_TAB : begin
      Node1 := Sender.GetNextSibling(Node);

      if Node1 <> nil then begin
        idx := Node1.Index + 1;
      end
      else begin
        idx := Node.Index + 1;
      end;
      PostMessage(Self.Handle, UM_VST_SELECT_ITEM, idx, 0);

    end; // VK_RETURN
    VK_LEFT : begin
      if Node <> nil then begin
        Sender.Selected[Node] := true;
        Sender.FocusedNode := Node;
        Sender.FocusedColumn := TVirtualStringTree(Sender).Header.Columns.GetPreviousVisibleColumn(Column, true);
      end;
    end;
//    VK_RIGHT, VK_TAB : begin
//      if Node <> nil then begin
//        Sender.Selected[Node] := true;
//        Sender.FocusedNode := Node;
//        Sender.FocusedColumn := TVirtualStringTree(Sender).Header.Columns.GetNextVisibleColumn(Column, true);
//      end;
//    end; // VK_RIGHT
  end; // CASE
  if Sender.Visible then
    Sender.SetFocus;
end;

procedure TSmallWin.ValuesGridEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  TmpNode : PVirtualNode;
begin
  if (not PrivPresentMO(Priv, 'bw')) or bIsFP then begin
    Allowed := false;
    Exit;
  end;

  Allowed := Column > 0;
  FIsEditing := true;
  TmpNode := Node;
end;

procedure TSmallWin.ValuesGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  CurStatNode : PVirtualNode;
  CurStatData : PStat;
  i : integer;
  found : boolean;
begin
  PNodeData := Sender.GetNodeData(Node);
  CellText := '';
  case Column of
    0 : begin
{$IFDEF MONTHLY}
      CellText := FormatDateTime('mmm yyyy', PNodeData.Date);
      CellText := AnsiUpperCase(LeftStr(CellText, 1)) + MidStr(CellText, 2, Length(CellText) - 1);
{$ELSE}
      CellText := DateToStr(PNodeData.Date);
{$ENDIF}
    end;
    1 : begin
      CurStatNode := TMainStatForm(MainStatGrid.Parent).GetStatNodeByID(ID, StatType);
      if CurStatNode <> nil then begin
        CurStatData := MainStatGrid^.GetNodeData(CurStatNode);
        for I := Low(CurStatData.Values) to High(CurStatData.Values) do begin
          if TDate(CurStatData.Values[i].Date) = PNodeData.Date then begin
            CellText := FloatToStr(CurStatData.Values[i].Value);
            found := true;
          end; // if
        end; // if
      end;
    end; // case of 1
  end;
end;

procedure TSmallWin.ValuesGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  ww: integer;
  Node          : PVirtualNode;
  NodeData      : PStatDate;
  MainNode      : PVirtualNode;
  MainNodeData  : PStat;
  i             : integer;
  j             : integer;
  found         : boolean;
begin
  ww := key;
  if Key = VK_DELETE then begin
    Node := TVirtualStringTree(Sender).GetFirstSelected;
    if Node <> nil then begin
      found := false;
      NodeData := TVirtualStringTree(Sender).GetNodeData(Node);         // get the date is being edited
      MainNode := TMainStatForm(MainStatGrid^.Parent).GetStatNodeByID(ID, StatType); // get the proper node from main tree
      MainNodeData := MainStatGrid^.GetNodeData(MainNode);
      for i := Low(MainNodeData.Values) to High(MainNodeData.Values) do begin
        if MainNodeData.Values[i].Date = NodeData.Date then begin
          found := true;
          break;
        end;
      end;
      for j := i to High(MainNodeData.Values)-1 do begin
        MainNodeData.Values[j].Date  := MainNodeData.Values[j+1].Date;
        MainNodeData.Values[j].Value := MainNodeData.Values[j+1].Value;
      end;
      if found then begin
      	i := Length(MainNodeData.Values);
        SetLength(MainNodeData.Values, Length(MainNodeData.Values)-1);
        DeleteStatValueFromDB(FPMainDataset, ID, NodeData.Date);
        for I := 0 to TMainStatForm(MainStatGrid^.Parent).ScrollBox.ControlCount - 1 do begin
          if (TMainStatForm(MainStatGrid^.Parent).ScrollBox.Controls[i] is TSmallWin) and
             ((TSmallWin(TMainStatForm(MainStatGrid^.Parent).ScrollBox.Controls[i]).ID = ID) or
              (TSmallWin(TMainStatForm(MainStatGrid^.Parent).ScrollBox.Controls[i]).ID2 = ID)) then
            PostMessage(TSmallWin(TMainStatForm(MainStatGrid^.Parent).ScrollBox.Controls[i]).Handle, CM_GRAPHREBUILDNEEDED, 0, 0);
        end;
      end;
      PostMessage(Self.Handle, UM_VST_SELECT_ITEM, Node.Index + 1, 0);
      //TVirtualStringTree(Sender).RepaintNode(Node);
    end; // if Node <> nil
  end; // VK_DELETE
  inherited;
end;

procedure TSmallWin.ValuesGridKeyPress(Sender: TObject; var Key: Char);
var
  TmpNode : PVirtualNode;
begin
  if Pos(key, AllowedChars) = 0 then begin
    inherited;
    Exit;
  end;
  FIsEditing := true;
  FFirstChar := Key;
  TmpNode := TVirtualStringTree(Sender).GetFirstSelected;
  TVirtualStringTree(Sender).EditNode(TmpNode, TVirtualStringTree(Sender).FocusedColumn);
end;

procedure TSmallWin.ValuesGridNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
Var
  CurMainListNode   : PVirtualNode;
  MainListNode      : PVirtualNode;
  MainListNodeData  : PStat;
  i                 : integer;
  ij                : integer;
  found             : boolean;
begin
  PNodeData := Sender.GetNodeData(Node);
  case Column of
    1 : begin
        MainListNode := TMainStatForm(MainStatGrid^.Parent).GetStatNodeByID(ID, StatType);
        MainListNodeData := MainStatGrid^.GetNodeData(MainListNode);
        if MainListNode <> nil then begin
          if Length(MainListNodeData.Values) > 0 then begin // if the values array is not empty
            for i := Low(MainListNodeData.Values) to High(MainListNodeData.Values) do
              if TDate(MainListNodeData.Values[i].Date) = PNodeData.Date then begin
                MainListNodeData.Values[i].Value := StrToFloat(NewText);
                StatValueToDB(FPMainDataset, ID, PNodeData.Date, MainListNodeData.Values[i].Value);
                found := true;
                break;
              end; // if
            ij := High(MainListNodeData.Values);
          end
          else begin
          	i	 	:= 0;
	          ij 	:= -1;
          end;
          if i > ij then begin // i.e. it's a new value
            SetLength(MainListNodeData.Values, i+1);
            MainListNodeData.Values[i].Value := StrToFloat(NewText);
            MainListNodeData.Values[i].Date := PNodeData.Date;
            StatValueToDB(FPMainDataset, MainListNodeData.ID, PNodeData.Date, MainListNodeData.Values[i].Value);
          end; // if I>
          // rebuild necessary graphs
          // rebuild myself
          PostMessage(Self.Handle, CM_GRAPHREBUILDNEEDED, Integer(Addr(MainListNodeData.Values)), Integer(Addr(SelectedDate)));
          // rebuild all the graphs where this stat is a second one
          for I := 0 to TMainStatForm(MainStatGrid^.Parent).ScrollBox.ControlCount - 1 do begin
            if TSmallWin(TMainStatForm(MainStatGrid^.Parent).ScrollBox.Controls[i]).ID2 = ID then begin
              PostMessage(TSmallWin(TMainStatForm(MainStatGrid^.Parent).ScrollBox.Controls[i]).Handle, CM_GRAPHREBUILDNEEDED, 0, 0);
            end;
          end;
        end; // if MainListNode <> nil
    end;  // case of 1
  end; // case Column of
  Sender.InvalidateNode(Node);
  if Sender.Visible then
    Sender.SetFocus;
end;

procedure TSmallWin.VerticalGridShowHideClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  Chart.BottomAxis.Grid.Visible := TMenuItem(Sender).Checked;
end;

Procedure TSmallWin.GraphRebuild(DatesAndValuesList : PAStatValue; DatesList : array of TDate; bInverted:boolean = false; SecondGraph: boolean = false);
Var
  Line            : TLineSeries;
  PrevDefined     : boolean;
  i, j            : integer;
  ValueFound      : boolean;
  StatValue       : TStatValue;
  ArrStatValue    : TAStatValue;
  Value1, Value2  : extended;
  CurColor        : TColor;
  MaxY, MinY      : Extended;
  NewNodeData     : PStatDate;
  NewNode         : PVirtualNode;
  G1              : TSeriesGroup;
  CurAxis         : ^TChartAxis;
  MinYV, MaxYV    : Extended;
  MinYA, MaxYA    : boolean;
{$IFDEF MONTHLY}
  Year, Month, Day : word;
{$ENDIF}

begin
  ArrStatValue := DatesAndValuesList^;

  // filling values grid with the dates
  ValuesGrid.Clear;
  for i := High(DatesList) downto Low(DatesList) do begin
    NewNode := ValuesGrid.GetFirstChild(nil);
    while NewNode <> nil do begin
      NewNodeData := ValuesGrid.GetNodeData(NewNode);
      if NewNodeData.Date = DatesList[i] then
        break;
      NewNode := ValuesGrid.GetNextSibling(NewNode);
    end;
    if NewNode = nil then begin
      NewNode := ValuesGrid.InsertNode(nil, amAddChildLast);

      NewNodeData := ValuesGrid.GetNodeData(NewNode);
      NewNodeData.Date := DatesList[i];
    end;
  end;

  if(not SecondGraph) then begin // if it's a first graph on the chart - clear everything
    Chart.SeriesList.Clear;
    Chart.SeriesGroups.Clear;
    // setting up the bottom Axis - only for the first graph
    Chart.BottomAxis.Automatic := false;
    Chart.BottomAxis.Maximum := DatesList[Low(DatesList)];
    Chart.BottomAxis.Grid.Visible := true;
    Chart.BottomAxis.Minimum := DatesList[High(DatesList)];
    Chart.BottomAxis.Automatic := false;
    Chart.BottomAxis.AutomaticMaximum := false;
    Chart.BottomAxis.AutomaticMinimum := false;

    Chart.BottomAxis.Minimum := Low(DatesList) - 0.1;
    Chart.BottomAxis.Maximum := High(DatesList) + 0.1;
    Chart.BottomAxis.Increment := 1;
  end;

  if SecondGraph then begin       // if it's a second graph on the chart - work with right axis
    CurAxis := addr(Chart.RightAxis);
    MinYV := MinYValue2;
    MaxYV := MaxYValue2;
    MinYA := MinYAuto2;
    MaxYA := MaxYAuto2;
    CurAxis.Grid.Visible := false;
    Chart.Legend.Visible := true;
    Popupmenu1.Items[6].Visible := true; // make menu items related to second graph visible
    Popupmenu1.Items[7].Visible := true;
  end
  else begin                           // if first - work with left axis
    CurAxis := addr(Chart.LeftAxis);
    MinYV := MinYValue;
    MaxYV := MaxYValue;
    MinYA := MinYAuto;
    MaxYA := MaxYAuto;
    CurAxis.Grid.Visible := true;
    Chart.Legend.Visible := false;
  end;

  CurAxis.MinorTicks.Visible := false;
  // adding the lines to the Graph
  Line := TLineSeries.Create(Self);
	Line.Marks.Visible := false;
	Line.Marks.Style := smsValue;
  Line.LinePen.Width := 2;
  if SecondGraph then begin       // assign first graph to left Axis
    Line.VertAxis := aRightAxis;
    Line.Pen.Style := psDash;
  end
  else                            // and second graph  - to right axis
    Line.VertAxis := aLeftAxis;

  Chart.AddSeries(Line);
  Line.ColorEachLine := true;
  Line.ColorEachPoint := true;
  if SecondGraph then begin       // assign second graph to group for visualization
    G1 := Chart.SeriesList.AddGroup('Второй график: ' + Title2 + ' (пунктир)');
    G1.Add(Line);
  end;

  Line.Pointer.Visible := true;
  Line.Pointer.VertSize := 2;
  Line.Pointer.HorizSize := 2;
  Line.Pointer.Style := psCircle;

  PrevDefined := false;
  MaxY := 0; MinY := 0;
  for i := High(DatesList) downto Low(DatesList) do begin
    ValueFound := false;
    for j := Low(ArrStatValue) to High(ArrStatValue) do begin
      StatValue := ArrStatValue[j];
      if StatValue.Date = DatesList[i] then begin
        Value2 := StatValue.Value;
        if i = High(DatesList) then begin
          MaxY := Value2;
          MinY := Value2;
        end;
        if MaxY < Value2 then MaxY := Value2;
        if MinY > Value2 then MinY := Value2;

        if PrevDefined then begin
          if (Value2 > Value1) then
            if not bInverted then
              CurColor := clBlack
            else
              CurColor := clRed
          else
            if not bInverted then
              CurColor := clRed
            else
              CurColor := clBlack
        end
        else begin
          CurColor := clBlack;
        end;
{$IFDEF MONTHLY}
        DecodeDate(DatesList[i], Year, Month, Day);
        Line.AddXY(High(DatesList)-i, Value2, MonthNameShort[Month] + ' ' + IntToStr(Year mod 2000), CurColor);
{$ELSE}
        Line.AddXY(High(DatesList)-i, Value2, DayToStr(DatesList[i]), CurColor);
{$ENDIF}

        ValueFound := true;
        Value1 := Value2; PrevDefined := true;
        break;
      end;
    end;
    if not ValueFound then begin
{$IFDEF MONTHLY}
        DecodeDate(DatesList[i], Year, Month, Day);
        Line.AddNullXY(High(DatesList)-i, 0, MonthNameShort[Month] + ' ' + IntToStr(Year mod 2000));
{$ELSE}
        Line.AddNullXY(High(DatesList)-i, 0, DayToStr(DatesList[i]));
{$ENDIF}
      PrevDefined := false;
    end;
  end;

  // new version - combined
  CurAxis^.Minimum := Low(Integer);
  CurAxis^.Maximum := High(Integer);

  if MinYA then begin
  // new version - combined
    CurAxis^.AutomaticMinimum := true;
  end
  else begin
    CurAxis^.AutomaticMinimum := false;
    CurAxis^.Minimum := MinYV;
  end;
  if MaxYA then begin
   CurAxis^.AutomaticMaximum := true
  end
  else begin
    CurAxis^.AutomaticMaximum := false;
    CurAxis^.Maximum := MaxYV;
  end;
  CurAxis^.Inverted := bInverted;
end;

procedure TSmallWin.HorizontalGridShowHideClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  Chart.LeftAxis.Grid.Visible  := TMenuItem(Sender).Checked;
end;

procedure TSmallWin.OnGraphRebuildNeeded(var Message: TMessage);
Var
  SeldDate  : ^TDate;
  Node      : PVirtualNode;
  NodeData  : PStatDate;
  Dates     : TDates;
begin
  // new version - WITH second graph available
  if bIsFP then begin
	  Dates := arrOrgDates[OrgID].FPDates;
  end
  else begin
	  Dates := arrOrgDates[OrgID].StatDates;
  end;
  InitGraphByID(ID, StatType, Dates, mInverted);


  if(TwoGraphs) then begin
	  InitGraphByID(ID2, StatType2, Dates, mInverted2, TwoGraphs);
  end;
end;

procedure TSmallWin.OnNumOfWeeksChanged(var Message: TMessage);
Var
  SeldDate  : ^TDate;
  Node      : PVirtualNode;
  NodeData  : PStatDate;
begin
  OnGraphRebuildNeeded(Message);
end;


procedure TSmallWin.PrintStatMenuItemClick(Sender: TObject);
const
  LongSide : integer = 1000;
Var
  CurSmallWin : TSmallWin;
  Chart : TChart;
  Series1 : TLineSeries;
  i : integer;
begin
	PrintSetupForm := TPrintSetupForm.Create(nil);
  PrintSetupForm.ChartToPrint := TSmallWin(TComponent(Sender).Owner).Chart;
  PrintSetupForm.InitChart;
  PrintSetupForm.ShowModal;
  PrintSetupForm.Free;

  Exit;

  if (not PrintDialog.Execute()) then begin
    Exit;
  end;

  CurSmallWin := TSmallWin(TComponent(Sender).Owner);
  Chart := TChart.Create(nil);
  Series1 := TLineSeries.Create(nil);
  Chart.Assign(CurSmallWin.Chart);
  Chart.Visible := false;
  Chart.Parent := CurSmallWin;
  Chart.BringToFront;
//
//  Chart.PrintResolution := -1000;
//
  Printer.Title := CurSmallWin.Caption;
  if CurNumOfWeeks > 13 then begin
    Chart.Height := Round(LongSide * 0.7);
    Chart.Width := LongSide;
  end
  else begin
    Chart.Height := LongSide;
    Chart.Width := Round(LongSide * 0.7);
  end;

  Chart.LeftAxis.Assign(CurSmallWin.Chart.LeftAxis);
  Chart.Axes.Bottom.Assign(CurSmallWin.Chart.BottomAxis);
  Series1.Assign(CurSmallWin.Chart.Series[0]);
  Chart.AddSeries(Series1);
  Chart.Axes.Left.TicksInner.Visible := false;
  Chart.Axes.Left.MinorTicks.Visible := false;
  Chart.Axes.Left.Grid.Visible := true;
  Chart.Axes.Left.Grid.Style := psDash;
  Chart.LeftAxis.Axis.Width := 1;
  Chart.Axes.Left.Ticks.Width := 1;
  Chart.Axes.Left.TickLength := 1;
  Chart.Axes.Bottom.TicksInner.Visible := false;
  Chart.Axes.Bottom.MinorTicks.Visible := false;
  Chart.Axes.Bottom.Grid.Visible := false;
  Chart.Axes.Bottom.Grid.Width := 1;
  Chart.Axes.Bottom.Ticks.Width := 1;
  Chart.Axes.Bottom.TickLength := 1;
  Chart.BottomAxis.Axis.Width := 1;
  Chart.Title.Font.Size := 12;
  Chart.Title.Visible := true;
  Chart.Title.Caption := CurSmallWin.Caption;
  Chart.PrintMargins := Rect(Point(0, 0), Point(0, 0));

  for I := 1 to printDialog.Copies do begin
    if CurNumOfWeeks > 13 then begin
      Chart.PrintLandscape;
    end
    else begin
      Chart.PrintPortrait;
    end;
  end;
  Chart.Free;
end;

procedure TSmallWin.OnVSTEndEdit(var Msg: TMessage);
begin
  ValuesGrid.EndEditNode;
end;

procedure TSmallWin.OnVSTSelectItem(var Msg: TMessage);
var
  Cnt : integer;
  Node : PVirtualNode;
begin

  //Node := ValuesGrid.GetNext(ValuesGrid.RootNode);
  Node := ValuesGrid.GetFirstChild(ValuesGrid.RootNode);
  Cnt := 1;
  while (Node <> nil)  and (Cnt < Msg.WParam) do begin
    Node := ValuesGrid.GetNext(Node);
    Inc(Cnt);
  end;
  if Node <> nil then begin
    ValuesGrid.ClearSelection;
    ValuesGrid.Selected[Node] := true;
    ValuesGrid.FocusedNode := Node;
    ValuesGrid.FocusedColumn := 2;
  end;

  ValuesGrid.Repaint;
//  Result := Node;//Should Return Nil if the index is not reached.
end;

procedure TVTCustomEditor1.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  C     : Char;
begin
//  ShowMessage(PWideChar('---- AttLoaderThread thread (' + IntToStr(integer(FEdit)) + ')'));
  case Key of
    VK_LEFT, VK_TAB, VK_RIGHT, VK_UP, VK_RETURN, VK_DOWN : begin
      FLastKey := Key;
      Key := 0;
      if FTree.Parent <> nil then
        PostMessage(FTree.Parent.Handle, UM_VST_END_EDIT, 0, 0);
    end; // VK_TAB
    VK_BACK: begin
      C := FEdit.Text[Length(FEdit.Text)];
      if C = FormatSettings.DecimalSeparator then
        FDecSepAlreadyPresent := false;
      if (C = '-') or (Length(FEdit.Text) = 1) then
        FSignAlreadyPresent := false;
      FEdit.Text := LeftStr(FEdit.Text, Length(FEdit.Text) -1);
      FEdit.SelStart  := Length(FEdit.Text);
    end; // VK_BACK
  else
    inherited;
  end; // Case
end;

procedure TVTCustomEditor1.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Pos(Key, AllowedChars) <= 0 then begin
//    ShowMessage(PWideChar('---- AttLoaderThread thread (' + IntToStr(integer(FEdit)) + ')'));
    Key := #0;
  end;
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
        FSignAlreadyPresent 	:= true;
        FDecSepAlreadyPresent := true;
        Key := FormatSettings.DecimalSeparator;
      end; // if FDecSepAlreadyPresent
    end; // '.', ','
  end; // case Key of
end;

procedure TVTCustomEditor1.CMDialogKey(var Msg: TWMKEY);
var
  Key : Word;
begin
  if (Msg.Charcode = VK_TAB) then begin
    Key := Msg.CharCode;
    EditKeyDown(Self, Key, []);
  end;
  inherited;
end;

destructor TVTCustomEditor1.Destroy;
begin
  //FreeAndNil(FEdit);
  FEdit.Free;
  inherited;
end;

function TVTCustomEditor1.BeginEdit: Boolean;
begin
  Result := True;

  with FEdit do begin
    AutoSelect := false;
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
    SelStart  := 1;
    Show;
    if Visible then
      SetFocus;
  end;
end;

function TVTCustomEditor1.CancelEdit: Boolean;
 begin
  Result := True;
  FEdit.Hide;
  FTree.InvalidateNode(FNode);
end;

function TVTCustomEditor1.EndEdit: Boolean;
var
  Txt: String;
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

function TVTCustomEditor1.GetBounds: TRect;
begin
  Result := Ftree.GetDisplayRect(FNode, 1, FALSE, True, FALSE);
  Result.Left := Result.Left + 10;
  Result.Top := Result.Top + 10;
  Result.Bottom := Result.Bottom + 10;
  Result.Right := Result.Right + 10;
end;

function TVTCustomEditor1.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
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
  Pt := Ftree.GetDisplayRect(FNode, 1, FALSE);
  Point1 := pt.TopLeft;
  Point2 := pt.BottomRight;

  Point1 := MainStatForm.ScreenToClient(FTree.ClientToScreen(Point1));
  Point2 := MainStatForm.ScreenToClient(FTree.ClientToScreen(Point2));

  FEdit.Color := TColor($AAFFFF);
  with FEdit do begin
    Top := Point1.Y-2;
    Left := Point1.X-2;
    Width := Ftree.Header.Columns[1].Width+3;
    Alignment := taRightJustify;
    Margins.Left := 5;
    Margins.Right := 0;
    Margins.Top := 0;
    Margins.Bottom := 0;
    AlignWithMargins := true;
    Visible := True;
    PArent := Ftree;
    Font.Style := Font.Style + [fsBold];
    Text := FTree.Text[FNode, FColumn];
    OnKeyDown   := EditKeyDown;
    OnKeyPress  := EditKeyPress;
  end;
  SetWindowRgn( FEdit.Handle, CreateRectRgn(2, 2, FEdit.Width - 2, FEdit.Height - 2), True);

end;

procedure TVTCustomEditor1.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TVTCustomEditor1.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, R.Left, R.Right);

  Dummy := integer(FEdit);
  FEdit.BoundsRect := R;
end;

procedure TSmallWin.InitGraphByID(StatID: integer; StatType: integer; DatesList : TDates; bInverted:boolean = false; bTwoGraphs: boolean = false);
begin
  GraphRebuild((TMainStatForm(MainStatGrid.Parent).GetStatValuesOfNodeByID(StatID, StatType)), DatesList, bInverted, bTwoGraphs);
end;

end.
