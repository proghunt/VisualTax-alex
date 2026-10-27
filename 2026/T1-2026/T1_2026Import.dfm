object ImportT1_2026: TImportT1_2026
  Left = 202
  Top = 84
  Caption = '\'
  ClientHeight = 629
  ClientWidth = 1041
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
  OnShow = FormShow
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
    Width = 109
    Height = 13
    Caption = 'Search Last Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object OKBtn: TBitBtn
    Left = 527
    Top = 294
    Width = 201
    Height = 33
    Caption = 'Rollover the Selected return'
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
  object CancelBtn: TBitBtn
    Left = 519
    Top = 510
    Width = 201
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    Kind = bkClose
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 8
    OnClick = CancelBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 89
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
      Left = 307
      Top = 41
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
  object AllBtn: TBitBtn
    Left = 527
    Top = 374
    Width = 201
    Height = 33
    Caption = 'Rollover All'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 5
    OnClick = AllBtnClick
  end
  object FileListBox1: TFileListBox
    Left = 583
    Top = 120
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
    TabOrder = 6
    Visible = False
  end
  object DosFileBtn: TBitBtn
    Left = 527
    Top = 335
    Width = 201
    Height = 33
    Caption = 'Rollover a known return (SIN)...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = DosFileBtnClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 232
    Width = 505
    Height = 385
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Ms Sans Serif'
    TitleFont.Style = [fsBold]
    OnDblClick = DBGrid1DblClick
  end
  object OverrideOption: TRadioGroup
    Left = 17
    Top = 160
    Width = 560
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
      'DO NOT replace already prepared 2025 tax returns'
      'Replace already prepared 2025 tax returns')
    ParentColor = False
    ParentFont = False
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 519
    Top = 462
    Width = 201
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Kind = bkHelp
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 9
    OnClick = BitBtn1Click
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
  object CfT4Box: TCheckBox
    Left = 527
    Top = 208
    Width = 201
    Height = 17
    Caption = 'Carry Forward T4 Employer'#39's Names'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 10
  end
  object CfT5Box: TCheckBox
    Left = 527
    Top = 224
    Width = 193
    Height = 17
    Caption = 'Carry Forward T5 Payer'#39's Names'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 11
  end
  object CfEfileIndicBox: TCheckBox
    Left = 527
    Top = 240
    Width = 193
    Height = 17
    Caption = 'Carry Forward Efile indicator'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 12
  end
  object BothSpousesBtn: TCheckBox
    Left = 545
    Top = 271
    Width = 163
    Height = 17
    Caption = 'Both spouses (if applicable)'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 14
  end
  object btnFixPasswords: TButton
    Left = 519
    Top = 568
    Width = 201
    Height = 25
    Caption = 'Fix files password'
    TabOrder = 13
    OnClick = btnFixPasswordsClick
  end
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 1041
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
    Zoom.Pen.Mode = pmNotXor
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 15
    ColorPaletteIndex = 13
    object Label4: TLabel
      Left = 146
      Top = 23
      Width = 514
      Height = 26
      Caption = 'Roll-over VisualTax T1-2024 to VisualTax T1-2025'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 271
    Top = 252
  end
  object FDConnection: TADConnection
    Left = 184
    Top = 248
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 184
    Top = 312
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
