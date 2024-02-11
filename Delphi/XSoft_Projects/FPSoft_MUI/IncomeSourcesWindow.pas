unit IncomeSourcesWindow;

{$I DEFINES.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  IncSrcUpdateThread,
  Dialogs, ImgList, acAlphaImageList, ComCtrls, ToolWin, sToolBar, VirtualTrees, ExtCtrls, sPanel,
  StdCtrls, sComboBox, sLabel, sButton, System.ImageList;

type
  TIncomeSourcesForm = class(TForm)
    IncSrcsTree: TVirtualStringTree;
    ToolBar: TsToolBar;
    AddIncSrcToolButton: TToolButton;
    EditIncSrcToolButton: TToolButton;
    DelIncSourceToolButton: TToolButton;
    ImagesList: TsAlphaImageList;
    OrgButton: TsButton;
    OrgCombo: TsComboBox;
    sAlphaImageList1: TsAlphaImageList;
    procedure IncSrcsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormCreate(Sender: TObject);
    procedure AddIncSrcToolButtonClick(Sender: TObject);
    procedure IncSrcsTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure EditIncSrcToolButtonClick(Sender: TObject);
    procedure IncSrcsTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure IncSrcsTreeDblClick(Sender: TObject);
    procedure DelIncSourceToolButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure OrgComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    CurNode 		: PVirtualNode;
    UpdateIsIP	: boolean;
    UpdThread		: TIncSrcUpdateThread;
    LastSelectedID	: integer;

    procedure AddIncomeSource;
    procedure EditIncomeSource;
    procedure DelIncomeSource;
    procedure EnableButtons;
    procedure OnOKToDeleteIncSrc(var Msg: TMessage); message UM_OKTODELINCSRC;


  public
    { Public declarations }
    ISPrefix : string;
    ISoid    : integer;
    OrgsList  : TList;
  end;

implementation

{$R *.dfm}

uses
	IncomeSourceEditWindow,
	ZDbcIntfs; // for EZSQLException

procedure TIncomeSourcesForm.OnOKToDeleteIncSrc(var Msg: TMessage);
var
  Node     : PVirtualNode;
  NodeData : PIncSrcData;
begin
  Node := IncSrcsTree.GetFirstSelected;
  if Node = nil then
    Exit;

  NodeData := IncSrcsTree.GetNodeData(Node);
  if NodeData.Index = msg.LParam then
    DelIncSourceToolButton.Enabled	:= true;

  UpdateIsIP											:= false;
  UpdThread												:= nil;
end;

procedure TIncomeSourcesForm.OrgComboChange(Sender: TObject);
var
  NewNode     : PVirtualNode;
  NewNodeData : PIncSrcData;
  OrgData     : PVTResourceData;

begin

  if OrgCombo.ItemIndex < 0 then
    Exit;

  OrgData  := PVTResourceData(OrgsList[OrgCombo.ItemIndex]);
  ISPrefix := OrgData.prefix;
  ISoid    := OrgData.index;

  IncSrcsTree.Clear;

  FPMainDataset.SQL.Text := 'SELECT ID,title,price,descr FROM ' + ISPrefix + 'incomesources ORDER BY ID';
  FPMainDataset.Open;
  while not FPMainDataset.Eof do begin
    NewNode             		:= IncSrcsTree.AddChild(nil);
    NewNodeData         		:= IncSrcsTree.GetNodeData(NewNode);
    NewNodeData.Index				:= FPMainDataset.FieldByName('ID').AsInteger;
    NewNodeData.Title				:= FPMainDataset.FieldByName('title').AsString;
    NewNodeData.Price       := FPMainDataset.FieldByName('price').AsFloat;
    NewNodeData.Descr				:= FPMainDataset.FieldByName('descr').AsString;
    FPMainDataset.Next;
  end;
end;

procedure TIncomeSourcesForm.EditIncSrcToolButtonClick(Sender: TObject);
begin
	EditIncomeSource;
end;

procedure TIncomeSourcesForm.EditIncomeSource;
var
	Node 				: PVirtualNode;
  NodeData		: PIncSrcData;
  Title				: string;
  Descr				: string;
  Price       : extended;
  ExitNeeded	: boolean;
  ErrorCode		: integer;
  i           : integer;
begin
  Node := IncSrcsTree.GetFirstSelected;
  if Node = nil then
  	Exit;

  NodeData 							:= IncSrcsTree.GetNodeData(Node);
	IncomeSourceEditForm 	:= TIncomeSourceEditForm.Create(nil);

  IncomeSourceEditForm.Caption 					:= 'Редактирвоание источника дохода';
  IncomeSourceEditForm.OKButton.Caption	:= 'Сохранить';
  IncomeSourceEditForm.IncomeSourceData := NodeData^;

  repeat
    if IncomeSourceEditForm.ShowModal = mrOK then begin
    	Title := IncomeSourceEditForm.IncomeSourceData.Title;
      Price := IncomeSourceEditForm.IncomeSourceData.Price;
      Descr	:= IncomeSourceEditForm.IncomeSourceData.Descr;

      FPMainDataset.SQL.Text := 'UPDATE ' + ISPrefix + 'incomesources SET title=:fTitle,price=:fPrice,descr=:fDescr WHERE ID=:fID';
      FPMainDataset.ParamByName('fTitle').AsString	:= Title;
      FPMainDataset.ParamByName('fPrice').AsFloat  	:= Price;
      FPMainDataset.ParamByName('fDescr').AsString	:= Descr;
      FPMainDataset.ParamByName('fID').AsInteger		:= NodeData.Index;
      ExitNeeded := true;
      Try
      	FPMainDataset.ExecSQL
      Except
      	on e: EZSQLException do begin
        	ErrorCode := e.ErrorCode;
          if ErrorCode = MYSQLDUPLICATEENTRY then begin
          	Application.MessageBox('Такой источник дохода уже существует', 'Ошибка', MB_OK or MB_ICONEXCLAMATION);
            ExitNeeded := false;
					end
          else begin
						GlobalVars.ShowError(nil, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
          end;
        end; // on e:...
      End; // Except

    end // if OK then begin
    else begin
    	Title				:= '';
      Price       := 0;
      Descr				:= '';
			ExitNeeded	:= true;
    end;
  until ExitNeeded;

  if Title <> '' then begin
    NodeData.Title	:= Title;
    NodeData.Price  := Price;
    NodeData.Descr	:= Descr;
    // change data to statdescr table
    FPMainDataset.SQL.Text := 'SELECT StatID FROM`' + ISPrefix + 'incomesources`WHERE ID=:fID';
    FPMainDataset.ParamByName('fID').AsInteger		:= NodeData.Index;
    try
      FPMainDataset.Open;
      if not FPMainDataset.Eof then
        i := FPMainDataset.FieldByName('StatID').AsInteger
      else
        i := 0;

      if i > 0 then begin
        FPMainDataset.SQL.Text := 'UPDATE`statdescr`SET ShortName=:fsn,Description=:fdesc WHERE StatID=:fsid';
        FPMainDataset.ParamByName('fsn').AsString	  := Title;
        FPMainDataset.ParamByName('fdesc').AsString	:= Descr;
        FPMainDataset.ParamByName('fsid').AsInteger	:= i;
        FPMainDataset.ExecSQL
      end;
    except
      on e: EZSQLException do begin
    	  GlobalVars.ShowError(nil, 'Ошибка сохранения данных.', e.ErrorCode, e.StatusCode, e.Message);
      end; // on e:...
    end; // Except
    // change data to statdesct table - end of
  end;
end;

procedure TIncomeSourcesForm.DelIncomeSource;
var
	Node 				: PVirtualNode;
  NodeData		: PIncSrcData;
  Title				: string;
  Descr				: string;
  ExitNeeded	: boolean;
//  ErrorCode		: integer;
  DeletedOK		: boolean;
begin
	if not DelIncSourceToolButton.Enabled then
  	Exit;

  Node := IncSrcsTree.GetFirstSelected;
  if Node = nil then
  	Exit;
  NodeData 							:= IncSrcsTree.GetNodeData(Node);
	IncomeSourceEditForm 	:= TIncomeSourceEditForm.Create(nil);
  Title	:= NodeData.Title;
  Descr	:= NodeData.Descr;

  IncomeSourceEditForm.Caption 					:= 'Удалить источник дохода?';
  IncomeSourceEditForm.OKButton.Caption	:= 'Удалить';

	DeletedOK		:= false;
  repeat

    if IncomeSourceEditForm.ShowModal = mrOK then begin
      FPMainDataset.SQL.Text := 'DELETE FROM ' + ISPrefix + 'incomesources WHERE ID=:fID';

      FPMainDataset.ParamByName('fID').AsInteger		:= NodeData.Index;
      ExitNeeded 	:= true;
		  DeletedOK		:= true;
      Try
      	FPMainDataset.ExecSQL
      Except
      	on e: EZSQLException do begin
//        	ErrorCode := e.ErrorCode;
					GlobalVars.ShowError(nil, 'Ошибка при удалении источника дохода. Обратитесь к разработчикам', e.ErrorCode, e.StatusCode, e.Message);
          ExitNeeded 	:= false;
				  DeletedOK		:= false;
        end; // on e:...
      End; // Except
    end // if OK then begin
    else begin
			ExitNeeded	:= true;
    end;
  until ExitNeeded;

  if DeletedOK then begin
	  IncSrcsTree.DeleteNode(Node);
  end;

end;

procedure TIncomeSourcesForm.EnableButtons;
begin
  EditIncSrcToolButton.Enabled		:= CurNode <> nil;
  DelIncSourceToolButton.Enabled	:= false;
end;

procedure TIncomeSourcesForm.AddIncomeSource;
var
  ExitNeeded	: boolean;
  Title				: string;
  Price       : extended;
  Descr				: string;
  ErrorCode		: integer;
  NewID				: integer;
  NewNode			: PVirtualNode;
  NewData			: PIncSrcData;
  i : integer;
begin
	IncomeSourceEditForm := TIncomeSourceEditForm.Create(nil);
  repeat
    if IncomeSourceEditForm.ShowModal = mrOK then begin
    	Title := IncomeSourceEditForm.IncomeSourceData.Title;
      Price := IncomeSourceEditForm.IncomeSourceData.Price;
      Descr	:= IncomeSourceEditForm.IncomeSourceData.Descr;

      FPMainDataset.SQL.Text := 'INSERT INTO ' + ISPrefix + 'incomesources(`ID`,`pid`,`title`,`price`,`descr`)VALUES(NULL,0,:fTitle,:fPrice,:fDescr)';
      FPMainDataset.ParamByName('fTitle').AsString := Title;
      FPMainDataset.ParamByName('fPrice').AsFloat  := Price;
      FPMainDataset.ParamByName('fDescr').AsString := Descr;
      ExitNeeded := true;
      Try
      	FPMainDataset.ExecSQL
      Except
      	on e: EZSQLException do begin
        	ErrorCode := e.ErrorCode;
          if ErrorCode = MYSQLDUPLICATEENTRY then begin
          	Application.MessageBox('Такой источник дохода уже существует', 'Ошибка', MB_OK or MB_ICONEXCLAMATION);
            ExitNeeded := false;
					end
          else begin
						GlobalVars.ShowError(nil, 'Неизвестная ошибка', e.ErrorCode, e.StatusCode, e.Message);
          end;
        end; // on e:...
      End; // Except
    end // if OK then begin
    else begin
    	Title			 := '';
      Price      := 0;
      Descr			 := '';
			ExitNeeded := true;
    end;
  until ExitNeeded;

  if Title <> '' then begin
		FPMainDataset.SQL.Text := 'SELECT ID FROM`' + ISPrefix + 'incomesources`WHERE title=:fTitle';
    FPMainDataset.ParamByName('fTitle').AsString := Title;
    FPMainDataset.Open;
    NewID := FPMainDataset.FieldByName('ID').AsInteger;

    // connect income source to StatID
    try
      // check whether we have statgroups table
      FPMainDataset.SQL.Text := 'SHOW TABLES LIKE "statgroups"';
      FPMainDataset.Open;
      if not FPMainDataset.Eof then
        i := 1
      else
        i := 0;

      // first pull the FP group ID for the org
      if i > 0 then begin
        FPMainDataset.SQL.Text := 'SELECT ID FROM`statgroups`WHERE OrgID=:foid AND isfp=1';
        FPMainDataset.ParamByName('foid').AsInteger := ISoid;
        FPMainDataset.Open;
        if not FPMainDataset.Eof then
          i := FPMainDataset.FieldByName('ID').AsInteger
        else
          i := 0;
      end;

      if i > 0 then begin
        FPMainDataset.SQL.Text := 'INSERT INTO`statdescr`(StatID,GroupID,OrgID,Description,ShortName)VALUES(NULL,:fgid,:foid,:fdesc,:fsn)';
        FPMainDataset.ParamByName('fgid').AsInteger := i;
        FPMainDataset.ParamByName('foid').AsInteger := ISoid;
        FPMainDataset.ParamByName('fdesc').AsString := Descr;
        FPMainDataset.ParamByName('fsn').AsString   := Title;
        FPMainDataset.ExecSQL;

        FPMainDataset.SQL.Text := 'SELECT LAST_INSERT_ID() AS lid';
        FPMainDataset.Open;
        if not FPMainDataset.Eof then
          i := FPMainDataset.FieldByName('lid').AsInteger
        else
          i := 0;
      end;

      if i > 0 then begin  //  i is StatID now
        FPMainDataset.SQL.Text := 'UPDATE`' + ISPrefix + 'incomesources`SET StatID=:fsid WHERE ID=:fid';
        FPMainDataset.ParamByName('fsid').AsInteger := i;
        FPMainDataset.ParamByName('fid').AsInteger  := NewID;
       	FPMainDataset.ExecSQL
      end;

    except
      on e: EZSQLException do begin
			  GlobalVars.ShowError(nil, 'Невозможно увязать источник дохода со статистиками. Свяжитесь с разработчиками.', e.ErrorCode, e.StatusCode, e.Message);
      end; // on e:...
    end; // Except

    // connect income source to StatID - end of

    NewNode := IncSrcsTree.AddChild(nil);
    NewData	:= IncSrcsTree.GetNodeData(NewNode);
    NewData.Index := NewID;
    NewData.Title	:= Title;
    NewData.Price := Price;
    NewData.Descr	:= Descr;
  end;

	IncomeSourceEditForm.Free;
end;

procedure TIncomeSourcesForm.AddIncSrcToolButtonClick(Sender: TObject);
begin
	AddIncomeSource;
end;

procedure TIncomeSourcesForm.DelIncSourceToolButtonClick(Sender: TObject);
begin
  DelIncomeSource;
end;

procedure TIncomeSourcesForm.FormCreate(Sender: TObject);

begin

	UpdThread	:= nil;
	LastSelectedID	:= 0;

  IncSrcsTree.Align := alClient;
  IncSrcsTree.NodeDataSize  := SizeOf(TIncSrcData);

  OrgsList := TList.Create;
	CurNode  := nil;
end;

procedure TIncomeSourcesForm.FormDestroy(Sender: TObject);
begin
  OrgsList.Destroy;
end;

procedure TIncomeSourcesForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_INSERT then begin
		AddIncomeSource;
  end
  else if Key = VK_DELETE then begin
		DelIncomeSource;
  end
  else if (Key = VK_RETURN) and (ssCtrl in Shift) then begin
		EditIncomeSource;
  end;

end;

procedure TIncomeSourcesForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ORD(Key) = VK_ESCAPE then begin
    ModalResult := MrCancel;
  end
end;

procedure TIncomeSourcesForm.FormShow(Sender: TObject);
begin
  OrgComboChange(Sender)
end;

procedure TIncomeSourcesForm.IncSrcsTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeData		: PIncSrcData;

begin
  CurNode := Node;

  EnableButtons;
  if Node = nil then begin
		UpdateIsIP := false;
    if UpdThread <> nil then begin
    	UpdThread := nil;
    end;
		LastSelectedID := 0;
	  Exit;
  end;


  if UpdateIsIP then begin
   	UpdThread := nil;
  end;

  NodeData	:= IncSrcsTree.GetNodeData(CurNode);
  if LastSelectedID = NodeData.Index then
	  Exit;

  LastSelectedID := NodeData.Index;

	UpdThread               	:= TIncSrcUpdateThread.Create(true);
  UpdThread.Priority				:= tpLower;
  UpdThread.FreeOnTerminate	:= true;
  UpdateIsIP								:= true;

  UpdThread.UConnection			:= FPConnection;
  UpdThread.PrntFrmHndl     := Self.Handle;
  UpdThread.UIncSrcID				:= NodeData.Index;
  UpdThread.UOPrefix        := ISPrefix;

  UpdThread.Start;
end;

procedure TIncomeSourcesForm.IncSrcsTreeDblClick(Sender: TObject);
begin
  if CurNode <> nil then begin
		EditIncomeSource;
  end;
end;

procedure TIncomeSourcesForm.IncSrcsTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  case Column of
    0: CellText := PIncSrcData(Sender.GetNodeData(Node)).Title;
    1: CellText := MyFloatToStr(PIncSrcData(Sender.GetNodeData(Node)).Price);
    2: CellText := PIncSrcData(Sender.GetNodeData(Node)).Descr;
  else
    CellText := '';
  end;
end;

procedure TIncomeSourcesForm.IncSrcsTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IncSrcsTree.Selected[CurNode] := false;
	CurNode := IncSrcsTree.GetNodeAt(X, Y);
  if CurNode <> nil then begin
	  IncSrcsTree.Selected[CurNode] := true;
  end;
  IncSrcsTree.FocusedNode := CurNode;
end;

end.
