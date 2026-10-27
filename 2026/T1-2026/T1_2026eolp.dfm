object EOLPT1_2026: TEOLPT1_2026
  Left = 247
  Top = 150
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'EOL PLUS'
  ClientHeight = 676
  ClientWidth = 886
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
  object AutoLbl: TLabel
    Left = 24
    Top = 162
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
    Left = 531
    Top = 162
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
    Left = 190
    Top = 91
    Width = 96
    Height = 13
    Caption = 'T1 returns Directory:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 586
    Top = 125
    Width = 94
    Height = 13
    Caption = 'Minimum time delay '
  end
  object Label4: TLabel
    Left = 586
    Top = 144
    Width = 212
    Height = 13
    Caption = 'between return transmissions (in milliseconds)'
  end
  object Label5: TLabel
    Left = 671
    Top = 173
    Width = 169
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'Start slowly and do not'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label7: TLabel
    Left = 671
    Top = 195
    Width = 169
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'exceed 5 returns per batch'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object SelectAllBtn: TBitBtn
    Left = 464
    Top = 298
    Width = 43
    Height = 41
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
    Left = 257
    Top = 118
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
    Left = 8
    Top = 186
    Width = 448
    Height = 480
    Hint = 'Hit Space Bar or Double click to select'
    Color = 15393742
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
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
    Left = 464
    Top = 234
    Width = 43
    Height = 33
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
    Left = 512
    Top = 184
    Width = 153
    Height = 480
    Hint = 'Hit Space Bar or Double click on a line to remove from list'
    Color = 15393742
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
    Left = 464
    Top = 202
    Width = 43
    Height = 33
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
    Left = 295
    Top = 90
    Width = 511
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
    Left = 464
    Top = 338
    Width = 43
    Height = 42
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
  object HeaderPanel: TPanel
    Left = 0
    Top = 0
    Width = 886
    Height = 33
    Hint = 'Click to change tax year and rates'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'VisualTax - EFILE ON-LINE PLUS'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
  end
  object LoginInfoPanel: TPanel
    Left = 0
    Top = 33
    Width = 886
    Height = 52
    Align = alTop
    BevelOuter = bvLowered
    Color = 15532031
    TabOrder = 10
    object Label6: TLabel
      Left = 16
      Top = 17
      Width = 161
      Height = 15
      Caption = 'EFile On-line Web site (URL):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object URLBox: TEdit
      Left = 184
      Top = 9
      Width = 481
      Height = 23
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object SetupBtn: TBitBtn
      Left = 672
      Top = 9
      Width = 57
      Height = 25
      Caption = 'Setup...'
      TabOrder = 1
      Visible = False
      OnClick = SetupBtnClick
    end
  end
  object RtuPanel: TPanel
    Left = 8
    Top = 90
    Width = 147
    Height = 73
    BorderStyle = bsSingle
    TabOrder = 8
    object RtuLabelsLbl: TLabel
      Left = 161
      Top = 7
      Width = 47
      Height = 13
      Caption = 'Print RTU'
    end
    object Label3: TLabel
      Left = 249
      Top = 7
      Width = 81
      Height = 13
      Caption = 'Show RTU Lines'
    end
    object PrintCurrentRtuBtn: TBitBtn
      Left = 144
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
      Left = 144
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Others...'
      TabOrder = 1
      OnClick = PrintOtherRtuClick
    end
    object PrintRtuListBtn: TBitBtn
      Left = 144
      Top = 72
      Width = 97
      Height = 25
      Caption = 'RTU Names'
      TabOrder = 2
      OnClick = PrintRtuListBtnClick
    end
    object ShowLinesOtherBtn: TBitBtn
      Left = 248
      Top = 56
      Width = 81
      Height = 41
      Caption = 'Others...'
      TabOrder = 3
      OnClick = ShowLinesOtherBtnClick
    end
    object ShowCurrentLinesBtn: TBitBtn
      Left = 248
      Top = 24
      Width = 81
      Height = 33
      Caption = 'Current RTU'
      TabOrder = 4
      OnClick = ShowCurrentLinesBtnClick
    end
    object ProdOrTestBox: TRadioGroup
      Left = 6
      Top = -1
      Width = 132
      Height = 65
      Caption = 'Production or Test'
      Color = clBtnFace
      ItemIndex = 0
      Items.Strings = (
        'Production (User)'
        'Test (Developer)')
      ParentBackground = False
      ParentColor = False
      TabOrder = 5
    end
  end
  object TransmitBtn: TBitBtn
    Left = 671
    Top = 243
    Width = 169
    Height = 57
    Caption = 'Transmit Now'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Glyph.Data = {
      F6010000424DF601000000000000760000002800000020000000180000000100
      0400000000008001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888888888888888888888888888888888888888888888888888888888888
      8800000000000000088888888888888880000000000000008888888888888888
      00000FFFFF00000888888888888888800000FFFFF00000888888888888888800
      000FFFFF00000888888888888888800000000000000088888888888888880000
      0000800000088888888888888880000000080000008888888888888888888888
      8888888880888888888888888899000000000000998888888888888889999999
      9999999999998888888888888899999999999999998888888888888888999999
      9999999999988888888888888888899999999999899888888888888888888999
      9999998988888888888888000088888000009988000008888888880888888800
      8890098808888888088888088888880888990988088888880888880008888808
      8899088808888800000888088888880088900888088888880888880000888880
      0000888808888888088888888888888888888888888888888888}
    Layout = blGlyphTop
    ParentFont = False
    TabOrder = 11
    OnClick = TransmitBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 671
    Top = 369
    Width = 168
    Height = 43
    Hint = 'Exit this sceen'
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = CancelBtnClick
  end
  object DelayBox: TEdit
    Left = 686
    Top = 122
    Width = 43
    Height = 21
    TabOrder = 13
    Text = '200'
  end
  object PrintBtn: TBitBtn
    Left = 671
    Top = 306
    Width = 168
    Height = 57
    Caption = 'Print Acknowledgement Report'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Layout = blGlyphTop
    ParentFont = False
    TabOrder = 14
    OnClick = PrintBtnClick
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 167
    Top = 223
  end
  object OpenDialog1: TOpenDialog
    Left = 620
    Top = 65
  end
  object PrintDialog1: TPrintDialog
    Left = 669
    Top = 60
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 249
    Top = 249
  end
  object Query1: TADQuery
    AfterOpen = Query1AfterOpen
    Connection = FDConnection
    Left = 281
    Top = 225
  end
end
