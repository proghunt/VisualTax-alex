object GoalsObjectives: TGoalsObjectives
  Left = 129
  Top = 128
  ClientHeight = 364
  ClientWidth = 613
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
    Width = 613
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = '2 - Goals and Objectives'
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
    Width = 613
    Height = 331
    Align = alClient
    Color = 14933196
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'The client and the Financial Planner discuss and agree on the go' +
        'als, objectives and assumptions.'
      
        'They can be expressed in general terms or expressed in very spec' +
        'ific terms such as retirement at a specific '
      'age.'
      ''
      
        'The Retirement Income and Expenses objective has been determined' +
        ' during the data gathering process'
      'under Annual Income Sources and Expenses.'
      ''
      
        'Special attention should be paid to the specific objectives and ' +
        'Life Events which quantify special desires'
      
        'such as financing the children'#8217's education, or financing an expe' +
        'nsive trip. Any items that are expected to have '
      'an'
      
        'impact on the balance sheet such as major purchases or sales can' +
        ' also be recorded.'
      ''
      
        'The program will take them into account in the retirement projec' +
        'tion calculations.'
      ' ')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
