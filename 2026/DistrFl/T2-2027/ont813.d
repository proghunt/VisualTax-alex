Schedule HDR
 1000        OPG_1    1   Corporations Tax            M   N           FH BTI    020
 1090        OPG_3    47  Date Control was            O   D           FH DTM    030 801
 1100        OPG_1    38  Date of                     M   D           FH DTM    030 ZZZ
 1110        OPG_1    36  Return for                  M   D           FH DTM    030 193
 1120        OPG_1    37  Return for                  M   D           FH DTM    030 194
 1181        OPG_1    42  If not                      O   D           FH DTM    030 447
 1182        OPG_1    43  If not                      O   D           FH DTM    030 379
 1362        OPG_1    10  Date of Change              O   D           FH DTM    030 152
 7630        OPG_17   20  Date of                     O   D           FH DTM    030 467
 1001        OPG_1    53  MCCR Annual Return          O   1/2         FH TIA    040
 1010        OPG_3    38  First Year Filing           O   1/          FH TIA    040
 1020        OPG_3    39  Amended Return              O   1/          FH TIA    040
 1030        OPG_3    40  Taxation Year End           O   1/          FH TIA    040
 1040        OPG_3    41  Final Taxation              O   1/          FH TIA    040
 1050        OPG_3    42  Final Taxation              O   1/          FH TIA    040
 1060        OPG_3    43  Floating Fiscal             O   1/          FH TIA    040
 1070        OPG_3    44  Transfer or                 O   1/          FH TIA    040
 1091        OPG_3    65  non-arms tx                 O   1/          FH TIA    040
 1092        OPG_3    66  first yr                    O   1/          FH TIA    040
 1093        OPG_3    67  section 83.1                O   1/          FH TIA    040
 1080        OPG_3    45  Acquisition of              O   1/          FH TIA    040
 1130        OPG_3    50  Has Canada Customs          O   1/2         FH TIA    040
 1180        OPG_1    41  Jurisdiction                M   A           FH TIA    040
 1183        OPG_1    44  If not                      O   1/          FH TIA    040
 1190        OPG_3    13  Specify major               O   A           FH TIA    040
 1200        OPG_3    48  Was the                     O   1/2         FH TIA    040
 1210        OPG_1    45  Language of Choice          O   1/2         FH TIA    040
 1361        OPG_1    9   Has Address                 O   N           FH TIA    040
 1578        OPG_1    35  Former Corporation          O   1/          FH TIA    040
 1580        OPG_3    4   Type of corp                O   N           FH TIA    040
 1581        OPG_3    9   Other Specify               O   A           FH TIA    040
 1590        OPG_1    47  State number of             O   N           FH TIA04  040
 1591        OPG_1    48  If there is no              O   1/          FH TIA    040
 1602        OPG_1    50  Director                    O   1/          FH TIA    040
 1603        OPG_1    51  Officer                     O   1/          FH TIA    040
 1604        OPG_1    52  Other individual            O   1/          FH TIA    040
 1630        OPG_3    10  Share Cap. with             O   %           FH TIA06  040
 1640        OPG_3    20  Type of                     O   N           FH TIA    040
 1790        OPG_3    52  Requesting a                O   1/2         FH TIA    040
 1800        OPG_3    54  Requesting a                O   1/2         FH TIA    040
 1810        OPG_3    56  Requesting a                O   1/2         FH TIA    040
 1820        OPG_3    58  Member of a                 O   1/2         FH TIA    040
 1150        OPG_1    ?   CCRA Business No [40]       M   A           FH BTI    020
 1145        OPG_1    39  Ontario                     O   N           FH REF    050 23
 1160        OPG_3    11  Ont. Retail Sales           O   N           FH REF    050 GT
 1170        OPG_3    12  Ontario Employer            O   N           FH REF    050 A9
 1111        N/A      N/A transaction                 O   A           FH TRN    060
 1260        OPG_1    2   Corporation's Name          M   A           FH N1     070 31
 1260        OPG_1    3   address 1                   O   A           FH N3     090
 1300        OPG_1    5   address                     O   A           FH N4     100
 1370        OPG_1    2   name                        O   A           FH N1     070 CQ
 1370        OPG_1    11  name                        O   A           FH N3     090
 1390        OPG_1    13  city                        O   A           FH N4     100
 1460        OPG_1    2   corp name                   O   A           FH N1     070 SB
 1460        OPG_1    18  adress 1                    O   A           FH N3     090
 1480        OPG_1    20  city                        O   A           FH N4     100
 1550        OPG_1    25  Name of Person to           O   A           FH PER    105 IC
 1571        OPG_1    2   name                        O   A           FH N1     070 ABE
 1571        OPG_1    28  name                        O   A           FH N3     090
 1573        OPG_1    30  city                        O   A           FH N4     100
 1577        OPG_1    34  Former Corporation          O   A           FH N1     070 AZ
 1600        OPG_1    49  Name of Authorized          O   A           FH N1     070 43
 7510        OPG_17   45  Certification Name          O   A           FH N1     070 AF
 7520        OPG_17   51  street                      O   A           FH N3     090
 7550        OPG_17   52  city                        O   A           FH N4     100
 7620        OPG_17   45  Signature of                M   A           FH N1     070 PV
 7625        OPG_17   48  title                       O   A           FH N1     070 07
SEND

Schedule 100  Corporation Tax
FGS          INCTAX
 1840        OPG_4    2   Charitable                  O   $           FD TIA    200
 1850        OPG_4    3   Gifts to Her                O   $           FD TIA    200
 1860        OPG_4    4   Taxable dividend            O   $           FD TIA    200
 1870        OPG_4    5   Ontario political           O   $           FD TIA    200
 1880        OPG_4    6   Federal Part VI.1           O   $           FD TIA    200
 1890        OPG_4    7   Federal part                O   $           FD TIA    200
 1891        OPG_4    58  Inclusive rate              O   %           FD TIA06  200
 1960        OPG_4    14  Addition to                 O   $           FD TIA    200
 1970        OPG_4    15  Adjusted Taxable            O   $           FD TIA    200
 1980        OPG_4    65  Taxable Income              O   $           FD TIA    200
 1990        OPG_4    66  Ontario                     O   %           FD TIA06  200
 1965        OPG_4    68  days                        O   N           FD TIA04  200
 1967        OPG_4    69  Total Days                  O   N           FD TIA04  200
 1966        OPG_4    34  Days after May 1,           O   N           FD TIA04  200
 1995        OPG_4    78  days                        O   N           FD TIA04  200
 2010        OPG_4    21  Did you claim the           O   1/2         FD TIA03  200
 2020        OPG_4    23  Income from                 O   $           FD TIA    200
 2030        OPG_4    24  Federal taxable             O   $           FD TIA    200
 2040        OPG_4    25  Losses of other             O   $           FD TIA    200
 2050        OPG_4    26  Losses of other             O   $           FD TIA    200
 2070        OPG_4    29  Business limit              O   $           FD TIA    200
 2004        OPG_4    77  Days after                  O   N           FD TIA04  200
 2006        OPG_4    38  Days after                  O   N           FD TIA04  200
 2071        OPG_4    40  fed %                       O   %           FD TIA06  200
 2072        OPG_4    56  bus limit                   O   $           FD TIA    200
 2080        OPG_4    30  Ontario                     O   %           FD TIA06  200
 2090        OPG_4    32  Income eligible             O   $           FD TIA    200
 2095        OPG_5    73  Total Days                  O   N           FD TIA04  200
 2130        OPG_5    36  Taxable Income of           O   $           FD TIA    200
 2140        OPG_5    38  If you are a                O   1/          FD TIA03  200
 2007        OPG_5    33  Days after                  O   N           FD TIA04  200
 2105        OPG_5    34  Days before Jan             O   N           FD TIA04  200
 TABLE        SCCPCMAG    2160 2170 2150 2180
*2160        OT2013  9   79  7   OT2013               O   N           FD REF    140 A9
*2170        OT2013  10  80  7   OT2013               O   D           FD DTM    150 091
*2150        OT2013  8   78  7   OT2013               O   N           FD N1     160 2L
*2180        OT2013  11  81  7   OT2013               O   $           FD TIA    200
FGS          MANDP
 2360        OPG_6    4   Additional                  O   $           FD TIA    200
 2380        OPG_6    5   Eligible Canadian           O   $           FD TIA    200
 2410        OPG_6    8   Ontario                     O   %           FD TIA06  200
 2430        OPG_6    11  Lesser of 56 or             O   $           FD TIA    200
 2480        OPG_6    16  Taxable income x            O   $           FD TIA    200
 2490        OPG_6    17  Amount by which             O   $           FD TIA    200
 2510        OPG_6    31  Claim                       O   $           FD TIA    200
 2520        OPG_6    32  Ontario                     O   %           FD TIA06  200
 2528        OPG_6    36  Days after Dec.             O   N           FD TIA04  200
 2522        OPG_6    37  Days after Dec.             O   N           FD TIA04  200
 2531        OPG_6    40  Days after Dec.             O   N           FD TIA04  200
 2541        OPG_6    28  Manufacturing and           O   $           FD TIA    200
 2542        OPG_6    23  M & P Profits               O   $           FD TIA    200
 2550        OPG_6    24  Paid tax to a               O   $           FD TIA    200
 2560        OPG_6    25  Eligible Credit -           O   $           FD TIA    200
 2570        OPG_6    26  Credit Claimed -            O   $           FD TIA    200
FGS          SPECTXCR
 2609        OPG_7    19  Film name                   O   A           FD N1     160 18
 2590        OPG_7    1   Eligible credit             O   $           FD TIA    200
 2600        OPG_7    2   Eligible credit             O   $           FD TIA    200
 2610        OPG_7    3   Eligible credit             O   $           FD TIA    200
 2611        OPG_7    4   Graduate                    O   N           FD TIA04  200
 2612        OPG_7    5   Eligible credit             O   $           FD TIA    200
 2613        OPG_7    6   Eligible credit             O   $           FD TIA    200
 2614        OPG_7    7   Eligible credit             O   $           FD TIA    200
 2615        OPG_7    8   Eligible Credit             O   $           FD TIA    200
 2616        OPG_7    9   Eligible Credit             O   $           FD TIA    200
 2617        OPG_7    16  Eligible Credit             O   $           FD TIA    200
 2618        OPG_7    17  Eligible Credit             O   $           FD TIA    200
 2619        OPG_7    20  Graduate                    O   N           FD TIA04  200
 2621        OPG_7    21  Eligible Credit             O   $           FD TIA    200
 2630        OPG_7    11  Specified Tax               O   $           FD TIA    200
FGS          CORPMINTX
 2650        OPG_8    1   Total Assets                O   $           FD TIA    200
 2660        OPG_8    2   Total Revenue               O   $           FD TIA    200
 2670        OPG_8    4   If you are a                O   1/          FD TIA03  200
 2850        OPG_8    25  CMT Base - From             O   $           FD TIA    200
 2950        OPG_8    34  Factor III Based            O   $           FD TIA    200
 2970        OPG_8    35  Foreign Tax                 O   $           FD TIA    200
 2990        OPG_8    37  Net CMT Payable             O   $           FD TIA    200
 3000        OPG_8    38  CMT Credit                  O   $           FD TIA    200
 3070        OPG_8    47  CMT credit used             O   $           FD TIA    200
TABLE        CMTMAG      2690 2700 2680 2710 2720
*2690        OCMTASS 5   100 5   OCMTASS              O   N           FD REF    140 A9
*2700        OCMTASS 6   101 5   OCMTASS              O   D           FD DTM    150 091
*2680        OCMTASS 4   99  5   OCMTASS              O   AN          FD N1     160 2L
*2710        OCMTASS 7   102 5   OCMTASS              O   $           FD TIA    200
*2720        OCMTASS 8   103 5   OCMTASS              O   $           FD TIA    200
FGS          CAPTXPDUP
 3110        OPG_9    4   Paid-Up Capital             O   $           FD TIA    200
 3120        OPG_9    5   Retained earning            O   $           FD TIA    200
 3130        OPG_9    6   Capital & other             O   $           FD TIA    200
 3140        OPG_9    7   Loans and                   O   $           FD TIA    200
 3150        OPG_9    8   Bank Loans                  O   $           FD TIA    200
 3160        OPG_9    9   Bankers                     O   $           FD TIA    200
 3170        OPG_9    10  Bonds and                   O   $           FD TIA    200
 3180        OPG_9    11  Mortgages payable           O   $           FD TIA    200
 3190        OPG_9    12  Lien Notes                  O   $           FD TIA    200
 3200        OPG_9    13  Deferred credits            O   $           FD TIA    200
 3210        OPG_9    14  Contingent,                 O   $           FD TIA    200
 3220        OPG_9    15  Other reserves              O   $           FD TIA    200
 3230        OPG_9    16  Share of                    O   $           FD TIA    200
 3250        OPG_9    18  Amounts deducted            O   $           FD TIA    200
 3251        OPG_9    30  Deductible R& D             O   $           FD TIA    200
 3270        OPG_9    20  Deferred Mining             O   $           FD TIA    200
 3271        OPG_9    22  electrical gen              O   $           FD TIA    200
 3310        OPG_9    24  Bonds, debentures           O   $           FD TIA    200
 3320        OPG_9    25  Mortgages due               O   $           FD TIA    200
 3330        OPG_9    26  Shares in other             O   $           FD TIA    200
 3340        OPG_9    27  Loans and                   O   $           FD TIA    200
 3341        OPG_9    31  Eligible loans              O   $           FD TIA    200
 3350        OPG_9    28  Share of                    O   $           FD TIA    200
