unit LoginWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, acPNG, ExtCtrls, StdCtrls, ErrorWindow, ZConnection, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, jpeg, sPanel, sLabel,
	GlobalVars,
	StrUtils,
  DECUtil, DECCipher, DECHash, DECFmt,
  MainPad,
  sGroupBox, sButton, sEdit, Buttons, sBitBtn, sCheckBox, sSkinManager, Menus, DKLang;

const
  ACipherClass : TDECCipherClass = TCipher_Rijndael;
  ACipherMode  : TCipherMode = cmCBCx;
  AHashClass   : TDECHashClass = THash_Whirlpool;
  ATextFormat  : TDECFormatClass = TFormat_Mime64;
  AKDFIndex    : LongWord = 1;


  ba1         : integer = 4;
  ba2         : integer = 8;

type

  TLogInForm = class(TForm)
    sPanel2: TsPanel;
    Image1: TImage;
    sPanel1: TsPanel;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    gbProps: TsGroupBox;
    sLabelFX3: TsLabelFX;
    sLabelFX4: TsLabelFX;
    sLabelFX5: TsLabelFX;
    PortLabel: TsLabelFX;
    ShowPropButton: TsButton;
    DBBase: TsEdit;
    sLabelFX6: TsLabelFX;
    OKButton: TsBitBtn;
    UserLoginEdit: TsEdit;
    UserPasswordEdit: TsEdit;
    CancelButton: TsBitBtn;
    SaveSettingsButton: TsBitBtn;
    ServerPortEdit: TsEdit;
    ServerNameEdit: TsEdit;
    DBUserEdit: TsEdit;
    DBPasswordEdit: TsEdit;
    sSkinManager1: TsSkinManager;
    EncryptCheckBox: TsCheckBox;
    lc: TDKLanguageController;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowPropButtonClick(Sender: TObject);
    procedure SaveSettingsButtonClick(Sender: TObject);
    procedure UserLoginEditKeyPress(Sender: TObject; var Key: Char);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UserPasswordEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    PropShown         : boolean;
    SmallHeight       : integer;
    BigHeight         : integer;
    //Connection				: TZConnection;
    Dataset						: TZQuery;
    TmpDataset				: TZQuery;

    ps : string; // param string - if it's not '' then we don't need login window and try to show main form directly

    procedure	SaveConIniParams;
    function Decrypt(const AText: String; const APassword: String): String; overload;
  public
    { Public declarations }
  end;

var
  LogInForm: TLogInForm;

  DBPassword: String;
  LoginSuccessful: Boolean;
  Connection: TZConnection;
//  TmpDataset: TZQuery;
  UserLoginName, UserFirstName, UserMiddleName, UserFamilyName, UserPriveleges: String;
  UserAppear: Byte;
  UserPassword: String;
//  UserPostLink, SUserID: Integer;
  UserPostLink: Integer;

implementation

{$R *.dfm}
uses
	ZDbcIntfs;   // for EZSQLException


function TLoginForm.Decrypt(const AText: String; const APassword: String): String;
var
  ASalt: Binary;
  AData: Binary;
  ACheck: Binary;
  APass: Binary;
  ALen: Integer;
begin
  with ValidCipher(ACipherClass).Create, Context do begin
    try
      ASalt := ValidFormat(ATextFormat).Decode(AText);
      ALen := Length(ASalt) - 16 - BufferSize;
      AData := System.Copy(ASalt, 17, ALen);
      ACheck := System.Copy(ASalt, ALen + 17, BufferSize);
      SetLength(ASalt, 16);
      APass := ValidHash(AHashClass).KDFx(APassword[1], Length(APassword) * SizeOf(APassword[1]), ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);
      Mode := ACipherMode;
      Init(APass);
      SetLength(Result, ALen div SizeOf(AText[1]));
      Decode(AData[1], Result[1], ALen);
      if ACheck <> CalcMAC then
        raise Exception.Create('Invalid data');
    finally
      Free;
      ProtectBinary(ASalt);
      ProtectBinary(AData);
      ProtectBinary(ACheck);
      ProtectBinary(APass);
    end;
  end; // with
end;

procedure TLogInForm.SaveSettingsButtonClick(Sender: TObject);
begin
  SaveConIniParams;
end;

