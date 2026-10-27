object PrintReturnFrmT2_2027: TPrintReturnFrmT2_2027
  Left = 300
  Top = 168
  Caption = 'PrintReturnFrmT2_2027'
  ClientHeight = 718
  ClientWidth = 711
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vtShape4: TvtShape
    Left = 0
    Top = 0
    Width = 711
    Height = 22
    Align = alTop
    Brush.Color = 11301888
    GradientColor = clBlack
    FillDirection = vtUpFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = ''
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtPageFooter = False
    vtIsPrintable = True
    ExplicitWidth = 717
  end
  object vtLabel87: TvtLabel
    Left = 245
    Top = 0
    Width = 147
    Height = 19
    Caption = 'Tax Return Printing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object Panel1: TPanel
    Left = 0
    Top = 22
    Width = 711
    Height = 696
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 182
      Top = 7
      Width = 320
      Height = 14
      Caption = 'Initial selection is based on Configure -> Print Templates...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 14
      Top = 672
      Width = 556
      Height = 14
      Caption = 
        '** For best PDF or Email results Download the PdfFactory utility' +
        ' from www.fineprint.com  (free Trial or paid version)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 14
      Top = 686
      Width = 468
      Height = 14
      Caption = 
        ' If you have a different PDF driver, you can use '#39'Print'#39' and sel' +
        'ect as printer your normal Pdf driver'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 14
      Top = 651
      Width = 478
      Height = 14
      Caption = 
        '* To Email the printout, select PdfFactory as your Printer and u' +
        'pon completion click the '#39'SEND'#39' button'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object CheckListBox1: TCheckListBox
      Left = 168
      Top = 77
      Width = 365
      Height = 554
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object SelectPrintSetGroup: TRadioGroup
      Left = 7
      Top = 77
      Width = 155
      Height = 281
      Caption = 'Select a Print Set'
      Items.Strings = (
        'Client'
        'Preparer'
        'Other 1'
        'Other 2'
        'Other 3')
      TabOrder = 1
      OnClick = SelectPrintSetGroupClick
    end
    object SelectFormsGroup: TRadioGroup
      Left = 245
      Top = 28
      Width = 183
      Height = 43
      Caption = 'Select/Un-select'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Select All'
        'Un-select ALL')
      TabOrder = 2
      OnClick = SelectFormsGroupClick
    end
    object GroupBox1: TGroupBox
      Left = 553
      Top = 77
      Width = 155
      Height = 281
      Caption = 'Select Action'
      TabOrder = 3
      object Label5: TLabel
        Left = 28
        Top = 21
        Width = 103
        Height = 13
        Caption = 'Upon completion, flag'
      end
      object Label6: TLabel
        Left = 28
        Top = 35
        Width = 104
        Height = 13
        Caption = 'tax return as '#39'Printed'#39'?'
      end
      object PrintBtn: TBitBtn
        Left = 14
        Top = 91
        Width = 127
        Height = 36
        Caption = '&Print *'
        Glyph.Data = {
          56020000424D5602000000000000760000002800000024000000180000000100
          040000000000E001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888880000888888888888888888888888888888888888
          0000888888888888888888888888888888888888000088888888888888888888
          8888888888888888000088888877000000000000000007788888888800008888
          8800000000000000000000078888888800008888877777777777777777777770
          788888880000888887F888888888888888888777078888880000888887F88888
          8888888889988777707888880000888887F88888888888888998877777088888
          0000888887F8CCCC8888888889988777770888880000888887F8888888888888
          88888877770888880000888887FFFFFFFFFFFFFFFFF888877708888800008888
          878FFFFFFFFFFFFFFFF8888877088888000088888878FF000000000000008888
          870888880000888888878FF07FFFFFFFFF707888880888880000888888887888
          74444444FF7007888708888800008888888887007FFFFFFFFF70000000888888
          00008888888888887F4444444F7888888888888800008888888888887FFFFFFF
          FF78888888888888000088888888888887F4444444F788888888888800008888
          8888888887FFFFFFFFF788888888888800008888888888888888888888888888
          8888888800008888888888888888888888888888888888880000}
        TabOrder = 0
        OnClick = PrintBtnClick
      end
      object CancelBtn: TBitBtn
        Left = 16
        Top = 217
        Width = 125
        Height = 36
        Caption = '&Cancel'
        ModalResult = 2
        NumGlyphs = 2
        TabOrder = 1
        OnClick = CancelBtnClick
      end
      object SavePdfBtn: TBitBtn
        Left = 14
        Top = 154
        Width = 127
        Height = 36
        Caption = '&Save in PDF **'
        TabOrder = 2
        OnClick = SavePdfBtnClick
      end
      object FlagAsPrintedBox: TCheckBox
        Left = 70
        Top = 49
        Width = 15
        Height = 17
        TabOrder = 3
      end
    end
    object PdfFactoryBtn: TBitBtn
      Left = 574
      Top = 595
      Width = 120
      Height = 36
      Caption = 'Download PdfFactory'
      TabOrder = 4
      OnClick = PdfFactoryBtnClick
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 420
    Top = 316
  end
  object SaveDialog1: TSaveDialog
    Left = 231
    Top = 190
  end
end
