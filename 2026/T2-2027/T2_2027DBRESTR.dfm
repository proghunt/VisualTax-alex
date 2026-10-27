object RestructT2_2027: TRestructT2_2027
  Left = 240
  Top = 120
  Caption = 'RestructT2_2027'
  ClientHeight = 256
  ClientWidth = 345
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
    Left = 61
    Top = 16
    Width = 93
    Height = 16
    Margins.Bottom = 2
    Caption = 'Data Directory'
  end
  object Label2: TLabel
    Left = 69
    Top = 72
    Width = 76
    Height = 16
    Margins.Bottom = 2
    Caption = 'Data Bases'
  end
  object OKBtn: TBitBtn
    Left = 241
    Top = 80
    Width = 89
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 241
    Top = 136
    Width = 89
    Height = 33
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object DataDirBox: TEdit
    Left = 57
    Top = 36
    Width = 168
    Height = 24
    TabOrder = 2
    Text = 'C:\delphi\t1\data'
    OnExit = DataDirBoxExit
  end
  object FileListBox1: TFileListBox
    Left = 66
    Top = 96
    Width = 135
    Height = 121
    TabOrder = 3
  end
  object DataSource1: TDataSource
    DataSet = OriginalTbl
    Left = 223
    Top = 194
  end
  object DataSource2: TDataSource
    DataSet = EmptyTbl
    Left = 255
    Top = 194
  end
  object BatchMove1: TADDataMove
    TextDataDef.Fields = <>
    TextFileName = 'Data.txt'
    Mappings = <>
    LogFileName = 'Data.log'
    Mode = dmAppend
    Left = 208
    Top = 65528
  end
  object EmptyFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 212
    Top = 129
  end
  object OriginalFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 212
    Top = 156
  end
  object OriginalTbl: TADTable
    Connection = OriginalFDConnection
    Left = 252
    Top = 156
  end
  object EmptyTbl: TADTable
    Connection = EmptyFDConnection
    Left = 252
    Top = 128
  end
end
