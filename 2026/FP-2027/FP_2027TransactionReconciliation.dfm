object TransactionReconciliationFP_2012: TTransactionReconciliationFP_2012
  Left = 20
  Top = 48
  Caption = 'Transaction Reconciliation'
  ClientHeight = 509
  ClientWidth = 770
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
  object Label3: TLabel
    Left = 224
    Top = 32
    Width = 97
    Height = 16
    Caption = 'Processing Log'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ProcessLbl: TLabel
    Left = 16
    Top = 448
    Width = 513
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CancelBtn: TBitBtn
    Left = 632
    Top = 248
    Width = 81
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
  object OkBtn: TBitBtn
    Left = 632
    Top = 208
    Width = 81
    Height = 25
    Caption = 'START'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 54
    Width = 609
    Height = 377
    ItemHeight = 13
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 770
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Transaction Reconciliation ('#39'T'#39' File)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 656
    Top = 304
    Width = 33
    Height = 25
    Lines.Strings = (
      'Mem'
      'o1')
    TabOrder = 4
    Visible = False
  end
  object ProgressBar1: TProgressBar
    Left = 24
    Top = 480
    Width = 497
    Height = 16
    TabOrder = 5
  end
  object AddDealerTransBox: TCheckBox
    Left = 632
    Top = 184
    Width = 137
    Height = 17
    Caption = 'Add dealer transactions'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object Panel1: TPanel
    Left = 632
    Top = 56
    Width = 137
    Height = 65
    TabOrder = 7
    Visible = False
    object Label4: TLabel
      Left = 24
      Top = 24
      Width = 100
      Height = 13
      Caption = 'Only Process Client : '
      Visible = False
    end
    object Label1: TLabel
      Left = 152
      Top = 8
      Width = 51
      Height = 13
      Caption = 'Last Name'
      Visible = False
    end
    object Label2: TLabel
      Left = 344
      Top = 8
      Width = 50
      Height = 13
      Caption = 'First Name'
      Visible = False
    end
    object ThisLastNameBox: TEdit
      Left = 128
      Top = 24
      Width = 193
      Height = 21
      TabOrder = 0
      Visible = False
    end
    object ThisFirstNameBox: TEdit
      Left = 336
      Top = 24
      Width = 145
      Height = 21
      TabOrder = 1
      Visible = False
    end
    object ShowMissingAgentsBtn: TBitBtn
      Left = 496
      Top = 24
      Width = 81
      Height = 25
      Caption = 'Add Agents'
      TabOrder = 2
      Visible = False
      OnClick = ShowMissingAgentsBtnClick
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientsTbl
    Left = 384
    Top = 80
  end
  object DataSource2: TDataSource
    DataSet = TransactionsTbl
    Left = 384
    Top = 128
  end
  object DataSource3: TDataSource
    DataSet = AccountsTbl
    Left = 392
    Top = 176
  end
  object DataSource4: TDataSource
    DataSet = AgentsTbl
    Left = 392
    Top = 224
  end
  object ClientsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'CLIENTS'
    TableName = 'CLIENTS'
    Left = 292
    Top = 88
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients')
    Left = 253
    Top = 89
  end
  object TransactionsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Transactions'
    TableName = 'Transactions'
    Left = 292
    Top = 128
  end
  object AccountsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Accounts'
    TableName = 'Accounts'
    Left = 284
    Top = 176
  end
  object AgentsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Agents'
    TableName = 'Agents'
    Left = 292
    Top = 232
  end
end
