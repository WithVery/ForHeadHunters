unit PrintSetupWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  GlobalVars,
  Chart,
  Dialogs, ExtCtrls, StdCtrls, sCheckBox, sEdit, sSpinEdit, sRadioButton, sGroupBox, sLabel, sComboBox, sButton, sPanel;

type
  TPrintSetupForm = class(TForm)
    PrintersCombo: TsComboBox;
    sLabel1: TsLabel;
    sGroupBox1: TsGroupBox;
    PortraitRadio: TsRadioButton;
    AlbumRadio: TsRadioButton;
    sGroupBox2: TsGroupBox;
    SpinEditTop: TsDecimalSpinEdit;
    sLabel2: TsLabel;
    SpinEditLeft: TsDecimalSpinEdit;
    sLabel3: TsLabel;
    SpinEditRight: TsDecimalSpinEdit;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    SpinEditBottom: TsDecimalSpinEdit;
    sGroupBox3: TsGroupBox;
    VertCheckBox: TsCheckBox;
    HorizCheckBox: TsCheckBox;
    ValuesCheckBox: TsCheckBox;
    PreviewImage: TImage;
    PrintButton: TsButton;
    CancelButton: TsButton;
    sPanel1: TsPanel;
    sPanel2: TsPanel;
    procedure FormCreate(Sender: TObject);
    procedure PortraitRadioClick(Sender: TObject);
    procedure AlbumRadioClick(Sender: TObject);
    procedure HorizCheckBoxClick(Sender: TObject);
    procedure VertCheckBoxClick(Sender: TObject);
    procedure ValuesCheckBoxClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    Chart : TChart;
    procedure OnSPPSettingsChanged(var Message: TMessage); message CM_SPP_SETTINGSCHANGED;

  public
    { Public declarations }
    ChartToPrint : TChart;
    procedure InitChart;
  end;

var
  PrintSetupForm: TPrintSetupForm;

implementation

{$R *.dfm}
uses
  ClipBrd,
	Series,
	Printers;

procedure TPrintSetupForm.InitChart;
var
  Series1 : TLineSeries;
begin
	Chart := TChart.Create(nil);
  Chart.Assign(ChartToPrint);

  Series1 := TLineSeries.Create(nil);

	Chart.LeftAxis.Assign(ChartToPrint.LeftAxis);
  Chart.Axes.Bottom.Assign(ChartToPrint.BottomAxis);
  Series1.Assign(ChartToPrint.Series[0]);
  Chart.AddSeries(Series1);
  Chart.Axes.Left.TicksInner.Visible := false;
  Chart.Axes.Left.MinorTicks.Visible := false;
  Chart.Axes.Left.Grid.Visible := false;
  Chart.Axes.Left.Grid.Style := psDash;
  Chart.LeftAxis.Axis.Width := 1;
  Chart.Axes.Left.Ticks.Width := 1;
  Chart.Axes.Left.TickLength := 1;
  Chart.Axes.Bottom.TicksInner.Visible := false;
  Chart.Axes.Bottom.MinorTicks.Visible := false;
  Chart.Axes.Bottom.Grid.Visible := false;
  Chart.Axes.Bottom.Grid.Width := 1;
  Chart.Axes.Bottom.Ticks.Width := 1;
  Chart.Axes.Bottom.TickLength := 1;
//  Chart.Axes.Bottom.Grid.Style := psDash;
  Chart.BottomAxis.Axis.Width := 1;
//  Chart.BottomAxis.Axis.Style	:= psDash;
//  Chart.Title.Font.Size := 12;
  Chart.Title.Visible := true;
  Chart.Color	:= clWhite;
  Chart.Title.Caption := TForm(ChartToPrint.Parent).Caption;
  Chart.PrintResolution	:= -5;
  Chart.PrintMargins := Rect(0,0,0,0);
	Chart.PrintProportional := true;

end;

procedure TPrintSetupForm.OnSPPSettingsChanged(var Message: TMessage);
var
	WinRect : TRect;
  PWidth	: integer;
  PHeight	: integer;
  CenterPoint : TPoint;
  PaperRect	: TRect;
//  Chart			: TChart;
  BMP				: TBitMap;

begin
//	LockWindowUpdate(PreviewImage.
	WinRect := Previewimage.ClientRect;
	Previewimage.Canvas.Brush.Color := DefColor;
	Previewimage.Canvas.FillRect(WinRect);
  CenterPoint.X := (WinRect.Right - WinRect.Left) div 2;
  CenterPoint.Y := (WinRect.Bottom - WinRect.Top) div 2;
  Chart.LeftAxis.Grid.Visible := HorizCheckBox.Checked;
  Chart.BottomAxis.Grid.Visible := VertCheckBox.Checked;
	Chart.Series[0].Marks.Visible := ValuesCheckBox.Checked;

