object RebuildT2_2027: TRebuildT2_2027
  Left = 248
  Top = 63
  Caption = 'Rebuild Client Data Base'
  ClientHeight = 546
  ClientWidth = 614
  Color = 15394527
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
  object Panel1: TPanel
    Left = 291
    Top = 289
    Width = 129
    Height = 169
    BorderStyle = bsSingle
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 17
      Top = 12
      Width = 96
      Height = 33
      Caption = 'Rebuild'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 17
      Top = 60
      Width = 96
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object BitBtn1: TBitBtn
      Left = 17
      Top = 120
      Width = 96
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  object Panel2: TPanel
    Left = 18
    Top = 112
    Width = 249
    Height = 428
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
      Top = 105
      Width = 117
      Height = 309
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 15
      Mask = '*.d'
      ParentFont = False
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 12
      Top = 28
      Width = 227
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'C:\delphi\t1\data'
      OnExit = DataDirBoxExit
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 614
    Height = 29
    Align = alTop
    Color = 11301888
    TabOrder = 2
    object Label9: TLabel
      Left = 185
      Top = 1
      Width = 243
      Height = 22
      Caption = 'Rebuild a Client Data Base'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 29
    Width = 614
    Height = 77
    Align = alTop
    TabOrder = 3
    object Label4: TLabel
      Left = 141
      Top = 8
      Width = 280
      Height = 16
      Caption = 'Use this facility to re-generate a client data base'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4194368
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 140
      Top = 24
      Width = 222
      Height = 16
      Caption = 'from tax return files in a data directory.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4194368
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 137
      Top = 40
      Width = 347
      Height = 16
      Caption = 'Usefull when the data base has been changed, or corrupted '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4194368
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 137
      Top = 54
      Width = 333
      Height = 16
      Caption = 'or you copied files into a data directory using the Explorer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4194368
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object FileNameFormat: TRadioGroup
    Left = 291
    Top = 136
    Width = 307
    Height = 106
    Caption = 'FILE NAME FORMAT'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'BusinessNumber 999999999.YR'
      'CompanyName-{BusinessNumber}.YR')
    ParentFont = False
    TabOrder = 4
  end
  object cbRename: TCheckBox
    Left = 291
    Top = 112
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
    TabOrder = 5
    OnClick = cbRenameClick
  end
end
