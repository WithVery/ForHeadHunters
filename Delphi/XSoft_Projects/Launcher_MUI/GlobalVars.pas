unit GlobalVars;

interface

{I DEFINES.INC}

uses
  Classes,
  Messages,
  SysUtils,
  Graphics,
  IniFiles,
  Dialogs, 	// for ShowMessage - to be deleted
  Forms, 		// for Application - to be deleted
  Clipbrd, 	// for TClipboard
  JPEG,
	ExtCtrls, // for TImage
  SyncObjs, // for TEvent
  VirtualTrees, // for PVirtualNode
	Printers, // for PrintGraphic function
  ShellApi, // for GetRegistryIconHandle(FileName: string): HICON;
  Registry, // for GetRegistryIconHandle(FileName: string): HICON;
  Windows,  // for GetRegistryIconHandle(FileName: string): HICON;
  ZConnection,
  ZDataset;

Const
  UM_CLEARNAVBAR  	  	= WM_USER + $200; // UM_ stands for UserMessage
  UM_SHOWPROPERFP 	  	= WM_USER + $201;
	UM_FPWASAPPROVED    	= WM_USER + $202;
  UM_POPUPMENUNEEDED  	= WM_USER + $203;
//  UM_SUMSUPDATENEEDED  	= WM_USER + $204;
	UM_STRGRIDPOPUPNEEDED = WM_USER + $205;
	UM_DEBCREDPOPUPNEEDED = WM_USER + $206;
	UM_POSPOPUPNEEDED 		= WM_USER + $207;
	UM_OKTODELINCSRC			= WM_USER + $208;
	UM_ATT_FAILED_TO_LOAD	= WM_USER + $209;
	UM_NEWATT_LOADED			= WM_USER + $20A;
	UM_LOGINNAMEOK        = WM_USER + $20B;  //this group is for LoginNameCheckThread
	UM_LOGINNAMENOTOK     = WM_USER + $20C;
	UM_LOGINNAMECHECKFAILED = WM_USER + $20D;
	UM_FP_ALLOCFORMCLOSED  = WM_USER + $20E;
	UM_FP_FUNDSLISTHIDE    = WM_USER + $20F;
	UM_FUNDTRANSFERRED     = WM_USER + $210;

//  for updating and launching
  UM_UPDNEEDED           = WM_USER + $211;
  UM_UPDFAILED           = WM_USER + $212;
  UM_UPDNOTNEEDED        = WM_USER + $213;

  UM_UPDDWNLDSTARTED     = WM_USER + $214;
  UM_UPDDWNLDIP          = WM_USER + $215;
  UM_UPDDWNLDCMPLTD      = WM_USER + $216;

  UM_UPDSTARTED          = WM_USER + $217;
  UM_UPDIP               = WM_USER + $218;
  UM_UPDDELTMPFLS        = WM_USER + $219;
  UM_UPDCMPLTD           = WM_USER + $21A;

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

  MAINGUID : string = '{B0B1453F-3996-426F-8A5A-0561C96A6347}';
  // MYSQL error codes
  MYSQLDUPLICATEENTRY = 1062;

  XORKey : string = 'akDjFP9z8sdkl5432-908zvlm,543v-z90x85234M,.sfxcvi870q934lsGmDf,gj98sdo65l4265sD09ft;l2k456,mWneRv9s8d75po2k43,.sfdKGjh0q2983452;lk,.gdSnD.lwk435hS9d8fLn43w.5wSO8d7bvslio45.,wmNedfLKqhLrqkWeJrP9w8eRutWEKjHBV0S89L;KWEJR5TP890SDUFL;K5M.O9EF7GVP982J43LKTRWSD';

  CRLF        		: String  = Chr(13) + Chr(10);
//  LFCR						: string
//  FROMCASH				: string 	= 'Из расходов';

