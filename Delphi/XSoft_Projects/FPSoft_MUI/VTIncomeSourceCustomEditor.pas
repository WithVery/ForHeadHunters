unit VTIncomeSourceCustomEditor;

interface

uses
Mask, // TMaskEdit
Graphics,
ExtCtrls,
ComCtrls,
StdCtrls,
SysUtils,
Messages,
Classes,
Controls,
VirtualTrees,
Windows,
AdvEdit,
GlobalVars,
Dialogs;

type
//  TVTEditorKind = (
//    ekString, // TEdit
//    ekMemo, // TMemo
//    ekComboBox, // TComboBox
//    ekColor, // TColorBox
//    ekDate, // TDateTimePicker
//    ekMask, // TMaskedEdit
//    ekProgress // TProgressBar
//  );

(*
  PVTEditNode = ^TVTEditNode;

  TVTEditNode = record
    Kind: TVTEditorKind;
    Value: String;
    Changed: Boolean;
  end;
*)

  // Наш класс, реализующий интерфейс IVTEditLink.
  // Он будет базовым для всех типов редакторов. Тип создаваемого редактора
  // для каждого узла будет определять по значению поля Kind у записи данных
  // узла (TVTEditNode).
  // Этот вариант более рационален, так как не придётся для каждого типа данных
  // создавать разные классы, релаизующие один и тот же интерфейс по почти
  // идентичной схеме.
  TVTIncomeSourceCustomEditor = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TWinControl;        // Базовый класс для каждого типа редактора
    FTree: TVirtualStringTree; // Ссылка на дерево, вызвавшее редактирование
    FNode: PVirtualNode;       // Редактируемый узел
    FColumn: Integer;          // Его колонка, в которой оно происходит
//    FSourceCombo : TComboBox;
//    FComboStrings : TStringList;
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
//    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
  public
    destructor Destroy; override;
    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;

implementation

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * TVTIncomeSourceCustomEditor * * * * * * * * * * * * * * * }
//------------------------------------------------------------------------------
destructor TVTIncomeSourceCustomEditor.Destroy;
begin
  FreeAndNil(FEdit);
//  FreeAndNil(VTCEAssetList);
  inherited;
end;

//procedure TVTIncomeSourceCustomEditor.CMDialogKey(var Msg: TWMKEY);
//var
//  Key : Word;
//begin
//  if (Msg.Charcode = VK_TAB) then begin
//    Key := Msg.CharCode;
//    EditKeyDown(Self, Key, []);
//  end;
//  inherited;
//end;

//------------------------------------------------------------------------------
// Для обработки нажатий с клавиатуры.
// Отмена редактироваеия по Escape, завершение редактирования по Enter,
// и переход между узлами по Up/Down, если список элементов у комбо бокса или
// редактора даты не выпущен.
//------------------------------------------------------------------------------
procedure TVTIncomeSourceCustomEditor.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CanContinue: Boolean;
begin
  CanContinue := True;
  case Key of
    VK_ESCAPE: // Нажали Escape
      if CanContinue then begin
        FTree.CancelEditNode;
        Key := 0;
      end;
    VK_RETURN, VK_TAB: // Нажали Enter или Tab
      if CanContinue then begin
        // Если Ctrl для TMemo не зажат, то завершаем редактирование
        // Сдеалем так, чтобы можно было по Ctrl+Enter вставлять в Memo
        // новую линию.
//        if (FEdit is TMemo) and (Shift = []) then
//          FTree.EndEditNode
//        else if not(FEdit is TMemo) then
//          FTree.EndEditNode;
        if (FTree.Parent <> nil) and (FTree.Parent.Parent <> nil) then begin
          PostMessage(FTree.Parent.Parent.Handle, UM_VST_END_EDIT, 0, 0);
        end;
        Key := 0;
      end;
    VK_UP, VK_DOWN:
      begin
        // Проверить, не идёт ли работа с редактором. Если идёт, то запретить
        // активность дерева, если нет, то передать нажатие дереву.
        CanContinue := Shift = [];
//        if FEdit is TComboBox then
//          CanContinue := CanContinue and not TComboBox(FEdit).DroppedDown;
//        if FEdit is TDateTimePicker then
//          CanContinue :=  CanContinue and not TDateTimePicker(FEdit).DroppedDown;
        if CanContinue then begin
          // Передача клавиши дереву
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;

end;

//------------------------------------------------------------------------------
// Началось редактирование, нужно показать редактор и установить ему фокус.
//------------------------------------------------------------------------------
function TVTIncomeSourceCustomEditor.BeginEdit: Boolean;
var
  VTEditNode: PIncomeSourceProperty;
