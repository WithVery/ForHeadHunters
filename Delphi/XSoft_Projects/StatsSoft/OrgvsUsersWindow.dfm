object OrgvsUsersForm: TOrgvsUsersForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
  ClientHeight = 393
  ClientWidth = 456
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
  PixelsPerInch = 96
  TextHeight = 13
  object pnl: TsPanel
    Left = 0
    Top = 0
    Width = 456
    Height = 393
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object lblUserAll: TsLabel
      Left = 10
      Top = 5
      Width = 57
      Height = 13
      Caption = #1044#1086#1089#1090#1091#1087#1085#1099#1077
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object lblOrg: TsLabel
      Left = 250
      Top = 5
      Width = 66
      Height = 13
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object lblUsersOrg: TsLabel
      Left = 250
      Top = 50
      Width = 73
      Height = 13
      Caption = #1042' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object vstUsersAll: TVirtualStringTree
      Left = 10
      Top = 24
      Width = 187
      Height = 313
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Indent = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnChange = vstUsersAllChange
      OnCompareNodes = vstUsersCompareNodes
      OnGetText = vstUsersGetText
      Columns = <>
    end
    object btnOrgAdd: TsButton
      Left = 205
      Top = 120
      Width = 38
      Height = 25
      Caption = '>>'
      TabOrder = 2
      OnClick = btnOrgAddClick
      SkinData.SkinSection = 'BUTTON'
    end
    object btnOrgRemove: TsButton
      Left = 205
      Top = 184
      Width = 38
      Height = 25
      Caption = '<<'
      TabOrder = 3
      OnClick = btnOrgRemoveClick
      SkinData.SkinSection = 'BUTTON'
    end
    object cmbOrgs: TsComboBox
      Left = 250
      Top = 24
      Width = 187
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
      Color = clWhite
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 16
      ItemIndex = -1
      ParentFont = False
      TabOrder = 0
      TabStop = False
    end
    object vstUsersOrg: TVirtualStringTree
      Left = 250
      Top = 69
      Width = 187
      Height = 268
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Indent = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnChange = vstUsersOrgChange
      OnCompareNodes = vstUsersCompareNodes
      OnGetText = vstUsersGetText
      Columns = <>
    end
    object btnOk: TsButton
      Left = 138
      Top = 360
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = btnOkClick
      SkinData.SkinSection = 'BUTTON'
    end
    object btnCancel: TsButton
      Left = 241
      Top = 360
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 6
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object lc: TDKLanguageController
    Left = 216
    Top = 192
    LangData = {
      0E004F726776735573657273466F726D01010000000100000007004361707469
      6F6E010B0000000300706E6C0101000000020000001400536B696E446174612E
      536B696E53656374696F6E000A006C626C55736572416C6C0101000000030000
      00070043617074696F6E0006006C626C4F726701010000000400000007004361
      7074696F6E000B006C626C55736572734F726701010000000500000007004361
      7074696F6E000B007673745573657273416C6C0000090062746E4F7267416464
      0101000000060000001400536B696E446174612E536B696E53656374696F6E00
      0C0062746E4F726752656D6F76650101000000070000001400536B696E446174
      612E536B696E53656374696F6E000700636D624F726773010100000008000000
      1400536B696E446174612E536B696E53656374696F6E000B0076737455736572
      734F72670000050062746E4F6B010200000009000000070043617074696F6E0A
      0000001400536B696E446174612E536B696E53656374696F6E00090062746E43
      616E63656C01020000000B000000070043617074696F6E0C0000001400536B69
      6E446174612E536B696E53656374696F6E00}
  end
end
