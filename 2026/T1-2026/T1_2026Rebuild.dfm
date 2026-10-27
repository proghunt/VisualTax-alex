object RebuildT1_2026: TRebuildT1_2026
  Left = 329
  Top = 196
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Rebuild Client Data Base'
  ClientHeight = 547
  ClientWidth = 943
  Color = 14537409
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 11
    Top = 1
    Width = 582
    Height = 16
    Caption = 
      'Use this facility to re-generate a client data base (Client Book' +
      ') from tax return files in a data directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 11
    Top = 22
    Width = 93
    Height = 16
    Caption = 'Data Directory'
  end
  object Panel1: TPanel
    Left = 281
    Top = 477
    Width = 296
    Height = 50
    BorderStyle = bsSingle
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 10
      Top = 5
      Width = 159
      Height = 33
      Caption = 'Rebuild the database'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkOK
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 191
      Top = 5
      Width = 81
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object Panel2: TPanel
    Left = 6
    Top = 54
    Width = 419
    Height = 407
    BorderStyle = bsSingle
    TabOrder = 1
    object Label3: TLabel
      Left = 175
      Top = 8
      Width = 4
      Height = 16
      Color = clWhite
      ParentColor = False
    end
    object Label7: TLabel
      Left = 112
      Top = 24
      Width = 287
      Height = 16
      AutoSize = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label8: TLabel
      Left = 11
      Top = 8
      Width = 157
      Height = 16
      Caption = 'Approximate no. of returns:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 11
      Top = 24
      Width = 100
      Height = 16
      Caption = 'Now processing: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object FileListBox1: TFileListBox
      Left = 11
      Top = 46
      Width = 200
      Height = 351
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Mask = '*.d'
      ParentFont = False
      TabOrder = 0
    end
    object cbRename: TCheckBox
      Left = 217
      Top = 82
      Width = 186
      Height = 17
      Caption = 'Rename returns FileName to ..'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = cbRenameClick
    end
  end
  object ListBox1: TListBox
    Left = 431
    Top = 80
    Width = 504
    Height = 381
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 432
    Top = 54
    Width = 505
    Height = 29
    Caption = 'Progress'
    TabOrder = 3
  end
  object DataDirBox: TEdit
    Left = 140
    Top = 21
    Width = 797
    Height = 24
    TabOrder = 4
    OnExit = DataDirBoxExit
  end
  object FileNameFormat: TRadioGroup
    Left = 227
    Top = 158
    Width = 182
    Height = 71
    Caption = 'FileName format'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'SIN 99999999.9'
      'LastName FirstName-{SIN}.YR')
    ParentFont = False
    TabOrder = 5
  end
end
