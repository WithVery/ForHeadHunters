unit MainFPWin;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, acCoolBar, ToolWin, sToolBar, StdCtrls, Buttons, sBitBtn,
  ImgList, acAlphaImageList, Menus, sTabControl, VirtualTrees, sPageControl,
  POWindow,
  GlobalVars,
  UsersWindow,
  ZConnection,
  ZDataset,
  OleServer,
  NewOrgWizWelcomeWindow,
  NOWStep1Window,
  NOWStep2Window,
  ActiveX,
  ClipBrd,
	UpdateThread, // for TUpdateThread
{$IFDEF TLOG}
  PushToDBThread,
{$ENDIF}
	AttSaverThread,
	AttRemoverThread,
  FPAllocWindow,
  LoadingProgressWindow,
  sStatusBar, sSkinManager,
  sGroupBox, ExtCtrls, sSplitter, sPanel, sButton,
  Grids, BaseGrid,
  AdvObj,
  AdvGrid,
  sLabel, sSpeedButton, sSkinProvider, sEdit, Mask, sMaskEdit, sCustomComboEdit, sTooledit,
  sComboBox, sScrollBox, ActnList, AdvUtil, System.ImageList;

resourcestring
  rsDescSortSuffix  = '[v]';
  rsAscSortSuffix   = '[^]';

  rsFltPrefix       = 'flt_';
  rsSubPrefix       = 'sub_';
  rsUrgentSuffix    = '_urgent';
  rsSubdPORow       = 'yellow';
  rsSubdPOUrgentRow = 'yellow_urgent';
  rsSubdPOHeaderRow = 'h_yellow';
  rsSubdPOTotalRow  = 'sub_yellow';
  rsSubdPOFilterRow = 'flt_yellow';

  rsRejdPORow       = 'red';
  rsRejdPOUrgentRow = 'red_urgent';
  rsRejdPOHeaderRow = 'h_red';
  rsRejdPOTotalRow  = 'sub_red';
  rsRejdPOFilterRow = 'flt_red';

  rsAppdPORow       = 'green';
  rsAppdPOUrgentRow = 'green_urgent';
  rsAppdPOHeaderRow = 'h_green';
  rsAppdPOTotalRow  = 'sub_green';
  rsAppdPOFilterRow = 'flt_green';

  rsPaidPORow       = 'gray';
  rsPaidPOUrgentRow = 'gray_urgent';
  rsPaidPOHeaderRow = 'h_gray';
  rsPaidPOTotalRow  = 'sub_gray';
  rsPaidPOFilterRow = 'flt_gray';

	rsSubdPOHeaderMain = 'A. Выставленные заявки';
	rsSubdPOHeaderNum  = '№';
	rsSubdPOHeaderDate = 'Дата';
	rsSubdPOHeaderSubj = 'Тема';
	rsSubdPOHeaderSum  = 'Сумма';
	rsSubdPOHeaderCash = 'Тип';
	rsSubdPOHeaderAuth = 'Автор';
	rsSubdPOHeaderTot  = 'Итого';

  rsRejdPOHeaderMain = 'Б. Отклоненные';
  rsRejdPOHeaderNum  = '№';
  rsRejdPOHeaderDate = 'Дата';
  rsRejdPOHeaderSubj = 'Тема';
  rsRejdPOHeaderSum  = 'Сумма';
  rsRejdPOHeaderAuth = 'Автор';
  rsRejdPOHeaderSig  = 'Подпись';
  rsRejdPOHeaderTot  = 'Итого';

  rsAppdPOHeaderMain = 'В. Одобренные. В том числе срочные (выделены красным)';
  rsAppdPOHeaderNum  = '№';
  rsAppdPOHeaderDate = 'Дата';
  rsAppdPOHeaderSubj = 'Тема';
  rsAppdPOHeaderSum  = 'Сумма';
  rsAppdPOHeaderSumA = 'Одобрено';
	rsAppdPOHeaderCash = 'Тип';
  rsAppdPOHeaderAuth = 'Автор';
//  rsAppdPOHeaderSig  = 'Подпись';
  rsAppdPOHeaderFnd  = 'Источник';
  rsAppdPOHeaderTot  = 'Итого';

  rsPaidPOHeaderMain    = 'Г. Оплаченные. В том числе срочные (выделены красным)';
  rsPaidPOHeaderNum     = '№';
  rsPaidPOHeaderDate    = 'Дата';
  rsPaidPOHeaderSubj    = 'Тема';
  rsPaidPOHeaderFPNo    = 'ФП';
  rsPaidPOHeaderPayDate = 'Дата оплаты';
  rsPaidPOHeaderSumP    = 'Оплачено';
//  rsPaidPOHeaderCash    = 'Тип';
  rsPaidPOHeaderCash    = 'Нал/безнал';
  rsPaidPOHeaderAuth    = 'Автор';
  rsPaidPOHeaderFnd     = 'Источник';
  rsPaidPOHeaderTot     = 'Итого';
  rsPaidPOHeaderType    = 'Вид оплаты';

  rsListCreditors       = 'Кредиторы';
  rsListDebtors         = 'Дебиторы';


const
  stString = 0;
  stDate   = 1;
  stFloat  = 2;
  stNum    = 3;

type
  TMainFPForm = class(TForm)
    sToolBar1             : TsToolBar;
    sAlphaImageList1      : TsAlphaImageList;
    MainGroupSplitter     : TsSplitter;
    MainPanel             : TsPanel;
    StrGrid               : TAdvStringGrid;
    ToolButton6           : TToolButton;
    ToolButton11          : TToolButton;
    ToolButton14          : TToolButton;
    GridPanel: TsPanel;
    PD: TPrintDialog;
    IncomeInvoicingBtn: TsSpeedButton;
    DisbToolButton: TsSpeedButton;
    TransferToolButton: TsSpeedButton;
    DebtingButton: TsSpeedButton;
    CreditingButton: TsSpeedButton;
    NewPOToolButton: TsSpeedButton;
    PrintToolButton: TsSpeedButton;
    MainTree: TVirtualStringTree;
    TreeImages: TsAlphaImageList;
    GridGroupBox: TsGroupBox;
    MainTreePopupMenu: TPopupMenu;
    MainTreePopupImages: TsAlphaImageList;
    PopUpItemPropShow: TMenuItem;
    PopUpEnterBalance: TMenuItem;
    PopUpWhatIsIt: TMenuItem;
    PopUpAddEntity: TMenuItem;
    PopUpDelete: TMenuItem;
    StrGridPopupMenu: TPopupMenu;
    StrGridPopupImages: TsAlphaImageList;
    SGPopUpDelete: TMenuItem;
    SGPopupWhatIsIt: TMenuItem;
    SGPopUpClose: TMenuItem;
    DebCredPopupMenu: TPopupMenu;
    DCPopUpList: TMenuItem;
    DCPopUpDel: TMenuItem;
    MenuItem3: TMenuItem;
    DCPopUpProp: TMenuItem;
    DebCredImages: TsAlphaImageList;
    DCPopUpSearch: TMenuItem;
    DCPopupAdd: TMenuItem;
    N1: TMenuItem;
    ExportToExcelButton: TsSpeedButton;
    SearchToolBar: TsToolBar;
    sButton4: TsButton;
    SearchTypeCombo: TsComboBox;
    sButton1: TsButton;
    SearchSourceCombo: TsComboBox;
    sButton3: TsButton;
    StartDateEdit: TsDateEdit;
    sButton2: TsButton;
    EndDateEdit: TsDateEdit;
    sButton5: TsButton;
    StringEdit: TsEdit;
    SearchToolButton: TsBitBtn;
    ShowFundsVsAssetWindowPopUp: TMenuItem;
    TimeFilterToolBar: TsToolBar;
    sButton6: TsButton;
    PeriodCombo: TsComboBox;
    FilterOutByFixedPeriodBtn: TsBitBtn;
    ToolButton9: TToolButton;
    sButton8: TsButton;
    FilterDateStartEdit: TsDateEdit;
    sButton9: TsButton;
    FilterDateEndEdit: TsDateEdit;
    FilterOutByArbPeriodBtn: TsBitBtn;
    TimeFilterToolButton: TsSpeedButton;
    TimeFilterImages: TsAlphaImageList;
    SubmittedPOToolBtn: TsBitBtn;
    ToolButton4: TToolButton;
    RejectedPOToolBtn: TsBitBtn;
    ApprovedPOToolBtn: TsBitBtn;
    PaidPOToolBtn: TsBitBtn;
    POsPopUpMenu: TPopupMenu;
    POsPopUpImages: TsAlphaImageList;
    EditPOPopUp: TMenuItem;
    NewPOByTemplate: TMenuItem;
    ReviewPOPopUp: TMenuItem;
    FindImagesList: TsAlphaImageList;
    N2: TMenuItem;
    ShowPOPopUp: TMenuItem;
    SubmittedPOPopUp: TMenuItem;
    RejectedPOPopUp: TMenuItem;
    ApprovedPOPopUp: TMenuItem;
    PaidPOPopUp: TMenuItem;
    AllPOPopUp: TMenuItem;
    IncomeSourcesButton: TsSpeedButton;
    StatsSplitter: TsSplitter;
    StatsScrollBox: TsScrollBox;
    ShowHidePOPopUp: TMenuItem;
    SubmittedPOPopUpSH: TMenuItem;
    RejectedPOPopUpSH: TMenuItem;
    ApprovedPOPopUpSH: TMenuItem;
    PaidPOPopUpSH: TMenuItem;
    ToolButton1: TToolButton;
    AboutButton: TsSpeedButton;
    NewOrgWizButton: TsSpeedButton;
    PwdButton: TsSpeedButton;
    PopUpRenameOrg: TMenuItem;
    N3: TMenuItem;
    UnapprovePOPopUp: TMenuItem;
    SGPopUpEdit: TMenuItem;
    DelPOPopUp: TMenuItem;
    sb: TsStatusBar;
    RTimer: TTimer;
    PopUpShowHideArchedFunds: TMenuItem;
    ArchUnarchFund: TMenuItem;
    UTimer: TTimer;
    FLPopupMenu: TPopupMenu;
    FLPopupImages: TsAlphaImageList;
    FLPopShowPOs: TMenuItem;
    TreeImagesVT: TsVirtualImageList;
    PersImages: TsAlphaImageList;
    PersPopupMenu: TPopupMenu;
    PersList: TMenuItem;
    PersFind: TMenuItem;
    PersAdd: TMenuItem;
    PersDel: TMenuItem;
    PersProps: TMenuItem;
    PersWhatIsIt: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure StrGridGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure StrGridGetFormat(Sender: TObject; ACol: Integer; var AStyle: TSortStyle; var aPrefix, aSuffix: string);
    procedure StrGridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure StrGridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor: TEditorType);
    procedure StrGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ExitButtonClick(Sender: TObject);
    procedure IncomeInvoicingBtnClick(Sender: TObject);
    procedure DisbToolButtonClick(Sender: TObject);
    procedure TransferToolButtonClick(Sender: TObject);
    procedure DebtingButtonClick(Sender: TObject);
    procedure CreditingButtonClick(Sender: TObject);
    procedure NewPOToolButtonClick(Sender: TObject);
    procedure PrintToolButtonClick(Sender: TObject);
    procedure StrGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MainGroupSplitterMoved(Sender: TObject);
    procedure MainTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure MainTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure MainTreeDblClick(Sender: TObject);
    procedure MainTreeDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure MainTreeDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState;
      Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure MainTreeDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
      Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure MainTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PopUpEnterBalanceClick(Sender: TObject);
    procedure PopUpItemPropShowClick(Sender: TObject);
    procedure PopUpAddEntityClick(Sender: TObject);
    procedure PopUpDeleteClick(Sender: TObject);
    procedure MainTreeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SGPopUpDeleteClick(Sender: TObject);
    procedure StrGridRightClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SGPopUpCloseClick(Sender: TObject);
    procedure DCPopUpSearchClick(Sender: TObject);
    procedure DCPopUpPropClick(Sender: TObject);
    procedure DCPopupAddClick(Sender: TObject);
    procedure DCPopUpDelClick(Sender: TObject);
    procedure DCPopUpListClick(Sender: TObject);
    procedure StrGridUpdateColumnSize(Sender: TObject; ACol: Integer; var AWidth: Integer);
    procedure StrGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure StrGridExit(Sender: TObject);
    procedure MainTreeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ExportToExcelButtonClick(Sender: TObject);
    procedure SearchToolButtonClick(Sender: TObject);
    procedure StringEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure ShowFundsVsAssetWindowPopUpClick(Sender: TObject);
    procedure TimeFilterToolButtonClick(Sender: TObject);
//    procedure IncPlanButtonClick(Sender: TObject);
    procedure FilterOutByFixedPeriodBtnClick(Sender: TObject);
    procedure FilterOutByArbPeriodBtnClick(Sender: TObject);
    procedure SubmittedPOToolBtnClick(Sender: TObject);
    procedure RejectedPOToolBtnClick(Sender: TObject);
    procedure ApprovedPOToolBtnClick(Sender: TObject);
    procedure PaidPOToolBtnClick(Sender: TObject);
    procedure NewPOByTemplateClick(Sender: TObject);
    procedure EditPOPopUpClick(Sender: TObject);
    procedure ReviewPOPopUpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SubmittedPOPopUpClick(Sender: TObject);
    procedure RejectedPOPopUpClick(Sender: TObject);
    procedure ApprovedPOPopUpClick(Sender: TObject);
    procedure PaidPOPopUpClick(Sender: TObject);
    procedure AllPOPopUpClick(Sender: TObject);
    procedure StrGridGetCellPrintColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure StrGridGetCellPrintBorder(Sender: TObject; ARow, ACol: Integer; APen: TPen; var Borders: TCellBorders);
    procedure DirIncSourcesClick(Sender: TObject);
    // To open a form as a separate window
    procedure ShowIncSourceDirectory;
    procedure MainMenuItemExitClick(Sender: TObject);
    procedure IncomeSourcesButtonClick(Sender: TObject);
    procedure MainTreeCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure MainTreeExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SubmittedPOPopUpSHClick(Sender: TObject);
    procedure RejectedPOPopUpSHClick(Sender: TObject);
    procedure ApprovedPOPopUpSHClick(Sender: TObject);
    procedure PaidPOPopUpSHClick(Sender: TObject);
    procedure MainTreeHeaderMouseUp(Sender: TVTHeader; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AboutButtonClick(Sender: TObject);
    procedure NewOrgWizButtonClick(Sender: TObject);
    procedure PwdButtonClick(Sender: TObject);
    procedure PopUpRenameOrgClick(Sender: TObject);
    procedure UnapprovePOPopUpClick(Sender: TObject);
    procedure SGPopUpEditClick(Sender: TObject);
    procedure DelPOPopUpClick(Sender: TObject);
    procedure RTimerTimer(Sender: TObject);
    procedure PopUpShowHideArchedFundsClick(Sender: TObject);
    procedure MainTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ArchUnarchFundClick(Sender: TObject);
    procedure UTimerTimer(Sender: TObject);
    procedure FLPopShowPOsClick(Sender: TObject);
    procedure StrGridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure StrGridSelectionChanged(Sender: TObject; ALeft, ATop, ARight, ABottom: Integer);
    procedure MainTreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure PersAddClick(Sender: TObject);
    procedure PersPropsClick(Sender: TObject);
    procedure PersListClick(Sender: TObject);
  private
    { Private declarations }
    MainGridIsBeingUpdated: Boolean;
    CurNode       : PVirtualNode;
    CurValue      : integer;
    PrevValue     : integer;
  	CurPrefix			: string;
    CurPrivs      : string;
    CurOInd       : integer;

    CEL_ErrCode   : integer;
    CEL_StatusCode: string;
    CEL_Message   : string;
    CurTable      : string;
    CurGridRows   : integer;
    CurFPNum      : integer;
    CurPONum			: integer;
    TmpFundCombo  : TComboBox;
    FondList      : TList;
    AssetList			: TList;

{$IFNDEF DLLNOTHREADS}
    UpdateThread	: TUpdateThread;
    SaverThread		: TAttSaverThread;
    RemoverThread : TAttRemoverThread;
{$ENDIF}

{$IFDEF TLOG}
  	LogPullTimer  : TTimer;
{$ENDIF}

  	POFilters     : TStringList;

    POForm				: TPOForm;
    PrintingIsIP 	: boolean;
		
    // MainTree variables
    AssetNode				: PVirtualNode; 		// Root node for asset branch
    FundNode        : PVirtualNode;			// root node for Funds branch

    AssetNodesArr		: TAPVN; //array of PVirtualNode;      // array of root nodes for Assets
  	BankNodesArr		: TAPVN; //array of PVirtualNode;			// array of root nodes for Bank accounts
    FundNodesArr    : TAPVN; //array of PVirtualNode;			// array of root nodes for Funds branch
		RNodesArr				: TAPVN; //array of PVirtualNode;			// array of root nodes for orgs
    FPArchNodesArr	: array of PVirtualNode;			// array of approved FP nodes for orgs
    FPNANodesArr		: array of PVirtualNode;

    OrgNamesArr     : array of string;
    OrgAddressesArr : array of string;
    OrgPhonesArr    : array of string;

    FPArchNodeData	: PVTResourceData;
    FPNANodeData		: PVTResourceData;

    FPForm          : TFPAllocForm;

    sFormat					:	TFormatSettings;
    FundVSAsset			: boolean;
    CurStrGridRow		: integer;
	  sIniSection			: string;
   	FixedTimeFilter : boolean;
   	ArbTimeFilter 	: boolean;
    POisRO					: boolean;
    POCanBeEdited 	: boolean;

    ShowSubmittedPOsOnly	: boolean;          // if true than ONLY submitted POs are shown
    ShowRejectedPOsOnly		: boolean;
    ShowApprovedPOsOnly		: boolean;
    ShowPaidPOsOnly				: boolean;
    ShowAllPOs						: boolean;

    FmtList	: TStringList;

 	  QFormatString	: TFormatSettings;
    ErrorTreeLoading  : boolean;
    // NOW variables
    NOWOrgHasNoParent : boolean;
    NOWPArentOrgID    : integer;
    NOWOrgHasNoTemplate : boolean;
    NOWTmpltOrgID     : integer;
    NextStepPressed   : boolean;
    PrevStepPressed   : boolean;

    LPF : TLoadingProgressForm;

    m_bInitComleted : boolean;

    procedure UserFormShow(Sender: TObject);
    procedure NewFP(Sender: TObject);
    procedure RenewNavBar(var Msg: TMessage); message UM_CLEARNAVBAR;
    procedure OnPopupMenuNeeded(var Msg: TMessage); message UM_POPUPMENUNEEDED;
    procedure OnStrGridPopupNeeded(var Msg: TMessage); message UM_STRGRIDPOPUPNEEDED;
    procedure OnDebCredPopupNeeded(var Msg: TMessage); message UM_DEBCREDPOPUPNEEDED;
    procedure OnPersPopupNeeded(var Msg: TMessage); message UM_PERS_POPUPNEEDED;
    procedure OnPOsPopupNeeded(var Msg: TMessage); message UM_POSPOPUPNEEDED;
    procedure OnFLPopupNeeded(var Msg: TMessage); message UM_FLPOPUPNEEDED;

    procedure OnFPWasApproved(var Msg: TMessage); message UM_FPWASAPPROVED;
    procedure OnFPApprovedExt(var Msg: TMessage); message UM_FPAPPROVEDEXT;
    procedure OnCFilerApplied(var Msg: TMessage); message UM_CFILTER_APPLIED;
		procedure CheckFiltersForRow(ARow, AFltRow : integer);

  	function 	GetAssetNameByLink(ANode: PVirtualNode; ALink: string): string;
    procedure ShowFP(Sender: TObject);
    procedure PullMainTreeData;
		procedure CompEntList(VTree : TBaseVirtualTree; NodeToStart : PVirtualNode; Source : string; Level : integer; Branch:integer);
    procedure SetSubtreeALinkValue(ANode: PVirtualNode; AString : string);
    function 	FundOrAssetIsEmpty(ALink : string) : boolean;
    procedure ShowSearchFooter;

    // Excel stuff - to be reworked?
    //procedure ExportToExcel;
	  // procedure ExportStrGridToExcel(AEA	: TExcelApplication); // to work out an alternative solution to export ot to Excel files
    // Excel stuff

    procedure SetFilerToolbarObjectsEnabled;
    procedure SetFilerToolbarVisible;
    function	GetFixedTimeInterval : string;
    procedure SearchFwdBtnPressed(Sender: TObject);
    procedure SearchBkwdBtnPressed(Sender: TObject);
    procedure CollapseExpandNode(ANode : PVirtualNode; ANodeData : PVTResourceData);
    procedure SaveNodeState(ANode : PVirtualNode);
		function  GetPONode(ANode : PVirtualNode; APID : integer) : PVirtualNode; // search OrgNode with APID id
		function  GetOPrivs(ANode : PVirtualNode) : string; // get privs for the proper org based on the node
    procedure SetUpToolBar;
    function  MakeEnabled(ANodesArr : array of PVirtualNode; APriv : string) : boolean;
    function  RealOrgsNumber(ANodesArr : array of PVirtualNode) : integer;
    function  GetSingleOrgNumAndPrefix(ANodesArr : array of PVirtualNode; var APref : string; var AiPref : integer) : integer;

    procedure OnAppActivate(Sender: TObject);
    procedure OnAppDeactivate(Sender: TObject);
    procedure OnFPAllocFormClosed(var Msg: TMessage); message UM_FP_ALLOCFORMCLOSED;
    procedure OnFundTransferred(var Msg: TMessage); message UM_FUNDTRANSFERRED;
    procedure OnReconnectNeeded(var Msg: TMessage); message UM_RECONNECTNEEDED;
    procedure ShowHideArchedFunds;
    procedure PullarchivedFunds;
    procedure RemoveArchivedFromTree;
    procedure OnArcFundToBeAdded(var Msg: TMessage); message UM_ARCHFUNDTOBEADDED;
    procedure OnBkgUpdateFinished(var Msg: TMessage); message UM_BKGUPDATEFINISHED;
{$IFDEF TLOG}
    procedure OnLogPullFinished(var Msg: TMessage); message UM_LOGPULLFINISHED;
//    procedure LogPullTimerTimer(Sender: TObject);
  	procedure InitLogPull;
{$ENDIF}
    function GetGridColName(ACol, ARow : integer) : string;
    procedure SortRows(ACol : integer; AAsc : boolean; AGroup: string; AType : integer);
		function CmpCells(ARow1, ARow2, ACol, AType : integer; AAsc : boolean) : boolean;
    function GetFilterState(AGroup : string; ACol : integer) : string;

	public
    { Public declarations }
		CurOrgID	: integer;

    Connection  : TZConnection;
    UserID      : integer;
    procedure InitDB;
    procedure StopThreads;
{$IFDEF TLOG}
//    procedure OnLogPullFinished(var Msg: TMessage); message UM_LOGPULLFINISHED;
    procedure LogPullTimerTimer(Sender: TObject);
//  	procedure InitLogPull;
{$ENDIF}

  end;

implementation

{$R *.dfm}

uses
  AboutWindow,
  StrUtils,
  PwdChangeWindow,
  SqlTimSt,
  IncomeEnteringWindow,
  DebtorEditWindow,
  AssetTransferWindow,
  DebtingWindow,
  CreditingWindow,
  FundEditWindow,
  NewFPWindow,
  DisbWindow,
  POApproveWindow,
  BalanceEnterWindow,
  DebtClosingWindow,
	DebtListWindow,
	AssetVsFundsWindow,
	ZDbcIntfs,
  IncomeCorrectionWindow,
  DB,
  SyncObjs,							// for TEvent
  IncomeSourcesWindow,
	Chart,								// for GI stat only - to be removed
	Series,								// for GI stat only - to be removed
	FundvsPOsWindow,       // for FundvsPOsForm
	POsExportToExcelWindow, // for POsExportToExcelForm
  OrgDataWindow,
  PersonEditWindow,
	TeEngine//,							// for GI stat only - to be removed
;

procedure TMainFPForm.RTimerTimer(Sender: TObject);
begin
  CheckAndReconnect(FPConnection);
end;

procedure TMainFPForm.ShowHideArchedFunds;
begin
  if gHideArchedFunds then begin
	  PopUpShowHideArchedFunds.Caption := 'Показать архивные фонды';
    RemoveArchivedFromTree;
  end
  else begin
	  PopUpShowHideArchedFunds.Caption := 'Скрыть архивные фонды';
    // start thread to pull archived funds
    PullArchivedFunds;
  end;
end;

procedure TMainFPForm.PullarchivedFunds;
var
	Node			: PVirtualNode;
  NodeData  : PVTResourceData;
begin
	if not m_bInitComleted then exit;

  LoadArchCS.Enter;
  Node := MainTree.GetFirstSelected;
  if Node <> nil then begin
	  NodeData := MainTree.GetNodeData(Node);
		LoadArchFLink	:= NodeData.link;
    LoadArchPrefix := NodeData.prefix;
		LoadArchEvent.SetEvent;
  end;
  LoadArchCS.Leave;
end;

procedure TMainFPForm.RemoveArchivedFromTree;
var
	Node			: PVirtualNode;
  NodeData  : PVTResourceData;
	Node1			: PVirtualNode;
begin
	if not m_bInitComleted then exit;

  Node := MainTree.GetFirstSelected;
  if Node = nil then Exit;

	Node1 := MainTree.GetFirstChild(Node);
  NodeData := MainTree.GetNodeData(Node1);
  while (Node1 <> nil) and (NodeData.arched) do begin
   	MainTree.DeleteNode(Node1);
		Node1 := MainTree.GetFirstChild(Node);
	  NodeData := MainTree.GetNodeData(Node1);
  end;

  while Node1 <> nil do begin
  	Node := MainTree.GetNextSibling(Node1);
	  NodeData := MainTree.GetNodeData(Node);
		while (Node <> nil) and (NodeData.arched) do begin
	   	MainTree.DeleteNode(Node);
      Node 	 := MainTree.GetNextSibling(Node);
		  NodeData := MainTree.GetNodeData(Node);
    end;
    Node1 := Node;
  end;
end;

procedure TMainFPForm.OnBkgUpdateFinished(var Msg: TMessage);
begin
	UTimer.Enabled := true;
end;

procedure TMainFPForm.OnArcFundToBeAdded(var Msg: TMessage);
var
  pflink 			 : ^string;
	NewNode	 		 : PVirtualNode;
  NodeData  	 : PVTResourceData;
  NewNodeData  : PVTResourceData;
  ArchData		 : PVTResourceData;
  i 					 : integer;
begin

	pflink 	 := pointer(msg.WParam);
  ArchData := pointer(msg.LParam);

  if(pflink = nil) or (ArchData = nil) then exit;

  // choose correct fund branch
  for i := Low(FundNodesArr) to High(FundNodesArr) do begin
    if FundNodesArr[i] = nil then continue;

    NodeData := MainTree.GetNodeData(FundNodesArr[i]);
    if NodeData.link = pflink^ then begin
	  	NewNode := MainTree.AddChild(FundNodesArr[i]);
      NewNodeData := MainTree.GetNodeData(NewNode);
      NewNodeData.name 		:= ArchData.name;
      NewNodeData.link		:= ArchData.link;
      NewNodeData.descr		:= ArchData.descr;
      NewNodeData.sub	 		:= ArchData.sub;
      NewNodeData.balance := ArchData.balance;
      NewNodeData.page		:= ArchData.page;
      NewNodeData.branch	:= ArchData.branch;
      NewNodeData.alink		:= ArchData.alink;
      NewNodeData.fp1sum	:= 0;
      NewNodeData.prefix	:= NodeData.prefix;
      NewNodeData.ipref		:= NodeData.ipref;
      NewNodeData.arched	:= ArchData.arched;
		  MainTree.Sort(FundNodesArr[i], 1, VirtualTrees.TSortDirection.sdAscending);
      break;
    end;
  end; // for i: = Low(UTFundNodesArr) to ...
  dispose(pflink);
  dispose(ArchData);
end;

procedure TMainFPForm.OnReconnectNeeded(var Msg: TMessage);
var
  NoError : boolean;
begin
  NoError := true;
// reconnection
  if not Assigned(FPConnection) then begin
    FPConnection := TZConnection.Create(nil);

    FPConnection.HostName	:= GFPHost;
    FPConnection.User			:= GFPUser;
    FPConnection.Port			:= GFPPort;
    FPConnection.Password	:= GFPPwd;
    FPConnection.Database := GFPDb;
    FPConnection.Protocol	:= GFPProt;
    FPConnection.ClientCodepage := rsCharsetSetUp;


    SetUpEncryption(FPConnection);

    try
  	  FPConnection.Connect;
    except
  	  on e:Exception do begin
        FPConnection.Free;
        FPConnection := nil;
        NoError := false;
      end;
    end;
  end;

// reconnect if needed
  if Assigned(FPConnection) then begin
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('=== Reconnecting Main thread''s connection ... ===');
{$ENDIF}
    try
	    SetUpEncryption(FPConnection);
      FPConnection.Reconnect;
    except
  	  on e:Exception do begin
        NoError := false;
//        Exit;
      end;
    end;
  end;
// set up datasets
  if not Assigned(FPMainDataset) then begin
    FPMainDataset := TZQuery.Create(nil);
    FPMainDataset.Connection := FPConnection;
  end;
  if not Assigned(FPTmpDataset) then begin
    FPTmpDataset := TZQuery.Create(nil);
    FPTmpDataset.Connection := FPConnection;
  end;

  try
    FPMainDataset.SQL.Text := 'SET CHARSET cp1251';
    FPMainDataset.ExecSQL;

    FPMainDataset.SQL.Text := 'SET autocommit=1';
    FPMainDataset.ExecSQL;
  except
    on e:Exception do begin
      NoError := false;
    end;
  end;

end;

function  TMainFPForm.GetSingleOrgNumAndPrefix(ANodesArr : array of PVirtualNode; var APref : string; var AIPref : integer) : integer;
var
  i : integer;
  NodeData  : PVTResourceData;
begin
  for i := Low(ANodesArr) to High(ANodesArr) do begin
    if ANodesArr[i] <> nil then begin
      NodeData := MainTree.GetNodeData(ANodesArr[i]);
      APref    := NodeData.prefix;
      AIPref   := NodeData.ipref;
      break;
    end;
  end;
  Result := i;
end;

function  TMainFPForm.RealOrgsNumber(ANodesArr : array of PVirtualNode) : integer;
var
  i, j : integer;
begin
  j := 0;
  for i := Low(ANodesArr) to High(ANodesArr) do begin
    inc(j, integer(ANodesArr[i]<> nil));
  end;
  Result := j;
end;

procedure TMainFPForm.SetUpToolBar;
var
  TmpPref  : string;
  TmpiPref : integer;
begin

  IncomeInvoicingBtn.Visible      := MakeEnabled(RNodesArr, 'b') or MakeEnabled(RNodesArr, 'd');
  DebtingButton.Visible           := MakeEnabled(RNodesArr, 'b') or MakeEnabled(RNodesArr, 'w');
  DisbToolButton.Visible          := MakeEnabled(RNodesArr, 'b') or MakeEnabled(RNodesArr, 'f');
  CreditingButton.Visible         := MakeEnabled(RNodesArr, 'b') or MakeEnabled(RNodesArr, 'c');
  TransferToolButton.Visible      := MakeEnabled(RNodesArr, 'b') or MakeEnabled(RNodesArr, 'h');
  ToolButton6.Visible             := DebtingButton.Visible or CreditingButton.Visible;
  IncomeSourcesButton.Visible     := MakeEnabled(RNodesArr, 'b') or MakeEnabled(RNodesArr, 'y');
{$IFDEF ORGWIZ}
  NewOrgWizButton.Visible         := MakeEnabled(RNodesArr, 'b');
{$ENDIF}
  if (RealOrgsNumber(RNodesArr) = 1) and (GetOPrivs(RNodesArr[GetSingleOrgNumAndPrefix(RNodesArr, TmpPref, TmpiPref)]) = 'a') then begin
    MainTree.Width                  := 0;
    MainTree.Visible                := false;
    MainGroupSplitter.Visible       := false;
    CurValue                        := 7;
    CurPrefix := TmpPref;
    CurOInd		:= TmpiPref;
  end
  else begin
    MainTree.Width          := 300;
    Self.MainGroupSplitterMoved(nil);

  // Here goes the update thread!
{$IFNDEF DLLNOTHREADS}
  {$IFDEF THREADSDBGOUTPUT}
    OutputDebugString(PWideChar('---- Update thread Start'));
  {$ENDIF}

	  UpdateThread := TUpdateThread.Create(true);
	  UpdateThread.Priority			    := tpLower;
  	UpdateThread.FreeOnTerminate	:= true;

  	UpdateThread.UTAssetNodesArr	:= AssetNodesArr;
	  UpdateThread.UTBankNodesArr		:= BankNodesArr;
  	UpdateThread.UTFundNodesArr		:= FundNodesArr;
  	UpdateThread.UTOrgsNodesArr	  := RNodesArr;
	  UpdateThread.UTConnection   	:= FPConnection;
  	UpdateThread.UTMainTree	      := Self.MainTree;
	  UpdateThread.Resume;

{$ENDIF}
  end;
end;

function  TMainFPForm.MakeEnabled(ANodesArr : array of PVirtualNode; APriv : string) : boolean;
var
  i : integer;
  OD : PVTResourceData;
begin
  Result := false;
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OD := MainTree.GetNodeData(RNodesArr[i]);
      if Pos(APriv, OD.descr) > 0 then begin
        Result := true;
        break
      end
    end
  end;
end;

function TMainFPForm.GetPONode(ANode : PVirtualNode; APID : integer) : PVirtualNode; // for searching the org root node
var
	TN : PVirtualNode;
	RN : PVirtualNode;
  OD : PVTResourceData;
begin

	RN := nil;
  if APID = 0 then begin
    Result := nil;
    Exit;
  end;

	TN := MainTree.GetFirstChild(ANode);

	while TN <> nil do begin
  	OD := MainTree.GetNodeData(TN);
	  if (OD.index = APID) and (OD.page = 2) then begin
  		RN := TN;
    	Break;
    end
  	else if TN.ChildCount > 0 then begin
    	RN := GetPONode(TN, APID);
      if RN <> nil then begin
      	break
      end;
    end;
    TN := MainTree.GetNextSibling(TN);
  end; // while
  Result := RN;
end;

function TMainFPForm.GetOPrivs(ANode : PVirtualNode) : string; // get privs for the proper org based on the node
var
	SN : PVirtualNode;
	RN : PVirtualNode;
  OD : PVTResourceData;
  lprivs : string;
begin
  lprivs := '';
  SN := ANode;

  while (SN <> nil) and (not IsIt(RNodesArr, SN)) do begin
    SN := SN.Parent;
  end;

  if IsIt(RNodesArr, SN) then begin
  	OD := MainTree.GetNodeData(SN);
    lprivs := OD.descr;
  end;

  Result := lprivs;
end;

procedure TMainFPForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  {$IFNDEF PROJECTISDLL}
  Params.ExStyle  := Params.ExStyle or WS_Ex_AppWindow;
  Params.WndParent:= 0;
  {$ENDIF}
end;

procedure TMainFPForm.SaveNodeState(ANode : PVirtualNode);
var
	NodeData : PVTResourceData;
  Collapsed	: integer;
  SectionStr	: string;
begin
	if ANode = nil then
  	Exit;
  NodeData := MainTree.GetNodeData(ANode);
	Collapsed := integer(not (vsExpanded in ANode.States));
	SectionStr := IntToStr(NodeData.branch) + ',' + IntToStr(NodeData.page) + ',' + IntToStr(NodeData.sub);
	WriteIntParam(SectionStr, 'Collapsed', Collapsed);
end;

procedure TMainFPForm.CollapseExpandNode(ANode : PVirtualNode; ANodeData : PVTResourceData);
var
	SectionStr : string;
  Collapsed	 : boolean;
begin
	SectionStr := IntToStr(ANodeData.branch) + ',' + IntToStr(ANodeData.page) + ',' + IntToStr(ANodeData.sub);
  Collapsed	 := bool(ReadIntParam(SectionStr, 'Collapsed', 0));
  if Collapsed then
  	ANode.States := ANode.States - [vsExpanded]
  else
  	ANode.States := ANode.States + [vsExpanded];
end;

procedure TMainFPForm.SearchFwdBtnPressed(Sender: TObject);
var
  i : integer;
  j : integer;
  found : boolean;
begin
  //
  i := StrGrid.Row + 1;
  found := false;
  while (i < StrGrid.RowCount) and (not found) do begin
    for j := 1 to StrGrid.ColCount - 1 do begin
      if (Pos(StrGrid.SearchPanel.EditControl.Text, StrGrid.Cells[j, i]) > 0) or
          (Pos(StrGrid.SearchPanel.EditControl.Text, ReplaceStr(StrGrid.Cells[j, i], ThSep, '')) > 0) then begin
        Found := true;
        break;
      end;
    end;
    if not Found then
      Inc(i);
  end;
  if i < StrGrid.RowCount then
    StrGrid.Row := i;
end;

procedure TMainFPForm.SearchBkwdBtnPressed(Sender: TObject);
var
  i : integer;
  j : integer;
  found : boolean;
begin
  //
  i := StrGrid.Row - 1;
  found := false;
  while (i > 0) and (not found) do begin
    for j := 1 to StrGrid.ColCount - 1 do begin
      if (Pos(StrGrid.SearchPanel.EditControl.Text, StrGrid.Cells[j, i]) > 0) or
          (Pos(StrGrid.SearchPanel.EditControl.Text, ReplaceStr(StrGrid.Cells[j, i], ThSep, '')) > 0) then begin
        Found := true;
        break;
      end;
    end;
    if not Found then
      Dec(i);
  end;
  if i > 0 then
    StrGrid.Row := i;
end;

function TMainFPForm.GetFixedTimeInterval : string;
begin
  Result := '';
  case PeriodCombo.ItemIndex of
  	0 : Result := '7 DAY';
  	1 : Result := '1 MONTH';
  	2 : Result := '3 MONTH';
  	3 : Result := '6 MONTH';
  	4 : Result := '1 YEAR';
  end;
end;

procedure TMainFPForm.SetFilerToolbarVisible;
begin
	SubmittedPOToolBtn.Visible	:= CurValue = 7;
  RejectedPOToolBtn.Visible		:= CurValue = 7;
  ApprovedPOToolBtn.Visible		:= CurValue = 7;
  PaidPOToolBtn.Visible				:= CurValue = 7;
  TimeFilterToolBar.Visible 	:= (CurValue in [7, 9]) and (UpperCase(CurTable) <> UpperCase('BANK'));
end;

procedure TMainFPForm.SetFilerToolbarObjectsEnabled;
begin
  PeriodCombo.Enabled 							:= TimeFilterToolButton.Down;
  FilterDateStartEdit.Enabled				:= TimeFilterToolButton.Down;
  FilterDateEndEdit.Enabled					:= TimeFilterToolButton.Down;
  FilterOutByFixedPeriodBtn.Enabled := TimeFilterToolButton.Down;
  FilterOutByArbPeriodBtn.Enabled 	:= TimeFilterToolButton.Down;
	FixedTimeFilter 									:= false;
	ArbTimeFilter 										:= false;
end;

procedure TMainFPForm.ShowSearchFooter;
begin
//	StrGrid.SearchFooter.Visible := not StrGrid.SearchFooter.Visible;
 	StrGrid.SearchFooter.AutoSearch 					:= false;
  StrGrid.SearchPanel.MatchCase.Visible			:= false;
  StrGrid.SearchPanel.HiliteButton.Visible	:= false;
	StrGrid.SearchFooter.Visible 							:= true;
  StrGrid.SearchPanel.EditControl.Width			:= 300;
  StrGrid.SearchPanel.EditControl.Left			:= 2;
  StrGrid.SearchPanel.ForwardButton.Left		:=
  	StrGrid.SearchPanel.EditControl.Left + StrGrid.SearchPanel.EditControl.Width + 2;
  StrGrid.SearchPanel.ForwardButton.Width		:= 120;
  StrGrid.SearchPanel.BackwardButton.Left 	:=
  	StrGrid.SearchPanel.ForwardButton.Left + StrGrid.SearchPanel.ForwardButton.Width + 2;
  StrGrid.SearchPanel.BackwardButton.Width 	:= 120;
  StrGrid.SearchPanel.ForwardButton.OnClick := SearchFwdBtnPressed;
  StrGrid.SearchPanel.BackwardButton.OnClick  := SearchBkwdBtnPressed;
end;

procedure TMainFPForm.ExportToExcelButtonClick(Sender: TObject);
var
  POEF: TPOsExportToExcelForm;
  i : integer;
  j            : integer;
  CurOrgId     : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;

begin
// to delete
end;

procedure TMainFPForm.AboutButtonClick(Sender: TObject);
var
  AboutBox : TAboutBox;
begin
  AboutBox := TAboutBox.Create(nil);
  AboutBox.ShowModal;
  AboutBox.Free;
end;

procedure TMainFPForm.AllPOPopUpClick(Sender: TObject);
begin
	ShowAllPOs						:= true;
	ShowSubmittedPOsOnly	:= false;
	ShowRejectedPOsOnly 	:= false;
	ShowApprovedPOsOnly 	:= false;
	ShowPaidPOsOnly 			:= false;
	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowAllPOs', 			ShowAllPOs);
  	IniFile.WriteBool(POIniSection, 'ShowSubmittedPOsOnly', ShowSubmittedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowRejectedPOsOnly', ShowRejectedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowApprovedPOsOnly', ShowApprovedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowPaidPOsOnly', ShowPaidPOsOnly);
		IniFile.UpdateFile;
  end;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default := false;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked := true;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);

end;

procedure TMainFPForm.ApprovedPOPopUpClick(Sender: TObject);
begin
	ShowAllPOs := false;
	ShowSubmittedPOsOnly 	:= false;
	ShowRejectedPOsOnly 	:= false;
	ShowApprovedPOsOnly 	:= true;
	ShowPaidPOsOnly 			:= false;
	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowApprovedPOsOnly', ShowApprovedPOsOnly);
    IniFile.UpdateFile;
  end;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default	:= true;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default	:= false;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked := false;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.ApprovedPOPopUpSHClick(Sender: TObject);
begin
	if ShowAllPOs and (not ShowApprovedPOsOnly) then begin // Submitted POS are still show even if ShowSubmittedPOsOnly is false
		ShowApprovedPOsOnly := true;
		ShowAllPOs := false;
  end;

  ShowApprovedPOsOnly := not ShowApprovedPOsOnly;

	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowApprovedPOsOnly', ShowApprovedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowAllPOs', 				 ShowAllPOs);
    IniFile.UpdateFile;
  end;

  if not ShowApprovedPOsOnly then begin
	  ShowSubmittedPOsOnly := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked;
  	ShowRejectedPOsOnly	 := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked;
	  ShowPaidPOsOnly			 := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked;
  end;

  ShowAllPOs := ShowSubmittedPOsOnly and ShowRejectedPOsOnly and ShowApprovedPOsOnly and ShowPaidPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked := ShowAllPOs or ShowApprovedPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default	:= false;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.ApprovedPOToolBtnClick(Sender: TObject);
var
	i : integer;
begin
	i := 2;
	while i < StrGrid.RowCount - 1 do begin
  	if StrGrid.Cells[0, i] = rsAppdPOHeaderRow then begin
    	LockWindowUpdate(StrGrid.Handle);
    	StrGrid.Row := i;
    	LockWindowUpdate(0);
      break;
    end;
    inc(i);
  end;
  StrGrid.SetFocus;
end;

procedure TMainFPForm.ArchUnarchFundClick(Sender: TObject);
var
	Node 			: PVirtualNode;
	NodeData  : PVTResourceData;
	NodeF 	 	: PVirtualNode;
	NodeDataF : PVTResourceData;
  T_Dataset : TZQuery;
  NoError   : boolean;
begin
  Node  := MainTree.GetFirstSelected;
  if Node = nil then Exit;
  NodeF := Node.Parent;
  if NodeF = nil then Exit;

  NodeData  := MainTree.GetNodeData(Node);
  NodeDataF := MainTree.GetNodeData(NodeF);

  if (NodeData.link = '') or (NodeDataF.link = '') then Exit;

  NoError   := true;
  T_Dataset 						:= TZQuery.Create(nil);
  T_Dataset.Connection  := FPConnection;
  T_Dataset.SQL.Text 		:= 'UPDATE ' + NodeDataF.link + ' SET arched=:farched WHERE link=:flink';
  T_Dataset.ParamByName('flink').AsString 	 := NodeData.link;
  T_Dataset.ParamByName('farched').AsInteger := integer(not NodeData.arched);

  try
	  T_Dataset.ExecSQL;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, 'Ошибка обновления базы данных.', e.ErrorCode, e.StatusCode, e.Message);
      NoError := false;
    end;
  end;

  T_Dataset.Free;

  if NoError then
	  NodeData.arched := not NodeData.arched
  else
	  Exit;

	// affect the appearance of the node
  if NodeData.arched and gHideArchedFunds then begin // in this case we have to remove this node from the main tree
  	MainTree.DeleteNode(Node);
  end
  else begin
		MainTree.RepaintNode(Node);
  end
end;

function TMainFPForm.FundOrAssetIsEmpty(ALink : string) : boolean;
var
  T_Dataset : TZQuery;
  Sub       : integer;
begin
  T_Dataset 						:= TZQuery.Create(nil);
  T_Dataset.Connection  := FPConnection;
  T_Dataset.SQL.Text 		:= 'SELECT`link`FROM ' + ALink + ' WHERE(`in`IS NOT NULL OR`out`IS NOT NULL)OR(`page`>8)';
  T_Dataset.Open;
  Result := T_Dataset.RecordCount = 0;
  T_Dataset.Free;
end;

procedure TMainFPForm.SearchToolButtonClick(Sender: TObject);
var
	TmpStr 	: string;
  i				: integer;
  S1, s2	: extended;
begin
	i := SearchSourceCombo.ItemIndex;
  if i > AssetList.Count then
		TmpStr := GetLinkOfFondByName(FondList, SearchSourceCombo.Items[i])
  else
		TmpStr := GetLinkOfFondByName(AssetList, SearchSourceCombo.Items[i]);

	if (TmpStr = '0') or (TmpStr = '')  then begin
	  Application.MessageBox('Выберите актив или фонд', 'Неправильно задана область поиска', MB_ICONINFORMATION or MB_OK);
    Exit;
  end;

  S1 := 0;
  S2 := 0;

	FPMainDataset.SQL.Text		:= 'SELECT`index`,`lastdate`,`data`,';
  if SearchTypeCombo.ItemIndex = SEARCH_ALL then
  	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '`in`,`out`,'
  else if SearchTypeCombo.ItemIndex = SEARCH_INC then
  	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '`in` AS mtr,'
  else
  	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '`out` as mtr,';

	FPMainDataset.SQL.Text		:= FPMainDataset.SQL.Text + '`balance` from ' + TmpStr + ' WHERE`data`LIKE :fSearchString';
  if SearchTypeCombo.ItemIndex = SEARCH_ALL then
  	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + ' AND(`in`>0 OR`out`>0)'
  else if SearchTypeCombo.ItemIndex = SEARCH_INC then
  	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + ' AND`in`>0'
  else
  	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + ' AND`out`>0';


  if StartDateEdit.Date > 0 then begin
	 	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + ' AND`lastdate`>=:fStartDate';
  	FPMainDataset.ParamByName('fStartDate').AsDateTime := StartDateEdit.Date;
  end;
  if EndDateEdit.Date > 0 then begin
	 	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + ' AND `lastdate`<=:fEndDate';
    FPMainDataset.ParamByName('fEndDate').AsDateTime := Trunc(EndDateEdit.Date) + 1;
  end;

  FPMainDataset.ParamByName('fSearchString').AsString := '%'+ StringEdit.Text + '%'; //StringEdit.Text;
  FPMainDataset.Open;
	if FPMainDataset.RecordCount = 0 then begin
	  Application.MessageBox('Поиск ничего не дал. Проверьте правильность данных', 'Результат поиска', MB_ICONINFORMATION or MB_OK);
    Exit;
  end;

  StrGrid.Visible := true;
  Strgrid.SplitRowCells(0);
  StrGrid.RowCount := 2;
  StrGrid.FixedRows := 1;

  StrGrid.ColumnHeaders.Clear;
  StrGrid.ColumnHeaders.Add('');
  StrGrid.ColumnHeaders.Add('№');
  StrGrid.ColumnHeaders.Add('Дата');
  StrGrid.ColumnHeaders.Add('Описание');
  if SearchTypeCombo.ItemIndex = SEARCH_ALL then begin
  	StrGrid.ColCount := 7;
    StrGrid.ColWidths[0]  := 0;
    StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 20); //20;
    StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 125); //125;
    StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 100); //100;
    StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 100); //100;
    StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 100); //100;
    StrGrid.ColWidths[6]  := ReadColWidth(sIniSection, 6, 100); //100;
	  StrGrid.ColumnHeaders.Add('Приход');
  	StrGrid.ColumnHeaders.Add('Расход');
  end
  else begin
  	StrGrid.ColCount := 6;
    StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 20); //20;
    StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 125); //125;
    StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 100); //100;
    StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 100); //100;
    StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 100); //100;
    if SearchTypeCombo.ItemIndex = SEARCH_INC then
		  StrGrid.ColumnHeaders.Add('Приход')
    else
	  	StrGrid.ColumnHeaders.Add('Расход');
  end;
  StrGrid.ColumnHeaders.Add('Баланс');

  i := 1;
  while not FPMainDataset.Eof do begin
	  Strgrid.SplitRowCells(i);
    StrGrid.Cells[0, i] := '';
    StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
    StrGrid.Cells[2, i] := FPMainDataset.FieldByName('lastdate').AsString;
    StrGrid.Cells[3, i] := Trim(FPMainDataset.FieldByName('data').AsAnsiString);
	  if SearchTypeCombo.ItemIndex = SEARCH_ALL then begin
      if FPMainDataset.FieldByName('in').AsFloat > 0 then begin
		    StrGrid.Cells[4, i] := MyFloatToStr(FPMainDataset.FieldByName('in').AsFloat);
		    StrGrid.Cells[5, i] := '';
        S1 := S1 + FPMainDataset.FieldByName('in').AsFloat;
      end
      else begin
		    StrGrid.Cells[4, i] := '';
		    StrGrid.Cells[5, i] := MyFloatToStr(FPMainDataset.FieldByName('out').AsFloat);;
        S2 := S2 + FPMainDataset.FieldByName('out').AsFloat;
      end;
      StrGrid.Cells[6, i] := MyFloatToStr(FPMainDataset.FieldByName('balance').AsFloat);
    end
    else begin
	    StrGrid.Cells[4, i] := MyFloatToStr(FPMainDataset.FieldByName('mtr').AsFloat);;
      StrGrid.Cells[5, i] := MyFloatToStr(FPMainDataset.FieldByName('balance').AsFloat);
      S1 := S1 + FPMainDataset.FieldByName('mtr').AsFloat;
    end;

    FPMainDataset.Next;
    Inc(i);
  end;
	Strgrid.SplitRowCells(i);
  StrGrid.Cells[0, i] := 't__';
  StrGrid.MergeCells(1, i, 3, 1);
  StrGrid.Cells[1, i] := 'Итого';
  StrGrid.Cells[4, i] := MyFloatToStr(S1);

  if SearchTypeCombo.ItemIndex = SEARCH_ALL then begin
	  StrGrid.Cells[5, i] := MyFloatToStr(S2);
	  StrGrid.Cells[6, i] := '';
  end
  else
	  StrGrid.Cells[5, i] := '';
  Inc(i);
  StrGrid.RowCount := i;
  StrGrid.SetFocus;
  StrGrid.Invalidate;
end;

procedure TMainFPForm.SetSubtreeALinkValue(ANode: PVirtualNode; AString : string);
var
  T_Dataset   : TZQuery;
  Node 		    : PVirtualNode;
  NodeData 		: PVTResourceData;
begin
  T_Dataset := TZQuery.Create(nil);
  T_Dataset.Connection := FPConnection;
  Node := MainTree.GetFirstChild(ANode);
  while Node <> nil do begin
  	NodeData := MainTree.GetNodeData(Node);
  	T_Dataset.SQL.Text := 'INSERT INTO ' + CurPrefix + 'fundsvsassets(`fundlink`,`assetlink`)VALUES(:fFundLink,:fAssetLink)ON DUPLICATE KEY UPDATE assetlink=:fAssetLink';
	  T_Dataset.ParamByName('fFundLink').AsString 	:= NodeData.link;
  	T_Dataset.ParamByName('fAssetLink').AsString 	:= AString;
    NodeData.alink																:= AString;
    MainTree.RepaintNode(Node);
    if Node.ChildCount > 0 then begin
      SetSubtreeALinkValue(MainTree.GetFirstChild(Node), AString);
    end;
    Node := MainTree.GetNextSibling(Node);
  end;
  T_Dataset.Close;
  T_Dataset.Free;
end;

procedure TMainFPForm.SGPopUpCloseClick(Sender: TObject);
var
	StrInd	: integer;
	nRow		: integer;
  i				: integer;
  TmpData : string;
  TmpSum  : extended;
  NoError : boolean;
begin
//
  nRow := StrGrid.Row;
	if (not TryStrToInt(StrGrid.Cells[1, nRow], StrInd)) and (not ((CurValue = BRANCH_DEBITORS) or (CurValue = BRANCH_CREDITORS))) then
	  Exit;
  i := Pos(Chr(13), StrGrid.Cells[4, nRow]);
  if i <= 0 then
    i := Length(StrGrid.Cells[4, nRow]);

  DebtClosingForm := TDebtClosingForm.Create(Self);
  if CurValue = BRANCH_DEBITORS then
	  DebtClosingForm.DebtorLabel.Caption := 'Дебитор'
  else
	  DebtClosingForm.DebtorLabel.Caption := 'Кредитор';

  DebtClosingForm.DescrEdit.Text				:= Trim(LeftStr(StrGrid.Cells[4, nRow], i));
  DebtClosingForm.AmountEdit.Value			:= StrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[5, nRow], '.',','),ThSep,''));
  DebtClosingForm.ShipDTEdit.Date				:= StrToDate(StrGrid.Cells[3, nRow]);
  DebtClosingForm.DTEdit.Date						:= StrToDate(StrGrid.Cells[6, nRow]);
  DebtClosingForm.TitleEdit.Text 				:= StrGrid.Cells[7, nRow];
	if DebtClosingForm.ShowModal <> mrOk then
    Exit;

  NoError := true;
  FPMainDataset.SQL.Text := 'SELECT`data`,`summ`,`closed`FROM ';
  if CurValue = BRANCH_DEBITORS then begin
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'tocollect '
  end
  else begin
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'topay ';
  end;

  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' WHERE `index`=' + IntToStr(StrInd);

  try
    FPMainDataset.Open;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, 'Невозможно получить данные о задолженности.', e.ErrorCode, e.StatusCode, e.Message);
      NoError := false;
    end;
  end;

  if (FPMainDataset.RecordCount = 0) or (not NoError) then
    Exit;

  TmpData  := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
  TmpSum   := FPMainDataset.FieldByName('summ').AsExtended;

  TmpData := TmpData + Chr(13) + DateTimeToStr(now) + ': Задолженность аннулирована. Основание: ' +
             DebtClosingForm.ReasonMemo.Text + Chr(13) + '<b>Обязательство закрыто</b>';
  FPMainDataset.SQL.Text := 'UPDATE ';
  if CurValue = BRANCH_DEBITORS then begin
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'tocollect '
  end
  else begin
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'topay ';
  end;
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'SET`data`=:fDebtData,`closed`=-1,`status`="2"WHERE`index`=' + IntToStr(StrInd);
	FPMainDataset.ParamByName('fDebtData').AsString := ReplaceStr((TmpData), Chr(13), '<br>');

  FPTmpDataset.SQL.Text := 'BEGIN';
  try
    FPTmpDataset.ExecSQL;
  except
    on E: EZSQLException do begin
      ShowError(Self, 'Сбой в начале обработки запроса.', e.ErrorCode, e.StatusCode, e.Message);
      NoError := false;
    end;
  end;

  if NoError then begin
    try
	    FPMainDataset.ExecSQL;
    except
      on E: EZSQLException do begin
        ShowError(Self, 'Ошибка при закрытии задолженности.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;
  end;

  if NoError then begin
    FPMainDataset.SQL.Text := 'COMMIT';
  	try
 	    FPMainDataset.ExecSQL;
    except
 		  on e: EZSQLException do begin
	  	  ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;
  end // if NoError
  else begin
    FPMainDataset.SQL.Text := 'ROLLBACK';
  	try
 	    FPMainDataset.ExecSQL;
    except
 		  on e: EZSQLException do begin
	  	  ShowError(Self, 'Невозможно откатить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;
  end; // else for if NoError

  if not NoError then begin
    Application.MessageBox('Во время аннулирования задолженности произошёл сбой. Задолженность не аннулирована.', 'Аннулирование задолженности', MB_ICONERROR or MB_OK);
    Exit;
  end;

  PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.SGPopUpDeleteClick(Sender: TObject);
Var
	StrInd	: integer;
  nRow		: integer;
  i				: integer;
  NoError : boolean;
begin
  nRow := StrGrid.Row;
	if (not TryStrToInt(StrGrid.Cells[1, nRow], StrInd)) and (not ((CurValue = BRANCH_DEBITORS) or (CurValue = BRANCH_CREDITORS))) then
	  Exit;

  NoError := true;

  i := Pos(Chr(13), StrGrid.Cells[4, nRow]);
  if i <= 0 then
    i := Length(StrGrid.Cells[4, nRow]);

  if mrYes = Application.MessageBox(PWideChar('Вы действительно хотите удалить задолженность "' +
      					Trim(LeftStr(StrGrid.Cells[4, nRow], i)) + '" от ' + StrGrid.Cells[2, nRow] + '?' + CRLF +
  							'Остаток по задолженности: ' + StrGrid.Cells[5, nRow]),
								'Подтвердите удаление', MB_YESNO or MB_ICONINFORMATION) then begin
	  FPMainDataset.SQL.Text := 'DELETE FROM';
  	if CurValue = BRANCH_DEBITORS then begin
			FPMainDataset.SQL.Text :=  FPMainDataset.SQL.Text + '`' + CurPrefix + 'tocollect`'
    end
	  else begin
			FPMainDataset.SQL.Text :=  FPMainDataset.SQL.Text + '`' + CurPrefix + 'topay`';
    end;
		FPMainDataset.SQL.Text :=  FPMainDataset.SQL.Text + 'WHERE`index`=:fInd';
  	FPMainDataset.ParamByName('fInd').AsInteger := StrInd;

    FPTmpDataset.SQL.Text := 'BEGIN';
    try
      FPTmpDataset.ExecSQL;
    except
      on E: EZSQLException do begin
        ShowError(Self, 'Сбой в начале обработки запроса.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;

    if NoError then begin // the deletion itself
      try
  	    FPMainDataset.ExecSQL;
      except
        on E: EZSQLException do begin
          ShowError(Self, 'Ошибка при удалении задолженности.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
    end;

    if NoError then begin
      FPMainDataset.SQL.Text := 'COMMIT';
  	  try
   	    FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
	  	    ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
    end // if NoError
    else begin
      FPMainDataset.SQL.Text := 'ROLLBACK';
    	try
 	      FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
	  	    ShowError(Self, 'Невозможно откатить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
    end; // else for if NoError

    if not NoError then begin
      Application.MessageBox('При удалении задолженности произошёл сбой. Задолженность не удалена.', 'Удаление задолженности', MB_ICONERROR or MB_OK);
      Exit;
    end;
    PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
  end;
end;

procedure TMainFPForm.SGPopUpEditClick(Sender: TObject);
var
  DF  : TDebtingForm;
  CF  : TCreditingForm;
  TDT : TDateTime;
  TFLT  : extended;
  CurID : integer;
  i            : integer;
  j            : integer;
  CurOrgId     : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;
begin
  if CurValue = BRANCH_DEBITORS then begin
    TryStrToInt(StrGrid.Cells[1, StrGrid.Row], CurID);
    if CurID = 0 then
      Exit;
    DF := TDebtingForm.Create(nil);
    TryStrToDate(StrGrid.Cells[3, StrGrid.Row], TDT);
    DF.ShipDt.Date := TDT;
    TryStrToDate(StrGrid.Cells[6, StrGrid.Row], TDT);
    DF.Dt.Date     := TDT;
    TryStrToFloat(MyCleanStr(StrGrid.Cells[5, StrGrid.Row]), TFLT);
    DF.AmountEdit.Value := TFLT;
    DF.DescrMemo.Text := StrGrid.Cells[4, StrGrid.Row];
    DF.DefOrg := StrGrid.Cells[7, StrGrid.Row];

	  j            := 0;
  	CurOrgId     := 0;
	  // populating Orgs Combo
  	DF.CurOrgPrefix := CurPrefix;
	  for i := Low(RNodesArr) to High(RNodesArr) do begin
  	  if RNodesArr[i] <> nil then begin
    	  OrgData := MainTree.GetNodeData(RNodesArr[i]);
      	if PrivPresentMO(OrgData.descr, 'bw') and (not PrivPresentMO(OrgData.descr, 'a')) then begin
	        New(ResData);
  	      ResData.name    := OrgData.name;
    	    ResData.prefix  := OrgData.prefix;
      	  ResData.index   := ORgData.index;
	        DF.OrgsList.Add(ResData);
  	      DF.OrgCombo.Items.Add(ResData.name);
    	    if CurPrefix = ResData.prefix then
      	    CurOrgId := j;
        	Inc(j);
	      end
  	  end;
	  end;

  	if DF.OrgCombo.Items.Count < 1 then begin
	  	Application.MessageBox('Произошла ошибка при построении списка организаций', 'Дебетование', MB_ICONINFORMATION or MB_OK);
	    DF.Free;
  	  Exit;
	  end
  	else begin
    	DF.OrgCombo.ItemIndex := CurOrgId;
	    DF.FixOrgCombo  := true;
  	end;

    if DF.ShowModal = mrOK then begin
      FPMainDataset.SQL.Text := 'UPDATE`'+ CurPrefix + 'tocollect`SET`debtor`=:fDID,`shipdate`=:fSD,`paydate`=:fPD,`summ`=:fSum,`data`=:fDescr';
{$IFDEF USERID}
			FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`=:fUserID';
{$ENDIF}
  	  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' WHERE`index`=:fID';
      FPMainDataset.ParamByName('fDID').AsInteger := PContrData(DF.DebCredCombo.Items.Objects[DF.DebCredCombo.ItemIndex]).index;
      FPMainDataset.ParamByName('fSD').AsDate     := DF.ShipDt.Date;
      FPMainDataset.ParamByName('fPD').AsDate     := DF.Dt.Date;
      FPMainDataset.ParamByName('fSum').AsFloat   := DF.AmountEdit.Value;
      FPMainDataset.ParamByName('fDescr').AsString:= DF.DescrMemo.Text;
      FPMainDataset.ParamByName('fID').AsInteger := CurID;
{$IFDEF USERID}
		FPMainDataset.ParamByName('fUserID').AsInteger := FPUserID;
{$ENDIF}
      try
        FPMainDataset.ExecSQL;
      except
		    on e: EZSQLException do begin
  	  	  ShowError(Self, 'Во время обновления данных произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
	  	    ModalResult := mrCancel;
      		Exit;
        end;
      end;
      // and renew main grid
    	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
    end;
    DF.Free
  end
  else if CurValue = BRANCH_CREDITORS then begin
//    ShowMessage('Not implemented yet.');
    TryStrToInt(StrGrid.Cells[1, StrGrid.Row], CurID);
    if CurID = 0 then
      Exit;

	  CF := TCreditingForm.Create(nil);
    TryStrToDate(StrGrid.Cells[3, StrGrid.Row], TDT);
    CF.RecDTEdit.Date := TDT;
    TryStrToDate(StrGrid.Cells[6, StrGrid.Row], TDT);
    CF.Dt.Date     := TDT;
    TryStrToFloat(MyCleanStr(StrGrid.Cells[5, StrGrid.Row]), TFLT);
    CF.AmountEdit.Value := TFLT;
    CF.DescrMemo.Text := StrGrid.Cells[4, StrGrid.Row];
    CF.DefCred := StrGrid.Cells[7, StrGrid.Row];

	  j            := 0;
  	CurOrgId     := 0;
	  // populating Orgs Combo
  	CF.CurOCPrefix := CurPrefix;
	  for i := Low(RNodesArr) to High(RNodesArr) do begin
  	  if RNodesArr[i] <> nil then begin
    	  OrgData := MainTree.GetNodeData(RNodesArr[i]);
      	if PrivPresentMO(OrgData.descr, 'bc') and (not PrivPresentMO(OrgData.descr, 'a')) then begin
	        New(ResData);
  	      ResData.name    := OrgData.name;
    	    ResData.prefix  := OrgData.prefix;
      	  ResData.index   := ORgData.index;
	        CF.OrgsList.Add(ResData);
  	      CF.OrgCombo.Items.Add(ResData.name);
    	    if CurPrefix = ResData.prefix then
      	    CurOrgId := j;
        	Inc(j);
	      end
  	  end;
	  end;

  	if CF.OrgCombo.Items.Count < 1 then begin
	  	Application.MessageBox('Произошла ошибка при построении списка организаций', 'Кредитование', MB_ICONINFORMATION or MB_OK);
	    CF.Free;
  	  Exit;
	  end
  	else begin
    	CF.OrgCombo.ItemIndex := CurOrgId;
	    CF.FixOrgCombo  := true;
      Cf.TypeCreditGroup.Visible := false;
  	end;

    if CF.ShowModal = mrOK then begin

      FPMainDataset.SQL.Text := 'UPDATE`'+ CurPrefix + 'topay`SET`creditor`=:fDID,`shipdate`=:fSD,`paydate`=:fPD,`summ`=:fSum,`data`=:fDescr';
{$IFDEF USERID}
			FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`=:fUserID';
{$ENDIF}
  	  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' WHERE`index`=:fID';
      FPMainDataset.ParamByName('fDID').AsInteger := PContrData(CF.CredCombo.Items.Objects[CF.CredCombo.ItemIndex]).index;
      FPMainDataset.ParamByName('fSD').AsDate     := CF.RecDTEdit.Date;
      FPMainDataset.ParamByName('fPD').AsDate     := CF.Dt.Date;
      FPMainDataset.ParamByName('fSum').AsFloat   := CF.AmountEdit.Value;
      FPMainDataset.ParamByName('fDescr').AsString:= CF.DescrMemo.Text;
      FPMainDataset.ParamByName('fID').AsInteger  := CurID;
{$IFDEF USERID}
		FPMainDataset.ParamByName('fUserID').AsInteger := FPUserID;
{$ENDIF}
      try
        FPMainDataset.ExecSQL;
      except
		    on e: EZSQLException do begin
  	  	  ShowError(Self, 'Во время обновления данных произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
	  	    ModalResult := mrCancel;
      		Exit;
        end;
      end;
      // and renew main grid
    	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);

    end;
    CF.Free
  end;
end;

function TMainFPForm.GetAssetNameByLink(ANode: PVirtualNode; ALink: string): string;
var
	Node			: PVirtualNode;
	NodeData 	: PVTResourceData;
begin
  Result := '';
  if ALink = '' then
    Exit;
  Node := MainTree.GetFirstChild(ANode);
  while Node <> nil do begin
    NodeData := MainTree.GetNodeData(Node);
    if NodeData.link = ALink then begin
      Result := NodeData.name;
      Exit;
    end;
    if Node.ChildCount > 0 then begin
    	Result := GetAssetNameByLink(Node, ALink);
      if Result <> '' then
        Exit;
    end;
    Node := MainTree.GetNextSibling(Node);
  end;
end;

procedure TMainFPForm.OnStrGridPopupNeeded(var Msg: TMessage);
Var
	StrNum	: integer;
  Point		: TPoint;
begin
	if TryStrToInt(StrGrid.Cells[1, StrGrid.Row], StrNum) then begin
		MainTreePopupMenu.Items[SGPM_CLOSEDEBT].Visible := true;
		MainTreePopupMenu.Items[SGPM_DELENTITY].Visible := true;
  end
  else begin
		MainTreePopupMenu.Items[SGPM_CLOSEDEBT].Visible := false;
		MainTreePopupMenu.Items[SGPM_DELENTITY].Visible := false;
  end;

	if((CurValue = BRANCH_DEBITORS) or (CurValue = BRANCH_CREDITORS)) and (TryStrToInt(StrGrid.Cells[1, StrGrid.Row], StrNum)) and ((StrGrid.Cells[0, StrGrid.Row] = 'red') or (StrGrid.Cells[0, StrGrid.Row] = 'green') or (StrGrid.Cells[0, StrGrid.Row] = rsSubdPORow)) then begin
    StrGridPopupMenu.Items[SGPM_EDITENTRY].Visible := true;
  end
  else begin
    StrGridPopupMenu.Items[SGPM_EDITENTRY].Visible := false;
  end;

  StrGridPopupMenu.Popup(Msg.WParam, Msg.LParam);
end;

procedure TMainFPForm.OnPOsPopupNeeded(var Msg: TMessage);
Var
	PONum				: integer;
  Originator	: string;
begin

	if not TryStrToInt(StrGrid.Cells[1, StrGrid.Row], PONum) then begin
    CurPONum	:= 0;
//  	Exit;
  end;

  POsPopupMenu.Items[4].Visible := true;

  if PONum > 0 then begin
	  POsPopupMenu.Items[0].Visible := true;
  	POsPopupMenu.Items[1].Visible := true;
	  POsPopupMenu.Items[2].Visible := true;
  	POsPopupMenu.Items[3].Visible := true;

    CurPONum	:= PONum;

    FPMainDataset.SQL.Text := 'SELECT origin FROM ' + CurPrefix + 'po WHERE `index`='+IntToStr(PONum);
    try
      FPMainDataset.Open;
    except
    	on e : EZSQLException do begin
		  	ShowError(Self, 'Не удалось получить данные об авторе заявки. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
        Exit;
      end;
    end;

    Originator := FPMainDataset.FieldByName('origin').AsString;
    if (Pos(rsSubdPORow, StrGrid.Cells[0, StrGrid.Row]) > 0) and (Originator = FPLogin) then begin // i.e. we can edit it
      POCanBeEdited := true;
    	POsPopupMenu.Items[0].ImageIndex := 0;
      POsPopupMenu.Items[0].Caption	:= 'Изменить';
    end
    else begin
      POCanBeEdited := false;
    	POsPopupMenu.Items[0].ImageIndex := 1;
      POsPopupMenu.Items[0].Caption	:= 'Посмотреть';
    end;
// show/hide Unapprove PO item
  	POsPopupMenu.Items[POP_UNAPPROVE].Visible := (Pos(rsAppdPORow, StrGrid.Cells[0, StrGrid.Row]) > 0) and PrivPresentMO(CurPrivs, 'bs');
// show/hide "Delete PO" item
// it can be done only by originator or the one who has permition to do it
  	POsPopupMenu.Items[POP_DELETE].Visible := ((Pos(rsSubdPORow, StrGrid.Cells[0, StrGrid.Row]) > 0) or (Pos(rsRejdPORow, StrGrid.Cells[0, StrGrid.Row]) > 0)) and (PrivPresentMO(CurPrivs, 'bs') or (Originator = FPLogin));

  	POsPopupMenu.Items[2].Visible := (Pos(rsSubdPORow, StrGrid.Cells[0, StrGrid.Row]) > 0) and PrivPresentMO(CurPrivs, 'bu');
    POIsRO := not POsPopupMenu.Items[2].Visible;
  end
  else begin
	  POsPopupMenu.Items[0].Visible := false;
  	POsPopupMenu.Items[1].Visible := false;
	  POsPopupMenu.Items[2].Visible := false;
  	POsPopupMenu.Items[3].Visible := false;

  	POsPopupMenu.Items[POP_UNAPPROVE].Visible := false;
  	POsPopupMenu.Items[POP_DELETE].Visible    := false;
  end;

	POsPopupMenu.Popup(Msg.WParam, Msg.LParam);
end;

procedure TMainFPForm.OnFLPopupNeeded(var Msg: TMessage);
begin
  FLPopShowPOs.Enabled := StrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[3, StrGrid.Row], '.',','),ThSep,'')) * 100 > 0;
	FLPopupMenu.Popup(Msg.WParam, Msg.LParam);
end;

procedure TMainFPForm.OnPersPopupNeeded(var Msg: TMessage);
Var
	ContrIndex	: integer;
  Point				: TPoint;
  TmpVal			: Extended;
begin
  if (CurValue in [LIST_PERSONS]) then
		PersPopupMenu.Items[DCPM_VIEW].Visible := true
  else
		PersPopupMenu.Items[DCPM_VIEW].Visible := false;

	PersPopupMenu.Items[DCPM_SEARCH].Visible := true;
	PersPopupMenu.Items[DCPM_ADD].Visible := true;
	PersPopupMenu.Items[DCPM_DEL].Visible := true;
	PersPopupMenu.Items[DCPM_PROP].Visible := true;

	if (CurStrGridRow < 1) or (not TryStrToInt(StrGrid.Cells[0, CurStrGridRow], ContrIndex)) then begin
		PersPopupMenu.Items[DCPM_VIEW].Visible := false;
		PersPopupMenu.Items[DCPM_DEL].Visible := false;
		PersPopupMenu.Items[DCPM_PROP].Visible := false;
  end;
  PersPopupMenu.Popup(Msg.WParam, Msg.LParam);
end;

procedure TMainFPForm.OnDebCredPopupNeeded(var Msg: TMessage);
Var
	ContrIndex	: integer;
  Point				: TPoint;
  TmpVal			: Extended;
begin
	if (CurValue in [LIST_DEBITORS, LIST_CREDITORS]) and (CurStrGridRow > 0) and (TryStrToFloat(MyCleanStr(StrGrid.Cells[5, CurStrGridRow]), TmpVal)) and (TmpVal > 0) then
		DebCredPopupMenu.Items[DCPM_VIEW].Visible := true
  else
		DebCredPopupMenu.Items[DCPM_VIEW].Visible := false;

	DebCredPopupMenu.Items[DCPM_SEARCH].Visible := true;
	DebCredPopupMenu.Items[DCPM_ADD].Visible := true;
	DebCredPopupMenu.Items[DCPM_DEL].Visible := true;
	DebCredPopupMenu.Items[DCPM_PROP].Visible := true;

	if (CurStrGridRow < 1) or (not TryStrToInt(StrGrid.Cells[0, CurStrGridRow], ContrIndex)) then begin
		DebCredPopupMenu.Items[DCPM_VIEW].Visible := false;
		DebCredPopupMenu.Items[DCPM_DEL].Visible := false;
		DebCredPopupMenu.Items[DCPM_PROP].Visible := false;
  end;
  DebCredPopupMenu.Popup(Msg.WParam, Msg.LParam);
end;

procedure TMainFPForm.OnPopUpMenuNeeded(var Msg: TMessage);
Var
  Node 			: PVirtualNode;
  NodeData  : PVTResourceData;
begin
  Node := MainTree.GetFirstSelected;
  if Node <> nil then begin
    NodeData := MainTree.GetNodeData(Node);
    // Setting up "Rename Org" menu item
    MainTreePopupMenu.Items[MTPM_RENAMEORG].Visible := IsIt(RNodesArr, Node) and PrivPresentMO(CurPrivs, 'b');

    // Setting up "ShowAssetsvsFunds" menu item
    if (NodeData.branch in [BRANCH_ASSETS]) and (NodeData.page = 9) and
       (NodeData.link <> NodeData.prefix + CASH_LINK) and (NodeData.link <> NodeData.prefix + BILL1_LINK) and (NodeData.link <> NodeData.prefix + DISBCASH_LINK) and PrivPresentMO(CurPrivs, 'bk') then
			MainTreePopupMenu.Items[MTPM_SHOWAVFWIN].Visible := true
    else
			MainTreePopupMenu.Items[MTPM_SHOWAVFWIN].Visible := false;

		ArchUnarchFund.Visible := false;
		PopUpShowHideArchedFunds.Visible := false;
		if IsIt(FundNodesArr, Node) then begin // it's a "fund" item - might be useful for everybody
    	PopUpShowHideArchedFunds.Visible := true;
      ArchUnarchFund.Visible := false;
    end;
    if (PrivPresentMO(CurPrivs, 'bx') and (NodeData.branch in [BRANCH_FUNDS])) then begin
    	PopUpShowHideArchedFunds.Visible := false;
      ArchUnarchFund.Visible := (NodeData.arched) or ((not NodeData.arched) and (Round(NodeData.balance * 100) = 0));
      if NodeData.arched then begin
      	ArchUnarchFund.Caption := 'Вывести из архива';
      end
      else begin
      	ArchUnarchFund.Caption := 'Перевести в архив';
      end;
    end;

    // Setting up "AddEntity" menu item
    MainTreePopupMenu.Items[MTPM_ADDENTITY].Visible := false;
    if  ((NodeData.branch in [BRANCH_ASSETS, BRANCH_FUNDS]) and (NodeData.page = 8)) or ((NodeData.page = BRANCH_FUNDS) and (NodeData.sub = 0)) then begin
      if ((PrivPresentMO(CurPrivs, 'bk')) and ((NodeData.branch in [BRANCH_ASSETS]) or (IsIt(AssetNodesArr, Node)))) or
         ((PrivPresentMO(CurPrivs, 'bx')) and ((NodeData.branch in [BRANCH_FUNDS]) or (IsIt(FundNodesArr, Node)))) then begin
        MainTreePopupMenu.Items[MTPM_ADDENTITY].Visible := true;
			end;
      //MainTreePopupMenu.Items[MTPM_PROPERTIES].Visible := false;

//      MainTreePopupMenu.Items[MTPM_ADDENTITY].Visible := true;
      if MainTreePopupMenu.Items[MTPM_ADDENTITY].Visible = true then begin
        if NodeData.branch = BRANCH_ASSETS then
          MainTreePopupMenu.Items[MTPM_ADDENTITY].Caption := 'Добавить счет'
        else
          MainTreePopupMenu.Items[MTPM_ADDENTITY].Caption := 'Добавить фонд';
      end;
    end;
//    else
//      MainTreePopupMenu.Items[MTPM_ADDENTITY].Visible := false;

		// setting up "delete" button
//	  if (NodeData.branch = BRANCH_FUNDS) or (NodeData.branch = BRANCH_ASSETS) then begin
		if (NodeData.branch = BRANCH_FUNDS) or ((NodeData.branch = BRANCH_ASSETS) and (not (NodeData.link = 'gso'))) then begin
  	  FPMainDataset.SQL.Text := 'SELECT`link`FROM ' + NodeData.link + ' WHERE(`in`IS NOT NULL OR`out`IS NOT NULL)OR(`page`>8) ';
  	  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'union SELECT`index`as`lines` FROM '+ CurPrefix +'lfp WHERE(`6`=:fFundLink and (`1` in ("a1","b")))or(`5`=:fFundLink and (`1`in("c","d","e","f"))) limit 1';
      FPMainDataset.ParamByName('fFundLink').AsString := NodeData.link;
	    FPMainDataset.Open;
      MainTreePopupMenu.Items[MTPM_DELENTITY].Visible := FPMainDataset.RecordCount = 0;
  	end
		else if (NodeData.branch = BRANCH_FP) and (NodeData.sub = FPNOTAPPROVED) then begin
      MainTreePopupMenu.Items[MTPM_DELENTITY].Visible := PrivPresentMO(CurPrivs, 'bos');
  	end
    else if (NodeData.branch = BRANCH_FUNDS) or (NodeData.branch = BRANCH_ASSETS) then begin
      MainTreePopupMenu.Items[MTPM_DELENTITY].Visible := false;
    end
    else
      MainTreePopupMenu.Items[MTPM_DELENTITY].Visible := false;

    // Setting up "Properties" menu item
    if (PrivPresentMO(CurPrivs, 'bk') and (NodeData.branch in [BRANCH_ASSETS]) and (NodeData.link <> 'bank')) or
       (PrivPresentMO(CurPrivs, 'bx') and (NodeData.branch in [BRANCH_FUNDS])) then begin
      MainTreePopupMenu.Items[MTPM_PROPERTIES].Visible := true;
    end
    else
      MainTreePopupMenu.Items[MTPM_PROPERTIES].Visible := false;

    // Setting up EnterBalance MenuItem
    if (not NodeData.arched) and (NodeData.branch in [BRANCH_FUNDS]) and (NodeData.page = 9) and (FundOrAssetIsEmpty(NodeData.link)) then begin
      MainTreePopupMenu.Items[MTPM_ENTERBALANCE].Visible := true;
    end
    else
      MainTreePopupMenu.Items[MTPM_ENTERBALANCE].Visible := false;

    MainTreePopupMenu.Popup(Msg.WParam, Msg.LParam);
  end;
end;

procedure TMainFPForm.OnFPWasApproved(var Msg: TMessage);
var
	ANode : PVirtualNode;
  ANodeData	: PVTResourceData;
  sdata			: ^string;
  nname			: string;
  iop       : integer;
begin
  ANode := FPNANodesArr[Msg.WParam].FirstChild;

  sdata := pointer(Msg.LParam);
  nname := sdata^;
  Dispose(sdata);

  if ANode = nil then
	  Exit;

  // moving the approved FP to Archive branch
  ANodeData	:= MainTree.GetNodeData(ANode);
  ANodeData.sub  := FPARCHIVED;
  ANodeData.name := nname;
  iop := aNodeData.ipref;

  MainTree.MoveTo(FPNANodesArr[Msg.WParam], FPArchNodesArr[Msg.WParam], amAddChildFirst, True);
	ANode := MainTree.AddChild(FPNANodesArr[Msg.WParam]);
  // adding node to create new FP
  ANodeData	:= MainTree.GetNodeData(ANode);
	ANodeData.sub		:= FPNEWFPTOCREATE;
  ANodeData.name	:= 'Создать новое ФП';
  ANodeData.page	:= BRANCH_FP;
  ANodeData.branch:= BRANCH_FP;
  ANodeData.index	:= 0;
  ANodeData.ipref := iop;
  MainTree.Expanded[FPNANodesArr[Msg.WParam]] := true;
	if Assigned(FPForm) then begin
  	FPForm.Close;
  	FPForm.Free;
  end;
  FPForm := nil;

end;

procedure TMainFPForm.OnFPApprovedExt(var Msg: TMessage);
var
	ANode : PVirtualNode;
  ANodeData	: PVTResourceData;
  sdata			: ^string;
  i					: integer;
  nfp			  : integer;
  sdt				: string;
  spr				: string;
  dt				: TDateTime;
  ds				: char;
  ts				: char;
  sd				: string;
  st				: string;

begin
	sdata := pointer(Msg.LParam);
  sdt := sdata^;
  Dispose(sdata);

  ANode := FPNANodesArr[Msg.WParam].FirstChild;

  if ANode = nil then Exit;

  i := Pos(':', sdt);
  if(i = 0) then Exit;

  nfp := StrToInt(LeftStr(sdt, i - 1));
  if(nfp = 0) then Exit;
	sdt := MidStr(sdt, i + 1, Length(sdt));

  // moving the approved FP to archive branch
  ANodeData	:= MainTree.GetNodeData(ANode);
  if(AnodeData.index <> nfp) then Exit; // we do not need to move the node if its # does not fit the # from FP

	ds := FormatString.DateSeparator;
  ts := FormatString.TimeSeparator;
	sd := FormatString.ShortDateFormat;
  st := FormatString.ShortTimeFormat;
	FormatString.DateSeparator := '-';
  FormatString.TimeSeparator := ':';
	FormatString.ShortDateFormat := 'YYYY-MM-DD';
  FormatString.ShortTimeFormat := 'hh:nn:ss';
  dt := StrToDateTime(sdt, FormatString);
	FormatString.DateSeparator := ds;
  FormatString.TimeSeparator := ts;
	FormatString.ShortDateFormat := sd;
  FormatString.ShortTimeFormat := st;

  ANodeData.sub  := FPARCHIVED;
  ANodeData.name := IntToStr(nfp) + ': ' + DateTimeToStr(dt, FormatString);
  spr := ANodeData.prefix;
  i   := ANodeData.ipref;

  MainTree.MoveTo(FPNANodesArr[i], FPArchNodesArr[i], amAddChildFirst, True);

  // adding node with last FP #
	ANode := MainTree.AddChild(FPNANodesArr[i]);
  ANodeData	    := MainTree.GetNodeData(ANode);
	ANodeData.sub	:= FPNOTAPPROVED;

	ANodeData.name	 := GS_CREATE_NEW_FP;
  ANodeData.branch := BRANCH_FP;
  ANodeData.page	 := BRANCH_FP;
  ANodeData.index	 := 0;
  ANodeData.prefix := spr;
  ANodeData.ipref	 := i;
  CollapseExpandNode(ANode, ANodeData);

	if Assigned(FPForm) then begin
	  FPForm.Close;
  	FPForm.Free;
  end;
  FPForm := nil;
end;


procedure TMainFPForm.PullMainTreeData;
Var
	Node					: PVirtualNode;
  NodeData			: PVTResourceData;
  TmpNode				: PVirtualNode;
  TmpNodeData		: PVTResourceData;
  lPage					: integer;
  LDataset			: TZQuery;
  SectionStr		: string;
  Collapsed			: integer;

  ODataset			: TZQuery;
  PN						: PVirtualNode;    // (P)arent(N)ode
  ON1						: PVirtualNode;    // (O)rg (N)ode
  ONData				: PVTResourceData;
  iPrefix				: integer;			   // Integer value of PVTResourceData.Prefix
  FPStr					: string;
  FirstValidOrg : integer;
begin

  GetLocaleFormatSettings(0, sFormat);
	sFormat.CurrencyString := '';

  ErrorTreeLoading  := false;

	MainTree.NodeDataSize := SizeOf(TVTResourceData);

	LDataset            := TZQuery.Create(nil);
  LDataset.Connection := FPConnection;

  FirstValidOrg       := -1;
	ODataset            := TZQuery.Create(nil);
  ODataset.Connection := FPConnection;

  LPF.Lbl.Caption := 'Получаем список организаций';
  LPF.PB.AddProgress(1);
  LPF.Repaint;

  ODataset.SQL.Text		:= 'SELECT OrgID,SeniorID,Abbr,Name,Address,Phone,Prefix,FPPrivs FROM orgs LEFT JOIN uofp ON orgs.ID=uofp.OrgID WHERE uofp.UserID=:fuid ORDER BY SeniorID,OrgID';// LOCK IN SHARE MODE';
  ODataset.ParamByName('fuid').AsInteger	:= UserID;
  try
    ODataset.Open;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, 'Невозможно получить данные об организациях.', e.ErrorCode, e.StatusCode, e.Message);
      ErrorTreeLoading := true;
      exit;
    end;
  end;

  if ODataset.RecordCount = 0 then begin
  	Application.MessageBox(PWideChar(rsNoOrgsToDisplay), PWideChar(rsClosingProgram), MB_ICONERROR or MB_OK);
    Halt;
  end;


  LPF.PB.MaxValue := ODataset.RecordCount * 10;
  LPF.PB.AddProgress(1);

  LPF.Repaint;

  while (not ODataset.Eof) and (not ErrorTreeLoading) do begin //

		PN        := GetPONode(nil, ODataset.FieldByName('SeniorID').AsInteger);
    CurPrivs  := ODataset.FieldByName('FPPrivs').AsString;

		ON1		        	:= MainTree.AddChild(PN);
  	ONData					:= MainTree.GetNodeData(ON1);

	  ONData.name			:= ODataset.FieldByName('Abbr').AsString;
  	ONData.link    	:= 'root';
	  ONData.page    	:= 2;
    ONData.index		:= ODataset.FieldByName('OrgID').AsInteger;
  	ONData.imindex	:= 1;
    ONData.balance	:= 0;
    ONData.descr		:= ODataset.FieldByName('FPPrivs').AsString; // privs in case of the org node
    ONData.prefix		:= ODataset.FieldByName('Prefix').AsString;
    ONData.ipref		:= ODataset.FieldByName('OrgID').AsInteger;

    iPrefix := ONData.ipref;
    if Length(AssetNodesArr) < iPrefix + 1 then begin
    	SetLength(AssetNodesArr,  iPrefix + 1);
    	SetLength(BankNodesArr,   iPrefix + 1);
    	SetLength(FundNodesArr,   iPrefix + 1);
    	SetLength(RNodesArr,  	  iPrefix + 1);
    	SetLength(FPArchNodesArr, iPrefix + 1);
    	SetLength(FPNANodesArr,   iPrefix + 1);
    	SetLength(FPPostsArr,     iPrefix + 1);
      SetLength(OrgNamesArr,    iPrefix + 1);
      SetLength(OrgAddressesArr,iPrefix + 1);
      SetLength(OrgPhonesArr,   iPrefix + 1);
    end;
    OrgNamesArr[iPrefix] := ODataset.FieldByName('Name').AsString;
    OrgAddressesArr[iPrefix] := ODataset.FieldByName('Address').AsString;
    OrgPhonesArr[iPrefix] := ODataset.FieldByName('Phone').AsString;

    if FirstValidOrg < 0 then
      FirstValidOrg := iPrefix;

    RNodesArr[iPrefix] := ON1;

    CollapseExpandNode(RNodesArr[iPrefix], ONData);

  	LPF.Lbl.Caption := 'Организация: ' + ONData.name;
//  LPF.PB.StepIt;
	  LPF.PB.AddProgress(1);
  	LPF.Repaint;
    //
    // pulling post title for each org
    //
	  FPMainDataset.SQL.Text :=
//    	'SELECT ' + ONData.prefix+ 'postsdir.ID AS PostID,Abbr,tbl2.UserID AS UID FROM ' + ONData.prefix+ 'postsdir LEFT JOIN' +
    	'SELECT Abbr FROM ' + ONData.prefix+ 'postsdir LEFT JOIN' +
    	'(SELECT PostID,UserID FROM ' + ONData.prefix+ 'psts LEFT JOIN(SELECT pstsid,userid FROM ' + ONData.prefix+ 'pstsfills LEFT JOIN users USING(UserID)WHERE(UserID=:fUserID)AND(Now()>=startdate)AND((Now()<enddate)OR(enddate is NULL)))AS tbl1 ' +
      'ON tbl1.pstsid=' + ONData.prefix+ 'psts.id)AS tbl2 ON tbl2.PostID=' + ONData.prefix+ 'postsdir.ID WHERE tbl2.UserID=:fUserID';
    FPMainDataset.ParamByName('fUserID').AsInteger := UserID;

  	try
    	FPMainDataset.Open;
    except
 		  on e: EZSQLException do begin
	  	  ShowError(Self, 'Невозможно получить данные о должности.', e.ErrorCode, e.StatusCode, e.Message);
        ErrorTreeLoading := true;
        break;
//        exit;
      end;
    end;

    if not FPMainDataset.Eof then begin
      FPPostsArr[iPrefix] := FPMainDataset.FieldByName('Abbr').AsString;
    end
    else begin
      Application.MessageBox(PWideChar('Вам не назначен пост в организации "' + ONData.name +'".' + CRLF + 'Возможна некорректная работа программы.'), 'Вам не назначен пост', MB_ICONWARNING or MB_OK);
    end;
    //
    // pulling posts - end of
    //

    LPF.Lbl.Caption := 'Организация: ' + ONData.name + '. Обрабатывается каталог ресурсов';
    LPF.PB.AddProgress(1);
    LPF.Repaint;

    // Main cycle - adjust it per the proper priviledges strings
	  FPMainDataset.SQL.Text := 'SELECT * from root';
  	try
    	FPMainDataset.Open;
    except
 	    on e: EZSQLException do begin
	  	  ShowError(Self, 'Невозможно получить данные из каталога ресурсов.', e.ErrorCode, e.StatusCode, e.Message);
        ErrorTreeLoading := true;
        break;
      end;
    end;

	  while not FPMainDataset.Eof do begin
	    lPage := FPMainDataset.FieldByName('page').AsInteger;
	    if (lPage = BRANCH_ASSETS) and (not PrivPresentMO(CurPrivs, 'bgk')) then begin
  	    FPMainDataset.Next;
    	  Continue;
	    end;
  	  if (lPage = BRANCH_FUNDS) and (not PrivPresentMO(CurPrivs, 'bi')) then begin
    	  FPMainDataset.Next;
      	Continue;
	    end;
  	  if (lPage = BRANCH_DEBITORS) and (not PrivPresentMO(CurPrivs, 'bp')) then begin
    	  FPMainDataset.Next;
      	Continue;
	    end;
  	  if (lPage = BRANCH_CREDITORS) and (not PrivPresentMO(CurPrivs, 'bt')) then begin
    	  FPMainDataset.Next;
      	Continue;
	    end;
  	  if (lPage = BRANCH_FP) and (not PrivPresentMO(CurPrivs, 'bm')) then begin
    	  FPMainDataset.Next;
      	Continue;
	    end;
  	  if (lPage = BRANCH_SEARCH) and (PrivPresentMO(CurPrivs, 'a')) then begin
    	  FPMainDataset.Next;
      	Continue;
	    end;
  	  if (lPage = BRANCH_ACCESS) and (not PrivPresentMO(CurPrivs, 'bn')) then begin
    	  FPMainDataset.Next;
      	Continue;
	    end;

		  Node := MainTree.AddChild(ON1);
  		NodeData := MainTree.GetNodeData(Node);
	  	NodeData.name			:= FPMainDataset.FieldByName('name').AsString;
	    NodeData.page			:= lPage;
  	  NodeData.imindex	:= FPMainDataset.FieldByName('index').AsInteger + 1;
    	NodeData.link			:= ONData.prefix + FPMainDataset.FieldByName('link').AsString;
      NodeData.balance	:= 0;
      NodeData.prefix		:= ONData.prefix;
      NodeData.ipref		:= ONData.ipref;
			CollapseExpandNode(Node, NodeData);

      LPF.Lbl.Caption := 'Организация: ' + ONData.name + '. Обрабатывается каталог ресурсов (' + NodeData.name + ')';
      LPF.PB.AddProgress(1);
      LPF.Repaint;

	    if lPage = BRANCH_ASSETS then  // 3
  	  	AssetNodesArr[iPrefix] := Node;
    	if lPage = BRANCH_FUNDS then //begin   // 4
    		FundNodesArr[iPrefix]  := Node;

      if lPage in [BRANCH_ASSETS, BRANCH_FUNDS] then begin  // it's an asset or fond
        CEL_ErrCode := 0;
        CompEntList(MainTree, Node, NodeData.link, 0, NodeData.page);
        if CEL_ErrCode <> 0 then begin
          ShowError(Self, 'Ошибка при инициализации БД.', CEL_ErrCode, CEL_StatusCode, CEL_Message);
          ErrorTreeLoading := true;
          continue;
        end;

    	  if FPMainDataset.FieldByName('page').AsInteger = BRANCH_ASSETS then begin // if it's an asset
  	    	TmpNode	          := MainTree.GetFirstChild(Node);
    	    if TmpNode <> nil then begin
      	    NodeData  := MainTree.GetNodeData(TmpNode);
        	  if NodeData.index = CASHID then // i.e., if it's a cash
          		PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 10 // 12
            else if NodeData.index = DISBCASHID then begin
//            	PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 10
            end
	          else if NodeData.index = BANKID then begin
  	        	PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 11;
        	  	BankNodesArr[iPrefix] := TmpNode;
      	    end;

        		TmpNode	  := MainTree.GetNextSibling(TmpNode);
          	NodeData  := MainTree.GetNodeData(TmpNode);
	          if NodeData.index = CASHID then // i.e., if it's a cash
  	        	PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 10 // 12
            else if NodeData.index = DISBCASHID then begin
//            	PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 10
            end
    	      else if NodeData.index = BANKID then begin
      	    	PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 11;
        	  	BankNodesArr[iPrefix] := TmpNode;
          	end;
          	TmpNode	  := MainTree.GetNextSibling(TmpNode);
            NodeData  := MainTree.GetNodeData(TmpNode);
            if NodeData.index = CASHID then // i.e., if it's a cash
            	PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 10  // 12
            else if NodeData.index = DISBCASHID then begin
//            	PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 10
            end
            else if NodeData.index = BANKID then begin
            	PVTResourceData(MainTree.GetNodeData(TmpNode)).imindex := 11;
        	  	BankNodesArr[iPrefix] := TmpNode;
            end;
	        end;
  	    end;
    	end
	    else if lPage in [BRANCH_FP] then begin // an FP branch
	  	  FPNANodesArr[iPrefix]	:= MainTree.AddChild(Node);
  	  	FPNANodeData 					:= MainTree.GetNodeData(FPNANodesArr[iPrefix]);
        FPNANodeData.prefix		:= ONData.prefix;
        FPNANodeData.ipref		:= ONData.ipref;

	    	FPNANodeData.branch := lPage;
		    FPNANodeData.page		:= lPage;
  		  FPNANodeData.name   := 'Неодобренные ФП';
	    	FPNANodeData.sub	  := FPNOTAPPROVEDBRANCH;
				CollapseExpandNode(FPNANodesArr[iPrefix], FPNANodeData);

	  	  FPArchNodesArr[iPrefix] := MainTree.AddChild(Node);

  	  	FPArchNodeData			  := MainTree.GetNodeData(FPArchNodesArr[iPrefix]);
        FPArchNodeData.prefix	:= ONData.prefix;
        FPArchNodeData.ipref	:= ONData.ipref;
	    	FPArchNodeData.branch := lPage;
		    FPArchNodeData.page		:= lPage;
	  	  FPArchNodeData.name   := 'Архив';
  	  	FPArchNodeData.sub	  := FPARCHBRANCH;

				CollapseExpandNode(FPArchNodesArr[iPrefix], FPArchNodeData);

				FPStr := ONData.prefix + 'fp';
		    LDataset.SQL.Text   := 'SELECT`index`,`to`FROM ' + FPStr + ' WHERE `to` IS NOT NULL ORDER BY `index` DESC';// LIMIT 1'; //+ ' ORDER BY `index` ASC';
        try
    		  LDataset.Open;
        except
      	  on e: EZSQLException do begin
		        ShowError(Self, 'Невозможно получить данные о финансовых планированиях.', e.ErrorCode, e.StatusCode, e.Message);
            ErrorTreeLoading := true;
            continue;
	        end;
        end;
	    	while not LDataset.Eof do begin
	      	FPTmpDataset.SQL.Text := 'SHOW TABLES LIKE "' + FPStr + LDataset.FieldByName('index').AsString + '"';
          try
	    	    FPTmpDataset.Open;
          except
        	  on e: EZSQLException do begin
		          ShowError(Self, 'Ошибка обработки ФП.', e.ErrorCode, e.StatusCode, e.Message);
              ErrorTreeLoading := true;
  	        end;
          end;
  	  	  if FPTmpDataset.RecordCount > 0 then begin // this is an approved FP, add it to "Archive" branch
    	  	  TmpNode         := MainTree.AddChild(FPArchNodesArr[iPrefix]);
	  		    TmpNodeData	    := MainTree.GetNodeData(TmpNode);
		    	  TmpNodeData.sub	:= FPARCHIVED;
		      end
  		    else begin
    		    TmpNode         := MainTree.AddChild(FPNANodesArr[iPrefix]);
      		  TmpNodeData	    := MainTree.GetNodeData(TmpNode);
		    	  TmpNodeData.sub	:= FPNOTAPPROVED;
		      end;

//	    	  TmpNodeData.name	 := LDataset.FieldByName('index').AsString + ': ' + DateTimeToStr(StrToDateTime(LDataset.FieldByName('to').AsString, QFormatString), lFormatString);
	    	  TmpNodeData.name	 := LDataset.FieldByName('index').AsString + ': ' + DateTimeToStr(LDataset.FieldByName('to').AsDateTime, lFormatString);
  	    	TmpNodeData.branch := lPage;
    	  	TmpNodeData.page	 := lPage;
      	  TmpNodeData.index	 := LDataset.FieldByName('index').AsInteger;
          TmpNodeData.prefix := ONData.prefix;
          TmpNodeData.ipref	 := ONData.ipref;
        	CollapseExpandNode(TmpNode, TmpNodeData);

	  	  	LDataset.Next;
  	  	end;

    	  if FPNANodesArr[iPrefix].ChildCount = 0 then begin // i.e. if all FPs are approved
   	  	  TmpNode            := MainTree.AddChild(FPNANodesArr[iPrefix]);
	     	  TmpNodeData	       := MainTree.GetNodeData(TmpNode);
		      TmpNodeData.sub		 := FPNEWFPTOCREATE;
    		  TmpNodeData.name	 := GS_CREATE_NEW_FP;
      		TmpNodeData.page	 := lPage;
      		TmpNodeData.branch := lPage;
	        TmpNodeData.index	 := 0;
          TmpNodeData.prefix := ONData.prefix;
          TmpNodeData.ipref  := ONData.ipref;
  	    end;
    	end // else if lPage in [BRANCH_FP]
	    else if lPage in [BRANCH_DEBITORS]  then begin // if it's a planning branch
  	 		TmpNode 					 := MainTree.AddChild(Node);
    	 	TmpNodeData				 := MainTree.GetNodeData(TmpNode);
	    	TmpNodeData.sub		 := 0;
	    	TmpNodeData.name	 := rsListDebtors;
  	    TmpNodeData.page	 := LIST_DEBITORS;
    	  TmpNodeData.branch := lPage;
      	TmpNodeData.index	 := 0;
        TmpNodeData.prefix := ONData.prefix;
        TmpNodeData.ipref  := ONData.ipref;
	    end
  	  else if lPage in [BRANCH_CREDITORS] then begin // if it's a planning branch
   			TmpNode 					 := MainTree.AddChild(Node);
     		TmpNodeData				 := MainTree.GetNodeData(TmpNode);
		    TmpNodeData.sub		 := 0;
  	  	TmpNodeData.name	 := rsListCreditors;
    	  TmpNodeData.page	 := LIST_CREDITORS;
      	TmpNodeData.branch := lPage;
	      TmpNodeData.index	 := 0;
        TmpNodeData.prefix := ONData.prefix;
        TmpNodeData.ipref  := ONData.ipref;
  	  end;
//  	  else if lPage in [BRANCH_PERSONS] then begin // if it's a planning branch
//   			TmpNode 					 := MainTree.AddChild(Node);
//     		TmpNodeData				 := MainTree.GetNodeData(TmpNode);
//		    TmpNodeData.sub		 := 0;
//  	  	TmpNodeData.name	 := rsListPersons;
//    	  TmpNodeData.page	 := LIST_PERSONS;
//      	TmpNodeData.branch := lPage;
//	      TmpNodeData.index	 := 0;
//        TmpNodeData.prefix := ONData.prefix;
//        TmpNodeData.ipref  := ONData.ipref;
//  	  end;

      FPMainDataset.Next;
    end;

    ODataset.Next;
  end;

  ODataset.Close;
  ODataset.Free;

  if not ErrorTreeLoading then begin
    MainTree.ClearSelection;
    SetUpToolBar;
    if FirstValidOrg >= 0 then begin
      CurNode := RNodesArr[FirstValidOrg];
      MainTree.Selected[RNodesArr[FirstValidOrg]] := true;
      MainTree.FocusedNode  := RNodesArr[FirstValidOrg];
      MainTreeDblClick(Self);
    end;
  end;

  LDataset.Close;
  LDataset.Free;
end;

procedure TMainFPForm.PwdButtonClick(Sender: TObject);
var
  PwdChangeForm: TPwdChangeForm;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

	PwdChangeForm := TPwdChangeForm.Create(Self);
  PwdChangeForm.Caption := 'Смена пароля';
  PwdChangeForm.Login   := FPLogin;
  PwdChangeForm.User    := FPNameOfUser;
  PwdChangeForm.ShowModal;
  PwdChangeForm.Free;

end;

Procedure TMainFPForm.CompEntList(VTree : TBaseVirtualTree; NodeToStart : PVirtualNode; Source : string; Level : integer; Branch:integer);
var
  T_Dataset   : TZQuery;
  T1_Dataset  : TZQuery;
  NewNode     : PVirtualNode;
  NewNodeData : PVTResourceData;
  TmpName     : String;
  TmpLink     : string;
  TmpPref			: string;
  NodeData		: PVTResourceData;
	TmpPrefix		: string;
{$IFDEF FAFH}
  bIsFndr     : boolean;
{$ENDIF}
begin
  if CEL_ErrCode <> 0 then
    Exit;

  if not FPConnection.Connected then
    FPConnection.Reconnect;

  T_Dataset := TZQuery.Create(nil);
  T_Dataset.Connection := FPConnection;

  T1_Dataset := TZQuery.Create(nil);
  T1_Dataset.Connection := FPConnection;

  // setting up total balance
  NewNodeData := VTree.GetNodeData(NodeToStart);
{$IFDEF FAFH}
	bIsFndr := PrivPresentMO(CurPrivs, 'b0');
  if bIsFndr then begin
{$ENDIF}
	  T_Dataset.SQL.Text    := 'SELECT SUM(`balance`)as`balance`FROM ' + Source;
{$IFDEF FAFH}
	end
  else begin
	  if (Source = NewNodeData.prefix + 'asset') then begin
		  T_Dataset.SQL.Text    := 'SELECT SUM(balance) AS`balance`FROM(SELECT`balance`FROM`' + NewNodeData.prefix + 'bank`WHERE`fnd`=0 UNION SELECT`balance`FROM`' + NewNodeData.prefix + 'asset`WHERE`index`<4)AS T1';
		end
	  else begin
		  T_Dataset.SQL.Text    := 'SELECT SUM(`balance`)as`balance`FROM`' + Source + '`WHERE fnd=0';
	  end;
  end;
{$ENDIF}

  try
    T_Dataset.Open;
  except
 	  on e: EZSQLException do begin
      CEL_ErrCode   := e.ErrorCode;
      CEL_StatusCode:= e.StatusCode;
      CEL_Message   := e.Message;
    end;
  end;

  if CEL_ErrCode = 0 then begin
	  NodeData              := VTree.GetNodeData(NodeToStart);
    NewNodeData.balance   := T_Dataset.FieldByName('balance').AsFloat;
	  TmpPrefix	 := NewNodeData.prefix;
  	T_Dataset.SQL.Text  := 'SELECT`index`,`name`,`link`,`sub`,`balance`,`page`,`assetlink`';
    if(Source = NodeData.prefix + 'fond') then begin
	  	T_Dataset.SQL.Text  := T_Dataset.SQL.Text + ',`arched`';
    end;
{$IFDEF FAFH}
    if(Source = NodeData.prefix + 'fond') or (Source = NodeData.prefix + 'bank') then begin
	  	T_Dataset.SQL.Text  := T_Dataset.SQL.Text + ',`fnd`';
    end;
{$ENDIF}
  	T_Dataset.SQL.Text  := T_Dataset.SQL.Text + 'FROM ' + Source + ' LEFT JOIN ' + NodeData.prefix + 'fundsvsassets ON link=fundlink';
    if (Source = NodeData.prefix + 'fond') then begin
      if gHideArchedFunds then
				T_Dataset.SQL.Text  := T_Dataset.SQL.Text  + ' WHERE arched<>1';
    end;
    if Source <> NodeData.prefix + 'asset' then
			T_Dataset.SQL.Text  := T_Dataset.SQL.Text  + ' ORDER BY`name`';
    try
      T_Dataset.Open;
    except
 	    on e: EZSQLException do begin
        CEL_ErrCode   := e.ErrorCode;
        CEL_StatusCode:= e.StatusCode;
        CEL_Message   := e.Message;
      end;
    end;
  end; // if CEL_ErrCode = 0

  while not T_Dataset.Eof and (CEL_ErrCode = 0) do begin
    TmpName := Trim(T_Dataset.FieldByName('name').AsAnsiString);
    if LeftStr(TmpName, 2) = '<<' then begin
      T_Dataset.Next;
      continue;
    end;

    TmpLink := T_Dataset.FieldByName('link').AsString;
    // next line might be moved to other place
    if TmpLink = 'debitors' then begin
      T_Dataset.Next;
      continue;
    end;
    if (Branch = BRANCH_ASSETS) and not (PrivPresentMO(CurPrivs, 'bgk') or
      (TmpLink = TmpPrefix + CASH_LINK) or (TmpLink = TmpPrefix + 'bank') or (TmpLink = TmpPrefix + BILL1_LINK)) then begin
      T_Dataset.Next;
      continue;
    end;
{$IFDEF FAFH}
    if ((Source = NodeData.prefix + 'fond') or (Source = NodeData.prefix + 'bank')) and (boolean(T_Dataset.FieldByName('fnd').AsInteger)) then begin
      if not PrivPresentMO(CurPrivs, 'b0') then begin
        T_Dataset.Next;
        continue;
      end;
    end;
{$ENDIF}

    NewNode     := VTree.AddChild(NodeToStart, nil);
    NewNodeData := VTree.GetNodeData(NewNode);
    NewNodeData.name    := TmpName;
    NewNodeData.link    := TmpLink;
    NewNodeData.level   := Level;
    NewNodeData.sub     := T_Dataset.FieldByName('sub').AsInteger;
{$IFDEF FCBF}
{$ENDIF}
    NewNodeData.balance := T_Dataset.FieldByName('balance').AsExtended;

    NewNodeData.index		:= T_Dataset.FieldByName('index').AsInteger;
    NewNodeData.page		:= T_Dataset.FieldByName('page').AsInteger;
		NewNodeData.prefix	:= TmpPrefix;
    if (Source = NodeData.prefix + 'fond') then
			NewNodeData.arched	:= T_Dataset.FieldByName('arched').AsInteger = 1;
    if NewNodeData.arched and gHideARchedFunds then begin
			NewNode.States := NewNode.States - [vsVisible];
    end;
{$IFDEF FAFH}
    if (Source = NodeData.prefix + 'fond') or (Source = NodeData.prefix + 'bank') then begin
      NewNodeData.fnd 		:= boolean(T_Dataset.FieldByName('fnd').AsInteger);
    end;
{$ENDIF}

{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('--- CompEntList(' + IntToStr(Level) + '): ' + NewNodeData.name + ' ---'));
{$ENDIF}

		CollapseExpandNode(NewNode, NewNodeData);

    if not T_Dataset.FieldByName('assetlink').IsNull then
    	NewNodeData.alink := T_Dataset.FieldByName('assetlink').AsString;
    NewNodeData.branch	:= Branch;
    if Branch = BRANCH_FUNDS then begin // i.e. if it's a fund
    	T1_Dataset.SQL.Text := 'SELECT assetlink FROM ' + TmpPrefix + 'fundsvsassets WHERE fundlink="' + NewNodeData.link + '"';
      try
        T1_Dataset.Open;
      except
   	    on e: EZSQLException do begin
          CEL_ErrCode   := e.ErrorCode;
          CEL_StatusCode:= e.StatusCode;
          CEL_Message   := e.Message;
          continue;
        end;
      end;

      if not T1_Dataset.Eof then begin
	      NewNodeData.alink := T1_Dataset.FieldByName('assetlink').AsString;
      end;
    end; // if Branch = BRANCH_FUNDS

    if NewNodeData.sub > 0 then
      CompEntList(VTree, NewNode,  NewNodeData.link,  Level + 1, Branch);

    T_Dataset.Next;
  end;

  T_Dataset.Close;
  T_Dataset.Free;
  T1_Dataset.Close;
  T1_Dataset.Free;
end;

procedure TMainFPForm.InitDB;
var
  Funds, assets : extended;
  StrBegin, StrEnd : String;
  TmpButton : TButton;
  ConfigCompleted	: boolean;

{$IFDEF SHOWFINSTATS}
  // vars for the income graph
  i							: integer;
  j							: integer;
  NowMoment			: TDateTime;
  LastFPMoment	: TDateTime;
  sGB						: TsGroupBox;
	Chart					: TChart;
	Line 					: TLineSeries;

  GIValues			: array of extended;
  Dates  				: array of TDateTime;
{$ENDIF}

begin
  // Setting initials
  PrintingIsIP := false;
  GetLocaleFormatSettings(0, FormatString);
  FormatString.CurrencyString := '';
  ThSep := FormatString.ThousandSeparator;

  TmpFundCombo                := TComboBox.Create(nil);
  TmpFundCombo.Parent         := Self;
  TmpFundCombo.Visible        := false;

  // transferring userID to GlobalSection
  FPUserID := UserID;

  // setting up connection to DB server
  FPConnection := Connection;
  Connection := nil;

  // Store the connection data
  GFPHost := FPConnection.HostName;
  GFPUser := FPConnection.User;
  GFPPort := FPConnection.Port;
  GFPPwd  := FPConnection.Password;
  GFPDb   := FPConnection.Database;
  GFPProt := FPConnection.Protocol;

  // initializing of TZQuery instantiations
  FPMainDataset := TZQuery.Create(nil);
  FPMainDataset.Connection := FPConnection;

  FPTmpDataset  := TZQuery.Create(nil);
  FPTmpDataset.Connection  := FPConnection;

	QFormatString.DateSeparator := '-';
	QFormatString.TimeSeparator	:= ':';
	QFormatString.LongDateFormat   := 'YYYY-MM-DD';
  QFormatString.ShortDateFormat  := 'YYYY-MM-DD';
  QFormatString.ShortTimeFormat  := 'HH:MM:SS';
  QFormatString.LongTimeFormat   := 'HH:MM:SS';


{$IFDEF SHOWFINSTATS}
// here goes the Income stats building - now it's in a separate file
{I IncomeGraph.pas}
{$ELSE}
	StatsScrollBox.Visible	:= false;
  StatsSplitter.Visible		:= false;
  GridPanel.Align					:= alClient;
{$ENDIF}

	GetMaxFileSize;

  FPMainDataset.SQL.Text := 'SET CHARSET cp1251';
  FPMainDataset.ExecSQL;

//  FPMainDataset.SQL.Text := 'SET autocommit=0';
  FPMainDataset.SQL.Text := 'SET autocommit=1';
  FPMainDataset.ExecSQL;

  LPF := TLoadingProgressForm.Create(nil);
  LPF.Lbl.Caption := 'Получаем данные о пользователе';
//  IntToStr(LPF.PB.Max) + ';'+IntToStr(LPF.PBА.Min)';'+IntToStr(LPF.PB.Position),
//  LPF.PB.Max := 100;
//  LPF.PB.Min := 0;
//  LPF.PB.Step:= 1;
//  LPF.PB.Position := 0;
  LPF.PB.MaxValue := 100;
  LPF.PB.MinValue := 0;
//  LPF.PB.Step:= 1;
  LPF.PB.Progress := 0;
  LPF.PB.AddProgress(1);
  LPF.Show;

  // put client version into DB
  FPMainDataset.SQL.Text := 'UPDATE users SET LastAppear=NOW(),cv=:fcv WHERE UserID=:fUID';
  FPMainDataset.ParamByName('fcv').AsString 	:= cv;
  FPMainDataset.ParamByName('fUID').AsInteger := FPUserID;
  try
    FPMainDataset.ExecSQL;
  except
	  on e: EZSQLException do begin
  	  ShowError(Self, 'Ошибка обновления данных о пользователе.', e.ErrorCode, e.StatusCode, e.Message);
    end;
  end;

  // Getting name and posts of users
	with FPMainDataset do begin
  	SQL.Text := 'SELECT Login,FamilyName,Left(FirstName,1)AS FName,Left(MiddleName,1)AS MName, NOW() as stime FROM users WHERE UserID=:fUserID';
		ParamByName('fUserID').AsInteger  := FPUserID;
		Open;
	  FPLogin      		:= FieldByName('Login').AsString;
	  FPNameOfUser 		:= GetShortFIO(FieldByName('FamilyName').AsString, FieldByName('FName').AsString, FieldByName('MName').AsString);
    GLogPulledDT    := FieldByName('stime').AsDateTime;
  end;

	ErrorTreeLoading := false;
	PullMainTreeData;
	if ErrorTreeLoading then begin
		Application.MessageBox('При инициализации БД произошла ошибка.', 'Инициализация базы данных', MB_ICONERROR or MB_OK);
		ModalResult := mrCancel;
		Application.Terminate;
  end;

{$IFDEF TLOG}
	// Getting name and posts of users
	with FPMainDataset do begin
  	SQL.Text := 'SELECT`id`FROM`log`ORDER BY`id`DESC LIMIT 1';
		Open;
	  llid := FieldByName('id').AsInteger;
  end;
{$ENDIF}


  LPF.Lbl.Caption := 'Настраивается главное окно приложения.';
//  LPF.PB.Stepit;
  LPF.PB.AddProgress(1);
  LPF.Repaint;

  // pulling settings for PO settings
 	ShowAllPOs						:= true;
 	ShowSubmittedPOsOnly 	:= false;
	ShowRejectedPOsOnly		:= false;
	ShowApprovedPOsOnly		:= false;
	ShowPaidPOsOnly				:= false;
  ConfigCompleted				:= false;
  if WorkingWithIni then begin
		ShowAllPOs					 := Inifile.ReadBool(POIniSection, 'ShowAllPOs', true);
  	IniFile.WriteBool(POIniSection, 'ShowAllPOs', ShowAllPOs);

    if ShowAllPOs then begin
    	ConfigCompleted := true;
    end;
    if not ConfigCompleted then begin
			ShowSubmittedPOsOnly := Inifile.ReadBool(POIniSection, 'ShowSubmittedPOsOnly', false);
      if ShowSubmittedPOsOnly then
      	ConfigCompleted := true;
    end;
    if not ConfigCompleted then begin
			ShowRejectedPOsOnly	 := Inifile.ReadBool(POIniSection, 'ShowRejectedPOsOnly', false);
      if ShowRejectedPOsOnly then
      	ConfigCompleted := true;
    end;
    if not ConfigCompleted then begin
			ShowApprovedPOsOnly	 := Inifile.ReadBool(POIniSection, 'ShowApprovedPOsOnly', false);
      if ShowApprovedPOsOnly then
      	ConfigCompleted := true;
    end;
    if not ConfigCompleted then begin
			ShowPaidPOsOnly			 := Inifile.ReadBool(POIniSection, 'ShowPaidPOsOnly', false);
      if ShowPaidPOsOnly then
      	ConfigCompleted := true;
    end;
    if not ConfigCompleted then
    	ShowAllPOs := true;


  	IniFile.WriteBool(POIniSection, 'ShowAllPOs', ShowAllPOs);
  	IniFile.WriteBool(POIniSection, 'ShowSubmittedPOsOnly', ShowSubmittedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowRejectedPOsOnly', ShowRejectedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowApprovedPOsOnly', ShowApprovedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowPaidPOsOnly', ShowPaidPOsOnly);
    IniFile.UpdateFile;
  end
  else begin
  	ShowAllPOs						:= true;
  	ShowSubmittedPOsOnly 	:= false;
    ShowRejectedPOsOnly		:= false;
    ShowApprovedPOsOnly		:= false;
  	ShowPaidPOsOnly				:= false;
  end;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := ShowSubmittedPOsOnly;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := ShowRejectedPOsOnly;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := ShowApprovedPOsOnly;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := ShowPaidPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked := ShowAllPOs or ShowSubmittedPOsOnly;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked := ShowAllPOs or ShowRejectedPOsOnly;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked := ShowAllPOs or ShowApprovedPOsOnly;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked := ShowAllPOs or ShowPaidPOsOnly;

  LPF.Close;
  LPF.Destroy;
end;

procedure TMainFPForm.UnapprovePOPopUpClick(Sender: TObject);
var
  id      : integer;
  NoError : boolean;
  status  : integer;
  bycash  : boolean;
  flink   : string;
  alink   : string;
  suma    : extended;
//  PONotLocked : boolean;
begin
//
  id := 0;
  NoError     := true;
  if (StrGrid.Row < StrGrid.RowCount) and (TryStrToInt(StrGrid.Cells[1, StrGrid.Row], id)) and (id > 0) then begin
    if Application.MessageBox('Вы действительно хотите отменить одобрение заявки?', PWideChar('Отмена одобрения заявки № ' + StrGrid.Cells[1, StrGrid.Row]), MB_ICONWARNING or MB_YESNO) = mrYes then begin
      // start transaction
    	FPMainDataset.SQL.Text := 'BEGIN';
      try
  	    FPMainDataset.ExecSQL;
      except
        on e: EZSQLException do begin
		      ShowError(Application.MainForm, 'Невозможно инициализировать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;

      if NoError then begin
        FPMainDataset.SQL.Text := 'SELECT * FROM`' + CurPrefix + 'po`WHERE`index`=' + IntToStr(id);
        try
  	      FPMainDataset.Open;
          status := FPMainDataset.FieldByName('status').AsInteger;
          bycash := boolean(FPMainDataset.FieldByName('bycash').AsInteger);
          flink  := FPMainDataset.FieldByName('fond').AsString;
          suma   := FPMainDataset.FieldByName('suma').AsExtended;
        except
 	        on e: EZSQLException do begin
      	    ShowError(Self, 'Невозможно получить информацию о блокировке заявки.', e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end;

      // check if it's locked
      if NoError and (FPMainDataset.RecordCount > 0) and (not FPMainDataset.FieldByName('rsvdby').IsNull) then begin
        // and if it is
        FPTmpDataset.SQL.Text := 'SELECT FirstName,MiddleName,FamilyName FROM users WHERE UserID=:fUID';
        FPTmpDataset.ParamByName('fUID').AsInteger := FPMainDataset.FieldByName('rsvdby').AsInteger;
        try
          FPTmpDataset.Open;
        except
          on e: EZSQLException do begin
            ShowError(Self, 'При попытке получить данные о блокировке заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
         	  Exit;
          end;
        end;

        Application.MessageBox(PWideChar('С заявкой № ' + IntToStr(id) + ' работает пользователь ' +
                GetShortFIO(FPTmpDataset.FieldByName('FamilyName').AsString, FPTmpDataset.FieldByName('FirstName').AsString, FPTmpDataset.FieldByName('MiddleName').AsString) + CRLF + 'Повторите попытку позже.'), 'Работа с заявкой', MB_OK or MB_ICONERROR);

        FPMainDataset.SQL.Text := 'ROLLBACK';
        try
          FPMainDataset.ExecSQL;
        except
          on e: EZSQLException do begin
            ShowError(Self, 'При попытке разблокировки заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          end;
        end;
        // leave it
        Exit;
      end; // if NoError and (FPMainDataset.RecordCount > 0)

      // check if it's still "Approved" (not unapproved before by someone else of PAID already)
      if not (status in [PO_APROVED, PO_APROVED_UGNT]) then begin
        Application.MessageBox(PWideChar('Заявка № ' + IntToStr(id) + ' уже перешла в состояние "' + GetPOStatusName(status) + '", поэтому её одобрение отменить нельзя'), 'Ошибка отмены одобрения заявки', MB_OK or MB_ICONERROR);
        // Rollback it
        FPMainDataset.SQL.Text := 'ROLLBACK';
        try
          FPMainDataset.ExecSQL;
        except
          on e: EZSQLException do begin
            ShowError(Self, 'При попытке разблокировки заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          end;
        end;
        // leave it
        Exit;
      end;

      // return money to account if it was approved to disbursment cash
      if NoError and bycash then begin
        alink := GetAssetByFund(flink, CurPrefix);
        NoError := AssetsTransfer(CurPrefix + DISBCASH_LINK, alink, suma, 'Отмена одобрения заявки № ' + IntToStr(id), CurPrefix);
      end;

      if NoError then begin
        FPMainDataset.SQL.Text := 'UPDATE`' + CurPrefix + 'po`SET suma=NULL,status=:fStatus,Note=:fNote,signature=NULL,fond=NULL,fp=NULL WHERE`index`=:fID';
        if Pos('_urgent', StrGrid.Cells[0, StrGrid.Row]) > 0 then begin // it was an urgent PO
          FPMainDataset.ParamByName('fStatus').AsInteger := -1;
        end
        else begin
          FPMainDataset.ParamByName('fStatus').AsInteger := 0;
        end;
        FPMainDataset.ParamByName('fNote').AsString := 'Одобрение отменено ' + DateToStr(now);
        FPMainDataset.ParamByName('fID').AsInteger  := id;
        try
          FPMainDataset.ExecSQL;
        except
 				  on e: EZSQLException do begin
	  			  ShowError(Self, 'Невозможно отменить одобрение заявки.', e.ErrorCode, e.StatusCode, e.Message);
          	NoError := false;
          end;
        end;
      end;

      if NoError then begin
        FPMainDataset.SQL.Text := 'COMMIT';
  	    try
   	      FPMainDataset.ExecSQL;
        except
 	  	    on e: EZSQLException do begin
	    	    ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end; // if NoError
      if not NoError then begin
        FPMainDataset.SQL.Text := 'ROLLBACK';
      	try
 	        FPMainDataset.ExecSQL;
        except
 	  	    on e: EZSQLException do begin
	    	    ShowError(Self, 'Невозможно откатить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end; // if not NoError

      if NoError then begin
        Application.MessageBox('Отмена одобрения заявки прошла успешно.', PWideChar('Отмена одобрения заявки № ' + StrGrid.Cells[1, StrGrid.Row]), MB_ICONINFORMATION or MB_OK);
      	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
      end;
    end;
  end;
end;

procedure TMainFPForm.UserFormShow(Sender: TObject);
var
  UsersForm			: TUsersForm;
begin
  UsersForm := TUsersForm.Create(Self);
  UsersForm.UPrefix := CurPrefix;
  UsersForm.UOrgID	:= CurOInd;
  UsersForm.ToOtherOrgToolButton.Visible := PrivPresentMO(CurPrivs, 'b');
  UsersForm.InitForm;
  UsersForm.ShowModal;
  UsersForm.Free;
end;

procedure TMainFPForm.UTimerTimer(Sender: TObject);
begin
	UpdateEvent.SetEvent;
  UTimer.Enabled := false;
//  OutputDebugString('---- UpdatEvent set ---');
end;

procedure TMainFPForm.DCPopupAddClick(Sender: TObject);
var
	NoError	: boolean;
  DCPrefix  : string;
begin
 //
 	NoError := true;
  DebtorEditForm:= TDebtorEditForm.Create(nil);
  DebtorEditForm.NameEdit.Text := '';
  DebtorEditForm.PhoneEdit.Text := '';
  DebtorEditForm.ContactPersonEdit.Text := '';
  DebtorEditForm.DebtKindCombo.Visible	:= false;
  DebtorEditForm.DebtStatusCombo.Clear;
  if CurValue = LIST_DEBITORS then begin
	  DebtorEditForm.Caption := 'Новый дебетор';
  	DebtorEditForm.DebtStatusCombo.Items.Add('Новый');
	  DebtorEditForm.DebtStatusCombo.Items.Add('Надежный');
 		DebtorEditForm.DebtStatusCombo.Items.Add('Задерживает');
	  DebtorEditForm.DebtStatusCombo.Items.Add('Опасный');
  end
  else begin
	  DebtorEditForm.Caption := 'Новый кредитор';
		DebtorEditForm.DebtStatusCombo.Items.Add('Новый');
	  DebtorEditForm.DebtStatusCombo.Items.Add('Обычный');
	  DebtorEditForm.DebtStatusCombo.Items.Add('Беспокойный');
	  DebtorEditForm.DebtStatusCombo.Items.Add('Опасный');
  end;
  DebtorEditForm.DebtStatusCombo.ItemIndex := 0;
 	DebtorEditForm.Height		:= 200;
  DCPrefix  := CurPrefix;

  // Add to DebtKindCombo all the rest stuff
  if (DebtorEditForm.ShowModal = mrOk) then begin
    FPMainDataset.SQL.Text := 'START TRANSACTION';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'Ошибка при инициализацйии транзакции.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;

    if NoError then begin
 		  FPMainDataset.SQL.Text := 'INSERT INTO ';
      if CurValue = LIST_DEBITORS then
	   		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + DCPrefix + 'debtor '
      else
	 		  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + DCPrefix + 'creditor ';

   		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + '(`name`,`status`,`phone`,`who`)VALUES(:fName,:fStatus,:fPhone,:fWho)';
	    FPMainDataset.ParamByName('fName').AsString 		:= DebtorEditForm.NameEdit.Text;
  	  FPMainDataset.ParamByName('fStatus').AsString	:= IntToStr(DebtorEditForm.DebtStatusCombo.ItemIndex);
      FPMainDataset.ParamByName('fPhone').AsString		:= DebtorEditForm.PhoneEdit.Text;
	    FPMainDataset.ParamByName('fWho').AsString			:= DebtorEditForm.ContactPersonEdit.Text;
      try
      	FPMainDataset.ExecSQL;
      except
  	    on e: EZSQLException do begin
          ShowError(Self, 'Ошибка при сохранении данных о контрагенте.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
	      end;
      end;
    end;

    if NoError then begin
   		FPMainDataset.SQL.Text := 'COMMIT';
      try
      	FPMainDataset.ExecSQL;
      except
    	  on e: EZSQLException do begin
          ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
	    end;
    end;

    if NoError then begin
	  	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
    end;

    if not NoError then begin
   		FPMainDataset.SQL.Text := 'ROLLBACK';
      try
      	FPMainDataset.ExecSQL;
      except
    	  on e: EZSQLException do begin
          ShowError(Self, 'Ошибка при откате транзакции.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
	    end;
    end; // if not NoError ...
  end;
  DebtorEditForm.Free;
end;

procedure TMainFPForm.DCPopUpDelClick(Sender: TObject);
var
	ContrID	: integer;
  NoError	: boolean;
begin
//
	if not TryStrToInt(StrGrid.Cells[0, CurStrGridRow], ContrID) then
  	Exit;

	FPMainDataset.SQL.Text := 'SELECT`index`FROM ';
  if CurValue = LIST_DEBITORS then begin
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'tocollect '
  end
  else begin
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'topay ';
  end;
	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'WHERE ';
  if CurValue = LIST_DEBITORS then
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'debtor'
  else
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'creditor';
	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + '=:fContrID';
  FPMainDataset.ParamByName('fContrID').AsInteger	:= ContrID;
  FPMainDataset.Open;

  if FPMainDataset.RecordCount > 0 then begin
	  Application.MessageBox('Удалить эту запись нельзя, т.к. к ней привязаны задолженности', 'Удаление записи', MB_ICONINFORMATION or MB_OK);
    Exit;
  end;

  if not (mrYes = Application.MessageBox(PWideChar('Вы действительно хотите удалить контрагента "' + StrGrid.Cells[1, CurStrGridRow] + '"?'),
  											'Подтвердите удаление', MB_YESNO or MB_ICONWARNING)) then
		Exit;

  // delete entity from the base
  NoError := true;
  FPMainDataset.SQL.Text := 'DELETE FROM ';
  if CurValue = LIST_DEBITORS then begin
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'debtor '
  end
  else begin
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'creditor ';
  end;
  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'WHERE `index`=:fIndex';
  FPMainDataset.ParamByName('fIndex').AsInteger	:= ContrID;
  try
  	FPMainDataset.ExecSQL;
  except
  	on e:EZSQLException do begin
	    ShowError(Self, 'Ошибка при удалении данных о контрагенте.', e.ErrorCode, e.StatusCode, e.Message);
      NoError := false;
    end;
  end;
  if NoError then begin
		PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
  end;
end;

procedure TMainFPForm.DCPopUpListClick(Sender: TObject);
var
  TotSum				: extended;
  TotClosed			: extended;
  CurTotSum			: extended;
  CurTotClosed	: extended;
  i							: integer;
  LOrgPrefix    : string;
  sTbl          : string;
begin
//
	if CurStrGridRow < 1 then
  	Exit;

  TotSum 		:= 0;
  TotClosed	:= 0;
	DebtListForm := TDebtListForm.Create(Self);
  DebtListForm.Caption := 'Задолженности по контрагенту "' + StrGrid.Cells[1, CurStrGridRow] + '"';
  // setting up the main list
  DebtListForm.Width 	:= ReadIntParam(DebtListSection, 'W', 650);
  DebtListForm.Left 	:= ReadIntParam(DebtListSection, 'L', (Screen.WorkAreaWidth - DebtListForm.Width) div 2);
  DebtListForm.Height := ReadIntParam(DebtListSection, 'H', 400);
  DebtListForm.Top	 	:= ReadIntParam(DebtListSection, 'T', (Screen.WorkAreaHeight - DebtListForm.Height) div 2);
  DebtListForm.StrGrid.Align := alClient;
  DebtListForm.StrGrid.ColCount   := 8;
  DebtListForm.StrGrid.RowCount   := 2;
  DebtListForm.StrGrid.FixedRows  := 1;
  DebtListForm.StrGrid.ColWidths[0] := 0;
  DebtListForm.StrGrid.ColWidths[1] := ReadColWidth(DebtListSection, 1, 100);
  DebtListForm.StrGrid.ColWidths[2] := ReadColWidth(DebtListSection, 2, 100);
  DebtListForm.StrGrid.ColWidths[3] := ReadColWidth(DebtListSection, 3, 100);
  DebtListForm.StrGrid.ColWidths[4] := ReadColWidth(DebtListSection, 4, 100);
  DebtListForm.StrGrid.ColWidths[5] := ReadColWidth(DebtListSection, 5, 100);
  DebtListForm.StrGrid.ColWidths[6] := ReadColWidth(DebtListSection, 6, 100);
  DebtListForm.StrGrid.ColWidths[7] := ReadColWidth(DebtListSection, 7, 115);

  DebtListForm.StrGrid.ColumnHeaders.Clear;

  DebtListForm.StrGrid.ColumnHeaders.Add('');
  DebtListForm.StrGrid.ColumnHeaders.Add('Дата операции');
  DebtListForm.StrGrid.ColumnHeaders.Add('Описание');

  if CurValue = LIST_DEBITORS then
  	DebtListForm.StrGrid.ColumnHeaders.Add('Дата отгрузки')
  else
  	DebtListForm.StrGrid.ColumnHeaders.Add('Дата получения');

  DebtListForm.StrGrid.ColumnHeaders.Add('До даты');
  DebtListForm.StrGrid.ColumnHeaders.Add('Сумма');
  DebtListForm.StrGrid.ColumnHeaders.Add('Остаток');
  DebtListForm.StrGrid.ColumnHeaders.Add('Автор операции');

  // setting up coorect prefix
  LOrgPrefix := CurPrefix;

  // pulling data from DB
  i := 1;

  DebtListForm.StrGrid.Cells[0, i]  := 'h_red';
  DebtListForm.StrGrid.MergeCells(1, i, 6, 1);
  DebtListForm.StrGrid.Cells[1, i] := 'ПРОСРОЧЕННАЯ ЗАДОЛЖЕННОСТЬ';
  Inc(i);

  if CurValue = LIST_DEBITORS then
		sTbl:= '`' + LOrgPrefix + 'tocollect`'
  else
		sTbl:= '`' + LOrgPrefix + 'topay`';

	FPMainDataset.SQL.Text	:= 'SELECT';
	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + sTbl;
	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '.*,users.FamilyName,users.FirstName,users.MiddleName FROM ';
	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + sTbl;
  FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + 'LEFT JOIN`users`ON' + sTbl + '.UserID=`users`.UserID';
  FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + 'WHERE ';
  if CurValue = LIST_DEBITORS then
		FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '`debtor`=:fDebtorID'
  else
		FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '`creditor`=:fCreditorID';
	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + ' and `closed`>-1 and paydate<=NOW() ORDER BY `paydate`';
  if CurValue = LIST_DEBITORS then
	  FPMainDataset.ParamByName('fDebtorID').AsString := StrGrid.Cells[0, CurStrGridRow]
  else
	  FPMainDataset.ParamByName('fCreditorID').AsString := StrGrid.Cells[0, CurStrGridRow];
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    DebtListForm.StrGrid.Cells[0, i]  := 'red_' + FPMainDataset.FieldByName('index').AsString;
    DebtListForm.StrGrid.Cells[1, i]  := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
    DebtListForm.StrGrid.Cells[2, i]  := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
    DebtListForm.StrGrid.Cells[3, i]  := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);
    DebtListForm.StrGrid.Cells[4, i]  := DateToStr(FPMainDataset.FieldByName('paydate').AsDateTime, lFormatString);
    DebtListForm.StrGrid.Cells[5, i]  := MyFloatToStr(FPMainDataset.FieldByName('summ').AsFloat);
    DebtListForm.StrGrid.Cells[6, i]  := MyFloatToStr(FPMainDataset.FieldByName('summ').AsFloat - FPMainDataset.FieldByName('closed').AsFloat);
    DebtListForm.StrGrid.Cells[7, i]  := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);
	  TotSum 		:= TotSum + FPMainDataset.FieldByName('summ').AsFloat;
	  TotClosed	:= TotClosed + FPMainDataset.FieldByName('closed').AsFloat;

    Inc(i);
    FPMainDataset.Next
  end;

  DebtListForm.StrGrid.Cells[0, i]  := 'totred';
  DebtListForm.StrGrid.MergeCells(1, i, 5, 1);
  DebtListForm.StrGrid.Cells[1, i] := 'Итого просрочено:';
  DebtListForm.StrGrid.Cells[6, i]  := MyFloatToStr(TotSum - TotClosed);
  Inc(i);

  DebtListForm.StrGrid.Cells[0, i]  := 'h_green';
  DebtListForm.StrGrid.MergeCells(1, i, 6, 1);
  DebtListForm.StrGrid.Cells[1, i] := 'ТЕКУЩАЯ ЗАДОЛЖЕННОСТЬ';
  Inc(i);

  CurTotSum    := 0;
  CurTotClosed := 0;
	FPMainDataset.SQL.Text	:= 'SELECT';
	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + sTbl;
	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '.*,users.FamilyName,users.FirstName,users.MiddleName FROM ';
	FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + sTbl;
  FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + 'LEFT JOIN`users`ON' + sTbl + '.UserID=`users`.UserID';
  FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + 'WHERE ';
  if CurValue = LIST_DEBITORS then
		FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '`debtor`=:fDebtorID'
  else
		FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + '`creditor`=:fCreditorID';
  FPMainDataset.SQL.Text	:= FPMainDataset.SQL.Text + ' and `closed`>-1 and paydate>NOW() ORDER BY `paydate`';
  if CurValue = LIST_DEBITORS then
	  FPMainDataset.ParamByName('fDebtorID').AsString := StrGrid.Cells[0, CurStrGridRow]
  else
	  FPMainDataset.ParamByName('fCreditorID').AsString := StrGrid.Cells[0, CurStrGridRow];
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    DebtListForm.StrGrid.Cells[0, i]  := 'green_' + FPMainDataset.FieldByName('index').AsString;
    DebtListForm.StrGrid.Cells[1, i]  := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
    DebtListForm.StrGrid.Cells[2, i]  := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
    DebtListForm.StrGrid.Cells[3, i]  := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);
    DebtListForm.StrGrid.Cells[4, i]  := DateToStr(FPMainDataset.FieldByName('paydate').AsDateTime, lFormatString);
    DebtListForm.StrGrid.Cells[5, i]  := MyFloatToStr(FPMainDataset.FieldByName('summ').AsFloat);
    DebtListForm.StrGrid.Cells[6, i]  := MyFloatToStr(FPMainDataset.FieldByName('summ').AsFloat - FPMainDataset.FieldByName('closed').AsFloat);
    DebtListForm.StrGrid.Cells[7, i]  := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);
	  CurTotSum 		:= CurTotSum + FPMainDataset.FieldByName('summ').AsFloat;
	  CurTotClosed	:= CurTotClosed + FPMainDataset.FieldByName('closed').AsFloat;
    Inc(i);
    FPMainDataset.Next
  end;

  DebtListForm.StrGrid.Cells[0, i] := 'totgreen';
  DebtListForm.StrGrid.MergeCells(1, i, 5, 1);
  DebtListForm.StrGrid.Cells[1, i] := 'Итого текущая:';
  DebtListForm.StrGrid.Cells[6, i] := MyFloatToStr(CurTotSum - CurTotClosed );
  Inc(i);

  DebtListForm.StrGrid.Cells[0, i] := 'gt';
  DebtListForm.StrGrid.MergeCells(1, i, 5, 1);
  DebtListForm.StrGrid.Cells[1, i] := 'Общая задолженность:';
  DebtListForm.StrGrid.Cells[6, i] := MyFloatToStr(CurTotSum - CurTotClosed + TotSum - TotClosed);
  Inc(i);

  DebtListForm.StrGrid.RowCount := i;

  DebtListForm.ShowModal;
  DebtListForm.Free;
end;

procedure TMainFPForm.DCPopUpPropClick(Sender: TObject);
var
	ContrIndex	: integer;
  NoError			: boolean;
begin
	if TryStrToInt(StrGrid.Cells[0, StrGrid.Row], ContrIndex) then begin
  	NoError := true;
	  DebtorEditForm := TDebtorEditForm.Create(nil);
  	DebtorEditForm.Caption								:= 'Данные о контрагенте';
	  DebtorEditForm.NameEdit.Text 					:= StrGrid.Cells[1, StrGrid.Row];
  	DebtorEditForm.PhoneEdit.Text					:= StrGrid.Cells[2, StrGrid.Row];
	  DebtorEditForm.ContactPersonEdit.Text	:= StrGrid.Cells[3, StrGrid.Row];

  	DebtorEditForm.DebtKindCombo.Visible	:= false;
	  DebtorEditForm.DebtStatusCombo.Clear;
    if CurValue = LIST_DEBITORS then begin
	  	DebtorEditForm.DebtStatusCombo.Items.Add('Новый');
		  DebtorEditForm.DebtStatusCombo.Items.Add('Надежный');
  		DebtorEditForm.DebtStatusCombo.Items.Add('Задерживает');
		  DebtorEditForm.DebtStatusCombo.Items.Add('Опасный');
    end
    else begin
			DebtorEditForm.DebtStatusCombo.Items.Add('Новый');
		  DebtorEditForm.DebtStatusCombo.Items.Add('Обычный');
		  DebtorEditForm.DebtStatusCombo.Items.Add('Беспокойный');
		  DebtorEditForm.DebtStatusCombo.Items.Add('Опасный');
    end;
		DebtorEditForm.DebtStatusCombo.ItemIndex := DebtorEditForm.DebtStatusCombo.Items.IndexOf(StrGrid.Cells[4, StrGrid.Row]);
  	DebtorEditForm.Height		:= 200;


  	if DebtorEditForm.ShowModal = mrOK then begin
  		FPMainDataset.SQL.Text := 'UPDATE ';

      if CurValue = LIST_DEBITORS then begin
	  		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'debtor '
      end
      else begin
	  		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + CurPrefix + 'creditor ';
      end;

  		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'SET `name`=:fName,`status`=:fStatus,`phone`=:fPhone,`who`=:fWho WHERE `index`=:fIndex';
	    FPMainDataset.ParamByName('fName').AsString 		:= DebtorEditForm.NameEdit.Text;
    	FPMainDataset.ParamByName('fStatus').AsString		:= IntToStr(DebtorEditForm.DebtStatusCombo.ItemIndex);
    	FPMainDataset.ParamByName('fPhone').AsString		:= DebtorEditForm.PhoneEdit.Text;
	    FPMainDataset.ParamByName('fWho').AsString			:= DebtorEditForm.ContactPersonEdit.Text;
  	  FPMainDataset.ParamByName('fIndex').AsInteger		:= ContrIndex;
      try
      	FPMainDataset.ExecSQL;
      except
      	on e:EZSQLException do begin
  		    ShowError(Self, 'Ошибка при сохранении данных о контрагенте.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
	  end;
    if NoError then begin
		  StrGrid.Cells[1, StrGrid.Row]					:= DebtorEditForm.NameEdit.Text;
  		StrGrid.Cells[2, StrGrid.Row]					:= DebtorEditForm.PhoneEdit.Text;
	  	StrGrid.Cells[3, StrGrid.Row]					:= DebtorEditForm.ContactPersonEdit.Text;
			StrGrid.Cells[4, StrGrid.Row]					:= DebtorEditForm.DebtStatusCombo.Items[DebtorEditForm.DebtStatusCombo.ItemIndex];
      StrGrid.RepaintRow(StrGrid.Row);
    end;
  end;
  DebtorEditForm.Free;
end;

procedure TMainFPForm.DCPopUpSearchClick(Sender: TObject);
begin
//	ShowSearchFooter
  StrGrid.SearchPanel.EditControl.SetFocus;
end;

procedure TMainFPForm.DebtingButtonClick(Sender: TObject);
var
  DebtingForm: TDebtingForm;
  ColTblName   : string;
//  DebData : PContrData;
  i            : integer;
  j            : integer;
  CurOrgId     : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;

begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  DebtingForm := TDebtingForm.Create(nil);

  j            := 0;
  CurOrgId     := 0;
  // populating Orgs Combo
  DebtingForm.CurOrgPrefix := CurPrefix;
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      if PrivPresentMO(OrgData.descr, 'bw') and (not PrivPresentMO(OrgData.descr, 'a')) then begin
        New(ResData);
        ResData.name    := OrgData.name;
        ResData.prefix  := OrgData.prefix;
        ResData.index   := ORgData.index;
        DebtingForm.OrgsList.Add(ResData);
        DebtingForm.OrgCombo.Items.Add(ResData.name);
        if CurPrefix = ResData.prefix then
          CurOrgId := j;
        Inc(j);
      end
    end;
  end;

  if DebtingForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Произошла ошибка при построении списка организаций', 'Дебетование', MB_ICONINFORMATION or MB_OK);
    DebtingForm.Free;
    Exit;
  end
  else begin
    DebtingForm.OrgCombo.ItemIndex := CurOrgId;
    DebtingForm.OrgCombo.Enabled   := DebtingForm.OrgCombo.Items.Count > 1;
  end;

  if (DebtingForm.ShowModal = mrOk) then begin
    ColTblName := DebtingForm.CurOrgPrefix;

    ColTblName := ColTblName + 'tocollect';

    FPMainDataset.SQL.Text := 'INSERT INTO '+ ColTblName + '(`index`,`debtor`,`status`,`data`,`date`,`shipdate`,`paydate`,`summ`,`closed`,`lastdate`';
{$IFDEF USERID}
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,:fDebtor,"0",:fDescr,NOW(),:fShipDate,:fPayDate,:fSum,0,NULL';
{$IFDEF USERID}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';

    FPMainDataset.ParamByName('fDebtor').AsInteger  := PContrData(DebtingForm.DebCredCombo.Items.Objects[DebtingForm.DebCredCombo.ItemIndex]).index;
    FPMainDataset.ParamByName('fDescr').AsString    := DebtingForm.DescrMemo.Text;
    FPMainDataset.ParamByName('fShipDate').AsDate   := DebtingForm.ShipDt.Date;
    FPMainDataset.ParamByName('fPayDate').AsDate    := DebtingForm.Dt.Date;
    FPMainDataset.ParamByName('fSum').AsFloat       := DebtingForm.AmountEdit.Value;
{$IFDEF USERID}
		FPMainDataset.ParamByName('fUserID').AsInteger := FPUserID;
{$ENDIF}
    try
      FPMainDataset.ExecSQL;
    except
		  on e: EZSQLException do begin
	  	  ShowError(Self, 'Во время добавления данных произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
		    ModalResult := mrCancel;
    		Exit;
      end;
    end;
  end;

  DebtingForm.Free;

  FPMainDataset.SQL.Text := 'COMMIT';
  try
    FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
	    ShowError(Self, 'Невозможно завершить транзакцию. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
		  ModalResult := mrCancel;
    	Exit;
    end;
  end;

  if (CurValue = BRANCH_DEBITORS) or (CurValue = LIST_DEBITORS) then
  	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.DelPOPopUpClick(Sender: TObject);
var
  id : integer;
  NoError : boolean;
begin
  id := 0;
  NoError := true;
  if (StrGrid.Row < StrGrid.RowCount) and (TryStrToInt(StrGrid.Cells[1, StrGrid.Row], id)) and (id > 0) then begin
    if Application.MessageBox(PWideChar('Вы действительно хотите удалить заявку № ' + StrGrid.Cells[1, StrGrid.Row] +  '?'), PWideChar('Удаление заявки № ' + StrGrid.Cells[1, StrGrid.Row]), MB_ICONWARNING or MB_YESNO) = mrYes then begin
// setting up transaction
      FPMainDataset.SQL.Text := 'BEGIN';
      try
        FPMainDataset.ExecSQL;
      except
        on E: EZSQLException do begin
          ShowError(Self, 'Сбой при инициализации транзакции.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;

      if NoError then begin
        FPTmpDataset.SQL.Text := 'SELECT * FROM`' + CurPrefix + 'po`WHERE`index`=' + IntToStr(id);
        try
  	      FPTmpDataset.Open;
        except
 	        on e: EZSQLException do begin
      	    ShowError(Self, 'Невозможно получить информацию о блокировке заявки.', e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end;

      // check if it's locked
      if NoError and (FPTmpDataset.RecordCount > 0) and (not FPTmpDataset.FieldByName('rsvdby').IsNull) then begin
        // and if it is
        FPMainDataset.SQL.Text := 'SELECT FirstName,MiddleName,FamilyName FROM users WHERE UserID=:fUID';
        FPMainDataset.ParamByName('fUID').AsInteger := FPTmpDataset.FieldByName('rsvdby').AsInteger;
        try
          FPMainDataset.Open;
        except
          on e: EZSQLException do begin
            ShowError(Self, 'При попытке получить данные о блокировке заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
         	  Exit;
          end;
        end;

        Application.MessageBox(PWideChar('С заявкой № ' + IntToStr(id) + ' работает пользователь ' +
                GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString,FPMainDataset.FieldByName('MiddleName').AsString) + CRLF + 'Повторите попытку позже.'), 'Работа с заявкой', MB_OK or MB_ICONERROR);

        FPMainDataset.SQL.Text := 'ROLLBACK';
        try
          FPMainDataset.ExecSQL;
        except
          on e: EZSQLException do begin
            ShowError(Self, 'При попытке разблокировки заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          end;
        end;
        // leave it
        Exit;
      end; // if NoError and (FPMainDataset.RecordCount > 0)

      // dropping PO
      if NoError then begin
        FPMainDataset.SQL.Text := 'DELETE FROM`' + CurPrefix + 'po`WHERE`index`=:fPOID';
        FPMainDataset.ParamByName('fPOID').AsInteger  := id;
        try
          FPMainDataset.ExecSQL;
        except
   				on e: EZSQLException do begin
	    			ShowError(Self, 'При удалении заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          	NoError := false;
          end;
        end;
      end;  // if NoError

      // dropping attachments
      if NoError then begin
        FPMainDataset.SQL.Text := 'DELETE FROM`' + CurPrefix + 'poatt`WHERE`PONum`=:fPOID';
        FPMainDataset.ParamByName('fPOID').AsInteger  := id;
        try
          FPMainDataset.ExecSQL;
        except
   				on e: EZSQLException do begin
	    			ShowError(Self, 'При удалении заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          	NoError := false;
          end;
        end;
      end; // if NoError

      if NoError then begin
        FPMainDataset.SQL.Text := 'COMMIT';
  	    try
   	      FPMainDataset.ExecSQL;
        except
 	  	    on e: EZSQLException do begin
	    	    ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end; // if NoError
      if not NoError then begin
        FPMainDataset.SQL.Text := 'ROLLBACK';
      	try
 	        FPMainDataset.ExecSQL;
        except
 	  	    on e: EZSQLException do begin
	    	    ShowError(Self, 'Невозможно откатить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end; // if not NoError

      if NoError then begin
        Application.MessageBox(PWideChar('Заявка № ' + StrGrid.Cells[1, StrGrid.Row] + ' удалена.'), 'Удаление заявки.', MB_ICONINFORMATION or MB_OK);
      	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
      end;
    end;
  end;
end;

procedure TMainFPForm.DirIncSourcesClick(Sender: TObject);
var
  IncomeSourcesForm : TIncomeSourcesForm;
  i            : integer;
  j            : integer;
  CurOrgId     : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;
begin
  IncomeSourcesForm := TIncomeSourcesForm.Create(nil);
  j            := 0;
  CurOrgId     := 0;
  // populating Orgs Combo
  IncomeSourcesForm.ISPrefix := CurPrefix;
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      if PrivPresentMO(OrgData.descr, 'bf') and (not PrivPresentMO(OrgData.descr, 'a')) then begin
        New(ResData);
        ResData.name    := OrgData.name;
        ResData.prefix  := OrgData.prefix;
        ResData.index   := ORgData.index;
        IncomeSourcesForm.OrgsList.Add(ResData);
        IncomeSourcesForm.OrgCombo.Items.Add(ResData.name);
        if CurPrefix = ResData.prefix then
          CurOrgId := j;
        Inc(j);
      end
    end;
  end;

  if IncomeSourcesForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Источники дохода', MB_ICONINFORMATION or MB_OK);
    IncomeSourcesForm.Free;
    Exit;
  end
  else begin
    IncomeSourcesForm.OrgCombo.ItemIndex  := CurOrgId;
    IncomeSourcesForm.OrgCombo.Enabled := IncomeSourcesForm.OrgCombo.Items.Count > 1;
  end;

  IncomeSourcesForm.ShowModal;
  IncomeSourcesForm.Free;
end;

procedure TMainFPForm.DisbToolButtonClick(Sender: TObject);
var
  DisbForm : TDisbForm;
  i        : integer;
  j        : integer;
  CurOrgId : integer;
  OrgData  : PVTResourceData;
  ResData  : PVTResourceData;

begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  DisbForm  := TDisbForm.Create(Self);
  j            := 0;
  CurOrgId     := 0;
  // populating Orgs Combo
  DisbForm.CurDPrefix := CurPrefix;
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      if PrivPresentMO(OrgData.descr, 'bf') then begin
        New(ResData);
        ResData.name    := OrgData.name;
        ResData.prefix  := OrgData.prefix;
        ResData.index   := ORgData.index;
        DisbForm.OrgsList.Add(ResData);
        DisbForm.OrgCombo.Items.Add(ResData.name);
        if CurPrefix = ResData.prefix then
          CurOrgId := j;
        Inc(j);
      end
    end;
  end;

  if DisbForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Расход', MB_ICONINFORMATION or MB_OK);
    DisbForm.Free;
    Exit;
  end
  else begin
    DisbForm.OrgLabel.Top     := DisbForm.DtLabel.Top;
    DisbForm.OrgLabel.Left    := DisbForm.DtLabel.Left;
    DisbForm.OrgCombo.Top     := DisbForm.POCombo.Top;
    DisbForm.OrgCombo.Left    := DisbForm.Dt.Left - 15;
    DisbForm.Dt.Visible       := false;
    DisbForm.DtLabel.Visible  := false;

    DisbForm.OrgCombo.ItemIndex  := CurOrgId;
    DisbForm.OrgCombo.Enabled := DisbForm.OrgCombo.Items.Count > 1;
  end;

  DisbForm.ShowModal;
  PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
  DisbForm.Free;
end;

procedure TMainFPForm.FilterOutByArbPeriodBtnClick(Sender: TObject);
begin
	ArbTimeFilter := true;
	FixedTimeFilter := false;
	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.FilterOutByFixedPeriodBtnClick(Sender: TObject);
begin
	FixedTimeFilter := true;
	ArbTimeFilter 	:= false;
	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.FLPopShowPOsClick(Sender: TObject);
var
	FundvsPOsForm: TFundvsPOsForm;
begin
	FundvsPOsForm := TFundvsPOsForm.Create(nil);
  FundvsPOsForm.CurFundName := StrGrid.Cells[1, StrGrid.Row];
  FundvsPOsForm.OPrefix     := CurPrefix;
	FundvsPOsForm.ShowModal;
	FundvsPOsForm.Free;
end;

procedure TMainFPForm.OnAppActivate(Sender: TObject);
begin
  if Application.Active then begin
    if Assigned(FPForm) and (Assigned(FPForm.FPFLF))  then begin
      SetWindowPos(FPForm.FPFLF.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOMOVE + SWP_NOSIZE);
    end;
  end
end;

procedure TMainFPForm.OnAppDeactivate(Sender: TObject);
begin
  if not Application.Active then begin
    if Assigned(FPForm) and (Assigned(FPForm.FPFLF)) then begin
      SetWindowPos(FPForm.FPFLF.Handle, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOMOVE + SWP_NOSIZE);

      Application.ProcessMessages;
    end;
  end
end;

procedure TMainFPForm.OnFPAllocFormClosed(var Msg: TMessage);
begin
  if Assigned(FPForm) then begin
    FPForm.Free;
    FPForm := nil;
  end;
  SetWindowPos(Self.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE);
end;

procedure TMainFPForm.OnFundTransferred(var Msg: TMessage);
begin
  if Assigned(FPForm) then begin
    SendMessage(FPForm.Handle, UM_FUNDTRANSFERRED, 0, 0);
  end;
end;

procedure TMainFPForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FPForm) then begin
    if not FPForm.CloseQuery then begin
      Action := caNone;
      SetWindowPos(FPForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE);
    end;
  end
  else begin
    inherited;
  end;
end;

procedure TMainFPForm.FormCreate(Sender: TObject);
var
  // filtering stuff
  POColFiltersArray : PColFilters;
  pfo     : TFilterObject;
  i : integer;
begin

	m_bInitComleted := false;
  MainGridIsBeingUpdated:= false;

{$IFDEF PROJECTISDLL}
  sSkinManager1.Active := true;
{$ENDIF}
  FondList := TList.Create;

  ImgsToPrint	:= TList.Create;

  lFormatString.TimeSeparator   := ':';
	lFormatString.LongDateFormat  := 'DD.MM.YY';
	lFormatString.ShortDateFormat	:= 'DD.MM.YY';
	lFormatString.ShortTimeFormat := 'HH:MM:SS';
	lFormatString.LongTimeFormat  := 'HH:MM:SS';

  SQLFormatString.DecimalSeparator := '.';
	SQLFormatString.LongDateFormat  := 'YYYYMMDD';
	SQLFormatString.ShortDateFormat	:= 'YYYYMMDD';

	StrGrid.FixedColor := clSpecBkColor;
	MainGroupSplitterMoved(Sender);

	FmtList := TStringList.Create;
{$IFNDEF ORGWIZ}
  NewOrgWizButton.Visible := false;
{$ENDIF}
  Application.OnDeactivate := OnAppDeActivate;
  Application.OnActivate   := OnAppActivate;

{$IFNDEF DLLNOTHREADS}
  SaverThread  := nil;
  UpdateThread := nil;
  RemoverThread := nil;
{$ENDIF}

// filtering stuff
	POFilters := TStringList.Create;

	new(POColFiltersArray);
  SetLength(POColFiltersArray^, 11);
  POFilters.AddObject(rsSubdPOFilterRow, pointer(POColFiltersArray));

	new(POColFiltersArray);
  SetLength(POColFiltersArray^, 11);
  POFilters.AddObject(rsRejdPOFilterRow, pointer(POColFiltersArray));

	new(POColFiltersArray);
  SetLength(POColFiltersArray^, 11);
  POFilters.AddObject(rsAppdPOFilterRow, pointer(POColFiltersArray));

	new(POColFiltersArray);
  SetLength(POColFiltersArray^, 11);
  POFilters.AddObject(rsPaidPOFilterRow, pointer(POColFiltersArray));
end;

procedure TMainFPForm.StopThreads;
begin
  // UpdateThread termination
  if Assigned(UpdateThread) then begin
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Update thread - trying to stop it - 2');
{$ENDIF}
    UpdateThread.Terminate;
    UpdateEvent.SetEvent;
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Update thread - "Exitnow" value set up 2');
{$ENDIF}
	  WaitForSingleObject(UpdateThread.Handle, 5000);
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Update thread - left 2');
{$ENDIF}
    UpdateThread := nil;
  end;

{$IFDEF TLOG}
//  PushToDBThread,
{$ENDIF}

  // Saver thread stop
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Saver thread - trying to stop it 2');
{$ENDIF}
  if Assigned(SaverThread) then begin
  	SaverThread.Terminate;
    AttSaveEvent.SetEvent;
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Saver thread - event set -- up 2');
{$ENDIF}
	  WaitForSingleObject(SaverThread.Handle, INFINITE);
    SaverThread := nil;
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Saver thread - left 2');
{$ENDIF}
  end
  else begin
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Saver thread - it is already nil. 2');
{$ENDIF}
  end;

  // remover thread sptopping
  if Assigned(RemoverThread) then begin
  	RemoverThread.Terminate;
    AttRemoveEvent.SetEvent;
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Remover thread - event set -- up 2');
{$ENDIF}
	  WaitForSingleObject(RemoverThread.Handle, INFINITE);
    RemoverThread := nil;
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Remover thread - left 2');
{$ENDIF}
  end
  else begin
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Remover thread - it is already nil. 2');
{$ENDIF}
  end;

end;

procedure TMainFPForm.FormDestroy(Sender: TObject);
begin
{$IFDEF PROJECTISDLL}
  sSkinManager1.Active := false;
  sSkinProvider1 := nil;
  sSkinManager1 := nil;
{$ENDIF}

  StopThreads;

	// synchronization objects initialization
  AttNeededEvent.Destroy;
  AttNeededCS.Destroy;
  LoadingAttsCS.Destroy;
	FmtList.Free;

{$IFDEF PROJECTISDLL}
  FPConnection := nil;
{$ENDIF}
end;

procedure TMainFPForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	inherited;
end;

procedure TMainFPForm.FormShow(Sender: TObject);
begin

  // setting up USERTMPFOLDER to store temp files
	USERTMPFOLDER := GetEnvironmentVariable('TEMP');
  if(USERTMPFOLDER = '') then USERTMPFOLDER := GetEnvironmentVariable('TMP');
  if(USERTMPFOLDER = '') then USERTMPFOLDER := APPDATAFOLDER;
  USERTMPFOLDER := USERTMPFOLDER + AppName + '_' + oid;
  if not DirectoryExists(USERTMPFOLDER) then begin
    if not CreateDir(USERTMPFOLDER) then begin
			ShowError(Self, 'Невозможно создать каталог для хранения временных файлов.', 0, oid, '');
    end;
  end;

  USERTMPFOLDER := USERTMPFOLDER + '\' + FPLogin;
  if not DirectoryExists(USERTMPFOLDER) then begin
    if not CreateDir(USERTMPFOLDER) then begin
			ShowError(Self, 'Невозможно создать каталог для хранения временных файлов.', 0, FPLogin, '');
    end;
  end;

	ShowHideArchedFunds;

	ShowSearchFooter;
  SetFilerToolbarObjectsEnabled;
	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);

{$IFNDEF DLLNOTHREADS}

	SaverThread	:= TAttSaverThread.Create(true);
  SaverThread.Priority				:= tpLower;
  SaverThread.FreeOnTerminate	:= true;

  SaverThread.ASConnection	:= FPConnection;
  SaverThread.Resume;

	RemoverThread := TAttRemoverThread.Create(true);
  RemoverThread.Priority				:= tpLower;
  RemoverThread.FreeOnTerminate	:= true;
  RemoverThread.Resume;

{$ENDIF}

  MFPF := Self;
  RTimer.Interval := (cto div 5) * 4;
	m_bInitComleted := true;
	UTimer.Interval := 5000;
  UTimer.Enabled  := true;

end;


{$IFDEF TLOG}
procedure TMainFPForm.LogPullTimerTimer(Sender: TObject);
begin
	InitLogPull;
end;

procedure TMainFPForm.OnLogPullFinished(var Msg: TMessage);
begin
  Exit; //febdebug
  LogPullTimer.Enabled := true;
end;

procedure TMainFPForm.InitLogPull;
begin
  Exit; //febdebug
	LogPullTimer.Enabled := false;
  LoadLogEvent.SetEvent;
  //OutputDebugString('= LoadLogEvent.SetEvent ... =');
end;
{$ENDIF}

procedure TMainFPForm.IncomeInvoicingBtnClick(Sender: TObject);
var
  IEF: TIncomeEnteringForm;
  i   : integer;
  OrgData : PVTResourceData;
  ResData : PVTResourceData;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  IEF := TIncomeEnteringForm.Create(Self);
  IEF.Caption := 'Приходование поступивших средств';

  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      if PrivPresentMO(OrgData.descr, 'bd') and (not PrivPresentMO(OrgData.descr, 'a')) then begin
        New(ResData);
        ResData.name    := OrgData.name;
        ResData.prefix  := OrgData.prefix;
        ResData.index   := ORgData.index;
        IEF.OrgsList.Add(ResData);
        IEF.OrgCombo.Items.Add(ResData.name);
      end
    end;
  end;

  if IEF.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Приходование средств', MB_ICONINFORMATION or MB_OK);
    IEF.Free;
    Exit;
  end
  else begin
    IEF.OrgCombo.ItemIndex  := 0;
    if IEF.OrgCombo.Items.Count = 1 then begin
      IEF.OrgCombo.Enabled := false;
//      IEF.OrgLabel.Visible  := false;
    end
  end;

  IEF.DescrMemo.Clear;
  IEF.OKButton.Enabled := false;
  IEF.ShowModal;
  IEF.Free;
  PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.IncomeSourcesButtonClick(Sender: TObject);
var
  IncomeSourcesForm : TIncomeSourcesForm;
  i            : integer;
  j            : integer;
  CurOrgId     : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

	IncomeSourcesForm := TIncomeSourcesForm.Create(nil);
  j            := 0;
  CurOrgId     := 0;
  // populating Orgs Combo
  IncomeSourcesForm.ISPrefix := CurPrefix;
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      if PrivPresentMO(OrgData.descr, 'by') and (not PrivPresentMO(OrgData.descr, 'a')) then begin
        New(ResData);
        ResData.name    := OrgData.name;
        ResData.prefix  := OrgData.prefix;
        ResData.index   := ORgData.index;
        IncomeSourcesForm.OrgsList.Add(ResData);
        IncomeSourcesForm.OrgCombo.Items.Add(ResData.name);
        if CurPrefix = ResData.prefix then
          CurOrgId := j;
        Inc(j);
      end
    end;
  end;

  if IncomeSourcesForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Источники дохода', MB_ICONINFORMATION or MB_OK);
    IncomeSourcesForm.Free;
    Exit;
  end
  else begin
    IncomeSourcesForm.OrgCombo.ItemIndex  := CurOrgId;
    IncomeSourcesForm.OrgCombo.Enabled := IncomeSourcesForm.OrgCombo.Items.Count > 1;
  end;

	IncomeSourcesForm.ShowModal;
	IncomeSourcesForm.Free;
end;

procedure TMainFPForm.MainGroupSplitterMoved(Sender: TObject);
begin
	MainTree.Header.Columns[0].Width := MainTree.ClientWidth - MainTree.Header.Columns[1].Width;
end;

procedure TMainFPForm.MainMenuItemExitClick(Sender: TObject);
begin
	Close;
end;

procedure TMainFPForm.MainTreeCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
	SaveNodeState(Node);
end;

procedure TMainFPForm.MainTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1   : PVTResourceData;
  Data2   : PVTResourceData;
begin
//
  Data1   := Sender.GetNodeData(Node1);
  Data2   := Sender.GetNodeData(Node2);

	Result := CompareText(Data1.name,Data2.Name);
end;

procedure TMainFPForm.MainTreeDblClick(Sender: TObject);
var
	CNode       : PVirtualNode;
  CNodeData   : PVTResourceData;
  tmpStr 			: string;
  dtvTmp      : TDateTime;
  StrFPNum   	: string;
  TmpCurValue	: integer;
  TmpCurTable	: string;
  TmpCurPrefix	: string;
  NoError     : boolean;
  FPisRO      : boolean;
  Stream 			: TMemoryStream; // for copying income plan
begin

  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  CNode := MainTree.GetFirstSelected;
  CurNode := CNode;
  if CNode <> nil then begin
    CurPrivs := GetOPrivs(CNode);
//    ResetToolBar(CurPrivs);
      if IsIt(RNodesArr, CNode) then begin
//      ShowMessage('Главный');
      CurValue := 2;
      CurTable := 'root';
      CNodeData := MainTree.GetNodeData(CNode);
      GridGroupBox.Caption := CNodeData.name;
      if PrivPresentMO(CurPrivs, 'a') then begin
        CurValue := BRANCH_POS;
        CurTable := '';
      end;
		  CurPrefix := CNodeData.prefix;
    	CurOInd		:= CNodeData.ipref;
		  SendMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
    end
    else begin
	    CNodeData := MainTree.GetNodeData(CNode);
  	  TmpCurValue := CNodeData.page;
 	  	TmpCurTable := CNodeData.link;
		  TmpCurPrefix:= CNodeData.prefix;
      if CNodeData.page = 10 then begin                                  // user access node
  		  CurPrefix := TmpCurPrefix;
        CurOInd		:= CNodeData.ipref;
				UserFormShow(Sender);
      end
      else if TmpCurValue = BRANCH_PERSONS then begin
	      CurValue 	:= LIST_PERSONS;
        CurTable	:= 'root';
      	CurPrefix := CNodeData.prefix;
        CurOInd		:= CNodeData.ipref;
			  PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
      end
      else if TmpCurValue = BRANCH_FP then begin
   		  CurPrefix := TmpCurPrefix;
        CurOInd		:= CNodeData.ipref;
      	if CNodeData.sub in [FPNOTAPPROVED, FPARCHIVED] then begin
          FPNum	 := CNodeData.index;
          if Assigned(FPForm) then begin
            if Application.MessageBox('Форма распределения для финансового планирования уже открыта. Переключиться на форму?', 'Финансовое планирование', MB_YESNO or MB_ICONWARNING) = mrYES then begin
                SetWindowPos(FPForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE);
            end;
            Exit;
          end
          else begin  // we have to check wether the necessary FP locked by someone else
            FPisRO  := CNodeData.sub = FPARCHIVED; // if FP was approved already - we don't need to lock it
            NoError := true;
            if not FPisRO then begin
              // checking wether it's locked already
    				  FPMainDataset.SQL.Text := 'BEGIN';
              try
    	  			  FPMainDataset.ExecSQL;
              except
                on e: EZSQLException do begin
      	  	      ShowError(Self, 'Ошибка при инициализации транзакции.', e.ErrorCode, e.StatusCode, e.Message);
                  NoError := false;
                end;
              end;
            end; // if not FPisRO ...

            // checking wether it's locked already
            if (not FPisRO) and NoError then begin
    				  FPMainDataset.SQL.Text := 'SELECT rsvdby FROM`' + CurPrefix + 'fp`WHERE`index`=:fFPID';
              FPMainDataset.ParamByName('fFPID').AsInteger := FPNum;
              try
    	  			  FPMainDataset.Open;
              except
                on e: EZSQLException do begin
      	  	      ShowError(Self, 'При попытке блокировки ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    	          	NoError := false;
                end;
              end;
            end; // if NoError then begin

            if (not FPisRO) and NoError and (FPMainDataset.RecordCount > 0) and (not FPMainDataset.FieldByName('rsvdby').IsNull) then begin
      				FPTmpDataset.SQL.Text := 'SELECT FirstName,MiddleName,FamilyName FROM users WHERE UserID=:fUID';
              FPTmpDataset.ParamByName('fUID').AsInteger := FPMainDataset.FieldByName('rsvdby').AsInteger;
              try
                FPTmpDataset.Open;
              except
                on e: EZSQLException do begin
      	    	    ShowError(Self, 'При попытке получить данные о блокировке ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    	          	Exit;
                end;
              end;
              Application.MessageBox(PWideChar('Финансовое планирование № ' + IntToStr(FPNum) + ' уже открыто пользователем ' +
                GetShortFIO(FPTmpDataset.FieldByName('FamilyName').AsString, FPTmpDataset.FieldByName('FirstName').AsString,FPTmpDataset.FieldByName('MiddleName').AsString) + CRLF + 'Повторите попытку позже.'), 'Финансовое планирование', MB_OK or MB_ICONERROR);

              FPMainDataset.SQL.Text := 'ROLLBACK';
              try
    	  			  FPMainDataset.ExecSQL;
              except
                on e: EZSQLException do begin
      	  	      ShowError(Self, 'При попытке разблокировки ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
                end;
              end;
              // leave it
              Exit;
            end; // if NoError and (FPMainDataset.RecordCount > 0)

            // checking for locked POs
            if (not FPisRO) and NoError then begin
    				  FPMainDataset.SQL.Text := 'SELECT`index`,`rsvdby`FROM`' + CurPrefix + 'po`WHERE`status`<=0 AND rsvdby IS NOT NULL';
              try
                FPMainDataset.Open;
              except
                on e: EZSQLException do begin
      	    	    ShowError(Self, 'Произошла ошибка при проверке заблокированных заявок.', e.ErrorCode, e.StatusCode, e.Message);
    	          	NoError := false;
                end;
              end;
            end;

            if (not FPisRO) and NoError then begin
              if FPMainDataset.RecordCount > 0 then begin
                tmpStr := '';
                while not FPMainDataset.Eof do begin
          				FPTmpDataset.SQL.Text := 'SELECT FirstName,MiddleName,FamilyName FROM users WHERE UserID=:fUID';
                  FPTmpDataset.ParamByName('fUID').AsInteger := FPMainDataset.FieldByName('rsvdby').AsInteger;
                  try
                    FPTmpDataset.Open;
                  except
                    on e: EZSQLException do begin
      	        	    ShowError(Self, 'При попытке получить данные о блокировке ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
        	          	NoError := false;
    	              	break;
                    end;
                  end;
                  tmpStr := tmpStr + FPMainDataset.FieldByName('index').AsString + ' : ' +
                              GetShortFIO(FPTmpDataset.FieldByName('FamilyName').AsString, FPTmpDataset.FieldByName('FirstName').AsString,FPTmpDataset.FieldByName('MiddleName').AsString) + CRLF;
                  FPMainDataset.Next;
                end;

                if NoError and (tmpStr <> '') then begin
                  tmpStr := 'Список заявок и пользователей, работающих с этими заявками в настоящий момент:' + CRLF + tmpStr;
                  ShowError(Self, 'Нельзя открыть ФП № ' + IntToStr(FPNum) + ', т.к. некоторые заявки находятся в работе.', 0, '', tmpStr);
        	        NoError := false;
                end
              end;
            end;

            if (not FPisRO) and NoError then begin // if FP is not locked then we lock it (if it's not ReadOnly of course)
    				  FPMainDataset.SQL.Text := 'UPDATE`' + CurPrefix + 'fp`SET rsvdby=:fUID,dtby=DATE_ADD(NOW(),INTERVAL 1 MINUTE)WHERE`index`=:fFPID';
              FPMainDataset.ParamByName('fUID').AsInteger  := FPUserID;
              FPMainDataset.ParamByName('fFPID').AsInteger := FPNum;
              try
                FPMainDataset.ExecSQL;
              except
                on e: EZSQLException do begin
      	    	    ShowError(Self, 'Произошла ошибка при блокировке ФП.', e.ErrorCode, e.StatusCode, e.Message);
    	          	NoError := false;
                end;
              end;
            end;

            if (not FPisRO) and NoError then begin // lock proper POs
    				  FPMainDataset.SQL.Text := 'UPDATE`' + CurPrefix + 'po`SET rsvdby=:fUID,dtby=DATE_ADD(NOW(),INTERVAL 1 MINUTE)WHERE`status`<=0';
              FPMainDataset.ParamByName('fUID').AsInteger  := FPUserID;
              try
                FPMainDataset.ExecSQL;
              except
                on e: EZSQLException do begin
      	    	    ShowError(Self, 'Произошла ошибка при блокировке заявок.', e.ErrorCode, e.StatusCode, e.Message);
    	          	NoError := false;
                end;
              end;
            end;

            if (not FPisRO) and NoError then begin // final Commit or rollback
    				  FPMainDataset.SQL.Text := 'COMMIT';
              try
                FPMainDataset.ExecSQL;
              except
                on e: EZSQLException do begin
      	    	    ShowError(Self, 'При попытке завершении транзакции произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    	          	NoError := false;
                end;
              end;
            end;

            if(not FPisRO) and (not NoError) then begin
    				  FPMainDataset.SQL.Text := 'ROLLBACK';
              try
                FPTmpDataset.ExecSQL;
              except
//                on e: EZSQLException do begin
//      	    	    ShowError(Self, 'При попытке получить данные о блокировке ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
//                end;
              end;
    	        Exit; // return in any case
            end;
          end;

				  FPForm := TFPAllocForm.Create(Self);
				  FPForm.PWin      := Self;
				  FPForm.ReadOnly	 := FPisRO; //CNodeData.sub = FPARCHIVED;
          FPForm.OrgPrefix := CNodeData.prefix;
          FPForm.FPPrivs   := CurPrivs;
          FPForm.Fndr      := PrivPresentMO(CurPrivs, 'b0');
          FPForm.iOrgPrefix:= CNodeData.ipref;

					if FPForm.ReadOnly then
				  	FPForm.InitArcDB
				  else
					  FPForm.InitDB;

				  FPForm.Show;
        end // if CNodeData.sub in [FPNOTAPPROVED, FPARCHIVED] then begin
        else if CNodeData.sub = FPNEWFPTOCREATE then begin // Creating new FP
          if not PrivPresentMO(CurPrivs, 'bo') then begin
            Exit;
          end;

					FormatString.DateSeparator := '-';
  				NewFPForm := TNewFPForm.Create(nil);
				  FPMainDataset.SQL.Text := 'SELECT * FROM ' + CurPrefix + 'fp ORDER BY`index`DESC LIMIT 1';
          try
  				  FPMainDataset.Open;
          except
            on e: EZSQLException do begin
      		    ShowError(Self, 'При инициализации ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    	      	Exit;
            end;
          end;
				  if not FPMainDataset.IsEmpty then begin
				    if FPMainDataset.FieldByName('to').AsString = '' then begin
				      StrFPNum := FPMainDataset.FieldByName('index').AsString;
				      CurFPNum := StrToInt(StrFPNum);
				      NewFPForm.NumEdit.Text := StrFPNum;

				      dtvTmp := FPMainDataset.FieldByName('from').AsDateTime;

				      NewFPForm.StartDateEdit.Date    := dtvTmp;
				      NewFPForm.StartTimePicker.Time  := dtvTmp;
				      NewFPForm.EndDateEdit.Date      := NewFPForm.StartDateEdit.Date + 7;
				      NewFPForm.EndTimePicker.Time    := NewFPForm.StartTimePicker.Time;
              NewFPForm.sLabel1.Color					:= clWhite;

				      if NewFPForm.ShowModal = mrOk then begin
				        dtvTmp := NewFPForm.EndDateEdit.Date + NewFPForm.EndTimePicker.Time;
        				FPMainDataset.SQL.Text := 'UPDATE`' + CurPrefix + 'fp`SET`to`=:ftd WHERE`index`=' + StrFPNum;
                FPMainDataset.ParamByName('ftd').AsDateTime := dtvTmp;
                try
           				FPMainDataset.ExecSQL;
                except
                  on e: EZSQLException do begin
            		    ShowError(Self, 'При инициализации ФП произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
        	        	Exit;
                  end;
                end;

                // copy last income plan if needed
                if NewFPForm.ckbCopyIncPlan.Checked then begin
									Stream := TMemoryStream.Create;
								  FPTmpDataset.SQL.Text := 'SELECT plan FROM`' + CurPrefix + 'fp`WHERE`index`<' + StrFPNum + ' ORDER BY`index`DESC LIMIT 1';
				          try
  								  FPTmpDataset.Open;
                    if FPTmpDataset.RecordCount > 0 then begin
  								  	Stream.LoadFromStream(FPTmpDataset.CreateBlobStream(FPTmpDataset.FieldByName('plan'), bmRead));

	  								  FPMainDataset.SQL.Text := 'UPDATE ' + CurPrefix + 'fp SET`plan`=:fData WHERE`index`=:fInd';
		  							  FPMainDataset.ParamByName('fInd').AsInteger := CurFPNum;
			  						  FPMainDataset.ParamByName('fData').LoadFromStream(Stream, ftBlob);
				  				    FPMainDataset.ExecSQL;
                    end
				          except
        				    on e: EZSQLException do begin
			    	  		    ShowError(Self, 'Невозможно сохранить план по доходу.', e.ErrorCode, e.StatusCode, e.Message);
    					      	Exit;
				      	    end;
				          end;

                end;

            	  FPMainDataset.SQL.Text := 'COMMIT';
                try
  	      			  FPMainDataset.ExecSQL;
                except
                  on e: EZSQLException do begin
            		    ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        	        	Exit;
                  end;
                end;

                // updating the main tree
			          CNodeData.name := StrFPNum + ': ' + DateTimeToStr(dtvTmp, lFormatString);
		  			    CNodeData.sub		:= FPNOTAPPROVED;
			  	      CNodeData.index	:= CurFPNum;
      			    MainTree.RepaintNode(CNode);
      				end;
      				NewFPForm.Free;
              if MainTree.CanFocus then
                MainTree.SetFocus;
    				end;
  				end; //if not FPMainDataset.IsEmpty
				  FPMainDataset.Close;
	      end; //if CurNodeData.sub = FPNEWFPTOCREATE - end of creating new FP
      end //if CurValue = BRANCH_FP
      else if (CNodeData.branch = BRANCH_DEBITORS) and (CNodeData.page = LIST_DEBITORS) then begin
	      CurValue := LIST_DEBITORS;
        CurTable := 'root';
      	CurPrefix := CNodeData.prefix;
        CurOInd		:= CNodeData.ipref;
			  PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
      end
      else if (CNodeData.branch = BRANCH_CREDITORS) and (CNodeData.page = LIST_CREDITORS) then begin
	      CurValue 	:= LIST_CREDITORS;
        CurTable	:= 'root';
      	CurPrefix := CNodeData.prefix;
        CurOInd		:= CNodeData.ipref;
			  PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
      end
      else begin
        if not (CNodeData.page in [BRANCH_FP, BRANCH_ACCESS]) then begin
		  	  CurValue := TmpCurValue;
  		  	CurTable := TmpCurTable;
    	  	CurPrefix := TmpCurPrefix;
	        CurOInd		:= CNodeData.ipref;
	        GridGroupBox.Caption := CNodeData.name;
				  PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
        end;
      end;
    end;
  end;
end;

procedure TMainFPForm.MainTreeDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
	NodeData : PVTResourceData;
begin
	Allowed := false;
  NodeData := MainTree.GetNodeData(Node);
  Allowed := (NodeData.branch = BRANCH_FUNDS) and (NodeData.page in [9]); //[8,9]);
end;

procedure TMainFPForm.MainTreeDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
	NodeDropTo	: PVirtualNode;
  NodeData		: PVTResourceData;
	Nodes		: TNodeArray;
  i				: integer;
begin
(**)
end;

procedure TMainFPForm.MainTreeDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState;
  Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
(**)
Accept := false;
end;

procedure TMainFPForm.MainTreeExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
	SaveNodeState(Node);
end;

procedure TMainFPForm.MainTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
begin
	if (Column = 0) and (Kind <> ikState) then
		ImageIndex :=  PVTResourceData(Sender.GetNodeData(Node)).imindex - 1
  else
		ImageIndex :=  -1;
end;

procedure TMainFPForm.MainTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
	NodeData	: PVTResourceData;
  TmpStr 		: string;
begin
  //
  NodeData := Sender.GetNodeData(Node);
  case Column of
  	0 : begin
			  CellText := NodeData.name;
			  if NodeData.link <> '' then
          if NodeData.branch = 4 then begin // i.e. it's a fond
          	TmpStr := Self.GetAssetNameByLink(AssetNode, NodeData.alink);
            if NodeData.page = 9 then begin
            	CellText := CellText + ' (Актив: ';
              if TmpStr = '' then
              	 CellText := CellText + 'не назначен'
              else
              	 CellText := CellText + TmpStr;
              CellText := CellText + ')';
            end;
          end;
    end;
    1	: begin
      if (NodeData.name <> '') and (NodeData.balance <> 0) then begin
        CellText := MyFloatToStr(NodeData.balance)
      end
      else
      	CellText := '';
    end;
    else
    	CellText := '';
  end;
end;

procedure TMainFPForm.MainTreeHeaderMouseUp(Sender: TVTHeader; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	MainGroupSplitterMoved(Sender);
end;

procedure TMainFPForm.MainTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ScreenPoint : TPoint;
  TreePoint : TPoint;
begin
  inherited;
  if (Button = mbRight) then begin
    ScreenPoint := Classes.Point(X, Y);
    TreePoint := MainTree.ClientToScreen(ScreenPoint);
    PostMessage(Self.Handle, UM_POPUPMENUNEEDED, TreePoint.X, TreePoint.Y);
  end;
end;

procedure TMainFPForm.MainTreeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDefault;
end;

procedure TMainFPForm.MainTreeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	MainGroupSplitterMoved(Sender);
end;

procedure TMainFPForm.MainTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
Var
  NodeData : PVTResourceData;
begin
  NodeData := Sender.GetNodeData(Node);
	if (Node.ChildCount > 0) or (NodeData.page = 8) then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
	if NodeData.arched then begin
    TargetCanvas.Font.Color := clMyGray; //clSilver;
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsItalic];
  end
end;

procedure TMainFPForm.RejectedPOPopUpClick(Sender: TObject);
begin
	ShowAllPOs := false;
	ShowSubmittedPOsOnly 	:= false;
	ShowRejectedPOsOnly 	:= true;
	ShowApprovedPOsOnly 	:= false;
	ShowPaidPOsOnly 			:= false;
	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowRejectedPOsOnly', ShowRejectedPOsOnly);
    IniFile.UpdateFile;
  end;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default	:= true;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default	:= false;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked := false;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.RejectedPOPopUpSHClick(Sender: TObject);
begin
	if ShowAllPOs and (not ShowRejectedPOsOnly) then begin // Submitted POS are still show even if ShowSubmittedPOsOnly is false
		ShowRejectedPOsOnly := true;
		ShowAllPOs := false;
  end;

  ShowRejectedPOsOnly := not ShowRejectedPOsOnly;

	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowRejectedPOsOnly', ShowRejectedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowAllPOs', 				 ShowAllPOs);
    IniFile.UpdateFile;
  end;

  if not ShowRejectedPOsOnly then begin
	  ShowSubmittedPOsOnly := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked;
  	ShowApprovedPOsOnly	 := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked;
	  ShowPaidPOsOnly			 := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked;
  end;

  ShowAllPOs := ShowSubmittedPOsOnly and ShowRejectedPOsOnly and ShowApprovedPOsOnly and ShowPaidPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked := ShowAllPOs or ShowRejectedPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default	:= false;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.RejectedPOToolBtnClick(Sender: TObject);
var
	i : integer;
begin
	i := 2;
	while i<StrGrid.RowCount - 1 do begin
  	if StrGrid.Cells[0, i] = rsRejdPOHeaderRow then begin
    	LockWindowUpdate(StrGrid.Handle);
    	StrGrid.Row := i;
    	LockWindowUpdate(0);
      break;
    end;
    inc(i);
  end;
  StrGrid.SetFocus;
end;

procedure TMainFPForm.RenewNavBar(var Msg: TMessage);
var
  i               : integer;
  j               : integer;
  TmpButton       : TsButton;
  TmpLabel        : TLabel;
  StrBegin        : string;
  StrEnd          : string;
  TmpFloat        : extended;
  TmpPOSum				: extended;
  TmpPOSum1				: extended;

  Total           : extended;
  formatSettings  : TFormatSettings;
  tmpStr          : string;
  tmpStr1         : string;
  kind            : integer;
  Funds           : extended;
  Assets          : extended;
  DateTime        : TDateTime;
  SQLDate         : TSQLTimeStamp;
  gp, yp, rp, grp : integer;
  IncData         : PIncData;
  FromDate        : TDateTime;
  ToDate          : TDateTime;
  page            : integer;
  BtnsAdded       : integer;
  LastFPNum       : integer;
  NAFPExists      : boolean;

  // for income source table
  TotWeek	: extended;
  Tot1    : extended;
  Tot2    : extended;
  tot3	  : extended;
  TmpPct	: extended;

  RecCount	: integer;

  fplink	    	: string;
  cashlink    	: string;
  bill1link	    : string;
  fundlink    	: string;
  assetlink   	: string;
  incsrceslink  : string;
  polink	    	: string;
  cplink	    	: string; // collect/pay link
  dclink	    	: string; // debtor/creditor link

// filtering stuff
  FiltArray : PColFilters;
  bFiltering : boolean;
  pfo     : TFilterObject;

// caching stuff
  ArrCompanyName   : array of string;

begin
	sb.SimpleText := '';
  BtnsAdded := 0;
  if CurValue = 0 then
    CurValue := 2;
  if CurTable = '' then
    curtable := 'root';
  StrGrid.Visible := true;
  PrintToolButton.Enabled := CurValue <> 5;
  SearchToolbar.Visible		:= CurValue = 6;
//*******************************************************************************************
// filling the main grid
//*******************************************************************************************

  MainGridIsBeingUpdated := true; // to lock any recurrent updates on the StrGrid

  StrGrid.BeginUpdate;
	GridPanel.Visible := true;
	StrGrid.FixedRows := 0;

  StrGrid.SplitRowCells(0);
  StrGrid.Cells[0, 0] := '';

  // flashing StrGrid
  StrGrid.UnGroup;
	StrGrid.UnHideRowsAll;
  StrGrid.Clear;

{$IFDEF SHOWFINSTATS}
  if CurValue <> 2 then begin
  	StatsScrollBox.Visible	:= false;
    StatsSplitter.Visible		:= false;
  end
  else begin
  	StatsScrollBox.Visible	:= true;
  end;
{$ENDIF}

  if (CurValue = 2) and not PrivPresentMO(CurPrivs, 'bg') then begin
      if PrivPresentMO(CurPrivs, 'z') then
        CurValue := BRANCH_INCOME
      else
        CurValue := BRANCH_POS;
  end;

	SetFilerToolbarVisible;

  sIniSection := IntToStr(CurValue);

	StrGrid.UnGroup;
  case CurValue of
    1 : begin // show income only instead of the root point when "show income only" right was set up
      StrGrid.ColCount := 6;

      StrGrid.RowCount := 2;
			StrGrid.FixedRows := 1;

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('№');
      StrGrid.ColumnHeaders.Add('Описание');
      StrGrid.ColumnHeaders.Add('Дата');
      StrGrid.ColumnHeaders.Add('Сумма');
      StrGrid.ColumnHeaders.Add('Куда поступили');

      // setting up header
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 40);
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 125);
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 450);
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 125);
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 160);

      StrGrid.MergedColumns.Clear;

      StrGrid.SplitRowCells(0);
      StrGrid.Cells[0, 0] := '';
      StrGrid.SplitRowCells(1);
      StrGrid.Cells[0, 1] := '';
      StrGrid.SplitRowCells(2);
      StrGrid.Cells[0, 2] := '';

      FmtList.Clear;
      i 		    := 1;
  		fplink		:= 'fp';
      cashlink  := CASH_LINK;
      bill1link	:= BILL1_LINK;
		  fundlink	:= 'fond';
      assetlink	:= 'asset';
      incsrceslink  := 'incomesources';

  		fplink 		:= CurPrefix + fplink;
      cashlink  := CurPrefix + cashlink;
      bill1link	:= CurPrefix + bill1link;
		  fundlink	:= CurPrefix + fundlink;
		  assetlink	:= CurPrefix + assetlink;
      incsrceslink := CurPrefix + incsrceslink;

      FPMainDataset.SQL.Text :=
          '(SELECT`index`,`lastdate`,`data`,CAST(`in`AS DECIMAL(25,2))AS`in`,`link`,"' + cashlink + '"as`src`FROM ' + cashlink + ' '+
          'WHERE`in`<>0 AND`link`IN("' + bill1link + '","frombank","' + cashlink + '","specinc"))';
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' union';
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text +
          '(SELECT`index`,`lastdate`,`data`,CAST(`in`AS DECIMAL(25,2))AS`in`,`link`,"' + bill1link + '"as`src`FROM '+ bill1link + ' '+
          'WHERE`in`<>0 AND`link`IN("' + bill1link + '","frombank","' + cashlink + '","specinc"))';
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY `lastdate` DESC';

			try
      	FPMainDataset.Open;
	      RecCount := FPMainDataset.RecordCount;
      except
      	on e: Exception do begin
        	RecCount := 0;
        end;
      end;

      if RecCount > 0 then begin
	      StrGrid.SplitRowCells(i);
		    while not FPMainDataset.Eof do begin
	  	    StrGrid.Cells[0, i] := '';
  	  	  StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString; //'№ п/п';
    	  	StrGrid.Cells[2, i] := DateTimeToStr(FPMainDataset.FieldByName('lastdate').AsDateTime, lFormatString);  // 'Date'
    	  	StrGrid.Cells[3, i] := FPMainDataset.FieldByName('data').AsString;  // 'Description'
    	  	StrGrid.Cells[4, i] := MyFloatToStr(FPMainDataset.FieldByName('in').AsExtended);  // 'Amount'
          if(FPMainDataset.FieldByName('src').AsString = cashlink) then begin
    	  	  StrGrid.Cells[5, i] := 'Касса (приходная)';  // 'Destination'
          end
          else begin
    	  	  StrGrid.Cells[5, i] := 'Счёт №1';  // 'Destination'
          end;
	        FPMainDataset.Next;
					StrGrid.AddRow;
          Inc(i);
  	    end; // while
      end; // if FPTmpDataset.RecordCount > 0
    end;
    2 : begin // root point
{$IFNDEF FORPERFORMIA}
      StrGrid.ColCount := 6;
{$ELSE}
      StrGrid.ColCount := 10;
{$ENDIF}
      StrGrid.RowCount  := 2;
			StrGrid.FixedRows := 1;
      StrGrid.ColumnHeaders.Clear;
{$IFNDEF FORPERFORMIA}
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
{$ELSE}
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
{$ENDIF}

      StrGrid.MergedColumns.Clear;

      StrGrid.SplitRowCells(0);
      StrGrid.Cells[0, 0] := '';
      StrGrid.SplitRowCells(1);
      StrGrid.Cells[0, 1] := '';
      StrGrid.SplitRowCells(2);
      StrGrid.Cells[0, 2] := '';

      FmtList.Clear;
      FmtList.Add('');
      FmtList.Add('cwinc');

      i 		:= 1;
      Total := 0;

  		fplink		:= 'fp';
      cashlink  := CASH_LINK;
      bill1link	:= BILL1_LINK;
		  fundlink	:= 'fond';
      assetlink	:= 'asset';
      incsrceslink  := 'incomesources';

  		fplink 		:= CurPrefix + fplink;
      cashlink  := CurPrefix + cashlink;
      bill1link	:= CurPrefix + bill1link;
		  fundlink	:= CurPrefix + fundlink;
		  assetlink	:= CurPrefix + assetlink;
      incsrceslink := CurPrefix + incsrceslink;

      // setting the current week income
      FPMainDataset.SQL.Text := 'SELECT`to`as`lasttade`FROM`' + fplink + '`WHERE`to`IS NOT NULL ORDER BY `index` DESC LIMIT 1';
      FPMainDataset.Open;
      if FPMainDataset.RecordCount > 0 then begin
      	FPTmpDataset.SQL.Text := 'SELECT SUM(`insums`) as `inctot` FROM'+
        		'(SELECT SUM(`in`) AS `insums` FROM ' + cashlink  + ' WHERE `lastdate`>=:fLastFPDate AND((`link`="' + cashlink  + '")OR(`link`="specinc")) UNION '+
             'SELECT SUM(`in`) AS `insums` FROM ' + bill1link + ' WHERE `lastdate`>=:fLastFPDate AND((`link`="' + bill1link + '")OR(`link`="specinc"))) AS `tmptbl1`';
        ToDate := FPMainDataset.FieldByName('lasttade').AsDateTime;
        FPTmpDataset.ParamByName('fLastFPDate').AsDateTime := ToDate;
      end
      else begin
      	FPTmpDataset.SQL.Text := 'SELECT SUM(`insums`)AS`inctot`FROM' +
        		'(SELECT SUM(`in`)AS`insums`FROM ' + cashlink  + ' WHERE((`link`="'+ cashlink  + '")OR(`link`="specinc")) UNION '+
             'SELECT SUM(`in`)AS`insums`FROM ' + bill1link + ' WHERE((`link`="'+ bill1link + '")OR(`link`="specinc"))) AS `tmptbl1`';
      end;

      FPTmpDataset.Open;
      if not FPTmpDataset.Eof then
	      TotWeek := FPTmpDataset.FieldByName('inctot').AsFloat
      else
	      TotWeek := 0;

      StrGrid.SplitRowCells(i);

      // Adding data for income sources
      j := 1;
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '2';
      StrGrid.Cells[2, i] := 'Доход за текущую неделю:';
      StrGrid.Cells[3, i] := ':';
      StrGrid.Cells[4, i] := ':';
      StrGrid.Cells[5, i] := ':';
			//StrGrid.AddRow;
      //Inc(i);


		  Tot1 := 0;
		  Tot2 := 0;
		  Tot3 := 0;
      if FPMainDataset.RecordCount > 0 then begin
      	FPTmpDataset.SQL.Text :=
						'SELECT ' + incsrceslink + '.title,SUM(`in`)AS`insums`,SUM(`amount`)AS`amnt`,incsrcid,pct FROM(' +
            'SELECT `index`,`in`,amount,incsrcid,pct FROM ' + cashlink  + ' WHERE `lastdate`>=:ftd AND((`link`="'+ cashlink  + '")OR(`link`="specinc"))AND`in`>0 UNION ' +
            'SELECT `index`,`in`,amount,incsrcid,pct FROM ' + bill1link + ' WHERE `lastdate`>=:ftd AND((`link`="'+ bill1link + '")OR(`link`="specinc"))AND`in`>0)as tbl1 ' +
            'LEFT JOIN ' + incsrceslink + ' ON tbl1.incsrcid=' + incsrceslink + '.ID GROUP BY incsrcid';
{$IFDEF FORPERFORMIA}
      	FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + ',pct';
{$ENDIF}
        FPTmpDataset.ParamByName('ftd').AsDateTime := ToDate;
      end
      else begin
      	FPTmpDataset.SQL.Text :=
						'SELECT ' + incsrceslink + '.title,SUM(`in`)AS`insums`,SUM(`amount`)AS`amnt`,incsrcid,pct FROM(' +
            'SELECT `index`,`in`,amount,incsrcid,pct from ' + cashlink  + ' WHERE((`link`="'+ cashlink  + '")OR(`link`="specinc"))AND `in`>0 UNION ' +
            'SELECT `index`,`in`,amount,incsrcid,pct from ' + bill1link + ' WHERE((`link`="'+ bill1link + '")OR(`link`="specinc"))AND `in`>0)as tbl1 ' +
            'LEFT JOIN ' + incsrceslink + ' ON tbl1.incsrcid=' + incsrceslink + '.ID GROUP BY incsrcid';
{$IFDEF FORPERFORMIA}
      	FPTmpDataset.SQL.Text := FPTmpDataset.SQL.Text + ',pct';
{$ENDIF}
      end;

			try
      	FPTmpDataset.Open;
	      RecCount := FPTmpDataset.RecordCount;
      except
      	on e: Exception do begin
        	RecCount := 0;
        end;
      end;

//      if FPTmpDataset.RecordCount > 0 then begin
      if RecCount > 0 then begin
	      StrGrid.SplitRowCells(i);
	      StrGrid.Cells[0, i] := '';
  	    StrGrid.Cells[1, i] := '1'; //'Доход по источникам дохода:';
    	  StrGrid.Cells[2, i] := '№'; // порядковый номер
	      StrGrid.Cells[3, i] := 'Источник дохода';
  	    StrGrid.Cells[4, i] := 'Кол-во';
    	  StrGrid.Cells[5, i] := 'Всего';

{$IFDEF FORPERFORMIA}
	      StrGrid.Cells[6, i] := '% ПСНГ';
  	    StrGrid.Cells[7, i] := 'Сумма ПСНГ';
    	  StrGrid.Cells[8, i] := '% ПКаз';
      	StrGrid.Cells[9, i] := 'Сумма ПКаз';
{$ENDIF}

        FmtList.Add('h1__');
	      Inc(i);
  	  	j := 1;

		    while not FPTmpDataset.Eof do begin
					StrGrid.AddRow;
	  	    StrGrid.Cells[0, i] := '';
  	  	  StrGrid.Cells[1, i] := '1'; //'Доход по источникам дохода:';
    	  	StrGrid.Cells[2, i] := IntToStr(j); //'1'; //
          Inc(j);
	        TmpPct   := FPTmpDataset.FieldByName('pct').AsExtended;
  	    	StrGrid.Cells[3, i] := FPTmpDataset.FieldByName('title').AsString;
	  	    StrGrid.Cells[4, i] := FPTmpDataset.FieldByName('amnt').AsString;
      	  TmpFloat	:= FPTmpDataset.FieldByName('insums').AsExtended;					// Общая сумма по ист дохода и %
        	Tot1 := Tot1 + TmpFloat;
	  	    StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);

{$IFDEF FORPERFORMIA}
  		    StrGrid.Cells[6, i] := MyFloatToStr(TmpPct);                      	// % ПСНГ
    	    TmpPOSum	:= Int(TmpFloat * TmpPct) / 100;
  	  	  StrGrid.Cells[7, i] := MyFloatToStr(TmpPOSum);                      // Сумма ПСНГ
        	Tot2 := Tot2 + TmpPOSum;
	  	    StrGrid.Cells[8, i] := MyFloatToStr(100 - TmpPct);                  // % ПКаз
  	      TmpPOSum1	:= TmpFloat - TmpPOSum;
  		    StrGrid.Cells[9, i] := MyFloatToStr(TmpPOSum1);                     // Сумма ПКаз
      	  Tot3 := Tot3 + TmpPOSum1;
{$ENDIF}

	        FmtList.Add('');
          Inc(i);
	        FPTmpDataset.Next;
  	    end; // while

				StrGrid.AddRow;
	  	  StrGrid.Cells[0, i] := '';
  	  	StrGrid.Cells[1, i] := '1'; //'Доход по источникам дохода:';
    	  StrGrid.Cells[2, i] := 'ИТОГО:'; //'1'; //
  	    StrGrid.Cells[3, i] := '';
	  	  StrGrid.Cells[4, i] := '';
	  	  StrGrid.Cells[5, i] := MyFloatToStr(Tot1);                                // Общая сумма по ист дохода и %
{$IFDEF FORPERFORMIA}
  		  StrGrid.Cells[6, i] := '';                      													// % ПСНГ
  	  	StrGrid.Cells[7, i] := MyFloatToStr(Tot2);                      					// Сумма ПСНГ
	  	  StrGrid.Cells[8, i] := '';                      													// % ПКаз
  		  StrGrid.Cells[9, i] := MyFloatToStr(tot3);                      					// Сумма ПКаз
      	Tot3 := Tot3 + TmpPOSum1;
{$ENDIF}
        FmtList.Add('f1__');
        Inc(i);
      end; // if FPTmpDataset.RecordCount > 0

			if RecCount > 0 then begin
// Group it on column 1
	    	StrGrid.SortSettings.AutoSortForGrouping := false;

        /// HERE IS THE BUG!!!
  	  	StrGrid.Group(1);
        /// HERE IS THE BUG!!!
      end
      else begin
      	StrGrid.RemoveCols(1, 1);
      end;

// Rearrainging the footer
      StrGrid.SplitRowCells(i);
    	StrGrid.MergeCells(1, i, 3, 1);

      // setting up header
      StrGrid.ColWidths[0]  := ReadColWidth(sIniSection, 0, 20); 	//20;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 20); 	//20;
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 200); //120;
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 60); 	//200;
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 200); //200;
{$IFDEF FORPERFORMIA}
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 100); //200;
      StrGrid.ColWidths[6]  := ReadColWidth(sIniSection, 6, 200); //200;
      StrGrid.ColWidths[7]  := ReadColWidth(sIniSection, 7, 100); //200;
      StrGrid.ColWidths[8]  := ReadColWidth(sIniSection, 8, 200); //200;
{$ENDIF}
      Inc(i);
      StrGrid.AddRow;
      StrGrid.SplitRowCells(i);
{$IFNDEF FORPERFORMIA}
    	StrGrid.MergeCells(1, i, 3, 1);
{$ELSE}
    	StrGrid.MergeCells(1, i, 7, 1);
{$ENDIF}

      // pulling funds from DB
      FPMainDataset.SQL.Text := 'SELECT SUM(balance) as bsum FROM ' + fundlink;
      FPMainDataset.Open;
      if FPMainDataset.RecordCount > 0 then begin
        StrGrid.Cells[1, i] := 'Всего в фондах:';
        Funds := FPMainDataset.FieldByName('bsum').AsExtended;
{$IFNDEF FORPERFORMIA}
        StrGrid.Cells[4, i] := MyFloatToStr(Funds);
{$ELSE}
        StrGrid.Cells[8, i] := MyFloatToStr(Funds);
{$ENDIF}
      end;
      FmtList.Add('h__');
			Inc(i);

      // pulling assets from DB
      StrGrid.AddRow;
      StrGrid.SplitRowCells(i);
{$IFNDEF FORPERFORMIA}
    	StrGrid.MergeCells(1, i, 3, 1);
{$ELSE}
    	StrGrid.MergeCells(1, i, 7, 1);
{$ENDIF}
      FPMainDataset.SQL.Text := 'SELECT SUM(balance) as bsum FROM ' + assetlink;
      FPMainDataset.Open;
      if FPMainDataset.RecordCount > 0 then begin
        StrGrid.Cells[1, i] := 'Всего денежных средств:';
        Assets := FPMainDataset.FieldByName('bsum').AsExtended;
{$IFNDEF FORPERFORMIA}
        StrGrid.Cells[4, i] := MyFloatToStr(Assets);
{$ELSE}
        StrGrid.Cells[8, i] := MyFloatToStr(Assets);
{$ENDIF}
      end;
      FmtList.Add('h__');
      Inc(i);

      StrGrid.AddRow;
      StrGrid.SplitRowCells(i);

{$IFNDEF FORPERFORMIA}
    	StrGrid.MergeCells(1, i, 3, 1);
{$ELSE}
    	StrGrid.MergeCells(1, i, 7, 1);
{$ENDIF}

      StrGrid.Cells[0, i] := '';
      if Funds <> Assets then begin
        if Funds < Assets then begin
          StrGrid.Cells[2, i] := 'Нераспределённые средства:';
        end
        else begin
          StrGrid.Cells[2, i] := 'Недостаток средств в активах:';
        end;
{$IFNDEF FORPERFORMIA}
        StrGrid.Cells[4, i] := MyFloatToStr(Abs(Assets - Funds));
{$ELSE}
        StrGrid.Cells[8, i] := MyFloatToStr(Abs(Assets - Funds));
{$ENDIF}
      end
      else begin
        StrGrid.Cells[2, i] := '';
{$IFNDEF FORPERFORMIA}
        StrGrid.Cells[4, i] := '';
{$ELSE}
        StrGrid.Cells[8, i] := '';
{$ENDIF}
      end;
      FmtList.Add('h__');
      Inc(i);

{$IFNDEF FORPERFORMIA}
    	StrGrid.MergeCells(1, 1, 3, 1);
{$ELSE}
    	StrGrid.MergeCells(1, 1, 7, 1);
{$ENDIF}
      StrGrid.Cells[1, 1] := 'Доход за текущую неделю:';

{$IFNDEF FORPERFORMIA}
      StrGrid.Cells[4, 1] := MyFloatToStr(TotWeek);
{$ELSE}
      StrGrid.Cells[8, 1] := MyFloatToStr(TotWeek);
{$ENDIF}

			MainGridIsBeingUpdated := false;
    end; // case of 2
    3 : begin // ASSETS (root points)
	    // setting the header
      Total := 0;
      StrGrid.ColCount	:= 4;
			StrGrid.FixedRows := 1;

      // setting up header
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 120);
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 200);
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 200);

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('Название');
      StrGrid.ColumnHeaders.Add('Баланс');
      StrGrid.ColumnHeaders.Add('Дата последней операции');
      StrGrid.Repaint;

      StrGrid.MergedColumns.Clear;
      i := 1;

      FPMainDataset.Close;
      FPMainDataset.SQL.Text := 'SELECT * FROM ' + CurTable + ' WHERE`index`>1 ORDER BY`index`ASC';
      FPMainDataset.Open;
      while not FPMainDataset.Eof do begin
				StrGrid.SplitRowCells(i);
				StrGrid.Cells[0, i] := '';
				StrGrid.Cells[1, i] := FPMainDataset.FieldByName('name').AsString;
				TmpFloat            := FPMainDataset.FieldByName('Balance').AsExtended;
				Total               := Total + TmpFloat;
				tmpStr              := MyFloatToStr(TmpFloat);
				StrGrid.Cells[2, i] := MyFloatToStr(TmpFloat);
				StrGrid.Cells[3, i] := DateTimeToStr(FPMainDataset.FieldByName('lastdate').AsDateTime, lFormatString);
				Inc(i);
				FPMainDataset.Next;
      end; // while

      StrGrid.SplitRowCells(i);
      StrGrid.Cells[0, i] := '';
      StrGrid.ClearRows(i, 1);
      StrGrid.Cells[1, i] := 'Всего:';
      StrGrid.Cells[2, i] := MyFloatToStr(Total);
      StrGrid.Cells[3, i] := '';
      Inc(i);
		  StrGrid.RowCount := i;
    end;   // case of 3, 4
    4 : begin // FUNDS (root points)
	    // setting the header
      Total    := 0;
      TmpPOSum := 0;

      StrGrid.ColCount	:= 6;
			StrGrid.FixedRows := 1;

      // setting up header
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 120);
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 200);
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 200);
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 200);
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 200);

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');                            // 0
      StrGrid.ColumnHeaders.Add('Название');                    // 1
      StrGrid.ColumnHeaders.Add('Баланс');                       // 4
      StrGrid.ColumnHeaders.Add('В заявках');                   // 3
      StrGrid.ColumnHeaders.Add('Свободно');                      // 2
      StrGrid.ColumnHeaders.Add('Дата последней операции');     // 5

      StrGrid.MergedColumns.Clear;
      i := 1;

      FPMainDataset.SQL.Text := 'SELECT * FROM ' + CurTable + ' WHERE`index`>1';
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND arched<>1';
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY`name`ASC'; // ' ORDER BY`index`ASC'; // sort be name is more logical

      FPMainDataset.Open;
      while not FPMainDataset.Eof do begin
				StrGrid.SplitRowCells(i);
				StrGrid.Cells[0, i] := '';
				StrGrid.Cells[1, i] := FPMainDataset.FieldByName('name').AsString;
				TmpFloat            := FPMainDataset.FieldByName('Balance').AsExtended;
				Total               := Total + TmpFloat;
        FPTmpDataset.SQL.Text := 'SELECT SUM(suma)AS tota FROM`' + CurPrefix + 'po`WHERE status IN(2,4)AND fond=:fFundLink GROUP BY fond';
        FPTmpDataset.ParamByName('fFundLink').AsString := FPMainDataset.FieldByName('link').AsString;
        FPTmpDataset.Open;
        TmpPOSum1 := FPTmpDataset.FieldByName('tota').AsExtended;
        TmpPOSum := TmpPOSum + TmpPOSum1;

				StrGrid.Cells[2, i] := MyFloatToStr(TmpFloat);
				StrGrid.Cells[3, i] := MyFloatToStr(TmpPOSum1);
				StrGrid.Cells[4, i] := MyFloatToStr(TmpFloat - TmpPOSum1);
				StrGrid.Cells[5, i] := DateTimeToStr(FPMainDataset.FieldByName('lastdate').AsDateTime, lFormatString);
				Inc(i);
				FPMainDataset.Next;
      end; // while
      FPTmpDataset.Close;

      StrGrid.SplitRowCells(i);
      StrGrid.Cells[0, i] := '';
      StrGrid.ClearRows(i, 1);
      StrGrid.Cells[1, i] := 'Всего:';
      StrGrid.Cells[2, i] := MyFloatToStr(Total);
      StrGrid.Cells[3, i] := MyFloatToStr(TmpPOSum);
      StrGrid.Cells[4, i] := MyFloatToStr(Total - TmpPOSum);
      StrGrid.Cells[5, i] := '';
      Inc(i);
		  StrGrid.RowCount := i;
    end;   // case of 4
    5 : begin  // FP
        GridPanel.Visible := false;
    end; // 5 : begin  // FP
    6 : begin  // Search
        SearchSourceCombo.Clear;
//        SearchSourceCombo.Items.Add('---------- Везде ---------------');
        SearchSourceCombo.Items.Add('---------- Активы ----------');

        if Assigned(AssetList) then
        	AssetList.Free;
			  AssetList := TList.Create;
        AssetList := CompFondList('asset', 0, CFL_IGNOREGROUPS, CFL_IGNOREPOS, CurPrefix);
			  for i := 0 to AssetList.Count - 1 do begin
			    SearchSourceCombo.Items.Add(PVTResourceData(AssetList[i]).name);
			  end;

        SearchSourceCombo.Items.Add('---------- Фонды ----------');
        if Assigned(FondList) then
        	FondList.Free;

			  FondList := TList.Create;
        FondList := CompFondList('fond', 0, CFL_IGNOREGROUPS, CFL_IGNOREPOS, CurPrefix, true);

			  for i := 0 to FondList.Count - 1 do begin
			    SearchSourceCombo.Items.Add(PVTResourceData(FondList[i]).name);
			  end;
        SearchSourceCombo.ItemIndex	:= 0;

        //StrGrid.Visible := false;
        StrGrid.ColCount := 0;
        StrGrid.Width := 0;
        EndDateEdit.Date := now;

    end; // 6 : begin  // Search

    7 : begin  // BRANCH_POS POs and etc...

      FondList := CompFondList(CurPrefix + 'fond', 0, CFL_WITHGROUPS, CFL_IGNOREPOS, CurPrefix, true);

    	StrGrid.SplitAllCells;
      StrGrid.ColCount := 11;

      StrGrid.RowCount	:= 3; //2;
			StrGrid.FixedRows := 1;
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 20); //20;
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 125); //125;
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 100); //100;
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 100); //100;
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 100); //100;
      StrGrid.ColWidths[6]  := ReadColWidth(sIniSection, 6, 100); //100;
      StrGrid.ColWidths[7]  := ReadColWidth(sIniSection, 7, 120); //120;
      StrGrid.ColWidths[8]  := ReadColWidth(sIniSection, 8, 80); //80;
      StrGrid.ColWidths[9]  := ReadColWidth(sIniSection, 9, 80); //80;
      StrGrid.ColWidths[10] := ReadColWidth(sIniSection, 9, 80); //80;

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('');
      i := 1;

			polink := CurPrefix + 'po';

		  if ShowAllPOs or ShowSubmittedPOsOnly then begin
	      StrGrid.MergeCells(1, i, 9, 1);
  	    StrGrid.Cells[0, i] := rsSubdPOHeaderRow;
    	  StrGrid.Cells[1, i] := rsSubdPOHeaderMain; //'A. Выставленные заявки';
      	inc(i);

	      StrGrid.SplitRowCells(i);
  	    StrGrid.Cells[ 0, i] := rsSubdPOHeaderRow;
    	  StrGrid.Cells[ 1, i] := rsSubdPOHeaderNum; //'№';
      	StrGrid.Cells[ 2, i] := rsSubdPOHeaderDate; //'Дата';
	      StrGrid.MergeCells(3, i, 4, 1);
  	    StrGrid.Cells[ 3, i] := rsSubdPOHeaderSubj; //'Тема';
    	  StrGrid.Cells[ 7, i] := rsSubdPOHeaderSum; //'Сумма';
    	  StrGrid.Cells[ 8, i] := rsSubdPOHeaderCash; //'Тип'; Нал/Безнал
	      StrGrid.MergeCells(9, i, 2, 1);
      	StrGrid.Cells[ 9, i] := rsSubdPOHeaderAuth; //'Автор';
//      	StrGrid.Cells[10, i] := rsSubdPOHeaderAuth; //
	    	Inc(i);

        // add filtering line - Submitted PO
        j := POFilters.IndexOf(rsSubdPOFilterRow);
			  if (j >= 0) and (j < POFilters.Count) then begin
        	FiltArray := PColFilters(POFilters.Objects[j]);
          bFiltering := true; //
        end
        else
          bFiltering := false;

				if bFiltering then begin
		      StrGrid.SplitRowCells(i);
  		    StrGrid.Cells[0, i] := rsSubdPOFilterRow;
	      	if FiltArray^[1] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftInt);
		        FiltArray^[1] := pfo;
        	end;
    		  StrGrid.Cells[1, i] := GetFilterState(StrGrid.Cells[0, i], 1); //'№';

	      	if FiltArray^[2] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftDates);
		        FiltArray^[2] := pfo;
        	end;
	      	StrGrid.Cells[2, i] := GetFilterState(StrGrid.Cells[0, i], 2); //'Дата';

		      StrGrid.MergeCells(3, i, 4, 1);
	      	if FiltArray^[3] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[3] := pfo;
        	end;
  		    StrGrid.Cells[3, i] := GetFilterState(StrGrid.Cells[0, i], 3); //'Тема';

	      	if FiltArray^[7] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftExt);
		        FiltArray^[7] := pfo;
        	end;
  	  	  StrGrid.Cells[7, i] := GetFilterState(StrGrid.Cells[0, i], 7); //'Сумма';

	      	if FiltArray^[8] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[8] := pfo;
        	end;
    		  StrGrid.Cells[8, i] := GetFilterState(StrGrid.Cells[0, i], 8); //'Тип'; Нал/Безнал

		      StrGrid.MergeCells(9, i, 2, 1);
	      	if FiltArray^[9] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[9] := pfo;
        	end;
      		StrGrid.Cells[9, i] := GetFilterState(StrGrid.Cells[0, i], 9); //'Автор';
//      		StrGrid.Cells[10, i] := ''; //'Автор';
	    		Inc(i);
        end;

	      // total string
  	    StrGrid.SplitRowCells(i);
      	StrGrid.Cells[ 0, i] := rsSubdPOTotalRow;
    	  StrGrid.MergeCells(1, i, 6, 1);
	      StrGrid.Cells[ 1, i] := rsSubdPOHeaderTot; //'Итого';
  	    StrGrid.Cells[ 7, i] := '';
  	    StrGrid.Cells[ 8, i] := '';
	      StrGrid.MergeCells(9, i, 2, 1);
	      StrGrid.Cells[ 9, i] := '';
//	      StrGrid.Cells[10, i] := '';

  	    j := i;

    	  TmpPOSum := 0;
    		Inc(i);

      // Security restrictions added
	      if PrivPresentMO(CurPrivs, 'a') or (not PrivPresentMO(CurPrivs, 'bl')) then
  	       TmpStr := '`origin`="' + FPLogin + '" AND ';
				FPMainDataset.SQL.Text := 'SELECT ' + polink + '.*,Left(FirstName,1)AS FName,Left(MiddleName,1)AS MName,allusers.FamilyName FROM`' + polink + '`INNER JOIN`allusers`ON ' + polink + '.origin=allusers.login WHERE ' + TmpStr + '`status`<=0';

	      // filtering out -- begin of
  	    if FixedTimeFilter then begin
    	    TmpStr1 := GetFixedTimeInterval;
      	  if TmpStr1 <> '' then
	      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND `date`>DATE_SUB(CURDATE(),INTERVAL '+ TmpStr1 +')';
	      end
  	    else if ArbTimeFilter then begin
	  	    FormatString.LongDateFormat   := 'YYYYMMDD';
	    	  FormatString.ShortDateFormat  := 'YYYYMMDD';
        	if FilterDateStartEdit.Date <> 0 then begin
	      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND `date`>=' + DateToStr(FilterDateStartEdit.Date, FormatString);
	        end;
  	      if FilterDateEndEdit.Date <> 0 then
	  	    	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND `date`<=' + DateToStr(FilterDateEndEdit.Date+1, FormatString);
      	end; // if FixedTimeFilter then begin
	      // filtering out -- end of
  	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY `index` DESC';// LOCK IN SHARE MODE';
    	  FPMainDataset.Open;
	      // submitted POs
  	    while not FPMainDataset.Eof do begin
    	    StrGrid.SplitRowCells(i);
        	if FPMainDataset.FieldByName('status').AsInteger = -1 then
	        	StrGrid.Cells[0, i] := rsSubdPOUrgentRow
          else
	      	  StrGrid.Cells[0, i] := rsSubdPORow;

	        StrGrid.Cells[1, i] := Trim(FPMainDataset.FieldByName('index').AsAnsiString); //AsString;
  	      StrGrid.Cells[2, i] := DateTimeToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
    	    StrGrid.MergeCells(3, i, 4, 1);
      	  StrGrid.Cells[3, i] := Trim(FPMainDataset.FieldByName('re').AsAnsiString); // AsString;
        	TmpFloat := FPMainDataset.FieldByName('sumr').AsExtended;
	        TmpPOSum := TmpPOSum + TmpFloat;
  	      StrGrid.Cells[7, i] := MyFloatToStr(TmpFloat);
        	if FPMainDataset.FieldByName('bycash').AsInteger > 0 then
	        	StrGrid.Cells[8, i] := rsByCash
          else
	      	  StrGrid.Cells[8, i] := rsByBank;


		      StrGrid.MergeCells(9, i, 2, 1);
    	    StrGrid.Cells[9, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FName').AsString, FPMainDataset.FieldByName('MName').AsString);
//		      StrGrid.Cells[10, i] := '';
	        Inc(i);
  	      Total := Total + TmpFloat;
    	    FPMainDataset.Next;
      	end; // while
	      StrGrid.MergeCells(1, i, 9, 1);
  	    StrGrid.Cells[0, i] := '';
    	  StrGrid.Cells[1, i] := '';
      	Inc(i);
	      StrGrid.Cells[7, j] 	:= MyFloatToStr(TmpPOSum);
	  	end;

			if ShowAllPOs or ShowRejectedPOsOnly then begin
  	    // rejected POs
    	  StrGrid.MergeCells(1, i, 9, 1);
	      StrGrid.Cells[0, i] := rsRejdPOHeaderRow;
  	    StrGrid.Cells[1, i] := rsRejdPOHeaderMain;
    	  Inc(i);

	      StrGrid.SplitRowCells(i);
  	    StrGrid.Cells[0, i] := rsRejdPOHeaderRow;
    	  StrGrid.Cells[1, i] := rsRejdPOHeaderNum;  // '№'
      	StrGrid.Cells[2, i] := rsRejdPOHeaderDate; //'Дата';
	      StrGrid.MergeCells(3, i, 4, 1);
  	    StrGrid.Cells[3, i] := rsRejdPOHeaderSubj; // 'Тема';
	      StrGrid.Cells[7, i] := rsRejdPOHeaderSum;  // 'Сумма';
	      StrGrid.Cells[8, i] := rsRejdPOHeaderAuth; // 'Автор';
  	    StrGrid.Cells[9, i] := rsRejdPOHeaderSig;  // 'Подпись';
	      StrGrid.Cells[10, i] := '';
    	  Inc(i);

        // add filtering line - Rejected PO
        j := POFilters.IndexOf(rsRejdPOFilterRow);
			  if (j >= 0) and (j < POFilters.Count) then begin
        	FiltArray := PColFilters(POFilters.Objects[j]);
          bFiltering := true; //
        end
        else
          bFiltering := false;

				if bFiltering then begin
		      StrGrid.SplitRowCells(i);
  		    StrGrid.Cells[0, i] := rsRejdPOFilterRow;
	      	if FiltArray^[1] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftInt);
		        FiltArray^[1] := pfo;
        	end;
    		  StrGrid.Cells[1, i] := GetFilterState(StrGrid.Cells[0, i], 1); //'№';

	      	if FiltArray^[2] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftDates);
		        FiltArray^[2] := pfo;
        	end;
	      	StrGrid.Cells[2, i] := GetFilterState(StrGrid.Cells[0, i], 2); //'Дата';

		      StrGrid.MergeCells(3, i, 4, 1);
	      	if FiltArray^[3] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[3] := pfo;
        	end;
  		    StrGrid.Cells[3, i] := GetFilterState(StrGrid.Cells[0, i], 3); //'Тема';

	      	if FiltArray^[7] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftExt);
		        FiltArray^[7] := pfo;
        	end;
  	  	  StrGrid.Cells[7, i] := GetFilterState(StrGrid.Cells[0, i], 7); //'Сумма';

	      	if FiltArray^[8] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[8] := pfo;
        	end;
    		  StrGrid.Cells[8, i] := GetFilterState(StrGrid.Cells[0, i], 8); //'Тип'; Нал/Безнал

	      	if FiltArray^[9] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[9] := pfo;
        	end;
      		StrGrid.Cells[9, i] := GetFilterState(StrGrid.Cells[0, i], 9); //'Автор';
	    		Inc(i);
        end;

      	// total string
	      StrGrid.SplitRowCells(i);
  	    StrGrid.MergeCells(1, i, 6, 1);
    	  StrGrid.Cells[0, i] := rsRejdPOTotalRow;
      	StrGrid.Cells[1, i] := rsRejdPOHeaderTot; // 'Итого';
	      StrGrid.Cells[7, i] := '';
  	    StrGrid.MergeCells(8, i, 2, 1);
    	  StrGrid.Cells[8, i] := '';
      	j := i;
	      TmpPOSum := 0;
  	  	Inc(i);

	      // security restrictions
        if PrivPresentMO(CurPrivs, 'a') then
    	    TmpStr := '`origin`="' + FPLogin + '" AND ';

				FPMainDataset.SQL.Text := 'SELECT ' + polink + '.*,Left(FirstName,1)AS FName,Left(MiddleName,1)AS MName,allusers.FamilyName FROM`' + polink + '`INNER JOIN`allusers`ON ' + polink + '.origin=allusers.login WHERE ' + TmpStr + '`status`=1';

  	    // filtering out -- begin of
    	  if FixedTimeFilter then begin
      	  TmpStr1 := GetFixedTimeInterval;
        	if TmpStr1 <> '' then
	      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`>DATE_SUB(CURDATE(),INTERVAL '+ TmpStr1 +')';
	      end
  	    else if ArbTimeFilter then begin
	  	    FormatString.LongDateFormat   := 'YYYYMMDD';
	    	  FormatString.ShortDateFormat  := 'YYYYMMDD';
        	if FilterDateStartEdit.Date <> 0 then begin
	      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`>=' + DateToStr(FilterDateStartEdit.Date, FormatString);
	        end;
  	      if FilterDateEndEdit.Date <> 0 then
	  	    	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`<=' + DateToStr(FilterDateEndEdit.Date+1, FormatString);
	      end; // if FixedTimeFilter then begin
      // filtering out -- end of
	      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY`index`DESC';// LOCK IN SHARE MODE';
  	    FPMainDataset.Open;
	      while not FPMainDataset.Eof do begin
  	      StrGrid.SplitRowCells(i);
    	    StrGrid.Cells[0, i] := rsRejdPORow;
      	  StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
	        StrGrid.Cells[2, i] := DateTimeToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
	        StrGrid.MergeCells(3, i, 4, 1);
  	      StrGrid.Cells[3, i] := FPMainDataset.FieldByName('re').AsString;
    	    TmpFloat := FPMainDataset.FieldByName('sumr').AsExtended;
      	  TmpPOSum := TmpPOSum + TmpFloat;
	        StrGrid.Cells[7, i] := MyFloatToStr(TmpFloat);
	        StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FName').AsString, FPMainDataset.FieldByName('MName').AsString);
	        StrGrid.Cells[9, i] := StringReplace(FPMainDataset.FieldByName('signature').AsString, '<br>', ' ', [rfReplaceAll]);
  	      Inc(i);
    	    Total := Total + TmpFloat;
      	  FPMainDataset.Next;
	      end; // while
  	    StrGrid.MergeCells(1, i, 9, 1);
    	  StrGrid.Cells[0, i] := '';
      	StrGrid.Cells[1, i] := '';
	      Inc(i);
  	    StrGrid.Cells[7,j] 	:= MyFloatToStr(TmpPOSum);
		  end;

		  if ShowAllPOs or ShowApprovedPOsOnly then begin
	      // APPROVED POs
    	  StrGrid.Cells[0, i] := rsAppdPOHeaderRow;
  	    StrGrid.MergeCells(1, i, 9, 1);
      	StrGrid.Cells[1, i] := rsAppdPOHeaderMain; //'В. Одобренные. В том числе срочные (выделены красным)';
	      Inc(i);

	      StrGrid.SplitRowCells(i);
  	    StrGrid.Cells[0, i] := rsAppdPOHeaderRow;
    	  StrGrid.Cells[1, i] := rsAppdPOHeaderNum;     //'№';
      	StrGrid.Cells[2, i] := rsAppdPOHeaderDate;    //'Дата';
	      StrGrid.Cells[3, i] := rsAppdPOHeaderSubj;    // 'Тема';
  	    StrGrid.MergeCells(3, i, 2, 1);
	      StrGrid.Cells[5, i] := rsAppdPOHeaderSum;     // 'Сумма';
	      StrGrid.Cells[6, i] := rsAppdPOHeaderSumA;    // 'Одобрено';
	      StrGrid.Cells[7, i] := rsAppdPOHeaderCash;    // 'Тип'
  	    StrGrid.Cells[8, i] := rsAppdPOHeaderAuth;    // 'Автор';
    	  StrGrid.Cells[9, i] := rsAppdPOHeaderFnd;     // 'Источник';
	      StrGrid.Cells[10, i] := '';
      	Inc(i);

        // add filtering line - APPROVED PO
        j := POFilters.IndexOf(rsAppdPOFilterRow);
			  if (j >= 0) and (j < POFilters.Count) then begin
        	FiltArray := PColFilters(POFilters.Objects[j]);
          bFiltering := true; //
        end
        else
          bFiltering := false;

				if bFiltering then begin
		      StrGrid.SplitRowCells(i);
  		    StrGrid.Cells[0, i] := rsAppdPOFilterRow;
	      	if FiltArray^[1] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftInt);
		        FiltArray^[1] := pfo;
        	end;
    		  StrGrid.Cells[1, i] := GetFilterState(StrGrid.Cells[0, i], 1); //'№';

	      	if FiltArray^[2] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftDates);
		        FiltArray^[2] := pfo;
        	end;
	      	StrGrid.Cells[2, i] := GetFilterState(StrGrid.Cells[0, i], 2); //'Дата';

		      StrGrid.MergeCells(3, i, 2, 1);
	      	if FiltArray^[3] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[3] := pfo;
        	end;
  		    StrGrid.Cells[3, i] := GetFilterState(StrGrid.Cells[0, i], 3); //'Тема';

	      	if FiltArray^[5] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftExt);
		        FiltArray^[5] := pfo;
        	end;
  	  	  StrGrid.Cells[5, i] := GetFilterState(StrGrid.Cells[0, i], 5); //'Сумма';

	      	if FiltArray^[6] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftExt);
		        FiltArray^[6] := pfo;
        	end;
  	  	  StrGrid.Cells[6, i] := GetFilterState(StrGrid.Cells[0, i], 6); //'Одобрено';

	      	if FiltArray^[7] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[7] := pfo;
        	end;
    		  StrGrid.Cells[7, i] := GetFilterState(StrGrid.Cells[0, i], 7); //'Тип'; Нал/Безнал

	      	if FiltArray^[8] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[8] := pfo;
        	end;
    		  StrGrid.Cells[8, i] := GetFilterState(StrGrid.Cells[0, i], 8); //'Автор'; Нал/Безнал

	      	if FiltArray^[9] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[9] := pfo;
        	end;
      		StrGrid.Cells[9, i] := GetFilterState(StrGrid.Cells[0, i], 9); //'Источник';
		      StrGrid.Cells[10, i] := '';
	    		Inc(i);
        end;

	      // total string
  	    StrGrid.SplitRowCells(i);
    	  StrGrid.MergeCells(1, i, 4, 1);
      	StrGrid.Cells[0, i] := rsAppdPOTotalRow;
	      StrGrid.Cells[1, i] := rsAppdPOHeaderTot;      // 'Итого'
  	    StrGrid.Cells[5, i] := '';
    	  StrGrid.Cells[6, i] := '';
      	StrGrid.MergeCells(7, i, 2, 1);
	      StrGrid.Cells[7, i] := '';
  	    j := i;
    	  TmpPOSum 	:= 0;
      	TmpPOSum1	:= 0;
	    	Inc(i);

  	    // security restrictions
        if PrivPresentMO(CurPrivs, 'a') then
      	   TmpStr := '`origin`="' + FPLogin + '" AND ';

				FPMainDataset.SQL.Text := 'SELECT ' + polink + '.*,Left(FirstName,1)AS FName,Left(MiddleName,1)AS MName,allusers.FamilyName FROM`' + polink + '`INNER JOIN`allusers`ON ' + polink + '.origin=allusers.login WHERE ' + TmpStr + '(`status`=2 OR `status`=4)';

    	  // filtering out -- begin of
	      if FixedTimeFilter then begin
  	      TmpStr1 := GetFixedTimeInterval;
      	  if TmpStr1 <> '' then
	      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`>DATE_SUB(CURDATE(),INTERVAL '+ TmpStr1 +')';
	      end
  	    else if ArbTimeFilter then begin
		      FormatString.LongDateFormat   := 'YYYYMMDD';
		      FormatString.ShortDateFormat  := 'YYYYMMDD';
    	    if FilterDateStartEdit.Date <> 0 then begin
	    	  	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`>=' + DateToStr(FilterDateStartEdit.Date, FormatString);
	        end;
  	      if FilterDateEndEdit.Date <> 0 then
	  	    	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`<=' + DateToStr(FilterDateEndEdit.Date+1, FormatString);
	      end; // if FixedTimeFilter then begin
	      // filtering out -- end of
  	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY`index`DESC';// LOCK IN SHARE MODE';
    	  FPMainDataset.Open;
	      while not FPMainDataset.Eof do begin
  	      StrGrid.SplitRowCells(i);
    	    if FPMainDataset.FieldByName('status').AsInteger = 4 then
      	    StrGrid.Cells[0, i] := rsAppdPOUrgentRow
        	else
	          StrGrid.Cells[0, i] := rsAppdPORow;
  	      StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
	        StrGrid.Cells[2, i] := DateTimeToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);

		      StrGrid.MergeCells(3, i, 2, 1);
  	      StrGrid.Cells[3, i] := FPMainDataset.FieldByName('re').AsString;
    	    TmpFloat := FPMainDataset.FieldByName('sumr').AsExtended;
      	  TmpPOSum := TmpPOSum + TmpFloat;
	        StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
  	      TmpFloat := FPMainDataset.FieldByName('suma').AsExtended;
    	    TmpPOSum1 := TmpPOSum1 + TmpFloat;
	        StrGrid.Cells[6, i] := MyFloatToStr(TmpFloat);
        	if FPMainDataset.FieldByName('bycash').AsInteger > 0 then
	        	StrGrid.Cells[7, i] := rsByCash
          else
	      	  StrGrid.Cells[7, i] := rsByBank;

  	      StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FName').AsString, FPMainDataset.FieldByName('MName').AsString);
  	      if FPMainDataset.FieldByName('fond').AsString = '0' then begin
        		StrGrid.Cells[9, i] := '';  // !!! *** !!!
          end
      	  else begin
          // here pulling of fund is to be done
	          StrGrid.Cells[9, i] := GetNameOfFondByLink(FondList, FPMainDataset.FieldByName('fond').AsString);
  	      end;
		      StrGrid.Cells[10, i] := '';
    	    Inc(i);
      	  Total := Total + TmpFloat;
        	FPMainDataset.Next;
	      end; // while
  	    StrGrid.MergeCells(1, i, 9, 1);
    	  StrGrid.Cells[0, i] := '';
      	StrGrid.Cells[1, i] := '';
	      Inc(i);
  	    StrGrid.Cells[5,j] 	:= MyFloatToStr(TmpPOSum);
    	  StrGrid.Cells[6,j] 	:= MyFloatToStr(TmpPOSum1);
		  end;

		  if ShowAllPOs or ShowPaidPOsOnly then begin
	      // Paid POs
  	    StrGrid.MergeCells(1, i, 9, 1);
    	  StrGrid.Cells[0, i] := rsPaidPOHeaderRow;
      	StrGrid.Cells[1, i] := rsPaidPOHeaderMain; // 'Г. Оплаченные. В том числе срочные (выделены красным)'
	      Inc(i);

	      StrGrid.SplitRowCells(i);
  	    StrGrid.Cells[ 0, i] := rsPaidPOHeaderRow;
    	  StrGrid.Cells[ 1, i] := rsPaidPOHeaderNum;  // '№';
      	StrGrid.Cells[ 2, i] := rsPaidPOHeaderDate; // 'Дата';
	      StrGrid.Cells[ 3, i] := rsPaidPOHeaderSubj; // 'Тема';
//  	    StrGrid.MergeCells(3, i, 2, 1);
	      StrGrid.Cells[ 4, i] := rsPaidPOHeaderFPNo; // 'Номер ФП';
	      StrGrid.Cells[ 5, i] := rsPaidPOHeaderPayDate;  // 'Дата оплаты';
	      StrGrid.Cells[ 6, i] := rsPaidPOHeaderSumP; // 'Оплачено';
  	    StrGrid.Cells[ 7, i] := rsPaidPOHeaderCash; // 'Тип'; Нал/Безнал
    	  StrGrid.Cells[ 8, i] := rsPaidPOHeaderAuth; // 'Автор';
      	StrGrid.Cells[ 9, i] := rsPaidPOHeaderFnd;  // 'Источник';
	      StrGrid.Cells[10, i] := rsPaidPOHeaderType;
	      Inc(i);

        // add filtering line - PAID PO
        j := POFilters.IndexOf(rsPaidPOFilterRow);
			  if (j >= 0) and (j < POFilters.Count) then begin
        	FiltArray := PColFilters(POFilters.Objects[j]);
          bFiltering := true; //
        end
        else
          bFiltering := false;

				if bFiltering then begin
		      StrGrid.SplitRowCells(i);
  		    StrGrid.Cells[0, i] := rsPaidPOFilterRow;
	      	if FiltArray^[1] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftInt);
		        FiltArray^[1] := pfo;
        	end;
    		  StrGrid.Cells[1, i] := GetFilterState(StrGrid.Cells[0, i], 1); //'№';

	      	if FiltArray^[2] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftDates);
		        FiltArray^[2] := pfo;
        	end;
	      	StrGrid.Cells[2, i] := GetFilterState(StrGrid.Cells[0, i], 2); //'Дата';

	      	if FiltArray^[3] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[3] := pfo;
        	end;
  		    StrGrid.Cells[3, i] := GetFilterState(StrGrid.Cells[0, i], 3); //'Тема';

	      	if FiltArray^[4] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftInt);
		        FiltArray^[4] := pfo;
        	end;
    		  StrGrid.Cells[4, i] := GetFilterState(StrGrid.Cells[0, i], 4); //'№ ФП';

	      	if FiltArray^[5] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftDates);
		        FiltArray^[5] := pfo;
        	end;
	      	StrGrid.Cells[5, i] := GetFilterState(StrGrid.Cells[0, i], 5); //'Дата оплаты';

	      	if FiltArray^[6] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftExt);
		        FiltArray^[6] := pfo;
        	end;
  	  	  StrGrid.Cells[6, i] := GetFilterState(StrGrid.Cells[0, i], 6); //'Оплачено';

	      	if FiltArray^[7] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[7] := pfo;
        	end;
    		  StrGrid.Cells[7, i] := GetFilterState(StrGrid.Cells[0, i], 7); //'Тип'; Нал/Безнал

	      	if FiltArray^[8] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[8] := pfo;
        	end;
    		  StrGrid.Cells[8, i] := GetFilterState(StrGrid.Cells[0, i], 8); //'Автор'; Нал/Безнал

	      	if FiltArray^[9] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[9] := pfo;
        	end;
      		StrGrid.Cells[9, i] := GetFilterState(StrGrid.Cells[0, i], 9); //'Источник';

	      	if FiltArray^[10] = nil then begin // we have to create filter if we don't have one.
		      	pfo := TFilterObject.Create;
	        	pfo.SetFilterType(ftStr);
		        FiltArray^[10] := pfo;
        	end;
      		StrGrid.Cells[10, i] := GetFilterState(StrGrid.Cells[0, i], 10); //'Источник';
	    		Inc(i);
        end;

        // total string
  	    StrGrid.SplitRowCells(i);
    	  StrGrid.MergeCells(1, i, 5, 1);
      	StrGrid.Cells[0, i] := rsPaidPOTotalRow;
	      StrGrid.Cells[1, i] := rsPaidPOHeaderTot;  // 'Итого';
//  	    StrGrid.Cells[5, i] := '';
    	  StrGrid.Cells[6, i] := '';
      	StrGrid.MergeCells(7, i, 2, 1);
	      StrGrid.Cells[7, i] := '';
  	    j := i;
      	TmpPOSum1	:= 0;
	    	Inc(i);

  	    // security restrictions
        if PrivPresentMO(CurPrivs, 'a') then
      	   TmpStr := '`origin`="' + FPLogin + '" AND ';

				FPMainDataset.SQL.Text := 'SELECT ' + polink + '.`index`,' + polink + '.`date`,' + polink + '.pd,' + polink + '.origin,' + polink + '.re,' + polink + '.sump,' + polink + '.status,' + polink + '.fond,' + polink + '.fp,' + polink + '.bycash,outopertype.name,Left(FirstName,1)AS FName,Left(MiddleName,1)AS MName,allusers.FamilyName FROM`' + polink + '`INNER JOIN`allusers`ON ' + polink + '.origin=allusers.login inner join outopertype on outopertype.`index`=' + polink + '.otid WHERE' + TmpStr + '(`status`=3 OR`status`=5)';

	      // filtering out -- begin of
  	    if FixedTimeFilter then begin
	        TmpStr1 := GetFixedTimeInterval;
  	      if TmpStr1 <> '' then
	  	    	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`>DATE_SUB(CURDATE(),INTERVAL '+ TmpStr1 +')';
      	end
	      else if ArbTimeFilter then begin
		      FormatString.LongDateFormat   := 'YYYYMMDD';
	  	    FormatString.ShortDateFormat  := 'YYYYMMDD';
      	  if FilterDateStartEdit.Date <> 0 then begin
	      		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`>='+ DateToStr(FilterDateStartEdit.Date, FormatString);
	        end;
  	      if FilterDateEndEdit.Date <> 0 then
	  	    	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND`date`<='+ DateToStr(FilterDateEndEdit.Date+1, FormatString);
	      end; // if FixedTimeFilter then begin
	      // filtering out -- end of
  	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY`index`DESC';// LOCK IN SHARE MODE';
    	  FPMainDataset.Open;
	      while not FPMainDataset.Eof do begin
  	      StrGrid.SplitRowCells(i);
    	    if FPMainDataset.FieldByName('status').AsInteger = 5 then
      	    StrGrid.Cells[0, i] := rsPaidPOUrgentRow
        	else
          	StrGrid.Cells[0, i] := rsPaidPORow;
	        StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
	        StrGrid.Cells[2, i] := DateTimeToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
//		      StrGrid.MergeCells(3, i, 2, 1);
    	    StrGrid.Cells[3, i] := FPMainDataset.FieldByName('re').AsString;
        	if FPMainDataset.FieldByName('fp').AsInteger <= 0 then
	        	StrGrid.Cells[4, i] := ''
          else
	      	  StrGrid.Cells[4, i] := IntToStr(FPMainDataset.FieldByName('fp').AsInteger);
					StrGrid.Cells[5, i] := DateTimeToStr(FPMainDataset.FieldByName('pd').AsDateTime, lFormatString);
          //
  	      TmpFloat := FPMainDataset.FieldByName('sump').AsExtended;
    	    TmpPOSum1 := TmpPOSum1 + TmpFloat;
	        StrGrid.Cells[6, i] := MyFloatToStr(TmpFloat);
        	if FPMainDataset.FieldByName('bycash').AsInteger > 0 then
	        	StrGrid.Cells[7, i] := rsByCash
          else
	      	  StrGrid.Cells[7, i] := rsByBank;
	        StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FName').AsString, FPMainDataset.FieldByName('MName').AsString);

  	      if FPMainDataset.FieldByName('fond').AsString = '0' then begin
        		StrGrid.Cells[9, i] := '';  // !!! *** !!!
          end
      	  else begin
        	  StrGrid.Cells[9, i] := GetNameOfFondByLink(FondList, FPMainDataset.FieldByName('fond').AsString);
	        end;

		      StrGrid.Cells[10, i] := FPMainDataset.FieldByName('name').AsString;

	        Inc(i);
  	      Total := Total + TmpFloat;
    	    FPMainDataset.Next;
      	end; // while
	      StrGrid.MergeCells(1, i, 9, 1);
  	    StrGrid.Cells[0, i] := '';
    	  StrGrid.Cells[1, i] := '';
      	Inc(i);
  	    StrGrid.Cells[6, j] := MyFloatToStr(TmpPOSum1);
		  end;

	    PostMessage(Self.Handle, UM_CFILTER_APPLIED, 0, 0);
      StrGrid.RowCount := i;
      if StrGrid.Row > i then
      	StrGrid.Row := i;
			// setting up buttons
	    if ShowAllPOs then begin
		  	SubmittedPOToolBtn.Enabled	:= true;
			  RejectedPOToolBtn.Enabled		:= true;
  			ApprovedPOToolBtn.Enabled		:= true;
			  PaidPOToolBtn.Enabled				:= true;
  	  end
    	else begin
	  		SubmittedPOToolBtn.Enabled	:= false;
			  RejectedPOToolBtn.Enabled		:= false;
  			ApprovedPOToolBtn.Enabled		:= false;
			  PaidPOToolBtn.Enabled				:= false;
	    end;
      FPMainDataset.Close;
      FPTmpDataset.Close;
    end; // case of 7 (POs)
    8 : begin // bank account or fund folder (entity with subentries)
      StrGrid.ColCount 	:= 5;
      StrGrid.RowCount	:= 2;
      StrGrid.FixedRows	:= 1;
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 20); //20;
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 200); //200;
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 300); //300;
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 300); //300;

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('№');
      StrGrid.ColumnHeaders.Add('Название');
      StrGrid.ColumnHeaders.Add('Баланс');
      StrGrid.ColumnHeaders.Add('Дата последней операции');

      // populating the table
      FPMainDataset.Close;
      FPMainDataset.SQL.Text := 'SELECT * FROM ' + CurTable + ' ORDER BY `index` ASC';
      FPMainDataset.Open;
      i := 1;
      while not FPMainDataset.Eof do begin
        tmpStr := Trim(FPMainDataset.FieldByName('name').AsAnsiString); //FPMainDataset.FieldByName('name').AsString;
        if LeftStr(tmpStr, 2) <> '<<' then begin
          StrGrid.SplitRowCells(i);
          StrGrid.Cells[0, i] := '';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
          StrGrid.Cells[2, i] := tmpStr;
          TmpFloat := FPMainDataset.FieldByName('balance').AsExtended;
          tmpStr := MyFloatToStr(TmpFloat);
          StrGrid.Cells[3, i] := tmpStr;
//          StrGrid.Cells[4, i] := FPMainDataset.FieldByName('lastdate').AsString;
          StrGrid.Cells[4, i] := DateTimeToStr(FPMainDataset.FieldByName('lastdate').AsDateTime, lFormatString);

          Inc(i);
          Total := Total + TmpFloat;
        end; // if FPMainDataset...
        FPMainDataset.Next;
      end; // while
      StrGrid.RowCount := i + 1;
      StrGrid.SplitRowCells(i);
      StrGrid.Cells[0, i] := '';
      StrGrid.MergeCells(1, i, 2, 1);
      StrGrid.Cells[1, i] := 'Всего:';
      StrGrid.Cells[3, i] := MyFloatToStr(Total);
      StrGrid.Cells[4, i] := '';
//      inc(i);
      StrGrid.RowCount := i + 1;
    end;
    9 : begin    // bank account or fund itself
      StrGrid.ColCount 	:= 7;
      StrGrid.RowCount	:= 3;
      //      filling the table
      FPMainDataset.Close;
      FPMainDataset.SQL.Text := 'SELECT * FROM ' + CurTable + ' WHERE `in` IS NOT NULL';
      if FixedTimeFilter then begin
        TmpStr1 := GetFixedTimeInterval;
        if TmpStr1 <> '' then
	      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND lastdate>DATE_SUB(CURDATE(),INTERVAL '+ TmpStr1 +')';
      end
      else if ArbTimeFilter then begin
	      FormatString.LongDateFormat   := 'YYYYMMDD';
	      FormatString.ShortDateFormat  := 'YYYYMMDD';
        if FilterDateStartEdit.Date <> 0 then begin
	      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND lastdate>='+ //DayToStr(FilterDateStartEdit.Date, '-');
	          DateToStr(FilterDateStartEdit.Date, FormatString);
        end;
        if FilterDateEndEdit.Date <> 0 then
	      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND lastdate<='+ //DayToStr(FilterDateEndEdit.Date, '-');
	          DateToStr(FilterDateEndEdit.Date+1, FormatString);
      end;

      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' ORDER BY `index` DESC';
      FPMainDataset.Open;
      StrGrid.FixedRows := 1 + integer(FPMainDataset.RecordCount > 0);
      // Setting up header
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 20); 	//20;
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 120); //120;
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 300); //300;
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 150); //150;
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 150); //150;
      StrGrid.ColWidths[6]  := ReadColWidth(sIniSection, 6, 150); //150;

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('№');
      StrGrid.ColumnHeaders.Add('Дата');
      StrGrid.ColumnHeaders.Add('Описание');
      StrGrid.ColumnHeaders.Add('Приход');
      StrGrid.ColumnHeaders.Add('Расход');
      StrGrid.ColumnHeaders.Add('Баланс');

    // setting the heading
      Total := 0;
      // adding the button if there is no actives
      StrGrid.MergedColumns.Clear;
      i := 1;

      if not FPMainDataset.Eof then
	      Total := FPMainDataset.FieldByName('Balance').AsExtended
      else
	      Total	:= 0;

      // balance
      StrGrid.SplitRowCells(i);
      StrGrid.Cells[0, i] := '';
      StrGrid.MergeCells(1, i, 5, 1);
      StrGrid.Cells[1, i] := 'Общий баланс:';
      StrGrid.Cells[6, i] := MyFloatToStr(Total);
      inc(i);
      while not FPMainDataset.Eof do begin
        if FPMainDataset.FieldByName('index').AsInteger > 0 then begin
          StrGrid.SplitRowCells(i);
          StrGrid.Cells[0, i] := '';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
//          StrGrid.Cells[2, i] := FPMainDataset.FieldByName('lastdate').AsString;
          StrGrid.Cells[2, i] := DateTimeToStr(FPMainDataset.FieldByName('lastdate').AsDateTime, lFormatString);

//          Total := Total + TmpFloat;
          tmpStr := MyFloatToStr(TmpFloat);
//          StrGrid.Cells[3, i] := StringReplace(FPMainDataset.FieldByName('data').AsString, CRLF, ' ', [rfReplaceAll]);
          //StrGrid.Cells[3, i] := MyCleanStr(FPMainDataset.FieldByName('data').AsString, UC_KEEPDOTS);
          StrGrid.Cells[3, i] := MyCleanStr(Trim(FPMainDataset.FieldByName('data').AsAnsiString), UC_KEEPDOTS);
          TmpFloat := FPMainDataset.FieldByName('in').AsExtended;
          if TmpFloat <> 0 then begin
            StrGrid.Cells[4, i] := MyFloatToStr(TmpFloat);
          end
          else
            StrGrid.Cells[4, i] := '';
          TmpFloat := FPMainDataset.FieldByName('out').AsExtended;
          if TmpFloat <> 0 then begin
            StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
          end
          else
            StrGrid.Cells[5, i] := '';
          TmpFloat := FPMainDataset.FieldByName('Balance').AsExtended;
          StrGrid.Cells[6, i] := MyFloatToStr(TmpFloat);
          Inc(i);
          Total := TmpFloat;
        end; // if FPMainDataset...
        FPMainDataset.Next;
      end; // while
			StrGrid.RowCount := i;
      if StrGrid.RowCount > 2 then
				StrGrid.FixedRows := 2;
    end; // case of 9

    13 : begin  // case of 13 - Debtors
      StrGrid.ColCount 	:= 9;
      StrGrid.RowCount	:= 2;
			StrGrid.FixedRows := 1;
      StrGrid.ColWidths[0]  := 0;           //
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 20); //20;          //  '№'
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 120); //120;         //  'Дата операции'
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 120); //120;         //  'Отгружено'
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 300); //300;         //  'Описание'
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 100); //100;         //  'Сумма'
      StrGrid.ColWidths[6]  := ReadColWidth(sIniSection, 6, 100); //100;         //  'До даты'
      StrGrid.ColWidths[7]  := ReadColWidth(sIniSection, 7, 150); //150;         //  'Дебитор'
      StrGrid.ColWidths[8]  := ReadColWidth(sIniSection, 8, 150); //150;         //  'Автор'

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('№');
      StrGrid.ColumnHeaders.Add('Дата операции');
      StrGrid.ColumnHeaders.Add('Отгружено');
      StrGrid.ColumnHeaders.Add('Описание');
      StrGrid.ColumnHeaders.Add('Сумма');
      StrGrid.ColumnHeaders.Add('До даты');
      StrGrid.ColumnHeaders.Add('Дебитор');
      StrGrid.ColumnHeaders.Add('Автор');
      //  filling the table
      // green debts
      StrGrid.MergeCells(1, 1, 7, 1);
      StrGrid.Cells[0, 1] := 'h_green';
      gp := 1;
      Total := 0;

    	cplink := CurPrefix + 'tocollect';
      dclink := CurPrefix + 'debtor';
      fplink := CurPrefix + 'fp';
//      FPMainDataset.SQL.Text := 'SELECT * FROM ' + cplink + ' WHERE `paydate`>NOW() AND `status`="0" AND `closed`>-1 ORDER BY `index` DESC';
      FPMainDataset.SQL.Text := 'SELECT ' + cplink + '.*,users.FamilyName,users.FirstName,users.MiddleName FROM ' + cplink + ' LEFT JOIN users ON ' + cplink + '.UserID=users.UserID WHERE `paydate`>NOW()AND`status`="0" AND `closed`>-1 ORDER BY `index` DESC';
      FPMainDataset.Open;
      StrGrid.MergedColumns.Clear;
      i := 2;
      while not FPMainDataset.Eof do begin
        j := FPMainDataset.FieldByName('debtor').AsInteger; // FPMainDataset.FieldByName('index').AsInteger;
        FPTmpDataset.SQL.Text := 'SELECT `name`,`status` FROM ' + dclink + ' WHERE `index`=' + IntToStr(j);
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then begin
          StrGrid.SplitRowCells(i);
          StrGrid.Cells[0, i] := 'green';
//          StrGrid.Cells[0, i] := '';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
          StrGrid.Cells[2, i] := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
          StrGrid.Cells[3, i] := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);

          StrGrid.Cells[4, i] := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat - FPMainDataset.FieldByName('closed').AsFloat;
          StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
          StrGrid.Cells[6, i] := FPMainDataset.FieldByName('paydate').AsString;
          StrGrid.Cells[7, i] := Trim(FPTmpDataset.FieldByName('name').AsAnsiString);
          StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);
          Inc(i);
          Total := Total + TmpFloat;
          FPTmpDataset.Next;
        end;
        FPMainDataset.Next;
      end; // while
      StrGrid.Cells[1, gp]  := 'A. Текущая дебиторка. Общая сумма: ' + MyFloatToStr(Total);
      Total := 0;
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      Inc(i);

      // Yellow debts
      // header
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      gp := i;
      StrGrid.Cells[0, i] := 'h_red';
      inc(i);

      StrGrid.MergedColumns.Clear;
      FPMainDataset.SQL.Text := 'SELECT ' + cplink + '.*,users.FamilyName,users.FirstName,users.MiddleName FROM`' + cplink + '`LEFT JOIN`users`ON`' + cplink + '`.UserID=`users`.UserID WHERE(`paydate`<=NOW() OR `paydate`=NULL) AND `status`<"2" AND closed>-1 ORDER BY `index` DESC';
      FPMainDataset.Open;
      while not FPMainDataset.Eof do begin
        j := FPMainDataset.FieldByName('debtor').AsInteger;
        FPTmpDataset.SQL.Text := 'SELECT `name`,`status` FROM ' + dclink + ' WHERE `index`=' + IntToStr(j);
        FPTmpDataset.Open;
        while not FPTmpDataset.Eof do begin
          StrGrid.SplitRowCells(i);
          StrGrid.Cells[0, i] := 'red';
//          StrGrid.Cells[0, i] := '';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
          StrGrid.Cells[2, i] := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
          StrGrid.Cells[3, i] := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);

          StrGrid.Cells[4, i] := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
          if FPMainDataset.FieldByName('closed').AsFloat > -1 then
	          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat - FPMainDataset.FieldByName('closed').AsFloat
          else
	          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat;
          StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
          StrGrid.Cells[6, i] := FPMainDataset.FieldByName('paydate').AsString;
          StrGrid.Cells[7, i] := FPTmpDataset.FieldByName('name').AsString;
          StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);

          Inc(i);
          Total := Total + TmpFloat;
          FPTmpDataset.Next;
        end;
        FPMainDataset.Next;
      end; // while
      StrGrid.Cells[1, gp] := 'Б. Просроченная. Общая сумма: ' + MyFloatToStr(Total);
      Total := 0;
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      Inc(i);

      // Red debts
      // header
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := 'В. Безнадежная. Общая сумма: ' + MyFloatToStr(Total);
      gp := i;
      StrGrid.Cells[0, i] := 'h_blue';
      inc(i);

      FPMainDataset.SQL.Text := 'SELECT`' + cplink + '`.*,users.FamilyName,users.FirstName,users.MiddleName FROM`' + cplink + '`LEFT JOIN`users`ON`' + cplink + '`.UserID=`users`.UserID WHERE `paydate`<=NOW() AND `status`="3" and `closed`>-1 ORDER BY `index` DESC';
      FPMainDataset.Open;
      StrGrid.MergedColumns.Clear;
      while not FPMainDataset.Eof do begin
        j := FPMainDataset.FieldByName('debtor').AsInteger;
        FPTmpDataset.SQL.Text := 'SELECT `name`,`status` FROM ' + dclink + ' WHERE `index`=' + IntToStr(j);
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then begin
          StrGrid.SplitRowCells(i);
          StrGrid.Cells[0, i] := 'blue';
//          StrGrid.Cells[0, i] := '';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
          StrGrid.Cells[2, i] := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
          StrGrid.Cells[3, i] := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);

          StrGrid.Cells[4, i] := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
          if FPMainDataset.FieldByName('closed').AsFloat > -1 then
	          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat - FPMainDataset.FieldByName('closed').AsFloat
          else
	          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat;
          StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
          StrGrid.Cells[6, i] := FPMainDataset.FieldByName('paydate').AsString;
          StrGrid.Cells[7, i] := FPTmpDataset.FieldByName('name').AsString;
	        StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);
          Inc(i);
          Total := Total + TmpFloat;
          FPTmpDataset.Next;
        end;
        FPMainDataset.Next;
      end; // while
      StrGrid.Cells[0, i] := '';
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      Inc(i);
      total := 0;

      // gray debts
      // header
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      gp := i;
      StrGrid.Cells[0, i] := 'h_gray';
      inc(i);

      FPMainDataset.SQL.Text := 'SELECT `from` FROM ' + fplink + ' ORDER BY `index` DESC LIMIT 1';
      FPMainDataset.Open;
      if FPMainDataset.RecordCount > 0 then
        tmpStr := FPMainDataset.FieldByName('from').AsString
      else
        tmpStr := '';

      FPMainDataset.SQL.Text := 'SELECT`' + cplink + '`.*,users.FamilyName,users.FirstName,users.MiddleName FROM`' + cplink + '`LEFT JOIN`users`ON`' + cplink + '`.UserID=`users`.UserID WHERE `lastdate`>"' + tmpStr + '" AND `status`="2" ORDER BY `index` DESC';
      FPMainDataset.Open;
      StrGrid.MergedColumns.Clear;
      while not FPMainDataset.Eof do begin
        j := FPMainDataset.FieldByName('debtor').AsInteger;
        FPTmpDataset.SQL.Text := 'SELECT `name`, `status` FROM ' + dclink + ' WHERE `index`=' + IntToStr(j);
        FPTmpDataset.Open;
        if not FPTmpDataset.Eof then begin
          StrGrid.SplitRowCells(i);
//          StrGrid.Cells[0, i] := '';
          StrGrid.Cells[0, i] := 'gray';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
          StrGrid.Cells[2, i] := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
          StrGrid.Cells[3, i] := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);

          StrGrid.Cells[4, i] := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
          if FPMainDataset.FieldByName('closed').AsFloat >= 0 then
	          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat - FPMainDataset.FieldByName('closed').AsFloat
          else
	          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat;
          StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
          StrGrid.Cells[6, i] := FPMainDataset.FieldByName('paydate').AsString;
          StrGrid.Cells[7, i] := FPTmpDataset.FieldByName('name').AsString;
	        StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);
          Inc(i);
          Total := Total + TmpFloat;
          FPTmpDataset.Next;
        end;
        FPMainDataset.Next;
      end; // while
      StrGrid.Cells[1, gp] := 'Г. Собранная с последнего ФП. Общая сумма: ' + MyFloatToStr(Total);
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      Inc(i);
      StrGrid.RowCount := i;
    end; // case of 13 - debtors

    14 : begin  // case of 14 - creditors
//      StrGrid.ColCount := 7;
      StrGrid.ColCount := 9;
      StrGrid.RowCount	:= 2;
			StrGrid.FixedRows := 1;
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 20); //20;        	//  '№'
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 120); //120;        //  'Дата операции'
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 120); //300;        // 'Получено'
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 300); //100;        //  'Описание'
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 100); //100;        //  'Сумма'
      StrGrid.ColWidths[6]  := ReadColWidth(sIniSection, 6, 100); //150;        //  'До даты'
      StrGrid.ColWidths[7]  := ReadColWidth(sIniSection, 7, 150); //150;        //  'До даты'
      StrGrid.ColWidths[8]  := ReadColWidth(sIniSection, 8, 150); //150;        //  'Автор'

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('№');
      StrGrid.ColumnHeaders.Add('Дата операции');
      StrGrid.ColumnHeaders.Add('Получено');
      StrGrid.ColumnHeaders.Add('Описание');
      StrGrid.ColumnHeaders.Add('Сумма');
      StrGrid.ColumnHeaders.Add('До даты');
      StrGrid.ColumnHeaders.Add('Кредитор');
      StrGrid.ColumnHeaders.Add('Автор');

      //  filling the table
      // green debts
      StrGrid.MergeCells(1, 1, 7, 1);
      StrGrid.Cells[0, 1] := 'h_green';
//			StrGrid.FixedRows := 1;
      gp := 1;
      Total := 0;

    	cplink := CurPrefix + 'topay';
      dclink := CurPrefix + 'creditor';
      fplink := CurPrefix + 'fp';

      // caching company name
      FPMainDataset.SQL.Text := 'SELECT`index`,`name`FROM`' + dclink + '`ORDER BY`index`';
      FPMainDataset.Open;
      while not FPMainDataset.Eof do begin
        j := FPMainDataset.FieldByName('index').AsInteger;
        if(Length(ArrCompanyName) < j + 1) then begin
        	SetLength(ArrCompanyName,   j + 1);
          ArrCompanyName[j]   := FPMainDataset.FieldByName('name').AsString;
        end;
      	FPMainDataset.Next;
      end;

      FPMainDataset.SQL.Text := 'SELECT`' + cplink + '`.*,users.FamilyName,users.FirstName,users.MiddleName FROM`' + cplink + '`LEFT JOIN`users`ON`' + cplink + '`.UserID=`users`.UserID WHERE `paydate`>NOW() AND `status`<>"2" ORDER BY `paydate`';// DESC';
      FPMainDataset.Open;
      StrGrid.MergedColumns.Clear;
      i := 2;
      while not FPMainDataset.Eof do begin
        j := FPMainDataset.FieldByName('creditor').AsInteger;
        if (j > 0) and (j < Length(ArrCompanyName)) and (ArrCompanyName[j] <> '') then begin
          StrGrid.SplitRowCells(i);
          StrGrid.Cells[0, i] := 'yellow';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
          StrGrid.Cells[2, i] := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
          StrGrid.Cells[3, i] := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);
          StrGrid.Cells[4, i] := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat - FPMainDataset.FieldByName('closed').AsFloat;
          StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
          StrGrid.Cells[6, i] := FPMainDataset.FieldByName('paydate').AsString;
          StrGrid.Cells[7, i] := ArrCompanyName[j];
	        StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);
          Inc(i);
          Total := Total + TmpFloat;
        end;
        FPMainDataset.Next;
      end; // while
      StrGrid.Cells[1, gp]  := 'A. Текущая. Общая сумма: ' + MyFloatToStr(Total);
      Total := 0;
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      Inc(i);

      // Yellow debts
      // header
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      gp := i;
      StrGrid.Cells[0, i] := 'h_red';
      inc(i);

      FPMainDataset.SQL.Text := 'SELECT`' + cplink + '`.*,users.FamilyName,users.FirstName,users.MiddleName FROM`' + cplink + '`LEFT JOIN`users`ON`' + cplink + '`.UserID=`users`.UserID WHERE `paydate`<=NOW() AND `status`<>"2" ORDER BY `paydate`';// DESC';
      FPMainDataset.Open;
      StrGrid.MergedColumns.Clear;
      while not FPMainDataset.Eof do begin
        j := FPMainDataset.FieldByName('creditor').AsInteger;
        if (j > 0) and (j < Length(ArrCompanyName)) and (ArrCompanyName[j] <> '') then begin
          StrGrid.SplitRowCells(i);
          StrGrid.Cells[0, i] := 'red';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
          StrGrid.Cells[2, i] := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
          StrGrid.Cells[3, i] := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);
          StrGrid.Cells[4, i] := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat - FPMainDataset.FieldByName('closed').AsFloat;
          StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
          StrGrid.Cells[6, i] := FPMainDataset.FieldByName('paydate').AsString;
          StrGrid.Cells[7, i] := ArrCompanyName[j];
	        StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);
          Inc(i);
          Total := Total + TmpFloat;
          end;
        FPMainDataset.Next;
      end; // while
      StrGrid.Cells[1, gp] := 'Б. Просроченная. Общая сумма: ' + MyFloatToStr(Total);
      Total := 0;
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      Inc(i);

      // Red debts
      // header
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[1, i] := '';
      gp := i;
      StrGrid.Cells[0, i] := 'h_gray';
      inc(i);

      FPMainDataset.SQL.Text := 'SELECT`' + cplink + '`.*,users.FamilyName,users.FirstName,users.MiddleName FROM`' + cplink + '`LEFT JOIN`users`ON`' + cplink + '`.UserID=`users`.UserID WHERE `status` = "2" ORDER BY `paydate`';// DESC';
      FPMainDataset.Open;
      StrGrid.MergedColumns.Clear;
      while not FPMainDataset.Eof do begin
        j := FPMainDataset.FieldByName('creditor').AsInteger;
        if (j > 0) and (j < Length(ArrCompanyName)) and (ArrCompanyName[j] <> '') then begin
          StrGrid.SplitRowCells(i);
          StrGrid.Cells[0, i] := 'gray';
          StrGrid.Cells[1, i] := FPMainDataset.FieldByName('index').AsString;
          StrGrid.Cells[2, i] := DateToStr(FPMainDataset.FieldByName('date').AsDateTime, lFormatString);
          StrGrid.Cells[3, i] := DateToStr(FPMainDataset.FieldByName('shipdate').AsDateTime, lFormatString);
          StrGrid.Cells[4, i] := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', CRLF);
                                                                 // - we need summ field only
          TmpFloat := FPMainDataset.FieldByName('summ').AsFloat; // - FPMainDataset.FieldByName('closed').AsFloat;
          StrGrid.Cells[5, i] := MyFloatToStr(TmpFloat);
          StrGrid.Cells[6, i] := FPMainDataset.FieldByName('paydate').AsString;
          StrGrid.Cells[7, i] := ArrCompanyName[j];
	        StrGrid.Cells[8, i] := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString, FPMainDataset.FieldByName('MiddleName').AsString);
          Inc(i);
          Total := Total + TmpFloat;
        end;
        FPMainDataset.Next;
      end; // while
      StrGrid.Cells[1, gp] := 'В. Закрытая. Общая сумма: ' + MyFloatToStr(Total);
      StrGrid.MergeCells(1, i, 7, 1);
      StrGrid.Cells[1, i] := '';
      StrGrid.Cells[0, i] := '';
      Inc(i);
      StrGrid.RowCount := i;
    end; // case of 14 - creditors
		101,100 : begin  // case of LIST_DEBITORS, LIST_CREDITORS
      //  filling the table
      // green debts
      Total := 0;

     	if CurValue = LIST_DEBITORS then begin
	    	cplink := CurPrefix + 'tocollect';
  	    dclink := CurPrefix + 'debtor';
	      FPMainDataset.SQL.Text :=
'SELECT ' + dclink + '.*, sums.amnt FROM ' + dclink + ' LEFT JOIN' +
'(SELECT ' + dclink + '.`index` AS `idx1`,SUM(summ - closed) AS amnt FROM ' + dclink + ' RIGHT JOIN ' + cplink + ' ON ' + dclink + '.`index`=' + cplink + '.debtor WHERE closed <> -1 GROUP BY `idx1`) as sums ' +
'ON ' + dclink + '.`index`=idx1 ORDER by ' + dclink + '.name';
      end
      else begin
				cplink := CurPrefix + 'topay';
				dclink := CurPrefix + 'creditor';
	      FPMainDataset.SQL.Text :=
'SELECT ' + dclink + '.*, sums.amnt FROM ' + dclink + ' LEFT JOIN' +
'(SELECT ' + dclink + '.`index` AS `idx1`,SUM(summ - closed) AS amnt FROM ' + dclink + ' RIGHT JOIN ' + cplink + ' ON ' + dclink + '.`index`=' + cplink + '.creditor WHERE closed <> -1 GROUP BY `idx1`) as sums ' +
'ON ' + dclink + '.`index`=idx1 ORDER by ' + dclink + '.name';

      end;

      FPMainDataset.Open;
    	if CurValue = LIST_DEBITORS then
     		GridGroupBox.Caption := 'Дебиторы'
      else
     		GridGroupBox.Caption := 'Кредиторы';

      if FPMainDataset.RecordCount > 0 then begin
        StrGrid.RowCount	:= 3;
	  		StrGrid.FixedRows := 2;
      end
      else begin
        StrGrid.RowCount	:= 2;
	  		StrGrid.FixedRows := 1;
      end;
      StrGrid.ColCount := 6;
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 300); //300;
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 120); //120;
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 220); //220;
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 120); //120;
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 120); //120;
      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('Название');
      StrGrid.ColumnHeaders.Add('Телефон');
      StrGrid.ColumnHeaders.Add('Контактное лицо');
      StrGrid.ColumnHeaders.Add('Статус');
      StrGrid.ColumnHeaders.Add('Задолженность');

      i := 1;
      StrGrid.SplitRowCells(i);
      StrGrid.MergeCells(1, i, 4, 1);
      StrGrid.Cells[1, i] := 'Итого:';
      Inc(i);

      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      StrGrid.Cells[2, i] := '';
      StrGrid.Cells[3, i] := '';
      StrGrid.Cells[4, i] := '';
      StrGrid.Cells[5, i] := '';

      while not FPMainDataset.Eof do begin
	      StrGrid.MergedColumns.Clear;
        StrGrid.SplitRowCells(i);
      	StrGrid.Cells[0, i] := FPMainDataset.FieldByName('index').AsString;
      	StrGrid.Cells[1, i] := FPMainDataset.FieldByName('name').AsString;
      	StrGrid.Cells[2, i] := FPMainDataset.FieldByName('phone').AsString;
      	StrGrid.Cells[3, i] := FPMainDataset.FieldByName('who').AsString;
	     	if CurValue = LIST_DEBITORS then
      	  StrGrid.Cells[4, i] := GetDebtorStatusStr(FPMainDataset.FieldByName('status').AsInteger)
        else
	      	StrGrid.Cells[4, i] := GetCreditorStatusStr(FPMainDataset.FieldByName('status').AsInteger);


      	StrGrid.Cells[5, i] := MyFloatToStr(FPMainDataset.FieldByName('amnt').AsFloat);
        Total := Total + FPMainDataset.FieldByName('amnt').AsFloat;
        Inc(i);
        FPMainDataset.Next;
      end;
      StrGrid.Cells[5, 1] := MyFloatToStr(Total);

      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      StrGrid.Cells[2, i] := '';
      StrGrid.Cells[3, i] := '';
      StrGrid.Cells[4, i] := '';
      StrGrid.Cells[5, i] := '';
      StrGrid.RowCount := i;
    end; // case of 101,100 (LIST_DEBITORS)
		LIST_PERSONS : begin  // case of LIST_PERSONS
      //  filling the table
      // green debts
      Total := 0;
   		GridGroupBox.Caption := rsListPersons;

      cplink := CurPrefix + 'persons';
//      FPMainDataset.SQL.Text := 'SELECT * FROM`' + cplink + '`ORDER by FamilyName,FirstName,MiddleName';

FPMainDataset.SQL.Text :=
//'SELECT persons.idx,persons.FamilyName,(SELECT balance FROM`person_balances`WHERE`person_balances`.`PersonID`=Persons.idx ORDER BY `person_balances`.idx DESC LIMIT 1) AS balance FROM persons';
'SELECT persons.*,(SELECT balance FROM`person_balances`WHERE`person_balances`.`PersonID`=Persons.idx ORDER BY `person_balances`.idx DESC LIMIT 1) AS balance FROM persons ORDER BY FamilyName,FirstName,MiddleName';

      FPMainDataset.Open;

      if FPMainDataset.RecordCount > 0 then begin
        StrGrid.RowCount	:= 3;
	  		StrGrid.FixedRows := 1;
      end
      else begin
        StrGrid.RowCount	:= 2;
	  		StrGrid.FixedRows := 1;
      end;
      // FIO, Address, Mobile, e-mail, account
      StrGrid.ColCount := 6;
      StrGrid.ColWidths[0]  := 0;
      StrGrid.ColWidths[1]  := ReadColWidth(sIniSection, 1, 120); //300;
      StrGrid.ColWidths[2]  := ReadColWidth(sIniSection, 2, 120); //120;
      StrGrid.ColWidths[3]  := ReadColWidth(sIniSection, 3, 120); //220;
      StrGrid.ColWidths[4]  := ReadColWidth(sIniSection, 4, 120); //120;
      StrGrid.ColWidths[5]  := ReadColWidth(sIniSection, 5, 120); //120;

      StrGrid.ColumnHeaders.Clear;
      StrGrid.ColumnHeaders.Add('');
      StrGrid.ColumnHeaders.Add('ФИО');
      StrGrid.ColumnHeaders.Add('Адрес');
      StrGrid.ColumnHeaders.Add('Телефон');
      StrGrid.ColumnHeaders.Add('Эл. почта');
      StrGrid.ColumnHeaders.Add('На счете');

      i := 1;
//      StrGrid.SplitRowCells(i);
//      StrGrid.MergeCells(1, i, 4, 1);
//      StrGrid.Cells[1, i] := 'Итого:';
//      Inc(i);

      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      StrGrid.Cells[2, i] := '';
      StrGrid.Cells[3, i] := '';
      StrGrid.Cells[4, i] := '';
      StrGrid.Cells[5, i] := '';

      while not FPMainDataset.Eof do begin
	      StrGrid.MergedColumns.Clear;
        StrGrid.SplitRowCells(i);
        with FPMainDataset do begin
          StrGrid.Cells[0, i] := FieldByName('idx').AsString;
          StrGrid.Cells[1, i] := GetShortFIO(FieldByName('FamilyName').AsString,FieldByName('FirstName').AsString,FieldByName('MiddleName').AsString);
          StrGrid.Cells[2, i] := FieldByName('Address').AsString;
          StrGrid.Cells[3, i] := FieldByName('PhoneMobile').AsString;
          StrGrid.Cells[4, i] := FieldByName('email').AsString;
          StrGrid.Cells[5, i] := MyFloatToStr(FieldByName('balance').AsExtended);
  //      	StrGrid.Cells[4, i] := GetCreditorStatusStr(FPMainDataset.FieldByName('status').AsInteger);
//          StrGrid.Cells[5, i] := MyFloatToStr(FPMainDataset.FieldByName('amnt').AsFloat);
//          Total := Total + FPMainDataset.FieldByName('amnt').AsFloat;
          Inc(i);
          Next;
        end;
      end;
      StrGrid.Cells[5, 1] := MyFloatToStr(Total);

      StrGrid.Cells[0, i] := '';
      StrGrid.Cells[1, i] := '';
      StrGrid.Cells[2, i] := '';
      StrGrid.Cells[3, i] := '';
      StrGrid.Cells[4, i] := '';
      StrGrid.Cells[5, i] := '';
      StrGrid.RowCount := i;
    end; // case of LIST_PERSONS

  end;

//  StrGrid.RowCount := i;
//  CurGridRows := StrGrid.RowCount;
  StrGrid.EndUpdate;

  if (StrGrid.CanFocus) and (StrGrid.Parent <> nil) then begin
  	StrGrid.SearchPanel.Repaint;
	  //StrGrid.SetFocus;
  end;
end;

procedure TMainFPForm.ReviewPOPopUpClick(Sender: TObject);
var
  POApproveForm: TPOApproveForm;
	CSWText		: string;
  PONum			: integer;
  PODate    : string;
  OrigPost	: string;
  OrigName	: string;
  RPPrefix  : string;
  RPPrefixID: integer;
  NoError   : boolean;
  asslink   : string;
  POStatus  : integer;

begin
	if CurPONum > 0 then
		PONum	:= CurPONum
  else
  	exit;

	POApproveForm := TPOApproveForm.Create(Self);

  RPPrefix   := CurPrefix;
  RPPrefixID := CurOInd;


  POApproveForm.CAPrefix   := RPPrefix;
  POApproveForm.CAPrefixID := RPPrefixID;

  POApproveForm.WithFndr := PrivPresentMO(CurPrivs, 'b0');

  NoError := true;
  FPMainDataset.SQL.Text := 'BEGIN';
  try
 	  FPMainDataset.ExecSQL;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, 'Невозможно инициализировать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
      NoError := false;
    end;
  end;

  if not NoError  then begin
    FPMainDataset.SQL.Text := 'ROLLBACK';
  	try
 	    FPMainDataset.ExecSQL;
    finally

    end;
    Exit;
  end;

	FPTmpDataset.SQL.Text := 'SELECT * FROM`' + RPPrefix + 'po`WHERE`index`=' + IntToStr(PONum);
  try
  	FPTmpDataset.Open;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, 'Ошибка подключения к серверу.', e.ErrorCode, e.StatusCode, e.Message);
      Exit;
    end;
  end;

  // check if it's locked
  if NoError and (FPTmpDataset.RecordCount > 0) and (not FPTmpDataset.FieldByName('rsvdby').IsNull) then begin
    // and if it is
    FPMainDataset.SQL.Text := 'SELECT FirstName,MiddleName,FamilyName FROM users WHERE UserID=:fUID';
    FPMainDataset.ParamByName('fUID').AsInteger := FPTmpDataset.FieldByName('rsvdby').AsInteger;
    try
      FPMainDataset.Open;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'При попытке получить данные о блокировке заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    	  Exit;
      end;
    end;

    Application.MessageBox(PWideChar('С заявкой № ' + IntToStr(PONum) + ' уже работает пользователь ' +
                GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString,FPMainDataset.FieldByName('MiddleName').AsString) + CRLF + 'Повторите попытку позже.'), 'Работа с заявкой', MB_OK or MB_ICONERROR);

    FPMainDataset.SQL.Text := 'ROLLBACK';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'При попытке разблокировки заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      end;
    end;
    // destroy form and leave it
    POApproveForm.Free;
    Exit;
  end // if NoError and (FPMainDataset.RecordCount > 0)
  else begin
    // if it's not locked then we lock it!
    FPMainDataset.SQL.Text := 'UPDATE`' + RPPrefix + 'po`SET rsvdby=:fUID,dtby=DATE_ADD(NOW(),INTERVAL 1 MINUTE)WHERE`index`=:fPOID';
    FPMainDataset.ParamByName('fUID').AsInteger  := FPUserID;
    FPMainDataset.ParamByName('fPOID').AsInteger := PONum;
    try
      FPMainDataset.ExecSQL;
    except
 	    on e: EZSQLException do begin
	      ShowError(Self, 'Невозможно заблокировать заявку.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;

    if NoError then begin
  		FPMainDataset.SQL.Text := 'COMMIT';
  	  try
 	  		FPMainDataset.ExecSQL;
      except
 				on e: EZSQLException do begin
	  			ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
        end;
      end;
    end; // if NoError
    if not NoError then begin
  		FPMainDataset.SQL.Text := 'ROLLBACK';
  	  try
 	  		FPMainDataset.ExecSQL;
      finally

      end;
      Exit;
    end; // else for if NoError
  end; // else begin

	POApproveForm.PONumEdit.Text   := IntToStr(PONum);
	POApproveForm.POSumEdit.Text   := MyFloatToStr(FPTmpDataset.FieldByName('sumr').AsFloat);
	POApproveForm.SubjectEdit.Text := FPTmpDataset.FieldByName('re').AsString;
	POStatus                       := FPTmpDataset.FieldByName('status').AsInteger;
  PODate                         := DateToStr(FPTmpDataset.FieldByName('Date').AsDateTime);
  POApproveForm.CashCB.Checked   := boolean(FPTmpDataset.FieldByName('bycash').AsInteger);
	CSWtext                        := FPTmpDataset.FieldByName('csw').AsString + CRLF + CRLF + 'Подписано: ';
  POApproveForm.Paid             := FPTmpDataset.FieldByName('status').AsInteger in [3,5];
  if POApproveForm.Paid then begin // if we have paid PO
  	POApproveForm.datep := FPTmpDataset.FieldByName('pd').AsDateTime;
  	POApproveForm.sump  := FPTmpDataset.FieldByName('sump').AsFloat;
  end;


  with FPMainDataset do begin
		SQL.Text := 'SELECT tbl2.*,' + RPPrefix + 'postsdir.Abbr FROM ' + RPPrefix + 'postsdir JOIN' +
                '(SELECT PostID,userid,FName,MName,FamilyName FROM ' + RPPrefix + 'psts JOIN' +
                '(SELECT pstsid,userid,FirstName AS FName,MiddleName AS MName,FamilyName FROM ' + RPPrefix + 'pstsfills JOIN allusers ' +
                'USING(UserID)WHERE allusers.login=:fLogin and(Now()>=startdate)AND((Now()<enddate)or(enddate is NULL)))AS tbl1 ' +
                'ON tbl1.pstsid=' + RPPrefix + 'psts.id)AS tbl2 ON tbl2.PostID=' + RPPrefix + 'postsdir.ID';// LOCK IN SHARE MODE';
  	ParamByName('fLogin').AsString := FPTmpDataset.FieldByName('origin').AsString;
  	Open;

  	OrigPost  := FieldByName('Abbr').AsString;
  	OrigName	:= GetShortFIO(FieldByName('FamilyName').AsString, FieldByName('FName').AsString, FieldByName('MName').AsString);
  end;

	POApproveForm.TextMemo.Text     := CSWtext + CRLF  + OrigName + ', ' + OrigPost;
	POApproveForm.Urgent						:= FPTmpDataset.FieldByName('status').AsInteger = -1;
	if POApproveForm.Urgent then begin
		POApproveForm.Caption 					:= POApproveForm.Caption + ' (срочной)';
		POApproveForm.PONumEdit.Color		:= clMyLightPink;
		POApproveForm.POSumEdit.Color		:= clMyLightPink;
		POApproveForm.SubjectEdit.Color := clMyLightPink;
		POApproveForm.SourceCombo.Color	:= clMyLightPink;
		POApproveForm.NoteMemo.Color		:= clMyLightPink;
		POApproveForm.TextMemo.Color    := clMyLightPink;
	end;

	POApproveForm.OutOfFP		:= true;
 	POApproveForm.FormIsRO	:= POisRO;
	POApproveForm.OrigDate	:= FPTmpDataset.FieldByName('date').AsDateTime; // !!!
  POApproveForm.OrigPost	:= OrigPost;
  POApproveForm.OrigName	:= OrigName;
  POApproveForm.PONum			:= PONum;
	POApproveForm.InitAtts;
	POApproveForm.InitLists;
  if POApproveForm.FundList.Count = 0 then begin
		Application.MessageBox('Вы ещё не создали ни одного фонда.', 'Рассмотрение заявки невозможно', MB_OK or MB_ICONERROR);
  	POApproveForm.Free;
    Exit;
  end;


  if POisRO then begin 													// i.e. we just view the PO
	  POApproveForm.TextMemo.ReadOnly						:= true;
		POApproveForm.ApproveRadioButton.Checked 	:= FPTmpDataset.FieldByName('status').AsInteger in [2..5];
    POApproveForm.RejectRadioButton.Checked		:= FPTmpDataset.FieldByName('status').AsInteger in [1];
		POApproveForm.ApproveRadioButton.Enabled 	:= FPTmpDataset.FieldByName('status').AsInteger in [2..5];
    POApproveForm.RejectRadioButton.Enabled		:= FPTmpDataset.FieldByName('status').AsInteger in [1];
	  if POisRO and (POStatus in [3,5]) then begin // we have paid PO
  	  POApproveForm.ApprovedSumEdit.Value			:= FPTmpDataset.FieldByName('sump').AsExtended;
    	POApproveForm.lblApprovedSum.Caption    := 'Оплачено';
      POApproveForm.lblApprovedSum.Left       := POApproveForm.lblSource.Left;
	  end
  	else begin
    	POApproveForm.ApprovedSumEdit.Value				:= FPTmpDataset.FieldByName('suma').AsExtended;
	  end;
		POApproveForm.NoteMemo.Text    						:= MyCleanStr(FPTmpDataset.FieldByName('note').AsString + CRLF +
    																						 'Подпись: ' + FPTmpDataset.FieldByName('signature').AsString, UC_KEEPDOTS);
    POApproveForm.NoteMemo.ReadOnly						:= true;
    POApproveForm.CancelButton.Caption				:= 'Закрыть';
    POApproveForm.SubmitButton.Visible				:= false;
    POApproveForm.SourceCombo.Enabled					:= false;
    POApproveForm.ApprovedSumEdit.Enabled			:= false;
    POApproveForm.PrintButton.Left						:= POApproveForm.SubmitButton.Left;
    POApproveForm.PrintButton.Top							:= POApproveForm.SubmitButton.Top;
    POApproveForm.PrintButton.Visible					:= true;

   	POApproveForm.SourceCombo.Clear;
    if POApproveForm.ApproveRadioButton.Checked then begin
//	    POApproveForm.CurFundLink	:= FPTmpDataset.FieldByName('fond').AsString;
      POApproveForm.SourceCombo.AddItem(GetNameOfFondByLink(FondList, FPTmpDataset.FieldByName('fond').AsString), nil);
      POApproveForm.SourceCombo.ItemIndex	:= 0;
    end
  end;
  // we need a transaction here as we have 2 operations in case of disbursment cash
  POApproveForm.CashCB.Enabled  := not POisRO;


	if POApproveForm.ShowModal = mrOK then begin
		if POApproveForm.ApproveRadioButton.Checked then begin // if PO was approved
  // we need a transaction here as we have 2 operations in case of disbursment cash
      NoError := true;
    	FPMainDataset.SQL.Text := 'BEGIN';
      try
//	      FPConnection.StartTransaction;
  	    FPMainDataset.ExecSQL;
      except
        on e: EZSQLException do begin
		      ShowError(Application.MainForm, 'Невозможно инициализировать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;

 // transfer money to disb cash
      if NoError then begin
        if (POApproveForm.CashCB.Visible) and (POApproveForm.CashCB.Checked) then begin
          asslink   := GetAssetByFund(POApproveForm.CurFundLink, RPPrefix);
          if asslink = '' then begin
            Application.MessageBox(PWideChar('Фонд "' + GetNameOfFondByLink(FondList, POApproveForm.CurFundLink) + '", из которого одобрена заявка,' + CRLF +
                                  'не увязан ни с каким активом. Автоматический перевод средств в расходную кассу невозможен.'), 'Невозможно перевести средства в расходную кассу', MB_ICONWARNING or MB_OK);
          end
          else begin
            NoError := AssetsTransfer(asslink, RPPrefix + DISBCASH_LINK, POApproveForm.ApprovedSumEdit.Value, 'Перевод средств по заявке № ' + IntToStr(PONum) + ' от ' + PODate, RPPrefix)
          end;
        end;
      end;

      if NoError then begin
  			FPMainDataset.SQL.Text :=
	  			'UPDATE`' + RPPrefix + 'po`SET`suma`=:fSuma,`status`=4,`note`=:fNote,`fond`=:fFond,`fp`=-1,`signature`=:fSignature,bycash=:fBC,rsvdby=NULL,dtby=NULL WHERE`index`='+IntToStr(PONum);
	  		FPMainDataset.ParamByName('fBC').AsInteger := integer((POApproveForm.CashCB.Visible) and (POApproveForm.CashCB.Checked));
		  	FPMainDataset.ParamByName('fSuma').AsFloat  := POApproveForm.ApprovedSumEdit.Value;
			  FPMainDataset.ParamByName('fFond').AsString := POApproveForm.CurFundLink;
  			FPMainDataset.ParamByName('fNote').AsString := POApproveForm.NoteMemo.Text;
	  		FPMainDataset.ParamByName('fSignature').AsString := FPNameOfUser +'<br>'+ FPPostsArr[CurOInd];
      end; // if NoError
		end
		else begin                                             // if PO was REJECTED
			FPMainDataset.SQL.Text :=
				'UPDATE ' + RPPrefix + 'po SET`status`=1,`note`=:fNote,`fp`=-1,`signature`=:fSignature,rsvdby=NULL,dtby=NULL WHERE`index`=' + IntToStr(PONum);
			FPMainDataset.ParamByName('fNote').AsString := POApproveForm.NoteMemo.Text;
			FPMainDataset.ParamByName('fSignature').AsString := FPNameOfUser +'<br>'+ FPPostsArr[CurOInd];
		end;
    try
		  FPMainDataset.ExecSQL;
    except
 		  on e: EZSQLException do begin
//	  	  ShowError(Self, 'Ошибка при изменении статуса заявки.', e.ErrorCode, e.StatusCode, e.Message);
	  	  ShowError(MFPF, 'Ошибка при изменении статуса заявки.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;
    if NoError then begin
      FPMainDataset.SQL.Text := 'COMMIT';
      try
//	      FPConnection.Commit;
        FPMainDataset.ExecSQL;
      except
        on e: EZSQLException do begin
//	        ShowError(Application.MainForm, 'Во время обновления данных произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
	        ShowError(MFPF, 'Во время обновления данных произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end; // try
    end;

    if not NoError then begin
	    FPMainDataset.SQL.Text := 'ROLLBACK';
      try
	      FPConnection.Rollback;
        FPMainDataset.ExecSQL; // 1
      except

      end; // try
    end;
		PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
	end        // if POApproveForm.ShowModal = mrOK then begin
  else begin
    // unlock PO in any case
    FPMainDataset.SQL.Text := 'UPDATE`' + RPPrefix + 'po`SET rsvdby=NULL,dtby=NULL WHERE`index`=:fPOID';
    FPMainDataset.ParamByName('fPOID').AsInteger := PONum;
    try
      FPMainDataset.ExecSQL;
    except
 	    on e: EZSQLException do begin
//	      ShowError(Self, 'Невозможно разблокировать заявку № ' + IntToStr(PONum), e.ErrorCode, e.StatusCode, e.Message);
	      ShowError(MFPF, 'Невозможно разблокировать заявку № ' + IntToStr(PONum), e.ErrorCode, e.StatusCode, e.Message);
      end;
    end;
  end;
	POApproveForm.Free;
end;


procedure TMainFPForm.OnCFilerApplied(var Msg: TMessage);
function IsPO(ASType : string) : boolean;
begin
	Result := (ASType = rsSubdPORow) or (ASType = rsSubdPORow + rsUrgentSuffix) or (ASType = rsRejdPORow) or (ASType = rsRejdPORow + rsUrgentSuffix) or
          	(ASType = rsAppdPORow) or (ASType = rsAppdPORow + rsUrgentSuffix) or (ASType = rsPaidPORow) or (ASType = rsPaidPORow + rsUrgentSuffix);
end;

var
	i : integer;
  j : integer;
  k : integer;
  frid : integer;
  tmpstr : string;
// filtering stuff
  FiltArray : PColFilters;
  bFiltering : boolean;
  FiltObj     : TFilterObject;
  tsum1 : extended;
  tsum2 : extended;
  tsum  : extended;
  tstype : string;
begin
	i := 0;
	SendMessage(StrGrid.Handle, WM_SETREDRAW, Ord(False), 0); // Locking redraw to speed up processing. We do not need a progrssbar here - it slows down the process.

  while i < StrGrid.AllRowCount - 1 do begin
    while i < StrGrid.AllRowCount - 1 do begin
      if LeftStr(StrGrid.AllCells[0, i], Length(rsFltPrefix)) = rsFltPrefix then begin frid := i; break; end;
	    Inc(i);
    end;

    if i < StrGrid.AllRowCount - 1 then begin // if we found a filter line, we set it up to proper value
      j := POFilters.IndexOf(StrGrid.AllCells[0, i]);
			if (j >= 0) and (j < POFilters.Count) then begin
      	FiltArray := PColFilters(POFilters.Objects[j]);
      	for k := 1 to StrGrid.ColCount - 1 do begin
          FiltObj  := FiltArray^[k];
          if FiltObj <> nil then begin
          	StrGrid.AllCells[k, i] := FiltObj.StateToString;
          end;
        end;
      end;
    end;


    tmpstr := MidStr(StrGrid.AllCells[0, i], Length(rsFltPrefix) + 1, Length(StrGrid.AllCells[0, i]));
    while (i < StrGrid.AllRowCount - 1) and (tmpstr <> '') and (StrGrid.AllCells[0, i] <> '') and ((StrGrid.AllCells[0, i] <> tmpstr) and (StrGrid.AllCells[0, i] <> tmpstr + rsUrgentSuffix)) do Inc(i); // move to the list of proper POs
    //
    while (i < StrGrid.AllRowCount - 1) and (tmpstr <> '') and (StrGrid.AllCells[0, i] <> '') and ((StrGrid.AllCells[0, i] = tmpstr) or (StrGrid.AllCells[0, i] = tmpstr + rsUrgentSuffix)) do begin
//	    OutputDebugString(PWideChar('PO # ' + StrGrid.AllCells[1, i]));
      CheckFiltersForRow(i, frid);
      Inc(i);
    end;
  end;

  // calculating totals for groups
  i := StrGrid.RowCount - 1;
  while i > 0 do begin

    while (i > 0) and (not IsPO(StrGrid.Cells[0, i])) do Dec(i); // move to the list of proper POs
//  	tmpstr := StrGrid.Cells[0, i];

    tsum1  := 0;
    tsum2  := 0;
    tstype := StrGrid.Cells[0, i]; //tmpstr;
    // Проверить отфильтровку _urgent, если суффикс есть.
    if RightStr(tstype, Length(rsUrgentSuffix)) = rsUrgentSuffix then
      tstype := LeftStr(tstype, Length(tstype) - Length(rsUrgentSuffix));

    while (i > 0) and IsPO(StrGrid.Cells[0, i]) do begin
    	if (tstype = rsSubdPORow) or (tstype = rsSubdPORow + rsUrgentSuffix) or (tstype = rsRejdPORow) or (tstype = rsRejdPORow + rsUrgentSuffix) then begin
      	TryStrToFloat(MyCleanStr(StrGrid.Cells[7, i]), tsum);
        tsum1 := tsum1 + tsum;
      end
      else if (tstype = rsAppdPORow) or (tstype = rsAppdPORow + rsUrgentSuffix) then begin
      	TryStrToFloat(MyCleanStr(StrGrid.Cells[5, i]), tsum);
        tsum1 := tsum1 + tsum;
      	TryStrToFloat(MyCleanStr(StrGrid.Cells[6, i]), tsum);
        tsum2 := tsum2 + tsum;
      end
      else if (tstype = rsPaidPORow) or (tstype = rsPaidPORow + rsUrgentSuffix) then begin
      	TryStrToFloat(MyCleanStr(StrGrid.Cells[6, i]), tsum);
        tsum1 := tsum1 + tsum;
      end;
      Dec(i);
    end;

    while (i > 0) and (StrGrid.Cells[0, i] <> rsSubPrefix + tstype) do Dec(i); // move to the list of proper POs

    if(i > 0) then begin
    	if (tstype = rsSubdPORow) or (tstype = rsSubdPORow + rsUrgentSuffix) or (tstype = rsRejdPORow) or (tstype = rsRejdPORow + rsUrgentSuffix) then begin
        StrGrid.Cells[7, i] := MyFloatToStr(tsum1);
      end
      else if (tstype = rsAppdPORow) or (tstype = rsAppdPORow + rsUrgentSuffix) then begin
        StrGrid.Cells[5, i] := MyFloatToStr(tsum1);
        StrGrid.Cells[6, i] := MyFloatToStr(tsum2);
      end
      else if (tstype = rsPaidPORow) or (tstype = rsPaidPORow + rsUrgentSuffix) then begin
        StrGrid.Cells[6, i] := MyFloatToStr(tsum1);
      end;
      Dec(i);
    end;
  end;

	SendMessage(StrGrid.Handle, WM_SETREDRAW, Ord(true), 0); // unlock redraw
  StrGrid.Repaint;
  StrGrid.SetFocus;
end;

procedure TMainFPForm.CheckFiltersForRow(ARow, AFltRow : integer);
var
  tmpres : boolean;
  tmpint : integer;
  tmpext : extended;
  tmpdt  : TDateTime;
  fltstr : string;
  i : integer;
  j : integer;
  FiltArray : PColFilters;
  FiltObj  : TFilterObject;
begin

	fltstr := StrGrid.AllCells[0, AFltRow];
  if fltstr = '' then exit;
	j := POFilters.IndexOf(fltstr);
  if (j >= 0) and (j < POFilters.Count) then begin
	  FiltArray := PColFilters(POFilters.Objects[j]);
    tmpres := true;
  	for i := 1 to StrGrid.ColCount - 1 do begin
  		FiltObj  := FiltArray^[i];
	    if FiltObj <> nil then begin
      	if FiltObj.GetFilterType = ftInt then begin
        	if not TryStrToInt(StrGrid.AllCells[i, ARow], tmpint) then tmpint := 0;
					tmpres := tmpres and FiltObj.GetIntFilterResult(tmpint);
        end
        else if FiltObj.GetFilterType = ftStr then begin
					tmpres := tmpres and FiltObj.GetStrFilterResult(StrGrid.AllCells[i, ARow]);
        end
        else if FiltObj.GetFilterType = ftExt then begin
        	if not TryStrToFloat(MyCleanStr(StrGrid.AllCells[i, ARow]), tmpext) then tmpext := 0;
					tmpres := tmpres and FiltObj.GetExtFilterResult(tmpext);
        end
        else if FiltObj.GetFilterType = ftDates then begin
        	if not TryStrToDateTime(StrGrid.AllCells[i, ARow], tmpdt) then tmpdt := 0;
					tmpres := tmpres and FiltObj.GetDatesFilterResult(tmpdt);
        end;
        if not tmpres then break;
    	end;
    end;
    if tmpres then begin
    	StrGrid.UnHideRow(ARow);
	    //OutputDebugString(PWideChar('PO # ' + StrGrid.AllCells[1, ARow] + ' SHOWN'));
    end
    else begin
	    //OutputDebugString(PWideChar('PO # ' + StrGrid.AllCells[1, ARow] + ' HIDDEN'));
    	StrGrid.HideRow(ARow);
    end;
  end;
end;

procedure TMainFPForm.StrGridClickCell(Sender: TObject; ARow, ACol: Integer);
var
	bSortIt      : boolean;
  bAscSorting  : boolean;
  SortType     : integer;
  SubRowToSort : string;
  i : integer;
  FiltArray : PColFilters;
  FiltObj  : TFilterObject;
begin
	if (CurValue in [BRANCH_POS]) and (ARow > 0) then begin
  	bSortIt := false;
    if(StrGrid.Cells[0, ARow] = rsSubdPOHeaderRow) and (StrGrid.Cells[1, ARow] <> rsSubdPOHeaderMain) then begin //clicked on the submitted POs header
    	if pos(rsDescSortSuffix, StrGrid.Cells[ACol, ARow]) > 0 then begin // DEscending sorting - change it to Ascending
        StrGrid.Cells[ACol, ARow] := GetGridColName(ACol, ARow) + ' ' + rsAscSortSuffix;
			  bAscSorting := true;
      end
      else if pos(rsAscSortSuffix, StrGrid.Cells[ACol, ARow]) > 0 then begin // Ascending sorting - change it to DEscending
        StrGrid.Cells[ACol, ARow] := GetGridColName(ACol, ARow) + ' ' + rsDescSortSuffix;
			  bAscSorting := false;
      end
      else begin  // change column to sort and set Ascending order
      	StrGrid.Cells[1, ARow] := rsSubdPOHeaderNum;
    		StrGrid.Cells[2, ARow] := rsSubdPOHeaderDate;
    		StrGrid.Cells[3, ARow] := rsSubdPOHeaderSubj;
				StrGrid.Cells[7, ARow] := rsSubdPOHeaderSum;
				StrGrid.Cells[8, ARow] := rsSubdPOHeaderCash;
    		StrGrid.Cells[9, ARow] := rsSubdPOHeaderAuth;
        StrGrid.Cells[ACol, ARow] := StrGrid.Cells[ACol, ARow] + ' ' + rsAscSortSuffix;
			  bAscSorting := true;
      end;
      if ACol in [1]     then SortType := stNum;
      if ACol in [2]     then SortType := stDate;
      if ACol in [3,8,9] then SortType := stString;
      if ACol in [7]     then SortType := stFloat;
      SubRowToSort := rsSubdPORow;
      bSortIt := true;
    end
    else if (StrGrid.Cells[0, ARow] = rsSubdPOFilterRow) or ((StrGrid.Cells[0, ARow] = rsRejdPOFilterRow)) or (StrGrid.Cells[0, ARow] = rsAppdPOFilterRow) or ((StrGrid.Cells[0, ARow] = rsPaidPOFilterRow)) then begin //clicked on the submitted POs FILTER
      	i := POFilters.IndexOf(StrGrid.Cells[0, ARow]);
      	if (i >= 0) and (i < POFilters.Count) then begin
        	FiltArray := PColFilters(POFilters.Objects[i]);
          FiltObj  := FiltArray^[ACol];
          if FiltObj <> nil then begin
          	FiltObj.SetUpFilter;
          end;
        end;
    end // Submitted PO filter row
    else if(StrGrid.Cells[0, ARow] = rsRejdPOHeaderRow) and (StrGrid.Cells[1, ARow] <> rsRejdPOHeaderMain) then begin //clicked on the rejected POs header
    	if pos(rsDescSortSuffix, StrGrid.Cells[ACol, ARow]) > 0 then begin // DEscending sorting - change it to Ascending
        StrGrid.Cells[ACol, ARow] := GetGridColName(ACol, ARow) + ' ' + rsAscSortSuffix;
			  bAscSorting := true;
      end
      else if pos(rsAscSortSuffix, StrGrid.Cells[ACol, ARow]) > 0 then begin // Ascending sorting - change it to DEscending
        StrGrid.Cells[ACol, ARow] := GetGridColName(ACol, ARow) + ' ' + rsDescSortSuffix;
			  bAscSorting := false;
      end
      else begin  // change column to sort and set Ascending order
      	StrGrid.Cells[1, ARow] := rsRejdPOHeaderNum;
    		StrGrid.Cells[2, ARow] := rsRejdPOHeaderDate;
    		StrGrid.Cells[3, ARow] := rsRejdPOHeaderSubj;
				StrGrid.Cells[7, ARow] := rsRejdPOHeaderSum;
				StrGrid.Cells[8, ARow] := rsRejdPOHeaderAuth;
    		StrGrid.Cells[9, ARow] := rsRejdPOHeaderSig;
        StrGrid.Cells[ACol, ARow] := StrGrid.Cells[ACol, ARow] + ' ' + rsAscSortSuffix;
			  bAscSorting := true;
      end;
      if ACol in [1]     then SortType := stNum;
      if ACol in [2]     then SortType := stDate;
      if ACol in [3,8,9] then SortType := stString;
      if ACol in [7]     then SortType := stFloat;
      SubRowToSort := rsRejdPORow;
      bSortIt := true;
    end
    else if(StrGrid.Cells[0, ARow] = rsAppdPOHeaderRow) and (StrGrid.Cells[1, ARow] <> rsAppdPOHeaderMain) then begin //clicked on the APPROVED POs header
    	if pos(rsDescSortSuffix, StrGrid.Cells[ACol, ARow]) > 0 then begin // DEscending sorting - change it to Ascending
        StrGrid.Cells[ACol, ARow] := GetGridColName(ACol, ARow) + ' ' + rsAscSortSuffix;
			  bAscSorting := true;
      end
      else if pos(rsAscSortSuffix, StrGrid.Cells[ACol, ARow]) > 0 then begin // Ascending sorting - change it to DEscending
        StrGrid.Cells[ACol, ARow] := GetGridColName(ACol, ARow) + ' ' + rsDescSortSuffix;
			  bAscSorting := false;
      end
      else begin  // change column to sort and set Ascending order
      	StrGrid.Cells[1, ARow] := rsAppdPOHeaderNum;
    		StrGrid.Cells[2, ARow] := rsAppdPOHeaderDate;
    		StrGrid.Cells[3, ARow] := rsAppdPOHeaderSubj;
    		StrGrid.Cells[5, ARow] := rsAppdPOHeaderSum;
    		StrGrid.Cells[6, ARow] := rsAppdPOHeaderSumA;
				StrGrid.Cells[7, ARow] := rsAppdPOHeaderCash;
				StrGrid.Cells[8, ARow] := rsAppdPOHeaderAuth;
    		StrGrid.Cells[9, ARow] := rsAppdPOHeaderFnd;
        StrGrid.Cells[ACol, ARow] := StrGrid.Cells[ACol, ARow] + ' ' + rsAscSortSuffix;
			  bAscSorting := true;
      end;
      if ACol in [1]       then SortType := stNum;
      if ACol in [2]       then SortType := stDate;
      if ACol in [3,7,8,9] then SortType := stString;
      if ACol in [5,6]     then SortType := stFloat;
      SubRowToSort := rsAppdPORow;
      bSortIt := true;
    end
    else if(StrGrid.Cells[0, ARow] = rsPaidPOHeaderRow) and (StrGrid.Cells[1, ARow] <> rsPaidPOHeaderMain) then begin //clicked on the APPROVED POs header
    	if pos(rsDescSortSuffix, StrGrid.Cells[ACol, ARow]) > 0 then begin // DEscending sorting - change it to Ascending
        StrGrid.Cells[ACol, ARow] := GetGridColName(ACol, ARow) + ' ' + rsAscSortSuffix;
			  bAscSorting := true;
      end
      else if pos(rsAscSortSuffix, StrGrid.Cells[ACol, ARow]) > 0 then begin // Ascending sorting - change it to DEscending
        StrGrid.Cells[ACol, ARow] := GetGridColName(ACol, ARow) + ' ' + rsDescSortSuffix;
			  bAscSorting := false;
      end
      else begin  // change column to sort and set Ascending order
      	StrGrid.Cells[1, ARow] := rsPaidPOHeaderNum;
    		StrGrid.Cells[2, ARow] := rsPaidPOHeaderDate;
    		StrGrid.Cells[3, ARow] := rsPaidPOHeaderSubj;
    		StrGrid.Cells[4, ARow] := rsPaidPOHeaderFPNo;
    		StrGrid.Cells[5, ARow] := rsPaidPOHeaderPayDate;
    		StrGrid.Cells[6, ARow] := rsPaidPOHeaderSumP;
				StrGrid.Cells[7, ARow] := rsPaidPOHeaderCash;
				StrGrid.Cells[8, ARow] := rsPaidPOHeaderAuth;
    		StrGrid.Cells[9, ARow] := rsPaidPOHeaderFnd;
        StrGrid.Cells[ACol, ARow] := StrGrid.Cells[ACol, ARow] + ' ' + rsAscSortSuffix;
			  bAscSorting := true;
      end;
      if ACol in [1,4]   then SortType := stNum;
      if ACol in [2,5]   then SortType := stDate;
      if ACol in [3,8,9] then SortType := stString;
      if ACol in [6]     then SortType := stFloat;
      SubRowToSort := rsPaidPORow;
      bSortIt := true;
    end;
		StrGrid.RepaintCell(ACol, ARow);
    if bSortIt then begin
			SortRows(ACol, bAscSorting, SubRowToSort, SortType);
    end;
  end;
	inherited;
end;

function TMainFPForm.GetFilterState(AGroup : string; ACol : integer) : string;
var
  FiltArray : PColFilters;
  FiltObj  : TFilterObject;
  i : integer;
begin
  Result := '';
	if (AGroup = rsSubdPOFilterRow) or (AGroup = rsRejdPOFilterRow) or (AGroup = rsAppdPOFilterRow) or (AGroup = rsPaidPOFilterRow) then begin //clicked on the submitted POs FILTER
  	i := POFilters.IndexOf(AGroup);
    if (i >= 0) and (i < POFilters.Count) then begin
    	FiltArray := PColFilters(POFilters.Objects[i]);
      FiltObj  := FiltArray^[ACol];
      if FiltObj <> nil then begin
      	Result := FiltObj.StateToString;
      end;
    end;
  end // if AGroup ...
end;


function TMainFPForm.GetGridColName(ACol, ARow: Integer) : string;
begin
  Result := '';
	if StrGrid.Cells[0, ARow] = rsSubdPOHeaderRow then begin
    if ACol = 1 then Result := rsSubdPOHeaderNum
    else if ACol = 2 then Result := rsSubdPOHeaderDate
    else if ACol = 3 then Result := rsSubdPOHeaderSubj
		else if ACol = 7 then Result := rsSubdPOHeaderSum
		else if ACol = 8 then Result := rsSubdPOHeaderCash
    else if ACol = 9 then Result := rsSubdPOHeaderAuth;
  end
	else if StrGrid.Cells[0, ARow] = rsRejdPOHeaderRow then begin
    if ACol = 1 then Result := rsRejdPOHeaderNum
    else if ACol = 2 then Result := rsRejdPOHeaderDate
    else if ACol = 3 then Result := rsRejdPOHeaderSubj
		else if ACol = 7 then Result := rsRejdPOHeaderSum
		else if ACol = 8 then Result := rsRejdPOHeaderAuth
    else if ACol = 9 then Result := rsRejdPOHeaderSig;
  end
	else if StrGrid.Cells[0, ARow] = rsAppdPOHeaderRow then begin
    if ACol = 1 then Result := rsAppdPOHeaderNum
    else if ACol = 2 then Result := rsAppdPOHeaderDate
    else if ACol = 3 then Result := rsAppdPOHeaderSubj
		else if ACol = 5 then Result := rsAppdPOHeaderSum
		else if ACol = 6 then Result := rsAppdPOHeaderSumA
		else if ACol = 7 then Result := rsAppdPOHeaderCash
		else if ACol = 8 then Result := rsAppdPOHeaderAuth
    else if ACol = 9 then Result := rsAppdPOHeaderFnd;
  end
	else if StrGrid.Cells[0, ARow] = rsPaidPOHeaderRow then begin
    if ACol = 1 then Result := rsPaidPOHeaderNum
    else if ACol = 2 then Result := rsPaidPOHeaderDate
    else if ACol = 3 then Result := rsPaidPOHeaderSubj
    else if ACol = 4 then Result := rsPaidPOHeaderFPNo
		else if ACol = 5 then Result := rsPaidPOHeaderPayDate
		else if ACol = 6 then Result := rsPaidPOHeaderSumP
		else if ACol = 7 then Result := rsPaidPOHeaderCash
		else if ACol = 8 then Result := rsPaidPOHeaderAuth
    else if ACol = 9 then Result := rsPaidPOHeaderFnd;
  end;
end;

procedure TMainFPForm.SortRows(ACol : integer; AAsc : boolean; AGroup: string; AType : integer);
(*
	ACol   - column as a key
	AAsc   - Ascending(true)/Descending(false) sorting
  AGroup - group of lines to be sorted
  AType  - type of the colum (string, float, date etc)
*)
var
	istart : integer;  // start line
	iend   : integer;  // end line
  bDone  : boolean;
  i, j   : integer;
begin

	bDone := false;

  for i := 0 to StrGrid.RowCount - 1 do begin
	  if LeftStr(StrGrid.Cells[0, i], Length(AGroup)) = AGroup then begin
      istart := i;
      break;
    end;
  end;
  for i := istart to StrGrid.RowCount - 1 do begin
	  if LeftStr(StrGrid.Cells[0, i], Length(AGroup)) <> AGroup then begin
      iend := i - 1;
      break;
    end;
  end;

	lpf             := TLoadingProgressForm.Create(nil); // for LoadingProgressForm
	lpf.BorderStyle := bsNone;
  lpf.Lbl.Caption := 'Сортируем...';
	lpf.PB.MaxValue := iend - istart + 1;
  lpf.PB.MinValue := 0;
  lpf.PB.Progress := 0;
  lpf.Width    := 250;
  lpf.Height   := 90;
  lpf.Show;

	MainTree.Enabled  := false;
  sToolBar1.Enabled := false;
	SendMessage(StrGrid.Handle, WM_SETREDRAW, Ord(False), 0);

  for i := istart to iend - 1 do begin
    lpf.PB.Progress := lpf.PB.Progress + 1;
    Application.ProcessMessages;
  	bDone := false;
    for j := istart to iend - 1 do begin
    	if CmpCells(j, j + 1, ACol, AType, AAsc) then bDone := true;
    end;
    if not bDone then break;
	end;
//  t2 := now;
//  OutputDebugString(PWideChar('- t2   =' + DateTimeToStr(t2)));
//  OutputDebugString(PWideChar('- dur   =' + DateTimeToStr(t2 - t1)));
//  OutputDebugString(PWideChar('- istart =' + IntToStr(istart)));
//  OutputDebugString(PWideChar('- iend   =' + IntToStr(iend)));
  lpf.Destroy;
	SendMessage(StrGrid.Handle, WM_SETREDRAW, Ord(true), 0);
  sToolBar1.Enabled := true;
	MainTree.Enabled  := true;
  StrGrid.Repaint;
  StrGrid.SetFocus;
end;

function TMainFPForm.CmpCells(ARow1, ARow2, ACol, AType : integer; AAsc : boolean) : boolean;
var
	invertor : integer; // we need it for ASC<->DESC manipulations
  Num1, Num2 : integer;
  Ext1, Ext2 : extended;
  Date1, Date2 : TDateTime;
begin
	Result := false;
  if AAsc then invertor := 1 else invertor := -1;
  if AType = stString then begin
	  if (invertor * AnsiCompareText(StrGrid.Cells[ACol, ARow1], StrGrid.Cells[ACol, ARow2])) > 0 then begin
  		StrGrid.SwapRows(ARow1, ARow2);
    	Result := true;
	  end;
  end
  else if AType = stNum then begin
  	try
	  	if not TryStrToInt(StrGrid.Cells[ACol, ARow1], Num1) then Num1 := 0;
  		if not TryStrToInt(StrGrid.Cells[ACol, ARow2], Num2) then Num2 := 0;
    finally

    end;
	  if invertor * (Num1 - Num2) > 0 then begin
  		StrGrid.SwapRows(ARow1, ARow2);
    	Result := true;
	  end;
  end
  else if AType = stFloat then begin
  	try
			if not TryStrToFloat(MyCleanStr(StrGrid.Cells[ACol, ARow1]), Ext1) then Ext1 := 0;
			if not TryStrToFloat(MyCleanStr(StrGrid.Cells[ACol, ARow2]), Ext2) then Ext2 := 0;
    finally

    end;
	  if invertor * (Ext1 - Ext2) > 0 then begin
  		StrGrid.SwapRows(ARow1, ARow2);
    	Result := true;
	  end;
  end
  else if AType = stDate then begin
  	try
			if not TryStrToDateTime(StrGrid.Cells[ACol, ARow1], Date1) then Date1 := 0;
			if not TryStrToDateTime(StrGrid.Cells[ACol, ARow2], Date2) then Date2 := 0;
    finally

    end;
	  if invertor * CompareDates(Date1, Date2) > 0 then begin
  		StrGrid.SwapRows(ARow1, ARow2);
    	Result := true;
	  end;
  end;

end;

procedure TMainFPForm.StrGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
var
	TmpVal    	: extended;
	TmpInt    	: integer;
  TmpEdit   	: tsEdit;
  TmpDate			: TDateTime;
  PONum				: integer;
  Originator	: string;
  DebtingForm: TDebtingForm;
  CPrefix     : string;
  CreditingForm: TCreditingForm;
  recid : integer;
  FPBlocked : boolean;
  LastFPDate : TDateTime;

  ICF : TIncomeCorrectionForm;
  price : double;
  balance : double;
  am0: double;
  totdif: double;
  am1: double;
  tot : double;
  IsSpeInc : boolean;
  Descr : string;


begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;
//
//	if (CurValue in [LIST_PERSONS]) and (ARow > 0) then begin
	if (CurValue in [LIST_PERSONS]) and (ARow > 0) and TryStrToInt(StrGrid.Cells[0, StrGrid.Row], PONum) and (PONum > 0) then begin
		CurStrGridRow := ARow;
		PersListClick(Sender);
    Exit;
  end
	else if (CurValue in [BRANCH_POS]) and (ARow > 0) and TryStrToInt(StrGrid.Cells[1, StrGrid.Row], PONum) and (PONum > 0) then begin
	  CurPONum	:= PONum;
    CPrefix := CurPrefix;
//		FPMainDataset.SQL.Text := 'SELECT origin FROM po WHERE `index`='+IntToStr(PONum);
		FPMainDataset.SQL.Text := 'SELECT origin FROM ' + CPrefix + 'po WHERE `index`=' + IntToStr(PONum);
  	try
    	FPMainDataset.Open;
	  except
  		on e : EZSQLException do begin
				ShowError(Self, 'Не удалось получить данные об авторе заявки. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
      	Exit;
	    end;
  	end;
	  Originator := FPMainDataset.FieldByName('origin').AsString;
    POCanBeEdited := (Pos(rsSubdPORow, StrGrid.Cells[0, StrGrid.Row]) > 0) and (Originator = FPLogin);
		EditPOPopUpClick(Sender);
  end
  else if (CurValue in [BRANCH_FUND_ASSET]) and (ARow > 0) and (StrGrid.Cells[4, StrGrid.Row] <> '') and (Pos(rsFPTrasferFromCashToBillOne, StrGrid.Cells[3, StrGrid.Row]) <> 1) and TryStrToInt(StrGrid.Cells[1, StrGrid.Row], RecId) and (RecId > 0) then begin
    CPrefix := CurPrefix;
	  //CurPONum	:= PONum;

    // can we change this record?
    LastFPDate := 0;
    FPBlocked := false;
		FPMainDataset.SQL.Text := '(select"rsvd"as param,`to`from ' + CPrefix + 'fp where rsvdby is not null or dtby is not null order by`index`desc limit 1)' +
                              'union (select"la"as param,`to`from ' + CPrefix + 'fp where aprvd=1 order by`index`desc limit 1)';
  	try
    	FPMainDataset.Open;
      while not FPMainDataset.Eof and not FPBlocked do begin
        if(FPMainDataset.FieldByName('param').AsString = 'rsvd') then begin
          FPBlocked := true;
        end
        else if FPMainDataset.FieldByName('param').AsString = 'la' then begin
          LastFPDate := FPMainDataset.FieldByName('to').AsDateTime;
        end;
        FPMainDataset.Next;
      end;
      FPMaindataset.Close;
	  except
  		on e : EZSQLException do begin
				ShowError(Self, 'Не удалось получить данные о записи. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
      	Exit;
	    end;
  	end;

    if FPBlocked then begin
      Application.MessageBox('Финплан заблокирован', 'Приход', MB_OK or MB_ICONERROR);
      exit;
    end
    else if LastFPDate > 0 then begin
      TryStrToDateTime(StrGrid.Cells[2, StrGrid.Row], TmpDate);
      if (TmpDate > 0) then begin
        if tmpDate <= LastFPDate then begin
          Application.MessageBox('Этот приход уже распределён.', 'Приход', MB_OK or MB_ICONERROR);
          exit;
        end;
      end
      else begin
        // something wrong with date conversion
      end;
    end;

    // pull income data
		FPMainDataset.SQL.Text := 'SELECT`data`,price,amount,`in`,balance FROM ' + CurTable + ' WHERE`index`=' + StrGrid.Cells[1, StrGrid.Row];
  	try
    	FPMainDataset.Open;
      if not FPMainDataset.Eof then begin
        am0 := FPMainDataset.FieldByName('amount').AsFloat;
        price := FPMainDataset.FieldByName('price').AsFloat;
        tot := am0 * price;
        balance := FPMainDataset.FieldByName('balance').AsFloat;
        descr := Trim(FPMainDataset.FieldByName('data').AsAnsiString);
      end;
      FPMaindataset.Close;
	  except
  		on e : EZSQLException do begin
				ShowError(Self, 'Не удалось получить данные о записи. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
      	Exit;
	    end;
  	end;

      ICF := TIncomeCorrectionForm.Create(Self);
      ICF.PriceEdit.Value := price;
      ICF.AmntEdit.Value := am0;
      ICF.AmountTotal.Value := price * am0;
      ICF.DescrMemo.Text := descr;
      if ICF.ShowModal <> mrOK then begin
        ICF.Free;
        exit;
      end;

      // any change?
      if (Round(ICF.PriceEdit.Value * 100) <> Round(price * 100)) or (Round(ICF.AmntEdit.Value * 100) <> Round(am0 * 100)) or (Round(ICF.AmountTotal.Value * 100) <> Round(price * am0 * 100)) or (descr <> ICF.DescrMemo.Text) then begin

        FPConnection.StartTransaction;

        // can we still change this record?
        LastFPDate := 0;
        FPBlocked := false;
        FPMainDataset.SQL.Text := '(select"rsvd"as param,`to`from ' + CPrefix + 'fp where rsvdby is not null or dtby is not null order by`index`desc limit 1)' +
                                  'union (select"la"as param,`to`from ' + CPrefix + 'fp where aprvd=1 order by`index`desc limit 1)';
        try
          FPMainDataset.Open;
          while not FPMainDataset.Eof and not FPBlocked do begin
            if(FPMainDataset.FieldByName('param').AsString = 'rsvd') then begin
              FPBlocked := true;
            end
            else if FPMainDataset.FieldByName('param').AsString = 'la' then begin
              LastFPDate := FPMainDataset.FieldByName('to').AsDateTime;
            end;
            FPMainDataset.Next;
          end;
          FPMaindataset.Close;
        except
          on e : EZSQLException do begin
            FPConnection.Rollback;
            ShowError(Self, 'Не удалось получить данные о записи. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
            Exit;
          end;
        end;

        if FPBlocked then begin
          Application.MessageBox('Финплан заблокирован', 'Приход', MB_OK or MB_ICONERROR);
          exit;
        end
        else if LastFPDate > 0 then begin
          TryStrToDateTime(StrGrid.Cells[2, StrGrid.Row], TmpDate);
          if (TmpDate > 0) then begin
            if tmpDate < LastFPDate then begin
              FPConnection.Rollback;
              Application.MessageBox('Этот приход уже распределён.', 'Приход', MB_OK or MB_ICONERROR);
              exit;
            end;
          end
          else begin
            // something wrong with date conversion
          end;
        end;

        price  := ICF.PriceEdit.Value;
        am1    := ICF.AmntEdit.Value;
        totdif := price * am1 - tot; // correction amount
        tot    := ICF.AmountTotal.Value;
        descr  := ICF.DescrMemo.Text;

        // upldate income data
        FPMainDataset.SQL.Text := 'UPDATE`' + CurTable +'`SET`data`=:fdata,`price`=:fprice,`amount`=:famount,`in`=:ftotal,`balance`=:fbalance WHERE`index`=' + StrGrid.Cells[1, StrGrid.Row];
        try
          FPMainDataset.ParamByName('fdata').AsAnsiString := descr;
          FPMainDataset.ParamByName('fprice').AsFloat     := price;
          FPMainDataset.ParamByName('famount').AsFloat    := am0;
          FPMainDataset.ParamByName('ftotal').AsFloat     := tot;
          FPMainDataset.ParamByName('fbalance').AsFloat   := balance + totdif;
          FPMainDataset.ExecSQL;
        except
          on e : EZSQLException do begin
            FPConnection.Rollback;
            ShowError(Self, 'Не удалось получить данные о записи. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
            Exit;
          end;
        end;

        // upldate later balances data
        FPMainDataset.SQL.Text := 'UPDATE`' + CurTable +'`SET`balance`=`balance`+:fdiff WHERE`index`>' + StrGrid.Cells[1, StrGrid.Row];
        try
          FPMainDataset.ParamByName('fdiff').AsFloat := totdif;
          FPMainDataset.ExecSQL;
        except
          on e : EZSQLException do begin
            FPConnection.Rollback;
            ShowError(Self, 'Не удалось получить данные о записи. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
            Exit;
          end;
        end;

        if(CurTable = CPrefix + BILL1_LINK) then begin // update bank/gso and asset/bank values
          descr := CurPrefix + 'bank';
          // update bank/gso data
          FPMainDataset.SQL.Text := 'UPDATE`' + CurPrefix + 'bank`SET`balance`=`balance`+:fdiff WHERE`link`=:ftable';
          try
            FPMainDataset.ParamByName('fdiff').AsFloat := totdif;
            FPMainDataset.ParamByName('ftable').AsAnsiString := CurTable;
            FPMainDataset.ExecSQL;
          except
            on e : EZSQLException do begin
              FPConnection.Rollback;
              ShowError(Self, 'Не удалось получить данные о записи. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
              Exit;
            end;
          end;
        end
        else begin
          descr := CurPrefix + CASH_LINK;
        end;

        // update asset/bank|cash data
        FPMainDataset.SQL.Text := 'UPDATE`' + CurPrefix+'asset`SET`balance`=`balance`+:fdiff WHERE`link`=:ftable';
        try
          FPMainDataset.ParamByName('fdiff').AsFloat := totdif;
          FPMainDataset.ParamByName('ftable').AsAnsiString := descr;
          FPMainDataset.ExecSQL;
        except
          on e : EZSQLException do begin
            FPConnection.Rollback;
            ShowError(Self, 'Не удалось получить данные о записи. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
            Exit;
          end;
        end;
        FPCOnnection.Commit;
      	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
      end;
    exit;
  end;

	if (CurValue in [LIST_DEBITORS, LIST_CREDITORS]) and (ARow > 0) and (TryStrToFloat(MyCleanStr(StrGrid.Cells[5, ARow]), TmpVal)) and (TmpVal > 0) then begin
		CurStrGridRow := ARow;
		DCPopUpListClick(Sender);
  end;

	if (CurValue in [BRANCH_DEBITORS, BRANCH_CREDITORS]) and (ARow > 0) and TryStrToInt(StrGrid.Cells[1, ARow], TmpInt) and (StrGrid.Cells[3, ARow]='') then begin
		CurStrGridRow := ARow;
    if CurValue in [BRANCH_DEBITORS] then begin
      DebtingForm := TDebtingForm.Create(Self);
      DebtingForm.ShipDateOnly    := true;
      DebtingForm.Dt.Enabled      := false;
      DebtingForm.Dt.Date         := StrToDate(StrGrid.Cells[6, CurStrGridRow]);

      DebtingForm.ShipDt.Enabled  := true;
      DebtingForm.DescrMemo.Enabled := false;
      DebtingForm.DescrMemo.Text    := StrGrid.Cells[4, CurStrGridRow];

      TmpEdit          := tsEdit.Create(Self);
      TmpEdit.Parent   := DebtingForm.sPanel1;
      TmpEdit.Text     := StrGrid.Cells[7, CurStrGridRow];
      TmpEdit.Left     := DebtingForm.DebCredCombo.Left;
      TmpEdit.Width    := DebtingForm.DebCredCombo.Width;
      TmpEdit.Top      := DebtingForm.DebCredCombo.Top;
      TmpEdit.Height   := DebtingForm.DebCredCombo.Height;
      TmpEdit.Enabled  := false;


      DebtingForm.DebCredCombo.Visible  := false;
      DebtingForm.DebCredCombo.Enabled  := false;

      DebtingForm.AmountEdit.Enabled    := false;
      TryStrToFloat(MyCleanStr(StrGrid.Cells[5, CurStrGridRow]), TmpVal);
      DebtingForm.AmountEdit.Value      := TmpVal;
      if mrOK = DebtingForm.ShowModal then begin
        CPrefix := CurPrefix;
//        FPMainDataset.SQL.Text  := 'UPDATE `'+ CPrefix + 'topay` SET `shipdate`=:fShipDate WHERE `index`=:fIndex';
        FPMainDataset.SQL.Text  := 'UPDATE `'+ CPrefix + 'tocollect` SET `shipdate`=:fShipDate WHERE `index`=:fIndex';
        FPMainDataset.ParamByName('fShipDate').AsDate := DebtingForm.ShipDt.Date;
        FPMainDataset.ParamByName('fIndex').AsInteger := TmpInt;

    	  try
		      FPMainDataset.ExecSQL;
    	  except
        	on e: EZSQLException do begin
    	  	  ShowError(Self, 'Ошибка обновления данных. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
	          Exit;
      	  end;
	      end;

        StrGrid.Cells[3, CurStrGridRow] := DateToStr(DebtingForm.ShipDt.Date);
        StrGrid.RepaintCell(3, CurStrGridRow);
      end;
      DebtingForm.Free;
    end
    else begin
      CreditingForm := TCreditingForm.Create(Self);
      CreditingForm.Caption := 'Изменение даты получения кредита';
      TryStrToDateTime(StrGrid.Cells[6, CurStrGridRow], TmpDate);
      CreditingForm.Dt.Date := TmpDate;

//      CreditingForm.Dt.Date := StrToDate(StrGrid.Cells[6, CurStrGridRow]);
      CreditingForm.Dt.Enabled  := false;

      TryStrToFloat(MyCleanStr(StrGrid.Cells[5, CurStrGridRow]), TmpVal);
      CreditingForm.AmountEdit.Value      := TmpVal;
      CreditingForm.AmountEdit.Enabled    := false;

      CreditingForm.DescrMemo.Text        := StrGrid.Cells[4, CurStrGridRow];
      CreditingForm.DescrMemo.Enabled     := false;

      CreditingForm.TypeCreditGroup.Visible    := false;
      CreditingForm.Height := CreditingForm.Height - 30;

      TmpEdit          := tsEdit.Create(Self);
      TmpEdit.Parent   := CreditingForm.sPanel1;
      TmpEdit.Text     := StrGrid.Cells[7, CurStrGridRow];
      TmpEdit.Left     := CreditingForm.CredCombo.Left;
      TmpEdit.Width    := CreditingForm.CredCombo.Width;
      TmpEdit.Top      := CreditingForm.CredCombo.Top;
      TmpEdit.Height   := CreditingForm.CredCombo.Height;
      TmpEdit.Enabled  := false;

      CreditingForm.CredCombo.Visible := false;

      if mrOK = CreditingForm.ShowModal then begin
        CPrefix := CurPrefix;
        FPMainDataset.SQL.Text  := 'UPDATE `'+ CPrefix + 'topay` SET `shipdate`=:fShipDate WHERE `index`=:fIndex';
//        FPMainDataset.SQL.Text  := 'UPDATE `topay` SET `shipdate`=:fShipDate WHERE `index`=:fIndex';
        FPMainDataset.ParamByName('fShipDate').AsDate := CreditingForm.RecDtEdit.Date;
        FPMainDataset.ParamByName('fIndex').AsInteger := TmpInt;

    	  try
		      FPMainDataset.ExecSQL;
    	  except
        	on e: EZSQLException do begin
    	  	  ShowError(Self, 'Ошибка обновления данных. Ответ сервера приведён ниже.', e.ErrorCode, e.StatusCode, e.Message);
	          Exit;
      	  end;
	      end;

        StrGrid.Cells[3, CurStrGridRow] := DateToStr(CreditingForm.RecDtEdit.Date);
        StrGrid.RepaintCell(3, CurStrGridRow);
      end;
      CreditingForm.Free;
    end;
  end;
end;

procedure TMainFPForm.StrGridExit(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TMainFPForm.StrGridGetAlignment(Sender:TObject; ARow, ACol : Integer; var HAlign : TAlignment; var VAlign : TVAlignment);
begin
  if CurValue = 1 then begin
  	if ARow = 0 then
    	HAlign := taCenter
    else if ACol in [1, 2, 4] then begin
    	HAlign := taRightJustify
    end
    else
    	HAlign := taLeftJustify
  end
  else if CurValue = 2 then begin
  	if (ARow = 0) then
    	HAlign := taCenter
    else if (ARow >= StrGrid.RowCount - 3) or (ARow = 1) then begin
//    	if ACol = 8 then begin
    	if ACol = StrGrid.ColCount - 1 then begin
				HAlign := taRightJustify;
      end
      else begin
				HAlign := taLeftJustify;
      end;
    end
    else if (fmtList.Count > ARow) and (FmtList[ARow] = 'f1__') then begin
    	if ACol in [4, 6, 8] then begin
				HAlign := taRightJustify;
      end
      else begin
				HAlign := taLeftJustify;
      end;
    end
    else if (fmtList.Count > ARow) and (FmtList[ARow] = 'h1__') then begin
  	  HAlign := taCenter
    end
    else begin
   	  if ACol = 2 then begin
			  HAlign := taLeftJustify;
    end
      else begin
	  		HAlign := taRightJustify;
		  end;
    end;
    Exit;
  end;

  case CurValue of
    2 : begin
    	if (ARow = 0) then
      	HAlign := taCenter
      else
      	case ACol of
        	2: HAlign := taRightJustify;
          else
          	HAlign := taLeftJustify;
        end;
    end; // case of 2
    3: begin
      if (ARow = 0) then
      	HAlign := taCenter
      else begin                                       // usual fund line and "Total" line
        if ACol = 1 then
          HAlign := taLeftJustify
        else
          HAlign := taRightJustify;
      end
//      else if ARow = CurGridRows - 1 then
(*
      else if ARow = StrGrid.RowCount - 1 then
      	case ACol of
        	3: HAlign := taRightJustify;
          else
          	HAlign := taLeftJustify;
          end
      else
      	case ACol of
        	2, 3: HAlign := taRightJustify;
          else
          	HAlign := taLeftJustify;
        end;
*)
    end; // case of 3
    4: begin
      if (ARow = 0) then
      	HAlign := taCenter
      else begin                                       // usual fund line and "Total" line
        if ACol = 1 then
          HAlign := taLeftJustify
        else
          HAlign := taRightJustify;
      end
    end; // case of 4
    5: begin
        if Pos('h__', StrGrid.Cells[0, aRow]) > 0 then begin // section header
          HAlign := taLeftJustify;
        end;
        if Pos('s__', StrGrid.Cells[0, aRow]) > 0 then begin // section subheader
          HAlign := taCenter;
        end;
        if Pos('t__', StrGrid.Cells[0, aRow]) > 0 then begin // totals
          case ACol of
            1, 9    : HAlign := taLeftJustify;
            4, 11   : HAlign := taRightJustify;
          end;
        end;
        if Pos('a__', StrGrid.Cells[0, aRow]) > 0 then begin // section A
          case ACol of
            1, 2, 12  : HAlign := taRightJustify;
            else        HAlign := taLeftJustify;
          end;
        end;
        if Pos('b__', StrGrid.Cells[0, aRow]) > 0 then begin // section B
          case ACol of
            1, 8, 11, 13  : HAlign := taRightJustify;
            else        HAlign := taLeftJustify;
          end;
        end;
        if  (Pos('c__', StrGrid.Cells[0, aRow]) > 0) or
            (Pos('e__', StrGrid.Cells[0, aRow]) > 0) then begin // section C and E
          case ACol of
            1, 11, 13  : HAlign := taRightJustify;
            else        HAlign := taLeftJustify;
          end;
        end;
        if Pos('d__', StrGrid.Cells[0, aRow]) > 0 then begin // section D
          case ACol of
            1, 13  : HAlign := taRightJustify;
            else        HAlign := taLeftJustify;
          end;
        end;
        if Pos('f__', StrGrid.Cells[0, aRow]) > 0 then begin // section D
          case ACol of
            1, 2, 7, 13  : HAlign := taRightJustify;
            else        HAlign := taLeftJustify;
          end;
        end;
    end; // case of 5
    6 : begin // search
        if ARow = 0 then
          HAlign := taCenter
        else
	        case ACol of
  	        1,2,4,5,6:
    	        HAlign := taRightJustify;
      	    3 :
        	    HAlign := taLeftJustify
	        end;
    end; // case of 6
    7 : begin  // POs
        if ARow = 0 then
          HAlign := taCenter
        else if Pos('sub_', StrGrid.Cells[0, aRow]) > 0 then begin
          if ACol = 1 then
	          HAlign := taLeftJustify
          else
	          HAlign := taRightJustify;
        end
        else if Pos('h_', StrGrid.Cells[0, aRow]) > 0 then
          HAlign := taCenter
        else
        case ACol of
          1,2,4,5:
            HAlign := taRightJustify;
          6 :
            if (StrGrid.Cells[0, aRow] = rsRejdPORow) or (Pos(rsAppdPORow, StrGrid.Cells[0, aRow]) > 0) or (Pos('gray', StrGrid.Cells[0, aRow]) > 0) then
              HAlign := taRightJustify
            else
              HAlign := taCenter;
          7 : if (StrGrid.Cells[0, aRow] = rsSubdPORow) or (StrGrid.Cells[0, aRow] = rsSubdPOUrgentRow) or (StrGrid.Cells[0, aRow] = rsRejdPORow)then ///or (Pos('green', StrGrid.Cells[0, aRow]) > 0) then
		          	HAlign := taRightJustify
              else
		          	HAlign := taLeftJustify;
          8 :
            if (StrGrid.Cells[0, aRow] = rsSubdPORow) or (StrGrid.Cells[0, aRow] = rsSubdPOUrgentRow) or (StrGrid.Cells[0, aRow] = rsRejdPORow) or (Pos(rsAppdPORow, StrGrid.Cells[0, aRow]) > 0) or (Pos(rsPaidPORow, StrGrid.Cells[0, aRow]) > 0) then
              HAlign := taLeftJustify
            else
              HAlign := taRightJustify;
          9:
              HAlign := taLeftJustify
          else
            HAlign := taLeftJustify;
        end;
    end; // case of 7
    8 : begin // bank
        if (ARow = 0) then
          HAlign := taCenter
        else if ARow = StrGrid.RowCount - 1 then begin
          if ACol = 1 then
            HAlign := taLeftJustify
          else
            HAlign := taRightJustify;
        end
        else
          case ACol of
            1,3,4 : HAlign := taRightJustify;
            else
              HAlign := taLeftJustify;
          end;
    end; // case of 8
    9 : begin
        if (ARow = 0) then
          HAlign := taCenter
//        else if ARow = CurGridRows - 1 then
        else if ARow = 1 then
          case ACol of
            6: HAlign := taRightJustify;
            else
              HAlign := taLeftJustify;
          end
        else
          case ACol of
            1,2,4,5,6: HAlign := taRightJustify;
            else
              HAlign := taLeftJustify;
          end;
    end; // case of 9
    13 : begin           // BRANCH_DEBITORS
        if ARow = 0 then
          HAlign := taCenter
        else if Pos('h_', StrGrid.Cells[0, aRow]) > 0 then
          HAlign := taCenter
        else
        case ACol of
          1,2,3,5,6:
            HAlign := taRightJustify;
          else
            HAlign := taLeftJustify;
        end;
    end; // case of 13
    14 : begin           // BRANCH_DEBITORS
        if ARow = 0 then
          HAlign := taCenter
        else if Pos('h_', StrGrid.Cells[0, aRow]) > 0 then
          HAlign := taCenter
        else
        case ACol of
          1,2,3,5,6:
            HAlign := taRightJustify;
          else
            HAlign := taLeftJustify;
        end;
    end; // case of 14
    LIST_PERSONS : begin           // BRANCH_PERSONS
        if ARow = 0 then
          HAlign := taCenter
        else if Pos('h_', StrGrid.Cells[0, aRow]) > 0 then
          HAlign := taCenter
        else
        case ACol of
          1,2,3,4:
            HAlign := taLeftJustify;
          else
            HAlign := taRightJustify;
        end;
    end; // case of 14
    100, 101 : begin
    	if ARow = 0 then
      	HAlign := taLeftJustify
      else
	    	case ACol of
  	    	1,2,3,4:
    	    	HAlign := taLeftJustify;
      	  else
        		HAlign := taRightJustify;
	      end; //
    end; // case of 13
  end;
end;

procedure TMainFPForm.StrGridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
Var
	TmpVal	: extended;
begin
//  if PrintingIsIP then begin
//		ABrush.Color 	:= NormalBkColor;
//  	AFont.Color		:= NormalBkColor;
//    AFont.Style		:= NormalFontStyle;
//  end
//  else begin
  if CurValue = 1 then begin
      ABrush.Color := clSpecBkColor;
    if ARow = 0 then begin                     // for header
      AFont.Style  := [fsBold];
    end
    else begin
      AFont.Style  := [];
    end;
    Exit;
  end
  else if CurValue = 2 then begin
    AFont.Color := clBlack;
    if ARow = 0 then begin                     // for header
      ABrush.Color := clSpecBkColor;//TColor($56BBF9);
      AFont.Style := [fsBold];
    end
//      else if ARow = CurGridRows - 1 then begin  // if it's a last line
    else if ARow = StrGrid.RowCount - 1 then begin  // if it's a last line
		  if PrintingIsIP then
			  ABrush.Color := NormalBkColor
      else
	      ABrush.Color := clSpecBkColor; //TColor($DDDDDD);
      AFont.Style := [fsBold];
    end
    else begin
		  if PrintingIsIP then begin
			  ABrush.Color := NormalBkColor;
	      AFont.Style := NormalFontStyle;
      end
      else begin
//          if StrGrid.Cells[0,ARow] = 'cwinc' then begin
        if (FmtList <> nil) and (FmtList.Count > ARow) and (FmtList[ARow] = 'cwinc') then begin
	        AFont.Style := [fsBold];
          AFont.Color	:= clRed;
          AFont.Size := AFont.Size + 2;
        end
				else if (fmtList.Count > ARow) and (FmtList[ARow] = 'f1__') then begin
	        AFont.Style := [fsBold];
        end
        else
		      AFont.Style := NormalFontStyle;
        ABrush.Color := clSpecBkColor;//NormalBkColor;
      end;
    end;
    Exit;
  end;

  case CurValue of
    4 : begin
    	AFont.Color := clBlack;
      if ARow = 0 then begin                     // for header
        ABrush.Color := clSpecBkColor;
        AFont.Style := [fsBold];
      end
//      else if ARow = CurGridRows - 1 then begin  // if it's a last line
      else if ARow = StrGrid.RowCount - 1 then begin  // if it's a last line
			  if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
	        ABrush.Color := clSpecBkColor;
        AFont.Style := [fsBold];
      end
      else begin
			  if PrintingIsIP then begin
					ABrush.Color := NormalBkColor;
	        AFont.Style := NormalFontStyle;
        end
        else begin
          if StrGrid.Cells[0,ARow] = 'cwinc' then begin
	          AFont.Style := [fsBold];
            AFont.Color	:= clRed;
            AFont.Size := AFont.Size + 3;
          end
          else
		        AFont.Style := NormalFontStyle;
	        ABrush.Color := clSpecBkColor;//NormalBkColor;
        end;
      end;
    end; // case of 4
    2, 3, (*4,*) 8 : begin
    	AFont.Color := clBlack;
      if ARow = 0 then begin                     // for header
        ABrush.Color := clSpecBkColor;//TColor($56BBF9);
        AFont.Style := [fsBold];
      end
//      else if ARow = CurGridRows - 1 then begin  // if it's a last line
      else if ARow = StrGrid.RowCount - 1 then begin  // if it's a last line
			  if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
	        ABrush.Color := clSpecBkColor; //TColor($DDDDDD);
        AFont.Style := [fsBold];
      end
      else begin
			  if PrintingIsIP then begin
					ABrush.Color := NormalBkColor;
	        AFont.Style := NormalFontStyle;
        end
        else begin
          if StrGrid.Cells[0,ARow] = 'cwinc' then begin
	          AFont.Style := [fsBold];
            AFont.Color	:= clRed;
            AFont.Size := AFont.Size + 3;
          end
          else
		        AFont.Style := NormalFontStyle;
	        ABrush.Color := clSpecBkColor;//NormalBkColor;
        end;
      end;
    end; // case of 3, 4...
    6 : begin
      if ('t__' = StrGrid.Cells[0, aRow]) or (ARow = 0) then begin // header or footer
      	AFont.Style 	:= [fsBold];
      end
      else begin
      	AFont.Style 	:= [];
      end;
      AFont.Color 	:= TColor($000000);  // clBlue
      ABrush.Color 	:=  clSpecBkColor;//TColor($93FFFF); //clYellow
    end;
    5 : begin
        if Pos('h__', StrGrid.Cells[0, aRow]) > 0 then begin // section header
          AFont.Style := [fsBold];
          AFont.Color := TColor($FF0000);  // clBlue
          ABrush.Color :=  clSpecBkColor;//TColor($93FFFF); //clYellow
        end
        else if Pos('s__', StrGrid.Cells[0, aRow]) > 0 then begin // section subheader
          AFont.Style := [fsBold];
          ABrush.Color :=  clSpecBkColor; //TColor($FFFFFF) //clWhite
        end
        else if Pos('t__', StrGrid.Cells[0, aRow]) > 0 then begin // totals
          case aCol of
            1, 9 : begin
              if StrGrid.Cells[aCol, aRow] <> '' then begin
                AFont.Style := [fsBold];
                AFont.Color := TColor($FF0000);  // clBlue
                ABrush.Color := clSpecBkColor;// TColor($FFFFFF) //clWhite
              end
              else begin
                AFont.Style := [];
                AFont.Color := TColor($000000);  // clBlack
                ABrush.Color :=  clSpecBkColor; //TColor($DDDDDD) //clWhite
              end;
            end;
            4, 11 : begin
              AFont.Style := [fsBold];
              AFont.Color := TColor($000000);  // clBlack
              ABrush.Color := clSpecBkColor;// TColor($FFFFFF) //clWhite
            end;
            else begin
              AFont.Style := [];
              AFont.Color := TColor($000000);  // clBlack
              ABrush.Color := clSpecBkColor;// TColor($DDDDDD) //clWhite
            end;
          end;
//          AFont.Style := [fsBold];
//          ABrush.Color :=  TColor($FFFFFF) //clWhite
        end
        else begin
          AFont.Style := [];
          ABrush.Color :=  clSpecBkColor; //TColor($DDDDDD) //clWhite
        end;
    end; // case of 5
    7 : begin
//      ABrush.Color := TColor($AAAAFF); // clRed
			AFont.Style := [];
      if ARow = 0 then begin
        ABrush.Color := TColor($56BBF9);
        AFont.Style := [fsBold];
      end
      else begin
//        if rsSubdPOFilterRow = StrGrid.Cells[0, aRow] then begin
        if (rsSubdPOFilterRow = StrGrid.Cells[0, aRow]) or (rsRejdPOFilterRow = StrGrid.Cells[0, aRow]) or (rsAppdPOFilterRow = StrGrid.Cells[0, aRow]) or (rsPaidPOFilterRow = StrGrid.Cells[0, aRow]) then begin
          AFont.Color := clBlue;
          if StrGrid.Cells[ACol, aRow] <> '[' + rsFilterIsInactive + ']' then
		        AFont.Style := [fsBold];
//          ABrush.Color := clSpecBkColor // TColor($AAAAFF); // clRed
        end
        else if Pos(rsAppdPORow, StrGrid.Cells[0, aRow]) > 0 then begin
          AFont.Color := clGreen; //TColor($AAFFAA); // clGreen
          ABrush.Color := clSpecBkColor; 							//TColor($AAFFAA) // clGreen
        end
        else if Pos(rsSubdPORow, StrGrid.Cells[0, aRow]) > 0 then begin
          ABrush.Color := clSpecBkColor;								// TColor($93FFFF) //clYellow
          AFont.Color := clBlack; //TColor($AAFFAA); // clGreen
        end
        else if Pos(rsRejdPORow, StrGrid.Cells[0, aRow]) > 0 then begin
          AFont.Color := clRed;
          ABrush.Color := clSpecBkColor // TColor($AAAAFF); // clRed
        end
//        else if Pos('blue', StrGrid.Cells[0, aRow]) > 0 then begin
//          AFont.Color := clBlue;
//          ABrush.Color := clSpecBkColor // TColor($AAAAFF); // clRed
//        end
        else if Pos('gray', StrGrid.Cells[0, aRow]) > 0 then begin
//          ABrush.Color := clSpecBkColor								//clSilver
          AFont.Color := clGray;								//clSilver
          ABrush.Color := clSpecBkColor;								//clSilver
        end
        else
          ABrush.Color := clSpecBkColor; //NormalBkColor;

        if Pos('_urgent', StrGrid.Cells[0, aRow]) > 0 then
          AFont.Color := clRed;

        if (Pos('h_', StrGrid.Cells[0, aRow]) > 0) or (Pos('sub_', StrGrid.Cells[0, aRow]) > 0) then begin
          AFont.Style := [fsBold];
          ABrush.Color := clSpecBkColor; //NormalBkColor;
        end
//        else if (ARow <> 0) and ((rsSubdPOFilterRow <> StrGrid.Cells[0, aRow]) and (StrGrid.Cells[ACol, aRow] = '[' + rsFilterIsInactive + ']')) then
//          AFont.Style := NormalFontStyle;
      end;
    end; // case of 7
    9 : begin
    	AFont.Color := clBlack;
      if ARow = 0 then begin                     // for header
        ABrush.Color := clSpecBkColor;//TColor($56BBF9);
        AFont.Style := [fsBold];
      end
//      else if ARow = CurGridRows - 1 then begin  // if it's a last line
      else if ARow = 1 then begin  // if it's a last line
			  if PrintingIsIP then
					ABrush.Color := NormalBkColor
        else
	        ABrush.Color := clSpecBkColor; //TColor($DDDDDD);
        AFont.Style := [fsBold];
      end
      else begin
			  if PrintingIsIP then begin
					ABrush.Color := NormalBkColor;
	        AFont.Style := NormalFontStyle;
        end
        else begin
          if StrGrid.Cells[0,ARow] = 'cwinc' then begin
	          AFont.Style := [fsBold];
            AFont.Color	:= clRed;
            AFont.Size := AFont.Size + 2;
          end
          else begin
		        AFont.Style := NormalFontStyle;
          end;
          if ARow mod 2 = 0 then begin
  	        ABrush.Color := clSpecBkColor;
            //AFont.Color	:= clBlack;
          end
          else begin
	          ABrush.Color := clSpecBkColorLight;
            //AFont.Color	:= clMyDarkGray;
          end;
        end;

      end;
    end; // case of 9
    13, 14 : begin // debt-cret page
//      ABrush.Color := TColor($AAAAFF); // clRed
      if ARow = 0 then begin
        ABrush.Color := TColor($56BBF9);
        AFont.Style := [fsBold];
      end
      else begin
        if Pos('green', StrGrid.Cells[0, aRow]) > 0 then begin
          AFont.Color := clGreen; //TColor($AAFFAA); // clGreen
          ABrush.Color := clSpecBkColor; 							//TColor($AAFFAA) // clGreen
        end
        else if Pos('yellow', StrGrid.Cells[0, aRow]) > 0 then begin
          ABrush.Color := clSpecBkColor;								// TColor($93FFFF) //clYellow
          AFont.Color := clBlack; //TColor($AAFFAA); // clGreen
        end
        else if Pos('red', StrGrid.Cells[0, aRow]) > 0 then begin
          AFont.Color := clRed;
          ABrush.Color := clSpecBkColor // TColor($AAAAFF); // clRed
        end
        else if Pos('blue', StrGrid.Cells[0, aRow]) > 0 then begin
          AFont.Color := clBlue;
          ABrush.Color := clSpecBkColor // TColor($AAAAFF); // clRed
        end
        else if Pos('gray', StrGrid.Cells[0, aRow]) > 0 then begin
//          ABrush.Color := clSpecBkColor								//clSilver
          AFont.Color := clGray;								//clSilver
          ABrush.Color := clSpecBkColor;								//clSilver
        end
        else
          ABrush.Color := clSpecBkColor; //NormalBkColor;
        if Pos('_urgent', StrGrid.Cells[0, aRow]) > 0 then
          AFont.Color := clRed;
        if (Pos('h_', StrGrid.Cells[0, aRow]) > 0) or (Pos('sub_', StrGrid.Cells[0, aRow]) > 0) then begin
          AFont.Style := [fsBold];
          ABrush.Color := clSpecBkColor; //NormalBkColor;
        end
        else if ARow <> 0 then
          AFont.Style := NormalFontStyle;
      end;
    end; // case of 13, 14
    101,100 : begin       						// 	LIST_DEBITORS
      if ARow = 0 then begin                     // for header
        ABrush.Color := clSpecBkColor;
        AFont.Style := [fsBold];
      end
      else begin
			  if PrintingIsIP then begin
					ABrush.Color := NormalBkColor;
	        AFont.Style := NormalFontStyle;
        end
        else begin
          AFont.Color	:= clBlack;
          if ACol = 4 then
            if CurValue = LIST_DEBITORS then
			        ABrush.Color := GetDebtorColor(StrGrid.Cells[4, ARow])
            else
			        ABrush.Color := GetCreditorColor(StrGrid.Cells[4, ARow])
          else
		        ABrush.Color := clSpecBkColor;
          if TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[5, ARow], '.',','),ThSep,''), TmpVal) and
  	        	(TmpVal > 0) then
		        AFont.Style := [fsBold]
          else
		        AFont.Style := NormalFontStyle;
        end;

      end;
    end; // case of 100, 101
  end;
//  end;
end;

procedure TMainFPForm.StrGridGetCellPrintBorder(Sender: TObject; ARow, ACol: Integer; APen: TPen;
  var Borders: TCellBorders);
begin
	if (ARow = 0) and (CurValue = 7) then begin
  	Borders := Borders - [cbLeft, cbRight, cbTop];
  end;
	if ACol = 0 then begin
  	Borders := [];
	end
  else if ACol < 9 then begin
  	Borders := Borders - [cbRight];
  end;
end;

procedure TMainFPForm.StrGridGetCellPrintColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState;
  ABrush: TBrush; AFont: TFont);
begin
	ABrush.Color	:= NormalBkColor;
  AFont.Color		:= clBlack;
end;

procedure TMainFPForm.StrGridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor: TEditorType);
begin
  //
  with StrGrid do begin
    if (Pos('b__', StrGrid.Cells[0, ARow]) > 0) or (Pos('c__', StrGrid.Cells[0, ARow]) > 0)  then
      case ACol of
        15: begin
          aEditor := edComboList;
          ClearComboString;
//          if Cells[1, ARow] <> '' then
//            if FileExists(Cells[1, ARow] + '.dat') then
//              ComboBox.Items.LoadFromFile(Cells[1, ARow] + '.dat');
//              ComboBox.Items.Assign(TmpFundCombo);
              ComboBox.Items.Assign(TmpFundCombo.Items);
//              ComboBox.Assign(TmpFundCombo);
        end;

      end;
    if (Pos('f__', StrGrid.Cells[0, ARow]) > 0) then
      case ACol of
        11: begin
          aEditor := edComboList;
          ClearComboString;
          ComboBox.Items.Add('Отложить');
          ComboBox.Items.Add('Отклонить');
          ComboBox.Items.Add('Одобрить');
        end;
        15: begin
          aEditor := edComboList;
          ClearComboString;
          ComboBox.Items.Assign(TmpFundCombo.Items);
        end;

      end;
  end;

end;

procedure TMainFPForm.StrGridGetFormat(Sender: TObject; ACol: Integer;
  var AStyle: TSortStyle; var aPrefix, aSuffix: string);
begin
  case ACol of
//    0: AStyle := ssAlphaNoCase;
//    1: AStyle := ssAlphaNoCase;
    3: AStyle := ssNumeric;
  else
      AStyle := ssAlphaNoCase;
  end;

end;

procedure TMainFPForm.StrGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
	procedure SearchNextHeader(Key: Word);
  var
  	i : integer;
  begin
   	LockWindowUpdate(StrGrid.Handle);
  	i := StrGrid.Row;
  	repeat
    	if Key = VK_UP then begin
      	Dec(i);
      end
      else begin
        Inc(i);
      end;
      if i<=0 then begin
		  	StrGrid.Row := 0;
        break;
      end;
      if i>= StrGrid.RowCount then begin
		  	StrGrid.Row := StrGrid.RowCount - 1;
        break;
      end;
      if (LeftStr(StrGrid.Cells[0, i], 2) = 'h_') then begin
		  	StrGrid.Row := i;
        break;
      end;
    until false;
   	LockWindowUpdate(0);
  end; // SearchNextHeader

  procedure CopyRowsToClipboard;
  var
  	li							: integer;
  	lj							: integer;
    StrToClipBoard	: string;
    TmpInt					: integer;
  begin
  	StrToClipBoard := '';
  	case CurValue of
    	2 : begin
	    	for li := 0 to StrGrid.SelectedRowCount - 1 do begin
        	StrToClipBoard := StrToClipBoard + StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
                          	ReplaceStr(MyCleanStr(StrGrid.Cells[2, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #$D#$A;
    	  end;
      end;  // 2
    	4 : begin   // FUNDS
	    	for li := 0 to StrGrid.SelectedRowCount - 1 do begin
	        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
  	                        	ReplaceStr(MyCleanStr(StrGrid.Cells[2, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
  	                        	ReplaceStr(MyCleanStr(StrGrid.Cells[3, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
  	                        	ReplaceStr(MyCleanStr(StrGrid.Cells[4, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        										StrGrid.Cells[5, StrGrid.SelectedRow[li]] + #$D#$A
        end;
      end;  // 4
    	3,8 : begin
	    	for li := 0 to StrGrid.SelectedRowCount - 1 do begin
        	if TryStrToInt(StrGrid.Cells[1, StrGrid.SelectedRow[li]], TmpInt) then
	        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
  	                        	ReplaceStr(MyCleanStr(StrGrid.Cells[3, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        										StrGrid.Cells[4, StrGrid.SelectedRow[li]] + #$D#$A
          else
	        	StrToClipBoard := StrToClipBoard +
	        										' ' + #9 +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
  	                        	ReplaceStr(MyCleanStr(StrGrid.Cells[3, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        										' ' + #$D#$A;
    	  end;
      end; // 3,8
    	6 : begin //
	    	for li := 0 to StrGrid.SelectedRowCount - 1 do begin
        	for lj := 1 to StrGrid.ColCount - 1 do begin
          	if lj <= 3 then
		        	StrToClipBoard := StrToClipBoard + //MyCleanStr(StrGrid.Cells[lj, StrGrid.SelectedRow[li]])
              	ReplaceStr(ReplaceStr(ReplaceStr(ReplaceStr(ReplaceStr(StrGrid.Cells[lj, StrGrid.SelectedRow[li]], CRLF, ', '), #10, ''), #13, ''), '<b>', ', '), '</b>', '')
            else
		        	StrToClipBoard := StrToClipBoard + ReplaceStr(MyCleanStr(StrGrid.Cells[lj, StrGrid.SelectedRow[li]]),	CRLF,	' ');
          	if lj < StrGrid.ColCount - 1 then
		        	StrToClipBoard := StrToClipBoard + #9;
          end;
  	      StrToClipBoard := StrToClipBoard +  #$D#$A
    	  end;
      end; // 9
    	7 : begin // POs
	    	for li := 0 to StrGrid.SelectedRowCount - 1 do begin
        	if StrGrid.Cells[0, StrGrid.SelectedRow[li]] = rsSubdPOHeaderRow then begin
          	if rsSubdPOHeaderNum = StrGrid.Cells[1, StrGrid.SelectedRow[li]] then
			        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[3, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[7, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[8, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[9, StrGrid.SelectedRow[li]] + #$D#$A
            else
			        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #$D#$A;
          end //if StrGrid.Cells[0, StrGrid.SelectedRow[li]] = rsSubdPOHeaderRow
          else if (rsSubdPORow = StrGrid.Cells[0, StrGrid.SelectedRow[li]]) or (rsSubdPOUrgentRow = StrGrid.Cells[0, StrGrid.SelectedRow[li]]) then begin
			    	StrToClipBoard := StrToClipBoard +
            	StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[3, StrGrid.SelectedRow[li]] + #9 +
	        		ReplaceStr(MyCleanStr(StrGrid.Cells[7, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        		StrGrid.Cells[8, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[9, StrGrid.SelectedRow[li]] + #$D#$A
          end //if (rsSubdPORow = StrGrid.
          else if '' = StrGrid.Cells[0, StrGrid.SelectedRow[li]] then begin
			    	StrToClipBoard := StrToClipBoard + ' ' + #$D#$A
          end //if ''
        	else if rsRejdPOHeaderRow = StrGrid.Cells[0, StrGrid.SelectedRow[li]] then begin
          	if rsRejdPOHeaderNum = StrGrid.Cells[1, StrGrid.SelectedRow[li]] then
			        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[3, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[7, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[8, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[9, StrGrid.SelectedRow[li]] + #$D#$A
            else
			        	StrToClipBoard := StrToClipBoard + StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #$D#$A;
          end //if Pos('h_red',
          else if rsRejdPORow = StrGrid.Cells[0, StrGrid.SelectedRow[li]] then begin
			    	StrToClipBoard := StrToClipBoard +
            	StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[3, StrGrid.SelectedRow[li]] + #9 +
//              MyCleanStr(StrGrid.Cells[6, StrGrid.SelectedRow[li]]) + #9 +
              ReplaceStr(MyCleanStr(StrGrid.Cells[7, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        		StrGrid.Cells[8, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[9, StrGrid.SelectedRow[li]] + #$D#$A
          end //if rsRejdPORow
        	else if (rsAppdPOHeaderRow = StrGrid.Cells[0, StrGrid.SelectedRow[li]]) then begin // approved POs header
          	if rsAppdPOHeaderNum = StrGrid.Cells[1, StrGrid.SelectedRow[li]] then
			        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[3, StrGrid.SelectedRow[li]] + #9 +
//	        										StrGrid.Cells[4, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[5, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[6, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[7, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[8, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[9, StrGrid.SelectedRow[li]] + #$D#$A
            else
			        	StrToClipBoard := StrToClipBoard + StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #$D#$A;
          end //if Pos(rsAppdPOHeaderRow,
          else if (rsAppdPORow = StrGrid.Cells[0, StrGrid.SelectedRow[li]]) or (rsAppdPOUrgentRow = StrGrid.Cells[0, StrGrid.SelectedRow[li]]) then begin  // Approved PO raw
			    	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[3, StrGrid.SelectedRow[li]] + #9 +
//								              MyCleanStr(StrGrid.Cells[4, StrGrid.SelectedRow[li]]) + #9 +
              								ReplaceStr(MyCleanStr(StrGrid.Cells[5, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
              								ReplaceStr(MyCleanStr(StrGrid.Cells[6, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        										StrGrid.Cells[7, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[8, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[9, StrGrid.SelectedRow[li]] + #$D#$A
          end //if rsAppdPOUrgentRow
        	else if (rsPaidPOHeaderRow = StrGrid.Cells[0, StrGrid.SelectedRow[li]]) then begin // Paid POs header
          	if rsAppdPOHeaderNum = StrGrid.Cells[1, StrGrid.SelectedRow[li]] then
			        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[ 1, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 2, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 3, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 4, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 5, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 6, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 7, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 8, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 9, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[10, StrGrid.SelectedRow[li]] + #$D#$A
            else
			        	StrToClipBoard := StrToClipBoard + StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #$D#$A;
          end //if rsPaidPOHeaderRow =
          else if (rsPaidPORow = StrGrid.Cells[0, StrGrid.SelectedRow[li]]) or (rsPaidPOUrgentRow = StrGrid.Cells[0, StrGrid.SelectedRow[li]]) then begin // Paid PO raw
	        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[ 1, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 2, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 3, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 4, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 5, StrGrid.SelectedRow[li]] + #9 +
              								ReplaceStr(MyCleanStr(StrGrid.Cells[6, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        										StrGrid.Cells[ 7, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 8, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[ 9, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[10, StrGrid.SelectedRow[li]] + #$D#$A
          end //if rsAppdPOUrgentRow
    	  end; // for li := 0 to StrGrid.SelectedRowCount - 1
      end; // 7
    	9 : begin //
	    	for li := 0 to StrGrid.SelectedRowCount - 1 do begin
	        	StrToClipBoard := StrToClipBoard +
            									StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        										StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        										ReplaceStr(StrGrid.Cells[3, StrGrid.SelectedRow[li]], CRLF,	' ') + #9 +
  	                        	MyCleanStr(StrGrid.Cells[4, StrGrid.SelectedRow[li]]) + #9 +
  	                        	MyCleanStr(StrGrid.Cells[5, StrGrid.SelectedRow[li]]) + #9 +
  	                        	MyCleanStr(StrGrid.Cells[6, StrGrid.SelectedRow[li]]) + #$D#$A
    	  end;
      end; // 9
    	13,14 : begin // Debtors/creditors
	    	for li := 0 to StrGrid.SelectedRowCount - 1 do begin
        	if LeftStr(StrGrid.Cells[0, StrGrid.SelectedRow[li]], 2) = 'h_' then begin
	        	StrToClipBoard := StrToClipBoard + StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #$D#$A;
          end //
          else if '' = StrGrid.Cells[0, StrGrid.SelectedRow[li]] then begin
			    	StrToClipBoard := StrToClipBoard + ' ' + #$D#$A
          end //if ''
          else begin //if 'green' = StrGrid.Cells[0, StrGrid.SelectedRow[li]] then begin
			    	StrToClipBoard := StrToClipBoard +
            	StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[3, StrGrid.SelectedRow[li]] + #9 +
	        		ReplaceStr(ReplaceStr(ReplaceStr(ReplaceStr(ReplaceStr(StrGrid.Cells[4, StrGrid.SelectedRow[li]], CRLF, ', '), #10, ''), #13, ''), '<b>', ', '), '</b>', '') + #9 +
	        		ReplaceStr(MyCleanStr(StrGrid.Cells[5, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        		ReplaceStr(MyCleanStr(StrGrid.Cells[6, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #9 +
	        		StrGrid.Cells[7, StrGrid.SelectedRow[li]] + #$D#$A
          end
    	  end; // for li := 0 to StrGrid.SelectedRowCount - 1
      end; // 13,14
    	100,101 : begin // list of Debtors/creditors
	    	for li := 0 to StrGrid.SelectedRowCount - 1 do begin
			    	StrToClipBoard := StrToClipBoard +
            	StrGrid.Cells[1, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[2, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[3, StrGrid.SelectedRow[li]] + #9 +
	        		StrGrid.Cells[4, StrGrid.SelectedRow[li]] + #9 +
	        		ReplaceStr(MyCleanStr(StrGrid.Cells[5, StrGrid.SelectedRow[li]]),	CRLF,	' ') + #$D#$A
    	  end; // for li := 0 to StrGrid.SelectedRowCount - 1
      end; // 100, 101
    end;
    Clipboard.SetTextBuf(PWideChar(StrToClipBoard));
  end;
begin
	if (Key in [VK_UP, VK_DOWN]) and (Shift = [ssCtrl]) then
  	SearchNextHeader(Key);

//	if ((Char(Key) = 'F') and ([ssCtrl] = Shift)) and (CurValue in [101, 100, 7]) then begin
//		ShowSearchFooter;
//    Key := 0;
//  end;
  if ((Key = VK_INSERT) or (Char(Key) = 'C') or (Char(Key) = 'c')) and ([ssCtrl] = Shift) then begin
  	CopyRowsToClipboard;
  end;
  inherited;
end;

procedure TMainFPForm.StrGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  nRow  	: integer;
  nCol  	: integer;
  TmpInt	: integer;
begin
  StrGrid.Hint := '';
  StrGrid.MouseToCell(x, y, nCol, nRow);
  if ((nRow < 0) or (nRow > StrGrid.RowCount - 1)) or ((nCol < 0) or (nCol > StrGrid.ColCount - 1)) then Exit;

  if (StrGrid.Cells[0, nRow] = rsSubdPOFilterRow) or (StrGrid.Cells[0, nRow] = rsRejdPOFilterRow) or (StrGrid.Cells[0, nRow] = rsAppdPOFilterRow) or (StrGrid.Cells[0, nRow] = rsPaidPOFilterRow) then begin //clicked on the submitted POs FILTER
		if StrGrid.Cells[nCol, nRow] = '[' + rsFilterIsInactive + ']' then
    	StrGrid.Hint :=  '[' + rsFltIsInactStr + ']'
    else
    	StrGrid.Hint := StrGrid.Cells[nCol, nRow];
  end
  else if (nRow >= 0) and (nRow < StrGrid.RowCount) then
    StrGrid.Hint := StrGrid.Cells[nCol, nRow]
  else
    StrGrid.Hint := '';

  // setting up a proper cursor for a proper cell
	if ((CurValue = BRANCH_DEBITORS) or (CurValue = BRANCH_CREDITORS)) and
    	((nRow >= 0) and (nCol >=0) and (nRow < StrGrid.RowCount) and (nCol < StrGrid.ColCount) and
	      (
	    		(TryStrToInt(StrGrid.Cells[1, nRow], TmpInt) and (StrGrid.Cells[3, nRow]=''))
  	    )
      ) then
		Screen.Cursor := crHandPoint
  else
  	Screen.Cursor := crDefault;
end;

procedure TMainFPForm.StrGridRightClickCell(Sender: TObject; ARow, ACol: Integer);
var
  Num		: integer;
	Point	: TPoint;
begin
	case CurValue of
    4	: begin // FundsList
      if (ARow > -1) and (ARow < StrGrid.RowCount - 1) then begin
        StrGrid.Row := ARow;
        StrGrid.Repaint;
				GetCursorPos(Point);
	    	PostMessage(Self.Handle, UM_FLPOPUPNEEDED, Point.X, Point.Y);
      end;
    end;
    7	: begin // POs
      if (ARow > -1) and (TryStrToInt(StrGrid.Cells[1,aRow], Num)) then begin
        StrGrid.Row := ARow;
        StrGrid.Repaint;
      end;
			GetCursorPos(Point);
    	PostMessage(Self.Handle, UM_POSPOPUPNEEDED, Point.X, Point.Y);
    end;
    13,14	: begin  // debts/credits list
      if (ARow > -1) and (TryStrToInt(StrGrid.Cells[1, aRow], Num)) then begin
        GetCursorPos(Point);
        StrGrid.Row := ARow;
        StrGrid.Repaint;
    		PostMessage(Self.Handle, UM_STRGRIDPOPUPNEEDED, Point.X, Point.Y);
      end;
    end; // 13, 14
    100, 101 : begin  // debtors/creditors list
    	CurStrGridRow := aRow;
      if CurStrGridRow > 0 then begin
        StrGrid.Row := CurStrGridRow; //ARow;
        StrGrid.Repaint;
      end;
      GetCursorPos(Point);
  		PostMessage(Self.Handle, UM_DEBCREDPOPUPNEEDED, Point.X, Point.Y);
    end; // 100, 101
    LIST_PERSONS : begin  // debtors/creditors list
    	CurStrGridRow := aRow;
      if CurStrGridRow > 0 then begin
        StrGrid.Row := CurStrGridRow; //ARow;
        StrGrid.Repaint;
      end;
      GetCursorPos(Point);
  		PostMessage(Self.Handle, UM_PERS_POPUPNEEDED, Point.X, Point.Y);
    end; // 100, 101

  end;
end;

procedure TMainFPForm.StrGridSelectionChanged(Sender: TObject; ALeft, ATop, ARight, ABottom: Integer);
var
	i : integer;
  j : integer;
  TmpSum : extended;
  TotSum : extended;
begin
	sb.SimpleText := '';
  if not (CurValue in [13,14]) then exit;

  j := 1;
  TotSum := 0;
	for i := 0 to StrGrid.SelectedRowCount - 1 do begin
		if not TryStrToFloat(MyCleanStr(StrGrid.Cells[5, StrGrid.SelectedRow[i]]), TmpSum) then TmpSum := 0;
    TotSum := TotSum + TmpSum;
	end;
	if (Trunc(TotSum * 100) <> 0) then
		sb.SimpleText := 'Сумма: ' + MyFloatToStr(TotSum);
end;

procedure TMainFPForm.StrGridUpdateColumnSize(Sender: TObject; ACol: Integer; var AWidth: Integer);
begin
  IniFile.WriteInteger(sIniSection, 'C' + IntToStr(ACol), AWidth);
end;

procedure TMainFPForm.StringEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(13) then
    SearchToolButtonClick(Sender);
end;

procedure TMainFPForm.SubmittedPOPopUpClick(Sender: TObject);
begin
//	if ShowSubmittedPOsOnly then //  if it's already ON we do not do anything
//  	Exit;
	ShowAllPOs := false;
	ShowSubmittedPOsOnly	:= true;
	ShowRejectedPOsOnly 	:= false;
	ShowApprovedPOsOnly 	:= false;
	ShowPaidPOsOnly 			:= false;
	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowSubmittedPOsOnly', ShowSubmittedPOsOnly);
    IniFile.UpdateFile;
  end;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default	:= true;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default	:= false;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked := false;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);

end;

procedure TMainFPForm.SubmittedPOPopUpSHClick(Sender: TObject);
begin
	if ShowAllPOs and (not ShowSubmittedPOsOnly) then begin // Submitted POS are still show even if ShowSubmittedPOsOnly is false
		ShowSubmittedPOsOnly := true;
		ShowAllPOs := false;
  end;

  ShowSubmittedPOsOnly := not ShowSubmittedPOsOnly;

	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowSubmittedPOsOnly', ShowSubmittedPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowAllPOs', 					ShowAllPOs);
    IniFile.UpdateFile;
  end;

  if not ShowSubmittedPOsOnly then begin
	  ShowRejectedPOsOnly := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked;
  	ShowApprovedPOsOnly	:= POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked;
	  ShowPaidPOsOnly			:= POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked;
  end;

  ShowAllPOs := ShowSubmittedPOsOnly and ShowRejectedPOsOnly and ShowApprovedPOsOnly and ShowPaidPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked := ShowAllPOs or ShowSubmittedPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default	:= false;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);

end;

procedure TMainFPForm.SubmittedPOToolBtnClick(Sender: TObject);
var
	i : integer;
begin
	i := 1;
	while i<StrGrid.RowCount - 1 do begin
  	if StrGrid.Cells[0, i] = rsSubdPOHeaderRow then begin
    	LockWindowUpdate(StrGrid.Handle);
    	StrGrid.Row := i;
    	LockWindowUpdate(0);
      break;
    end;
    inc(i);
  end;
  StrGrid.SetFocus;
end;

procedure TMainFPForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainFPForm.PaidPOPopUpClick(Sender: TObject);
begin
//	if ShowPaidPOsOnly then //  if it's already ON we do not do anything
//  	Exit;

	ShowAllPOs := false;
	ShowSubmittedPOsOnly 	:= false;
	ShowRejectedPOsOnly 	:= false;
	ShowApprovedPOsOnly 	:= false;
	ShowPaidPOsOnly 			:= true;
	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowPaidPOsOnly', ShowPaidPOsOnly);
    IniFile.UpdateFile;
  end;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := true;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default	:= true;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked := true;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);

end;

procedure TMainFPForm.PaidPOPopUpSHClick(Sender: TObject);
begin
	if ShowAllPOs and (not ShowPaidPOsOnly) then begin // Submitted POS are still show even if ShowSubmittedPOsOnly is false
		ShowPaidPOsOnly := true;
		ShowAllPOs := false;
  end;

  ShowPaidPOsOnly := not ShowPaidPOsOnly;

	if WorkingWithIni then begin
  	IniFile.WriteBool(POIniSection, 'ShowPaidPOsOnly', ShowPaidPOsOnly);
  	IniFile.WriteBool(POIniSection, 'ShowAllPOs', 		 ShowAllPOs);
    IniFile.UpdateFile;
  end;

  if not ShowPaidPOsOnly then begin
	  ShowSubmittedPOsOnly := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[0].Checked;
  	ShowRejectedPOsOnly	 := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[1].Checked;
	  ShowApprovedPOsOnly	 := POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[2].Checked;
  end;

  ShowAllPOs := ShowSubmittedPOsOnly and ShowRejectedPOsOnly and ShowApprovedPOsOnly and ShowPaidPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWHIDEPOS].Items[3].Checked := ShowAllPOs or ShowPaidPOsOnly;

  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[0].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[1].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[2].Default	:= false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Checked := false;
  POsPopUpMenu.Items[SGPM_SHOWFILER].Items[3].Default	:= false;

	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.PaidPOToolBtnClick(Sender: TObject);
var
	i : integer;
begin
	i := 2;
	while i<StrGrid.RowCount - 1 do begin
  	if StrGrid.Cells[0, i] = 'h_gray' then begin
    	LockWindowUpdate(StrGrid.Handle);
    	StrGrid.Row := i;
    	LockWindowUpdate(0);
      break;
    end;
    inc(i);
  end;
  StrGrid.SetFocus;
end;

procedure TMainFPForm.PersAddClick(Sender: TObject);
var
  PEF     : TPersonEditForm;
  NoError : boolean;
  fio     : string;
  NewSID   : string;
  NewRecID, i : integer;
  RecFound : boolean;
begin
  PEF := TPersonEditForm.Create(nil);
  if (PEF.ShowModal = mrOk) then begin
    NoError := true;
    try
      FPCOnnection.StartTransaction;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'Ошибка при инициализации транзакции.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;

    if NoError then begin
 		  FPMainDataset.SQL.Text := 'INSERT INTO persons(`FamilyName`,`FirstName`,`MiddleName`,`Country`,`PostalIndex`,`Address`,`PassportSeries`,`PassportNumber`,`PhoneHome`,`PhoneMobile`,`email`)VALUES'+
                                '(:fFamilyName,:fFirstName,:fMiddleName,:fCountry,:fPostalIndex,:fAddress,:fPassportSeries,:fPassportNumber,:fPhoneHome,:fPhoneMobile,:femail)';
	    FPMainDataset.ParamByName('fFamilyName').AsString 		:= PEF.FamilyNameEdit.Text;
  	  FPMainDataset.ParamByName('fFirstName').AsString	    := PEF.FirstNameEdit.Text;
  	  FPMainDataset.ParamByName('fMiddleName').AsString	    := PEF.MiddleNameEdit.Text;
  	  FPMainDataset.ParamByName('fCountry').AsString	      := PEF.CountryEdit.Text;
  	  FPMainDataset.ParamByName('fPostalIndex').AsString	  := PEF.PostalIndexEdit.Text;
  	  FPMainDataset.ParamByName('fAddress').AsString	      := PEF.AddressEdit.Text;
  	  FPMainDataset.ParamByName('fPassportSeries').AsString	:= PEF.PassportSeriesEdit.Text;
  	  FPMainDataset.ParamByName('fPassportNumber').AsString	:= PEF.PassportNumberEdit.Text;
  	  FPMainDataset.ParamByName('fPhoneHome').AsString	    := PEF.PhoneHomeEdit.Text;
  	  FPMainDataset.ParamByName('fPhoneMobile').AsString	  := PEF.PhoneMobileEdit.Text;
  	  FPMainDataset.ParamByName('femail').AsString	        := PEF.EMailEdit.Text;
      try
      	FPMainDataset.ExecSQL;
      except
  	    on e: EZSQLException do begin
          ShowError(Self, 'Ошибка при сохранении данных о контрагенте.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
	      end;
      end;
    end;

    FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
    try                     // saving filename only - the file will be saved later
      FPMainDataset.Open;
      if not FPMainDataset.Eof then
        NewSID := FPMainDataset.FieldByName('ID').AsString;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'Произошла ошибка при получении индекса.', e.ErrorCode, e.StatusCode, e.Message + ' @ SELECT_LAST_ID');
        NoError := false;
      end;
    end;


    if NoError then begin
      try
        FPCOnnection.Commit;
      except
    	  on e: EZSQLException do begin
          ShowError(Self, 'Невозможно записать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
	    end;
    end;

    if not NoError then begin
      try
        FPCOnnection.Rollback;
      except
    	  on e: EZSQLException do begin
          ShowError(Self, 'Ошибка при откате транзакции.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
	    end;
    end; // if not NoError ...

    // update the main grid
    if NoError then begin
      fio     := GetShortFIO(PEF.FamilyNameEdit.Text, PEF.FirstNameEdit.Text, PEF.MiddleNameEdit.Text);
      RecFound := false;
      for i:=1 to StrGrid.RowCount do begin
        if fio < strGrid.Cells[1, i]  then begin
          RecFound := true;
          NewRecID := i;
          break;
        end;
      end;
      if not RecFound then begin
          NewRecID := StrGrid.RowCount + 1;
      end;

      StrGrid.InsertRows(NewRecID, 1, true);
      StrGrid.Cells[0, i] := NewSID;
      StrGrid.Cells[1, i] := fio;
      StrGrid.Cells[2, i] := PEF.AddressEdit.Text;
      StrGrid.Cells[3, i] := PEF.PhoneMobileEdit.Text;
      StrGrid.Cells[4, i] := PEF.EMailEdit.Text;
      StrGrid.Cells[5, i] := MyFloatToStr(0);
      StrGrid.SelectRows(NewRecID, 1);
    end;
  end;
  PEF.Free;
end;

procedure TMainFPForm.PersListClick(Sender: TObject);
var
  TotSum				: extended;
  TotClosed			: extended;
  CurTotSum			: extended;
  CurTotClosed	: extended;
  i							: integer;
  sidx          : integer;
  LOrgPrefix    : string;
  sTbl          : string;
  PersListForm  : TDebtListForm;
  sPersonIdx    : string;
  bIsOk : boolean;
  sTable :string;
begin
//
	if CurStrGridRow < 1 then
  	Exit;

  bIsOk := true;
	PersListForm := TDebtListForm.Create(Self);

  sPersonIdx := StrGrid.Cells[0, CurStrGridRow];
  // load person data
  sTable := CurPrefix + 'persons';

  try
    FPMainDataset.SQL.Text		:= 'SELECT * FROM ' + sTable + ' WHERE idx=:fidx LIMIT 1';
    FPMainDataset.ParamByName('fidx').AsString := sPersonIdx;
    FPMainDataset.Open;
    if not FPMainDataset.Eof then begin //
      with PersListForm do begin
        sFamilyName := FPMainDataset.FieldByName('FamilyName').AsString;
        sFirstName := FPMainDataset.FieldByName('FirstName').AsString;
        sMiddleName := FPMainDataset.FieldByName('MiddleName').AsString;
        sCountry := FPMainDataset.FieldByName('Country').AsString;
        sPostalIndex := FPMainDataset.FieldByName('PostalIndex').AsString;
        sAddress := FPMainDataset.FieldByName('Address').AsString;
        sPassportSeries := FPMainDataset.FieldByName('PassportSeries').AsString;
        sPassportNumber := FPMainDataset.FieldByName('PassportNumber').AsString;
        sPhoneHome := FPMainDataset.FieldByName('PhoneHome').AsString;
        sPhoneMobile := FPMainDataset.FieldByName('PhoneMobile').AsString;
        sEMail := FPMainDataset.FieldByName('email').AsString;
      end;
    end
    else begin
      ShowError(Self, 'Читатель не найден.', 0, '', '');
      bIsOk := false;
    end;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, 'Невозможно получить данные о читателе.', e.ErrorCode, e.StatusCode, e.Message);
      bIsOk := false;
    end;
  end;

  if bIsOk then begin
    TotSum 		:= 0;
    TotClosed	:= 0;
    PersListForm.PersonToolbar.Visible := true;
    PersListForm.Caption := 'Обороты по контрагенту "' + StrGrid.Cells[1, CurStrGridRow] + '"';
    PersListForm.sPersonID := sPersonIdx;
    PersListForm.sPersonFIO := StrGrid.Cells[1, CurStrGridRow];
    PersListForm.sOrgPrefix := CurPrefix;

    // setting up the main list
    PersListForm.Width 	:= ReadIntParam(DebtListSection, 'W', 650);
    PersListForm.Left 	:= ReadIntParam(DebtListSection, 'L', (Screen.WorkAreaWidth - PersListForm.Width) div 2);
    PersListForm.Height := ReadIntParam(DebtListSection, 'H', 400);
    PersListForm.Top	 	:= ReadIntParam(DebtListSection, 'T', (Screen.WorkAreaHeight - PersListForm.Height) div 2);
    PersListForm.StrGrid.Align := alClient;
    PersListForm.StrGrid.ColCount   := 6;
    PersListForm.StrGrid.RowCount   := 2;
    PersListForm.StrGrid.FixedRows  := 1;
    PersListForm.StrGrid.ColWidths[0] := 0;
    PersListForm.StrGrid.ColWidths[1] := ReadColWidth(DebtListSection, 1, 100);
    PersListForm.StrGrid.ColWidths[2] := ReadColWidth(DebtListSection, 2, 100);
    PersListForm.StrGrid.ColWidths[3] := ReadColWidth(DebtListSection, 3, 100);
    PersListForm.StrGrid.ColWidths[4] := ReadColWidth(DebtListSection, 4, 100);
    PersListForm.StrGrid.ColWidths[5] := ReadColWidth(DebtListSection, 5, 100);
  //  PersListForm.StrGrid.ColWidths[6] := ReadColWidth(DebtListSection, 6, 100);
  //  PersListForm.StrGrid.ColWidths[7] := ReadColWidth(DebtListSection, 7, 115);

    PersListForm.StrGrid.ColumnHeaders.Clear;

    PersListForm.StrGrid.ColumnHeaders.Add('');
    PersListForm.StrGrid.ColumnHeaders.Add('Дата');
    PersListForm.StrGrid.ColumnHeaders.Add('Основание');
    PersListForm.StrGrid.ColumnHeaders.Add('Приход');
    PersListForm.StrGrid.ColumnHeaders.Add('Расход');
    PersListForm.StrGrid.ColumnHeaders.Add('Остаток');

    // setting up coorect prefix
    LOrgPrefix := CurPrefix;

    // pulling data from DB
    i := 1;

    sTbl := CurPrefix + 'person_balances';
    with FPMainDataset do begin
      SQL.Text := 'SELECT idx,Date,ServiceID,ServiceDescr,income,outcome,balance,title FROM person_balances LEFT JOIN incomesources ON ServiceID=ID WHERE`PersonID`=' + sPersonIdx + ' ORDER BY idx DESC';
      Open;
      while not Eof do begin
        with PersListForm do begin
          StrGrid.Cells[0, i]  := FieldByName('idx').AsString;
          StrGrid.Cells[1, i]  := DateToStr(FieldByName('date').AsDateTime, lFormatString);
          if FieldByName('ServiceID').AsString = '-1' then begin
            StrGrid.Cells[2, i]  := FieldByName('ServiceDescr').AsString;
          end
          else begin
            StrGrid.Cells[2, i]  := FieldByName('title').AsString;
          end;
          StrGrid.Cells[3, i]  := MyFloatToStr(FieldByName('income').AsFloat);
          StrGrid.Cells[4, i]  := MyFloatToStr(FieldByName('outcome').AsFloat);
          StrGrid.Cells[5, i]  := MyFloatToStr(FieldByName('balance').AsFloat);
        end;
        Inc(i);
        Next;
      end;
    end;

    PersListForm.StrGrid.RowCount := i;
    PersListForm.ShowModal;
  end;
  PersListForm.Free;
end;

procedure TMainFPForm.PersPropsClick(Sender: TObject);
var
  PEF     : TPersonEditForm;
  NoError : boolean;
  table : string;
  ridx  : integer;
  CurRow : integer;

  NewFIO   : string;
  NewSID   : string;
  NewRecID, i : integer;
  RecFound : boolean;

begin

  table := CurPrefix + 'persons';

  CurRow := StrGrid.Row;
	if (not TryStrToInt(StrGrid.Cells[0, CurRow], ridx)) then
	  Exit;

  // pull orig data first
  FPMainDataset.SQL.Text		:= 'SELECT * FROM ' + table + ' WHERE idx=:fidx LIMIT 1';
  FPMainDataset.ParamByName('fidx').AsInteger := ridx;
  try
    FPMainDataset.Open;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, 'Невозможно получить данные о читателе.', e.ErrorCode, e.StatusCode, e.Message);
      FPMainDataset.Close;
      exit;
    end;
  end;

  if FPMainDataset.Eof then begin //
	    ShowError(Self, 'Невозможно получить данные о читателе.', 0, '', '');
      FPMainDataset.Close;
      exit;
  end;

  PEF := TPersonEditForm.Create(nil);
  with PEF do begin
    FamilyNameEdit.Text     := FPMainDataset.FieldByName('FamilyName').AsString;
    FirstNameEdit.Text      := FPMainDataset.FieldByName('FirstName').AsString;
    MiddleNameEdit.Text     := FPMainDataset.FieldByName('MiddleName').AsString;
    CountryEdit.Text        := FPMainDataset.FieldByName('Country').AsString;
    PostalIndexEdit.Text    := FPMainDataset.FieldByName('PostalIndex').AsString;
    AddressEdit.Text        := FPMainDataset.FieldByName('Address').AsString;
    PassportSeriesEdit.Text := FPMainDataset.FieldByName('PassportSeries').AsString;
    PassportNumberEdit.Text := FPMainDataset.FieldByName('PassportNumber').AsString;
    PhoneHomeEdit.Text      := FPMainDataset.FieldByName('PhoneHome').AsString;
    PhoneMobileEdit.Text    := FPMainDataset.FieldByName('PhoneMobile').AsString;
    EMailEdit.Text          := FPMainDataset.FieldByName('email').AsString;
  end;

  // Add to DebtKindCombo all the rest stuff
  if (PEF.ShowModal = mrOk) then begin
    NoError := true;
    try
      FPCOnnection.StartTransaction;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'Ошибка при инициализации транзакции.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;

    if NoError then begin
      with FPMainDataset do begin
        SQL.Text := 'UPDATE persons SET FamilyName=:fFamilyName,FirstName=:fFirstName,MiddleName=:fMiddleName,Country=:fCountry,'+
                    'PostalIndex=:fPostalIndex,Address=:fAddress,PassportSeries=:fPassportSeries,PassportNumber=:fPassportNumber,PhoneHome=:fPhoneHome,PhoneMobile=:fPhoneMobile,email=:femail WHERE idx=:fidx';
        ParamByName('fFamilyName').AsString 		:= PEF.FamilyNameEdit.Text;
        ParamByName('fFirstName').AsString	    := PEF.FirstNameEdit.Text;
        ParamByName('fMiddleName').AsString	    := PEF.MiddleNameEdit.Text;
        ParamByName('fCountry').AsString	      := PEF.CountryEdit.Text;
        ParamByName('fPostalIndex').AsString	  := PEF.PostalIndexEdit.Text;
        ParamByName('fAddress').AsString	      := PEF.AddressEdit.Text;
        ParamByName('fPassportSeries').AsString	:= PEF.PassportSeriesEdit.Text;
        ParamByName('fPassportNumber').AsString	:= PEF.PassportNumberEdit.Text;
        ParamByName('fPhoneHome').AsString	    := PEF.PhoneHomeEdit.Text;
        ParamByName('fPhoneMobile').AsString	  := PEF.PhoneMobileEdit.Text;
        ParamByName('femail').AsString	        := PEF.EMailEdit.Text;
        ParamByName('fidx').AsInteger            := ridx;
        try
          ExecSQL;
        except
          on e: EZSQLException do begin
            ShowError(Self, 'Ошибка при сохранении данных о читателе.', e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end;
    end;

    if NoError then begin
      try
        FPCOnnection.Commit;
      except
    	  on e: EZSQLException do begin
          ShowError(Self, 'Невозможно записать операцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
	    end;
    end;

    if not NoError then begin
      try
        FPCOnnection.Rollback;
      except
    	  on e: EZSQLException do begin
          ShowError(Self, 'Ошибка при откате операции.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
	    end;
    end; // if not NoError ...
  end;

  if NoError then begin // update strGrid with new data
    with PEF do begin
      NewFIO := GetShortFIO(PEF.FamilyNameEdit.Text, PEF.FirstNameEdit.Text, PEF.MiddleNameEdit.Text);
      if NewFIO <> StrGrid.Cells[1, CurRow] then begin
        RecFound := false;
        if StrGrid.Cells[1, CurRow] < NewFIO then begin
          for i := CurRow + 1 to StrGrid.RowCount do begin
            if NewFIO < strGrid.Cells[1, i]  then begin
              RecFound := true;
              NewRecID := i;
              break;
            end;
          end;
          if not RecFound then begin
              NewRecID := StrGrid.RowCount + 1;
          end;
        end
        else begin
          for i := 1 to CurRow do begin
            if NewFIO < strGrid.Cells[1, i]  then begin
              RecFound := true;
              NewRecID := i;
              break;
            end;
          end;
          if not RecFound then begin
              NewRecID := 1;
          end;
        end;

        if NewRecId <> CurRow then begin
          StrGrid.MoveRow(CurRow, NewRecID);
        end;
        StrGrid.Cells[1, NewRecID] := IntToStr(ridx);
        StrGrid.Cells[1, NewRecID] := NewFIO;
        StrGrid.Cells[2, NewRecID] := AddressEdit.Text;
        StrGrid.Cells[3, NewRecID] := PhoneMobileEdit.Text;
        StrGrid.Cells[4, NewRecID] := EmailEdit.Text;
        StrGrid.SelectRows(NewRecID, 1);
      end;
    end;
  end;
  PEF.Free;
end;

procedure TMainFPForm.PopUpAddEntityClick(Sender: TObject);
Var
  FEF         : TFundEditForm;
  Node        : PVirtualNode;
  NodeData    : PVTResourceData;
  NewNode     : PVirtualNode;
  NewNodeData : PVTResourceData;
  NoError     : boolean;
  Prefix      : string;
  TblName     : string;
  NewPage     : integer;
  NewSub      : integer;
  NewFundID		: integer;

  fvastr			: string;
  fp1str			: string;
  itsafund    : boolean;
  pisafolder  : boolean;
  itsafolder  : boolean;

begin

  Node := MainTree.GetFirstSelected;
  if Node = nil then
    Exit;

  NewFundID := 0;
  NodeData := MainTree.GetNodeData(Node);

  FEF := TFundEditForm.Create(nil);
  FEF.TitleEdit.Text := '';
  FEF.DescrMemo.Clear;
  FEF.IsFolderCB.Visible := false;
  FEF.IsFolderCB.Checked := false;

  itsafund := (NodeData.branch = BRANCH_FUNDS) or IsIt(FundNodesArr, Node);
	pisafolder := (NodeData.branch = BRANCH_FUNDS) and not (IsIt(FundNodesArr, Node));
  if itsafund then begin
    Prefix      := 'fond';
    FEF.Caption := 'Новый фонд';
{$IFDEF FCBF}
  	FEF.IsFolderCB.Enabled := true;
  	FEF.IsFolderCB.Visible := true;
{$ELSE}
    FEF.Height	:= 323;
{$ENDIF}
  end
  else begin
    Prefix  										 := 'bank';
    FEF.Caption 								 := 'Новый счет';
    FEF.FP1MoneyEdit.Visible		 := false;
    FEF.FP1PctEdit.Visible		   := false;
    FEF.AssetCombo.Visible			 := false;
    FEF.AssLabel.Visible         := false;
{$IFNDEF FAFH}
    FEF.Height	:= 220;
{$ENDIF}
  end;


{$IFDEF FAFH}
  FEF.isfund := itsafund;
  FEF.isFndr := PrivPresentMO(CurPrivs, 'b0');
  FEF.SetupSize;
{$ENDIF}

  Prefix := Prefix + '_';
  Prefix := NodeData.prefix + Prefix;
  FEF.OrgPRefix := NodeData.prefix;
  FEF.Prefix := Prefix;
  FEF.SetupAssetList;

//  if((NodeData.branch = BRANCH_FUNDS) or (IsIt(FundNodesArr, Node))) and (FEF.GetAssListCount = 0) then begin
  if itsafund and (FEF.GetAssListCount = 0) then begin
    MessageBox(0, 'Прежде чем создать фонд следует создать актив, к которому можно будет привязать фонд', 'Невозможно создать фонд', MB_Ok or MB_ICONWARNING);
    FEF.Free;
    Exit;
  end;

  if pisafolder then begin
{$IFDEF FAFH}
    FEF.FndrCheckBox.Checked := NodeData.fnd;
    FEF.FndrCheckBox.Enabled := false;
{$ENDIF}
		FEF.SetupAsset(NodeData.alink);
//    FEF.AssetCombo.Text := NodeData.alink;
  end;

  repeat
    NoError   := true;

    if FEF.ShowModal <> mrOk then break;

		itsafolder := FEF.IsFolderCB.Checked;

   	// start transaction
		FPMainDataset.SQL.Text := 'START TRANSACTION';
    try
    	FPMainDataset.ExecSQL;
    except
 			on e: EZSQLException do begin
	  		ShowError(Self, 'Невозможно начать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
	    end;
    end;

		if NoError then begin
    	TblName := Prefix + TranslitIt(FEF.TitleEdit.Text);

 	    // creating table itself
   	  FPMainDataset.SQL.Text := 'CREATE TABLE`'+ TblName + '`(`index` int NOT NULL AUTO_INCREMENT,' +
     	                          '`name`TEXT NULL,`page`int(8)NOT NULL default "0",' +
       	                        '`link`TEXT NULL,`sub`tinyint(1)NOT NULL default "0",' +
         	                      '`balance`decimal(22,2)default "0",' +
           	                    '`lastdate`timestamp NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,' +
                                '`UserID` INT NOT NULL DEFAULT "0",' +
             	                  '`data`TEXT NOT NULL,`in`decimal(20,2)default NULL,' +
               	                '`out`decimal(20,2)default NULL,' +
                                '`arched`TINYINT NOT NULL DEFAULT"0",' +
                                '`fnd`TINYINT NOT NULL DEFAULT"0",' +
                                'INDEX ( UserID ),' +
                                'PRIMARY KEY(`index`))ENGINE=InnoDB';
      try
 	      FPMainDataset.ExecSQL;
   	  except
  		  on e: EZSQLException do begin
       	  if Pos('already exists', e.Message) > 0 then
         	  Application.MessageBox('Такое название уже существует.', 'Ошибка создания базы', MB_OK or MB_ICONERROR)
          else
			  	  ShowError(Self, 'Ошибка инициализации таблицы.', e.ErrorCode, e.StatusCode, e.Message + ' @ _' + FEF.TitleEdit.Text + '_');
   	      NoError := false;
	  		end;
    	end;
    end; // if NoError

    if NoError then begin
	  	// Adding basic info to just created table
  	  FPMainDataset.SQL.Text := 'INSERT INTO '+ TblName + '(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES(NULL,:fParName,:fParPage,:fParLink,0,0,NULL,:fDescr,NULL,NULL)';
    	FPMainDataset.ParamByName('fParName').AsString  := '<<' + NodeData.name;
      FPMainDataset.ParamByName('fParPage').AsInteger := NodeData.page;
	    FPMainDataset.ParamByName('fParLink').AsString  := NodeData.link;
  	  FPMainDataset.ParamByName('fDescr').AsString    := FEF.DescrMemo.Text;

    	try
      	FPMainDataset.ExecSQL;
      except
	  		on e: EZSQLException do begin
			  	ShowError(Self, 'Ошибка инициализации таблицы.', e.ErrorCode, e.StatusCode, e.Message + ' @ ' + NodeData.name);
    	    NoError := false;
        end;
      end;
    end; // if NoError

    if NoError then begin
	  	// updating parent table
{$IFDEF FAFH}
  	  FPMainDataset.SQL.Text := 'INSERT INTO ' + NodeData.link + '(`index`,`name`,`page`,`link`,`sub`,`lastdate`,`fnd`)VALUES(NULL,:dtitle,:dtype,:fTblName,:dkind,NOW(),:ffnd)';
      FPMainDataset.ParamByName('ffnd').AsInteger := integer(FEF.isObjFnd);
{$ELSE}
  	  FPMainDataset.SQL.Text := 'INSERT INTO ' + NodeData.link + '(`index`,`name`,`page`,`link`,`sub`,`lastdate`)VALUES(NULL,:dtitle,:dtype,:fTblName,:dkind,NOW())';
{$ENDIF}
      FPMainDataset.ParamByName('dtitle').AsString    := FEF.TitleEdit.Text;
 	    FPMainDataset.ParamByName('fTblName').AsString  := TblName;
   	  if itsafolder then begin
     	  FPMainDataset.ParamByName('dtype').AsInteger := 8;
       	FPMainDataset.ParamByName('dkind').AsInteger := 1;
        NewPage     :=  8;
 	      NewSub      :=  1;
   	  end
      else begin
 	      FPMainDataset.ParamByName('dtype').AsInteger := 9;
   	    FPMainDataset.ParamByName('dkind').AsInteger := 0;
     	  NewPage     :=  9;
       	NewSub      :=  0;
      end;

   	  try
     	  FPMainDataset.ExecSQL;
      except
  		  on e: EZSQLException do begin
		  	  ShowError(Self, 'Ошибка базы данных.', e.ErrorCode, e.StatusCode, e.Message + ' @ ' + NodeData.link);
   	      NoError := false;
	  	  end;
 	    end;
    end; // if NoError

		if NoError then begin
 	  	// Getting last ID
		  FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
    	try                     // saving filename only - the file will be saved later
		  	FPMainDataset.Open;
	      if not FPMainDataset.Eof then
		    	NewFundID := FPMainDataset.FieldByName('ID').AsInteger;
      except
  			on e: EZSQLException do begin
		  		ShowError(Self, 'Произошла ошибка при получении индекса.', e.ErrorCode, e.StatusCode, e.Message + ' @ SELECT_LAST_ID');
	        NoError := false;
        end;
      end;
    end; //

		if NoError then begin
	  	// Adding info about Fund<->Asset relation
//  	  if(FEF.AssetCombo.ItemIndex >= 0) then begin
  	  if itsafund and not itsafolder then begin  // we need it only if it's a fund, not a folder
      	fvastr := NodeData.prefix + 'fundsvsassets';
	  		FPMainDataset.SQL.Text := 'INSERT INTO ' + fvastr + '(`fundlink`,`assetlink`)VALUES(:fFundLink,:fAssetLink)';
  	  	FPMainDataset.ParamByName('fFundLink').AsString		:= TblName;
      	FPMainDataset.ParamByName('fAssetLink').AsString	:= PVTResourceData(FEF.AssetCombo.Items.Objects[FEF.AssetCombo.ItemIndex]).link;

	  	  try
  	  		FPMainDataset.ExecSQL;
        except
  				on e: EZSQLException do begin
		  			ShowError(Self, 'Произошла ошибка обновления связи актива и фонда. Пожалуйста, обратитесь к разработчикам.', e.ErrorCode, e.StatusCode, e.Message);
	        	NoError := false;
          end;
        end;
      end;
    end; // if NoError

    if NoError then begin
	  	// Adding info about FP1 amount
//  	  if ((itsafund) or (IsIt(FundNodesArr, Node))) and (not itsafolder) and (FEF.FP1MoneyEdit.Value > 0) and (NewFundID > 0) then begin
  	  if itsafund and (not itsafolder) and (FEF.FP1MoneyEdit.Value > 0) and (NewFundID > 0) then begin

	     	fp1str := 'fp1funddata';
      	fp1str := NodeData.prefix + fp1str;

	  		FPMainDataset.SQL.Text := 'INSERT INTO ' + fp1str + '(fid,amount,pct)VALUES(:ffid,:famount,:fpct)';
  	  	FPMainDataset.ParamByName('ffid').AsInteger	 := NewFundID;
      	FPMainDataset.ParamByName('famount').AsFloat := FEF.FP1MoneyEdit.Value;
      	FPMainDataset.ParamByName('fpct').AsFloat    := FEF.FP1PctEdit.Value;

	  	  try
  	  		FPMainDataset.ExecSQL;
        except
  				on e: EZSQLException do begin
		  			ShowError(Self, 'Ошибка обновления данных.', e.ErrorCode, e.StatusCode, e.Message);
	        	NoError := false;
          end;
        end;
      end;
    end; // if NoError

    if NoError then begin
  		FPMainDataset.SQL.Text := 'COMMIT';
  	  try
 	  		FPMainDataset.ExecSQL;
      except
 				on e: EZSQLException do begin
	  			ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
        end;
      end;
    end // if NoError
    else begin
  		FPMainDataset.SQL.Text := 'ROLLBACK';
  	  try
 	  		FPMainDataset.ExecSQL;
      except
 				on e: EZSQLException do begin
	  			ShowError(Self, 'Невозможно откатить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
        end;
      end;
    end; // else for if NoError

    if NoError then begin

	  	NewNode			:= MainTree.AddChild(Node);
  	  NewNodeData := MainTree.GetNodeData(NewNode);

    	NewNodeData.name  	:= FEF.TitleEdit.Text;
      NewNodeData.link  	:= TblName;
	    NewNodeData.descr  	:= FEF.DescrMemo.Text;
  	  NewNodeData.page  	:= NewPage;
    	NewNodeData.sub   	:= NewSub;
      NewNodeData.index		:= NewFundID;
      NewNodeData.prefix	:= NodeData.prefix;
{$IFDEF FAFH}
// 100! - обработать
//      NewNodeData.fnd     := FEF.FndrCheckBox.Checked;
{$ENDIF}

	    if (NodeData.branch = BRANCH_FUNDS) or (IsIt(FundNodesArr, Node)) then begin
  			NewNodeData.branch  := 	BRANCH_FUNDS;
      end
      else begin
	    	NewNodeData.branch  := 	NodeData.branch;
      end;

//  	  if (FEF.AssetCombo.ItemIndex >= 0) and (FEF.AssetCombo.Enabled) and (FEF.AssetCombo.Visible) then
  	  if (itsafund) and (FEF.AssetCombo.ItemIndex >= 0) and (FEF.AssetCombo.Visible) then
	  		NewNodeData.alink		:=	PVTResourceData(FEF.AssetCombo.Items.Objects[FEF.AssetCombo.ItemIndex]).link;
{$IFDEF FCBF}
  	  if (itsafund) then begin
        NewNodeData.fldr := itsafolder;
      	if (not itsafolder) and (FEF.AssetCombo.ItemIndex >= 0) and (FEF.AssetCombo.Visible) then begin
		  		NewNodeData.alink		:=	PVTResourceData(FEF.AssetCombo.Items.Objects[FEF.AssetCombo.ItemIndex]).link;
        end
      end;
{$ELSE}
  	  if (itsafund) and (FEF.AssetCombo.ItemIndex >= 0) and (FEF.AssetCombo.Visible) then
	  		NewNodeData.alink		:=	PVTResourceData(FEF.AssetCombo.Items.Objects[FEF.AssetCombo.ItemIndex]).link;
{$ENDIF}

			CollapseExpandNode(NewNode, NewNodeData);

		end; // if NoError
  until NoError;
	FEF.Free;
end;

procedure TMainFPForm.PopUpDeleteClick(Sender: TObject);
var
  Node					: PVirtualNode;
  PrntNode			: PVirtualNode;
  NodeData			: PVTResourceData;
  PrntNodeData	: PVTResourceData;
  NoError				: boolean;
  i							: integer;
  ind						: integer;
  fvastr        : string;
  fp1fstr       : string;
begin
//
  Node			:= MainTree.GetFirstSelected;
  if Node = nil then
  	Exit;

  PrntNode	:= Node.Parent;
  if PrntNode = nil then
  	Exit;

  NodeData			:= MainTree.GetNodeData(Node);
  // if we have to delete FP
  if (NodeData.branch = BRANCH_FP) and (NodeData.sub = FPNOTAPPROVED) then begin
	  if mrYes <> Application.MessageBox('Вы действительно хотите удалить это ФП?', 'Подтвердите удаление', MB_YESNO or MB_ICONWARNING) then
  	  Exit;

		ind := NodeData.index;

    FPMainDataset.SQL.Text := 'UPDATE ' + NodeData.prefix + 'fp SET `to`=NULL,`plan`=NULL WHERE `index`=:fIndex';
    FPMainDataset.ParamByName('fIndex').AsInteger := ind;

    try
    	FPMainDataset.ExecSQL;
    except
    	on e: EZSQLException do begin
		    ShowError(Self, 'Не удалось удалить ФП.', e.ErrorCode, e.StatusCode, e.Message);
	      Exit;
  	  end;
    end;

    FPMainDataset.SQL.Text := 'COMMIT';
    try
    	FPMainDataset.ExecSQL;
    except
    	on e: EZSQLException do begin
		    ShowError(Self, 'Не удалось завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
	      Exit;
  	  end;
    end;

	  NodeData.sub		:= FPNEWFPTOCREATE;
  	NodeData.name		:= 'Создать новое ФП';
    NodeData.page		:= BRANCH_FP;
	  NodeData.branch	:= BRANCH_FP;
  	NodeData.index	:= 0;

		MainTree.ClearSelection;
    MainTree.Selected[Node] := true;
    MainTree.RepaintNode(Node);

  	Exit;
  end;

  NoError 			:= true;
  // deleting other stuff
  if mrYes <> Application.MessageBox('Вы действительно хотите удалить этот объект?', 'Подтвердите удаление', MB_YESNO or MB_ICONWARNING) then
    Exit;

  PrntNodeData	:= MainTree.GetNodeData(PrntNode);

 	// start transaction
	FPMainDataset.SQL.Text := 'START TRANSACTION';
	try
		FPMainDataset.ExecSQL;
	except
 		on e: EZSQLException do begin
	  	ShowError(Self, 'Невозможно начать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
      NoError := false;
    end;
  end;

  if NoError then begin
	  // dropping table itself
  	FPMainDataset.SQL.Text := 'DROP TABLE ' + NodeData.link;
	  try
  		FPMainDataset.ExecSQL;
	  except
  		on E: EZSQLException do begin
		    ShowError(Self, 'Ошибка при удалении объекта.', e.ErrorCode, e.StatusCode, e.Message);
	      NoError := false;
  	  end;
	  end;
  end; // if NoError then

  if NoError then begin
	  // dropping fund-asset relation
    fvastr  := 'fundsvsassets';
    fp1fstr := 'fp1funddata';
    fvastr  := NodeData.prefix + fvastr;
    fp1fstr := NodeData.prefix + fp1fstr;
//    FPMainDataset.SQL.Text := 'DELETE FROM fundsvsassets WHERE fundlink=:fFndLink';
    FPMainDataset.SQL.Text := 'DELETE FROM ' + fvastr + ' WHERE fundlink=:fFndLink';
    FPMainDataset.ParamByName('fFndLink').AsString := NodeData.link;
	  try
  		FPMainDataset.ExecSQL;
	  except
  		on E: EZSQLException do begin
		    ShowError(Self, 'Ошибка при удалении ссылок на фонд.', e.ErrorCode, e.StatusCode, e.Message);
	      NoError := false;
  	  end;
	  end;
  end;

  if NoError then begin
	  // dropping asset from parent (if exists)
    FPMainDataset.SQL.Text := 'DELETE FROM ' + PrntNodeData.link + ' WHERE link=:fFndLink';
    FPMainDataset.ParamByName('fFndLink').AsString := NodeData.link;
	  try
  		FPMainDataset.ExecSQL;
	  except
  		on E: EZSQLException do begin
		    ShowError(Self, 'Ошибка обновления информации после удаления фонда.', e.ErrorCode, e.StatusCode, e.Message);
	      NoError := false;
  	  end;
	  end;
  end;

  if NoError then begin
	  // dropping asset from parent (if exists)
//    FPMainDataset.SQL.Text := 'DELETE FROM fp1funddata WHERE fid=:ffid';
    FPMainDataset.SQL.Text := 'DELETE FROM ' + fp1fstr + ' WHERE fid=:ffid';
    FPMainDataset.ParamByName('ffid').AsInteger := NodeData.index;
	  try
  		FPMainDataset.ExecSQL;
	  except
  		on E: EZSQLException do begin
		    ShowError(Self, 'Ошибка обновления информации по ФП №1 после удаления фонда.', e.ErrorCode, e.StatusCode, e.Message);
	      NoError := false;
  	  end;
	  end;
  end;

	// closing transaction
	if NoError then begin
		FPMainDataset.SQL.Text := 'COMMIT';
  	try
 	  	FPMainDataset.ExecSQL;
    except
 			on e: EZSQLException do begin
	  		ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;
  end; // if NoError

  if not NoError then begin
  	FPMainDataset.SQL.Text := 'ROLLBACK';
  	try
 	  	FPMainDataset.ExecSQL;
    except
 			on e: EZSQLException do begin
	  		ShowError(Self, 'Невозможно октатить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
      end;
    end;
  end; // else for if NoError

  if NoError then begin
		MainTree.ClearSelection;
    MainTree.Selected[PrntNode] := true;
    MainTree.DeleteNode(Node);
  end;

end;

procedure TMainFPForm.PopUpEnterBalanceClick(Sender: TObject);
var
  BEF       : TBalanceEnterForm;
  SNode     : PVirtualNode;
  Node      : PVirtualNode;
  NodeData  : PVTResourceData;
  Val       : extended;
  BalVal    : extended;
  Node1     : PVirtualNode;
  Node1Data : PVTResourceData;
  NoError   : boolean;
  PUPPref  : string;
begin
  Node := MainTree.GetFirstSelected;
  if Node = nil then
    Exit;

  NodeData := MainTree.GetNodeData(Node);

  BEF := TBalanceEnterForm.Create(nil);
  BEF.Caption := 'Внесение остатков';
  BEF.MoneyEdit.Text := '';

  if (BEF.ShowModal = mrOk) then begin
    Val := BEF.MoneyEdit.Value;
    NoError   := true;
    PUPPref := NodeData.prefix;

    FPMainDataset.SQL.Text := 'BEGIN';
    try
      FPMainDataset.ExecSQL;
    except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'Невозможно начать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
	    end;
    end;

    if NoError then begin
      if (NodeData.link = PUPPref + CASH_LINK) or (NodeData.link = PUPPref + BILL1_LINK) then begin
    		FPMainDataset.SQL.Text  := 'INSERT INTO`'+ NodeData.link+ '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`amount`,`price`,`data`,`in`,`out`,`incsrcid`,`pct`';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',UserID';
{$ENDIF}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
  	  	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,"rest",0,:f1,NOW(),0,0,"Первоначальные остатки",:f1,NULL,0,0';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
				FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      end
      else begin
        FPMainDataset.SQL.Text := 'INSERT INTO`' + NodeData.link + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',UserID';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')VALUES(NULL,NULL,0,"rest",0,:f1,NOW(),"Первоначальные остатки",:f1,NULL';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
				FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      end;
      FPMainDataset.ParamByName('f1').AsFloat := Val;
{$IFDEF USERID}
	      FPMainDataset.ParamByName('fUserID').AsInteger := FPUserID;
{$ENDIF}
      NodeData.balance := Val;

//    MainTree.RepaintNode(Node);
      try
        FPMainDataset.ExecSQL;
      except
    	  on e: EZSQLException do begin
		      ShowError(Self, 'При сохранении начальных остатков произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
  	    end;
      end;

      try
      // Add this value to the proper asset
      if not ((NodeData.link = PUPPref + CASH_LINK) or (NodeData.link = PUPPref + BILL1_LINK)) and (NodeData.branch = BRANCH_FUNDS) then begin
        // pull the balance from the proper asset
        FPMainDataset.SQL.Text  := 'SELECT`balance`FROM`'+ NodeData.alink + '`ORDER BY`index`DESC LIMIT 1';
        FPMainDataset.Open;
        BalVal := FPMainDataset.FieldByName('balance').AsFloat;


    		FPMainDataset.SQL.Text  := 'INSERT INTO`'+ NodeData.alink + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',UserID';
{$ENDIF}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,"rest",0,:fbal,NOW(),:fexp,:fval,0';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';

        FPMainDataset.ParamByName('fexp').AsString := 'Внесение первоначальных остатков в фонд "' + NodeData.name + '"';
        FPMainDataset.ParamByName('fbal').AsFloat := Val + BalVal;
        FPMainDataset.ParamByName('fval').AsFloat := Val;
{$IFDEF USERID}
	      FPMainDataset.ParamByName('fUserID').AsInteger := FPUserID;
{$ENDIF}
        FPMainDataset.ExecSQL;
        fond_update(NodeData.alink, Val + BalVal);

      end;
      except
    	  on e: EZSQLException do begin
		      ShowError(Self, 'При сохранении начальных остатков произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
  	    end;
      end;



    end;

    if NoError then  begin
      fond_update(NodeData.link, Val);
      SNode := Node;
      Repeat
        Node := Node.Parent;
        if Node <> nil then begin
          NodeData := MainTree.GetNodeData(Node);
          Node1 := Node.Parent;
          Node1Data := MainTree.GetNodeData(Node1);
          if Node1Data.link = 'root' then begin
            FPMainDataset.SQL.Text := 'SELECT SUM(balance) AS balance FROM ' + NodeData.link;
          end
          else begin
            FPMainDataset.SQL.Text := 'SELECT balance FROM ' + Node1Data.link + ' WHERE link=:fLink';
            FPMainDataset.ParamByName('fLink').AsString := NodeData.link;
          end;
          try
            FPMainDataset.Open;
            if FPMainDataset.RecordCount > 0 then begin
              NodeData.balance := FPMainDataset.FieldByName('balance').AsFloat;
              MainTree.RepaintNode(Node);
            end;
          except
        	  on e: EZSQLException do begin
		          ShowError(Self, 'Невозможно получить данные.', e.ErrorCode, e.StatusCode, e.Message);
              NoError := false;
	          end;
          end;
          if not NoError then
            break
        end;
      Until (Node = nil) or (Node1 = nil) or (IsIt(RNodesArr, Node1));
    end;

    if NoError then begin
      FPMainDataset.SQL.Text := 'COMMIT';
      try
        FPMainDataset.ExecSQL;
      except
  	    on e: EZSQLException do begin
		      ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
  	    end;
      end;
    end;

    if not NoError then begin
      FPMainDataset.SQL.Text := 'ROLLBACK';
      try
        FPMainDataset.ExecSQL;
      finally

      end;
    end;

    if MainTree.HasAsParent(SNode, CurNode) then
      PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
  end;
end;

procedure TMainFPForm.PopUpItemPropShowClick(Sender: TObject);
var
  FEF       : TFundEditForm;
  Node      : PVirtualNode;
  NodeData  : PVTResourceData;
  TNode      : PVirtualNode;
  TNodeData  : PVTResourceData;
  PrntNode  : PVirtualNode;
  PrntNodeData  : PVTResourceData;
  OldSub    : integer;
  OldTitle  : string;
  OldDescr  : string;
  OldAsset	: string;
  i					: integer;
  OldFP1Amount : extended;
  OldFP1Pct    : extended;
  NoError		: boolean;
  PopUpPrefix : string;
  Bal         : extended;

  itsafund    : boolean;
  wstr        : string;
  cstr        : string;
{$IFDEF FCBF}
  acbc				: boolean;   // asset can be changed
  itsafolder  : boolean;
{$ENDIF}

begin
  Node := MainTree.GetFirstSelected;
  if Node = nil then
    Exit;
  NodeData := MainTree.GetNodeData(Node);
  FEF      := TFundEditForm.Create(nil);

  FEF.OrgPrefix := NodeData.prefix;
  PopUpPrefix   := NodeData.prefix;

  PrntNode := Node.Parent;
  PrntNodeData  := MainTree.GetNodeData(PrntNode);

  itsafund := NodeData.branch = BRANCH_FUNDS;

{$IFDEF FCBF}
//	if itsafund then begin
//	acbc := (NodeData.branch = BRANCH_FUNDS) and IsIt(FundNodesArr, PrntNode);
	itsafolder := boolean(NodeData.sub);
 	FEF.IsFolderCB.Checked := itsafolder;
  FEF.IsFolderCB.Enabled := false;
  FEF.IsFolderCB.Visible := true;

	acbc := (NodeData.branch = BRANCH_FUNDS) and (not itsafolder);
//  end;
//  FEF.AssetCombo.Enabled := (not itsafund) or (itsafund and acbc);
  FEF.AssetCombo.Enabled := itsafund and acbc;
  if itsafolder then begin
  	FEF.AssetCombo.ItemIndex := -1;
//    FEF.Caption := FEF.Caption + ' (папка)';
  end;
{$ENDIF}

(*
// 100! - обработать
{$IFNDEF FAFH}
	FEF.FndrCheckBox.Visible := false;
{$ELSE}
  if not PrivPresentMO(CurPrivs, 'b0') then
    FEF.FndrCheckBox.Visible := false;
{$ENDIF}
*)

  if itsafund then begin
    FEF.Caption := 'Свойства фонда';
{$IFDEF FCBF}
  	FEF.IsFolderCB.Enabled := true;
  	FEF.IsFolderCB.Visible := true;
//{ELSE}
//    FEF.Height	:= 323;
{$ENDIF}
  end
  else begin
    FEF.Caption := 'Свойства счета';
//    FEF.Height	:= 240;
    FEF.AssetCombo.Enabled	:= false;
    FEF.AssetCombo.Visible	:= false;
    FEF.AssLabel.Visible    := false;
    FEF.FP1MoneyEdit.Visible:= false;
    FEF.FP1MoneyLabel.Visible := false;
    FEF.FP1PctEdit.Visible  := false;
    FEF.FP1PctLabel.Visible := false;
{$IFNDEF FAFH}
    FEF.Height	:= 220;
{$ENDIF}

  end;

{$IFDEF FAFH}
  FEF.isfund := itsafund;
//  FEF.isFndr := PrivPresentMO(CurPrivs, 'b0');
  FEF.isFndr := PrivPresentMO(CurPrivs, 'b0') and  not ((NodeData.link = FEF.OrgPrefix + BILL1_LINK) or (NodeData.link = FEF.OrgPrefix + CASH_LINK) or (NodeData.link = FEF.OrgPrefix + DISBCASH_LINK));
  FEF.SetupSize;
{$ENDIF}

  OldSub 		:= NodeData.page;
  OldTitle 	:= NodeData.name;
//  OldDescr 	:= NodeData.descr;
  OldAsset	:= NodeData.alink;

  FEF.TitleEdit.Text := NodeData.name;
//  FEF.DescrMemo.Text := '';
// pulling description of the object
 	NoError := true;
  FPMainDataset.SQL.Text := 'SELECT`data`FROM`' + NodeData.link + '`WHERE`index`=1';
  try
    FPMainDataset.Open;
    NodeData.descr 	   := FPMainDataset.FieldByName('data').AsString;
    OldDescr           := NodeData.descr;
    FEF.DescrMemo.Text := NodeData.descr;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, 'Невозможно получить данные об объекте.', e.ErrorCode, e.StatusCode, e.Message);
      NoError := false;
    end;
  end;

  FEF.IsFolderCB.Checked  := OldSub = 8;        // 8 - it's a folder
  if not FundOrAssetIsEmpty(NodeData.link) then begin // we can change only description
    FEF.TitleEdit.Enabled := false;
    FEF.IsFolderCB.Enabled  := false;
  end;

{$IFDEF FAFH}
  if FEF.FndrCheckBox.Visible then
    FEF.FndrCheckBox.Checked := NodeData.fnd;
{$ENDIF}

  FEF.SetupAssetList;

  if not itsafund then begin   // not fund, i.e., it's an asset
    FEF.IsFolderCB.Visible := false
  end
  else begin // setting up proper asset
    for i := 0 to FEF.AssetCombo.Items.Count - 1 do begin
      if NodeData.alink = PVTResourceData(FEF.AssetCombo.Items.Objects[i]).link then begin
        FEF.AssetCombo.ItemIndex := i;
        break;
      end;
    end;

      // pulling FP1 fund data
    FPMainDataset.SQL.Text := 'SELECT amount,pct FROM ' + PopUpPrefix + 'fp1funddata WHERE fid=:ffid ORDER BY since DESC LIMIT 1';
 	  FPMainDataset.ParamByName('ffid').AsInteger	 := NodeData.index;
    try
      FPMainDataset.Open;
      if not FPMainDataset.Eof then begin
	  	  OldFP1Amount := FPMainDataset.FieldByName('amount').AsFloat;
        OldFP1Pct    := FPMainDataset.FieldByName('pct').AsFloat;

        FEF.FP1MoneyEdit.Value := OldFP1Amount;
        FEF.FP1PctEdit.Value   := OldFP1Pct;
      end;
    except
 	    on e: EZSQLException do begin
        ShowError(Self, 'Невозможно получить данные об объекте.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;
  end;

  if (NodeData.branch = BRANCH_FUNDS) and (NodeData.arched) then begin
    FEF.OkButton.Visible     := false;
    FEF.DescrMemo.Enabled    := false;
    FEF.FP1MoneyEdit.Enabled := false;
    FEF.FP1PctEdit.Enabled	 := false;
    FEF.AssetCombo.Enabled   := false;
    FEF.CancelButton.Caption := 'Закрыть';
    FEF.Caption							 := FEF.Caption + ' (архив)';
  end;

  if NoError and (FEF.ShowModal = mrOK) then begin
{$IFDEF FAFH}
  // if "fnd" flag has been changed we need the confirmation that it was done intentionally
//  if FEF.FndrCheckBox.Visible and (FEF.FndrCheckBox.Checked <> NodeData.fnd) or (FEF.isObjFnd <> NodeData.fnd) then begin
  if (FEF.isObjFnd <> NodeData.fnd) then begin
    cstr := 'Изменена область видимости';
    if NodeData.branch = BRANCH_FUNDS then begin
      wstr := 'Вы изменили настройки фонда. После внесения изменеий он будет виден ';
      if FEF.isObjFnd then begin // it was a fnd fund, but now it's not
        wstr := wstr + 'ТОЛЬКО УЧРЕДИТЕЛЮ и тем, кто имеет право работать с фондами учредителя.';
      end
      else begin
        wstr := wstr + 'ВСЕМ СОТРУДНИКАМ, которые имеют право работать с фондами, а не только учредитель.';
      end;
      cstr := cstr + ' фонда';
    end // if NodeData.branch = BRANCH_FUNDS
    else begin
      wstr := 'Вы изменили настройки счета. После внесения изменеий счет и все привязанные к нему фонды будут видны ';
      if FEF.isObjFnd then begin // it was a fnd fund, but now it's not
        wstr := wstr + 'ТОЛЬКО УЧРЕДИТЕЛЮ и тем, кто имеет право работать со счетами учредителя.';
      end
      else begin
        wstr := wstr + 'ВСЕМ СОТРУДНИКАМ, которые имеют право работать со счетами, а не только учредитель.';
      end;
      cstr := cstr + ' счета';
    end;
    wstr := wstr + ' Продолжить?';
    if not (Application.MessageBox(PWideChar(wstr), PWideChar(cstr), MB_ICONWARNING or MB_YESNO) = mrYes) then Exit;
  end;
{$ENDIF}

    // Starting transaction
		FPMainDataset.SQL.Text := 'START TRANSACTION';
    try
    	FPMainDataset.ExecSQL;
    except
 			on e: EZSQLException do begin
	  		ShowError(Self, 'Невозможно инициализировать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
	    end;
    end;

    if NoError then begin
//	    if not FEF.IsFolderCheckBox.Visible then begin // i.e. it's a bank
//	    if not FEF.ToAssetCB.Visible then begin // i.e. it's a bank
	    if not itsafund then begin // i.e. it's a bank
  	    if (OldTitle <> FEF.TitleEdit.Text)
{$IFDEF FAFH}
          or (FEF.FndrCheckBox.Visible and (FEF.FndrCheckBox.Checked <> NodeData.fnd))
{$ENDIF}
        then begin
    	    FPMainDataset.SQL.Text := 'UPDATE`' + PrntNodeData.link + '`SET`name`=:fName';
{$IFDEF FAFH}
          if FEF.FndrCheckBox.Visible and (FEF.FndrCheckBox.Checked <> NodeData.fnd) then begin
            FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`fnd`=:ffnd';
          end;
{$ENDIF}
    	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text  + ' WHERE`link`="' + NodeData.link + '"';
      	  FPMainDataset.ParamByName('fName').AsString := FEF.TitleEdit.Text;
{$IFDEF FAFH}
          if FEF.FndrCheckBox.Visible and (FEF.FndrCheckBox.Checked <> NodeData.fnd) then begin
            FPMainDataset.ParamByName('ffnd').AsInteger := integer(FEF.FndrCheckBox.Checked);
          end;
{$ENDIF}
//          FPMainDataset.ParamByName('flink').AsString := NodeData.link;

	  	  	try
  	  	  	FPMainDataset.ExecSQL;
		      except
	  				on e: EZSQLException do begin
			  			ShowError(Self, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
		    	    NoError := false;
    		    end;
		      end;

          if NoError then begin
		        NodeData.name := FEF.TitleEdit.Text;
{$IFDEF FAFH}
          if FEF.FndrCheckBox.Visible and (FEF.FndrCheckBox.Checked <> NodeData.fnd) then begin
		        NodeData.fnd := FEF.FndrCheckBox.Checked;
          end;
{$ENDIF}
  		      //MainTree.RepaintNode(Node);
          end;
    	  end;
      	if NoError and (OldDescr <> FEF.DescrMemo.Text) then begin
	        FPMainDataset.SQL.Text := 'UPDATE`' + NodeData.link + '`SET`data`=:fDescr WHERE`index`=1';
  	      FPMainDataset.ParamByName('fDescr').AsString := FEF.DescrMemo.Text;

	  	  	try
  	  	  	FPMainDataset.ExecSQL;
		      except
	  				on e: EZSQLException do begin
			  			ShowError(Self, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
		    	    NoError := false;
    		    end;
		      end;

          if NoError then begin
	      	  NodeData.descr := FEF.DescrMemo.Text;
          end;
	      end; // if NoError and (OldDescr <> FEF.DescrMemo.Text)
{$IFDEF FAFH}
		    // here comes the update of the funds
//      	if NoError and FEF.FndrCheckBox.Visible and (FEF.FndrCheckBox.Checked <> NodeData.fnd) then begin
      	if NoError and (FEF.isObjFnd <> NodeData.fnd) then begin
          FPMainDataset.SQL.Text := 'UPDATE`'+ CurPrefix +'fond`SET fnd=:ffnd WHERE link IN(SELECT fundlink FROM`'+ CurPrefix +'fundsvsassets`WHERE assetlink=:fAsset)';
  	      FPMainDataset.ParamByName('ffnd').AsInteger  := integer(FEF.FndrCheckBox.Checked);
  	      FPMainDataset.ParamByName('fAsset').AsString := NodeData.link;

	  	  	try
  	  	  	FPMainDataset.ExecSQL;
		      except
	  				on e: EZSQLException do begin
			  			ShowError(Self, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
		    	    NoError := false;
    		    end;
		      end;

          if NoError then begin
		        NodeData.fnd := FEF.FndrCheckBox.Checked;
            // run through the tree and change the fnd flag for proper funds.
            TNode := FundNodesArr[CurOInd];
            if TNode <> nil then begin
              TNode := TNode.FirstChild;
              while TNode <> nil do begin
                TNodeData := MainTree.GetNodeData(TNode);
                if TNodeData.alink = NodeData.link then begin
                  TNodeData.fnd := NodeData.fnd;
                end;
                TNode := TNode.NextSibling;
              end;
            end;
          end;
	      end; // if NoError and FEF.FndrCheckBox.Visible and (OldDescr <> FEF.DescrMemo.Text)
{$ENDIF}
  	  end
	    else begin //if it's a fund
  	    if (OldTitle <> FEF.TitleEdit.Text) {$IFDEF FAFH} or (FEF.isObjFnd <> NodeData.fnd) {$ENDIF} then begin
    	    FPMainDataset.SQL.Text := 'UPDATE`' + PrntNodeData.link + '`SET`name`=:fName';
{$IFDEF FAFH}
          if (FEF.isObjFnd <> NodeData.fnd) then begin
            FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`fnd`=:ffnd';
          end;
{$ENDIF}
    	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text  + ' WHERE`link`="' + NodeData.link + '"';
      	  FPMainDataset.ParamByName('fName').AsString := FEF.TitleEdit.Text;
{$IFDEF FAFH}
          if (FEF.isObjFnd <> NodeData.fnd) then begin
            FPMainDataset.ParamByName('ffnd').AsInteger := integer(FEF.isObjFnd);
          end;
{$ENDIF}

//    	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' WHERE`link`="' + NodeData.link +'"';


	  	  	try
  	  	  	FPMainDataset.ExecSQL;
		      except
	  				on e: EZSQLException do begin
			  			ShowError(Self, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
		    	    NoError := false;
    		    end;
		      end;

          if NoError then begin
		        NodeData.name := FEF.TitleEdit.Text;
{$IFDEF FAFH}
            NodeData.fnd  := FEF.isObjFnd;
{$ENDIF}
  		      MainTree.RepaintNode(Node);
          end;
    	  end;

	      if NoError and (OldSub <> (9 - integer(FEF.IsFolderCB.Checked))) then begin
  	      FPMainDataset.SQL.Text := 'UPDATE ' + PrntNodeData.link + ' SET `page`=:fPage,`sub`=:fLink WHERE `link`="' + NodeData.link +'"';
    	    FPMainDataset.ParamByName('fPage').AsInteger    := 9 - integer(FEF.IsFolderCB.Checked);
      	  FPMainDataset.ParamByName('fLink').AsInteger    := integer(FEF.IsFolderCB.Checked);

	  	  	try
  	  	  	FPMainDataset.ExecSQL;
		      except
	  				on e: EZSQLException do begin
			  			ShowError(Self, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
		    	    NoError := false;
    		    end;
		      end;

          if NoError then begin
		        NodeData.page := 9 - integer(FEF.IsFolderCB.Checked);
  		      MainTree.RepaintNode(Node);
          end;
	      end; // if NoError and (OldSub <> (9 - integer(FEF.IsFolderCheckBox.Checked))) then begin

  	    if NoError and (OldDescr <> FEF.DescrMemo.Text) then begin
    	    FPMainDataset.SQL.Text := 'UPDATE ' + NodeData.link + ' SET `data`=:fDescr WHERE `index`=1';
      	  FPMainDataset.ParamByName('fDescr').AsString    := FEF.DescrMemo.Text;

	  	  	try
  	  	  	FPMainDataset.ExecSQL;
		      except
	  				on e: EZSQLException do begin
			  			ShowError(Self, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
		    	    NoError := false;
    		    end;
		      end;

          if NoError then begin
		        NodeData.descr := FEF.DescrMemo.Text;
          end;
  	    end; // if NoError and (OldDescr <> FEF.DescrMemo.Text)
                          (* 100 *)
        if NoError then begin
    	  	if itsafund then begin
	      		if OldAsset <> PVTResourceData(FEF.AssetCombo.Items.Objects[FEF.AssetCombo.ItemIndex]).link then begin
		      	  NodeData.alink := PVTResourceData(FEF.AssetCombo.Items.Objects[FEF.AssetCombo.ItemIndex]).link;
  		    		FPMainDataset.SQL.Text := 'SELECT`balance`FROM ' + NodeData.link + ' ORDER BY`index`DESC LIMIT 1';
		  		  	try
  		  		  	FPMainDataset.Open;
                Bal := FPMainDataset.FieldByName('balance').AsExtended;
			      	except
	  						on e: EZSQLException do begin
				  				ShowError(Self, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
			    		    NoError := false;
	  	  		    end;
				      end;

              if(Round(Bal * 100) > 0) then begin
                NoError := AssetsTransfer(OldAsset, NodeData.alink, bal, 'Перевод остатков фонда "' + NodeData.name +  '" на актив "' + FEF.AssetCombo.Items[FEF.AssetCombo.ItemIndex] +  '"', PopUpPrefix);
              end;
  		    		FPMainDataset.SQL.Text := 'INSERT INTO ' + PopUpPrefix + 'fundsvsassets(`fundlink`,`assetlink`)VALUES(:fFundLink,:fAssetLink)ON DUPLICATE KEY UPDATE assetlink=:fAssetLink';
						  FPMainDataset.ParamByName('fFundLink').AsString 	:= NodeData.link;
  						FPMainDataset.ParamByName('fAssetLink').AsString 	:= NodeData.alink;

		  		  	try
  		  		  	FPMainDataset.ExecSQL;
			      	except
	  						on e: EZSQLException do begin
				  				ShowError(Self, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
			    		    NoError := false;
	  	  		    end;
				      end;
      		  end; // if NoError and (OldAsset <> PVTResourceData(FEF.AssetCombo.Items.Objects[FEF.AssetCombo.ItemIndex]).link)

        		// FP1 amount data
		        if NoError and ((Round(FEF.FP1MoneyEdit.Value * 100) <> Round(OldFP1Amount * 100)) or(Round(FEF.FP1PctEdit.Value * 100) <> Round(OldFP1Pct * 100))) then begin
				      FPMainDataset.SQL.Text := 'INSERT INTO ' + PopUpPrefix + 'fp1funddata(fid,amount,pct)VALUES(:ffid,:famount,:fpct)';
  				    FPMainDataset.ParamByName('ffid').AsInteger	 := NodeData.index;
    			  	FPMainDataset.ParamByName('famount').AsFloat := FEF.FP1MoneyEdit.Value;
    			  	FPMainDataset.ParamByName('fpct').AsFloat    := FEF.FP1PctEdit.Value;

	  	  		  try
  	  	  		  FPMainDataset.ExecSQL;
	    	  		except
	  						on e: EZSQLException do begin
				  				ShowError(Self, 'Ошибка обновления данных о фонде.', e.ErrorCode, e.StatusCode, e.Message);
			    		    NoError := false;
	  	  		    end;
  	  	  		end;
	    		  end; // if NoError and (FEF.FP1MoneyEdit.Value <> OldFP1Amount)
	  	    end //
  	  	  else begin // it's a folder, i.e. we don't need fundsvsassets and fp1fundamount info
  		  		FPMainDataset.SQL.Text := 'DELETE FROM ' + PopUpPrefix + 'fundsvsassets WHERE fundlink=:fFundLink';
						FPMainDataset.ParamByName('fFundLink').AsString 	:= NodeData.link;
  	  		  try
 	  	  		  FPMainDataset.ExecSQL;
	    	  	except
  						on e: EZSQLException do begin
			  				ShowError(Self, 'Ошибка обновления данных о фонде.', e.ErrorCode, e.StatusCode, e.Message);
	    			    NoError := false;
    			    end;
	 	    		end;

            if NoError then begin
				      NodeData.alink := '';
            end;

            if NoError then begin
	  		  		FPMainDataset.SQL.Text := 'DELETE FROM ' + PopUpPrefix + 'fp1funddata WHERE fid=:ffid';
							FPMainDataset.ParamByName('ffid').AsInteger	:= NodeData.index;
	  	  		  try
 	  	  			  FPMainDataset.ExecSQL;
	    	  		except
  							on e: EZSQLException do begin
				  				ShowError(Self, 'Ошибка обновления данных о фонде.', e.ErrorCode, e.StatusCode, e.Message);
	  	  			    NoError := false;
  	  			    end;
		 	    		end;
            end;

    		  end;
        end; // if NoError then
		  end; // if not FEF.CheckBox.Visible
    end; // if NoError

    // closing transaction
    if NoError then begin
  		FPMainDataset.SQL.Text := 'COMMIT';
  	  try
 	  		FPMainDataset.ExecSQL;
      except
 				on e: EZSQLException do begin
	  			ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
        end;
      end;
    end; // if NoError

    if not NoError then begin
  		FPMainDataset.SQL.Text := 'ROLLBACK';
  	  try
 	  		FPMainDataset.ExecSQL;
      except
 				on e: EZSQLException do begin
	  			ShowError(Self, 'Невозможно откатить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        end;
      end;
    end; // else for if NoError
//    MainTree.RepaintNode(Node);
    MainTree.ReinitNode(Node, false);
  end;
  FEF.Free;
end;

procedure TMainFPForm.PopUpRenameOrgClick(Sender: TObject);
var
  CData : PVTResourceData;
  CNode : PVirtualNode;
  bIsOk : boolean;
  OrgForm : TOrgDataForm;
begin
  CNode := MAinTree.GetFirstSelected;
  if (CNode = nil) or (not IsIt(RNodesArr, CNode)) then
    Exit;

  CData := MainTree.GetNodeData(CNode);

  if CData.page <> 2 then
    Exit;

  OrgForm := TOrgDataForm.Create(nil);
  OrgForm.ShortNameEdit.Text := CData.name;
  OrgForm.FullNameEdit.Text := OrgNamesArr[CData.index];
  OrgForm.AddressEdit.Text := OrgAddressesArr[CData.index];
  OrgForm.PhoneEdit.Text := OrgPhonesArr[CData.index];

  if OrgForm.ShowModal = mrOk then begin
    OrgForm.FullNameEdit.Text := Trim(OrgForm.FullNameEdit.Text);
    OrgForm.AddressEdit.Text := Trim(OrgForm.AddressEdit.Text);
    OrgForm.PhoneEdit.Text := Trim(OrgForm.PhoneEdit.Text);
    OrgForm.ShortNameEdit.Text := Trim(OrgForm.ShortNameEdit.Text);

    bIsOk := true;
    try
      FPMainDataset.SQL.Text := 'UPDATE`orgs`SET`Abbr`=:fAbbr,`Name`=:fName,`Address`=:fAddress,`Phone`=:fPhone WHERE`ID`=:fID';
      FPMainDataset.ParamByName('fAbbr').AsString    := OrgForm.ShortNameEdit.Text;
      FPMainDataset.ParamByName('fName').AsString    := OrgForm.FullNameEdit.Text;
      FPMainDataset.ParamByName('fAddress').AsString := OrgForm.AddressEdit.Text;
      FPMainDataset.ParamByName('fPhone').AsString   := OrgForm.PhoneEdit.Text;
      FPMainDataset.ParamByName('fID').AsInteger     := CData.index;
      FPConnection.StartTransaction;
      FPMainDataset.ExecSQL;
      FPConnection.Commit;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'При обновлении информации об организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
        bIsOk := false;
      end;
    end;
    if bIsOk then begin
      OrgNamesArr[CData.index] := OrgForm.FullNameEdit.Text;
      OrgAddressesArr[CData.index] := OrgForm.AddressEdit.Text;
      OrgPhonesArr[CData.index] := OrgForm.PhoneEdit.Text;
      CData.name := OrgForm.ShortNameEdit.Text;
      Application.MessageBox(PWideChar('Информация об организации обновлена'), 'Операция выполнено успешно', MB_OK or MB_ICONINFORMATION);
    end
    else begin
      try
        FPConnection.Rollback;
      except
        on e: EZSQLException do begin
          ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        end;
      end;
    end
  end;
  OrgForm.Free;
end;

procedure TMainFPForm.PopUpShowHideArchedFundsClick(Sender: TObject);
begin
	gHideArchedFunds := not gHideArchedFunds;
  IniFile.WriteBool('General', 'HideArchedFunds', gHideArchedFunds);
	ShowHideArchedFunds;
end;

procedure TMainFPForm.PrintToolButtonClick(Sender: TObject);
Var
	OldColor 			: TColor;
  ColNums				: integer;
  Ratio					: extended;
  i							: integer;
  OldGridWidth 	: integer;
  GridWidth			: integer;
  RatioedGridWidth : integer;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

	if not PD.Execute then Exit;
  PrintingIsIP := true;
  //
  // compressing grid
	LockWindowUpdate(StrGrid.Handle);
	GridWidth := 0;
	for i := 0 to StrGrid.ColCount - 1 do
  	Inc(GridWidth, StrGrid.ColWidths[i]);
	if GridWidth > MaxPrintWidth then begin
  	Ratio := (GridWidth * 1.0) / (MaxPrintWidth * 1.0);
    RatioedGridWidth	:= 0;
		for i := 0 to StrGrid.ColCount - 2 do begin
      StrGrid.ColWidths[i] := Round((StrGrid.ColWidths[i] * 1.0) / ratio);
      Inc(RatioedGridWidth, StrGrid.ColWidths[i]);
    end;
    StrGrid.ColWidths[StrGrid.ColCount - 1] := MaxPrintWidth - RatioedGridWidth;
  end;

// 	StrGrid.PrintSettings.TitleText := MainGroupBox.Caption;
 	StrGrid.PrintSettings.TitleText := GridGroupBox.Caption;
//
	OldColor := StrGrid.Color;
	StrGrid.PrintSettings.RightSize	:= 50;
  StrGrid.PrintSettings.LeftSize := 50;
  StrGrid.PrintSettings.HeaderSize	:= 50;
  StrGrid.PrintSettings.FooterSize	:= 50;

  StrGrid.PrintSettings.NoAutoSize := true;
//  Grid1.PrintSettings.NoAutoSizeRow := true;
  StrGrid.PrintSettings.Centered := false;

  StrGrid.PrintSettings.Title := ppTopCenter;
  StrGrid.PrintSettings.TitleSpacing	:= 50;
  StrGrid.PrintSettings.HeaderFont.Size := 14;
  StrGrid.PrintSettings.Font.Size				:= 8;
  StrGrid.PrintSettings.Font.Style			:= NormalFontStyle;
  StrGrid.PrintSettings.Font.Color			:= clBlack;

  StrGrid.PrintSettings.Time 	:= ppBottomLeft;
  StrGrid.PrintSettings.Date	:= ppBottomLeft;
  StrGrid.PrintSettings.PageNr := ppBottomRight;

  StrGrid.PrintSettings.FixedCellsAlways := false;
  StrGrid.PrintSettings.UseFixedHeight := false;
  StrGrid.PrintSettings.UseFixedWidth		:= false;

  StrGrid.Print;

  // deflating grid
	if GridWidth > MaxPrintWidth then begin
    RatioedGridWidth	:= 0;
		for i := 0 to StrGrid.ColCount - 2 do begin
      StrGrid.ColWidths[i] := Round((StrGrid.ColWidths[i] * 1.0) * ratio);
      Inc(RatioedGridWidth, StrGrid.ColWidths[i]);
    end;
    StrGrid.ColWidths[StrGrid.ColCount - 1] := GridWidth - RatioedGridWidth;
  end;
  PrintingIsIP := false;
	LockWindowUpdate(0);
  StrGrid.Repaint;
end;

procedure TMainFPForm.TimeFilterToolButtonClick(Sender: TObject);
begin
//
	if TimeFilterToolButton.Down then begin
    TimeFilterToolButton.ImageIndex := 1;
    TimeFilterToolButton.Hint 			:= 'Фильтр активен, нажмите, чтобы деактивировать';
  end
  else begin
    TimeFilterToolButton.ImageIndex := 0;
    TimeFilterToolButton.Hint 			:= 'Фильтр неактивен, нажмите, чтобы активировать';
		PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
  end;
  SetFilerToolbarObjectsEnabled;

//  PeriodCombo.Enabled 						:= TimeFilterToolButton.Down;
//  FilterDateStartEdit.Enabled			:= TimeFilterToolButton.Down;
//  FilterDateEndEdit								:= TimeFilterToolButton.Down;

end;

procedure TMainFPForm.TransferToolButtonClick(Sender: TObject);
var
  AsTrF : TAssetTransferForm;
  i         : integer;
  j         : integer;
  CurOrgID  : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  AsTrF := TAssetTransferForm.Create(Self);
  j            := 0;
  CurOrgId     := 0;
  // populating Orgs Combo
  AsTrF.CurATPrefix := CurPrefix;
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      if PrivPresentMO(OrgData.descr, 'bf') and (not PrivPresentMO(OrgData.descr, 'a')) then begin
        New(ResData);
        ResData.name    := OrgData.name;
        ResData.prefix  := OrgData.prefix;
        ResData.descr   := OrgData.descr;
        ResData.index   := ORgData.index;
        AsTrF.OrgsList.Add(ResData);
        AsTrF.OrgCombo.Items.Add(ResData.name);
        if CurPrefix = ResData.prefix then
          CurOrgId := j;
        Inc(j);
      end
    end;
  end;

  if AsTrF.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Расход', MB_ICONINFORMATION or MB_OK);
    AsTrF.Free;
    Exit;
  end
  else begin
    AsTrF.OrgCombo.ItemIndex  := CurOrgId;
    AsTrF.OrgCombo.Enabled := AsTrF.OrgCombo.Items.Count > 1;
  end;

  AsTrF.ParentHWND := Handle;

  AsTrF.ShowModal;
  AsTrF.Free;
//  PostMessage(Self.Handle, UM_SUMSUPDATENEEDED, 0, 0);
end;

procedure TMainFPForm.CreditingButtonClick(Sender: TObject);
var
  CreditingForm: TCreditingForm;
  i            : integer;
  j            : integer;
  CurOrgId     : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  CreditingForm := TCreditingForm.Create(Self);

  j            := 0;
  CurOrgId     := 0;
  // populating Orgs Combo
  CreditingForm.CurOCPrefix := CurPrefix;
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      if PrivPresentMO(OrgData.descr, 'bc') and (not PrivPresentMO(OrgData.descr, 'a')) then begin
        New(ResData);
        ResData.name    := OrgData.name;
        ResData.prefix  := OrgData.prefix;
        ResData.index   := ORgData.index;
        CreditingForm.OrgsList.Add(ResData);
        CreditingForm.OrgCombo.Items.Add(ResData.name);
        if CurPrefix = ResData.prefix then
          CurOrgId := j;
        Inc(j);
      end
    end;
  end;

  if CreditingForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Кредитование', MB_ICONINFORMATION or MB_OK);
    CreditingForm.Free;
    Exit;
  end
  else begin
//    CreditingForm.OrgCombo.ItemIndex  := 0;
    CreditingForm.OrgCombo.ItemIndex  := CurOrgId;
    CreditingForm.OrgCombo.Enabled := CreditingForm.OrgCombo.Items.Count > 1;
  end;

  CreditingForm.InitForm;

  CreditingForm.ShowModal;
  CreditingForm.Free;
  if (CurValue = BRANCH_CREDITORS) or (CurValue = LIST_CREDITORS) then
  	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
  // renewing the main window
//  PostMessage(Self.Handle, UM_SUMSUPDATENEEDED, 0, 0);
end;

procedure TMainFPForm.EditPOPopUpClick(Sender: TObject);
Var
	item				: TListItem;
  PONum				: integer;
  RowNum			: integer;
//  FileInfo		: PFileInfo;
  AttInfo		  : PAttInfo;
  OrigPost		: string;
  OrigName		: string;
  SumCol			: integer;
  FormResult	: integer;
  SQLError		: boolean;
  i						: integer;
  j						: integer;
  CurFullName	: string;
  AttID				: integer;
	Stream 			: TFileStream;
  SQLRequest	: string;
  NewItem			: PAttToSave;
  LoadError		: boolean;

  LPPrefix    : string;
  LPPrefixID  : integer;
  NoError     : boolean;
  CurOrgId    : integer;
  OrgData     : PVTResourceData;
//  ResData      : PVTResourceData;
	IDsToDelete : string;
  CurFileName : string;

  tsum : extended;

begin
  RowNum	:= StrGrid.Row;
	if not TryStrToInt(StrGrid.Cells[1, RowNum], PONum) then
  	Exit;

  if Pos(rsSubdPORow, StrGrid.Cells[0, RowNum]) <= 0 then begin
  	POisRO	:= true;
		ReviewPOPopUpClick(Sender);
    Exit;
  end;

  POisRO := not POCanBeEdited;

  LPPrefix := CurPrefix;
  LPPrefixID := CurOInd;

  if not POisRO then begin
    FPMainDataset.SQL.Text := 'BEGIN';
    try
 	    FPMainDataset.ExecSQL;
    except
 	    on e: EZSQLException do begin
	      ShowError(Self, 'Невозможно инициализировать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;
  end;

  if not POisRO and not NoError  then begin
    FPMainDataset.SQL.Text := 'ROLLBACK';
  	try
 	    FPMainDataset.ExecSQL;
    finally

    end;
    Exit;
  end;

//  if not POisRO then begin
  	FPTmpDataset.SQL.Text := 'SELECT * FROM`' + LPPrefix + 'po`WHERE`index`=' + IntToStr(PONum);
    try
  	  FPTmpDataset.Open;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'При попытке получить данные о блокировке заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    	  NoError := false;
      end;
    end;
//  end;

  // check if it's locked
  if not POisRO then begin
    if NoError and (FPTmpDataset.RecordCount > 0) and (not FPTmpDataset.FieldByName('rsvdby').IsNull) then begin
      // and if it is
      FPMainDataset.SQL.Text := 'SELECT FirstName,MiddleName,FamilyName FROM users WHERE UserID=:fUID';
      FPMainDataset.ParamByName('fUID').AsInteger := FPTmpDataset.FieldByName('rsvdby').AsInteger;
      try
        FPMainDataset.Open;
      except
        on e: EZSQLException do begin
          ShowError(Self, 'При попытке получить данные о блокировке заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    	    Exit;
        end;
      end;

      Application.MessageBox(PWideChar('С заявкой № ' + IntToStr(PONum) + ' уже работает пользователь ' +
                  GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FirstName').AsString,FPMainDataset.FieldByName('MiddleName').AsString) + CRLF + 'Повторите попытку позже.'), 'Работа с заявкой', MB_OK or MB_ICONERROR);

      FPMainDataset.SQL.Text := 'ROLLBACK';
      try
        FPMainDataset.ExecSQL;
      except
        on e: EZSQLException do begin
          ShowError(Self, 'При попытке разблокировки заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
        end;
      end;
      // leave it
      Exit;
    end // if NoError and (FPMainDataset.RecordCount > 0)
    else begin
      // if it's not locked then we lock it!
      FPMainDataset.SQL.Text := 'UPDATE`' + LPPrefix + 'po`SET rsvdby=:fUID,dtby=DATE_ADD(NOW(),INTERVAL 1 MINUTE)WHERE`index`=:fPOID';
      FPMainDataset.ParamByName('fUID').AsInteger  := FPUserID;
      FPMainDataset.ParamByName('fPOID').AsInteger := PONum;
      try
        FPMainDataset.ExecSQL;
      except
 	      on e: EZSQLException do begin
	        ShowError(Self, 'Невозможно заблокировать заявку.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;

      if NoError then begin
  		  FPMainDataset.SQL.Text := 'COMMIT';
    	  try
 	    		FPMainDataset.ExecSQL;
        except
 			  	on e: EZSQLException do begin
	  		  	ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        	  NoError := false;
          end;
        end;
      end; // if NoError

      if not NoError then begin
    		FPMainDataset.SQL.Text := 'ROLLBACK';
  	    try
 	  	  	FPMainDataset.ExecSQL;
        finally

        end;
        Exit;
      end; // else for if NoError
    end; // else begin
  end; // if not POisRO

	POForm := TPOForm.Create(Self);   // edit PO
  POForm.OPPrefix   := LPPrefix;
  POForm.OPPrefixID := LPPrefixID;

//  POForm.BeingEdited := not boolean(TMenuItem(Sender).ImageIndex); // setting flag whether we're editing the PO
	POForm.BeingEdited	        := POCanBeEdited;
	POForm.Caption              := 'Заявка № ' + IntToStr(PONum) + ' от ' + DateToStr(FPTmpDataset.FieldByName('date').AsDateTime);
  POForm.PONum		            := PONum;
  POForm.SubjectEdit.Text     := StrGrid.Cells[3, RowNum];
  POForm.SubjectEdit.Enabled  := POForm.BeingEdited;

  POForm.CashCB.Checked := boolean(FPTmpDataset.FieldByName('bycash').AsInteger);
	POForm.CashCB.Enabled	:= POCanBeEdited;
//	POForm.CashCB.Enabled	:= POForm.BeingEdited;

  // populating Orgs Combo
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      if CurPrefix = OrgData.prefix then begin
        POForm.OrgCombo.Items.Add(OrgData.name);
        break;
      end;
    end;
  end;

  if POForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Редактирование заявки на ФП', MB_ICONINFORMATION or MB_OK);
    POForm.Free;
    Exit;
  end
  else begin
    POForm.OrgCombo.ItemIndex  := 0;
    POForm.OrgCombo.Enabled    := false;
  end;
//

  if Pos(rsSubdPORow, StrGrid.Cells[0, RowNum]) > 0 then begin
		SumCol := 7;
  end
  else if Pos(rsRejdPORow, StrGrid.Cells[0, RowNum]) > 0 then begin
		SumCol := 6;
  end
  else if Pos(rsAppdPORow, StrGrid.Cells[0, RowNum]) > 0 then begin
		SumCol := 5;
  end
  else if Pos('gray', StrGrid.Cells[0, RowNum]) > 0 then begin
		SumCol := 4;
  end;

	//POForm.SumEdit.Text           := StrGrid.Cells[SumCol, RowNum];
  TryStrToFloat(MyCleanStr(StrGrid.Cells[SumCol, RowNum]), tsum);
  POForm.SumEdit.Value := tsum;

  //POForm.SumEdit.Text           := '1000'; //StrGrid.Cells[SumCol, RowNum];
	POForm.SumEdit.Enabled        := POForm.BeingEdited;
  POForm.TextMemo.Text          := FPTmpDataset.FieldByName('csw').AsString;
  POForm.TextMemo.ReadOnly      := not POForm.BeingEdited; // we can edit the area in the case of editing
  POForm.AttestCheckBox.Checked := true;
  POForm.AttestCheckBox.Enabled := false;
  POForm.SubmitButton.Visible   := POForm.BeingEdited;

  if POForm.BeingEdited then
  	POForm.SubmitButton.Caption := 'Сохранить изменения';

  POForm.ResetButton.Visible    	:= POForm.BeingEdited;
  POForm.UrgencyCheckBox.Enabled	:= POForm.BeingEdited;
  POForm.UrgencyCheckBox.Checked	:= (FPTmpDataset.FieldByName('status').AsInteger = -1) or (FPTmpDataset.FieldByName('status').AsInteger in [4, 5]);

//  POForm.UrgencyCombo.Visible		:= POForm.BeingEdited;
//	POForm.UrgencyLabel.Visible		:= POForm.BeingEdited;

  POForm.CancelButton.Caption   := 'Закрыть';
  POForm.OrigDate	:= FPTmpDataset.FieldByName('date').AsDateTime;

  with FPMainDataset do begin
		SQL.Text := 'SELECT tbl2.*,' + LPPrefix + 'postsdir.Abbr FROM ' + LPPrefix + 'postsdir JOIN' +
                '(SELECT PostID,userid,FName,MName,FamilyName FROM ' + LPPrefix + 'psts JOIN' +
                '(SELECT pstsid,userid,FirstName AS FName,MiddleName AS MName,FamilyName FROM ' + LPPrefix + 'pstsfills JOIN allusers ' +
                'USING(UserID)WHERE allusers.login=:fLogin and(Now()>=startdate)AND((Now()<enddate)or(enddate is NULL)))AS tbl1 ' +
                'ON tbl1.pstsid=' + LPPrefix + 'psts.id)AS tbl2 ON tbl2.PostID=' + LPPrefix + 'postsdir.ID';// LOCK IN SHARE MODE';
  	ParamByName('fLogin').AsString := FPTmpDataset.FieldByName('origin').AsString;
  	Open;
  	OrigPost  := FieldByName('Abbr').AsString;
  	OrigName	:= GetShortFIO(FieldByName('FamilyName').AsString, FieldByName('FName').AsString, FieldByName('MName').AsString);
  end;

  POForm.OrigPost := OrigPost;
  POForm.OrigName	:= OrigName;

//  POForm.AttestLabel.Caption := 'Я, ' + OrigName + ', ' + OrigPost +
  POForm.AttestLabel.Caption := 'Я, ' + OrigName + ', ' + OrigPost +
													      ', подтверждаю, что данный расход действительно необходим для работы организации и цена является оптимальной.';

	POForm.btnAddFiles.Visible := POForm.BeingEdited;
  //loading attachments
  FPMainDataset.SQL.Text := 'SELECT id,FileName FROM '+ LPPrefix + 'poatt WHERE PONum=:fPONum';
  FPMainDataset.ParamByName('fPONum').AsInteger := PONum;
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
  	New(AttInfo);
    AttInfo.FileName := FPMainDataset.FieldByName('FileName').AsString;
    AttInfo.POAttID  := FPMainDataset.FieldByName('id').AsInteger;
    AttInfo.OrgID    := LPPrefixID;
    AttInfo.FullName := AttInfo.FileName;
    AttInfo.state    := AS_NOTLOADED; // not loaded

    POForm.FilesListView.AddItem(AttInfo.FileName, pointer(AttInfo));
    FPMainDataset.Next;
  end;
  //loading attachments - end of

  if not POForm.BeingEdited then begin
	  POForm.FilesListView.Height := POForm.TextMemo.Height;
    POForm.btnAddFiles.Visible  := false;
    POForm.lblAtts.Visible      := POForm.btnAddFiles.Visible;
    if POForm.FilesListView.Items.Count < 1 then begin
  	  POForm.TextMemo.Width := POForm.FilesListView.Width + POForm.FilesListView.Left - POForm.TextMemo.Left;
	    POForm.FilesListView.Visible := false;
    end;
  end;

  POForm.OrgCombo.Enabled := false;
  POForm.OrgCombo.Visible := false;
  POForm.OrgLabel.Visible := false;

  FormResult := POForm.ShowModal;

  if (POForm.BeingEdited) and (FormResult = mrOk) then begin
    SQLError := false;

		FPMainDataset.SQL.Text  := 'BEGIN';
  	try
	    FPMainDataset.ExecSQL;
    except
  	  on e: EZSQLException do begin
			  ShowError(Self, 'При инициализации транзацкии произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    		SQLError := true;
      end;
    end;

    if not SQLError then begin
      // saving the changes in the PO itself
      FPMainDataset.SQL.Text := 'UPDATE`'+ LPPrefix + 'po`SET`re`=:fre,`csw`=:fcsw,`sumr`=:fsumr,`status`=:fStatus,rsvdby=NULL,dtby=NULL,bycash=:fBC WHERE`index`=:fPONum';
      FPMainDataset.ParamByName('fBC').AsInteger := integer(POForm.CashCB.Checked);
      FPMainDataset.ParamByName('fre').AsString    		:= POForm.SubjectEdit.Text;
      FPMainDataset.ParamByName('fcsw').AsString   		:= POForm.TextMemo.Text;
      FPMainDataset.ParamByName('fsumr').AsFloat   		:= POForm.SumEdit.Value; // StrToFloat(POForm.SumEdit.Text);
      FPMainDataset.ParamByName('fStatus').AsInteger	:= integer(POForm.UrgencyCheckBox.Checked) * (-1);
      FPMainDataset.ParamByName('fPONum').AsInteger		:= PONum;

      try
	      FPMainDataset.ExecSQL;
  	  except
    	  on e: EZSQLException do begin
		      ShowError(Self, 'При сохранении заявки произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    	  	SQLError := true;
  	    end;
      end;
    end;

    // remove all deleted attachements if any
    LPPrefixID := POForm.OPPrefixID;
   	IDsToDelete := '';
    if (not SQLError) and (POForm.AttsToDelete.Count > 0) then begin
	    FPMainDataset.SQL.Text := 'DELETE FROM '+ LPPrefix + 'poatt WHERE id IN (' + POForm.AttsToDelete[0];
    	IDsToDelete := IntTosTr(LPPrefixID) + '_' + POForm.AttsToDelete[0];
      for i := 1 to POForm.AttsToDelete.Count - 1 do begin
		    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',' + POForm.AttsToDelete[i];
		    IDsToDelete := IDsToDelete + ',' + IntTosTr(POForm.OPPrefixID) + '_' + POForm.AttsToDelete[i];
      end;
	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
	    try
		    FPMainDataset.ExecSQL;
		  except
  		  on e: EZSQLException do begin
			    ShowError(Self, 'При обновлении данных о приложениях к заявке произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
  	  end;
      // remove them attachements from the server folder.
      if not SQLError then begin
	  	  AttRemoveCS.Enter;
  	  	if AttsToRemove <> '' then
	    	 AttsToRemove := AttsToRemove + ',';
		    AttsToRemove := AttsToRemove + IDsToDelete;
  		  AttRemoveCS.Leave;
        AttRemoveEvent.SetEvent;
      end;
    end;
    // remove all deleted attachements if any - end of

    // save all atts - new version with thread
    for i := 0 to POForm.FilesListView.Items.Count - 1 do begin
    	if PAttInfo(POForm.FilesListView.Items[i].Data).POAttID <> 0 then continue;

    	SQLError := false;
      CurFileName := PAttInfo(POForm.FilesListView.Items[i].Data).FileName;
//      CurFullName := PAttInfo(POForm.FilesListView.Items[i].Data).FullName;

	    FPMainDataset.SQL.Text := 'INSERT INTO ' + LPPrefix + 'poatt(`id`,`PONum`,`FileName`,`Data`)VALUES(NULL,:fPOID,:fFileName,NULL)';
  	  FPMainDataset.ParamByName('fPOID').AsInteger 		:= PONum;
      FPMainDataset.ParamByName('fFileName').AsString := CurFileName;
      try                     // saving filename only - the file will be saved later
		    FPMainDataset.ExecSQL;
		  except
  		  on e: EZSQLException do begin
		  	  ShowError(Self, 'При записи в базу файла '+ CurFullName + ' произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
  	  end;
    	if SQLError then begin // if there was an error during inserting
      	FPMainDataset.SQL.Text := 'ROLLBACK'; // rollback it
	      FPMainDataset.ExecSQL;

	    	if (i < POForm.FilesListView.Items.Count - 1)  and
	    	 (IDYES = Application.MessageBox('Попытаться сохранить остальные приложения?', 'Сохранение приложений', MB_YESNO or MB_ICONQUESTION))
  	  	then
    	  	continue
      	else
      		break;
	    end;
	    FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
      try                     // saving filename only - the file will be saved later
		    FPMainDataset.Open;
		  except
  		  on e: EZSQLException do begin
		  	  ShowError(Self, 'При записи в базу файла '+ CurFullName + ' произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
  	  end;
    	if SQLError then begin // error during the just inserted ID retrieving
      	FPMainDataset.SQL.Text := 'ROLLBACK'; // rollback it
	      FPMainDataset.ExecSQL;

	    	if (i < POForm.FilesListView.Items.Count - 1)  and
	    	 (IDYES = Application.MessageBox('Попытаться сохранить остальные приложения?', 'Сохранение приложений', MB_YESNO or MB_ICONQUESTION))
  	  	then
    	  	continue
      	else
      		break;
	    end;
      AttID := FPMainDataset.FieldByName('ID').AsInteger;

      if SQLError then begin
      	FPMainDataset.SQL.Text := 'ROLLBACK'; // rollback saving this attachement
	      FPMainDataset.ExecSQL;

      	SqlError := false;
	      if Application.MessageBox(PWideChar('Невозможно прочитать файл ' + CurFullName + CRLF +
        													'Попытаться сохранить остальные приложения?'), 'Сохранение приложений',
      														MB_YESNO or MB_ICONQUESTION) = IDYES
      	then
        	continue
        else
          break;
      end;

			New(NewItem);
			NewItem.ATS_OrgID		:= LPPrefixID;  // Org prefix as integer
  		NewItem.ATS_POAttID	:= AttID;  // ID value from poatt field
		  NewItem.ATS_Name		:= CurFileName;  	// filename (editing/approving) of the attachment
      NewItem.ATS_Stream  := TMemoryStream.Create;
      NewItem.ATS_Stream.LoadFromStream(PAttInfo(POForm.FilesListView.Items[i].Data).Data);
      PAttInfo(POForm.FilesListView.Items[i].Data).Data.Free;

			AttSaveCS.Enter;
			AttsToSave.Add(NewItem);
			AttSaveCS.Leave;
      AttSaveEvent.SetEvent;
    end; // for i :=
   	FPMainDataset.SQL.Text := 'COMMIT'; // rollback saving this attachement
    FPMainDataset.ExecSQL;
    // save all atts - new version with thread - end of
  end // if (POForm.BeingEdited) and (FormResult = mrOk) then begin
  else begin //
    //unlock PO if it was opened not in Read-Only mode
    if not SQLError and not POisRO then begin
      // saving the changes in the PO itself
      FPMainDataset.SQL.Text := 'UPDATE`'+ LPPrefix + 'po`SET rsvdby=NULL,dtby=NULL WHERE`index`=:fPONum';
      FPMainDataset.ParamByName('fPONum').AsInteger	:= PONum;
      try
	      FPMainDataset.ExecSQL;
  	  except
    	  on e: EZSQLException do begin
		      ShowError(Self, 'Не удалось разблокировать заявку.', e.ErrorCode, e.StatusCode, e.Message);
  	    end;
      end;
    end;
  end;
  POForm.Free;
end;

procedure TMainFPForm.NewFP(Sender: TObject);
var
  NewFPForm : TNewFPForm;
  tmpStr : string;
  SFPNum   : string;
begin
//
  FormatString.DateSeparator := '-';
//  Showmessage(DateTimeToStr(now, FormatString));
  NewFPForm := TNewFPForm.Create(nil);
  NewFPForm.Parent := Self;
  FPMainDataset.Close;
  FPMainDataset.SQL.Text := 'SELECT * FROM fp ORDER BY`index`DESC LIMIT 1';
  FPMainDataset.Open;
  if not FPMainDataset.IsEmpty then begin
    if FPMainDataset.FieldByName('to').AsString = '' then begin
      SFPNum := FPMainDataset.FieldByName('index').AsString;
      CurFPNum := StrToInt(SFPNum);
      NewFPForm.NumEdit.Text := SFPNum;
      tmpStr := FPMainDataset.FieldByName('from').AsString;
      FormatString.LongDateFormat   := 'YYYY-MM-DD';
      FormatString.ShortDateFormat  := 'YYYY-MM-DD';
      FormatString.ShortTimeFormat  := 'HH:MM:SS';
      FormatString.LongTimeFormat   := 'HH:MM:SS';
  //    ShowMessage(TmpStr);
//      NewFPForm.StartDateEdit.Date := StrToDateTime(FPMainDataset.FieldByName('from').AsString, FormatString);
      NewFPForm.StartDateEdit.Date    := StrToDateTime(tmpStr, FormatString);
      NewFPForm.StartTimePicker.Time  := StrToDateTime(tmpStr, FormatString);
      NewFPForm.EndDateEdit.Date      := NewFPForm.StartDateEdit.Date + 7;
      NewFPForm.EndTimePicker.Time    := NewFPForm.StartTimePicker.Time;
      if NewFPForm.ShowModal = mrOk then begin
        FPMainDataset.Close;
//        "UPDATE fp SET `to` = '$toDate' WHERE `index` = $fpNumber"
        TmpStr := DateToStr(NewFPForm.EndDateEdit.Date, FormatString) + ' ' + TimeToStr(NewFPForm.EndTimePicker.Time);
//        ShowMessage(DateToStr(NewFPForm.EndDateEdit.Date, FormatString) + ' ' + TimeToStr(NewFPForm.EndTimePicker.Time));
        FPMainDataset.SQL.Text := 'UPDATE fp SET`to`="' + TmpStr + '"WHERE`index`=' + SFPNum;
//        ShowMessage(FPMainDataset.SQL.Text);
        FPMainDataset.ExecSQL;
      end;
      NewFPForm.Free;
    end;
  end;
  FPMainDataset.Close;
  PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);

// Here the FP itself is to be added.
  ShowFP(Sender);

end;

procedure TMainFPForm.NewOrgWizButtonClick(Sender: TObject);
var
  NOWWF : TNewOrgWizWelcomeForm;
  FPressed  : boolean;
//  WasCAncelled : boolean
  NOWStep1Form: TNOWStep1Form;
  NOWStep2Form: TNOWStep2Form;
  CurStep : integer;
  StepResult : integer;
  NoError    : boolean;
  OrgName     : string;
  NewOrgID    : integer;
  NewOrgPrefix : string;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

(*
  NOWStep1Form := TNOWStep1Form.Create(nil);

  NOWStep1Form.Caption := 'Создание новой организации';
  NOWStep1Form.PrevStepButton.Visible := false;
  NOWStep1Form.PrevStepButton.Enabled := false;
  NOWStep1Form.NextStepButton.Visible := false;
  NOWStep1Form.NextStepButton.Enabled := false;
*)
// creating new org

  NOWWF := TNewOrgWizWelcomeForm.Create(nil);
  NOWStep1Form := TNOWStep1Form.Create(nil);
  NOWStep2Form := TNOWStep2Form.Create(nil);

  NOWOrgHasNoParent := true;
  NOWParentOrgID    := 0;
  NOWOrgHasNoTemplate := true;

  CurStep := 0;

  FPressed := false;

  repeat
    case CurStep of
      0: begin                              // initial step - welcome window
        StepResult := NOWWF.ShowModal;
        if (StepResult = mrOK) then begin
          FPressed := NOWWF.FinishPressed;
          OrgName := NOWWF.OrgNameEdit.Text;
          if not FPressed then  begin
            Inc(CurStep);
          end;
        end
        else begin
          break;
        end;
      end; // 0
      1: begin                              // first step - setting parent window
        if NOWOrgHasNoParent then begin                  // setting up currrent settings
          NOWStep1Form.NoParentRadio.Checked := true;
        end
        else begin
          NOWStep1Form.HasParentRadio.Checked := true;
        end;
        StepResult := NOWStep1Form.ShowModal;
        if (StepResult = mrOK) then begin
          NOWOrgHasNoParent := NOWStep1Form.NoParentRadio.Checked;
          NOWParentOrgID    := NOWStep1Form.CurPrntID;
          NextStepPressed   := NOWStep1Form.NextStepPressed;
          PrevStepPressed   := NOWStep1Form.PrevStepPressed;
          FPressed          := NOWStep1Form.FinishPressed;
          if NextStepPressed then begin
            Inc(CurStep);
          end
          else if PrevStepPressed then begin
            Dec(CurStep);
          end;
        end
        else begin
          break;
        end;
      end; // 1
//      2: begin                              // second step - setting template org
//        if NOWOrgHasNoTemplate then begin                  // setting up currrent settings
//          NOWStep2Form.NoTemplateRadio.Checked := true;
//        end
//        else begin
//          NOWStep2Form.HasTemplateRadio.Checked := true;
//        end;
//        StepResult := NOWStep2Form.ShowModal;
//        if (StepResult = mrOK) then begin
//          FPressed := NOWStep2Form.FinishPressed;
//          NOWOrgHasNoTemplate := NOWStep2Form.NoTemplateRadio.Checked;
//          NOWTmpltOrgID       := NOWStep2Form.TmpltOrgID;
//          NextStepPressed     := NOWStep2Form.NextStepPressed;
//          PrevStepPressed     := NOWStep2Form.PrevStepPressed;
//          if NextStepPressed then begin
//            Inc(CurStep);
//          end
//          else if PrevStepPressed then begin
//            Dec(CurStep);
//          end;
//        end
//        else begin
//          break;
//        end;
//      end; // 2
    end;
  until FPressed;

  NOWOrgHasNoParent := NOWStep1Form.NoParentRadio.Checked;
  NOWParentOrgID    := NOWStep1Form.CurPrntID;

  NOWStep2Form.Free;
  NOWStep1Form.Free;
  NOWWF.Free;


//  StepResult := NOWStep1Form.ShowModal;

//  if StepResult <> mrOk then begin
//    NOWStep1Form.Free;
//    Exit;
//  end;

  if not FPressed then begin
    Exit;
  end;

  NoError := true;
  FPMainDataset.SQL.Text := 'BEGIN';

  try
    FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
		  ShowError(Self, 'Невозможно инициировать транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
    	NoError := false;
    end;
  end;

  if not NoError then begin
    FPMainDataset.SQL.Text := 'ROLLBACK';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'Ошибка базы данных.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
    Exit;
  end;

  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'INSERT INTO orgs(`Name`,';
    if not NOWOrgHasNoParent then begin
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + '`SeniorID`,';
    end;
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + '`Abbr`)VALUES(:fName,';
    if not NOWOrgHasNoParent then begin
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ':fSnrID,';
    end;
    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ':fName)';

    FPMainDataset.ParamByName('fName').AsString := OrgName;
    if not NOWOrgHasNoParent then begin
      FPMainDataset.ParamByName('fSnrID').AsInteger := NOWPArentOrgID;
    end;

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При добавлении организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // Getting last ID
  if NoError then begin
		FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
    try                     // saving filename only - the file will be saved later
		  FPMainDataset.Open;
	    if not FPMainDataset.Eof then begin
		    NewOrgID := FPMainDataset.FieldByName('ID').AsInteger;
      end;
    except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'Произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
	      NoError := false;
      end;
    end;
  end; // if NoError

  // try to convert prefix
  NewOrgPrefix := IntToStr(NewOrgID);
  NoError := NewOrgPrefix <> '';
  // put the prefix back
  if NoError then begin
    FPMainDataset.SQL.Text := 'UPDATE orgs SET Prefix=:fPrefix WHERE ID=:fID';
    FPMainDAtaset.ParamByName('fPrefix').AsString := NewOrgPrefix;
    FPMainDAtaset.ParamByName('fID').AsInteger    := NewOrgID;
    try                     // saving filename only - the file will be saved later
		  FPMainDataset.ExecSQL;
    except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'Сбой базы данных.', e.ErrorCode, e.StatusCode, e.Message);
	      NoError := false;
      end;
    end;
  end; // if NoError

  // asset creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE `' + NewOrgPrefix + 'asset` like `asset`';

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // asset population
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'asset`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`)VALUES' +
                              '(1, "<<Главная", 2, "root", 0, NULL, NULL),' +
//                              '(2, "Касса", 9, "' + NewOrgPrefix + 'cash", 0, 0, NULL),' +
//                              '(3, "Банк", 8, "' + NewOrgPrefix + 'bank", 1, 0, NULL)';
                              '(2, "Касса (приходная)", 9, "' + NewOrgPrefix + CASH_LINK     + '", 0, 0, NULL),' +
                              '(3, "Касса (расходная)", 9, "' + NewOrgPrefix + DISBCASH_LINK + '", 0, 0, NULL),' +
                              '(4, "Банк", 8, "' + NewOrgPrefix + 'bank", 1, 0, NULL)';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // bank creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'bank`like`bank`';

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // bank population
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'bank`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`)VALUES' +
                              '(1, "<<Активы", 3, "' + NewOrgPrefix + 'asset", 0, 0.00, NULL, "", NULL, NULL),' +
                              '(2, "Счет №1", 9, "' + NewOrgPrefix + BILL1_LINK + '", 0, 0, NULL, "", NULL, NULL)';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // cash creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + CASH_LINK + '`like ' + CASH_LINK;

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // cash population
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + CASH_LINK + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`amount`,`price`,`in`,`out`,`incsrcid`,`pct`)VALUES' +
                              '(1, "<<Активы", 3, "' + NewOrgPrefix + 'asset", 0, 0.00, NULL, "", 0.00, 0.00, NULL, NULL, 0, 0.00)';

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // DISB cash creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + DISBCASH_LINK + '`like ' + DISBCASH_LINK;

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // cash population
  if NoError then begin
	  	// updating parent table
//    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + DISBCASH_LINK + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`amount`,`price`,`in`,`out`,`incsrcid`,`pct`)VALUES' +
//                              '(1,"<<Активы",3,"' + NewOrgPrefix + 'asset",0,0.00,NULL,"",0.00,0.00,NULL,NULL,0,0.00)';
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + DISBCASH_LINK + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`data`)VALUES' +
                              '(1,"<<Активы",3,"' + NewOrgPrefix + 'asset",0,0.00,"")';

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // Bill 1 creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + BILL1_LINK + '`like ' + BILL1_LINK;

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // bill 1 population
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + BILL1_LINK + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`amount`,`price`,`data`,`in`,`out`,`incsrcid`,`pct`)VALUES' +
                              '(0, "<<Банк", 2, "' + NewOrgPrefix + 'bank", 0, NULL, NULL, 0.00, 0.00, "", NULL, NULL, 0, 0.00)';

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // Creditors creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'creditor`like`creditor`';

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // Debitor creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'debtor`like`debtor`';

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // fund creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'fond`like`fond`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // fund population
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'fond`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`)VALUES' +
                              '(1,"<<Главная",2,"root",0,NULL,NULL)';

    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // FP table creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'fp`like`fp`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // fp population
  if NoError then begin
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'fp`(`index`,`from`,`to`,`plan`)VALUES' +
                              '(1,NOW(),NULL,NULL)';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // fp1funddata table creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'fp1funddata`like`fp1funddata`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // fundsvsassets table creation
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'fundsvsassets`like`fundsvsassets`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // incomesources creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'incomesources`like`incomesources`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // bill 1 population
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'incomesources`(`ID`,`pid`,`title`,`descr`)VALUES' +
                              '(1, 0, "По умолчанию", "По умолчанию")';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // LFP table creation
  if NoError then begin
//    FPMainDataset.SQL.Text := 'CREATE TABLE `' + NewOrgPrefix + 'lfp`like`' + NewOrgPrefix + 'fp`';
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'lfp`like`lfp`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // PO table creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'po`like`po`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // POatt table creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'poatt`like`poatt`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // posts creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'posts`like`posts`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // posts population
  if NoError then begin
	  	// updating parent table
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'posts`(`ID`,`SeniorID`,`OrgLink`,`Abbr`,`CommAlert`)VALUES' +
                              '(1,NULL,1,"Учредитель",0)';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // postsdir creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'postsdir`like`postsdir`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // postsdir population
  if NoError then begin
    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'postsdir`(`ID`,`SnrID`,`Abbr`)VALUES' +
                              '(1, NULL, "Учредитель")';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // psts creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'psts`like`psts`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // ****
  // postsdir population
//  if NoError then begin
//    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'psts`(`ID`,`SnrID`,`Abbr`)VALUES' +
//                              '(1, NULL, "Учредитель")';
//    try
//      FPMainDataset.ExecSQL;
//    except
//      on e: EZSQLException do begin
//		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
//      	NoError := false;
//      end;
//    end;
//  end;

  // pstsfills creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'pstsfills`like`pstsfills`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;
  // ****
  // postsdir population
//  if NoError then begin
//    FPMainDataset.SQL.Text := 'INSERT INTO`' + NewOrgPrefix + 'psts`(`ID`,`SnrID`,`Abbr`)VALUES' +
//                              '(1, NULL, "Учредитель")';
//    try
//      FPMainDataset.ExecSQL;
//    except
//      on e: EZSQLException do begin
//		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
//      	NoError := false;
//      end;
//    end;
//  end;

  // tocollect creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'tocollect`like`tocollect`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // topay creation
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE TABLE`' + NewOrgPrefix + 'topay`like`topay`';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // privileges setup
  if NoError then begin
    FPMainDataset.SQL.Text := 'INSERT INTO`uofp`(userID,OrgID,FPPRivs)VALUES(:fUserID,:fOrgID,"b")';
    FPMainDataset.ParamByName('fUserID').AsInteger := FPUserID;
    FPMainDataset.ParamByName('fOrgID').AsInteger  := NewOrgID;
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации организации произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // creating fp locking flush event
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE EVENT ' + FPConnection.Database + '_fp_' + NewOrgPrefix + ' ON SCHEDULE EVERY 60 SECOND DO UPDATE`' + FPConnection.Database + '`.`' + NewOrgPrefix + 'fp`SET rsvdby=NULL,dtby=NULL WHERE dtby<NOW()';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации события разблокировки финплана произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  // creating fp locking flush event
  if NoError then begin
    FPMainDataset.SQL.Text := 'CREATE EVENT ' + FPConnection.Database + '_po_' + NewOrgPrefix + ' ON SCHEDULE EVERY 60 SECOND DO UPDATE`' + FPConnection.Database + '`.`' + NewOrgPrefix + 'po`SET rsvdby=NULL,dtby=NULL WHERE dtby<NOW()';
    try
      FPMainDataset.ExecSQL;
    except
      on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации события разблокировки заявок произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
      	NoError := false;
      end;
    end;
  end;

  //
  // closing transaction
  //
  if NoError then begin
    FPMainDataset.SQL.Text := 'COMMIT';
    try                     // saving filename only - the file will be saved later
		  FPMainDataset.ExecSQL;
    except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
	      NoError := false;
      end;
    end;
  end; //

  if not NoError then begin
    FPMainDataset.SQL.Text := 'ROLLBACK';
    try                     // saving filename only - the file will be saved later
		  FPMainDataset.ExecSQL;
    except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
	      NoError := false;
      end;
    end;
  end; //

  if NoError then begin
    Application.MessageBox(PWideChar('Создание организации «' + OrgName + '» прошло успешно. Перезагрузите программу.'), 'Создание новой организации', MB_ICONINFORMATION or MB_OK);
  end
  else begin
    Application.MessageBox(PWideChar('При создании организации «' + OrgName + '» произошла ошибка.'), 'Создание новой организации', MB_ICONERROR or MB_OK);
  end;
end;

procedure TMainFPForm.NewPOByTemplateClick(Sender: TObject);
var
	TmpVal	: extended;
  PONum		: integer;
  RowNum	: integer;
  TmpData	: string;
  i            : integer;
  j            : integer;
  CurOrgId     : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;
  TpoPrefix   : string;
  NoError   : boolean;
begin
	RowNum	:= StrGrid.Row;
//	if  then
//    Exit;
	if (not TryStrToInt(StrGrid.Cells[1, RowNum], PONum)) or (mrYES <> Application.MessageBox('Вы действительно хотите создать новую заявку на основе выбранной?',
  		'Создание новой заявки', MB_YESNO or MB_ICONINFORMATION)) then
	  Exit;

  POForm := TPOForm.Create(Self);                       // New PO by template
  POForm.SubjectEdit.Text := StrGrid.Cells[3,	RowNum];
  TmpVal := 0;
  if Pos(rsSubdPORow, StrGrid.Cells[0, RowNum]) > 0 then begin
		TryStrToFloat(MyCleanStr(StrGrid.Cells[8, RowNum]), TmpVal);
  end
  else if Pos(rsRejdPORow, StrGrid.Cells[0, RowNum]) > 0 then begin
		TryStrToFloat(MyCleanStr(StrGrid.Cells[7, RowNum]), TmpVal);
  end
  else if Pos(rsAppdPORow, StrGrid.Cells[0, RowNum]) > 0 then begin
		TryStrToFloat(MyCleanStr(StrGrid.Cells[5, RowNum]), TmpVal);
  end
  else if Pos('gray', StrGrid.Cells[0, RowNum]) > 0 then begin
		TryStrToFloat(MyCleanStr(StrGrid.Cells[5, RowNum]), TmpVal);
  end;

  POForm.SumEdit.Value 				:=	TmpVal;

  j            := 0;
  CurOrgId     := 0;
  // populating Orgs Combo
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
//      if PrivPresentMO(OrgData.descr, 'bc') or PrivPresentMO(OrgData.descr, 'a') then begin
      if OrgData.descr <> '' then begin
        New(ResData);
        ResData.name    := OrgData.name;
        ResData.prefix  := OrgData.prefix;
        ResData.index   := ORgData.index;
		    ResData.ipref   := ORgData.ipref;
        POForm.OrgsList.Add(ResData);
        POForm.OrgCombo.Items.Add(ResData.name);
        if CurPrefix = ResData.prefix then
          CurOrgId := j;
        Inc(j);
      end
    end;
  end;

  if POForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Новая заявка на ФП', MB_ICONINFORMATION or MB_OK);
    POForm.Free;
    Exit;
  end
  else begin
    POForm.OrgCombo.ItemIndex  := CurOrgId;
    POForm.OrgCombo.Enabled    := POForm.OrgCombo.Items.Count > 1;
  end;
  TpoPrefix := CurPrefix;
  POForm.OPPrefix := TpoPrefix;

  FPMainDataset.SQL.Text := 'SELECT csw,bycash FROM ' + TpoPrefix + 'po WHERE `index`=' + IntToStr(PONum);

  FPMainDataset.Open;
  if FPMainDataset.RecordCount > 0 then
  	TmpData	:= FPMainDataset.FieldByName('csw').AsString;
  POForm.TextMemo.Text				:= TmpData;
	POForm.AttestLabel.Caption 	:=
  				'Я, ' + FPNameOfUser + ', ' + FPPostsArr[CurOInd] +
			    ', подтверждаю, что данный расход действительно необходим для работы организации и цена является оптимальной.';
	POForm.FilesListView.Visible  := true;
  POForm.btnAddFiles.Visible := true;
  POForm.CashCB.Checked := boolean(FPMainDataset.FieldByName('bycash').AsInteger);

  if POForm.ShowModal = mrOK then begin
//    if POForm.OPPrefix <> TpoPrefix then
    TpoPrefix := POForm.OPPrefix;

    NoError   := true;
    FPMainDataset.SQL.Text := 'BEGIN';
  	try
 	    FPMainDataset.ExecSQL;
    except
 		  on e: EZSQLException do begin
	  	  ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
      end;
    end;
    if NoError then begin
  		FPMainDataset.SQL.Text := 'INSERT INTO ' + TpoPrefix + 'po(origin,re,csw,sumr,status,bycash)Values(:flogin,:fre,:fcsw,:fsumr,:fStatus,:fBC)';
	  	FPMainDataset.ParamByName('fBC').AsInteger   := integer(POForm.CashCB.Checked);
	  	FPMainDataset.ParamByName('flogin').AsString 		:= FPLogin;
		  FPMainDataset.ParamByName('fre').AsString    		:= POForm.SubjectEdit.Text;
  		FPMainDataset.ParamByName('fcsw').AsString   		:= POForm.TextMemo.Text;
	  	FPMainDataset.ParamByName('fsumr').AsFloat   		:= POForm.SumEdit.Value; // StrToFloat(POForm.SumEdit.Text);
		  FPMainDataset.ParamByName('fStatus').AsInteger	:= integer(POForm.UrgencyCheckBox.Checked) * (-1);

    	try
 	      FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
  	  	  ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
    end;
    if NoError then begin
  		FPMainDataset.SQL.Text := 'COMMIT';
    	try
 	      FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
  	  	  ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
    end;
    if not NoError then begin
  		FPMainDataset.SQL.Text := 'ROLLBACK';
    	try
 	      FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
  	  	  ShowError(Self, 'Невозможно завершить транзакцию.', e.ErrorCode, e.StatusCode, e.Message);
        end;
      end;
    end;
  end;
	POForm.Free;
	PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
end;

procedure TMainFPForm.NewPOToolButtonClick(Sender: TObject);
var
  SQLError		: boolean;
  POID				: integer;
  AttID				: integer;
  i						: integer;
  CurFileName	: string;
  CurFullName	: string;
//  Stream			: TFileStream;
  POWasAdded	: Boolean;
  AttSaved		: boolean;
  OPO         : string;
  OPOID       : integer;
  j            : integer;
  CurOrgId     : integer;
  OrgData      : PVTResourceData;
  ResData      : PVTResourceData;
  NewItem			: PAttToSave;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  POWasAdded	:= false;
  AttSaved		:= false;
  POForm:= TPOForm.Create(Self);                    // New PO

  POForm.OPPrefix   := CurPrefix;
  POForm.OPPrefixID := Self.CurOInd;

  OPO             := POForm.OPPrefix;
  OPOID           := POForm.OPPrefixID;

  j            := 0;
  CurOrgId     := 0;
  // populating Orgs Combo
  for i := Low(RNodesArr) to High(RNodesArr) do begin
    if RNodesArr[i] <> nil then begin
      OrgData := MainTree.GetNodeData(RNodesArr[i]);
      New(ResData);
      ResData.name    := OrgData.name;
      ResData.prefix  := OrgData.prefix;
      ResData.ipref   := OrgData.ipref;
      ResData.index   := ORgData.index;
      POForm.OrgsList.Add(ResData);
      POForm.OrgCombo.Items.Add(ResData.name);
      if CurPrefix = ResData.prefix then begin
        CurOrgId := j;
      end;
      Inc(j);
    end;
  end;

  if POForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Новая заявка на ФП', MB_ICONINFORMATION or MB_OK);
    POForm.Free;
    Exit;
  end
  else begin
//    CreditingForm.OrgCombo.ItemIndex  := 0;
    POForm.OrgCombo.ItemIndex  := CurOrgId;
    POForm.OrgCombo.Enabled    := POForm.OrgCombo.Items.Count > 1;
  end;

  POForm.IsNew	:= true;
  POForm.AttestLabel.Caption :=
    'Я, ' + FPNameOfUser + ', ' + FPPostsArr[CurOInd] +
    ', подтверждаю, что данный расход действительно необходим для работы организации и цена является оптимальной.';

  if POForm.ShowModal = mrOK then begin

    OPO := POForm.OPPrefix;
    OPOID := POForm.OPPrefixID;

		SQLError	:= false;

		FPMainDataset.SQL.Text  := 'START TRANSACTION';
  	try
	    FPMainDataset.ExecSQL;
    except
  	  on e: EZSQLException do begin
			  ShowError(Self, 'При инициализации сохранения приложений произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
    		SQLError := true;
      end;
    end;

	  if SQLError then begin
      POForm.Free;
  	  Exit;
    end;

    FPMainDataset.SQL.Text := 'INSERT INTO ' + OPO + 'po(origin,re,csw,sumr,status,bycash)Values(:flogin,:fre,:fcsw,:fsumr,:fStatus,:fBC)';
	  FPMainDataset.ParamByName('fBC').AsInteger   := integer(POForm.CashCB.Checked);
    FPMainDataset.ParamByName('flogin').AsString 		:= FPLogin;
    FPMainDataset.ParamByName('fre').AsString    		:= POForm.SubjectEdit.Text;
    FPMainDataset.ParamByName('fcsw').AsString   		:= POForm.TextMemo.Text;
    FPMainDataset.ParamByName('fsumr').AsFloat   		:= POForm.SumEdit.Value; // StrToFloat(POForm.SumEdit.Text);
    FPMainDataset.ParamByName('fStatus').AsInteger	:= integer(POForm.UrgencyCheckBox.Checked) * (-1);
    try
	    FPMainDataset.ExecSQL;
	  except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'При сохранении заявки произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
    		SQLError := true;
	    end;
    end;
	  if SQLError then begin
      POForm.Free;
	    Exit;
  	end
    else begin
    	POWasAdded := true;
    end;

    FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
    try
			FPMainDataset.Open;
	  except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'При инициализации сохранения приложений произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
    		SQLError := true;
	    end;
    end;
    if SQLError then begin
      POForm.Free;
      Exit;
    end;
    POID	:= FPMainDataset.FieldByName('ID').AsInteger;

    // save attachments
    for i := 0 to POForm.FilesListView.Items.Count - 1 do begin
    	SQLError := false;
      CurFileName := PAttInfo(POForm.FilesListView.Items[i].Data).FileName;
      CurFullName := PAttInfo(POForm.FilesListView.Items[i].Data).FullName;

	    FPMainDataset.SQL.Text := 'INSERT INTO ' + OPO + 'poatt(`id`,`PONum`,`FileName`,`Data`)VALUES(NULL,:fPOID,:fFileName,NULL)';
  	  FPMainDataset.ParamByName('fPOID').AsInteger 		:= POID;
      FPMainDataset.ParamByName('fFileName').AsString := CurFileName;
      try                     // saving filename only - the file will be saved later
		    FPMainDataset.ExecSQL;
		  except
  		  on e: EZSQLException do begin
		  	  ShowError(Self, 'При записи в базу файла '+ CurFullName + ' произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
  	  end;
    	if SQLError then begin // if there was an error during inserting
      	FPMainDataset.SQL.Text := 'ROLLBACK'; // rollback it
	      FPMainDataset.ExecSQL;

	    	if (i < POForm.FilesListView.Items.Count - 1)  and
	    	 (IDYES = Application.MessageBox('Попытаться сохранить остальные приложения?', 'Сохранение приложений', MB_YESNO or MB_ICONQUESTION))
  	  	then
    	  	continue
      	else
      		break;
	    end;
	    FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
      try                     // saving filename only - the file will be saved later
		    FPMainDataset.Open;
		  except
  		  on e: EZSQLException do begin
		  	  ShowError(Self, 'При записи в базу файла '+ CurFullName + ' произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
    			SQLError := true;
		    end;
  	  end;
    	if SQLError then begin // error during the just inserted ID retrieving
      	FPMainDataset.SQL.Text := 'ROLLBACK'; // rollback it
	      FPMainDataset.ExecSQL;

	    	if (i < POForm.FilesListView.Items.Count - 1)  and
	    	 (IDYES = Application.MessageBox('Попытаться сохранить остальные приложения?', 'Сохранение приложений', MB_YESNO or MB_ICONQUESTION))
  	  	then
    	  	continue
      	else
      		break;
	    end;
      AttID := FPMainDataset.FieldByName('ID').AsInteger;

      if SQLError then begin
      	FPMainDataset.SQL.Text := 'ROLLBACK'; // rollback saving this attachement
	      FPMainDataset.ExecSQL;

      	SqlError := false;
	      if Application.MessageBox(PWideChar('Невозможно прочитать файл ' + CurFullName + CRLF +
        													'Попытаться сохранить остальные приложения?'), 'Сохранение приложений',
      														MB_YESNO or MB_ICONQUESTION) = IDYES
      	then
        	continue
        else
          break;
      end;

			New(NewItem);
			NewItem.ATS_OrgID		:= OPOID;  // Org prefix as integer
  		NewItem.ATS_POAttID	:= AttID;  // ID value from poatt field
		  NewItem.ATS_Name		:= CurFullName;  	// filename (editing/approving) of the attachment
      NewItem.ATS_Stream  := TMemoryStream.Create;
      NewItem.ATS_Stream.LoadFromStream(PAttInfo(POForm.FilesListView.Items[i].Data).Data);
      PAttInfo(POForm.FilesListView.Items[i].Data).Data.Free;

			AttSaveCS.Enter;
			AttsToSave.Add(NewItem);
			AttSaveCS.Leave;

    	FPMainDataset.SQL.Text := 'COMMIT'; // rollback saving this attachement
	    FPMainDataset.ExecSQL;
    end; // for i :=
    // save attachments - end of

  	FPMainDataset.SQL.Text := 'SET CHARACTER SET cp1251';
    try
		  FPMainDataset.ExecSQL;
    except
  	  on e: EZSQLException do begin
		    ShowError(Self, 'Ошибка при установке кодовой страницы. Заявка не сохранена', e.ErrorCode, e.StatusCode, e.Message);
    		SQLError := true;
      end;
    end;
    if not SQLError then begin
      FPMainDataset.SQL.Text := 'COMMIT'; // commmit saving this attachement
      try
	      FPMainDataset.ExecSQL;
      except
  	    on e: EZSQLException do begin
  		    ShowError(Self, 'Ошибка при установке кодовой страницы. Заявка не сохранена', e.ErrorCode, e.StatusCode, e.Message);
      		SQLError := true;
        end;
      end;
    end;
    if SQLError then begin
      FPMainDataset.SQL.Text := 'ROLLBACK'; // rollback saving this attachement
      try
	      FPMainDataset.ExecSQL;
      except
  	    on e: EZSQLException do begin
      		SQLError := true;
        end;
      end;
    end;
    POForm.Free;
    PostMessage(Self.Handle, UM_CLEARNAVBAR, 0, 0);
  end;
end;

procedure TMainFPForm.ShowFP(Sender: TObject);
begin
  StrGrid.Clear;
  StrGrid.ColCount := 7;
  StrGrid.RowCount := 10;
  StrGrid.Options := StrGrid.Options - [goRowSelect];
  FPMainDataset.Close;
  FPMainDataset.SQL.Text := 'SELECT `lastdate`, `data`, `in`, `link` '
end;

procedure TMainFPForm.ShowFundsVsAssetWindowPopUpClick(Sender: TObject);
var
	CNode			: PVirtualNode;
	CNodeData	: PVTResourceData;
  AVsFForm  : TAssetVsFundsForm;
begin
	CNode			:= MainTree.GetFirstSelected;
  if CNode = nil then
  	Exit;
  CNodeData := MainTree.GetNodeData(CNode);
  AVsFForm  := TAssetVsFundsForm.Create(nil);
  AVsFForm.DefAssName := CNodeData.name;
  AVsFForm.DefAssLink	:= CNodeData.link;
  AVsFForm.AvFPrefix  := CNodeData.prefix;
  AVsFForm.wfndfnd    := PrivPresentMO(CurPrivs, 'b0');
  AVsFForm.ShowModal;
  AVsFForm.Free;
end;

//procedure TMainFPForm.ExportToExcel;
////var
////	EA			: TExcelApplication;
////  EWB			: TExcelWorkbook;
////  EWS			: TExcelWorksheet;
////  TmpVal	: extended;
//begin
//(*
////	lcid:=LOCALE_SYSTEM_DEFAULT;
//	EA := TExcelApplication.Create(nil);
// 	EA.ConnectKind:=ckNewInstance;
//	EA.AutoQuit:=false;
//	try
//		EA.Visible[LOCALE_SYSTEM_DEFAULT]:=true;
//	except
//		on E:Exception do begin
//  	  Application.MessageBox('Microsoft Excel не установлен или установлен неправильно.', 'Экспорт данных', MB_ICONINFORMATION or MB_OK);
//      EA.Free;
//			Exit;
//		end;
//	end;
//	EA.AutoConnect:=true;
//
//	EA.ScreenUpdating[LOCALE_SYSTEM_DEFAULT] := False;
//
//
//  EWB := TExcelWorkbook.Create(nil);
//  EWS	:= TExcelWorksheet.Create(nil);
//
//	EWB.ConnectTo(EA.Workbooks.Add(EmptyParam,LOCALE_SYSTEM_DEFAULT));
//	EWS.ConnectTo(EA.ActiveWorkbook.ActiveSheet as ExcelWorkSheet);
//
//  ExportStrGridToExcel(EA);
//
//	EA.ScreenUpdating[LOCALE_SYSTEM_DEFAULT] := true;
//	EA.AutoQuit := False;
//  EWS.Disconnect;
//  EWB.Disconnect;
//	EA.UserControl := true;
//  EA.Disconnect;
//  EWS.Free;
//  EWB.Free;
//	EA.Free;
//*)
//end;

(*
procedure TMainFPForm.ExportStrGridToExcel(AEA: TExcelApplication);
var
	TmpVal	: extended;
  i				: integer;
  j				: integer;
  ri			: integer;
  nshift	: integer;
  TmpStr	: string;
begin
  case CurValue of
  	2: With AEA do begin                  							// root
			Range['A1','B1'].Font.Bold := true;
		  Range['A1','B1'].Interior.ColorIndex:=16;
			Range['A1',EmptyParam].Columns.ColumnWidth:= 80;
			Range['B1',EmptyParam].Columns.ColumnWidth:= 40;

		  Range['A1',EmptyParam].Value2 := 'Название';
		  Range['B1',EmptyParam].Value2 := 'Баланс';

		  Range['A1','B1'].HorizontalAlignment	:= xlCenter;

		  Range['A2','B2'].Font.Bold		:= true;
		  Range['A2','B2'].Font.Size		:= Range['A1','B1'].Font.Size + 2;
		  Range['A2','B2'].Font.ColorIndex 	:= 3; // to become xlRed
		  Range['A2',EmptyParam].Value2 		:= 'Доход за текущую неделю';
		  TryStrToFloat(MyCleanStr(StrGrid.Cells[2,1]), TmpVal);
		  Range['B2',EmptyParam].NumberFormat := '# ##0,00';
		  Range['B2',EmptyParam].Value2 := TmpVal;

		  Range['A3',EmptyParam].Value2 := 'Всего в фондах';
		  TryStrToFloat(MyCleanStr(StrGrid.Cells[2,2]), TmpVal);
		  Range['B3',EmptyParam].NumberFormat := '# ##0,00';
		  Range['B3',EmptyParam].Value2 := TmpVal;

		  Range['A4',EmptyParam].Value2 := 'Всего в фондах';
		  TryStrToFloat(MyCleanStr(StrGrid.Cells[2,3]), TmpVal);
		  Range['B4',EmptyParam].NumberFormat := '# ##0,00';
		  Range['B4',EmptyParam].Value2 := TmpVal;

		  Range['A5','B5'].Font.Bold		:= true;
		  Range['A5','B5'].Interior.ColorIndex:=15;
		  Range['A5',EmptyParam].Value2 := StrGrid.Cells[1,4];
		  TryStrToFloat(MyCleanStr(StrGrid.Cells[2,4]), TmpVal);
		  Range['B5',EmptyParam].NumberFormat := '# ##0,00';
		  Range['B5',EmptyParam].Value2 := TmpVal;
    end; // 2: root
	 	3,4: With AEA do begin                                // Assets, funds

			Range['A1','D1'].MergeCells									:= true;
			Range['A1','D1'].Font.Bold 									:= true;
      Range['A1',EmptyParam].HorizontalAlignment 	:= xlCenter;
      Range['A1',EmptyParam].Value2								:= AnsiUpperCase(GridGroupBox.Caption);
		  Range['A1',EmptyParam].Font.Size						:= Range['A1',EmptyParam].Font.Size + 2;


			Range['A2','D2'].Font.Bold 						:= true;
		  Range['A2','D2'].Interior.ColorIndex	:= 16;
			Range['A2',EmptyParam].Columns.ColumnWidth	:= 3;
			Range['B2',EmptyParam].Columns.ColumnWidth	:= 90;
      Range['C2',EmptyParam].Columns.ColumnWidth	:= 20;
      Range['D2',EmptyParam].Columns.ColumnWidth	:= 30;
		  Range['A2',EmptyParam].Value2 := '№';
		  Range['B2',EmptyParam].Value2 := 'Название';
		  Range['C2',EmptyParam].Value2 := 'Баланс';
		  Range['D2',EmptyParam].Value2 := 'Дата последней операции';
      Range['D2',EmptyParam].HorizontalAlignment := xlHAlignRight;
      for I := 1 to StrGrid.RowCount - 2 do begin
      	TmpStr := IntToStr(i+2);
			  Range['A'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[1, i];
			  Range['B'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[2, i];
			  TryStrToFloat(MyCleanStr(StrGrid.Cells[3,i]), TmpVal);
			  Range['C'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
			  Range['C'+TmpStr,EmptyParam].Value2 := TmpVal;
	      Range['D'+TmpStr,EmptyParam].HorizontalAlignment := xlHAlignRight;
        Range['D'+TmpStr,EmptyParam].Value2	:= StrGrid.Cells[4,i];
      end;

    	TmpStr := IntToStr(i+2);
		  Range['A'+TmpStr,'D'+TmpStr].Interior.ColorIndex:=15;
			Range['A'+TmpStr,'B'+TmpStr].MergeCells:=True;
		  Range['A'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[1, i];
//		  TryStrToFloat(MyCleanStr(StrGrid.Cells[3,i]), TmpVal);
		  Range['C'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
		  Range['C'+TmpStr,EmptyParam].Formula := '=sum(C3:C'+IntToStr(i+1)+')';
		end; // 3, 4
	 	7: With AEA do begin                                // POs
    	nShift := 0;
			Range['A1',EmptyParam].Columns.ColumnWidth	:= 6;
			Range['B1',EmptyParam].Columns.ColumnWidth	:= 19;
      Range['C1',EmptyParam].Columns.ColumnWidth	:= 15;
      Range['D1',EmptyParam].Columns.ColumnWidth	:= 15;
      Range['E1',EmptyParam].Columns.ColumnWidth	:= 15;
      Range['F1',EmptyParam].Columns.ColumnWidth	:= 15;
      Range['G1',EmptyParam].Columns.ColumnWidth	:= 15;
      Range['H1',EmptyParam].Columns.ColumnWidth	:= 15;
      Range['I1',EmptyParam].Columns.ColumnWidth	:= 60;
      Range['J1',EmptyParam].Columns.ColumnWidth	:= 40;

      // submitted POs
			Range['A1','H1'].MergeCells									:= true;

			Range['A1','H1'].Font.Bold 									:= true;
      Range['A1',EmptyParam].HorizontalAlignment 	:= xlCenter;
      Range['A1',EmptyParam].Value2								:= AnsiUpperCase(GridGroupBox.Caption);
		  Range['A1',EmptyParam].Font.Size						:= Range['A1',EmptyParam].Font.Size + 2;

			Range['A2','H2'].MergeCells									:= true;
			Range['A2','H2'].Font.Bold 									:= true;
		  Range['A2','H2'].Interior.ColorIndex				:= 15;
		  Range['A2',EmptyParam].Value2 							:= 'Выставленные заявки';
      Range['A2',EmptyParam].HorizontalAlignment	:= xlCenter;

		  Range['A3',EmptyParam].Value2 := '№';
      Range['A3',EmptyParam].HorizontalAlignment := xlHAlignRight;
		  Range['B3',EmptyParam].Value2 := 'Дата';
      Range['B3',EmptyParam].HorizontalAlignment := xlHAlignRight;
		  Range['C3','G3'].MergeCells		:= true;
      Range['C3',EmptyParam].HorizontalAlignment := xlHAlignLeft;
		  Range['C3',EmptyParam].Value2 := 'Тема';
		  Range['H3',EmptyParam].Value2 := 'Сумма';
      Range['H3',EmptyParam].HorizontalAlignment := xlHAlignRight;
		  Range['A3','H3'].Interior.ColorIndex				:= 16;

      i := 3;
//      nshift := 1;
      while StrGrid.Cells[0, i] <>'' do begin
      	TmpStr := IntToStr(i+1);
        if Pos('urgent', StrGrid.Cells[0, i]) > 0 then
				  Range['A'+TmpStr,'H'+TmpStr].Font.ColorIndex 	:= 3; // to become xlRed
			  Range['A'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[1, i];
			  Range['B'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[2, i];
        Range['B'+TmpStr,EmptyParam].HorizontalAlignment	:= xlHAlignRight;

        Range['C'+TmpStr,EmptyParam].Value2	:= StrGrid.Cells[3,i];
			  TryStrToFloat(MyCleanStr(StrGrid.Cells[8,i]), TmpVal);
			  Range['C'+TmpStr,'G'+TmpStr].MergeCells		:= true;
			  Range['H'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
			  Range['H'+TmpStr,EmptyParam].Value2 := TmpVal;
      	inc(i);
      end;
    	TmpStr := IntToStr(i+1);
			Range['A'+TmpStr,'G'+TmpStr].MergeCells		:= true;
		  Range['A'+TmpStr,'H'+TmpStr].Interior.ColorIndex:=15;
			Range['A'+TmpStr,EmptyParam].Value2 := 'Итого по выставленным заявкам';

		  Range['H'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
		  Range['H'+TmpStr,EmptyParam].Formula := '=sum(H4:H'+IntToStr(i)+')';
			Range['A'+TmpStr,'H'+TmpStr].Font.Bold 									:= true;
      // footer
      inc(i);

      // rejected POs
      // header
      inc(i);
      inc(nshift);
//    	TmpStr := IntToStr(i+nshift);
    	TmpStr := IntToStr(i + 1);
			Range['A'+TmpStr,'I'+TmpStr].MergeCells						:= true;
			Range['A'+TmpStr,'I'+TmpStr].Font.Bold 						:= true;
		  Range['A'+TmpStr,'I'+TmpStr].Interior.ColorIndex	:= 15;
		  Range['A'+TmpStr,EmptyParam].Value2 							:= 'Отклоненные заявки';
      Range['A'+TmpStr,EmptyParam].HorizontalAlignment	:= xlCenter;

      inc(i);
//    	TmpStr := IntToStr(i+nshift);
    	TmpStr := IntToStr(i + 1);
		  Range['A'+TmpStr,EmptyParam].Value2 							:= '№';
      Range['A'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['B'+TmpStr,EmptyParam].Value2 							:= 'Дата';
      Range['B'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['C'+TmpStr,'G'+TmpStr].MergeCells						:= true;
      Range['C'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignLeft;
		  Range['C'+TmpStr,EmptyParam].Value2 							:= 'Тема';
		  Range['H'+TmpStr,EmptyParam].Value2 							:= 'Сумма';
      Range['H'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['I'+TmpStr,EmptyParam].Value2 							:= 'Подпись';
      Range['I'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignLeft;
		  Range['A'+TmpStr,'I'+TmpStr].Interior.ColorIndex				:= 16;

      inc(i);
      j := i;
      while StrGrid.Cells[0, i - nShift] <>'' do begin
      	TmpStr := IntToStr(i + 1);
      	ri := i - nShift;
			  Range['A'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[1, ri];
			  Range['B'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[2, ri];
        Range['B'+TmpStr,EmptyParam].HorizontalAlignment	:= xlHAlignRight;
        Range['C'+TmpStr,EmptyParam].Value2	:= StrGrid.Cells[3, ri];
			  TryStrToFloat(MyCleanStr(StrGrid.Cells[6, ri]), TmpVal);
			  Range['C'+TmpStr,'G'+TmpStr].MergeCells		:= true;
			  Range['H'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
			  Range['H'+TmpStr,EmptyParam].Value2 := TmpVal;
			  Range['I'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[9, ri];
      	inc(i);
      end;
    	TmpStr := IntToStr(i + 1);
			Range['A'+TmpStr,'G'+TmpStr].MergeCells		:= true;
		  Range['A'+TmpStr,'I'+TmpStr].Interior.ColorIndex:=15;
			Range['A'+TmpStr,EmptyParam].Value2 := 'Итого по отклоненным заявкам';

		  Range['H'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
		  Range['H'+TmpStr,EmptyParam].Formula := '=sum(H'+IntToStr(j+1)+':H'+IntToStr(i)+')';
			Range['A'+TmpStr,'I'+TmpStr].Font.Bold 									:= true;
      Range['A'+IntToStr(j - 2),'I'+TmpStr].Font.ColorIndex 			:= 3; // to become xlRed
      // footer
      inc(i);

      // approved POs
      // header
      inc(i);
    	TmpStr := IntToStr(i + 1);
    	Inc(nshift);
			Range['A'+TmpStr,'J'+TmpStr].MergeCells						:= true;
			Range['A'+TmpStr,'J'+TmpStr].Font.Bold 						:= true;
		  Range['A'+TmpStr,'J'+TmpStr].Interior.ColorIndex	:= 15;
		  Range['A'+TmpStr,EmptyParam].Value2 							:= 'Одобренные';
      Range['A'+TmpStr,EmptyParam].HorizontalAlignment	:= xlCenter;
      Range['A'+TmpStr,'J'+TmpStr].Font.ColorIndex 			:= 10; // to become xlDarkGreen

      inc(i);
    	TmpStr := IntToStr(i + 1);
		  Range['A'+TmpStr,EmptyParam].Value2 							:= '№';
      Range['A'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['B'+TmpStr,EmptyParam].Value2 							:= 'Дата';
      Range['B'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['C'+TmpStr,'F'+TmpStr].MergeCells						:= true;
      Range['C'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignLeft;
		  Range['C'+TmpStr,EmptyParam].Value2 							:= 'Тема';
		  Range['G'+TmpStr,EmptyParam].Value2 							:= 'Сумма';
      Range['G'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['H'+TmpStr,EmptyParam].Value2 							:= 'Одобрено';
      Range['H'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['I'+TmpStr,EmptyParam].Value2 							:= 'Подпись';
      Range['I'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignLeft;
		  Range['J'+TmpStr,EmptyParam].Value2 							:= 'Источник';
      Range['J'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignLeft;
		  Range['A'+TmpStr,'J'+TmpStr].Interior.ColorIndex	:= 16;
      Range['A'+TmpStr,'J'+TmpStr].Font.ColorIndex 			:= 10; // to become xlDarkGreen

      inc(i);
      j := i;
      while StrGrid.Cells[0, i - nShift] <>'' do begin
      	TmpStr := IntToStr(i + 1);
      	ri := i - nShift;
        if Pos('urgent', StrGrid.Cells[0, i]) > 0 then
				  Range['A'+TmpStr,'J'+TmpStr].Font.ColorIndex 	:= 3 // to become xlRed
        else
		      Range['A'+TmpStr,'J'+TmpStr].Font.ColorIndex	:= 10; // to become xlDarkGreen

			  Range['A'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[1, ri];
			  Range['B'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[2, ri];
        Range['B'+TmpStr,EmptyParam].HorizontalAlignment	:= xlHAlignRight;
			  Range['C'+TmpStr,'F'+TmpStr].MergeCells		:= true;
        Range['C'+TmpStr,EmptyParam].Value2	:= StrGrid.Cells[3, ri];
			  TryStrToFloat(MyCleanStr(StrGrid.Cells[4,ri]), TmpVal);
			  Range['G'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
			  Range['G'+TmpStr,EmptyParam].Value2 := TmpVal;
			  TryStrToFloat(MyCleanStr(StrGrid.Cells[5,ri]), TmpVal);
			  Range['H'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
			  Range['H'+TmpStr,EmptyParam].Value2 := TmpVal;
			  Range['I'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[8,ri];
			  Range['J'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[9,ri];
      	inc(i);
      end;
    	TmpStr := IntToStr(i + 1);
			Range['A'+TmpStr,'F'+TmpStr].MergeCells		:= true;
		  Range['A'+TmpStr,'J'+TmpStr].Interior.ColorIndex:=15;
			Range['A'+TmpStr,EmptyParam].Value2 := 'Итого по одобренным заявкам';
			Range['A'+TmpStr,'J'+TmpStr].Font.ColorIndex	:= 10; // to become xlDarkGreen

		  Range['G'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
		  Range['G'+TmpStr,EmptyParam].Formula := '=sum(G'+IntToStr(j + 1)+':G'+IntToStr(i)+')';
		  Range['H'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
		  Range['H'+TmpStr,EmptyParam].Formula := '=sum(H'+IntToStr(j + 1)+':H'+IntToStr(i)+')';
			Range['A'+TmpStr,'I'+TmpStr].Font.Bold 									:= true;
      Range['A'+TmpStr,'J'+TmpStr].Font.ColorIndex	:= 10; // to become xlDarkGreen

      // footer
      inc(i);

      // paid POs
      // header
      inc(i);
    	TmpStr := IntToStr(i + 1);
    	Inc(nshift);
			Range['A'+TmpStr,'J'+TmpStr].MergeCells						:= true;
			Range['A'+TmpStr,'J'+TmpStr].Font.Bold 						:= true;
		  Range['A'+TmpStr,'J'+TmpStr].Interior.ColorIndex	:= 15;
		  Range['A'+TmpStr,EmptyParam].Value2 							:= 'Оплаченные';
      Range['A'+TmpStr,EmptyParam].HorizontalAlignment	:= xlCenter;

      inc(i);
    	TmpStr := IntToStr(i + 1);
		  Range['A'+TmpStr,EmptyParam].Value2 							:= '№';
      Range['A'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['B'+TmpStr,EmptyParam].Value2 							:= 'Дата';
      Range['B'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['C'+TmpStr,'F'+TmpStr].MergeCells						:= true;
      Range['C'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignLeft;
		  Range['C'+TmpStr,EmptyParam].Value2 							:= 'Тема';
		  Range['G'+TmpStr,EmptyParam].Value2 							:= 'Сумма';
      Range['G'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['H'+TmpStr,EmptyParam].Value2 							:= 'Одобрено';
      Range['H'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignRight;
		  Range['I'+TmpStr,EmptyParam].Value2 							:= 'Подпись';
      Range['I'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignLeft;
		  Range['J'+TmpStr,EmptyParam].Value2 							:= 'Источник';
      Range['J'+TmpStr,EmptyParam].HorizontalAlignment 	:= xlHAlignLeft;
		  Range['A'+TmpStr,'J'+TmpStr].Interior.ColorIndex	:= 16;

      inc(i);
      j := i;
      while StrGrid.Cells[0, i - nShift] <>'' do begin
      	TmpStr := IntToStr(i + 1);
      	ri := i - nShift;
        if Pos('urgent', StrGrid.Cells[0, i]) > 0 then
				  Range['A'+TmpStr,'J'+TmpStr].Font.ColorIndex 	:= 3; // to become xlRed

			  Range['A'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[1, ri];
			  Range['B'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[2, ri];
        Range['B'+TmpStr,EmptyParam].HorizontalAlignment	:= xlHAlignRight;
			  Range['C'+TmpStr,'F'+TmpStr].MergeCells		:= true;
        Range['C'+TmpStr,EmptyParam].Value2	:= StrGrid.Cells[3, ri];
			  TryStrToFloat(MyCleanStr(StrGrid.Cells[4,ri]), TmpVal);
			  Range['G'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
			  Range['G'+TmpStr,EmptyParam].Value2 := TmpVal;
			  TryStrToFloat(MyCleanStr(StrGrid.Cells[5,ri]), TmpVal);
			  Range['H'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
			  Range['H'+TmpStr,EmptyParam].Value2 := TmpVal;
			  Range['I'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[8,ri];
			  Range['J'+TmpStr,EmptyParam].Value2 := StrGrid.Cells[9,ri];
      	inc(i);
      end;
    	TmpStr := IntToStr(i + 1);
			Range['A'+TmpStr,'F'+TmpStr].MergeCells		:= true;
		  Range['A'+TmpStr,'J'+TmpStr].Interior.ColorIndex:=15;
			Range['A'+TmpStr,EmptyParam].Value2 := 'Итого по оплаченным заявкам';

		  Range['G'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
		  Range['G'+TmpStr,EmptyParam].Formula := '=sum(G'+IntToStr(j + 1)+':G'+IntToStr(i)+')';
		  Range['H'+TmpStr,EmptyParam].NumberFormat := '# ##0,00';
		  Range['H'+TmpStr,EmptyParam].Formula := '=sum(H'+IntToStr(j + 1)+':H'+IntToStr(i)+')';
			Range['A'+TmpStr,'I'+TmpStr].Font.Bold 									:= true;
    end; // 7 - POs

  end; // case CurValue of
end;
*)

procedure TMainFPForm.ShowIncSourceDirectory;
begin
//  ShowMessage('Тут будет справочник источников дохода');
end;


end.
