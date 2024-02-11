unit OrgDataWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sLabel, sEdit, sButton;

type
  TOrgDataForm = class(TForm)
    FullNameEdit: TsEdit;
    OrgLabel: TsLabel;
    sLabel1: TsLabel;
    ShortNameEdit: TsEdit;
    sLabel2: TsLabel;
    AddressEdit: TsEdit;
    sLabel3: TsLabel;
    PhoneEdit: TsEdit;
    OkButton: TsButton;
    CancelButton: TsButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrgDataForm: TOrgDataForm;

implementation

{$R *.dfm}

end.
