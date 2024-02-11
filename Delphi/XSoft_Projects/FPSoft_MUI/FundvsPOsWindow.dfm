object FundvsPOsForm: TFundvsPOsForm
  Left = 0
  Top = 0
  Caption = #1054#1076#1086#1073#1088#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080' '#1087#1086' '#1092#1086#1085#1076#1072#1084
  ClientHeight = 255
  ClientWidth = 609
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 609
    Height = 255
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    ExplicitLeft = 176
    ExplicitTop = 120
    ExplicitWidth = 185
    ExplicitHeight = 41
    DesignSize = (
      609
      255)
    object FLabel: TsLabel
      Left = 8
      Top = 8
      Width = 31
      Height = 13
      Caption = #1060#1086#1085#1076':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object POLabel: TsLabel
      Left = 8
      Top = 55
      Width = 107
      Height = 13
      Caption = #1054#1076#1086#1073#1088#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object FCombo: TsComboBox
      Left = 8
      Top = 27
      Width = 593
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Alignment = taLeftJustify
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'Tahoma'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 0
      ItemIndex = -1
      ParentFont = False
      TabOrder = 0
      OnCloseUp = FComboCloseUp
      OnChange = FComboChange
    end
    object POList: TVirtualStringTree
      Left = 8
      Top = 74
      Width = 593
      Height = 175
      Anchors = [akLeft, akTop, akRight, akBottom]
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Header.Style = hsXPStyle
      Indent = 0
      TabOrder = 1
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnDblClick = POListDblClick
      OnGetText = POListGetText
      ExplicitWidth = 572
      Columns = <
        item
          Alignment = taRightJustify
          Position = 0
          Width = 40
          WideText = #8470
        end
        item
          Alignment = taRightJustify
          Position = 1
          Width = 70
          WideText = #1044#1072#1090#1072
        end
        item
          Position = 2
          Width = 350
          WideText = #1054#1087#1080#1089#1072#1085#1080#1077
        end
        item
          Alignment = taRightJustify
          Position = 3
          Width = 100
          WideText = #1057#1091#1084#1084#1072
        end>
    end
  end
end
