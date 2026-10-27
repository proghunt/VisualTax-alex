unit conscom;
interface
uses Classes, SysUtils;

Type TEkLanguageId=word;
     TEkControlStatus=array of boolean;

const
wdAfrikaans=1078;
wdAlbanian=1052;
wdArabic=1025;
wdArabicAlgeria=5121;
wdArabicBahrain=15361;
wdArabicEgypt=3073;
wdArabicIraq=2049;
wdArabicJordan=11265;
wdArabicKuwait=13313;
wdArabicLebanon=12289;
wdArabicLibya=4097;
wdArabicMorocco=6145;
wdArabicOman=8193;
wdArabicQatar=16385;
wdArabicSyria=10241;
wdArabicTunisia=7169;
wdArabicUAE=14337;
wdArabicYemen=9217;
wdArmenian=1067;
wdAssamese=1101;
wdAzeriCyrillic=2092;
wdAzeriLatin=1068;
wdBasque=1069;
wdBelgianDutch=2067;
wdBelgianFrench=2060;
wdBengali=1093;
wdBrazilianPortuguese=1046;
wdBulgarian=1026;
wdBurmese=1109;
wdByelorussian=1059;
wdCatalan=1027;
wdChineseHongKong=3076;
wdChineseMacao=5124;
wdChineseSingapore=4100;
wdCroatian=1050;
wdCzech=1029;
wdDanish=1030;
wdDutch=1043;
wdEnglishAUS=3081;
wdEnglishBelize=10249;
wdEnglishCanadian=4105;
wdEnglishCaribbean=9225;
wdEnglishIreland=6153;
wdEnglishJamaica=8201;
wdEnglishNewZealand=5129;
wdEnglishPhilippines=13321;
wdEnglishSouthAfrica=7177;
wdEnglishTrinidad=11273;
wdEnglishUK=2057;
wdEnglishUS=1033;
wdEnglishZimbabwe=12297;
wdEstonian=1061;
wdFaeroese=1080;
wdFarsi=1065;
wdFinnish=1035;
wdFrench=1036;
wdFrenchCameroon=11276;
wdFrenchCanadian=3084;
wdFrenchCotedIvoire=12300;
wdFrenchLuxembourg=5132;
wdFrenchMali=13324;
wdFrenchMonaco=6156;
wdFrenchReunion=8204;
wdFrenchSenegal=10252;
wdFrenchWestIndies=7180;
wdFrenchZaire=9228;
wdFrisianNetherlands=1122;
wdGaelicIreland=2108;
wdGaelicScotland=1084;
wdGalician=1110;
wdGeorgian=1079;
wdGerman=1031;
wdGermanAustria=3079;
wdGermanLiechtenstein=5127;
wdGermanLuxembourg=4103;
wdGreek=1032;
wdGujarati=1095;
wdHebrew=1037;
wdHindi=1081;
wdHungarian=1038;
wdIcelandic=1039;
wdIndonesian=1057;
wdItalian=1040;
wdJapanese=1041;
wdKannada=1099;
wdKashmiri=1120;
wdKazakh=1087;
wdKhmer=1107;
wdKirghiz=1088;
wdKonkani=1111;
wdKorean=1042;
wdLanguageNone=0;
wdLao=1108;
wdLatvian=1062;
wdLithuanian=1063;
wdMacedonian=1071;
wdMalayalam=1100;
wdMalayBruneiDarussalam=2110;
wdMalaysian=1086;
wdMaltese=1082;
wdManipuri=1112;
wdMarathi=1102;
wdMexicanSpanish=2058;
wdMongolian=1104;
wdNepali=1121;
wdNoProofing=1024;
wdNorwegianBokmol=1044;
wdNorwegianNynorsk=2068;
wdOriya=1096;
wdPolish=1045;
wdPortuguese=2070;
wdPunjabi=1094;
wdRhaetoRomanic=1047;
wdRomanian=1048;
wdRomanianMoldova=2072;
wdRussian=1049;
wdRussianMoldova=2073;
wdSamiLappish=1083;
wdSanskrit=1103;
wdSerbianCyrillic=3098;
wdSerbianLatin=2074;
wdSesotho=1072;
wdSimplifiedChinese=2052;
wdSindhi=1113;
wdSlovak=1051;
wdSlovenian=1060;
wdSorbian=1070;
wdSpanish=1034;
wdSpanishArgentina=11274;
wdSpanishBolivia=16394;
wdSpanishChile=13322;
wdSpanishColombia=9226;
wdSpanishCostaRica=5130;
wdSpanishDominicanRepublic=7178;
wdSpanishEcuador=12298;
wdSpanishElSalvador=17418;
wdSpanishGuatemala=4106;
wdSpanishHonduras=18442;
wdSpanishModernSort=3082;
wdSpanishNicaragua=19466;
wdSpanishPanama=6154;
wdSpanishParaguay=15370;
wdSpanishPeru=10250;
wdSpanishPuertoRico=20490;
wdSpanishUruguay=14346;
wdSpanishVenezuela=8202;
wdSutu=1072;
wdSwahili=1089;
wdSwedish=1053;
wdSwedishFinland=2077;
wdSwissFrench=4108;
wdSwissGerman=2055;
wdSwissItalian=2064;
wdTajik=1064;
wdTamil=1097;
wdTatar=1092;
wdTelugu=1098;
wdThai=1054;
wdTibetan=1105;
wdTraditionalChinese=1028;
wdTsonga=1073;
wdTswana=1074;
wdTurkish=1055;
wdTurkmen=1090;
wdUkrainian=1058;
wdUrdu=1056;
wdUzbekCyrillic=2115;
wdUzbekLatin=1091;
wdVenda=1075;
wdVietnamese=1066;
wdWelsh=1106;
wdXhosa=1076;
wdZulu=1077;

