object NewFPForm: TNewFPForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1060#1055
  ClientHeight = 135
  ClientWidth = 353
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
    Width = 353
    Height = 135
    Align = alClient
    TabOrder = 0
    object Label2: TLabel
      Left = 12
      Top = 48
      Width = 60
      Height = 13
      Caption = #1047#1072' '#1087#1077#1088#1080#1086#1076' '#1089
    end
    object Label3: TLabel
      Left = 60
      Top = 75
      Width = 12
      Height = 13
      Caption = #1087#1086
    end
    object sLabel1: TsLabel
      Left = 38
      Top = 16
      Width = 152
      Height = 13
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1086#1077' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#8470
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object CancleButton: TsButton
      Left = 264
      Top = 42
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 3
    end
    object EndDateEdit: TsDateEdit
      Left = 78
      Top = 72
      Width = 86
      Height = 21
      AutoSize = False
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 0
      Text = '  .  .    '
    end
    object EndTimePicker: TsTimePicker
      Left = 170
      Top = 72
      Width = 71
      Height = 21
      TabOrder = 1
      Text = '00:00:00'
    end
    object NumEdit: TEdit
      Left = 196
      Top = 13
      Width = 41
      Height = 21
      TabStop = False
      Alignment = taRightJustify
      Color = clInactiveBorder
      ReadOnly = True
      TabOrder = 4
    end
    object OKButton: TsButton
      Left = 264
      Top = 11
      Width = 75
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = OKButtonClick
    end
    object StartDateEdit: TsDateEdit
      Left = 78
      Top = 45
      Width = 86
      Height = 21
      TabStop = False
      AutoSize = False
      Enabled = False
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 5
      Text = '  .  .    '
    end
    object StartTimePicker: TsTimePicker
      Left = 170
      Top = 45
      Width = 71
      Height = 21
      TabStop = False
      Enabled = False
      TabOrder = 6
      Text = '00:00:00'
    end
    object ckbCopyIncPlan: TsCheckBox
      Left = 78
      Top = 99
      Width = 170
      Height = 17
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1083#1072#1085' '#1087#1086' '#1076#1086#1093#1086#1076#1091
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
  end
end
