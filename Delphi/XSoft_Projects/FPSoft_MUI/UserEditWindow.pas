unit UserEditWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  LoginNameCheckThread, GlobalVars,
  Dialogs, StdCtrls, sButton, sComboBox, sEdit, sLabel, ExtCtrls, sPanel, acPNG, DKLang;

type
  TUserEditForm = class(TForm)
    FamilyNameLabel: TsLabel;
    FamilyNameEdit: TsEdit;
    FirstNameEdit: TsEdit;
    FirstNameLabel: TsLabel;
    MiddleNameEdit: TsEdit;
    MiddleNameLabel: TsLabel;
    PostLabel: TsLabel;
    PostCombo: TsComboBox;
    PwdLabel: TsLabel;
    PwdEdit: TsEdit;
    PwdConfLabel: TsLabel;
    PwdConfEdit: TsEdit;
    SaveButton: TsButton;
    CancelButton: TsButton;
    LoginEdit: TsEdit;
    LoginLabel: TsLabel;
    sPanel1: TsPanel;
    LoginOKImg: TImage;
    LoginNotOKImg: TImage;
    lc: TDKLanguageController;
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure DataChanged(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure LoginEditExit(Sender: TObject);
  private
    { Private declarations }
    LoginNameCheckIsIP : boolean;
    LoginAlreadyExists : boolean;
    LoginChkThread     : TLoginNameCheckThread;
    procedure OnLogInNameOK(var Msg: TMessage); message UM_LOGINNAMEOK;
    procedure OnLogInNameNotOK(var Msg: TMessage); message UM_LOGINNAMENOTOK;
    procedure OnLogInNameCheckFailed(var Msg: TMessage); message UM_LOGINNAMECHECKFAILED;
  public
    { Public declarations }
    WasChanged	: boolean;
    UpdateUser	: boolean;
    UpdOK				: boolean;
    UserID      : integer;
    NewUserID   : integer;
    UEPrefix    : string;
    UEOID       : integer;
    OldPost     : string;
    bStats      : boolean;
    procedure SetOKButton;
  end;

//var
//  UserEditForm: TUserEditForm;

implementation

{$R *.dfm}

uses
  StrUtils,
	ZDbcIntfs;

//	GlobalVars;

procedure TUserEditForm.OnLogInNameOK(var Msg: TMessage);
begin
  LoginAlreadyExists := false;
  LoginNameCheckIsIP := false;
  LoginEdit.Enabled  := true;
  LoginOkImg.Visible := true;

  SetOKButton
end;

procedure TUserEditForm.OnLogInNameNotOK(var Msg: TMessage);
begin
  LoginAlreadyExists := true;
  LoginNameCheckIsIP := false;
  LoginEdit.Enabled  := true;
  if loginEdit.Text = '' then
	  LoginNotOKImg.Visible := false
  else
	  LoginNotOKImg.Visible := true;
  SetOKButton
end;

procedure TUserEditForm.OnLogInNameCheckFailed(var Msg: TMessage);
begin
  LoginAlreadyExists := false;
  LoginNameCheckIsIP := false;
  LoginEdit.Enabled  := true;
  SetOKButton
end;

procedure TUserEditForm.SetOKButton;
begin

	SaveButton.Enabled := (LoginEdit <> nil) and (FamilyNameEdit <> nil) and (PostCombo <> nil) and
  	(PwdEdit <> nil) and (PwdConfEdit <> nil) and (not LoginAlreadyExists) and
  	(LoginEdit.Text <> '') and (FamilyNameEdit.Text <> '') and (PostCombo.Text <> '') and
 	(
    (
    	UpdateUser and
      (((PwdEdit.Text <> '') and (PwdEdit.Text=PwdConfEdit.Text) ) or ( (PwdEdit.Text = '') and (PwdConfEdit.Text='')))
     )
     or
    (
    	(not UpdateUser) and
      (((PwdEdit.Text <> '') and (PwdEdit.Text=PwdConfEdit.Text) ) )
     )
	)

end;

procedure TUserEditForm.DataChanged(Sender: TObject);
begin
	SetOKButton
end;

procedure TUserEditForm.FormCreate(Sender: TObject);
begin
  LoginNotOKImg.Left := LoginOKImg.Left;
  LoginNotOKImg.Top  := LoginOKImg.Top;
  LoginNameCheckIsIP := false;
  LoginAlreadyExists := false;
  LoginChkThread     := nil;

	WasChanged := true;
end;

procedure TUserEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : begin ModalResult := mrCancel; Key := 0; end;
  end;
end;

procedure TUserEditForm.FormShow(Sender: TObject);
begin
  SetOKButton;
end;

procedure TUserEditForm.LoginEditExit(Sender: TObject);
begin
  LoginEdit.Text := Trim(LoginEdit.Text);
  if LoginEdit.Text = '' then begin
    SendMessage(Handle, UM_LOGINNAMENOTOK, 0, 0);
    Exit;
  end;

  LoginChkThread := TLoginNameCheckThread.Create(true);
  if not Assigned(LoginChkThread) then
    Exit;

  SaveButton.Enabled    := false;
  LoginEdit.Enabled     := false;
  LoginOkImg.Visible    := false;
  LoginNotOKImg.Visible := false;
  LoginOKImg.Visible    := false;

  LoginNameCheckIsIP := true;
  LoginChkThread.GLNCConnection  := FPConnection;
  LoginChkThread.GLNCLogin       := Trim(LoginEdit.Text);
  LoginChkThread.GLNCPHandle     := Self.Handle;
  LoginChkThread.Priority				 := tpLower;
  LoginChkThread.FreeOnTerminate := true;
  LoginChkThread.Resume;

end;

procedure TUserEditForm.SaveButtonClick(Sender: TObject);
var
  PstsID    : integer;
	PostID    : integer;
  NoError   : boolean;
  OldPostID : integer;
  OldPstsID : integer;
begin
  NoError := true;
	if UpdateUser then begin
  	UpdOk	:= false;
	  if PostCombo.Items.IndexOf(PostCombo.Text) < 0 then begin // we need to create new post
    	if mrYES <>
			    	Application.MessageBox(PWideChar(rsUserPostNotFound + CRLF + rsUserPostToAdd + CRLF + rsToContinue), PWideChar(rsPostNotFound), MB_YESNO or MB_ICONWARNING)
        then begin
        ModalResult := mrNone;
      	Exit;
      end;

      FPMainDataset.SQL.Text := 'START TRANSACTION';
      try
        FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
	  		  ShowError(Self, rsFailedToStartTransation, e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
      // Adding new post to DB
			// First pull an old post from the DB
      if OldPost <> '' then begin
        if NoError then begin
          FPMainDataset.SQL.Text := 'SELECT ' + UEPrefix + 'psts.ID FROM ' + UEPrefix + 'psts JOIN ' + UEPrefix + 'pstsfills ON ' + UEPrefix + 'psts.id=' + UEPrefix + 'pstsfills.pstsid JOIN ' + UEPrefix + 'postsdir ON ' + UEPrefix + 'psts.Postid=' + UEPrefix + 'postsdir.id WHERE userid=:fUserID AND Abbr=:fAbbr';// LOCK IN SHARE MODE';
          FPMainDataset.ParamByName('fuserid').AsInteger := USerID;
          FPMainDataset.ParamByName('fAbbr').AsString    := OldPost;
          try
            FPMainDataset.Open;
            OldPstsID	:= FPMainDataset.FieldByName('ID').AsInteger;
          except
 	  	  	  on e: EZSQLException do begin
      	      ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
              NoError := false;
            end;
          end;
        end;
        if NoError then begin
          FPMainDataset.SQL.Text := 'UPDATE ' + UEPrefix + 'pstsfills SET enddate=NOW() WHERE pstsid=:fpstsid AND userid=:fuserid';
          FPMainDataset.ParamByName('fpstsid').AsInteger := OldPstsID;
          FPMainDataset.ParamByName('fuserid').AsInteger := USerID;
          try
            FPMainDataset.ExecSQL;
          except
 	  	  	  on e: EZSQLException do begin
      	      ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
              NoError := false;
            end;
          end;
        end;
      end;

      // adding new post to DB
      if NoError then begin
        FPMainDataset.SQL.Text := 'INSERT INTO ' + UEPrefix + 'postsdir(Abbr)VALUES(:fAbbr)';
        FPMainDataset.ParamByName('fAbbr').AsString := MyFirstLetterUp(PostCombo.Text);
        try
          FPMainDataset.ExecSQL;
        except
 		  	  on e: EZSQLException do begin
    	      ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end;
      if NoError then begin
        FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID()as ID';
        try
          FPMainDataset.Open;
          PostID	:= FPMainDataset.FieldByName('ID').AsInteger;
        except
 		  	  on e: EZSQLException do begin
    	      ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
          end;
        end;
      end;
      //
    end // if PostCombo.Items.IndexOf(...) < 0
    else begin // i.e. we don't need to create post
      if NoError then begin
        //    pulling old post from the DB
        // if the person was "on post" before this editing, we have to remove him from the old post and post him on the new one.
        if OldPost <> '' then begin // if the person was on post before, first we have to remove him from old post
        	if OldPost <> PostCombo.Text then begin // we can do it only if old post and new post are different
	          if NoError then begin
  	          FPMainDataset.SQL.Text := 'SELECT ' + UEPrefix + 'psts.ID FROM ' + UEPrefix + 'psts JOIN ' + UEPrefix + 'pstsfills ON ' + UEPrefix + 'psts.id=' + UEPrefix + 'pstsfills.pstsid JOIN ' + UEPrefix + 'postsdir ON ' + UEPrefix + 'psts.Postid=' + UEPrefix + 'postsdir.id WHERE userid=:fUserID AND Abbr=:fAbbr';// LOCK IN SHARE MODE';
    	        FPMainDataset.ParamByName('fuserid').AsInteger := USerID;
      	      FPMainDataset.ParamByName('fAbbr').AsString    := OldPost;
        	    try
          	    FPMainDataset.Open;
            	  OldPstsID	:= FPMainDataset.FieldByName('ID').AsInteger;
	            except
 		    	  	  on e: EZSQLException do begin
    	    	      ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
      	          NoError := false;
        	      end;
	            end;
  	        end;
    	      if NoError then begin
      	      FPMainDataset.SQL.Text := 'UPDATE ' + UEPrefix + 'pstsfills SET enddate=NOW() WHERE pstsid=:fpstsid AND userid=:fuserid';
        	    FPMainDataset.ParamByName('fpstsid').AsInteger := OldPstsID;
          	  FPMainDataset.ParamByName('fuserid').AsInteger := USerID;
	            try
  	            FPMainDataset.ExecSQL;
    	        except
 	  		    	  on e: EZSQLException do begin
      		        ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
          	      NoError := false;
            	  end;
	            end;
  	        end;
          end;
        end;
      end; // if NoError then begin
    end;

    // post person on a new post (if it differs from the old one)
		if (OldPost <> PostCombo.Text) and NoError then begin // we can do it only if old post and new post are different
			// pulling new post from DB
      FPMainDataset.SQL.Text := 'SELECT ID FROM ' + UEPrefix + 'postsdir WHERE Abbr=:fAbbr';
      FPMainDataset.ParamByName('fAbbr').AsString := PostCombo.Text;
      try
      	FPMainDataset.Open;
        PostID	:= FPMainDataset.FieldByName('ID').AsInteger;
      except
 		  	on e: EZSQLException do begin
	  			ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;

	    // add new post to psts table as we need it to posting a user
  	  if NoError then begin
    	  FPMainDataset.SQL.Text := 'INSERT INTO ' + UEPrefix + 'psts(PostID)VALUES(:fPostID)';
      	FPMainDataset.ParamByName('fPostID').AsInteger := PostID;
	      try
  	      FPMainDataset.ExecSQL;
    	  except
 		  	  on e: EZSQLException do begin
    	  	  ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
          	NoError := false;
	        end;
  	    end;
    	end;
	    if NoError then begin
  	    FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
    	  FPMainDataset.Open;
      	PstsID	:= FPMainDataset.FieldByName('ID').AsInteger;
	    end;

  	  // add info to the postsfill table to track assignments
    	if NoError then begin
      	FPMainDataset.SQL.Text := 'INSERT INTO ' + UEPrefix + 'pstsfills(pstsid,userid,startdate)VALUES(:fpstsid,:fUserID,NOW())';
	      FPMainDataset.ParamByName('fpstsid').AsInteger    := PstsID;
  	    FPMainDataset.ParamByName('fUserID').AsInteger    := UserID;
    	  try
      	  FPMainDataset.ExecSQL;
	      except
  	    	on e: EZSQLException do begin
    				ShowError(Self, rsFailedToInitUserInfo, e.ErrorCode, e.StatusCode, e.Message);
      	  	NoError := false;
	    	  end;
  	    end;
    	end;
    end
    else begin
      PostID := OldPostID;
    end;

    // put data to the DB
    if NoError then begin
      FPMainDataset.SQL.Text := 'UPDATE users SET FirstName=:fFirstName,MiddleName=:fMiddleName,FamilyName=:fFamilyName,PostLink=:fPostLink';
      if PwdEdit.Text <> '' then begin
	      FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + ',Password=PASSWORD(:fPwd)';
      end;
	    FPMainDataset.SQL.Text := FPMainDataset.SQL.Text + 'WHERE Login=:fLogin';
      FPMainDataset.ParamByName('fFirstName').AsString 	:= MyFirstLetterUp(FirstNameEdit.Text);
      FPMainDataset.ParamByName('fMiddleName').AsString := MyFirstLetterUp(MiddleNameEdit.Text);
      FPMainDataset.ParamByName('fFamilyName').AsString := MyFirstLetterUp(FamilyNameEdit.Text);
      FPMainDataset.ParamByName('fPostLink').AsInteger	:= PostID;
      if PwdEdit.Text <> '' then begin
	      FPMainDataset.ParamByName('fPwd').AsString	 		:= PwdEdit.Text;
      end;
      FPMainDataset.ParamByName('fLogin').AsString			:= LoginEdit.Text;
      try
        FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
	  		  ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
    end;
(*
    // add new post to psts table as we need it to posting a user
    if NoError then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + UEPrefix + 'psts(PostID)VALUES(:fPostID)';
      FPMainDataset.ParamByName('fPostID').AsInteger := PostID;
      try
        FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
    	    ShowError(Self, 'Произошла ошибка при инициализации новой должности.', e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
    end;
    if NoError then begin
      FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
      FPMainDataset.Open;
      PstsID	:= FPMainDataset.FieldByName('ID').AsInteger;
    end;

    // add info to the postsfill table to track assignments
    if NoError then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + UEPrefix + 'pstsfills(pstsid,userid,startdate)VALUES(:fpstsid,:fUserID,NOW())';
      FPMainDataset.ParamByName('fpstsid').AsInteger    := PstsID;
      FPMainDataset.ParamByName('fUserID').AsInteger    := UserID;
      try
        FPMainDataset.ExecSQL;
      except
      	on e: EZSQLException do begin
    			ShowError(Self, 'Ошибка при инициализации пользователя.', e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
    	  end;
      end;
    end;
*)

    // commmit or rollback transaction
    if NoError then begin
      FPMainDataset.SQL.Text := 'COMMIT';
      try
        FPMainDataset.ExecSQL;
      except
      	on e: EZSQLException do begin
    			ShowError(Self, rsFailedToCloseTransation, e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
    	  end;
      end;
    end;

    if not NoError then begin
      FPMainDataset.SQL.Text := 'ROLLBACK';
      try
        FPMainDataset.ExecSQL;
      finally
      end;
    end;
//  	UpdOk	:= true;
  	UpdOk	:= NoError;
  end
  else begin // if NOT updateuser - here we are INSERTing new user
  	UpdOk	:= false;
    if NoError then begin
  	  if PostCombo.Items.IndexOf(PostCombo.Text) < 0 then begin // we need to create new post
      	if mrYES <>
		  	    	Application.MessageBox(PWideChar(rsUserPostNotFound + CRLF + rsUserPostToAdd + CRLF + rsToContinue), PWideChar(rsPostNotFound), MB_YESNO or MB_ICONWARNING)
          then begin
          ModalResult := mrNone;
          NoError := true;
        	Exit;
        end;

      	FPMainDataset.SQL.Text := 'START TRANSACTION';
        try
        	FPMainDataset.ExecSQL;
        except
 		    	on e: EZSQLException do begin
	  		    ShowError(Self, rsFailedToStartTransation, e.ErrorCode, e.StatusCode, e.Message);
            NoError := false;
	        end;
        end;
        // Adding new post to DB
        if NoError then begin
//          FPMainDataset.SQL.Text := 'INSERT INTO posts (Abbr) VALUES(:fAbbr)';
          FPMainDataset.SQL.Text := 'INSERT INTO ' + UEPrefix + 'postsdir(Abbr)VALUES(:fAbbr)';
          FPMainDataset.ParamByName('fAbbr').AsString := MyFirstLetterUp(PostCombo.Text);
          try
          	FPMainDataset.ExecSQL;
          except
 		  	    on e: EZSQLException do begin
    	    		ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
              NoError := false;
    	      end;
          end;
        end;
        if NoError then begin
          FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID()as ID';
          FPMainDataset.Open;
          PostID	:= FPMainDataset.FieldByName('ID').AsInteger;
        end;
      end // if UserEditForm.PostCombo.Items.IndexOf(...) < 0, i.e. we have to pull the post ID from the posts table
      else begin
        FPMainDataset.SQL.Text := 'SELECT ID FROM ' + UEPrefix + 'postsdir WHERE Abbr=:fAbbr';
        FPMainDataset.ParamByName('fAbbr').AsString := PostCombo.Text;
        FPMainDataset.Open;
        PostID	:= FPMainDataset.FieldByName('ID').AsInteger;
      end;
    end; // if NoError
    // put user data to the DB
    if NoError then begin
      FPMainDataset.SQL.Text :=
      	'INSERT INTO users(Login,FirstName,MiddleName,FamilyName,PostLink,Password,FPPriviledges,cv)VALUES' +
                         '(:fLogin,:fFirstName,:fMiddleName,:fFamilyName,:fPostLink,PASSWORD(:fPwd),"a","")';
      FPMainDataset.ParamByName('fLogin').AsString			:= LoginEdit.Text;
      FPMainDataset.ParamByName('fFirstName').AsString 	:= MyFirstLetterUp(FirstNameEdit.Text);
      FPMainDataset.ParamByName('fMiddleName').AsString := MyFirstLetterUp(MiddleNameEdit.Text);
      FPMainDataset.ParamByName('fFamilyName').AsString := MyFirstLetterUp(FamilyNameEdit.Text);
      FPMainDataset.ParamByName('fPostLink').AsInteger	:= PostID;
		  FPMainDataset.ParamByName('fPwd').AsString	 			:= PwdEdit.Text;
      try
        FPMainDataset.ExecSQL;
      except
      	on e: EZSQLException do begin
    			ShowError(Self, 'Ошибка при добавлении пользователя.', e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
    	  end;
      end;
    end;
    if NoError then begin
      FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
      try
        FPMainDataset.Open;
        NewUserID   := FPMainDataset.FieldByName('ID').AsInteger;
      except
      	on e: EZSQLException do begin
    			ShowError(Self, rsFaileToUpdateUserInfo, e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
    	  end;
      end;
    end;

    // add new post to psts table as we need it to posting a user
    if NoError then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + UEPrefix + 'psts(PostID)VALUES(:fPostID)';
      FPMainDataset.ParamByName('fPostID').AsInteger := PostID;
      try
        FPMainDataset.ExecSQL;
      except
 		    on e: EZSQLException do begin
    	    ShowError(Self, rsFailedToCreateNewPost, e.ErrorCode, e.StatusCode, e.Message);
          NoError := false;
        end;
      end;
    end;
    if NoError then begin
      FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() as ID';
      FPMainDataset.Open;
      PstsID	:= FPMainDataset.FieldByName('ID').AsInteger;
    end;

    // add info to the postsfill table to track assignments
    if NoError then begin
      FPMainDataset.SQL.Text := 'INSERT INTO ' + UEPrefix + 'pstsfills(pstsid,userid,startdate)VALUES(:fpstsid,:fUserID,NOW())';
      FPMainDataset.ParamByName('fpstsid').AsInteger    := PstsID;
      FPMainDataset.ParamByName('fUserID').AsInteger    := NewUserID;
      try
        FPMainDataset.ExecSQL;
      except
      	on e: EZSQLException do begin
    			ShowError(Self, rsFailedToInitUserInfo, e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
    	  end;
      end;
    end;

    if NoError then begin
//      if not TryStrToInt(UEPrefix, UEOID) then
    	if UEOID < 1 then
				UEOID := 1;

//      if bStats then begin
//
//      end;

      try
	      FPMainDataset.SQL.Text := 'INSERT INTO uos(UserID,OrgID,sp)VALUES(:fUID,:fOID,"")';
  	    FPMainDataset.ParamByName('fUID').AsInteger := NewUserID;
    	  FPMainDataset.ParamByName('fOID').AsInteger := UEOID;
        FPMainDataset.ExecSQL;

	      FPMainDataset.SQL.Text := 'INSERT INTO uofp(UserID,OrgID,FPPrivs)VALUES(:fUID,:fOID,"a")';
  	    FPMainDataset.ParamByName('fUID').AsInteger := NewUserID;
    	  FPMainDataset.ParamByName('fOID').AsInteger := UEOID;
        FPMainDataset.ExecSQL;
      except
      	on e: EZSQLException do begin
    			ShowError(Self, rsFailedToCreateUser, e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
    	  end;
      end;
    end;

    if NoError then begin
      FPMainDataset.SQL.Text := 'COMMIT';
      try
        FPMainDataset.ExecSQL;
      except
      	on e: EZSQLException do begin
    			ShowError(Self, rsFailedToCloseTransation, e.ErrorCode, e.StatusCode, e.Message);
        	NoError := false;
    	  end;
      end;
    end;

    if not NoError then begin
      FPMainDataset.SQL.Text := 'ROLLBACK';
      try
        FPMainDataset.ExecSQL;
      finally
      end;
    end;
    UpdOk	:= NoError;
  end; //
end;

end.
