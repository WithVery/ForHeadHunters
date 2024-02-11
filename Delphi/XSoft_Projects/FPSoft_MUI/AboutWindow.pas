unit AboutWindow;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  GlobalVars,
  ZDataset,
  Buttons, ExtCtrls, acPNG, sPanel, sLabel, Menus, VirtualTrees, ComCtrls, sTabControl, sRichEdit;

type
  PEncListValue = ^TEncListValue;
	TEncListValue = record
  	VarName : string;
  	VarValue : string;
	end;

type
  TAboutBox = class(TForm)
    OKButton: TButton;
    sPanel1: TsPanel;
    Comments: TLabel;
    Copyright: TLabel;
    ProgramIcon: TImage;
    VersionLabel: TLabel;
    DVLabel: TLabel;
    Emaillabel: TsWebLabel;
    PopupMenu: TPopupMenu;
    CopyEmailAddres: TMenuItem;
    VarsListTree: TVirtualStringTree;
    ListPopupMenu: TPopupMenu;
    ListCopy: TMenuItem;
    TabCtrl: TsTabControl;
    WhatsNewEdit: TsRichEdit;
    ThirdPartiesEdit: TsRichEdit;
    procedure CopyEmailAddresClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure VarsListTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormShow(Sender: TObject);
    procedure ListCopyClick(Sender: TObject);
    procedure TabCtrlChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ClipBrd;

procedure TAboutBox.CopyEmailAddresClick(Sender: TObject);
begin
  ClipBoard.AsText := 'support@fpsoft.ru';
end;

procedure TAboutBox.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TAboutBox.FormShow(Sender: TObject);
const
  requests : array[0..4] of string = (
	  'show variables like "%_ssl%"',
  	'show SESSION status like "ssl_cipher"'
	  ,'show SESSION status like "ssl_version"'
    ,'SELECT ''client_ip'', SUBSTRING_INDEX(host,'':'',1) as ''address'' FROM information_schema.processlist WHERE ID=connection_id()'
    ,'show variables like ''%hostname%'''
  );
var
	NewNode     : PVirtualNode;
	NewNodeData : PEncListValue;
  i						: integer;
