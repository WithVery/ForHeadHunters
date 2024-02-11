
{****************************************************************}
{                                                                }
{                        XML Data Binding                        }
{                                                                }
{         Generated on: 5/29/2011 5:06:49 PM                     }
{       Generated from: C:\Work\TestProjects\Rave\Test6\FP.xml   }
{   Settings stored in: C:\Work\TestProjects\Rave\Test6\FP.xdb   }
{                                                                }
{****************************************************************}

unit FPXMLBinding;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLFPType = interface;
  IXMLGlobalsType = interface;
  IXMLSectionAType = interface;
  IXMLLineAType = interface;
  IXMLSectionA1Type = interface;
  IXMLLineA1Type = interface;
  IXMLSectionBType = interface;
  IXMLLineBType = interface;
  IXMLSectionCType = interface;
  IXMLLineCType = interface;
  IXMLSectionDType = interface;
  IXMLLineDType = interface;
  IXMLSectionEType = interface;
  IXMLLineEType = interface;
  IXMLSectionFType = interface;
  IXMLLineFType = interface;
  IXMLSectionGType = interface;
  IXMLLineGType = interface;

{ IXMLFPType }

  IXMLFPType = interface(IXMLNode)
    ['{F8009E25-9422-4607-BF63-74990FA63991}']
    { Property Accessors }
    function Get_Globals: IXMLGlobalsType;
    function Get_SectionA: IXMLSectionAType;
    function Get_SectionA1: IXMLSectionA1Type;
    function Get_SectionB: IXMLSectionBType;
    function Get_SectionC: IXMLSectionCType;
    function Get_SectionD: IXMLSectionDType;
    function Get_SectionE: IXMLSectionEType;
    function Get_SectionF: IXMLSectionFType;
    function Get_SectionG: IXMLSectionGType;
    { Methods & Properties }
    property Globals: IXMLGlobalsType read Get_Globals;
    property SectionA: IXMLSectionAType read Get_SectionA;
    property SectionA1: IXMLSectionA1Type read Get_SectionA1;
    property SectionB: IXMLSectionBType read Get_SectionB;
    property SectionC: IXMLSectionCType read Get_SectionC;
    property SectionD: IXMLSectionDType read Get_SectionD;
    property SectionE: IXMLSectionEType read Get_SectionE;
    property SectionF: IXMLSectionFType read Get_SectionF;
    property SectionG: IXMLSectionGType read Get_SectionG;
  end;

{ IXMLGlobalsType }

  IXMLGlobalsType = interface(IXMLNode)
    ['{79C35327-EC25-427D-9EBE-413ED585F5DE}']
    { Property Accessors }
    function Get_FPNumber: Integer;
    function Get_TGI: string;
    function Get_TotA1: string;
    function Get_GI: string;
    function Get_TotB: string;
    function Get_CGI: string;
    function Get_TotC: string;
    function Get_BalC: string;
    function Get_TotD: string;
    function Get_BalD: string;
    function Get_TotE: string;
    function Get_TotEI: string;
    function Get_BalE: string;
    function Get_TotF: string;
    function Get_FPBal: string;
    function Get_FromDate: string;
    function Get_ToDate: string;
    { Methods & Properties }
    property FPNumber: Integer read Get_FPNumber;
    property TGI: string read Get_TGI;
    property TotA1: string read Get_TotA1;
    property GI: string read Get_GI;
    property TotB: string read Get_TotB;
    property CGI: string read Get_CGI;
    property TotC: string read Get_TotC;
    property BalC: string read Get_BalC;
    property TotD: string read Get_TotD;
    property BalD: string read Get_BalD;
    property TotE: string read Get_TotE;
    property TotEI: string read Get_TotEI;
    property BalE: string read Get_BalE;
    property TotF: string read Get_TotF;
    property FPBal: string read Get_FPBal;
    property FromDate: string read Get_FromDate;
    property ToDate: string read Get_ToDate;
  end;

{ IXMLSectionAType }

  IXMLSectionAType = interface(IXMLNodeCollection)
    ['{1FD545C1-7354-4BAF-8236-270A459B59BA}']
    { Property Accessors }
    function Get_LineA(Index: Integer): IXMLLineAType;
    { Methods & Properties }
    function Add: IXMLLineAType;
    function Insert(const Index: Integer): IXMLLineAType;
    property LineA[Index: Integer]: IXMLLineAType read Get_LineA; default;
  end;

