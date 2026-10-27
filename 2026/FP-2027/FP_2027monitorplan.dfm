object MonitorPlan: TMonitorPlan
  Left = 144
  Top = 94
  Caption = 'Monitor plan performance'
  ClientHeight = 393
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 567
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = '6 - Performance Review'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 33
    Width = 567
    Height = 360
    Align = alClient
    Color = 14933196
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'The Financial Planner and Client should meet periodically to rev' +
        'iew the performance of the Financial'
      'Planning recommendations.'
      ''
      
        'Specifically, performance of investments should be reviewed at l' +
        'east once a year to determine'
      
        'deviations from the plan and arrive at a new course of action if' +
        ' necessary.'
      ''
      
        'The Visual FP program provides facilities to update the financia' +
        'l position of the client based on latest '
      'prices of the various investments.'
      '')
    ParentFont = False
    TabOrder = 1
  end
end
