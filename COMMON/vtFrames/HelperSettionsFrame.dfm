object frameHelperSettings: TframeHelperSettings
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  AutoScroll = True
  TabOrder = 0
  OnResize = FrameResize
  object pgcApp: TPageControl
    Left = 0
    Top = 116
    Width = 451
    Height = 188
    Align = alClient
    TabOrder = 0
    ExplicitTop = 132
    ExplicitHeight = 172
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 116
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 1
    object pnl1: TPanel
      Left = 0
      Top = 0
      Width = 451
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 13
        Top = 6
        Width = 64
        Height = 13
        Caption = 'Helper name:'
      end
      object edtHelperName: TEdit
        Left = 142
        Top = 3
        Width = 203
        Height = 21
        Color = clSilver
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 0
      end
    end
    object pnlAdvanced: TPanel
      Left = 0
      Top = 26
      Width = 451
      Height = 90
      Align = alTop
      TabOrder = 1
      Visible = False
      ExplicitTop = 31
      object lblClientIDHelp: TLabel
        Left = 1
        Top = 29
        Width = 449
        Height = 60
        Align = alTop
        AutoSize = False
        Caption = 
          '  If you have your own application on the cloud storage (eg Drop' +
          'Box), then you can use it to work.'#13#10'  To learn the "Client ID" f' +
          'or your application please go to https://www.dropbox.com/develop' +
          'ers, then go to "My apps", select your application. The data wil' +
          'l be recorded in "App key" field.'#13#10'  Also you can use to work Ap' +
          'plication provided by Microsophic Inc., To do this, set the flag' +
          ' as in the field "Use VisualTax Client ID"'
        Color = clInfoBk
        ParentColor = False
        Transparent = False
        WordWrap = True
        ExplicitTop = -11
        ExplicitHeight = 52
      end
      object pnlClientId: TPanel
        Left = 1
        Top = 1
        Width = 449
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitTop = 0
        object lblClientId: TLabel
          Left = 12
          Top = 6
          Width = 45
          Height = 13
          Caption = 'Client ID:'
        end
        object chbUseDefaultClientID: TCheckBox
          Left = 374
          Top = 5
          Width = 345
          Height = 17
          Caption = 'Use VisualTax Client ID'
          TabOrder = 0
          OnClick = chbUseDefaultClientIDClick
        end
        object edtClientID: TEdit
          Left = 142
          Top = 3
          Width = 203
          Height = 21
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
          OnChange = edtClientIDChange
        end
      end
    end
  end
end
