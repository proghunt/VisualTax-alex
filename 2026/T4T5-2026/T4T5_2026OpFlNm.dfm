object OpenFlNameT4T5_2026: TOpenFlNameT4T5_2026
  Left = 126
  Top = 122
  Caption = 'Open by File Name'
  ClientHeight = 152
  ClientWidth = 388
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 53
    Top = 16
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
    Left = 21
    Top = 56
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
    Left = 22
    Top = 141
    Width = 127
    Height = 13
    Caption = '* Enter SIN as 9 digits'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object FlNameBox: TEdit
    Left = 145
    Top = 12
    Width = 121
    Height = 24
    TabOrder = 0
  end
  object DataDirBox: TEdit
    Left = 145
    Top = 52
    Width = 192
    Height = 24
    TabOrder = 1
    Text = 'DataDirBox'
  end
  object OKBtn: TBitBtn
    Left = 113
    Top = 96
    Width = 80
    Height = 33
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 233
    Top = 96
    Width = 80
    Height = 33
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
end
