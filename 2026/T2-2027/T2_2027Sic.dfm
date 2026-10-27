object SICT2_2027: TSICT2_2027
  Left = 272
  Top = 171
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'NAICS ( Industry Classification Codes)'
  ClientHeight = 783
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
    Left = 274
    Top = 8
    Width = 84
    Height = 13
    Caption = 'NAICS CODES'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 287
    Top = 35
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
    Top = 70
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
    Left = 70
    Top = 35
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
    Top = 45
    Width = 61
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = OkBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 568
    Top = 45
    Width = 57
    Height = 25
    Caption = 'Exit'
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object CodeEntered: TEdit
    Left = 287
    Top = 49
    Width = 92
    Height = 21
    MaxLength = 6
    TabOrder = 1
  end
  object KeyW: TEdit
    Left = 14
    Top = 49
    Width = 162
    Height = 21
    TabOrder = 0
    OnKeyPress = KeyWKeyPress
  end
  object FindBtn: TBitBtn
    Left = 189
    Top = 49
    Width = 57
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
    Left = 8
    Top = 89
    Width = 694
    Height = 692
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
