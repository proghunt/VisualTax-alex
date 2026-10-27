object ImportGpT1_2026: TImportGpT1_2026
  Left = 90
  Top = 91
  Caption = 'ImportGpT1_2026'
  ClientHeight = 0
  ClientWidth = 124
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 160
    Width = 385
    Height = 353
    TabOrder = 0
    object Label4: TLabel
      Left = 64
      Top = 3
      Width = 197
      Height = 19
      Caption = 'STEP 2 - Data Conversion'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Memo1: TMemo
      Left = 8
      Top = 64
      Width = 369
      Height = 273
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object StartBtn: TBitBtn
      Left = 48
      Top = 32
      Width = 129
      Height = 25
      Caption = '2.1 Start Conversion...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = StartBtnClick
    end
    object LogBtn: TBitBtn
      Left = 200
      Top = 32
      Width = 153
      Height = 25
      Caption = '2.2  Show conversion Results'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = LogBtnClick
    end
  end
  object Panel2: TPanel
    Left = 408
    Top = 160
    Width = 361
    Height = 353
    TabOrder = 1
    object Label5: TLabel
      Left = 56
      Top = 3
      Width = 215
      Height = 19
      Caption = 'STEP 3 - Import to VisualTax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 40
      Top = 40
      Width = 86
      Height = 13
      Caption = 'Converted files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ImportOneBtn: TBitBtn
      Left = 208
      Top = 143
      Width = 137
      Height = 33
      Caption = '3.2 Import Selected file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ImportOneBtnClick
    end
    object ImportAllBtn: TBitBtn
      Left = 208
      Top = 199
      Width = 129
      Height = 33
      Caption = '3.2 Import ALL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ImportAllBtnClick
    end
    object ReplaceOptionBox: TRadioGroup
      Left = 192
      Top = 48
      Width = 153
      Height = 49
      Caption = '3.1 Replace existing return(s)'
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 1
      Items.Strings = (
        'Yes'
        'No')
      ParentFont = False
      TabOrder = 2
    end
    object ExportedBtn: TBitBtn
      Left = 208
      Top = 103
      Width = 129
      Height = 26
      Caption = 'Show converted file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = ExportedBtnClick
    end
    object FileListBox1: TFileListBox
      Left = 8
      Top = 64
      Width = 177
      Height = 281
      Hint = 'Double click a file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ItemHeight = 13
      Mask = 'x*x'
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnDblClick = FileListBox1DblClick
    end
    object CancelBtn: TBitBtn
      Left = 208
      Top = 256
      Width = 129
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
      TabOrder = 5
      OnClick = CancelBtnClick
    end
  end
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 124
    Height = 153
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clSilver
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
      '   Greenpoint-Profile to VisualTax'
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
    TabOrder = 2
    ExplicitWidth = 778
    ColorPaletteIndex = 13
    object Label3: TLabel
      Left = 352
      Top = 82
      Width = 229
      Height = 16
      Caption = 'Current VisualTax directory (see Config)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 16
      Top = 82
      Width = 171
      Height = 16
      Caption = 'Select a Profile data directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 24
      Top = 130
      Width = 114
      Height = 14
      Caption = 'Profile file extension'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Image1: TImage
      Left = 296
      Top = 95
      Width = 41
      Height = 25
      Picture.Data = {
        07544269746D61706A020000424D6A0200000000000076000000280000002200
        0000190000000100040000000000F40100000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00888888888888888888888888888888888800000088888888888888888888
        8888888888888800000088888888888888888888888888888888880000008888
        8888888888888888888888888888880000008800888888800000088888888888
        8888880000008800008800088888800008888888888888000000880088008888
        888008FFF08888888888880000008800880888FFFF08FF000088888888888800
        000088008808FFFFFF0F008FFF0888888888880000008800880FFFFFFFF08FF0
        000088888888880000008800EE0FFFFFFFF0F008FFFF08888888880000008800
        EE0FFFFFFFFF08FFFFFF08888888880000008800EE0FFFFFFFFF0FFF00000888
        8888880000008800EE0FFFFFFFFF0000FFFFF0888888880000008800EE0FFFFF
        FFF0FFFFFFFFF0000000880000008800EE0FFFFFFFFFFFFFFFF0008888880800
        00008800EE00FFFFFFFFFFFFF008FFFFFFFF080000008800008800FFFFFFFFFF
        0FFFFFFF000088000000880088888800FFFFFFFFFFF000008888880000008888
        8888888800000000000888888888880000008888888888888888888888888888
        8888880000008888888888888888888888888888888888000000888888888888
        8888888888888888888888000000888888888888888888888888888888888800
        00008888888888888888888888888888888888000000}
    end
    object Label7: TLabel
      Left = 272
      Top = 59
      Width = 251
      Height = 19
      Caption = 'STEP 1 - Data Directory selection'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object ToDirBox: TEdit
      Left = 352
      Top = 103
      Width = 233
      Height = 23
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'ToDirBox'
    end
    object FromDirBox: TEdit
      Left = 16
      Top = 103
      Width = 201
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'FromDirBox'
    end
    object ProfileExtensionBox: TEdit
      Left = 144
      Top = 127
      Width = 33
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'ProfileExtensionBox'
    end
    object SelectDirBtn1: TBitBtn
      Left = 224
      Top = 103
      Width = 57
      Height = 25
      Caption = 'Select...'
      TabOrder = 3
      OnClick = SelectDirBtn1Click
    end
    object SelectDirBtn2: TBitBtn
      Left = 592
      Top = 103
      Width = 49
      Height = 25
      Caption = 'Select...'
      TabOrder = 4
      OnClick = SelectDirBtn2Click
    end
    object HelpBtn: TBitBtn
      Left = 648
      Top = 103
      Width = 57
      Height = 25
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 5
      OnClick = HelpBtnClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 608
    Top = 8
  end
end