{$IFDEF MULTIORG}
  CASHID  : integer = 2; // here are the `index` values in the asset table
  BANKID  : integer = 3;
{$ELSE}
  CASHID  : integer = 2; // 1;
  BANKID  : integer = 3; // 2;
{$ENDIF}

  // painting stuff
  NormalBkColor   : TColor = clWhite; //TColor($FFFFFF);
  NormalFontStyle : TFontStyles = [];

	MaxPrintWidth 	: integer = 650;

  clSpecBkColor		: TColor = TColor($0093B8CE);
  clMyLightPink		: TColor = TColor($CCCCFF);
  clMyLightGray		: TColor = TColor($EEEEEE);

  BRANCH_ASSETS       : integer =   3;
  BRANCH_FUNDS				: integer =   4;
  BRANCH_FP						: integer =   5;
  BRANCH_SEARCH				: integer =   6;
  BRANCH_POS					: integer =   7;
  BRANCH_ACCESS				: integer =  10;
  BRANCH_DEBITORS			: integer =  13;
  BRANCH_CREDITORS		: integer =  14;

  LIST_CREDITORS			: integer = 100;
  LIST_DEBITORS				: integer = 101;


  // "sub" values for FP branch
  FPROOT							: integer = 0;
  FPNOTAPPROVEDBRANCH	: integer = 1;
  FPARCHBRANCH				: integer = 2;
  FPNOTAPPROVED				: integer	= 3;
  FPARCHIVED					: integer	= 4;
	FPNEWFPTOCREATE			: integer = 5;

  // string constants
  CASH_LINK          	: string = 'cash';
  BILL1_LINK					: string = 'gso';

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

  AppName : string = 'AdminPower'; //  needed to create ini file in user "Application data" folder
  DebtListSection : string = 'DLW';
  POIniSection	: string = 'POSettings';

  UNIQUE							: integer = 0;
  NON_UNIQUE					: integer = 1;

//  (I)ncome (S)ource (F)orms constatnts
  ISF_OKTODELETE			: integer = 1;
  ISF_NOTOKTODELETE		: integer = 0;     // not used in reality

Type

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
    Descr   		: string;
  end;

	POrgData	= ^TOrgData;
  TOrgData = record
  	ID				: integer;
//    ParentID	: integer;
    ShortName	: string;
    FPPrivs		: string;
    prefix    : string;
  end;

	PErrorInfo	= ^TErrorInfo;
  TErrorInfo = record
    MCode	: integer; // no specific meaning so far
    SCode	: integer; // no specific meaning so far
    Msg		: string;	 // error message
  end;

	// for working with files in PO window -- ?
  PFileInfo = ^TFileInfo;
  TFileInfo = record
    FullName  : string;  	// either full name (submitting) or filename (editing/approving)
    Size      : integer;	// filesize (submitting)
    DBID			: integer;  // index of attachment in the DB if DBID = 0 then it's not in the DB and was just loaded from local drive
  end;

  PAttToSave	= ^TAttToSave;
  TAttToSave	= record
    ATS_POID  		: integer;
    ATS_Name  		: string;  	// filename (editing/approving) of the attachment
    ATS_Stream		: TMemoryStream;
    ATS_Prefix    : string;   // Org prefix
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
{$IFDEF MULTIORG}
    prefix		: string;					// prefix for the tables in the multi-org versions
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
  end;

  PAccData = ^TAccData;
  TAccData = record
    index       : integer;
    Day         : TDateTime;
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
  end;

var
  UTmpFolder : string;
  FPConnection    : TZConnection;
  FPMainDataset   : TZQuery;
  FPTmpDataset    : TZQuery;
//  MainFPFrm     : TMainFPForm;

  FormatString  : TFormatSettings;
  FPNum         : integer;  // ???
  FPUserID      : integer;
  FPLogin       : string;
  FPNameOfUser  : string;

