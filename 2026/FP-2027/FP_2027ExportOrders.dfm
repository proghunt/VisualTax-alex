object ExportOrdersFP_2012: TExportOrdersFP_2012
  Left = 29
  Top = 44
  BorderStyle = bsDialog
  Caption = 'Export Orders'
  ClientHeight = 506
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label2: TLabel
    Left = 472
    Top = 448
    Width = 141
    Height = 15
    Caption = 'Set status to '#39'Transmitted'#39
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 0
    Top = 472
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
  object Label5: TLabel
    Left = 64
    Top = 456
    Width = 57
    Height = 15
    Caption = 'File Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object SetForSelectedBtn: TBitBtn
    Left = 392
    Top = 464
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
    OnClick = SetForSelectedBtnClick
  end
  object SetForAllBtn: TBitBtn
    Left = 560
    Top = 464
    Width = 161
    Height = 25
    Caption = 'ALL listed transactions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = SetForAllBtnClick
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 738
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Export Orders (Branch to Dealer or Agent to the Branch Office)'
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
    Left = 560
    Top = 408
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
    Width = 738
    Height = 368
    Align = alTop
    TabOrder = 4
    object DBGrid2: TDBGrid
      Left = 1
      Top = 25
      Width = 736
      Height = 328
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
          Width = 148
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Product'
          Title.Caption = 'Fund'
          Width = 52
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
        end>
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 736
      Height = 24
      Align = alTop
      Caption = 'HO Ready orders (not transmitted yet)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object OKBtn: TBitBtn
    Left = 456
    Top = 408
    Width = 81
    Height = 33
    Caption = 'Export all'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object FilesOutBox: TEdit
    Left = 128
    Top = 472
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
  object FlNameBox: TEdit
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
    TabOrder = 7
  end
  object DealerOrBranchBox: TRadioGroup
    Left = 128
    Top = 408
    Width = 233
    Height = 33
    Caption = 'Export to'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'Dealer'
      'Agent'#39's Branch')
    ParentFont = False
    TabOrder = 8
  end
  object DBMemo1: TDBMemo
    Left = 13
    Top = 328
    Width = 668
    Height = 38
    Color = clYellow
    DataField = 'OtherData'
    DataSource = ClientsSource
    ScrollBars = ssVertical
    TabOrder = 9
    Visible = False
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
  object TransactionsQ: TADQuery
    OnCalcFields = TransactionsQCalcFields
    Connection = FDConnection
    SQL.Strings = (
      'Select * from Transactions')
    Left = 148
    Top = 187
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients')
    Left = 197
    Top = 105
  end
  object AccountsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Accounts'
    TableName = 'Accounts'
    Left = 364
    Top = 192
  end
  object TransactionsExportQ: TADQuery
    OnCalcFields = TransactionsQCalcFields
    Connection = FDConnection
    SQL.Strings = (
      'Select * from Transactions')
    Left = 268
    Top = 179
  end
  object ClientsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'CLIENTS'
    TableName = 'CLIENTS'
    Left = 188
    Top = 264
  end
end
