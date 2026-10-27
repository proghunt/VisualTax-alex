object sqlFiltT1_2026: TsqlFiltT1_2026
  Left = 117
  Top = 153
  Width = 480
  Height = 342
  Caption = 'Client List Filters'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 433
    Height = 289
    BevelInner = bvLowered
    BorderWidth = 4
    Color = clBtnShadow
    TabOrder = 0
    object Label6: TLabel
      Left = 148
      Top = 5
      Width = 129
      Height = 18
      Alignment = taCenter
      Caption = 'Selection Criteria'
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
    end
    object GroupBox7: TGroupBox
      Left = 8
      Top = 32
      Width = 177
      Height = 49
      Caption = 'Data Directory'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      object datadir: TComboBox
        Left = 16
        Top = 16
        Width = 145
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
      end
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 144
      Width = 177
      Height = 41
      Caption = 'Preparation Status'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      object EFStatus: TComboBox
        Left = 16
        Top = 16
        Width = 145
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 88
      Width = 177
      Height = 41
      Caption = 'EFile Status'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 2
      object efstat: TComboBox
        Left = 16
        Top = 16
        Width = 145
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
        Items.Strings = (
          'Any'
          'Ready for RTU'
          'Accepted'
          'Rejected'
          'In RTU')
      end
    end
    object GroupBox3: TGroupBox
      Left = 232
      Top = 32
      Width = 177
      Height = 72
      Caption = 'Preparer'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 3
      object Label3: TLabel
        Left = 4
        Top = 20
        Width = 63
        Height = 13
        Caption = 'Prepared by: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 4
        Top = 44
        Width = 74
        Height = 13
        Caption = 'Updated in last '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 140
        Top = 44
        Width = 22
        Height = 13
        Caption = 'days'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpinButton1: TSpinButton
        Left = 114
        Top = 40
        Width = 20
        Height = 25
        DownGlyph.Data = {
          DE000000424DDE00000000000000360000002800000009000000060000000100
          180000000000A800000000000000000000000000000000000000008080008080
          0080800080800080800080800080800080800080800000808000808000808000
          8080000000008080008080008080008080000080800080800080800000000000
          0000000000808000808000808000008080008080000000000000000000000000
          0000000080800080800000808000000000000000000000000000000000000000
          0000008080000080800080800080800080800080800080800080800080800080
          8000}
        TabOrder = 0
        UpGlyph.Data = {
          DE000000424DDE00000000000000360000002800000009000000060000000100
          180000000000A800000000000000000000000000000000000000008080008080
          0080800080800080800080800080800080800080800000808000000000000000
          0000000000000000000000000000008080000080800080800000000000000000
          0000000000000000808000808000008080008080008080000000000000000000
          0080800080800080800000808000808000808000808000000000808000808000
          8080008080000080800080800080800080800080800080800080800080800080
          8000}
      end
      object upddate: TEdit
        Left = 80
        Top = 40
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object prepby: TComboBox
        Left = 76
        Top = 16
        Width = 77
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 2
        Items.Strings = (
          'Any'
          'Mary'
          'John')
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 193
      Width = 177
      Height = 81
      Caption = 'Tax Criteria'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 4
      object Label2: TLabel
        Left = 8
        Top = 16
        Width = 20
        Height = 13
        Caption = 'Line'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 120
        Top = 16
        Width = 48
        Height = 13
        Caption = 'Amount($)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 64
        Top = 16
        Width = 41
        Height = 13
        Caption = 'Operator'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Edit2: TEdit
        Left = 120
        Top = 56
        Width = 49
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object ComboBox3: TComboBox
        Left = 68
        Top = 32
        Width = 45
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 1
        Items.Strings = (
          '>'
          '<'
          '='
          '>='
          '<='
          '<>')
      end
      object TComboBox
        Left = 4
        Top = 32
        Width = 53
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 2
        Items.Strings = (
          '101'
          '102'
          '103')
      end
      object TComboBox
        Left = 4
        Top = 56
        Width = 53
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 3
        Items.Strings = (
          '101'
          '102')
      end
      object ComboBox4: TComboBox
        Left = 68
        Top = 56
        Width = 45
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 4
        Items.Strings = (
          '>'
          '<'
          '='
          '>='
          '<='
          '<>')
      end
      object Edit3: TEdit
        Left = 120
        Top = 32
        Width = 49
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
    end
    object GroupBox4: TGroupBox
      Left = 232
      Top = 121
      Width = 177
      Height = 72
      Caption = 'Advanced Criteria'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 5
      object ComboBox1: TComboBox
        Left = 8
        Top = 24
        Width = 73
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
      end
      object ComboBox7: TComboBox
        Left = 8
        Top = 48
        Width = 73
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 1
      end
      object ComboBox9: TComboBox
        Left = 84
        Top = 24
        Width = 45
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 2
        Items.Strings = (
          '>'
          '<'
          '='
          '>='
          '<='
          '<>')
      end
      object ComboBox10: TComboBox
        Left = 84
        Top = 48
        Width = 45
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 3
        Items.Strings = (
          '>'
          '<'
          '='
          '>='
          '<='
          '<>')
      end
      object Edit4: TEdit
        Left = 136
        Top = 24
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object Edit5: TEdit
        Left = 136
        Top = 48
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
    end
    object OKBtn: TBitBtn
      Left = 212
      Top = 224
      Width = 89
      Height = 33
      Caption = 'OK'
      TabOrder = 6
    end
    object CancelBtn: TBitBtn
      Left = 308
      Top = 224
      Width = 89
      Height = 33
      Caption = 'Cancel'
      TabOrder = 7
      OnClick = CancelBtnClick
    end
  end
end
