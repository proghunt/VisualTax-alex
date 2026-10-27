object FixDBLiteForm: TFixDBLiteForm
  Left = 174
  Top = 69
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Fix Data Base'
  ClientHeight = 749
  ClientWidth = 1025
  Color = 13353654
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object DBGrid1: TDBGrid
    Left = 0
    Top = 57
    Width = 1025
    Height = 614
    Align = alClient
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'System'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 57
    Align = alTop
    Color = 15532031
    TabOrder = 1
    object Label3: TLabel
      Left = 1
      Top = 1
      Width = 1023
      Height = 15
      Align = alTop
      Caption = 
        'The contents of this data base is critical for the operation of ' +
        'the program. Changes should be made carefully'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 589
    end
    object VariableLabel1: TvtLabel
      Left = 3
      Top = 21
      Width = 24
      Height = 15
      Caption = 'Var1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object VariableLabel2: TvtLabel
      Left = 1
      Top = 35
      Width = 24
      Height = 15
      Caption = 'Var2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
  end
  object TPanel
    Left = 0
    Top = 671
    Width = 1025
    Height = 78
    Align = alBottom
    Color = 13353654
    TabOrder = 2
    object SaveBtn: TBitBtn
      Left = 20
      Top = 38
      Width = 89
      Height = 33
      Caption = '&Save'
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
      TabOrder = 0
      OnClick = SaveBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 138
      Top = 38
      Width = 89
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object DBNavigator1: TDBNavigator
      Left = 1
      Top = 1
      Width = 1023
      Height = 25
      DataSource = DataSource1
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete]
      Align = alTop
      TabOrder = 2
    end
    object SortBy: TRadioGroup
      Left = 249
      Top = 30
      Width = 289
      Height = 41
      Caption = 'Sort &by:'
      Columns = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'Form Name'
        'Form Number'
        'Print Sequence')
      ParentFont = False
      TabOrder = 3
      OnClick = SortByClick
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 288
    Top = 261
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      '')
    Left = 81
    Top = 305
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 120
    Top = 304
  end
end
