unit T1_2026testfrm;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,DBCtrls,Mask;

type

  TTESTFRMT1_2026 = class(TForm)

    Label2: TLabel;

    DBEdit1:TDBEdit;

    Label5: TLabel;

    Label6: TLabel;

    Label7: TLabel;

    DBEdit2:TDBEdit;

    DBEdit3:TDBEdit;

    Label9: TLabel;

    DBEdit4:TDBEdit;

    DBEdit5:TDBEdit;

    Label12: TLabel;

    Label13: TLabel;

    DBEdit6:TDBEdit;

    Label16: TLabel;

    DBEdit9:TDBEdit;

    Label18: TLabel;

    Label20: TLabel;

    DBEdit10:TDBEdit;

    Label22: TLabel;

    Label23: TLabel;

    Label24: TLabel;

    DBEdit11:TDBEdit;

    Label25: TLabel;

    Label26: TLabel;

    DBEdit12:TDBEdit;

    Label27: TLabel;

    Label28: TLabel;

    DBEdit13:TDBEdit;

    Label29: TLabel;

    DBEdit14:TDBEdit;

    DBEdit15:TDBEdit;

    Label31: TLabel;

    DBEdit16:TDBEdit;

    Label32: TLabel;

    Label33: TLabel;

    DBEdit17:TDBEdit;

    Label34: TLabel;

    Label35: TLabel;

    DBEdit18:TDBEdit;

    Label36: TLabel;

    Label37: TLabel;

    Label39: TLabel;

    DBEdit20:TDBEdit;

    Label40: TLabel;

    Label41: TLabel;

    DBEdit21:TDBEdit;

    Label43: TLabel;

    Label44: TLabel;

    DBEdit24:TDBEdit;

    Label47: TLabel;

    Label48: TLabel;

    Label49: TLabel;

    Label50: TLabel;

    Label51: TLabel;

    Label52: TLabel;

    DBEdit25:TDBEdit;

    DBEdit26:TDBEdit;

    Label53: TLabel;

    DBEdit27:TDBEdit;

    DBEdit28:TDBEdit;

    Label54: TLabel;

    Label55: TLabel;

    Label56: TLabel;

    Label57: TLabel;

    DBEdit29:TDBEdit;

    Label59: TLabel;

    DBEdit30:TDBEdit;

    Label60: TLabel;

    Label62: TLabel;

    Shape27: TShape;

    Shape34: TShape;

    Shape37: TShape;

    Shape38: TShape;

    Shape39: TShape;

    Shape40: TShape;

    Shape41: TShape;

    Shape42: TShape;

    Label8: TLabel;

    Label11: TLabel;

    Label10: TLabel;

    Label17: TLabel;

    DBEdit34: TDBEdit;

    DBEdit35: TDBEdit;

    Label30: TLabel;

    Label136: TLabel;

    Label42: TLabel;

    DBEdit36: TDBEdit;

    Shape28: TShape;

    Label19: TLabel;

    Label137: TLabel;

    Label58: TLabel;

    Label128: TLabel;

    Label143: TLabel;

    Shape1: TShape;

    Label144: TLabel;

    DBEdit33: TDBEdit;

    Label21: TLabel;

    Shape29: TShape;

    DBEdit7: TDBEdit;

    Label15: TLabel;

    DBEdit8: TDBEdit;

    Label45: TLabel;

    DBEdit22: TDBEdit;

    Label4: TLabel;

    Label46: TLabel;

    Label145: TLabel;

    Label147: TLabel;

    Shape33: TShape;

    Label148: TLabel;

    Label149: TLabel;

    Label150: TLabel;

    Label151: TLabel;

    Label152: TLabel;

    Shape35: TShape;

    DBEdit43: TDBEdit;

    DBEdit44: TDBEdit;

    Label109: TLabel;

    Label110: TLabel;

    Label111: TLabel;

    Label113: TLabel;

    Label114: TLabel;

    Label116: TLabel;

    Label122: TLabel;

    Label129: TLabel;

    Label130: TLabel;

    DBEdit56: TDBEdit;

    DBEdit57: TDBEdit;

    DBEdit45: TDBEdit;

    DBEdit46: TDBEdit;

    DBEdit47: TDBEdit;

    DBEdit48: TDBEdit;

    DBEdit49: TDBEdit;

    DBEdit51: TDBEdit;

    DBEdit52: TDBEdit;

    DBEdit54: TDBEdit;

    DBEdit55: TDBEdit;

    Label108: TLabel;

    Label115: TLabel;

    DBEdit58: TDBEdit;

    Label118: TLabel;

    DBEdit59: TDBEdit;

    DBEdit60: TDBEdit;

    Shape2: TShape;

    Label67: TLabel;

    DBEdit61: TDBEdit;

    Label65: TLabel;

    Label14: TLabel;

    Label72: TLabel;

    DBEdit37: TDBEdit;

    Label73: TLabel;

    Label74: TLabel;

    Label79: TLabel;

    Label84: TLabel;

    Label85: TLabel;

    Label86: TLabel;

    DBEdit38: TDBEdit;

    Label87: TLabel;

    Label88: TLabel;

    Label89: TLabel;

    Label90: TLabel;

    Label91: TLabel;

    Shape9: TShape;

    Label92: TLabel;

    DBEdit39: TDBEdit;

    Label93: TLabel;

    DBEdit40: TDBEdit;

    Label94: TLabel;

    Label95: TLabel;

    DBEdit41: TDBEdit;

    Shape11: TShape;

    Label96: TLabel;

    DBEdit42: TDBEdit;

    Shape4: TShape;

    Shape54: TShape;

    Shape44: TShape;

    Shape43: TShape;

    Label132: TLabel;

    Label133: TLabel;

    Label134: TLabel;

    Shape45: TShape;

    Shape46: TShape;

    Shape49: TShape;

    Shape51: TShape;

    Shape52: TShape;

    Shape53: TShape;

    Shape55: TShape;

    Shape56: TShape;

    Label135: TLabel;

    Shape47: TShape;

    Shape48: TShape;

    Label1: TLabel;

    DBEdit53: TDBEdit;

    Label70: TLabel;

    Label71: TLabel;

    DBEdit62: TDBEdit;

    DBEdit63: TDBEdit;

    Label97: TLabel;

    DBEdit64: TDBEdit;

    Label98: TLabel;

    Label99: TLabel;

    DBEdit65: TDBEdit;

    Label100: TLabel;

    Label101: TLabel;

    DBEdit66: TDBEdit;

    Label103: TLabel;

    Label102: TLabel;

    Label63: TLabel;

    Label64: TLabel;

    Label66: TLabel;

    Label68: TLabel;

    DBEdit19: TDBEdit;

    Label69: TLabel;

    Label75: TLabel;

    Label76: TLabel;

    Label77: TLabel;

    Shape3: TShape;

    Label38: TLabel;

    Label78: TLabel;

    DBEdit23: TDBEdit;

    Label81: TLabel;

    DBEdit67: TDBEdit;

    DBEdit68: TDBEdit;

    Label82: TLabel;

    Label83: TLabel;

    Label104: TLabel;

    DBEdit69: TDBEdit;

    Label61: TLabel;

    Label3: TLabel;

    Label105: TLabel;

    DBEdit70: TDBEdit;

    Label106: TLabel;

    Label107: TLabel;

    DBEdit72: TDBEdit;

    Label112: TLabel;

    DBEdit71: TDBEdit;

    Label117: TLabel;

    DBEdit73: TDBEdit;

    Label120: TLabel;

    Label121: TLabel;

    DBEdit74: TDBEdit;

    DBEdit75: TDBEdit;

    Label123: TLabel;

    DBEdit76: TDBEdit;

    Label124: TLabel;

    DBEdit77: TDBEdit;

    Label125: TLabel;

    DBEdit78: TDBEdit;

    Label126: TLabel;

    Label131: TLabel;

    DBEdit80: TDBEdit;

    Label138: TLabel;

    Label139: TLabel;

    Label127: TLabel;

    Label140: TLabel;

    Label141: TLabel;

    Label142: TLabel;

    Label146: TLabel;

    Label153: TLabel;

    DBEdit81: TDBEdit;

    DBEdit82: TDBEdit;

    DBEdit83: TDBEdit;

    DBEdit84: TDBEdit;

    Shape8: TShape;

    Shape10: TShape;

    Shape12: TShape;

    Shape13: TShape;

    Shape7: TShape;

    Label119: TLabel;

    Label154: TLabel;

    Label155: TLabel;

    Label156: TLabel;

    Shape14: TShape;

    Label157: TLabel;

    DBEdit85: TDBEdit;

    Label158: TLabel;

    DBEdit86: TDBEdit;

    Label159: TLabel;

    DBEdit87: TDBEdit;

    Label160: TLabel;

    DBEdit88: TDBEdit;

    Label161: TLabel;

    Label162: TLabel;

    DBEdit89: TDBEdit;

    Label163: TLabel;

    DBEdit90: TDBEdit;

    Shape5: TShape;

    Shape6: TShape;

    Label80: TLabel;

    Label164: TLabel;

    Label165: TLabel;

    Shape15: TShape;

    Label166: TLabel;

    Label167: TLabel;

    Shape16: TShape;

    Label168: TLabel;

    Label169: TLabel;

    Shape17: TShape;

    Label170: TLabel;

    Label171: TLabel;

    Shape18: TShape;

    Label172: TLabel;

    Label173: TLabel;

    Shape19: TShape;

    Label174: TLabel;

    Label175: TLabel;

    Shape20: TShape;

    Label176: TLabel;

    Label177: TLabel;

    Shape21: TShape;

    Label178: TLabel;

    Label179: TLabel;

    Shape22: TShape;

    Label180: TLabel;

    Label181: TLabel;

    Shape23: TShape;

    Label182: TLabel;

    Label183: TLabel;

    Shape24: TShape;

    Label184: TLabel;

    Label185: TLabel;

    Shape25: TShape;

    Label186: TLabel;

    Label187: TLabel;

    Label188: TLabel;

    Label189: TLabel;

    Label190: TLabel;

    Shape26: TShape;

    Label191: TLabel;

    Label192: TLabel;

    Shape30: TShape;

    Label193: TLabel;

    Label194: TLabel;

    Shape31: TShape;

    Label195: TLabel;

    Label196: TLabel;

    Shape32: TShape;

    Label197: TLabel;

    Label198: TLabel;

    Label199: TLabel;

    Label200: TLabel;

    Label201: TLabel;

    Label202: TLabel;

    Label203: TLabel;

    Shape36: TShape;

    Label204: TLabel;

    Label205: TLabel;

    Label206: TLabel;

    Label207: TLabel;

    Shape50: TShape;

    Label208: TLabel;

    Label209: TLabel;

    Label210: TLabel;

    Label211: TLabel;

    Shape57: TShape;

    Label212: TLabel;

    Label213: TLabel;

    Label214: TLabel;

    Label215: TLabel;

    Shape58: TShape;

    Label216: TLabel;

    Label217: TLabel;

    Label218: TLabel;

    Label219: TLabel;

    Label220: TLabel;

    Label221: TLabel;

    Label222: TLabel;

    Label223: TLabel;

    Label224: TLabel;

    Label225: TLabel;

    Label226: TLabel;

    Label227: TLabel;

    Label228: TLabel;

    Label229: TLabel;

    Label230: TLabel;

    Shape59: TShape;

    Label231: TLabel;

    Shape60: TShape;

    Shape61: TShape;

    Label232: TLabel;

    Label233: TLabel;

    Label234: TLabel;

    Label235: TLabel;

    Label236: TLabel;

    Label237: TLabel;

    Label238: TLabel;

    Label239: TLabel;

    Shape62: TShape;

    Label240: TLabel;

    Label241: TLabel;

    Label242: TLabel;

    Label243: TLabel;

    Label244: TLabel;

    DBEdit31: TDBEdit;

    DBEdit32: TDBEdit;

    DBEdit50: TDBEdit;

    DBEdit79: TDBEdit;

    DBEdit91: TDBEdit;

    DBEdit92: TDBEdit;

    DBEdit93: TDBEdit;

    DBEdit94: TDBEdit;

    DBEdit95: TDBEdit;

    DBEdit96: TDBEdit;

    DBEdit97: TDBEdit;

    DBEdit98: TDBEdit;

    DBEdit99: TDBEdit;

    DBEdit100: TDBEdit;

    DBEdit101: TDBEdit;

    DBEdit102: TDBEdit;

    DBEdit103: TDBEdit;

    DBEdit104: TDBEdit;

    DBEdit105: TDBEdit;

    DBEdit106: TDBEdit;

    DBEdit107: TDBEdit;

    DBEdit108: TDBEdit;

    DBEdit109: TDBEdit;

    DBEdit110: TDBEdit;

    DBEdit111: TDBEdit;

    DBEdit112: TDBEdit;

    DBEdit113: TDBEdit;

    DBEdit114: TDBEdit;

    DBEdit115: TDBEdit;

    DBEdit116: TDBEdit;

    DBEdit117: TDBEdit;

    DBEdit118: TDBEdit;

    Label245: TLabel;

    Label246: TLabel;

    Label247: TLabel;

    Label248: TLabel;

    Label249: TLabel;

    Label250: TLabel;

    Label251: TLabel;

    Label252: TLabel;

    Label253: TLabel;

    Label254: TLabel;

    Shape63: TShape;

    Label255: TLabel;

    Label256: TLabel;

    Shape64: TShape;

    Label257: TLabel;

    Label258: TLabel;

    Shape65: TShape;

    Label259: TLabel;

    Label260: TLabel;

    Shape66: TShape;

    Label261: TLabel;

    Label262: TLabel;

    Shape67: TShape;

    Label263: TLabel;

    Label264: TLabel;

    Shape68: TShape;

    Label265: TLabel;

    Label266: TLabel;

    Shape69: TShape;

    Label267: TLabel;

    Label268: TLabel;

    Label269: TLabel;

    Label270: TLabel;

    Shape70: TShape;

    Label271: TLabel;

    Label272: TLabel;

    Shape71: TShape;

    Label273: TLabel;

    Label274: TLabel;

    Shape72: TShape;

    Label275: TLabel;

    Label276: TLabel;

    Shape73: TShape;

    Label277: TLabel;

    Label278: TLabel;

    Shape74: TShape;

    Label279: TLabel;

    Label280: TLabel;

    Shape75: TShape;

    Label281: TLabel;

    Label282: TLabel;

    Label283: TLabel;

    Shape76: TShape;

    Label284: TLabel;

    Label285: TLabel;

    Shape77: TShape;

    Label286: TLabel;

    Label287: TLabel;

    Label288: TLabel;

    Shape78: TShape;

    Label289: TLabel;

    Label290: TLabel;

    Shape79: TShape;

    Label291: TLabel;

    Label292: TLabel;

    Label293: TLabel;

    Shape80: TShape;

    Shape81: TShape;

    Label294: TLabel;

    Label295: TLabel;

    Label296: TLabel;

    Shape82: TShape;

    Label297: TLabel;

    Label298: TLabel;

    Label299: TLabel;

    Shape83: TShape;

    Label300: TLabel;

    Label301: TLabel;

    Label302: TLabel;

    Shape84: TShape;

    Label303: TLabel;

    Shape85: TShape;

    Label304: TLabel;

    Label305: TLabel;

    Shape86: TShape;

    Label306: TLabel;

    Label307: TLabel;

    Label308: TLabel;

    DBEdit119: TDBEdit;

    DBEdit120: TDBEdit;

    DBEdit121: TDBEdit;

    DBEdit122: TDBEdit;

    DBEdit123: TDBEdit;

    DBEdit124: TDBEdit;

    DBEdit125: TDBEdit;

    DBEdit126: TDBEdit;

    DBEdit127: TDBEdit;

    DBEdit128: TDBEdit;

    DBEdit129: TDBEdit;

    DBEdit130: TDBEdit;

    DBEdit131: TDBEdit;

    DBEdit132: TDBEdit;

    DBEdit133: TDBEdit;

    DBEdit134: TDBEdit;

    DBEdit135: TDBEdit;

    DBEdit136: TDBEdit;

    DBEdit137: TDBEdit;

    DBEdit138: TDBEdit;

    DBEdit139: TDBEdit;

    DBEdit140: TDBEdit;

    DBEdit141: TDBEdit;

    DBEdit142: TDBEdit;

    DBEdit143: TDBEdit;

    DBEdit144: TDBEdit;

    DBEdit145: TDBEdit;

    Shape87: TShape;

    Shape88: TShape;

    Label309: TLabel;

    Label310: TLabel;

    Label311: TLabel;

    Shape89: TShape;

    Label312: TLabel;

    Label313: TLabel;

    Shape90: TShape;

    Label314: TLabel;

    Label315: TLabel;

    Shape91: TShape;

    Label316: TLabel;

    Shape92: TShape;

    Label317: TLabel;

    Label318: TLabel;

    Label319: TLabel;

    Label320: TLabel;

    Shape93: TShape;

    Label321: TLabel;

    Label322: TLabel;

    Shape94: TShape;

    Label323: TLabel;

    Label324: TLabel;

    Shape95: TShape;

    Label325: TLabel;

    Label326: TLabel;

    Shape96: TShape;

    Label327: TLabel;

    Label328: TLabel;

    Shape97: TShape;

    Label329: TLabel;

    Label330: TLabel;

    Shape98: TShape;

    Label331: TLabel;

    Label332: TLabel;

    Shape99: TShape;

    Shape100: TShape;

    Label333: TLabel;

    Shape101: TShape;

    Label334: TLabel;

    Label335: TLabel;

    Shape102: TShape;

    Label336: TLabel;

    Label337: TLabel;

    Shape103: TShape;

    Label338: TLabel;

    Label339: TLabel;

    Label340: TLabel;

    Label341: TLabel;

    Label342: TLabel;

    Label343: TLabel;

    Label344: TLabel;

    Label345: TLabel;

    Label346: TLabel;

    Label347: TLabel;

    Label348: TLabel;

    Shape104: TShape;

    Shape105: TShape;

    Shape106: TShape;

    Shape107: TShape;

    Shape108: TShape;

    Shape109: TShape;

    Shape110: TShape;

    Shape111: TShape;

    Shape112: TShape;

    Shape113: TShape;

    Shape114: TShape;

    Shape115: TShape;

    Label349: TLabel;

    Label350: TLabel;

    Label351: TLabel;

    Shape116: TShape;

    Shape117: TShape;

    Label352: TLabel;

    Label353: TLabel;

    Shape118: TShape;

    Shape119: TShape;

    Label354: TLabel;

    Shape120: TShape;

    Label355: TLabel;

    Label356: TLabel;

    Label357: TLabel;

    Shape121: TShape;

    Shape122: TShape;

    Label358: TLabel;

    Label359: TLabel;

    Shape123: TShape;

    Label360: TLabel;

    Label361: TLabel;

    Shape124: TShape;

    Shape125: TShape;

    Shape126: TShape;

    Label362: TLabel;

    Shape127: TShape;

    Shape128: TShape;

    Shape129: TShape;

    Label363: TLabel;

    Label364: TLabel;

    Label365: TLabel;

    Shape130: TShape;

    Label366: TLabel;

    Label367: TLabel;

    Label368: TLabel;

    Shape131: TShape;

    Label369: TLabel;

    Label370: TLabel;

    Label371: TLabel;

    Label372: TLabel;

    Label373: TLabel;

    Label374: TLabel;

    Label375: TLabel;

    Label376: TLabel;

    Label377: TLabel;

    Label378: TLabel;

    Label379: TLabel;

    Label380: TLabel;

    Label381: TLabel;

    Label382: TLabel;

    Label383: TLabel;

    Label384: TLabel;

    Label385: TLabel;

    Label386: TLabel;

    Label387: TLabel;

    Label388: TLabel;

    Shape132: TShape;

    Label389: TLabel;

    Label390: TLabel;

    Label391: TLabel;

    Label392: TLabel;

    Label393: TLabel;

    Label394: TLabel;

    Shape133: TShape;

    Shape134: TShape;

    Shape135: TShape;

    DBEdit146: TDBEdit;

    DBEdit147: TDBEdit;

    DBEdit148: TDBEdit;

    DBEdit149: TDBEdit;

    DBEdit150: TDBEdit;

    DBEdit151: TDBEdit;

    DBEdit152: TDBEdit;

    DBEdit153: TDBEdit;

    DBEdit154: TDBEdit;

    DBEdit155: TDBEdit;

    DBEdit156: TDBEdit;

    DBEdit157: TDBEdit;

    DBEdit158: TDBEdit;

    DBEdit159: TDBEdit;

    DBEdit160: TDBEdit;

    DBEdit161: TDBEdit;

    DBEdit162: TDBEdit;

    DBEdit163: TDBEdit;

    DBEdit164: TDBEdit;

    DBEdit165: TDBEdit;

    DBEdit166: TDBEdit;

    DBEdit167: TDBEdit;

    DBEdit168: TDBEdit;

    DBEdit169: TDBEdit;

    DBEdit170: TDBEdit;

    DBEdit171: TDBEdit;

    DBEdit172: TDBEdit;

    DBEdit173: TDBEdit;

    DBEdit174: TDBEdit;

    DBEdit175: TDBEdit;

    DBEdit176: TDBEdit;

    DBEdit177: TDBEdit;

    DBEdit178: TDBEdit;

    Shape136: TShape;

    Label395: TLabel;

    Label396: TLabel;

    Label397: TLabel;

    Label398: TLabel;

    Label399: TLabel;

    Label400: TLabel;

    Shape137: TShape;

    Shape138: TShape;

    Shape139: TShape;

    Shape140: TShape;

    Shape141: TShape;

    Label401: TLabel;

    Label402: TLabel;

    Label403: TLabel;

    Label404: TLabel;

    Label405: TLabel;

    Shape142: TShape;

    Shape143: TShape;

    Label406: TLabel;

    Label407: TLabel;

    Label408: TLabel;

    Label409: TLabel;

    Shape144: TShape;

    Shape145: TShape;

    Label410: TLabel;

    Label411: TLabel;

    Label412: TLabel;

    Shape146: TShape;

    Label413: TLabel;

    Shape147: TShape;

    Label414: TLabel;

    Label415: TLabel;

    Label416: TLabel;

    Label417: TLabel;

    Label418: TLabel;

    Label419: TLabel;

    Label420: TLabel;

    Label421: TLabel;

    Label422: TLabel;

    Shape148: TShape;

    Label423: TLabel;

    Label424: TLabel;

    Shape149: TShape;

    Label425: TLabel;

    Label426: TLabel;

    Shape150: TShape;

    Label427: TLabel;

    Shape151: TShape;

    Label428: TLabel;

    Label429: TLabel;

    Shape152: TShape;

    Label430: TLabel;

    Label431: TLabel;

    Shape153: TShape;

    Label432: TLabel;

    Label433: TLabel;

    Label434: TLabel;

    Label435: TLabel;

    Label436: TLabel;

    Shape154: TShape;

    Label437: TLabel;

    Label438: TLabel;

    Shape155: TShape;

    Label439: TLabel;

    Label440: TLabel;

    Shape156: TShape;

    Label441: TLabel;

    Label442: TLabel;

    Shape157: TShape;

    Label443: TLabel;

    Label444: TLabel;

    Shape158: TShape;

    Label445: TLabel;

    Label446: TLabel;

    Shape159: TShape;

    Label447: TLabel;

    Label448: TLabel;

    Shape160: TShape;

    Label449: TLabel;

    Label450: TLabel;

    Label451: TLabel;

    Shape161: TShape;

    Shape162: TShape;

    Shape163: TShape;

    Label452: TLabel;

    Shape164: TShape;

    Label453: TLabel;

    Label454: TLabel;

    Label455: TLabel;

    Label456: TLabel;

    Label457: TLabel;

    Shape165: TShape;

    Shape166: TShape;

    Label458: TLabel;

    Shape167: TShape;

    Label459: TLabel;

    Label460: TLabel;

    Label461: TLabel;

    Label462: TLabel;

    Shape168: TShape;

    Label463: TLabel;

    Label464: TLabel;

    Label465: TLabel;

    Label466: TLabel;

    Label467: TLabel;

    Label468: TLabel;

    Label469: TLabel;

    Label470: TLabel;

    Label471: TLabel;

    Label472: TLabel;

    Label473: TLabel;

    Label474: TLabel;

    Label475: TLabel;

    Label476: TLabel;

    Label477: TLabel;

    Label478: TLabel;

    Label479: TLabel;

    Label480: TLabel;

    Label481: TLabel;

    Label482: TLabel;

    Label483: TLabel;

    Label484: TLabel;

    Label485: TLabel;

    Label486: TLabel;

    DBEdit179: TDBEdit;

    DBEdit180: TDBEdit;

    DBEdit181: TDBEdit;

    DBEdit182: TDBEdit;

    DBEdit183: TDBEdit;

    DBEdit184: TDBEdit;

    DBEdit185: TDBEdit;

    DBEdit186: TDBEdit;

    DBEdit187: TDBEdit;

    DBEdit188: TDBEdit;

    DBEdit189: TDBEdit;

    DBEdit190: TDBEdit;

    DBEdit191: TDBEdit;

    DBEdit192: TDBEdit;

    DBEdit193: TDBEdit;

    DBEdit194: TDBEdit;

    DBEdit195: TDBEdit;

    DBEdit196: TDBEdit;

    DBEdit197: TDBEdit;

    DBEdit198: TDBEdit;

    DBEdit199: TDBEdit;

    DBEdit200: TDBEdit;

    DBEdit201: TDBEdit;

    DBEdit202: TDBEdit;

    DBEdit203: TDBEdit;

    DBEdit204: TDBEdit;

    DBEdit205: TDBEdit;

    DBEdit206: TDBEdit;

    DBEdit207: TDBEdit;

    DBEdit208: TDBEdit;

    DBEdit209: TDBEdit;

    DBEdit210: TDBEdit;

    DBEdit211: TDBEdit;

    DBEdit212: TDBEdit;

    DBEdit213: TDBEdit;

    DBEdit214: TDBEdit;

    DBEdit215: TDBEdit;

    DBEdit216: TDBEdit;

    DBEdit217: TDBEdit;

    DBEdit218: TDBEdit;

    DBEdit219: TDBEdit;

    DBEdit220: TDBEdit;

    DBEdit221: TDBEdit;

    DBEdit222: TDBEdit;

    DBEdit223: TDBEdit;

    DBEdit224: TDBEdit;

    DBEdit225: TDBEdit;

    DBEdit226: TDBEdit;

    DBEdit227: TDBEdit;

    DBEdit228: TDBEdit;

    DBEdit229: TDBEdit;

    DBEdit230: TDBEdit;

    Shape169: TShape;

    Label487: TLabel;

    Label488: TLabel;

    Shape170: TShape;

    Label489: TLabel;

    Shape171: TShape;

    Label490: TLabel;

    Label491: TLabel;

    Shape172: TShape;

    Label492: TLabel;

    Shape173: TShape;

    Label493: TLabel;

    Shape174: TShape;

    Label494: TLabel;

    Shape175: TShape;

    Label495: TLabel;

    Label496: TLabel;

    Shape176: TShape;

    Label497: TLabel;

    Label498: TLabel;

    Label499: TLabel;

    Label500: TLabel;

    Label501: TLabel;

    Shape177: TShape;

    Label502: TLabel;

    Label503: TLabel;

    Label504: TLabel;

    Label505: TLabel;

    Label506: TLabel;

    Label507: TLabel;

    Shape178: TShape;

    Shape179: TShape;

    Shape180: TShape;

    Label508: TLabel;

    Label509: TLabel;

    Shape181: TShape;

    Label510: TLabel;

    Label511: TLabel;

    Label512: TLabel;

    Shape182: TShape;

    Label513: TLabel;

    Label514: TLabel;

    Shape183: TShape;

    Label515: TLabel;

    Label516: TLabel;

    Shape184: TShape;

    Shape185: TShape;

    Label517: TLabel;

    Label518: TLabel;

    Label519: TLabel;

    Label520: TLabel;

    Label521: TLabel;

    Shape186: TShape;

    Label522: TLabel;

    Label523: TLabel;

    Shape187: TShape;

    Label524: TLabel;

    Label525: TLabel;

    Label526: TLabel;

    Label527: TLabel;

    Label528: TLabel;

    Label529: TLabel;

    Label530: TLabel;

    Label531: TLabel;

    Label532: TLabel;

    Label533: TLabel;

    Label534: TLabel;

    Shape188: TShape;

    Label535: TLabel;

    Label536: TLabel;

    Shape189: TShape;

    Shape190: TShape;

    Shape191: TShape;

    Shape192: TShape;

    Label537: TLabel;

    Label538: TLabel;

    Label539: TLabel;

    Shape193: TShape;

    Label540: TLabel;

    Label541: TLabel;

    Shape194: TShape;

    Label542: TLabel;

    Label543: TLabel;

    Label544: TLabel;

    Label545: TLabel;

    Label546: TLabel;

    Label547: TLabel;

    Label548: TLabel;

    Label549: TLabel;

    Label550: TLabel;

    Label551: TLabel;

    Label552: TLabel;

    Label553: TLabel;

    Label554: TLabel;

    Shape195: TShape;

    Shape196: TShape;

    Label555: TLabel;

    Label556: TLabel;

    Label557: TLabel;

    Label558: TLabel;

    Label559: TLabel;

    Label560: TLabel;

    Label561: TLabel;

    Label562: TLabel;

    Label563: TLabel;

    Label564: TLabel;

    Shape197: TShape;

    Shape198: TShape;

    Shape199: TShape;

    Shape200: TShape;

    Shape201: TShape;

    Label565: TLabel;

    Label566: TLabel;

    Shape202: TShape;

    Label567: TLabel;

    Label568: TLabel;

    Shape203: TShape;

    Label569: TLabel;

    Label570: TLabel;

    DBEdit231: TDBEdit;

    DBEdit232: TDBEdit;

    DBEdit233: TDBEdit;

    DBEdit234: TDBEdit;

    DBEdit235: TDBEdit;

    DBEdit236: TDBEdit;

    DBEdit237: TDBEdit;

    DBEdit238: TDBEdit;

    DBEdit239: TDBEdit;

    DBEdit240: TDBEdit;

    DBEdit241: TDBEdit;

    DBEdit242: TDBEdit;

    DBEdit243: TDBEdit;

    DBEdit244: TDBEdit;

    DBEdit245: TDBEdit;

    DBEdit246: TDBEdit;

    DBEdit247: TDBEdit;

    DBEdit248: TDBEdit;

    DBEdit249: TDBEdit;

    DBEdit250: TDBEdit;

    DBEdit251: TDBEdit;

    DBEdit252: TDBEdit;

    DBEdit253: TDBEdit;

    DBEdit254: TDBEdit;

    DBEdit255: TDBEdit;

    DBEdit256: TDBEdit;

    DBEdit257: TDBEdit;

    DBEdit258: TDBEdit;

    DBEdit259: TDBEdit;

    DBEdit260: TDBEdit;

    DBEdit261: TDBEdit;

    DBEdit262: TDBEdit;

    DBEdit263: TDBEdit;

    DBEdit264: TDBEdit;

    DBEdit265: TDBEdit;

    Shape204: TShape;

    Label571: TLabel;

    Label572: TLabel;

    Label573: TLabel;

    Label574: TLabel;

    Label575: TLabel;

    Label576: TLabel;

    Label577: TLabel;

    Label578: TLabel;

    Label579: TLabel;

    Label580: TLabel;

    Label581: TLabel;

    Label582: TLabel;

    Label583: TLabel;

    Label584: TLabel;

    Label585: TLabel;

    Label586: TLabel;

    Label587: TLabel;

    Label588: TLabel;

    Label589: TLabel;

    Label590: TLabel;

    Label591: TLabel;

    Label592: TLabel;

    Label593: TLabel;

    Label594: TLabel;

    Label595: TLabel;

    Label596: TLabel;

    Label597: TLabel;

    Label598: TLabel;

    Label599: TLabel;

    Label600: TLabel;

    Label601: TLabel;

    Label602: TLabel;

    Label603: TLabel;

    Label604: TLabel;

    Label605: TLabel;

    Label606: TLabel;

    Label607: TLabel;

    Label608: TLabel;

    Label609: TLabel;

    Label610: TLabel;

    Label611: TLabel;

    Label612: TLabel;

    Label613: TLabel;

    Label614: TLabel;

    Label615: TLabel;

    Label616: TLabel;

    Label617: TLabel;

    Label618: TLabel;

    Label619: TLabel;

    Label620: TLabel;

    Label621: TLabel;

    Label622: TLabel;

    Label623: TLabel;

    Label624: TLabel;

    Label625: TLabel;

    Label626: TLabel;

    Label627: TLabel;

    Label628: TLabel;

    Label629: TLabel;

    Label630: TLabel;

    Label631: TLabel;

    Label632: TLabel;

    Label633: TLabel;

    Label634: TLabel;

    Label635: TLabel;

    Label636: TLabel;

    Label637: TLabel;

    Label638: TLabel;

    Label639: TLabel;

    Label640: TLabel;

    Label641: TLabel;

    Label642: TLabel;

    Label643: TLabel;

    Label644: TLabel;

    Label645: TLabel;

    Label646: TLabel;

    Label647: TLabel;

    Label648: TLabel;

    Label649: TLabel;

    Label650: TLabel;

    Label651: TLabel;

    Label652: TLabel;

    Label653: TLabel;

    Label654: TLabel;

    Label655: TLabel;

    Label656: TLabel;

    Label657: TLabel;

    Label658: TLabel;

    Label659: TLabel;

    Label660: TLabel;

    Label661: TLabel;

    Label662: TLabel;

    Label663: TLabel;

    Label664: TLabel;

    Label665: TLabel;

    Label666: TLabel;

    Label667: TLabel;

    Label668: TLabel;

    Label669: TLabel;

    Label670: TLabel;

    Label671: TLabel;

    Label672: TLabel;

    Label673: TLabel;

    Label674: TLabel;

    Label675: TLabel;

    Label676: TLabel;

    Label677: TLabel;

    Label678: TLabel;

    Label679: TLabel;

    Label680: TLabel;

    Label681: TLabel;

    Label682: TLabel;

    Label683: TLabel;

    Label684: TLabel;

    Label685: TLabel;

    Label686: TLabel;

    Label687: TLabel;

    Label688: TLabel;

    Label689: TLabel;

    Label690: TLabel;

    Label691: TLabel;

    Label692: TLabel;

    Label693: TLabel;

    Label694: TLabel;

    Label695: TLabel;

    Label696: TLabel;

    Label697: TLabel;

    Label698: TLabel;

    Label699: TLabel;

    Label700: TLabel;

    Label701: TLabel;

    Label702: TLabel;

    Label703: TLabel;

    Label704: TLabel;

    Label705: TLabel;

    Label706: TLabel;

    Label707: TLabel;

    Label708: TLabel;

    Label709: TLabel;

    Label710: TLabel;

    Label711: TLabel;

    Label712: TLabel;

    Label713: TLabel;

    Label714: TLabel;

    Label715: TLabel;

    Label716: TLabel;

    Label717: TLabel;

    Label718: TLabel;

    Label719: TLabel;

    Label720: TLabel;

    Label721: TLabel;

    Label722: TLabel;

    Label723: TLabel;

    Label724: TLabel;

    Label725: TLabel;

    Label726: TLabel;

    Label727: TLabel;

    Label728: TLabel;

    Label729: TLabel;

    Label730: TLabel;

    Label731: TLabel;

    Label732: TLabel;

    Label733: TLabel;

    Label734: TLabel;

    Label735: TLabel;

    Label736: TLabel;

    Label737: TLabel;

    Label738: TLabel;

    Label739: TLabel;

    Label740: TLabel;

    Label741: TLabel;

    Label742: TLabel;

    Label743: TLabel;

    Label744: TLabel;

    Label745: TLabel;

    Label746: TLabel;

    Label747: TLabel;

    Label748: TLabel;

    Label749: TLabel;

    Label750: TLabel;

    Label751: TLabel;

    Label752: TLabel;

    Label753: TLabel;

    Label754: TLabel;

    Label755: TLabel;

    Label756: TLabel;

    Label757: TLabel;

    Label758: TLabel;

    Label759: TLabel;

    Label760: TLabel;

    Label761: TLabel;

    Label762: TLabel;

    Label763: TLabel;

    Label764: TLabel;

    Label765: TLabel;

    Label766: TLabel;

    Label767: TLabel;

    Label768: TLabel;

    Label769: TLabel;

    Label770: TLabel;

    Label771: TLabel;

    Label772: TLabel;

    Label773: TLabel;

    Label774: TLabel;

    Label775: TLabel;

    Label776: TLabel;

    DBEdit266: TDBEdit;

    DBEdit267: TDBEdit;

    DBEdit268: TDBEdit;

    DBEdit269: TDBEdit;

    DBEdit270: TDBEdit;

    DBEdit271: TDBEdit;

    DBEdit272: TDBEdit;

    DBEdit273: TDBEdit;

    DBEdit274: TDBEdit;

    DBEdit275: TDBEdit;

    DBEdit276: TDBEdit;

    DBEdit277: TDBEdit;

    DBEdit278: TDBEdit;

    DBEdit279: TDBEdit;

    DBEdit280: TDBEdit;

    DBEdit281: TDBEdit;

    DBEdit282: TDBEdit;

    DBEdit283: TDBEdit;

    DBEdit284: TDBEdit;

    DBEdit285: TDBEdit;

    DBEdit286: TDBEdit;

    DBEdit287: TDBEdit;

    DBEdit288: TDBEdit;

    DBEdit289: TDBEdit;

    DBEdit290: TDBEdit;

    DBEdit291: TDBEdit;

    DBEdit292: TDBEdit;

    DBEdit293: TDBEdit;

    DBEdit294: TDBEdit;

    DBEdit295: TDBEdit;

    DBEdit296: TDBEdit;

    DBEdit297: TDBEdit;

    DBEdit298: TDBEdit;

    DBEdit299: TDBEdit;

    DBEdit300: TDBEdit;

    DBEdit301: TDBEdit;

    DBEdit302: TDBEdit;

    DBEdit303: TDBEdit;

    DBEdit304: TDBEdit;

    DBEdit305: TDBEdit;

    DBEdit306: TDBEdit;

    DBEdit307: TDBEdit;

    DBEdit308: TDBEdit;

    DBEdit309: TDBEdit;

    DBEdit310: TDBEdit;

    DBEdit311: TDBEdit;

    DBEdit312: TDBEdit;

    DBEdit313: TDBEdit;

    DBEdit314: TDBEdit;

    DBEdit315: TDBEdit;

    DBEdit316: TDBEdit;

    DBEdit317: TDBEdit;

    DBEdit318: TDBEdit;

    DBEdit319: TDBEdit;

    DBEdit320: TDBEdit;

    DBEdit321: TDBEdit;

    DBEdit322: TDBEdit;

    DBEdit323: TDBEdit;

    DBEdit324: TDBEdit;

    DBEdit325: TDBEdit;

    DBEdit326: TDBEdit;

    DBEdit327: TDBEdit;

    DBEdit328: TDBEdit;

    DBEdit329: TDBEdit;

    DBEdit330: TDBEdit;

    DBEdit331: TDBEdit;

    DBEdit332: TDBEdit;

    DBEdit333: TDBEdit;

    DBEdit334: TDBEdit;

    DBEdit335: TDBEdit;

    DBEdit336: TDBEdit;

    DBEdit337: TDBEdit;

    DBEdit338: TDBEdit;

    DBEdit339: TDBEdit;

    DBEdit340: TDBEdit;

    DBEdit341: TDBEdit;

    DBEdit342: TDBEdit;

    DBEdit343: TDBEdit;

    DBEdit344: TDBEdit;

    DBEdit345: TDBEdit;

    DBEdit346: TDBEdit;

    DBEdit347: TDBEdit;

    DBEdit348: TDBEdit;

    DBEdit349: TDBEdit;

    DBEdit350: TDBEdit;

    DBEdit351: TDBEdit;

    DBEdit352: TDBEdit;

    DBEdit353: TDBEdit;

    DBEdit354: TDBEdit;

    DBEdit355: TDBEdit;

    DBEdit356: TDBEdit;

    DBEdit357: TDBEdit;

    DBEdit358: TDBEdit;

    DBEdit359: TDBEdit;

    DBEdit360: TDBEdit;

    DBEdit361: TDBEdit;

    DBEdit362: TDBEdit;

    DBEdit363: TDBEdit;

    DBEdit364: TDBEdit;

    DBEdit365: TDBEdit;

    DBEdit366: TDBEdit;

    DBEdit367: TDBEdit;

    DBEdit368: TDBEdit;

    DBEdit369: TDBEdit;

    DBEdit370: TDBEdit;

    DBEdit371: TDBEdit;

    DBEdit372: TDBEdit;

    DBEdit373: TDBEdit;

    DBEdit374: TDBEdit;

    DBEdit375: TDBEdit;

    DBEdit376: TDBEdit;

    DBEdit377: TDBEdit;

    DBEdit378: TDBEdit;

    DBEdit379: TDBEdit;

    DBEdit380: TDBEdit;

  private

    { Private declarations }

  public

    { Public declarations }

  end;

var

TESTFRM: TTESTFRMT1_2026;

implementation

{$R *.DFM}

end.

