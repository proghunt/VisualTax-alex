object FPFINDT1_2026: TFPFINDT1_2026
  Left = 79
  Top = 94
  Caption = 'Client Data Base - Financial Services'
  ClientHeight = 433
  ClientWidth = 703
  Color = 16777183
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object ClearBtn: TBitBtn
    Left = 23
    Top = 376
    Width = 154
    Height = 25
    Caption = 'Clear conditions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnClick = ClearBtnClick
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 703
    Height = 33
    Align = alTop
    Caption = 'Financial Planning Assistance - Search'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 703
    Height = 32
    Align = alTop
    Color = 14811135
    TabOrder = 2
    object Label15: TLabel
      Left = 16
      Top = 8
      Width = 484
      Height = 15
      Caption = 
        'This utility allows you to analyse the clients based on the fina' +
        'ncial services they accepted'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 192
    Top = 368
    Width = 89
    Height = 41
    TabOrder = 3
    Visible = False
    object Label2: TLabel
      Left = 32
      Top = 32
      Width = 54
      Height = 14
      Caption = 'Form Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 104
      Top = 32
      Width = 41
      Height = 14
      Caption = 'Field No.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 248
      Top = 32
      Width = 44
      Height = 14
      Caption = 'Condition'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 312
      Top = 32
      Width = 27
      Height = 14
      Caption = 'Value'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 96
      Width = 18
      Height = 14
      Caption = 'and'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 8
      Top = 128
      Width = 18
      Height = 14
      Caption = 'and'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 8
      Top = 152
      Width = 18
      Height = 14
      Caption = 'and'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 176
      Top = 24
      Width = 37
      Height = 14
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 168
      Top = 40
      Width = 61
      Height = 14
      Caption = 'or Character'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 95
      Top = 8
      Width = 226
      Height = 16
      Caption = 'Enter up to four Filtering Conditions'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Frm1: TEdit
      Left = 32
      Top = 56
      Width = 57
      Height = 22
      Hint = 'Enter valid form as per List'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object Fld1: TEdit
      Left = 104
      Top = 56
      Width = 41
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      TabOrder = 1
    end
    object Condition1: TComboBox
      Left = 256
      Top = 56
      Width = 41
      Height = 24
      Hint = 'Click to select conditional operator'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Items.Strings = (
        '>'
        '<'
        '='
        '>='
        '<=')
    end
    object Value1: TEdit
      Left = 304
      Top = 56
      Width = 113
      Height = 22
      Hint = 
        'If field is a dollar amount enter as number with no decimals i.e' +
        '. 32000.56, If Character enter any text'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object Frm2: TEdit
      Left = 32
      Top = 88
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object Fld2: TEdit
      Left = 104
      Top = 88
      Width = 41
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      TabOrder = 5
    end
    object Condition2: TComboBox
      Left = 256
      Top = 88
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Items.Strings = (
        '>'
        '<'
        '='
        '>='
        '<=')
    end
    object Value2: TEdit
      Left = 304
      Top = 88
      Width = 113
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object Frm3: TEdit
      Left = 32
      Top = 120
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object Fld3: TEdit
      Left = 104
      Top = 120
      Width = 41
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      TabOrder = 9
    end
    object Condition3: TComboBox
      Left = 256
      Top = 120
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      Items.Strings = (
        '>'
        '<'
        '='
        '>='
        '<=')
    end
    object Value3: TEdit
      Left = 304
      Top = 120
      Width = 113
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
    end
    object Frm4: TEdit
      Left = 32
      Top = 152
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
    end
    object Fld4: TEdit
      Left = 104
      Top = 152
      Width = 41
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      TabOrder = 13
    end
    object Condition4: TComboBox
      Left = 256
      Top = 152
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      Items.Strings = (
        '>'
        '<'
        '='
        '>='
        '<=')
    end
    object Value4: TEdit
      Left = 304
      Top = 152
      Width = 113
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
    end
    object FldType1: TComboBox
      Left = 170
      Top = 56
      Width = 71
      Height = 22
      Hint = 'Click to select'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      Items.Strings = (
        'Amount'
        'Character')
    end
    object FldType2: TComboBox
      Left = 170
      Top = 88
      Width = 71
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
    end
    object FldType3: TComboBox
      Left = 170
      Top = 120
      Width = 71
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 18
    end
    object FldType4: TComboBox
      Left = 170
      Top = 152
      Width = 71
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 19
    end
  end
  object Panel3: TPanel
    Left = 248
    Top = 72
    Width = 449
    Height = 297
    TabOrder = 4
    object doing: TLabel
      Left = 68
      Top = 275
      Width = 317
      Height = 14
      AutoSize = False
      Caption = 'Doing'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Left = 160
      Top = 3
      Width = 76
      Height = 14
      Caption = 'Data Directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DataDirBox: TEdit
      Left = 112
      Top = 20
      Width = 169
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'DataDirBox'
      OnExit = DataDirBoxExit
      OnKeyPress = DataDirBoxKeyPress
    end
    object ListBox1: TListBox
      Left = 144
      Top = 48
      Width = 113
      Height = 217
      TabOrder = 1
    end
  end
  object ServiceGroup: TRadioGroup
    Left = 8
    Top = 72
    Width = 233
    Height = 297
    Caption = 'Services accepted by client'
    Color = 14942207
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'Mortgage Insurance'
      'RESP/Life Insurance'
      'RRSP Planning'
      'RRSP Contributions'
      'Employer Pension Plan'
      'Life Insurance'
      'Investments Review'
      'Retiring Allowances review'
      'Disability Insurance'
      'Insurance for not disabled member'
      'Large Gifts'
      'Tax Shelters')
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    OnClick = ServiceGroupClick
  end
  object FindBtn: TBitBtn
    Left = 304
    Top = 376
    Width = 89
    Height = 33
    Hint = 'Click to proceed'
    Caption = 'Find'
    Glyph.Data = {
      46060000424D4606000000000000360400002800000018000000160000000100
      0800000000001002000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
      A4003F3F5F003F3F7F003F3F9F003F3FBF003F3FDF003F3FFF003F5F3F003F5F
      5F003F5F7F003F5F9F003F5FBF003F5FDF003F5FFF003F7F3F003F7F5F003F7F
      7F003F7F9F003F7FBF003F7FDF003F7FFF003F9F3F003F9F5F003F9F7F003F9F
      9F003F9FBF003F9FDF003F9FFF003FBF3F003FBF5F003FBF7F003FBF9F003FBF
      BF003FBFDF003FBFFF003FDF3F003FDF5F003FDF7F003FDF9F003FDFBF003FDF
      DF003FDFFF003FFF3F003FFF5F003FFF7F003FFF9F003FFFBF003FFFDF003FFF
      FF005F3F3F005F3F5F005F3F7F005F3F9F005F3FBF005F3FDF005F3FFF005F5F
      3F005F5F5F005F5F7F005F5F9F005F5FBF005F5FDF005F5FFF005F7F3F005F7F
      5F005F7F7F005F7F9F005F7FBF005F7FDF005F7FFF005F9F3F005F9F5F005F9F
      7F005F9F9F005F9FBF005F9FDF005F9FFF005FBF3F005FBF5F005FBF7F005FBF
      9F005FBFBF005FBFDF005FBFFF005FDF3F005FDF5F005FDF7F005FDF9F005FDF
      BF005FDFDF005FDFFF005FFF3F005FFF5F005FFF7F005FFF9F005FFFBF005FFF
      DF005FFFFF007F3F3F007F3F5F007F3F7F007F3F9F007F3FBF007F3FDF007F3F
      FF007F5F3F007F5F5F007F5F7F007F5F9F007F5FBF007F5FDF007F5FFF007F7F
      3F007F7F5F007F7F7F007F7F9F007F7FBF007F7FDF007F7FFF007F9F3F007F9F
      5F007F9F7F007F9F9F007F9FBF007F9FDF007F9FFF007FBF3F007FBF5F007FBF
      7F007FBF9F007FBFBF007FBFDF007FBFFF007FDF3F007FDF5F007FDF7F007FDF
      9F007FDFBF007FDFDF007FDFFF007FFF3F007FFF5F007FFF7F007FFF9F007FFF
      BF007FFFDF007FFFFF009F3F3F009F3F5F009F3F7F009F3F9F009F3FBF009F3F
      DF009F3FFF009F5F3F009F5F5F009F5F7F009F5F9F009F5FBF009F5FDF009F5F
      FF009F7F3F009F7F5F009F7F7F009F7F9F009F7FBF009F7FDF009F7FFF009F9F
      3F009F9F5F009F9F7F009F9F9F009F9FBF009F9FDF009F9FFF009FBF3F009FBF
      5F009FBF7F009FBF9F009FBFBF009FBFDF009FBFFF009FDF3F009FDF5F009FDF
      7F009FDF9F009FDFBF009FDFDF009FDFFF009FFF3F009FFF5F009FFF7F009FFF
      9F009FFFBF009FFFDF009FFFFF00BF3F3F00BF3F5F00BF3F7F00BF3F9F00BF3F
      BF00BF3FDF00BF3FFF00BF5F3F00BF5F5F00BF5F7F00BF5F9F00BF5FBF00BF5F
      DF00BF5FFF00BF7F3F00BF7F5F00BF7F7F00BF7F9F00BF7FBF00BF7FDF00BF7F
      FF00BF9F3F00BF9F5F00BF9F7F00BF9F9F00BF9FBF00BF9FDF00BF9FFF00BFBF
      3F00BFBF5F00BFBF7F00BFBF9F00BFBFBF00BFBFDF00BFBFFF00BFDF3F00BFDF
      5F00BFDF7F00BFDF9F00BFDFBF00BFDFDF00F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
      0707070707070707070707070707070707070707070707070707070707070707
      0707070707070707070707070707070707070707070707070707070707070707
      0707070707070707070707070707070707070707070707070707070707070707
      0707070700000007070707070000000707070707070707070707070700070007
      0707070700070007070707070707070707070707000000F80707077B00000007
      0707070707070707070707070000000000000000000000070707070707070707
      0707070700070000000007000000000707070707070707070707070700070000
      00000700000000070707070707F8000000000000000000000000000000000007
      070707070700FEFEFEFEFEFE00000000007B000000000707070707070700FEFE
      FEFEFEFEFEFE0000FE00070000070707070707070700FEFEFEFEFEFEFEFE0000
      FE00070000070707070707070700FEFEFEFEFEFEFEFE0000FE00070000070707
      070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707070707070700FEFE
      FEFEFEFEFEFEFEFEFE00070707070707070707070700FEFEFEFEFEFEFEFEFEFE
      FE00000707070707070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707
      0707070707000000FEFEFE000000000000F80707070707070707070707070700
      0000000707070707070707070707070707070707070707070707070707070707
      07070707070707070707}
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = FindBtnClick
  end
  object BitBtn1: TBitBtn
    Left = 424
    Top = 376
    Width = 89
    Height = 33
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 7
    OnClick = BitBtn1Click
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 584
    Top = 32
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 593
    Top = 97
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 632
    Top = 96
  end
end