begin
  Result := True;
  VTEditNode := FTree.GetNodeData(FNode);
  if FEdit is TEdit then begin
    TEdit(FEdit).Text := VTEditNode.description;
  end
  else if FEdit is TAdvEdit then begin
      TAdvEdit(FEdit).IntValue := Trunc(VTEditNode.Price);

(*
    if(VTEditNode.description = '') then begin
      TAdvEdit(FEdit).IntValue := 0;
    end
    else begin
      TAdvEdit(FEdit).IntValue := StrToInt(VTEditNode.description);
    end;
*)
  end;

  with FEdit do begin
    Show;
    SetFocus;
  end;
end;

//------------------------------------------------------------------------------
// Отменилось, прячем редактор.
//------------------------------------------------------------------------------
function TVTIncomeSourceCustomEditor.CancelEdit: Boolean;
 begin
  Result := True;
  FEdit.Hide;
  FTree.InvalidateNode(FNode);
end;

//
//function TVTCustomEditor1.CancelEdit: Boolean;
// begin
//  Result := True;
//  FEdit.Hide;
//  FTree.InvalidateNode(FNode);
//end;



//------------------------------------------------------------------------------
// Успешно завершилось, прячем редактор, обновляем данные узла и возвращаем
// фокус дереву.
//------------------------------------------------------------------------------
function TVTIncomeSourceCustomEditor.EndEdit: Boolean;
var
  Txt: String;
begin
  Result := True;
  if FEdit is TEdit then begin
    Txt := TEdit(FEdit).Text;
  end
  else if FEdit is TAdvEdit then begin
    Txt := IntToStr(TAdvEdit(FEdit).IntValue);
  end
//  else if FEdit is TMemo then
//    Txt := TEdit(FEdit).Text;
  else if FEdit is TComboBox then begin
    Txt := TComboBox(FEdit).Text;
  end;
//  else if FEdit is TColorBox then
//    Txt := ColorToString(TColorBox(FEdit).Selected)
//  else if FEdit is TDateTimePicker then begin
//    Txt := DateToStr(TDateTimePicker(FEdit).DateTime);
//  end
//  else if FEdit is TMaskEdit then
//    Txt := TMaskEdit(FEdit).Text
//  else if FEdit is TProgressBar then
//    Txt := IntToStr(TProgressBar(FEdit).Position) + ' %';
  // Изменяем текст узла (поле Value у TVTEditNode) через событие OnNewText
  // у дерева
  FTree.Text[FNode, FColumn] := Txt;
  FEdit.Hide;
  FTree.SetFocus;
end;

//------------------------------------------------------------------------------
// Возвращаем границы редактора.
//------------------------------------------------------------------------------
function TVTIncomeSourceCustomEditor.GetBounds: TRect;
begin
  Result := Ftree.GetDisplayRect(FNode, 1, FALSE, True, FALSE);
//  Dec(Result.Bottom, 5);
end;

//------------------------------------------------------------------------------
// В подготовке к редактированию мы должны создать экземпляр TWinControl
// нужного класса потомка в соответствии с полем Kind у TVTEditNode.
//------------------------------------------------------------------------------
function TVTIncomeSourceCustomEditor.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  VTEditNode: PIncomeSourceProperty;
//  i : integer;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
//  if FEdit <> nil then begin
//    FEdit.Visible := false;
//  end;

  if (VTEditNode.kind = 'price') then begin
  	FEdit := TAdvEdit.Create(nil);
    with FEdit as TAdvEdit do begin
      OnKeyDown := EditKeyDown;
      AutoThousandSeparator := true;
      EditType := etMoney;
      EditAlign := eaRight;
    end;
  end
  else begin
    FEdit := TEdit.Create(nil);
    with FEdit as TEdit do begin
      OnKeyDown := EditKeyDown;
    end;
  end;


  FEdit.Visible := false;
  FEdit.Parent := Tree;

end;

//------------------------------------------------------------------------------
// Обработка сообщений Windows для редактора.
//------------------------------------------------------------------------------
procedure TVTIncomeSourceCustomEditor.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

//------------------------------------------------------------------------------
// Устанавливает границы редактора в соответствии с шириной и высотой колонки.
//------------------------------------------------------------------------------
procedure TVTIncomeSourceCustomEditor.SetBounds(R: TRect);
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, R.Left, R.Right);
//  Dec(R.Bottom, 5);
  FEdit.BoundsRect := R;
//  FEdit.Height := FEdit.Height - 5;
  if FEdit is TMemo then begin
    FEdit.Height := 80;
  end;
end;

end.
