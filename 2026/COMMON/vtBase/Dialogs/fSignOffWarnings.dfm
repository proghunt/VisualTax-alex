object SignOffWarnings: TSignOffWarnings
  Left = 625
  Top = 353
  Width = 686
  Height = 480
  Caption = 'SignOffWarnings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 678
    Height = 25
    Align = alTop
    Caption = 'Sign-off Warnings'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object ListBox1: TListBox
    Left = 7
    Top = 70
    Width = 659
    Height = 316
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    MultiSelect = True
    ParentFont = False
    TabOrder = 1
    OnDblClick = ListBox1DblClick
  end
  object AllBtn: TBitBtn
    Left = 595
    Top = 399
    Width = 22
    Height = 25
    Caption = 'All'
    TabOrder = 2
    Visible = False
    OnClick = AllBtnClick
  end
  object OneOnlyBtn: TBitBtn
    Left = 28
    Top = 399
    Width = 85
    Height = 25
    Caption = 'Sign Off'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = OneOnlyBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 497
    Top = 399
    Width = 75
    Height = 25
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 49
    Top = 28
    Width = 541
    Height = 20
    Caption = 
      'Signed off warnings will be listed at the '#39'Signed-off'#39' messages ' +
      'at the end of the Audit Wizard'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object StaticText2: TStaticText
    Left = 161
    Top = 49
    Width = 272
    Height = 20
    Caption = 'Double click on the message to be signed-off'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object ReverseSignOffBtn: TBitBtn
    Left = 273
    Top = 399
    Width = 204
    Height = 25
    Caption = 'Reverse all signed-off warnings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = ReverseSignOffBtnClick
  end
  object LocateFormBtn: TBitBtn
    Left = 126
    Top = 399
    Width = 134
    Height = 25
    Caption = 'Locate form in error'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = LocateFormBtnClick
  end
end
