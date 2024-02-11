object WEEditForm: TWEEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1077#1088#1080#1086#1076#1072
  ClientHeight = 182
  ClientWidth = 573
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
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnl: TsPanel
    Left = 0
    Top = 0
    Width = 573
    Height = 182
    Align = alClient
    TabOrder = 0
    object lblNextWE: TsLabel
      Left = 294
      Top = 9
      Width = 139
      Height = 13
      Caption = #1057#1083#1077#1076#1091#1102#1097#1080#1081' '#1082#1086#1085#1077#1094' '#1085#1077#1076#1077#1083#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object lblOrgList: TsLabel
      Left = 9
      Top = 9
      Width = 70
      Height = 13
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object lblWEList: TsLabel
      Left = 161
      Top = 9
      Width = 64
      Height = 13
      Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object btnCancel: TsButton
      Left = 488
      Top = 59
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Default = True
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TsButton
      Left = 488
      Top = 28
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
      TabOrder = 1
    end
    object mc: TsMonthCalendar
      Left = 294
      Top = 28
      BevelWidth = 1
      Caption = ' '
      Ctl3D = True
      Enabled = False
      ParentCtl3D = False
      TabOrder = 2
      ShowSelectAlways = False
      ShowYearBtns = False
      ShowMonthBtns = False
    end
    object vstOrgs: TVirtualStringTree
      Left = 9
      Top = 28
      Width = 137
      Height = 139
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Height = 17
      Header.MainColumn = -1
      Indent = 0
      TabOrder = 3
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnChange = vstOrgsChange
      OnGetText = vstOrgsGetText
      Columns = <>
    end
    object vstWED: TVirtualStringTree
      Left = 161
      Top = 28
      Width = 121
      Height = 139
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Height = 17
      Header.MainColumn = -1
      Indent = 0
      TabOrder = 4
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnChange = vstWEDChange
      OnGetText = vstWEDGetText
      Columns = <>
    end
  end
  object lc: TDKLanguageController
    Left = 288
    Top = 88
    LangData = {
      0A00574545646974466F726D010100000001000000070043617074696F6E0109
      0000000300706E6C00000A006C626C4F72674C69737401010000000300000007
      0043617074696F6E0009006C626C57454C697374010100000004000000070043
      617074696F6E0009006C626C4E65787457450101000000050000000700436170
      74696F6E0007007673744F7267730000090062746E43616E63656C0101000000
      06000000070043617074696F6E00050062746E4F4B0101000000080000000700
      43617074696F6E0002006D63000006007673745745440000}
  end
end
