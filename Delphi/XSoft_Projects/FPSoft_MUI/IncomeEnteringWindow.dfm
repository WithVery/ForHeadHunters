object IncomeEnteringForm: TIncomeEnteringForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1088#1080#1093#1086#1076
  ClientHeight = 545
  ClientWidth = 462
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
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 462
    Height = 545
    Align = alClient
    TabOrder = 0
    DesignSize = (
      462
      545)
    object ArrearsLabel: TsLabel
      Left = 44
      Top = 258
      Width = 84
      Height = 13
      Caption = #1047#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1100':'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object DebtorLabel: TsLabel
      Left = 80
      Top = 236
      Width = 48
      Height = 13
      Caption = #1044#1077#1073#1080#1090#1086#1088':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object DescrLabel: TsLabel
      Left = 4
      Top = 133
      Width = 122
      Height = 13
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080' '#1086#1087#1077#1088#1072#1094#1080#1080':'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PriceLabel: TsLabel
      Left = 16
      Top = 467
      Width = 30
      Height = 13
      Caption = #1062#1077#1085#1072':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel2: TsLabel
      Left = 281
      Top = 467
      Width = 35
      Height = 13
      Caption = #1057#1091#1084#1084#1072':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object TypeLabel: TsLabel
      Left = 55
      Top = 65
      Width = 73
      Height = 13
      Caption = #1058#1080#1087' '#1086#1087#1077#1088#1072#1094#1080#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object DestLabel: TsLabel
      Left = 18
      Top = 85
      Width = 110
      Height = 13
      Caption = #1050#1091#1076#1072' '#1087#1088#1080#1096#1083#1080' '#1076#1077#1085#1100#1075#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel5: TsLabel
      Left = 66
      Top = 38
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1087#1077#1094#1076#1086#1093#1086#1076'?'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object RestMoneyLabel: TsLabel
      Left = 80
      Top = 378
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
    object IncSrcLabel: TsLabel
      Left = 34
      Top = 111
      Width = 93
      Height = 13
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1076#1086#1093#1086#1076#1072':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object AmountLabel: TsLabel
      Left = 147
      Top = 467
      Width = 39
      Height = 13
      Caption = #1050#1086#1083'-'#1074#1086':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PercentLabel: TsLabel
      Left = 297
      Top = 38
      Width = 64
      Height = 13
      Caption = '% '#1074' '#1052#1086#1089#1082#1074#1091':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object OrgLabel: TsLabel
      Left = 192
      Top = 38
      Width = 70
      Height = 13
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object ClientsLabel: TsLabel
      Left = 87
      Top = 11
      Width = 41
      Height = 13
      Caption = #1050#1083#1080#1077#1085#1090':'
    end
    object AdvMoneyEdit: TAdvMoneyEdit
      Left = 320
      Top = 464
      Width = 114
      Height = 21
      TabStop = False
      EditorEnabled = False
      EditType = etMoney
      EmptyTextStyle = []
      ExcelStyleDecimalSeparator = True
      FocusBorderColor = clBlack
      FocusColor = clWhite
      FocusFontColor = clBlack
      ModifiedColor = clWhite
      DisabledColor = clWhite
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
      CanUndo = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      Signed = True
      TabOrder = 9
      Text = '0,00'
      Visible = True
      OnChange = AdvMoneyEditChange
      OnKeyUp = AdvMoneyEditKeyUp
      Version = '1.1.2.6'
      CalculatorLook.ButtonWidth = 0
      CalculatorLook.ButtonHeight = 0
      CalculatorLook.ButtonColor = clBlack
      CalculatorLook.Color = clWhite
      CalculatorLook.Flat = False
      CalculatorLook.Font.Charset = DEFAULT_CHARSET
      CalculatorLook.Font.Color = clWindowText
      CalculatorLook.Font.Height = -11
      CalculatorLook.Font.Name = 'Tahoma'
      CalculatorLook.Font.Style = []
    end
    object CancelButton: TButton
      Left = 286
      Top = 512
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 19
    end
    object DebtorCombo: TsComboBox
      Left = 144
      Top = 232
      Width = 290
      Height = 21
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 14
      OnChange = DebtorComboChange
    end
    object DescrMemo: TMemo
      Left = 144
      Top = 131
      Width = 290
      Height = 95
      Lines.Strings = (
        'DescrMemo')
      TabOrder = 13
      OnKeyUp = DescrMemoKeyUp
    end
    object DestCombo: TsComboBox
      Left = 144
      Top = 85
      Width = 290
      Height = 21
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 3
    end
    object OKButton: TButton
      Left = 44
      Top = 512
      Width = 149
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1087#1080#1089#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 18
      OnClick = OKButtonClick
    end
    object SpecIncCB: TsCheckBox
      Left = 144
      Top = 36
      Width = 40
      Height = 17
      Caption = #1044#1072
      TabOrder = 1
    end
    object TypeCombo: TsComboBox
      Left = 144
      Top = 62
      Width = 290
      Height = 21
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      Enabled = False
      ItemIndex = -1
      TabOrder = 2
      OnChange = TypeComboChange
    end
    object ArrearsTree: TVirtualStringTree
      Left = 144
      Top = 255
      Width = 290
      Height = 114
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Height = 17
      Header.Options = [hoColumnResize, hoVisible]
      Indent = 4
      TabOrder = 15
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
          WideText = #1044#1086#1083#1075
        end
        item
          Alignment = taRightJustify
          Position = 2
          Width = 80
          WideText = #1047#1072#1082#1088#1099#1090#1100
        end>
    end
    object RestMoneyEdit: TAdvMoneyEdit
      Left = 144
      Top = 375
      Width = 290
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
      TabOrder = 16
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
      Left = 144
      Top = 400
      Width = 104
      Height = 17
      Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
      TabOrder = 17
      OnClick = AutoCloseCheckBoxClick
    end
    object IncSrcCombo: TsComboBox
      Left = 144
      Top = 108
      Width = 290
      Height = 21
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 12
    end
    object PriceEdit: TAdvMoneyEdit
      Left = 52
      Top = 465
      Width = 86
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
      Signed = True
      TabOrder = 7
      Text = '0,00'
      Visible = True
      OnChange = PriceEditChange
      OnKeyDown = PriceEditKeyDown
      OnContextPopup = PriceEditContextPopup
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
    object AmountEdit: TAdvMoneyEdit
      Left = 190
      Top = 464
      Width = 77
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
      Signed = True
      TabOrder = 8
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
    object PercentEdit: TAdvMoneyEdit
      Left = 372
      Top = 35
      Width = 62
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
      TabOrder = 11
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
    object OrgCombo: TsComboBox
      Left = 268
      Top = 35
      Width = 46
      Height = 21
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 10
      Visible = False
      OnChange = OrgComboChange
    end
    object IncomeTree: TVirtualStringTree
      Left = 8
      Top = 108
      Width = 426
      Height = 122
      EditDelay = 10
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = [fsBold]
      Header.Options = [hoColumnResize, hoVisible]
      Indent = 0
      TabOrder = 4
      TextMargin = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toExtendedFocus]
      OnChange = IncomeTreeChange
      OnCreateEditor = IncomeTreeCreateEditor
      OnEdited = IncomeTreeEdited
      OnEditing = IncomeTreeEditing
      OnGetText = IncomeTreeGetText
      OnNewText = IncomeTreeNewText
      Columns = <
        item
          Position = 0
          Width = 200
          WideText = #1057#1090#1072#1090#1100#1103
        end
        item
          Alignment = taRightJustify
          CaptionAlignment = taRightJustify
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable]
          Position = 1
          Width = 80
          WideText = #1062#1077#1085#1072
        end
        item
          Alignment = taRightJustify
          CaptionAlignment = taRightJustify
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable]
          Position = 2
          Width = 57
          WideText = #1050#1086#1083'-'#1074#1086
        end
        item
          Alignment = taRightJustify
          CaptionAlignment = taRightJustify
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coUseCaptionAlignment, coEditable]
          Position = 3
          Width = 80
          WideText = #1057#1090#1086#1080#1084#1086#1089#1090#1100
        end>
    end
    object IncomeLineAddButton: TsButton
      Left = 438
      Top = 112
      Width = 20
      Height = 20
      Caption = '+'
      TabOrder = 5
      OnClick = IncomeLineAddButtonClick
    end
    object IncomeLineDeleteButton: TsButton
      Left = 438
      Top = 135
      Width = 20
      Height = 20
      Caption = '-'
      TabOrder = 6
      OnClick = IncomeLineDeleteButtonClick
    end
    object ClientsCB: TsComboBox
      Left = 144
      Top = 8
      Width = 285
      Height = 21
      AutoDropDown = True
      BoundLabel.Caption = #1054#1090' '#1082#1086#1075#1086
      BoundLabel.Layout = sclTopLeft
      DropDownCount = 10
      ItemIndex = -1
      TabOrder = 0
      OnSelect = ClientsCBSelect
      OnChange = ClientsCBChange
    end
  end
end