const
EkLanguageIDs:array [0..172] of TIdentMapEntry = (
(Value: 1078; name : 'wdAfrikaans'),
(Value: 1052; name : 'wdAlbanian'),
(Value: 1025; name : 'wdArabic'),
(Value: 5121; name : 'wdArabicAlgeria'),
(Value: 15361;name : 'wdArabicBahrain'),
(Value: 3073; name : 'wdArabicEgypt'),
(Value: 2049; name : 'wdArabicIraq'),
(Value: 11265;name : 'wdArabicJordan'),
(Value: 13313;name : 'wdArabicKuwait'),
(Value: 12289;name : 'wdArabicLebanon'),
(Value: 4097; name : 'wdArabicLibya'),
(Value: 6145; name : 'wdArabicMorocco'),
(Value: 8193; name : 'wdArabicOman'),
(Value: 16385;name : 'wdArabicQatar'),
(Value: 10241;name : 'wdArabicSyria'),
(Value: 7169; name : 'wdArabicTunisia'),
(Value: 14337;name : 'wdArabicUAE'),
(Value: 9217; name : 'wdArabicYemen'),
(Value: 1067;name : 'wdArmenian'),
(Value: 1101;name : 'wdAssamese'),
(Value: 2092;name : 'wdAzeriCyrillic'),
(Value: 1068;name : 'wdAzeriLatin'),
(Value: 1069;name : 'wdBasque'),
(Value: 2067;name : 'wdBelgianDutch'),
(Value: 2060;name : 'wdBelgianFrench'),
(Value: 1093;name : 'wdBengali'),
(Value: 1046;name : 'wdBrazilianPortuguese'),
(Value: 1026;name : 'wdBulgarian'),
(Value: 1109;name : 'wdBurmese'),
(Value: 1059;name : 'wdByelorussian'),
(Value: 1027;name : 'wdCatalan'),
(Value: 3076;name : 'wdChineseHongKong'),
(Value: 5124;name : 'wdChineseMacao'),
(Value: 4100;name : 'wdChineseSingapore'),
(Value: 1050;name : 'wdCroatian'),
(Value: 1029;name : 'wdCzech'),
(Value: 1030;name : 'wdDanish'),
(Value: 1043;name : 'wdDutch'),
(Value: 3081;name : 'wdEnglishAUS'),
(Value: 10249;name : 'wdEnglishBelize'),
(Value: 4105;name : 'wdEnglishCanadian'),
(Value: 9225;name : 'wdEnglishCaribbean'),
(Value: 6153;name : 'wdEnglishIreland'),
(Value: 8201;name : 'wdEnglishJamaica'),
(Value: 5129;name : 'wdEnglishNewZealand'),
(Value: 13321;name : 'wdEnglishPhilippines'),
(Value: 7177;name : 'wdEnglishSouthAfrica'),
(Value: 11273;name : 'wdEnglishTrinidad'),
(Value: 2057;name : 'wdEnglishUK'),
(Value: 1033;name : 'wdEnglishUS'),
(Value: 12297;name : 'wdEnglishZimbabwe'),
(Value: 1061;name : 'wdEstonian'),
(Value: 1080;name : 'wdFaeroese'),
(Value: 1065;name : 'wdFarsi'),
(Value: 1035;name : 'wdFinnish'),
(Value: 1036;name : 'wdFrench'),
(Value: 11276;name : 'wdFrenchCameroon'),
(Value: 3084;name : 'wdFrenchCanadian'),
(Value: 12300;name : 'wdFrenchCotedIvoire'),
(Value: 5132;name : 'wdFrenchLuxembourg'),
(Value: 13324;name : 'wdFrenchMali'),
(Value: 6156;name : 'wdFrenchMonaco'),
(Value: 8204;name : 'wdFrenchReunion'),
(Value: 10252;name : 'wdFrenchSenegal'),
(Value: 7180;name : 'wdFrenchWestIndies'),
(Value: 9228;name : 'wdFrenchZaire'),
(Value: 1122;name : 'wdFrisianNetherlands'),
(Value: 2108;name : 'wdGaelicIreland'),
(Value: 1084;name : 'wdGaelicScotland'),
(Value: 1110;name : 'wdGalician'),
(Value: 1079;name : 'wdGeorgian'),
(Value: 1031;name : 'wdGerman'),
(Value: 3079;name : 'wdGermanAustria'),
(Value: 5127;name : 'wdGermanLiechtenstein'),
(Value: 4103;name : 'wdGermanLuxembourg'),
(Value: 1032;name : 'wdGreek'),
(Value: 1095;name : 'wdGujarati'),
(Value: 1037;name : 'wdHebrew'),
(Value: 1081;name : 'wdHindi'),
(Value: 1038;name : 'wdHungarian'),
(Value: 1039;name : 'wdIcelandic'),
(Value: 1057;name : 'wdIndonesian'),
(Value: 1040;name : 'wdItalian'),
(Value: 1041;name : 'wdJapanese'),
(Value: 1099;name : 'wdKannada'),
(Value: 1120;name : 'wdKashmiri'),
(Value: 1087;name : 'wdKazakh'),
(Value: 1107;name : 'wdKhmer'),
(Value: 1088;name : 'wdKirghiz'),
(Value: 1111;name : 'wdKonkani'),
(Value: 1042;name : 'wdKorean'),
(Value:    0;name : 'wdLanguageNone'),
(Value: 1108;name : 'wdLao'),
(Value: 1062;name : 'wdLatvian'),
(Value: 1063;name : 'wdLithuanian'),
(Value: 1071;name : 'wdMacedonian'),
(Value: 1100;name : 'wdMalayalam'),
(Value: 2110;name : 'wdMalayBruneiDarussalam'),
(Value: 1086;name : 'wdMalaysian'),
(Value: 1082;name : 'wdMaltese'),
(Value: 1112;name : 'wdManipuri'),
(Value: 1102;name : 'wdMarathi'),
(Value: 2058;name : 'wdMexicanSpanish'),
(Value: 1104;name : 'wdMongolian'),
(Value: 1121;name : 'wdNepali'),
(Value: 1024;name : 'wdNoProofing'),
(Value: 1044;name : 'wdNorwegianBokmol'),
(Value: 2068;name : 'wdNorwegianNynorsk'),
(Value: 1096;name : 'wdOriya'),
(Value: 1045;name : 'wdPolish'),
(Value: 2070;name : 'wdPortuguese'),
(Value: 1094;name : 'wdPunjabi'),
(Value: 1047;name : 'wdRhaetoRomanic'),
(Value: 1048;name : 'wdRomanian'),
(Value: 2072;name : 'wdRomanianMoldova'),
(Value: 1049;name : 'wdRussian'),
(Value: 2073;name : 'wdRussianMoldova'),
(Value: 1083;name : 'wdSamiLappish'),
(Value: 1103;name : 'wdSanskrit'),
(Value: 3098;name : 'wdSerbianCyrillic'),
(Value: 2074;name : 'wdSerbianLatin'),
(Value: 1072;name : 'wdSesotho'),
(Value: 2052;name : 'wdSimplifiedChinese'),
(Value: 1113;name : 'wdSindhi'),
(Value: 1051;name : 'wdSlovak'),
(Value: 1060;name : 'wdSlovenian'),
(Value: 1070;name : 'wdSorbian'),
(Value: 1034;name : 'wdSpanish'),
(Value: 11274;name : 'wdSpanishArgentina'),
(Value: 16394;name : 'wdSpanishBolivia'),
(Value: 13322;name : 'wdSpanishChile'),
(Value: 9226;name : 'wdSpanishColombia'),
(Value: 5130;name : 'wdSpanishCostaRica'),
(Value: 7178;name : 'wdSpanishDominicanRepublic'),
(Value: 12298;name : 'wdSpanishEcuador'),
(Value: 17418;name : 'wdSpanishElSalvador'),
(Value: 4106;name : 'wdSpanishGuatemala'),
(Value: 18442;name : 'wdSpanishHonduras'),
(Value: 3082;name : 'wdSpanishModernSort'),
(Value: 19466;name : 'wdSpanishNicaragua'),
(Value: 6154;name : 'wdSpanishPanama'),
(Value: 15370;name : 'wdSpanishParaguay'),
(Value: 10250;name : 'wdSpanishPeru'),
(Value: 20490;name : 'wdSpanishPuertoRico'),
(Value: 14346;name : 'wdSpanishUruguay'),
(Value: 8202;name : 'wdSpanishVenezuela'),
(Value: 1072;name : 'wdSutu'),
(Value: 1089;name : 'wdSwahili'),
(Value: 1053;name : 'wdSwedish'),
(Value: 2077;name : 'wdSwedishFinland'),
(Value: 4108;name : 'wdSwissFrench'),
(Value: 2055;name : 'wdSwissGerman'),
(Value: 2064;name : 'wdSwissItalian'),
(Value: 1064;name : 'wdTajik'),
(Value: 1097;name : 'wdTamil'),
(Value: 1092;name : 'wdTatar'),
(Value: 1098;name : 'wdTelugu'),
(Value: 1054;name : 'wdThai'),
(Value: 1105;name : 'wdTibetan'),
(Value: 1028;name : 'wdTraditionalChinese'),
(Value: 1073;name : 'wdTsonga'),
(Value: 1074;name : 'wdTswana'),
(Value: 1055;name : 'wdTurkish'),
(Value: 1090;name : 'wdTurkmen'),
(Value: 1058;name : 'wdUkrainian'),
(Value: 1056;name : 'wdUrdu'),
(Value: 2115;name : 'wdUzbekCyrillic'),
(Value: 1091;name : 'wdUzbekLatin'),
(Value: 1075;name : 'wdVenda'),
(Value: 1066;name : 'wdVietnamese'),
(Value: 1106;name : 'wdWelsh'),
(Value: 1076;name : 'wdXhosa'),
(Value: 1077;name : 'wdZulu'));

     //Exceptions
  type
     EBadRtfFormat=Class(Exception);
     EIOError=Class(Exception);
     EIllegalScanUse=Class(Exception);
     EIllegalFunctionUse=Class(Exception);
     EIllegalIFUse=Class(Exception);

