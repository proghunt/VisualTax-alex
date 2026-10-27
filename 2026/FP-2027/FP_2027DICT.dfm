object DataDictFP_2012: TDataDictFP_2012
  Left = 185
  Top = 158
  Caption = 'Data Dictionary'
  ClientHeight = 350
  ClientWidth = 509
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 16
    Top = 8
    Width = 489
    Height = 273
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Ms Sans Serif'
    TitleFont.Style = [fsBold]
  end
  object DBNavigator1: TDBNavigator
    Left = 16
    Top = 280
    Width = 490
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit]
    TabOrder = 1
  end
  object SaveBtn: TBitBtn
    Left = 173
    Top = 313
    Width = 89
    Height = 33
    Caption = 'Save'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = SaveBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 285
    Top = 313
    Width = 89
    Height = 33
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object DataSource1: TDataSource
    Left = 47
    Top = 322
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=C:\fp\DataDict.DB')
    Left = 81
    Top = 305
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'DataDict'
    TableName = 'DataDict'
    Left = 120
    Top = 304
  end
end
