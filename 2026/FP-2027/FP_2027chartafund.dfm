object ChartAFund: TChartAFund
  Left = 81
  Top = 212
  Caption = 'Fund Analysis'
  ClientHeight = 535
  ClientWidth = 771
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object FndName: TLabel
    Left = 0
    Top = 0
    Width = 771
    Height = 25
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'abc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 779
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 32
    Width = 745
    Height = 505
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Ten top Holdings'
      object HoldingsChart: TChart
        Left = 168
        Top = 8
        Width = 593
        Height = 441
        AllowPanning = pmNone
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        BackWall.Pen.Visible = False
        Gradient.EndColor = 16777088
        Gradient.StartColor = 8421631
        Gradient.Visible = True
        Legend.Visible = False
        Title.Text.Strings = (
          '')
        AxisVisible = False
        Chart3DPercent = 10
        ClipPoints = False
        Frame.Visible = False
        View3DOptions.Elevation = 315
        View3DOptions.HorizOffset = 36
        View3DOptions.Orthogonal = False
        View3DOptions.Perspective = 0
        View3DOptions.Rotation = 360
        View3DOptions.VertOffset = -36
        View3DOptions.Zoom = 126
        View3DWalls = False
        Zoom.Allow = False
        TabOrder = 0
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
      object DBGrid1: TDBGrid
        Left = 0
        Top = 8
        Width = 169
        Height = 441
        DataSource = TenTopHoldingsSrc
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'Holding'
            Width = 98
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Percent'
            Title.Caption = '%'
            Width = 32
            Visible = True
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Performance'
      ImageIndex = 1
      object Label38: TLabel
        Left = 496
        Top = 480
        Width = 101
        Height = 14
        Caption = 'Certificates Available'
        FocusControl = DBEdit22
      end
      object Label39: TLabel
        Left = 496
        Top = 520
        Width = 63
        Height = 14
        Caption = 'Cost to Issue'
        FocusControl = DBEdit23
      end
      object Label40: TLabel
        Left = 496
        Top = 560
        Width = 69
        Height = 14
        Caption = 'Switching Fee'
        FocusControl = DBEdit24
      end
      object Label41: TLabel
        Left = 496
        Top = 600
        Width = 71
        Height = 14
        Caption = 'Switching Text'
        FocusControl = DBEdit25
      end
      object Label42: TLabel
        Left = 496
        Top = 640
        Width = 51
        Height = 14
        Caption = 'Trailer Fee'
        FocusControl = DBEdit26
      end
      object Label43: TLabel
        Left = 496
        Top = 680
        Width = 53
        Height = 14
        Caption = 'Trailer Text'
        FocusControl = DBEdit27
      end
      object Label44: TLabel
        Left = 496
        Top = 720
        Width = 63
        Height = 14
        Caption = 'Max No Load'
        FocusControl = DBEdit28
      end
      object Label45: TLabel
        Left = 496
        Top = 760
        Width = 69
        Height = 14
        Caption = 'Max Front End'
        FocusControl = DBEdit29
      end
      object Label46: TLabel
        Left = 496
        Top = 800
        Width = 68
        Height = 14
        Caption = 'Max Back End'
        FocusControl = DBEdit30
      end
      object Label47: TLabel
        Left = 496
        Top = 840
        Width = 53
        Height = 14
        Caption = 'Min Assets'
        FocusControl = DBEdit31
      end
      object Label48: TLabel
        Left = 496
        Top = 880
        Width = 61
        Height = 14
        Caption = 'Max Front %'
        FocusControl = DBEdit32
      end
      object Label49: TLabel
        Left = 496
        Top = 920
        Width = 60
        Height = 14
        Caption = 'Max Back %'
        FocusControl = DBEdit33
      end
      object Label50: TLabel
        Left = 496
        Top = 960
        Width = 48
        Height = 14
        Caption = 'Min Invest'
        FocusControl = DBEdit34
      end
      object Label51: TLabel
        Left = 496
        Top = 1000
        Width = 90
        Height = 14
        Caption = 'Subsequent Invest'
        FocusControl = DBEdit35
      end
      object Label52: TLabel
        Left = 496
        Top = 1040
        Width = 20
        Height = 14
        Caption = 'PAC'
        FocusControl = DBEdit36
      end
      object Label53: TLabel
        Left = 496
        Top = 1080
        Width = 88
        Height = 14
        Caption = 'PIP Min Investment'
        FocusControl = DBEdit37
      end
      object Label54: TLabel
        Left = 496
        Top = 1120
        Width = 23
        Height = 14
        Caption = 'SWP'
        FocusControl = DBEdit61
      end
      object Label55: TLabel
        Left = 496
        Top = 1160
        Width = 84
        Height = 14
        Caption = 'SWP Min Balance'
        FocusControl = DBEdit62
      end
      object Label56: TLabel
        Left = 496
        Top = 1200
        Width = 100
        Height = 14
        Caption = 'SWP Min Withdrawal'
        FocusControl = DBEdit63
      end
      object Label57: TLabel
        Left = 496
        Top = 1240
        Width = 43
        Height = 14
        Caption = 'PAC Text'
        FocusControl = DBEdit64
      end
      object Label58: TLabel
        Left = 496
        Top = 1280
        Width = 53
        Height = 14
        Caption = 'RRSP Initial'
        FocusControl = DBEdit66
      end
      object Label59: TLabel
        Left = 496
        Top = 1320
        Width = 88
        Height = 14
        Caption = 'RRSP Subsequent'
        FocusControl = DBEdit74
      end
      object Label60: TLabel
        Left = 496
        Top = 1360
        Width = 75
        Height = 14
        Caption = 'Non RRSP Initial'
        FocusControl = DBEdit75
      end
      object Label61: TLabel
        Left = 496
        Top = 1400
        Width = 110
        Height = 14
        Caption = 'Non RRSP Subsequent'
        FocusControl = DBEdit76
      end
      object Label62: TLabel
        Left = 496
        Top = 1440
        Width = 91
        Height = 14
        Caption = 'Non RRSP Balance'
        FocusControl = DBEdit77
      end
      object Label63: TLabel
        Left = 496
        Top = 1480
        Width = 81
        Height = 14
        Caption = 'Group RRSP Fee'
        FocusControl = DBEdit78
      end
      object Label64: TLabel
        Left = 496
        Top = 1520
        Width = 58
        Height = 14
        Caption = 'Trustee Fee'
        FocusControl = DBEdit79
      end
      object Label65: TLabel
        Left = 496
        Top = 1560
        Width = 75
        Height = 14
        Caption = 'PIP Subsequent'
        FocusControl = DBEdit80
      end
      object Label66: TLabel
        Left = 496
        Top = 1600
        Width = 48
        Height = 14
        Caption = 'Sales Fee'
        FocusControl = DBEdit81
      end
      object GroupBox1: TGroupBox
        Left = 96
        Top = 40
        Width = 201
        Height = 153
        Caption = 'Standard Deviation'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label1: TLabel
          Left = 30
          Top = 24
          Width = 59
          Height = 14
          Caption = '3Yr Std Dev'
          FocusControl = DBEdit1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 30
          Top = 48
          Width = 59
          Height = 14
          Caption = '5Yr Std Dev'
          FocusControl = DBEdit2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 24
          Top = 72
          Width = 65
          Height = 14
          Caption = '10Yr Std Dev'
          FocusControl = DBEdit3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 24
          Top = 96
          Width = 65
          Height = 14
          Caption = '15Yr Std Dev'
          FocusControl = DBEdit4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 24
          Top = 120
          Width = 65
          Height = 14
          Caption = '20Yr Std Dev'
          FocusControl = DBEdit5
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit1: TDBEdit
          Left = 105
          Top = 24
          Width = 64
          Height = 22
          DataField = '3Yr Std Dev'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 105
          Top = 48
          Width = 64
          Height = 22
          DataField = '5Yr Std Dev'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit3: TDBEdit
          Left = 105
          Top = 72
          Width = 64
          Height = 22
          DataField = '10Yr Std Dev'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit4: TDBEdit
          Left = 105
          Top = 96
          Width = 64
          Height = 22
          DataField = '15Yr Std Dev'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object DBEdit5: TDBEdit
          Left = 105
          Top = 120
          Width = 64
          Height = 22
          DataField = '20Yr Std Dev'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
      end
      object GroupBox2: TGroupBox
        Left = 344
        Top = 40
        Width = 177
        Height = 153
        Caption = 'Volatility'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label6: TLabel
          Left = 8
          Top = 24
          Width = 60
          Height = 14
          Caption = '3Yr Volatility'
          FocusControl = DBEdit6
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 8
          Top = 48
          Width = 60
          Height = 14
          Caption = '5Yr Volatility'
          FocusControl = DBEdit7
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 6
          Top = 72
          Width = 66
          Height = 14
          Caption = '10Yr Volatility'
          FocusControl = DBEdit8
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label9: TLabel
          Left = 6
          Top = 99
          Width = 66
          Height = 14
          Caption = '15Yr Volatility'
          FocusControl = DBEdit9
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label10: TLabel
          Left = 6
          Top = 123
          Width = 66
          Height = 14
          Caption = '20Yr Volatility'
          FocusControl = DBEdit10
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit6: TDBEdit
          Left = 89
          Top = 24
          Width = 64
          Height = 22
          DataField = '3Yr Volatility'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit7: TDBEdit
          Left = 89
          Top = 48
          Width = 64
          Height = 22
          DataField = '5Yr Volatility'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit8: TDBEdit
          Left = 89
          Top = 72
          Width = 64
          Height = 22
          DataField = '10Yr Volatility'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit9: TDBEdit
          Left = 89
          Top = 91
          Width = 64
          Height = 22
          DataField = '15Yr Volatility'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object DBEdit10: TDBEdit
          Left = 89
          Top = 115
          Width = 64
          Height = 22
          DataField = '20Yr Volatility'
          DataSource = MptSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
      end
      object DBEdit22: TDBEdit
        Left = 496
        Top = 496
        Width = 10
        Height = 22
        DataField = 'Certificates Available'
        DataSource = feesExpensesSrc
        TabOrder = 2
      end
      object DBEdit23: TDBEdit
        Left = 496
        Top = 536
        Width = 64
        Height = 22
        DataField = 'Cost to Issue'
        DataSource = feesExpensesSrc
        TabOrder = 3
      end
      object DBEdit24: TDBEdit
        Left = 496
        Top = 576
        Width = 10
        Height = 22
        DataField = 'Switching Fee'
        DataSource = feesExpensesSrc
        TabOrder = 4
      end
      object DBEdit25: TDBEdit
        Left = 496
        Top = 616
        Width = 484
        Height = 22
        DataField = 'Switching Text'
        DataSource = feesExpensesSrc
        TabOrder = 5
      end
      object DBEdit26: TDBEdit
        Left = 496
        Top = 656
        Width = 10
        Height = 22
        DataField = 'Trailer Fee'
        DataSource = feesExpensesSrc
        TabOrder = 6
      end
      object DBEdit27: TDBEdit
        Left = 496
        Top = 696
        Width = 484
        Height = 22
        DataField = 'Trailer Text'
        DataSource = feesExpensesSrc
        TabOrder = 7
      end
      object DBEdit28: TDBEdit
        Left = 496
        Top = 736
        Width = 64
        Height = 22
        DataField = 'Max No Load'
        DataSource = feesExpensesSrc
        TabOrder = 8
      end
      object DBEdit29: TDBEdit
        Left = 496
        Top = 776
        Width = 64
        Height = 22
        DataField = 'Max Front End'
        DataSource = feesExpensesSrc
        TabOrder = 9
      end
      object DBEdit30: TDBEdit
        Left = 496
        Top = 816
        Width = 64
        Height = 22
        DataField = 'Max Back End'
        DataSource = feesExpensesSrc
        TabOrder = 10
      end
      object DBEdit31: TDBEdit
        Left = 496
        Top = 856
        Width = 64
        Height = 22
        DataField = 'Min Assets'
        DataSource = feesExpensesSrc
        TabOrder = 11
      end
      object DBEdit32: TDBEdit
        Left = 496
        Top = 896
        Width = 64
        Height = 22
        DataField = 'Max Front %'
        DataSource = feesExpensesSrc
        TabOrder = 12
      end
      object DBEdit33: TDBEdit
        Left = 496
        Top = 936
        Width = 64
        Height = 22
        DataField = 'Max Back %'
        DataSource = feesExpensesSrc
        TabOrder = 13
      end
      object DBEdit34: TDBEdit
        Left = 496
        Top = 976
        Width = 64
        Height = 22
        DataField = 'Min Invest'
        DataSource = feesExpensesSrc
        TabOrder = 14
      end
      object DBEdit35: TDBEdit
        Left = 496
        Top = 1016
        Width = 64
        Height = 22
        DataField = 'Subsequent Invest'
        DataSource = feesExpensesSrc
        TabOrder = 15
      end
      object DBEdit36: TDBEdit
        Left = 496
        Top = 1056
        Width = 10
        Height = 22
        DataField = 'PAC'
        DataSource = feesExpensesSrc
        TabOrder = 16
      end
      object DBEdit37: TDBEdit
        Left = 496
        Top = 1096
        Width = 64
        Height = 22
        DataField = 'PIP Min Investment'
        DataSource = feesExpensesSrc
        TabOrder = 17
      end
      object DBEdit61: TDBEdit
        Left = 496
        Top = 1136
        Width = 10
        Height = 22
        DataField = 'SWP'
        DataSource = feesExpensesSrc
        TabOrder = 18
      end
      object DBEdit62: TDBEdit
        Left = 496
        Top = 1176
        Width = 64
        Height = 22
        DataField = 'SWP Min Balance'
        DataSource = feesExpensesSrc
        TabOrder = 19
      end
      object DBEdit63: TDBEdit
        Left = 496
        Top = 1216
        Width = 64
        Height = 22
        DataField = 'SWP Min Withdrawal'
        DataSource = feesExpensesSrc
        TabOrder = 20
      end
      object DBEdit64: TDBEdit
        Left = 496
        Top = 1256
        Width = 364
        Height = 22
        DataField = 'PAC Text'
        DataSource = feesExpensesSrc
        TabOrder = 21
      end
      object DBEdit66: TDBEdit
        Left = 496
        Top = 1296
        Width = 64
        Height = 22
        DataField = 'RRSP Initial'
        DataSource = feesExpensesSrc
        TabOrder = 22
      end
      object DBEdit74: TDBEdit
        Left = 496
        Top = 1336
        Width = 64
        Height = 22
        DataField = 'RRSP Subsequent'
        DataSource = feesExpensesSrc
        TabOrder = 23
      end
      object DBEdit75: TDBEdit
        Left = 496
        Top = 1376
        Width = 64
        Height = 22
        DataField = 'Non RRSP Initial'
        DataSource = feesExpensesSrc
        TabOrder = 24
      end
      object DBEdit76: TDBEdit
        Left = 496
        Top = 1416
        Width = 64
        Height = 22
        DataField = 'Non RRSP Subsequent'
        DataSource = feesExpensesSrc
        TabOrder = 25
      end
      object DBEdit77: TDBEdit
        Left = 496
        Top = 1456
        Width = 64
        Height = 22
        DataField = 'Non RRSP Balance'
        DataSource = feesExpensesSrc
        TabOrder = 26
      end
      object DBEdit78: TDBEdit
        Left = 496
        Top = 1496
        Width = 454
        Height = 22
        DataField = 'Group RRSP Fee'
        DataSource = feesExpensesSrc
        TabOrder = 27
      end
      object DBEdit79: TDBEdit
        Left = 496
        Top = 1536
        Width = 454
        Height = 22
        DataField = 'Trustee Fee'
        DataSource = feesExpensesSrc
        TabOrder = 28
      end
      object DBEdit80: TDBEdit
        Left = 496
        Top = 1576
        Width = 64
        Height = 22
        DataField = 'PIP Subsequent'
        DataSource = feesExpensesSrc
        TabOrder = 29
      end
      object DBEdit81: TDBEdit
        Left = 496
        Top = 1616
        Width = 10
        Height = 22
        DataField = 'Sales Fee'
        DataSource = feesExpensesSrc
        TabOrder = 30
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Fees'
      ImageIndex = 2
      object Label76: TLabel
        Left = 544
        Top = 480
        Width = 53
        Height = 14
        Caption = 'Min Assets'
        FocusControl = DBEdit91
      end
      object Label77: TLabel
        Left = 544
        Top = 520
        Width = 61
        Height = 14
        Caption = 'Max Front %'
        FocusControl = DBEdit92
      end
      object Label78: TLabel
        Left = 544
        Top = 560
        Width = 60
        Height = 14
        Caption = 'Max Back %'
        FocusControl = DBEdit93
      end
      object Label79: TLabel
        Left = 544
        Top = 600
        Width = 48
        Height = 14
        Caption = 'Min Invest'
        FocusControl = DBEdit94
      end
      object Label80: TLabel
        Left = 544
        Top = 640
        Width = 90
        Height = 14
        Caption = 'Subsequent Invest'
        FocusControl = DBEdit95
      end
      object Label81: TLabel
        Left = 544
        Top = 680
        Width = 20
        Height = 14
        Caption = 'PAC'
        FocusControl = DBEdit96
      end
      object Label82: TLabel
        Left = 544
        Top = 720
        Width = 88
        Height = 14
        Caption = 'PIP Min Investment'
        FocusControl = DBEdit97
      end
      object Label83: TLabel
        Left = 544
        Top = 760
        Width = 23
        Height = 14
        Caption = 'SWP'
        FocusControl = DBEdit98
      end
      object Label84: TLabel
        Left = 544
        Top = 800
        Width = 84
        Height = 14
        Caption = 'SWP Min Balance'
        FocusControl = DBEdit99
      end
      object Label85: TLabel
        Left = 544
        Top = 840
        Width = 100
        Height = 14
        Caption = 'SWP Min Withdrawal'
        FocusControl = DBEdit100
      end
      object Label86: TLabel
        Left = 544
        Top = 880
        Width = 43
        Height = 14
        Caption = 'PAC Text'
        FocusControl = DBEdit101
      end
      object Label87: TLabel
        Left = 544
        Top = 920
        Width = 53
        Height = 14
        Caption = 'RRSP Initial'
        FocusControl = DBEdit102
      end
      object Label88: TLabel
        Left = 544
        Top = 960
        Width = 88
        Height = 14
        Caption = 'RRSP Subsequent'
        FocusControl = DBEdit103
      end
      object Label89: TLabel
        Left = 544
        Top = 1000
        Width = 75
        Height = 14
        Caption = 'Non RRSP Initial'
        FocusControl = DBEdit104
      end
      object Label90: TLabel
        Left = 544
        Top = 1040
        Width = 110
        Height = 14
        Caption = 'Non RRSP Subsequent'
        FocusControl = DBEdit105
      end
      object Label91: TLabel
        Left = 544
        Top = 1080
        Width = 91
        Height = 14
        Caption = 'Non RRSP Balance'
        FocusControl = DBEdit106
      end
      object Label92: TLabel
        Left = 544
        Top = 1120
        Width = 81
        Height = 14
        Caption = 'Group RRSP Fee'
        FocusControl = DBEdit107
      end
      object Label93: TLabel
        Left = 544
        Top = 1160
        Width = 58
        Height = 14
        Caption = 'Trustee Fee'
        FocusControl = DBEdit108
      end
      object Label94: TLabel
        Left = 544
        Top = 1200
        Width = 75
        Height = 14
        Caption = 'PIP Subsequent'
        FocusControl = DBEdit109
      end
      object Label95: TLabel
        Left = 544
        Top = 1240
        Width = 48
        Height = 14
        Caption = 'Sales Fee'
        FocusControl = DBEdit110
      end
      object DBEdit91: TDBEdit
        Left = 544
        Top = 496
        Width = 64
        Height = 22
        DataField = 'Min Assets'
        DataSource = feesExpensesSrc
        TabOrder = 2
      end
      object DBEdit92: TDBEdit
        Left = 544
        Top = 536
        Width = 64
        Height = 22
        DataField = 'Max Front %'
        DataSource = feesExpensesSrc
        TabOrder = 3
      end
      object DBEdit93: TDBEdit
        Left = 544
        Top = 576
        Width = 64
        Height = 22
        DataField = 'Max Back %'
        DataSource = feesExpensesSrc
        TabOrder = 4
      end
      object DBEdit94: TDBEdit
        Left = 544
        Top = 616
        Width = 64
        Height = 22
        DataField = 'Min Invest'
        DataSource = feesExpensesSrc
        TabOrder = 5
      end
      object DBEdit95: TDBEdit
        Left = 544
        Top = 656
        Width = 64
        Height = 22
        DataField = 'Subsequent Invest'
        DataSource = feesExpensesSrc
        TabOrder = 6
      end
      object DBEdit96: TDBEdit
        Left = 544
        Top = 696
        Width = 10
        Height = 22
        DataField = 'PAC'
        DataSource = feesExpensesSrc
        TabOrder = 7
      end
      object DBEdit97: TDBEdit
        Left = 544
        Top = 736
        Width = 64
        Height = 22
        DataField = 'PIP Min Investment'
        DataSource = feesExpensesSrc
        TabOrder = 8
      end
      object DBEdit98: TDBEdit
        Left = 544
        Top = 776
        Width = 10
        Height = 22
        DataField = 'SWP'
        DataSource = feesExpensesSrc
        TabOrder = 9
      end
      object DBEdit99: TDBEdit
        Left = 544
        Top = 816
        Width = 64
        Height = 22
        DataField = 'SWP Min Balance'
        DataSource = feesExpensesSrc
        TabOrder = 10
      end
      object DBEdit100: TDBEdit
        Left = 544
        Top = 856
        Width = 64
        Height = 22
        DataField = 'SWP Min Withdrawal'
        DataSource = feesExpensesSrc
        TabOrder = 11
      end
      object DBEdit101: TDBEdit
        Left = 544
        Top = 896
        Width = 364
        Height = 22
        DataField = 'PAC Text'
        DataSource = feesExpensesSrc
        TabOrder = 12
      end
      object DBEdit102: TDBEdit
        Left = 544
        Top = 936
        Width = 64
        Height = 22
        DataField = 'RRSP Initial'
        DataSource = feesExpensesSrc
        TabOrder = 13
      end
      object DBEdit103: TDBEdit
        Left = 544
        Top = 976
        Width = 64
        Height = 22
        DataField = 'RRSP Subsequent'
        DataSource = feesExpensesSrc
        TabOrder = 14
      end
      object DBEdit104: TDBEdit
        Left = 544
        Top = 1016
        Width = 64
        Height = 22
        DataField = 'Non RRSP Initial'
        DataSource = feesExpensesSrc
        TabOrder = 15
      end
      object DBEdit105: TDBEdit
        Left = 544
        Top = 1056
        Width = 64
        Height = 22
        DataField = 'Non RRSP Subsequent'
        DataSource = feesExpensesSrc
        TabOrder = 16
      end
      object DBEdit106: TDBEdit
        Left = 544
        Top = 1096
        Width = 64
        Height = 22
        DataField = 'Non RRSP Balance'
        DataSource = feesExpensesSrc
        TabOrder = 17
      end
      object DBEdit107: TDBEdit
        Left = 544
        Top = 1136
        Width = 454
        Height = 22
        DataField = 'Group RRSP Fee'
        DataSource = feesExpensesSrc
        TabOrder = 18
      end
      object DBEdit108: TDBEdit
        Left = 544
        Top = 1176
        Width = 454
        Height = 22
        DataField = 'Trustee Fee'
        DataSource = feesExpensesSrc
        TabOrder = 19
      end
      object DBEdit109: TDBEdit
        Left = 544
        Top = 1216
        Width = 64
        Height = 22
        DataField = 'PIP Subsequent'
        DataSource = feesExpensesSrc
        TabOrder = 20
      end
      object DBEdit110: TDBEdit
        Left = 544
        Top = 1256
        Width = 10
        Height = 22
        DataField = 'Sales Fee'
        DataSource = feesExpensesSrc
        TabOrder = 21
      end
      object GroupBox10: TGroupBox
        Left = 232
        Top = 200
        Width = 217
        Height = 81
        Caption = 'Minimum Investment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 24
        object Label99: TLabel
          Left = 25
          Top = 19
          Width = 71
          Height = 14
          Caption = 'Min Investment'
          FocusControl = DBEdit114
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label100: TLabel
          Left = 15
          Top = 51
          Width = 90
          Height = 14
          Caption = 'Subsequent Invest'
          FocusControl = DBEdit115
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit114: TDBEdit
          Left = 120
          Top = 19
          Width = 64
          Height = 22
          DataField = 'Min Invest'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit115: TDBEdit
          Left = 120
          Top = 51
          Width = 64
          Height = 22
          DataField = 'Subsequent Invest'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
      object GroupBox6: TGroupBox
        Left = 232
        Top = 288
        Width = 497
        Height = 113
        Caption = 'Other info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 22
        object Label96: TLabel
          Left = 51
          Top = 16
          Width = 53
          Height = 14
          Caption = 'Min Assets'
          FocusControl = DBEdit111
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label101: TLabel
          Left = 84
          Top = 48
          Width = 20
          Height = 14
          Caption = 'PAC'
          FocusControl = DBEdit116
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label102: TLabel
          Left = 201
          Top = 64
          Width = 88
          Height = 14
          Caption = 'PIP Min Investment'
          FocusControl = DBEdit117
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label103: TLabel
          Left = 202
          Top = 16
          Width = 117
          Height = 14
          Caption = 'Syst. Withdrawal (SWP)'
          FocusControl = DBEdit118
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label104: TLabel
          Left = 205
          Top = 40
          Width = 84
          Height = 14
          Caption = 'SWP Min Balance'
          FocusControl = DBEdit119
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit111: TDBEdit
          Left = 120
          Top = 16
          Width = 64
          Height = 22
          DataField = 'Min Assets'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit116: TDBEdit
          Left = 120
          Top = 40
          Width = 65
          Height = 22
          DataField = 'PAC'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit117: TDBEdit
          Left = 336
          Top = 64
          Width = 64
          Height = 22
          DataField = 'PIP Min Investment'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit118: TDBEdit
          Left = 336
          Top = 16
          Width = 65
          Height = 22
          DataField = 'SWP'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object DBEdit119: TDBEdit
          Left = 336
          Top = 40
          Width = 64
          Height = 22
          DataField = 'SWP Min Balance'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
      end
      object GroupBox9: TGroupBox
        Left = 232
        Top = 8
        Width = 497
        Height = 177
        Caption = 'Switching Fees'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 23
        object Label69: TLabel
          Left = 8
          Top = 16
          Width = 69
          Height = 14
          Caption = 'Switching Fee'
          FocusControl = DBEdit84
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label70: TLabel
          Left = 48
          Top = 32
          Width = 28
          Height = 14
          Caption = 'Notes'
          FocusControl = DBEdit85
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label71: TLabel
          Left = 24
          Top = 56
          Width = 51
          Height = 14
          Caption = 'Trailer Fee'
          FocusControl = DBEdit86
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label72: TLabel
          Left = 48
          Top = 72
          Width = 28
          Height = 14
          Caption = 'Notes'
          FocusControl = DBEdit87
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label73: TLabel
          Left = 8
          Top = 96
          Width = 63
          Height = 14
          Caption = 'Max No Load'
          FocusControl = DBEdit88
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label74: TLabel
          Left = 8
          Top = 120
          Width = 69
          Height = 14
          Caption = 'Max Front End'
          FocusControl = DBEdit89
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label75: TLabel
          Left = 8
          Top = 144
          Width = 68
          Height = 14
          Caption = 'Max Back End'
          FocusControl = DBEdit90
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit84: TDBEdit
          Left = 88
          Top = 16
          Width = 73
          Height = 22
          DataField = 'Switching Fee'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit85: TDBEdit
          Left = 88
          Top = 32
          Width = 401
          Height = 22
          DataField = 'Switching Text'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit86: TDBEdit
          Left = 88
          Top = 56
          Width = 73
          Height = 22
          DataField = 'Trailer Fee'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit87: TDBEdit
          Left = 88
          Top = 72
          Width = 401
          Height = 22
          DataField = 'Trailer Text'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object DBEdit88: TDBEdit
          Left = 88
          Top = 96
          Width = 73
          Height = 22
          DataField = 'Max No Load'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object DBEdit89: TDBEdit
          Left = 88
          Top = 120
          Width = 73
          Height = 22
          DataField = 'Max Front End'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object DBEdit90: TDBEdit
          Left = 88
          Top = 144
          Width = 73
          Height = 22
          DataField = 'Max Back End'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 209
        Height = 273
        Caption = 'Load/Charges'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label11: TLabel
          Left = 89
          Top = 72
          Width = 24
          Height = 14
          Caption = 'Load'
          FocusControl = DBEdit11
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label19: TLabel
          Left = 48
          Top = 96
          Width = 65
          Height = 14
          Caption = 'Front or Back'
          FocusControl = DBEdit12
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label26: TLabel
          Left = 36
          Top = 120
          Width = 77
          Height = 14
          Caption = 'Negotiable Fees'
          FocusControl = DBEdit13
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label27: TLabel
          Left = 68
          Top = 144
          Width = 45
          Height = 14
          Caption = 'Back Fee'
          FocusControl = DBEdit14
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label29: TLabel
          Left = 92
          Top = 168
          Width = 21
          Height = 14
          Caption = 'MER'
          FocusControl = DBEdit15
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label30: TLabel
          Left = 23
          Top = 192
          Width = 95
          Height = 14
          Caption = 'Management Fee %'
          FocusControl = DBEdit16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label31: TLabel
          Left = 26
          Top = 216
          Width = 87
          Height = 14
          Caption = 'Expenses Paid By'
          FocusControl = DBEdit17
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label97: TLabel
          Left = 60
          Top = 16
          Width = 61
          Height = 14
          Caption = 'Max Front %'
          FocusControl = DBEdit112
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label98: TLabel
          Left = 61
          Top = 48
          Width = 60
          Height = 14
          Caption = 'Max Back %'
          FocusControl = DBEdit113
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit11: TDBEdit
          Left = 136
          Top = 72
          Width = 65
          Height = 22
          DataField = 'Load'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit12: TDBEdit
          Left = 136
          Top = 96
          Width = 65
          Height = 22
          DataField = 'Front or Back'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit13: TDBEdit
          Left = 136
          Top = 120
          Width = 65
          Height = 22
          DataField = 'Negotiable Fees'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit14: TDBEdit
          Left = 136
          Top = 144
          Width = 65
          Height = 22
          DataField = 'Back Fee'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object DBEdit15: TDBEdit
          Left = 136
          Top = 168
          Width = 64
          Height = 22
          DataField = 'MER'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object DBEdit16: TDBEdit
          Left = 136
          Top = 192
          Width = 64
          Height = 22
          DataField = 'Management Fee'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object DBEdit17: TDBEdit
          Left = 136
          Top = 216
          Width = 65
          Height = 22
          DataField = 'Expenses Paid By'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object DBEdit112: TDBEdit
          Left = 136
          Top = 16
          Width = 64
          Height = 22
          DataField = 'Max Front %'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object DBEdit113: TDBEdit
          Left = 136
          Top = 40
          Width = 64
          Height = 22
          DataField = 'Max Back %'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 288
        Width = 209
        Height = 121
        Caption = 'RRSP fees'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label34: TLabel
          Left = 32
          Top = 24
          Width = 80
          Height = 14
          Caption = 'RRSP Admin Fee'
          FocusControl = DBEdit18
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label35: TLabel
          Left = 15
          Top = 48
          Width = 98
          Height = 14
          Caption = 'RRSP Withdraw Fee'
          FocusControl = DBEdit19
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label36: TLabel
          Left = 37
          Top = 72
          Width = 75
          Height = 14
          Caption = 'RRIF Admin Fee'
          FocusControl = DBEdit20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label37: TLabel
          Left = 20
          Top = 96
          Width = 93
          Height = 14
          Caption = 'RRIF Withdraw Fee'
          FocusControl = DBEdit21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit18: TDBEdit
          Left = 129
          Top = 16
          Width = 64
          Height = 22
          DataField = 'RRSP Admin Fee'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit19: TDBEdit
          Left = 129
          Top = 40
          Width = 64
          Height = 22
          DataField = 'RRSP Withdraw Fee'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit20: TDBEdit
          Left = 129
          Top = 64
          Width = 64
          Height = 22
          DataField = 'RRIF Admin Fee'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit21: TDBEdit
          Left = 129
          Top = 88
          Width = 64
          Height = 22
          DataField = 'RRIF Withdraw Fee'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
      end
      object GroupBox5: TGroupBox
        Left = 472
        Top = 208
        Width = 257
        Height = 73
        Caption = 'Certificates'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 25
        object Label67: TLabel
          Left = 8
          Top = 27
          Width = 101
          Height = 14
          Caption = 'Certificates Available'
          FocusControl = DBEdit82
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label68: TLabel
          Left = 40
          Top = 51
          Width = 63
          Height = 14
          Caption = 'Cost to Issue'
          FocusControl = DBEdit83
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit82: TDBEdit
          Left = 136
          Top = 19
          Width = 65
          Height = 22
          DataField = 'Certificates Available'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit83: TDBEdit
          Left = 136
          Top = 43
          Width = 65
          Height = 22
          DataField = 'Cost to Issue'
          DataSource = feesExpensesSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Asset Allocation'
      ImageIndex = 3
      object Label32: TLabel
        Left = 304
        Top = 488
        Width = 66
        Height = 14
        Caption = 'SOUTH AM %'
        FocusControl = DBEdit52
      end
      object Label33: TLabel
        Left = 304
        Top = 528
        Width = 78
        Height = 14
        Caption = 'CENTRAL AM %'
        FocusControl = DBEdit53
      end
      object Label105: TLabel
        Left = 304
        Top = 568
        Width = 50
        Height = 14
        Caption = 'AFRICA %'
        FocusControl = DBEdit54
      end
      object Label106: TLabel
        Left = 304
        Top = 608
        Width = 92
        Height = 14
        Caption = 'OTH EUROPEAN %'
        FocusControl = DBEdit55
      end
      object Label107: TLabel
        Left = 304
        Top = 648
        Width = 27
        Height = 14
        Caption = 'UK %'
        FocusControl = DBEdit56
      end
      object Label108: TLabel
        Left = 304
        Top = 688
        Width = 79
        Height = 14
        Caption = 'MIDDLE EAST %'
        FocusControl = DBEdit57
      end
      object GroupBox7: TGroupBox
        Left = 40
        Top = 16
        Width = 225
        Height = 241
        Caption = 'By Asset Category'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label12: TLabel
          Left = 16
          Top = 144
          Width = 26
          Height = 14
          Caption = 'REITs'
          FocusControl = DBEdit38
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label13: TLabel
          Left = 16
          Top = 120
          Width = 104
          Height = 14
          Caption = 'Royalty trust unitsunit'
          FocusControl = DBEdit39
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label14: TLabel
          Left = 8
          Top = 48
          Width = 71
          Height = 14
          Caption = 'Common Stock'
          FocusControl = DBEdit40
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label15: TLabel
          Left = 16
          Top = 72
          Width = 46
          Height = 14
          Caption = 'Preferred'
          FocusControl = DBEdit41
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label16: TLabel
          Left = 16
          Top = 96
          Width = 25
          Height = 14
          Caption = 'Cash'
          FocusControl = DBEdit42
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label115: TLabel
          Left = 144
          Top = 24
          Width = 10
          Height = 14
          Caption = '%'
          FocusControl = DBEdit42
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit38: TDBEdit
          Left = 128
          Top = 136
          Width = 41
          Height = 22
          DataField = 'REITCA %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit39: TDBEdit
          Left = 128
          Top = 112
          Width = 41
          Height = 22
          DataField = 'ROYLTY %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit40: TDBEdit
          Left = 128
          Top = 40
          Width = 41
          Height = 22
          DataField = 'COMSTK %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit41: TDBEdit
          Left = 128
          Top = 64
          Width = 41
          Height = 22
          DataField = 'PREFST %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object DBEdit42: TDBEdit
          Left = 128
          Top = 88
          Width = 41
          Height = 22
          DataField = 'CASH %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
      end
      object DBEdit52: TDBEdit
        Left = 304
        Top = 504
        Width = 64
        Height = 22
        DataField = 'SOUTH AM %'
        DataSource = ALlocationsSrc
        TabOrder = 1
      end
      object DBEdit53: TDBEdit
        Left = 304
        Top = 544
        Width = 64
        Height = 22
        DataField = 'CENTRAL AM %'
        DataSource = ALlocationsSrc
        TabOrder = 2
      end
      object DBEdit54: TDBEdit
        Left = 304
        Top = 584
        Width = 64
        Height = 22
        DataField = 'AFRICA %'
        DataSource = ALlocationsSrc
        TabOrder = 3
      end
      object DBEdit55: TDBEdit
        Left = 304
        Top = 624
        Width = 64
        Height = 22
        DataField = 'OTH EUROPEAN %'
        DataSource = ALlocationsSrc
        TabOrder = 4
      end
      object DBEdit56: TDBEdit
        Left = 304
        Top = 664
        Width = 64
        Height = 22
        DataField = 'UK %'
        DataSource = ALlocationsSrc
        TabOrder = 5
      end
      object DBEdit57: TDBEdit
        Left = 304
        Top = 704
        Width = 64
        Height = 22
        DataField = 'MIDDLE EAST %'
        DataSource = ALlocationsSrc
        TabOrder = 6
      end
      object GroupBox8: TGroupBox
        Left = 304
        Top = 24
        Width = 393
        Height = 233
        Caption = 'Geographically'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        object Label17: TLabel
          Left = 24
          Top = 24
          Width = 57
          Height = 14
          Caption = 'CANADA %'
          FocusControl = DBEdit43
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label18: TLabel
          Left = 56
          Top = 48
          Width = 27
          Height = 14
          Caption = 'US %'
          FocusControl = DBEdit44
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label20: TLabel
          Left = 32
          Top = 72
          Width = 46
          Height = 14
          Caption = 'JAPAN %'
          FocusControl = DBEdit45
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label21: TLabel
          Left = 8
          Top = 96
          Width = 76
          Height = 14
          Caption = 'HONG KONG %'
          FocusControl = DBEdit46
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label22: TLabel
          Left = 40
          Top = 120
          Width = 43
          Height = 14
          Caption = 'CHINA %'
          FocusControl = DBEdit47
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label23: TLabel
          Left = 16
          Top = 144
          Width = 68
          Height = 14
          Caption = 'OTH ASIAN %'
          FocusControl = DBEdit48
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label24: TLabel
          Left = 32
          Top = 168
          Width = 51
          Height = 14
          Caption = 'MEXICO %'
          FocusControl = DBEdit49
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label25: TLabel
          Left = 224
          Top = 32
          Width = 65
          Height = 14
          Caption = 'GERMANY %'
          FocusControl = DBEdit50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label28: TLabel
          Left = 216
          Top = 56
          Width = 71
          Height = 14
          Caption = 'AUSTRALIA %'
          FocusControl = DBEdit51
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label109: TLabel
          Left = 224
          Top = 80
          Width = 66
          Height = 14
          Caption = 'SOUTH AM %'
          FocusControl = DBEdit58
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label110: TLabel
          Left = 208
          Top = 104
          Width = 78
          Height = 14
          Caption = 'CENTRAL AM %'
          FocusControl = DBEdit59
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label111: TLabel
          Left = 240
          Top = 128
          Width = 50
          Height = 14
          Caption = 'AFRICA %'
          FocusControl = DBEdit60
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label112: TLabel
          Left = 200
          Top = 152
          Width = 92
          Height = 14
          Caption = 'OTH EUROPEAN %'
          FocusControl = DBEdit65
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label113: TLabel
          Left = 264
          Top = 176
          Width = 27
          Height = 14
          Caption = 'UK %'
          FocusControl = DBEdit67
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label114: TLabel
          Left = 216
          Top = 200
          Width = 79
          Height = 14
          Caption = 'MIDDLE EAST %'
          FocusControl = DBEdit68
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object DBEdit43: TDBEdit
          Left = 104
          Top = 24
          Width = 64
          Height = 22
          DataField = 'CANADA %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit44: TDBEdit
          Left = 104
          Top = 48
          Width = 64
          Height = 22
          DataField = 'US %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit45: TDBEdit
          Left = 104
          Top = 72
          Width = 64
          Height = 22
          DataField = 'JAPAN %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit46: TDBEdit
          Left = 104
          Top = 96
          Width = 64
          Height = 22
          DataField = 'HONG KONG %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object DBEdit47: TDBEdit
          Left = 104
          Top = 120
          Width = 64
          Height = 22
          DataField = 'CHINA %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object DBEdit48: TDBEdit
          Left = 104
          Top = 144
          Width = 64
          Height = 22
          DataField = 'OTH ASIAN %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object DBEdit49: TDBEdit
          Left = 104
          Top = 168
          Width = 64
          Height = 22
          DataField = 'MEXICO %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object DBEdit50: TDBEdit
          Left = 312
          Top = 24
          Width = 64
          Height = 22
          DataField = 'GERMANY %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object DBEdit51: TDBEdit
          Left = 312
          Top = 48
          Width = 64
          Height = 22
          DataField = 'AUSTRAL %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object DBEdit58: TDBEdit
          Left = 312
          Top = 72
          Width = 64
          Height = 22
          DataField = 'SOUTH AM %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object DBEdit59: TDBEdit
          Left = 312
          Top = 96
          Width = 64
          Height = 22
          DataField = 'CENTRAL AM %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object DBEdit60: TDBEdit
          Left = 312
          Top = 120
          Width = 64
          Height = 22
          DataField = 'AFRICA %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
        end
        object DBEdit65: TDBEdit
          Left = 312
          Top = 144
          Width = 64
          Height = 22
          DataField = 'OTH EUROPEAN %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
        end
        object DBEdit67: TDBEdit
          Left = 312
          Top = 168
          Width = 64
          Height = 22
          DataField = 'UK %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
        end
        object DBEdit68: TDBEdit
          Left = 312
          Top = 192
          Width = 64
          Height = 22
          DataField = 'MIDDLE EAST %'
          DataSource = ALlocationsSrc
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
        end
      end
    end
  end
  object CancelBtn: TBitBtn
    Left = 632
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 1
  end
  object TenTopHoldingsSrc: TDataSource
    DataSet = TenTopHoldingsQ
    Left = 37
    Top = 1
  end
  object MutualFundsSrc: TDataSource
    DataSet = TenTopHoldingsQ
    Left = 128
  end
  object MptSrc: TDataSource
    DataSet = MptTbl
    Left = 172
    Top = 81
  end
  object feesExpensesSrc: TDataSource
    DataSet = FeesExpensesTbl
    Left = 492
    Top = 57
  end
  object ALlocationsSrc: TDataSource
    DataSet = AllocationsTbl
    Left = 36
    Top = 153
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FundData.DB')
    Left = 101
    Top = 265
  end
  object AllocationsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Allocations'
    TableName = 'Allocations'
    Left = 68
    Top = 192
  end
  object TenTopHoldingsQ: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'MutualFunds'
    TableName = 'MutualFunds'
    Left = 108
    Top = 49
  end
  object MptTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'MPT'
    TableName = 'MPT'
    Left = 188
    Top = 129
  end
  object PerformanceGrowthTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Performance Growth'
    TableName = 'Performance Growth'
    Left = 244
    Top = 97
  end
  object PerformanceTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Performance'
    TableName = 'Performance'
    Left = 436
    Top = 9
  end
  object PerformanceRankTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Performance Rank'
    TableName = 'Performance Rank'
    Left = 492
    Top = 1
  end
  object FeesExpensesTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'FeesExpenses'
    TableName = 'FeesExpenses'
    Left = 428
    Top = 65
  end
  object PortfolioDetailsQ: TADQuery
    Connection = FDConnection
    SQL.Strings = (
      'Select * from  "Ten Top Holdings"')
    Left = 20
    Top = 43
  end
end
