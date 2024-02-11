unit IncPlanPrintPreviewWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  PtblRV, // for TRVPrint
  RVStyle, // for TRVUnitsRect
  Printers, // for Printer
  StrUtils, // for LeftStr
  GlobalVars, // for MinInt
  Dialogs, StdCtrls, sLabel, ExtCtrls, sPanel, RVScroll, CRVPP, RVPP, sEdit, sSpinEdit, sButton, sGroupBox, sRadioButton;

type
  TIncPlanPrintPreviewForm = class(TForm)
    rvpp: TRVPrintPreview;
    sPanel1: TsPanel;
    pnlSetUp: TsPanel;
    lblPages: TsLabel;
    lblOutOf: TsLabel;
    lblPageTot: TsLabel;
    lblPageCur: TsLabel;
    btnGoFirst: TsButton;
    btnGoPrev: TsButton;
    btnGoNext: TsButton;
    btnGoLast: TsButton;
    grpMargins: TsGroupBox;
    spnMarginTop: TsSpinEdit;
    spnMarginBottom: TsSpinEdit;
    spnMarginRight: TsSpinEdit;
    spnMarginLeft: TsSpinEdit;
    lblMarginTop: TsLabel;
    lblMarginBottom: TsLabel;
    lblMarginRight: TsLabel;
    lblMarginLeft: TsLabel;
    grpPrinter: TsGroupBox;
    lblPrinter: TsLabel;
    btnPrinterChoose: TsButton;
    pd: TPrintDialog;
    btnPrintIt: TsButton;
    grpPages: TsGroupBox;
    rbPagesAll: TsRadioButton;
    rbPagesSome: TsRadioButton;
    edtPages: TsEdit;
    procedure btnGoFirstClick(Sender: TObject);
    procedure btnGoPrevClick(Sender: TObject);
    procedure btnGoNextClick(Sender: TObject);
    procedure btnGoLastClick(Sender: TObject);
    procedure spnMarginTopChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spnMarginLeftChange(Sender: TObject);
    procedure spnMarginRightChange(Sender: TObject);
    procedure spnMarginBottomChange(Sender: TObject);
    procedure btnPrinterChooseClick(Sender: TObject);
    procedure rbPagesAllClick(Sender: TObject);
    procedure rbPagesSomeClick(Sender: TObject);
    procedure btnPrintItClick(Sender: TObject);
  private
    { Private declarations }
    PagesToPrint : set of byte;
    procedure RefreshPreview;
    procedure SetUpPrinter;
    procedure PagesAllClicked;
    procedure PagesSomeClicked;
  public
    { Public declarations }
    UpdateAllowed : boolean;
  end;

var
  IncPlanPrintPreviewForm: TIncPlanPrintPreviewForm;

implementation

{$R *.dfm}

procedure TIncPlanPrintPreviewForm.PagesAllClicked;
begin
  if rbPagesAll.Checked then begin
    rbPagesSome.Checked := false;
    edtPages.Enabled    := false;
  end;
end;

procedure TIncPlanPrintPreviewForm.PagesSomeClicked;
begin
  if rbPagesSome.Checked then begin
    rbPagesAll.Checked := false;
    edtPages.Enabled   := true;
  end;
end;


procedure TIncPlanPrintPreviewForm.SetUpPrinter;
begin
	lblPrinter.Caption := Printer.Printers[Printer.PrinterIndex];
end;

procedure TIncPlanPrintPreviewForm.btnGoFirstClick(Sender: TObject);
begin
rvpp.First;
lblPageCur.Caption := IntToStr(rvpp.PageNo);
end;

procedure TIncPlanPrintPreviewForm.btnGoPrevClick(Sender: TObject);
begin
	rvpp.Prev;
lblPageCur.Caption := IntToStr(rvpp.PageNo);
end;

procedure TIncPlanPrintPreviewForm.btnPrinterChooseClick(Sender: TObject);
begin
  if not pd.Execute then Exit;
  SetUpPrinter;
end;

procedure TIncPlanPrintPreviewForm.btnPrintItClick(Sender: TObject);
const
  PrintTitle : string = 'План по доходу.';
  Delims     : string = ',-';
  ErrorBoxCaption : string = 'Ничего не напечатано';
  ErrorMessage    : string = 'Проверьте правильность указанного диапазон и повторите печать.';
var
	i : integer;
  j : integer;
  tmpi1 : integer;
  tmpi2 : integer;
  str : string;
  iPrinted : integer;
  nPagesTot : integer;
  nPageStart : integer;
  nPageEnd   : integer;
  bIsRange : boolean;
  bCanPrint : boolean;
begin
	if rbPagesAll.Checked then begin
  	(rvpp.RVPrint as TRVPrint).Print(PrintTitle, 1, false);
    ModalResult := mrOk;
  end
  else begin
		nPagesTot := (rvpp.RVPrint as TRVPrint).PagesCount;

    iPrinted := 0;
    str := Trim(edtPages.Text);
    bCanPrint := false;
    bIsRange := false;
    while str <> '' do begin
      i := 1;

      if (pos(',', str) > 0) or (pos('-', str) > 0) then begin
	      while i < Length(str) do begin
		      if Pos(str[i], Delims) > 0 then begin
  	        if str[i] = ',' then begin
  	          bIsRange  := false;
    	        bCanPrint := true;
      	      if nPageStart > 0 then begin
        	    	TryStrToInt(LeftStr(str, i - 1), nPageEnd);
          	    break;
	            end
  	          else begin
    	        	TryStrToInt(LeftStr(str, i - 1), nPageStart);
      	        break;
        	    end;
          	end
	          else begin
  	          bIsRange   := true;
    	        bCanPrint  := false;
      	     	TryStrToInt(LeftStr(str, i - 1), nPageStart);
              break;
	          end;
  	      end;
