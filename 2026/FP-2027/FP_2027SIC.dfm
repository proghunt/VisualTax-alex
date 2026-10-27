object SICFP_2012: TSICFP_2012
  Left = 56
  Top = 80
  Width = 586
  Height = 424
  Caption = 'Standard Industrial Classification (SIC) codes'
  Color = 15269887
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
  object Label1: TLabel
    Left = 21
    Top = 10
    Width = 390
    Height = 13
    Caption = 
      'Use the SIC codes in the preparation of Self-Employment Statemen' +
      'ts'
  end
  object Panel1: TPanel
    Left = 8
    Top = 24
    Width = 425
    Height = 361
    BevelOuter = bvLowered
    BevelWidth = 2
    BorderStyle = bsSingle
    TabOrder = 0
    object Outline1: TOutline
      Left = 14
      Top = 10
      Width = 395
      Height = 343
      Hint = 'Double click to select '
      OutlineStyle = osPlusMinusText
      ItemHeight = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      Color = clWhite
      TabOrder = 0
      OnDblClick = Outline1DblClick
      ItemSeparator = '\'
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
  end
  object Panel2: TPanel
    Left = 448
    Top = 82
    Width = 121
    Height = 239
    BevelWidth = 2
    BorderStyle = bsSingle
    TabOrder = 1
    object OkBtn: TBitBtn
      Left = 16
      Top = 98
      Width = 89
      Height = 33
      Caption = 'OK'
      TabOrder = 0
      OnClick = OkBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 16
      Top = 154
      Width = 89
      Height = 33
      Caption = 'Exit'
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object GroupBox1: TRadioGroup
      Left = 8
      Top = 20
      Width = 105
      Height = 53
      Caption = 'Show'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      Items.Strings = (
        'All expanded'
        'All collapsed')
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = GroupBox1Click
    end
  end
end
