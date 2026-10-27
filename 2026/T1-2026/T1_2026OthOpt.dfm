object OthOptT1_2026: TOthOptT1_2026
  Left = 356
  Top = 123
  Caption = 'Other Options'
  ClientHeight = 372
  ClientWidth = 652
  Color = 13353654
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 176
    Top = 32
    Width = 265
    Height = 15
    Caption = 'Enter Y or N (or 1,2,3) as indicated (Position 30)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 120
    Top = 56
    Width = 397
    Height = 15
    Caption = 
      '***  Any changed options will take effect after closing the tax ' +
      'return ***'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 16
    Top = 72
    Width = 609
    Height = 233
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyPress = Memo1KeyPress
  end
  object SaveBtn: TBitBtn
    Left = 264
    Top = 312
    Width = 65
    Height = 33
    Caption = 'Save'
    TabOrder = 1
    OnClick = SaveBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 352
    Top = 312
    Width = 65
    Height = 33
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 652
    Height = 25
    Align = alTop
    Caption = 'Other Options'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
end
