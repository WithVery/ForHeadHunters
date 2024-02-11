object POsExportToExcelForm: TPOsExportToExcelForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1079#1072#1103#1074#1086#1082
  ClientHeight = 332
  ClientWidth = 230
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
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 230
    Height = 332
    Align = alClient
    TabOrder = 0
    object gbDates: TsGroupBox
      Left = 11
      Top = 55
      Width = 208
      Height = 98
      Caption = #1044#1072#1090#1099
      TabOrder = 0
      object lblVal2: TsLabel
        Left = 8
        Top = 56
        Width = 12
        Height = 13
        Caption = #1087#1086
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object slblVal1: TsLabel
        Left = 10
        Top = 30
        Width = 5
        Height = 13
        Caption = #1089
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object teVal2: TsTimePicker
        Left = 120
        Top = 54
        Width = 79
        Height = 21
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '00:00:00'
      end
      object deVal2: TsDateEdit
        Left = 24
        Top = 54
        Width = 88
        Height = 21
        AutoSize = False
        Color = clWhite
        EditMask = '!99/99/9999;1; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 2
        Text = '  .  .    '
      end
      object teVal1: TsTimePicker
        Left = 120
        Top = 27
        Width = 79
        Height = 21
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = '00:00:00'
      end
      object deVal1: TsDateEdit
        Left = 24
        Top = 27
        Width = 88
        Height = 21
        AutoSize = False
        Color = clWhite
        EditMask = '!99/99/9999;1; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 0
        Text = '  .  .    '
      end
    end
    object gbPOs: TRadioGroup
      Left = 11
      Top = 159
      Width = 208
      Height = 98
      Caption = #1047#1072#1103#1074#1082#1080
      Items.Strings = (
        #1042#1099#1089#1090#1072#1074#1083#1077#1085#1085#1099#1077
        #1054#1090#1082#1083#1086#1085#1105#1085#1085#1099#1077
        #1054#1076#1086#1073#1088#1077#1085#1085#1099#1077
        #1054#1087#1083#1072#1095#1077#1085#1085#1099#1077)
      TabOrder = 1
    end
    object btnExport: TButton
      Left = 21
      Top = 296
      Width = 75
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Default = True
      ModalResult = 1
      TabOrder = 3
      OnClick = btnExportClick
    end
    object btnCancel: TButton
      Left = 128
      Top = 296
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 4
    end
    object cbOpenFileAfterExport: TCheckBox
      Left = 11
      Top = 263
      Width = 208
      Height = 17
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' '#1087#1086#1089#1083#1077' '#1101#1082#1089#1087#1086#1088#1090#1072
      TabOrder = 2
    end
    object gbOrg: TGroupBox
      Left = 11
      Top = 7
      Width = 208
      Height = 45
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
      TabOrder = 5
      object OrgCombo: TsComboBox
        Left = 10
        Top = 16
        Width = 191
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        SkinData.SkinSection = 'COMBOBOX'
        Color = clWhite
        Style = csDropDownList
        ItemIndex = -1
        TabOrder = 0
        OnChange = OrgComboChange
      end
    end
  end
  object sd: TSaveDialog
    Filter = #1060#1072#1081#1083#1099' Excel|*.xls'
    Left = 104
    Top = 136
  end
end
