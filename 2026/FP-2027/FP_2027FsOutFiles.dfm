object FsOutFiles: TFsOutFiles
  Left = 107
  Top = 282
  Width = 730
  Height = 554
  Caption = 'FsOut Files'
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 722
    Height = 49
    Align = alTop
    TabOrder = 0
    object TransmitBtn: TBitBtn
      Left = 208
      Top = 8
      Width = 169
      Height = 33
      Caption = 'Connect To FundServ'
      TabOrder = 0
      OnClick = TransmitBtnClick
      Glyph.Data = {
        F6010000424DF60100000000000076000000280000001E000000180000000100
        0400000000008001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888880088888888888888888888888888888800888888888888
        8888888888888888880088888888888888888888888888888800880000000000
        0000000000088888880088088888888888888888008088888800880000000000
        0000000000880888880088000A00900A00900A0000888088880088000A00900A
        00900A0000888808880088000000000000000000008888808800880000000000
        0000000000888880880088088888888888888888808888808800888088888000
        0000088888088880880088880888888888888888888088808800888880888880
        0000000888880880880088888808888800000000088880808800888888808888
        8888888888888800880088888888000000000000000000008800888888888888
        8888888888888888880088888888888888888888888888888800888888888888
        8888888888888888880088888888888888888888888888888800888888888888
        8888888888888888880088888888888888888888888888888800}
    end
    object CancelBtn: TBitBtn
      Left = 400
      Top = 8
      Width = 137
      Height = 33
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object FileListBox1: TFileListBox
    Left = 0
    Top = 82
    Width = 722
    Height = 135
    Align = alTop
    Color = 14933196
    ItemHeight = 13
    Mask = 'xx.X'
    TabOrder = 1
    OnClick = FileListBox1Click
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 722
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Orders ready for transmission to  FundServ'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object Panel2: TPanel
    Left = 0
    Top = 217
    Width = 722
    Height = 32
    Align = alTop
    Caption = 'File Contents'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 0
    Top = 249
    Width = 722
    Height = 189
    Align = alClient
    Color = 15925247
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    OnClick = Memo1Click
  end
  object TempMemo: TMemo
    Left = 0
    Top = 438
    Width = 722
    Height = 89
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 5
    Visible = False
    WantReturns = False
    WordWrap = False
  end
end
