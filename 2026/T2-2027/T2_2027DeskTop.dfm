object DeskTopT2_2027: TDeskTopT2_2027
  Left = 92
  Top = 88
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Operational Options'
  ClientHeight = 279
  ClientWidth = 509
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 509
    Height = 279
    Align = alClient
    BorderStyle = bsSingle
    Color = 13353654
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 226
      Width = 182
      Height = 13
      Margins.Bottom = 2
      Caption = 'Disclaimer above signature on Page 8:'
      Visible = False
    end
    object GroupBox1: TGroupBox
      Left = 24
      Top = 96
      Width = 369
      Height = 121
      Caption = ' Printing  '
      Color = 13353654
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      object Label2: TLabel
        Left = 160
        Top = 20
        Width = 100
        Height = 16
        Margins.Bottom = 2
        Caption = 'In client letters:'
      end
      object Label3: TLabel
        Left = 16
        Top = 20
        Width = 118
        Height = 16
        Margins.Bottom = 2
        Caption = 'In tax forms, print:'
      end
      object Label4: TLabel
        Left = 160
        Top = 68
        Width = 158
        Height = 13
        Margins.Bottom = 2
        Caption = 'Number of lines reserved for logo:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object DBCheckBox1: TDBCheckBox
        Left = 16
        Top = 88
        Width = 110
        Height = 17
        Caption = 'Name on Headings'
        DataField = 'PRN_NAMEH'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Visible = False
      end
      object DBCheckBox2: TDBCheckBox
        Left = 8
        Top = 88
        Width = 110
        Height = 17
        Caption = 'SIN on Headings'
        DataField = 'PRN_SINH'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
      end
      object DBCheckBox3: TDBCheckBox
        Left = 24
        Top = 88
        Width = 110
        Height = 17
        Caption = 'Date on Headings'
        DataField = 'PRN_DATEH'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Visible = False
      end
      object DBCheckBox4: TDBCheckBox
        Left = 24
        Top = 40
        Width = 97
        Height = 17
        Caption = 'Field Shading'
        DataField = 'PRN_SHADE'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object DBCheckBox7: TDBCheckBox
        Left = 160
        Top = 40
        Width = 185
        Height = 17
        Caption = 'Use your Logo in Letter'
        DataField = 'PRN_LOGO'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object DBEdit2: TDBEdit
        Left = 320
        Top = 64
        Width = 25
        Height = 21
        DataField = 'PRN_LOGOLN'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
    end
    object GroupBox2: TGroupBox
      Left = 24
      Top = 16
      Width = 497
      Height = 65
      Caption = 'Display and  Calculations'
      Color = 13353654
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      object Label5: TLabel
        Left = 24
        Top = 44
        Width = 242
        Height = 13
        Margins.Bottom = 2
        Caption = 'If not checked, the Esc returns to the previous form'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object DBCheckBox6: TDBCheckBox
        Left = 8
        Top = 24
        Width = 465
        Height = 17
        Caption = 'Show Tax Summary upon Escape'
        Color = 13353654
        DataField = 'OPR_CLOSE'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object DBEdit1: TDBEdit
      Left = 31
      Top = 241
      Width = 362
      Height = 14
      BorderStyle = bsNone
      DataField = 'PRN_DISCLM'
      DataSource = DataSource1
      TabOrder = 2
      Visible = False
    end
    object SaveBtn: TBitBtn
      Left = 407
      Top = 94
      Width = 89
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
      ModalResult = 1
      TabOrder = 3
      OnClick = SaveBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 407
      Top = 134
      Width = 89
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 4
      OnClick = CancelBtnClick
    end
    object BitBtn1: TBitBtn
      Left = 408
      Top = 176
      Width = 89
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 5
      OnClick = BitBtn1Click
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 447
    Top = 205
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 't1cfg'
    TableName = 't1cfg'
    Left = 455
    Top = 65533
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=c:\t1\t1cfg.db')
    Left = 455
    Top = 40
  end
end
