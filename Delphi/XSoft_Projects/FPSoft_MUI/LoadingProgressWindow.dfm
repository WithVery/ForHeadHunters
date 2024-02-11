object LoadingProgressForm: TLoadingProgressForm
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  BorderStyle = bsSingle
  Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1086#1077' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077'. '#1047#1072#1075#1088#1091#1079#1082#1072'.'
  ClientHeight = 98
  ClientWidth = 556
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 556
    Height = 98
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    ExplicitWidth = 562
    DesignSize = (
      556
      98)
    object Lbl: TsLabel
      Left = 8
      Top = 15
      Width = 13
      Height = 13
      Caption = 'Lbl'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PB: TsGauge
      Left = 8
      Top = 48
      Width = 539
      Height = 30
      Anchors = [akLeft, akTop, akRight, akBottom]
      SkinData.SkinSection = 'GAUGE'
      ForeColor = clBlack
      ShowText = False
      Suffix = '%'
      ExplicitWidth = 545
    end
  end
end
