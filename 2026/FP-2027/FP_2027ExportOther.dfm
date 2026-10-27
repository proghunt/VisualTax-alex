object ExportOtherFP_2012: TExportOtherFP_2012
  Left = 157
  Top = 129
  BorderStyle = bsDialog
  Caption = 'Export other files '
  ClientHeight = 260
  ClientWidth = 403
  Color = 14933196
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 16
    Top = 112
    Width = 114
    Height = 15
    Caption = 'Destination Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 72
    Top = 144
    Width = 57
    Height = 15
    Caption = 'File Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 32
    Top = 48
    Width = 310
    Height = 16
    Caption = 'This facility exports any file from your computer'
  end
  object Label2: TLabel
    Left = 48
    Top = 88
    Width = 89
    Height = 15
    Caption = 'Export to Branch'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 403
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Export miscellaneous files'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object CancelBtn: TBitBtn
    Left = 216
    Top = 192
    Width = 73
    Height = 31
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Kind = bkCancel
    Margin = 2
    NumGlyphs = 2
    ParentFont = False
    Spacing = -1
    TabOrder = 4
    OnClick = CancelBtnClick
  end
  object OKBtn: TBitBtn
    Left = 120
    Top = 192
    Width = 73
    Height = 33
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = OKBtnClick
  end
  object FilesOutBox: TEdit
    Left = 144
    Top = 112
    Width = 193
    Height = 23
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object FlNameBox: TEdit
    Left = 144
    Top = 144
    Width = 193
    Height = 23
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object BranchListBox: TComboBox
    Left = 144
    Top = 80
    Width = 89
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'BranchListBox'
    OnChange = BranchListBoxChange
  end
  object OpenDialog1: TOpenDialog
    Left = 24
    Top = 128
  end
end
