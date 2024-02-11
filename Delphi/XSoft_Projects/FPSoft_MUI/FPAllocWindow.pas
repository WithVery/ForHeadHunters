unit FPAllocWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, BaseGrid, AdvGrid, ComCtrls, ImgList, acAlphaImageList, ToolWin, sToolBar,
  Buttons, sSpeedButton, ExtCtrls, sSplitter, sPanel, sGroupBox, sRichEdit,
//  MSXML2_TLB,
//  ComObj,
//	FPXMLBinding,
  Printers,
  //RpDevice,
  GlobalVars,
  FPFundsListWindow, // for TFPFundsListForm
  FPLockerThread,
  POLockerThread,
  sComboBox, sEdit, sUpDown,
  RVScroll, RichView, RVStyle, RVEdit, PtblRV, AdvUtil, System.ImageList, AdvObj;

type
  TFPAllocForm = class(TForm)
    StrGrid: TAdvStringGrid;
    Toolbar: TsToolBar;
    Images: TsAlphaImageList;
    PD: TPrintDialog;
    StatusBar: TStatusBar;
    RowAddToolButton: TsSpeedButton;
    RowDelToolButton: TsSpeedButton;
    SaveToolButton: TsSpeedButton;
    ApproveToolButton: TsSpeedButton;
    PrintToolButton: TsSpeedButton;
    IncPlanButton: TsSpeedButton;
    Panel: TsPanel;
    Splitter: TsSplitter;
    tbFont: TsToolBar;
    PlanPanel: TsPanel;
    ToolbarImages: TImageList;
    btnClearIncPlan: TToolButton;
    ToolButton1: TToolButton;
    btnUndo: TToolButton;
    cmbFont: TsComboBox;
    btnSplitter2: TToolButton;
    btnBold: TToolButton;
    btnItalic: TToolButton;
    btnUnderline: TToolButton;
    btnAlignLeft: TToolButton;
    btnAlignCenter: TToolButton;
    btnAlignRight: TToolButton;
    btnBullets: TToolButton;
    btnPrintIncPlan: TToolButton;
    btnSaveIncPlan: TToolButton;
    HorSplitToolButton: TsSpeedButton;
    FundsTableButton: TsSpeedButton;
    RVEditor: TRichViewEdit;
    RVStyle: TRVStyle;
    cd: TColorDialog;
    btnFontColor: TToolButton;
    ToolButton3: TToolButton;
    btnFontBackColor: TToolButton;
    cmbFontSize: TComboBox;
    btnAlignJust: TToolButton;
    cb: TControlBar;
    tbFile: TsToolBar;
    tbPara: TsToolBar;
    tbTable: TToolBar;
    btnAddTable: TToolButton;
    ToolButton4: TToolButton;
    btnAddTblColumn: TToolButton;
    btnDelTblColumn: TToolButton;
    btnAddTblRow: TToolButton;
    btnDelTblRow: TToolButton;
    btnNoBullets: TToolButton;
    ToolButton2: TToolButton;
    btnParaFill: TToolButton;
    ToolButton5: TToolButton;
    btnMergeCells: TToolButton;
    btnSplitCellHoriz: TToolButton;
    btnSplitCellVert: TToolButton;
    btnRedo: TToolButton;
    tbEdit: TToolBar;
    btnCopy: TToolButton;
    btnCut: TToolButton;
    btnPaste: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    btnIndentInc: TToolButton;
    btnIndentDec: TToolButton;
    RVPrint1: TRVPrint;
    procedure FormCreate(Sender: TObject);
    procedure StrGridGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure StrGridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure StrGridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor: TEditorType);
    procedure StrGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure StrGridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure StrGridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
    procedure StrGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StrGridEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure StrGridEditChange(Sender: TObject; ACol, ARow: Integer; Value: string);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure StrGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RowAddToolButtonClick(Sender: TObject);
    procedure RowDelToolButtonClick(Sender: TObject);
    procedure SaveToolButtonClick(Sender: TObject);
    procedure ApproveToolButtonClick(Sender: TObject);
    procedure PrintToolButtonClick(Sender: TObject);
    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
    procedure IncPlanButtonClick(Sender: TObject);
    procedure SplitterResize(Sender: TObject);
    procedure btnClearIncPlanClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure SelectionChange(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure btnAlignLeftClick(Sender: TObject);
    procedure btnAlignCenterClick(Sender: TObject);
    procedure btnAlignRightClick(Sender: TObject);
    procedure btnBulletsClick(Sender: TObject);
    procedure btnPrintIncPlanClick(Sender: TObject);
    procedure btnSaveIncPlanClick(Sender: TObject);
    procedure StrGridGetCellPrintBorder(Sender: TObject; ARow, ACol: Integer; APen: TPen; var Borders: TCellBorders);
    procedure StrGridUpdateColumnSize(Sender: TObject; ACol: Integer; var AWidth: Integer);
    procedure HorSplitToolButtonClick(Sender: TObject);
    procedure StrGridMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure StrGridMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure StrGridGetEditText(Sender: TObject; ACol, ARow: Integer; var Value: string);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FundsTableButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RVEditorStyleConversion(Sender: TCustomRichViewEdit; StyleNo, UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
    procedure RVEditorCurTextStyleChanged(Sender: TObject);
    procedure btnFontColorClick(Sender: TObject);
    procedure btnFontBackColorClick(Sender: TObject);
    procedure cmbFontClick(Sender: TObject);
    procedure cmbFontSizeClick(Sender: TObject);
    procedure cmbFontSizeExit(Sender: TObject);
    procedure cmbFontSizeKeyPress(Sender: TObject; var Key: Char);
    procedure RVEditorParaStyleConversion(Sender: TCustomRichViewEdit; StyleNo, UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
    procedure btnAlignJustClick(Sender: TObject);
    procedure RVEditorCurParaStyleChanged(Sender: TObject);
    procedure cbMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SplitterMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SplitterMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cbMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnAddTableClick(Sender: TObject);
    procedure btnAddTblColumnClick(Sender: TObject);
    procedure btnAddTblRowClick(Sender: TObject);
    procedure btnDelTblColumnClick(Sender: TObject);
    procedure btnDelTblRowClick(Sender: TObject);
    procedure RVEditorCaretMove(Sender: TObject);
    procedure btnNoBulletsClick(Sender: TObject);
    procedure btnParaFillClick(Sender: TObject);
    procedure btnMergeCellsClick(Sender: TObject);
    procedure btnSplitCellVertClick(Sender: TObject);
    procedure btnSplitCellHorizClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnCutClick(Sender: TObject);
    procedure btnIndentIncClick(Sender: TObject);
    procedure btnIndentDecClick(Sender: TObject);
  private
    { Private declarations }
    // TRichViewEdit variables
    FontName: String;
    FontSize: integer;

    TmpFundCombo  		: TComboBox;
    FromFondCombo 		: TComboBox;
    ApproveCombo  		: TComboBox;
    TGIStrNum      		: integer; 	// Total income
    GIStrNum      		: integer;	// Total Income reduced by Special Income
    FPBalD        		: extended;
    FromDateS     		: string;
    ToDateS       		: string;
    FromDate     		  : TDateTime;
    ToDate       		  : TDateTime;
    RecordFP      		: boolean;
    FPWasChanged  		: boolean;
    PrevApproveStatus	: string;			// to trace the status of PO
    PrintingIsIP			: boolean;
    FPBal							: extended;
    ErrorPresent			: boolean;
    BalanceIsNotNull	: boolean;
    ErrCol						: integer;
    ErrRow						: integer;
    FUpdating					: Boolean;
    FFromRecalc       : boolean;

  	FundList    			: TList;
    FFList            : TList;     // list of funds allowed to work with with current priviledges

    FundSums					: TStringList;
		IndexGlobals	: integer;
	  IndexA 				:	integer;
		IndexA1 			:	integer;
    IndexB				: integer;
    IndexC				: integer;
		IndexD				: integer;
    IndexE				: integer;
    IndexF				: integer;
    IndexG				: integer;

   	fplink			: string;
	  lfplink			: string;
  	cashlink		: string;
	  bill1link		: string;
  	polink			: string;

    FP1PStr     : string;     // FP1 % for fund
    FP1PEditing : boolean;    // FP1 % is being edited
    FP1AStr     : string;     // FP1 amount for fund
    FP1AEditing : boolean;    // FP1 amount is editing

    LastRecDate : TDateTime;
    EarlyAppr		: boolean;    // true if FP was approved BEFORE the actual period end

{$IFDEF NATPRINT}             // native printing stuff
    PixPerInchX,PixPerInchY,PageWidthInMM,PageHeightInMM,PhysOffsetX,PhysOffsetY,PageResX,PageResY,PhysPageWidth,PhysPageHeigth:integer;
    OrgShortName : string;
{$ENDIF}

// Stats export stuff
    IncByIS : array of extended;
    ISBySID : array of integer; // ling of Income source to Stat ID
//  for toolbars inside the controlbar
  	tbFontWidth : integer;
  	tbParaWidth : integer;
  	tbFileWidth : integer;

// for checking funds zero bound
    PrevCellValue : string;
    SubZeroFundExists : boolean;

    FPLT : TFPLockerThread;
    MaxPONum : integer;
    cm       : extended;
    POList   : TStringList; // PurchaseOrders inside FP
    POrList  : TStringList; // PurchaseOrders inside FP but originally set in po table
    BAlist   : TStringList; // BankAccounts
    AcToDC   : TStringList; // transfers from account to Disbirsment cash
    PA       : ^string;
    procedure InitBAList;
    procedure RecalcFP;
    procedure GetToolBarsWidths;
    procedure SetToolBarsWidths;
    function  ProcessFormula(ARow, ACol : integer) : extended;
    procedure SaveFP(RecordFP : boolean = false);
    procedure SaveAndApproveFP;
    function 	CurrText: TTextAttributes;
		procedure GetFontNames;
		procedure UpdateCursorPos;
    procedure SaveIncPlan;
    procedure TransferAssets(ATmpVal : Extended; AFundLink, AReason : string);
    procedure RecalcFundsRests;
    procedure InitFunds;
    procedure AddInSumToFFL(AVal : Extended; AFundName: string);
    procedure AddSumToFFL(AVal : Extended; AFundName: string);
    procedure AddPOSumToFFL(AVal : Extended; AFundName: string);
    procedure InitFundsTree;
    procedure ClearFundsTree;
    procedure SearchSubZeroFund;
    procedure OnFundsListHide(var Msg: TMessage); message UM_FP_FUNDSLISTHIDE;
    procedure OnFundTransferred(var Msg: TMessage); message UM_FUNDTRANSFERRED;

  protected
    Procedure CreateParams(Var Params : TCreateParams); override;

  public
    { Public declarations }
    ReadOnly  : boolean;
    PWin      : TWinControl;
    OrgPrefix	: string;
    iOrgPrefix: integer;
    FPPrivs   : string;
    Fndr      : boolean;

    FPFLF     : TFPFundsListForm;
    procedure InitDB;
    procedure InitArcDB;
  end;

//var
//  FPAllocForm: TFPAllocForm;

implementation

{$R *.dfm}
  Uses
	DB, // for ftBlob
	RVTable,  // fr tables in TRichViewEdit
  RVItem,   // for TCustomRVItemInfo in TRichViewEdit
	TableDataWindow, // for TableDataForm
	IncPlanPrintPreviewWindow,
	FPUnsavedExitWindow,
	ZDbcIntfs,
  POApproveWindow,
	RichEdit,
  ErrorWindow,
  POWindow,
  VirtualTrees,
  StrUtils;

procedure TFPAllocForm.InitBAList;
var
//  i : integer;
  astr : ^string;
begin
  BAList := TStringList.Create;
	FPTmpDataset.SQL.Text := 'SELECT name,link FROM ' + OrgPrefix + 'bank WHERE`index`>1 and link<>:fB1';
  FPTmpDataset.ParamByName('fB1').AsString := OrgPrefix + BILL1_LINK;
  try
    FPTmpDataset.Open;
  except

  end;

  while not FpTmpDataset.Eof do begin
    New(astr);
    if astr <> nil then begin
      astr^ := Trim(FPTmpDataset.FieldByName('name').AsAnsiString);
      BAList.AddObject(FPTmpDataset.FieldByName('link').AsString, TObject(astr));
    end;
    FPTmpDataset.Next;
  end;
end;

procedure TFPAllocForm.InitFunds;
var
  j        : integer;
begin
  if Assigned(FundList) then
    FundList.Free;

  FundList := TList.Create;
  FundList := CompFondList(OrgPrefix + 'fond',  0, CFL_IGNOREGROUPS, CFL_CONSIDERPOS, OrgPrefix, true);

  FFList := TList.Create;
  FFList.Assign(FundList);
  ListFilterOut(FFList, OrgPrefix, Fndr);

  FromFondCombo.Clear;
  TmpFundCombo.Clear;
{$IFDEF FAFH}
	for j := 0 to FFList.Count - 1 do begin
  	TmpFundCombo.Items.Add(PVTResourceData(FFList[j]).name);
    FromFondCombo.Items.AddObject(PVTResourceData(FFList[j]).name + ' (' + MyFloatToStr(PVTResourceData(FFList[j]).balance)+ ')', TObject(FFList[j]));
	end;
{$ELSE}
	for j := 0 to FundList.Count - 1 do begin
  	TmpFundCombo.Items.Add(PVTResourceData(FundList[j]).name);
    FromFondCombo.Items.AddObject(PVTResourceData(FundList[j]).name + ' (' + MyFloatToStr(PVTResourceData(FundList[j]).balance)+ ')', TObject(FundList[j]));
	end;
{$ENDIF}
end;

procedure TFPAllocForm.OnFundTransferred(var Msg: TMessage);
begin
  InitFunds;
  InitFundsTree;
  ClearFundsTree;
  RecalcFP;
end;

procedure TFPAllocForm.OnFundsListHide(var Msg: TMessage);
begin
  FundsTableButton.Down := false;
end;

procedure TFPAllocForm.AddPOSumToFFL(AVal : Extended; AFundName: string);
var
	PFFNodeData : PFFLData;
  PFFNode     : PVirtualNode;
begin
  if Assigned(FPFLF) and (Round(AVal * 100) > 0) and (AFundName <> '') then begin
    PFFNode := FPFLF.GetNodeByFundName(AFundName);
    if PFFNode = nil then begin                                     // Add New fund to the FPFundsListForm
{$IFDEF FAFH}
      if PrivPresentMO(FPPrivs, 'b0') then begin
{$ENDIF}
      PFFNode := FPFLF.FundsTree.AddChild(nil);
      PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);
      PFFNodeData.name := AFundName;
      PFFNodeData.link := GetLinkOfFondByName(FundList, PFFNodeData.name);
      PFFNodeData.InAmnt  := 0;
      PFFNodeData.FPAmnt  := 0;
      PFFNodeData.POAmnt  := AVal;
{$IFDEF FAFH}
      end
{$ENDIF}
    end
    else begin
      PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);
      PFFNodeData.POAmnt  := PFFNodeData.POAmnt + AVal;
      PFFNodeData.IsInFP  := true;
    end
  end;
end;

procedure TFPAllocForm.AddInSumToFFL(AVal : Extended; AFundName: string);
var
	PFFNodeData : PFFLData;
  PFFNode     : PVirtualNode;
begin
  if Assigned(FPFLF) and  (Round(AVal * 100) > 0) and (AFundName <> '') then begin
    PFFNode := FPFLF.GetNodeByFundName(AFundName);
    if PFFNode = nil then begin                                     // Add New fund to the FPFundsListForm
{$IFDEF FAFH}
      if PrivPresentMO(FPPrivs, 'b0') then begin
{$ENDIF}
      PFFNode := FPFLF.FundsTree.AddChild(nil);
      PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);
      PFFNodeData.name := AFundName;
      PFFNodeData.link := GetLinkOfFondByName(FundList, PFFNodeData.name);
      PFFNodeData.InAmnt  := AVal;
      PFFNodeData.FPAmnt  := 0;
      PFFNodeData.POAmnt  := 0;
{$IFDEF FAFH}
      end
{$ENDIF}
    end
    else begin
      PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);
      PFFNodeData.InAmnt  := PFFNodeData.InAmnt + AVal;
    end
  end;
end;

procedure TFPAllocForm.AddSumToFFL(AVal : Extended; AFundName: string);
var
	PFFNodeData : PFFLData;
  PFFNode     : PVirtualNode;
begin
  if Assigned(FPFLF) and  (Round(AVal * 100) > 0) and (AFundName <> '') then begin
    PFFNode := FPFLF.GetNodeByFundName(AFundName);
    if PFFNode = nil then begin                                     // Add New fund to the FPFundsListForm
{$IFDEF FAFH}
      if PrivPresentMO(FPPrivs, 'b0') then begin
{$ENDIF}
      PFFNode := FPFLF.FundsTree.AddChild(nil);
      PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);
      PFFNodeData.name := AFundName;
      PFFNodeData.link := GetLinkOfFondByName(FundList, PFFNodeData.name);
      PFFNodeData.InAmnt  := 0;
      PFFNodeData.FPAmnt  := AVal;
      PFFNodeData.POAmnt  := 0;
{$IFDEF FAFH}
      end
{$ENDIF}
    end
    else begin
      PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);
      PFFNodeData.FPAmnt  := PFFNodeData.FPAmnt + AVal;
      PFFNodeData.IsInFP  := true;
    end
  end;
end;

procedure TFPAllocForm.InitFundsTree;
var
  k           : integer;
	PFFNodeData : PFFLData;
  PFFNode     : PVirtualNode;
begin
  FPFLF.FundsTree.Clear;
  for k := 0 to FFList.Count - 1 do begin
    PFFNode     := FPFLF.FundsTree.AddChild(nil);
    PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);

    PFFNodeData.name    := PVTResourceData(FFList[k]).name;
    PFFNodeData.link    := PVTResourceData(FFList[k]).link;
    PFFNodeData.InAmnt  := PVTResourceData(FFList[k]).balance;
    PFFNodeData.FPAmnt  := 0;
    PFFNodeData.POAmnt  := 0;
    PFFNodeData.IsInFP  := false;
  end;
end;

procedure TFPAllocForm.ClearFundsTree;
var
	PFFNodeData : PFFLData;
  PFFNode     : PVirtualNode;
begin
  SubZeroFundExists := false;
  if Assigned(FPFLF) then begin
    PFFNode := FPFLF.FundsTree.GetFirstChild(nil);
    while PFFNode <> nil do begin
      PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);
      PFFNodeData.FPAmnt  := 0;
      PFFNodeData.POAmnt  := 0;
      PFFNodeData.IsInFP  := false;
      PFFNode := FPFLF.FundsTree.GetNextSibling(PFFNode);
    end;
  end;
end;

procedure TFPAllocForm.SearchSubZeroFund;
var
	PFFNodeData  : PFFLData;
  PFFNode      : PVirtualNode;
  NodeToDelete : PVirtualNode;
begin
  SubZeroFundExists := false;
  if Assigned(FPFLF) then begin
    PFFNode := FPFLF.FundsTree.GetFirstChild(nil);
    while PFFNode <> nil do begin

      NodeToDelete := nil;

      PFFNodeData := FPFLF.FundsTree.GetNodeData(PFFNode);
      if (Round((PFFNodeData.InAmnt + PFFNodeData.FPAmnt - PFFNodeData.POAmnt) * 100) < 0) then begin
        SubZeroFundExists := true;
      end;
      PFFNode := FPFLF.FundsTree.GetNextSibling(PFFNode);
      if NodeToDelete <> nil then begin
        FPFLF.FundsTree.DeleteNode(NodeToDelete);
      end;
    end;
  end;
end;

Procedure TFPAllocForm.CreateParams(Var Params : TCreateParams);
Begin
  inherited CreateParams(Params);
  Params.ExStyle   := Params.ExStyle + WS_EX_APPWINDOW;
  Params.WndParent := 0;
End;

procedure TFPAllocForm.RecalcFundsRests;
var
	i 			: integer;
  j				: integer;
  k				: integer;
  PSum		: ^extended;
  TmpSum	: extended;
  TmpLink	: string;
begin
  FFromRecalc  := true;
  for i := 1 to StrGrid.RowCount - 1 do begin
    if (StrGrid.Cells[0, i] = 'h__') and (LeftStr(StrGrid.Cells[1, i], 2) = 'G.') then break;
  end;

  FundSums := TStringList.Create;
  FundSums.Clear;
  for j := 1 to i do begin
  	if (Pos('a1__', StrGrid.Cells[0, j])>0) or (StrGrid.Cells[0, j] = 'b__') or
       (StrGrid.Cells[0, j] = 'c__') or (StrGrid.Cells[0, j] = 'd__')        or
       (StrGrid.Cells[0, j] = 'e__') then begin
    	if (StrGrid.Cells[15, j] <> '') then begin
        TmpSum := 0;
        TryStrToFloat(MyCleanStr(StrGrid.Cells[13, j]), TmpSum);
        if Round(TmpSum * 100) = 0 then
        	continue;
      	TmpLink := GetLinkOfFondByName(FundList, StrGrid.Cells[15, j]);
        k := FundSums.IndexOf(TmpLink);
        if k < 0 then begin
        	New(PSum);
          PSum^ := TmpSum;
          FundSums.AddObject(TmpLink, pointer(PSum))
        end
        else begin
        	PSum := pointer(FundSums.Objects[k]);
          PSum^ := PSum^ + TmpSum;
        end;
      end;
    end; // if (StrGrid.Cells[0, j] = 'b__') or
    // POs
  	if (StrGrid.Cells[0, j] = 'f__')
      	then begin
    	if (StrGrid.Cells[11, j] <> '') then begin
        TmpSum := 0;
        TryStrToFloat(MyCleanStr(StrGrid.Cells[11, j]), TmpSum);
        if Round(TmpSum * 100) = 0 then
        	continue;
      	TmpLink := GetLinkOfFondByName(FundList, StrGrid.Cells[15, j]);
        k := FundSums.IndexOf(TmpLink);
        if k < 0 then begin
        	New(PSum);
          PSum^ := -TmpSum;
          FundSums.AddObject(TmpLink, pointer(PSum))
        end
        else begin
        	PSum  := pointer(FundSums.Objects[k]);
          PSum^ := PSum^ - TmpSum;
        end;
      end;
    end; // if (StrGrid.Cells[0, j] = 'b__') or
  end;

  for i := 0 to FromFondCombo.Items.Count - 1 do begin
  	for j := 0 to FundSums.Count - 1 do begin
    	if PVTResourceData(FromFondCombo.Items.Objects[i]).link = FundSums[j] then
      	break;
    end;
    if j < FundSums.Count then begin
      PSum := pointer(FundSums.Objects[j]);
      FromFondCombo.Items[i] := PVTResourceData(FromFondCombo.Items.Objects[i]).name +
                      ' (' + MyFloatToStr(PVTResourceData(FromFondCombo.Items.Objects[i]).balance + PSum^) + ')';
    	PVTResourceData(FromFondCombo.Items.Objects[i]).fp1sum := PSum^;
    end
    else begin
      FromFondCombo.Items[i] := PVTResourceData(FromFondCombo.Items.Objects[i]).name +
                      ' (' + MyFloatToStr(PVTResourceData(FromFondCombo.Items.Objects[i]).balance) + ')';
    end;
  end;

  FPFLF.FundsTree.SortTree(0, sdAscending);
  FPFLF.FundsTree.Invalidate;
  Application.ProcessMessages;

  FundSums.Free;
end;

procedure TFPAllocForm.SaveIncPlan;
Var
	Stream  : TMemoryStream;
begin
  Stream := TMemoryStream.Create;
//  Editor.Lines.SaveToStream(Stream);
	RVEditor.SaveRTFToStream(Stream, FALSE);
  FPMainDataset.SQL.Text := 'UPDATE ' + OrgPrefix + 'fp SET `plan`=:fData WHERE `index`=:fInd';
  FPMainDataset.ParamByName('fInd').AsInteger := FPNum;
  FPMainDataset.ParamByName('fData').LoadFromStream(Stream, ftBlob);
  try
    FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
	    Globalvars.ShowError(Self, 'При сохранении плана по доходу произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    end;
  end;
  Stream.Free;
end;

procedure TFPAllocForm.UpdateCursorPos;
var
  CharPos: TPoint;
begin
  Inc(CharPos.Y);
  Inc(CharPos.X);
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric; FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;

function TFPAllocForm.CurrText: TTextAttributes;
begin
(*
  if Editor.SelLength > 0 then
  	Result := Editor.SelAttributes
  else
//  	Result := Editor.DefAttributes;
  	Result := Editor.SelAttributes;
*)
end;

procedure TFPAllocForm.SelectionChange(Sender: TObject);
begin
(*
  with Editor.Paragraph do
  try
    FUpdating := True;
    BoldBtn.Down := fsBold in Editor.SelAttributes.Style;
    ItalicBtn.Down := fsItalic in Editor.SelAttributes.Style;
    UnderlineBtn.Down := fsUnderline in Editor.SelAttributes.Style;
    BulletsBtn.Down := Boolean(Numbering);
  	if Editor.SelAttributes.Size = 0 then
//	    FontSize.Text := IntToStr(Editor.SelAttributes.Size)
//    else begin
    	Editor.SelAttributes.Size := 8;
//    end;
    FontSize.Text := IntToStr(Editor.SelAttributes.Size);
    FontName.Text := Editor.SelAttributes.Name;
      LeftAlign.Down := false;
      RightAlign.Down := false;
      CenterAlign.Down := false;
    case Ord(Alignment) of
      0: LeftAlign.Down := True;
      1: RightAlign.Down := True;
      2: CenterAlign.Down := True;
    end;
    UpdateCursorPos;
  finally
    FUpdating := False;
  end;
*)
end;

procedure TFPAllocForm.btnBoldClick(Sender: TObject);
begin
  if FUpdating then Exit;
  RVEditor.ApplyStyleConversion(TEXT_BOLD);
end;

procedure TFPAllocForm.btnDelTblColumnClick(Sender: TObject);
var
  Item:         TCustomRVItemInfo;
  table:        TRVTableItemInfo;
  Data:         Integer;
  r, c, cs, rs: Integer;
  s:            String;
  rve:          TCustomRichViewEdit;
  ItemNo:       Integer;
begin
  if not RVEditor.CanChange or not RVEditor.GetCurrentItemEx(TRVTableItemInfo, rve, Item) then
    exit;
  table := TRVTableItemInfo(Item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);

  table.GetNormalizedSelectionBounds(True, r, c, cs, rs);
  if cs = table.Rows[0].Count then begin
  	// deleting the whole table
    rve.SetSelectionBounds(ItemNo, 0, ItemNo, 1);
    rve.DeleteSelection;
    exit;
  end;
  rve.BeginUndoGroup(rvutModifyItem);
  rve.SetUndoGroupMode(True);
  table.DeleteSelectedCols;
  // it's possible all-nil rows/cols appear after deleting
  table.DeleteEmptyRows;
  table.DeleteEmptyCols;
  rve.SetUndoGroupMode(False);

  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;

procedure TFPAllocForm.btnDelTblRowClick(Sender: TObject);
var
  Item:         TCustomRVItemInfo;
  table:        TRVTableItemInfo;
  Data:         Integer;
  r, c, cs, rs: Integer;
  s:            String;
  rve:          TCustomRichViewEdit;
  ItemNo:       Integer;
begin
  if not RVEditor.CanChange or not RVEditor.GetCurrentItemEx(TRVTableItemInfo, rve, Item) then
    exit;
  table := TRVTableItemInfo(Item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);

  table.GetNormalizedSelectionBounds(True, r, c, cs, rs);
  if rs = table.Rows.Count then begin
		// deleting the whole table
    rve.SetSelectionBounds(ItemNo, 0, ItemNo, 1);
    rve.DeleteSelection;
    exit;
  end;
  rve.BeginUndoGroup(rvutModifyItem);
  rve.SetUndoGroupMode(True);
  table.DeleteSelectedRows;
  // it's possible all-nil rows/cols appear after deleting
  table.DeleteEmptyRows;
  table.DeleteEmptyCols;
  rve.SetUndoGroupMode(False);

  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;

procedure TFPAllocForm.btnFontBackColorClick(Sender: TObject);
begin
	cd.Color := RVStyle.TextStyles[RVEditor.CurTextStyleNo].BackColor;
  if cd.Color = clNone then cd.Color := clWhite;
	if not cd.Execute then exit;
  RVEditor.ApplyStyleConversion(TEXT_BACKCOLOR);
end;

procedure TFPAllocForm.btnFontColorClick(Sender: TObject);
begin
  cd.Color := RVStyle.TextStyles[RVEditor.CurTextStyleNo].Color;
  if cd.Execute then
    RVEditor.ApplyStyleConversion(TEXT_COLOR);
end;

procedure TFPAllocForm.btnBulletsClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if (RVStyle.ListStyles.Count = 0) or (RVStyle.ListStyles[0].Levels.Count = 0) then begin
    Application.MessageBox('Default list style is not defined', '', 0);
    exit;
  end;
  RVEditor.ApplyListStyle(0, 0, 1, False, False);
end;

procedure TFPAllocForm.btnCopyClick(Sender: TObject);
begin
	RVEditor.CopyDef;
end;

procedure TFPAllocForm.btnCutClick(Sender: TObject);
begin
	RVEditor.CutDef;
end;

procedure TFPAllocForm.GetToolBarsWidths;
begin
	if tbFontWidth = 0 then
		tbFontWidth := tbFont.Width;
	if tbParaWidth = 0 then
	  tbParaWidth := tbPara.Width;
	if tbFileWidth = 0 then
  	tbFileWidth := tbFile.Width;
end;

procedure TFPAllocForm.SetToolBarsWidths;
begin
	tbFont.Width := tbFontWidth;
  tbPara.Width := tbParaWidth;
  tbFile.Width := tbFileWidth;
end;

procedure TFPAllocForm.cbMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	GetToolBarsWidths;
end;

procedure TFPAllocForm.cbMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetToolbarsWidths;
end;

procedure TFPAllocForm.btnAddTableClick(Sender: TObject);
var
  table: TRVTableItemInfo;
  r, c:  Integer;
  frmTableData : TTableDataForm;
begin

  frmTableData := TTableDataForm.Create(nil);
  if frmTableData.ShowModal <> mrOk then exit;
	r := frmTableData.spnRows.value;
	c := frmTableData.spnColumns.value;

  table := TRVTableItemInfo.CreateEx(r, c, RVEditor.RVData);

  table.BorderColor := $00A98E10;
  table.BorderStyle := rvtbRaisedColor;
  table.CellBorderStyle := rvtbLoweredColor;
  table.BorderLightColor := clBlack;
  table.BorderColor := clBlack;
  table.CellBorderLightColor := clBlack;
  table.CellBorderColor := clBlack;

  table.BorderWidth := 1;
  table.BorderVSpacing := 0;
  table.BorderHSpacing := 0;
  table.CellBorderWidth := 1;
  table.CellPadding := 3;
  table.CellVSpacing := 0;
  table.CellHSpacing := 0;

  if RVEditor.InsertItem('', table) then begin end;
end;

procedure TFPAllocForm.btnAddTblColumnClick(Sender: TObject);
var
  Item:         TCustomRVItemInfo;
  table:        TRVTableItemInfo;
  Data:         Integer;
  r, c, cs, rs: Integer;
  s:            String;
  rve:          TCustomRichViewEdit;
  ItemNo:       Integer;
begin
  if not RVEditor.CanChange or not RVEditor.GetCurrentItemEx(TRVTableItemInfo, rve, Item) then
    exit;
  table := TRVTableItemInfo(Item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);
  table.InsertColsLeft(1);

  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;

procedure TFPAllocForm.btnAddTblRowClick(Sender: TObject);
var
  Item:         TCustomRVItemInfo;
  table:        TRVTableItemInfo;
  Data:         Integer;
  r, c, cs, rs: Integer;
  s:            String;
  rve:          TCustomRichViewEdit;
  ItemNo:       Integer;
begin
  if not RVEditor.CanChange or not RVEditor.GetCurrentItemEx(TRVTableItemInfo, rve, Item) then
    exit;
  table := TRVTableItemInfo(Item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);
  table.InsertRowsAbove(1);

  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;

procedure TFPAllocForm.btnAlignCenterClick(Sender: TObject);
begin
  if FUpdating then Exit;
	RVEditor.ApplyParaStyleConversion(PARA_ALIGNCENTER);
end;

procedure TFPAllocForm.btnAlignJustClick(Sender: TObject);
begin
  if FUpdating then Exit;
	RVEditor.ApplyParaStyleConversion(PARA_ALIGNJUST);
end;

procedure TFPAllocForm.btnClearIncPlanClick(Sender: TObject);
begin
  if RVEditor.ReadOnly then Exit;
  RVEditor.LeftMargin := 5;
  RVEditor.RightMargin := 5;
	RVEditor.TopMargin := 5;
  RVEditor.BottomMargin := 5;
  RVEditor.BackgroundBitmap := nil;
  RVEditor.BackgroundStyle := bsNoBitmap;
  RVEditor.Clear;
  RVEditor.DeleteUnusedStyles(True, True, True);
  RVEditor.Format;
  // you can delete non default styles here...
  RVEditorCurTextStyleChanged(nil);
  RVEditorCurParaStyleChanged(nil);

end;

procedure TFPAllocForm.CMDialogKey(var Msg: TWMKEY);
begin
//  if not ((ActiveControl is TEdit) or (Msg.Charcode = VK_TAB)) then
//  if not ((Msg.Charcode = VK_TAB)) then
    inherited;
end;

procedure TFPAllocForm.IncPlanButtonClick(Sender: TObject);
begin
	if IncPlanButton.Down then begin
  	PlanPanel.Visible := true;
    Splitter.Visible	:= true;
	end
	else begin
		Splitter.Visible	:= false;
		PlanPanel.Visible := false;
	end;
  HorSplitToolButton.Enabled := IncPlanButton.Down;
  IniFile.WriteInteger('fp', 'IncPlanIsDown', integer(IncPlanButton.Down));
end;

Procedure TFPAllocForm.InitArcDB;
var
  StrBegin  : string;
  i, j      : integer;
  AssList     : TList;
  RecList     : TList;
  IncData     : PIncData;
  TotalA      : extended;
  TotalA1     : extended;
  TotalB      : extended;
  TotalC      : extended;
  TotalD      : extended;
  TotalE      : extended;
  TotalF      : extended;
  CGI         : extended;
  GI1         : extended;
  TmpSum      : extended;
  FPBalanceC  : extended;
  FPBalanceD  : extended;
  FPBalanceF  : extended;
  TmpVal      : extended;
  Stream      : TMemoryStream;
  FP1RSUM      : extended;
  FP1PSUM      : extended;
begin
  if Assigned(FPFLF) then
    FPFLF.Close;

	PrintingIsIP	:= true;
  FPWasChanged := false;
  SaveToolButton.Enabled := FPWasChanged;

  FPMainDataset.SQL.Text := 'SELECT Abbr FROM orgs WHERE Prefix=:fPrefix';
  FPMainDataset.ParamByName('fPrefix').AsString := OrgPrefix;
  try
    FPMainDataset.Open;
  except
 	  on e: EZSQLException do begin
	    Globalvars.ShowError(Self, 'Невозможно получить название организации.', e.ErrorCode, e.StatusCode, e.Message);
    end;
  end;
  OrgShortName := Trim(FPMainDataset.FieldByName('Abbr').AsAnsiString);
  Caption:= '"' + OrgShortName + '" — финансовое планирование: с';
  if not ReadOnly then begin
  	SaveToolButton.Visible 		:= true;
    ApproveToolButton.Visible := true;
    RowAddToolButton.Visible	:= true;
    RowDelToolButton.Visible	:= true;
	  SaveToolButton.Visible    := PrivPresentMO(FPPrivs, 'boqs');
  	ApproveToolButton.Visible := PrivPresentMO(FPPrivs, 'bs');
  end
  else begin
  	SaveToolButton.Visible 		:= false;
    ApproveToolButton.Visible := false;
    RowAddToolButton.Visible	:= false;
    RowDelToolButton.Visible	:= false;
    FundsTableButton.Visible  := false;
  end;

  TmpFundCombo := TComboBox.Create(nil);
  TmpFundCombo.Parent := Self;
  TmpFundCombo.Visible := false;

  FromFondCombo := TComboBox.Create(nil);
  FromFondCombo.Parent := Self;
  FromFondCombo.Visible := false;

  ApproveCombo := TComboBox.Create(nil);
  ApproveCombo.Parent   := Self;
  ApproveCombo.Visible  := false;
  ApproveCombo.Clear;
  ApproveCombo.Items.Add('Отложить');
  ApproveCombo.Items.Add('Отклонить');
  ApproveCombo.Items.Add('Одобрить');


  width := 1040;
  height := screen.Height - 50;
  left := (Screen.Width - Width) div 2;
  top := 5;

	fplink		:= OrgPrefix + 'fp';
	lfplink		:= OrgPrefix + 'lfp';
  cashlink	:= OrgPrefix + CASH_LINK;
  bill1link	:= OrgPrefix + BILL1_LINK;
  polink		:= OrgPrefix + 'po';


  FundList := TList.Create;
  FundList := CompFondList(OrgPrefix + 'fond',  0, CFL_IGNOREGROUPS, CFL_CONSIDERPOS, OrgPrefix, true, AF_SHOWALLFUNDS);

  AssList := TList.Create;
  AssList  := CompFondList(OrgPRefix + 'asset', 0, CFL_WITHGROUPS,   CFL_IGNOREPOS, OrgPRefix);

// pulling the IncomePlan
  Stream := TMemoryStream.Create;
  FPMainDataset.SQL.Text := 'SELECT`plan`FROM ' + OrgPRefix + 'fp WHERE`index`=' + IntToStr(FPNum);
  try
  	FPMainDataset.Open;
  	Stream.LoadFromStream(FPMainDataset.CreateBlobStream(FPMainDataset.FieldByName('plan'), bmRead));
	  RVEditor.Clear;
  	RVEditor.DeleteUnusedStyles(True, True, True);
    RVEditor.LoadRTFFromStream(Stream);
	  RVEditor.Format;
  except
    on e: EZSQLException do begin
		  Globalvars.ShowError(Self, 'Невозможно загрузить план по доходу.', e.ErrorCode, e.StatusCode, e.Message);
    end;
  end;
  Stream.Free;

  // set up buttons in the Income plan toolbars
  RVEditor.ReadOnly := false;
  tbEdit.Enabled := not RVEditor.ReadOnly;
  tbTable.Enabled := not RVEditor.ReadOnly;
  tbPara.Enabled := not RVEditor.ReadOnly;
  tbFont.Enabled := not RVEditor.ReadOnly;
  btnSaveIncPlan.Enabled := not RVEditor.ReadOnly;
  btnClearIncPlan.Enabled := not RVEditor.ReadOnly;

  FPMainDataset.SQL.Text := 'SELECT`from`,`to`FROM ' + fplink + ' WHERE`index`=' + IntToStr(FPNum);
  FPMainDataset.Open;
  FromDate := FPMainDataset.FieldByName('from').AsDateTime;
  ToDate   := FPMainDataset.FieldByName('to').AsDateTime;
  FromDateS := DateTimeToStr(FromDate);
  ToDateS   := DateTimeToStr(ToDate);

  Caption := Caption + ' ' + FromDateS + ' по ' + ToDateS;


  StrGrid.Visible := true;
  StrGrid.Options := StrGrid.Options - [goRowSelect];

  StrGrid.Align   := alClient;
  StrGrid.ColCount := 17;
  i := 65;

  StrGrid.FixedRows	:= 1;

  StrGrid.ColWidths[0] := 0;
  StrGrid.ColWidths[1] := 30;
  for j := 2 to StrGrid.ColCount - 1 do
  	StrGrid.ColWidths[j] := ReadColWidth('FP', j, i);
  i := 1;

  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'А. Поступления';
  Inc(i);

  // headline A
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 2, 1);
  StrGrid.Cells[2, i] := 'Сумма';
  StrGrid.MergeCells(4, i, 8, 1);
  StrGrid.Cells[4, i] := 'Описание';
  StrGrid.MergeCells(12, i, 3, 1);
  StrGrid.Cells[12, i] := 'Дата/время';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Куда поступили';
  Inc(i);

  RecList     := TList.Create;

  TotalA := 0;
  FromFondCombo.Clear;
  TmpFundCombo.Clear;

  for j := 0 to FundList.Count - 1 do begin
    TmpFundCombo.Items.Add(PVTResourceData(FundList[j]).name);
    FromFondCombo.Items.AddObject(PVTResourceData(FundList[j]).name, TObject(FundList[j]));
  end;

	FPMainDataset.SQL.Text :=
          '(SELECT`lastdate`,`data`,CAST(`in`AS DECIMAL(25,2))as`in`,`link`,"' + cashlink + '"as`src`FROM  ' + cashlink + ' '+
          'WHERE`lastdate`>:ffd AND `lastdate`<=:ftd AND`in`<>0 AND`link`IN("' + OrgPrefix + BILL1_LINK + '","frombank","' + OrgPrefix + CASH_LINK + '","specinc"))';
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' union';
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text +
          '(SELECT`lastdate`,`data`,CAST(`in`AS DECIMAL(25,2))as`in`,`link`,"' + bill1link + '"as`src`FROM  '+ bill1link + ' '+
          'WHERE`lastdate`>:ffd AND `lastdate`<=:ftd AND`in`<>0 AND`link`IN("' + OrgPrefix + BILL1_LINK + '","frombank","' + OrgPrefix + CASH_LINK + '","specinc"))';
  if FPMainDataset.SQL.Text <> '' then
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY `lastdate`';

  FPMainDataset.ParamByName('ffd').AsDateTime := FromDate;
  FPMainDataset.ParamByName('ftd').AsDateTime := ToDate;

  FPMainDataset.Open;

  j := 0;
  while not FPMainDataset.Eof do begin
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'a__';
    StrGrid.Cells[1, i] := IntToStr(j+1);
    StrGrid.MergeCells(2, i, 2, 1);
    StrGrid.Cells[2, i] := MyFloatToStr(FPMainDataset.FieldByName('in').AsExtended); //.AsFloat);
    StrGrid.MergeCells(4, i, 8, 1);
    StrGrid.Cells[4, i] := Trim(FPMainDataset.FieldByName('data').AsAnsiString);
    StrGrid.MergeCells(12, i, 3, 1);

		StrGrid.Cells[12, i] := DateTimeToStr(FPMainDataset.FieldByName('lastdate').AsDateTime, FormatString);

    StrGrid.MergeCells(15, i, 2, 1);
    StrGrid.Cells[15, i] := GetNameOfFondByLink(AssList, Trim(FPMainDataset.FieldByName('src').AsAnsiString));
    inc(j);
    Inc(i);
    FPMainDataset.Next;
  end;

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a GI string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'tgi__';
  TGIStrNum           := i;
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Общий валовый доход:';
  StrGrid.MergeCells(4, i, 2, 1);
  StrGrid.Cells[4, i] := MyFloatToStr(TotalA);
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  TotalA1 := 0;
  // populating section A1  - special income
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'A1. Спецдоход';
  Inc(i);

  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 9, 1);
  StrGrid.Cells[2, i] := 'Наименование';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := '%';
  StrGrid.MergeCells(13, i, 2, 1);
  StrGrid.Cells[13, i] := 'Сумма';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Фонд';
  Inc(i);

  FPMainDataset.Close;

  // pulling data from income itself
  FPMainDataset.SQL.Text := '';
  for j := 0 to AssList.Count - 1 do begin
    if PVTResourceData(AssList.Items[j]).link = 'debitors' then break;
    if PVTResourceData(AssList.Items[j]).link = '' then continue;

    if FPMainDataset.SQL.Text <> '' then
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' union';
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text +
        	'(SELECT`index`,`lastdate`,`data`,`in`,"' + PVTResourceData(AssList.Items[j]).link + '" as`link`FROM ' + PVTResourceData(AssList.Items[j]).link +
          ' WHERE`lastdate`>:ffd AND`lastdate`<=:ftd AND`in`>0 AND`link`="specinc")';
  end;
  FPMainDataset.ParamByName('ffd').AsDateTime := FromDate;
  FPMainDataset.ParamByName('ftd').AsDateTime := ToDate;

  FPMainDataset.Open;

  j := 0;
  TotalA1  := 0;
  while not FPMainDataset.Eof do begin
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'a1__'+ FPMainDataset.FieldByName('link').AsString + '_'+
    FPMainDataset.FieldByName('index').AsString;
    Inc(j);
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 9, 1);
    StrGrid.Cells[2, i] := MyCleanStr(FPMainDataset.FieldByName('data').AsAnsiString, false); //'Наименование';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] :=  '';
    StrGrid.MergeCells(13, i, 2, 1);
		TmpVal := FPMainDataset.FieldByName('in').AsFloat;
    TotalA1  := TotalA1 + TmpVal;
    StrGrid.Cells[13, i] := MyFloatToStr(TmpVal); //'К выплате';
    StrGrid.MergeCells(15, i, 2, 1);
