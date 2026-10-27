object MonitorFrameT2_2027: TMonitorFrameT2_2027
  Left = 0
  Top = 0
  Width = 753
  Height = 27
  Hint = 'Click Recalc to refresh calculations'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentColor = False
  ParentFont = False
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object NetIncPanel: TPanel
    Left = 5
    Top = 3
    Width = 134
    Height = 16
    Alignment = taRightJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object NetIncLabel: TLabel
      Left = 4
      Top = 1
      Width = 53
      Height = 14
      Caption = 'Net Income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object TxblIncPanel: TPanel
    Left = 145
    Top = 3
    Width = 150
    Height = 16
    Alignment = taRightJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    object TxblIncPanelLbl: TLabel
      Left = 4
      Top = 1
      Width = 74
      Height = 14
      Caption = 'Taxable Income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object AlbPay: TPanel
    Left = 444
    Top = 3
    Width = 138
    Height = 16
    Alignment = taRightJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    object AlbPaylbl: TLabel
      Left = 0
      Top = 1
      Width = 55
      Height = 14
      Caption = 'Alberta Tax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object FedPay: TPanel
    Left = 588
    Top = 3
    Width = 133
    Height = 16
    Alignment = taRightJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 3
    object FedPaylbl: TLabel
      Left = 0
      Top = 1
      Width = 56
      Height = 14
      Caption = 'Federal Tax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object TotalTaxPanel: TPanel
    Left = 311
    Top = 3
    Width = 127
    Height = 16
    Alignment = taRightJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    object Totaltaxlbl: TLabel
      Left = 6
      Top = 0
      Width = 42
      Height = 14
      Caption = 'Total Tax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
end