TABLE        PUCLA       3131 3132
*3131        OPUCLA  4   50  2   OPUCLA               O   N           FD N1     160 2L
*3132        OPUCLA  5   51  2   OPUCLA               O   $           FD TIA    200
TABLE        PUCOR       3211 3212 3213 3214 3215 3216
*3211        OPUCOR  4   130 6   OPUCOR               O   N           FD TIA03  200
*3212        OPUCOR  5   131 6   OPUCOR               O   $           FD TIA    200
*3213        OPUCOR  6   132 6   OPUCOR               O   $           FD TIA    200
*3214        OPUCOR  7   133 6   OPUCOR               O   $           FD TIA    200
*3215        OPUCOR  8   134 6   OPUCOR               O   $           FD TIA    200
*3216        OPUCOR  9   135 6   OPUCOR               O   $           FD TIA    200
TABLE        PUCPJV      3221 3222 3223 3224
*3221        OPUCPJ  4   96  4   OPUCPJ               O   N           FD N1     160 2L
*3222        OPUCPJ  5   97  4   OPUCPJ               O   %           FD TIA06  200
*3223        OPUCPJ  6   98  4   OPUCPJ               O   $           FD TIA    200
*3224        OPUCPJ  7   99  4   OPUCPJ               O   $           FD TIA    200
TABLE        ELIGINV     3342 3343 3344 3345
*3342        OELGPJ  4   84  4   OELGPJ               O   N           FD N1     160 2L
*3343        OELGPJ  5   85  4   OELGPJ               O   %           FD TIA06  200
*3344        OELGPJ  6   86  4   OELGPJ               O   $           FD TIA    200
*3345        OELGPJ  7   87  4   OELGPJ               O   $           FD TIA    200
FGS          CAPTX
 3370        OPG_10   1   Total Assets per            O   $           FD TIA    200
 3380        OPG_10   2   Mortgages or                O   $           FD TIA    200
 3390        OPG_10   3   Investment in               O   $           FD TIA    200
 3400        OPG_10   4   Total Assets as             O   $           FD TIA    200
 3410        OPG_10   5   Total Assets as             M   $           FD TIA    200
 3420        OPG_10   6   Amounts in 360 &            O   $           FD TIA    200
 3430        OPG_10   7   Amounts in 371 ,            O   $           FD TIA    200
 3440        OPG_10   8   Appraisal surplus           O   $           FD TIA    200
 3450        OPG_10   9   Other adjustments           O   $           FD TIA    200
 3500        OPG_10   11  Investment                  O   $           FD TIA    200
 3520        OPG_10   13  Gross Revenue               M   $           FD TIA    200
 3533        OPG_10   33  Days after                  O   N           FD TIA04  200
 3531        OPG_10   35  Days after                  O   N           FD TIA04  200
 3532        OPG_10   38  Days after                  O   N           FD TIA04  200
 3534        OPG_10   41  Investment                  O   $           FD TIA    200
 3541        OPG_10   44  Days after                  O   N           FD TIA04  200
 3542        OPG_10   47  Days after                  O   N           FD TIA04  200
 3551        OPG_10   37  Investment                  O   $           FD TIA    200
 3552        OPG_10   40  Investment                  O   $           FD TIA    200
 3553        OPG_10   42  Investment                  O   $           FD TIA    200
 3554        OPG_10   45  Investment                  O   $           FD TIA    200
 3560        OPG_10   34  Days after                  O   N           FD TIA04  200
 3561        OPG_10   50  Days after                  O   N           FD TIA04  200
 3565        OPG_10   22  Investment                  O   %           FD TIA06  200
 3566        OPG_10   48  Investment                  O   %           FD TIA06  200
 3569        OPG_10   51  Investment                  O   %           FD TIA06  200
 7051        OPG_11   39  fron 470                    O   $           FD TIA    200
 7052        OPG_11   37  fron 471                    O   $           FD TIA    200
 7053        OPG_11   36  Ontario                     O   %           FD TIA06  200
 7054        OPG_11   34  Ontario                     O   N           FD TIA04  200
 7060        OPG_11   33  Portion of                  O   $           FD TIA    200

 7055        OPG_11   22  assoc no pe                 O   1/          FD TIA03  200
 7056        OPG_11   24  assoc with pe               O   1/          FD TIA03  200
 3600        OPG_11   04  taxbl cap                   O   $           FD TIA    200
 3735        OPG_11   20  taxbl cap                   O   $           FD TIA    200
 7057        OPG_11   23  election filed              O   1/          FD TIA03  200

 7500        OPG_12   04  taxbl cap                   O   $           FD TIA    200
 7501        OPG_12   05  taxbl cap                   O   $           FD TIA    200
 7502        OPG_12   06  taxbl cap                   O   $           FD TIA    200
 7504        OPG_12   10  taxbl cap                   O   $           FD TIA    200
 7511        OPG_12   11  taxbl cap                   O   $           FD TIA    200
 7512        OPG_12   14  taxbl cap                   O   $           FD TIA    200
 7513        OPG_12   15  taxbl cap                   O   $           FD TIA    200
 7514        OPG_12   16  taxbl cap                   O   $           FD TIA    200
 7517        OPG_12   19  taxbl cap                   O   $           FD TIA    200
 3800        OPG_12   22  Capital Tax                 O   $           FD TIA    200
 3810        OPG_12   23  Specified Tax               O   $           FD TIA    200
 3820        OPG_12   24  Capital Tax                 O   $           FD TIA    200

TABLE        SHARETA     3381 3382 3383 3384
*3381        OSHRTA  4   84  4   OSHRTA               O   AN          FD N1     160 2L
*3382        OSHRTA  5   85  4   OSHRTA               O   %           FD TIA06  200
*3383        OSHRTA  6   86  4   OSHRTA               O   $           FD TIA    200
*3384        OSHRTA  7   87  4   OSHRTA               O   $           FD TIA    200
TABLE        TOTASSET    3441 3442
*3441        OTAADJ  4   52  2   OTAADJ               O   AN          FD TIA03  200
*3442        OTAADJ  5   53  2   OTAADJ               O   $           FD TIA    200

TABLE        MAGCAN      3612 3613 3611 3614
*3612        OCT21   5   121 4   OCT21                O   N           FD REF    140 A9
*3613        OCT21   6   122 4   OCT21                O   D           FD DTM    150 091
*3611        OCT21   4   120 4   OCT21                O   AN          FD N1     160 2L
*3614        OCT21   7   123 4   OCT21                O   $           FD TIA    200

FGS          CPTX
 3825        OPG_13   5   Total Days                  O   N           FD TIA04  200
 3827        OPG_13   11  Lesser of                   O   $           FD TIA    200
 3828        OPG_13   3   Capital Tax Rate            O   %           FD TIA06  200
 3829        OPG_13   12  Ontario                     O   %           FD TIA06  200
 3830        OPG_13   14  Days in Taxation            O   N           FD TIA04  200
 3833        OPG_13   16  TPUC adjusted in            O   $           FD TIA    200
 3834        OPG_13   10  Capital Tax Rate            O   %           FD TIA06  200
 3836        OPG_13   19  Days in Taxation            O   N           FD TIA04  200
 3890        OPG_13   29  Allowable Credit            O   $           FD TIA    200
 3891        OPG_13   30  Financial                   O   1/          FD TIA03  200
FGS          PREMTX
 3910        OPG_13   35  Uninsured                   O   $           FD TIA    200
 3930        OPG_13   37  Specified Tax               O   $           FD TIA    200
 3940        OPG_13   38  Premium Tax                 O   $           FD TIA    200
 3950        OPG_14   10  Net Income (loss)           O   $           FD TIA    200
 3960        OPG_14   11  Federal capital             O   $           FD TIA    200
 3970        OPG_14   12  Federal                     O   $           FD TIA    200
 3980        OPG_14   13  Ontario taxable             O   $           FD TIA    200
 3990        OPG_14   14  Federal non                 O   $           FD TIA    200
 4000        OPG_14   15  Federal allowable           O   $           FD TIA    200
 4010        OPG_14   16  Ontario non                 O   $           FD TIA    200
 4020        OPG_14   17  Ontario allowable           O   $           FD TIA    200
 4030        OPG_14   18  Federal                     O   $           FD TIA    200
 4040        OPG_14   19  Federal resource            O   $           FD TIA    200
 4050        OPG_14   20  Federal depletion           O   $           FD TIA    200
 4060        OPG_14   21  Federal foreign             O   $           FD TIA    200
 4065        OPG_14   9   Crown...                    O   $           FD TIA    200
 4061        OPG_14   39  Fedescient research         O   $           FD TIA    200
 4063        OPG_14   22  add negative                O   $           FD TIA    200
 4070        OPG_14   32  Management fees,            O   $           FD TIA    200
 4080        OPG_14   23  Federal allowable           O   $           FD TIA    200
 4081        OPG_14   31  Federal allowable           O   $           FD TIA    200
 4090        OPG_14   33  Days after May 1,           O   N           FD TIA04  200
 4095        OPG_14   34  Days after May 1,           O   N           FD TIA04  200
 4092        OPG_14   05  Days after May 1,           O   N           FD TIA04  200
 4100        OPG_14   25  Total of other              O   $           FD TIA    200

 4120        OPG_14   40  Ontario capital             O   $           FD TIA    200
 4130        OPG_14   41  Ontario                     O   $           FD TIA    200
 4140        OPG_14   42  Federal taxable             O   $           FD TIA    200
 4150        OPG_14   43  Ontario non                 O   $           FD TIA    200
 4160        OPG_14   44  Ontario allowable           O   $           FD TIA    200
 4170        OPG_14   45  Federal non                 O   $           FD TIA    200
 4180        OPG_14   46  Federal allowable           O   $           FD TIA    200
 4190        OPG_14   47  Ontario                     O   $           FD TIA    200
 4200        OPG_14   48  Ontario depletion           O   $           FD TIA    200
 4210        OPG_14   49  Ontario resource            O   $           FD TIA    200
 4230        OPG_14   50  Ontario current             O   $           FD TIA    200
 4233        OPG_14   52  Ontario current             O   $           FD TIA    200
 4234        OPG_14   53  Ontario current             O   $           FD TIA    200

 4231        OPG_15   06  Ontario current             O   $           FD TIA    200
 4240        OPG_15   30  Workplace Child             O   $           FD TIA    200
 4244        OPG_15   59  Workplace                   O   $           FD TIA    200
 4248        OPG_15   58  Number of                   O   N           FD TIA04  200
 4249        OPG_15   4   Ontario School              O   $           FD TIA    200
 4250        OPG_15   52  Total of other              O   $           FD TIA    200

 4254        OPG_15   1   Educational                 O   $           FD TIA    200
 4256        OPG_15   11  Ontario allowable           O   $           FD TIA    200
 4062        OPG_15   15  Ontario scient reasearch    O   $           FD TIA    200
 4064        OPG_15   16  amount added to income      O   $           FD TIA    200
TABLE        PREM        3924 3921 3923 3925 3926 3922 3927 3928 3929
*3924        OPRMTAX 10  164 14  OPRMTAX              O   D           FD DTM    150 196
*3921        OPRMTAX 4   158 14  OPRMTAX              O   AN          FD N1     160 IR
*3923        OPRMTAX 8   162 14  OPRMTAX              O   AN          FD N1     160 PP
*3925        OPRMTAX 11  165 14  OPRMTAX              O   AN          FD N1     160 IU
*3926        OPRMTAX 13  167 14  OPRMTAX              O   AN          FD N3     180
*3922        OPRMTAX 6   160 14  OPRMTAX              O   N           FD TIA03  200
*3927        OPRMTAX 15  169 14  OPRMTAX              O   $           FD TIA    200
*3928        OPRMTAX 16  170 14  OPRMTAX              O   %           FD TIA06  200
*3929        OPRMTAX 17  171 14  OPRMTAX              O   $           FD TIA    200
TABLE        ADD         4101 4102
*4101        OOTHIT  4   52  2   OOTHIT               O   AN          FD TIA03  200
*4102        OOTHIT  5   53  2   OOTHIT               O   $           FD TIA    200
TABLE        DED         4251 4252
*4251        OOTHDED 4   52  2   OOTHDED              O   AN          FD TIA03  200
*4252        OOTHDED 5   52  2   OOTHDED              O   $           FD TIA    200
FGS          CONTLOSS
 4280        OPG_16   1   Balance at                  O   $           FD TIA    200
 4290        OPG_16   7   Current year's              O   $           FD TIA    200
 4300        OPG_16   13  Losses from                 O   $           FD TIA    200
 4320        OPG_16   24  Utilized during             O   $           FD TIA    200
 4330        OPG_16   30  Expired during              O   $           FD TIA    200
 4340        OPG_16   35  Carried back to             O   $           FD TIA    200
 4371        OPG_16   2   Balance at                  O   $           FD TIA    200
 4381        OPG_16   8   Current year's              O   $           FD TIA    200
 4391        OPG_16   14  Losses from                 O   $           FD TIA    200
 4410        OPG_4    9   Utilized during             O   $           FD TIA    200
 4411        OPG_16   25  Utilized during             O   $           FD TIA    200
 4431        OPG_16   31  Carried back to             O   $           FD TIA    200
 4460        OPG_16   3   Balance at                  O   $           FD TIA    200
 4470        OPG_16   9   Current year's              O   $           FD TIA    200
 4480        OPG_16   15  Losses from                 O   $           FD TIA    200
 4500        OPG_16   26  Utilized during             O   $           FD TIA    200
 4510        OPG_16   32  Expired during              O   $           FD TIA    200
 4520        OPG_16   40  Carried back to             O   $           FD TIA    200
 4560        OPG_16   4   Balance at                  O   $           FD TIA    200
 4570        OPG_16   10  Current year's              O   $           FD TIA    200
 4580        OPG_16   16  Losses from                 O   $           FD TIA    200
 4600        OPG_16   27  Utilized during             O   $           FD TIA    200
 4610        OPG_16   33  Expired during              O   $           FD TIA    200
 4620        OPG_16   37  Carried back to             O   $           FD TIA    200
 4650        OPG_16   5   Balance at                  O   $           FD TIA    200
 4660        OPG_16   11  Current year's              O   $           FD TIA    200
 4690        OPG_16   28  Utilized during             O   $           FD TIA    200
 4700        OPG_16   38  Expired during              O   $           FD TIA    200
 4710        OPG_16   34  Carried back to             O   $           FD TIA    200
 4740        OPG_16   6   Balance at                  O   $           FD TIA    200
 4750        OPG_16   12  Current year's              O   $           FD TIA    200
 4760        OPG_16   17  Losses from                 O   $           FD TIA    200
 4780        OPG_16   29  Utilized during             O   $           FD TIA    200
FGS          ANBAL
 4830        OPG_16   51  Year of Origin -            O   D           FD DTM    150 LTP
 4840        OPG_16   57  Year of Origin -            O   D           FD DTM    150 ABD
 4850        OPG_16   63  Year of Origin -            O   D           FD DTM    150 090
 4860        OPG_16   69  Year of Origin -            O   D           FD DTM    150 140
 4870        OPG_16   75  Year of Origin -            O   D           FD DTM    150 193
 4880        OPG_16   81  Year of Origin -            O   D           FD DTM    150 196
 4890        OPG_16   87  Year of Origin -            O   D           FD DTM    150 242
 4900        OPG_16   93  Year of Origin -            O   D           FD DTM    150 AB3
 4910        OPG_16   99  Year of Origin -            O   D           FD DTM    150 621
 4920        OPG_16   105 Year of Origin -            O   D           FD DTM    150 ETP
 4931        OPG_16   53  7th Prior Non-              O   $           FD TIA    200
 4932        OPG_16   58  7th Prior Non-              O   $           FD TIA    200
 4933        OPG_16   60  7th Prior Non-              O   $           FD TIA    200
 4930        OPG_16   70  7th Prior Non-              O   $           FD TIA    200
 4940        OPG_16   76  6th Prior Non-              O   $           FD TIA    200
 4950        OPG_16   82  5th Prior Non-              O   $           FD TIA    200
 4960        OPG_16   88  4th Prior Non-              O   $           FD TIA    200
 4970        OPG_16   94  3rd Prior Non-              O   $           FD TIA    200
 4980        OPG_16   100 2nd Prior Non-              O   $           FD TIA    200
 4990        OPG_16   106 1st Prior Non-              O   $           FD TIA    200
 5007        OPG_16   54  7th Prior NCL of            O   $           FD TIA    200
 5008        OPG_16   59  7th Prior NCL of            O   $           FD TIA    200
 5009        OPG_16   64  7th Prior NCL of            O   $           FD TIA    200
 5010        OPG_16   71  7th Prior NCL of            O   $           FD TIA    200
 5020        OPG_16   77  6th Prior NCL of            O   $           FD TIA    200
 5030        OPG_16   83  5th Prior NCL of            O   $           FD TIA    200
 5040        OPG_16   89  4th Prior NCL of            O   $           FD TIA    200
 5050        OPG_16   95  3rd Prior NCL of            O   $           FD TIA    200
 5060        OPG_16   101 2nd Prior NCL of            O   $           FD TIA    200
 5070        OPG_16   107 1st Prior NCL of            O   $           FD TIA    200
 5091        OPG_16   72  7th Prior Total             O   $           FD TIA    200
 5101        OPG_16   78  6th Prior Total             O   $           FD TIA    200
 5111        OPG_16   84  5th Prior Total             O   $           FD TIA    200
 5121        OPG_16   90  4th Prior Total             O   $           FD TIA    200
 5131        OPG_16   96  3rd Prior Total             O   $           FD TIA    200
 5141        OPG_16   102 2nd Prior Total             O   $           FD TIA    200
 5151        OPG_16   108 1st Prior Total             O   $           FD TIA    200
 5170        OPG_16   55  10th Prior Farm             O   $           FD TIA    200
 5180        OPG_16   61  9th   Prior Farm            O   $           FD TIA    200
 5190        OPG_16   67  8th   Prior Farm            O   $           FD TIA    200
 5200        OPG_16   73  7th   Prior Farm            O   $           FD TIA    200
 5210        OPG_16   79  6th   Prior Farm            O   $           FD TIA    200
 5220        OPG_16   85  5th   Prior Farm            O   $           FD TIA    200
 5230        OPG_16   91  4th   Prior Farm            O   $           FD TIA    200
 5240        OPG_16   97  2nd  Prior Farm             O   $           FD TIA    200
 5250        OPG_16   103 2nd  Prior Farm             O   $           FD TIA    200
 5260        OPG_16   109 1st   Prior Farm            O   $           FD TIA    200
 5280        OPG_16   56  10th Prior RFL -            O   $           FD TIA    200
 5290        OPG_16   62  9th   Prior RFL -           O   $           FD TIA    200
 5300        OPG_16   68  8th   Prior RFL -           O   $           FD TIA    200
 5310        OPG_16   74  7th   Prior RFL -           O   $           FD TIA    200
 5320        OPG_16   80  6th   Prior RFL -           O   $           FD TIA    200
 5330        OPG_16   86  5th   Prior RFL -           O   $           FD TIA    200
 5340        OPG_16   92  4th   Prior RFL -           O   $           FD TIA    200
 5350        OPG_16   98  3rd   Prior RFL -           O   $           FD TIA    200
 5360        OPG_16   104 2nd   Prior RFL -           O   $           FD TIA    200
 5370        OPG_16   110 1st   Prior RFL -           O   $           FD TIA    200
