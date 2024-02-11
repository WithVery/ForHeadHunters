object OrgDataForm: TOrgDataForm
  Left = 0
  Top = 0
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086#1073' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
  ClientHeight = 185
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object OrgLabel: TsLabel
    Left = 8
    Top = 21
    Width = 91
    Height = 13
    Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object sLabel1: TsLabel
    Left = 8
    Top = 48
    Width = 124
    Height = 13
    Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object sLabel2: TsLabel
    Left = 8
    Top = 75
    Width = 35
    Height = 13
    Caption = #1040#1076#1088#1077#1089':'
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object sLabel3: TsLabel
    Left = 8
    Top = 102
    Width = 48
    Height = 13
    Caption = #1058#1077#1083#1077#1092#1086#1085':'
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object FullNameEdit: TsEdit
    Left = 105
    Top = 18
    Width = 423
    Height = 21
    TabOrder = 0
  end
  object ShortNameEdit: TsEdit
    Left = 138
    Top = 45
    Width = 390
    Height = 21
    TabOrder = 1
  end
  object AddressEdit: TsEdit
    Left = 49
    Top = 72
    Width = 479
    Height = 21
    TabOrder = 2
  end
  object PhoneEdit: TsEdit
    Left = 62
    Top = 99
    Width = 466
    Height = 21
    TabOrder = 3
  end
  object OkButton: TsButton
    Left = 139
    Top = 142
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object CancelButton: TsButton
    Left = 249
    Top = 142
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
  end
end