{$IFDEF MULTIORG}
  FPPostsArr    : array of string;
{$ELSE}
  FPPost        : string;
  FPAccessString: string;
{$ENDIF}

  ThSep : char;    // delimeter for thousands in Currency transformation
  oid   : string;  // uid of the org - stored in connection.ini - unique for the org

  WorkingWithIni	: boolean;
  IniFile					: TIniFile;
  ConIniFile			: TIniFile;              // Connection ini file
  ConIniFileIsRO	: boolean;

  MaxFileSize			: integer;
  Clipboard				: TClipboard;

  ImgsToPrint			: TList;
  AttNeededEvent	: TEvent;									// special Attachment Needed (event)
  AttNeededCS			: TCriticalSection;				// special Attachment Needed (Critical Section)

  LoadedAttsCS		: TCriticalSection;				// loaded attachments list (Critical Section)

  AttAddedHDD			: TEvent;
  AttAddedHDDCS		: TCriticalSection;

  AttsToSave			: TList;									// List of attachments to be saved to DB
  AttSaveEvent		: TEvent;
  AttSaveCS				: TCriticalSection;

  UpdateEvent			: TEvent;
  UpdateCS				: TCriticalSection;

  FPLockEvent			: TEvent;

  SSLDATAFOLDER   : string;

//  OrgID       : integer;
//  Dates       : array of TDateTime;
//  Values      : array of TStatValues;
//  Values      : TList;

function  DayToStr(const SomeDay : TDateTime; Delimiter : string = '.') : string;
Function  TranslitIt(const RussianString: string): string;
//function  CompFondList(tablename : string; level : integer) : TList;
//function  CompFondList(tablename : string; level : integer; AWithGroups : boolean=true) : TList;
function  CompFondList(tablename : string; level : integer; AWithGroups : boolean; AConsiderApprovedPOs : boolean; APrefix : string) : TList;
function  CompareDates(Item1, Item2: Pointer): Integer;
procedure fond_update(flink : string; Balance : Extended);
function  GetNameOfFondByLink(AList : TList; ALink : string) : string;
function  GetLinkOfFondByName(AList : TList; AName : string) : string;
function  GetBalanceOfFondByLink(AList : TList; ALink : string) : extended;
function  GetBalanceOfFondByName(AList : TList; AName : string) : extended;

//procedure Cred_Calc(ToPayID : integer; ASum:extended; PONum : integer; ADate : string);

{$IFDEF MULTIORG} // multi-org versions of functions
function  PrivPresentMO(AOrgAStr : string; APStr : string) : boolean;
procedure Debt_CalcMO(AOrgPrefix : string; ToCollectID : integer; ASum : extended; ADate : string);
procedure Cred_CalcMO(AOrgPrefix : string; ToPayID : integer; ASum:extended; PONum : integer; ADate : string);
function  IsIt(AArray: array of PVirtualNode; ANode: PVirtualNode): boolean;
{$ELSE}
function  PrivPresent(APStr : string) : boolean;
procedure Debt_Calc(ToCollectID : integer; ASum:extended; ADate : string);
procedure Cred_Calc(ToPayID : integer; ASum:extended; PONum : integer; ADate : string);
{$ENDIF}

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


function EncryptPWD(const Text : string) : string;
function DecryptPWD(const Text : string) : string;
function XorCrypt(const key: string; const Text : string) : string;
procedure ShowError(AParent: TComponent; ATitle: string; AErrorCode : integer; AStatus : string; AMessage : string);
procedure GetMaxFileSize;

procedure SetCommaAsDecimalSeparator;

//
function GetNextThursday(SomeDay : TDateTime): TDateTime;

procedure PrintGraphic(APrinter: TPrinter; AGraphic : TGraphic);
function GetVersion(sFileName:string): string;

implementation

uses
//  windows, // for MB_OK - must be deleted
	ErrorWindow,
  StrUtils;

function GetVersion(sFileName:string): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(sFileName), Dummy);
  if(VerInfoSize = 0) then begin
    Result := '';
  end
  else begin
	  GetMem(VerInfo, VerInfoSize);
  	GetFileVersionInfo(PChar(sFileName), 0, VerInfoSize, VerInfo);
	  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  	with VerValue^ do begin
	    Result := IntToStr(dwFileVersionMS shr 16);
  	  Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
    	Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
	    Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
  	end;
	  FreeMem(VerInfo, VerInfoSize);
  end;
end;

