unit NewStatWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, acAlphaImageList, Buttons, sBitBtn, sCheckBox,
  sEdit, sMemo, sLabel, sComboBox, ExtCtrls, sPanel, sGroupBox, DKLang;

type
  TNewStatForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ShortStatNameEdit: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    MinYEdit: TsEdit;
    MinAutoCheckBox: TsCheckBox;
    MaxYEdit: TsEdit;
    MaxAutoCheckBox: TsCheckBox;
    FullStatNameMemo: TsMemo;
    UDCheckBox: TsCheckBox;
    OrgCombo: TsComboBox;
    OrgLabel: TsLabel;
    sPanel1: TsPanel;
    TopGroupBox: TsGroupBox;
    BottomGroupBox: TsGroupBox;
    cmbUsers: TsComboBox;
    lblUSers: TsLabel;
    lc: TDKLanguageController;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MinAutoCheckBoxClick(Sender: TObject);
    procedure MaxAutoCheckBoxClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UDCheckBoxClick(Sender: TObject);
    procedure MinYEditChange(Sender: TObject);
    procedure MaxYEditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OrgComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbUsersChange(Sender: TObject);
  private
    { Private declarations }
    CancelPressed : boolean;
    Oldstring : string;
  public
    { Public declarations }
    CurUserID : integer;
  end;

//var
//  NewStatForm: TNewStatForm;

implementation

{$R *.dfm}

//uses PostsAndStaff;
uses
  ZDbcIntfs, // for EZSQLException
	GlobalVars;

procedure TNewStatForm.ButtonOKClick(Sender: TObject);
begin
  if not MinAutoCheckBox.Checked and not MaxAutoCheckBox.Checked then
    if StrToFloat(MinYEdit.Text) >= StrToFloat(MaxYEdit.Text) then begin
      if not UDCheckBox.Checked then // if the graph is normal
        ShowMessage(rsLowMarginIsLessThanHigh)
      else
        ShowMessage(rsHighMarginIsMoreThanLow);
      MinYEdit.SetFocus;
      Exit;
    end;
  ModalResult := mrOK;
end;

procedure TNewStatForm.cmbUsersChange(Sender: TObject);
begin
 if cmbUsers.ItemIndex > -1 then
	CurUserID := integer(cmbUsers.Items.Objects[cmbUsers.ItemIndex]);
end;

procedure TNewStatForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (ModalResult <> mrOK) or (Trim(ShortStatNameEdit.Text) <> '');
end;

procedure TNewStatForm.FormCreate(Sender: TObject);
begin
  CurUserID := -1;
end;

procedure TNewStatForm.FormDestroy(Sender: TObject);
begin
  ButtonOK.Enabled := Trim(ShortStatNameEdit.Text) <> '';
end;

procedure TNewStatForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ButtonOK.Enabled := Trim(ShortStatNameEdit.Text) <> '';
end;

procedure TNewStatForm.FormShow(Sender: TObject);
begin
	OrgComboChange(Sender);
	cmbUsersChange(Sender);
end;

procedure TNewStatForm.MaxAutoCheckBoxClick(Sender: TObject);
begin
  MaxYEdit.Enabled := not MaxAutoCheckBox.Checked;
  if MaxAutoCheckBox.Checked then MaxYEdit.Text := '0';
end;

procedure TNewStatForm.MaxYEditChange(Sender: TObject);
var
  tmpValue    : extended;
  tmpSelStart : integer;
begin
  if not ((MaxYEdit.Text='+') or (MaxYEdit.Text='') or (MaxYEdit.Text='-')) then begin
    tmpSelStart := MaxYEdit.SelStart;
    if TryStrToFloat(MaxYEdit.Text, tmpValue) then begin
      Oldstring := MaxYEdit.Text;
    end
    else begin
      Beep;
      MaxYEdit.Text := Oldstring;
      MaxYEdit.SelStart := tmpSelStart-1;
    end;
  end
  else begin
    Oldstring := MaxYEdit.Text;
  end;
end;

procedure TNewStatForm.MinAutoCheckBoxClick(Sender: TObject);
var
  TmpStr : string;
begin
  MinYEdit.Enabled := not MinAutoCheckBox.Checked;
  if MinAutoCheckBox.Checked then MinYEdit.Text := '0';
end;

procedure TNewStatForm.MinYEditChange(Sender: TObject);
var
  tmpValue    : extended;
  tmpSelStart : integer;
  tmpSelStop  : integer;
begin
  if not ((MinYEdit.Text='+') or (MinYEdit.Text='') or (MinYEdit.Text='-')) then begin
    tmpSelStart := MinYEdit.SelStart;
    if TryStrToFloat(MinYEdit.Text, tmpValue) then begin
      Oldstring := MinYEdit.Text;
    end
    else begin
      Beep;
      MinYEdit.Text := Oldstring;
      MinYEdit.SelStart := tmpSelStart-1;
    end;
  end
  else begin
    Oldstring := MinYEdit.Text;
  end;
end;

procedure TNewStatForm.OrgComboChange(Sender: TObject);
var
  error : boolean;
  tmps  : string;
  i     : integer;
  f,m,n : string;

begin
  error := false;
  cmbUsers.Clear;

	FPMainDataset.SQL.Text := 'SELECT users.UserID as UID,FamilyName,FirstName,MiddleName FROM users LEFT JOIN uos ON users.UserID=uos.UserID WHERE uos.OrgID=:forgid AND arched=0 ORDER BY FamilyName,FirstName,MiddleName';// LOCK IN SHARE MODE';
  FPMainDataset.ParamByName('forgid').AsInteger	:= integer(OrgCombo.Items.Objects[OrgCombo.ItemIndex]);

  try
  	FPMainDataset.Open;
  except
		on e: EZSQLException do begin
			ShowError(Self, rsAuthorError, e.ErrorCode, e.StatusCode, e.Message);
	    error := true;
    end;
  end;

	if not error then begin
  	while not FPMainDataset.Eof do begin
		 	with FPMainDataset do begin
    		i := FPMainDataset.FieldByName('UID').AsInteger;
			  n	:= FPMainDataset.FieldByName('FirstName').AsString;
  			m	:= FPMainDataset.FieldByName('MiddleName').AsString;
    		f	:= FPMainDataset.FieldByName('FamilyName').AsString;
		  	tmps				:= GetShortFIO(f, n, m);
        cmbUsers.AddItem(tmps, pointer(i));
			  Next;
    	end;
		end;
  end;

  if CurUserID > 0 then begin
  	error := true;
  	for i := 0 to cmbUsers.Items.Count - 1 do begin
      if CurUserID = integer(cmbUsers.Items.Objects[i]) then begin
      	cmbUsers.ItemIndex := i;
        error := false;
        break;
      end;
    end;
    if error then begin
      ShowError(self, rsFailedToLocateStatIC, 0, '', rsAddressToDevelopers);
    end;
  end
  else begin
	  if cmbUsers.Items.Count > 0 then cmbUsers.ItemIndex := 0;
  end;
end;

procedure TNewStatForm.UDCheckBoxClick(Sender: TObject);
Var
  TmpStr : string;
begin
  TmpStr := BottomGroupBox.Caption;
  BottomGroupBox.Caption := TopGroupBox.Caption;
  TopGroupBox.Caption := TmpStr;
end;

end.
