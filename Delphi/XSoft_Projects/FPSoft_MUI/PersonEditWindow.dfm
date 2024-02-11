object PersonEditForm: TPersonEditForm
  Left = 0
  Top = 0
  Anchors = []
  BorderStyle = bsDialog
  Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  ClientHeight = 312
  ClientWidth = 368
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
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 368
    Height = 312
    Align = alClient
    AutoSize = True
    UseDockManager = False
    ShowCaption = False
    StyleElements = []
    TabOrder = 0
    DesignSize = (
      368
      312)
    object AddressLabel: TLabel
      Left = 10
      Top = 135
      Width = 35
      Height = 13
      Caption = #1040#1076#1088#1077#1089':'
    end
    object CountryLabel: TLabel
      Left = 10
      Top = 87
      Width = 41
      Height = 13
      Caption = #1057#1090#1088#1072#1085#1072':'
    end
    object EMailLabel: TLabel
      Left = 10
      Top = 255
      Width = 54
      Height = 13
      Caption = #1069#1083'. '#1087#1086#1095#1090#1072':'
    end
    object FamilyNameLabel: TLabel
      Left = 10
      Top = 15
      Width = 48
      Height = 13
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
    end
    object FirstNameLabel: TLabel
      Left = 10
      Top = 39
      Width = 23
      Height = 13
      Caption = #1048#1084#1103':'
    end
    object MiddleNameLabel: TLabel
      Left = 10
      Top = 63
      Width = 53
      Height = 13
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
    end
    object PassportNumberLabel: TLabel
      Left = 10
      Top = 183
      Width = 87
      Height = 13
      Caption = #1055#1072#1089#1087#1086#1088#1090' ('#1085#1086#1084#1077#1088'):'
    end
    object PassportSeriesLabel: TLabel
      Left = 10
      Top = 159
      Width = 86
      Height = 13
      Caption = #1055#1072#1089#1087#1086#1088#1090' ('#1089#1077#1088#1080#1103'):'
    end
    object PhoneHomeLabel: TLabel
      Left = 10
      Top = 207
      Width = 82
      Height = 13
      Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1076#1086#1084'.):'
    end
    object PhoneMobileLabel: TLabel
      Left = 10
      Top = 231
      Width = 81
      Height = 13
      Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1084#1086#1073'.):'
    end
    object PostalIndexLabel: TLabel
      Left = 10
      Top = 111
      Width = 94
      Height = 13
      Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1080#1085#1076#1077#1082#1089':'
    end
    object AddressEdit: TsEdit
      Left = 110
      Top = 132
      Width = 241
      Height = 21
      TabOrder = 5
      Text = 'AddressEdit'
    end
    object CancelButton: TsButton
      Left = 212
      Top = 280
      Width = 75
      Height = 25
      Anchors = [akLeft, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 12
      OnClick = CancelButtonClick
    end
    object CountryEdit: TsEdit
      Left = 110
      Top = 84
      Width = 241
      Height = 21
      TabOrder = 3
      Text = 'CountryEdit'
    end
    object EMailEdit: TsEdit
      Left = 110
      Top = 252
      Width = 241
      Height = 21
      TabOrder = 10
      Text = 'EMailEdit'
    end
    object FamilyNameEdit: TsEdit
      Left = 110
      Top = 12
      Width = 241
      Height = 21
      TabOrder = 0
      Text = 'FamilyNameEdit'
    end
    object FirstNameEdit: TsEdit
      Left = 110
      Top = 36
      Width = 241
      Height = 21
      TabOrder = 1
      Text = 'FirstNameEdit'
    end
    object MiddleNameEdit: TsEdit
      Left = 110
      Top = 60
      Width = 241
      Height = 21
      TabOrder = 2
      Text = 'MiddleNameEdit'
    end
    object OKButton: TsButton
      Left = 84
      Top = 280
      Width = 75
      Height = 25
      Anchors = [akLeft, akRight]
      Caption = #1047#1072#1087#1080#1089#1072#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 11
      OnClick = OKButtonClick
    end
    object PassportNumberEdit: TsEdit
      Left = 110
      Top = 180
      Width = 65
      Height = 21
      TabOrder = 7
      Text = 'PassportNumberEdit'
    end
    object PassportSeriesEdit: TsEdit
      Left = 110
      Top = 156
      Width = 65
      Height = 21
      TabOrder = 6
      Text = 'PassportSeriesEdit'
    end
    object PhoneHomeEdit: TsEdit
      Left = 110
      Top = 204
      Width = 121
      Height = 21
      TabOrder = 8
      Text = 'PhoneHomeEdit'
    end
    object PhoneMobileEdit: TsEdit
      Left = 110
      Top = 228
      Width = 121
      Height = 21
      TabOrder = 9
      Text = 'PhoneMobileEdit'
    end
    object PostalIndexEdit: TsEdit
      Left = 110
      Top = 108
      Width = 241
      Height = 21
      TabOrder = 4
      Text = 'PostalIndexEdit'
    end
  end
end