function 	MyFirstLetterUp(AStr: String): string;
begin
  Result := AnsiUpperCase(LeftStr(AStr, 1)) + MidStr(AStr, 2, Length(AStr) - 1);
end;

procedure GetMaxFileSize;
begin
// commented only for portable MySQL
	FPMainDataset.SQL.Text := 'SHOW VARIABLES LIKE "max_allowed_packet"';
  FPMainDataset.Open;
  MaxFileSize := (MinInt(2 * 1024 * 1024, FPMainDataset.FieldByName('Value').AsInteger) * 8) div 10;
end;

procedure ShowError(AParent: TComponent; ATitle: string; AErrorCode : integer; AStatus : string; AMessage : string);
begin
	ErrorForm := TErrorForm.Create(AParent);
  ErrorForm.ErrorExplanationMemo.Text 	:= ATitle;
  ErrorForm.ErrorMemo.Text	 						:= '';
  if AErrorCode <> 0 then
	  ErrorForm.ErrorMemo.Text	 						:= 'Ошибка: ' + IntToStr(AErrorCode) + ', ';
  if AStatus <> '' then
  	ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + 'Статус: ' + AStatus + ', ';
  ErrorForm.ErrorMemo.Text	:= ErrorForm.ErrorMemo.Text + AMessage;
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
//  FileInfo: SHFILEINFO;
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
  //передача хендлера иконки как рещультат выполнения
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
//var
//  MyValue : integer;
begin
//	MyValue	:= AValue;
  if WorkingWithIni then begin
//		MyValue := Inifile.ReadInteger(ASection, AParam, MyValue);
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
		MyColWidth := Inifile.ReadInteger(ASection, 'C'+IntToStr(ACol), MyColWidth);
  	IniFile.WriteInteger(ASection, 'C'+IntToStr(ACol), MyColWidth);
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
  // set up connection file
	IniFileName := ExtractFilePath(Application.ExeName) + '\connection.ini';
  try
    ConIniFile	:= TIniFile.Create(IniFileName);
  except
  	on E : EIniFileException do begin
    	ConIniFileIsRO := true;
    end;
  end;
  oid := ConIniFile.ReadString('General', 'uid', '');

  if oid = '' then begin
    ShowError(nil, 'Критическая ошибка', 0, '', 'Ошибка получения данных для обновлений.');
    Application.Terminate;
  end;

	UserAppsFolder := GetEnvironmentVariable('APPDATA');
  ThisAppFolder	 := UserAppsFolder + '\' + oid;
  if not DirectoryExists(ThisAppFolder) then begin
    if not CreateDir(ThisAppFolder) then begin
      ShowError(nil, 'Критическая ошибка', 0, '', 'Невозможно создать рабочий каталог.');
      Application.Terminate;
    end;
  end;
  UTmpFolder := ThisAppFolder + '\';
  Result := true;
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

{$IFDEF MULTIORG}
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
  Result := false;
  for i := 0 to Length(AArray) do begin
  	Result := AArray[i] = ANode;
  	if result then begin
      break;
    end;
  end;
end;

{$ELSE}
function PrivPresent(APStr : string) : boolean;
var
  i : integer;
begin
  i := 1;
  Result := false;
  while (i <= Length(APStr)) and (not Result) do begin
    Result := Pos(APStr[i], FPAccessString) > 0;
    Inc(i);
  end;
end;

{$ENDIF}


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
  Result := 'Из расходов';
  if AList = nil then
    Result := 'Из расходов';

  for i := 0 to AList.Count - 1 do
    if   PVTResourceData(AList[i]).link = ALink then begin
      Result := PVTResourceData(AList[i]).name;
      break;
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

{$IFDEF MULTIORG}
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
    Application.MessageBox('Структура базы некорректна', 'Ошибка в данных', MB_OK or MB_ICONERROR);
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

//
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
{$ELSE}
procedure Cred_Calc(ToPayID : integer; ASum:extended; PONum : integer; ADate : string);
Var
  CredData  : string;
  SumToPay  : extended;
  SumClosed : extended;
  SumDiffer : extended;
