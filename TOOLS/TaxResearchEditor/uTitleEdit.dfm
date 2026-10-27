object TitleEdit: TTitleEdit
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Title Edit'
  ClientHeight = 90
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    423
    90)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 16
    Width = 24
    Height = 13
    Caption = 'Title:'
  end
  object edTitle: TDBEdit
    Left = 43
    Top = 13
    Width = 364
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Title'
    DataSource = dsQ
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 125
    Top = 51
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 227
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Q: TADQuery
    Connection = dmData.MainConn
    SQL.Strings = (
      'SELECT * FROM Titles'
      'WHERE Id = :Id')
    Left = 320
    Top = 48
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
    object QId: TADAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QTitle: TStringField
      FieldName = 'Title'
      Origin = 'Title'
      Size = 255
    end
    object QParentTitleId: TIntegerField
      FieldName = 'ParentTitleId'
      Origin = 'ParentTitleId'
    end
    object QSeqNo: TIntegerField
      FieldName = 'SeqNo'
      Origin = 'SeqNo'
    end
  end
  object dsQ: TDataSource
    DataSet = Q
    Left = 360
    Top = 49
  end
end
