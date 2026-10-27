object FutureValueCalculatorFP_2012: TFutureValueCalculatorFP_2012
  Left = 111
  Top = 149
  Width = 376
  Height = 330
  Caption = 'FutureValueCalculatorFP_2012'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object CancelBtn: TBitBtn
    Left = 192
    Top = 248
    Width = 89
    Height = 33
    Caption = 'Exit'
    TabOrder = 0
    Kind = bkCancel
  end
  object CalcBtn: TBitBtn
    Left = 80
    Top = 248
    Width = 89
    Height = 33
    Caption = 'Calc'
    TabOrder = 1
    OnClick = CalcBtnClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 368
    Height = 41
    Align = alTop
    Caption = 'Future Value Calculator'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 40
    Top = 56
    Width = 281
    Height = 177
    BevelOuter = bvLowered
    TabOrder = 3
    object Label2: TLabel
      Left = 69
      Top = 16
      Width = 60
      Height = 15
      Caption = 'Amount ($)'
    end
    object Label3: TLabel
      Left = 77
      Top = 80
      Width = 41
      Height = 15
      Caption = 'Interest'
    end
    object Label4: TLabel
      Left = 29
      Top = 48
      Width = 91
      Height = 15
      Caption = 'Number of years'
    end
    object Label5: TLabel
      Left = 24
      Top = 128
      Width = 93
      Height = 16
      Caption = 'Future Value ($)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 197
      Top = 80
      Width = 11
      Height = 15
      Caption = '%'
    end
    object Bevel1: TBevel
      Left = 32
      Top = 104
      Width = 233
      Height = 9
      Shape = bsBottomLine
      Style = bsRaised
    end
    object AmountBox: TEdit
      Left = 145
      Top = 12
      Width = 96
      Height = 23
      TabOrder = 0
    end
    object YearsBox: TEdit
      Left = 145
      Top = 44
      Width = 48
      Height = 23
      TabOrder = 1
    end
    object InterestBox: TEdit
      Left = 145
      Top = 76
      Width = 48
      Height = 23
      TabOrder = 2
    end
    object FutValBox: TEdit
      Left = 145
      Top = 124
      Width = 96
      Height = 23
      TabOrder = 3
    end
  end
end
