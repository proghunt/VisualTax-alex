object PostTransactions: TPostTransactions
  Left = 165
  Top = 93
  Width = 689
  Height = 550
  Caption = 'PostTransactions'
  Color = 14933196
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 16
    Top = 376
    Width = 65
    Height = 16
    Caption = 'Error Log'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 681
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Post Settled transactions'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object PostTransactionsBtn: TBitBtn
    Left = 232
    Top = 488
    Width = 153
    Height = 25
    Caption = 'Post transactions to B/S'
    TabOrder = 1
  end
  object CancelBtn: TBitBtn
    Left = 408
    Top = 488
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    Kind = bkCancel
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 88
    Width = 649
    Height = 289
    DataSource = TransactionsSrc
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'TradeDate'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TransType'
        Width = 199
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Status'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Product'
        Width = 52
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TransactionId'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Units'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NetAmount'
        Width = 69
        Visible = True
      end>
  end
  object ListBox1: TListBox
    Left = 16
    Top = 392
    Width = 649
    Height = 89
    ItemHeight = 13
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 681
    Height = 57
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 5
    object GroupBox1: TGroupBox
      Left = 160
      Top = 8
      Width = 321
      Height = 41
      Caption = 'Trade dates'
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label2: TLabel
        Left = 144
        Top = 24
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object FromDtBox: TEdit
        Left = 48
        Top = 16
        Width = 81
        Height = 21
        TabOrder = 0
        Text = 'FromDtBox'
      end
      object ToDtBox: TEdit
        Left = 168
        Top = 16
        Width = 89
        Height = 21
        TabOrder = 1
        Text = 'ToDtBox'
      end
    end
  end
  object TransactionsSrc: TDataSource
    Left = 80
    Top = 176
  end
  object AssetsSrc: TDataSource
    Left = 304
    Top = 160
  end
  object DataSource1: TDataSource
    Left = 480
    Top = 152
  end
end