//        FPTmpDataset.SQL.Text := 'SELECT `6` FROM lfp WHERE `5`=:fCode';
    FPTmpDataset.SQL.Text := 'SELECT`6`FROM ' + lfplink + ' WHERE`5`=:fCode';

    FPTmpDataset.ParamByName('fCode').AsString := FPMainDataset.FieldByName('link').AsString + '_'+
                                FPMainDataset.FieldByName('index').AsString;
    FPTmpDataset.Open;
    if (FPTmpDataset.RecordCount > 0) and (FPTmpDataset.FieldByName('6').AsString <> '') then begin
      StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPTmpDataset.FieldByName('6').AsString);
    end
    else begin
  	  StrGrid.Cells[15, i] := '';
    end;
    Inc(i);
    FPMainDataset.Next;
  end;

  // pulling special income data set manually
	FPMainDataset.SQL.Text := 'SELECT * FROM '+ fplink + IntToStr(FPNum) + ' WHERE`1`="a1" AND`2`IS NOT NULL';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'a1__';
    Inc(j); //j := FPMainDataset.FieldByName('index').AsInteger;
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 9, 1);
    StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString; //'Наименование';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] :=  FPMainDataset.FieldByName('4').AsString; //'Формула';
    StrGrid.MergeCells(13, i, 2, 1);
    if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','), TmpSum) then begin
      TryStrToFloat(ReplaceStr(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','), ThSep, ''), TmpVal);
      TotalA1  := TotalA1 + TmpVal; //StrToFloat(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','));
      StrGrid.Cells[13, i] := MyFloatToStr(TmpVal); //'К выплате';
    end
    else begin
      StrGrid.Cells[13, i] := '';
    end;
    StrGrid.MergeCells(15, i, 2, 1);
    if (FPMainDataset.FieldByName('6').AsString <> '') and (FPMainDataset.FieldByName('6').AsString <> '0') then begin
          StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('6').AsString)
    end
    else if (FundList.Count >0) and (FPMainDataset.FieldByName('6').AsString <> '0') then begin
          StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
    end
    else begin
          StrGrid.Cells[15, i] := '';
    end;
    Inc(i);
    FPMainDataset.Next;
  end;

  // Showing the amount for section A1
  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding the  total for section A1
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'a1t__';
  StrGrid.MergeCells(1, i, 8, 1);
  StrGrid.Cells[1, i] := '';
  StrGrid.MergeCells(9, i, 2, 1);
  StrGrid.Cells[9, i] := 'Итого:';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := MyFloatToStr(TotalA1);
  StrGrid.MergeCells(13, i, 4, 1);
  StrGrid.Cells[13, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a CGI string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'gi__';
  GIStrNum						:= i;
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Валовый доход:';
  StrGrid.MergeCells(4, i, 2, 1);
  GI1 := TotalA - TotalA1;
  StrGrid.Cells[4, i] := MyFloatToStr(GI1);
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // populating section B  - taxes, royalties etc
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'B. Фонды управления';
  Inc(i);

// new version with FP1 percents
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 7, 1);
  StrGrid.Cells[2, i] := 'Наименование';
  StrGrid.Cells[9, i] := '%(ФП №1)';
  StrGrid.MergeCells(10, i, 2, 1);
  StrGrid.Cells[10, i] := 'По ФП №1';
  StrGrid.Cells[12, i] := '%';
  StrGrid.MergeCells(13, i, 2, 1);
  StrGrid.Cells[13, i] := 'Сумма';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Фонд';
  Inc(i);

	FPMainDataset.SQL.Text := 'SELECT * FROM ' + fplink + IntToStr(FPNum) + ' WHERE`1`="B"';
{$IFDEF SFIAF}
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY`2`';
{$ENDIF}
  FPMainDataset.Open;
  j := 0;
  TotalB  := 0;
  while not FPMainDataset.Eof do begin
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'b__';
    Inc(j);
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 7, 1);
    StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString; //'Наименование';
  	// new version - with FP1%s
    if FPMainDataset.FieldByName('6').AsString <> '0' then begin
      FPTmpDataset.SQL.Text := 'SELECT ' + OrgPRefix + 'fp1funddata.* from ' + OrgPRefix + 'fp1funddata JOIN ' + OrgPRefix + 'fond ON ' + OrgPRefix + 'fp1funddata.fid=' + OrgPRefix + 'fond.`index` WHERE ' + OrgPRefix + 'fond.link=:fLink AND since<NOW() ORDER BY since DESC LIMIT 1';
      FPTmpDataset.ParamByName('fLink').AsString := FPMainDataset.FieldByName('6').AsString;
      try
        FPTmpDataset.Open;
      except
 				on e: EZSQLException do begin
	  			Globalvars.ShowError(Self, 'Невозможно получить данные об ФП №1.', e.ErrorCode, e.StatusCode, e.Message);
        	Close;
        end;
      end;

      if FPTmpDataset.RecordCount > 0 then begin
        StrGrid.Cells[ 9, i] := MyFloatToStr(FPTmpDataset.FieldByName('pct').AsExtended);    //'% по ФП №1';
      end
      else
        StrGrid.Cells[ 9, i] := '';    //'% по ФП №1';
      StrGrid.MergeCells(10, i, 2, 1);                                                     //'По ФП №1';
      if FPTmpDataset.RecordCount > 0 then begin
        StrGrid.Cells[10, i] := MyFloatToStr(FPTmpDataset.FieldByName('amount').AsExtended);
      end
      else begin
        StrGrid.Cells[10, i] := '';
      end;
    end
    else begin
      StrGrid.Cells[ 9, i] := '';                                        //'% по ФП №1';
      StrGrid.MergeCells(10, i, 2, 1);                                  //'По ФП №1'
  		StrGrid.Cells[10, i] := '';
    end;
    // FP1 Data - percent and amount - end of

    StrGrid.Cells[12, i] :=  FPMainDataset.FieldByName('4').AsString; //'%'
  	// new version - with FP1%s - end of

    StrGrid.MergeCells(13, i, 2, 1);
    if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','), TmpSum) then begin
      TryStrToFloat(ReplaceStr(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','), ThSep, ''), TmpVal);
      TotalB  := TotalB + TmpVal;
      StrGrid.Cells[13, i] := MyFloatToStr(TmpVal); //'К выплате';
    end
    else begin
          StrGrid.Cells[13, i] := '';
    end;
    StrGrid.MergeCells(15, i, 2, 1);
    if (FPMainDataset.FieldByName('6').AsString <> '') and (FPMainDataset.FieldByName('6').AsString <> '0') then begin
          StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('6').AsString)
    end
    else if (FundList.Count >0) and (FPMainDataset.FieldByName('6').AsString <> '0') then begin
          StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
    end
    else begin
          StrGrid.Cells[15, i] := '';
    end;
    Inc(i);
    FPMainDataset.Next;
  end;

  // Showing the amount for section B
  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding the  total for section B
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'bt__';
  StrGrid.MergeCells(1, i, 8, 1);
  StrGrid.Cells[1, i] := '';
  StrGrid.MergeCells(9, i, 2, 1);
  StrGrid.Cells[9, i] := 'Итого:';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := MyFloatToStr(TotalB);
  StrGrid.MergeCells(13, i, 4, 1);
  StrGrid.Cells[13, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a CGI string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'b_cgi__';
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'К распределению:';
  StrGrid.MergeCells(4, i, 2, 1);
  CGI := TotalA - TotalB;
  StrGrid.Cells[4, i] := MyFloatToStr(CGI);
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Section C - funds etc
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'С. Фонды организации';
  Inc(i);

  // headline C
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 7, 1);
  StrGrid.Cells[2, i] := 'Наименование';
  StrGrid.Cells[9, i] := '% (ФП №1)'; //RightAlign
  StrGrid.MergeCells(10, i, 2, 1);
  StrGrid.Cells[10, i] := 'По ФП №1'; //RightAlign
  StrGrid.Cells[12, i] := '%';				//RightAlign
  StrGrid.MergeCells(13, i, 2, 1);		//RightAlign
  StrGrid.Cells[13, i] := 'Сумма';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Фонд';
  Inc(i);

  FPMainDataset.SQL.Text := 'SELECT * FROM ' + fplink + IntToStr(FPNum) + ' WHERE`1`="C"';
{$IFDEF SFIAF}
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY`2`';
{$ENDIF}
  j := 0;
  FP1PSUM := 0;
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'c__';
    Inc(j);
    StrGrid.Cells[1, i] := IntToStr(j);
		StrGrid.MergeCells(2, i, 7, 1);
    StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString; //'Наименование';

    // FP1 Data - percent and amount
    if FPMainDataset.FieldByName('5').AsString <> '0' then begin
      FPTmpDataset.SQL.Text := 'SELECT ' + OrgPRefix + 'fp1funddata.* from ' + OrgPRefix + 'fp1funddata JOIN ' + OrgPRefix + 'fond ON ' + OrgPRefix + 'fp1funddata.fid=' + OrgPRefix + 'fond.`index` WHERE ' + OrgPRefix + 'fond.link=:fLink AND since<NOW() ORDER BY since DESC LIMIT 1';
      FPTmpDataset.ParamByName('fLink').AsString := FPMainDataset.FieldByName('5').AsString;
      try
        FPTmpDataset.Open;
      except
 				on e: EZSQLException do begin
	  			Globalvars.ShowError(Self, 'Невозможно получить данные об ФП №1.', e.ErrorCode, e.StatusCode, e.Message);
        	Close;
        end;
      end;

      if FPTmpDataset.RecordCount > 0 then begin
        StrGrid.Cells[ 9, i] := MyFloatToStr(FPTmpDataset.FieldByName('pct').AsExtended);    //'% по ФП №1';
      end
      else
        StrGrid.Cells[ 9, i] := '';    //'% по ФП №1';
      StrGrid.MergeCells(10, i, 2, 1);                                                     //'По ФП №1';
      if FPTmpDataset.RecordCount > 0 then begin
        StrGrid.Cells[10, i] := MyFloatToStr(FPTmpDataset.FieldByName('amount').AsExtended);
        FP1PSUM := FP1PSUM + FPTmpDataset.FieldByName('amount').AsExtended;
      end
      else begin
        StrGrid.Cells[10, i] := '';
      end;
    end
    else begin
      StrGrid.Cells[ 9, i] := '';                                        //'% по ФП №1';
      StrGrid.MergeCells(10, i, 2, 1);                                  //'По ФП №1'
  		StrGrid.Cells[10, i] := '';
    end;
    // FP1 Data - percent and amount - end of
    StrGrid.Cells[12, i] :=  FPMainDataset.FieldByName('3').AsString; //'%'
    StrGrid.MergeCells(13, i, 2, 1);                  							//'Сумма';
		if FPMainDataset.FieldByName('4').AsString<>'' then begin
    	if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('4').AsString, '.', ','), TmpVal) then begin
        FP1RSUM := FP1RSUM + TmpVal;
        StrGrid.Cells[13, i] := MyFloatToStr(TmpVal);
      end
      else
      	StrGrid.Cells[13, i] := FPMainDataset.FieldByName('4').AsString
    end
    else
    	StrGrid.Cells[13, i] :=  '';

    StrGrid.MergeCells(15, i, 2, 1);
    if (FPMainDataset.FieldByName('5').AsString <> '') and (FPMainDataset.FieldByName('5').AsString <> '0') then begin
          StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('5').AsString)
    end
    else if (FundList.Count > 0) and (FPMainDataset.FieldByName('5').AsString <> '0') then begin
          StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
    end
    else begin
          StrGrid.Cells[15, i] := '';
    end;
    Inc(i);
    FPMainDataset.Next;
  end;

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding the  total for section C
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'ct__';
  StrGrid.MergeCells(1, i, 8, 1);
  StrGrid.Cells[1, i] := '';
  StrGrid.MergeCells(9, i, 2, 1);
  StrGrid.Cells[9, i] := 'Итого:';
  StrGrid.MergeCells(11, i, 2, 1);
  FPBalanceC := CGI - TotalC;
  StrGrid.Cells[11, i] := MyFloatToStr(TotalC); //'Сумма';
  StrGrid.MergeCells(13, i, 4, 1);
  StrGrid.Cells[13, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

	// Adding the FP1 balance line
	StrGrid.SplitRowCells(i);
	StrGrid.Cells[0, i] := 'fp1t__';
	StrGrid.MergeCells(1, i, 9, 1);
	StrGrid.Cells[1, i] := 'Итого по ФП №1';
	StrGrid.MergeCells(10, i, 2, 1);
	StrGrid.Cells[10, i] := MyFloatToStr(FP1PSUM);
	StrGrid.Cells[12, i] := '';
	StrGrid.MergeCells(13, i, 2, 1);
	StrGrid.Cells[13, i] := MyFloatToStr(FP1RSUM);
	StrGrid.MergeCells(15, i, 2, 1);
	StrGrid.Cells[15, i] := '';
	Inc(i);

	// Adding an empty string
	StrGrid.SplitRowCells(i);
	StrGrid.MergeCells(1, i, 16, 1);
	StrGrid.Cells[1, i] := '';
	Inc(i);

  // Adding a FP balance string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'c_cgi__';
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Баланс ФП:';
  StrGrid.MergeCells(4, i, 2, 1);
  StrGrid.Cells[4, i] := MyFloatToStr(FPBalanceC);
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Section D
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
//  StrGrid.Cells[1, i] := 'D. Обязательные выплаты';
  StrGrid.Cells[1, i] := 'D. Фиксированные обязательные платежи';
  Inc(i);

  // headline D
	StrGrid.SplitRowCells(i);
	StrGrid.Cells[0, i] := 's__';
	StrGrid.Cells[1, i] := '№';
	StrGrid.MergeCells(2, i, 5, 1);
	StrGrid.Cells[2, i] := 'Наименование';
	StrGrid.MergeCells(7, i, 3, 1);
	StrGrid.Cells[7, i] := 'По ФП №1';
	StrGrid.MergeCells(10, i, 3, 1);
	StrGrid.Cells[10, i] := 'Примечание';
	StrGrid.MergeCells(13, i, 2, 1);
	StrGrid.Cells[13, i] := 'Сумма';
	StrGrid.MergeCells(15, i, 2, 1);
	StrGrid.Cells[15, i] := 'Фонд';
	Inc(i);

  FPMainDataset.SQL.Text := 'SELECT * FROM ' + fplink + IntToStr(FPNum) + ' WHERE`1`="D"';
  FPMainDataset.Open;
  j := 0;
  while not FPMainDataset.Eof do begin
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'd__';
    j := FPMainDataset.FieldByName('index').AsInteger;
    StrGrid.Cells[1, i] := IntToStr(j);

  	// FP colum added
      StrGrid.MergeCells(2, i, 5, 1);                                 //'Наименование'
      StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString;
		  StrGrid.MergeCells(7, i, 3, 1); 																//'По ФП №1'
			if TryStrToFloat(ReplaceStr(ReplaceStr(FPMainDataset.FieldByName('6').AsString, '.', ','), ThSep, ''), TmpVal) then
        StrGrid.Cells[7, i] := MyFloatToStr(TmpVal)
    	else
	    	StrGrid.Cells[7, i] := '';
      StrGrid.MergeCells(10, i, 3, 1);                                // Примечание
      StrGrid.Cells[10, i] := FPMainDataset.FieldByName('3').AsString;
      StrGrid.MergeCells(13, i, 2, 1);                                //'Сумма'
      if FPMainDataset.FieldByName('4').AsString <>'' then begin
      	if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('4').AsString, '.', ','), TmpSum) then begin
        	TotalD  := TotalD + TmpSum;
          StrGrid.Cells[13, i] := MyFloatToStr(TmpSum);
        end
        else
        	StrGrid.Cells[13, i] := FPMainDataset.FieldByName('4').AsString
      end
      else
      	StrGrid.Cells[13, i] :=  '';
    // fp column added - end of
    StrGrid.MergeCells(15, i, 2, 1);
    if (FPMainDataset.FieldByName('5').AsString <> '') and (FPMainDataset.FieldByName('5').AsString <> '0') then begin
          StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('5').AsString)
    end
    else if (FundList.Count > 0) and (FPMainDataset.FieldByName('5').AsString <> '0') then begin
      StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
    end
    else begin
      StrGrid.Cells[15, i] := '';
    end;
    Inc(i);

    FPMainDataset.Next;
  end;

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding the  total for section D
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'dt__';
  StrGrid.MergeCells(1, i, 8, 1);
  StrGrid.Cells[1, i] := '';
  StrGrid.MergeCells(9, i, 2, 1);
  StrGrid.Cells[9, i] := 'Итого:';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := MyFloatToStr(TotalD); //'Сумма';
  StrGrid.MergeCells(13, i, 4, 1);
  StrGrid.Cells[13, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a FP balance string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'd_cgi__';
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Баланс ФП:';
  StrGrid.MergeCells(4, i, 2, 1);
  FPBalanceD := FPBalanceC - TotalD;
  StrGrid.Cells[4, i] := MyFloatToStr(FPBalanceD);
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Section F (now section E)
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'E. Заявки';
  Inc(i);

  // headline F (now section E)
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 2, 1);
  StrGrid.Cells[2, i] := 'Дата';
  StrGrid.MergeCells(4, i, 3, 1);
  StrGrid.Cells[4, i] := 'Тема';
  StrGrid.MergeCells(7, i, 2, 1);
  StrGrid.Cells[7, i] := 'Сумма заявки';
  StrGrid.MergeCells(9, i, 2, 1);
  StrGrid.Cells[9, i] := 'Решение';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := 'Одобрить';
  StrGrid.MergeCells(13, i, 2, 1);
  StrGrid.Cells[13, i] := 'Пояснение';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Источник';
  Inc(i);

	POList   := TStringList.Create;
	POrList  := TStringList.Create;

  FPMainDataset.SQL.Text := 'SELECT * FROM ' + fplink + IntToStr(FPNum) + ' WHERE`1`="F"';
  FPMainDataset.Open;
  j := 0;
  while not FPMainDataset.Eof do begin
	  FPTmpDataset.SQL.Text := 'SELECT * FROM ' + polink + ' WHERE`index`=' + FPMainDataset.FieldByName('index').AsString;
    FPTmpDataset.Open;
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[ 0, i] := 'f__';
    j := FPMainDataset.FieldByName('index').AsInteger;
    POList.AddObject( IntToStr(j), pointer(FPTmpDataset.FieldByName('bycash').AsInteger));
    POrList.AddObject(IntToStr(j), pointer(FPTmpDataset.FieldByName('bycash').AsInteger));

    StrGrid.Cells[ 1, i] := IntToStr(j);

    StrGrid.MergeCells(2, i, 2, 1);
	  StrGrid.Cells[ 2, i] := DateTimeToStr(FPTmpDataset.FieldByName('date').AsDateTime, FormatString);

    StrGrid.MergeCells(4, i, 3, 1);
    StrGrid.Cells[ 4, i] := Trim(FPTmpDataset.FieldByName('re').AsAnsiString);

    StrGrid.MergeCells(7, i, 2, 1);
    StrGrid.Cells[ 7, i] := MyFloatToStr(FPTmpDataset.FieldByName('sumr').AsFloat); //'Сумма';

    StrGrid.MergeCells( 9, i, 2, 1);
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.MergeCells(13, i, 2, 1);
    StrGrid.MergeCells(15, i, 2, 1);
    if not FPTmpDataset.Eof then begin
      StrGrid.Cells[ 9, i] := ApproveCombo.Items[FPMainDataset.FieldByName('3').AsInteger];  //'Отложить';
      if FPMainDataset.FieldByName('2').AsString <> '' then begin
	      TryStrToFloat(ReplaceStr(ReplaceStr(FPMainDataset.FieldByName('2').AsString, '.', ','), ThSep, ''), TmpVal);
        StrGrid.Cells[11, i] := MyFloatToStr(TmpVal); // Одобрить
      end
      else begin
            StrGrid.Cells[11, i] := '';
      end;
      StrGrid.Cells[13, i] := FPMainDataset.FieldByName('4').AsString;                       // Пояснение
      if FPMainDataset.FieldByName('3').AsInteger = 2 then begin
            StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('5').AsString)// Источник
      end
      else begin
            StrGrid.Cells[15, i] := '';// Источник
      end
    end
    else begin
      StrGrid.Cells[ 9, i] := ApproveCombo.Items[0];                                      //'Отложить';
      StrGrid.Cells[11, i] := '';                                                         // Одобрить
      StrGrid.Cells[13, i] := '';                                                         // Пояснение
      StrGrid.Cells[15, i] := '';                                                         // Источник
    end;
    Inc(i);
    FPMainDataset.Next;
  end;
  POList.Sort;
  POrList.Sort;

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding the total for section F
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[ 0, i] := 'ftwf__';
  StrGrid.MergeCells( 1, i, 7, 1);
  StrGrid.Cells[ 1, i] := '';
  StrGrid.MergeCells( 8, i, 3, 1);
  StrGrid.Cells[ 8, i] := 'Итого:';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := '0,00';
  StrGrid.MergeCells(13, i, 4, 1);
  StrGrid.Cells[13, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a FP balance string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'ft__';
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Баланс ФП:';
  StrGrid.MergeCells(4, i, 2, 1);
  StrGrid.Cells[4, i] := '';
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Section F (used to be section E)
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'F. Нераспределённые средства';
  Inc(i);

  // headline E
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 9, 1);
  StrGrid.Cells[2, i] := 'Наименование';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := '%';
  StrGrid.MergeCells(13, i, 2, 1);
  StrGrid.Cells[13, i] := 'Сумма';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Фонд';
  Inc(i);

  FPMainDataset.SQL.Text := 'SELECT * FROM ' + fplink + IntToStr(FPNum) + ' WHERE`1`="E"';
  FPMainDataset.Open;
  j := 0;
  while not FPMainDataset.Eof do begin
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'e__';
    j := FPMainDataset.FieldByName('index').AsInteger;
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 9, 1);
    StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString;
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] := FPMainDataset.FieldByName('3').AsString;
    StrGrid.MergeCells(13, i, 2, 1);
    if FPMainDataset.FieldByName('4').AsString <>'' then begin
      if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('4').AsString, '.', ','), TmpSum) then begin
        StrGrid.Cells[13, i] := MyFloatToStr(TmpSum); //'Сумма';
      end
      else begin
        StrGrid.Cells[13, i] := FPMainDataset.FieldByName('4').AsString
      end
    end
    else begin
      StrGrid.Cells[13, i] :=  ''; //'Сумма';
    end;

    StrGrid.MergeCells(15, i, 2, 1);
    if (FPMainDataset.FieldByName('5').AsString <> '') and (FPMainDataset.FieldByName('5').AsString <> '0') then begin
      StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('5').AsString)
    end
    else if (FundList.Count >0) and (FPMainDataset.FieldByName('5').AsString <> '0') then begin
      StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
    end
    else begin
      StrGrid.Cells[15, i] := '';
    end;
    Inc(i);
    FPMainDataset.Next;
  end;

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a FP balance string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'et__';
  StrGrid.MergeCells(1, i, 8, 1);
  StrGrid.Cells[1, i] := '';
  StrGrid.MergeCells(9, i, 2, 1);
  StrGrid.Cells[9, i] := 'Итого:';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := MyFloatToStr(0); //'Сумма';
  StrGrid.MergeCells(13, i, 4, 1);
  StrGrid.Cells[13, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a FP balance string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'gt__';
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Баланс ФП:';
  StrGrid.MergeCells(4, i, 2, 1);
  StrGrid.Cells[4, i] := '';
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Section G
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 9, 1);
  StrGrid.Cells[ 1, i] := 'G. Переводы со счёта №1';
  StrGrid.MergeCells(10, i, 7, 1);
  StrGrid.Cells[10, i] := 'Переводы со счетов в расходную кассу';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);


  StrGrid.RowCount := i;
  InitBAList;
  RecalcFP;
	PrintingIsIP	:= false;
end;

procedure TFPAllocForm.InitDB;
var
  StrBegin  : string;
  i, j, k      : integer;
  AssList     : TList;
  RecList     : TList;
  IncData     : PIncData;
  FromDate    : TDateTime;
  TotalA      : extended;
  TotalA1     : extended;
  TotalB      : extended;
  TotalC      : extended;
  TotalD      : extended;
  TotalE      : extended;
  TotalF      : extended;
  CGI         : extended;
  GI1         : extended;
  TmpSum      : extended;
  FPBalanceC  : extended;
  FPBalanceD  : extended;
  FPBalanceF  : extended;
  TmpVal      : extended;
  iColWidth		: integer;
  PSum        : ^Extended;
  Stream      : TMemoryStream;

  FP1PSUM     : extended;
  FP1RSUM     : extended;

  ds					: char;
  ts					: char;
  sd					: string;
  st					: string;

begin
  // locking FP
  FPLT := TFPLockerThread.Create(TRUE);
  FPLT.FPTGC      := FPConnection;
  FPLT.FPTNum     := FPNum;
  FPLT.FPTOPrefix := OrgPrefix;
  FPLT.FPTUID     := FPUserID;

  FPLT.Priority        := tpLower;
  FPLT.FreeOnTerminate := true;
  FPLT.Resume;

  FPLockEvent.WaitFor(50);
  FPLockEvent.SetEvent;

  FPFLF := TFPFundsListForm.Create(Application);
  FPFLF.Parent       := TWinControl(0);
  FPFLF.FPAllocHadle := Self.Handle;

  if(ReadOnly) then
  	FundsTableButton.Visible := false
  else
	  FundsTableButton.Down := boolean(IniFile.ReadInteger('fp', 'FundsVisible', 1));
  IniFile.WriteInteger('fp', 'FundsVisible', integer(FundsTableButton.Down));

  FFromRecalc := false;
	PrintingIsIP	:= true;
  FPWasChanged := false;
  SaveToolButton.Enabled := FPWasChanged;

  FPMainDataset.SQL.Text := 'SELECT Abbr FROM orgs WHERE Prefix=:fPrefix';
  FPMainDataset.ParamByName('fPrefix').AsString := OrgPrefix;
  try
    FPMainDataset.Open;
  except
 	  on e: EZSQLException do begin
	    Globalvars.ShowError(Self, 'Невозможно получить название организации.', e.ErrorCode, e.StatusCode, e.Message);
    end;
  end;
  OrgShortName := FPMainDataset.FieldByName('Abbr').AsString;
  Caption:= '"' + OrgShortName + '" — финансовое планирование: с';

  SaveToolButton.Visible    := PrivPresentMO(FPPrivs, 'boqs');
  ApproveToolButton.Visible := PrivPresentMO(FPPrivs, 'bs');

  if not ReadOnly then begin
  	SaveToolButton.Visible 		:= true;
    ApproveToolButton.Visible := true;
    RowAddToolButton.Visible	:= true;
    RowDelToolButton.Visible	:= true;
	  SaveToolButton.Visible    := PrivPresentMO(FPPrivs, 'boqs');
  	ApproveToolButton.Visible := PrivPresentMO(FPPrivs, 'bs');
  end
  else begin
  	SaveToolButton.Visible 		:= false;
    ApproveToolButton.Visible := false;
    RowAddToolButton.Visible	:= false;
    RowDelToolButton.Visible	:= false;
  end;

  TmpFundCombo := TComboBox.Create(nil);
  TmpFundCombo.Parent := Self;
  TmpFundCombo.Visible := false;

  FromFondCombo := TComboBox.Create(nil);
  FromFondCombo.Parent := Self;
  FromFondCombo.Visible := false;

  ApproveCombo := TComboBox.Create(nil);
  ApproveCombo.Parent   := Self;
  ApproveCombo.Visible  := false;
  ApproveCombo.Clear;
  ApproveCombo.Items.Add('Отложить');
  ApproveCombo.Items.Add('Отклонить');
  ApproveCombo.Items.Add('Одобрить');

  width := 1040;
  height := screen.Height - 50;
  left := (Screen.Width - Width) div 2;
  top := 5;

	fplink		:= OrgPrefix + 'fp';
	lfplink		:= OrgPrefix + 'lfp';
  cashlink	:= OrgPrefix + CASH_LINK;
  bill1link	:= OrgPrefix + BILL1_LINK;
  polink		:= OrgPrefix + 'po';

  //replaced with InitFunds procedure
  InitFunds;
  InitFundsTree;

  AssList  := TList.Create;
  AssList  := CompFondList(OrgPRefix + 'asset', 0, CFL_WITHGROUPS, CFL_IGNOREPOS, OrgPRefix);

// pulling the IncomePlan
  Stream := TMemoryStream.Create;
  FPMainDataset.SQL.Text := 'SELECT`from`,`to`,`plan`FROM`' + OrgPRefix + 'fp`WHERE`index`=' + IntToStr(FPNum);

  try
  	FPMainDataset.Open;

	  FromDate := FPMainDataset.FieldByName('from').AsDateTime;
  	ToDate   := FPMainDataset.FieldByName('to').AsDateTime;
	  FromDateS := DateTimeToStr(FromDate);
  	ToDateS   := DateTimeToStr(ToDate);

  	Stream.LoadFromStream(FPMainDataset.CreateBlobStream(FPMainDataset.FieldByName('plan'), bmRead));
  except
    on e: EZSQLException do begin
		  Globalvars.ShowError(Self, 'Невозможно загрузить план по доходу.', e.ErrorCode, e.StatusCode, e.Message);
    end;
  end;

  // load the stream to Editor
	RVEditor.Clear;
  RVEditor.DeleteUnusedStyles(True, True, True);
  RVEditor.LoadRTFFromStream(Stream);
	RVEditor.Format;
  Stream.Free;

  Caption		 := Caption + ' ' + FromDateS + ' по ' + ToDateS;

	StrGrid.Visible := true;
  StrGrid.Options := StrGrid.Options - [goRowSelect];
  StrGrid.Align   := alClient;

  StrGrid.ColCount := 17;
  i := 65;
  StrGrid.FixedRows	:= 1;
  StrGrid.ColWidths[0] := 0;
  StrGrid.ColWidths[1] := ReadColWidth('FP', 1, 30);

  StrGrid.ColumnHeaders.Clear;
  iColWidth := i;
  for j := 2 to StrGrid.ColCount - 1 do begin
  	StrGrid.ColWidths[j] := ReadColWidth('FP', j, i);
  end;

  i := 1;

  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'А. Поступления';
  Inc(i);
      // headline A
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 2, 1);
  StrGrid.Cells[2, i] := 'Сумма';
  StrGrid.MergeCells(4, i, 8, 1);
  StrGrid.Cells[4, i] := 'Описание';
  StrGrid.MergeCells(12, i, 3, 1);
  StrGrid.Cells[12, i] := 'Дата/время';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Куда поступили';
  Inc(i);

  RecList     := TList.Create;

