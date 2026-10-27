object TimedMsg: TTimedMsg
  Left = 221
  Top = 191
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Info Message'
  ClientHeight = 118
  ClientWidth = 438
  Color = 15925247
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormCreate
  PixelsPerInch = 120
  TextHeight = 20
  object MsgLbl: TLabel
    Left = 20
    Top = 10
    Width = 51
    Height = 19
    Caption = 'MsgLbl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object CloseBtn: TBitBtn
    Left = 180
    Top = 70
    Width = 94
    Height = 31
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 0
    OnClick = CloseBtnClick
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 364
    Top = 24
  end
end
