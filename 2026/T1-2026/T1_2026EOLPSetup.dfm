object EOLPSetUpT1_2026: TEOLPSetUpT1_2026
  Left = 257
  Top = 261
  Caption = 'EOLPSetUpT1_2026'
  ClientHeight = 440
  ClientWidth = 783
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
  PixelsPerInch = 96
  TextHeight = 16
  object HeaderPanel: TPanel
    Left = 0
    Top = 0
    Width = 783
    Height = 33
    Hint = 'Click to change tax year and rates'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'EFILE On-line PLUS (EOLP)  and SEND SETUP'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 392
    Top = 328
    Width = 105
    Height = 49
    Caption = '&Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object SaveBtn: TBitBtn
    Left = 264
    Top = 328
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
    Top = 48
    Width = 745
    Height = 169
    Caption = 'Provided by CRA'
    TabOrder = 3
    object Label16: TLabel
      Left = 96
      Top = 32
      Width = 117
      Height = 16
      Caption = 'Efile On-line number'
    end
    object Label17: TLabel
      Left = 152
      Top = 96
      Width = 57
      Height = 16
      Caption = 'Password'
    end
    object Label6: TLabel
      Left = 16
      Top = 128
      Width = 202
      Height = 16
      Caption = 'EFile On-line Plus Web site (URL):'
    end
    object Label13: TLabel
      Left = 264
      Top = 128
      Width = 370
      Height = 16
      Caption = '(Check with CCRA for the final URL address for EFILE ON-LINE)'
    end
    object Label2: TLabel
      Left = 128
      Top = 64
      Width = 82
      Height = 15
      Caption = 'Transmitter No'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 320
      Top = 32
      Width = 231
      Height = 16
      Caption = '(enter as given by CRA. i.e. upper case)'
    end
    object Label8: TLabel
      Left = 316
      Top = 93
      Width = 77
      Height = 16
      Caption = 'Enter it again'
    end
    object OnlineNoBox: TEdit
      Left = 232
      Top = 24
      Width = 73
      Height = 24
      TabOrder = 0
      Text = 'OnlineBox'
      OnExit = OnlineNoBoxExit
    end
    object PasswordBox: TEdit
      Left = 232
      Top = 88
      Width = 73
      Height = 24
      PasswordChar = '*'
      TabOrder = 1
      Text = 'PasswordBox'
    end
    object URLBox: TEdit
      Left = 232
      Top = 120
      Width = 497
      Height = 24
      TabOrder = 2
    end
    object TransmitterNoBox: TEdit
      Left = 232
      Top = 56
      Width = 73
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'TransmitterNoBox'
    end
    object ProductionOrTestBox: TRadioGroup
      Left = 532
      Top = 56
      Width = 185
      Height = 57
      Caption = 'Production or Test'
      Color = clYellow
      ItemIndex = 0
      Items.Strings = (
        'Production'
        'Test')
      ParentColor = False
      TabOrder = 4
      Visible = False
      OnClick = ProductionOrTestBoxClick
    end
    object PasswordBox2: TEdit
      Left = 402
      Top = 90
      Width = 73
      Height = 24
      PasswordChar = '*'
      TabOrder = 5
      Text = 'PasswordBox'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 224
    Width = 745
    Height = 89
    TabOrder = 4
    object Label1: TLabel
      Left = 24
      Top = 32
      Width = 198
      Height = 16
      Caption = 'EFile On-line Plus Batch file folder'
    end
    object Label4: TLabel
      Left = 257
      Top = 52
      Width = 424
      Height = 15
      Caption = 
        '(Folder where transmission files are created and acknowledgments' +
        ' received)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 472
      Top = 91
      Width = 3
      Height = 14
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 256
      Top = 10
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
      Left = 248
      Top = 24
      Width = 481
      Height = 24
      TabOrder = 0
    end
  end
end
