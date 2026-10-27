object vtDataModule: TvtDataModule
  OldCreateOrder = False
  Height = 364
  Width = 625
  object FDPhysSQLiteDriverLink: TADPhysSQLiteDriverLink
    Left = 48
    Top = 32
  end
  object FDGUIxWaitCursor: TADGUIxWaitCursor
    Provider = 'Console'
    Left = 416
    Top = 272
  end
  object FDSQLiteSecurity: TADSQLiteSecurity
    DriverLink = FDPhysSQLiteDriverLink
    Left = 64
    Top = 112
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    Transaction = FDTransaction
    Left = 200
    Top = 64
  end
  object FDTransaction: TADTransaction
    Connection = FDConnection
    Left = 256
    Top = 72
  end
  object dlgOpen: TOpenDialog
    Left = 184
    Top = 224
  end
  object ADPhysODBCDriverLink1: TADPhysODBCDriverLink
    Left = 408
    Top = 56
  end
end
