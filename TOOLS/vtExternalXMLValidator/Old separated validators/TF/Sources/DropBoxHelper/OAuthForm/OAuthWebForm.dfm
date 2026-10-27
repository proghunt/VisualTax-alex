object frm_OAuthWebForm: Tfrm_OAuthWebForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'OAuth Web-Login'
  ClientHeight = 674
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 589
    Width = 606
    Height = 85
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      606
      85)
    object Bevel1: TBevel
      Left = 8
      Top = 5
      Width = 590
      Height = 2
      Anchors = [akLeft, akTop, akRight]
    end
    object Label1: TLabel
      Left = 11
      Top = 14
      Width = 408
      Height = 13
      Caption = 
        'This window will be closed automatically when code could be dete' +
        'cted and extracted.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label1Click
    end
    object Label2: TLabel
      Left = 11
      Top = 33
      Width = 377
      Height = 13
      Caption = 
        'If program did not extract code, copy and paste it here and pres' +
        's "Save code"'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label1Click
    end
    object Label3: TLabel
      Left = 11
      Top = 55
      Width = 31
      Height = 13
      Caption = 'Code:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Label1Click
    end
    object btn_Close: TButton
      Left = 523
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Close'
      ModalResult = 8
      TabOrder = 0
      ExplicitTop = 13
    end
    object edCode: TEdit
      Left = 48
      Top = 52
      Width = 249
      Height = 21
      TabOrder = 1
    end
    object btnSaveCode: TButton
      Left = 304
      Top = 50
      Width = 75
      Height = 25
      Caption = 'Save Code'
      TabOrder = 2
      OnClick = btnSaveCodeClick
    end
  end
  object ChromiumWindow: TChromiumWindow
    Left = 0
    Top = 0
    Width = 606
    Height = 589
    Align = alClient
    TabOrder = 1
    OnAfterCreated = ChromiumWindowAfterCreated
    ExplicitHeight = 632
  end
  object TimerChromium: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerChromiumTimer
    Left = 200
    Top = 472
  end
end
