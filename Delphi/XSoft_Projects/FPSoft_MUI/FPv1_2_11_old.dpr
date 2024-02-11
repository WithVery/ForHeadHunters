//program FPv1_2_4_10;
program FPv1_2_11;

uses
  Forms,
  GlobalVars in 'GlobalVars.pas',
  MainFPWin in 'MainFPWin.pas' {MainFPForm},
  IncomeEnteringWindow in 'IncomeEnteringWindow.pas' {IncomeEnteringForm},
  DebtorEditWindow in 'DebtorEditWindow.pas' {DebtorEditForm},
  DebtingWindow in 'DebtingWindow.pas' {DebtingForm},
  FundEditWindow in 'FundEditWindow.pas' {FundEditForm},
  BalanceEnterWindow in 'BalanceEnterWindow.pas' {BalanceEnterForm},
  NewFPWindow in 'NewFPWindow.pas' {NewFPForm},
  FPAllocWindow in 'FPAllocWindow.pas' {FPAllocForm},
  POWindow in 'POWindow.pas' {POForm},
  POApproveWindow in 'POApproveWindow.pas' {POApproveForm},
  UsersWindow in 'UsersWindow.pas' {UsersForm},
  PwdChangeWindow in 'PwdChangeWindow.pas' {PwdChangeForm},
  UserAccessWindow in 'UserAccessWindow.pas' {UserAccessForm},
  CreditingWindow in 'CreditingWindow.pas' {CreditingForm},
  AssetTransferWindow in 'AssetTransferWindow.pas' {AssetTransferForm},
  DisbWindow in 'DisbWindow.pas' {DisbForm},
  FPLoadingWindow in 'FPLoadingWindow.pas' {FPLoadingForm},
  DebtClosingWindow in 'DebtClosingWindow.pas' {DebtClosingForm},
  DebtListWindow in 'DebtListWindow.pas' {DebtListForm},
  LoginWindow in 'LoginWindow.pas' {LogInForm},
  ErrorWindow in 'ErrorWindow.pas' {ErrorForm},
  UserEditWindow in 'UserEditWindow.pas' {UserEditForm},
  AssetVsFundsWindow in 'AssetVsFundsWindow.pas' {AssetVsFundsForm},
  ImageViewerWindow in 'ImageViewerWindow.pas' {ImageViewerForm},
  FPXMLBinding in 'FPXMLBinding.pas',
  UpdateThread in 'UpdateThread.pas',
  IncomeSourcesWindow in 'IncomeSourcesWindow.pas' {IncomeSourcesForm},
  IncomeSourceEditWindow in 'IncomeSourceEditWindow.pas' {IncomeSourceEditForm},
  IncSrcUpdateThread in 'IncSrcUpdateThread.pas',
  AttLoaderHDDThread in 'AttLoaderHDDThread.pas',
  AttSaverThread in 'AttSaverThread.pas',
  LoginNameCheckThread in 'LoginNameCheckThread.pas',
  UserOrgTransferWindow in 'UserOrgTransferWindow.pas' {UserOrgTransferForm},
  AboutWindow in 'AboutWindow.pas' {AboutBox},
  NewOrgWizWelcomeWindow in 'NewOrgWizWelcomeWindow.pas' {NewOrgWizWelcomeForm},
  NOWStep1Window in 'NOWStep1Window.pas' {NOWStep1Form},
  NOWStep2Window in 'NOWStep2Window.pas' {NOWStep2Form};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLogInForm, LogInForm);
  Application.Run;
end.
