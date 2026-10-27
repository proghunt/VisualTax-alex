object PortFolioChartFP_2012: TPortFolioChartFP_2012
  Left = 59
  Top = 62
  Caption = 'PROPOSED PORTFOLIO REVIEW'
  ClientHeight = 477
  ClientWidth = 756
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 169
    Top = -8
    Width = 8
    Height = 473
    Hint = 'You can resize with the mouse'
    Align = alNone
    Color = clWhite
    ParentColor = False
  end
  object LeftPanel: TPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 465
    Color = clBlue
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 1
      Top = 42
      Width = 167
      Height = 404
      Hint = 'Double click for indivisual fund performance'
      Align = alClient
      Color = clBtnFace
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Arial'
      TitleFont.Style = [fsBold]
      OnCellClick = DBGrid1CellClick
      OnDblClick = DBGrid1DblClick
      OnKeyDown = DBGrid1KeyDown
    end
    object DBNavigator1: TDBNavigator
      Left = 1
      Top = 446
      Width = 167
      Height = 18
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alBottom
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 167
      Height = 41
      Align = alTop
      TabOrder = 2
      object PortFlLabel: TLabel
        Left = 32
        Top = 16
        Width = 74
        Height = 16
        Caption = 'PortFlLabel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object RightPanel: TPanel
    Left = 176
    Top = 8
    Width = 561
    Height = 457
    TabOrder = 1
    object TabbedNotebook1: TTabbedNotebook
      Left = 8
      Top = 57
      Width = 537
      Height = 392
      TabFont.Charset = DEFAULT_CHARSET
      TabFont.Color = clBtnText
      TabFont.Height = -11
      TabFont.Name = 'MS Sans Serif'
      TabFont.Style = []
      TabOrder = 0
      OnChange = TabbedNotebook1Change
      object TTabPage
        Left = 4
        Top = 25
        Caption = 'Portfolio Mix'
        object Image1: TImage
          Left = 8
          Top = 8
          Width = 513
          Height = 313
        end
      end
      object TTabPage
        Left = 4
        Top = 25
        Caption = 'Exp'#39'd Performance'
      end
      object TTabPage
        Left = 4
        Top = 25
        Caption = 'Hist'#39'l Performance'
      end
      object TTabPage
        Left = 4
        Top = 25
        Caption = 'Historical returns'
      end
      object TTabPage
        Left = 4
        Top = 25
        Caption = 'Hist'#39'l Risk - 3 Year'
      end
      object TTabPage
        Left = 4
        Top = 25
        Caption = 'Hist'#39'l Risk - 5 Years'
      end
    end
    object Panel1: TPanel
      Left = 8
      Top = 8
      Width = 481
      Height = 49
      BevelOuter = bvLowered
      TabOrder = 1
      object PortFolioTypeBox: TRadioGroup
        Left = 8
        Top = 8
        Width = 209
        Height = 33
        Caption = 'Proposed Portfolio'
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Items.Strings = (
          'Semi-Sheltered'
          'Sheltered (RRSP)')
        ParentFont = False
        TabOrder = 2
        OnClick = PortFolioTypeBoxClick
      end
      object ChartBtn: TBitBtn
        Left = 238
        Top = 8
        Width = 115
        Height = 33
        Caption = 'Performance...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
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
        TabOrder = 0
        OnClick = ChartBtnClick
      end
      object BitBtn1: TBitBtn
        Left = 368
        Top = 8
        Width = 53
        Height = 33
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Kind = bkCancel
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 1
        OnClick = BitBtn1Click
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = InvestmentPlanQ
    Left = 48
    Top = 192
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients.db')
    Left = 605
    Top = 185
  end
  object InvestmentPlanQ: TADQuery
    Connection = FDConnection
    SQL.Strings = (
      'Select * from mutualFunds')
    Left = 564
    Top = 179
  end
end
