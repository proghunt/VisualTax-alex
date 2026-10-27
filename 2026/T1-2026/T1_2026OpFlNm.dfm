object OpenFlNameT1_2026: TOpenFlNameT1_2026
  Left = 228
  Top = 207
  Width = 427
  Height = 193
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Open by File Name'
  Color = clGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 393
    Height = 137
    BevelWidth = 2
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 45
      Top = 16
      Width = 61
      Height = 13
      Caption = 'File Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 13
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
      Left = 246
      Top = 21
      Width = 102
      Height = 13
      Caption = '(Enter SIN as 9 digits)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object FlNameBox: TEdit
      Left = 121
      Top = 12
      Width = 121
      Height = 23
      TabOrder = 0
      Text = 'FlNameBox'
    end
    object DataDirBox: TEdit
      Left = 121
      Top = 52
      Width = 192
      Height = 23
      TabOrder = 1
      Text = 'DataDirBox'
    end
    object OKBtn: TBitBtn
      Left = 113
      Top = 88
      Width = 80
      Height = 33
      TabOrder = 2
      OnClick = OKBtnClick
      Kind = bkOK
    end
    object CancelBtn: TBitBtn
      Left = 209
      Top = 88
      Width = 80
      Height = 33
      TabOrder = 3
      OnClick = CancelBtnClick
      Kind = bkCancel
    end
  end
end
