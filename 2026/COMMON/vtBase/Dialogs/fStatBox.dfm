object StatusBox: TStatusBox
  Left = 250
  Top = 174
  BorderStyle = bsDialog
  Caption = 'Status'
  ClientHeight = 50
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object MsgLabel: TLabel
    Left = 39
    Top = 20
    Width = 73
    Height = 16
    Alignment = taCenter
    Caption = 'Msg Label'
  end
end
