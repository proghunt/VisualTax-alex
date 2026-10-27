object SICT3_2026: TSICT3_2026
  Left = 128
  Top = 151
  ActiveControl = Outline1
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'NAICS ( Industry Classification Codes)'
  ClientHeight = 514
  ClientWidth = 590
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
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 584
    Height = 16
    Align = alTop
    Alignment = taCenter
    Caption = 
      'Use the NAICS codes in the preparation of Self-Employment Statem' +
      'ents'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 425
  end
  object Outline1: TOutline
    Left = 0
    Top = 61
    Width = 590
    Height = 453
    Hint = 'Click to select and then click on OK'
    OutlineStyle = osPlusMinusText
    ItemHeight = 14
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Color = clWhite
    TabOrder = 0
    OnDblClick = Outline1DblClick
    OnKeyDown = Outline1KeyDown
    OnKeyPress = Outline1KeyPress
    ItemSeparator = '\'
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 22
    Width = 590
    Height = 39
    Align = alTop
    TabOrder = 1
    DesignSize = (
      590
      39)
    object CancelBtn: TBitBtn
      Left = 497
      Top = 9
      Width = 81
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Exit'
      TabOrder = 0
      OnClick = CancelBtnClick
    end
    object GroupBox1: TRadioGroup
      Left = 1
      Top = 1
      Width = 225
      Height = 37
      Align = alLeft
      Caption = 'Show'
      Color = clBtnFace
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'All expanded'
        'All collapsed')
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnClick = GroupBox1Click
    end
    object OkBtn: TBitBtn
      Left = 393
      Top = 9
      Width = 81
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      TabOrder = 2
      OnClick = OkBtnClick
    end
  end
end
