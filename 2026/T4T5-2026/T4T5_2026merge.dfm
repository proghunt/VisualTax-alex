object MergeT4T5_2026: TMergeT4T5_2026
  Left = 94
  Top = 86
  Caption = 'Merge data bases'
  ClientHeight = 301
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Label5: TLabel
    Left = 147
    Top = 8
    Width = 236
    Height = 16
    Caption = 'Use this facility to merge tax returns'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 162
    Top = 24
    Width = 215
    Height = 16
    Caption = 'from different directories into one'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 8
    Top = 48
    Width = 521
    Height = 257
    BorderStyle = bsSingle
    Color = 15269887
    TabOrder = 0
    object Label1: TLabel
      Left = 67
      Top = 8
      Width = 130
      Height = 16
      Caption = 'From Data Directory'
    end
    object Label2: TLabel
      Left = 11
      Top = 64
      Width = 167
      Height = 16
      Caption = 'Aproximate no. of returns:'
    end
    object Label3: TLabel
      Left = 192
      Top = 64
      Width = 4
      Height = 16
    end
    object Label6: TLabel
      Left = 67
      Top = 80
      Width = 112
      Height = 16
      Caption = 'Now processing: '
    end
    object Label7: TLabel
      Left = 192
      Top = 80
      Width = 4
      Height = 16
    end
    object Image1: TImage
      Left = 244
      Top = 28
      Width = 45
      Height = 21
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
    object Label4: TLabel
      Left = 307
      Top = 8
      Width = 113
      Height = 16
      Caption = 'To Data Directory'
    end
    object FileListBox1: TFileListBox
      Left = 52
      Top = 112
      Width = 141
      Height = 129
      Mask = '*.db'
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 33
      Top = 28
      Width = 176
      Height = 24
      TabOrder = 1
      Text = 'C:\delphi\t1\data'
      OnExit = DataDirBoxExit
    end
    object DestDataDirBox: TEdit
      Left = 305
      Top = 28
      Width = 192
      Height = 24
      TabOrder = 2
      Text = 'C:\delphi\t1\data'
    end
    object Panel1: TPanel
      Left = 248
      Top = 128
      Width = 249
      Height = 57
      BorderStyle = bsSingle
      TabOrder = 3
      object OKBtn: TBitBtn
        Left = 24
        Top = 12
        Width = 89
        Height = 33
        Caption = 'Merge'
        Kind = bkOK
        NumGlyphs = 2
        TabOrder = 0
        OnClick = OKBtnClick
      end
      object CancelBtn: TBitBtn
        Left = 128
        Top = 12
        Width = 81
        Height = 33
        Kind = bkCancel
        NumGlyphs = 2
        TabOrder = 1
        OnClick = CancelBtnClick
      end
    end
  end
end
