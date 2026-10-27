object LifeInsur: TLifeInsur
  Left = 129
  Top = 128
  Caption = 'Life Insurance'
  ClientHeight = 379
  ClientWidth = 760
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
  object DBGrid1: TDBGrid
    Left = 0
    Top = 25
    Width = 760
    Height = 313
    Align = alTop
    DataSource = DataSource1
    FixedColor = 10930928
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'PolicyNo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Type'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'InsuranceCompany'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CashSurrenderValue'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AnnualPremium'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SelfCoverage'
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SpouseCoverage'
        Width = 83
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Notes'
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'InsuranceAgent'
        Visible = True
      end>
  end
  object DeleteBtn: TBitBtn
    Left = 312
    Top = 352
    Width = 75
    Height = 33
    Caption = 'Delete...'
    TabOrder = 1
  end
  object CancelBtn: TBitBtn
    Left = 512
    Top = 352
    Width = 121
    Height = 33
    Caption = 'Save and Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
  object PrintBtn: TBitBtn
    Left = 416
    Top = 352
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
    TabOrder = 3
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 760
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Life Insurance'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    ExplicitWidth = 768
  end
  object DataSource1: TDataSource
    Left = 152
    Top = 96
  end
end
