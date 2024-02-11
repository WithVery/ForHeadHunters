unit GlobalVars;

interface

{$IFDEF STATPROJ}
  {$I ..\FinStats_MUI\DEFINES.INC}
{$ENDIF}
{$IFDEF FPPROJ}
  {$I DEFINES.INC}
{$ENDIF}

uses
  Classes,
  Messages,
  SysUtils,
  Graphics,
  IniFiles,
//  Dialogs, 	// for ShowMessage - to be deleted
  Forms, 		// for Application - to be deleted
  Clipbrd, 	// for TClipboard
  JPEG,
	ExtCtrls, // for TImage, TTimer
  SyncObjs, // for TEvent
  Controls, // for TWinControl
  StdCtrls, // for TComboBox
//  MainFPWin,
  VirtualTrees, // for PVirtualNode
{$IFDEF FPPROJ}
  POLockerThread,
  PushToDBThread,
{$ENDIF}
	Printers, // for PrintGraphic function
  ShellApi, // for GetRegistryIconHandle(FileName: string): HICON;
  Registry, // for GetRegistryIconHandle(FileName: string): HICON;
  Windows,  // for GetRegistryIconHandle(FileName: string): HICON;
  ZConnection,
  DateUtils, // for DayOfTheWeek
  ZDataset;

{$IFNDEF FPPROJ}
{$R RUS.res}
{$R ENU.res}
{$R ESP.res}
{$ENDIF}

ResourceString
	rsFilterFullString  = 'Полностью совпадает';
	rsFilterSubString   = 'Явлется частью строки';
	rsOR                = 'ИЛИ';
	rsAND               = 'И';
	rsFullString        = 'Строка';
	rsSubString         = 'Подстрока';
	rsFilterIsInactive  = '.'; //'фильтр неактивен';
	rsFltIsInactStr     = 'фильтр неактивен';
	rsNoOrgsToDisplay   = 'У вас нет доступа ни к одной организации.';
	rsClosingProgram    = 'Завершение работы.';
	rsFileAccessError   = 'Ошибка доступа к файлу.';
	rsFileCanBeInUse    = 'Файл может использоваться другой программой.';
  rsByCash            = 'Нал';
  rsByBank            = 'Безнал';
	rsExportCompleted   = 'Экспорт успешно завершен.';
	rsPOExport          = 'Экспорт заявок.';

Const

	// string constatns ID
	nrsIncorrectData = 1;
	nrsIncorrectDataRcvd = 2;
	nrsSrvConnErr = 3;
	nrsConnSetupErr = 4;
	nrsFailedToGetStatValues = 5;
	nrsFailedToLoadStat = 6;
	nrsFailedToLoadStatList = 7;
	nrsFailedToLoadUngroupedStatList = 8;
	nrsFailedToLoadFPDates = 9;
	nrsFailedToLoadStatDates = 10;
	nrsFailedToSetupCodePage = 11;
	nrsFailedToLocateStatIC = 12;
	nrsFailedToCreateUser = 13;
	nrsFailedToInitUserInfo = 14;
	nrsFaileToUpdateUserInfo = 15;
	nrsFaileToDeleteUserInfo = 16;
	nrsFailedToStartTransation = 17;
	nrsFailedToCloseTransation = 18;
	nrsFailedToCreateNewPost = 19;
	nrsServerAnswerBelow = 20;
	nrsError = 21;
	nrsStatus = 22;
	nrsAddressToDevelopers = 23;
	nrsDataNotFound = 24;
	nrsAuthorError = 25;
	nrsCheckLoginPwd = 26;
	nrsStatsUser = 27;
	nrsUser = 28;
	nrsAccessLevel = 29;
	nrsFull = 30;
	nrsTitle = 31;
{$IFNDEF MONTHLY}
	nrsWeek = 32;
	nrsWeeks = 33;
{$ENDIF}
	nrsSureToDeleteStat = 34;
	nrsSureToDeleteGroup = 35;
	nrsSureToDeleteUser = 36;
	nrsAllDataToDelete = 37;
	nrsStatsAndDataToSave = 38;
	nrsUserToRemoveTotally = 39;
	nrsUserDelete = 40;
	nrsUserImpossibleToDelete = 41;
	nrsUserPOsExist = 42;
	nrsUserToArchive = 43;
	nrsUserDataChange = 44;
	nrsUserSaveData = 45;
	nrsUserAccessSetupSchanged = 46;
	nrsUserPostNotFound = 47;
	nrsUserPostToAdd = 48;
	nrsPostNotFound = 49;
	nrsConfirmDelete = 50;
	nrsPostCreate = 51;
	nrsPostProperties = 52;
	nrsPostDelete = 53;
	nrsGroupCreate = 54;
	nrsGroupProperties = 55;
	nrsGroupDelete = 56;
	nrsStatProperties = 57;
	nrsErrInput = 58;
	nrsErrAtLeastOneDataNeeded = 59;
	nrsErrStartIsToBeLess = 60;
	nrsLowMarginIsLessThanHigh = 61;
	nrsHighMarginIsMoreThanLow = 62;
	nrsHntShowGraphs = 63;
	nrsHntValuesShow = 64;
	nrsHntValuesHide = 65;
	nrsSaveData = 66;
	nrsGroupStat = 67;
	nrsRead = 68;
	nrsWrite = 69;
	nrsToContinue = 70;
	nrsCharsetSetUp = 71;
	nrsDataStructError = 72;
	nrsDataError       = 73;
  nrsCriticalError   = 74;
  nrsIncorrectGUIDError = 75;
  nrsCheckingForUpdates = 76;
  nrsConnectionError = 77;
  nrsUpdateError = 78;
  nrsDwldingUpdates = 79;
  nrsNoUpdates = 80;
  nrsFailedToLaunchFile = 81;
  nrsFile = 82;
  nrsUpdatesDownloaded = 83;
  nrsInstallingUpdates = 84;
  nrsUpdatesInstalled = 85;
  nrsRemovingTempFiles = 86;
{$IFDEF MONTHLY}
  nrsMonth = 87;
  nrsMonths = 88;
{$ENDIF}
  nrsDatesRangeError = 89;
  nrsDatesRangeErrorMessageTooShortPeriodMonthly = 90;
  nrsDatesRangeErrorMessageTooShortPeriodWeekly  = 91;
  nrsDatesRangeErrorMessageIncorrectRange = 92;
  nrsFPTrasferFromCashToBillOne = 93;

//
  UM_CLEARNAVBAR  	  	= WM_USER + $200; // UM_ stands for UserMessage
  UM_SHOWPROPERFP 	  	= WM_USER + $201;
	UM_FPWASAPPROVED    	= WM_USER + $202;
  UM_POPUPMENUNEEDED  	= WM_USER + $203;
	UM_STRGRIDPOPUPNEEDED = WM_USER + $205;
	UM_DEBCREDPOPUPNEEDED = WM_USER + $206;
	UM_POSPOPUPNEEDED 		= WM_USER + $207;
	UM_OKTODELINCSRC			= WM_USER + $208;
//	UM_ATT_FAILED_TO_LOAD	= WM_USER + $209;
//	UM_NEWATT_LOADED			= WM_USER + $20A;
	UM_LOGINNAMEOK        = WM_USER + $20B;  //this group is for LoginNameCheckThread
	UM_LOGINNAMENOTOK     = WM_USER + $20C;
	UM_LOGINNAMECHECKFAILED = WM_USER + $20D;
	UM_FP_ALLOCFORMCLOSED  = WM_USER + $20E;
	UM_FP_FUNDSLISTHIDE    = WM_USER + $20F;
	UM_FUNDTRANSFERRED     = WM_USER + $210;

	UM_RECONNECTNEEDED     = WM_USER + $211;
	UM_ARCHFUNDTOBEADDED   = WM_USER + $212;
	UM_BKGUPDATEFINISHED	 = WM_USER + $213;
  UM_LOGPULLFINISHED  	 = WM_USER + $214; // pulling info from log table completed
	UM_FPAPPROVEDEXT			 = WM_USER + $215; //
	UM_AVF_ASSETCHANGED		 = WM_USER + $216; //
	UM_FLPOPUPNEEDED   		 = WM_USER + $217; //

  UM_ATT_LOAD             = WM_USER + $218; // we have to load PO attachement from server
	UM_ATT_LOADINGFAILED    = WM_USER + $219; // attachement failed to load
	UM_ATT_LOADED			      = WM_USER + $21A; // attachement loaded from server successfully
	UM_ATT_OPEN			        = WM_USER + $21B; // attachement loaded from server successfully
	UM_ATT_LOAD_STARTED     = WM_USER + $21C; // attachement loaded from server successfully
	UM_ATT_LOAD_IP          = WM_USER + $21D; // attachement loaded from server successfully

	UM_CFILTER_APPLIED      = WM_USER + $21E;  // Column filter applied
	UM_CFILTER_DEACTIVATED  = WM_USER + $21F;  // Column filter deactivated

	UM_VST_END_EDIT         = WM_USER + $220;  // Virtual String Tree end edit cell
	UM_VST_CANCEL_EDIT      = WM_USER + $221;  // Virtual String Tree end edit cell
	UM_VST_SELECT_ITEM      = WM_USER + $222;  // Virtual String Tree select item at WParam

//  for updating and launching (launcher.exe)
  UM_UPDNEEDED           = WM_USER + $231;
  UM_UPDFAILED           = WM_USER + $232;
  UM_UPDNOTNEEDED        = WM_USER + $233;

  UM_UPDDWNLDSTARTED     = WM_USER + $234;
  UM_UPDDWNLDIP          = WM_USER + $235;
  UM_UPDDWNLDCMPLTD      = WM_USER + $236;

  UM_UPDSTARTED          = WM_USER + $237;
  UM_UPDIP               = WM_USER + $238;
  UM_UPDDELTMPFLS        = WM_USER + $239;
  UM_UPDCMPLTD           = WM_USER + $23A;
  UM_PERS_POPUPNEEDED    = WM_USER + $23B;


  CM_CHILDFORMCLOSE     	= WM_USER + $300;
  CM_GRAPHREBUILDNEEDED 	= WM_USER + $301;
  CM_NUMOFWEEKSCHANGED  	= WM_USER + $302;
  CM_STATADDEDFROMAS    	= WM_USER + $303;
  CM_STATNAMECHANGED    	= WM_USER + $304;
  CM_GROUPADDEDFROMAS   	= WM_USER + $305;
  CM_STVALCHANGEDFROMAS 	= WM_USER + $306;
  CM_SPP_SETTINGSCHANGED	= WM_USER + $307; // SPP is for StatPrintPreview
  CM_DATE_RANGE_CHANGED  	= WM_USER + $308;


// Parameters for ApplyStyleConversion
  TEXT_BOLD          = 1;
  TEXT_ITALIC        = 2;
  TEXT_UNDERLINE     = 3;
  TEXT_APPLYFONTNAME = 4;
  TEXT_APPLYFONT     = 5;
  TEXT_APPLYFONTSIZE = 6;
  TEXT_COLOR         = 7;
  TEXT_BACKCOLOR     = 8;

// Parameters for ApplyParaStyleConversion
  PARA_ALIGNLEFT   = 1;
  PARA_ALIGNCENTER = 2;
  PARA_ALIGNRIGHT  = 3;
  PARA_ALIGNJUST   = 4;
  PARA_INDENTINC = 15;
  PARA_INDENTDEC = 16;
  PARA_COLOR     = 17;


  // Types of invoices
  IT_DBT	= 0;
  IT_CRDT	= 1;
  IT_CASH	= 2;

  // for CompFondList
  CFL_WITHGROUPS   : boolean = true;
  CFL_IGNOREGROUPS : boolean = false;
  CFL_CONSIDERPOS  : boolean = true;
  CFL_IGNOREPOS    : boolean = false;

  // MyCleanStr constants
  UC_KEEPDOTS : boolean = false;
  AF_SHOWALLFUNDS : boolean = false;

  NewStatWinShiftX : integer = 20;
  NewStatWinShiftY : integer = 20;
  // Only these chars are allowed for editing of the grids
  AllowedChars : string = '-0123456789.,';

  A4Long	: extended	= 297.0;
  A4Short	: extended  = 210.0;
  GoldenProp : extended	= 297.0 / 210.0;
  DefColor	: TColor	= TColor($00D2E9FF);

{$IFDEF FPPROJ}
  MAINGUID : string = '{BAC4B800-D621-4A78-BEA1-9B817D4C08C6}';
{$ENDIF}

{$IFDEF STATPROJ}
  MAINGUID : string = '{BAC4B800-D621-4A78-BEA1-9B817D4C08C6}';
{$ENDIF}
  NumOfWeeks : array[0..3] of integer = (3, 13, 26, 52);

{$IFDEF TLOG}
	// Type of messages for "Log" table
  LT_INFO : integer = 0;
  LT_WARN : integer = 1;
  LT_ERR  : integer = 2;
  LT_BC   : integer = 3;  // "Broadcast" message

  // Codes of messages for "Log" table
  LC_FPAPPRVD : integer = 1; // FP was approved //<OrgPrefix>:<# of FP>:<date-time of this FP's period>
{$ENDIF}

  // MYSQL error codes
  MYSQLDUPLICATEENTRY		= 1062;
  MYSQLSEVERHASGONEAWAY = 2006;
  MYSWLSERVERSHUTDOWNIP = 1053;

  _CR_            : String = Chr(13);
  _LF_            : String = Chr(10);
  CRLF        		: String  = Chr(13) + Chr(10);
