object DirOptT2_2027: TDirOptT2_2027
  Left = 99
  Top = 140
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Data Directories'
  ClientHeight = 385
  ClientWidth = 754
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 754
    Height = 360
    Align = alClient
    BevelWidth = 2
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 0
    object Label13: TLabel
      Left = 552
      Top = 104
      Width = 98
      Height = 13
      Margins.Bottom = 2
      Caption = 'Floppy examples:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 557
      Top = 120
      Width = 44
      Height = 13
      Margins.Bottom = 2
      Caption = 'A:\DATA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 552
      Top = 24
      Width = 117
      Height = 13
      Margins.Bottom = 2
      Caption = 'Hard Disk examples:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 362
      Top = 64
      Width = 3
      Height = 12
      Margins.Bottom = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 658
      Top = 56
      Width = 74
      Height = 13
      Margins.Bottom = 2
      Caption = 'C:\xxxxx\DATA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 554
      Top = 56
      Width = 69
      Height = 13
      Margins.Bottom = 2
      Caption = 'C:\T1DATA04'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 557
      Top = 136
      Width = 44
      Height = 13
      Margins.Bottom = 2
      Caption = 'B:\DATA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label19: TLabel
      Left = 658
      Top = 40
      Width = 70
      Height = 13
      Margins.Bottom = 2
      Caption = 'D:\T1DATA04'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label22: TLabel
      Left = 554
      Top = 40
      Width = 89
      Height = 13
      Margins.Bottom = 2
      Caption = 'C:\T1-2004\DATA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 550
      Top = 184
      Width = 154
      Height = 75
      Margins.Bottom = 2
      Caption = 
        '- In the Multi-Office version of the program the Default directo' +
        'ry needs also to be defined in Configure | Multi-user for each u' +
        'ser'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label12: TLabel
      Left = 554
      Top = 72
      Width = 75
      Height = 13
      Margins.Bottom = 2
      Caption = 'G:\xxxxx\DATA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 554
      Top = 88
      Width = 180
      Height = 13
      Margins.Bottom = 2
      Caption = 'C:\VTData04   (for T1 Limited version)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 2
      Width = 527
      Height = 352
      Align = alLeft
      Color = 13353654
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 29
        Top = 40
        Width = 97
        Height = 13
        Margins.Bottom = 2
        Caption = 'Current Directory'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 29
        Top = 72
        Width = 97
        Height = 13
        Margins.Bottom = 2
        Caption = 'Default Directory'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Prior1Lbl: TLabel
        Left = 13
        Top = 176
        Width = 51
        Height = 13
        Margins.Bottom = 2
        Caption = 'Prior1Lbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 13
        Top = 312
        Width = 103
        Height = 13
        Margins.Bottom = 2
        Caption = 'Samples Directory'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label8: TLabel
        Left = 197
        Top = 56
        Width = 153
        Height = 15
        Margins.Bottom = 2
        Caption = '(To be used in this session)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 165
        Top = 88
        Width = 305
        Height = 15
        Margins.Bottom = 2
        Caption = '(To be used at start-up time. Normally same as current) '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 197
        Top = 104
        Width = 3
        Height = 15
        Margins.Bottom = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Prior2Lbl: TLabel
        Left = 13
        Top = 200
        Width = 51
        Height = 13
        Margins.Bottom = 2
        Caption = 'Prior2Lbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label5: TLabel
        Left = 96
        Top = 152
        Width = 366
        Height = 16
        Margins.Bottom = 2
        Caption = 'For proper Rollover, enter last year'#39's data directory *'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel1: TBevel
        Left = 8
        Top = 128
        Width = 497
        Height = 1
      end
      object Label24: TLabel
        Left = 176
        Top = 16
        Width = 178
        Height = 16
        Margins.Bottom = 2
        Caption = 'Required data directories'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label21: TLabel
        Left = 21
        Top = 272
        Width = 365
        Height = 13
        Margins.Bottom = 2
        Caption = 
          ' * If not in VisualTax last year, enter the data directory you u' +
          'sed'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Prior3Lbl: TLabel
        Left = 13
        Top = 216
        Width = 51
        Height = 13
        Margins.Bottom = 2
        Caption = 'Prior3Lbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Prior4Lbl: TLabel
        Left = 13
        Top = 232
        Width = 51
        Height = 13
        Margins.Bottom = 2
        Caption = 'Prior4Lbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label3: TLabel
        Left = 13
        Top = 16
        Width = 5
        Height = 13
        Margins.Bottom = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CurDirLbl: TLabel
        Left = 13
        Top = 16
        Width = 53
        Height = 13
        Margins.Bottom = 2
        Caption = 'CurDirLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CurDir: TDBEdit
        Left = 136
        Top = 40
        Width = 313
        Height = 13
        BorderStyle = bsNone
        DataField = 'DIR_CUR'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DefaultDir: TDBEdit
        Left = 136
        Top = 72
        Width = 313
        Height = 13
        BorderStyle = bsNone
        DataField = 'DIR_DEFLT'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object LastYrDir: TDBEdit
        Left = 80
        Top = 176
        Width = 369
        Height = 13
        BorderStyle = bsNone
        DataField = 'DIR_LASTYR'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object SampleDir: TDBEdit
        Left = 168
        Top = 304
        Width = 169
        Height = 13
        BorderStyle = bsNone
        DataField = 'DIR_SAMPLE'
        DataSource = DataSource1
        TabOrder = 6
        Visible = False
      end
      object PrvLYr: TDBEdit
        Left = 80
        Top = 200
        Width = 369
        Height = 13
        BorderStyle = bsNone
        DataField = 'DIR_PRVLYR'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Visible = False
      end
      object SelectCurBtn: TBitBtn
        Left = 464
        Top = 40
        Width = 49
        Height = 16
        Hint = 'Click if directory already exists'
        Caption = 'Select...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = SelectCurBtnClick
      end
      object SelectDefBtn: TBitBtn
        Left = 462
        Top = 72
        Width = 51
        Height = 16
        Hint = 'Click if directory already exists'
        Caption = 'Select...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = SelectDefBtnClick
      end
      object SelectL1Btn: TBitBtn
        Left = 462
        Top = 176
        Width = 51
        Height = 16
        Caption = 'Select...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        OnClick = SelectL1BtnClick
      end
      object SelectL2btn: TBitBtn
        Left = 462
        Top = 200
        Width = 51
        Height = 16
        Caption = 'Select...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
        Visible = False
        OnClick = SelectL2btnClick
      end
      object SelectLast3Btn: TBitBtn
        Left = 358
        Top = 295
        Width = 49
        Height = 25
        Caption = 'Select...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
        Visible = False
        OnClick = SelectLast3BtnClick
      end
      object SelectL3Btn: TBitBtn
        Left = 462
        Top = 216
        Width = 51
        Height = 16
        Caption = 'Select...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        Visible = False
        OnClick = SelectL3BtnClick
      end
      object SelectL4Btn: TBitBtn
        Left = 462
        Top = 232
        Width = 51
        Height = 16
        Caption = 'Select...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
        Visible = False
        OnClick = SelectL4BtnClick
      end
      object L3Yr: TEdit
        Left = 80
        Top = 216
        Width = 369
        Height = 13
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        Visible = False
      end
      object L4Yr: TEdit
        Left = 80
        Top = 232
        Width = 369
        Height = 13
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Visible = False
      end
    end
    object SaveBtn: TBitBtn
      Left = 584
      Top = 256
      Width = 81
      Height = 33
      Caption = 'Save'
      Default = True
      Glyph.Data = {
        56020000424D5602000000000000760000002800000024000000180000000100
        040000000000E001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888880000888888888888888888888888888888888888
        0000888888888888888884444444444444444488000088888888808888884444
        4444444444444448000088888888800888884444444444444444444800008888
        000000B088884444447788888444444800008888000000B088884444447888FF
        F444444800008880000000BB08884444447878888444444800008880BBBBBBBB
        B0884444447777777444444800008880BBBBBBBBBB0844444444444444444448
        00008880BBBBBBBBBBF04444444444444444444800008880BBBBBBBBBB084444
        444444444444444800008880BBBBBBBBB0884444FFFFFFFFFFF4444800008880
        000000BB08884444FFFFFFFFFFF4444800008888888880B088884444FFFFFFFF
        FFF44448000088888888800888884444FFFFFFFFFFF444480000888888888088
        88884444FFFFFFFFFFF44448000088888888888888884444FFFFFFFFFFF44448
        000088888888888888884444FFFFFFFFFFF44448000088888888888888884C4C
        0C4C4C4C4C4C4C48000088888888888888884444444444444444444800008888
        8888888888888888888888888888888800008888888888888888888888888888
        8888888800008888888888888888888888888888888888880000}
      TabOrder = 1
      OnClick = SaveBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 584
      Top = 320
      Width = 81
      Height = 33
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 2
      OnClick = CancelBtnClick
    end
    object BitBtn1: TBitBtn
      Left = 584
      Top = 288
      Width = 81
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 3
      OnClick = BitBtn1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 754
    Height = 25
    Align = alTop
    Caption = 'Data directories'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 624
    Top = 176
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Path=c:\t1\T1Cfg.Db')
    Left = 639
    Top = 112
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'T1Cfg'
    TableName = 'T1Cfg'
    Left = 671
    Top = 96
  end
end
