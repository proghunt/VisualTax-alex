object RollGpT1_2026: TRollGpT1_2026
  Left = 280
  Top = 256
  Caption = 'RollGpT1_2026'
  ClientHeight = 434
  ClientWidth = 779
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 774
    Height = 71
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
    BevelOuter = bvNone
    TabOrder = 3
    ColorPaletteIndex = 13
    object Label4: TLabel
      Left = 124
      Top = 18
      Width = 483
      Height = 26
      Caption = 'Roll-over Profile T1-2024 to VisualTax T1-2025'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object OptionsGroupBox: TGroupBox
    Left = 9
    Top = 72
    Width = 297
    Height = 321
    Caption = 'OPTIONS'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 142
      Width = 119
      Height = 16
      Caption = 'Profile data directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 8
      Top = 232
      Width = 185
      Height = 16
      Caption = 'Current VisualTax data directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 11
      Top = 186
      Width = 132
      Height = 16
      Caption = 'Profile Files extension '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label8: TLabel
      Left = 8
      Top = 248
      Width = 231
      Height = 14
      Caption = 'or Configure | General Options | Data Directories'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object LinkToOptionsLbl: TLabel
      Left = 11
      Top = 105
      Width = 251
      Height = 15
      Cursor = crHandPoint
      Caption = 'Configure | General Options | Data Directories'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsUnderline]
      ParentFont = False
      Transparent = True
      OnClick = LinkToOptionsLblClick
    end
    object Label6: TLabel
      Left = 13
      Top = 91
      Width = 182
      Height = 15
      Caption = 'Directories should be entered in  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object ReplaceOptionBox: TRadioGroup
      Left = 8
      Top = 32
      Width = 273
      Height = 49
      Caption = 'Replace already existing return(s) in VisualTax'
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
      TabOrder = 0
    end
    object ProfileExtensionBox: TComboBox
      Left = 225
      Top = 188
      Width = 73
      Height = 24
      TabOrder = 3
      OnChange = ProfileExtensionBoxChange
      Items.Strings = (
        '24T'
        '*')
    end
    object FromDirBox: TEdit
      Left = 8
      Top = 159
      Width = 280
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'FromDirBox'
      OnExit = FromDirBoxExit
      OnKeyPress = FromDirBoxKeyPress
    end
    object SelectDirBtn1: TBitBtn
      Left = 136
      Top = 140
      Width = 49
      Height = 19
      Caption = 'Select...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = SelectDirBtn1Click
    end
    object ToDirBox: TEdit
      Left = 8
      Top = 263
      Width = 265
      Height = 23
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = 'ToDirBox'
    end
    object SelectDirBtn2: TBitBtn
      Left = 213
      Top = 231
      Width = 68
      Height = 18
      Caption = 'Select...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = SelectDirBtn2Click
    end
  end
  object ActionsGroupBox: TGroupBox
    Left = 546
    Top = 72
    Width = 211
    Height = 321
    Caption = 'ACTIONS'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    object Label5: TLabel
      Left = 40
      Top = 116
      Width = 111
      Height = 15
      Caption = 'BATCH ROLL-OVER'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 37
      Top = 134
      Width = 61
      Height = 15
      Caption = 'How many:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 24
      Top = 155
      Width = 150
      Height = 16
      Caption = 'starting from selected one'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 13
      Top = 49
      Width = 82
      Height = 15
      Caption = 'File Password:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object OpenBtn: TBitBtn
      Left = 9
      Top = 77
      Width = 169
      Height = 24
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
      TabOrder = 2
      OnClick = OpenBtnClick
    end
    object ImportAllBtn: TBitBtn
      Left = 9
      Top = 186
      Width = 169
      Height = 33
      Hint = 'Not RecommendedImport data to VisualTax dataBase)'
      Caption = 'Batch roll-over'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = ImportAllBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 9
      Top = 264
      Width = 169
      Height = 41
      Caption = ' Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 4
      OnClick = CancelBtnClick
    end
    object HelpBtn: TBitBtn
      Left = 9
      Top = 228
      Width = 169
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 5
      OnClick = BitBtn1Click
    end
    object HowManyBox: TEdit
      Left = 104
      Top = 132
      Width = 49
      Height = 17
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Text = 'HowManyBox'
    end
    object SpouseBox: TCheckBox
      Left = 10
      Top = 26
      Width = 194
      Height = 17
      Caption = 'Rollover both spouses, if applicable'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
    end
    object Psw: TEdit
      Left = 104
      Top = 48
      Width = 72
      Height = 17
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
    end
  end
  object FilesGroupBox: TGroupBox
    Left = 313
    Top = 72
    Width = 227
    Height = 321
    Caption = 'FILES'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object ProcessingLbl: TLabel
      Left = 64
      Top = 16
      Width = 80
      Height = 15
      Caption = 'ProcessingLbl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object FileListBox1: TFileListBox
      Left = 16
      Top = 32
      Width = 201
      Height = 281
      Hint = 'Double click to Open it'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = FileListBox1DblClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 722
    Top = 40
  end
  object PopupMenu1: TPopupMenu
    Left = 723
    Top = 3
  end
end
