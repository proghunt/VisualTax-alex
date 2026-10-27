object MergeT2_2027: TMergeT2_2027
  Left = 144
  Top = 105
  Caption = 'Merge data bases'
  ClientHeight = 592
  ClientWidth = 554
  Color = clWhite
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
  object Panel2: TPanel
    Left = 0
    Top = 85
    Width = 554
    Height = 507
    Align = alClient
    BorderStyle = bsSingle
    Color = 15394527
    TabOrder = 0
    object Label1: TLabel
      Left = 67
      Top = 22
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
      Left = 251
      Top = 42
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
      Top = 22
      Width = 113
      Height = 16
      Caption = 'To Data Directory'
    end
    object FileListBox1: TFileListBox
      Left = 35
      Top = 112
      Width = 158
      Height = 386
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 15
      Mask = '*.db'
      ParentFont = False
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 12
      Top = 42
      Width = 220
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnExit = DataDirBoxExit
    end
    object DestDataDirBox: TEdit
      Left = 305
      Top = 42
      Width = 207
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object Panel1: TPanel
      Left = 227
      Top = 219
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
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 554
    Height = 36
    Align = alTop
    Color = 11301888
    TabOrder = 1
    object Label9: TLabel
      Left = 147
      Top = 8
      Width = 227
      Height = 22
      Caption = 'Merge Client Data Bases'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 36
    Width = 554
    Height = 49
    Align = alTop
    TabOrder = 2
    object Label5: TLabel
      Left = 147
      Top = 8
      Width = 194
      Height = 15
      Caption = 'Use this facility to merge tax returns'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4194368
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 92
      Top = 24
      Width = 355
      Height = 15
      Caption = 
        'from different directories into one and create a Single Client B' +
        'ook'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4194368
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
end
