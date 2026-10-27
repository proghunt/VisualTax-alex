object OpenFlNameT2_2027: TOpenFlNameT2_2027
  Left = 119
  Top = 98
  Caption = 'Open by File Name'
  ClientHeight = 464
  ClientWidth = 659
  Color = 14933196
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 253
    Top = 8
    Width = 66
    Height = 13
    Caption = 'File Name:*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 13
    Top = 8
    Width = 92
    Height = 13
    Caption = 'Directory Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 29
    Top = 56
    Width = 31
    Height = 13
    Caption = 'Drive'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 221
    Top = 56
    Width = 52
    Height = 13
    Caption = 'Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 405
    Top = 56
    Width = 21
    Height = 13
    Caption = 'File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object FlNameBox: TEdit
    Left = 241
    Top = 28
    Width = 121
    Height = 24
    TabOrder = 1
  end
  object DataDirBox: TEdit
    Left = 9
    Top = 28
    Width = 192
    Height = 24
    TabOrder = 0
    Text = 'DataDirBox'
  end
  object OKBtn: TBitBtn
    Left = 561
    Top = 192
    Width = 88
    Height = 33
    Caption = 'Open file'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 561
    Top = 248
    Width = 88
    Height = 33
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object FileListBox1: TFileListBox
    Left = 344
    Top = 72
    Width = 193
    Height = 385
    TabOrder = 4
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 176
    Top = 72
    Width = 145
    Height = 385
    TabOrder = 5
  end
  object DriveComboBox1: TDriveComboBox
    Left = 16
    Top = 72
    Width = 137
    Height = 22
    TabOrder = 6
  end
  object OpenDialog1: TOpenDialog
    Left = 56
    Top = 128
  end
end
