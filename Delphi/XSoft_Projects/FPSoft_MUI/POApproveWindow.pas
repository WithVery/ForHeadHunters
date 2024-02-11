unit POApproveWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sComboBox, sGroupBox, sCheckBox, sMemo, sEdit, sLabel,
  AttLoaderThread, // for background attachments loading
//  JPEG,
  POLockerThread,
  LoadingProgressWindow, // for LoadingProgressForm
  GlobalVars,
  sButton, sRadioButton, AdvEdit, AdvMoneyEdit, ExtCtrls, sPanel, ComCtrls, sListView, ImgList, acAlphaImageList, Menus, jpeg;

type
  TPOApproveForm = class(TForm)
    sLabel1: TsLabel;
    PONumEdit: TsEdit;
    sLabel2: TsLabel;
    POSumEdit: TsEdit;
    sLabel3: TsLabel;
    SubjectEdit: TsEdit;
    sLabel4: TsLabel;
    TextMemo: TsMemo;
    sGroupBox1: TsGroupBox;
    lblSource: TsLabel;
    SourceCombo: TsComboBox;
    lblApprovedSum: TsLabel;
    lblNote: TsLabel;
    NoteMemo: TsMemo;
    SubmitButton: TsButton;
    CancelButton: TsButton;
    ApproveRadioButton: TsRadioButton;
    RejectRadioButton: TsRadioButton;
    ApprovedSumEdit: TAdvMoneyEdit;
    sPanel1: TsPanel;
    PrintButton: TsButton;
    PD: TPrintDialog;
    lblFiles: TsLabel;
    FilesListView: TsListView;
    PopUpImages: TsAlphaImageList;
    FilesListPopupMenu: TPopupMenu;
    ShowFilePopPup: TMenuItem;
    TmpImage: TImage;
    SaveAsPopUp: TMenuItem;
    SaveDlg: TSaveDialog;
    CashCB: TsCheckBox;
    rbPutAside: TsRadioButton;
    procedure ApproveRadioButtonClick(Sender: TObject);
    procedure RejectRadioButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SubmitButtonClick(Sender: TObject);
    procedure SourceComboChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShowFilePopPupClick(Sender: TObject);
    procedure FilesListPopupMenuPopup(Sender: TObject);
    procedure FilesListViewDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintAttClick(Sender: TObject);
    procedure PrintAllAttsClick(Sender: TObject);
    procedure SaveAsPopUpClick(Sender: TObject);
    procedure CashCBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbPutAsideClick(Sender: TObject);
  private
    { Private declarations }
    ALLoader				: TAttLoaderThread;
    LoadedAtts			: TList;
    UrgentAddNeeded	: string;
	  lpf             : TLoadingProgressForm; // for LoadingProgressForm

    CAFPPost        : string;
    POLTInitedLocally : boolean;

    function SubmitButtonActive : boolean;
    procedure AttLoad(var Msg: TMessage); message UM_ATT_LOAD;
    procedure AttLoadStarted(var Msg: TMessage); message UM_ATT_LOAD_STARTED;
    procedure AttLoadIP(var Msg: TMessage); message UM_ATT_LOAD_IP;
    procedure AttLoaded(var Msg: TMessage); message UM_ATT_LOADED;
    procedure AttOpen(var Msg: TMessage); message UM_ATT_OPEN;
    procedure FailedToLoad(var Msg: TMessage); message UM_ATT_LOADINGFAILED;
  public
    { Public declarations }
    FundList  	: TList;
    CurFundLink : string;
    Urgent			: boolean;
    OutOfFP			: boolean;
    FormIsRO		: boolean;
    OrigDate		: TDate;
    PONum				: integer;
    OrigName		: string;
    OrigPost		: string;
    CAPrefix    : string;
    CAPrefixID  : integer;
    WithFndr    : boolean;
    paid        : boolean;
    datep       : TDateTime;
    sump        : extended;
    procedure InitLists;
    procedure InitAtts;
  end;

