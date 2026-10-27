{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryType1.pas                              }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryType1;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  Classes, DebenuPDFLibraryStructure,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryFont,
  DebenuPDFLibraryFontRasterizer, DebenuPDFLibraryFontConst, DebenuPDFLibraryGenericCanvas, DebenuPDFLibraryMatrix,
  DebenuPDFLibraryExtra;

type
  TPDFCFFHeader = packed record
    Major: Byte;
    Minor: Byte;
    HdrSize: Byte;
    OffSize: Byte;
  end;

  TFDSelect = array of Integer;

  TPDFType1Decoder = class(TPDFFontRasterizer)
  private
    FSubrs: TQuickPDFStringList;
    FGlobalSubrs: TQuickPDFStringList;
    FCIDSubrs: array of TQuickPDFStringList;
    FCIDSelect: TFDSelect;
    FStructure: TPDFStructure;
    FFontDict: TPDFDictionary;
    FClearTextPortion: AnsiString;
    FEncryptedPortion: AnsiString;
    FFixedContentPortion: AnsiString;
    FCharStack: TQuickPDFStringList;
    FCharStringNames: TQuickPDFCaseSensitiveStringList;
    FCharStringValues: TQuickPDFStringList;
    FFDSel: Integer;
    FRD: AnsiString;
    FND: AnsiString;
    FNP: AnsiString;
    FCharStringType: Integer;
    FEncoding: TPDFCharsetNames;
    FFontBBox: TPDFArray;
    FFontMatrixScaling: Double;
    FDecodedCharStrings: TQuickPDFCaseSensitiveStringList;
    FIsCIDFont: Boolean;
    FForceCIDFont: Boolean;
    FOnFindObject: TPDFFindObjectEvent;
    FLenIV: Integer;
    FCharShapes: TQuickPDFCaseSensitiveStringList;
  protected
    procedure Tokenize(const Source: AnsiString; Output: TQuickPDFStringList);
    function Decrypt(R, N: Word; CipherText: AnsiString): AnsiString;
    function GetSubr(Index: Integer): AnsiString;
    function GetType2Subr(Index: Integer): AnsiString;
    function GetType2GSubr(Index: Integer): AnsiString;
    function GetCharString(const Name: AnsiString): AnsiString;
    function GetCharStringCount: Integer;
    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function LoadPFBFromStream(Stream: TStream): Boolean;
    function LoadPFBFromFile(const FileName: WideString): Boolean;
    function LoadPFBFromPDFStream(Stream: TPDFStream): Boolean;
    function LoadPFBFromString(const Source: AnsiString): Boolean;
    function LoadCFFFromPDFStream(Stream: TPDFStream): Boolean;
    function LoadCFFFromStream(Stream: TStream): Boolean;
    function LoadOpenTypeFromStream(Stream: TStream): Boolean;
    function DecodeFontDict: Boolean;
    function DecodeEncryptedPortion: Boolean;
    function DecodeCharstring(const Name: AnsiString): Boolean;
    function DecodeType1Charstring(const Name: AnsiString): Boolean;
    function DecodeType2Charstring(const Name: AnsiString): Boolean;
    function DecryptedEncryptionPortion: AnsiString;
    function GetCharStringName(Index: Integer): AnsiString;

    function RenderToCanvas(var RX, RY: Double; Canvas: TPDFGenericCanvas; Mat: TPDFXForm;
      const CharName: AnsiString; Enc: TPDFEncodingVector): Boolean; override;

    function GetEncoding: TPDFCharsetNames;
    function FontMatrixScaling: Double; override;
    procedure ForceCIDFont;
    property CharStringCount: Integer read GetCharStringCount;
    property ClearTextPortion: AnsiString read FClearTextPortion;
    property EncryptedPortion: AnsiString read FEncryptedPortion;
    property FixedContentPortion: AnsiString read FFixedContentPortion;
    property FontDict: TPDFDictionary read FFontDict;
    property CharStack: TQuickPDFStringList read FCharStack;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;  
  end;

implementation

uses
  SysUtils, Math, DebenuPDFLibraryTrueTypeParser;

const
  StandardEncoding: AnsiString = '|space*32|exclam*33|quotedbl*34|numbersign*35|dollar*36|' +
    'percent*37|ampersand*38|quoteright*39|parenleft*40|parenright*41|' +
    'asterisk*42|plus*43|comma*44|hyphen*45|period*46|slash*47|zero*48|' +
    'one*49|two*50|three*51|four*52|five*53|six*54|seven*55|eight*56|nine*57|' +
    'colon*58|semicolon*59|less*60|equal*61|greater*62|question*63|at*64|' +
    'A*65|B*66|C*67|D*68|E*69|F*70|G*71|H*72|I*73|J*74|K*75|L*76|M*77|N*78|' +
    'O*79|P*80|Q*81|R*82|S*83|T*84|U*85|V*86|W*87|X*88|Y*89|Z*90|' +
    'bracketleft*91|backslash*92|bracketright*93|asciicircum*94|underscore*95|' +
    'quoteleft*96|a*97|b*98|c*99|d*100|e*101|f*102|g*103|h*104|i*105|j*106|' +
    'k*107|l*108|m*109|n*110|o*111|p*112|q*113|r*114|s*115|t*116|u*117|v*118|' +
    'w*119|x*120|y*121|z*122|braceleft*123|bar*124|braceright*125|' +
    'asciitilde*126|exclamdown*161|cent*162|sterling*163|fraction*164|yen*165|' +
    'florin*166|section*167|currency1*168|quotesingle*169|quotedblleft*170|' +
    'guillemotleft*171|guilsinglleft*172|guilsinglright*173|fi*174|fl*175|' +
    'endash*177|dagger*178|daggerdbl*179|periodcentered*180|paragraph*182|' +
    'bullet*183|quotesinglbase*184|quotedblbase*185|quotedblright*186|' +
    'guillemotright*187|ellipsis*188|perthousand*189|questiondown*191|' +
    'grave*193|acute*194|circumflex*195|tilde*196|macron*197|breve*198|' +
    'dotaccent*199|dieresis*200|ring*202|cedilla*203|hungarumlaut*205|' +
    'ogonek*206|caron*207|emdash*208|AE*225|ordfeminine*227|Lslash*232|' +
    'Oslash*233|OE*234|ordmasculine*235|ae*241|dotlessi*245|lslash*248|' +
    'oslash*249|oe*250|germandbls*251|';

  StandardEncodingSID: array[0..255] of Integer = (
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
    51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68,
    69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86,
    87, 88, 89, 90, 91, 92, 93, 94, 95, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 96, 97,
    98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 0, 111,
    112, 113, 114, 0, 115, 116, 117, 118, 119, 120, 121, 122, 0, 123, 0, 124,
    125, 126, 127, 128, 129, 130, 131, 0, 132, 133, 0, 134, 135, 136, 137,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 138, 0, 139, 0, 0, 0, 0,
    140, 141, 142, 143, 0, 0, 0, 0, 0, 144, 0, 0, 0, 145, 0, 0, 146, 147, 148,
    149, 0, 0, 0, 0);

  StandardCFFStrings: AnsiString = 
    '|000.notdef|001space|002exclam|003quotedbl|004numbersign|005dollar|' +
    '006percent|007ampersand|008quoteright|009parenleft|010parenright|' +
    '011asterisk|012plus|013comma|014hyphen|015period|016slash|017zero|' +
    '018one|019two|020three|021four|022five|023six|024seven|025eight|' +
    '026nine|027colon|028semicolon|029less|030equal|031greater|032question|' +
    '033at|034A|035B|036C|037D|038E|039F|040G|041H|042I|043J|044K|045L|' +
    '046M|047N|048O|049P|050Q|051R|052S|053T|054U|055V|056W|057X|058Y|059Z|' +
    '060bracketleft|061backslash|062bracketright|063asciicircum|' +
    '064underscore|065quoteleft|066a|067b|068c|069d|070e|071f|072g|073h|' +
    '074i|075j|076k|077l|078m|079n|080o|081p|082q|083r|084s|085t|086u|087v|' +
    '088w|089x|090y|091z|092braceleft|093bar|094braceright|095asciitilde|' +
    '096exclamdown|097cent|098sterling|099fraction|100yen|101florin|' +
    '102section|103currency|104quotesingle|105quotedblleft|' +
    '106guillemotleft|107guilsinglleft|108guilsinglright|109fi|110fl|' +
    '111endash|112dagger|113daggerdbl|114periodcentered|115paragraph|' +
    '116bullet|117quotesinglbase|118quotedblbase|119quotedblright|' +
    '120guillemotright|121ellipsis|122perthousand|123questiondown|124grave|' +
    '125acute|126circumflex|127tilde|128macron|129breve|130dotaccent|' +
    '131dieresis|132ring|133cedilla|134hungarumlaut|135ogonek|136caron|' +
    '137emdash|138AE|139ordfeminine|140Lslash|141Oslash|142OE|' +
    '143ordmasculine|144ae|145dotlessi|146lslash|147oslash|148oe|' +
    '149germandbls|150onesuperior|151logicalnot|152mu|153trademark|154Eth|' +
    '155onehalf|156plusminus|157Thorn|158onequarter|159divide|160brokenbar|' +
    '161degree|162thorn|163threequarters|164twosuperior|165registered|' +
    '166minus|167eth|168multiply|169threesuperior|170copyright|171Aacute|' +
    '172Acircumflex|173Adieresis|174Agrave|175Aring|176Atilde|177Ccedilla|' +
    '178Eacute|179Ecircumflex|180Edieresis|181Egrave|182Iacute|' +
    '183Icircumflex|184Idieresis|185Igrave|186Ntilde|187Oacute|' +
    '188Ocircumflex|189Odieresis|190Ograve|191Otilde|192Scaron|193Uacute|' +
    '194Ucircumflex|195Udieresis|196Ugrave|197Yacute|198Ydieresis|' +
    '199Zcaron|200aacute|201acircumflex|202adieresis|203agrave|204aring|' +
    '205atilde|206ccedilla|207eacute|208ecircumflex|209edieresis|210egrave|' +
    '211iacute|212icircumflex|213idieresis|214igrave|215ntilde|216oacute|' +
    '217ocircumflex|218odieresis|219ograve|220otilde|221scaron|222uacute|' +
    '223ucircumflex|224udieresis|225ugrave|226yacute|227ydieresis|' +
    '228zcaron|229exclamsmall|230Hungarumlautsmall|231dollaroldstyle|' +
    '232dollarsuperior|233ampersandsmall|234Acutesmall|' +
    '235parenleftsuperior|236parenrightsuperior|237twodotenleader|' +
    '238onedotenleader|239zerooldstyle|240oneoldstyle|241twooldstyle|' +
    '242threeoldstyle|243fouroldstyle|244fiveoldstyle|245sixoldstyle|' +
    '246sevenoldstyle|247eightoldstyle|248nineoldstyle|249commasuperior|' +
    '250threequartersemdash|251periodsuperior|252questionsmall|' +
    '253asuperior|254bsuperior|255centsuperior|256dsuperior|257esuperior|' +
    '258isuperior|259lsuperior|260msuperior|261nsuperior|262osuperior|' +
    '263rsuperior|264ssuperior|265tsuperior|266ff|267ffi|268ffl|' +
    '269parenleftinferior|270parenrightinferior|271Circumflexsmall|' +
    '272hyphensuperior|273Gravesmall|274Asmall|275Bsmall|276Csmall|' +
    '277Dsmall|278Esmall|279Fsmall|280Gsmall|281Hsmall|282Ismall|283Jsmall|' +
    '284Ksmall|285Lsmall|286Msmall|287Nsmall|288Osmall|289Psmall|290Qsmall|' +
    '291Rsmall|292Ssmall|293Tsmall|294Usmall|295Vsmall|296Wsmall|297Xsmall|' +
    '298Ysmall|299Zsmall|300colonmonetary|301onefitted|302rupiah|' +
    '303Tildesmall|304exclamdownsmall|305centoldstyle|306Lslashsmall|' +
    '307Scaronsmall|308Zcaronsmall|309Dieresissmall|310Brevesmall|' +
    '311Caronsmall|312Dotaccentsmall|313Macronsmall|314figuredash|' +
    '315hypheninferior|316Ogoneksmall|317Ringsmall|318Cedillasmall|' +
    '319questiondownsmall|320oneeighth|321threeeighths|322fiveeighths|' +
    '323seveneighths|324onethird|325twothirds|326zerosuperior|' +
    '327foursuperior|328fivesuperior|329sixsuperior|330sevensuperior|' +
    '331eightsuperior|332ninesuperior|333zeroinferior|334oneinferior|' +
    '335twoinferior|336threeinferior|337fourinferior|338fiveinferior|' +
    '339sixinferior|340seveninferior|341eightinferior|342nineinferior|' +
    '343centinferior|344dollarinferior|345periodinferior|346commainferior|' +
    '347Agravesmall|348Aacutesmall|349Acircumflexsmall|350Atildesmall|' +
    '351Adieresissmall|352Aringsmall|353AEsmall|354Ccedillasmall|' +
    '355Egravesmall|356Eacutesmall|357Ecircumflexsmall|358Edieresissmall|' +
    '359Igravesmall|360Iacutesmall|361Icircumflexsmall|362Idieresissmall|' +
    '363Ethsmall|364Ntildesmall|365Ogravesmall|366Oacutesmall|' +
    '367Ocircumflexsmall|368Otildesmall|369Odieresissmall|370OEsmall|' +
    '371Oslashsmall|372Ugravesmall|373Uacutesmall|374Ucircumflexsmall|' +
    '375Udieresissmall|376Yacutesmall|377Thornsmall|378Ydieresissmall|' +
    '379001|380001.001|381001.002|382001.003|383Black|384Bold|385Book|' +
    '386Light|387Medium|388Regular|389Roman|390Semibold|';

  // Type 1 spec mentions max call depth of 10
  QPLType1MaxCallDepth = 20;
    
