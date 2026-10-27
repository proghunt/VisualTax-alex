object vtColorPatternSelect: TvtColorPatternSelect
  Left = 0
  Top = 0
  Caption = 'Color / Fill Select'
  ClientHeight = 486
  ClientWidth = 965
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 445
    Width = 965
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      965
      41)
    object btnSave: TButton
      Left = 801
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Select'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 882
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object sgCustomPatColors: TStringGrid
      AlignWithMargins = True
      Left = 7
      Top = 6
      Width = 444
      Height = 28
      ColCount = 10
      DefaultColWidth = 44
      DefaultDrawing = False
      DrawingStyle = gdsClassic
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      GridLineWidth = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine]
      ScrollBars = ssNone
      TabOrder = 2
      OnDrawCell = sgCustomPatColorsDrawCell
      OnSelectCell = sgCustomPatColorsSelectCell
    end
    object btnAddCustom: TButton
      Left = 464
      Top = 8
      Width = 140
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Add to Custom Colors'
      TabOrder = 3
      OnClick = btnAddCustomClick
    end
  end
  object pgMain: TPageControl
    Left = 0
    Top = 0
    Width = 965
    Height = 445
    ActivePage = tabBasicColor
    Align = alClient
    TabOrder = 1
    OnChange = pgMainChange
    OnResize = pgMainResize
    object tabBasicColor: TTabSheet
      Caption = 'Basic windows colors'
      ImageIndex = 2
      object pnlBasicColors: TPanel
        Left = 0
        Top = 0
        Width = 957
        Height = 417
        Align = alClient
        Constraints.MinHeight = 350
        Constraints.MinWidth = 600
        TabOrder = 0
        DesignSize = (
          957
          417)
        object pbBrightness: TPaintBox
          Left = 920
          Top = 3
          Width = 17
          Height = 318
          Anchors = [akTop, akRight, akBottom]
          Constraints.MinHeight = 240
          OnMouseDown = pbBrightnessMouseDown
          OnMouseMove = pbBrightnessMouseMove
          OnMouseUp = pbBrightnessMouseUp
          OnPaint = pbBrightnessPaint
        end
        object pbBasicColors: TPaintBox
          Left = 242
          Top = 3
          Width = 663
          Height = 318
          Anchors = [akLeft, akTop, akRight, akBottom]
          Constraints.MinHeight = 240
          Constraints.MinWidth = 240
          OnMouseDown = pbBasicColorsMouseDown
          OnMouseMove = pbBasicColorsMouseMove
          OnMouseUp = pbBasicColorsMouseUp
          OnPaint = pbBasicColorsPaint
        end
        object lbBrightness: TLabel
          Left = 939
          Top = 0
          Width = 11
          Height = 25
          Anchors = [akTop, akRight]
          Caption = #9664
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnMouseDown = lbBrightnessMouseDown
          OnMouseMove = lbBrightnessMouseMove
          OnMouseUp = lbBrightnessMouseUp
        end
        object shBasicColor: TShape
          Left = 242
          Top = 332
          Width = 121
          Height = 49
          Anchors = [akLeft, akBottom]
        end
        object lbBasicColor: TLabel
          Left = 242
          Top = 389
          Width = 25
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Color'
        end
        object lbHue: TLabel
          Left = 378
          Top = 335
          Width = 23
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Hue:'
        end
        object lbSat: TLabel
          Left = 381
          Top = 362
          Width = 20
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Sat:'
        end
        object lbLum: TLabel
          Left = 378
          Top = 389
          Width = 23
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Lum:'
        end
        object lbRed: TLabel
          Left = 466
          Top = 335
          Width = 23
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Red:'
        end
        object lbGreen: TLabel
          Left = 456
          Top = 362
          Width = 33
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Green:'
        end
        object lbBlue: TLabel
          Left = 465
          Top = 389
          Width = 24
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Blue:'
        end
        object lbBasicColorsCaption: TLabel
          Left = 12
          Top = 3
          Width = 59
          Height = 13
          Caption = 'Basic colors:'
        end
        object edHue: TEdit
          Left = 407
          Top = 332
          Width = 28
          Height = 21
          Anchors = [akLeft, akBottom]
          NumbersOnly = True
          TabOrder = 0
          OnChange = BasicColorManualHLSChange
        end
        object edSat: TEdit
          Left = 407
          Top = 359
          Width = 28
          Height = 21
          Anchors = [akLeft, akBottom]
          NumbersOnly = True
          TabOrder = 1
          OnChange = BasicColorManualHLSChange
        end
        object edLum: TEdit
          Left = 407
          Top = 386
          Width = 28
          Height = 21
          Anchors = [akLeft, akBottom]
          NumbersOnly = True
          TabOrder = 2
          OnChange = BasicColorManualHLSChange
        end
        object edBlue: TEdit
          Left = 495
          Top = 386
          Width = 28
          Height = 21
          Anchors = [akLeft, akBottom]
          NumbersOnly = True
          TabOrder = 3
          OnChange = BasicColorManualRGBChange
        end
        object edGreen: TEdit
          Left = 495
          Top = 359
          Width = 28
          Height = 21
          Anchors = [akLeft, akBottom]
          NumbersOnly = True
          TabOrder = 4
          OnChange = BasicColorManualRGBChange
        end
        object edRed: TEdit
          Left = 495
          Top = 332
          Width = 28
          Height = 21
          Anchors = [akLeft, akBottom]
          NumbersOnly = True
          TabOrder = 5
          OnChange = BasicColorManualRGBChange
        end
        object sgBasicColors: TStringGrid
          Left = 12
          Top = 22
          Width = 216
          Height = 162
          BorderStyle = bsNone
          ColCount = 8
          DefaultColWidth = 26
          DefaultRowHeight = 26
          DefaultDrawing = False
          FixedCols = 0
          RowCount = 6
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine]
          TabOrder = 6
          OnDrawCell = sgBasicColorsDrawCell
          OnSelectCell = sgBasicColorsSelectCell
        end
        object pnlDrawBackground: TPanel
          Left = 12
          Top = 362
          Width = 39
          Height = 41
          BevelOuter = bvNone
          TabOrder = 7
          Visible = False
        end
      end
    end
    object tabColor: TTabSheet
      Caption = 'Benjiamin Moore Color palette'
      object pnlColorInfo: TPanel
        Left = 0
        Top = 385
        Width = 957
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          957
          32)
        object lbColorName: TLabel
          Left = 8
          Top = 8
          Width = 72
          Height = 13
          Caption = 'Color Number: '
        end
        object Label1: TLabel
          Left = 144
          Top = 8
          Width = 26
          Height = 13
          Caption = 'Hex: '
        end
        object Label2: TLabel
          Left = 243
          Top = 8
          Width = 34
          Height = 13
          Caption = 'Name: '
        end
        object btnSearchColor: TSpeedButton
          Left = 774
          Top = 5
          Width = 179
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Search by Color Number or Name'
          OnClick = btnSearchColorClick
        end
        object meColors: TMemo
          Left = 583
          Top = 24
          Width = 185
          Height = 89
          Lines.Strings = (
            '2000-70|#FCE2E6|Voile Pink'
            '2000-60|#FFCDD8|Light Chiffon Pink'
            '2000-50|#FDACBD|Blush Tone'
            '2000-40|#F57F94|Strawberry Shortcake'
            '2000-30|#E04C5B|Red Tulip'
            '2000-20|#D33A41|Tricycle Red'
            '2000-10|#C92E2E|Red'
            '2001-70|#FEE2E7|Marshmallow Bunny'
            '2001-60|#FFCDD8|Country Pink'
            '2001-50|#FEACBD|Full Bloom'
            '2001-40|#F57E92|Pink Popsicle'
            '2001-30|#E14B5A|Spring Tulips'
            '2001-20|#D5393F|Bonfire'
            '2001-10|#CA2C2C|Ruby Red'
            '2002-70|#FDE7E8|Pink Cadillac'
            '2002-60|#FFD3D8|Sweet 16 Pink'
            '2002-50|#FFB3BD|Tickled Pink'
            '2002-40|#F88791|Flamingo'#39's Dream'
            '2002-30|#E65458|Rose Quartz'
            '2002-20|#D93E3C|Bull'#39's Eye Red'
            '2002-10|#CF312B|Vermilion'
            '2003-70|#FDE2E6|Pleasing Pink'
            '2003-60|#FECDD6|Exotic Pink'
            '2003-50|#F9ABBA|Coral Pink'
            '2003-40|#ED7E8E|True Pink'
            '2003-30|#D44C57|Berry Wine'
            '2003-20|#C33D3D|Strawberry Red'
            '2003-10|#B5332C|Million Dollar Red'
            '2004-70|#FCE3E7|Romantic Pink'
            '2004-60|#FCCCD6|Pink Parfait'
            '2004-50|#F5ACBC|Baby Girl'
            '2004-40|#E47F90|Pink Starburst'
            '2004-30|#CA4F5A|Raspberry Pudding'
            '2004-20|#B14040|Chili Pepper'
            '2004-10|#A0372F|Deep Rose'
            '2005-70|#F7E4E4|Wispy Pink'
            '2005-60|#F0CDD1|Pink Pearl'
            '2005-50|#E1ADB3|Pink Eraser'
            '2005-40|#C78086|Genuine Pink'
            '2005-30|#9C5251|Bricktone Red'
            '2005-20|#8A453E|Hot Apple Spice'
            '2005-10|#7C3E32|Red Rock'
            '2006-70|#FAE0E0|Pink Fairy'
            '2006-60|#F6C8CA|Authentic Pink'
            '2006-50|#EAA6A9|Pink Punch'
            '2006-40|#D37878|Glamour Pink'
            '2006-30|#B14C45|Rosy Apple'
            '2006-20|#A54337|Sangria'
            '2006-10|#9D3D2D|Merlot Red'
            '2007-70|#FCE1E3|Angel Pink'
            '2007-60|#FACBD0|Pastel Pink'
            '2007-50|#F2AAB3|Supple Pink'
            '2007-40|#DE7C83|Coral Essence'
            '2007-30|#BE4E4E|Rhubarb'
            '2007-20|#AE4138|Shy Cherry'
            '2007-10|#A33A2D|Smoldering Red'
            '2008-70|#FDE8E6|Touch of Pink'
            '2008-60|#FED6D5|Little Piggy'
            '2008-50|#FBB9B9|Delicate Rose'
            '2008-40|#F0908D|Hydrangea Flowers'
            '2008-30|#D75F56|Raspberry Blush'
            '2008-20|#C94F43|Claret Rose'
            '2008-10|#BD4638|Ravishing Red'
            '2009-70|#FDE7E4|Powder Pink'
            '2009-60|#FFD4D3|Pink Sea Shell'
            '2009-50|#FFB6B6|Fashion Pink'
            '2009-40|#F88A87|Pink Peach'
            '2009-30|#E75A50|Dark Salmon'
            '2009-20|#DC4739|Salsa'
            '2009-10|#D33B2B|Redstone'
            '2010-70|#FDE9E3|Frosty Pink'
            '2010-60|#FFD7D1|Rose Petal'
            '2010-50|#FFB9B3|Dawn Pink'
            '2010-40|#F98F83|Coral Gables'
            '2010-30|#E95F4D|Starburst Orange'
            '2010-20|#DF4C37|Warm Comfort'
            '2010-10|#D7402B|Tomato Red'
            '2011-70|#FDEAE6|Light Quartz'
            '2011-60|#FFD9D4|Springy Peach'
            '2011-50|#FFBEB8|Mixed Fruit'
            '2011-40|#FD988E|Old World'
            '2011-30|#F06450|Hot Spice'
            '2011-20|#E7513B|Blazing Orange'
            '2011-10|#E0412B|Orange'
            '2012-70|#FDEBE5|Soft Pink'
            '2012-60|#FFDBD4|Creamy Peach'
            '2012-50|#FFC0B7|Perky Peach'
            '2012-40|#FE9989|Summer Sun Pink'
            '2012-30|#F16750|Tangerine Dream'
            '2012-20|#E75136|Flame'
            '2012-10|#E04227|Tawny Day Lily'
            '2013-70|#FDEDE5|Bridal Pink'
            '2013-60|#FFDED3|Pink Harmony'
            '2013-50|#FFC5B5|Salmon Peach'
            '2013-40|#FF9E84|Dusk Pink'
            '2013-30|#F46F4B|Jeweled Peach'
            '2013-20|#EA5933|Orange Nectar'
            '2013-10|#E34C28|Outrageous Orange'
            '2014-70|#FDEFE2|Ecru'
            '2014-60|#FFE1CF|Whispering Peach'
            '2014-50|#FFCAB0|Springtime Peach'
            '2014-40|#FFA67E|Peachy Keen'
            '2014-30|#F77946|Tangy Orange'
            '2014-20|#EF6530|Rumba Orange'
            '2014-10|#E95823|Festive Orange'
            '2015-70|#FCF2E1|Apricot Ice'
            '2015-60|#FFE7CB|Gerbera Daisy'
            '2015-50|#FFD4AA|Funky Fruit'
            '2015-40|#FFB577|Peach Sorbet'
            '2015-30|#FB8B3C|Calypso Orange'
            '2015-20|#F57C28|Orange Burst'
            '2015-10|#F0701A|Electric Orange'
            '2016-70|#FCF3DE|Cancun Sand'
            '2016-60|#FFEAC9|Creamy Beige'
            '2016-50|#FFD8A6|Melon Popsicle'
            '2016-40|#FFBA71|Marmalade'
            '2016-30|#FC9537|Carrot Stick'
            '2016-20|#F78523|Citrus Orange'
            '2016-10|#F47C1B|Startling Orange'
            '2017-70|#FCF4DE|White Vanilla'
            '2017-60|#FFECC7|Pale Daffodil'
            '2017-50|#FFDDA6|Yellow Haze'
            '2017-40|#FFC36F|Sweet Orange'
            '2017-30|#FFA134|Tangelo'
            '2017-20|#FC931E|Sharp Cheddar'
            '2017-10|#F98A0C|Orange Juice'
            '2018-70|#FBF6DD|Milkyway'
            '2018-60|#FEF0C6|Lighthouse'
            '2018-50|#FFE4A1|Morning Sunshine'
            '2018-40|#FFCF6B|Nacho Cheese'
            '2018-30|#FFB229|Citrus Blast'
            '2018-20|#FFA706|Mandarin Orange'
            '2018-10|#FF9F00|Orange Sky'
            '2019-70|#FBF6DB|Lightning White'
            '2019-60|#FEF2C3|Lemon Sorbet'
            '2019-50|#FFE89F|Lemon Drops'
            '2019-40|#FFD766|American Cheese'
            '2019-30|#FFC21B|Sunflower'
            '2019-20|#FFB700|Golden Nugget'
            '2019-10|#FFAF00|Mardi Gras Gold'
            '2020-70|#FBF7DD|Yellow Freeze'
            '2020-60|#FFF3C4|Moonlight'
            '2020-50|#FFE99F|Mellow Yellow'
            '2020-40|#FFD867|Yellow Rain Coat'
            '2020-30|#FFC31E|Sparkling Sun'
            '2020-20|#FFB600|Lemon Shine'
            '2020-10|#FFB000|Bumble Bee Yellow'
            '2021-70|#FBF7DB|Pale Straw'
            '2021-60|#FEF4C3|Provence Cr'#232'me'
            '2021-50|#FFEC9E|Yellow Lotus'
            '2021-40|#FFDE64|Yellow Highlighter'
            '2021-30|#FFCE0B|Sunshine'
            '2021-20|#FFC400|Lemon'
            '2021-10|#FFBD00|Yellow Flash'
            '2022-70|#FAF7DC|Cr'#232'me Brulee'
            '2022-60|#FDF5C4|Light Yellow'
            '2022-50|#FFF19F|Sundance'
            '2022-40|#FFE765|Banana Yellow'
            '2022-30|#FFDB00|Bright Yellow'
            '2022-20|#FFD600|Sun Kissed Yellow'
            '2022-10|#FFD400|Yellow'
            '2023-70|#FBF8DD|Cr'#232'me Fraiche'
            '2023-60|#FCF5C4|Butter'
            '2023-50|#FEF0A1|Lemon Meringue'
            '2023-40|#FAE466|Sunburst'
            '2023-30|#F8D60A|Sun Porch'
            '2023-20|#F0CD00|Baby Chick'
            '2023-10|#ECC900|Yolk'
            '2024-70|#FAF8E0|Lemon Ice'
            '2024-60|#FAF4C8|Lemonade'
            '2024-50|#F6ECA9|Jasper Yellow'
            '2024-40|#ECDC71|Yellow Finch'
            '2024-30|#D7C52E|Citron'
            '2024-20|#CCBB0E|Eve Green'
            '2024-10|#C1B400|Chartreuse'
            '2025-70|#F7F8DB|Barely Yellow'
            '2025-60|#F7F6C3|Lemon Glow'
            '2025-50|#F0F09F|Lemon Freeze'
            '2025-40|#E1E465|Limelight'
            '2025-30|#D2D612|New Lime'
            '2025-20|#C3CF00|Yew Green'
            '2025-10|#B4CA00|Bright Lime'
            '2026-70|#F7F8DC|Eggshell'
            '2026-60|#F3F5C5|Summer Lime'
            '2026-50|#E7EFA0|Fresh Cut Grass'
            '2026-40|#D2E169|Apple Green'
            '2026-30|#BDD120|Snow Cone Green'
            '2026-20|#A4C700|Margarita'
            '2026-10|#97C100|Lime Green'
            '2027-70|#F5F6DB|Aspen White'
            '2027-60|#F2F2C3|Light Daffodil'
            '2027-50|#E8E99F|Hibiscus'
            '2027-40|#D5D869|Grape Green'
            '2027-30|#BFC428|Eccentric Lime'
            '2027-20|#ABB915|Spring Moss'
            '2027-10|#99B009|Dark Lime'
            '2028-70|#F4F6DD|Seahorse'
            '2028-60|#EDF1C7|Celadon Green'
            '2028-50|#DDE5A3|Wales Green'
            '2028-40|#C3D16F|Pear Green'
            '2028-30|#A6BA32|Tequila Lime'
            '2028-20|#88AA27|Douglas Fir'
            '2028-10|#79A21E|Iguana Green'
            '2029-70|#F0F5DE|Frosty Lime'
            '2029-60|#E4EEC8|Pale Vista'
            '2029-50|#CDDFA7|Potpourri Green'
            '2029-40|#ACC774|Stem Green'
            '2029-30|#7BA640|Rosemary Green'
            '2029-20|#669A30|Baby Fern'
            '2029-10|#569128|Basil Green'
            '2030-70|#ECF7E0|Iced Mint'
            '2030-60|#DBF3CB|Celery Ice'
            '2030-50|#BFE8AA|Shimmering Lime'
            '2030-40|#97D477|Spring Leaf'
            '2030-30|#61B83E|Lucky Charm Green'
            '2030-20|#48AB2C|Tropical Seaweed Green'
            '2030-10|#33A122|Lizard Green'
            '2031-70|#EFF8DF|Lime Froth'
            '2031-60|#E1F3C9|Neon Celery'
            '2031-50|#CBEAA7|Key Lime'
            '2031-40|#A7D873|Spring Meadow Green'
            '2031-30|#78BF38|Sweet Pea'
            '2031-20|#62B424|Paradise Green'
            '2031-10|#50AB18|Neon Lime'
            '2032-70|#E7F6E1|Lime Sorbet'
            '2032-60|#D5F2CE|Citra Lime'
            '2032-50|#B6E6AF|Early Spring Green'
            '2032-40|#88D17E|Citrus Green'
            '2032-30|#4EB245|Fresh Lime'
            '2032-20|#32A431|Traffic Light Green'
            '2032-10|#169928|Neon Green'
            '2033-70|#E3F6E5|Sweet Honeydew Melon'
            '2033-60|#CBF0D2|Mantis Green'
            '2033-50|#A6E3B5|Bud Green'
            '2033-40|#72CC88|Lime Tart'
            '2033-30|#31AA50|Fresh Scent Green'
            '2033-20|#00983C|Peppermint Leaf'
            '2033-10|#008A31|Yellow Green'
            '2034-70|#E5F1E2|Daiquiri Ice'
            '2034-60|#CFE6CE|Light Pistachio'
            '2034-50|#AED2B0|Acadia Green'
            '2034-40|#7FB37F|Cedar Green'
            '2034-30|#448C4E|Grassy Fields'
            '2034-20|#2F7D3F|Vine Green'
            '2034-10|#207337|Clover Green'
            '2035-70|#E1F0E4|Italian Ice Green'
            '2035-60|#C8E3D2|Leisure Green'
            '2035-50|#A3CDB5|Spruce Green'
            '2035-40|#71AD87|Stokes Forest Green'
            '2035-30|#348354|Nile Green'
            '2035-20|#227442|Cactus Green'
            '2035-10|#136938|Seaweed'
            '2036-70|#E2F5E9|Cr'#232'me de Mint'
            '2036-60|#C9ECDA|Surf Green'
            '2036-50|#A4DCC1|Marina Bay'
            '2036-40|#75C099|Meadowlands Green'
            '2036-30|#429565|Green with Envy'
            '2036-20|#347E50|Irish Moss'
            '2036-10|#2F6F46|Cat'#39's Eye'
            '2037-70|#DCF6E9|Fresh Mint'
            '2037-60|#C0EFDB|Santa Barbara Green'
            '2037-50|#94E1C2|Greenwood Lake'
            '2037-40|#53C799|Adam Green'
            '2037-30|#00A162|Kelly Green'
            '2037-20|#00874A|Jade Green'
            '2037-10|#00703A|Amazon Moss'
            '2038-70|#DCF6EB|Irish Spring'
            '2038-60|#BFEDDE|Tropical Pool'
            '2038-50|#95DDC7|Return to Paradise'
            '2038-40|#5BC2A2|Monmouth Green'
            '2038-30|#0A976D|Prairie Green'
            '2038-20|#007C56|Irish Clover'
            '2038-10|#0C6546|Celtic Green'
            '2039-70|#D8F6EC|Refreshing Teal'
            '2039-60|#B8EEE0|Seafoam Green'
            '2039-50|#85DFCB|Mermaid Green'
            '2039-40|#35C6A8|Teal Blast'
            '2039-30|#009E75|Cabana Green'
            '2039-20|#008158|Emerald Isle'
            '2039-10|#006242|Deep Green'
            '2040-70|#D9EDE7|Spring Mint'
            '2040-60|#BFE0D7|Antiguan Sky'
            '2040-50|#92C6BB|Hazy Blue'
            '2040-40|#5CA492|Summer Basket Green'
            '2040-30|#17775C|Very Green'
            '2040-20|#0A6548|Green Meadows'
            '2040-10|#105A3C|Rainforest Foliage'
            '2041-70|#DEF4ED|Irish Mint'
            '2041-60|#C2E8E0|Soft Mint'
            '2041-50|#9AD5CB|Sea Mist Green'
            '2041-40|#65B4A5|Juneau Spring'
            '2041-30|#34816F|Green Gables'
            '2041-20|#296253|Fiddlehead Green'
            '2041-10|#2A453D|Hunter Green'
            '2042-70|#D8F5EC|Minty Green'
            '2042-60|#B8EEE1|Florida Aqua'
            '2042-50|#86DECD|Caribe Green'
            '2042-40|#3DC6AB|Miami Green'
            '2042-30|#009D7B|Hummingbird Green'
            '2042-20|#007E5D|Reef Green'
            '2042-10|#006047|True Green'
            '2043-70|#D7F4EC|Frosty Mint'
            '2043-60|#B8EBE1|Summer Green'
            '2043-50|#89DCCD|South Beach'
            '2043-40|#45C1AC|Egyptian Green'
            '2043-30|#00967A|Kelp Forest Green'
            '2043-20|#00745D|Ming Jade'
            '2043-10|#055143|Absolute Green'
            '2044-70|#D3F4EB|Light Touch'
            '2044-60|#B3EDE1|Crystal Clear'
            '2044-50|#7EDECD|Bermuda Teal'
            '2044-40|#25C7AF|Amelia Island Blue'
            '2044-30|#009F7E|St. Patrick'
            '2044-20|#008363|Leprechaun'
            '2044-10|#006149|Green'
            '2045-70|#D4F4ED|Soft Green'
            '2045-60|#B3EDE2|Winter Green'
            '2045-50|#7FDDCF|Green Coral'
            '2045-40|#24C5AE|Bahama Green'
            '2045-30|#009C7D|Green Leaf'
            '2045-20|#007C61|Lawn Green'
            '2045-10|#005949|Green Bay'
            '2046-70|#D5F4ED|Light Mint'
            '2046-60|#B4ECE3|Misty Teal'
            '2046-50|#81DDD0|Scuba Green'
            '2046-40|#22C3AF|Green Sponge'
            '2046-30|#009A7F|Cayman Lagoon'
            '2046-20|#007A63|Garden Green'
            '2046-10|#005A48|Calypso Green'
            '2047-70|#D8F3EC|Baby Green'
            '2047-60|#BAEAE2|Ocean Spray'
            '2047-50|#8BD8CD|Shore House Green'
            '2047-40|#4BBCAB|Capri Seas'
            '2047-30|#00907A|Rolling Hill Green'
            '2047-20|#006B5B|Manor Green'
            '2047-10|#174A43|Forest Green'
            '2048-70|#D3F1EE|Barely Teal'
            '2048-60|#B3E8E6|Jamaican Aqua'
            '2048-50|#7ED5D4|Tropicana Cabana'
            '2048-40|#1FB9B4|Poolside Blue'
            '2048-30|#008B84|Aruba Blue'
            '2048-20|#006D66|Juniper'
            '2048-10|#004E4A|Sherwood Forest'
            '2049-70|#DCF0ED|Icing on the Cake'
            '2049-60|#C0E3E3|Forget Me Not'
            '2049-50|#98CED0|Spectra Blue'
            '2049-40|#61ACAE|Peacock Blue'
            '2049-30|#29777B|Teal Ocean'
            '2049-20|#225A5D|Oasis Blue'
            '2049-10|#274043|Pacific Sea Teal'
            '2050-70|#DDF0EC|Blue Bonnet'
            '2050-60|#C4E3E1|Arctic Blue'
            '2050-50|#9DCDCB|Waterfall'
            '2050-40|#6DA9A7|Florida Keys Blue'
            '2050-30|#3E7371|Newport Green'
            '2050-20|#325654|Dollar Bill Green'
            '2050-10|#2F3E3E|Salamander'
            '2051-70|#D8EBE9|Crystal Blue'
            '2051-60|#BEDCDD|Bird'#39's Egg'
            '2051-50|#94C2C5|Tranquil Blue'
            '2051-40|#629FA0|Majestic Blue'
            '2051-30|#306E6D|Casco Bay'
            '2051-20|#2D5D5A|Pine Green'
            '2051-10|#2F534F|Yukon Green'
            '2052-70|#D5EBEA|Ice Blue'
            '2052-60|#B3DBDE|China Blue'
            '2052-50|#85C1C8|Pool Blue'
            '2052-40|#499EA1|Blue Spa'
            '2052-30|#00706C|Tropical Turquoise'
            '2052-20|#0A5A52|Marine Aqua'
            '2052-10|#1C4E42|Ocean Tropic'
            '2053-70|#D6EAEC|Morning Sky Blue'
            '2053-60|#B8DAE0|Tear Drop Blue'
            '2053-50|#8DC1CA|Passion Blue'
            '2053-40|#569CA5|Blue Lake'
            '2053-30|#236D73|North Sea Green'
            '2053-20|#255A5E|Dark Teal'
            '2053-10|#294E4F|Mallard Green'
            '2054-70|#D2EAEC|Clear Skies'
            '2054-60|#B0DAE3|Old Pickup Blue'
            '2054-50|#80C0CF|Seaside Blue'
            '2054-40|#409CAC|Blue Lagoon'
            '2054-30|#006B76|Venezuelan Sea'
            '2054-20|#0A565A|Beau Green'
            '2054-10|#1D4543|Bavarian Forest'
            '2055-70|#D1EFF1|Innocence'
            '2055-60|#AEE1EA|Serenity'
            '2055-50|#78CBDA|Fairy Tale Blue'
            '2055-40|#12ABBE|Bahaman Sea Blue'
            '2055-30|#007B8E|Caribbean Blue Water'
            '2055-20|#005F6F|Pacific Ocean Blue'
            '2055-10|#144552|Teal'
            '2056-70|#D3F0F0|Icy Moon Drops'
            '2056-60|#AFE3E9|Blue Seafoam'
            '2056-50|#7ACFD9|Baby Boy Blue'
            '2056-40|#18AFBB|Cool Aqua'
            '2056-30|#00808B|Surf Blue'
            '2056-20|#00636C|Jade Garden'
            '2056-10|#0B464E|Tucson Teal'
            '2057-70|#D5EBEE|Icy Blue'
            '2057-60|#B5DAE4|Blue Flower'
            '2057-50|#87C0D1|Turquoise Powder'
            '2057-40|#4D9CAE|Ash Blue'
            '2057-30|#136B7B|Naples Blue'
            '2057-20|#1F5763|Gal'#225'pagos Turquoise'
            '2057-10|#254952|River Blue'
            '2058-70|#D2EAF0|Blue Angel'
            '2058-60|#B0D9E8|Ocean Breeze'
            '2058-50|#80BFD7|Aquarium Blue'
            '2058-40|#419AB7|Cool Blue'
            '2058-30|#006985|Deep Ocean'
            '2058-20|#18546A|Slate Teal'
            '2058-10|#254455|Twilight'
            '2059-70|#CFECF2|Fountain Spout'
            '2059-60|#AADCEE|Splash'
            '2059-50|#76C4E2|Pool Party'
            '2059-40|#17A1C8|Yosemite Blue'
            '2059-30|#00719C|Laguna Blue'
            '2059-20|#00567C|Caribbean Azure'
            '2059-10|#1D3E59|Marine Blue'
            '2060-70|#CEEBF3|Tear Drop'
            '2060-60|#A9DBEF|Turquoise Haze'
            '2060-50|#73C1E4|Cayman Blue'
            '2060-40|#199FCC|Toronto Blue'
            '2060-30|#006EA1|Seaport Blue'
            '2060-20|#005381|California Blue'
            '2060-10|#203B5D|Symphony Blue'
            '2061-70|#CDE7F1|Caribbean Mist'
            '2061-60|#ACD5E9|Little Boy Blue'
            '2061-50|#7CB7D6|Tidal Wave'
            '2061-40|#3E90B8|Electric Blue'
            '2061-30|#185D82|Bermuda Blue'
            '2061-20|#264864|Champion Cobalt'
            '2061-10|#2F394B|Deep Royal'
            '2062-70|#D3E7ED|Harbor Fog'
            '2062-60|#B3D3E1|Blue Hydrangea'
            '2062-50|#87B5CB|Blue Jean'
            '2062-40|#548DA7|Blue Daisy'
            '2062-30|#2D5970|Blue Danube'
            '2062-20|#304656|Gentleman'#39's Gray'
            '2062-10|#323A43|Polo Blue'
            '2063-70|#D3E8F1|Cumulus Cotton'
            '2063-60|#B1D6EA|Sapphireberry'
            '2063-50|#84BBDC|Blue Marguerite'
            '2063-40|#4A93BE|Sailor'#39's Sea Blue'
            '2063-30|#1A5E89|Blueberry'
            '2063-20|#254669|Downpour Blue'
            '2063-10|#2E3549|Old Navy'
            '2064-70|#CCE8F3|Billowy Down'
            '2064-60|#A8D5EF|Bluebelle'
            '2064-50|#74BAE3|Costa Rica Blue'
            '2064-40|#3195CA|Clearest Ocean Blue'
            '2064-30|#0062A0|Ol'#39' Blue Eyes'
            '2064-20|#184A7C|Patriot Blue'
            '2064-10|#2B3558|Bold Blue'
            '2065-70|#C8E6F3|Bashful Blue'
            '2065-60|#A3D4F0|Caribbean Coast'
            '2065-50|#6EB8E5|Blue Wave'
            '2065-40|#1C94D0|Utah Sky'
            '2065-30|#0063A6|Brilliant Blue'
            '2065-20|#144B86|Dark Royal Blue'
            '2065-10|#2B3762|Admiral Blue'
            '2066-70|#CAE8F3|Light Blue'
            '2066-60|#A3D6F2|Honolulu Blue'
            '2066-50|#6CBAEA|True Blue'
            '2066-40|#0F97D8|Rocky Mountain Sky'
            '2066-30|#0066B1|Big Country Blue'
            '2066-20|#004E93|Evening Blue'
            '2066-10|#233872|Blue'
            '2067-70|#D7E5F2|White Satin'
            '2067-60|#BCD2ED|Windmill Wings'
            '2067-50|#92B3E0|Summer Blue'
            '2067-40|#6289C6|Blue Lapis'
            '2067-30|#365496|Twilight Blue'
            '2067-20|#334076|Starry Night Blue'
            '2067-10|#333356|Midnight Navy'
            '2068-70|#E2E5F1|White Heaven'
            '2068-60|#CBCFEA|Purple Lace'
            '2068-50|#AAB0DB|Victorian Trim'
            '2068-40|#7F84BE|California Lilac'
            '2068-30|#4E4E8C|Scandinavian Blue'
            '2068-20|#413D6D|Grape Gum'
            '2068-10|#3A3450|Majestic Violet'
            '2069-70|#E8E8EF|Polar White'
            '2069-60|#D6D5E5|Lavender Ice'
            '2069-50|#B8B9D2|Blue Orchid'
            '2069-40|#8E8FB0|Violet Stone'
            '2069-30|#5C5A7C|Darkest Grape'
            '2069-20|#48445E|Blackberry Wine'
            '2069-10|#3C3845|Deep Mulberry'
            '2070-70|#E5E5ED|Whisper Violet'
            '2070-60|#CFCFE0|Lavender Mist'
            '2070-50|#AFAFCB|Enchanted'
            '2070-40|#8782A6|Spring Purple'
            '2070-30|#544D6D|Dark Lilac'
            '2070-20|#453C50|Plum Royale'
            '2070-10|#3B3339|Tulsa Twilight'
            '2071-70|#EAE3F0|Misty Lilac'
            '2071-60|#DBCEE8|Lily Lavender'
            '2071-50|#BFADD7|Amethyst Cream'
            '2071-40|#9A80B9|Crocus Petal Purple'
            '2071-30|#664B86|Mystical Grape'
            '2071-20|#523C68|Gentle Violet'
            '2071-10|#43334D|Exotic Purple'
            '2072-70|#EBE3EA|Raspberry Ice'
            '2072-60|#D9CCDB|Beach Plum'
            '2072-50|#BDABC2|Lavender Lipstick'
            '2072-40|#957E99|Wild Orchid'
            '2072-30|#604B62|Purple Lotus'
            '2072-20|#4D3D4B|Black Raspberry'
            '2072-10|#40363C|Dark Basalt'
            '2073-70|#F0E3EC|Purple Cream'
            '2073-60|#E3CCE0|Pale Iris'
            '2073-50|#CCACCA|Purple Easter Egg'
            '2073-40|#AA7FA5|Purple Hyacinth'
            '2073-30|#764B6E|Passion Plum'
            '2073-20|#5D3D54|Autumn Purple'
            '2073-10|#4B3540|Dark Purple'
            '2074-70|#F5E3EF|Easter Bonnet'
            '2074-60|#EDCDE6|Bunny Nose Pink'
            '2074-50|#DCACD3|Exotic Fuchsia'
            '2074-40|#C280B4|Lilac Pink'
            '2074-30|#9B4A80|Twilight Magenta'
            '2074-20|#7B3C63|Summer Plum'
            '2074-10|#62334A|Grape Juice'
            '2075-70|#F6E3EF|Charming Pink'
            '2075-60|#EDCCE4|Passion Pink'
            '2075-50|#DFAAD1|Pink Taffy'
            '2075-40|#C67DAF|Pink Raspberry'
            '2075-30|#9F487D|Pre-Dawn Sky'
            '2075-20|#7F3B5F|Mulberry'
            '2075-10|#663347|Dark Burgundy'
            '2076-70|#F7E2ED|Nursery Pink'
            '2076-60|#F3CAE3|Dog'#39's Ear'
            '2076-50|#E8A9D0|Easter Pink'
            '2076-40|#D67CB0|Raspberry Mousse'
            '2076-30|#B4447B|Crushed Berries'
            '2076-20|#A0365F|Royal Flush'
            '2076-10|#8D2D48|Crushed Velvet'
            '2077-70|#F8E2EE|I Love You Pink'
            '2077-60|#F4CBE5|Valentine'#39's Day'
            '2077-50|#EBA8D3|Pretty Pink'
            '2077-40|#DB7BB4|Spring Azalea'
            '2077-30|#BC427F|Hot Lips'
            '2077-20|#AB3162|Gypsy Pink'
            '2077-10|#9C284B|Magenta'
            '2078-70|#F8E5EC|Pink Peony'
            '2078-60|#F5D0E1|Newborn Pink'
            '2078-50|#ECB0CA|Pink Begonia'
            '2078-40|#DC85A6|Paradise Pink'
            '2078-30|#BD5070|Royal Fuchsia'
            '2078-20|#AC3D58|Raspberry Glaze'
            '2078-10|#9D3448|Roseate'
            '2079-70|#FAE2EC|Candy Stripe'
            '2079-60|#F8CDE1|Pink Cherub'
            '2079-50|#F2ABCB|Rhododendron'
            '2079-40|#E47DA7|Springtime Bloom'
            '2079-30|#C84470|Peony'
            '2079-20|#B83153|Blushing Red'
            '2079-10|#AA253C|Candy Cane Red'
            '2080-70|#F8E1E7|Aztec Lily'
            '2080-60|#F3C9D7|Posy Pink'
            '2080-50|#E6A7BC|Bayberry'
            '2080-40|#D07991|Wild Pink'
            '2080-30|#AD485B|Cherry Wine'
            '2080-20|#9E3B45|Patriot Red'
            '2080-10|#923538|Raspberry Truffle'
            '2081-70|#F8E7EA|Flush Pink'
            '2081-60|#F5D4DC|Pink Lace'
            '2081-50|#EDB6C3|Pink Ruffle'
            '2081-40|#DC8C9B|Pink Blossom'
            '2081-30|#BE5A67|Vibrant Blush'
            '2081-20|#AE4853|Sultan'#39's Palace'
            '2081-10|#A14048|Burnt Peanut Red'
            '2082-70|#F3E2E6|Ballerina Pink'
            '2082-60|#E9CCD4|Pink Innocence'
            '2082-50|#D6ACB8|Damask Rose'
            '2082-40|#B77F8C|Rosewood'
            '2082-30|#8C5059|Cherokee Brick'
            '2082-20|#7C4547|Plum Raisin'
            '2082-10|#703E3C|Chestnut'
            '2083-70|#F5E3EA|Baby Dreams'
            '2083-60|#ECCBDA|Sweet Naivete'
            '2083-50|#DCAAC1|Pink Pansy'
            '2083-40|#C27E9A|Begonia'
            '2083-30|#974C64|Old Claret'
            '2083-20|#833F4D|Cranberry Cocktail'
            '2083-10|#73383F|Raisin Torte'
            '2084-70|#FAE4E8|Gentle Blush'
            '2084-60|#F6CFD9|Early Sunrise'
            '2084-50|#EAAEBE|Rosy Glow'
            '2084-40|#D48295|Precious Pink'
            '2084-30|#B2525D|Rouge'
            '2084-20|#914443|Maple Leaf Red'
            '2084-10|#793B31|Brick Red'
            '2085-70|#F8E3E8|Baby Pink'
            '2085-60|#EFCDD9|Pink Petals'
            '2085-50|#E4ACC0|Strawberry'
            '2085-40|#CB7E95|Taste of Berry'
            '2085-30|#A64E5D|Gypsy Love'
            '2085-20|#853F44|Pottery Red'
            '2085-10|#6E3731|Arroyo Red'
            '2086-70|#FBE3EA|50'#39's Pink'
            '2086-60|#FACDDD|Sweet Taffy'
            '2086-50|#F5ABC5|Blushing Bride'
            '2086-40|#E97B9D|Deep Carnation'
            '2086-30|#CF4566|Rosy Blush'
            '2086-20|#C0324A|Rose Parade'
            '2086-10|#B32735|Exotic Red'
            '2087-70|#FAE7E9|Elephant Pink'
            '2087-60|#FAD4DB|Ribbon Pink'
            '2087-50|#F6B6C3|Strawberry Sorbet'
            '2087-40|#EB8A99|Autumn Red'
            '2087-30|#D35361|Italiano Rose'
            '2087-20|#C53D46|Watermelon Red'
            '2087-10|#B82D33|Neon Red'
            '2088-70|#F6D9D4|Fond Memory'
            '2088-60|#ECBDB7|Fruit Shake'
            '2088-50|#D99992|Cool Lava'
            '2088-40|#BD6D64|Persimmon'
            '2088-30|#9F4B3D|Strawberry Field'
            '2088-20|#9A4637|Country Lane'
            '2088-10|#964333|Red Oxide'
            '2089-70|#F9ECE7|Frosted Petal'
            '2089-60|#F6DBD6|Peach Kiss'
            '2089-50|#EEC0BA|Salmon Berry'
            '2089-40|#DF9B91|Tomato Cream Sauce'
            '2089-30|#C26C60|Pink Mix'
            '2089-20|#B55E4F|Rosy Peach'
            '2089-10|#A95445|Iron Ore Red'
            '2090-70|#F7DAD5|Spring Pink'
            '2090-60|#EDC0B9|Strawberry Freeze'
            '2090-50|#DA9B94|Tender Pink'
            '2090-40|#BF7065|Wild Flower'
            '2090-30|#A14C3E|Terra Cotta Tile'
            '2090-20|#9B4837|Rich Chestnut'
            '2090-10|#974434|Grand Canyon Red'
            '2091-70|#F3DAD5|April Pink'
            '2091-60|#E7BFBA|Heather Pink'
            '2091-50|#D19A95|Rosy Tan'
            '2091-40|#B36F67|Red River Clay'
            '2091-30|#974C3E|Deep Poinsettia'
            '2091-20|#8E4738|Rustic Brick'
            '2091-10|#894334|Tea'
            '2092-70|#F0DBD7|Fairest Pink'
            '2092-60|#E3C1BD|Georgia Pink'
            '2092-50|#CB9E99|Titanic Rose'
            '2092-40|#A97169|Texas Rose'
            '2092-30|#864B40|Boston Brick'
            '2092-20|#804638|Sienna'
            '2092-10|#7B4233|Clydesdale Brown'
            '2093-70|#F5EAE7|Pink Bliss'
            '2093-60|#F2DAD7|Playful Pink'
            '2093-50|#E5BEBB|Camellia Pink'
            '2093-40|#CE958E|Belladonna Lily'
            '2093-30|#AE6557|Colonial Brick'
            '2093-20|#8B5042|Fresh Clay'
            '2093-10|#754331|Cimarron'
            '2094-70|#F6E8E2|Mellow Pink'
            '2094-60|#EED4CE|Pleasant Pink'
            '2094-50|#DDB6AE|Desert Rose'
            '2094-40|#C18C80|Soft Cranberry'
            '2094-30|#975C4B|Giant Sequoia'
            '2094-20|#864D3B|Copper Mine'
            '2094-10|#7B4532|Burnt Cinnamon'
            '2095-70|#EEE2DB|Melted Ice Cream'
            '2095-60|#DFCBC2|Southern Comfort'
            '2095-50|#C6AAA0|Just Beige'
            '2095-40|#A48073|Mudslide'
            '2095-30|#7E5849|Butternut Brown'
            '2095-20|#754F3F|Antler Brown'
            '2095-10|#6F4B3B|Adirondack Brown'
            '2096-70|#F0E4DC|Early Sunset'
            '2096-60|#E2CFC4|Light Mocha'
            '2096-50|#CAAFA1|Cappuccino'
            '2096-40|#A98573|Gaucho Brown'
            '2096-30|#825B48|Grandfather Clock Brown'
            '2096-20|#78523F|Chocolate Truffle'
            '2096-10|#714D39|Seed Brown'
            '2097-70|#EDE2DC|Wild Rice'
            '2097-60|#DDCBC3|Misty Blush'
            '2097-50|#C3AAA1|Hint of Mauve'
            '2097-40|#9F7F73|Santa Fe Tan'
            '2097-30|#7A5749|Hedgehog Brown'
            '2097-20|#704E40|Morning Coffee'
            '2097-10|#6B4A3C|Toasted Brown'
            '2098-70|#ECE2DC|Frosted Caf'#233
            '2098-60|#DBCAC3|Wisp of Mauve'
            '2098-50|#C0A9A1|Flax'
            '2098-40|#9B7D73|Caf'#233' Ole'
            '2098-30|#785548|Dark Nut Brown'
            '2098-20|#6D4C3F|Roasted Coffee Beans'
            '2098-10|#67473A|Barrel Brown'
            '2099-70|#EDE1DA|Wheatberry'
            '2099-60|#DECAC2|Malted Milk'
            '2099-50|#C5A99F|Caf'#233' Mocha'
            '2099-40|#A17D71|Autumn Brown'
            '2099-30|#7C5547|Espresso'
            '2099-20|#734D3E|Cupcake'
            '2099-10|#6E493A|Brown'
            '2100-70|#EEE1DB|Victorian Lace'
            '2100-60|#E0CBC3|Bermuda Sands'
            '2100-50|#C6AAA0|Pebble Stone'
            '2100-40|#A47F73|Appalachian Spring'
            '2100-30|#7D5648|English Brown'
            '2100-20|#754E3F|Leather Saddle Brown'
            '2100-10|#6E4939|Mocha Madness'
            '2101-70|#EFE2DD|Tropical Sand'
            '2101-60|#E0CBC5|Pale Cherry Blossom'
            '2101-50|#C8AAA3|Allspice'
            '2101-40|#A57F75|Almond Beige'
            '2101-30|#7E554A|Warm Brownie'
            '2101-20|#744D40|Cocoa Brown'
            '2101-10|#6F483B|Suede Brown'
            '2102-70|#EFE2DE|First Light'
            '2102-60|#E1CBC7|Honey Hut'
            '2102-50|#CAABA6|Rose Bisque'
            '2102-40|#A77F78|Brown Teepee'
            '2102-30|#7F554B|Pueblo Brown'
            '2102-20|#754C40|Pumpernickel'
            '2102-10|#6F473B|Earth Brown'
            '2103-70|#ECDDDA|Strawberry-n-Cream'
            '2103-60|#DBC3C0|Pale Berry'
            '2103-50|#BF9F9C|Sandblast'
            '2103-40|#9A726D|Hickory Stick'
            '2103-30|#754B41|Peatmoss'
            '2103-20|#6D4338|English Manor'
            '2103-10|#684034|Natural Brown'
            '2104-70|#ECDCD9|Strawberry Yogurt'
            '2104-60|#DDC3C0|Rose Silk'
            '2104-50|#C19E9B|Cherry Malt'
            '2104-40|#9E726D|New England Brown'
            '2104-30|#7C4B42|Harvest Brown'
            '2104-20|#744539|Beaver Brown'
            '2104-10|#714235|Pancake Syrup'
            '2105-70|#ECE1DA|Savory Cream'
            '2105-60|#DDC9C1|Acapulco Sand'
            '2105-50|#C3A99F|Sand Pebble'
            '2105-40|#A07E71|Dusty Ranch Brown'
            '2105-30|#7A5648|Rabbit Brown'
            '2105-20|#724E3F|Root Beer Candy'
            '2105-10|#6C493A|Forest Brown'
            '2106-70|#ECE3DC|Foggy Morning'
            '2106-60|#DCCDC5|Soft Sand'
            '2106-50|#C1ACA2|Driftscape Tan'
            '2106-40|#9C8174|Cougar Brown'
            '2106-30|#755749|Pine Cone'
            '2106-20|#6D4E3F|Auberge'
            '2106-10|#67493A|Java'
            '2107-70|#EAE4DE|Cloudy Gray'
            '2107-60|#D8CFC7|Sea Froth'
            '2107-50|#BDAFA6|Sandlot Gray'
            '2107-40|#978477|Driftwood'
            '2107-30|#6F594B|Rockies Brown'
            '2107-20|#664F40|Mocha Brown'
            '2107-10|#614A3B|Chocolate Candy Brown'
            '2108-70|#E8E5DF|Lacey Pearl'
            '2108-60|#D3CFC7|Abalone'
            '2108-50|#B8B1A7|Silver Fox'
            '2108-40|#918578|Stardust'
            '2108-30|#695A4C|Brown Horse'
            '2108-20|#604E40|Sierra Spruce'
            '2108-10|#5D4B3D|Ferret Brown'
            '2109-70|#E6E2DE|A la Mode'
            '2109-60|#D3CCC7|Portland Gray'
            '2109-50|#B5ABA7|Elephant Gray'
            '2109-40|#8E7F79|Smoked Oyster'
            '2109-30|#68554D|Wood Grain Brown'
            '2109-20|#604D44|Hearthstone Brown'
            '2109-10|#58453B|Classic Brown'
            '2110-70|#F2EDE8|Vintage Taupe'
            '2110-60|#E8DDD8|Pampas Grass'
            '2110-50|#D3C3BD|Gobi Desert'
            '2110-40|#B59D94|Seaside Sand'
            '2110-30|#886A59|Saddle Soap'
            '2110-20|#6E5440|Brown Tar'
            '2110-10|#5A4430|Taupe'
            '2111-70|#E6E4DF|Calm'
            '2111-60|#D3D0C9|Barren Plain'
            '2111-50|#B4AFA8|Stone Harbor'
            '2111-40|#8C847A|Taos Taupe'
            '2111-30|#68574A|Mustang'
            '2111-20|#5F4B3C|Grizzly Bear Brown'
            '2111-10|#594334|Deep Taupe'
            '2112-70|#E4E3E0|American White'
            '2112-60|#CDCCCA|Cement Gray'
            '2112-50|#AEABAA|Stormy Monday'
            '2112-40|#86807E|Stone'
            '2112-30|#5F544E|Stone Brown'
            '2112-20|#564942|Brown Sugar'
            '2112-10|#52443C|Mink'
            '2113-70|#E4DEDD|Antique Pearl'
            '2113-60|#D0C5C5|Porcelain'
            '2113-50|#B1A2A4|Mauve Desert'
            '2113-40|#897475|Cinnamon Slate'
            '2113-30|#664B47|Bison Brown'
            '2113-20|#5F433C|Pine Cone Brown'
            '2113-10|#5B3F36|Chocolate Sundae'
            '2114-70|#ECE7E5|Venetian Marble'
            '2114-60|#DCD4D3|Hint of Violet'
            '2114-50|#C2B5B7|Victorian Mauve'
            '2114-40|#9C8989|Wet Concrete'
            '2114-30|#685553|Desert Shadows'
            '2114-20|#52433E|Mississippi Mud'
            '2114-10|#433731|Bittersweet Chocolate'
            '2115-70|#ECE9E8|Oyster'
            '2115-60|#DED8DA|Majestic Mauve'
            '2115-50|#C4BBC0|Iced Mauve'
            '2115-40|#A19195|Mauve Blush'
            '2115-30|#6F5B5C|Amazon Soil'
            '2115-20|#584744|Incense Stick'
            '2115-10|#493A33|Appalachian Brown'
            '2116-70|#EBE9EA|Mirage White'
            '2116-60|#DCD6DD|Touch of Gray'
            '2116-50|#C1B9C4|African Violet'
            '2116-40|#9B8E9C|Hazy Lilac'
            '2116-30|#6B5A64|Cabernet'
            '2116-20|#544649|Vintage Wine'
            '2116-10|#443A36|Night Shade'
            '2117-70|#E5E3E7|Dreamy Cloud'
            '2117-60|#D0CDD6|Winter Gray'
            '2117-50|#B0ACBB|Spring Violet'
            '2117-40|#857D8F|Tropical Dusk'
            '2117-30|#514A58|Shadow'
            '2117-20|#413D44|Galaxy'
            '2117-10|#383537|Carbon Copy'
            '2118-70|#E1E2E5|Heaven'
            '2118-60|#CACCD3|Misty Memories'
            '2118-50|#A9ABB6|Excalibur Gray'
            '2118-40|#7B7C88|Sea Life'
            '2118-30|#4A4A53|Ebony Slate'
            '2118-20|#3C3B40|Toucan Black'
            '2118-10|#353435|Universal Black'
            '2119-70|#DFE2E3|Full Moon'
            '2119-60|#C6CBCF|Silver Lining'
            '2119-50|#A2A9B1|Nickel'
            '2119-40|#757B83|Silver Streak'
            '2119-30|#464A50|Baby Seal Black'
            '2119-20|#3A3B3F|Black Berry'
            '2119-10|#333334|Space Black'
            '2120-70|#DFE3E3|Stone White'
            '2120-60|#C6CBCF|White Water'
            '2120-50|#A3AAB0|Silver Spring'
            '2120-40|#757B82|Smoke Gray'
            '2120-30|#46494F|Witching Hour'
            '2120-20|#3A3C3E|Black Iron'
            '2120-10|#333334|Jet Black'
            '2121-70|#F4F6F1|Chantilly Lace'
            '2121-60|#ECEFEC|White Diamond'
            '2121-50|#DCE1E1|Iced Cube Silver'
            '2121-40|#C3C8CB|Silver Half Dollar'
            '2121-30|#979C9F|Pewter'
            '2121-20|#787B7D|Steel Wool'
            '2121-10|#585858|Gray'
            '2122-70|#F1F5F1|Snow White'
            '2122-60|#E9EFED|Palest Pistachio'
            '2122-50|#D6E0E0|Iceberg'
            '2122-40|#BAC8C9|Smoke'
            '2122-30|#8F9D9E|Cloudy Sky'
            '2122-20|#6E7C7D|Steep Cliff Gray'
            '2122-10|#4B5756|Dark Pewter'
            '2123-70|#F1F4F1|Ice Mist'
            '2123-60|#E7EFEC|Sea Foam'
            '2123-50|#D3E1E1|Ocean Air'
            '2123-40|#B3C8C8|Gossamer Blue'
            '2123-30|#889E9E|Sea Star'
            '2123-20|#627C7A|Caribbean Teal'
            '2123-10|#465956|Mediterranean Teal'
            '2124-70|#F2F4F1|Distant Gray'
            '2124-60|#E8EBEA|Misty Gray'
            '2124-50|#D6DBDC|Bunny Gray'
            '2124-40|#B8BDC0|Thundercloud Gray'
            '2124-30|#8B9094|Deep Silver'
            '2124-20|#696D70|Trout Gray'
            '2124-10|#494A4B|Wrought Iron'
            '2125-70|#EEF0EE|Wedding Veil'
            '2125-60|#E0E4E4|Marilyn'#39's Dress'
            '2125-50|#C7CDD1|Sweet Innocence'
            '2125-40|#A2A9AE|Shadow Gray'
            '2125-30|#6D7378|Gray Shower'
            '2125-20|#52565A|Deep Space'
            '2125-10|#3D3F40|Black Panther'
            '2126-70|#EAEDEB|Chalk White'
            '2126-60|#D7DCDE|Gray Cloud'
            '2126-50|#BAC1C6|Gray Timber Wolf'
            '2126-40|#92999E|Sweatshirt Gray'
            '2126-30|#5C6167|Anchor Gray'
            '2126-20|#464A4D|Raccoon Fur'
            '2126-10|#38393A|Black Tar'
            '2127-70|#DDE2E3|Cascade White'
            '2127-60|#C4CBD0|Feather Gray'
            '2127-50|#A0AAB1|Pike'#39's Peak Gray'
            '2127-40|#727C83|Wolf Gray'
            '2127-30|#444A50|Gravel Gray'
            '2127-20|#373A3D|Black Ink'
            '2127-10|#343435|Twilight Zone'
            '2128-70|#E3E9EB|Lily White'
            '2128-60|#CDD7DE|Beacon Gray'
            '2128-50|#ACBAC8|November Skies'
            '2128-40|#8290A0|Oxford Gray'
            '2128-30|#515A67|Evening Dove'
            '2128-20|#42444B|Abyss'
            '2128-10|#393736|Black Beauty'
            '2129-70|#DBE3E5|Silver Cloud'
            '2129-60|#C1CDD3|Mt. Rainier Gray'
            '2129-50|#9CADB7|Winter Lake'
            '2129-40|#6D7E89|Normandy'
            '2129-30|#404B54|Blue Note'
            '2129-20|#373C41|Soot'
            '2129-10|#323436|Midnight Dream'
            '2130-70|#DCE1E4|Seattle Gray'
            '2130-60|#C1CAD1|Iced Slate'
            '2130-50|#9CA8B3|New Hope Gray'
            '2130-40|#717C86|Black Pepper'
            '2130-30|#4F4E53|Almost Black'
            '2130-20|#494242|Deep Caviar'
            '2130-10|#453C39|Black Bean Soup'
            '2131-70|#DDE5E5|Gray Sky'
            '2131-60|#C4CFD2|Silver Gray'
            '2131-50|#A1B0B4|Nimbus Gray'
            '2131-40|#728287|Smokestack Gray'
            '2131-30|#434E52|Lead Gray'
            '2131-20|#373D3F|Midnight'
            '2131-10|#313435|Black Satin'
            '2132-70|#DDE1E1|Mineral Ice'
            '2132-60|#C3C9CD|Metallic Silver'
            '2132-50|#9EA7AD|Pilgrim Haze'
            '2132-40|#717980|Eclipse'
            '2132-30|#44484D|Black Horizon'
            '2132-20|#383A3C|Ebony King'
            '2132-10|#313132|Black'
            '2133-70|#E2E4E3|Tundra'
            '2133-60|#CBCED0|Sidewalk Gray'
            '2133-50|#AAAEB3|Pigeon Gray'
            '2133-40|#7C7F84|Dior Gray'
            '2133-30|#4B4B4F|Day'#39's End'
            '2133-20|#3D3D3E|Black Jack'
            '2133-10|#353434|Onyx'
            '2134-70|#E1E4E3|Genesis White'
            '2134-60|#C9CECE|Whitestone'
            '2134-50|#A7AEB0|Gull Wing Gray'
            '2134-40|#7E8283|Whale Gray'
            '2134-30|#575553|Iron Mountain'
            '2134-20|#504A45|Midsummer Night'
            '2134-10|#4B433D|Night Horizon'
            '2135-70|#E4EDEB|Patriotic White'
            '2135-60|#CEDDDF|Summer Shower'
            '2135-50|#ADC3C8|Soft Chinchilla'
            '2135-40|#829BA1|Province Blue'
            '2135-30|#55656B|Nocturnal Gray'
            '2135-20|#434C4F|Stonecutter'
            '2135-10|#393D3C|Blacktop'
            '2136-70|#DCE7E6|Whispering Spring'
            '2136-60|#C3D4D4|Harbor Haze'
            '2136-50|#9EB5B8|Colorado Gray'
            '2136-40|#6F898B|Aegean Teal'
            '2136-30|#415457|Amazon Green'
            '2136-20|#364042|Regent Green'
            '2136-10|#303536|Black Knight'
            '2137-70|#E6E8E1|White Wisp'
            '2137-60|#D3D4CC|Gray Owl'
            '2137-50|#B3B5AB|Sea Haze'
            '2137-40|#8D8C7F|Desert Twilight'
            '2137-30|#645D4E|Durango'
            '2137-20|#5A4F40|Char Brown'
            '2137-10|#544839|Otter Brown'
            '2138-70|#E4E8E2|Gray Lake'
            '2138-60|#CFD5CD|Gray Cashmere'
            '2138-50|#B0B8AE|Misted Green'
            '2138-40|#858D81|Carolina Gull'
            '2138-30|#5F5E50|Mohegan Sage'
            '2138-20|#555042|Green Grove'
            '2138-10|#4F493B|Southern Vine'
            '2139-70|#EAEEE9|White Ice'
            '2139-60|#DAE0DA|Green Tint'
            '2139-50|#C0C8C1|Silver Marlin'
            '2139-40|#99A196|Heather Gray'
            '2139-30|#6D6C5E|Sharkskin'
            '2139-20|#565344|Dakota Woods Green'
            '2139-10|#464233|River Rock'
            '2140-70|#E7E9E2|Winter White'
            '2140-60|#D6D8CF|Moonshine'
            '2140-50|#B9BBB1|Gray Horse'
            '2140-40|#919284|Storm Cloud Gray'
            '2140-30|#616253|Dark Olive'
            '2140-20|#545447|Tuscany Green'
            '2140-10|#4B4B3F|Fatigue Green'
            '2141-70|#ECECE3|Vanilla Milkshake'
            '2141-60|#DADBCF|Titanium'
            '2141-50|#BFC0B1|Horizon Gray'
            '2141-40|#9A9885|Creekside Green'
            '2141-30|#6A6855|Army Green'
            '2141-20|#5C5A47|Cabbage Patch'
            '2141-10|#535140|Artichoke'
            '2142-70|#EDEDE3|Icicle'
            '2142-60|#E0DED0|November Rain'
            '2142-50|#C8C5B2|Gray Mirage'
            '2142-40|#A39F84|Dry Sage'
            '2142-30|#757055|Mountain Moss'
            '2142-20|#696449|Turtle Green'
            '2142-10|#5E5A42|Mediterranean Olive'
            '2143-70|#F6F6ED|Simply White'
            '2143-60|#EFEEE3|Moonlight White'
            '2143-50|#E2E0D1|Old Prairie'
            '2143-40|#CBC7B0|Camouflage'
            '2143-30|#A59C79|Olive Branch'
            '2143-20|#8D835E|Alligator Green'
            '2143-10|#766C4B|Sage'
            '2144-70|#F6F7EE|Snowfall White'
            '2144-60|#EEEFE5|Cloud Nine'
            '2144-50|#E0E3D4|Silken Pine'
            '2144-40|#C8CAB2|Soft Fern'
            '2144-30|#A0A27E|Rosemary Sprig'
            '2144-20|#83855E|Eucalyptus Leaf'
            '2144-10|#646742|Guacamole'
            '2145-70|#F5F6EB|Cotton Balls'
            '2145-60|#F0F0DF|Minced Onion'
            '2145-50|#E3E4CA|Limesicle'
            '2145-40|#CCCCA3|Fernwood Green'
            '2145-30|#A6A56C|Brookside Moss'
            '2145-20|#8B8C50|Terrapin Green'
            '2145-10|#6E743A|Avocado'
            '2146-70|#F7F7E7|Bavarian Cream'
            '2146-60|#F2F1D7|Cream Silk'
            '2146-50|#E7E5BD|Rainforest Dew'
            '2146-40|#D3CF8F|Pale Avocado'
            '2146-30|#B1AD55|Split Pea'
            '2146-20|#9A983D|Forest Moss'
            '2146-10|#83872E|Dark Celery'
            '2147-70|#F4F4E3|Alpine White'
            '2147-60|#ECECCF|Dark Linen'
            '2147-50|#DDDCB1|Pale Sea Mist'
            '2147-40|#C4C184|Dill Pickle'
            '2147-30|#A19D52|Jalape'#241'o Pepper'
            '2147-20|#949146|Olive Moss'
            '2147-10|#8C883F|Oregano'
            '2148-70|#F7F5EB|Mountain Peak White'
            '2148-60|#F2EEDD|Timid White'
            '2148-50|#E7DFC5|Sandy White'
            '2148-40|#D3C59D|Light Khaki'
            '2148-30|#B19C68|Military Tan'
            '2148-20|#9D8752|Thyme'
            '2148-10|#8B7744|Foot Hills'
            '2149-70|#F5F3E3|White Chocolate'
            '2149-60|#EDE8CF|White Marigold'
            '2149-50|#DED6AF|Mellowed Ivory'
            '2149-40|#C6B984|Timothy Straw'
            '2149-30|#AB9554|Fresh Olive'
            '2149-20|#958649|G.I. Green'
            '2149-10|#8B7D43|Newt Green'
            '2150-70|#F7F4E2|Easter Lily'
            '2150-60|#F2EBCD|Pale Celery'
            '2150-50|#E7DCAE|Hampton Green'
            '2150-40|#D3C281|Spring Dust'
            '2150-30|#BAA04F|Savannah Green'
            '2150-20|#A89343|Lichen Green'
            '2150-10|#9F8C3F|Willow Green'
            '2151-70|#F5F2E1|Powder Sand'
            '2151-60|#F0E8CB|Linen Sand'
            '2151-50|#E8D8AD|Bronzed Beige'
            '2151-40|#D2BA7F|Sulfur Yellow'
            '2151-30|#BB9951|Ochre'
            '2151-20|#AC8D46|Golden Chalice'
            '2151-10|#A08542|Mustard Olive'
            '2152-70|#F9F5E5|Mayonnaise'
            '2152-60|#F7ECD2|Mannequin Cream'
            '2152-50|#EFDDB5|Golden Straw'
            '2152-40|#E0C389|Golden Tan'
            '2152-30|#C59E55|Autumn Gold'
            '2152-20|#B89045|Aztec Yellow'
            '2152-10|#AD863E|Medieval Gold'
            '2153-70|#F8F1DD|Ivory Tusk'
            '2153-60|#F2E4C5|Rich Cream'
            '2153-50|#E6CFA1|Desert Tan'
            '2153-40|#D1B071|Cork'
            '2153-30|#AF8840|Tapestry Gold'
            '2153-20|#A07A35|Corduroy'
            '2153-10|#96722E|Golden Bark'
            '2154-70|#FAF3E0|Vanilla Ice Cream'
            '2154-60|#FAEBCC|Filtered Sunlight'
            '2154-50|#F5DAA9|Straw'
            '2154-40|#EAC17C|York Harbor Yellow'
            '2154-30|#D5A14B|Buttercup'
            '2154-20|#CC953D|Spicy Mustard'
            '2154-10|#C58E38|Yellow Oxide'
            '2155-70|#FBF4DC|Cotton Tail'
            '2155-60|#FCEBC3|Cream Yellow'
            '2155-50|#FBDC9F|Suntan Yellow'
            '2155-40|#F4C36B|Semolina'
            '2155-30|#EAA731|Yellow Marigold'
            '2155-20|#DC9222|Gold Mine'
            '2155-10|#D68A1A|Desert Sunset'
            '2156-70|#FBF2DC|Fine China'
            '2156-60|#FBE7C5|Soft Beige'
            '2156-50|#F8D3A1|Asbury Sand'
            '2156-40|#ECB36D|August Morning'
            '2156-30|#D78C3B|Jack O'#39'Lantern'
            '2156-20|#CC7F2D|Pumpkin Blush'
            '2156-10|#C57626|Autumn Orange'
            '2157-70|#FBF2E4|Ivory Tower'
            '2157-60|#FCE7CF|Tudor Cream'
            '2157-50|#F9D5B0|Crisp Straw'
            '2157-40|#EEB783|Beeswax'
            '2157-30|#D89050|Butterscotch'
            '2157-20|#CD8341|Golden Harvest'
            '2157-10|#C57B3A|Golden Dunes'
            '2158-70|#FAF3E3|Cream Froth'
            '2158-60|#FAE8CE|Lion Yellow'
            '2158-50|#F4D6AE|Manila'
            '2158-40|#E8B981|Golden Mist'
            '2158-30|#D19750|Delightful Golden'
            '2158-20|#C68745|Venetian Gold'
            '2158-10|#BE7F3E|Dried Mustard'
            '2159-70|#FAF3E2|White Cloud'
            '2159-60|#FBEACD|Cream'
            '2159-50|#F7DAAD|Wheatfield'
            '2159-40|#ECBF7F|Amber Waves'
            '2159-30|#D69D4D|Apple Crisp'
            '2159-20|#CC9040|Peanut Butter'
            '2159-10|#C4893A|Dash of Curry'
            '2160-70|#F9F2E0|Sugar Cookie'
            '2160-60|#F8E8CC|Kansas Grain'
            '2160-50|#F0D5AC|Oklahoma Wheat'
            '2160-40|#E0B97F|Roasted Sesame Seed'
            '2160-30|#C9974F|Maple Sugar'
            '2160-20|#BA8744|Turmeric'
            '2160-10|#B2803D|Caramel Corn'
            '2161-70|#F7EFE1|Woodland Snow'
            '2161-60|#F1E1CC|Hazelnut Cream'
            '2161-50|#E3C9AA|Yellow Squash'
            '2161-40|#CDA87F|Acorn Yellow'
            '2161-30|#AB7E51|Dark Mustard'
            '2161-20|#9F7247|Tawny'
            '2161-10|#966B41|Coppertone'
            '2162-70|#F5ECDC|October Sky'
            '2162-60|#ECDCC5|Mystic Beige'
            '2162-50|#DBC3A4|Arizona Tan'
            '2162-40|#C09D73|Peanut Shell'
            '2162-30|#997245|Warm Tan'
            '2162-20|#8C663B|Desert Camel'
            '2162-10|#835E34|Autumn Bronze'
            '2163-70|#F4EBDF|Winter Sky'
            '2163-60|#EBDBCA|Latte'
            '2163-50|#DAC0AA|Burlap'
            '2163-40|#BE997C|Metallic Gold'
            '2163-30|#986E4F|Penny'
            '2163-20|#8D6345|Pony Brown'
            '2163-10|#855C3F|Log Cabin'
            '2164-70|#F2E8DD|Candle White'
            '2164-60|#E6D4C4|Soft Satin'
            '2164-50|#D1B7A3|Saint Martin Sand'
            '2164-40|#B18E74|Serengeti Sand'
            '2164-30|#8A6348|Rich Clay Brown'
            '2164-20|#7E583D|Marsh Brown'
            '2164-10|#765138|Saddle Brown'
            '2165-70|#F8F1E1|Butter Pecan'
            '2165-60|#F5E5CC|Durango Dust'
            '2165-50|#EBD2AD|Natural Sand'
            '2165-40|#D8B281|Dark Beige'
            '2165-30|#BA8B52|Golden Retriever'
            '2165-20|#AE7E46|Golden Meadow'
            '2165-10|#A5763E|Camel'
            '2166-70|#FAEDDB|Adobe White'
            '2166-60|#F9DEC3|Pale Oats'
            '2166-50|#F1C5A0|Creamy Orange'
            '2166-40|#E1A16D|Soft Pumpkin'
            '2166-30|#C7773E|Bronze Tone'
            '2166-20|#BC6B32|Caramel Latte'
            '2166-10|#B5632C|Gold Rush'
            '2167-70|#FCF1E4|Summer Peach'
            '2167-60|#FDE4D1|Sweet Salmon'
            '2167-50|#FBCFB3|Perfect Peach'
            '2167-40|#F1AE84|Toffee Orange'
            '2167-30|#DB8450|Harvest Moon'
            '2167-20|#D07640|Pumpkin Pie'
            '2167-10|#C76C37|Burnt Caramel'
            '2168-70|#FCEFE4|Sun Kissed Peach'
            '2168-60|#FDE3D1|Peach Nectar'
            '2168-50|#FBCCB3|Summer Melon'
            '2168-40|#F2AB85|Peachland'
            '2168-30|#DC8052|Orange Blossom'
            '2168-20|#D17042|Pumpkin Cream'
            '2168-10|#C86638|Fall Harvest'
            '2169-70|#FDEEE5|Sun Washed'
            '2169-60|#FFE0D3|Peach Cloud'
            '2169-50|#FDC8B6|Malibu Peach'
            '2169-40|#F5A386|Peach Cobbler'
            '2169-30|#E17751|Oriole'
            '2169-20|#D4653E|Orange Parrot'
            '2169-10|#CC5A32|Racing Orange'
            '2170-70|#FAEDE3|Soft White'
            '2170-60|#F9DDCF|Sunlit Coral'
            '2170-50|#F4C3B2|Teacup Rose'
            '2170-40|#EA9E82|Coral Spice'
            '2170-30|#D56E4E|Autumn Cover'
            '2170-20|#CB5E3D|Tropical Orange'
            '2170-10|#C35232|Fireball Orange'
            '2171-70|#FCEAE6|Pink Swirl'
            '2171-60|#FDDAD5|Rose Reflection'
            '2171-50|#F8BEB8|Pearly Pink'
            '2171-40|#EA9589|Passion Fruit'
            '2171-30|#D36651|Adobe Orange'
            '2171-20|#BD543D|Fire Dance'
            '2171-10|#AB4830|Navajo Red'
            '2172-70|#F4D9D5|Spring Blossom'
            '2172-60|#EABFB9|Pink Hibiscus'
            '2172-50|#D59A94|Bouquet Rose'
            '2172-40|#B77067|Raspberry Parfait'
            '2172-30|#9A4B3D|Mexicana'
            '2172-20|#924737|Mars Red'
            '2172-10|#8E4332|Copper Clay'
            '2173-70|#F7E8E2|Gentle Butterfly'
            '2173-60|#F0D5CE|Just Peachy'
            '2173-50|#E2B8B0|Coral Dust'
            '2173-40|#C88D81|Antique Rose'
            '2173-30|#9E5D4B|Salmon Stream'
            '2173-20|#8D4E3A|Tawny Rose'
            '2173-10|#804531|Earthly Russet'
            '2174-70|#F9E9E4|Cream Puff'
            '2174-60|#F4D7D1|Dream Whip'
            '2174-50|#E8BBB4|Eraser Pink'
            '2174-40|#D29185|Dusty Mauve'
            '2174-30|#AB604E|Sedona Clay'
            '2174-20|#984F3B|Cinnamon'
            '2174-10|#88442E|Toasted Chestnut'
            '2175-70|#F9E7DA|Peach Parfait'
            '2175-60|#F6D4C1|Light Salmon'
            '2175-50|#EAB59D|Peach Blossom'
            '2175-40|#D48D6C|Adobe Dust'
            '2175-30|#B66340|Rust'
            '2175-20|#AD5935|Pilgrimage Foliage'
            '2175-10|#A65330|Aztec Brick')
          TabOrder = 0
          Visible = False
          WordWrap = False
        end
        object edColorNumber: TEdit
          Left = 83
          Top = 5
          Width = 54
          Height = 21
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 1
        end
        object edColorHex: TEdit
          Left = 175
          Top = 5
          Width = 59
          Height = 21
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 2
          Text = '#DDDDDD'
        end
        object edColorName: TEdit
          Left = 283
          Top = 5
          Width = 294
          Height = 21
          ReadOnly = True
          TabOrder = 3
        end
      end
      object sbNavigation: TScrollBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 951
        Height = 91
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alTop
        TabOrder = 1
        object pnlContainer: TPanel
          Left = 0
          Top = 0
          Width = 1780
          Height = 69
          BevelOuter = bvNone
          TabOrder = 0
          object pbColors: TPaintBox
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 1760
            Height = 49
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alClient
            OnMouseDown = pbColorsMouseDown
            OnPaint = pbColorsPaint
            ExplicitLeft = -951
            ExplicitTop = 11
            ExplicitWidth = 1780
            ExplicitHeight = 50
          end
        end
      end
      object sgColors: TStringGrid
        AlignWithMargins = True
        Left = 3
        Top = 100
        Width = 951
        Height = 282
        Align = alClient
        ColCount = 8
        DefaultDrawing = False
        DrawingStyle = gdsClassic
        FixedCols = 0
        RowCount = 7
        FixedRows = 0
        GridLineWidth = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ScrollBars = ssNone
        TabOrder = 2
        OnClick = sgColorsClick
        OnDrawCell = sgColorsDrawCell
      end
    end
    object tabPattern: TTabSheet
      Caption = 'Predefined colors'
      ImageIndex = 1
      object pbPattern: TPaintBox
        AlignWithMargins = True
        Left = 3
        Top = 292
        Width = 951
        Height = 122
        Align = alBottom
        OnPaint = pbPatternPaint
        ExplicitLeft = 0
        ExplicitTop = 304
        ExplicitWidth = 839
      end
      object lvPatterns: TListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 951
        Height = 283
        Align = alClient
        Columns = <>
        IconOptions.AutoArrange = True
        PopupMenu = pmPatterns
        TabOrder = 0
        OnSelectItem = lvPatternsSelectItem
      end
    end
  end
  object pmPatterns: TPopupMenu
    Left = 564
    Top = 208
    object Reloadpatterns1: TMenuItem
      Caption = 'Reload predefined patterned samples'
      OnClick = Reloadpatterns1Click
    end
  end
end
