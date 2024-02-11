object DebtorEditForm: TDebtorEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1099#1081' '#1076#1077#1073#1080#1090#1086#1088
  ClientHeight = 196
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 389
    Height = 196
    Align = alClient
    TabOrder = 0
    DesignSize = (
      389
      196)
    object Label1: TLabel
      Left = 16
      Top = 40
      Width = 52
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 16
      Top = 67
      Width = 64
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1058#1077#1083#1077#1092#1086#1085'('#1099'):'
    end
    object Label3: TLabel
      Left = 16
      Top = 94
      Width = 92
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086':'
    end
    object Label4: TLabel
      Left = 16
      Top = 121
      Width = 40
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1057#1090#1072#1090#1091#1089':'
    end
    object CancelButton: TsButton
      Left = 209
      Top = 160
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 6
      OnClick = CancelButtonClick
    end
    object ContactPersonEdit: TsEdit
      Left = 128
      Top = 91
      Width = 241
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 3
      Text = 'sEdit1'
    end
    object DebtKindCombo: TComboBox
      Left = 128
      Top = 10
      Width = 121
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = DebtKindComboChange
    end
    object NameEdit: TsEdit
      Left = 128
      Top = 37
      Width = 241
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 1
      Text = 'NameEdit'
    end
    object OKButton: TsButton
      Left = 73
      Top = 160
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Default = True
      TabOrder = 5
      OnClick = OKButtonClick
    end
    object PhoneEdit: TsEdit
      Left = 128
      Top = 64
      Width = 121
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 2
      Text = 'sEdit1'
    end
    object DebtStatusCombo: TsComboBox
      Left = 128
      Top = 118
      Width = 145
      Height = 21
      Anchors = [akLeft, akBottom]
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 4
      OnChange = DebtStatusComboChange
    end
  end
end
