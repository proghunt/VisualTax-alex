object SelApp: TSelApp
  Left = 513
  Top = 107
  Width = 301
  Height = 213
  Caption = 'New Return ...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    293
    161)
  PixelsPerInch = 120
  TextHeight = 16
  object lbApps: TListBox
    Left = 10
    Top = 10
    Width = 228
    Height = 207
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 16
    TabOrder = 0
    OnClick = lbAppsClick
    OnDblClick = lbAppsDblClick
  end
  object buCreate: TButton
    Left = 261
    Top = 10
    Width = 92
    Height = 31
    Caption = 'Create'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object buCancel: TButton
    Left = 261
    Top = 64
    Width = 92
    Height = 31
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
