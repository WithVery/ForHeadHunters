object MainFPForm: TMainFPForm
  Left = 0
  Top = 0
  ClientHeight = 752
  ClientWidth = 1179
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TsPanel
    Left = 0
    Top = 84
    Width = 1179
    Height = 649
    Align = alClient
    TabOrder = 0
    object MainGroupSplitter: TsSplitter
      Left = 193
      Top = 1
      Height = 647
      OnMoved = MainGroupSplitterMoved
      ExplicitLeft = 88
      ExplicitTop = 120
      ExplicitHeight = 100
    end
    object GridPanel: TsPanel
      Left = 199
      Top = 1
      Width = 979
      Height = 647
      SkinData.SkinSection = 'PANEL_LOW'
      Align = alClient
      TabOrder = 0
      object StatsSplitter: TsSplitter
        AlignWithMargins = True
        Left = 1
        Top = 470
        Width = 977
        Height = 6
        Cursor = crVSplit
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        Visible = False
        ExplicitTop = 449
        ExplicitWidth = 134
      end
      object GridGroupBox: TsGroupBox
        AlignWithMargins = True
        Left = 1
        Top = 1
        Width = 977
        Height = 469
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Caption = #1043#1083#1072#1074#1085#1072#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        SkinData.SkinSection = 'PANEL_LOW'
        CaptionSkin = 'BUTTON'
        object StrGrid: TAdvStringGrid
          AlignWithMargins = True
          Left = 2
          Top = 57
          Width = 973
          Height = 410
          Cursor = crDefault
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Color = 9681102
          ColCount = 10
          Ctl3D = True
          DrawingStyle = gdsClassic
          FixedColor = clWhite
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goRowSelect]
          ParentCtl3D = False
          ScrollBars = ssBoth
          TabOrder = 0
          OnExit = StrGridExit
          OnKeyDown = StrGridKeyDown
          OnMouseMove = StrGridMouseMove
          HoverRowCells = [hcNormal, hcSelected]
          OnGetCellColor = StrGridGetCellColor
          OnGetCellPrintColor = StrGridGetCellPrintColor
          OnGetCellPrintBorder = StrGridGetCellPrintBorder
          OnGetAlignment = StrGridGetAlignment
          OnGetFormat = StrGridGetFormat
          OnClickCell = StrGridClickCell
          OnRightClickCell = StrGridRightClickCell
          OnDblClickCell = StrGridDblClickCell
          OnGetEditorType = StrGridGetEditorType
          OnSelectionChanged = StrGridSelectionChanged
          OnUpdateColumnSize = StrGridUpdateColumnSize
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          ActiveCellColor = clMaroon
          ActiveCellColorTo = clPurple
          AutoFilterUpdate = False
          BackGround.ColorTo = clGreen
          ColumnHeaders.Strings = (
            '')
          ControlLook.FixedGradientHoverFrom = 16775139
          ControlLook.FixedGradientHoverTo = 16775139
          ControlLook.FixedGradientHoverMirrorFrom = 16772541
          ControlLook.FixedGradientHoverMirrorTo = 16508855
          ControlLook.FixedGradientDownFrom = 16377020
          ControlLook.FixedGradientDownTo = 16377020
          ControlLook.FixedGradientDownMirrorFrom = 16242317
          ControlLook.FixedGradientDownMirrorTo = 16109962
          ControlLook.FixedGradientDownBorder = clSilver
          ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
          ControlLook.DropDownHeader.Font.Color = clWindowText
          ControlLook.DropDownHeader.Font.Height = -11
          ControlLook.DropDownHeader.Font.Name = 'Tahoma'
          ControlLook.DropDownHeader.Font.Style = []
          ControlLook.DropDownHeader.Visible = True
          ControlLook.DropDownHeader.Buttons = <>
          ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
          ControlLook.DropDownFooter.Font.Color = clWindowText
          ControlLook.DropDownFooter.Font.Height = -11
          ControlLook.DropDownFooter.Font.Name = 'Tahoma'
          ControlLook.DropDownFooter.Font.Style = []
          ControlLook.DropDownFooter.Visible = True
          ControlLook.DropDownFooter.Buttons = <>
          EnableHTML = False
          EnableWheel = False
          EnhRowColMove = False
          Filter = <>
          FilterDropDown.Font.Charset = DEFAULT_CHARSET
          FilterDropDown.Font.Color = clWindowText
          FilterDropDown.Font.Height = -11
          FilterDropDown.Font.Name = 'Tahoma'
          FilterDropDown.Font.Style = []
          FilterDropDownClear = '(All)'
          FilterEdit.TypeNames.Strings = (
            'Starts with'
            'Ends with'
            'Contains'
            'Not contains'
            'Equal'
            'Not equal'
            'Larger than'
            'Smaller than'
            'Clear')
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
          FloatingFooter.Color = clYellow
          HoverButtons.Buttons = <>
          HoverButtons.Position = hbLeftFromColumnLeft
          HTMLSettings.ImageFolder = 'images'
          HTMLSettings.ImageBaseName = 'img'
          IntelliPan = ipNone
          IntelliZoom = False
          Look = glListView
          PrintSettings.DateFormat = 'dd/mm/yyyy'
          PrintSettings.Font.Charset = DEFAULT_CHARSET
          PrintSettings.Font.Color = clWindowText
          PrintSettings.Font.Height = -11
          PrintSettings.Font.Name = 'Tahoma'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'Tahoma'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'Tahoma'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'Tahoma'
          PrintSettings.FooterFont.Style = []
          PrintSettings.PageNumSep = '/'
          PrintSettings.UseDisplayFont = False
          ScrollWidth = 13
          SearchFooter.Color = 5470350
          SearchFooter.ColorTo = 9681102
          SearchFooter.FindNextCaption = #1048#1089#1082#1072#1090#1100' '#1085#1080#1078#1077
          SearchFooter.FindPrevCaption = #1048#1089#1082#1072#1090#1100' '#1074#1099#1096#1077
          SearchFooter.Font.Charset = DEFAULT_CHARSET
          SearchFooter.Font.Color = clWindowText
          SearchFooter.Font.Height = -11
          SearchFooter.Font.Name = 'Tahoma'
          SearchFooter.Font.Style = []
          SearchFooter.HighLightCaption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
          SearchFooter.HintClose = #1047#1072#1082#1088#1099#1090#1100
          SearchFooter.HintFindNext = #1053#1072#1081#1090#1080' '#1085#1080#1078#1077
          SearchFooter.HintFindPrev = #1053#1072#1081#1090#1080' '#1074#1099#1096#1077
          SearchFooter.HintHighlight = #1055#1086#1076#1089#1074#1077#1095#1080#1074#1072#1077#1090' '#1074#1089#1077' '#1089#1086#1074#1087#1072#1076#1077#1085#1080#1103
          SearchFooter.MatchCaseCaption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1088#1077#1075#1080#1089#1090#1088
          SearchFooter.ShowClose = False
          SearchFooter.ShowMatchCase = False
          SearchFooter.Visible = True
          SelectionColor = clSilver
          ShowDesignHelper = False
          SortSettings.DefaultFormat = ssAutomatic
          SortSettings.HeaderColor = 16579058
          SortSettings.HeaderColorTo = 16579058
          SortSettings.HeaderMirrorColor = 16380385
          SortSettings.HeaderMirrorColorTo = 16182488
          UseInternalHintClass = False
          Version = '8.1.3.0'
          ColWidths = (
            64
            64
            64
            64
            64
            64
            64
            64
            64
            64)
          RowHeights = (
            22
            22
            22
            22
            22
            22
            22
            22
            22
            22)
        end
        object SearchToolBar: TsToolBar
          Left = 2
          Top = 36
          Width = 973
          Height = 21
          Caption = 'sToolBar1'
          DoubleBuffered = True
          Images = TreeImages
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          object sButton4: TsButton
            Left = 0
            Top = 0
            Width = 57
            Height = 22
            Caption = #1048#1089#1082#1072#1090#1100':'
            Enabled = False
            TabOrder = 9
            TabStop = False
            Down = True
          end
          object SearchTypeCombo: TsComboBox
            Left = 57
            Top = 0
            Width = 145
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 0
            Text = #1042#1089#1105
            Items.Strings = (
              #1042#1089#1105
              #1055#1088#1080#1093#1086#1076
              #1056#1072#1089#1093#1086#1076)
          end
          object sButton1: TsButton
            AlignWithMargins = True
            Left = 202
            Top = 0
            Width = 39
            Height = 22
            Caption = #1043#1076#1077':'
            Enabled = False
            TabOrder = 6
            TabStop = False
            Down = True
            ShowFocus = False
          end
          object SearchSourceCombo: TsComboBox
            Left = 241
            Top = 0
            Width = 145
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Style = csDropDownList
            ItemIndex = -1
            TabOrder = 1
          end
          object sButton3: TsButton
            AlignWithMargins = True
            Left = 386
            Top = 0
            Width = 82
            Height = 22
            Caption = #1055#1077#1088#1080#1086#1076'. '#1057':'
            Enabled = False
            TabOrder = 8
            TabStop = False
            WordWrap = False
            Down = True
            ShowFocus = False
          end
          object StartDateEdit: TsDateEdit
            Left = 468
            Top = 0
            Width = 86
            Height = 22
            AutoSize = False
            EditMask = '!99/99/9999;1; '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            MaxLength = 10
            ParentFont = False
            TabOrder = 2
            Text = '  .  .    '
            Weekends = [dowSaturday, dowSunday]
            WeekendColor = clMaroon
          end
          object sButton2: TsButton
            AlignWithMargins = True
            Left = 554
            Top = 0
            Width = 34
            Height = 22
            Caption = #1087#1086':'
            Enabled = False
            TabOrder = 7
            TabStop = False
            WordWrap = False
            Down = True
            ShowFocus = False
          end
          object EndDateEdit: TsDateEdit
            Left = 588
            Top = 0
            Width = 86
            Height = 22
            AutoSize = False
            EditMask = '!99/99/9999;1; '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            MaxLength = 10
            ParentFont = False
            TabOrder = 3
            Text = '  .  .    '
            Weekends = [dowSaturday, dowSunday]
            WeekendColor = clMaroon
          end
          object sButton5: TsButton
            AlignWithMargins = True
            Left = 674
            Top = 0
            Width = 82
            Height = 22
            Caption = #1063#1090#1086' '#1080#1089#1082#1072#1090#1100':'
            Enabled = False
            TabOrder = 10
            TabStop = False
            WordWrap = False
            Down = True
            ShowFocus = False
          end
          object StringEdit: TsEdit
            Left = 756
            Top = 0
            Width = 121
            Height = 22
            TabOrder = 4
            OnKeyPress = StringEditKeyPress
          end
          object SearchToolButton: TsBitBtn
            Left = 877
            Top = 0
            Width = 21
            Height = 22
            Hint = #1048#1089#1082#1072#1090#1100'!'
            TabOrder = 5
            OnClick = SearchToolButtonClick
            ImageIndex = 4
            Images = TreeImages
          end
        end
        object TimeFilterToolBar: TsToolBar
          Left = 2
          Top = 15
          Width = 973
          Height = 21
          Caption = 'sToolBar1'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          object TimeFilterToolButton: TsSpeedButton
            Left = 0
            Top = 0
            Width = 97
            Height = 22
            AllowAllUp = True
            GroupIndex = 1
            Caption = #1060#1080#1083#1100#1090#1088
            OnClick = TimeFilterToolButtonClick
            Images = TimeFilterImages
            ImageIndex = 0
          end
          object sButton6: TsButton
            Left = 97
            Top = 0
            Width = 75
            Height = 22
            Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100':'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            Down = True
          end
          object PeriodCombo: TsComboBox
            Left = 172
            Top = 0
            Width = 145
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Style = csDropDownList
            ItemIndex = -1
            TabOrder = 6
            Items.Strings = (
              #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1085#1077#1076#1077#1083#1103
              #1055#1086#1089#1083#1077#1076#1085#1080#1081' '#1084#1077#1089#1103#1094
              #1055#1086#1089#1083#1077#1076#1085#1080#1077' 3 '#1084#1077#1089#1103#1094#1072
              #1055#1086#1089#1083#1077#1076#1085#1080#1077' 6 '#1084#1077#1089#1103#1094#1077#1074
              #1055#1086#1089#1083#1077#1076#1085#1080#1081' '#1075#1086#1076)
          end
          object FilterOutByFixedPeriodBtn: TsBitBtn
            Left = 317
            Top = 0
            Width = 21
            Height = 22
            Hint = #1054#1073#1085#1086#1074#1080#1090#1100
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 7
            OnClick = FilterOutByFixedPeriodBtnClick
            ShowCaption = False
            ImageIndex = 2
            Images = TimeFilterImages
          end
          object ToolButton9: TToolButton
            Left = 338
            Top = 0
            Width = 8
            Caption = 'ToolButton3'
            ImageIndex = 0
            Style = tbsSeparator
          end
          object sButton8: TsButton
            AlignWithMargins = True
            Left = 346
            Top = 0
            Width = 144
            Height = 22
            Caption = #1055#1088#1086#1080#1079#1074#1086#1083#1100#1085#1099#1081' '#1087#1077#1088#1080#1086#1076'. '#1057':'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            TabStop = False
            WordWrap = False
            Down = True
            ShowFocus = False
          end
          object FilterDateStartEdit: TsDateEdit
            Left = 490
            Top = 0
            Width = 86
            Height = 22
            AutoSize = False
            EditMask = '!99/99/9999;1; '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            MaxLength = 10
            ParentFont = False
            TabOrder = 3
            Text = '  .  .    '
            Weekends = [dowSaturday, dowSunday]
            WeekendColor = clMaroon
          end
          object sButton9: TsButton
            AlignWithMargins = True
            Left = 576
            Top = 0
            Width = 34
            Height = 22
            Caption = #1087#1086':'
            Enabled = False
            TabOrder = 1
            TabStop = False
            WordWrap = False
            Down = True
            ShowFocus = False
          end
          object FilterDateEndEdit: TsDateEdit
            Left = 610
            Top = 0
            Width = 86
            Height = 22
            AutoSize = False
            EditMask = '!99/99/9999;1; '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            MaxLength = 10
            ParentFont = False
            TabOrder = 0
            Text = '  .  .    '
            Weekends = [dowSaturday, dowSunday]
            WeekendColor = clMaroon
          end
          object FilterOutByArbPeriodBtn: TsBitBtn
            Left = 696
            Top = 0
            Width = 21
            Height = 22
            TabOrder = 4
            OnClick = FilterOutByArbPeriodBtnClick
            ImageIndex = 2
            Images = TimeFilterImages
          end
          object ToolButton4: TToolButton
            Left = 717
            Top = 0
            Width = 8
            Caption = 'ToolButton4'
            ImageIndex = 1
            Style = tbsSeparator
          end
          object SubmittedPOToolBtn: TsBitBtn
            Left = 725
            Top = 0
            Width = 22
            Height = 22
            Hint = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1074#1099#1089#1090#1072#1074#1083#1077#1085#1085#1099#1084' '#1079#1072#1103#1074#1082#1072#1084
            TabOrder = 8
            OnClick = SubmittedPOToolBtnClick
            ImageIndex = 3
            Images = TimeFilterImages
          end
          object RejectedPOToolBtn: TsBitBtn
            Left = 747
            Top = 0
            Width = 22
            Height = 22
            Hint = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1086#1090#1082#1083#1086#1085#1077#1085#1085#1099#1084' '#1079#1072#1103#1074#1082#1072#1084
            TabOrder = 9
            OnClick = RejectedPOToolBtnClick
            ImageIndex = 4
            Images = TimeFilterImages
          end
          object ApprovedPOToolBtn: TsBitBtn
            Left = 769
            Top = 0
            Width = 22
            Height = 22
            Hint = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1086#1076#1086#1073#1088#1077#1085#1085#1099#1084' '#1079#1072#1103#1074#1082#1072#1084
            TabOrder = 10
            OnClick = ApprovedPOToolBtnClick
            ImageIndex = 5
            Images = TimeFilterImages
          end
          object PaidPOToolBtn: TsBitBtn
            Left = 791
            Top = 0
            Width = 22
            Height = 22
            Hint = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1086#1087#1083#1072#1095#1077#1085#1085#1099#1084' '#1079#1072#1103#1074#1082#1072#1084
            TabOrder = 11
            OnClick = PaidPOToolBtnClick
            ImageIndex = 6
            Images = TimeFilterImages
          end
        end
      end
      object StatsScrollBox: TsScrollBox
        AlignWithMargins = True
        Left = 1
        Top = 476
        Width = 977
        Height = 170
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        TabOrder = 1
      end
    end
    object MainTree: TVirtualStringTree
      Left = 1
      Top = 1
      Width = 192
      Height = 647
      Align = alLeft
      ButtonStyle = bsTriangle
      CustomCheckImages = TreeImages
      DragType = dtVCL
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Height = 17
      Header.Options = [hoColumnResize, hoVisible]
      HintMode = hmTooltip
      Images = TreeImages
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus, toAutoChangeScale]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseExplorerTheme]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      OnCollapsed = MainTreeCollapsed
      OnCompareNodes = MainTreeCompareNodes
      OnDblClick = MainTreeDblClick
      OnDragAllowed = MainTreeDragAllowed
      OnDragOver = MainTreeDragOver
      OnDragDrop = MainTreeDragDrop
      OnExpanded = MainTreeExpanded
      OnGetText = MainTreeGetText
      OnPaintText = MainTreePaintText
      OnGetImageIndex = MainTreeGetImageIndex
      OnHeaderMouseUp = MainTreeHeaderMouseUp
      OnMouseDown = MainTreeMouseDown
      OnMouseMove = MainTreeMouseMove
      OnMouseUp = MainTreeMouseUp
      Columns = <
        item
          Position = 0
          Width = 300
          WideText = #1056#1072#1079#1076#1077#1083
        end
        item
          Alignment = taRightJustify
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
          Position = 1
          Width = 110
          WideText = #1041#1072#1083#1072#1085#1089
        end>
    end
  end
  object sToolBar1: TsToolBar
    Left = 0
    Top = 0
    Width = 1179
    Height = 84
    AutoSize = True
    ButtonHeight = 38
    ButtonWidth = 39
    Color = clBtnFace
    DoubleBuffered = True
    Images = sAlphaImageList1
    List = True
    ParentColor = False
    ParentDoubleBuffered = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object IncomeInvoicingBtn: TsSpeedButton
      Left = 0
      Top = 0
      Width = 90
      Height = 38
      Align = alLeft
      Caption = #1055#1088#1080#1093#1086#1076
      OnClick = IncomeInvoicingBtnClick
      Images = sAlphaImageList1
      ImageIndex = 2
    end
    object DisbToolButton: TsSpeedButton
      Left = 90
      Top = 0
      Width = 90
      Height = 38
      Align = alLeft
      Caption = #1056#1072#1089#1093#1086#1076
      OnClick = DisbToolButtonClick
      Images = sAlphaImageList1
      ImageIndex = 3
    end
    object TransferToolButton: TsSpeedButton
      Left = 180
      Top = 0
      Width = 90
      Height = 38
      Align = alLeft
      Caption = #1055#1077#1088#1077#1074#1086#1076
      OnClick = TransferToolButtonClick
      Images = sAlphaImageList1
      ImageIndex = 4
    end
    object ToolButton6: TToolButton
      Left = 270
      Top = 0
      Width = 8
      Caption = 'ToolButton6'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object DebtingButton: TsSpeedButton
      Left = 278
      Top = 0
      Width = 115
      Height = 38
      Align = alLeft
      Caption = #1044#1077#1073#1077#1090#1086#1074#1072#1085#1080#1077
      OnClick = DebtingButtonClick
      Images = sAlphaImageList1
      ImageIndex = 7
    end
    object CreditingButton: TsSpeedButton
      Left = 393
      Top = 0
      Width = 120
      Height = 38
      Align = alLeft
      Caption = #1050#1088#1077#1076#1080#1090#1086#1074#1072#1085#1080#1077
      OnClick = CreditingButtonClick
      Images = sAlphaImageList1
      ImageIndex = 8
    end
    object ToolButton14: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'ToolButton14'
      ImageIndex = 6
      Wrap = True
      Style = tbsSeparator
    end
    object NewPOToolButton: TsSpeedButton
      Left = 0
      Top = 46
      Width = 85
      Height = 38
      Align = alLeft
      Caption = #1053#1086#1074#1072#1103' '#1079#1072#1103#1074#1082#1072
      OnClick = NewPOToolButtonClick
      Images = sAlphaImageList1
      ImageIndex = 13
    end
    object NewOrgWizButton: TsSpeedButton
      Left = 85
      Top = 46
      Width = 112
      Height = 38
      Hint = #1052#1072#1089#1090#1077#1088' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1085#1086#1074#1086#1081' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
      Align = alLeft
      Caption = #1053#1086#1074#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
      Visible = False
      OnClick = NewOrgWizButtonClick
      Images = sAlphaImageList1
      ImageIndex = 5
    end
    object ToolButton11: TToolButton
      Left = 197
      Top = 46
      Width = 8
      Caption = 'ToolButton11'
      ImageIndex = 7
      Style = tbsSeparator
      Visible = False
    end
    object IncomeSourcesButton: TsSpeedButton
      Left = 205
      Top = 46
      Width = 120
      Height = 38
      Align = alLeft
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080' '#1076#1086#1093#1086#1076#1072
      OnClick = IncomeSourcesButtonClick
      Images = sAlphaImageList1
      ImageIndex = 0
    end
    object PrintToolButton: TsSpeedButton
      Left = 325
      Top = 46
      Width = 85
      Height = 38
      Align = alLeft
      Caption = #1055#1077#1095#1072#1090#1100
      OnClick = PrintToolButtonClick
      Images = sAlphaImageList1
      ImageIndex = 17
    end
    object PwdButton: TsSpeedButton
      Left = 410
      Top = 46
      Width = 103
      Height = 38
      Align = alLeft
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1086#1083#1100
      OnClick = PwdButtonClick
      Images = sAlphaImageList1
      ImageIndex = 6
    end
    object ToolButton1: TToolButton
      Left = 513
      Top = 46
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object ExportToExcelButton: TsSpeedButton
      Left = 521
      Top = 46
      Width = 85
      Height = 38
      Align = alLeft
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Visible = False
      OnClick = ExportToExcelButtonClick
      Images = sAlphaImageList1
      ImageIndex = 18
    end
    object AboutButton: TsSpeedButton
      Left = 606
      Top = 46
      Width = 116
      Height = 38
      Align = alLeft
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnClick = AboutButtonClick
      Images = sAlphaImageList1
      ImageIndex = 14
    end
  end
  object sb: TsStatusBar
    Left = 0
    Top = 733
    Width = 1179
    Height = 19
    Panels = <>
  end
  object sAlphaImageList1: TsAlphaImageList
    DrawingStyle = dsTransparent
    Height = 32
    Width = 32
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002B744558744372656174696F6E2054696D650053612031332044657A
          20323030332030303A30333A3233202B30313030179948BB0000000774494D45
          07D30A06141612C3AB4C6F000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000007BD4944415478DAAD576B6C1C57
          15FEE6B5B30FEF7ADFDEF533AE1F751C87BA316A9BD212059A0424DA0AC19F42
          0B95900A1202C10F9010123F104455F98110084510248A40406969A19592B414
          A4D2368DD5DAA1ADF3F066EDC489EBC7DABBDEF7CE9B73EFECA6560871D2E64A
          67B47BE7CE39DFFDCE77CEDC1170C57860F2D6909A17F758B6B3CF71ECBD96EE
          FCFAEF9FCDFC8E6E55C84CDCE421B0CB5766C7B6C986FAA586AE7FD22C397786
          822135168F221269C7F4C9192797291E3EF6F5F983A86391961B371380C42E23
          0F26BE1A0C047F3CDC3FDC37323C2877A55308B5B7419625F4F5F608A5467922
          3AAE8C94CED7A6EB39AB488FD83715C0E843B1CFF5F476ED8E276290216221BF
          06AFA2401625D8B64D20D2301573107DC66EAB61BF53CAEA6B372B1D4D00F12F
          A7BA933B436D019CC8CCE257478E60667E1EF78CED846999B01D1B5D9D097883
          9E54355CDEA704E56CE1ED7A2B1DCE870120B28B2DD8095555F884A6EBE80A06
          91F2FBC9B3034110E050888666A0BFBF1B9FD837D1DD79C0FF9B1DDF8E3F42CB
          A3AD4D7C180684E12F44BF3330D097142511FD1D292423117C7474148A2C1303
          160170782A9805025EF46F4BAB4B7A6E7FFB476467E55FB553E4A38E0FA80B0E
          60FB238983C343DBBC6CC2A2809150088A24C1304D1E9C19678A8370B8386F1D
          EA16974A857BDA6F973B96A7AAFF418397A9F5810088FBF135AB5A0BA7D371FA
          2372102C181B2D008E23503A5C26DCFFC0F6912E215FADECF4DC62EFAC2C1BD3
          46CEDEB851101C406E57FDD188AAA696169790A04AF0FBBD304DEBF2CE99CE0C
          C3E67392C43461739096E5607028259892D55F8BD6EE252D9DAACF59ABB8815E
          C101600FBE38988EF62AA28CD9CC02DADAFC88464397F3CE68174507C5A28146
          C380CFA7D09CCB1203D5DD1D4330E24BAC0AF9034A443C5F39655C24BF3AAEA3
          425C00F7E2F383BDD1A158C807D5AB607676811C3B6029698160BE7C3E19F97C
          0DB95C85BAA4973364593674DD443C1E44574FBCED427DF5D3DE3EB9589ED2CF
          D1438DAD40B8003E860786FAA33B92ED01783C32A2113FE6E796B1B25AA4D24B
          35F3EEEA21185451AD6A387326878E8E3662C62D53C33089390F8606D3CAF98D
          D5FB3CDB45A57C5C7F075B54880BE02EECEFED09EF8AB7FB6012B5AC3B84633E
          ACAE96307B7611B70C749200C1E966B90F87BD7C63C78F9F473219E0CCB07BA6
          6953858818DBD12D5CCA17EE1286ACBE72C69846EDFF5788DB44EEC6DE642AB0
          9BA540A7002689CCAE53CDC754D4EB1AA6DF9C2326925055990761B4B7B77B79
          1A8E1E3D8350C84B9AF1F37B2DCD8CED480B855A63B41ED526F48A71D2CE217F
          35102E803B717724E1DB9320EA1900D23FEA45BA7A00AF5F82E41131F97A16A9
          8E08050E342BC0A66AF110B0089E7DF65D3EC77E33102D3646463A988F9E65A1
          B8575471C6BCE02C5F59212D0013A1B8BA3F9968836E1048AAF76AC184E8A5F2
          A3FC2A1E01925FC0E4AB5984823EC413219E7316485164DC765B1A478E9C4636
          BB86F1F12E9E0656AE6C0C0EC691EE0E45B3D5F54F218C4BC6ACBD40D35A4B9C
          325F65A2AC69266FBB8C01916451AB1B10A812246ACF06A94C20A767E737724E
          6126B7F6F1F2E81D770C507A0C0E8409F1B1C776E3C92727F1F8E3C7A897BC9F
          0E2650899A9BAC4831EF987308AAD3597BC63C4C51D7594AE4669F2931001A05
          37C804064037205211797C4412351C8900D0B493796263CA28D9B9F55C65CFBE
          0363BC324C6AD92CD8C30FEFC2CF9E78796DEE07F9971D49280A6E2F70430824
          2C079A2072417692955985B8000C1435CDE1BBD7C911537C8300C935FAE11178
          10959E44007EC770D6E70F15FF6639F6E25FCA930FDDFF997181516E50EA54D5
          035F588D16447DDDA93A2FD1E62F5ED10718218CFEB596165A29281986E10220
          63C2D068572255B01412615B8C47D608E0A59B4413320BBF28FF487BD45CFA43
          E9F8371FBCFF76A52DE8E14C503588ABE9AAAD672D765E38BD49749B81D8ADDE
          203627CA46C38661BB29D009A7412AAF550CDE178C26335CB40A3F47B2D3D0FC
          CA6FEB3FCFBF5AFBFE1FFF3C595C5CDCE0E28BC502905308D2FD20DC33A7D134
          73935D6E4C6233050553B79D16032605D31D526655A7D5369F33D88B88A9CDC3
          09929B8E16379ED77F5F3EAA7DEBB9A7A62F4E4D2DD07B210CB14B8AD13D66EA
          56EF02370535941D7AB7100392490C6B350BCBD96A8942D47D49A523109649A0
          54090CAE07EED505CF44B65A3D61BE60E4A5F57FD6333FEC1D8D8CCB9D4217DC
          D392672B002E0327A95F13EB3AA39B66B25305072FE1793C8DE716DE28AE978A
          1A916443620854FE8CB2297DACBBE5F58CF5CAC6D38D6F5C3CBD7E4C8C890334
          176E0210B60630473B9141845B589A29C33C691FC3392A9702FE8DB7F0BDC537
          2AC54A99FA828C1600CF26002D519590C374E197FA778D45FB19B1830393AF2F
          05AE462BF94B8D58E5B43E8B17B142336F91BD8E37A95EFDC07B72F9A772480C
          1000F92A005A2AAF919D2D1FD20ED22A56EB8DE63A6B6B00024A8599460D2FE0
          355ACEDEE527C8DEE3127D057FA5905E73C8FE097C9C52E52A005A20589D5F20
          FDAC343572CDC3AA7CF9410280777198682FD1FFD7C8E69BCED828E01FF813AD
          F691B4FA9A81C46BF86D95DE96E3FD33FD043599A7F8CE99BD4DB6F13F3B3B87
          0C29631D5502E47633ED7A825C6B6C566888ACA7E998BD28AEF6E9C500FB9ACC
          DDF4AFE596F3ADBE74046C515A3732FE0B6DF7EAA1F0EF3B3A0000000049454E
          44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002A744558744372656174696F6E2054696D6500446F20352046656220
          323030342032333A30363A3337202B30313030525CF2530000000774494D4507
          D4070708160BEFD52DD7000000097048597300000B1100000B11017F645F9100
          00000467414D410000B18F0BFC61050000061A4944415478DAAD574D6F144710
          ADF95E2F4E6C08095FC289A220941B176E4456B871499453A45C72881494537E
          4B1424A4FC841C01092952B8A1448090821111D8C6EBB5B059F67B7776BDB333
          3D9357D53D78586C762DA5AD52CFECCC74BD7AF5AABA6DD1C4B876EDDAAF4992
          5C4ED3D4C2ADA794B2B22C9367F8CDC6B5CBF7B826F3BBBCC31798C9B22C274D
          95BC83FB7E92A8C66030B879FDFAF55FF04A0F9614FDB99300B0F0F757AE5C79
          6F6B6B8B1CC711475114C1594A713CC6F5481C63611A8DF2DF13DC27B8F6E094
          70CFE01C3C8F17A3A87BB6544A3EC6D20F607761AD770200EA981DAEACAC1800
          4A9B0270EB382D2E7E8ADF7D2A954A74EC5880885D38B7257AA55201C633DB78
          9C50ADD6A430BCC5515F80AD4C036021E288A3766C9B9AED1E8DAC12D9AE4BAE
          57A6F7BDD3B4BCFC25ADAFAFD2CE4E48AD56886815E529C96D2F450C24627662
          AC5DDE2FE0FD1818F3C792CF609E96BFFB99923190D944F5C7558A76891A8D90
          FAFD51C1B1E45BD2A0C0147440E5724952C4ECC13F3390C2583496990FD48006
          002300F7F19B93E9AFEC14B9563A4A7678F4A8474B4B1F211D81389C9B2B5310
          94C9752D808CE8C68D3B0240A9AC08603606C4E0E488071CF8D476F0B2CDE24B
          C9B62D5E94CE9D3B45172F2ED12E58816CF08C907792FB24B14C403133A00C00
          9A0A8019E0E81800E1E3790088700919080095E89C33D5A84A1A0CB453563F03
          E0CA4406C8F75D498566203D1C03BAA44033E612DEB0B0380A823C5C730AF899
          08D5F1E51BE815F9268051D4E90CA8DD0E31F7C49FD68088703600886ECC3397
          5382284BBE01200C90D43C8B8EA3DBD86850A552976A180E77A5470873A459D0
          8C0A003533003010310322B438A23233E06A009EA3BB1D33C06B55ABDB396C49
          0B6BC342B9E4D5C1D2650D28CE173E3DB40618C81C3490C51A00B331EAC7C200
          3FE728D959DEAAF3EBBD366DE58D697606F232648BF131673975B5083D441826
          7B8D260750745E34CBE2392956C1740018E36224605D58806F0A5C4BD4CFA2CB
          01149D4F02D12C7219728D88F3E900620C5D05FC2E3C511BCE13A1D371FB78CE
          BD3F131DF09C373606F53603B600C626A68C066662202A0248D3352C6E9B6FDB
          5870419C8FB1E6F2F259F2BCB194DCC387BBAFD7DF034006C02152C07D402B1D
          5141FE2ADE243BF0E55BCFE1ED570BEBCC99793A7F7E01EDF838AA6183D6D656
          A9DBF504DC1E0B1A404184D3AB8035A094AE1817FDF7DEABBFC89D476A504E95
          EE1134888B5205C3E1889E3F5F07033B70DC4213EA02D8826CE1454D3000E820
          9D95810CF48F31A4D17800F0DBDA1D728F824EAEF5F6125D5699ECF5ED7644F7
          EE0DE06805E98800E2149C8F71EF1A5D9049417CB832E44E9803E031EF6277F3
          33D98C62DF21F55AD02972EF20BAD3003082734F1C738AF2C6C4BA331A486716
          2133800F844A82FA5D27203FD0E0D3C096FC171B91830EE5BABEA904DBD09F9A
          60988171CEC06C9D108B440C401600D52ECE790118903F0F00E4E8A54C94BA1F
          D8B663EABEE85CB3C47B0758286A207B27806215B01519503EEA3A36FB847AB3
          114DCE7927D41A50338B50B6CE7C334A118D8B54B8252D2BB76CC90E199BBD22
          077010089D2AAE824300C018E55B6A66A5E46D9EA493FE293A420B34DC29513B
          C3392FD14CB28309018B78F3998FF131765454096FF1C94C0040D7B37ABD9EF9
          BE6F65380CFA4FCFD042FA396FAC346AF4C08A32A7DD37535074DCE974A8D96C
          52AFD70AB7B757FF7CF9B2C6A793362C9EF467D1DB63EEEAD5AB7F408C97CCAE
          98A22CBBFD7EEF551CFBC1A54B3F7D321C36E1A02F00D821AB7F842351BBDD66
          E759AF577F54A9FCFDB856FB1747FCA48E351F91FEA7E4054DFBCF0823BA7DFB
          F68F41107C5DABD54E8461E8A5A994D1E8C285AF3EC0F6FA437EEEE3D1ED76C5
          FAFD6E6B7B7BE5EEE6E6FDE670D81AE2D116EC196C1DB6631848269DED0720AD
          56ABCF31FF0EFBD08887779AF189139F7DDB68D4E598D56834E0B49F763A2FEE
          AFAEDE7D5AAF3F4D00B486F7D660AB265A761A1E94FF8300080BB0AA5984CC02
          48C5E0E69327FF7C03551FAB541E3C40B4BD280AD9C1A6897603C694F7CC1A29
          4D19D6B4172646003B07FB02B6600072C47C38ECC07048DFBFE5FE5F00F8FD39
          D822CC330E4313EDCC4E8BE33FA34A59610FD2E2950000000049454E44AE4260
          82}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002B744558744372656174696F6E2054696D65004D6F20313720466562
          20323030332031343A33363A3030202B303130308F728FEE0000000774494D45
          07D30A06141333F2B5A874000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000005674944415478DAD5565D6C1455
          14FEEEDD9DDDD2064AA0041529A08924A0118209F2E31B4FC6E8034834263EE0
          8389A16FC668C283CF46E303312162824DA3401088058C20514C4004828458FE
          AD82A58556A005DAEEFCDC1FCF9999DD9DD99D42F9F1C19B9C9DD9D973EFF9CE
          39DFF97680FFC5DAE2BF832F87DEA7BB4964F9877974EEAE1EDFFA6F176F399F
          35888615C1C2C51207BE3A434F47C9CC7F9FF976FF2D6CB4BAF38CB1DBBAB4C5
          17C6E0DD8E8FE897C71F5625C6AEC0CED29BB856DCB865A9CDB54CB0181A3558
          DA6CC43EBD6009E6B47A38DA79F66154221BC02EEF0D5C2D6EEA5862F2339B2C
          8EF519DC702D84B1583659890358B80C3367B938DEC9ED283D08887A009DDE6B
          E82BB46F5AAC9DD9132D8EF41A04CA4253075C0290B306CF352BF18B78761966
          B4967062F7D907019106B0CD5B8DDE42C7C6E795F3E464815F2FEB307840C195
          8EAE5E606893C5C2495A1EC533CBF1D8AC119CDC73DF20AA00BEF65E417F7EF3
          E74B5561EE1489431715053450260D40D3776504246D9937D1C81372DE724C7D
          F4264EEFBD808813F6DE016C765F1237E4B64F17D9E253CD02FDC30603C33A15
          58958D005CEF390F1378689006F3264BD9E53CFD829D3AE306CEECFD23AEC4B8
          41086C502FC255DB2758BFA1202D4ABE851F58AC5B54405130F90C4C1C98B337
          B4E54AD741EC320B90B73ECD223DB339F8560638B9751DF6BCD74EE7FE33DE76
          E43178EE220E6D5D553AF7D3FCD2F0B547886D05ACF961F5A442CBB4D666D29D
          3F15858CB28F00485007009573D586153B54BE380299F721088074F8CC1964B7
          E24A8C03C007F3B97743647D64453289A669AF065AC15339B84C3A9104002226
          EF6C3218FC8B7BBE9FEC4A9CB14B3640A6C7DB025633156FBA5E698B74ACAF7D
          78748CAF6A01508BE84AA21090EF30D969B2EE78AF894D85E7D42F9B05C0C61B
          54058046347E2A01C0445A60AD20301C86E3877BBC38F3EAE1EB3348D886D9F4
          D91FFBA600D42FDF0F03FB890A84D95B364153413F983B5779C7DAB518312EF6
          9D3A858E9F0FF3A35564DF905DBA3B80C0CF29CD0A28A108808E014420A84096
          54805A74A735A446315C2A6134A8F8CD246BC86A41FD5226CF22E4B19948F974
          3C8A3C721EDD474C4CAD54CF35EDD39647BAE227639FA49FCD064013C07DE6EC
          156982263DA80240C4019D68C1FAFA991F715D78D4CA298D8D659FB69009359C
          18AB050E1581C65090D1E4270084C95376F0468364E63BD7B6E17A304CE0344A
          9E87510ACEF773A74FC7C7AFAF0C9D38D86F3D3D683F78B4C2896C00460B3F90
          546A119250861C884084334613425FCA2317656CDDB0E786FC7CA5C2E0868C51
          5ABA5A6A4741CA88C0094E8CD182920CB413B6A00AC0863135EB0097C10FC955
          19B723DDDDB84500B83A8D8E83275A5AC2E0FDB76FE3FCD5AB28E472700840EF
          CD9B494E6491F0434ABB371798260A9EAFD10106406368521C0841ACFFFEC7D4
          299F50D9B902DD0303D8FFFBB9CC3A8F01800F774982E90584D89606C0CA63EA
          49D88639F4B9322EAB64C285C4A0B2E773B2ECD389AA1071F01EBECF00709298
          B744788A27CDA484A83A05B4DFAF089A8D0F6691698849D99617222E7BE59583
          7DB62312221B03C99882E56B24A52F95E14CD342144D8124509C436AF2F8B0BF
          930F8E5FBA1492F1F2E060D2878327FB91A1035C5FD2E070EC580DE91D90FF1B
          585414AB203FE7673C26E995D2FFF643C7B27A6E6BFD325AE0843A3FE81B5C18
          F02973415F030424A99A8D448A068A8F7390FD8F57169955154E247A5EEB5A0F
          40EC21F715435DDF1D2E9022465996CB6DC2E8368CEB34DE4E6453FBEF97E444
          B205FD75E132F0F3B356B297E36B6DA9CBCDE731B848B69BECF218E7D42E3B1E
          27C4C8A7A1CAEAAC43CA4CE6F73F0FF7B9C47DFE76C7ACEE65FD0B04337FEC6A
          98E2930000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002B744558744372656174696F6E2054696D65004D6F20313720466562
          20323030332031343A35303A3134202B30313030523C11670000000774494D45
          07D30A0614151F96376311000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC61050000052D4944415478DACD56DF6F1455
          14FEEEDCF9D16DC1D2D60201891088219A1212A289896881A8F8803C6848488C
          0F3C6A4CF45FF0CDF8C0A304C1A8218418243C613028B121F50760898201B1A5
          140A94D29FDBDDCECECE0FBF3333DB2EED6E1C4A1FBC9B937BF7CEDCFB7DF79C
          EF9C3B0AF59B42B616657C2F2B48A4F0E6D757306135A3EC6B04613A1FC8332F
          8693558DED4338BB7B374723B4D2420998F3A7F618C0DE351B3A372E59BEC422
          1E11A30821BB91BC87075321C6876E01773DBE87D768A7697717918013DB53AD
          0D58DBA2F1C7808BD1621923533E3C12011DA2FD29FA438B4BD6D2728F1382DA
          044C0B8E56182B84B831EAC1D2806D1984A427388636106823AC5A2F41599016
          8CF9538723E8E6C0E413C7D668A439FC63C7A66192984902B062ECC712601D0F
          70532B17DA04718823C04A453028824085D091412FF081B6E6AECB9A350F6199
          35A71D13165D6E596A8640C06CF0950193672E4B18ACD9A5A5CD085D1FF0A98A
          729858C94F7A992BD13C99979E26EFEECAC7FA19AA4DC0301902BA9C669180C1
          9307048FBD400256AC033D7372D9F8897D1DC9EEE594851F26FFABE738CEF7E6
          71E6922BEBDEA61DAF4DC0340387FB5B9684409180C1D34733044A826DCE8640
          F68E81C6B9F17439194FFB695F4EC6691F16A24A6959436BA843C08EC4039691
          88CFA02C0C094328F540918088C351D51EC8DF2E209CF410170CF1B14CBAE9E9
          25062E51DD44B332853401EA10D0654DB5C71EA01654949E3E355352C47266D6
          8AB7C7BEBB19E35447C0AD8A4025F695E7882B4A3D0214986D45D4808A75A0D2
          D3FB2422B540E6530DC4A758F537D6B17B2B75AB81FF6E02CE720AB73601AD03
          AD027A20A90148091852883816EF54A5A1F87548042531CD005E696EFD2C30ED
          D0D4256A00B1BB2BF1975E7E7116D87AEE66038F003E43BE9E0662F1593CA968
          4044E8A70442D1405C88EC799B2D80401D0DD8460C22354042A090B83F480958
          2A21B918AD36018ACD62FEC797508540250D291F47C21FCEAFC50B23F0456913
          26F2EDF04B0AA1AF500C98E87996801C35A06A1008611A6416B836D66FCB61CB
          BBCF63CDCBEBA159A4CBD393D8BFF112F7F5B286C4C4D8A405BDF458CEB49F6C
          E54D5C6C0831C1A2A194E29E8907C42395F84B7E6B8E9D266359C33B873ED251
          884260A0144613E839FA1EF7BC83242BBC2C0434BEFF7404AB575EF6DB36EF7C
          FF5927F7418783BDCFD878BAC58C0BC78322D34E493966E0A5A757C252119B9A
          8AD8100EA2C50970CD5B3689637BBFC4C52305245F476348BEE1321090A2D073
          6A188D5EDF39BB73FB8A46D51011B87734C0C834154F409512487A034D6DAB58
          CE8AB8EB6A9C76D74DE1F0CE9318B820A0E769D76985AC1AA848D9C3D59F6FA1
          39B8F96B53E7B64D6D86B3BA51F1E221281E262077048A63E81FBA8753FEC622
          0EBF7E02033DF7B8C70FB4DF69E359E35F4D401694F0D7B97E34E376776E6B67
          47ABE9ACE4D79E1FCD12D02CBFB6F271ADBF0F27FD8E697CFEEA09F49D9778FF
          48BB98BA3ECC0A5E4D6096C495AE7E2CC3E0B9A6AD9D9B5B4C7B790EF10DA818
          8A1C53F36A6F2F8E969F9BC6811DC771FD97FB55E0A38F0A3E97C02C89CB24D1
          AC06BB722F6D7BA15DDB2B1A241D4DF40DDEC181F1B52E3EDBF12DAE7557C02F
          2C14BC16810A09177F76DD405BD3BDB3F68BDB5F59699AA562011F0FB47838F8
          C6715CFE69780E7826C53F6A936BB51DFB3EF91007CBAE3EE47BD8B2F308E7F6
          D376D156D439C0637BE0E170F49CE945F3D2FB51F757BDE8FE464EDB45FB8DF6
          60314E9EE5535A48B6D136A45EF98736BC18E05909544838E9FBEE6281FF2FDA
          BFAD71456A8DA227DE0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002B744558744372656174696F6E2054696D65004D6F20313720466562
          20323030332031343A33363A3030202B303130308F728FEE0000000774494D45
          07D30A061413346CD13DD7000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000004F44944415478DAD5974D6C5455
          14C7FFEFB56F3EE8B4E3B425485A18CB0062448D0909028D0651A361E34E161A
          168A268605F1736162C2CAC48D9AE882850B571A1349246E8C16A4163F421028
          ADC3B405DAE974C64E613A9DAFF779EFF5DC37AF7C184BDFAB92E84DCEBC99BC
          77EFFF77CE3DE7DC37C0FF767CA6AFC727F6D778F9E3CDF42B42A6AC64999615
          897FA327510A0DF4AF69D9910D6D7A12F5F16164D37374C7BEF30047C9F37CE8
          C4DB5BD5D4FBDB800516E93E9BD8BD03F3178691BF540C0A110C407A9E0F1D7F
          FD7E35B57FA3C0C9298E8DAB3842E1555DA3DD4F6D47297D0185F1D92010FE01
          8EE97DC8BAE21BF6A7487C9AA1620AD44D8E541B432412ED4EAF7EFA11D43217
          3033E61BC21FC03123855C68E0CDAD4ADF0B298E935986AA25C09880C5381AB6
          401F45221AD1BA32896776A27E6904F98BBE209607F8CAD8809C467B8EE47329
          B8E2354FDCE1640460D1779D29E80D03B188DA399E7862176A13B41D9965216E
          0FF005793EAB1D7FF72191DCBF59C1E82C43BEC65D715B02B026802354342A65
          3834A5AFBD15ED91D6C4984CCC7A760485DB476269804F8D4DA86803BD112769
          D91C9F672CFC7695E1BE38DC085C17A72BA765E6AE9CC50F591DC3B33A0C8BC1
          54A39DC6BADD3B519E1941315D580AA27569F7CDCD289DFF28971EBC3B57988C
          43EBEEC09E43FB0E6F6FC3D0A4896B1607E7CD68881689A06282AD01063E3C0A
          ABDA80A63168511BB1C4C3B4D838D92499E31FE0C5F8F7F499214B92C5E4B3AD
          BB0FEEB31CEE269E4957B10840579BF2411316ECA10F4C7AF63459C113AC9071
          2FDA01009A219B21931D4EB65995D460D076B8103703A87415F408933A2893FD
          EA792D3C71CBB3205BE04ED43D93431104203DFD3B00DA7608C775D0F120E63D
          80DB8ED6E51EB86590804C48F32F007C118000838E6000366D01C5C572C40D00
          8A087D2100E6DEBFA300C261D7BD771C5905B21911912ACB5181C29D20CB0507
          E024B05805D67500025398DB98C49D8E800CB1692BAEF7CD326CB6634E056031
          957EFF9B1178A7BE17E6422F9C860A9D0AC128AF85691280B70D948C422C0208
          3707B84195FBE02B09F46C7B169D0F54A1A874A356C0978F7F4B2BCAFEC0FD03
          5CCD4C416939D211557B56AFD1A09B09F7D0A95BCE8D2AF00064E0796C2DBAEE
          D2E1F41F781E9CA15EA9C331C434CEBCF706DDEE219BF6206E194B9F05678E94
          A1759C31A37D7BB6AC8F773CB6A513DBFBDAD01553315EB45035D9AD87926841
          281683C6AE51272EA331DF98C6C04B47513C5FA3D5B268F605E61F40862B77AA
          04B391CED9A947E799DA5EA0A5CECDE8140D6ABD4EF32072011C09A0C0AC16B1
          502CA13A67CEE0F8811368146527FD85EC326E3434DF007258B83A520037D3F3
          3CD91F6E8B7484239A9B07B6D3F49C5281DCA2C434EBA8E67368CC99D3187CF5
          048CD2259A2FCF9311B22A96E88A7EDE880862340FA6A7CB2CD9AF46A21D5A34
          EC26A14DE5482F43D48CE80D293B01FD9A91C5D0C14198AEF877CB89FB056842
          942E1628A3476B62DD2E251C8DAB91B0EBBD4367546D6A0CC66C6512A70E0DC2
          9A9FF0E379508026C4C2D81F30CBA3BA48F68B7038AEB4C5509FBA0C2B3F3B85
          9F5F1B825D9627E0805FF1A0004D88CAE502F586518BF5ECB24D3BEE4C4F4EE2
          F45B3FC25E18BFC9F39A1FF1950078101305DAE7DF056FEFC5B9C33FC15AB872
          93E7BEC5E558D1FF396F5E3BD9BD64F79049804C50F17F02B03857FE295D45D6
          2033828AFF27C69F02B02A172A0612030000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002B744558744372656174696F6E2054696D65004D692031372044657A
          20323030332032303A31313A3134202B3031303037C380AB0000000774494D45
          07D30A0614143024FD6F09000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC61050000086B4944415478DAAD570B5054E7
          15FE76EF3E60D9E5252FE50DCA0AE1110B21CA80B11A1FD1A4B655928E4D3299
          CCB44DA74D9CD476FA9C66A6633BED64DAC4C94C74AA4DA6D53AB1544DA67444
          01416104140D2C8F05167079B32C8FDD65DFAFDBF35F2F042CA899F8CF9C59EE
          F2DFFF3BE73BDFF97E00BEE26A781731357F82E1C2AFF0BE5A8D38FA4AFEC693
          905F78131AFA59F2B0F7658F02623806CD86C3B08B8FFCD2DF49A448D14485AF
          8F4A8A79EBDD9707D76B54302914D8E7E3A12CCD4469E30006699B6BB5B3A50F
          03D7FF0DA7C6FD983EF936BE4D8FE1F7BF63B2C2EF77FBF0B5436F4B9EDDB966
          DF969DB9AF7FE3C89178C73C5C2D466CA72D090F62E28109B49FC06BF37ED5EB
          DAD22D0AA70B2FD1577914A18BCCFC03052A198EA923C3E8C98FF57951C8285E
          0FC36D3DEABBD1E40B20EA61188B2D183A8D5CD31C9EB6386099B6C0A850819B
          9AC1FBDB5ED925F1295210A16CDA40DBB2182E85D378163B26ADEAFF16EFCE50
          44C707083F48E103821C2C932658EDF03082281C8F9480D5892BD159056B55B3
          4350AB2DF0B88127CA9E822C2E1732E55A6894C854C891E0F5090C48062741A8
          4E9B513F1CE3B5872321950AE588694E8AD2432F605477FB80D58D8EFA4EC8C5
          16F02B25C02DFCF0DDAF636B6C5AAC3633DB8FE45405D28A4B1096580884A401
          9EBBF0598DCA2D89F3797B8B90BA2D17925F7F843BFFBCC25FEE1F729B399B35
          7E7D41F61A99C380DA8A2E8CF50C4026B171F0047DD7F5E8A2E3CD14BE072610
          A141B7CA35F5526A6230940BDF08A8B480863E3D93C05C07E2A3C691FB84222C
          3A39235F15A278B12865BEEC4C3D2EF48DA1737B3E6233B2E20BEFD475F0EF9D
          B5559CA99C6DB9DD136CABD661D8E1C10C1D3FD6FB115EF9C17378F578259A05
          C150B39625D0AC87AD20034EF824BB529FDE2A81269BB6501B2D54804D07B8CD
          90C4E4232A772B7CDE50E8F5BDFEAA260C10AF9D7BB742EA1E1FF8665BB7FBFA
          892A4C585CB25BA3735C6B6A6C70FCD4113C73681B0A3D501C9D77F0859F36F3
          CD1E2F66998E9625402BA008C5786E6CE047DA5D07384849D93606DE495B6994
          A37230638940CDA94F83E7CF77D6FCF113B479FC02B5FA9666E8C2A283E31F5C
          C4444262DAF0F1E31F7EE7E08B87DED856925D1EEDAA2FDDF06452D9C6BD3FE4
          E6A78665057196C2A22C48EA74E8A677BD4B8D883FBC0BE5D15AAD02F2B5A4CA
          76D26F1F452FB5230533B3E13873AC66F8C36A5CEB1B174C89684113C52C95E3
          FDE03CFEF59B778EBE50BAE5A93F6834EAB8D8D858C842CA305C550D795C1442
          237C282C76C03EA3D6DABBED07E9BD568A5B8B09F41E4558B70B3FDB79E0FB94
          CA08785B2F1C239D50C7449240B2316DB4A0D5883B04CEAAAE17136063E6311A
          8DDCC4C4C44FBC5EEF4FC3C3C339954A050959A44C463AB40E21E00DC1CC8DBF
          636222888A2BF6EABF5E16DC51B0ED2F7C4082B2D8F48C38536F3B7AEA2A7943
          CFEC9CD70BF7B3CF47AFD33E9F0379F830C264C2380D88E0634C4C376FDE4CEA
          ECEC3CABD168CAD2D3D3095406A9540AA7D3499BBDB09946D07ED5037F80BA1A
          9C41EF38A6C8A0D819D45BCC2F2630390B9DC6315877AD7ED0F1EF2698757711
          0855C2F65B8F71C773A1ED05B129C9502A8599F652B89966366DDA144195D726
          262666A5A4A4404197809236D96C3621114E12C4333F9F43A83A12C3770DF8EC
          2F3B46DA07471C6211A38CBDC5045EFD33A6E8E37B1425144A8A11BB0B9327AA
          51C5F3977F9791A2DC3C64C6DCC2F8A4A5A5157A3C9EB304BA61E3C68DE0384E
          48201008C06EB70B0CAC5BB78E5AC183E35D90D267BB635BAFD9769A9D31BCE0
          904B45181069BD223EB3317193E3F5FFFE3C7E9C93E4D9DD6C10129BA46A5FF6
          FBFD4749682156AB156161617423F9056087C321B46096A449ECB04485C46A6B
          AB795D5BEBA8083E2932B96C0C211A8453CCCE2356EBA7719B1B9DC5DD909010
          537C7CFC5B74E09B454545F205B0CCCC4CAA54028BC52224313F3F2F7C6F3299
          D0DADACAD7D5D575545454D49056A6E9BC16B1059EFB19581CC7159E5DC9C9C9
          EBA8CA3354757A5E5E1EDADADAD0D1D181BEBE3EE4E6E6A2A4A4042E974B0896
          407F7F3F060707C72A2B2BEBBABBBBD9DF0383A2783B174C68B504EE5F12A2FC
          08A39C8094919191B874E912A6A7A7EF89777212274F9E048D2012121204EA09
          D875E3C68D4B57AF5EB591268668DBE7CCB0C4B1B58BEDBE77F88390A9EA189E
          E73F2665EF23CA258CD28686064168F72FAD568BE2E26233B5E5664D4D8D9926
          615AACB89D099A8D9CD8E2E5D5AD064EA3B535180C9E2625A7646767A3A5A505
          0683E1FFF6C9E572BABED5419A882BA4FC295160649F82D51A2998EFFBB0CA75
          BC52025C5252D22F08FC9DFCFC7C3973B5DADA5A30B52F7B9144C7D44FF3DE47
          3D6F26566C62C56D62C5EC05F76AC08B608B4AE379C99E3D7B7E493DFD646E6E
          6E3F898A9B9A9A42757535DC6EF7B29798D990F3397D3EDF67A4FA7E7A975153
          47C1AE5A26361B56B9FF5764802A0C27F17C4C877EEBE0C183D8BF7FBFA4B1B1
          11434343CBB325B321BA098F6F266003B1C428FF5CAC9ACD381BDFC0A3002F2C
          1929358B147D917A9D437D04D1EFBF78F1A28C39D9D2C55AC17C80E8AEA1CAD9
          2FD95F3AEC46EB17FBEC7F18DD2BB68068AF212BCD63B32D9A898F04C7514F05
          7698C8E886A3C7401581EBC4B1BA4ED120825BBF6CD5CB18A0FE6A0B0A0A4074
          32E563F3E6CDCAB1B1B100198894BE9390EBF510F02D0266404C64B7714FDD36
          AC30565F9A81EDDBB7EF26774B65B36D369B111D1DCD6C544A8CF034D3FF2153
          6122EBC13D913589E0ACD7C1AF0A2E24909393334DC0E5D46329733172307475
          75E9CF9D3B57A5D7EB4D22689DD8F3855E3FB6C5FAAC2E2F2F7F8DECF630D96D
          C8B56BD71A753A9D8BE8EF13E96616CAD4EE7D9CC04B1360FF3AADA1D8445180
          7BF7039B6B76698C3D4EBA574B802D66486A7CF1CF27F3EDC722B287ADFF01B4
          24ECF2542C678B0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002A744558744372656174696F6E2054696D65004D692035204D727A20
          323030332031353A35353A3136202B303130306934B61A0000000774494D4507
          D30A06141432CAF30E25000000097048597300000B1100000B11017F645F9100
          00000467414D410000B18F0BFC61050000071F4944415478DAA557CB6F137710
          9EF5FAB1B1E3D84EC8CB4D482824818662A0EF86B61740209028A887DECA8143
          FF048E3DA0DE2AF55051898A4A95904A855A242A1A357D41390009E40DE4E598
          04277E25F6DACEAEF7E5DDCEACD78243E23874A59137D9D999F97DF3CD6319D8
          C275E1C205A7CFE7FD84659D271209A14D510C0DA01056D5C23FD7AFFFD41F0E
          CFAFA19AB6159B4CB58AD7AE5DFB90E36ABEF7F95A774A120B7575356018063C
          7B9682C9C9394351566652A9F9F3972F7FFB17AA0B287A3576D96A94AE5CF9F1
          444F4FCFAF5D5DBD4D2E17077EBF1B5C2E27709C0B9A9B03100A7533D9ACB12D
          9BD53F6E6D6D8C4F4D8DCFE36B128AF1BF03F8E1879FBABABA3A0682C1573D64
          8F651D208A0AC462AB904A65415134703A1DD0D1D10A9264D82549EF4BA59E8D
          F3FC6A0C5F9737B36FDF4CA1A6C6F1554FCF3EAF2449E6894746C2303C3C07AA
          AA610A7428166D505BEB824387F6C3DB6FF7624A92FE50E8BD4F2391E9057C7D
          D242E2E510B87CF9CAEEDEDED7BE565586E9EC6C82870FC370E7CE182C2E2E88
          F7EFF70FCCCC0C8DD4D73B355D77B700D8303575E0F57A211E4FB50E0FFF3B86
          882DA219F1A5115859C99EDEB6ADC5861764B30578F0600A666723F28D1BDF5C
          E7F944065566EFDEFDFBCFF3E7BFF87C7939F04647473B72A21E53E20B04020D
          BBD2E9A41F755295B8503180D6D6B683F9BC004D4D01585E5E81683405434377
          FEB29CFF8E32512C16658ED33B755D7983DE29161970BBEBC06EE7BCF8671D8A
          A312172A06E070D8029224A3510361E5118535446561151FCD58F95D229F3E9F
          2F1D0C6E07068B9A656DC88F228A6CC3671C506E5E36053C9F17645943D6CB68
          5047C6AB48B4FD4D7BF69C7EB3B9F9950FB10D08ABABE9119ECF346CDFEE005D
          A7A0B113691AEAAB8605BDF1B20130E9749E57550503D010051D9B0F0767CF9E
          3BEA74BA8178218A129663FAB3999939431014A8AF67B1326C588E2A06A1900D
          EDFF0400140039090474B3EB793C1EE8EB7B9FA154F07C0EFB000F2D2D4EF0F9
          EA9942414184F258AA8D265245CA1BA667B3002AE6A7B191D332190173CBC2DA
          9A047BF7EEC44000C2E1A829F48CD243CD48D725246904B00B62C00EE3C081BE
          32012BFAD8B00F0C0CFCDE29CBB9EFF279872B186C42A85370F264087BC184D5
          841874AAA31826492945BACE20F42AA6C28755E07E1DD337178F2FCE426936AC
          8BC486D1C562F12F0F1DEA63A9DDB6B7D7C3A95307606262CA7C859C92101AF4
          4BB6E99ED24444C46A60BABA76DBBABB0F9EC3C9194285DA2D2170E9D2A5763C
          DDC5C3870FBBDE7DF7351BB5DA7BF7469078AC755A93A3C878D63C35DD53E911
          0AF49C0AC06E671945290692C9E5582693A0B2CDC23A13725D047239E1745B5B
          BB3393E15997CB018383C3782A82573761C702004130A0BF7F08AE5EBD09A3A3
          D3E8D0FE0232BA59B63E5F009BD88EBD6872074ACD7ABED6AD0259963FF2FBFD
          48BCBC79DAB5B5023698D2E929004DB3E194BC0A4B4B4FB0FF3743229184B6B6
          16D4791E04A1C1716E9C0D4D3D5600381B205F1502E8B49B4ECC714E8844164C
          353A1121404164B32A327ECA6CB90E470DEA79B047784C9D7200C4054D332888
          4634D0B411021B0550872B97A1AA00C964D6CC2F3927A1FBBA3A3B1C3972C66C
          BB74D2E3C73F40D48A2F9C9ED25034AB45D3E4029A745B7C63AA0900958AE2D3
          A7693D99CC990ECA8E4BA2A33315DE7A2B84F5DE8CDCA0499937FF5F2268A922
          28789A23B95CE6193C6F484635011892A44DC7E3191BCF0B269465F89FA3A063
          FE1398FB388E5E173C7D1AC35C735615940467013ACF31B1582482367914A5EA
          14609BED17455E8FC57206E5B17CF2B210488F1E8DE35E5863AE68F17816ABC0
          B03802260A8220133268E309951F4D4DB1EA006EDEFCF16786595BC01DC028D5
          B56EF1A0681A57141DC6C6464D87B5B5B570F06037129235EB9F9A51A120A348
          B89E4DDF15C51C398E6C14C0BA65188D2EF3F97CFA2B8E8B5E0C0603A6F372A7
          A3348AA200C78E1D835DBB769A44CC64440C2865D63F214673231E5FD6C6C707
          E6F085B085C0BABBE146B3401F19999D0F857A8E7A3C8D2DD864183A3D319C1C
          308C1D97552F3A92CD558DC62F71858478934CA6607CFCD6AFD1E8E338DABA65
          05A16C25000A58EDECEC4D23FC671A1A1A19849E29A7A0541945AB338255F33A
          22913756575330373736343AFA1B2EA4C65D34F4C022A1B1C500407FFCF8E162
          67E73EAF288AEFF8FD8D9406869C95CB8D2EFAA59CA7D339239188A1F389C1C1
          C15FA6B00F8CE0E3DB28CB50E1736DB30F93E2A347F746DDEE065510449C6AAC
          CB6E77994C275EE02E60A06306CBD1585A5A1227276FDF9898F8236A39BF6591
          AFE2C74935DF8644D46020D0F2414747EFD1868657F67BBDDB76620139655929
          64B3B1E9582C3C8FF95E5355690575C72DD8172DE71537A26A3F4E2908DAF1B7
          A3D070E940094069E32172D1A64C4383581F45A1B55DADC670D55FC796AE1385
          F67D0F3C5FB774EBA48225CA66A77EF1FA0FD7976E0F7516286E000000004945
          4E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000017352474200AECE1CE900000006624B474400FF00FF00FFA0BDA793
          000000097048597300000AF000000AF00142AC34980000000774494D4507DB01
          080C0016B1370B26000008214944415458C3B5977D6C9D551DC73FE79CE7E5F6
          F676EDD6AE5D07AC1B6334C1A9A323A020846850DE03467C4124518306E21F12
          12135FFE10342A1A8C09311283897F100CBEA146136248167538DE1646B7765B
          47D94BBB76EDBD6B7B5F9FB7739EE31FF7B9B7B7639161E2494E7272D39EEFF7
          FB7BF93EBF03FFFB12E7D9003CF7FD0FDD7AF9CF7BBE0BAC039C77BBE482D79E
          276EBCB8540E1F30869B639D5E6E52EB05913E5569E817566AC99EDB6F183DF4
          EAE209FFD7DB665F1AF9E0D6BE17FF76E0E9E0DBE687C02C909CEF4EE742C1F7
          3FFBD023B5C5A9C78606D6E7A5E311D496ED6C3138393D5F3F1C27E9C0AECBFA
          9E358591F409F5B2F9CE7D77F70DCB3E1C291F581E34BB1F1FFAC22FAEB9F3E1
          DF0135C074DEABDE2DBC4F3FB25B3DFAF067BEA1C3EAE3DD1B463CA11C1A2BF3
          BC3EB57C7AEFA1E294A3647F4FDEDDF191DDA3EB9F5F38941FBBF78ADCE6C206
          2A048C0D6D63BEAB34FCCCF8815B9EBAFBFEAB9DC6CCE1F1B7CBCB9D243A5320
          9E7FF4DAFBAA0D7D5362D2C1283603C0C6725DF7DF78CD15F97CFF8890CAA5BA
          70142FBF1EE5E5F1BAFBF10BFDF40C8DB270F845FED43BC1A68F0E530B434C9A
          22A4A4E079EC3D32C5C9D70CDF4AC6967EF4E46FEEF9C778E955A00ED836813F
          3F76DD578AE5F0A98DBD3931BC6507C33B6F43F9798450E8B04A797E92DAE214
          9B3F70076E572FD6A6A43AC6F1BAA995A6F9E5A9A7D976EF1867EB35B4D6586B
          B199C29E7C17874E9C627CCF325F2F5FFEDCFDDFFCFDE3C02410B553F089AB36
          7D4E0A716D4FDEA1545A64F6E83E366F1F438715745CC3CDF5D0DDBF151D5408
          CA7384E57992608524AAF2BD577E4AEEAE4B992D9D454A41A43591D6C45A935A
          CBF4DC1992D85273CBFCB1787C73BCAF3EA1637B0A68B409DCF1E1E1EB0B39E7
          8681FEF50C5E328AD22BD48AD30821896A25A2CA0251AD48542D920465E25A09
          846066E12895BE4166DF52BCFACA31BCE114D7554449D22420E0A537A6B86BF2
          22DE9F8CB2A9E29C393A33BBD858344781E57617A42948093635181DD1BB7927
          F36F1FC0EF5EC0A61A6BD3D56AC9CEC1F20C8385013EED75A3BC3C7BD36E7EBB
          BC9F7CDE2749341670534341BA5C3F388A900E6AFE60B1742836401E506D0252
          E2374B5180B5B85DBD6863494D8C4DCD1AE0E6B1790E57E6B13625B76E881E27
          47A516500BC336013F55889518D9EB1294E7393657974015580174A70FE48510
          0821410884F27094C0A68654C71D7F66598DDA6A4BA73AA26E144198508FA226
          012148A503B331EEF07AAAC5697C4776656D980069278182AB3270A1104290F3
          143A6E9C477D8797D85542E5B881490DD520406B83549246B5C13DE652E25A09
          AB63BA7CD50DB82D0B6811108E921B8400219BE0008EEB9226E179C12CE95A4B
          F50B4C9E3882B359500B03AC4D114271F15F351FBBF61AAA0B53A46982A3849F
          11906BACD8557240490142361949054262D3E4BCCA6D0719BF3080B6B0B73C81
          CA75116A8D6E68D27FC7FCEC8A9B89AA8BC4610D29059E23FDCC81D7448058A7
          435DBE6A830B2191D245C7F53560E70402BFB0817AF7363EFBF233B8570AEC91
          00FF38DC6247B8F7CAAB318D259617E748AD25E729A4106E86BB4AE0C9AFED92
          F5500F35BB21536E5384E311562B28D54C89311D05682DDD5D2E523A1CD8F777
          BE940E30F4A6CBF6C1021B768D22944B657E925AA09102A4102CD76200DD0A3F
          601D8085E568FD96C17C5E4A09649D9091494C4A72FE9AA3528FE953553EF5F9
          87296CDC8EE31758997D93A3FFFC15519C1244864A23A15C4FA83612BA7C873F
          FC6BF685AC0D753B02EBF2EE1629D7CE06CD7C0BA2C4E0A826219336D19514ED
          73B55623D521F9FE1152A3D1619523A7AA1457421C47A29A79A727EF92F324DA
          D808389E7D9ADB35B05549D9CEBD500ED65AA47248B425CD4C476681D3C61227
          96A56A442D306CBFAA42B03C0348A27A094709FA7B7D94144841BBABA400DF95
          16A8B406142733BF2DAD0E10198ACC4C324A527C5712C4862836D44383CE6AA1
          1E6AAA0D8D49424C12619280A85A24E7C936B092A24D3E4DC173B33C774E4452
          884B7C3793D7CABFE3B169E7ADECD9F7633201E43C85E74A725E330D4A0A82D8
          B074F2758A537B385D6C9098142525BE2790D93F8AAC081393E228A9B2365CE3
          0317B5C2DB9C5204D6689CDCBAA64576396442DAAAA4847E4FE17B92133367DA
          515152B4BBA6052C4496BE087C57AA77B4616AEDB0A32402D9CC57F63DC0A628
          29C879B20D7EAEAA8DBD7ECBC856815825DBFADD551248F01CA1CE3522E1B972
          A3E748A4EB23A4B3EA8480E74A3C47A1A468A7628DAACEA8B48A4D0A9C2C1241
          64A805BA554361AC6DDC390E3A805D9777DF3A5D0A46E1ACDCD43B8C727308A1
          DA4ABB7CB946D5B960ADFA11021AA1A1524F88756A83482F1C9BAB1F9E385E5E
          383253ADCD141BDA5A16802210B753F0C59FBCF6C0FBB6AEFBE44D6343B7EE5C
          0A6ED9B56B4CE5FB47B0A9C9FA78958C920237EB6F21A01E1A962A3161626C10
          99E2E4C9CAC103D32B67264F561A672B71927DF717B27D0658CC76A3B3089727
          4E54FE3271A232BE7B47DFDEDB161A5FFEF875A51D97DDF0204A0A0A5D4E1672
          499C18EAA1A65C4F28D793CAE95230BE7F6A79E6E0F1727D71258A33C033C069
          601E389B4DC041B6936C1EB09D0462600E58DA7F6CE5D45B73F5F17A641EBCBD
          F1833BBA7C45181B566A099546628AE568E2E0F1F2B1570E2F95678A8DC45ACA
          19E06C764729B3DA16609C81D90B7D9A49A0006C7BE8CEED5FBD6463FEF6C993
          95436F4CAF2C1E9BAD265192D6B310CE64A00B99B33532C0E8BF015EE8DB5000
          1E703130066CCD54CD64615DCABCBC05682E14F0BD3E4E1DA0379B60930E95FA
          1D03E2FF7989F7FA92BED0F51FEB97F127E49F0A7D0000000049454E44AE4260
          82}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002B744558744372656174696F6E2054696D6500446F203134204E6F76
          20323030322031393A35323A3139202B30313030E8DB41510000000774494D45
          07D30A0614160C39A4710C000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000007844944415478DAAD575D6C14D7
          15FE667667FFFD83EDC576FDB3368100162292D31AD42A4D645A41A382521E2A
          35ED4BE24411519A871621A4362FA86D5EDB3E558A7888D487A03C544A25934A
          28258190BA7503316B877AD76BE3F5DF9AF5FF7A77BD3BB3DBEF5CCF2C267522
          437ACD6166EFCCDCEF3BDFB9E7CC190D8F3EB46DE6CAFF8F45BE745CB870A175
          7575F565CBB24ED01E2F954A9E8D8D8DC97C3EFFFEFAFAFADF4747473F8E46A3
          2BBCD5DA29991D13B878F1E22F6767672FB8DDEE80CBE5C2DADA5A797171F16E
          3299BC699AE67A5B5BDB8F785B96447E5F2C160743A1506DB95C364832DEDFDF
          3F9C4AA572BC5EFA22B12F2350993F73E68C7EF4E8D1B3D96CF64D2EAA110024
          82442231353E3E7E27180C8668F55555552D3E9F2F40654002E8EAEA82A66920
          49CCCDCDA549E6DDBB77EFFEF1EAD5ABE35CB6E010D94A403B77EEDCCF28E7F7
          B9C8EE42A1D0C0B93081EB7B7A7A020D0D0D9A783E3333031281C7E341757535
          08AC7E07020164321950112187DEDE5E352F832A60707010D7AE5D4B5EBE7CF9
          C724749BD3EB72CDEDA09F3F7FFE65C6F74F5C548B4422E8EEEE5620BAAE2397
          CB616A6A4A3C01D55060F408E2AD2CCE1080CFAA755A5A5AD0DCDC2C2152DECB
          7519ADADADD8B3674FDBAE5DBB9EE33ACB9C8AD3CC0A01B27F9C60CACB783C8E
          B1B1319C3E7D5A2D2E565757073EAC80646107FCAB4CEE91214771448CE4DB39
          15A14D096C85006FCAF9FD7E256B676727A6A7A771E3C60D70732902DB2D2A2A
          7CD124EE727486732EE0866148586AF8B39EE67B8080F3B023697B7BBB524262
          2C73DB2DFA30E7B2B6AD806C8C6A27FC1502BCC12B37391E489CC54BC71E1578
          EB90DF54C16F7BEF7A800047C02120267B418C29A67637B3E26B9190351520EB
          080F5E898A4CEBF8399EE089C11B4222914340CEC3E1303EE61F9AA14221A111
          359C8DF930E7521B2494CCAC20F13C3601FE67E20F78063DDCE5DFD84A4049C2
          30A4F5347E3D7F1E89FA041A1B1BBF1609316288F7C6FD10E4A16BFBB43F0722
          01ADA1DCA0641760919E450856DEC20BA79EC15F06DFC613E5A77032721213E3
          13957DF1B0E1E01EF0DAE0CA4B170EE158D3F76ABF7B65F4839AB4B9A0158345
          AC7A5731EB9AC550660883A941B4EDAFC2A9234F62B830820FE2FF446F5B2F72
          AB39CA2AE959865972C12A1B2894DCB04A8620F19FA4EDFD5415F945D9959515
          F3D6AD5B9F125B6C4914F8AC90317F1A3956A72DE7C7F151360197EE825F3350
          DDE967450CA33614C062268B533D4F22D1318F37DE7B03671F3B0B4FD2CBA2B4
          8046F7A7F09453F058F7E0B36690D49EC5927688D2962A1B504C1495EAE7C45F
          4471238B2BEB53C5B2D951D2BC5E0335357E54B12005BD5E847C3E04588E2DBB
          3664F2791CDCDD8A5FBDD880DFBCFB5BFCA4A90F074A5338D6D18FEAC79E82BF
          E65B988B0D63E6CA022CB78E8D7C4E95713101F772CD818181F709BC66132193
          7E8C34159AE266D654B299A6A5A475CCB228A52DA310D94011CD7A2DBA0FB663
          1C09B88D6A041A3A50B77F1FFC610386BE81747A19B1D8A8AAA6945CC92FFB4A
          08D0910DE2CA1B31035B8A42DFC1BE81B98135681E1774978EB214236CBE2F2B
          655625AD8E2AD690B76F7F087378378ECE7D0783FFFA0485CC0290BE092CDF86
          B9368BB22E25FDFE5B5280A50CDBE55896923757D121007D5A9F7EB1E525C4AE
          CCB3E014E1F7B9E12519C370C3F01870333364CB86188EBF7EFE6FCC0F78F0F4
          E4D3F8E41F03585A26F1225F6ED608858D22BB9461AEBB14A0632C3EEA2819C6
          731D5BDA00550963B198E7C08103F8DDA137F1CECD77701D43A80B0711AAF6A3
          C874FB6657270EEF89E0FA9D51C43F2AE0F9C2F318498C90A80FDE0D0DE3FF29
          237A6B1DD38BEC944AEDC8B83AE073494D311ED88492BA2E61B19986FAD652DC
          B2B0B0A0DEFFB2BB83BB82487157EB3E1D6F7DF816CC7D2544272611BDBA8A3E
          FE8DDC19515ED55433A69E6FE36FB35D485B1D286941CE5B2CAB26173609EA7E
          A0B24A39E7732E1B57DB4AA0C9B941DAADDA5C2DC27561449A22A80FD563622E
          8AE5981BAF7A5EC5E8F0A892D259D8A8AAE36E6A80DF259EE62B5554BC7780C5
          361D8784C251E03E015E0C3BB1929B65D33925B4C45C9EBF53C22FAA5EC3D8C8
          5865B1AD2FAEAD5EAA3D6583CA9CBC03240DE548CBD30ACE0BD82150E64E8D33
          04FBE559E97A1C2242C0BFE4C7EB4DAF23194F6E7A6C18FF03EA7827BF454569
          5CF96C99E729B65F9F4F4E4EA698921962984CC9146FBD87CDC6B4B21B1BD980
          9C3E7CF8F0B3EC807EC07ED0C5FE4DBD012F5DBA0476BB8ACC56491D0F05503C
          A46202788FBDE36D76CB733C66D9BE49AA49FF97B26D8E366F9B7C3F547AC225
          B27C8F36B477EFDEEBE974BAEFC89123FB8E1F3FAE7A01C967278D04901F230A
          949EAEB23F1C2260922DF7FAF2F272C10614A069DA2C8D454275C039DB8454E5
          C3C521200FCED016D9864D52B621029D21C049C90C558649842DBB45AF8609C6
          CC8DAD50D222255DB101A7EC35D276A975009D6F806DBF94B6FB30919D247D5B
          E78913275EE1F7C00FD9EB47272626E6992145125BB7254CDAA029BBB2656DC0
          8DAF02DC0901675EBA96565A37ADC3F62A69CBBA68D7720770C7DF823B25E00C
          0991B4D1013B768E97A67DFD91401F95E8437D49EF74FC17E5999A08FEA54507
          0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000A4F6943435050686F746F73686F70204943432070726F66696C650000
          78DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A
          2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807
          E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C008
          0C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173
          FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA4299
          5C01808401C07491384B08801400407A8E42A600404601809D98265300A00400
          60CB6362E300502D0060277FE6D300809DF8997B01005B94211501A091002013
          65884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0
          B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2
          573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE4917
          2B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE
          0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C
          2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370
          F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E
          3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FC
          B70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525
          D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F7
          0000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E
          44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC60
          36844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C0
          51688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA88
          01628A58238E08179985F821C14804128B2420C9881451224B91354831528A54
          2055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB5
          43B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA
          8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB0
          56AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8
          201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C
          23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E52
          23E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE4
          21F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52
          DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D3
          1A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D8615
          83C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F
          996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB
          548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67
          A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C21
          6B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B3
          52F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB9
          31655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C7
          4A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB44
          77BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C58
          06B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E1
          8491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4D
          EE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79B
          DFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB3
          46AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D8
          06DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB
          1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B6
          13CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8
          BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F29
          9E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F
          9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7
          C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02
          FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8
          EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C278587855786
          3F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A
          3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBE
          DFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A9640
          4C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D843
          5C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B
          3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC65
          85B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267
          655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5
          864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD5
          4FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED
          5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCA
          BF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB4
          0DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54
          A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BE
          DB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D2
          03FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D
          558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F
          6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C5979
          4AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A
          0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F
          6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDD
          F4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD977
          27EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47
          F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA7
          43CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7C
          A5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4F
          E47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB00000006
          624B474400FF00FF00FFA0BDA793000000097048597300000B1200000B1201D2
          DD7EFC0000000774494D4507DA0B19113B3BB5ED73B6000003984944415458C3
          C597BD8B245514C57FF775DB5FF3D53D63BB2E8B8289C8AC8BC8B24CB491BA0A
          0A42BB080626626864A20C6B266E2046821328062222C8A88189FE0D66B21A68
          ECAAA32E83333B333DD5F718545577754D7575AD38FA8AA6BB1EF5DE39F7DC7B
          CFAB3649A4A3D57A8985669F5F762E4D26AB0E459BDFFC70E53A0221247029FE
          ED2081E448F0D8436D04AC7697B12C81741C1F7DAA505B9F83E8400444F8E827
          B01668F8E6D7DF3FF98600B9E3025222122E908B27D63B6302A11CE4B0E0731B
          B18FB48FF417F23F1007401DAC71EDCAFA57AFCA85640968AA460C9E0FB89480
          1865A2F5644E5373E208E431015A982DBCF3D4C35FBC9C02CB13121EAFF49CE0
          33084419C05106D8312CB3D4C764CC9A98D51212BDF79FBEF0F10B52FC84D214
          784CA4B202400630376721891AB03A6667C0BA98DD959038FBC9338F7C74551E
          038FEB800A04E2A82792A7B22B734D96C7242CAC61D6035BC6AC09B648B07B3E
          7BF6D10F07CAA4432E7ADD6556BBCB650A78E5EE336A401DB325CC7A98AD25DF
          6DB0552C9CD91E5CFC60209F74438514784512F9E5C3047C05B33E666D82DD8B
          596FFBEAA5F70612882A45A82877EF49A5677E6B423256A193002FC5E0610DB3
          3ED822161E80B0BAFDFCC6D6C07371151AD1F0704BB5FA45A4E30265A6AB1F0E
          91DF42DA41DA05EB80FF0956071A58381B13A3C968740369E7B956E7EDCFD31D
          EBB3DBB008305B1F99796B002DD001680FB13FD65AD14DC4519C8EF020106DEF
          ED5E585A5CF96EAF944091099D243389C3580073A08DD94A61BDC86F8275A8D5
          CE778F0EDEBADD6C6F7ABDB80D55A11BB2A402580363258E16031A893A615C3F
          56EBE3FA19F7DF7EFDF6C68B7E79636E1B167DE73F2171C0065807B325B0C538
          2DD68953639D64AE0338AF6F6D1E5FDEB8AFA4061425ACA3CC233EA71DD3F434
          4A140BA088775F7BBCAA0F4415ED2855216099AB784FCF55CF1D1991CFE01DE2
          96B3E1D49696499DE4895F5422104D4CC7BCA255A7F20760984B4B9814644ED5
          D222CC1E4AD30BCB7CC173E09E8BB38A02639B3D049A85E7FF5464276A259BC2
          7AE6FD62D292A504C6262427AE25A7FAA9E9A52D3D31B8B92988EE00745E21FB
          CCC2AE57DFA0EC500A33CE8DA267A3AA5D90BC746A37F6F952253CB1DCCCE619
          0B9676FF890F24D9D11031ACF0C764CEFD8C1486F987CDE98E12055A5838770A
          90252930B33ED038D87B85E8F8CB133DFB6F0D33BB1B1849BA75E295CCCCCE01
          F79FB2F23F4AFA7DE63BE17F3902FFF3F81BF2A2EC97A623DC1F000000004945
          4E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000A4F6943435050686F746F73686F70204943432070726F66696C650000
          78DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A
          2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807
          E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C008
          0C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173
          FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA4299
          5C01808401C07491384B08801400407A8E42A600404601809D98265300A00400
          60CB6362E300502D0060277FE6D300809DF8997B01005B94211501A091002013
          65884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0
          B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2
          573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE4917
          2B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE
          0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C
          2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370
          F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E
          3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FC
          B70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525
          D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F7
          0000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E
          44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC60
          36844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C0
          51688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA88
          01628A58238E08179985F821C14804128B2420C9881451224B91354831528A54
          2055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB5
          43B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA
          8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB0
          56AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8
          201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C
          23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E52
          23E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE4
          21F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52
          DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D3
          1A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D8615
          83C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F
          996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB
          548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67
          A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C21
          6B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B3
          52F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB9
          31655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C7
          4A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB44
          77BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C58
          06B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E1
          8491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4D
          EE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79B
          DFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB3
          46AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D8
          06DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB
          1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B6
          13CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8
          BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F29
          9E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F
          9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7
          C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02
          FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8
          EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C278587855786
          3F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A
          3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBE
          DFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A9640
          4C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D843
          5C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B
          3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC65
          85B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267
          655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5
          864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD5
          4FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED
          5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCA
          BF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB4
          0DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54
          A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BE
          DB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D2
          03FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D
          558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F
          6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C5979
          4AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A
          0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F
          6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDD
          F4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD977
          27EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47
          F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA7
          43CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7C
          A5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4F
          E47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB00000006
          624B474400FF00FF00FFA0BDA793000000097048597300000B1200000B1201D2
          DD7EFC0000000774494D4507DA0B19113812DC72B819000004704944415458C3
          C596BD8F1B5514C57FF7CD78C6DEF56E9C4022A1283434FC07545450512634B4
          887F0121BE5AA8A04182028992265A0A0A5251D1215141114008814891005A65
          B5D9F5D7DC43F1DE9B193B8E778BA03CC9F2783CF3EE79E79CFB6192C86B387C
          9DDDFA3237BF7FB7BB79CEE5E29DD974F92102212470295E3B48203912BCF4FC
          08019726FB94FD4DA6D32F00F8F6F67D9EB9BCB33992F2570C2277EEFD7B4C28
          AA0FCAAADC59CC16EF8B2E18024948C205F2D5B3959BA31800F3469BE34BB88B
          A611F3F982F9BCA1D82B18D0BCE78370B898351F4BD682886CC4E07DC601C266
          3A453C451734BFD6BE2F70394D235CC28A82A6AEA807C5475684375C99A1F8BF
          3CEEB946C066007817A91F508059BC6706264B40455DC020405357EC8ECACF81
          D7A4BC5592C0F590049B1948E71520EB18685F0D86CC20180684605CD929D8AB
          8CAA8820F6C6D597925E95C7C09E41700E0072E17DD195B58FA789BF0D331208
          63320C4C8605FB55A02E40A39ABD717D53D275F5E4908B8B937D2E4DF6B779A0
          173BF921CB21ACE52782304208EC5781496D5C180626C3C0A8348AF190BD717D
          20715D4ECBC2D90C64C40299AD9A30FBC20C0BF11F1904392C975CAC23984BA3
          08A29EEC30DEA90E1AF97509D6F36A631ABAF71E543C69B2E0AA29659805CC02
          F520605612825186C0702102703875786A97A6F183A3E3D90D175F9D092033B0
          6A184312669668B4F8094651167CFDC33DA6D33975193899CE08160865607F7F
          4435ACB870654CD3E8E0E8C1EC0674201E5907FA9AA39EFE3978CA8E60462802
          6519288AC0E9DC99CE9D93D992E30773EEDC39E497DB77F8FDE7BF286B188FAA
          83B73FBD35DECE80A7B20958AAE98681095794C37A602C04CAAAA0A6625039F5
          CE2073D61915383E3A61301871F5CAC5C937DFFD76F2CA8BCF79B9BD125A523E
          1B315F59EB66195892A10E05CDB2C1CCB000C102B2CEC13BBB35F78F169C1E35
          77F7AE55BED584BD44C353E543E0A94FB43DC38C604E51048AC2086568A19AE5
          BE123730817CCE9F7F9F2EDE7CE1DA7613BA60D988B2B0B6F3594691D2D31248
          428852B953044B9C45704ACF37184588EC7EF2D6CB67A5A156BA580EE5EA0491
          D44962012B72503A8E949D90D2591DBBDB01A8578CC89530762103DCB211538D
          B0980D50609653D4DB46E2267CE9B18748E72944C293D1FACF1B86A3AE0BA6B3
          5A92288448BB7BE22644D041D117C1C239BB61AAB74D5B05734FD04AB75CA994
          16EF2BB1848574800021F165D09CB71738C662E92B01F2A9B3371C21B32459D7
          3573138BDA643F8960C65AFC2DA5380D930ED8FA5BD9FF6AF380AC3CBD4E6AFD
          A92AC9E63A67336AB4DA01FB94C7F44AD9B0362FF681786F826A8758F93918C8
          B99E67016D984CAD67D0764EEB0D2FBD06460B02D6E23F7A22CA7560366D7ABA
          E653AA774D5796D51FDDAC4DE1D393254DB33AE89EE101F0544D964B67B9741E
          CB52D769B733B0A6EDE35A9BF67C0403C6A8304617AAC70F629B04667619A83E
          BBF5073FFD78F721BA1ED732B3A78146D2A1ADD76633BB0A3CCBFFBB7E95F40F
          B1C68827B9024F78FD0781C01EEF6D92A5F50000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000A4F6943435050686F746F73686F70204943432070726F66696C650000
          78DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A
          2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807
          E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C008
          0C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173
          FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA4299
          5C01808401C07491384B08801400407A8E42A600404601809D98265300A00400
          60CB6362E300502D0060277FE6D300809DF8997B01005B94211501A091002013
          65884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0
          B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2
          573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE4917
          2B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE
          0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C
          2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370
          F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E
          3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FC
          B70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525
          D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F7
          0000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E
          44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC60
          36844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C0
          51688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA88
          01628A58238E08179985F821C14804128B2420C9881451224B91354831528A54
          2055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB5
          43B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA
          8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB0
          56AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8
          201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C
          23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E52
          23E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE4
          21F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52
          DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D3
          1A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D8615
          83C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F
          996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB
          548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67
          A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C21
          6B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B3
          52F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB9
          31655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C7
          4A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB44
          77BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C58
          06B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E1
          8491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4D
          EE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79B
          DFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB3
          46AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D8
          06DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB
          1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B6
          13CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8
          BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F29
          9E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F
          9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7
          C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02
          FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8
          EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C278587855786
          3F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A
          3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBE
          DFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A9640
          4C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D843
          5C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B
          3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC65
          85B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267
          655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5
          864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD5
          4FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED
          5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCA
          BF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB4
          0DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54
          A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BE
          DB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D2
          03FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D
          558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F
          6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C5979
          4AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A
          0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F
          6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDD
          F4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD977
          27EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47
          F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA7
          43CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7C
          A5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4F
          E47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB00000006
          624B474400FF00FF00FFA0BDA793000000097048597300000B1200000B1201D2
          DD7EFC0000000774494D4507DA0B1912043078A73E5B000003ED4944415458C3
          C5974188DC6414C77FDF976F32D9ECEE981DA78B54B607B12022581129148B48
          F528C2D68B57F1E8C94B51F456100F9EF4A61EF522DB8B770F1E945E6C2908CA
          825041A175D55AC7713B9BBCE7215F3299992413B0D5378449BEE4CBFBBFFF7B
          FFF77D31AA4A6151F40AEBFD637CFCC7F9D9604713F4CDFED593EFA0A028AA20
          AAF9B9802AA80AAA70EE9135141826034C15406197B8AC0F335AE1D020FEF703
          07843852E46274E5E4DB0AA808A2400144155150519E7F342E01D8BA975B0C00
          8748CDA14C48993065CC949BFCC90401221CF6ADDB4FECBFAEA2A81AEFB46023
          77BE18702D8014413C88DC8C3F40C84A0E5284940C618A031C1131F6BD5B4F7E
          FF6AE158C5831045C981AC0400AE664C01832528A7E64C590425C4E20870440C
          E87DF8CB53DFBEAC0A02689102C981AC0420A4FE5F10B4CCB52015468AE982C5
          709C98018107123162EDD31BA7F75F52C91D97754027005A71E62BC99FE72928
          D8502C064BC8907546AC91D027C412B2C688E0B39FCF5CDBD54A3A5494AD64C0
          3019B40108E6C0B499A58FC390B049C23A093D86F489E9111333627DEFA7A7AF
          EDAACCD4D0818123CF424EB740C947F5BC787656BC19231212FA8C0889091872
          1F4392BDEBCF7CB3ABCA52380D009AD25257AE0E8B21222261930D62B64918B1
          C1366BC4046C1333626BEFC767AFEC8AAC2E7704E723D5251016B3306E09B17C
          C497DCE6909880DFB88D23C291F100F7B3418FE36C92C2DEF5735F9F879D4BAD
          0052EE944CE452D34A1FD085080C0E4B88232460CC111326C00480036E31E12F
          62D67988130C19ED9DE2CCE655BE1AB73050955C7E6DB17E447CDC41D9AC1C7D
          22328488881E1B447E660604581C16E126BF32608BC7389B7CC0E793D778411A
          00F49754209E8FD978E659C9A185381C0153DF1772603A376748C401CA98C98D
          C72F9F124EB730309F7353BE74BE45E3FB80F1C5687128C211961E76A9E95884
          313BEFBE7874F6C24E5B114E11604A46485016A46D50470E202025C36181B002
          58E794957287F72F3CC78A223C9A9B686BF4BF18996BBC67BC84D57752ED22C3
          A2FF9B52FFC58BAA91D94A3AAA2072AA6561EF90FAF1B4DB5A308BBBB9072C47
          13E008E69C17522DEE775C8C7247E99C332927A7E59E60317599076A7DB4A6F6
          99CECBF1614D3F9807B4DC37AA4BB7F54C16E9B4350B5BCB723CBFF7AB033173
          6796A295A5CE290D696B0090D3290DDAD75A7A9B4198F2E8980269DD0BD439EF
          6E4137060A9B90122D4C6AD37BDDF59869B9D15994614B1FC8A39C92325D98F4
          6FACA30C0F576EC5EE963574D03E310131F15D77D8AA0263CC31207C433FE10B
          BE23E5EF7B12B531660464AAFAFBD2B7A131E641E0C43D667E5F550F80FA8FD3
          FFD22CFFB3FD034A242990CC7EF13E0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000A4F6943435050686F746F73686F70204943432070726F66696C650000
          78DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A
          2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807
          E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C008
          0C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173
          FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA4299
          5C01808401C07491384B08801400407A8E42A600404601809D98265300A00400
          60CB6362E300502D0060277FE6D300809DF8997B01005B94211501A091002013
          65884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0
          B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2
          573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE4917
          2B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE
          0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C
          2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370
          F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E
          3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FC
          B70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525
          D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F7
          0000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E
          44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC60
          36844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C0
          51688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA88
          01628A58238E08179985F821C14804128B2420C9881451224B91354831528A54
          2055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB5
          43B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA
          8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB0
          56AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8
          201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C
          23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E52
          23E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE4
          21F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52
          DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D3
          1A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D8615
          83C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F
          996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB
          548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67
          A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C21
          6B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B3
          52F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB9
          31655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C7
          4A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB44
          77BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C58
          06B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E1
          8491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4D
          EE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79B
          DFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB3
          46AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D8
          06DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB
          1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B6
          13CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8
          BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F29
          9E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F
          9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7
          C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02
          FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8
          EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C278587855786
          3F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A
          3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBE
          DFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A9640
          4C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D843
          5C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B
          3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC65
          85B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267
          655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5
          864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD5
          4FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED
          5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCA
          BF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB4
          0DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54
          A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BE
          DB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D2
          03FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D
          558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F
          6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C5979
          4AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A
          0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F
          6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDD
          F4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD977
          27EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47
          F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA7
          43CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7C
          A5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4F
          E47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB00000006
          624B474400FF00FF00FFA0BDA793000000097048597300000B1200000B1201D2
          DD7EFC0000000774494D4507DA0B1912032BBD836170000004134944415458C3
          C596CF6B245510C73FF55ECFF4CC24643BB393202EABC222C8E2C1936659F6A4
          FB0F442F5E45F0EE45F0D749F4E4C9D3E26D112F12C18B67F1A00644C1832BEE
          41F0B22E899B88C9243BE9AEF2F0BA7B7A3ADD994176B5A0E9F75EF7ABFABEAA
          6FD52B31330AE9F55E61295EE3F627EF4F171715E5CD6F1FFFEB030C0CC30CD4
          2C8C15CCC04C3183E79FEA63C0305941AA000AB9F745664B97E46C7B0A2888C2
          D16F86758194F7BE7962FF1D034C1535A00062861A981AD72F0F4A00AE517BBE
          9A1E9F7E4E8E211D838E213B80FB3B463A86D40422DE7EF6D7E47553C34C72A3
          853782F1FA819B01A490E9749A1F0408270610C0D2F0AF992111645E88067CB8
          F1CBEAAB8561D31C841A4600321F8009F5004801C44D4189030DF1C777C11520
          56F8F8CA4FC397CDC2772B42A001C85C00A59B142C8F75F954BCA18502074B8F
          426F2500C9BCD01DF1E9C68FA3974C83E192072C12828A31C99F72ACE1AD8073
          418388E087D019419CE4203A426FCD3EBBF2C368D32AE1303556931586C94A3B
          00CD64164C8B1860224804FE9CE013E826D01B426700DA17FAE765EBEAF7EB9B
          A6D36C98EB01B190BBAAB933F231B5F14CB8003911FC79A193407F04F1006455
          8813B7B5B1BDBE6906C60224546D0E4BD3BAF312B4F440129065F0EBE04710AF
          433408F3A5A1DBBABAFDC8665D476321BA7B536DF932E8A4A546E8145436063D
          3426F760F2B7110F60BC67445E908ED15B77B865502FDCFF1DC67F662F3EF956
          E7F3B3B320B3D21356AF05F51344401488E7BB707C009323637CA01CEE19FBB7
          32EE7C9DB2FF5D8AEF184B89DBFAF2FACE72B13F9A9705C55C5C0054D0D35C9E
          A2005E703D2352C1C7E097DD8CB3FA22780747BB4ABCECB870A99FECDE38198F
          5EEB682380AC92055618AD9F5C2B5E71605DF051085BECC27E1FCD6E3B37741C
          ED089343BB7BEB993FF41A17CFA8039577910DD52C28C9E482779C175C2C485F
          902EB858A023B8CA432CA070F3E9ED936BCF5D6C0F41289B423609712DAAA1B8
          16B02ED794865383206E9633AAE137CB8C8FDE7881333960998186FBC072C3A6
          9598D7EB460EC06A45AA4A84626F5D4733009DE6BD2F36BB6AF1AF8DEB20F27F
          A512365150C7629530D3A9FEF21ECA17CA8A58E7469E922E9ABDB48C222C79CA
          EA0295D0B240962C6DAE849AB670369D02A592A6559B69BA503F60654754AF07
          8DA5596B995321AD56FE6D22B16BE34091FFA6ED205CA567A893AB98573BA822
          BC7349986970671B73EB5571063835F2E5EBAAE0F474F8DAB3A0A2B0F5FB197D
          42DBD89BCC075075733606D73B7D1136D582AAA7AAF3EC600A3CABA561AB074A
          C64F5AAEE57F21AE219CAD4DA9290F5C9A5446CD2D99D01D4077C04347310340
          44D680EECFEF4EB8F395968DC983161119019999ED9D6AC944E402F0180F576E
          9BD96E6B4FF85F8AE37F967F00599C63FD808B75C40000000049454E44AE4260
          82}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000A4F6943435050686F746F73686F70204943432070726F66696C650000
          78DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A
          2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807
          E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C008
          0C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173
          FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA4299
          5C01808401C07491384B08801400407A8E42A600404601809D98265300A00400
          60CB6362E300502D0060277FE6D300809DF8997B01005B94211501A091002013
          65884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0
          B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2
          573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE4917
          2B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE
          0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C
          2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370
          F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E
          3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FC
          B70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525
          D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F7
          0000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E
          44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC60
          36844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C0
          51688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA88
          01628A58238E08179985F821C14804128B2420C9881451224B91354831528A54
          2055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB5
          43B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA
          8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB0
          56AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8
          201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C
          23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E52
          23E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE4
          21F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52
          DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D3
          1A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D8615
          83C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F
          996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB
          548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67
          A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C21
          6B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B3
          52F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB9
          31655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C7
          4A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB44
          77BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C58
          06B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E1
          8491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4D
          EE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79B
          DFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB3
          46AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D8
          06DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB
          1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B6
          13CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8
          BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F29
          9E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F
          9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7
          C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02
          FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8
          EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C278587855786
          3F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A
          3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBE
          DFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A9640
          4C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D843
          5C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B
          3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC65
          85B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267
          655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5
          864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD5
          4FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED
          5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCA
          BF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB4
          0DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54
          A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BE
          DB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D2
          03FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D
          558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F
          6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C5979
          4AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A
          0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F
          6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDD
          F4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD977
          27EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47
          F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA7
          43CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7C
          A5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4F
          E47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB00000006
          624B474400FF00FF00FFA0BDA793000000097048597300000B1200000B1201D2
          DD7EFC0000000774494D4507DA0B191202302EFD99DD000002C24944415458C3
          C596CD6A135114C7FFF7639249822516CA2C822DA268F005A44A2B7EBD407463
          96E213B8537427B872E1DA7D36121FA28B3E8422B4E02634908D486A66CEDF45
          72A7D37192B9B14D3D30DCB9778639BFF33D8A249C84E17334AA1BF87EF8EAE4
          D05348BEDE3FE47B1020081210727A2F000990021278D8AE8100D69B6B505900
          27A3D188611896294CD7E3E36368AD2122EFF60FF99600280221000742420850
          88C7B7EA29805EA444440AAF2449D2358E63880800406BFD667B132F2904A966
          4A9D37A6CAF3066B1F2B179DB9BD520A4A2918633EDCD9C20BA7983283108298
          829402903CE5E2BCA2221807A09482B5F6D3DD2D3E2301C97C4F640AE2ED81BC
          C2FC59F6591004D05AA7104110F476AEE22965AA38CD03D0CF03F3BC91DD6721
          8C31B0D6A6105A6B586B3FDFBBA63ACC8483425C6EAE61BDB9E6E7011F99C53E
          857020B37DFFFE75DDA19C54C3522158263C24618C71D6A7AB31A6FFE086EA90
          403EADB56FF62F7A2F5301A917B221A9542A30C6F41FDDD49D59C59E1851A46C
          381CB256AB9582B87C70FD20491268AD912489EB0B298C520AE3F118711C3F69
          B55A5F16021C1D1DB15EAF7B0388480AE080F2EF28A550AD562122188D4697DA
          EDF64F00B0657D20EFEAA27EE0B23E9B074512C731B4D608C3B039180C7E4551
          2476D94E38EF992B3F114973222FD65A4C2613C4713CF87AF05BA268C92A2802
          CA7640577AD95E90BF00E063FF60B273FBCAFC1C180C066C341AA9353E60BE95
          331E8F1145913A973E50D6B27DC269CF6A918FF285B953F6B3B1CC87E7255F16
          74E9565C045356A245653A4F4AFF88F2103EF78B262ACE7316FC8B7887609510
          67FA273CABE5F96FDA32C56EC2F994623E09DD5E44E6E681F521CF4EB70B0DC1
          45885DD45482205879159C1A46BD5E6F0340657777F7C72AADDEDBDBDB009074
          BBDDD15FD3B0D7EBB5006CAED8F3DFBADDEE70EE38BE48F9EF49F80753BF305B
          3432500F0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000006F54944415458859D976D881D5719C77FE7393373DFF6EECDC6269BDD
          CD26DB24776BE98726161A04514B5A84548A2BF5434DA1420B52B414EBA7A282
          1F34D62A12C10F450B491BFCE0D2A646B06949AAD2A628C18434695E9A7435BB
          25BBD9CDDE4DF6BEBFCD1C3FCCDC99B97B371A7BE0B0779633E7FF7FFECFFF79
          CE19C56D8EFCC30727C03C80A8ED0ABD3997CB6C0245B1549D31C6CC18DC335E
          BBFEDED49B4F1D02DA80773BFBAAFF01BA06F85E369B7A7674F88EDCF08601B2
          9914F516946B2EAEEBA1058CD766B954A370B3CCE252B1D86C945FAA5C3BB96F
          F6C4AF1700F75311C8EF7E65229B4DEFDF7ECF586E74641D57AF37985B6AB170
          B3DDB5CE047FFB528AB40D491B6E2E97985F2C14EBA5D967A68E3C3D09346FA5
          C8AA04F2BB5F3DB06DCBD013F7EFD8CABFE69A4CCD3668B54DD71A03A054F706
          0A94F28924C463F1C612A5E2DC6B97DED8F32450594D8D1E02F9DDAF1ED8795F
          FE8991E10D9CBA5466B9E21287EE00DF379E0114A72E97A36DC2DD14A2202550
          AD15B959F8F71B97FEF8F893407125097D2BF0E3678B541B5E0FB8528AE7BE31
          CCF37B36F2D5CF0F904D6BFE7EA102A24029104129FF770B856527B19CCCDDD9
          B15D77152EBCFE16D022CA1C1281BF32B16DCB5008DE6A9B7095018C52FEC6C0
          F8682A24353E9A0251A8CE54416A8267572974AA9F646EE3D7C61E7CF19B4026
          8E2BE0BB3D9B4DEFBF7FC7564E5D2AF78087B9568028E6969A2181B9A5162AC8
          BD0F2A880E7EEB6826B36BC90CDDFB426EEC4B77024E570A3E33FEF5E777EED8
          F69542D9E2EA62AB0B5C85E02A9CA73EAE32BDD0E4DDB3255E3EB288128929A0
          7C4594446951FEB3D6B663A5D6EBA58FFE741C6800C602C86653CF6E1C59C7B1
          7F2EF7444E081E28A114E5BAC79B279643A9FDFFC74986CBBB0C64A7FB480E8C
          3D06FC12BF2AAA56FEE18313A3C377E4AE5E6FD072CD2AB2479B3EF7E810E31B
          9311A9607CFB373360149E31412912FA25945A140A839DEEEFDBBCEB278F4CBF
          F3C3FD40DD021E181E1C60A6D08A5607114491FB1B8E6F4CF2B97C8695A352F7
          50A290C0842A7C275AD3F20CCA80A82489DCE84E60122809C2F681357D618733
          808AD775207BBDE9F1E38357D9F3C2540F016D099625E8CEB43596EDFFB66C8D
          656BB425284B483909ACF4DA3C90066C4BA13797AAEEEA7947516B7854EB7E3F
          383F5D47746FF3D496440A04465C990603600C8E12B49DDE0024006DE572994D
          955AD49C3AD2B75CC372B9856B4074505A5A215A5839C4122446403AD5D02161
          FCB236066C6D48A4FB07F14B515BA0687B5E57F4E5AA4BB1EA225A85352D2221
          408F020141D1FE3A2531051461DF339EC1714C27080D88552C5567B4329B3AD1
          2F155BD49A268C42547764B74A8104EA88F6DF8977455F7D83F1209332D46BE5
          85CEBB96C1CC286536A1E0FA8D268D96893A9910E65482CE26AB291010E828A1
          4410892910C86F3C4322E162DA8D79FC43C9B38C71CFDC58AE7CA159D7D41A9E
          1F61CC44518B255060150F68E5BB5F4BE887B033121148DB86B6DBA2555B9AC2
          BF23B862DCFA7BB3F3456C7163A071707AC8ACE601DD558682E5686C5B63399D
          290C648552B949BD70F9347E2B76E5E33F3F75A852AD163309850E365728E21D
          4DC5225A05DF8F3A883EAA7DC1722424904868D66635F3D7CB952B477FF437A0
          0AB4046837EAC597EA8D2AFDA9286F2A6210457F0B053AE68CAB6005D1DB8112
          1B063485A53AC5D9738703F00AD016C0AB5C3BB5AF5A2915B30983ADBB5BE9CA
          D97DC2F8232CD31809CB8E4864FB34EB7370FE62A132F3D7BD93C03250033C01
          983DB16FA156BAFA4CBD5124EBF8D1F7E02878F9BBA39CFCC5D61E0247BF3FC8
          8B8FE6A23405E9B06C4D32A9C90F693E3C5FE4DA07877F559D3F370BDC083C10
          DE4CDCA9234F4F36AAD75FC3AB92D181130225FC93F1BFDEE083F5BE47444044
          B01DC5DD239A99E932174F9F3B76E5ED1F1C03168112C1DD30BEAB007DE313BF
          3F60A7374DB82A4BDB5281B17474D8D891C97468361DE5DC162CC722DBA7191F
          D25C992E73FCE8C963677EFBE05E600E9805CA04D7F4F8A5D400EDC2C5436FAF
          CD3F7497B69DCFA212D069C13ACA73BC358B084A4B6844CB1206738A917E8FD3
          1FDCE0E4FBA78F9DFDDD437B8179E05A1C7C25810E8956E1C2EB6F6506EFF924
          91E9FF224A3B4A3B6809CA347626C4CF87FE94B02EAB1859A3282E5578FF1FD7
          2A1FBDFB879F5F9AFCD6811878CFB5FC5689D5402637F6E53BD7DFFBF8779C35
          5B1E13A7AFCF49A448390912498D9DD03809219D12920945DBF5582E37999F2F
          558A73E70E7FF2979F4D56E63F9C0D725EE0763F4C5678C201B2C0C0E65D3F7D
          24B16674A7951AC86B27BD2199EE1F5422D46B9505E336E65BB5C2547DF1F2E9
          589359C6777B89FFF7D36C153512400AFF4E9F0E9E1DA214BA014883A8C9D482
          E74FF771BACA10C002EC00581395B11700B9F85F3EB7FD79FE1FB6DF73FB25FE
          7E4F0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000A4F6943435050686F746F73686F70204943432070726F66696C650000
          78DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A
          2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807
          E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C008
          0C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173
          FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA4299
          5C01808401C07491384B08801400407A8E42A600404601809D98265300A00400
          60CB6362E300502D0060277FE6D300809DF8997B01005B94211501A091002013
          65884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0
          B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2
          573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE4917
          2B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE
          0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C
          2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370
          F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E
          3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FC
          B70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525
          D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F7
          0000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E
          44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC60
          36844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C0
          51688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA88
          01628A58238E08179985F821C14804128B2420C9881451224B91354831528A54
          2055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB5
          43B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA
          8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB0
          56AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8
          201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C
          23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E52
          23E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE4
          21F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52
          DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D3
          1A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D8615
          83C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F
          996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB
          548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67
          A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C21
          6B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B3
          52F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB9
          31655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C7
          4A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB44
          77BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C58
          06B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E1
          8491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4D
          EE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79B
          DFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB3
          46AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D8
          06DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB
          1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B6
          13CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8
          BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F29
          9E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F
          9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7
          C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02
          FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8
          EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C278587855786
          3F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A
          3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBE
          DFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A9640
          4C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D843
          5C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B
          3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC65
          85B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267
          655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5
          864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD5
          4FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED
          5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCA
          BF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB4
          0DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54
          A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BE
          DB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D2
          03FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D
          558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F
          6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C5979
          4AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A
          0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F
          6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDD
          F4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD977
          27EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47
          F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA7
          43CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7C
          A5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4F
          E47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB00000006
          624B474400FF00FF00FFA0BDA793000000097048597300000B1200000B1201D2
          DD7EFC0000000774494D4507DA0C151109100CD7BD2F000004D54944415448C7
          A5956B6C53651CC69FF79CD39EDEBB765B57E868D93A2E43C68026338395B56C
          8330400563882604A388FBA05F15C11813113E1812E336E08321F183248A04E4
          521811E58E3886837011DDBA0EC62EEC7AD6AEA7A7E7F2FA812D0E92E106CF97
          F792BCFF5F9EE7FDE77DD1BCC10F003857E9C9B850EDDD7D696D5EE3C56A5F00
          A32A0D85F12262F7DD1EC4AFCBDD734C76E339FF5B35AB9D76325D1A16B64473
          8A8468B4EDF78E58EC8500CCD915B946A3CDB4D3E5B6E75B7CF9E87FF408FBED
          25C82898BD3B182ADB0E009BCA0A9E1FC0304C3E61D9F5C6E225A4EF683D94CA
          1ABCFEE99730D9ECC4E12BD8F16ED5DCDD9FE9DB5900A8AF304F3DA27766D9CB
          CCB99E0DF4410BEAA22CF6FDD9811C57160215CB8970AD81AEF5352F89A695CC
          4377B448A44D9E3AE06DBFB59B4F254A8EFB57E75D1108558787487B6B1436F1
          2182AE0194CDB943F43A6DE13227C8A1BBF47C7D850591B6F4D428ED554E5F75
          45F0D6C7B57574CDC64D5A5938A4DDDF0E4A6F576974F890261CE069E356D0EF
          D7EBDE1F3B535F39B9B8D8E32BF35172BA53483AF3BF4B75B414F8667AE66F9B
          7D4E2B5C4D924AD75F3C153B610C6C85496A24548CAF29CF6694C3F7E8854874
          7271B1075A07B1241CC69DCB6765AFC57CA25A7F61A6D7315C0C4186CD6B1235
          A195A7C24D980235C43874191C87A5C10CA887FFA617F7545A7022FAECB85800
          7830DAEBED3D3D8AA32BABC1ED185ACA31AC9F8848DB3C2CB4E40047135DD45C
          F206F8BE6B9C266B15A11CDDC3CD2753D701A0BECA82C8042076FCA22E6CC4AE
          BB03323A671CF4640A855A5A2B666546B4E5726935DEC36BF101588A5712633A
          0625917AA53C9B918EFC432F469EE1E2094024A6A02E6CC25777FBE5971DC653
          2C510A194A1628832A9C3E9DA8247A7975B883DAE697107E38069661824B1D90
          7F6EA197F64E1017FBF44624F6F8F21AEE2B924D70455CB6F83202364F15A8EC
          9801A892C869F1116A5F9807AEBF8753245486DD5CFB7B0DA96600D85B657D02
          C44E64AD2E64C08E9B82644FB87E72D912459A84F95A828899B98C2CA7E27A2D
          AE22639E9718E441A4E2DA6BE5D964E468945E7EDAC58480C77119F1C50D412A
          CD349E6219A5082AF352AA5FA5D93E4692A411BD924850A73F93708904A09160
          591652C7A2B8B2679C0BF6592D1689296371A5DC8AE354B6351902E57CE9214D
          CEF682C8B2C2AA231ACD2A32421C76E918F02B96E728D12D0DC99BFFEB60BC6A
          43067C7E3D214ED31C879D2671912A92B9928064D60CA229AAAC534708D82C0B
          D1177C0480AE0B16959E3ED678A363FF071BC14C06F0E1D9146A43067C7D6FB0
          BFA34FFF66AF407FE9EE64ADB7CE007D824E8A275344897783B2293A2DB00A1C
          A3ED04004200F23C6FFC270BADEE802F7EC26A372E1EB4545289B111C24199B3
          681E5C1E37F7C799ABAD83BD43C19A6F7FEC62A65AFC9B901EBB9AE3DDD7DB2D
          6B077A53E739B185D8CC3CAC7A032774F67394AAD4E39B3ED36CE0574DFA0EC6
          EB644C456D398F6D57C578D081E3C4E95F4C8C99F906B319723289A1EE7EE2CA
          F330077F6B62420B0A8F90E7FC09C97F3DA2D2BACDEB4A0DBC6987D1C0171A0C
          7AF70F3762C4EAC844DFFD362F99424102801BADAA1B9DEB01D8C780CB0AFD73
          79B3F5D5114AC284E57C92A66D208140004D4D4D938530A300323A8EC1D85120
          01C0CCF2B8ED05DE5CEB8042F87F01E3F51575C2D1EFE80000000049454E44AE
          426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000A4F6943435050686F746F73686F70204943432070726F66696C650000
          78DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A
          2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807
          E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C008
          0C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173
          FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA4299
          5C01808401C07491384B08801400407A8E42A600404601809D98265300A00400
          60CB6362E300502D0060277FE6D300809DF8997B01005B94211501A091002013
          65884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0
          B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2
          573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE4917
          2B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE
          0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C
          2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370
          F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E
          3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FC
          B70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525
          D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F7
          0000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E
          44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC60
          36844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C0
          51688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA88
          01628A58238E08179985F821C14804128B2420C9881451224B91354831528A54
          2055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB5
          43B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA
          8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB0
          56AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8
          201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C
          23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E52
          23E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE4
          21F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52
          DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D3
          1A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D8615
          83C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F
          996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB
          548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67
          A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C21
          6B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B3
          52F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB9
          31655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C7
          4A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB44
          77BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C58
          06B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E1
          8491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4D
          EE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79B
          DFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB3
          46AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D8
          06DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB
          1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B6
          13CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8
          BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F29
          9E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F
          9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7
          C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02
          FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8
          EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C278587855786
          3F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A
          3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBE
          DFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A9640
          4C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D843
          5C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B
          3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC65
          85B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267
          655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5
          864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD5
          4FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED
          5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCA
          BF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB4
          0DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54
          A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BE
          DB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D2
          03FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D
          558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F
          6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C5979
          4AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A
          0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F
          6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDD
          F4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD977
          27EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47
          F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA7
          43CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7C
          A5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4F
          E47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB00000006
          624B474400FF00FF00FFA0BDA793000000097048597300000B1200000B1201D2
          DD7EFC0000000774494D4507DA0B1B0F092469246CC30000052D4944415448C7
          9595DB6F14551CC7BFBF99BDDF67BB2D8596488250A84DA8E1492C0D5E128C05
          D316D89A8289451FE41FF1159F8831D61812C0ADE1A2580921D1B01889464481
          2E5D2E69A59442B7BBD3B4DBEDCCEC99F3F36176CBD242A32799CC99339F39BF
          DBF7770658658CF605F17FC6AA7CB6F232BB173DD92E7C3AF27E5DA2767DC566
          C9C07FE7B37D21E7A31E35993BDACBF6DFDFF2E81E8C8CF4C5B4D59C19ED5593
          B9CF56E769C9A3FDDEFEC09A8613755BB6B035768BDCED6F62EAC2D9B4B0EC9E
          ADA7CD42B62F80A81640E3E7330080DBFB3CC9E09AC654DDD616B6C646C8D3FE
          061E2DE35B5225D0DD431A99BA3EA0B5B50D469BD6B275FF068101F20719F52F
          D1F41FBFA7416A77CBA9393DB3CF8FD6D38BB8D585C35A5BDB60B4B991ADBB37
          09C4507C21E60A4FA4F66C3E35570000CA74BB9A239B5A2642111FECDC444D50
          0CF205D9B57E0B4D5CBA98F184421D9B4ECEE977FAFC4702EB371C0B45032FE0
          5BE8E1CF3FFDD97AC6DA0E008A545C107A0EE2C943480948C9905242DA80BD30
          4FD6D8089A76ED6A1512A94C8FEB43359A3816AE8B72F9C944859790B684940C
          BB5484393E0A26F5690DC60E85A858140381B0773012F5324BA6AA4720E7A686
          E3EC7AE52D2AE5A611AD8FF2FCD5730452402030180402085CB624CDEAA5CB3E
          8FDABBF164B1F04C916F1F0824595153893A0F331331186087200694401850DD
          B04B454098700C000C0688206D463E6F5CF67BE9E0CB278B93D9BE205A520B8E
          816C328896A105640E0493AA4B4D85C3EA92C82A412CE5194C15B79C5522B094
          444FA68D4C7D141DEB8F97F4C98F35347DA93F2BD3AAC5EBDD81C35EAF6B508B
          A82C998941207642610288B8C622B155669A9D2BA71BC2DCDD74BCA457F759D1
          07CBBA34B928D45483A6407205E3CAAEE4CC8908B694C8CFCA8B21AFECDF9C2A
          15966F0E00AEE719B837E511EB12B6A30E7EF1F12225B0602898C8B90194706F
          CABD82510060FC8310EAB01100706157EC7073BD389D88300B9B212583D99121
          57255C9913981B35B93B16B4CF1E6F4F685DE9590C776A2B8F8A3A6C441EF731
          DC194B36C6454A0BCA4A4D2B125A2A7555C18E72AA0F92411339576672C6D371
          E8FA8CBE22823CEEE3874E2D190FDB292D20D8960C6933244B489B619705CCC5
          32CA860573D1729AD1AEA4D066826434C7CBADEB12D6B9EF3BB438000C77C69C
          08BED91EA75090071A22D6603C24A494A454BD253829B24CC15E8F4A867021E2
          3179C152C9ED539D62579B8DC09650686AD6939E2DAA3DFB7F2B140040894765
          5322640D46FD0252B0C252323303CC280B1BA5928016241A9F0D5C7AA0FB06A6
          E68314700B364B65303B35716AC3E4566C5E17333AC341796929454212BC2A43
          18160C53404A26694B08216019821361C25F53E18CB094837BD2FAD7330BAE3E
          DDF4930209A3242A671743DA12A65146D8259E519E621A981CCFFB3E32388090
          47B269DAB005C35AB4D9EF75D3C874382D2CA5E3DD2B7AEECC6B71ECBDA20F8D
          171C3EEC936C1A02A26CC332057B5C2ECA4C877F350C7A7B45A39DDFA925233E
          916A0ECD73A1085A1B5771E371242D6CF4BCF78B5E18EED4D0957E2A90F33BB5
          64D42F524D41876F8CABB8F938929612BD7BAEE8F92A4F00B0D6A72853869443
          3B62FD1B62D689E6A885ABFF44B2D366B9F3C8B5F999E5CD137611CD0BB68776
          C4FA5F8A5927D63BFC9D9C597EFD936BF3F9A70797138107805F018212508EB6
          47776B5EE5D5EF1E96BE383B69162A70B97249006E00BE4A87D847B745DFD1BC
          B4EDC7C7C657430F8C4715A604400028534DAAAA7359DB2335839FF72FAFE1C9
          4520C1E05AF65F8F9CF4C54D29AF6E0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000002A744558744372656174696F6E2054696D650044692036204A756C20
          323030342031343A30313A3231202B30313030ED81B0DD0000000774494D4507
          D40707081A15B96F5FB8000000097048597300000B1100000B11017F645F9100
          00000467414D410000B18F0BFC6105000004AF4944415478DA95565B4F635518
          FD4EAF5CCAA5E52615E874181832661227100DC618428C4FF2EC2FF0611EFC01
          66DE7DE27D7C7230860703918409170D09263A22E126B45032E526A5E552CAB5
          D0694B7B5CEB784EE76010C79DACF49C7DCE5EEBFBD6F7ED7DAAC89B0DE58639
          F5FF2ED4AE0707079DE7E7E7CD8AA2DC5755F5FED5D5552B7EEF59ADD6965C2E
          974E26932F805F7A7B7BBF3FC3C092AB5B05C6C7C73F05C9C7206CB5DBED2D20
          F3399D4E3B20B897E2E262292A2A120848269391E3E36359595991D1D1D12F06
          060606C1110772FF2AF0FCF9F3F3CECE4E97C56211906B24D96C5610AD5C5E5E
          CAFAFABA041617E5ECEC14E447F2A0AD4DCDA9AA924E67B68E4F4EC79217C91F
          9E3EFDFA05B8D240FE9F023610DBABAAAA0A13C8462E2E2EE4E4E444136A6C6C
          903FF71392A96F9377EA9BA4A2E62DC5555222F66CEA4EEE38F638B91F79ECBB
          E30F27E2F16723A3A3CF905D42B74DAB910DD66884E9745A784D4B2A2A2A34B8
          5C2E595D5D9547AD77E5A4FE9154569649B155A4D426E2B2038E467159DF67F1
          5AE66767BF727B3C9F2F2F2F7FD9DFDF3F0EEE736664A32DA5A5A51A3852A994
          9C9E9E6A02CCACA6A6566643BF4A15881FDCFD481C30C16965EAD7ADE8E8E810
          9BCDE647BDBE83B54F868686BEC574C296CFBFB68D62CC800565839497974B6B
          4B8BFCA47E236249C94EC02D0FDF7D788D786B6B4B363636E4E8E808C1D4E4DB
          DBDB6DB158EC091E2D03BFD9E8B9E13D0BCDE17038B44C3887A8E4C3EC67B2FE
          724DB69D11098682D2D5D525E17058A2D1A8D4D6D6AA6C06B4B66C6F6F2B58AB
          604D1168DA81150BBB855998C1418BD8921CCDBEE67C3412BBB25814B5BBBB5B
          E0B3D665CC746161418198727070A0A00315A396186EC6AAD5803088F990F75C
          5C5656A65905DB2CB1DD98C5FBB657EAEAEAA4AFAFAFF0BE21C48660E6443C1E
          7FDDA6B481E00212D3263D02ED65CE1F1E1E6A2D4B2B1821FD6653B05E0C8202
          5CC3B5842E4E12A550642313731604773177B4C7E3D16CE30EAFACACD404CCA4
          1431FF16326064FBFBFB5AB48C86825C686461D8C062EB81A82050CCC406F80E
          833177A626854ED008F7F6F60407592123A3018C4CF80EEF4964109A89192CED
          E4BA82008A18585A5A92126C7F169064BBBBBBD784484A02DEF2AC32474CB036
          AC0BDF6D6A6AD29EE947856A9D9E9EFE1191E750793F3AA1ACA1A141F3D72826
          A3A67D3C321884CFE753D8A62466107C8FB5618DF83C1289C8CECECEC1DCDC5C
          0002B3566CA85738A0C25353534BD88167E87D3F767091D7EBD584B8E1128984
          ACADAD15DA30180C2A14E6514272468CB502274E272626C6709407D199EB1058
          B4EA67F91922898642A19599999925649402E93DB7DB6DA7107B9CBB96BFC840
          C57385C4B48EC410DCC3776574787838B0B9B9B90DF259704E013B56BD162CFB
          2BE0187E6E070281654413442DF2B0A9B9BABADAC2F306640A1B0216286C0858
          B501D2B191919110E6B620F83B387E06168028BF11377D6B39E7D0B7BACFEFF7
          7F800FD2276886CCFCFCFC614F4FCF7BE892FCE4E4E41F104DA3B011FD607B09
          ECD10D206B7C0F6E12300BF1D0F2007E1E49FA7C0AF0EAD76B4058FEFE6C9E9B
          3F346692FF1ADC2B4EC065EC3BA0585F4BD20B7DEE8DFE65DC36145340E6EB5B
          C75F0349B47B86EEC8830000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000017352474200AECE1CE900000006624B474400FF00FF00FFA0BDA793
          000000097048597300000B1300000B1301009A9C180000000774494D4507DB03
          100C1D0AB5371765000006B14944415458C3AD976B7055D515C77F6B9F9BE486
          BCEE4D781A06535E410A182C8AF00149CBCB177C405A1507A142A745DA4E9576
          8A536B199D4EB1632DA9AD0E3EC001C6692D541491402842152C2344DA5A2182
          41A8C02521100821F7DE73F6EA877BEECDBDC9C589E89ED9731E7B9FBDFE7BAD
          FFFAAFB385AFB0DDF3A3C7F5B629D5883118E320282088080289AB08818003FE
          738FDACF5E38ADC722B1099F3767D29C257AE4745CD7BEFE8EC65DD58E98D5B8
          A7EA7AAA9EA7EA5955EBF764DBB4F3A0067A02E09DBDF50863F71C8BC42656F4
          CBDDDB75FCA6998BB466C50A003C6B01C80D089EFA1324E189AE4D81AC00263C
          745CC38542FF9043B850D85FFF5FC68E2865DD8EF3DD4054CD98AF4FFD7A85BF
          1CA8D54C0B0220D41D6CC108881104A17A540854C91A84C1D36B7448E5188A8B
          0B09854A282B0B535A924F79A9C3BF8F9CE7C985FD25691CA0B0A017F9C1A0DF
          F358B7F29738065C0B22F8F1F79D01C45C2537206CDA7930BB07D48B71F4F0BF
          7002414C2048BF0103F8C60DA3391551BE7F7BF8D627D3E6FEF8A1E5CC9A3010
          E34071D064AC13487B4C1A4D86074055B30368AC5B9AE199BCBB37E8854B1E4B
          6797DD7ADDA0E0D6F4314F139E76049E7FEB084604318211BF1B3F0B044CDAFB
          99375F83EBBAF48884D18E0E1E9BDB67ECA0BEB91F741DB356504DDE2BF74D1D
          921A730CBCF2F631EEADAEC8F866E3BB9FA53C607A02E0F06B73259B7100D71A
          AC8211C1F309E8A4ADEAA59332053A9129F64A21F86282D2C49EFDCD54DF3C1A
          B5CAEADA06C477B3F821585BD7E88786D458D2035F99A05CBCEC75EB1D31ABCF
          6D6ED068DC66F435DB1AB5236675FDE6BD9942F4650425E6C2A3CFD6327C4805
          22C2C2DB2AB10AF3A70DED9CA764AC9D41C22F2B28C9B6E88E11AC7AE310711F
          F5237FAC6564E5108CC077670CE3E5ED473146F06C82B481744159F6D82F3204
          E5BE999352F6933753AE2FCD1094E4CE2EC73B4158553CDB293E0B660C63F5D6
          06E21EDCFBCD21ACDF71D45F2E8D845723280077AEBD8B86E68FE103C081AA67
          7E0EC073AB92B908D356FF8EB019CE940BCB282F2E4F81C4A601F8A2820289D4
          6BBD1865CFE21D9F9BC64D6DCD6C6BA863F6FA593C32F9516054F734BC1A4101
          58599F20D4DF3EFC2B39B93959018483A5DC533587EBFB8F66D15F96306FE853
          C4DDC199527C2541F1EC9505255137AC3FEE116D8F669DD3D6DEC68996E3CC1E
          3987876FF921FB3E79134FA774052058555C4B8F0405A0B8208761BDBFC6C996
          93084238AF94505E986020482818426D82A1B93979BCF1D126B61C7A93F1836E
          E237DB7EFB99D5A7CB334290480B3002F3670CCBD8418E23ACD97684FBA777E6
          F4E953A7280E17306BE24A401875CDD7136AE9E78874D18BD70E6CA4499BC81B
          988B75BDC258DC423A80B65880A8ABE4B9D2234189C6629C6DEEA0B0301F4993
          0A451094A5EBE6F3F1B17A8AF243AC7B783705524053EB195C2F8E756DC2D34A
          170E587A2C28F1789C48A48592FE85ACAD7F9913ADC701F8C9849FF2F7FD1BD8
          F9FE461CE3B0F6895D0962B75B366C7F95A995D351CFE31F074E6456C32409B3
          094A927F0B660CC3AA12F7C0F5C0A84749B0981F8C7F9071E53702F078ED329E
          D9BC1C631C9E5DFC3A45BD42008C1E3C06F537635DCBEF6B9E48684C278004D3
          9DB45F656B2DABDFFA2855BD92290A608C211A8DA2288E31CC19FD1DFA15F4E5
          572F2EC45A8FE195E329ED3DD0D73B1837745C4ADEADEB7160CB4BB278CB4BDD
          43D01127C303F3A65D871158BEEAD3543AC65DC518C3E9E68B28963FD7BFC27B
          9FEEA5A8CDA3FD522B4525BDE95F31823FEDABE18ECA594CBAF616CA42BD19D4
          E75A5415EB79291BA65309D3AA5E97DD667B27C6509C9F4BDC8D31696835F672
          3BDBDFDF402090CBC8AAC988089EF5D8D5B8931D9FD401CAD431D3F05C37A51D
          1921F06CA242C55C9BC67625E68231995E89794AD405571D222D67282B09B1EF
          9F9B0178E0CE65DC3FE94104C18841307E5EC0E431D51C8A1CC2A6D948FD5E4F
          FC760D0BAB83BCF06A5D8F4E4BED175AB8A12287AAF103B87154959FF7923298
          D4024138DCD8103F77A1C5DBBABFB6F50F3B569E925C693DBFE6E2E44C0FA8E0
          7ACA03777D0B23F845084434F1378BEF097FACE9CC698E351E219CDF87B367CF
          9E69BF74B92D722A72B2A9A9B9F9FCB9D60B7BDF7DEF68C3E186B3BBDEDEDD04
          74006DC0FFFCDEDE2D045625916E16544045B1061CBF4A5A01E3D77815A5B8A4
          9470691FFEF361847391C6BE8BBFB7601E10F58DC5FC6BD4BF77813870D97F47
          1600F0E2EE188E80632C018180B1048C26AE8EE218C511C531164794225342AF
          BC5E501003A8BD9A13750AC0FE0D4BAEEA486E8C61E1DCBBAFFA48FF7FC563CC
          FDC0A45F310000000049454E44AE426082}
      end>
    Left = 496
    Top = 136
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object PD: TPrintDialog
    Left = 384
    Top = 296
  end
  object TreeImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446F20323020466562
          20323030332032333A32353A3435202B303130308377E4250000000774494D45
          07D30305173B097407ACAA000000097048597300000B1200000B1201D2DD7EFC
          0000000467414D410000B18F0BFC61050000025E4944415478DABD935F485371
          14C7BFB76DF73AEFDD3F75666BCB70656499418499524116D98248C34248B282
          81D543850F05F510BDAC1EEA2534127A09235846B2954C1938C487A844AD291B
          2EA735758E6DEE6E6E73B7ADCD68341A952F7D1F7FE77CBEBFF33BE7FC80FF29
          C71ED50D5369A1EF19A05D353CE1FADAB0D4713BFE4D5B95E866A8481F20489D
          AFF917B8D55FB1ADCBDFF664AAA695B008B64296433E3C04C45231E26F70B367
          679ECC2B7D5BB659AD1E347EC162BFD414B42F6BCCC6975C2ACECF06C5FA51E0
          F7E32C7F09828BB3746DF9F632F507AB133D2343EF17C19E8411DCCFDC0C8344
          B222A701E74767681D1BE0F2DC9222A84B95B0CD2CC0A01F089F2682CD8F1E80
          FD95493F8135A1DCC989DB99F5C7AB29E91188F2EBE01C9B448B5983CFC9AC17
          4A125B187F948B2F19E5E2782779186FD24D9CD643FBC98A771B775DA8A6F21A
          50B4A109342D83271A410B7513B397E7A1A81C842352422D8445F54323786DED
          C4F3B4C1B80D775D2E9064AE0C225E2FA6ECFA95AAF6EDAF417DF3294C2D4C43
          AE2C8627FF29029C04D118019B139AB48138078F434124048C02029112058C09
          F671C38A89482CC7BCDB0D4BF719280347A15A4B8094D270B0D065F460E00E8E
          4585CCFDDDF54D9B24EB8A11744F6272AE16DE59334A64A31024AFE2969711F2
          FBD0DBE77C75B51D27927022630FF41A5081425C53EE505CAF6AD0303C7E1CEC
          FC1C423E2FB8B00F89188BFE1ED7476124B1F75CD78F69645DA48E46A8E224EE
          D11234D234885C1A60186078181E5E049597F470FC36C66CBA7510070821DA28
          0A156C0013F128AEE82C185BF547FA93BE03FA1CDB8547150BC8000000004945
          4E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000442494441544889B5965B6C54551486BF7DE69CB95FA02DB52D6528D4
          D0D24A109410D02051138CFA622411121294842021C6A4BE40D0F8863146A336
          A898881A4D40A85A118282404C31A4542892B6968A053A960E33D376EE9D3973
          2E3E4C394C5378D2AE64277BEDFDEFF5EF7FED95B38E304D9399346946A30372
          EBA19D2FE7757D03081340080081B88D10F7985B4BC51571E7309210A2CCE59E
          682CAFD8250AF9C48CE64806F8B4FD237433F7BF07DFFE5C4B91403773847B42
          14149D3D3B3FFC4F41B7EDDE8CCFE1A37EC94260520180E2F5E0997487C27DB8
          1C6E24213874E65B009E58B69A895C1A97C3852CD9506C368E767500F0D2BA0D
          FC357495258D6B9837673E9A6958841641795D19FD5D7F0310AC6A9A22B3F5E0
          1E8E9F3D4D6DD53CB2F90C029D4DCFEC607BED0A0BB7A4B10600DDC853701480
          32A0A44CE3910C1FECD93B4DF2D1B3ED1C3FD5C1B9AE8BB89500C9A4C65038C2
          70AC7899B1C428B1788C743609C09B2D6F63A434EBBC45B06BDB1B007CFDC3FB
          44A38316A0F37C17D77A869948E5B97A7D00359D239948F3E7E00091D84D4EFC
          768C9F3A8E706B6C8478320AC05B25EF68A5E8564F2BC9A17E561A79E2677B49
          797C78830D847A074884B3343E59CFF8588C6C2EC75822CECFA77F2114BA41C7
          C533F8FD7E42917FD8F1C20E262652B85CBEE904F12BDD786A1A7057B8191DEC
          C3E69118EFED441D1DC7EE74A0BB540A8A412696213E9CE2DAF59B44E323A4B2
          3952993C4EC54F329564B66FF69414CBA58EAB7A2189810B0482AB9114995CF8
          24BA96C357E96471052C9DEFC6579D86E501208051D1CC7038C2883C9FA5CD2B
          A9AD5E30ED0DA71048920F4353F1562E2715ED034004EC3C1674F268798ECA86
          55648654BC0B9F0549C3D054A4582F2B9FDA8DCFE3B7E2BCF2CE569AEE5F3C9D
          201DBA8C9E4F73F3DC3E0CBD58092B562D43A4470118EBE9442FE4C88E1E040C
          B0DB015014871563EBEB2F52B760EE9D4B971238CB6B300D0D4FDD03CC6A580B
          404F773F2D3BBF002050FF204EAF4260D123CC5AB4064D5600D877642F5F9DFC
          0480F24A3F9AAEDE3D45A60D24871797AF0E9BAB8271E0F3CF8EDDD917324836
          DC654D48363B91A14E6CC0ABEB5B2C4C4D752D9170ECEE04B9916B986A964877
          1B422ECAFEF8FBF700781C28645214B27922970E224932643380646100145966
          6E6D95E55B9FEB2BDF6EE1BE559B885D6CA77CE9D3802072FE1B1A9EDFCFEDFD
          E0DA2DC4FE68C353BF0E9BCD4EB2FF30D9846A61EE6692E2088813AD9B2B018C
          42DE34D48C6614D494C31BD400BCEEC0E286E09C870126D249CDD4D5B4DD5365
          E85A3E6F4EF65BC51190154740511C01513A64BB5FC84EBB8CB04951D3342F44
          7F3FFC1020C7BADB7D006A41BF90D7090DDE5285619837225D87CB8410BEE15F
          5B011CA6696611E212C5623128363613C0ED71F1DDA9FD88D2A6DF7B60FD9740
          13D007FCD8BCB1ADAD546EEF81F5AF011B26DD3EE0DDE68D6D97EF991F984A30
          1336E37F15FF02248CBB60D0DA3BD80000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000028949444154789C75933B6B544118869FB9EDD91CF772102344710D81
          10AC622358585828042CCC1FF02FA869B54A6F1DECB4B1B05310492124D82822
          BA12489490B0F1B68A6E76DD9CDDCD9E3D3363713637C10FA619E67979E61D46
          706856176F45C0AC09F2D783427116EFF1CE620749D5A68356D2DDA90A15FC01
          AA400BA88A21386BF2A5EB41589ECD178B910914E070CEE2D3012E4DB0498FB4
          DFC1265D9C85F0F8596AEB9F101BCB73CDD1A9AB911439BCEBE3D21897EE000E
          EF1CCE6601788F900621727C5DFFC06675897AFD373A2C9D8C0A853CE0411741
          9611083C9E34E90160D384FADA3B36DE3FE7CBDA2BBC1D20A544CA321AEF10B9
          80CF6F970ECA500A84C023E9356BB8B8C5AB178F879044188D1412E524DA7B07
          8073C94180E3C894CF4C608CC9602990220BEAA70AEDBD0720DDED604B1718AD
          4CD3697DA7B3F51C9333FB21DAE8CC60084B39346068D093632C3C58268E9F31
          3333C3A9E238155903A0F1E95D667008165220537960B0D315C4710CC0E2E222
          A74F686E5C09511A741861B4390A4B89EC2B24C380B0FF914AA502C0D8D81827
          4A0E2DECFE158C3168A3D146638CC1188352874A0C82946BD37FF83D3541BFDB
          6072342B56A891A31DEC2D21514AA02133F06942944B88722D2831DCB3083342
          F9CC043F36DF1CC04A1314225492A0FBDD1DEA2B2FE936EBE89102DA04479E50
          1EBA8294925C58428D9459DF6CF0B5DE99D7BBED5FB5F6F6F678A7D9C2379A59
          7A5824080B04E1315CDC627DE53561A948BE789CAD6F6DBEAF6DCD6F770B4FEE
          DC5FCD3ED3BD9B976E5F9CEC54FB89BB3C18F8696BFD792BF2E3DAEDA27321CA
          F590D149366B3F1FB6DBDDF9B9858DDA9EA1E03FF3E8EEB928B5FE7CBBA76FE9
          20ACEDC68DA7730B1BCBFF9EFB0B674E1D90EB0BA8380000000049454E44AE42
          6082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000016549444154789C9591BD4B425118C67FDE6E449414D7C8343F485142
          CB92206C69C8ADA9A9D6FC631A9D6B686868116C88E6A8259A248CA2228812FB
          42833E35D3E36D1151CFB58F677ADE87F3FE38CF39266A4AECA6757ED7C65274
          22D618A88DC3E25CC870AB5C115C65EEB9CBBF2C2776D3FD406C293AF10CA0B4
          1E8EAF2789AF2759DDDCA9679D6A07FE9161C63D56067A940560AF066ABE0140
          24E4A55028E07238EA592E9703C062B1101482A3CB87C9D72FD31E109600E2F3
          8D4AF183C7BB1BFC5E571D904AA518B4DAD0865CE8E54FF2F9C2A461055573D3
          E70CA06A6E0E4F33003C577BF0866731DB7D94952E66A6C6383F3B971F112012
          7036CDBAAE4B99A228944A25634072FFA43592D4F85B52058080C74EC063E7BD
          58917CAB0C013E9B199FCD4C6FB72AF956491500B60F2E7EF56D01F3D31E2366
          5B4980E3EBA7A639E8ECFF1F60D4DEDC5308F13F80A6693F2EB40508215859DB
          229BBDA55AADFE19F00D4FE37613382F4EC50000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002D744558744372656174696F6E2054696D65006A65752E20352064E9
          632E20323030322031323A32313A3130202B30313030603BD286000000077449
          4D4507D30A06140B14D5A48546000000097048597300000AF000000AF00142AC
          34980000000467414D410000B18F0BFC6105000002454944415478DACD92DF6B
          D35014C74F97AC6963B366B5A8AC34CB181A3A545837565187C84444FA26D252
          26F6A5AFB27FC127C19782824F3EF80FA80FA23E8C75282B58D7561F6C93C542
          85511BDB75EBD2246DD75F9E42855AC4573DF021F77273BEF77BCF3900FF3A88
          A1B5A94F381CB6F33CBFEAF178EEB12C4B699AF6BDD168B4F1ACFB2701532010
          58B6582C0F6C369B3A333323743A1D9E24C9319AA601D7904824A46432795F14
          C537F8BF8E747E73C071DCFA3C4628143AED743A27198631E18D502A95A0582C
          020A3B1D0EC72DB3D97CB6DD6EE7755DAF0C8B1098B4E6F7FB1DD56A150A8502
          A8AA0AB22C433A9D866EB70B2E970BA2D1A8291289089A66AC72D3D3EE866188
          95FD7DADFF2C02ADCAAD56EB26265A298A826030088BDE0528281AB49A7528EF
          FD00CEED864C3607DEA515F2FC4A703E97F97046CA663EA2804A542A15A55C2E
          E7D0C1B2CFE7B3E9B54390769B70E76E1018E10AC49E3F0596B543C73107BC67
          160C8280BC249F48C663220AECF6BBD0C6DB0BE822DBA8D797C62D0C2B5CBF0D
          06D65D1DA760EBC5B39D54725B3E3577C95DA5792862053EBD7A9C93C46C0173
          B3E4A03D078AA26C6CC5E36B346D7D62BD78348545035DC9C38E94FD5C544A65
          76F2A13A2B8B378CBDAFB5F5B7AFB731E71039328DCCC1842008D7162E5C7DE4
          E4CE4D7D89BF4C6D6E6EA47BBDDE3B3CFB66B74F2C6A9AEEC2F6D670FF1E4999
          46E7A22F4251662F49909775C360709F476248DFB21D398E341105A98D0AFC12
          39869C1C7C0F9052DFEED0F4F6064FEFFD6DCCC7107220F81FC74FFBE4F78F3D
          EEB9160000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000013D49444154388DA5D3CD4AC3401486E17762550A0AD9D4B537E0D23B
          F01ADAA57B6F4C5C791FAD2E74A5084A17FEA0224217A599CCF95CCCB41DD346
          05032103E1F9CE99938CFB3C3B14FFB83A00BB4727481558058AB7AC02F96C5D
          81024848808CE9C5550C906660BE812B301F83D76099961D30AF66D5125885E4
          DB71B02CA00916413EC38ACF8415C2F70E16A00D5BC296B065012B6D5B055803
          5BC21671B303942A9BFF1BCE3BF80DCB2C0E2DC72B5B68C321568FB05E84C89A
          5B402D38803628B6F756FEC2A2F31662C04F3884586013F478035B0E75BBF8FB
          7130699266B006E77B4D1367CB115C417818CF4C9A94FD61AF00D2F76DC7C5CE
          3E00B5AFA99F5EBC05BB2BFBC31E40113B88706DE534ACFAF996F0FE3191D969
          39181DE4A7D1A697D7F323EDE62F9C7338E700029DD7A9BC7792CECBC1E8381F
          E4177F0ABEB1E3123E280000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500467220323320417072
          20323030342031323A33363A3136202B30313030B19B93BD0000000774494D45
          07D40707081E1243670F1F000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000002934944415478DA6D935D485361
          18C7FFDB5137B7933B2AAB497E35ADB1969AD122B54088A4AEA28884BA0E82A2
          BBBA912EBAE92202BB0A4AEF82A28B09957493055960CC9991629A393FA66ED3
          C396FB3EE7EC9CF51C38BAC93CF08397F3FE9FFFFBBCCFF3BC3A147D8FCA7028
          DB0329D70BB06720AC0D213DF502898F4BB42912B942B56E576C437F15CC7A2F
          6ADA9BAC56095FFABCB87C4FC1DC4F790BFCC0056403D3A44A169AE877826DFD
          5618A5111CBBD404FB596CEA0E430CCF604DD7427B0E0B18FB0D523512258567
          323B2B6B672FEA3A6F816D80D3E443AFDD83B1C9185AABA7C067396CFDE5A350
          66FCA45C2384EDB0BC9B2477806171FFF43B9C73C6B1B0588B4F53F3088642E8
          3279A4656923482A0B51BA770666378348B8FBEDD551B6C56680AB96C1490787
          9E360E5DAC6FFAF9E7B965524D104B8519E46B107C3282F5C7D785A06F169200
          13E27058651C27A3482C9B2045480B4E1566A02F58A7A0447EBC9FE45E21F015
          88913EB601AC8FE3F5B7847A7A948813F2DE57505BE31A7C38BCD0D13726B4E9
          CE9BBF23BDB98107E3DD78E6BDD60C45F643FC33A19928C57370E4E94570751F
          B0BF05072A4570867F482B26F01111299EA7E47F25111ABC8BAC7F98D49BDBB3
          90BF829CB98D836E80B3222C542319CD81F7FAA83B3437E5547CFB513398D62B
          A46C268C4535B0ECCB9DF2DC7C4995A00C4B18AC2A3628AC05A968122623D54D
          4FC91AEBDB49EA222A8A0C12494518789301C2F3681047A951496444BA2A5B89
          F214CDCE2A3540C84824AD21CA8B6B6072BBC0D8EEA0B4E604D8DA46E80C15C8
          C4B390E211C4960390FD2BC8FDA6F424F53D0C6913B9EB31A9AE4D8493A827AA
          088356AC3411215688596251FBB7CB405D97A933A9E6A305339A81DA7B511B22
          75A8A4ED2EFC072BDBF8CCFFB53F6D0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446F203134204E6F76
          20323030322031393A35323A3139202B30313030E8DB41510000000774494D45
          07D30A06140A260468E587000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC61050000023B4944415478DA7D52CB6ED340
          143D638FF37E2880A088356201AA90A01B56DDF103FC006BF80156ACFA1BAC58
          C29E4F00C1022448D54215A22856D2342DE4654FE207E78EED16898AB18FEF78
          E69E3BF79EB9EACD0BDC745D3C89125C4F814E1CA3AD80B6A7D176359ADA41D3
          71D0501A8D928BDA728EC9872EF6F6DEE2358099AE364AEF761E5DDBAE2A1F9E
          07680D908024811D5194CDC56E368052B8313CC6736E1D12EF75B25EDFDA54EE
          60D6F71127995341105B04626676D8E00A754EB789AEE64698D06B3C62741748
          D3CC51EC6573098004CC156DC2D37218B711865980FF91C5B204F2C12FC45BE9
          C83023FE060C40D1CE098E3DCD41EA9411AF03C4C53A37546C0358682EF24960
          026E7AC88F02A6CE43F4AACF1099396E2F5FE26AF94C9611D02F4E91E744D123
          256929188AA7F3341DAE35369FD0E93D45CA027FF37F446268B21246069FE9BA
          1635B44AE1AEE601FCA1ADCD6A51DC44A50C7BB58A68B6802BB4EC19F40FC050
          38258CA6A3BB9C2FC0178D26D06A652471947AC5CAA932B7F52B9BA14814CAED
          4AD65EB5E2606B0B2857F26BC2BFE422A064C62E7533A558B6524E3D65C03A5B
          C32B5D38BB794F4839441A0698FEF071B83F84FFF1086372973603639278B54A
          51AB6724D1C01844E3531C7C1BA0D71D607A3486992EA45F30234E082A867D62
          A11EDFC583DDFB78C55B505F7EE2FBD7017EF52788D61156749812721AFB14C7
          C419B1CAEB970C4269861A718FD8C9E713C2CF89B3BF08824D5EFB791F141D45
          F9D0C9DB531C8342E58BD6BA7CFC015DC20B3BE63531160000000049454E44AE
          426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446F203134204E6F76
          20323030322031393A35323A3139202B30313030E8DB41510000000774494D45
          07D30A06140A260468E587000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC61050000029C4944415478DA5D53CD6A1351
          183D337327691C3B495369A4966E5211DA08CDB2829095B8EF324271EDC2AD7B
          1F40F00D045FA010100A2E5C885D498AA185B4B52521C1C4A634C9E47F92F17C
          D70968074E6672EF3DDFCF39DF3570EBD9DBDB5B9E4EA7FBC4CE6432E9FBBE7F
          3C1E8F3F5D5D5D156CDB6E789ED73A3A3A1AF268203072B99C99C9645E74BBDD
          34099B4AA967A954CABDBEBE46229118BBAE6BB75A2D837B585A5A42AFD7EB9F
          9C9CBC393838F8C8001DB5BABA9A9CCD661FD6D6D6B0BBBB8B72B90C66433E9F
          C770388C8C4623341A0D54AB556C6C6C201289DCA9D7EBAF493E25BE2996FA30
          1A8D229D4EA35028607D7D1DB1580C87878760F9BAAD2008C0F251A954F49BFB
          F7B9BC4D1C2B66CF0861656505A55209C964F23FA2E0DF6F816559312E2D1311
          4581E28EE3C8A2DE949225C06DE2FC5BF64C3EFC6B1396E2E2BD783C0EC33020
          420D0603B02A7D781A98F0A736668101658E601A0194359D1B66C88F62E6AD85
          8505BD423D44381D80C161061E9E3FFA0CC7EE63BF9883374B6234EC818E7543
          1B75801495055BD1E5C95B02CC1860D2AEE3E92B05F80EDEEF5731898CD9B489
          4EA7F38BDC89E45424A77424A5B490B4E86F0096DD6DD6D0F8FA1D970DC0711F
          23B05DDA68A1D96C4AFF324C33C5F2974540B18733815AADA66D342D05E76E16
          6FBF6C636226E0C47D6607A2D18824537321147B8E5E5C5C68FFE5595C5C84CC
          8508AD944D77143CAF03AFE389C0634EE8CFF3F3F31F3C3AD02D148BC5273737
          37EF881D4E9AC9F1D52DC828532B9F637CCA04C72CBBCD3353EE7924FE264A44
          57AC7088AD6C369B67152F695F9BA35B3E3B3BAB90E0D3995E48A81235A22944
          B9070223F4537C7C108EE7266186072F43529B90407D6224A5CF6D34FEB9C922
          8C4BC4C37551D90B49F3E9096E5FFF3FFC80736FF79A0CE10000000049454E44
          AE426082}
      end
      item
        ImageFormat = ifPNG
        ImageName = 'businessmen_16'
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000006597A5458745261772070726F66696C65207479706520657869660000
          78DAD5575B9224270CFCE7143E022040E2383C237C031FDF4949B4677A67C2EB
          F07ED85DD10505942494528A72EB8FDFB7FB0DBF186B7429B3945A8AC72FD554
          634347BCFEDA730F3E3D777BF0B7F369DCBD262286082DE9A3145B7FC783FF24
          2934F4F20741326CA27F9EA8C9E4CB9B205344C7A288CE3441D50451D4896002
          9A6ECB972AFC710B7D693BEF4E44FFEEDCFA506F94BBF8ED3931BC3733F4508C
          8B0279DC23253580CE9F1C357404F740150B03061B1131EE91AE4FE090AFFCE4
          3F58E5DE5179F5C237E36FA050D1718781CFCE2CAFF6CBF190BF76BE7B5CFC41
          338D97E64FE33D7A7EDFCEFDEF3DC5EDBD74772D15B8B4D8A65EDE391D2CEC70
          393DAF155C8C7F469F9FABE212077C06209F7EF88E6B841A2260D92185195AD8
          613DED080326A6B822A38D71447AC68418F931C83BE094CE157664AA348160A4
          017809A3F1654B78F4D647DD0802C53360650C1076908EEEDC7EC5F5ADA0BD4F
          C887E0E5E52BD8154F52C08C83DCB963150009FBC6517E1C7CAFF7DFC1958060
          7EDC2CD860F35D45F41C2CB64E1CD10334616146ABB916789A00B808BA338C09
          040490379403928763E410E047013E0D820449133B200839C7092B63222A0047
          E2D18D77383C6B638E3A0CCE0210990A12490050035609C486F8E12488A19629
          A79C73C99C25D7DC0A9554722985CB21BFC6C48933176616AEDC84244996222C
          E2A44AABB112C831D752B94AADB535286D90DCF076C382D67AECD453CFBD74EE
          D26B6F03E133D2C8A30C1EE2461D6DC649133C31CBE429B3CEB6C24228ADB4F2
          2A8B97ACBADA46A86DDA69E75D366FD975B7176AC129AC3F5C3F8F5AB8A8C507
          A9B3905FA8E155E62B221C3AC9073320165300E27C104040C783999790527407
          BA8399AFA039CA1156E603CE0C073120985688798717767F21F7093797D2BFC2
          2D5EE4DC81EE5720E70E74DF20F7236E5FA0364F99189EDC83D049C3E3544F48
          3F2C58D2A2B453D47EBA75FFF485FFB8A0CDF974625F08C88D0AF93C81C17ACA
          216544DE7A4640DF88A33394451A3FBD02B61EAC9276471FAC725CEAA4819EDB
          184D4577BF92C93BE7809F6FDDE9706FF33CE4ED8541EAF95901722B8FE29124
          F2A3A77984AAF6062C57DD0505A04DF708584892C1B56515971A23619A3962AD
          1B0DFD9AC091AD57C8B43A6F9DF736EC246666ED618E1255CB1C8C52DAF561A0
          2205B5CBF143C8E7DD91926A4429A8F9E921CB23CB324341229290658648982A
          2E898787DD838E84B1AE25634C9D46AA7E67EDD2259947AE1B693F533E3E4A01
          296A33A816DCC876114BCACD7C2BD13C586BBFCAF2F00C49048A4AEEB1591833
          48549D1DCCA1A8AB0B53585537039A00624C1A1C7CD42FB2A95E1CB0A2F27701
          5CB605701CE8D10C3A337D2356489703C10D5653120AB285CB445CAAF895A881
          106CFDEE895641364C8B6D84C91A7E167576C729321575E068316A7ED4C416E3
          5CFC4010E86E376813B2DEAD761BD1AA0B64D002C3A9D74B4B6189A59787432C
          D5D01BCB621507B3DC2CF6A7931D2CCD26ECF23B5AE02FC18CECD64C4D255AE7
          50A4B304875C5B34481CF682EC57DF8D9976ADF666ABB4C82C4FAFFCE4362DDE
          61F286B3F5D5551C4A8AF66104BC0877B5792192B3DADC04484A90A90FB3207A
          9090C584A23CB8811943C4CB66D937A917A5DDCB85779320B3F7232749081A9C
          A7F22A61B1EB1199CE32F3A581FD1C531E2797227F6DC9827933EA0EA2F41A57
          CF54894623D39784FAA8EA463523A4D0CE371A3AC86443C6CA168130AB5B6A8F
          5AB743B9B7342394EEB9CD32AA73A56D4A23973AFA25ABC527B3F5A9E3E3AA3C
          9E8245D268D4F603AD7B3364A01266EAC6F215412F8A2B60BFC90B9272A18E65
          BB0FC2AB61D58522F229B337D1418A55FD8239F23C63B86F2232A7B3A9156AC7
          715DDF291960DB2B19BC2A9AB360C6A269792889E665DBA775CA53162CB3E254
          86C4D035059F0A86A62FF87CD30DC5F375F76CF3A4F3B2C86F8EC60ED5F86670
          C7A1C5024316B7958D0E90D32FD303D42415D5D2185D8D7038B180D7AB263CC8
          BADEC0A9F545BEE5EEE782BA33026184A8AE68D597E1740D04B0025741FC666D
          807225AA526E2808BCE4E14E7BC2C9C9F6E09E7A30AC40E24C682503FED9AF1A
          51ADA447B9A68D571D18597BCE7F57D8BE6D2F84D3EF44E6C281ADF57B82B8DE
          C9EB3ACCD8B618C2C700C9AF62BBADA794EF7ECDE9E8FF2E68E30C5BDD9F01F4
          48E6C8DFA04A00000184694343504943432070726F66696C650000789C7D913D
          48C35014854F53C522158776107108589D2C888A74942A16C142692BB4EA60F2
          D23F68D290A4B8380AAE05077F16AB0E2ECEBA3AB80A82E00F88AB8B93A28B94
          785F526811E383CBFB38EF9DC37DF70142B3CA54B367125035CB4827E2622EBF
          2AF6BD228010D528621233F56466310BCFF5750F1FDFEFA23CCBFBDE9F6B4029
          980CF089C4734C372CE20DE2D94D4BE7BC4F1C666549213E279E30A841E247AE
          CB2EBF712E392CF0CCB0914DCF138789C55217CB5DCCCA864A3C431C51548DF2
          859CCB0AE72DCE6AB5CEDA7DF217060BDA4A86EB542348600949A42042461D15
          5461214ABB468A89349DC73DFCC38E3F452E995C1530722CA0061592E307FF83
          DFB3358BD3536E52300EF4BED8F6C718D0B70BB41AB6FD7D6CDBAD13C0FF0C5C
          691D7FAD09C43E496F74B4C81130B80D5C5C7734790FB8DC01869E74C9901CC9
          4F25148BC0FB197D531E08DD02FD6BEEDCDAE7387D00B234ABE51BE0E010182F
          51F6BAC7BB03DD73FBF74E7B7E3FCC6372CBBCC5B28300000D1869545874584D
          4C3A636F6D2E61646F62652E786D7000000000003C3F787061636B6574206265
          67696E3D22EFBBBF222069643D2257354D304D7043656869487A7265537A4E54
          637A6B633964223F3E0A3C783A786D706D65746120786D6C6E733A783D226164
          6F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520
          342E342E302D4578697632223E0A203C7264663A52444620786D6C6E733A7264
          663D22687474703A2F2F7777772E77332E6F72672F313939392F30322F32322D
          7264662D73796E7461782D6E7323223E0A20203C7264663A4465736372697074
          696F6E207264663A61626F75743D22220A20202020786D6C6E733A786D704D4D
          3D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F6D6D
          2F220A20202020786D6C6E733A73744576743D22687474703A2F2F6E732E6164
          6F62652E636F6D2F7861702F312E302F73547970652F5265736F757263654576
          656E7423220A20202020786D6C6E733A64633D22687474703A2F2F7075726C2E
          6F72672F64632F656C656D656E74732F312E312F220A20202020786D6C6E733A
          47494D503D22687474703A2F2F7777772E67696D702E6F72672F786D702F220A
          20202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E
          636F6D2F746966662F312E302F220A20202020786D6C6E733A786D703D226874
          74703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F220A20202078
          6D704D4D3A446F63756D656E7449443D2267696D703A646F6369643A67696D70
          3A36356633373830382D633063622D343339632D623565312D31366230633863
          3735626637220A202020786D704D4D3A496E7374616E636549443D22786D702E
          6969643A63623532303831652D663838392D346230332D396631652D31336664
          3435643238633735220A202020786D704D4D3A4F726967696E616C446F63756D
          656E7449443D22786D702E6469643A37396166303761382D346162352D343362
          342D616636382D623638663065346338613232220A20202064633A466F726D61
          743D22696D6167652F706E67220A20202047494D503A4150493D22322E30220A
          20202047494D503A506C6174666F726D3D2257696E646F7773220A2020204749
          4D503A54696D655374616D703D2231363932343334323639323032343238220A
          20202047494D503A56657273696F6E3D22322E31302E3234220A202020746966
          663A4F7269656E746174696F6E3D2231220A202020786D703A43726561746F72
          546F6F6C3D2247494D5020322E3130223E0A2020203C786D704D4D3A48697374
          6F72793E0A202020203C7264663A5365713E0A20202020203C7264663A6C690A
          20202020202073744576743A616374696F6E3D227361766564220A2020202020
          2073744576743A6368616E6765643D222F220A20202020202073744576743A69
          6E7374616E636549443D22786D702E6969643A38626131616535632D34383339
          2D343463652D393032642D343838326532376362393035220A20202020202073
          744576743A736F6674776172654167656E743D2247696D7020322E3130202857
          696E646F777329220A20202020202073744576743A7768656E3D22323032332D
          30382D31395431323A33373A3439222F3E0A202020203C2F7264663A5365713E
          0A2020203C2F786D704D4D3A486973746F72793E0A20203C2F7264663A446573
          6372697074696F6E3E0A203C2F7264663A5244463E0A3C2F783A786D706D6574
          613E0A2020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          202020202020200A202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020200A20202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          20202020202020202020202020202020200A2020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          202020202020202020202020202020202020202020200A202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020200A20202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          0A20202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          20202020200A2020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          202020202020202020200A202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020200A20202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          20202020202020202020202020202020202020200A2020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          202020202020202020202020202020202020202020202020200A202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020200A20
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020200A20202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          20202020202020200A2020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          202020202020202020202020200A202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020200A20202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          20202020202020202020202020202020202020202020200A2020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          202020202020202020202020202020202020202020202020202020200A202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          200A202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020200A20202020202020202020202020202020202020202020202020
          20200A3C3F787061636B657420656E643D2277223F3EC5A3020E000000046741
          4D410000B18F0BFC610500000006624B474400FF00FF00FFA0BDA79300000009
          7048597300000B1100000B11017F645F910000000774494D4507E70813082531
          0277B34F000002C64944415438CBC593DF6B537714C03FF77E6FEE4D93264D9B
          2E497BEB523152505ABA5A5CD44E591F2A28F824C5275114C597B287E9A36EFE
          17823A90E1063E38196E0F1B633F605B711B28B5A6D5544DCD95985ECD8F9BE4
          36B9F7C68746903DF9E681038773E0F370CEF9C0FB0EE94DF1ED1CC3288CDA4D
          B44A85CCDC351E006E67DC0504800AD07A1B20006E7C46BABB8FEFC311CEA82A
          B34270580F939FCFF25096E5FD535353974646464E371A8DC39665F5038B4013
          40017005E782DD0CDBB61FD773108A134BC5C5517017D3BB767FB3637232542C
          9A24AD3ACD66738F699A2E7019B0942BC7D16A3689176B29F6CE1C410D46F0AA
          266B8BBF24B8361F8D94F2EAFD3B654EED8F9151EB5C987FE503D2C02DC0524E
          7CC5FAD767D495E9F1F15DD1A00A8A0B7E4159966440BAFD795A251504C783C9
          4D1CFCB0FFD5C4173F15DFEC470150DBBD17435EFD20D56204A180B5C6F55F9F
          DC056A4EB959549E4B31DA40CB6348526D10CBE09637007345F598543A7036B3
          EC3BE5FC416FEB21DF95A7DBE7BD4303A93D3F87EE1AA57FC6E5F5034269E334
          05B7969CC7F80339EC6A63E30AE9637B4F7EF2C1D57B6E5FE047F763F6DDCBF2
          E5F071A9D15293B323F5E9C59698888E6D96E4688D1F8CEDFCDDD2E25B9343A5
          8585853F015B1E8BB467F1FBBA860783E42C899BFFE659597ECE47BA27EFDC1E
          D3237D51C994EB64353F5947901CD2D5643279321E8F7F0AA8B2E3BADBF2659B
          7509C6925D5C1E3DCA402A41BC6DE0537C24E231561EDCE7F7DF5EE253640281
          009AA669BAAEEF047A45313C612C2DE5C5B397756DAD64354AB2A8E60BE54A5F
          2153506AD9EE81C141E569BE8DD6BD859E9E10A6696259563997CB3D320CE33F
          09D080012001F4007E36FEB639353333AAEBFA6ED775FBC3E190A854AA76A150
          A8ADAEAE1A994CE62FCFF36E4BFF7342EE2480D77140073601A14EAF0418C00B
          A02ABDA370E22DB0DB01B5015E03A13516795C7DDD130000000049454E44AE42
          6082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000025249444154789C8D92DB4B937118C73FEF61F33DECD5774EAD6D9E32
          84A9089274200A0721786541375E45F81779D7ADF4075456501785DD06952B4C
          3C4C9B53DBC9B9DFD49D7C77E8C24842D39ECBE7E1F9C2E7C357E282F9FE7462
          047870C6E9C5D0A3B711E982E779ADD90A7B3B0358AD16AA02B85C148B16E2C7
          062211FDA09E17E0F198E1E0AD7B2866CB5F7BC302A3B58D8F339FC3E70648B2
          8C9C8952D327517413AA02EA476CAFAD72B0F48A72B9C6B901F543C16EB482BC
          FF125725C1D6F237E63FC5711A6E2CEB12ADB6751C70962845918D46214B9357
          23B51A21BA5DA6A476E30B0D524361A0DF26BEB0807A91A8ACD8C2EC1A2060D5
          D8CBE4B93B354532B6F10741DA7CF6B011BC3D7E4A14008EC3F399270C5F6D26
          154FB2BA9220ED14711BFA09C2FF882A3B55B2150DE1F6A3795BF075759E2000
          622F99B65DD577905B3F25CAB63CACC58BF48D8C6205F378EC66FCA1D009C2CF
          D7533690D3743709A110DB2A913F7428148A74B419F4D82996568EE8B62AACAE
          2458DCD9C7DF6562DB7E2CD344999EE87CA3AA6AAFCBE5C21BECA1BB45A01796
          88AE2DB29BDE6637A7A26B4D387595E59D2A862F88D9DEC78DB1510ED32954D3
          34C381EB6338A53295BD143B7983A5AC1F5F6890C24111F693DCBC730D51042B
          9847F718787C5E94DC97E322C98A8C92DB44EA9E44EF31B1870543E32712235F
          259CCC3A87F124B1DF08BE76838ECB010C4D17174A34345D50AB461279D9CE48
          ED2375CD8A88AA2EDCA5A6394966565555E54AA3DE785C4E6FDEDFDC29F5C6B2
          FEDE92CB1313FB95584D95E62499D9FEE9F7E25F75FF0558C02D6290A2F34E00
          00000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000001FC49444154789CCD92BF6B537114C53FDFF75ED2B4C61A9BA4989021
          83A256515A842005458B8B202848872E6EA5A38E76EA220E6E2EE2681107FF00
          B72E0E5D74702822B6D40AA2C536BFDA97F75EF2FD711D4AEBCFA1E2E2D92E97
          73B8E79C0BFF0835FD58E46F0849B4DD9ABF337878770E006EDF748807918676
          22F49CE00103690540183BDAA1A31339E69FBCC9FD28180088EEF1E8C5074A85
          2CD5CA10412A45CF08195FE144D1082DEB4D437538407E393800689362FCDC51
          00AC11E244B016622B18112A76859C0AF16CE5374B01C0760FA2AE309056F4F9
          0AE584440BF5D0D135305A0819395E642DDAB1C424C20410D10A00728165306F
          F170F84A91740D9D3E8FCA4178FF15ECDC53F4AD88FEEA3520CFF5CA14B51317
          B8FB6C26170024DD1E43C45863D8D459D6DA7DD44347B3E368478EA9A24F71AC
          4627F03992CFB0FCF91D3575116437C4A09F0DC9E03C308150CE40B1E09168C1
          58581C7DC0015F210EC2F815A732271994D44E06ADFA3A73F757B1D6ECFB176A
          A5639473F91D81E7B325B5B79944A64766E8EA2D9402A5145A1B221DE38CF0B1
          B94A313ACDC2DB2CA5F133DF5BD8C3045CBE74858A37843186A5DE6B5E6E2C50
          6F6CD06C3448B6221E9EBDCA585C67F1D0E61F0400ED1B56E40BDAD3A87481F3
          E51BE8621793688C762C658659F6D334A21600EA27F63D844F80DD771CFF01BE
          01BC54E3691CF894420000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000002F249444154388D6D93CF6F155514C73FF7DEB933EFBDCEBCD7D25A5B
          DA1A9AE02F02710152A24BE98295C668B02112F72E084B13FF03D76E5DA0D68D
          469744BB61631A4C302925201095D46879403ACF376FE6BDB933F7B8784509F1
          ACCE599C4FBEDFF3438908D7D7DF4244B04982B616444E8FF2EC1B1431508761
          D417F157B46DBECD53A11F274A29EAC1003F1AE1ABD10FF133CBF1E2C9F775D8
          68D97072AE9317C52AC8C2D380E0C942BCA72E0A6AABE9B417B59D98466A8732
          81016244C2FF05485DBFA31BF603A5F4A40A82E7EACAF1F08F6D766E5D415CCE
          D06BCA610149471E377A51B46C35B6104EB63F0BDB336754605FD7462F4451E4
          1BD6F3D21B1FD2999C62EEC5933CD9D8B48EA54E9FDFF6923140C42773C7D7B4
          D260E369DD983DA48B2C65EFF60600A35E17630CCA8F38D01C70A33BCBD7DB2F
          F0C5B5E7C716BC09E9DEBC4C557BF430C38BA31C0DF1E101B2FE16FDC136C604
          D4ADC372B737E0F39F8FB071E72013413E5650663D5AB347F075459E0DB0AD49
          B436341A1171D266E1E86B04D6523EFB6EF0C9D537B9B9DB6679AAC744E8F601
          AE24EBFE82AF6B26DA6DCAFE4300E2F96300F4766E53398796E1AF4958C4A1F1
          6D11A5FFBD03AD14732FAFA28D212F0AC434F0BEE6AFADEFC8B23E7F771F90E7
          038E1D5D91BBF7D247E2FD1EC27F0065237A3B9B846148D299264FEF23222C9E
          58238E136CD4C044ADF1AD880436B4FAEAA5B5AA72FB6B74C580CED2A9F1C48B
          8CA9F9658C0978706B03E71CB61172F1FBB3AC9C5FF722A8CA55AC9C5FF749C3
          D401803201BD9D4DCAB2C41543F27ECA6858D068B6FF0C0EBD7A705046A4B942
          8C5153513D56A2B512850A00421BD0593A45B6B3C5443203540C1E29D27B9BF3
          CE39118FFAF48CE3E31FCF1DAE5D7D078FFAE9D27B0A408908D7BF3D2BCDF60C
          755180F148E5C4B972D44BF78C8898308CC4554E5F8B3EB25F5EDE2D87A34A97
          751D8ADFFF056BC3DFF37477BE97A6566945B3D9F2BD74EF7492B42F38E75EF1
          DE737C75F5ABFB37F48C96FA44B7DBCBE238AAB40DE41FF4666B7D69C83B7100
          00000049454E44AE426082}
      end>
    Left = 536
    Top = 216
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object MainTreePopupMenu: TPopupMenu
    Images = MainTreePopupImages
    Left = 184
    Top = 424
    object ShowFundsVsAssetWindowPopUp: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1092#1086#1085#1076#1099
      ImageIndex = 5
      OnClick = ShowFundsVsAssetWindowPopUpClick
    end
    object PopUpAddEntity: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1101#1090#1091' '#1075#1088#1091#1087#1087#1091
      ImageIndex = 3
      OnClick = PopUpAddEntityClick
    end
    object PopUpDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 4
      OnClick = PopUpDeleteClick
    end
    object PopUpEnterBalance: TMenuItem
      Caption = #1042#1085#1077#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1080
      ImageIndex = 1
      OnClick = PopUpEnterBalanceClick
    end
    object PopUpItemPropShow: TMenuItem
      Caption = 'C'#1074#1086#1081#1089#1090#1074#1072
      ImageIndex = 0
      OnClick = PopUpItemPropShowClick
    end
    object PopUpWhatIsIt: TMenuItem
      Caption = #1063#1090#1086' '#1101#1090#1086'?'
      ImageIndex = 2
      Visible = False
    end
    object PopUpRenameOrg: TMenuItem
      Caption = #1054#1073' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
      ImageIndex = 6
      OnClick = PopUpRenameOrgClick
    end
    object PopUpShowHideArchedFunds: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1072#1088#1093#1080#1074#1085#1099#1077' '#1092#1086#1085#1076#1099
      OnClick = PopUpShowHideArchedFundsClick
    end
    object ArchUnarchFund: TMenuItem
      Caption = #1055#1077#1088#1077#1074#1077#1089#1090#1080' '#1074' '#1072#1088#1093#1080#1074
      OnClick = ArchUnarchFundClick
    end
  end
  object MainTreePopupImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1200000B1201D2DD7EFC00000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080
          830000F9FF000080E9000075300000EA6000003A980000176F925FC546000003
          444944415478DA3C93CB6B9C551C869F73CE37C984CC6466A0491A1DCDC55A6B
          6E4D431521895A0D6EB57625886202DA28255528B870211850706142832EDAA2
          E842B120B4FF807845942E6A5A8D99A6499ADB4CCDA4E9249DDB777EE7B8A8E9
          BB7F1F78168FF2DEB3BB89A9C93DC0E67BE327DDC79F7DFA733C161B88C7E314
          0A85F2D82BAFD64D4C4D1A2B7ECFFBEFBC9DDBFDA85DC0C4D4E43E63CC5F0A76
          ACC8B031E6C7D1375EAF07F8E2EC398CD6CF94CAE53326300FC6EAEA074E8C8C
          FC710F303135D9618C993DFAE2D1C8EC952B64AE2FB8D6745AEF6D6A466B58CB
          E6585E5DA3A3ADB5F2687777EDC50B1770627BDF3D313E130068AD878D31C1FA
          8D155289148FF727B5F7E0BCC38BA2B9B191A6C64680DAECF232263054AAE1D3
          C0CC3D850FA74F5F4BB7B43C747FCB7DA0C003DE7BC45A82208252779D57D7D7
          D9DCDA92F191D100407D30F949048868ADF3FDBDBD51630C00B76EDF662D9BAD
          28A50A46EB64EB03E948B4368AB5963FAF5E25D1D0D0B4B8B256D45AEB7C3C16
          DBEEEEE98E7AC08A502A97B8BEB05809C3303D3E32DA542A979F5D5A5E09AD08
          A0E8EAEAA25A0DFF89D606DB1AD01D6DED5A89C75AC18AE54EB188F77EEED4F1
          B10D8053C7C77EB222C56A18224EF0E2686F6B4B79F14A7BD0EBB92C859D0256
          042B8231014AABF6B3DF7C1D01F8FCFCB79D409DF31E6B2DDB77B6C9DECCE134
          044E24551389D42D2E2E6DEC7F78BF510AB4D1241389FA7C7EB3F0D1F4F40E90
          6C88C702B1160F2C2C2DD1F5C88154600CC1C1CECE8A135FB9E1571736F21BFB
          52A9140A4825932A168F47ADB5D19A4804A30D22C2ADAD2D6A233592AA4F6C25
          EAEAD10ECFA599CB3D626D473C1E47C4FDAFE250402408F0DE63C5629D23168B
          512A97CCF7BFFF3274646810ED4387F7FE80B556AC15AA61856C2E8788C53987
          3887B5422E97230C43448430B4C562B1DC0EA0054F7F4FCF790FA37399399799
          CB849BF9FC777FCFCEBA6A18E2C491B996A1582E5FCA64325BF3F3F34EA14E0E
          0F3DF525800E6D15143C76E8D057626DB315491CEEEB3B668CD14A29AC58009E
          38D877D879972E552AE9230383679E7B72F06E8D2B6BEBFCF0DBAF686378E9F9
          17DA8018B0F7B5B7DE7CB9B9A5E5184AA97F6F662F9E9B9A3E0D6C033BDEFBC5
          DD9CFF1B003284B1B1A2D1FCDF0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000002264944415438CB
          8D92DD6BD25118C7F76F74D37537055D75D14DB7832228E8E56EC69AD5AA0B2B
          0817524CF437DF7EF30DF9F936F385292AA4483027C80C23BB90D491A2826F38
          152F82414428FBF63BCF96B169AD07BEE7E13CE73C9FF3E5E1CC019893C9641A
          B7DBDD0906830887C38844228846A394D99ED5FD7E3F1C0EC750A1509858CF6F
          D162B3D90A62FE86D3E3A720087B5300AFD73B12F3C135D926FE2516A2534C01
          983D16B756DE6151BB8325FD0748F92C1EAE7FC4B2E9131E5B3ED3190B8FC733
          0DF0F97C1380546C7E70A2F9A9F50F60C3F37636603C1EA35AADA25C2EA3582C
          229FCF2397CB219BCD2293C9209D4EFFDDC15191266F301850A954100804A0D1
          6808D47FFE0CB53B37301A8D66CFC0E5A2223A9D0E5AAD16EAF53A6AB51AB929
          954AA442A140779CAE1900C16EA7C3582C06A3D18876BB4D6E789E2758281482
          5EAF270782609F0658AD5602F4FB7DF47A3D74BB5D72C340CD66138D46039B5B
          4EBC102458325CC75DE595FDF997175E4D0046A38900894402168B8520F1781C
          66B39940BA8DD778139620B16BC597BD24F8ED47B8CD9FC7A5E5333A0268753A
          020C8743D2603098B8619268E6112BAD23F6F5F0215DEA3EF89494017E1040A5
          528D76329983542A05A6ED13BABA7211EF779DC7FE74BC686580C341C8E5F2D2
          EAAAF2BB4AA5865A2D8AE3C0ADAD81E398385C7E7216DAE43DA8930BD4ACDE5A
          38EEE0348917953775E7A04F2ED2CB2CB3FD6406FF09E144ED33DB479963F55F
          C99AFFDABA4756660000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000002A44944415438CB
          A593DD4F926118C6FD5BE04F68ADE66AD56A9DD5D638E8A003A7E627D0D472B5
          0C96B37498D32C2935339D0A6AEA9C8A026F02228826CA9720F062225FCAC744
          78E155B3EDEA8D359CCBD95A07BF937BCFF5DBAE67F79D0320E77FF863A0230F
          D95AF78140E3DC2755EB34F5C59EA214368A9CB1240453A63DF69902B593E6CC
          3AD2214FF8101B3B34DC412A83673B0D47208D91C568686821CC395540ACA538
          726B32B519D987F9DB2EA4737E88C69CA81F594717B10183230A5788C227953F
          D5456C714E0864E6046B72351EDC08D35870C650CB843A090FFC311ABE581A63
          8B01D448AD50AE8660F725D03A49069BC75DACAC6074292A5CF3A7B0E2894338
          68C7E31E33D207470C3F7E7384DA410B6AFA4D98B747A05D8BA04E6A1566057D
          7321D2C574ED263651DD634255F70AFCD134A6960350DBB6413302B52D086EBB
          0EAD530E58BDBB78D26D24B3820E8597760793104A2CA8FC6804AFD3C03CD663
          DAE8C32E75809D5D1ABDB32E94B66951F9410F876F0F3CB19ECE0A5AC65DB42B
          90C4D3010BB81D7A94BFD7A1EC9D0E49FA3BB62214F8622D8A5A54B8CFC0176B
          60F7C791DFA43E16BC90DA48DB561C62990BBC7603CAC4F328793B87E2D7EA0C
          85AF0814362A50D02847BD7419464F0477EBE4C715983E42853100BD2382CA0E
          4336184BEC23B247234F3493A1502403B1EA8384A973AB66E2F813F9E20556F9
          9BF9E0923302E58A1FDC360D0A9A94681B3765F815CE6F98C0B0C60D8D25809B
          D563C1EB0F47592716294F34CBB9D740A474F66DA8AD41BC942CA1A4598EA2C6
          693CEFD54369F44265F6E36AC5E7D4E507439C5357F98E50C6B9FD6C32D447AC
          E3AB3B0C8B379661D1B9832E990DB93C69E862B98473E631DD7834CABE563522
          B852314C5EE20F52B95C2975A16C803C5FDA2F3857DCC7FEEB35FE2B3F01D7AF
          05A2BD4DBDC40000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1200000B1201D2DD7EFC00000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080
          830000F9FF000080E9000075300000EA6000003A980000176F925FC546000001
          964944415478DA94923D485C511085BF591FBB88B20692686154D04A489162D3
          28484AB5B4B0492BD804B4B0114B831656D611ECD3A4336582A058A60881ACAC
          3F2B282104115CDDB7EFDE9914EFB9AEBB794B9CEECE9C396766EE1133A33936
          F77B5A920B6357C23F22434ACC172E982AAC325FB8A05D046985AF7FDE725DF9
          4539BFD796207502EF6BA87A9C0F1F4FA09A217237181EE742D4A7EA201B5F9E
          C507131083BBEB0DF58F10F990CE5C9ED2E98FFB06EE314B6F7E4BE05DC0C244
          89325B75D020737C3A1E47D5711B5EF16EECB4A5BEB93B1213BEFFFCC2860707
          A8D92560C914F260A2465501B2995E4AE5235626CF24705116A737A8460DC8BB
          6E4972098D00186A212ECAC6DFE8A28062F116A4A3DE2C620C0DD76275334E8E
          72318191285CD61D10ACCEFC6C71D8F2C797E6B5123F0C7CD4CDDAECF707B8F5
          9D5703A946F22EC0AB4792CD9D6B852D4F7F3B6B4B60E6508BD7F63E789C9555
          333CED1EADBF0F7DF5FF0944E4F9E2F66B0E0EAACDF99EA9B95C2571AFDBF950
          55E2235B23A80F78027401F926EE2280999D3726FF0E00A747AF821B5256E700
          00000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1200000B1201D2DD7EFC00000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080
          830000F9FF000080E9000075300000EA6000003A980000176F925FC546000002
          5A4944415478DA8C924D4F135114869F3BD3D232B5D5D6C650513724EC0CCA42
          63D48DB090C48F3893185BB768FC17C6ADFF40DCC36AAA0926B8286E541256A4
          B1890B8B319A0A8500A1D0324C67EE7531335088319E643E729E77CE7BE7BD17
          A514D1552F1AE6F7C786AA170DB3B7FF2FA611D67229656A1AF6F9672FD134EC
          E552CAFC1F26EA4503C014027BE0D604FBB5CFF45FBB43E3ED348015A8B007EF
          97E82CBC2379F13A2B1FE640610165512F1AA654C21E1CBFCD5EF52308010A52
          37EEF2EBCD0C0AB8F0A048FBD36CE8A9E81FB949A3F21E4D284B7C7D985285D1
          11DC9FDF40002A5A1B641F3D07606BE6052A681D6892C397682C2C20EA45C374
          BA9A7D3A9F880C024D28140254CF331AB0B1E1908C2B4B28A5582EA5CCDD7DCD
          CEE7E281CBB1523DEF0258DFF43891F0ADA1E9765928A50E92DEEE68763EAB23
          0EACA3751FD6FAA6E4A4117C0C108BC08FB53ED28644FA32ECC863BEC1345F06
          DAA18828A5981FCF9A4652DA6732FEA1A3524743ED99D5DC8EB1E768D65865AB
          2C2A63A7CCBEB8B40732EEDFB4473208E605F7662B81DB1596A6EBD8C3B936ED
          9683F4835F909EA4D372C8C4BA64625D3A2D07E9497C5F223D9F4ECB6138B78B
          AE2B5BF37DACDA5A9A424EC769BBF8BEC4E9B814723A5FD6D2D49A21EBB8482F
          60F1448C5A338DEF0B4B03CA28ACEA6A20EC3A1E859C4E753583088EAB555D09
          98BB1FB07C4A01041944DB383F9E355D5FD8A3675B2CAD64886BCA1AAB6C9523
          D695C2BE5C68B1F43B435C3F64021808B7534D5D4D4F0C2663AF571C6F727271
          671670C30C93AFAEA4EF9DEB8F4D351CEFC9D3C59DB9B0EFFD1900D243448043
          A7D6CF0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D65004D6920313720417567
          20323030352031303A33313A3335202B3031303075E0E4250000000774494D45
          07D30A06140B3600C4C4A2000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002F44944415478DA6D936F481371
          18C79FDD9D73AB6D89A6731A62589A992B459BF8A21759BEC957114110884811
          44E42BA1E845AF2282DE582F7C11BE520A229C191AEA14DCA6AB29A64BDA74EE
          AE73D331E79F7977F3F4E6ADE74261FE39F870F77BFE7C797EF7FBFE5470E871
          3A17B318C63F9C9646E4314CC0C9B2FE4EABB57738189CD9C4F42E924CAD571D
          1670BB8557E5E5EA670C13024902585B8BC1E262709D6517EC81807FD866FBDA
          49D34C6C5FEC884030B8F32B3F3FEDB2F2BDBB2BA3880C044181C7E305BBDD07
          E130B33237E77CD3DDFDB9034B62446A737BFB0825CBFC85FD354912A0D150A0
          560358AD0E5859F14163E3D3EC8282D2FB98AE467407040A0BB34C1405E987A7
          1A181849D2F4F46FBD3E3329CB000B0B9E30868B9193546A6138BC9D67B1A41D
          EEC76D489B5D5DEFBDE5E56607C7FD2DE9EBEBA131BCA1A40E4C108F8772351A
          F5118150683982AFA586865B33F5F53798E463771DAE5944A4868656D546A3B6
          AAA3E3A587A67D6704A10E4451FABF778A522061793914339BCD7C7373B3E5DE
          17B92EA90123369F43FC6453D3C38F9595396F4B4A6A1B83C14891D168CC93A4
          0468B5E930191020539F0EA7330D505171457C3769A81958900AE044BA088E36
          1F0ACC123CBF718D6196213B9BCC6B69B95B25083170387EE011EEC293B671B8
          F9A20F789E338E85336EF74CAD1742624702FF77DB9EA164CAEB9DED8946A30F
          0C069DAAB4F42C94951581D97C1E0D1405937E07FA3D09789E50934B5B04FE4C
          4205B6D64FC08E70D8FC07E1C8C141AB8BE3364224491923113E97E74995CDD6
          8F421721CE3A212CE5C2D4FC26AC8B0035A6B8BC38F87A1A1B9509C69028A91C
          054DCFB176FBC014CF475763B1A84E14B772AAABAFAA26269CD0FAE80E7CE89D
          074B9909AEEB47A5D1D1D171C51A4800492802680D109008CBD23EB7DBE94924
          C4D5E2E2E2228EE3B53FEDFDB2206993B50637B1B32DF85C2E9732BA0B593DEE
          3229C6D221CA315DDA2323A50EAF17CC23DF145F1C7B1B53840CC82924D559C9
          BD69A3C8B612F807D3985AD7788818D30000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE900000006624B474400FF00FF00FFA0BDA793
          000000097048597300000B1300000B1301009A9C180000000774494D4507DB02
          0E0C0D1666525067000002244944415438CB8DD35F48936114C7F1EFFB3CDBBB
          36DD3095E594865AA3A024282842C3220945308D08A3B040A88BBAA88B10F22E
          A8C8E8B2840889082F0DA4404328FF412D0A029370CE74E59FA52B8B6D95DBF3
          3EDD881782BADFE581F3E1C039C76039BDD52526309CB0DC66DCF23434F50D4D
          90697AAB4BBC0367F62AFDE695FEF1F4A1AE693CAD3BAA760532E91500C22687
          0AB24CF1733CC46067279B7D053CF3ED1BCB08F8D4B8B3D52508D8B4C57CFF63
          9CF7EED3D0DC8C3B3F8FC1ABA6DE10985C8C3D4A5B9A54527169D6C38DCB5770
          4841DBA95FF8F39708B6CA751151DB331FFD9DB277B5987BD85F5B8F3BCFA4E8
          C37972935DF82FB6B3C5A5085E971B4EC293AA8A8AE3E7CEEA916BE8E4704027
          9E0B1D7FE9D67AA15D4FDD44BF5D0331561782AD52BB9614A5F50152B130D81C
          78B61612E90E3397901CB8A58C750180FE169BCEB3D214D716915E9C451B929C
          523F91EE30B309C9CC9CE13CD191FEBBB2C6D5A9BC933662C2C6E48B69707A50
          29452C1CC15FB70DAF4B29334B8E3D38EA116B022B8821F9D6B788706CC24A2B
          A29F27292CDF21FE38EB8A1C5966DDBA0040659B321690CC0C24894EF35EA5AD
          503CFBB6A5ECF942F80E366D08001CBEAB8CEF96647CD42AEB099E0C444642B2
          FCD82194CCAE01B06572AEE151A75F78778FC6FFA5EC03C3EF74EEE790783D15
          35D7DCC2727C801370010EBB14B623DBBDFEB2D2E20B634959F5F1CB57229188
          6164F8B039800978003B20812430F11F0CA4D1B09C47BA200000000049454E44
          AE426082}
      end>
    Left = 184
    Top = 480
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object StrGridPopupMenu: TPopupMenu
    AutoPopup = False
    Images = StrGridPopupImages
    Left = 952
    Top = 360
    object SGPopUpClose: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1100
      ImageIndex = 2
      OnClick = SGPopUpCloseClick
    end
    object SGPopUpDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1100
      ImageIndex = 0
      OnClick = SGPopUpDeleteClick
    end
    object SGPopUpEdit: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 3
      Visible = False
      OnClick = SGPopUpEditClick
    end
    object N1: TMenuItem
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1090#1091
      Visible = False
    end
    object SGPopupWhatIsIt: TMenuItem
      Caption = #1063#1090#1086' '#1101#1090#1086'?'
      ImageIndex = 1
      Visible = False
    end
  end
  object StrGridPopupImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446920333020536570
          20323030332032333A35343A3236202B3031303065D5FFC10000000774494D45
          07D30A06140A3580D6A459000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000002EA4944415478DA4D535F485371
          14FE7EDB6E6ED3796D6AABA6199292E29FA8C408B55ECC282A10C10C1F4AA2DE
          7A2AE8B51E7AE845A8DE7A8C22040B538B90FE589945561A6865A2D6A666BAE9
          DD1FB77BEFEEFD75EEDD940D3ED8CEF97DDFCEF9CE3940DAE703D03000DCBF0B
          D4D14F0781ADE75E03E7FB185EDC065A72009142D6742E7E01B7FCCD0775F57A
          2B1F606C9842FB089946EE237074A2344FE1674AB9AF4AE4DD563646E1624286
          6543A120F7A4F7D81E66DB045434961FE8005A29BAED1950CBBC6257D9A10201
          31194AA6804F1AFF43B90642CE86C0B43FD0A3CEFE0564195B6B77A2DDED3CD7
          021C77E5673FA93955E68214415856F1FE7370BE1358228A6E60A38F7A20E4D6
          B50E77713E432C8E8222D1E9F5859AEADAAAB3B0BA0A5D9531F235A85F5D517A
          168059A20C12E6362AB8087C9D1E9E1A464205D404048780FAD3150C9204682A
          267D613CF0459F8ED31F256D3145947427F51ACE650F4373CE163B109781B538
          8929580A46D1F37671E20630C5CD61C1303960706CEBEC21C04B8D9DB58B343D
          95AA5014936C7E8FA9903822F46F731A308AA4071A52B364EFA8036BA1FBD1E1
          F6FD65D9C6E0D662305B5192029976864A8FE02DF4C7C400C7901F98A757AA29
          F01C682EAA2DBA57D9586CB784A464E98904344586857AD7131A6969C8A05ACB
          B70B9EBC65F5884BE50B54C68CE18185D4A286C3580E12396E8E311489A27760
          2E31FD3B4CABA881EB2442A236C6D1B4D7EED9055C207235C169C9B5B29B3B8A
          B2A8CF98495E94A2E87FB518BC14561F768E4ABD337E8AEB3A3855A2681A46A6
          15F4013F529BE8B42D697C500B47AA6407C3243D7E39267DBFA6F39115C07707
          18CFFB168EB4EE76B48136746A4E417740EBA511AC1179912033DAB6921382A5
          4BB7B1BCC7316DB81F0893BD3F9383C11441BC0C5CA1E511E9D0A47F94A7D817
          C21BC2BC716D198492E432820ECD34C738161F214A108C4B215412ECA9F86C6A
          942A4B9DAC91D89C7A1C4172DBD4B42533F6C5957A4BA680DC063712FF01ED26
          4369DCC167DB0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000002A44944415438CB
          A593DD4F926118C6FD5BE04F68ADE66AD56A9DD5D638E8A003A7E627D0D472B5
          0C96B37498D32C2935339D0A6AEA9C8A026F02228826CA9720F062225FCAC744
          78E155B3EDEA8D359CCBD95A07BF937BCFF5DBAE67F79D0320E77FF863A0230F
          D95AF78140E3DC2755EB34F5C59EA214368A9CB1240453A63DF69902B593E6CC
          3AD2214FF8101B3B34DC412A83673B0D47208D91C568686821CC395540ACA538
          726B32B519D987F9DB2EA4737E88C69CA81F594717B10183230A5788C227953F
          D5456C714E0864E6046B72351EDC08D35870C650CB843A090FFC311ABE581A63
          8B01D448AD50AE8660F725D03A49069BC75DACAC6074292A5CF3A7B0E2894338
          68C7E31E33D207470C3F7E7384DA410B6AFA4D98B747A05D8BA04E6A1566057D
          7321D2C574ED263651DD634255F70AFCD134A6960350DBB6413302B52D086EBB
          0EAD530E58BDBB78D26D24B3820E8597760793104A2CA8FC6804AFD3C03CD663
          DAE8C32E75809D5D1ABDB32E94B66951F9410F876F0F3CB19ECE0A5AC65DB42B
          90C4D3010BB81D7A94BFD7A1EC9D0E49FA3BB62214F8622D8A5A54B8CFC0176B
          60F7C791DFA43E16BC90DA48DB561C62990BBC7603CAC4F328793B87E2D7EA0C
          85AF0814362A50D02847BD7419464F0477EBE4C715983E42853100BD2382CA0E
          4336184BEC23B247234F3493A1502403B1EA8384A973AB66E2F813F9E20556F9
          9BF9E0923302E58A1FDC360D0A9A94681B3765F815CE6F98C0B0C60D8D25809B
          D563C1EB0F47592716294F34CBB9D740A474F66DA8AD41BC942CA1A4598EA2C6
          693CEFD54369F44265F6E36AC5E7D4E507439C5357F98E50C6B9FD6C32D447AC
          E3AB3B0C8B379661D1B9832E990DB93C69E862B98473E631DD7834CABE563522
          B852314C5EE20F52B95C2975A16C803C5FDA2F3857DCC7FEEB35FE2B3F01D7AF
          05A2BD4DBDC40000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002A744558744372656174696F6E2054696D65004D6F2033204D727A20
          323030332032323A34323A3130202B30313030FF26557B0000000774494D4507
          D30A06140A2A0DDEA9AC000000097048597300000AF000000AF00142AC349800
          00000467414D410000B18F0BFC61050000021D4944415478DAB593DB4F134114
          877F3BDB764BB10834A0C1DA8460C5885A92465BE393FE07C6175FB509AFA63C
          F8C4BF811A216AA226A2468C573084CB83F186551FD494205DA0914B2D2D5DB6
          652FDD7A76B3A29246F1C133F9929939F3ED6CCECC00FF1E9CCDC6606BD10B3F
          6760D0597608EA0BFD1C06F08666657E4BF20DECE4556EF4FCD1AE43429DBC23
          25678E5426F092322B8EBFCA37D18C158C744763EDC3E941541807C698CF8011
          A1EC3C33D7B425EA438107DB4E62176A69F8F3AFAEC2C765F1AC3B12EB18F9FA
          103AAB2099CC97F42BC610655D04636D8FEBBAC2C5F0DB4ECFFE7B420F2ED3A4
          DF4A5E43030A188E4763A1B18547D050C6F45461BD7441BD8B396468CD3B22CF
          B79F6E7D12F07ABD59651E2E8FEBE072B0D88225247100B7E2D13387C7179F42
          E334A4A625A5D84BF28C258F12096295574E948E732E25088E430D73C2E1651D
          B956E554FCD8D9BD139921A8D4C41949952FAA77F065439E340B48187C31AD3D
          9FF5AD461A1B6B76D337E074308403FB6A3FE426A15434CCA6244DBEA4DEC694
          258F11E6F1658932AC822D621D2924169AD7420D3EB71F54D64C31079D373027
          4ABADC4FF2674B30777E4D7CFB21C3AE7819396A22DE2F35C99DDB9BDC2DBCC0
          90160BFA5A9F3A808F96305E4DC62F4756469E761191C80AA53DF9BCE2295DD7
          EF939CB5E5574466B3BCF92A9B7D371124CC4B524F7CB2ABBD5C4DAEF616CCB1
          60CB4E42B2A92AFF297E7B71FF35BE035888D4F678C2D3F00000000049454E44
          AE426082}
      end
      item
        ImageFormat = ifICO
        ImgData = {
          0000010001001010000001002000680400001600000028000000100000002000
          0000010020000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000100000001600000024000000290000002C00000022000000000000
          0000000000000000000000000000000000000000000000000019000000220000
          002C000000330203053718274655384973BB3B3F4DFF1E1E1EFF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000C499B1D385F9DF3506091FE546490FD6477A2FF424B5CFD000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000373BEFF0067AFF955719DFF899FCEFFA6C1E3FF596A9CF7000000000000
          0000000000000000000000000000000000000000000000000000000000000375
          C0FF0075D4FF0291D3CC01A7E5DAAECBECFC697BA8FF4D679FAE000000000000
          00000000000000000000000000000000000000000000000000000376C1FF0075
          D4FF0AB3EEFF02ACEAFF03ABE8FF27BFF8FE5576ABFD144E9D50000000000000
          000000000000000000000000000000000000000000000477C1FF0075D4FF10B9
          F0FF02ACECFF05B0ECFF23D3FFFF0084DEFC076DB4E20E439602000000000000
          0000000000000000000000000000000000000477C1FF0075D4FF1BC0F4FF02B0
          F0FF05B1EFFF23D3FFFF0085E1FF037AC8FF0462AE0800000000000000000000
          0000000000000000000000000000037BCAFF0075D4FF25C5F6FF02B2F1FF09B6
          F1FF23D3FFFF0085E1FF037AC9FF000000000000000000000000000000000000
          0000000000003C44A23C5C5F4FFF0075D4FF25C5F6FF02B4F5FF0DBAF4FF97EC
          FFFF0085E1FF037AC9FF00000000000000000000000000000000000000000000
          00002847B3AD626150FF98977AFF4B5649FF36A5CDFF10BDF6FF97ECFFFF0085
          E1FF037ACAFF0000000000000000000000000000000000000000000000001548
          B517234CC1FF335BD9FF484C44FF45433CFFD6D7B2FF62C7E4FF0085E1FF037B
          CAFF000000000000000000000000000000000000000000000000000000002858
          D57B244EC5FF3665DEFF3A65D9FFD5D7BAFFD4D4ABFF71715AFF0671C3FF0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000244CBBDA3866DAFF9AA4EEFF404AB1FF71715AFF5E5D4DFF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00002148B916325BC2FDBFC8FFFF9AA4EEFF595849FF2B449E25000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000002148B9062148B9CB2E46AED13C44A22200000000000000000000
          000000000000000000000000000000000000000000000000000000000000FFFF
          0000FFF10000FFC10000FF810000FF010000FE030000FC030000F8070000F00F
          0000E01F0000803F0000807F000080FF000081FF0000C3FF0000E7FF0000}
      end>
    Left = 864
    Top = 344
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object DebCredPopupMenu: TPopupMenu
    AutoPopup = False
    Images = DebCredImages
    Left = 944
    Top = 408
    object DCPopUpList: TMenuItem
      Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080
      Default = True
      ImageIndex = 0
      OnClick = DCPopUpListClick
    end
    object DCPopUpSearch: TMenuItem
      Caption = #1053#1072#1081#1090#1080
      ImageIndex = 1
      ShortCut = 16454
      OnClick = DCPopUpSearchClick
    end
    object DCPopupAdd: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 5
      OnClick = DCPopupAddClick
    end
    object DCPopUpDel: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 3
      OnClick = DCPopUpDelClick
    end
    object DCPopUpProp: TMenuItem
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072
      ImageIndex = 2
      OnClick = DCPopUpPropClick
    end
    object MenuItem3: TMenuItem
      Caption = #1063#1090#1086' '#1101#1090#1086'?'
      ImageIndex = 4
      Visible = False
    end
  end
  object DebCredImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D65004D6F20313520417567
          20323030352031313A33313A3134202B30313030D9FE197A0000000774494D45
          07D3021B100E3406B73D94000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002524944415478DAA593CF6B1351
          10C7BFFBDEFE48B64DD336B11612A12054448C372F2256940A1E0405413DEA41
          F158A85EBCE8CDFF40F1A88882276905F152510FF522F6241691B616531B69B2
          E926D9F7D349680A357AEA83618761BE9F99376F16D8E571BACE8DEB57EEE7F3
          B943DA8039A29EE3E93060CC0C7166068550FEA7CF95D3B3B32F3FFC9774EFEE
          F45BDB39CADAF917F46D9055C8CA76E5C77B3B3D75213A77F6FCB1BF75BCEB4C
          4E9EB8696D5C28AF97B137AE421746209B1B50AD0A96BE2FA1745806E3FBFD8B
          B5B8F86E71F1CB7257C7B6498C85C54211A3F951284537332EB8DF87D4C008AC
          3F8899D735ACFE149930D87C353171EA6457E7761D63757AAC3084785321D112
          9CAA43C76841E2E0588823539728DBC1B5AB51E6F69D670FE6E6706007C0AA24
          631C03D3AC0129D60EB4A36D349456504D41BE80E7D42924644F077E980AD636
          1AD893EA8793CDC11D1A811611A4A8432B0D43064777A0461BDE03804EF8F3A7
          4F70A6348E7DFD1E587DA5DD31CDC145AA2F4BE26CA703A04A880E69274029C5
          6F4D5D46F5E3022CA38A545980F2124573505B628554202095FA17403070970A
          651150B2F119B52E60B5D86ABD0DA1AB1B056B0D7A00DA1ADD4E624915C80F23
          087D309EDE5A56129B18526E82DB1A3CD7E9EF01C8A4611E3D7C8CE3F494A3C3
          1E922A55EB54D29D177118ED380D25ED0ADA75F83D002164E36869A02FEF7930
          D13AFC4C8E84B23D73EA8160B41B3A69A25CAD11577A3D805F95C6FCCC9BD592
          EBB903AD280EE1318773DE94CA56A2A8B5BEBC122D7CFDF67BD96AB3C6B8D9D8
          ED5FBC7DFE00353025184304863C0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002D744558744372656174696F6E2054696D65006A65752E20352064E9
          632E20323030322031323A32313A3130202B30313030603BD286000000077449
          4D4507D30115140006F095E4A5000000097048597300000AF000000AF00142AC
          34980000000467414D410000B18F0BFC6105000001FF4944415478DA636018F2
          80119B607A7A3ADF9B376F821919196DDEBF7FBFFEF3E7CF3B4F9D3AF51BA701
          515151D66C6C6C1D0202021FE5E5E5357EFDFAA5C8C2C2C2C4C5C5C5F0F7EF5F
          86F3E7CF5FBB79F366DE912347F6A21BC00C22646565F718181818464444A809
          0B0B0BF1F2F232FEF8F183E1D5AB570CCF9F3F67E0E4E41405E2583E3E3E6D1E
          1E9E33AF5FBFFE0033800544009DC9A4AAAACA70E7CE1D101B6CEBEDDBB719AE
          5EBDCA202424C4A0AEAECED0D3D303726D6853538BDFBBF7EF667DFFFAB96ED6
          EC391FC02E9096963EF5EDDBB7C00F1F3E70B1B3B333005DC2606264CCF0F4C5
          1786DF3FBF33BC7EF392414E5696E1EAB53B0C86A64E2CAA56FEE6678EEE52BF
          70EECC4AB0014F8140505070FBFDFBF7034D4D4D79BE7EFEC870E3F14F86D8F8
          08065E757B867D6BE7300808F033FC15D26250D05466F8C6CCCC70FBEA75E953
          87777730C1FCB267CF9ECBC080B4DBB37BF7BD8B576E31489A5831DCFFCCC0F0
          979F9781859DF3F296CD9BB73F7CF19AE1F8630686AB8F18183EBF00FA171688
          3070EFDEBD77C040DCF2F7CFCF6066152FBE575F99195EDEBDCF7061D7A2EEDF
          7FFF17FCFFF044EDF5E3673A4F4EAFF974F9ECD184A7CF9E3FC49A0E92931335
          FF32F1EDE69350937E76FDD0A1278FEF7B9E3879EA1B48CED9C9410D18D0AFCE
          9DBFF881011FB0B3B3E1B4B1B654C595D88611000004DFD98685D7A784000000
          0049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1200000B1201D2DD7EFC00000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080
          830000F9FF000080E9000075300000EA6000003A980000176F925FC546000003
          444944415478DA3C93CB6B9C551C869F73CE37C984CC6466A0491A1DCDC55A6B
          6E4D431521895A0D6EB57625886202DA28255528B870211850706142832EDAA2
          E842B120B4FF807845942E6A5A8D99A6499ADB4CCDA4E9249DDB777EE7B8A8E9
          BB7F1F78168FF2DEB3BB89A9C93DC0E67BE327DDC79F7DFA733C161B88C7E314
          0A85F2D82BAFD64D4C4D1A2B7ECFFBEFBC9DDBFDA85DC0C4D4E43E63CC5F0A76
          ACC8B031E6C7D1375EAF07F8E2EC398CD6CF94CAE53326300FC6EAEA074E8C8C
          FC710F303135D9618C993DFAE2D1C8EC952B64AE2FB8D6745AEF6D6A466B58CB
          E6585E5DA3A3ADB5F2687777EDC50B1770627BDF3D313E130068AD878D31C1FA
          8D155289148FF727B5F7E0BCC38BA2B9B191A6C64680DAECF232263054AAE1D3
          C0CC3D850FA74F5F4BB7B43C747FCB7DA0C003DE7BC45A82208252779D57D7D7
          D9DCDA92F191D100407D30F949048868ADF3FDBDBD51630C00B76EDF662D9BAD
          28A50A46EB64EB03E948B4368AB5963FAF5E25D1D0D0B4B8B256D45AEB7C3C16
          DBEEEEE98E7AC08A502A97B8BEB05809C3303D3E32DA542A979F5D5A5E09AD08
          A0E8EAEAA25A0DFF89D606DB1AD01D6DED5A89C75AC18AE54EB188F77EEED4F1
          B10D8053C7C77EB222C56A18224EF0E2686F6B4B79F14A7BD0EBB92C859D0256
          042B8231014AABF6B3DF7C1D01F8FCFCB79D409DF31E6B2DDB77B6C9DECCE134
          044E24551389D42D2E2E6DEC7F78BF510AB4D1241389FA7C7EB3F0D1F4F40E90
          6C88C702B1160F2C2C2DD1F5C88154600CC1C1CECE8A135FB9E1571736F21BFB
          52A9140A4825932A168F47ADB5D19A4804A30D22C2ADAD2D6A233592AA4F6C25
          EAEAD10ECFA599CB3D626D473C1E47C4FDAFE250402408F0DE63C5629D23168B
          512A97CCF7BFFF3274646810ED4387F7FE80B556AC15AA61856C2E8788C53987
          3887B5422E97230C43448430B4C562B1DC0EA0054F7F4FCF790FA37399399799
          CB849BF9FC777FCFCEBA6A18E2C491B996A1582E5FCA64325BF3F3F34EA14E0E
          0F3DF525800E6D15143C76E8D057626DB315491CEEEB3B668CD14A29AC58009E
          38D877D879972E552AE9230383679E7B72F06E8D2B6BEBFCF0DBAF686378E9F9
          17DA8018B0F7B5B7DE7CB9B9A5E5184AA97F6F662F9E9B9A3E0D6C033BDEFBC5
          DD9CFF1B003284B1B1A2D1FCDF0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446920333020536570
          20323030332032333A35343A3236202B3031303065D5FFC10000000774494D45
          07D30A06140A3580D6A459000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000002EA4944415478DA4D535F485371
          14FE7EDB6E6ED3796D6AABA6199292E29FA8C408B55ECC282A10C10C1F4AA2DE
          7A2AE8B51E7AE845A8DE7A8C22040B538B90FE589945561A6865A2D6A666BAE9
          DD1FB77BEFEEFD75EEDD940D3ED8CEF97DDFCEF9CE3940DAE703D03000DCBF0B
          D4D14F0781ADE75E03E7FB185EDC065A72009142D6742E7E01B7FCCD0775F57A
          2B1F606C9842FB089946EE237074A2344FE1674AB9AF4AE4DD563646E1624286
          6543A120F7A4F7D81E66DB045434961FE8005A29BAED1950CBBC6257D9A10201
          31194AA6804F1AFF43B90642CE86C0B43FD0A3CEFE0564195B6B77A2DDED3CD7
          021C77E5673FA93955E68214415856F1FE7370BE1358228A6E60A38F7A20E4D6
          B50E77713E432C8E8222D1E9F5859AEADAAAB3B0BA0A5D9531F235A85F5D517A
          168059A20C12E6362AB8087C9D1E9E1A464205D404048780FAD3150C9204682A
          267D613CF0459F8ED31F256D3145947427F51ACE650F4373CE163B109781B538
          8929580A46D1F37671E20630C5CD61C1303960706CEBEC21C04B8D9DB58B343D
          95AA5014936C7E8FA9903822F46F731A308AA4071A52B364EFA8036BA1FBD1E1
          F6FD65D9C6E0D662305B5192029976864A8FE02DF4C7C400C7901F98A757AA29
          F01C682EAA2DBA57D9586CB784A464E98904344586857AD7131A6969C8A05ACB
          B70B9EBC65F5884BE50B54C68CE18185D4A286C3580E12396E8E311489A27760
          2E31FD3B4CABA881EB2442A236C6D1B4D7EED9055C207235C169C9B5B29B3B8A
          B2A8CF98495E94A2E87FB518BC14561F768E4ABD337E8AEB3A3855A2681A46A6
          15F4013F529BE8B42D697C500B47AA6407C3243D7E39267DBFA6F39115C07707
          18CFFB168EB4EE76B48136746A4E417740EBA511AC1179912033DAB6921382A5
          4BB7B1BCC7316DB81F0893BD3F9383C11441BC0C5CA1E511E9D0A47F94A7D817
          C21BC2BC716D198492E432820ECD34C738161F214A108C4B215412ECA9F86C6A
          942A4B9DAC91D89C7A1C4172DBD4B42533F6C5957A4BA680DC063712FF01ED26
          4369DCC167DB0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000002A44944415438CB
          A593DD4F926118C6FD5BE04F68ADE66AD56A9DD5D638E8A003A7E627D0D472B5
          0C96B37498D32C2935339D0A6AEA9C8A026F02228826CA9720F062225FCAC744
          78E155B3EDEA8D359CCBD95A07BF937BCFF5DBAE67F79D0320E77FF863A0230F
          D95AF78140E3DC2755EB34F5C59EA214368A9CB1240453A63DF69902B593E6CC
          3AD2214FF8101B3B34DC412A83673B0D47208D91C568686821CC395540ACA538
          726B32B519D987F9DB2EA4737E88C69CA81F594717B10183230A5788C227953F
          D5456C714E0864E6046B72351EDC08D35870C650CB843A090FFC311ABE581A63
          8B01D448AD50AE8660F725D03A49069BC75DACAC6074292A5CF3A7B0E2894338
          68C7E31E33D207470C3F7E7384DA410B6AFA4D98B747A05D8BA04E6A1566057D
          7321D2C574ED263651DD634255F70AFCD134A6960350DBB6413302B52D086EBB
          0EAD530E58BDBB78D26D24B3820E8597760793104A2CA8FC6804AFD3C03CD663
          DAE8C32E75809D5D1ABDB32E94B66951F9410F876F0F3CB19ECE0A5AC65DB42B
          90C4D3010BB81D7A94BFD7A1EC9D0E49FA3BB62214F8622D8A5A54B8CFC0176B
          60F7C791DFA43E16BC90DA48DB561C62990BBC7603CAC4F328793B87E2D7EA0C
          85AF0814362A50D02847BD7419464F0477EBE4C715983E42853100BD2382CA0E
          4336184BEC23B247234F3493A1502403B1EA8384A973AB66E2F813F9E20556F9
          9BF9E0923302E58A1FDC360D0A9A94681B3765F815CE6F98C0B0C60D8D25809B
          D563C1EB0F47592716294F34CBB9D740A474F66DA8AD41BC942CA1A4598EA2C6
          693CEFD54369F44265F6E36AC5E7D4E507439C5357F98E50C6B9FD6C32D447AC
          E3AB3B0C8B379661D1B9832E990DB93C69E862B98473E631DD7834CABE563522
          B852314C5EE20F52B95C2975A16C803C5FDA2F3857DCC7FEEB35FE2B3F01D7AF
          05A2BD4DBDC40000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1200000B1201D2DD7EFC00000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080
          830000F9FF000080E9000075300000EA6000003A980000176F925FC546000001
          964944415478DA94923D485C511085BF591FBB88B20692686154D04A489162D3
          28484AB5B4B0492BD804B4B0114B831656D611ECD3A4336582A058A60881ACAC
          3F2B282104115CDDB7EFDE9914EFB9AEBB794B9CEECE9C396766EE1133A33936
          F77B5A920B6357C23F22434ACC172E982AAC325FB8A05D046985AF7FDE725DF9
          4539BFD796207502EF6BA87A9C0F1F4FA09A217237181EE742D4A7EA201B5F9E
          C507131083BBEB0DF58F10F990CE5C9ED2E98FFB06EE314B6F7E4BE05DC0C244
          89325B75D020737C3A1E47D5711B5EF16EECB4A5BEB93B1213BEFFFCC2860707
          A8D92560C914F260A2465501B2995E4AE5235626CF24705116A737A8460DC8BB
          6E4972098D00186A212ECAC6DFE8A28062F116A4A3DE2C620C0DD76275334E8E
          72318191285CD61D10ACCEFC6C71D8F2C797E6B5123F0C7CD4CDDAECF707B8F5
          9D5703A946F22EC0AB4792CD9D6B852D4F7F3B6B4B60E6508BD7F63E789C9555
          333CED1EADBF0F7DF5FF0944E4F9E2F66B0E0EAACDF99EA9B95C2571AFDBF950
          55E2235B23A80F78027401F926EE2280999D3726FF0E00A747AF821B5256E700
          00000049454E44AE426082}
      end>
    Left = 848
    Top = 408
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object TimeFilterImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500467220323820466562
          20323030332031313A35313A3531202B303130307CE9F46F0000000774494D45
          07D30A06140B18DC12C96D000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002754944415478DA8D52BD6F5271
          14BD8F47A1348580210129A93838980E3AC8E0804D8C9BE9D2D1B8B07771F01F
          E8D2ADAB7F0021711116130685802606EA0051689582A540F82C1F79807C159E
          E7BE3CB45F8337B9EF97F7DE3DE777CFB95720C4EEEEAE667B7BFB592E977BDE
          EBF51E8AA27847AFD79BE6F3394DA753A9DD6E978F8E8ED2C964F223CE0F9D4E
          6700D8396385D3D3D3078944C29F4AA53618B0B6B6460E87839C4E27994C2632
          9BCDCAB9B2B24220279FCF97DBDFDF7F95CFE7A3C00F44ABD51AF6FBFD1BB895
          565757C9603028C546A39196969648ABD5922008C4FFF9BBDBEDBED5ED769F44
          A3D12F2068695074D6EFF7096D912449341C0EB96DE26E18C8043A9D8E208916
          011967381E21CD9A72B9FC7A6767A7BDBEBE4ED04AB55A8D06838152C81D592C
          16A51B260D0683B4B5B5D50A0402DFF07B8A9C0B7818BC5EEFCBBDBDBD372812
          D3E934351A0D9ACD6634994C14D242A140CD669346A3D139FC7A8B6F45E0DE23
          53221E33187802801EEC8F6D361BC117B2DBED8AEE0BB2E44C26F30E1D378109
          23B98BBEA8CA1AC7E3F1EFD07A7F7373F31E7B82DBA8D56A51A954A27ABD4EC7
          C7C7118CB18EDA4FC80324FB202F0864E4B0582CA69697979F7A3C1E2BFBC07E
          004818D9612C16FB29CBF2814A50E1CE1928D2BF98631252B55ACD42CE0B4C41
          C866B30C9E8442A130241CAAAD17540395D0D0E518A3CDCF98C8D4E572293B01
          2325C8E9E35F0279C23517015709580ACF70C426AAE3FB8D77496D7B70A5FE1A
          814252A954C23C01F841E3F178A8DE3ABDA1F692077F03C67D8D442256CCDB82
          ADFB81BDC8AB63EB5EAD15E8E6E0BDBDABAEEB6DE42F644C1DDD7F112C484CBC
          A93C62F5F66B32FE0009C54C626771979A0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500467220323820466562
          20323030332031313A35313A3531202B303130307CE9F46F0000000774494D45
          07D30A06140B18DC12C96D000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002E14944415478DA75535F485A61
          143FF75ED3D43215C14857326814EE4F0F73AC8D34A2B7D14B8F632FB1575FF6
          B00DF6E84B6F31B687B1BD8D260C46C6604451638E5C68114AB372694C5D64A6
          A9A8976BFEB9EE9C8BB12DDA81DFFD2EDFFD7EBF7BCEEF9C8F010C97CBC54E4E
          4E8EC762B17BA5526988E3B83E8542A11145116AB55A3197CB1DECEEEE8683C1
          E00AAECBF97C9E475A9DB84C2291B8110804DCA150C84A0493C9043D3D3D6036
          9B41A3D18056AB9556954A05280EB3B3B3B199999947FBFBFB5EE4F39CC160F8
          EC76BBADF857E8E8E800A552291DEEECEC84B6B63690C964C0300CD077DAB7D9
          6CFA42A160F77ABD6B2870C2E2A16CB95C064C0B8AC522088240690365434412
          90CBE58025C1596019595C6E22B4ECC1C1C163A7D399EBEDED05AC158E8E8E80
          E779E92065A4D3E9A46C48747E7E1E2626264E3C1ECF167EAE2144061FCAA9A9
          A907D3D3D3AFF010170E87E1F8F8181A8D0654AB5549341E8F432693814AA552
          C71291EF4920EF2322C8E1A38106FE448202D5878D4623A02FD0DDDD2DD5FD57
          594DCC64C96EB737162EBB1CB0FEE61D72B35CABAC53BFDFFF1D6B1D74381CFD
          E409CBB2D06C36211289403A9DA68CD646474785D79961DB615D6582B5979BC8
          4B9D0934114232990CB5B7B78F8D8C8C18C8B4685606B6A101B86A1D2CAAD5EA
          D862FE9A7525C95E0295A202BE177BC8D9E6E04F88D889622A95DAC3BFDDB758
          2CCCC3E75BB0B89D85B17E39F32DD535E00E895D7586ADC1E1D765D859489307
          2CFC1BA7386DAB7ABDBE4ACE9BB52204B6ABF06C4E90CF051BE8039ABEF8E43D
          7C70FEA26E224AE705A8141E5B57A4A1193725E17A9F1AFC3B0588A704B8A5CB
          8B90FC426756113E44E1BC8024825EF8C8C08A5086B74FEF028BEFC3570C30D6
          B549F35F42441087340BDC0502108D4637F03EDCC6F619D77D4B0C5F538A7734
          1B6CF594FF81DDA2D4FD34C6D265828B83E6B61F61475810F2D63E4D5F14F1A9
          95C17F059896881EA1469C952A7944034486D3C66F553D5A8A5963AFD2000000
          0049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446F203134204E6F76
          20323030322032333A33313A3434202B3031303084501C480000000774494D45
          07D30A06140B3370AE302D000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC61050000030B4944415478DA5D936D485361
          14C7CFDDEE746E3337E7A66E0B75998A5828851136EB8394FA21925EA4920A4A
          328CC8A20804A1088BA20F5108A154249819456F4A96182653CB3244B734DFE6
          66BAA69B7BD16DDECD7B3B57AEF872E1C73DF7DEF33FF73CFFF33C04ACBF4AF4
          17A394D222094164F08314653699F581C9911AF852D6885FBDC8E2EA74FEEA07
          A2DC54A58E4B2A976F50AA14D14A42111B431664276BCD1E619E9B880E82A56D
          10D3FC08C3A6AF2D50FAF3142F9439EFFEF5FAF17453658765D868E14913B4E2
          0899604F7A4C88C52DCA748D1987E4852F6E89B79E3DE7EDADFE80AAE0CAEF8B
          BB1EC0E69C7C36428E23059098772DEDE6B0F74A2BC3DCFECE30905FE7ACFE41
          336917BE7AF07B11A25AE9A0A7A6031CA3428CC6913E64181CC38336BF127665
          EDC8524848D89FB345181D4940C3CBD6B1B981B756CCE9E72D89AF4E8A40BB93
          C268684908308DB820F74D0008E9427BA78191840288309BC095CF8C0FD93833
          6912CEB41DD99B423D1356D411668FC036E3F059FFD99DD6C044F73DA083854F
          EF979668240024DA16A451814582D326078ADD488084C505DD93C371A1A6597C
          4381C6E607CD08C637EE74B9C0F0BCA9F8B25F1E151E96288F8C50C4284314BE
          399A01EFA01DC5980514291693DA199CEE9813CB615377DFF7D2C6FACA0618FD
          F817FC6E7F60F4D5C329800424B61F400C0429042688D93086F848D50671C28C
          0F4BA1D88F64266A784682A051CC9A3980A016D8F9B306932826D9D61176195E
          9E542C8AEF32D3505CD5EC640B44C5C861D3818A83A0CD0DC78479841D990D72
          3FE3189B8F623C895810B60B9A4FA5971C6AFFD6FDDB577FBAD310A24B56C76B
          04CA5805E91667E85C61A911A0CA9741CA890242C07F048EBE4F30D1C29A37C7
          AE1FB8EDA84272965A4C3D2651EFBB747DBB6E9B64015D9FC7143BFE67D66A67
          A65A6A6B415FD68E79066E9FCC2D17C009836CF938803A7B372F31EFA42C4997
          058250A167A8C740FD69EC81F1776CEBE823E8395F16970BACBF4B9124241DD9
          B8641CEE1DCEC85ECE8300AC13AE39949CE36C2111F74C71667AD61E2080FFB0
          D131F7DFD39F6A0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500536F2032382044657A
          20323030332032323A35363A3237202B30313030163854F20000000774494D45
          07D30A06140B174CADD4FC000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002574944415478DA8D534D4F1341
          187E6677BBEDB6A59612B045B02A722B078926A6D1E8C190183918C4AB3FC293
          FE08EEEA5F10BFAEEAC9837AC1C4AF18432A5283440DC6D0D0DDD9F9F29D6D4B
          A8EDC149DED9CCEC3BCFFBBCCF3CC340E3F3F37A9CCDA5DD907BD060760B91C8
          D0EC81C70C9A058863404A83B0CDB17863F504FDFC61D3BC24DB1F7573C72F38
          EB8FEF42B002423A1C0A09AE02B445804801AD308D730BE791DA7EAAE9C412C5
          438ACD04406B033F5FC1ECC565AA9F86D41E8464E0C285542E844E11130795A9
          3CD6BF2725AB1496222C00D3864109414094A8B308791AB9E228C60B65689585
          A102C63860AE84D2383858C2208AA892D0587BB106D7F330522C0127EBC80613
          A8544EED676F6D7F84E7A59383BDBD04C0D8B53B86F94B57A902B56032189FC8
          A2B5FB0BCDE66BDB64926A1063AFDD4FA103A019860DC64A989E3EBDBFFEB6F5
          16CA6010800B9FFA9768BCBA8F161FC34E54C2D4EC1C6A35460C1E81F33C82E0
          1809CBA1546A10C0AACC3C1FB5CBB7E13087C03A4D1AA3E9EE051C2743BD3B74
          23CEBF227601C82446C6F8F0E4162233422C0EE14F54C04E2B8F2B4B0B246611
          E5F20C1A5FDE41287F8806767233985BBE0366AC263124594FC4921C28214484
          8D8DF7C42826870E0150C6259F4678B97A133FF7265138328FB3F5EBA856AB7D
          C98DC6A7A4BD0100AD1459780667AEAD90068C2A0A48FE1B5F3777932463AC22
          0E2C3DD911C11C04305208F5E6D93D5258D08A2C1C1BBA79176D72A4B22ED4F6
          A6C8A5D28763FA38989E018E761F48B5EBB2E1C6E854B6D1A47860BFBD44FB30
          0EF71EC87F8C08DDE7FC17E02811B133F26C6D0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500536F2032382044657A
          20323030332032323A35363A3237202B30313030163854F20000000774494D45
          07D30A06140B174CADD4FC000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002614944415478DA8D53CF4F1341
          14FE667697EE6E9B526AA954AD600C1102FE0CC4C69307F580176CF0E87FC03F
          A0FF005E8CC62B89C6BBD1C8C183078FFE8826460D20C6062D31216A88695176
          6767677CB35042D31E7CD997DDB733F3BDEF7BEF0D03D9FAD491A099DBEFC0E2
          147168307220368B8E4BEFED38A235A5453879FFF908853FC803DBEC6964FA1D
          77A6CA9FCEDE01EBEF8348FB105E1A329D86F0CDDBC79F948BA9A90AF893851E
          3A52257F445E4F00A4D2E82D9770FEFA35C04B41711B9233CA6821B62C8A1D08
          6277A090C16A9CF03A4CEE990F03C034A3CD5B11548F03E5FA085329E48A7DC8
          EE1B40CC7D284AA0893E6712D268313AB78D250C8C46A919965E7F22CD0EEC1C
          C9181B82573A81D2F069B4ECFBEA2224B1DA6B0980E61678368753D58B50945D
          F7B828E67D349A3F515F7E05A240396D68251033DE0920EC14BA19F3F2288F4E
          ECC66BB5F724A90B0345A89B6BEB783BFF1041B1884D62333C791CE3230CF537
          8F11B20CBCC210A230C45FD8AC0320265DB9F1515CB875038C995E1B5DF4C40A
          3234DD7761531724AD997A7532E01CBFDE2DE2C5CD7944853CC26C2F824C16CD
          7406D5994BF07A7318281F456DE50342DD0D807EE6CF4E607AA1924C9C0A0444
          482E64E29108B0BAF2115A9A22263560ED12A8308DC5253C9BBB8766F9100E56
          CEE0DCE5AB183C36D896ADF6793919F3CE1A10803F7612D30F6E9B8A52C68806
          6B035FBF34B66B610E25EDA3C04A18E8BD007A2394C1CBB9BB4E14499A091A2A
          2A5B48A71481298AC3185C319600FD664CEC01D8AD8899ED2BE4833BFADA79B6
          9B39FCAD75995A1B5DF262EB82FC876D61E73AFF0386B4DFF6514EE592000000
          0049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500536F2032382044657A
          20323030332032323A35363A3237202B30313030163854F20000000774494D45
          07D30A06140B174CADD4FC000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002574944415478DA8D53CF4F1341
          14FE666769BBDD6651DAAE145B31260D90A81C0C0931F166A2110F4A8827FF04
          49E34562E2D593E1ACDCF41FA8116F24FE05F5E6010B02698DB11CA162F7C7EC
          8C6FB63F52A00767F6CBECCCBCF9E67BF3DE63A056D97AE28F09C734C068A6A1
          C06142050C4A025228C8902024D2DCC0EBA7EFAE91D121C13335412671D1BC71
          F39E51F9FC0C7996871DD84807166CA1C7743C264F92B8FFE0216A3FBF102596
          09554223265052E26AA68457775EC2A26E480386308010E0118FE73CE0708B39
          C8863E8F69424AFF98B1665A13A140422690922924FD24DC0B2EB24E16466440
          D205E415B191691013F41B8B15E8CD4844A87EAB223B96459EE7311FCEA36015
          502E9407D6FBBF0F60288EDE43A1AF00D26370B883D55BAB48CA24122A810977
          02EDE336B69BDB2450829C82A0D1648961055D0243929FCCC0D966310B73A5B9
          C17CF7D71EA965E709F4E251E7081B5F37E07A2E9C3F0E16CA0B98BD3E8B5AB3
          06E633E4AC1C42E193DC1104A64861CA2E60FDEE3A18D3B157D03D52117C7D88
          C4719383450C91AFCE13A800689DB4F07CAB825C9883E33BC87819D86D1B2BCB
          2B18B7C6519A2CE1FB7EBD1B8DB304A11FA26815B1F9683336F0A4073FF01104
          41176180FA411D4209A8700481F6EAD06B61EDD30B94DA252C5E5EC4D2ED25CC
          4CCF9C32DED9DBA1708F70413B39694EE1FDE30FF44632BEF1AFDFC16EE347FC
          16FA63FA1AFA7AD152C3044A045EF4F6E39B38DEF15648C94219A8539849B39B
          68A104E71CC79DF6B0844150AFF40A64BAE7D1E9580D1DE8A1D92FA6BEA12E8C
          4BFD02F98FE6A157CEFF00636BEB375FA18C740000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE900000006624B474400FF00FF00FFA0BDA793
          000000097048597300000AF000000AF00142AC34980000000774494D4507DB04
          05120732EE47A0E7000001E14944415438CB8D93316F1A411085BFB93B70220B
          4B08A45814C13291ECC612050514D0BBCD1FE0F7B9487E03151535601924E20E
          89CA4677B7B737BB29C25D706CA48CB4DAD9D1EC9BB74F6F05E0E1E1210BC330
          04101182202897AA92E739AA8AF71E638C1B8FC7DF802D904600611886DD6E37
          98CD66A82AC6188C3164594696651863D8EFF70C8743922401F80EFC009E2300
          EF3DD56A959B9B1B44A49C6AAD45555155ACB55C5E5EB2DD6E01DAC067800810
          A0A4584C3C3F3FA7D96C222278EF0170CE95F921242ADEADAACCE773E2382649
          12BADD2E8D468376BB5D766F361BA2E8CF95A21615491004DCDDDDE19CC33947
          A3D1204912D6EB35DE7B44046BEDBF0CFE027C14954A854EA7539ED7EB35CEB9
          F70022E2ADB52C974BE238E6F5F595ABAB2B6E6F6F592C16A82A171717A71978
          EF393B3BA3D7EB11044149B9100E208AA23782BE0130C6489EE7CC6633D23425
          4D53E238E6E5E585FBFB7B6AB51AAD568BC7C7C7D31A8461C8603028A7E4795E
          7AC15ACB6AB522CFF38F35F0DEA3AA4CA75376BB1DF57A9DD168C4F5F5F59BE6
          E572F94EE8D2072242BFDF2F3D9124094F4F4F14038EF500FC3180DFEFF73A99
          4CCA4611F147CCE4A84E9AA6C722F8C2515F0F1FA47DECB213E18167E027F0AB
          68FE047C39ECFF1369F19D7F034F2921F4B758E3110000000049454E44AE4260
          82}
      end>
    Left = 688
    Top = 184
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object POsPopUpMenu: TPopupMenu
    Images = POsPopUpImages
    Left = 680
    Top = 368
    object EditPOPopUp: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Default = True
      ImageIndex = 0
      OnClick = EditPOPopUpClick
    end
    object NewPOByTemplate: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1091#1102' '#1087#1086' '#1086#1073#1088#1072#1079#1094#1091
      ImageIndex = 2
      OnClick = NewPOByTemplateClick
    end
    object ReviewPOPopUp: TMenuItem
      Caption = #1056#1072#1089#1089#1084#1086#1090#1088#1077#1090#1100
      ImageIndex = 3
      OnClick = ReviewPOPopUpClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object ShowPOPopUp: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086
      object SubmittedPOPopUp: TMenuItem
        Caption = #1042#1099#1089#1090#1072#1074#1083#1077#1085#1085#1099#1077
        ImageIndex = 4
        RadioItem = True
        OnClick = SubmittedPOPopUpClick
      end
      object RejectedPOPopUp: TMenuItem
        Caption = #1054#1090#1082#1083#1086#1085#1105#1085#1085#1099#1077
        ImageIndex = 5
        OnClick = RejectedPOPopUpClick
      end
      object ApprovedPOPopUp: TMenuItem
        Caption = #1054#1076#1086#1073#1088#1077#1085#1085#1099#1077
        ImageIndex = 6
        OnClick = ApprovedPOPopUpClick
      end
      object PaidPOPopUp: TMenuItem
        Caption = #1054#1087#1083#1072#1095#1077#1085#1085#1099#1077
        ImageIndex = 7
        OnClick = PaidPOPopUpClick
      end
    end
    object ShowHidePOPopUp: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100'/'#1089#1082#1088#1099#1090#1100
      object SubmittedPOPopUpSH: TMenuItem
        Caption = #1042#1099#1089#1090#1072#1074#1083#1077#1085#1085#1099#1077
        ImageIndex = 4
        OnClick = SubmittedPOPopUpSHClick
      end
      object RejectedPOPopUpSH: TMenuItem
        Caption = #1054#1090#1082#1083#1086#1085#1105#1085#1085#1099#1077
        ImageIndex = 5
        OnClick = RejectedPOPopUpSHClick
      end
      object ApprovedPOPopUpSH: TMenuItem
        Caption = #1054#1076#1086#1073#1088#1077#1085#1085#1099#1077
        ImageIndex = 6
        OnClick = ApprovedPOPopUpSHClick
      end
      object PaidPOPopUpSH: TMenuItem
        Caption = #1054#1087#1083#1072#1095#1077#1085#1085#1099#1077
        ImageIndex = 7
        OnClick = PaidPOPopUpSHClick
      end
    end
    object AllPOPopUp: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      OnClick = AllPOPopUpClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object UnapprovePOPopUp: TMenuItem
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1086#1076#1086#1073#1088#1077#1085#1080#1077
      ImageIndex = 8
      Visible = False
      OnClick = UnapprovePOPopUpClick
    end
    object DelPOPopUp: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 9
      Visible = False
      OnClick = DelPOPopUpClick
    end
  end
  object POsPopUpImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D65004D692031372044657A
          20323030332032313A32323A3435202B30313030761781FC0000000774494D45
          07D30A06140A2E0AB36DB5000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002ED4944415478DA95935D485361
          1880DF6D9FDB745AA99B3F35C3C8446F72A9430922A5ACA8488A2422258AA0BB
          A08BC22890B210EAA222B0CC0B6FB26219961056429013CCD44D73965AF36F4E
          B7733AFB3DDBD9FFD777E631565DF5C2C3F9CEC7FBFFBE1FC07F08BD19D27A6E
          34B65C6DBE6924BFD90499E4F4E54E4D6171B9CC295586D9A5C9A8A02B4A202E
          1DAD8F549683273E7867BF1EFFD1F3767884A29DE49A4239AA14E3D68A6AA8A8
          D446030D6718A79BB5D1144379598F2D168E510CC77423DDEDB1BC0AAD4EDCDA
          A829181E8036136725C6197C00A456AB605B5111C4221189428EB2E4F2A4AC64
          9904C4220CD6253B5CB8D40457EA6B8E3A3EF656D5590C707D82FBF2693529DE
          891FC5A25160D90078BC01215F0CAA0DC9809018E4290AC85F2FDFC594EEDD71
          52FF185E7D76F8EE6330600033519C893B0872A1A814892448222251F9A24590
          97AB801CA502645231ECCF43DAB3C31D303FBE886FB97037299C268643841542
          44CCB2AC33598600116B098177343DE786C1691F849ACE835A5B06D7C4C57091
          92BD1F01F01123BE82293E3A9F2FFAC9382C690AA99271F8890388679191A980
          32D90A785EB6C3919C2EE81A8999DEF97C7CC4518281E08CD74A446CB550E654
          398A1B4B842C5CE124F876EA3028B76443FB8013FAE5E96318E3D9C4D4D7C62B
          0E84FD135EB79B142F028C4907108275863EC8A5BF83AECF06B5A659C82EA9CA
          22BA0B041B2194B85C88E35C83F38BCBB0AFBA141468F5D2AB2C8467A18D5037
          D10FE905F970A866CFCE71FD8BDE20C74AFF59CF8CF4C2754D779F330F74262C
          D3B460509CC3905482176C76BC26162B8DB757D67612F5527E7DFFC8C0E19CF1
          8D1AA7DEDC3976A0A1ADB916AACAD5E07753A0D78F82CB1BC39353E625A3D160
          E6FC0E8EE86F22F0BD08FE764088B919FBD38E27AFEB39BF77F9E1BD21336D9B
          B3B9688BD7E3B44723E1005FB34BD83C07219A98C1DA6349216808BB8533C33F
          14585D1AFEEC11E6CEEF019BE84494F04D2564F293113A1D1008268C0DFFDDC3
          5F636C48525CAA98660000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500467220323120466562
          20323030332031313A31373A3332202B30313030BF29E7090000000774494D45
          07D30A06140C0319369646000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC61050000028A4944415478DA8D53DD4B5371
          187ECEF1B4A39E39B522235B23588ED4F9B552B3E5BC8B8AEEECA2A0B0A08145
          37FE035D749157165D448D3E2C23973A0A62928D128B10616DC6CAD22183924A
          F163AEE63ECECE4EBFDFD98E2884F5C073CE7BCE799F87F77D7FEF614070EDE5
          8297D76A2DE9540AFFE2F7719FFF66D7E9E344364F98C08DE188F7D34F49FE5F
          F8A616E573176E8D13B19990E7389EB79497B0189A067239FA86302713732C90
          C364EE2A2A0C027656D65693B0857081A365011A78FA1C8A9023B4EEAF427D43
          234253134891EF9148041F3E4E280617CFB74196241A1A0885AC01D07AC60E61
          13A0D70143CF07D0D57905B14402F9BC069515E5B8D46E472A0D30B288AC8664
          835D3570F73AD05C5F0D5FE80B8C4DCD387AA2159371201826D31A71E3C1FDBB
          301A8DB05AADAA01432FAC6A70AACD4ECA6EC0F4D71994EDD90D4906622B4924
          7FC520D71DC3DCEC2C6C361B5896550DB0CEC0D5E34028F8192B2B31049600EF
          5C023FC2227E531311089339040201300C837466060AB8B5156CD792A9E4F298
          22064C3C89785C424464519A27A3B8A81066B359C95D5781248A4AD0F7D081B1
          D17730E84B21FA5F633E5580684E21B6E90AB0E8B9038ECFC3B7DEAB4AAEAA51
          2A501F6805820638643D0857FF132CB82E231A8B4314F25150548C230D12F46F
          9F01AF36A3E54023AEAFB6903578DCED50964843F6A0AA622F4C26136A6A6A94
          BEB5132FB0CBE304CEDA80FE6ED40A3354222B06C958D4E70F2ED575B4B72946
          744874D294144ADF946F4A8047B7819387E174EB65B5057A963B3A3A0707B5BA
          2DD51BFD444DFB0CB02C0FA32F2CA4079C3D4FDF8F8D4E12ED3D6AC013966577
          DB90DD30067F879C6594D04738A2265293AD74B73710AF053DC765C2F01FF210
          54EF95262D0F0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D65004D6F20313520417567
          20323030352031313A33313A3134202B30313030D9FE197A0000000774494D45
          07D30A06140A2F7DB45D23000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002304944415478DA7D523D685441
          10FEDE650FEC0EA37036E6F4E088A8C81949828818CF481A4591148A85651A11
          228865081211D2D8192D346A114125904A450D06D122069168A1702249614E04
          458FE46EDFFE38B36FDFBB4B14073E66D99DF966E69B0DB0C646CE4F5AF661A8
          A1086C526A847585A5EFE58189C7C3F7E9EA17C13D0A9F17C4046DF9561C3A51
          58CB8BD10B4F51C8EFB85EEA3CB3E1F9ECED71BAFAC624E2CAD8235F5141123E
          C91F787FE715EA32C4D183DBD09ECF42AB88E4C8C92E7697AD35C1F49BBBB798
          C4757071A0EFAF8A8397EEE1C5EC823B177259E7276ECC385F6C3F3C4204F374
          7C99325A2749D65A1842A85D5338DDDFEB489E3D29A3EF5807BAF6EFC4A9B37B
          69F81A3F7712D68BE6AA4110300B02AFC8B5F129E7DF5597D153CA4311712803
          1AC9F075869016524A1734F7F60BA4B204529DDE7B0F74A34ECDEDD9DE8AAB63
          9328CFFF44657105C59E4DD0D626C2271D7414735C9C46800B883D6D104A452A
          5A22D666B556222203665E7F7609DC1DAF3FF4BEB46F0B38C418387DD8DB3889
          2CC5EB636B4935668F7F854BF4274E8A3AB4483577608C6904DBD5A014E73933
          BB35838D6D19547FF3588DCD895A3D12917E2A787BCACFC9E368DF36579E9E9A
          C3C70F5FDD26D2C249E72A8BE515B753ECDA9DF37F21EA2616B44A2BD1A4DEE0
          D071DE698550F3C98B7C16E934706EE8A61F2272160DA13859B4B88A4B848784
          051FCC4415968B4BF71336B3A8F8B7C5151F7882E4F332C13A42D6FBFF59AD69
          84C4FE00BEFD2B60E610B8870000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D65004D69203134204D6169
          20323030332032313A31373A3430202B3031303099981FB00000000774494D45
          07D30A06140B3599CD9518000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000002774944415478DA85933D4C5351
          14C7FF6DDFEB173CDAA6D5D49402228A96A8D1F8094109616470202CBA38BAA8
          8B899B71725017465C8C312EBA900884180721881F08A1A50895B4142AFD8216
          5EDBF4D9F6BDEB7958132C0227F9DDE1FECFFDE7DE73CED58022F0022D1A6B43
          BFCCBB3CA199CF9FDE4F961E3E79831992248261BF488D1D9A606C9025827759
          E05D371B7984E8F966749124109ABDCE6AB796AAC66631358F7C3A01299784D5
          E971769E462F498709FDBE0662DC37532C9400CE02A6E361B2D5A1A501A7483A
          4E54ED6B100C8A7D4A64B0A4E1AD30DBDDD01A35A873594E1AF46820B97AAF67
          E8D4E5F91022EE03E1B8C7B9D9C639CE1A999C031485CFC4E32B4F6FE3C4BD1E
          9C8B64B118584281D2951D0614A5E1310417C38985F6FA398F507FD961ACAE46
          77A7FE8CB5F668BB025D57A390BE9A4C623A98408AF2E54A03B555BF169610F1
          CD4BFEEB9DB16BCE8B37F59C500BA6304286D924BB5C42A64B141108C6B14AF9
          C5ED067F4D24DF5BEE8EF5C28336ADD60C1DCF416132144E412E16857D43B419
          057665780AA36AF75513AEA2264C30B86F485909260B83465783829481D23F8E
          CC30301D6B81D83197A7175CA2DC6522576980F548D8AFF0FE5693C58EE8F820
          D61E2F60D45B034F930E115ECB86A6E489F2CDB73AB3C320B4AC0C388CDED61F
          B3B3D8ECCBE1679EA1C95D85C99C2C7F2CCCBEF62E6183D2FCEAF854D6602B8E
          B8B0EE30A76E29AFB2DA119F1D069B0961DB6AECD9F7D0C05488AD51CA18F195
          48AB4FFEDF80185EDE475F3EC5F57CF956130F15D3BE0F7E962DCA58214DBDBE
          9748AAADC72E13A6EE1D243A8863E5768588B972E1B2DBE760B711556B63C59F
          DF28970F65CB66FF7CEFDFA9EE00E3C33F24670000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500536F2032382044657A
          20323030332032323A35363A3237202B30313030163854F20000000774494D45
          07D30A06140B174CADD4FC000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002574944415478DA8D534D4F1341
          187E6677BBEDB6A59612B045B02A722B078926A6D1E8C190183918C4AB3FC293
          FE08EEEA5F10BFAEEAC9837AC1C4AF18432A5283440DC6D0D0DDD9F9F29D6D4B
          A8EDC149DED9CCEC3BCFFBBCCF3CC340E3F3F37A9CCDA5DD907BD060760B91C8
          D0EC81C70C9A058863404A83B0CDB17863F504FDFC61D3BC24DB1F7573C72F38
          EB8FEF42B002423A1C0A09AE02B445804801AD308D730BE791DA7EAAE9C412C5
          438ACD04406B033F5FC1ECC565AA9F86D41E8464E0C285542E844E11130795A9
          3CD6BF2725AB1496222C00D3864109414094A8B308791AB9E228C60B65689585
          A102C63860AE84D2383858C2208AA892D0587BB106D7F330522C0127EBC80613
          A8544EED676F6D7F84E7A59383BDBD04C0D8B53B86F94B57A902B56032189FC8
          A2B5FB0BCDE66BDB64926A1063AFDD4FA103A019860DC64A989E3EBDBFFEB6F5
          16CA6010800B9FFA9768BCBA8F161FC34E54C2D4EC1C6A35460C1E81F33C82E0
          1809CBA1546A10C0AACC3C1FB5CBB7E13087C03A4D1AA3E9EE051C2743BD3B74
          23CEBF227601C82446C6F8F0E4162233422C0EE14F54C04E2B8F2B4B0B246611
          E5F20C1A5FDE41287F8806767233985BBE0366AC263124594FC4921C28214484
          8D8DF7C42826870E0150C6259F4678B97A133FF7265138328FB3F5EBA856AB7D
          C98DC6A7A4BD0100AD1459780667AEAD90068C2A0A48FE1B5F3777932463AC22
          0E2C3DD911C11C04305208F5E6D93D5258D08A2C1C1BBA79176D72A4B22ED4F6
          A6C8A5D28763FA38989E018E761F48B5EBB2E1C6E854B6D1A47860BFBD44FB30
          0EF71EC87F8C08DDE7FC17E02811B133F26C6D0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500536F2032382044657A
          20323030332032323A35363A3237202B30313030163854F20000000774494D45
          07D30A06140B174CADD4FC000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002614944415478DA8D53CF4F1341
          14FE667697EE6E9B526AA954AD600C1102FE0CC4C69307F580176CF0E87FC03F
          A0FF005E8CC62B89C6BBD1C8C183078FFE8826460D20C6062D31216A88695176
          6767677CB35042D31E7CD997DDB733F3BDEF7BEF0D03D9FAD491A099DBEFC0E2
          147168307220368B8E4BEFED38A235A5453879FFF908853FC803DBEC6964FA1D
          77A6CA9FCEDE01EBEF8348FB105E1A329D86F0CDDBC79F948BA9A90AF893851E
          3A52257F445E4F00A4D2E82D9770FEFA35C04B41711B9233CA6821B62C8A1D08
          6277A090C16A9CF03A4CEE990F03C034A3CD5B11548F03E5FA085329E48A7DC8
          EE1B40CC7D284AA0893E6712D268313AB78D250C8C46A919965E7F22CD0EEC1C
          C9181B82573A81D2F069B4ECFBEA2224B1DA6B0980E61678368753D58B50945D
          F7B828E67D349A3F515F7E05A240396D68251033DE0920EC14BA19F3F2288F4E
          ECC66BB5F724A90B0345A89B6BEB783BFF1041B1884D62333C791CE3230CF537
          8F11B20CBCC210A230C45FD8AC0320265DB9F1515CB875038C995E1B5DF4C40A
          3234DD7761531724AD997A7532E01CBFDE2DE2C5CD7944853CC26C2F824C16CD
          7406D5994BF07A7318281F456DE50342DD0D807EE6CF4E607AA1924C9C0A0444
          482E64E29108B0BAF2115A9A22263560ED12A8308DC5253C9BBB8766F9100E56
          CEE0DCE5AB183C36D896ADF6793919F3CE1A10803F7612D30F6E9B8A52C68806
          6B035FBF34B66B610E25EDA3C04A18E8BD007A2394C1CBB9BB4E14499A091A2A
          2A5B48A71481298AC3185C319600FD664CEC01D8AD8899ED2BE4833BFADA79B6
          9B39FCAD75995A1B5DF262EB82FC876D61E73AFF0386B4DFF6514EE592000000
          0049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500536F2032382044657A
          20323030332032323A35363A3237202B30313030163854F20000000774494D45
          07D30A06140B174CADD4FC000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002574944415478DA8D53CF4F1341
          14FE666769BBDD6651DAAE145B31260D90A81C0C0931F166A2110F4A8827FF04
          49E34562E2D593E1ACDCF41FA8116F24FE05F5E6010B02698DB11CA162F7C7EC
          8C6FB63F52A00767F6CBECCCBCF9E67BF3DE63A056D97AE28F09C734C068A6A1
          C06142050C4A025228C8902024D2DCC0EBA7EFAE91D121C13335412671D1BC71
          F39E51F9FC0C7996871DD84807166CA1C7743C264F92B8FFE0216A3FBF102596
          09554223265052E26AA68457775EC2A26E480386308010E0118FE73CE0708B39
          C8863E8F69424AFF98B1665A13A140422690922924FD24DC0B2EB24E16466440
          D205E415B191691013F41B8B15E8CD4844A87EAB223B96459EE7311FCEA36015
          502E9407D6FBBF0F60288EDE43A1AF00D26370B883D55BAB48CA24122A810977
          02EDE336B69BDB2450829C82A0D1648961055D0243929FCCC0D966310B73A5B9
          C17CF7D71EA965E709F4E251E7081B5F37E07A2E9C3F0E16CA0B98BD3E8B5AB3
          06E633E4AC1C42E193DC1104A64861CA2E60FDEE3A18D3B157D03D52117C7D88
          C4719383450C91AFCE13A800689DB4F07CAB825C9883E33BC87819D86D1B2BCB
          2B18B7C6519A2CE1FB7EBD1B8DB304A11FA26815B1F9683336F0A4073FF01104
          41176180FA411D4209A8700481F6EAD06B61EDD30B94DA252C5E5EC4D2ED25CC
          4CCF9C32DED9DBA1708F70413B39694EE1FDE30FF44632BEF1AFDFC16EE347FC
          16FA63FA1AFA7AD152C3044A045EF4F6E39B38DEF15648C94219A8539849B39B
          68A104E71CC79DF6B0844150AFF40A64BAE7D1E9580D1DE8A1D92FA6BEA12E8C
          4BFD02F98FE6A157CEFF00636BEB375FA18C740000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE900000006624B474400FF00FF00FFA0BDA793
          000000097048597300000AF000000AF00142AC34980000000774494D4507DB04
          05120732EE47A0E7000001E14944415438CB8D93316F1A411085BFB93B70220B
          4B08A45814C13291ECC612050514D0BBCD1FE0F7B9487E03151535601924E20E
          89CA4677B7B737BB29C25D706CA48CB4DAD9D1EC9BB74F6F05E0E1E1210BC330
          04101182202897AA92E739AA8AF71E638C1B8FC7DF802D904600611886DD6E37
          98CD66A82AC6188C3164594696651863D8EFF70C8743922401F80EFC009E2300
          EF3DD56A959B9B1B44A49C6AAD45555155ACB55C5E5EB2DD6E01DAC067800810
          A0A4584C3C3F3FA7D96C222278EF0170CE95F921242ADEADAACCE773E2382649
          12BADD2E8D468376BB5D766F361BA2E8CF95A21615491004DCDDDDE19CC33947
          A3D1204912D6EB35DE7B44046BEDBF0CFE027C14954A854EA7539ED7EB35CEB9
          F70022E2ADB52C974BE238E6F5F595ABAB2B6E6F6F592C16A82A171717A71978
          EF393B3BA3D7EB11044149B9100E208AA23782BE0130C6489EE7CC6633D23425
          4D53E238E6E5E585FBFB7B6AB51AAD568BC7C7C7D31A8461C8603028A7E4795E
          7AC15ACB6AB522CFF38F35F0DEA3AA4CA75376BB1DF57A9DD168C4F5F5F59BE6
          E572F94EE8D2072242BFDF2F3D9124094F4F4F14038EF500FC3180DFEFF73A99
          4CCA4611F147CCE4A84E9AA6C722F8C2515F0F1FA47DECB213E18167E027F0AB
          68FE047C39ECFF1369F19D7F034F2921F4B758E3110000000049454E44AE4260
          82}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446F203134204E6F76
          20323030322032333A33313A3434202B3031303084501C480000000774494D45
          07D30A06140C04875203E5000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000002C74944415478DA95935F485371
          14C7CFBDFBCDB94DDD9C86989ABA6C92E49FFEA8A019D91F820802ADA4875E0C
          C2C8879E8A2890A0979E021F4A0A22A2877C2824D0666625FE499C3A755B6A99
          AE8D4D6BCEFDBBFB73D7BD779D1B570A8BFEFCE003BFFBFB9D737EF77CCF3914
          FC7D511BBE137FBAFCB10E74674162F54A6A76D6710591EB565D2BB384668D5C
          5F733BDE06114E3493FDD6F9D468CDA602C59B5B978F1DACAF2BD21696142AA8
          E2D2DC2095BB3F16CFDF0CAE9E49B40A23C2AF01CED84AF5F9747F476B65C6B3
          F700335F009C21008605A0D3D520A8B3CBB8301B4F7C36CD894108B45ADB5294
          6417F3A0F13CE4D5465235A1CE3B2DD59A4E0B00A1016CA629D669EA33513275
          92B6FCD0EE8C9D0659A03FA30A9D07113FA9D3936B4D7B8B49EB789303D479B1
          F6B395DB0796005449005D9DBD2EBFF1EA2B704F84513957D0DB6296A75D3FA7
          34D49545CDB0150398C94A20E4D8A2037DC591C6669613048D8A06CE07306A59
          E2FC2F6FBC16DC132BD26BF3FC7407F115375429D3332BA2009978964C169703
          564A00FD899A121595E06106CD137C02268D8F0704C79028D408328678C5AA09
          91E01CADD595E19E168B40532C635D0E72A094E32D25839C3400E3F807142025
          856E78580447EF19D0F0AB547F8E8F733361B7DD8DFB9878460851AEF5D8BC70
          7A4F16387CE2EB00170E1BC0B3CF504D14008F5ED8EB6D230536F0DBDFA2830F
          64F288C07A174401119E8E3D3979DF1EE043C9585039C260808880EA7FF2C3DD
          2E4B746EA8AB179D77A0B1F67BE391248A623D66292596803F187247D9773A15
          543BD7A2F07C968161CBA2839932DAB8819B1EE0A21E34744A8D93804870909B
          BCAD96528A88AD4C918BC36DDB727497E62746A661FAE98230DB8D6D03CBC822
          62950278252D14D2DFF0621AEBB3908ED422E50856083E22A824AC220124FED3
          1051D2080822EB0108A24152A5216124F88DD3F72FA34BFD8FC337A11223F609
          3A8C810000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446920333020536570
          20323030332032333A35343A3236202B3031303065D5FFC10000000774494D45
          07D30A06140A3580D6A459000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000002EA4944415478DA4D535F485371
          14FE7EDB6E6ED3796D6AABA6199292E29FA8C408B55ECC282A10C10C1F4AA2DE
          7A2AE8B51E7AE845A8DE7A8C22040B538B90FE589945561A6865A2D6A666BAE9
          DD1FB77BEFEEFD75EEDD940D3ED8CEF97DDFCEF9CE3940DAE703D03000DCBF0B
          D4D14F0781ADE75E03E7FB185EDC065A72009142D6742E7E01B7FCCD0775F57A
          2B1F606C9842FB089946EE237074A2344FE1674AB9AF4AE4DD563646E1624286
          6543A120F7A4F7D81E66DB045434961FE8005A29BAED1950CBBC6257D9A10201
          31194AA6804F1AFF43B90642CE86C0B43FD0A3CEFE0564195B6B77A2DDED3CD7
          021C77E5673FA93955E68214415856F1FE7370BE1358228A6E60A38F7A20E4D6
          B50E77713E432C8E8222D1E9F5859AEADAAAB3B0BA0A5D9531F235A85F5D517A
          168059A20C12E6362AB8087C9D1E9E1A464205D404048780FAD3150C9204682A
          267D613CF0459F8ED31F256D3145947427F51ACE650F4373CE163B109781B538
          8929580A46D1F37671E20630C5CD61C1303960706CEBEC21C04B8D9DB58B343D
          95AA5014936C7E8FA9903822F46F731A308AA4071A52B364EFA8036BA1FBD1E1
          F6FD65D9C6E0D662305B5192029976864A8FE02DF4C7C400C7901F98A757AA29
          F01C682EAA2DBA57D9586CB784A464E98904344586857AD7131A6969C8A05ACB
          B70B9EBC65F5884BE50B54C68CE18185D4A286C3580E12396E8E311489A27760
          2E31FD3B4CABA881EB2442A236C6D1B4D7EED9055C207235C169C9B5B29B3B8A
          B2A8CF98495E94A2E87FB518BC14561F768E4ABD337E8AEB3A3855A2681A46A6
          15F4013F529BE8B42D697C500B47AA6407C3243D7E39267DBFA6F39115C07707
          18CFFB168EB4EE76B48136746A4E417740EBA511AC1179912033DAB6921382A5
          4BB7B1BCC7316DB81F0893BD3F9383C11441BC0C5CA1E511E9D0A47F94A7D817
          C21BC2BC716D198492E432820ECD34C738161F214A108C4B215412ECA9F86C6A
          942A4B9DAC91D89C7A1C4172DBD4B42533F6C5957A4BA680DC063712FF01ED26
          4369DCC167DB0000000049454E44AE426082}
      end>
    Left = 680
    Top = 416
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object FindImagesList: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F
          53000000017352474200AECE1CE900000141504C5445BDBDBDBD0A0AA6A6A6D7
          6666D63232E69191DEDEDEF20F0FCCCCCCDC8686FFFFFFE4A3A3CD4E4EC5C5C5
          C41B1BB5B5B5E51F1FE9BDBDD87777E42F2FADADADE6E6E6CD0B0BD6D6D6E095
          95E8AFAFF7F7F7F14B4BFD0F0FF66060F48080EE7474E69C9CDE1A1ACF1010E6
          3737CC3F3FF72121F61313ED6363EF8282EFCACAEBB5B5DE5656C51212EF9292
          D40B0BF07B7BC83B3BEC5454EDBCBCE87373F4A6A6F62A2AE94242E02424E319
          19F6E3E3C8B9B9C42222ED8D8DF48A8AF4AFAFDC3737E92727F91818DC4343C5
          0A0AF56B6BE28E8EF9F0F0F49D9DF32F2FF49494EE5D5DD81111F2C6C6D66B6B
          F47575F7B7B7D25252F33A3AE45B5BEF6C6CE57D7DDD0B0BFFF7F7F19C9CF134
          34E02626EBA4A4CF1919F14343DE7373D53E3EF7BABAD12424EF2929EB1818E6
          8C8CF65454F22424E06C6CDB3030F54646DB6565F45D5D85C37C3B0000000174
          524E530040E6D86600000001624B47440088051D48000000097048597300000B
          1200000B1201D2DD7EFC0000000774494D4507DB07071030369700A2FF000000
          9A4944415418D36360C00E04790C84A490B87AFA26262666D6303EB7B93B18E8
          3A4305F46C4CE4EDEC6CE5C38D55C0FC0063777F2E4F7D2EAE60776FB08098AD
          AD2E170804DB06198104A2FDFCFC4022CA312E7EAC6015B2B2D22005C91E1E29
          5A2081B8540F2097958B2B33D5026C869BB7AA005792AAAB96AA6A02C4DA3431
          35081083B92C84D13934548F510CE178A958253116412906A20000EBF418B819
          F364F80000000049454E44AE426082}
      end>
    Left = 720
    Top = 256
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object RTimer: TTimer
    Enabled = False
    OnTimer = RTimerTimer
    Left = 696
    Top = 504
  end
  object UTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = UTimerTimer
    Left = 656
    Top = 504
  end
  object FLPopupMenu: TPopupMenu
    Images = FLPopupImages
    Left = 864
    Top = 200
    object FLPopShowPOs: TMenuItem
      Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1079#1072#1103#1074#1082#1080
      ImageIndex = 0
      OnClick = FLPopShowPOsClick
    end
  end
  object FLPopupImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002D744558744372656174696F6E2054696D65006A65752E20352064E9
          632E20323030322031323A32313A3130202B30313030603BD286000000077449
          4D4507D30A06140B14D5A48546000000097048597300000AF000000AF00142AC
          34980000000467414D410000B18F0BFC6105000002454944415478DACD92DF6B
          D35014C74F97AC6963B366B5A8AC34CB181A3A545837565187C84444FA26D252
          26F6A5AFB27FC127C19782824F3EF80FA80FA23E8C75282B58D7561F6C93C542
          85511BDB75EBD2246DD75F9E42855AC4573DF021F77273BEF77BCF3900FF3A88
          A1B5A94F381CB6F33CBFEAF178EEB12C4B699AF6BDD168B4F1ACFB2701532010
          58B6582C0F6C369B3A333323743A1D9E24C9319AA601D7904824A46432795F14
          C537F8BF8E747E73C071DCFA3C4628143AED743A27198631E18D502A95A0582C
          020A3B1D0EC72DB3D97CB6DD6EE7755DAF0C8B1098B4E6F7FB1DD56A150A8502
          A8AA0AB22C433A9D866EB70B2E970BA2D1A8291289089A66AC72D3D3EE866188
          95FD7DADFF2C02ADCAAD56EB26265A298A826030088BDE0528281AB49A7528EF
          FD00CEED864C3607DEA515F2FC4A703E97F97046CA663EA2804A542A15A55C2E
          E7D0C1B2CFE7B3E9B54390769B70E76E1018E10AC49E3F0596B543C73107BC67
          160C8280BC249F48C663220AECF6BBD0C6DB0BE822DBA8D797C62D0C2B5CBF0D
          06D65D1DA760EBC5B39D54725B3E3577C95DA5792862053EBD7A9C93C46C0173
          B3E4A03D078AA26C6CC5E36B346D7D62BD78348545035DC9C38E94FD5C544A65
          76F2A13A2B8B378CBDAFB5F5B7AFB731E71039328DCCC1842008D7162E5C7DE4
          E4CE4D7D89BF4C6D6E6EA47BBDDE3B3CFB66B74F2C6A9AEEC2F6D670FF1E4999
          46E7A22F4251662F49909775C360709F476248DFB21D398E341105A98D0AFC12
          39869C1C7C0F9052DFEED0F4F6064FEFFD6DCCC7107220F81FC74FFBE4F78F3D
          EEB9160000000049454E44AE426082}
      end>
    Left = 864
    Top = 248
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object TreeImagesVT: TsVirtualImageList
    AlphaImageList = TreeImages
    Left = 482
    Top = 231
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object PersImages: TsAlphaImageList
    DrawingStyle = dsTransparent
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D65004D6F20313520417567
          20323030352031313A33313A3134202B30313030D9FE197A0000000774494D45
          07D3021B100E3406B73D94000000097048597300000AF000000AF00142AC3498
          0000000467414D410000B18F0BFC6105000002524944415478DAA593CF6B1351
          10C7BFFBDEFE48B64DD336B11612A12054448C372F2256940A1E0405413DEA41
          F158A85EBCE8CDFF40F1A88882276905F152510FF522F6241691B616531B69B2
          E926D9F7D349680A357AEA83618761BE9F99376F16D8E571BACE8DEB57EEE7F3
          B943DA8039A29EE3E93060CC0C7166068550FEA7CF95D3B3B32F3FFC9774EFEE
          F45BDB39CADAF917F46D9055C8CA76E5C77B3B3D75213A77F6FCB1BF75BCEB4C
          4E9EB8696D5C28AF97B137AE421746209B1B50AD0A96BE2FA1745806E3FBFD8B
          B5B8F86E71F1CB7257C7B6498C85C54211A3F951284537332EB8DF87D4C008AC
          3F8899D735ACFE149930D87C353171EA6457E7761D63757AAC3084785321D112
          9CAA43C76841E2E0588823539728DBC1B5AB51E6F69D670FE6E6706007C0AA24
          631C03D3AC0129D60EB4A36D349456504D41BE80E7D42924644F077E980AD636
          1AD893EA8793CDC11D1A811611A4A8432B0D43064777A0461BDE03804EF8F3A7
          4F70A6348E7DFD1E587DA5DD31CDC145AA2F4BE26CA703A04A880E69274029C5
          6F4D5D46F5E3022CA38A545980F2124573505B628554202095FA17403070970A
          651150B2F119B52E60B5D86ABD0DA1AB1B056B0D7A00DA1ADD4E624915C80F23
          087D309EDE5A56129B18526E82DB1A3CD7E9EF01C8A4611E3D7C8CE3F494A3C3
          1E922A55EB54D29D177118ED380D25ED0ADA75F83D002164E36869A02FEF7930
          D13AFC4C8E84B23D73EA8160B41B3A69A25CAD11577A3D805F95C6FCCC9BD592
          EBB903AD280EE1318773DE94CA56A2A8B5BEBC122D7CFDF67BD96AB3C6B8D9D8
          ED5FBC7DFE00353025184304863C0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002D744558744372656174696F6E2054696D65006A65752E20352064E9
          632E20323030322031323A32313A3130202B30313030603BD286000000077449
          4D4507D30115140006F095E4A5000000097048597300000AF000000AF00142AC
          34980000000467414D410000B18F0BFC6105000001FF4944415478DA636018F2
          80119B607A7A3ADF9B376F821919196DDEBF7FBFFEF3E7CF3B4F9D3AF51BA701
          515151D66C6C6C1D0202021FE5E5E5357EFDFAA5C8C2C2C2C4C5C5C5F0F7EF5F
          86F3E7CF5FBB79F366DE912347F6A21BC00C22646565F718181818464444A809
          0B0B0BF1F2F232FEF8F183E1D5AB570CCF9F3F67E0E4E41405E2583E3E3E6D1E
          1E9E33AF5FBFFE0033800544009DC9A4AAAACA70E7CE1D101B6CEBEDDBB719AE
          5EBDCA202424C4A0AEAECED0D3D303726D6853538BDFBBF7EF667DFFFAB96ED6
          EC391FC02E9096963EF5EDDBB7C00F1F3E70B1B3B333005DC2606264CCF0F4C5
          1786DF3FBF33BC7EF392414E5696E1EAB53B0C86A64E2CAA56FEE6678EEE52BF
          70EECC4AB0014F8140505070FBFDFBF7034D4D4D79BE7EFEC870E3F14F86D8F8
          08065E757B867D6BE7300808F033FC15D26250D05466F8C6CCCC70FBEA75E953
          87777730C1FCB267CF9ECBC080B4DBB37BF7BD8B576E31489A5831DCFFCCC0F0
          979F9781859DF3F296CD9BB73F7CF19AE1F8630686AB8F18183EBF00FA171688
          3070EFDEBD77C040DCF2F7CFCF6066152FBE575F99195EDEBDCF7061D7A2EEDF
          7FFF17FCFFF044EDF5E3673A4F4EAFF974F9ECD184A7CF9E3FC49A0E92931335
          FF32F1EDE69350937E76FDD0A1278FEF7B9E3879EA1B48CED9C9410D18D0AFCE
          9DBFF881011FB0B3B3E1B4B1B654C595D88611000004DFD98685D7A784000000
          0049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1200000B1201D2DD7EFC00000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080
          830000F9FF000080E9000075300000EA6000003A980000176F925FC546000003
          444944415478DA3C93CB6B9C551C869F73CE37C984CC6466A0491A1DCDC55A6B
          6E4D431521895A0D6EB57625886202DA28255528B870211850706142832EDAA2
          E842B120B4FF807845942E6A5A8D99A6499ADB4CCDA4E9249DDB777EE7B8A8E9
          BB7F1F78168FF2DEB3BB89A9C93DC0E67BE327DDC79F7DFA733C161B88C7E314
          0A85F2D82BAFD64D4C4D1A2B7ECFFBEFBC9DDBFDA85DC0C4D4E43E63CC5F0A76
          ACC8B031E6C7D1375EAF07F8E2EC398CD6CF94CAE53326300FC6EAEA074E8C8C
          FC710F303135D9618C993DFAE2D1C8EC952B64AE2FB8D6745AEF6D6A466B58CB
          E6585E5DA3A3ADB5F2687777EDC50B1770627BDF3D313E130068AD878D31C1FA
          8D155289148FF727B5F7E0BCC38BA2B9B191A6C64680DAECF232263054AAE1D3
          C0CC3D850FA74F5F4BB7B43C747FCB7DA0C003DE7BC45A82208252779D57D7D7
          D9DCDA92F191D100407D30F949048868ADF3FDBDBD51630C00B76EDF662D9BAD
          28A50A46EB64EB03E948B4368AB5963FAF5E25D1D0D0B4B8B256D45AEB7C3C16
          DBEEEEE98E7AC08A502A97B8BEB05809C3303D3E32DA542A979F5D5A5E09AD08
          A0E8EAEAA25A0DFF89D606DB1AD01D6DED5A89C75AC18AE54EB188F77EEED4F1
          B10D8053C7C77EB222C56A18224EF0E2686F6B4B79F14A7BD0EBB92C859D0256
          042B8231014AABF6B3DF7C1D01F8FCFCB79D409DF31E6B2DDB77B6C9DECCE134
          044E24551389D42D2E2E6DEC7F78BF510AB4D1241389FA7C7EB3F0D1F4F40E90
          6C88C702B1160F2C2C2DD1F5C88154600CC1C1CECE8A135FB9E1571736F21BFB
          52A9140A4825932A168F47ADB5D19A4804A30D22C2ADAD2D6A233592AA4F6C25
          EAEAD10ECFA599CB3D626D473C1E47C4FDAFE250402408F0DE63C5629D23168B
          512A97CCF7BFFF3274646810ED4387F7FE80B556AC15AA61856C2E8788C53987
          3887B5422E97230C43448430B4C562B1DC0EA0054F7F4FCF790FA37399399799
          CB849BF9FC777FCFCEBA6A18E2C491B996A1582E5FCA64325BF3F3F34EA14E0E
          0F3DF525800E6D15143C76E8D057626DB315491CEEEB3B668CD14A29AC58009E
          38D877D879972E552AE9230383679E7B72F06E8D2B6BEBFCF0DBAF686378E9F9
          17DA8018B0F7B5B7DE7CB9B9A5E5184AA97F6F662F9E9B9A3E0D6C033BDEFBC5
          DD9CFF1B003284B1B1A2D1FCDF0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558744372656174696F6E2054696D6500446920333020536570
          20323030332032333A35343A3236202B3031303065D5FFC10000000774494D45
          07D30A06140A3580D6A459000000097048597300000B1100000B11017F645F91
          0000000467414D410000B18F0BFC6105000002EA4944415478DA4D535F485371
          14FE7EDB6E6ED3796D6AABA6199292E29FA8C408B55ECC282A10C10C1F4AA2DE
          7A2AE8B51E7AE845A8DE7A8C22040B538B90FE589945561A6865A2D6A666BAE9
          DD1FB77BEFEEFD75EEDD940D3ED8CEF97DDFCEF9CE3940DAE703D03000DCBF0B
          D4D14F0781ADE75E03E7FB185EDC065A72009142D6742E7E01B7FCCD0775F57A
          2B1F606C9842FB089946EE237074A2344FE1674AB9AF4AE4DD563646E1624286
          6543A120F7A4F7D81E66DB045434961FE8005A29BAED1950CBBC6257D9A10201
          31194AA6804F1AFF43B90642CE86C0B43FD0A3CEFE0564195B6B77A2DDED3CD7
          021C77E5673FA93955E68214415856F1FE7370BE1358228A6E60A38F7A20E4D6
          B50E77713E432C8E8222D1E9F5859AEADAAAB3B0BA0A5D9531F235A85F5D517A
          168059A20C12E6362AB8087C9D1E9E1A464205D404048780FAD3150C9204682A
          267D613CF0459F8ED31F256D3145947427F51ACE650F4373CE163B109781B538
          8929580A46D1F37671E20630C5CD61C1303960706CEBEC21C04B8D9DB58B343D
          95AA5014936C7E8FA9903822F46F731A308AA4071A52B364EFA8036BA1FBD1E1
          F6FD65D9C6E0D662305B5192029976864A8FE02DF4C7C400C7901F98A757AA29
          F01C682EAA2DBA57D9586CB784A464E98904344586857AD7131A6969C8A05ACB
          B70B9EBC65F5884BE50B54C68CE18185D4A286C3580E12396E8E311489A27760
          2E31FD3B4CABA881EB2442A236C6D1B4D7EED9055C207235C169C9B5B29B3B8A
          B2A8CF98495E94A2E87FB518BC14561F768E4ABD337E8AEB3A3855A2681A46A6
          15F4013F529BE8B42D697C500B47AA6407C3243D7E39267DBFA6F39115C07707
          18CFFB168EB4EE76B48136746A4E417740EBA511AC1179912033DAB6921382A5
          4BB7B1BCC7316DB81F0893BD3F9383C11441BC0C5CA1E511E9D0A47F94A7D817
          C21BC2BC716D198492E432820ECD34C738161F214A108C4B215412ECA9F86C6A
          942A4B9DAC91D89C7A1C4172DBD4B42533F6C5957A4BA680DC063712FF01ED26
          4369DCC167DB0000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000002A44944415438CB
          A593DD4F926118C6FD5BE04F68ADE66AD56A9DD5D638E8A003A7E627D0D472B5
          0C96B37498D32C2935339D0A6AEA9C8A026F02228826CA9720F062225FCAC744
          78E155B3EDEA8D359CCBD95A07BF937BCFF5DBAE67F79D0320E77FF863A0230F
          D95AF78140E3DC2755EB34F5C59EA214368A9CB1240453A63DF69902B593E6CC
          3AD2214FF8101B3B34DC412A83673B0D47208D91C568686821CC395540ACA538
          726B32B519D987F9DB2EA4737E88C69CA81F594717B10183230A5788C227953F
          D5456C714E0864E6046B72351EDC08D35870C650CB843A090FFC311ABE581A63
          8B01D448AD50AE8660F725D03A49069BC75DACAC6074292A5CF3A7B0E2894338
          68C7E31E33D207470C3F7E7384DA410B6AFA4D98B747A05D8BA04E6A1566057D
          7321D2C574ED263651DD634255F70AFCD134A6960350DBB6413302B52D086EBB
          0EAD530E58BDBB78D26D24B3820E8597760793104A2CA8FC6804AFD3C03CD663
          DAE8C32E75809D5D1ABDB32E94B66951F9410F876F0F3CB19ECE0A5AC65DB42B
          90C4D3010BB81D7A94BFD7A1EC9D0E49FA3BB62214F8622D8A5A54B8CFC0176B
          60F7C791DFA43E16BC90DA48DB561C62990BBC7603CAC4F328793B87E2D7EA0C
          85AF0814362A50D02847BD7419464F0477EBE4C715983E42853100BD2382CA0E
          4336184BEC23B247234F3493A1502403B1EA8384A973AB66E2F813F9E20556F9
          9BF9E0923302E58A1FDC360D0A9A94681B3765F815CE6F98C0B0C60D8D25809B
          D563C1EB0F47592716294F34CBB9D740A474F66DA8AD41BC942CA1A4598EA2C6
          693CEFD54369F44265F6E36AC5E7D4E507439C5357F98E50C6B9FD6C32D447AC
          E3AB3B0C8B379661D1B9832E990DB93C69E862B98473E631DD7834CABE563522
          B852314C5EE20F52B95C2975A16C803C5FDA2F3857DCC7FEEB35FE2B3F01D7AF
          05A2BD4DBDC40000000049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1200000B1201D2DD7EFC00000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080
          830000F9FF000080E9000075300000EA6000003A980000176F925FC546000001
          964944415478DA94923D485C511085BF591FBB88B20692686154D04A489162D3
          28484AB5B4B0492BD804B4B0114B831656D611ECD3A4336582A058A60881ACAC
          3F2B282104115CDDB7EFDE9914EFB9AEBB794B9CEECE9C396766EE1133A33936
          F77B5A920B6357C23F22434ACC172E982AAC325FB8A05D046985AF7FDE725DF9
          4539BFD796207502EF6BA87A9C0F1F4FA09A217237181EE742D4A7EA201B5F9E
          C507131083BBEB0DF58F10F990CE5C9ED2E98FFB06EE314B6F7E4BE05DC0C244
          89325B75D020737C3A1E47D5711B5EF16EECB4A5BEB93B1213BEFFFCC2860707
          A8D92560C914F260A2465501B2995E4AE5235626CF24705116A737A8460DC8BB
          6E4972098D00186A212ECAC6DFE8A28062F116A4A3DE2C620C0DD76275334E8E
          72318191285CD61D10ACCEFC6C71D8F2C797E6B5123F0C7CD4CDDAECF707B8F5
          9D5703A946F22EC0AB4792CD9D6B852D4F7F3B6B4B60E6508BD7F63E789C9555
          333CED1EADBF0F7DF5FF0944E4F9E2F66B0E0EAACDF99EA9B95C2571AFDBF950
          55E2235B23A80F78027401F926EE2280999D3726FF0E00A747AF821B5256E700
          00000049454E44AE426082}
      end>
    Left = 864
    Top = 464
    Bitmap = {
      494C010100000800080001000100FFFFFFFF0400FFFFFFFFFFFFFFFF424D7600
      0000000000007600000028000000040000000100000001000400000000000400
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF0000000000}
  end
  object PersPopupMenu: TPopupMenu
    AutoPopup = False
    Images = DebCredImages
    Left = 952
    Top = 464
    object PersList: TMenuItem
      Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1086#1073#1086#1088#1086#1090#1082#1091
      Default = True
      ImageIndex = 0
      OnClick = PersListClick
    end
    object PersFind: TMenuItem
      Caption = #1053#1072#1081#1090#1080
      ImageIndex = 1
      ShortCut = 16454
    end
    object PersAdd: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 5
      OnClick = PersAddClick
    end
    object PersDel: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 3
    end
    object PersProps: TMenuItem
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072
      ImageIndex = 2
      OnClick = PersPropsClick
    end
    object PersWhatIsIt: TMenuItem
      Caption = #1063#1090#1086' '#1101#1090#1086'?'
      ImageIndex = 4
      Visible = False
    end
  end
end
