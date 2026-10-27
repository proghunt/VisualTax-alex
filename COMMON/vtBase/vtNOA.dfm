object frmNOA: TfrmNOA
  Left = 0
  Top = 0
  Caption = 'NOA'
  ClientHeight = 628
  ClientWidth = 897
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 897
    Height = 628
    ActivePage = tsWork
    Align = alClient
    TabOrder = 0
    object tsStart: TTabSheet
      Caption = 'tsStart'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        889
        600)
      object lblStart: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 30
        Width = 829
        Height = 540
        Margins.Left = 30
        Margins.Top = 30
        Margins.Right = 30
        Margins.Bottom = 30
        Align = alClient
        Caption = 
          'You are about to be redirected to a secure Canada Revenue Agency' +
          ' (CRA) service that allows authorized representatives to request' +
          ' the electronic delivery of the Notice of Assessment. '#13#10' '#13#10#13#10'To ' +
          'use this service you must have the following: '#13#10#183'     A CRA or S' +
          'ign-In partner credential '#13#10#183'     A completed  E-authorization w' +
          'eb submission for Authorization or Cancelling a Representative  ' +
          '      via the Represent a Client portal or through the EFILE sof' +
          'tware '#13#10#183'     A completed T183 with the Delivery of your Notice ' +
          'of Assessment section filled out and/or'#13#10'      your client has r' +
          'egistered for Email notifications '#13#10' '#13#10#13#10'See the Terms and Condi' +
          'tions of Use for more details.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitWidth = 827
        ExplicitHeight = 299
      end
      object btnContinue: TButton
        Left = 581
        Top = 561
        Width = 195
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'I agree, Continue'
        TabOrder = 0
        OnClick = btnContinueClick
      end
      object btnCancel: TButton
        Left = 797
        Top = 561
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
    object tsWork: TTabSheet
      Caption = 'tsWork'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pgcWizard: TPageControl
        Left = 0
        Top = 0
        Width = 889
        Height = 559
        ActivePage = tsProcess
        Align = alClient
        TabOrder = 0
        object tsSelectReturn: TTabSheet
          Caption = 'Select Return'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Label1: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 121
            Height = 25
            Align = alTop
            Alignment = taCenter
            Caption = 'Select return'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -21
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object grClients: TDBGrid
            Left = 0
            Top = 72
            Width = 881
            Height = 459
            Align = alClient
            DataSource = dsClients
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDblClick = btnNextClick
            OnKeyPress = grClientsKeyPress
            OnTitleClick = grClientsTitleClick
          end
          object Panel2: TPanel
            Left = 0
            Top = 31
            Width = 881
            Height = 41
            Align = alTop
            TabOrder = 1
            object Label3: TLabel
              Left = 16
              Top = 16
              Width = 28
              Height = 13
              Caption = 'Filter:'
            end
            object edFilter: TEdit
              Left = 50
              Top = 14
              Width = 311
              Height = 21
              TabOrder = 0
              OnChange = edFilterChange
              OnKeyPress = grClientsKeyPress
            end
          end
        end
        object tsProcess: TTabSheet
          Caption = 'tsProcess'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object GroupBox1: TGroupBox
            Left = 0
            Top = 0
            Width = 881
            Height = 177
            Align = alTop
            Caption = 'Return Info'
            TabOrder = 0
            object vlReturnInfo: TValueListEditor
              Left = 2
              Top = 15
              Width = 877
              Height = 160
              Align = alClient
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goAlwaysShowEditor, goThumbTracking]
              TabOrder = 0
              TitleCaptions.Strings = (
                'Field'
                'Value')
              ColWidths = (
                166
                705)
            end
          end
          object mmoLog: TMemo
            Left = 0
            Top = 280
            Width = 881
            Height = 251
            Align = alClient
            TabOrder = 1
          end
          object Panel3: TPanel
            Left = 0
            Top = 177
            Width = 881
            Height = 73
            Align = alTop
            TabOrder = 2
            DesignSize = (
              881
              73)
            object Label2: TLabel
              Left = 28
              Top = 49
              Width = 42
              Height = 13
              Caption = 'NOA key'
            end
            object btnExecuteNOA: TButton
              Left = 448
              Top = 6
              Width = 335
              Height = 42
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Request the electronic delivery of NOA'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnExecuteNOAClick
            end
            object chbAutoClose: TCheckBox
              Left = 135
              Top = 4
              Width = 237
              Height = 17
              Caption = 'Close CRA webpage after authorization'
              Checked = True
              State = cbChecked
              TabOrder = 1
            end
            object rgTestOrProd: TRadioGroup
              Left = 3
              Top = 3
              Width = 110
              Height = 41
              Columns = 2
              ItemIndex = 0
              Items.Strings = (
                'Prod'
                'Test')
              TabOrder = 2
            end
            object chbAutoSaveToMobileDB: TCheckBox
              Left = 135
              Top = 28
              Width = 266
              Height = 17
              Caption = 'Automatically save the result to a mobile database.'
              Checked = True
              State = cbChecked
              TabOrder = 3
            end
            object edNOAKey: TEdit
              Left = 91
              Top = 48
              Width = 386
              Height = 21
              TabOrder = 4
            end
          end
          object pnlViewOld: TPanel
            Left = 0
            Top = 250
            Width = 881
            Height = 30
            Align = alTop
            TabOrder = 3
            DesignSize = (
              881
              30)
            object btnViewOld: TButton
              Left = 503
              Top = -1
              Width = 258
              Height = 25
              Anchors = [akLeft, akTop, akRight]
              Caption = 'View NOA from 21/01/2017'
              TabOrder = 0
              OnClick = btnViewOldClick
            end
          end
        end
        object tsFinish: TTabSheet
          Caption = 'tsFinish'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object lblFinish: TLabel
            AlignWithMargins = True
            Left = 30
            Top = 30
            Width = 820
            Height = 184
            Margins.Left = 30
            Margins.Top = 30
            Margins.Right = 30
            Margins.Bottom = 30
            Align = alClient
            Caption = 
              '  The <tax year> tax return for <taxpayer name> has been assesse' +
              'd. To view your clients most recent assessment/reassessment deta' +
              'ils, login to the Express NOA service within your software.  '#13#10#13 +
              #10'  The same selection criteria for verifying income tax returns ' +
              'are used for both paper and electronic versions. Your client nee' +
              'ds to keep all tax information slips and documents for six years' +
              ' after you filed the tax return. Please keep this confirmation n' +
              'umber and DCN for your records: #######- #############'#13#10
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -21
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object lblHTMLPath: TLabel
            Left = 0
            Top = 508
            Width = 6
            Height = 23
            Align = alBottom
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 559
        Width = 889
        Height = 41
        Align = alBottom
        TabOrder = 1
        DesignSize = (
          889
          41)
        object btnPrev: TButton
          Left = 629
          Top = 8
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '<<< Prev'
          TabOrder = 0
          OnClick = btnPrevClick
        end
        object btnNext: TButton
          Left = 718
          Top = 8
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Next >>>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnNextClick
        end
        object btnCancel2: TButton
          Left = 805
          Top = 8
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Cancel'
          TabOrder = 2
          OnClick = btnCancel2Click
        end
      end
    end
  end
  object conClients: TADConnection
    Left = 461
    Top = 379
  end
  object tblClients: TADTable
    OnFilterRecord = tblClientsFilterRecord
    Connection = conClients
    Left = 573
    Top = 379
  end
  object dsClients: TDataSource
    DataSet = tblClients
    Left = 529
    Top = 379
  end
end
