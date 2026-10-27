object RetirementChartsFP_2012: TRetirementChartsFP_2012
  Left = 73
  Top = 224
  Caption = 'Asset Accumulation'
  ClientHeight = 487
  ClientWidth = 726
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 89
    Align = alTop
    BevelOuter = bvLowered
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 793
    object InvestmentTypeBox: TRadioGroup
      Left = 16
      Top = 40
      Width = 369
      Height = 41
      Caption = 'Choose Investment type'
      Columns = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Items.Strings = (
        'Non-Shelt'
        'Sheltered'
        'Semi-shelt'
        'Other ')
      ParentFont = False
      TabOrder = 0
      OnClick = InvestmentTypeBoxClick
    end
    object ByYearOrAge: TRadioGroup
      Left = 488
      Top = 40
      Width = 113
      Height = 41
      Caption = 'Chart By'
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Items.Strings = (
        'Year'
        'Age')
      ParentFont = False
      TabOrder = 1
      OnClick = ByYearOrAgeClick
    end
    object ChartAllBtn: TBitBtn
      Left = 392
      Top = 48
      Width = 81
      Height = 33
      Caption = 'Chart All'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = ChartAllBtnClick
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 791
      Height = 40
      Align = alTop
      BevelOuter = bvLowered
      Caption = 'Asset Accumulation '
      Color = 11301888
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      object CancelBtn: TBitBtn
        Left = 608
        Top = 7
        Width = 81
        Height = 26
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'System'
        Font.Style = [fsBold]
        Kind = bkCancel
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 0
        OnClick = CancelBtnClick
      end
    end
    object PrintBtn: TBitBtn
      Left = 608
      Top = 48
      Width = 81
      Height = 32
      Caption = 'Print chart'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = PrintBtnClick
    end
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 96
    Width = 785
    Height = 449
    ActivePage = TabSheet2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnChange = PageControl1Change
    object Tabsheet1: TTabSheet
      Caption = 'Growth Chart'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Chart1: TChart
        Left = 24
        Top = 8
        Width = 649
        Height = 329
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Text.Strings = (
          'TChart')
        Color = clWhite
        TabOrder = 0
        ColorPaletteIndex = 13
        object Series1: TBarSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.ShapeStyle = fosRoundRectangle
          Marks.Visible = True
          SeriesColor = clRed
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Yearly Schedule'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GridTitleLbl: TLabel
        Left = 0
        Top = 0
        Width = 54
        Height = 19
        Align = alTop
        Alignment = taCenter
        Caption = 'xxxxxx'
        Color = 14933196
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object StringGrid2: TStringGrid
        Left = 8
        Top = 21
        Width = 769
        Height = 388
        Color = 15532031
        ColCount = 9
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
          38
          75
          74
          80
          84
          84
          78
          224)
      end
    end
  end
end
