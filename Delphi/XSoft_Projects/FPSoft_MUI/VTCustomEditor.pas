{
  Пример № 5 - Создание собственных редакторов данных.
  Пример иллюстрирует создание и использование различных типов
  редактооров данных для дерева в соответствии с типом данных.

  © Quadr0, 2006 (4quadr0@gmail.com) (http://vingrad.ru/@Quadr0).
}

unit VTCustomEditor;

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

	PAVFN = ^TAVFN;
  TAVFN = record
    link    : string;
    name    : string;
    balance : extended;
  end;

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
  TVTCustomEditor = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TWinControl;        // Базовый класс для каждого типа редактора
    FTree: TVirtualStringTree; // Ссылка на дерево, вызвавшее редактирование
    FNode: PVirtualNode;       // Редактируемый узел
    FColumn: Integer;          // Его колонка, в которой оно происходит
//    FSourceCombo : TComboBox;
//    FComboStrings : TStringList;
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

var
  VTCEAssetList : TStringList;

implementation

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * TVTCustomEditor * * * * * * * * * * * * * * * }
//------------------------------------------------------------------------------
destructor TVTCustomEditor.Destroy;
begin
  FreeAndNil(FEdit);
  FreeAndNil(VTCEAssetList);
  inherited;
end;

//------------------------------------------------------------------------------
// Для обработки нажатий с клавиатуры.
// Отмена редактироваеия по Escape, завершение редактирования по Enter,
// и переход между узлами по Up/Down, если список элементов у комбо бокса или
// редактора даты не выпущен.
//------------------------------------------------------------------------------
procedure TVTCustomEditor.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CanContinue: Boolean;
begin
  CanContinue := True;
  case Key of
    VK_ESCAPE: // Нажали Escape
      if CanContinue then
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;
    VK_RETURN: // Нажали Enter
      if CanContinue then begin
        // Если Ctrl для TMemo не зажат, то завершаем редактирование
        // Сдеалем так, чтобы можно было по Ctrl+Enter вставлять в Memo
        // новую линию.
        if (FEdit is TMemo) and (Shift = []) then
          FTree.EndEditNode
        else if not(FEdit is TMemo) then
          FTree.EndEditNode;
        Key := 0;
      end;
    VK_UP, VK_DOWN:
      begin
        // Проверить, не идёт ли работа с редактором. Если идёт, то запретить
        // активность дерева, если нет, то передать нажатие дереву.
        CanContinue := Shift = [];
        if FEdit is TComboBox then
          CanContinue := CanContinue and not TComboBox(FEdit).DroppedDown;
        if FEdit is TDateTimePicker then
          CanContinue :=  CanContinue and not TDateTimePicker(FEdit).DroppedDown;
        if CanContinue then
        begin
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
function TVTCustomEditor.BeginEdit: Boolean;
begin
  Result := True;
  with FEdit do
  begin
    Show;
    SetFocus;
  end;
end;

//------------------------------------------------------------------------------
// Отменилось, прячем редактор.
//------------------------------------------------------------------------------
function TVTCustomEditor.CancelEdit: Boolean;
 begin
  Result := True;
  FEdit.Hide;
end;

//------------------------------------------------------------------------------
// Успешно завершилось, прячем редактор, обновляем данные узла и возвращаем
// фокус дереву.
//------------------------------------------------------------------------------
function TVTCustomEditor.EndEdit: Boolean;
var
  Txt: String;
begin
  Result := True;
  if FEdit is TEdit then
    Txt := TEdit(FEdit).Text
  else if FEdit is TMemo then
    Txt := TEdit(FEdit).Text
  else if FEdit is TComboBox then
    Txt := TComboBox(FEdit).Text
  else if FEdit is TColorBox then
    Txt := ColorToString(TColorBox(FEdit).Selected)
  else if FEdit is TDateTimePicker then begin
    Txt := DateToStr(TDateTimePicker(FEdit).DateTime);
  end
  else if FEdit is TMaskEdit then
    Txt := TMaskEdit(FEdit).Text
  else if FEdit is TProgressBar then
    Txt := IntToStr(TProgressBar(FEdit).Position) + ' %';
  // Изменяем текст узла (поле Value у TVTEditNode) через событие OnNewText
  // у дерева
  FTree.Text[FNode, FColumn] := Txt;
  FEdit.Hide;
  FTree.SetFocus;
end;

//------------------------------------------------------------------------------
// Возвращаем границы редактора.
//------------------------------------------------------------------------------
function TVTCustomEditor.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

//------------------------------------------------------------------------------
// В подготовке к редактированию мы должны создать экземпляр TWinControl
// нужного класса потомка в соответствии с полем Kind у TVTEditNode.
//------------------------------------------------------------------------------
function TVTCustomEditor.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  VTEditNode: PAVFN;
  i : integer;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FreeAndNil(FEdit);
  VTEditNode := FTree.GetNodeData(Node);

	FEdit := TComboBox.Create(nil);
  with FEdit as TComboBox do begin
  	Style := csDropDownList;
    Visible := False;
    Parent := Tree;
    Text := VTEditNode.name;
		Items.AddStrings(VTCEAssetList);
    for i := 0 to Items.Count - 1 do begin
    	if Items[i] = VTEditNode.name then begin
      	ItemIndex := i;
        break;
      end;
    end;
    OnKeyDown := EditKeyDown;
  end;
end;

//------------------------------------------------------------------------------
// Обработка сообщений Windows для редактора.
//------------------------------------------------------------------------------
procedure TVTCustomEditor.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

//------------------------------------------------------------------------------
// Устанавливает границы редактора в соответствии с шириной и высотой колонки.
//------------------------------------------------------------------------------
procedure TVTCustomEditor.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
  if FEdit is TMemo then
    FEdit.Height := 80;
end;

//------------------------------------------------------------------------------
{* * * * * * * * * * * * * * * * * * * TfrmMain * * * * * * * * * * * * * * * *}
//------------------------------------------------------------------------------
(*
procedure TfrmMain.VTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with Sender do
  begin
    if Assigned(Node) then
    begin
      // Убираем паузу перед редактированием узла. Что бы ни случилось с узлом,
      // (кликнули, выделили) сразу начётся редактирование колонки.
      VT.EditNode(Node, 1);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TVTCustomEditor.Create;
end;

//------------------------------------------------------------------------------
// Разрешаем редактировать только второую колонку.
//------------------------------------------------------------------------------
procedure TfrmMain.VTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column > 0;
end;

//------------------------------------------------------------------------------
// Обновляем виртуальные данные после редактирования.
//------------------------------------------------------------------------------
procedure TfrmMain.VTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; NewText: String);
var
  VTEditNode: PVTEditNode;
begin
  VTEditNode := Sender.GetNodeData(Node);
  with VTEditNode^ do
  begin
    if not Changed then
      Changed := Value <> NewText;
    Value := StringReplace(NewText, #13#10, ' ', [rfReplaceAll]);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.VTPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  VTEditNode: PVTEditNode;
begin
  VTEditNode := Sender.GetNodeData(Node);
  if VTEditNode.Changed then
    TargetCanvas.Font.Style := [fsBold]
  else
    TargetCanvas.Font.Style := [];
end;
*)

end.