FGS          APPLOSS
 5390        OPG_17   12  3rd preceding               O   N           FD REF    140 03
 5400        OPG_17   14  2nd preceding               O   N           FD REF    140 02
 5410        OPG_17   21  1st preceding               O   N           FD REF    140 01
 5420        OPG_17   13  Taxation Year               O   D           FD DTM    150 091
 5430        OPG_17   15  Taxation Year               O   D           FD DTM    150 194
 5440        OPG_17   26  Taxation Year               O   D           FD DTM    150 197
 5810        OPG_17   49  Apply overpyment            O   D           FD DTM    150 995
 5450        OPG_17   4   Non-capital                 O   $           FD TIA    200
 5460        OPG_17   8   Non-Capital                 O   $           FD TIA    200
 5470        OPG_17   16  Non-Capital                 O   $           FD TIA    200
 5480        OPG_17   22  Non-Capital                 O   $           FD TIA    200
 5500        OPG_17   31  Non-Capital                 O   $           FD TIA    200
 5511        OPG_17   5   Total Capital               O   $           FD TIA    200
 5521        OPG_17   9   Total Capital               O   $           FD TIA    200
 5531        OPG_17   17  Total Capital               O   $           FD TIA    200
 5541        OPG_17   23  Total Capital               O   $           FD TIA    200
 5561        OPG_17   32  Total Capital               O   $           FD TIA    200
 5570        OPG_17   6   Farm Losses                 O   $           FD TIA    200
 5580        OPG_17   10  Farm Losses                 O   $           FD TIA    200
 5590        OPG_17   18  Farm Losses                 O   $           FD TIA    200
 5600        OPG_17   24  Farm Losses                 O   $           FD TIA    200
 5620        OPG_17   33  Farm Losses                 O   $           FD TIA    200
 5630        OPG_17   7   Restricted Farm             O   $           FD TIA    200
 5640        OPG_17   11  Restricted Farm             O   $           FD TIA    200
 5650        OPG_17   19  Restricted Farm             O   $           FD TIA    200
 5660        OPG_17   25  Restricted Farm             O   $           FD TIA    200
 5680        OPG_17   34  Restricted Farm             O   $           FD TIA    200
 5690        OPG_17   35  Income Tax                  O   $           FD TIA    200
 5730        OPG_17   39  Total Tax Payable           M   $           FD TIA    200
 5740        OPG_17   40  Payments                    O   $           FD TIA    200
 5750        OPG_17   41  Capital Gains               O   $           FD TIA    200
 5760        OPG_17   42  Qualifying                  O   $           FD TIA    200
 5770        OPG_17   43  Specified Tax               O   $           FD TIA    200
 5780        OPG_17   44  Balance                     O   $           FD TIA    200
 5790        OPG_17   46  If payment ue               O   $           FD TIA    200
 5800        OPG_17   47  If overpaymnt:              O   $           FD TIA    200
 5820        OPG_17   50  Amount of                   O   $           FD TIA    200
SEND

Schedule 101  Corporate Minimum Tax
FGS          SCHEDA
 5830        OS101_1  1   Net Income (loss)           O   $           FD TIA    200
 5840        OS101_1  2   Provision for               O   $           FD TIA    200
 5850        OS101_1  3   Provision for               O   $           FD TIA    200
 5860        OS101_1  4   Equity income from          O   $           FD TIA    200
 5870        OS101_1  5   Share of                    O   $           FD TIA    200
 5880        OS101_1  6   Dividends                   O   $           FD TIA    200
 5890        OS101_1  7   Dividends                   O   $           FD TIA    200
 5900        OS101_1  8   Dividends                   O   $           FD TIA    200
 5901        OS101_1  44  Federal Part VI.1           O   $           FD TIA    200
 5902        OS101_1  42  Calculated Federal          O   $           FD TIA    200
 5903        OS101_1  51  Calculated Federal          O   $           FD TIA    200
 5920        OS101_1  11  Provision for               O   $           FD TIA    200
 5930        OS101_1  12  Provision for               O   $           FD TIA    200
 5940        OS101_1  13  Equity losses from          O   $           FD TIA    200
 5950        OS101_1  14  Share of                    O   $           FD TIA    200
 5951        OS101_1  43  Dividends that              O   $           FD TIA    200
 5970        OS101_1  17  Fed s. 85 plus              O   $           FD TIA    200
 5980        OS101_1  18  Fed s. 85 minus             O   $           FD TIA    200
 5990        OS101_1  19  Fed s. 85.1                 O   $           FD TIA    200
 6000        OS101_1  20  Fed s. 85.1                 O   $           FD TIA    200
 6010        OS101_1  21  Fed s. 97 plus              O   $           FD TIA    200
 6020        OS101_1  22  Fed s. 97 minus             O   $           FD TIA    200
 6030        OS101_1  23  Amounts relating            O   $           FD TIA    200
 6040        OS101_1  24  Amounts relating            O   $           FD TIA    200
 6050        OS101_1  25  Amounts relating            O   $           FD TIA    200
 6060        OS101_1  26  Amounts relating            O   $           FD TIA    200
 6070        OS101_1  27  Amounts relating            O   $           FD TIA    200
 6080        OS101_1  28  Amounts relating            O   $           FD TIA    200
 6085        OS101_1  45  Interest allowable          O   $           FD TIA    200
 6087        OS101_1  52  Interest allowable          O   $           FD TIA    200
 6130        OS101_1  33  Other adjustments           O   $           FD TIA    200
 6150        OS101_1  35  Share of                    O   $           FD TIA    200
 6160        OS101_1  36  Adjusted net                O   $           FD TIA    200
 6210        OS101_1  41  CMT Base                    O   $           FD TIA    200
FGS          SCHEDB
 6220        OS101_2  4   Balance at                  O   $           FD TIA    200
 6230        OS101_2  5   Current year's              O   $           FD TIA    200
 6240        OS101_2  6   Losses from                 O   $           FD TIA    200
 6250        OS101_2  7   Losses from                 O   $           FD TIA    200
 6260        OS101_2  8   Amalgamation                O   1/          FD TIA03  200
 6270        OS101_2  9   Wind-up CMTB                O   1/          FD TIA03  200
 6300        OS101_2  12  Adjustments CMTB            O   $           FD TIA    200
 6320        OS101_2  14  Pre-194 loss                O   $           FD TIA    200
 6330        OS101_2  15  Other eligible              O   $           FD TIA    200
 6340        OS101_2  51  Expired during the          O   $           FD TIA    200
FGS          SCHEDC
 6380        OS101_2  19  10th prior CMTC -           O   D           FD DTM    150 LTP
 6390        OS101_2  22  9th prior   CMTC -          O   D           FD DTM    150 ABD
 6400        OS101_2  25  8th prior   CMTC -          O   D           FD DTM    150 090
 6410        OS101_2  28  7th prior   CMTC -          O   D           FD DTM    150 140
 6420        OS101_2  31  6th prior   CMTC -          O   D           FD DTM    150 193
 6430        OS101_2  34  5th prior   CMTC -          O   D           FD DTM    150 196
 6440        OS101_2  37  4th prior   CMTC -          O   D           FD DTM    150 242
 6450        OS101_2  40  3rd prior   CMTC -          O   D           FD DTM    150 AB3
 6460        OS101_2  43  2nd prior  CMTC -           O   D           FD DTM    150 621
 6470        OS101_2  46  1st prior   CMTC -          O   D           FD DTM    150 ETP
 6480        OS101_2  20  10th prior CMT              O   $           FD TIA    200
 6490        OS101_2  23  9th prior   CMT             O   $           FD TIA    200
 6500        OS101_2  26  8th prior   CMT             O   $           FD TIA    200
 6510        OS101_2  29  7th prior   CMT             O   $           FD TIA    200
 6520        OS101_2  32  6th prior   CMT             O   $           FD TIA    200
 6530        OS101_2  35  5th prior   CMT             O   $           FD TIA    200
 6540        OS101_2  38  4th prior   CMT             O   $           FD TIA    200
 6550        OS101_2  41  3rd prior   CMT             O   $           FD TIA    200
 6560        OS101_2  44  2nd prior  CMT              O   $           FD TIA    200
 6570        OS101_2  47  1st prior  CMT              O   $           FD TIA    200
 6590        OS101_2  21  10th prior CMTLP -          O   $           FD TIA    200
 6600        OS101_2  24  9th prior   CMTLP           O   $           FD TIA    200
 6610        OS101_2  27  8th prior   CMTLP           O   $           FD TIA    200
 6620        OS101_2  30  7th prior   CMTLP           O   $           FD TIA    200
 6630        OS101_2  33  6th prior   CMTLP           O   $           FD TIA    200
 6640        OS101_2  36  5th prior   CMTLP           O   $           FD TIA    200
 6650        OS101_2  39  4th prior   CMTLP           O   $           FD TIA    200
 6660        OS101_2  42  3rd prior   CMTLP           O   $           FD TIA    200
 6670        OS101_2  45  2nd prior  CMTLP -          O   $           FD TIA    200
 6680        OS101_2  48  1st prior   CMTLP           O   $           FD TIA    200
FGS          SCHEDD
 6700        OS101_3  1   Balance at                  O   $           FD TIA    200
 6710        OS101_3  2   Current year's CMT          O   $           FD TIA    200
 6720        OS101_3  3   CMT Credit                  O   $           FD TIA    200
 6730        OS101_3  5   Amalgamation CMT            O   1/          FD TIA03  200
 6740        OS101_3  6   Wind-up CMT Credit          O   1/          FD TIA03  200
 6770        OS101_3  9   Adjustments CMT             O   $           FD TIA    200
 6780        OS101_3  10  CMT credit                  O   $           FD TIA    200
 6790        OS101_3  11  Utilized during             O   $           FD TIA    200
 6800        OS101_3  12  Expired during the          O   $           FD TIA    200
FGS          SCHEDE
 6840        OS101_3  16  10th prior                  O   D           FD DTM    150 LTP
 6850        OS101_3  19  9th prior                   O   D           FD DTM    150 ABD
 6860        OS101_3  22  8th prior                   O   D           FD DTM    150 090
 6870        OS101_3  25  7th prior                   O   D           FD DTM    150 140
 6880        OS101_3  28  6th prior                   O   D           FD DTM    150 193
 6890        OS101_3  31  5th prior                   O   D           FD DTM    150 196
 6900        OS101_3  34  4th prior                   O   D           FD DTM    150 242
 6910        OS101_3  37  3rd prior                   O   D           FD DTM    150 AB3
 6920        OS101_3  40  2nd prior                   O   D           FD DTM    150 621
 6930        OS101_3  43  1st prior                   O   D           FD DTM    150 ETP
 6940        OS101_3  17  10th prior                  O   $           FD TIA    200
 6950        OS101_3  20  9th   prior                 O   $           FD TIA    200
 6960        OS101_3  23  8th   prior                 O   $           FD TIA    200
 6970        OS101_3  26  7th   prior                 O   $           FD TIA    200
 6980        OS101_3  29  6th   prior                 O   $           FD TIA    200
 6990        OS101_3  32  5th   prior                 O   $           FD TIA    200
 7000        OS101_3  35  4th   prior                 O   $           FD TIA    200
 7010        OS101_3  38  3rd   prior                 O   $           FD TIA    200
 7020        OS101_3  41  2nd  prior                  O   $           FD TIA    200
 7030        OS101_3  44  1st   prior                 O   $           FD TIA    200
 7050        OS101_3  18  10th prior                  O   $           FD TIA    200
 7060        OS101_3  21  9th prior                   O   $           FD TIA    200
 7070        OS101_3  24  8th prior                   O   $           FD TIA    200
 7080        OS101_3  27  7th prior                   O   $           FD TIA    200
 7090        OS101_3  30  6th prior                   O   $           FD TIA    200
 7100        OS101_3  33  5th prior                   O   $           FD TIA    200
 7110        OS101_3  36  4th prior                   O   $           FD TIA    200
 7120        OS101_3  39  3rd prior                   O   $           FD TIA    200
 7130        OS101_3  42  2nd prior                   O   $           FD TIA    200
 7140        OS101_3  45  1st prior                   O   $           FD TIA    200
SEND

Schedule 102  Summary of Co-Op Student Tax Credit
TABLE        PARTII      7330 7310 7340 7350 7300 7320 7321 7360 7370
*7330        OS113   3   21  9   OS113                O   N           FD REF    140 CO
*7310        OS113   7   25  9   OS113                O   A           FD REF03  140 ZZ
*7340        OS113   4   22  9   OS113                O   D           FD DTM    150 196
*7350        OS113   9   27  9   OS113                O   D           FD DTM    150 197
*7300        OS113   1   19  9   OS113                O   A           FD N1     160 IR
*7320        OS113   2   20  9   OS113                O   A           FD N1     160 S2
*7321        OS113   8   26  9   OS113                O   A           FD N2     060
*7360        OS113   5   23  9   OS113                O   $           FD TIA    200
*7370        OS113   6   24  9   OS113                O   $           FD TIA    200
FGS          SUMM
 7380        OS113    32  Enter                       O   $           FD TIA    200
 7390        OS113    34  Indicate rate used          O   %           FD TIA06  200
SEND

Schedule 103  Summary of Graduate Transitions Tax Credit
TABLE        PARTII      8130 8110 8140 8150 8100 8120 8160 8170
*8130        OS115   7   25  9   OS115                O   N           FD REF    140 CO
*8110        OS115   11  29  9   OS115                O   D           FD DTM    150 198
*8140        OS115   8   26  9   OS115                O   D           FD DTM    150 196
*8150        OS115   13  31  9   OS115                O   D           FD DTM    150 197
*8100        OS115   5   23  9   OS115                O   A           FD N1     160 IR
*8120        OS115   6   24  9   OS115                O   A           FD N1     160 EY
*8160        OS115   9   27  9   OS115                O   $           FD TIA    200
*8170        OS115   10  28  9   OS115                O   $           FD TIA    200
FGS          SUMM
 8180        OS115    37                              O   $           FD TIA    200
 8210        OS115    39                              O   %           FD TIA06  200
 8260        OS115    40                              O   N           FD TIA03  200
