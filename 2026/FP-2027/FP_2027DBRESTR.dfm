object RestructFP_2012: TRestructFP_2012
  Left = 152
  Top = 96
  Caption = 'Restructure a data base'
  ClientHeight = 265
  ClientWidth = 409
  Color = clBtnFace
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
    Left = 101
    Top = 8
    Width = 261
    Height = 16
    Caption = 'Directory of data base to be restructured'
  end
  object Label2: TLabel
    Left = 13
    Top = 56
    Width = 76
    Height = 16
    Caption = 'Data Bases'
  end
  object OKBtn: TBitBtn
    Left = 233
    Top = 96
    Width = 89
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 233
    Top = 160
    Width = 89
    Height = 33
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object DataDirBox: TEdit
    Left = 129
    Top = 28
    Width = 168
    Height = 24
    TabOrder = 2
    OnExit = DataDirBoxExit
  end
  object FileListBox1: TFileListBox
    Left = 10
    Top = 72
    Width = 135
    Height = 193
    TabOrder = 3
  end
  object DataSource1: TDataSource
    DataSet = OriginalTbl
    Left = 199
    Top = 234
  end
  object DataSource2: TDataSource
    DataSet = EmptyTbl
    Left = 287
    Top = 234
  end
  object EmptyFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 156
    Top = 153
  end
  object EmptyTbl: TADTable
    Connection = EmptyFDConnection
    Left = 196
    Top = 152
  end
  object OriginalFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 156
    Top = 188
  end
  object OriginalTbl: TADTable
    Connection = OriginalFDConnection
    Left = 196
    Top = 187
  end
  object BatchMove1: TADDataMove
    TextDataDef.Fields = <>
    TextFileName = 'Data.txt'
    Mappings = <>
    LogFileName = 'Data.log'
    Mode = dmAppend
    Left = 176
    Top = 120
  end
end
