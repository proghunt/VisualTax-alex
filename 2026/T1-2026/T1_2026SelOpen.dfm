object SelOpenT1_2026: TSelOpenT1_2026
  Left = 273
  Top = 171
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Selective Open of returns'
  ClientHeight = 653
  ClientWidth = 881
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel4: TPanel
    Left = 0
    Top = 604
    Width = 881
    Height = 49
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 0
    object Label2: TLabel
      Left = 650
      Top = 3
      Width = 114
      Height = 16
      Caption = 'After opening one'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 636
      Top = 21
      Width = 180
      Height = 16
      Caption = 'OR more returns, click Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CancelBtn: TBitBtn
      Left = 534
      Top = 4
      Width = 89
      Height = 33
      Hint = 'Exit this sceen'
      Caption = 'Close'
      Kind = bkCancel
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = CancelBtnClick
    end
    object OpenBtn: TBitBtn
      Left = 154
      Top = 4
      Width = 97
      Height = 33
      Caption = 'Open'
      Glyph.Data = {
        56020000424D5602000000000000760000002800000024000000180000000100
        040000000000E001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777770000777777777777777777777777777777777777
        0000777777000000000000000007777777777777000077777700666666666666
        666077777777777700007777770E006666666666666607777777777700007777
        770EEE0666666666666660777777777700007777770EEEE06666666666666600
        7777777700007777770EEEEE06666666666666660777777700007777770EEEEE
        E0666666666666666077777700007777770EEEEEEE0666666666666666077777
        00007777770EEEEEEEE06666666666666660777700007777770EEEEEEEEE0000
        000000000000777700007777770EEEEEEEEEEEEEEEE077777777777700007777
        770EEEEEEEEEEEEEEEE077777777777700007777770EEEEEE000000000007777
        7777777700007777770EEEEEE077777777777779999997770000777777700000
        0777777777777777999997770000777777777777777777777777777777999777
        0000700007077770007077077777777779799777000070770707777077707707
        7777777797779777000070770700007007707007777999997777777700007077
        0707707077700707777777777777777700007000070000700070770777777777
        7777777700007777777777777777777777777777777777770000}
      TabOrder = 1
      OnClick = OpenBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 274
      Top = 4
      Width = 113
      Height = 33
      Caption = 'Print Listing'
      Glyph.Data = {
        56020000424D5602000000000000760000002800000024000000180000000100
        040000000000E001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888880000888888888888888888888888888888888888
        0000888888888888888888888888888888888888000088888888888888888888
        8888888888888888000088888877000000000000000007788888888800008888
        8800000000000000000000078888888800008888877777777777777777777770
        788888880000888887F888888888888888888777078888880000888887F88888
        8888888889988777707888880000888887F88888888888888998877777088888
        0000888887F8CCCC8888888889988777770888880000888887F8888888888888
        88888877770888880000888887FFFFFFFFFFFFFFFFF888877708888800008888
        878FFFFFFFFFFFFFFFF8888877088888000088888878FF000000000000008888
        870888880000888888878FF07FFFFFFFFF707888880888880000888888887888
        74444444FF7007888708888800008888888887007FFFFFFFFF70000000888888
        00008888888888887F4444444F7888888888888800008888888888887FFFFFFF
        FF78888888888888000088888888888887F4444444F788888888888800008888
        8888888887FFFFFFFFF788888888888800008888888888888888888888888888
        8888888800008888888888888888888888888888888888880000}
      TabOrder = 2
      OnClick = PrintBtnClick
    end
    object CopyBtn: TBitBtn
      Left = 409
      Top = 4
      Width = 89
      Height = 33
      Caption = 'Copy returns...'
      TabOrder = 3
      OnClick = CopyBtnClick
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 75
    Width = 169
    Height = 529
    Align = alLeft
    Caption = '  FILTER  '
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    OnClick = RadioGroup1Click
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 881
    Height = 43
    Align = alTop
    Caption = 'Selective Open (Apply filter)'
    Color = 7895160
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 43
    Width = 881
    Height = 32
    Align = alTop
    TabOrder = 3
    object Label1: TLabel
      Left = 31
      Top = 8
      Width = 87
      Height = 13
      Caption = 'Data Directory:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DataDirBox: TEdit
      Left = 140
      Top = 8
      Width = 456
      Height = 21
      Hint = 'Press Tab after changing directory'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'DataDirBox'
      OnExit = DataDirBoxExit
      OnKeyPress = DataDirBoxKeyPress
    end
    object SelectCurBtn: TBitBtn
      Left = 614
      Top = 9
      Width = 73
      Height = 20
      Caption = 'Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = SelectCurBtnClick
    end
  end
  object Panel3: TPanel
    Left = 169
    Top = 75
    Width = 712
    Height = 529
    Align = alClient
    TabOrder = 4
    object AutoLbl: TLabel
      Left = 1
      Top = 1
      Width = 710
      Height = 16
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'AutoLbl'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ExplicitWidth = 704
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 17
      Width = 710
      Height = 511
      Hint = 'Hit Space Bar or Double click to select'
      Align = alClient
      Color = 16777158
      DataSource = DataSource1
      DrawingStyle = gdsClassic
      FixedColor = 11301888
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = 12971774
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = [fsBold]
      OnDblClick = DBGrid1DblClick
      OnKeyPress = DBGrid1KeyPress
    end
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 327
    Top = 309
  end
  object OpenDialog1: TOpenDialog
    Left = 318
    Top = 353
  end
  object PrintDialog1: TPrintDialog
    Left = 368
    Top = 307
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 289
    Top = 273
  end
  object Query1: TADQuery
    Connection = FDConnection
    Left = 321
    Top = 249
  end
end