SEND

Schedule 002  Charitable Donations
FGS          CDGD
 2000        OS2_1    2   Charitable                  O   $           FD TIA    200
 2010        OS2_1    3   Deduct: donations           O   $           FD TIA    200
 2020        OS2_1    4   Charitable                  O   $           FD TIA    200
 2030        OS2_1    5   Add: Donations              O   $           FD TIA    200
 2040        OS2_1    6   Total current year          O   $           FD TIA    200
 2045        OS2_1    31  Adjustm                     O   $           FD TIA    200
 2050        OS2_1    9   Total donations             O   $           FD TIA    200
 2060        OS2_1    10  Deduct: amount              O   $           FD TIA    200
 2070        OS2_1    11  Charitable                  O   $           FD TIA    200
 2080        OS2_1    12  Ontario net income          O   $           FD TIA    200
 2090        OS2_1    13  Ontario taxable             O   $           FD TIA    200
 2100        OS2_1    14  Ontario taxable             O   $           FD TIA    200 
 2110        OS2_1    15  1) the amount of            O   $           FD TIA    200 
 2120        OS2_1    16  2) the lesser of            O   $           FD TIA    200 
 2130        OS2_1    17  ii) the capital             O   $           FD TIA    200 
 2140        OS2_1    22  Subtotal: amount I          O   $           FD TIA    200 
 2150        OS2_1    29  Amount P                    O   $           FD TIA    200
 2160        OS2_1    23  Maximum deduction           O   $           FD TIA    200
 2170        OS2_1    24  Claim for                   O   $           FD TIA    200 
 2180        OS2_2    4   Gifts to Ontario            O   $           FD TIA    200 
 2190        OS2_2    5   Deduct: Gifts               O   $           FD TIA    200 
 2200        OS2_2    6   Gifts to Ontario            O   $           FD TIA    200 
 2210        OS2_2    7   Add: Gifts                  O   $           FD TIA    200
 2220        OS2_2    8   Total current year          O   $           FD TIA    200
 2230        OS2_2    44  Subtotal                    O   $           FD TIA    200
 2235        OS2_2    47  Adjustment                  O   $           FD TIA    200
 2236        OS2_2    48  Total gifts avlbl           O   $           FD TIA    200
 2240        OS2_2    9   Deduct: Amount              O   $           FD TIA    200
 2250        OS2_2    10  Gifts to Ontario            O   $           FD TIA    200
 2251        OS2_2    30  Ontario Net Income          O   $           FD TIA    200
 2252        OS2_2    31  Ontario Net Income          O   $           FD TIA    200 
 2253        OS2_2    32  Gifts made in the           O   $           FD TIA    200 
 2257        OS2_2    36  Gifts to Canada or          O   $           FD TIA    200 
 2258        OS2_2    37  Deduct: Gifts to            O   $           FD TIA    200 
 2259        OS2_2    38  Gifts to Canada or          O   $           FD TIA    200 
 2261        OS2_2    39  Add: Gifts to               O   $           FD TIA    200 
 2262        OS2_2    40  Total current year          O   $           FD TIA    200 
 2263        OS2_2    41  Subtotal                    O   $           FD TIA    200
 2266        OS2_2    50  Adjustm                     O   $           FD TIA    200
 2267        OS2_2    51  Tot gifts                   O   $           FD TIA    200
 2264        OS2_2    42  Deduct: Amount              O   $           FD TIA    200
 2265        OS2_2    43  Gifts to Canada or          O   $           FD TIA    200
 2260        OS2_3    9   Gifts of certified          O   $           FD TIA    200 
 2270        OS2_3    10  Deduct: Gifts of            O   $           FD TIA    200 
 2280        OS2_3    11  Gifts of certified          O   $           FD TIA    200 
 2290        OS2_3    12  Add: Gifts of               O   $           FD TIA    200 
 2300        OS2_3    13  Total current year          O   $           FD TIA    200
 2310        OS2_3    14  Subtotal                    O   $           FD TIA    200
 2315        OS2_3    62  adjustm                     O   $           FD TIA    200
 2316        OS2_3    63  tot gifts                   O   $           FD TIA    200
 2320        OS2_3    15  Deduct: Amount              O   $           FD TIA    200
 2330        OS2_3    16  Gifts of certified          O   $           FD TIA    200 
 2340        OS2_3    17  Gifts of certified          O   $           FD TIA    200 
 2350        OS2_3    18  Deduct: Gifts of            O   $           FD TIA    200 
 2360        OS2_3    19  Gifts of certified          O   $           FD TIA    200 
 2370        OS2_3    20  Add: Gifts of               O   $           FD TIA    200 
 2380        OS2_3    21  Total current year          O   $           FD TIA    200 
 2390        OS2_3    22  Subtotal                    O   $           FD TIA    200
 2395        OS2_3    65  Adjustm                     O   $           FD TIA    200
 2396        OS2_3    66  tot gifts                   O   $           FD TIA    200
 2400        OS2_3    23  Deduct: Amount              O   $           FD TIA    200
 2410        OS2_3    24  Gifts of certified          O   $           FD TIA    200 
TABLE        ANOFBAL     2420 2430 2435 2440 2450 2460
*2420        OS2_3   25  55  6  S2PART8               O   D           FD DTM    150 194
*2430        OS2_3   26  56  6  S2PART8               O   $           FD TIA    200
*2435        OS2_3   27  57  6  S2PART8               O   $           FD TIA    200
*2440        OS2_3   28  58  6  S2PART8               O   $           FD TIA    200
*2450        OS2_3   29  59  6  S2PART8               O   $           FD TIA    200
*2460        OS2_3   30  60  6  S2PART8               O   $           FD TIA    200
TABLE        GIFTS       2480 2470 2490
*2480        OS2_2   12  27  3   S2PART3              O   D           FD DTM    150 447
*2470        OS2_2   11  26  3   S2PART3              O   A           FD N1     160 GIR
*2490        OS2_2   13  28  3   S2PART3              O   $           FD TIA    200
SEND

Schedule 005  General Allocation
FGS          GENALL
 5000        OS5      4   Salaries & wages -          O   $           FD TIA    200
 5010        OS5      9   Salaries & wages -          O   $           FD TIA    200
 5020        OS5      14  Salaries & wages -          O   $           FD TIA    200
 5030        OS5      19  Salaries & wages -          O   $           FD TIA    200
 5040        OS5      24  Salaries & wages -          O   $           FD TIA    200
 5050        OS5      29  Salaries & wages -          O   $           FD TIA    200
 5060        OS5      34  Salaries & wages -          O   $           FD TIA    200
 5070        OS5      39  Salaries & wages            O   $           FD TIA    200
 5080        OS5      44  Salaries & wages -          O   $           FD TIA    200
 5090        OS5      49  Salaries & wages -          O   $           FD TIA    200
 5100        OS5      54  Salaries & wages -          O   $           FD TIA    200
 5110        OS5      59  Salaries & wages -          O   $           FD TIA    200
 5120        OS5      64 Salaries & wages -           O   $           FD TIA    200
 5130        OS5      69  Salaries & wages -          O   $           FD TIA    200
 5300        OS5      6   Gross Revenue -             O   $           FD TIA    200
 5310        OS5      11  Gross Revenue -             O   $           FD TIA    200
 5320        OS5      16  Gross Revenue -             O   $           FD TIA    200
 5330        OS5      21  Gross Revenue -             O   $           FD TIA    200
 5340        OS5      26  Gross Revenue -             O   $           FD TIA    200
 5350        OS5      31  Gross Revenue -             O   $           FD TIA    200
 5360        OS5      36  Gross Revenue -             O   $           FD TIA    200
 5370        OS5      41  Gross Revenue -             O   $           FD TIA    200
 5380        OS5      46  Gross Revenue -             O   $           FD TIA    200
 5390        OS5      51  Gross Revenue -             O   $           FD TIA    200
 5400        OS5      56  Gross Revenue -             O   $           FD TIA    200
 5410        OS5      61  Gross Revenue -             O   $           FD TIA    200
 5420        OS5      66  Gross Revenue -             O   $           FD TIA    200
 5430        OS5      71  Gross Revenue -             O   $           FD TIA    200
SEND

Schedule 005A Allocation Navigation Corporations
FGS          NAVALL
 6000        OS5A         Port-call-tonnage           O   N           FD TIA04  200
 6010                     Port-call-tonnage           O   N           FD TIA04  200
 6020                     Port-call-tonnage           O   N           FD TIA04  200
 6030                     Port-call-tonnage           O   N           FD TIA04  200
 6040                     Port-call-tonnage           O   N           FD TIA04  200
 6050                     Port-call-tonnage           O   N           FD TIA04  200
 6060                     Port-call-tonnage           O   N           FD TIA04  200
 6070                     Port-call-tonnage           O   N           FD TIA04  200
 6080                     Port-call-tonnage           O   N           FD TIA04  200
 6090                     Port-call-tonnage           O   N           FD TIA04  200
 6100                     Port-call-tonnage           O   N           FD TIA04  200
 6110                     Port-call-tonnage           O   N           FD TIA04  200
 6120                     Port-call-tonnage           O   N           FD TIA04  200
 6150                     Port-call tonnage           O   $           FD TIA    200
 6160                     Port-call tonnage           O   $           FD TIA    200
 6170                     Port-call tonnage           O   $           FD TIA    200
 6180                     Port-call tonnage           O   $           FD TIA    200
 6190                     Port-call tonnage           O   $           FD TIA    200
 6200                     Port-call tonnage           O   $           FD TIA    200
 6210                     Port-call tonnage           O   $           FD TIA    200
 6220                     Port-call tonnage           O   $           FD TIA    200
 6230                     Port-call tonnage           O   $           FD TIA    200
 6240                     Port-call tonnage           O   $           FD TIA    200
 6250                     Port-call tonnage           O   $           FD TIA    200
 6260                     Port-call tonnage           O   $           FD TIA    200
 6270                     Port-call tonnage           O   $           FD TIA    200
 6290                     Salaries & wages -          O   $           FD TIA    200
 6300                     Salaries & wages -          O   $           FD TIA    200
 6310                     Salaries & wages -          O   $           FD TIA    200
 6320                     Salaries & wages -          O   $           FD TIA    200
 6330                     Salaries & wages -          O   $           FD TIA    200
 6340                     Salaries & wages -          O   $           FD TIA    200
 6350                     Salaries & wages -          O   $           FD TIA    200
 6360                     Salaries & wages -          O   $           FD TIA    200
 6370                     Salaries & wages -          O   $           FD TIA    200
 6380                     Salaries & wages -          O   $           FD TIA    200
 6390                     Salaries & wages -          O   $           FD TIA    200
 6400                     Salaries & wages -          O   $           FD TIA    200
 6410                     Salaries & wages -          O   $           FD TIA    200
 6430                     Salaries & wages            O   $           FD TIA    200
 6440                     Salaries & wages            O   $           FD TIA    200
 6450                     Salaries & wages            O   $           FD TIA    200
 6460                     Salaries & wages            O   $           FD TIA    200
 6470                     Salaries & wages            O   $           FD TIA    200
 6480                     Salaries & wages            O   $           FD TIA    200
 6490                     Salaries & wages            O   $           FD TIA    200
 6500                     Salaries & wages            O   $           FD TIA    200
 6510                     Salaries & wages            O   $           FD TIA    200
 6520                     Salaries & wages            O   $           FD TIA    200
 6530                     Salaries & wages            O   $           FD TIA    200
 6540                     Salaries & wages            O   $           FD TIA    200
 6550                     Salaries & wages            O   $           FD TIA    200
SEND

Schedule 005B Allocation Chartered Banks
FGS          CHBANKALL
 7000        OS5B         Salaries & wages -          O   $           FD TIA    200
 7010                     Salaries & wages -          O   $           FD TIA    200
 7020                     Salaries & wages -          O   $           FD TIA    200
 7030                     Salaries & wages -          O   $           FD TIA    200
 7040                     Salaries & wages -          O   $           FD TIA    200
 7050                     Salaries & wages -          O   $           FD TIA    200
 7060                     Salaries & wages -          O   $           FD TIA    200
 7070                     Salaries & wages -          O   $           FD TIA    200
 7080                     Salaries & wages -          O   $           FD TIA    200
 7090                     Salaries & wages -          O   $           FD TIA    200
 7100                     Salaries & wages -          O   $           FD TIA    200
 7110                     Salaries & wages -          O   $           FD TIA    200
 7120                     Salaries & wages -          O   $           FD TIA    200
 7130                     Salaries & wages -          O   $           FD TIA    200
 7300                     Loans and Deposits          O   $           FD TIA    200
 7310                     Loans and Deposits          O   $           FD TIA    200
 7320                     Loans and Deposits          O   $           FD TIA    200
 7330                     Loans and Deposits          O   $           FD TIA    200
 7340                     Loans and Deposits          O   $           FD TIA    200
 7350                     Loans and Deposits          O   $           FD TIA    200
 7360                     Loans and Deposits          O   $           FD TIA    200
 7370                     Loans and Deposits          O   $           FD TIA    200
 7380                     Loans and Deposits          O   $           FD TIA    200
 7390                     Loans and Deposits          O   $           FD TIA    200
 7400                     Loans and Deposits          O   $           FD TIA    200
 7410                     Loans and Deposits          O   $           FD TIA    200
 7420                     Loans and Deposits          O   $           FD TIA    200
 7430                     Loans and Deposits          O   $           FD TIA    200
SEND

Schedule 005C Allocation Loan and Trust Corporations
FGS          LNTRALL
 8000        OS5C         Gross Revenue -             O   $           FD TIA    200
 8010                     Gross Revenue -             O   $           FD TIA    200
 8020                     Gross Revenue -             O   $           FD TIA    200
 8030                     Gross Revenue -             O   $           FD TIA    200
 8040                     Gross Revenue -             O   $           FD TIA    200
 8050                     Gross Revenue -             O   $           FD TIA    200
 8060                     Gross Revenue -             O   $           FD TIA    200
 8070                     Gross Revenue -             O   $           FD TIA    200
 8080                     Gross Revenue -             O   $           FD TIA    200
 8090                     Gross Revenue -             O   $           FD TIA    200
 8100                     Gross Revenue - N.          O   $           FD TIA    200
 8110                     Gross Revenue -             O   $           FD TIA    200
 8120                     Gross Revenue -             O   $           FD TIA    200
 8130                     Gross Revenue -             O   $           FD TIA    200
 8300                     Salaries & wages -          O   $           FD TIA    200
 8310                     Salaries & wages -          O   $           FD TIA    200
 8320                     Salaries & wages -          O   $           FD TIA    200
 8330                     Salaries & wages -          O   $           FD TIA    200
 8340                     Salaries & wages -          O   $           FD TIA    200
 8350                     Salaries & wages -          O   $           FD TIA    200
 8360                     Salaries & wages -          O   $           FD TIA    200
 8370                     Salaries & wages -          O   $           FD TIA    200
 8380                     Salaries & wages -          O   $           FD TIA    200
 8390                     Salaries & wages -          O   $           FD TIA    200
 8400                     Salaries & wages -          O   $           FD TIA    200
 8410                     Salaries & wages -          O   $           FD TIA    200
 8420                     Salaries & wages -          O   $           FD TIA    200
 8430                     Salaries & wages -          O   $           FD TIA    200
SEND


