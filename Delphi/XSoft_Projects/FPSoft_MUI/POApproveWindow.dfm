object POApproveForm: TPOApproveForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1072#1089#1089#1084#1086#1090#1088#1077#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
  ClientHeight = 503
  ClientWidth = 698
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TmpImage: TImage
    Left = 304
    Top = 216
    Width = 105
    Height = 105
    Picture.Data = {
      0A544A504547496D61676578030000FFD8FFE000104A46494600010101006000
      600000FFE100FE45786966000049492A00080000000500120103000100000001
      00523A310102001C0000004A0000003201020014000000660000001302030001
      00000001002C2069870400010000007A00000000000000414344205379737465
      6D73204469676974616C20496D6167696E6700323030363A31313A3137203131
      3A32383A30320005000090070004000000303232308692020039000000BC0000
      0090920200040000003333340002A0040001000000F801000003A00400010000
      00580200000000000043524541544F523A2067642D6A7065672076312E302028
      7573696E6720494A47204A50454720763632292C207175616C697479203D2038
      3500BBFFDB004300080606070605080707070909080A0C140D0C0B0B0C191213
      0F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F2739
      3D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232
      3232323232323232323232323232323232323232323232323232323232323232
      32323232323232323232323232FFC00011080002000203012200021101031101
      FFC4001F0000010501010101010100000000000000000102030405060708090A
      0BFFC400B5100002010303020403050504040000017D01020300041105122131
      410613516107227114328191A1082342B1C11552D1F02433627282090A161718
      191A25262728292A3435363738393A434445464748494A535455565758595A63
      6465666768696A737475767778797A838485868788898A92939495969798999A
      A2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6
      D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F01000301
      01010101010101010000000000000102030405060708090A0BFFC400B5110002
      0102040403040705040400010277000102031104052131061241510761711322
      328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728
      292A35363738393A434445464748494A535455565758595A636465666768696A
      737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7
      A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3
      E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F1AE
      D4514551A1FFD9}
    Visible = False
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 698
    Height = 503
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object sLabel1: TsLabel
      Left = 8
      Top = 16
      Width = 52
      Height = 13
      Caption = #1047#1072#1103#1074#1082#1072' '#8470
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel2: TsLabel
      Left = 119
      Top = 16
      Width = 44
      Height = 13
      Caption = #1085#1072' '#1089#1091#1084#1084#1091
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel3: TsLabel
      Left = 275
      Top = 16
      Width = 24
      Height = 13
      Caption = #1058#1077#1084#1072
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel4: TsLabel
      Left = 256
      Top = 46
      Width = 75
      Height = 13
      Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object lblFiles: TsLabel
      Left = 568
      Top = 46
      Width = 67
      Height = 13
      Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1103':'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PONumEdit: TsEdit
      Left = 66
      Top = 13
      Width = 47
      Height = 21
      Alignment = taRightJustify
      Color = clWhite
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
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
    object POSumEdit: TsEdit
      Left = 169
      Top = 13
      Width = 95
      Height = 21
      Alignment = taRightJustify
      Color = clWhite
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
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
    object sGroupBox1: TsGroupBox
      Left = 8
      Top = 367
      Width = 673
      Height = 126
      Caption = #1054#1076#1086#1073#1088#1077#1085#1080#1077'/'#1088#1072#1089#1089#1084#1086#1090#1088#1077#1085#1080#1077' '#1079#1072#1103#1074#1082#1080' '#1074#1085#1077' '#1060#1055
      TabOrder = 2
      SkinData.SkinSection = 'GROUPBOX'
      object lblSource: TsLabel
        Left = 115
        Top = 26
        Width = 48
        Height = 13
        Caption = #1048#1089#1090#1086#1095#1085#1080#1082
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object lblApprovedSum: TsLabel
        Left = 129
        Top = 58
        Width = 31
        Height = 13
        Caption = #1057#1091#1084#1084#1072
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object lblNote: TsLabel
        Left = 391
        Top = 10
        Width = 54
        Height = 13
        Caption = #1055#1086#1103#1089#1085#1077#1085#1080#1077
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object SourceCombo: TsComboBox
        Left = 166
        Top = 24
        Width = 217
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
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 16
        ItemIndex = -1
        ParentFont = False
        TabOrder = 2
        OnChange = SourceComboChange
      end
      object NoteMemo: TsMemo
        Left = 389
        Top = 25
        Width = 273
        Height = 85
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
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
      object SubmitButton: TsButton
        Left = 13
        Top = 87
        Width = 112
        Height = 25
        Caption = #1059#1090#1074#1077#1088#1076#1080#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = SubmitButtonClick
        SkinData.SkinSection = 'BUTTON'
      end
      object CancelButton: TsButton
        Left = 141
        Top = 87
        Width = 112
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 7
        SkinData.SkinSection = 'BUTTON'
      end
      object ApproveRadioButton: TsRadioButton
        Left = 9
        Top = 24
        Width = 79
        Height = 20
        Caption = #1054#1076#1086#1073#1088#1080#1090#1100
        TabOrder = 0
        OnClick = ApproveRadioButtonClick
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object RejectRadioButton: TsRadioButton
        Left = 9
        Top = 54
        Width = 84
        Height = 20
        Caption = #1054#1090#1082#1083#1086#1085#1080#1090#1100
        TabOrder = 1
        OnClick = RejectRadioButtonClick
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object ApprovedSumEdit: TAdvMoneyEdit
        Left = 166
        Top = 53
        Width = 132
        Height = 21
        EditType = etMoney
        Precision = 2
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Separator = ';'
        BiDiMode = bdRightToLeft
        ParentBiDiMode = False
        Color = clWindow
        Enabled = False
        TabOrder = 3
        Text = '0,00'
        Visible = True
        Version = '1.1.1.1'
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
      object PrintButton: TsButton
        Left = 270
        Top = 87
        Width = 112
        Height = 25
        Caption = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        Visible = False
        OnClick = PrintButtonClick
        SkinData.SkinSection = 'BUTTON'
      end
      object CashCB: TsCheckBox
        Left = 304
        Top = 54
        Width = 79
        Height = 20
        Caption = #1053#1072#1083#1080#1095#1085#1099#1077
        TabOrder = 4
        OnClick = CashCBClick
        SkinData.SkinSection = 'CHECKBOX'
        ImgChecked = 0
        ImgUnchecked = 0
      end
      object rbPutAside: TsRadioButton
        Left = 58
        Top = 45
        Width = 80
        Height = 20
        Caption = #1054#1090#1083#1086#1078#1080#1090#1100
        TabOrder = 9
        OnClick = rbPutAsideClick
        SkinData.SkinSection = 'RADIOBUTTON'
      end
    end
    object SubjectEdit: TsEdit
      Left = 304
      Top = 13
      Width = 377
      Height = 21
      Color = clWhite
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
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
    object TextMemo: TsMemo
      Left = 8
      Top = 65
      Width = 545
      Height = 296
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 4
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
    object FilesListView: TsListView
      Left = 568
      Top = 65
      Width = 113
      Height = 296
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
      Color = clWhite
      Columns = <
        item
          Width = 450
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      IconOptions.Arrangement = iaLeft
      IconOptions.AutoArrange = True
      ReadOnly = True
      ParentFont = False
      PopupMenu = FilesListPopupMenu
      ShowColumnHeaders = False
      TabOrder = 5
      ViewStyle = vsReport
      OnDblClick = FilesListViewDblClick
    end
  end
  object PD: TPrintDialog
    Left = 24
    Top = 32
  end
  object PopUpImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D65004D6F20313520417567
          20323030352031313A33313A3134202B30313030D9FE197A0000000774494D45
          07D30A06140B0F5FC14CAA000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC61050000024F4944415478DA8D524B681351
          143D6F9AD8FC9A6AD44A292A5A6C310BD3455B17C5854548895250B22B28B8D0
          9D64E1C6851504C585883B8B167F605526552A5522A55AAADDB9104B51530517
          2E44256D6232BFCCC7FB3233EDF48378E1CC7D6FEEBDE7DD1F03C995A19CC575
          B5AA7305CDD59AAD55AD8A1FDFBF9C7E74F3BC48D712C1805738C1BF2473F1A1
          35786DCCEA3D72F21CB93713EADC581FD6118A014FC930ED733412C440FA1037
          5D362D934D3DBF7B87CE3FB98B401FC69DBCC21803232D307E0676EFD88A07D9
          0994CA123AF6272F91A993105DCA4055B51504D96C16B3731F21AB2A82F51B10
          8FC79139D54F0432AEDF78C25FEB22CC1116EC122C73395814D1DCD189643A8D
          CF0A30BF0814DFE6901B1F435FFF311886C99CD7FDDC5F585DFB874F79B4EDD9
          0583DE91250DDA1F1946A20F5FE7F3B5BED8DDA95558D33E3BD0BE99A42549C6
          EC029D3515858A8EB2A443F7075191A5A5E67AC5E79DBF4E0EA1403DF244C014
          0D8A62A05415D012B4500E876117BA2203BB04D3B44D3AADC7DEF636E8EFA7F0
          5B6F40A5AE114DD106142686110885C15E0FA37B5FEBDA0C14670A066570F868
          1ACF4645FC1A1D8424AB504241346E8C21D5AD63F39B112442BD6B09DC3DD09D
          61A48884FFB29CFE18D3F7D034390476E200E22393B8DA13DB7276A610E11B59
          239015D521581EA797C0EC398EA220207AFF16FC032994844D49CC64C6C9FC8D
          13587E9AE8990BB7DD06C1ED95E5C9AE2BD18AF6C841BC146378F1F4F12BFAD5
          4208B9DDDC494813B6AFDE8D7584A75921BC234CBB0401C23647FF8FF0B91709
          8B7F01222C1C12A0DAF6630000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500536F203137204E6F76
          20323030322031393A31373A3436202B3031303041C0B5F10000000774494D45
          07D30A06140B3599CD9518000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002564944415478DA8D524D6B1351
          143DEFCD24339344134D8D3525B5B40457DD65A12B170ABA70A70B29165C8404
          EDAECB80F80B2AEE42433675E3465C08E20F101785D0852E146DA43410686A26
          1ACD24937933CF3B63B2684CC40B873BF3EE3DE77EBCC7B487B51DBB7EBCDEDC
          5E625E280EA628701D817E7F80FEC0826DDB90BD635CDE8E49ADDB786EBF5EDB
          0460121C02B8D7E9DE43FD334B261358485F40B371888EF90D56AF0B4F3858BE
          B888543289B8B5C7A2BA7E9738D70967313295AB9C433720848B301D64B35930
          C6301C0E83EAF4034708182B5760EF1F704A5925EC128E0201C619A0A9B089A0
          5162A7D30904A494242AA0F8237902901C8CCEC80C82422022A4CA1412354218
          0EECA0AA699A50553510F03C0F914804AEEB82539E941C93A672AAC60C8D9661
          81BB3D5C5A4E932E0292A0658209848485901687CD820ED80901308E445CC3ED
          A70DD8E290D6CAC0B942B7417954552118BA8A5898E327637F77E0E74563617C
          34391145D0BE4724372826A1D17E741A3B7A9A3AC5140192F03709E92878FF28
          83BD832142EC1716120AE69273D86F7650FB7E06DC3030CC6AD87C851363B0C4
          C6AE3CC77AF82154BC5CD7F16CA78AFFB14AA5B2E45FA56A99DD0F3CADAF1A11
          0356BF1B040B8502AAD52A52A9145AAD16F2F9FC24D97777082F54597BB2F675
          FE56D5F1A22BDA8DF95374A8F9D172B98C5C2E875AAD36AB890C41E7CE973775
          E7EDC603BCBBFFF8EAB59B5BE368A9540A2AFB7E86F13F4B0406844FA3A719F1
          B9A316D16EB7035F2C16A70978938F62FCBD389A2F33AE3283DCF077C0A60475
          C2F991FF97F99D1FFD06F8F8DD3FE91462330000000049454E44AE426082}
      end>
    Left = 440
    Top = 320
    Bitmap = {}
  end
  object FilesListPopupMenu: TPopupMenu
    Images = PopUpImages
    OnPopup = FilesListPopupMenuPopup
    Left = 400
    Top = 320
    object ShowFilePopPup: TMenuItem
      Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100
      ImageIndex = 0
      OnClick = ShowFilePopPupClick
    end
    object SaveAsPopUp: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
      ImageIndex = 1
      OnClick = SaveAsPopUpClick
    end
  end
  object SaveDlg: TSaveDialog
    Left = 336
    Top = 248
  end
end
