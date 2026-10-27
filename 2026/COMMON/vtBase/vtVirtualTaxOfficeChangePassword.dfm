object vtVirtualTaxOfficeChangePassword: TvtVirtualTaxOfficeChangePassword
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Virtual Tax Office Change Password'
  ClientHeight = 255
  ClientWidth = 311
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
  object shHeader: TvtShape
    Left = 0
    Top = 0
    Width = 311
    Height = 70
    Align = alTop
    Brush.Color = 11301888
    GradientColor = clBlack
    FillDirection = vtUpFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = ''
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtPageFooter = False
    vtIsPrintable = True
    ExplicitWidth = 764
  end
  object vtLabel37: TvtLabel
    Left = 49
    Top = 21
    Width = 212
    Height = 31
    Caption = 'Virtual Tax Office'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 70
    Width = 311
    Height = 499
    Align = alTop
    TabOrder = 0
    object gbLogin: TGroupBox
      Left = 9
      Top = 6
      Width = 289
      Height = 168
      Caption = 'Login'
      TabOrder = 0
      object lbCyberId: TLabel
        Left = 10
        Top = 24
        Width = 44
        Height = 13
        Caption = 'Virtual ID'
      end
      object Label1: TLabel
        Left = 10
        Top = 51
        Width = 86
        Height = 13
        Caption = 'Current Password'
      end
      object Label3: TLabel
        Left = 10
        Top = 78
        Width = 70
        Height = 13
        Caption = 'New Password'
      end
      object Label6: TLabel
        Left = 10
        Top = 105
        Width = 86
        Height = 13
        Caption = 'Confirm password'
      end
      object edCyberId: TEdit
        Left = 111
        Top = 21
        Width = 168
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edPassword: TEdit
        Left = 111
        Top = 48
        Width = 168
        Height = 21
        PasswordChar = '*'
        TabOrder = 1
      end
      object edNewPassword: TEdit
        Left = 111
        Top = 75
        Width = 168
        Height = 21
        PasswordChar = '*'
        TabOrder = 2
      end
      object edConfirmPassword: TEdit
        Left = 111
        Top = 102
        Width = 168
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
      end
      object btnChangePassword: TButton
        Left = 85
        Top = 131
        Width = 118
        Height = 25
        Caption = 'Change Password'
        TabOrder = 4
        OnClick = btnChangePasswordClick
      end
    end
  end
end
