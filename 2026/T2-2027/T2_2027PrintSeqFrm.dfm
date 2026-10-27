object PrintSeqFrmT2_2027: TPrintSeqFrmT2_2027
  Left = 453
  Top = 198
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  Caption = 'Print Sequence'
  ClientHeight = 743
  ClientWidth = 417
  Color = 13353654
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label3: TLabel
    Left = 21
    Top = 70
    Width = 294
    Height = 15
    Caption = 'Drag and drop with your mouse Or Double Click a line'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 28
    Top = 133
    Width = 58
    Height = 16
    Caption = 'Sequence'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 161
    Top = 133
    Width = 30
    Height = 16
    Caption = 'Form'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 21
    Top = 84
    Width = 191
    Height = 15
    Caption = 'If List is empty, click Exit and repeat'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 417
    Height = 25
    Align = alTop
    Caption = 'Print Sequence of forms'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object TextRelatedPanel: TPanel
    Left = 0
    Top = 25
    Width = 417
    Height = 43
    Align = alTop
    TabOrder = 1
    object Label2: TLabel
      Left = 12
      Top = 1
      Width = 249
      Height = 14
      Caption = 'Print Sequence Text file used for production printing'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object FlBox: TEdit
      Left = 12
      Top = 14
      Width = 388
      Height = 22
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object PrintBtn: TBitBtn
      Left = 406
      Top = 14
      Width = 15
      Height = 22
      Caption = '&Print Form Print Schedule'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Visible = False
      OnClick = PrintBtnClick
    end
  end
  object ListBox1: TListBox
    Left = 21
    Top = 154
    Width = 372
    Height = 582
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnDblClick = ListBox1DblClick
    OnDragDrop = ListBox1DragDrop
    OnDragOver = ListBox1DragOver
    OnKeyDown = ListBox1KeyDown
    OnMouseDown = ListBox1MouseDown
  end
  object CancelBtn: TBitBtn
    Left = 245
    Top = 105
    Width = 85
    Height = 27
    Caption = 'E&xit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object FindBtn: TBitBtn
    Left = 245
    Top = 133
    Width = 85
    Height = 18
    Caption = 'Find Form'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = FindBtnClick
  end
  object SaveBtn: TBitBtn
    Left = 77
    Top = 105
    Width = 117
    Height = 25
    Caption = '&Save/Apply'
    TabOrder = 5
    OnClick = SaveBtnClick
  end
  object PrintDialog1: TPrintDialog
    Left = 350
    Top = 112
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=C:\t1\t1fees.db')
    Left = 185
    Top = 185
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'T1Scr'
    TableName = 'T1Scr'
    Left = 256
    Top = 224
  end
end