// set up IncByIS array
  SetLength(IncByIS, 0);
  SetLength(ISBySID, 0);
  FPMainDataset.SQL.Text := 'SELECT`ID`,StatID FROM ' + OrgPrefix + 'incomesources ORDER BY ID ASC';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    j := FPMainDataset.FieldByName('ID').AsInteger;
    if Length(IncByIS) < j + 1 then begin
      SetLength(IncByIS, j + 1);
      SetLEngth(ISBySID, j + 1);
    end;
    k := FPMainDataset.FieldByName('StatID').AsInteger;
    ISBySID[j] := k;
    FPMainDataset.Next;
  end;

  for j := Low(IncByIS) to High(IncByIS) do IncByIS[j] := 0;

  TotalA := 0;
  FPMainDataset.SQL.Text :=
          '(SELECT`lastdate`,`data`,CAST(`in`AS DECIMAL(25,2))AS`in`,`link`,"' + cashlink + '"as`src`,`incsrcid`AS`isid`FROM ' + cashlink + ' '+
          'WHERE`lastdate`>:ffd AND`lastdate`<=:ftd AND`in`<>0 AND`link`IN("' + OrgPrefix + BILL1_LINK + '","frombank","' + OrgPrefix + CASH_LINK + '","specinc"))';
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' union';
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text +
          '(SELECT`lastdate`,`data`,CAST(`in`AS DECIMAL(25,2))AS`in`,`link`,"' + bill1link + '"as`src`,`incsrcid`AS`isid`FROM '+ bill1link + ' '+
          'WHERE`lastdate`>:ffd AND`lastdate`<=:ftd AND`in`<>0 AND`link`IN("' + OrgPrefix + BILL1_LINK + '","frombank","' + OrgPrefix + CASH_LINK + '","specinc"))';
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY `lastdate`';
  FPMainDataset.ParamByName('ffd').AsDateTime := FromDate;
  FPMainDataset.ParamByName('ftd').AsDateTime := ToDate;
  FPMainDataset.Open;

  j  := 0;
  cm := 0;

  while not FPMainDataset.Eof do begin
    if FPMainDataset.FieldByName('src').AsString = cashlink then
      cm  := cm + FPMainDataset.FieldByName('in').AsFloat;
  	StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'a__';
    StrGrid.Cells[1, i] := IntToStr(j + 1);
    StrGrid.MergeCells(2, i, 2, 1);
    TmpVal := FPMainDataset.FieldByName('in').AsFloat;
    StrGrid.Cells[2, i] := MyFloatToStr(TmpVal);
    k := FPMainDataset.FieldByName('isid').AsInteger;
    if (k >= Low(IncByIS)) and (k <= High(IncByIS)) then IncByIS[k] := IncByIS[k] + TmpVal;

    StrGrid.MergeCells(4, i, 8, 1);
    StrGrid.Cells[4, i] := MyCleanStr(FPMainDataset.FieldByName('data').AsAnsiString, false);

    StrGrid.MergeCells(12, i, 3, 1);
    LastRecDate := FPMainDataset.FieldByName('lastdate').AsDateTime;
    StrGrid.Cells[12, i] := DateTimeToStr(LastRecDate, FormatString);

    StrGrid.MergeCells(15, i, 2, 1);

    StrGrid.Cells[15, i] := GetNameOfFondByLink(AssList, Trim(FPMainDataset.FieldByName('src').AsAnsiString));

    inc(j);
    Inc(i);
    FPMainDataset.Next;
	end;

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a Total GI string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'tgi__';
  TGIStrNum           := i;
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Общий валовый доход:';
  StrGrid.MergeCells(4, i, 2, 1);
  StrGrid.Cells[4, i] := MyFloatToStr(TotalA);
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

// !!!!!!!!!!!!!!!!!!!!
// Special Income Section
  // populating section A1  - special income
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'A1. Спецдоход';
  Inc(i);
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 9, 1);
  StrGrid.Cells[2, i] := 'Наименование';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := '%';
  StrGrid.MergeCells(13, i, 2, 1);
  StrGrid.Cells[13, i] := 'Сумма';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Фонд';
  Inc(i);
  FPMainDataset.Close;

	// pulling data from income itself
  FPMainDataset.SQL.Text := '';
  for j := 0 to AssList.Count - 1 do begin
  	if PVTResourceData(AssList.Items[j]).link = 'debitors'
    	then break;
    //if (PVTResourceData(AssList.Items[j]).link = '') or (PVTResourceData(AssList.Items[j]).level = 0)
    if (PVTResourceData(AssList.Items[j]).link = '')
    	then continue;

    if FPMainDataset.SQL.Text <> '' then
    	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' union';
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text +
    	'(SELECT`index`,`lastdate`,`data`,`in`,"' + PVTResourceData(AssList.Items[j]).link + '" AS`link`FROM ' + PVTResourceData(AssList.Items[j]).link +
      ' WHERE`lastdate`>:ffd AND`lastdate`<=:ftd AND`in`>0 AND`link`="specinc")';
  end; // for j:=...
  FPMainDataset.ParamByName('ffd').AsDateTime := FromDate;
  FPMainDataset.ParamByName('ftd').AsDateTime := ToDate;
  FPMainDataset.Open;

  j       := 0;
  TotalA1 := 0;
  while not FPMainDataset.Eof do begin
  	StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'a1__' + FPMainDataset.FieldByName('link').AsString + '_' + FPMainDataset.FieldByName('index').AsString;
    Inc(j);
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 9, 1);
    StrGrid.Cells[2, i] := Trim(FPMainDataset.FieldByName('data').AsAnsiString); //'Наименование';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] :=  '';
    StrGrid.MergeCells(13, i, 2, 1);
		TmpVal 								:= FPMainDataset.FieldByName('in').AsFloat;
    TotalA1  							:= TotalA1 + TmpVal;
    StrGrid.Cells[13, i] 	:= MyFloatToStr(TmpVal); //'К выплате';
		StrGrid.MergeCells(15, i, 2, 1);
//    FPTmpDataset.SQL.Text := 'SELECT `6` FROM lfp WHERE `5`=:fCode';
    FPTmpDataset.SQL.Text := 'SELECT`6`FROM ' + lfplink + ' WHERE`5`=:fCode';
    FPTmpDataset.ParamByName('fCode').AsString := FPMainDataset.FieldByName('link').AsString + '_'+ FPMainDataset.FieldByName('index').AsString;
    FPTmpDataset.Open;
    if (FPTmpDataset.RecordCount > 0) and (FPTmpDataset.FieldByName('6').AsString <> '') and (FPTmpDataset.FieldByName('6').AsString <> '0') then begin
    	StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPTmpDataset.FieldByName('6').AsString);
    end
    else
  		StrGrid.Cells[15, i] := '';
    Inc(i);
    FPMainDataset.Next;
  end;

  // pulling special income data set manually
	FPMainDataset.SQL.Text := 'SELECT * FROM`' + lfplink + '`WHERE`1`="a1"AND`2`IS NOT NULL';
  FPMainDataset.Open;
	while not FPMainDataset.Eof do begin
  	StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'a1__';
    Inc(j); //j := FPMainDataset.FieldByName('index').AsInteger;
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 9, 1);
    StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString; //'Наименование';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] :=  FPMainDataset.FieldByName('4').AsString; //'Формула';
    StrGrid.MergeCells(13, i, 2, 1);
    if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','), TmpSum) then begin
    	TryStrToFloat(ReplaceStr(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','), ThSep, ''), TmpVal);
      TotalA1  := TotalA1 + TmpVal; //StrToFloat(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','));
      StrGrid.Cells[13, i] := MyFloatToStr(TmpVal); //'К выплате';
    end
		else
    	StrGrid.Cells[13, i] := '';
    StrGrid.MergeCells(15, i, 2, 1);
    if (FPMainDataset.FieldByName('6').AsString <> '') and (FPMainDataset.FieldByName('6').AsString <> '0') then
    	StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('6').AsString)
    else if (FundList.Count >0) and (FPMainDataset.FieldByName('6').AsString <> '0') then
    	StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
    else
    	StrGrid.Cells[15, i] := '';
    Inc(i);
    FPMainDataset.Next;
  end;

  // Add blank line
  Inc(j);
  StrGrid.Cells[0, i] := 'a1__';
  StrGrid.Cells[1, i] := IntToStr(j);
  StrGrid.MergeCells(2, i, 9, 1);
  StrGrid.Cells[2, i] := '';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] :=  '';
  StrGrid.MergeCells(13, i, 2, 1);
  StrGrid.Cells[13, i] := '';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := '';
  Inc(i);

  // Showing the amount for section A1
  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding the  total for section A1
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'a1t__';
  StrGrid.MergeCells(1, i, 8, 1);
  StrGrid.Cells[1, i] := '';
  StrGrid.MergeCells(9, i, 2, 1);
  StrGrid.Cells[9, i] := 'Итого по разделу:';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := MyFloatToStr(TotalA1);
  StrGrid.MergeCells(13, i, 4, 1);
  StrGrid.Cells[13, i] := '';
  Inc(i);
  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a CGI string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'gi__';
  GIStrNum						:= i;
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Валовый доход:';
  StrGrid.MergeCells(4, i, 2, 1);
//      CGI := TotalA - TotalB;
  GI1 := TotalA - TotalA1;
  StrGrid.Cells[4, i] := MyFloatToStr(GI1);
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);


  FP1PSUM := 0;
  FP1RSUM := 0;

  // populating section B  - taxes, royalties etc
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'B. Фонды управления';
  Inc(i);

// new version with FP1 percents
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 7, 1);
  StrGrid.Cells[2, i] := 'Наименование';
  StrGrid.Cells[9, i] := '%(ФП №1)';
  StrGrid.MergeCells(10, i, 2, 1);
  StrGrid.Cells[10, i] := 'По ФП №1';
  StrGrid.Cells[12, i] := '%';
  StrGrid.MergeCells(13, i, 2, 1);
  StrGrid.Cells[13, i] := 'Сумма';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Фонд';
  Inc(i);

 	FPMainDataset.SQL.Text := 'SELECT * FROM`' + lfplink + '`WHERE`1`="B"';
{$IFDEF SFIAF}
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY`2`';
{$ENDIF}
  FPMainDataset.Open;
  j := 0;
	TotalB  := 0;
  while not FPMainDataset.Eof do begin
  	StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'b__';
    Inc(j);
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 7, 1);
    StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString;   //'Наименование';
    // FP1 Data - percent and amount
    if FPMainDataset.FieldByName('6').AsString <> '0' then begin
      FPTmpDataset.SQL.Text := 'SELECT ' + OrgPRefix + 'fp1funddata.* from ' + OrgPRefix + 'fp1funddata JOIN ' + OrgPRefix + 'fond ON ' + OrgPRefix + 'fp1funddata.fid=' + OrgPRefix + 'fond.`index` WHERE ' + OrgPRefix + 'fond.link=:fLink AND since<NOW() ORDER BY since DESC LIMIT 1';
      FPTmpDataset.ParamByName('fLink').AsString := FPMainDataset.FieldByName('6').AsString;
      try
        FPTmpDataset.Open;
      except
 				on e: EZSQLException do begin
	  			Globalvars.ShowError(Self, 'Невозможно получить данные об ФП №1.', e.ErrorCode, e.StatusCode, e.Message);
        	Close;
        end;
      end;

      if FPTmpDataset.RecordCount > 0 then begin
        StrGrid.Cells[ 9, i] := MyFloatToStr(FPTmpDataset.FieldByName('pct').AsExtended);    //'% по ФП №1';
      end
      else
        StrGrid.Cells[ 9, i] := '';    //'% по ФП №1';
      StrGrid.MergeCells(10, i, 2, 1);                                                     //'По ФП №1';
      if FPTmpDataset.RecordCount > 0 then begin
        StrGrid.Cells[10, i] := MyFloatToStr(FPTmpDataset.FieldByName('amount').AsExtended);
        FP1PSUM := FP1PSUM + FPTmpDataset.FieldByName('amount').AsExtended;
      end
      else begin
        StrGrid.Cells[10, i] := '';
      end;
    end
    else begin
      StrGrid.Cells[ 9, i] := '';                                        //'% по ФП №1';
      StrGrid.MergeCells(10, i, 2, 1);                                  //'По ФП №1'
  		StrGrid.Cells[10, i] := '';
    end;
    // FP1 Data - percent and amount - end of

    StrGrid.Cells[12, i] :=  FPMainDataset.FieldByName('4').AsString; //'%'
    StrGrid.MergeCells(13, i, 2, 1);																  //'Сумма'
    if	TryStrToFloat(ReplaceStr(ReplaceStr(FPMainDataset.FieldByName('5').AsString, '.', ','), ThSep, ''), TmpVal) then begin
      FP1RSUM := FP1RSUM + TmpVal;
      StrGrid.Cells[13, i] := MyFloatToStr(TmpVal)
    end
    else begin
    	StrGrid.Cells[13, i] := '';
    end;
    StrGrid.MergeCells(15, i, 2, 1);																// 'Фонд'
    if (FPMainDataset.FieldByName('6').AsString <> '') and (FPMainDataset.FieldByName('6').AsString <> '0') then
    	StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('6').AsString)
    else
    	StrGrid.Cells[15, i] := '';
    Inc(i);
    FPMainDataset.Next;
	end;

  // Add blank line
  Inc(j);
  StrGrid.Cells[0, i] := 'b__';
  StrGrid.Cells[1, i] := IntToStr(j);
  StrGrid.MergeCells(2, i, 7, 1);
  StrGrid.Cells[2, i] := '';
  StrGrid.Cells[9, i] := '';
  StrGrid.MergeCells(10, i, 2, 1);
  StrGrid.Cells[10, i] :=  '';
  StrGrid.Cells[12, i] :=  '';
  StrGrid.MergeCells(13, i, 2, 1);
  StrGrid.Cells[13, i] := '';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := '';
  Inc(i);

  // Showing the amount for section B
  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

	// Adding the  total for section B
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'bt__';
  StrGrid.MergeCells(1, i, 8, 1);
  StrGrid.Cells[1, i] := '';
  StrGrid.MergeCells(9, i, 2, 1);
  StrGrid.Cells[9, i] := 'Итого по разделу:';
  StrGrid.MergeCells(11, i, 2, 1);
  StrGrid.Cells[11, i] := MyFloatToStr(TotalB);
  StrGrid.MergeCells(13, i, 4, 1);
  StrGrid.Cells[13, i] := '';
  Inc(i);
  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Adding a CGI string
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'b_cgi__';
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'К распределению:';
  StrGrid.MergeCells(4, i, 2, 1);
  CGI := TotalA - TotalB;
  StrGrid.Cells[4, i] := MyFloatToStr(CGI);
  StrGrid.MergeCells(6, i, 11, 1);
  StrGrid.Cells[6, i] := '';
  Inc(i);

  // Adding an empty string
  StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  // Section C - funds etc
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 'h__';
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := 'С. Фонды организации';
  Inc(i);

  // headline C
  StrGrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 's__';
  StrGrid.Cells[1, i] := '№';
  StrGrid.MergeCells(2, i, 7, 1);
  StrGrid.Cells[2, i] := 'Наименование';
  StrGrid.Cells[9, i] := '% (ФП №1)'; //RightAlign
  StrGrid.MergeCells(10, i, 2, 1);
  StrGrid.Cells[10, i] := 'По ФП №1'; //RightAlign
  StrGrid.Cells[12, i] := '%';				//RightAlign
  StrGrid.MergeCells(13, i, 2, 1);		//RightAlign
  StrGrid.Cells[13, i] := 'Сумма';
  StrGrid.MergeCells(15, i, 2, 1);
  StrGrid.Cells[15, i] := 'Фонд';
  Inc(i);

  FPMainDataset.SQL.Text := 'SELECT * FROM`' + lfplink + '`WHERE`1`="C"';
{$IFDEF SFIAF}
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY`2`';
{$ENDIF}
  FPMainDataset.Open;
  j := 0;
  while not FPMainDataset.Eof do begin
  	StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'c__';
    Inc(j);
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 7, 1);
    StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString; //'Наименование';
    // FP1 Data - percent and amount
    if FPMainDataset.FieldByName('5').AsString <> '0' then begin
      FPTmpDataset.SQL.Text := 'SELECT ' + OrgPRefix + 'fp1funddata.* from ' + OrgPRefix + 'fp1funddata JOIN ' + OrgPRefix + 'fond ON ' + OrgPRefix + 'fp1funddata.fid=' + OrgPRefix + 'fond.`index` WHERE ' + OrgPRefix + 'fond.link=:fLink AND since<NOW() ORDER BY since DESC LIMIT 1';
      FPTmpDataset.ParamByName('fLink').AsString := FPMainDataset.FieldByName('5').AsString;
      try
        FPTmpDataset.Open;
      except
 				on e: EZSQLException do begin
	  			Globalvars.ShowError(Self, 'Невозможно получить данные об ФП №1.', e.ErrorCode, e.StatusCode, e.Message);
        	Close;
        end;
      end;

      if FPTmpDataset.RecordCount > 0 then begin
        StrGrid.Cells[ 9, i] := MyFloatToStr(FPTmpDataset.FieldByName('pct').AsExtended);    //'% по ФП №1';
      end
      else
        StrGrid.Cells[ 9, i] := '';    //'% по ФП №1';
      StrGrid.MergeCells(10, i, 2, 1);                                                     //'По ФП №1';
      if FPTmpDataset.RecordCount > 0 then begin
        StrGrid.Cells[10, i] := MyFloatToStr(FPTmpDataset.FieldByName('amount').AsExtended);
        FP1PSUM := FP1PSUM + FPTmpDataset.FieldByName('amount').AsExtended;
      end
      else begin
        StrGrid.Cells[10, i] := '';
      end;
    end
    else begin
      StrGrid.Cells[ 9, i] := '';                                        //'% по ФП №1';
      StrGrid.MergeCells(10, i, 2, 1);                                  //'По ФП №1'
  		StrGrid.Cells[10, i] := '';
    end;
    // FP1 Data - percent and amount - end of
    StrGrid.Cells[12, i] :=  FPMainDataset.FieldByName('3').AsString; //'%'
    StrGrid.MergeCells(13, i, 2, 1);                  							//'Сумма';
		if FPMainDataset.FieldByName('4').AsString<>'' then begin
    	if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('4').AsString, '.', ','), TmpVal) then begin
        FP1RSUM := FP1RSUM + TmpVal;
        StrGrid.Cells[13, i] := MyFloatToStr(TmpVal);
      end
      else
      	StrGrid.Cells[13, i] := FPMainDataset.FieldByName('4').AsString
    end
    else
    	StrGrid.Cells[13, i] :=  '';
    StrGrid.MergeCells(15, i, 2, 1);
			if (FPMainDataset.FieldByName('5').AsString <> '') then
      	StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('5').AsString)
{IFNDEF FAFH}
//      else if (FundList.Count > 0) and (FPMainDataset.FieldByName('5').AsString <> '0') then
//      	StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
{ENDIF}
      else
      	StrGrid.Cells[15, i] := '';
			Inc(i);
			FPMainDataset.Next;
    end;

    // Add the blank line
		Inc(j);
		StrGrid.Cells[0, i] := 'c__';
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 7, 1);
    StrGrid.Cells[2, i] := '';
    StrGrid.Cells[9, i] := '';
    StrGrid.MergeCells(10, i, 2, 1);
    StrGrid.Cells[10, i] :=  '';
    StrGrid.Cells[12, i] :=  '';
    StrGrid.MergeCells(13, i, 2, 1);
    StrGrid.Cells[13, i] := '';
    StrGrid.MergeCells(15, i, 2, 1);
    StrGrid.Cells[15, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding the  total for section C
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'ct__';
    StrGrid.MergeCells(1, i, 8, 1);
    StrGrid.Cells[1, i] := '';
    StrGrid.MergeCells(9, i, 2, 1);
    StrGrid.Cells[9, i] := 'Итого по разделу:';
    StrGrid.MergeCells(11, i, 2, 1);
    FPBalanceC := CGI - TotalC;
    StrGrid.Cells[11, i] := MyFloatToStr(TotalC);  //'Сумма';
    StrGrid.MergeCells(13, i, 4, 1);
    StrGrid.Cells[13, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding the FP1 balance line
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'fp1t__';
    StrGrid.MergeCells(1, i, 9, 1);
    StrGrid.Cells[1, i] := 'Итого по ФП №1';
    StrGrid.MergeCells(10, i, 2, 1);
    StrGrid.Cells[10, i] := MyFloatToStr(FP1PSUM);
    StrGrid.Cells[12, i] := '';
    StrGrid.MergeCells(13, i, 2, 1);
    StrGrid.Cells[13, i] := MyFloatToStr(FP1RSUM);
    StrGrid.MergeCells(15, i, 2, 1);
    StrGrid.Cells[15, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding a FP balance string
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'c_cgi__';
    StrGrid.MergeCells(1, i, 3, 1);
    StrGrid.Cells[1, i] := 'Баланс ФП:';
    StrGrid.MergeCells(4, i, 2, 1);
    StrGrid.Cells[4, i] := MyFloatToStr(FPBalanceC);
    StrGrid.MergeCells(6, i, 11, 1);
    StrGrid.Cells[6, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Section D
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'h__';
    StrGrid.MergeCells(1, i, 16, 1);
//    StrGrid.Cells[1, i] := 'D. Обязательные выплаты';
    StrGrid.Cells[1, i] := 'D. Фиксированные обязательные платежи';
    Inc(i);

    // headline D
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 's__';
    StrGrid.Cells[1, i] := '№';
    StrGrid.MergeCells(2, i, 5, 1);
    StrGrid.Cells[2, i] := 'Наименование';
	  StrGrid.MergeCells(7, i, 3, 1);
  	StrGrid.Cells[7, i] := 'По ФП №1';
    StrGrid.MergeCells(10, i, 3, 1);
    StrGrid.Cells[10, i] := 'Примечание';
    StrGrid.MergeCells(13, i, 2, 1);
    StrGrid.Cells[13, i] := 'Сумма';
    StrGrid.MergeCells(15, i, 2, 1);
    StrGrid.Cells[15, i] := 'Фонд';
    Inc(i);

    FPMainDataset.SQL.Text := 'SELECT * FROM`' + lfplink + '`WHERE`1`="D"';
    FPMainDataset.Open;
    j := 0;
    while not FPMainDataset.Eof do begin
    	StrGrid.SplitRowCells(i);
      StrGrid.Cells[0, i] := 'd__';
      j := FPMainDataset.FieldByName('index').AsInteger;
      StrGrid.Cells[1, i] := IntToStr(j);
      StrGrid.MergeCells(2, i, 5, 1);                                 //'Наименование'
      StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString;
		  StrGrid.MergeCells(7, i, 3, 1); 																//'По ФП №1'
			if TryStrToFloat(ReplaceStr(ReplaceStr(FPMainDataset.FieldByName('6').AsString, '.', ','), ThSep, ''), TmpVal) then
        StrGrid.Cells[7, i] := MyFloatToStr(TmpVal)
    	else
	    	StrGrid.Cells[7, i] := '';
      StrGrid.MergeCells(10, i, 3, 1);                                // Примечание
      StrGrid.Cells[10, i] := FPMainDataset.FieldByName('3').AsString;
      StrGrid.MergeCells(13, i, 2, 1);                                //'Сумма'
      if FPMainDataset.FieldByName('4').AsString <>'' then begin
      	if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('4').AsString, '.', ','), TmpSum) then begin
        	TotalD  := TotalD + TmpSum;
          StrGrid.Cells[13, i] := MyFloatToStr(TmpSum);
        end
        else
        	StrGrid.Cells[13, i] := FPMainDataset.FieldByName('4').AsString
      end
      else
      	StrGrid.Cells[13, i] :=  '';

      StrGrid.MergeCells(15, i, 2, 1);																// 'Фонд'
      if (FPMainDataset.FieldByName('5').AsString <> '') and (FPMainDataset.FieldByName('5').AsString <> '0') then
      	StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('5').AsString)
      else if (FundList.Count > 0) and (FPMainDataset.FieldByName('5').AsString <> '0') then
      	StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
      else
      	StrGrid.Cells[15, i] := '';
      Inc(i);
      FPMainDataset.Next;
		end;

    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'd__';
    Inc(j);
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 5, 1);
    StrGrid.Cells[2, i] := '';
    StrGrid.MergeCells(7, i, 3, 1);
    StrGrid.Cells[7, i] := '';
    StrGrid.MergeCells(10, i, 3, 1);
    StrGrid.Cells[10, i] := '';
    StrGrid.MergeCells(13, i, 2, 1);
    StrGrid.Cells[13, i] :=  '';
    StrGrid.MergeCells(15, i, 2, 1);
    StrGrid.Cells[15, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding the  total for section D
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'dt__';
    StrGrid.MergeCells(1, i, 8, 1);
    StrGrid.Cells[1, i] := '';
    StrGrid.MergeCells(9, i, 2, 1);
    StrGrid.Cells[9, i] := 'Итого по разделу:';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] := MyFloatToStr(TotalD); //'Сумма';
    StrGrid.MergeCells(13, i, 4, 1);
    StrGrid.Cells[13, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding a FP balance string
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'd_cgi__';
    StrGrid.MergeCells(1, i, 3, 1);
    StrGrid.Cells[1, i] := 'Баланс ФП:';
    StrGrid.MergeCells(4, i, 2, 1);
    FPBalanceD := FPBalanceC - TotalD;
    StrGrid.Cells[4, i] := MyFloatToStr(FPBalanceD);
    StrGrid.MergeCells(6, i, 11, 1);
    StrGrid.Cells[6, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Section F (now section E)
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'h__';
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := 'E. Заявки';
    Inc(i);

    // headline F
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 's__';
    StrGrid.Cells[1, i] := '№';
    StrGrid.MergeCells(2, i, 2, 1);
    StrGrid.Cells[2, i] := 'Дата';
    StrGrid.MergeCells(4, i, 3, 1);
    StrGrid.Cells[4, i] := 'Тема';
    StrGrid.MergeCells(7, i, 2, 1);
    StrGrid.Cells[7, i] := 'Сумма заявки';
    StrGrid.MergeCells(9, i, 2, 1);
    StrGrid.Cells[9, i] := 'Решение';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] := 'Одобрить';
    StrGrid.MergeCells(13, i, 2, 1);
    StrGrid.Cells[13, i] := 'Пояснение';
    StrGrid.MergeCells(15, i, 2, 1);
    StrGrid.Cells[15, i] := 'Источник';
    Inc(i);

    MaxPONum := 0;
    POList  := TStringList.Create;
    POrList := TStringList.Create;

   	FPMainDataset.SQL.Text := 'SELECT * FROM`' + polink + '`WHERE`status`<=0'; /// ?!!! - to change `status` to the usual integer
    FPMainDataset.Open;
    j := 0;
    while not FPMainDataset.Eof do begin
      StrGrid.SplitRowCells(i);
      StrGrid.Cells[0,  i] := 'f__';
      j := FPMainDataset.FieldByName('index').AsInteger;
      if j > MaxPONum then
        MaxPONum := j;
      POList.AddObject( IntToStr(j), pointer(FPMainDataset.FieldByName('bycash').AsInteger));
      POrList.AddObject(IntToStr(j), pointer(FPMainDataset.FieldByName('bycash').AsInteger));
      StrGrid.Cells[1,  i] := IntToStr(j);
      StrGrid.MergeCells(2, i, 2, 1);
      StrGrid.Cells[2,  i] := DateTimeToStr(FPMainDataset.FieldByName('date').AsDateTime, FormatString);

      StrGrid.MergeCells(4, i, 3, 1);
      StrGrid.Cells[4,  i] := FPMainDataset.FieldByName('re').AsString;

      StrGrid.MergeCells(7, i, 2, 1);
      StrGrid.Cells[7,  i] := MyFloatToStr(FPMainDataset.FieldByName('sumr').AsFloat);  //'Сумма';

      StrGrid.MergeCells(9,	 i, 2, 1);
      StrGrid.MergeCells(11, i, 2, 1);
      StrGrid.MergeCells(13, i, 2, 1);
      StrGrid.MergeCells(15, i, 2, 1);
			FPTmpDataset.SQL.Text := 'SELECT`2`,`3`,`4`,`5`FROM`' + lfplink + '`WHERE`index`='+ IntToStr(j) + ' AND`1`="f"';
      FPTmpDataset.Open;
      if not FPTmpDataset.Eof then begin
      	StrGrid.Cells[9,  i] := ApproveCombo.Items[FPTmpDataset.FieldByName('3').AsInteger];  //'Отложить';
        if FPTmpDataset.FieldByName('2').AsString <> '' then begin
        	TryStrToFloat(ReplaceStr(ReplaceStr(FPTmpDataset.FieldByName('2').AsString, '.', ','), ThSep, ''), TmpVal);
          StrGrid.Cells[11, i] := MyFloatToStr(TmpVal);  // Одобрить
				end
        else
        	StrGrid.Cells[11, i] := '';
        StrGrid.Cells[13, i] := FPTmpDataset.FieldByName('4').AsString;                       // Пояснение
        if FPTmpDataset.FieldByName('3').AsInteger = 2 then
        	StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPTmpDataset.FieldByName('5').AsString)// Источник
        else
        	StrGrid.Cells[15, i] := '';// Источник
			end
      else begin
      	StrGrid.Cells[9,  i] := ApproveCombo.Items[0];                                      //'Отложить';
        StrGrid.Cells[11, i] := '';                                                         // Одобрить
        StrGrid.Cells[13, i] := '';                                                         // Пояснение
        StrGrid.Cells[15, i] := '';                                                         // Источник
      end;
      Inc(i);
      FPMainDataset.Next;
		end;
    POList.Sort;
    POrList.Sort;

    // here goes PO Locker
    MaxPONum := j;
    // locking proper POs
    POLT := TPOLockerThread.Create(TRUE);
    POLT.POTGC      := FPConnection;
    POLT.POTOPrefix := OrgPrefix;
    POLT.POTUID     := FPUserID;
    POLT.POFilter   := '`status`<=0 AND`index`<=' + IntToStr(MaxPONum);

    POLT.Priority        := tpLower;
    POLT.FreeOnTerminate := true;
    POLT.Resume;

    POLockEvent.WaitFor(50);
    POLockEvent.SetEvent;

