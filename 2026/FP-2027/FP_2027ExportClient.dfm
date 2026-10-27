object ExportClient: TExportClient
  Left = 70
  Top = 43
  Width = 636
  Height = 545
  Caption = 'ExportClient'
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
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 628
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Export Client data  (Replication)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Memox: TMemo
    Left = 0
    Top = 33
    Width = 628
    Height = 120
    Align = alTop
    Color = 15138815
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'The exported data can be imported later into the data base of an' +
        'other office or head office. It includes ALL '
      
        'data for a given client (such as Financial Plan, Transactions, A' +
        'ccounts, etc).'
      ''
      
        'The import function is a complete replacement of data of the sam' +
        'e client in another office.'
      
        'The receiving office cannot process it unles the client is delet' +
        'ed first.'
      
        'This facility should be used to populate the data base in anothe' +
        'r office or to copy client data from one data '
      'base to another.'
      'Data can be sent to another office by modem or disk.')
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 153
    Width = 393
    Height = 365
    Align = alLeft
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 1
      Top = 57
      Width = 391
      Height = 312
      Align = alTop
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'LastName'
          Width = 91
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FirstName'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AgentCode'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClientId'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClientStatus'
          Visible = True
        end>
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 1
      Width = 391
      Height = 56
      Align = alTop
      Caption = 'Show'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Label1: TLabel
        Left = 176
        Top = 24
        Width = 31
        Height = 13
        Caption = 'Agent:'
      end
      object AllClientsBtn: TBitBtn
        Left = 86
        Top = 16
        Width = 59
        Height = 25
        Caption = 'All'
        TabOrder = 0
      end
      object SelectClientBtn: TBitBtn
        Left = 8
        Top = 16
        Width = 57
        Height = 25
        Caption = 'Select...'
        TabOrder = 1
      end
      object AgentBox: TComboBox
        Left = 224
        Top = 16
        Width = 65
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
      end
    end
  end
  object Panel2: TPanel
    Left = 393
    Top = 153
    Width = 225
    Height = 365
    Align = alLeft
    TabOrder = 3
    object Label4: TLabel
      Left = 60
      Top = 40
      Width = 101
      Height = 13
      Caption = 'Destinanion Directory'
    end
    object ExportOneBtn: TBitBtn
      Left = 48
      Top = 128
      Width = 145
      Height = 25
      Caption = 'Export selected client'
      TabOrder = 0
    end
    object CancelBtn: TBitBtn
      Left = 48
      Top = 248
      Width = 145
      Height = 25
      Caption = 'Exit'
      TabOrder = 1
      Kind = bkCancel
    end
    object FilesOutBox: TEdit
      Left = 24
      Top = 56
      Width = 185
      Height = 21
      TabOrder = 2
    end
    object ExportAllBtn: TBitBtn
      Left = 48
      Top = 184
      Width = 145
      Height = 25
      Caption = 'Export ALL clients shown'
      TabOrder = 3
    end
  end
  object DBMemo1: TDBMemo
    Left = 13
    Top = 440
    Width = 668
    Height = 38
    Color = clYellow
    DataField = 'OtherData'
    DataSource = DataSource1
    ScrollBars = ssVertical
    TabOrder = 4
    Visible = False
  end
  object DataSource1: TDataSource
    Left = 136
    Top = 288
  end
end
