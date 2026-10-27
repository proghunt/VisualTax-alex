object ProcessFsFunds: TProcessFsFunds
  Left = 147
  Top = 103
  Caption = 'Process FundServe Fund Data'
  ClientHeight = 491
  ClientWidth = 796
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
  object Image1: TImage
    Left = 440
    Top = 232
    Width = 25
    Height = 33
    Picture.Data = {
      07544269746D61707E010000424D7E0100000000000076000000280000001400
      0000160000000100040000000000080100000000000000000000100000000000
      000000000000000080000080000000808000800000008000800080800000C0C0
      C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00777777777777777777770000777777777777777777770000777777777707
      7777777700007777777777007777777700007777777777040777777700007777
      7777770440777777000077777777770444077777000077770000000444407777
      0000777704444444444407770000777704444444444440770000777704444444
      4444440700007777044444444444407700007777044444444444077700007777
      0000000444407777000077777777770444077777000077777777770440777777
      0000777777777704077777770000777777777700777777770000777777777707
      7777777700007777777777777777777700007777777777777777777700007777
      77777777777777770000}
  end
  object Label1: TLabel
    Left = 16
    Top = 40
    Width = 174
    Height = 13
    Caption = 'Enter FundServ Fund Setup (FD file):'
  end
  object Label2: TLabel
    Left = 32
    Top = 56
    Width = 153
    Height = 13
    Caption = '(Original file names start with FD)'
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 80
    Width = 433
    Height = 393
    Caption = 'Fund Data Setup file (From FundServ)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object StringGrid2: TStringGrid
      Left = 8
      Top = 48
      Width = 417
      Height = 329
      ColCount = 8
      DefaultRowHeight = 17
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object PreviewBtn: TBitBtn
      Left = 200
      Top = 16
      Width = 129
      Height = 25
      Caption = 'Preview FD file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 464
    Top = 80
    Width = 329
    Height = 393
    Caption = 'Update results'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object UpdateFundsBtn: TBitBtn
      Left = 72
      Top = 16
      Width = 177
      Height = 25
      Caption = 'Update the Mutual Funds DB'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object Memo1: TMemo
      Left = 8
      Top = 48
      Width = 297
      Height = 329
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object CancelBtn: TBitBtn
    Left = 672
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Mutual Fund update  (from FundServ FD file)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object FileBox: TEdit
    Left = 200
    Top = 48
    Width = 313
    Height = 21
    TabOrder = 4
  end
  object SelectDirBtn: TBitBtn
    Left = 520
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Select file...'
    TabOrder = 5
  end
  object DataSource1: TDataSource
    DataSet = MutualFundsTbl
    Left = 628
    Top = 41
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 589
    Top = 145
  end
  object MutualFundsTbl: TADTable
    Connection = FDConnection
    Left = 588
    Top = 56
  end
end