//  FROMCASH				: string 	= 'Из расходов';

  CASHID     : integer = 2; // here are the `index` values in the asset table
  DISBCASHID : integer = 3;
  BANKID     : integer = 4;

  // painting stuff
  NormalBkColor   : TColor = clWhite; //TColor($FFFFFF);
  NormalFontStyle : TFontStyles = [];

	MaxPrintWidth 	: integer = 650;

  clSpecBkColor		: TColor = TColor($0093B8CE);
  //clSpecBkColorLight : TColor = TColor($00C5EBFF);
  clSpecBkColorLight		: TColor = TColor($00A4C9DF);
  clMyDarkGray : TColor = TColor($00444444);
  clMyLightPink		: TColor = TColor($CCCCFF);
  clMyLightGray		: TColor = TColor($EEEEEE);
  clMyGray    		: TColor = TColor($555555);

  BRANCH_INCOME       : integer =   1;
  BRANCH_ASSETS       : integer =   3;
  BRANCH_FUNDS				: integer =   4;
  BRANCH_FP						: integer =   5;
  BRANCH_SEARCH				: integer =   6;
  BRANCH_POS					: integer =   7;
  BRANCH_FUND_ASSET		: integer =   9;
  BRANCH_ACCESS				: integer =  10;
  BRANCH_DEBITORS			: integer =  13;
  BRANCH_CREDITORS		: integer =  14;
  BRANCH_PERSONS      : integer =  15;

  LIST_CREDITORS			: integer = 100;
  LIST_DEBITORS				: integer = 101;
  //LIST_PERSONS        : integer = 102;

  LIST_PERSONS        = 102;
  rsListPersons       = 'Читатели';


  // "sub" values for FP branch
  FPROOT							: integer = 0;
  FPNOTAPPROVEDBRANCH	: integer = 1;
  FPARCHBRANCH				: integer = 2;
  FPNOTAPPROVED				: integer	= 3;
  FPARCHIVED					: integer	= 4;
	FPNEWFPTOCREATE			: integer = 5;

  // string constants
  CASH_LINK          	: string = 'cash';
  DISBCASH_LINK       : string = 'dca';
  BILL1_LINK					: string = 'gso';

  GS_CREATE_NEW_FP		: string = 'Создать новое ФП';

  // consts for MainTreePopUpMenu
  MTPM_SHOWAVFWIN     : integer = 0;
  MTPM_ADDENTITY      : integer = 1;
  MTPM_DELENTITY      : integer = 2;
  MTPM_ENTERBALANCE   : integer = 3;
  MTPM_PROPERTIES     : integer = 4;
  MTPM_WHATISIT       : integer = 5;
  MTPM_RENAMEORG      : integer = 6;

  // consts for (S)tring(G)rid(P)opUp(M)enu
  SGPM_CLOSEDEBT			: integer	=	0;
  SGPM_DELENTITY      : integer = 1;
  SGPM_EDITENTRY      : integer = 2;

//  SGPM_WHATISIT	      : integer = 2;   // supposed to be a context help for an item
  SGPM_SHOWFILER			: integer = 4;   // "show only" item in the PO context menu
  SGPM_SHOWHIDEPOS		: integer = 5;   // "show/hide" item in the PO context menu

  // consts for POsPopUpMenu
  POP_UNAPPROVE       : integer = 8;
  POP_DELETE          : integer = 9;

  //PO
  PO_SUBMITTED_UGNT   : integer = -1;
  PO_SUBMITTED        : integer = 0;
  PO_REJECTED         : integer = 1;
  PO_APROVED          : integer = 2;
  PO_PAID             : integer = 3;
  PO_APROVED_UGNT     : integer = 4;
  PO_PAID_UGNT        : integer = 5;

  // consts for (D)ebit(C)reditPopUp menu
  DCPM_VIEW						: integer	=	0;
  DCPM_SEARCH		      : integer = 1;
  DCPM_ADD			      : integer = 2;
  DCPM_DEL						: integer	= 3;
  DCPM_PROP			      : integer = 4;
  DCPM_WHATISIT	      : integer = 5;

  //consts for searching
  SEARCH_ALL					: integer = 0;
  SEARCH_INC					: integer = 1;
  SEARCH_DISB					: integer = 2;

  // Stat kinds values for main stat tree
  SVK_STAT            : integer = 0;
  SVK_GROUP           : integer = 1;
  SVK_ORG             : integer = 2;

  STF_US              : integer = 0;  // normal editable statistics
  STF_FP              : integer = 1;  // FP stat, not editable

  // status of the attachements in the PO form
  AS_NOTLOADED      : integer = 0;
  AS_LOADINGSTARTED : integer = 1;
  AS_LOADED         : integer = 2;
  AS_LOADINGFAILED  : integer = 3;
  AS_LOCAL          : integer = 4;

  // next AppName is to be changed to the new branding of the software
 // AppName : string = 'AdminPower'; //  needed to create ini file in user "Application data" folder
  AppName         : string = 'FinancePlanning'; //  needed to create ini file in user "Application data" folder
  DebtListSection : string = 'DLW';
  POIniSection	  : string = 'POSettings';

  UNIQUE							: integer = 0;
  NON_UNIQUE					: integer = 1;

//  (I)ncome (S)ource (F)orms constatnts
  ISF_OKTODELETE			: integer = 1;
  ISF_NOTOKTODELETE		: integer = 0;     // not used in reality

  ftInt    : integer = 0;
  ftExt    : integer = 1;
  ftDates  : integer = 2;
  ftStr    : integer = 3;

  // Short forms for montha
  MonthNameShort: array[1..12] of string = ('Янв.', 'Февр.', 'Март', 'Апр.', 'Май', 'Июнь', 'Июль', 'Авг.', 'Сент.', 'Окт.', 'Нояб.', 'Дек.');


Type
{$IFDEF FPPROJ}
	PFilterData = ^TFilterData;
  TFilterData = record
    Active   : boolean;    // TRUE when filter is active
  	Kind     : integer;    // type of filtering: 0 - int; 1 - float; 2 - date; 3 - string
    Oper1    : string;     // <,>,<= in case of int, float or date and "=" or "part of" in case of string value
    Oper2    : string;     // the same as oper 1
    op2OR    : boolean;    // TRUE - OR second comparison, FALSE - AND second comparison
    SecOp    : boolean;    // second operator is active (always FALSE in case of string comparison)
    IntVal1  : integer;
    IntVal2  : integer;
    ExtVal1  : extended;
    ExtVal2  : extended;
    DateVal1 : TDateTime;
    DateVal2 : TDateTime;
    StrVal   : string;
  end;

	PIncomeSourceProperty = ^TIncomeSourceProperty;
  TIncomeSourceProperty = record
    kind  : string;
    name  : string;
    price : extended;
    description : string;
  end;

	PIncomeEntity = ^TIncomeEntity; // used in IncomeEnteringWindow
  TIncomeEntity = record
    IsText : string;
    IsID   : integer;
    price  : extended;
    amount : integer;
//    total  : extended;
  end;

//  PFilterObject = ^TFilterObject;
  TFilterObject = class(TObject)
  private
    { Private declarations }
    Data : TFilterData;
    procedure Clear;
  public
    { Public declarations }
		constructor Create; //overload;   // Этот конструктор использует умолчания
//		constructor Create(AType : integer); overload;   // Этот конструктор использует умолчания
    function GetIntFilterResult(AVal : integer) : boolean;
    function GetStrFilterResult(AVal : string) : boolean;
		function GetExtFilterResult(AVal: extended) : boolean;
		function GetDatesFilterResult(AVal: TDateTime) : boolean;
		function StateToString : string;
    procedure SetFilterType(AType : integer);
    function GetFilterType : integer;
    procedure SetUpFilter;
  end;

  PColFilters =  ^TColFilters;
  TColFilters = array of TFilterObject;
{$ENDIF}

//	TStatAccess = record
//    sID : integer;
//    access : string;
//  end;
//
//
  PUserData = ^TUserData;
  TUserData = record
    Index    		: integer;
    Name    		: string;  // FIO
    Login   		: string;
    Post    		: string;
    Access  		: string;
    FirstName		: string;
    MiddleName	: string;
    FamilyName	: string;
    StatsAccess : array of string; // TStatAccess; // (r) for read, (w) for write
    arched      : boolean;
  end;

  PStatValue =  ^TStatValue;
  TStatValue = record     //
    Value : extended;
    Date  : TDate; //TDateTime;
  end;

  PAStatValue =  ^TAStatValue;
  TAStatValue = array of TStatValue;

// Type for managing stats in list
  PStat =  ^TStat;
  TStat = record     //
    ID               : integer;
    OrgID            : integer;
    UserID           : integer;
    UserName         : string;
    PostName         : string;
    ShortDescription : string;
    //WShortDescription : WideString;
    Values           : TAStatValue; //array of TStatValue;
    FullDescription  : string;      // contains Stas Privileges in case node is an Org
    kind             : integer;     //  0 - stat, 1 - group, 2 - org
    Shown            : boolean;
    ValuesLoaded     : boolean;
    MinYValue        : extended;
    MaxYValue        : extended;
    MinYAuto         : boolean;
    MaxYAuto         : boolean;
    UpsideDown       : boolean;
    SecondGraph      : integer;   // in case of OrgNode in Stats window it's a W/E day
    saux             : string;
    flags            : integer;  // flags: 1 - FP group/stat,
  end;

  TAPVN = array of PVirtualNode;

	PFFLData = ^TFFLData;
  TFFLData = record
  	index				: integer;
    link        : string;
    name  			: string;
    InAmnt 			: extended;
    FPAmnt      : extended;
    POAmnt 			: extended;
    IsInFP      : boolean;
//    FPAmnt      : extended;
  end;

	PArrearData = ^TArrearData;
  TArrearData = record
  	index				: integer;
    Checked 		: boolean;
    PayDate			: TDate;
    Amount			: extended;
    SumToClose	: extended;
  end;

  PIncSrcData = ^TIncSrcData;
  TIncSrcData = record
    Index    		: integer;
    Title    		: string;
    Price       : extended;
    Descr   		: string;
  end;

	POrgData	= ^TOrgData;
  TOrgData = record
  	ID				: integer;
    ShortName	: string;
    FPPrivs		: string;
    prefix    : string;
    swe       : integer; // day of W/E: 1 - Monday, 2 - Tuesday etc. variable - WeekStartsAt
  end;

	PErrorInfo	= ^TErrorInfo;
  TErrorInfo = record
    MCode	: integer; // no specific meaning so far
    SCode	: integer; // no specific meaning so far
    Msg		: string;	 // error message
  end;

  PAttToSave	= ^TAttToSave;
  TAttToSave	= record
    ATS_POID  		: integer;
    ATS_Prefix    : string;   // Org prefix
    // all field above is to be delete
    ATS_OrgID     : integer;  // Org prefix as integer
    ATS_POAttID   : integer;  // ID value from poatt field
    ATS_Name  		: string;  	// filename (editing/approving) of the attachment
    ATS_Stream		: TMemoryStream;
  end;

  PAttInfo	= ^TAttInfo;
  TAttInfo	= record
    FileName  : string;  	// either full name (submitting) or filename (editing/approving)
    FullName  : string;  	// either full name (submitting) or filename (editing/approving)
    Data      : TMemoryStream;
    state     : integer;  // 0 - not loaded, 1 - is being loaded, 2 - loaded, 3 - loading failed
//    DBID			: integer;  // index of attachment in the DB if DBID = 0 then it's not in the DB and was just loaded from local drive

    OrgID     : integer;  // Org prefix as integer
    POAttID   : integer;  // ID value from poatt field
    Stream		: TMemoryStream;
  end;

  PImageToPrint = ^TImageToPrint;
  TImageToPrint = record
  	ItemIsOK		: boolean;
    ImgName  		: string;  	// filename (editing/approving) of the attachment to be printed
//    Image				: TImage;
    ImStream		: TMemoryStream;
//    PrinterName	: string;
  end;

  // Recource data type
  PVTResourceData = ^TVTResourceData;
  TVTResourceData = record
    name      : string;         // "normal" title
    link      : string;         // link for the database
    descr     : string;         // some description / FPPriv container in Multi-Org mode (for the root org node)
    sub       : integer;
    level     : integer;
    balance   : extended;
    index     : integer;
    page			: integer;
    imindex		: integer;
    branch		: integer;
    alink			: string;
    fp1sum		: extended;       // it can be an amount allocated in FP in sections B-D minus section E(POs) (in FPAllocForm)
    prefix		: string;					// prefix for the tables in the multi-org versions
    ipref			: integer;
    arched 		: boolean;
{$IFDEF FAFH}
    fnd       : boolean;
{$ENDIF}
 {$IFDEF FCBF}
  	fldr			: boolean;
 {$ENDIF}
 end;

  PCreditData = ^TCreditData;
  TCreditData = record
    index     : integer;
    paydate   : TDate;
    summ      : extended;
    data      : string;
    closed    : extended;
  end;

  PIncData = ^TIncData;
  TIncData = record
    lastdate  : TDateTime;
    data      : string;
    in_       : Extended;
    link      : string;
    name      : string;
  end;

 PContrData = ^TContrData;
 TContrData = packed record
   Index  : integer;
   Status : byte;
//   Name   : string;
   Phone  : string;
   Person : string;
 end;

  PPOData = ^TPOData;
  TPOData = record
    index       : integer;
    Day         : TDateTime;
    Note				: string;
    re          : string;
    origin      : string;
    status      : string;
    FPNum       : integer;
    FondLink    : string;
    FondName    : string;
    FondBalance : Extended;
    SumA        : extended;
    Name        : string;
    Post        : string;
    bycash      : boolean;
    alink       : string;
  end;

{$IFDEF STATPROJ}
  TDates = array of TDate;

  POrgDates = ^TOrgDates;
  TOrgDates = record
	  FPDates   : TDates;
	  StatDates : TDates;
  end;
{$ENDIF}

