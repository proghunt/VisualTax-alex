object PortfolioCreatorFP_2012: TPortfolioCreatorFP_2012
  Left = 146
  Top = 142
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'Portfolio Creator'
  ClientHeight = 527
  ClientWidth = 782
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object FormHeader: TPanel
    Left = 0
    Top = 0
    Width = 782
    Height = 33
    Align = alTop
    Caption = 'Visual FP - Portfolio Creator'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 790
    object CancelBtn: TBitBtn
      Left = 640
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
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
      ModalResult = 2
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 33
    Width = 782
    Height = 488
    ActivePage = TabSheet2
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 790
    object TabSheet1: TTabSheet
      Caption = 'Portfolio Set-up'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label13: TLabel
        Left = 312
        Top = -4
        Width = 129
        Height = 22
        Alignment = taCenter
        Caption = 'Portfolio Set-up'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -19
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 782
        Height = 459
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label23: TLabel
          Left = 312
          Top = 12
          Width = 5
          Height = 22
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object GroupBox3: TGroupBox
          Left = 8
          Top = 8
          Width = 361
          Height = 449
          Caption = 'List of Portfolios'
          TabOrder = 0
          object DBGrid3: TDBGrid
            Left = 8
            Top = 96
            Width = 337
            Height = 321
            DataSource = DataSource1
            FixedColor = 10930928
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = [fsBold]
            Columns = <
              item
                Color = 14933196
                Expanded = False
                FieldName = 'PortFolioName'
                ReadOnly = True
                Width = 133
                Visible = True
              end
              item
                Color = 15532031
                Expanded = False
                FieldName = 'PortfolioType'
                PickList.Strings = (
                  'SHELT'
                  'NONSH')
                Title.Caption = 'Type'
                Width = 50
                Visible = True
              end
              item
                Color = 15663103
                Expanded = False
                FieldName = 'Active'
                PickList.Strings = (
                  'Y'
                  'N')
                Width = 45
                Visible = True
              end
              item
                Color = 15532031
                Expanded = False
                FieldName = 'TotalInvestment'
                Title.Caption = 'Investment'
                Visible = True
              end>
          end
          object Panel5: TPanel
            Left = 8
            Top = 16
            Width = 337
            Height = 73
            Color = 14933196
            TabOrder = 1
            object NewPortfolioBtn: TBitBtn
              Left = 160
              Top = 8
              Width = 97
              Height = 25
              Caption = 'New Portfolio...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object DeletePortfolioBtn: TBitBtn
              Left = 264
              Top = 8
              Width = 65
              Height = 25
              Caption = 'Remove...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object ImportPortfolioBtn: TBitBtn
              Left = 8
              Top = 8
              Width = 145
              Height = 25
              Caption = 'Import model portfolio...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object PortfolioProjectionBtn: TBitBtn
              Left = 160
              Top = 32
              Width = 169
              Height = 33
              Caption = 'Portfolio Projection'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
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
              TabOrder = 3
            end
            object CurrentPortfoliosBtn: TBitBtn
              Left = 8
              Top = 32
              Width = 145
              Height = 33
              Caption = 'Current portrfolios...'
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
            end
          end
        end
      end
      object GroupBox2: TGroupBox
        Left = 365
        Top = 8
        Width = 404
        Height = 449
        Caption = 'Portfolio Composition'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        object DBGrid2: TDBGrid
          Left = 8
          Top = 96
          Width = 385
          Height = 321
          Color = clWhite
          DataSource = DataSource2
          FixedColor = 10930928
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = [fsBold]
          Columns = <
            item
              Expanded = False
              FieldName = 'FundCode'
              ReadOnly = True
              Width = 67
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FundName'
              ReadOnly = True
              Width = 241
              Visible = True
            end>
        end
        object Panel6: TPanel
          Left = 8
          Top = 16
          Width = 385
          Height = 73
          Color = 14933196
          TabOrder = 1
          object DeleteFundBtn: TBitBtn
            Left = 184
            Top = 24
            Width = 57
            Height = 25
            Caption = 'Remove...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object SelectBtn: TBitBtn
            Left = 104
            Top = 24
            Width = 57
            Height = 25
            Caption = 'Select...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Percentages and Projection'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 782
        Height = 81
        Align = alTop
        Color = 14933196
        TabOrder = 0
        object Label7: TLabel
          Left = 16
          Top = 8
          Width = 184
          Height = 24
          Alignment = taCenter
          Caption = 'Portfolio Projection:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object DBText3: TDBText
          Left = 216
          Top = 8
          Width = 393
          Height = 25
          DataField = 'PortFolioName'
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label8: TLabel
          Left = 8
          Top = 32
          Width = 121
          Height = 15
          Caption = 'Total Initial Investment'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label9: TLabel
          Left = 448
          Top = 32
          Width = 88
          Height = 15
          Caption = 'Projection years'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object CalcBtn: TBitBtn
          Left = 552
          Top = 40
          Width = 65
          Height = 33
          Caption = 'Calculate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object ProjectOptionBox: TRadioGroup
          Left = 144
          Top = 32
          Width = 289
          Height = 41
          Caption = 'Projection until:'
          Columns = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          Items.Strings = (
            'Retirement'
            'Ultimate Age'
            'Other')
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit1: TDBEdit
          Left = 24
          Top = 48
          Width = 73
          Height = 23
          Color = 14811135
          DataField = 'TotalInvestment'
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit3: TDBEdit
          Left = 472
          Top = 48
          Width = 33
          Height = 23
          Color = 14811135
          DataField = 'Years'
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object PortfolioReportBtn: TBitBtn
          Left = 630
          Top = 40
          Width = 139
          Height = 33
          Caption = 'Portfolio report...'
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
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object PortFChartBtn: TBitBtn
          Left = 687
          Top = 8
          Width = 26
          Height = 17
          Hint = 'Show fund information'
          Caption = 'Fund Report'
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
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          Visible = False
        end
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 81
        Width = 782
        Height = 264
        Align = alTop
        DataSource = DataSource2
        FixedColor = 10930928
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Arial'
        TitleFont.Style = [fsBold]
        Columns = <
          item
            Expanded = False
            FieldName = 'FundName'
            ReadOnly = True
            Width = 157
            Visible = True
          end
          item
            Color = 15532031
            Expanded = False
            FieldName = 'Percent'
            Width = 55
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'InitialInvestment'
            ReadOnly = True
            Title.Caption = 'Initial Investment'
            Width = 103
            Visible = True
          end
          item
            Color = 15532031
            Expanded = False
            FieldName = 'TypeOfReturn'
            PickList.Strings = (
              'Manual'
              '10 Yr '
              'FundLife'
              '1 Yr'
              '3 Yr'
              '5 Yr'
              'YTD')
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RateOfReturn'
            Title.Caption = 'Return %'
            Width = 52
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'StdDev3Yr'
            Title.Caption = 'StdDev3-Yr'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'StdDev5Yr'
            Title.Caption = 'StdDev-5-Yr'
            Width = 67
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FutureValue'
            ReadOnly = True
            Width = 77
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GainPercent'
            ReadOnly = True
            Title.Caption = 'Gain %'
            Width = 74
            Visible = True
          end>
      end
      object Panel9: TPanel
        Left = 0
        Top = 345
        Width = 782
        Height = 64
        Align = alTop
        Color = clSilver
        TabOrder = 2
        object Bevel8: TBevel
          Left = 168
          Top = 0
          Width = 9
          Height = 57
          Shape = bsLeftLine
        end
        object Bevel9: TBevel
          Left = 232
          Top = -17
          Width = 9
          Height = 74
          Shape = bsLeftLine
        end
        object Bevel10: TBevel
          Left = 600
          Top = -8
          Width = 9
          Height = 65
          Shape = bsLeftLine
        end
        object Bevel11: TBevel
          Left = 688
          Top = -17
          Width = 9
          Height = 74
          Shape = bsLeftLine
        end
        object Bevel12: TBevel
          Left = 760
          Top = -9
          Width = 9
          Height = 66
          Shape = bsLeftLine
        end
        object Label10: TLabel
          Left = 24
          Top = 8
          Width = 107
          Height = 16
          Caption = 'Portfolio Totals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Bevel13: TBevel
          Left = 345
          Top = -9
          Width = 7
          Height = 66
          Shape = bsLeftLine
        end
        object Bevel7: TBevel
          Left = 472
          Top = -10
          Width = 9
          Height = 67
          Shape = bsLeftLine
        end
        object Label6: TLabel
          Left = 280
          Top = 2
          Width = 26
          Height = 15
          Caption = 'Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label14: TLabel
          Left = 272
          Top = 16
          Width = 46
          Height = 15
          Caption = 'Invested'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label15: TLabel
          Left = 192
          Top = 2
          Width = 27
          Height = 15
          Caption = '% of '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label16: TLabel
          Left = 424
          Top = 2
          Width = 44
          Height = 15
          Caption = 'Average'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label17: TLabel
          Left = 624
          Top = 2
          Width = 26
          Height = 15
          Caption = 'Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label18: TLabel
          Left = 696
          Top = 2
          Width = 26
          Height = 15
          Caption = 'Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label19: TLabel
          Left = 176
          Top = 16
          Width = 50
          Height = 15
          Caption = 'total portf'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label20: TLabel
          Left = 424
          Top = 16
          Width = 32
          Height = 15
          Caption = 'return'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label21: TLabel
          Left = 616
          Top = 16
          Width = 67
          Height = 15
          Caption = 'Future value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label22: TLabel
          Left = 696
          Top = 16
          Width = 40
          Height = 15
          Caption = 'Gain %'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Bevel1: TBevel
          Left = 409
          Top = -2
          Width = 7
          Height = 59
          Shape = bsLeftLine
        end
        object DBEdit4: TDBEdit
          Left = 248
          Top = 32
          Width = 89
          Height = 22
          DataField = 'TotalAmountAllocated'
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object DBEdit6: TDBEdit
          Left = 184
          Top = 32
          Width = 41
          Height = 22
          DataField = 'TotalPercentAllocated'
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
        object DBEdit7: TDBEdit
          Left = 608
          Top = 32
          Width = 73
          Height = 22
          DataField = 'TotalFutureValue'
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
        object DBEdit8: TDBEdit
          Left = 688
          Top = 32
          Width = 57
          Height = 22
          DataField = 'TotalGainPercent'
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
        end
        object DBEdit9: TDBEdit
          Left = 424
          Top = 32
          Width = 41
          Height = 22
          DataField = 'AverageReturn'
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
        end
      end
    end
  end
  object DataSource1: TDataSource
    Left = 160
    Top = 200
  end
  object DataSource2: TDataSource
    Left = 424
    Top = 240
  end
  object DataSource3: TDataSource
    Left = 576
    Top = 280
  end
  object TransactionsSrc: TDataSource
    Left = 420
    Top = 300
  end
end