// here goes PO Locker -- end of
    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding the total for section F
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'ftwf__';
    StrGrid.MergeCells(1, i, 7, 1);
    StrGrid.Cells[1, i] := '';
    StrGrid.MergeCells(8, i, 3, 1);
    StrGrid.Cells[8, i] := 'Итого по разделу:';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] := '0,00';
    StrGrid.MergeCells(13, i, 4, 1);
    StrGrid.Cells[13, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding a FP balance string
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'ft__';
    StrGrid.MergeCells(1, i, 3, 1);
    StrGrid.Cells[1, i] := 'Баланс ФП:';
    StrGrid.MergeCells(4, i, 2, 1);
    StrGrid.Cells[4, i] := '';
    StrGrid.MergeCells(6, i, 11, 1);
    StrGrid.Cells[6, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Section F (used to be section E)
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'h__';
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := 'F. Нераспределённые средства';
    Inc(i);

    // headline E
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 's__';
    StrGrid.Cells[1, i] := '№';
    StrGrid.MergeCells(2, i, 9, 1);
    StrGrid.Cells[2, i] := 'Наименование';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] := '%';
    StrGrid.MergeCells(13, i, 2, 1);
    StrGrid.Cells[13, i] := 'Сумма';
    StrGrid.MergeCells(15, i, 2, 1);
    StrGrid.Cells[15, i] := 'Фонд';
    Inc(i);

    FPMainDataset.SQL.Text := 'SELECT * FROM`' + lfplink + '`WHERE `1` = "E"';
    FPMainDataset.Open;
    j := 0;
    while not FPMainDataset.Eof do begin
    	StrGrid.SplitRowCells(i);
      StrGrid.Cells[0, i] := 'e__';
      j := FPMainDataset.FieldByName('index').AsInteger;
      StrGrid.Cells[1, i] := IntToStr(j);
      StrGrid.MergeCells(2, i, 9, 1);
      StrGrid.Cells[2, i] := FPMainDataset.FieldByName('2').AsString;
      StrGrid.MergeCells(11, i, 2, 1);
      StrGrid.Cells[11, i] := FPMainDataset.FieldByName('3').AsString;
      StrGrid.MergeCells(13, i, 2, 1);
      if FPMainDataset.FieldByName('4').AsString <>'' then begin
      	if TryStrToFloat(ReplaceStr(FPMainDataset.FieldByName('4').AsString, '.', ','), TmpSum) then begin
        	StrGrid.Cells[13, i] := MyFloatToStr(TmpSum); //'Сумма';
        end
        else
        	StrGrid.Cells[13, i] := FPMainDataset.FieldByName('4').AsString
      end
      else
      	StrGrid.Cells[13, i] :=  ''; //'Сумма';

			StrGrid.MergeCells(15, i, 2, 1);
      if (FPMainDataset.FieldByName('5').AsString <> '') and (FPMainDataset.FieldByName('5').AsString <> '0') then
      	StrGrid.Cells[15, i] := GetNameOfFondByLink(FundList, FPMainDataset.FieldByName('5').AsString)
      else if (FundList.Count >0) and (FPMainDataset.FieldByName('5').AsString <> '0') then
      	StrGrid.Cells[15, i] := PVTResourceData(FundList[0]).name
      else
      	StrGrid.Cells[15, i] := '';
      Inc(i);
      FPMainDataset.Next;
		end;

    // Add empty line to the section E
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'e__';
    Inc(j);
    StrGrid.Cells[1, i] := IntToStr(j);
    StrGrid.MergeCells(2, i, 9, 1);
    StrGrid.Cells[2, i] := '';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] := '';
    StrGrid.MergeCells(13, i, 2, 1);
    StrGrid.Cells[13, i] :=  '';
    StrGrid.MergeCells(15, i, 2, 1);
    StrGrid.Cells[15, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding a FP balance string
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'et__';
    StrGrid.MergeCells(1, i, 8, 1);
    StrGrid.Cells[1, i] := '';
    StrGrid.MergeCells(9, i, 2, 1);
    StrGrid.Cells[9, i] := 'Итого:';
    StrGrid.MergeCells(11, i, 2, 1);
    StrGrid.Cells[11, i] := MyFloatToStr(0); //'Сумма';
    StrGrid.MergeCells(13, i, 4, 1);
    StrGrid.Cells[13, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Adding a FP balance string
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'gt__';
    StrGrid.MergeCells(1, i, 3, 1);
    StrGrid.Cells[1, i] := 'Баланс ФП:';
    StrGrid.MergeCells(4, i, 2, 1);
    StrGrid.Cells[4, i] := '';
    StrGrid.MergeCells(6, i, 11, 1);
    StrGrid.Cells[6, i] := '';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    // Section G
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'h__';
    StrGrid.MergeCells(1, i, 9, 1);
    StrGrid.Cells[ 1, i] := 'G. Переводы со счёта №1';
    StrGrid.MergeCells(10, i, 7, 1);
    StrGrid.Cells[10, i] := 'Переводы со счетов в расходную кассу';
    Inc(i);

    // Adding an empty string
    StrGrid.SplitRowCells(i);
    StrGrid.MergeCells(1, i, 16, 1);
    StrGrid.Cells[1, i] := '';
    Inc(i);

    StrGrid.RowCount := i;
    InitBAList;
    RecalcFP;
		PrintingIsIP	:= false;
end;


procedure TFPAllocForm.btnIndentDecClick(Sender: TObject);
begin
  RVEditor.ApplyParaStyleConversion(PARA_INDENTDEC);
end;

procedure TFPAllocForm.btnIndentIncClick(Sender: TObject);
begin
  RVEditor.ApplyParaStyleConversion(PARA_INDENTINC);
end;

procedure TFPAllocForm.btnItalicClick(Sender: TObject);
begin
  if FUpdating then Exit;
  RVEditor.ApplyStyleConversion(TEXT_ITALIC);
end;

procedure TFPAllocForm.btnMergeCellsClick(Sender: TObject);
var
  Item:         TCustomRVItemInfo;
  table:        TRVTableItemInfo;
  Data:         Integer;
  r, c, cs, rs: Integer;
  s:            String;
  rve:          TCustomRichViewEdit;
  ItemNo:       Integer;
begin
  if not RVEditor.CanChange or not RVEditor.GetCurrentItemEx(TRVTableItemInfo, rve, Item) then
    exit;
  table := TRVTableItemInfo(Item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);

	RVEditor.BeginUndoGroup(rvutModifyItem);
  RVEditor.SetUndoGroupMode(True);
	table.MergeSelectedCells(True);
  table.DeleteEmptyRows;
  table.DeleteEmptyCols;
  rve.SetUndoGroupMode(False);
  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;

procedure TFPAllocForm.btnNoBulletsClick(Sender: TObject);
begin
	RVEditor.RemoveLists(False);
end;

procedure TFPAllocForm.btnParaFillClick(Sender: TObject);
begin
	cd.Color := RVStyle.ParaStyles[RVEditor.CurParaStyleNo].Background.Color;
  if cd.Color = clNone then cd.Color := clWhite;
  if not cd.Execute then exit;
  RVEditor.ApplyParaStyleConversion(PARA_COLOR);
end;

procedure TFPAllocForm.btnPasteClick(Sender: TObject);
begin
	RVEditor.Paste;
end;

procedure TFPAllocForm.btnRedoClick(Sender: TObject);
begin
  RVEditor.Redo;
end;

procedure TFPAllocForm.btnSplitCellHorizClick(Sender: TObject);
var
  Item:         TCustomRVItemInfo;
  table:        TRVTableItemInfo;
  Data:         Integer;
  r, c, cs, rs: Integer;
  s:            String;
  rve:          TCustomRichViewEdit;
  ItemNo:       Integer;
begin
  if not RVEditor.CanChange or not RVEditor.GetCurrentItemEx(TRVTableItemInfo, rve, Item) then
    exit;
  table := TRVTableItemInfo(Item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);
        s := '2';
        if InputQuery('Разделение по горизонтали', 'Сделать строк (в каждой выбранной ячейке):', s)
        then
        begin
          table.SplitSelectedCellsHorizontally(StrToIntDef(s, 0));
        end;
  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;

procedure TFPAllocForm.btnSplitCellVertClick(Sender: TObject);
var
  Item:         TCustomRVItemInfo;
  table:        TRVTableItemInfo;
  Data:         Integer;
  r, c, cs, rs: Integer;
  s:            String;
  rve:          TCustomRichViewEdit;
  ItemNo:       Integer;
begin
  if not RVEditor.CanChange or not RVEditor.GetCurrentItemEx(TRVTableItemInfo, rve, Item) then
    exit;
  table := TRVTableItemInfo(Item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);
        s := '2';
        if InputQuery('Разделение по вертикали', 'Сделать столбцов (в каждой выбранной ячейке):', s)
        then
        begin
          table.SplitSelectedCellsVertically(StrToIntDef(s, 0));
        end;
  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;

procedure TFPAllocForm.btnAlignLeftClick(Sender: TObject);
begin
  if FUpdating then Exit;
  RVEditor.ApplyParaStyleConversion(PARA_ALIGNLEFT);
end;

procedure TFPAllocForm.SaveAndApproveFP;
begin
  //
end;

procedure TFPAllocForm.TransferAssets(ATmpVal : Extended; AFundLink, AReason : string);
var
	AssetLink : string;
  Balance		: extended;
  i         : integer;
begin
	FPTmpDataset.SQL.Text := 'SELECT assetlink FROM ' + OrgPrefix + 'fundsvsassets WHERE fundlink=:fFundLink';
  FPTmpDataset.ParamByName('fFundLink').AsString	:= AFundLink;
  FPTmpDataset.Open;

  if FPTmpDataset.RecordCount > 0 then
  	AssetLink := FPTmpDataset.FieldByName('assetlink').AsString
  else
  	AssetLink := '';

  if AssetLink <> '' then begin // if there is a fund-asset relation established
	  // Getting the balance from Account #1
  	FPTmpDataset.SQL.Text := 'SELECT balance FROM ' + bill1link + ' WHERE `index`>1 ORDER by `index` DESC LIMIT 1';
    FPTmpDataset.Open;
    if not FPTmpDataset.Eof then
  		Balance := FPTmpDataset.FieldByName('balance').AsFloat
    else
    	Balance := 0;
    // updating balance
    Balance := Balance - ATmpVal;

	  FPTmpDataset.SQL.Text := 'INSERT INTO ' + bill1link + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`amount`,`price`,`data`,`in`,`out`,`incsrcid`,`pct`)' +
																	    'VALUES(NULL,NULL,0,"transfer",0,:fBal,NOW(),0,0,:fData,0,:fSum,0,0)';
  	FPTmpDataset.ParamByName('fBal').AsFloat    := Balance;
    FPTmpDataset.ParamByName('fData').AsAnsiString  := AReason;
    FPTmpDataset.ParamByName('fSum').AsFloat    := ATmpVal;
    FPTmpDataset.ExecSQL;

    // updating Balance for Account #1
	  Fond_Update(bill1link, Balance);
	  // Getting the balance from proper asset
  	FPTmpDataset.SQL.Text := 'SELECT balance FROM ' + AssetLink + ' WHERE `index`>1 ORDER by `index` DESC LIMIT 1';
    FPTmpDataset.Open;
	  if not FPTmpDataset.Eof then
  		Balance := FPTmpDataset.FieldByName('balance').AsFloat
    else
    	Balance := 0;
    // updating balance
    Balance := Balance + ATmpVal;
	  FPTmpDataset.SQL.Text := 'INSERT INTO ' + AssetLink + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES(NULL,NULL,0,"transfer",0,:fBal,NOW(),:fData,:fSum,0)';
  	FPTmpDataset.ParamByName('fBal').AsFloat    := Balance;
    FPTmpDataset.ParamByName('fData').AsAnsiString  := 'Перевод : "' + AReason + '"';;
    FPTmpDataset.ParamByName('fSum').AsFloat    := ATmpVal;
    FPTmpDataset.ExecSQL;
    // updating Account #1
	  Fond_Update(AssetLink, Balance);
  end;
end;

procedure TFPAllocForm.SaveFP(RecordFP : boolean = false);
var
  i         	: integer;
  j           : integer;
  FPTable   	: string;
  FundLink  	: string;
  AssetLink		: string;
  Balance   	: extended;
  TmpBal    	: extended;
  SQLError		: boolean;
  f0          : integer;
  f1          : integer;
  S0          : string;
  S1          : string;
  DateFrom    : TDateTime;
  sdata				: ^string;

  ds					: char;
  ts					: char;
  sd					: string;
  st					: string;

begin
	SQLError := false;
  FPMainDataset.SQL.Text  := 'START TRANSACTION';
  try
	  FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
    	ErrorForm := TErrorForm.Create(Self);
      ErrorForm.ErrorExplanationMemo.Text 	:= 'При инициализации сохранения ФП произошла ошибка. Ответ сервера приведён ниже';
      ErrorForm.ErrorMemo.Text	 						:= 'Ошибка: ' + IntToStr(e.ErrorCode) + ', ';
      if e.StatusCode <> '' then
      	ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + 'Статус: ' + e.StatusCode + ', ';
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
    Exit;
  end;

  // check whether we have the same FP already approved
  FPMainDataset.SQL.Text  := 'SELECT`index`,`from`FROM ' + fplink + ' ORDER BY`index`DESC LIMIT 1';
  try
	  FPMainDataset.Open;
    f0 := FPMainDataset.FieldByName('index').AsInteger;
    DateFrom := FPMainDataset.FieldByName('from').AsDateTime;
  except
    on e: EZSQLException do begin
    	ErrorForm := TErrorForm.Create(Self);
      ErrorForm.ErrorExplanationMemo.Text 	:= 'При обращении к ДБ произошла ошибка. Ответ сервера приведён ниже.';
      ErrorForm.ErrorMemo.Text	 						:= 'Ошибка: ' + IntToStr(e.ErrorCode) + ', ';
      if e.StatusCode <> '' then
      	ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + 'Статус: ' + e.StatusCode + ', ';
     	ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + e.Message;
      ErrorForm.ShowModal;
      ErrorForm.Free;
    	SQLError := true;
    end;
  end;

  if f0 <> FPNum then begin
		Application.MessageBox(PWideChar('ФП №' + IntToStr(FPNum) + ' уже было одобрено. Форма распределения будет закрыта.'), 'Одобрение финансового планирования', MB_OK or MB_ICONERROR);
    New(sdata);
    sdata^ := IntToStr(f0) + ':' + DateTimeToStr(DateFrom, lFormatString);
    PostMessage(PWin.Handle, UM_FPWASAPPROVED, iOrgPrefix, integer(sdata));
    Exit;
  end;

  if RecordFP then begin // we have to check whether current moment is later than the "end FP period" and if not ask confirmation to change this date.
    FPMainDataset.SQL.Text  := 'SELECT now()<:ftd AS AB';
    FPMainDataset.ParamByName('ftd').AsDateTime := ToDate;
    FPMainDataset.Open;
    EarlyAppr		:= boolean(FPMainDataset.FieldByName('AB').AsInteger);    // true if FP was approved BEFORE the actual period end

    if EarlyAppr then begin
			if Application.MessageBox(PWideChar('Дата окончания ФП №' + IntToStr(FPNum) + ' ПОЗЖЕ, чем текущий момент времени. Дата окончания периода будет изменена.'), 'Одобрение финансового планирования', MB_OKCANCEL or MB_ICONWARNING) = IDOK then begin
        if LastRecDate > 0 then begin
          FPMainDataset.SQL.Text := 'UPDATE ' + fplink + ' SET`to`=:ato WHERE`index`=:aid';
          FPMainDataset.ParamByName('ato').AsDateTime := LastRecDate;
          FPMainDataset.ParamByName('aid').AsInteger  := FPNum;
          FPMainDataset.ExecSQL;
        end
        else begin
          FPMainDataset.SQL.Text := 'UPDATE ' + fplink + ' SET`to`=now() WHERE`index`=:aid';
          FPMainDataset.ParamByName('aid').AsInteger  := FPNum;
          FPMainDataset.ExecSQL;

          // pull the approving moment from the server
          FPMainDataset.SQL.Text := 'SELECT`to`FROM ' + fplink + ' WHERE`index`=:aid';
          FPMainDataset.ParamByName('aid').AsInteger  := FPNum;
          FPMainDataset.Open;
        	if FPMainDataset.RecordCount = 0 then begin
            raise Exception.Create('Failed to obtain approving date of last FP');
          end;
          LastRecDate := FPMainDataset.FieldByName('to').AsDateTime;
        end;

        ToDate := LastRecDate;
      end
      else begin
//       	if ApproveToolButton is visible, then the user has right to approve FP and we have to enable the button
	        ApproveToolButton.Enabled := ApproveToolButton.Visible;
      	Exit
      end;
    end;
  end;

  // first we have to save Income plan
	SaveIncPlan;

  // saving itself
  FPMainDataset.SQL.Text  := 'DELETE FROM ' + lfplink;
  try
	  FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
	    Globalvars.ShowError(Self, 'При сохранении ФП произошла ошибка. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
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
    Exit;
  end;

  if RecordFP and (Trunc(cm * 100) <> 0) then begin
    SQLError := not AssetsTransfer(cashlink, bill1link, cm, 'Перевод из приходной кассы на Cчёт № 1 на ФП №' + IntToStr(FPNum), OrgPrefix);
  end;

  for i := 0 to StrGrid.RowCount - 1 do begin
    if (Pos('a1__', StrGrid.Cells[0, i]) > 0) and (Length('a1__') < Length(StrGrid.Cells[0, i])) then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + lfplink + '(`index`,`1`,`2`,`3`,`4`,`5`,`6`)VALUES('+ StrGrid.Cells[1, i]+ ',"a1",NULL,NULL,NULL,:fCode,:fFond)';
      FPMainDataset.ParamByName('fCode').AsString     := MidStr(StrGrid.Cells[0, i], 5, 100);
      FundLink                                        := StrGrid.Cells[15, i];
      if (FundLink <> '') then begin
        FundLink                                      := GetLinkOfFondByName(FundList, FundLink);
      end;
      if (FundLink = '0') then begin
        FundLink                                      := '';
      end;
      FPMainDataset.ParamByName('fFond').AsString     := FundLink;
		  try
	  		FPMainDataset.ExecSQL;
		  except
    		on e: EZSQLException do begin
			    Globalvars.ShowError(Self, 'При сохранении ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
		  end;
      if SQLError then
      	break;
      if RecordFP then begin
      	// updating fund data
      	FPTmpDataset.SQL.Text := 'SELECT balance FROM ' + FundLink + ' WHERE`index`>1 ORDER by`index`DESC LIMIT 1';
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then
          Balance := FPTmpDataset.FieldByName('balance').AsFloat
        else
          Balance := 0;
        TmpBal := 0;
        if StrGrid.Cells[13, i] <> '' then
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13,i], '.', ','), ThSep, ''), TmpBal) then
            Balance := Balance + TmpBal;
        if not (Round(TmpBal*100) > 0 ) then
        	continue;
        FPTmpDataset.SQL.Text := 'INSERT INTO ' + FundLink + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES(NULL,NULL,0,NULL,0,:fBal,NOW(),:fData,:fSum,NULL)';
        FPTmpDataset.ParamByName('fBal').AsFloat    := Balance;
        FPTmpDataset.ParamByName('fData').AsAnsiString  := 'По ФП № '+ IntToStr(FPNum) + ': ' + StrGrid.Cells[2, i];
        FPTmpDataset.ParamByName('fSum').AsFloat    := TmpBal; //StrToFloat(ReplaceStr(StrGrid.Cells[13,i], ThSep, ''));
        FPTmpDataset.ExecSQL;
        Fond_Update(FundLink, Balance);
      	// updating assets data
        TransferAssets(TmpBal, FundLink, 'Перевод спецдохода (ФП № '+ IntToStr(FPNum) + '): "' + StrGrid.Cells[2, i] + '"'); // : string);
      end; // if RecordFP then begin
    end;

    if (StrGrid.Cells[0, i] = 'a1__') and
       ((StrGrid.Cells[2, i]<>'') or (StrGrid.Cells[8,i]<>'') or (StrGrid.Cells[11,i]<>'') or (StrGrid.Cells[13,i]<>'') or (StrGrid.Cells[15,i]<>'')) then begin
    	FPMainDataset.SQL.Text := 'INSERT INTO ' + lfplink + '(`index`,`1`,`2`,`3`,`4`,`5`,`6`)VALUES('+ StrGrid.Cells[1, i]+ ',"a1",:fDescr,:fSumSub,:fFormula,:fToPay,:fFond)';
      FPMainDataset.ParamByName('fDescr').AsAnsiString    := StrGrid.Cells[2, i];
      FPMainDataset.ParamByName('fSumSub').AsString   := ReplaceStr(StrGrid.Cells[8, i], ThSep, ''); // StrGrid.Cells[8, i];
      FPMainDataset.ParamByName('fFormula').AsString  := StrGrid.Cells[11,i];
      FPMainDataset.ParamByName('fToPay').AsString    := ReplaceStr(StrGrid.Cells[13,i], ThSep, '');
      FundLink                                        := GetLinkOfFondByName(FundList, StrGrid.Cells[15,i]);
      FPMainDataset.ParamByName('fFond').AsString     := FundLink;
		  try
	  		FPMainDataset.ExecSQL;
		  except
    		on e: EZSQLException do begin
			    Globalvars.ShowError(Self, 'При сохранении ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
		  end;
      if SQLError then
      	break;
      if RecordFP then begin
      	// updating fund data
        FPTmpDataset.SQL.Text := 'SELECT balance FROM ' + FundLink + ' WHERE`index`>1 ORDER by`index`DESC LIMIT 1';
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then
          Balance := FPTmpDataset.FieldByName('balance').AsFloat
        else
          Balance := 0;
        TmpBal := 0;
        if StrGrid.Cells[13,i] <> '' then begin
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13,i], '.', ','), ThSep, ''), TmpBal) then
            Balance := Balance + TmpBal;
        end;
        if not (Round(TmpBal*100) > 0 ) then
        	continue;
        FPTmpDataset.SQL.Text := 'INSERT INTO ' + FundLink + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES(NULL,NULL,0,NULL,0,:fBal,NOW(),:fData,:fSum,NULL)';
        FPTmpDataset.ParamByName('fBal').AsFloat    := Balance;
        FPTmpDataset.ParamByName('fData').AsAnsiString  := 'По ФП № '+ IntToStr(FPNum) + ': ' + StrGrid.Cells[2, i]; //StrGrid.Cells[2, i];
        FPTmpDataset.ParamByName('fSum').AsFloat    := TmpBal; //StrToFloat(ReplaceStr(StrGrid.Cells[13,i], ThSep, ''));
        FPTmpDataset.ExecSQL;
        Fond_Update(FundLink, Balance);
      	// updating assets data
        TransferAssets(TmpBal, FundLink, 'Перевод спецдохода(ФП № '+ IntToStr(FPNum) + '): "' + StrGrid.Cells[2, i] + '"'); // : string);
      end;
    end;

    if (StrGrid.Cells[0, i] = 'b__') and
        ((StrGrid.Cells[ 2, i] <> '') or (StrGrid.Cells[ 9, i] <> '') or (StrGrid.Cells[10, i] <> '') or
         (StrGrid.Cells[12, i] <> '') or (StrGrid.Cells[13, i] <> '') or (StrGrid.Cells[15, i] <> '')) then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + lfplink + '(`index`,`1`,`2`,`3`,`4`,`5`,`6`)VALUES('+ StrGrid.Cells[1, i]+ ',"b",:fDescr,"",:fPct,:fToPay,:fFond)';
      FPMainDataset.ParamByName('fDescr').AsAnsiString    := StrGrid.Cells[2, i];
      FPMainDataset.ParamByName('fPct').AsString      := StrGrid.Cells[12,i];
      FPMainDataset.ParamByName('fToPay').AsString    := ReplaceStr(StrGrid.Cells[13,i], ThSep, '');
      FundLink                                        := GetLinkOfFondByName(FundList, StrGrid.Cells[15,i]);
      FPMainDataset.ParamByName('fFond').AsString     := FundLink;
		  try
	  		FPMainDataset.ExecSQL;
		  except
    		on e: EZSQLException do begin
			    Globalvars.ShowError(Self, 'Невозможно сохранить ФП.', e.ErrorCode, e.StatusCode, e.Message + ' Section B.');
    			SQLError := true;
		    end;
		  end;
      if SQLError then
      	break;
      if RecordFP then begin
        FPTmpDataset.SQL.Text := 'SELECT balance FROM ' + FundLink + ' WHERE `index`>1 ORDER by `index` DESC LIMIT 1';
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then
          Balance := FPTmpDataset.FieldByName('balance').AsFloat
        else
          Balance := 0;
        TmpBal := 0;
        if StrGrid.Cells[13,i] <> '' then begin
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13,i], '.', ','), ThSep, ''), TmpBal) then
            Balance := Balance + TmpBal;
        end;
        if not (Round(TmpBal * 100) > 0 ) then
        	continue;
        FPTmpDataset.SQL.Text := 'INSERT INTO ' + FundLink + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES(NULL,NULL,0,NULL,0,:fBal,NOW(),:fData,:fSum,NULL)';
        FPTmpDataset.ParamByName('fBal').AsFloat    := Balance;
        FPTmpDataset.ParamByName('fData').AsAnsiString  := 'По ФП № '+ IntToStr(FPNum) + ': ' + StrGrid.Cells[2, i]; //StrGrid.Cells[2, i];
        FPTmpDataset.ParamByName('fSum').AsFloat    := TmpBal; //StrToFloat(ReplaceStr(StrGrid.Cells[13,i], ThSep, ''));
        FPTmpDataset.ExecSQL;
        Fond_Update(FundLink, Balance);
        TransferAssets(TmpBal, FundLink, 'Перевод по ФП № '+ IntToStr(FPNum) + ' : ' + StrGrid.Cells[2, i]); // : string);
      end;
    end;
    if (StrGrid.Cells[0, i] = 'c__') and
        ((StrGrid.Cells[ 2, i] <> '') or (StrGrid.Cells[ 9, i] <> '') or (StrGrid.Cells[10, i] <> '') or
         (StrGrid.Cells[12, i] <> '') or (StrGrid.Cells[13, i] <> '') or (StrGrid.Cells[15, i] <> '')) then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + lfplink + '(`index`,`1`,`2`,`3`,`4`,`5`,`6`)VALUES('+ StrGrid.Cells[1, i]+ ',"c",:fDescr,:fPerc,:fToPay,:fFond,"")';
      FPMainDataset.ParamByName('fDescr').AsAnsiString    := StrGrid.Cells[2, i];
      FPMainDataset.ParamByName('fPerc').AsString     := StrGrid.Cells[12, i];
      FPMainDataset.ParamByName('fToPay').AsString    := ReplaceStr(StrGrid.Cells[13,i], ThSep, '');
      FundLink                                        := GetLinkOfFondByName(FundList, StrGrid.Cells[15,i]);
      FPMainDataset.ParamByName('fFond').AsString     := FundLink;
		  try
	  		FPMainDataset.ExecSQL;
		  except
    		on e: EZSQLException do begin
			    Globalvars.ShowError(Self, 'При сохранении ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message + ' Section C.');
    			SQLError := true;
		    end;
		  end;
      if SQLError then
      	break;
      if RecordFP then begin
      	// updating fund data
        FPTmpDataset.SQL.Text := 'SELECT balance FROM ' + FundLink + ' WHERE`index`>1 ORDER by`index`DESC LIMIT 1';
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then
          Balance := FPTmpDataset.FieldByName('balance').AsFloat
        else
          Balance := 0;
        TmpBal := 0;
        if StrGrid.Cells[13, i] <> '' then begin
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13,i], '.', ','), ThSep, ''), TmpBal) then
            Balance := Balance + TmpBal;
        end;
        if not (Round(TmpBal*100) > 0 ) then
        	continue;
        FPTmpDataset.SQL.Text := 'INSERT INTO ' + FundLink + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES(NULL,NULL,0,NULL,0,:fBal,NOW(),:fData,:fSum,NULL)';
        FPTmpDataset.ParamByName('fBal').AsFloat    := Balance;
        FPTmpDataset.ParamByName('fData').AsAnsiString  := 'По ФП № '+ IntToStr(FPNum) + ': ' + StrGrid.Cells[2, i]; //StrGrid.Cells[2, i];
        FPTmpDataset.ParamByName('fSum').AsFloat    := TmpBal; //StrToFloat(ReplaceStr(StrGrid.Cells[13,i], ThSep, ''));
        FPTmpDataset.ExecSQL;
        Fond_Update(FundLink, Balance);
        TransferAssets(TmpBal, FundLink, 'Перевод по ФП № '+ IntToStr(FPNum) + ' : ' + StrGrid.Cells[2, i]); // : string);
      end;
    end;
    if (StrGrid.Cells[0, i] = 'd__') and
        (	(StrGrid.Cells[2,i]<>'') or (StrGrid.Cells[7,i]<>'') or (StrGrid.Cells[10,i]<>'') or (StrGrid.Cells[13,i]<>'') or
        	(StrGrid.Cells[15,i]<>'')
        ) then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + lfplink + '(`index`,`1`,`2`,`3`,`4`,`5`,`6`)VALUES('+ StrGrid.Cells[1, i] + ',"d",:fDescr,:fNote,:fToPay,:fFond,:fByFP1)';
      FPMainDataset.ParamByName('fDescr').AsAnsiString    := StrGrid.Cells[2, i];
      FPMainDataset.ParamByName('fNote').AsAnsiString     := StrGrid.Cells[10, i];
      FPMainDataset.ParamByName('fToPay').AsString    := ReplaceStr(StrGrid.Cells[13,i], ThSep, '');
      FundLink                                      	:= GetLinkOfFondByName(FundList, StrGrid.Cells[15,i]);
      FPMainDataset.ParamByName('fFond').AsString     := FundLink;
      FPMainDataset.ParamByName('fByFP1').AsString    := ReplaceStr(StrGrid.Cells[7, i], ThSep, '');
		  try
	  		FPMainDataset.ExecSQL;
		  except
    		on e: EZSQLException do begin
			    Globalvars.ShowError(Self, 'При сохранении ФП произошла ошибка. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
		  end;
      if SQLError then
      	break;
      if RecordFP then begin
        FPTmpDataset.SQL.Text := 'SELECT balance FROM ' + FundLink + ' WHERE `index`>1 ORDER by `index` DESC LIMIT 1';
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then
          Balance := FPTmpDataset.FieldByName('balance').AsFloat
        else
          Balance := 0;
        TmpBal := 0;
        if StrGrid.Cells[13,i] <> '' then begin
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13,i], '.', ','), ThSep, ''), TmpBal) then
            Balance := Balance + TmpBal;
        end;
        if not (Round(TmpBal*100) > 0 ) then
        	continue;
        FPTmpDataset.SQL.Text := 'INSERT INTO ' + FundLink + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES(NULL,NULL,0,NULL,0,:fBal,NOW(),:fData,:fSum,NULL)';
        FPTmpDataset.ParamByName('fBal').AsFloat    := Balance;
        FPTmpDataset.ParamByName('fData').AsAnsiString  := 'По ФП № '+ IntToStr(FPNum) + ': ' + StrGrid.Cells[2, i]; //StrGrid.Cells[2, i];
        FPTmpDataset.ParamByName('fSum').AsFloat    := TmpBal; //StrToFloat(ReplaceStr(StrGrid.Cells[13,i], ThSep, ''));
        FPTmpDataset.ExecSQL;
        Fond_Update(FundLink, Balance);
        TransferAssets(TmpBal, FundLink, 'Перевод по ФП № '+ IntToStr(FPNum) + ' : ' + StrGrid.Cells[2, i]); // : string);
      end;
    end;
    if (StrGrid.Cells[0, i] = 'e__') and
        ((StrGrid.Cells[2, i]<>'') or (StrGrid.Cells[11, i]<>'') or (StrGrid.Cells[13, i]<>'') or (StrGrid.Cells[15, i]<>'')) then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + lfplink + '(`index`,`1`,`2`,`3`,`4`,`5`,`6`)VALUES(' + StrGrid.Cells[1, i]+ ',"e",:fDescr,:fPerc,:fToPay,:fFond,"")';
      FPMainDataset.ParamByName('fDescr').AsAnsiString    := StrGrid.Cells[2, i];
      FPMainDataset.ParamByName('fPerc').AsString     := StrGrid.Cells[11, i];
      FPMainDataset.ParamByName('fToPay').AsString    := ReplaceStr(StrGrid.Cells[13,i], ThSep, '');
      FundLink                                        := GetLinkOfFondByName(FundList, StrGrid.Cells[15,i]);
      FPMainDataset.ParamByName('fFond').AsString     := FundLink;
		  try
	  		FPMainDataset.ExecSQL;
		  except
    		on e: EZSQLException do begin
			    Globalvars.ShowError(Self, 'При сохранении ФП произошла ошибка. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
		  end;
      if SQLError then
      	break;
      if RecordFP then begin
        FPTmpDataset.SQL.Text := 'SELECT balance FROM ' + FundLink + ' WHERE `index`>1 ORDER by `index` DESC LIMIT 1';
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then
          Balance := FPTmpDataset.FieldByName('balance').AsFloat
        else
          Balance := 0;
        TmpBal := 0;
        if StrGrid.Cells[13, i] <> '' then begin
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13,i], '.', ','), ThSep, ''), TmpBal) then
            Balance := Balance + TmpBal;
        end;
        if not (Round(TmpBal*100) > 0 ) then
        	continue;
        FPTmpDataset.SQL.Text := 'INSERT INTO ' + FundLink + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES(NULL,NULL,0,NULL,0,:fBal,NOW(),:fData,:fSum,NULL)';
        FPTmpDataset.ParamByName('fBal').AsFloat    := Balance;
        FPTmpDataset.ParamByName('fData').AsAnsiString  := 'По ФП № '+ IntToStr(FPNum) + ': ' + StrGrid.Cells[2, i]; //StrGrid.Cells[2, i];
        FPTmpDataset.ParamByName('fSum').AsFloat    := TmpBal; //StrToFloat(ReplaceStr(StrGrid.Cells[13,i], ThSep, ''));
        FPTmpDataset.ExecSQL;
        Fond_Update(FundLink, Balance);
        TransferAssets(TmpBal, FundLink, 'Перевод по ФП № '+ IntToStr(FPNum) + ' : ' + StrGrid.Cells[2, i]); // : string);
      end;
    end;
    if (StrGrid.Cells[0, i] = 'f__')  then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + lfplink + '(`index`,`1`,`2`,`3`,`4`,`5`,`6`)VALUES(' + StrGrid.Cells[1, i] +',"f",:fSumA,:fAppKind,:fDescr,:fFond,"")';
      if StrGrid.Cells[11,i] <> '' then begin
        TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[11,i], '.', ','), ThSep, ''), TmpBal);
        FPMainDataset.ParamByName('fSumA').AsFloat    :=  TmpBal; //StrToFloat(ReplaceStr(StrGrid.Cells[11,i], ThSep, ''))
      end
      else
        FPMainDataset.ParamByName('fSumA').AsString   :=  '';
      FPMainDataset.ParamByName('fAppKind').AsInteger :=  ApproveCombo.Items.IndexOf(StrGrid.Cells[9, i]);
      FPMainDataset.ParamByName('fDescr').AsAnsiString    :=  StrGrid.Cells[13, i];
      FundLink                                        :=  GetLinkOfFondByName(FundList, StrGrid.Cells[15,i]);
      FPMainDataset.ParamByName('fFond').AsString     :=  FundLink;
		  try
	  		FPMainDataset.ExecSQL;
		  except
    		on e: EZSQLException do begin
			    Globalvars.ShowError(Self, 'При сохранении ФП произошла ошибка. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
		  end;
      if SQLError then
      	break;
      if (RecordFP) and (ApproveCombo.Items.IndexOf(StrGrid.Cells[9, i])>0) then begin
        FPTmpDataset.SQL.Text :=
    			'UPDATE ' + polink + ' SET`suma`=:fSumA,`status`=:fStatus,`note`=:fNote,`fond`=:fFond,`fp`=:fFPNum,`signature`=:fSign WHERE `index`=' + StrGrid.Cells[1, i];
        TmpBal := 0;
        if (StrGrid.Cells[9,i] = 'Одобрить') or (StrGrid.Cells[9,i] = 'Отклонить') then begin
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[11,i], '.', ','), ThSep, ''), TmpBal) then
            Balance := Balance + TmpBal;
	        FPTmpDataset.ParamByName('fSumA').AsFloat :=  TmpBal; //StrToFloat(ReplaceStr(StrGrid.Cells[11,i], ThSep, ''));
          if (StrGrid.Cells[9,i] = 'Одобрить') then
	        	FPTmpDataset.ParamByName('fStatus').AsInteger := 2
          else
	        	FPTmpDataset.ParamByName('fStatus').AsInteger := 1;

	        FPTmpDataset.ParamByName('fNote').AsAnsiString   :=  StrGrid.Cells[13, i];
  	      FPTmpDataset.ParamByName('fFond').AsString   :=  FundLink;
    	    FPTmpDataset.ParamByName('fFPNum').AsInteger := FPNum;
  	      FPTmpDataset.ParamByName('fSign').AsString   := FPNameOfUser + '<br>' + FPPostsArr[iOrgPrefix];
    	    FPTmpDataset.ExecSQL;
        end;
      end;
    end;
  end; // for i := 0 to StrGrid.RowCount - 1 do begin

  // transfer assets to disbursment cash
  f0 := 0;
  s0 := 'UPDATE`' + polink + '`SET`bycash`=0 WHERE`index`IN(';
  f1 := 0;
  s1 := 'UPDATE`' + polink + '`SET`bycash`=1 WHERE`index`IN(';
  for i := 0 to POList.Count - 1 do begin
    if integer(POList.Objects[i]) <> integer(POrList.Objects[i]) then begin
      if integer(POList.Objects[i]) <> 0 then begin
        if f1 > 0 then begin
          s1 := s1 + ',' + POList[i]
        end
        else begin
          s1 := s1 + POList[i];
        end;
        inc(f1);
      end
      else begin // if integer(POList.Objects[i]) <> 0
        if f0 > 0 then begin
          s0 := s0 + ',' + POList[i]
        end
        else begin
          s0 := s0 + POList[i];
        end;
        inc(f0);
      end
    end
  end;
  if (f0 > 0) and (not SQLError) then begin
    FPMainDataset.SQL.Text := s0 + ')';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
	  	  Globalvars.ShowError(Self, 'При обновлении данных о заявках произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
   		  SQLError := true;
      end;
    end;
  end;
  if (f1 > 0) and (not SQLError) then begin
    FPMainDataset.SQL.Text := s1 + ')';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
	  	  Globalvars.ShowError(Self, 'При обновлении данных о заявках произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
   		  SQLError := true;
      end;
    end;
  end;

  // Record FP and create new one
  if RecordFP then begin
    // transfer assets to disbursment cash
    for i := 0 to AcToDC.Count - 1 do begin
      j := BAList.IndexOf(AcToDC[i]);
      if (j >= 0) and (j < BAList.Count) then begin
        SQLError := not AssetsTransfer(AcToDC[i], OrgPrefix + DISBCASH_LINK, extended(pointer(AcToDC.Objects[i])^), 'Перевод в расходную кассу по ФП № ' + IntToStr(FPNum) + '. Источник: ' + string(pointer(BAList.Objects[j])^) , OrgPrefix);
      end
      else begin
        SQLError := true;
      end;
      if SQLError then
        break;
    end;

//  put the income source values to the stats
    // reomve old values if they exist (it's impossible, but possible)
    s1 := '';
    FPMainDataset.SQL.Text  := 'DELETE FROM statvalues WHERE Date=:ftd AND StatID IN(';
    for i := Low(IncByIS) to High(IncByIS) do begin
      j := ISBySID[i];
      if(j > 0) then begin
        if s1 <> '' then s1 := s1 + ',';
        s1 := s1 + IntToStr(j);
      end
    end;

    if(s1 <> '') then begin
      FPMainDataset.SQL.Text  := FPMainDataset.SQL.Text + s1 + ')';
      FPMainDataset.ParamByName('ftd').AsDate := ToDate;
      FPMainDataset.ExecSQL;
    end;

    s1 := '';
    FPMainDataset.SQL.Text  := 'INSERT INTO statvalues(StatID,Value,Date)VALUES';
    for i := Low(IncByIS) to High(IncByIS) do begin
      j := ISBySID[i];
      if(j > 0) then begin
        if s1 <> '' then s1 := s1 + ',';
        s1 := s1 + '(' + IntToStr(j) + ',' + FloatToStr(IncByIS[i], SQLFormatString) + ',' + DateToStr(ToDate, SQLFormatString) + ')';
      end
    end;
    if s1 <> '' then begin
	    FPMainDataset.SQL.Text  := FPMainDataset.SQL.Text + s1;
  	  FPMainDataset.ExecSQL;
    end;

//  put the income source values to the stats - end of
    FPMainDataset.SQL.Text  := 'UPDATE`' + fplink + '`SET`aprvd`=1 WHERE`index`=:fi';
    FPMainDataset.ParamByName('fi').AsInteger := FPNum;
    FPMainDataset.ExecSQL;

    FPTable := fplink + IntToStr(FPNum);

    FPMainDataset.SQL.Text  := 'CREATE TABLE IF NOT EXISTS '+ FPTable + ' SELECT * FROM ' + lfplink; // this to be rewritten because of incorrect engine set in result table
    FPMainDataset.ExecSQL;

    FPMainDataset.SQL.Text  := 'INSERT INTO ' + fplink + '(`index`,`from`,`to`,`plan`)VALUES(NULL,:ffd,NULL,NULL)';
    FPMainDataset.ParamByName('ffd').AsDateTime := ToDate;
    FPMainDataset.ExecSQL;
  end;

  FPWasChanged  := false;
  SaveToolButton.Enabled := FPWasChanged;

  if SQLError then begin
	  FPMainDataset.SQL.Text  := 'ROLLBACK';
    try
    	FPMainDataset.ExecSQL;
	  except
   		on e: EZSQLException do begin
   			SQLError := true;
	    end;
    end;
  end;

  if not SQLError then begin
    FPMainDataset.SQL.Text  := 'COMMIT';
    try
  	  FPMainDataset.ExecSQL;
	  except
   		on e: EZSQLException do begin
		    Globalvars.ShowError(Self, 'При сохранении ФП произошла ошибка. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
   			SQLError := true;
	    end;
    end;
  end;

	ApproveToolButton.Enabled := true;
  if (RecordFP) and (not SQLError) then begin
    New(sdata);
    if EarlyAppr then
	    sdata^ := IntToStr(FPNum) + ': ' + DateTimeToStr(LastRecDate, FormatString)
  	else
    	sdata^ := IntToStr(FPNum) + ': ' + DateTimeToStr(ToDate, FormatString);
{$IFDEF TLOG}
		AddToLog(LC_FPAPPRVD, LT_BC, IntToStr(iOrgPrefix) + ':' + IntToStr(FPNum) + ':' + ToDateS, FPLogin); //FPNameOfUser)
{$ENDIF}
    SendMessage(PWin.Handle, UM_FPWASAPPROVED, iOrgPrefix, integer(sdata));
  	Application.MessageBox('Финансовое планирование успешно одобрено.', 'Финансовое планирование', MB_OK or MB_ICONINFORMATION);
  end;
end;

procedure TFPAllocForm.btnSaveIncPlanClick(Sender: TObject);
begin
  if RVEditor.ReadOnly then Exit;

  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

	SaveIncPlan;
end;

procedure TFPAllocForm.RecalcFP;
var
  i         : integer;
  TmpResult : extended;
  TmpResult1: extended;
  TotA1			: extended;
  TotB      : extended;
  TotC      : extended;
  TotD      : extended;
  TotE      : extended;
  TotPO			: extended;

  TotBalC   : extended;
  TotBalD   : extended;
  TotBalF   : extended;
  TotBalE   : extended;
  TotBalTot : extended;
  TotCGI    : extended;
  GI				: extended;
  TotGI     : extended;
	GTENum		: integer;
  Accounts  : TStringList;
  j         : integer;
  k         : integer;
  PSum      : ^extended;
  TmpSum    : extended;

  FP1PSUM   : extended;
  FP1RSUM   : extended;

  l         : integer;

  pfx       : string;
  srestsok  : boolean;

begin
  AcToDC.Clear;

	ErrorPresent 			:= false;
  ApproveToolButton.Enabled := true;
  TotB  := 0;
  TotBalF := 0;
  if not ReadOnly then
    ClearFundsTree;

  FP1PSUM := 0;
  FP1RSUM := 0;
  srestsok:= true;

  for I := 0 to StrGrid.RowCount - 1 do begin
    if Pos('a__', StrGrid.Cells[0, i]) > 0 then begin
      if TryStrToFloat(ReplaceStr(StrGrid.Cells[2, i], ThSep, ''), TmpResult) then
          TotGI := TotGI + TmpResult;
    end;

    if Pos('tgi__', StrGrid.Cells[0, i]) > 0 then begin
      StrGrid.Cells[4, i] := MyFloatToStr(TotGI);
    end;

    if Pos('a1__', StrGrid.Cells[0, i]) > 0	then begin
      if Length(StrGrid.Cells[0, i]) > Length('a1__') then begin // it's a read-only line
        if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13, i], '.', ','), ThSep, ''), TmpResult1) then begin
          StrGrid.Cells[13, i] := MyFloatToStr(TmpResult1);
          if not ReadOnly then
            AddSumToFFL(TmpResult1, StrGrid.Cells[15, i]);
        end
        else
          StrGrid.Cells[13, i] := '';
				TotA1	:= TotA1 + TmpResult1;
      end
      else begin // it's a hand-made line
	      if StrGrid.Cells[8,i] <> '' then begin
  	      if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[8, i], '.', ','), ThSep, ''), TmpResult1) then
    	      StrGrid.Cells[8, i] := MyFloatToStr(TmpResult1);
        end;