var
  UTmpFolder : string;

  FPConnection    : TZConnection;
  FPMainDataset   : TZQuery;
  FPTmpDataset    : TZQuery;
  GFPHost : string;
  GFPUser : string;
  GFPPort : integer;
  GFPPwd  : string;
  GFPDb   : string;
  GFPProt : string;
  GFPHTTPPort : integer;
  GFPHTTPHost : string;

// Stats stuff
  FFirstChar    : Char; // first character in the editing window
  FLastKey      : Word; // contains last key that was pressed during editing of value
  CurNumOfWeeks : integer; // Number of weeks to display
  Dates         : array of TDateTime;
  WeekStartsAt  : integer;               // the beginning of the week-end
  MainPostID    : integer; // post id of the user logged on
  StatShowMode  : boolean; // показывает ГРАФИКИ статистик, а не грид
  NewStatWinX   : integer;
  NewStatWinY   : integer;


{$IFDEF TLOG}
  PTDBThread   : TPushToDBThread;
  DTLRS			 	 : TDateTime; 			// (D)ate-(T)ime of (L)ast (R)equest to (S)erver.
  llid				 : longint;					// (Last) (L)og (ID)
  LoadLogEvent : TEvent;          // event to pull the data from log table
{$ENDIF}

// Stats stuff - end of

  lFormatString	  : TFormatSettings;
  SQLFormatString	: TFormatSettings;

  FormatString  : TFormatSettings;
  FPNum         : integer;   // ??? - should it be GLOBAL?
{$IFDEF FPPROJ}
  FPUserID      : integer;
  FPLogin       : string;
  FPNameOfUser  : string;
{$ENDIF}
{$IFDEF STATPROJ}
	SUserID: Integer;
  // to be moved to the private section of the TSmallWin class
  arrOrgDates : array of POrgDates;
  arrOrgPfxs  : array of string;
  arrOrgs     : array of boolean;
  arrOrgsWEs  : array of integer;
  Vals   : array of extended;

{$ENDIF}

{$IFDEF STATPROJ}
  gStatsWeekly : boolean;
{$ENDIF}


  FPPostsArr    : array of string;

  ThSep         : char;   // delimeter for thousands in Currency transformation
  oid           : string;  // uid of the org - stored in connection.ini - unique for the org
  gHideArchedFunds: boolean; // flag to show/hide archived funds

  WorkingWithIni	: boolean;
  IniFile					: TIniFile;
  ConIniFile			: TIniFile;              // Connection ini file
  ConIniFileIsRO	: boolean;

  MaxFileSize			: integer;
  Clipboard				: TClipboard;

  ImgsToPrint			: TList;
  AttNeededEvent	: TEvent;									// special Attachment Needed (event)
  AttNeededCS			: TCriticalSection;				// special Attachment Needed (Critical Section)

  LoadingAttsCS		: TCriticalSection;				// loaded attachments list (Critical Section)
  LoadingAtts			: TList;

  AttAddedHDD			: TEvent;
  AttAddedHDDCS		: TCriticalSection;

  AttsToSave			: TList;									// List of attachments to be saved to DB
  AttSaveEvent		: TEvent;
  AttSaveCS				: TCriticalSection;

  AttsToRemove		: string;									// List of attachments to be removed from server
  AttRemoveEvent	: TEvent;
  AttRemoveCS			: TCriticalSection;

  UpdateEvent			: TEvent;
  UpdateCS				: TCriticalSection;

  LoadArchEvent		: TEvent;
  LoadArchCS 			: TCriticalSection;
  LoadArchFLink		: string;
  LoadArchPrefix	: string;

  FPLockEvent			: TEvent;

{$IFDEF FPPROJ}
  POLT            : TPOLockerThread;
  POLockEvent			: TEvent;
{$ENDIF}

  SSLDATAFOLDER   : string;
  APPDATAFOLDER		: string;
  USERTMPFOLDER		: string;      // to store downloaded attachements. USERTMPFOLDER=<TEMP | TMP system variable>\fp_<oid>\username
  cv              : string;                 // current version
  encconn         : boolean;
  MFPF            : TWinControl; //TComponent;

  GLogPulledDT    : TDateTime;

  cto							: integer;

  // resource loadable strings
	rsIncorrectData : string;
	rsIncorrectDataRcvd : string;
	rsSrvConnErr : string;
	rsConnSetupErr : string;
	rsFailedToGetStatValues : string;
	rsFailedToLoadStat : string;
	rsFailedToLoadStatList : string;
	rsFailedToLoadUngroupedStatList : string;
	rsFailedToLoadFPDates : string;
	rsFailedToLoadStatDates : string;
	rsFailedToSetupCodePage : string;
	rsFailedToLocateStatIC : string;
	rsFailedToCreateUser : string;
	rsFailedToInitUserInfo : string;
	rsFaileToUpdateUserInfo : string;
	rsFaileToDeleteUserInfo : string;
	rsFailedToStartTransation : string;
	rsFailedToCloseTransation : string;
	rsFailedToCreateNewPost : string;
	rsServerAnswerBelow : string;
	rsError : string;
	rsStatus : string;
	rsAddressToDevelopers : string;
	rsDataNotFound : string;
	rsCharsetSetUp : string;
	rsAuthorError : string;
	rsCheckLoginPwd : string;
	rsStatsUser : string;
	rsUser : string;
	rsAccessLevel : string;
	rsFull : string;
	rsTitle : string;
{$IFDEF MONTHLY}
  rsMonth  : string;
  rsMonths : string;
{$ELSE}
	rsWeek : string;
	rsWeeks : string;
{$ENDIF}
	rsSureToDeleteStat : string;
	rsSureToDeleteGroup : string;
	rsSureToDeleteUser : string;
	rsAllDataToDelete : string;
	rsStatsAndDataToSave : string;
	rsUserToRemoveTotally : string;
	rsUserDelete : string;
	rsUserImpossibleToDelete : string;
	rsUserPOsExist : string;
	rsUserToArchive : string;
	rsUserDataChange : string;
	rsUserSaveData : string;
	rsUserAccessSetupSchanged : string;
	rsUserPostNotFound : string;
	rsUserPostToAdd : string;
	rsPostNotFound : string;
	rsConfirmDelete : string;
	rsPostCreate : string;
	rsPostProperties : string;
	rsPostDelete : string;
	rsGroupCreate : string;
	rsGroupProperties : string;
	rsGroupDelete : string;
	rsStatProperties : string;
	rsErrInput : string;
	rsErrAtLeastOneDataNeeded : string;
	rsErrStartIsToBeLess : string;
	rsLowMarginIsLessThanHigh : string;
	rsHighMarginIsMoreThanLow : string;
	rsHntShowGraphs : string;
	rsHntValuesShow : string;
	rsHntValuesHide : string;
	rsSaveData : string;
	rsGroupStat : string;
	rsRead : string;
	rsWrite : string;
	rsToContinue : string;
	rsDataStructError : string;
  rsDataError       : string;
  rsCriticalError   : string;
  rsIncorrectGUIDError : string;
  rsCheckingForUpdates : string;
  rsConnectionError : string;
  rsUpdateError : string;
  rsDwldingUpdates : string;
  rsNoUpdates : string;
  rsFailedToLaunchFile : string;
  rsFile : string;
  rsUpdatesDownloaded : string;
  rsInstallingUpdates : string;
  rsUpdatesInstalled : string;
  rsRemovingTempFiles : string;
  rsDatesRangeError : string;
  rsDatesRangeErrorMessageTooShortPeriodMonthly : string;
  rsDatesRangeErrorMessageTooShortPeriodWeekly  : string;
  rsDatesRangeErrorMessageIncorrectRange : string;
  rsFPTrasferFromCashToBillOne : string;


function GetNextThursday(aCurDate:TDateTime):TDate;
function CreateUUID():string;
function  DayToStr(const SomeDay : TDateTime; Delimiter : string = '.') : string;
function  TranslitIt(const RussianString: string): string;
function  CompFondList(tablename : string; level : integer; AWithGroups : boolean; AConsiderApprovedPOs : boolean; APrefix : string; ASortAlpha : boolean = false; AIgnoreArched : boolean = true) : TList;
function  CompareDates(Item1, Item2: Pointer): Integer; overload;
function  CompareDates(Date1, Date2: TDateTime): Integer; overload;
procedure fond_update(flink : string; Balance : Extended);
procedure FillComboWithEntities(var ACombo : TComboBox; var AList : TList; AOrgPrefix : string; WithFndr : boolean);
procedure ListFilterOut(var AList : TList; AOrgPrefix : string; WithFndr : boolean);
//procedure LeaveFndrOnly(AList : TList; AOrgPrefix : string; WithFndr : boolean);
procedure LeaveCommonOnly(AList : TList; AOrgPrefix : string; WithFndr : boolean);


function  GetNameOfFondByLink(AList : TList; ALink : string) : string;
function  GetLinkOfFondByName(AList : TList; AName : string) : string;
function  GetAssetOfFundByName(AList : TList; AName : string) : string;

function  GetBalanceOfFondByLink(AList : TList; ALink : string) : extended;
function  GetBalanceOfFondByName(AList : TList; AName : string) : extended;

//procedure Cred_Calc(ToPayID : integer; ASum:extended; PONum : integer; ADate : string);
function  PrivPresentMO(AOrgAStr : string; APStr : string) : boolean;
procedure Debt_CalcMO(AOrgPrefix : string; ToCollectID : integer; ASum : extended; ADate : string);
procedure Cred_CalcMO(AOrgPrefix : string; ToPayID : integer; ASum:extended; PONum : integer; ADate : string);
function  IsIt(AArray: array of PVirtualNode; ANode: PVirtualNode): boolean;

function  GetDebtorStatusStr(AStatus : integer) : string;
function 	GetDebtorColor(AStatus : string) : TColor;
function  GetCreditorStatusStr(AStatus : integer) : string;
function 	GetCreditorColor(AStatus : string) : TColor;
function 	MinFloat(a, b: extended) : extended;
function 	MaxFloat(a, b: extended) : extended;
function 	MinInt(a, b: integer) : integer;
function 	MaxInt(a, b: integer) : integer;
function  MyFloatToStr(fFloat: extended): string;
function  MyCleanStr(AString	: string; CleanOutDots : boolean = true) : string;
function 	SetUpIniFile : boolean;
function 	ReadColWidth(ASection: string; ACol : integer; ADefaultWidth : integer) 	: integer;
function 	ReadIntParam(ASection: string; AParam : string; ADefaultValue : integer)	: integer;
procedure WriteIntParam(ASection: string; AParam : string; AValue : integer);
function 	GetWindowsFolder: String;
function 	GetShortFIO(LastName, FirstName, MiddleName : string): String;
function	GetRegistryIconHandle(FileName: string): HICON;
function 	MyGetFileSize(FileName: String): Integer;
function 	MyFirstLetterUp(AStr: String): string;
function 	GetPOStatusName(AID: integer): string;

function AssetsTransfer(AAFrom, AATo : string; ASum : extended; AReason: string; APrefix : string) : boolean; // true if successful
function GetAssetByFund(AFund : string; APrefix : string) : string;

procedure ShowError(AParent: TComponent; ATitle: string; AErrorCode : integer; AStatus : string; AMessage : string);
procedure GetMaxFileSize;

procedure SetUpEncryption(var AConn: TZConnection);
function CheckAndReconnect(var AConn: TZConnection; AAddConf : boolean = true): boolean;
{$IFDEF RWLO}
procedure CheckParamsAndHalt;
{$ENDIF}
function GetVersion(sFileName:string): string;

{$IFDEF TLOG}
procedure AddToLog(acode : integer; atype	: integer; adata	: string; asrc	: string = '');
{$ENDIF}

procedure SetCommaAsDecimalSeparator;

//
// Stats stuff
//
//function GetNextWE(SomeDay : TDateTime): TDateTime;
procedure PrintGraphic(APrinter: TPrinter; AGraphic : TGraphic);
function  DeleteStatValueFromDB(var Query: TZQuery; StatID : integer; DateOfValue: TDate):boolean;
function  StatValueToDB(var Query: TZQuery; AStatID : integer; DateOfValue: TDate; Value: Extended):boolean;
{$IFDEF STATPROJ}
function  GetNextWEDay(SomeDay : TDateTime; WeekEndDay : integer = 4): TDateTime;
function  GetPrevWEDay(SomeDay : TDateTime; WeekEndDay : integer = 4): TDateTime;
function  IsAWEDay(SomeDay : TDateTime; WeekEndDay : integer = 4): boolean;
//function  GetFirstDayOfWeek(SomeDay : TDateTime): TDateTime;
{$ENDIF}

procedure LoadResourceStrings(wLang : LangID);

implementation

uses
	ErrorWindow,
{$IFDEF FPPROJ}
  FilterNumbersWindow, // for FilterNumbersForm
	FilterStringWindow,  // for FilterStringForm
	FilterFloatsWindow,  // for FilterFloatsForm
	FilterDatesWindow,   // for FilterDatesForm
{$ENDIF}
  ZDbcIntfs,
  Types,               // for TValueRelationship
  StrUtils;

{$IFDEF TLOG}
procedure AddToLog(acode : integer; atype	: integer; adata	: string; asrc	: string = '');
var
	NewLogLine : PLogInfo;
begin
	New(NewLogLine);
  NewLogLine^.ldt 	:= now;
  NewLogLine^.lcode := acode;
  NewLogLine^.ltype := atype;
  NewLogLine^.ldata := adata;
  NewLogLine^.lsrc  := asrc;

  PushToDBCS.Enter;
  PTDBThread.ToLog.Add(NewLogLine);
  PushToDBCS.Leave;
  PushToDBEvent.SetEvent;
end;
{$ENDIF}

function CheckAndReconnect(var AConn: TZConnection; AAddConf : boolean = true): boolean;
var
	NoError : boolean;
