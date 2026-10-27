object RestructureT1_2026: TRestructureT1_2026
  Left = 63
  Top = 131
  Caption = 'RestructureT1_2026'
  ClientHeight = 550
  ClientWidth = 790
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 64
    Width = 206
    Height = 16
    Caption = 'Data Base Modification Script'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 368
    Width = 218
    Height = 16
    Caption = 'Data Base Modification Results'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 16
    Top = 80
    Width = 761
    Height = 273
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '{You can enter and run any SQL here)')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object FileBox: TEdit
    Left = 16
    Top = 40
    Width = 225
    Height = 21
    TabOrder = 1
    Text = 'FileBox'
  end
  object LoadBtn1: TBitBtn
    Left = 248
    Top = 40
    Width = 145
    Height = 33
    Caption = 'Load restructure Script'
    TabOrder = 2
    OnClick = LoadBtn1Click
  end
  object CancelBtn: TBitBtn
    Left = 648
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object RunBtn: TBitBtn
    Left = 398
    Top = 40
    Width = 73
    Height = 33
    Caption = 'Run Script'
    TabOrder = 4
    OnClick = RunBtnClick
  end
  object ClearListBtn: TBitBtn
    Left = 565
    Top = 40
    Width = 75
    Height = 33
    Caption = 'Clear Script'
    TabOrder = 5
    OnClick = ClearListBtnClick
  end
  object SaveBtn: TBitBtn
    Left = 478
    Top = 40
    Width = 76
    Height = 33
    Caption = 'Save script'
    TabOrder = 6
    OnClick = SaveBtnClick
  end
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 790
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Clients Data Base restructure '
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object ListBox1: TListBox
    Left = 16
    Top = 392
    Width = 753
    Height = 121
    Color = 15400959
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 8
  end
  object LoadBtn2: TBitBtn
    Left = 768
    Top = 40
    Width = 17
    Height = 33
    Caption = 'Load FundData restructure script'
    TabOrder = 9
    Visible = False
    OnClick = LoadBtn2Click
  end
  object DbBox: TRadioGroup
    Left = 744
    Top = 40
    Width = 25
    Height = 33
    Caption = 'Data Base affected'
    Columns = 2
    Items.Strings = (
      'FpClients'
      'FundData')
    TabOrder = 10
    Visible = False
  end
  object SaveDialog1: TSaveDialog
    Left = 440
    Top = 184
  end
end
