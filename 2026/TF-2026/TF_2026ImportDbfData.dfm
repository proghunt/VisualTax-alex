object ImportDBFTF_2026: TImportDBFTF_2026
  Left = 315
  Top = 202
  Caption = 'Import data to Multi-App version of VisualTax'
  ClientHeight = 641
  ClientWidth = 853
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object RetCntLabel: TLabel
    Left = 192
    Top = 120
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
    Top = 208
    Width = 111
    Height = 13
    Caption = 'Search Corp Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelProgressBar: TLabel
    Left = 528
    Top = 408
    Width = 200
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = '0/0'
    Visible = False
  end
  object OKBtn: TBitBtn
    Left = 527
    Top = 294
    Width = 201
    Height = 33
    Caption = 'Import the Selected return'
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
  object CancelBtn: TBitBtn
    Left = 528
    Top = 584
    Width = 201
    Height = 33
    Cancel = True
    Caption = '&Close'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 7
    OnClick = CancelBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 88
    Width = 721
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
    object Label3: TLabel
      Left = 305
      Top = 16
      Width = 44
      Height = 13
      Caption = 'TO folder'
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
    object Label1: TLabel
      Left = 11
      Top = 16
      Width = 60
      Height = 13
      Caption = 'FROM folder'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object DbfData_Dir: TEdit
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
      Text = 'DbfData_Dir'
      OnExit = DbfData_DirExit
      OnKeyPress = DbfData_DirKeyPress
    end
    object Cur_Dir: TEdit
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
      Text = 'Cur_Dir'
    end
  end
  object AllBtn: TBitBtn
    Left = 527
    Top = 347
    Width = 201
    Height = 33
    Caption = 'Import All returns'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 4
    OnClick = AllBtnClick
  end
  object FileListBox1: TFileListBox
    Left = 583
    Top = 97
    Width = 77
    Height = 73
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ItemHeight = 13
    Mask = '*.xyz'
    ParentFont = False
    TabOrder = 5
    Visible = False
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 232
    Width = 497
    Height = 385
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Ms Sans Serif'
    TitleFont.Style = [fsBold]
    OnDblClick = DBGrid1DblClick
  end
  object OverrideOption: TRadioGroup
    Left = 8
    Top = 160
    Width = 721
    Height = 41
    Caption = 'Options (when importing All)'
    Color = clBtnFace
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'DO NOT replace existing tax returns in Multi-app'
      'Replace All')
    ParentColor = False
    ParentFont = False
    TabOrder = 2
  end
  object SearchBox: TEdit
    Left = 132
    Top = 208
    Width = 79
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
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 853
    Height = 78
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.StartColor = 9733176
    Gradient.Visible = True
    Legend.Visible = False
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 10
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = 12971774
    Title.Font.Height = -27
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      '  '
      '')
    AxisVisible = False
    Chart3DPercent = 1
    View3DOptions.HorizOffset = -1257
    View3DOptions.VertOffset = -365
    View3DOptions.Zoom = 1
    View3DWalls = False
    Zoom.AnimatedSteps = 9
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 8
    ColorPaletteIndex = 13
    object Label4: TLabel
      Left = 0
      Top = 0
      Width = 853
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Import old data base format VisualTax TF-2017 Tax return Data '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlBottom
    end
    object Label5: TLabel
      Left = 0
      Top = 36
      Width = 853
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'to the Multi-app  VT-2017 '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlBottom
    end
  end
  object ProgressBar: TProgressBar
    Left = 528
    Top = 392
    Width = 200
    Height = 16
    TabOrder = 9
    Visible = False
  end
  object MemoLog: TMemo
    Left = 527
    Top = 461
    Width = 201
    Height = 114
    BorderStyle = bsNone
    Color = clInfoBk
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 10
    Visible = False
  end
  object ButtonCloseLog: TButton
    Left = 528
    Top = 430
    Width = 201
    Height = 25
    Caption = 'Close / show log'
    TabOrder = 11
    Visible = False
    OnClick = ButtonCloseLogClick
  end
  object btnHelp: TBitBtn
    Left = 528
    Top = 232
    Width = 200
    Height = 25
    Kind = bkHelp
    NumGlyphs = 2
    TabOrder = 12
    OnClick = btnHelpClick
  end
  object DataSource1: TDataSource
    DataSet = Table
    Left = 271
    Top = 252
  end
  object Connection: TADConnection
    Left = 160
    Top = 304
  end
  object Table: TADTable
    OnFilterRecord = TableFilterRecord
    Connection = Connection
    Left = 160
    Top = 360
  end
end