begin

	try
    NoError := AConn.PingServer;
  finally

  end;

  if NoError then begin
    Result := true;
    Exit;
  end
  else begin
    NoError := true;
    try
	    SetUpEncryption(AConn);
      AConn.ClientCodepage := rsCharsetSetUp;
		  AConn.Reconnect;
      if AAddConf then begin
//		    FPMainDataset.SQL.Text := 'SET CHARSET ' + rsCharsetSetUp;
		    FPMainDataset.SQL.Text := 'SET CHARSET cp1251';
  		  FPMainDataset.ExecSQL;

	  	  FPMainDataset.SQL.Text := 'SET old_passwords=FALSE';
  	  	FPMainDataset.ExecSQL;
      end;
    except
      NoError := false;
    end;
  end;
  Result := NoError;
end;

procedure SetUpEncryption(var AConn: TZConnection);
begin
{$IFDEF TLOG}
  {$I SetUpEncryption.inc}
{$ELSE}
  if EncConn then begin
    AConn.Properties.Values['MYSQL_SSL']      := 'TRUE';
    AConn.Properties.Values['MYSQL_SSL_KEY']  := SSLDATAFOLDER + 'client-key.pem';
    AConn.Properties.Values['MYSQL_SSL_CERT'] := SSLDATAFOLDER + 'client-cert.pem';
    AConn.Properties.Values['MYSQL_SSL_CA']   := SSLDATAFOLDER + 'ca-cert.pem';
  end;
{$ENDIF}
end;

{$IFDEF RWLO}
procedure CheckParamsAndHalt;
begin
  if ParamCount < 2 then Halt;
end;
{$ENDIF}

function GetPOStatusName(AID: integer): string;
begin
  Result := 'Неизвестно';
  if AID = PO_SUBMITTED_UGNT then
    result := 'Заявка подана (срочная)'
  else if AID = PO_SUBMITTED then
    result := 'Заявка подана'
  else if AID = PO_REJECTED then
    result := 'Заявка отклонена'
  else if AID = PO_APROVED then
    result := 'Заявка одобрена'
  else if AID = PO_PAID then
    result := 'Заявка оплачена'
  else if AID = PO_APROVED_UGNT then
    result := 'Заявка одобрена (срочная)'
  else if AID = PO_PAID_UGNT then
    result := 'Заявка оплачена (срочная)';
end;

function GetAssetByFund(AFund : string; APrefix : string) : string;
//var
//  al : string;
begin
  FPMainDataset.SQL.Text := 'SELECT assetlink FROM`' + APrefix + 'fundsvsassets`WHERE`fundlink`=:fFL LIMIT 1';
  FPMainDataset.ParamByName('fFL').AsString := AFund;
  try
    // pulling last balance from the asset/fond table
    FPMainDataset.Open;
    Result := FPMainDataset.FieldByName('assetlink').AsString;
  except
    on e: EZSQLException do begin
	    ShowError(Application.MainForm, 'Невозможно получить данные об активе.', e.ErrorCode, e.StatusCode, e.Message);
      Result := '';
    end;
  end; // try
//  Result := al;
end;

function AssetsTransfer(AAFrom, AATo : string; ASum : extended; AReason: string; APrefix : string) : boolean;
var
  NoError     : boolean;
  TmpBalance  : extended;
  //i           : integer;