Schedule 005D Allocation Railway Corporations
FGS          RAILALL
 9000        OS5D         Track Length -              O   N           FD TIA04  200
 9010                     Track Length -              O   N           FD TIA04  200
 9020                     Track Length -              O   N           FD TIA04  200
 9030                     Track Length -              O   N           FD TIA04  200
 9040                     Track Length -              O   N           FD TIA04  200
 9050                     Track Length -              O   N           FD TIA04  200
 9060                     Track Length - New          O   N           FD TIA04  200
 9070                     Track Length -              O   N           FD TIA04  200
 9080                     Track Length -              O   N           FD TIA04  200
 9090                     Track Length -              O   N           FD TIA04  200
 9100                     Track Length - N.           O   N           FD TIA04  200
 9110                     Track Length -              O   N           FD TIA04  200
 9120                     Track Length -              O   N           FD TIA04  200
 9280                     Gross Freight               O   N           FD TIA04  200
 9290                     Gross Freight               O   N           FD TIA04  200
 9300                     Gross Freight               O   N           FD TIA04  200
 9310                     Gross Freight               O   N           FD TIA04  200
 9320                     Gross Freight               O   N           FD TIA04  200
 9330                     Gross Freight               O   N           FD TIA04  200
 9340                     Gross Freight               O   N           FD TIA04  200
 9350                     Gross Freight               O   N           FD TIA04  200
 9360                     Gross Freight               O   N           FD TIA04  200
 9370                     Gross Freight               O   N           FD TIA04  200
 9380                     Gross Freight               O   N           FD TIA04  200
 9390                     Gross Freight               O   N           FD TIA04  200
 9400                     Gross Freight               O   N           FD TIA04  200
SEND


Schedule 005E Allocation Airline Corporations
FGS          AIRALL
 1000        OS5E         Capital Cost of             O   $           FD TIA    200
 1010                     Capital Cost of             O   $           FD TIA    200
 1020                     Capital Cost of             O   $           FD TIA    200
 1030                     Capital Cost of             O   $           FD TIA    200
 1040                     Capital Cost of             O   $           FD TIA    200
 1050                     Capital Cost of             O   $           FD TIA    200
 1060                     Capital Cost of             O   $           FD TIA    200
 1070                     Capital Cost of             O   $           FD TIA    200
 1080                     Capital Cost of             O   $           FD TIA    200
 1090                     Capital Cost of             O   $           FD TIA    200
 1100                     Capital Cost of             O   $           FD TIA    200
 1110                     Capital Cost of             O   $           FD TIA    200
 1120                     Capital Cost of             O   $           FD TIA    200
 1280                     Revenue Plane               O   N           FD TIA04  200
 1290                     Revenue Plane               O   N           FD TIA04  200
 1300                     Revenue Plane               O   N           FD TIA04  200
 1310                     Revenue Plane               O   N           FD TIA04  200
 1320                     Revenue Plane               O   N           FD TIA04  200
 1330                     Revenue Plane               O   N           FD TIA04  200
 1340                     Revenue Plane               O   N           FD TIA04  200
 1350                     Revenue Plane               O   N           FD TIA04  200
 1360                     Revenue Plane               O   N           FD TIA04  200
 1370                     Revenue Plane               O   N           FD TIA04  200
 1380                     Revenue Plane               O   N           FD TIA04  200
 1390                     Revenue Plane               O   N           FD TIA04  200
 1400                     Revenue Plane               O   N           FD TIA04  200
SEND


Schedule 005F Allocation Grain Elevator Corporations
FGS          GRAINALL
 2000        OS5F         Quantity of Grain           O   N           FD TIA04  200
 2010                     Quantity of Grain           O   N           FD TIA04  200
 2020                     Quantity of Grain           O   N           FD TIA04  200
 2030                     Quantity of Grain           O   N           FD TIA04  200
 2040                     Quantity of Grain           O   N           FD TIA04  200
 2050                     Quantity of Grain           O   N           FD TIA04  200
 2060                     Quantity of Grain           O   N           FD TIA04  200
 2070                     Quantity of Grain           O   N           FD TIA04  200
 2080                     Quantity of Grain           O   N           FD TIA04  200
 2090                     Quantity of Grain           O   N           FD TIA04  200
 2100                     Quantity of Grain           O   N           FD TIA04  200
 2110                     Quantity of Grain           O   N           FD TIA04  200
 2120                     Quantity of Grain           O   N           FD TIA04  200
 2130                     Quantity of Grain           O   N           FD TIA04  200
 3000                     Salaries & wages -          O   $           FD TIA    200
 3010                     Salaries & wages -          O   $           FD TIA    200
 3020                     Salaries & wages -          O   $           FD TIA    200
 3030                     Salaries & wages -          O   $           FD TIA    200
 3040                     Salaries & wages -          O   $           FD TIA    200
 3050                     Salaries & wages -          O   $           FD TIA    200
 3060                     Salaries & wages -          O   $           FD TIA    200
 3070                     Salaries & wages -          O   $           FD TIA    200
 3080                     Salaries & wages -          O   $           FD TIA    200
 3090                     Salaries & wages -          O   $           FD TIA    200
 3100                     Salaries & wages -          O   $           FD TIA    200
 3110                     Salaries & wages -          O   $           FD TIA    200
 3120                     Salaries & wages -          O   $           FD TIA    200
 3130                     Salaries & wages -          O   $           FD TIA    200
SEND


Schedule 005G Allocation Bus and Truck Operators
FGS          BUSALL
 3000        OS5G         Salaries & wages -          O   $           FD TIA    200
 3010                     Salaries & wages -          O   $           FD TIA    200
 3020                     Salaries & wages -          O   $           FD TIA    200
 3030                     Salaries & wages -          O   $           FD TIA    200
 3040                     Salaries & wages -          O   $           FD TIA    200
 3050                     Salaries & wages -          O   $           FD TIA    200
 3060                     Salaries & wages -          O   $           FD TIA    200
 3070                     Salaries & wages -          O   $           FD TIA    200
 3080                     Salaries & wages -          O   $           FD TIA    200
 3090                     Salaries & wages -          O   $           FD TIA    200
 3100                     Salaries & wages -          O   $           FD TIA    200
 3110                     Salaries & wages -          O   $           FD TIA    200
 3120                     Salaries & wages -          O   $           FD TIA    200
 3130                     Salaries & wages -          O   $           FD TIA    200
 3300                     Distance driven by          O   N           FD TIA04  200
 3310                     Distance driven by          O   N           FD TIA04  200
 3320                     Distance driven by          O   N           FD TIA04  200
 3330                     Distance driven by          O   N           FD TIA04  200
 3340                     Distance driven by          O   N           FD TIA04  200
 3350                     Distance driven by          O   N           FD TIA04  200
 3360                     Distance driven by          O   N           FD TIA04  200
 3370                     Distance driven by          O   N           FD TIA04  200
 3380                     Distance driven by          O   N           FD TIA04  200
 3390                     Distance driven by          O   N           FD TIA04  200
 3400                     Distance driven by          O   N           FD TIA04  200
 3410                     Distance driven by          O   N           FD TIA04  200
 3420                     Distance driven by          O   N           FD TIA04  200
 3430                     Distance driven by          O   N           FD TIA04  200
SEND


Schedule 005H Allocation Pipeline
FGS          PIPEALL
 4000        OS5H         Length of pipe -            O   N           FD TIA04  200
 4010                     Length of pipe -            O   N           FD TIA04  200
 4020                     Length of pipe -            O   N           FD TIA04  200
 4030                     Length of pipe -            O   N           FD TIA04  200
 4040                     Length of pipe -            O   N           FD TIA04  200
 4050                     Length of pipe -            O   N           FD TIA04  200
 4060                     Length of pipe -            O   N           FD TIA04  200
 4070                     Length of pipe -            O   N           FD TIA04  200
 4080                     Length of pipe -            O   N           FD TIA04  200
 4090                     Length of pipe -            O   N           FD TIA04  200
 4100                     Length of pipe -            O   N           FD TIA04  200
 4110                     Length of pipe -            O   N           FD TIA04  200
 4120                     Length of pipe -            O   N           FD TIA04  200
 4280                     Salaries & wages -          O   $           FD TIA    200
 4290                     Salaries & wages -          O   $           FD TIA    200
 4300                     Salaries & wages -          O   $           FD TIA    200
 4310                     Salaries & wages -          O   $           FD TIA    200
 4320                     Salaries & wages -          O   $           FD TIA    200
 4330                     Salaries & wages -          O   $           FD TIA    200
 4340                     Salaries & wages -          O   $           FD TIA    200
 4350                     Salaries & wages -          O   $           FD TIA    200
 4360                     Salaries & wages -          O   $           FD TIA    200
 4370                     Salaries & wages -          O   $           FD TIA    200
 4380                     Salaries & wages -          O   $           FD TIA    200
 4390                     Salaries & wages -          O   $           FD TIA    200
 4400                     Salaries & wages -          O   $           FD TIA    200
SEND


Schedule 006  Summary of Dispositions of Capital Property
TABLE        DESIG       6003 6001 6002 6004 6005 6006 6007 6008
*6003        OS6_1   8   88  8   S6PARTA              O   D           FD DTM    150 621
*6001        OS6_1   6   86  8   S6PARTA              O   A           FD TIA03  200
*6002        OS6_1   7   87  8   S6PARTA              O   A           FD TIA03  200
*6004        OS6_1   9   89  8   S6PARTA              O   $           FD TIA    200
*6005        OS6_1   10  90  8   S6PARTA              O   $           FD TIA    200
*6006        OS6_1   11  91  8   S6PARTA              O   $           FD TIA    200
*6007        OS6_1   12  92  8   S6PARTA              O   $           FD TIA    200
*6008        OS6_1   13  93  8   S6PARTA              O   $           FD TIA    200
TABLE        ASSET       6014 6013 6011 6012 6015 6016 6017 6018 6019
*6014        OS6_1   99  180 9   S6PARTB              O   D           FD DTM    150 621
*6013        OS6_1   98  179 9   S6PARTB              O   A           FD N1     160 2L
*6011        OS6_1   96  177 9   S6PARTB              O   A           FD TIA03  200
*6012        OS6_1   97  178 9   S6PARTB              O   A           FD TIA03  200
*6015        OS6_1   100 181 9   S6PARTB              O   $           FD TIA    200
*6016        OS6_1   101 182 9   S6PARTB              O   A           FD TIA03  200
*6017        OS6_1   102 183 9   S6PARTB              O   %           FD TIA06  200
*6018        OS6_1   103 184 9   S6PARTB              O   $           FD TIA    200
*6019        OS6_1   104 185 9   S6PARTB              O   $           FD TIA    200
TABLE        SHARE       6040 6045 6020 6010 6030 6050 6060 6070 6080
*6040        OS6_2   9   209 8   SHARES               O   D           FD DTM    150 801
*6045        OS6_2   220 245 1   SHARES               O   D           FD DTM    150 621
*6020        OS6_2   7   207 8   SHARES               O   A           FD N1     160 2L
*6010        OS6_2   6   206 8   SHARES               O   N           FD TIA04  200
*6030        OS6_2   8   208 8   SHARES               O   A           FD TIA03  200
*6050        OS6_2   10  210 8   SHARES               O   $           FD TIA    200
*6060        OS6_2   11  211 8   SHARES               O   $           FD TIA    200
*6070        OS6_2   12  212 8   SHARES               O   $           FD TIA    200
*6080        OS6_2   13  213 8   SHARES               O   $           FD TIA    200
TABLE        REAL-EST    6100 6105 6090 6091 6110 6120 6130 6140
*6100        OS6RE   6   303 11  REALEST              O   D           FD DTM    150 801
*6105        OS6RE   7   304 11  REALEST              O   D           FD DTM    150 621
*6090        OS6RE   1   298 11  REALEST              O   A           FD N1     160 PP
*6091        OS6RE   2   299 11  REALEST   city       O   A           FD N4     190
*6110        OS6RE   8   305 11  REALEST              O   $           FD TIA    200
*6120        OS6RE   9   306 11  REALEST              O   $           FD TIA    200
*6130        OS6RE   10  307 11  REALEST              O   $           FD TIA    200
*6140        OS6RE   11  308 11  REALEST              O   $           FD TIA    200
TABLE        BOND        6160 6180 6185 6170 6150 6190 6200 6210 6220
*6160        OS6_3   2   65  9   BONDS                O   D           FD DTM    150 815
*6180        OS6_3   5   68  9   BONDS                O   D           FD DTM    150 801
*6185        OS6_3   146 153 1   BONDS                O   D           FD DTM    150 621
*6170        OS6_3   3   66  9   BONDS                O   A           FD N1     160 IU
*6150        OS6_3   1   64  9   BONDS                O   $           FD TIA    200
*6190        OS6_3   6   69  9   BONDS                O   $           FD TIA    200
*6200        OS6_3   7   70  9   BONDS                O   $           FD TIA    200
*6210        OS6_3   8   71  9   BONDS                O   $           FD TIA    200
*6220        OS6_3   9   72  9   BONDS                O   $           FD TIA    200
TABLE        OTH-PRO     6240 6245 6230 6250 6260 6270 6280
*6240        OS6_3   79  114 7   OTHPROP              O   D           FD DTM    150 801
*6245        OS6_3   155 160 1   OTHPROP              O   D           FD DTM    150 621
*6230        OS6_3   77  84  7   OTHPROP              O   A           FD N1     160 PP
*6250        OS6_3   80  115 7   OTHPROP              O   $           FD TIA    200
*6260        OS6_3   81  116 7   OTHPROP              O   $           FD TIA    200
*6270        OS6_3   82  117 7   OTHPROP              O   $           FD TIA    200
*6280        OS6_3   83  118 7   OTHPROP              O   $           FD TIA    200
TABLE        PUP         6300 6305 6290 6310 6320 6330 6340
*6300        OS6_3   124 136 6   PUP                  O   D           FD DTM    150 801
*6305        OS6_3   162 164 1   PUP                  O   D           FD DTM    150 621
*6290        OS6_3   123 135 6   PUP                  O   A           FD N1     160 PP
*6310        OS6_3   125 137 6   PUP                  O   $           FD TIA    200
*6320        OS6_3   126 138 6   PUP                  O   $           FD TIA    200
*6330        OS6_3   127 139 6   PUP                  O   $           FD TIA    200
*6340        OS6_3   128 140 6   PUP                  O   $           FD TIA    200
TABLE        LPP         6360 6365 6350 6370 6380 6390 6400
*6360        OS6_3   194 208 7   LPP                  O   D           FD DTM    150 801
*6365        OS6_3   195 209 7   LPP                  O   D           FD DTM    150 621
*6350        OS6_3   193 207 7   LPP                  O   A           FD N1     160 PP
*6370        OS6_3   196 210 7   LPP                  O   $           FD TIA    200
*6380        OS6_3   197 211 7   LPP                  O   $           FD TIA    200
*6390        OS6_3   198 212 7   LPP                  O   $           FD TIA    200
*6400        OS6_3   199 213 7   LPP                  O   $           FD TIA    200
FGS          DTCGL
 6780        OS6_4    81  Add: Amount of              O   $           FD TIA    200
 6785        OS6_4    79  Capital gain                O   $           FD TIA    200
 6790        OS6_4    83  Deduct: Amount of           O   $           FD TIA    200
 6920        OS6_4    74  Gain or loss (z)            O   $           FD TIA    200
 6925        OS6_4    75  Gain on donations           O   $           FD TIA    200
 6930        OS6_4    77  Gain on donation            O   $           FD TIA    200
 6950        OS6_4    78  Gain on donation            O   $           FD TIA    200
 6960        OS6_4    86  Gain on donation            O   $           FD TIA    200
