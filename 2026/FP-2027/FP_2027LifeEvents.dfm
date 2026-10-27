object LifeEventsFP_2012: TLifeEventsFP_2012
  Left = 69
  Top = 37
  Caption = 'LifeEventsFP_2012'
  ClientHeight = 0
  ClientWidth = 124
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label9: TLabel
    Left = 17
    Top = 87
    Width = 490
    Height = 16
    Caption = 
      'Client expects to have income of $5,000 in the three years start' +
      'ing in 2010. Enter as:'
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label10: TLabel
    Left = 17
    Top = 103
    Width = 503
    Height = 16
    Caption = 
      'Income   2010   2013   C   5000   100   (the default is 100% to ' +
      'Non-sheltered accounts)'
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 124
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Life Events Planner'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 788
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 124
    Height = 498
    Align = alClient
    BevelOuter = bvLowered
    Color = 14933196
    TabOrder = 1
    ExplicitWidth = 788
    object Panel4: TPanel
      Left = 1
      Top = 209
      Width = 122
      Height = 296
      Align = alTop
      BevelOuter = bvLowered
      Color = 14933196
      TabOrder = 0
      ExplicitWidth = 786
      object Label1: TLabel
        Left = 1
        Top = 1
        Width = 479
        Height = 15
        Align = alTop
        Alignment = taCenter
        Caption = 
          'Contributions (C) and Withdrawals (W) are assumed to be done at ' +
          'the end of the year'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 488
        Top = 19
        Width = 217
        Height = 14
        Caption = '% of Withdrawal  (W) or Contribution (C)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object StringGrid1: TStringGrid
        Left = 33
        Top = 40
        Width = 712
        Height = 209
        ColCount = 9
        DefaultColWidth = 40
        DefaultRowHeight = 17
        FixedCols = 0
        RowCount = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing, goTabs, goThumbTracking]
        ParentFont = False
        TabOrder = 0
        OnSelectCell = StringGrid1SelectCell
        OnSetEditText = StringGrid1SetEditText
        ColWidths = (
          112
          83
          75
          96
          78
          64
          62
          54
          52)
      end
      object CancelBtn: TBitBtn
        Left = 520
        Top = 255
        Width = 65
        Height = 34
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 4194368
        Font.Height = -11
        Font.Name = 'System'
        Font.Style = [fsBold]
        Kind = bkCancel
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 1
        OnClick = CancelBtnClick
      end
      object Print: TBitBtn
        Left = 400
        Top = 255
        Width = 105
        Height = 34
        Caption = 'Print Life Events'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = PrintClick
      end
      object ChartsBtn: TBitBtn
        Left = 232
        Top = 256
        Width = 153
        Height = 33
        Hint = 'It shows how life events affect your financial position'
        Caption = 'Accumulation Charts'
        Glyph.Data = {
          56020000424D5602000000000000760000002800000024000000180000000100
          040000000000E001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000FFFF0000000000000000000000000FFFFFFF
          0000FFFF00888888888888888888888880FFFFFF0000FFFF0800000078800000
          78800000780FFFFF0000FFFF088099900780EEE00780BBB00780FFFF0000FFFF
          088099903070EEE06070BBB050780FFF0000FFFF088099903070EEE06070BBB0
          507780FF0000FFFF088099903000EEE06000BBB0500000FF0000FFFF08809990
          30F0EEE060F0BBB050FFFFFF0000FFFF0880999030F0EEE060F0BBB050FFFFFF
          0000FFFF0880999030F0EEE060F0BBB050FFFFFF0000FFFF0880999030F0EEE0
          60F0BBB050FFFFFF0000FFFF0880000030F0EEE060F0BBB050FFFFFF0000FFFF
          0888099900F0EEE060F0BBB050FFFFFF0000FFFF0888800000F0EEE060F0BBB0
          50FFFFFF0000FFFF088880FFFFF0EEE060F0BBB050FFFFFF0000FFFF088880FF
          FFF0EEE060F0BBB050FFFFFF0000FFFF088880FFFFF0EEE060F0BBB050FFFFFF
          0000FFFFF08880FFFFF0EEE060FF0BBB00FFFFFF0000FFFFFF0880FFFFF0EEE0
          60FFF00000FFFFFF0000FFFFFFF080FFFFF0000060FFFFFFFFFFFFFF0000FFFF
          FFFF00FFFFFF0EEE00FFFFFFFFFFFFFF0000FFFFFFFFF0FFFFFFF00000FFFFFF
          FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = ChartsBtnClick
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 122
      Height = 208
      Align = alTop
      Color = 16056319
      TabOrder = 1
      ExplicitWidth = 786
      object Label2: TLabel
        Left = 185
        Top = 39
        Width = 381
        Height = 15
        Caption = 
          'Enter planned major expenditures or financial changes throughout' +
          ' life'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label4: TLabel
        Left = 185
        Top = 55
        Width = 593
        Height = 15
        Caption = 
          'You can enter recurring income streams (Code C - Contributions) ' +
          'or lump-sum income expected in the future'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label5: TLabel
        Left = 185
        Top = 71
        Width = 593
        Height = 15
        Caption = 
          'You can enter recurring expenditures (Code W - withdrawals) or l' +
          'ump-sum withdrawals expected in the future'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label6: TLabel
        Left = 185
        Top = 135
        Width = 59
        Height = 15
        Caption = 'Examples:'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label7: TLabel
        Left = 185
        Top = 167
        Width = 362
        Height = 15
        Caption = 
          'Client expects to receive a lump-sum of $10,000 in 2016. Enter a' +
          's:'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label8: TLabel
        Left = 185
        Top = 183
        Width = 535
        Height = 15
        Caption = 
          'Lump-sum   2016   2016   C   10000   100   (the default is 100% ' +
          'added to Non-sheltered accounts)'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label13: TLabel
        Left = 17
        Top = -1
        Width = 114
        Height = 16
        Caption = 'Typical life events'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label14: TLabel
        Left = 185
        Top = 15
        Width = 340
        Height = 15
        Caption = 
          'Entries on this form are in addition to the ones entered on the ' +
          ' '
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label15: TLabel
        Left = 521
        Top = 15
        Width = 76
        Height = 15
        Caption = 'Cost Of Living'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnClick = Label15Click
      end
      object Label16: TLabel
        Left = 601
        Top = 15
        Width = 24
        Height = 15
        Caption = 'and '
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label17: TLabel
        Left = 625
        Top = 15
        Width = 90
        Height = 15
        Caption = 'Income Sources'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnClick = Label17Click
      end
      object Label18: TLabel
        Left = 721
        Top = 15
        Width = 45
        Height = 15
        Caption = 'screens'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label19: TLabel
        Left = 185
        Top = 111
        Width = 442
        Height = 15
        Caption = 
          'Education for dependants should be entered on the Education Plan' +
          'ner form(s):'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label20: TLabel
        Left = 185
        Top = 151
        Width = 154
        Height = 15
        Caption = 'Expected one-time income:'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label11: TLabel
        Left = 185
        Top = 95
        Width = 29
        Height = 15
        Caption = 'Note:'
        Color = clScrollBar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object ListBox1: TListBox
        Left = 0
        Top = 16
        Width = 177
        Height = 185
        Color = 14933196
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        Items.Strings = (
          'Education(W)'
          'Vacation(W)'
          'House DownPayment (W)'
          'Car DownPayment (W)'
          'Tax on Withdrawal i.e. RRSP (W)'
          'Tax on Capital Disposition (W)'
          ''
          'Employment Lumpsum (C)'
          'Marriage (W and/or C)'
          'Divorce (W and/or C)'
          'Inheritance (C)'
          ''
          'Productive Asset Sale (W)'
          'Re-investment of proceeds (C)')
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 232
    Top = 297
  end
end