(*
		      if Pos(str[i], Delims) > 0 then begin
	          bIsRange := str[i] = '-';
            break;
          end;
*)
          inc(i);
        end;
      end
      else begin
        if bIsRange then begin
        	TryStrToInt(str, nPageEnd);
        end
        else begin
          TryStrToInt(str, nPageStart);
        end;
        str := ''; // we do not need it anymore
        bCanPrint := true;
      end;
      if nPageEnd > 0 then begin // we have range here
        tmpi1 := MinInt(nPageStart, nPageEnd);
        tmpi2 := MaxInt(nPageStart, nPageEnd);
        nPageStart := MaxInt(1, tmpi1);
        nPageEnd   := MinInt(tmpi2, nPagesTot);
      end;

      if bCanPrint then begin
				bCanPrint := false;
		    bIsRange := false;
       // here goes printing
       	if(nPageStart <= nPagesTot) then begin
					Inc(iPrinted);
	      	if nPageEnd > 0 then begin
						(rvpp.RVPrint as TRVPrint).PrintPages(nPageStart, nPageEnd, PrintTitle +  ' Страницы с ' + IntToStr(nPageStart) + ' по ' + IntToStr(nPageEnd), 1, false);
	      	end
  	    	else begin
						(rvpp.RVPrint as TRVPrint).PrintPages(nPageStart, nPageStart, PrintTitle +  ' Страница ' + IntToStr(nPageStart), 1, false);
      		end;
	      end;
  	     // end of printing
    	  nPageStart := 0;
      	nPageEnd   := 0;
      end;
      str := Trim(MidStr(str, i + 1, Length(str)));
    end;
    if iPrinted = 0 then begin
		  Application.MessageBox(PWideChar(ErrorMessage), PWideChar(ErrorBoxCaption), MB_ICONINFORMATION or MB_OK);
    end
    else begin
    	ModalREsult := mrOk;
    end;
  end;
end;

procedure TIncPlanPrintPreviewForm.FormShow(Sender: TObject);
var
  mrgns : TRVUnitsRect;
begin
	SetUpPrinter;
  rbPagesAll.Checked := true;
	PagesAllClicked;

	mrgns := (rvpp.RVPrint as TRVPrint).Margins;
	spnMarginTop.Value    := trunc(mrgns.Top);
	spnMarginRight.Value  := trunc(mrgns.Right);
	spnMarginBottom.Value := trunc(mrgns.Bottom);
	spnMarginLeft.Value   := trunc(mrgns.Left);
	UpdateAllowed := true;
  RefreshPreview;
end;

procedure TIncPlanPrintPreviewForm.rbPagesAllClick(Sender: TObject);
begin
	PagesAllClicked;
end;

procedure TIncPlanPrintPreviewForm.rbPagesSomeClick(Sender: TObject);
begin
	PagesSomeClicked;
end;

procedure TIncPlanPrintPreviewForm.spnMarginBottomChange(Sender: TObject);
begin
	RefreshPreview;
end;

procedure TIncPlanPrintPreviewForm.spnMarginLeftChange(Sender: TObject);
begin
	RefreshPreview;
end;

procedure TIncPlanPrintPreviewForm.spnMarginRightChange(Sender: TObject);
begin
	RefreshPreview;
end;

procedure TIncPlanPrintPreviewForm.spnMarginTopChange(Sender: TObject);
begin
	RefreshPreview;
end;

procedure TIncPlanPrintPreviewForm.btnGoNextClick(Sender: TObject);
begin
	rvpp.Next;
lblPageCur.Caption := IntToStr(rvpp.PageNo);
end;

procedure TIncPlanPrintPreviewForm.btnGoLastClick(Sender: TObject);
begin
	rvpp.Last;
lblPageCur.Caption := IntToStr(rvpp.PageNo);
end;

procedure TIncPlanPrintPreviewForm.RefreshPreview;
begin
	if UpdateAllowed then begin
		(rvpp.RVPrint as TRVPrint).Margins.Top    := spnMarginTop.Value;
		(rvpp.RVPrint as TRVPrint).Margins.Right  := spnMarginRight.Value;
		(rvpp.RVPrint as TRVPrint).Margins.Bottom := spnMarginBottom.Value;
		(rvpp.RVPrint as TRVPrint).Margins.Left   := spnMarginLeft.Value;
	  (rvpp.RVPrint as TRVPrint).FormatPages(rvdoALL);

    lblPageTot.Caption := IntToStr(rvpp.RVPrint.PagesCount);
    if rvpp.PageNo > rvpp.RVPrint.PagesCount then rvpp.PageNo := rvpp.RVPrint.PagesCount;
    lblPageCur.Caption := IntToStr(rvpp.PageNo);

  	rvpp.Repaint;
  end;
end;

end.
