object PresentValueCalculatorFP_2012: TPresentValueCalculatorFP_2012
  Left = 129
  Top = 162
  Width = 442
  Height = 369
  Caption = 'PresentValueCalculatorFP_2012'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object CancelBtn: TBitBtn
    Left = 232
    Top = 264
    Width = 89
    Height = 33
    Caption = 'Exit'
    TabOrder = 0
    Kind = bkCancel
  end
  object Panel1: TPanel
    Left = 32
    Top = 48
    Width = 353
    Height = 201
    BevelOuter = bvLowered
    TabOrder = 1
    object Label2: TLabel
      Left = 85
      Top = 24
      Width = 60
      Height = 15
      Caption = 'Amount ($)'
    end
    object Label3: TLabel
      Left = 93
      Top = 88
      Width = 41
      Height = 15
      Caption = 'Interest'
    end
    object Label4: TLabel
      Left = 45
      Top = 56
      Width = 91
      Height = 15
      Caption = 'Number of years'
    end
    object Label5: TLabel
      Left = 40
      Top = 144
      Width = 95
      Height = 15
      Caption = 'Present Value ($)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 213
      Top = 88
      Width = 11
      Height = 15
      Caption = '%'
    end
    object Bevel3: TBevel
      Left = 48
      Top = 120
      Width = 257
      Height = 17
      Shape = bsBottomLine
      Style = bsRaised
    end
    object AmountBox: TEdit
      Left = 161
      Top = 20
      Width = 96
      Height = 23
      TabOrder = 0
    end
    object YearsBox: TEdit
      Left = 161
      Top = 52
      Width = 48
      Height = 23
      TabOrder = 1
    end
    object InterestBox: TEdit
      Left = 161
      Top = 84
      Width = 48
      Height = 23
      TabOrder = 2
    end
    object PresValBox: TEdit
      Left = 161
      Top = 140
      Width = 96
      Height = 23
      Enabled = False
      TabOrder = 3
    end
  end
  object CalcBtn: TBitBtn
    Left = 120
    Top = 264
    Width = 89
    Height = 33
    Caption = 'Calc'
    TabOrder = 2
    OnClick = CalcBtnClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 41
    Align = alTop
    Caption = 'Present Value Calculator'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
end
