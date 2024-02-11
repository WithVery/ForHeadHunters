object NOWStep2Form: TNOWStep2Form
  Left = 0
  Top = 0
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1085#1086#1074#1086#1081' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080' - '#1096#1072#1075' 2 '#1080#1079' 5'
  ClientHeight = 306
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 442
    Height = 306
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelEdges = []
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object sLabel1: TsLabel
      Left = 8
      Top = 8
      Width = 296
      Height = 13
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102', '#1082#1086#1090#1086#1088#1072#1103' '#1073#1091#1076#1077#1090' '#1096#1072#1073#1083#1086#1085#1086#1084
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object FinishButton: TsButton
      Left = 262
      Top = 274
      Width = 75
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100
      TabOrder = 1
      OnClick = FinishButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object NextStepButton: TsButton
      Left = 166
      Top = 274
      Width = 75
      Height = 25
      Caption = #1044#1072#1083#1077#1077' >>'
      Default = True
      TabOrder = 0
      OnClick = NextStepButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object CancelButton: TsButton
      Left = 358
      Top = 274
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 2
      OnClick = CancelButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object PrevStepButton: TsButton
      Left = 78
      Top = 274
      Width = 75
      Height = 25
      Caption = '<< '#1053#1072#1079#1072#1076
      Default = True
      TabOrder = 3
      OnClick = PrevStepButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object NoTemplateRadio: TsRadioButton
      Left = 8
      Top = 27
      Width = 216
      Height = 20
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103' '#1089#1086#1079#1076#1072#1105#1090#1089#1103' '#1073#1077#1079' '#1096#1072#1073#1083#1086#1085#1072
      TabOrder = 4
      OnClick = NoTemplateRadioClick
      SkinData.SkinSection = 'RADIOBUTTON'
    end
    object HasTemplateRadio: TsRadioButton
      Left = 8
      Top = 53
      Width = 234
      Height = 20
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103', '#1082#1086#1090#1086#1088#1072#1103' '#1073#1091#1076#1077#1090' '#1096#1072#1073#1083#1086#1085#1086#1084':'
      TabOrder = 5
      OnClick = HasTemplateRadioClick
      SkinData.SkinSection = 'RADIOBUTTON'
    end
    object WOrgTree: TVirtualStringTree
      Left = 8
      Top = 79
      Width = 426
      Height = 178
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      TabOrder = 6
      OnChange = WOrgTreeChange
      OnGetText = WOrgTreeGetText
      Columns = <>
    end
  end
end