{ TPDFType1Decoder }

constructor TPDFType1Decoder.Create;
begin
  FStructure := TPDFStructure.Create;
  FFontDict := FStructure.NewDictionary;
  FCharStack := TQuickPDFStringList.Create;
  FSubrs := TQuickPDFStringList.Create;
  FGlobalSubrs := TQuickPDFStringList.Create;
  FCharStringNames := TQuickPDFCaseSensitiveStringList.Create;
  FCharStringValues := TQuickPDFStringList.Create;
  FCharStringType := 1;
  FFontBBox := nil;
  FFontMatrixScaling := 1;

  FDecodedCharStrings := TQuickPDFCaseSensitiveStringList.Create;
  FDecodedCharStrings.Sorted := True;

  FIsCIDFont := False;
  
  FCharShapes := TQuickPDFCaseSensitiveStringList.Create;
  FCharShapes.Sorted := True;
end;

function TPDFType1Decoder.DecodeFontDict: Boolean;
var
  Obj: TPDFObject;
  CTP: AnsiString;
  SL: TQuickPDFStringList;
  X: Integer;
  DX: Integer;
  Encoding, FontMatrix: TPDFArray;
begin
  GetCharsetNames(peStandard, FEncoding);
  Result := False;
  CTP := FClearTextPortion;
  SL := TQuickPDFStringList.Create;
  try
    Tokenize(CTP, SL);
    CTP := '';
    for X := 0 to SL.Count - 1 do
    begin
      if SL[X] = '/ps:FontDirectory' then
      begin
        DX := X - 1;
        repeat
          Inc(DX);
          if SL[DX] <> '/ps:dict' then SL[DX] := '';
        until (DX >= SL.Count) or (SL[DX] = '/ps:dict');  // D13890
      end;
      if SL[X] = '/ps:readonly' then SL[X] := '';
      if SL[X] = '/ps:def' then SL[X] := '';
      if SL[X] = '/ps:end' then SL[X] := '>>';
      if SL[X] = '{' then SL[X] := '[';
      if SL[X] = '}' then SL[X] := ']';
      if SL[X] = '/ps:currentdict' then SL[X] := '';
      if SL[X] = '/ps:currentfile' then SL[X] := '';
      if SL[X] = '/ps:dict' then
      begin
        SL[X] := '';
        if X > 0 then
          SL[X - 1] := '';
        DX := X;
        repeat
          Inc(DX);
        until (DX >= SL.Count) or (SL[DX] = '/ps:begin');
        if (DX < SL.Count) and (SL[DX] = '/ps:begin') then
          SL[DX] := '<<';
      end;
      if SL[X] = '/Encoding' then
      begin
        if X < (SL.Count - 2) then
        begin
          if SL[X + 1] = '/ps:StandardEncoding' then
          begin
            SL[X + 1] := '/StandardEncoding';
          end else
          if SL[X + 2] = '/ps:array' then
          begin
            SL[X + 1] := '[';
            DX := X + 1;
            repeat
              Inc(DX);
              if SL[DX] <> '/ps:dup' then SL[DX] := '';
            until (DX >= (SL.Count - 1)) or (SL[DX] = '/ps:dup');
            repeat
              Inc(DX);
            until (DX >= (SL.Count - 1)) or (SL[DX] = '/ps:def') or (SL[DX] = '/ps:readonly');
            if (DX < (SL.Count - 1)) then
              SL[DX] := ']';
          end;
        end;
      end;
      if SL[X] = '/ps:dup' then SL[X] := '';
      if SL[X] = '/ps:put' then SL[X] := '';
    end;
    for X := 0 to SL.Count - 1 do
      if SL[X] <> '' then
      begin
        CTP := CTP + SL[X] + ' ';
      end;
  finally
    SL.Free;
  end;
  Obj := FStructure.Decode(CTP);
  if Obj is TPDFDictionary then
  begin
    Result := True;
    FStructure.RemoveObject(FFontDict);
    FFontDict := TPDFDictionary(Obj);
    Obj := FFontDict.FindValueByKeyName('FontBBox');
    if Obj is TPDFArray then
      FFontBBox := TPDFArray(Obj)
    else
      FFontBBox := nil;
    Obj := FFontDict.FindValueByKeyName('Encoding');
    if Obj is TPDFArray then
    begin
      Encoding := TPDFArray(Obj);
      DX := 0;
      for X := 0 to Encoding.Count - 1 do
      begin
        Obj := Encoding.Item[X];
        if Obj is TPDFNumeric then
          DX := TPDFNumeric(Obj).AsInteger;
        if Obj is TPDFName then
          FEncoding[DX] := TPDFName(Obj).Name;
      end;
    end;
    Obj := FFontDict.FindValueByKeyName('FontMatrix');
    if Obj is TPDFArray then
    begin
      FontMatrix := TPDFArray(Obj);

      if FontMatrix.Count >= 1 then
      begin
        if (FontMatrix.Item[0] is TPDFNumeric) then
        begin
          Obj := FontMatrix.Item[0];
          FFontMatrixScaling := TPDFNumeric(Obj).AsDouble * 1000;
        end;
      end;
    end;
  end;
end;

destructor TPDFType1Decoder.Destroy;
var
  X: Integer;
begin
  FStructure.Free;
  FCharStack.Free;
  FSubrs.Free;
  FGlobalSubrs.Free;
  FCharStringNames.Free;
  FCharStringValues.Free;
  for X := 0 to FDecodedCharStrings.Count - 1 do
    TQuickPDFStringList(FDecodedCharStrings.Objects[X]).Free;
  FDecodedCharStrings.Free;
  for X := 0 to Length(FCIDSubrs) - 1 do
    FCIDSubrs[X].Free;
  for X := 0 to FCharShapes.Count - 1 do
    FCharShapes.Objects[X].Free;
  FCharShapes.Free;

  inherited;
end;

function TPDFType1Decoder.LoadPFBFromFile(const FileName: WideString): Boolean;
var
  FS: TQuickPDFWideFileStream;
begin
  Result := False;
  if QPLFileExists(FileName) then
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      FS.Seek(0, soFromBeginning);
      Result := LoadPFBFromStream(FS);
    finally
      FS.Free;
    end;
  except
  end;
end;

function TPDFType1Decoder.LoadPFBFromStream(Stream: TStream): Boolean;
var
  B: Byte;
  T: Byte;
  S: AnsiString;
  Len: Integer;
  Portion: Integer;
begin
  Result := True;
  Portion := 0;
  repeat
    if Stream.Read(B, 1) <> 1 then Result := False;
    if B = 128 then
    begin
      Inc(Portion);
      if Stream.Read(T, SizeOf(Byte)) <> 1 then Result := False;
      if (T = 1) or (T = 2) then
      begin
        if Stream.Read(Len, 4) <> 4 then Result := False;
        SetLength(S, Len);
        if Stream.Read(S[1], Len) <> Len then Result := False;
        if Portion = 1 then FClearTextPortion := S;
        if Portion = 2 then FEncryptedPortion := S;
        if Portion = 3 then FFixedContentPortion := S;
      end;
    end else
      Result := False;
  until (not Result) or (T = 3);
end;

function TPDFType1Decoder.LoadPFBFromPDFStream(
  Stream: TPDFStream): Boolean;
var
  Length1: Integer;
  Length2: Integer;
  Length3: Integer;
  Obj: TPDFObject;
  S: AnsiString;
begin
  Result := False;
  Length1 := 0;
  Length2 := 0;
  Length3 := 0;
  S := Stream.Dictionary.Output;
  Obj := Stream.Dictionary.FindValueByKeyName('Length1');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFNumeric then Length1 := TPDFNumeric(Obj).AsInteger;
  Obj := Stream.Dictionary.FindValueByKeyName('Length2');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFNumeric then Length2 := TPDFNumeric(Obj).AsInteger;
  Obj := Stream.Dictionary.FindValueByKeyName('Length3');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFNumeric then Length3 := TPDFNumeric(Obj).AsInteger;
  S := Stream.GetDecodedStream;
  if (Length1 > 0) and (Length2 > 0) {and (Length3 > 0)} then
  begin
    Result := True;
    FClearTextPortion := QPLCopy(S, 1, Length1);
    FEncryptedPortion := QPLCopy(S, Length1 + 1, Length2);
    FFixedContentPortion := QPLCopy(S, Length1 + Length2 + 1, Length3);
    if Length(FClearTextPortion) <> Length1 then Result := False;
    if Length(FEncryptedPortion) <> Length2 then Result := False;
    if Length(FFixedContentPortion) <> Length3 then Result := False;
  end;
end;

function IsRD(const AStr: AnsiString; const ACustom: AnsiString): Boolean;
begin
  Result := (AStr = '-|') or (AStr = '/-|') or (AStr = 'RD') or (AStr = '/RD') or (AStr = '/ps:RD');
  if (not Result) and (ACustom <> '') then
    Result := AStr = ACustom;
end;

function IsND(const AStr: AnsiString; const ACustom: AnsiString): Boolean;
begin
  Result := (AStr = '|-') or (AStr = '/|-') or (AStr = 'ND') or (AStr = '/ND') or (AStr='/ps:ND');
  if (not Result) and (ACustom <> '') then
    Result := AStr = ACustom;
end;

