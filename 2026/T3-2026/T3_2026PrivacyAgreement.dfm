object PrivacyAgreementT3_2026: TPrivacyAgreementT3_2026
  Left = 366
  Top = 183
  BorderIcons = [biSystemMenu]
  Caption = 'Terms, Conditions, Privacy'
  ClientHeight = 574
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object headerPanel: TPanel
    Left = 0
    Top = 0
    Width = 670
    Height = 78
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object formHeaderLbl: TLabel
      Left = 14
      Top = 42
      Width = 155
      Height = 19
      Caption = '**dynamically filled**'
    end
    object Label2: TLabel
      Left = 14
      Top = 14
      Width = 290
      Height = 19
      Caption = 'Terms, Conditions, and Privacy Notice'
    end
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 78
    Width = 670
    Height = 419
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Terms and Conditions'
      ''
      
        'To proceed with filing your electronic Corporation Foreign Repor' +
        'ting via this transmission Web service, you'
      'must agree to the following terms and conditions:'
      ''
      
        '-  I may file a Corporation Foreign Reporting using this Web ser' +
        'vice only for the Corporation to which I'
      
        'am an authorized officer or representative for the corporation t' +
        'o which a Web Access Code has'
      
        'been assigned or for my client if I am a registered tax professi' +
        'onal with EFILE On-Line.'
      ''
      
        '-  I may only file an initial or amended, eligible, 2016 or subs' +
        'equent year Corporation Foreign'
      'Reporting through this filing Web service.'
      ''
      
        '-  I understand that I will not be able to use this Web service ' +
        'to file an initial or amended return for'
      'year prior to the 2016 tax year.'
      ''
      
        '-  I understand and agree that I cannot change the Corporation'#39's' +
        ' name, and head office or mailing'
      
        'address with a tax return filed through this Web service. All ch' +
        'anges must be made in My Business'
      'Account prior to the transmission of the return.'
      ''
      
        '-  I understand that I cannot add or change direct deposit infor' +
        'mation with a tax return filed through'
      'this Web service.'
      ''
      
        '-  I will not attempt to disrupt this Web service by uploading f' +
        'iles other than the eligible Corporation'
      
        'Foreign reporting. If I do, the Canada Revenue Agency (CRA) will' +
        ' deny me access to electronic'
      'services.'
      ''
      
        '-  I certify that the attached electronic tax return is complete' +
        ' and accurate, and that it reports the'
      
        'Corporation'#39's foreign income from all sources. Or, if filing on ' +
        'behalf of a client, my client has signed'
      
        'the proper Form T183 and certified that the attached electronic ' +
        'return is correct, complete, and'
      'reports the client'#39's foreign income from all sources.'
      ''
      '-  I have read the Privacy notice statement below:'
      ''
      'Limitation of liability'
      
        'CRA uses sophisticated security techniques to protect its Intern' +
        'et filing Web services. You'#39're responsible for'
      
        'ensuring that your own computer is secure. While the CRA has tak' +
        'en all reasonable efforts to ensure the'
      
        'security of information in transit to the CRA, it is not liable ' +
        'for any damages that may arise as the result of'
      
        'interception, loss, or other action or difficulty. You should al' +
        'so make sure your return was completed with'
      
        'the latest version of your certified software. In some cases not' +
        ' updating your software will prevent you from'
      'being able to use this Web service.'
      ''
      'Privacy notice statement'
      
        'The information you provide is collected under the authority of ' +
        'the Income Tax Act for the purpose of secure'
      
        'transmission of electronic information returns via the Internet.' +
        ' The information will be retained in Personal'
      
        'Information Bank(s) "International and Large Business Income Tax' +
        ' Audit and Examination, CRA PPU 035 "'
      
        'and will be used and disclosed in accordance with the conditions' +
        ' listed therein. Information may also be'
      
        'used for follow-up, audit, compliance, and evaluation purposes a' +
        'nd may be shared, in accordance with the'
      
        'Income Tax Act and under existing information-sharing agreements' +
        ', with other federal institutions and'
      
        'provincial governments. Failure to provide all or parts of the r' +
        'equested information may result in penalties'
      'incurred and other non-filer actions.'
      
        'Under the provisions of the Privacy Act, individuals have the ri' +
        'ght to protection of, and access to, their'
      
        'personal information. For more information about your rights, se' +
        'e www.infosource.gc.ca. This is a'
      
        'Government of Canada publication available in major libraries, a' +
        't government information offices, and from'
      'constituency offices of federal Members of Parliament.'
      ''
      'Confirmation of receipt'
      
        'Once you file your Corporation Foreign reporting, a preliminary ' +
        'check of your return will be performed. If it'
      
        'meets the basic requirements, CRA will send you a confirmation n' +
        'umber within seconds. This means that'
      
        'your return has been accepted for processing. If there are any p' +
        'roblems with the electronic return you tried'
      
        'to send to the CRA, you will be prompted with an explanation of ' +
        'error(s) that requires corrections. This'
      
        'means that your return was not accepted by the CRA for processin' +
        'g. You can change the electronic version'
      
        'of your return and then try to send it again using the same Web ' +
        'service.'
      
        'If your return has been accepted for processing, do not submit a' +
        ' paper copy by mail. After CRA has'
      
        'processed your return, we may need to contact you to obtain supp' +
        'orting documents, so remember to keep'
      
        'your documentation for at least six years. This is part of the s' +
        'ame verification process that applies to all tax'
      'returns, whether paper or electronic.')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 497
    Width = 670
    Height = 77
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    DesignSize = (
      670
      77)
    object continueBTN: TButton
      Left = 433
      Top = 17
      Width = 225
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'I agree - File the return now.'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = continueBTNClick
    end
    object cancelBTN: TButton
      Left = 202
      Top = 17
      Width = 225
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'I disagree - Don'#8217't file the return.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
    end
    object DoNotShowAgainCheckBox: TCheckBox
      Left = 521
      Top = 48
      Width = 127
      Height = 15
      Alignment = taLeftJustify
      Anchors = [akRight, akBottom]
      Caption = 'do not show again'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
end
