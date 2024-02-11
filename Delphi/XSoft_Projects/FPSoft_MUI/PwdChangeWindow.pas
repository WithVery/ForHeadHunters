unit PwdChangeWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sLabel, sEdit, ExtCtrls, sPanel;

type
  TPwdChangeForm = class(TForm)
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    Pwd2Edit: TsEdit;
    SaveButton: TsButton;
    CloseButton: TsButton;
    PwdEdit: TsEdit;
    sPanel1: TsPanel;
    procedure CloseButtonClick(Sender: TObject);
    procedure PwdEditChange(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure ResetForm;
    procedure SaveButtonEnabled;
  public
    { Public declarations }
    login : string;
    User  : string;
  end;

//var
//  PwdChangeForm: TPwdChangeForm;

implementation

{$R *.dfm}

Uses
	ZDbcIntfs,
  GlobalVars;

procedure TPwdChangeForm.SaveButtonClick(Sender: TObject);
var
  NoError : boolean;
begin
  NoError := true;
  FPMainDataset.SQL.Text := 'UPDATE users SET`Password`=PASSWORD(:fPwd)WHERE`Login`=:fLogin';
  FPMainDataset.ParamByName('fPwd').AsString    := PwdEdit.Text;
  FPMainDataset.ParamByName('fLogin').AsString  := Login;
  try
    FPMainDataset.ExecSQL;
  except
    on e: EZSQLException do begin
		  ShowError(Self, 'При изменении пароля произошла ошибка.', e.ErrorCode, e.StatusCode, e.Message);
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
  end
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
  end;

  if NoError then begin
    Application.MessageBox(PWideChar('Пароль пользователя ' + User + ' успешно изменён.'), 'Операция выполнено успешно', MB_OK or MB_ICONINFORMATION);
  end;
  ModalResult := mrOK;
end;

procedure TPwdChangeForm.SaveButtonEnabled;
begin
  SaveButton.Enabled  := (PwdEdit.Text <> '') and (Pwd2Edit.Text <> '') and (PwdEdit.Text = Pwd2Edit.Text);
end;

procedure TPwdChangeForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TPwdChangeForm.PwdEditChange(Sender: TObject);
begin
  SaveButtonEnabled;
end;

procedure TPwdChangeForm.ResetForm;
begin
  PwdEdit.Text  :=  '';
  Pwd2Edit.Text :=  '';
  SaveButtonEnabled;
end;

procedure TPwdChangeForm.CloseButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
