object frmShowGlobalMessage: TfrmShowGlobalMessage
  Left = 0
  Top = 0
  Caption = 'Global Message'
  ClientHeight = 459
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnMouseWheelDown = sbMessageMouseWheelDown
  OnMouseWheelUp = sbMessageMouseWheelUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sbMessage: TScrollBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 417
    Height = 412
    VertScrollBar.Tracking = True
    Align = alClient
    TabOrder = 0
    OnMouseWheelDown = sbMessageMouseWheelDown
    OnMouseWheelUp = sbMessageMouseWheelUp
    ExplicitLeft = 0
    ExplicitTop = 0
    object lbMessage: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 60
      Height = 16
      Align = alTop
      Caption = 'lbMessage'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 418
    Width = 423
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 184
    ExplicitTop = 360
    ExplicitWidth = 185
    object lbClose: TLabel
      Left = 8
      Top = 24
      Width = 3
      Height = 13
    end
    object btnOk: TButton
      Left = 174
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object TimerClose: TTimer
    Enabled = False
    OnTimer = TimerCloseTimer
    Left = 171
    Top = 179
  end
end
