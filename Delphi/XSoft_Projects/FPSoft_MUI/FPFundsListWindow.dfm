object FPFundsListForm: TFPFundsListForm
  AlignWithMargins = True
  Left = 0
  Top = 0
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  BorderStyle = bsSizeToolWin
  Caption = #1057#1088#1077#1076#1089#1090#1074#1072' '#1085#1072' '#1092#1086#1085#1076#1072#1093
  ClientHeight = 295
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 562
    Height = 295
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    TabOrder = 0
    object FundsTree: TVirtualStringTree
      Left = 1
      Top = 1
      Width = 560
      Height = 293
      Align = alClient
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Height = 17
      Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Indent = 8
      TabOrder = 0
      TreeOptions.MiscOptions = [toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines, toUseExplorerTheme]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnCompareNodes = FundsTreeCompareNodes
      OnGetText = FundsTreeGetText
      OnPaintText = FundsTreePaintText
      Columns = <
        item
          Position = 0
          Width = 150
          WideText = #1060#1086#1085#1076
        end
        item
          Alignment = taRightJustify
          Position = 1
          Width = 100
          WideText = #1042#1093#1086#1076#1103#1097#1080#1081' '#1086#1089#1090#1072#1090#1086#1082
        end
        item
          Alignment = taRightJustify
          Position = 2
          Width = 100
          WideText = #1054#1090#1083#1086#1078#1077#1085#1086' '#1085#1072' '#1060#1055
        end
        item
          Alignment = taRightJustify
          Position = 3
          Width = 100
          WideText = #1054#1076#1086#1073#1088#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
        end
        item
          Alignment = taRightJustify
          Position = 4
          Width = 100
          WideText = #1054#1089#1090#1072#1090#1086#1082
        end>
    end
  end
end
