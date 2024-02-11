object FPUnsavedExitForm: TFPUnsavedExitForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
  ClientHeight = 98
  ClientWidth = 481
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 481
    Height = 98
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    ExplicitLeft = 144
    ExplicitTop = 48
    ExplicitWidth = 185
    ExplicitHeight = 41
    object sLabel1: TsLabel
      Left = 16
      Top = 16
      Width = 447
      Height = 33
      Caption = 
        #1042#1053#1048#1052#1040#1053#1048#1045'! '#1042#1099' '#1087#1099#1090#1072#1077#1090#1077#1089#1100' '#1079#1072#1082#1088#1099#1090#1100' '#1092#1086#1088#1084#1091', '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1077#1089#1090#1100' '#1085#1077#1089#1086#1093#1088#1072#1085#1105#1085#1085 +
        #1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103'!'
      ParentFont = False
      WordWrap = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object btnSaveAndClose: TsButton
      Left = 16
      Top = 55
      Width = 137
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080' '#1079#1072#1082#1088#1099#1090#1100
      Default = True
      TabOrder = 0
      OnClick = btnSaveAndCloseClick
      SkinData.SkinSection = 'BUTTON'
    end
    object btnClose: TsButton
      Left = 167
      Top = 55
      Width = 137
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103
      TabOrder = 1
      OnClick = btnCloseClick
      SkinData.SkinSection = 'BUTTON'
    end
    object btnCancel: TsButton
      Left = 326
      Top = 55
      Width = 137
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      TabOrder = 2
      OnClick = btnCancelClick
      SkinData.SkinSection = 'BUTTON'
    end
  end
end
