object AnalyseT1_2026: TAnalyseT1_2026
  Left = 239
  Top = 192
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Data Base Analyser'
  ClientHeight = 591
  ClientWidth = 1003
  Color = 10855845
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
  object Label12: TLabel
    Left = 328
    Top = 40
    Width = 159
    Height = 16
    Alignment = taCenter
    Caption = 'SELECTED CLIENTS LIST'
    Color = clAqua
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object CountBox: TLabel
    Left = 497
    Top = 40
    Width = 62
    Height = 16
    Caption = 'CountBox'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 752
    Top = 40
    Width = 240
    Height = 16
    Alignment = taCenter
    Caption = 'ACTIONS ON ALL SELECTED CLIENTS'
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 13041663
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label28: TLabel
    Left = 16
    Top = 40
    Width = 221
    Height = 16
    Alignment = taCenter
    Caption = 'FILTER CLIENTS (and/or click Find)'
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 13041663
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object GraphBtn: TSpeedButton
    Left = 344
    Top = 416
    Width = 41
    Height = 33
    Hint = 'Client Statistic - Graphical Charts'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    Glyph.Data = {
      56020000424D5602000000000000760000002800000024000000180000000100
      040000000000E001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF0000FFFF0000000000000000000000000FFFFFFF
      0000FFFF00888888888888888888888880FFFFFF0000FFFF0800000078800000
      78800000780FFFFF0000FFFF088099900780EEE00780BBB00780FFFF0000FFFF
      088099903070EEE06070BBB050780FFF0000FFFF088099903070EEE06070BBB0
      507780FF0000FFFF088099903000EEE06000BBB0500000FF0000FFFF08809990
      30F0EEE060F0BBB050FFFFFF0000FFFF0880999030F0EEE060F0BBB050FFFFFF
      0000FFFF0880999030F0EEE060F0BBB050FFFFFF0000FFFF0880999030F0EEE0
      60F0BBB050FFFFFF0000FFFF0880000030F0EEE060F0BBB050FFFFFF0000FFFF
      0888099900F0EEE060F0BBB050FFFFFF0000FFFF0888800000F0EEE060F0BBB0
      50FFFFFF0000FFFF088880FFFFF0EEE060F0BBB050FFFFFF0000FFFF088880FF
      FFF0EEE060F0BBB050FFFFFF0000FFFF088880FFFFF0EEE060F0BBB050FFFFFF
      0000FFFFF08880FFFFF0EEE060FF0BBB00FFFFFF0000FFFFFF0880FFFFF0EEE0
      60FFF00000FFFFFF0000FFFFFFF080FFFFF0000060FFFFFFFFFFFFFF0000FFFF
      FFFF00FFFFFF0EEE00FFFFFFFFFFFFFF0000FFFFFFFFF0FFFFFFF00000FFFFFF
      FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = GraphBtnClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 56
    Width = 217
    Height = 470
    BevelWidth = 2
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label6: TLabel
      Left = 68
      Top = 42
      Width = 37
      Height = 13
      Caption = 'Line No'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 144
      Top = 40
      Width = 36
      Height = 13
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 116
      Top = 58
      Width = 8
      Height = 16
      Caption = '>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 116
      Top = 74
      Width = 8
      Height = 16
      Caption = '>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 36
      Top = 90
      Width = 18
      Height = 13
      Caption = 'and'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 116
      Top = 90
      Width = 8
      Height = 16
      Caption = '<'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 36
      Top = 74
      Width = 18
      Height = 13
      Caption = 'and'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 12
      Top = 259
      Width = 68
      Height = 13
      Caption = 'Data Directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 4
      Top = 26
      Width = 21
      Height = 13
      Caption = 'Pick'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 4
      Top = 42
      Width = 20
      Height = 13
      Caption = 'Line'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 8
      Top = 8
      Width = 75
      Height = 16
      Alignment = taCenter
      Caption = 'Tax Criteria'
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 8
      Top = 112
      Width = 114
      Height = 16
      Alignment = taCenter
      Caption = 'and Other Criteria'
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label15: TLabel
      Left = 4
      Top = 154
      Width = 85
      Height = 13
      Caption = 'and Marital Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label19: TLabel
      Left = 20
      Top = 130
      Width = 19
      Height = 13
      Caption = 'Age'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label20: TLabel
      Left = 44
      Top = 130
      Width = 8
      Height = 16
      Caption = '>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label21: TLabel
      Left = 100
      Top = 130
      Width = 40
      Height = 13
      Caption = 'and Age'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label22: TLabel
      Left = 152
      Top = 128
      Width = 8
      Height = 16
      Caption = '<'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label26: TLabel
      Left = 52
      Top = 130
      Width = 8
      Height = 16
      Caption = '='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label27: TLabel
      Left = 160
      Top = 128
      Width = 8
      Height = 16
      Caption = '='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 4
      Top = 170
      Width = 84
      Height = 12
      Caption = '(check one or more)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 14
      Top = 302
      Width = 117
      Height = 13
      Caption = 'If no '#39'filter'#39', just click Find'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LineBox1: TEdit
      Left = 64
      Top = 56
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object LineBox2: TEdit
      Left = 64
      Top = 72
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object AmountBox1: TEdit
      Left = 136
      Top = 56
      Width = 65
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '0'
    end
    object AmountBox2: TEdit
      Left = 136
      Top = 72
      Width = 65
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = '0'
    end
    object LineBox3: TEdit
      Left = 64
      Top = 88
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object AmountBox3: TEdit
      Left = 136
      Top = 88
      Width = 65
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = '0'
    end
    object DataDirBox: TEdit
      Left = 8
      Top = 275
      Width = 196
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
      Text = 'DataDirBox'
      OnExit = DataDirBoxExit
      OnKeyPress = DataDirBoxKeyPress
    end
    object Button1: TButton
      Left = 4
      Top = 56
      Width = 21
      Height = 17
      Hint = 'Pick a line, First condition'
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 4
      Top = 72
      Width = 21
      Height = 17
      Hint = 'Pick a line, second condition'
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 4
      Top = 88
      Width = 21
      Height = 17
      Hint = 'Pick a line, thitrd condition'
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = Button3Click
    end
    object AgeBox1: TEdit
      Left = 64
      Top = 128
      Width = 25
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      MaxLength = 6
      ParentFont = False
      TabOrder = 9
      OnChange = AgeBox1Change
    end
    object AgeBox2: TEdit
      Left = 176
      Top = 128
      Width = 25
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      TabOrder = 10
      OnChange = AgeBox2Change
    end
    object MarBox1: TCheckBox
      Left = 95
      Top = 151
      Width = 97
      Height = 17
      Caption = 'Married'
      TabOrder = 11
    end
    object MarBox2: TCheckBox
      Left = 95
      Top = 167
      Width = 109
      Height = 17
      Caption = 'Common-law'
      TabOrder = 12
    end
    object MarBox3: TCheckBox
      Left = 95
      Top = 183
      Width = 97
      Height = 17
      Caption = 'Widowe(r)'
      TabOrder = 13
    end
    object MarBox4: TCheckBox
      Left = 95
      Top = 199
      Width = 97
      Height = 17
      Caption = 'Divorced'
      TabOrder = 14
    end
    object MarBox5: TCheckBox
      Left = 95
      Top = 215
      Width = 97
      Height = 17
      Caption = 'Separated'
      TabOrder = 15
    end
    object MarBox6: TCheckBox
      Left = 95
      Top = 231
      Width = 97
      Height = 17
      Caption = 'Single'
      TabOrder = 16
    end
    object FindBtn: TBitBtn
      Left = 8
      Top = 320
      Width = 121
      Height = 35
      Hint = 'Click to find the returns based on above criteria'
      Caption = '&Find'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Glyph.Data = {
        46060000424D4606000000000000360400002800000018000000160000000100
        0800000000001002000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A4003F3F5F003F3F7F003F3F9F003F3FBF003F3FDF003F3FFF003F5F3F003F5F
        5F003F5F7F003F5F9F003F5FBF003F5FDF003F5FFF003F7F3F003F7F5F003F7F
        7F003F7F9F003F7FBF003F7FDF003F7FFF003F9F3F003F9F5F003F9F7F003F9F
        9F003F9FBF003F9FDF003F9FFF003FBF3F003FBF5F003FBF7F003FBF9F003FBF
        BF003FBFDF003FBFFF003FDF3F003FDF5F003FDF7F003FDF9F003FDFBF003FDF
        DF003FDFFF003FFF3F003FFF5F003FFF7F003FFF9F003FFFBF003FFFDF003FFF
        FF005F3F3F005F3F5F005F3F7F005F3F9F005F3FBF005F3FDF005F3FFF005F5F
        3F005F5F5F005F5F7F005F5F9F005F5FBF005F5FDF005F5FFF005F7F3F005F7F
        5F005F7F7F005F7F9F005F7FBF005F7FDF005F7FFF005F9F3F005F9F5F005F9F
        7F005F9F9F005F9FBF005F9FDF005F9FFF005FBF3F005FBF5F005FBF7F005FBF
        9F005FBFBF005FBFDF005FBFFF005FDF3F005FDF5F005FDF7F005FDF9F005FDF
        BF005FDFDF005FDFFF005FFF3F005FFF5F005FFF7F005FFF9F005FFFBF005FFF
        DF005FFFFF007F3F3F007F3F5F007F3F7F007F3F9F007F3FBF007F3FDF007F3F
        FF007F5F3F007F5F5F007F5F7F007F5F9F007F5FBF007F5FDF007F5FFF007F7F
        3F007F7F5F007F7F7F007F7F9F007F7FBF007F7FDF007F7FFF007F9F3F007F9F
        5F007F9F7F007F9F9F007F9FBF007F9FDF007F9FFF007FBF3F007FBF5F007FBF
        7F007FBF9F007FBFBF007FBFDF007FBFFF007FDF3F007FDF5F007FDF7F007FDF
        9F007FDFBF007FDFDF007FDFFF007FFF3F007FFF5F007FFF7F007FFF9F007FFF
        BF007FFFDF007FFFFF009F3F3F009F3F5F009F3F7F009F3F9F009F3FBF009F3F
        DF009F3FFF009F5F3F009F5F5F009F5F7F009F5F9F009F5FBF009F5FDF009F5F
        FF009F7F3F009F7F5F009F7F7F009F7F9F009F7FBF009F7FDF009F7FFF009F9F
        3F009F9F5F009F9F7F009F9F9F009F9FBF009F9FDF009F9FFF009FBF3F009FBF
        5F009FBF7F009FBF9F009FBFBF009FBFDF009FBFFF009FDF3F009FDF5F009FDF
        7F009FDF9F009FDFBF009FDFDF009FDFFF009FFF3F009FFF5F009FFF7F009FFF
        9F009FFFBF009FFFDF009FFFFF00BF3F3F00BF3F5F00BF3F7F00BF3F9F00BF3F
        BF00BF3FDF00BF3FFF00BF5F3F00BF5F5F00BF5F7F00BF5F9F00BF5FBF00BF5F
        DF00BF5FFF00BF7F3F00BF7F5F00BF7F7F00BF7F9F00BF7FBF00BF7FDF00BF7F
        FF00BF9F3F00BF9F5F00BF9F7F00BF9F9F00BF9FBF00BF9FDF00BF9FFF00BFBF
        3F00BFBF5F00BFBF7F00BFBF9F00BFBFBF00BFBFDF00BFBFFF00BFDF3F00BFDF
        5F00BFDF7F00BFDF9F00BFDFBF00BFDFDF00F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070700000007070707070000000707070707070707070707070700070007
        0707070700070007070707070707070707070707000000F80707077B00000007
        0707070707070707070707070000000000000000000000070707070707070707
        0707070700070000000007000000000707070707070707070707070700070000
        00000700000000070707070707F8000000000000000000000000000000000007
        070707070700FEFEFEFEFEFE00000000007B000000000707070707070700FEFE
        FEFEFEFEFEFE0000FE00070000070707070707070700FEFEFEFEFEFEFEFE0000
        FE00070000070707070707070700FEFEFEFEFEFEFEFE0000FE00070000070707
        070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707070707070700FEFE
        FEFEFEFEFEFEFEFEFE00070707070707070707070700FEFEFEFEFEFEFEFEFEFE
        FE00000707070707070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707
        0707070707000000FEFEFE000000000000F80707070707070707070707070700
        0000000707070707070707070707070707070707070707070707070707070707
        07070707070707070707}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 18
      OnClick = FindBtnClick
    end
    object AdvancedBtn: TBitBtn
      Left = 8
      Top = 361
      Width = 121
      Height = 35
      Hint = 'Above filter criteria are ignored'
      Caption = 'Advanced Filter...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        46060000424D4606000000000000360400002800000018000000160000000100
        0800000000001002000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A4003F3F5F003F3F7F003F3F9F003F3FBF003F3FDF003F3FFF003F5F3F003F5F
        5F003F5F7F003F5F9F003F5FBF003F5FDF003F5FFF003F7F3F003F7F5F003F7F
        7F003F7F9F003F7FBF003F7FDF003F7FFF003F9F3F003F9F5F003F9F7F003F9F
        9F003F9FBF003F9FDF003F9FFF003FBF3F003FBF5F003FBF7F003FBF9F003FBF
        BF003FBFDF003FBFFF003FDF3F003FDF5F003FDF7F003FDF9F003FDFBF003FDF
        DF003FDFFF003FFF3F003FFF5F003FFF7F003FFF9F003FFFBF003FFFDF003FFF
        FF005F3F3F005F3F5F005F3F7F005F3F9F005F3FBF005F3FDF005F3FFF005F5F
        3F005F5F5F005F5F7F005F5F9F005F5FBF005F5FDF005F5FFF005F7F3F005F7F
        5F005F7F7F005F7F9F005F7FBF005F7FDF005F7FFF005F9F3F005F9F5F005F9F
        7F005F9F9F005F9FBF005F9FDF005F9FFF005FBF3F005FBF5F005FBF7F005FBF
        9F005FBFBF005FBFDF005FBFFF005FDF3F005FDF5F005FDF7F005FDF9F005FDF
        BF005FDFDF005FDFFF005FFF3F005FFF5F005FFF7F005FFF9F005FFFBF005FFF
        DF005FFFFF007F3F3F007F3F5F007F3F7F007F3F9F007F3FBF007F3FDF007F3F
        FF007F5F3F007F5F5F007F5F7F007F5F9F007F5FBF007F5FDF007F5FFF007F7F
        3F007F7F5F007F7F7F007F7F9F007F7FBF007F7FDF007F7FFF007F9F3F007F9F
        5F007F9F7F007F9F9F007F9FBF007F9FDF007F9FFF007FBF3F007FBF5F007FBF
        7F007FBF9F007FBFBF007FBFDF007FBFFF007FDF3F007FDF5F007FDF7F007FDF
        9F007FDFBF007FDFDF007FDFFF007FFF3F007FFF5F007FFF7F007FFF9F007FFF
        BF007FFFDF007FFFFF009F3F3F009F3F5F009F3F7F009F3F9F009F3FBF009F3F
        DF009F3FFF009F5F3F009F5F5F009F5F7F009F5F9F009F5FBF009F5FDF009F5F
        FF009F7F3F009F7F5F009F7F7F009F7F9F009F7FBF009F7FDF009F7FFF009F9F
        3F009F9F5F009F9F7F009F9F9F009F9FBF009F9FDF009F9FFF009FBF3F009FBF
        5F009FBF7F009FBF9F009FBFBF009FBFDF009FBFFF009FDF3F009FDF5F009FDF
        7F009FDF9F009FDFBF009FDFDF009FDFFF009FFF3F009FFF5F009FFF7F009FFF
        9F009FFFBF009FFFDF009FFFFF00BF3F3F00BF3F5F00BF3F7F00BF3F9F00BF3F
        BF00BF3FDF00BF3FFF00BF5F3F00BF5F5F00BF5F7F00BF5F9F00BF5FBF00BF5F
        DF00BF5FFF00BF7F3F00BF7F5F00BF7F7F00BF7F9F00BF7FBF00BF7FDF00BF7F
        FF00BF9F3F00BF9F5F00BF9F7F00BF9F9F00BF9FBF00BF9FDF00BF9FFF00BFBF
        3F00BFBF5F00BFBF7F00BFBF9F00BFBFBF00BFBFDF00BFBFFF00BFDF3F00BFDF
        5F00BFDF7F00BFDF9F00BFDFBF00BFDFDF00F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070700000007070707070000000707070707070707070707070700070007
        0707070700070007070707070707070707070707000000F80707077B00000007
        0707070707070707070707070000000000000000000000070707070707070707
        0707070700070000000007000000000707070707070707070707070700070000
        00000700000000070707070707F8000000000000000000000000000000000007
        070707070700FEFEFEFEFEFE00000000007B000000000707070707070700FEFE
        FEFEFEFEFEFE0000FE00070000070707070707070700FEFEFEFEFEFEFEFE0000
        FE00070000070707070707070700FEFEFEFEFEFEFEFE0000FE00070000070707
        070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707070707070700FEFE
        FEFEFEFEFEFEFEFEFE00070707070707070707070700FEFEFEFEFEFEFEFEFEFE
        FE00000707070707070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707
        0707070707000000FEFEFE000000000000F80707070707070707070707070700
        0000000707070707070707070707070707070707070707070707070707070707
        07070707070707070707}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 19
      OnClick = AdvancedBtnClick
    end
    object FpFindBtn: TBitBtn
      Left = 6
      Top = 402
      Width = 201
      Height = 34
      Hint = 'Above filter criteria are ignored'
      Caption = 'Financial Planning services...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        46060000424D4606000000000000360400002800000018000000160000000100
        0800000000001002000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A4003F3F5F003F3F7F003F3F9F003F3FBF003F3FDF003F3FFF003F5F3F003F5F
        5F003F5F7F003F5F9F003F5FBF003F5FDF003F5FFF003F7F3F003F7F5F003F7F
        7F003F7F9F003F7FBF003F7FDF003F7FFF003F9F3F003F9F5F003F9F7F003F9F
        9F003F9FBF003F9FDF003F9FFF003FBF3F003FBF5F003FBF7F003FBF9F003FBF
        BF003FBFDF003FBFFF003FDF3F003FDF5F003FDF7F003FDF9F003FDFBF003FDF
        DF003FDFFF003FFF3F003FFF5F003FFF7F003FFF9F003FFFBF003FFFDF003FFF
        FF005F3F3F005F3F5F005F3F7F005F3F9F005F3FBF005F3FDF005F3FFF005F5F
        3F005F5F5F005F5F7F005F5F9F005F5FBF005F5FDF005F5FFF005F7F3F005F7F
        5F005F7F7F005F7F9F005F7FBF005F7FDF005F7FFF005F9F3F005F9F5F005F9F
        7F005F9F9F005F9FBF005F9FDF005F9FFF005FBF3F005FBF5F005FBF7F005FBF
        9F005FBFBF005FBFDF005FBFFF005FDF3F005FDF5F005FDF7F005FDF9F005FDF
        BF005FDFDF005FDFFF005FFF3F005FFF5F005FFF7F005FFF9F005FFFBF005FFF
        DF005FFFFF007F3F3F007F3F5F007F3F7F007F3F9F007F3FBF007F3FDF007F3F
        FF007F5F3F007F5F5F007F5F7F007F5F9F007F5FBF007F5FDF007F5FFF007F7F
        3F007F7F5F007F7F7F007F7F9F007F7FBF007F7FDF007F7FFF007F9F3F007F9F
        5F007F9F7F007F9F9F007F9FBF007F9FDF007F9FFF007FBF3F007FBF5F007FBF
        7F007FBF9F007FBFBF007FBFDF007FBFFF007FDF3F007FDF5F007FDF7F007FDF
        9F007FDFBF007FDFDF007FDFFF007FFF3F007FFF5F007FFF7F007FFF9F007FFF
        BF007FFFDF007FFFFF009F3F3F009F3F5F009F3F7F009F3F9F009F3FBF009F3F
        DF009F3FFF009F5F3F009F5F5F009F5F7F009F5F9F009F5FBF009F5FDF009F5F
        FF009F7F3F009F7F5F009F7F7F009F7F9F009F7FBF009F7FDF009F7FFF009F9F
        3F009F9F5F009F9F7F009F9F9F009F9FBF009F9FDF009F9FFF009FBF3F009FBF
        5F009FBF7F009FBF9F009FBFBF009FBFDF009FBFFF009FDF3F009FDF5F009FDF
        7F009FDF9F009FDFBF009FDFDF009FDFFF009FFF3F009FFF5F009FFF7F009FFF
        9F009FFFBF009FFFDF009FFFFF00BF3F3F00BF3F5F00BF3F7F00BF3F9F00BF3F
        BF00BF3FDF00BF3FFF00BF5F3F00BF5F5F00BF5F7F00BF5F9F00BF5FBF00BF5F
        DF00BF5FFF00BF7F3F00BF7F5F00BF7F7F00BF7F9F00BF7FBF00BF7FDF00BF7F
        FF00BF9F3F00BF9F5F00BF9F7F00BF9F9F00BF9FBF00BF9FDF00BF9FFF00BFBF
        3F00BFBF5F00BFBF7F00BFBF9F00BFBFBF00BFBFDF00BFBFFF00BFDF3F00BFDF
        5F00BFDF7F00BFDF9F00BFDFBF00BFDFDF00F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070700000007070707070000000707070707070707070707070700070007
        0707070700070007070707070707070707070707000000F80707077B00000007
        0707070707070707070707070000000000000000000000070707070707070707
        0707070700070000000007000000000707070707070707070707070700070000
        00000700000000070707070707F8000000000000000000000000000000000007
        070707070700FEFEFEFEFEFE00000000007B000000000707070707070700FEFE
        FEFEFEFEFEFE0000FE00070000070707070707070700FEFEFEFEFEFEFEFE0000
        FE00070000070707070707070700FEFEFEFEFEFEFEFE0000FE00070000070707
        070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707070707070700FEFE
        FEFEFEFEFEFEFEFEFE00070707070707070707070700FEFEFEFEFEFEFEFEFEFE
        FE00000707070707070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707
        0707070707000000FEFEFE000000000000F80707070707070707070707070700
        0000000707070707070707070707070707070707070707070707070707070707
        07070707070707070707}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 20
      OnClick = FpFindBtnClick
    end
  end
  object Panel3: TPanel
    Left = 753
    Top = 273
    Width = 235
    Height = 253
    BevelWidth = 2
    BorderStyle = bsSingle
    TabOrder = 1
    object PrintListBtn: TBitBtn
      Left = 59
      Top = 8
      Width = 97
      Height = 49
      Caption = 'Print Listing'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
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
      TabOrder = 0
      OnClick = PrintListBtnClick
    end
    object PrintLabelsBtn: TBitBtn
      Left = 59
      Top = 56
      Width = 97
      Height = 55
      Caption = 'Print Labels'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
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
      TabOrder = 1
      OnClick = PrintLabelsBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 59
      Top = 185
      Width = 97
      Height = 40
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = CancelBtnClick
    end
    object CreateEmailListBtn: TBitBtn
      Left = 59
      Top = 112
      Width = 97
      Height = 55
      Caption = 'Create EMAIL list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Layout = blGlyphTop
      ParentFont = False
      TabOrder = 3
      OnClick = CreateEmailListBtnClick
    end
    object SendEmailbtn: TBitBtn
      Left = 171
      Top = 133
      Width = 47
      Height = 20
      Caption = 'Send Email'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Layout = blGlyphTop
      ParentFont = False
      TabOrder = 4
      Visible = False
      OnClick = SendEmailbtnClick
    end
  end
  object Panel4: TPanel
    Left = 753
    Top = 56
    Width = 235
    Height = 204
    BevelWidth = 2
    BorderStyle = bsSingle
    TabOrder = 2
    object PrintLetterBtn: TBitBtn
      Left = 15
      Top = 136
      Width = 112
      Height = 47
      Caption = 'Print Selected Letter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
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
      Spacing = 2
      TabOrder = 0
      OnClick = PrintLetterBtnClick
    end
    object FileListBox1: TFileListBox
      Left = 7
      Top = 7
      Width = 204
      Height = 122
      Color = 16777153
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ItemHeight = 13
      Mask = '*.RTF'
      ParentFont = False
      TabOrder = 1
    end
    object DesignBtn: TBitBtn
      Left = 133
      Top = 136
      Width = 78
      Height = 47
      Caption = 'Design...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Glyph.Data = {
        F6010000424DF60100000000000076000000280000001F000000180000000100
        0400000000008001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        777777777777777777797770000000000000000000000777777F777066666666
        6666666666660777777E77706666666666666666666607777777777066066066
        0660660660660777777077708808808808808808808807777771777000000000
        00000000000007777770777770F999999999999077777777777F777770999999
        99999007777777777770777770F9000000999000777777777773777770990777
        09990808087777777771777770F907709990780780777777777D777770990709
        9907770878077777777D777770F900999077770788807777777D777770990999
        07777780BB8087777770777770F99990777777707B880777777C777770999907
        777777780BB808777775777770F990777777777807B88077777F777770990777
        7777777780BB80877772777770F0777777777777807B01077773777770077777
        7777777778011107777E77777077777777777777780111077770777777777777
        777777777780008777707777777777777777777777777777777C}
      Layout = blGlyphTop
      ParentFont = False
      TabOrder = 2
      OnClick = DesignBtnClick
    end
  end
  object Panel2: TPanel
    Left = 231
    Top = 56
    Width = 512
    Height = 470
    BevelWidth = 2
    BorderStyle = bsSingle
    TabOrder = 3
    object ListBox1: TListBox
      Left = 8
      Top = 8
      Width = 490
      Height = 350
      Color = 16777153
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnDblClick = ListBox1DblClick
    end
    object SaveBtn: TBitBtn
      Left = 113
      Top = 365
      Width = 89
      Height = 25
      Caption = '&Save list..'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = SaveBtnClick
    end
    object OpenBtn: TBitBtn
      Left = 230
      Top = 365
      Width = 121
      Height = 25
      Caption = '&Open existing list..'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = OpenBtnClick
    end
    object ClearListBtn: TButton
      Left = 113
      Top = 397
      Width = 89
      Height = 25
      Caption = '&Clear List'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = ClearListBtnClick
    end
    object ManualBtn: TButton
      Left = 230
      Top = 397
      Width = 121
      Height = 25
      Caption = '&Add manually...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = ManualBtnClick
    end
    object OpenReturnBtn: TBitBtn
      Left = 112
      Top = 428
      Width = 239
      Height = 25
      Caption = 'Open a selected return (or double click it)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = OpenReturnBtnClick
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 1003
    Height = 33
    Align = alTop
    Caption = 'Client Data Base Analyser'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object Memo1: TMemo
    Left = 9
    Top = 539
    Width = 636
    Height = 17
    Lines.Strings = (
      'M'
      'e'
      'm'
      'o'
      '1')
    TabOrder = 5
    Visible = False
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 392
    Top = 256
  end
  object SaveDialog1: TSaveDialog
    Left = 360
    Top = 200
  end
  object OpenDialog1: TOpenDialog
    Left = 352
    Top = 248
  end
  object PrintDialog1: TPrintDialog
    Left = 251
    Top = 421
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 287
    Top = 216
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 303
    Top = 272
  end
end
