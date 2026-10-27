object PickADate: TPickADate
  Left = 317
  Top = 179
  Width = 236
  Height = 220
  Caption = 'PickADate'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MonthCalendar1: TMonthCalendar
    Left = 0
    Top = 0
    Width = 228
    Height = 153
    Align = alTop
    Date = 36710.846799189800000000
    TabOrder = 0
  end
  object OkBtn: TBitBtn
    Left = 32
    Top = 160
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 120
    Top = 160
    Width = 75
    Height = 25
    TabOrder = 2
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
end