{ IXMLLineAType }

  IXMLLineAType = interface(IXMLNode)
    ['{092E99CA-9C67-40A7-8846-AA38E7D5608F}']
    { Property Accessors }
    function Get_N: Integer;
    function Get_Sum: string;
    function Get_Descr: string;
    function Get_DateTime: string;
    function Get_Source: string;
    { Methods & Properties }
    property N: Integer read Get_N;
    property Sum: string read Get_Sum;
    property Descr: string read Get_Descr;
    property DateTime: string read Get_DateTime;
    property Source: string read Get_Source;
  end;

{ IXMLSectionA1Type }

  IXMLSectionA1Type = interface(IXMLNodeCollection)
    ['{D16C775F-60F4-4A66-AE34-DA6B4EBA508B}']
    { Property Accessors }
    function Get_LineA1(Index: Integer): IXMLLineA1Type;
    { Methods & Properties }
    function Add: IXMLLineA1Type;
    function Insert(const Index: Integer): IXMLLineA1Type;
    property LineA1[Index: Integer]: IXMLLineA1Type read Get_LineA1; default;
  end;

{ IXMLLineA1Type }

  IXMLLineA1Type = interface(IXMLNode)
    ['{64CB6011-8F95-4040-A980-B8FB3D77688B}']
    { Property Accessors }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_FP1: string;
    function Get_Percent: string;
    function Get_Sum: string;
    function Get_Fund: string;
    { Methods & Properties }
    property N: Integer read Get_N;
    property Descr: string read Get_Descr;
    property FP1: string read Get_FP1;
    property Percent: string read Get_Percent;
    property Sum: string read Get_Sum;
    property Fund: string read Get_Fund;
  end;

{ IXMLSectionBType }

  IXMLSectionBType = interface(IXMLNodeCollection)
    ['{EE1B1040-B56A-4C2E-9FE4-EA1D2B716D8D}']
    { Property Accessors }
    function Get_LineB(Index: Integer): IXMLLineBType;
    { Methods & Properties }
    function Add: IXMLLineBType;
    function Insert(const Index: Integer): IXMLLineBType;
    property LineB[Index: Integer]: IXMLLineBType read Get_LineB; default;
  end;

{ IXMLLineBType }

  IXMLLineBType = interface(IXMLNode)
    ['{EBB05642-46E5-4901-980E-BE00DF5F4671}']
    { Property Accessors }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_FP1: string;
    function Get_Percent: string;
    function Get_Sum: string;
    function Get_Fund: string;
    { Methods & Properties }
    property N: Integer read Get_N;
    property Descr: string read Get_Descr;
    property FP1: string read Get_FP1;
    property Percent: string read Get_Percent;
    property Sum: string read Get_Sum;
    property Fund: string read Get_Fund;
  end;

{ IXMLSectionCType }

  IXMLSectionCType = interface(IXMLNodeCollection)
    ['{87F22399-7B2A-44A2-A95E-139EC5D2EF16}']
    { Property Accessors }
    function Get_LineC(Index: Integer): IXMLLineCType;
    { Methods & Properties }
    function Add: IXMLLineCType;
    function Insert(const Index: Integer): IXMLLineCType;
    property LineC[Index: Integer]: IXMLLineCType read Get_LineC; default;
  end;

{ IXMLLineCType }

  IXMLLineCType = interface(IXMLNode)
    ['{C65D2E98-E29F-4F47-BC72-CA7601E863A5}']
    { Property Accessors }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_FP1: string;
    function Get_Percent: string;
    function Get_Sum: string;
    function Get_Fund: string;
    { Methods & Properties }
    property N: Integer read Get_N;
    property Descr: string read Get_Descr;
    property FP1: string read Get_FP1;
    property Percent: string read Get_Percent;
    property Sum: string read Get_Sum;
    property Fund: string read Get_Fund;
  end;

{ IXMLSectionDType }

  IXMLSectionDType = interface(IXMLNodeCollection)
    ['{816C97E1-3CF3-4CAA-85DD-21375C32A931}']
    { Property Accessors }
    function Get_LineD(Index: Integer): IXMLLineDType;
    { Methods & Properties }
    function Add: IXMLLineDType;
    function Insert(const Index: Integer): IXMLLineDType;
    property LineD[Index: Integer]: IXMLLineDType read Get_LineD; default;
  end;

