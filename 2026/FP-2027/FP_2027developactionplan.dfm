object DevelopActionPlan: TDevelopActionPlan
  Left = 9
  Top = 53
  Caption = 'DevelopActionPlan'
  ClientHeight = 520
  ClientWidth = 765
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 216
    Top = 216
    Width = 51
    Height = 13
    Caption = 'Tax refund'
  end
  object PageControl1: TPageControl
    Left = -8
    Top = 32
    Width = 769
    Height = 441
    ActivePage = ReviewSheet
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object BuySellSheet: TTabSheet
      Caption = 'Develop Action Plan'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 344
        Top = 16
        Width = 473
        Height = 401
        Caption = 'Action Plan'
        Color = 14933196
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        object DBGrid1: TDBGrid
          Left = 9
          Top = 72
          Width = 411
          Height = 313
          DataSource = DataSource2
          FixedColor = 10930928
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
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
              FieldName = 'Action'
              PickList.Strings = (
                'BUY'
                'SELL')
              Width = 53
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AssetType'
              Width = 49
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Amount'
              Width = 59
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Description'
              Width = 85
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Status'
              PickList.Strings = (
                'InPlan')
              Width = 47
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SwitchTo'
              Visible = True
            end>
        end
        object EnterDirectlyBtn: TBitBtn
          Left = 24
          Top = 40
          Width = 169
          Height = 25
          Caption = 'Enter action manually'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object RemoveBtn: TBitBtn
          Left = 208
          Top = 40
          Width = 177
          Height = 25
          Hint = 'Remove the current security from the portfolio'
          Caption = 'Remove action...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object AddMFSheltBtn: TBitBtn
          Left = 24
          Top = 16
          Width = 169
          Height = 25
          Caption = 'Buy a Mutual Fund  - RRSP'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object BuyMFNonShBtn: TBitBtn
          Left = 208
          Top = 16
          Width = 177
          Height = 25
          Caption = 'Buy a Mutual Fund - NonRRSP'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
      end
      object GroupBox6: TGroupBox
        Left = 16
        Top = 16
        Width = 321
        Height = 401
        Caption = 'Investments and Personal assets'
        Color = 14933196
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        object Label1: TLabel
          Left = 24
          Top = 16
          Width = 101
          Height = 16
          Caption = 'Filter Asset Type:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object AssetsGrid: TDBGrid
          Left = 8
          Top = 72
          Width = 305
          Height = 313
          DataSource = DataSource1
          FixedColor = 10930928
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          Columns = <
            item
              Expanded = False
              FieldName = 'AssetType'
              Visible = True
            end
            item
              ButtonStyle = cbsEllipsis
              Expanded = False
              FieldName = 'Description'
              Width = 96
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CurrentValue'
              Width = 82
              Visible = True
            end>
        end
        object SellBtn: TBitBtn
          Left = 128
          Top = 40
          Width = 129
          Height = 25
          Caption = 'Sell selected asset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object SwitchFundBtn: TBitBtn
          Left = 264
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Switch Mutual Fund'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Visible = False
        end
        object AssetTypeBox: TComboBox
          Left = 144
          Top = 16
          Width = 97
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Sorted = True
          TabOrder = 3
        end
      end
    end
    object ReviewSheet: TTabSheet
      Caption = 'Assign responsibility for action'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 737
        Height = 337
        Caption = 'Action plan'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object DBGrid2: TDBGrid
          Left = 8
          Top = 16
          Width = 721
          Height = 305
          DataSource = DataSource3
          FixedColor = 10930928
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
          TitleFont.Color = clBlack
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          Columns = <
            item
              Expanded = False
              FieldName = 'Who'
              PickList.Strings = (
                'Agent'
                'Client')
              Width = 79
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Action'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'When'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AssetType'
              Width = 48
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Description'
              Width = 116
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Amount'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Supplier'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Product'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SwitchTo'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Status'
              Visible = True
            end>
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 765
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Specific Action Plan'
    Color = 11301888
    Font.Charset = ANSI_CHARSET
    Font.Color = 10930928
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 773
  end
  object CloseBtn: TBitBtn
    Left = 432
    Top = 480
    Width = 145
    Height = 33
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 2
  end
  object PrintBtn: TBitBtn
    Left = 304
    Top = 480
    Width = 97
    Height = 33
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
    TabOrder = 3
  end
  object DataSource1: TDataSource
    Left = 72
    Top = 176
  end
  object DataSource2: TDataSource
    Left = 84
    Top = 217
  end
  object PrintDialog1: TPrintDialog
    Left = 211
    Top = 198
  end
  object DataSource3: TDataSource
    Left = 80
    Top = 256
  end
end
