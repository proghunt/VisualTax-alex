object dmMain: TdmMain
  OldCreateOrder = False
  Height = 245
  Width = 378
  object FConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 40
    Top = 14
  end
  object ADPhysSQLiteDriverLink1: TADPhysSQLiteDriverLink
    Left = 40
    Top = 174
  end
  object ADGUIxWaitCursor1: TADGUIxWaitCursor
    Left = 168
    Top = 174
  end
  object FLastYearConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 160
    Top = 14
  end
end
