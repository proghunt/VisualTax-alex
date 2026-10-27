object Liabilities: TLiabilities
  Left = 144
  Top = 97
  VertScrollBar.Position = 28
  Caption = 'Liabilities'
  ClientHeight = 0
  ClientWidth = 124
  Color = 10724259
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object LiabilityTypeLbl: TLabel
    Left = 0
    Top = 109
    Width = 124
    Height = 19
    Align = alTop
    Alignment = taCenter
    Caption = 'LiabilityTypeLbl'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ExplicitWidth = 120
  end
  object CancelBtn: TBitBtn
    Left = 576
    Top = 460
    Width = 113
    Height = 33
    Caption = 'Save and E&xit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
  end
  object DBNavigator1: TDBNavigator
    Left = 184
    Top = 460
    Width = 216
    Height = 33
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 3
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 128
    Width = 124
    Height = 325
    Align = alTop
    Color = clWhite
    DataSource = DataSource1
    FixedColor = 10930928
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Delete: TBitBtn
    Left = 96
    Top = 460
    Width = 75
    Height = 33
    Caption = '&Delete...'
    TabOrder = 2
  end
  object LiabilityTypeBox: TRadioGroup
    Left = 0
    Top = -28
    Width = 124
    Height = 97
    Align = alTop
    Caption = 'Liability Type'
    Color = clSilver
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 4
    ExplicitWidth = 775
  end
  object PrintBtn: TBitBtn
    Left = 464
    Top = 460
    Width = 75
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
    TabOrder = 5
  end
  object CalculatorPanel: TPanel
    Left = 0
    Top = 69
    Width = 124
    Height = 40
    Align = alTop
    Color = 14680063
    TabOrder = 6
    ExplicitWidth = 775
    object Label3: TLabel
      Left = 216
      Top = 21
      Width = 255
      Height = 13
      Caption = 'All dates must be in the format YYYY-MM-DD'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 0
      Top = 5
      Width = 766
      Height = 13
      Caption = 
        'Car Loans, Mortgages and other Long Term liabilities:To recalcul' +
        'ate the monthly payment automatically, zero out the monthly  pay' +
        'ment '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object AutoMonthlyBtn: TBitBtn
      Left = 560
      Top = 13
      Width = 121
      Height = 25
      Caption = 'Calc Monthly payment'
      TabOrder = 0
      Visible = False
    end
  end
  object DataSource1: TDataSource
    Left = 248
    Top = 112
  end
  object DataSource2: TDataSource
    Left = 544
    Top = 176
  end
end
