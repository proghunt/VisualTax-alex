object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'AppMon Viewer'
  ClientHeight = 473
  ClientWidth = 1185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AppMonGrid: TDBGrid
    Left = 0
    Top = 118
    Width = 1185
    Height = 336
    Align = alClient
    DataSource = dsData
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = AppMonGridDrawColumnCell
    OnTitleClick = AppMonGridTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'AppName'
        Title.Caption = 'App Name'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AppKey'
        Title.Caption = 'App Key'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LicenseLevel'
        Title.Caption = 'License Level'
        Width = 92
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EventDate'
        Title.Caption = 'Event Date'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ComputerName'
        Title.Caption = 'Computer Name'
        Width = 104
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PreparerName'
        Title.Caption = 'Preparer Name'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PreparerAddress'
        Title.Caption = 'Preparer Address'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ReturnCount'
        Title.Caption = 'Return Count'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FileName'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EfileNumber'
        Title.Caption = 'Efile Number'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TaxationYear'
        Title.Caption = 'Taxation Year'
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AdditionalInfo'
        Title.Caption = 'Additional Info'
        Width = 200
        Visible = True
      end>
  end
  object pnlConnection: TPanel
    Left = 0
    Top = 0
    Width = 1185
    Height = 33
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 1146
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 71
      Height = 25
      Align = alLeft
      Caption = 'Choose DB File'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnOpen: TSpeedButton
      Left = 674
      Top = 7
      Width = 23
      Height = 22
      Action = actFileOpen
    end
    object btnConnect: TSpeedButton
      Left = 703
      Top = 7
      Width = 105
      Height = 22
      Action = actConnect
    end
    object btnMergeDatabases: TSpeedButton
      Left = 814
      Top = 7
      Width = 105
      Height = 22
      Action = actMergeDatabases
    end
    object edDBFile: TEdit
      Left = 82
      Top = 7
      Width = 591
      Height = 21
      TabOrder = 0
    end
  end
  object pnlFilter: TPanel
    Left = 0
    Top = 33
    Width = 1185
    Height = 85
    Align = alTop
    TabOrder = 2
    object Label2: TLabel
      Left = 4
      Top = 9
      Width = 50
      Height = 13
      Caption = 'Start Date'
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 172
      Top = 9
      Width = 44
      Height = 13
      Caption = 'End Date'
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 172
      Top = 59
      Width = 40
      Height = 13
      Caption = 'App Key'
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 4
      Top = 35
      Width = 49
      Height = 13
      Caption = 'App Name'
      Layout = tlCenter
    end
    object btnSearch: TSpeedButton
      Left = 639
      Top = 56
      Width = 72
      Height = 21
      Action = actSearch
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnAppMisuse: TSpeedButton
      Left = 766
      Top = 6
      Width = 225
      Height = 21
      Action = actAppMisuse
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnT2Summary: TSpeedButton
      Left = 766
      Top = 32
      Width = 225
      Height = 21
      Action = actT2Summary
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 172
      Top = 32
      Width = 161
      Height = 13
      Caption = 'Use for Appkey misuse detection:'
    end
    object deStart: TDateTimePicker
      Left = 62
      Top = 6
      Width = 97
      Height = 21
      Date = 43301.503888553240000000
      Time = 43301.503888553240000000
      TabOrder = 0
    end
    object deEnd: TDateTimePicker
      Left = 226
      Top = 6
      Width = 97
      Height = 21
      Date = 43301.503888553240000000
      Time = 43301.503888553240000000
      TabOrder = 1
    end
    object rbAll: TRadioButton
      Left = 336
      Top = 8
      Width = 33
      Height = 17
      Caption = 'All'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object rbKeyMisUse: TRadioButton
      Left = 384
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Appkey misuse'
      TabOrder = 3
    end
    object rbT2MisUse: TRadioButton
      Left = 487
      Top = 8
      Width = 146
      Height = 17
      Caption = 'T2 Limited version misuse'
      TabOrder = 4
    end
    object edKey: TEdit
      Left = 226
      Top = 56
      Width = 407
      Height = 21
      TabOrder = 5
    end
    object cbApp: TComboBox
      Left = 62
      Top = 32
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 6
      Text = '< ALL >'
      Items.Strings = (
        '< ALL >')
    end
    object cbPrintEfiler4: TCheckBox
      Left = 998
      Top = 8
      Width = 83
      Height = 17
      Caption = 'Print Efiler4'
      TabOrder = 7
    end
    object cbIgnoreEmptyValues: TCheckBox
      Left = 639
      Top = 31
      Width = 120
      Height = 17
      Caption = 'Ignore empty values'
      TabOrder = 8
    end
    object cbEfiler: TCheckBox
      Left = 340
      Top = 31
      Width = 81
      Height = 17
      Caption = 'Efiler Number'
      TabOrder = 9
    end
    object cbPreparerName: TCheckBox
      Left = 429
      Top = 31
      Width = 91
      Height = 17
      Caption = 'Preparer Name'
      TabOrder = 10
    end
    object cbPreparerAddress: TCheckBox
      Left = 530
      Top = 31
      Width = 105
      Height = 17
      Caption = 'Preparer Address'
      TabOrder = 11
    end
    object cbPrintToExcel: TCheckBox
      Left = 1083
      Top = 8
      Width = 83
      Height = 17
      Caption = 'Print to Excel'
      TabOrder = 12
    end
  end
  object sbAppMon: TStatusBar
    Left = 0
    Top = 454
    Width = 1185
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 50
      end>
    ExplicitWidth = 1146
  end
  object ActionList: TActionList
    Left = 24
    Top = 144
    object actFileOpen: TAction
      Caption = '..'
      OnExecute = actFileOpenExecute
    end
    object actConnect: TAction
      Caption = 'Connect'
      OnExecute = actConnectExecute
    end
    object actSearch: TAction
      Caption = 'Search'
      OnExecute = actSearchExecute
    end
    object actMergeDatabases: TAction
      Caption = 'Merge Databases'
      OnExecute = actMergeDatabasesExecute
    end
    object actAppMisuse: TAction
      Caption = 'App Key Misuse Summary report'
      OnExecute = actAppMisuseExecute
    end
    object actT2Summary: TAction
      Caption = 'T2 summary report for the Limited version'
      OnExecute = actT2SummaryExecute
    end
  end
  object OpenDBDialog: TOpenDialog
    Filter = 'Database Files (*.db)|*.db|All Files (*.*)|*.*'
    Left = 472
    Top = 105
  end
  object FConnection: TADConnection
    Params.Strings = (
      'Database=Z:\VisualTax_Data\Temp\PHP\Recent.db'
      'DriverID=SQLite')
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    LoginPrompt = False
    AfterConnect = FConnectionAfterConnect
    AfterDisconnect = FConnectionAfterConnect
    Left = 632
    Top = 136
  end
  object QData: TADQuery
    AfterScroll = QDataAfterScroll
    Connection = FConnection
    SQL.Strings = (
      'SELECT * FROM SaveLog '
      'ORDER BY !SORTFIELD !SORTORDER')
    Left = 632
    Top = 184
    MacroData = <
      item
        Value = Null
        Name = 'SORTFIELD'
      end
      item
        Value = Null
        Name = 'SORTORDER'
      end>
    object QDataId: TADAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QDataAppName: TStringField
      FieldName = 'AppName'
      Origin = 'AppName'
      Size = 10
    end
    object QDataAppKey: TStringField
      FieldName = 'AppKey'
      Origin = 'AppKey'
      Size = 19
    end
    object QDataLicenseLevel: TStringField
      FieldName = 'LicenseLevel'
      Origin = 'LicenseLevel'
      Size = 255
    end
    object QDataReturnCountLimited: TBooleanField
      FieldName = 'ReturnCountLimited'
      Origin = 'ReturnCountLimited'
    end
    object QDataMaxReturnCount: TStringField
      FieldName = 'MaxReturnCount'
      Origin = 'MaxReturnCount'
      Size = 255
    end
    object QDataEventDate: TDateTimeField
      FieldName = 'EventDate'
      Origin = 'EventDate'
    end
    object QDataComputerName: TStringField
      FieldName = 'ComputerName'
      Origin = 'ComputerName'
      Size = 255
    end
    object QDataPreparerName: TStringField
      FieldName = 'PreparerName'
      Origin = 'PreparerName'
      Size = 255
    end
    object QDataPreparerAddress: TStringField
      FieldName = 'PreparerAddress'
      Origin = 'PreparerAddress'
      Size = 255
    end
    object QDataReturnCount: TIntegerField
      FieldName = 'ReturnCount'
      Origin = 'ReturnCount'
    end
    object QDataFileName: TStringField
      FieldName = 'FileName'
      Origin = 'FileName'
      Size = 255
    end
    object QDataEfileNumber: TStringField
      FieldName = 'EfileNumber'
      Origin = 'EfileNumber'
    end
    object QDataTaxationYear: TStringField
      FieldName = 'TaxationYear'
      Origin = 'TaxationYear'
    end
    object QDataAdditionalInfo: TStringField
      FieldName = 'AdditionalInfo'
      Origin = 'AdditionalInfo'
      Size = 500
    end
  end
  object FDPhysSQLiteDriverLink1: TADPhysSQLiteDriverLink
    Left = 1048
    Top = 232
  end
  object QApp: TADQuery
    Connection = FConnection
    SQL.Strings = (
      'SELECT DISTINCT AppName '
      'FROM SaveLog'
      'WHERE AppName <> '#39#39
      'ORDER BY AppName')
    Left = 696
    Top = 185
  end
  object FDGUIxWaitCursor1: TADGUIxWaitCursor
    Provider = 'Forms'
    Left = 1048
    Top = 185
  end
  object dsData: TDataSource
    AutoEdit = False
    DataSet = QData
    Left = 632
    Top = 232
  end
  object SaveDBDialog: TSaveDialog
    DefaultExt = '*.db'
    Filter = 'Database Files (*.db)|*.db|All Files (*.*)|*.*'
    Title = 'Save Merged Database as'
    Left = 472
    Top = 160
  end
  object SaveReportDialog: TSaveDialog
    DefaultExt = '*.txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 472
    Top = 216
  end
  object QAppKeyMisuseReport: TADQuery
    Connection = FConnection
    ResourceOptions.AssignedValues = [rvParamCreate, rvParamExpand]
    ResourceOptions.ParamCreate = False
    ResourceOptions.ParamExpand = False
    SQL.Strings = (
      'SELECT '
      '    AppName, '
      '    S.AppKey, '
      '    REPLACE(LicenseLevel, '#39'Limited'#39', '#39'Lim.'#39') AS LicenseLevel, '
      '    strftime("%Y-%m-%d %H:%M", MIN(EventDate)) AS StartDate,  '
      '    strftime("%Y-%m-%d %H:%M", MAX(EventDate)) AS EndDate,'
      '    C1.Efiler AS Efiler1, '
      '    C2.Efiler AS Efiler2, '
      '    C3.Efiler AS Efiler3, '
      '    C4.Efiler AS Efiler4 '
      'FROM SaveLog S'
      
        '    LEFT JOIN AppMisuse C1 ON C1.AppKey = S.AppKey AND C1.SeqNo ' +
        '= 1'
      
        '    LEFT JOIN AppMisuse C2 ON C2.AppKey = S.AppKey AND C2.SeqNo ' +
        '= 2'
      
        '    LEFT JOIN AppMisuse C3 ON C3.AppKey = S.AppKey AND C3.SeqNo ' +
        '= 3'
      
        '    LEFT JOIN AppMisuse C4 ON C4.AppKey = S.AppKey AND C4.SeqNo ' +
        '= 4'
      'WHERE S.AppKey IN '
      '         ( '
      '           SELECT S.AppKey '
      '           FROM SaveLog S '
      '           GROUP BY S.AppKey '
      '           HAVING !MisUseFilter'
      '         )'
      'GROUP BY AppName, S.AppKey, LicenseLevel         '
      'ORDER BY S.AppKey')
    Left = 456
    Top = 329
    MacroData = <
      item
        Value = Null
        Name = 'MISUSEFILTER'
      end>
  end
  object QT2LimitedReport: TADQuery
    Connection = FConnection
    ResourceOptions.AssignedValues = [rvParamCreate, rvParamExpand]
    ResourceOptions.ParamCreate = False
    ResourceOptions.ParamExpand = False
    SQL.Strings = (
      'SELECT '
      '    AppName, '
      '    S.AppKey, '
      '    REPLACE(LicenseLevel, '#39'Limited'#39', '#39'Lim.'#39') AS LicenseLevel, '
      '    strftime("%Y-%m-%d %H:%M", MIN(EventDate)) AS StartDate,  '
      '    strftime("%Y-%m-%d %H:%M", MAX(EventDate)) AS EndDate,'
      '    C1.Efiler AS Efiler1, '
      '    C2.Efiler AS Efiler2, '
      '    C3.Efiler AS Efiler3, '
      '    C4.Efiler AS Efiler4 '
      'FROM SaveLog S'
      
        '    LEFT JOIN AppMisuse C1 ON C1.AppKey = S.AppKey AND C1.SeqNo ' +
        '= 1'
      
        '    LEFT JOIN AppMisuse C2 ON C2.AppKey = S.AppKey AND C2.SeqNo ' +
        '= 2'
      
        '    LEFT JOIN AppMisuse C3 ON C3.AppKey = S.AppKey AND C3.SeqNo ' +
        '= 3'
      
        '    LEFT JOIN AppMisuse C4 ON C4.AppKey = S.AppKey AND C4.SeqNo ' +
        '= 4'
      'WHERE S.AppKey IN '
      '         ( '
      '           SELECT S.AppKey '
      '           FROM SaveLog S '
      '           WHERE ReturnCountLimited = 1'
      '           GROUP BY S.AppKey '
      '           HAVING COUNT(DISTINCT S.FileName) > MaxReturnCount '
      '         )'
      'GROUP BY AppName, S.AppKey, LicenseLevel         '
      'ORDER BY S.AppKey')
    Left = 456
    Top = 385
  end
  object SaveXlsReportDialog: TSaveDialog
    DefaultExt = '*.xls'
    Filter = 'Excel files (*.xls, *xlsx)|*.xls;*.xlsx|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 472
    Top = 264
  end
  object QAppKeys: TADQuery
    Connection = FConnection
    ResourceOptions.AssignedValues = [rvParamCreate, rvParamExpand]
    ResourceOptions.ParamCreate = False
    ResourceOptions.ParamExpand = False
    SQL.Strings = (
      'SELECT DISTINCT AppKey    '
      'FROM SaveLog'
      '')
    Left = 632
    Top = 289
  end
end