//var
//  POApproveForm: TPOApproveForm;

implementation

{$R *.dfm}
Uses
	sRichEdit,
//	ImageViewerWindow,
  DB,
  ShellAPI, // for drag features
  StrUtils,
  ZDbcIntfs,
  Printers;
//  GlobalVars;

procedure TPOApproveForm.AttLoad(var Msg: TMessage);
var
	AttID      : integer;
  AttName		: string;
  i							: integer;
  AttToLoad : PAttInfo;
  bFound : boolean;
begin
	AttID := Msg.WParam;
  if (AttID <= 0) then exit;
  bFound := false;

  for i := 0 to FilesListView.Items.Count - 1 do begin
  	if PAttInfo(FilesListView.Items[i].Data).POAttID = AttID then begin
      New(AttToLoad);
      AttToLoad.OrgID := PAttInfo(FilesListView.Items[i].Data).OrgID;
      AttToLoad.POAttID := AttID;
      AttName := FilesListView.Items[i].Caption;

	  	LoadingAttsCS.Enter;
			LoadingAtts.Insert(0, pointer(AttToLoad));
      LoadingAttsCS.Leave;
      AttNeededEvent.SetEvent;
		  bFound     := true;
      break;
    end;
  end;

  // if found we have to open progress window
  if bFound then begin
	  lpf             := TLoadingProgressForm.Create(nil); // for LoadingProgressForm
		lpf.BorderStyle := bsNone;
    lpf.Lbl.Caption := 'Скачиваем ' + AttName;
  end;
end;

procedure TPOApproveForm.AttLoadStarted(var Msg: TMessage);
begin
	lpf.PB.MaxValue := Msg.WParam;
  lpf.PB.MinValue := 0;
  lpf.PB.Progress := 0;
  lpf.Width    := 250;
  lpf.Height   := 90;
  lpf.Show;
end;

procedure TPOApproveForm.AttLoadIP(var Msg: TMessage);
begin
  lpf.PB.Progress := Msg.WParam;
end;

procedure TPOApproveForm.AttLoaded(var Msg: TMessage);
var
  AttLoaded : PAttInfo;
  i         : integer;
  OK        : boolean;
begin

	OK := false;
	AttLoaded := PAttInfo(pointer(Msg.WParam));
  for i := 0 to FilesListView.Items.Count - 1 do begin
  	if AttLoaded.POAttID = PAttInfo(FilesListView.Items[i].Data).POAttID then begin
	    PAttInfo(FilesListView.Items[i].Data).Stream := TMemoryStream.Create;
    	PAttInfo(FilesListView.Items[i].Data).Stream.LoadFromStream(AttLoaded.Stream);
      PAttInfo(FilesListView.Items[i].Data).state := AS_LOADED;
      OK := true;
      break;
    end;
  end;
  AttLoaded.Stream.Free;
	lpf.Destroy;
  if OK then PostMessage(Self.Handle, UM_ATT_OPEN, AttLoaded.POAttID, 0);
  Dispose(AttLoaded);
end;

procedure TPOApproveForm.AttOpen(var Msg: TMessage);
var
  AttID    : integer;
  i         : integer;
  j         : integer;
  FileName  : string;
  FileExt   : string;
  FinalName : string;
  FilePath  : string;
