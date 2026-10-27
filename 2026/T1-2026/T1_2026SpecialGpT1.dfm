object SpecialGpT1_2026: TSpecialGpT1_2026
  Left = 494
  Top = 287
  Caption = 'SpecialGpT1_2026'
  ClientHeight = 375
  ClientWidth = 777
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
  object Label4: TLabel
    Left = 7
    Top = 0
    Width = 560
    Height = 26
    Caption = 'Special Roll-over Profile T1 to VisualTax T1 same year'
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object OptionsGroupBox: TGroupBox
    Left = 7
    Top = 28
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
      Width = 218
      Height = 14
      Caption = 'Configure | General Options | Data Directories'
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
      Left = 217
      Top = 184
      Width = 73
      Height = 24
      TabOrder = 3
      OnChange = ProfileExtensionBoxChange
      Items.Strings = (
        '12T'
        '12T'
        '11T'
        '10T'
        '09T'
        '08T'
        '07T'
        '06T'
        '05T'
        '04T'
        '03T'
        '02T'
        '01T'
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
      Width = 12
      Height = 25
      Caption = 'Select...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Visible = False
      OnClick = SelectDirBtn2Click
    end
  end
  object ActionsGroupBox: TGroupBox
    Left = 553
    Top = 28
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
      Top = 172
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
      Left = 32
      Top = 188
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
      Top = 204
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
      Top = 98
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
    object Label12: TLabel
      Left = 10
      Top = 120
      Width = 195
      Height = 16
      Caption = 'We recommend Open one-by-one'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object OpenBtn: TBitBtn
      Left = 9
      Top = 140
      Width = 169
      Height = 24
      Hint = 'Open (and save after review)'
      Caption = 'OPEN selected file'
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
      Top = 228
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
      Top = 32
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
      Top = 188
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
      Top = 75
      Width = 194
      Height = 17
      Caption = 'Rollover both spouses, if applicable'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
    end
    object Psw: TEdit
      Left = 104
      Top = 97
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
    Left = 315
    Top = 28
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
    Left = 735
  end
  object PopupMenu1: TPopupMenu
    Left = 707
  end
end
