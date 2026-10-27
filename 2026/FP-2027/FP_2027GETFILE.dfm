object getfileFP_2012: TgetfileFP_2012
  Left = 36
  Top = 42
  BorderStyle = bsDialog
  Caption = 'Select File(s)'
  ClientHeight = 324
  ClientWidth = 478
  Color = clBtnShadow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Ms Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 320
    Top = 8
    Width = 140
    Height = 265
    BevelInner = bvLowered
    BorderWidth = 4
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 101
      Height = 16
      Caption = 'Selected Files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ListBox1: TListBox
      Left = 16
      Top = 56
      Width = 105
      Height = 193
      Hint = 'Double click to remove a file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = ListBox1DblClick
    end
    object ClearBtn: TButton
      Left = 38
      Top = 30
      Width = 43
      Height = 19
      Hint = 'Click to clear this list'
      Caption = 'Clear'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = ClearBtnClick
    end
  end
  object Panel2: TPanel
    Left = 16
    Top = 8
    Width = 292
    Height = 265
    BevelInner = bvLowered
    BorderWidth = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 8
      Width = 76
      Height = 16
      Caption = 'File Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 208
      Width = 40
      Height = 16
      Caption = 'Filter:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 152
      Top = 8
      Width = 68
      Height = 16
      Caption = 'Directory:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 144
      Top = 208
      Width = 42
      Height = 16
      Caption = 'Drive:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DirLabel: TLabel
      Left = 152
      Top = 24
      Width = 3
      Height = 13
    end
    object FileNameBox: TEdit
      Left = 16
      Top = 24
      Width = 105
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 0
      OnDblClick = FileNameBoxDblClick
    end
    object FileListBox1: TFileListBox
      Left = 16
      Top = 56
      Width = 105
      Height = 145
      Hint = 'Double click to select'
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = FileListBox1Click
      OnDblClick = FileListBox1DblClick
    end
    object FilterComboBox1: TFilterComboBox
      Left = 16
      Top = 232
      Width = 105
      Height = 21
      Hint = 'Click to change filter'
      Color = clBtnFace
      Filter = 'All files (*)|*.*|Zip files (*.ZIP|*.ZIP'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object DirectoryListBox1: TDirectoryListBox
      Left = 141
      Top = 56
      Width = 124
      Height = 145
      Hint = 'Double click to change directory'
      ItemHeight = 16
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object DriveComboBox1: TDriveComboBox
      Left = 141
      Top = 231
      Width = 124
      Height = 19
      Hint = 'Click to change drive'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
  end
  object OKBtn: TBitBtn
    Left = 153
    Top = 279
    Width = 89
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = OKBtnClick
    Kind = bkOK
  end
  object CancelBtn: TBitBtn
    Left = 265
    Top = 279
    Width = 89
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
end