begin
	AttID := Msg.WParam;
  for i := 0 to FilesListView.Items.Count - 1 do begin
  	if AttID = PAttInfo(FilesListView.Items[i].Data).POAttID then begin
      if PAttInfo(FilesListView.Items[i].Data).state = AS_LOCAL then begin
      	FilePath := PAttInfo(FilesListView.Items[i].Data).FullName;
      end
      else begin
	    	FileName := PAttInfo(FilesListView.Items[i].Data).FileName;
  	    FileExt  := ExtractFileExt(FileName);
      	FileName := LeftStr(FileName, Length(FileName) - Length(FileExt));
    	  FinalName := FileName + FileExt;
	      j := 1;
  	    while FileExists(USERTMPFOLDER + '\' + FinalName) do begin
	  	    FinalName := FileName + ' (' + IntToStr(j) + ')' + FileExt;
	        inc(j);
  	    end;
        FilePath := USERTMPFOLDER  + '\' + FinalName;
    	  PAttInfo(FilesListView.Items[i].Data).Stream.SaveToFile(FilePath);
      end;
      j := ShellExecute(Handle, 'open', PWideChar(FilePath), nil, nil, SW_SHOWNORMAL);
			if j <= 32 then begin
        ShowError(Self, 'Во время открытия файла "' + FilePath + '" произошла ошибка.', j, '', '');
      end;
      break;
    end;
  end;
end;

procedure TPOApproveForm.FailedToLoad(var Msg: TMessage);
var
  i     : integer;
  AttID : integer;
  ErrorMessage : ^string;
begin
	AttID := Msg.WParam;
  ErrorMessage := pointer(Msg.LParam);
  for i := 0 to FilesListView.Items.Count - 1 do begin
  	if AttID = PAttInfo(FilesListView.Items[i].Data).POAttID then begin
      PAttInfo(FilesListView.Items[i].Data).state := AS_LOADINGFAILED;
      ShowError(self, 'Ошибка при скачивании файла', 0, 'Файл: ' + PAttInfo(FilesListView.Items[i].Data).FileName, 'Ответ сервера: ' + ErrorMessage^);
      Dispose(ErrorMessage);
      break;
    end;
  end;
end;

procedure TPOApproveForm.InitAtts;
var
  AttInfo	: PAttInfo;
//  item			: TListItem;
begin
  // pulling files attached to PO
  FPMainDataset.SQL.Text := 'SELECT id,FileName FROM ' + CAPrefix + 'poatt WHERE PONum=:fPONum';
  FPMainDataset.ParamByName('fPONum').AsInteger := PONum;
  FPMainDataset.Open;
  if FPMainDataset.RecordCount > 0 then
	  while not FPMainDataset.Eof do begin
	  	New(AttInfo);
  	  AttInfo.FileName := FPMainDataset.FieldByName('FileName').AsString;
    	AttInfo.POAttID  := FPMainDataset.FieldByName('id').AsInteger;
	    AttInfo.OrgID    := CAPrefixID;
  	  AttInfo.FullName := AttInfo.FileName;
    	AttInfo.state    := AS_NOTLOADED; // not loaded
    	FilesListView.AddItem(AttInfo.FileName, pointer(AttInfo));

    	FPMainDataset.Next;
	  end
  else begin
    TextMemo.Width 				:= FilesListView.Left + FilesListView.Width - TextMemo.Left;
    FilesListView.Visible		:= false;
    lblFiles.Visible	:= false;
  end;
end;

procedure TPOApproveForm.InitLists;
var
  i         : integer;
  ResData 	: PVTResourceData;
begin
	if OutOfFP then begin
	  FundList  := TList.Create;
		FundList  := CompFondList(CAPrefix + 'fond', 0, CFL_IGNOREGROUPS, CFL_CONSIDERPOS, CAPrefix, true);  // parsing funds only, no subfunds
  end;
	if FormIsRO then
  	Exit;

  ListFilterOut(FundList, CAPrefix, WithFndr);
  SourceCombo.Clear;
  for i := 0 to FundList.Count - 1 do begin
    SourceCombo.Items.Add(PVTResourceData(FundList[i]).name + ' (' + MyFloatToStr(PVTResourceData(FundList[i]).balance) + ')');
  end;
  SourceCombo.ItemIndex := 0;
  SourceComboChange(Self);
end;

procedure TPOApproveForm.PrintAllAttsClick(Sender: TObject);
var
  AttName  : string;
  i				 : integer;
  Item		 : PImageToPrint;
begin
//
	if not PD.Execute then
  	Exit;

  i := 0;
  while i <= FilesListView.Items.Count - 1 do begin
    LoadingAttsCS.Enter;
  	if i <= LoadedAtts.Count - 1 then begin
	  	Item := LoadedAtts[i];
	    if assigned(Item) and Item.ItemIsOK then begin
        TmpImage.Picture.Graphic.LoadFromStream(Item.ImStream);
        LoadingAttsCS.Leave;

				Printer.Title := Item.ImgName;

			  PrintGraphic(Printer, TmpImage.Picture.Graphic);
      end
      else begin
        LoadingAttsCS.Leave;
      end;
      inc(i);
    end //
    else begin // i.e. not all files have been loaded
			LoadingAttsCS.Leave;
      sleep(40);
      Application.ProcessMessages;
    end;
  end;

end;

procedure TPOApproveForm.PrintAttClick(Sender: TObject);
var
  AttName  : string;
  i				 : integer;
  Item		 : PImageToPrint;

begin
//
	if not PD.Execute then
  	Exit;

  repeat
    sleep(40);
		Item := nil;
		AttName := PAttInfo(FilesListView.Items[FilesListView.ItemIndex].Data).FullName;
	  for i := 0 to LoadedAtts.Count - 1 do begin
  		Item := LoadedAtts[i];
	    if Item.ImgName = AttName then begin
  	  	break;
    	end;
	  end;

	  if i < LoadedAtts.Count then begin
  	  if not Item.ItemIsOK then begin
    	  Application.MessageBox('При загрузке приложения произошла ошибка', 'Приложения к заявке на ФП', MB_ICONINFORMATION or MB_OK);
  	    Exit;
	    end;
  	end;
    Application.ProcessMessages;

  until (i < LoadedAtts.Count);

	TmpImage.Picture.Graphic.LoadFromStream(Item.ImStream);

	Printer.Title := AttName;

  PrintGraphic(Printer, TmpImage.Picture.Graphic);

end;

procedure TPOApproveForm.PrintButtonClick(Sender: TObject);
var
	RE				: TsRichEdit;
  HeadLine	: string;
begin
	if not PD.Execute then
  	Exit;

	RE				:=	TsRichEdit.Create(nil);
  RE.Parent := 	Self;
	RE.PageRect := Rect(round(Printer.PageWidth * 0.05), round(Printer.PageHeight * 0.05), round(Printer.PageWidth * 0.9), round(Printer.PageHeight * 0.9));

  RE.Clear;
  RE.Paragraph.Alignment := taRightJustify;
  if OrigDate <> 0 then
	  RE.Lines.Add(DateToStr(OrigDate))
  else
	  RE.Lines.Add(DateToStr(now));
  RE.Lines.Add('');

  RE.Paragraph.Alignment	:= taCenter;
  if PONum = 0 then
	  HeadLine	:=	'Заявка № (б/н) на финансовое планирование'
  else
	  HeadLine	:= 'Заявка № ' + IntToStr(PONum) + ' на финансовое планирование';
  RE.Lines.Add(HeadLine);
  RE.Lines.Add('');

  RE.Paragraph.Alignment	:= taCenter;
  RE.Lines.Add('Тема: ' + Self.SubjectEdit.Text);
  RE.Lines.Add('');

  RE.Paragraph.Alignment := taLeftJustify;
  RE.Paragraph.FirstIndent	:= Canvas.TextWidth('     ');
  RE.Paragraph.LeftIndent		:= -RE.Paragraph.FirstIndent;
  RE.Lines.Add(TextMemo.Text);

  RE.Paragraph.Alignment := taLeftJustify;
  RE.Lines.Add('');
  RE.Lines.Add('');

  RE.Lines.Add('Я подтверждаю необходимость указанных расходов');
  if OrigName = '' then
  	Re.Lines.Add(FPNameOfUser)
  else
	  Re.Lines.Add(OrigName);
  if OrigPost = '' then
  	Re.Lines.Add(CAFPPost)
  else
	  Re.Lines.Add(OrigPost);

  RE.Lines.Add('');
  RE.Lines.Add('');
  RE.Lines.Add('');

  Re.Paragraph.Alignment	:= taCenter;
  Re.Lines.Add('_______________ Одобрено'+Chr(9)+Chr(9)+Chr(9)+Chr(9)+Chr(9)+'_______________ Неодобрено');

  RE.Lines.Add('');
  RE.Lines.Add('');
  Re.Lines.Add('Решение:');
  if Self.ApproveRadioButton.Checked then
	  Re.Lines.Add('Одобрить ' + MyFloatToStr(ApprovedSumEdit.Value))
  else
	  Re.Lines.Add('Отклонить ');

  RE.Lines.Add('');
  Re.Lines.Add(NoteMemo.Text);
  if Paid then begin
	  RE.Lines.Add('');
	  RE.Lines.Add(' Оплачено :');
	  RE.Lines.Add(MyFloatToStr(sump) + '  ' + DateTimeToStr(datep));
  end;

  RE.Print(HeadLine);

  Re.Free;
end;

procedure TPOApproveForm.rbPutAsideClick(Sender: TObject);
begin
  SourceCombo.Enabled     := false;
  ApprovedSumEdit.Enabled := false;
  CashCB.Enabled          := false;
  SubmitButton.Caption    := rbPutAside.Caption;
  SubmitButtonActive;
end;

procedure TPOApproveForm.ApproveRadioButtonClick(Sender: TObject);
var
	TmpValue	: extended;
begin
  SourceCombo.Enabled     := true;
  ApprovedSumEdit.Enabled := true;
  CashCB.Enabled          := true;
  SubmitButton.Caption    := ApproveRadioButton.Caption;
  SubmitButtonActive;
  if (ApprovedSumEdit.Value = 0) and (TryStrToFloat(MyCleanStr(POSumEdit.Text), TmpValue)) then begin
    ApprovedSumEdit.Value := TmpValue;
  end;
  SubmitButtonActive;
end;

procedure TPOApproveForm.CashCBClick(Sender: TObject);
begin
  SubmitButtonActive;
end;

procedure TPOApproveForm.FilesListPopupMenuPopup(Sender: TObject);
begin
  FilesListPopUpMenu.Items[0].Enabled := FilesListView.ItemIndex > -1;
  FilesListPopUpMenu.Items[1].Enabled := FilesListView.ItemIndex > -1;
end;

procedure TPOApproveForm.FilesListViewDblClick(Sender: TObject);
begin
	ShowFilePopPupClick(Sender);
end;

procedure TPOApproveForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	// we do not need to load anything after the window is closed
  ALLoader.Terminate;
  WaitForSingleObject(ALLoader.Handle, INFINITE);
  ALLoader := nil;
end;

procedure TPOApproveForm.FormCreate(Sender: TObject);
begin
  CAPrefix    := '';
  LoadedAtts	:= TList.Create;

  SubmitButton.Enabled  := false;
  SourceComboChange(Sender); // must be removed to other place as it's misplaced
  POLTInitedLocally := false;

  ALLoader := nil;
end;

procedure TPOApproveForm.FormDestroy(Sender: TObject);
begin
	if OutOfFP then
  	FundList.Free;

  if POLTInitedLocally and Assigned(POLT) then begin
    POLT.Terminate;
    POLockEvent.SetEvent;
    WaitForSingleObject(POLT.Handle, INFINITE);
    POLT := nil;
  end;
end;

procedure TPOApproveForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and
//  	(	(POApproveForm.TextMemo.ReadOnly)
  	(	(TextMemo.ReadOnly)
      or
    	(Application.MessageBox('Закрыть окно?', 'Запрос на закрытие окна', MB_YESNO or MB_ICONQUESTION) = IDYES)
		) then begin
  	ModalResult := mrCancel;
  end;
end;

procedure TPOApproveForm.FormShow(Sender: TObject);
var
	AFileInfo	: PAttInfo;
	OFileInfo	: PAttInfo;
  i					: integer;
begin

  if not FormIsRO and (PONum > 0) and (POLT = nil) then begin
    POLT := TPOLockerThread.Create(TRUE);
    POLT.POTGC      := FPConnection;
    POLT.POTUID     := FPUserID;
    POLT.POFilter   := '`index`=' + IntToSTr(PONum);
    POLT.POTOPrefix := CAPrefix;

    POLT.Priority        := tpLower;
    POLT.FreeOnTerminate := true;
    POLT.Resume;

    POLockEvent.WaitFor(50);
    POLockEvent.SetEvent;
    POLTInitedLocally := true;
  end;

  if not OutOfFP then begin // we have to show "Pu Aside" radio button and move the OK/Cancel buttons to the right
    rbPutAside.Left := RejectRadioButton.Left;
    rbPutAside.Top  := RejectRadioButton.Top + (RejectRadioButton.Top - ApproveRadioButton.Top);
  	SubmitButton.Left := CancelButton.Left;
    CancelButton.Left := PrintButton.Left;
  end
  else begin
    rbPutAside.Visible := false;
  end;

// setting up loading thread
	ALLoader	:= TAttLoaderThread.Create(true);
  ALLoader.FreeOnTerminate := true;
  ALLoader.Priority				:= tpLower;
  ALLoader.POWndHandle     := Self.Handle;
  ALLoader.Resume;

  CAFPPost  := FPPostsArr[CAPrefixID];
end;

procedure TPOApproveForm.RejectRadioButtonClick(Sender: TObject);
begin
  SourceCombo.Enabled     := false;
  ApprovedSumEdit.Enabled := false;
  CashCB.Enabled          := false;
  SubmitButton.Caption    := RejectRadioButton.Caption;
  SubmitButtonActive;
end;

procedure TPOApproveForm.SaveAsPopUpClick(Sender: TObject);
var
	i	: integer;
  FileName	: string;
  SaveName	: string;
  MemStream	: TMemoryStream;
  ErrorCode	: cardinal;
  CSLeft		: boolean;
begin
  if FilesListView.ItemIndex < 0 then
  	Exit;

  FileName	:= PAttInfo(FilesListView.Items[FilesListView.ItemIndex].Data).FullName;
  SaveDlg.FileName := FileName;

  if SaveDlg.Execute then begin

	  SaveName := SaveDlg.FileName;
		CSLeft	 := false;

	  LoadingAttsCS.Enter;
  	for i := 0 to LoadedAtts.Count - 1 do begin
    	if PImageToPrint(LoadedAtts[i]).ImgName = FileName then begin
      	break;
	    end;
  	end;

    if i < LoadedAtts.Count then begin
		  MemStream	:= TMemoryStream.Create;
      ErrorCode := 0;

      try
	      MemStream.LoadFromStream(PImageToPrint(LoadedAtts[i]).ImStream);
				CSLeft	 := true;
			  LoadingAttsCS.Leave;
      except
			  ErrorCode := GetLastError;
        Application.MessageBox(PWideChar('При сохранении приложения произошла ошибка (' + IntToStr(ErrorCode) + ')'), 'Сохранение приложения', MB_ICONERROR or MB_OK);
      end;

      if ErrorCode = 0 then begin
	      try
  		    MemStream.SaveToFile(SaveName);
      	except
        	on e: EFCreateError do begin
				  	ErrorCode := GetLastError;
//		        Application.MessageBox(PWideChar('При сохранении приложения произошла ошибка: ' + IntToStr(ErrorCode) + ')'), 'Сохранение приложения', MB_ICONERROR or MB_OK);
		        Application.MessageBox(PWideChar('При сохранении приложения произошла ошибка: ' + e.Message), 'Сохранение приложения', MB_ICONERROR or MB_OK);
          end;
  	    end;
      end;

      MemStream.Free;
    end; // if i < LoadedAtts.Count - 1 then begin

    if not CSLeft then begin
			LoadingAttsCS.Leave;
    end;

  end;
end;

procedure TPOApproveForm.ShowFilePopPupClick(Sender: TObject);
var
  TmpAttName		: string;
  i							: integer;
  AI            : PAttInfo;
begin
  if FilesListView.ItemIndex < 0 then Exit;

  AI := PAttInfo(FilesListView.Items[FilesListView.ItemIndex].Data);

  if AI.state = AS_NOTLOADED then begin
  	PostMessage(Self.Handle, UM_ATT_LOAD, AI.POAttID, 0);
  end
  else if AI.state = AS_LOADED then begin
  	PostMessage(Self.Handle, UM_ATT_OPEN, AI.POAttID, 0);
  end
  else if AI.state = AS_LOCAL then begin
  	PostMessage(Self.Handle, UM_ATT_OPEN, AI.POAttID, 0);
  end
  else if AI.state = AS_LOADINGFAILED then begin
	  if (Application.MessageBox('Во время последней загрузки файла произошла ошибка. Попробовать загрузить файл ещё раз?', 'Ошибка при загрузке файла', MB_ICONINFORMATION or MB_YESNO) = mrYes) then begin
	  	PostMessage(Self.Handle, UM_ATT_LOAD, AI.POAttID, 0);
    end;
  end;

end;

procedure TPOApproveForm.SourceComboChange(Sender: TObject);
var
  i : integer;
  fbal  : extended;
  pobal : extended;
begin
	if FormIsRO then
  	Exit;

  if SourceCombo.ItemIndex >= 0 then begin
    fbal := PVTResourceData(FundList[SourceCombo.ItemIndex]).balance;
    pobal := PVTResourceData(FundList[SourceCombo.ItemIndex]).fp1sum;
  end;

  if SourceCombo.ItemIndex >= 0 then begin
    if Round(ApprovedSumEdit.Value * 100) > Round((fbal + pobal) * 100) then begin
      Application.MessageBox('В выбранном фонде не хватает средств', 'Невозможно одобрить заявку.', MB_ICONERROR or MB_OK);
    end;
    CurFundLink := PVTResourceData(FundList[SourceCombo.ItemIndex]).link
  end
  else begin
    CurFundLink := '';
  end;

  SubmitButtonActive;
end;

function TPOApproveForm.SubmitButtonActive;
begin
  SubmitButton.Enabled := RejectRadioButton.Checked or rbPutAside.Checked or (ApproveRadioButton.Checked and ((ApprovedSumEdit <> nil) and (SourceCombo <> nil) and (SourceCombo.ItemIndex >=0) and
    (Round(ApprovedSumEdit.Value * 100) <= Round((PVTResourceData(FundList[SourceCombo.ItemIndex]).balance + PVTResourceData(FundList[SourceCombo.ItemIndex]).fp1sum) * 100))));
end;

procedure TPOApproveForm.SubmitButtonClick(Sender: TObject);
var
  Text    : string;
  Caption : string;
begin
  if not CheckAndReconnect(FPConnection) then begin
  	ShowMessage('Невозможно соединиться с сервером. Повторите попытку позже.');
  	Exit;
  end;

  //
  if not OutOfFP then begin
    ModalResult := mrOK;
    Exit;
  end;

  if RejectRadioButton.Checked then begin
    Text 		:= 'Вы дейстительно хотите отклонить заявку до проведения общего финансового планирования?';
    Caption := 'Отклонение заявки';
  end
  else begin
    Text 		:= 'Вы подтверждаете, что ситуация настолько серьёзная, что требует срочной оплаты' + CRLF + 'и её рассмотрение не может быть отложено до проведения общего финансового планирования?';
    Caption := 'Одобрение заявки';
  end;
  if IDYES = Application.MessageBox(PWideChar(Text), PWideChar(Caption), MB_YESNO or MB_ICONWARNING) then
    ModalResult := mrOK;
end;

end.
