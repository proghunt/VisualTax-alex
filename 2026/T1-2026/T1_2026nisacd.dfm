object NISACDT1_2026: TNISACDT1_2026
  Left = 127
  Top = 133
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'NISA CODES'
  ClientHeight = 430
  ClientWidth = 707
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 408
    Top = 8
    Width = 185
    Height = 41
    BevelOuter = bvSpace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object OkBtn: TBitBtn
      Left = 16
      Top = 8
      Width = 57
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = OkBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 104
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Exit'
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object GroupBox1: TRadioGroup
    Left = 112
    Top = 8
    Width = 249
    Height = 41
    Caption = 'Show'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    Items.Strings = (
      'All expanded'
      'All collapsed')
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    OnClick = GroupBox1Click
  end
  object Outline1: TOutline
    Left = 10
    Top = 54
    Width = 687
    Height = 379
    Hint = 'Click to select and then click on OK'
    OutlineStyle = osPlusMinusText
    ItemHeight = 14
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Color = clWhite
    TabOrder = 2
    ItemSeparator = '\'
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
end
