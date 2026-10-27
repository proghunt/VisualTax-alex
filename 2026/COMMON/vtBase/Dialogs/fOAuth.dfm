object frmOAuth: TfrmOAuth
  Left = 0
  Top = 0
  Caption = 'OAuth Web-Login'
  ClientHeight = 554
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  DesignSize = (
    601
    554)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 509
    Width = 584
    Height = 3
    Anchors = [akLeft, akRight, akBottom]
    ExplicitTop = 522
    ExplicitWidth = 623
  end
  object Label1: TLabel
    Left = 8
    Top = 524
    Width = 477
    Height = 12
    Anchors = [akLeft, akBottom]
    Caption = 
      'This windows will close automatically when a token could be dete' +
      'cted and extracted.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 535
  end
  object Browser: TWebBrowser
    Left = 8
    Top = 8
    Width = 584
    Height = 496
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnTitleChange = BrowserTitleChange
    OnBeforeNavigate2 = BrowserBeforeNavigate2
    OnNavigateComplete2 = BrowserNavigateComplete2
    ExplicitWidth = 623
    ExplicitHeight = 508
    ControlData = {
      4C0000005C3C0000433300000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object btn_Close: TButton
    Left = 517
    Top = 517
    Width = 75
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    ModalResult = 8
    TabOrder = 1
    ExplicitLeft = 556
    ExplicitTop = 530
  end
end
