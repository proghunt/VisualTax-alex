object ReturnPasswordT3_2026: TReturnPasswordT3_2026
  Left = 226
  Top = 207
  Width = 369
  Height = 85
  Caption = 'Return Password'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 16
    Width = 121
    Height = 13
    Caption = 'Enter the return password'
  end
  object Edit1: TEdit
    Left = 192
    Top = 16
    Width = 81
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
end
