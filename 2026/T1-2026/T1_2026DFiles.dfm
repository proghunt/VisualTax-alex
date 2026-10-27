object DFilesT1_2026: TDFilesT1_2026
  Left = 218
  Top = 156
  Width = 509
  Height = 448
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'SomeCaption'
  Color = 13353398
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
  object ListBox1: TListBox
    Left = 0
    Top = 65
    Width = 501
    Height = 299
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 0
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 501
    Height = 25
    Align = alTop
    Caption = 'SomeCaption'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 501
    Height = 40
    Align = alTop
    Color = 15269887
    TabOrder = 2
    object FormLabel: TLabel
      Left = 8
      Top = 9
      Width = 397
      Height = 26
      Caption = 
        'FormLabel xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' +
        'xxxxxxxxxxxx'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 364
    Width = 501
    Height = 57
    Align = alBottom
    TabOrder = 3
    object SelectBtn: TBitBtn
      Left = 72
      Top = 16
      Width = 64
      Height = 33
      Caption = 'Select'
      TabOrder = 0
      OnClick = SelectBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 392
      Top = 16
      Width = 64
      Height = 33
      Caption = 'Exit'
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object AddNewBtn: TBitBtn
      Left = 144
      Top = 16
      Width = 72
      Height = 33
      Caption = 'Add New'
      TabOrder = 2
      OnClick = AddNewBtnClick
    end
    object DeleteBtn: TBitBtn
      Left = 224
      Top = 16
      Width = 56
      Height = 33
      Caption = 'Delete'
      TabOrder = 3
      OnClick = DeleteBtnClick
    end
    object DeleteAllBtn: TBitBtn
      Left = 296
      Top = 16
      Width = 89
      Height = 33
      Caption = 'Delete ALL...'
      TabOrder = 4
      OnClick = DeleteAllBtnClick
    end
  end
end
