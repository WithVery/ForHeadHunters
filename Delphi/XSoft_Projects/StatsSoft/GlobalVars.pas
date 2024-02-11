unit GlobalVars;

{$DEFINE INSIDECOMPLEX}

interface

uses
  Classes,
  Messages, // for PostMessage
{$IFDEF INSIDECOMPLEX}
  Dialogs,
{$ENDIF}
  IniFiles,
  DateUtils, // for DayOfTheWeek
  SysUtils,
  StrUtils,   // for LeftStr
  Forms, 		 // for Application - to be deleted
  Graphics,
  ZConnection,
  ZDataset;

Const
  NumOfWeeks : array[0..3] of integer = (3, 13, 26, 52);
  // Windows messages
  CM_CHILDFORMCLOSE     	= WM_USER + $100;
  CM_GRAPHREBUILDNEEDED 	= WM_USER + $101;
  CM_NUMOFWEEKSCHANGED  	= WM_USER + $102;
  CM_STATADDEDFROMAS    	= WM_USER + $103;
  CM_STATNAMECHANGED    	= WM_USER + $104;
  CM_GROUPADDEDFROMAS   	= WM_USER + $105;
  CM_STVALCHANGEDFROMAS 	= WM_USER + $106;

  CM_SPP_SETTINGSCHANGED	= WM_USER + $107; // SPP is for StatPrintPreview

  NewStatWinShiftX : integer = 20;
  NewStatWinShiftY : integer = 20;
  // Only these chars are allowed for editing of the grids
  AllowedChars : string = '-0123456789.,';

  // next AppName is to be changed to the new branding of the software
  AppName : string = 'AdminPower'; //  needed to create ini file in user "Application data" folder

  A4Long	: extended	= 297.0;
  A4Short	: extended  = 210.0;
  GoldenProp : extended	= 297.0 / 210.0;
  DefColor	: TColor	= TColor($00D2E9FF);

  // Key for crypting
  XORKey : string = 'akDjFP9z8sdkl5432-908zvlm,543v-z90x85234M,.sfxcvi870q934lsGmDf,gj98sdo65l4265sD09ft;l2k456,mWneRv9s8d75po2k43,.sfdKGjh0q2983452;lk,.gdSnD.lwk435hS9d8fLn43w.5wSO8d7bvslio45.,wmNedfLKqhLrqkWeJrP9w8eRutWEKjHBV0S89L;KWEJR5TP890SDUFL;K5M.O9EF7GVP982J43LKTRWSD';

  CRLF   : String = Chr(13) + Chr(10);

Type
  PStatValue =  ^TStatValue;
  TStatValue = record     //
    Value : extended;
    Date  : TDateTime;
  end;

  PStatDescription = ^TStatDescription;
  TStatDescription = record
    ShortName : string;
    FullName  : string;
  end;

  PAStatValue =  ^TAStatValue;
  TAStatValue = array of TStatValue;

// Type for managing stats in list
  PStat =  ^TStat;
  TStat = record     //
    ID                : integer;
    ShortDescription  : string;
    Values            : TAStatValue; //array of TStatValue;
    FullDescription   : string;
    kind              : integer;     //  0 - stat, 1- group
    Shown             : boolean;
    Inited            : boolean;
    MinYValue         : extended;
    MaxYValue         : extended;
    MinYAuto          : boolean;
    MaxYAuto          : boolean;
    UpsideDown        : boolean;
    SecondGraph       : integer;
  end;

//Type
var
  oid           : string;  // uid of the org - stored in connection.ini - unique for the org

  CurNumOfWeeks : integer; // Number of weeks to display

  OrgID       : integer;
  Dates       : array of TDateTime;
  FFirstChar  : Char; // first character in the editing window
  FLastKey    : Word; // contains last key that was pressed during editing of value

  StatShowMode : boolean; // показывает ГРАФИКИ статистик, а не грид

  NewStatWinX : integer;
  NewStatWinY : integer;

//  iniFile : TIniFile;

  WorkingWithIni	: boolean;               // whether do we work with ini files
  IniFile					: TIniFile;
  ConIniFile			: TIniFile;              // Connection ini file
  ConIniFileIsRO	: boolean;

  WeekStartsAt    : integer;               // the beginning of the week-end

  Connection			: TZConnection;
  MainDataset     : TZQuery;
  TmpDataset      : TZQuery;

  UserLoginName   : string;
  UserFirstName   : string;
  UserMiddleName  : string;
  UserFamilyName  : string;
  UserID          : integer;
  UserPostLink    : integer;
  MainPostID      : integer; // post id of the user logged on