{ IXMLLineDType }

  IXMLLineDType = interface(IXMLNode)
    ['{027A78EC-513D-4A48-AD54-818FC6DC0590}']
    { Property Accessors }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_FP1: string;
    function Get_Note: string;
    function Get_Sum: string;
    function Get_Fund: string;
    { Methods & Properties }
    property N: Integer read Get_N;
    property Descr: string read Get_Descr;
    property FP1: string read Get_FP1;
    property Note: string read Get_Note;
    property Sum: string read Get_Sum;
    property Fund: string read Get_Fund;
  end;

{ IXMLSectionEType }

  IXMLSectionEType = interface(IXMLNodeCollection)
    ['{9B7A174C-A7DC-400B-B146-79B5F2FB7E2D}']
    { Property Accessors }
    function Get_LineE(Index: Integer): IXMLLineEType;
    { Methods & Properties }
    function Add: IXMLLineEType;
    function Insert(const Index: Integer): IXMLLineEType;
    property LineE[Index: Integer]: IXMLLineEType read Get_LineE; default;
  end;

{ IXMLLineEType }

  IXMLLineEType = interface(IXMLNode)
    ['{3D70DD08-CF99-4A49-8B56-EFEBB104F8A8}']
    { Property Accessors }
    function Get_N: Integer;
    function Get_Date: string;
    function Get_Subj: string;
    function Get_SumR: string;
    function Get_Sol: string;
    function Get_SumA: string;
    function Get_Note: string;
    function Get_Fund: string;
    { Methods & Properties }
    property N: Integer read Get_N;
    property Date: string read Get_Date;
    property Subj: string read Get_Subj;
    property SumR: string read Get_SumR;
    property Sol: string read Get_Sol;
    property SumA: string read Get_SumA;
    property Note: string read Get_Note;
    property Fund: string read Get_Fund;
  end;

{ IXMLSectionFType }

  IXMLSectionFType = interface(IXMLNodeCollection)
    ['{27C9274C-3F13-4089-BF84-BC7D78909D20}']
    { Property Accessors }
    function Get_LineF(Index: Integer): IXMLLineFType;
    { Methods & Properties }
    function Add: IXMLLineFType;
    function Insert(const Index: Integer): IXMLLineFType;
    property LineF[Index: Integer]: IXMLLineFType read Get_LineF; default;
  end;

{ IXMLLineFType }

  IXMLLineFType = interface(IXMLNode)
    ['{B4D88591-46C6-49CE-B294-F7026EAD95E4}']
    { Property Accessors }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_Percent: string;
    function Get_Sum: string;
    function Get_Fund: string;
    { Methods & Properties }
    property N: Integer read Get_N;
    property Descr: string read Get_Descr;
    property Percent: string read Get_Percent;
    property Sum: string read Get_Sum;
    property Fund: string read Get_Fund;
  end;

{ IXMLSectionGType }

  IXMLSectionGType = interface(IXMLNodeCollection)
    ['{1232403D-ACAA-41CB-9455-3D60E4854343}']
    { Property Accessors }
    function Get_LineG(Index: Integer): IXMLLineGType;
    { Methods & Properties }
    function Add: IXMLLineGType;
    function Insert(const Index: Integer): IXMLLineGType;
    property LineG[Index: Integer]: IXMLLineGType read Get_LineG; default;
  end;

{ IXMLLineGType }

  IXMLLineGType = interface(IXMLNode)
    ['{AF910995-8EC8-4693-8B8C-2B6093C9B811}']
    { Property Accessors }
    function Get_Acc: string;
    function Get_Sum: string;
    { Methods & Properties }
    property Acc: string read Get_Acc;
    property Sum: string read Get_Sum;
  end;

{ Forward Decls }

  TXMLFPType = class;
  TXMLGlobalsType = class;
  TXMLSectionAType = class;
  TXMLLineAType = class;
  TXMLSectionA1Type = class;
  TXMLLineA1Type = class;
  TXMLSectionBType = class;
  TXMLLineBType = class;
  TXMLSectionCType = class;
  TXMLLineCType = class;
  TXMLSectionDType = class;
  TXMLLineDType = class;
  TXMLSectionEType = class;
  TXMLLineEType = class;
  TXMLSectionFType = class;
  TXMLLineFType = class;
  TXMLSectionGType = class;
  TXMLLineGType = class;

