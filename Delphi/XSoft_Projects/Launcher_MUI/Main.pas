unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  DECUtil, DECCipher, DECHash, DECFmt,
  StrUtils,
  IdMultipartFormData,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdHTTP;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    Button1: TButton;
    SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function Decrypt(const AText: String; const APassword: String): String; overload;
  public
    { Public declarations }
  end;

const
  ACipherClass: TDECCipherClass = TCipher_Rijndael;
  ACipherMode: TCipherMode = cmCBCx;
  AHashClass: TDECHashClass = THash_Whirlpool;
  ATextFormat: TDECFormatClass = TFormat_Mime64;
  AKDFIndex: LongWord = 1;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  RespStr : string;
  Error   : boolean;
  k       : string;
  s       : string;
  request : TIdMultiPartFormDataStream;
begin
//
  error := false;
  idhttp1.ProtocolVersion := pv1_1;

  request:= TIdMultiPartFormDataStream.Create;

  try
    request.AddFormField('Name', 'www');
    RespStr := IdHTTP1.Post('https://127.0.0.1/orgs/', request);
  finally
    request.Free;
  end;

  if not Error then begin
    k := '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
    s := ReplaceStr(RespStr, '<html>', '');
    s := ReplaceStr(s, '</html>', '');
    s := ReplaceStr(s, '<header>', '');
    s := ReplaceStr(s, '</header>', '');
    if s <> '' then begin
      s := Decrypt(s, k);
      ShowMessage(s);
    end
    else begin
      ShowMessage('there is no data');
    end;
  end
end;

function TForm1.Decrypt(const AText: String; const APassword: String): String;
var
  ASalt: Binary;
  AData: Binary;
  ACheck: Binary;
  APass: Binary;
  ALen: Integer;
begin
  with ValidCipher(ACipherClass).Create, Context do begin
    try
      ASalt := ValidFormat(ATextFormat).Decode(AText);
      ALen := Length(ASalt) - 16 - BufferSize;
      AData := System.Copy(ASalt, 17, ALen);
      ACheck := System.Copy(ASalt, ALen + 17, BufferSize);
      SetLength(ASalt, 16);
      APass := ValidHash(AHashClass).KDFx(APassword[1], Length(APassword) * SizeOf(APassword[1]), ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);
      Mode := ACipherMode;
      Init(APass);
      SetLength(Result, ALen div SizeOf(AText[1]));
      Decode(AData[1], Result[1], ALen);
      if ACheck <> CalcMAC then
        raise Exception.Create('Invalid data');
    finally
      Free;
      ProtectBinary(ASalt);
      ProtectBinary(AData);
      ProtectBinary(ACheck);
      ProtectBinary(APass);
    end;
  end; // with
end;

end.
