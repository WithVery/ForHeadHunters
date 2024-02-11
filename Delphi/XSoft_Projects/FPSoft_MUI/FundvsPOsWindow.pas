unit FundvsPOsWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, VirtualTrees, StdCtrls, sComboBox, sLabel;

type
  TFundvsPOsForm = class(TForm)
    sPanel1: TsPanel;
    FLabel: TsLabel;
    FCombo: TsComboBox;
    POLabel: TsLabel;
    POList: TVirtualStringTree;
    procedure FormShow(Sender: TObject);
    procedure FComboCloseUp(Sender: TObject);
    procedure POListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FComboChange(Sender: TObject);
    procedure POListDblClick(Sender: TObject);
  private
    { Private declarations }
    FundList		: TList;
    CurIndex    : integer;
    procedure FundChanged;
  public
    { Public declarations }
    CurFundName : string;
    OPrefix     : string;

  end;

//var
//  FundvsPOsForm: TFundvsPOsForm;

implementation

{$R *.dfm}

uses
	POWindow,
  ZDbcIntfs,  // for EZSQLException
  ComCtrls,   // for TListItem
  MainFPWin,
	GlobalVars;

procedure TFundvsPOsForm.FComboChange(Sender: TObject);
begin
	FundChanged;
end;

procedure TFundvsPOsForm.FComboCloseUp(Sender: TObject);
begin
//	FundChanged;
end;

procedure TFundvsPOsForm.FormShow(Sender: TObject);
var
	i : integer;

begin
	// Tree init
	POList.NodeDataSize := SizeOf(TPOData);

  // pull the fund data
  CurIndex := -1;
	FundList 	:= CompFondList(OPrefix + 'fond', 0, CFL_WITHGROUPS, CFL_IGNOREPOS, OPrefix, true); // it's processed in AssetComboChange function (?)
	for I := 0 to FundList.Count - 1 do begin
    FCombo.Items.Add(PVTResourceData(FundList[i]).name);
 		if PVTResourceData(FundList[i]).name = CurFundName then CurIndex := i;
  end;
  FCombo.ItemIndex := CurIndex;
	FundChanged;
end;

procedure TFundvsPOsForm.FundChanged;
var
  NodeData : PPOData;
  Node     : PVirtualNode;
  flink    : string;
begin
  //
  POList.Clear;
	flink := PVTResourceData(FundList[FCombo.ItemIndex]).link;
  if flink = '' then exit;

	FPMainDataset.SQL.Text := 'SELECT`index`,`date`,`re`,`suma`FROM ' + OPrefix + 'po WHERE fond=:flink AND`status`in(2,4)ORDER BY `index` DESC';
  FPMainDataset.ParamByName('flink').AsString := flink;

  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    Node := POList.AddChild(nil);
    NodeData := POList.GetNodeData(Node);

    NodeData.index    := FPMainDataset.FieldByName('index').AsInteger;
    NodeData.re       := FPMainDataset.FieldByName('re').AsString;
    NodeData.Day      := FPMainDataset.FieldByName('date').AsDateTime;
    NodeData.origin   := '';
    NodeData.FPNum    := 0;
    NodeData.SumA     := FPMainDataset.FieldByName('suma').AsExtended;
    NodeData.FondLink := '';
    NodeData.Note			:= '';
    NodeData.bycash   := false;
    NodeData.alink    := '';
    FPMainDAtaset.Next;
  end;
end;

procedure TFundvsPOsForm.POListDblClick(Sender: TObject);
var
	NodeData 		: PPOdata;
  Node     		: PVirtualNode;
	item				: TListItem;
  PONum				: integer;
  OrigPost		: string;
  OrigName		: string;
  FileInfo		: PAttInfo;
	POForm 			: TPOForm;