///
        if StrGrid.Cells[11,i] <> '' then begin // '%'
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[11, i], '.', ','), ThSep, ''), TmpResult) then
            StrGrid.Cells[11, i] := MyFloatToStr(TmpResult)
          else
            StrGrid.Cells[11, i] := '';
        end;

        if StrGrid.Cells[11,i] <> '' then begin
          StrGrid.Cells[13, i] := MyFloatToStr(TotGI * TmpResult / 100);
        end
        else begin
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13, i], '.', ','), ThSep, ''), TmpResult1) then
            StrGrid.Cells[13, i] := MyFloatToStr(TmpResult1);
        end;

  	    if TryStrToFloat(ReplaceStr(StrGrid.Cells[13, i], ThSep, ''), TmpResult) then begin
	    	  TotA1	:= TotA1 + TmpResult;
          if not ReadOnly then AddSumToFFL(TmpResult, StrGrid.Cells[15, i]);
        end;
      end; // it's a hand-made line

      // check wether all proper cells are
    	if ApproveToolButton.Visible and ApproveToolButton.Enabled then begin //
        if not ErrorPresent then begin
	        ErrorPresent :=	not(((StrGrid.Cells[15, i] <> '') and (StrGrid.Cells[13, i] <> '') and (StrGrid.Cells[2, i] <> '')) or
  	        ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')));
          if ErrorPresent then begin
            // if a line is not empty
	          if not ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')) then begin
		          ErrRow := i;
  		        if StrGrid.Cells[2, i] = '' then begin
      	        ErrCol := 2;
              end
          	  else if StrGrid.Cells[13, i] = '' then begin
            	  ErrCol := 13;
              end
  	          else if StrGrid.Cells[15, i] = '' then begin
    	          ErrCol := 15;
              end
            end;
          end;
        end; // if not ErrorPresent then begin
      end; // if ApproveToolButton.Visible and ApproveToolButton.Enabled then begin
    end; // // Pos('a1__', StrGrid.Cells[0, i]) > 0

    if Pos('a1t__', StrGrid.Cells[0, i]) > 0 then begin
      StrGrid.Cells[11, i] := MyFloatToStr(TotA1);
    end;

    if Pos('gi__', StrGrid.Cells[0, i]) > 0 then begin
	    GI := TotGI - TotA1;
      StrGrid.Cells[4, i] := MyFloatToStr(GI);
      if (Trunc(GI * 100) < 0) then begin
        ErrorPresent := true;
        srestsok := false;
        ErrRow := i;
        ErrCol := 4;
      end;
    end;

    if (Pos('b__', StrGrid.Cells[0, i]) > 0) then begin //or (Pos('a1__', StrGrid.Cells[0, i]) > 0)
      if StrGrid.Cells[9, i] <> '' then begin
        if TryStrToFloat(MyCleanStr(StrGrid.Cells[9, i]), TmpResult1) then
          StrGrid.Cells[9, i] := MyFloatToStr(TmpResult1);
      end;
      if StrGrid.Cells[10, i] <> '' then begin
        if TryStrToFloat(MyCleanStr(StrGrid.Cells[10, i]), TmpResult1) then begin
          StrGrid.Cells[10, i] := MyFloatToStr(TmpResult1);
          FP1PSUM := FP1PSUM + TmpResult1;
        end;
      end;
      if StrGrid.Cells[12, i] <> '' then begin // '%'
        if TryStrToFloat(MyCleanStr(StrGrid.Cells[12, i]), TmpResult) then
          StrGrid.Cells[12, i] := MyFloatToStr(TmpResult)
        else
          StrGrid.Cells[12, i] := '';
      end;
      if StrGrid.Cells[12,i] <> '' then begin
        StrGrid.Cells[13, i] := MyFloatToStr(GI * TmpResult / 100);
      end
      else begin
        if TryStrToFloat(MyCleanStr(StrGrid.Cells[13, i]), TmpResult1) then StrGrid.Cells[13, i] := MyFloatToStr(TmpResult1);
      end;
      if TryStrToFloat(ReplaceStr(StrGrid.Cells[13, i], ThSep, ''), TmpResult) then begin
        TotB 	:= TotB + TmpResult;
        if not ReadOnly then AddSumToFFL(TmpResult, StrGrid.Cells[15, i]);
      end;
      if ApproveToolButton.Visible and ApproveToolButton.Enabled then
      	if not ErrorPresent then begin
	      	ErrorPresent :=	not(((StrGrid.Cells[15, i] <> '') and (StrGrid.Cells[13, i] <> '') and (StrGrid.Cells[2, i] <> '')) or
  	        ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')));
    	    if ErrorPresent then begin
          	// if a line is not empty
            if not ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')) then begin
	            ErrRow := i;
  	          if StrGrid.Cells[2, i] = '' then begin
              	ErrCol := 2;
    	        end
              else if StrGrid.Cells[13, i] = '' then begin
              	ErrCol := 13;
    	        end
              else if StrGrid.Cells[15, i] = '' then begin
              	ErrCol := 15;
    	        end
            end;
          end;
        end; // if not ErrorPresent then begin
    end; // Pos('b__', StrGrid.Cells[0, i]) > 0
    if Pos('bt__', StrGrid.Cells[0, i]) > 0 then begin
      StrGrid.Cells[11, i] := MyFloatToStr(TotB);
    end;
    if Pos('c__', StrGrid.Cells[0, i]) > 0 then begin
      if StrGrid.Cells[9, i] <> '' then begin
        if TryStrToFloat(MyCleanStr(StrGrid.Cells[9, i]), TmpResult1) then
          StrGrid.Cells[9, i] := MyFloatToStr(TmpResult1);
      end;
      if StrGrid.Cells[10, i] <> '' then begin
        if TryStrToFloat(MyCleanStr(StrGrid.Cells[10, i]), TmpResult1) then begin
          StrGrid.Cells[10, i] := MyFloatToStr(TmpResult1);
          FP1PSUM := FP1PSUM + TmpResult1;
        end;
      end;
//
      if StrGrid.Cells[12,i] <> '' then // '%'
        if TryStrToFloat(MyCleanStr(StrGrid.Cells[12, i]), TmpResult) then
          StrGrid.Cells[12, i] := MyFloatToStr(TmpResult)
        else
          StrGrid.Cells[12, i] := '';
      if StrGrid.Cells[12,i] <> '' then begin
        StrGrid.Cells[13, i] := MyFloatToStr(TotCGI * TmpResult / 100);
      end;
///
      if TryStrToFloat(ReplaceStr(StrGrid.Cells[13, i], ThSep, ''), TmpResult) then begin
        TotC := TotC + TmpResult;
        if not ReadOnly then
          AddSumToFFL(TmpResult, StrGrid.Cells[15, i]);
      end;
      if ApproveToolButton.Visible and ApproveToolButton.Enabled then
      	if not ErrorPresent then begin
	      	ErrorPresent :=	not(((StrGrid.Cells[15, i] <> '') and (StrGrid.Cells[13, i] <> '') and (StrGrid.Cells[2, i] <> '')) or
  	        ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')));
    	    if ErrorPresent then begin
          	// if a line is not empty
            if not ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')) then begin
	            ErrRow := i;
  	          if StrGrid.Cells[2, i] = '' then begin
              	ErrCol := 2;
    	        end
              else if StrGrid.Cells[13, i] = '' then begin
              	ErrCol := 13;
    	        end
              else if StrGrid.Cells[15, i] = '' then begin
              	ErrCol := 15;
    	        end
            end;
          end;
        end; // if not ErrorPresent then begin
    end;
    if Pos('ct__', StrGrid.Cells[0, i]) > 0 then begin
      StrGrid.Cells[11, i] := MyFloatToStr(TotC);
    end;
    if Pos('b_cgi__', StrGrid.Cells[0, i]) > 0 then begin
      TotCGI := GI - TotB;
      StrGrid.Cells[4, i] := MyFloatToStr(TotCGI);
      if (Trunc(TotCGI * 100) < 0) then begin
        ErrorPresent := true;
        srestsok := false;
        ErrRow := i;
        ErrCol := 4;
      end;
    end;

    if Pos('c_cgi__', StrGrid.Cells[0, i]) > 0 then begin
      TotBalC := TotCGI - TotC;
      StrGrid.Cells[4, i] := MyFloatToStr(TotBalC);
      if (Trunc(TotBalC * 100) < 0) then begin
        ErrorPresent := true;
        srestsok := false;
        ErrRow := i;
        ErrCol := 4;
      end;
    end;
    if Pos('fp1t__', StrGrid.Cells[0, i]) > 0 then begin
      StrGrid.Cells[10, i] := MyFloatToStr(FP1PSUM);
      StrGrid.Cells[13, i] := MyFloatToStr(TotC + TotB);
    end;
    if Pos('d__', StrGrid.Cells[0, i]) > 0 then begin
      if TryStrToFloat(ReplaceStr(StrGrid.Cells[13, i], ThSep, ''), TmpResult) then begin
        TotD := TotD + TmpResult;
        if not ReadOnly then begin
          if StrGrid.Cells[15, i] <> '' then begin
            AddSumToFFL(TmpResult, StrGrid.Cells[15, i]);
          end
        end
      end;
      if ApproveToolButton.Visible and ApproveToolButton.Enabled then begin
      	if not ErrorPresent then begin
	      	ErrorPresent :=	not(((StrGrid.Cells[15, i] <> '') and (StrGrid.Cells[13, i] <> '') and (StrGrid.Cells[2, i] <> '')) or
  	        ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')));
    	    if ErrorPresent then begin
          	// if a line is not empty
            if not ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')) then begin
	            ErrRow := i;
  	          if StrGrid.Cells[2, i] = '' then begin
              	ErrCol := 2;
    	        end
              else if StrGrid.Cells[13, i] = '' then begin
              	ErrCol := 13;
    	        end
              else if StrGrid.Cells[15, i] = '' then begin
              	ErrCol := 15;
    	        end
            end;
          end;
        end; // if not ErrorPresent then begin
      end;
    end;
    if Pos('dt__', StrGrid.Cells[0, i]) > 0 then begin
      StrGrid.Cells[11, i] := MyFloatToStr(TotD);
    end;
    if Pos('d_cgi__', StrGrid.Cells[0, i]) > 0 then begin
      TotBalD := TotBalC - TotD;
      StrGrid.Cells[4, i] := MyFloatToStr(TotBalD);
      FPBalD := TotBalD;
      if (Trunc(TotBalD * 100) < 0) then begin
        ErrorPresent := true;
        srestsok := false;
        ErrRow := i;
        ErrCol := 4;
      end;
    end;
    if Pos('f__', StrGrid.Cells[0, i]) > 0 then begin
      if StrGrid.Cells[9, i] <> 'Одобрить' then begin
        StrGrid.Cells[11, i] := '';
      end;
      if ((StrGrid.Cells[9, i] = 'Одобрить')) and TryStrToFloat(ReplaceStr(StrGrid.Cells[11, i], ThSep, ''), TmpResult) then begin
        TotPO	:= TotPO + TmpResult;
        if not ReadOnly then begin
          if StrGrid.Cells[15, i] <> '' then begin
            AddPOSumToFFL(TmpResult, StrGrid.Cells[15, i]);
          end
        end;
        if POList.Find(StrGrid.Cells[1, i], k) and (k >=0) and (k < POList.Count) and (integer(POList.Objects[k]) = 1) then begin
        	if StrGrid.Cells[15, i] <> '' then begin
            pfx := GetAssetOfFundByName(FundList, StrGrid.Cells[15, i]);
            if pfx = '' then
              continue;
            TmpSum := 0;
            TryStrToFloat(MyCleanStr(StrGrid.Cells[12, i]), TmpSum);
            if Trunc(TmpSum * 100) = 0 then
            	continue;

            k := AcToDC.IndexOF(pfx);
            if k < 0 then begin
            	New(PSum);
              PSum^ := TmpSum;
              AcToDC.AddObject(pfx, pointer(PSum))
            end
            else begin
            	PSum := pointer(AcToDC.Objects[k]);
              PSum^ := PSum^ + TmpSum;
            end;
          end; // if StrGrid.Cells[15, j] <>
        end;
	      if ApproveToolButton.Visible and ApproveToolButton.Enabled then begin
  	    	if not ErrorPresent then begin
	  	    	ErrorPresent :=	StrGrid.Cells[15, i] = '';
    	    	if ErrorPresent then begin
          		// we cannot approve the PO without fund to take money from
              ErrRow := i;
   	          ErrCol := 15;
	          end;
  	      end; // if not ErrorPresent then begin
    	  end;
      end; // if ((... "Одобрить"
    end;
    if Pos('ftwf__', StrGrid.Cells[0, i]) > 0 then begin
       StrGrid.Cells[11, i] := MyFloatToStr(TotPO);
    end;
    if Pos('ft__', StrGrid.Cells[0, i]) > 0 then begin
      TotBalF := TotBalD; //TotPO;
      StrGrid.Cells[4, i] := MyFloatToStr(TotBalF);
      if (Trunc( TotBalF * 100) < 0) then begin
        ErrorPresent := true;
        srestsok := false;
        ErrRow := i;
        ErrCol := 4;
      end;
    end;
    if Pos('e__', StrGrid.Cells[0, i]) > 0 then begin
      if StrGrid.Cells[11,i] <> '' then begin  // if a perccentage exists
        if TryStrToFloat(ReplaceStr(StrGrid.Cells[11, i], ThSep, ''), TmpResult) then begin
          if TotBalF > 0 then
            TmpResult := TotBalF * TmpResult/100
          else
            TmpResult := 0;
          StrGrid.Cells[13, i] := MyFloatToStr(TmpResult);
        end;
      end;
      if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[13, i], '.', ','), ThSep, ''), TmpResult) then begin
        TotE := TotE + TmpResult;
        StrGrid.Cells[13, i] := MyFloatToStr(TmpResult);
        if not ReadOnly then begin
          if StrGrid.Cells[15, i] <> '' then begin
            AddSumToFFL(TmpResult, StrGrid.Cells[15, i]);
          end
        end
      end;

      if ApproveToolButton.Visible and ApproveToolButton.Enabled then
      	if not ErrorPresent then begin
	      	ErrorPresent :=	not(((StrGrid.Cells[15, i] <> '') and (StrGrid.Cells[13, i] <> '') and (StrGrid.Cells[2, i] <> '')) or
  	        ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')));
    	    if ErrorPresent then begin
          	// if a line is not empty
            if not ((StrGrid.Cells[15, i] = '') and (StrGrid.Cells[13, i] = '') and (StrGrid.Cells[2, i] = '')) then begin
	            ErrRow := i;
  	          if StrGrid.Cells[2, i] = '' then begin
              	ErrCol := 2;
    	        end
              else if StrGrid.Cells[13, i] = '' then begin
              	ErrCol := 13;
    	        end
              else if StrGrid.Cells[15, i] = '' then begin
              	ErrCol := 15;
    	        end
            end;
          end;
        end; // if not ErrorPresent then begin
    end;
    if Pos('et__', StrGrid.Cells[0, i]) > 0 then begin
       StrGrid.Cells[11, i] := MyFloatToStr(TotE);
    end;
    if Pos('gt__', StrGrid.Cells[0, i]) > 0 then begin
    	GTENum	:= i;
    end;
  end;
  FPBal 											:= TotBalF - TotE;
  StrGrid.Cells[4, GTENum] 		:= MyFloatToStr(FPBal);

 	BalanceIsNotNull := MyFloatToStr(FPBal) <> MyFloatToStr(0);
  if BalanceIsNotNull and (not ErrorPresent) then begin
    ErrCol 	:= 4;
    ErrRow	:=  GTENum;
  end;

// recalculating the money to be transferred
// removing the old account lines
  FFromRecalc  := true;
  for I := 1 to StrGrid.RowCount - 1 do begin
    if (StrGrid.Cells[0, i] = 'h__') and (LeftStr(StrGrid.Cells[1, i], 2) = 'G.') then break;
  end;
  Inc(i);

  Accounts := TStringList.Create;
  Accounts.Clear;
  for j := 1 to i do begin
    pfx := StrGrid.Cells[0, j];
  	if (pfx = 'b__') or (Pos('a1__', pfx) > 0) or (pfx = 'c__') or (pfx = 'd__') or (pfx = 'e__') then begin
    	if StrGrid.Cells[15, j] <> '' then begin
        pfx := GetAssetOfFundByName(FundList, StrGrid.Cells[15, j]);
        TmpSum := 0;
        TryStrToFloat(MyCleanStr(StrGrid.Cells[13, j]), TmpSum);
//        if not (Round(TmpSum*100) > 0) then
        if Trunc(TmpSum * 100) = 0 then
        	continue;

        k := Accounts.IndexOF(pfx);
        if k < 0 then begin
        	New(PSum);
          PSum^ := TmpSum;
//          Accounts.AddObject(FPMainDataset.FieldByName('assetlink').AsString, pointer(PSum))
          Accounts.AddObject(pfx, pointer(PSum))
        end
        else begin
        	PSum  := pointer(Accounts.Objects[k]);
          PSum^ := PSum^ + TmpSum;
        end;
      end; // if StrGrid.Cells[15, j] <>
    end //
  end;

//	for j := 0 to Accounts.Count - 1 do begin
  k := MaxInt(AcToDC.Count, Accounts.Count) - 1;
	for j := 0 to k do begin
    // left part - transfers from Bill #1 to other bank accounts
    StrGrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := 'acn__'; //
    StrGrid.MergeCells(1, i, 5, 1);
    StrGrid.MergeCells(6, i, 3, 1);
    if j <= Accounts.Count - 1 then begin
      l := BAList.IndexOf(Accounts[j]);
      if (l >= 0) and (l < BAList.Count) then begin
        StrGrid.Cells[1, i] := string(pointer(BAList.Objects[l])^);
        PSum := pointer(Accounts.Objects[j]);
        StrGrid.Cells[6, i] := MyFloatToStr(PSum^);
      end
      else begin
        StrGrid.Cells[1, i] := '';
        StrGrid.Cells[6, i] := '';
      end
    end
    else begin
      StrGrid.Cells[1, i] := '';
      StrGrid.Cells[6, i] := '';
    end;

    // right part - transfers from accounts to disbursment cash
    StrGrid.MergeCells(10, i, 5, 1);
    StrGrid.MergeCells(15, i, 2, 1);
    if j <= AcToDC.Count - 1 then begin
      l := BAList.IndexOf(AcToDC[j]);
      if (l >= 0) and (l < BAList.Count) then begin
        StrGrid.Cells[10, i] := string(pointer(BAList.Objects[l])^);
        PSum := pointer(AcToDC.Objects[j]);
        StrGrid.Cells[15, i] := MyFloatToStr(PSum^);
      end
      else begin
        StrGrid.Cells[10, i] := '';
        StrGrid.Cells[15, i] := '';
      end
    end
    else begin
      StrGrid.Cells[10, i] := '';
      StrGrid.Cells[15, i] := '';
    end;
    Inc(i);
  end;
  Accounts.Free;

  // Adding an empty string
	StrGrid.SplitRowCells(i);
  StrGrid.MergeCells(1, i, 16, 1);
  StrGrid.Cells[1, i] := '';
  Inc(i);

  if not ReadOnly then
		RecalcFundsRests;

  ffromRecalc := false;
	StrGrid.RowCount := i;
// end of recalculating
  StatusBar.Repaint;

  if not ReadOnly then begin
    SearchSubZeroFund;
    if SubZeroFundExists  then begin
      Application.MessageBox('В фондах не хватает средств (в таблице списке фондов они выделены красным цветом).',
                             'Финансовое планирование', MB_OK or MB_ICONERROR)
    end;
  end;

  if not ReadOnly then
    ApproveToolButton.Enabled := (not BalanceIsNotNull) and (not SubZeroFundExists) and srestsok;
end;

procedure TFPAllocForm.btnAlignRightClick(Sender: TObject);
begin
  if FUpdating then Exit;
	RVEditor.ApplyParaStyleConversion(PARA_ALIGNRIGHT);
end;

procedure TFPAllocForm.RowAddToolButtonClick(Sender: TObject);
var
  AddedRowNum : integer;
begin
  if (LeftStr(StrGrid.Cells[0, StrGrid.SelectedRow[0]], Length('a1__')) = 'a1__') then begin
    AddedRowNum := StrGrid.SelectedRow[0] + 1;
    while LeftStr(StrGrid.Cells[0, AddedRowNum], Length('a1__')) = 'a1__' do
      Inc(AddedRowNum);
    StrGrid.InsertNormalRow(AddedRowNum);
    StrGrid.Cells[0, AddedRowNum] := 'a1__';
    StrGrid.Cells[1, AddedRowNum] := IntToStr(StrToInt(StrGrid.Cells[1, AddedRowNum-1])+1);
    StrGrid.MergeCells(2, AddedRowNum, 9, 1);             // Наименование
    StrGrid.Cells[2, AddedRowNum] := '';
    StrGrid.MergeCells(11, AddedRowNum, 2, 1);
    StrGrid.Cells[11, AddedRowNum] :=  '';                //'Формула';
    StrGrid.MergeCells(13, AddedRowNum, 2, 1);
    StrGrid.Cells[13, AddedRowNum] := '';                 //'К выплате';
    StrGrid.MergeCells(15, AddedRowNum, 2, 1);
    StrGrid.Cells[15, AddedRowNum] := '';                 //
    Inc(GIStrNum);
    RecalcFP;
  end; // if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'a1__')
  if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'b__') then begin
    AddedRowNum := StrGrid.SelectedRow[0] + 1;
    while StrGrid.Cells[0, AddedRowNum] = 'b__' do
      Inc(AddedRowNum);
    StrGrid.InsertNormalRow(AddedRowNum);
    StrGrid.Cells[0, AddedRowNum] := 'b__';
    StrGrid.Cells[1, AddedRowNum] := IntToStr(StrToInt(StrGrid.Cells[1, AddedRowNum-1])+1);
    StrGrid.MergeCells(2, AddedRowNum, 7, 1);
    StrGrid.Cells[2, AddedRowNum] := '';
    StrGrid.Cells[9, AddedRowNum] := '';
    StrGrid.MergeCells(10, AddedRowNum, 2, 1);
    StrGrid.Cells[10, AddedRowNum] :=  '';
    StrGrid.Cells[12, AddedRowNum] :=  '';
    StrGrid.MergeCells(13, AddedRowNum, 2, 1);
    StrGrid.Cells[13, AddedRowNum] := '';
    StrGrid.MergeCells(15, AddedRowNum, 2, 1);
    StrGrid.Cells[15, AddedRowNum] := '';
  end; // if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'b__')
  if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'c__') then begin
    AddedRowNum := StrGrid.SelectedRow[0] + 1;
    while StrGrid.Cells[0, AddedRowNum] = 'c__' do
      Inc(AddedRowNum);
    StrGrid.InsertNormalRow(AddedRowNum);
    StrGrid.Cells[0, AddedRowNum] := 'c__';
    StrGrid.Cells[1, AddedRowNum] := IntToStr(StrToInt(StrGrid.Cells[1, AddedRowNum-1])+1);
    StrGrid.MergeCells(2, AddedRowNum, 7, 1);
    StrGrid.Cells[2, AddedRowNum] := '';
    StrGrid.Cells[9, AddedRowNum] := '';
    StrGrid.MergeCells(10, AddedRowNum, 2, 1);
    StrGrid.Cells[10, AddedRowNum] :=  '';
    StrGrid.Cells[12, AddedRowNum] :=  '';
    StrGrid.MergeCells(13, AddedRowNum, 2, 1);
    StrGrid.Cells[13, AddedRowNum] := '';
    StrGrid.MergeCells(15, AddedRowNum, 2, 1);
    StrGrid.Cells[15, AddedRowNum] := '';
  end; // if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'с__')
  if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'd__') then begin
    AddedRowNum := StrGrid.SelectedRow[0] + 1;
    while StrGrid.Cells[0, AddedRowNum] = 'd__' do
      Inc(AddedRowNum);
    StrGrid.InsertNormalRow(AddedRowNum);
    StrGrid.Cells[0, AddedRowNum] := 'd__';
    StrGrid.Cells[1, AddedRowNum] := IntToStr(StrToInt(StrGrid.Cells[1, AddedRowNum-1])+1);

    StrGrid.MergeCells(2, AddedRowNum, 5, 1);
    StrGrid.Cells[2, AddedRowNum] := '';                // Наименование
    StrGrid.MergeCells(7, AddedRowNum, 3, 1);
    StrGrid.Cells[7, AddedRowNum] := '';                // По ФП №1
    StrGrid.MergeCells(10, AddedRowNum, 3, 1);
    StrGrid.Cells[10, AddedRowNum] := '';               // Примечание
    StrGrid.MergeCells(13, AddedRowNum, 2, 1);
    StrGrid.Cells[13, AddedRowNum] :=  '';              //Сумма
    StrGrid.MergeCells(15, AddedRowNum, 2, 1);
    StrGrid.Cells[15, AddedRowNum] := '';
  end; // if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'd__')
  if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'e__') then begin
    AddedRowNum := StrGrid.SelectedRow[0] + 1;
    while StrGrid.Cells[0, AddedRowNum] = 'e__' do
      Inc(AddedRowNum);
    StrGrid.InsertNormalRow(AddedRowNum);
    StrGrid.Cells[0, AddedRowNum] := 'e__';
    StrGrid.Cells[1, AddedRowNum] := IntToStr(StrToInt(StrGrid.Cells[1, AddedRowNum-1])+1);
    StrGrid.MergeCells(2, AddedRowNum, 9, 1);
    StrGrid.Cells[2, AddedRowNum] := ''; //'Наименование';
    StrGrid.MergeCells(11, AddedRowNum, 2, 1);
    StrGrid.Cells[11, AddedRowNum] := '';// '%';
    StrGrid.MergeCells(13, AddedRowNum, 2, 1);
    StrGrid.Cells[13, AddedRowNum] :=  ''; //'Сумма';
    StrGrid.MergeCells(15, AddedRowNum, 2, 1);
    StrGrid.Cells[15, AddedRowNum] := '';
  end; // if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'с__')
end;

procedure TFPAllocForm.RowDelToolButtonClick(Sender: TObject);
  procedure DelAndRenum(AStr : string);
  var
    RemRowNum   : integer;
    i           : integer;
    FirstNum    : integer;
    LastNum     : integer;
  begin
    if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = AStr) then begin
      RemRowNum := StrGrid.SelectedRow[0];
      // check amount of lines
      FirstNum    := RemRowNum;
      while LeftStr(StrGrid.Cells[0, FirstNum-1], Length(AStr)) = AStr do Dec(FirstNum);
      LastNum    := RemRowNum;
      while LeftStr(StrGrid.Cells[0, LastNum+1], Length(AStr))  = AStr do Inc(LastNum);

      if LastNum > FirstNum then begin   // if we have more than one line - delete current
        StrGrid.RemoveNormalRow(RemRowNum);
        i := 0;
        while LeftStr(StrGrid.Cells[0, FirstNum + i], Length(AStr)) = AStr  do begin
          StrGrid.Cells[1,FirstNum + i] := IntToStr(i + 1);
          Inc(i);
        end;
        if AStr = 'a1__' then
          Dec(GIStrNum);
      end;
    end; // if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'b__')
  end; // procedure
var
  sr : integer;
begin
  sr := StrGrid.SelectedRow[0];
  if((StrGrid.Cells[0, sr] = 'b__') or (StrGrid.Cells[0, sr] ='c__') or (StrGrid.Cells[0, sr] = 'd__') or (StrGrid.Cells[0, sr] ='e__') or (StrGrid.Cells[0, sr] = 'a1__')) and
     ((StrGrid.Cells[15, sr] = '') or ((StrGrid.Cells[15, sr] <> '') and (GetLinkOfFondByName(FFList, StrGrid.Cells[15, sr])<>''))) // filter for non-founder strings
      then begin
    DelAndRenum(StrGrid.Cells[0, StrGrid.SelectedRow[0]]);
    RecalcFP;
  end; // if (StrGrid.Cells[0, StrGrid.SelectedRow[0]] = 'b__')
end;

procedure TFPAllocForm.RVEditorCaretMove(Sender: TObject);
var
  Item:                           TCustomRVItemInfo;
  table:                          TRVTableItemInfo;
  r, c, cs, rs:                   Integer;
  rve:                            TCustomRichViewEdit;
  Selected, SelectionRectangular: Boolean;
begin
  // track table variables
  if not RVEditor.GetCurrentItemEx(TRVTableItemInfo, rve, Item) then begin
  	btnAddTblColumn.Enabled   := false;
  	btnAddTblRow.Enabled      := false;
	  btnDelTblColumn.Enabled   := false;
  	btnDelTblRow.Enabled      := false;
    btnMergeCells.Enabled     := false;
    btnSplitCellHoriz.Enabled := false;
    btnSplitCellVert.Enabled  := false;
    exit;
  end;
  table := TRVTableItemInfo(Item);
  Selected := table.GetNormalizedSelectionBounds(True, r, c, cs, rs);
  btnAddTblColumn.Enabled := Selected;
  btnAddTblRow.Enabled    := Selected;
  btnDelTblColumn.Enabled := Selected;
  btnDelTblRow.Enabled    := Selected;
  btnMergeCells.Enabled   := true;
  SelectionRectangular := true; //Selected and (table.CanMergeSelectedCells(True) or (table.GetEditedCell(r, c) <> nil));
  btnSplitCellHoriz.Enabled := SelectionRectangular;
  btnSplitCellVert.Enabled := SelectionRectangular;
end;

procedure TFPAllocForm.RVEditorCurParaStyleChanged(Sender: TObject);
begin
	btnAlignLeft.Down   := False;
  btnAlignCenter.Down := False;
  btnAlignRight.Down  := False;
  btnAlignJust.Down   := False;

  case RVStyle.ParaStyles[RVEditor.CurParaStyleNo].Alignment of
    rvaLeft:
      btnAlignLeft.Down := True;
    rvaCenter:
      btnAlignCenter.Down := True;
    rvaRight:
      btnAlignRight.Down := True;
    rvaJustify:
      btnAlignJust.Down := True;
  end;
end;

procedure TFPAllocForm.RVEditorCurTextStyleChanged(Sender: TObject);
var
  fi: TFontInfo;
begin
  // Changing selection in comboboxes with font names and sizes:
  fi := RVStyle.TextStyles[RVEditor.CurTextStyleNo];
  cmbFont.ItemIndex := cmbFont.Items.IndexOf(fi.FontName);
  cmbFontSize.Text := IntToStr(fi.Size);

  // Checking font buttons
  btnBold.Down      := fsBold in fi.Style;
  btnItalic.Down    := fsItalic in fi.Style;
  btnUnderline.Down := fsUnderline in fi.Style;
end;

procedure TFPAllocForm.RVEditorParaStyleConversion(Sender: TCustomRichViewEdit; StyleNo, UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
var
  ParaInfo: TParaInfo;
begin
  ParaInfo := TParaInfo.Create(nil);
  try
    ParaInfo.Assign(RVStyle.ParaStyles[StyleNo]);
    case UserData of
      PARA_ALIGNLEFT:
        ParaInfo.Alignment := rvaLeft;
      PARA_ALIGNCENTER:
        ParaInfo.Alignment := rvaCenter;
      PARA_ALIGNRIGHT:
        ParaInfo.Alignment := rvaRight;
      PARA_ALIGNJUST:
        ParaInfo.Alignment := rvaJustify;

      PARA_INDENTINC:
        begin
          ParaInfo.LeftIndent := ParaInfo.LeftIndent + 20;
          if ParaInfo.LeftIndent > 200 then
            ParaInfo.LeftIndent := 200;
        end;
      PARA_INDENTDEC:
        begin
          ParaInfo.LeftIndent := ParaInfo.LeftIndent - 20;
          if ParaInfo.LeftIndent < 0 then
            ParaInfo.LeftIndent := 0;
        end;

      PARA_COLOR:
        ParaInfo.Background.Color := cd.Color;

      // add your code here....
    end;
    NewStyleNo := RVStyle.FindParaStyle(ParaInfo);
  finally
    ParaInfo.Free;
  end;
end;

procedure TFPAllocForm.RVEditorStyleConversion(Sender: TCustomRichViewEdit; StyleNo, UserData: Integer; AppliedToText: Boolean;  var NewStyleNo: Integer);
var
  FontInfo: TFontInfo;
begin
  FontInfo := TFontInfo.Create(nil);
  try
    FontInfo.Assign(RVStyle.TextStyles[StyleNo]);
    case UserData of
      TEXT_BOLD:
        if btnBold.Down then
          FontInfo.Style := FontInfo.Style + [fsBold]
        else
          FontInfo.Style := FontInfo.Style - [fsBold];
      TEXT_ITALIC:
        if btnItalic.Down then
          FontInfo.Style := FontInfo.Style + [fsItalic]
        else
          FontInfo.Style := FontInfo.Style - [fsItalic];
      TEXT_UNDERLINE:
        if btnUnderline.Down then
          FontInfo.Style := FontInfo.Style + [fsUnderline]
        else
          FontInfo.Style := FontInfo.Style - [fsUnderline];
      TEXT_APPLYFONTNAME:
        FontInfo.FontName := FontName;
      TEXT_APPLYFONTSIZE:
        FontInfo.Size := FontSize;
      TEXT_COLOR:
        FontInfo.Color := cd.Color;
      TEXT_BACKCOLOR:
        FontInfo.BackColor := cd.Color;
    end;
    NewStyleNo := RVStyle.FindTextStyle(FontInfo);
  finally
    FontInfo.Free;
  end;
end;


procedure TFPAllocForm.ApproveToolButtonClick(Sender: TObject);
const
	wtitle : PWideChar = 'Одобрение финансового планирования';
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  ApproveToolButton.Enabled := false;
//	SaveIncPlan;
	if Application.MessageBox('Вы действительно хотите записать данное ФП и перечислить средства на фонды?', wtitle, MB_YESNO or MB_ICONWARNING) <> mrYES then Exit;
	if ErrorPresent or BalanceIsNotNull then begin
  	if ErrorPresent then
			Application.MessageBox('Ошибка ввода данных. Обязательные поля должны быть заполнены.', wtitle, MB_OK or MB_ICONERROR)
    else
			Application.MessageBox('Баланс планирования должен быть нулевым.', wtitle, MB_OK or MB_ICONERROR);
    StrGrid.Col := ErrCol;
    StrGrid.Row := ErrRow;
	  ApproveToolButton.Enabled := true;
    Exit;
  end;
	SaveFP(true);
end;

procedure TFPAllocForm.cmbFontClick(Sender: TObject);
begin
  if (cmbFont.ItemIndex <> -1) then begin
  	FontName := cmbFont.Items[cmbFont.ItemIndex];
    RVEditor.ApplyStyleConversion(TEXT_APPLYFONTNAME);
  end;
  if Visible then RVEditor.SetFocus;
end;

procedure TFPAllocForm.cmbFontSizeClick(Sender: TObject);
begin
  if (cmbFontSize.Text <> '') then begin
    FontSize := StrToIntDef(cmbFontSize.Text, 10);
    RVEditor.ApplyStyleConversion(TEXT_APPLYFONTSIZE);
  end;
  if Visible then RVEditor.SetFocus;
end;

procedure TFPAllocForm.cmbFontSizeExit(Sender: TObject);
begin
  cmbFontSizeClick(nil);
end;

procedure TFPAllocForm.cmbFontSizeKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then begin
    Key := #0;
    cmbFontSizeClick(nil);
  end;
end;

procedure TFPAllocForm.FormActivate(Sender: TObject);
begin
  if Assigned(FPFLF) then begin
    SetWindowPos(FPFLF.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOMOVE + SWP_NOSIZE);
  end;
end;

procedure TFPAllocForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Action = caHide then begin
    PostMessage(PWin.Handle, UM_FP_ALLOCFORMCLOSED, 0, 0);
  end;
end;

procedure TFPAllocForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  UEF : TFPUnsavedExitForm;
begin
  if FPWasChanged then begin
	  UEF := TFPUnsavedExitForm.Create(self);
    if UEF.ShowModal <> mrOk then begin
    	CanClose := false;
    end
    else begin
    	if UEF.SaveIt then begin
        SaveFP;
      end;
    end;
    UEF.Destroy;
  end;
end;

procedure TFPAllocForm.FormCreate(Sender: TObject);
begin
	FormatString.CurrencyString		:= '';
  FormatString.LongDateFormat   := 'DD.MM.YY';
	FormatString.ShortDateFormat	:= 'DD.MM.YY';
	FormatString.ShortTimeFormat  := 'HH:MM:SS';
	FormatString.LongTimeFormat   := 'HH:MM:SS';

	ErrorPresent	:= false;

  IncPlanButton.Down := boolean(IniFile.ReadInteger('fp', 'IncPlanIsDown', 1));
  IniFile.WriteInteger('fp', 'IncPlanIsDown', integer(IncPlanButton.Down));

  PlanPanel.Width := IniFile.ReadInteger('fp', 'PlanPanelWidth', Self.Width div 2);
  if PlanPanel.Width > Self.Width then
  	PlanPanel.Width := Self.Width div 2;

  IniFile.WriteInteger('fp', 'PlanPanelWidth', integer(PlanPanel.Width));
  IncPlanButtonClick(Sender);

  GetFontNames;
  SelectionChange(Self);

  CurrText.Name := DefFontData.Name;
  CurrText.Size := -MulDiv(DefFontData.Height, 72, Screen.PixelsPerInch);

  FPFLF := nil;

  FPLT := nil;
  POLT := nil;
  AcToDC   := TStringList.Create;
end;

procedure TFPAllocForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FPFLF) then begin
    FPFLF.Close;
    FPFLF.Free;
  end;

  // terminate fp locker thread
  if Assigned(FPLT) then begin
    FPLT.Terminate;
    FPLockEvent.SetEvent;
    WaitForSingleObject(FPLT.Handle, INFINITE);
    FPLT := nil;
  end;

  // terminate po locker thread
  if Assigned(POLT) then begin
    POLT.Terminate;
    POLockEvent.SetEvent;
    WaitForSingleObject(POLT.Handle, INFINITE);
    POLT := nil;
  end;

  POList.Destroy;
  POrList.Destroy;
  BAList.Destroy;
  AcToDC.Destroy;
