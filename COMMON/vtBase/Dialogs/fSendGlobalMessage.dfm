object frmSendGlobalMessage: TfrmSendGlobalMessage
  Left = 0
  Top = 0
  Caption = 'Send Global Message'
  ClientHeight = 416
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    412
    416)
  PixelsPerInch = 96
  TextHeight = 13
  object lbMessage: TLabel
    Left = 8
    Top = 10
    Width = 46
    Height = 13
    Caption = 'Message:'
  end
  object lbRunningProcesses: TLabel
    Left = 253
    Top = 10
    Width = 94
    Height = 13
    Caption = 'Running processes:'
  end
  object lbProcessesCount: TLabel
    Left = 350
    Top = 10
    Width = 3
    Height = 13
  end
  object meMessage: TMemo
    Left = 8
    Top = 32
    Width = 396
    Height = 289
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      
        'System maintenance will start in 5 minutes. Please save your wor' +
        'k and exit')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object cbExitAfterDisplay: TCheckBox
    Left = 8
    Top = 336
    Width = 105
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Exit after display'
    TabOrder = 1
  end
  object cbShowForSeconds: TCheckBox
    Left = 119
    Top = 336
    Width = 177
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Show for a few seconds and stop'
    TabOrder = 2
  end
  object seSeconds: TSpinEdit
    Left = 311
    Top = 334
    Width = 49
    Height = 22
    Anchors = [akLeft, akBottom]
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 5
    OnChange = seSecondsChange
  end
  object btnSend: TButton
    Left = 8
    Top = 368
    Width = 129
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Send Message'
    TabOrder = 4
    OnClick = btnSendClick
  end
end
