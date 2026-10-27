object SICT1_2026: TSICT1_2026
  Left = 272
  Top = 171
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'NAICS ( Industry Classification Codes)'
  ClientHeight = 788
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 141
    Top = 2
    Width = 338
    Height = 13
    Caption = 
      'Use the NAICS codes in the preparation of Self-Employment Statem' +
      'ents'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 287
    Top = 28
    Width = 95
    Height = 13
    Caption = 'Enter code if known'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 287
    Top = 63
    Width = 105
    Height = 13
    Caption = 'or select from list lelow'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 35
    Top = 28
    Width = 77
    Height = 13
    Caption = 'Find by keyword'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object OkBtn: TBitBtn
    Left = 490
    Top = 38
    Width = 61
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 568
    Top = 38
    Width = 57
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object CodeEntered: TEdit
    Left = 287
    Top = 42
    Width = 92
    Height = 21
    MaxLength = 6
    TabOrder = 0
  end
  object KeyW: TEdit
    Left = 14
    Top = 42
    Width = 141
    Height = 21
    TabOrder = 3
    OnKeyPress = KeyWKeyPress
  end
  object FindBtn: TBitBtn
    Left = 161
    Top = 42
    Width = 75
    Height = 25
    Caption = 'Find'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = FindBtnClick
  end
  object ListBox1: TListBox
    Left = 14
    Top = 84
    Width = 694
    Height = 701
    Hint = 'Double click a code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnDblClick = ListBox1DblClick
  end
end
