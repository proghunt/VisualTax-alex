object Analysis: TAnalysis
  Left = 130
  Top = 107
  Caption = 'Analysis of current position'
  ClientHeight = 419
  ClientWidth = 594
  Color = 14942207
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
    Width = 594
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = '3 - Projections and Assessment'
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
    Width = 594
    Height = 386
    Align = alClient
    Color = 14933196
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'Normally this step is done by the Financial Planner on his own b' +
        'y analyzing the Balance sheet, Income,'
      
        'Expenses, client Objectives/Risk tolerance and the Disposable In' +
        'come.'
      ''
      
        'The problems are classified and documented in general terms such' +
        ' as cash flow problem, poor'
      'investments, inadequate insurance, etc.'
      
        'The Financial Planner will determine how much of the disposable ' +
        'income should be used for debt '
      'reduction, insurance or investments.'
      'The dispsable income is calculated in the Cash Flow screen.'
      
        'The Life Insurance worksheet will determine any additional insur' +
        'ance required expressed in $50,000 '
      'increments.'
      ''
      
        'The amount used for investment purposes will have an impact on t' +
        'he retirement planning calculations '
      'and projections.'
      ''
      '3.1 Retirement Analysis'
      
        'Retirement projections are calculated by the program based on th' +
        'e specific retirement goals, the Life '
      'Events and the Investment Strategy chosen.'
      ''
      
        'The Investment Strategy defines the Asset Allocation into differ' +
        'ent types of investments and the expected'
      'rate of return from each type of investment.'
      ''
      
        'Based on the above the program calculates any Shortfall at retir' +
        'ement, and the year by year Asset '
      'Accumulation for the various investment types.'
      ''
      
        'The calculation algorithm tries to meet the client objectives by' +
        ' utilizing the remaining balances in the'
      'investments following the sequence of:'
      '- Non-sheltered'
      '- Semi-sheltered'
      '- Sheltered'
      ''
      
        'Analysis of the Asset Accumulation will indicate if the client c' +
        'an meet his/her future financial objectives.'
      
        'Negative balances in the non-sheltered investments indicates tha' +
        't the client cannot meet the objectives, '
      
        'even after the other investments have been liquidated. In this c' +
        'ase the objectives or the investment '
      'strategy should be revised.'
      ' ')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
