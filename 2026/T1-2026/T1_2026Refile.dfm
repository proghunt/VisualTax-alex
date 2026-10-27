object RefileT1_2026: TRefileT1_2026
  Left = 297
  Top = 247
  Caption = 'ReFILE Preparation'
  ClientHeight = 541
  ClientWidth = 752
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelEfileType: TLabel
    Left = 208
    Top = 18
    Width = 251
    Height = 22
    Caption = 'ReFILE - Preparatory Steps'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 20
    Top = 245
    Width = 448
    Height = 14
    Caption = 
      'Please confirm the following before Re-FILING by clicking the ch' +
      'eck boxes below '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 20
    Top = 87
    Width = 517
    Height = 14
    Caption = 
      'Before making any adjustments,  click the button to Copy the pre' +
      '-amended return to the Pre-amended folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 21
    Top = 346
    Width = 603
    Height = 14
    Caption = 
      'Once the preparatory steps are done, just Exit and click EfileOn' +
      'line -> Current Return as done for normal EFILE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 209
    Top = 380
    Width = 280
    Height = 14
    Caption = 'Unless all boxes are checked you cannot do ReFILE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 59
    Top = 106
    Width = 253
    Height = 14
    Caption = 'The tax return will be copied into the following folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 522
    Width = 752
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 454
    ExplicitWidth = 888
  end
  object ExitBtn: TBitBtn
    Left = 288
    Top = 408
    Width = 99
    Height = 37
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 6
    OnClick = ExitBtnClick
  end
  object WebBrowser1: TWebBrowser
    Left = 371
    Top = 189
    Width = 0
    Height = 8
    Hint = '5'
    TabOrder = 7
    ControlData = {
      4C00000000000000D40000000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object CheckBoxWantToRefile: TCheckBox
    Left = 21
    Top = 266
    Width = 467
    Height = 17
    Caption = 
      'I want to ReFILE this return by adjusting amounts previously Efi' +
      'led and accepted by CRA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object CheckBoxSectionDCompleted: TCheckBox
    Left = 21
    Top = 289
    Width = 467
    Height = 17
    Caption = 'Section D of Form T183 has been completed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object CheckBoxT1013OnFile: TCheckBox
    Left = 21
    Top = 312
    Width = 467
    Height = 17
    Caption = 'The T1013 with Level 2 Authorization is with CRA already'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object SavePreamendedBtn: TBitBtn
    Left = 546
    Top = 80
    Width = 183
    Height = 29
    Caption = 'Copy the pre-amended return '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = SavePreamendedBtnClick
  end
  object ReviewAmmendedAmounts: TBitBtn
    Left = 469
    Top = 176
    Width = 190
    Height = 29
    Caption = 'Review amended amounts'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
  end
  object CheckBoxMadeAdjustments: TCheckBox
    Left = 20
    Top = 183
    Width = 429
    Height = 17
    Caption = 
      'Make necessary adjustments to the tax return and ...............' +
      '........................................'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object AmendFolderBox: TEdit
    Left = 59
    Top = 123
    Width = 670
    Height = 21
    TabOrder = 1
    Text = 'AmendFolderBox'
  end
  object MainMenu1: TMainMenu
    Left = 751
    Top = 79
    object WebServiceserrors1: TMenuItem
      Caption = 'Web Services errors'
    end
    object EfileErrorMessages1: TMenuItem
      Caption = 'Efile Error Messages'
    end
    object ExitProgram: TMenuItem
      Caption = '&Exit'
    end
  end
  object ActionList1: TActionList
    Left = 816
    Top = 148
    object BackAction: TAction
      Caption = 'Back'
      ImageIndex = 0
    end
    object ForwardAction: TAction
      Caption = 'Forward'
      Enabled = False
      ImageIndex = 1
    end
    object StopAction: TAction
      Caption = 'Stop'
      ImageIndex = 2
    end
    object RefreshAction: TAction
      Caption = 'Refresh'
      ImageIndex = 3
    end
  end
  object Query1: TQuery
    Left = 755
    Top = 147
  end
  object OpenDialog1: TOpenDialog
    Left = 854
    Top = 77
  end
  object SaveDialog1: TSaveDialog
    Left = 812
    Top = 77
  end
end
