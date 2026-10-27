object ImportTF_2026: TImportTF_2026
  Left = 130
  Top = 179
  Caption = 'Rollover from Last Year'
  ClientHeight = 373
  ClientWidth = 757
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object RetCntLabel: TLabel
    Left = 192
    Top = 40
    Width = 5
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 79
    Width = 81
    Height = 13
    Caption = 'Search Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object OKBtn: TBitBtn
    Left = 600
    Top = 79
    Width = 117
    Height = 33
    Caption = 'Rollover selected return'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 2
    WordWrap = True
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 608
    Top = 309
    Width = 109
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    Kind = bkClose
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 6
    OnClick = CancelBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 569
    Height = 65
    Caption = ' Data Directories (Tab after change)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 5
      Top = 16
      Width = 115
      Height = 14
      Caption = 'Last Year (import from) '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 305
      Top = 16
      Width = 102
      Height = 13
      Caption = 'This Year (import into)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Image1: TImage
      Left = 253
      Top = 36
      Width = 28
      Height = 21
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
    object LastYearDirBox: TEdit
      Left = 9
      Top = 36
      Width = 224
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'LastYearDirBox'
      OnExit = LastYearDirBoxExit
      OnKeyPress = LastYearDirBoxKeyPress
    end
    object ThisYearDirBox: TEdit
      Left = 307
      Top = 36
      Width = 222
      Height = 21
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'ThisYearDirBox'
    end
  end
  object FileListBox1: TFileListBox
    Left = 597
    Top = 24
    Width = 48
    Height = 40
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ItemHeight = 13
    Mask = '*.xyz'
    ParentFont = False
    TabOrder = 4
    Visible = False
  end
  object DosFileBtn: TBitBtn
    Left = 600
    Top = 118
    Width = 117
    Height = 35
    Caption = 'Rollover a known return (Account)...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    WordWrap = True
    OnClick = DosFileBtnClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 98
    Width = 569
    Height = 248
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Ms Sans Serif'
    TitleFont.Style = [fsBold]
    OnDblClick = DBGrid1DblClick
  end
  object BitBtn1: TBitBtn
    Left = 608
    Top = 270
    Width = 109
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Kind = bkHelp
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 7
    OnClick = BitBtn1Click
  end
  object SearchBox: TEdit
    Left = 104
    Top = 79
    Width = 73
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = SearchBoxChange
    OnKeyPress = SearchBoxKeyPress
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 375
    Top = 65532
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'Database=D:\VT\TF-2015\Data2'
      'ODBCDriver={Microsoft dBase Driver (*.dbf)}'
      'DriverID=ODBC')
    LoginPrompt = False
    Left = 445
    Top = 1
  end
  object Table1: TADTable
    IndexFieldNames = 'CORP_NAME'
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Clients'
    TableName = 'Clients'
    Left = 484
  end
end