procedure TLogInForm.ShowPropButtonClick(Sender: TObject);
begin
  if not PropShown then begin
    ShowPropButton.Caption := '<<';
    Self.Width 			:= BigHeight;
    gbProps.Visible	:= true;
  end
  else begin
    ShowPropButton.Caption := '>>';
    Self.Width 			:= SmallHeight;
    gbProps.Visible	:= false;
  end;
  PropShown := not PropShown;
end;

procedure TLogInForm.UserLoginEditKeyPress(Sender: TObject; var Key: Char);
begin
	if (Key = chr(13)) and (UserLoginEdit.Text <> '') then begin
			Key:= #0;
			UserPasswordEdit.SetFocus
  end;
end;

procedure TLogInForm.UserPasswordEditKeyPress(Sender: TObject; var Key: Char);
begin
	if (Key = chr(13)) and (UserLoginEdit.Text <> '') and (UserPasswordEdit.Text <> '')  then begin
	  Key:= #0;
    OKButtonClick(Sender);
  end;
end;

procedure	TLogInForm.SaveConIniParams;
var
	TmpInt : integer;
begin
	TryStrToInt(ServerPortEdit.Text, TmpInt);
  try
		ConIniFile.WriteInteger('General', 'Port', 		 TmpInt);
		ConIniFile.WriteString('General',  'Server', 	 ServerNameEdit.Text);
		ConIniFile.WriteString('General',  'user', 		 DBUserEdit.Text);
		ConIniFile.WriteString('General',  'pwd', 		 DBPasswordEdit.Text);
		ConIniFile.WriteString('General',  'database', DBBase.Text);
  Except
  	on E : EIniFileException do begin
    	ConIniFileIsRO := true;
      SaveSettingsButton.Enabled := false;
    end;
  end;
end;

procedure TLogInForm.CancelButtonClick(Sender: TObject);
begin
	Close;
end;

procedure TLogInForm.FormCreate(Sender: TObject);
var
  k  : string;
  s  : string;
  pc : integer;
  pt : integer;
  i  : integer;
  Error : boolean;
begin

	LoadResourceStrings(1049);

  // Initializing the connections
  Connection 	:= TZconnection.Create(nil);
  Dataset 		:= TZQuery.Create(Self);
  TmpDataset 	:= TZQuery.Create(Self);

{$IFDEF RWLO}
	EncryptCheckBox.Visible := false;
{$ENDIF}

  // check wether we've been launched from command line
  pc := ParamCount;
  if pc > 0 then begin
    Error := false;
    ps := ParamStr(1);
    k := MidStr(oid, trunc(sqrt(ba1)) + ba2 * 2, ba2 * 2 + 2) +  MidStr(oid, trunc(sqrt(ba1)), ba2 * 2 + 2);
    s := Decrypt(ps, k);
    // setting up the connection
    Connection.Protocol	:= 'mysql';
    Connection.LibraryLocation:=ExtractFilePath(Application.ExeName)+'libmariadb.dll';
    Connection.ClientCodepage := rsCharsetSetUp;

    // DB Server adress
    i := Pos(';', s);
    if i = 0 then begin
      ShowMessage(rsIncorrectData);
    end;
    Connection.HostName := LeftStr(s, i - 1);
    s := MidStr(s, i + 1, Length(s));

    // DB server port
    i := Pos(';', s);
    if i = 0 then begin
      ShowMessage(rsIncorrectData);
    end;

    TryStrToInt(LeftStr(s, i - 1), pt);
    Connection.Port			:= pt;
    s := MidStr(s, i + 1, Length(s));

    // DB Username adress
    i := Pos(';', s);
    if i = 0 then begin
      ShowMessage(rsIncorrectData);
    end;
    Connection.User			:= LeftStr(s, i - 1);
    s := MidStr(s, i + 1, Length(s));

    // DB pwd
    i := Pos(';', s);
    if i = 0 then begin
      ShowMessage(rsIncorrectData);
    end;
    Connection.Password := LeftStr(s, i - 1);
    s := MidStr(s, i + 1, Length(s));

    // DB name
    i := Pos(';', s);
    if (i = 0) then begin
      if s = '' then begin
        ShowMessage(rsIncorrectDataRcvd);
        Connection.Database	:= '';
        Exit;
      end
      else begin
        Connection.Database	:= s;
      end;
    end
    else begin
      Connection.Database := LeftStr(s, i - 1);
      s := MidStr(s, i + 1, Length(s));
    end;

