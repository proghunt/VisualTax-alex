object AssetsFrameFP_2012: TAssetsFrameFP_2012
  Left = 0
  Top = 0
  Width = 714
  Height = 47
  Color = 15532031
  ParentColor = False
  TabOrder = 0
  object vtLabel1: TvtLabel
    Left = 7
    Top = 0
    Width = 31
    Height = 14
    Caption = 'Other'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel2: TvtLabel
    Left = 7
    Top = 14
    Width = 40
    Height = 14
    Caption = 'Assets'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtShape6: TvtShape
    Left = 56
    Top = 9
    Width = 16
    Height = 10
    Brush.Color = clRed
    GradientColor = clBlack
    Shape = vtTriangleRight
    FillDirection = vtUpFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtIsPrintable = False
  end
  object vtLabel3: TvtLabel
    Left = 77
    Top = 33
    Width = 575
    Height = 14
    Caption = 
      'Most detaled Asset forms are wide. For full viewing, press F5, o' +
      'r reduce the left panel and/or or use negative zoom (-)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object Cash: TBitBtn
    Left = 77
    Top = 3
    Width = 64
    Height = 15
    Caption = 'Cash'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = CashClick
  end
  object CSB: TBitBtn
    Left = 224
    Top = 3
    Width = 50
    Height = 15
    Caption = 'CSB'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = CSBClick
  end
  object GIC: TBitBtn
    Left = 455
    Top = 3
    Width = 43
    Height = 15
    Caption = 'GIC'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = GICClick
  end
  object Bonds: TBitBtn
    Left = 154
    Top = 3
    Width = 57
    Height = 15
    Caption = 'Bonds'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = BondsClick
  end
  object Loans: TBitBtn
    Left = 77
    Top = 20
    Width = 64
    Height = 15
    Caption = 'Loans'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = LoansClick
  end
  object TermDep: TBitBtn
    Left = 280
    Top = 3
    Width = 78
    Height = 15
    Caption = 'Term Deposits'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = TermDepClick
  end
  object MutFunds: TBitBtn
    Left = 154
    Top = 20
    Width = 78
    Height = 15
    Caption = 'Mutual Funds'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = MutFundsClick
  end
  object Stocks: TBitBtn
    Left = 231
    Top = 20
    Width = 64
    Height = 15
    Caption = 'Stocks'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = StocksClick
  end
  object DefPlans: TBitBtn
    Left = 371
    Top = 3
    Width = 78
    Height = 15
    Caption = 'Deferred Plans'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = DefPlansClick
  end
  object RealEst: TBitBtn
    Left = 504
    Top = 3
    Width = 75
    Height = 15
    Caption = 'Real Estate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = RealEstClick
  end
  object Business: TBitBtn
    Left = 315
    Top = 20
    Width = 75
    Height = 15
    Caption = 'Business'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnClick = BusinessClick
  end
  object OthAssets: TBitBtn
    Left = 406
    Top = 20
    Width = 75
    Height = 15
    Caption = 'Other Assets'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = OthAssetsClick
  end
end
