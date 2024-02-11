object StatGroupForm: TStatGroupForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082
  ClientHeight = 286
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 428
    Height = 286
    Align = alClient
    Caption = 'sPanel1'
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object Label1: TLabel
      Left = 8
      Top = 34
      Width = 52
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 8
      Top = 82
      Width = 53
      Height = 13
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
    end
    object OrgLabel: TsLabel
      Left = 8
      Top = 10
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
      Left = 232
      Top = 253
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 3
      SkinData.SkinSection = 'BUTTON'
    end
    object DescrEdit: TEdit
      Left = 8
      Top = 53
      Width = 412
      Height = 21
      TabOrder = 0
      Text = 'DescrEdit'
    end
    object FullDescrMemo: TMemo
      Left = 8
      Top = 101
      Width = 412
      Height = 142
      Lines.Strings = (
        'FullDescrMemo')
      TabOrder = 1
    end
    object OKButton: TsButton
      Left = 104
      Top = 253
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 2
      SkinData.SkinSection = 'BUTTON'
    end
    object OrgCombo: TsComboBox
      Left = 96
      Top = 8
      Width = 324
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
      TabOrder = 4
    end
  end
  object lc: TDKLanguageController
    Left = 200
    Top = 144
    LangData = {
      0D005374617447726F7570466F726D010100000001000000070043617074696F
      6E010900000007007350616E656C31010200000002000000070043617074696F
      6E030000001400536B696E446174612E536B696E53656374696F6E0006004C61
      62656C31010100000004000000070043617074696F6E0006004C6162656C3201
      0100000005000000070043617074696F6E0008004F72674C6162656C01010000
      0006000000070043617074696F6E000C0043616E63656C427574746F6E010200
      000007000000070043617074696F6E080000001400536B696E446174612E536B
      696E53656374696F6E0009004465736372456469740101000000090000000400
      54657874000D0046756C6C44657363724D656D6F01010000000A00000005004C
      696E65730008004F4B427574746F6E01020000000B000000070043617074696F
      6E0C0000001400536B696E446174612E536B696E53656374696F6E0008004F72
      67436F6D626F01010000000D0000001400536B696E446174612E536B696E5365
      6374696F6E00}
  end
end
