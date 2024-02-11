object AssetTransferForm: TAssetTransferForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1077#1074#1086#1076' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074' ('#1092#1086#1085#1076#1099')'
  ClientHeight = 264
  ClientWidth = 507
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
    Width = 507
    Height = 264
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    DesignSize = (
      507
      264)
    object sLabel2: TsLabel
      Left = 264
      Top = 10
      Width = 35
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1057#1091#1084#1084#1072':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel3: TsLabel
      Left = 8
      Top = 38
      Width = 43
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1054#1090#1082#1091#1076#1072':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel4: TsLabel
      Left = 264
      Top = 38
      Width = 30
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1050#1091#1076#1072':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel5: TsLabel
      Left = 8
      Top = 92
      Width = 122
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080' '#1086#1087#1077#1088#1072#1094#1080#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ExplicitTop = 65
    end
    object OrgLabel: TsLabel
      Left = 16
      Top = 10
      Width = 33
      Height = 13
      Caption = #1054#1088#1075'-'#1103':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object FromAvailLabel: TsLabel
      Left = 15
      Top = 66
      Width = 53
      Height = 13
      Caption = #1044#1086#1089#1090#1091#1087#1085#1086':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object AmountEdit: TAdvMoneyEdit
      Left = 300
      Top = 7
      Width = 197
      Height = 21
      EditType = etMoney
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Separator = ';'
      Anchors = [akLeft, akBottom]
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Color = clWindow
      Enabled = True
      TabOrder = 0
      Text = '0,00'
      Visible = True
      OnChange = AmountEditChange
      OnExit = AmountEditExit
      Version = '1.1.1.1'
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
    object CancelButton: TsButton
      Left = 315
      Top = 230
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 5
      OnClick = CancelButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object DescrMemo: TsMemo
      Left = 8
      Top = 115
      Width = 489
      Height = 102
      TabStop = False
      Anchors = [akLeft, akBottom]
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      OnChange = DescrMemoChange
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'Tahoma'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
    object FromCombo: TsComboBox
      Left = 57
      Top = 35
      Width = 197
      Height = 22
      Anchors = [akLeft, akBottom]
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
      ItemHeight = 16
      ItemIndex = -1
      ParentFont = False
      TabOrder = 1
      OnChange = FromComboChange
    end
    object OKButton: TsButton
      Left = 90
      Top = 230
      Width = 145
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
      TabOrder = 4
      OnClick = OKButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object ToCombo: TsComboBox
      Left = 300
      Top = 35
      Width = 197
      Height = 22
      Anchors = [akLeft, akBottom]
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
      ItemHeight = 16
      ItemIndex = -1
      ParentFont = False
      TabOrder = 2
      OnChange = ToComboChange
    end
    object OrgCombo: TsComboBox
      Left = 57
      Top = 7
      Width = 197
      Height = 22
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
      ItemHeight = 16
      ItemIndex = -1
      ParentFont = False
      TabOrder = 6
      OnChange = OrgComboChange
    end
    object FromAvailMoneyEdit: TAdvMoneyEdit
      Left = 74
      Top = 63
      Width = 151
      Height = 21
      Hint = #1047#1072' '#1074#1099#1095#1077#1090#1086#1084' '#1086#1076#1086#1073#1088#1077#1085#1085#1099#1093', '#1085#1086' '#1085#1077' '#1086#1087#1083#1072#1095#1077#1085#1085#1099#1093' '#1079#1072#1103#1074#1086#1082
      EditType = etMoney
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Separator = ';'
      Anchors = [akLeft, akBottom]
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Color = clWindow
      Enabled = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 7
      Text = '0,00'
      Visible = True
      OnChange = AmountEditChange
      OnExit = AmountEditExit
      Version = '1.1.1.1'
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
  end
end
