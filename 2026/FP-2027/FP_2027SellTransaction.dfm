object SellTransactionFP_2012: TSellTransactionFP_2012
  Left = 235
  Top = 48
  Caption = 'Redemption Form'
  ClientHeight = 505
  ClientWidth = 398
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
  object Label2: TLabel
    Left = 0
    Top = 0
    Width = 398
    Height = 24
    Align = alTop
    Alignment = taCenter
    Caption = 'Fund Redemption'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ExplicitWidth = 160
  end
  object Panel2: TPanel
    Left = 24
    Top = 32
    Width = 361
    Height = 449
    TabOrder = 0
    object Label5: TLabel
      Left = 16
      Top = 56
      Width = 40
      Height = 13
      Caption = 'Account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 16
      Top = 120
      Width = 36
      Height = 13
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 16
      Top = 76
      Width = 36
      Height = 13
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 16
      Top = 88
      Width = 24
      Height = 13
      Caption = 'Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 16
      Top = 32
      Width = 37
      Height = 13
      Caption = 'Product'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 128
      Top = 344
      Width = 81
      Height = 13
      Caption = 'Redeemed funds'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object PayeeBox: TRadioGroup
      Left = 48
      Top = 152
      Width = 169
      Height = 41
      Caption = 'Payee Indicator'
      Columns = 2
      Items.Strings = (
        'Dealer'
        'Client')
      TabOrder = 0
    end
    object AccountBox: TEdit
      Left = 64
      Top = 48
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object AmountBox: TEdit
      Left = 64
      Top = 112
      Width = 81
      Height = 21
      TabOrder = 2
    end
    object AmountTypeBox: TComboBox
      Left = 64
      Top = 80
      Width = 169
      Height = 21
      TabOrder = 3
      Items.Strings = (
        'A   All shares/units'
        'D   Dollars'
        'F   All shares/units not subject to DSC (also known as M+T free)'
        'M   Matured shares/units only'
        'P   Percentage of shares/units owned'
        'S   Shares/units'
        
          'T   Shares/units allowed to be redeemed, not subject to DSC, and' +
          ' excluding matured shares/units ')
    end
    object ProductBox: TEdit
      Left = 64
      Top = 24
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object SelectBtn: TBitBtn
      Left = 192
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Select...'
      TabOrder = 5
      OnClick = SelectBtnClick
    end
    object ListBox1: TListBox
      Left = 32
      Top = 368
      Width = 289
      Height = 65
      Color = 15138815
      Enabled = False
      ItemHeight = 13
      TabOrder = 6
    end
    object GroupBox2: TGroupBox
      Left = 24
      Top = 208
      Width = 321
      Height = 81
      TabOrder = 7
      object Label11: TLabel
        Left = 56
        Top = 20
        Width = 30
        Height = 13
        Caption = 'Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object CancelBtn: TBitBtn
        Left = 152
        Top = 48
        Width = 73
        Height = 25
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Kind = bkCancel
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 0
        OnClick = CancelBtnClick
      end
      object SelectedItem: TEdit
        Left = 8
        Top = 376
        Width = 65
        Height = 21
        TabOrder = 1
        Text = 'SelectedItem'
        Visible = False
      end
      object OkBtn: TBitBtn
        Left = 40
        Top = 48
        Width = 75
        Height = 25
        Caption = 'OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = OKBtnClick
      end
      object StatusBox: TComboBox
        Left = 104
        Top = 16
        Width = 105
        Height = 21
        TabOrder = 3
        Text = 'StatusBox'
        Items.Strings = (
          'WIP'
          'Hold'
          'HO Ready'
          'Xmitted'
          'Accepted'
          'Rejected'
          'Posted'
          'Settled'
          'Finished')
      end
    end
  end
  object DataSource2: TDataSource
    DataSet = TransactionsTbl
    Left = 344
    Top = 176
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients')
    Left = 293
    Top = 73
  end
  object TransactionsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Transactions'
    TableName = 'Transactions'
    Left = 338
    Top = 72
  end
end