end;

procedure TFPAllocForm.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	GetToolBarsWidths;
end;

procedure TFPAllocForm.FormShow(Sender: TObject);
begin
  if not ReadOnly then begin
    FundsTableButtonClick(Sender);
  end;
end;

procedure TFPAllocForm.FundsTableButtonClick(Sender: TObject);
begin
	if FundsTableButton.Down then begin
    Self.FPFLF.Show;
	end
	else begin
    Self.FPFLF.Hide;
	end;
  IniFile.WriteInteger('fp', 'FundsVisible', integer(FundsTableButton.Down));
end;

procedure TFPAllocForm.GetFontNames;
begin
	cmbFont.Items.Clear;
  cmbFont.Items.Assign(Screen.Fonts);
end;

procedure TFPAllocForm.HorSplitToolButtonClick(Sender: TObject);
begin
  PlanPanel.Width := Screen.Width div 2;
  IniFile.WriteInteger('fp', 'PlanPanelWidth', integer(PlanPanel.Width));
  IncPlanButtonClick(Sender);
end;

procedure TFPAllocForm.SaveToolButtonClick(Sender: TObject);
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  if not PrivPresentMO(FPPrivs, 'boqs') then
    Exit;

	SaveIncPlan;
  SaveFP(false);
  FPWasChanged := false;
  SaveToolButton.Enabled := FPWasChanged;
end;

procedure TFPAllocForm.SplitterMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	GetToolBarsWidths;
end;

procedure TFPAllocForm.SplitterMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	SetToolBarsWidths;
end;

procedure TFPAllocForm.SplitterResize(Sender: TObject);
begin
//	SetToolbarsWidths;
  IniFile.WriteInteger('fp', 'PlanPanelWidth', PlanPanel.Width);
end;

procedure TFPAllocForm.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
with statusbar.Canvas do begin
	if FPBal >= -0.009 then
		Font.Color	:= clBlack
  else
		Font.Color	:= clRed;
  Font.Style := [fsBold];
    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, 'Баланс ФП: ' + MyFloatToStr(FPBal));
  end;
end;

procedure TFPAllocForm.StrGridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
var
  fallowed : boolean;
begin
  CanEdit := false;
  if ReadOnly then Exit;
  fallowed := (StrGrid.Cells[15, ARow] = '') or ((StrGrid.Cells[15, ARow] <> '') and (GetLinkOfFondByName(FFList, StrGrid.Cells[15, ARow])<>''));
  if Pos('a1__', StrGrid.Cells[0, ARow]) > 0 then begin
    if Length(StrGrid.Cells[0, ARow]) > Length('a1__')  then
      CanEdit := (ACol in [15]) and fallowed
    else
      CanEdit := ((ACol in [2,11,15]) or ((ACol = 13) and (StrGrid.Cells[11,ARow] = ''))) and fallowed;
  end;
  if (StrGrid.Cells[0, aRow] = 'b__') then
    CanEdit := ((ACol in [2, 12, 15]) or ((ACol = 13) and (StrGrid.Cells[12, ARow] = '')) or ((ACol in [9, 10]) and (StrGrid.Cells[15, ARow] <> ''))) and fallowed;
  if StrGrid.Cells[0, aRow] = 'c__' then
    CanEdit := ((ACol in [2, 9, 10, 12, 15]) or ((ACol = 13) and (StrGrid.Cells[12, ARow] = ''))) and fallowed;
  if StrGrid.Cells[0, aRow] = 'd__' then
    CanEdit := (ACol in [2, 7, 10, 13, 15]) and fallowed;
  if StrGrid.Cells[0, aRow] = 'e__' then
    CanEdit := ((ACol in [2,11,15]) or ((ACol = 13) and (StrGrid.Cells[11,ARow]=''))) and fallowed;
end;

procedure TFPAllocForm.StrGridClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if StrGrid.Cells[0, aRow] = 'b__' then
    if ACol = 15 then
      StrGrid.ShowInplaceEdit;
end;

procedure TFPAllocForm.StrGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
Var
  POApproveForm : TPOApproveForm;

  OrigName  : string;
  OrigPost  : string;
  OrigOrig  : string;
  TmpVal    : extended;
  TmpInt    : integer;
  TI        : integer;
  TmpStatus : string;
  CellStr   : string;
begin
  if 'f__' = StrGrid.Cells[0, ARow] then begin
      FPTmpDataset.SQL.Text := 'SELECT * FROM ' + polink + ' WHERE`index`=' + StrGrid.Cells[1, ARow];
      FPTmpDataset.Open;
      OrigOrig  := FPTmpDataset.FieldByName('origin').AsString;

      TmpStatus 		:=  StrGrid.Cells[9, ARow];
      POApproveForm := TPOApproveForm.Create(Self);

      POApproveForm.PONumEdit.Text  		:= StrGrid.Cells[1, ARow];
      POApproveForm.PONum								:= StrToInt(StrGrid.Cells[1, ARow]);
      TryStrToFloat(MyCleanStr(StrGrid.Cells[7, ARow]), TmpVal);
      POApproveForm.POSumEdit.Text  		:= MyFloatToStr(TmpVal);
      POApproveForm.SubjectEdit.Text  	:= StrGrid.Cells[4, ARow];
      TryStrToInt(MyCleanStr(StrGrid.Cells[1, ARow]), TmpInt);
      if TmpInt <= 0 then
        Exit;
      if (POList.Find(StrGrid.Cells[1, ARow], TI)) then begin
        POApproveForm.CashCB.Checked := boolean(POList.Objects[ti])
      end
      else begin
        POApproveForm.CashCB.Checked := boolean(FPTmpDataset.FieldByName('bycash').AsInteger);
      end;
      POApproveForm.sGroupBox1.Caption	:= 'Решение по заявке';

      FPMainDataset.SQL.Text := 'SELECT tbl2.*,' + OrgPrefix + 'postsdir.Abbr FROM ' + OrgPrefix + 'postsdir JOIN ' +
        '(SELECT PostID,userid,FName,MName,FamilyName FROM ' + OrgPrefix + 'psts JOIN ' +
      	'(SELECT pstsid,userid,FirstName AS FName,MiddleName AS MName,FamilyName FROM ' + OrgPrefix + 'pstsfills JOIN allusers ' +
	      'USING(UserID)WHERE allusers.login=:fLogin and(Now()>=startdate)AND((Now()<enddate)or(enddate is NULL)))AS tbl1 ' +
        'ON tbl1.pstsid=' + OrgPrefix + 'psts.id)AS tbl2 ON tbl2.PostID=' + OrgPrefix + 'postsdir.ID';// LOCK IN SHARE MODE';
      FPMainDataset.ParamByName('fLogin').AsString := OrigOrig;
      FPMainDataset.Open;

      OrigPost  := FPMainDataset.FieldByName('Abbr').AsString;
      OrigName  := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FName').AsString, FPMainDataset.FieldByName('MName').AsString);

      POApproveForm.TextMemo.Text     := FPTmpDataset.FieldByName('csw').AsString + CRLF + CRLF + OrigName + ', ' + OrigPost;
      POApproveForm.TextMemo.ReadOnly	:= true;
      POApproveForm.OutOfFP						:= false;
      POApproveForm.FundList 					:= FFList; // FundList;
      POApproveForm.CAPrefix					:= OrgPrefix;


    	POApproveForm.SourceCombo.Items.Assign(FromFondCombo.Items);

      if StrGrid.Cells[9, ARow] <> 'Отложить' then begin
				POApproveForm.NoteMemo.Text    		:= MyCleanStr(FPTmpDataset.FieldByName('note').AsString, UC_KEEPDOTS);
		    POApproveForm.PrintButton.Visible	:= true;
      end
      else begin
	      POApproveForm.NoteMemo.Text := StrGrid.Cells[13, ARow];
      end;

      if StrGrid.Cells[9, ARow] = 'Одобрить' then begin
        POApproveForm.ApproveRadioButton.Checked := true;
        TryStrToFloat(MyCleanStr(StrGrid.Cells[11, ARow]), TmpVal);
        POApproveForm.ApprovedSumEdit.Value := TmpVal;

        CellStr := StrGrid.Cells[15, ARow];
        for TmpInt := 0 to FromFondCombo.Items.Count - 1 do begin
          if PVTResourceData(FromFondCombo.Items.Objects[TmpInt]).name = CellStr then begin
            if ReadOnly then begin // Arc FP
              POApproveForm.SourceCombo.Items[TmpInt] := PVTResourceData(FromFondCombo.Items.Objects[TmpInt]).name;
            end
            else begin
              POApproveForm.SourceCombo.Items[TmpInt] := PVTResourceData(FromFondCombo.Items.Objects[TmpInt]).name +
                ' (' + MyFloatToStr(PVTResourceData(FromFondCombo.Items.Objects[TmpInt]).balance + PVTResourceData(FromFondCombo.Items.Objects[TmpInt]).fp1sum + TmpVal) + ')';
              PVTResourceData(FromFondCombo.Items.Objects[TmpInt]).fp1sum := PVTResourceData(FromFondCombo.Items.Objects[TmpInt]).fp1sum + TmpVal;
            end;
            POApproveForm.SourceCombo.ItemIndex := TmpInt;
            POApproveForm.CurFundLink := PVTResourceData(FromFondCombo.Items.Objects[TmpInt]).link;
            break
          end;
        end;
      end
      else if StrGrid.Cells[9, ARow] = 'Отклонить' then begin
        POApproveForm.RejectRadioButton.Checked := true;
      end
      else if StrGrid.Cells[9, ARow] = 'Отложить' then begin
        POApproveForm.rbPutAside.Checked := true;
      end;


      POApproveForm.InitAtts;

      if ReadOnly then begin
        POApproveForm.SubmitButton.Visible        := false;
        POApproveForm.TextMemo.ReadOnly		        := true;
        POApproveForm.ApproveRadioButton.Enabled	:= false;
        POApproveForm.RejectRadioButton.Enabled		:= false;
        POApproveForm.SourceCombo.Enabled					:= false;
        POApproveForm.ApprovedSumEdit.Enabled			:= false;
        POApproveForm.Font.Style                  := POApproveForm.Font.Style + [fsBold];
        POApproveForm.NoteMemo.Enabled						:= false;
      end;

      if mrOK = POApproveForm.ShowModal then begin
	      if POList.Find(StrGrid.Cells[1, ARow], TmpInt) then begin
  	      POList.Objects[TmpInt] := pointer(POApproveForm.CashCB.Checked)
    	  end;
        SaveToolButton.Enabled  := true;
        FPWasChanged            := true;
        if POApproveForm.ApproveRadioButton.Checked then begin
			      StrGrid.Cells[ 9, ARow] := 'Одобрить';
			      StrGrid.Cells[11, ARow] := MyFloatToStr(POApproveForm.ApprovedSumEdit.Value);
			      StrGrid.Cells[13, ARow] := POApproveForm.NoteMemo.Text;
			      StrGrid.Cells[15, ARow] := GetNameOfFondByLink(FundList, POApproveForm.CurFundLink);
        end
        else if POApproveForm.RejectRadioButton.Checked then begin
			      StrGrid.Cells[ 9, ARow] := 'Отклонить';
			      StrGrid.Cells[11, ARow] := '';
			      StrGrid.Cells[13, ARow] := POApproveForm.NoteMemo.Text;
			      StrGrid.Cells[15, ARow] := '';
        end
        else begin // the rest is "Put aside"
			      StrGrid.Cells[ 9, ARow] := 'Отложить';
			      StrGrid.Cells[11, ARow] := '';
			      StrGrid.Cells[13, ARow] := '';
			      StrGrid.Cells[15, ARow] := '';
        end
      end;

      POApproveForm.Free;
      RecalcFP;
  end;
end;

procedure TFPAllocForm.StrGridEditCellDone(Sender: TObject; ACol, ARow: Integer);

	function FundBalEnough(ALine : integer) : boolean;
  var
  	itop 			: integer;
    ibot			: integer;
    i					: integer;
    flink			: string;
    TSum			: extended;
    TmpResult	: extended;
    FundBal		: extended;
  begin
  	Result 	:= true;
    flink := GetLinkOfFondByName(FundList, StrGrid.Cells[15, ALine]);
    if (flink = '0') or (flink = '') then
      Exit;

    FundBal	:= GetBalanceOfFondByLink(FundList, flink);

    for I := 1 to StrGrid.RowCount - 1 do begin
      if 	(Pos('a1__', StrGrid.Cells[0, i]) > 0) or
        	(StrGrid.Cells[0, i] = 'b__') or (StrGrid.Cells[0, i] = 'c__') or
        	(StrGrid.Cells[0, i] = 'd__') or (StrGrid.Cells[0, i] = 'd__')
      	then begin
						if (GetLinkOfFondByName(FundList, StrGrid.Cells[15, i]) = flink) and
            	(TryStrToFloat(ReplaceStr(StrGrid.Cells[13, i], ThSep, ''), TmpResult)) then
                FundBal := FundBal + TmpResult;
        end;
    end;
  	itop := ALine;
    while StrGrid.Cells[0, itop - 1] = 'f__' do
    	Dec(itop);
  	ibot := ALine;
    while StrGrid.Cells[0, ibot + 1] = 'f__' do
    	Inc(ibot);
    TSum := 0;
    for i := itop to ibot do
    	if (GetLinkOfFondByName(FundList, StrGrid.Cells[15, i]) = flink) and (TryStrToFloat(ReplaceStr(StrGrid.Cells[11, i], ThSep, ''), TmpResult)) then
      	TSum := TSum + TmpResult;
		Result := FundBal >= TSum;
  end; // function FundBalEnough

Var
  TmpVal    : extended;
  TmpValOld : extended;
  TmpInd    : integer;
  UpdFP1DataNeeded  : boolean;
  NoError   : boolean;
  fid       : integer;
begin
  if ((StrGrid.Cells[0, aRow] = 'b__') or (StrGrid.Cells[0, aRow] = 'c__')) then begin
    if (ACol in [9, 10]) then begin
      UpdFP1DataNeeded := false;
      if (ACol = 9) and FP1PEditing then begin
        TryStrToFloat(MyCleanStr(FP1PStr), TmpValOld);
        TryStrToFloat(MyCleanStr(StrGrid.Cells[ACol, ARow]), TmpVal);
        if Round(TmpVal * 100) <> Round(TmpValOld * 100) then begin // put it to the DB (fp1funddata table)
          UpdFP1DataNeeded := true;
        end;
      end
      else if (ACol = 10) and FP1AEditing then begin
        TryStrToFloat(MyCleanStr(FP1AStr), TmpValOld);
        TryStrToFloat(MyCleanStr(StrGrid.Cells[ACol, ARow]), TmpVal);
        if Round(TmpVal * 100) <> Round(TmpValOld * 100) then begin // put it to the DB (fp1funddata table)
          UpdFP1DataNeeded := true;
        end;
      end;

      if UpdFP1DataNeeded and (StrGrid.Cells[15, ARow] <> '') then begin
        NoError := true;
        FPMainDataset.SQL.Text := 'SELECT`index`FROM ' + OrgPRefix + 'fond Where link=:fLink';
        FPMainDataset.ParamByName('fLink').AsString := GetLinkOfFondByName(FundList,  StrGrid.Cells[15, ARow]);
        try
          FPMainDataset.Open;
        except
   				on e: EZSQLException do begin
	    			Globalvars.ShowError(Self, 'Невозможно получить данные о фонде.', e.ErrorCode, e.StatusCode, e.Message);
          	NoError := false;
          end;
        end;
        if NoError then begin
          fid := FPMainDataset.FieldByName('index').AsInteger;
        end;
        if NoError and (fid > 0) then begin
          TmpValOld := 0;
          TmpVal    := 0;
          TryStrToFloat(MyCleanStr(StrGrid.Cells[9,  ARow]), TmpValOld);
          TryStrToFloat(MyCleanStr(StrGrid.Cells[10, ARow]), TmpVal);
          FPMainDataset.SQL.Text := 'INSERT INTO ' + OrgPRefix + 'fp1funddata(fid,since,amount,pct)VALUES(:fFID,NOW(),:fAmnt,:fPct)';
          FPMainDataset.ParamByName('fFID').AsInteger := fid;
          FPMainDataset.ParamByName('fAmnt').AsFloat  := TmpVal;
          FPMainDataset.ParamByName('fPct').AsFloat   := TmpValOld;
          try
            FPMainDataset.ExecSQL;
          except
   		  		on e: EZSQLException do begin
	    	  		Globalvars.ShowError(Self, 'Невозможно обновить данные о фонде.', e.ErrorCode, e.StatusCode, e.Message);
            end;
          end;
        end; // if NoError and (fid > 0) then begin
      end; // if UpdFP1DataNeeded and (StrGrid.Cells[15, ARow] <> '')
    end // if (ACol in [9, 10]))
    else if (ACol = 15) and (StrGrid.Cells[15, ARow] <> '') then begin
      FPMainDataset.SQL.Text := 'SELECT ' + OrgPRefix + 'fp1funddata.* from ' + OrgPRefix + 'fp1funddata JOIN ' + OrgPRefix + 'fond ON ' + OrgPRefix + 'fp1funddata.fid=' + OrgPRefix + 'fond.`index` WHERE ' + OrgPRefix + 'fond.name=:fFName AND since<now()ORDER BY since DESC LIMIT 1';
      FPMainDataset.ParamByName('fFName').AsString := StrGrid.Cells[15, ARow];
      try
        FPMainDataset.Open;
      except
   		  on e: EZSQLException do begin
	    	  Globalvars.ShowError(Self, 'Невозможно обновить данные об ФП №1.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
      if NoError and (FPMainDataset.RecordCount > 0) then begin
        StrGrid.Cells[ 9, ARow] := MyFloatToStr(FPMainDataset.FieldByName('pct').AsFloat);
        StrGrid.Cells[10, ARow] := MyFloatToStr(FPMainDataset.FieldByName('amount').AsFloat);
      end
      else begin
        StrGrid.Cells[ 9, ARow] := '';
        StrGrid.Cells[10, ARow] := '';
      end;
    end
  end; // if (((StrGrid.Cells[0, aRow] = 'b__') or (StrGrid.Cells[0, aRow] = 'c__'))

  if ((StrGrid.Cells[0, aRow] = 'e__') and (ACol in [11])) then begin
    if TryStrToFloat(MyCleanStr(StrGrid.Cells[ACol, ARow]), TmpVal) then
      StrGrid.Cells[ACol, ARow] := MyFloatToStr(abs(TmpVal))
    else
      StrGrid.Cells[ACol, ARow] := '';
  end;

  if ((Pos('a1__', StrGrid.Cells[0, aRow]) > 0) and (ACol in [11, 13])) or
     ((StrGrid.Cells[0, aRow] = 'b__') and (ACol in [9, 10, 12, 13])) or
  	 ((StrGrid.Cells[0, aRow] = 'c__') and (ACol in [9, 10, 12, 13])) or
     ((StrGrid.Cells[0, aRow] = 'd__') and (ACol in [7, 13])) or
     ((StrGrid.Cells[0, aRow] = 'e__') and (ACol in [13])) or
     ((StrGrid.Cells[0, aRow] = 'f__') and (ACol in [11])) then begin
    if TryStrToFloat(MyCleanStr(StrGrid.Cells[ACol, ARow]), TmpVal) then
      StrGrid.Cells[ACol, ARow] := MyFloatToStr(abs(TmpVal))
    else
      StrGrid.Cells[ACol, ARow] := '';
  end;
  if (StrGrid.Cells[0, ARow] = 'f__') then begin
		if (ACol = 9) then begin
  	  if PrevApproveStatus <> StrGrid.Cells[ACol, ARow] then begin
			  if StrGrid.Cells[ACol, ARow] = 'Одобрить' then begin
      		StrGrid.Cells[11, ARow] := StrGrid.Cells[7, ARow];
      		StrGrid.Cells[15, ARow] := '';  // !!! *** !!!
			  end
    	  else begin
      		StrGrid.Cells[11, ARow] := '';
      		StrGrid.Cells[13, ARow] := '';
      		StrGrid.Cells[15, ARow] := '';
	      end;
		  end;
	  end; // if ACol = 9
		if (ACol = 15) then begin // fund to approve from was changed
      TmpInd := FromFondCombo.Items.IndexOf(StrGrid.Cells[15, ARow]);
      if TmpInd < 0 then begin
//        	Exit;
      end
      else begin
			  StrGrid.Cells[15, ARow] := PVTResourceData(FromFondCombo.Items.Objects[TmpInd]).name;
      end;

      if not FundBalEnough(ARow) then begin
			  Application.MessageBox(
            PWideChar('На выбранном фонде "' + StrGrid.Cells[15, ARow] + '" недостаточно средств' + Chr(13) + 'Выберите другой фонд.'),
            'Недостаточно средств', MB_OK or MB_ICONERROR);
        StrGrid.Col := ACol;
        StrGrid.Row	:= ARow;
        StrGrid.Cells[ACol, ARow] := '';
      end;
//		  end;
	  end; // if ACol = 15
  end;
//	RecalcFundsRests;
  FPWasChanged := true;
  SaveToolButton.Enabled := FPWasChanged;

	RecalcFP;
end;

procedure TFPAllocForm.StrGridEditChange(Sender: TObject; ACol, ARow: Integer; Value: string);
var
	TmpVal : extended;
begin
  if ('f__' = StrGrid.Cells[0, ARow]) and (ACol = 9) then begin
		PrevApproveStatus := StrGrid.Cells[9, ARow];
  end;
end;

procedure TFPAllocForm.StrGridGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
	if Pos('h__', StrGrid.Cells[0, aRow]) > 0 then begin // section header
  	HAlign := taLeftJustify;
  end;
  if StrGrid.Cells[0, aRow] = 'eh__' then begin // Header for section E
  	case ACol of
    	1, 11   : HAlign := taLeftJustify;
      13      : HAlign := taRightJustify;
    end;
  end;
  if Pos('s__', StrGrid.Cells[0, aRow]) > 0 then begin // section subheader
  	HAlign := taCenter;
  end;
  if 	(Pos('gt__', StrGrid.Cells[0, aRow]) > 0) or
			(StrGrid.Cells[0, aRow] = 'tgi__') or
      (StrGrid.Cells[0, aRow] = 'gi__') or
      (Pos('bt__', StrGrid.Cells[0, aRow]) > 0) or
      (Pos('a1t__', StrGrid.Cells[0, aRow]) > 0) or
      (Pos('ct__', StrGrid.Cells[0, aRow]) > 0) or
      (Pos('dt__', StrGrid.Cells[0, aRow]) > 0) or
      (Pos('ft__', StrGrid.Cells[0, aRow]) > 0) or
      (Pos('et__', StrGrid.Cells[0, aRow]) > 0) or
      (Pos('c_cgi__', StrGrid.Cells[0, aRow]) > 0) or
      (Pos('b_cgi__', StrGrid.Cells[0, aRow]) > 0) or
      (Pos('d_cgi__', StrGrid.Cells[0, aRow]) > 0)
      	then begin // totals
  	case ACol of
    	1, 9    : HAlign := taLeftJustify;
      4, 11   : HAlign := taRightJustify;
    end;
  end;
  if 	(Pos('ftwf__', StrGrid.Cells[0, aRow]) > 0) then begin // totals
  	case ACol of
    	1, 8    : HAlign := taLeftJustify;
      4, 11   : HAlign := taRightJustify;
    end;
  end;
  if 	(Pos('fp1t__', StrGrid.Cells[0, aRow]) > 0) then begin // totals
  	case ACol of
    	1      : HAlign := taLeftJustify;
      10, 13 : HAlign := taRightJustify;
    end;
  end;
  if Pos('a__', StrGrid.Cells[0, aRow]) > 0 then begin // section A
  	case ACol of
    	1, 2, 12  : HAlign := taRightJustify;
    else        	HAlign := taLeftJustify;
    end;
  end;
  if (Pos('b__', StrGrid.Cells[0, aRow]) > 0) or (Pos('c__', StrGrid.Cells[0, aRow]) > 0) or (Pos('a1__', StrGrid.Cells[0, aRow]) > 0) then begin // B and A1
  	case ACol of
    	1, 9, 10, 12, 13  : HAlign := taRightJustify;
    else                 	HAlign := taLeftJustify;
  	end;
  end;
  if (Pos('a1__', StrGrid.Cells[0, aRow]) > 0) or (Pos('e__', StrGrid.Cells[0, aRow]) > 0) then begin // section A1 and E
  	case ACol of
    	1, 11, 13  : HAlign := taRightJustify;
    else         	 HAlign := taLeftJustify;
    end;
  end;
  if Pos('d__', StrGrid.Cells[0, aRow]) > 0 then begin // section D
  	case ACol of
    	1, 7, 13  : 	HAlign := taRightJustify;
    else     		HAlign := taLeftJustify;
    end;
  end;
  if Pos('f__', StrGrid.Cells[0, aRow]) > 0 then begin // section D
  	case ACol of
    	1, 2, 7, 11  :  HAlign := taRightJustify;
    else            	HAlign := taLeftJustify;
    end;
  end;
  if Pos('acn__', StrGrid.Cells[0, aRow]) > 0 then begin // section D
  	case ACol of
    	6, 15  :  HAlign := taRightJustify;
    else    HAlign := taLeftJustify;
    end;
  end;
end;

procedure TFPAllocForm.StrGridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
const
  NormalBkColor   : TColor = TColor($FFFFFF);
  NormalFontStyle : TFontStyles = [];
var
  TmpResult        : extended;
begin
	if PrintingIsIP then
		AFont.Size := 7
  else
		AFont.Size := 10;
  if 'h__' = StrGrid.Cells[0, aRow] then begin // section header
  	AFont.Style := [fsBold];
    AFont.Color := TColor($FF0000);  // clBlue
		if PrintingIsIP then
			ABrush.Color := NormalBkColor
    else
	  	ABrush.Color :=  TColor($93FFFF); //clYellow
  end
  else if Pos('s__', StrGrid.Cells[0, aRow]) > 0 then begin // section subheader
  	AFont.Style := [fsBold];
		if PrintingIsIP then
			ABrush.Color := NormalBkColor
    else
	  	ABrush.Color :=  TColor($FFFFFF) //clWhite
  end
  else if Pos('fp1t__', StrGrid.Cells[0, aRow]) > 0 then begin // section subheader
  	AFont.Style := [fsBold];
  	AFont.Color := clBlack;
		if PrintingIsIP then begin
			ABrush.Color := NormalBkColor
    end
    else begin
	  	ABrush.Color := TColor($FFFFFF); //clWhite
      if ACol = 1 then begin
        AFont.Color := TColor($FF0000);  // clBlue
      end
    end;
  end
  else if 'eh__' = StrGrid.Cells[0, aRow] then begin // section header
  	if ACol in [11,13] then begin
    	AFont.Style := [fsBold];
      if ACol = 13 then
      	AFont.Color := TColor($000000)
      else
      	AFont.Color := TColor($FF0000);  // clBlue
      if PrintingIsIP then
				ABrush.Color := NormalBkColor
      else
      	ABrush.Color :=  TColor($FFFFFF); //clYellow
    end
    else begin
    	AFont.Style := [fsBold];
      AFont.Color := TColor($000000);  // clBlue
			if PrintingIsIP then
				ABrush.Color := NormalBkColor
      else
      	ABrush.Color :=  TColor($93FFFF); //clYellow
    end
  end
  else if (Pos('gt__', StrGrid.Cells[0, aRow]) > 0) or
  				('tgi__' = StrGrid.Cells[0, aRow]) or
        	('gi__' = StrGrid.Cells[0, aRow]) or
          (Pos('bt__', StrGrid.Cells[0, aRow]) > 0)			or
          (Pos('a1t__', StrGrid.Cells[0, aRow]) > 0)	or
          (Pos('ct__', StrGrid.Cells[0, aRow]) > 0)	or
          (Pos('dt__', StrGrid.Cells[0, aRow]) > 0)	or
          (Pos('ft__', StrGrid.Cells[0, aRow]) > 0)	or
          (Pos('et__', StrGrid.Cells[0, aRow]) > 0)	or
          (Pos('b_cgi__', StrGrid.Cells[0, aRow]) > 0)	or
          (Pos('c_cgi__', StrGrid.Cells[0, aRow]) > 0)	or
          (Pos('d_cgi__', StrGrid.Cells[0, aRow]) > 0)
          	then begin // totals
		case aCol of
    	1, 9 : begin
      	if StrGrid.Cells[aCol, aRow] <> '' then begin
        	AFont.Style := [fsBold];
          AFont.Color := TColor($FF0000);  // clBlue
					if PrintingIsIP then
						ABrush.Color := NormalBkColor
          else
      	  	ABrush.Color :=  TColor($FFFFFF) //clWhite
        end
        else begin
        	AFont.Style := [];
          AFont.Color := TColor($000000);  // clBlack
					if PrintingIsIP then
						ABrush.Color := NormalBkColor
          else
      	  	ABrush.Color :=  TColor($DDDDDD) //clWhite
          end;
        end;
      4, 11 : begin
      	AFont.Style := [fsBold];
        if(Pos('ft__', StrGrid.Cells[0, aRow]) > 0) then begin
        end
        else begin
        	AFont.Color := TColor($000000);  // clBlack
          if aCol = 4 then begin
          	TryStrToFloat(ReplaceStr(StrGrid.Cells[aCol, aRow], ThSep, ''), TmpResult);
            if TmpResult < 0 then
            	AFont.Color := TColor($0000FF);  // clRed
          end;
        end;
        if(Pos('gt__', StrGrid.Cells[0, aRow]) > 0) then begin
        	TryStrToFloat(ReplaceStr(StrGrid.Cells[4, aRow], ThSep, ''), TmpResult);
          if TmpResult < 0 then
          	AFont.Color := TColor($0000FF);  // clRed
        end;
				if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
        	ABrush.Color :=  TColor($FFFFFF) //clWhite
      end;
      else begin
      	AFont.Style := [];
        AFont.Color := TColor($000000);  // clBlack
				if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
        	ABrush.Color :=  TColor($DDDDDD) //clWhite
      end;
    end;
  end // else if (Pos('gt__', StrGrid.Cells[0, aRow]) > 0) or
	else if (Pos('ftwf__', StrGrid.Cells[0, aRow]) > 0) then begin // totals
  	case aCol of
    	1, 8 : begin
      	if StrGrid.Cells[aCol, aRow] <> '' then begin
        	AFont.Style := [fsBold];
          AFont.Color := TColor($FF0000);  // clBlue
					if PrintingIsIP then
						ABrush.Color := NormalBkColor
          else
      	  	ABrush.Color :=  TColor($FFFFFF) //clWhite
      	end
      	else begin
      		AFont.Style := [];
        	AFont.Color := TColor($000000);  // clBlack
					if PrintingIsIP then
						ABrush.Color := NormalBkColor
        	else
      			ABrush.Color :=  TColor($DDDDDD) //clWhite
      	end;
    	end;
      4, 11 : begin
      	AFont.Style := [fsBold];
        AFont.Color := TColor($000000);  // clBlack
				if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
        	ABrush.Color :=  TColor($FFFFFF) //clWhite
      end;
      else begin
      	AFont.Style := [];
        AFont.Color := TColor($000000);  // clBlack
				if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
        	ABrush.Color :=  TColor($DDDDDD) //clWhite
      end;
    end;
  end // if (Pos('ftwf__', StrGrid.Cells[0, aRow]) > 0) or
  else if (Pos('acn__', StrGrid.Cells[0, aRow]) > 0)
  				then begin // totals
  	AFont.Style := [fsBold];
    AFont.Color := TColor($000000);  // clBlue
    case aCol of
    	1, 6, 10, 15 : begin
				if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
     	  	ABrush.Color :=  TColor($FFFFFF); //clWhite
      end
      else begin
				if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
      		ABrush.Color :=  TColor($DDDDDD) //clWhite
      end;
    end;
  end // 'acn___'
  else begin
  	AFont.Style := [];
    if PrintingIsIP then
			ABrush.Color := NormalBkColor
    else
  		ABrush.Color :=  TColor($DDDDDD) //clWhite
  end;
  if PrintingIsIP then
		ABrush.Color := NormalBkColor;
end;

procedure TFPAllocForm.StrGridGetCellPrintBorder(Sender:TObject;ARow,ACol:Integer;APen:TPen;var Borders:TCellBorders);
begin
	if (ACol=0) or (ARow=0) or (StrGrid.Cells[0,ARow]='') or (StrGrid.Cells[0,ARow]='h__') then begin
    Borders := [];
	end
  else begin
  	if StrGrid.Cells[0,ARow]='a__' then begin
      if ACol in [1,2,4,12,15] then begin
		    Borders := [cbLeft, cbBottom];
        if ACol = 15 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
  	else if (StrGrid.Cells[0,ARow]='b__') or (Pos('a1__', StrGrid.Cells[0,ARow])>0) or (StrGrid.Cells[0,ARow]='c__') then begin
      if ACol in [1,2,8,11,13,15] then begin
		    Borders := [cbLeft, cbBottom];
        if ACol = 15 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else if StrGrid.Cells[0,ARow]='s__' then begin
	  	if StrGrid.Cells[0,ARow-1]='b__' then begin
	      Borders := [];
      end
    end
    else if StrGrid.Cells[0,ARow]='d__' then begin
      if ACol in [1,2,7,10,13,15] then begin
		    Borders := [cbLeft, cbBottom];
        if ACol = 15 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else if StrGrid.Cells[0,ARow]='e__' then begin
      if ACol in [1,2,11,13,15] then begin
		    Borders := [cbLeft, cbBottom];
        if ACol = 15 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else if StrGrid.Cells[0,ARow]='f__' then begin
      if ACol in [1,2,4,7,9,11,13,15] then begin
		    Borders := [cbLeft, cbBottom];
        if ACol = 15 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else if (StrGrid.Cells[0,ARow]='ftwf__')then begin
      if ACol in [8,11] then begin
		    Borders := [cbLeft, cbBottom, cbTop];
        if ACol = 11 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else if (StrGrid.Cells[0,ARow]='acn__') then begin
      if ACol in [1,6] then begin
		    Borders := [cbLeft, cbBottom, cbTop];
        if ACol = 6 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else if (StrGrid.Cells[0,ARow]='tgi__') or
				    (StrGrid.Cells[0,ARow]='gi__') or
            (Pos('b_cgi__', StrGrid.Cells[0, aRow]) > 0)	or
            (Pos('c_cgi__', StrGrid.Cells[0, aRow]) > 0)	or
            (Pos('d_cgi__', StrGrid.Cells[0, aRow]) > 0)	or
            (StrGrid.Cells[0,ARow]='gt__') or (StrGrid.Cells[0,ARow]='ft__') then begin
      if ACol in [1,4] then begin
		    Borders := [cbLeft, cbBottom, cbTop];
        if ACol = 4 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else if (Pos('eh__', StrGrid.Cells[0, ARow]) > 0) then begin
      if ACol in [11, 13] then begin
		    Borders := [cbLeft, cbBottom, cbTop];
        if ACol = 13 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else if (StrGrid.Cells[0,ARow]='bt__') or (StrGrid.Cells[0,ARow]='ct__') //then begin
          	or (StrGrid.Cells[0,ARow]='dt__')  or (StrGrid.Cells[0,ARow]='et__')
				    or (StrGrid.Cells[0,ARow]='a1t__')

            then begin
      if ACol in [9,11] then begin
		    Borders := [cbLeft, cbBottom, cbTop];
        if ACol = 11 then
			    Borders := Borders + [cbRight];
      end
      else
		    Borders := [];
    end
    else
	    Borders := [cbLeft, cbBottom ];
  end;
end;

procedure TFPAllocForm.StrGridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor: TEditorType);
begin
  with StrGrid do begin
    if ('b__' = StrGrid.Cells[0, ARow]) or ('c__'= StrGrid.Cells[0, ARow]) or
       ('d__'= StrGrid.Cells[0, ARow])  or ('e__'= StrGrid.Cells[0, ARow]) or
       (Pos('a1__', StrGrid.Cells[0, ARow]) > 0) then
      case ACol of
        15: begin
          aEditor := edComboList;
          ClearComboString;
          ComboBox.Items.Assign(TmpFundCombo.Items);
        end;
      end;
    if (Pos('f__', StrGrid.Cells[0, ARow]) > 0) then
      case ACol of
        9: begin
          aEditor := edComboList;
          ClearComboString;
          ComboBox.Items.Add('Отложить');
          ComboBox.Items.Add('Отклонить');
          ComboBox.Items.Add('Одобрить');
        end;
        15: begin
          aEditor := edComboList;
          ClearComboString;
          ComboBox.Items.Assign(FromFondCombo.Items);
        end;
      end;
  end;
