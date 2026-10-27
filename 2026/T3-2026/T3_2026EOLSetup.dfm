object EOLSetUpT3_2026: TEOLSetUpT3_2026
  Left = 284
  Top = 240
  Caption = 'EOLSetUpT3_2026'
  ClientHeight = 381
  ClientWidth = 708
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object UrlLabel: TLabel
    Left = 10
    Top = 116
    Width = 172
    Height = 16
    Caption = 'EFile On-line Web site (URL):'
  end
  object Label5: TLabel
    Left = 194
    Top = 140
    Width = 468
    Height = 16
    Caption = 
      '(To get the default URL provided by the program, delete the abov' +
      'e and click Save)'
  end
  object EfileType: TPanel
    Left = 0
    Top = 0
    Width = 708
    Height = 33
    Hint = 'Click to change tax year and rates'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'EFILE ON-LINE (EOL)  SETUP'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 376
    Top = 312
    Width = 105
    Height = 49
    Caption = '&Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object SaveBtn: TBitBtn
    Left = 232
    Top = 312
    Width = 105
    Height = 49
    Caption = '&Save'
    Default = True
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    TabOrder = 2
    OnClick = SaveBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 34
    Width = 689
    Height = 72
    Caption = 'Provided by CRA'
    TabOrder = 3
    object Label16: TLabel
      Left = 80
      Top = 25
      Width = 117
      Height = 16
      Caption = 'Efile On-line number'
    end
    object Label17: TLabel
      Left = 136
      Top = 49
      Width = 57
      Height = 16
      Caption = 'Password'
    end
    object Label2: TLabel
      Left = 288
      Top = 32
      Width = 231
      Height = 16
      Caption = '(enter as given by CRA. i.e. upper case)'
    end
    object OnlineNoBox: TEdit
      Left = 208
      Top = 17
      Width = 73
      Height = 24
      CharCase = ecUpperCase
      TabOrder = 0
      Text = 'ONLINEBOX'
    end
    object PasswordBox: TEdit
      Left = 208
      Top = 41
      Width = 73
      Height = 24
      PasswordChar = '*'
      TabOrder = 1
      Text = 'PasswordBox'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 192
    Width = 689
    Height = 105
    TabOrder = 4
    object Label1: TLabel
      Left = 25
      Top = 41
      Width = 125
      Height = 16
      Caption = 'EFile/Netfile file folder'
    end
    object Label4: TLabel
      Left = 200
      Top = 66
      Width = 485
      Height = 15
      Caption = 
        '(Folder where transmission  XML file is stored temporarily befor' +
        'e it is transmitted to CRA)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 200
      Top = 82
      Width = 465
      Height = 14
      Caption = 
        '(Please use a short folder path such as C:\T1-2010\EolFiles (it ' +
        'should not exceed 70 characters)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 214
      Top = 17
      Width = 206
      Height = 15
      Caption = 'Do not use spaces in the folder name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object NetfileDirBox: TEdit
      Left = 208
      Top = 33
      Width = 473
      Height = 24
      TabOrder = 0
    end
  end
  object ProdOrTestBox: TRadioGroup
    Left = 565
    Top = 50
    Width = 97
    Height = 49
    Caption = 'Mode'
    Color = clYellow
    ItemIndex = 0
    Items.Strings = (
      'Production'
      'Test')
    ParentColor = False
    TabOrder = 5
    TabStop = True
    Visible = False
    OnClick = ProdOrTestBoxClick
  end
  object URLBox: TEdit
    Left = 217
    Top = 115
    Width = 463
    Height = 24
    TabOrder = 6
  end
end
