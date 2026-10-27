object FixedAssetsChartFP_2027: TFixedAssetsChartFP_2027
  Left = 116
  Top = 181
  ClientHeight = 0
  ClientWidth = 116
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 116
    Height = 49
    Align = alTop
    Caption = 'Fixed Assets Growth'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 784
    object ByYearOrAge: TRadioGroup
      Left = 8
      Top = 8
      Width = 129
      Height = 33
      Caption = 'Chart By year or Age'
      Color = clSilver
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 1
      Items.Strings = (
        'Year'
        'Age')
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      OnClick = ByYearOrAgeClick
    end
    object CancelBtn: TBitBtn
      Left = 640
      Top = 16
      Width = 51
      Height = 25
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 560
      Top = 16
      Width = 72
      Height = 25
      Caption = 'Print chart'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = PrintBtnClick
    end
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 56
    Width = 761
    Height = 441
    ActivePage = TabSheet2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Chart'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Chart1: TChart
        Left = 0
        Top = 8
        Width = 681
        Height = 341
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Border.Visible = True
        Gradient.Direction = gdBottomTop
        Gradient.EndColor = 16777156
        Gradient.Visible = True
        Legend.Visible = False
        Title.Font.Color = clNavy
        Title.Font.Height = -13
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Liabilities projection')
        BevelOuter = bvNone
        TabOrder = 0
        ColorPaletteIndex = 13
        object Series1: TBarSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.ShapeStyle = fosRoundRectangle
          Marks.Visible = False
          SeriesColor = clRed
          BarStyle = bsRectGradient
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Yearly Schedule '
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object StringGrid1: TStringGrid
        Left = 8
        Top = 5
        Width = 737
        Height = 396
        Color = 15663103
        ColCount = 10
        DefaultRowHeight = 16
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect]
        ParentFont = False
        TabOrder = 0
        ColWidths = (
          64
          43
          91
          64
          64
          64
          64
          64
          64
          64)
      end
    end
  end
end
