object vtVirtualTaxOfficeColourSettings: TvtVirtualTaxOfficeColourSettings
  Left = 0
  Top = 0
  Caption = 'Virtual Tax Office'
  ClientHeight = 603
  ClientWidth = 978
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnShow = FormShow
  DesignSize = (
    978
    603)
  PixelsPerInch = 96
  TextHeight = 13
  object shHeader: TvtShape
    Left = 0
    Top = 0
    Width = 978
    Height = 70
    Align = alTop
    Brush.Color = 11301888
    GradientColor = clBlack
    FillDirection = vtUpFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = ''
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtPageFooter = False
    vtIsPrintable = True
    ExplicitWidth = 764
  end
  object vtLabel37: TvtLabel
    Left = 313
    Top = 19
    Width = 351
    Height = 31
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Virtual Office Colour Settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    vtBorderType = vtlblNoBorder
  end
  object pnlMain: TPanel
    Left = 0
    Top = 70
    Width = 465
    Height = 533
    Align = alLeft
    TabOrder = 0
    object gbTemplates: TGroupBox
      AlignWithMargins = True
      Left = 6
      Top = 363
      Width = 453
      Height = 123
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Caption = 'Colour Settings Templates'
      TabOrder = 0
      object lblTemplates: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 105
        Width = 443
        Height = 13
        Align = alBottom
        Caption = 'Click to Preview, DblClick to use as Current'
        ExplicitWidth = 205
      end
      object lbTemplates: TListBox
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 443
        Height = 81
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnClick = lbTemplatesClick
        OnDblClick = lbTemplatesDblClick
      end
    end
    object pnlButtons: TPanel
      Left = 1
      Top = 491
      Width = 463
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object btnCancel: TButton
        Left = 117
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 0
      end
      object btnSave: TButton
        Left = 27
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Save'
        Default = True
        TabOrder = 1
        OnClick = btnSaveClick
      end
      object btnSaveAsTemplate: TButton
        Left = 320
        Top = 5
        Width = 116
        Height = 25
        Caption = 'Save as template'
        TabOrder = 2
        OnClick = btnSaveAsTemplateClick
      end
    end
    object pnlSettings: TPanel
      Left = 1
      Top = 1
      Width = 463
      Height = 357
      Align = alTop
      Caption = 'pnlSettings'
      TabOrder = 2
      object pgSettings: TPageControl
        Left = 1
        Top = 1
        Width = 461
        Height = 324
        ActivePage = tabMain
        Align = alClient
        TabOrder = 0
        object tabMain: TTabSheet
          Caption = 'Main'
          object BackgroundColour: TShape
            Left = 126
            Top = 28
            Width = 65
            Height = 21
          end
          object BackgroundColourBtn: TSpeedButton
            Left = 192
            Top = 28
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object BackgroundFileNameBtn: TSpeedButton
            Left = 347
            Top = 77
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = BackgroundFileNameBtnClick
          end
          object BorderColour: TShape
            Left = 126
            Top = 52
            Width = 65
            Height = 21
          end
          object BorderColourBtn: TSpeedButton
            Left = 192
            Top = 52
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object CompanyNameColour: TShape
            Left = 126
            Top = 173
            Width = 65
            Height = 21
          end
          object CompanyNameColourBtn: TSpeedButton
            Left = 192
            Top = 173
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object lbCompanyNameSize: TLabel
            Left = 221
            Top = 177
            Width = 97
            Height = 13
            Caption = 'Company Name Size'
          end
          object lblBackgroundColour: TLabel
            Left = 5
            Top = 32
            Width = 90
            Height = 13
            Caption = 'Background Colour'
          end
          object lblBackgroundFileName: TLabel
            Left = 5
            Top = 81
            Width = 89
            Height = 13
            Caption = 'Background Image'
          end
          object lblBorderColour: TLabel
            Left = 5
            Top = 56
            Width = 60
            Height = 13
            Caption = 'Border Color'
          end
          object lblBorderWidth: TLabel
            Left = 221
            Top = 56
            Width = 63
            Height = 13
            Caption = 'Border Width'
          end
          object lblCompanyName: TLabel
            Left = 5
            Top = 129
            Width = 75
            Height = 13
            Caption = 'Company Name'
          end
          object lblCompanyNameColour: TLabel
            Left = 5
            Top = 177
            Width = 109
            Height = 13
            Caption = 'Company Name Colour'
          end
          object lblLogoFileName: TLabel
            Left = 5
            Top = 105
            Width = 56
            Height = 13
            Caption = 'Logo Image'
          end
          object lblLogoMessage: TLabel
            Left = 5
            Top = 153
            Width = 68
            Height = 13
            Caption = 'Logo Message'
          end
          object lblLogoMessageColour: TLabel
            Left = 5
            Top = 201
            Width = 96
            Height = 13
            Caption = 'Logo Message Color'
          end
          object lbLogoMessageSize: TLabel
            Left = 221
            Top = 201
            Width = 90
            Height = 13
            Caption = 'Logo Message Size'
          end
          object lblProjectorColour: TLabel
            Left = 221
            Top = 32
            Width = 78
            Height = 13
            Caption = 'Projector Colour'
          end
          object lblTitleColour: TLabel
            Left = 221
            Top = 8
            Width = 54
            Height = 13
            Caption = 'Title Colour'
          end
          object lblTitleSmallColour: TLabel
            Left = 5
            Top = 8
            Width = 81
            Height = 13
            Caption = 'Small Title Colour'
          end
          object lbNameColour: TLabel
            Left = 5
            Top = 225
            Width = 109
            Height = 13
            Caption = 'First/Last Name Colour'
          end
          object lbNameSize: TLabel
            Left = 221
            Top = 225
            Width = 97
            Height = 13
            Caption = 'First/Last Name Size'
          end
          object lbOtherTextColour: TLabel
            Left = 5
            Top = 249
            Width = 81
            Height = 13
            Caption = 'Other Text Color'
          end
          object lbOtherTextSize: TLabel
            Left = 221
            Top = 249
            Width = 75
            Height = 13
            Caption = 'Other Text Size'
          end
          object lbWallsWidth: TLabel
            Left = 5
            Top = 274
            Width = 56
            Height = 13
            Caption = 'Walls Width'
          end
          object LogoFileNameBtn: TSpeedButton
            Left = 408
            Top = 101
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = BackgroundFileNameBtnClick
          end
          object LogoMessageColour: TShape
            Left = 126
            Top = 197
            Width = 65
            Height = 21
          end
          object LogoMessageColourBtn: TSpeedButton
            Left = 192
            Top = 197
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object NameColour: TShape
            Left = 126
            Top = 221
            Width = 65
            Height = 21
          end
          object NameColourBtn: TSpeedButton
            Left = 192
            Top = 221
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object OtherTextColour: TShape
            Left = 126
            Top = 245
            Width = 65
            Height = 21
          end
          object OtherTextColourBtn: TSpeedButton
            Left = 192
            Top = 245
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object ProjectorColour: TShape
            Left = 342
            Top = 28
            Width = 65
            Height = 21
          end
          object ProjectorColourBtn: TSpeedButton
            Left = 408
            Top = 28
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object TitleColour: TShape
            Left = 342
            Top = 4
            Width = 65
            Height = 21
          end
          object TitleColourBtn: TSpeedButton
            Left = 408
            Top = 4
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object TitleSmallColour: TShape
            Left = 126
            Top = 4
            Width = 65
            Height = 21
          end
          object TitleSmallColourBtn: TSpeedButton
            Left = 192
            Top = 4
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object BackgroundFileName: TEdit
            Left = 126
            Top = 77
            Width = 219
            Height = 21
            TabOrder = 0
          end
          object BorderWidth: TSpinEdit
            Left = 342
            Top = 52
            Width = 89
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 1
            Value = 0
            OnChange = BorderWidthChange
          end
          object cbRepeat: TCheckBox
            Left = 375
            Top = 80
            Width = 56
            Height = 17
            Caption = 'Repeat'
            TabOrder = 2
            OnClick = cbRepeatClick
          end
          object CompanyName: TEdit
            Left = 126
            Top = 125
            Width = 305
            Height = 21
            TabOrder = 3
          end
          object CompanyNameSize: TSpinEdit
            Left = 342
            Top = 173
            Width = 89
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 4
            Value = 0
            OnChange = BorderWidthChange
          end
          object LogoFileName: TEdit
            Left = 126
            Top = 101
            Width = 281
            Height = 21
            TabOrder = 5
          end
          object LogoMessage: TEdit
            Left = 126
            Top = 149
            Width = 305
            Height = 21
            TabOrder = 6
          end
          object LogoMessageSize: TSpinEdit
            Left = 342
            Top = 197
            Width = 89
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 7
            Value = 0
            OnChange = BorderWidthChange
          end
          object NameSize: TSpinEdit
            Left = 342
            Top = 221
            Width = 89
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 8
            Value = 0
            OnChange = BorderWidthChange
          end
          object OtherTextSize: TSpinEdit
            Left = 342
            Top = 245
            Width = 89
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 9
            Value = 0
            OnChange = BorderWidthChange
          end
          object WallsWidth: TSpinEdit
            Left = 126
            Top = 270
            Width = 89
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 10
            Value = 0
            OnChange = BorderWidthChange
          end
        end
        object tabLeftWall: TTabSheet
          Caption = 'Left Wall'
          ImageIndex = 1
          object lblLeftPanel: TLabel
            Left = 3
            Top = 7
            Width = 76
            Height = 13
            Caption = 'Left Wall Colour'
          end
          object LeftPanelColour: TShape
            Left = 91
            Top = 3
            Width = 330
            Height = 62
          end
          object LeftPanelColourBtn: TSpeedButton
            Left = 427
            Top = 3
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = FillColourBtnClick
          end
          object LeftBaseBoardColour: TShape
            Left = 292
            Top = 91
            Width = 65
            Height = 21
          end
          object LeftBaseBoardColourBtn: TSpeedButton
            Left = 363
            Top = 91
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object lbLeftBaseboardColour: TLabel
            Left = 255
            Top = 95
            Width = 31
            Height = 13
            Caption = 'Colour'
          end
          object lbLeftCrownColour: TLabel
            Left = 255
            Top = 118
            Width = 31
            Height = 13
            Caption = 'Colour'
          end
          object LeftCrownColour: TShape
            Left = 292
            Top = 114
            Width = 65
            Height = 21
          end
          object LeftCrownColourBtn: TSpeedButton
            Left = 363
            Top = 114
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object ShowLeftWindow: TCheckBox
            Left = 91
            Top = 71
            Width = 86
            Height = 17
            Caption = 'Show Window'
            TabOrder = 0
            OnClick = cbRepeatClick
          end
          object ShowLeftBaseboard: TCheckBox
            Left = 91
            Top = 94
            Width = 102
            Height = 17
            Caption = 'Show BaseBoard'
            TabOrder = 1
            OnClick = cbRepeatClick
          end
          object ShowLeftCrown: TCheckBox
            Left = 91
            Top = 117
            Width = 86
            Height = 17
            Caption = 'Show Crown'
            TabOrder = 2
            OnClick = cbRepeatClick
          end
        end
        object tabRightWall: TTabSheet
          Caption = 'Right Wall'
          ImageIndex = 2
          object lblRightPanel: TLabel
            Left = 3
            Top = 7
            Width = 82
            Height = 13
            Caption = 'Right Wall Colour'
          end
          object RightPanelColour: TShape
            Left = 96
            Top = 3
            Width = 328
            Height = 62
          end
          object RightPanelColourBtn: TSpeedButton
            Left = 427
            Top = 3
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = FillColourBtnClick
          end
          object lbRightBaseBoardColour: TLabel
            Left = 263
            Top = 103
            Width = 31
            Height = 13
            Caption = 'Colour'
          end
          object RightBaseBoardColour: TShape
            Left = 300
            Top = 99
            Width = 65
            Height = 21
          end
          object RightBaseBoardColourBtn: TSpeedButton
            Left = 371
            Top = 99
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object lbRightCrownColour: TLabel
            Left = 263
            Top = 126
            Width = 31
            Height = 13
            Caption = 'Colour'
          end
          object RightCrownColour: TShape
            Left = 300
            Top = 122
            Width = 65
            Height = 21
          end
          object RightCrownColourBtn: TSpeedButton
            Left = 371
            Top = 122
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object ShowRightWindow: TCheckBox
            Left = 99
            Top = 79
            Width = 86
            Height = 17
            Caption = 'Show Window'
            TabOrder = 0
            OnClick = cbRepeatClick
          end
          object ShowRightBaseBoard: TCheckBox
            Left = 99
            Top = 102
            Width = 102
            Height = 17
            Caption = 'Show BaseBoard'
            TabOrder = 1
            OnClick = cbRepeatClick
          end
          object ShowRightCrown: TCheckBox
            Left = 99
            Top = 125
            Width = 86
            Height = 17
            Caption = 'Show Crown'
            TabOrder = 2
            OnClick = cbRepeatClick
          end
          object cbSameWalls: TCheckBox
            Left = 99
            Top = 160
            Width = 126
            Height = 17
            Caption = 'The same as Left wall'
            TabOrder = 3
            OnClick = cbSameWallsClick
          end
        end
        object tabFloor: TTabSheet
          Caption = 'Floor'
          ImageIndex = 3
          object FloorColour: TShape
            Left = 67
            Top = 2
            Width = 357
            Height = 62
          end
          object FloorColourBtn: TSpeedButton
            Left = 427
            Top = 2
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = FillColourBtnClick
          end
          object GroutColour: TShape
            Left = 67
            Top = 67
            Width = 65
            Height = 21
          end
          object GroutColourBtn: TSpeedButton
            Left = 137
            Top = 67
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = ColourBtnClick
          end
          object lblFloor: TLabel
            Left = 3
            Top = 6
            Width = 58
            Height = 13
            Caption = 'Floor Colour'
          end
          object lblGrout: TLabel
            Left = 3
            Top = 69
            Width = 55
            Height = 13
            Caption = 'Grout Color'
          end
          object rgFloorMode: TRadioGroup
            Left = 166
            Top = 70
            Width = 258
            Height = 43
            Caption = 'Floor Mode'
            Columns = 2
            Items.Strings = (
              'Show tile lines'
              'No decoration')
            TabOrder = 0
            OnClick = cbRepeatClick
          end
        end
        object tabCeiling: TTabSheet
          Caption = 'Ceiling'
          ImageIndex = 4
          object lbCeiling: TLabel
            Left = 4
            Top = 6
            Width = 65
            Height = 13
            Caption = 'Ceiling Colour'
          end
          object CeilingColour: TShape
            Left = 75
            Top = 2
            Width = 350
            Height = 62
          end
          object CeilingColourBtn: TSpeedButton
            Left = 428
            Top = 2
            Width = 23
            Height = 21
            Caption = '..'
            OnClick = FillColourBtnClick
          end
          object rgCeilingMode: TRadioGroup
            Left = 75
            Top = 70
            Width = 356
            Height = 43
            Caption = 'Ceiling Mode'
            Columns = 3
            Items.Strings = (
              'No sky'
              'Full sky'
              'Partial Skylight')
            TabOrder = 0
            OnClick = cbRepeatClick
          end
        end
      end
      object pnlPreviewBtn: TPanel
        Left = 1
        Top = 325
        Width = 461
        Height = 31
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object btnPreview: TButton
          Left = 365
          Top = 2
          Width = 75
          Height = 25
          Caption = 'Preview'
          TabOrder = 0
          OnClick = btnPreviewClick
        end
      end
    end
  end
  object CW: TChromiumWindow
    Left = 465
    Top = 70
    Width = 513
    Height = 533
    Align = alClient
    TabOrder = 1
    Visible = False
    OnAfterCreated = CWAfterCreated
  end
  object PreviewHtml: TMemo
    Left = 551
    Top = 353
    Width = 698
    Height = 249
    Lines.Strings = (
      '<!DOCTYPE html>'
      '<html lang="en">'
      '<head>'
      '  <title>Virtual Tax Office</title>'
      '    <meta charset="utf-8">'
      
        '  <meta name="viewport" content="width=device-width, initial-sca' +
        'le=1">'
      
        '  <link rel="stylesheet" type="text/css" href="https://maxcdn.bo' +
        'otstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">'
      
        '  <link rel="stylesheet" type="text/css" href="%URL%css/virtualt' +
        'axoffice.css?v=%VERSION%">'
      
        '  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.' +
        '1/jquery.min.js"></script>'
      
        '  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/j' +
        's/bootstrap.min.js"></script>'
      '  <script src="%URL%js/PerspectiveTransform.min.js"></script> '
      
        '  <script src="%URL%js/virtualtaxoffice.js?v=%VERSION%"></script' +
        '> '
      '  <script>  '
      '    const LEFT_PANEL_COLOR = '#39'%LEFT_PANEL_COLOR%'#39';'
      '    const RIGHT_PANEL_COLOR = '#39'%RIGHT_PANEL_COLOR%'#39';'
      '    const FLOOR_COLOR = '#39'%FLOOR_COLOR%'#39';'
      '    const GROUT_COLOR = '#39'%GROUT_COLOR%'#39';'
      '    const BORDER_COLOR = '#39'%BORDER_COLOR%'#39';'
      '    const BORDER_WIDTH = %BORDER_WIDTH%;'
      '    const WALLS_WIDTH = %WALLS_WIDTH%;'
      '    const FLOOR_MODE = '#39'%FLOOR_MODE%'#39';'
      '    const CEILING_MODE = '#39'%CEILING_MODE%'#39';'
      '    const LEFT_WALL_MODE = '#39'%LEFT_WALL_MODE%'#39';'
      '    const RIGHT_WALL_MODE = '#39'%RIGHT_WALL_MODE%'#39';'
      '    const BACKGROUND_FILENAME = '#39'%BACKGROUND_FILENAME%'#39';'
      '    const CEILING_COLOR = '#39'%CEILING_COLOR%'#39';'
      '    const LEFT_BASEBOARD_COLOR = '#39'%LEFT_BASEBOARD_COLOR%'#39';'
      '    const RIGHT_BASEBOARD_COLOR = '#39'%RIGHT_BASEBOARD_COLOR%'#39';'
      '    const LEFT_CROWN_COLOR = '#39'%LEFT_CROWN_COLOR%'#39';'
      '    const RIGHT_CROWN_COLOR = '#39'%RIGHT_CROWN_COLOR%'#39';'
      '    '
      '    var left_column_width = WALLS_WIDTH;'
      '    var right_column_width = WALLS_WIDTH;'
      '  </script>'
      '  <style>'
      '    .company_text {'
      '        color: %COMPANY_NAME_COLOR%;'
      '        font-size: %COMPANY_NAME_SIZE%px;'
      '    }'
      '    .company_large_text {'
      '        color: %COMPANY_NAME_COLOR%;'
      '        font-size: 40px;'
      '    }'
      '    .company_small_text {'
      '        color: %COMPANY_NAME_COLOR%;'
      '        font-size: 18px;'
      '    }'
      '    .logo_text {'
      '        color: %LOGO_MESSAGE_COLOR%;'
      '        font-size: %LOGO_MESSAGE_SIZE%px;'
      '    }'
      '    .name_text {'
      '        color: %NAME_COLOR%;'
      '        font-size: %NAME_SIZE%px;'
      '    }'
      '    .other_text {'
      '        color: %OTHER_TEXT_COLOR%;'
      '        font-size: %OTHER_TEXT_SIZE%px;        '
      '    }'
      '    .floor_style {'
      '        %FLOOR_COLOR_STYLE%;        '
      '    }'
      '    .ceiling_style {'
      '        %CEILING_COLOR_STYLE%;        '
      '    }'
      '    .left_wall_style {'
      '        %LEFT_PANEL_COLOR_STYLE%;        '
      '    }'
      '    .right_wall_style {'
      '        %RIGHT_PANEL_COLOR_STYLE%;        '
      '    }'
      '    .wall_text_panel {'
      '        background-color: %LOGO_MESSAGE_CONTRAST_COLOR%; '
      '        padding: 5px; '
      '        border-radius: 5px;'
      '    }'
      '    .left_baseboard_style {        '
      '        display: %LEFT_BASEBOARD_DISPLAY%;'
      '        width: 100%;'
      '        height: 20px;'
      '    }'
      '    .right_baseboard_style {'
      '        display: %RIGHT_BASEBOARD_DISPLAY%;       '
      '        width: 100%;'
      '        height: 20px;        '
      '    }'
      '    .left_crown_style {        '
      '        display: %LEFT_CROWN_DISPLAY%;'
      '        width: 100%;'
      '        height: 20px;'
      '    }'
      '    .right_crown_style {'
      '        display: %RIGHT_CROWN_DISPLAY%;       '
      '        width: 100%;'
      '        height: 20px;        '
      '    }'
      '  </style>'
      '</head>'
      '<body>'
      
        '<table id="holder" style="background-color: %BACKGROUND_COLOR%>;' +
        ' '
      
        '                          background-image: url('#39'%BACKGROUND_FIL' +
        'ENAME%'#39'); '
      
        '                          background-repeat: %BACKGROUND_REPEAT%' +
        '>; '
      '                          background-size: %BACKGROUND_SIZE%>;"'
      '                   width=100% height=100%>'
      '    <tr height=100px>'
      '        <td style="width: %WALLS_WIDTH%px" id="left_td"></td>'
      '        <td>'
      '            <div class="header">'
      '                <div id="title_panel">'
      
        '                    <table id="titles" border=0 height=80px widt' +
        'h=100%>'
      '                        <tr>'
      '                            <td height="100%" width=100px>    '
      
        '                                <center><span class="company_lar' +
        'ge_text"><strong>%BUSINESS_NAME%</strong></span></center><br>'
      
        '                                <center><span class="company_sma' +
        'll_text"><strong>www.VirtualOfficeTower.com</strong></span></cen' +
        'ter>'
      '                            </td>                            '
      '                        </tr>'
      '                    </table>'
      '                </div>'
      '            </div>'
      '        </td>'
      
        '        <td style="width: %WALLS_WIDTH%px" id="right_td"></canva' +
        's></td>'
      '    </tr>'
      '    <tr class="inn1er_body" id="inner_body_row">'
      '        <td> '
      '        </td>'
      '        <td class="content" height=100%>'
      '            <table id="frame_table" class="frame_table">'
      
        '                <tr class="content_border_tr" style="background-' +
        'color: %BORDER_COLOR%;">'
      '                    <td></td>'
      '                    <td colspan=2>                '
      
        '                        <button type="button" class="btn btn-pri' +
        'mary">Login</button>'
      '                    </td>'
      '                </tr>'
      '                <tr>'
      
        '                    <td class="content_border_td" style="backgro' +
        'und-color: %BORDER_COLOR%;"></td>'
      '                    <td height=100%>'
      
        '                        <div id="content_div" class="content_div' +
        '" style="overflow-y: auto; overflow-x: auto; height: 100px; back' +
        'ground-color: %PROJECTOR_COLOR%; border: %BORDER%;">'
      '                    '
      '            <h1>Welcome to Virtual Tax Office</h1>'
      '            </div>'
      '                    </td>'
      
        '                    <td class="content_border_td" style="backgro' +
        'und-color: %BORDER_COLOR%;"></td>'
      '                </tr>'
      
        '                <tr class="content_border_tr" style="background-' +
        'color: %BORDER_COLOR%;">'
      '                    <td colspan=3></td>'
      '                </tr>'
      '            </table>'
      '            </div>'
      '        </td>'
      '        <td>            '
      '        </td>'
      '    </tr>'
      '    <tr class="floor" height=100px>'
      '        <td colspan=3></td>'
      '    </tr>'
      '</table>'
      ''
      
        '<div id="ceiling_div" class="ceiling_div" style="visibility: hid' +
        'den;">'
      
        '    <canvas id="ceiling_canvas" width=10px height=10px"></canvas' +
        '>'
      '</div>'
      ''
      
        '<div id="left_wall" class="left_wall_div" style="visibility: hid' +
        'den; width: %WALLS_WIDTH%px; max-width; %WALLS_WIDTH%px;">'
      
        '    <canvas id="left_wall_canvas" width=10px height=10px"></canv' +
        'as>'
      '    '
      
        '    <div id="left_wall_panel" class="left_wall_panel " style="pa' +
        'dding:10px; width: %WALLS_WIDTH%px;">        '
      '        <div class="left_crown_style"></div>'
      
        '        <div class="form-group" style="position: relative; heigh' +
        't: 25px;">               '
      
        '            <button style="float: right;" onclick="left_collapse' +
        '_expand();"><img id="left_collapse_expand_img" src="%URL%img/col' +
        'lapse.png"></button>'
      '        </div>'
      
        '        <div id="left_menu_panel" class="btn-group-vertical cent' +
        'er-block" style="visibility: visible; position: relative;">'
      '            <div class="form-group">&nbsp;</div>'
      '            <div class="wall_text_panel">'
      
        '                <div class="form-group"><img id="office_logo" st' +
        'yle="max-width: 260px;" src="%LOGO_FILENAME%"></div>'
      
        '                <div class="form-group logo_text">%LOGO_MESSAGE%' +
        '</div>'
      
        '                <div class="form-group wordwrap other_text">Virt' +
        'ual ID: %VIRTUALID%</div>'
      
        '                <div class="form-group wordwrap other_text">%PHO' +
        'NE%</div>'
      
        '                <div class="form-group wordwrap other_text"><a h' +
        'ref="%WEBSITE%" target="_blank">%WEBSITE%</a></div>'
      
        '                <div class="form-group wordwrap other_text" styl' +
        'e="width: 100%"><a href="mailto:%EMAIL%">%EMAIL%</a></div>'
      '            </div>            '
      '        </div>'
      '        <div class="left_baseboard_style"></div>'
      '    </div>'
      '</div>'
      ''
      ''
      
        '<div id="right_wall" class="right_wall_div" style="visibility: h' +
        'idden; width: %WALLS_WIDTH%px; max-width; %WALLS_WIDTH%px;">'
      
        '    <canvas id="right_wall_canvas" width=10px height=10px"></can' +
        'vas>'
      
        '    <div id="right_wall_panel" class="right_wall_panel " style="' +
        'padding:10px; width: %WALLS_WIDTH%px;">'
      '        <div class="right_crown_style"></div>'
      
        '        <div class="form-group" style="position: relative; heigh' +
        't: 25px;">'
      
        '            <button style="float: left;" onclick="right_collapse' +
        '_expand();"><img id="right_collapse_expand_img" src="%URL%img/co' +
        'llapse.png"></button>'
      '        </div>         '
      
        '        <div id="right_menu_panel" style="visibility: visible; p' +
        'osition: relative;"></div>'
      '        <div class="form-group">&nbsp;</div> '
      '        <div class="wall_text_panel">'
      
        '            <div class="form-group wordwrap other_text"><strong>' +
        'Services provided:</strong></div>'
      
        '            <div class="form-group wordwrap other_text">%SERVICE' +
        'S%</div>'
      '        </div>               '
      '        <div class="right_baseboard_style"></div>'
      '    </div>'
      '</div>'
      ''
      
        '<div id="floor_div" class="floor_div floor_style" style="visibil' +
        'ity: hidden;">'
      '    <canvas id="floor_canvas" width=10px height=10px"></canvas>'
      '</div>'
      ''
      '<div id="monitor_stand_div" class="monitor_stand_div">'
      
        '    <canvas id="monitor_stand_canvas" width=10px height=10px></c' +
        'anvas>'
      '</div>'
      ''
      '<script>'
      '    if (localStorage.getItem("left_panel_visible") == "false") {'
      '        left_collapse_expand();'
      '    }'
      
        '    if (localStorage.getItem("right_panel_visible") == "false") ' +
        '{'
      '        right_collapse_expand();'
      '    }'
      '</script>'
      '</body>'
      '</html>')
    TabOrder = 2
    Visible = False
    WordWrap = False
  end
  object SelectColorDialog: TColorDialog
    Left = 216
    Top = 24
  end
  object TimerChromium: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerChromiumTimer
    Left = 584
    Top = 88
  end
  object OpenImageDialog: TOpenPictureDialog
    Filter = 
      'All (*.gif;*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff;*.ico;*.emf;*.w' +
      'mf)|*.gif;*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff;*.ico;*.emf;*.wm' +
      'f|GIF Image (*.gif)|*.gif|Portable Network Graphics (*.png)|*.pn' +
      'g|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|' +
      'Bitmaps (*.bmp)|*.bmp|TIFF Images (*.tif)|*.tif|TIFF Images (*.t' +
      'iff)|*.tiff|Icons (*.ico)|*.ico|Enhanced Metafiles (*.emf)|*.emf' +
      '|Metafiles (*.wmf)|*.wmf'
    Left = 584
    Top = 144
  end
  object TimerSpinEditChange: TTimer
    Enabled = False
    OnTimer = TimerSpinEditChangeTimer
    Left = 528
    Top = 256
  end
end
