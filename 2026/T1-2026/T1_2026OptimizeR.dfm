object OptimizeRT1_2026: TOptimizeRT1_2026
  Left = 410
  Top = 309
  Caption = 'Optimize Results'
  ClientHeight = 250
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 28
    Top = 42
    Width = 115
    Height = 16
    Caption = 'Before this optimize'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 56
    Top = 70
    Width = 83
    Height = 16
    Caption = 'After Optimize'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 70
    Top = 98
    Width = 69
    Height = 16
    Caption = 'Tax Savings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object vtShape6: TvtShape
    Left = 0
    Top = 0
    Width = 367
    Height = 22
    Align = alTop
    Brush.Color = 11301888
    GradientColor = clBlack
    FillDirection = vtUpFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = ''
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtIsPrintable = True
  end
  object vtLabel1: TvtLabel
    Left = 28
    Top = 0
    Width = 266
    Height = 19
    Caption = 'Optimized Family Payable (Refund)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object Bevel1: TBevel
    Left = 147
    Top = 91
    Width = 99
    Height = 8
    Shape = bsTopLine
  end
  object CancelBtn: TBitBtn
    Left = 147
    Top = 133
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 0
    OnClick = CancelBtnClick
  end
  object PayBefore: TEdit
    Left = 147
    Top = 35
    Width = 99
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object PayAfter: TEdit
    Left = 147
    Top = 63
    Width = 99
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object TaxSavings: TEdit
    Left = 147
    Top = 98
    Width = 99
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
end
