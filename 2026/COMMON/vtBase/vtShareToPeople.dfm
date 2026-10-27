object frmShareToPeople: TfrmShareToPeople
  Left = 0
  Top = 0
  Caption = 'Share with ..'
  ClientHeight = 354
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 313
    Width = 368
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      368
      41)
    object BitBtn2: TBitBtn
      Left = 279
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      Left = 198
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 368
    Height = 62
    Align = alTop
    TabOrder = 0
    DesignSize = (
      368
      62)
    object Label4: TLabel
      Left = 12
      Top = 12
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object btnAdd: TSpeedButton
      Left = 247
      Top = 9
      Width = 107
      Height = 48
      Anchors = [akTop, akRight]
      Caption = 'Add e-mail to list'
      Enabled = False
      OnClick = btnAddClick
      ExplicitLeft = 268
    end
    object Label1: TLabel
      Left = 12
      Top = 39
      Width = 24
      Height = 13
      Caption = 'Email'
    end
    object edName: TEdit
      Left = 60
      Top = 9
      Width = 181
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object edEmail: TEdit
      Left = 60
      Top = 36
      Width = 181
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = edEmailChange
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 62
    Width = 368
    Height = 251
    Align = alClient
    TabOrder = 1
    DesignSize = (
      368
      251)
    object btnRemove: TSpeedButton
      Left = 99
      Top = 208
      Width = 162
      Height = 34
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Remove e-mail from list'
      OnClick = btnRemoveClick
      ExplicitTop = 191
      ExplicitWidth = 168
    end
    object lbEmails: TListBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 360
      Height = 197
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
  end
end
