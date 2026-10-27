object frmT4T5SpecificPrint: TfrmT4T5SpecificPrint
  Left = 0
  Top = 0
  Caption = 'T4T5 Specific Print'
  ClientHeight = 560
  ClientWidth = 786
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 786
    Height = 81
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 19
      Top = 31
      Width = 88
      Height = 19
      Caption = 'Current slip:'
    end
    object lblCurrentSlipName: TLabel
      Left = 113
      Top = 31
      Width = 159
      Height = 19
      Caption = 'lblCurrentSlipName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 17
      Top = 56
      Width = 243
      Height = 19
      Caption = 'Total slips in this Employer/Payer:'
    end
    object lblTotalSlips: TLabel
      Left = 266
      Top = 56
      Width = 101
      Height = 19
      Caption = 'lblTotalSlips'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 19
      Top = 6
      Width = 181
      Height = 19
      Caption = 'Current Employer/Payer: '
    end
    object LblCurrentEmployer: TLabel
      Left = 206
      Top = 6
      Width = 158
      Height = 19
      Caption = 'lblCurrentEmployer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 81
    Width = 786
    Height = 368
    Align = alClient
    TabOrder = 1
    object lblWarning: TLabel
      Left = 1
      Top = 1
      Width = 784
      Height = 19
      Align = alTop
      Color = 12320767
      ParentColor = False
      WordWrap = True
      ExplicitWidth = 5
    end
    object gbPrintType: TGroupBox
      Left = 1
      Top = 20
      Width = 784
      Height = 59
      Align = alTop
      Caption = 'What to Print'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBackground = False
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      object lblCRAForm: TLabel
        Left = 16
        Top = 80
        Width = 79
        Height = 19
        Caption = 'CRA Form:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        Visible = False
      end
      object rbBlankAll: TRadioButton
        Left = 221
        Top = 28
        Width = 172
        Height = 17
        Caption = 'All Company Slips '
        TabOrder = 0
        OnClick = rbBlankCurrClick
      end
      object rbBlankCurr: TRadioButton
        Left = 35
        Top = 29
        Width = 148
        Height = 17
        Caption = 'Current slip only'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = rbBlankCurrClick
      end
      object rbBlankSUM: TRadioButton
        Left = 421
        Top = 28
        Width = 126
        Height = 17
        Caption = 'Summary'
        TabOrder = 2
        OnClick = rbBlankCurrClick
      end
      object rbCRAAll: TRadioButton
        Left = 256
        Top = 103
        Width = 178
        Height = 17
        Caption = 'All slips (CRA Form)'
        TabOrder = 3
        Visible = False
        OnClick = rbBlankCurrClick
      end
      object rbCRACurr: TRadioButton
        Left = 35
        Top = 103
        Width = 206
        Height = 17
        Caption = 'Current slip (CRA Form)'
        TabOrder = 4
        Visible = False
        OnClick = rbBlankCurrClick
      end
      object rbCRASUM: TRadioButton
        Left = 456
        Top = 103
        Width = 185
        Height = 17
        Caption = 'T4 SUM (CRA Form)'
        TabOrder = 5
        Visible = False
        OnClick = rbBlankCurrClick
      end
      object btnSummaryInstructions: TBitBtn
        Left = 565
        Top = 15
        Width = 172
        Height = 38
        Caption = 'Summary Instructions'
        TabOrder = 6
        OnClick = btnSummaryInstructionsClick
      end
    end
    object pnlPrintSettings: TPanel
      Left = 1
      Top = 79
      Width = 767
      Height = 288
      Align = alLeft
      TabOrder = 1
      object gbFilter: TGroupBox
        Left = 330
        Top = 1
        Width = 437
        Height = 286
        Align = alLeft
        Caption = 'Select Employees'
        TabOrder = 0
        DesignSize = (
          437
          286)
        object Label5: TLabel
          Left = 12
          Top = 39
          Width = 209
          Height = 19
          Caption = 'From Last Name starting with'
        end
        object Label6: TLabel
          Left = 6
          Top = 79
          Width = 191
          Height = 19
          Caption = 'To Last Name starting with'
        end
        object Label16: TLabel
          Left = 2
          Top = 221
          Width = 433
          Height = 38
          Align = alBottom
          Alignment = taCenter
          Caption = 'Examples: A to Z,   A to B,   KA to KE'#13#10'(inclusive)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsItalic]
          ParentFont = False
          ExplicitWidth = 268
        end
        object lblT4Total: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 262
          Width = 427
          Height = 19
          Align = alBottom
          Caption = '0 slips'
          Color = clSilver
          ParentColor = False
          ParentShowHint = False
          ShowHint = True
          Transparent = False
          WordWrap = True
          ExplicitWidth = 45
        end
        object edtFrom: TEdit
          Left = 243
          Top = 36
          Width = 169
          Height = 27
          Anchors = [akLeft, akTop, akRight]
          CharCase = ecUpperCase
          TabOrder = 0
          OnChange = edtFromChange
        end
        object edtTo: TEdit
          Left = 243
          Top = 76
          Width = 169
          Height = 27
          Anchors = [akLeft, akTop, akRight]
          CharCase = ecUpperCase
          TabOrder = 1
          OnChange = edtFromChange
        end
      end
      object rgSlipType: TRadioGroup
        Left = 1
        Top = 1
        Width = 329
        Height = 286
        Align = alLeft
        Caption = 'Select Type of slip'
        ItemIndex = 0
        Items.Strings = (
          '1. Government Copy only'
          '2. Employee Copy only'
          '3. Employer/Preparer Copy only'
          '4. All copies')
        TabOrder = 1
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 449
    Width = 786
    Height = 111
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      786
      111)
    object Label4: TLabel
      Left = 49
      Top = 49
      Width = 424
      Height = 19
      Caption = 'If you printed the Final slips/summaries, Close this window,'
    end
    object Label7: TLabel
      Left = 49
      Top = 74
      Width = 594
      Height = 19
      Caption = 
        'then Open the EMPL form and Set the Status of the corresponding ' +
        'slips to PRINTED'
    end
    object BitBtn1: TBitBtn
      Left = 379
      Top = 5
      Width = 172
      Height = 38
      Anchors = [akTop, akRight]
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 0
      OnExit = BitBtn1Exit
    end
    object btnPrint: TBitBtn
      Left = 178
      Top = 5
      Width = 170
      Height = 38
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Print'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        000000000000C69460FDCA9865FFCA9765FFCA9765FFCA9765FFCA9764FFC997
        64FFC99764FFCA9865FFC69360FD0000000000000000000000003B3B3B994D4D
        4DD2585858FFC79561FFF9F7F6FFF9F1ECFFF9F1EBFFF8F0E9FFF7EDE6FFF4EA
        E1FFF2E8DEFFFAF8F6FFC79461FF242424FF1D1D1DD11111117A696969FDA7A7
        A7FFB5B5B5FF818181FFAFACAAFFC5C0BDFFC5C0BDFFC5C0BDFFC5C0BDFFC5C0
        BDFFC5C0BDFFADAAA8FF2C2C2CFFB5B5B5FF9B9B9BFF232323FF707070FFB5B5
        B5FFB5B5B5FF959595FF818181FF818181FF797979FF6E6E6EFF616161FF5252
        52FF434343FF424242FF6E6E6EFFB5B5B5FFB5B5B5FF252525FF757575FFBBBB
        BBFFBBBBBBFF8D8D8DFFD4D4D4FFB9B9B9FFB9B9B9FFB9B9B9FFB9B9B9FFB9B9
        B9FFB9B9B9FFD3D3D3FF838383FFBBBBBBFFBBBBBBFF2A2A2AFF7A7A7AFFD7D7
        D7FFD7D7D7FF979797FFD8D8D8FFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBF
        BFFFBFBFBFFFD7D7D7FF8E8E8EFFD7D7D7FFD7D7D7FF3F3F3FFF7E7E7EFFF9F9
        F9FFF9F9F9FFABABABFFDFDFDFFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCB
        CBFFCBCBCBFFDFDFDFFFA3A3A3FFF9F9F9FFF9F9F9FF616161FF7E7E7EF9FCFC
        FCFFFCFCFCFFCBCBCBFFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFC6C6C6FFFCFCFCFFFCFCFCFF707070FE6A6A6AD2D2D2
        D2FFE8E8E8FF7D7D7DFF7D7D7DFF7D7D7DFF7D7D7DFF7D7D7DFF7D7D7DFF7D7D
        7DFF7D7D7DFF7D7D7DFF7D7D7DFFE8E8E8FFC4C4C4FF4A4A4ADC232323459A9A
        9AFFCCCCCCFFC78B4EFFF9F4EDFF0207DBFF2893F9FF25AB3DFFBA8763FFFAE0
        C7FFF9DDC3FFFAF4EDFFC7854AFFC3C3C3FF747474FF13131345000000003232
        32637B7B7BF3C5894CFFF9F4EFFF3B39DAFF3796F9FF56CFCEFFB2A078FFC290
        6AFFF6DABDFFFAF4EFFFC48348FF555555F32020206300000000000000000000
        000005050509C08649F9F9F4F0FFFCE6D3FF6072EBFF41A6F9FF52CBC0FF50AB
        50FF80A75BFFF8F4F0FFBE7F44F9030303090000000000000000000000000000
        000000000000C08549F7F9F5F1FFFCE3CFFFF4DDD0FF5160E8FF3A8DF7FFF4E9
        DFFFF7F2ECFFF5EFE9FFBF7C44FB000000000000000000000000000000000000
        000000000000BF8449F6F9F5F1FFFCE3CDFFFBE3CDFFF9E0C8FFE3C9C4FFFDFB
        F8FFFCE6CDFFE2B684FF7C4F2BA6000000000000000000000000000000000000
        000000000000C08348FAF7F2ECFFF8F4EEFFF8F3EDFFF8F3EDFFF8F2ECFFF2E6
        D7FFE2B27DFFD28C60F605030207000000000000000000000000000000000000
        000000000000492F1A60936638BBC78B4FFEC88C4FFFC2894DF7C3884DF7C488
        4CFE724422940000000000000000000000000000000000000000}
      TabOrder = 1
      OnClick = btnPrintClick
    end
  end
  object PrintDialogItem: TPrintDialog
    Left = 227
    Top = 347
  end
end
