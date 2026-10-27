object ShortFallFrmFP_2012: TShortFallFrmFP_2012
  Left = 332
  Top = 272
  Caption = 'Retirement Planning'
  ClientHeight = 426
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 14
  object ShortFallImage: TImage
    Left = 112
    Top = 56
    Width = 417
    Height = 225
  end
  object Label45: TLabel
    Left = 72
    Top = 352
    Width = 334
    Height = 16
    Caption = 'This shortfall could be covered with an additional capital of'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 352
    Top = 376
    Width = 62
    Height = 16
    Caption = 'at a rate of'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label16: TLabel
    Left = 480
    Top = 376
    Width = 16
    Height = 16
    Caption = '% '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 72
    Top = 320
    Width = 216
    Height = 16
    Caption = 'Annual income shortfall at retirement:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 400
    Top = 400
    Width = 14
    Height = 16
    Caption = 'for'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 456
    Top = 400
    Width = 89
    Height = 16
    Caption = 'years of payout'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object CapShortFallBox: TEdit
    Left = 424
    Top = 344
    Width = 73
    Height = 22
    TabStop = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    Text = '0'
  end
  object ShFallDiscountBox: TEdit
    Left = 424
    Top = 368
    Width = 49
    Height = 22
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '0'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 629
    Height = 49
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Shortfall/Surplus at retirement'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 637
    object CancelBtn: TBitBtn
      Left = 536
      Top = 16
      Width = 65
      Height = 25
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'System'
      Font.Style = [fsBold]
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = CancelBtnClick
    end
  end
  object IncShortFallBox: TEdit
    Left = 296
    Top = 312
    Width = 73
    Height = 22
    TabStop = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    Text = '0'
  end
  object YearsPayoutBox: TEdit
    Left = 424
    Top = 392
    Width = 25
    Height = 22
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = '0'
  end
end