{ TXMLFPType }

  TXMLFPType = class(TXMLNode, IXMLFPType)
  protected
    { IXMLFPType }
    function Get_Globals: IXMLGlobalsType;
    function Get_SectionA: IXMLSectionAType;
    function Get_SectionA1: IXMLSectionA1Type;
    function Get_SectionB: IXMLSectionBType;
    function Get_SectionC: IXMLSectionCType;
    function Get_SectionD: IXMLSectionDType;
    function Get_SectionE: IXMLSectionEType;
    function Get_SectionF: IXMLSectionFType;
    function Get_SectionG: IXMLSectionGType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLGlobalsType }

  TXMLGlobalsType = class(TXMLNode, IXMLGlobalsType)
  protected
    { IXMLGlobalsType }
    function Get_FPNumber: Integer;
    function Get_TGI: string;
    function Get_TotA1: string;
    function Get_GI: string;
    function Get_TotB: string;
    function Get_CGI: string;
    function Get_TotC: string;
    function Get_BalC: string;
    function Get_TotD: string;
    function Get_BalD: string;
    function Get_TotE: string;
    function Get_TotEI: string;
    function Get_BalE: string;
    function Get_TotF: string;
    function Get_FPBal: string;
    function Get_FromDate: string;
    function Get_ToDate: string;
  end;

{ TXMLSectionAType }

  TXMLSectionAType = class(TXMLNodeCollection, IXMLSectionAType)
  protected
    { IXMLSectionAType }
    function Get_LineA(Index: Integer): IXMLLineAType;
    function Add: IXMLLineAType;
    function Insert(const Index: Integer): IXMLLineAType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineAType }

  TXMLLineAType = class(TXMLNode, IXMLLineAType)
  protected
    { IXMLLineAType }
    function Get_N: Integer;
    function Get_Sum: string;
    function Get_Descr: string;
    function Get_DateTime: string;
    function Get_Source: string;
  end;

{ TXMLSectionA1Type }

  TXMLSectionA1Type = class(TXMLNodeCollection, IXMLSectionA1Type)
  protected
    { IXMLSectionA1Type }
    function Get_LineA1(Index: Integer): IXMLLineA1Type;
    function Add: IXMLLineA1Type;
    function Insert(const Index: Integer): IXMLLineA1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineA1Type }

  TXMLLineA1Type = class(TXMLNode, IXMLLineA1Type)
  protected
    { IXMLLineA1Type }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_FP1: string;
    function Get_Percent: string;
    function Get_Sum: string;
    function Get_Fund: string;
  end;

{ TXMLSectionBType }

  TXMLSectionBType = class(TXMLNodeCollection, IXMLSectionBType)
  protected
    { IXMLSectionBType }
    function Get_LineB(Index: Integer): IXMLLineBType;
    function Add: IXMLLineBType;
    function Insert(const Index: Integer): IXMLLineBType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineBType }

  TXMLLineBType = class(TXMLNode, IXMLLineBType)
  protected
    { IXMLLineBType }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_FP1: string;
    function Get_Percent: string;
    function Get_Sum: string;
    function Get_Fund: string;
  end;

{ TXMLSectionCType }

  TXMLSectionCType = class(TXMLNodeCollection, IXMLSectionCType)
  protected
    { IXMLSectionCType }
    function Get_LineC(Index: Integer): IXMLLineCType;
    function Add: IXMLLineCType;
    function Insert(const Index: Integer): IXMLLineCType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineCType }

  TXMLLineCType = class(TXMLNode, IXMLLineCType)
  protected
    { IXMLLineCType }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_FP1: string;
    function Get_Percent: string;
    function Get_Sum: string;
    function Get_Fund: string;
  end;

{ TXMLSectionDType }

  TXMLSectionDType = class(TXMLNodeCollection, IXMLSectionDType)
  protected
    { IXMLSectionDType }
    function Get_LineD(Index: Integer): IXMLLineDType;
    function Add: IXMLLineDType;
    function Insert(const Index: Integer): IXMLLineDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineDType }

  TXMLLineDType = class(TXMLNode, IXMLLineDType)
  protected
    { IXMLLineDType }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_FP1: string;
    function Get_Note: string;
    function Get_Sum: string;
    function Get_Fund: string;
  end;