//  Connection.Database	:= s;
    // Encryption flag
//    ShowMEssage(s);
    i := Pos(';', s);
    if i = 0 then begin
      encconn := false;
    end
    else begin
      TryStrToInt(LeftStr(s, i - 1), pt);
      encconn := boolean(pt);
    end;

    SetUpEncryption(Connection);

    try
      Connection.Connect;
    except
 	    on e: EZSQLException do begin
	      ShowError(Self, rsSrvConnErr, e.ErrorCode, e.StatusCode, e.Message);
        Halt;
      end;
    end;

    // here goes the launch of main form directly
    Dataset.Connection		:= Connection;
    TmpDataset.Connection	:= Connection;

    //Dataset.SQL.Text := 'SET CHARSET ' + rsCharsetSetUp;
    Dataset.SQL.Text := 'SET CHARSET cp1251';
    Dataset.ExecSQL;

    Dataset.SQL.Text:= 'SET old_passwords=FALSE';
    Dataset.ExecSQL;

  // check the
    Dataset.SQL.Text := 'SELECT UserID,FirstName,MiddleName,FamilyName,Password FROM users WHERE Login=:fLogin AND PASSWORD(:fPWD)=Password';
    Dataset.ParamByName('fLogin').AsString := ParamStr(2);
    Dataset.ParamByName('fPwd').AsString 	 := ParamStr(3);
    try
      Dataset.Open;
    except
	  	on e: EZSQLException do begin
		  	ShowError(Self, rsAuthorError, e.ErrorCode, e.StatusCode, e.Message);
	      error := true;
      end;
    end;

    if not Error then begin
      if Dataset.RecordCount = 0 then begin
		  	ShowError(Self, rsAuthorError, 0, '', rsCheckLoginPwd);
      end
      else begin // launch the FP form
         // here goes the MainPad form initilization ***!***

        MainStatForm := TMainStatForm.Create(nil);
        with MainStatForm do begin
          Parent := nil;
          with Dataset do begin
	          Caption	:= 	rsStatsUser + GetShortFIO(FieldByName('FamilyName').AsString, FieldByName('FirstName').AsString, FieldByName('MiddleName').AsString);
          end;

          FPConnection  := Connection; // AConnection;
          SUserID  			:= Dataset.FieldByName('UserID').AsInteger; //AUserID;
          InitDB;
          ShowModal;
          Destroy;
        end;
        Halt;
      end;
    end;

    Connection.Free;
    TmpDataset.Free;

    Connection 	:= nil;
    TmpDataset 	:= nil;
    Halt;
  end;

{$IFDEF RWLO}
  CheckParamsAndHalt;
{$ENDIF}

	// ”становка и запоминание начальных размеров
	PropShown 	:= false;
	BigHeight   := Self.Width;
	SmallHeight := ShowPropButton.Left + ShowPropButton.Width + 148;
	Self.Width 	:= SmallHeight;

  // pulling the connection data
  if WorkingWithIni then begin
		ServerPortEdit.Text := IntToStr(ConInifile.ReadInteger('General', 'Port', 3306));
		ServerNameEdit.Text := ConIniFile.ReadString('General', 'Server', '127.0.0.1');
		DBUserEdit.Text     := ConIniFile.ReadString('General', 'user', 'root');
		DBPasswordEdit.Text := ConIniFile.ReadString('General', 'pwd', '');
		DBBase.Text         := ConIniFile.ReadString('General', 'database', 'ap');
  end
  else begin
		ServerPortEdit.Text := IntToStr(3306);
		ServerNameEdit.Text := '127.0.0.1';
		DBUserEdit.Text     := 'root';
		DBPasswordEdit.Text := '';
		DBBase.Text         := 'ap';
  end;

  gbProps.Visible	:= false;
  if not ConIniFileIsRO then begin
    SaveConIniParams;
  end
  else begin
    SaveSettingsButton.Enabled := false;
  end;
end;

procedure TLogInForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
//    VK_ESCAPE : begin ModalResult := mrCancel; Key := 0; end;
    VK_ESCAPE : begin Close; Key := 0; end;
  end;
end;

procedure TLogInForm.OKButtonClick(Sender: TObject);
var
	PwdStr 				: string;
  ErrorMessage  : string;
	ti 						: integer;
