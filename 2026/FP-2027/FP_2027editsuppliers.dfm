object EditSuppliers: TEditSuppliers
  Left = 79
  Top = 72
  Width = 654
  Height = 521
  Caption = 'Suppliers'
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
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 528
    Height = 408
    DataSource = SupplierDs
    FixedColor = 10930928
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 528
    Top = 41
    Width = 118
    Height = 453
    Align = alRight
    TabOrder = 1
    object OKBtn: TBitBtn
      Left = 24
      Top = 136
      Width = 65
      Height = 25
      Caption = 'Save'
      TabOrder = 0
    end
    object CancelBtn: TBitBtn
      Left = 24
      Top = 200
      Width = 65
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
    object SelectedItem: TEdit
      Left = 24
      Top = 272
      Width = 65
      Height = 21
      TabOrder = 2
      Text = 'SelectedItem'
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 646
    Height = 41
    Align = alTop
    Caption = 'Edit Suppliers'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object DBNavigator1: TDBNavigator
    Left = 88
    Top = 456
    Width = 360
    Height = 25
    DataSource = SupplierDs
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete]
    TabOrder = 3
  end
  object SupplierDs: TDataSource
    Left = 120
    Top = 168
  end
end
