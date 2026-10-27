object ChooseFileForm: TChooseFileForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Choose File'
  ClientHeight = 384
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    309
    384)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDir: TLabel
    Left = 8
    Top = 11
    Width = 44
    Height = 13
    Caption = 'Directory'
  end
  object lblFilesInDirectory: TLabel
    Left = 8
    Top = 40
    Width = 83
    Height = 13
    Caption = 'Files in Directory:'
  end
  object edDir: TEdit
    Left = 64
    Top = 8
    Width = 235
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 0
  end
  object lbFiles: TListBox
    Left = 8
    Top = 64
    Width = 291
    Height = 281
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    OnDblClick = btnChooseClick
  end
  object btnChoose: TButton
    Left = 64
    Top = 351
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Choose'
    Default = True
    TabOrder = 2
    OnClick = btnChooseClick
  end
  object btnCancel: TButton
    Left = 168
    Top = 351
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
