object YTDCashFrmT1_2026: TYTDCashFrmT1_2026
  Left = 92
  Top = 55
  Width = 576
  Height = 398
  Caption = 'YTD Cash Consolidation'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 328
    Top = 8
    Width = 115
    Height = 16
    Caption = 'YTD Cash Directory'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 187
    Height = 16
    Caption = 'Un-processed daily cash reports'
  end
  object Label3: TLabel
    Left = 448
    Top = 216
    Width = 84
    Height = 16
    Caption = 'YYYY-MM-DD'
  end
  object Label4: TLabel
    Left = 296
    Top = 216
    Width = 69
    Height = 16
    Caption = 'Print Option'
  end
  object YtdDirBox: TEdit
    Left = 256
    Top = 32
    Width = 265
    Height = 24
    Enabled = False
    TabOrder = 5
  end
  object DayDirBox: TEdit
    Left = 8
    Top = 32
    Width = 201
    Height = 24
    Enabled = False
    TabOrder = 4
  end
  object ConsolidateBtn: TBitBtn
    Left = 264
    Top = 152
    Width = 257
    Height = 33
    Hint = 'Consilidate all outstanding cash reports '
    Caption = 'Consolidate all un-processed reports'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = ConsolidateBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 360
    Top = 328
    Width = 89
    Height = 33
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object FileListBox1: TFileListBox
    Left = 8
    Top = 64
    Width = 197
    Height = 305
    ItemHeight = 16
    TabOrder = 3
  end
  object ListfileBtn: TBitBtn
    Left = 264
    Top = 104
    Width = 257
    Height = 33
    Caption = 'List un-processed daily cash reports'
    TabOrder = 0
    OnClick = ListfileBtnClick
  end
  object PrintBtn: TBitBtn
    Left = 264
    Top = 280
    Width = 265
    Height = 33
    Caption = 'Print'
    TabOrder = 6
    OnClick = PrintBtnClick
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
  end
  object OptionGroup: TRadioGroup
    Left = 264
    Top = 232
    Width = 169
    Height = 41
    Columns = 2
    Items.Strings = (
      'YTD'
      'Single day')
    TabOrder = 7
  end
  object DateBox: TEdit
    Left = 448
    Top = 248
    Width = 81
    Height = 24
    TabOrder = 8
    Text = 'DateBox'
  end
  object PrintDialog1: TPrintDialog
    Left = 230
    Top = 75
  end
end
