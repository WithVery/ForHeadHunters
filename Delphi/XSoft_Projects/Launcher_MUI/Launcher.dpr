program launcher;



uses
  Forms,
  Main in 'Main.pas' {Form1},
  DECUtil in '..\EncLibs\DECUtil.pas',
  DECCipher in '..\EncLibs\DECCipher.pas',
  DECFmt in '..\EncLibs\DECFmt.pas',
  CRC in '..\EncLibs\CRC.pas',
  DECData in '..\EncLibs\DECData.pas',
  DECHash in '..\EncLibs\DECHash.pas',
  LoginWindow in 'LoginWindow.pas' {LogInForm},
  ErrorWindow in '..\FP\ErrorWindow.pas' {ErrorForm},
  GlobalVars in '..\FP\GlobalVars.pas',
  AAndUThread in 'AAndUThread.pas',
  LoadingProgressWindow in 'LoadingProgressWindow.pas' {LoadingProgressForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLogInForm, LogInForm);
  Application.Run;
end.
