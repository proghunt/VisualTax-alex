object RestructureFP_2012: TRestructureFP_2012
  Left = 28
  Top = 114
  Caption = 'RestructureFP_2012'
  ClientHeight = 533
  ClientWidth = 775
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
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
    Top = 360
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
    Height = 241
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
    Width = 177
    Height = 33
    Caption = 'Load FPclients restructure Script'
    TabOrder = 2
    OnClick = LoadBtn1Click
  end
  object CancelBtn: TBitBtn
    Left = 584
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object RunBtn: TBitBtn
    Left = 40
    Top = 328
    Width = 97
    Height = 25
    Caption = 'Run Script'
    TabOrder = 4
    OnClick = RunBtnClick
  end
  object ClearListBtn: TBitBtn
    Left = 160
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Clear Script'
    TabOrder = 5
    OnClick = ClearListBtnClick
  end
  object SaveBtn: TBitBtn
    Left = 256
    Top = 328
    Width = 121
    Height = 25
    Caption = 'Save your own Script'
    TabOrder = 6
    OnClick = SaveBtnClick
  end
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 775
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'FP Clients Data Base restructure '
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    ExplicitWidth = 783
  end
  object ListBox1: TListBox
    Left = 16
    Top = 384
    Width = 753
    Height = 153
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
  object FundCodeLengthBtn: TBitBtn
    Left = 408
    Top = 328
    Width = 153
    Height = 25
    Caption = 'Revise FundCode Length'
    TabOrder = 9
    Visible = False
    OnClick = FundCodeLengthBtnClick
  end
  object LoadBtn2: TBitBtn
    Left = 432
    Top = 40
    Width = 169
    Height = 33
    Caption = 'Load FundData restructure script'
    TabOrder = 10
    OnClick = LoadBtn2Click
  end
  object DbBox: TRadioGroup
    Left = 616
    Top = 40
    Width = 153
    Height = 33
    Caption = 'Data Base affected'
    Columns = 2
    Items.Strings = (
      'FpClients'
      'FundData')
    TabOrder = 11
  end
  object SaveDialog1: TSaveDialog
    Left = 448
    Top = 240
  end
end