//  UserLoginName, UserFirstName, UserMiddleName, UserFamilyName, UserPriveleges: String;
  UserPriveleges  : String;

  SSLDATAFOLDER   : string;

  function  SetUpIniFile : boolean;

  function  DayToStr(const SomeDay : TDateTime; Delimiter : string = '.') : string;
//  function  GetNearestThursday(SomeDay : TDateTime): TDateTime;
//  function  GetNextThursday(SomeDay : TDateTime): TDateTime;
  function  GetNextWEDay(SomeDay : TDateTime): TDateTime;
  function  GetPrevWEDay(SomeDay : TDateTime): TDateTime;
  function  GetFirstDayOfWeek(SomeDay : TDateTime): TDateTime;

  function  StatValueToDB(var Query: TZQuery; AStatID : integer; DateOfValue: TDate; Value: Extended):boolean;
  function  DeleteStatValueFromDB(var Query: TZQuery; StatID : integer; DateOfValue: TDate):boolean;

  function  EncryptPWD(const Text : string) : string;
  function  DecryptPWD(const Text : string) : string;
  function  XorCrypt(const key: string; const Text : string) : string;
  procedure ShowError(AParent: TComponent; ATitle: string; AErrorCode : integer; AStatus : string; AMessage : string);
  function 	GetShortFIO(LastName, FirstName, MiddleName : string): String;

implementation

uses
  ZDbcIntfs,
  ErrorWindow;

function GetShortFIO(LastName, FirstName, MiddleName: string): String;
begin
	Result := LastName;
  if FirstName <> '' then begin
  	Result := Result + ' ' + LeftStr(FirstName, 1) + '.';
    if MiddleName <> '' then
	  	Result := Result + ' ' + LeftStr(MiddleName, 1) + '.';
	end;
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
      ShowMessage(ConIniFile.FileName);
    end;
  end;
//  ShowMessage(ConIniFile.FileName);
  oid := ConIniFile.ReadString('General', 'uid', '');
end;

function StatValueToDB(var Query: TZQuery; AStatID : integer; DateOfValue: TDate; Value: Extended):boolean;
var
  OldDateSeparator : WideChar;
  OldShortDateFormat : string;
begin
  result := true;
  OldDateSeparator := DateSeparator;
  OldShortDateFormat := ShortDateFormat;
  DateSeparator := '-';
  ShortDateFormat := 'yyyy/mm/dd';

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

  DateSeparator   := OldDateSeparator;
  ShortDateFormat := OldShortDateFormat;
end;

function DeleteStatValueFromDB(var Query: TZQuery; StatID : integer; DateOfValue: TDate):boolean;
var
  OldDateSeparator : WideChar;
  OldShortDateFormat : string;
begin
  result := true;
  OldDateSeparator := DateSeparator;
  OldShortDateFormat := ShortDateFormat;
  DateSeparator := '-';
  ShortDateFormat := 'yyyy/mm/dd';
  Query.SQL.Text  :=  'DELETE FROM statvalues WHERE StatID=' + IntToStr(StatID) + ' AND Date="' + DateToStr(DateOfValue)+'"';

  try
    Query.ExecSQL;
  except
    on E: EZSQLException do begin
      ShowError(Application.MainForm, 'Ошибка удаления значения из базы.', e.ErrorCode, e.StatusCode, e.Message);
      result := false;
    end;
  end;

  DateSeparator   := OldDateSeparator;
  ShortDateFormat := OldShortDateFormat;
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

function GetFirstDayOfWeek(SomeDay : TDateTime): TDateTime;
begin
  Result := GetPrevWEDay(SomeDay) + 1;
end;

function GetPrevWEDay(SomeDay : TDateTime): TDateTime;
begin
  Result := GetNextWEDay(SomeDay) - 7;
end;

function GetNextWEDay(SomeDay : TDateTime): TDateTime;
begin
  while DayOfTheWeek(SomeDay) <> WeekStartsAt do SomeDay := SomeDay + 1;
//  repeat SomeDay := SomeDay + 1 Until DayOfTheWeek(SomeDay) = WeekStartsAt;
  Result := SomeDay;
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
  result  := '';
  for i := 0 to (length(text) div length(key)) do
    longkey := longkey + key;
  for i := 1 to length(text) do begin
    // XOR itself
    toto := chr((ord(text[i]) xor ord(longkey[i])));
    result := result + toto;
  end;
end; // function

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


initialization
  OrgID := 1;
//  Values := TList.Create;
  NewStatWinX := 0;
  NewStatWinY := 0;

  WeekStartsAt := 3 + 1;  // set it as a thursday (3 for Thursday (from MySQL point of view) + 1 which gives 4 for DayOfTheWeek(Thursday)

  ConIniFileIsRO := false;
	WorkingWithIni := SetUpIniFile;

  SSLDATAFOLDER  := ExtractFilePath(Application.ExeName);

end.
