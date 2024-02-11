unit POsExportToExcelWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  //DBTables, // for TDatabase
  DB, // for ftInteger
  GlobalVars, // for resource strings
  Dialogs, StdCtrls, ExtCtrls, sLabel, Mask, sMaskEdit, sCustomComboEdit, sTooledit, sEdit, sSpinEdit, sPanel, sGroupBox,
  //ADODB, // not starter feature
  sComboBox;

type
  SQLHWnd = LongWord;
  SQLChar = Char;
  PSQLChar = ^SQLChar;
  SQLBOOL = WordBool;
  UDword = LongInt;
  PUDword = ^UDword;
  SQLSmallint = Smallint;
  SQLReturn = SQLSmallint;

function SQLConfigDataSource (
    hwndParent:     SQLHWnd;
    fRequest:       WORD;
    lpszDriver:     PChar;
    lpszAttributes: PChar
  ): SQLBOOL; {$IFDEF MSWINDOWS} stdcall {$ELSE} cdecl {$ENDIF};
  external 'odbccp32.dll' name 'SQLConfigDataSourceW';

function SQLInstallerError (
    iError:           WORD;
    pfErrorCode:      PUDword;
    lpszErrorMsg:     PChar;
    cbErrorMsgMax:    WORD;
    pcbErrorMsg:      PWORD
  ): SQLReturn; {$IFDEF MSWINDOWS} stdcall {$ELSE} cdecl {$ENDIF};
  external 'odbccp32.dll' name 'SQLInstallerErrorW';

const
  SQL_MAX_MESSAGE_LENGTH = 4096;

  ODBC_ADD_DSN     = 1;         // Add data source
  ODBC_CONFIG_DSN  = 2;         // Configure (edit) data source
  ODBC_REMOVE_DSN  = 3;         // Remove data source

  ODBC_ADD_SYS_DSN    = 4;          // add a system DSN
  ODBC_CONFIG_SYS_DSN   = 5;        // Configure a system DSN
  ODBC_REMOVE_SYS_DSN   = 6;        // remove a system DSN
  ODBC_REMOVE_DEFAULT_DSN   = 7;    // remove the default DSN

	// PO types
  potSubmitted = 0;
  potRejected  = 1;
  potApproved  = 2;
  potPaid      = 3;

type
  TPOsExportToExcelForm = class(TForm)
(*
    gbDates: TsGroupBox;
    sPanel1: TsPanel;
    teVal2: TsTimePicker;
    deVal2: TsDateEdit;
    lblVal2: TsLabel;
    teVal1: TsTimePicker;
    deVal1: TsDateEdit;
    slblVal1: TsLabel;
    gbPOs: TRadioGroup;
    btnExport: TButton;
    btnCancel: TButton;
    sd: TSaveDialog;
    cbOpenFileAfterExport: TCheckBox;
    db: TDatabase;
    adb: TADOConnection;
    q1: TADOQuery;
    gbOrg: TGroupBox;
    OrgCombo: TsComboBox;
*)
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OrgComboChange(Sender: TObject);
  private
    { Private declarations }
   // odbcdb : TDatabase;
//    q1: TQuery;
    sCurOPrefix : string;
  public
    { Public declarations }
    OrgsList        : TList;

  end;

//var
//  POsExportToExcelForm: TPOsExportToExcelForm;

implementation

{$R *.dfm}

uses
	ShellApi, // for ShellExecute
	DateUtils;
procedure TPOsExportToExcelForm.btnExportClick(Sender: TObject);
const
 scAlias : string = 'FPPO2XLS';
var
  strAttributes: string;
  pfErrorCode: UDword;
  errMsg: PChar;
  ADriver  : string;
  AFileName : string;

  POType : integer;
  FromDate : TDateTime;
  ToDate   : TDateTime;

  j : integer;
  polink : string;
  sTable : string;

  FondList : TList;

