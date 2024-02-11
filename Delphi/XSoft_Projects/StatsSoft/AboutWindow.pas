unit AboutWindow;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  GlobalVars,
  Buttons, ExtCtrls, acPNG, sPanel, sLabel, Menus, DKLang;

type
  TAboutBox = class(TForm)
    OKButton: TButton;
    sPanel1: TsPanel;
    Comments: TLabel;
    Copyright: TLabel;
    ProgramIcon: TImage;
    VersionLabel: TLabel;
    DVLabel: TLabel;
    Emaillabel: TsWebLabel;
    PopupMenu: TPopupMenu;
    CopyEmailAddres: TMenuItem;
    lblWaiver: TLabel;
    lc: TDKLanguageController;
    procedure CopyEmailAddresClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ClipBrd;

procedure TAboutBox.CopyEmailAddresClick(Sender: TObject);
begin
  ClipBoard.AsText := 'support@fpsoft.ru';
end;

procedure TAboutBox.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

end.
 
