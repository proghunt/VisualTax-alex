object frmEditUser: TfrmEditUser
  Left = 0
  Top = 0
  Caption = 'User'
  ClientHeight = 170
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 289
    Height = 129
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 40
    ExplicitTop = 8
    ExplicitWidth = 185
    ExplicitHeight = 41
    DesignSize = (
      289
      129)
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 11
      Height = 13
      Caption = 'ID'
    end
    object Label2: TLabel
      Left = 24
      Top = 43
      Width = 25
      Height = 13
      Caption = 'Login'
    end
    object Label3: TLabel
      Left = 24
      Top = 70
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label4: TLabel
      Left = 24
      Top = 97
      Width = 24
      Height = 13
      Caption = 'Email'
    end
    object chbAdministrator: TCheckBox
      Left = 127
      Top = 15
      Width = 97
      Height = 17
      Caption = 'Administrator'
      TabOrder = 0
      OnClick = edIDChange
    end
    object edID: TEdit
      Left = 80
      Top = 13
      Width = 41
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = 'edID'
      OnChange = edIDChange
    end
    object edLogin: TEdit
      Left = 80
      Top = 40
      Width = 193
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      Text = 'Edit1'
      OnChange = edIDChange
    end
    object edPassword: TEdit
      Left = 80
      Top = 67
      Width = 193
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
      TabOrder = 3
      Text = 'Edit1'
      OnChange = edIDChange
    end
    object edEmail: TEdit
      Left = 80
      Top = 94
      Width = 193
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      Text = 'Edit1'
      OnChange = edIDChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 129
    Width = 289
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 72
    ExplicitTop = 248
    ExplicitWidth = 185
    DesignSize = (
      289
      41)
    object BitBtn1: TBitBtn
      Left = 119
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 232
    end
    object BitBtn2: TBitBtn
      Left = 200
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 313
    end
  end
end
