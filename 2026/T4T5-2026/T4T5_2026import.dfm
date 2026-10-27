object ImportT4T5_2026: TImportT4T5_2026
  Left = 130
  Top = 179
  Caption = 'Rollover from Last Year'
  ClientHeight = 503
  ClientWidth = 736
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 736
    Height = 120
    Align = alTop
    Caption = ' Data Directories (Tab after change)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
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
    object OverrideOption: TRadioGroup
      Left = 3
      Top = 63
      Width = 569
      Height = 41
      Caption = 'Options (when importing All)'
      Color = clBtnFace
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'DO NOT replace already prepared 2025 tax returns'
        'Replace already prepared 2025 tax returns')
      ParentColor = False
      ParentFont = False
      TabOrder = 2
    end
  end
  object grClient: TDBGrid
    Left = 0
    Top = 151
    Width = 491
    Height = 352
    Align = alClient
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Ms Sans Serif'
    TitleFont.Style = [fsBold]
    OnDblClick = grClientDblClick
  end
  object pnlSearch: TPanel
    Left = 0
    Top = 120
    Width = 736
    Height = 31
    Align = alTop
    TabOrder = 3
    object Label2: TLabel
      Left = 7
      Top = 6
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
    object SearchBox: TEdit
      Left = 104
      Top = 3
      Width = 289
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
  end
  object pnlTools: TPanel
    Left = 491
    Top = 151
    Width = 245
    Height = 352
    Align = alRight
    TabOrder = 2
    object BitBtn1: TBitBtn
      Left = 16
      Top = 151
      Width = 181
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object CancelBtn: TBitBtn
      Left = 16
      Top = 190
      Width = 181
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      Kind = bkClose
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object DosFileBtn: TBitBtn
      Left = 161
      Top = 46
      Width = 9
      Height = 33
      Caption = 'Rollover a known return (Account)...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = DosFileBtnClick
    end
    object OKBtn: TBitBtn
      Left = 16
      Top = 7
      Width = 181
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
      TabOrder = 3
      OnClick = OKBtnClick
    end
    object btnRolloverAll: TBitBtn
      Left = 16
      Top = 87
      Width = 181
      Height = 33
      Caption = 'Rollover ALL returns'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 1
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 4
      OnClick = btnRolloverAllClick
    end
  end
  object DataSource1: TDataSource
    DataSet = tblClient
    Left = 375
    Top = 65532
  end
  object conClient: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=C:\T4T5-2017\Data\CLIENTS.db')
    Left = 109
    Top = 145
  end
  object tblClient: TADTable
    Connection = conClient
    UpdateOptions.UpdateTableName = 'Clients'
    TableName = 'Clients'
    Left = 108
    Top = 192
  end
end
