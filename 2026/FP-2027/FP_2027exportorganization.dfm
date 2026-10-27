object ExportOrganizationFP_2012: TExportOrganizationFP_2012
  Left = 103
  Top = 59
  BorderStyle = bsDialog
  Caption = 'Export Organization'
  ClientHeight = 476
  ClientWidth = 587
  Color = 14933196
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 408
    Top = 184
    Width = 114
    Height = 15
    Caption = 'Destination Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 440
    Top = 256
    Width = 57
    Height = 15
    Caption = 'File Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 64
    Top = 48
    Width = 479
    Height = 16
    Caption = 
      'This facility exports the Head Office, Branch and Agent Configur' +
      'ation data.'
  end
  object Label2: TLabel
    Left = 24
    Top = 88
    Width = 342
    Height = 16
    Caption = 'Click on Branch to be exported (one branch at a time)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 587
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Export Organization Structure '
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 496
    Top = 352
    Width = 73
    Height = 31
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Kind = bkCancel
    Margin = 2
    NumGlyphs = 2
    ParentFont = False
    Spacing = -1
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object OKBtn: TBitBtn
    Left = 400
    Top = 352
    Width = 73
    Height = 33
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object FilesOutBox: TEdit
    Left = 384
    Top = 200
    Width = 193
    Height = 23
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object FlNameBox: TEdit
    Left = 384
    Top = 272
    Width = 193
    Height = 23
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object DBGrid1: TDBGrid
    Left = 32
    Top = 104
    Width = 329
    Height = 353
    DataSource = DataSource2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Arial'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Branch'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BranchName'
        Width = 236
        Visible = True
      end>
  end
  object DataSource1: TDataSource
    DataSet = HeadOfficeTbl
    Left = 312
    Top = 216
  end
  object DataSource2: TDataSource
    DataSet = BranchOfficesTbl
    Left = 304
    Top = 264
  end
  object DataSource3: TDataSource
    DataSet = AgentsTbl
    Left = 304
    Top = 304
  end
  object hFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      '')
    Left = 213
    Top = 217
  end
  object HeadOfficeTbl: TADTable
    Connection = hFDConnection
    UpdateOptions.UpdateTableName = 'HeadOffice'
    TableName = 'HeadOffice'
    Left = 260
    Top = 216
  end
  object bFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      '')
    Left = 213
    Top = 265
  end
  object BranchOfficesTbl: TADTable
    Connection = bFDConnection
    UpdateOptions.UpdateTableName = 'BranchOffices'
    TableName = 'BranchOffices'
    Left = 260
    Top = 264
  end
  object aFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      '')
    Left = 213
    Top = 313
  end
  object AgentsTbl: TADTable
    Connection = aFDConnection
    UpdateOptions.UpdateTableName = 'Agents'
    TableName = 'Agents'
    Left = 260
    Top = 312
  end
end
