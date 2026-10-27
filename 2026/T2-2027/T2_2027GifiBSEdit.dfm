object GifiBSEditT2_2027: TGifiBSEditT2_2027
  Left = 374
  Top = 202
  Caption = 'GENERAL INDEX OF FINANCIAL INFORMATION (GIFI)'
  ClientHeight = 746
  ClientWidth = 1030
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 1030
    Height = 33
    Align = alTop
    Alignment = taLeftJustify
    Caption = '   G I F I  Balance Sheet  (RSI Schedule 100/101)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 511
      Top = 7
      Width = 148
      Height = 25
      Caption = '&CRA GIFI GUIDE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = BitBtn1Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 115
    Width = 1030
    Height = 631
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Closing Balance Sheet'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 1022
        Height = 603
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object TreeView1: TTreeView
          Left = 1
          Top = 36
          Width = 1020
          Height = 566
          Align = alClient
          AutoExpand = True
          Color = 16777088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          HotTrack = True
          Indent = 19
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          RowSelect = True
          ShowHint = False
          TabOrder = 0
          ToolTips = False
          OnDblClick = TreeView1DblClick
          OnKeyPress = TreeView1KeyPress
        end
        object Panel4: TPanel
          Left = 1
          Top = 1
          Width = 1020
          Height = 35
          Align = alTop
          Caption = ' '
          TabOrder = 1
          object Label5: TLabel
            Left = 637
            Top = 7
            Width = 51
            Height = 15
            Caption = 'Last Year'
          end
          object Label6: TLabel
            Left = 735
            Top = 7
            Width = 51
            Height = 15
            Caption = 'This Year'
          end
          object Label7: TLabel
            Left = 616
            Top = 21
            Width = 96
            Height = 12
            Caption = '(Optional/Not for CRA)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 1030
    Height = 66
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object CollapseBtn1: TBitBtn
      Left = 455
      Top = 35
      Width = 69
      Height = 25
      Hint = 'Collapse all acounts'
      Caption = 'Collapse All'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = CollapseBtn1Click
    end
    object ExpandBtn1: TBitBtn
      Left = 455
      Top = 14
      Width = 69
      Height = 22
      Hint = 'Expand all accounts'
      Caption = 'Expand All'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = ExpandBtn1Click
    end
    object BsNoBox: TRadioGroup
      Left = 8
      Top = 7
      Width = 329
      Height = 50
      Caption = ' Select'
      Color = 16777088
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Closing B/S'
        'Opening B/S (New Corp)')
      ParentColor = False
      TabOrder = 0
      OnClick = BsNoBoxClick
    end
    object CancelBtn: TBitBtn
      Left = 861
      Top = 14
      Width = 89
      Height = 45
      Hint = 'Save the GIFI data before closing the form'
      Cancel = True
      Caption = 'Save and Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = CancelBtnClick
    end
    object RecalcBtn: TBitBtn
      Left = 686
      Top = 14
      Width = 71
      Height = 22
      Hint = 'Recalculate this statement '
      Caption = 'Recalc GIFI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = RecalcBtnClick
    end
    object FindKeyWBtn: TBitBtn
      Left = 630
      Top = 14
      Width = 46
      Height = 45
      Hint = 'Search line number or description of account'
      Caption = 'Find...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
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
      Layout = blGlyphTop
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 1
      TabOrder = 6
      OnClick = FindKeyWBtnClick
    end
    object BatchEntryBtn: TBitBtn
      Left = 357
      Top = 14
      Width = 81
      Height = 25
      Hint = 'Fast data entry by Line Number'
      Caption = 'Batch Entry...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BatchEntryBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 770
      Top = 14
      Width = 79
      Height = 45
      Hint = 'Show a Print Preview and Print if needed'
      Caption = 'Print preview'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
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
      Spacing = 1
      TabOrder = 9
      OnClick = PrintBtnClick
    end
    object ClearBtn: TBitBtn
      Left = 686
      Top = 35
      Width = 71
      Height = 25
      Hint = 'Clear all data'
      Caption = 'Clear Form'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = ClearBtnClick
    end
    object ImportBtn: TBitBtn
      Left = 357
      Top = 35
      Width = 81
      Height = 25
      Hint = 'Import from an external GIF file'
      Caption = 'Import GIFI...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = ImportBtnClick
    end
    object LastYrBtn: TBitBtn
      Left = 539
      Top = 14
      Width = 78
      Height = 43
      Hint = 'Show last year'#39's data'
      Caption = 'Show Last Year'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = LastYrBtnClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 99
    Width = 1030
    Height = 16
    Align = alTop
    Caption = 
      'For low volume data entry: Expand by clicking the + item and the' +
      'n double click (or space bar) on a line. Otherwise select Import' +
      ' GIFI or Batch Entry'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object DataSource1: TDataSource
    Left = 718
    Top = 1
  end
  object PrintDialog1: TPrintDialog
    Left = 752
    Top = 2
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'GFI'
    Filter = 'GIFI files(*.GFI)|*.GFI'
    InitialDir = 'K:\delphi\T2\certif00'
    Left = 853
    Top = 1
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 823
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 791
  end
end
