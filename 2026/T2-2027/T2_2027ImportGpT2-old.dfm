object ImportGpT2_2027: TImportGpT2_2027
  Left = 285
  Top = 157
  Caption = 'ImportGpT2_2027'
  ClientHeight = 623
  ClientWidth = 845
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 845
    Height = 623
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.StartColor = 12615680
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
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ColorPaletteIndex = 13
    object Label4: TLabel
      Left = 235
      Top = 10
      Width = 343
      Height = 25
      Margins.Bottom = 2
      Caption = 'Roll-over to next year from Profile'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 14086654
      Font.Height = -23
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label7: TLabel
      Left = 326
      Top = 40
      Width = 121
      Height = 25
      Margins.Bottom = 2
      Caption = 'Draft - WIP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 14086654
      Font.Height = -23
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object OptionsGroupBox: TGroupBox
    Left = 2
    Top = 72
    Width = 237
    Height = 496
    Caption = 'OPTIONS'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 34
      Width = 133
      Height = 17
      Margins.Bottom = 2
      Caption = 'Profile data directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 11
      Top = 142
      Width = 174
      Height = 17
      Margins.Bottom = 2
      Caption = 'Current VisualTax directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 11
      Top = 82
      Width = 146
      Height = 17
      Margins.Bottom = 2
      Caption = 'Profile Files extension '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 11
      Top = 198
      Width = 157
      Height = 17
      Margins.Bottom = 2
      Caption = 'Replace existing returns'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 11
      Top = 212
      Width = 84
      Height = 17
      Margins.Bottom = 2
      Caption = 'in VisualTax?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object ReplaceOptionBox: TRadioGroup
      Left = 72
      Top = 235
      Width = 118
      Height = 49
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 1
      Items.Strings = (
        'Yes'
        'No')
      ParentFont = False
      TabOrder = 5
    end
    object ProfileExtensionBox: TComboBox
      Left = 160
      Top = 80
      Width = 73
      Height = 24
      TabOrder = 2
      OnChange = ProfileExtensionBoxChange
      Items.Strings = (
        'GT2'
        '*')
    end
    object FromDirBox: TEdit
      Left = 8
      Top = 55
      Width = 225
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'FromDirBox'
      OnExit = FromDirBoxExit
      OnKeyPress = FromDirBoxKeyPress
    end
    object SelectDirBtn1: TBitBtn
      Left = 184
      Top = 27
      Width = 49
      Height = 25
      Caption = 'Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = SelectDirBtn1Click
    end
    object ToDirBox: TEdit
      Left = 8
      Top = 163
      Width = 225
      Height = 23
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'ToDirBox'
    end
    object SelectDirBtn2: TBitBtn
      Left = 184
      Top = 135
      Width = 49
      Height = 25
      Caption = 'Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = SelectDirBtn2Click
    end
  end
  object ActionsGroupBox: TGroupBox
    Left = 623
    Top = 72
    Width = 162
    Height = 496
    Caption = 'ACTIONS'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    object Label8: TLabel
      Left = 16
      Top = 175
      Width = 135
      Height = 75
      Margins.Bottom = 2
      Caption = 
        'If your Profile licence expired, you may need to roll back the s' +
        'ystem date to 2010 before rolling-over tax returns'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      WordWrap = True
    end
    object OpenBtn: TBitBtn
      Left = 16
      Top = 267
      Width = 128
      Height = 25
      Hint = 'Open (and save after review)'
      Caption = 'Roll-over selected file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = OpenBtnClick
    end
    object ImportAllBtn: TBitBtn
      Left = 16
      Top = 306
      Width = 128
      Height = 25
      Hint = 'Not RecommendedImport data to VisualTax dataBase)'
      Caption = 'Roll-over  ALL files...'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = ImportAllBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 16
      Top = 411
      Width = 128
      Height = 33
      Caption = ' Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = CancelBtnClick
    end
    object HelpBtn: TBitBtn
      Left = 16
      Top = 355
      Width = 128
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 3
      OnClick = HelpBtnClick
    end
    object ProfileVersionBox: TRadioGroup
      Left = 11
      Top = 24
      Width = 148
      Height = 149
      Caption = 'Profile version'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        '2023'
        '2022'
        '2021'
        '2020'
        '2019'
        '2018'
        '2017'
        '2016'
        'Prior')
      ParentFont = False
      TabOrder = 4
    end
  end
  object FilesGroupBox: TGroupBox
    Left = 244
    Top = 72
    Width = 373
    Height = 496
    Caption = 'FILES'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    object FileListBox1: TFileListBox
      Left = 7
      Top = 24
      Width = 354
      Height = 460
      Hint = 'Double click to Open it'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      MultiSelect = True
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = FileListBox1DblClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 664
    Top = 40
  end
end
