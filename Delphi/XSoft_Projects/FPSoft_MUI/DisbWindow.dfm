object DisbForm: TDisbForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1072#1089#1093#1086#1076#1086#1074#1072#1085#1080#1077' '#1089#1088#1077#1076#1089#1090#1074
  ClientHeight = 516
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 543
    Height = 516
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 504
    DesignSize = (
      543
      516)
    object DtLabel: TsLabel
      Left = 11
      Top = 9
      Width = 81
      Height = 13
      Caption = #1044#1072#1090#1072' '#1086#1087#1077#1088#1072#1094#1080#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel3: TsLabel
      Left = 261
      Top = 9
      Width = 40
      Height = 13
      Caption = #1047#1072#1103#1074#1082#1072':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object OrgLabel: TsLabel
      Left = 13
      Top = 28
      Width = 70
      Height = 13
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object CancelButton: TsButton
      Left = 320
      Top = 485
      Width = 135
      Height = 23
      Anchors = [akBottom]
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 5
      ExplicitTop = 473
    end
    object Dt: TsDateEdit
      Left = 98
      Top = 8
      Width = 86
      Height = 21
      AutoSize = False
      Enabled = False
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      ReadOnly = True
      TabOrder = 0
      Text = '  .  .    '
    end
    object OKButton: TsButton
      Left = 89
      Top = 485
      Width = 135
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1087#1080#1089#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = OKButtonClick
      ExplicitTop = 473
    end
    object POCombo: TsComboBox
      Left = 307
      Top = 8
      Width = 230
      Height = 21
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 2
      OnChange = POComboChange
    end
    object POGroupBox: TsGroupBox
      Left = 8
      Top = 35
      Width = 529
      Height = 444
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'POGroupBox'
      TabOrder = 3
      object FPLabel: TsLabel
        Left = 24
        Top = 21
        Width = 90
        Height = 13
        Caption = '_______________'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object FondLabel: TsLabel
        Left = 312
        Top = 21
        Width = 90
        Height = 13
        Caption = '_______________'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object AmountLabel: TsLabel
        Left = 41
        Top = 183
        Width = 54
        Height = 13
        Caption = #1054#1087#1083#1072#1090#1080#1090#1100':'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object TypeLabel: TsLabel
        Left = 24
        Top = 210
        Width = 71
        Height = 13
        Caption = #1058#1080#1087' '#1074#1099#1087#1083#1072#1090#1099':'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object AssLabel: TsLabel
        Left = 280
        Top = 210
        Width = 52
        Height = 13
        Caption = #1048#1089#1090#1086#1095#1085#1080#1082':'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object CreditorLabel: TsLabel
        Left = 41
        Top = 238
        Width = 54
        Height = 13
        Caption = #1050#1088#1077#1076#1080#1090#1086#1088':'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object ArrearsLabel: TLabel
        Left = 53
        Top = 265
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1088#1077#1076#1080#1090':'
        Visible = False
      end
      object RestMoneyLabel: TsLabel
        Left = 37
        Top = 387
        Width = 47
        Height = 13
        Caption = #1054#1089#1090#1072#1090#1086#1082':'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object DescrMemo: TsMemo
        Left = 24
        Top = 45
        Width = 481
        Height = 129
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object ApprSumEdit: TsEdit
        Left = 176
        Top = 18
        Width = 130
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        SkinData.CustomFont = True
      end
      object AmountEdit: TAdvMoneyEdit
        Left = 101
        Top = 180
        Width = 164
        Height = 21
        EditType = etMoney
        EmptyTextStyle = []
        Precision = 2
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Arial'
        Lookup.Font.Style = []
        Lookup.Separator = ';'
        BiDiMode = bdRightToLeft
        ParentBiDiMode = False
        Color = clWindow
        TabOrder = 2
        Text = '0,00'
        Visible = True
        OnChange = AmountEditChange
        Version = '1.1.2.6'
        CalculatorLook.ButtonWidth = 24
        CalculatorLook.ButtonHeight = 24
        CalculatorLook.ButtonColor = clSilver
        CalculatorLook.Color = clWhite
        CalculatorLook.Flat = False
        CalculatorLook.Font.Charset = DEFAULT_CHARSET
        CalculatorLook.Font.Color = clWindowText
        CalculatorLook.Font.Height = -11
        CalculatorLook.Font.Name = 'Tahoma'
        CalculatorLook.Font.Style = []
      end
      object TypeCombo: TsComboBox
        Left = 101
        Top = 207
        Width = 164
        Height = 21
        SkinData.SkinSection = 'COMBOBOX'
        Style = csDropDownList
        ItemIndex = -1
        TabOrder = 4
        OnChange = TypeComboChange
      end
      object AssCombo: TsComboBox
        Left = 338
        Top = 207
        Width = 167
        Height = 21
        SkinData.SkinSection = 'COMBOBOX'
        Style = csDropDownList
        ItemIndex = -1
        TabOrder = 5
      end
      object ArrearsTree: TVirtualStringTree
        Left = 101
        Top = 265
        Width = 404
        Height = 113
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Height = 17
        Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Indent = 4
        TabOrder = 7
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnChecked = ArrearsTreeChecked
        OnGetText = ArrearsTreeGetText
        OnPaintText = ArrearsTreePaintText
        Columns = <
          item
            Position = 0
            Width = 100
            WideText = #1044#1072#1090#1072
          end
          item
            Alignment = taRightJustify
            Position = 1
            Width = 80
            WideText = #1057#1091#1084#1084#1072
          end
          item
            Alignment = taRightJustify
            Position = 2
            Width = 80
            WideText = #1047#1072#1082#1088#1099#1090#1100
          end>
      end
      object RestMoneyEdit: TAdvMoneyEdit
        Left = 101
        Top = 384
        Width = 404
        Height = 21
        EditType = etMoney
        EmptyTextStyle = []
        ExcelStyleDecimalSeparator = True
        Precision = 2
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Arial'
        Lookup.Font.Style = []
        Lookup.Separator = ';'
        BiDiMode = bdRightToLeft
        ParentBiDiMode = False
        Color = clWindow
        Enabled = False
        Signed = True
        TabOrder = 8
        Text = '0,00'
        Visible = True
        Version = '1.1.2.6'
        CalculatorLook.ButtonWidth = 24
        CalculatorLook.ButtonHeight = 24
        CalculatorLook.ButtonColor = clSilver
        CalculatorLook.Color = clWhite
        CalculatorLook.Flat = False
        CalculatorLook.Font.Charset = DEFAULT_CHARSET
        CalculatorLook.Font.Color = clWindowText
        CalculatorLook.Font.Height = -11
        CalculatorLook.Font.Name = 'Tahoma'
        CalculatorLook.Font.Style = []
      end
      object AutoCloseCheckBox: TsCheckBox
        Left = 101
        Top = 408
        Width = 104
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
        TabOrder = 9
        OnClick = AutoCloseCheckBoxClick
      end
      object ByCashCB: TsCheckBox
        Left = 338
        Top = 181
        Width = 77
        Height = 17
        Caption = #1053#1072#1083#1080#1095#1085#1099#1077
        TabOrder = 3
        OnClick = ByCashCBClick
      end
      object CreditorCombo: TComboBox
        Left = 101
        Top = 237
        Width = 404
        Height = 21
        TabOrder = 6
        Text = 'CreditorCombo'
        OnChange = CreditorComboChange
        OnKeyPress = CreditorComboKeyPress
      end
    end
    object OrgCombo: TsComboBox
      Left = 89
      Top = 25
      Width = 166
      Height = 21
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 1
      OnChange = OrgComboChange
    end
  end
end
