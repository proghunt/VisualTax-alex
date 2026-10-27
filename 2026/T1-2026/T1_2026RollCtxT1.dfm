object RollCtxT1_2026: TRollCtxT1_2026
  Left = 251
  Top = 165
  BorderStyle = bsDialog
  Caption = 'Roll Forward CanTax T1'
  ClientHeight = 699
  ClientWidth = 747
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clInactiveBorder
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 119
    Top = 196
    Width = 159
    Height = 14
    Caption = 'CanTax last year'#39's data directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 119
    Top = 259
    Width = 132
    Height = 14
    Caption = 'VisualTax Current directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 427
    Top = 238
    Width = 114
    Height = 14
    Caption = 'CanTax Files extension '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LinkToOptionsLbl: TLabel
    Left = 119
    Top = 182
    Width = 218
    Height = 14
    Cursor = crHandPoint
    Caption = 'Configure | General Options | Data Directories'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    Transparent = True
    OnClick = LinkToOptionsLblClick
  end
  object Label5: TLabel
    Left = 119
    Top = 168
    Width = 159
    Height = 14
    Caption = 'Directories should be entered in  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 119
    Top = 308
    Width = 29
    Height = 15
    Caption = 'Files:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveBorder
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object CancelBtn: TBitBtn
    Left = 497
    Top = 662
    Width = 85
    Height = 36
    Caption = ' Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 0
    OnClick = CancelBtnClick
  end
  object HelpBtn: TBitBtn
    Left = 385
    Top = 662
    Width = 85
    Height = 36
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkHelp
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 1
    OnClick = HelpBtnClick
  end
  object OpenBtn: TBitBtn
    Left = 182
    Top = 662
    Width = 176
    Height = 36
    Hint = 'Open (and save after review)'
    Caption = 'Roll-over selected Return(s)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = OpenBtnClick
  end
  object FileListBox1: TFileListBox
    Left = 119
    Top = 308
    Width = 498
    Height = 348
    Hint = 'Double click to Open'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    MultiSelect = True
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnChange = FileListBox1Change
    OnClick = FileListBox1Change
    OnDblClick = FileListBox1DblClick
    OnEnter = FileListBox1Change
    OnExit = FileListBox1Change
    OnKeyPress = FileListBox1KeyPress
  end
  object ReplaceOptionBox: TRadioGroup
    Left = 119
    Top = 119
    Width = 498
    Height = 36
    Caption = 'Replace already existing return(s) in VisualTax'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 1
    Items.Strings = (
      'Yes'
      'No')
    ParentFont = False
    TabOrder = 4
  end
  object CanTaxExtensionBox: TComboBox
    Left = 546
    Top = 238
    Width = 71
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnChange = CanTaxExtensionBoxChange
  end
  object FromDirBox: TEdit
    Left = 175
    Top = 210
    Width = 442
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = 'FromDirBox'
    OnExit = FromDirBoxExit
    OnKeyPress = FromDirBoxKeyPress
  end
  object SelectDirBtn1: TBitBtn
    Left = 119
    Top = 210
    Width = 49
    Height = 22
    Caption = 'Select...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = SelectDirBtn1Click
  end
  object ToDirBox: TEdit
    Left = 175
    Top = 273
    Width = 442
    Height = 22
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Text = 'ToDirBox'
  end
  object SelectDirBtn2: TBitBtn
    Left = 119
    Top = 273
    Width = 48
    Height = 22
    Caption = 'Select...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = SelectDirBtn2Click
  end
  object SaveOrOpenOptionBox: TRadioGroup
    Left = 119
    Top = 77
    Width = 498
    Height = 36
    Caption = 'Roll-Over Options'
    Color = clBtnFace
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = -1
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Open Return(s)'
      'Save Return(s) Directly to File')
    ParentColor = False
    ParentFont = False
    TabOrder = 10
  end
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 747
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
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 11
    ColorPaletteIndex = 13
    object Label7: TLabel
      Left = 124
      Top = 16
      Width = 492
      Height = 26
      Caption = 'Roll-over CanTax T1-2024 to VisualTax T1-2025'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 636
    Top = 16
  end
end
