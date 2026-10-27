inherited vtnosplash: Tvtnosplash
  Left = 245
  Top = 189
  Caption = 'Visual Tax 2015'
  ClientHeight = 741
  ClientWidth = 1272
  Color = clWhite
  OnMouseWheel = FormMouseWheel
  ExplicitWidth = 1288
  ExplicitHeight = 780
  PixelsPerInch = 96
  TextHeight = 17
  inherited AuditPanelSplitter: TSplitter
    Left = 368
    Top = 67
    Height = 648
    OnCanResize = AuditPanelSplitterCanResize
    ExplicitLeft = 342
    ExplicitTop = 67
    ExplicitHeight = 612
  end
  inherited MonitorReturnDataSplitter: TSplitter
    Left = 1168
    Top = 67
    Height = 648
    ExplicitLeft = 932
    ExplicitTop = 67
    ExplicitHeight = 612
  end
  inherited ReviewPanelSplitter: TSplitter
    Left = 1168
    Top = 67
    Height = 648
    AutoSnap = False
    MinSize = 1
    OnCanResize = ReviewPanelSplitterCanResize
    OnMoved = ReviewPanelSplitterMoved
    ExplicitLeft = 875
    ExplicitTop = 65
    ExplicitHeight = 649
  end
  object ToolBoxSplitter: TSplitter [3]
    Left = 0
    Top = 65
    Width = 1272
    Height = 2
    Cursor = crVSplit
    Align = alTop
    Color = clRed
    ParentColor = False
    Visible = False
    ExplicitWidth = 1210
  end
  object LeftPanel: TPanel [4]
    Left = 57
    Top = 67
    Width = 311
    Height = 648
    Align = alLeft
    ParentBackground = False
    TabOrder = 2
    object WizardPanelSplitter: TSplitter
      Left = 1
      Top = 77
      Width = 309
      Height = 2
      Cursor = crVSplit
      Align = alTop
      Color = clRed
      ParentColor = False
    end
    object FormsPanelSplitter: TSplitter
      Left = 1
      Top = 473
      Width = 309
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Color = clRed
      ParentColor = False
      ExplicitTop = 437
    end
    object FormsPanel: TPanel
      Left = 1
      Top = 476
      Width = 309
      Height = 171
      Align = alBottom
      Color = clTeal
      TabOrder = 0
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 307
        Height = 23
        Hint = 'You can drag the red splitter to change the room for forms'
        Align = alTop
        Caption = 'Forms'
        Color = 11301888
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10930928
        Font.Height = -17
        Font.Name = 'Arial Black'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object SpeedButton2: TSpeedButton
          Left = 284
          Top = 5
          Width = 18
          Height = 15
          Action = actHideForms
          Flat = True
          Margin = 0
          Spacing = 1
        end
      end
      object ExpandPanel: TPanel
        Left = 1
        Top = 24
        Width = 307
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        Color = 13353654
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 14546429
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
        object SpeedButton1: TSpeedButton
          Left = 136
          Top = 0
          Width = 38
          Height = 18
          Hint = 'Close Audit'
          Caption = 'Close'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
        end
        object ExpandBtn: TBitBtn
          Left = 3
          Top = 0
          Width = 52
          Height = 18
          Hint = 'Expand the Forms tree'
          Caption = 'Expand'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = ExpandBtnClick
        end
        object Collapse: TBitBtn
          Left = 71
          Top = 0
          Width = 52
          Height = 18
          Hint = 'Collapse the Forms tree'
          Caption = 'Collapse'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = CollapseClick
        end
        object UsedFormsBox: TCheckBox
          Left = 179
          Top = 0
          Width = 98
          Height = 18
          Caption = 'Used Forms'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = UsedFormsBoxClick
        end
      end
      object FormsTreeView1: TTreeView
        Left = 1
        Top = 49
        Width = 307
        Height = 121
        Align = alClient
        BorderStyle = bsNone
        Color = 15794175
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        HotTrack = True
        Images = ilTreeView
        Indent = 19
        ParentFont = False
        ReadOnly = True
        ShowRoot = False
        TabOrder = 2
        OnClick = FormsTreeView1Click
        OnGetImageIndex = TreeViewGetImageIndex
        OnGetSelectedIndex = TreeViewGetImageIndex
        OnKeyPress = FormsTreeView1KeyPress
      end
    end
    object ReturnsPanel: TPanel
      Left = 1
      Top = 1
      Width = 309
      Height = 76
      Align = alTop
      Color = clYellow
      TabOrder = 1
      object ReturnsHeaderPanel: TPanel
        Left = 1
        Top = 1
        Width = 307
        Height = 23
        Hint = 
          'Click on a listed return to activate it. Click on the header to ' +
          'change rates'
        Align = alTop
        Caption = 'Returns'
        Color = 11301888
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10930928
        Font.Height = -17
        Font.Name = 'Arial Black'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object SpeedButton3: TSpeedButton
          Left = 284
          Top = 5
          Width = 18
          Height = 15
          Action = actHideReturnsList
          Flat = True
          Margin = 0
          Spacing = 1
        end
      end
      object ReturnsListBox: TListBox
        Left = 1
        Top = 24
        Width = 307
        Height = 51
        Hint = 'Click to go to this return'
        Style = lbOwnerDrawFixed
        Align = alClient
        Color = 15794175
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = ReturnsListBoxClick
        OnDrawItem = ReturnsListBoxDrawItem
      end
    end
    object WizardPanel: TPanel
      Left = 1
      Top = 79
      Width = 309
      Height = 394
      Align = alClient
      Color = clGreen
      TabOrder = 2
      object WizardHeaderPanel: TPanel
        Left = 1
        Top = 1
        Width = 307
        Height = 67
        Hint = 
          'Click on the errors to get to the form. Press F5 to close or re-' +
          'open the Wizard Panel'
        Align = alTop
        Color = 11301888
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10930928
        Font.Height = -17
        Font.Name = 'Arial Black'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object Label9: TLabel
          Left = 129
          Top = 45
          Width = 81
          Height = 16
          Caption = 'Or Right Click'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton4: TSpeedButton
          Left = 284
          Top = 5
          Width = 18
          Height = 15
          Action = actHideAudit
          Flat = True
          Margin = 0
          Spacing = 1
        end
        object SuperAuditBox: TCheckBox
          Left = 7
          Top = 22
          Width = 106
          Height = 18
          Hint = 'Find ommissions from last year'
          Alignment = taLeftJustify
          Caption = 'Super Audit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = SuperAuditBoxClick
        end
        object buSignOffWarnings: TBitBtn
          Left = 7
          Top = 45
          Width = 117
          Height = 19
          Caption = 'Sign Off Warnings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = buSignOffWarningsClick
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 68
        Width = 307
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        Color = 13353654
        TabOrder = 1
        Visible = False
        object SuperFeaturesLbl: TLabel
          Left = 315
          Top = 1
          Width = 103
          Height = 15
          AutoSize = False
          Caption = 'lbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object PrintAuditBtn: TSpeedButton
          Left = 278
          Top = 0
          Width = 18
          Height = 18
          Hint = 'Print Audit List'
          Caption = 'PR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = PrintAuditBtnClick
        end
        object SuperVerificationBtn: TPanel
          Left = 10
          Top = 0
          Width = 111
          Height = 18
          Hint = 'Compare data of this form with last year'#39's'
          BorderStyle = bsSingle
          Caption = 'Super Verification'
          Color = 15663103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object AuditPanel: TScrollBox
        Left = 1
        Top = 94
        Width = 307
        Height = 299
        Align = alClient
        BorderStyle = bsNone
        Color = 16053492
        ParentColor = False
        TabOrder = 2
        object ErrorView: TTreeView
          Left = 0
          Top = 0
          Width = 307
          Height = 299
          Align = alClient
          BorderStyle = bsNone
          Color = clOlive
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Images = ilTreeView
          Indent = 19
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          ShowRoot = False
          TabOrder = 0
          ToolTips = False
          OnClick = ErrorViewClick
          OnDblClick = AuditListDblClick
          OnGetImageIndex = TreeViewGetImageIndex
          OnGetSelectedIndex = TreeViewGetImageIndex
          OnMouseDown = ErrorViewMouseDown
          OnMouseMove = ErrorViewMouseMove
        end
      end
    end
  end
  object TutorialsPanel: TPanel [5]
    Left = 0
    Top = 0
    Width = 1272
    Height = 65
    Align = alTop
    TabOrder = 1
    Visible = False
    OnResize = TutorialsPanelResize
    object Splitter1: TSplitter
      Left = 180
      Top = 1
      Width = 2
      Height = 63
      Color = clRed
      ParentColor = False
    end
    object TutLeftPanel: TPanel
      Left = 1
      Top = 1
      Width = 179
      Height = 63
      Align = alLeft
      TabOrder = 0
      object Panel6: TPanel
        Left = 1
        Top = 1
        Width = 177
        Height = 37
        Align = alTop
        Caption = 'Tutorials'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object TutorialListBox: TListBox
        Left = 1
        Top = 38
        Width = 177
        Height = 24
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = TutorialListBoxClick
      end
    end
    object Panel4: TPanel
      Left = 182
      Top = 1
      Width = 1089
      Height = 63
      Align = alClient
      Caption = 'Panel4'
      TabOrder = 1
      object WebBrowser1: TWebBrowser
        Left = 1
        Top = 38
        Width = 1087
        Height = 24
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 965
        ExplicitHeight = 22
        ControlData = {
          4C000000587000007B0200000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object Panel5: TPanel
        Left = 1
        Top = 1
        Width = 1087
        Height = 37
        Align = alTop
        TabOrder = 1
        object TutorialZoomInBtn: TSpeedButton
          Left = 283
          Top = 5
          Width = 22
          Height = 26
          Hint = 'Enlarge tutorial '
          Glyph.Data = {
            F6000000424DF60000000000000076000000280000000F000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3330333333333333333033333333333333303333370007333330333307777703
            333033307F8F8F7033303377F8F9F8F7733033078F898F8703303307F99999F7
            033033078F898F8703303377F8F9F8F7733033307F8F8F703330333307777703
            3330333337000733333033333333333333303333333333333330}
          ParentShowHint = False
          ShowHint = True
          OnClick = TutorialZoomInBtnClick
        end
        object TutorialZoomOutBtn: TSpeedButton
          Left = 311
          Top = 5
          Width = 24
          Height = 26
          Hint = 'Reduce tutorial'
          Glyph.Data = {
            F6000000424DF60000000000000076000000280000000F000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3330333333333333333033333333333333303333370007333330333307777703
            3330333078F8F870333033778F8F8F8773303307F8F8F8F70330330789999987
            03303307F8F8F8F7033033778F8F8F877330333078F8F8703330333307777703
            3330333337000733333033333333333333303333333333333330}
          ParentShowHint = False
          ShowHint = True
          OnClick = TutorialZoomOutBtnClick
        end
        object CloseTutorialBtn: TBitBtn
          Left = 342
          Top = 7
          Width = 90
          Height = 24
          Hint = 'Close the Tutorials'
          Caption = '&Close Tutorial'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          NumGlyphs = 2
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = CloseTutorialBtnClick
        end
        object NextTutorialBtn: TBitBtn
          Left = 596
          Top = 7
          Width = 23
          Height = 24
          Hint = 'Open the Next tutorial'
          Caption = 'Next'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Visible = False
          OnClick = NextTutorialBtnClick
        end
        object PrevTutorialBtn: TBitBtn
          Left = 629
          Top = 7
          Width = 23
          Height = 24
          Hint = 'Open the previous tutorial'
          Caption = 'Previous'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Visible = False
          OnClick = PrevTutorialBtnClick
        end
        object DemonstrateTutorialBtn: TBitBtn
          Left = 573
          Top = 7
          Width = 16
          Height = 24
          Hint = 'Open the Next tutorial'
          Caption = 'Demonstrate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Visible = False
          OnClick = DemonstrateTutorialBtnClick
        end
        object URLs: TComboBox
          Left = 662
          Top = 10
          Width = 90
          Height = 24
          Hint = 'URL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Visible = False
        end
        object HelpIndexBtn: TBitBtn
          Left = 439
          Top = 6
          Width = 68
          Height = 24
          Hint = 'Open the Next tutorial'
          Caption = 'Help Index'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object TrBtn: TBitBtn
          Left = 513
          Top = 6
          Width = 31
          Height = 24
          Hint = 'Open the Next tutorial'
          Caption = 'TR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
        end
      end
    end
  end
  object StatusBar1: TStatusBar [6]
    Left = 0
    Top = 715
    Width = 1272
    Height = 26
    Panels = <
      item
        Width = 100
      end>
    object PanelZoom: TPanel
      Left = 640
      Top = 3
      Width = 613
      Height = 23
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object lblZoom: TLabel
        Left = 540
        Top = 0
        Width = 50
        Height = 23
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Caption = '100%'
        Layout = tlCenter
        ExplicitLeft = 400
        ExplicitTop = 1
        ExplicitHeight = 20
      end
      object buttonAvailableWidth: TSpeedButton
        Left = 590
        Top = 0
        Width = 23
        Height = 23
        Hint = 'Zoom to available width'
        Align = alRight
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFB1B1B1A2A2A2A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5
          A5A5A5A5A5A5A5A5BCBCBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9A9A9AFAFAFA
          F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F4F4F4FAFAFAA8A8A8FFFFFFFFFF
          FFFFFFFF6790AA9BB5C79B9B9BF9F9F9F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
          F3F3F4F4F4F9F9F9A9A9A9FFFFFFFFFFFF477999668CA36F8C9F9C9C9CFCFCFC
          F6F6F6F6F6F6F7F7F7F7F7F7F7F7F7F7F7F7F9F9F9FCFCFCAAA9A8FFFFFF4679
          993F6F8F72A5D06181969D9D9DFFFFFFFAFAFAFAFAFAFFFFFFDFDFDFDFDFDFDF
          DFDFDFDFDFE3E3E3AFAEAC5985A040759675A6D05D8098DADBDC9C9C9CFFFFFF
          FEFEFEFFFFFFCFCFD08C8C8C8C8C8C8B8B8B8C8C8C9D9D9D7D94A3BDCAD376AA
          D45E8099D6D6D6FFFFFF9C9C9CFFFFFFFFFFFFD0D0D09F9F9FD6D6D6EFEFEFEF
          EFEFD7D7D7999999979797C5CFD7607F95D5D5D6FFFFFFFFFFFF9C9C9CFFFFFF
          CFCFCF9D9D9DDCDDDEE6E7E7EEEEEEF1F1F0F0F0F1E0E1E19797978B8B8BF9F9
          F9FFFFFFFFFFFFFFFFFF9C9C9CFFFFFFA9A9A9DADDDEEAE6E4E49B5FF9FBFDFA
          FCFEE49B5FF3EFEDDFE0E29D9D9DFFFFFFFFFFFFFFFFFFFFFFFF9C9C9CFFFFFF
          A3A3A4ECECEDE09155E2A16DF1F1F1F1F1F0E3A573DE8E52F0EFEF989999FFFF
          FFFFFFFFFFFFFFFFFFFF9C9C9CFFFFFFA3A5A6D38E57DF7E2FDE8137DE833BDE
          833BDE8138DC7A2ED68C52969799FFFFFFFFFFFFFFFFFFFFFFFF9C9C9CFFFFFF
          A2A2A3EDEDEEE79957E6A770ECEAE8E6E4E3E1A471E3934FEEEDEC979898FFFF
          FFFFFFFFFFFFFFFFFFFF9E9E9EFFFFFFB4B5B58B8C8DF7F6F4E38F49FFFFFFF3
          F4F4E28D48F1F0EF909192B8B9B9FFFFFFFFFFFFFFFFFFFFFFFFBABABAA1A1A1
          A0A0A0929292878889E0E2E3E3E3E3E5E5E6DDDFE08A8B8CA9A9AAFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFE9E9E9DFDFDFDFDFDFE8E8E8B6B7B79B9C9C95959594
          9494999999ADADAEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = buttonAvailableWidthClick
        ExplicitLeft = 518
        ExplicitTop = -1
      end
      object ButtonZoomPlus: TSpeedButton
        Tag = 1
        Left = 517
        Top = 0
        Width = 23
        Height = 23
        Hint = 'Zoom in'
        Align = alRight
        Flat = True
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000830B0000830B00000001000000010000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
          6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          09090909E8E8E8E8E8E8E8E8E8E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8E8
          09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
          09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
          09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E809090909
          0910100909090909E8E8E8E88181818181ACAC8181818181E8E8E8E809101010
          1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809101010
          1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809090909
          0910100909090909E8E8E8E88181818181ACAC8181818181E8E8E8E8E8E8E8E8
          09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
          09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
          09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
          09090909E8E8E8E8E8E8E8E8E8E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonZoomPlusClick
        ExplicitLeft = 446
      end
      object ButtonZoomMinus: TSpeedButton
        Tag = -1
        Left = 305
        Top = 0
        Width = 23
        Height = 23
        Hint = 'Zoom out'
        Align = alRight
        Flat = True
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000830B0000830B00000001000000010000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
          6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E809090909
          0909090909090909E8E8E8E8818181818181818181818181E8E8E8E809101010
          1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809101010
          1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809090909
          0909090909090909E8E8E8E8818181818181818181818181E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonZoomPlusClick
        ExplicitLeft = 232
      end
      object rbZoomAll: TRadioButton
        Left = 160
        Top = 0
        Width = 35
        Height = 23
        Align = alRight
        Caption = 'All'
        Checked = True
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = rbZoomAllClick
      end
      object rbZoomCenter: TRadioButton
        Left = 195
        Top = 0
        Width = 59
        Height = 23
        Align = alRight
        Caption = 'Center'
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        OnClick = rbZoomAllClick
      end
      object rbZoomRight: TRadioButton
        Left = 254
        Top = 0
        Width = 51
        Height = 23
        Align = alRight
        Caption = 'Right'
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        OnClick = rbZoomAllClick
      end
      object tbZoom: TTrackBar
        Left = 328
        Top = 0
        Width = 189
        Height = 23
        Hint = 'Zoom in/out form'
        Align = alRight
        Max = 40
        Min = 10
        Position = 20
        TabOrder = 3
        ThumbLength = 18
        TickStyle = tsNone
        OnChange = tbZoomChange
      end
      object btnSendGlobalMessage: TButton
        Left = 6
        Top = 1
        Width = 123
        Height = 21
        Caption = 'Send Global Message'
        TabOrder = 4
        Visible = False
        OnClick = btnSendGlobalMessageClick
      end
    end
  end
  object ReviewPanel: TPageControl [7]
    Left = 1172
    Top = 67
    Width = 100
    Height = 648
    ActivePage = tabReview
    Align = alRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Default'
    Font.Style = [fsBold]
    MultiLine = True
    ParentFont = False
    ScrollOpposite = True
    TabOrder = 3
    TabPosition = tpRight
    OnChange = ReviewPanelChange
    object tabHide: TTabSheet
      Caption = 'Hide'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tabReview: TTabSheet
      Caption = 'Review'
      ImageIndex = 1
      OnDragDrop = PageControlDragDrop
      OnDragOver = PageControlDragOver
      object ReviewForms: TTabControl
        Left = 0
        Top = 21
        Width = 66
        Height = 25
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Default'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = ReviewFormsChange
      end
      object ReviewHeaderPanel: TPanel
        Left = 0
        Top = 0
        Width = 66
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        Color = 11301888
        Ctl3D = False
        ParentBackground = False
        ParentCtl3D = False
        TabOrder = 1
      end
      object ReviewBottomPanel: TPanel
        Left = 0
        Top = 620
        Width = 66
        Height = 20
        Align = alBottom
        BevelOuter = bvNone
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
      end
    end
    object tabLastyear: TTabSheet
      Caption = 'Last year'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblLinkLastYearReturn: TLabel
        Left = -80
        Top = 46
        Width = 146
        Height = 14
        Cursor = crHandPoint
        Align = alTop
        Alignment = taRightJustify
        Caption = 'Select the file manually...  '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Default'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
        Visible = False
        OnClick = lblLinkLastYearReturnClick
        OnMouseEnter = lblLinkLastYearReturnMouseEnter
        OnMouseLeave = lblLinkLastYearReturnMouseLeave
      end
      object LastYearHeaderPanel: TPanel
        Left = 0
        Top = 0
        Width = 66
        Height = 46
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = 11301888
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10930928
        Font.Height = -16
        Font.Name = 'Default'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        object LastYearHeaderError: TLabel
          Left = 0
          Top = 32
          Width = 4
          Height = 14
          Align = alTop
          Alignment = taCenter
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -12
          Font.Name = 'Default'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object LastYearHeaderCaption: TPanel
          Left = 0
          Top = 0
          Width = 66
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Last Year'
          Color = 11301888
          ParentBackground = False
          TabOrder = 0
          object buttonSynchronousDisplay: TSpeedButton
            Left = 29
            Top = 0
            Width = 37
            Height = 32
            Hint = 'Synchronous display: ON'
            Align = alRight
            AllowAllUp = True
            GroupIndex = 1
            Down = True
            Glyph.Data = {
              36100000424D3610000000000000360000002800000020000000200000000100
              20000000000000100000C30E0000C30E00000000000000000000FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00858A88BF858A
              88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A
              88FF858A88FF858A88FF999E9CFFFFFFFF00B100161CB10016AAB10016AAB100
              161CFFFFFF00858A88BF858A88FF858A88FF858A88FF858A88FF858A88FF858A
              88FF858A88FF858A88FF858A88FF858A88FF858A88FF999E9CFF858A88FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF858A88FFB100161CB10016C6B10016CCB10016CCB100
              16C6B100161C858A88FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF858A88FF858A88FFFFFF
              FFFFDADEDEFFD8DCDBFFD7DADAFFD5D9D8FFD5D9D8FFD4D8D7FFD3D7D5FFD1D6
              D4FFD0D5D3FFFFFFFFFF858A88FFB10016ECB10016FFB10016FFB10016FFB100
              16FFB10016EC858A88FFFFFFFFFFDADEDEFFD8DCDBFFD7DADAFFD5D9D8FFD5D9
              D8FFD4D8D7FFD3D7D5FFD1D6D4FFD0D5D3FFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE0E4E3FF000000FF313232FFDBDFDEFFDBDFDEFF313131FF313131FFD7DB
              DAFFD5DAD9FFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016FFB10016FFFFFF
              FF00FFFFFF00858A88FFFFFFFFFFE0E4E3FF000000FF313232FFDBDFDEFFDBDF
              DEFF313131FF313131FFD7DBDAFFD5DAD9FFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE0E4E3FFDEE1E0FFDCE0DFFFDBDFDEFFDBDFDEFFD9DDDDFFD9DCDCFFD7DB
              DAFFD5DAD9FFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016FFB10016FFFFFF
              FF00FFFFFF00858A88FFFFFFFFFFE0E4E3FFDEE1E0FFDCE0DFFFDBDFDEFFDBDF
              DEFFD9DDDDFFD9DCDCFFD7DBDAFFD5DAD9FFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE3E5E5FF323333FF000000FF323332FFDFE2E1FF313232FF313231FFD9DD
              DCFFD8DCDBFFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016FFB10016FFFFFF
              FF00FFFFFF00858A88FFFFFFFFFFE3E5E5FF323333FF000000FF323332FFDFE2
              E1FF313232FF313231FFD9DDDCFFD8DCDBFFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE3E5E5FFE0E3E2FFDEE2E1FFDFE2E1FFDFE2E1FFDCDFDEFFDADEDDFFD9DD
              DCFFD8DCDBFFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016C6B10016FFFFFF
              FF00FFFFFF00858A88FFFFFFFFFFE3E5E5FFE0E3E2FFDEE2E1FFDFE2E1FFDFE2
              E1FFDCDFDEFFDADEDDFFD9DDDCFFD8DCDBFFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE0E4E3FF000000FF313232FFDBDFDEFFDBDFDEFF313131FF313131FFD7DB
              DAFFD5DAD9FFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016C6B10016F2FFFF
              FF00FFFFFF00858A88FFFFFFFFFFE0E4E3FF000000FF313232FFDBDFDEFFDBDF
              DEFF313131FF313131FFD7DBDAFFD5DAD9FFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE0E4E3FFDEE1E0FFDCE0DFFFDBDFDEFFDBDFDEFFD9DDDDFFD9DCDCFFD7DB
              DAFFD5DAD9FFFFFFFFFF858A88FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00858A88FFFFFFFFFFE0E4E3FFDEE1E0FFDCE0DFFFDBDFDEFFDBDF
              DEFFD9DDDDFFD9DCDCFFD7DBDAFFD5DAD9FFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE3E5E5FF323333FF000000FF323332FFDFE2E1FF313232FF313231FFD9DD
              DCFFD8DCDBFFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016C6B10016C6FFFF
              FF00FFFFFF00858A88FFFFFFFFFFE3E5E5FF323333FF000000FF323332FFDFE2
              E1FF313232FF313231FFD9DDDCFFD8DCDBFFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE3E5E5FFE0E3E2FFDEE2E1FFDFE2E1FFDFE2E1FFDCDFDEFFDADEDDFFD9DD
              DCFFD8DCDBFFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016C6B10016C6FFFF
              FF00FFFFFF00858A88FFFFFFFFFFE3E5E5FFE0E3E2FFDEE2E1FFDFE2E1FFDFE2
              E1FFDCDFDEFFDADEDDFFD9DDDCFFD8DCDBFFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE0E4E3FF000000FF313232FFDBDFDEFFDBDFDEFF313131FF313131FFD7DB
              DAFFD5DAD9FFFFFFFFFF858A88FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00858A88FFFFFFFFFFE0E4E3FF000000FF313232FFDBDFDEFFDBDF
              DEFF313131FF313131FFD7DBDAFFD5DAD9FFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE0E4E3FFDEE1E0FFDCE0DFFFDBDFDEFFDBDFDEFFD9DDDDFFD9DCDCFFD7DB
              DAFFD5DAD9FFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016C6B10016C6FFFF
              FF00FFFFFF00858A88FFFFFFFFFFE0E4E3FFDEE1E0FFDCE0DFFFDBDFDEFFDBDF
              DEFFD9DDDDFFD9DCDCFFD7DBDAFFD5DAD9FFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE3E5E5FF323333FF000000FF323332FFDFE2E1FF313232FF313231FFD9DD
              DCFFD8DCDBFFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016FFB10016FFFFFF
              FF00FFFFFF00858A88FFFFFFFFFFE3E5E5FF323333FF000000FF323332FFDFE2
              E1FF313232FF313231FFD9DDDCFFD8DCDBFFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE3E5E5FFE0E3E2FFDEE2E1FFDFE2E1FFDFE2E1FFDCDFDEFFDADEDDFFD9DD
              DCFFD8DCDBFFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016FFB10016FFFFFF
              FF00FFFFFF00858A88FFFFFFFFFFE3E5E5FFE0E3E2FFDEE2E1FFDFE2E1FFDFE2
              E1FFDCDFDEFFDADEDDFFD9DDDCFFD8DCDBFFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE4E6E6FF000000FF000000FF323332FFDFE2E1FF323232FF313232FFDBDE
              DEFFD9DEDCFFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016FFB10016FFFFFF
              FF00FFFFFF00858A88FFFFFFFFFFE4E6E6FF000000FF000000FF323332FFDFE2
              E1FF323232FF313232FFDBDEDEFFD9DEDCFFFFFFFFFF858A88FF858A88FFFFFF
              FFFFE6E8E9FFE3E6E5FFE2E5E5FFE1E4E3FFE1E4E3FFE0E3E2FFDFE2E0FFDDE0
              DFFFDBDFDFFFFFFFFFFF858A88FFFFFFFF00FFFFFF00B10016FFB10016FFFFFF
              FF00FFFFFF00858A88FFFFFFFFFFE6E8E9FFE3E6E5FFE2E5E5FFE1E4E3FFE1E4
              E3FFE0E3E2FFDFE2E0FFDDE0DFFFDBDFDFFFFFFFFFFF858A88FF874A20FFCF9F
              72FFA46534FFA46534FFA46534FFA46534FFA46534FFA46534FFA46534FFA465
              34FFA46534FFCF9F72FF874A20FFB10016AAB10016F8B10016FFB10016FFB100
              16EEB10016AA874A20FFCF9F72FFA46534FFA46534FFA46534FFA46534FFA465
              34FFA46534FFA46534FFA46534FFA46534FFCF9F72FF874A20FF874A20FFCF9F
              72FFCF9F72FFCF9F72FFCF9F72FFCF9F72FFCF9F72FFCF9F72FFCF9F72FFCF9F
              72FFCF9F72FFCF9F72FF874A20FFB100161CB10016CCB10016D2B10016D2B100
              16CCB100161C874A20FFCF9F72FFCF9F72FFCF9F72FFCF9F72FFCF9F72FFCF9F
              72FFCF9F72FFCF9F72FFCF9F72FFCF9F72FFCF9F72FF874A20FF874A207F874A
              20FF874A20FF874A20FF874A20FF874A20FF874A20FF874A20FF874A20FF874A
              20FF874A20FF874A20FF874A207FFFFFFF00B100161CB10016E6B10016E6B100
              161CFFFFFF00874A207F874A20FF874A20FF874A20FF874A20FF874A20FF874A
              20FF874A20FF874A20FF874A20FF874A20FF874A20FF874A207FFFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
              000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
            ParentShowHint = False
            ShowHint = True
            OnClick = buttonSynchronousDisplayClick
            ExplicitLeft = 328
            ExplicitTop = 6
            ExplicitHeight = 13
          end
          object buttonZoom50_50: TSpeedButton
            Left = -3
            Top = 0
            Width = 32
            Height = 32
            Hint = 'Zoom 50 / 50: ON'
            Align = alRight
            AllowAllUp = True
            GroupIndex = 2
            Down = True
            Glyph.Data = {
              36100000424D3610000000000000360000002800000020000000200000000100
              20000000000000100000C30E0000C30E00000000000000000000FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000060000
              001100000016000000160000001100000006FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000060000001C0000
              00370000004300000043000000370000001C00000006FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000060000001C0000003D4C80
              A9FF4D81A8FF4C81A9FF4B81ABFF0000003700000011FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00000000060000001C0000003D4E82AAFF2B91
              D6FF26A2FBFF2CADFFFF36B8FFFF4992C5FF00000016FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00000000060000001C0000003D4F82A9FF1F92E1FF27A0
              F7FF2CAAFFFF33B1FFFF3DBDFFFF4791C4FF00000016FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00000000060000001C0000003D4F82A9FF1F92E1FF28A0F6FF2BA9
              FFFF2CADFFFFD3EFFFFF42C3FFFF4691C6FF00000012FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00000000060000001C0000003D4D82AAFF1F92E1FF28A0F6FF2BA9FFFF2BAD
              FFFFCDECFFFFD4F4FFFF49CEFFFF4594C9FF00000008FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              00060000001C0000003D4482B1FF2990D8FF27A0F7FF2BA9FFFF2BADFFFFCCEC
              FFFFD1F2FFFF44CBFFFF428EC3FF3F86B63900000001FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000040000000C0000
              001200000016000000160000001600000016000000120000000B000000080000
              001B0000003C807874FF6D96B0FF1DA0FEFF28A9FFFF2AADFFFFCCECFFFFD1F2
              FFFF43CBFFFF418EC3FF00000006FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00000000030000000D0000001C0000002E0000
              003C000000420000004300000043000000420000003B0000002D000000260000
              003A7B7776FF9B9895FFA9A099FF7DA7C6FF21ADFFFFCAECFFFFD1F2FFFF43CB
              FFFF418EC3FF00000006FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF0000000005000000160000002E1212114A625F5EB66F6C
              6BEB73706FFF726F6EFF726F6EFF73706FFF6F6C6BEB605E5DB40000004B8C8A
              88E9999896FFA2A09EFFABA8A4FFB6ADA7FFE5ECEFFFC9F2FFFF41CBFFFF418E
              C3FF00000008FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00000000050000001900000038636060B57B7877FFA3A3A1FFCECE
              CDFFE4E4E3FFE3E3E2FFE3E3E2FFE4E4E3FFCECECDFFA3A3A1FF7A7676FF8480
              80FFA3A2A0FFABAAA8FFB1B0ADFFEEEDEBFFFAF3EFFF9ECEE0FF3A8DC5FF3D85
              B63800000001FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF0000000003000000160000003873706FED979595FFE0E0DFFFE2E3E4FFDEE1
              E3FFDCDFE4FFDBDFE4FFDBDFE4FFDBDFE4FFDEE0E3FFE2E3E4FFDFDFDEFF9593
              92FF7B7977FFB2B0AEFFBCBAB7FFF6F5F4FFD2CDCAFF9D9189FF00000006FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF000000000D0000002E747270ECA09E9CFFE7E8E8FFE0E3E6FFE5D9CAFFF4CB
              97FFFFC375FFFFC375FFFFC275FFFFC273FFF3CA95FFE4D8C9FFE0E3E6FFE6E7
              E7FF9D9B99FF7E7B7AFFCAC8C6FFD1CFCDFF918D8AFF00000006FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              00040000001B686663B09A9898FFE9EAEBFFE2E5EBFFEDCDA4FFF6BD72FFEEC1
              7AFFECC884FFEECF8AFFF1D690FFF4D891FFF6D189FFF7BF73FFECCBA3FFE2E5
              EAFFE9E9EAFF959393FF9E9B9AFFDADAD7E300000008FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              000C191919377F7C7AFFE6E6E7FFE5E8ECFFEBC799FFEFB76EFFE8BD79FFECC7
              83FFEFD08CFFF4D692FFF6DE98FFF9E39DFFFAE69FFFF9E29BFFF1BD73FFE8C9
              A2FFE5E7EBFFE5E5E5FF7A7775FF0000002D0000000BFFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              00126C6868AEACABAAFFEBEDEEFFE6DBCBFFEAB56EFFEDC893FFF2CE91FFF5D3
              8EFFFBDB95FFFEE59DFFFFEEA5FFFFF4ACFFFFF9B1FFFFF4ABFFFAE49CFFEAB4
              69FFE6DBCCFFEBEDEEFFABAAA8FF686665AC00000012FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              0016787574E9DCDBDBFFEBEEF1FFE2BC8AFFEDCA9AFFF3D5A7FF795324FF7F59
              2AFF80592BFF7F582BFF7F582AFF7F5729FF7E5528FF774E23FFFFEEA5FFEECB
              85FFE2BC8BFFEBEEF2FFDCDBDBFF777473E900000016FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              00167B7977FFF5F5F5FFECF0F4FFD8A055FFF1D9B7FFF5DAB2FF795120FF7F57
              28FF7F5829FF7F5829FF7F582AFF7F572AFF7E5629FF774F23FFFFEBA3FFF5DA
              93FFD7A058FFECF0F5FFF5F5F5FF7B7977FF00000016FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              00167B7977FFF6F6F6FFEEF2F7FFD09850FFF4DFC3FFF4DBB8FFF9DFB6FFFDE4
              B4FFFFE6AFFFFFE8AAFFFFEAA4FFFFEEA6FFFFF0A9FFFFECA4FFF8E09BFFF5D9
              92FFD09855FFEEF2F8FFF6F6F6FF7B7977FF00000016FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              00167C7A78FFF8FAFAFFF1F6FAFFC7914AFFF7E5D0FFF6E1C3FFFAE4C1FFFDE7
              BEFFFFE6B7FFFEE7B1FFFFE8ABFFFFE6A2FFFFE69EFFFCE29BFFF6D994FFF2D3
              8DFFC79350FFF2F6FCFFF8FAFAFF7C7A78FF00000016FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              00127F7C79FFFCFDFCFFF4F8FCFFBF8A43FFFBEEE0FFFDEBD5FF784F1BFF7F56
              25FF7F5828FF7F5828FF7F5829FF7F582AFF7E5729FF795125FFF6D791FFEEC9
              85FFC08C4AFFF5F9FEFFFCFDFCFF7F7C79FF00000012FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              000C7F7B79E6E6E6E6FFF8FBFEFFCAA879FFE8D1B5FFFFF3E2FF784E1AFF7E56
              23FF7F5826FF805827FF805828FF805929FF7F5829FF7A5326FFF4CF89FFDAB0
              6CFFCBAA7FFFF8FBFFFFE6E6E6FF7F7B79E60000000CFFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
              00047C7977A0B8B6B6FFFDFEFFFFE8DED0FFC19963FFFFF7EDFFFFF2E1FFFFEF
              D7FFFDEBCDFFFCE6C3FFFBE2B9FFFADFAEFFF8D9A4FFF4CF91FFEBC07AFFB788
              47FFE9E0D4FFFEFEFFFFB8B6B6FF7C7977A000000004FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF0042413F178A8785FFFBFCFCFFFEFFFFFFCCB28CFFC5A376FFFFF6EBFFFAEC
              DBFFF7E5CDFFF5DFC1FFF3DAB6FFF1D5ADFFF0D2A3FFEBC790FFB48545FFCDB5
              93FFFEFFFFFFFBFCFCFF8A8785FF42413F17FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00000000037F7D7A9DAAA9A7FFFFFFFFFFFFFFFFFFC3A67EFFB6905CFFE0CB
              AFFFFAEEDEFFF9E7D1FFF7E1C4FFF2D8B7FFDCBB8FFFAD8246FFCBB292FFFFFF
              FFFFFFFFFFFFAAA9A7FF7F7D7A9D00000003FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF000000000584827FE7B4B2B2FFFFFFFFFFFFFFFFFFEAE0D3FFBF9E
              72FFA0702EFFA17130FFA17231FFA17131FFBFA075FFEBE1D6FFFFFFFFFFFFFF
              FFFFB5B2B2FF84827FE700000005FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF0000000005868481E6ADACAAFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFADAC
              AAFF868481E700000005FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF0000000003868482998E8B89FFBFBEBEFFF2F3
              F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F3F3FFBFBEBEFF8E8C89FF8684
              829A00000003FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006867640F8886839A8886
              83E3878582FF878581FF878581FF878582FF888683E38886839A6867640FFFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
            ParentShowHint = False
            ShowHint = True
            OnClick = buttonZoom50_50Click
            ExplicitLeft = 296
          end
        end
      end
      object LastYearBottomPanel: TPanel
        Left = 0
        Top = 620
        Width = 66
        Height = 20
        Align = alBottom
        BevelOuter = bvNone
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
      end
    end
    object tabAssist: TTabSheet
      Caption = 'Assist'
      ImageIndex = 2
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object AssistBrowser: TWebBrowser
        Left = 0
        Top = 27
        Width = 66
        Height = 613
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 230
        ExplicitHeight = 541
        ControlData = {
          4C000000D20600005B3F00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 66
        Height = 27
        Align = alTop
        TabOrder = 1
        object swFullHelp: TCheckBox
          Left = 4
          Top = 4
          Width = 78
          Height = 18
          Caption = 'Full Help'
          TabOrder = 0
        end
      end
    end
    object tsClientDocuments: TTabSheet
      Caption = 'Client Documents'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tsViewSideBySide: TTabSheet
      Caption = 'View Side by side'
      ImageIndex = 5
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlViewSideBySide: TPanel
        Left = 0
        Top = 0
        Width = 66
        Height = 640
        Align = alClient
        TabOrder = 0
      end
    end
    object tsAutofill: TTabSheet
      Caption = 'Autofill Slips'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Default'
      Font.Style = []
      ImageIndex = 6
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object TabControl1: TTabControl [8]
    Left = 0
    Top = 67
    Width = 31
    Height = 648
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -15
    Font.Name = 'Default'
    Font.Style = [fsBold]
    Images = AppImages
    MultiLine = True
    ParentFont = False
    TabOrder = 4
    TabPosition = tpLeft
    Tabs.Strings = (
      '')
    TabIndex = 0
    OnChange = TabControl1Change
    OnChanging = TabControl1Changing
    OnGetImageIndex = TabControl1GetImageIndex
    OnMouseUp = TabControl1MouseUp
  end
  object pgc: TPageControl [9]
    Left = 31
    Top = 67
    Width = 26
    Height = 648
    ActivePage = tsForms
    Align = alLeft
    MultiLine = True
    TabOrder = 5
    TabPosition = tpLeft
    OnChange = pgcChange
    object tabRightPanelHide: TTabSheet
      Caption = 'Hide'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tsDiagnostics: TTabSheet
      Caption = 'Audit'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tsForms: TTabSheet
      Caption = 'Forms'
      ImageIndex = 1
    end
    object tsBoth: TTabSheet
      Caption = 'Audit/Forms'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object pnlToolBarParent: TPanel [10]
    Left = 0
    Top = 67
    Width = 1272
    Height = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
  end
  inherited OpenDialog1: TOpenDialog
    Left = 436
    Top = 595
  end
  inherited ActionList1: TActionList
    Left = 619
    Top = 598
    object actViewReturnsList: TAction [2]
      Category = 'LeftPanelSetting'
      Caption = 'Returns'
      Checked = True
      ImageIndex = 18
      OnExecute = ActLeftPanelSettingExecute
    end
    object actHideReturnsList: TAction [3]
      Category = 'LeftPanelSetting'
      ImageIndex = 21
      Visible = False
      OnExecute = actHideReturnsListExecute
    end
    object actViewAudit: TAction
      Category = 'LeftPanelSetting'
      Caption = 'Audit'
      Checked = True
      ImageIndex = 19
      OnExecute = ActLeftPanelSettingExecute
    end
    object actHideAudit: TAction
      Category = 'LeftPanelSetting'
      ImageIndex = 21
      Visible = False
      OnExecute = actHideAuditExecute
    end
    object actViewForms: TAction
      Category = 'LeftPanelSetting'
      Caption = 'Forms'
      Checked = True
      ImageIndex = 20
      OnExecute = ActLeftPanelSettingExecute
    end
    object actHideForms: TAction
      Category = 'LeftPanelSetting'
      ImageIndex = 21
      Visible = False
      OnExecute = actHideFormsExecute
    end
  end
  inherited ImageList1: TImageList
    Left = 748
    Top = 602
    Bitmap = {
      494C010116005002280310001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000006000000001002000000000000060
      000000000000000000000000000000000000DCDCDC23CCCCCC33CCCCCC33CCCC
      CC33CCCCCC33CCCCCC33CCCCCC33CCCCCC33CCCCCC33CCCCCC33CCCCCC33CCCC
      CC33CCCCCC33CCCCCC33CCCCCC33DCDCDC230000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A3A3A3C08D8D8DFF8A8A8AFF8A8A
      8AFF8A8A8BFF8B8B8CFF8B8C8DFF8B8C8DFF8B8B8CFF8A8A8BFF8A8A8AFF8A8A
      8AFF8A8A8AFF8A8A8AFF8D8D8DFFA3A3A3C0E6E6E45CC2C2BED8A8A8A2F9A2A2
      9BFAA2A29BFAA2A29BFAA2A29BFAA2A29BFAA2A29BFAA2A29CFAA2A29CFAA3A3
      9CFAA3A39CFAA9A9A3F9C4C4C0D9E6E6E55D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008D8D8DFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF8D8D8DFF9B9B95D694948AFF95958BFF9595
      8BFF95958BFF95958BFF95958BFF95958BFF95958BFF95958BFF95958BFF9595
      8BFF95958BFF95958BFF95958BFF9D9D97D60000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8B8BFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFC6A584FF9E6932FF9E6932FFC4A482FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF8B8B8BFF69695FFFB0B0A6FFBABAB0FFBCBC
      B2FFBCBCB2FFC4C4BBFFC2C2B9FFBCBCB2FFBCBCB2FFC2C2B9FFC4C4BBFFBCBC
      B2FFBCBCB2FFBABAB0FFB0B0A6FF6D6D63FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8B8BFFFFFFFFFFFFFFFFFF8081
      82FF83878AFFA16A32FFF0D9BBFFE0BC8FFF9D672FFFFFFFFFFF5C5D5DFF9E9E
      9EFF9C9C9CFF9A9A9AFFFFFFFFFF8B8B8BFF64645AFFBFBFB5FFC0C0B6FFC0C0
      B6FFC7C7BFFF8D8D86FF969690FFC5C5BCFFC5C5BCFF969690FF8D8D86FFC7C7
      BFFFC0C0B6FFC0C0B6FFBFBFB5FF67675DFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8B8BFFFFFFFFFFFEFEFEFF8383
      84FFFFFFFFFFCFB08CFFAD7941FFAD7941FFCCAD8AFFFBFEFFFFFBFCFCFFFBFB
      FBFFFAFAFAFFFAFAFAFFFFFFFFFF8B8B8BFF636359FFC3C3B9FFC3C3B9FFC7C7
      BEFF83837DFF323228FF323228FF8D8D86FF8D8D86FF323228FF323228FF8383
      7DFFC7C7BEFFC3C3B9FFC3C3B9FF67675DFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8B8BFFFFFFFFFFFAFAFAFF8383
      83FFFDFFFFFFFAFFFFFFFCFFFFFFFCFFFFFFF9FEFFFFF4F7F9FFF4F4F4FFF3F4
      F4FFF3F3F3FFF4F4F4FFFFFEFEFF8B8B8BFF64645AFFC7C7BDFFC7C7BDFFC4C4
      BCFF73736BFF38382EFF38382EFF38382EFF38382EFF38382EFF38382EFF7373
      6BFFC4C4BCFFC7C7BDFFC7C7BDFF67675DFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8B8BFFFFFEFEFFF8F7F6FF8585
      85FFFFFFFFFFC2A280FF9F6A34FF9F6A34FFC0A07EFFF5F7F9FFF6F5F4FFF5F4
      F3FFF5F4F2FFF4F3F2FFFFFEFEFF8C8C8CFF64645AFFCBCBC1FFCBCBC1FFCBCB
      C1FFC9C9BFFF77776FFF3D3D33FF3D3D33FF3D3D33FF3D3D33FF77776FFFC9C9
      BFFFCBCBC1FFCBCBC1FFCBCBC1FF68685EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8C8CFFFEFDFDFFF5F4F3FF8787
      88FF878B8FFFA26C34FFF0DABCFFE1BD90FF9E6931FFF5F8FBFF5F6061FFA0A0
      A0FF9E9F9FFF9C9D9DFFFFFEFEFF8C8C8CFF64645AFFCECEC4FFCECEC4FFCECE
      C4FFCECEC6FF7A7A73FF424238FF424238FF424238FF424238FF7A7A73FFCECE
      C6FFCECEC4FFCECEC4FFCECEC4FF68685EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8C8CFFFDFCFCFFF1F1F0FF8687
      88FFF7FAFCFFCBAB89FFAE7A40FFAD7A40FFC8A885FFEFF1F2FFEFEFEEFFEFEE
      EDFFEFEEECFFEEEDECFFFDFCFCFF8C8C8CFF65655BFFD2D2C8FFD2D2C8FFCECE
      C6FF76766EFF48483EFF48483EFF48483EFF48483EFF48483EFF48483EFF7676
      6EFFCECEC6FFD2D2C8FFD2D2C8FF69695FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8C8CFFFEFEFFFFEFEFF2FF858A
      8EFFF1F4FAFFEDF1F7FFECEFF4FFEBEDF2FFEAEAEDFFE8E7E8FFE8E6E6FFE8E5
      E6FFE7E5E5FFE7E5E5FFFCFBFBFF8C8C8CFF65655BFFD6D6CCFFD6D6CCFFD2D2
      C8FF7A7A73FF4D4D43FF4D4D43FF7F7F78FF7F7F78FF4D4D43FF4D4D43FF7A7A
      73FFD2D2C8FFD6D6CCFFD6D6CCFF69695FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8C8DFFFFFFFFFFBC9C7AFFA36E
      37FFA26D36FFBC9C7BFFE9EAEEFFE9E8E9FFE9E7E7FFE8E6E6FFE6E4E4FFE4E2
      E3FFE3E1E1FFE3E1E1FFFCFBFBFF8C8C8CFF68685EFFDADAD0FFD9D9CFFFD9D9
      CFFFD5D5CBFF7D7D75FF84847CFFD5D5CDFFD5D5CDFF84847CFF7D7D75FFD5D5
      CBFFD9D9CFFFD9D9CFFFDADAD0FF6C6C62FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8D8DFFFFFFFFFF9F6931FFF0DA
      BCFFE2BE91FFA06A33FFE8E9ECFF626364FFA2A3A3FFA1A1A1FF9E9F9FFFE2E0
      DFFFE0DEDDFFE0DDDCFFFCFDFBFF8C8C8CFF626258FFE6E6E0FFE3E3DAFFE1E1
      D8FFE1E1D8FFDDDDD4FFDDDDD4FFE1E1D8FFE1E1D8FFDDDDD4FFDDDDD4FFE1E1
      D8FFE1E1D8FFE3E3DAFFE7E7E1FF64645AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8D8DFFFFFFFFFFC4A47FFFAE7A
      41FFAF7B41FFC5A581FFE2E2E3FFE2E0E0FFE2E0DFFFE1DFDEFFE0DEDDFFDEDC
      DBFFDDDBD9FFDCDAD9FFFFFEFEFF8C8C8CFF7B7B73CCBFBFB8FFF4F4F1FFF6F6
      F4FFF6F6F4FFF6F6F4FFF6F6F4FFF6F6F4FFF6F6F4FFF6F6F4FFF6F6F4FFF6F6
      F4FFF6F6F4FFF4F4F1FFBFBFB9FF7B7B73CC0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008E8F8FFFFFFFFFFFF7F7FAFFF7F9
      FDFFF7F9FEFFF7F7FAFFF5F4F5FFF5F3F3FFF5F3F3FFF5F3F3FFF5F3F3FFF5F2
      F2FFF4F2F2FFF4F2F2FFFFFFFFFF8E8E8EFFD8D8D53C7E7E76C766665DFF7474
      6BFF74746BFF74746BFF74746BFF74746BFF74746BFF74746BFF74746BFF7474
      6BFF74746BFF66665DFF7E7E76C7D8D8D53C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000989898EF8E8F8FFF8D8D8EFF8D8D
      8EFF8D8E8EFF8D8D8EFF8C8D8DFF8C8D8DFF8C8D8DFF8C8D8DFF8C8D8DFF8C8D
      8DFF8C8C8DFF8C8D8DFF8E8E8EFF989898EF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      00008000000080000000800000008000000000000000F5F5F50CF2F2F211FDFD
      FD03F7F7F709F2F2F211F2F2F211F2F2F211F2F2F211F2F2F211F2F2F211F2F2
      F211F2F2F211F2F2F211F5F5F50C000000000000000000000000B1B1B1CFA0A0
      A0FFA0A0A0FFD8D8D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF950000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000F4F4F40DC1A166AEC59043CDD9CC
      BD4EC1C1C252D0D0D03ED0D0D03ED0D0D03ED0D0D03ED0D0D03ED0D0D03ED0D0
      D03ED0D0D03ED0D0D03EC2C2C252F5F5F50C0000000000000000A0A0A0FFEBEB
      EBFFEBEBEBFFFFFFFFFF9AD9FCFF32B2F9FF03A0F7FF03A0F7FF03A0F7FF03A0
      F7FF03A0F7FF32B2F9FF9AD9FCFFFFFFFFFF0000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000F1F1F112C69842CFDD870BFFD3C2
      AE60BEBEBE56ECECEC18ECECEC18ECECEC18ECECEC18ECECEC18ECECEC18ECEC
      EC18ECECEC18ECECEC18C6C6C64BF2F2F2110000000000000000A0A0A0FFF0F0
      F0FFCCD7DDFFFFFFFFFF32B2F9FF01D4FDFF00E0FFFF03A0F7FF03A0F7FF03A0
      F7FF00E0FFFF01D4FDFF32B2F9FFFFFFFFFF0000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FDFDFD03D8CCB853D1C0AA64EFEB
      E71EDFDFDF2BD4D4D538D4D4D538D4D4D538D4D4D538D4D4D538D4D4D538D4D4
      D538D4D4D538D4D4D538D9D9D932FDFDFD030000000000000000A0A0A0FFF5F5
      F5FFD0DCE1FFFFFFFFFF42B8F9FF01D4FDFF00E6FFFF03A0F7FFFFFFFFFF03A0
      F7FF00E6FFFF01D4FDFF42B8F9FFFFFFFFFF0000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000800000008000000000000000EEEEEE16E9E9E91EFBFB
      FB05F2F2F210E9E9E91EE9E9E91EE9E9E91EE9E9E91EE9E9E91EE9E9E91EE9E9
      E91EE9E9E91EE9E9E91EEEEEEF15000000000000000000000000A0A0A0FFF8F8
      F8FFD3DEE4FFFFFFFFFFAADFFCFF02B3F9FF00ECFFFF03A0F7FF03A0F7FF03A0
      F7FF00ECFFFF02B3F9FFAADFFCFFFFFFFFFF0000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      00008000000080000000FFFFFF0080000000F2F2F210BF9A50C2CA8826E8D3C5
      B459BEBEBE57D9D9D932D9D9D932D9D9D932D9D9D932D9D9D932D9D9D932D9D9
      D932D9D9D932D9D9D932C0C0C053F4F4F40F0000000000000000A0A0A0FFF8F8
      F8FFF8F8F8FFF9F9F9FFFFFFFFFF42B8F9FF01DEFDFF03A0F7FFFFFFFFFF03A0
      F7FF01DEFDFF42B8F9FFFFFFFFFFFFFFFF950000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      000080000000800000008000000080000000F1F1F112BF9441D2D5830EFFD1C0
      AD62BABABA5BE3E3E324E3E3E324E3E3E324E3E3E324E3E3E324E3E3E324E3E3
      E324E3E3E324E3E3E324C1C1C152F2F2F2110000000000000000A0A0A0FFF8F8
      F8FFC5D4DBFFBECCD4FFFFFFFFFFAADFFCFF03ABF8FF03A0F7FFFFFFFFFF03A0
      F7FF03ABF8FFAADFFCFFFFFFFFFF000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008000000000000000000000000000000000000000E5E2DD2ADEDAD435F7F6
      F40DEBEBEB1ADEDEDE2BDEDEDE2BDEDEDE2BDEDEDE2BDEDEDE2BDEDEDE2BDEDE
      DE2BDEDEDE2BDEDEDE2BE6E6E621000000000000000000000000BDBDBDFFFAFA
      FAFFF5F5F5FFEBEBEBFFF1F1F1FFFFFFFFFF6BC7FAFF03A0F7FF03A0F7FF03A0
      F7FF6BC7FAFFFFFFFFFFFFFFFF95000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000000000000000000000000000000000000E6E5E125DEDBD732F9F7
      F70AEDEDED18DEDEDE2BDEDEDE2BDEDEDE2BDEDEDE2BDEDEDE2BDEDEDE2BDEDE
      DE2BDEDEDE2BDEDEDE2BE7E7E71F000000000000000000000000BDBDBDFFFAFA
      FAFFF0F0F0FFDEDEDEFFFEFEFEFFFFFFFFFFE9F7FEFF6BC7FAFF03A0F7FF6BC7
      FAFFE9F7FEFFFFFFFFFF00000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF008000
      000080000000800000008000000080000000800000008000000080000000FFFF
      FF0080000000000000000000000000000000F1F1F112BF9341D2D5830FFFD2C0
      AD62BABABA5BE3E3E325E3E3E325E3E3E325E3E3E325E3E3E325E3E3E325E3E3
      E325E3E3E325E3E3E325C1C1C152F2F2F2110000000000000000BDBDBDFFFAFA
      FAFFEEEEEEFFDBDBDBFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFD8D8D8FF00000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000000000000000000000000000F2F2F210BF984EC4CB8625EBD4C4
      B35ABDBDBE57DADADA31DADADA31DADADA31DADADA31DADADA31DADADA31DADA
      DA31DADADA31DADADA31C0C0C153F4F4F40F0000000000000000BDBDBDFFFAFA
      FAFFF0F0F0FFE0E0E0FFFFFFFFFFABABABFFC0C0C0FFF3F3F3FFF8F8F8FFBDBD
      BDFFF8F8F8FFA0A0A0FF00000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      00000000000000000000000000000000000000000000EEEEEE16E7E7E71FFBFB
      FB05F2F2F210E7E7E71FE7E7E71FE7E7E71FE7E7E71FE7E7E71FE7E7E71FE7E7
      E71FE7E7E71FE7E7E71FEEEEEE16000000000000000000000000C9C9C9DDBDBD
      BDFFBABABAFFB5B5B5FFB1B1B1FFC9C9C9FFF5F5F5FFFAFAFAFFD8D8D8FFE1E1
      E1FFFAFAFAFFBDBDBDFF00000000000000000000000080000000800000008000
      00008000000080000000FFFFFF00800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      000000000000000000000000000000000000FDFDFD03D9CFBE4ED3C4AE5FF1ED
      E81CE1E1E129D5D5D537D5D5D537D5D5D537D5D5D537D5D5D537D5D5D537D5D5
      D537D5D5D537D5D5D537DBDBDB30FDFDFD030000000000000000000000000000
      0000BCBCBCFFF5F5F5FFF5F5F5FFF7F7F7FFFAFAFAFFD8D8D8FFE1E1E1FFFCFC
      FCFFFAFAFAFFBDBDBDFF00000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000800000008000
      00008000000080000000800000008000000080000000FFFFFF00800000000000
      000000000000000000000000000000000000F1F1F112C59642D0DD870BFFD2C0
      AD61BEBEBE56ECECEC18ECECEC18ECECEC18ECECEC18ECECEC18ECECEC18ECEC
      EC18ECECEC18ECECEC18C6C6C64BF2F2F2110000000000000000000000000000
      0000C9C9C9DDBDBDBDFFD1D1D1FFD1D1D1FFD1D1D1FFE1E1E1FFFCFCFCFFFAFA
      FAFFC7C7C7FFD5D5D5BC00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      000000000000000000000000000000000000F4F4F40DC29F63B0C69042D0D8CC
      BD4FC1C1C152D0D0D03ED0D0D03ED0D0D03ED0D0D03ED0D0D03ED0D0D03ED0D0
      D03ED0D0D03ED0D0D03EC1C1C252F5F5F50C0000000000000000000000000000
      00000000000000000000BDBDBDFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFC7C7
      C7FFD5D5D5BCFFFFFF4D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F4F4F40DF1F1F112FDFD
      FD03F7F7F709F1F1F112F1F1F112F1F1F112F1F1F112F1F1F112F1F1F112F1F1
      F112F1F1F112F1F1F112F4F4F40D000000000000000000000000000000000000
      00000000000000000000C9C9C9DDBDBDBDFFBDBDBDFFBDBDBDFFBDBDBDFFD5D5
      D5BCFFFFFF4D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000C0C0C0008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000C0C0
      C000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000C0C0C0008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000C0C0C000800000008000
      000080000000000000000000000000000000000000000000000080808000C0C0
      C000FFFFFF008080800000000000800000000000000000000000000000000000
      00000000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000FFFFFF008080800080000000800000008000
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000FFFFFF0080808000000000000000000000000000000000000000
      80000000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C000C0C0
      C00000000000C0C0C00000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000000000000000000000000000000000000080808000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF0080808000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000FFFFFF00000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      80000000800000000000000000000000800000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000080000000000000000000000080000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000C0C0C0008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000008000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFF0000FFFF0000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF00800000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C0008080
      80000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C000FFFF00008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      80000080800000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C0008080
      8000C0C0C00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      00000080800000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C000FFFF0000C0C0C000C0C0C0008080
      8000C0C0C00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000FFFF0000FFFF0000C0C0C0008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000C0C0C00000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C0008080
      80000000000000000000000000000000000000000000FFFFFF0000000000C0C0
      C00000000000FFFFFF0000000000C0C0C00000000000C0C0C000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000008000000080000000800000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000008000000080000000800000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000008000000080000000800000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000C0C0C000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000008080000080800000808000008080000080800000808000008080000080
      8000008080000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
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
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000800000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000800000000000000080000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000800000000000000080000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00800000000000000000808000808080000080
      8000808080000080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000080000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF00000000000000000000000000FFFF
      FF00800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000080000000800000008000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00800000000000000000808000808080000080
      8000808080000080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080000000FFFFFF0080000000000000000000000000000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000008000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF000000000000000000FFFF
      FF00800000008000000080000000800000000000000000808000808080000080
      8000808080000080800080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080000000FFFFFF0080000000000000000000000080808000008080008080
      8000008080008080800000808000808080000080800080808000008080008080
      8000008080000000000000000000000000000000000000000000800000008000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000008000000000000000000000000000000000808000808080000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080808000808080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000008080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000808080000080
      80000000000000FFFF00000000000000000000FFFF0000000000808080000080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000600000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF00000000FFFFFC008001C0008003FC000000C000
      8003FC000000C0008003FC000000C0008003E0008001C0008003E0000000C000
      8003E0000000C0018003E0078001C001800380078001C003800380070000C003
      800380070000C0038003801F8001C0038003801F0000F0038003801F0000F003
      FFFF801F0000FC03FFFFFFFF8001FC07FFF3FFFFFFFFFFFFFFE1FF3FC0078003
      FFC1FE3F80038003FF83C07F00018003F00780F700018003C00F00E700018003
      801F00C100008003801F00E600008003000F00F680008003000F81FEC0008003
      000FC3BFE0018003000FFFB7E0078003801FFFB3F0078003801FFFC1F0038003
      C03FFFF3F803FFFFF0FFFFF7FFFFFFFFFFFFFFFFFFFFFFFFC001000C000FF9FF
      80010008000FF9FF80010001000FF3C780010003000F73C780010003000F27FF
      80010003000F07C780010003000F00C780010003000F01E380010007000403F1
      8001000F000006388001000F00000E388001000FF8001E388001001FFC003F01
      8001003FFE047F83FFFF007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFEFFDC007001FFFFFC7FFC007000FFFFFC3FBC0070007EFFFE3F7C0070003
      EF83F1E7C0070001DFC3F8CFC0070000DFE3FC1FC007001FDFD3FE3FC007001F
      EF3BFC1FC007001FF0FFF8CFC0078FF1FFFFE1E7C00FFFF9FFFFC3F3C01FFF75
      FFFFC7FDC03FFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFC00FFFF
      F6CFFE008000FFFFF6B7FE000000FFFFF6B7FE000000FFFFF8B780000000FFF7
      FE8F80000001C1F7FE3F80000003C3FBFF7F80000003C7FBFE3F80010003CBFB
      FEBF80030003DCF7FC9F80070003FF0FFDDF807F0003FFFFFDDF80FF8007FFFF
      FDDF81FFF87FFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  inherited SaveDialog1: TSaveDialog
    Left = 364
    Top = 596
  end
  inherited PrintDialogItem: TPrintDialog
    Left = 827
    Top = 602
  end
  inherited ColorDialog1: TColorDialog
    Left = 897
    Top = 596
  end
  object AppImages: TImageList
    Left = 984
    Top = 564
    Bitmap = {
      494C01010A003002340310001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      00000000000000000000000000000000000000000000162D0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000162D0A00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A17040070E0CE0070E0CE0070E0
      CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0
      CE0070E0CE0070E0CE0070E0CE000A1704000000000000000000000000000000
      0000FFFFFF007F7F7F00000000007F7F7F00000000007F7F7F0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0070E0
      CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0
      CE0070E0CE0070E0CE0070E0CE00000000000000000000000000000000007F7F
      7F007F7F7F00000000007F7F7F007F7F7F007F7F7F00000000007F7F7F007F7F
      7F0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0070E0
      CE0059B3A4006AD5C40070E0CE0070E0CE0070E0CE0070E0CE0065CAB900478F
      830059B3A40070E0CE0070E0CE000000000000000000000000007F7F7F000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      00007F7F7F0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0059B3
      A400000000003A746B0070E0CE0070E0CE0070E0CE00478F830010201D001020
      1D00000000001A34300070E0CE0000000000000000007F7F7F00FFFFFF000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000007F7F7F00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0059B3
      A400000000003A746B0070E0CE0070E0CE0070E0CE0010201D001A3430006AD5
      C4004D9B8E00000000004182770000000000000000007F7F7F00000000000000
      00000000000000000000000000007F7F7F00FFFFFF0000000000000000000000
      0000000000007F7F7F0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0059B3
      A400000000003A746B0070E0CE0070E0CE0070E0CE0070E0CE006AD5C40070E0
      CE0070E0CE0010201D0023474100000000007F7F7F00FFFFFF00000000000000
      00000000000000000000000000007F7F7F00FFFFFF00FFFFFF00000000000000
      000000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0059B3
      A400000000003A746B0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0059B3
      A40032655D00000000004D9B8E00000000007F7F7F00FFFFFF00000000000000
      00000000000000000000000000007F7F7F007F7F7F00FFFFFF00FFFFFF000000
      000000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0059B3
      A400000000003A746B0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE002347
      410010201D003A746B0070E0CE00000000007F7F7F00FFFFFF00000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F00FFFFFF00FFFF
      FF0000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0059B3
      A400000000003A746B0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0
      CE0032655D0010201D0065CAB900000000007F7F7F00FFFFFF00000000000000
      000000000000FFFFFF00FFFFFF0000000000000000007F7F7F007F7F7F00FFFF
      FF0000000000000000007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0059B3
      A400000000003A746B0070E0CE0070E0CE0070E0CE001A3430001A34300070E0
      CE0032655D000000000059B3A400000000007F7F7F0000000000FFFFFF000000
      00007F7F7F007F7F7F00FFFFFF0000000000000000007F7F7F007F7F7F00FFFF
      FF0000000000000000007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000002347410010201D001020
      1D000000000010201D0010201D0010201D0070E0CE004D9B8E0010201D001020
      1D00000000002347410070E0CE0000000000000000007F7F7F00FFFFFF000000
      00007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F7F000000
      0000000000007F7F7F00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005FBEAF0059B3A40059B3
      A40059B3A40059B3A40059B3A40059B3A40070E0CE0070E0CE0065CAB90059B3
      A40059B3A40070E0CE0070E0CE0000000000000000007F7F7F0000000000FFFF
      FF00000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      0000000000007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070E0CE0070E0CE0070E0
      CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0
      CE0070E0CE0070E0CE0070E0CE000000000000000000000000007F7F7F000000
      0000FFFFFF00FFFFFF007F7F7F007F7F7F007F7F7F000000000000000000FFFF
      FF007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000203B110070E0CE0070E0CE0070E0
      CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0CE0070E0
      CE0070E0CE0070E0CE0070E0CE00203B11000000000000000000000000007F7F
      7F007F7F7F0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000162D0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000162D0A00000000000000000000000000000000000000
      0000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000000000BF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000BF0000000000000000E598E400E598E400E598
      E400E598E400E598E400E598E400E598E400E598E400E598E400E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4003630
      E4003630E4003630E4003630E4003630E4003630E4003630E4003630E4003630
      E4003630E4003630E4003630E40000000000000000004C4C4C00999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      990099999900999999004C4C4C0000000000000000DF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF000000DF00000000E598E400E598E400E598
      E400E598E400E598E400E598E400E598E400E598E400E598E400E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4003630
      E4003630E4003630E4003630E4003630E4003630E4003630E4003630E4003630
      E4003630E4003630E4003630E400000000000000000099999900B2B2B200B2B2
      B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF000000FF00000000E598E400E598E400E598
      E400E598E400E598E400E598E400E598E400E598E400E598E400E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4003630
      E4003630E4003630E4003630E4003630E4003630E4003630E4003630E4003630
      E4003630E4003630E4003630E400000000000000000099999900B2B2B200B2B2
      B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFF967D6BFF967D
      6BFFA59080FFAB9788FF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFFA590
      80FFA59080FF967D6BFF967D6BFF000000FF000000008082E40000003300C556
      3300E598E400E598E400E598E4008082E40000003300C5563300E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4005D30
      E400FFE0F200A2E0FF003630E8003630E4003630E4003630E4003630E400A258
      E400FFFFFB005D9FFB003630E400000000000000000099999900B2B2B200FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B2B2B200B2B2B200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF009999990000000000000000FF967D6BFF967D6BFF967D
      6BFFE5DFDBFFEEEBE8FF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFFE5DF
      DBFFE5DFDBFF967D6BFF967D6BFF000000FF000000008082E40000003300C556
      3300E598E400E598E400E598E4008082E40000003300C5563300E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4005D30
      E400FFE0F200A2E0FF003630E8003630E4003630E4003630E4003630E400A258
      E400FFFFFB005D9FFB003630E400000000000000000099999900FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B2B2B200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF009999990000000000000000FF967D6BFF967D6BFF967D
      6BFFE5DFDBFFEEEBE8FF967D6BFF967D6BFFDCD5CFFFE5DFDBFFE5DFDBFFEEEB
      E8FFEEEBE8FFC1B3A8FF967D6BFF000000FF000000008082E40000003300C556
      3300E598E400E598E400E598E4008082E40000003300C5563300E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4005D30
      E400FFE0F200A2E0FF003630E8003630E400FFC0ED00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF005D9FFB00000000000000000099999900B2B2B200B2B2
      B200B2B2B200B2B2B200FFFFFF00FFFFFF00B2B2B200FFFFFF00FFFFFF00B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFF967D6BFF967D
      6BFFE5DFDBFFEEEBE8FF967D6BFF967D6BFFEEEBE8FFEEEBE8FFE5DFDBFFEEEB
      E8FFEEEBE8FFC1B3A8FF967D6BFF000000FF000000008082E400000033000000
      00000000000000000000E56C5B008082E4000000330000000000000000000000
      0000C5563300E598E400E598E40000000000000000003630E4003630E4005D30
      E400FFE0F200A2E0FF003630E8003630E400E19FE800C1FFFF003630ED00A258
      E400FFFFFB005D9FFB003630E400000000000000000099999900B2B2B200B2B2
      B200FFFFFF00FFFFFF00FFFFFF00FFFFFF00B2B2B200FFFFFF00FFFFFF00B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFF967D6BFF967D
      6BFFE5DFDBFFEEEBE8FF967D6BFF967D6BFFC7BAB1FFE5DFDBFF967D6BFFE5DF
      DBFFE5DFDBFF967D6BFF967D6BFF000000FF000000008082E40000003300C556
      3300E598E400E598E400E598E4008082E40000003300C5563300E598E4003356
      C40000000000E56C5B00E598E40000000000000000003630E4003630E4005D30
      E400FFE0F200A2E0FF003630E8003630E4005D30E400FFE0F2005D9FFB00A258
      E400FFFFFB005D9FFB003630E400000000000000000099999900FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B2B2B200B2B2B200FFFFFF00FFFFFF00B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFF967D6BFF967D
      6BFFE5DFDBFFEEEBE8FF967D6BFF967D6BFF967D6BFFDCD5CFFFCEC3BBFFE5DF
      DBFFE5DFDBFF967D6BFF967D6BFF000000FF000000008082E40000003300C556
      3300E598E400E598E400E598E4008082E40000003300C5563300E598E4008082
      E40000003300C5563300E598E40000000000000000003630E4003630E4005D30
      E400FFE0F200A2E0FF003630E8003630E4003630E400C17DE400C1FFFF00A258
      ED00FFFFFB005D9FFB003630E400000000000000000099999900FFFFFF00FFFF
      FF00B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200FFFFFF00FFFFFF00B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFF967D6BFF967D
      6BFFE5DFDBFFEEEBE8FF967D6BFF967D6BFF967D6BFFA08979FFEEEBE8FFEEEB
      E8FFE5DFDBFF967D6BFF967D6BFF000000FF000000008082E40000003300C556
      3300E598E400E598E400E598E4008082E40000003300C5563300E598E4003356
      C40000000000C5563300E598E40000000000000000003630E4003630E4005D30
      E400FFE0F200A2E0FF003630E8003630E4003630E4003630E400FFC0ED00C1C0
      FB00FFFFFB005D9FFB003630E400000000000000000099999900FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B2B2B200FFFFFF00FFFFFF00B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFFDCD5CFFFE5DF
      DBFFEEEBE8FFFFFFFFFFE5DFDBFFE5DFDBFFA59080FF967D6BFFC1B3A8FFFFFF
      FFFFE5DFDBFF967D6BFF967D6BFF000000FF000000008082E400000033000000
      00000000000000000000C55633008082E4000000330000000000000000000000
      0000A33D0000E598E400E598E40000000000000000003630E400FFFFFB00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00E1FFFF003658F2003630E400A258E400FFFF
      FB00FFFFFF005D9FFB003630E400000000000000000099999900B2B2B200FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B2B2B200B2B2B200FFFFFF00FFFFFF00B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFFDCD5CFFFE5DF
      DBFFE5DFDBFFE5DFDBFFE5DFDBFFE5DFDBFFA59080FF967D6BFF967D6BFFD5CB
      C4FFD5CBC4FF967D6BFF967D6BFF000000FF00000000E598E400E598E400E598
      E400E598E400E598E400E598E400E598E400E598E400E598E400E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4003630
      E4003630E4003630E4003630E4003630E4003630E4003630E4003630E4003630
      E4003630E4003630E4003630E400000000000000000099999900B2B2B200B2B2
      B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF000000FF00000000E598E400E598E400E598
      E400E598E400E598E400E598E400E598E400E598E400E598E400E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4003630
      E4003630E4003630E4003630E4003630E4003630E4003630E4003630E4003630
      E4003630E4003630E4003630E400000000000000000099999900B2B2B200B2B2
      B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2B200B2B2
      B200B2B2B200B2B2B2009999990000000000000000FF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF000000FF00000000E598E400E598E400E598
      E400E598E400E598E400E598E400E598E400E598E400E598E400E598E400E598
      E400E598E400E598E400E598E40000000000000000003630E4003630E4003630
      E4003630E4003630E4003630E4003630E4003630E4003630E4003630E4003630
      E4003630E4003630E4003630E40000000000000000004C4C4C00999999009999
      9900999999009999990099999900999999009999990099999900999999009999
      990099999900999999004C4C4C00000000000000009F967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D6BFF967D
      6BFF967D6BFF967D6BFF967D6BFF0000009F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000000000BF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007F7F7F000000FF007F7F7F00FFFFFF00000000000000
      00000000000000000000000000000000000000000000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000000000000000000001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF400000000000000000015B6840015B6840015B6
      840015B6840015B6840015B6840015B6840015B6840015B6840015B6840015B6
      840015B6840015B6840015B684000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF000000FF000000FF000000FF0000FFFF00FFFFFF0000FF
      FF000000000000000000000000000000000000000000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000000000000000000001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF400000000000000000015B6840015B6840015B6
      840015B6840015B6840015B6840015B6840015B6840015B6840015B6840015B6
      840015B6840015B6840015B6840000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF007F7F7F000000FF007F7F7F00FFFFFF0000FFFF00FFFF
      FF0000FFFF0000000000000000000000000000000000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000000000000000000001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF400000000000000000015B6840015B6840015B6
      840015B6840015B6840015B6840015B6840015B6840015B6840015B6840015B6
      840015B6840015B6840015B68400000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00000000000000000000000000F1A00000F1A00000F3A0
      0000FFF09000F8F0FF00F1A03A00F1A00000F3A00000FFF09000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00F1C1B600000000000000000001ADF40001ADF4003AAD
      F400FFF2FA0090F2FF0000ADF60001ADF400B6C9F400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00DBFFFF0000BBFA00000000000000000015B6840015B6840045B6
      8400FFF3C40095F3FF0015B69A0015B6840095C28400FFFFEC0045DBEC0015B6
      840015B6840015B6840015B684000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000F1A00000F1A00000F3A0
      0000FFF09000F8F0FF00F1A03A00F1A00000F1A00000F1A00000F6A00000FFFF
      B600F6E1FF00F1A00000F1A00000000000000000000001ADF40001ADF4003AAD
      F400FFF2FA0090F2FF0000ADF60001ADF4003AADF400FFF2FA00B6FFFF0000AD
      F70001ADF40001ADF40001ADF400000000000000000015B6840015B6840045B6
      8400FFF3C40095F3FF0015B69A0015B6840095C28400FFFFEC0045DBEC0015B6
      840015B6840015B6840015B6840000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000FF007F7F7F0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000000000000000F1A00000F1A00000F3A0
      0000FFF09000F8F0FF00F1A03A00F1A00000F1A00000F1A00000F6A00000FFFF
      B600F6E1FF00F1A00000F1A00000000000000000000001ADF40001ADF4003AAD
      F400FFF2FA0090F2FF0000ADF60001ADF40001ADF4003AADF400FFF2FA00B6FF
      FF0000ADF70001ADF40001ADF400000000000000000015B6840015B6840045B6
      8400FFF3C40095F3FF0015B69A0015B6840095C28400FFFFEC0045DBEC0015B6
      840015B6840015B6840015B684000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000000000000000F1A00000F1A00000F3A0
      0000FFF09000F8F0FF00F1A03A00F1A00000F1A00000F1A00000F6A00000FFFF
      B600F6E1FF00F1A00000F1A00000000000000000000001ADF40001ADF4003AAD
      F400FFF2FA0090F2FF0000ADF60001ADF40001ADF40001ADF40066ADF400FFFF
      FC0090F2FF0000ADF60001ADF400000000000000000015B6840015B6840045B6
      8400FFF3C40095F3FF0015B69A0015B6840095C28400FFFFEC00FFFFFF00FFFF
      FF00FFFFFF0015CFD80015B6840000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000000000000000F1A00000F1A00000F3A0
      0000FFF09000F8F0FF00F1A03A00F1A00000F1A00000F1A00000F6A00000FFFF
      B600F6E1FF00F1A00000F1A00000000000000000000001ADF40001ADF4003AAD
      F400FFF2FA0090F2FF0000ADF60001ADF40001ADF40001ADF40001ADF40090BB
      F400FFFFFD003AD7FD0001ADF400000000000000000015B6840015B6840045B6
      8400FFF3C40095F3FF0015B69A0015B6840095C28400FFFFEC0045DBEC0015B6
      840015B6840015B6840015B684000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF007F7F7F007F7F7F0000FFFF00FFFFFF007F7F7F000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000000000000000F1A00000F1A00000F3A0
      0000FFF09000F8F0FF00F1A03A00F1A00000F3A00000FFF09000F6C1B600FFFF
      B600F6E1FF00F1A00000F1A00000000000000000000001ADF40001ADF4003AAD
      F400FFF2FA0090F2FF0000ADF60001ADF40001ADF40001ADF40001ADF40066AD
      F400FFFFFC0090F2FF0000ADF600000000000000000015B6840015B6840045B6
      8400FFF3C40095F3FF0015B69A0015B6840095C28400FFFFEC0045DBEC0015B6
      840015B6840015B6840015B6840000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF000000FF000000FF00FFFFFF0000FFFF007F7F7F000000FF000000FF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000000000000000F1A00000F1A00000F3A0
      0000FFF09000F8F0FF00F1A03A00F1A00000F1A00000FCD13A00FFFFFF00FFFF
      FF00F6E1FF00F1A00000F1A00000000000000000000001ADF40001ADF4003AAD
      F400FFF2FA0090F2FF0000ADF60001ADF40090BBF40066E4FD0001ADF40090BB
      F400FFFFFD0090F2FF0000ADF600000000000000000015B6840015B6840045B6
      8400FFF3C40095F3FF0015B69A0015B6840095C28400FFFFEC0045DBEC0015B6
      840015B6840015B6840015B684000000000000000000FFFFFF0000FFFF00FFFF
      FF000000FF000000FF007F7F7F00FFFFFF007F7F7F000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000F1A00000FFFFDB00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FCFFFF00F1B19000F1A00000FAC10000FFFF
      FF00F6E1FF00F1A00000F1A00000000000000000000001ADF400FFFFFD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00DBFFFF0000BBFA00B6C9F400FFFFFF00FFFF
      FF00DBFFFF0000BBFA0001ADF400000000000000000015B68400FFFFEC00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00DDFFFF0095CFC400FFFFEC00FFFFFF00FFFF
      FF00FFFFFF0045DBEC0015B68400000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00000000000000000000000000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000000000000000000001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF400000000000000000015B6840015B6840015B6
      840015B6840015B6840015B6840015B6840015B6840015B6840015B6840015B6
      840015B6840015B6840015B6840000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF000000FF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF0000000000000000000000000000000000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000000000000000000001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF400000000000000000015B6840015B6840015B6
      840015B6840015B6840015B6840015B6840015B6840015B6840015B6840015B6
      840015B6840015B6840015B684000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF000000000000000000000000000000000000000000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A00000F1A0
      0000F1A00000F1A00000F1A00000000000000000000001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001ADF40001AD
      F40001ADF40001ADF40001ADF400000000000000000015B6840015B6840015B6
      840015B6840015B6840015B6840015B6840015B6840015B6840015B6840015B6
      840015B6840015B6840015B68400000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF008001FC1F000000000000F2A700000000
      0000E44B000000000000DEF50000000000009F79000000000000BE7A00000000
      00003E3C0000000000003E1C0000000000003F0C000000000000398C00000000
      0000518D0000000000009019000000000000A83B000000000000D06700000000
      0000E40F000000008001F83F0000000080018001000080010000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000008001800100008001FFFF800180018001F83F000000000000
      E00F000000000000C00700000000000080030000000000008003000000000000
      0001000000000000000100000000000000010000000000000001000000000000
      000100000000000080030000000000008003000000000000C007000000000000
      E00F000000000000F83F80018001800100000000000000000000000000000000
      000000000000}
  end
  object EkRTF1: TEkRTF
    OutFile = 'outfile.doc'
    TrueValue = 'True'
    FalseValue = 'False'
    UDFList = EkUDFList1
    UnicodeByDefault = False
    Charset = DEFAULT_CHARSET
    Lang = 0
    Options = [eoGraphicsWmfCompatible, eoDotAsColon]
    DisableControls = True
    Left = 315
    Top = 378
    VarDataTypes = {00000000}
  end
  object EkUDFList1: TEkUDFList
    Functions = <
      item
        Name = 'GetGraphic'
        ArgMinCount = 0
        ArgMaxCount = 3
        ResultType = 2
      end>
    Left = 385
    Top = 364
  end
  object XPColorMap1: TXPColorMap
    HighlightColor = 14410210
    BtnSelectedColor = clBtnFace
    UnusedColor = 14410210
    Left = 520
    Top = 248
  end
  object ilTreeView: TImageList
    Left = 520
    Top = 384
    Bitmap = {
      494C010107001C00540010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
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
      0000000000000000000000000000000000000000000000000000745230C2FBF2
      DDFFFBF2DDFFFBF2DCFFFAF1DCFFFAF1DBFFFAF0DBFFF9F0DAFFF9EFDAFFF9EE
      D9FFFCF2DFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006F4D2CB1F6EE
      D4FFF6EDD3FFF5EDD3FFF5ECD2FFF4EAD0FFF4E9CFFFF3E8CEFFF2E6CCFFF1E5
      CBFFF8EDD7FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000764D1CE3E07F0BFFE07F
      0BFFE07F0BFFE07F0BFFE07F0BFFE07F0BFFE07F0BFFE07F0BFFE07F0BFFE07F
      0BFFE07F0BFFE07F0BFF0606061C0000000000000000744B1DE2E0810BFFE081
      0BFFE0810BFFE0810BFFE0810BFFE0810BFFE0810BFFE0810BFFE0810BFFE081
      0BFFE0810BFFE0810BFF0606061C0000000000000000000000006646279CF6ED
      D3FFF5EDD3FFF5ECD2FFF4EAD0FFF4E9CFFFF3E8CEFFF2E6CCFFF1E5CBFFF1E3
      C9FFF8ECD7FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D6118F1FF8D00FFFF8D
      00FFFF8D00FFFF8D00FFFF8D00FFFF8D00FFFF8D00FFFF8D00FFFF8D00FFFF8D
      00FFFF8D00FFFF8D00FF0F0F0F3D0000000000000000B57115FAFF9200FFFF92
      00FFFF9200FFFF9200FFFF9200FFFF9200FFFF9200FFFF9200FFFF9200FFFF92
      00FFFF9200FFFF9200FF1B1A1A7A00000000000000000000000063442495F5ED
      D3FFF5ECD2FFF4EAD0FFF4E9CFFFF3E8CEFFF2E6CCFFF1E5CBFFF1E3C9FFF0E2
      C8FFF7EBD6FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C17714FEFF9200FFFF92
      00FFFF9200FFFF9200FFFF9200FFFF9200FFFF9200FFFF9200FFFF9200FFFF92
      00FFFF9200FFFF9200FF1212134B0000000000000000D4840FFFFF9800FFFF98
      00FFFF9800FFFF9800FFFF9800FFFF9800FFFF9800FFFF9800FFFF9800FFFF98
      00FFFF9800FFFF9800FF3E3428CB0000000000000000000000006142238FF5EC
      D2FFF4EAD0FFF4E9CFFFF3E8CEFFF2E6CCFFF1E5CBFFF1E3C9FFF0E2C8FFEFE0
      C6FFF7EAD5FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CF8211FFFF9700FFFF97
      00FFFF9700FFFF9700FFFF9700FFFF9700FFFF9700FFFF9700FFFF9700FFFF97
      00FFFF9700FFFF9700FF1616165F0000000000000000E89308FFFF9E00FFFF9E
      00FFFF9E00FFFF9E00FFFF9E00FFFF9E00FFFF9E00FFFF9E00FFFF9E00FFFF9E
      00FFFF9E00FFFF9E00FF76541CE30000000000000000000000005E40228AF4EA
      D0FFF4E9CFFFF3E8CEFFF2E6CCFFF1E5CBFFF1E3C9FFF0E2C8FFEFE0C6FFEEDE
      C4FFF6E9D4FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DA8A0DFFFF9B00FFFF9B
      00FFFF9B00FFFF9B00FFFF9B00FFFF9B00FFFF9B00FFFF9B00FFFF9B00FFFF9B
      00FFFF9B00FFFF9B00FF1B1A1A780000000000000000976F2CFB967338FD9673
      38FD967338FD967338FD967338FD967338FDD38E14FFFFA400FFFFA400FFFFA4
      00FFFFA400FFFFA400FFD48E0FFF0000000000000000000000005C3F2085F4E9
      CFFFF3E8CEFFF2E6CCFFF1E5CBFFF1E3C9FFF0E2C8FFEFE0C6FFEEDEC4FFEDDC
      C2FFF5E8D2FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E59309FFFFA000FFFFA0
      00FFFFA000FFFFA000FFFFA000FFFFA000FFFFA000FFFFA000FFFFA000FFFFA0
      00FFFFA000FFFFA000FF23211D900000000000000000909090E5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFEFEFEFFFEFEFEFFFEFDFDFFA58D5EFF977E4EFF977E
      4EFF977E4EFF977E4EFF634D27D7000000000000000000000000593D1F80F3E8
      CEFFF2E6CCFFF1E5CBFFF1E3C9FFF0E2C8FFEFE0C6FFEEDEC4FFEDDCC2FFEBD9
      BFFFF4E6D0FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F19D05FFFFA400FFFFA4
      00FFFFA400FFFFA400FFFFA400FFFFA400FFFFA400FFFFA400FFFFA400FFFFA4
      00FFFFA400FFFFA400FF2A2621A50000000000000000909090E5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFEFEFEFFFEFEFEFFFEFDFDFFFDFDFDFFFDFCFCFFFDFC
      FCFFFDFCFCFFFDFCFCFF0B0B0C30000000000000000000000000583B1E7CF2E6
      CCFFF1E5CBFFF1E3C9FFF0E2C8FFEFE0C6FFEEDEC4FFEDDCC2FFEBD9BFFFE9D5
      BBFFF4E4CEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A47B28FCAB8437FFAB84
      37FFAB8437FFAB8437FFAB8437FFAB8437FFFBA701FFFFA900FFFFA900FFFFA9
      00FFFFA900FFFFA900FF41392DC50000000000000000909090E5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFEFEFEFFFEFEFEFFFEFDFDFFFDFDFDFFFDFCFCFFFDFC
      FCFFFDFCFCFFFDFCFCFF0B0B0C3000000000000000000000000055391D77F1E5
      CBFFF1E3C9FFF0E2C8FFEFE0C6FFEEDEC4FFEDDCC2FFEBD9BFFFE9D5BBFFE8D1
      B7FFF3E3CDFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7BE5FEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFAD8B46FFA38343FFA383
      43FFA38343FFA38343FF2D271D7F0000000000000000909090E5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFEFEFEFFFEFEFEFFFEFDFDFFFDFDFDFFFDFCFCFFFDFC
      FCFFFDFCFCFFFDFCFCFF0B0B0C3000000000000000000000000052371C73F1E3
      C9FFF0E2C8FFEFE0C6FFEEDEC4FFEDDCC2FFEBD9BFFFE9D5BBFFE8D1B7FFE6CF
      B5FFF2E1CCFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7979E5474748FF4747
      48FF474748FF474748FFFEFDFDFF313131A72F2F2FAE2F2F2FAE2F2F2FAE2F2F
      2FAE2F2F2FAE2F2F2FAE000000000000000000000000909090E5474748FF4747
      48FF474748FF474748FFFEFEFEFF525252A7494949AE494949AE494949AE4949
      49AE494949AE494949AE0000000000000000000000000000000050361B6FF0E2
      C8FFEFE0C6FFEEDEC4FFEDDCC2FFEBD9BFFFE9D5BBFFE8D1B7FFE6CEB4FFE4C9
      B1FFE9D0BDFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000131313552626279B2626
      279B2626279B2626279B08080825000000000000000000000000000000000000
      00000000000000000000000000000000000000000000292929553F3F419B3F3F
      419B3F3F419B3F3F419B0A0A0A25000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004F351A6CEFE0
      C6FFEEDEC4FFEDDCC2FFEBD9BFFFE9D5BBFFE8D1B7FFE6CFB5FFCCAF92FFFFF6
      E5FF4F351A6C0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D341969EEDE
      C4FFEDDCC2FFEBD9BFFFE9D5BBFFE8D1B7FFE6CFB5FFE5CCB2FFDABFA4FF4D34
      1969000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003926134D4C33
      19674C3319674C3319674C3319674C3319674C3319674C3319674C3319670000
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
      0000000000000000000000000000000000000000000000000000303D74C2DDDC
      FAFFDDDCFAFFDDDCFAFFDDDCFAFFDDDCFAFFDCDCFAFFDDDCFAFFDCDCFAFFD9DA
      FAFFDEDFFCFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002C386FB1D6D3
      F5FFD5D3F5FFD6D3F5FFD5D3F5FFD2D0F5FFD1D0F5FFCFCEF2FFCCCBF2FFCCCB
      F2FFD7D8F7FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C2876E30B28E0FF0B28
      E0FF0B28E0FF0B28E0FF0B28E0FF0B28E0FF0B28E0FF0B28E0FF0B28E0FF0B28
      E0FF0B28E0FF0B28E0FF0707071C00000000000000001D2A75E20B28E0FF0B28
      E0FF0B28E0FF0B28E0FF0B28E0FF0B28E0FF0B28E0FF0B28E0FF0B28E0FF0B28
      E0FF0B28E0FF0B28E0FF0707071C0000000000000000000000002732669CD5D3
      F5FFD6D3F5FFD5D3F5FFD2D0F5FFD1D0F5FFCFCEF2FFCCCBF2FFCCCBF2FFC9CA
      F2FFD7D9F7FF00000000000000000000000000000000313131E3808080FF8080
      80FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FF808080FF0707071C0000000000000000192A9CF10022FFFF0022
      FFFF0022FFFF0022FFFF0022FFFF0022FFFF0022FFFF0022FFFF0022FFFF0022
      FFFF0022FFFF0022FFFF0F0F0F3D00000000000000001526B6FA001EFFFF001E
      FFFF001EFFFF001EFFFF001EFFFF001EFFFF001EFFFF001EFFFF001EFFFF001E
      FFFF001EFFFF001EFFFF1B1B1C7A000000000000000000000000242F6395D6D3
      F5FFD5D3F5FFD2D0F5FFD1D0F5FFCFCEF2FFCCCBF2FFCCCBF2FFC9CAF2FFC7C8
      F0FFD7D9F7FF000000000000000000000000000000004D4D4DF1999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF0F0F0F3D00000000000000001428C1FE001EFFFF001E
      FFFF001EFFFF001EFFFF001EFFFF001EFFFF001EFFFF001EFFFF001EFFFF001E
      FFFF001EFFFF001EFFFF1313124B00000000000000000F1FD4FF0015FFFF0015
      FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015
      FFFF0015FFFF0015FFFF282C3ECB000000000000000000000000222D618FD5D3
      F5FFD2D0F5FFD1D0F5FFCFCEF2FFCCCBF2FFCCCBF2FFC9CAF2FFC7C8F0FFC7C9
      F0FFD5D7F7FF00000000000000000000000000000000686868FE999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF1212124B00000000000000001120CFFF0015FFFF0015
      FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015
      FFFF0015FFFF0015FFFF1616165F00000000000000000716E8FF0011FFFF0011
      FFFF0011FFFF0011FFFF0011FFFF0011FFFF0011FFFF0011FFFF0011FFFF0011
      FFFF0011FFFF0011FFFF1C2276E3000000000000000000000000222C5F8AD2D0
      F5FFD1D0F5FFCFCEF2FFCCCBF2FFCCCBF2FFC9CAF2FFC7C8F0FFC7C9F0FFC2C5
      EDFFD3D5F5FF00000000000000000000000000000000737373FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF1616165F00000000000000000D1BD9FF0015FFFF0015
      FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015FFFF0015
      FFFF0015FFFF0015FFFF1A1B1B7800000000000000002B3396FB393F97FD393F
      97FD393F97FD393F97FD393F97FD393F97FD131DD4FF0008FFFF0008FFFF0008
      FFFF0008FFFF0008FFFF0F15D4FF000000000000000000000000202A5B85D1D0
      F5FFCFCEF2FFCCCBF2FFCCCBF2FFC9CAF2FFC7C8F0FFC7C9F0FFC2C5EDFFC2C6
      EDFFD3D4F5FF000000000000000000000000000000007A7A7AFF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF1A1A1A7800000000000000000914E6FF000DFFFF000D
      FFFF000DFFFF000DFFFF000DFFFF000DFFFF000DFFFF000DFFFF000DFFFF000D
      FFFF000DFFFF000DFFFF1E1E24900000000000000000909090E5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5E60A6FF4E5196FF4E51
      96FF4E5196FF4E5196FF272A62D70000000000000000000000001F295980CFCE
      F2FFCCCBF2FFCCCBF2FFC9CAF2FFC7C8F0FFC7C9F0FFC2C5EDFFC2C6EDFFBEC2
      EBFFD0D3F5FF00000000000000000000000000000000858585FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF1B1B1B900000000000000000050DF2FF0008FFFF0008
      FFFF0008FFFF0008FFFF0008FFFF0008FFFF0008FFFF0008FFFF0008FFFF0008
      FFFF0008FFFF0008FFFF21222AA50000000000000000909090E5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFFFCFCFCFF0C0C0B300000000000000000000000001E28587CCCCB
      F2FFCCCBF2FFC9CAF2FFC7C8F0FFC7C9F0FFC2C5EDFFC2C6EDFFBEC2EBFFBABF
      E8FFCED2F5FF000000000000000000000000000000008F8F8FFF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF1D1D1DA50000000000000000282BA4FC3739ABFF3739
      ABFF3739ABFF3739ABFF3739ABFF3739ABFF0004FAFF0004FFFF0004FFFF0004
      FFFF0004FFFF0004FFFF2C2E40C50000000000000000909090E5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFFFCFCFCFF0C0C0B300000000000000000000000001C265577CCCB
      F2FFC9CAF2FFC7C8F0FFC7C9F0FFC2C5EDFFC2C6EDFFBEC2EBFFBABFE8FFB7BF
      E8FFCBCFF2FF00000000000000000000000000000000575757FC666666FF6666
      66FF666666FF666666FF666666FF666666FF949494FF999999FF999999FF9999
      99FF999999FF999999FF292929C500000000000000007B7B7BE5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4547ADFF4345A3FF4345
      A3FF4345A3FF4345A3FF1D1E2D7F0000000000000000909090E5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFFFCFCFCFF0C0C0B300000000000000000000000001B265273C9CA
      F2FFC7C8F0FFC7C9F0FFC2C5EDFFC2C6EDFFBEC2EBFFBABFE8FFB7BFE8FFB5BD
      E6FFCBD1F2FF000000000000000000000000000000007B7B7BE5FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF707070FF696969FF6969
      69FF696969FF696969FF1B1B1B7F0000000000000000797B7BE5474747FF4747
      47FF474747FF474747FFFFFFFFFF313131A72F2F2FAE2F2F2FAE2F2F2FAE2F2F
      2FAE2F2F2FAE2F2F2FAE000000000000000000000000909090E5474747FF4747
      47FF474747FF474747FFFFFFFFFF515151A7494949AE494949AE494949AE4949
      49AE494949AE494949AE000000000000000000000000000000001B25506FC7C8
      F0FFC7C9F0FFC2C5EDFFC2C6EDFFBEC2EBFFBABFE8FFB7BFE8FFB3BBE6FFB1BC
      E3FFBCC7E8FF000000000000000000000000000000007B7B7BE5474747FF4747
      47FF474747FF474747FFFFFFFFFF313131A72F2F2FAE2F2F2FAE2F2F2FAE2F2F
      2FAE2F2F2FAE2F2F2FAE000000000000000000000000121212552626259B2626
      259B2626259B2626259B08080825000000000000000000000000000000000000
      000000000000000000000000000000000000000000002828285540413F9B4041
      3F9B40413F9B40413F9B0A0A0A25000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A244E6CC7C9
      F0FFC2C5EDFFC2C6EDFFBEC2EBFFBABFE8FFB7BFE8FFB5BDE6FF939DCCFFE6E6
      FFFF1A244E6C00000000000000000000000000000000121212552626269B2626
      269B2626269B2626269B08080825000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A234D69C2C5
      EDFFC2C6EDFFBEC2EBFFBABFE8FFB7BFE8FFB5BDE6FFB3BBE6FFA3ACD9FF1A23
      4D69000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001219394D1922
      4C6719224C6719224C6719224C6719224C6719224C6719224C6719224C670000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFC0030000FFFFFFFFC0030000
      80018001C003000080018001C003000080018001C003000080018000C0030000
      80018000C003000080018000C003000080018000C003000080018001C0030000
      80018001C003000080018001C003000080018001C003000081FF81FFC0030000
      FFFFFFFFC0070000FFFFFFFFC00F0000FFFFFFFFC003FFFFFFFFFFFFC003FFFF
      80018001C003800180018001C003800180018001C003800180018000C0038001
      80018000C003800180018000C003800180018000C003800180018001C0038001
      80018001C003800180018001C003800180018001C003800181FF81FFC00381FF
      FFFFFFFFC007FFFFFFFFFFFFC00FFFFF00000000000000000000000000000000
      000000000000}
  end
  object GlobalMessageTimer: TTimer
    Enabled = False
    OnTimer = GlobalMessageTimerTimer
    Left = 432
    Top = 544
  end
  object CloudLogTimer: TTimer
    Enabled = False
    OnTimer = CloudLogTimerTimer
    Left = 432
    Top = 496
  end
end
