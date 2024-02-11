unit DebtListWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  Dialogs, VirtualTrees, Grids, BaseGrid, AdvGrid, ExtCtrls, sPanel, AdvUtil,
  AdvObj, System.ImageList, Vcl.ImgList, acAlphaImageList, Vcl.ComCtrls,
  Vcl.ToolWin, sToolBar, Vcl.Buttons, sSpeedButton, PtblRV, RVStyle, RVScroll,
  RVTable, RVItem, CRVData, RVLabelItem,
  RichView;

type
  TDebtListForm = class(TForm)
    StrGrid: TAdvStringGrid;
    PersonImagesList: TsAlphaImageList;
    PersonToolBar: TsToolBar;
    AddToBalanceButton: TToolButton;
    UserEditToolButton: TToolButton;
    rvOutput: TRichView;
    rvsOutput: TRVStyle;
    RVPrint1: TRVPrint;
    PrintButton: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure StrGridGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure StrGridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush;
      AFont: TFont);
    procedure StrGridUpdateColumnSize(Sender: TObject; ACol: Integer; var AWidth: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AddToBalanceButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure FillFields(RVData: TCustomRVData);
    function GetFieldValueFromDatabase(const FieldName: String): String;
  public
    { Public declarations }
    sPersonID : string;
    sPersonFIO : string;
    sOrgPrefix : string;

    // person's data
    sFamilyName : string;
    sFirstName : string;
    sMiddleName : string;
    sCountry : string;
    sPostalIndex : string;
    sAddress : string;
    sPassportSeries : string;
    sPassportNumber : string;
    sPhoneHome : string;
    sPhoneMobile : string;
    sEMail : string;
  end;

var
  DebtListForm: TDebtListForm;

implementation

{$R *.dfm}

uses
  System.AnsiStrings,
  ZDbcIntfs, // for EZSQLException
  PersonIncomeWindow;

procedure TDebtListForm.FormCreate(Sender: TObject);
begin
  //DebtsTree.Color := clSpecBkColor;
end;

procedure TDebtListForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then begin
    Close;
	end;
end;

procedure TDebtListForm.FormResize(Sender: TObject);
begin
  IniFile.WriteInteger(DebtListSection, 'L', Self.Left);
  IniFile.WriteInteger(DebtListSection, 'T', Self.Top);
  IniFile.WriteInteger(DebtListSection, 'W', Self.Width);
  IniFile.WriteInteger(DebtListSection, 'H', Self.Height);
end;

function TDebtListForm.GetFieldValueFromDatabase(const FieldName: String): String;
begin
  if FieldName = 'familyname' then begin
    Result := sFamilyName
  end
  else if FieldName = 'firstname' then begin
    Result := sFirstName
  end
  else if FieldName = 'middlename' then begin
    Result := sMiddleName
  end
  else if FieldName = 'passportser' then begin
    Result := sPassportSeries
  end
  else if FieldName = 'passportnum' then begin
    Result := sPassportNumber
  end
  else if FieldName = 'date' then begin
    Result := DateToStr(TDate(Now()))
  end
  else if FieldName = 'addressperson' then begin
    Result := sAddress
  end
  else if FieldName = 'weekend' then begin
    Result := DateToStr(GetNextThursday(Now()));
  end
  else if FieldName = 'invtype' then begin
    Result := ''
  end
  else if FieldName = 'phoneh' then begin
    Result := sPhoneHome
  end
  else if FieldName = 'phonem' then begin
    Result := sPhoneMobile
  end
  else if FieldName = 'email' then begin
    Result := sEMail
  end
  else if FieldName = 'descr' then begin
    Result := StrGrid.Cells[2, strGrid.Row]
  end
  else begin
    Result := '(error)'
  end;
end;

procedure TDebtListForm.FillFields(RVData: TCustomRVData);
var i,r,c: Integer;
    table: TRVTableItemInfo;
    FieldName: String;
begin
  for i := 0 to RVData.ItemCount-1 do
    case RVData.GetItemStyle(i) of
      rvsTable:
        begin
          table := TRVTableItemInfo(RVData.GetItem(i));
          for r := 0 to table.Rows.Count-1 do
            for c := 0 to table.Rows[r].Count-1 do
              if table.Cells[r,c]<>nil then
                FillFields(table.Cells[r,c].GetRVData);
        end;
      rvsLabel:
        begin
          FieldName := RVData.GetItemTag(i);
          if FieldName<>'' then begin
            TRVLabelItemInfo(RVData.GetItem(i)).Text := GetFieldValueFromDatabase(FieldName);
            TRVLabelItemInfo(RVData.GetItem(i)).UpdateMe;
          end;
        end;
    end;
end;

procedure TDebtListForm.PrintButtonClick(Sender: TObject);
var
  PrintIt: Boolean;
begin
  {$IFDEF RICHVIEWDEF3}
  PrintIt := psd.Execute;
  {$ELSE}
  PrintIt := True;
  {$ENDIF}
  if PrintIt then begin
    // load template
    rvOutput.LoadRVF(ExtractFilePath(Application.ExeName)+'\templates\Invoice.rvf');
    FillFields(rvOutput.RVData);
    rvOutput.Format;

    RVPrint1.AssignSource(rvOutput);
    RVPrint1.FormatPages(rvdoALL);
    if RVPrint1.PagesCount > 0 then
      RVPrint1.Print('Инвойс Иванов И. И.', 1, False);
  end;
end;

procedure TDebtListForm.AddToBalanceButtonClick(Sender: TObject);
var
  IncomeForm : TPersonIncomeForm;
  IncSrcID : integer;
  IncSrcDescr : string;
  fIncome : extended;
  fAmount : extended;
  balance : extended;
  PersAcc : string;
  bIsOK   : boolean;
  TxID    : integer;
begin
  TxID := 0;

  IncomeForm := TPersonIncomeForm.Create(nil);
  IncomeForm.PersonEdit.Text := sPersonFIO;

  FPMainDataset.SQL.Text := 'SELECT ID,title FROM ' + sOrgPrefix + 'incomesources ORDER BY title';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    IncomeForm.SourcesCombo.AddItem(FPMainDataset.FieldByName('title').AsString, pointer(FPMainDataset.FieldByName('ID').AsInteger));
    FPMainDataset.Next;
  end;

  if IncomeForm.ShowModal = mrOk then begin
    if IncomeForm.SourceRadioBtn.Checked then begin
      IncSrcID := integer(IncomeForm.SourcesCombo.Items.Objects[IncomeForm.SourcesCombo.ItemIndex]);
      IncSrcDescr := IncomeForm.SourcesCombo.Items[IncomeForm.SourcesCombo.ItemIndex];
    end
    else begin
      IncSrcID := -1;
      IncSrcDescr := IncomeForm.OtherEdit.Text;
    end;

    if 1 < StrGrid.RowCount then begin
      PersAcc := StrGrid.Cells[5, 1];
      PersAcc := ReplaceStr(ReplaceStr(PersAcc, '.',','),ThSep,'');
      if not TryStrToFloat(ReplaceStr(ReplaceStr(StrGrid.Cells[5, 1], '.',','),ThSep,''), fAmount) then begin
        GlobalVars.ShowError(Self, 'Некорректная конфигурация списка.', 0, '', '');
        IncomeForm.Free;
        Exit;
      end;
    end
    else begin
      fAmount := 0;
    end;

    // add info to the balances table
    fIncome := IncomeForm.AmountEdit.Value;
    balance := fAmount + fIncome;
    PersAcc := sOrgPrefix + 'person_balances';
    bIsOK := true;

    try
      FPConnection.StartTransaction;
      // update person's balance
      FPMainDataset.SQL.Text := 'INSERT INTO ' + PersAcc + '(`Date`,`UserID`,`PersonID`,`ServiceID`,`ServiceDescr`,`price`,`amount`,`income`,`balance`,`refidx`,`iscash`)';
      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'VALUES(:fDate,:fUserId,:fPersonId,:fServiceId,:fServiceDescr,:fPrice,:fAmount,:fIncome,:fBalance,:fRefIdx,:fIsCash)';
      FPMainDataset.ParamByName('fDate').AsDateTime 		:= Now;
      FPMainDataset.ParamByName('fUserID').AsInteger 		:= FPUserID;
      FPMainDataset.ParamByName('fPersonID').AsString	:= sPersonId;
      FPMainDataset.ParamByName('fServiceID').AsInteger	:= IncSrcID;
      if 0 < IncSrcID then begin
        FPMainDataset.ParamByName('fServiceDescr').AsString := '';
      end
      else begin
        FPMainDataset.ParamByName('fServiceDescr').AsString := IncSrcDescr;
      end;

      FPMainDataset.ParamByName('fPrice').AsFloat      	:= fAmount;
      FPMainDataset.ParamByName('fAmount').AsInteger    := 1;
      FPMainDataset.ParamByName('fIncome').AsFloat      := fIncome;
      FPMainDataset.ParamByName('fbalance').AsFloat  		:= balance;
      FPMainDataset.ParamByName('fRefIdx').AsInteger    := -1;
      FPMainDataset.ParamByName('fIsCash').AsInteger    := 0;
      FPMainDataset.ExecSQL;

      // get transaction ID
      FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() AS lid';
      FPMainDataset.Open;
      if not FPMainDataset.Eof then begin
        TxID := FPMainDataset.FieldByName('lid').AsInteger;
      end;

      if TxID > 0 then begin
        FPConnection.Commit;
      end
      else begin
        GlobalVars.ShowError(Self, 'Ошибка записи в базу.', 0, '', '');
        FPConnection.Rollback;
        bIsOK := false;
      end
    except
      on e: EZSQLException do begin
        GlobalVars.ShowError(Self, 'Во время сохранеия записи прихода произошла ошибка. Ответ сервера приведён ниже', e.ErrorCode, e.StatusCode, e.Message);
        FPConnection.Rollback;
        bIsOK := false;
      end;
    end;

    if bIsOk then begin
      StrGrid.InsertRows(1, 1);
      StrGrid.Cells[0, 1] := IntToStr(TxID);
      StrGrid.Cells[1, 1] := DateToStr(Now(), lFormatString);
      StrGrid.Cells[2, 1] := IncSrcDescr;
      StrGrid.Cells[3, 1] := MyFloatToStr(fAmount);
      StrGrid.Cells[4, 1] := MyFloatToStr(0);
      StrGrid.Cells[5, 1] := MyFloatToStr(balance);
      if IncomeForm.PrintCheckBox.Checked then begin

      end;
    end;
    // add info to the balances table - end of
  end;
  IncomeForm.Free;
end;

procedure TDebtListForm.StrGridGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if Pos('h_', StrGrid.Cells[0, ARow]) > 0 then
    HAlign := taCenter
  else if (Pos('tot', StrGrid.Cells[0, ARow]) > 0) or ('gt' = StrGrid.Cells[0, ARow])then begin
    if ACol = 6 then
      HAlign := taRightJustify
    else
      HAlign := taLeftJustify;
  end
  else begin
    if (ACol = 2) or (ACol = 7) then
      HAlign := taLeftJustify
    else
      HAlign := taRightJustify;
  end;
end;

procedure TDebtListForm.StrGridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  AFont.Color := clBlack;
  if Pos('green', StrGrid.Cells[0, ARow]) > 0 then begin
    AFont.Color := clGreen
  end
  else if Pos('red', StrGrid.Cells[0, ARow]) > 0 then begin
    AFont.Color := clRed;
  end;
  if (Pos('h_', StrGrid.Cells[0, ARow]) > 0) or (Pos('tot', StrGrid.Cells[0, ARow]) > 0) or ('gt' = StrGrid.Cells[0, ARow])then begin
    AFont.Style := [fsBold];
    ABrush.Color := NormalBkColor;
  end;
end;

procedure TDebtListForm.StrGridUpdateColumnSize(Sender: TObject; ACol: Integer; var AWidth: Integer);
begin
  IniFile.WriteInteger(DebtListSection, 'C' + IntToStr(ACol), AWidth);
end;

end.
