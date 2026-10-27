object URLEdit: TURLEdit
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'URL Edit'
  ClientHeight = 106
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
    106)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 16
    Width = 41
    Height = 13
    Caption = 'Caption:'
  end
  object Label2: TLabel
    Left = 13
    Top = 43
    Width = 23
    Height = 13
    Caption = 'URL:'
  end
  object edCaption: TDBEdit
    Left = 60
    Top = 13
    Width = 347
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Caption'
    DataSource = dsQ
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 125
    Top = 70
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 227
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object edURL: TDBEdit
    Left = 60
    Top = 40
    Width = 347
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'URL'
    DataSource = dsQ
    TabOrder = 1
  end
  object Q: TADQuery
    Connection = dmData.MainConn
    SQL.Strings = (
      'SELECT * FROM URLs'
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
    end
    object QCaption: TStringField
      FieldName = 'Caption'
      Origin = 'Caption'
      Size = 255
    end
    object QURL: TStringField
      FieldName = 'URL'
      Origin = 'URL'
      Size = 4000
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
