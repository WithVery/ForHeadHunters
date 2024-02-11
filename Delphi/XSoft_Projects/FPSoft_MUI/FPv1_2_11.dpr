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
  FPXMLBinding in 'FPXMLBinding.pas',
  UpdateThread in 'UpdateThread.pas',
  IncomeSourcesWindow in 'IncomeSourcesWindow.pas' {IncomeSourcesForm},
  IncomeSourceEditWindow in 'IncomeSourceEditWindow.pas' {IncomeSourceEditForm},
  IncSrcUpdateThread in 'IncSrcUpdateThread.pas',
  AttSaverThread in 'AttSaverThread.pas',
  LoginNameCheckThread in 'LoginNameCheckThread.pas',
  UserOrgTransferWindow in 'UserOrgTransferWindow.pas' {UserOrgTransferForm},
  AboutWindow in 'AboutWindow.pas' {AboutBox},
  NewOrgWizWelcomeWindow in 'NewOrgWizWelcomeWindow.pas' {NewOrgWizWelcomeForm},
  NOWStep1Window in 'NOWStep1Window.pas' {NOWStep1Form},
  NOWStep2Window in 'NOWStep2Window.pas' {NOWStep2Form},
  FPFundsListWindow in 'FPFundsListWindow.pas' {FPFundsListForm},
  FPLockerThread in 'FPLockerThread.pas',
  POLockerThread in 'POLockerThread.pas',
  LoadingProgressWindow in 'LoadingProgressWindow.pas' {LoadingProgressForm},
  DECUtil in '..\EncLibs\DECUtil.pas',
  CRC in '..\EncLibs\CRC.pas',
  DECCipher in '..\EncLibs\DECCipher.pas',
  DECData in '..\EncLibs\DECData.pas',
  DECFmt in '..\EncLibs\DECFmt.pas',
  DECHash in '..\EncLibs\DECHash.pas',
  AttLoaderThread in 'AttLoaderThread.pas',
  PushToDBThread in 'PushToDBThread.pas',
  VTCustomEditor in 'VTCustomEditor.pas',
  FundvsPOsWindow in 'FundvsPOsWindow.pas' {FundvsPOsForm},
  FPConstStrs in 'FPConstStrs.pas',
  TableDataWindow in 'TableDataWindow.pas' {TableDataForm},
  AttRemoverThread in 'AttRemoverThread.pas',
  IncPlanPrintPreviewWindow in 'IncPlanPrintPreviewWindow.pas' {IncPlanPrintPreviewForm},
  FilterNumbersWindow in 'FilterNumbersWindow.pas' {FilterNumbersForm},
  FilterStringWindow in 'FilterStringWindow.pas' {FilterStringForm},
  FilterFloatsWindow in 'FilterFloatsWindow.pas' {FilterFloatsForm},
  FilterDatesWindow in 'FilterDatesWindow.pas' {FilterDatesForm},
  POsExportToExcelWindow in 'POsExportToExcelWindow.pas' {POsExportToExcelForm},
  FPUnsavedExitWindow in 'FPUnsavedExitWindow.pas' {FPUnsavedExitForm},
  IncomeCorrectionWindow in 'IncomeCorrectionWindow.pas' {IncomeCorrectionForm},
  VTIncomeSourceCustomEditor in 'VTIncomeSourceCustomEditor.pas',
  VTIncomeEnteringCustomEditor in 'VTIncomeEnteringCustomEditor.pas',
  PersonIncomeWindow in 'PersonIncomeWindow.pas' {PersonIncomeForm},
  OrgDataWindow in 'OrgDataWindow.pas' {OrgDataForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLogInForm, LogInForm);
  Application.CreateForm(TPersonIncomeForm, PersonIncomeForm);
  Application.CreateForm(TOrgDataForm, OrgDataForm);
  Application.Run;
end.
