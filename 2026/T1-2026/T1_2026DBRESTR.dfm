object RestructT1_2026: TRestructT1_2026
  Left = 256
  Top = 112
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'RestructT1_2026'
  ClientHeight = 265
  ClientWidth = 264
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 93
    Top = 8
    Width = 93
    Height = 16
    Caption = 'Data Directory'
  end
  object Label2: TLabel
    Left = 13
    Top = 72
    Width = 76
    Height = 16
    Caption = 'Data Bases'
  end
  object OKBtn: TBitBtn
    Left = 161
    Top = 136
    Width = 89
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 161
    Top = 176
    Width = 89
    Height = 33
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object DataDirBox: TEdit
    Left = 49
    Top = 28
    Width = 168
    Height = 24
    TabOrder = 2
    Text = 'C:\delphi\t1\data'
    OnExit = DataDirBoxExit
  end
  object FileListBox1: TFileListBox
    Left = 8
    Top = 94
    Width = 135
    Height = 161
    TabOrder = 3
  end
  object DataSource1: TDataSource
    DataSet = OriginalTbl
    Left = 231
    Top = 10
  end
  object DataSource2: TDataSource
    DataSet = EmptyTbl
    Left = 223
    Top = 34
  end
  object EmptyFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 164
    Top = 201
  end
  object EmptyTbl: TADTable
    Connection = EmptyFDConnection
    Left = 204
    Top = 200
  end
  object OriginalFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 164
    Top = 236
  end
  object OriginalTbl: TADTable
    Connection = OriginalFDConnection
    Left = 204
    Top = 235
  end
  object BatchMove1: TADDataMove
    TextDataDef.Fields = <>
    TextFileName = 'Data.txt'
    Mappings = <>
    LogFileName = 'Data.log'
    Mode = dmAppend
    Left = 160
    Top = 64
  end
end
