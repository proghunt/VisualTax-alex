object ReindexDbT4T5_2026: TReindexDbT4T5_2026
  Left = 120
  Top = 79
  Caption = 'ReindexDbT4T5_2026'
  ClientHeight = 327
  ClientWidth = 518
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
    Left = 227
    Top = 216
    Width = 68
    Height = 13
    Caption = 'Data Directory'
  end
  object OkBtn: TBitBtn
    Left = 176
    Top = 288
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = OkBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 280
    Top = 288
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object DataDirBox: TEdit
    Left = 176
    Top = 236
    Width = 177
    Height = 21
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 33
    Align = alTop
    Caption = 'Re-index the Clients Data Base'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    ExplicitWidth = 526
  end
  object Panel2: TPanel
    Left = 40
    Top = 48
    Width = 449
    Height = 153
    BevelOuter = bvLowered
    TabOrder = 4
    object Label4: TLabel
      Left = 27
      Top = 8
      Width = 390
      Height = 48
      Caption = 
        'Use this facility to re-generate the Index of your Clients Data ' +
        'Base. The Index (Clients.MDX) can get corrupted due to power or ' +
        'other interruptions at the wrong time.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label2: TLabel
      Left = 59
      Top = 80
      Width = 292
      Height = 48
      Caption = 
        'Recommendation: Before proceeding, copy the Clients.DB and Clie' +
        'nts.MDX to a safe place as a back-up.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
  end
end