{ TXMLSectionEType }

  TXMLSectionEType = class(TXMLNodeCollection, IXMLSectionEType)
  protected
    { IXMLSectionEType }
    function Get_LineE(Index: Integer): IXMLLineEType;
    function Add: IXMLLineEType;
    function Insert(const Index: Integer): IXMLLineEType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineEType }

  TXMLLineEType = class(TXMLNode, IXMLLineEType)
  protected
    { IXMLLineEType }
    function Get_N: Integer;
    function Get_Date: string;
    function Get_Subj: string;
    function Get_SumR: string;
    function Get_Sol: string;
    function Get_SumA: string;
    function Get_Note: string;
    function Get_Fund: string;
  end;

{ TXMLSectionFType }

  TXMLSectionFType = class(TXMLNodeCollection, IXMLSectionFType)
  protected
    { IXMLSectionFType }
    function Get_LineF(Index: Integer): IXMLLineFType;
    function Add: IXMLLineFType;
    function Insert(const Index: Integer): IXMLLineFType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineFType }

  TXMLLineFType = class(TXMLNode, IXMLLineFType)
  protected
    { IXMLLineFType }
    function Get_N: Integer;
    function Get_Descr: string;
    function Get_Percent: string;
    function Get_Sum: string;
    function Get_Fund: string;
  end;

{ TXMLSectionGType }

  TXMLSectionGType = class(TXMLNodeCollection, IXMLSectionGType)
  protected
    { IXMLSectionGType }
    function Get_LineG(Index: Integer): IXMLLineGType;
    function Add: IXMLLineGType;
    function Insert(const Index: Integer): IXMLLineGType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineGType }

  TXMLLineGType = class(TXMLNode, IXMLLineGType)
  protected
    { IXMLLineGType }
    function Get_Acc: string;
    function Get_Sum: string;
  end;

{ Global Functions }

function GetFP(Doc: IXMLDocument): IXMLFPType;
function LoadFP(const FileName: string): IXMLFPType;
function NewFP: IXMLFPType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetFP(Doc: IXMLDocument): IXMLFPType;
begin
  Result := Doc.GetDocBinding('FP', TXMLFPType, TargetNamespace) as IXMLFPType;
end;

function LoadFP(const FileName: string): IXMLFPType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('FP', TXMLFPType, TargetNamespace) as IXMLFPType;
end;

function NewFP: IXMLFPType;
begin
  Result := NewXMLDocument.GetDocBinding('FP', TXMLFPType, TargetNamespace) as IXMLFPType;
end;

{ TXMLFPType }

procedure TXMLFPType.AfterConstruction;
begin
  RegisterChildNode('Globals', TXMLGlobalsType);
  RegisterChildNode('SectionA', TXMLSectionAType);
  RegisterChildNode('SectionA1', TXMLSectionA1Type);
  RegisterChildNode('SectionB', TXMLSectionBType);
  RegisterChildNode('SectionC', TXMLSectionCType);
  RegisterChildNode('SectionD', TXMLSectionDType);
  RegisterChildNode('SectionE', TXMLSectionEType);
  RegisterChildNode('SectionF', TXMLSectionFType);
  RegisterChildNode('SectionG', TXMLSectionGType);
  inherited;
end;

function TXMLFPType.Get_Globals: IXMLGlobalsType;
begin
  Result := ChildNodes['Globals'] as IXMLGlobalsType;
end;

function TXMLFPType.Get_SectionA: IXMLSectionAType;
begin
  Result := ChildNodes['SectionA'] as IXMLSectionAType;
end;

function TXMLFPType.Get_SectionA1: IXMLSectionA1Type;
begin
  Result := ChildNodes['SectionA1'] as IXMLSectionA1Type;
end;

function TXMLFPType.Get_SectionB: IXMLSectionBType;
begin
  Result := ChildNodes['SectionB'] as IXMLSectionBType;
end;

function TXMLFPType.Get_SectionC: IXMLSectionCType;
begin
  Result := ChildNodes['SectionC'] as IXMLSectionCType;
end;

function TXMLFPType.Get_SectionD: IXMLSectionDType;
begin
  Result := ChildNodes['SectionD'] as IXMLSectionDType;
end;

function TXMLFPType.Get_SectionE: IXMLSectionEType;
begin
  Result := ChildNodes['SectionE'] as IXMLSectionEType;
end;

function TXMLFPType.Get_SectionF: IXMLSectionFType;
begin
  Result := ChildNodes['SectionF'] as IXMLSectionFType;
end;

function TXMLFPType.Get_SectionG: IXMLSectionGType;
begin
  Result := ChildNodes['SectionG'] as IXMLSectionGType;
end;

{ TXMLGlobalsType }

