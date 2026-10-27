object OptimT1_2026: TOptimT1_2026
  Left = 170
  Top = 101
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Optimization'
  ClientHeight = 428
  ClientWidth = 578
  Color = 15400959
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel4: TPanel
    Left = 0
    Top = 81
    Width = 578
    Height = 347
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    object Label11: TLabel
      Left = 48
      Top = 100
      Width = 57
      Height = 15
      Caption = 'GST credit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 368
      Top = 236
      Width = 68
      Height = 15
      Caption = 'Dependants'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label13: TLabel
      Left = 48
      Top = 124
      Width = 99
      Height = 15
      Caption = 'Medical expenses'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 368
      Top = 220
      Width = 137
      Height = 15
      Caption = 'Property/Sales Tax Credit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object CurRetNoName: TLabel
      Left = 200
      Top = 76
      Width = 81
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Label11'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SpouseRetNoName: TLabel
      Left = 296
      Top = 76
      Width = 97
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Label11'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label17: TLabel
      Left = 48
      Top = 148
      Width = 57
      Height = 15
      Caption = 'Donations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 48
      Top = 172
      Width = 120
      Height = 15
      Caption = 'Political Contributions'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 232
      Top = 52
      Width = 95
      Height = 16
      Caption = 'Claim options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 48
      Top = 92
      Width = 433
      Height = 3
      Style = bsRaised
    end
    object Label2: TLabel
      Left = 80
      Top = 222
      Width = 63
      Height = 15
      Caption = 'Net Income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LblNetInc1: TLabel
      Left = 216
      Top = 222
      Width = 38
      Height = 15
      Caption = 'Label2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LblNetInc2: TLabel
      Left = 304
      Top = 222
      Width = 38
      Height = 15
      Caption = 'Label2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 80
      Top = 238
      Width = 86
      Height = 15
      Caption = 'Taxable Income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LblTxblInc1: TLabel
      Left = 216
      Top = 238
      Width = 38
      Height = 15
      Caption = 'Label2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LblTxblInc2: TLabel
      Left = 304
      Top = 238
      Width = 38
      Height = 15
      Caption = 'Label2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 80
      Top = 254
      Width = 65
      Height = 15
      Caption = 'Tax Payable'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LblPayable1: TLabel
      Left = 216
      Top = 254
      Width = 38
      Height = 15
      Caption = 'Label2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LblPayable2: TLabel
      Left = 304
      Top = 254
      Width = 38
      Height = 15
      Caption = 'Label2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object TLabel
      Left = 80
      Top = 270
      Width = 122
      Height = 15
      Caption = 'Refund (Balance Due)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LblRef1: TLabel
      Left = 216
      Top = 270
      Width = 34
      Height = 15
      Caption = 'lblref1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LblRef2: TLabel
      Left = 304
      Top = 270
      Width = 34
      Height = 15
      Caption = 'lblref2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel3: TBevel
      Left = 48
      Top = 204
      Width = 433
      Height = 3
      Style = bsRaised
    end
    object Label4: TLabel
      Left = 288
      Top = 254
      Width = 7
      Height = 15
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 368
      Top = 254
      Width = 7
      Height = 15
      Caption = '='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object TotPayableLbl: TLabel
      Left = 384
      Top = 254
      Width = 77
      Height = 15
      Caption = 'TotPayableLbl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 13
      Top = 9
      Width = 485
      Height = 15
      Caption = 
        'Before you use this optimization, ensure that ALL Donations and ' +
        'Medical are listed in one'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 13
      Top = 23
      Width = 173
      Height = 15
      Caption = 'of the spouse'#39's return (not split)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Gst0: TCheckBox
      Left = 224
      Top = 100
      Width = 25
      Height = 17
      TabOrder = 0
      OnClick = Gst0Click
    end
    object Gst1: TCheckBox
      Left = 312
      Top = 100
      Width = 25
      Height = 17
      TabOrder = 1
      OnClick = Gst1Click
    end
    object Dependants0: TCheckBox
      Left = 468
      Top = 292
      Width = 25
      Height = 17
      Enabled = False
      TabOrder = 2
      Visible = False
      OnClick = Dependants0Click
    end
    object Dependants1: TCheckBox
      Left = 505
      Top = 292
      Width = 25
      Height = 17
      Enabled = False
      TabOrder = 3
      Visible = False
      OnClick = Dependants1Click
    end
    object Medical0: TCheckBox
      Left = 224
      Top = 124
      Width = 25
      Height = 17
      TabOrder = 4
      OnClick = Medical0Click
    end
    object Medical1: TCheckBox
      Left = 312
      Top = 124
      Width = 25
      Height = 17
      TabOrder = 5
      OnClick = Medical1Click
    end
    object PrvCr0: TCheckBox
      Left = 503
      Top = 311
      Width = 25
      Height = 17
      TabOrder = 6
      Visible = False
      OnClick = PrvCr0Click
    end
    object PrvCr1: TCheckBox
      Left = 463
      Top = 311
      Width = 25
      Height = 17
      TabOrder = 7
      Visible = False
      OnClick = PrvCr1Click
    end
    object Don0: TCheckBox
      Left = 224
      Top = 148
      Width = 25
      Height = 17
      TabOrder = 8
      OnClick = Don0Click
    end
    object Don1: TCheckBox
      Left = 312
      Top = 148
      Width = 25
      Height = 17
      TabOrder = 9
      OnClick = Don1Click
    end
    object Polit0: TCheckBox
      Left = 224
      Top = 172
      Width = 25
      Height = 17
      TabOrder = 10
      OnClick = Polit0Click
    end
    object Polit1: TCheckBox
      Left = 312
      Top = 172
      Width = 25
      Height = 17
      TabOrder = 11
      OnClick = Polit1Click
    end
    object ApplyBtn: TBitBtn
      Left = 368
      Top = 119
      Width = 81
      Height = 28
      Caption = 'Apply '
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A400000000000000000000000000000000000000000000000000000000000000
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
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
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
      ParentFont = False
      TabOrder = 12
      OnClick = ApplyBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 368
      Top = 152
      Width = 81
      Height = 28
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 13
      OnClick = CancelBtnClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 578
    Height = 81
    Align = alTop
    TabOrder = 1
    object Label3: TLabel
      Left = 206
      Top = 8
      Width = 157
      Height = 20
      Caption = 'Family Optimization'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 49
      Top = 32
      Width = 456
      Height = 41
      BorderStyle = bsSingle
      TabOrder = 0
      object Label1: TLabel
        Left = 49
        Top = 7
        Width = 84
        Height = 15
        Caption = 'Current Return:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object CurRetLbl: TLabel
        Left = 148
        Top = 7
        Width = 57
        Height = 13
        Caption = 'CurRetLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Image1: TImage
        Left = 8
        Top = 2
        Width = 33
        Height = 25
        Picture.Data = {
          07544269746D6170F6010000424DF60100000000000076000000280000002000
          0000180000000100040000000000800100000000000000000000100000000000
          0000000000000000800000800000008080008000000080008000808000008080
          8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00888884448444888888888778778888888888844484448888888887787788
          8888888884448444888888888778778888888888844484448888889999999999
          9888888884448444888888999999999998888888844444448888888999999999
          8888888484444444844779999999999998888844844444448447799899999998
          9988884484444444844889988899988899888844844444448448899888BBB888
          99888844847FFF74844889988999998899888844847FFF748448899899999998
          99888844447F4F74444889989999999899888844447F4F744448899999777999
          99888884447F4F74444889997788877999888884488787884488889988787889
          9888888888777778888888888777778888888888877888778888888877888778
          8888888887888887888888887888887888888888877888778888888877888778
          8888888888778778888888888778778888888888887777788888888887777788
          8888888888888888888888888888888888888888888888888888888888888888
          8888}
      end
    end
  end
end
