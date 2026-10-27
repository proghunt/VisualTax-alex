object ChartClientsT1_2026: TChartClientsT1_2026
  Left = 125
  Top = 72
  Caption = 'Client Statistics'
  ClientHeight = 421
  ClientWidth = 666
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label2: TLabel
    Left = 472
    Top = 0
    Width = 79
    Height = 14
    Caption = 'Data Directory:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ChartGroup: TRadioGroup
    Left = 8
    Top = 8
    Width = 417
    Height = 33
    Hint = 'Click to select a chart'
    Caption = 'Select chart:'
    Columns = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Items.Strings = (
      'EFile Status'
      'Prep Status'
      'Age'
      'Marital Status')
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = ChartGroupClick
  end
  object DataDirBox: TEdit
    Left = 432
    Top = 16
    Width = 161
    Height = 22
    TabOrder = 1
    Text = 'DataDirBox'
    OnExit = DataDirBoxExit
    OnKeyPress = DataDirBoxKeyPress
  end
  object Chart1: TChart
    Left = 9
    Top = 56
    Width = 656
    Height = 337
    AllowPanning = pmNone
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Pen.Visible = False
    Title.Font.Color = clNavy
    Title.Font.Height = -19
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      '')
    AxisVisible = False
    ClipPoints = False
    Frame.Visible = False
    View3DOptions.Elevation = 315
    View3DOptions.Orthogonal = False
    View3DOptions.Perspective = 0
    View3DOptions.Rotation = 360
    View3DWalls = False
    Zoom.Allow = False
    Zoom.Pen.Mode = pmNotXor
    TabOrder = 2
    ColorPaletteIndex = 13
    object Series1: TPieSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.ShapeStyle = fosRoundRectangle
      Marks.Style = smsLabelPercent
      Marks.Visible = True
      SeriesColor = clRed
      XValues.Order = loAscending
      YValues.Name = 'Pie'
      YValues.Order = loNone
      Frame.InnerBrush.BackColor = clRed
      Frame.InnerBrush.Gradient.EndColor = clGray
      Frame.InnerBrush.Gradient.MidColor = clWhite
      Frame.InnerBrush.Gradient.StartColor = 4210752
      Frame.InnerBrush.Gradient.Visible = True
      Frame.MiddleBrush.BackColor = clYellow
      Frame.MiddleBrush.Gradient.EndColor = 8553090
      Frame.MiddleBrush.Gradient.MidColor = clWhite
      Frame.MiddleBrush.Gradient.StartColor = clGray
      Frame.MiddleBrush.Gradient.Visible = True
      Frame.OuterBrush.BackColor = clGreen
      Frame.OuterBrush.Gradient.EndColor = 4210752
      Frame.OuterBrush.Gradient.MidColor = clWhite
      Frame.OuterBrush.Gradient.StartColor = clSilver
      Frame.OuterBrush.Gradient.Visible = True
      Frame.Width = 4
      OtherSlice.Legend.Visible = False
      OtherSlice.Text = 'Other'
    end
  end
  object CancelBtn: TBitBtn
    Left = 600
    Top = 15
    Width = 65
    Height = 23
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'System'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 468
    Top = 64
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 377
    Top = 56
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 425
    Top = 64
  end
end
