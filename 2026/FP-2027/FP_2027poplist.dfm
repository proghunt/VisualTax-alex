object PopListFP_2012: TPopListFP_2012
  Left = 299
  Top = 150
  Width = 619
  Height = 503
  BorderIcons = [biSystemMenu]
  Color = 13353654
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
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 611
    Height = 353
    Align = alTop
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 0
    OnDblClick = ListBox1DblClick
    OnKeyPress = ListBox1KeyPress
  end
  object OKBtn: TBitBtn
    Left = 192
    Top = 360
    Width = 73
    Height = 33
    TabOrder = 1
    OnClick = OKBtnClick
    Kind = bkOK
  end
  object CancelBtn: TBitBtn
    Left = 312
    Top = 360
    Width = 89
    Height = 33
    TabOrder = 2
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
end
