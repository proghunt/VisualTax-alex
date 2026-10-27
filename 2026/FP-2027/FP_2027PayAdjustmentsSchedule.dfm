object PayAdjustmentsSchedule: TPayAdjustmentsSchedule
  Left = 52
  Top = 114
  Width = 675
  Height = 572
  Caption = 'Pay Adjustments Schedule'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object AgentNameLbl: TLabel
    Left = 0
    Top = 137
    Width = 667
    Height = 24
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'AgentNameLbl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 667
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Automatic Commission Adjustments'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object DBCtrlGrid1: TDBCtrlGrid
    Left = 0
    Top = 185
    Width = 667
    Height = 320
    Align = alTop
    ColCount = 1
    Color = 13615537
    DataSource = AdjustmentsSource
    PanelHeight = 64
    PanelWidth = 651
    ParentColor = False
    TabOrder = 1
    RowCount = 5
    object Label7: TLabel
      Left = 56
      Top = 40
      Width = 33
      Height = 15
      Caption = 'Notes'
      FocusControl = DBEdit7
    end
    object CodeBox: TDBEdit
      Left = 8
      Top = 8
      Width = 25
      Height = 20
      BorderStyle = bsNone
      DataField = 'Code'
      DataSource = AdjustmentsSource
      TabOrder = 0
    end
    object DBEdit3: TDBEdit
      Left = 56
      Top = 8
      Width = 214
      Height = 20
      BorderStyle = bsNone
      DataField = 'Description'
      DataSource = AdjustmentsSource
      TabOrder = 1
    end
    object StartFromBox: TDBEdit
      Left = 288
      Top = 8
      Width = 74
      Height = 20
      BorderStyle = bsNone
      DataField = 'StartFrom'
      DataSource = AdjustmentsSource
      TabOrder = 2
    end
    object EndInBox: TDBEdit
      Left = 432
      Top = 8
      Width = 74
      Height = 20
      BorderStyle = bsNone
      DataField = 'EndIn'
      DataSource = AdjustmentsSource
      TabOrder = 3
    end
    object DBEdit6: TDBEdit
      Left = 528
      Top = 8
      Width = 74
      Height = 20
      BorderStyle = bsNone
      DataField = 'Amount'
      DataSource = AdjustmentsSource
      TabOrder = 4
    end
    object DBEdit7: TDBEdit
      Left = 104
      Top = 32
      Width = 354
      Height = 20
      BorderStyle = bsNone
      DataField = 'Notes'
      DataSource = AdjustmentsSource
      TabOrder = 5
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 161
    Width = 667
    Height = 24
    Align = alTop
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 29
      Height = 15
      Caption = 'Code'
      FocusControl = CodeBox
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 56
      Top = 8
      Width = 65
      Height = 15
      Caption = 'Description'
      FocusControl = DBEdit3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 296
      Top = 8
      Width = 57
      Height = 15
      Caption = 'Start Date'
      FocusControl = StartFromBox
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 440
      Top = 8
      Width = 50
      Height = 15
      Caption = 'End Date'
      FocusControl = EndInBox
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 528
      Top = 8
      Width = 44
      Height = 15
      Caption = 'Amount'
      FocusControl = DBEdit6
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 505
    Width = 667
    Height = 37
    Align = alTop
    TabOrder = 3
    object CancelBtn: TBitBtn
      Left = 544
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Exit'
      TabOrder = 0
      Kind = bkCancel
    end
    object AddBtn: TBitBtn
      Left = 128
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Add code'
      TabOrder = 1
    end
    object DeleteBtn: TBitBtn
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Delete...'
      TabOrder = 2
    end
    object SaveBtn: TBitBtn
      Left = 448
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 3
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 33
    Width = 667
    Height = 104
    Align = alTop
    Color = 15925247
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Double click on Code and Dates for automatic selection.'
      
        'Codes 01 to 30 are used for charges.  Codes 31 to 60 are used fo' +
        'r credits'
      
        'Amounts are taken automatically by the program as Charges or Cre' +
        'dits based on the Adjustment code'
      
        'One time charges or credits should be entered with the same Star' +
        't and End dates'
      
        'Charges and credits will be applied the week in which the Start ' +
        'and end End dates fall into (inclusive).'
      ' '
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object AdjustmentsSource: TDataSource
    Left = 236
    Top = 262
  end
end
