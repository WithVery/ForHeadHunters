unit ErrorWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sMemo, sLabel, DKLang;

type
  TErrorForm = class(TForm)
    ErrorExplanationMemo: TsMemo;
    ErrorMemo: TsMemo;
    CloseButton: TsBitBtn;
    CopyButton: TsBitBtn;
    sLabel1: TsLabel;
    DKLanguageController1: TDKLanguageController;
    procedure CloseButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ErrorForm: TErrorForm;

implementation

{$R *.dfm}

uses ClipBrd;

procedure TErrorForm.CloseButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TErrorForm.CopyButtonClick(Sender: TObject);
begin
  ClipBoard.AsText := ErrorMemo.Text;
end;

procedure TErrorForm.FormShow(Sender: TObject);
begin
  CloseButton.SetFocus
end;

end.
