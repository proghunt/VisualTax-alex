object InvoiceRepT1_2026: TInvoiceRepT1_2026
  Left = 53
  Top = 95
  Caption = 'InvoiceRepT1_2026'
  ClientHeight = 668
  ClientWidth = 653
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TvtRichMemo
    Left = 0
    Top = 0
    Width = 653
    Height = 668
    DrawEndPage = False
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 192
  end
  object EkRTF1: TEkRTF
    InFile = 'C:\InvoiceReport.rtf'
    OutFile = 'outfile.doc'
    TrueValue = 'True'
    FalseValue = 'False'
    UnicodeByDefault = True
    Charset = DEFAULT_CHARSET
    Lang = 0
    Options = [eoGraphicsBinary, eoDotAsColon]
    DisableControls = True
    Left = 272
    Top = 80
    VarDataTypes = {00000000}
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 104
    Top = 80
  end
  object Query1: TADQuery
    Connection = FDConnection
    Left = 168
    Top = 80
  end
end
