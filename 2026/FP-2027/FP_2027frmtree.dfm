object FrmTreeFP_2012: TFrmTreeFP_2012
  Left = 75
  Top = 76
  Caption = 'FP Forms Explorer - TABLE OF CONTENTS'
  ClientHeight = 424
  ClientWidth = 813
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label15: TLabel
    Left = 170
    Top = 21
    Width = 130
    Height = 13
    Caption = 'Find (Form or keyword)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 450
    Top = 21
    Width = 167
    Height = 13
    Caption = 'or double-click an item below'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    OnClick = CancelBtnClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 49
    Width = 959
    Height = 722
    Style = lbOwnerDrawFixed
    Color = clWhite
    Columns = 3
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = ListBox1Click
    OnDblClick = ListBox1DblClick
    OnDrawItem = ListBox1DrawItem
  end
  object CancelBtn: TBitBtn
    Left = 697
    Top = 14
    Width = 75
    Height = 25
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object FormBox: TEdit
    Left = 315
    Top = 21
    Width = 120
    Height = 21
    TabOrder = 0
    OnKeyPress = FormBoxKeyPress
  end
end