TABLE        ABIL        6490 6495 6470 6480 6500 6510 6520 6530
*6490        OS6_4   6   62  7   ABIL                 O   D           FD DTM    150 801
*6495        OS6_4   87  95  1   ABIL                 O   D           FD DTM    150 621
*6470        OS6_4   4   60  7   ABIL                 O   A           FD N1     160 21
*6480        OS6_4   5   61  7   ABIL                 O   N           FD TIA03  200
*6500        OS6_4   7   63  7   ABIL                 O   $           FD TIA    200
*6510        OS6_4   8   64  7   ABIL                 O   $           FD TIA    200
*6520        OS6_4   9   65  7   ABIL                 O   $           FD TIA    200
*6530        OS6_4   10  66  7   ABIL                 O   $           FD TIA    200
SEND


Schedule 008  Capital Cost Allowance
FGS          IDENT
 8000        OS8ALL   4   Subsection 1101             O   1/2         FD TIA03  200
TABLE        CCAD        8010 8020 8030 8040 8050 8060 8061 8070 8080 8090
*8010        OS8ALL  6   281 11  S8                   O   N           FD REF    140 X2
*8020        OS8ALL  7   282 11  S8                   O   $           FD TIA    200
*8030        OS8ALL  8   283 11  S8                   O   $           FD TIA    200
*8040        OS8ALL  9   284 11  S8                   O   $           FD TIA    200
*8050        OS8ALL  10  285 11  S8                   O   $           FD TIA    200
*8060        OS8ALL  11  286 11  S8                   O   $           FD TIA    200
*8061        OS8ALL  12  287 11  S8                   O   %           FD TIA06  200
*8070        OS8ALL  13  288 11  S8                   O   $           FD TIA    200
*8080        OS8ALL  14  289 11  S8                   O   $           FD TIA    200
*8090        OS8ALL  15  290 11  S8                   O   $           FD TIA    200
SEND


Schedule 010  Cumulative Eligible Capital Deduction
FGS          CECDD
 8500        OS10     4   Ontario cumulative          O   $           FD TIA    200
 8510        OS10     5   Cost of eligible            O   $           FD TIA    200
 8520        OS10     24  Amount transferred          O   $           FD TIA    200
 8530        OS10     25  Other adjustments           O   $           FD TIA    200
 8540        OS10     7   Ontario proceeds            O   $           FD TIA    200
 8550        OS10     8   Gross amount of a           O   $           FD TIA    200
 8560        OS10     9   Other adjustments           O   $           FD TIA    200
 8570        OS10     12  Current year                O   $           FD TIA    200
 8571        OS10     28  Current year                O   $           FD TIA    200
 8573        OS10     29  Current year                O   $           FD TIA    200
 8590        OS10     20  Total cumulative            O   $           FD TIA    200
 8600        OS10     15  Negative balances           O   $           FD TIA    200
 8610        OS10     16  Current year                O   $           FD TIA    200

 8690        OS10     26  Cost of eligible            O   $           FD TIA    200
 8700        OS10     41  Amount transferred          O   $           FD TIA    200
 8710        OS10     18  Other adjustments           O   $           FD TIA    200
 8720        OS10     42  Ontario proceeds            O   $           FD TIA    200
 8730        OS10     43  Gross amount of a           O   $           FD TIA    200
 8740        OS10     06  Other adjustments           O   $           FD TIA    200
 8750        OS10     27  Current year                O   $           FD TIA    200
 8760        OS10     19  Current year                O   $           FD TIA    200
 8770        OS10     10  Current year                O   $           FD TIA    200
 8775        OS10     14  Total cumulative            O   $           FD TIA    200
 8780        OS10     13  Negative balances           O   $           FD TIA    200
 8790        OS10     30  Current year                O   $           FD TIA    200
 8800        OS10     31  Current year                O   $           FD TIA    200
 8810        OS10     33  Current year                O   $           FD TIA    200
 8820        OS10     17  Current year                O   $           FD TIA    200
 8830        OS10     35  Current year                O   $           FD TIA    200
 8840        OS10     36  Current year                O   $           FD TIA    200
 8850        OS10     38  Current year                O   $           FD TIA    200
 8860        OS10     39  Current year                O   $           FD TIA    200
 8870        OS10     21  Current year                O   $           FD TIA    200
 8880        OS10     46  Current year                O   $           FD TIA    200
 8890        OS10     11  Current year                O   $           FD TIA    200
 8900        OS10     47  Current year                O   $           FD TIA    200
 8910        OS10     48  Current year                O   $           FD TIA    200
 8920        OS10     49  Current year                O   $           FD TIA    200
SEND

Schedule 012  Ontario Exploration Expenses
FGS          EDAD
 1200        OS12_1   4   CEDB Regular                O   $           FD TIA    200
 1210        OS12_1   6   CEDB Regular                O   $           FD TIA    200
 1220        OS12_1   9   CEDB Regular                O   $           FD TIA    200
 1240        OS12_1   13  CEDB Regular                O   $           FD TIA    200
 1250        OS12_1   15  CEDB Regular                O   $           FD TIA    200
 1260        OS12_1   5   CEDB Successor              O   $           FD TIA    200
 1270        OS12_1   7   CEDB Successor              O   $           FD TIA    200
 1280        OS12_1   8   CEDB Successor              O   $           FD TIA    200
 1290        OS12_1   10  CEDB Successor              O   $           FD TIA    200
 1310        OS12_1   14  CEDB Successor              O   $           FD TIA    200
 1320        OS12_1   16  CEDB Successor              O   $           FD TIA    200
 1400        OS12_1   17  CCEE Regular                O   $           FD TIA    200
 1410        OS12_1   19  CCEE  Regular               O   $           FD TIA    200
 1420        OS12_1   20  CCEE  Regular               O   $           FD TIA    200
 1430        OS12_1   22  CCEE Regular                O   $           FD TIA    200
 1431        OS12_1   26  CCEE Regular                O   $           FD TIA    200
 1440        OS12_1   27  CCEE Regular                O   $           FD TIA    200
 1450        OS12_1   28  CCEE Regular                O   $           FD TIA    200
 1460        OS12_1   29  CCEE Regular                O   $           FD TIA    200
 1480        OS12_1   31  CCEE Regular                O   $           FD TIA    200
 1500        OS12_1   35  CCEE Regular                O   $           FD TIA    200
 1510        OS12_1   37  CCEE Regular                O   $           FD TIA    200
 1520        OS12_1   18  CCEE Successor              O   $           FD TIA    200
 1530        OS12_1   21  CCEE Successor              O   $           FD TIA    200
 1540        OS12_1   23  CCEE Successor              O   $           FD TIA    200
 1550        OS12_1   25  CCEE Successor              O   $           FD TIA    200
 1580        OS12_1   30  CCEE Successor              O   $           FD TIA    200
 1590        OS12_1   32  CCEE Successor              O   $           FD TIA    200
 1610        OS12_1   36  CCEE Successor              O   $           FD TIA    200
 1620        OS12_1   38  CCEE Successor              O   $           FD TIA    200
 1630        OS12_2   4   CCDE Regular                O   $           FD TIA    200
 1640        OS12_2   6   CCDE Regular                O   $           FD TIA    200
 1650        OS12_2   7   CCDE Regular                O   $           FD TIA    200
 1660        OS12_2   10  CCDE Regular                O   $           FD TIA    200
 1670        OS12_2   11  CCDE Regular                O   $           FD TIA    200
 1680        OS12_2   13  CCDE Regular                O   $           FD TIA    200
 1690        OS12_2   14  CCDE Regular                O   $           FD TIA    200
 1700        OS12_2   15  CCDE Regular                O   $           FD TIA    200
 1710        OS12_2   16  CCDE Regular                O   $           FD TIA    200
 1730        OS12_2   18  CCDE Regular                O   $           FD TIA    200
 1750        OS12_2   22  CCDE Regular                O   $           FD TIA    200
 1760        OS12_2   24  CCDE Regular                O   $           FD TIA    200
 1770        OS12_2   5   CCDE Successor              O   $           FD TIA    200
 1780        OS12_2   8   CCDE Successor              O   $           FD TIA    200
 1790        OS12_2   9   CCDE Successor              O   $           FD TIA    200
 1810        OS12_2   12  CCDE Successor              O   $           FD TIA    200
 1840        OS12_2   17  CCDE Successor              O   $           FD TIA    200
 1850        OS12_2   49  CCDE Successor              O   $           FD TIA    200
 1860        OS12_2   19  CCDE Successor              O   $           FD TIA    200
 1880        OS12_2   23  CCDE Successor              O   $           FD TIA    200
 1890        OS12_2   25  CCDE Successor              O   $           FD TIA    200
 1891        OS12_2   26  CDE Regular                 O   $           FD TIA    200
 1892        OS12_2   28  CDE Regular                 O   $           FD TIA    200
 1893        OS12_2   29  CDE Regular                 O   $           FD TIA    200
 1895        OS12_2   32  CDE Regular                 O   $           FD TIA    200
 1896        OS12_2   33  CDE Regular                 O   $           FD TIA    200
 1897        OS12_2   34  CDE Regular                 O   $           FD TIA    200
 1898        OS12_2   43  CDE Regular                 O   $           FD TIA    200
 1899        OS12_2   37  CDE Regular                 O   $           FD TIA    200
 1901        OS12_2   39  CDE Regular                 O   $           FD TIA    200
 1902        OS12_2   41  CDE Regular                 O   $           FD TIA    200
 1904        OS12_2   45  CDE Regular                 O   $           FD TIA    200
 1905        OS12_2   47  CDE Regular                 O   $           FD TIA    200
 1906        OS12_2   27  CDE Successor               O   $           FD TIA    200
 1908        OS12_2   30  CDE Successor               O   $           FD TIA    200
 1909        OS12_2   31  CDE Successor               O   $           FD TIA    200
 1912        OS12_2   35  CDE Successor               O   $           FD TIA    200
 1915        OS12_2   38  CDE Successor               O   $           FD TIA    200
 1916        OS12_2   40  CDE Successor               O   $           FD TIA    200
 1917        OS12_2   42  CDE Successor               O   $           FD TIA    200
 1919        OS12_2   46  CDE Successor               O   $           FD TIA    200
 1921        OS12_2   48  CDE Successor               O   $           FD TIA    200
 1900        OS12_3   4   CCOG Regular                O   $           FD TIA    200
 1910        OS12_3   6   CCOG Regular                O   $           FD TIA    200
 1920        OS12_3   7   CCOG Regular                O   $           FD TIA    200
 1930        OS12_3   10  CCOG Regular                O   $           FD TIA    200
 1940        OS12_3   12  Regular expenses            O   $           FD TIA    200
 1950        OS12_3   14  CCOG Regular                O   $           FD TIA    200
 1970        OS12_3   15  CCOG Regular                O   $           FD TIA    200
 1980        OS12_3   17  CCOG Regular                O   $           FD TIA    200
 2000        OS12_3   21  CCOG Regular                O   $           FD TIA    200
 2010        OS12_3   23  CCOG Regular                O   $           FD TIA    200
 2020        OS12_3   5   CCOG Successor              O   $           FD TIA    200
 2030        OS12_3   8   CCOG Successor              O   $           FD TIA    200
 2040        OS12_3   9   CCOG Successor              O   $           FD TIA    200
 2060        OS12_3   13  CCOG Successor              O   $           FD TIA    200
 2080        OS12_3   16  CCOG Successor              O   $           FD TIA    200
 2090        OS12_3   18  CCOG Successor              O   $           FD TIA    200
 2110        OS12_3   22  CCOG Successor              O   $           FD TIA    200
 2120        OS12_3   24  CCOG Successor              O   $           FD TIA    200
SEND

Schedule 013  Continuity of Reserves
TABLE        CGR         1300 1310 1315 1320
*1300        OS13    4   24  4   OS13PART1            O   A           FD N1     160 PP
*1310        OS13    5   25  4   OS13PART1            O   $           FD TIA    200
*1315        OS13    6   26  4   OS13PART1            O   $           FD TIA    200
*1320        OS13    7   27  4   OS13PART1            O   $           FD TIA    200
FGS          OR
 1330        OS13     31  Reserve for                 O   $           FD TIA    200
 1331        OS13     32  Reserve for                     $           FD TIA    200
 1340        OS13     33  Reserve for                 O   $           FD TIA    200
 1350        OS13     34  Reserve for                 O   $           FD TIA    200
 1351        OS13     35  Reserve for                 O   $           FD TIA    200
 1360        OS13     36  Reserve for                 O   $           FD TIA    200
 1370        OS13     37  Reserve for                 O   $           FD TIA    200
 1371        OS13     38  Reserve for                 O   $           FD TIA    200
 1380        OS13     39  Reserve for                 O   $           FD TIA    200
 1390        OS13     40  December 31, 1995           O   $           FD TIA    200
 1391        OS13     41  December 31, 1995           O   $           FD TIA    200
 1400        OS13     42  December 31, 1995           O   $           FD TIA    200
 1410        OS13     43  Reserve for                 O   $           FD TIA    200
 1411        OS13     44  Reserve for                 O   $           FD TIA    200
 1420        OS13     45  Reserve for                 O   $           FD TIA    200
 1430        OS13     46  Reserve for unpaid          O   $           FD TIA    200
 1431        OS13     47  Reserve for unpaid          O   $           FD TIA    200
 1440        OS13     48  Reserve for unpaid          O   $           FD TIA    200
 1450        OS13     49  Other Tax Reserves          O   $           FD TIA    200
 1451        OS13     50  Other Tax Reserves          O   $           FD TIA    200
 1460        OS13     51  Other Tax Reserves          O   $           FD TIA    200
TABLE        CNR         1500 1510 1520 1530 1540 1550
*1500        OS13    56  86  6   OS13PART3            O   A           FD TIA03  200
*1510        OS13    57  87  6   OS13PART3            O   $           FD TIA    200
*1520        OS13    58  88  6   OS13PART3            O   $           FD TIA    200
*1530        OS13    59  89  6   OS13PART3            O   $           FD TIA    200
*1540        OS13    60  90  6   OS13PART3            O   $           FD TIA    200
*1550        OS13    61  91  6   OS13PART3            O   $           FD TIA    200
SEND


Schedule 017  Additional Deduction for Credit Unions
FGS          CREDIT
 1000        OS17     5  Taxable Income for           O   $           FD TIA    200
 1010        OS17     6  4/3 x maximum                O   $           FD TIA    200
 1030        OS17     9  Preferred amount             O   $           FD TIA    200
 1060        OS17     13 Adjusted Ontario             O   $           FD TIA    200
 1072        OS17     40 Adjusted Ontario             O   $           FD TIA    200
 1074        OS17     41 Adjusted Ontario             O   $           FD TIA    200
 1080        OS17     16 Days before May 2,           O   N           FD TIA04  200
 1090        OS17     29 Total Days                   O   N           FD TIA04  200
 1101        OS17     20 Days after May 1,            O   N           FD TIA04  200
 1111        OS17     24 Days after Dec 31,           O   N           FD TIA04  200
 1121        OS17     28 Days after Dec 31,           O   N           FD TIA04  200
 1131        OS17     32 Days after Dec 31,           O   N           FD TIA04  200
SEND


