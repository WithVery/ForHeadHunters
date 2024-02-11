unit PersonEditWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, sButton, ExtCtrls, sPanel, sComboBox;

type
  TPersonEditForm = class(TForm)
    FirstNameLabel: TLabel;
    PhoneHomeLabel: TLabel;
    EMailLabel: TLabel;
    CancelButton: TsButton;
    OKButton: TsButton;
    FirstNameEdit: TsEdit;
    PhoneHomeEdit: TsEdit;
    EMailEdit: TsEdit;
    sPanel1: TsPanel;
    FamilyNameEdit: TsEdit;
    FamilyNameLabel: TLabel;
    MiddleNameLabel: TLabel;
    MiddleNameEdit: TsEdit;
    CountryEdit: TsEdit;
    CountryLabel: TLabel;
    PostalIndexEdit: TsEdit;
    PostalIndexLabel: TLabel;
    AddressLabel: TLabel;
    AddressEdit: TsEdit;
    PassportSeriesEdit: TsEdit;
    PassportSeriesLabel: TLabel;
    PassportNumberLabel: TLabel;
    PassportNumberEdit: TsEdit;
    PhoneMobileLabel: TLabel;
    PhoneMobileEdit: TsEdit;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CancelButtonClick(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
    idx : integer;
  end;

var
  PersonEditForm: TPersonEditForm;

implementation

{$R *.dfm}

uses GlobalVars;

procedure TPersonEditForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPersonEditForm.FormCreate(Sender: TObject);
var
  i : integer;
begin
  // flush TEdit fields
  for i:= 0 to Self.ComponentCount - 1 do begin
    if Self.Components[i] is TEdit then begin
      TEdit(Components[i]).Text := '';
    end;
  end;
end;

procedure TPersonEditForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin CancelButtonClick(Sender); Key := 0; end;
  end;
end;

procedure TPersonEditForm.OKButtonClick(Sender: TObject);
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;
end;

End.


