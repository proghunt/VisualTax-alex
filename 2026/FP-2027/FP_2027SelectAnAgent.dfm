object SelectAnAgentFP_2012: TSelectAnAgentFP_2012
  Left = 85
  Top = 55
  Caption = 'Agent List'
  ClientHeight = 460
  ClientWidth = 599
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
  object DBGrid1: TDBGrid
    Left = 0
    Top = 57
    Width = 599
    Height = 403
    Align = alClient
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'LastName'
        Width = 157
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
        Width = 66
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Branch'
        Width = 42
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ManagerCode'
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 599
    Height = 57
    Align = alTop
    TabOrder = 1
    object OKBtn: TBitBtn
      Left = 40
      Top = 16
      Width = 65
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 128
      Top = 16
      Width = 65
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object PickedItem: TEdit
      Left = 200
      Top = 16
      Width = 73
      Height = 21
      TabOrder = 2
      Text = 'PickedItem'
      Visible = False
    end
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 192
    Top = 80
  end
  object Query1: TADQuery
    Connection = FDConnection
    SQL.Strings = (
      'Select * from Agents')
    Left = 76
    Top = 99
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients.db')
    Left = 117
    Top = 105
  end
end
