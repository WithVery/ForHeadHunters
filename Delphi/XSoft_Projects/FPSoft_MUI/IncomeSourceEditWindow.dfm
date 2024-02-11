object IncomeSourceEditForm: TIncomeSourceEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1099#1081' '#1080#1089#1090#1086#1095#1085#1080#1082' '#1076#1086#1093#1086#1076#1072
  ClientHeight = 261
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TsPanel
    Left = 0
    Top = 215
    Width = 428
    Height = 46
    TabOrder = 0
    DesignSize = (
      428
      46)
    object CancelButton: TsButton
      Left = 248
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akLeft]
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 1
    end
    object OKButton: TsButton
      Left = 104
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akLeft]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
  end
  object Tree: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 428
    Height = 217
    Align = alTop
    Header.AutoSizeIndex = 0
    Header.Background = clGrayText
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = [fsBold]
    Header.Height = 17
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Indent = 1
    LineStyle = lsSolid
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toExtendedFocus]
    OnChange = TreeChange
    OnCreateEditor = TreeCreateEditor
    OnEditing = TreeEditing
    OnFocusChanged = TreeFocusChanged
    OnFocusChanging = TreeFocusChanging
    OnGetText = TreeGetText
    OnNewText = TreeNewText
    Columns = <
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coEditable]
        Position = 0
        Width = 150
        WideText = #1055#1072#1088#1072#1084#1077#1090#1088
      end
      item
        Position = 1
        Width = 250
        WideText = #1047#1085#1072#1095#1077#1085#1080#1077
      end>
  end
end