//----- UDF result type --------
const udfrNil=0;
      udfrTEkReportVariable=1;
      udfrTPicture=2;
      udfrTMemoryStream=3;

EkUDFResultTypeIDs:array [0..3] of TIdentMapEntry = (
(Value: 0; name : 'udfrNil'),
(Value: 1; name : 'udfrTEkReportVariable'),
(Value: 2; name : 'udfrTPicture'),
(Value: 3; name : 'udfrTMemoryStream'));


type TEkUDFResultType=0..255;
//------------------------------

type TEkFieldFormat=record
      case fmtnumber:longint of
      0,1,2,3,4,7,8:(precision,decimals:longint);
           5:(ImgFmt:longint);
           9:(NDtStr:longint);
      end;


type TEkBaseFormatIDs=record
     id:longint;
     name:string;
     argmin,argmax:longint;
     argtype:set of TEkUDFResultType;
     isfloat:boolean;
     floatformat:TFloatFormat;
end;

 //ImageFormat borders
 const brNone=0;   brSingle=1;
       brDouble=2; brThick=3;
       brShadow=4; brDot=5;
       brHair=6;

 type TEkImageBorderType=0..6;  //(brNone,brSingle,brDouble,brThick,brShadow,brDot,brHair);

 type TEkImageBorder=record
                     BrType:TEkImageBorderType;
                     Width:Single;      //border width in points
                     ColorIndex:Word; //Index from TEkColorArray  0..15
                     end;

