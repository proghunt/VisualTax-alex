object DeskTopT1_2026: TDeskTopT1_2026
  Left = 140
  Top = 101
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Operational Options'
  ClientHeight = 297
  ClientWidth = 510
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 510
    Height = 297
    Align = alClient
    Color = 13353654
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 266
      Width = 441
      Height = 16
      Caption = 
        'Disclaimer above signature on Page 4 (Leave it blank, if not req' +
        'uired)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 136
      Width = 369
      Height = 121
      Caption = ' Printing  '
      Color = 13353654
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
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
        Caption = 'In client letters:'
      end
      object Label3: TLabel
        Left = 16
        Top = 20
        Width = 118
        Height = 16
        Caption = 'In tax forms, print:'
      end
      object Label4: TLabel
        Left = 160
        Top = 68
        Width = 158
        Height = 13
        Caption = 'Number of lines reserved for logo:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object DBCheckBox1: TDBCheckBox
        Left = 16
        Top = 40
        Width = 110
        Height = 17
        Caption = 'Name on Headings'
        DataField = 'PRN_NAMEH'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DBCheckBox2: TDBCheckBox
        Left = 16
        Top = 56
        Width = 110
        Height = 17
        Caption = 'SIN on Headings'
        DataField = 'PRN_SINH'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object DBCheckBox3: TDBCheckBox
        Left = 16
        Top = 72
        Width = 110
        Height = 17
        Caption = 'Date on Headings'
        DataField = 'PRN_DATEH'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object DBCheckBox4: TDBCheckBox
        Left = 16
        Top = 96
        Width = 201
        Height = 17
        Caption = 'Field Shading (Not allowed by CCRA)'
        DataField = 'PRN_SHADE'
        DataSource = DataSource1
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
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
        Font.Height = -11
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
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 32
      Width = 489
      Height = 97
      Caption = 'Calculations and Display'
      Color = 13353654
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      object DBCheckBox6: TDBCheckBox
        Left = 8
        Top = 24
        Width = 465
        Height = 17
        Caption = 
          'If checked the Esc key goes to Tax Summary, otherwise Esc goes t' +
          'o the previous form'
        DataField = 'OPR_CLOSE'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DBCheckBox5: TDBCheckBox
        Left = 8
        Top = 40
        Width = 465
        Height = 17
        Caption = 
          'If checked, the Elections Canada question on Page 1, defaults to' +
          ' Yes for new returns'
        DataField = 'PRP_ELECT'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object DBCheckBox8: TDBCheckBox
        Left = 8
        Top = 56
        Width = 465
        Height = 17
        Caption = 
          'If checked, the Representation question in T183, defaults to Yes' +
          ' for new returns'
        DataField = 'PRP_EFREPR'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object DBCheckBox9: TDBCheckBox
        Left = 8
        Top = 72
        Width = 473
        Height = 17
        Caption = 
          'If checked, the program will automatically fill Signature dates ' +
          'with today'#39's date in all relevant forms'
        DataField = 'PRP_DATES'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object DBEdit1: TDBEdit
      Left = 15
      Top = 281
      Width = 466
      Height = 14
      BorderStyle = bsNone
      DataField = 'PRN_DISCLM'
      DataSource = DataSource1
      TabOrder = 2
    end
    object SaveBtn: TBitBtn
      Left = 400
      Top = 142
      Width = 104
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
      Left = 400
      Top = 190
      Width = 105
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 4
      OnClick = CancelBtnClick
    end
    object BitBtn1: TBitBtn
      Left = 400
      Top = 232
      Width = 105
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 5
      OnClick = BitBtn1Click
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 508
      Height = 25
      Align = alTop
      Caption = 'Operational Options'
      Color = 11301888
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12971774
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 455
    Top = 77
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=c:\t1\t1cfg.db')
    Left = 455
    Top = 40
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 't1cfg'
    TableName = 't1cfg'
    Left = 455
    Top = 65533
  end
end
