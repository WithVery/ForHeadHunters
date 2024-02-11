object AssetVsFundsForm: TAssetVsFundsForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1040#1082#1090#1080#1074#1099' '#1080' '#1092#1086#1085#1076#1099
  ClientHeight = 286
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Tree: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 324
    Height = 286
    Hint = 
      #1065#1105#1083#1082#1085#1091#1090#1100' '#1087#1086' '#1072#1082#1090#1080#1074#1091' - '#1089#1084#1077#1085#1080#1090#1100' '#1077#1075#1086', Ctrl+Ins - '#1089#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1073#1091#1092#1077#1088 +
      '.'
    Align = alClient
    EditDelay = 10
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Height = 17
    Header.Options = [hoColumnResize, hoShowSortGlyphs, hoVisible]
    Indent = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnChange = TreeChange
    OnCreateEditor = TreeCreateEditor
    OnEditing = TreeEditing
    OnGetText = TreeGetText
    OnPaintText = TreePaintText
    OnKeyDown = TreeKeyDown
    OnNewText = TreeNewText
    Columns = <
      item
        Position = 0
        Width = 200
        WideText = #1053#1072#1079#1074#1072#1085#1080#1103
      end
      item
        Alignment = taRightJustify
        Position = 1
        Width = 100
        WideText = #1057#1091#1084#1084#1099
      end>
    WideDefaultText = ''
  end
end