Schedule 018  Ontario Capital Gains Refund
FGS          FPTCGRD
 1800        OS18_1   4   RCGTOH at end of            O   $           FD TIA    200
 1802        OS18_1   11  Taxable Income for          O   $           FD TIA    200
 1803        OS18_1   12  Ontario Allocation          O   %           FD TIA06  200
 1806        OS18_1   14  Days after May 1,           O   N           FD TIA04  200
 1805        OS18_1   15  Total Days                  O   N           FD TIA04  200
 1825        OS18_1   46  Days after May 1,           O   N           FD TIA04  200
 1855        OS18_1   52  Days after                  O   N           FD TIA04  200
 1857        OS18_1   58  Days after                  O   N           FD TIA04  200

 1810        OS18_1   24  RCGTOH amount               O   $           FD TIA    200
 1836        OS18_1   40  Days after May 1,           O   N           FD TIA04  200
 1814        OS18_1   31  RCGTOH amount               O   $           FD TIA    200
 1820        OS18_1   33  RCGTOH amount               O   $           FD TIA    200
 1830        OS18_1   35  Ontario capital             O   $           FD TIA    200
 1840        OS18_1   36  RCGTOH at end of            O   $           FD TIA    200

 1845        OS18_2   5   Inclusion Rate              O   %           FD TIA06  200
 1850        OS18_2   9   Fair Market Value           O   $           FD TIA    200
 1860        OS18_2   10  All debts or other          O   $           FD TIA    200
 1870        OS18_2   13  Cost amount of all          O   $           FD TIA    200
 1880        OS18_2   14  Cash on hand                O   $           FD TIA    200
 1890        OS18_2   20  Amount paid in the          O   $           FD TIA    200
 1990        OS18_2   26  Capital Gains               O   $           FD TIA    200
 1910        OS18_2   27  Capital Gains               O   $           FD TIA    200
 1920        OS18_2   37  Ontario Capital             O   $           FD TIA    200
SEND


Schedule 024  First time filer
FGS          TO
 1000        S24      66  type of corp (FROM FED)     O   N           FD TIA03  200
 TABLE        FYFAA       1210 1200
*1210        OS24    23  33  2   S24PART2             O   A/N         FD REF    140 A9
*1200        OS24    22  32  2   S24PART2             O   A/N         FD N1     160 2L
 TABLE        FYFAWU      1310 1320 1330 1300
*1310        OS24    35  63  4   S24PART3             O   A/N         FD REF    140 A9
*1320        OS24    36  64  4   S24PART3             O   D           FD DTM    150 242
*1330        OS24    37  65  4   S24PART3             O   D           FD DTM    150 447
*1300        OS24    34  62  4   S24PART3             O   A/N         FD N1     160 2L
SEND


Schedule 027  Ontario Manufacturing and Processing Profits Credit
FGS          CMPP
 2740        OS27     8   MC                          O   $           FD TIA    200
 2741        OS27     4   ML                          O   $           FD TIA    200
 2742        OS27     5   ML                          O   $           FD TIA    200
 2743        OS27     6   C                           O   $           FD TIA    200
 2744        OS27     7   L                           O   $           FD TIA    200
 2745        OS27     9   ECP                         O   $           FD TIA    200
 3100        OS27     10  Foreign Net Income          O   $           FD TIA    200
 3110        OS27     11  Foreign Investment          O   $           FD TIA    200
 3120        OS27     12  Foreign Dividend            O   $           FD TIA    200
 3130        OS27     13  Foreign Income              O   $           FD TIA    200
 3140        OS27     14  Canadian Net                O   $           FD TIA    200
 3150        OS27     15  Canadian                    O   $           FD TIA    200
 3160        OS27     16  Canadian Dividend           O   $           FD TIA    200
 3170        OS27     17  Canadian Income             O   $           FD TIA    200
SEND

Schedule 044  Non-Arm's Length Transactions
 TABLE        NALTD       1210 1220 1200
*1210        OS44    5   74  3   S44                  O   A/N         FD REF    140 A9
*1220        OS44    6   74  3   S44                  O   D           FD DTM    150 447
*1200        OS44    4   73  3   S44                  O   A/N         FD N1     160 2L
SEND


Schedule 104  Change of Mailing Address
FGS          COA
 1025        OADDR    1   tax account                 O   A           FD REF    140 A9
 1026        OADDR    2   fed no                      O   A           FD REF    140 9F
 1030        OADDR    3   Effective Date of           O   D           FD DTM    150 007
 1040        OADDR    7   name                        M   A           FD N1     160 31
 1050        OADDR    8   street  Line 1              O   A           FD N3     190
 1070        OADDR    9   City                        O   A           FD N4     190
 1120        OADDR    4   c/o                         O   A           FD N1     160 C1
SEND


Schedule 105  Exempt from Filing Declaration
FGS          EXEMPT
 1040        OPG_2    7  Date                         O   D           FD DTM    150 467
 1000        OPG_2    4  Declaration Name             O   A           FD N1     160 IAG
 1010        OPG_2    ?  Signature                    O   A           FD N1     160 PV
 1020        OPG_2    5  Title/Relation to            O   A           FD N1     160 07
 1030        OPG_2    ?  phone goes with title        O   N           FD N1     160 12
SEND


Schedule 106  MGS - Schedule A - Information on Ontario Corporations
FGS          DOINFO
 1070        OPG_18   15  Date Elected                O   D           FD DTM    150 840
 1080        OPG_18   16  Date Ceased                 O   D           FD DTM    150 924
 1000        OPG_18   4   DOI                         O   A           FD N1     160 IAGDOI
 1002        OPG_18   5   First Name                  O   A           FD IN2    175 02
 1001        OPG_18   4   Last Name                   O   A           FD IN2    175 05
 1003        OPG_18   6   Middle Name                 O   A           FD IN2    175 03
 1010        OPG_18   7   Street number and               A           FD N3     180
 1020        OPG_18   9   City                            A           FD N4     190
 1060        OPG_18   13  Canadian Resident           O   1/2         FD TIA03  200
FGS          PRES
 1090        OPG_18   17  Date Appointed              O   D           FD DTM    150 923
 1100        OPG_18   18  Date Ceased                 O   D           FD DTM    150 924
FGS          SECR
 1110        OPG_18   19  Date Appointed              O   D           FD DTM    150 923
 1120        OPG_18   20  Date Ceased                 O   D           FD DTM    150 924
FGS          TREA
 1130        OPG_18   23  Date Appointed              O   D           FD DTM    150 923
 1140        OPG_18   24  Date Ceased                 O   D           FD DTM    150 924
FGS          GM
 1150        OPG_18   25  Date Appointed              O   D           FD DTM    150 923
 1160        OPG_18   26  Date Ceased                 O   D           FD DTM    150 924
FGS          OTHER
 1170        OPG_18   27  Date Appointed              O   D           FD DTM    150 923
 1180        OPG_18   28  Date Ceased                 O   D           FD DTM    150 924
 1190        OPG_18   31  Other Titles -              O   1/          FD TIA03  200
 1200        OPG_18   32  Other Titles -              O   1/          FD TIA03  200
 1210        OPG_18   33  Other Titles -              O   1/          FD TIA03  200
 1220        OPG_18   34  Other Titles -              O   1/          FD TIA03  200
 1230        OPG_18   35  Other Titles -              O   1/          FD TIA03  200
 1240        OPG_18   36  Other Titles -              O   1/          FD TIA03  200
 1250        OPG_18   37  Other Titles -              O   1/          FD TIA03  200
 1260        OPG_18   38  Other Titles -              O   1/          FD TIA03  200
 1270        OPG_18   39  Other Titles -              O   1/          FD TIA03  200
 1280        OPG_18   40  Other Titles -              O   1/          FD TIA03  200
 1290        OPG_18   41  Other Titles -              O   1/          FD TIA03  200
 1300        OPG_18   42  Other Titles -              O   1/          FD TIA03  200
 1310        OPG_18   43  Other Titles -              O   1/          FD TIA03  200
 1320        OPG_18   44  Other Titles -              O   1/          FD TIA03  200
 1330        OPG_18   45  Other Titles -              O   1/          FD TIA03  200
 1340        OPG_18   46  Other Titles -              O   1/          FD TIA03  200
 1350        OPG_18   47  Other Titles -              O   1/          FD TIA03  200
 1360        OPG_18   48  Other Titles -              O   1/          FD TIA03  200
 1370        OPG_18   49  Other Titles -              O   1/          FD TIA03  200
SEND


Schedule 107  MGS - Schedule K - Information on Foreign Business Corporations
FGS          COMINFO
 1270        OPG_20   13  Date Appointed              O   D           FD DTM    150 923
 1280        OPG_20   14  Date Ceased                 O   D           FD DTM    150 924
 1210        OPG_20   1   COMI constant               O   A           FD N1     160 IAO
 1211        OPG_20   4   Last Name                   O   A           FD IN2    175 05
 1212        OPG_20   5   First Name                  O   A           FD IN2    175 02
 1213        OPG_20   6   Middle Name                 O   A           FD IN2    175 03
 1220        OPG_20   7   Street number and           O   A           FD N3     180
 1230        OPG_20   9   City                        O   A           FD N4     190

FGS          AFSI
 1370        OPG_20   26  Ontario                     O   N           FD REF    140 A9
 1300        OPG_20   2   ASI constant                O   A           FD N1     160 AG
 1302        OPG_20   17  First Name                  O   A           FD IN2    175 02
 1301        OPG_20   16  Last Name                   O   A           FD IN2    175 05
 1303        OPG_20   18  Middle Name                 O   A           FD IN2    175 03
 1310        OPG_20   19  Street number and               A           FD N3     180
 1320        OPG_20   21  City                            A           FD N4     190
 1380        OPG_20   27  Corporation Name            O   A           FD N1     160 31
 1390        OPG_20   28  Street number and               A           FD N3     180
 1400        OPG_20   31  City                            A           FD N4     190
 1290        OPG_20   15  Indicate if the             O   1/          FD TIA03  200
 1360        OPG_20   25  Indicate if the             O   1/          FD TIA03  200
SEND

Schedule 108  Ontario Sound Recording Tax Credit
FGS          SOUND
 1000        OSOUND   4  Date of first                O   D           FD DTM    150 196
 1010        OSOUND   5        Date of last           O   D           FD DTM    150 197
 1020        OSOUND   6        Artists royalties      O   $           FD TIA    200
 1030        OSOUND   7        Musician fees          O   $           FD TIA    200
 1040        OSOUND   8        Graphics incurred      O   $           FD TIA    200
 1045        OSOUND   9        Producers' Fee         O   $           FD TIA    200
 1050        OSOUND   10       Software incurred      O   $           FD TIA    200
 1055        OSOUND   11       Studio Costs &         O   $           FD TIA    200
 1060        OSOUND   12       Digital scanning       O   $           FD TIA    200
 1070        OSOUND   45       Programming            O   $           FD TIA    200
 1075        OSOUND   46       Engineers' &           O   $           FD TIA    200
 1080        OSOUND   47       Beta testing           O   $           FD TIA    200
 1090        OSOUND   13       Qualifying music       O   $           FD TIA    200
 1100        OSOUND   15       Consultant fees        O   $           FD TIA    200
 1110        OSOUND   17       Employees wages        O   $           FD TIA    200
 1115        OSOUND   48       Advertising and        O   $           FD TIA    200
 1120        OSOUND   19       Rental costs           O   $           FD TIA    200
 1130        OSOUND   21       Expenses incurred      O   $           FD TIA    200
 1140        OSOUND   23       Event planning         O   $           FD TIA    200
 1150        OSOUND   25       Design, printing       O   $           FD TIA    200
 1160        OSOUND   27       Security incurred      O   $           FD TIA    200
 1170        OSOUND   29       Business location      O   $           FD TIA    200
 1180        OSOUND   31       Photography            O   $           FD TIA    200
 1190        OSOUND   33       Promotional gifts      O   $           FD TIA    200
 1210        OSOUND   14       Qualifying music       O   $           FD TIA    200
 1220        OSOUND   16       Consultant fees        O   $           FD TIA    200
 1230        OSOUND   18       Employees wages        O   $           FD TIA    200
 1240        OSOUND   20       Rental costs           O   $           FD TIA    200
 1250        OSOUND   22       Expenses incurred      O   $           FD TIA    200
 1260        OSOUND   24       Event planning         O   $           FD TIA    200
 1270        OSOUND   26       Design, printing       O   $           FD TIA    200
 1280        OSOUND   28       Security incurred      O   $           FD TIA    200
 1290        OSOUND   30       Business location      O   $           FD TIA    200
 1300        OSOUND   32       Photography            O   $           FD TIA    200
 1310        OSOUND   34       Promotional gifts      O   $           FD TIA    200
 1360        OSOUND   40       Deduct Government      O   $           FD TIA    200
 1370        OSOUND   41       Add repayment of       O   $           FD TIA    200
SEND


Schedule 109  Ontario Current Cost Adjustment
TABLE        ASSET       1000 1010 1020
*1000        OCCA    4   13  3   OCCA                 O   $           FD TIA    200
*1010        OCCA    5   14  3   OCCA                 O   $           FD TIA    200
*1020        OCCA    6   15  3   OCCA                 O   $           FD TIA    200
FGS          OCCA
 1060        OCCA     19 Capital cost of              O   $           FD TIA    200
 1070        OCCA     20 Capital cost of              O   $           FD TIA    200
 1080        OCCA     21 Capital cost of              O   $           FD TIA    200
 1090        OCCA     22 Maximum limit is             O   $           FD TIA    200
 1100        OCCA     23 Maximum limit is             O   $           FD TIA    200
 1110        OCCA     24 Maximum limit is             O   $           FD TIA    200
 1170        OCCA     31 Repaid Assistance            O   $           FD TIA    200
 1180        OCCA     32 Other Adjustments            O   $           FD TIA    200
 1190        OCCA     33 Related ITC                  O   $           FD TIA    200
 1200        OCCA     34 Assistance                   O   $           FD TIA    200
 1210        OCCA     35 Other Adjustments            O   $           FD TIA    200
 1260        OCCA     41 Ontario Allocation           O   %           FD TIA06  200
 1280        OCCA     39 Ontario Current              O   $           FD TIA    200
SEND


Schedule 110  Ontario Political Election Contribution
FGS          POLDON
 2000        OPOLIT   4  Ontario taxable              O   $           FD TIA    200
 2010        OPOLIT   5  Political donation           O   $           FD TIA    200
 2020        OPOLIT   6  Ontario taxable              O   $           FD TIA    200
 2030        OPOLIT   7  Annual limit                 O   $           FD TIA    200
 2060        OPOLIT   10 Ontario Allocation           O   %           FD TIA06  200
 2090        OPOLIT   13 Political                    O   $           FD TIA    200
FGS          CONT
 2110        OPOLIT   14 Prior year ending            O   $           FD TIA    200
 2120        OPOLIT   15 Current year                 O   $           FD TIA    200
 2140        OPOLIT   16 Amount claimed in            O   $           FD TIA    200
SEND


Schedule 111  Ontario Foreign Tax Credit
FGS          FOREIGN
 3000        OFTC#1   4  Investment Income            O   $           FD TIA    200
 3010        OFTC#1   5  Add: Taxable                 O   $           FD TIA    200
 3020        OFTC#1   6  Less: Allowable              O   $           FD TIA    200
 3040        OFTC#1   10 Ontario Allocation           O   %           FD TIA06  200
 3050        OFTC#1   11 Foreign non-                 O   $           FD TIA    200
 3060        OFTC#1   12 Less:  Amount of             O   $           FD TIA    200
 3080        OFTC#1   14 Foreign Non-                 O   $           FD TIA    200
 3100        OFTC#1   22 Total Days                   O   N           FD TIA04  200
 3110        OFTC#1   21 Days after May 1,            O   N           FD TIA04  200
 3121        OFTC#1   26 Days after Dec 31,           O   N           FD TIA04  200
 3151        OFTC#1   44 Days after Dec 31,           O   N           FD TIA04  200
 3153        OFTC#1   49 Days after Dec 31,           O   N           FD TIA04  200
 3210        OFTC#1   29 Ontario Foreign              O   $           FD TIA    200
 3220        OFTC#1   38 Ontario Foreign              O   $           FD TIA    200
 3230        OFTC#1   42 Ontario Foreign              O   $           FD TIA    200
SEND


