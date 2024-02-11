unit LoadingProgressWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sLabel, ComCtrls, acProgressBar, ExtCtrls, sPanel, sGauge;

type
  TLoadingProgressForm = class(TForm)
    Lbl: TsLabel;
    sPanel1: TsPanel;
    PB: TsGauge;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  LoadingProgressForm: TLoadingProgressForm;

implementation

{$R *.dfm}

end.
