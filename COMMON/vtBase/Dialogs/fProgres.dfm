object Progress: TProgress
  Left = 228
  Top = 124
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Progress'
  ClientHeight = 337
  ClientWidth = 532
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 120
  TextHeight = 20
  object Label1: TLabel
    Left = 150
    Top = 30
    Width = 53
    Height = 20
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -17
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 300
    Top = 30
    Width = 53
    Height = 20
    Caption = 'Label2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 150
    Top = 60
    Width = 53
    Height = 20
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 300
    Top = 60
    Width = 53
    Height = 20
    Caption = 'Label4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 180
    Top = 90
    Width = 4
    Height = 20
  end
  object Label6: TLabel
    Left = 320
    Top = 90
    Width = 4
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
  end
  object Gauge1: TGauge
    Left = 20
    Top = 290
    Width = 481
    Height = 21
    ForeColor = clBlue
    Progress = 0
  end
  object BitBtn1: TBitBtn
    Left = 220
    Top = 200
    Width = 111
    Height = 41
    Cancel = True
    Caption = 'Abort'
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    ModalResult = 3
    NumGlyphs = 2
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object ListBox1: TListBox
    Left = 20
    Top = 20
    Width = 121
    Height = 261
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 18
    ParentFont = False
    TabOrder = 2
  end
  object PauseBtn: TBitBtn
    Left = 220
    Top = 130
    Width = 111
    Height = 41
    Caption = 'Pause'
    TabOrder = 1
    OnClick = PauseBtnClick
  end
  object ProgressBar1: TProgressBar
    Left = 20
    Top = 310
    Width = 481
    Height = 21
    TabOrder = 3
  end
end