const
EkBaseFormatsArr:array [0..11] of TEkBaseFormatIDs = (
(id: 0; name : 'NOFORMAT'; argmin: 1; argmax: 1; argtype: []; isfloat:false; floatformat:ffgeneral),
(id: 1; name : 'FEXP';     argmin: 1; argmax: 2; argtype: [1]; isfloat:true;  floatformat:ffExponent),
(id: 2; name : 'FFIX';     argmin: 1; argmax: 2; argtype: [1]; isfloat:true;  floatformat:ffFixed),
(id: 3; name : 'FNUM';     argmin: 1; argmax: 2; argtype: [1]; isfloat:true;  floatformat:ffNumber),
(id: 4; name : 'FCUR';     argmin: 1; argmax: 2; argtype: [1]; isfloat:true;  floatformat:ffCurrency),
(id: 5; name : 'FIMG';     argmin: 1; argmax: 2; argtype: [1,2]; isfloat:false; floatformat:ffgeneral),
(id: 6; name : 'FLNK';     argmin: 1; argmax: 1; argtype: [1]; isfloat:false; floatformat:ffgeneral),
(id: 7; name : 'FFIXR';    argmin: 1; argmax: 2; argtype: [1]; isfloat:true;  floatformat:ffFixed),
(id: 8; name : 'FNUMR';    argmin: 1; argmax: 2; argtype: [1]; isfloat:true;  floatformat:ffNumber),
(id: 9; name : 'FDTM';     argmin: 2; argmax: 2; argtype: [1]; isfloat:false; floatformat:ffGeneral),
(id: 10; name : 'FBOOL';   argmin: 1; argmax: 1; argtype: [1]; isfloat:false; floatformat:ffGeneral),
(id: 11; name : 'FRTF';   argmin: 1; argmax: 1; argtype: [1]; isfloat:false; floatformat:ffGeneral)
);