begin
(*
	POType := gbPOs.ItemIndex;

	sd.Title := 'Выберите файл';
  sd.Filter := 'Файлы Excel|*.xls';
  sd.DefaultExt := 'xls';
  sd.FilterIndex := 1;
  if sd.Execute then AFileName := sd.FileName else exit;
	ADriver := 'Microsoft Excel Driver (*.xls)';
	if FileExists(AFileName) then begin
  	if not DeleteFile(AFileName) then begin
    	Application.MessageBox(PWideChar(rsFileCanBeInUse), PWideChar(rsFileAccessError), MB_ICONERROR or MB_OK); exit;
    end
  end;

// pull auxilary data
	FondList := TList.Create;
	FondList := CompFondList('fond', 0, CFL_IGNOREGROUPS, CFL_IGNOREPOS, '', true);

  // connect to ODBC database
  try
    adb.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + AFileName + ';Extended Properties=Excel 8.0;';
    adb.Connected := true;
  except
  	on e:exception do begin
    	ShowError(Self, 'Ошибка при соедниении с ODBC', 0, '', e.Message);
      Exit;
    end;
  end;

  q1.Connection := adb;

  polink := sCurOPrefix + 'po';
//  FPMainDataset.SQL.Text := 'SELECT`index`,`date`,`re`,`sumr`,`bycash` FROM po';
  FPMainDataset.SQL.Text := 'SELECT ' + polink + '.*,Left(FirstName,1)AS FName,Left(MiddleName,1)AS MName,allusers.FamilyName FROM`' + polink + '`INNER JOIN`allusers`ON ' + polink + '.origin=allusers.login WHERE';

  if (POType = potSubmitted) or (POType = potRejected) then begin
  	if POType = potSubmitted then
	  	sTable := 'Vistavlennie'
    else
	  	sTable := 'Otklonennie';
		q1.SQL.Text := 'CREATE TABLE '+ sTable +'(Num NUMBER, Data DATETIME, Tema TEXT, Summa CURRENCY, Tip TEXT, Avtor TEXT)';
  	if POType = potSubmitted then
		  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + '`status`<=0'
    else
	  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + '`status`=1';
  end
  else if POType = potApproved then begin
  	sTable := 'Odobrennie';
		q1.SQL.Text := 'CREATE TABLE '+ sTable +'(Num NUMBER,Data DATETIME,Tema TEXT,Summa CURRENCY,Odobreno CURRENCY,Tip TEXT,Avtor TEXT,Istochnik TEXT)';
		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + '`status` in (2,4)';
  end
  else if POType = potPaid then begin
  	sTable := 'Oplachennie';
		q1.SQL.Text := 'CREATE TABLE '+ sTable +'(Num NUMBER,Data DATETIME,Tema TEXT,FP NUMBER,DataOplaty DATETIME,Oplacheno CURRENCY,Tip TEXT,Avtor TEXT,Istochnik TEXT)';
	  FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + '`status` in (3,5)';
  end;

  try
		q1.ExecSQL;
  except
  	on e:exception do begin
    	ShowError(Self, 'Невозможно создать таблицу в файле', 0, '', e.Message);
      Exit;
    end;
  end;


  FromDate := deVal1.Date + teVal1.Time;
  ToDate   := deVal2.Date + teVal2.Time;

  if (FromDate > 0) or (ToDate > 0) then begin
	  if FromDate > 0 then begin
  		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND date>:ffd';
      FPMainDataset.ParamByName('ffd').AsDateTime := FromDate;
	  end;
	  if ToDate > 0 then begin
  		FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ' AND date<:ftd';
      FPMainDataset.ParamByName('ftd').AsDateTime := ToDate;
	  end;
  end;

  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
  	if (POType = potSubmitted) or(POType = potRejected) then begin
			q1.SQL.Text := 'INSERT INTO ' + sTable +'(Num,Data,Tema,Summa,Tip,Avtor)VALUES(:fNum,:fData,:fTema,:fSumma,:fTip,:fAvtor)';
      q1.Parameters.ParamByName('fNum').Value   := FPMainDataset.FieldByName('index').AsInteger;
    	q1.Parameters.ParamByName('fData').Value := FPMainDataset.FieldByName('date').AsDateTime;
	    q1.Parameters.ParamByName('fTema').Value := FPMainDataset.FieldByName('re').AsString;
  	  q1.Parameters.ParamByName('fSumma').Value := FPMainDataset.FieldByName('sumr').AsFloat;
    	if FPMainDataset.FieldByName('bycash').AsInteger = 0 then
	    	q1.Parameters.ParamByName('fTip').Value := rsByBank
	    else
		    q1.Parameters.ParamByName('fTip').Value := rsByCash;
    	q1.Parameters.ParamByName('fAvtor').Value := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FName').AsString, FPMainDataset.FieldByName('MName').AsString);
    end
	  else if POType = potApproved then begin
			q1.SQL.Text := 'INSERT INTO ' + sTable +'(Num,Data,Tema,Summa,Odobreno,Tip,Avtor,Istochnik)VALUES(:fNum,:fData,:fTema,:fSumma,:fOdobreno,:fTip,:fAvtor,:fIstochnik)';
  	  q1.Parameters.ParamByName('fNum').Value   := FPMainDataset.FieldByName('index').AsInteger;
    	q1.Parameters.ParamByName('fData').Value := FPMainDataset.FieldByName('date').AsDateTime;
	    q1.Parameters.ParamByName('fTema').Value := FPMainDataset.FieldByName('re').AsString;
  	  q1.Parameters.ParamByName('fSumma').Value := FPMainDataset.FieldByName('sumr').AsFloat;
  	  q1.Parameters.ParamByName('fOdobreno').Value := FPMainDataset.FieldByName('suma').AsFloat;
    	if FPMainDataset.FieldByName('bycash').AsInteger = 0 then
	    	q1.Parameters.ParamByName('fTip').Value := rsByBank
	    else
		    q1.Parameters.ParamByName('fTip').Value := rsByCash;
    	q1.Parameters.ParamByName('fAvtor').Value := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FName').AsString, FPMainDataset.FieldByName('MName').AsString);
			q1.Parameters.ParamByName('fIstochnik').Value := GetNameOfFondByLink(FondList, FPMainDataset.FieldByName('fond').AsString);
  	end
	  else if POType = potPaid then begin
			q1.SQL.Text := 'INSERT INTO ' + sTable +'(Num,Data,Tema,FP,DataOplaty,Oplacheno,Tip,Avtor,Istochnik)VALUES(:fNum,:fData,:fTema,:fFP,:fDataOplaty,:fOplacheno,:fTip,:fAvtor,:fIstochnik)';
  	  q1.Parameters.ParamByName('fNum').Value   := FPMainDataset.FieldByName('index').AsInteger;
    	q1.Parameters.ParamByName('fData').Value := FPMainDataset.FieldByName('date').AsDateTime;
	    q1.Parameters.ParamByName('fTema').Value := FPMainDataset.FieldByName('re').AsString;
      q1.Parameters.ParamByName('fFP').DataType := ftInteger;
//      q1.Parameters.ParamByName('fFP').
      if FPMainDataset.FieldByName('fp').AsInteger > 0 then
	    	q1.Parameters.ParamByName('fFP').Value := FPMainDataset.FieldByName('fp').AsInteger;
    	q1.Parameters.ParamByName('fDataOplaty').Value := FPMainDataset.FieldByName('pd').AsDateTime;
  	  q1.Parameters.ParamByName('fOplacheno').Value := FPMainDataset.FieldByName('sump').AsFloat;
    	if FPMainDataset.FieldByName('bycash').AsInteger = 0 then
	    	q1.Parameters.ParamByName('fTip').Value := rsByBank
	    else
		    q1.Parameters.ParamByName('fTip').Value := rsByCash;
    	q1.Parameters.ParamByName('fAvtor').Value := GetShortFIO(FPMainDataset.FieldByName('FamilyName').AsString, FPMainDataset.FieldByName('FName').AsString, FPMainDataset.FieldByName('MName').AsString);
			q1.Parameters.ParamByName('fIstochnik').Value := GetNameOfFondByLink(FondList, FPMainDataset.FieldByName('fond').AsString);
  	end;


	  try
  	  q1.ExecSQL;
    	FPMainDataset.Next;
	  except
  		on e:exception do begin
    		ShowError(Self, 'Невозможно создать таблицу в файле', 0, '', e.Message);
	      Exit;
  	  end;
	  end;
  end;

  adb.Connected := false;
//  odbcdb.Connected := false;

  //q1.Destroy;
  //  odbcdb.Destroy;

  if cbOpenFileAfterExport.Checked then begin
  	j := ShellExecute(Handle, 'open', PWideChar(AFileName), nil, nil, SW_SHOWNORMAL);
		if j <= 32 then begin
    	ShowError(Self, 'Во время открытия файла "' + AFileName + '" произошла ошибка.', j, '', '');
    end;
  end
  else begin
    Application.MessageBox(PWideChar(rsExportCompleted), PWideChar(rsPOExport), MB_ICONINFORMATION or MB_OK);
  end;

  FondList.Free;
*)
end;

procedure TPOsExportToExcelForm.FormCreate(Sender: TObject);
begin
  OrgsList := TList.Create;
end;

procedure TPOsExportToExcelForm.FormDestroy(Sender: TObject);
begin
  OrgsList.Free;
end;

procedure TPOsExportToExcelForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then ModalResult := mrCancel;
end;

procedure TPOsExportToExcelForm.FormShow(Sender: TObject);
begin
(*
	gbPOs.ItemIndex := 0;

  deVal2.Date := DateOf(now);
  teVal2.Date := TimeOf(now);

   OrgComboChange(Sender);
*)
end;

procedure TPOsExportToExcelForm.OrgComboChange(Sender: TObject);
var
  ResData : PVTResourceData;
  i         : integer;
  Str       : string;
begin
(*
  if OrgCombo.ItemIndex < 0 then
    Exit;

  ResData := PVTResourceData(OrgsList[OrgCombo.ItemIndex]);
  sCurOPrefix := ResData.prefix;
*)

end;

end.
