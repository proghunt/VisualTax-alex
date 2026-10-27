object TablesF: TTablesF
  Left = 81
  Top = 67
  Caption = 'DB Viewer'
  ClientHeight = 0
  ClientWidth = 121
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 137
    Top = 49
    Width = 4
    Height = 0
    Color = clRed
    ParentColor = False
    ExplicitHeight = 514
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 121
    Height = 49
    Align = alTop
    Color = 13880237
    TabOrder = 0
    ExplicitWidth = 104
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 57
      Height = 15
      Caption = '&Database:'
      FocusControl = ComboBox1
    end
    object SelectColumnsBtn: TSpeedButton
      Left = 536
      Top = 8
      Width = 113
      Height = 33
      Caption = 'Select Columns...'
      Visible = False
      OnClick = SelectColumnsBtnClick
    end
    object PrintLayoutBtn: TSpeedButton
      Left = 648
      Top = 8
      Width = 121
      Height = 33
      Caption = 'Print Table Layout...'
      Visible = False
      OnClick = PrintLayoutBtnClick
    end
    object ReportBtn: TSpeedButton
      Left = 448
      Top = 8
      Width = 89
      Height = 33
      Caption = 'Table Report'
      Visible = False
      OnClick = ReportBtnClick
    end
    object ComboBox1: TComboBox
      Left = 69
      Top = 13
      Width = 276
      Height = 24
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object ConnectBtn: TBitBtn
      Left = 376
      Top = 8
      Width = 75
      Height = 33
      Caption = 'Connect'
      TabOrder = 1
      OnClick = ConnectBtnClick
    end
  end
  object PageControl1: TPageControl
    Left = 141
    Top = 49
    Width = 7
    Height = 0
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 1
    OnChange = PageControl1Change
    ExplicitWidth = 663
    ExplicitHeight = 514
    object TabSheet1: TTabSheet
      Caption = 'Data View'
      ExplicitWidth = 564
      ExplicitHeight = 285
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 10
        Height = 3
        Align = alClient
        Color = 15663103
        DataSource = DataSource1
        FixedColor = 13880237
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = -24
        Width = 200
        Height = 25
        DataSource = DataSource1
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 260
        ExplicitWidth = 564
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'SQL view'
      ImageIndex = 1
      ExplicitWidth = 655
      ExplicitHeight = 484
      object Splitter2: TSplitter
        Left = 0
        Top = 105
        Width = 10
        Height = 3
        Cursor = crVSplit
        Align = alTop
        Color = clRed
        ParentColor = False
        ExplicitWidth = 655
      end
      object Splitter3: TSplitter
        Left = 0
        Top = 417
        Width = 10
        Height = 3
        Cursor = crVSplit
        Align = alTop
        Color = clRed
        ParentColor = False
        ExplicitWidth = 655
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 10
        Height = 105
        Align = alTop
        Caption = 'SQL'
        Color = 13880237
        ParentColor = False
        TabOrder = 0
        ExplicitWidth = 655
        object Memo1: TMemo
          Left = 161
          Top = 17
          Width = 11
          Height = 86
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitWidth = 492
        end
        object Panel4: TPanel
          Left = 2
          Top = 17
          Width = 159
          Height = 86
          Align = alLeft
          BevelOuter = bvNone
          Color = 13880237
          TabOrder = 1
          object RunBtn: TBitBtn
            Left = 64
            Top = 8
            Width = 89
            Height = 25
            Caption = 'Execute'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = RunBtnClick
          end
          object LoadBtn: TBitBtn
            Left = 8
            Top = 32
            Width = 51
            Height = 25
            Caption = 'Load...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = LoadBtnClick
          end
          object SaveBtn: TBitBtn
            Left = 8
            Top = 56
            Width = 51
            Height = 25
            Caption = 'Save...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = SaveBtnClick
          end
          object ClearBtn: TBitBtn
            Left = 8
            Top = 8
            Width = 51
            Height = 25
            Caption = 'Clear'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = ClearBtnClick
          end
          object RecviewBtn: TBitBtn
            Left = 64
            Top = 48
            Width = 89
            Height = 25
            Caption = 'Record View...'
            TabOrder = 4
            OnClick = RecviewBtnClick
          end
        end
      end
      object QueryGrid: TDBGrid
        Left = 0
        Top = 108
        Width = 10
        Height = 309
        Align = alTop
        Color = 15663103
        DataSource = QuerySource
        FixedColor = 13880237
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
      end
      object ErrorList: TMemo
        Left = 0
        Top = 420
        Width = 10
        Height = 64
        Align = alClient
        Color = 15724002
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8404992
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 2
        ExplicitWidth = 655
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Data Properties'
      ImageIndex = 2
      ExplicitWidth = 564
      ExplicitHeight = 285
      object StringGrid1: TStringGrid
        Left = 0
        Top = 0
        Width = 10
        Height = 1
        Align = alClient
        Color = 15400959
        DefaultRowHeight = 17
        FixedColor = 13880237
        FixedCols = 0
        RowCount = 30
        TabOrder = 0
        ExplicitWidth = 564
        ExplicitHeight = 285
        ColWidths = (
          210
          116
          80
          64
          64)
        RowHeights = (
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17)
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Table Indexes'
      ImageIndex = 3
      ExplicitWidth = 655
      ExplicitHeight = 484
      object IndexListBox: TListBox
        Left = 0
        Top = 0
        Width = 10
        Height = 1
        Align = alClient
        Color = 15532031
        ItemHeight = 15
        TabOrder = 0
        ExplicitWidth = 655
        ExplicitHeight = 484
      end
    end
  end
  object PageControl2: TPageControl
    Left = 0
    Top = 49
    Width = 137
    Height = 0
    ActivePage = TabSheet4
    Align = alLeft
    TabOrder = 2
    ExplicitHeight = 514
    object TabSheet4: TTabSheet
      Caption = 'Tables'
      ExplicitHeight = 484
      object ListBox1: TListBox
        Left = 0
        Top = 0
        Width = 129
        Height = 1
        Align = alClient
        Color = 15724002
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 0
        OnClick = ListBox1Click
        OnDblClick = ListBox1DblClick
        ExplicitHeight = 484
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Stored Procs'
      ImageIndex = 1
      ExplicitHeight = 285
      object Label2: TLabel
        Left = 24
        Top = 112
        Width = 88
        Height = 45
        Caption = 'Feature not available in this release'
        WordWrap = True
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 96
    Top = 112
  end
  object QuerySource: TDataSource
    DataSet = Query1
    Left = 432
    Top = 211
  end
  object OpenDialog1: TOpenDialog
    Left = 265
    Top = 214
  end
  object SaveDialog1: TSaveDialog
    Left = 304
    Top = 216
  end
  object tFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 53
    Top = 185
  end
  object Table1: TADTable
    Connection = tFDConnection
    Left = 92
    Top = 184
  end
  object Query1: TADQuery
    Connection = qFDConnection
    Left = 372
    Top = 225
  end
  object qFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 373
    Top = 273
  end
  object wwRecordViewDialog1: TwwRecordViewDialog
    DataSource = QuerySource
    FormPosition.Left = 0
    FormPosition.Top = 0
    FormPosition.Width = 0
    FormPosition.Height = 0
    NavigatorButtons = [nbsFirst, nbsPrior, nbsNext, nbsLast, nbsInsert, nbsDelete, nbsEdit, nbsPost, nbsCancel, nbsRefresh, nbsPriorPage, nbsNextPage, nbsSaveBookmark, nbsRestoreBookmark]
    ControlOptions = []
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'MS Sans Serif'
    LabelFont.Style = []
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Caption = 'Record View'
    NavigatorFlat = True
    Left = 361
    Top = 139
  end
end
