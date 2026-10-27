object PostPrices: TPostPrices
  Left = 179
  Top = 77
  Width = 527
  Height = 448
  Caption = 'PostPrices'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 442
    Height = 32
    Caption = 
      'This process will update the balance sheet of all clients with t' +
      'he latest prices from the Mutual Funds Data Base.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 216
    Top = 72
    Width = 65
    Height = 16
    Caption = 'Error Log'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16512
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 519
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Post Latest Fund Prices'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object OKBtn: TBitBtn
    Left = 160
    Top = 384
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
  end
  object CancelBtn: TBitBtn
    Left = 280
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    Kind = bkCancel
  end
  object ListBox1: TListBox
    Left = 64
    Top = 88
    Width = 385
    Height = 289
    ItemHeight = 13
    TabOrder = 3
  end
  object AssetsSrc: TDataSource
    Left = 248
    Top = 128
  end
  object DataSource2: TDataSource
    Left = 248
    Top = 168
  end
end
