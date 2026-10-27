object frmEditDocument: TfrmEditDocument
  Left = 0
  Top = 0
  Caption = 'Document'
  ClientHeight = 243
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 196
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 385
    ExplicitHeight = 174
    DesignSize = (
      420
      196)
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 12
      Height = 16
      Caption = 'ID'
    end
    object Label3: TLabel
      Left = 24
      Top = 46
      Width = 28
      Height = 16
      Caption = 'Type'
    end
    object Label4: TLabel
      Left = 24
      Top = 73
      Width = 41
      Height = 16
      Caption = 'Format'
    end
    object Label5: TLabel
      Left = 24
      Top = 100
      Width = 33
      Height = 16
      Caption = 'Name'
    end
    object lblFileSource: TLabel
      Left = 80
      Top = 171
      Width = 59
      Height = 13
      Cursor = crHandPoint
      Caption = 'lblFileSource'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = lblFileSourceClick
      OnMouseEnter = lblFileSourceMouseEnter
      OnMouseLeave = lblFileSourceMouseLeave
    end
    object chbDocumentLoaded: TCheckBox
      Left = 127
      Top = 15
      Width = 146
      Height = 17
      Caption = 'Document loaded'
      Enabled = False
      TabOrder = 0
    end
    object edID: TEdit
      Left = 80
      Top = 13
      Width = 41
      Height = 24
      Enabled = False
      TabOrder = 1
      Text = 'edID'
    end
    object edName: TEdit
      Left = 80
      Top = 97
      Width = 326
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      Text = 'edName'
      OnChange = cbTypeChange
      ExplicitWidth = 291
    end
    object btnLoadFile: TBitBtn
      Left = 80
      Top = 128
      Width = 326
      Height = 37
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Load file'
      TabOrder = 3
      OnClick = btnLoadFileClick
    end
    object cbType: TComboBox
      Left = 80
      Top = 43
      Width = 326
      Height = 24
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      OnChange = cbTypeChange
      ExplicitWidth = 291
    end
    object cbFormat: TComboBox
      Left = 80
      Top = 70
      Width = 326
      Height = 24
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      OnChange = cbTypeChange
      ExplicitWidth = 291
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 196
    Width = 420
    Height = 47
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 192
    DesignSize = (
      420
      47)
    object BitBtn1: TBitBtn
      Left = 232
      Top = 6
      Width = 85
      Height = 35
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 323
      Top = 6
      Width = 89
      Height = 35
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object dlgOpen: TOpenDialog
    Left = 24
    Top = 128
  end
end
