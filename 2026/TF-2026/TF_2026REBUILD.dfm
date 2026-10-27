object RebuildTF_2026: TRebuildTF_2026
  Left = 183
  Top = 22
  Caption = 'Rebuild Client Data Base'
  ClientHeight = 373
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 11
    Top = 8
    Width = 314
    Height = 16
    Caption = 'Use this facility to re-generate a client data base'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 50
    Top = 24
    Width = 182
    Height = 16
    Caption = 'from files in a data directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 312
    Width = 313
    Height = 57
    BorderStyle = bsSingle
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 8
      Top = 12
      Width = 89
      Height = 33
      Caption = 'Rebuild'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 112
      Top = 12
      Width = 81
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object BitBtn1: TBitBtn
      Left = 208
      Top = 12
      Width = 89
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  object Panel2: TPanel
    Left = 40
    Top = 48
    Width = 249
    Height = 257
    BorderStyle = bsSingle
    TabOrder = 1
    object Label1: TLabel
      Left = 67
      Top = 8
      Width = 93
      Height = 16
      Caption = 'Data Directory'
    end
    object Label2: TLabel
      Left = 11
      Top = 64
      Width = 167
      Height = 16
      Caption = 'Aproximate no. of returns:'
    end
    object Label3: TLabel
      Left = 192
      Top = 64
      Width = 4
      Height = 16
    end
    object Label6: TLabel
      Left = 67
      Top = 80
      Width = 112
      Height = 16
      Caption = 'Now processing: '
    end
    object Label7: TLabel
      Left = 192
      Top = 80
      Width = 4
      Height = 16
    end
    object FileListBox1: TFileListBox
      Left = 60
      Top = 112
      Width = 117
      Height = 129
      Mask = '*.d'
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 33
      Top = 28
      Width = 168
      Height = 24
      TabOrder = 1
      Text = 'C:\delphi\t1\data'
      OnExit = DataDirBoxExit
    end
  end
end
