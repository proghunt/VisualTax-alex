object SetPgmPsw: TSetPgmPsw
  Left = 219
  Top = 174
  Width = 363
  Height = 214
  Caption = 'Memorize your password!'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 64
    Top = 56
    Width = 114
    Height = 16
    Caption = 'Program password'
  end
  object Label2: TLabel
    Left = 56
    Top = 80
    Width = 123
    Height = 16
    Caption = 'Confirm (enter again)'
  end
  object HeaderPanel: TPanel
    Left = 0
    Top = 0
    Width = 355
    Height = 33
    Hint = 'Click to change tax year and rates'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Set program password'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 160
    Top = 48
    Width = 121
    Height = 24
    PasswordChar = '*'
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 112
    Top = 128
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 160
    Top = 80
    Width = 121
    Height = 24
    PasswordChar = '*'
    TabOrder = 2
    Text = 'Edit1'
  end
  object BitBtn1: TBitBtn
    Left = 200
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 4
    OnClick = BitBtn1Click
    Kind = bkCancel
  end
end
