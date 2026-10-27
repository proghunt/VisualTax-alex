object FSErrors: TFSErrors
  Left = 153
  Top = 142
  Width = 503
  Height = 470
  Caption = 'FSErrors'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object CancelBtn: TBitBtn
    Left = 224
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 33
    Width = 495
    Height = 360
    Align = alTop
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 495
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'FundServ Error Codes'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object DataSource1: TDataSource
    Left = 176
    Top = 72
  end
end
