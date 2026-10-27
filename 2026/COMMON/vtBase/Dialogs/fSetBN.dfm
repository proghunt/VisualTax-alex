object SetBN: TSetBN
  Left = 341
  Top = 129
  BorderIcons = [biSystemMenu]
  Caption = 'Limited BN'
  ClientHeight = 260
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object meBN: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 326
    Height = 207
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 545
    ExplicitHeight = 193
  end
  object pnlButtons: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 216
    Width = 326
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 56
    ExplicitTop = 232
    ExplicitWidth = 185
    DesignSize = (
      326
      41)
    object btnCancel: TButton
      Left = 240
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 485
    end
    object btnOk: TButton
      Left = 158
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 403
    end
  end
end
