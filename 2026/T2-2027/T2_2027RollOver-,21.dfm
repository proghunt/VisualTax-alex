object RolloverT2_2027: TRolloverT2_2027
  Left = 401
  Top = 182
  Caption = 'RolloverT2_2027'
  ClientHeight = 643
  ClientWidth = 923
  Color = clSilver
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
    Top = 168
    Width = 5
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 923
    Height = 22
    Align = alTop
    Shape = bsBottomLine
    ExplicitTop = 616
    ExplicitWidth = 888
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 80
    Width = 517
    Height = 509
    Caption = 'FILES'
    TabOrder = 0
    object Label2: TLabel
      Left = 24
      Top = 28
      Width = 81
      Height = 13
      Caption = 'Search Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBGrid1: TDBGrid
      Left = 8
      Top = 56
      Width = 497
      Height = 442
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'Ms Sans Serif'
      TitleFont.Style = [fsBold]
      OnDblClick = DBGrid1DblClick
    end
    object SearchBox: TEdit
      Left = 128
      Top = 25
      Width = 118
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
  object GroupBox3: TGroupBox
    Left = 556
    Top = 71
    Width = 225
    Height = 518
    Caption = 'OPTIONS'
    TabOrder = 2
    object Label1: TLabel
      Left = 5
      Top = 48
      Width = 231
      Height = 15
      Caption = 'Last Year (import from)  A: or B: acceptable'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 9
      Top = 152
      Width = 108
      Height = 13
      Caption = 'This Year (rollover into)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 5
      Top = 32
      Width = 76
      Height = 15
      Caption = '(From Config)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LastYearDirBox: TEdit
      Left = 9
      Top = 68
      Width = 208
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'LastYearDirBox'
      OnExit = LastYearDirBoxExit
      OnKeyPress = LastYearDirBoxKeyPress
    end
    object ThisYearDirBox: TEdit
      Left = 11
      Top = 172
      Width = 206
      Height = 21
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'ThisYearDirBox'
    end
    object SelectDirBtn1: TBitBtn
      Left = 112
      Top = 95
      Width = 49
      Height = 25
      Caption = 'Select...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = SelectDirBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 112
      Top = 199
      Width = 49
      Height = 25
      Caption = 'Select...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = BitBtn2Click
    end
  end
  object GroupBox4: TGroupBox
    Left = 805
    Top = 71
    Width = 97
    Height = 518
    Caption = 'ACTIONS'
    TabOrder = 1
    object OKBtn: TBitBtn
      Left = 8
      Top = 56
      Width = 81
      Height = 33
      Caption = 'Roll-over'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 1
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 8
      Top = 232
      Width = 81
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      Kind = bkClose
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object HelpBtn: TBitBtn
      Left = 8
      Top = 136
      Width = 81
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = HelpBtnClick
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 175
    Top = 356
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=E:\delphi\t2\data\Clients.db')
    Left = 247
    Top = 306
  end
  object Table1: TADTable
    OnFilterRecord = Table1FilterRecord
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'CLIENTS'
    TableName = 'CLIENTS'
    Left = 167
    Top = 307
  end
  object ADMemTable1: TADMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 264
    Top = 384
  end
end
