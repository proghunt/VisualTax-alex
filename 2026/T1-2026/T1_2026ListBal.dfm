object ListBalT1_2026: TListBalT1_2026
  Left = 192
  Top = 129
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'ListBal'
  ClientHeight = 357
  ClientWidth = 439
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
    Left = 11
    Top = 8
    Width = 417
    Height = 16
    Caption = 
      'Use this facility to print the balance due or refund for each re' +
      'turn'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8404992
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 96
    Top = 304
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
    Top = 32
    Width = 249
    Height = 265
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
      Width = 175
      Height = 16
      Caption = 'Approximate no. of returns:'
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
  object PrintDialog1: TPrintDialog
    Left = 25
    Top = 112
  end
end