//  Previewimage.Canvas.LineTo(WinRect.Right, WinRect.Bottom);
	Chart.Top := 0;
  Chart.Left := 0;
  if PortraitRadio.Checked then begin // Portrait orientation
  	PHeight := WinRect.Bottom - WinRect.Top;
    PWidth	:= Trunc((PHeight * 1.0)/GoldenProp);
	  Chart.Height 	:= Trunc(500.0 * GoldenProp);
 		Chart.Width 	:= 500;
  end
  else begin
  	PWidth 	:= WinRect.Right - WinRect.Left;
    PHeight	:= Trunc((PWidth * 1.0)/GoldenProp);
	  Chart.Height	:= 500;
 		Chart.Width 	:= Trunc(500.0 * GoldenProp);
  end;
  Chart.Refresh;
  PaperRect.Left		:= CenterPoint.X - (PWidth div 2);
  PaperRect.Top   	:= CenterPoint.Y - (PHeight div 2);
  PaperRect.Right		:= CenterPoint.X + (PWidth div 2);
  PaperRect.Bottom	:= CenterPoint.Y + (PHeight div 2);

	Previewimage.Canvas.Brush.Color := clWhite;
	Previewimage.Canvas.FillRect(PaperRect);
  Previewimage.Canvas.Rectangle(PaperRect.Left, PaperRect.Top, PaperRect.Right, PaperRect.Bottom);

  BMP := TBitmap.Create;

  Chart.CopyToClipboardBitmap;
  BMP.Assign(Clipboard);
  Previewimage.Canvas.StretchDraw(PaperRect, BMP);
end;

procedure TPrintSetupForm.PortraitRadioClick(Sender: TObject);
begin
	PostMessage(Handle, CM_SPP_SETTINGSCHANGED, 0, 0);
end;

procedure TPrintSetupForm.PrintButtonClick(Sender: TObject);
var
  PrRect : TRect;
  iTop, iLeft, iRight, iBottom : extended;
  iTopBottom, iLeftRight	: extended;
begin
	Printer.PrinterIndex := PrintersCombo.ItemIndex;
  if PortraitRadio.Checked then begin
    Printer.Orientation := poPortrait;
    iTopBottom	:= A4Long;
    iLeftRight	:= A4Short;
  end
  else begin
    Printer.Orientation := poLandscape;
    iTopBottom	:= A4Short;
    iLeftRight	:= A4Long;
  end;
//  Chart.PrintProportional := true;

  PrRect := Printer.Canvas.ClipRect;

  iTop 		:= (SpinEditTop.Value * 10) / iTopBottom;
  iBottom	:= (SpinEditBottom.Value * 10) / iTopBottom;
  iLeft		:= (SpinEditLeft.Value * 10) / iLeftRight;
  iRight	:= (SpinEditRight.Value * 10) / iLeftRight;

	PrRect.Left		:= Trunc((PrRect.Right - PrRect.Left) * iLeft);
	PrRect.Right	:= PrRect.Right - Trunc((PrRect.Right - PrRect.Left) * iRight);
	PrRect.Top 		:= Trunc((PrRect.Bottom	- PrRect.Top) * iTop);
	PrRect.Bottom	:= PrRect.Bottom - Trunc((PrRect.Bottom	- PrRect.Top) * iBottom);
	Chart.PrintRect(PrRect);

end;

procedure TPrintSetupForm.ValuesCheckBoxClick(Sender: TObject);
begin
	PostMessage(Handle, CM_SPP_SETTINGSCHANGED, 0, 0);
end;

procedure TPrintSetupForm.VertCheckBoxClick(Sender: TObject);
begin
	PostMessage(Handle, CM_SPP_SETTINGSCHANGED, 0, 0);
end;

procedure TPrintSetupForm.AlbumRadioClick(Sender: TObject);
begin
	PostMessage(Handle, CM_SPP_SETTINGSCHANGED, 0, 0);
end;

procedure TPrintSetupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Assigned(Chart) then
  Chart.Free;
end;

procedure TPrintSetupForm.FormCreate(Sender: TObject);
begin
	PrintersCombo.Clear;
  PrintersCombo.Items.Assign(Printer.Printers);
	PrintersCombo.Text	:= Printer.Printers[0];
  PrintersCombo.ItemIndex := 0;
end;

procedure TPrintSetupForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TPrintSetupForm.FormShow(Sender: TObject);
begin
	PostMessage(Handle, CM_SPP_SETTINGSCHANGED, 0, 0);
end;

procedure TPrintSetupForm.HorizCheckBoxClick(Sender: TObject);
begin
	PostMessage(Handle, CM_SPP_SETTINGSCHANGED, 0, 0);
end;

end.