begin
  NoError := true;

  if NoError then begin
	  FPMainDataset.SQL.Text := 'SELECT balance FROM`' + AAFrom + '`WHERE`index`>1 ORDER BY`index`DESC LIMIT 1';
    try
    	// pulling last balance from the asset/fond table
      FPMainDataset.Open;
      TmpBalance := FPMainDataset.FieldByName('balance').AsExtended;

  	  TmpBalance := TmpBalance - ASum;
      if (AAFrom = APrefix + CASH_LINK) or (AAFrom = APrefix + BILL1_LINK) then begin
		  	FPMainDataset.SQL.Text := 'INSERT INTO`' + AAFrom + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`amount`,`price`,`data`,`in`,`out`,`incsrcid`,`pct`';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fReason,0,:fBalance,Now(),0,0,:fDescr,0,:fSum,0,0';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      end
      else begin
	  	  FPMainDataset.SQL.Text := 'INSERT INTO`' + AAFrom + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fReason,0,:fBalance,Now(),:fDescr,0,:fSum';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      end;
    	FPMainDataset.ParamByName('fReason').AsString := 'transfer';
	    FPMainDataset.ParamByName('fBalance').AsFloat := TmpBalance;
  	  FPMainDataset.ParamByName('fDescr').AsString  := AReason;
  	  FPMainDataset.ParamByName('fSum').AsFloat     := ASum;
{$IFDEF USERID}
      FPMainDataset.ParamByName('fUserID').AsInteger:= FPUserID;
{$ENDIF}
    	FPMainDataset.ExecSQL;
	    fond_update(AAFrom, TmpBalance);

      // updating TO asset
	    FPMainDataset.SQL.Text := 'SELECT balance FROM`' + AATo + '`WHERE`index`>1 ORDER BY`index`DESC LIMIT 1';
      FPMainDataset.Open;
      TmpBalance := FPMainDataset.FieldByName('balance').AsExtended;

	    TmpBalance := TmpBalance + ASum;

      if (AATo = APrefix + CASH_LINK) or (AATo = APrefix + BILL1_LINK) then begin
	  		FPMainDataset.SQL.Text := 'INSERT INTO`' + AATo + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`amount`,`price`,`data`,`in`,`out`,`incsrcid`,`pct`';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fReason,0,:fBalance,Now(),0,0,:fDescr,:fSum,0,0,0';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      end
      else begin
	    	FPMainDataset.SQL.Text := 'INSERT INTO`' + AATo + '`(`index`,`name`,`page`,`link`,`sub`,`balance`,`lastdate`,`data`,`in`,`out`';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',`UserID`';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(NULL,NULL,0,:fReason,0,:fBalance,Now(),:fDescr,:fSum,0';
{$IFDEF USERID}
      	FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',:fUserID';
{$ENDIF}
        FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ')';
      end;
    	FPMainDataset.ParamByName('fReason').AsString := 'transfer';
	    FPMainDataset.ParamByName('fBalance').AsFloat := TmpBalance;
  	  FPMainDataset.ParamByName('fDescr').AsString  := AReason;
  	  FPMainDataset.ParamByName('fSum').AsFloat     := ASum;
{$IFDEF USERID}
      FPMainDataset.ParamByName('fUserID').AsInteger:= FPUserID;
{$ENDIF}
    	FPMainDataset.ExecSQL;
	    fond_update(AATo, TmpBalance);
    except
   	  on e: EZSQLException do begin
	      ShowError(Application.MainForm, 'Во время обновления данных произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
        NoError := false;
 	    end;
    end; // try
  end;
  Result := NoError;
end;

function 	MyFirstLetterUp(AStr: String): string;
begin
  Result := AnsiUpperCase(LeftStr(AStr, 1)) + MidStr(AStr, 2, Length(AStr) - 1);
end;

procedure GetMaxFileSize;
begin
	FPMainDataset.SQL.Text := 'SHOW VARIABLES LIKE "max_allowed_packet"';
  FPMainDataset.Open;
  MaxFileSize := (MinInt(2 * 1024 * 1024, FPMainDataset.FieldByName('Value').AsInteger) * 8) div 10;
end;

procedure ShowError(AParent: TComponent; ATitle: string; AErrorCode : integer; AStatus : string; AMessage : string);
begin
	ErrorForm := TErrorForm.Create(AParent);
  ErrorForm.ErrorExplanationMemo.Text := ATitle;
  ErrorForm.ErrorMemo.Text	 					:= '';
  // send message to reconnect
  if (AErrorCode = 1053) or (AErrorCode = 2006) then begin
    SendMessage(MFPF.Handle, UM_RECONNECTNEEDED, 0, 0);
  end;

  if AErrorCode <> 0 then
	  ErrorForm.ErrorMemo.Text := rsError + ' ' + IntToStr(AErrorCode) + ', ';
  if AStatus <> '' then
  	ErrorForm.ErrorMemo.Text := ErrorForm.ErrorMemo.Text + rsStatus + ' ' + AStatus + ', ';
  ErrorForm.ErrorMemo.Text := ErrorForm.ErrorMemo.Text + AMessage;
  ErrorForm.ShowModal;
  ErrorForm.Free;
end;

function MyGetFileSize(FileName: String): Integer;
var
  FS: TFileStream;
begin
  Result := 0;
  FS     := nil;
  try
    FS := TFileStream.Create(Filename, fmOpenRead);
  except
    Result := -1;
  end;

  if Result <> -1 then
  	Result := FS.Size;
  FS.Free;
end;

function GetRegistryIconHandle(FileName: string): HICON;
var
  R: TRegistry;
  Alias, 								//псевдвним для расширения в реестре
  IconPath: string;			//путь для файла с иконкой
  IconNum,							//номер иконки в файле
  QPos: Integer;				//позиция запятой в записи реестра
  TmphIcon : hIcon;
  FileExt   : string;
begin
  IconNum := 0;
  TmphIcon := 0;
  FileExt := ExtractFileExt(FileName);
  if UpperCase(FileExt) = '.EXE' then FileExt := '.com';

  R := TRegistry.Create;
  try
    R.RootKey := HKEY_CLASSES_ROOT;

    //чтение псевданима
    if R.OpenKey('\' + FileExt, True) then Alias := R.ReadString('');
    R.CloseKey;

    //чтение записи об иконке
    if R.OpenKey('\' + Alias + '\DefaultIcon', True) then IconPath := R.ReadString('');
    R.CloseKey;

    //поиск запятой
    QPos := Pos(',', IconPath);

    //чтение номера иконки в файле если она имеется
    if QPos <> 0 then begin
      IconNum := StrToInt(Copy(IconPath, QPos + 1, 4));
      IconPath := Copy(IconPath, 1, QPos - 1)
    end;
  finally
    R.Free;
  end;
  TmphIcon := ExtractIcon(hInstance, PChar(IconPath), IconNum);
// added by me for defaul files
  if (TmphIcon = 0) then begin
    IconNum := -223;
    IconPath := '%SystemRoot%\System32\Shell32.dll';
    TmphIcon := ExtractIcon(hInstance, PChar(IconPath), IconNum);
  end;
  Result := TmphIcon;
end;

function GetShortFIO(LastName, FirstName, MiddleName: string): String;
begin
	Result := LastName;
  if FirstName <> '' then begin
  	Result := Result + ' ' + LeftStr(FirstName, 1) + '.';
    if MiddleName <> '' then
	  	Result := Result + ' ' + LeftStr(MiddleName, 1) + '.';
	end;
end;

function GetWindowsFolder: String;
var
	p:PChar;
begin
	GetMem(p, MAX_PATH);
	Result	:=	'';
	if GetWindowsDirectory(p, MAX_PATH)>0 then
  	Result	:= String(p);
	FreeMem(p)
end;

procedure WriteIntParam(ASection: string; AParam : string; AValue : integer);
begin
  if WorkingWithIni then begin
    try
	  	IniFile.WriteInteger(ASection, AParam, AValue);
    finally

    end;
  end;
end;

function ReadIntParam(ASection: string; AParam : string; ADefaultValue : integer) : integer;
var
  MyDefValue : integer;
begin
	MyDefValue	:= ADefaultValue;
  if WorkingWithIni then begin
		MyDefValue := Inifile.ReadInteger(ASection, AParam, MyDefValue);
  	IniFile.WriteInteger(ASection, AParam, MyDefValue);
  end;
  Result := MyDefValue;
end;

function ReadColWidth(ASection: string; ACol : integer; ADefaultWidth : integer) : integer;
var
  MyColWidth : integer;
begin
	MyColWidth := ADefaultWidth;
  if WorkingWithIni then begin
		MyColWidth := Inifile.ReadInteger(ASection, 'C' + IntToStr(ACol), MyColWidth);
  	IniFile.WriteInteger(ASection, 'C' + IntToStr(ACol), MyColWidth);
  end;
  Result := MyColWidth;
end;

function SetUpIniFile : boolean;
var
	UserAppsFolder 	: String;
  FileHandle			: integer;
  IniFileName			: string;
  ThisAppfolder 	: string;
begin
	UserAppsFolder := GetEnvironmentVariable('APPDATA');
  ThisAppFolder	:= UserAppsFolder + '\' + AppName;
  APPDATAFOLDER := ThisAppFolder;
  if not DirectoryExists(ThisAppFolder) then begin
    if not CreateDir(ThisAppFolder) then begin
    	Result := false;
      Exit;
    end;
  end;

  IniFileName := ThisAppFolder + '\fp.ini';

  if not FileExists(IniFileName) then begin
		FileHandle := FileCreate(IniFileName);
  	if  FileHandle = -1 then begin
      Result := false;
      Exit;
    end
    else
      FileClose(FileHandle);
  end;
	IniFile := TIniFile.Create(IniFileName);
 	Result := Assigned(IniFile);

	IniFileName := ExtractFilePath(Application.ExeName) + '\connection.ini';

  try
    ConIniFile	:= TIniFile.Create(IniFileName);
  except
  	on E : EIniFileException do begin
    	ConIniFileIsRO := true;
//      ShowMessage(E.Message);
    end;
  end;
  oid := ConIniFile.ReadString('General', 'uid', '');
  gHideArchedFunds := IniFile.ReadBool('General', 'HideArchedFunds', false);

end;

function MyCleanStr(AString : string; CleanOutDots : boolean = true) : string;
begin
	Result := Trim(ReplaceStr(ReplaceStr(AString,	ThSep,	''), '<br>', CRLF));
  if CleanOutDots then
		Result := ReplaceStr(Result, '.',	',')
end;

function MyFloatToStr(fFloat: extended): string;
begin
  Result := FloatToStrF(fFloat, ffCurrency, 20, 2, FormatString);
end;

function 	MinFloat(a, b: extended) : extended;
begin
	if a > b then Result := b else Result := a;
end;

function 	MaxFloat(a, b: extended) : extended;
begin
  if a < b then Result := b else Result := a;
end;

function 	MaxInt(a, b: integer) : integer;
begin
  if a < b then Result := b else Result := a;
end;

function 	MinInt(a, b: integer) : integer;
begin
  if a > b then Result := b else Result := a;
end;

function GetCreditorStatusStr(AStatus : integer) : string;
begin
	case AStatus of
  	1 : Result := 'Обычный';
  	2 : Result := 'Беспокойный';
  	3 : Result := 'Опасный';
	else
  	Result := 'Новый'
  end;
end;

function GetCreditorColor(AStatus : string) : TColor;
begin
  if AStatus = 'Обычный' then
  	Result := TColor($48974F) // clGreen
  else if AStatus = 'Беспокойный' then
  	Result := clYellow
  else if AStatus = 'Опасный' then
  	Result := clRed
	else
  	Result := clSpecBkColor;
end;

function GetDebtorStatusStr(AStatus : integer) : string;
begin
	case AStatus of
  	1 : Result := 'Надежный';
  	2 : Result := 'Задерживает';
  	3 : Result := 'Опасный';
	else
  	Result := 'Новый'
  end;
end;

function 	GetDebtorColor(AStatus : string) : TColor;
begin
  if AStatus = 'Надежный' then
  	Result := TColor($48974F) // clGreen
  else if AStatus = 'Задерживает' then
  	Result := clYellow
  else if AStatus = 'Опасный' then
  	Result := clRed
	else
  	Result := clSpecBkColor;
end;

function  PrivPresentMO(AOrgAStr : string; APStr : string) : boolean;
var
  i : integer;
begin
  i := 1;
  Result := false;
  while (i <= Length(APStr)) and (not Result) do begin
    Result := Pos(APStr[i], AOrgAStr) > 0;
    Inc(i);
  end;
end;

function  IsIt(AArray: array of PVirtualNode; ANode: PVirtualNode): boolean;
var
	i	: integer;
begin
  for i := 0 to Length(AArray) - 1 do begin
  	if pointer(AArray[i]) = pointer(ANode) then begin
      Result := true;
      Exit;
    end;
  end;
  Result := false;
end;

function GetBalanceOfFondByLink(AList : TList; ALink : string) : extended;
var
  i : integer;
begin
  Result := 0;
  for i := 0 to AList.Count - 1 do
    if	PVTResourceData(AList[i]).link = ALink then begin
      Result := PVTResourceData(AList[i]).balance;
      break;
    end;
end;

function GetNameOfFondByLink(AList : TList; ALink : string) : string;
var
  i : integer;
begin
//  Result := 'Из расходов';
  Result := '';
  if AList = nil then exit;

  for i := 0 to AList.Count - 1 do begin
    if   PVTResourceData(AList[i]).link = ALink then begin
      Result := PVTResourceData(AList[i]).name;
      break;
    end;
  end;
end;

function GetBalanceOfFondByName(AList : TList; AName : string) : extended;
var
  i : integer;
begin
  Result := 0;
  for i := 0 to AList.Count - 1 do
    if PVTResourceData(AList[i]).Name = AName then begin
      Result := PVTResourceData(AList[i]).balance;
      break;
    end;
end;

function GetLinkOfFondByName(AList : TList; AName : string) : string;
var
  i : integer;
begin
  Result := '';
  for i := 0 to AList.Count - 1 do
    if PVTResourceData(AList[i]).Name = AName then begin
      Result := PVTResourceData(AList[i]).Link;
      break;
    end;
end;

function GetAssetOfFundByName(AList : TList; AName : string) : string;
var
  i : integer;
begin
  Result := '';
  for i := 0 to AList.Count - 1 do
    if PVTResourceData(AList[i]).Name = AName then begin
      Result := PVTResourceData(AList[i]).alink;
      break;
    end;
end;

procedure Cred_CalcMO(AOrgPrefix : string; ToPayID : integer; ASum:extended; PONum : integer; ADate : string);
Var
  CredData  : string;
  SumToPay  : extended;
  SumClosed : extended;
  SumDiffer : extended;
  ToCollectStr : string;

begin
  ToCollectStr := AOrgPrefix + 'topay';

  FPMainDataset.SQL.Text := 'SELECT `data`,`summ`,`closed` FROM`' + ToCollectStr + '`WHERE `index`=' + IntToStr(ToPayID);
  FPMainDataset.Open;
  if FPMainDataset.RecordCount <> 1 then begin
    Application.MessageBox(PWideChar(rsDataStructError), PWideChar(rsDataError), MB_OK or MB_ICONERROR);
    Exit;
  end;

  CredData  := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', Chr(13));
  SumToPay  := FPMainDataset.FieldByName('summ').AsExtended;
  SumClosed := FPMainDataset.FieldByName('closed').AsExtended;

  SumDiffer := SumToPay - SumClosed - ASum;
  if SumDiffer > 0  then begin
    CredData := CredData + Chr(13) + ADate + ' оплачено ' + FloatToStr(ASum) + ' по заявке № ' + IntToStr(PONum);
    FPMainDataset.SQL.Text := 'UPDATE`' + ToCollectStr + '`SET `data`=:fCredData,`closed`=:fClosed WHERE `index`=' + IntToStr(ToPayID);
		FPMainDataset.ParamByName('fCredData').AsString := ReplaceStr((CredData), Chr(13), '<br>');
    FPMainDataset.ParamByName('fClosed').AsFloat    := SumClosed + ASum;
    FPMainDataset.ExecSQL;
  end
  else if SumDiffer = 0 then begin
    CredData := CredData + Chr(13) + ADate + ' оплачено ' + FloatToStr(ASum) + ' по заявке № ' + IntToStr(PONum) + Chr(13) + '<b>Обязательство закрыто</b>';
    FPMainDataset.SQL.Text := 'UPDATE`' + ToCollectStr + '`SET `data`=:fCredData,`closed`=-1,`status`="2" WHERE `index`=' + IntToStr(ToPayID);
		FPMainDataset.ParamByName('fCredData').AsString := ReplaceStr((CredData), Chr(13), '<br>');
    FPMainDataset.ExecSQL;
  end;
end;

procedure debt_calcMO(AOrgPrefix : string; ToCollectID : integer; ASum:extended; ADate : string);
Var
  DebtData  : string;
  SumToColl : extended;
  SumClosed : extended;
  SumDiffer : extended;
  ToCollectStr : string;
begin
  ToCollectStr := AOrgPrefix + 'tocollect';
  FPMainDataset.SQL.Text := 'SELECT `data`,`summ`,`closed` FROM ' + ToCollectStr + ' WHERE `index`=' + IntToStr(ToCollectID);
  FPMainDataset.Open;
  if FPMainDataset.RecordCount <> 1 then begin
    Application.MessageBox('Структура базы некорректна. Обратитесь к разработчикам.', 'Ошибка в данных', MB_OK or MB_ICONERROR);
    Exit;
  end;

  DebtData  := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', Chr(13));
  SumToColl := FPMainDataset.FieldByName('summ').AsExtended;
  SumClosed := FPMainDataset.FieldByName('closed').AsExtended;

  SumDiffer := SumToColl - SumClosed - ASum;
  if SumDiffer > 0  then begin
    DebtData := DebtData + Chr(13) + ' ' + ADate + ' получена оплата: ' + FloatToStr(ASum);
    FPMainDataset.SQL.Text := 'UPDATE ' + ToCollectStr + ' SET `data`=:fDebtData,`closed`=:fClosed WHERE `index`=' + IntToStr(ToCollectID);
		FPMainDataset.ParamByName('fDebtData').AsString := ReplaceStr((DebtData), Chr(13), '<br>');
    FPMainDataset.ParamByName('fClosed').AsFloat    := SumClosed + ASum;
    FPMainDataset.ExecSQL;
  end
  else if SumDiffer = 0 then begin
    DebtData := DebtData + Chr(13) + ' ' + ADate + ' получена оплата: ' + FloatToStr(ASum) + '.' + Chr(13) + '<b>Обязательство закрыто</b>';
    FPMainDataset.SQL.Text := 'UPDATE ' + ToCollectStr + ' SET `data`=:fDebtData,`closed`=-1,`status`="2" WHERE `index`=' + IntToStr(ToCollectID);
		FPMainDataset.ParamByName('fDebtData').AsString := ReplaceStr((DebtData), Chr(13), '<br>');
    FPMainDataset.ExecSQL;
  end;
end;

function GetNextThursday(aCurDate:TDateTime):TDate;
var
  dow : integer; // 1 - Sunday; 2 - Monday... 7 - Saturday
  tdt : TDateTime;
begin
  dow := DayOfWeek(aCurDate);
  if dow = 5 then begin // 5 - Thursday
    tdt := EncodeDateTime(YearOf(aCurDate), MonthOf(aCurDate), DayOf(aCurDate), 14, 0,0,0);
    if CompareDateTime(aCurDate, tdt) = GreaterThanValue then begin
      Result := EncodeDate(YearOf(aCurDate), MonthOf(aCurDate), DayOf(aCurDate)) + 7;
    end
    else begin
      Result := EncodeDate(YearOf(aCurDate), MonthOf(aCurDate), DayOf(aCurDate));
    end;
  end
  else begin
    tdt := aCurDate;
    while DayOfWeek(tdt) <> 5 do tdt := tdt + 1;
    Result := EncodeDate(YearOf(tdt), MonthOf(tdt), DayOf(tdt));
  end;
end;

function CreateUUID:string;
var
  Uid: TGuid;
  Res: HResult;
begin
  Res := CreateGuid(Uid);
  if Res = S_OK then begin
     Result := GuidToString(Uid);
  end
  else begin
     Result := '';
  end;
end;

function DayToStr(const SomeDay : TDateTime; Delimiter : string = '.') : string;
var
  Year, Month, Day : word;
  StrDate : string;
begin
  DecodeDate(SomeDay, Year, Month, Day);
  if Day < 10 then StrDate := '0';
  StrDate := StrDate + IntToStr(Day) + Delimiter;
  if Month < 10 then StrDate := StrDate + '0';
  StrDate := StrDate + IntToStr(Month)+ Delimiter;
  if Year mod 100 < 10 then StrDate := StrDate + '0';
  Result := StrDate + IntToStr(Year mod 100);
end;

Function TranslitIt(const RussianString: string): string;
const
  RussAlph  : string =('абвгдеёжзийклмнопрстуфхцчшщъыьэюя№');
  EngAlph   : string =('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');
  TransAlph : array[1..34] of String = ('a', 'b', 'v', 'g', 'd', 'e', 'ho', 'hz', 'z' , 'i', 'j', 'k',
                                        'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f', 'hk', 'c', 'hc', 'hs', 'hx',
                                        'q', 'y', 'hq', 'he', 'hu', 'ha', 'hn');
var
  i:  integer;
  j:  integer;
  TmpStr : string;
begin
  TmpStr := AnsiLowerCase(RussianString);
  Result := '';
  for I := 1 to Length(TmpStr) do begin
    j := pos(TmpStr[i], RussAlph);
    if j > 0 then
      Result := Result + TransAlph[j]
    else begin
      j := pos(TmpStr[i], EngAlph);
      if j > 0 then
        Result := Result + EngAlph[j]
      else
        Result := Result + '_' + IntToStr(Ord(TmpStr[i]));
    end;
  end;
end;

function  CompFondList(tablename : string; level : integer; AWithGroups : boolean; AConsiderApprovedPOs : boolean; APrefix : string; ASortAlpha : boolean = false; AIgnoreArched : boolean = true) : TList;
var
  T_Dataset    : TZQuery;
  T_TmpDataset : TZQuery;
  tmpstr : string;
  TmpList : TList;
  ResData : PVTResourceData;
  TmpList1 : TList;
  POSum : extended;
  i			: integer;
{$IFDEF FAFH}
  tmpstrf : string;
  tmpstrb : string;
{$ENDIF}
begin
  if FPConnection = nil then begin
    result := nil;
    exit;
  end;
  TmpList := TList.Create;

  T_TmpDataset := TZQuery.Create(nil);
  T_TmpDataset.Connection := FPConnection;

  T_Dataset    := TZQuery.Create(nil);
  T_Dataset.Connection := FPConnection;
	T_Dataset.SQL.Text   := 'SELECT `index`,name,link,sub,balance,assetlink';
{$IFDEF FAFH}
  tmpstrb := APrefix + 'bank';
  tmpstrf := APrefix + 'fond';
	if (tablename = tmpstrf) or (tablename = tmpstrb) then
	  T_Dataset.SQL.Text := T_Dataset.SQL.Text + ',fnd';
{$ENDIF}

	T_Dataset.SQL.Text := T_Dataset.SQL.Text + ' FROM ' + tablename + ' LEFT JOIN ' + APrefix + 'fundsvsassets ON link=fundlink';

  tmpstr := APrefix + 'fond';
	i := Length(tmpstr);
	if AIgnoreArched and (LeftStr(tablename, i) = tmpstr) then
	  T_Dataset.SQL.Text   := T_Dataset.SQL.Text + ' WHERE arched=0';

	if ASortAlpha then
	  T_Dataset.SQL.Text   := T_Dataset.SQL.Text + ' ORDER BY`name`';

  T_Dataset.Open;

  while not T_Dataset.Eof do begin
    //tmpstr := T_Dataset.FieldByName('name').AsString;
    tmpstr := Trim(T_Dataset.FieldByName('name').AsAnsiString);
    if not (AnsiLeftStr(tmpstr, 2) = '<<') then begin
      if AWithGroups or ((not AWithGroups) and (T_Dataset.FieldByName('sub').AsInteger = 0))then begin
        POSum := 0;
        New(ResData);
        ResData.name    := tmpstr;
        ResData.index   := T_Dataset.FieldByName('index').AsInteger;
        ResData.link    := Trim(T_Dataset.FieldByName('link').AsAnsiString);
        ResData.sub     := T_Dataset.FieldByName('sub').AsInteger;
        ResData.alink   := Trim(T_Dataset.FieldByName('assetlink').AsAnsiString);
        ResData.level   := level;
        ResData.fp1sum  := 0;
{$IFDEF FAFH}
      	if (tablename = tmpstrf) or (tablename = tmpstrb) then
          ResData.fnd := boolean(T_Dataset.FieldByName('fnd').AsInteger);
{$ENDIF}
        if AConsiderApprovedPOs then begin
          POSum := 0;

          T_TmpDataset.SQL.Text := 'SELECT SUM(suma)AS tota FROM`' + APrefix + 'po`WHERE status IN(2,4)AND fond=:fFundLink GROUP BY fond';
          T_TmpDAtaset.ParamByName('fFundLink').AsString := ResData.link;
          try
            T_TmpDataset.Open;
            POSum := T_TmpDataset.FieldByName('tota').AsExtended;
            T_TmpDataset.Close;
          except

          end;
        end;
        ResData.balance := T_Dataset.FieldByName('balance').AsExtended - POSum;
        TmpList.Add(ResData);
      end;
      if T_Dataset.FieldByName('sub').AsInteger = 1 then begin
        TmpList1 := CompFondList(T_Dataset.FieldByName('link').AsString, level + 1, AWithGroups, AConsiderApprovedPOs, APrefix, ASortAlpha);
        TmpList.Assign(TmpList1, laOr);
      end;
    end; // if not (AnsiLeftStr(tmpstr, 2) = '<<')
    T_Dataset.Next;
  end;
  T_Dataset.Close;
  T_Dataset.Free;

  T_TmpDataset.Close;
  T_TmpDataset.Free;
  Result := TmpList;
end;

function CompareDates(Item1, Item2: Pointer): Integer;
begin
  if PIncData(Item1).lastdate > PIncData(Item2).lastdate then
    Result := 1
  else if PIncData(Item2).lastdate > PIncData(Item1).lastdate then
    Result := -1
  else
    Result := 0;
end;

function CompareDates(Date1, Date2: TDateTime): Integer;
begin
  if Date1 > Date2 then
    Result := 1
  else if Date2 > Date1 then
    Result := -1
  else
    Result := 0;
end;

procedure fond_update(flink : string; Balance : Extended);
var
  TmpSqlStr : string;
  link : string;
  link1 : string;
  TotBalance : Extended;
begin
///  FPMainDataset.Close;
  FPMainDataset.SQL.Text := 'SELECT link FROM ' + flink + ' ORDER BY `index` LIMIT 1';
  FPMainDataset.Open;
  if FPMainDataset.RecordCount > 0 then begin
    link  := FPMainDataset.FieldByName('link').AsString;
///    FPMainDataset.Close;
//    TmpSqlStr := 'UPDATE ' + link + ' SET balance =' + FloatToStr(balance) + ' WHERE link ="' +  flink + '" LIMIT 1';
//    TmpSqlStr := 'UPDATE ' + link + ' SET balance =' + FloatToStr(balance) + ' WHERE link ="' +  flink + '" LIMIT 1';
//    FPMainDataset.SQL.Text := TmpSqlStr;
    FPMainDataset.SQL.Text :=  'UPDATE ' + link + ' SET balance=:fBalance WHERE link ="' +  flink + '"';
    FPMainDataset.ParamByName('fBalance').AsFloat := balance;
    FPMainDataset.ExecSQL;
    TmpSqlStr := 'SELECT link FROM ' + link + ' ORDER BY `index` LIMIT 1';
    FPMainDataset.SQL.Text := TmpSqlStr;
    FPMainDataset.Open;
    if FPMainDataset.RecordCount > 0 then begin
      link1 := FPMainDataset.FieldByName('link').AsString;
    	if(link1 <> 'root') then begin
        FPMainDataset.SQL.Text := 'SELECT balance FROM ' + link;
        FPMainDataset.Open;
        FPMainDataset.First;
        TotBalance := 0;
        while not FPMainDataset.Eof do begin
          TotBalance := TotBalance + FPMainDataset.FieldByName('balance').AsExtended;
          FPMainDataset.Next;
        end;
        fond_update(link, TotBalance);
      end;
    end;
  end;
end;

procedure SetCommaAsDecimalSeparator;
 var
   DefLCID: LCID;
//   Buffer: PChar;
 begin
   Application.UpdateFormatSettings := True;
   DefLCID := GetThreadLocale;
   if SetLocaleInfo(DefLCID, LOCALE_SDecimal, ',') then begin
    try
     FormatSettings.DecimalSeparator := ',';
    finally

    end;
   end;
   Application.UpdateFormatSettings := False;
 end;

//function GetNextWE(SomeDay : TDateTime): TDateTime;
//begin
//  while DayOfWeek(SomeDay) <> 5 do
//  	SomeDay := SomeDay + 1;
//  Result := SomeDay;
//end;

procedure PrintGraphic(APrinter: TPrinter; AGraphic : TGraphic);
var
  IRatio	 : extended;
  IWidth	 : integer;
  IHeight	 : integer;

  PRatio	 : extended;
  PWidth	 : integer;
  PHeight	 : integer;
  PRect		 : TRect;
begin

	APrinter.BeginDoc;

	IHeight	:= AGraphic.Height;
  IWidth	:= AGraphic.Width;
  IRatio := (IWidth * 1.0) / (IHeight * 1.0);

  PWidth 	:= APrinter.Canvas.ClipRect.Right	 - APrinter.Canvas.ClipRect.Left;
  PHeight	:= APrinter.Canvas.ClipRect.Bottom - APrinter.Canvas.ClipRect.Top;
  PRatio := (PWidth * 1.0) / (PHeight * 1.0);

  if PRatio < 1 then begin // printer in portrait
  	if IRatio < 1 then begin 					// image is portrait
    	if PRatio < IRatio then begin   // image is "thicker" than printer
      	PRect.Left		:= 0;
        PRect.Right		:= PWidth;
        PRect.Top			:= (PHeight - trunc(PWidth / IRatio)) div 2;
        PRect.Bottom	:= PRect.Top + trunc(PWidth / IRatio);
      end
      else begin                      // image is "slimmer" than printer
      	PRect.Left		:= (PWidth - trunc(PHeight * IRatio)) div 2;
        PRect.Right		:= PRect.Left + trunc(PHeight * IRatio);
        PRect.Top			:= 0;
        PRect.Bottom	:= PHeight;
      end;
    end
    else begin                        // image is landscape
    	PRect.Left		:= 0;
      PRect.Right		:= PWidth;
      PRect.Top			:= (PHeight - trunc(PWidth / IRatio)) div 2;
      PRect.Bottom	:= PRect.Top + trunc(PWidth / IRatio);
    end;
  end
  else begin                     // printer in landscape
  	if IRatio < 1 then begin 					// image is portrait
    	PRect.Left		:= (PWidth - trunc(PHeight * IRatio)) div 2;
      PRect.Right		:= PRect.Left + trunc(PHeight * IRatio);
      PRect.Top			:= 0;
      PRect.Bottom	:= PHeight;
    end
    else begin
    	if PRatio < IRatio then begin   // image is "thicker" than printer
	    	PRect.Left		:= 0;
  	    PRect.Right		:= PWidth;
    	  PRect.Top			:= (PHeight - trunc(PWidth / IRatio)) div 2;
      	PRect.Bottom	:= PRect.Top + trunc(PWidth / IRatio);
      end
      else begin
	    	PRect.Left		:= (PWidth - trunc(PHeight * IRatio)) div 2;
  	    PRect.Right		:= PRect.Left + trunc(PHeight * IRatio);
    	  PRect.Top			:= 0;
      	PRect.Bottom	:= PHeight;
      end;
    end;
  end;

  try
		APrinter.Canvas.StretchDraw(PRect, AGraphic);
  finally
		Printer.EndDoc;
  end;
end;

function GetVersion(sFileName:string): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(sFileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(sFileName), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    Result := IntToStr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

function DeleteStatValueFromDB(var Query: TZQuery; StatID : integer; DateOfValue: TDate):boolean;
var
  OldDateSeparator : WideChar;
  OldShortDateFormat : string;
begin
  result := true;
  OldDateSeparator := FormatSettings.DateSeparator;
  OldShortDateFormat := FormatSettings.ShortDateFormat;
  FormatSettings.DateSeparator := '-';
  FormatSettings.ShortDateFormat := 'yyyy/mm/dd';
  Query.SQL.Text  :=  'DELETE FROM statvalues WHERE StatID=' + IntToStr(StatID) + ' AND Date="' + DateToStr(DateOfValue)+'"';

  try
    Query.ExecSQL;
  except
    on E: EZSQLException do begin
      ShowError(Application.MainForm, 'Ошибка удаления значения из базы.', e.ErrorCode, e.StatusCode, e.Message);
      result := false;
    end;
  end;

  FormatSettings.DateSeparator   := OldDateSeparator;
  FormatSettings.ShortDateFormat := OldShortDateFormat;
end;

function StatValueToDB(var Query: TZQuery; AStatID : integer; DateOfValue: TDate; Value: Extended):boolean;
var
  OldDateSeparator : WideChar;
  OldShortDateFormat : string;
begin
  result := true;
  OldDateSeparator := FormatSettings.DateSeparator;
  OldShortDateFormat := FormatSettings.ShortDateFormat;
  FormatSettings.DateSeparator := '-';
  FormatSettings.ShortDateFormat := 'yyyy/mm/dd';

  Query.SQL.Text := 'INSERT INTO statvalues(StatID,Value,Date)VALUES(:fStID,:fVal,:fDt)ON DUPLICATE KEY UPDATE Value=:fVal';
	Query.ParamByName('fStID').AsFloat  := AStatID;
	Query.ParamByName('fVal').AsFloat   := Value;
	Query.ParamByName('fDt').AsDateTime := DateOfValue;

  try
    Query.ExecSQL;
  except
 	  on e: EZSQLException do begin
	    ShowError(Application.MainForm, 'Ошибка сохранения значений статистики.', e.ErrorCode, e.StatusCode, e.Message);
      result := false;
    end;
  end;

  FormatSettings.DateSeparator   := OldDateSeparator;
  FormatSettings.ShortDateFormat := OldShortDateFormat;
end;

{$IFDEF STATPROJ}
function IsAWEDay(SomeDay : TDateTime; WeekEndDay : integer): boolean;
var
  s: string;
begin
  if gStatsWeekly then begin
    Result := DayOfTheWeek(SomeDay) <> WeekEndDay;
  end
  else begin
    Result := DayOf(SomeDay) = 1;
  end;
  s := DateToStr(SomeDay);
  OutputDebugString(PWideChar('---- IsAWEDay : ' + s));
end;

function GetPrevWEDay(SomeDay : TDateTime; WeekEndDay : integer): TDateTime;
var
  s: string;
begin
  Result := GetNextWEDay(SomeDay, WeekEndDay);
  if gStatsWeekly then begin
   Result := Result - 7;
  end
  else begin
    Result := IncMonth(Result, -1);
  end;
  s := DateToStr(Result);
  OutputDebugString(PWideChar('---- GetNextWEDay : ' + DateToStr(Result)));
end;

function GetNextWEDay(SomeDay : TDateTime; WeekEndDay : integer): TDateTime;
var
  s: string;
begin
  if gStatsWeekly then begin
    while DayOfTheWeek(SomeDay) <> WeekEndDay do SomeDay := SomeDay + 1;
    Result := SomeDay;
  end
  else begin
    SomeDay := IncMonth(SomeDay, 1);
    Result := RecodeDay(SomeDay, 1);
  end;
  s := DateToStr(Result);
  OutputDebugString(PWideChar('---- GetNextWEDay : ' + s));
end;
{$ENDIF}

procedure FillComboWithEntities(var ACombo : TComboBox; var AList : TList; AOrgPrefix : string; WithFndr : boolean);
var
  i : integer;
  TmpList : TList;

begin

  TmpList := TList.Create;
  TmpList.Assign(AList);
  LeaveCommonOnly(TmpList, AOrgPrefix, WithFndr);

  ACombo.Clear;
  for i := 0 to TmpList.Count - 1 do begin
    ACombo.Items.AddObject(PVTResourceData(TmpList[i]).name, TmpList[i]);      // Проверить! ACombo.Items.Objects[i] := TmpList[i];
  end;
  if ACombo.Items.Count > 0 then
    ACombo.ItemIndex := 0;
end;

procedure ListFilterOut(var AList : TList; AOrgPrefix : string; WithFndr : boolean);
var
	CashStr, DisbCashStr, Bill1Str : string;
  i : integer;
begin
	CashStr     := AOrgPrefix + CASH_LINK;
	DisbCashStr := AOrgPrefix + DISBCASH_LINK;
  Bill1Str    := AOrgPrefix + BILL1_LINK;

  i := 0;
  while i < AList.Count do begin
    if(PVTResourceData(AList.Items[i]).link = CashStr) or (PVTResourceData(AList.Items[i]).link = DisbCashStr) or (PVTResourceData(AList.Items[i]).link = Bill1Str) then begin
      AList.Delete(i);
    	continue;
    end;
    if(PVTResourceData(AList.Items[i]).sub = 1) then begin
      AList.Delete(i);
    	continue;
    end;
{$IFDEF FAFH}
    if (not WithFndr) and PVTResourceData(AList.Items[i]).fnd then begin
      AList.Delete(i);
    	continue;
    end;
{$ENDIF}
    Inc(i);
  end;
end;

procedure LeaveCommonOnly(AList : TList; AOrgPrefix : string; WithFndr : boolean);
var
	CashStr, DisbCashStr, Bill1Str : string;
  i : integer;
begin
	CashStr     := AOrgPrefix + CASH_LINK;
	DisbCashStr := AOrgPrefix + DISBCASH_LINK;
  Bill1Str    := AOrgPrefix + BILL1_LINK;

  i := 0;
  while i < AList.Count do begin
    if(PVTResourceData(AList.Items[i]).link = CashStr) or (PVTResourceData(AList.Items[i]).link = DisbCashStr) or (PVTResourceData(AList.Items[i]).link = Bill1Str) then begin
      AList.Delete(i);
    	continue;
    end;
    if(PVTResourceData(AList.Items[i]).sub = 1) then begin
      AList.Delete(i);
    	continue;
    end;
{$IFDEF FAFH}
    if (not WithFndr) and (PVTResourceData(AList.Items[i]).fnd) then begin
      AList.Delete(i);
    	continue;
    end;
{$ENDIF}
    Inc(i);
  end;
end;

{$IFDEF FPPROJ}
constructor TFilterObject.Create;
begin
	inherited;
	Clear;
end;

procedure TFilterObject.Clear;
begin
 with Data do begin
    Active   := false;
  	kind     := 0;
    Oper1    := '';
    Oper2    := '';
    op2OR    := false;
    SecOp    := false;
    IntVal1  := 0;
    IntVal2  := 0;
    ExtVal1  := 0;
    ExtVal2  := 0;
    DateVal1 := 0;
    DateVal2 := 0;
    StrVal   := '';
 end;
end;

procedure TFilterObject.SetFilterType(AType : integer);
begin
  Data.Kind := AType;
end;

function TFilterObject.GetFilterType : integer;
begin
  Result := Data.Kind;
end;

procedure TFilterObject.SetUpFilter;
var
	fnf : TFilterNumbersForm;
	fsf : TFilterStringForm;
	fff : TFilterFloatsForm;
	fdf : TFilterDatesForm;
  i : integer;
begin
	if Data.Kind = ftInt then begin
		fnf := TFilterNumbersForm.Create(nil);
    i := fnf.cmbOper1.IndexOf(Data.Oper1);
    if(i > 0) then fnf.cmbOper1.ItemIndex := i
    else fnf.cmbOper1.ItemIndex := 0; //MessageBox(0, 'Не найден индекс первой операции', 'Ошибка настройки фильтра', MB_OK or MB_ICONERROR);
    fnf.edtVal1.Text := IntToStr(Data.IntVal1);
    fnf.ckbOper2.Checked := Data.SecOp;
    fnf.rbOR.Checked     := Data.op2OR;
    fnf.rbAND.Checked    := not Data.op2OR;
    fnf.SecOpReset;
    if Data.SecOp then begin
	    i := fnf.cmbOper2.IndexOf(Data.Oper2);
	 	  if(i > 0) then fnf.cmbOper2.ItemIndex := i else fnf.cmbOper2.ItemIndex := 0;
	    fnf.edtVal2.Text := IntToStr(Data.IntVal2);
    end;

    if fnf.ShowModal = mrOk then begin
      if fnf.DeactivateIt then begin
        Clear;
        Data.Kind := ftInt;
      end
			else begin
      	Data.Active  := true;
    		Data.IntVal1 := StrToInt(fnf.edtVal1.Text);
		    Data.Oper1   := fnf.cmbOper1.Text;
    		Data.SecOp   := fnf.ckbOper2.Checked;
				if Data.SecOp then begin
					Data.IntVal2 := StrToInt(fnf.edtVal2.Text);
  		    Data.Oper2   := fnf.cmbOper2.Text;
      	  Data.op2OR   := fnf.rbOR.Checked;
	      end
  		  else begin
	  			Data.IntVal2 := 0;
  	  		Data.Oper2   := '';
			 		Data.op2OR   := true;
				end;
      end;
      PostMessage(MFPF.Handle, UM_CFILTER_APPLIED, 0, 0);
	  end;
		fnf.Destroy;
  end
  else if Data.Kind = ftStr then begin
    fsf := 	TFilterStringForm.Create(nil);
    fsf.cmbOper.Clear;
    fsf.cmbOper.Items.Add(rsFilterSubString);
    fsf.cmbOper.Items.Add(rsFilterFullString);
    i := fsf.cmbOper.IndexOf(Data.Oper1);
    if(i > 0) then fsf.cmbOper.ItemIndex := i else fsf.cmbOper.ItemIndex := 0;
    fsf.edtVal.Text := Data.StrVal;

    if fsf.ShowModal = mrOk then begin
      if fsf.DeactivateIt then begin
        Clear;
        Data.Kind := ftStr;
      end
			else begin
      	Data.Active  := true;
    		Data.StrVal := fsf.edtVal.Text;
		    Data.Oper1  := fsf.cmbOper.Text;
			end;
      PostMessage(MFPF.Handle, UM_CFILTER_APPLIED, 0, 0);
    end;
		fsf.Destroy;
  end
  else if Data.Kind = ftExt then begin
		fff := TFilterFloatsForm.Create(nil);
    i := fff.cmbOper1.IndexOf(Data.Oper1);
    if(i > 0) then fff.cmbOper1.ItemIndex := i else fff.cmbOper1.ItemIndex := 0;
    fff.edtVal1.Value    := Data.ExtVal1;
    fff.ckbOper2.Checked := Data.SecOp;
    fff.rbOR.Checked     := Data.op2OR;
    fff.rbAND.Checked    := not Data.op2OR;
    fff.SecOpReset;
    if Data.SecOp then begin
	    i := fff.cmbOper2.IndexOf(Data.Oper2);
	 	  if(i > 0) then fff.cmbOper2.ItemIndex := i else fff.cmbOper2.ItemIndex := 0;
	    fff.edtVal2.Value := Data.ExtVal2;
    end;

    if fff.ShowModal = mrOk then begin
      if fff.DeactivateIt then begin
        Clear;
        Data.Kind := ftExt;
      end
			else begin
      	Data.Active  := true;
    		Data.ExtVal1 := fff.edtVal1.Value;
		    Data.Oper1   := fff.cmbOper1.Text;
    		Data.SecOp   := fff.ckbOper2.Checked;
				if Data.SecOp then begin
					Data.ExtVal2 := fff.edtVal2.Value;
  		    Data.Oper2   := fff.cmbOper2.Text;
      	  Data.op2OR   := fff.rbOR.Checked;
	      end
  		  else begin
	  			Data.ExtVal2 := 0;
  	  		Data.Oper2   := '';
			 		Data.op2OR   := true;
				end;
      end;
      PostMessage(MFPF.Handle, UM_CFILTER_APPLIED, 0, 0);
	  end;
		fff.Destroy;
  end
  else if Data.Kind = ftDates then begin
		fdf := TFilterDatesForm.Create(nil);
    i := fdf.cmbOper1.IndexOf(Data.Oper1);
    if(i > 0) then fdf.cmbOper1.ItemIndex := i else fdf.cmbOper1.ItemIndex := 0;
    fdf.deVal1.Date      := DateOf(Data.DateVal1);
    fdf.teVal1.Time      := TimeOf(Data.DateVal1);
    fdf.ckbOper2.Checked := Data.SecOp;
    fdf.rbOR.Checked     := Data.op2OR;
    fdf.rbAND.Checked    := not Data.op2OR;
    fdf.SecOpReset;
    if Data.SecOp then begin
	    i := fdf.cmbOper2.IndexOf(Data.Oper2);
	 	  if(i > 0) then fdf.cmbOper2.ItemIndex := i else fdf.cmbOper2.ItemIndex := 0;
	    fdf.deVal2.Date := DateOf(Data.DateVal2);
	    fdf.teVal2.Time := TimeOf(Data.ExtVal2);
    end;

    if fdf.ShowModal = mrOk then begin
      if fdf.DeactivateIt then begin
        Clear;
        Data.Kind := ftExt;
      end
			else begin
      	Data.Active  := true;
    		Data.DateVal1 := fdf.deVal1.Date + fdf.teVal1.Time;
		    Data.Oper1   := fdf.cmbOper1.Text;
    		Data.SecOp   := fdf.ckbOper2.Checked;
				if Data.SecOp then begin
	    		Data.DateVal2 := fdf.deVal2.Date + fdf.teVal2.Time;
  		    Data.Oper2   := fdf.cmbOper2.Text;
      	  Data.op2OR   := fdf.rbOR.Checked;
	      end
  		  else begin
	  			Data.ExtVal2 := 0;
  	  		Data.Oper2   := '';
			 		Data.op2OR   := true;
				end;
      end;
      PostMessage(MFPF.Handle, UM_CFILTER_APPLIED, 0, 0);
	  end;
		fdf.Destroy;
  end
end;

function TFilterObject.StateToString : string;
var
  i : integer;
  resstr : string;
begin
	resstr := '[';
  with Data do begin
	  if Active then begin
			if Kind = ftInt then begin
  		  resstr := resstr + Oper1 + IntToStr(IntVal1);
    		if SecOp then begin
			    resstr := resstr + ' ';
  		    if op2OR then resstr := resstr + rsOR
    		  else resstr := resstr + rsAND;
	    		resstr := resstr + ' ' + Oper2 + IntToStr(IntVal2);
		    end;
  		end
	  	else if Kind = ftStr then begin
  			if Oper1 = rsFilterFullString then
	  	  	resstr := resstr + rsFullString + ': '
		    else
			    resstr := resstr + rsSubString + ': ';
    		resstr := resstr + StrVal;
		  end
  		else if Data.Kind = ftExt then begin
  		  resstr := resstr + Oper1 + MyFloatToStr(ExtVal1);
    		if SecOp then begin
			    resstr := resstr + ' ';
  		    if op2OR then resstr := resstr + rsOR
    		  else resstr := resstr + rsAND;
	    		resstr := resstr + ' ' + Oper2 + MyFloatToStr(ExtVal2);
		    end;
  		end
		  else if Data.Kind = ftDates then begin
  		  resstr := resstr + Oper1 + DateTimeToStr(DateVal1);
    		if SecOp then begin
			    resstr := resstr + ' ';
  		    if op2OR then resstr := resstr + rsOR
    		  else resstr := resstr + rsAND;
	    		resstr := resstr + ' ' + Oper2 + DateTimeToStr(DateVal2);
		    end;
  		end;
	  end // if Data.Active then begin
  	else begin
	  	resstr := resstr + rsFilterIsInactive;
	  end;
  end; // with Data
  resstr := resstr + ']';

  Result := resstr;
end;

function TFilterObject.GetIntFilterResult(AVal: integer) : boolean;
var
	tmpres : boolean;
begin
	tmpres := true;
	with Data do begin
		if not Active then begin Result := tmpres; Exit; end;
//		if Active then begin Result := false; Exit; end;
	  if Oper1 = '<' then tmpres := AVal < Data.IntVal1
  	else if Oper1 = '<=' then tmpres := AVal <= Data.IntVal1
    else if Oper1 = '=' then tmpres := AVal = Data.IntVal1
    else if Oper1 = '>=' then tmpres := AVal >= Data.IntVal1
	  else if Oper1 = '>' then tmpres := AVal > Data.IntVal1;
  	Result := tmpres;
    if SecOp then begin
			if Oper2 = '<' then tmpres := AVal < Data.IntVal2
  		else if Oper2 = '<=' then tmpres := AVal <= Data.IntVal2
    	else if Oper2 = '=' then tmpres := AVal = Data.IntVal2
      else if Oper2 = '>=' then tmpres := AVal >= Data.IntVal2
		  else if Oper2 = '>' then tmpres := AVal > Data.IntVal2;

  	  if op2OR then Result := Result or tmpres else Result := Result and tmpres;
	  end;
  end;
end;

function TFilterObject.GetExtFilterResult(AVal: extended) : boolean;
var
	tmpres : boolean;
begin
 	tmpres := true;
	with Data do begin
		if not Active then begin Result := tmpres; Exit; end;
	  if Oper1 = '<' then tmpres := AVal < Data.ExtVal1
  	else if Oper1 = '<=' then tmpres := AVal <= Data.ExtVal1
    else if Oper1 = '=' then tmpres := AVal = Data.ExtVal1
    else if Oper1 = '>=' then tmpres := AVal >= Data.ExtVal1
	  else if Oper1 = '>' then tmpres := AVal > Data.ExtVal1;
  	Result := tmpres;
    if SecOp then begin
			if Oper2 = '<' then tmpres := AVal < Data.ExtVal2
  		else if Oper2 = '<=' then tmpres := AVal <= Data.ExtVal2
    	else if Oper2 = '=' then tmpres := AVal = Data.ExtVal2
      else if Oper2 = '>=' then tmpres := AVal >= Data.ExtVal2
		  else if Oper2 = '>' then tmpres := AVal > Data.ExtVal2;

  	  if op2OR then Result := Result or tmpres
    	else Result := Result and tmpres;
    end;
  end;
end;

function TFilterObject.GetDatesFilterResult(AVal: TDateTime) : boolean;
var
	tmpres : boolean;
  dtcres : TValueRelationship;
begin
	tmpres := true;
	with Data do begin
		if not Active then begin Result := tmpres; Exit; end;
    dtcres := CompareDateTime(AVal, DateVal1);
	  if Oper1 = '<' then tmpres := dtcres < 1
  	else if Oper1 = '<=' then tmpres := dtcres <= 0
    else if Oper1 = '=' then tmpres := dtcres = 0
    else if Oper1 = '>=' then tmpres := dtcres >= 0
	  else if Oper1 = '>' then tmpres := dtcres > 0;
  	Result := tmpres;
    if SecOp then begin
	    dtcres := CompareDateTime(AVal, DateVal2);
			if Oper2 = '<' then tmpres := dtcres < 0
  		else if Oper2 = '<=' then tmpres := dtcres <= 0
    	else if Oper2 = '=' then tmpres := dtcres = 0
      else if Oper2 = '>=' then tmpres := dtcres >= 0
		  else if Oper2 = '>' then tmpres := dtcres > 0;

  	  if op2OR then Result := Result or tmpres
    	else Result := Result and tmpres;
    end;
  end;
end;

function TFilterObject.GetStrFilterResult(AVal: string) : boolean;
begin
	with Data do begin
		if not Active then begin Result := true; Exit; end;
	  if Oper1 = rsFilterFullString then result := AnsiUpperCase(AVal) = AnsiUpperCase(StrVal)
    else result := ContainsText(AVal, StrVal); //Pos(StrVal, AVal) > 0;
  end;
end;
{$ENDIF}

function GetStringRes(idx: DWORD; wLang: Word): WideString;
var
  hFindRes: Cardinal;
  hLoadRes: Cardinal;
  nBlockID, nItemID: DWORD;
  pRes: Pointer;
  i, j: Integer;
  dwSize: Cardinal;
  nLen: Integer;
  iStr: Cardinal;
const
  NO_OF_STRINGS_PER_BLOCK = 16;
begin
  Result := EmptyStr;
  nBlockID := (idx shr 4) + 1;
  nItemID := 16 - (nBlockID shl 4 - idx);
  hFindRes := FindResourceEx(HInstance, RT_STRING, MAKEINTRESOURCEW(nBlockID), wLang);
  if hFindRes = 0 then Exit;
  hLoadRes := LoadResource(HInstance, hFindRes);
  if hLoadRes = 0 then Exit;
  pRes := LockResource(hLoadRes);
  if pRes = nil then Exit;
  dwSize := SizeofResource(HInstance, hFindRes);
  if dwSize = 0 then Exit;
  iStr := 0;
  for i := 0 to NO_OF_STRINGS_PER_BLOCK - 1 do
  begin
    nLen := PWord(pRes)^;
    Inc(DWord(pRes), 2);
    if pRes = nil then
      Exit;
    if iStr = nItemID then
    begin
      SetLength(Result, nLen);
      for j := 1 to nLen do
      begin
        Result[j] := PWideChar(pRes)^;
        Inc(DWord(pRes), 2);
      end;
      UnlockResource(hLoadRes);
      Exit;
    end
    else
      Inc(DWord(pRes), nLen * 2);
    inc(iStr);
  end;
end;

procedure LoadResourceStrings(wLang : LangID);
begin
	rsIncorrectData := GetStringRes(nrsIncorrectData, wLang);
	rsIncorrectDataRcvd := GetStringRes(nrsIncorrectDataRcvd, wLang);
	rsSrvConnErr := GetStringRes(nrsSrvConnErr, wLang);
	rsConnSetupErr := GetStringRes(nrsConnSetupErr, wLang);
	rsFailedToGetStatValues := GetStringRes(nrsFailedToGetStatValues, wLang);
	rsFailedToLoadStat := GetStringRes(nrsFailedToLoadStat, wLang);

	rsFailedToLoadStatList := GetStringRes(nrsFailedToLoadStatList, wLang);
	rsFailedToLoadUngroupedStatList := GetStringRes(nrsFailedToLoadUngroupedStatList, wLang);
	rsFailedToLoadFPDates := GetStringRes(nrsFailedToLoadFPDates, wLang);
	rsFailedToLoadStatDates := GetStringRes(nrsFailedToLoadStatDates, wLang);
	rsFailedToSetupCodePage := GetStringRes(nrsFailedToSetupCodePage, wLang);
	rsFailedToLocateStatIC := GetStringRes(nrsFailedToLocateStatIC, wLang);

	rsFailedToCreateUser := GetStringRes(nrsFailedToCreateUser, wLang);
	rsFailedToInitUserInfo := GetStringRes(nrsFailedToInitUserInfo, wLang);
	rsFaileToUpdateUserInfo := GetStringRes(nrsFaileToUpdateUserInfo, wLang);
	rsFaileToDeleteUserInfo := GetStringRes(nrsFaileToDeleteUserInfo, wLang);
	rsFailedToStartTransation := GetStringRes(nrsFailedToStartTransation, wLang);
	rsFailedToCloseTransation := GetStringRes(nrsFailedToCloseTransation, wLang);
	rsFailedToCreateNewPost := GetStringRes(nrsFailedToCreateNewPost, wLang);
	rsServerAnswerBelow := GetStringRes(nrsServerAnswerBelow, wLang);
	rsError := GetStringRes(nrsError, wLang);
	rsStatus := GetStringRes(nrsStatus, wLang);
	rsAddressToDevelopers := GetStringRes(nrsAddressToDevelopers, wLang);
	rsDataNotFound := GetStringRes(nrsDataNotFound, wLang);
	rsAuthorError := GetStringRes(nrsAuthorError, wLang);
	rsCheckLoginPwd := GetStringRes(nrsCheckLoginPwd, wLang);
	rsStatsUser := GetStringRes(nrsStatsUser, wLang);
	rsUser := GetStringRes(nrsUser, wLang);
	rsAccessLevel := GetStringRes(nrsAccessLevel, wLang);
	rsFull := GetStringRes(nrsFull, wLang);
	rsTitle := GetStringRes(nrsTitle, wLang);
{$IFDEF MONTHLY}
	rsMonth  := GetStringRes(nrsMonth, wLang);
	rsMonths := GetStringRes(nrsMonths, wLang);
{$ELSE}
	rsWeek := GetStringRes(nrsWeek, wLang);
	rsWeeks := GetStringRes(nrsWeeks, wLang);
{$ENDIF}
	rsSureToDeleteStat := GetStringRes(nrsSureToDeleteStat, wLang);
	rsSureToDeleteGroup := GetStringRes(nrsSureToDeleteGroup, wLang);
	rsSureToDeleteUser := GetStringRes(nrsSureToDeleteUser, wLang);
	rsAllDataToDelete := GetStringRes(nrsAllDataToDelete, wLang);
	rsStatsAndDataToSave := GetStringRes(nrsStatsAndDataToSave, wLang);
	rsUserToRemoveTotally := GetStringRes(nrsUserToRemoveTotally, wLang);
	rsUserDelete := GetStringRes(nrsUserDelete, wLang);
	rsUserImpossibleToDelete := GetStringRes(nrsUserImpossibleToDelete, wLang);
	rsUserPOsExist := GetStringRes(nrsUserPOsExist, wLang);
	rsUserToArchive := GetStringRes(nrsUserToArchive, wLang);
	rsUserDataChange := GetStringRes(nrsUserDataChange, wLang);
	rsUserSaveData := GetStringRes(nrsUserSaveData, wLang);
	rsUserAccessSetupSchanged := GetStringRes(nrsUserAccessSetupSchanged, wLang);
	rsUserPostNotFound := GetStringRes(nrsUserPostNotFound, wLang);
	rsUserPostToAdd := GetStringRes(nrsUserPostToAdd, wLang);
	rsPostNotFound := GetStringRes(nrsPostNotFound, wLang);
	rsConfirmDelete := GetStringRes(nrsConfirmDelete, wLang);
	rsPostCreate := GetStringRes(nrsPostCreate, wLang);
	rsPostProperties := GetStringRes(nrsPostProperties, wLang);
	rsPostDelete := GetStringRes(nrsPostDelete, wLang);
	rsGroupCreate := GetStringRes(nrsGroupCreate, wLang);
	rsGroupProperties := GetStringRes(nrsGroupProperties, wLang);
	rsGroupDelete := GetStringRes(nrsGroupDelete, wLang);
	rsStatProperties := GetStringRes(nrsStatProperties, wLang);
	rsErrInput := GetStringRes(nrsErrInput, wLang);
	rsErrAtLeastOneDataNeeded := GetStringRes(nrsErrAtLeastOneDataNeeded, wLang);
	rsErrStartIsToBeLess := GetStringRes(nrsErrStartIsToBeLess, wLang);
	rsLowMarginIsLessThanHigh := GetStringRes(nrsLowMarginIsLessThanHigh, wLang);
	rsHighMarginIsMoreThanLow := GetStringRes(nrsHighMarginIsMoreThanLow, wLang);
	rsHntShowGraphs := GetStringRes(nrsHntShowGraphs, wLang);
	rsHntValuesShow := GetStringRes(nrsHntValuesShow, wLang);
	rsHntValuesHide := GetStringRes(nrsHntValuesHide, wLang);
	rsSaveData := GetStringRes(nrsSaveData, wLang);
	rsGroupStat := GetStringRes(nrsGroupStat, wLang);
	rsRead := GetStringRes(nrsRead, wLang);
	rsWrite := GetStringRes(nrsWrite, wLang);
	rsToContinue := GetStringRes(nrsToContinue, wLang);
	rsCharsetSetUp := GetStringRes(nrsCharsetSetUp, wLang);
  rsDataStructError := GetStringRes(nrsDataStructError, wLang);
  rsDataError       := GetStringRes(nrsDataError, wLang);
  rsCriticalError := GetStringRes(nrsCriticalError, wLang);
  rsIncorrectGUIDError := GetStringRes(nrsIncorrectGUIDError, wLang);
  rsCheckingForUpdates := GetStringRes(nrsCheckingForUpdates, wLang);
  rsConnectionError  := GetStringRes(nrsConnectionError, wLang);
  rsUpdateError  := GetStringRes(nrsUpdateError, wLang);
  rsDwldingUpdates := GetStringRes(nrsDwldingUpdates, wLang);
  rsNoUpdates := GetStringRes(nrsNoUpdates, wLang);
  rsFailedToLaunchFile := GetStringRes(nrsFailedToLaunchFile, wLang);
  rsFile := GetStringRes(nrsFile, wLang);
  rsUpdatesDownloaded := GetStringRes(nrsUpdatesDownloaded, wLang);
  rsInstallingUpdates := GetStringRes(nrsInstallingUpdates, wLang);
  rsUpdatesInstalled := GetStringRes(nrsUpdatesInstalled, wLang);
  rsRemovingTempFiles := GetStringRes(nrsRemovingTempFiles, wLang);
  rsDatesRangeError   := GetStringRes(nrsDatesRangeError, wLang);
  rsDatesRangeErrorMessageTooShortPeriodMonthly := GetStringRes(nrsDatesRangeErrorMessageTooShortPeriodMonthly, wLang);
  rsDatesRangeErrorMessageTooShortPeriodWeekly  := GetStringRes(nrsDatesRangeErrorMessageTooShortPeriodWeekly, wLang);
  rsDatesRangeErrorMessageIncorrectRange := GetStringRes(nrsDatesRangeErrorMessageIncorrectRange, wLang);
  rsFPTrasferFromCashToBillOne := 'Перевод из приходной кассы на Cчёт № 1 на ФП №'; //GetStringRes(nrsFPTrasferFromCashToBillOne, wLang);

end;

initialization
  ConIniFileIsRO := false;
	WorkingWithIni := SetUpIniFile;
	SetCommaAsDecimalSeparator;

	// synchronization objects initialization
  AttNeededCS    := TCriticalSection.Create;
  AttNeededEvent := TEvent.Create(nil, false, false, '');
  LoadingAttsCS   := TCriticalSection.Create;
  LoadingAtts    := TList.Create;

  AttAddedHDD		:= TEvent.Create(nil, false, false, '');
  AttAddedHDDCS := TCriticalSection.Create;

  AttsToSave	 := TList.Create;
  AttSaveEvent := TEvent.Create(nil, false, false, '');
  AttSaveCS		 := TCriticalSection.Create;

  AttsToRemove   := '';
  AttRemoveEvent := TEvent.Create(nil, false, false, '');
  AttRemoveCS		 := TCriticalSection.Create;



  UpdateEvent := TEvent.Create(nil, false, false, '');
  UpdateCS		:= TCriticalSection.Create;

{$IFDEF TLOG}
  PushToDBEvent := TEvent.Create(nil, false, false, '');
  PushToDBCS		:= TCriticalSection.Create;
  LoadLogEvent  := TEvent.Create(nil, false, false, '');
  llid				 	:= 0;
{$ENDIF}

  LoadArchEvent	:= TEvent.Create(nil, false, false, '');
  LoadArchCS 		:= TCriticalSection.Create;
  LoadArchFLink	:= '';
  LoadArchPrefix:= '';

  FPLockEvent	:= TEvent.Create(nil, false, false, '');

{$IFDEF FPPROJ}
  POLockEvent	:= TEvent.Create(nil, false, false, '');
{$ENDIF}

  SSLDATAFOLDER := ExtractFilePath(Application.ExeName);
  cv            := GetVersion(Application.ExeName);
  if cv = '' then begin
    Application.MessageBox('Невозможно определить версию программы.', 'Критическая ошибка', MB_OK or MB_ICONERROR);
    Application.Terminate;
  end;

{$IFDEF ENCRYPTMYSQLTRAFFIC}          // encrypt traffic to and from server with SSL
  encconn := true;
{$ELSE}
  encconn := false;
{$ENDIF}

  cto	:= 10 * 1000; // default connect_timeout = 10 seconds (in ms)

{$IFDEF STATPROJ}
  {$IFDEF MONTHLY}          // set up stats period
    gStatsWeekly := false;
  {$ELSE}
    gStatsWeekly := true; // default stats period is a week
  {$ENDIF}
{$ENDIF}

{$IFDEF FPPROJ}
  rsCharsetSetUp := 'cp1251';
{$ENDIF}

end.

