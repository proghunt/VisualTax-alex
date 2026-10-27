object DebtRepaymentCalculatorFP_2012: TDebtRepaymentCalculatorFP_2012
  Left = 27
  Top = 54
  Width = 677
  Height = 449
  Caption = 'Debt Repayment Calculator'
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
    Left = 152
    Top = 296
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
    Left = 256
    Top = 296
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
    Left = 360
    Top = 64
    Width = 17
    Height = 257
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 2
    Visible = False
  end
  object Panel1: TPanel
    Left = 48
    Top = 48
    Width = 433
    Height = 241
    BevelOuter = bvLowered
    Color = clSilver
    TabOrder = 3
    object Label1: TLabel
      Left = 72
      Top = 24
      Width = 100
      Height = 15
      Caption = 'Amount of debt ($)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 72
      Top = 72
      Width = 51
      Height = 15
      Caption = 'Repay in '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 72
      Top = 120
      Width = 82
      Height = 15
      Caption = 'Annual Interest'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object TLabel
      Left = 56
      Top = 200
      Width = 115
      Height = 15
      Caption = 'Payment required ($)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel3: TBevel
      Left = 16
      Top = 168
      Width = 393
      Height = 9
      Shape = bsBottomLine
      Style = bsRaised
    end
    object Label8: TLabel
      Left = 232
      Top = 120
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
    object perPaymentBox: TLabel
      Left = 280
      Top = 200
      Width = 44
      Height = 15
      Caption = 'per year'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object PrincipalBox: TEdit
      Left = 184
      Top = 16
      Width = 81
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '10000'
    end
    object PeriodsBox: TEdit
      Left = 184
      Top = 64
      Width = 41
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 2
      ParentFont = False
      TabOrder = 1
      Text = '10'
    end
    object InterestBox: TEdit
      Left = 184
      Top = 112
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
    object ResultBox: TEdit
      Left = 184
      Top = 192
      Width = 89
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = '0'
    end
    object PeriodTypeBox: TRadioGroup
      Left = 272
      Top = 56
      Width = 129
      Height = 41
      Columns = 2
      Items.Strings = (
        'Years'
        'Months')
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 669
    Height = 41
    Align = alTop
    Caption = 'Debt repayment calculator'
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
