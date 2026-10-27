object SelectFileT4T5_2026: TSelectFileT4T5_2026
  Left = 216
  Top = 316
  Width = 681
  Height = 548
  Color = clBtnFace
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
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 673
    Height = 464
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label5: TLabel
      Left = 24
      Top = 16
      Width = 37
      Height = 16
      Caption = 'Drive:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SelectedLbl: TLabel
      Left = 243
      Top = 392
      Width = 278
      Height = 17
      AutoSize = False
      Caption = 'N/A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 408
      Top = 40
      Width = 27
      Height = 13
      Caption = 'Files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 24
      Top = 40
      Width = 62
      Height = 13
      Caption = 'Directories'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 248
      Top = 16
      Width = 365
      Height = 15
      Alignment = taCenter
      Caption = 
        'Double click on a directory and then on a file name, then click ' +
        'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label4: TLabel
      Left = 184
      Top = 392
      Width = 54
      Height = 15
      AutoSize = False
      Caption = 'Selected: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object DirectoryListBox1: TDirectoryListBox
      Left = 21
      Top = 56
      Width = 340
      Height = 322
      Hint = 'Double click to change directory'
      ItemHeight = 16
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object DriveComboBox1: TDriveComboBox
      Left = 64
      Top = 16
      Width = 161
      Height = 19
      Hint = 'Click to change drive'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object OKBtn: TBitBtn
      Left = 256
      Top = 416
      Width = 73
      Height = 25
      Caption = 'OK'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 360
      Top = 416
      Width = 73
      Height = 25
      Caption = 'Exit'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = CancelBtnClick
      Kind = bkCancel
    end
    object FileListBox1: TFileListBox
      Left = 408
      Top = 56
      Width = 161
      Height = 321
      Hint = 'Double click to select'
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = FileListBox1Click
      OnDblClick = FileListBox1DblClick
    end
    object FilterComboBox1: TFilterComboBox
      Left = 592
      Top = 352
      Width = 17
      Height = 21
      Color = clBtnFace
      Filter = 'All files (*)|*.*|Zip files (*.ZIP|*.ZIP'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 5
      Visible = False
    end
  end
  object MonitorPlanBtn: TChart
    Left = 0
    Top = 0
    Width = 673
    Height = 57
    AnimatedZoomSteps = 9
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clSilver
    Gradient.StartColor = 12615680
    Gradient.Visible = True
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 10
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = 12971774
    Title.Font.Height = -27
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      '   Select File'
      '')
    AxisVisible = False
    Chart3DPercent = 1
    Legend.Visible = False
    View3DOptions.HorizOffset = -1257
    View3DOptions.VertOffset = -365
    View3DOptions.Zoom = 1
    View3DWalls = False
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 609
    Top = 176
  end
end
