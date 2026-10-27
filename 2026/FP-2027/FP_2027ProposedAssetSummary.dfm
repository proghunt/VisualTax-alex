object ProposedAssetSummary: TProposedAssetSummary
  Left = 110
  Top = 113
  Caption = 'Proposed Asset Summary'
  ClientHeight = 504
  ClientWidth = 762
  Color = clBtnShadow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 160
    Top = 432
    Width = 165
    Height = 13
    Caption = 'Un-allocated cash from sales'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Chart3: TChart
    Left = 8
    Top = 16
    Width = 753
    Height = 393
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Font.Color = clMaroon
    Title.Font.Height = -16
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      'Investment Mix (Current vs Proposed)')
    TabOrder = 2
    ColorPaletteIndex = 13
    object Series3: TBarSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.ShapeStyle = fosRoundRectangle
      Marks.Style = smsPercent
      Marks.Visible = True
      SeriesColor = clRed
      Title = 'Current'
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
    object Series4: TBarSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.ShapeStyle = fosRoundRectangle
      Marks.Style = smsPercent
      Marks.Visible = True
      SeriesColor = clGreen
      Title = 'Proposed'
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object CancelBtn: TBitBtn
    Left = 672
    Top = 160
    Width = 65
    Height = 25
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 0
    OnClick = CancelBtnClick
  end
  object Chart1: TChart
    Left = 664
    Top = 272
    Width = 89
    Height = 73
    AllowPanning = pmNone
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Pen.Visible = False
    Title.Font.Color = clMaroon
    Title.Font.Height = -16
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      '(Proposed) Asset Mix')
    AxisVisible = False
    ClipPoints = False
    Frame.Visible = False
    View3DOptions.Elevation = 315
    View3DOptions.Orthogonal = False
    View3DOptions.Perspective = 0
    View3DOptions.Rotation = 360
    View3DWalls = False
    Zoom.Allow = False
    TabOrder = 1
    Visible = False
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
  object Edit1: TEdit
    Left = 336
    Top = 424
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = 'Edit1'
  end
  object DataSource1: TDataSource
    DataSet = InvestmentPlanQ
    Left = 80
    Top = 16
  end
  object DataSource2: TDataSource
    DataSet = AssetTypesTbl
    Left = 80
    Top = 288
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 253
    Top = 17
  end
  object InvestmentPlanQ: TADQuery
    Connection = FDConnection
    Left = 196
    Top = 19
  end
  object AssetTypesTbl: TADTable
    Connection = tblFDConnection
    UpdateOptions.UpdateTableName = 'AssetTypes'
    TableName = 'AssetTypes'
    Left = 124
    Top = 248
  end
  object tblFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FrontOfficeDb')
    Left = 181
    Top = 241
  end
end
