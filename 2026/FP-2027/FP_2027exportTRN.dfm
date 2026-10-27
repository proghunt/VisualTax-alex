object ExportTRNFP_2012: TExportTRNFP_2012
  Left = 52
  Top = 56
  BorderStyle = bsDialog
  Caption = 'Export FS Order Feedback to Branches or Remote Agents'
  ClientHeight = 491
  ClientWidth = 740
  Color = 13815225
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label2: TLabel
    Left = 56
    Top = 488
    Width = 133
    Height = 15
    Caption = 'Set FsToBranch flag to Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label4: TLabel
    Left = 8
    Top = 456
    Width = 118
    Height = 15
    Caption = 'Destinanion Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object SetForSelectedBtn: TBitBtn
    Left = 200
    Top = 480
    Width = 161
    Height = 25
    Caption = 'Selectted transaction only'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnClick = SetForSelectedBtnClick
  end
  object SetForAllBtn: TBitBtn
    Left = 368
    Top = 480
    Width = 249
    Height = 25
    Caption = 'ALL listed transactions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Visible = False
    OnClick = SetForAllBtnClick
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 740
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Export FundServ responses to Branches or Agents (TRN file)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object CancelBtn: TBitBtn
    Left = 624
    Top = 432
    Width = 81
    Height = 33
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    Margin = 2
    NumGlyphs = 2
    ParentFont = False
    Spacing = -1
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 740
    Height = 368
    Align = alTop
    TabOrder = 4
    object DBGrid2: TDBGrid
      Left = 1
      Top = 57
      Width = 738
      Height = 304
      Align = alTop
      DataSource = TransactionsQSrc
      FixedColor = 10930928
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Arial'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'TransactionId'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClientName'
          Width = 134
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Product'
          Title.Caption = 'Fund'
          Width = 59
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TransType'
          Width = 84
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GrossAmount'
          Title.Caption = 'Gross'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NetAmount'
          Title.Caption = 'Net'
          Width = 57
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LastUpdate'
          Width = 78
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Status'
          Width = 59
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FsToBranch'
          Visible = True
        end>
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 738
      Height = 56
      Align = alTop
      Color = 13815225
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object GroupBox5: TGroupBox
        Left = 152
        Top = 7
        Width = 337
        Height = 42
        Caption = 'Dates'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label8: TLabel
          Left = 184
          Top = 16
          Width = 13
          Height = 13
          Caption = 'To'
        end
        object Label9: TLabel
          Left = 32
          Top = 16
          Width = 23
          Height = 13
          Caption = 'From'
        end
        object DateFrom: TEdit
          Left = 64
          Top = 16
          Width = 65
          Height = 21
          TabOrder = 0
          OnDblClick = DateFromDblClick
          OnKeyPress = DateFromKeyPress
        end
        object DateTo: TEdit
          Left = 208
          Top = 16
          Width = 65
          Height = 21
          TabOrder = 1
          OnDblClick = DateToDblClick
          OnExit = DateToExit
          OnKeyPress = DateToKeyPress
        end
      end
    end
  end
  object OKBtn: TBitBtn
    Left = 544
    Top = 432
    Width = 65
    Height = 33
    Caption = 'Export all'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = OKBtnClick
  end
  object FilesOutBox: TEdit
    Left = 128
    Top = 448
    Width = 233
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object DealerOrBranchBox: TRadioGroup
    Left = 24
    Top = 408
    Width = 337
    Height = 33
    Caption = 'Export to'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'Dealer to Branches'
      'Branch to remote Agents')
    ParentFont = False
    TabOrder = 7
  end
  object DBMemo1: TDBMemo
    Left = 21
    Top = 328
    Width = 668
    Height = 38
    Color = clYellow
    DataField = 'OtherData'
    DataSource = ClientsSource
    ScrollBars = ssVertical
    TabOrder = 8
    Visible = False
  end
  object ExportOneBtn: TBitBtn
    Left = 368
    Top = 432
    Width = 169
    Height = 33
    Caption = 'Export selected transaction'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = ExportOneBtnClick
  end
  object TransactionsQSrc: TDataSource
    DataSet = TransactionsQ
    Left = 104
    Top = 208
  end
  object ClientsSource: TDataSource
    DataSet = ClientsTbl
    Left = 224
    Top = 289
  end
  object AccountsSrc: TDataSource
    DataSet = AccountsTbl
    Left = 400
    Top = 225
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients')
    Left = 261
    Top = 137
  end
  object TransactionsQ: TADQuery
    OnCalcFields = TransactionsQCalcFields
    Connection = FDConnection
    SQL.Strings = (
      'Select * from Transactions')
    Left = 148
    Top = 203
  end
  object TransactionsExportQ: TADQuery
    Connection = FDConnection
    Left = 252
    Top = 203
  end
  object AccountsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Accounts'
    TableName = 'Accounts'
    Left = 356
    Top = 176
  end
  object ClientsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'CLIENTS'
    TableName = 'CLIENTS'
    Left = 180
    Top = 280
  end
end
