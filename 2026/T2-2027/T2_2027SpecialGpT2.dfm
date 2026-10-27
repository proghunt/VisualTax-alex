object SpecialGpT2_2027: TSpecialGpT2_2027
  Left = 705
  Top = 307
  Caption = 'SpecialGpT2_2027'
  ClientHeight = 461
  ClientWidth = 801
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 7
    Top = 7
    Width = 419
    Height = 25
    Margins.Bottom = 2
    Caption = 'Import Rolled-over Greenpoint-Profile T2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object statuslbl: TLabel
    Left = 752
    Top = 371
    Width = 9
    Height = 12
    Margins.Bottom = 2
    Alignment = taRightJustify
    Caption = '---'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object OptionsGroupBox: TGroupBox
    Left = 7
    Top = 35
    Width = 239
    Height = 335
    Caption = 'OPTIONS'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
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
    object ReplaceOptionBox: TRadioGroup
      Left = 9
      Top = 228
      Width = 223
      Height = 49
      Caption = 'Replace existing returns in VisualTax?'
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
      Height = 25
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
      Height = 25
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
    Top = 35
    Width = 141
    Height = 393
    Caption = 'ACTIONS'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    object Label8: TLabel
      Left = 9
      Top = 92
      Width = 109
      Height = 105
      Margins.Bottom = 2
      Caption = 
        'If your Profile licence expired, you may need to roll back the s' +
        'ystem date to 2007 before rolling-over tax returns'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      WordWrap = True
    end
    object Label5: TLabel
      Left = 37
      Top = 224
      Width = 45
      Height = 15
      Margins.Bottom = 2
      Alignment = taRightJustify
      Caption = 'Amount:'
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
      Top = 177
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
      Left = 9
      Top = 244
      Width = 128
      Height = 25
      Hint = 'Not RecommendedImport data to VisualTax dataBase)'
      Caption = 'Batch Roll-over...'
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
      Left = 9
      Top = 335
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
      Left = 9
      Top = 300
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
    object HowManyBox: TEdit
      Left = 85
      Top = 224
      Width = 49
      Height = 16
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = 'HowManyBox'
    end
    object ProfileVersionBox: TRadioGroup
      Left = -7
      Top = 21
      Width = 148
      Height = 50
      Caption = 'Profile version'
      Columns = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        '2009'
        'Prior'
        '2012')
      ParentFont = False
      TabOrder = 5
    end
  end
  object FilesGroupBox: TGroupBox
    Left = 252
    Top = 35
    Width = 365
    Height = 335
    Caption = 'FILES'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object FileListBox1: TFileListBox
      Left = 7
      Top = 24
      Width = 354
      Height = 299
      Hint = 'Double click to Open it'
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
    Top = 7
  end
end