end;

procedure TFPAllocForm.StrGridGetEditText(Sender: TObject; ACol, ARow: Integer; var Value: string);
var
  i : integer;
  CellStr : string;
begin
  PrevCellValue := Value;
  if ('b__' = StrGrid.Cells[0, ARow]) or ('c__'= StrGrid.Cells[0, ARow]) then begin //or
    if ACol = 9 then begin
      FP1PStr     := Value;     // FP1 % for fund
      FP1PEditing := true;      // FP1 % is being edited
    end
    else if ACol = 10 then begin
      FP1AStr     := Value;     // FP1 amount for fund
      FP1AEditing := true;      // FP1 amount is editing
    end;
  end;
  if ('f__' = StrGrid.Cells[0, ARow]) and (ACol = 15) then begin
    CellStr := StrGrid.Cells[15, ARow];
    for i := 1 to FromFondCombo.Items.Count - 1 do begin
      if PVTResourceData(FromFondCombo.Items.Objects[i]).name = CellStr then begin
        StrGrid.Combobox.ItemIndex := i;
        break
      end;
    end;
  end;
end;

procedure TFPAllocForm.StrGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
	CanEdit : boolean;
begin
	if Key = VK_DELETE then begin
  	if [ssAlt] = Shift then begin
			RowDelToolButtonClick(Sender)
    end
    else begin
	    StrGridCanEditCell(Sender, StrGrid.Row, StrGrid.Col, CanEdit);
  	  if (CanEdit) and (not StrGrid.EditMode) and (not((StrGrid.Col in [11, 15]) and (StrGrid.Cells[0, StrGrid.Row] = 'f__'))) then begin
				StrGrid.Cells[StrGrid.Col, StrGrid.Row] := '';
  	    FPWasChanged := true;
			  SaveToolButton.Enabled := FPWasChanged;
        if (StrGrid.Col = 15) and ('b__' = StrGrid.Cells[0, StrGrid.Row]) and ('' = StrGrid.Cells[15, StrGrid.Row]) then begin
          StrGrid.Cells[ 9, StrGrid.Row] := '';
          StrGrid.Cells[10, StrGrid.Row] := '';
        end;
		    RecalcFP;
  	  end
    end;
	  Key := 0;
	end
  else 	if Key = VK_INSERT then begin
  	if [ssAlt] = Shift then begin
			RowAddToolButtonClick(Sender)
    end
  end;
end;

procedure TFPAllocForm.StrGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  nRow  : integer;
  nCol  : integer;
begin
	inherited;
(*
  StrGrid.MouseToCell(x, y, nCol, nRow);
  if (nRow>=0) and (nRow<StrGrid.RowCount) then
    if ('tgi__' = StrGrid.Cells[0, nRow]) and (nCol in [4,5]) then  // if it's a GI
      StrGrid.Hint := 'tgi'
    else if ('gi__' = StrGrid.Cells[0, nRow]) and (nCol in [4,5]) then  // if it's a GI
      StrGrid.Hint := 'gi'
    else if (Pos('b__', StrGrid.Cells[0, nRow])>0) then begin
      if nCol in [2..7] then
        StrGrid.Hint := 'b'+StrGrid.Cells[1, nRow] + '1'
      else if nCol in [8..10] then
        StrGrid.Hint := 'b'+StrGrid.Cells[1, nRow] + '2'
      else if nCol in [11..12] then
        StrGrid.Hint := 'b'+StrGrid.Cells[1, nRow] + '3'
      else if nCol in [13..14] then
        StrGrid.Hint := 'b'+StrGrid.Cells[1, nRow] + '4';
    end // b__
    else // no hint needed
      StrGrid.Hint := ''
  else
    StrGrid.Hint := '';
*)
end;

procedure TFPAllocForm.StrGridMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
	inherited;
  StrGrid.SetFocus;
end;

procedure TFPAllocForm.StrGridMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
	inherited;
  StrGrid.SetFocus;
end;

procedure TFPAllocForm.StrGridUpdateColumnSize(Sender: TObject; ACol: Integer; var AWidth: Integer);
begin
  IniFile.WriteInteger('FP', 'C' + IntToStr(ACol), AWidth);
end;

procedure TFPAllocForm.btnUnderlineClick(Sender: TObject);
begin
  if FUpdating then Exit;
  RVEditor.ApplyStyleConversion(TEXT_UNDERLINE);
end;

procedure TFPAllocForm.btnUndoClick(Sender: TObject);
begin
///  with Editor do
///    if HandleAllocated then SendMessage(Handle, EM_UNDO, 0, 0);
  RVEditor.Undo;
end;

procedure TFPAllocForm.btnPrintIncPlanClick(Sender: TObject);
var
	PrintIt : boolean;
  frmPreview : TIncPlanPrintPreviewForm;

begin
  RVPrint1.AssignSource(RVEditor);
  RVPrint1.FormatPages(rvdoALL);
  if RVPrint1.PagesCount > 0 then begin
	  frmPreview := TIncPlanPrintPreviewForm.Create(nil);
    frmPreview.UpdateAllowed := false;

    frmPreview.rvpp.RVPrint := RVPrint1;
    frmPreview.ShowModal;
    frmPreview.Destroy;
  end;

end;

procedure TFPAllocForm.PrintToolButtonClick(Sender: TObject);
{$IFDEF NATPRINT}
	function MMToPixX(mm: Integer): Integer; begin Result := Round(mm*(PixPerInchX/25.4)); end;
	function MMToPixY(mm: Integer): Integer; begin Result := Round(mm*(PixPerInchY/25.4)); end;
	procedure GetPrinterInfo;
	var
	  DC:HDC;
	begin
  	DC := Printer.Handle;
	  // DPI for x and y axes
  	PixPerInchX := GetDeviceCaps(DC, LOGPIXELSX);
	  PixPerInchY := GetDeviceCaps(DC, LOGPIXELSY);

  	// page sizes (in mm)
	  PageWidthInMM	 := GetDeviceCaps(DC, HORZSIZE);
  	PageHeightInMM := GetDeviceCaps(DC, VERTSIZE);

	  // page sizes (in dots)
  	PhysPageWidth  := GetDeviceCaps(DC, PHYSICALWIDTH);
	  PhysPageHeigth := GetDeviceCaps(DC, PHYSICALHEIGHT);

  	// printable area offsets
	  PhysOffsetX := GetDeviceCaps(DC, PHYSICALOFFSETX);
  	PhysOffsetY := GetDeviceCaps(DC, PHYSICALOFFSETY);

	  // printable area on the page
  	PageResX := GetDeviceCaps(DC, HORZRES);
  	PageResY := GetDeviceCaps(DC, VERTRES);

	  // границы печати
//  	Margins.Top	 	 := round(PhysOffsetY / PixPerInchY * 25.4);
//	  Margins.Left 	 := round(PhysOffsetX / PixPerInchX * 25.4);
//  	Margins.Bottom := round((PhysPageHeigth - PageResY - PhysOffsetY) / PixPerInchY * 25.4);
//	  Margins.Right  := round((PhysPageWidth	- PageResX - PhysOffsetX) / PixPerInchX * 25.4);
	end;
  procedure CheckForNewPageAndFeedLine(var y1: integer; dy1, ybottom, ytop : integer);
  begin
		if(y1 + dy1 > ybottom) then begin
    	// start new page
      Printer.NewPage; y1 := ytop;
    end;
    inc(y1, dy1);
  end;
{$ELSE}
  procedure AddTextValue(AMainXMLDoc: IXMLDomDocument; ANode : IXMLDomElement; AParameter, AValue : string);
  var
    NNode : IXMLDomElement;
  begin
    NNode := AMainXMLDoc.createElement(AParameter);
    ANode.appendChild(NNode);
    NNode.appendChild(AMainXMLDoc.createTextNode(AValue));
  end;
{$ENDIF}
const
 fsMainHeader : integer = 12;
 fsHeader : integer = 10;
 fsNormal : integer = 8;
Var
{$IFDEF NATPRINT}
  lm, tm, rm, bm : integer; // margins
  x, y : integer;           // current prosition
  dx, dy : integer;         // delta

  MMMx : integer; // Margins (in mm)
  MMMy : integer;

  MDx : integer; // Margins (in dots)
  MDy : integer;

  IMMx : integer;  // default indent (in mm)
  IDx : integer;   // default indent (in dots)

  IMMy : integer;  // default indent (in mm)
  IDy : integer;   // default indent (in dots)
  ofw  : integer;   // old font weight
  opw  : integer;   // old pen width
  cr	: TRect;     // rect to print text inside
  s   : string;
  widths : array of integer;  // widhts of the columns
  Titles : array of string;   // titles of the sections
  Nums   : array of integer;  // #s of cells to pull data from
  i,j,k,l,m : integer;
  i1, j1, k1, l1, m1 : integer;
  ytoptmp : integer;          //top part of currently printing table
  gridwidth : integer;        // grid width in pixels
  fh        : integer;
  PrintWidth : integer;
  BoldPenWidth  : integer;
  PlainPenWidth  : integer;

  crs1rect : TRect;
  crs2rect : TRect;

{$ELSE}
	OldColor 			: TColor;
  ColNums				: integer;
  Ratio					: extended;
  OldGridWidth 	: integer;
  GridWidth			: integer;
  RatioedGridWidth : integer;
  iRoot, iGlobal : IXMLDomElement;
  iSection  : IXMLDomElement;
  iLine     : IXMLDomElement;
  i							: integer;
  j					: integer;
  MyPrinter	: TPrinter;
{$ENDIF}
begin

