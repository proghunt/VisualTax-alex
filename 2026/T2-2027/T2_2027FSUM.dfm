object FrmSumT2_2027: TFrmSumT2_2027
  Left = 74
  Top = 114
  Caption = 'Summary of Statements (Multiple)'
  ClientHeight = 289
  ClientWidth = 577
  Color = clAqua
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 577
    Height = 289
    Align = alClient
    BevelInner = bvLowered
    BevelWidth = 2
    Color = clBtnShadow
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object RetNameLbl: TLabel
      Left = 192
      Top = 16
      Width = 249
      Height = 13
      Margins.Bottom = 2
      Alignment = taCenter
      AutoSize = False
      Caption = 'RetNameLbl'
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label1: TLabel
      Left = 104
      Top = 16
      Width = 72
      Height = 13
      Margins.Bottom = 2
      Caption = 'Current Return:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object FNameBox: TLabel
      Left = 272
      Top = 44
      Width = 101
      Height = 22
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'FNameBox'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object T2124Btn: TButton
      Left = 8
      Top = 64
      Width = 145
      Height = 21
      Caption = 'Business - T2124'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = T2124BtnClick
    end
    object T2121Btn: TButton
      Left = 8
      Top = 136
      Width = 145
      Height = 21
      Caption = 'Fishing - T2121'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = T2121BtnClick
    end
    object ExitBtn: TBitBtn
      Left = 512
      Top = 8
      Width = 49
      Height = 33
      Cancel = True
      Caption = 'Exit'
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 2
      OnClick = ExitBtnClick
    end
    object T2032Btn: TButton
      Left = 8
      Top = 88
      Width = 145
      Height = 21
      Caption = 'Professional - T2032'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = T2032BtnClick
    end
    object T2042Btn: TButton
      Left = 8
      Top = 112
      Width = 145
      Height = 21
      Caption = 'Farming - T2042'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = T2042BtnClick
    end
    object SwitchBtn: TBitBtn
      Left = 456
      Top = 8
      Width = 49
      Height = 33
      Hint = 'Change Tax Return'
      Glyph.Data = {
        F6010000424DF601000000000000760000002800000020000000180000000100
        0400000000008001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888899889999988998888888888888880888998999999989988888888888888
        8008899899999998998888888888000000008999997779999988888888808888
        8008899977888779998888888808888880888899887878899888888888088888
        8888888887777788888888888808888888888888778887788888888888088888
        8888888878888878888888888888888888888888778887788888888877777788
        88888888877877888888844847FFF74844888888877777888888844847FFF748
        44888888888888888888844447F4F74444888888888888888888844447F4F744
        44888888888808888888884447F4F74444888888888808888888884488787884
        4888888888880888888888888777778888888888888808888888888877888778
        8888808888880888888888887888887888880088888088888888888877888778
        8880000000088888888888888778778888880088888888888888888887777788
        8888808888888888888888888888888888888888888888888888}
      TabOrder = 5
      OnClick = SwitchBtnClick
    end
    object T776Btn: TButton
      Left = 8
      Top = 176
      Width = 145
      Height = 21
      Caption = 'Rental - T776'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = T776BtnClick
    end
    object AutoExpBtn: TButton
      Left = 8
      Top = 200
      Width = 145
      Height = 21
      Caption = 'Automobile Expenses'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = AutoExpBtnClick
    end
    object T2209Btn: TButton
      Left = 8
      Top = 224
      Width = 145
      Height = 21
      Caption = ' Fed Foreign Tax Credits '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      OnClick = T2209BtnClick
    end
    object T2036Btn: TButton
      Left = 8
      Top = 248
      Width = 145
      Height = 21
      Caption = 'Prv Foreign T/C-T2036'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      OnClick = T2036BtnClick
    end
    object StringGrid1: TStringGrid
      Left = 168
      Top = 69
      Width = 401
      Height = 212
      Hint = 'Double Click on a Statement No. to access it'
      Color = clWhite
      ColCount = 10
      DefaultRowHeight = 16
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      Options = [goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing, goRowMoving, goColMoving, goTabs, goAlwaysShowEditor, goThumbTracking]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnDblClick = StringGrid1DblClick
      OnKeyPress = StringGrid1KeyPress
      OnSelectCell = StringGrid1SelectCell
      OnSetEditText = StringGrid1SetEditText
      ColWidths = (
        64
        64
        64
        64
        64
        62
        64
        64
        64
        64)
      RowHeights = (
        16
        16)
    end
  end
end
