object FrmtypesT1_2026: TFrmtypesT1_2026
  Left = 187
  Top = 98
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeToolWin
  Caption = 'Forms Explorer (FormType)'
  ClientHeight = 791
  ClientWidth = 1014
  Color = clBtnFace
  Constraints.MaxHeight = 910
  Constraints.MaxWidth = 1030
  Constraints.MinHeight = 710
  Constraints.MinWidth = 1030
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 52
    Top = 30
    Width = 596
    Height = 13
    Caption = 
      'Double click or press Enter.    Select/Unselect with space bar o' +
      'r single click    Change section with TAB'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1014
    Height = 45
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object SwapBtn: TBitBtn
      Left = 7
      Top = 2
      Width = 148
      Height = 29
      Hint = 'Swap returns'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
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
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = SwapBtnClick
    end
    object OpenBtn: TBitBtn
      Left = 154
      Top = 2
      Width = 148
      Height = 29
      Caption = '&Open'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = OpenBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 301
      Top = 2
      Width = 148
      Height = 29
      Caption = '&Print Form'
      Default = True
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = PrintBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 742
      Top = 2
      Width = 148
      Height = 29
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 3
      OnClick = CancelBtnClick
    end
    object FindBtn: TBitBtn
      Left = 448
      Top = 2
      Width = 148
      Height = 29
      Caption = 'Find Form/Line'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
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
      Spacing = 2
      TabOrder = 4
      OnClick = FindBtnClick
    end
    object FindAlphaBtn: TBitBtn
      Left = 595
      Top = 2
      Width = 148
      Height = 29
      Caption = 'Alphabetical View'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
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
      Spacing = 2
      TabOrder = 5
      OnClick = FindAlphaBtnClick
    end
  end
  object PanelFind: TPanel
    Left = 0
    Top = 45
    Width = 1014
    Height = 35
    Align = alTop
    Color = clActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clActiveCaption
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object Label15: TLabel
      Left = 7
      Top = 14
      Width = 130
      Height = 14
      Caption = 'Find (Form or keyword)'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label16: TLabel
      Left = 287
      Top = 14
      Width = 167
      Height = 14
      Caption = 'or double-ckick an item below'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label11: TLabel
      Left = 490
      Top = 14
      Width = 265
      Height = 14
      Caption = 'Highlighted items have data and/or will be saved'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object LastYearLabel: TLabel
      Left = 770
      Top = 14
      Width = 127
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Caption = 'LAST YEAR'#39's FORMS'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object FormBox: TEdit
      Left = 147
      Top = 7
      Width = 127
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnExit = FormBoxExit
    end
  end
  object Panel3: TPanel
    Left = 510
    Top = 80
    Width = 170
    Height = 711
    Align = alLeft
    Constraints.MaxWidth = 180
    Constraints.MinHeight = 100
    Constraints.MinWidth = 100
    TabOrder = 2
    object Label4: TLabel
      Left = 1
      Top = 1
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'Self-Empl/Rental'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 97
    end
    object Label13: TLabel
      Left = 1
      Top = 257
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'SUMMARIES'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 75
    end
    object Label12: TLabel
      Left = 1
      Top = 459
      Width = 168
      Height = 13
      Align = alBottom
      Caption = 'Mult. Jurisd. (MJ)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 98
    end
    object SEList: TListBox
      Left = 1
      Top = 14
      Width = 168
      Height = 243
      Style = lbOwnerDrawFixed
      Align = alTop
      Color = clWhite
      Constraints.MinHeight = 80
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnDblClick = SEListDblClick
      OnDrawItem = SEListDrawItem
      OnKeyPress = SEListKeyPress
      OnMouseDown = SEListMouseDown
    end
    object SmList: TListBox
      Left = 1
      Top = 270
      Width = 168
      Height = 189
      Style = lbOwnerDrawFixed
      Align = alClient
      Color = clWhite
      Constraints.MinHeight = 80
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 1
      OnDblClick = SmListDblClick
      OnDrawItem = SmListDrawItem
      OnKeyPress = SmListKeyPress
      OnMouseDown = SmListMouseDown
    end
    object MjList: TListBox
      Left = 1
      Top = 472
      Width = 168
      Height = 238
      Style = lbOwnerDrawFixed
      Align = alBottom
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 2
      OnDblClick = MJListDblClick
      OnDrawItem = MJListDrawItem
      OnKeyPress = MJListKeyPress
      OnMouseDown = MJListMouseDown
    end
  end
  object Panel4: TPanel
    Left = 340
    Top = 80
    Width = 170
    Height = 711
    Align = alLeft
    Caption = 'Panel4'
    Constraints.MaxWidth = 180
    Constraints.MinHeight = 100
    Constraints.MinWidth = 100
    TabOrder = 3
    object Label3: TLabel
      Left = 1
      Top = 1
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'Slips'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 28
    end
    object Label8: TLabel
      Left = 1
      Top = 330
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'Carry-Forward & Hist'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      ExplicitWidth = 116
    end
    object Label10: TLabel
      Left = 13
      Top = 465
      Width = 121
      Height = 13
      Caption = 'Expl/Dev Statements'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label17: TLabel
      Left = 14
      Top = 577
      Width = 144
      Height = 13
      Caption = 'SERS -Special Elections '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SLList: TListBox
      Left = 1
      Top = 14
      Width = 168
      Height = 316
      Style = lbOwnerDrawFixed
      Align = alTop
      Color = clWhite
      Constraints.MinHeight = 80
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnDblClick = SLListDblClick
      OnDrawItem = SLListDrawItem
      OnKeyPress = SLListKeyPress
      OnMouseDown = SLListMouseDown
    end
    object CFList: TListBox
      Left = 1
      Top = 343
      Width = 168
      Height = 110
      Style = lbOwnerDrawFixed
      Align = alTop
      Color = clWhite
      Constraints.MinHeight = 80
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 1
      OnDblClick = CFListDblClick
      OnDrawItem = CFListDrawItem
      OnKeyPress = CFListKeyPress
      OnMouseDown = CFListMouseDown
    end
    object REList: TListBox
      Left = 5
      Top = 484
      Width = 168
      Height = 87
      Style = lbOwnerDrawFixed
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 2
      OnDblClick = REListDblClick
      OnDrawItem = REListDrawItem
      OnKeyPress = REListKeyPress
      OnMouseDown = REListMouseDown
    end
    object SERSLIST: TListBox
      Left = 5
      Top = 596
      Width = 168
      Height = 107
      Style = lbOwnerDrawFixed
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 3
      OnDblClick = REListDblClick
      OnDrawItem = REListDrawItem
      OnKeyPress = REListKeyPress
      OnMouseDown = REListMouseDown
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 80
    Width = 170
    Height = 711
    Align = alLeft
    Caption = 'Panel5'
    Constraints.MaxWidth = 180
    Constraints.MinHeight = 100
    Constraints.MinWidth = 100
    TabOrder = 4
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'FED T1/Schedules'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
      ExplicitWidth = 109
    end
    object Label7: TLabel
      Left = 1
      Top = 386
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'Admin'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 35
    end
    object Label14: TLabel
      Left = 1
      Top = 548
      Width = 168
      Height = 13
      Align = alBottom
      Caption = 'Client Letters'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 76
    end
    object T1List: TListBox
      Left = 1
      Top = 14
      Width = 168
      Height = 372
      Style = lbOwnerDrawFixed
      Align = alTop
      Color = clWhite
      Constraints.MinHeight = 80
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnDblClick = T1ListDblClick
      OnDrawItem = T1ListDrawItem
      OnKeyPress = T1ListKeyPress
      OnMouseDown = T1ListMouseDown
    end
    object ADList: TListBox
      Left = 1
      Top = 399
      Width = 168
      Height = 149
      Style = lbOwnerDrawFixed
      Align = alClient
      Color = clWhite
      Constraints.MinHeight = 80
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 1
      OnDblClick = ADListDblClick
      OnDrawItem = ADListDrawItem
      OnKeyPress = ADListKeyPress
      OnMouseDown = ADListMouseDown
    end
    object CLList: TListBox
      Left = 1
      Top = 561
      Width = 168
      Height = 149
      Style = lbOwnerDrawFixed
      Align = alBottom
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 2
      OnDblClick = CLListDblClick
      OnDrawItem = CLListDrawItem
      OnKeyPress = CLListKeyPress
      OnMouseDown = CLListMouseDown
    end
  end
  object Panel6: TPanel
    Left = 680
    Top = 80
    Width = 170
    Height = 711
    Align = alLeft
    Caption = 'Panel6'
    TabOrder = 5
    object Label5: TLabel
      Left = 1
      Top = 1
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'Federal Forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 80
    end
    object TFList: TListBox
      Left = 1
      Top = 14
      Width = 168
      Height = 696
      Style = lbOwnerDrawFixed
      Align = alClient
      Color = clWhite
      Constraints.MinHeight = 100
      Constraints.MinWidth = 100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnDblClick = TFListDblClick
      OnDrawItem = TFListDrawItem
      OnKeyPress = TFListKeyPress
      OnMouseDown = TFListMouseDown
    end
  end
  object Panel7: TPanel
    Left = 850
    Top = 80
    Width = 170
    Height = 711
    Align = alLeft
    Caption = 'Panel7'
    TabOrder = 6
    object Label6: TLabel
      Left = 1
      Top = 1
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'Worksheets (Fed)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 101
    end
    object MIList: TListBox
      Left = 1
      Top = 14
      Width = 168
      Height = 696
      Style = lbOwnerDrawFixed
      Align = alClient
      Color = clWhite
      Constraints.MinHeight = 100
      Constraints.MinWidth = 100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnDblClick = MIListDblClick
      OnDrawItem = MIListDrawItem
      OnKeyPress = MIListKeyPress
      OnMouseDown = MIListMouseDown
    end
  end
  object Panel2: TPanel
    Left = 170
    Top = 80
    Width = 170
    Height = 711
    Align = alLeft
    Caption = 'Panel2'
    TabOrder = 7
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 168
      Height = 13
      Align = alTop
      Caption = 'Prov Tax/Credits'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      ExplicitWidth = 97
    end
    object CRList: TListBox
      Left = 1
      Top = 14
      Width = 168
      Height = 696
      Style = lbOwnerDrawFixed
      Align = alClient
      Color = clWhite
      Constraints.MinHeight = 100
      Constraints.MinWidth = 100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnDblClick = MJListDblClick
      OnDrawItem = MJListDrawItem
      OnKeyPress = MJListKeyPress
      OnMouseDown = MJListMouseDown
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 938
    Top = 38
  end
end
