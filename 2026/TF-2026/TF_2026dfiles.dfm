object DFilesTF_2026: TDFilesTF_2026
  Left = 182
  Top = 49
  Width = 438
  Height = 456
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FormLabel: TLabel
    Left = 8
    Top = 33
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
  object ListBox1: TListBox
    Left = 16
    Top = 72
    Width = 393
    Height = 305
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
  object SelectBtn: TBitBtn
    Left = 24
    Top = 384
    Width = 64
    Height = 33
    Caption = 'Select'
    TabOrder = 1
    OnClick = SelectBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 344
    Top = 384
    Width = 64
    Height = 33
    Caption = 'Exit'
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object AddNewBtn: TBitBtn
    Left = 96
    Top = 384
    Width = 72
    Height = 33
    Caption = 'Add New'
    TabOrder = 3
    OnClick = AddNewBtnClick
  end
  object DeleteBtn: TBitBtn
    Left = 176
    Top = 384
    Width = 56
    Height = 33
    Caption = 'Delete'
    TabOrder = 4
    OnClick = DeleteBtnClick
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 430
    Height = 25
    Align = alTop
    Caption = 'SomeCaption'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object DeleteAllBtn: TBitBtn
    Left = 248
    Top = 384
    Width = 89
    Height = 33
    Caption = 'Delete ALL...'
    TabOrder = 6
    OnClick = DeleteAllBtnClick
  end
end
