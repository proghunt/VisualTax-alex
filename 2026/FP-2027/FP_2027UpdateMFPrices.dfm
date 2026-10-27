object UpdateMFPrices: TUpdateMFPrices
  Left = 104
  Top = 290
  Width = 733
  Height = 507
  Caption = 'UpdateMFPrices'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object UpdateBtn: TBitBtn
    Left = 232
    Top = 432
    Width = 201
    Height = 33
    Caption = 'Update Fund Names and Prices'
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 576
    Top = 432
    Width = 75
    Height = 33
    TabOrder = 1
    Kind = bkCancel
  end
  object DBGrid4: TDBGrid
    Left = 8
    Top = 0
    Width = 705
    Height = 417
    DataSource = MutualFundsSrc
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object RebuildBtn: TBitBtn
    Left = 56
    Top = 431
    Width = 153
    Height = 33
    Caption = 'Rebuild the Data Base'
    TabOrder = 3
  end
  object DuplicatesBtn: TBitBtn
    Left = 464
    Top = 432
    Width = 75
    Height = 33
    Caption = 'Duplicates'
    TabOrder = 4
  end
  object PricingInfoSrc: TDataSource
    Left = 72
    Top = 64
  end
  object FundInfoSrc: TDataSource
    Left = 216
    Top = 72
  end
  object TradingCodeScr: TDataSource
    Left = 320
    Top = 72
  end
  object MutualFundsSrc: TDataSource
    Left = 208
    Top = 16
  end
end
