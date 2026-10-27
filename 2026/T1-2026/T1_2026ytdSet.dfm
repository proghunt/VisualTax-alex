object YTDSetUpT1_2026: TYTDSetUpT1_2026
  Left = 37
  Top = 33
  Caption = 'YTD set-up'
  ClientHeight = 340
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 64
    Top = 248
    Width = 121
    Height = 16
    Caption = 'YTD Cash Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 24
    Width = 177
    Height = 16
    Caption = 'Daily cash reports  directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 48
    Width = 547
    Height = 16
    Caption = 
      'This directory contains all daily cash reports from all tax prep' +
      'arers (agents) of an Office or H.O.'
  end
  object Label4: TLabel
    Left = 8
    Top = 64
    Width = 442
    Height = 16
    Caption = 
      'The name of the cash reports have the general name LLLLnnnn.MDD ' +
      ' where:'
  end
  object Label5: TLabel
    Left = 8
    Top = 80
    Width = 362
    Height = 16
    Caption = 
      'LLLL is the tax preparer'#39's office location (i.e. WHIT for Whitby' +
      ' )'
  end
  object Label6: TLabel
    Left = 8
    Top = 96
    Width = 293
    Height = 16
    Caption = 'nnnn is a unique four digit preparer code (i.e. 0001)'
  end
  object Label7: TLabel
    Left = 8
    Top = 112
    Width = 355
    Height = 16
    Caption = 'M = Month of the cash report (A=Jan, B=Feb, C=March, etc).'
  end
  object Label8: TLabel
    Left = 8
    Top = 128
    Width = 302
    Height = 16
    Caption = 'DD = the day for which the cash report is referring to'
  end
  object Label9: TLabel
    Left = 72
    Top = 152
    Width = 477
    Height = 16
    Caption = 
      'File name WHIT0001.A12 is the cash report for Agent 0001 located' +
      ' in Whitby, Ont.'
  end
  object Label10: TLabel
    Left = 72
    Top = 168
    Width = 81
    Height = 16
    Caption = 'for Janyary 12'
  end
  object Label11: TLabel
    Left = 8
    Top = 152
    Width = 60
    Height = 16
    Caption = 'Example:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label12: TLabel
    Left = 8
    Top = 184
    Width = 520
    Height = 16
    Caption = 
      'Daily Cash report files are collected daily. For local operators' +
      ' the files can be copied using'
  end
  object Label13: TLabel
    Left = 8
    Top = 216
    Width = 433
    Height = 16
    Caption = 
      'Preparers from remote locations submit their daily cash reports ' +
      'by modem.'
  end
  object Label14: TLabel
    Left = 8
    Top = 272
    Width = 543
    Height = 16
    Caption = 
      'This directory contains the consolidated YTD cash data from all ' +
      'preparers of the Office or H.O.'
  end
  object Label15: TLabel
    Left = 8
    Top = 200
    Width = 288
    Height = 16
    Caption = 'the Copy Daily Cash report facility of the program.'
  end
  object Label16: TLabel
    Left = 160
    Top = 0
    Width = 260
    Height = 16
    Caption = 'FOR OFFICE AND H.O. ADMINISTRATORS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object YtdDirBox: TEdit
    Left = 200
    Top = 240
    Width = 265
    Height = 24
    TabOrder = 0
  end
  object DayDirBox: TEdit
    Left = 200
    Top = 24
    Width = 265
    Height = 24
    TabOrder = 1
  end
  object CancelBtn: TBitBtn
    Left = 304
    Top = 304
    Width = 89
    Height = 33
    Caption = 'Exit'
    ModalResult = 2
    TabOrder = 2
  end
  object SaveBtn: TBitBtn
    Left = 192
    Top = 304
    Width = 89
    Height = 33
    Caption = 'Save'
    TabOrder = 3
    OnClick = SaveBtnClick
  end
end
