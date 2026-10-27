object EOLSetUpT2_2027: TEOLSetUpT2_2027
  Left = 482
  Top = 228
  Caption = 'CIF SetUp'
  ClientHeight = 448
  ClientWidth = 726
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
  object Label3: TLabel
    Left = 14
    Top = 42
    Width = 487
    Height = 16
    Caption = 
      'Note: If you do not have a EFile On-line number but you have a W' +
      'AC number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 56
    Top = 84
    Width = 452
    Height = 16
    Caption = 
      'and enter the WAC number on page 1 of the T2 form of the corpora' +
      'tion.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 56
    Top = 63
    Width = 364
    Height = 16
    Caption = 'then leave the Efile number/password blank, click '#39'SAVE'#39' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object HeaderPanel: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 33
    Hint = 'Click to change tax year and rates'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Set-up Corporate Internet Filing (CIF)'
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
    Left = 396
    Top = 379
    Width = 105
    Height = 49
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object SaveBtn: TBitBtn
    Left = 239
    Top = 379
    Width = 105
    Height = 49
    Cancel = True
    Caption = 'Save'
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    TabOrder = 2
    OnClick = SaveBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 108
    Width = 707
    Height = 117
    Caption = 'Provided by CRA (Or use your existing T1 Efile On-line number) '
    TabOrder = 3
    object Label16: TLabel
      Left = 80
      Top = 32
      Width = 117
      Height = 16
      Caption = 'Efile On-line number'
    end
    object Label17: TLabel
      Left = 145
      Top = 61
      Width = 57
      Height = 16
      Caption = 'Password'
    end
    object Label6: TLabel
      Left = 486
      Top = 67
      Width = 189
      Height = 12
      Caption = 'Corporate Internet Filing (CIF) Web Site URL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
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
      Top = 24
      Width = 65
      Height = 24
      CharCase = ecUpperCase
      TabOrder = 0
      Text = 'ONLINEBOX'
    end
    object PasswordBox: TEdit
      Left = 208
      Top = 54
      Width = 65
      Height = 24
      CharCase = ecUpperCase
      PasswordChar = '*'
      TabOrder = 1
      Text = 'PASSWORDBOX'
    end
    object URLBox: TEdit
      Left = 490
      Top = 83
      Width = 176
      Height = 24
      TabOrder = 2
      Visible = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 252
    Width = 707
    Height = 97
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 41
      Width = 55
      Height = 16
      Caption = 'CIF folder'
    end
    object Label4: TLabel
      Left = 82
      Top = 66
      Width = 464
      Height = 15
      Caption = 
        '(Folder where transmission data is stored temporarily before it ' +
        'is transmitted to CRA)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 82
      Top = 12
      Width = 157
      Height = 15
      Caption = 'Use a local drive and folder.  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object NetfileDirBox: TEdit
      Left = 80
      Top = 33
      Width = 569
      Height = 24
      TabOrder = 0
    end
  end
  object ProdOrTestBox: TRadioGroup
    Left = 532
    Top = 45
    Width = 183
    Height = 57
    Caption = 'Mode'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Production by  End User'
      'Developer only')
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 5
  end
end
