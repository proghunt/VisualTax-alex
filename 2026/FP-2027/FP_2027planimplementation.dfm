object PlanImplementation: TPlanImplementation
  Left = 129
  Top = 121
  Caption = 'Implementation and Order Processing'
  ClientHeight = 378
  ClientWidth = 583
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
    Width = 583
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = '5 - Implementation and Transactions'
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
    Width = 583
    Height = 345
    Align = alClient
    Color = 14933196
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'In this phase of the process the Financial Planner or Agent acts' +
        ' on the various recommendations that'
      
        'came up during the Strategies and Planns phase and/or the portfo' +
        'lio creator process.'
      ''
      
        'Facilities provided by the program are geared specifically to ha' +
        'ndling Mutual Fund orders. The'
      
        'recommended investment portfolio can be converted to Mutual Fund' +
        ' orders. Mutual Fund Agents will be '
      'transmitting the orders to their'
      
        'Mutual Funds Dealer who in turn will interact with the Mutual Fu' +
        'nds Companies.'
      ''
      
        'The Mutual Fund Dealer must have our Visual FP - Back Office ver' +
        'sion of the program.'
      ''
      
        'Mutual Fund transactions can be created on demand, without havin' +
        'g to first create an Investment Plan'
      'or a Mutual Funds Portfolio.'
      ' ')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
