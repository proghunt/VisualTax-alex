object SICT4T5_2026: TSICT4T5_2026
  Left = 128
  Top = 151
  Width = 602
  Height = 534
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'NAICS ( Industry Classification Codes)'
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
  OnPaint = FormPaint
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
  object GroupBox1: TRadioGroup
    Left = 96
    Top = 20
    Width = 225
    Height = 37
    Caption = 'Show'
    Color = clBtnFace
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ItemIndex = 1
    Items.Strings = (
      'All expanded'
      'All collapsed')
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnClick = GroupBox1Click
  end
  object OkBtn: TBitBtn
    Left = 368
    Top = 24
    Width = 57
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 456
    Top = 24
    Width = 57
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object Outline1: TOutline
    Left = 8
    Top = 64
    Width = 569
    Height = 431
    Hint = 'Click to select and then click on OK'
    OutlineStyle = osPlusMinusText
    ItemHeight = 14
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Color = clWhite
    TabOrder = 3
    OnDblClick = Outline1DblClick
    ItemSeparator = '\'
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
end
