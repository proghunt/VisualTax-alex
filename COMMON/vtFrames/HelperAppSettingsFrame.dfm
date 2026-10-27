object frameHelperAppSettings: TframeHelperAppSettings
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label3: TLabel
      Left = 28
      Top = 5
      Width = 70
      Height = 13
      Caption = 'Application ID:'
    end
    object edtAppID: TEdit
      Left = 186
      Top = 2
      Width = 203
      Height = 21
      Color = clInfoBk
      Ctl3D = True
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object pgcUser: TPageControl
    Left = 0
    Top = 28
    Width = 451
    Height = 276
    Align = alClient
    TabOrder = 1
    ExplicitTop = 33
    ExplicitHeight = 271
  end
end
