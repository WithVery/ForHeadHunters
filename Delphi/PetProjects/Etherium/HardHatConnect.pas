unit HardHatConnect;

{$DEFINE VCL}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
//BigIntegers in 'Velthuis.BigIntegers.pas',
//Velthuis.BigIntegers,
web3 in 'web3.pas'
;


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//
web3.eth.getBalance(TWeb3.Create('http://127.0.0.1:8545'), Edit1.Text, procedure(qty: BigInteger; err: IError)
  begin
    TThread.Synchronize(nil, procedure
    begin
      if Assigned(err) then
        MessageDlg(err.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0)
      else
        ShowMessage(web3.eth.utils.fromWei(qty, web3.eth.utils.ether) + ' ether');
    end);
  end);
end;

end.
