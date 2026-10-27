object Response: TResponse
  Left = 70
  Top = 127
  Caption = 'Process Responses'
  ClientHeight = 383
  ClientWidth = 607
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 24
    Width = 521
    Height = 329
    ItemHeight = 13
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 256
    Top = 360
    Width = 73
    Height = 25
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 504
  end
  object DataSource2: TDataSource
    DataSet = TransactionsTbl
    Left = 560
    Top = 104
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'AssetTypes'
    TableName = 'AssetTypes'
    Left = 404
    Top = 40
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 405
    Top = 81
  end
  object TransactionsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'AssetTypes'
    TableName = 'AssetTypes'
    Left = 556
    Top = 56
  end
end