type TEKBaseFunctionIDs=record
     id:longint;
     name:string;
     argmin,argmax:longint;
     ResultType:TEkUDFResultType;
end;

const
EkMathIDs:array [0..18] of TIdentMapEntry = (
(Value: 0; name : '&&'),
(Value: 1; name : '||'),
(Value: 2; name : '<='),
(Value: 3; name : '=>'),
(Value: 4; name : '>='),
(Value: 5; name : '<>'),
(Value: 6; name : '!='),
(Value: 7; name : 'u-'),
(Value: 8; name : 'u+'),
(Value: 9; name : '!'),
(Value: 10; name : '*'),
(Value: 11; name : '/'),
(Value: 12; name : '%'),
(Value: 13; name : '+'),
(Value: 14; name : '-'),
(Value: 15; name : '>'),
(Value: 16; name : '<'),
(Value: 17; name : '='),
(Value: 18; name : ':='));

EkSysIDs:array [0..18] of TIdentMapEntry = (
(Value: 0; name : 'SYS_AND'),
(Value: 1; name : 'SYS_OR'),
(Value: 2; name : 'SYS_LTEQ'),
(Value: 3; name : 'SYS_GTEQ'),
(Value: 4; name : 'SYS_GTEQ'),
(Value: 5; name : 'SYS_NOTEQ'),
(Value: 6; name : 'SYS_NOTEQ'),
(Value: 7; name : 'SYS_UMINUS'),
(Value: 8; name : 'SYS_UPLUS'),
(Value: 9; name : 'SYS_NOT'),
(Value: 10; name : 'SYS_MULT'),
(Value: 11; name : 'SYS_DIV'),
(Value: 12; name : 'SYS_PERCENT'),
(Value: 13; name : 'SYS_ADD'),
(Value: 14; name : 'SYS_SUB'),
(Value: 15; name : 'SYS_GT'),
(Value: 16; name : 'SYS_LT'),
(Value: 17; name : 'SYS_EQ'),
(Value: 18; name : 'SYS_LET'));




type TEkDataType=(ekdtUnknown, ekdtString,
                  ekdtNumber, ekdtBoolean, ekdtDateTime);

