object EFMErrorsT1_2026: TEFMErrorsT1_2026
  Left = 128
  Top = 54
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'EFile Errors '
  ClientHeight = 561
  ClientWidth = 626
  Color = 13353654
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 76
    Top = 46
    Width = 5
    Height = 16
    Caption = '.'
    Color = 12615680
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8404992
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 15
    Top = 86
    Width = 364
    Height = 20
    AutoSize = False
    Caption = 'The error clues (if any) should be investigated and '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 15
    Top = 102
    Width = 392
    Height = 13
    AutoSize = False
    Caption = 'corrected before including the return in a new transmission'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 134
    Width = 153
    Height = 401
    BevelInner = bvLowered
    BorderStyle = bsSingle
    TabOrder = 0
    object Label3: TLabel
      Left = 4
      Top = 6
      Width = 141
      Height = 13
      AutoSize = False
      Caption = 'Label3'
    end
    object ListBox1: TListBox
      Left = 32
      Top = 32
      Width = 81
      Height = 353
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      TabOrder = 0
      OnClick = ListBox1Click
    end
  end
  object Panel2: TPanel
    Left = 176
    Top = 127
    Width = 441
    Height = 409
    BevelInner = bvLowered
    BorderStyle = bsSingle
    TabOrder = 1
    object Label1: TLabel
      Left = 62
      Top = 8
      Width = 89
      Height = 13
      Caption = 'Find Error Code'
    end
    object DBMemo1: TDBMemo
      Left = 12
      Top = 32
      Width = 413
      Height = 361
      DataField = 'Descr'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 166
      Top = 8
      Width = 67
      Height = 21
      TabOrder = 1
      OnChange = Edit1Change
    end
  end
  object ErrorTypeGroup: TRadioGroup
    Left = 11
    Top = 42
    Width = 382
    Height = 39
    Caption = ' Show Efile errors'
    Color = clBtnFace
    Columns = 2
    Items.Strings = (
      'for current Return only'
      'All (Master List)')
    ParentColor = False
    TabOrder = 2
    OnClick = ErrorTypeGroupClick
  end
  object CancelBtn: TBitBtn
    Left = 443
    Top = 72
    Width = 89
    Height = 33
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object SwapBtn: TBitBtn
    Left = 443
    Top = 40
    Width = 89
    Height = 33
    Caption = 'Swap'
    Glyph.Data = {
      F6010000424DF601000000000000760000002800000020000000180000000100
      0400000000008001000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777799779999977997777777777777770777997999999979977777777777777
      7007799799999997997777777777000000007999998889999977777777707777
      7007799988777889997777777700777770777799778787799777777777077777
      7777777778888877777777777707777777777777887778877777777777077777
      7777777787777787777777777777777777777777887778877777777788888877
      77777777788788777777744748FFF84744777777788888777777744748FFF847
      44777777777777777777744448F4F84444777777777777777777744448F4F844
      44777777770707770007774448F4F84444777777770707770707774477878774
      4777777777070077000777777888887777777777770707770707777788777887
      7777077777070007000777778777778777700777707777777777777788777887
      7700000007777777777777777887887777700777777777777777777778888877
      7777077777777777777777777777777777777777777777777777}
    TabOrder = 4
    OnClick = SwapBtnClick
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 626
    Height = 25
    Align = alTop
    Caption = 'E-File errors as reported in the acknowledgement file'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object DataSource1: TDataSource
    Left = 224
    Top = 360
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=c:\t1\EFERRORS.db')
    Left = 375
    Top = 344
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'EFERRORS'
    TableName = 'EFERRORS'
    Left = 303
    Top = 349
  end
end