begin
{$IFDEF RWLO}
  CheckParamsAndHalt;
{$ELSE}
	EncConn := false; // true; //EncryptCheckBox.Checked;
{$ENDIF}

	Connection.Protocol	:= 'mysql';
  Connection.LibraryLocation:=ExtractFilePath(Application.ExeName)+'libmariadb.dll';
  Connection.HostName := ServerNameEdit.Text;
  Connection.User			:= DBUserEdit.Text;
  Connection.Port			:= StrToInt(ServerPortEdit.Text); //!!!
  Connection.Password	:= DBPasswordEdit.Text;
  Connection.Database	:= DBBase.Text;
  Connection.ClientCodepage := rsCharsetSetUp;

  SetUpEncryption(Connection);

  try
    Connection.Connect;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, rsSrvConnErr, e.ErrorCode, e.StatusCode, e.Message);
      Exit;
    end;
  end;

  Dataset.Connection		:= Connection;
  TmpDataset.Connection	:= Connection;

//  Dataset.SQL.Text := 'SET CHARSET ' + rsCharsetSetUp;
  Dataset.SQL.Text := 'SET CHARSET cp1251' ;
  Dataset.ExecSQL;

  Dataset.SQL.Text:= 'SET old_passwords=FALSE';
  Dataset.ExecSQL;

  try
	  Dataset.SQL.Text:= 'SHOW VARIABLES LIKE "connect_timeout"';
  	Dataset.Open;
    ti := Dataset.FieldByName('Value').AsInteger;
    if ti > 0 then begin
      cto := ti * 1000;
    end;
  except
 	  on e: EZSQLException do begin
	    ShowError(Self, rsIncorrectDataRcvd, e.ErrorCode, e.StatusCode, e.Message);
      Exit;
    end;
  end;

//  Dataset.SQL.Text:= 'SHOW STATUS LIKE "%ssl_cipher%"';
//  Dataset.Open;
//  ErrorMessage := Dataset.FieldByName('Variable_name').AsString;
//  ErrorMessage := Dataset.FieldByName('Value').AsString;

  // check the
  Dataset.SQL.Text := 'SELECT UserID,FirstName,MiddleName,FamilyName,Password FROM users WHERE Login=:fLogin';
  Dataset.ParamByName('fLogin').AsString 	:= UserLoginEdit.Text;
  Dataset.Open;
  if Dataset.RecordCount = 0 then begin
  	ErrorMessage := rsAuthorError;
    ErrorForm := TErrorForm.Create(nil);
    with ErrorForm do begin
    	ErrorExplanationMemo.Text := rsSrvConnErr;
      ErrorMemo.Text := ErrorMessage;
      ShowModal;
      Free;
    end;
    Connection.Disconnect;
    OKButton.Down := false;
    Exit;
  end;
  PwdStr := Dataset.FieldByName('Password').AsString;
  TmpDataset.SQL.Text := 'SELECT PASSWORD(:fPwd) as PWD';
  TmpDataset.ParamByName('fPwd').AsString := UserPasswordEdit.Text;
  TmpDataset.Open;
  if PwdStr <> TmpDataset.FieldByName('PWD').AsString then begin
	  ErrorMessage := rsAuthorError;
  	ErrorForm := TErrorForm.Create(nil);
    with ErrorForm do begin
	    ErrorExplanationMemo.Text := rsSrvConnErr;
  	  ErrorMemo.Text := ErrorMessage;
    	ShowModal;
      Free;
	  end;
  	Connection.Disconnect;
    OKButton.Down := false;
	  Exit;
  end;
  Visible := false;

  MainStatForm := TMainStatForm.Create(nil);
  with MainStatForm do begin
    Parent := nil;
    with Dataset do begin
	    Caption	:= 	rsStatsUser + GetShortFIO(FieldByName('FamilyName').AsString, FieldByName('FirstName').AsString, FieldByName('MiddleName').AsString);
    end;

    FPConnection  := Connection; // AConnection;
    SUserID  			:= Dataset.FieldByName('UserID').AsInteger; //AUserID;
    InitDB;
    ShowModal;
    Destroy;
  end;

  Connection.Free;
  TmpDataset.Free;

  Connection 	:= nil;
  TmpDataset 	:= nil;

  ModalResult := mrCancel;

	Close;
end;

end.
