object ActionPlan: TActionPlan
  Left = 86
  Top = 63
  Caption = 'Action Plan'
  ClientHeight = 441
  ClientWidth = 619
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
  object RichEdit1: TRichEdit
    Left = -8
    Top = 33
    Width = 627
    Height = 408
    Align = alRight
    Color = 14933196
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'The Financial Planner in consultation with the Client arrive at ' +
        'the appropriate strategies and action plans. This '
      'may involve'
      
        'selling some assets or replacing certain investments with others' +
        ' that better fit the client profile and his/her'
      'objectives.'
      ''
      
        'Responsibility for carrying out a specific action is assigned to' +
        ' client or the Financial Planner.'
      ''
      
        'The program will automatically assign responsibility to the Fina' +
        'ncial Planner for all actions that require the '
      'handling of Mutual Funds.'
      ''
      
        'The impact of the action plan is reflected on the automatically ' +
        'prepared Net Worth Statement and the various '
      'retirement projections.'
      
        'Specific purchases or sales of existing investments can be enter' +
        'ed by the Financial Planner for documentation '
      'purposes and follow-up.'
      ''
      '4.1 Portfolio Creator'
      
        'The program provides facilities to build several investment port' +
        'folios for a given client, such as RRSP, or Non-'
      
        'RRSP. Each portfolio should be given a unique name to reflect it' +
        's type and purpose and/or the date it was build.'
      
        'One of the portfolios should be given the status of '#8216'Active'#8217'. Ob' +
        'solete portfolios should be deleted or classified as'
      
        #8216'Inactive'#8217'.Once a portfolio has been created, the total amount o' +
        'f investment should be entered against it. The'
      
        'program provides facilities to select the funds comprising the p' +
        'ortfolio and their percentage of the total '
      
        'investment portfolio amount. Historical performance of each fund' +
        ' can be viewed on the screen as well as'
      'projected performance for the total portfolio.'
      ''
      
        'A portfolio, if agreed by the client can be converted to Mutual ' +
        'Funds orders.'
      ''
      ' ')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 619
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = '4 - Strategies and Plans'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
end
