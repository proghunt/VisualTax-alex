object CoupleT1_2026: TCoupleT1_2026
  Left = 94
  Top = 145
  BorderStyle = bsDialog
  Caption = 'Coupling'
  ClientHeight = 489
  ClientWidth = 796
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 796
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 256
      Top = 7
      Width = 88
      Height = 13
      Caption = 'Current Return:'
    end
    object CurRetLbl: TLabel
      Left = 362
      Top = 7
      Width = 57
      Height = 13
      Caption = 'CurRetLbl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Image1: TImage
      Left = 192
      Top = 2
      Width = 33
      Height = 25
      Picture.Data = {
        07544269746D6170F6010000424DF60100000000000076000000280000002000
        0000180000000100040000000000800100000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00888884448444888888888778778888888888844484448888888887787788
        8888888884448444888888888778778888888888844484448888889999999999
        9888888884448444888888999999999998888888844444448888888999999999
        8888888484444444844779999999999998888844844444448447799899999998
        9988884484444444844889988899988899888844844444448448899888BBB888
        99888844847FFF74844889988999998899888844847FFF748448899899999998
        99888844447F4F74444889989999999899888844447F4F744448899999777999
        99888884447F4F74444889997788877999888884488787884488889988787889
        9888888888777778888888888777778888888888877888778888888877888778
        8888888887888887888888887888887888888888877888778888888877888778
        8888888888778778888888888778778888888888887777788888888887777788
        8888888888888888888888888888888888888888888888888888888888888888
        8888}
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 65
    Width = 796
    Height = 377
    Align = alTop
    BorderStyle = bsSingle
    TabOrder = 2
    object Label2: TLabel
      Left = 32
      Top = 50
      Width = 115
      Height = 16
      Caption = 'Family members'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 352
      Top = 122
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label22: TLabel
      Left = 11
      Top = 8
      Width = 47
      Height = 16
      Caption = 'NOTE:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object WarnLbl: TLabel
      Left = 60
      Top = 22
      Width = 634
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label23: TLabel
      Left = 60
      Top = 8
      Width = 725
      Height = 13
      Caption = 
        'FIRST TIME coupling must start from the spouse where you entered' +
        ' details of medical, donations, shared slips, statements, etc.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object StringGrid1: TStringGrid
      Left = 8
      Top = 74
      Width = 297
      Height = 270
      ColCount = 4
      DefaultRowHeight = 16
      FixedCols = 3
      RowCount = 12
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentFont = False
      TabOrder = 0
      ColWidths = (
        64
        98
        64
        55)
      RowHeights = (
        16
        15
        16
        16
        16
        16
        16
        16
        16
        16
        16
        16)
    end
    object GroupBox1: TGroupBox
      Left = 322
      Top = 58
      Width = 442
      Height = 286
      Caption = 'Notes'
      TabOrder = 1
      object Label6: TLabel
        Left = 8
        Top = 97
        Width = 284
        Height = 13
        Caption = '- Family members are copied from the '#39'Dependants List'#39' form '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 8
        Top = 129
        Width = 175
        Height = 13
        Caption = '- Existing returns are loaded from disk'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 8
        Top = 113
        Width = 189
        Height = 13
        Caption = '- First-time returns are created in memory'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 8
        Top = 153
        Width = 208
        Height = 13
        Caption = 'While in coupling mode ('#39'Family ON'#39')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 8
        Top = 169
        Width = 262
        Height = 13
        Caption = '- Changes in Dependant'#39's income will affect the parents'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 8
        Top = 185
        Width = 303
        Height = 13
        Caption = '- Shared slips and statements between spouses are recalculated'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 8
        Top = 203
        Width = 334
        Height = 13
        Caption = 
          '- Eligible transfers from spouse and dependants are done automat' +
          'ically '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label19: TLabel
        Left = 8
        Top = 83
        Width = 222
        Height = 13
        Caption = '- Enter X next to the name using the keyboard. '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 11
        Top = 229
        Width = 303
        Height = 13
        Caption = 'To show the same form of another return, click the Swap button:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Image2: TImage
        Left = 388
        Top = 219
        Width = 33
        Height = 25
        Picture.Data = {
          07544269746D6170F6010000424DF60100000000000076000000280000002000
          0000180000000100040000000000800100000000000000000000100000000000
          000000000000000080000080000000808000800000008000800080800000C0C0
          C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00777777777777777779977999997799777777777777777077799799999997
          9977777777777777700779979999999799777777777700000000799999888999
          9977777777707777700779998877788999777777770077777077779977878779
          9777777777077777777777777888887777777777770777777777777788777887
          7777777777077777777777778777778777777777777777777777777788777887
          777777778888887777777777788788777777744748FFF8474477777778888877
          7777744748FFF84744777777777777777777744448F4F8444477777777777777
          7777744448F4F84444777777770707770007774448F4F8444477777777070777
          0707774477878774477777777707007700077777788888777777777777070777
          0707777788777887777707777707000700077777877777877770077770777777
          7777777788777887770000000777777777777777788788777770077777777777
          7777777778888877777707777777777777777777777777777777777777777777
          7777}
      end
      object Label20: TLabel
        Left = 10
        Top = 250
        Width = 323
        Height = 13
        Caption = 
          'To turn coupling OFF and stop the inter-flow of data, click this' +
          ' button'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 8
        Top = 20
        Width = 173
        Height = 13
        Caption = 'To Save coupled returns, use:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 8
        Top = 36
        Width = 195
        Height = 13
        Caption = '- Ctrl F3 to Save All and continue working'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 8
        Top = 50
        Width = 160
        Height = 13
        Caption = '- Shift F3 to Save All and Close All'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 8
        Top = 69
        Width = 83
        Height = 13
        Caption = 'To link returns'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CplBtn: TPanel
        Left = 370
        Top = 248
        Width = 65
        Height = 17
        Hint = 'You may click to Stop family coupling'
        Caption = 'Family '#39'ON'#39
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 33
    Align = alTop
    Caption = 'Family Coupling Set-up'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object ButtonsPanel: TPanel
    Left = 0
    Top = 442
    Width = 796
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object CancelBtn: TBitBtn
      Left = 376
      Top = 12
      Width = 81
      Height = 28
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object OKBtn: TBitBtn
      Left = 280
      Top = 12
      Width = 81
      Height = 28
      Caption = 'OK'
      Default = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
  end
end
