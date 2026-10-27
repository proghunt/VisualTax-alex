object ImportFSFiles72FP_2012: TImportFSFiles72FP_2012
  Left = 74
  Top = 48
  Caption = 'Fund Serve - Incoming Files'
  ClientHeight = 506
  ClientWidth = 733
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object FileTypeBox: TRadioGroup
    Left = 0
    Top = 120
    Width = 161
    Height = 209
    Caption = 'File type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'ALL'
      'Rejected Orders'
      'Daily Prices'
      'Reconc'#39'n files'
      'Settlements'
      'ZIP files'
      'History'
      'Account Reconciliation')
    ParentFont = False
    TabOrder = 0
    OnClick = FileTypeBoxClick
  end
  object GroupBox1: TGroupBox
    Left = 160
    Top = 74
    Width = 573
    Height = 374
    Align = alRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object StringGrid1: TStringGrid
      Left = 9
      Top = 16
      Width = 561
      Height = 329
      Hint = 'Double click to Preview file'
      DefaultRowHeight = 17
      FixedColor = 10930928
      FixedCols = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = StringGrid1DblClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 733
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Import FundServe files (Version 7.2)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 733
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 3
    object Label1: TLabel
      Left = 21
      Top = 19
      Width = 48
      Height = 14
      Caption = 'In Folder'
    end
    object Label2: TLabel
      Left = 317
      Top = 19
      Width = 80
      Height = 14
      Caption = 'Archive Folder'
    end
    object DataDirBox: TEdit
      Left = 81
      Top = 11
      Width = 216
      Height = 22
      Enabled = False
      TabOrder = 0
      Text = 'DataDirBox'
      OnExit = DataDirBoxExit
    end
    object ArchiveDirBox: TEdit
      Left = 409
      Top = 11
      Width = 216
      Height = 22
      Enabled = False
      TabOrder = 1
      Text = 'ArchiveDirBox'
      OnExit = DataDirBoxExit
    end
    object FileListBox1: TFileListBox
      Left = 640
      Top = 16
      Width = 41
      Height = 17
      ItemHeight = 14
      Mask = 'xx*.*'
      TabOrder = 2
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 448
    Width = 733
    Height = 58
    Align = alBottom
    TabOrder = 4
    object CancelBtn: TBitBtn
      Left = 584
      Top = 16
      Width = 81
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object ProcessAllBtn: TBitBtn
      Left = 144
      Top = 16
      Width = 89
      Height = 33
      Caption = 'Process All'
      Enabled = False
      TabOrder = 1
      OnClick = ProcessAllBtnClick
    end
    object ProcessFileBtn: TBitBtn
      Left = 24
      Top = 16
      Width = 89
      Height = 33
      Caption = 'Process File'
      TabOrder = 2
      OnClick = ProcessFileBtnClick
    end
    object ArchiveBtn: TBitBtn
      Left = 272
      Top = 16
      Width = 81
      Height = 33
      Caption = 'Archive File'
      TabOrder = 3
      OnClick = ArchiveBtnClick
    end
    object ArchiveAllBtn: TBitBtn
      Left = 384
      Top = 16
      Width = 81
      Height = 33
      Caption = 'Archive all'
      Enabled = False
      TabOrder = 4
    end
  end
  object DataSource2: TDataSource
    DataSet = SuppliersTbl
    Left = 472
    Top = 208
  end
  object OpenDialog1: TOpenDialog
    Left = 344
    Top = 104
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients')
    Left = 325
    Top = 209
  end
  object SuppliersTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Suppliers'
    TableName = 'Suppliers'
    Left = 380
    Top = 208
  end
end
