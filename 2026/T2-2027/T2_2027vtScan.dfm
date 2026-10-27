object VtScanT2_2027: TVtScanT2_2027
  Left = 305
  Top = 183
  Caption = 'vtSCAN'
  ClientHeight = 501
  ClientWidth = 778
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SourceImageBox: TEdit
    Left = 133
    Top = 133
    Width = 589
    Height = 23
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object StartBtn: TBitBtn
    Left = 203
    Top = 455
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 6
    OnClick = StartBtnClick
  end
  object StaticText1: TStaticText
    Left = 14
    Top = 133
    Width = 88
    Height = 17
    Caption = 'Source Device'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object ExitBtn: TBitBtn
    Left = 483
    Top = 455
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 8
    OnClick = ExitBtnClick
  end
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 778
    Height = 120
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.StartColor = 7829248
    Gradient.Visible = True
    Legend.Visible = False
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 10
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = 12971774
    Title.Font.Height = -27
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      '  '
      '')
    AxisVisible = False
    Chart3DPercent = 1
    View3DOptions.HorizOffset = -1257
    View3DOptions.VertOffset = -365
    View3DOptions.Zoom = 1
    View3DWalls = False
    Zoom.AnimatedSteps = 9
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 9
    ColorPaletteIndex = 13
    object Label4: TLabel
      Left = 141
      Top = 0
      Width = 10
      Height = 120
      Align = alLeft
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -40
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      ExplicitHeight = 45
    end
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 141
      Height = 120
      Align = alLeft
      Picture.Data = {
        0A544A504547496D616765850B0000FFD8FFE000104A46494600010100000100
        010000FFDB004300090607080706090807080A0A090B0D160F0D0C0C0D1B1415
        1016201D2222201D1F1F2428342C242631271F1F2D3D2D3135373A3A3A232B3F
        443F384334393A37FFDB0043010A0A0A0D0C0D1A0F0F1A37251F253737373737
        3737373737373737373737373737373737373737373737373737373737373737
        37373737373737373737373737FFC0001108006D007C03012200021101031101
        FFC4001C0000020301010101000000000000000000000503040607010208FFC4
        0049100001030203040408080A0B000000000001020304000506112112314161
        13225171142336738191A1B107163242525562D1152533639294B2C1E1F02434
        3543444553548493D2FFC4001A01000203010100000000000000000000000203
        0001040507FFC400301100010400040207090101000000000000010002031104
        12213141512232426171C1E1051314728191A1B1F03392FFDA000C0301000211
        0311003F00EE1471A2A9CC94504B6D1EB7157655816A89A533F25B67427357D1
        1549C9CEABE4E481CB5AAD453430042495217DD3BDC5FAE80FBC9DCE2BD273A8
        5C5A1A6D4E38B4A10919A94A3900399A8E2CA8F311B711F6DF49E2DA82BDD574
        15262DCF713F940143D46AEB2FB6F0EA1D7883BC5510C36D23A492A000E19E40
        779AA126F701ACD2D488E0F625C4FDF4A716F05775BAD015246F501E9AF41077
        1CEB093AEFB79EC2811DA0D247AE4EB6ADA6DD5A15DA951069264012CCE02EAD
        5ED730858DEE109603EA129AE2973457A15F7E75B9B0E20817D64AA1B993A91E
        3195E8B47A388E62ADB235C8D92B5FA04D68A28E34698BDA2BC145451432DEE8
        5A247CA3A0A4AFBED476CB921D43681BD4E2801EB357AE0BDA7F678247B6925F
        E0439F6E5A2E0B0D348EB874A80E8CF6E669AD141013652BB8634B646CD31B6E
        5AFEC0D94FACFEE06B3B371ADD1FCC470D464FD84ED2BD67EEA5E8B0CC92E3A6
        DE9325849F16E14F465C1C81A5F2633F11DE8A532E32BFA2E24A4D2F3E6D8AA6
        3D8EBCA6E9492E74C9E7665C879FCCE895A8A813C853189756F0CA16DDA9A6DF
        BCAD3B2EC873ACD441F4523E72BB4EEE1AEB49D0B536769072565A1E239D4690
        942721901549898B37DB9991D35CDD17339E7B32370EE03202B536BC5D677548
        625401156AD33090A48E7C0E5E835934DB65743D3BE8F0763FD47F34E7DC379F
        555611B6A4B694216FBCA3E25A3A6BDA40DDEDA8D7EB412848C738B46B4BAC3D
        6AB7CB6C292D206D0CC2DBD33F5564F1458A4DA9A12DA25E86AD36F8B67B15F7
        D6AF0F45950ED4CB335C0B78665596E19EB953C8886E4B0F459084B8D2D39290
        A19820E84514B187B6F8A17C61FA2E10F49CF8D7C43B8CA8131B950DD534F367
        34A87BB98E54CB18D89787EF4E45054A8EB1D230B3C50781E6377B78D22AE61B
        05735D99AEA3B85DE70862367115B03E004496FAAFB43E6ABB47234F81075041
        15F9CEDF26632E2998321E64C801B5F44B29DA1D872AEF386A22E0D962B0E13B
        496C69D832D056C89E5E355D2825320D782675ED795ED353D267CED485E7F4C8
        F6D728BCDDA75C66132544742B394709C83647D93BCF33AF7575790327DC1F68
        D23BD61C8375CDC7105A91C1E6F43E9EDA6B9B98525E9B1596B2E2FE83A921B0
        523452D037778DE2B5D1AE56DBBC7D95F42F3677A560287A8EEAC1DE30B4F86A
        2E2DA5484277488FA2C0E637D26614EB0EED33246D27B7C5AC7A777B29018E8F
        46E9DDC166F840CFF135DDC3D3FB45D26660FB2CACD4DB4B8E4F161790F51CC5
        5299F8130C340C68E95CA3A214AEBB8A3C89DDE8C852163145C586CB2A4F48A5
        0EA15687D396847AA9527C2EE53836C672263BBD677247EE1FCF69A84BDDA557
        F704392790E57F4471D77F0F552CB9736ED3D29C8BD2D67C5B49F92DF3FE3FC8
        DD618C36D5A1BE99F21D9AB1D770F0E42A5C378798B331B4727252FF0028E91E
        C1CA9DD398C0D1A2D2D6B58DCAD1411534327A6210A09514900919807BA94622
        251629CA1A10C920D4D0308595E8319D722B8A5ADA4A947C21CD49009F9D4324
        8E07280B6C504462F7B2388D6B417C01E639AC4636B1E299127C2272CCF65BCF
        A32CA400807B10376E1DB58852548514AD252A1A10464457753832C3FED1CFD6
        5DFF00D55791F07F871FCCF81B885FD24C8733F6AAB1BA17137E7E8B2CF82C39
        05D1BDD7DE07EF315CEBE0EED3F846FA85B83C533D635DB011A0195646D9F079
        64845D2E21D7D4B3A28BCB4903B342295E2DB1376C976B4D816B8725D5B8A0E1
        756BD509CC0D49D378F4F1A2B744DD96CC060A190362CE438DF0D36BDEEFF0BA
        20A2B3584B130BC2570E72046BAC7D1E60E9B5F693CBF9DD5A5A735C1C2C209E
        092090C720A23FBEC96DC5BD9742F8287B4554A6F21A0F3453C7783CE94A8149
        208C88DE2B430D8599C1794B2E761B6DCC13263276F8388EAA87A4533A2890AC
        1CFC0F29BCC5BA60536ADE87B423D5BEB4B87AC31ECB1B651D77D7AB8E9DEA34
        DE8AA0D015D94543354510DF524E4434A20FA0D4D505C3FA849F34BF71AA7754
        A38BAEDF15CEB0BC7B86247AE087EF4FC66A337D228EC170286673D331D94D05
        92E4E3F67F02C4D21D83712A4A1EE8D4828294950EA156EEA91C292E06C4112C
        122ECB96E2D0B799D964A51B5D604FF0A8ECD8BE5BB89ADD3F104D75D62295E5
        9207573411A252071CAB86D7C795B9B73DFDFE3C97A1CF87C59965310018D1A0
        A1A9CA76E8EA6EB8F7514EEE76AB83502E322D58A5E9CEDB5444A60A14DA9196
        79EF51CF71E4723AD4922D8EC1830A4DC7174E60CA643A94A6238E65A02754A8
        EECF8D55B8625B042857E3675CB9332F255D274A80943615B59E5C7E79EDE150
        622C6CE2ED76B8B629AF35D1C5E8A527A3C813B291C46BC688BA3166FF00279F
        8F259E3871B216B436813B96B41ACA0EBD135ADD69AAB1F063769F371496654C
        79E6FC1DC212B59237A75CAB798AACF3EE4EC07ED8EC643B154B3FD236B64ED0
        03E6FA6B9AFC127959FF0015CF7A6BB32975A30A33C34E5C9F6E3CE1BDA39A20
        0501C34D6C2E1174BB5FD531B96AB3CA8F2222894CA662389200ED24E453DFFB
        CD768C3D72374B3C596E001C5A06DE4321B596B972CEA3C40B26C93C67FE1D7E
        E354F02F93517BA9913323C8BDD62C7628E270ED7168194D69E16B4755A5C50F
        7591A2FDF5668AD20D2E4248A494A8A54082381AF29CBACA1D192D39F3E22A9B
        96F3FDDAC772A981E1016954A8AB061BE3E683DC450213E77A40EF345982AA2A
        BD7A964BF9B610161432208D32E7579B8037B8BCF926ADA1096D3B2848039509
        78E0AC02B278930DD9A2E1BB83CDDB2107D2C95070309041E472D2AFDB70D589
        76E8AB5D9ADEA52994124C64124EC8E553E30F262E5E61557AD5FD990FCC23F6
        4565CADF7874E0BA66797E141CC7AC789E4153F8B160FA92DDFAAA3EEAF0E19C
        3E3FC92DDFAAA3EEA6AA565512974595BC96713CC7B67EE5528968B5407BA783
        6D891DDD929DB6584A5591E19815654BAF95AEA15AEA683657D279B71B552FCA
        CECD387E617EE351605F26A2F75797C567689BE617EE35EE04F2662F750B7AFF
        0044F9456147CDE4B47DB471A28A6AE7A28A28A8A238D145151445145151449F
        18793172F30AAB56D5656C89E611FB22AAE30F262E5E615524057E2E89E61BFD
        914BEDFD16D02F0A3E63FA0ADAD750A975F2B5D44A5D4250358BD52EA252EBE5
        4BA854BA1253DAC55AF2AFC55307E657EEAB1813C998BDD546EEACED92FCCABD
        D57702F93317BAA99D7FA23C50AC30F9BC96928E3476D1C69EB968A28A2A288A
        28E34545114514545127C61E4C5CBCC2ABE60A8FE0F8BA1FC82387D914CA7C46
        A7C2762C804B4EA7655B2723956555822321452C5C67B6D8F929E949CA94E0EC
        D616F82487DCE490906EF6BE03BC724E96A3D86A1528F61A53F12DBFAD677FD9
        47C4A6BEB49DFA7434FE5F94D0FC28ED9FF9F54C56A3D86A1528D53F894D7D69
        3BF4E8F892D7D693BF4EAB2BF92313614768FDBD57CDD544DBA579A57BA99E04
        F26627752D560761492955CE69046446DD69AC96D6ED76E6A234B5290DE80AB7
        D146C707594AC5E2217C41919275BDABCD7FFFD9}
      Transparent = True
    end
    object Label1: TLabel
      Left = 175
      Top = 70
      Width = 525
      Height = 31
      Alignment = taCenter
      Caption = 'client documents for a green, paperless office'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 336
      Top = 21
      Width = 172
      Height = 45
      Alignment = taCenter
      Caption = 'vtSCAN...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -40
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object StaticText3: TStaticText
    Left = 14
    Top = 162
    Width = 36
    Height = 17
    Caption = 'Client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
  end
  object StaticText4: TStaticText
    Left = 14
    Top = 191
    Width = 114
    Height = 17
    Caption = 'Document category'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
  end
  object DocCategoryBox: TEdit
    Left = 133
    Top = 191
    Width = 232
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = DocCategoryBoxChange
  end
  object ClientNameBox: TEdit
    Left = 133
    Top = 162
    Width = 589
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
  object StaticText6: TStaticText
    Left = 378
    Top = 191
    Width = 204
    Height = 17
    Caption = '(... or any specific category of your choice)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
  end
  object FlNameBox: TEdit
    Left = 133
    Top = 413
    Width = 589
    Height = 23
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object StaticText7: TStaticText
    Left = 8
    Top = 413
    Width = 103
    Height = 17
    Caption = 'Scan to file name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
  end
  object ListDocsbtn: TBitBtn
    Left = 301
    Top = 455
    Width = 134
    Height = 25
    Caption = 'Show Documents List'
    TabOrder = 14
    OnClick = ListDocsbtnClick
  end
  object StaticText2: TStaticText
    Left = 14
    Top = 220
    Width = 230
    Height = 17
    Caption = 'Multiple documents in scanner for ADF?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 15
  end
  object UseADFBtn: TCheckBox
    Left = 259
    Top = 220
    Width = 22
    Height = 17
    TabOrder = 3
  end
  object ScanFormatBox: TRadioGroup
    Left = 28
    Top = 243
    Width = 267
    Height = 36
    Caption = ' General Purpose Cases - Scan Format'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemIndex = 0
    Items.Strings = (
      'PDF'
      'TIF')
    ParentFont = False
    TabOrder = 4
    OnClick = ScanFormatBoxClick
  end
  object EnableduplexLbl: TStaticText
    Left = 301
    Top = 220
    Width = 122
    Height = 17
    Caption = 'Enable duplex scan?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 16
  end
  object EnableDuplexBox: TCheckBox
    Left = 427
    Top = 220
    Width = 22
    Height = 17
    TabOrder = 17
  end
  object GroupBox1: TGroupBox
    Left = 28
    Top = 299
    Width = 602
    Height = 94
    Caption = 'SIGNATURE'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 18
    object E_SIGNATUREHOLDER: TImage
      Left = 189
      Top = 42
      Width = 330
      Height = 27
    end
    object EnlargeBtn: TBitBtn
      Left = 560
      Top = 11
      Width = 29
      Height = 22
      Caption = 'Enlarge'
      TabOrder = 0
      Visible = False
    end
    object RotateBtn: TBitBtn
      Left = 560
      Top = 39
      Width = 36
      Height = 22
      Caption = 'Rotate'
      TabOrder = 1
      Visible = False
    end
    object SignatureBox: TCheckBox
      Left = 13
      Top = 19
      Width = 457
      Height = 17
      Caption = 
        'SIGNATURE (Insert document with Signature and then Crop and resi' +
        'ze)  '
      TabOrder = 2
    end
    object ShowSignatureBtn: TBitBtn
      Left = 35
      Top = 42
      Width = 106
      Height = 22
      Caption = 'Show Signature'
      TabOrder = 3
      OnClick = ShowSignatureBtnClick
    end
  end
  object OpenDialog: TOpenDialog
    Left = 721
    Top = 63
  end
end