begin
  FPMainDataset.SQL.Text := 'SELECT `data`,`summ`,`closed` FROM topay WHERE `index`=' + IntToStr(ToPayID);
  FPMainDataset.Open;
  if FPMainDataset.RecordCount <> 1 then begin
    Application.MessageBox('Структура базы некорректна', 'Ошибка в данных', MB_OK or MB_ICONERROR);
    Exit;
  end;

  CredData  := ReplaceStr(FPMainDataset.FieldByName('data').AsString, '<br>', Chr(13));
  SumToPay  := FPMainDataset.FieldByName('summ').AsExtended;
  SumClosed := FPMainDataset.FieldByName('closed').AsExtended;

  SumDiffer := SumToPay - SumClosed - ASum;
  if SumDiffer > 0  then begin
    CredData := CredData + Chr(13) + ADate + ' оплачено ' + FloatToStr(ASum) + ' по заявке № ' + IntToStr(PONum);
    FPMainDataset.SQL.Text := 'UPDATE `topay` SET `data`=:fCredData,`closed`=:fClosed WHERE `index`=' + IntToStr(ToPayID);
		FPMainDataset.ParamByName('fCredData').AsString := ReplaceStr((CredData), Chr(13), '<br>');
    FPMainDataset.ParamByName('fClosed').AsFloat    := SumClosed + ASum;
    FPMainDataset.ExecSQL;
  end
  else if SumDiffer = 0 then begin
    CredData := CredData + Chr(13) + ADate + ' оплачено ' + FloatToStr(ASum) + ' по заявке № ' + IntToStr(PONum) + Chr(13) + '<b>Обязательство закрыто</b>';
    FPMainDataset.SQL.Text := 'UPDATE `topay` SET `data`=:fCredData,`closed`=-1,`status`="2" WHERE `index`=' + IntToStr(ToPayID);
		FPMainDataset.ParamByName('fCredData').AsString := ReplaceStr((CredData), Chr(13), '<br>');
    FPMainDataset.ExecSQL;
  end;
end;

procedure debt_calc(ToCollectID : integer; ASum:extended; ADate : string);
Var
  DebtData  : string;
  SumToColl : extended;
  SumClosed : extended;
  SumDiffer : extended;
begin
  FPMainDataset.SQL.Text := 'SELECT `data`,`summ`,`closed` FROM tocollect WHERE `index`=' + IntToStr(ToCollectID);
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
    FPMainDataset.SQL.Text := 'UPDATE `tocollect` SET `data`=:fDebtData,`closed`=:fClosed WHERE `index`=' + IntToStr(ToCollectID);
		FPMainDataset.ParamByName('fDebtData').AsString := ReplaceStr((DebtData), Chr(13), '<br>');
    FPMainDataset.ParamByName('fClosed').AsFloat    := SumClosed + ASum;
    FPMainDataset.ExecSQL;
  end
  else if SumDiffer = 0 then begin
    DebtData := DebtData + Chr(13) + ' ' + ADate + ' получена оплата: ' + FloatToStr(ASum) + '.' + Chr(13) + '<b>Обязательство закрыто</b>';
    FPMainDataset.SQL.Text := 'UPDATE `tocollect` SET `data`=:fDebtData,`closed`=-1,`status`="2" WHERE `index`=' + IntToStr(ToCollectID);
		FPMainDataset.ParamByName('fDebtData').AsString := ReplaceStr((DebtData), Chr(13), '<br>');
    FPMainDataset.ExecSQL;
  end;
end;
{$ENDIF}

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

//function CompFondList(tablename : string; level : integer) : TList;
//function CompFondList(tablename : string; level : integer;AWithGroups:boolean=true) : TList;
//function CompFondList(tablename : string; level : integer; AWithGroups : boolean) : TList;
function  CompFondList(tablename : string; level : integer; AWithGroups : boolean; AConsiderApprovedPOs : boolean; APrefix : string) : TList;
var
  T_Dataset    : TZQuery;
  T_TmpDataset : TZQuery;
  tmpstr : string;
  TmpList : TList;
  ResData : PVTResourceData;
  TmpList1 : TList;
  POSum : extended;
