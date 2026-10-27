object dmData: TdmData
  OldCreateOrder = False
  Height = 419
  Width = 759
  object ADGUIxWaitCursor1: TADGUIxWaitCursor
    Left = 336
    Top = 16
  end
  object ADPhysSQLiteDriverLink1: TADPhysSQLiteDriverLink
    Left = 456
    Top = 17
  end
  object MainConn: TADConnection
    Params.Strings = (
      'Database=..\bin\TRTOC.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    Left = 16
    Top = 16
  end
  object QTitles: TADQuery
    Connection = MainConn
    SQL.Strings = (
      'SELECT * FROM Titles'
      'ORDER BY NULLIF(ParentTitleId, 0), SeqNo')
    Left = 16
    Top = 104
  end
  object QURLs: TADQuery
    Connection = MainConn
    SQL.Strings = (
      'SELECT * FROM URLs'
      'WHERE ParentTitleId = :TitleId'
      'ORDER BY SeqNo')
    Left = 64
    Top = 104
    ParamData = <
      item
        Name = 'TITLEID'
        ParamType = ptInput
      end>
    object QURLsId: TADAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QURLsCaption: TStringField
      FieldName = 'Caption'
      Origin = 'Caption'
      Size = 255
    end
    object QURLsURL: TStringField
      FieldName = 'URL'
      Origin = 'URL'
      Size = 4000
    end
    object QURLsParentTitleId: TIntegerField
      FieldName = 'ParentTitleId'
      Origin = 'ParentTitleId'
    end
    object QURLsSeqNo: TIntegerField
      FieldName = 'SeqNo'
      Origin = 'SeqNo'
    end
  end
  object dsURLs: TDataSource
    AutoEdit = False
    DataSet = QURLs
    Left = 64
    Top = 152
  end
end