const
EkBaseFunctionsArr:array [0..67] of TEKBaseFunctionIDs = (
(id: -1; name : 'SUM'; argmin: 2; argmax:3; ResultType:udfrNil;),
(id: -2; name : 'CTN'; argmin: 2; argmax:3; ResultType:udfrNil;),
(id: -3; name : 'CTS'; argmin: 2; argmax:3;  ResultType:udfrNil;),
(id: -4; name : 'VAR'; argmin: 1; argmax:10000;  ResultType:udfrNil;),
(id: -5; name : 'SYS_AND'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -6; name : 'SYS_OR'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -7; name : 'SYS_LTEQ'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -8; name : 'SYS_GTEQ'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -9; name : 'SYS_NOTEQ'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -10; name : 'SYS_UMINUS'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -11; name : 'SYS_UPLUS'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -12; name : 'SYS_NOT'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -13; name : 'SYS_MULT'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -14; name : 'SYS_DIV'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -15; name : 'SYS_PERCENT'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -16; name : 'SYS_ADD'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -17; name : 'SYS_SUB'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -18; name : 'SYS_GT'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -19; name : 'SYS_LT'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -20; name : 'IF'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -21; name : 'WHILE'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -22; name : ''; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -23; name : 'SYS_EQ'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -24; name : 'SET'; argmin: 2; argmax:2;  ResultType:udfrNil;),
(id: -25; name : 'TRIM'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -26; name : 'MID'; argmin: 2; argmax:3; ResultType:udfrTEkReportVariable;),
(id: -27; name : 'SUBSTR'; argmin: 2; argmax:3; ResultType:udfrTEkReportVariable;),
(id: -28; name : 'COPY'; argmin: 2; argmax:3; ResultType:udfrTEkReportVariable;),
(id: -29; name : 'UPPER'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -30; name : 'LOWER'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -31; name : 'STR'; argmin: 1; argmax:3; ResultType:udfrTEkReportVariable;),
(id: -32; name : 'VAL'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -33; name : 'EOF'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -34; name : 'BOF'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -35; name : 'NEXT'; argmin: 1; argmax:1; ResultType:udfrNil;),
(id: -36; name : 'PRIOR'; argmin: 1; argmax:1; ResultType:udfrNil;),
(id: -37; name : 'FIRST'; argmin: 1; argmax:1; ResultType:udfrNil;),
(id: -38; name : 'LAST'; argmin: 1; argmax:1; ResultType:udfrNil;),
(id: -39; name : 'INT'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -40; name : 'FRAC'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -41; name : 'ROUND'; argmin: 1; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -42; name : 'NOW'; argmin: 0; argmax:0; ResultType:udfrTEkReportVariable;),
(id: -43; name : 'DATE'; argmin: 0; argmax:0; ResultType:udfrTEkReportVariable;),
(id: -44; name : 'TIME'; argmin: 0; argmax:0; ResultType:udfrTEkReportVariable;),
(id: -45; name : 'DATETOSTR'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -46; name : 'DATETIMETOSTR'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -47; name : 'TIMETOSTR'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -48; name : 'STRTODATE'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -49; name : 'STRTODATETIME'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -50; name : 'STRTOTIME'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -51; name : 'YEAR'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -52; name : 'MONTH'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -53; name : 'DAY'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -54; name : 'SYEAR'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -55; name : 'SMONTH'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -56; name : 'SDAY'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -57; name : 'DTOS'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -58; name : 'STOD'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -59; name : 'FORMATFLOAT'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -60; name : 'POWER'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -61; name : 'INTPOWER'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -62; name : 'IIF'; argmin: 3; argmax:3; ResultType:udfrTEkReportVariable;),
(id: -63; name : 'ELSIF'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -64; name : 'POS'; argmin: 2; argmax:2; ResultType:udfrTEkReportVariable;),
(id: -65; name : 'SYS_LET'; argmin: 2; argmax:2; ResultType:udfrNil;),
(id: -66; name : 'SYS_IIF_TEST'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -67; name : 'SYS_IIF_TRUE'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;),
(id: -68; name : 'SYS_IIF_FALSE'; argmin: 1; argmax:1; ResultType:udfrTEkReportVariable;)
);

const eklngScan=0; eklngScanEntry=1; eklngScanFooter=2; eklngEndScan=3;
      eklngIf=4; eklngElse=5; eklngEndIf=6; eklngElsIf=7;

EkBaseLangControl:array [eklngScan..eklngElsIf, eklngScan..eklngElsIf] of boolean=(
//scan sentry sfoot  endsc  if    else   endif  elsif
(true, true,  true,  true,  true, false, false, false),  //scan
(true, false, true,  true,  true, false, false, false),  //scanentry
(true, false, false, true,  true, false, false, false),  //scanfooter
(true, false, false, true,  true, true,  true,  true),   //endscan
(true, false, false, false, true, true,  true,  true),   //if
(true, false, false, false, true, false, true,  false),   //else
(true, true,  true,  true,  true, true,  true,  false),   //endif
(true, false, false, false, true, true,  true,  true)    //elsif
);

implementation

end.
