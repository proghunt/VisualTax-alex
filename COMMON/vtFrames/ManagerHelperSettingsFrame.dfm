object frameManagerHelperSettings: TframeManagerHelperSettings
  Left = 0
  Top = 0
  Width = 791
  Height = 304
  Align = alClient
  TabOrder = 0
  ExplicitWidth = 451
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 791
    Height = 17
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = 'Cloud helpers settings'
    TabOrder = 0
    ExplicitTop = -6
    ExplicitWidth = 451
    object chkShowAdvanced: TCheckBox
      Left = 272
      Top = 0
      Width = 519
      Height = 17
      Align = alRight
      Caption = 'Show advanced settings (for system administrators)'
      TabOrder = 0
      OnClick = chkShowAdvancedClick
    end
  end
  object pgcHelper: TPageControl
    Left = 0
    Top = 17
    Width = 791
    Height = 287
    Align = alClient
    TabOrder = 1
    ExplicitTop = 41
    ExplicitWidth = 451
    ExplicitHeight = 263
  end
end
