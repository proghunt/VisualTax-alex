object chartT1_2026: TchartT1_2026
  Left = 102
  Top = 72
  Caption = 'Client Statistics'
  ClientHeight = 450
  ClientWidth = 698
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 181
    Height = 14
    Caption = 'For numbers click the Bars icon. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
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
  object Label3: TLabel
    Left = 8
    Top = 32
    Width = 274
    Height = 14
    Caption = 'For exact numbers, right click on the face of a bar.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 296
    Top = 48
    Width = 63
    Height = 14
    Caption = 'Pie icon (%)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape1: TShape
    Left = 190
    Top = 56
    Width = 11
    Height = 1
    Brush.Style = bsClear
  end
  object Shape2: TShape
    Left = 200
    Top = 56
    Width = 1
    Height = 9
    Brush.Style = bsClear
  end
  object Shape3: TShape
    Left = 272
    Top = 56
    Width = 17
    Height = 1
    Brush.Style = bsClear
  end
  object Shape4: TShape
    Left = 272
    Top = 56
    Width = 1
    Height = 9
    Brush.Style = bsClear
  end
  object ChartGroup: TRadioGroup
    Left = 8
    Top = 0
    Width = 417
    Height = 33
    Hint = 'Click to select a chart'
    Caption = 'Select chart:'
    Columns = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Items.Strings = (
      'EFile Status'
      'Prep Status'
      'Marital Status'
      'Age')
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = ChartGroupClick
  end
  object CancelBtn: TBitBtn
    Left = 488
    Top = 40
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
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object DataDirBox: TEdit
    Left = 432
    Top = 16
    Width = 161
    Height = 22
    TabOrder = 2
    Text = 'DataDirBox'
    OnExit = DataDirBoxExit
    OnKeyPress = DataDirBoxKeyPress
  end
  object Panel1: TPanel
    Left = 8
    Top = 71
    Width = 665
    Height = 378
    Hint = 'For exact values, right click on the face of a bar '
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object Chart1: TChart
      Left = 32
      Top = 24
      Width = 601
      Height = 329
      AllowPanning = pmNone
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      BackWall.Pen.Visible = False
      Title.Text.Strings = (
        'TChart')
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
      TabOrder = 0
      PrintMargins = (
        15
        22
        15
        22)
      ColorPaletteIndex = 13
      object Series1: TPieSeries
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.ShapeStyle = fosRoundRectangle
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
  end
  object DataSource1: TDataSource
    Left = 566
    Top = 15
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 616
    Top = 16
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 624
    Top = 64
  end
end
