object FilterFloatsForm: TFilterFloatsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1092#1080#1083#1100#1090#1088#1072' '#1089#1091#1084#1084
  ClientHeight = 147
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object pnl: TsPanel
    Left = 0
    Top = 0
    Width = 313
    Height = 147
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object lblOper1: TsLabel
      Left = 8
      Top = 8
      Width = 59
      Height = 13
      Caption = #1054#1087#1077#1088#1072#1090#1086#1088' 1'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object lblVal2: TsLabel
      Left = 224
      Top = 56
      Width = 57
      Height = 13
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077' 2'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object slblVal1: TsLabel
      Left = 224
      Top = 8
      Width = 57
      Height = 13
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077' 1'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object ckbOper2: TsCheckBox
      Left = 8
      Top = 56
      Width = 87
      Height = 20
      Caption = #1054#1087#1077#1088#1072#1090#1086#1088' 2'
      TabOrder = 2
      OnClick = ckbOper2Click
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
    object cmbOper1: TsComboBox
      Left = 8
      Top = 27
      Width = 201
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
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = '='
      Items.Strings = (
        '='
        '>'
        '>='
        '<'
        '<=')
    end
    object cmbOper2: TsComboBox
      Left = 8
      Top = 75
      Width = 201
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
      ItemIndex = 0
      ParentFont = False
      TabOrder = 5
      Text = '='
      Items.Strings = (
        '='
        '>'
        '>='
        '<'
        '<=')
    end
    object rbAND: TsRadioButton
      Left = 101
      Top = 56
      Width = 35
      Height = 20
      Caption = #1048
      TabOrder = 4
      SkinData.SkinSection = 'RADIOBUTTON'
    end
    object rbOR: TsRadioButton
      Left = 133
      Top = 56
      Width = 49
      Height = 20
      Caption = #1048#1051#1048
      TabOrder = 3
      SkinData.SkinSection = 'RADIOBUTTON'
    end
    object edtVal1: TsCurrencyEdit
      Left = 224
      Top = 27
      Width = 73
      Height = 21
      AutoSize = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
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
      GlyphMode.Blend = 0
      GlyphMode.Grayed = False
    end
    object edtVal2: TsCurrencyEdit
      Left = 224
      Top = 75
      Width = 73
      Height = 21
      AutoSize = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
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
      GlyphMode.Blend = 0
      GlyphMode.Grayed = False
    end
    object btnApply: TsButton
      Left = 8
      Top = 114
      Width = 87
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100'!'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 7
      SkinData.SkinSection = 'BUTTON'
    end
    object btnDeactivate: TsButton
      Left = 107
      Top = 114
      Width = 190
      Height = 25
      Caption = #1044#1077#1072#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 8
      OnClick = btnDeactivateClick
      SkinData.SkinSection = 'BUTTON'
    end
  end
end