procedure TPDFType1Decoder.Tokenize(const Source: AnsiString; Output: TQuickPDFStringList);
var
  L: Integer;
  X: Integer;
  Tok: AnsiString;
  RD: AnsiString;
  ND: AnsiString;
  NP: AnsiString;
  InPrivate: Boolean;
  InSubrs: Boolean;
  InCharStrings: Boolean;
  LastPrivateName: AnsiString;
  LastSubrsTok: AnsiString;
  LastCharStringsTok: AnsiString;  
  InPrivateDefine: Boolean;
  RDLen: Integer;
  SkipTok: Boolean;
  SubrN: Integer;
  DupN: AnsiString;
  SubrCount: Integer;

  function IsWhitespace(C: AnsiChar): Boolean;
  begin
    Result := (C = #32) or (C = #10) or (C = #13) or (C = #9) or
      (C = #12) or (C = #0);
  end;

  function IsDelimiter(C: AnsiChar): Boolean;
  begin
    Result := (C = '(') or (C = ')') or (C = '<') or (C = '>') or
      (C = '[') or (C = ']') or (C = '/') or (C = '%') or (C = '{') or (C = '}');
  end;

  function IsNumeric(C: AnsiChar): Boolean;
  begin
    Result := ((C >= '0') and (C <= '9'));
  end;

  procedure SkipWhitespace;
  begin
    while (X < L) and IsWhitespace(Source[X]) do Inc(X);
    if (X < L) and (Source[X] = '%') then
    begin
      while (X < L) and (Source[X] <> #10) and (Source[X] <> #13) do Inc(X);
      if (Source[X] = #13) and (Source[X + 1] = #10) then
        Inc(X, 2)
      else
        Inc(X);
      SkipWhiteSpace;
    end;
  end;

  function GetToken: AnsiString;
  var
    C: AnsiChar;
    P: Integer;
    DC: Integer;
    BC: Integer;

    function ValidOperator(const Op: AnsiString): Boolean;
    var
      OL: Integer;
    begin
      Result := False;
      OL := Length(Op);
      if (((L - X) = (OL - 1)) and (QPLCopy(Source, X, OL) = Op)) or
        (((L - X) > (OL - 1)) and (QPLCopy(Source, X, OL) = Op) and
        (IsWhitespace(Source[X + OL]) or IsDelimiter(Source[X + OL]))) then
      begin
        Result := True;
        X := X + OL;
      end;
    end;

  begin
    Result := '';
    repeat
      SkipWhitespace;
    until (X > L) or ((Source[X] <> '%') and (not IsWhitespace(Source[X]))) or
      ((X = L) and (IsWhitespace(Source[X]) or (Source[X] = '%'))); //FB21076

    if X <= L then
    begin
      if (Source[X] = '[') or (Source[X] = ']') or (Source[X] = '{') or (Source[X] = '}') then
      begin
        Result := Source[X];
        Inc(X);
      end else
      if ValidOperator(RD) then Result := RD else
      if ValidOperator(ND) then Result := ND else
      if ValidOperator(NP) then Result := NP else
      if (Source[X] = '-') or (Source[X] = '.') or IsNumeric(Source[X]) then
      begin
        P := X + 1;
        if Source[X] = '.' then DC := 1 else DC := 0;
        while (P <= L) and (((DC = 0) and (Source[P] = '.')) or IsNumeric(Source[P])) do
        begin
          if Source[P] = '.' then Inc(DC);
          Inc(P);
        end;
        Result := QPLCopy(Source, X, P - X);
        X := P;
      end else
      if Source[X] = '(' then
      begin
        P := X;
        BC := 1;
        while (P <= L) and (BC > 0) do
        begin
          Inc(P);
          if Source[P] = '(' then Inc(BC) else
          if Source[P] = ')' then Dec(BC) else
          if (Source[P] = '\') and (P < (L - 1)) then
          begin
            C := Source[P + 1];
            if (C = '(') or (C = ')') or (C = '\') then Inc(P);
          end;
        end;
        if BC = 0 then
        begin
          Result := QPLCopy(Source, X, P - X + 1);
          X := P + 1;
        end;
      end else

      if ((L - X) > 1) and (Source[X] = '<') then
      begin
        P := X;
        while (P < L) and (Source[P] <> '>') do Inc(P);
        Result := QPLCopy(Source, X + 1, P - X - 1);
        X := P + 1;
      end else

      if (Source[X] = '/') then
      begin
        P := X + 1;
        while (P <= L) and (not IsWhitespace(Source[P])) and
          (not IsDelimiter(Source[P])) do Inc(P);
        Result := '/' + QPLCopy(Source, X + 1, P - X - 1);
        X := P;
      end else

      if ((Source[X] >= 'a') and (Source[X] <= 'z')) or
        ((Source[X] >= 'A') and (Source[X] <= 'Z')) then
      begin
        P := X;
        while (P <= L) and (not IsWhitespace(Source[P])) and (not IsDelimiter(Source[P])) do
          Inc(P);
        Result := '/ps:' + QPLCopy(Source, X, P - X);
        X := P;
      end;
    end;
  end;

begin
  Output.Clear;
  SubrCount := 0;
  L := Length(Source);
  if L > 0 then
  begin
    InPrivate := False;
    InSubrs := False;
    InCharStrings := False;
    LastPrivateName := '';
    InPrivateDefine := False;
    RD := 'RD';
    ND := 'ND';
    NP := 'NP';
    X := 1;
    repeat
      Tok := GetToken;
      SkipTok := False;
      if Tok = '/Private' then InPrivate := True;
      if Tok = '/Subrs' then
      begin
        InSubrs := True;
        InCharStrings := False;
        SubrCount := QPLStrToIntDef(GetToken, 0);
      end;
      if Tok = '/CharStrings' then
      begin
        InCharStrings := True;
        InSubrs := False;
      end;
      if InPrivate then
      begin
        if (QPLCopy(Tok, 1, 1) = '/') and (QPLCopy(Tok, 1, 4) <> '/ps:') then
          LastPrivateName := QPLCopy(Tok, 2, MaxInt);
        if Tok = '{' then InPrivateDefine := True;
        if Tok = '}' then InPrivateDefine := False;
        if (Tok = '/ps:readstring') and InPrivateDefine then
          RD := LastPrivateName;
        if (Tok = '/ps:def') and InPrivateDefine then
          ND := LastPrivateName;
        if (Tok = '/ps:put') and InPrivateDefine then
        begin
          NP := LastPrivateName;
          InPrivate := False;
        end;
      end;
      if InSubrs then
      begin
        if (Tok = '/ps:dup') then
        begin
          DupN := GetToken;
        end;
        if IsRD(Tok, RD) then
        begin
          RDLen := QPLStrToIntDef(LastSubrsTok, 0);
          Inc(X);
          SubrN := QPLStrToIntDef(DupN, FSubrs.Count);
          FSubrs.AddObject(QPLCopy(Source, X, RDLen), TObject(SubrN));
          Inc(X, RDLen);
          SkipTok := True;
          if ((SubrCount > 0) and (FSubrs.Count = SubrCount)) then
          begin
            InSubrs := False;
          end;
        end;
        if IsND(Tok, ND) then InSubrs := False;
        LastSubrsTok := Tok;
      end;
      if InCharStrings then
      begin
        if IsRD(Tok, RD) then
        begin
          Output.Add(Tok);
          RDLen := QPLStrToIntDef(LastCharStringsTok, 0);
          Inc(X);
          Output.Add(QPLCopy(Source, X, RDLen));
          Inc(X, RDLen);
          SkipTok := True;
        end;
        if Tok = 'end' then InCharStrings := False;
        LastCharStringsTok := Tok;
      end;
      if Tok = ']' then
      begin
        Tok := ']';
      end;
      if Tok = '' then SkipTok := True;
      if not SkipTok then Output.Add(Tok);
    until Tok = '';
  end;
  FRD := RD;
  FND := ND;
  FNP := NP;
end;

function TPDFType1Decoder.Decrypt(R, N: Word;
  CipherText: AnsiString): AnsiString;
var
  T: Byte;
  X: Cardinal;
  C: Byte;
  P: Byte;
  Start: Cardinal;
  RC: Cardinal;
const
  C1: Cardinal = 52845;
  C2: Cardinal = 22719;
begin
  Start := QPLPos('eexec', CipherText);
  if Start > 0 then
    Start := Start + 6
  else
    Start := 1;

  for X := Start to Length(CipherText) do
  begin
    C := Ord(CipherText[X]);
    T := R shr 8;
    P := C xor T;
    if (X - Start) >= N then Result := Result + AnsiChar(P);
    RC := C;
    Inc(RC, R);
    RC := RC * C1;
    Inc(RC, C2);
    R := RC and $FFFF;
  end;
end;

function TPDFType1Decoder.DecodeEncryptedPortion: Boolean;
var
  EP: AnsiString;
  SL: TQuickPDFStringList;
  X: Integer;
  CharStringsP: Integer;
  CharStringsC: Integer;
begin
  Result := False;
  EP := Decrypt(55665, 4, FEncryptedPortion);
  SL := TQuickPDFStringList.Create;
  try
    Tokenize(EP, SL);
    X := SL.IndexOf('/lenIV');

    if X >= 0 then
      FLenIV := QPLStrToIntDef(SL[X + 1], 4)
    else
      FLenIV := 4;

    CharStringsP := SL.IndexOf('/CharStrings');
    if CharStringsP > 0 then
    begin
      FCharStringNames.Clear;
      FCharStringValues.Clear;
      CharStringsC := QPLStrToIntDef(SL[CharStringsP + 1], 0);
      X := CharStringsP;
      repeat
        Inc(X);
        if IsRD(SL[X], FRD) then
        begin
          FCharStringNames.Add(QPLCopy(SL[X - 2], 2, MaxInt));
          FCharStringValues.Add(SL[X + 1]);
          Dec(CharStringsC);
        end;
      until (X >= (SL.Count - 2)) or (CharStringsC = 0);
      Result := True;
    end;
  finally
    SL.Free;
  end;
end;

function TPDFType1Decoder.DecodeCharstring(const Name: AnsiString): Boolean;
var
  I: Integer;
  SL: TQuickPDFStringList;
begin
  I := FDecodedCharStrings.IndexOf(Name);
  if I >= 0 then
  begin
    FCharStack.Clear;
    FCharStack.AddStrings(TQuickPDFStringList(FDecodedCharStrings.Objects[I]));
    Result := True;
  end else
  begin
    if FCharStringType = 2 then
      Result := DecodeType2Charstring(Name)
    else
      Result := DecodeType1Charstring(Name);
    SL := TQuickPDFStringList.Create;
    SL.AddStrings(FCharStack);
    FDecodedCharStrings.AddObject(Name, SL);
  end;
end;

function TPDFType1Decoder.DecodeType1Charstring(const Name: AnsiString): Boolean;
var
  MCS: AnsiString;
  Stack: TQuickPDFStringList;
  ActiveFlex: Boolean;
  FlexN: Integer;
  FlexX: array[0..6] of AnsiString;
  FlexY: array[0..6] of AnsiString;
  PSStack: TQuickPDFStringList;
  CallDepth: Integer;

  function Pop: AnsiString;
  begin
    if Stack.Count > 0 then
    begin
      Result := Stack[Stack.Count - 1];
      Stack.Delete(Stack.Count - 1);
    end else
      Result := '';
  end;

  procedure Proc_div;
  var
    Num1, Num2: Double;
    Q: Double;
  begin
    TazzToFloatVar(Pop, Num2);
    TazzToFloatVar(Pop, Num1);
    if Num2 = 0 then Q := 0 else
      Q := Num1 / Num2;
    Stack.Add(QPLDoubleToStr(Q, 6));
  end;

  procedure Proc_hstem;
  var
    Y, DY: AnsiString;
  begin
    DY := Pop;
    Y := Pop;
    Stack.Add('hstem(' + Y + ',' + DY + ')');
  end;

  procedure Proc_vstem;
  var
    X, DX: AnsiString;
  begin
    DX := Pop;
    X := Pop;
    Stack.Add('vstem(' + X + ',' + DX + ')');
  end;

  procedure Proc_hsbw;
  var
    SBX, WX: AnsiString;
  begin
    WX := Pop;
    SBX := Pop;
    Stack.Add('hsbw(' + SBX + ',' + WX + ')');
  end;

  procedure Proc_sbw;
  var
    SBX, SBY, WX, WY: AnsiString;
  begin
    WY := Pop;
    WX := Pop;
    SBY := Pop;
    SBX := Pop;
    Stack.Add('sbw(' + SBX + ',' + SBY + ',' + WX + ',' + WY + ')');
  end;

  procedure Proc_rmoveto;
  var
    DX, DY: AnsiString;
  begin
    DY := Pop;
    DX := Pop;
    if ActiveFlex and (FlexN >= 0) and (FlexN < 7) then
    begin
      FlexX[FlexN] := DX;
      FlexY[FlexN] := DY;
    end else
      Stack.Add('rmoveto(' + DX + ',' + DY + ')');
  end;

  procedure Proc_hmoveto;
  begin
    Stack.Add('0');
    Proc_rmoveto;
  end;

  procedure Proc_vmoveto;
  var
    DY: AnsiString;
  begin
    DY := Pop;
    Stack.Add('0');
    Stack.Add(DY);
    Proc_rmoveto;
  end;

  procedure Proc_rlineto;
  var
    DX, DY: AnsiString;
  begin
    DY := Pop;
    DX := Pop;
    Stack.Add('rlineto(' + DX + ',' + DY + ')');
  end;

  procedure Proc_vlineto;
  var
    DY: AnsiString;
  begin
    DY := Pop;
    Stack.Add('rlineto(0,' + DY + ')');
  end;

  procedure Proc_hlineto;
  var
    DX: AnsiString;
  begin
    DX := Pop;
    Stack.Add('rlineto(' + DX + ',0)');
  end;

  procedure Proc_rrcurveto;
  var
    DX1, DY1, DX2, DY2, DX3, DY3: AnsiString;
  begin
    DY3 := Pop;
    DX3 := Pop;
    DY2 := Pop;
    DX2 := Pop;
    DY1 := Pop;
    DX1 := Pop;
    Stack.Add('rrcurveto(' + DX1 + ',' + DY1 + ',' + DX2 + ',' + DY2 + ',' +
      DX3 + ',' + DY3 + ') rr');
  end;

  procedure Proc_vhcurveto;
  var
    DY1, DX2, DY2, DX3: AnsiString;
  begin
    DX3 := Pop;
    DY2 := Pop;
    DX2 := Pop;
    DY1 := Pop;
    Stack.Add('rrcurveto(0,' + DY1 + ',' + DX2 + ',' + DY2 + ',' + DX3 + ',0) vh');
  end;

  procedure Proc_hvcurveto;
  var
    DX1, DX2, DY2, DY3: AnsiString;
  begin
    DY3 := Pop;
    DY2 := Pop;
    DX2 := Pop;
    DX1 := Pop;
    Stack.Add('rrcurveto(' + DX1 + ',0,' + DX2 + ',' + DY2 + ',0,' + DY3 + ') hv');
  end;

  procedure Proc_callothersubr;
  var
    OtherSubr: Integer;
    LastX, LastY: AnsiString;
  begin
    OtherSubr := QPLStrToIntDef(Pop, 0);
    Pop;  
    case OtherSubr of
      0:
      begin
        LastY := Pop;
        LastX := Pop;
        Pop;        
        if FlexN = 7 then
        begin
          Stack.Add('flex(' +
            FlexX[0] + ',' + FlexY[0] + ',' +
            FlexX[1] + ',' + FlexY[1] + ',' +
            FlexX[2] + ',' + FlexY[2] + ',' +
            FlexX[3] + ',' + FlexY[3] + ',' +
            FlexX[4] + ',' + FlexY[4] + ',' +
            FlexX[5] + ',' + FlexY[5] + ',' +
            FlexX[6] + ',' + FlexY[6] + ')');
        end;
        ActiveFlex := False;
        FlexN := 0;
        PSStack.Add(LastY);
        PSStack.Add(LastX);                
      end;

      1:
      begin
        ActiveFlex := True;
        FlexN := 0;
      end;

      2: Inc(FlexN);

      3:
      begin
        PSStack.Add('3');
      end;
    end;
  end;

  procedure Proc_pop;
  begin
    if PSStack.Count > 0 then
    begin
      Stack.Add(PSStack[PSStack.Count - 1]);
      PSStack.Delete(PSStack.Count - 1);
    end else
      Stack.Add('0');
  end;

  procedure Proc_setcurrentpoint;
  var
    X, Y: AnsiString;
  begin
    Y := Pop;
    X := Pop;
    Stack.Add('setcurrentpoint(' + X + ',' + Y + ')');
  end;

  procedure Decode(const CS: AnsiString);
  var
    L: Integer;
    X: Integer;
    V: Byte;
    W: Byte;
    C: Cardinal;
    I: Integer;
    ACharString: AnsiString;
    BCharString: AnsiString;

    procedure Proc_seac;
    var
      ADX: AnsiString;
      ADY: AnsiString;
      BChar: Integer;
      AChar: Integer;
      BName: AnsiString;
      AName: AnsiString;
      ASB: AnsiString;
      I: Integer;
    begin
      AChar := QPLStrToIntDef(Pop, 0);
      BChar := QPLStrToIntDef(Pop, 0);
      ADY := Pop;
      ADX := Pop;
      ASB := Pop;
      I := QPLPos('*' + QPLIntToStr(AChar) + '|', StandardEncoding);
      AName := '';
      if I > 0 then
      begin
        AName := QPLCopy(StandardEncoding, I - 100, 100);
        if Length(AName) > 0 then
        begin
          I := Length(AName);
          repeat
            Dec(I);
          until (AName[I] = '|') or (I = 1);
          AName := QPLCopy(AName, I + 1, MaxInt);
        end;
      end;
      I := QPLPos('*' + QPLIntToStr(BChar) + '|', StandardEncoding);
      BName := '';
      if I > 0 then
      begin
        BName := QPLCopy(StandardEncoding, I - 100, 100);
        if Length(BName) > 0 then
        begin
          I := Length(BName);
          repeat
            Dec(I);
          until (BName[I] = '|') or (I = 1);
          BName := QPLCopy(BName, I + 1, MaxInt);
        end;
      end;
      if (AName <> '') and (BName <> '') then
      begin
        ACharString := GetCharString(AName);
        ACharString := Decrypt(4330, FLenIV, ACharString);
        BCharString := GetCharString(BName);
        BCharString := Decrypt(4330, FLenIV, BCharString);
        Decode(BCharString);
        Stack.Add('seac(' + ASB + ',' + ADX + ',' + ADY + ')');
        Decode(ACharString);
      end;
    end;

  begin
    Inc(CallDepth);
    if (CallDepth < QPLType1MaxCallDepth) then
    begin
      X := 0;
      L := Length(CS);
      if L > 0 then
      repeat
        Inc(X);
        V := Ord(CS[X]);
        if (V >= 32) and (V <= 246) then
          Stack.Add(QPLIntToStr(V - 139));
        if (V >= 247) and (V <= 250) and (X < L) then
        begin
          W := Ord(CS[X + 1]);
          Stack.Add(QPLIntToStr((V - 247) * 256 + W + 108));
          Inc(X);
        end;
        if (V >= 251) and (V <= 254) and (X < L) then
        begin
          W := Ord(CS[X + 1]);
          Stack.Add(QPLIntToStr((V - 251) * -256 - W - 108));
          Inc(X);
        end;
        if (V = 255) and (X < (L - 3)) then
        begin
          C := Ord(CS[X + 1]) shl 24 +
            Ord(CS[X + 2]) shl 16 +
            Ord(CS[X + 3]) shl 8 +
            Ord(CS[X + 4]);
          I := Integer(C);
          Stack.Add(QPLIntToStr(I));
          Inc(X, 4);
        end;
        if (V < 32) then
        begin
          case V of
            1: Proc_hstem;
            3: Proc_vstem;
            4: Proc_vmoveto;
            5: Proc_rlineto;
            6: Proc_hlineto;
            7: Proc_vlineto;
            8: Proc_rrcurveto;
            9: Stack.Add('closepath');
            10:
            begin
              I := QPLStrToIntDef(Stack[Stack.Count - 1], 0);
              Stack.Delete(Stack.Count - 1);
              Decode(GetSubr(I));
            end;
            12:
            begin
              W := Ord(CS[X + 1]);
              case W of
                0: Stack.Add('dotsection');
                1: Stack.Add('vstem3');
                2: Stack.Add('hstem3');
                6: Proc_seac;
                7: Proc_sbw;
                12: Proc_div;
                16: Proc_callothersubr;
                17: Proc_pop;
                33: Proc_setcurrentpoint;
              end;
              Inc(X);
            end;
            13: Proc_hsbw;
            14: Stack.Add('endchar');
            21: Proc_rmoveto;
            22: Proc_hmoveto;
            30: Proc_vhcurveto;
            31: Proc_hvcurveto;
          end;
        end;
      until X = L;
    end;
    Dec(CallDepth);
  end;

begin
  CallDepth := 0;
  FCharStack.Clear;
  Result := False;
  MCS := GetCharString(Name);
  MCS := Decrypt(4330, FLenIV, MCS);
  if Length(MCS) > 0 then
  begin
    Stack := FCharStack;
    PSStack := TQuickPDFStringList.Create;
    try
      Result := True;
      ActiveFlex := False;
      Decode(MCS);
    finally
      PSStack.Free;
    end;
  end;
end;

type
  THintStack = record
    FirstClear: Boolean;
    HintCount: Integer;
  end;

function TPDFType1Decoder.DecodeType2Charstring(const Name: AnsiString): Boolean;
var
  MCS: AnsiString;
  Stack: TQuickPDFStringList;
  PSStack: TQuickPDFStringList;
  Transient: array[0..32] of AnsiString;
  V28: Smallint;
  W28: Word;
  CW: AnsiString;
  HintStack: array of THintStack;
  HintPointer: Integer;
  OutStack: TQuickPDFStringList;

  function Pop: AnsiString;
  begin
    if Stack.Count > 0 then
    begin
      Result := Stack[Stack.Count - 1];
      Stack.Delete(Stack.Count - 1);
    end else
      Result := '';
  end;

  function PopTop: AnsiString;
  begin
    if Stack.Count > 0 then
    begin
      Result := Stack[0];
      Stack.Delete(0);
    end else
      Result := '';
  end;

  // Arithmetic Operators

  procedure Proc_abs;
  var
    Num1: Double;
  begin
    TazzToFloatVar(Pop, Num1);
    Num1 := Abs(Num1);
    Stack.Add(QPLDoubleToStr(Num1, 6));
  end;

  procedure Proc_add;
  var
    Num1, Num2: Double;
    R: Double;
  begin
    TazzToFloatVar(Pop, Num2);
    TazzToFloatVar(Pop, Num1);
    R := Num1 + Num2;
    Stack.Add(QPLDoubleToStr(R, 6));
  end;

  procedure Proc_sub;
  var
    Num1, Num2: Double;
    R: Double;
  begin
    TazzToFloatVar(Pop, Num2);
    TazzToFloatVar(Pop, Num1);
    R := Num1 - Num2;
    Stack.Add(QPLDoubleToStr(R, 6));
  end;

  procedure Proc_div;
  var
    Num1, Num2: Double;
    Q: Double;
  begin
    TazzToFloatVar(Pop, Num2);
    TazzToFloatVar(Pop, Num1);
    if Num2 = 0 then Q := 0 else
      Q := Num1 / Num2;
    Stack.Add(QPLDoubleToStr(Q, 6));
  end;

  procedure Proc_neg;
  var
    Num1: Double;
  begin
    TazzToFloatVar(Pop, Num1);
    Num1 := -Num1;
    Stack.Add(QPLDoubleToStr(Num1, 6));
  end;

  procedure Proc_random;
  var
    Num2: Double;
  begin
    Num2 := Random;
    if Num2 = 0 then Num2 := 1;
    Stack.Add(QPLDoubleToStr(Num2, 6));
  end;

  procedure Proc_mul;
  var
    Num1, Num2: Double;
    M: Double;
  begin
    TazzToFloatVar(Pop, Num2);
    TazzToFloatVar(Pop, Num1);
    M := Num1 * Num2;
    Stack.Add(QPLDoubleToStr(M, 6));
  end;

  procedure Proc_sqrt;
  var
    Num1: Double;
    S: Double;
  begin
    TazzToFloatVar(Pop, Num1);
    if Num1 >= 0 then
      S := Sqrt(Num1)
    else
      S := 0;
    Stack.Add(QPLDoubleToStr(S, 6));
  end;

  procedure Proc_drop;
  begin
    Pop;
  end;

  procedure Proc_exch;
  var
    Num1, Num2: AnsiString;
  begin
    Num2 := Pop;
    Num1 := Pop;
    Stack.Add(Num2);
    Stack.Add(Num1);
  end;

  procedure Proc_dup;
  var
    Num1: AnsiString;
  begin
    Num1 := Pop;
    Stack.Add(Num1);
    Stack.Add(Num1);
  end;

  procedure Proc_index;
  var
    I: Integer;
  begin
    I := QPLStrToIntDef(Pop, -1);
    if I < 0 then I := 1;
    if I > Stack.Count then Stack.Add('') else
      Stack.Add(Stack[Stack.Count - I]);
  end;

  procedure Proc_roll;
  var
    J: Integer;
    N: Integer;
    X: Integer;
    S: AnsiString;
  begin
    J := QPLStrToIntDef(Pop, -1);
    N := QPLStrToIntDef(Pop, -1);
    if (Stack.Count > 1) and (N > 0) then
    begin
      if J < 0 then
      begin
        for X := 1 to Abs(J) do
        begin
          S := Stack[Stack.Count - N - 1];
          Stack.Delete(Stack.Count - N - 1);
          Stack.Add(S);
        end;
      end else
      if J > 0 then
      begin
        S := Pop;
        Stack.Insert(Stack.Count - N - 1, S);
      end;
    end;
  end;

  // Conditional Operators

  procedure Proc_and;
  var
    Num1, Num2: Double;
    R: AnsiString;
  begin
    TazzToFloatVar(Pop, Num2);
    TazzToFloatVar(Pop, Num1);
    if (Num1 <> 0) and (Num2 <> 0) then R := '1' else R := '0';
    Stack.Add(R);
  end;

  procedure Proc_or;
  var
    Num1, Num2: Double;
    R: AnsiString;
  begin
    TazzToFloatVar(Pop, Num2);
    TazzToFloatVar(Pop, Num1);
    if (Num1 <> 0) or (Num2 <> 0) then R := '1' else R := '0';
    Stack.Add(R);
  end;

  procedure Proc_not;
  var
    Num1: Double;
    R: AnsiString;
  begin
    TazzToFloatVar(Pop, Num1);
    if (Num1 <> 0) then R := '0' else R := '1';
    Stack.Add(R);
  end;

  procedure Proc_eq;
  var
    Num1, Num2: Double;
    R: AnsiString;
  begin
    TazzToFloatVar(Pop, Num2);
    TazzToFloatVar(Pop, Num1);
    if (Num1 = Num2) then R := '1' else R := '0';
    Stack.Add(R);
  end;

  procedure Proc_ifelse;
  var
    S1, S2: AnsiString;
    V1, V2: Double;
    R: AnsiString;
  begin
    TazzToFloatVar(Pop, V2);
    TazzToFloatVar(Pop, V1);
    S2 := Pop;
    S1 := Pop;
    if (V1 <= V2) then R := S1 else R := S2;
    Stack.Add(R);
  end;

  // Storage operators
  procedure Proc_put;
  var
    I: Integer;
    Val: AnsiString;
  begin
    I := QPLStrToIntDef(Pop, -1);
    Val := Pop;
    if (I >= 0) and (I <= 32) then
      Transient[I] := Val;
  end;

  procedure Proc_get;
  var
    I: Integer;
    Val: AnsiString;
  begin
    I := QPLStrToIntDef(Pop, -1);
    if (I >= 0) and (I <= 32) then
    begin
      Val := Transient[I];
      Stack.Add(Val);
    end;
  end;

  // Hint operators

  procedure Proc_hstem;
  var
    Y, DY: AnsiString;
    DYA, DYB: AnsiString;
    S: AnsiString;
  begin
    if HintStack[HintPointer].FirstClear and (Stack.Count mod 2 = 1) then
    begin
      CW := PopTop;
      HintStack[HintPointer].FirstClear := False;
    end;
    S := '';
    while Stack.Count > 3 do
    begin
      Inc(HintStack[HintPointer].HintCount);
      DYB := Pop;
      DYA := Pop;
      S := ',' + DYA + ',' + DYB + S;
    end;
    Inc(HintStack[HintPointer].HintCount);
    DY := Pop;
    Y := Pop;
    S := Y + ',' + DY + S;
    if QPLCopy(S, Length(S), 1) = ',' then Delete(S, Length(S), 1);
    Stack.Clear;
    OutStack.Add('hstem' + '(' + S + ')');
  end;

  procedure Proc_vstem;
  var
    X, DX: AnsiString;
    DXA, DXB: AnsiString;
    S: AnsiString;
  begin
    if HintStack[HintPointer].FirstClear and (Stack.Count mod 2 = 1) then
    begin
      CW := PopTop;
      HintStack[HintPointer].FirstClear := False;
    end;
    S := '';
    while Stack.Count > 3 do
    begin
      Inc(HintStack[HintPointer].HintCount);
      DXB := Pop;
      DXA := Pop;
      S := ',' + DXA + ',' + DXB + S;
    end;
    Inc(HintStack[HintPointer].HintCount);
    DX := Pop;
    X := Pop;
    S := X + ',' + DX + S;
    if QPLCopy(S, Length(S), 1) = ',' then Delete(S, Length(S), 1);
    Stack.Clear;
    OutStack.Add('vstem' + '(' + S + ')');
  end;

  function Proc_hintmask(const HM: AnsiString): Integer;
  var
    S: AnsiString;
    I: Integer;
    MaskByte: Integer;
  const
    MaskBits: array[0..7] of Byte = (128, 64, 32, 16, 8, 4, 2, 1);
  begin
    if Stack.Count > 0 then Proc_vstem;
    if HintStack[HintPointer].HintCount > 0 then
    begin
      Result := (HintStack[HintPointer].HintCount - 1) div 8 + 1;
      for I := 1 to HintStack[HintPointer].HintCount do
      begin
        MaskByte := (I - 1) div 8 + 1;
        if MaskByte < Length(HM) then
          MaskByte := Ord(HM[MaskByte])
        else
          MaskByte := 0;
        if MaskByte and MaskBits[(I - 1) mod 8] = MaskBits[(I - 1) mod 8] then
          S := S + '1,'
        else
          S := S + '0,';
      end;
    end else
    begin
      S := '';
      Result := 0;
    end;

    // Always advance at least 1
    if Result = 0 then Result := 1;

    if QPLCopy(S, Length(S), 1) = ',' then Delete(S, Length(S), 1);
    Stack.Clear;
    OutStack.Add('hintmask' + '(' + S + ')');
  end;

  function Proc_cntrmask(const HM: AnsiString): Integer;
  var
    S: AnsiString;
    I: Integer;
    MaskByte: Integer;
  const
    MaskBits: array[0..7] of Byte = (128, 64, 32, 16, 8, 4, 2, 1);
  begin
    if Stack.Count > 0 then
      Proc_vstem;
    if HintStack[HintPointer].HintCount > 0 then
    begin
      Result := (HintStack[HintPointer].HintCount - 1) div 8 + 1;
      for I := 1 to HintStack[HintPointer].HintCount do
      begin
        MaskByte := (I - 1) div 8 + 1;
        if MaskByte < Length(HM) then
          MaskByte := Ord(HM[MaskByte])
        else
          MaskByte := 0;
        if MaskByte and MaskBits[(I - 1) mod 8] = MaskBits[(I - 1) mod 8] then
          S := S + '1,'
        else
          S := S + '0,';
      end;
    end else
    begin
      S := '';
      Result := 0;
    end;
    if QPLCopy(S, Length(S), 1) = ',' then Delete(S, Length(S), 1);
    Stack.Clear;
    OutStack.Add('cntrmask' + '(' + S + ')');
  end;

  // Path construction operators

  procedure Proc_rmoveto;
  begin
    if HintStack[HintPointer].FirstClear and (Stack.Count mod 2 = 1) then
    begin
      CW := PopTop;
      HintStack[HintPointer].FirstClear := False;
    end else
    if (Stack.Count mod 2 = 1) then PopTop;
    OutStack.Add('rmoveto(' + PopTop + ',' + PopTop + ')');
    Stack.Clear;
  end;

  procedure Proc_hmoveto;
  begin
    if HintStack[HintPointer].FirstClear and (Stack.Count mod 2 = 0) then
    begin
      CW := PopTop;
      HintStack[HintPointer].FirstClear := False;
    end;
    OutStack.Add('rmoveto(' + PopTop + ',0)');
    Stack.Clear;
  end;

  procedure Proc_vmoveto;
  begin
    if HintStack[HintPointer].FirstClear and (Stack.Count mod 2 = 0) then
    begin
      CW := PopTop;
      HintStack[HintPointer].FirstClear := False;
    end;
    OutStack.Add('rmoveto(0, ' + PopTop + ')');
    Stack.Clear;
  end;

  procedure Proc_rlineto;
  begin
    while Stack.Count >= 2 do
      OutStack.Add('rlineto(' + PopTop + ',' + PopTop + ')');
    Stack.Clear;
  end;

  procedure Proc_vlineto;
  var
    DY1: AnsiString;
    DXA: AnsiString;
    DXB: AnsiString;
    DYA: AnsiString;
    DYB: AnsiString;
  begin
    if Stack.Count mod 2 = 1 then
    begin
      DY1 := PopTop;
      OutStack.Add('rlineto(0,' + DY1 + ')');
      while Stack.Count > 0 do
      begin
        DXA := PopTop;
        OutStack.Add('rlineto(' + DXA + ',0)');
        DYB := PopTop;
        OutStack.Add('rlineto(0,' + DYB + ')');
      end;
    end else
    begin
      while Stack.Count > 0 do
      begin
        DYA := PopTop;
        OutStack.Add('rlineto(0,' + DYA + ')');
        DXB := PopTop;
        OutStack.Add('rlineto(' + DXB + ',0)');
      end;
    end;
  end;

  procedure Proc_hlineto;
  var
    DX1: AnsiString;
    DXA: AnsiString;
    DXB: AnsiString;
    DYA: AnsiString;
    DYB: AnsiString;
  begin
    if Stack.Count mod 2 = 1 then
    begin
      DX1 := PopTop;
      OutStack.Add('rlineto(' + DX1 + ',0)');
      while Stack.Count > 0 do
      begin
        DYA := PopTop;
        OutStack.Add('rlineto(0,' + DYA + ')');
        DXB := PopTop;
        OutStack.Add('rlineto(' + DXB + ',0)');
      end;
    end else
    begin
      while Stack.Count > 0 do
      begin
        DXA := PopTop;
        OutStack.Add('rlineto(' + DXA + ',0)');
        DYB := PopTop;
        OutStack.Add('rlineto(0,' + DYB + ')');
      end;
    end;
  end;

  procedure Proc_rrcurveto;
  begin
    while Stack.Count >= 6 do
      OutStack.Add('rrcurveto(' + PopTop + ',' + PopTop + ',' + PopTop + ',' +
        PopTop + ',' + PopTop + ',' + PopTop + ') rr');    
  end;

  procedure Proc_vhcurveto;
  var
    C: Integer;
    DXF, DYF: AnsiString;
  begin
    C := Stack.Count;
    if ((C - 4) mod 8 = 0) or ((C - 4) mod 8 = 1) then
    begin
      DYF := '0';
      if C = 5 then
        DYF := Pop;
      OutStack.Add('rrcurveto(0,' + PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ',' + DYF + ') vh1');
      while Stack.Count >= 8 do
      begin
        OutStack.Add('rrcurveto(' + PopTop + ',0,' + PopTop + ',' + PopTop + ',0,' + PopTop + ') vh2');
        if Stack.Count = 5 then
          DYF := Pop
        else
          DYF := '0';
        OutStack.Add('rrcurveto(0,' + PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ',' + DYF + ') vh3');
      end;
    end else
    if (C mod 8 = 0) or (C mod 8 = 1) then
    begin
      while Stack.Count >= 8 do
      begin
        OutStack.Add('rrcurveto(0,' + PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ',0) vh4');
        if Stack.Count = 5 then
          DXF := Pop
        else
          DXF := '0';
        OutStack.Add('rrcurveto(' + PopTop + ',0,' + PopTop + ',' + PopTop + ',' + DXF + ',' + PopTop + ') vh5');
      end;
    end;
    Stack.Clear;
  end;

  procedure Proc_hvcurveto;
  var
    C: Integer;
    DXF, DYF: AnsiString;
  begin
    C := Stack.Count;
    if ((C - 4) mod 8 = 0) or ((C - 4) mod 8 = 1) then
    begin
      DXF := '0';
      if C = 5 then DXF := Pop;
      OutStack.Add('rrcurveto(' + PopTop + ',0,' + PopTop + ',' + PopTop + ',' + DXF + ',' + PopTop + ') hv1');
      while Stack.Count >= 8 do
      begin
        OutStack.Add('rrcurveto(0,' + PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ',0) hv2');
        if Stack.Count = 5 then
          DXF := Pop
        else
          DXF := '0';
        OutStack.Add('rrcurveto(' + PopTop + ',0,' + PopTop + ',' + PopTop + ',' + DXF + ',' + PopTop + ') hv3');
      end;
    end else
    if (C mod 8 = 0) or (C mod 8 = 1) then
    begin
      while Stack.Count >= 8 do
      begin
        OutStack.Add('rrcurveto(' + PopTop + ',0,' + PopTop + ',' + PopTop + ',0,' + PopTop + ') hv4');
        if Stack.Count = 5 then
          DYF := Pop
        else
          DYF := '0';
        OutStack.Add('rrcurveto(0,' + PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ',' + DYF + ') hv5');
      end;
    end;
    Stack.Clear;
  end;

  procedure Proc_hflex;
  var
    DX1, DX2, DY2, DX3, DX4, DX5, DX6: AnsiString;
  begin
    DX1 := PopTop;
    DX2 := PopTop;
    DY2 := PopTop;
    DX3 := PopTop;
    DX4 := PopTop;
    DX5 := PopTop;
    DX6 := PopTop;
    OutStack.Add('t2flex(' + DX1 + ',0,' + DX2 + ',' +
      DY2 + ',' + DX3 + ',0,' + DX4 + ',0,' +
      DX5 + ',0,' + DX6 + ',0,50)');
    Stack.Clear;
  end;

  procedure Proc_flex;
  begin
    OutStack.Add('t2flex(' + PopTop + ',' + PopTop + ',' + PopTop + ',' +
      PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ',' +
      PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ',' +
      PopTop + ',' + PopTop + ')');
    Stack.Clear;
  end;

  procedure Proc_hflex1;
  var
    DX1, DY1, DX2, DY2, DX3, DX4, DX5, DY5, DX6: AnsiString;
  begin
    DX1 := PopTop;
    DY1 := PopTop;
    DX2 := PopTop;
    DY2 := PopTop;
    DX3 := PopTop;
    DX4 := PopTop;
    DX5 := PopTop;
    DY5 := PopTop;
    DX6 := PopTop;
    OutStack.Add('t2flex(' + DX1 + ',' + DY1 + ',' + DX2 + ',' +
      DY2 + ',' + DX3 + ',0,' + DX4 + ',0,' +
      DX5 + ',' + DY5 + ',' + DX6 + ',0,50)');
    Stack.Clear;
  end;

  procedure Proc_flex1;
  var
    DX1, DY1, DX2, DY2, DX3, DY3, DX4, DY4, DX5, DY5, D6: AnsiString;
    DX6, DY6: AnsiString;
    DX: Double;
    DY: Double;
  begin
    DX1 := PopTop;
    DY1 := PopTop;
    DX2 := PopTop;
    DY2 := PopTop;
    DX3 := PopTop;
    DY3 := PopTop;
    DX4 := PopTop;
    DY4 := PopTop;
    DX5 := PopTop;
    DY5 := PopTop;
    DX := TazzToFloat(DX1) + TazzToFloat(DX2) + TazzToFloat(DX3) + TazzToFloat(DX4) + TazzToFloat(DX5);
    DY := TazzToFloat(DY1) + TazzToFloat(DY2) + TazzToFloat(DY3) + TazzToFloat(DY4) + TazzToFloat(DY5);
    D6 := PopTop;
    if Abs(DX) > Abs(DY) then
    begin
      DX6 := D6;
      DY6 := '0';
    end else
    begin
      DX6 := '0';
      DY6 := D6;
    end;
    OutStack.Add('t2flex(' + DX1 + ',' + DY1 + ',' + DX2 + ',' +
      DY2 + ',' + DX3 + ',' + DY3 + ',' + DX4 + ',' + DY4 + ',' +
      DX5 + ',' + DY5 + ',' + DX6 + ',' + DY6 + ',50)');
    Stack.Clear;
  end;

  procedure Proc_rcurveline;
  begin
    while Stack.Count >= 8 do
      OutStack.Add('rrcurveto(' + PopTop + ',' + PopTop + ',' +
        PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ')');
    OutStack.Add('rlineto(' + PopTop + ',' + PopTop + ') cl');
    Stack.Clear;
  end;

  procedure Proc_rlinecurve;
  begin
    while Stack.Count >= 8 do
      OutStack.Add('rlineto(' + PopTop + ',' + PopTop + ')');
    OutStack.Add('rrcurveto(' + PopTop + ',' + PopTop + ',' +
      PopTop + ',' + PopTop + ',' + PopTop + ',' + PopTop + ') lc');
    Stack.Clear;
  end;

  procedure Proc_vvcurveto;
  var
    DX1: AnsiString;
  begin
    if Stack.Count mod 2 = 1 then
      DX1 := PopTop
    else
      DX1 := '0';
    while Stack.Count >= 4 do
    begin
      OutStack.Add('rrcurveto(' + DX1 + ',' + PopTop + ',' + PopTop + ',' +
        PopTop + ',0,' + PopTop + ') vv');
      DX1 := '0';
    end;
    Stack.Clear;
  end;

  procedure Proc_hhcurveto;
  var
    DY1: AnsiString;
  begin
    if Stack.Count mod 2 = 1 then
      DY1 := PopTop
    else
      DY1 := '0';
    while Stack.Count >= 4 do
    begin
      OutStack.Add('rrcurveto(' + PopTop + ',' + DY1 + ',' + PopTop + ',' +
        PopTop + ',' + PopTop + ',0) hh');
      DY1 := '0';
    end;
    Stack.Clear;
  end;

  procedure Proc_endchar(var ACS, BCS, ADX, ADY: AnsiString);
  var
    BChar: Integer;
    AChar: Integer;
    BName: AnsiString;
    AName: AnsiString;
    I: Integer;
  begin
    if Stack.Count >= 4 then
    begin
      while Stack.Count >= 5 do
        PopTop; 
      ADX := PopTop;
      ADY := PopTop;
      BChar := QPLStrToIntDef(PopTop, 0);
      AChar := QPLStrToIntDef(PopTop, 0);
      I := QPLPos('*' + QPLIntToStr(AChar) + '|', StandardEncoding);
      AName := '';
      if I > 0 then
      begin
        AName := QPLCopy(StandardEncoding, I - 100, 100);
        if Length(AName) > 0 then
        begin
          I := Length(AName);
          repeat
            Dec(I);
          until (AName[I] = '|') or (I = 1);
          AName := QPLCopy(AName, I + 1, MaxInt);
        end;
      end;
      I := QPLPos('*' + QPLIntToStr(BChar) + '|', StandardEncoding);      
      BName := '';
      if I > 0 then
      begin
        BName := QPLCopy(StandardEncoding, I - 100, 100);
        if Length(BName) > 0 then
        begin
          I := Length(BName);
          repeat
            Dec(I);
          until (BName[I] = '|') or (I = 1);
          BName := QPLCopy(BName, I + 1, MaxInt);
        end;
      end;
      if (AName <> '') and (BName <> '') then
      begin
        ACS := GetCharString(AName);
        BCS := GetCharString(BName);
      end;
    end else
    begin
      ACS := '';
      BCS := '';
    end;
  end;

  procedure Decode(const CS: AnsiString; IsSubroutine: Boolean = False);
  var
    L: Integer;
    X: Integer;
    V: Byte;
    W: Byte;
    C: Cardinal;
    I: Integer;
    WW: Word;
    SI: SmallInt;
    ACharString: AnsiString;
    BCharString: AnsiString;
    ADX: AnsiString;
    ADY: AnsiString;
    D: Double;
  begin
    if (not IsSubroutine) then
    begin
      SetLength(HintStack, Length(HintStack) + 1);
      HintPointer := Length(HintStack) - 1;
      HintStack[HintPointer].HintCount := 0;
      HintStack[HintPointer].FirstClear := True;
    end;

    X := 0;
    L := Length(CS);
    if L > 0 then
    repeat
      Inc(X);
      V := Ord(CS[X]);

      case V of
        1: Proc_hstem;
        3: Proc_vstem;
        4: Proc_vmoveto;
        5: Proc_rlineto;
        6: Proc_hlineto;
        7: Proc_vlineto;
        8: Proc_rrcurveto;
        11: begin end;
        10:
        begin
          if FFDSel >= 0 then
          begin
            I := QPLStrToIntDef(Stack[Stack.Count - 1], 0);
            Stack.Delete(Stack.Count - 1);
            if FCIDSubrs[FFDSel].Count < 1240 then I := I + 107 else
              if FCIDSubrs[FFDSel].Count < 33900 then I := I + 1131 else
                I := I + 32768;
            Decode(GetType2Subr(I), True);
          end else
          begin
            I := QPLStrToIntDef(Stack[Stack.Count - 1], 0);
            Stack.Delete(Stack.Count - 1);
            if FSubrs.Count < 1240 then I := I + 107 else
              if FSubrs.Count < 33900 then I := I + 1131 else
                I := I + 32768;
            Decode(GetType2Subr(I), True);
          end;
        end;
        12:
        begin
          W := Ord(CS[X + 1]);
          case W of
            3: Proc_and;
            4: Proc_or;
            5: Proc_not;
            9: Proc_abs;
            10: Proc_add;
            11: Proc_sub;
            12: Proc_div;
            14: Proc_neg;
            15: Proc_eq;
            18: Proc_drop;
            20: Proc_put;
            21: Proc_get;
            22: Proc_ifelse;
            23: Proc_random;
            24: Proc_mul;
            26: Proc_sqrt;
            27: Proc_dup;
            28: Proc_exch;
            29: Proc_index;
            30: Proc_roll;
            34: Proc_hflex;
            35: Proc_flex;
            36: Proc_hflex1;
            37: Proc_flex1;
          end;
          Inc(X);
        end;
        14:
        begin
          Proc_endchar(ACharString, BCharString, ADX, ADY);
          if (ACharString <> '') and (BCharString <> '') then
          begin
            Decode(BCharString);
            OutStack.Add('seac(0,' + ADX + ',' + ADY + ')');
            Decode(ACharString);
          end;
          OutStack.Add('endchar');
        end;
        18: Proc_hstem;  //hstemhm
        19: X := X + Proc_hintmask(QPLCopy(CS, X + 1, MaxInt));
        20: X := X + Proc_cntrmask(QPLCopy(CS, X + 1, MaxInt));
        21: Proc_rmoveto;
        22: Proc_hmoveto;
        23: Proc_vstem;  //vstemhm
        24: Proc_rcurveline;
        25: Proc_rlinecurve;
        26: Proc_vvcurveto;
        27: Proc_hhcurveto;
        28:
        if X < (L - 2) then
        begin
          W28 := Ord(CS[X + 1]) shl 8 + Ord(CS[X + 2]);
          V28 := SmallInt(W28);
          Stack.Add(QPLIntToStr(V28));
          Inc(X, 2);
        end;
        29:
        begin
          I := QPLStrToIntDef(Stack[Stack.Count - 1], 0);
          if FGlobalSubrs.Count < 1240 then I := I + 107 else
            if FGlobalSubrs.Count < 33900 then I := I + 1131 else
              I := I + 32768;
          Stack.Delete(Stack.Count - 1);
          Decode(GetType2GSubr(I), True);
        end;
        30: Proc_vhcurveto;
        31: Proc_hvcurveto;
        32..246: Stack.Add(QPLIntToStr(V - 139));
        247..250:
        if X < L then
        begin
          W := Ord(CS[X + 1]);
          Stack.Add(QPLIntToStr((V - 247) * 256 + W + 108));
          Inc(X);
        end;
        251..254:
        if X < L then
        begin
          W := Ord(CS[X + 1]);
          Stack.Add(QPLIntToStr((V - 251) * -256 - W - 108));
          Inc(X);
        end;
        255:
        if X < (L - 4) then
        begin
          WW := Ord(CS[X + 1]) shl 8 + Ord(CS[X + 2]);
          SI := SmallInt(WW);
          I := SI;
          WW := Ord(CS[X + 3]) shl 8 + Ord(CS[X + 4]);
          C := WW;
          D := I + C / 65536;
          Stack.Add(QPLDoubleToStr(D, 6));
          Inc(X, 4);
        end;
      else
        OutStack.Add('Unknown: ' + QPLIntToStr(V));
      end;
    until X = L;

    if Length(HintStack) > 1 then
    begin
      SetLength(HintStack, Length(HintStack) - 1);
      Dec(HintPointer);
    end;
  end;

begin
  FCharStack.Clear;
  FCharStack.Add('hsbw(0,0)');
  Result := False;
  MCS := GetCharString(Name);
  if Length(MCS) > 0 then
  begin
    OutStack := FCharStack;
    PSStack := TQuickPDFStringList.Create;
    Stack := TQuickPDFStringList.Create;
    try
      Result := True;
      Decode(MCS);
      MCS := OutStack.Text;
    finally
      PSStack.Free;
      Stack.Free;
    end;
  end;
end;

function TPDFType1Decoder.GetCharString(const Name: AnsiString): AnsiString;
var
  I: Integer;
begin
  FFDSel := -1;
  I := FCharStringNames.IndexOf(Name);
  if (I < 0) and (QPLCopy(Name, 1, 4) = 'GID:') then
  begin
    I := FCharStringNames.IndexOf('CID:' + QPLCopy(Name, 5, MaxInt));
    if (I < 0) then
    begin
      I := QPLStrToInt(QPLCopy(Name, 5, MaxInt));
    end;
  end;

  Result := '';
  if ((I >= 0) and (FCharStringValues.Count >= I)) then
  begin
    Result := FCharStringValues[I];
    if (I < Length(FCIDSelect)) then
    begin
      FFDSel := FCIDSelect[I];
    end;
  end;
end;

function TPDFType1Decoder.GetSubr(Index: Integer): AnsiString;
var
  X: Integer;
begin
  Result := '';
  X := FSubrs.IndexOfObject(TObject(Index));
  if X >= 0 then
    Result := Decrypt(4330, FLenIV, FSubrs[X]);
end;

function TPDFType1Decoder.GetType2Subr(Index: Integer): AnsiString;
begin
  if FFDSel >= 0 then
  begin
    if (Index >= 0) and (Index < FCIDSubrs[FFDSel].Count) then
      Result := FCIDSubrs[FFDSel][Index]
    else
      Result := '';
  end else
  begin
    if (Index >= 0) and (Index < FSubrs.Count) then
      Result := FSubrs[Index];
  end;
end;

function TPDFType1Decoder.RenderToCanvas(var RX, RY: Double; Canvas: TPDFGenericCanvas;
  Mat: TPDFXForm; const CharName: AnsiString; Enc: TPDFEncodingVector): Boolean;
var
  X: Integer;
  S: AnsiString;
  Cmd: AnsiString;
  CPX: Double;
  CPY: Double;
  DX0, DY0, DX1, DY1, DX2, DY2, DX3, DY3: Double;
  SBX: Double;
  SBY: Double;
  InSeac: Boolean;
  Bad: AnsiString;
  Mat2: TPDFXForm;
  Shape: TPDFGenericShape;
const
  SC = 4;
  XO = 200;
  YO = 200;

  function GetStrParm: AnsiString;
  var
    PB: Integer;
    PC: Integer;
    P: Integer;
  begin
    P := 0;
    PB := QPLPos(')', S);
    PC := QPLPos(',', S);
    if (PB = 0) or (PC = 0) then
    begin
      if PB = 0 then P := PC;
      if PC = 0 then P := PB;
    end else
    begin
      if PB < PC then P := PB else P := PC;
    end;
    if P > 0 then
    begin
      Result := QPLCopy(S, 1, P - 1);
      Delete(S, 1, P);
    end else
    begin
      Result := S;
      S := '';
    end;
  end;

  function GetNumParm: Double; {$IFNDEF QPL_NOINLINE}inline;{$ENDIF}
  begin
    TazzToFloatVar(GetStrParm, Result);
  end;

begin
  if FFontMatrixScaling <> 1 then
  begin
    Mat2.eM11 := FFontMatrixScaling;
    Mat2.eM12 := 0;
    Mat2.eM21 := 0;
    Mat2.eM22 := FFontMatrixScaling;
    Mat2.eDx := 0;
    Mat2.eDy := 0;
    CombinePDFXForm(Mat, Mat2, Mat);
  end;

  X := FCharShapes.IndexOf(CharName);
  if X >= 0 then
  begin
    Shape := TPDFGenericShape(FCharShapes.Objects[X]);
    Mat2.eM11 := 1;
    Mat2.eM12 := 0;
    Mat2.eM21 := 0;
    Mat2.eM22 := 1;
    Mat2.eDx := RX;
    Mat2.eDy := RY;
    CombinePDFXForm(Mat, Mat2, Mat);
    Canvas.DrawShape(Shape, Mat);
    Result := True;
  end else
  begin
    Shape := TPDFGenericShape.Create;
    FCharShapes.AddObject(CharName, Shape);

    DecodeCharstring(CharName);

    InSeac := False;
    Result := False;
    Bad := '';

    CPX := 0;
    CPY := 0;
    SBX := 0;
    SBY := 0;

    Bad := FCharStack.Text;
    Bad := '';

    if Assigned(Canvas) then
    for X := 0 to FCharStack.Count - 1 do
    begin
      S := FCharStack[X];
      if QPLPos('(', S) > 0 then
      begin
        Cmd := QPLCopy(S, 1, QPLPos('(', S) - 1);
        Delete(S, 1, Length(Cmd) + 1);
      end else
        Cmd := S;
      if Cmd = 'hsbw' then
      begin
        SBX := GetNumParm;
        {WX := }GetNumParm;
        if InSeac then
        begin

        end else
        begin
          CPX := {RX + }SBX;
          CPY := {RY + }0;
        end;
      end else
      if Cmd = 'sbw' then
      begin
        SBX := GetNumParm;
        SBY := GetNumParm;
        {WX := }GetNumParm;
        {WY := }GetNumParm;
        if InSeac then
        begin
        end else
        begin
          CPX := {RX + }SBX;
          CPY := {RY + }SBY;
        end;
      end else
      if Cmd = 'rmoveto' then
      begin
        Shape.ClosePath;
        CPX := CPX + GetNumParm;
        CPY := CPY + GetNumParm;
        Shape.MoveTo(CPX, CPY);
      end else
      if Cmd = 'setcurrentpoint' then
      begin
        CPX := {RX + }GetNumParm;
        CPY := {RY + }GetNumParm;
      end else
      if Cmd = 'rlineto' then
      begin
        CPX := CPX + GetNumParm;
        CPY := CPY + GetNumParm;       
        Shape.AddLineToPath(CPX, CPY);
      end else
      if Cmd = 'hmoveto' then
      begin
        Shape.ClosePath;
        CPX := CPX + GetNumParm;
        Shape.MoveTo(CPX, CPY);
      end else
      if Cmd = 'vmoveto' then
      begin
        Shape.ClosePath;
        CPY := CPY + GetNumParm;
        Shape.MoveTo(CPX, CPY);
      end else
      if Cmd = 'rrcurveto' then
      begin
        DX1 := GetNumParm;
        DY1 := GetNumParm;
        DX2 := GetNumParm;
        DY2 := GetNumParm;
        DX3 := GetNumParm;
        DY3 := GetNumParm;
        Shape.AddBezierToPath(CPX + DX1, CPY + DY1, CPX + DX1 + DX2,
          CPY + DY1 + DY2, CPX + DX1 + DX2 + DX3, CPY + DY1 + DY2 + DY3);
        CPX := CPX + DX1 + DX2 + DX3;
        CPY := CPY + DY1 + DY2 + DY3;
        Shape.AddLineToPath(CPX, CPY);
      end else
      if Cmd = 'flex' then
      begin
        DX0 := GetNumParm;
        DY0 := GetNumParm;
        DX1 := DX0 + GetNumParm;
        DY1 := DY0 + GetNumParm;
        DX2 := GetNumParm;
        DY2 := GetNumParm;
        DX3 := GetNumParm;
        DY3 := GetNumParm;
        Shape.AddBezierToPath(CPX + DX1, CPY + DY1, CPX + DX1 + DX2,
          CPY + DY1 + DY2, CPX + DX1 + DX2 + DX3, CPY + DY1 + DY2 + DY3);
        CPX := CPX + DX1 + DX2 + DX3;
        CPY := CPY + DY1 + DY2 + DY3;

        DX1 := GetNumParm;
        DY1 := GetNumParm;
        DX2 := GetNumParm;
        DY2 := GetNumParm;
        DX3 := GetNumParm;
        DY3 := GetNumParm;
        Shape.AddBezierToPath(CPX + DX1, CPY + DY1, CPX + DX1 + DX2,
          CPY + DY1 + DY2, CPX + DX1 + DX2 + DX3, CPY + DY1 + DY2 + DY3);
        CPX := CPX + DX1 + DX2 + DX3;
        CPY := CPY + DY1 + DY2 + DY3;
      end else
      if Cmd = 't2flex' then
      begin
        DX1 := GetNumParm;
        DY1 := GetNumParm;
        DX2 := GetNumParm;
        DY2 := GetNumParm;
        DX3 := GetNumParm;
        DY3 := GetNumParm;
        Shape.AddBezierToPath(CPX + DX1, CPY + DY1, CPX + DX1 + DX2,
          CPY + DY1 + DY2, CPX + DX1 + DX2 + DX3, CPY + DY1 + DY2 + DY3);
        CPX := CPX + DX1 + DX2 + DX3;
        CPY := CPY + DY1 + DY2 + DY3;
        DX1 := GetNumParm;
        DY1 := GetNumParm;
        DX2 := GetNumParm;
        DY2 := GetNumParm;
        DX3 := GetNumParm;
        DY3 := GetNumParm;
        Shape.AddBezierToPath(CPX + DX1, CPY + DY1, CPX + DX1 + DX2,
          CPY + DY1 + DY2, CPX + DX1 + DX2 + DX3, CPY + DY1 + DY2 + DY3);
        CPX := CPX + DX1 + DX2 + DX3;
        CPY := CPY + DY1 + DY2 + DY3;
        GetNumParm;
      end else
      if Cmd = 'closepath' then
      begin
        Shape.ClosePath;
      end else
      if Cmd = 'endchar' then
      begin
        Result := True;
      end else
      if (Cmd = 'vstem') or (Cmd = 'hstem') then
      begin

      end else
      if (Cmd = 'seac') then
      begin
        InSeac := True;
        GetNumParm;
        CPX := {RX + }SBX + GetNumParm;
        CPY := {RY + }SBY + GetNumParm;
      end else
      begin
        Bad := Bad + Cmd + ' ';
      end;
    end;
    Mat2.eM11 := 1;
    Mat2.eM12 := 0;
    Mat2.eM21 := 0;
    Mat2.eM22 := 1;
    Mat2.eDx := RX;
    Mat2.eDy := RY;
    CombinePDFXForm(Mat, Mat2, Mat);
    Canvas.DrawShape(Shape, Mat);
  end;
end;

function TPDFType1Decoder.DecryptedEncryptionPortion: AnsiString;
begin
  Result := Decrypt(55665, FLenIV, FEncryptedPortion);
end;

function TPDFType1Decoder.GetCharStringCount: Integer;
begin
  Result := FCharStringNames.Count;
end;

function TPDFType1Decoder.GetCharStringName(Index: Integer): AnsiString;
begin
  if (Index >= 0) and (Index < FCharStringNames.Count) then
    Result := FCharStringNames[Index]
  else
    Result := '';
end;

function TPDFType1Decoder.LoadCFFFromPDFStream(
  Stream: TPDFStream): Boolean;
var
  S: AnsiString;
  MS: TStringStream;
begin
  S := Stream.GetDecodedStream;
  MS := TStringStream.Create(S);
  try
    Result := LoadCFFFromStream(MS);
  finally
    MS.Free;
  end;
end;

function TPDFType1Decoder.LoadCFFFromStream(Stream: TStream): Boolean;
var
  Header: TPDFCFFHeader;
  NameIndex: TQuickPDFStringList;
  TopDictIndex: TQuickPDFStringList;
  StringIndex: TQuickPDFStringList;
  GlobalSubrIndex: TQuickPDFStringList;
  LocalStructure: TPDFStructure;
  TopDict: TPDFDictionary;
  Obj: TPDFObject;
  TDI: Integer;
  CharStringsIndex: TQuickPDFStringList;
  PrivateArray: TPDFArray;
  PrivateStr: AnsiString;
  PrivatePos: Integer;
  PrivateSize: Integer;
  Offset: Integer;
  FontDictPos: Integer;
  FontDictIndex: TQuickPDFStringList;
  FDI: Integer;
  FontDict: TPDFDictionary;
  PrivateDict: TPDFDictionary;
  OTTO: Boolean;
  StreamOffset: Integer;

  function ReadCard8: Byte;
  begin
    Stream.Read(Result, 1);
  end;

  function ReadCard16: Word;
  var
    B1, B2: Byte;
  begin
    Stream.Read(B1, 1);
    Stream.Read(B2, 1);
    Result := B1 shl 8 + B2;
  end;

  function ReadCard24: Cardinal;
  var
    B1, B2, B3: Byte;
  begin
    Stream.Read(B1, 1);
    Stream.Read(B2, 1);
    Stream.Read(B3, 1);
    Result := B1 shl 16 + B2 shl 8 + B3;
  end;

  function ReadCard32: Cardinal;
  var
    B1, B2, B3, B4: Byte;
  begin
    Stream.Read(B1, 1);
    Stream.Read(B2, 1);
    Stream.Read(B3, 1);
    Stream.Read(B4, 1);
    Result := B1 shl 24 + B2 shl 16 + B3 shl 8 + B4;
  end;

  procedure ReadIndex(Index: TQuickPDFStringList);
  var
    Count: Word;
    OffSize: Byte;
    X: Integer;
    Data: AnsiString;
    Offsets: array of Cardinal;
  begin
    Index.Clear;
    Count := ReadCard16;
    if Count > 0 then
    begin
      OffSize := ReadCard8;
      SetLength(Offsets, Count + 1);
      for X := 0 to Count do
      begin
        case OffSize of
          1: Offsets[X] := ReadCard8;
          2: Offsets[X] := ReadCard16;
          3: Offsets[X] := ReadCard24;
          4: Offsets[X] := ReadCard32;
        end;
      end;
      for X := 0 to Count - 1 do
      begin
        SetLength(Data, Offsets[X + 1] - Offsets[X]);
        if Length(Data) > 0 then
          Stream.Read(Data[1], Length(Data));
        Index.Add(Data);
      end;
    end;
  end;

  function GetSID(SID: Integer): AnsiString;
  var
    TS: AnsiString;
  begin
    if (SID >= 0) and (SID <= 390) then
    begin
      TS := '|' + QPLFormatFloat('000', SID);
      SID := QPLPos(TS, StandardCFFStrings);
      if SID >= 1 then
      begin
        Result := QPLCopy(StandardCFFStrings, SID + 4, MaxInt);
        if QPLPos('|', Result) > 0 then
          Delete(Result, QPLPos('|', Result), MaxInt);
      end;
    end else
    if (SID > 390) and (SID <= (StringIndex.Count + 390)) then
      Result := StringIndex[SID - 391]
    else
      Result := '';
  end;

  function DecodeDict(const DictData: AnsiString; DictType: Integer): AnsiString;
  var
    X: Integer;
    L: Integer;
    RN: AnsiString;
    Nibble: Byte;
    B0: Byte;
    B1: Byte;
    B2: Byte;
    B3: Byte;
    B4: Byte;
    StackList: array of AnsiString;
    StackCount: Integer;
    OperandList: array of AnsiString;
    OperandCount: Integer;

    function OutputStack: AnsiString;
    var
      X: Integer;
      ResultLength: Integer;
      Item: AnsiString;
    begin
      SetLength(Result, StackCount * 20);
      Result[1] := '<';
      Result[2] := '<';
      Result[3] := ' ';
      ResultLength := 3;
      for X := 0 to StackCount - 1 do
      begin
        Item := StackList[X];
        while ResultLength + Length(Item) + 1 >= Length(Result) do
        begin
          SetLength(Result, Length(Result) * 2);
        end;
        if Length(Item) > 0 then
        begin
          Move(Item[1], Result[ResultLength + 1], Length(Item));
          Inc(ResultLength, Length(Item) + 1);
          Result[ResultLength] := ' ';
        end;
      end;
      SetLength(Result, ResultLength);
      Result := Result + '>>';
    end;

    procedure AddOperand(const Tok: AnsiString);
    begin
      Inc(OperandCount);
      if OperandCount >= Length(OperandList) then
      begin
        SetLength(OperandList, Length(OperandList) + 100);
      end;
      OperandList[OperandCount - 1] := Tok;
    end;

    procedure AddStack(const Tok: AnsiString);
    begin
      Inc(StackCount);
      if StackCount >= Length(StackList) then
      begin
        SetLength(StackList, Length(StackList) + 100);
      end;
      StackList[StackCount - 1] := Tok;
    end;

    function Pop: AnsiString;
    begin
      if OperandCount > 0 then
      begin
        Dec(OperandCount);
        Result := OperandList[OperandCount];
      end else
        Result := '';
    end;

    function PopSID: AnsiString;
    var
      SID: Integer;
    begin
      SID := QPLStrToIntDef(Pop, -1);
      Result := GetSID(SID);
    end;

    function PopArray: AnsiString;
    var
      Item: AnsiString;
      X: Integer;
      ResultLength: Integer;
    begin
      SetLength(Result, OperandCount * 20);
      ResultLength := 0;
      for X := 0 to OperandCount - 1 do
      begin
        Item := OperandList[X];
        if ResultLength + Length(Item) + 1 >= Length(Result) then
        begin
          SetLength(Result, Length(Result) + (OperandCount - X) * 20);
        end;
        if Length(Item) > 0 then
        begin
          Move(Item[1], Result[ResultLength + 1], Length(Item));
          Inc(ResultLength, Length(Item) + 1);
          Result[ResultLength] := ' ';
        end;
      end;
      OperandCount := 0;
      if ResultLength > 0 then Dec(ResultLength);
      SetLength(Result, ResultLength - 1);
    end;

    procedure ProcTopDict;
    begin
      case B0 of
        0: AddStack('/version (' + PopSID + ')');
        1: AddStack('/Notice (' + PopSID + ')');
        2: AddStack('/FullName (' + PopSID + ')');
        3: AddStack('/FamilyName (' + PopSID + ')');
        4: AddStack('/Weight (' + PopSID + ')');
        5: AddStack('/FontBBox [ ' + PopArray + ' ]');
        12:
        begin
          case B1 of
            0: AddStack('/Copyright (' + PopSID + ')');
            1: AddStack('/isFixedPitch ' + Pop);
            2: AddStack('/italicAngle ' + Pop);
            3: AddStack('/UnderlinePosition ' + Pop);
            4: AddStack('/UnderlineThickness ' + Pop);
            5: AddStack('/PaintType ' + Pop);
            6: AddStack('/CharstringType ' + Pop);
            7: AddStack('/FontMatrix [ ' + PopArray + ' ]');
            8: AddStack('/StrokeWidth ' + Pop);
            20: AddStack('/SyntheticBase ' + Pop);
            21: AddStack('/PostScript (' + PopSID + ')');
            22: AddStack('/BaseFontName (' + PopSID + ')');
            23: AddStack('/BaseFontBlend [' + PopArray + ']');
            30: AddStack('/ROS [' + PopArray + ']');
            31: AddStack('/CIDFontVersion ' + Pop);
            32: AddStack('/CIDFontRevision ' + Pop);
            33: AddStack('/CIDFontType ' + Pop);
            34: AddStack('/CIDCount ' + Pop);
            35: AddStack('/UIDBase ' + Pop);
            36: AddStack('/FDArray ' + Pop);
            37: AddStack('/FDSelect ' + Pop);
            38: AddStack('/FontName (' + PopSID + ')');
          end;
          Inc(X);
        end;
        13: AddStack('/UniqueID ' + Pop);
        14: AddStack('/XUID [ ' + PopArray + ' ]');
        15: AddStack('/charset ' + Pop);
        16: AddStack('/Encoding ' + Pop);
        17: AddStack('/CharStrings ' + Pop);
        18: AddStack('/Private [ ' + Pop + ' ' + Pop + ' ]');
      end;
    end;

    procedure ProcPrivateDict;
    begin
      case B0 of
        6: AddStack('/BlueValues [ ' + PopArray + ' ]');
        7: AddStack('/OtherBlues [ ' + PopArray + ' ]');
        8: AddStack('/FamilyBlues [ ' + PopArray + ' ]');
        9: AddStack('/FamilyOtherBlues [ ' + PopArray + ' ]');
        10: AddStack('/StdHW ' + Pop);
        11: AddStack('/StdVW ' + Pop);
        12:
        begin
          case B1 of
            9: AddStack('/BlueScale ' + Pop);
            10: AddStack('/BlueShift ' + Pop);
            11: AddStack('/BlueFuzz ' + Pop);
            12: AddStack('/StemSnapH [ ' + PopArray + ' ]');
            13: AddStack('/StemSnapV [ ' + PopArray + ' ]');
            14: AddStack('/ForceBold ' + Pop);
            17: AddStack('/LanguageGroup ' + Pop);
            18: AddStack('/ExpansionFactor ' + Pop);
            19: AddStack('/initialRandomSeed ' + Pop);
          end;
          Inc(X);
        end;
        19: AddStack('/Subrs ' + Pop);
        20: AddStack('/defaultWidthX ' + Pop);
        21: AddStack('/nominalWidthX ' + Pop);
      end;
    end;

  begin
    B0 := 0;
    B1 := 0;
    B2 := 0;
    B3 := 0;
    B4 := 0;
    L := Length(DictData);
    if L > 0 then
    begin
      SetLength(StackList, 100);
      StackCount := 0;
      SetLength(OperandList, 100);
      OperandCount := 0;
      X := 0;
      repeat
        Inc(X);
        B0 := Ord(DictData[X]);
        if X < L then
          B1 := Ord(DictData[X + 1]);
        if X < (L - 1) then
          B2 := Ord(DictData[X + 2]);
        if X < (L - 2) then
          B3 := Ord(DictData[X + 3]);
        if X < (L - 3) then
          B4 := Ord(DictData[X + 4]);
        if (DictType = 0) and (B0 <= 21) then ProcTopDict;
        if (DictType = 1) and (B0 <= 21) then ProcPrivateDict;          
        if (B0 >= 28) then
        case B0 of
          28:
          begin
            AddOperand(QPLIntToStr(B1 shl 8 + B2));
            Inc(X, 2);
          end;
          29:
          begin
            AddOperand(QPLIntToStr(B1 shl 24 + B2 shl 16 + B3 shl 8 + B4));
            Inc(X, 4);
          end;
          30:
          begin
            RN := '';
            repeat
              Inc(X);
              B0 := Ord(DictData[X]);
              Nibble := (B0 and $f0) shr 4;
              case Nibble of
                0..9: RN := RN + QPLIntToStr(Nibble);
                $a: RN := RN + '.';
                $b: RN := RN + 'E';
                $c: RN := RN + 'E-';
                $e: RN := RN + '-';
              end;
              Nibble := (B0 and $0f);
              case Nibble of
                0..9: RN := RN + QPLIntToStr(Nibble);
                $a: RN := RN + '.';
                $b: RN := RN + 'E';
                $c: RN := RN + 'E-';
                $e: RN := RN + '-';
              end;
            until (B0 and $0f) = $0f;
            AddOperand(RN);
          end;
          32..246: AddOperand(QPLIntToStr(B0 - 139));
          247..250:
          begin
            AddOperand(QPLIntToStr((B0 - 247) * 256 + B1 + 108));
            Inc(X);
          end;
          251..254:
          begin
            AddOperand(QPLIntToStr((B0 - 251) * -256 - B1 - 108));
            Inc(X);
          end;
        end;
      until X >= L;
      Result := OutputStack;
    end;
  end;

  procedure ReadEncoding;
  var
    Format: Word;
    NRanges: Word;
    X: Integer;
    I: Integer;
    First: Word;
    NLeft: Word;
    NCodes: Word;
    Offset: Integer;
  begin
    for X := 0 to 255 do
      FEncoding[X] := '.notdef';
    Format := ReadCard8;
    if (Format = 0)  or (Format = 128) then
    begin
      NCodes := ReadCard8;
      for X := 1 to NCodes do
      begin
        First := ReadCard8;
        if X <= (FCharStringNames.Count - 1) then
          FEncoding[First] := FCharStringNames[X];
      end;
    end else
    if Format = 1 then
    begin
      NRanges := ReadCard8;
      Offset := 1;
      for X := 1 to NRanges do
      begin
        First := ReadCard8;
        NLeft := ReadCard8;
        for I := 0 to NLeft do
        begin
          FEncoding[First] := FCharStringNames[Offset];
          Inc(Offset);
          Inc(First);
        end;
      end;
    end;
  end;

  procedure DefaultEncoding(Code: Integer);
  var
    X: Integer;
    SID: Integer;
  begin
    if Code = 0 then
    begin
      for X := 0 to 255 do
      begin
        SID := StandardEncodingSID[X];
        FEncoding[X] := GetSID(SID);
      end;
    end;
  end;

  procedure ReadCharset;
  var
    Format: Byte;
    First: Word;
    NLeft: Byte;
    NLeft2: Word;
    Done: Boolean;
    I: Integer;
    X: Integer;
    Charset: array of Integer;
    CSN: AnsiString;
    CSV: AnsiString;
  begin
    FCharStringNames.Clear;
    FCharStringValues.Clear;
    SetLength(Charset, CharStringsIndex.Count);
    Charset[0] := 0;
    Format := ReadCard8;
    if Format = 0 then
    begin
      for X := 1 to CharStringsIndex.Count - 1 do
      begin
        First := ReadCard16;
        Charset[X] := First;
      end;
    end else
    if Format = 1 then
    begin
      I := 0;
      Done := False;
      repeat
        First := ReadCard16;
        NLeft := ReadCard8;
        Inc(I);
        Charset[I] := First;
        for X := 1 to NLeft do
        begin
          Inc(I);
          Charset[I] := Charset[I - 1] + 1;
        end;
        if I >= Length(Charset) - 1 then Done := True;
      until Done;
    end else
    if Format = 2 then
    begin
      I := 0;
      Done := False;
      repeat
        First := ReadCard16;
        NLeft2 := ReadCard16;
        Inc(I);
        Charset[I] := First;
        for X := 1 to NLeft2 do
        begin
          Inc(I);
          Charset[I] := Charset[I - 1] + 1;
        end;
        if I >= Length(Charset) - 1 then Done := True;
      until Done;
    end;

    for X := 0 to Length(Charset) - 1 do
    begin
      if FIsCIDFont then
        CSN := 'CID:' + QPLIntToStr(Charset[X])
      else
        CSN := GetSID(Charset[X]);
      CSV := CharStringsIndex[X];
      FCharStringNames.Add(CSN);
      FCharStringValues.Add(CSV);
    end;
  end;

  procedure DefaultCharset(Code: Integer);
  var
    X: Integer;
    SID: Integer;
    CSN: AnsiString;
    CSV: AnsiString;
  begin
    FCharStringNames.Clear;
    FCharStringValues.Clear;
    if Code = 0 then
    begin
      FCharStringNames.Add('.notdef');
      FCharStringValues.Add('');
    end;
    for X := 1 to CharStringsIndex.Count - 1 do
    begin
      SID := X;
      CSN := GetSID(SID);
      CSV := CharStringsIndex[SID];
      FCharStringNames.Add(CSN);
      FCharStringValues.Add(CSV);
    end;
  end;

  function GetPrivateDict(Dict: TPDFDictionary): TPDFDictionary;
  begin
    Result := nil;
    Obj := Dict.FindValueByKeyName('Private');
    if Obj is TPDFArray then
    begin
      PrivateArray := TPDFArray(Obj);
      if (PrivateArray.Count = 2) and (PrivateArray.Item[0] is TPDFNumeric)
        and (PrivateArray.Item[1] is TPDFNumeric) then
      begin
        PrivateSize := TPDFNumeric(PrivateArray.Item[1]).AsInteger;
        PrivatePos := TPDFNumeric(PrivateArray.Item[0]).AsInteger;
        SetLength(PrivateStr, PrivateSize);
        if PrivateSize > 0 then
        begin
          Stream.Seek(StreamOffset + PrivatePos, soFromBeginning);
          Stream.Read(PrivateStr[1], PrivateSize);
          PrivateStr := DecodeDict(PrivateStr, 1);
          Obj := LocalStructure.Decode(PrivateStr);
          if Obj is TPDFDictionary then
            Result := TPDFDictionary(Obj);
        end;
      end;
    end;
  end;

  procedure ReadFDSelect(var FD: TFDSelect);
  var
    Format: Byte;
    NRanges: Word;
    X: Integer;
    First: Integer;
    Next: Integer;
    FDValue: Integer;
    FX: Integer;
  begin
    SetLength(FD, FCharStringNames.Count);
    Format := ReadCard8;
    if Format = 0 then
    begin
      for X := 0 to Length(FD) - 1 do
        FD[X] := ReadCard8;
    end else
    if Format = 3 then
    begin
      NRanges := ReadCard16;
      First := ReadCard16;
      for X := 0 to NRanges - 1 do
      begin
        FDValue := ReadCard8;
        Next := ReadCard16;
        for FX := First to Next - 1 do
          FD[FX] := FDValue;
        First := Next;
      end;
    end;
  end;

begin
  NameIndex := TQuickPDFStringList.Create;
  TopDictIndex := TQuickPDFStringList.Create;
  StringIndex := TQuickPDFStringList.Create;
  GlobalSubrIndex := TQuickPDFStringList.Create;
  LocalStructure := FStructure;
  CharStringsIndex := TQuickPDFStringList.Create;
  FontDictIndex := TQuickPDFStringList.Create;
  try
    LocalStructure.PDFPrecision := '0.00000000';
    LocalStructure.PDFPrecNum := 8;
    StreamOffset := Stream.Position;
    Stream.Read(Header, SizeOf(Header));
    OTTO := (Header.Major = 79) and (Header.Minor = 84) and
      (Header.HdrSize = 84) and (Header.OffSize = 79);

    if OTTO then
    begin
      Stream.Seek(StreamOffset, soFromBeginning);
      LoadOpenTypeFromStream(Stream);
      StreamOffset := Stream.Position;
      Stream.Read(Header, SizeOf(Header));
      OTTO := (Header.Major = 79) and (Header.Minor = 84) and
        (Header.HdrSize = 84) and (Header.OffSize = 79);
    end;

    Result := not OTTO;

    if Result then
    begin
      if SizeOf(Header) < Header.HdrSize then
        Stream.Position := Stream.Position + (Header.HdrSize - SizeOf(Header));
      ReadIndex(NameIndex);
      ReadIndex(TopDictIndex);
      ReadIndex(StringIndex);
      ReadIndex(GlobalSubrIndex);
      FGlobalSubrs.Clear;
      FGlobalSubrs.AddStrings(GlobalSubrIndex);
      for TDI := 0 to TopDictIndex.Count - 1 do
      begin
        TopDictIndex[TDI] := DecodeDict(TopDictIndex[TDI], 0);
        Obj := LocalStructure.Decode(TopDictIndex[TDI]);
        if Obj is TPDFDictionary then
        begin
          TopDict := TPDFDictionary(Obj);
          FIsCIDFont := (TopDict.FindValueByKeyName('ROS') <> nil) or FForceCIDFont;
          Obj := TopDict.FindValueByKeyName('FontMatrix');
          if Obj is TPDFArray then
          begin
            Obj := TPDFArray(Obj).Item[0];
            if Obj is TPDFNumeric then
              FFontMatrixScaling := TPDFNumeric(Obj).AsDouble * 1000;
            if FFontMatrixScaling = 0 then FFontMatrixScaling := 1;
          end;
          Obj := TopDict.FindValueByKeyName('CharStrings');
          if Obj is TPDFNumeric then
          begin
            Offset := TPDFNumeric(Obj).AsInteger;
            Stream.Seek(StreamOffset + Offset, soFromBeginning);
            ReadIndex(CharStringsIndex);
          end;
          if CharStringsIndex.Count > 0 then
          begin
            Obj := TopDict.FindValueByKeyName('charset');
            if Obj is TPDFNumeric then
            begin
              Offset := TPDFNumeric(Obj).AsInteger;
              if Offset > 2 then
              begin
                Stream.Seek(StreamOffset + Offset, soFromBeginning);
                ReadCharset;
              end else
                DefaultCharset(Offset);
            end else
              DefaultCharset(0);
            Obj := TopDict.FindValueByKeyName('Encoding');
            if Obj is TPDFNumeric then
            begin
              Offset := TPDFNumeric(Obj).AsInteger;
              if Offset > 1 then
              begin
                Stream.Seek(StreamOffset + Offset, soFromBeginning);
                ReadEncoding;
              end else
                DefaultEncoding(Offset);
            end else
              DefaultEncoding(0);
          end;
          FCharStringType := 2;

          if FIsCIDFont then
          begin
            Obj := TopDict.FindValueByKeyName('FDSelect');
            if Obj is TPDFNumeric then
            begin
              Stream.Seek(StreamOffset + TPDFNumeric(Obj).AsInteger, soFromBeginning);
              ReadFDSelect(FCIDSelect);
            end;
            Obj := TopDict.FindValueByKeyName('FDArray');
            if Obj is TPDFNumeric then
            begin
              FontDictPos := TPDFNumeric(Obj).AsInteger;
              Stream.Seek(StreamOffset + FontDictPos, soFromBeginning);
              ReadIndex(FontDictIndex);
              SetLength(FCIDSubrs, FontDictIndex.Count);
              for FDI := 0 to FontDictIndex.Count - 1 do
              begin
                FCIDSubrs[FDI] := TQuickPDFStringList.Create;
                FontDictIndex[FDI] := DecodeDict(FontDictIndex[FDI], 0);
                Obj := LocalStructure.Decode(FontDictIndex[FDI]);
                if Obj is TPDFDictionary then
                begin
                  FontDict := TPDFDictionary(Obj);
                  PrivateDict := GetPrivateDict(FontDict);
                  if Assigned(PrivateDict) then
                  begin
                    Obj := PrivateDict.FindValueByKeyName('Subrs');
                    if Obj is TPDFNumeric then
                    begin
                      Stream.Seek(StreamOffset + PrivatePos + TPDFNumeric(Obj).AsInteger,
                        soFromBeginning);
                      ReadIndex(FCIDSubrs[FDI]);
                    end;
                  end;
                end;
              end;
            end;
          end;

          if Assigned(TopDict) then
          begin
            PrivateDict := GetPrivateDict(TopDict);
            if Assigned(PrivateDict) then
            begin
              Obj := PrivateDict.FindValueByKeyName('Subrs');
              if Obj is TPDFNumeric then
              begin
                Stream.Seek(StreamOffset + PrivatePos + TPDFNumeric(Obj).AsInteger,
                  soFromBeginning);
                ReadIndex(FSubrs);
              end;
            end;
          end;
          // get subrs
        end;
      end;
    end;
  finally
    NameIndex.Free;
    TopDictIndex.Free;
    StringIndex.Free;
    GlobalSubrIndex.Free;
    FontDictIndex.Free;
    //LocalStructure.Free;
    CharStringsIndex.Free;
  end;
end;

function TPDFType1Decoder.LoadPFBFromString(const Source: AnsiString): Boolean;
var
  MS: TMemoryStream;
begin
  if (Length(Source) > 0) then
  begin
    MS := TMemoryStream.Create;
    try
      MS.Write(Source[1], Length(Source));
      MS.Seek(0, soFromBeginning);
      Result := LoadPFBFromStream(MS);
    finally
      MS.Free;
    end;
  end else
  begin
    Result := False;
  end;
end;

function TPDFType1Decoder.GetEncoding: TPDFCharsetNames;
begin
  Result := FEncoding;
end;

function TPDFType1Decoder.FontMatrixScaling: Double;
begin
  Result := FFontMatrixScaling;
end;

procedure TPDFType1Decoder.ForceCIDFont;
begin
  FForceCIDFont := True;
end;

function TPDFType1Decoder.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

function TPDFType1Decoder.GetType2GSubr(Index: Integer): AnsiString;
begin
  if (Index >= 0) and (Index < FGlobalSubrs.Count) then
    Result := FGlobalSubrs[Index]
  else
    Result := '';
end;

function TPDFType1Decoder.LoadOpenTypeFromStream(Stream: TStream): Boolean;
var
  Parser: TPDFTrueTypeParser;
  CFFDataPosition: Integer;
begin
  Result := False;
  Parser := TPDFTrueTypeParser.Create;
  try
    Parser.LoadFromStream(Stream);
    CFFDataPosition := Parser.GetCFFDataPosition;
    if (CFFDataPosition > 0) then
    begin
      Stream.Seek(CFFDataPosition, soFromBeginning);
    end;
  finally
    Parser.Free;
  end;
end;

end.
