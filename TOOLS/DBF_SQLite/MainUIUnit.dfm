object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 310
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    535
    310)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 503
    Top = 24
    Width = 23
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '...'
    OnClick = SpeedButton1Click
  end
  object Label1: TLabel
    Left = 24
    Top = 5
    Width = 40
    Height = 13
    Caption = 'dbf Files'
  end
  object SpeedButton2: TSpeedButton
    Left = 503
    Top = 119
    Width = 23
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '...'
    OnClick = SpeedButton2Click
  end
  object FileListBox: TListBox
    Left = 24
    Top = 24
    Width = 161
    Height = 270
    ItemHeight = 13
    TabOrder = 0
  end
  object DirectoryName: TEdit
    Left = 200
    Top = 24
    Width = 300
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object LoadFileName: TButton
    Left = 200
    Top = 51
    Width = 97
    Height = 25
    Caption = 'Load files name'
    TabOrder = 2
    OnClick = LoadFileNameClick
  end
  object SQLiteDirectory: TEdit
    Left = 200
    Top = 119
    Width = 300
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object Button1: TButton
    Left = 200
    Top = 152
    Width = 97
    Height = 25
    Caption = 'Convert To SQLite'
    TabOrder = 4
    OnClick = Button1Click
  end
  object cbAddRowId: TCheckBox
    Left = 312
    Top = 156
    Width = 121
    Height = 17
    Caption = 'Add RowID as Primary Key'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object ADOConnection: TADOConnection
    LoginPrompt = False
    Left = 248
    Top = 72
  end
end
