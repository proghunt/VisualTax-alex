object SavingsCalculatorFP_2012: TSavingsCalculatorFP_2012
  Left = 61
  Top = 67
  Width = 613
  Height = 397
  Caption = 'Savings Calculator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CalcBtn: TBitBtn
    Left = 192
    Top = 320
    Width = 89
    Height = 33
    Caption = 'Calculate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = CalcBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 296
    Top = 320
    Width = 81
    Height = 33
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
  object ListBox1: TListBox
    Left = 296
    Top = 48
    Width = 289
    Height = 257
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 16
    Top = 48
    Width = 273
    Height = 265
    BevelOuter = bvLowered
    Color = clSilver
    TabOrder = 3
    object Label1: TLabel
      Left = 16
      Top = 64
      Width = 80
      Height = 15
      Caption = 'Yearly Savings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 160
      Width = 91
      Height = 15
      Caption = 'Number of years'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 136
      Width = 70
      Height = 15
      Caption = 'Interest Rate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 16
      Top = 8
      Width = 95
      Height = 15
      Caption = 'Opening Balance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object TLabel
      Left = 16
      Top = 232
      Width = 91
      Height = 15
      Caption = 'Closing Balance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel2: TBevel
      Left = 0
      Top = 40
      Width = 255
      Height = 7
      Shape = bsBottomLine
      Style = bsRaised
    end
    object Bevel3: TBevel
      Left = 0
      Top = 208
      Width = 257
      Height = 9
      Shape = bsBottomLine
      Style = bsRaised
    end
    object Label8: TLabel
      Left = 168
      Top = 128
      Width = 11
      Height = 15
      Caption = '%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 16
      Top = 192
      Width = 98
      Height = 15
      Caption = 'Marginal Tax Rate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 168
      Top = 192
      Width = 11
      Height = 15
      Caption = '%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 16
      Top = 96
      Width = 97
      Height = 15
      Caption = 'Investment timing'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 152
      Top = 80
      Width = 85
      Height = 12
      Caption = 'B=Beginning of year'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 152
      Top = 91
      Width = 72
      Height = 12
      Caption = 'M=Middle of year'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 152
      Top = 102
      Width = 61
      Height = 12
      Caption = 'E=End of year'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object AmountBox: TEdit
      Left = 120
      Top = 56
      Width = 81
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '10000'
    end
    object YearsBox: TEdit
      Left = 120
      Top = 152
      Width = 41
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 2
      ParentFont = False
      TabOrder = 3
      Text = '10'
    end
    object InterestBox: TEdit
      Left = 120
      Top = 128
      Width = 41
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 5
      ParentFont = False
      TabOrder = 2
      Text = '10'
    end
    object OpeningBalanceBox: TEdit
      Left = 120
      Top = 8
      Width = 81
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '0'
    end
    object ResultBox: TEdit
      Left = 120
      Top = 224
      Width = 89
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = '0'
    end
    object TaxRateBox: TEdit
      Left = 120
      Top = 184
      Width = 41
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 5
      ParentFont = False
      TabOrder = 4
      Text = '0'
    end
    object TimingBox: TEdit
      Left = 120
      Top = 88
      Width = 25
      Height = 23
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 1
      ParentFont = False
      TabOrder = 6
      Text = 'B'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 605
    Height = 41
    Align = alTop
    Caption = 'Savings Calculator'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
end
