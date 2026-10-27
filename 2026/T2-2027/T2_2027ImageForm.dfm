object ImageFormT2_2027: TImageFormT2_2027
  Left = 4
  Top = 81
  Width = 800
  Height = 534
  Caption = 'Print Preview'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ImageBox1: TImage
    Left = 0
    Top = 41
    Width = 790
    Height = 441
    Align = alTop
  end
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 790
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'RSI Print Preview'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object CancelBtn: TBitBtn
      Left = 576
      Top = 8
      Width = 49
      Height = 25
      Caption = 'Next'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = CancelBtnClick
    end
  end
end
