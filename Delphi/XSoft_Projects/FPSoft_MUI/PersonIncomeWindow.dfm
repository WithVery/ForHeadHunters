object PersonIncomeForm: TPersonIncomeForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1073#1072#1083#1072#1085#1089#1072
  ClientHeight = 210
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 53
    Height = 13
    Caption = #1063#1080#1090#1072#1090#1077#1083#1100':'
  end
  object Label2: TLabel
    Left = 8
    Top = 35
    Width = 59
    Height = 13
    Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077':'
  end
  object Label3: TLabel
    Left = 8
    Top = 147
    Width = 35
    Height = 13
    Caption = #1057#1091#1084#1084#1072':'
  end
  object OtherEdit: TsEdit
    Left = 24
    Top = 117
    Width = 241
    Height = 21
    TabOrder = 2
  end
  object OtherRadioBtn: TsRadioButton
    Left = 8
    Top = 96
    Width = 59
    Height = 18
    Caption = #1044#1088#1091#1075#1086#1077
    TabOrder = 1
    OnClick = OtherRadioBtnClick
  end
  object PersonEdit: TsEdit
    Left = 67
    Top = 13
    Width = 254
    Height = 21
    Enabled = False
    TabOrder = 7
    Text = 'PersonEdit'
  end
  object SourceRadioBtn: TsRadioButton
    Left = 8
    Top = 54
    Width = 58
    Height = 18
    Caption = #1056#1072#1079#1076#1077#1083
    TabOrder = 8
    OnClick = SourceRadioBtnClick
  end
  object OkButton: TsButton
    Left = 67
    Top = 177
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = OkButtonClick
  end
  object CancelButton: TsButton
    Left = 177
    Top = 177
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object AmountEdit: TAdvMoneyEdit
    Left = 49
    Top = 144
    Width = 112
    Height = 21
    EditAlign = eaRight
    EditType = etMoney
    EmptyTextStyle = []
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
    Color = clWindow
    TabOrder = 3
    Text = '0'
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
  object SourcesCombo: TComboBox
    Left = 24
    Top = 69
    Width = 297
    Height = 21
    AutoDropDown = True
    Style = csDropDownList
    TabOrder = 0
  end
  object PrintCheckBox: TsCheckBox
    Left = 170
    Top = 147
    Width = 129
    Height = 17
    Caption = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100' '#1080#1085#1074#1086#1081#1089
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
