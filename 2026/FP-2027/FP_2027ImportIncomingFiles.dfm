object ImportIncomingFiles: TImportIncomingFiles
  Left = 310
  Top = 183
  Caption = 'ImportIncomingFiles'
  ClientHeight = 577
  ClientWidth = 667
  Color = 14933196
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 112
    Top = 40
    Width = 68
    Height = 15
    Caption = 'In-Box folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Image1: TImage
    Left = 176
    Top = 32
    Width = 41
    Height = 33
    Picture.Data = {
      07544269746D617076020000424D760200000000000076000000280000002000
      000020000000010004000000000000020000C40E0000C40E0000100000000000
      0000000000007F7F00007F7F7F00BFBFBF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000222222222222222222222222222222222222222222222200222222222222
      2222222222222222200200222222222222222222222222220023300022222222
      2222222222222220042333300022222222222222222222004423333330002222
      2222222222222004442333333330002222222222222200444423333333333000
      2222222222200444442333333333333000222222220044444422333332233333
      3000222220044444423422332432333333302222004444442343433243432333
      3330222004444442343434343434233333302200444444234343434333433233
      3330200444444234343434133434342233300044444423434343411233434344
      2230044444423434343411123434344444020444442343434341111233434444
      4022044442343434341111123434444402220444234343434111111123444440
      2222044233333434311111112334440022220423333333434111111112334031
      0222023333333333341111111123033110222003333333333311111111110001
      1102222003333333334111111111111111102222200333333334111111111111
      1111222222200333333341111111111111122222222220033333443031111111
      1122222222222220033344022222222112222222222222222003402222222221
      2222222222222222222002222222222222222222222222222222222222222222
      2222}
    Transparent = True
  end
  object Label2: TLabel
    Left = 112
    Top = 64
    Width = 77
    Height = 15
    Caption = 'Archive Folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object ProcessOneBtn: TBitBtn
    Left = 200
    Top = 432
    Width = 105
    Height = 33
    Caption = 'Process File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 264
    Top = 472
    Width = 129
    Height = 25
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 1
  end
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 667
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Import incoming files'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object FileListBox1: TFileListBox
    Left = 288
    Top = 104
    Width = 369
    Height = 305
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    Mask = 'xx.X'
    ParentFont = False
    TabOrder = 3
  end
  object InDirBox: TEdit
    Left = 224
    Top = 40
    Width = 249
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = 'InDirBox'
  end
  object Memo1: TMemo
    Left = 0
    Top = 368
    Width = 673
    Height = 17
    Color = 8454143
    Lines.Strings = (
      'M'
      'e'
      'm'
      'o'
      '1')
    TabOrder = 5
    Visible = False
  end
  object AllBtn: TBitBtn
    Left = 8
    Top = 432
    Width = 17
    Height = 33
    Caption = 'Process All files'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Visible = False
  end
  object ArchiveDirBox: TEdit
    Left = 224
    Top = 64
    Width = 249
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Text = 'ArchiveDirBox'
  end
  object ArchiveBtn: TBitBtn
    Left = 326
    Top = 432
    Width = 81
    Height = 33
    Caption = 'Archive File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object CopyToOutFilesBtn: TBitBtn
    Left = 432
    Top = 472
    Width = 41
    Height = 33
    Caption = 'Place copy in the out-mail box'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    Visible = False
  end
  object Memo2: TMemo
    Left = 8
    Top = 104
    Width = 273
    Height = 305
    Color = 14811135
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'File Types (Extension)'
      '======================================='
      'ORD = Order'
      'ORG = Organization (Agents/Branches)'
      'CLN  = Full Client File (with Transaction History)'
      'TRN  =  Transaction (normally with FS response)'
      'MFP  =   Mutual Funds Prices'
      ''
      'Files with 8 characters extension are FundServ files')
    ParentFont = False
    TabOrder = 10
  end
  object LongNameBtn: TBitBtn
    Left = 112
    Top = 472
    Width = 105
    Height = 33
    Caption = 'Long Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    Visible = False
  end
  object DataSource1: TDataSource
    DataSet = HeadOfficeTbl
    Left = 336
    Top = 256
  end
  object DataSource2: TDataSource
    DataSet = BranchOfficesTbl
    Left = 336
    Top = 288
  end
  object DataSource3: TDataSource
    DataSet = AgentsTbl
    Left = 344
    Top = 328
  end
  object DataSource4: TDataSource
    DataSet = AnyTable
    Left = 448
    Top = 256
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients')
    Left = 469
    Top = 185
  end
  object Accounts: TADTable
    Connection = FDConnection
    Left = 372
    Top = 152
  end
  object AnyTable: TADTable
    Connection = FDConnection
    Left = 420
    Top = 256
  end
  object HeadOfficeTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'HeadOffice'
    TableName = 'HeadOffice'
    Left = 300
    Top = 256
  end
  object BranchOfficesTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'BranchOffices'
    TableName = 'BranchOffices'
    Left = 300
    Top = 288
  end
  object AgentsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Agents'
    TableName = 'Agents'
    Left = 300
    Top = 328
  end
end