begin
  if FPConnection = nil then begin
    result:= nil;
    exit;
  end;
  TmpList := TList.Create;

  T_TmpDataset := TZQuery.Create(nil);
  T_TmpDataset.Connection := FPConnection;

  T_Dataset    := TZQuery.Create(nil);
  T_Dataset.Connection := FPConnection;
  T_Dataset.SQL.Text   := 'SELECT name, link, sub, balance FROM ' + tablename;
  T_Dataset.Open;

  while not T_Dataset.Eof do begin
    tmpstr := T_Dataset.FieldByName('name').AsString;
    if not (AnsiLeftStr(tmpstr, 2) = '<<') then begin
      if AWithGroups or ((not AWithGroups) and (T_Dataset.FieldByName('sub').AsInteger = 0))then begin
        POSum := 0;
        New(ResData);
        ResData.name    := tmpstr;
        ResData.link    := T_Dataset.FieldByName('link').AsString;
        ResData.sub     := T_Dataset.FieldByName('sub').AsInteger;
        ResData.level   := level;
        ResData.fp1sum  := 0;
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
        TmpList1 := CompFondList(T_Dataset.FieldByName('link').AsString, level + 1, AWithGroups, AConsiderApprovedPOs, APrefix);
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
//var
//  tmpstr : string;
begin
//  tmpstr := DateTimeToStr(PIncData(Item1).lastdate);
  if PIncData(Item1).lastdate > PIncData(Item2).lastdate then
    Result := 1
  else if PIncData(Item2).lastdate > PIncData(Item1).lastdate then
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
///  FPMainDataset.Close;
end;

procedure SetCommaAsDecimalSeparator;
 var
   DefLCID: LCID;
 begin
   Application.UpdateFormatSettings := True;
   DefLCID := GetThreadLocale;
   if SetLocaleInfo(DefLCID, LOCALE_SDecimal, ',') then begin
    try
     {$IFDEF FP}
     DecimalSeparator := ',';
     {$ENDIF}
    finally

    end;
   end;
   Application.UpdateFormatSettings := False;
 end;

function EncryptPWD(const Text : string) : string;
var
  tmpStr : string;
  i       : integer;
begin
  tmpStr := XorCrypt(XORKey, Text);
  result := '';
  for i := 1 to Length(tmpStr) do
    result := result + IntToHex(ord(tmpStr[i]), 4);
end;

function DecryptPWD(const Text : string) : string;
var
  tmpText   : string;
  tmpStr    : string;
  i         : integer;
  tmpi      : integer;
begin
  tmpStr := '';
  tmpText := Text;
  SetLength(tmpText, (Length(Text) div 4) * 4);
  for i := 1 to (Length(tmpText) div 4) do begin
    if not TryStrToInt('$' + tmpText[i*4-3]+tmpText[i*4-2]+tmpText[i*4-1]+tmpText[i*4], tmpi) then begin
      Result := '';
      Exit;
    end;
    tmpStr := tmpStr + chr(tmpi);
  end;
  Result := XorCrypt(XORKey, tmpStr);
end;

function XorCrypt(const key: string; const Text : string) : string;
var
  longkey : string;
  i : integer;
  toto : char;
begin
  longkey := '';
  result := '';
  for i := 0 to (length(text) div length(key)) do
    longkey := longkey + key;
  for i := 1 to length(text) do begin
    // XOR itself
    toto := chr((ord(text[i]) xor ord(longkey[i])));
    result := result + toto;
  end;
end; // function

function GetNextThursday(SomeDay : TDateTime): TDateTime;
begin
  While DayOfWeek(SomeDay) <> 5 do
  	SomeDay := SomeDay + 1;
  Result := SomeDay;
end;

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

initialization
  ConIniFileIsRO := false;
	WorkingWithIni := SetUpIniFile;
	SetCommaAsDecimalSeparator;

//  SSLDATAFOLDER   := 'C:/xampp/mysql/bin/';
  SSLDATAFOLDER := ExtractFilePath(Application.ExeName);

end.