function TXMLGlobalsType.Get_FPNumber: Integer;
begin
  Result := ChildNodes['FPNumber'].NodeValue;
end;

function TXMLGlobalsType.Get_TGI: string;
begin
  Result := ChildNodes['TGI'].Text;
end;

function TXMLGlobalsType.Get_TotA1: string;
begin
  Result := ChildNodes['TotA1'].Text;
end;

function TXMLGlobalsType.Get_GI: string;
begin
  Result := ChildNodes['GI'].Text;
end;

function TXMLGlobalsType.Get_TotB: string;
begin
  Result := ChildNodes['TotB'].Text;
end;

function TXMLGlobalsType.Get_CGI: string;
begin
  Result := ChildNodes['CGI'].Text;
end;

function TXMLGlobalsType.Get_TotC: string;
begin
  Result := ChildNodes['TotC'].Text;
end;

function TXMLGlobalsType.Get_BalC: string;
begin
  Result := ChildNodes['BalC'].Text;
end;

function TXMLGlobalsType.Get_TotD: string;
begin
  Result := ChildNodes['TotD'].Text;
end;

function TXMLGlobalsType.Get_BalD: string;
begin
  Result := ChildNodes['BalD'].Text;
end;

function TXMLGlobalsType.Get_TotE: string;
begin
  Result := ChildNodes['TotE'].Text;
end;

function TXMLGlobalsType.Get_TotEI: string;
begin
  Result := ChildNodes['TotEI'].Text;
end;

function TXMLGlobalsType.Get_BalE: string;
begin
  Result := ChildNodes['BalE'].Text;
end;

function TXMLGlobalsType.Get_TotF: string;
begin
  Result := ChildNodes['TotF'].Text;
end;

function TXMLGlobalsType.Get_FPBal: string;
begin
  Result := ChildNodes['FPBal'].Text;
end;

function TXMLGlobalsType.Get_FromDate: string;
begin
  Result := ChildNodes['FromDate'].Text;
end;

function TXMLGlobalsType.Get_ToDate: string;
begin
  Result := ChildNodes['ToDate'].Text;
end;

{ TXMLSectionAType }

procedure TXMLSectionAType.AfterConstruction;
begin
  RegisterChildNode('LineA', TXMLLineAType);
  ItemTag := 'LineA';
  ItemInterface := IXMLLineAType;
  inherited;
end;

function TXMLSectionAType.Get_LineA(Index: Integer): IXMLLineAType;
begin
  Result := List[Index] as IXMLLineAType;
end;

function TXMLSectionAType.Add: IXMLLineAType;
begin
  Result := AddItem(-1) as IXMLLineAType;
end;

function TXMLSectionAType.Insert(const Index: Integer): IXMLLineAType;
begin
  Result := AddItem(Index) as IXMLLineAType;
end;

{ TXMLLineAType }

function TXMLLineAType.Get_N: Integer;
begin
  Result := ChildNodes[WideString('N')].NodeValue;
end;

function TXMLLineAType.Get_Sum: string;
begin
  Result := ChildNodes['Sum'].Text;
end;

function TXMLLineAType.Get_Descr: string;
begin
  Result := ChildNodes['Descr'].Text;
end;

function TXMLLineAType.Get_DateTime: string;
begin
  Result := ChildNodes['DateTime'].Text;
end;

function TXMLLineAType.Get_Source: string;
begin
  Result := ChildNodes['Source'].Text;
end;

{ TXMLSectionA1Type }

procedure TXMLSectionA1Type.AfterConstruction;
begin
  RegisterChildNode('LineA1', TXMLLineA1Type);
  ItemTag := 'LineA1';
  ItemInterface := IXMLLineA1Type;
  inherited;
end;

function TXMLSectionA1Type.Get_LineA1(Index: Integer): IXMLLineA1Type;
begin
  Result := List[Index] as IXMLLineA1Type;
end;

function TXMLSectionA1Type.Add: IXMLLineA1Type;
begin
  Result := AddItem(-1) as IXMLLineA1Type;
end;

function TXMLSectionA1Type.Insert(const Index: Integer): IXMLLineA1Type;
begin
  Result := AddItem(Index) as IXMLLineA1Type;
end;

{ TXMLLineA1Type }

function TXMLLineA1Type.Get_N: Integer;
begin
  Result := ChildNodes[WideString('N')].NodeValue;
end;