Schedule 112  Ontario Book Publishing Tax Credit
FGS          BOOK
 1000        OBPTC    5  Amount of non-               O   $           FD TIA    200
 1010        OBPTC    6  Salaries and wages           O   $           FD TIA    200
 1020        OBPTC    7  Freelance fees               O   $           FD TIA    200
 1030        OBPTC    8  Amounts for                  O   $           FD TIA    200
 1050        OBPTC    11 Expenditures                 O   $           FD TIA    200
 1070        OBPTC    13 Expenditures for             O   $           FD TIA    200
 1080        OBPTC    14 Expenditures for             O   $           FD TIA    200
 1100        OBPTC    16 Salaries and wages           O   $           FD TIA    200
 1110        OBPTC    17 Other amounts                O   $           FD TIA    200
 1140        OBPTC    21 Government                   O   $           FD TIA    200
 1150        OBPTC    23 Qualifying                   O   $           FD TIA    200
 1170        OBPTC    25 Total Eligible               O   $           FD TIA    200
 1180        OBPTC    28 Tax Credit is                O   $           FD TIA    200
 1190        OBPTC    29 Total Eligible               O   $           FD TIA    200
 1210        OBPTC    33 Tax credit is                O   $           FD TIA    200
SEND

Schedule 113  Ontario Business-Research Institute Tax Credit (OBRITC)
TABLE        BUSRSCH     1010 1000 1020 1030 1050 1080 1090
*1010        OBRITC  5   35  6   OBRITC               O   N           FD REF    140 9F
*1000        OBRITC  4   34  6   OBRITC               O   A           FD N1     160 95
*1020        OBRITC  6   36  6   OBRITC               O   $           FD TIA    200
*1030        OBRITC  7   37  6   OBRITC               O   $           FD TIA    200
*1050        OBRITC  9   39  6   OBRITC               O   $           FD TIA    200
*1080        OBRITC  40  45  1   OBRITC2              O   N           FD TIA04  200
*1090        OBRITC  46  51  1   OBRITC3              O   $           FD TIA    200
FGS          OBRITC
 1100        OBRITC   52 total                        O   $           FD TIA    200
SEND

Schedule 114  ATTC - Ontario Apprenticeship Training Tax Credit
TABLE        ATTCELGBL   7603 7601 7605 7604 7606 7607 7602 7600 7608 7609
*7603        OS114_1 9   35  13  OS114                O   N           FD REF    140 CO
*7601        OS114_1 4   30  13  OS114                O   A           FD REF03  140 ZZ
*7605        OS114_1 11  37  13  OS114                O   A           FD REF    140 AH
*7604        OS114_1 10  36  13  OS114                O   D           FD DTM    150 447
*7606        OS114_1 12  38  13  OS114                O   D           FD DTM    150 196
*7607        OS114_1 13  39  13  OS114                O   D           FD DTM    150 197
*7602        OS114_1 7   33  13  OS114                O   A           FD N1     160 S2
*7600        OS114_1 3   29  13  OS114                O   A           FD TIA03  200
*7608        OS114_1 14  40  13  OS114                O   $           FD TIA    200
*7609        OS114_1 15  41  13  OS114                O   $           FD TIA    200
FGS          ATTCSUM
 7610        OS114_1  44                              O   $           FD TIA    200
 7611        OS114_1  46                              O   %           FD TIA06  200
 7612        OS114_1  47                              O   N           FD TIA04  200
SEND


Schedule 160  Research and Development Super Allowance
FGS          EXBASE
 1600        OS1B     7   3rd prior year              O   D           FD DTM    150 602
 1610        OS1B     9   2nd prior year              O   D           FD DTM    150 601
 1620        OS1B     11  1st prior year              O   D           FD DTM    150 194
 1630        OS1B     35  Number of days in           O   N           FD TIA04  200
 1640        OS1B     36  Number of days in           O   N           FD TIA04  200
 1650        OS1B     5   Number of days in           O   N           FD TIA04  200
 1660        OS1B     8   Eligible qualified          O   $           FD TIA    200
 1670        OS1B     10  Eligible qualified          O   $           FD TIA    200
 1680        OS1B     12  Eligible qualified          O   $           FD TIA    200
 1690        OS1B     54  ITC 3rd prior RDSA          O   $           FD TIA    200
 1700        OS1B     55  ITC 2nd prior RDSA          O   $           FD TIA    200
 1710        OS1B     56  ITC 1st  prior              O   $           FD TIA    200
 1720        OS1B     57  Other adjustments           O   $           FD TIA    200
 1730        OS1B     58  Other adjustments           O   $           FD TIA    200
 1740        OS1B     59  Other adjustments           O   $           FD TIA    200
 1748        OS1B     14  Days in current             O   N           FD TIA04  200
 1750        OS1B     46  Days in Base                O   N           FD TIA04  200
 1760        OS1B     37  Was the                     O   1/2         FD TIA03  200
 1770        OS1B     39  Aggregate of                O   $           FD TIA    200
 1780        OS1B     40  Aggregate Net               O   $           FD TIA    200
FGS          SUPALL
 1790        OS1B     4   Qualified                   O   $           FD TIA    200
 1800        OS1B     6   ITC deducted under          O   $           FD TIA    200
 1810        OS1B     45  Negative Net                O   $           FD TIA    200
 1820        OS1B     34  Other adjustments           O   $           FD TIA    200
 1830        OS1B     ?   Zero "Net Eligible          O   $           FD TIA    200
 1840        OS1B     33  Negative "Net               O   $           FD TIA    200
 1850        OS1B     19  Excess                      O   $           FD TIA    200
 1844        OS1B     20  Allowance on                O   $           FD TIA    200
 1846        OS1B     21  Rate - Allowance            O   N           FD TIA06  200
 1847        OS1B     23  Allowance on                O   $           FD TIA    200
 1848        OS1B     24  Rate - Allowance            O   N           FD TIA06  200
 1858        OS1B     3   Rate - Gross-up             O   N           FD TIA06  200
 1860        OS1B     28  Ontario Research &          O   $           FD TIA    200
SEND

Schedule 161  Research and Development
FGS          ONTPOOL
 1601        OS161_2  4   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1602        OS161_2  5   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1603        OS161_2  6   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1604        OS161_2  7   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1605        OS161_2  8   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1606        OS161_2  10  xxxxxxxxxxxxxxxxxx          O   %           FD TIA06  200
 1611        OS161_2  14  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1612        OS161_2  15  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1613        OS161_2  16  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1614        OS161_2  17  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1615        OS161_2  18  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1616        OS161_2  19  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1621        OS161_2  26  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1622        OS161_2  27  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
FGS          FEDITC
 1631        OS161_3  4   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1632        OS161_3  5   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1633        OS161_3  6   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1635        OS161_3  8   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1636        OS161_3  9   xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1637        OS161_3  10  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1638        OS161_3  11  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
 1641        OS161_3  13  xxxxxxxxxxxxxxxxxx          O   $           FD TIA    200
TABLE        CONTSRED    1701 1702 1703 1704 1705 1706
*1701        OS161_4 4   58  6   OS1611               O   D           FD DTM    150 194
*1702        OS161_4 5   59  6   OS1611               O   $           FD TIA    200
*1703        OS161_4 6   60  6   OS1611               O   $           FD TIA    200
*1704        OS161_4 7   61  6   OS1611               O   $           FD TIA    200
*1705        OS161_4 8   62  6   OS1611               O   $           FD TIA    200
*1706        OS161_4 9   63  6   OS1611               O   $           FD TIA    200
TABLE        CONTQORD    1801 1802 1803 1804 1805
*1801        OS161_5 4   49  5   OS1612               O   D           FD DTM    150 194
*1802        OS161_5 5   50  5   OS1612               O   $           FD TIA    200
*1803        OS161_5 6   51  5   OS1612               O   $           FD TIA    200
*1804        OS161_5 7   52  5   OS1612               O   $           FD TIA    200
*1805        OS161_5 8   53  5   OS1612               O   $           FD TIA    200
SEND


Schedule 591  Capital tax election of Associated group
TABLE        CTELECT     1000 1010 1030 1020 1120 1070 1080 1090 1100 1110
*1000        OS591#1 4   48  11  OS591                O   N           FD REF    140 A9
*1010        OS591#1 5   49  11  OS591                O   D           FD DTM    150 194
*1030        OS591#1 11  55  11  OS591                O   AN          FD N1     160 2L
*1020        OS591#1 6   50  11  OS591                O   %           FD TIA06  200
*1120        OS591#1 77  81  1   OS591C               O   %           FD TIA06  200
*1070        OS591#1 8   52  11  OS591                O   $           FD TIA    200
*1080        OS591#1 9   53  11  OS591                O   $           FD TIA    200
*1090        OS591#1 10  54  11  OS591                O   $           FD TIA    200
*1100        OS591#1 67  75  2   OS591B               O   $           FD TIA    200
*1110        OS591#1 68  76  2   OS591B               O   $           FD TIA    200

FGS          TAND
 2000        OS591#1  1  Tot assets                   O   $           FD TIA    200
 2010        OS591#1  2  Tot net ded                  O   $           FD TIA    200
 2020        OS591#1  3  Tot alloc net ded            O   $           FD TIA    200
SEND

Schedule 800  Ontario Innovation Tax Credit Claim (OITC)
FGS          ELIG
 8001        OITC_1   6   Was the                     O   1/2         FD TIA03  200
 8010        OITC_1   8   Did the                     O   1/2         FD TIA03  200
 8020        OITC_1   10  Did the                     O   1/2         FD TIA03  200
 8030        OITC_1   12  Was corporation a           O   1/2         FD TIA03  200
 8040        OITC_1   14  Percentage of               O   %           FD TIA06  200
 8050        OITC_1   15  Have contract or            O   1/2         FD TIA03  200
 8060        OITC_1   17  Corporations                O   $           FD TIA    200
 8070        OITC_1   31  Corporation's               O   $           FD TIA    200
 8815        OITC_2   4   Corporations                O   $           FD TIA    200
TABLE        PART2MAG    8090 8100 8080 8110 8120
*8090        OITC_1  19  27  4   OITCPART1            O   N           FD REF    140 A9
*8100        OITC_1  20  28  4   OITCPART1            O   D           FD DTM    150 091
*8080        OITC_1  18  26  4   OITCPART1            O   A           FD N1     160 2L
*8110        OITC_1  21  29  4   OITCPART1            O   $           FD TIA    200
*8120        OITC_1  32  34  4   OITCPART1            O   $           FD TIA    200
TABLE        QELMAG      8150 8160
*8150        OITC_3  6   10  2   OITC1D               O   A           FD N1     160 2L
*8160        OITC_3  7   11  2   OITC1D               O   $           FD TIA    200
TABLE        DETBL       8830 8840 8820 8850
*8830        OITC_2  6   14  4   OITC1CI              O   N           FD REF    140 A9
*8840        OITC_2  7   15  4   OITC1CI              O   D           FD DTM    150 091
*8820        OITC_2  5   13  4   OITC1CI              O   A           FD N1     160 2L
*8850        OITC_2  8   16  4   OITC1CI              O   $           FD TIA    200
FGS          DMBLN
 8864        OITC_2   32  Corporations                O   $           FD TIA    200
 8869        OITC_2   45  Corporations                O   $           FD TIA    200
TABLE        DMBL        8866 8867 8865 8868
*8866        OITC_2  34  42  4   OITC1CI              O   N           FD REF    140 A9
*8867        OITC_2  35  43  4   OITC1CI              O   D           FD DTM    150 091
*8865        OITC_2  33  41  4   OITC1CI              O   A           FD N1     160 2L
*8868        OITC_2  36  44  4   OITC1CI              O   $           FD TIA    200
TABLE        PROSBL      8650 8670 8640 8680
*8650        OITC_2  19  27  4   OITC1CII             O   N           FD REF    140 A9
*8670        OITC_2  20  28  4   OITC1CII             O   D           FD DTM    150 091
*8640        OITC_2  18  26  4   OITC1CII             O   A           FD N1     160 2L
*8680        OITC_2  21  29  4   OITC1CII             O   $           FD TIA    200
FGS          PART2
 8130        OITC_3   4   Name of                     O   A           FD N1     160 2L
 8900        OITC_3   65  qual exp limit              O   $           FD TIA    200
 8125        OITC_3   67  qual exp limit              O   $           FD TIA    200
 8630        OITC_2   46  Corporation's               O   $           FD TIA    200
 8140        OITC_3   5   Expenditure                 O   $           FD TIA    200
 8170        OITC_3   13  Current                     O   $           FD TIA    200
 8180        OITC_3   16  Capital                     O   $           FD TIA    200
 8190        OITC_3   14  Allowable Portion           O   $           FD TIA    200
 8200        OITC_3   17  Allowable Portion           O   $           FD TIA    200
TABLE        ALLBL       8930 8950 8960 8970
*8930        OITC_4  4   19  5   OITCALLBL            O   AN          FD N1     160 2L
*8950        OITC_4  6   21  5   OITCALLBL            O   N           FD TIA    200
*8960        OITC_4  7   22  5   OITCALLBL            O   %           FD TIA06  200
*8970        OITC_4  8   23  5   OITCALLBL            O   N           FD TIA    200
FGS          NCCPCBL
 8920        OITC_4   63  qual exp limit              O   D           FD DTM    150 ??
 8901        OITC_3   26  qual exp limit              O   $           FD TIA    200
 8902        OITC_3   29  qual exp limit              O   $           FD TIA    200
 8903        OITC_3   32  qual exp limit              O   $           FD TIA    200
 8904        OITC_3   33  qual exp limit              O   $           FD TIA    200
 8910        OITC_3   34  qual exp limit              O   $           FD TIA    200
 8980        OITC_3   62  qual exp limit              O   $           FD TIA    200

TABLE        SREDPERF    8210 8220 8221 8230 8240 8250 8260
*8210        OITC_4  24  48  12  OITCPART2            O   A           FD N1     160 2L
*8220        OITC_4  25  49  12  OITCPART2            O   A           FD N3     180
*8221        OITC_4  26  50  12  OITCPART2            O   A           FD N4     190
*8230        OITC_4  30  54  12  OITCPART2            O   1/2         FD TIA03  200
*8240        OITC_4  32  56  12  OITCPART2            O   1/2         FD TIA03  200
*8250        OITC_4  34  58  12  OITCPART2            O   $           FD TIA    200
*8260        OITC_4  35  59  12  OITCPART2            O   $           FD TIA    200
TABLE        3PTYPAY     8270 8280 8281 8290 8300 8310
*8270        OITC_5  4   26  11  OITCPART3            O   A           FD N1     160 TY
*8280        OITC_5  5   27  11  OITCPART3            O   A           FD N3     180
*8281        OITC_5  6   28  11  OITCPART3            O   A           FD N4     190
*8290        OITC_5  10  32  11  OITCPART3            O   1/2         FD TIA03  200
*8300        OITC_5  12  34  11  OITCPART3            O   1/2         FD TIA03  200
*8310        OITC_5  14  36  11  OITCPART3            O   $           FD TIA    200
FGS          WAIV
 8380        OITC_5   45  Title of                    O   A           FD REF    140 ZZ
 8360        OITC_5   40  Date OITC Waiver            O   D           FD DTM    150 467
 8390        OITC_5   46  Date Certification          O   D           FD DTM    150 606
 8352        OITC_5   ?   Signature of                O   A           FD N1     160 AF
 8370        OITC_5   44  Name of Authorized          O   A           FD N1     160 TY
 8381        OITC_5   ?   Signature of                O   A           FD N1     160 PV
 8330        OITC_5   37  Eligible OITC               O   $           FD TIA    200
 8340        OITC_5   38   Amount of OITC             O   $           FD TIA    200
 8350        OITC_5   39   Amount of OITC             O   $           FD TIA    200
SEND

RSIEND
