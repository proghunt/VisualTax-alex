object GridForm: TGridForm
  Left = 188
  Top = 161
  Caption = 'Table'
  ClientHeight = 265
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 33
    Width = 419
    Height = 232
    Align = alClient
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 419
    Height = 33
    Align = alTop
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 118
      Top = 4
      Width = 67
      Height = 25
      Caption = 'Fields...'
      OnClick = SpeedButton1Click
    end
    object DBNavigator1: TDBNavigator
      Left = 4
      Top = 4
      Width = 104
      Height = 25
      DataSource = DataSource1
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      TabOrder = 0
    end
    object ComboBox1: TComboBox
      Left = 192
      Top = 4
      Width = 145
      Height = 21
      Style = csDropDownList
      Sorted = True
      TabOrder = 1
      OnChange = ComboBox1Change
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 336
    Top = 208
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 333
    Top = 169
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 372
    Top = 168
  end
end