begin
	VarsListTree.Align := alClient;
	VarsListTree.NodeDataSize := sizeof(TEncListValue);
  for i := Low(Requests) to High(requests) do begin

		FPTmpDataset.SQL.Text := requests[i];
  	FPTmpDataset.Open;
	  while not FPTmpDataset.Eof do begin
  		NewNode := VarsListTree.AddChild(nil);
    	NewNodeData := VarsListTree.GetNodeData(NewNode);
	    NewNodeData.VarName := FPTmpDataset.Fields[0].AsString;
  	  NewNodeData.VarValue := FPTmpDataset.Fields[1].AsString;
	  	FPTmpDataset.Next;
	  end;
  	FPTmpDataset.Close;
  end;

  // adjusting What's New window
  WhatsNewEdit.Align := alClient;
  WhatsNewEdit.Lines.Clear;
  WhatsNewEdit.Lines.Add('История изменений:');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.3.0.26');
  WhatsNewEdit.Lines.Add(' - Некорректная работа поиска.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.3.0.25');
  WhatsNewEdit.Lines.Add(' - Некорректное отображение окна расходов при масштабировании шрифтов.');
  WhatsNewEdit.Lines.Add(' - Исправлена отображение списка активы/фонды.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.3.0.11-15');
  WhatsNewEdit.Lines.Add(' - Исправление мелких ошибок.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.3.0.10');
  WhatsNewEdit.Lines.Add(' + Интеграция со статистиками.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.27');
  WhatsNewEdit.Lines.Add(' + При переводе средств с одного актива на другой выводится предупреждение о необходимости физического перевода средств.');
  WhatsNewEdit.Lines.Add(' - Исправлены мелкие ошибки.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.18');
  WhatsNewEdit.Lines.Add(' + Оптимизирована загрузка дебиторки/кредиторки.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.15');
  WhatsNewEdit.Lines.Add(' + В дебиторке/кредиторке фиксируется/выводится автор записи.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.14');
  WhatsNewEdit.Lines.Add(' + Добавлена возможность учёта типа расходной операции в заявках.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.13');
  WhatsNewEdit.Lines.Add(' + Добавлена возможность экспортировать заявки в файл формата xls.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.12');
  WhatsNewEdit.Lines.Add(' + Суммы по заявкам выводятся с учётом фильтров.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.11');
  WhatsNewEdit.Lines.Add(' + Добавлены фильтры для столбцов в заявках.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.10');
  WhatsNewEdit.Lines.Add(' + Добавлена привязка оплаченных заявок к ФП.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.07');
  WhatsNewEdit.Lines.Add(' + Добавлен подсчёт общей суммы по выделенным строкам в дебиторке и кредиторке.');
  WhatsNewEdit.Lines.Add(' + В раздел «Оплаченные заявки» добавлена колонка «Дата оплаты».');
  WhatsNewEdit.Lines.Add(' + Добавлена возможность сортировок по всем столбцам в окне заявок. Сортировка производится независимо в каждом разделе (выставленные, отклонённые и т.д.).');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.06');
  WhatsNewEdit.Lines.Add(' + Добавлен предварительный просмотр перед печатью плана по доходу.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.03');
  WhatsNewEdit.Lines.Add('+ Введена возможность прикладывать к заявкам на ФП файлы любого типа размером до 10 МБ.');
  WhatsNewEdit.Lines.Add('+ Хранение приложений к заявкам на ФП перенесено на http сервер.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.02');
  WhatsNewEdit.Lines.Add(' + План по доходу поддерживает добавление таблиц, форматирование шрифтов и заливку абзацев.');
  WhatsNewEdit.Lines.Add('');

  WhatsNewEdit.Lines.Add('Версия 1.2.7.01');
  WhatsNewEdit.Lines.Add(' + Улучшена работа комбобокса кредиторов в окне "Расход" при списывании кредиторской задолженности.');
  WhatsNewEdit.Lines.Add(' + В базу заносятся данные о том, кто провёл операцию.');

  // Filling Third parties window.
  ThirdPartiesEdit.Align := alClient;

	TabCtrlChange(Sender);
end;

procedure TAboutBox.ListCopyClick(Sender: TObject);
var
	StrToClipboard : string;
	Node     : PVirtualNode;
	NodeData : PEncListValue;
begin
	StrToClipBoard := '';
  Node := VarsListTree.GetFirstChild(nil);
  while Node <> nil do begin
		NodeData := VarsListTree.GetNodeData(Node);
    StrToClipBoard := StrToClipBoard + NodeData.VarName + #9 + NodeData.VarValue + #$D#$A;
    Node := VarsListTree.GetNextSibling(Node);
  end;

	Clipboard.SetTextBuf(PWideChar(StrToClipBoard));

end;

procedure TAboutBox.TabCtrlChange(Sender: TObject);
begin
	case TabCtrl.TabIndex of
		0 : begin // what's new?
    	WhatsNewEdit.Visible := true;
    	VarsListTree.Visible := false;
      ThirdPartiesEdit.Visible := false;
    end;
    1 : begin // connection
    	WhatsNewEdit.Visible := false;
    	VarsListTree.Visible := true;
      ThirdPartiesEdit.Visible := false;
    end;
    2 : begin // third partyies
    	WhatsNewEdit.Visible := false;
    	VarsListTree.Visible := false;
      ThirdPartiesEdit.Visible := true;
    end;
	end;
end;

procedure TAboutBox.VarsListTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
	NodeData : PEncListValue;
begin
  CellText := '';
  if Node = nil then
    Exit;

  NodeData := Sender.GetNodeData(Node);
  case Column of
    0: CellText := NodeData.VarName;
    1: CellText := NodeData.VarValue;
  end;
end;

end.

