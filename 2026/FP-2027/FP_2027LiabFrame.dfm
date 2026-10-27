object LiabFrameFP_2012: TLiabFrameFP_2012
  Left = 0
  Top = 0
  Width = 642
  Height = 52
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
    Width = 50
    Height = 14
    Caption = 'Liablities'
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
    Left = 91
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
    Left = 91
    Top = 31
    Width = 538
    Height = 14
    Caption = 
      'Some liabiliy forms are wide. For full viewing, press F5, or red' +
      'uce the left panel and/or or use negative zoom (-)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object UnPaidBills: TBitBtn
    Left = 112
    Top = 3
    Width = 92
    Height = 15
    Caption = 'Unpaid Bills'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = UnPaidBillsClick
  end
  object CreditCards: TBitBtn
    Left = 308
    Top = 3
    Width = 78
    Height = 15
    Caption = 'Credit Cards'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = CreditCardsClick
  end
  object Mortgages: TBitBtn
    Left = 112
    Top = 17
    Width = 92
    Height = 15
    Caption = 'Mortgages'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = MortgagesClick
  end
  object BankAdv: TBitBtn
    Left = 210
    Top = 3
    Width = 85
    Height = 15
    Caption = 'Bank Advances'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = BankAdvClick
  end
  object TaxPayable: TBitBtn
    Left = 399
    Top = 3
    Width = 113
    Height = 15
    Caption = 'Income TaxPayable'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = TaxPayableClick
  end
  object CarLoans: TBitBtn
    Left = 518
    Top = 3
    Width = 64
    Height = 15
    Caption = 'Car Loans'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = CarLoansClick
  end
  object OthLongTerm: TBitBtn
    Left = 210
    Top = 17
    Width = 85
    Height = 15
    Caption = 'Other Long Term'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = OthLongTermClick
  end
end
