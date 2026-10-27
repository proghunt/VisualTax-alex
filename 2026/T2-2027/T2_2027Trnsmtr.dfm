object TransmitterT2_2027: TTransmitterT2_2027
  Left = 177
  Top = 105
  Caption = 'TransmitterT2_2027'
  ClientHeight = 396
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 27
    Top = 64
    Width = 118
    Height = 17
    Caption = 'Transmitter Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 46
    Top = 247
    Width = 57
    Height = 17
    Caption = 'Province'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 27
    Top = 91
    Width = 131
    Height = 17
    Caption = 'Transmitter Number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 46
    Top = 192
    Width = 39
    Height = 17
    Caption = 'Street'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 46
    Top = 219
    Width = 25
    Height = 17
    Caption = 'City'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 37
    Top = 165
    Width = 72
    Height = 18
    Caption = 'ADDRESS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 110
    Top = 18
    Width = 341
    Height = 18
    Caption = 'Ontario (CT23) TRANSMITTER IDENTIFICATION'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 46
    Top = 329
    Width = 68
    Height = 17
    Caption = 'Telephone'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 46
    Top = 274
    Width = 80
    Height = 17
    Caption = 'Postal Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 46
    Top = 357
    Width = 24
    Height = 17
    Caption = 'Fax'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 27
    Top = 128
    Width = 94
    Height = 17
    Caption = 'Contact Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label12: TLabel
    Left = 46
    Top = 302
    Width = 51
    Height = 17
    Caption = 'Country'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 201
    Top = 311
    Width = 104
    Height = 16
    Caption = '(CA for Canada)'
  end
  object Label14: TLabel
    Left = 210
    Top = 247
    Width = 110
    Height = 16
    Caption = '(ON, AB, BC, etc)'
  end
  object Label17: TLabel
    Left = 366
    Top = 347
    Width = 140
    Height = 17
    Caption = 'Format 999 999-9999'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label15: TLabel
    Left = 448
    Top = 91
    Width = 173
    Height = 17
    Caption = '(Supplied by the Ont MOF)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label16: TLabel
    Left = 347
    Top = 338
    Width = 8
    Height = 28
    Caption = '}'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -25
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Name: TEdit
    Left = 165
    Top = 64
    Width = 266
    Height = 24
    CharCase = ecUpperCase
    MaxLength = 35
    TabOrder = 0
  end
  object EFileNo: TEdit
    Left = 165
    Top = 91
    Width = 266
    Height = 24
    MaxLength = 17
    TabOrder = 1
  end
  object Street: TEdit
    Left = 165
    Top = 192
    Width = 266
    Height = 24
    MaxLength = 35
    TabOrder = 3
  end
  object City: TEdit
    Left = 165
    Top = 219
    Width = 266
    Height = 24
    MaxLength = 19
    TabOrder = 4
  end
  object Province: TEdit
    Left = 165
    Top = 247
    Width = 28
    Height = 24
    CharCase = ecUpperCase
    MaxLength = 2
    TabOrder = 5
  end
  object Postal: TEdit
    Left = 165
    Top = 274
    Width = 65
    Height = 24
    CharCase = ecUpperCase
    MaxLength = 9
    TabOrder = 6
  end
  object Phone: TEdit
    Left = 165
    Top = 329
    Width = 165
    Height = 24
    MaxLength = 12
    TabOrder = 7
  end
  object Fax: TEdit
    Left = 165
    Top = 357
    Width = 165
    Height = 24
    MaxLength = 12
    TabOrder = 8
  end
  object OKBtn: TBitBtn
    Left = 448
    Top = 174
    Width = 102
    Height = 37
    Caption = 'OK'
    Default = True
    Glyph.Data = {
      BE060000424DBE06000000000000360400002800000024000000120000000100
      0800000000008802000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C00070609F00B7AF
      CF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCD8E700A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
      0303030303030303030303030303030303030303030303030303030303030303
      03030303030303030303030303030303030303030303FF030303030303030303
      03030303030303040403030303030303030303030303030303F8F8FF03030303
      03030303030303030303040202040303030303030303030303030303F80303F8
      FF030303030303030303030303040202020204030303030303030303030303F8
      03030303F8FF0303030303030303030304020202020202040303030303030303
      0303F8030303030303F8FF030303030303030304020202FA0202020204030303
      0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
      040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
      03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
      FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
      0303030303030303030303FA0202020403030303030303030303030303F8FF03
      03F8FF03030303030303030303030303FA020202040303030303030303030303
      0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
      03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
      030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
      0202040303030303030303030303030303F8FF03F8FF03030303030303030303
      03030303FA0202030303030303030303030303030303F8FFF803030303030303
      030303030303030303FA0303030303030303030303030303030303F803030303
      0303030303030303030303030303030303030303030303030303030303030303
      0303}
    NumGlyphs = 2
    TabOrder = 9
    OnClick = OKBtnClick
  end
  object BitBtn2: TBitBtn
    Left = 448
    Top = 219
    Width = 102
    Height = 38
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 10
    OnClick = BitBtn2Click
  end
  object MailToName: TEdit
    Left = 165
    Top = 128
    Width = 266
    Height = 24
    MaxLength = 35
    TabOrder = 2
  end
  object Country: TEdit
    Left = 165
    Top = 302
    Width = 28
    Height = 24
    CharCase = ecUpperCase
    MaxLength = 2
    TabOrder = 11
  end
end
