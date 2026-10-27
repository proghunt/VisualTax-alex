object frmCloudLogon: TfrmCloudLogon
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'VisualTax Logon'
  ClientHeight = 315
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vtShape6: TvtShape
    Left = 0
    Top = 0
    Width = 508
    Height = 113
    Align = alTop
    Brush.Color = 8673536
    Brush.Style = bsBDiagonal
    GradientColor = clWhite
    Gradient = True
    FillDirection = vtHorizCenterFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = 'gyuoglyujhg;lk'
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtPageFooter = False
    vtIsPrintable = True
    ExplicitLeft = -589
    ExplicitWidth = 1116
  end
  object Image3: TImage
    Left = 14
    Top = 8
    Width = 41
    Height = 41
    Picture.Data = {
      055449636F6E0000010001002020100000000000E80200001600000028000000
      2000000040000000010004000000000080020000000000000000000000000000
      0000000000000000000080000080000000808000800000008000800080800000
      80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
      FFFFFF00FFF7F877868687F87760F8383770FFFFFFF7F877686867F87780F838
      3770FFFFFFF7F877868687F87760F8383770FFFFFFF7F877686867F87780F838
      3770FFFFFFF7F877868687F87760F8383770FFFFFFF7F877686867F87780F838
      3770FFFF77777777777777777770F838377077FF78888888888877777770F838
      377087FF77777777777777777770F838377077FFFF77FF88888888888880F838
      37707FFFFFFF77FF877777777770F8383770FFFFFFFFFF77FF8778888770F387
      7370FFFFFFFFFFFF77FF8788780F387877370FFFFFFFFFFFFF77FF7780F38780
      077370FFFFFFFFFFFFFF77FF0F3878888877370FFFFFFFFFFFFFFF70F3878303
      03078770FFFFFFFFFFFFFF703878000000007730FFFFFFFFFFFFFFF000011111
      11111100FFB0FFFFF1006FFFFF99B999B99999FFFFB06FFFFF34FFFFFF99B9B9
      9BB9B9FFFF8076FFFF34FFFFF99BB9BB99BB99FFFF8063EFFF80EFFFF99B999B
      999999FFFF806F38FFF16FFFF99B9B9BB9BB99FFFF806FF7FFF34FFFFF9B9B9B
      B9999FFFFFF16FF873830887FF9B99B9BB9BFFFFFF000EF107000006FFF999B9
      999FFFFFFFFFFFFFFFFFFFFFFFFF99BB999FFFFFFFFFFFFFFFFFFFFFFFFFF999
      B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFF999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      99FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000018000000000
      000002A000000FF0000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000}
    Transparent = True
  end
  object Label16: TLabel
    Left = 196
    Top = 8
    Width = 117
    Height = 31
    Caption = 'VisualTax'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label14: TLabel
    Left = 319
    Top = 8
    Width = 19
    Height = 15
    Caption = 'TM'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lbProgramId: TLabel
    Left = 170
    Top = 45
    Width = 168
    Height = 26
    Alignment = taCenter
    AutoSize = False
    Caption = 'VT-201X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 26
    Top = 77
    Width = 456
    Height = 26
    Alignment = taCenter
    AutoSize = False
    Caption = 'Multi-App / Multi-Year version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 113
    Width = 321
    Height = 263
    TabOrder = 0
    Visible = False
    object lblName: TLabel
      Left = 16
      Top = 42
      Width = 41
      Height = 16
      Caption = 'Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblEmail: TLabel
      Left = 16
      Top = 79
      Width = 40
      Height = 16
      Caption = 'Email:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPhone: TLabel
      Left = 16
      Top = 117
      Width = 45
      Height = 16
      Caption = 'Phone:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblinstruction: TLabel
      Left = 14
      Top = 209
      Width = 66
      Height = 16
      Cursor = crHandPoint
      Caption = 'Instruction'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      OnClick = lblinstructionClick
    end
    object lblNewUser: TLabel
      Left = 16
      Top = 7
      Width = 56
      Height = 16
      Caption = 'New User'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtName: TEdit
      Left = 63
      Top = 41
      Width = 249
      Height = 21
      TabOrder = 0
      OnChange = edtEmailChange
    end
    object edtEmail: TEdit
      Left = 63
      Top = 78
      Width = 249
      Height = 21
      TabOrder = 1
      OnChange = edtEmailChange
    end
    object edtPhone: TEdit
      Left = 63
      Top = 116
      Width = 249
      Height = 21
      TabOrder = 2
      OnChange = edtEmailChange
    end
    object btnGetDemoKey: TButton
      Left = 84
      Top = 162
      Width = 137
      Height = 25
      Caption = 'Get demo key'
      TabOrder = 3
      OnClick = btnGetDemoKeyClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 113
    Width = 508
    Height = 202
    Align = alClient
    TabOrder = 1
    object lblKey: TLabel
      Left = 112
      Top = 42
      Width = 173
      Height = 16
      Caption = 'VTRemote Access Password:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 7
      Width = 78
      Height = 16
      Caption = 'Existing User'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object edtKey: TEdit
      Left = 297
      Top = 41
      Width = 120
      Height = 21
      TabOrder = 0
      OnChange = edtKeyChange
    end
    object btnLogon: TButton
      Left = 280
      Top = 98
      Width = 137
      Height = 25
      Caption = 'Logon'
      TabOrder = 1
      OnClick = btnLogonClick
    end
    object btnClose: TButton
      Left = 345
      Top = 154
      Width = 137
      Height = 25
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCloseClick
    end
  end
end
