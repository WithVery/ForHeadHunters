object SmallWin: TSmallWin
  Left = 0
  Top = 0
  ActiveControl = ValuesGrid
  BorderIcons = [biSystemMenu]
  Caption = 'SmallWin'
  ClientHeight = 373
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 190
    Top = 0
    Height = 373
    OnMoved = SplitterMoved
    ExplicitLeft = 156
    ExplicitTop = -5
    ExplicitHeight = 393
  end
  object Chart: TChart
    Left = 193
    Top = 0
    Width = 392
    Height = 373
    AllowPanning = pmNone
    Legend.Alignment = laBottom
    Legend.CheckBoxes = True
    Legend.DividingLines.Style = psDot
    Legend.LegendStyle = lsSeriesGroups
    Legend.Symbol.Visible = False
    Legend.TextStyle = ltsPlain
    PrintProportional = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    Title.AdjustFrame = False
    AxisBehind = False
    BottomAxis.LabelsAngle = 45
    BottomAxis.LabelsFormat.Font.Shadow.Color = clBlack
    BottomAxis.LabelsFormat.Font.Shadow.Visible = False
    BottomAxis.LabelsOnAxis = False
    BottomAxis.LabelsSeparation = 0
    BottomAxis.MinorTickCount = 0
    BottomAxis.MinorTickLength = 1
    BottomAxis.TickInnerLength = 1
    BottomAxis.TickLength = 2
    BottomAxis.Ticks.Style = psDot
    BottomAxis.Ticks.Width = 2
    BottomAxis.TicksInner.Style = psDot
    BottomAxis.TicksInner.Width = 2
    BottomAxis.Title.Caption = 'sdfgsdfg'
    BottomAxis.Title.Visible = False
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Axis.EndStyle = esSquare
    LeftAxis.Maximum = 902.500000000000000000
    LeftAxis.Minimum = 522.500000000000000000
    LeftAxis.MinimumRound = True
    LeftAxis.MinorTickLength = 1
    LeftAxis.MinorTicks.Visible = False
    LeftAxis.TickInnerLength = 1
    LeftAxis.TickLength = 2
    LeftAxis.TicksInner.Visible = False
    LeftAxis.Title.Visible = False
    TopAxis.Automatic = False
    TopAxis.AutomaticMaximum = False
    TopAxis.AutomaticMinimum = False
    TopAxis.Axis.Width = 1
    TopAxis.Visible = False
    View3D = False
    View3DWalls = False
    Zoom.Allow = False
    Align = alClient
    Color = clWhite
    PopupMenu = PopupMenu1
    OnDragDrop = ChartDragDrop
    OnDragOver = FormDragOver
    TabOrder = 0
    OnClick = ChartClick
    OnDblClick = ChartDblClick
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      5
      10
      5
      5)
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      HoverElement = [heCurrent]
      Legend.Visible = False
      ColorEachPoint = True
      Marks.Font.Height = -5
      Marks.Font.Shadow.Visible = False
      Marks.Frame.Visible = False
      Marks.Shadow.Color = 8684676
      Marks.Style = smsValue
      Marks.Symbol.Shadow.Visible = False
      Shadow.Visible = False
      ShowInLegend = False
      Brush.Style = bsClear
      Brush.BackColor = clDefault
      Dark3D = False
      LineBrush = bsClear
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Transparency = 100
    end
  end
  object ValuesGrid: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 190
    Height = 373
    Align = alLeft
    Color = 16382457
    Colors.BorderColor = 2579119
    DragType = dtVCL
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 270410
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Header.AutoSizeIndex = 0
    Header.Background = 5672120
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Height = 17
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Indent = 2
    ParentFont = False
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toExtendedFocus]
    OnBeforeCellPaint = ValuesGridBeforeCellPaint
    OnClick = ValuesGridClick
    OnCreateEditor = ValuesGridCreateEditor
    OnEdited = ValuesGridEdited
    OnEditing = ValuesGridEditing
    OnGetText = ValuesGridGetText
    OnKeyDown = ValuesGridKeyDown
    OnKeyPress = ValuesGridKeyPress
    OnNewText = ValuesGridNewText
    Columns = <
      item
        Position = 0
      end
      item
        Alignment = taRightJustify
        Position = 1
        Width = 80
      end>
  end
  object PopupMenu1: TPopupMenu
    Left = 320
    Top = 176
    object Showvalues1: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1103
      Default = True
      OnClick = Showvalues1Click
    end
    object VerticalGridShowHide: TMenuItem
      Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1072#1103' '#1089#1077#1090#1082#1072
      OnClick = VerticalGridShowHideClick
    end
    object HorizontalGridShowHide: TMenuItem
      Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1072#1103' '#1089#1077#1090#1082#1072
      OnClick = HorizontalGridShowHideClick
    end
    object ShowValuesOnGraph: TMenuItem
      Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1085#1072' '#1075#1088#1072#1092#1080#1082#1077
      OnClick = ShowValuesOnGraphClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PrintStatMenuItem: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100
      OnClick = PrintStatMenuItemClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object DelSecondGraphMenuItem: TMenuItem
      Caption = #1059#1073#1088#1072#1090#1100' '#1074#1090#1086#1088#1091#1102' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091
      OnClick = DelSecondGraphMenuItemClick
    end
  end
  object PrintDialog: TPrintDialog
    Left = 296
    Top = 232
  end
  object sSkinProvider1: TsSkinProvider
    ShowAppIcon = False
    TitleSkin = 'SCROLLBTNTOP'
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = 270410
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = [fsBold]
    SkinData.SkinSection = 'PAGECONTROL'
    TitleButtons = <>
    Left = 512
    Top = 48
  end
  object lc: TDKLanguageController
    Left = 184
    Top = 184
    LangData = {
      0800536D616C6C57696E010100000001000000070043617074696F6E010F0000
      00080053706C6974746572000005004368617274010200000003000000180042
      6F74746F6D417869732E5469746C652E43617074696F6E020000000A00546974
      6C652E54657874000700536572696573310102000000040000000C005856616C
      7565732E4E616D65050000000C005956616C7565732E4E616D65000A0056616C
      7565734772696400000A00506F7075704D656E753100000B0053686F7776616C
      75657331010100000006000000070043617074696F6E00140056657274696361
      6C4772696453686F7748696465010100000007000000070043617074696F6E00
      1600486F72697A6F6E74616C4772696453686F77486964650101000000080000
      00070043617074696F6E00110053686F7756616C7565734F6E47726170680101
      00000009000000070043617074696F6E0002004E31000011005072696E745374
      61744D656E754974656D01010000000A000000070043617074696F6E0002004E
      320000160044656C5365636F6E6447726170684D656E754974656D0101000000
      0B000000070043617074696F6E000B005072696E744469616C6F6700000E0073
      536B696E50726F76696465723101020000000C0000001400536B696E44617461
      2E536B696E53656374696F6E0D00000009005469746C65536B696E00}
  end
end
