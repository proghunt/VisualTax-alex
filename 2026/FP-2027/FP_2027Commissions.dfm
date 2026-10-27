object CommissionsFP_2012: TCommissionsFP_2012
  Left = 54
  Top = 66
  Caption = 'CommissionsFP_2012'
  ClientHeight = 495
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TBitBtn
    Left = 264
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 368
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object Panel1: TPanel
    Left = 232
    Top = 96
    Width = 545
    Height = 353
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 9
      Top = 9
      Width = 528
      Height = 328
      DataSource = TransactionsSrc
      FixedColor = 10930928
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
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
          Width = 65
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClientName'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ProductRt'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Status'
          PickList.Strings = (
            'WIP'
            'Hold'
            'HO Ready'
            'Xmitted'
            'Accepted'
            'Rejected'
            'Posted'
            'Settled'
            'Finished')
          Width = 38
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GrossAmount'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DealerCommission'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AgentPercent'
          Visible = True
        end>
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 25
    Width = 770
    Height = 56
    Align = alTop
    Color = 16777185
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    object GroupBox2: TGroupBox
      Left = 616
      Top = 8
      Width = 33
      Height = 41
      Caption = 'Account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 38
        Height = 13
        Caption = 'Supplier'
      end
      object Label2: TLabel
        Left = 80
        Top = 16
        Width = 24
        Height = 13
        Caption = 'Type'
      end
      object SupplierFilter: TEdit
        Left = 48
        Top = 16
        Width = 33
        Height = 21
        TabOrder = 0
      end
      object AccountTypeFilter: TComboBox
        Left = 112
        Top = 16
        Width = 89
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        Items.Strings = (
          'ALL'
          'OPEN'
          'RRSP'
          'RRIF'
          'RESP'
          'DPSP'
          'RHOSP'
          'OTHER'
          'LIF'
          'LIRA'
          'LRIF')
      end
    end
    object GroupBox4: TGroupBox
      Left = 328
      Top = 8
      Width = 257
      Height = 41
      Caption = 'Transaction'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Label6: TLabel
        Left = 136
        Top = 16
        Width = 30
        Height = 13
        Caption = 'Status'
      end
      object Label7: TLabel
        Left = 8
        Top = 16
        Width = 24
        Height = 13
        Caption = 'Type'
      end
      object StatusFilter: TComboBox
        Left = 168
        Top = 16
        Width = 81
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        Items.Strings = (
          'ALL'
          'WIP'
          'Hold'
          'HO Ready'
          'FS Ready'
          'Xmitted'
          'Accepted'
          'Rejected'
          'Posted'
          'Settled'
          'Finished')
      end
      object TransactionTypeFilter: TComboBox
        Left = 40
        Top = 16
        Width = 89
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        Items.Strings = (
          'ALL'
          '1  Reinvestments'
          '2  Distributions'
          '3  Cash distribution'
          '4  Fees'
          '5  Purhases/Switch-in'
          '6  Redemptions/Switch-out'
          '7  Share splits & consolidations'
          '8  External switches'
          '9  Certificate issued'
          '0  Certificates returned'
          'A  Average Cost - Fund company'
          'T2033'
          'T2151'
          'T2220')
      end
    end
    object GroupBox5: TGroupBox
      Left = 24
      Top = 8
      Width = 201
      Height = 41
      Caption = 'Trade Dates'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object Label8: TLabel
        Left = 112
        Top = 16
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object Label9: TLabel
        Left = 8
        Top = 16
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object DateFrom: TEdit
        Left = 40
        Top = 16
        Width = 65
        Height = 21
        TabOrder = 0
      end
      object DateTo: TEdit
        Left = 128
        Top = 16
        Width = 65
        Height = 21
        TabOrder = 1
      end
    end
    object FindBtn: TBitBtn
      Left = 48
      Top = 256
      Width = 75
      Height = 33
      Caption = 'Search'
      Glyph.Data = {
        46060000424D4606000000000000360400002800000018000000160000000100
        0800000000001002000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A4003F3F5F003F3F7F003F3F9F003F3FBF003F3FDF003F3FFF003F5F3F003F5F
        5F003F5F7F003F5F9F003F5FBF003F5FDF003F5FFF003F7F3F003F7F5F003F7F
        7F003F7F9F003F7FBF003F7FDF003F7FFF003F9F3F003F9F5F003F9F7F003F9F
        9F003F9FBF003F9FDF003F9FFF003FBF3F003FBF5F003FBF7F003FBF9F003FBF
        BF003FBFDF003FBFFF003FDF3F003FDF5F003FDF7F003FDF9F003FDFBF003FDF
        DF003FDFFF003FFF3F003FFF5F003FFF7F003FFF9F003FFFBF003FFFDF003FFF
        FF005F3F3F005F3F5F005F3F7F005F3F9F005F3FBF005F3FDF005F3FFF005F5F
        3F005F5F5F005F5F7F005F5F9F005F5FBF005F5FDF005F5FFF005F7F3F005F7F
        5F005F7F7F005F7F9F005F7FBF005F7FDF005F7FFF005F9F3F005F9F5F005F9F
        7F005F9F9F005F9FBF005F9FDF005F9FFF005FBF3F005FBF5F005FBF7F005FBF
        9F005FBFBF005FBFDF005FBFFF005FDF3F005FDF5F005FDF7F005FDF9F005FDF
        BF005FDFDF005FDFFF005FFF3F005FFF5F005FFF7F005FFF9F005FFFBF005FFF
        DF005FFFFF007F3F3F007F3F5F007F3F7F007F3F9F007F3FBF007F3FDF007F3F
        FF007F5F3F007F5F5F007F5F7F007F5F9F007F5FBF007F5FDF007F5FFF007F7F
        3F007F7F5F007F7F7F007F7F9F007F7FBF007F7FDF007F7FFF007F9F3F007F9F
        5F007F9F7F007F9F9F007F9FBF007F9FDF007F9FFF007FBF3F007FBF5F007FBF
        7F007FBF9F007FBFBF007FBFDF007FBFFF007FDF3F007FDF5F007FDF7F007FDF
        9F007FDFBF007FDFDF007FDFFF007FFF3F007FFF5F007FFF7F007FFF9F007FFF
        BF007FFFDF007FFFFF009F3F3F009F3F5F009F3F7F009F3F9F009F3FBF009F3F
        DF009F3FFF009F5F3F009F5F5F009F5F7F009F5F9F009F5FBF009F5FDF009F5F
        FF009F7F3F009F7F5F009F7F7F009F7F9F009F7FBF009F7FDF009F7FFF009F9F
        3F009F9F5F009F9F7F009F9F9F009F9FBF009F9FDF009F9FFF009FBF3F009FBF
        5F009FBF7F009FBF9F009FBFBF009FBFDF009FBFFF009FDF3F009FDF5F009FDF
        7F009FDF9F009FDFBF009FDFDF009FDFFF009FFF3F009FFF5F009FFF7F009FFF
        9F009FFFBF009FFFDF009FFFFF00BF3F3F00BF3F5F00BF3F7F00BF3F9F00BF3F
        BF00BF3FDF00BF3FFF00BF5F3F00BF5F5F00BF5F7F00BF5F9F00BF5FBF00BF5F
        DF00BF5FFF00BF7F3F00BF7F5F00BF7F7F00BF7F9F00BF7FBF00BF7FDF00BF7F
        FF00BF9F3F00BF9F5F00BF9F7F00BF9F9F00BF9FBF00BF9FDF00BF9FFF00BFBF
        3F00BFBF5F00BFBF7F00BFBF9F00BFBFBF00BFBFDF00BFBFFF00BFDF3F00BFDF
        5F00BFDF7F00BFDF9F00BFDFBF00BFDFDF00F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070700000007070707070000000707070707070707070707070700070007
        0707070700070007070707070707070707070707000000F80707077B00000007
        0707070707070707070707070000000000000000000000070707070707070707
        0707070700070000000007000000000707070707070707070707070700070000
        00000700000000070707070707F8000000000000000000000000000000000007
        070707070700FEFEFEFEFEFE00000000007B000000000707070707070700FEFE
        FEFEFEFEFEFE0000FE00070000070707070707070700FEFEFEFEFEFEFEFE0000
        FE00070000070707070707070700FEFEFEFEFEFEFEFE0000FE00070000070707
        070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707070707070700FEFE
        FEFEFEFEFEFEFEFEFE00070707070707070707070700FEFEFEFEFEFEFEFEFEFE
        FE00000707070707070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707
        0707070707000000FEFEFE000000000000F80707070707070707070707070700
        0000000707070707070707070707070707070707070707070707070707070707
        07070707070707070707}
      TabOrder = 3
    end
    object SearchBtn: TBitBtn
      Left = 696
      Top = 24
      Width = 49
      Height = 25
      Caption = 'Search'
      TabOrder = 4
      OnClick = SearchBtnClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 770
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Commissions'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object Panel2: TPanel
    Left = 0
    Top = 96
    Width = 225
    Height = 353
    TabOrder = 5
    object TreeView1: TTreeView
      Left = 8
      Top = 8
      Width = 209
      Height = 329
      HotTrack = True
      Indent = 19
      TabOrder = 0
      OnClick = TreeView1Click
    end
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 152
    Top = 160
  end
  object TransactionsSrc: TDataSource
    DataSet = TransactionsQ
    Left = 456
    Top = 248
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients.db')
    Left = 373
    Top = 241
  end
  object TransactionsQ: TADQuery
    OnCalcFields = TransactionsQCalcFields
    Connection = FDConnection
    SQL.Strings = (
      'Select * from transactions')
    Left = 428
    Top = 315
  end
  object Query1: TADQuery
    OnCalcFields = Query1CalcFields
    Connection = FDConnection
    SQL.Strings = (
      'Select *  from Agents a, BranchOffices b'
      'where a.Branch = b.branch '
      'ORDER BY b.BranchName, a.LastName')
    Left = 108
    Top = 219
  end
end
