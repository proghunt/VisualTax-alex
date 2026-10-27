object CopyFrmT2_2027: TCopyFrmT2_2027
  Left = 131
  Top = 123
  Caption = 'Copy Form'
  ClientHeight = 530
  ClientWidth = 861
  Color = 15663103
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 861
    Height = 16
    Margins.Bottom = 2
    Align = alTop
    Alignment = taCenter
    Caption = 'Form Data to be copied'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
    ExplicitLeft = 248
    ExplicitTop = 8
    ExplicitWidth = 150
  end
  object Panel1: TPanel
    Left = 0
    Top = 481
    Width = 861
    Height = 49
    Align = alBottom
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = 177
    ExplicitTop = 338
    ExplicitWidth = 313
    DesignSize = (
      857
      45)
    object CopyBtn: TBitBtn
      Left = 654
      Top = 8
      Width = 89
      Height = 33
      Anchors = [akTop, akRight]
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
      OnClick = CopyBtnClick
      ExplicitLeft = 545
    end
    object BitBtn2: TBitBtn
      Left = 749
      Top = 8
      Width = 89
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BitBtn2Click
      ExplicitLeft = 640
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 16
    Width = 249
    Height = 465
    Align = alLeft
    TabOrder = 1
    object Label3: TLabel
      Left = 1
      Top = 1
      Width = 247
      Height = 16
      Margins.Bottom = 2
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Forms'
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 8
      ExplicitTop = 8
      ExplicitWidth = 81
    end
    object Frmlist: TListBox
      Left = 1
      Top = 17
      Width = 247
      Height = 447
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnClick = FrmlistClick
      ExplicitLeft = 8
      ExplicitTop = 24
      ExplicitWidth = 81
      ExplicitHeight = 376
    end
  end
  object Panel5: TPanel
    Left = 249
    Top = 16
    Width = 612
    Height = 465
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 128
    ExplicitTop = 256
    ExplicitWidth = 585
    ExplicitHeight = 321
    object Image1: TImage
      Left = 282
      Top = 34
      Width = 33
      Height = 430
      Align = alLeft
      Center = True
      Picture.Data = {
        07544269746D61706A020000424D6A0200000000000076000000280000002200
        0000190000000100040000000000F40100000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00888888888888888888888888888888888800000088888888888888888888
        8888888888888800000088888888888888888888888888888888880000008888
        8888888888888888888888888888880000008800888888800000088888888888
        8888880000008800008800088888800008888888888888000000880088008888
        888008FFF08888888888880000008800880888FFFF08FF000088888888888800
        000088008808FFFFFF0F008FFF0888888888880000008800880FFFFFFFF08FF0
        000088888888880000008800EE0FFFFFFFF0F008FFFF08888888880000008800
        EE0FFFFFFFFF08FFFFFF08888888880000008800EE0FFFFFFFFF0FFF00000888
        8888880000008800EE0FFFFFFFFF0000FFFFF0888888880000008800EE0FFFFF
        FFF0FFFFFFFFF0000000880000008800EE0FFFFFFFFFFFFFFFF0008888880800
        00008800EE00FFFFFFFFFFFFF008FFFFFFFF080000008800008800FFFFFFFFFF
        0FFFFFFF000088000000880088888800FFFFFFFFFFF000008888880000008888
        8888888800000000000888888888880000008888888888888888888888888888
        8888880000008888888888888888888888888888888888000000888888888888
        8888888888888888888888000000888888888888888888888888888888888800
        00008888888888888888888888888888888888000000}
      ExplicitLeft = 288
      ExplicitTop = 128
      ExplicitHeight = 29
    end
    object ListBoxLbl: TLabel
      Left = 1
      Top = 21
      Width = 610
      Height = 13
      Margins.Bottom = 2
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
      ExplicitLeft = 256
      ExplicitTop = 32
      ExplicitWidth = 273
    end
    object CurFormBox: TLabel
      Left = 1
      Top = 1
      Width = 610
      Height = 20
      Margins.Bottom = 2
      Align = alTop
      Alignment = taCenter
      Caption = 'CurFormBox'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
      ExplicitLeft = 144
      ExplicitTop = 32
      ExplicitWidth = 100
    end
    object Splitter1: TSplitter
      Left = 315
      Top = 34
      Width = 8
      Height = 430
    end
    object Panel2: TPanel
      Left = 1
      Top = 34
      Width = 281
      Height = 430
      Align = alLeft
      BorderStyle = bsSingle
      TabOrder = 0
      ExplicitLeft = 96
      ExplicitTop = 56
      ExplicitHeight = 260
      object Label2: TLabel
        Left = 1
        Top = 1
        Width = 275
        Height = 13
        Margins.Bottom = 2
        Align = alTop
        Caption = 'From return:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 8
        ExplicitTop = 8
        ExplicitWidth = 69
      end
      object ListBox1: TListBox
        Left = 1
        Top = 14
        Width = 275
        Height = 411
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 8
        ExplicitTop = 34
        ExplicitWidth = 257
        ExplicitHeight = 205
      end
    end
    object Panel3: TPanel
      Left = 323
      Top = 34
      Width = 288
      Height = 430
      Align = alClient
      BorderStyle = bsSingle
      TabOrder = 1
      ExplicitLeft = 424
      ExplicitTop = 56
      ExplicitWidth = 289
      ExplicitHeight = 260
      object Label4: TLabel
        Left = 1
        Top = 1
        Width = 282
        Height = 13
        Margins.Bottom = 2
        Align = alTop
        Caption = 'To Return:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 13
        ExplicitTop = 8
        ExplicitWidth = 62
      end
      object ListBox3: TListBox
        Left = 1
        Top = 14
        Width = 282
        Height = 411
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 8
        ExplicitTop = 34
        ExplicitWidth = 265
        ExplicitHeight = 212
      end
    end
  end
end
