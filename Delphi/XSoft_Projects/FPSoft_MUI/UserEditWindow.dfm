object UserEditForm: TUserEditForm
  Left = 0
  Top = 0
  ParentCustomHint = False
  BorderStyle = bsDialog
  Caption = 'UserEditForm'
  ClientHeight = 238
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 428
    Height = 238
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object FamilyNameLabel: TsLabel
      Left = 16
      Top = 38
      Width = 48
      Height = 13
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object FirstNameLabel: TsLabel
      Left = 16
      Top = 65
      Width = 23
      Height = 13
      Caption = #1048#1084#1103':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object MiddleNameLabel: TsLabel
      Left = 16
      Top = 92
      Width = 53
      Height = 13
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PostLabel: TsLabel
      Left = 16
      Top = 119
      Width = 61
      Height = 13
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PwdConfLabel: TsLabel
      Left = 16
      Top = 173
      Width = 85
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100' '#1077#1097#1105' '#1088#1072#1079':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PwdLabel: TsLabel
      Left = 16
      Top = 146
      Width = 41
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object LoginLabel: TsLabel
      Left = 16
      Top = 11
      Width = 34
      Height = 13
      Caption = #1051#1086#1075#1080#1085':'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object LoginOKImg: TImage
      Left = 406
      Top = 10
      Width = 16
      Height = 16
      Hint = #1051#1086#1075#1080#1085' '#1085#1077' '#1079#1072#1085#1103#1090
      ParentCustomHint = False
      ParentShowHint = False
      Picture.Data = {
        0B54504E474772617068696336040000424D3604000000000000360000002800
        0000100000001000000001002000000000000004000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000010000
        0001000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000100000008000000180000
        001D000000100000000300000000000000000000000000000000000000000000
        000000000000000000000000000000000001000000090000002E000000650000
        00750000004B0000001900000003000000000000000000000000000000000000
        000000000000000000000000000100000009001E0038006C00BF037F05E9002B
        00A2000000900000005000000019000000030000000000000000000000000000
        000000000000000000000000000900200038007C00CB13AC27FF15B32BFF0692
        0EFB002C00A40000009000000050000000180000000300000000000000000000
        0000000000000000000700220034008000C816AE2EFF17B231FF14AD2AFF13B1
        29FF06900BFB002B00A4000000900000004D0000001700000003000000000000
        0000000000000031001F008700C619B233FF1CB63AFF18B334FF34BC4DFF17B0
        30FF13B02AFF068F0BFA002700A30000008E0000004D00000017000000030000
        0000000000000B9B15B51FB73EFF20BA42FF1FB840FF11A824FF018901EA62C7
        71FF19B232FF13B12BFF068F0BF9002500A30000008E0000004B000000160000
        00030000000028B238E942C865FF1FBB46FF15B32CFF007E00A9002800300090
        00C861C871FF19B131FF13B22CFF068D0BF8002200A30000008D0000004A0000
        0015000000020EB5236643C456FC36BC4EFF009707A50000001F0000000600A0
        0011009100CC63CA72FF17B131FF14B12CFF068D09F7002200A20000008C0000
        00450000000E0000000010CE232F0CB21E51001B000B00000003000000000000
        0000009F0013009201D063CA72FF17B131FF14B32DFF068C09F6001E00A10000
        00760000001E0000000000000000000000000000000000000000000000000000
        00000000000000A50016009300D464CB75FF15B131FF16B330FF028004E90000
        00700000001C0000000000000000000000000000000000000000000000000000
        0000000000000000000000A40018019603D866CD78FF2ABC46FF007E02D60000
        00390000000B0000000000000000000000000000000000000000000000000000
        00000000000000000000000000000095001C009301CB049006D2005700410000
        000C000000010000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000001000000010000
        000000000000}
      ShowHint = True
      Transparent = True
      Visible = False
    end
    object LoginNotOKImg: TImage
      Left = 412
      Top = 16
      Width = 16
      Height = 16
      Hint = #1051#1086#1075#1080#1085' '#1079#1072#1085#1103#1090
      ParentCustomHint = False
      ParentShowHint = False
      Picture.Data = {
        0B54504E474772617068696336040000424D3604000000000000360000002800
        0000100000001000000001002000000000000004000000000000000000000000
        00000000000000000001000000090000001A0000001F00000013000000050000
        0000000000000000000000000004000000110000001200000009000000010000
        000000000000000000070000002C000000690000007900000058000000290000
        000C0000000100000006000000220000004F000000570000003A0000001A0000
        000500000000000054250205A1CF03099FE300004EAA0000039D000000760000
        003B00000017000000260000749B00005BAA0000169B0000008E0000005C0000
        001E0000000400009B921844F6FF194DF8FF1031D2FF010290D6000011A20000
        00850000005A000080A60928D7FF092ED7FF0313B3FF000060B2000000950000
        004A0000000F0103B0D12451F9FF1F52FFFF1D4FFFFF1744E8FF040AA6ED0000
        1DA300006CB20D2EDDFF1142F9FF0D3DF5FF0B3BF0FF041ABCFF0000399F0000
        00610000001600009D471832DBFF285BFFFF2456FFFF2253FFFF1B4BF1FF050D
        AFFB0F30DDFF164AFEFF1344F9FF1041F6FF0E3EF6FF0A3CF0FF000085C70000
        003F0000000C0000B9521F37DDFF3A6FFFFF2C5EFFFF295AFFFF2657FFFF2052
        FCFF1C4FFFFF194AFDFF1646FAFF1445FAFF0F3DF2FF020AA9E8000061610000
        001000000002000000010000C467121DC7F03D6AFBFF3567FFFF2C5DFFFF2859
        FFFF2253FFFF1D4EFFFF1A4DFFFF123DEDFF000296D1000038460000000C0000
        00010000000000000000000000000000C51D0000B0BC2E4EE7FF3668FFFF2E5E
        FFFF2859FFFF2254FFFF163DEAFF000082C90000068500000032000000070000
        0000000000000000000000000000000000020000915C253FDFFF3B6DFFFF3464
        FFFF2E5EFFFF2759FFFF1B46EAFF000191D5000003A0000000620000001C0000
        0003000000000000000000000000000000090203B9C54B7CFFFF4170FFFF3B6B
        FFFF396CFFFF2D5EFFFF2558FFFF1336D7FF000069B300000094000000490000
        00100000000100000000000000000000993A263CDBFE5080FFFF4575FFFF3662
        FAFF0D14C2FE3C6DFFFF2A5BFFFF2053FDFF0B1DC3FD00002BA2000000800000
        00300000000700000000000000000000B991527CFAFF5081FFFF4B7DFFFF0A12
        BEEB0000546F0E15C4E9386AFFFF2456FFFF1A4AF2FF0206A3E50000079E0000
        005E000000150000000000000000131CDBE06A9CFFFF5788FFFF2B46E7FF0000
        628A000000240000B7370F1BCAF23065FFFF1F51FFFF1439DDFF000078B30000
        00600000001700000000000000000000DB923A52E4FE5782FBFF0101BBC70000
        00330000000B000000000000C9481426D6FA265AFFFF0F2EE3FF0103ADD10000
        0022000000070000000000000000000000000000C83E0000BBA500009B3C0000
        00090000000100000000000000000000C0640001B4BD000093540000100F0000
        000300000000}
      ShowHint = True
      Transparent = True
      Visible = False
    end
    object FamilyNameEdit: TsEdit
      Left = 128
      Top = 35
      Width = 273
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = DataChanged
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
    object FirstNameEdit: TsEdit
      Left = 128
      Top = 62
      Width = 273
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnChange = DataChanged
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
    object LoginEdit: TsEdit
      Left = 128
      Top = 8
      Width = 273
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = DataChanged
      OnExit = LoginEditExit
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
    object MiddleNameEdit: TsEdit
      Left = 128
      Top = 89
      Width = 273
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnChange = DataChanged
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
    object PostCombo: TsComboBox
      Left = 128
      Top = 116
      Width = 273
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
      TabOrder = 4
      OnSelect = DataChanged
      OnChange = DataChanged
    end
    object PwdConfEdit: TsEdit
      Left = 128
      Top = 170
      Width = 273
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 6
      OnChange = DataChanged
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
    object PwdEdit: TsEdit
      Left = 128
      Top = 143
      Width = 273
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 5
      OnChange = DataChanged
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
    object SaveButton: TsButton
      Left = 16
      Top = 200
      Width = 161
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 7
      OnClick = SaveButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object CancelButton: TsButton
      Left = 288
      Top = 200
      Width = 113
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 8
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object lc: TDKLanguageController
    Left = 200
    Top = 120
    LangData = {
      0C005573657245646974466F726D010100000001000000070043617074696F6E
      011300000007007350616E656C310101000000020000001400536B696E446174
      612E536B696E53656374696F6E000F0046616D696C794E616D654C6162656C01
      0100000003000000070043617074696F6E000E0046697273744E616D654C6162
      656C010100000004000000070043617074696F6E000F004D6964646C654E616D
      654C6162656C010100000005000000070043617074696F6E000900506F73744C
      6162656C010100000006000000070043617074696F6E000C00507764436F6E66
      4C6162656C010100000007000000070043617074696F6E0008005077644C6162
      656C010100000008000000070043617074696F6E000A004C6F67696E4C616265
      6C010100000009000000070043617074696F6E000A004C6F67696E4F4B496D67
      01010000000A000000040048696E74000D004C6F67696E4E6F744F4B496D6701
      010000000B000000040048696E74000E0046616D696C794E616D654564697401
      010000000C0000001400536B696E446174612E536B696E53656374696F6E000D
      0046697273744E616D654564697401010000000D0000001400536B696E446174
      612E536B696E53656374696F6E0009004C6F67696E4564697401010000000E00
      00001400536B696E446174612E536B696E53656374696F6E000E004D6964646C
      654E616D654564697401010000000F0000001400536B696E446174612E536B69
      6E53656374696F6E000900506F7374436F6D626F010100000010000000140053
      6B696E446174612E536B696E53656374696F6E000B00507764436F6E66456469
      740101000000110000001400536B696E446174612E536B696E53656374696F6E
      000700507764456469740101000000120000001400536B696E446174612E536B
      696E53656374696F6E000A0053617665427574746F6E01020000001300000007
      0043617074696F6E140000001400536B696E446174612E536B696E5365637469
      6F6E000C0043616E63656C427574746F6E010200000015000000070043617074
      696F6E160000001400536B696E446174612E536B696E53656374696F6E00}
  end
end
