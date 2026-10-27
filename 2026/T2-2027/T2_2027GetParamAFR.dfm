object GetParamAFR: TGetParamAFR
  Left = 277
  Top = 178
  BorderIcons = [biSystemMenu]
  ClientHeight = 410
  ClientWidth = 404
  Color = 13353654
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Courier New'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDesigned
  Scaled = False
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object BottomPanel: TPanel
    Left = 0
    Top = 355
    Width = 404
    Height = 55
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      404
      55)
    object OKBtn: TBitBtn
      Left = 70
      Top = 6
      Width = 75
      Height = 43
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkOK
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 255
      Top = 6
      Width = 79
      Height = 43
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
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
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 404
    Height = 40
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 402
      Height = 38
      Align = alClient
      Caption = 
        'Click the box(es) of the delivered tax data elements you want to' +
        ' download.  At least one selection must be made:'
      WordWrap = True
      ExplicitWidth = 399
      ExplicitHeight = 30
    end
  end
  object pnlReturnDataFileAll: TPanel
    Left = 0
    Top = 81
    Width = 404
    Height = 51
    Align = alTop
    TabOrder = 2
    object cbReturnDataFile: TCheckBox
      Left = 1
      Top = 19
      Width = 157
      Height = 17
      Caption = 'T2 Returns data file.'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbDisabledClick
    end
    object pnlReturnDataFile: TPanel
      Left = 165
      Top = 1
      Width = 238
      Height = 49
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 1
      object lblReturnDataFile: TLabel
        Left = 8
        Top = 18
        Width = 91
        Height = 16
        Caption = 'Tax Year End:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cboxReturnDataFile: TComboBox
        Left = 105
        Top = 15
        Width = 123
        Height = 23
        Style = csDropDownList
        TabOrder = 0
      end
    end
  end
  object pnlReturnBalances: TPanel
    Left = 0
    Top = 132
    Width = 404
    Height = 51
    Align = alTop
    TabOrder = 3
    object cbReturnBalances: TCheckBox
      Left = 1
      Top = 1
      Width = 402
      Height = 49
      Align = alClient
      Caption = 
        'T2 Return balances '#8211' All balances will be provided (RDTOH, GRIP,' +
        ' Non-capital Losses, Cap gains/losses, CDA).'
      Checked = True
      State = cbChecked
      TabOrder = 0
      WordWrap = True
      OnClick = cbDisabledClick
    end
  end
  object pnlCorporationBalances: TPanel
    Left = 0
    Top = 183
    Width = 404
    Height = 70
    Align = alTop
    TabOrder = 4
    object cbAccountBalances: TCheckBox
      Left = 1
      Top = 1
      Width = 402
      Height = 68
      Align = alClient
      Caption = 
        'Corporation Account balances '#8211' All balances starting with the cu' +
        'rrent year plus the four prior years including the non-reporting' +
        ' period and total prior year will be transmitted.'
      Checked = True
      State = cbChecked
      TabOrder = 0
      WordWrap = True
      OnClick = cbDisabledClick
    end
  end
  object pnlBNData: TPanel
    Left = 0
    Top = 253
    Width = 404
    Height = 51
    Align = alTop
    TabOrder = 5
    object cbBNData: TCheckBox
      Left = 1
      Top = 1
      Width = 402
      Height = 49
      Align = alClient
      Caption = 
        'Corporation BN data '#8211' All addresses: address/email/RMI (if appli' +
        'cable) available on file will be provided. '
      Checked = True
      State = cbChecked
      TabOrder = 0
      WordWrap = True
      OnClick = cbDisabledClick
    end
  end
  object pnlNOA: TPanel
    Left = 0
    Top = 304
    Width = 404
    Height = 51
    Align = alTop
    TabOrder = 6
    object cbNOA: TCheckBox
      Left = 1
      Top = 19
      Width = 157
      Height = 17
      Caption = 'T2 Available NOA'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbDisabledClick
    end
    object Panel2: TPanel
      Left = 165
      Top = 1
      Width = 238
      Height = 49
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 1
      object lblNOA: TLabel
        Left = 8
        Top = 18
        Width = 91
        Height = 16
        Caption = 'Tax Year End:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cboxNOA: TComboBox
        Left = 105
        Top = 15
        Width = 123
        Height = 23
        Style = csDropDownList
        TabOrder = 0
      end
    end
  end
  object pnlSelect: TPanel
    Left = 0
    Top = 0
    Width = 404
    Height = 41
    Align = alTop
    TabOrder = 7
    object rbAutofill: TRadioButton
      Left = 52
      Top = 12
      Width = 113
      Height = 17
      Caption = 'Autofill only'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbAutofillClick
    end
    object rbNOA: TRadioButton
      Left = 181
      Top = 12
      Width = 80
      Height = 17
      Caption = 'NOA only'
      TabOrder = 1
      OnClick = rbAutofillClick
    end
    object rbBoth: TRadioButton
      Left = 267
      Top = 12
      Width = 51
      Height = 17
      Caption = 'Both'
      TabOrder = 2
      OnClick = rbAutofillClick
    end
  end
end
