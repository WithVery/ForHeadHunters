object DebtingForm: TDebtingForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1077#1073#1077#1090#1086#1074#1072#1085#1080#1077
  ClientHeight = 310
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 322
    Height = 310
    Align = alClient
    TabOrder = 0
    DesignSize = (
      322
      310)
    object sLabel1: TsLabel
      Left = 16
      Top = 69
      Width = 137
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1076#1086#1075#1086#1074#1086#1088#1091':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ExplicitTop = 48
    end
    object sLabel2: TsLabel
      Left = 16
      Top = 101
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
      ExplicitTop = 80
    end
    object sLabel3: TsLabel
      Left = 16
      Top = 128
      Width = 64
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ExplicitTop = 107
    end
    object sLabel4: TsLabel
      Left = 16
      Top = 152
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
      ExplicitTop = 134
    end
    object sLabel5: TsLabel
      Left = 16
      Top = 42
      Width = 79
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ExplicitTop = 21
    end
    object OrgLabel: TsLabel
      Left = 16
      Top = 14
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
    object AmountEdit: TAdvMoneyEdit
      Left = 159
      Top = 98
      Width = 145
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
      Anchors = [akLeft, akBottom]
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Color = clWindow
      TabOrder = 3
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
    object CancelButton: TsButton
      Left = 189
      Top = 274
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 7
    end
    object DebCredCombo: TsComboBox
      Left = 159
      Top = 125
      Width = 145
      Height = 22
      Anchors = [akLeft, akBottom]
      SkinData.SkinSection = 'COMBOBOX'
      Style = csOwnerDrawFixed
      ItemIndex = -1
      TabOrder = 4
      OnChange = DebCredComboChange
    end
    object DescrMemo: TsMemo
      Left = 16
      Top = 171
      Width = 288
      Height = 89
      Anchors = [akLeft, akBottom]
      Lines.Strings = (
        'DescrMemo')
      TabOrder = 5
      OnKeyPress = DescrMemoKeyPress
      Text = 'DescrMemo'
    end
    object Dt: TsDateEdit
      Left = 159
      Top = 66
      Width = 86
      Height = 21
      Anchors = [akLeft, akBottom]
      AutoSize = False
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 2
      Text = '  .  .    '
      OnChange = DtChange
      OnExit = DtExit
    end
    object OKButton: TsButton
      Left = 51
      Top = 274
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1087#1080#1089#1072#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 6
      OnClick = OKButtonClick
    end
    object ShipDt: TsDateEdit
      Left = 159
      Top = 39
      Width = 86
      Height = 21
      Anchors = [akLeft, akBottom]
      AutoSize = False
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 1
      OnChange = ShipDtChange
      OnExit = ShipDtExit
      DefaultToday = True
    end
    object OrgCombo: TsComboBox
      Left = 92
      Top = 11
      Width = 212
      Height = 21
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 0
      OnChange = OrgComboChange
    end
  end
end
