unit POWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sMemo, sEdit, sButton, sCheckBox, sLabel,
  //AdvEdit,
  AdvMoneyEdit, sComboBox, ExtCtrls, sPanel,
	GlobalVars,
	AttLoaderThread, // for background attachments loading
  POLockerThread,
  LoadingProgressWindow, // for LoadingProgressForm
  ShellAPI, // for drag features
  ImgList, acAlphaImageList, ComCtrls, sListView, Buttons, sSpeedButton, ExtDlgs, sDialogs, Menus, jpeg,
  System.ImageList, AdvEdit;

type
  TPOForm = class(TForm)
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    AttestCheckBox: TsCheckBox;
    SubmitButton: TsButton;
    ResetButton: TsButton;
    CancelButton: TsButton;
    SubjectEdit: TsEdit;
    TextMemo: TsMemo;
    AttestLabel: TsLabel;
    SumEdit: TAdvMoneyEdit;
    sPanel1: TsPanel;
    PrintButton: TsButton;
    pd: TPrintDialog;
    btnAddFiles: TsSpeedButton;
    FilesListView: TsListView;
    lblAtts: TsLabel;
    sAlphaImageList1: TsAlphaImageList;
    FilesListPopupMenu: TPopupMenu;
    ShowFilePopPup: TMenuItem;
    DeleteFilePopUp: TMenuItem;
    PopUpImages: TsAlphaImageList;
    DeleteAllPopUp: TMenuItem;
    UrgencyCheckBox: TsCheckBox;
    TmpImage: TImage;
    SaveAsPopUp: TMenuItem;
    SaveDlg: TSaveDialog;
    OrgCombo: TsComboBox;
    OrgLabel: TsLabel;
    Timer: TTimer;
    CashCB: TsCheckBox;
    od: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure AttestCheckBoxClick(Sender: TObject);
    procedure SubjectEditChange(Sender: TObject);
    procedure TextMemoChange(Sender: TObject);
    procedure SumEditChange(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure btnAddFilesClick(Sender: TObject);
    procedure DeleteAllPopUpClick(Sender: TObject);
    procedure FilesListPopupMenuPopup(Sender: TObject);
    procedure DeleteFilePopUpClick(Sender: TObject);
    procedure pupOpenFileClick(Sender: TObject);
    procedure FilesListViewDblClick(Sender: TObject);
    procedure FilesListViewEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure FilesListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UrgencyCheckBoxClick(Sender: TObject);
    procedure PrintAttachmentClick(Sender: TObject);
    procedure PrintAllAttachmentsClick(Sender: TObject);
    procedure SaveAsPopUpClick(Sender: TObject);
    procedure OrgComboChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    ATTLoader	      : TAttLoaderThread;
    FNames			    : TStringList;
	  lpf             : TLoadingProgressForm; // for LoadingProgressForm

//    UrgentAddNeeded : string;

    POFPPost        : string;
    iOPPrefix       : integer;

    POLTInitedLocally : boolean;

    function SubmitButtonEnabled : boolean;
    procedure AttLoad(var Msg: TMessage); message UM_ATT_LOAD;
    procedure AttLoadStarted(var Msg: TMessage); message UM_ATT_LOAD_STARTED;
    procedure AttLoadIP(var Msg: TMessage); message UM_ATT_LOAD_IP;
    procedure AttLoaded(var Msg: TMessage); message UM_ATT_LOADED;
    procedure AttOpen(var Msg: TMessage); message UM_ATT_OPEN;
    procedure FailedToLoad(var Msg: TMessage); message UM_ATT_LOADINGFAILED;

		procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
    procedure RecolorFields;

  public
    { Public declarations }
    PONum				 : integer;
    OrigPost		 : string;
    OrigName		 : string;
    OrigDate		 : TDate;
    BeingEdited	 : boolean; // flag whether we edit PO or view it
    IsNew				 : boolean; // whether it's a new PO
    AttsToDelete : TStringList;
    LoadedAtts   : TList;         // list of PImageToPrint type items  - is to be in the private section of the class
    OPPrefix     : string;
    OPPrefixID   : integer;
    OrgsList     : TList;
  end;

implementation

{$R *.dfm}
Uses
	sRichEdit,
//	ImageViewerWindow,
  StrUtils, // for LeftStr
  DB,
  ZDbcIntfs,
  Printers;

procedure TPOForm.WMDropFiles(var Message: TWMDropFiles);
var
	aFile			 : array[0..2048] of Char;
	FilesCount : Integer;
	i          : integer;
  j : integer;
  FileInfo   : PAttInfo;
  FileName   : string;
  NameFound : boolean;
begin
	inherited;
	FilesCount := DragQueryFile(Message.drop, $FFFFFFFF, nil, 0);
	for i := 0 to FilesCount - 1 do begin
  	DragQueryFile(Message.drop, i, aFile, 2048);
    NameFound := false;
    FileName := ExtractFilename(aFile);
    for j := 0 to FilesListView.Items.Count - 1 do begin
      if PAttInfo(FilesListView.Items[i].Data).FileName = FileName then begin
      NameFound := true;
      break;
      end
    end;

    if NameFound then begin
      Application.MessageBox(PWideChar('Файл "' + FileName + '" уже приложен к заявке. Удалите приложенный файл и попробуйте снова.'), 'Файл уже приложен.', MB_ICONERROR or MB_OK);
    end
    else begin
		  New(FileInfo);
  		FileInfo.FileName := FileName;
	  	FileInfo.FullName := aFile;
	    FileInfo.Data     := TMemoryStream.Create;
  	  FileInfo.Data.LoadFromFile(FileInfo.FullName);
			FilesListView.AddItem(FileInfo.FileName, pointer(FileInfo));
    end;
 end;
	DragFinish(Message.Drop);
end;

procedure TPOForm.RecolorFields;
begin
	if UrgencyCheckbox.Checked then begin
		SubjectEdit.Color 	:= clMyLightPink;
		TextMemo.Color			:= clMyLightPink;
		SumEdit.Color				:= clMyLightPink;
//		UrgencyCheckBox.Font.Style := UrgencyCheckBox.Font.Style - [fsBold];
    FilesListView.Color := clMyLightPink;
    OrgCombo.Color      := clMyLightPink;
	end
	else begin
		SubjectEdit.Color 	:= clWhite;
		TextMemo.Color			:= clWhite;
		SumEdit.Color				:= clWhite;
//		UrgencyCheckBox.Font.Style := UrgencyCheckBox.Font.Style + [fsBold];
    FilesListView.Color := clWhite;
    OrgCombo.Color      := clWhite;
	end;

  InvalidateRect(Self.Handle, nil, true);
  InvalidateRect(TextMemo.Handle, nil, true);

  Repaint;
end;

procedure TPOForm.AttLoaded(var Msg: TMessage);
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

procedure TPOForm.AttOpen(var Msg: TMessage);
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

procedure TPOForm.OrgComboChange(Sender: TObject);
begin
  if OrgCombo.Visible then begin
    OPPrefix  := PVTResourceData(OrgsList[OrgCombo.ItemIndex]).prefix;
    iOPPrefix := PVTResourceData(OrgsList[OrgCombo.ItemIndex]).ipref;
    OPPrefixID := iOPPrefix;
    POFPPost := FPPostsArr[iOPPrefix];
  end;
end;

procedure TPOForm.FailedToLoad(var Msg: TMessage);
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

procedure TPOForm.SaveAsPopUpClick(Sender: TObject);
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
		        Application.MessageBox(PWideChar('При сохранении приложения произошла ошибка: ' + e.Message ), 'Сохранение приложения', MB_ICONERROR or MB_OK);
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

procedure TPOForm.pupOpenFileClick(Sender: TObject);
var
  TmpAttName		: string;
  i							: integer;
  AI            : PAttInfo;
begin
  if FilesListView.ItemIndex < 0 then
  	Exit;

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

procedure TPOForm.AttLoad(var Msg: TMessage);
var
	AttID      : integer;
  AttName    : string;
  i					 : integer;
  AttToLoad  : PAttInfo;
  bFound     : boolean;
begin
	AttID := Msg.WParam;
  if (AttID <= 0) then exit;

  bFound     := false;
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

procedure TPOForm.AttLoadStarted(var Msg: TMessage);
begin
	lpf.PB.MaxValue := Msg.WParam;
  lpf.PB.MinValue := 0;
  lpf.PB.Progress := 0;
  lpf.Width    := 250;
  lpf.Height   := 90;
  lpf.Show;
end;

procedure TPOForm.AttLoadIP(var Msg: TMessage);
begin
  lpf.PB.Progress := Msg.WParam;
end;

procedure TPOForm.SubjectEditChange(Sender: TObject);
begin
  SubmitButton.Enabled := SubmitButtonEnabled;
end;

function TPOForm.SubmitButtonEnabled : boolean;
begin
  result := AttestCheckBox.Checked and (SumEdit.Value <> 0) and (SubjectEdit.Text <> '') and (TextMEmo.Text <> '');
end;

procedure TPOForm.SumEditChange(Sender: TObject);
begin
  SubmitButton.Enabled := SubmitButtonEnabled;
end;

procedure TPOForm.AttestCheckBoxClick(Sender: TObject);
begin
  SubmitButton.Enabled := SubmitButtonEnabled;
end;

procedure TPOForm.DeleteAllPopUpClick(Sender: TObject);
var
	i		: integer;
  itm	: PImageToPrint;
begin
  if BeingEdited then begin
		for i := 0 to FilesListView.Items.Count - 1 do begin
//    	if PAttInfo(FilesListView.Items[i].Data).DBID <> 0 then
//				DeletedItems.Add(IntToStr(PAttInfo(FilesListView.Items[i].Data).DBID));
    	if PAttInfo(FilesListView.Items[i].Data).POAttID <> 0 then begin
				AttsToDelete.Add(IntToStr(PAttInfo(FilesListView.Items[i].Data).POAttID));
      end;

    end;

(*
    // cleaning the cache of loaded images
    LoadingAttsCS.Enter;
		while LoadedAtts.Count > 0 do begin
    	itm := LoadedAtts[0];
    	if itm.ItemIsOK then
				itm.ImStream.Free;
      LoadedAtts.Delete(0);
    end;
    LoadingAttsCS.Leave;
*)

  end;
	FilesListView.Items.Clear;
end;

procedure TPOForm.DeleteFilePopUpClick(Sender: TObject);
var
	i	: integer;
begin
	if (FilesListView.ItemIndex > -1) then begin
		if BeingEdited and (PAttInfo(FilesListView.Items[FilesListView.ItemIndex].Data).POAttID <> 0) then // i.e. it's from DB
			AttsToDelete.Add(IntToStr(PAttInfo(FilesListView.Items[FilesListView.ItemIndex].Data).POAttID));
		FilesListView.Items.Delete(FilesListView.ItemIndex);
  end;
end;

procedure TPOForm.FilesListPopupMenuPopup(Sender: TObject);
begin
  FilesListPopUpMenu.Items[0].Enabled := FilesListView.ItemIndex > -1;
  FilesListPopUpMenu.Items[1].Enabled := FilesListView.ItemIndex > -1;
	FilesListPopUpMenu.Items[1].Visible	:= BeingEdited or IsNew;
	FilesListPopUpMenu.Items[2].Visible	:= BeingEdited or IsNew;
end;

procedure TPOForm.FilesListViewDblClick(Sender: TObject);
begin
	pupOpenFileClick(Sender);
end;

procedure TPOForm.FilesListViewEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
begin
	AllowEdit := false;
end;

procedure TPOForm.FilesListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (BeingEdited or IsNew) and (FilesListView.ItemIndex > -1) then begin
  	if Application.MessageBox(PWideChar('Вы действительно хотите удалить файл ' +
    		ExtractFileName(PAttInfo(FilesListView.Items[FilesListView.ItemIndex].Data).FullName) + ' из списка приложений?'), 'Удаление файла', MB_YESNO or MB_ICONQUESTION) = IDYES
    then begin
	    if BeingEdited and (PAttInfo(FilesListView.Items[FilesListView.ItemIndex].Data).POAttID <> 0) then // i.e. it's from DB
				AttsToDelete.Add(IntToStr(PAttInfo(FilesListView.Items[FilesListView.ItemIndex].Data).POAttID));
    	FilesListView.Items.Delete(FilesListView.ItemIndex);
    end;
  end;
end;

procedure TPOForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	// we do not need to load anything after the window is closed
  ATTLoader.Terminate;
  WaitForSingleObject(ATTLoader.Handle, INFINITE);
  ATTLoader := nil;
end;

procedure TPOForm.FormCreate(Sender: TObject);
begin
	// make it drag files-aware
	DragAcceptFiles(Handle, True);

  OrgsList := TList.Create;
	OrigDate := 0;
  OrigName	:= '';
  OrigPost	:= '';
  AttestLabel.Width := 599;
  ResetButtonClick(Sender);
  SubmitButton.Enabled := SubmitButtonEnabled;

  LoadedAtts := TList.Create;
  FNames     := TStringList.Create;

  POLTInitedLocally := false;
  CashCB.Visible := true;
  CashCB.Enabled := true;
end;

procedure TPOForm.FormDestroy(Sender: TObject);
var
  lSearchRec:TSearchRec;
  lPath:string;
begin

  if BeingEdited then
    AttsToDelete.Free;

  if POLTInitedLocally and Assigned(POLT) then begin
    POLT.Terminate;
    POLockEvent.SetEvent;
    WaitForSingleObject(POLT.Handle, INFINITE);
    POLT := nil;
  end;

  // delete all temporary loaded files|attachements
  lPath := IncludeTrailingPathDelimiter(USERTMPFOLDER);
  if FindFirst(lPath + '*.*', faAnyFile, lSearchRec) = 0 then begin
    try
      repeat
        DeleteFile(lPath + lSearchRec.Name);
      until SysUtils.FindNext(lSearchRec) <> 0;
    finally
      FindClose(lSearchRec);  // Free resources on successful find
    end;
  end;
  // delete all temporary files - end of
end;

procedure TPOForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and
  	(	(not BeingEdited)
      or
    	(Application.MessageBox(PWideChar('Вы действительно хотите выйти?' + CRLF + 'Изменения не будут сохранены.'), 'Запрос на закрытие окна', MB_YESNO or MB_ICONQUESTION) = IDYES)
		) then begin
  	ModalResult := mrCancel;
  end;
end;

procedure TPOForm.FormShow(Sender: TObject);
var
	i		: integer;
begin
  if BeingEdited then
    AttsToDelete := TStringList.Create
  else
  	AttsToDelete := nil;

  OrgComboChange(Sender);

  RecolorFields;
// loading attachments from server
	ATTLoader	:= TAttLoaderThread.Create(true);
  ATTLoader.FreeOnTerminate := true;
  ATTLoader.Priority				:= tpLower;
  ATTLoader.POWndHandle     := Self.Handle;
  ATTLoader.Resume;

  Timer.Enabled := true;
  if BeingEdited and (PONum > 0) and (POLT = nil) then begin
    POLT := TPOLockerThread.Create(TRUE);
    POLT.POTGC      := FPConnection;
    POLT.POTUID     := FPUserID;
    POLT.POFilter   := '`index`=' + IntToSTr(PONum);
    POLT.POTOPrefix := OPPRefix;

    POLT.Priority        := tpLower;
    POLT.FreeOnTerminate := true;
    POLT.Resume;

    POLockEvent.WaitFor(50);
    POLockEvent.SetEvent;
    POLTInitedLocally := true;
  end;
end;

procedure TPOForm.PrintAllAttachmentsClick(Sender: TObject);
var
  AttName  : string;
  i				 : integer;
  Item		 : PImageToPrint;
begin

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

procedure TPOForm.PrintAttachmentClick(Sender: TObject);
var
  AttName  : string;
  i				 : integer;
  Item		 : PImageToPrint;

begin
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

procedure TPOForm.PrintButtonClick(Sender: TObject);
var
	RE				: TsRichEdit;
  HeadLine	: string;
begin

	if not PD.Execute then
  	Exit;

	RE					:= TsRichEdit.Create(nil);
  RE.Parent 	:= Self;
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
  	Re.Lines.Add(POFPPost)
  else
	  Re.Lines.Add(OrigPost);

  RE.Lines.Add('');
  RE.Lines.Add('');
  RE.Lines.Add('');

  Re.Paragraph.Alignment	:= taCenter;
  Re.Lines.Add('_______________ Одобрено'+Chr(9)+Chr(9)+Chr(9)+Chr(9)+Chr(9)+'_______________ Неодобрено');

  RE.Print(HeadLine);

  Re.Free;

end;

procedure TPOForm.ResetButtonClick(Sender: TObject);
var
	i		: integer;
begin
  SumEdit.Value := 0;
  SubjectEdit.Text := '';
  TextMemo.Text := 'Ситуация:' + CRLF + CRLF + 'Данные:' + CRLF + CRLF + 'Решение:';
  if BeingEdited then begin
		for i := 0 to FilesListView.Items.Count - 1 do begin
  		if BeingEdited and (PAttInfo(FilesListView.Items[i].Data).POAttID <> 0) then // i.e. it's from DB
				AttsToDelete.Add(IntToStr(PAttInfo(FilesListView.Items[i].Data).POAttID));
    end;
  end;
  FilesListView.Items.Clear;
end;

procedure TPOForm.btnAddFilesClick(Sender: TObject);
var
	i								: integer;
  j : integer;
  FileInfo				: PAttInfo;
  FileName : string;
  NameFound: boolean;
begin
	if od.Execute then begin
  	for i := 0 to od.Files.Count - 1 do begin
	    NameFound := false;
  	  FileName := ExtractFilename(od.Files[i]);
    	for j := 0 to FilesListView.Items.Count - 1 do begin
	      if PAttInfo(FilesListView.Items[j].Data).FileName = FileName then begin
  	    NameFound := true;
    	  break;
      	end
	    end;

  	  if NameFound then begin
    	  Application.MessageBox(PWideChar('Файл "' + FileName + '" уже приложен к заявке. Удалите приложенный файл и попробуйте снова.'), 'Файл уже приложен.', MB_ICONERROR or MB_OK);
	    end
  	  else begin
	  	  New(FileInfo);
  	  	FileInfo.FileName := FileName;
		    FileInfo.FullName := od.Files[i];
  	    FileInfo.Data     := TMemoryStream.Create;
    	  FileInfo.Data.LoadFromFile(FileInfo.FullName);
      	FileInfo.state    := AS_LOCAL;
        FileInfo.POAttID  := 0;
        FileInfo.OrgID    := OPPrefixID;

        if FileInfo.Data.Size > 10 * 1024 * 1024 then begin
        	Application.MessageBox(PWideChar('Файл "' + FileName + '" слишком большой. Максимальный размер приложения 10 Мб.'), 'Файл слишком большой.', MB_ICONERROR or MB_OK);
          Dispose(FileInfo);
          continue;
        end
        else begin
					FilesListView.AddItem(FileInfo.FileName, pointer(FileInfo));
        end;
  	  end;
    end;
  end; // if OPDilg1...
end;

procedure TPOForm.UrgencyCheckBoxClick(Sender: TObject);
begin
  RecolorFields;
end;

procedure TPOForm.TextMemoChange(Sender: TObject);
begin
  SubmitButton.Enabled := SubmitButtonEnabled;
end;

procedure TPOForm.TimerTimer(Sender: TObject);
begin
  RecolorFields;
  Timer.Enabled := false;
end;

end.
