object DebtingForm: TDebtingForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DebtingForm'
  ClientHeight = 268
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel1: TsLabel
    Left = 16
    Top = 19
    Width = 137
    Height = 13
    Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1076#1086#1075#1086#1074#1086#1088#1091':'
  end
  object sLabel2: TsLabel
    Left = 16
    Top = 51
    Width = 35
    Height = 13
    Caption = #1057#1091#1084#1084#1072':'
  end
  object sLabel3: TsLabel
    Left = 16
    Top = 78
    Width = 48
    Height = 13
    Caption = #1044#1077#1073#1080#1090#1086#1088':'
  end
  object sLabel4: TsLabel
    Left = 16
    Top = 110
    Width = 122
    Height = 13
    Caption = #1055#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080' '#1086#1087#1077#1088#1072#1094#1080#1080':'
  end
  object Dt: TsDateEdit
    Left = 159
    Top = 16
    Width = 86
    Height = 21
    AutoSize = False
    EditMask = '!99/99/9999;1; '
    MaxLength = 10
    TabOrder = 0
    Text = '  .  .    '
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
  object AmountEdit: TsEdit
    Left = 159
    Top = 48
    Width = 86
    Height = 21
    Alignment = taRightJustify
    TabOrder = 1
    Text = 'AmountEdit'
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
  object DescrMemo: TsMemo
    Left = 16
    Top = 129
    Width = 288
    Height = 89
    Lines.Strings = (
      'DescrMemo')
    TabOrder = 2
    Text = 'DescrMemo'
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
  object OKButton: TsButton
    Left = 40
    Top = 232
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    TabOrder = 3
    OnClick = OKButtonClick
    SkinData.SkinSection = 'BUTTON'
  end
  object CancelButton: TsButton
    Left = 162
    Top = 232
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 4
    SkinData.SkinSection = 'BUTTON'
  end
  object DebCredCombo: TsComboBox
    Left = 159
    Top = 75
    Width = 145
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
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = -1
    TabOrder = 5
    OnDrawItem = DebCredComboDrawItem
  end
end