function TXMLLineA1Type.Get_Descr: string;
begin
  Result := ChildNodes['Descr'].Text;
end;

function TXMLLineA1Type.Get_FP1: string;
begin
  Result := ChildNodes['FP1'].Text;
end;

function TXMLLineA1Type.Get_Percent: string;
begin
  Result := ChildNodes['Percent'].Text;
end;

function TXMLLineA1Type.Get_Sum: string;
begin
  Result := ChildNodes['Sum'].Text;
end;

function TXMLLineA1Type.Get_Fund: string;
begin
  Result := ChildNodes['Fund'].Text;
end;

{ TXMLSectionBType }

procedure TXMLSectionBType.AfterConstruction;
begin
  RegisterChildNode('LineB', TXMLLineBType);
  ItemTag := 'LineB';
  ItemInterface := IXMLLineBType;
  inherited;
end;

function TXMLSectionBType.Get_LineB(Index: Integer): IXMLLineBType;
begin
  Result := List[Index] as IXMLLineBType;
end;

function TXMLSectionBType.Add: IXMLLineBType;
begin
  Result := AddItem(-1) as IXMLLineBType;
end;

function TXMLSectionBType.Insert(const Index: Integer): IXMLLineBType;
begin
  Result := AddItem(Index) as IXMLLineBType;
end;

{ TXMLLineBType }

function TXMLLineBType.Get_N: Integer;
begin
  Result := ChildNodes[WideString('N')].NodeValue;
end;

function TXMLLineBType.Get_Descr: string;
begin
  Result := ChildNodes['Descr'].Text;
end;

function TXMLLineBType.Get_FP1: string;
begin
  Result := ChildNodes['FP1'].Text;
end;

function TXMLLineBType.Get_Percent: string;
begin
  Result := ChildNodes['Percent'].Text;
end;

function TXMLLineBType.Get_Sum: string;
begin
  Result := ChildNodes['Sum'].Text;
end;

function TXMLLineBType.Get_Fund: string;
begin
  Result := ChildNodes['Fund'].Text;
end;

{ TXMLSectionCType }

procedure TXMLSectionCType.AfterConstruction;
begin
  RegisterChildNode('LineC', TXMLLineCType);
  ItemTag := 'LineC';
  ItemInterface := IXMLLineCType;
  inherited;
end;

function TXMLSectionCType.Get_LineC(Index: Integer): IXMLLineCType;
begin
  Result := List[Index] as IXMLLineCType;
end;

function TXMLSectionCType.Add: IXMLLineCType;
begin
  Result := AddItem(-1) as IXMLLineCType;
end;

function TXMLSectionCType.Insert(const Index: Integer): IXMLLineCType;
begin
  Result := AddItem(Index) as IXMLLineCType;
end;

{ TXMLLineCType }

function TXMLLineCType.Get_N: Integer;
begin
  Result := ChildNodes[WideString('N')].NodeValue;
end;

function TXMLLineCType.Get_Descr: string;
begin
  Result := ChildNodes['Descr'].Text;
end;

function TXMLLineCType.Get_FP1: string;
begin
  Result := ChildNodes['FP1'].Text;
end;

function TXMLLineCType.Get_Percent: string;
begin
  Result := ChildNodes['Percent'].Text;
end;

function TXMLLineCType.Get_Sum: string;
begin
  Result := ChildNodes['Sum'].Text;
end;

function TXMLLineCType.Get_Fund: string;
begin
  Result := ChildNodes['Fund'].Text;
end;

{ TXMLSectionDType }

procedure TXMLSectionDType.AfterConstruction;
begin
  RegisterChildNode('LineD', TXMLLineDType);
  ItemTag := 'LineD';
  ItemInterface := IXMLLineDType;
  inherited;
end;

function TXMLSectionDType.Get_LineD(Index: Integer): IXMLLineDType;
begin
  Result := List[Index] as IXMLLineDType;
end;

function TXMLSectionDType.Add: IXMLLineDType;
begin
  Result := AddItem(-1) as IXMLLineDType;
end;

function TXMLSectionDType.Insert(const Index: Integer): IXMLLineDType;
begin
  Result := AddItem(Index) as IXMLLineDType;
end;

{ TXMLLineDType }

function TXMLLineDType.Get_N: Integer;
begin
  Result := ChildNodes[WideString('N')].NodeValue;
end;

function TXMLLineDType.Get_Descr: string;
begin
  Result := ChildNodes['Descr'].Text;
end;

