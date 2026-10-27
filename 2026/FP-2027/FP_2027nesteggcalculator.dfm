object NestEggCalculatorFP_2012: TNestEggCalculatorFP_2012
  Left = 163
  Top = 98
  Width = 386
  Height = 390
  Caption = 'Nest Egg Calculator'
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
    Left = 80
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
    Left = 200
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
    Left = 352
    Top = 56
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
    Left = 56
    Top = 56
    Width = 257
    Height = 257
    BevelOuter = bvLowered
    Color = clSilver
    TabOrder = 3
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 129
      Height = 15
      Caption = 'Desired annual income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 112
      Height = 15
      Caption = 'For Number of years'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 88
      Width = 74
      Height = 15
      Caption = 'Rate of return'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 160
      Top = 24
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
    object TLabel
      Left = 16
      Top = 224
      Width = 118
      Height = 15
      Caption = 'Nest Egg required ($)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel3: TBevel
      Left = 0
      Top = 184
      Width = 257
      Height = 9
      Shape = bsBottomLine
      Style = bsRaised
    end
    object Label8: TLabel
      Left = 200
      Top = 96
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
      Top = 136
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
      Left = 200
      Top = 136
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
    object AmountBox: TEdit
      Left = 152
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
    object YearsBox: TEdit
      Left = 152
      Top = 48
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
      Left = 152
      Top = 88
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
      Left = 152
      Top = 216
      Width = 89
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = '0'
    end
    object TaxRateBox: TEdit
      Left = 152
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
      TabOrder = 3
      Text = '0'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 378
    Height = 41
    Align = alTop
    Caption = 'Nest Egg Calculator'
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
