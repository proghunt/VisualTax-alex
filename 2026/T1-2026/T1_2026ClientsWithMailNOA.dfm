object ClientsWithMailNOAT1_2026: TClientsWithMailNOAT1_2026
  Left = 192
  Top = 129
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'ClientsWithMailNOAT1_2026'
  ClientHeight = 496
  ClientWidth = 596
  Color = clSilver
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
    Left = 69
    Top = 8
    Width = 447
    Height = 16
    Caption = 
      'This listing will show all clients who requested NOA delivery by' +
      ' MAIL'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8404992
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 185
    Top = 436
    Width = 249
    Height = 41
    BorderStyle = bsSingle
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 8
      Top = 4
      Width = 145
      Height = 33
      Caption = 'Print Listing'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 160
      Top = 4
      Width = 73
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object Panel2: TPanel
    Left = 88
    Top = 30
    Width = 410
    Height = 391
    BorderStyle = bsSingle
    TabOrder = 1
    object Label1: TLabel
      Left = 162
      Top = 6
      Width = 93
      Height = 16
      Caption = 'Data Directory'
    end
    object Label2: TLabel
      Left = 47
      Top = 58
      Width = 175
      Height = 16
      Caption = 'Approximate no. of returns:'
    end
    object Label3: TLabel
      Left = 228
      Top = 58
      Width = 36
      Height = 16
      AutoSize = False
      Color = clSilver
      ParentColor = False
    end
    object Label6: TLabel
      Left = 47
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
      Left = 84
      Top = 102
      Width = 260
      Height = 256
      Mask = '*.d'
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 33
      Top = 28
      Width = 360
      Height = 24
      TabOrder = 1
      Text = 'C:\delphi\t1\data'
      OnExit = DataDirBoxExit
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 25
    Top = 112
  end
end
