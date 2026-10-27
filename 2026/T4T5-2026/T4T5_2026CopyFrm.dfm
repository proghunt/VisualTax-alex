object CopyFrmT4T5_2026: TCopyFrmT4T5_2026
  Left = 48
  Top = 48
  Caption = 'Copy/Move Form'
  ClientHeight = 371
  ClientWidth = 574
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 320
    Top = 120
    Width = 33
    Height = 29
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
  end
  object Label1: TLabel
    Left = 240
    Top = 8
    Width = 202
    Height = 16
    Caption = 'Form Data to be copied/moved:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object ListBoxLbl: TLabel
    Left = 224
    Top = 32
    Width = 273
    Height = 13
    AutoSize = False
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object CurFormBox: TLabel
    Left = 144
    Top = 32
    Width = 68
    Height = 13
    Caption = 'CurFormBox'
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 97
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'Forms'
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 184
    Top = 256
    Width = 313
    Height = 49
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object CopyBtn: TBitBtn
      Left = 8
      Top = 8
      Width = 89
      Height = 33
      Caption = 'Copy'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = CopyBtnClick
    end
    object BitBtn2: TBitBtn
      Left = 216
      Top = 8
      Width = 89
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object MoveBtn: TBitBtn
      Left = 112
      Top = 8
      Width = 89
      Height = 33
      Caption = 'Move'
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 120
    Top = 56
    Width = 193
    Height = 177
    BorderStyle = bsSingle
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 69
      Height = 13
      Caption = 'From return:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ListBox1: TListBox
      Left = 9
      Top = 34
      Width = 168
      Height = 127
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
    end
    object ListBox2: TListBox
      Left = 200
      Top = 34
      Width = 25
      Height = 127
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 360
    Top = 56
    Width = 185
    Height = 177
    BorderStyle = bsSingle
    TabOrder = 2
    object Label4: TLabel
      Left = 13
      Top = 8
      Width = 62
      Height = 13
      Caption = 'To Return:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ListBox3: TListBox
      Left = 17
      Top = 34
      Width = 152
      Height = 119
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
    end
    object ListBox4: TListBox
      Left = 192
      Top = 34
      Width = 25
      Height = 111
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object Frmlist: TListBox
    Left = 8
    Top = 24
    Width = 97
    Height = 281
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    ParentFont = False
    TabOrder = 3
    OnClick = FrmlistClick
  end
end
