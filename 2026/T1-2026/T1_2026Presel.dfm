object PreSelT1_2026: TPreSelT1_2026
  Left = 259
  Top = 56
  Width = 828
  Height = 786
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Pre-select forms'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 820
    Height = 726
    Align = alClient
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    BevelWidth = 3
    Color = clSilver
    TabOrder = 0
    object Panel4: TPanel
      Left = 3
      Top = 3
      Width = 814
      Height = 110
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 455
        Top = 7
        Width = 250
        Height = 16
        Caption = 'Navigate with: PgDn, PgUp, KeyDn, KeyUp'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 7
        Top = 7
        Width = 424
        Height = 16
        Caption = 
          'Select/Un-select with Single click or Space Bar (in the desired ' +
          'sequence)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 105
        Top = 28
        Width = 173
        Height = 16
        Caption = 'Client fits following profiles'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 469
        Top = 28
        Width = 99
        Height = 16
        Caption = '... and claiming'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object StudentBox: TCheckBox
        Left = 98
        Top = 49
        Width = 64
        Height = 17
        Caption = 'Student'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = StudentBoxClick
      end
      object EmployeeBox: TCheckBox
        Left = 14
        Top = 49
        Width = 78
        Height = 17
        Caption = 'Employee'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = EmployeeBoxClick
      end
      object PensionerBox: TCheckBox
        Left = 168
        Top = 49
        Width = 85
        Height = 17
        Caption = 'Pensioner'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = PensionerBoxClick
      end
      object InvestorBox: TCheckBox
        Left = 259
        Top = 49
        Width = 64
        Height = 17
        Caption = 'Investor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = InvestorBoxClick
      end
      object CreditsBox: TCheckBox
        Left = 616
        Top = 49
        Width = 120
        Height = 17
        Caption = 'Provincial credits'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = CreditsBoxClick
      end
      object Dependants: TCheckBox
        Left = 448
        Top = 49
        Width = 85
        Height = 17
        Caption = 'Dependants'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = DependantsClick
      end
      object RrspBox: TCheckBox
        Left = 546
        Top = 49
        Width = 57
        Height = 17
        Caption = 'RRSP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = RrspBoxClick
      end
      object SingleBtn: TBitBtn
        Left = 596
        Top = 77
        Width = 49
        Height = 24
        Caption = 'Edit &Single form'
        Default = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
        Visible = False
        OnClick = SingleBtnClick
        NumGlyphs = 2
      end
      object CancelBtn: TBitBtn
        Left = 486
        Top = 77
        Width = 73
        Height = 29
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
        OnClick = CancelBtnClick
        Kind = bkCancel
      end
      object SelectedOnlyBtn: TBitBtn
        Left = 148
        Top = 75
        Width = 161
        Height = 31
        Caption = 'Edit &Preselected Forms'
        Default = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnClick = SelectedOnlyBtnClick
        Glyph.Data = {
          BE060000424DBE06000000000000360400002800000024000000120000000100
          0800000000008802000000000000000000000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A600000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
          0303030303030303030303030303030303030303030303030303030303030303
          03030303030303030303030303030303030303030303FF030303030303030303
          03030303030303040403030303030303030303030303030303F8F8FF03030303
          03030303030303030303040202040303030303030303030303030303F80303F8
          FF030303030303030303030303040202020204030303030303030303030303F8
          03030303F8FF0303030303030303030304020202020202040303030303030303
          0303F8030303030303F8FF030303030303030304020202FA0202020204030303
          0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
          040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
          03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
          FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
          0303030303030303030303FA0202020403030303030303030303030303F8FF03
          03F8FF03030303030303030303030303FA020202040303030303030303030303
          0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
          03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
          030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
          0202040303030303030303030303030303F8FF03F8FF03030303030303030303
          03030303FA0202030303030303030303030303030303F8FFF803030303030303
          030303030303030303FA0303030303030303030303030303030303F803030303
          0303030303030303030303030303030303030303030303030303030303030303
          0303}
        NumGlyphs = 2
      end
      object EditAllBtn: TBitBtn
        Left = 609
        Top = 77
        Width = 71
        Height = 17
        Caption = 'Select &All'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        Visible = False
        OnClick = EditAllBtnClick
      end
      object EditNoneBtn: TBitBtn
        Left = 326
        Top = 75
        Width = 145
        Height = 31
        Caption = '&Remove all selections'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnClick = EditNoneBtnClick
      end
      object SelfEmployedBox: TCheckBox
        Left = 336
        Top = 49
        Width = 99
        Height = 17
        Caption = 'Self-employed'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        OnClick = SelfEmployedBoxClick
      end
    end
    object ListBox1: TListBox
      Left = 3
      Top = 113
      Width = 814
      Height = 610
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      Style = lbOwnerDrawFixed
      TabOrder = 1
      OnDblClick = ListBox1DblClick
      OnDrawItem = ListBox1DrawItem
      OnKeyPress = ListBox1KeyPress
      OnMouseDown = ListBox1MouseDown
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 33
    Align = alTop
    Caption = ' Client interview -  Forms pre-selection'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
end