function TXMLLineDType.Get_FP1: string;
begin
  Result := ChildNodes['FP1'].Text;
end;

function TXMLLineDType.Get_Note: string;
begin
  Result := ChildNodes['Note'].Text;
end;

function TXMLLineDType.Get_Sum: string;
begin
  Result := ChildNodes['Sum'].Text;
end;

function TXMLLineDType.Get_Fund: string;
begin
  Result := ChildNodes['Fund'].Text;
end;

{ TXMLSectionEType }

procedure TXMLSectionEType.AfterConstruction;
begin
  RegisterChildNode('LineE', TXMLLineEType);
  ItemTag := 'LineE';
  ItemInterface := IXMLLineEType;
  inherited;
end;

function TXMLSectionEType.Get_LineE(Index: Integer): IXMLLineEType;
begin
  Result := List[Index] as IXMLLineEType;
end;

function TXMLSectionEType.Add: IXMLLineEType;
begin
  Result := AddItem(-1) as IXMLLineEType;
end;

function TXMLSectionEType.Insert(const Index: Integer): IXMLLineEType;
begin
  Result := AddItem(Index) as IXMLLineEType;
end;

{ TXMLLineEType }

function TXMLLineEType.Get_N: Integer;
begin
  Result := ChildNodes[WideString('N')].NodeValue;
end;

function TXMLLineEType.Get_Date: string;
begin
  Result := ChildNodes['Date'].Text;
end;

function TXMLLineEType.Get_Subj: string;
begin
  Result := ChildNodes['Subj'].Text;
end;

function TXMLLineEType.Get_SumR: string;
begin
  Result := ChildNodes['SumR'].Text;
end;

function TXMLLineEType.Get_Sol: string;
begin
  Result := ChildNodes['Sol'].Text;
end;

function TXMLLineEType.Get_SumA: string;
begin
  Result := ChildNodes['SumA'].Text;
end;

function TXMLLineEType.Get_Note: string;
begin
  Result := ChildNodes['Note'].Text;
end;

function TXMLLineEType.Get_Fund: string;
begin
  Result := ChildNodes['Fund'].Text;
end;

{ TXMLSectionFType }

procedure TXMLSectionFType.AfterConstruction;
begin
  RegisterChildNode('LineF', TXMLLineFType);
  ItemTag := 'LineF';
  ItemInterface := IXMLLineFType;
  inherited;
end;

function TXMLSectionFType.Get_LineF(Index: Integer): IXMLLineFType;
begin
  Result := List[Index] as IXMLLineFType;
end;

function TXMLSectionFType.Add: IXMLLineFType;
begin
  Result := AddItem(-1) as IXMLLineFType;
end;

function TXMLSectionFType.Insert(const Index: Integer): IXMLLineFType;
begin
  Result := AddItem(Index) as IXMLLineFType;
end;

{ TXMLLineFType }

function TXMLLineFType.Get_N: Integer;
begin
  Result := ChildNodes[WideString('N')].NodeValue;
end;

function TXMLLineFType.Get_Descr: string;
begin
  Result := ChildNodes['Descr'].Text;
end;

function TXMLLineFType.Get_Percent: string;
begin
  Result := ChildNodes['Percent'].Text;
end;

function TXMLLineFType.Get_Sum: string;
begin
  Result := ChildNodes['Sum'].Text;
end;

function TXMLLineFType.Get_Fund: string;
begin
  Result := ChildNodes['Fund'].Text;
end;

{ TXMLSectionGType }

procedure TXMLSectionGType.AfterConstruction;
begin
  RegisterChildNode('LineG', TXMLLineGType);
  ItemTag := 'LineG';
  ItemInterface := IXMLLineGType;
  inherited;
end;

function TXMLSectionGType.Get_LineG(Index: Integer): IXMLLineGType;
begin
  Result := List[Index] as IXMLLineGType;
end;

function TXMLSectionGType.Add: IXMLLineGType;
begin
  Result := AddItem(-1) as IXMLLineGType;
end;

function TXMLSectionGType.Insert(const Index: Integer): IXMLLineGType;
begin
  Result := AddItem(Index) as IXMLLineGType;
end;

{ TXMLLineGType }

function TXMLLineGType.Get_Acc: string;
begin
  Result := ChildNodes['Acc'].Text;
end;

function TXMLLineGType.Get_Sum: string;
begin
  Result := ChildNodes['Sum'].Text;
end;

end.