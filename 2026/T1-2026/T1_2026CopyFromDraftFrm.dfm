object CopyFromDraftFrmT1_2026: TCopyFromDraftFrmT1_2026
  Left = 190
  Top = 194
  Width = 710
  Height = 401
  Caption = 'Copy Draft Returns'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 84
    Width = 176
    Height = 15
    Caption = 'Data directory used in T1Draft10'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Labelx: TLabel
    Left = 7
    Top = 147
    Width = 183
    Height = 15
    Caption = 'Current Production Data Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 7
    Top = 175
    Width = 566
    Height = 14
    Caption = 
      'The production data directory should be an EMPTY Data Directory ' +
      'where you want to save the returns prepared with'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 7
    Top = 189
    Width = 569
    Height = 14
    Caption = 
      'the Draft version of the program as specified in Configure -> Ge' +
      'neral Options -> Data Directories  -> Current directory '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 35
    Top = 49
    Width = 619
    Height = 14
    Caption = 
      'This is a one time operation at the start of the tax season, pro' +
      'vided you want to keep the returns prepared with the draft versi' +
      'on'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 7
    Top = 287
    Width = 300
    Height = 14
    Caption = 'After successful copy, you may click the Recalc button below'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 7
    Top = 301
    Width = 665
    Height = 14
    Caption = 
      'This step will ensure that returns are re-calculated in the even' +
      't they have been affected by any change made since the draft was' +
      ' issued.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 702
    Height = 43
    Align = alTop
    Caption = 'Copy returns prepared with the T1Draft10 version'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object FromDirBox: TEdit
    Left = 196
    Top = 77
    Width = 463
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object ToDirBox: TEdit
    Left = 196
    Top = 140
    Width = 463
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object OkBtn: TBitBtn
    Left = 245
    Top = 238
    Width = 75
    Height = 25
    Caption = 'Copy'
    TabOrder = 1
    OnClick = OkBtnClick
    Kind = bkOK
  end
  object Exit: TBitBtn
    Left = 357
    Top = 238
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = ExitClick
    Kind = bkCancel
  end
  object BitBtn1: TBitBtn
    Left = 287
    Top = 322
    Width = 75
    Height = 25
    Caption = 'Recalc'
    TabOrder = 5
    OnClick = BitBtn1Click
  end
end
