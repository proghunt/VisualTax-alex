object ReportMenuT2_2027: TReportMenuT2_2027
  Left = 188
  Top = 99
  Caption = 'ReportMenuT2_2027'
  ClientHeight = 206
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Preview: TButton
    Left = 28
    Top = 172
    Width = 89
    Height = 29
    Caption = 'P&review'
    TabOrder = 0
    OnClick = PreviewClick
  end
  object Print: TButton
    Left = 140
    Top = 172
    Width = 89
    Height = 29
    Caption = '&Print'
    TabOrder = 1
    OnClick = PreviewClick
  end
  object Exit: TButton
    Left = 248
    Top = 172
    Width = 89
    Height = 29
    Caption = 'E&xit'
    TabOrder = 2
    OnClick = ExitClick
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 10
    Width = 349
    Height = 135
    Caption = 'Select report'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    object ClientList: TRadioButton
      Left = 12
      Top = 20
      Width = 193
      Height = 17
      Caption = 'Client List'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 159
    Top = 67
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 239
    Top = 66
  end
end
