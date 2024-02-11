object NewStatForm: TNewStatForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1072#1103' '#1089#1072#1090#1080#1089#1090#1080#1082#1072
  ClientHeight = 302
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 416
    Height = 302
    Align = alClient
    Caption = 'sPanel1'
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object Label1: TLabel
      Left = 8
      Top = 108
      Width = 53
      Height = 13
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 8
      Top = 62
      Width = 97
      Height = 13
      Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077':'
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
    object lblUSers: TsLabel
      Left = 215
      Top = 10
      Width = 85
      Height = 13
      Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object ButtonCancel: TButton
      Left = 333
      Top = 267
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 8
    end
    object ButtonOK: TButton
      Left = 240
      Top = 267
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Default = True
      TabOrder = 7
      OnClick = ButtonOKClick
    end
    object FullStatNameMemo: TsMemo
      Left = 8
      Top = 127
      Width = 400
      Height = 57
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
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
    object OrgCombo: TsComboBox
      Left = 8
      Top = 29
      Width = 193
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
      TabOrder = 0
      OnChange = OrgComboChange
    end
    object ShortStatNameEdit: TEdit
      Left = 8
      Top = 81
      Width = 400
      Height = 21
      TabOrder = 2
    end
    object UDCheckBox: TsCheckBox
      Left = 8
      Top = 270
      Width = 143
      Height = 20
      Caption = #1055#1077#1088#1077#1074#1105#1088#1085#1091#1090#1099#1081' '#1075#1088#1072#1092#1080#1082
      TabOrder = 6
      OnClick = UDCheckBoxClick
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
    object TopGroupBox: TsGroupBox
      Left = 215
      Top = 190
      Width = 193
      Height = 59
      Caption = #1042#1077#1088#1093#1085#1103#1103' '#1075#1088#1072#1085#1080#1094#1072
      TabOrder = 5
      SkinData.SkinSection = 'GROUPBOX'
      object MaxAutoCheckBox: TsCheckBox
        Left = 80
        Top = 24
        Width = 106
        Height = 20
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
        TabOrder = 1
        OnClick = MaxAutoCheckBoxClick
        SkinData.SkinSection = 'CHECKBOX'
        ImgChecked = 0
        ImgUnchecked = 0
      end
      object MaxYEdit: TsEdit
        Left = 16
        Top = 24
        Width = 49
        Height = 21
        Alignment = taRightJustify
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = MaxYEditChange
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
      end
    end
    object BottomGroupBox: TsGroupBox
      Left = 8
      Top = 190
      Width = 193
      Height = 59
      Caption = #1053#1080#1078#1085#1103#1103' '#1075#1088#1072#1085#1080#1094#1072
      TabOrder = 4
      SkinData.SkinSection = 'GROUPBOX'
      object MinAutoCheckBox: TsCheckBox
        Left = 80
        Top = 24
        Width = 106
        Height = 20
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
        TabOrder = 1
        OnClick = MinAutoCheckBoxClick
        SkinData.SkinSection = 'CHECKBOX'
        ImgChecked = 0
        ImgUnchecked = 0
      end
      object MinYEdit: TsEdit
        Left = 16
        Top = 24
        Width = 49
        Height = 21
        Alignment = taRightJustify
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = MinYEditChange
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
      end
    end
    object cmbUsers: TsComboBox
      Left = 215
      Top = 29
      Width = 193
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
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 16
      ItemIndex = -1
      ParentFont = False
      Sorted = True
      TabOrder = 1
      OnChange = cmbUsersChange
    end
  end
  object lc: TDKLanguageController
    Left = 200
    Top = 152
    LangData = {
      0B004E657753746174466F726D010100000001000000070043617074696F6E01
      1200000007007350616E656C31010200000002000000070043617074696F6E03
      0000001400536B696E446174612E536B696E53656374696F6E0006004C616265
      6C31010100000004000000070043617074696F6E0006004C6162656C32010100
      000005000000070043617074696F6E0008004F72674C6162656C010100000006
      000000070043617074696F6E0008006C626C5553657273010100000007000000
      070043617074696F6E000C00427574746F6E43616E63656C0101000000080000
      00070043617074696F6E000800427574746F6E4F4B0101000000090000000700
      43617074696F6E00100046756C6C537461744E616D654D656D6F01010000000A
      0000001400536B696E446174612E536B696E53656374696F6E0008004F726743
      6F6D626F01010000000B0000001400536B696E446174612E536B696E53656374
      696F6E00110053686F7274537461744E616D654564697400000A005544436865
      636B426F7801020000000C000000070043617074696F6E0D0000001400536B69
      6E446174612E536B696E53656374696F6E000B00546F7047726F7570426F7801
      020000000E000000070043617074696F6E0F0000001400536B696E446174612E
      536B696E53656374696F6E000F004D61784175746F436865636B426F78010200
      000010000000070043617074696F6E110000001400536B696E446174612E536B
      696E53656374696F6E0008004D61785945646974010100000012000000140053
      6B696E446174612E536B696E53656374696F6E000E00426F74746F6D47726F75
      70426F78010200000013000000070043617074696F6E140000001400536B696E
      446174612E536B696E53656374696F6E000F004D696E4175746F436865636B42
      6F78010200000015000000070043617074696F6E160000001400536B696E4461
      74612E536B696E53656374696F6E0008004D696E594564697401010000001700
      00001400536B696E446174612E536B696E53656374696F6E000800636D625573
      6572730101000000180000001400536B696E446174612E536B696E5365637469
      6F6E00}
  end
end
