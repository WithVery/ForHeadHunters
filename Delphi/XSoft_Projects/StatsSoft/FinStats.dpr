program FinStats;

{$R 'ENU.res' 'ENU.rc'}
{$R 'ESP.res' 'ESP.rc'}
{$R 'RUS.res' 'RUS.rc'}

uses
  Forms,
  LoginWindow in 'LoginWindow.pas' {LogInForm},
  GlobalVars in '..\FP\GlobalVars.pas',
  MainPad in 'MainPad.pas' {MainStatForm},
  NewStatWindow in 'NewStatWindow.pas' {NewStatForm},
  PadWin in 'PadWin.pas' {SmallWin},
  ErrorWindow in '..\FP\ErrorWindow.pas' {ErrorForm},
  StatGroupWindow in 'StatGroupWindow.pas' {StatGroupForm},
  DECFmt in '..\EncLibs\DECFmt.pas',
  DECHash in '..\EncLibs\DECHash.pas',
  DECUtil in '..\EncLibs\DECUtil.pas',
  DECCipher in '..\EncLibs\DECCipher.pas',
  DECData in '..\EncLibs\DECData.pas',
  CRC in '..\EncLibs\CRC.pas',
  AboutWindow in 'AboutWindow.pas' {AboutBox},
  AccessWindow in 'AccessWindow.pas' {AccessForm},
  UserEditWindow in '..\FP\UserEditWindow.pas' {UserEditForm},
  LoginNameCheckThread in '..\FP\LoginNameCheckThread.pas',
  OrgvsUsersWindow in 'OrgvsUsersWindow.pas' {OrgvsUsersForm},
  WEEditWindow in 'WEEditWindow.pas' {WEEditForm},
  uLkJSON in 'uLkJSON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLogInForm, LogInForm);
  Application.Run;
end.