{$IFDEF NATPRINT}
	if not PD.Execute then Exit;

  GetPrinterInfo;

  Printer.Title := 'FP #' + IntToStr(FPNum);
  Printer.BeginDoc;
  Printer.Canvas.Font.Size := fsMainHeader;

	// set Margins for ... milimeters
	MMMx := 10;
	MMMy := 10;

  MDx := MMToPixX(MMMx);
  MDy := MMToPixY(MMMy);

  IMMx := 1;
  IDx  := MMToPixX(IMMx);

  IMMy := 1;
  IDy  := MMToPixY(IMMy);


  lm := PhysOffsetX + MDx; //Margins.Left;
  tm := PhysOffsetY + MDy; //Margins.Top;
  rm := PhysPageWidth  - PhysOffsetX - MDx; //Margins.Bottom;
  bm := PhysPageHeigth - PhysOffsetY - MDy; //Margins.Right;
  PrintWidth := rm - lm;

	x  := lm;
  y  := tm;
  dy := abs(Printer.Canvas.Font.Height) + IDy;
  dx := x;

  // initial set up
  Printer.Canvas.Brush.Style := bsClear;

  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style + [fsBold];
	s := OrgShortName + '. ' +  'ФП №  ' + IntToStr(FPNum) + '  c ' + FromDateS + ' по ' + ToDateS;

  Printer.Canvas.TextOut(x + (((rm - lm) div 2) - Printer.Canvas.TextWidth(s) div 2), y, s);
  //Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Inc(y, 2 * dy);

  Printer.Canvas.Font.Size := fsHeader;
	s := 'A. Поступления';
  Printer.Canvas.TextOut(x, y, s);

  Inc(y, dy);

	ytoptmp := y;

  PlainPenWidth  := Printer.Canvas.Pen.Width;
	Printer.Canvas.Pen.Width := MMToPixY(1) div 2 ;  // 0.5 mm
	BoldPenWidth  := Printer.Canvas.Pen.Width;
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);

	Printer.Canvas.Font.Size := fsNormal;
  dy := abs(Printer.Canvas.Font.Height) + IDy;

  Inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);

  SetLength(Widths, 0);
  SetLength(Titles, 0);

  // pulling widths for section A
	SetLength(Widths, 5);
  Widths[0] := StrGrid.ColWidths[1];
  Widths[1] := StrGrid.ColWidths[2] + StrGrid.ColWidths[3];
  Widths[2] := StrGrid.ColWidths[4] + StrGrid.ColWidths[5] + StrGrid.ColWidths[6] + StrGrid.ColWidths[7] + StrGrid.ColWidths[8] + StrGrid.ColWidths[9] + StrGrid.ColWidths[10] + StrGrid.ColWidths[11];
  Widths[3] := StrGrid.ColWidths[12] + StrGrid.ColWidths[13] + StrGrid.ColWidths[14];
  Widths[4] := StrGrid.ColWidths[15] + StrGrid.ColWidths[16];

	SetLength(Nums, 5);
  Nums[0] := 1;
  Nums[1] := 2;
  Nums[2] := 4;
  Nums[3] := 12;
  Nums[4] := 15;

  gridwidth := 0;
  for i := Low(Widths) to High(Widths) do begin
  	inc(gridwidth, Widths[i]);
  end;
  for i := Low(Widths) to High(Widths) do begin
  	Widths[i] := (PrintWidth * Widths[i]) div gridwidth;
  end;


  for j := 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if StrGrid.Cells[0, j] = 's__' then begin
      SetLength(Titles, 5);
      Titles[0] := StrGrid.Cells[1, j];
      Titles[1] := StrGrid.Cells[2, j];
      Titles[2] := StrGrid.Cells[4, j];
      Titles[3] := StrGrid.Cells[12, j];
      Titles[4] := StrGrid.Cells[15, j];
      break;
    end
  end;

  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Printer.Canvas.Font.Size  := 8;

	Printer.Canvas.Pen.Width := PlainPenWidth;
  k := lm;
  for i := Low(Titles) to High(Titles) do begin
  	l := Widths[i];
    cr.Left := k;
    cr.Right := k + l;
    cr.Top := y - dy;
    cr.Bottom := y - IDy;
	  Printer.Canvas.TextRect(cr, Titles[i], [tfCenter]);
  	if i <> High(Titles) then begin
	    inc(k, l);
  	  Printer.Canvas.MoveTo(k, y - dy);
    	Printer.Canvas.LineTo(k, y);
  	end;
  end;

  inc(y, dy);
  // printing data from section A
  for i := j + 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if StrGrid.Cells[0, i] = 'a__' then begin
    	if(i > j + 1) then begin
  	  	Printer.Canvas.MoveTo(lm, y - dy);
    		Printer.Canvas.LineTo(rm, y - dy);
      end;
		  k := lm;
		  for m := Low(Nums) to High(Nums) do begin
		  	l := Widths[m];
		    cr.Left := k + IDx;
		    cr.Right := k + l - IDx;
		    cr.Top := y - dy;
		    cr.Bottom := y - IDy div 2;
        s := StrGrid.Cells[Nums[m], i];
        if(m in [0,1,3]) then
				  Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine])
        else
				  Printer.Canvas.TextRect(cr, s, [tfLeft, tfEndEllipsis, tfSingleLine]);
		  	if m <> High(Nums) then begin
	  		  inc(k, l);
		  	  Printer.Canvas.MoveTo(k, y - dy);
		    	Printer.Canvas.LineTo(k, y);
		  	end;
		  end;
      // check for next page
      if(y + dy > bm) then begin
      	// print border of the table
				Printer.Canvas.Pen.Width := BoldPenWidth;
				Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);

        // start new page
        Printer.NewPage; y := tm;

			  if StrGrid.Cells[0, i] = 'a__' then begin // if next line is from the same page, we need to print the header of the table
					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					ytoptmp := y;
					inc(y, dy);

					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					Printer.Canvas.Pen.Width := PlainPenWidth;
					k1 := lm;
					for i1 := Low(Titles) to High(Titles) do begin
					  l := Widths[i1];
					  cr.Left := k1;
					  cr.Right := k1 + l;
					  cr.Top := y - dy;
					  cr.Bottom := y - IDy;
						Printer.Canvas.TextRect(cr, Titles[i1], [tfCenter]);
					  if i1 <> High(Titles) then begin
							inc(k1, l);
					  	Printer.Canvas.MoveTo(k1, y - dy);
					    Printer.Canvas.LineTo(k1, y);
        	  end;
	        end;
  	    end;
    	end;
      // check for next page
		  inc(y, dy);
    end
    else begin
    	j := i + 1;
    	break;
    end;
  end;
  dec(y, dy);

  // draw left and right border of the table (in bold)
	Printer.Canvas.Pen.Width := BoldPenWidth;
	Printer.Canvas.MoveTo(lm, ytoptmp);
  Printer.Canvas.LineTo(lm, y);
	Printer.Canvas.LineTo(rm, y);
  Printer.Canvas.LineTo(rm, ytoptmp);

  Printer.Canvas.Font.Size := fsHeader;
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	s := StrGrid.Cells[1, j] + ' ' + StrGrid.Cells[4, j];
  Printer.Canvas.TextOut(lm, y, s);

  //
  // printing A1 section
  //
	CheckForNewPageAndFeedLine(y, 2 * dy, bm, tm);

  inc(j, 2);
  // A1 header
	s := StrGrid.Cells[1, j];
  Printer.Canvas.TextOut(x, y, s);

  // printing A1 table
  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);
  ytoptmp := y;

  SetLength(Widths, 0);
  SetLength(Titles, 0);

  // pulling widths for section A1
	SetLength(Widths, 5);
  Widths[0] := StrGrid.ColWidths[1];
  Widths[1] := StrGrid.ColWidths[2] + StrGrid.ColWidths[3] + StrGrid.ColWidths[4] + StrGrid.ColWidths[5] + StrGrid.ColWidths[6] + StrGrid.ColWidths[7] + StrGrid.ColWidths[8] + StrGrid.ColWidths[9] + StrGrid.ColWidths[10];
  Widths[2] := StrGrid.ColWidths[11] + StrGrid.ColWidths[12];
  Widths[3] := StrGrid.ColWidths[13] + StrGrid.ColWidths[14];
  Widths[4] := StrGrid.ColWidths[15] + StrGrid.ColWidths[16];

	SetLength(Nums, 5);
  Nums[0] := 1;
  Nums[1] := 2;
  Nums[2] := 11;
  Nums[3] := 13;
  Nums[4] := 15;

  for i := Low(Widths) to High(Widths) do begin
  	Widths[i] := (PrintWidth * Widths[i]) div gridwidth;
  end;

  inc(j);
  SetLength(Titles, 5);
  Titles[0] := StrGrid.Cells[1, j];
  Titles[1] := StrGrid.Cells[2, j];
  Titles[2] := StrGrid.Cells[11, j];
  Titles[3] := StrGrid.Cells[13, j];
  Titles[4] := StrGrid.Cells[15, j];

  // printing header of the table
  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Printer.Canvas.Font.Size  := 8;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);

	Printer.Canvas.Pen.Width := PlainPenWidth;
  k := lm;
  for i := Low(Titles) to High(Titles) do begin
  	l := Widths[i];
    cr.Left := k;
    cr.Right := k + l;
    cr.Top := y - dy;
    cr.Bottom := y - IDy;
	  Printer.Canvas.TextRect(cr, Titles[i], [tfCenter]);
  	if i <> High(Titles) then begin
	    inc(k, l);
  	  Printer.Canvas.MoveTo(k, y - dy);
    	Printer.Canvas.LineTo(k, y);
  	end;
  end;

  inc(y, dy);
	m1 := 0;
  for i := j + 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if Pos('a1__', StrGrid.Cells[0, i]) > 0 then begin
    	if(i > j + 1) then begin
  	  	Printer.Canvas.MoveTo(lm, y - dy);
    		Printer.Canvas.LineTo(rm, y - dy);
      end;
      if((StrGrid.Cells[2, i] <> '') or (StrGrid.Cells[11, i] <> '') or (StrGrid.Cells[13, i] <> '') or (StrGrid.Cells[15, i] <> '')) then begin
      	inc(m1);
			  k := lm;
			  for m := Low(Nums) to High(Nums) do begin
			  	l := Widths[m];
		  	  cr.Left := k + IDx;
		    	cr.Right := k + l - IDx;
			    cr.Top := y - dy;
			    cr.Bottom := y - IDy div 2;
    	    s := StrGrid.Cells[Nums[m], i];
      	  if(m in [0,2,3]) then
					  Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine])
	        else
					  Printer.Canvas.TextRect(cr, s, [tfLeft, tfEndEllipsis, tfSingleLine]);
			  	if m <> High(Nums) then begin
	  			  inc(k, l);
		  		  Printer.Canvas.MoveTo(k, y - dy);
			    	Printer.Canvas.LineTo(k, y);
			  	end;
			  end;
      // check for next page
      if(y + dy > bm) then begin
      	// print border of the table
				Printer.Canvas.Pen.Width := BoldPenWidth;
				Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);

        // start new page
        Printer.NewPage; y := tm;
        m1 := 0;

			  if (Pos('a1__', StrGrid.Cells[0, i + 1]) > 0) and
           ((StrGrid.Cells[2, i + 1] <> '') or (StrGrid.Cells[11, i + 1] <> '') or (StrGrid.Cells[13, i + 1] <> '') or (StrGrid.Cells[15, i + 1] <> '')) then begin // if next line is from the same page, we need to print the header of the table
					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					ytoptmp := y;
					inc(y, dy);

					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					Printer.Canvas.Pen.Width := PlainPenWidth;
					k1 := lm;
					for i1 := Low(Titles) to High(Titles) do begin
					  l := Widths[i1];
					  cr.Left := k1;
					  cr.Right := k1 + l;
					  cr.Top := y - dy;
					  cr.Bottom := y - IDy;
						Printer.Canvas.TextRect(cr, Titles[i1], [tfCenter]);
					  if i1 <> High(Titles) then begin
							inc(k1, l);
					  	Printer.Canvas.MoveTo(k1, y - dy);
					    Printer.Canvas.LineTo(k1, y);
        	  end;
	        end;
  	    end;
    	end;
      // check for next page
		  	inc(y, dy);
      end;
    end
    else begin
    	j := i + 1;
    	break;
    end;
  end;
  dec(y, dy);

  // draw left and right border of the table (in bold)
  if m1 > 0 then begin
		Printer.Canvas.Pen.Width := BoldPenWidth;
		Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);
  end;

  inc(y, dy);
  //printing section subtotal
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	crs1rect.Left  := lm + Widths[0] + (IDx div 2);
	crs1rect.Right := crs1rect.Left + Widths[1] - IDx;
	crs1rect.Top := y - dy;
	crs1rect.Bottom := y - IDy div 2;
  s := StrGrid.Cells[9, j];
	Printer.Canvas.TextRect(crs1rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

	crs2rect.Left   := lm + Widths[0] + Widths[1] + (IDx div 2);
	crs2rect.Right  := crs2rect.Left + Widths[2] - IDx;
  crs2rect.Top    := crs1rect.Top;
  crs2rect.Bottom := crs1rect.Bottom;
  s := StrGrid.Cells[11, j];
	Printer.Canvas.TextRect(crs2rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  inc(j, 2);
  Printer.Canvas.Font.Size := fsHeader;
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	s := StrGrid.Cells[1, j] + ' ' + StrGrid.Cells[4, j];
  Printer.Canvas.TextOut(lm, y, s);

  //
  // A1 section - end of
  //

  // printing B section
	CheckForNewPageAndFeedLine(y, 2 * dy, bm, tm);
  inc(j, 2);
  // A1 header
	s := StrGrid.Cells[1, j];
  Printer.Canvas.TextOut(x, y, s);

  // printing B table
  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);
  ytoptmp := y;

  SetLength(Widths, 0);
  SetLength(Titles, 0);

  // pulling widths for section B
	SetLength(Widths, 7);
  Widths[0] := StrGrid.ColWidths[1];
  Widths[1] := StrGrid.ColWidths[2] + StrGrid.ColWidths[3] + StrGrid.ColWidths[4] + StrGrid.ColWidths[5] + StrGrid.ColWidths[6] + StrGrid.ColWidths[7] + StrGrid.ColWidths[8];
  Widths[2] := StrGrid.ColWidths[9];
  Widths[3] := StrGrid.ColWidths[10] + StrGrid.ColWidths[11];
  Widths[4] := StrGrid.ColWidths[12];
  Widths[5] := StrGrid.ColWidths[13] + StrGrid.ColWidths[14];
  Widths[6] := StrGrid.ColWidths[15] + StrGrid.ColWidths[16];

	SetLength(Nums, 7);
  Nums[0] := 1;
  Nums[1] := 2;
  Nums[2] := 9;
  Nums[3] := 10;
  Nums[4] := 12;
  Nums[5] := 13;
  Nums[6] := 15;

  for i := Low(Widths) to High(Widths) do begin
  	Widths[i] := (PrintWidth * Widths[i]) div gridwidth;
  end;

  inc(j);
  SetLength(Titles, 7);
  Titles[0] := StrGrid.Cells[ 1, j];
  Titles[1] := StrGrid.Cells[ 2, j];
  Titles[2] := StrGrid.Cells[ 9, j];
  Titles[3] := StrGrid.Cells[10, j];
  Titles[4] := StrGrid.Cells[12, j];
  Titles[5] := StrGrid.Cells[13, j];
  Titles[6] := StrGrid.Cells[15, j];

  // printing header of the table
  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Printer.Canvas.Font.Size  := 8;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);

	Printer.Canvas.Pen.Width := PlainPenWidth;
  k := lm;
  for i := Low(Titles) to High(Titles) do begin
  	l := Widths[i];
    cr.Left := k;
    cr.Right := k + l;
    cr.Top := y - dy;
    cr.Bottom := y - IDy;
	  Printer.Canvas.TextRect(cr, Titles[i], [tfCenter]);
  	if i <> High(Titles) then begin
	    inc(k, l);
  	  Printer.Canvas.MoveTo(k, y - dy);
    	Printer.Canvas.LineTo(k, y);
  	end;
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  m1 := 0;
  for i := j + 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if Pos('b__', StrGrid.Cells[0, i]) > 0 then begin
    	if(i > j + 1) then begin
  	  	Printer.Canvas.MoveTo(lm, y - dy);
    		Printer.Canvas.LineTo(rm, y - dy);
      end;
      if((StrGrid.Cells[2, i] <> '') or (StrGrid.Cells[9, i] <> '') or (StrGrid.Cells[10, i] <> '') or (StrGrid.Cells[12, i] <> '') or (StrGrid.Cells[13, i] <> '') or (StrGrid.Cells[15, i] <> '')) then begin
        inc(m1);
			  k := lm;
			  for m := Low(Nums) to High(Nums) do begin
			  	l := Widths[m];
		  	  cr.Left := k + IDx;
		    	cr.Right := k + l - IDx;
			    cr.Top := y - dy;
			    cr.Bottom := y - IDy div 2;
    	    s := StrGrid.Cells[Nums[m], i];
      	  if(m in [0,2,3,4,5]) then
					  Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine])
	        else
					  Printer.Canvas.TextRect(cr, s, [tfLeft, tfEndEllipsis, tfSingleLine]);
			  	if m <> High(Nums) then begin
	  			  inc(k, l);
		  		  Printer.Canvas.MoveTo(k, y - dy);
			    	Printer.Canvas.LineTo(k, y);
			  	end;
			  end;
      // check for next page
      if(y + dy > bm) then begin
      	// print border of the table
				Printer.Canvas.Pen.Width := BoldPenWidth;
				Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);

        // start new page
        Printer.NewPage; y := tm;
        m1 := 0;

			  if (Pos('b__', StrGrid.Cells[0, i + 1]) > 0) and
           ((StrGrid.Cells[2, i + 1] <> '') or (StrGrid.Cells[9, i + 1] <> '') or (StrGrid.Cells[10, i + 1] <> '') or (StrGrid.Cells[12, i + 1] <> '') or (StrGrid.Cells[13, i + 1] <> '') or (StrGrid.Cells[15, i + 1] <> '')) then begin // if next line is from the same page, we need to print the header of the table
					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					ytoptmp := y;
					inc(y, dy);

					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					Printer.Canvas.Pen.Width := PlainPenWidth;
					k1 := lm;
					for i1 := Low(Titles) to High(Titles) do begin
					  l := Widths[i1];
					  cr.Left := k1;
					  cr.Right := k1 + l;
					  cr.Top := y - dy;
					  cr.Bottom := y - IDy;
						Printer.Canvas.TextRect(cr, Titles[i1], [tfCenter]);
					  if i1 <> High(Titles) then begin
							inc(k1, l);
					  	Printer.Canvas.MoveTo(k1, y - dy);
					    Printer.Canvas.LineTo(k1, y);
        	  end;
	        end;
  	    end;
    	end;
      // check for next page
		  	inc(y, dy);
      end;
    end
    else begin
    	j := i + 1;
    	break;
    end;
  end;
  dec(y, dy);

  // draw left and right border of the table (in bold)
  if m1 > 0 then begin
		Printer.Canvas.Pen.Width := BoldPenWidth;
		Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
  //inc(y, dy);
  //printing section subtotal
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	crs1rect.Top := y - dy;
	crs1rect.Bottom := y - IDy div 2;
  s := StrGrid.Cells[9, j];
	Printer.Canvas.TextRect(crs1rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

	crs2rect.Top 		:= crs1rect.Top;
	crs2rect.Bottom := crs1rect.Bottom;
  s := StrGrid.Cells[11, j];
	Printer.Canvas.TextRect(crs2rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  inc(j, 2);
  Printer.Canvas.Font.Size := fsHeader;
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	s := StrGrid.Cells[1, j] + ' ' + StrGrid.Cells[4, j];
  Printer.Canvas.TextOut(lm, y, s);

  // B section - end of

  // printing C section
	CheckForNewPageAndFeedLine(y, 2 * dy, bm, tm);
	//inc(y, 2*dy);
  inc(j, 2);
  // C header
	s := StrGrid.Cells[1, j];
  Printer.Canvas.TextOut(x, y, s);

  // printing C table
	CheckForNewPageAndFeedLine(y, dy, bm, tm);
  //inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);
  ytoptmp := y;

  SetLength(Widths, 0);
  SetLength(Titles, 0);

  // pulling widths for section C
	SetLength(Widths, 7);
  Widths[0] := StrGrid.ColWidths[1];
  Widths[1] := StrGrid.ColWidths[2] + StrGrid.ColWidths[3] + StrGrid.ColWidths[4] + StrGrid.ColWidths[5] + StrGrid.ColWidths[6] + StrGrid.ColWidths[7] + StrGrid.ColWidths[8];
  Widths[2] := StrGrid.ColWidths[9];
  Widths[3] := StrGrid.ColWidths[10] + StrGrid.ColWidths[11];
  Widths[4] := StrGrid.ColWidths[12];
  Widths[5] := StrGrid.ColWidths[13] + StrGrid.ColWidths[14];
  Widths[6] := StrGrid.ColWidths[15] + StrGrid.ColWidths[16];

	SetLength(Nums, 7);
  Nums[0] := 1;
  Nums[1] := 2;
  Nums[2] := 9;
  Nums[3] := 10;
  Nums[4] := 12;
  Nums[5] := 13;
  Nums[6] := 15;

  for i := Low(Widths) to High(Widths) do begin
  	Widths[i] := (PrintWidth * Widths[i]) div gridwidth;
  end;

  inc(j);
  SetLength(Titles, 7);
  Titles[0] := StrGrid.Cells[ 1, j];
  Titles[1] := StrGrid.Cells[ 2, j];
  Titles[2] := StrGrid.Cells[ 9, j];
  Titles[3] := StrGrid.Cells[10, j];
  Titles[4] := StrGrid.Cells[12, j];
  Titles[5] := StrGrid.Cells[13, j];
  Titles[6] := StrGrid.Cells[15, j];

  // printing header of the table
  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Printer.Canvas.Font.Size  := 8;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
  //inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);

	Printer.Canvas.Pen.Width := PlainPenWidth;
  k := lm;
  for i := Low(Titles) to High(Titles) do begin
  	l := Widths[i];
    cr.Left := k;
    cr.Right := k + l;
    cr.Top := y - dy;
    cr.Bottom := y - IDy;
	  Printer.Canvas.TextRect(cr, Titles[i], [tfCenter]);
  	if i <> High(Titles) then begin
	    inc(k, l);
  	  Printer.Canvas.MoveTo(k, y - dy);
    	Printer.Canvas.LineTo(k, y);
  	end;
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);

	m1 := 0;
  for i := j + 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if Pos('c__', StrGrid.Cells[0, i]) > 0 then begin
      if((StrGrid.Cells[2, i] <> '') or (StrGrid.Cells[9, i] <> '') or (StrGrid.Cells[10, i] <> '') or (StrGrid.Cells[12, i] <> '') or (StrGrid.Cells[13, i] <> '') or (StrGrid.Cells[15, i] <> '')) then begin
    	if(i > j + 1) then begin
  	  	Printer.Canvas.MoveTo(lm, y - dy);
    		Printer.Canvas.LineTo(rm, y - dy);
      end;
			  k := lm;
        inc(m1);
			  for m := Low(Nums) to High(Nums) do begin
			  	l := Widths[m];
		  	  cr.Left := k + IDx;
		    	cr.Right := k + l - IDx;
			    cr.Top := y - dy;
			    cr.Bottom := y - IDy div 2;
    	    s := StrGrid.Cells[Nums[m], i];
      	  if(m in [0,2,3,4,5]) then
					  Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine])
	        else
					  Printer.Canvas.TextRect(cr, s, [tfLeft, tfEndEllipsis, tfSingleLine]);
			  	if m <> High(Nums) then begin
	  			  inc(k, l);
		  		  Printer.Canvas.MoveTo(k, y - dy);
			    	Printer.Canvas.LineTo(k, y);
			  	end;
			  end;
      // check for next page
      if(y + dy > bm) then begin
      	// print border of the table
				Printer.Canvas.Pen.Width := BoldPenWidth;
				Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);

        // start new page
        Printer.NewPage; y := tm;
        m1 := 0;

			  if (Pos('c__', StrGrid.Cells[0, i + 1]) > 0) and
           ((StrGrid.Cells[2, i + 1] <> '') or (StrGrid.Cells[9, i + 1] <> '') or (StrGrid.Cells[10, i + 1] <> '') or (StrGrid.Cells[12, i + 1] <> '') or (StrGrid.Cells[13, i + 1] <> '') or (StrGrid.Cells[15, i + 1] <> '')) then begin // if next line is from the same page, we need to print the header of the table
					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					ytoptmp := y;
					inc(y, dy);

					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					Printer.Canvas.Pen.Width := PlainPenWidth;
					k1 := lm;
					for i1 := Low(Titles) to High(Titles) do begin
					  l := Widths[i1];
					  cr.Left := k1;
					  cr.Right := k1 + l;
					  cr.Top := y - dy;
					  cr.Bottom := y - IDy;
						Printer.Canvas.TextRect(cr, Titles[i1], [tfCenter]);
					  if i1 <> High(Titles) then begin
							inc(k1, l);
					  	Printer.Canvas.MoveTo(k1, y - dy);
					    Printer.Canvas.LineTo(k1, y);
        	  end;
	        end;
  	    end;
    	end;
      // check for next page
		  	inc(y, dy);
      end;
    end
    else begin
    	j := i + 1;
    	break;
    end;
  end;
  dec(y, dy);

  // draw left and right border of the table (in bold)
  if(m1 > 0) then begin
		Printer.Canvas.Pen.Width := BoldPenWidth;
		Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  //printing section subtotal
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	crs1rect.Top := y - dy;
	crs1rect.Bottom := y - IDy div 2;
  s := StrGrid.Cells[9, j];
	Printer.Canvas.TextRect(crs1rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

	crs2rect.Top 		:= crs1rect.Top;
	crs2rect.Bottom := crs1rect.Bottom;
  s := StrGrid.Cells[11, j];
	Printer.Canvas.TextRect(crs2rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  // print FP#1 line
  inc(j, 2);
	s := StrGrid.Cells[1, j];
  Printer.Canvas.TextOut(lm, y, s);

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
  cr.Left   := lm + Widths[0] + Widths[1] + IDx div 2;
  cr.Right  := cr.Left  + Widths[2] + Widths[3] - IDx;
	cr.Top 		:= y - dy;
	cr.Bottom := y - IDy div 2;
  s := StrGrid.Cells[10, j];
	Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  cr.Left   := cr.Right + IDx;
  cr.Right  := cr.Left + Widths[4] + Widths[5] - IDx;
  s := StrGrid.Cells[13, j];
	Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  // print subtotal
	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  inc(j, 2);
  Printer.Canvas.Font.Size := fsHeader;
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	s := StrGrid.Cells[1, j] + ' ' + StrGrid.Cells[4, j];
  Printer.Canvas.TextOut(lm, y, s);
  //
  // C section - end of
  //

  //
  // D section printing
  //
	CheckForNewPageAndFeedLine(y, 2 * dy, bm, tm);

  inc(j, 2);
  // D header
	s := StrGrid.Cells[1, j];
  Printer.Canvas.TextOut(x, y, s);

  // printing D table
	CheckForNewPageAndFeedLine(y, dy, bm, tm);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);
  ytoptmp := y;

  SetLength(Widths, 0);
  SetLength(Titles, 0);

  // pulling widths for section D
	SetLength(Widths, 6);
  Widths[0] := StrGrid.ColWidths[1];
  Widths[1] := StrGrid.ColWidths[2] + StrGrid.ColWidths[3] + StrGrid.ColWidths[4] + StrGrid.ColWidths[5] + StrGrid.ColWidths[6];
  Widths[2] := StrGrid.ColWidths[7] + StrGrid.ColWidths[8] + StrGrid.ColWidths[9];
  Widths[3] := StrGrid.ColWidths[10] + StrGrid.ColWidths[11] + StrGrid.ColWidths[12];
  Widths[4] := StrGrid.ColWidths[13] + StrGrid.ColWidths[14];
  Widths[5] := StrGrid.ColWidths[15] + StrGrid.ColWidths[16];

	SetLength(Nums, 7);
  Nums[0] := 1;
  Nums[1] := 2;
  Nums[2] := 7;
  Nums[3] := 10;
  Nums[4] := 13;
  Nums[5] := 15;

  for i := Low(Widths) to High(Widths) do begin
  	Widths[i] := (PrintWidth * Widths[i]) div gridwidth;
  end;

  inc(j);
  SetLength(Titles, 7);
  Titles[0] := StrGrid.Cells[ 1, j];
  Titles[1] := StrGrid.Cells[ 2, j];
  Titles[2] := StrGrid.Cells[ 9, j];
  Titles[3] := StrGrid.Cells[10, j];
  Titles[4] := StrGrid.Cells[12, j];
  Titles[5] := StrGrid.Cells[13, j];

  // printing header of the table
  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Printer.Canvas.Font.Size  := 8;

  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);

	Printer.Canvas.Pen.Width := PlainPenWidth;
  k := lm;
  for i := Low(Titles) to High(Titles) do begin
  	l := Widths[i];
    cr.Left := k;
    cr.Right := k + l;
    cr.Top := y - dy;
    cr.Bottom := y - IDy;
	  Printer.Canvas.TextRect(cr, Titles[i], [tfCenter]);
  	if i <> High(Titles) then begin
	    inc(k, l);
  	  Printer.Canvas.MoveTo(k, y - dy);
    	Printer.Canvas.LineTo(k, y);
  	end;
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  m1 := 0;
  for i := j + 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if Pos('d__', StrGrid.Cells[0, i]) > 0 then begin
    	if(i > j + 1) then begin
  	  	Printer.Canvas.MoveTo(lm, y - dy);
    		Printer.Canvas.LineTo(rm, y - dy);
      end;
      if((StrGrid.Cells[2, i] <> '') or (StrGrid.Cells[7, i] <> '') or (StrGrid.Cells[10, i] <> '') or (StrGrid.Cells[13, i] <> '') or (StrGrid.Cells[15, i] <> '')) then begin
        inc(m1);
			  k := lm;
			  for m := Low(Nums) to High(Nums) do begin
			  	l := Widths[m];
		  	  cr.Left := k + IDx;
		    	cr.Right := k + l - IDx;
			    cr.Top := y - dy;
			    cr.Bottom := y - IDy div 2;
    	    s := StrGrid.Cells[Nums[m], i];
      	  if(m in [0,2,3,4,5]) then
					  Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine])
	        else
					  Printer.Canvas.TextRect(cr, s, [tfLeft, tfEndEllipsis, tfSingleLine]);
			  	if m <> High(Nums) then begin
	  			  inc(k, l);
		  		  Printer.Canvas.MoveTo(k, y - dy);
			    	Printer.Canvas.LineTo(k, y);
			  	end;
			  end;
      // check for next page
      if(y + dy > bm) then begin
      	// print border of the table
				Printer.Canvas.Pen.Width := BoldPenWidth;
				Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);

        // start new page
        Printer.NewPage; y := tm;
        m1 := 0;
			  if (Pos('d__', StrGrid.Cells[0, i + 1]) > 0) and
           ((StrGrid.Cells[2, i + 1] <> '') or (StrGrid.Cells[7, i + 1] <> '') or (StrGrid.Cells[10, i + 1] <> '') or (StrGrid.Cells[13, i + 1] <> '') or (StrGrid.Cells[15, i + 1] <> '')) then begin // if next line is from the same page, we need to print the header of the table
					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					ytoptmp := y;
					inc(y, dy);

					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					Printer.Canvas.Pen.Width := PlainPenWidth;
					k1 := lm;
					for i1 := Low(Titles) to High(Titles) do begin
					  l := Widths[i1];
					  cr.Left := k1;
					  cr.Right := k1 + l;
					  cr.Top := y - dy;
					  cr.Bottom := y - IDy;
						Printer.Canvas.TextRect(cr, Titles[i1], [tfCenter]);
					  if i1 <> High(Titles) then begin
							inc(k1, l);
					  	Printer.Canvas.MoveTo(k1, y - dy);
					    Printer.Canvas.LineTo(k1, y);
        	  end;
	        end;
  	    end;
    	end;
      // check for next page
		  	inc(y, dy);
      end;
    end
    else begin
    	j := i + 1;
    	break;
    end;
  end;
  dec(y, dy);

  // draw left and right border of the table (in bold)
  if m1 > 0 then begin
		Printer.Canvas.Pen.Width := BoldPenWidth;
		Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  //printing section subtotal
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	crs1rect.Top := y - dy;
	crs1rect.Bottom := y - IDy div 2;
  s := StrGrid.Cells[9, j];
	Printer.Canvas.TextRect(crs1rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

	crs2rect.Top 		:= crs1rect.Top;
	crs2rect.Bottom := crs1rect.Bottom;
  s := StrGrid.Cells[11, j];
	Printer.Canvas.TextRect(crs2rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  // print subtotal
	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  inc(j, 2);
  Printer.Canvas.Font.Size := fsHeader;
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	s := StrGrid.Cells[1, j] + ' ' + StrGrid.Cells[4, j];
  Printer.Canvas.TextOut(lm, y, s);

  //
  // D section - end of
  //

  //
  // E section printing // POs
  //
	CheckForNewPageAndFeedLine(y, 2 * dy, bm, tm);
//	inc(y, 2*dy);
  inc(j, 2);
  // A1 header
	s := StrGrid.Cells[1, j];
  Printer.Canvas.TextOut(x, y, s);

  // printing D table
	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);
  ytoptmp := y;

  SetLength(Widths, 0);
  SetLength(Titles, 0);

  // pulling widths for section D
	SetLength(Widths, 8);
  Widths[0] := StrGrid.ColWidths[1];
  Widths[1] := StrGrid.ColWidths[2] + StrGrid.ColWidths[3];
  Widths[2] := StrGrid.ColWidths[4] + StrGrid.ColWidths[5] + StrGrid.ColWidths[6];
  Widths[3] := StrGrid.ColWidths[7] + StrGrid.ColWidths[8];
  Widths[4] := StrGrid.ColWidths[9] + StrGrid.ColWidths[10];
  Widths[5] := StrGrid.ColWidths[11] + StrGrid.ColWidths[12];
  Widths[6] := StrGrid.ColWidths[13] + StrGrid.ColWidths[14];
  Widths[7] := StrGrid.ColWidths[15] + StrGrid.ColWidths[16];

	SetLength(Nums, 8);
  Nums[0] :=  1;
  Nums[1] :=  2;
  Nums[2] :=  4;
  Nums[3] :=  7;
  Nums[4] :=  9;
  Nums[5] := 11;
  Nums[6] := 13;
  Nums[7] := 15;

  for i := Low(Widths) to High(Widths) do begin
  	Widths[i] := (PrintWidth * Widths[i]) div gridwidth;
  end;

  inc(j);
  SetLength(Titles, 8);
  Titles[0] := StrGrid.Cells[ 1, j];
  Titles[1] := StrGrid.Cells[ 2, j];
  Titles[2] := StrGrid.Cells[ 4, j];
  Titles[3] := StrGrid.Cells[ 7, j];
  Titles[4] := StrGrid.Cells[ 9, j];
  Titles[5] := StrGrid.Cells[11, j];
  Titles[6] := StrGrid.Cells[13, j];
  Titles[7] := StrGrid.Cells[15, j];

  // printing header of the table
  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Printer.Canvas.Font.Size  := 8;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);

	Printer.Canvas.Pen.Width := PlainPenWidth;
  k := lm;
  for i := Low(Titles) to High(Titles) do begin
  	l := Widths[i];
    cr.Left := k;
    cr.Right := k + l;
    cr.Top := y - dy;
    cr.Bottom := y - IDy;
	  Printer.Canvas.TextRect(cr, Titles[i], [tfCenter]);
  	if i <> High(Titles) then begin
	    inc(k, l);
  	  Printer.Canvas.MoveTo(k, y - dy);
    	Printer.Canvas.LineTo(k, y);
  	end;
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  m1 := 0;
  for i := j + 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if Pos('f__', StrGrid.Cells[0, i]) > 0 then begin
    	if(i > j + 1) then begin
  	  	Printer.Canvas.MoveTo(lm, y - dy);
    		Printer.Canvas.LineTo(rm, y - dy);
      end;
      inc(m1);
			k := lm;
			for m := Low(Nums) to High(Nums) do begin
				l := Widths[m];
		  	cr.Left := k + IDx;
		    cr.Right := k + l - IDx;
			  cr.Top := y - dy;
			  cr.Bottom := y - IDy div 2;
    	  s := StrGrid.Cells[Nums[m], i];
      	if(m in [0,2,3,4,5]) then
					Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine])
        else
					Printer.Canvas.TextRect(cr, s, [tfLeft, tfEndEllipsis, tfSingleLine]);
        if m <> High(Nums) then begin
	  			inc(k, l);
		  		Printer.Canvas.MoveTo(k, y - dy);
			    Printer.Canvas.LineTo(k, y);
        end;
      end;
      if(y + dy > bm) then begin
      	// print border of the table
				Printer.Canvas.Pen.Width := BoldPenWidth;
				Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);

        // start new page
        Printer.NewPage; y := tm;
        m1 := 0;
			  if Pos('f__', StrGrid.Cells[0, i + 1]) > 0 then begin // if next line is from the same page, we need to print the header of the table
					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					ytoptmp := y;
					inc(y, dy);

					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					Printer.Canvas.Pen.Width := PlainPenWidth;
					k1 := lm;
					for i1 := Low(Titles) to High(Titles) do begin
					  l := Widths[i1];
					  cr.Left := k1;
					  cr.Right := k1 + l;
					  cr.Top := y - dy;
					  cr.Bottom := y - IDy;
						Printer.Canvas.TextRect(cr, Titles[i1], [tfCenter]);
					  if i1 <> High(Titles) then begin
							inc(k1, l);
					  	Printer.Canvas.MoveTo(k1, y - dy);
					    Printer.Canvas.LineTo(k1, y);
        	  end;
	        end;
  	    end;
    	end;
		  inc(y, dy);
    end
    else begin
    	j := i + 1;
    	break;
    end;
  end;

  dec(y, dy);

  // draw left and right border of the table (in bold)
  if m1 > 0 then begin
		Printer.Canvas.Pen.Width := BoldPenWidth;
		Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  //printing section subtotal
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	crs1rect.Top := y - dy;
	crs1rect.Bottom := y - IDy div 2;
  s := StrGrid.Cells[9, j];
	Printer.Canvas.TextRect(crs1rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

	crs2rect.Top 		:= crs1rect.Top;
	crs2rect.Bottom := crs1rect.Bottom;
  s := StrGrid.Cells[11, j];
	Printer.Canvas.TextRect(crs2rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  // print subtotal
	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  inc(j, 2);
  Printer.Canvas.Font.Size := fsHeader;
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	s := StrGrid.Cells[1, j] + ' ' + StrGrid.Cells[4, j];
  Printer.Canvas.TextOut(lm, y, s);

  //
  // E section - end of
  //

  //
  // F section
  //
	CheckForNewPageAndFeedLine(y, 2 * dy, bm, tm);
//	inc(y, 2*dy);
  inc(j, 2);
  // F header
	s := StrGrid.Cells[1, j];
  Printer.Canvas.TextOut(x, y, s);

  // printing F table
	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);
  ytoptmp := y;

  SetLength(Widths, 0);
  SetLength(Titles, 0);

  // pulling widths for section F
	SetLength(Widths, 5);
  Widths[0] := StrGrid.ColWidths[1];
  Widths[1] := StrGrid.ColWidths[2] + StrGrid.ColWidths[3] + StrGrid.ColWidths[4] + StrGrid.ColWidths[5] + StrGrid.ColWidths[6] + StrGrid.ColWidths[7] + StrGrid.ColWidths[8] + StrGrid.ColWidths[9] + StrGrid.ColWidths[10];
  Widths[2] := StrGrid.ColWidths[11] + StrGrid.ColWidths[12];
  Widths[3] := StrGrid.ColWidths[13] + StrGrid.ColWidths[14];
  Widths[4] := StrGrid.ColWidths[15] + StrGrid.ColWidths[16];

	SetLength(Nums, 5);
  Nums[0] := 1;
  Nums[1] := 2;
  Nums[2] := 11;
  Nums[3] := 13;
  Nums[4] := 15;

  for i := Low(Widths) to High(Widths) do begin
  	Widths[i] := (PrintWidth * Widths[i]) div gridwidth;
  end;

  inc(j);
  SetLength(Titles, 5);
  Titles[0] := StrGrid.Cells[1, j];
  Titles[1] := StrGrid.Cells[2, j];
  Titles[2] := StrGrid.Cells[11, j];
  Titles[3] := StrGrid.Cells[13, j];
  Titles[4] := StrGrid.Cells[15, j];

  // printing header of the table
  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Printer.Canvas.Font.Size  := 8;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);

	Printer.Canvas.Pen.Width := PlainPenWidth;
  k := lm;
  for i := Low(Titles) to High(Titles) do begin
  	l := Widths[i];
    cr.Left := k;
    cr.Right := k + l;
    cr.Top := y - dy;
    cr.Bottom := y - IDy;
	  Printer.Canvas.TextRect(cr, Titles[i], [tfCenter]);
  	if i <> High(Titles) then begin
	    inc(k, l);
  	  Printer.Canvas.MoveTo(k, y - dy);
    	Printer.Canvas.LineTo(k, y);
  	end;
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  m1 := 0;
  for i := j + 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if Pos('e__', StrGrid.Cells[0, i]) > 0 then begin
    	if(i > j + 1) then begin
  	  	Printer.Canvas.MoveTo(lm, y - dy);
    		Printer.Canvas.LineTo(rm, y - dy);
      end;
      if((StrGrid.Cells[2, i] <> '') or (StrGrid.Cells[11, i] <> '') or (StrGrid.Cells[13, i] <> '') or (StrGrid.Cells[15, i] <> '')) then begin
        inc(m1);
			  k := lm;
			  for m := Low(Nums) to High(Nums) do begin
			  	l := Widths[m];
		  	  cr.Left := k + IDx;
		    	cr.Right := k + l - IDx;
			    cr.Top := y - dy;
			    cr.Bottom := y - IDy div 2;
    	    s := StrGrid.Cells[Nums[m], i];
      	  if(m in [0,2,3]) then
					  Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine])
	        else
					  Printer.Canvas.TextRect(cr, s, [tfLeft, tfEndEllipsis, tfSingleLine]);
			  	if m <> High(Nums) then begin
	  			  inc(k, l);
		  		  Printer.Canvas.MoveTo(k, y - dy);
			    	Printer.Canvas.LineTo(k, y);
			  	end;
			  end;
      // check for next page
      if(y + dy > bm) then begin
      	// print border of the table
				Printer.Canvas.Pen.Width := BoldPenWidth;
				Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);

        // start new page
        Printer.NewPage; y := tm;
        m1 := 0;

			  if (Pos('e__', StrGrid.Cells[0, i + 1]) > 0) and
           ((StrGrid.Cells[2, i + 1] <> '') or (StrGrid.Cells[11, i + 1] <> '') or (StrGrid.Cells[13, i + 1] <> '') or (StrGrid.Cells[15, i + 1] <> '')) then begin // if next line is from the same page, we need to print the header of the table
					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					ytoptmp := y;
					inc(y, dy);

					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					Printer.Canvas.Pen.Width := PlainPenWidth;
					k1 := lm;
					for i1 := Low(Titles) to High(Titles) do begin
					  l := Widths[i1];
					  cr.Left := k1;
					  cr.Right := k1 + l;
					  cr.Top := y - dy;
					  cr.Bottom := y - IDy;
						Printer.Canvas.TextRect(cr, Titles[i1], [tfCenter]);
					  if i1 <> High(Titles) then begin
							inc(k1, l);
					  	Printer.Canvas.MoveTo(k1, y - dy);
					    Printer.Canvas.LineTo(k1, y);
        	  end;
	        end;
  	    end;
    	end;
      // check for next page
		  	inc(y, dy);
      end;
    end
    else begin
    	j := i + 1;
    	break;
    end;
  end;
  dec(y, dy);

  // draw left and right border of the table (in bold)
  if m1 > 0 then begin
		Printer.Canvas.Pen.Width := BoldPenWidth;
		Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  //printing section subtotal
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	crs1rect.Top := y - dy;
	crs1rect.Bottom := y - IDy div 2;
  s := StrGrid.Cells[9, j];
	Printer.Canvas.TextRect(crs1rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  crs2rect.Top    := crs1rect.Top;
  crs2rect.Bottom := crs1rect.Bottom;
  s := StrGrid.Cells[11, j];
	Printer.Canvas.TextRect(crs2rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  inc(j, 2);
  Printer.Canvas.Font.Size := fsHeader;
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	s := StrGrid.Cells[1, j] + ' ' + StrGrid.Cells[4, j];
  Printer.Canvas.TextOut(lm, y, s);

  //
  // F section - end of
  //

  //
  // G section
  //
	CheckForNewPageAndFeedLine(y, 2 * dy, bm, tm);
//	inc(y, 2*dy);
  inc(j, 2);
  // G header
	s := StrGrid.Cells[1, j];
  Printer.Canvas.TextOut(x, y, s);
	s := StrGrid.Cells[10, j];
  m :=  StrGrid.ColWidths[1] + StrGrid.ColWidths[2] + StrGrid.ColWidths[3] + StrGrid.ColWidths[4] + StrGrid.ColWidths[5] + StrGrid.ColWidths[6] + StrGrid.ColWidths[7] + StrGrid.ColWidths[8] + StrGrid.ColWidths[9];
  m := lm +(PrintWidth * m) div gridwidth;
  Printer.Canvas.TextOut(m, y, s);

  // printing G table
	CheckForNewPageAndFeedLine(y, dy, bm, tm);
  //inc(y, dy);
  Printer.Canvas.MoveTo(lm, y);
  Printer.Canvas.LineTo(rm,	y);
  ytoptmp := y;

  SetLength(Widths, 0);
  SetLength(Titles, 0);

  // pulling widths for section F
	SetLength(Widths, 5);
  Widths[0] := StrGrid.ColWidths[1] + StrGrid.ColWidths[2] + StrGrid.ColWidths[3] + StrGrid.ColWidths[4] + StrGrid.ColWidths[5];
  Widths[1] := StrGrid.ColWidths[6] + StrGrid.ColWidths[7] + StrGrid.ColWidths[8];
  Widths[2] := StrGrid.ColWidths[9];
  Widths[3] := StrGrid.ColWidths[10] + StrGrid.ColWidths[11] + StrGrid.ColWidths[12] + StrGrid.ColWidths[13] + StrGrid.ColWidths[14];
  Widths[4] := StrGrid.ColWidths[15] + StrGrid.ColWidths[16];

	SetLength(Nums, 5);
  Nums[0] := 1;
  Nums[1] := 6;
  Nums[2] := 9;
  Nums[3] := 10;
  Nums[4] := 15;

  for i := Low(Widths) to High(Widths) do begin
  	Widths[i] := (PrintWidth * Widths[i]) div gridwidth;
  end;

  // printing header of the table
  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
  Printer.Canvas.Font.Size  := 8;
	Printer.Canvas.Pen.Width  := PlainPenWidth;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
//  inc(y, dy);
  m1 := 0;
  for i := j + 1 to StrGrid.RowCount - 1 do begin // looking for header
  	if Pos('acn__', StrGrid.Cells[0, i]) > 0 then begin
    	if(i > j + 1) then begin
  	  	Printer.Canvas.MoveTo(lm, y - dy);
    		Printer.Canvas.LineTo(rm, y - dy);
      end;
      	inc(m1);
			  k := lm;
			  for m := Low(Nums) to High(Nums) do begin
			  	l := Widths[m];
		  	  cr.Left := k + IDx;
		    	cr.Right := k + l - IDx;
			    cr.Top := y - dy;
			    cr.Bottom := y - IDy div 2;
    	    s := StrGrid.Cells[Nums[m], i];
      	  if(m in [1,4]) then
					  Printer.Canvas.TextRect(cr, s, [tfRight, tfEndEllipsis, tfSingleLine])
	        else
					  Printer.Canvas.TextRect(cr, s, [tfLeft, tfEndEllipsis, tfSingleLine]);
			  	if m <> High(Nums) then begin
	  			  inc(k, l);
		  		  Printer.Canvas.MoveTo(k, y - dy);
			    	Printer.Canvas.LineTo(k, y);
			  	end;
			  end;
      // check for next page
      if(y + dy > bm) then begin
      	// print border of the table
				Printer.Canvas.Pen.Width := BoldPenWidth;
				Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);

        // start new page
        Printer.NewPage; y := tm;
        m1 := 0;
			  if(Pos('acn__', StrGrid.Cells[0, i + 1]) > 0)then begin // if next line is from the same page, we need to print the header of the table
					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					ytoptmp := y;
					inc(y, dy);

					Printer.Canvas.MoveTo(lm, y);
					Printer.Canvas.LineTo(rm,	y);
					Printer.Canvas.Pen.Width := PlainPenWidth;
  	    end;
    	end;
      // check for next page
		  	inc(y, dy);
    end
    else begin
    	j := i + 1;
    	break;
    end;
  end;
  dec(y, dy);

  // draw left and right border of the table (in bold)
  if m1 > 0 then begin
		Printer.Canvas.Pen.Width := BoldPenWidth;
		Printer.Canvas.MoveTo(lm, ytoptmp); Printer.Canvas.LineTo(lm, y); Printer.Canvas.LineTo(rm, y); Printer.Canvas.LineTo(rm, ytoptmp);
  end;

	CheckForNewPageAndFeedLine(y, dy, bm, tm);
  //inc(y, dy);
  //printing section subtotal
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	crs1rect.Top := y - dy;
	crs1rect.Bottom := y - IDy div 2;
  s := StrGrid.Cells[9, j];
	Printer.Canvas.TextRect(crs1rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  crs2rect.Top    := crs1rect.Top;
  crs2rect.Bottom := crs1rect.Bottom;
  s := StrGrid.Cells[11, j];
	Printer.Canvas.TextRect(crs2rect, s, [tfRight, tfEndEllipsis, tfSingleLine]);

  inc(j, 2);
  Printer.Canvas.Font.Size := fsHeader;
  Printer.Canvas.Font.Style :=   Printer.Canvas.Font.Style + [fsBold];
	s := StrGrid.Cells[1, j] + ' ' + StrGrid.Cells[4, j];
  Printer.Canvas.TextOut(lm, y, s);

  //
  // G section - end of
  //

  Printer.EndDoc;
{$ELSE}
	MyPrinter := Printer;

	if not PD.Execute then Exit;

  MainXML := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  iRoot := MainXML.createElement('FP');
  MainXML.appendChild(iRoot);

  iGlobal := MainXML.createElement('Globals');
  iRoot.appendChild(iGlobal);

  AddTextValue(MainXML, iGlobal, 'FPNumber', IntToStr(FPNum));

  iSection  := MainXML.createElement('SectionA');
  iRoot.appendChild(iSection);

  for i := 3 to StrGrid.RowCount - 1 do begin
  	if StrGrid.Cells[0, i] = 'a__' then begin
		  iLine     := MainXML.createElement('LineA');
  		iSection.appendChild(iLine);
	  	AddTextValue(MainXML, iLine, 'N', 				StrGrid.Cells[1, i]);
	  	AddTextValue(MainXML, iLine, 'Sum', 			StrGrid.Cells[2, i]);
		  AddTextValue(MainXML, iLine, 'Descr', 		Trim(StrGrid.Cells[4, i]));
  		AddTextValue(MainXML, iLine, 'DateTime',	StrGrid.Cells[12, i]);
		  AddTextValue(MainXML, iLine, 'Source',		StrGrid.Cells[15, i]);
    end
    else
    	break;
  end;
  inc(i);
	AddTextValue(MainXML, iGlobal, 'TGI', StrGrid.Cells[4, i]);
  inc(i,4);

  j := i;
  iSection  := MainXML.createElement('SectionA1');
  iRoot.appendChild(iSection);
  for i := j to StrGrid.RowCount - 1 do begin
  	if Pos('a1__', StrGrid.Cells[0, i]) > 0 then begin
		  iLine     := MainXML.createElement('LineA1');
  		iSection.appendChild(iLine);
	  	AddTextValue(MainXML, iLine, 'N', 				StrGrid.Cells[1, i]);
		  AddTextValue(MainXML, iLine, 'Descr', 		Trim(StrGrid.Cells[2, i]));
	  	AddTextValue(MainXML, iLine, 'FP1', 			StrGrid.Cells[8, i]);
  		AddTextValue(MainXML, iLine, 'Percent',		StrGrid.Cells[11, i]);
	  	AddTextValue(MainXML, iLine, 'Sum', 			StrGrid.Cells[13, i]);
		  AddTextValue(MainXML, iLine, 'Fund',			StrGrid.Cells[15, i]);
    end
    else
    	break;
  end;
  inc(i);
	AddTextValue(MainXML, iGlobal, 'TotA1', StrGrid.Cells[11, i]);
  inc(i,2);
	AddTextValue(MainXML, iGlobal, 'GI', StrGrid.Cells[4, i]);

  inc(i,4);
  j := i;
  iSection  := MainXML.createElement('SectionB');
  iRoot.appendChild(iSection);
  for i := j to StrGrid.RowCount - 1 do begin
  	if 'b__' = StrGrid.Cells[0, i] then begin
		  iLine     := MainXML.createElement('LineB');
  		iSection.appendChild(iLine);
	  	AddTextValue(MainXML, iLine, 'N', 				StrGrid.Cells[1, i]);
		  AddTextValue(MainXML, iLine, 'Descr', 		Trim(StrGrid.Cells[2, i]));
	  	AddTextValue(MainXML, iLine, 'FP1', 			StrGrid.Cells[8, i]);
  		AddTextValue(MainXML, iLine, 'Percent',		StrGrid.Cells[11, i]);
	  	AddTextValue(MainXML, iLine, 'Sum', 			StrGrid.Cells[13, i]);
		  AddTextValue(MainXML, iLine, 'Fund',			StrGrid.Cells[15, i]);
    end
    else
    	break;
  end;
  inc(i);
	AddTextValue(MainXML, iGlobal, 'TotB', StrGrid.Cells[11, i]);
  inc(i,2);
	AddTextValue(MainXML, iGlobal, 'CGI', StrGrid.Cells[4, i]);

  inc(i,4);
  j := i;
  iSection  := MainXML.createElement('SectionC');
  iRoot.appendChild(iSection);
  for i := j to StrGrid.RowCount - 1 do begin
  	if 'c__' = StrGrid.Cells[0, i] then begin
		  iLine     := MainXML.createElement('LineC');
  		iSection.appendChild(iLine);
	  	AddTextValue(MainXML, iLine, 'N', 				StrGrid.Cells[1, i]);
		  AddTextValue(MainXML, iLine, 'Descr', 		Trim(StrGrid.Cells[2, i]));
	  	AddTextValue(MainXML, iLine, 'FP1', 			StrGrid.Cells[8, i]);
  		AddTextValue(MainXML, iLine, 'Percent',		StrGrid.Cells[11, i]);
	  	AddTextValue(MainXML, iLine, 'Sum', 			StrGrid.Cells[13, i]);
		  AddTextValue(MainXML, iLine, 'Fund',			StrGrid.Cells[15, i]);
    end
    else
    	break;
  end;
  inc(i);
	AddTextValue(MainXML, iGlobal, 'TotC', StrGrid.Cells[11, i]);
  inc(i,2);
	AddTextValue(MainXML, iGlobal, 'BalC', StrGrid.Cells[4, i]);

  inc(i,4);
  j := i;
  iSection  := MainXML.createElement('SectionD');
  iRoot.appendChild(iSection);
  for i := j to StrGrid.RowCount - 1 do begin
  	if 'd__' = StrGrid.Cells[0, i] then begin
		  iLine     := MainXML.createElement('LineD');
  		iSection.appendChild(iLine);
	  	AddTextValue(MainXML, iLine, 'N', 				StrGrid.Cells[1, i]);
		  AddTextValue(MainXML, iLine, 'Descr', 		Trim(StrGrid.Cells[2, i]));
	  	AddTextValue(MainXML, iLine, 'FP1', 			StrGrid.Cells[7, i]);
  		AddTextValue(MainXML, iLine, 'Note',			StrGrid.Cells[10, i]);
	  	AddTextValue(MainXML, iLine, 'Sum', 			StrGrid.Cells[13, i]);
		  AddTextValue(MainXML, iLine, 'Fund',			StrGrid.Cells[15, i]);
    end
    else
    	break;
  end;
  inc(i);
	AddTextValue(MainXML, iGlobal, 'TotD', StrGrid.Cells[11, i]);
  inc(i,2);
	AddTextValue(MainXML, iGlobal, 'BalD', StrGrid.Cells[4, i]);

  inc(i,4);
  j := i;
  iSection  := MainXML.createElement('SectionE');
  iRoot.appendChild(iSection);
  for i := j to StrGrid.RowCount - 1 do begin
  	if 'f__' = StrGrid.Cells[0, i] then begin
    	if StrGrid.Cells[9, i] <> 'Отложить' then begin
			  iLine     := MainXML.createElement('LineE');
  			iSection.appendChild(iLine);
	  		AddTextValue(MainXML, iLine, 'N', 				StrGrid.Cells[1, i]);
		  	AddTextValue(MainXML, iLine, 'Date', 			Trim(StrGrid.Cells[2, i]));
			  AddTextValue(MainXML, iLine, 'Subj', 			Trim(StrGrid.Cells[4, i]));
		  	AddTextValue(MainXML, iLine, 'SumR', 			StrGrid.Cells[7, i]);
	  		AddTextValue(MainXML, iLine, 'Sol', 			StrGrid.Cells[9, i]);
  			AddTextValue(MainXML, iLine, 'SumA',			StrGrid.Cells[11, i]);
		  	AddTextValue(MainXML, iLine, 'Note', 			StrGrid.Cells[13, i]);
			  AddTextValue(MainXML, iLine, 'Fund',			StrGrid.Cells[15, i]);
      end;
    end
    else
    	break;
  end;
  inc(i);
	AddTextValue(MainXML, iGlobal, 'TotE', StrGrid.Cells[11, i]);
  inc(i);
	AddTextValue(MainXML, iGlobal, 'TotEI', StrGrid.Cells[11, i]);
  inc(i,2);
	AddTextValue(MainXML, iGlobal, 'BalE', StrGrid.Cells[4, i]);

  inc(i,4);
  j := i;
  iSection  := MainXML.createElement('SectionF');
  iRoot.appendChild(iSection);
  for i := j to StrGrid.RowCount - 1 do begin
  	if 'e__' = StrGrid.Cells[0, i] then begin
		  iLine     := MainXML.createElement('LineF');
 			iSection.appendChild(iLine);
  		AddTextValue(MainXML, iLine, 'N', 				StrGrid.Cells[1, i]);
	  	AddTextValue(MainXML, iLine, 'Desr', 			Trim(StrGrid.Cells[2, i]));
		  AddTextValue(MainXML, iLine, 'Percent', 	StrGrid.Cells[11, i]);
	  	AddTextValue(MainXML, iLine, 'Sum', 			StrGrid.Cells[13, i]);
		  AddTextValue(MainXML, iLine, 'Fund',			StrGrid.Cells[15, i]);
    end
    else
    	break;
  end;
  inc(i);
	AddTextValue(MainXML, iGlobal, 'TotF', 	StrGrid.Cells[11, i]);
  inc(i,2);
	AddTextValue(MainXML, iGlobal, 'FPBal', StrGrid.Cells[4, i]);
	AddTextValue(MainXML, iGlobal, 'FromDate', FromDateS);
	AddTextValue(MainXML, iGlobal, 'ToDate', ToDateS);

  inc(i,3);
  j := i;
  iSection  := MainXML.createElement('SectionG');
  iRoot.appendChild(iSection);
  for i := j to StrGrid.RowCount - 1 do begin
  	if 'acn__' = StrGrid.Cells[0, i] then begin
		  iLine     := MainXML.createElement('LineG');
 			iSection.appendChild(iLine);
  		AddTextValue(MainXML, iLine, 'Acc',	StrGrid.Cells[1, i]);
	  	AddTextValue(MainXML, iLine, 'Sum',	StrGrid.Cells[6, i]);
    end
    else
    	break;
  end;

  MainXML.save('FP4111.xml');
  MainXML := nil;
  FP := LoadFP('FP4111.xml');

	RpDev.SelectPrinter(MyPrinter.Printers[MyPrinter.PrinterIndex], true);
  RvSystem.DefaultDest := rdPrinter;

  RvSystem.SystemSetups := RvSystem.SystemSetups - [ssAllowSetup];

  RvProject.ExecuteReport('Report3');
  DeleteFile('FP4111.xml');

  Exit;

{$ENDIF}
end;

function TFPAllocForm.ProcessFormula(ARow, ACol : integer) : extended;

  function FindCellByString(AStr:string; var FRow, FCol: integer) : boolean;
  var
    BegStr      : string;
    CellNum     : integer;
    LineNum     : integer;
    i           : integer;
    CurLineNum  : integer;
  begin
    FRow    := 0;	FCol    := 0;
    Result  := false;
    if AStr = 'tgi' then begin
      FRow  := TGIStrNum;
      FCol  := 4;
      Result := true;
    end
    else if AStr = 'gi' then begin
      FRow  := GIStrNum;
      FCol  := 4;
      Result := true;
    end
    else begin // none of special strings
      BegStr := LeftStr(AStr, 1);
      if not TryStrToInt(RightStr(AStr, 1), CellNum) then
        Exit;
      if not TryStrToInt(MidStr(AStr, 2, Length(AStr) - 2), LineNum) then
        Exit;
      for i := 0 to StrGrid.RowCount - 1 do begin
        if (Pos(BegStr+'__', StrGrid.Cells[0,i])>0) and (TryStrToInt(StrGrid.Cells[1,i], CurLineNum)) and (LineNum = CurLineNum) then begin
          case BegStr[1] of
            'b' : begin
              if CellNum = 1 then begin
                FRow := i;  FCol := 2;  Result := true;
              end
              else if CellNum = 2 then begin
                FRow := i;  FCol := 8;  Result := true;
              end
              else if CellNum = 3 then begin
                FRow := i;  FCol := 11; Result := true;
              end
              else if CellNum = 4 then begin
                FRow := i;  FCol := 13; Result := true;
              end
            end;
          end;
          break;
        end;
      end;
    end;
  end; // function FindCellByString

var
  Total         : extended;
  StrToAn       : string;
  arg1          : string;
  res1          : extended;
  arg2          	: string;
  res2          	: extended;
  i,  j         	: integer;
  tColNum       	: integer;
  tRowNum       	: integer;
  ErrorOccured  	: boolean;
  LastOper1			: char;
  LastOper2      : char;
begin
  StrToAn  := StrGrid.Cells[aCol, aRow];
  ErrorOccured := false;
  arg1  := '';
  arg2  := '';
  LastOper1 := Chr(0);
  LastOper2 := Chr(0);
  i := 1;
  j := i;
//  for j := i to Length(StrToAn) do begin
  while j<= Length(StrToAn) do begin
    if Pos(StrToAn[j], '*/+-') > 0 then begin
      if LastOper1 = Chr(0) then
        LastOper1 := StrToAn[j]
      else begin
        LastOper2 := StrToAn[j]
      end;
      if Arg1 = '' then begin
        arg1 := MidStr(StrToAn, i, j-i);
        if (not TryStrToFloat(arg1, Result)) and
           (FindCellByString(arg1, tRowNum, tColNum) and
             (not TryStrToFloat(ReplaceStr(StrGrid.Cells[tColNum, tRowNum], ThSep, ''), result))) then begin
          Result := 0;
          ErrorOccured := true;
          break;
        end
      end
      else begin
        arg2 := MidStr(StrToAn, i, j-i);
        if (not TryStrToFloat(arg2, res2)) and
           (FindCellByString(arg2, tRowNum, tColNum) and
           (not TryStrToFloat(ReplaceStr(StrGrid.Cells[tColNum, tRowNum], ThSep, ''), res2))) then begin
          Result := 0;
          ErrorOccured := true;
          break;
        end
      end;
      if (arg1 <> '') and (arg2 <> '') then begin
        case LastOper1 of
          '+' : begin
            Result := Result + res2;
          end;
          '-' : begin
            Result := Result - res2;
          end;
          '*' : begin
            Result := Result * res2;
          end;
          '/' : begin
            Result := Result / res2;
          end;
        end; // case
        arg1 := arg2;
        LastOper1 := LastOper2;
        arg2 := '';
      end;
      i := j + 1;
    end;
    inc(j);
  end;
  if not ErrorOccured then begin
    arg2 := MidStr(StrToAn, i, j-1);
    if (not TryStrToFloat(arg2, res2)) and
       (FindCellByString(arg2, tRowNum, tColNum) and
       (not TryStrToFloat(ReplaceStr(StrGrid.Cells[tColNum, tRowNum], ThSep, ''), res2))) then begin
      Result := 0;
      ErrorOccured := true;
    end;
    if not ErrorOccured then begin
        case LastOper1 of
          '+' : begin
            Result := Result + res2;
          end;
          '-' : begin
            Result := Result - res2;
          end;
          '*' : begin
            Result := Result * res2;
          end;
          '/' : begin
            Result := Result / res2;
          end;
        end; // case
    end;
  end;

end;

end.
