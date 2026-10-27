object AdjustmentsReview: TAdjustmentsReview
  Left = 179
  Top = 126
  Width = 760
  Height = 496
  Caption = 'AdjustmentsReview'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 0
    Top = 0
    Width = 752
    Height = 24
    Align = alTop
    Alignment = taCenter
    Caption = 'Automatic Commission Adjustments'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 24
    Width = 752
    Height = 377
    Align = alTop
    Color = 14933196
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object EditBtn: TBitBtn
    Left = 272
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Edit...'
    TabOrder = 1
  end
  object CancelBtn: TBitBtn
    Left = 456
    Top = 424
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object AddBtn: TBitBtn
    Left = 152
    Top = 424
    Width = 91
    Height = 25
    Caption = 'Add an Agent'
    TabOrder = 3
  end
  object DeleteBtn: TBitBtn
    Left = 368
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Delete Entry'
    TabOrder = 4
  end
  object DataSource1: TDataSource
    Left = 240
    Top = 112
  end
end
