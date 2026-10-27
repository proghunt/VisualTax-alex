object clientsT1_2026: TclientsT1_2026
  Left = 344
  Top = 206
  BorderIcons = [biSystemMenu, biMaximize]
  ClientHeight = 611
  ClientWidth = 721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AutoLbl: TLabel
    Left = 16
    Top = 104
    Width = 305
    Height = 16
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
  end
  object SelectedLbl: TLabel
    Left = 432
    Top = 104
    Width = 89
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'Selected:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label1: TLabel
    Left = 107
    Top = 40
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
  object FormLbl: TLabel
    Left = 592
    Top = 128
    Width = 37
    Height = 13
    Caption = 'FormLbl'
    Visible = False
  end
  object SelectAllBtn: TBitBtn
    Left = 360
    Top = 240
    Width = 43
    Height = 48
    Hint = 'Select All'
    Caption = 'All '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000014000000160000000100
      0400000000000801000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888800008888888888888888888800008888888888088888888800008888
      8888880088888888000088888888880C08888888000088888888880CC0888888
      000088888888880CCC088888000088880000000CCCC08888000088880CCCCCCC
      CCCC0888000088880CCCCCCCCCCCC088000088880CCCCCCCCCCCCC0800008888
      0CCCCCCCCCCCC088000088880CCCCCCCCCCC0888000088880000000CCCC08888
      000088888888880CCC088888000088888888880CC0888888000088888888880C
      0888888800008888888888008888888800008888888888088888888800008888
      8888888888888888000088888888888888888888000088888888888888888888
      0000}
    Layout = blGlyphBottom
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Spacing = 1
    TabOrder = 0
    OnClick = SelectAllBtnClick
  end
  object RadioGroup1: TRadioGroup
    Left = 214
    Top = 64
    Width = 305
    Height = 33
    Caption = '  FILTER  '
    Color = clBtnFace
    Columns = 2
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
  object DBGrid1: TDBGrid
    Left = 17
    Top = 126
    Width = 337
    Height = 414
    Hint = 'Hit Space Bar or Double click to select'
    Color = 16777158
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    OnKeyPress = DBGrid1KeyPress
  end
  object RemoveBtn: TBitBtn
    Left = 360
    Top = 192
    Width = 43
    Height = 40
    Hint = 'Remove Selected file'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000014000000160000000100
      0400000000000801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777700007777777777777777777700007777777777077777777700007777
      77777007777777770000777777770C0777777777000077777770CC0777777777
      00007777770CCC07777777770000777770CCCC0000000777000077770CCCCCCC
      CCCC077700007770CCCCCCCCCCCC07770000770CCCCCCCCCCCCC077700007770
      CCCCCCCCCCCC0777000077770CCCCCCCCCCC07770000777770CCCC0000000777
      00007777770CCC0777777777000077777770CC07777777770000777777770C07
      7777777700007777777770077777777700007777777777077777777700007777
      7777777777777777000077777777777777777777000077777777777777777777
      0000}
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = RemoveBtnClick
  end
  object ListBox1: TListBox
    Left = 409
    Top = 126
    Width = 169
    Height = 414
    Hint = 'Hit Space Bar or Double click on a line to remove from list'
    Color = 16777158
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 4
    OnDblClick = ListBox1DblClick
    OnKeyPress = ListBox1KeyPress
  end
  object BitBtn1: TBitBtn
    Left = 360
    Top = 147
    Width = 43
    Height = 38
    Hint = 'Select File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000014000000160000000100
      0400000000000801000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888800008888888888888888888800008888888888088888888800008888
      8888880088888888000088888888880C08888888000088888888880CC0888888
      000088888888880CCC088888000088880000000CCCC08888000088880CCCCCCC
      CCCC0888000088880CCCCCCCCCCCC088000088880CCCCCCCCCCCCC0800008888
      0CCCCCCCCCCCC088000088880CCCCCCCCCCC0888000088880000000CCCC08888
      000088888888880CCC088888000088888888880CC0888888000088888888880C
      0888888800008888888888008888888800008888888888088888888800008888
      8888888888888888000088888888888888888888000088888888888888888888
      0000}
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = BitBtn1Click
  end
  object DataDirBox: TEdit
    Left = 216
    Top = 40
    Width = 305
    Height = 21
    Hint = 'Press Tab after changing directory'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = 'DataDirBox'
    OnExit = DataDirBoxExit
    OnKeyPress = DataDirBoxKeyPress
  end
  object BitBtn2: TBitBtn
    Left = 360
    Top = 301
    Width = 41
    Height = 50
    Caption = 'All'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000014000000160000000100
      0400000000000801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777700007777777777777777777700007777777777077777777700007777
      77777007777777770000777777770C0777777777000077777770CC0777777777
      00007777770CCC07777777770000777770CCCC0000000777000077770CCCCCCC
      CCCC077700007770CCCCCCCCCCCC07770000770CCCCCCCCCCCCC077700007770
      CCCCCCCCCCCC0777000077770CCCCCCCCCCC07770000777770CCCC0000000777
      00007777770CCC0777777777000077777770CC07777777770000777777770C07
      7777777700007777777770077777777700007777777777077777777700007777
      7777777777777777000077777777777777777777000077777777777777777777
      0000}
    Layout = blGlyphBottom
    ParentFont = False
    Spacing = 1
    TabOrder = 7
    OnClick = BitBtn2Click
  end
  object RtuPanel: TPanel
    Left = 17
    Top = 553
    Width = 649
    Height = 36
    BorderStyle = bsSingle
    TabOrder = 8
    object RtuLabelsLbl: TLabel
      Left = 417
      Top = 7
      Width = 47
      Height = 13
      Caption = 'Print RTU'
    end
    object Label2: TLabel
      Left = 88
      Top = 7
      Width = 68
      Height = 13
      Caption = 'Create RTU'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 537
      Top = 7
      Width = 81
      Height = 13
      Caption = 'Show RTU Lines'
    end
    object TLabel
      Left = 184
      Top = 8
      Width = 37
      Height = 13
      AutoSize = False
      Caption = 'RtuNo:'
    end
    object RtuLbl: TLabel
      Left = 224
      Top = 8
      Width = 38
      Height = 13
      Caption = 'RtuLbl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object PrintCurrentRtuBtn: TBitBtn
      Left = 400
      Top = 24
      Width = 97
      Height = 25
      Hint = 'Open Selected returns'
      Caption = 'Current RTU'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = PrintCurrentRtuBtnClick
    end
    object PrintOtherRtu: TBitBtn
      Left = 400
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Others...'
      TabOrder = 1
      OnClick = PrintOtherRtuClick
    end
    object PrintRtuListBtn: TBitBtn
      Left = 400
      Top = 72
      Width = 97
      Height = 25
      Caption = 'RTU Names'
      TabOrder = 2
      OnClick = PrintRtuListBtnClick
    end
    object ProdRtuBtn: TBitBtn
      Left = 7
      Top = 24
      Width = 130
      Height = 25
      Hint = 'Create RTU for selected returns'
      Caption = 'Production T1'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = ProdRtuBtnClick
    end
    object ProductionSENDBtn: TBitBtn
      Left = 144
      Top = 24
      Width = 113
      Height = 25
      Hint = 'Create RTU for selected returns'
      Caption = 'Production SEND'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = ProductionSENDBtnClick
    end
    object TestT1Btn: TBitBtn
      Left = 7
      Top = 48
      Width = 130
      Height = 25
      Hint = 'Create RTU for selected returns'
      Caption = 'Compatibility Test T1'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = TestT1BtnClick
    end
    object TestSendBtn: TBitBtn
      Left = 144
      Top = 48
      Width = 113
      Height = 25
      Hint = 'Create RTU for selected returns'
      Caption = 'Test SEND'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = TestSendBtnClick
    end
    object DevelpmentT1Btn: TBitBtn
      Left = 7
      Top = 72
      Width = 130
      Height = 25
      Hint = 'Create RTU for selected returns'
      Caption = 'Development T1'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = DevelpmentT1BtnClick
    end
    object DevelopmentSendBtn: TBitBtn
      Left = 144
      Top = 72
      Width = 113
      Height = 25
      Hint = 'Create RTU for selected returns'
      Caption = 'Development SEND'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = DevelopmentSendBtnClick
    end
    object EfileBtn: TBitBtn
      Left = 288
      Top = 32
      Width = 105
      Height = 49
      Hint = 'Connect to RevCan now'
      Caption = 'EFile now'
      Glyph.Data = {
        F6010000424DF601000000000000760000002800000020000000180000000100
        0400000000008001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888888888888888888888888888888888888888888888
        8800000000000000088888888888888880000000000000008888888888888888
        00000FFFFF00000888888888888888800000FFFFF00000888888888888888800
        000FFFFF00000888888888888888800000000000000088888888888888880000
        0000800000088888888888888880000000080000008888888888888888088888
        8888888880888888888888888800000000000000008888888888888889999999
        9999999999998888888888888889999999999999998888888888888888999999
        9999999999988888888888888899899999999999899888888888888888888989
        9999998988888888888888888888888999999988888888888888880008088889
        9999998888888888888888088808888989998988888888888888880088008888
        8999888888888888888888088808888888988888888888888888880008000888
        8898888888888888888888888888888888888888888888888888}
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = EfileBtnClick
    end
    object ShowLinesOtherBtn: TBitBtn
      Left = 536
      Top = 56
      Width = 81
      Height = 41
      Caption = 'Others...'
      TabOrder = 10
      OnClick = ShowLinesOtherBtnClick
    end
    object ShowCurrentLinesBtn: TBitBtn
      Left = 536
      Top = 24
      Width = 81
      Height = 33
      Caption = 'Current RTU'
      TabOrder = 11
      OnClick = ShowCurrentLinesBtnClick
    end
  end
  object CancelBtn: TBitBtn
    Left = 584
    Top = 296
    Width = 117
    Height = 57
    Hint = 'Exit this sceen'
    Caption = 'Close'
    Kind = bkCancel
    Layout = blGlyphTop
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = CancelBtnClick
  end
  object PrintBtn: TBitBtn
    Left = 584
    Top = 144
    Width = 117
    Height = 57
    Hint = 'Print Selected returns'
    Caption = 'Print'
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
    Layout = blGlyphTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = PrintBtnClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 721
    Height = 33
    Align = alTop
    Caption = 'Panel1'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    ExplicitWidth = 709
  end
  object BarPrintBtn: TBitBtn
    Left = 584
    Top = 216
    Width = 117
    Height = 60
    Hint = 'Print Selected returns'
    Caption = 'Print with Barcode'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = []
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
    Layout = blGlyphTop
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = BarPrintBtnClick
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 271
    Top = 205
  end
  object OpenDialog1: TOpenDialog
    Left = 422
    Top = 297
  end
  object PrintDialog1: TPrintDialog
    Left = 567
    Top = 72
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 57
    Top = 81
  end
  object Query1: TADQuery
    Connection = FDConnection
    Left = 89
    Top = 57
  end
end