begin
  Node := POList.GetFirstSelected;
  if Node = nil then exit;
  NodeData := POList.GetNodeData(Node);

  // show approved PO
  PONum := NodeData.index;

  	FPTmpDataset.SQL.Text := 'SELECT * FROM`' + OPrefix + 'po`WHERE`index`=' + IntToStr(PONum);
    try
  	  FPTmpDataset.Open;
    except
      on e: EZSQLException do begin
        ShowError(Self, 'При попытке получить данные о заявке.', e.ErrorCode, e.StatusCode, e.Message);
        exit;
      end;
    end;

	POForm := TPOForm.Create(Self);
  POForm.OPPrefix := OPrefix;

	POForm.BeingEdited	        := false;
	POForm.Caption              := 'Заявка № ' + IntToStr(PONum) + ' от ' + DateToStr(FPTmpDataset.FieldByName('date').AsDateTime);
  POForm.PONum		            := PONum;
  POForm.SubjectEdit.Text     := FPTmpDataset.FieldByName('csw').AsString;
  POForm.SubjectEdit.Enabled  := POForm.BeingEdited;

  POForm.CashCB.Checked := boolean(FPTmpDataset.FieldByName('bycash').AsInteger);
	POForm.CashCB.Enabled	:= false;
  POForm.OrgCombo.Items.Add('');

  if POForm.OrgCombo.Items.Count < 1 then begin
	  Application.MessageBox('Невозможно создать список организаций', 'Редактирование заявки на ФП', MB_ICONINFORMATION or MB_OK);
    POForm.Free;
    Exit;
  end
  else begin
    POForm.OrgCombo.ItemIndex  := 0;
    POForm.OrgCombo.Enabled    := false;
  end;

	POForm.SumEdit.Text           := MyFloatToStr(NodeData.SumA);
	POForm.SumEdit.Enabled        := false;
  POForm.TextMemo.Text          := FPTmpDataset.FieldByName('csw').AsString;
  POForm.TextMemo.ReadOnly      := not POForm.BeingEdited; // we can edit the area in the case of editing
  POForm.AttestCheckBox.Checked := true;
  POForm.AttestCheckBox.Enabled := false;
  POForm.SubmitButton.Visible   := POForm.BeingEdited;

  POForm.ResetButton.Visible    	:= POForm.BeingEdited;
  POForm.UrgencyCheckBox.Enabled	:= POForm.BeingEdited;
  POForm.UrgencyCheckBox.Checked	:= (FPTmpDataset.FieldByName('status').AsInteger = -1) or (FPTmpDataset.FieldByName('status').AsInteger in [4, 5]);

  POForm.CancelButton.Caption   := 'Закрыть';
  POForm.OrigDate	:= FPTmpDataset.FieldByName('date').AsDateTime;

  with FPMainDataset do begin
		SQL.Text := 'SELECT tbl2.*,' + OPrefix + 'postsdir.Abbr FROM ' + OPrefix + 'postsdir JOIN' +
                '(SELECT PostID,userid,FName,MName,FamilyName FROM ' + OPrefix + 'psts JOIN' +
                '(SELECT pstsid,userid,FirstName AS FName,MiddleName AS MName,FamilyName FROM ' + OPrefix + 'pstsfills JOIN allusers ' +
                'USING(UserID)WHERE allusers.login=:fLogin and(Now()>=startdate)AND((Now()<enddate)or(enddate is NULL)))AS tbl1 ' +
                'ON tbl1.pstsid=' + OPrefix + 'psts.id)AS tbl2 ON tbl2.PostID=' + OPrefix + 'postsdir.ID';// LOCK IN SHARE MODE';
  	ParamByName('fLogin').AsString := FPTmpDataset.FieldByName('origin').AsString;
  	Open;
  	OrigPost  := FieldByName('Abbr').AsString;
  	OrigName	:= GetShortFIO(FieldByName('FamilyName').AsString, FieldByName('FName').AsString, FieldByName('MName').AsString);
  end;

  POForm.OrigPost := OrigPost;
  POForm.OrigName	:= OrigName;

  POForm.AttestLabel.Caption := 'Я, ' + OrigName + ', ' + OrigPost +
													      ', подтверждаю, что данный расход действительно необходим для работы организации и цена является оптимальной.';

	POForm.btnAddFiles.Visible := POForm.BeingEdited;

  FPMainDataset.SQL.Text := 'SELECT id,FileName FROM '+ OPrefix + 'poatt WHERE PONum=:fPONum';

  FPMainDataset.ParamByName('fPONum').AsInteger := PONum;
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
  	New(FileInfo);
    FileInfo.FullName := FPMainDataset.FieldByName('FileName').AsString;
    FileInfo.POAttID  := FPMainDataset.FieldByName('id').AsInteger;

		item := POForm.FilesListView.Items.Add;
		item.Caption 		:= FileInfo.FullName;
		item.ImageIndex := 0;
    item.Data				:= FileInfo;
    FPMainDataset.Next;
  end;

  if not POForm.BeingEdited then begin
	  POForm.FilesListView.Width := POForm.TextMemo.Width;
    if POForm.FilesListView.Items.Count < 1 then begin
  	  POForm.TextMemo.Height := POForm.FilesListView.Height + POForm.FilesListView.Top - POForm.TextMemo.Top;
	    POForm.FilesListView.Visible := false;
    end;
  end;

  POForm.OrgCombo.Enabled := false;
  POForm.OrgCombo.Visible := false;
  POForm.OrgLabel.Visible := false;

  POForm.ShowModal;
  POForm.Destroy;
end;

procedure TFundvsPOsForm.POListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
	NodeData : PPOData;
begin
	if assigned(Node) then begin
		NodeData := Sender.GetNodeData(Node);
		case Column of
    	0 : begin
      	CellText := IntToStr(NodeData.index);
	    end;
  	  1 : begin
      	CellText := DateToStr(NodeData.Day);
	    end;
  	  2 : begin
      	CellText := NodeData.re;
	    end;
  	  3 : begin
      	CellText := MyFloatToStr(NodeData.SumA);
	    end;
  	end;
  end;
end;

end.
