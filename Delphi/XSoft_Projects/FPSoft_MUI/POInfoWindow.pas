unit POInfoWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sMemo, sEdit, sLabel, ExtCtrls, sPanel;

type
  TPOInfoForm = class(TForm)
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    PONumEdit: TsEdit;
    POSumEdit: TsEdit;
    SubjectEdit: TsEdit;
    NoteMemo: TsMemo;
    sLabel7: TsLabel;
    sLabel4: TsLabel;
    SignedByEdit: TsEdit;
    CancelButton: TsButton;
    sPanel1: TsPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  POInfoForm: TPOInfoForm;

implementation

{$R *.dfm}

end.
