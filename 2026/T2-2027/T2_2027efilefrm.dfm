object EfileFrm: TEfileFrm
  Left = 286
  Top = 231
  Caption = 'EfileFrm'
  ClientHeight = 488
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object HeaderPanel: TPanel
    Left = 0
    Top = 0
    Width = 716
    Height = 33
    Hint = 'Click to change tax year and rates'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'EFile'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ExplicitWidth = 712
  end
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 716
    Height = 455
    Align = alClient
    Color = 13353654
    TabOrder = 1
    ExplicitWidth = 712
    ExplicitHeight = 438
    object Label1: TLabel
      Left = 80
      Top = 176
      Width = 21
      Height = 16
      Caption = 'SIN'
    end
    object Label2: TLabel
      Left = 80
      Top = 200
      Width = 54
      Height = 16
      Caption = 'BirthDate'
    end
    object Label3: TLabel
      Left = 80
      Top = 224
      Width = 70
      Height = 16
      Caption = 'File location'
    end
    object Label4: TLabel
      Left = 208
      Top = 120
      Width = 166
      Height = 19
      Caption = 'Return being NetFiled'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 80
      Top = 152
      Width = 34
      Height = 16
      Caption = 'Name'
    end
    object Label6: TLabel
      Left = 16
      Top = 272
      Width = 162
      Height = 16
      Caption = 'NetFile Pro Web site (URL):'
    end
    object SinBox: TEdit
      Left = 184
      Top = 168
      Width = 121
      Height = 24
      ReadOnly = True
      TabOrder = 3
      Text = 'SinBox'
    end
    object BirthDateBox: TEdit
      Left = 184
      Top = 192
      Width = 121
      Height = 24
      ReadOnly = True
      TabOrder = 4
      Text = 'Edit1'
    end
    object FileNameBox: TEdit
      Left = 184
      Top = 216
      Width = 273
      Height = 24
      TabOrder = 0
      Text = 'Edit1'
    end
    object RefundBox: TRadioButton
      Left = 184
      Top = 248
      Width = 113
      Height = 17
      Caption = 'Refund'
      Enabled = False
      TabOrder = 5
    end
    object CreateBtn: TBitBtn
      Left = 504
      Top = 232
      Width = 57
      Height = 17
      Caption = 'Create NetFile'
      TabOrder = 6
      Visible = False
      OnClick = CreateBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 536
      Top = 296
      Width = 105
      Height = 49
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 7
      OnClick = CancelBtnClick
    end
    object ShowBtn: TBitBtn
      Left = 160
      Top = 296
      Width = 105
      Height = 49
      Caption = 'Display File'
      TabOrder = 1
      OnClick = ShowBtnClick
    end
    object TransmitBtn: TPanel
      Left = 320
      Top = 296
      Width = 153
      Height = 49
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = TransmitBtnClick
      object WorldButton: TImage
        Left = 8
        Top = 8
        Width = 41
        Height = 41
        Hint = 'Connect to the Internet'
        ParentShowHint = False
        Picture.Data = {
          07544269746D6170FE080000424DFE0800000000000036040000280000002200
          0000220000000100080000000000C80400000000000000000000000100000001
          000000000000000080000080000000808000800000008000800080800000C0C0
          C000C0DCC000F0CAA600FFF3FF0000006600000099000000CC00003300000033
          330000336600003399000033CC000033FF000066000000663300006666000066
          99000066CC000066FF000099330000996600009999000099CC000099FF0000CC
          000000CC330000CC660000CC990000CCCC0000CCFF0000FF330000FF660000FF
          990000FFCC00330000003300330033006600330099003300CC003300FF003333
          00003333330033336600333399003333CC003333FF0033660000336633003366
          6600336699003366CC003366FF00339900003399330033996600339999003399
          CC003399FF0033CC000033CC330033CC66000099000033CC990033CCCC0033CC
          FF0033FF000033FF330033FF660033FF990033FFCC0033FFFF00660000006600
          330066006600660099006600CC006600FF006633000066333300663366006633
          99006633CC006633FF00666600006666330066666600666699006666CC006666
          FF00669900006699330066996600669999006699CC006699FF0066CC000066CC
          330066CC660066CC990066CCCC0066CCFF0066FF000066FF330066FF660066FF
          990066FFCC0066FFFF00990000009900330099006600990099009900CC009900
          FF00993300009933330099336600993399009933CC009933FF00996600009966
          330099666600996699009966CC009966FF009999000099993300999966009999
          99009999CC009999FF0099CC000099CC330099CC660099CC990099CCCC0099CC
          FF0099FF000099FF330099FF660099FF990099FFCC0099FFFF00CC000000CC00
          3300CC006600CC009900CC00CC00CC00FF00CC330000CC333300CC336600CC33
          9900CC33CC00CC33FF00CC660000CC663300CC666600CC669900CC66CC00CC66
          FF00CC990000CC993300CC996600CC999900CC99CC00CC99FF00CCCC0000CCCC
          3300CCCC6600CCCC9900CCCCCC00CCCCFF00CCFF0000CCFF3300CCFF6600CCFF
          9900CCFFCC00CCFFFF00FF003300FF006600FF009900FF00CC00FF330000FF33
          3300FF336600FF339900FF33CC00FF33FF00FF660000FF663300FF666600FF66
          9900FF66CC00FF66FF00FF990000FF993300FF996600FF999900FF99CC00FF99
          FF00FFCC0000FFCC3300FFCC6600FFCC9900FFCCCC00FFCCFF00FFFF3300FFFF
          6600FFFF9900FFFFCC007D7D7D0061285500249D2C0018008D006D7961009110
          2C0034DA3400B24C9D00754C6500442038000000A5009D309100000095009D48
          8D00004BB400004CB300004DB200004EB100004FB0000050AF000051AE000052
          AD000053AC000054AB000055AA000056A9000048B7000049B600F0FBFF00A4A0
          A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFCFCFCFCFC
          FCFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFCFCFC
          0707FCFCFCFCFCFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFCFCFCFCFCFC
          FCFCFCFC07FAFCFCFCFCFCFCFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFCFCFCFC
          FCFCFCFCFCFCFCFCFCFA0707FCFCFCFCFCFCFFFFFFFFFFFF0000FFFFFFFFFFFC
          FCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFA07FCFCFCFCFCFCFFFFFFFFFF0000FFFF
          FFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFA07FCFCFCFCFCFFFFFFFFFF
          0000FFFFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFA07FCFCFCFCFC
          FFFFFFFF0000FFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFA07
          FCFCFCFCFCFFFFFF0000FFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FA
          FAFAFAFAFA07FCFCFCFFFFFF0000FFFFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
          FCFC07FAFAFAFAFAFA07FCFC07FCFFFF0000FFFFFCFCFCFCFCFCFCFCFCFCFCFC
          FCFCFCFCFCFAFAFAFAFAFAFAFAFAFCFC07FCFFFF0000FFFFFCFCFCFCFCFCFCFC
          FCFCFCFCFCFCFCFC07FAFAFAFAFAFAFAFAFAFCFC07FAFFFF0000FFFCFCFCFCFC
          FCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFAFAFAFAFAFAFAFCFC07FAFCFF0000FFFC
          FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFAFAFAFAFAFA07FCFC07FA07FF
          0000FFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFAFAFA07FCFCFCFC
          07FAFAFF0000FFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFAFAFAFCFC
          FCFCFCFC07FAFAFF0000FFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FA0707FAFA
          FA07FCFCFCFCFCFC07FAFCFF0000FFFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFA
          FCFCFAFA07FCFCFCFCFCFCFCFAFAFCFF0000FFFFFC0707FCFCFCFCFCFC0707FA
          FAFAFA07FCFCFCFCFCFCFCFCFCFCFCFCFA07FFFF0000FFFFFCFAFAFCFCFCFCFC
          FCFAFAFAFA07FAFCFAFA07FCFCFCFCFCFCFCFCFCFAFCFFFF0000FFFFFCFCFCFC
          FCFCFCFCFA07FAFA07FCFCFC07070707FCFCFCFCFCFCFCFA07FCFFFF0000FFFF
          FFFCFCFCFCFCFC07FAFAFAFAFA0707FA07FCFCFCFCFCFCFCFCFC0707FCFFFFFF
          0000FFFFFFFCFCFCFCFCFCFAFAFAFAFAFAFAFAFA07FCFCFCFCFCFCFCFCFC07FC
          FCFFFFFF0000FFFFFFFFFCFCFCFCFCFAFAFAFAFAFAFAFAFAFAFA07FCFCFCFCFC
          FCFCFCFCFFFFFFFF0000FFFFFFFFFFFCFCFCFCFCFAFAFAFAFAFA07FAFAFAFAFC
          FCFCFCFCFCFCFCFFFFFFFFFF0000FFFFFFFFFFFC070707FCFAFAFAFAFAFA07FA
          FAFAFAFA07FCFCFCFCFCFCFFFFFFFFFF0000FFFFFFFFFFFFFC0707FAFAFAFAFA
          FAFAFAFAFA07070707FA07FCFCFCFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFCFC
          07FAFAFAFAFAFAFA07FC07FAFAFAFCFCFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
          FFFFFFFCFCFC07070707070707FA070707FCFCFFFFFFFFFFFFFFFFFF0000FFFF
          FFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFFFFFFFFFFFFFFFFFFFFFF
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF0000}
        ShowHint = True
        Transparent = True
        OnClick = WorldButtonClick
      end
      object Label5: TLabel
        Left = 64
        Top = 16
        Width = 75
        Height = 16
        Caption = 'Transmit File'
        OnClick = Label5Click
      end
    end
    object ProdOrTestBox: TRadioGroup
      Left = 504
      Top = 184
      Width = 121
      Height = 41
      Caption = 'Production or Test'
      Color = 15925247
      Items.Strings = (
        'Production'
        'Test')
      ParentColor = False
      TabOrder = 8
      Visible = False
    end
    object Panel2: TPanel
      Left = 552
      Top = 112
      Width = 49
      Height = 41
      BorderStyle = bsSingle
      Color = 15925247
      TabOrder = 9
      Visible = False
      object Label7: TLabel
        Left = 43
        Top = 8
        Width = 83
        Height = 16
        Caption = 'Data Directory'
      end
      object Label8: TLabel
        Left = 11
        Top = 64
        Width = 157
        Height = 16
        Caption = 'Approximate no. of returns:'
      end
      object Label9: TLabel
        Left = 192
        Top = 64
        Width = 4
        Height = 16
      end
      object Label10: TLabel
        Left = 67
        Top = 80
        Width = 100
        Height = 16
        Caption = 'Now processing: '
      end
      object Label11: TLabel
        Left = 192
        Top = 80
        Width = 4
        Height = 16
      end
      object FileListBox1: TFileListBox
        Left = 12
        Top = 96
        Width = 117
        Height = 129
        Mask = '*.d'
        TabOrder = 0
      end
      object DataDirBox: TEdit
        Left = 9
        Top = 28
        Width = 168
        Height = 24
        TabOrder = 1
        Text = 'C:\delphi\t1\data'
      end
      object DoAllBtn: TBitBtn
        Left = 0
        Top = 0
        Width = 33
        Height = 25
        Caption = 'All'
        TabOrder = 2
        OnClick = DoAllBtnClick
      end
    end
    object LoadallfilesBox: TCheckBox
      Left = 472
      Top = 160
      Width = 97
      Height = 17
      Caption = 'Load all files'
      TabOrder = 10
      Visible = False
    end
    object NameBox: TEdit
      Left = 184
      Top = 144
      Width = 273
      Height = 24
      ReadOnly = True
      TabOrder = 11
      Text = 'NameBox'
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 710
      Height = 104
      Align = alTop
      BevelOuter = bvLowered
      Color = 15532031
      TabOrder = 12
      object Label13: TLabel
        Left = 8
        Top = 17
        Width = 523
        Height = 16
        Caption = 
          'You cannot NetFile changes to: Name, Address, BirthDate, and Dir' +
          'ect Deposit information.'
      end
      object Label14: TLabel
        Left = 8
        Top = 33
        Width = 438
        Height = 16
        Caption = 
          'For such changes, contact the local tax office before Netfiling ' +
          'the tax return.'
      end
      object Label15: TLabel
        Left = 8
        Top = 1
        Width = 44
        Height = 16
        Caption = 'Note 1:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label16: TLabel
        Left = 8
        Top = 65
        Width = 558
        Height = 16
        Caption = 
          'Direct Deposit information is not allowed in NetFile. Discounted' +
          ' returns are not allowed in NetFile'
      end
      object Label17: TLabel
        Left = 8
        Top = 81
        Width = 323
        Height = 16
        Caption = 'Related data is ignored even if entered on the tax return.'
      end
      object Label18: TLabel
        Left = 8
        Top = 49
        Width = 44
        Height = 16
        Caption = 'Note 2:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object BuildBtn: TBitBtn
      Left = 32
      Top = 296
      Width = 105
      Height = 49
      Caption = 'Build File'
      TabOrder = 13
      OnClick = BuildBtnClick
    end
    object Panel4: TPanel
      Left = 1
      Top = 388
      Width = 710
      Height = 49
      Align = alBottom
      Color = 15532031
      TabOrder = 14
      object Label19: TLabel
        Left = 8
        Top = 1
        Width = 44
        Height = 16
        Caption = 'Note 3:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label20: TLabel
        Left = 8
        Top = 17
        Width = 655
        Height = 16
        Caption = 
          'After successful transmission you may save the Netfile Confirmat' +
          'ion No. at the bottom of T183 (in lieu of DCN No)'
      end
    end
    object URLBox: TEdit
      Left = 184
      Top = 264
      Width = 457
      Height = 24
      TabOrder = 15
    end
  end
end
