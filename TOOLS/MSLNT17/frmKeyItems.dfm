object frmKey: TfrmKey
  Left = 548
  Top = 181
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Enter key items'
  ClientHeight = 459
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 477
    Height = 418
    Align = alClient
    Caption = 'pnlMain'
    TabOrder = 0
    object aList: TListView
      Left = 1
      Top = 1
      Width = 475
      Height = 416
      Align = alClient
      Checkboxes = True
      Columns = <>
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object pnlButton: TPanel
    Left = 0
    Top = 418
    Width = 477
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnOk: TButton
      Left = 32
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      Left = 368
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
