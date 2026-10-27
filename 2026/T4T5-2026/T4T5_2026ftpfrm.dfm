object FtpFrmT4T5_2026: TFtpFrmT4T5_2026
  Left = 73
  Top = 74
  Caption = 'Program Update Download'
  ClientHeight = 465
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 106
    Width = 674
    Height = 23
    Align = alTop
    Panels = <>
    SimplePanel = True
  end
  object Memo1: TMemo
    Left = 0
    Top = 129
    Width = 674
    Height = 297
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 674
    Height = 33
    Align = alTop
    Caption = 'Check/download any recent update from VisualTax Web Site'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object ProxyPanel: TPanel
    Left = 0
    Top = 73
    Width = 674
    Height = 33
    Align = alTop
    TabOrder = 1
    object Label16: TLabel
      Left = 178
      Top = 12
      Width = 60
      Height = 13
      Caption = 'Proxy Server'
    end
    object Label17: TLabel
      Left = 409
      Top = 16
      Width = 48
      Height = 13
      Caption = 'Proxy Port'
    end
    object CheckBox1: TCheckBox
      Left = 49
      Top = 8
      Width = 104
      Height = 17
      Caption = 'Use Proxy Server'
      TabOrder = 0
    end
    object Edit6: TEdit
      Left = 248
      Top = 8
      Width = 137
      Height = 21
      TabOrder = 1
    end
    object Edit7: TEdit
      Left = 464
      Top = 8
      Width = 33
      Height = 21
      TabOrder = 2
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 33
    Width = 674
    Height = 40
    Align = alTop
    TabOrder = 0
    object DownloadBtn: TButton
      Left = 144
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Download the program update'
      Caption = '2. Download'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = DownloadBtnClick
    end
    object AbortBtn: TButton
      Left = 240
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Interrupt any download '
      Caption = 'Abort'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = AbortBtnClick
    end
    object CheckUpdatesBtn: TBitBtn
      Left = 32
      Top = 8
      Width = 89
      Height = 25
      Hint = 'Check web site for any new update'
      Caption = '1. Check Update'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = CheckUpdatesBtnClick
    end
    object Button1: TButton
      Left = 544
      Top = 7
      Width = 75
      Height = 25
      Hint = 'Exit this window'
      Caption = 'Exit'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = Button1Click
    end
  end
end
