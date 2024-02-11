program ConnectToHardHat;

uses
  Vcl.Forms,
  //Velthuis.Sizes in 'e:\1\Etherium\DelphiBigNumbers\Source\Velthuis.Sizes.pas',
  Velthuis.BigIntegers in 'e:\1\Etherium\DelphiBigNumbers\Source\Velthuis.BigIntegers.pas',
  ClpIESParameters in 'e:\1\Etherium\CryptoLib4Pascal\CryptoLib\src\Crypto\Parameters\ClpIESParameters.pas',
  ClpICipherParameters in 'e:\1\Etherium\CryptoLib4Pascal\CryptoLib\src\Interfaces\ClpICipherParameters.pas',
  HardHatConnect in 'HardHatConnect.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
