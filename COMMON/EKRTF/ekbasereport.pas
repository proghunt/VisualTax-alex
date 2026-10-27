(*****************************************)
(*           Ek RTF report v 3.11        *)
(*   (C) Eugene Kuchugurov, 2000-2013    *)
(*****************************************)
// This file is in UTF-8 encoding
unit ekbasereport;

interface
uses
  Windows,
{$IFDEF VER120}
  FileCtrl,
{$ENDIF}
{$IFDEF VER130}
  FileCtrl,
{$ENDIF}
   SysUtils, Classes, Graphics,
  conscom,  ekfunc;

type ByteArray=Array of Byte;

  type
    TEkBaseReport=class;


  TEkVarListObject=class
   private
   FDataType:TEkDataType;
  end;

  TEkIntStack=class
    private
      FArray: array of longint;
      FCount: longint;
    public
      constructor Create;
      destructor Destroy;override;
      procedure Clear;
      procedure Push(i:longint);
      function Pop:longint;
      property Count:longint read FCount;
  end;

  TEkReportVariable=class
     private
       FOwnerBaseReport:TEkBaseReport;
       FVarName:string;
       FLocal:boolean;
       FLocalValue:string;
       FLocalType:TEkDataType;
       FmtSett: TFormatSettings;
       function GetDataType: TEkDataType;
       function GetDataTypeText: string;
       function GetDataTypeNumber: integer;
       procedure SetDataType(const Value: TEkDataType);
     protected
       property OwnerBaseReport:TEkBaseReport read FOwnerBaseReport;
       function GetCheckVarNumber(ErrMsg:string):longint;
       function GetAsString:string;
       procedure SetAsString(Value:string);
       function GetAsFloat:Extended;
       procedure SetAsFloat(Value:Extended);
       function GetAsInteger:int64;
       procedure SetAsInteger(Value:int64);
       function GetAsDate:TDateTime;
       procedure SetAsDate(Value:TDateTime);
       function GetAsDateTime:TDateTime;
       procedure SetAsDateTime(Value:TDateTime);
       function GetAsBoolean:boolean;
       procedure SetAsBoolean(Value:boolean);
       procedure SetLocal(Value:boolean);
     public
       //***!!! was protected
       property Local:boolean read FLocal write SetLocal;
       procedure SetVarName(VarName:string);
       procedure ChangeVarName(NewVarName:string);

       constructor create(VarOwner:TEkBaseReport);
       property AsString:string read GetAsString write SetAsString;
       property AsFloat:Extended read GetAsFloat write SetAsFloat;
       property AsInteger:int64 read GetAsInteger write SetAsInteger;
       property AsDate:TDateTime read GetAsDate write SetAsDate;
       property AsDateTime:TDateTime read GetAsDateTime write SetAsDateTime;
       property AsBoolean:boolean read GetAsBoolean write SetAsBoolean;
       property Name:string read FVarName;
       property DataType:TEkDataType read GetDataType write SetDataType;
       property DataTypeText:string read GetDataTypeText;
       property DataTypeNumber:integer read GetDataTypeNumber;
       //destructor destroy;override;
  end;

  TEkOperand=record
    Text:string;
    IsOperand:boolean;
    ArgsNeed:integer;
    ReqBoolArg:boolean;
    AllowBoolArg:boolean;
    RetBoolRes:boolean;
    Priority:integer;
    Fldnum:integer;
  end;

  TEkOperationStack=class
  private
    FExpression:array of TEkOperand;
    FCount:integer;
    function GetOperation(index:integer):TEkOperand;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(MOperand:TEkOperand);
    function Pop:TEkOperand;
    property Count:integer read FCount;
    property Operation[index:integer]: TEkOperand read GetOperation;
  end;


  TEkExpression=class
  private
    FExpression:array of TEkOperand;
    FCount:integer;
    function GetOperand(index:integer):TEkOperand;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(MText:string; MIsOperand:boolean; MArgsNeed:integer; MReqBoolArg, MAllowBoolArg, MRetBoolRes:boolean; MPriority,MFldnum:integer);overload;
    procedure Add(MOperand:TEkOperand);overload;
    property Operand[index:integer]: TEkOperand read GetOperand;
    property Count:integer read FCount;
  end;


  TEkRcTypes=(rcdata, rcsimple, rcnottext);
  TEkRowContent=record
       stestf,
       Dalias,
       Field,
       sout:string;
       NField:longint;
       fmt:TEkFieldFormat;
       ftype, DefinedType:TEkRcTypes;
       Defined:boolean;
   end;


  TEkVarList=class(TStringList)
   public
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
  end;

  //------------------EkBaseReport----------------------------------------------
  TEkBaseReport = class(TComponent)
  private
    FVarList:TEkVarList;
    FReportVariable:TEkReportVariable;
    FTrueValue:string;
    FFalseValue:string;
    FDecimalRTerminator:char;
    FDecimalRSeparator:char;
    FUDFList:TEkUDFList;

    FInFile:TFileName;
    FOutFile:TFileName;

    FInDList:TStringList; //List of input data files names Name=NNN
    FInDListOneCharExists:boolean; //Для проверки в функции CToN при поиске индекса по имени датасета

    FExecute:boolean; //is report executing
    FOnFinished:TNotifyEvent;

    FPFile:ByteArray;
    FTmLoaded:boolean;
    Fpnt,Flent : longint;
    FLastBoundaryPnt: longint;
    FKwdPnt    : longint;
    FSzi:longint;

    FTmpStream:TStream;  //Temporary stream
    FTmpFileName:string; //Temporary file in case of not using memory
    FOutStream:TStream;   //for output to memory
    FUseStream:boolean;   //use output to memory
    FOutf  : TStream;     //foutf is created file stream or =FOutStream
    FOutfCreated:boolean; //had been outfile created?

    FiifNumber:longint; //unique iif number

    FCmPos:longint;
    FCmLastId:longint;
    FCmLastFpnt:longint;
    FCmSkip:longint;
    FCmStream: TMemoryStream;
    FCmStrings: array of string;

    FmtSett: TFormatSettings;
    FUnicodeByDefault:boolean;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadVarDataType(St: TStream);
    procedure WriteVarDataType(St: TStream);

    procedure SetVarList(Value:TEkVarList);
    procedure SetTrueValue(Value:string);
    procedure SetFalseValue(Value:string);
    procedure SetUDFList(Value:TEkUDFList);
    procedure SetInFile(Value:TFileName);
    procedure SetOutFile(Value:TFileName);
    procedure SetOnFinished(Value: TNotifyEvent);

    function CmStoreString(var s:string):longint;
    function CmGetString(n:longint):string;
    procedure CmSaveItemInfo(id, skipbytes, cmfpnt:integer);
    procedure CmReadItemInfo;
    procedure CmSaveItemPos;
    procedure CmReadItemPos;
    procedure CmSaveBegin;
    procedure CmSaveEnd;

    procedure CmSaveBlocItem; virtual;
    procedure CmReadBlocItem; virtual;
    procedure CmSaveBalancedBlocItem; virtual;
    procedure CmReadBalancedBlocItem; virtual;
    procedure CmSaveTableBegin; virtual;
    procedure CmReadTableBegin; virtual;
    procedure CmSaveTableEnd; virtual;
    procedure CmReadTableEnd; virtual;
    procedure CmSaveRawItem(var s:string); virtual;
    procedure CmReadRawItem(var s:string); virtual;
    procedure CmSaveScanItem(var OutStr,SPar:string; n:word); virtual;
    procedure CmReadScanItem(var OutStr,SPar:string;var n:word); virtual;
    procedure CmSaveScanWhileItem(var OutStr,SPar:string; n:word); virtual;
    procedure CmReadScanWhileItem(var OutStr,SPar:string;var n:word); virtual;
    procedure CmSaveIfItem(var OutStr,SPar:string; n:word; elseflag:boolean); virtual;
    procedure CmReadIfItem(var OutStr,SPar:string;var n:word; var elseflag:boolean); virtual;
    procedure CmSaveScanEntryItem(var OutStr,SPar:string; n:word); virtual;
    procedure CmReadScanEntryItem(var OutStr,SPar:string; var n:word); virtual;
    procedure CmSaveScanFooterItem(var OutStr,SPar:string; n:word); virtual;
    procedure CmReadScanFooterItem(var OutStr,SPar:string; var n:word); virtual;
    procedure CmSaveEndScanItem(var OutStr,SPar:string; n:word); virtual;
    procedure CmReadEndScanItem(var OutStr,SPar:string;var n:word); virtual;
    procedure CmSaveEndIfItem(var OutStr,SPar:string; n:word); virtual;
    procedure CmReadEndIfItem(var OutStr,SPar:string;var n:word); virtual;
    procedure CmSaveScanSkipItem(n:word); virtual;
    procedure CmReadScanSkipItem(var n:word); virtual;
    procedure CmSaveScanFirstItem(n:word); virtual;
    procedure CmReadScanFirstItem(var n:word); virtual;
    procedure CmSaveField(id:longint; FieldContent:TEKRowContent); virtual;
    procedure CmUpdateField(n:longint; tp:TEkRcTypes; defined:boolean); virtual;
    procedure CmReadField(var FieldContent:TEKRowContent); virtual;
    procedure CmSaveExprBeginItem(FieldContent:TEKRowContent; InDocument,IsManage:boolean; ScanNum:word); virtual;
    procedure CmReadExprBeginItem(var FieldContent:TEKRowContent; var InDocument,IsManage:boolean; var ScanNum:word); virtual;
    procedure CmSaveExprEndItem; virtual;
    procedure CmReadExprEndItem; virtual;
    procedure CmSaveExecuteUDFItem(udfnumber,parcount,iifnumber, argnumber, mainudfnumber:longint); virtual;
    procedure CmReadExecuteUDFItem(out udfnumber,parcount,iifnumber, argnumber, mainudfnumber:longint); virtual;


    procedure SetOutfToNil;
    procedure SetOutfToTmp;
    procedure SetOutf;
    procedure FreeOutf;
    procedure CreateCmStream;
    procedure FreeCmStream;
    procedure SeekToBeginCmStream;
    procedure CreateTmpStream;
    procedure FreeTmpStream;
    procedure ResetIifNumber;
    function GetNextIifNumber:longint;

    function GetVarTypeByNumber(number: integer): TEkDataType;
    function GetVarByNumber(number:integer):string;

    function CtoN(c: string): integer; virtual;
    function SplitArgs(s:string; var List:TStringList):boolean;
    function LeftQuote(c:char):boolean; virtual; abstract;
    function RightQuote(lc,rc:char):boolean; virtual; abstract;
    function IsQuoted(s:string):boolean; virtual; abstract;
    function CheckFormat(var s:string):TEkFieldFormat;
    function DateConstToStr(s:string):string;
    function GetNextExprOperation(var ex, nextop, tail:string; Unary:boolean):boolean;
    function GetNextExprField(var ex, nextfield, tail:string; DotAsColon:boolean):integer;
    function ConvertExpression(var ex:string; DotAsColon:boolean):string;
    procedure ReadFileBody;
    procedure FreePFile;
    procedure wr(s:string);
    procedure wrBlock(Arb:ByteArray; index,ln:longint);
    function  FileEof:boolean;
    //function FileBof:boolean;

    function  GetUDFNumber(s:string; out udfnumber:longint):boolean;
    function  GetArgMinCount(udfnumber:longint):longint;
    function  GetArgMaxCount(udfnumber:longint):longint;
    function  GetUDFResultType(udfnumber:longint):longint;
    function  CheckUdfFormat(var udfnumber:longint; var infmtvar:TEkFieldFormat):boolean;
    function  ProcessUDFName(fname:string; udfargs:TStringList; out udfnumber:longint):boolean;
    procedure IncPnt(delta:longint);

    property PFile:ByteArray read FPfile;
    property Pnt:longint read Fpnt write Fpnt;
    property Lent:longint read Flent write Flent;
    property LastBoundaryPnt: longint read FLastBoundaryPnt write FLastBoundaryPnt;
    property KwdPnt: longint read FKwdPnt write FKwdPnt;
    property Szi:longint read FSzi;
    property UseStream:boolean read FUseStream write FUseStream;
    property TmLoaded:boolean read FTmLoaded;
    property IsExecute:boolean read FExecute write FExecute;
    property InDList:TStringList read FInDlist write FInDList;
    property InDListOneCharExists:boolean read FInDListOneCharExists write FInDListOneCharExists;

    property OutputUserStream:TStream read FOutStream write FOutStream;
    property TmpStream:TStream read FTmpStream;
    property Outf:TStream read FOutf;
    property OutfCreated:boolean read FOutfCreated;
    property CmLastId:longint read FCmLastId;
    property CmLastPnt:longint read FCmLastFpnt;
    property CmSkip:longint read FCmSkip;
    property CmPos:longint read FCmPos;
    property CmStream:TMemoryStream read FCmStream;

  public
    function GetVarNumber(ident:string):integer;
    function Letter(ch:char):boolean;
    function Digit(ch:char):boolean;
    function ZeroOut(s:string):boolean;

    property DecimalRTerminator:char read FDecimalRTerminator write FDecimalRTerminator;
    property DecimalRSeparator:char read FDecimalRSeparator write FDecimalRSeparator;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Notification(AComponent:TComponent; Operation:TOperation); override;
    function ShellOpenFile(const FileName:string; ShowCmd: Integer): THandle; virtual;
    function CreateTmpFileName(Prefix: String): String;
    procedure FreeTemplate;
    procedure SetTemplateBuffer(Buffer:ByteArray; Size:longint);
    function VarByName(VarName:string):TEkReportVariable;
    procedure ClearVars;
    procedure CreateVar(Name:string; Value:string);overload;
    procedure CreateVar(Name:string; Value:Double);overload;
    procedure CreateVar(Name:string; Value:Extended);overload;
    procedure CreateVar(Name:string; Value:TDateTime; IgnoreTime:boolean);overload;
    procedure CreateVar(Name:string; Value:boolean);overload;
    procedure FreeVar(Name:string);
    function Version:longint;

  published

    property OnFinished:TNotifyEvent read FOnFinished write SetOnFinished;

    property InFile:TFileName read FInFile write SetInFile;
    property OutFile:TFileName read FOutFile write SetOutFile;
    property VarList:TEkVarList read FVarList write SetVarList;
    property TrueValue:string read FTrueValue write SetTrueValue;
    property FalseValue:string read FFalseValue write SetFalseValue;
    property UDFList:TEkUDFList read FUDFList write SetUDFList;
    property UnicodeByDefault:boolean read FUnicodeByDefault write FUnicodeByDefault;
  end;

  type
  TEkColor=class
  private
   fr,fg,fb:byte;
  protected
   function GetColor:TColor;
   procedure SetColor(Value:TColor);
   procedure SetFr(Value:byte);
   procedure SetFg(Value:byte);
   procedure SetFb(Value:byte);
  public
   constructor create;
   property r:byte read fr write Setfr;
   property g:byte read fg write Setfg;
   property b:byte read fb write Setfb;
   property color:TColor read GetColor write SetColor;
  end;

  TEkColorArray=array of TEkColor;

  //Report options
  TEkRTFOption=(eoGraphicsWmfCompatible, eoGraphicsBinary, eoClearMissedFields,
                   eoDotAsColon, eoNumericFormatClearZero, eoKeepFrtfPar, eoProcessFormFields);
  TEkRTFOptions=set of TEkRTFOption;

  TEkOutTabRec = record
                 n1, n2, id:longint;
                 end;
  TEkOutTabArray = array of TEkOutTabRec;

  TEkFontStringList = class(TStringList);

  TEkColorStringList = class(TStringList)
  public
    function UseColor(s:string):longint;
  end;

     TEkImageFormat=class
           private
            FSizeXmm, FSizeYmm:Double;
            FSizeX,FSizeY:Word;
            FScaleX,FScaleY:Word;
            FBorder:TEkImageBorder;
            FBorderTwips:byte;
            FProportional:boolean;
           protected
            procedure SetScaleX(Value:Word);
            procedure SetScaleY(Value:Word);
            procedure SetSizeXmm(Value:Double);
            procedure SetSizeYmm(Value:Double);
            procedure SetBorder(Value:TEkImageBorder);
           public
            constructor create(x,y:word);
            procedure FitScaleToX(x:word);
            procedure FitScaleToY(y:word);
            procedure SetSizeXY(x,y:word);
            procedure SetBorderType(BrType:TEkImageBorderType; BrWidth:Single; ColorIndex:Word);
            property SizeX:Word read FSizeX;
            property SizeY:Word read FSizeY; //Size X,Y in pixels
            property ScaleX:Word read FScaleX write SetScaleX;
            property ScaleY:Word read FScaleY write SetScaleY; //Scale 1-100
            property SizeXmm:Double read FSizeXmm write SetSizeXmm;
            property SizeYmm:Double read FSizeYmm write SetSizeYmm;
            property Border:TEkImageBorder read FBorder;
            property BorderTwips:byte read FBorderTwips;
            property Proportional:boolean read FProportional write FProportional;
           end;//TEkImageFormat

  TEkOnImageFormat = procedure(FormatIndex:integer; var ImageFormat:TEkImageFormat) of object;

  TEkBaseRTFReport=class(TEkBaseReport)
  private
    FOutTab:TEkOutTabArray;

    FCharset:TFontCharset;
    FLang:TEkLanguageID;

    FQuoteIndex:longint;
    FQuoteSkip:longint;
    FQuoteStr:string;

    FIsFontTable:boolean;
    FIsColorTable:boolean;
    FIsStyle:boolean;
    FIsDocInfo:boolean;
    FInTable:boolean;
    FTableRowOpen:boolean;

    FDocColorCount:Word;    //Color count in table in input file
    FDocColorTable:TEkColorArray; //Colors in color table in input file
    FColorCount:Word;       //16
    FColorTable:TEkColorArray;

    FRTFFont:TEkFontStringList;  //list for font table ***!!!
    FRTFColor:TEkColorStringList;
    FRTFStyle:TStringList;
    FRTFDocInfo:TStringList;

    FOptions:TEkRTFOptions;

    FUnicodeSkipCount:longint; //То что придет в \uc<N> по умолчанию 1
    FUcStack:TEkIntStack;

  protected
    function GetCharset: TFontCharset;
    procedure SetCharset(Value: TFontCharset);
    function GetLang: TEkLanguageID;
    procedure SetLang(Value:TEkLanguageID);
    procedure SetOptions(Value:TEkRTFOptions);

    procedure CmSaveFontTable;
    procedure CmReadFontTable;
    procedure CmSaveColorTable;
    procedure CmReadColorTable;
    procedure CmSaveStyleSheet;
    procedure CmReadStyleSheet;
    procedure CmSaveDocInfo;
    procedure CmReadDocInfo;

    procedure ReadFb(var ch:AnsiChar);
    procedure ReadBack(var ch:AnsiChar);
    function LeftQuote(c:char):boolean; override;
    function RightQuote(lc,rc:char):boolean; override;
    function IsQuoted(s:string):boolean; override;

    procedure OutRaw;
    procedure OutColorTable;
    procedure OutFontTable;
    procedure OutStyle;

    procedure SaveToOutTable(fid:longint);
    procedure CutRtString(rtstring:string; var fldstring, outstring:string);
    function getns(n:integer):string;
    function GetNextReportField:string;
    function KillPar:string;


    property IsFontTable:boolean read FIsFontTable write FIsFontTable;
    property IsColorTable:boolean read FIsColorTable write FIsColorTable;
    property IsStyle:boolean read FIsStyle write FIsStyle;
    property IsDocInfo:boolean read FIsDocInfo write FIsDocInfo;
    property DocColorTable:TEkColorArray read FDocColorTable write FDocColorTable;
    property DocColorCount:Word read FDocColorCount write FDocColorCount;

    property OutTab:TEkOutTabArray read FOutTab write FOutTab;
    property UnicodeSkipCount:longint read FUnicodeSkipCount write FUnicodeSkipCount;
    property UcStack:TEkIntStack read FUcStack;

  public
    property RTFFont:TEkFontStringList read FRTFFont write FRTFFont;
    property RTFColor:TEkColorStringList read FRTFColor write FRTFColor;
    property RTFStyle:TStringList read FRTFStyle write FRTFStyle;
    property RTFDocInfo:TStringList read FRTFDocInfo write FRTFDocInfo;

    property InTable:boolean read FInTable write FInTable;
    property ColorTable:TEkColorArray read FColorTable;
    property ColorCount:Word read FColorCount;

    function txt2rtf(s:string):string;
    function CreateFileName(Directory, Prefix: string): string; overload; virtual;
    function CreateFileName(Directory, Prefix, Extension: string): string; overload; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Charset: TFontCharset read GetCharset write SetCharset;
    property Lang:TEkLanguageID read GetLang write SetLang;
    property Options:TEkRTFOptions read FOptions write SetOptions;
  end;

  function DateToVarStr(Date:TDateTime):string;
  function VarStrToDate(s:string):TDateTime;  
  function DateTimeToVarStr(Date:TDateTime):string;
  function VarStrToDateTime(s:string):TDateTime;

implementation
uses ShellApi;

{----------------- common functions -------------------}
function DateToVarStr(Date:TDateTime):string;
var Year,Month,Day:Word;
begin
   DecodeDate(Date,Year,Month,Day);
   Result:='{'+FormatFloat('0000',Year)+'-'
              +FormatFloat('00',Month)+'-'
              +FormatFloat('00',Day)+'}';
end;


function VarStrToDate(s:string):TDateTime;
var Year,Month,Day:Word;
begin
   if length(s)<12 then raise Exception.Create(s+' is not a valid date value');
   Year:=StrToInt(copy(s,2,4));
   Month:=StrToInt(copy(s,7,2));
   Day:=StrToInt(copy(s,10,2));
   Result:=EncodeDate(Year,Month,Day);
end;

function DateTimeToVarStr(Date:TDateTime):string;
var Year,Month,Day:Word;
    Hour,Min,Sec,MSec:Word;
begin
   DecodeDate(Date,Year,Month,Day);
   DecodeTime(Date,Hour,Min,Sec,MSec);
   //{2002-12-01,12:00:00:000}
   Result:='{'+FormatFloat('0000',Year)+'-'
              +FormatFloat('00',Month)+'-'
              +FormatFloat('00',Day)+','
              +FormatFloat('00',Hour)+':'
              +FormatFloat('00',Min)+':'
              +FormatFloat('00',Sec)+':'
              +FormatFloat('000',MSec)+'}';
end;

function VarStrToDateTime(s:string):TDateTime;
var Year,Month,Day:Word;
    Hour,Min,Sec,MSec:Word;
begin
   if length(s)<12 then raise Exception.Create(s+' is not a valid datetime value');
   Year:=StrToInt(copy(s,2,4));
   Month:=StrToInt(copy(s,7,2));
   Day:=StrToInt(copy(s,10,2));
   Hour:=0;
   Min:=0;
   Sec:=0;
   MSec:=0;
   if (length(s)=25) and (s[12]=',') then begin
       Hour:=StrToInt(copy(s,13,2));
       Min:=StrToInt(copy(s,16,2));
       Sec:=StrToInt(copy(s,19,2));
       MSec:=StrToInt(copy(s,22,3));
   end;
   Result:=EncodeDate(Year,Month,Day)+EncodeTime(Hour,Min,Sec,MSec);
end;

function TEkBaseReport.CreateTmpFileName(Prefix: String): String;
var
  Path : array[0..MAX_PATH] of Char;
    sf : array[0..MAX_PATH] of Char;
begin
    FillChar(Path,SizeOf(Path),#0);
    FillChar(sf,SizeOf(sf),#0);
    GetTempPath(MAX_PATH,Path);
    GetTempFilename(Path, PChar(Prefix), 0, sf);
    Result := sf;
end;


function TEkBaseReport.Letter(ch:char):boolean;
begin
Result:=false;
if ((ch>='a') and (ch<='z')) or ((ch>='A') and (ch<='Z')) then Result:=true;
end;


function TEkBaseReport.Digit(ch:char):boolean;
begin
Result:=false;
if (ch='0') or(ch='1') or (ch='2') or (ch='3') or
   (ch='4') or (ch='5') or (ch='6') or (ch='7') or
   (ch='8') or (ch='9') then Result:=True;
end; //Digit

function TEkBaseReport.ZeroOut(s:string):boolean;
var f,ln:longint;
begin
 Result:=true;
 ln:=length(s);
 for f:=1 to ln do if (Digit(s[f])) and (s[f]<>'0') then begin Result:=false; exit; end;
end;

function TEkBaseReport.CtoN(c: string): integer;
var s,sn:string;
    lnts:integer;
begin
   s:=UpperCase(trim(c));
   lnts:=Length(s);

   if lnts=0 then begin Result:=-1; exit; end;

   //If there is DataSets with name length = 1

   //Если есть хотя бы один датасет с именем из одной буквы, то надо возвращать его номер из списка
   //по его имени, а не по порядку символов A..Z
   if (FInDListOneCharExists) and (lnts=1) then begin
       sn:=FInDList.Values[s];
       if length(sn)>0 then begin Result:=strtoint(sn); exit; end;
   end;//if

   //Номер по порядку символов A..Z
   if (lnts=1) and (s>='A') and (S<='Z')
      then begin Result:=ord(S[1])-ord('A'); exit; end;

   //Если алиас больше чем из одной буквы, то просто возвращаем индекс по его имени
   sn:=FInDList.Values[s];
   if length(sn)>0 then Result:=strtoint(sn) else Result:=-1;
end;//TEkBaseReport.CtoN


{ TEkReportVariable }
constructor TEkReportVariable.create(VarOwner:TEkBaseReport);
begin
 FOwnerBaseReport:=VarOwner;
 FVarName:='';
 if VarOwner=nil then FLocal:=true else FLocal:=false;
 FLocalValue:='';
 FLocalType:=ekdtUnknown;
 FmtSett:= TFormatSettings.Create;
 FmtSett := FormatSettings; //20160301 Igor
end;

procedure TEkReportVariable.SetLocal(Value:boolean);
begin
 if Flocal<>Value then begin
    Flocal:=Value;
    FLocalValue:='';
    FLocalType:=ekdtUnknown;
 end;
end;

procedure TEkReportVariable.SetVarName(VarName:string);
begin
  FVarName:=VarName;
end;

procedure TEkReportVariable.ChangeVarName(NewVarName:string);
var firstname,s:string;
    n,p,l:integer;
begin
 firstname:=FVarName;
 if not Local then begin
    With OwnerBaseReport do
    begin
     n:=GetVarNumber(firstname);
     if n=0 then raise EIOError.create('Report variable not found: '+firstname);
     if GetVarNumber(NewVarName)>0 then raise EIOError.create('Can''t set variable name to '+NewVarName+', because variable with the same name already exists');
     s:=FVarList.Strings[n-1];
     p:=pos('=',s);
     l:=length(s);
       if (p>0) and (l>p) then begin
          s:=NewVarName+'='+copy(s,p+1,l-p);
       end else begin
          s:=NewVarName+'=';
       end;
     FVarList.Strings[n-1]:=s;
    end;//with
 end;//if not local
 FVarName:=NewVarName;
end;

function TEkReportVariable.GetCheckVarNumber(ErrMsg:string):longint;
begin
 Result:=0;
 if not Local then begin
    With OwnerBaseReport do
    begin
    Result:=GetVarNumber(FVarName);
    if Result=0 then raise EIOError.create(ErrMsg+': report variable not found: '+FVarName);
    end;//with
 end;//if not local
end;

function TEkReportVariable.GetAsString: string;
var i:longint;
    s:string;
begin
  Result:='';
  if Local then begin
    s:=FLocalValue;
  end else begin
    With OwnerBaseReport do
    begin
      i:=GetCheckVarNumber('Get variable');
      s:=GetVarByNumber(i);
    end;//with
  end;//if local

  case DataType of
  ekdtNumber:begin
              if FmtSett.DecimalSeparator <> '.' then begin
               i:=pos('.',s);
               if i>0 then s[i]:=FmtSett.DecimalSeparator;
              end;
             end;//ekdtNumber
  ekdtDateTime:begin
                {2002-12-01,12:00:00:000}
                  if length(s)>=12 then begin
                     if s[12]=',' then begin
                       //Date with time
                       s:=DateTimeToStr(VarStrToDateTime(s));
                     end else begin
                      //Date witout time
                       s:=DateToStr(VarStrToDate(s));
                     end;
                  end;
               end;//ekdtDateTime
  end;//case
  Result:=s;

end;//TEkReportVariable.GetAsString

procedure TEkReportVariable.SetAsString(Value: string);
var i:longint;
begin
  if Local then begin
    FLocalValue:=Value;
    FLocalType:=ekdtString;
  end else begin
     With OwnerBaseReport do
     begin
       i:=GetCheckVarNumber('Set variable');
       dec(i);
       FVarList.Strings[i]:=FVarName+'='+Value;
       if not Assigned(FVarList.Objects[i]) then FVarList.Objects[i]:=TEkVarListObject.Create;
       TEkVarListObject(FVarList.Objects[i]).FDataType:=ekdtString;
     end;//with
  end;//if local
end;//TEkReportVariable.SetAsString

function TEkReportVariable.GetAsFloat: Extended;
var i,pdc:longint;
    sv:string;
begin
  if Local then begin
    sv:=FLocalValue;
  end else begin
    With OwnerBaseReport do
    begin
    i:=GetCheckVarNumber('Get variable');
    sv:=GetVarByNumber(i);
    end;//with
  end;//if local

   if length(Trim(sv))=0 then sv:='0';
   if FmtSett.DecimalSeparator<>'.' then begin
       pdc:=pos('.',sv);
       if pdc>0 then sv[pdc]:=FmtSett.DecimalSeparator;
   end;
   Result:=StrToFloat(sv);

end;//TEkReportVariable.GetAsFloat

procedure TEkReportVariable.SetAsFloat(Value: Extended);
var i,pdc:longint;
    s:string;
begin
  s:=FloatToStr(Value);
  if FmtSett.DecimalSeparator<>'.' then begin
      pdc:=pos(FmtSett.DecimalSeparator,s);
      if pdc>0 then s[pdc]:='.';
  end;

  if Local then begin
     FLocalValue:=s;
     FLocalType:=ekdtNumber;
  end else begin
     With OwnerBaseReport do
     begin
       i:=GetCheckVarNumber('Set variable');
       dec(i);
       FVarList.Strings[i]:=FVarName+'='+s;
       if not Assigned(FVarList.Objects[i]) then FVarList.Objects[i]:=TEkVarListObject.Create;
       TEkVarListObject(FVarList.Objects[i]).FDataType:=ekdtNumber;
     end;//with
  end;//if local

end;//TEkReportVariable.SetAsFloat

function TEkReportVariable.GetAsInteger: int64;
var i:longint;
    sv:string;
begin
  if Local then begin
     sv:=FLocalValue;
     if length(Trim(sv))=0 then sv:='0';
     Result:=StrToInt64(sv);
  end else begin
     With OwnerBaseReport do
     begin
     i:=GetCheckVarNumber('Get variable');
     sv:=GetVarByNumber(i);
     if length(Trim(sv))=0 then sv:='0';
     Result:=StrToInt64(sv);
     end;//with
  end;//if local
end;//TEkReportVariable.GetAsFloat

procedure TEkReportVariable.SetAsInteger(Value: int64);
var i:longint;
begin
  if Local then begin
     FLocalValue:=IntToStr(Value);
     FLocalType:=ekdtNumber;
  end else begin
     With OwnerBaseReport do
     begin
       i:=GetCheckVarNumber('Set variable');
       dec(i);
       FVarList.Strings[i]:=FVarName+'='+IntToStr(Value);
       if not Assigned(FVarList.Objects[i]) then FVarList.Objects[i]:=TEkVarListObject.Create;
       TEkVarListObject(FVarList.Objects[i]).FDataType:=ekdtNumber;
     end;//with
  end;//if local
end;//TEkReportVariable.SetAsFloat

function TEkReportVariable.GetAsDate: TDateTime;
var i:longint;
begin
  if Local then begin
     Result:=VarStrToDate(FLocalValue);
  end else begin
     With OwnerBaseReport do
     begin
     i:=GetCheckVarNumber('Get variable');
     Result:=VarStrToDate(GetVarByNumber(i));
     end;//with
  end;//if local
end;//TEkReportVariable.GetAsDate

procedure TEkReportVariable.SetAsDate(Value: TDateTime);
var i:longint;
begin
  if Local then begin
     FLocalValue:=DateToVarStr(Value);
     FLocalType:=ekdtDateTime;
  end else begin
     With OwnerBaseReport do
     begin
       i:=GetCheckVarNumber('Set variable');
       dec(i);
       FVarList.Strings[i]:=FVarName+'='+DateToVarStr(Value);
       if not Assigned(FVarList.Objects[i]) then FVarList.Objects[i]:=TEkVarListObject.Create;
       TEkVarListObject(FVarList.Objects[i]).FDataType:=ekdtDateTime;
     end;//with
  end;//if local
end;//TEkReportVariable.SetAsDate

function TEkReportVariable.GetAsDateTime: TDateTime;
var i:longint;
begin
  if Local then begin
    Result:=VarStrToDateTime(FLocalValue);
  end else begin
    With OwnerBaseReport do
    begin
    i:=GetCheckVarNumber('Get variable');
    Result:=VarStrToDateTime(GetVarByNumber(i));
    end;//with
  end;//if local
end;//TEkReportVariable.GetAsDateTime

procedure TEkReportVariable.SetAsDateTime(Value: TDateTime);
var i:longint;
begin
  if Local then begin
     FLocalValue:=DateTimeToVarStr(Value);
     FLocalType:=ekdtDateTime;
  end else begin
     With OwnerBaseReport do
     begin
       i:=GetCheckVarNumber('Set variable');
       dec(i);
       FVarList.Strings[i]:=FVarName+'='+DateTimeToVarStr(Value);
       if not Assigned(FVarList.Objects[i]) then FVarList.Objects[i]:=TEkVarListObject.Create;
       TEkVarListObject(FVarList.Objects[i]).FDataType:=ekdtDateTime;
     end;//with
  end;//if local
end;//TEkReportVariable.SetAsDateTime

function TEkReportVariable.GetAsBoolean: boolean;
var i:longint;
    s:string;
begin
  if Local then begin
     s:=FLocalValue;
     Result:=false; if (s=OwnerBaseReport.FTrueValue)or(UpperCase(s)='TRUE') then Result:=true;
  end else begin
     With OwnerBaseReport do
     begin
      i:=GetCheckVarNumber('Get variable');
      s:=GetVarByNumber(i);
      Result:=false;
      if (s=FTrueValue)or(UpperCase(s)='TRUE') then Result:=true;
     end;//with
  end;//if local
end;//TEkReportVariable.GetAsBoolean

procedure TEkReportVariable.SetAsBoolean(Value: boolean);
var i:longint;
    s:string;
begin

  With OwnerBaseReport do begin
    if Value then s:=FTrueValue else s:=FFalseValue;
    if FTrueValue=FFalseValue then
    begin
       if Value then s:='True' else s:='False';
    end;
  end;//with

  if Local then begin
     FLocalValue:=s;
     FLocalType:=ekdtBoolean;
  end else begin
     With OwnerBaseReport do
     begin
       i:=GetCheckVarNumber('Set variable');
       dec(i);
       FVarList.Strings[i]:=FVarName+'='+s;
       if not Assigned(FVarList.Objects[i]) then FVarList.Objects[i]:=TEkVarListObject.Create;
       TEkVarListObject(FVarList.Objects[i]).FDataType:=ekdtBoolean;
     end;//with
  end;//if local

end;//TEkReportVariable.SetAsBoolean


function TEkReportVariable.GetDataType: TEkDataType;
var i:longint;
begin
  if Local then begin
    Result:=FLocalType;
  end else begin
    With OwnerBaseReport do
    begin
      i:=GetCheckVarNumber('Get variable');
      Result:=GetVarTypeByNumber(i);
    end;//with
  end;//if local
end;//TEkReportVariable.GetDataType

function TEkReportVariable.GetDataTypeText: string;
begin
  case DataType of
    ekdtUnknown: Result:='Unknown';
    ekdtBoolean: Result:='Boolean';
    ekdtString: Result:='String';
    ekdtNumber: Result:='Number';
    ekdtDateTime: Result:='DateTime';
  end;
end;//TEkReportVariable.GetDataTypeText

function DataType2Int(Dt:TEkDataType): integer;
begin
  Result:=-1;
  case Dt of
    ekdtString: Result:=0;
    ekdtNumber: Result:=1;
    ekdtBoolean: Result:=2;
    ekdtDateTime: Result:=3;
  end;
end;

function Int2DataType(i:integer): TEkDataType;
begin
  Result:=ekdtUnknown;
  case i of
    0:Result:=ekdtString;
    1:Result:=ekdtNumber;
    2:Result:=ekdtBoolean;
    3:Result:=ekdtDateTime;
  end;
end;


function TEkReportVariable.GetDataTypeNumber: integer;
begin
  Result:=DataType2Int(DataType);
end;//TEkReportVariable.GetDataTypeNumber


procedure TEkReportVariable.SetDataType(const Value: TEkDataType);
var i:longint;
begin
  if Local then begin
    FLocalType:=Value;
  end else begin
     With OwnerBaseReport do
     begin
       i:=GetCheckVarNumber('Set variable');
       dec(i);
       if not Assigned(FVarList.Objects[i]) then FVarList.Objects[i]:=TEkVarListObject.Create;
       TEkVarListObject(FVarList.Objects[i]).FDataType:=Value;
     end;//with
  end;//if local
end;//TEkReportVariable.SetDataType


{ TEkBaseReport }

procedure TEkBaseReport.ClearVars;
begin
 VarList.Clear;
 FReportVariable.SetVarName('');
end;

procedure TEkBaseReport.CreateVar(Name: string; Value: boolean);
var vi:integer;
begin
   if GetVarNumber(Name)>0 then raise EIOError.create('Can''t add report variable '+Name+' - variable already exists')
      else begin
             if value then vi:=VarList.Add(Trim(Name)+'='+FTrueValue)
                      else vi:=VarList.Add(Trim(Name)+'='+FFalseValue);
             VarList.Objects[vi]:=TEkVarListObject.Create;
             TEkVarlistObject(VarList.Objects[vi]).FDataType:=ekdtBoolean;
           end;//if
end;//CreateVar boolean

procedure TEkBaseReport.CreateVar(Name, Value: string);
var vi:integer;
begin
   if GetVarNumber(Name)>0 then raise EIOError.create('Can''t add report variable '+Name+' - variable already exists')
      else begin
             vi:=VarList.Add(Trim(Name)+'='+Value);
             VarList.Objects[vi]:=TEkVarListObject.Create;
             TEkVarlistObject(VarList.Objects[vi]).FDataType:=ekdtString;
           end;
end;//CreateVar string

procedure TEkBaseReport.CreateVar(Name: string; Value: Double);
var vi,pdc:integer;
         s:string;
begin
   if GetVarNumber(Name)>0 then raise EIOError.create('Can''t add report variable '+Name+' - variable already exists')
      else begin
            s:=FloatToStr(Value);
            if FmtSett.DecimalSeparator<>'.' then begin
                pdc:=pos(FmtSett.DecimalSeparator,s);
                if pdc>0 then s[pdc]:='.';
            end;
            vi:=VarList.Add(Trim(Name)+'='+s);
            VarList.Objects[vi]:=TEkVarListObject.Create;
            TEkVarlistObject(VarList.Objects[vi]).FDataType:=ekdtNumber;
           end;
end;//CreateVar Double

procedure TEkBaseReport.CreateVar(Name: string; Value: Extended);
var vi,pdc:integer;
    s:string;
begin
   if GetVarNumber(Name)>0 then raise EIOError.create('Can''t add report variable '+Name+' - variable already exists')
      else begin
           s:=FloatToStr(Value);
           if FmtSett.DecimalSeparator<>'.' then begin
               pdc:=pos(FmtSett.DecimalSeparator,s);
               if pdc>0 then s[pdc]:='.';
           end;
            vi:=VarList.Add(Trim(Name)+'='+s);
            VarList.Objects[vi]:=TEkVarListObject.Create;
            TEkVarlistObject(VarList.Objects[vi]).FDataType:=ekdtNumber;
           end;
end;//CreateVar Extended

procedure TEkBaseReport.CreateVar(Name: string; Value: TDateTime;
  IgnoreTime: boolean);
var vi:integer;
begin
   if GetVarNumber(Name)>0 then raise EIOError.create('Can''t add report variable '+Name+' - variable already exists')
      else begin
             if IgnoreTime then vi:=VarList.Add(Trim(Name)+'='+DateToVarStr(Value))
                           else vi:=VarList.Add(Trim(Name)+'='+DateTimeToVarStr(Value));
             VarList.Objects[vi]:=TEkVarListObject.Create;
             TEkVarlistObject(VarList.Objects[vi]).FDataType:=ekdtDateTime;
           end;
end;//CreateVar DateTime

procedure TEkBaseReport.FreeTemplate;
begin
     if FTmLoaded then
     begin
        try FreePFile; except end;
        FTmLoaded:=false;
        Fpnt:=1; Flent:=-1;
     end;
end;

procedure TEkBaseReport.FreeVar(Name: string);
var i:longint;
begin
  i:=GetVarNumber(Name);
  if i>0 then VarList.Delete(i-1);
end;

procedure TEkBaseReport.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation=opRemove ) and (AComponent=FUDFList) then
    FUDFList:=nil;
end;

procedure TEkBaseReport.SetInFile(Value: TFileName);
begin
  if Value<>FInFile then
     begin
         FTmLoaded:=false;
         FInFile:=Value;
     end;
end;

procedure TEkBaseReport.SetOutFile(Value: TFileName);
begin
  if Value<>FOutFile then FOutFile:=Value;
end;

procedure TEkBaseReport.SetOnFinished(Value: TNotifyEvent);
begin
  FOnFinished := Value;
end;

procedure TEkBaseReport.FreePFile;
begin
   SetLength(FPFile,0);
   FPFile:=nil;
end;

procedure TEkBaseReport.SetTemplateBuffer(Buffer:ByteArray; Size:longint);
begin
 if not FExecute then
 begin
     FPFile:=Buffer;
     flent:=size;
     FTmLoaded:=true;
     FInFile:='';
  end else
      begin
      raise EIOError.create('Can''t set template while executing report');
      end;//if not FExecute;
end;

procedure TEkBaseReport.SetTrueValue(Value: string);
begin
   if Value<>FTrueValue then FTrueValue:=Value;
end;

procedure TEkBaseReport.SetFalseValue(Value: string);
begin
   if Value<>FFalseValue then FFalseValue:=Value;
end;

procedure TEkBaseReport.SetUDFList(Value: TEkUDFList);
begin
  if Value<>FUDFList then begin
  if not FExecute then begin

    if Value<>nil then begin
         if Self.version<>Value.version then begin
          raise EIllegalFunctionUse.Create('TEkRTF version '+inttostr(Self.Version)+' doesn''t equal TEkUDFList version '+inttostr(Value.Version));
         end else begin
          FUDFList:=Value;
          Value.FreeNotification(Self);
         end;
    end else begin
        FUDFList:=Value;
    end;//if Value<>nil

  end else begin
           raise EIllegalFunctionUse.create('Can''t set UDFList while executing report');
           end;//if not FExecute
  end;//if Value
end;

procedure TEkBaseReport.SetVarList(Value: TEkVarList);
begin
   FVarList.Assign(Value);
end;

function TEkBaseReport.ShellOpenFile(const FileName: string;
  ShowCmd: Integer): THandle;
begin
  Result := ShellExecute(0, nil, PChar(FileName), nil, nil, ShowCmd);
end;

function TEkBaseReport.VarByName(VarName: string): TEkReportVariable;
begin
 FReportVariable.SetVarName(VarName);
 Result:=FReportVariable;
end;

function TEkBaseReport.Version: longint;
begin
Result:=311;
end;

function TEkBaseReport.GetVarTypeByNumber(number: integer): TEkDataType;
begin
  dec(number);
  Result:=ekdtUnknown;
  if Assigned(FVarList.Objects[number]) then begin
     Result:=TEkVarListObject(FVarList.Objects[number]).FDataType;
  end;
end;//GetVarTypeByNumber


function TEkBaseReport.GetVarByNumber(number: integer): string;
var p:integer;
    s:string;
begin
  dec(number);
  s:=FVarList[number];
  p:=pos('=',s);
  if p>1 then
  begin
     Result:=copy(s,p+1,length(s));
  end else begin
           Result:='';
           end;
end;//GetVarByNumber

function TEkBaseReport.GetVarNumber(ident: string): integer;
var f,p,n:integer;
begin

    if Assigned(FVarList) then
                      n:=FVarList.Count
                                    else raise exception.Create('Incorrect using report variable (or variable doesn''t exist):'+ident);

    if n>0 then
    begin
       Result:=0;
          for f:=0 to n-1 do
              begin
               p:=pos('=',FVarList[f]);
               if (p>1) and ( uppercase(copy(FVarList[f],1,p-1))=uppercase(ident) ) then
                  begin Result:=f+1; break; end;
              end;//for
    end else begin
             Result:=0;
             end;
end;//GetVarNumber

function TEkBaseReport.SplitArgs(s: string;
  var List: TStringList): boolean;
var f,ln,nested:integer;
    argone:string;
    lq, c:char;
    inquote:boolean;
begin
   Result:=true;
   if Trim(s)='' then exit;
   s:=s+',';
   ln:=length(s);
   argone:=''; nested:=0; inquote:=false; lq:=' ';
   for f:=1 to ln do
   begin
     c:=s[f];

      if (not inquote) and (LeftQuote(c)) then begin
          inquote:=true; lq:=c;
          argone:=argone+c;
          continue;
          end;

      if (inquote) and (not RightQuote(lq,c)) then begin
          argone:=argone+c;
          continue;
          end;

      if (inquote) and (RightQuote(lq,c)) then begin
         inquote:=false;
         argone:=argone+c;
         continue;
         end;

     if c='(' then inc(nested);
     if c=')' then begin
                   dec(nested);
                   if nested<0 then begin
                      Result:=false; //error
                      list.add(argone);
                      break;
                   end;
              end;

     if (c=',') and (nested=0) then begin
                   list.add(argone); argone:='';
                   continue;
     end;
      argone:=argone+c;
    end;//for

    if nested>0 then begin
                      Result:=false; //error
                      list.add(argone);
                     end;
end; //TEkBaseReport.SplitArgs


function TEkBaseReport.CheckFormat(var s:string):TEkFieldFormat; //Check if format function present
 var p1,p3,ndec,nprec,f,ln,argcount:longint;
     Args:TStringList;
     formatname, sdec,sprec:string;
     isdec:boolean;
     secondarg:string;
 begin
    Result.fmtnumber:=0; //No format eq ffGeneral
    Result.precision:=18;
    Result.decimals:=2;

    //find first '(' after format name
    ln:=length(s);
    if ln=0 then exit;

    f:=1; formatname:='';
    while (f<ln) and letter(s[f]) do inc(f);
    if not ( (s[f]='(')and(f<ln-1)and(s[ln]=')') ) then exit;

    p1:=f; p3:=ln; //p2:=p3;
    formatname:=UpperCase(copy(s,1,p1-1));

    isdec:=false;
    sdec:=''; sprec:=''; ndec:=0; nprec:=0; secondarg:='';

    //Find format name in table
    for f:=Low(EkBaseFormatsArr) to High(EkBaseFormatsArr) do begin
        if formatname=EkBaseFormatsArr[f].name then begin
        Result.fmtnumber:=f; break;
        end;
    end;//for

    if Result.fmtnumber=0 then exit; //format not found, exit with 0 result

    Args:=TStringList.Create;
    try
     if SplitArgs(copy(s,p1+1,p3-p1-1),args) then begin
        argcount:=args.Count;
        if argcount<EkBaseFormatsArr[Result.fmtnumber].argmin  then
           raise EIllegalFunctionUse.create('Illegal format function use: '+s+' - number of arguments is less than minimum required');
        if argcount>EkBaseFormatsArr[Result.fmtnumber].argmax then
           raise EIllegalFunctionUse.create('Illegal format function use: '+s+' - number of arguments is more than maximum allowed');
     end else begin
              raise EIllegalFunctionUse.create('Brackets balance violation in format function '+s);
             end; //if SplitArgs

     s:=string(Args[0]);  //added
     if argcount=2 then begin
        //incorrect search of p2, because "," may be inside string in second argument
        //for f:=ln downto p1 do if s[f]=',' then begin p2:=f; break; end;
        isdec:=true;
        secondarg:=Args[1];
     end;

    finally
     Args.free;
    end;//try

    //if number expected after comma and isdec
    if ((EkBaseFormatsArr[Result.fmtnumber].isfloat) or (Result.fmtnumber=5)) and isdec then
    begin
       for f:=1 to length(secondarg) do begin
           if not ((digit(secondarg[f])) or (secondarg[f]=#32)
                   or ( (secondarg[f]=':') and (f>1) and (f<length(secondarg)) )
                  ) then begin
              raise EIllegalFunctionUse.create('Illegal use of format function '+s+' - cannot understand argument '+secondarg);
           end;
       end;//for

       if (pos(':',secondarg)>1) then
       begin
         sprec:=copy(secondarg,1,pos(':',secondarg)-1);
         nprec:=StrToInt(sprec);
         sdec:=copy(secondarg,pos(':',secondarg)+1,length(secondarg));
         ndec:=StrToInt(sdec);
       end else ndec:=StrToInt(secondarg);
    end;//if

       case Result.fmtnumber of
       //FEXP FFIX FNUM FFIXR FNUMR
       0,1,2,3,7,8:begin
             if isdec then Result.decimals:=ndec;
             if (isdec) and (nprec>0) then Result.precision:=nprec;
             //s:=copy(s,p1+1,p2-p1-1);
             exit;
             end;//FEXP FFIX FNUM FFIXR FNUMR

       //FCUR
       4:begin
         if isdec then Result.decimals:=ndec else Result.decimals:=FmtSett.CurrencyDecimals;
         if (isdec) and (nprec>0) then Result.precision:=nprec;
         //s:=copy(s,p1+1,p2-p1-1);
         exit;
         end;//FCUR

       //FIMG
       5:begin
         Result.ImgFmt:=0;
         if isdec then Result.ImgFmt:=ndec;
         if (isdec) and (nprec>0) then Result.ImgFmt:=nprec;
         //s:=copy(s,p1+1,p2-p1-1);
         exit;
         end;//FIMG

       //FLNK
       6:begin
         //s:=copy(s,p1+1,p2-p1-1);
         exit;
         end;

       //FDTM
       9:begin
         Result.NDtstr:=CmStoreString(secondarg);
         //s:=copy(s,p1+1,p2-p1-1);
         exit;
         end;

       //FBOOL
      10:begin
         //s:=copy(s,p1+1,p2-p1-1);
         exit;
         end;
      //FRTF
      11:begin
         //s:=copy(s,p1+1,p2-p1-1);
         exit;
         end;

       end;//case

end; //function CheckFormat


function TEkBaseReport.DateConstToStr(s: string): string;
begin
  Result:=DateToStr(EncodeDate(strtoint(copy(s,2,4)),strtoint(copy(s,7,2)),strtoint(copy(s,10,2))));
end;


 //Search UDF name in UDFList and in Built in functions such as SUM, CTN ...
function TEkBaseReport.GetUDFNumber(s:string; out udfnumber:longint):boolean;
var f:longint;
begin
   udfnumber:=-1;
   Result:=false;
   if (Assigned(UDFList)) and (UDFList.Count>0) then begin
      udfnumber:=UDFList.FindFunction(s);
      if udfnumber>-1 then begin Result:=true; exit; end;
   end;

   //Search in built in
  udfnumber:=0;
  s:=Trim(UpperCase(s));
  for f:=Low(EkBaseFunctionsArr) to High(EkBaseFunctionsArr) do begin
     if s=EkBaseFunctionsArr[f].name then begin udfnumber:=EkBaseFunctionsArr[f].id; break; end;
  end;
  if udfnumber<0 then Result:=true;
end; //GetUDFNumber


function TEkBaseReport.GetArgMinCount(udfnumber:longint):longint;
begin
   Result:=0;
   if (Assigned(UDFList)) and (udfnumber>-1) then Result:=UDFList.Functions[udfnumber].ArgMinCount;
   if udfnumber<0 then Result:=EkBaseFunctionsArr[-1-udfnumber].argmin;
end;

function TEkBaseReport.GetArgMaxCount(udfnumber:longint):longint;
begin
   Result:=0;
   if (Assigned(UDFList)) and (udfnumber>-1) then Result:=UDFList.Functions[udfnumber].ArgMaxCount;
   if udfnumber<0 then Result:=EkBaseFunctionsArr[-1-udfnumber].argmax;
end;

function TEkBaseReport.GetUDFResultType(udfnumber:longint):longint;
var f:integer;
begin
   Result:=0;
   if udfnumber<0 then begin
      for f:=Low(EkBaseFunctionsArr) to High(EkBaseFunctionsArr) do begin
          if EkBaseFunctionsArr[f].id=udfnumber then begin
                        Result:=EkBaseFunctionsArr[f].ResultType;
                        break;
                        end;
      end;//for
   end;//if
   if (Assigned(UDFList)) and (udfnumber>-1) then Result:=UDFList.Functions[udfnumber].ResultType;
end;

function TEkBaseReport.CheckUdfFormat(var udfnumber:longint; var infmtvar:TEkFieldFormat):boolean;
var f:integer;
   RT:TEkUDFResultType;
begin
   Result:=false;
   RT:=0;
   if udfnumber<0 then begin //built in functions
      for f:=Low(EkBaseFunctionsArr) to High(EkBaseFunctionsArr) do begin
          if EkBaseFunctionsArr[f].id=udfnumber then begin
                        RT:=EkBaseFunctionsArr[f].ResultType;
                        break;
                        end;
      end;//for

      if (infmtvar.fmtnumber>0) and not (RT in EkBaseFormatsArr[infmtvar.fmtnumber].argtype)
                   then Result:=false else Result:=true;
   end;//if<0
   //--------------------------------------------------------------------
   if (Assigned(UDFList)) and (udfnumber>-1) then begin
       if (infmtvar.fmtnumber>0) and not (UDFList.Functions[udfnumber].ResultType
                   in EkBaseFormatsArr[infmtvar.fmtnumber].argtype)
                   then Result:=false else Result:=true;
   end;//if
end;

 //This function gets string 'fname(...,...,...)' and empty TStringList
 //Result is true o false, udfnumber=fn number in UDFList or -number of predefined function
 //udfargs became filled with parameter strings

function TEkBaseReport.ProcessUDFName(fname:string; udfargs:TStringList; out udfnumber:longint):boolean;
var p1,p3,f,ln,argcount:longint;
    udfname,s:string;
begin
    Result:=false;
    s:=fname; //s is string atleast F(A)
    ln:=length(s);
    f:=1; udfname:='';
    p3:=ln;

    if (ln>2) and (s[1]='(') and (s[ln]=')') then begin
       //empty function
       p1:=1;
    end else begin
       //not empty function
       //find first '(' after udf name
       while (f<ln) and (s[f]<>'(') do inc(f);
       if not ( (s[f]='(')and(f<ln)and(s[ln]=')') ) then exit;
       p1:=f; //p1=position of '('
       //p3=position of last ')'
       udfname:=trim(UpperCase(copy(s,1,p1-1)));
    end;//if

    if not GetUDFNumber(udfname,udfnumber) then exit;

    if SplitArgs(copy(s,p1+1,p3-p1-1),udfargs) then begin
       argcount:=udfargs.Count;

       if argcount<GetArgMinCount(udfnumber)  then
          raise EIllegalFunctionUse.create('Illegal function use: '+s+' - number of arguments is less than minimum required');
       if argcount>GetArgMaxCount(udfnumber) then
          raise EIllegalFunctionUse.create('Illegal function use: '+s+' - number of arguments is more than maximum allowed');
    end else begin
             raise EIllegalFunctionUse.create('Brackets balance violation in function '+s);
             end; //if SplitArgs

    Result:=true;

end;//ProcessUDFName


constructor TEkBaseReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPFile:=nil;
  FExecute:=false;
  FTmLoaded:=false;
  Fpnt:=0; Flent:=-1;
  FLastBoundaryPnt:=-1;
  FKwdPnt:=-1;
  FSzi:=sizeof(Fpnt);

  FInFile:='';
  FOutFile:='';

  FTmpStream:=nil;
  FTmpFileName:='';
  FOutStream:=nil;
  FUseStream:=false;
  FOutf:=nil;
  FOutfCreated:=false;

  FiifNumber:=0;

  FCmpos:=0;
  FCmLastId:=-9999; FCmLastFpnt:=0;
  FCmSkip:=0;
  FCmStream:=nil;
  FCmStrings:=nil;

  FInDList:=nil;
  FInDListOneCharExists:=false;

  FVarList:=TEkVarList.create;
  FReportVariable:=TEkReportVariable.create(Self);
  FTrueValue:='True';
  FFalseValue:='False';
  FDecimalRTerminator:='=';
  FDecimalRSeparator:='-';
  FUDFList:=nil;

  FmtSett:= TFormatSettings.Create;
  FmtSett := FormatSettings; //20160301 Igor
  FUnicodeByDefault:=false;
end;

destructor TEkBaseReport.Destroy;
var f:integer;
begin
  FreePFile;
  FCmStrings:=nil;
  FreeTemplate;
  for f:=0 to FVarList.Count-1 do begin
   if Assigned(FVarList.Objects[f]) then FVarList.Objects[f].Free;
  end;
  FVarList.Free;
  FReportVariable.Free;
  inherited Destroy;
end;

procedure TEkBaseReport.ReadFileBody;//Load file or blobfield into memory
var
   ActualRead: Longint;
   //FileHandle: Integer;
   FS        : TFileStream;
   SearchRec : TSearchRec;
        size : Longint;
begin
    Fpnt:=1;
    if not FTmLoaded then
      begin   //load from inFile

      try
        if FindFirst(FInFile, faAnyFile, SearchRec)=0 then
        begin
          size:=SearchRec.Size;
          SetLength(FPFile,size);
          FS := nil;
          try
           //FileHandle := FileOpen(FInFile, fmOpenRead);
           FS := TFileStream.Create(FInFile, fmShareDenyNone);
           //ActualRead := FileRead(FileHandle, FPFile[0], size);
           ActualRead := FS.Read(FPFile[0],size);
           //FileClose(FileHandle);
           Flent:=ActualRead;//size
          finally
           if FS<>nil then FS.Free;
          end;
         if ActualRead<size then begin raise EIOError.create('Can''t read report template from file: '+FInFile); end;
        end else begin
                 raise EIOError.create('Can''t read file '+FInFile);
                 SetLength(FPFile,0);
        end; //if findfirst
      finally
         FindClose(SearchRec);
      end;//try

    end; //if not FFileLoaded

end;//TEkBaseReport.ReadFileBody


procedure TEkBaseReport.IncPnt(delta: Integer);
begin
inc(FPnt,delta);
end;

procedure TEkBaseReport.wr(s:string);
var f,ln:integer;
    a:Array of Byte;
begin
 //D7 Win32 code: FOutf.WriteBuffer(pointer(s)^,length(s));
 if s = '' then exit; //20160301 Igor

 ln:=length(s);
 SetLength(a,ln);
 for f:=1 to ln do a[f-1]:=byte(AnsiString(s)[f]);
 FOutf.Write(a[0],ln); //Write(a,0,ln);
end;//procedure wr

procedure TEkBaseReport.wrBlock(Arb:ByteArray; index,ln:longint);
begin
  //Outf.WriteBuffer((Pfile+CmLastPnt-1)^,Pnt-CmLastPnt);
  Foutf.Write(Arb[index],ln);
end;

function TEkBaseReport.FileEof: boolean;
begin
   Result:=(Fpnt>Flent);
end;

//function TEkBaseReport.FileBof: boolean;
//begin
//   Result:=(Fpnt>1);
//end;

procedure TEkBaseReport.SetOutfToNil;
begin
  FOutf:=nil;
end;

procedure TEkBaseReport.SetOutfToTmp;
begin
  FOutf:=FTmpStream;
end;

procedure TEkBaseReport.SetOutf;
begin
   if UseStream then begin
                      FOutStream.Seek(0,0);
                      FOutf:=FOutStream; //This is user defined out stream - shouldn't be destroyed
                    end else begin
                          FOutf:=TFileStream.create(OutFile,fmCreate);
                          FOutfCreated:=true;
                        end;
end;//SetOutf

procedure TEkBaseReport.FreeOutf;
begin
   //if Outf was set within SetOutf, it will be destroyed here:
   if (not UseStream) then
   begin
            if (FOutfCreated) and (Assigned(FOutf)) then begin
               FOutf.free; FOutf:=nil;
               FOutfCreated:=false;
            end;
   end else   
       if (FOutf=OutputUserStream)
          then FOutf.seek(0,0);
end;//FreeOutf

procedure TEkBaseReport.CreateTmpStream;
begin
  FTmpStream:=nil;
  FTmpFileName:='';
  if (FUseStream) and (FOutStream is TMemoryStream) then begin
     FTmpStream:=TMemoryStream.Create;
  end else begin
     FTmpFileName:=CreateTmpFileName('ekr');
     FTmpStream:=TFileStream.Create(FTmpFileName,fmCreate);
  end;
end;


procedure TEkBaseReport.CreateCmStream;
begin
 FCmStream:=TMemoryStream.Create;
 FCmStream.SetSize(1000);
 FCmStrings:=nil;
 FCmPos:=0; FCmLastId:=-9999;
end;

procedure TEkBaseReport.FreeTmpStream;
begin
   if Assigned(FTmpStream) then begin FTmpStream.free; FTmpStream:=nil; end;
   if (not FUseStream) then DeleteFile(FTmpFileName);
end;

procedure TEkBaseReport.FreeCmStream;
begin
  if (FCmStream)<>nil then begin FCmStream.free; FCmStream:=nil; end;
  FCmStrings:=nil;
  FCmPos:=0; FCmLastId:=-9999;
end;

procedure TEkBaseReport.SeekToBeginCmStream;
begin
 FCmStream.Seek(0,sofrombeginning);
 FCmLastId:=-9999; FCmLastFpnt:=0; FCmPos:=0;
end;

function TEkBaseReport.CmGetString(n: Integer): string;
var i:longint;
begin
  i:=High(FCmStrings);
  if (n>-1) and (n<=i) then Result:=FCmStrings[n] else Result:='';
end;

function TEkBaseReport.CmStoreString(var s: string): longint;
var n:longint;
begin
   n:=High(FCmStrings)+1; //new index
   SetLength(FCmStrings,n+1);
   FCmStrings[n]:=s;
   Result:=n;
end;

procedure TEkBaseReport.CmSaveItemInfo(id, skipbytes, cmfpnt:integer);
begin
  with FCmStream do
  begin
  Write(id, Szi);
  FCmLastId:=id;
  inc(skipbytes,Szi);  //one more fszi for last field FCmPos
  Write(cmfpnt,Szi);
  Write(skipbytes,Szi);
  end;
end;

procedure TEkBaseReport.CmReadItemInfo;
var mpnt:longint;
begin
   With FCmStream do
   begin
     Read(FCmLastId,Szi);
     FCmLastFpnt:=Pnt;
     Read(mpnt,Szi);
     Read(FCmSkip,Szi);
     Pnt:=mpnt;
   end;
end;

procedure TEkBaseReport.CmSaveItemPos;
begin
  FCmStream.Write(Fcmpos,Szi); //first time Fcmpos=0;
  Fcmpos:=FCmStream.Position;
end;

procedure TEkBaseReport.CmReadItemPos;
begin
  FCmStream.Read(Fcmpos,Szi);
end;

procedure TEkBaseReport.CmSaveBegin;
begin
CmSaveItemInfo(-9999,0,Pnt);
CmSaveItemPos;
end;

procedure TEkBaseReport.CmSaveEnd;
begin
CmSaveItemInfo(-10000,0,Pnt);
CmSaveItemPos;
end;

procedure TEkBaseReport.CmSaveBlocItem;
begin
   if CmLastId=-5 then
      begin
        CmStream.Seek(-Szi-Szi-Szi,sofromcurrent);
        CmStream.Write(Pnt,Szi);
        CmStream.Seek(Szi+Szi,sofromcurrent);
      end else begin
               CmSaveItemInfo(-5,0,Pnt);
               //nothing here
               CmSaveItemPos;
               end;
end;

procedure TEkBaseReport.CmReadBlocItem;
begin
  //Nothing to read, just item position
  CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveBalancedBlocItem;
begin
  CmSaveItemInfo(-10,0,Pnt);
  //nothing here
  CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadBalancedBlocItem;
begin
  //Nothing to read, just item position
  CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveTableEnd;
begin
   CmSaveItemInfo(-7,0,Pnt);
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadTableEnd;
begin
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveTableBegin;
begin
   CmSaveItemInfo(-6,0,Pnt);
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadTableBegin;
begin
   //nothing
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveRawItem(var s:string);
var i:longint;
begin
  CmSaveItemInfo(-16,Szi,Pnt);
  i:=CmStoreString(s); CmStream.Write(i,Szi);
  CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadRawItem(var s:string);
var i:longint;
begin
    CmStream.Read(i,Szi); s:=CmGetString(i);
    CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveScanItem(var OutStr,SPar:string; n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-3,Szi+Szi+szn,Pnt);
   With CmStream do
   begin
     i:=CmStoreString(OutStr); Write(i,Szi);
     i:=CmStoreString(Spar);   Write(i,Szi);
     Write(n,szn);
   end;
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadScanItem(var OutStr,SPar:string;var n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   With CmStream do
   begin
    Read(i,Szi); Outstr:=CmGetString(i);
    Read(i,Szi); SPar:=CmGetString(i);
    Read(n,szn);
   end;
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveScanWhileItem(var OutStr,SPar:string; n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-21,Szi+Szi+szn,Pnt);
   With CmStream do
   begin
     i:=CmStoreString(OutStr); Write(i,Szi);
     i:=CmStoreString(Spar);   Write(i,Szi);
     Write(n,szn);
   end;
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadScanWhileItem(var OutStr,SPar:string;var n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   With CmStream do
   begin
    Read(i,Szi); Outstr:=CmGetString(i);
    Read(i,Szi); SPar:=CmGetString(i);
    Read(n,szn);
   end;
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveIfItem(var OutStr,SPar:string; n:word; elseflag:boolean);
var szn, i, nelse : longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-23,Szi+Szi+szn+Szi,Pnt);
   With CmStream do
   begin
     i:=CmStoreString(OutStr); Write(i,Szi);
     i:=CmStoreString(Spar);   Write(i,Szi);
     Write(n,szn);

     nelse:=0;
     if elseflag then nelse:=1;
     Write(nelse,Szi);

   end;
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadIfItem(var OutStr,SPar:string;var n:word; var elseflag:boolean);
var szn, i, nelse : longint;
begin
   szn:=sizeof(word);
   With CmStream do
   begin
    Read(i,Szi); Outstr:=CmGetString(i);
    Read(i,Szi); SPar:=CmGetString(i);
    Read(n,szn);

    Read(nelse, Szi);
    if nelse=1 then elseflag:=true else elseflag:=false;

   end;
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveScanEntryItem(var OutStr,SPar:string; n:word);
var szn,i : longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-11,Szi+Szi+szn,Pnt);
   With CmStream do
   begin
     i:=CmStoreString(OutStr); Write(i,Szi);
     i:=CmStoreString(Spar);   Write(i,Szi);
     Write(n,szn);
   end;
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadScanEntryItem(var OutStr,SPar:string; var n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   With CmStream do
   begin
    Read(i,Szi); Outstr:=CmGetString(i);
    Read(i,Szi); SPar:=CmGetString(i);
    Read(n,szn);
   end;
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveScanFooterItem(var OutStr,SPar:string; n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-12,Szi+Szi+szn,Pnt);
   With CmStream do
   begin
     i:=CmStoreString(OutStr); Write(i,Szi);
     i:=CmStoreString(Spar);   Write(i,Szi);
     Write(n,szn);
   end;
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadScanFooterItem(var OutStr,SPar:string; var n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   With CmStream do
   begin
    Read(i,Szi); Outstr:=CmGetString(i);
    Read(i,Szi); SPar:=CmGetString(i);
    Read(n,szn);
   end;
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveEndScanItem(var OutStr,SPar:string; n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-4,Szi+Szi+szn,Pnt);
   With CmStream do
   begin
     i:=CmStoreString(OutStr); Write(i,Szi);
     i:=CmStoreString(Spar);   Write(i,Szi);
     Write(n,szn);
   end;
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadEndScanItem(var OutStr,SPar:string;var n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   With CmStream do
   begin
    Read(i,Szi); Outstr:=CmGetString(i);
    Read(i,Szi); SPar:=CmGetString(i);
    Read(n,szn);
   end;
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveEndIfItem(var OutStr,SPar:string; n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-24,Szi+Szi+szn,Pnt);
   With CmStream do
   begin
     i:=CmStoreString(OutStr); Write(i,Szi);
     i:=CmStoreString(Spar);   Write(i,Szi);
     Write(n,szn);
   end;
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadEndIfItem(var OutStr,SPar:string;var n:word);
var szn, i : longint;
begin
   szn:=sizeof(word);
   With CmStream do
   begin
    Read(i,Szi); Outstr:=CmGetString(i);
    Read(i,Szi); SPar:=CmGetString(i);
    Read(n,szn);
   end;
   CmReadItemPos;
end;


procedure TEkBaseReport.CmSaveScanSkipItem(n:word);
var szn:longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-22,szn,Pnt);
   CmStream.Write(n,szn);
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadScanSkipItem(var n:word);
var szn:longint;
begin
   szn:=sizeof(word);
   CmStream.Read(n,szn);
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveScanFirstItem(n: word);
var szn:longint;
begin
   szn:=sizeof(word);
   CmSaveItemInfo(-26,szn,Pnt);
   CmStream.Write(n,szn);
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadScanFirstItem(var n: word);
var szn:longint;
begin
   szn:=sizeof(word);
   CmStream.Read(n,szn);
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveField(id:longint; FieldContent:TEKRowContent);
var szfmt, sztype,n:longint;
begin
  szfmt:=sizeof(TEkFieldFormat);
  sztype:=sizeof(TEkRcTypes);
  CmSaveItemInfo(id, 6*Szi+szfmt+sztype+sztype, Pnt);
  With CmStream do
  begin
   n:=CmStoreString(FieldContent.stestf); Write(n,Szi);
   n:=CmStoreString(FieldContent.dalias); Write(n,Szi);
   n:=CmStoreString(FieldContent.field);  Write(n,Szi);
   n:=CmStoreString(FieldContent.sout);   Write(n,Szi);
   Write(FieldContent.fmt,szfmt);
   Write(FieldContent.ftype,sztype);
   Write(FieldContent.NField,Szi);
   Write(FieldContent.definedtype,sztype);
   n:=0;
   if FieldContent.Defined then n:=1;
   Write(n,Szi);
  end;
  CmSaveItemPos;
end;

procedure TEkBaseReport.CmUpdateField(n:longint; tp:TEkRcTypes; defined:boolean);
var szfmt, sztype:longint;
    i:longint;
begin
  szfmt:=sizeof(TEkFieldFormat);
  sztype:=sizeof(TEkRcTypes);
  //Read and Skip item info
  CmReadItemInfo;
  CmStream.Seek(4*Szi+szfmt+sztype, sofromcurrent);
  CmStream.Write(n,Szi); //NField
  CmStream.Write(tp,sztype); //DefinedType
  i:=0;
  if defined then i:=1;
  CmStream.Write(i,Szi);
  //Read and Skip item pos
  CmReadItemPos;
end;

procedure TEkBaseReport.CmReadField(var FieldContent:TEKRowContent);
var szfmt, sztype, n:longint;
    R:TEkRowContent;
begin
  szfmt:=sizeof(TEkFieldFormat);
  sztype:=sizeof(TEkRcTypes);
  With CmStream do
  begin
   Read(n,Szi); R.stestf:=CmGetString(n);
   Read(n,Szi); R.dalias:=CmGetString(n);
   Read(n,Szi); R.field:=CmGetString(n);
   Read(n,Szi); R.sout:=CmGetString(n);
   Read(R.fmt,szfmt);
   Read(R.ftype,sztype);
   Read(R.NField,Szi);
   Read(R.definedtype,sztype);
   Read(n,Szi);
   if n=1 then R.Defined:=true else R.Defined:=false;
  end;//with
  FieldContent:=R;
  CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveExprBeginItem(FieldContent:TEKRowContent; InDocument, IsManage:boolean; ScanNum:word);
var szn, szfmt, sztype,n:longint;
begin
  szn:=sizeof(word);
  szfmt:=sizeof(TEkFieldFormat);
  sztype:=sizeof(TEkRcTypes);
  CmSaveItemInfo(-13, 8*Szi+szfmt+sztype+sztype+szn, Pnt);
  With CmStream do
  begin
   n:=CmStoreString(FieldContent.stestf); Write(n,Szi);
   n:=CmStoreString(FieldContent.dalias); Write(n,Szi);
   n:=CmStoreString(FieldContent.field);  Write(n,Szi);
   n:=CmStoreString(FieldContent.sout);   Write(n,Szi);
   Write(FieldContent.fmt,szfmt);
   Write(FieldContent.ftype,sztype);
   Write(FieldContent.NField,Szi);
   Write(FieldContent.definedtype,sztype);
   n:=0;
   if FieldContent.Defined then n:=1;
   Write(n,Szi);
   n:=0;
   if InDocument then n:=1;
   Write(n,Szi);
   n:=0;
   if IsManage then n:=1;
   Write(n,Szi);
   Write(ScanNum,szn);
  end;
  CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadExprBeginItem(var FieldContent:TEKRowContent; var InDocument, IsManage:boolean; var ScanNum:word);
var szn, szfmt, sztype, n:longint;
    R:TEkRowContent;
begin
  szn:=sizeof(word);
  szfmt:=sizeof(TEkFieldFormat);
  sztype:=sizeof(TEkRcTypes);
  With CmStream do
  begin
   Read(n,Szi); R.stestf:=CmGetString(n);
   Read(n,Szi); R.dalias:=CmGetString(n);
   Read(n,Szi); R.field:=CmGetString(n);
   Read(n,Szi); R.sout:=CmGetString(n);
   Read(R.fmt,szfmt);
   Read(R.ftype,sztype);
   Read(R.NField,Szi);
   Read(R.definedtype,sztype);
   Read(n,Szi);
   if n=1 then R.Defined:=true else R.Defined:=false;
   Read(n,Szi);
   if n=1 then InDocument:=true else InDocument:=false;
   Read(n,Szi);
   if n=1 then IsManage:=true else IsManage:=false;
   Read(ScanNum,szn);
  end;//with
  FieldContent:=R;
  CmReadItemPos;

end;

procedure TEkBaseReport.CmSaveExprEndItem;
begin
   CmSaveItemInfo(-14,0,Pnt);
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadExprEndItem;
begin
   CmReadItemPos;
end;

procedure TEkBaseReport.CmSaveExecuteUDFItem(udfnumber, parcount, iifnumber, argnumber, mainudfnumber:longint);
begin
   CmSaveItemInfo(-15,Szi+Szi+Szi+Szi+Szi,Pnt);
   CmStream.Write(udfnumber,Szi);
   CmStream.Write(parcount,Szi);
   CmStream.Write(iifnumber,Szi);
   CmStream.Write(argnumber,Szi);
   CmStream.Write(mainudfnumber,Szi);
   CmSaveItemPos;
end;

procedure TEkBaseReport.CmReadExecuteUDFItem(out udfnumber, parcount, iifnumber, argnumber, mainudfnumber:longint);
begin
   CmStream.Read(udfnumber,Szi);
   CmStream.Read(parcount,Szi);
   CmStream.Read(iifnumber,Szi);
   CmStream.Read(argnumber,Szi);
   CmStream.Read(mainudfnumber,Szi);   
   CmReadItemPos;
end;


{-----------------TEkColor-----------------------------}
constructor TEkColor.create;
begin
  inherited create;
  fr:=0; fg:=0; fb:=0;
end;
function TEkColor.GetColor:TColor;
begin
  Result:=FB Shl 16 Or
          FG Shl 8  Or
          FR;
end;
procedure TEkColor.SetColor(Value:TColor);
begin
  FB:=(Value and $00FF0000) shr 16;
  FG:=(Value and $0000FF00) shr 8;
  FR:=Value and $000000FF;
end;
procedure TEkColor.SetFr(Value:byte);
begin
   If Value<>Fr then Fr:=value;
end;
procedure TEkColor.SetFg(Value:byte);
begin
   If Value<>Fg then Fg:=value;
end;
procedure TEkColor.SetFb(Value:byte);
begin
   If Value<>Fb then Fb:=value;
end;


//-----------------------------------------------------------------
function TEkBaseRTFReport.GetCharSet:TFontCharSet;
begin
Result:=FCharset;
end;
//-----------------------------------------------------------------
procedure TEkBaseRTFReport.SetCharSet(Value:TFontCharset);
begin
  if Value<>FCharset then FCharset:=Value;
end;
//-----------------------------------------------------------------
function TEkBaseRTFReport.GetLang: TEkLanguageID;
begin
Result:=FLang;
end;
//-----------------------------------------------------------------
procedure TEkBaseRTFReport.SetLang(Value:TEkLanguageID);
begin
  if Value<>FLang then FLang:=Value;
end;

procedure TEkBaseRTFReport.SetOptions(Value: TEkRTFOptions);
begin
  if Value<>FOptions then FOptions:=Value;
end;

//-----------------------------------------------------------
function TEkBaseRTFReport.txt2rtf(s:string):string;
{$IF CompilerVersion < 20} //Non unicode before D2009

var o,f,i:Longint;
begin
f:=length(s);
i:=1;
Result:='';
while i<=f do
begin
o:=ord(s[i]);
 case o of
        9: Result:=Result+'\tab ';
       11: Result:=Result+'\line ';
       12: Result:=Result+'\page ';
       13: Result:=Result+'\par ';
       92: Result:=Result+'\\';
      123: Result:=Result+'\{';
      125: Result:=Result+'\}';
 128..255: Result:=Result+'\'''+inttohex(o,2);
 else
     Result:=Result+s[i];
 end;//case
inc(i);
end;

{$ELSE}  //D2009 and later -------------------------------------

var o,f,i:Longint;
    UniCharPresent:boolean;
    oAnsi:byte;
begin
f:=length(s);
i:=1;
Result:='';
UniCharPresent := false;

while i<=f do
begin
o:=ord(s[i]);  //юникодное значение
 case o of
        9: Result:=Result+'\tab ';
       11: Result:=Result+'\line ';
       12: Result:=Result+'\page ';
       13: Result:=Result+'\par ';
       92: Result:=Result+'\\';
      123: Result:=Result+'\{';
      125: Result:=Result+'\}';
 128..255: Result:=Result+'\'''+inttohex(o,2);
 else
  //2011.11.6 by t27
  if not Self.UnicodeByDefault then
     Result := Result + s[i]
  else
  begin

     if (o>255) and Self.UnicodeByDefault then
     begin //Unicode
        oAnsi := byte(AnsiString(s)[i]);

       //2011.11.6 by t27
       {if o<128 then
          Result := Result + s[i]
       else
       begin}
          Result := Result+'\u'+inttostr(o)+' ';
        	Result := Result + '\'''+inttohex(oAnsi,2);
       {end;}
          UniCharPresent := true;
     end else begin

         //Ansi
         if o < 128 then
         begin
              Result := Result + s[i]; //здесь остается юникод, в ansi перобразуется при записи в файл в TEkBaseReport.wr
         end else begin

              oAnsi := byte(AnsiString(s)[i]);
              if oAnsi < 128 then
                 Result := Result + s[i] //здесь остается юникод, в ansi перобразуется при записи в файл в TEkBaseReport.wr
        			else
                 Result := Result + '\'''+inttohex(oAnsi,2);
         end;

 	   end; //if (o>255) and Self.UnicodeByDefault

  end;//if not Self.Unicode
 end;//case
inc(i);
end;//while

     //Юникод надо заключать в {\uc1 .....} иначе с иероглифами будут проблемы
     //Для восточных символов в исходном шаблоне может быть задан пропуск более чем одного символа
     if UniCharPresent then begin
        Result := '{\uc1 '+Result+'}';
     end;
{$IFEND}
end;//function txt2rtf

function TEkBaseRTFReport.CreateFileName(Directory, Prefix: string): string;
var ln:integer;
    tic:string;
begin
    ln:=length(Directory);
    if (ln>0) and not DirectoryExists(Directory) then begin
       raise EIOError.Create('CreateFileName: directory '+Directory+' does not exist');
    end;
    if (ln>0) then begin
       if Directory[ln]<>'\' then Directory:=Directory+'\';
    end;
    tic:=IntTohex( Gettickcount, 8 );
    while (tic[1]='0') and (length(tic)>1) do tic:=copy(tic,2,length(tic)-1);
    randomize;
    Result :=Directory + Prefix+tic + IntToHex(Random($FFFF),4) + '.doc';
end;

function TEkBaseRTFReport.CreateFileName(Directory, Prefix, Extension: string): string;
var ln:integer;
    tic:string;
begin
    ln:=length(Directory);
    if (ln>0) and not DirectoryExists(Directory) then begin
       raise EIOError.Create('CreateFileName: directory '+Directory+' does not exist');
    end;
    if (ln>0) then begin
       if Directory[ln]<>'\' then Directory:=Directory+'\';
    end;
    if (length(Extension)>0) and (Extension[1]<>'.') then Extension:='.'+Extension;
    tic:=IntTohex( Gettickcount, 8 );
    while (tic[1]='0') and (length(tic)>1) do tic:=copy(tic,2,length(tic)-1);
    randomize;
    Result :=Directory + Prefix+tic + IntToHex(Random($FFFF),4) + Extension;
end;



constructor TEkBaseRTFReport.Create(AOwner: TComponent);
var i:integer;
begin
  inherited Create(AOwner);
  FCharset:=DEFAULT_CHARSET;
  FLang:=0;

  //this string is empty in BaseReport
  //set outfile name here
  OutFile:='outfile.doc';
  FOutTab:=nil;
  FQuoteIndex:=0; FQuoteSkip:=0; FQuoteStr:='';

  Include(FOptions,eoGraphicsBinary);
  Include(FOptions,eoDotAsColon);

  FRTFFont:=nil;
  FRTFColor:=nil;
  FRTFStyle:=nil;
  FRTFDocInfo:=nil;

  FIsFontTable:=false;
  FIsStyle:=false;
  FIsColorTable:=false; //not known
  FIsDocInfo:=false;
  FInTable:=false;
  FTableRowOpen:=false;

  FUnicodeSkipCount:=1;
  FUcStack := TEkIntStack.Create;

  FDocColorCount:=0; // not known at creation
  FColorCount:=16;

  Setlength(FColorTable,FColorCount);
  for i:=0 to FColorCount-1 do FColorTable[i]:=TEkcolor.create;
  FColorTable[0].b:=$00; FColorTable[0].g:=$00; FColorTable[0].r:=$00;
  FColorTable[1].b:=$FF; FColorTable[1].g:=$00; FColorTable[1].r:=$00;
  FColorTable[2].b:=$FF; FColorTable[2].g:=$FF; FColorTable[2].r:=$00;
  FColorTable[3].b:=$00; FColorTable[3].g:=$FF; FColorTable[3].r:=$00;
  FColorTable[4].b:=$FF; FColorTable[4].g:=$00; FColorTable[4].r:=$FF;
  FColorTable[5].b:=$00; FColorTable[5].g:=$00; FColorTable[5].r:=$FF;
  FColorTable[6].b:=$00; FColorTable[6].g:=$FF; FColorTable[6].r:=$FF;
  FColorTable[7].b:=$FF; FColorTable[7].g:=$FF; FColorTable[7].r:=$FF;
  FColorTable[8].b:=$80; FColorTable[8].g:=$00; FColorTable[8].r:=$00;
  FColorTable[9].b:=$80; FColorTable[9].g:=$80; FColorTable[9].r:=$00;
  FColorTable[10].b:=$00; FColorTable[10].g:=$80; FColorTable[10].r:=$00;
  FColorTable[11].b:=$80; FColorTable[11].g:=$00; FColorTable[11].r:=$80;
  FColorTable[12].b:=$00; FColorTable[12].g:=$00; FColorTable[12].r:=$80;
  FColorTable[13].b:=$00; FColorTable[13].g:=$80; FColorTable[13].r:=$80;
  FColorTable[14].b:=$80; FColorTable[14].g:=$80; FColorTable[14].r:=$80;
  FColorTable[15].b:=$C0; FColorTable[15].g:=$C0; FColorTable[15].r:=$C0;
end;//end constructor

destructor TEkBaseRTFReport.Destroy;
var i:integer;
begin
  FRTFFont.Free;
  FRTFColor.Free;
  FRTFStyle.Free;
  FRTFDocInfo.Free;
  for i:=0 to FColorCount-1 do FColorTable[i].free;
  FColorTable:=nil;
  FDocColorTable:=nil;
  FUcStack.Free;
  inherited Destroy;
end;//end destructor

procedure TEkBaseRTFReport.CmSaveFontTable;
begin
   //Not fonttable, but sign of it
   CmSaveItemInfo(-17,0,Pnt);
   CmSaveItemPos;
end;

procedure TEkBaseRTFReport.CmReadFontTable;
begin
   CmReadItemPos;
end;

procedure TEkBaseRTFReport.CmSaveColorTable;
begin
   //Just sign of it
   CmSaveItemInfo(-18,0,Pnt);
   CmSaveItemPos;
end;

procedure TEkBaseRTFReport.CmReadColorTable;
begin
   CmReadItemPos;
end;

procedure TEkBaseRTFReport.CmSaveStyleSheet;
begin
   //Just sign of it
   CmSaveItemInfo(-19,0,Pnt);
   CmSaveItemPos;
end;

procedure TEkBaseRTFReport.CmReadStyleSheet;
begin
   CmReadItemPos;
end;


procedure TEkBaseRTFReport.CmSaveDocInfo;
begin
   //Just sign of it
   CmSaveItemInfo(-20,0,Pnt);
   CmSaveItemPos;
end;

procedure TEkBaseRTFReport.CmReadDocInfo;
begin
   CmReadItemPos;
end;

//-----------------------------------------------------------------------------

procedure TEkBaseRTFReport.ReadFb(var ch:AnsiChar);
label 1;
begin
    1:
    if Pnt<=Lent then begin ch:=AnsiChar(Pfile[Pnt-1]); IncPnt(1); end
                   else begin ch:=#26; end;
    if ((ch<#32) and (ch<>#10) and (ch<>#09)) and (Pnt<=Lent) then goto 1;
end;//proc ReadFb

procedure TEkBaseRTFReport.ReadBack(var ch:AnsiChar);
label 1;
begin
    1:
    if (Pnt<=Lent) and (Pnt>1) then begin IncPnt(-1); ch:=AnsiChar(Pfile[Pnt-1]);  end
                   else begin ch:=#26; end;
    if ((ch<#32) and (ch<>#10) and (ch<>#09)) and (Pnt<=Lent) and (Pnt>1) then goto 1;
end;//proc ReadBack

function TEkBaseRTFReport.LeftQuote(c:char):boolean;
begin
  Result:=false;
  if     (c = char('“'))   //#147
      or (c = char('”'))   //#148
      or (c = char('«'))   //#171
      or (c = char('»'))   //#187
      or (c = char('"'))   //#34
      or (c = char(''''))  //#39
      or (c = char('`'))   //#96
      or (c = char('~'))   //#126
  then Result:=true;
end;

function TEkBaseRTFReport.RightQuote(lc,rc:char):boolean;
begin
  Result:=false;
  case lc of
   //#147,#148: if rc=#148 then Result:=true;
   char('“'), char('”')    : if rc = '”' then Result:=true;

   //#171,#187: if rc=#187 then Result:=true;
   char('«'), char('»')    : if rc = '»' then Result:=true;

   //      #34: if rc=#34 then Result:=true;
   char('"')        : if rc = '"' then Result:=true;

  //       #39: if rc=#39 then Result:=true;
   char('''')       : if rc = '''' then Result:=true;

  //       #96: if rc=#96 then Result:=true;
   char('`')        : if rc = '`' then Result:=true;

  //      #126: if rc=#126 then Result:=true;
   char('~')        : if rc = '~' then Result:=true;
  end;//case
end;

function TEkBaseRTFReport.IsQuoted(s:string):boolean;
var lq,rq:char;
    f,ln:longint;
begin
   Result:=false;
   ln:=length(s);
   if (ln>2) and (LeftQuote(s[1])) then begin
        lq:=s[1];
        rq:=s[ln];
        if (not RightQuote(lq,rq)) then begin Result:=false; exit; end;
        for f:=2 to ln-1 do if s[f]=rq then begin Result:=false; exit; end;
        Result:=true;
   end;
end;//func IsQuoted


procedure TEkBaseRTFReport.OutRaw;
var s:string;
begin
   CmReadRawItem(s);
   wr(s);
end;

procedure TEkBaseRTFReport.OutColorTable;
var f:longint;
begin
  wr('{\colortbl');
  for f:=0 to RTFColor.Count-1 do wr(RTFColor[f]);
  wr('}');
end;

procedure TEkBaseRTFReport.OutFontTable;
var f:longint;
begin
  wr('{\fonttbl');
  for f:=0 to RTFFont.Count-1 do wr(RTFFont[f]);
  wr('}');
  //if no color table in input file, but colors added
  if (not IsColorTable) and (RTFColor.Count>0) then OutColorTable;
end;

procedure TEkBaseRTFReport.OutStyle;
var f:longint;
begin
  wr('{\stylesheet');
  for f:=0 to RTFStyle.Count-1 do wr(RTFStyle[f]);
  wr('}');
end;



{ gets string \\...\\ with field name mixed with rtf tags
  result: fldstring=\\field\\ outstring=other rtf tags}

procedure TEkBaseRTFReport.CutRtString(rtstring:string; var fldstring, outstring:string);
     var   f,ln,hexn,i:integer;
           f1         :integer;
           ch, ch1,ch2,ch3,lq:char;
           delspace, inquote:boolean;
           fldres:string;
           decstr:string;
           undx  :integer;
           ucode :longint;
           uchar :char;
           SkipCharAfterUnicode:boolean;
           SkippedCount:longint;

     procedure AddNextChar(var CurrentStr: string; AddStr:string; var SkipChar:boolean; var N:longint);
     begin
         if not SkipChar then begin
            CurrentStr:=CurrentStr+AddStr;
         end else begin
           //После юникода пропускаем одну или больше букв (не прибавляем). Флаг сбрасываем.
           //пропускать количество символов UnicodeSkipCount
           inc(N);
               if (N >= UnicodeSkipCount) then begin
                  SkipChar := false;
                  N := 0; //Счетчик пропущенных сбрасываем
               end;
         end;
     end;

     begin // CutRtString ------------------------------

       ln:=length(rtstring);
       rtstring:=rtstring+'          ';
       fldstring:=''; outstring:='';
       f:=1;
       SkipCharAfterUnicode:=false;
       SkippedCount := 0;

       while f<=ln do
       begin
            ch:=rtstring[f];
            case ch of
            '\':begin
                   ch1:=rtstring[f+1];
                   case ch1 of
                   '\': begin AddNextChar(fldstring,'\',SkipCharAfterUnicode,SkippedCount); inc(f,2); end;
                   // brackets that may be in document
                   '}': begin AddNextChar(fldstring,'}',SkipCharAfterUnicode,SkippedCount); inc(f,2); end;
                   '{': begin AddNextChar(fldstring,'{',SkipCharAfterUnicode,SkippedCount); inc(f,2); end;
                        //non-breaking space
                   '~': begin AddNextChar(fldstring,' ',SkipCharAfterUnicode,SkippedCount); inc(f,2); end;
                    //символ Unicode \u<N> ?
                    'u','U':begin
                               ch2:=rtstring[f+2];
                               //если дальше идут цифры, то это юникод
                               if Digit(ch2) then begin
                                  decstr:=ch2;
                                  undx:=3;
                                  ch2:=rtstring[f+undx];
                                    while (f+undx<ln) and Digit(ch2) do
                                    begin
                                      decstr:=decstr+ch2;
                                      inc(undx);
                                      ch2:=rtstring[f+undx];
                                    end;
                                    ucode:=StrToInt(decstr);
                                    uchar:=Char(ucode);

                                    AddNextChar(fldstring,uchar,SkipCharAfterUnicode,SkippedCount);

                                    //После десятичного кода может идти пробел и символ ANSI, который надо пропустить
                                    if (ch2 = #32) then begin
                                       inc(f,undx+1);
                                    end else begin
                                      //А может символ ANSI сразу без пробела
                                       inc(f,undx);
                                    end;
                                    SkipCharAfterUnicode:=true;

                               end else begin //if \u<N>
                                   //если после u идут не цифры, то это может быть управляющее слово rtf, например uc2 или что еще
                                  //здесь проверять uc2 и проверяется в GetNextReportField

                                 //В любом случае нужно прочитать все после \u, а там посмотрим
                                 f1 := f; //f1 стоит на \

                                 //Дочитка до конца управляюшего слова
                                 repeat
                                   outstring:=outstring+rtstring[f];
                                   inc(f);
                                 until  (rtstring[f]='\') or (rtstring[f]=' ')
                                        or (rtstring[f]='}') or (rtstring[f]='{');
                                //Add Last space to keyword
                                if (rtstring[f]=' ') then begin outstring:=outstring+' '; inc(f); end;

                                  //Здесь проверяем
                                  if (UpperCase(rtstring[f1+2]) = 'C') and
                                     (Digit(rtstring[f1+3])) then //если uc<N>
                                  begin
                                        f1 := f1+3;
                                        decstr:='';
                                        while (f1 <= f) and Digit(rtstring[f1])
                                        do begin
                                           decstr := decstr + rtstring[f1];
                                           inc(f1);
                                        end;
                                        UnicodeSkipCount := StrToInt(decstr);
                                  end;


                               end;//if \u<N>
                            end;//begin u
                   //символ Ansi в шестнадцатиричном представлении
                   #39: begin ch2:=rtstring[f+2]; ch3:=rtstring[f+3];
                              hexn:=StrToIntDef('$'+ch2+ch3,0);
                              if hexn>0 then AddNextChar(fldstring,string(AnsiChar(hexn)),SkipCharAfterUnicode,SkippedCount);
                              //chr неправильно переводит коды до 255 в string, поэтому заменена на AnsiChar
                              inc(f,4);
                        end;
                   else
                       begin

                         if (copy(rtstring,f+1,6)='lquote') and (not Letter(rtstring[f+7])) and (not Digit(rtstring[f+7])) then
                            begin
                            AddNextChar(fldstring,#39,SkipCharAfterUnicode,SkippedCount);
                            inc(f,7);
                            if rtstring[f]=' ' then inc(f);
                            continue;
                            end;

                         if (copy(rtstring,f+1,6)='rquote') and (not Letter(rtstring[f+7])) and (not Digit(rtstring[f+7])) then
                            begin
                            AddNextChar(fldstring,#39,SkipCharAfterUnicode,SkippedCount);
                            inc(f,7);
                            if rtstring[f]=' ' then inc(f);
                            continue;
                            end;

                         if (copy(rtstring,f+1,9)='ldblquote') and (not Letter(rtstring[f+10])) and (not Digit(rtstring[f+10])) then
                            begin
                            AddNextChar(fldstring,#147,SkipCharAfterUnicode,SkippedCount);
                            inc(f,10);
                            if rtstring[f]=' ' then inc(f);
                            continue;
                            end;

                         if (copy(rtstring,f+1,9)='rdblquote') and (not Letter(rtstring[f+10])) and (not Digit(rtstring[f+10])) then
                            begin
                            AddNextChar(fldstring,#148,SkipCharAfterUnicode,SkippedCount);
                            inc(f,10);
                            if rtstring[f]=' ' then inc(f);
                            continue;
                            end;

                        //Дочитка до конца управляюшего слова
                        repeat
                        outstring:=outstring+rtstring[f];
                        inc(f);
                        until  (rtstring[f]='\') or (rtstring[f]=' ')
                           or (rtstring[f]='}') or (rtstring[f]='{');
                        //Add Last space to keyword
                        if (rtstring[f]=' ') then begin outstring:=outstring+' '; inc(f); end;

                       end;
                   end; //case nested
                end;
            'A'..'Z',
            'a'..'z',
            ' ','_','!','?','"','#','$','%','&',#39,'(',')',
            '*','+',',','-','.','/',':',';','[',']','@','|','<','>','=',
            #96,
            #126..#255,
            '0'..'9':begin AddNextChar(fldstring,ch,SkipCharAfterUnicode,SkippedCount); inc(f); end;

            //Дальше идут не символы
            '{':begin
                  outstring:=outstring+rtstring[f];
                  inc(f);

                  UcStack.Push(UnicodeSkipCount);

                  //skip {\*\pnseclvl and other bullet formats
                  if (ln-f>5) and (copy(rtstring,f,5)='\*\pn')
                              and ((rtstring[f+5]=#32) or (Letter(rtstring[f+5]))) then begin
                     i:=1;
                     repeat
                      ch2:=rtstring[f];
                        if ch2='{' then inc(i);
                        if ch2='}' then dec(i);
                      outstring:=outstring+ch2;
                      inc(f);
                     until (i=0) or (f=ln);
                     //Здесь при i=0 заканчивается закрывающей } поэтому возвращаем из стэка то, что положили
                     if (i=0) then UnicodeSkipCount := UcStack.Pop;

                  end;//if
                 end;// '{'

            '}':begin
                  outstring:=outstring+rtstring[f];
                  inc(f);

                  UnicodeSkipCount := UcStack.Pop;
                end;//'}'

            else //case
              //here will be symbols that not processed including rtf tags
              outstring:=outstring+rtstring[f];
              inc(f);
            end;//case


       end;//while

       fldstring:=Trim(fldstring);
       ln:=length(fldstring);
       delspace:=true; inquote:=false; fldres:=''; lq:=' ';
       for f:=1 to ln do begin
                           ch:=fldstring[f];
                           if (not inquote) and (LeftQuote(ch)) then begin
                               inquote:=true; lq:=ch;
                               fldres:=fldres+ch;
                               continue;
                               end;

                           if (inquote) and (not RightQuote(lq,ch)) then begin
                               fldres:=fldres+ch;
                               continue;
                               end;

                           if (inquote) and (RightQuote(lq,ch)) then begin
                              inquote:=false;
                              fldres:=fldres+ch;
                              continue;
                              end;

                           if ch='[' then begin delspace:=false; continue; end;
                           if ch=']' then begin delspace:=true; continue; end;
                           if (delspace) and (ch=' ') then continue else fldres:=fldres+ch;
                         end;
       fldstring:=Trim(fldres);
end;//proc

     //Returns symbols with n chars offset from current position fpnt

{
function TEkBaseRTFReport.getnch(n:integer):char;
label 1,2;
     begin
        if n>=0 then
        begin //positive n
             1:
             if Pnt+n<=Lent then begin Result:=(Pfile+Pnt+n-1-1)^; inc(n); end
                            else begin Result:=#26; end;
             if (Result<#32) and (Pnt+n<=Lent) then goto 1;
        end
        else
         begin //negative n
          2:
          if Pnt+n>=1 then begin Result:=(Pfile+Pnt+n-1-1)^; Dec(n); end
                         else begin Result:=#26; end;
          if (Result<#32) and (Pnt+n>=1) then goto 2;
         end;
end;//function getnch
}


function TEkBaseRTFReport.getns(n:integer):string;
var TemPnt,f:integer;
    ch:AnsiChar;
begin
    TemPnt:=Pnt;
    Result:='';

    if n>=0 then begin //-----------------------------------------------

     for f:=1 to n do begin
      repeat
         if TemPnt<=Lent then begin ch:=AnsiChar(Pfile[TemPnt-1]) ; Inc(TemPnt); end
                         else begin ch:=#26; end;
      until (TemPnt>Lent) or (ch>#31) or (ch=#09);
      Result:=Result+string(ch);
     end;//for

    end else begin //---------------------------------------------------

     for f:=-1 downto n do begin
      repeat
         if TemPnt<=Lent then begin ch:=AnsiChar(Pfile[TemPnt-1]) ; Dec(TemPnt); end
                         else begin ch:=#26; end;
      until (TemPnt+n>=1) or (ch>#31) or (ch=#09);
      Result:=Result+string(ch);
     end;//for

    end;//if -----------------------------------------------------------

end;



function TEkBaseRTFReport.GetNextReportField:string;
const MaxLens=10000;
var    ch : AnsiChar   ;
        s : string ;
      ucs, decstr : string;
      cnt, i : integer;
MStoredPnt:longint ;


     //Reading from FileBody
     procedure ReadScan(var ch:AnsiChar);
     begin
      repeat
      readFB(ch);
      until (FileEof()) or (ch>#31) or (ch=#10) or (ch=#09);

     end; //procedure ReadScan

  //------------------------------------------------------------
  function isLeftQuote:boolean;
  var s:string;
  begin
     Result:=false;
     if (ch<>'\') and (ch<>#34) and (ch<>#39) and (ch<>#96)
                  and (ch<>#126) and (ch<>#147) and (ch<>#148)
                  and (ch<>#171) and (ch<>#187) then exit;

     //chr(147)----------------
     if (ch=#147) then begin
                       FQuoteIndex:=1; FQuoteSkip:=1; FQuoteStr:=#147;
                       Result:=true; exit;
                       end;
     s:=getns(3);
     if (ch='\') and (s=#39+'93')
         then begin
              FQuoteIndex:=1; FQuoteSkip:=4; FQuoteStr:='\'+#39+'93';
              Result:=true; exit;
              end;
     //chr(148)----------------
     if (ch=#148) then begin
                       FQuoteIndex:=1; FQuoteSkip:=1; FQuoteStr:=#148;
                       Result:=true; exit;
                       end;
     s:=getns(3);
     if (ch='\') and (s=#39+'94')
         then begin
              FQuoteIndex:=1; FQuoteSkip:=4; FQuoteStr:='\'+#39+'94';
              Result:=true; exit;
              end;


     //lquote------------------
     s:=UpperCase(getns(7));
     if (ch='\') and (copy(s,1,6)='LQUOTE') and ( not ((s[7]>='A') and (s[7]<='Z')))
        then begin
             FQuoteIndex:=2; FQuoteSkip:=7; FQuoteStr:='\lquote';
             Result:=true; exit;
             end;

     //ldblquote------------------
     s:=UpperCase(getns(10));
     if (ch='\') and (copy(s,1,9)='LDBLQUOTE') and ( not ((s[10]>='A') and (s[10]<='Z')))
        then begin
             FQuoteIndex:=8; FQuoteSkip:=10; FQuoteStr:='\ldblquote';
             Result:=true; exit;
             end;

     //rdblquote------------------
     s:=UpperCase(getns(10));
     if (ch='\') and (copy(s,1,9)='RDBLQUOTE') and ( not ((s[10]>='A') and (s[10]<='Z')))
        then begin
             FQuoteIndex:=8; FQuoteSkip:=10; FQuoteStr:='\rdblquote';
             Result:=true; exit;
             end;


     //rquote------------------
     s:=UpperCase(getns(7));
     if (ch='\') and (copy(s,1,6)='RQUOTE') and ( not ((s[7]>='A') and (s[7]<='Z')))
        then begin
             FQuoteIndex:=2; FQuoteSkip:=7; FQuoteStr:='\rquote';
             Result:=true; exit;
             end;


     //chr(171)----------------
     if (ch=#171) then begin
                       FQuoteIndex:=3; FQuoteSkip:=1; FQuoteStr:=#171;
                       Result:=true; exit;
                       end;

     s:=UpperCase(getns(3));
     if ( (ch='\') and (s=#39+'AB') )
         then begin
              FQuoteIndex:=3; FQuoteSkip:=4; FQuoteStr:='\'+#39+'ab';
              Result:=true; exit;
              end;

     //chr(187)----------------
     if (ch=#187) then begin
                       FQuoteIndex:=3; FQuoteSkip:=1; FQuoteStr:=#187;
                       Result:=true; exit;
                       end;

     s:=UpperCase(getns(3));
     if ( (ch='\') and (s=#39+'BB') )
         then begin
              FQuoteIndex:=3; FQuoteSkip:=4; FQuoteStr:='\'+#39+'bb';
              Result:=true; exit;
              end;

     if ch=#34 then begin FQuoteIndex:=4; FQuoteSkip:=1; FQuoteStr:=#34;
                          Result:=true; exit; end;
     if ch=#39 then begin FQuoteIndex:=5; FQuoteSkip:=1; FQuoteStr:=#39;
                          Result:=true; exit; end;
     if ch=#96 then begin FQuoteIndex:=6; FQuoteSkip:=1; FQuoteStr:=#96;
                          Result:=true; exit; end;
     if ch=#126 then begin FQuoteIndex:=7; FQuoteSkip:=1; FQuoteStr:=#126;
                           Result:=true; exit; end;
  end;// isLeftQuote

  function isRightQuote:boolean;
  var s:string;
  begin
     Result:=false;

     case FQuoteIndex of
     1,8:begin
         //chr(148)----------------
         if (ch=#148) then begin
                           FQuoteSkip:=1; FQuoteStr:=#148;
                           Result:=true; exit;
                           end;

         s:=UpperCase(getns(3));
         if ( (ch='\') and (s=#39+'94') )
             then begin
                  FQuoteSkip:=4; FQuoteStr:='\'+#39+'94';
                  Result:=true; exit;
                  end;
         //rdblquote------------------
         s:=UpperCase(getns(10));
         if (ch='\') and (copy(s,1,9)='RDBLQUOTE') and ( not ((s[10]>='A') and (s[10]<='Z')))
            then begin
                 FQuoteSkip:=10; FQuoteStr:='\rdblquote';
                 Result:=true; exit;
                 end;
       end;//1

     2,5:begin
       if ch=#39 then begin FQuoteSkip:=1; FQuoteStr:=#39;
                            Result:=true; exit; end;
       //rquote------------------
       s:=UpperCase(getns(7));
       if (ch='\') and (copy(s,1,6)='RQUOTE') and ( not ((s[7]>='A') and (s[7]<='Z')))
          then begin
               FQuoteSkip:=7; FQuoteStr:='\rquote';
               Result:=true; exit;
               end;
       end;//2

     3:begin
       //chr(187)----------------
       s:=UpperCase(getns(3));
       if ( (ch='\') and (s=#39+'BB') )
           then begin
                FQuoteSkip:=4; FQuoteStr:='\'+#39+'bb';
                Result:=true; exit;
                end;
       if (ch=#187) then begin
                         FQuoteSkip:=1; FQuoteStr:=#187;
                         Result:=true; exit;
                         end;

       end;//3

     4:begin if ch=#34 then begin FQuoteSkip:=1; FQuoteStr:=#34;
                                  Result:=true; exit; end; end;
     6:begin if ch=#96 then begin FQuoteSkip:=1; FQuoteStr:=#96;
                                  Result:=true; exit; end; end;
     7:begin if ch=#126 then begin FQuoteSkip:=1; FQuoteStr:=#126;
                                   Result:=true; exit; end; end;

     end;//case

  end;// isRightQuote

  //-------------------- check if we have read \\ or \'5c
  function isBackSlash:boolean;
  var s:string;
  begin
     if (ch<>'\') then begin Result:=false; exit; end;
     s:=getns(3);
     if (
         ( (ch='\') and (s[1]='\') ) or
         ( (ch='\') and (s=#39+'5C') ) or
         ( (ch='\') and (s=#39+'5c') )
        )
         and not
        (
          ( (ch='\') and (s[1]='*') ) or
          ( (ch='\') and (s[1]='\') and (s[2]='*') )
        )
          then Result:=true else Result:=false;
  end;

  function Uc:boolean;  // проверка \Uc2
  var s:string;
  begin
      if (ch<>'\') then begin Result:=false; exit; end;

      s:=UpperCase(getns(3));
      //uc<N>
      if (ch='\') and (copy(s,1,2)='UC') and (Digit(s[3])) then
              begin Result:=true; exit; end;
      Result:=false;
  end;

  function TableRow:boolean;
  var s:string;
  begin
      if (ch<>'\') then begin Result:=false; exit; end;

      s:=UpperCase(getns(6));
      //trowd
      if (ch='\') and (copy(s,1,5)='TROWD') and ( not ((s[6]>='A') and (s[6]<='Z')) ) then
              begin Result:=true; exit; end;
      Result:=false;
  end;

  function InTbl:boolean;
  var s:string;
  begin
      if (ch<>'\') then begin Result:=false; exit; end;

      s:=UpperCase(getns(6));
      //intbl
      if (ch='\') and (copy(s,1,5)='INTBL') then
              begin Result:=true; exit; end;
      Result:=false;
  end;

  function Pard:boolean;
  var s:string;
  begin
      if (ch<>'\') then begin Result:=false; exit; end;

      s:=UpperCase(getns(5));
      //pard
      if (ch='\') and (copy(s,1,4)='PARD') then
              begin Result:=true; exit; end;
      Result:=false;
  end;


  function TableEndRow:boolean;
  var s:string;
  begin
      if (ch<>'\') then begin Result:=false; exit; end;

      //row
      s:=UpperCase(getns(4));
      if (ch='\') and (copy(s,1,3)='ROW') and ( not ((s[4]>='A') and (s[4]<='Z')) ) then
              begin Result:=true; exit; end;
      Result:=false;
  end;

  function FontTable:boolean;
  var s:string;
  begin
      if (ch<>'{') then begin Result:=false; exit; end;
      //{\fonttbl
      s:=UpperCase(getns(9));
      if (ch='{') and (copy(s,1,8)='\FONTTBL') and ( not ((s[9]>='A') and (s[9]<='Z'))) then
              begin Result:=true; exit; end;
      Result:=false;
  end;

  function ColorTable:boolean;
  var s:string;
  begin
      if (ch<>'{') then begin Result:=false; exit; end;
      //{\colortbl
      s:=UpperCase(getns(10));
      if (ch='{') and (copy(s,1,9)='\COLORTBL') and ( not ((s[10]>='A') and (s[10]<='Z'))) then
              begin Result:=true; exit; end;
      Result:=false;
  end;

  function DocInfo:boolean;
  var s:string;
  begin
      if (ch<>'{') then begin Result:=false; exit; end;
      //{\info
      s:=UpperCase(getns(6));
      if (ch='{') and (copy(s,1,5)='\INFO') and ( not ((s[6]>='A') and (s[6]<='Z'))) then
              begin Result:=true; exit; end;
      Result:=false;
  end;

  function StyleSheet:boolean;
  var s:string;
  begin
      if (ch<>'{') then begin Result:=false; exit; end;
      //{\stylesheet
      s:=UpperCase(getns(12));
      if (ch='{') and (copy(s,1,11)='\STYLESHEET') and ( not ((s[12]>='A') and (s[12]<='Z'))) then
              begin Result:=true; exit; end;
      Result:=false;
  end;


  function NeedToSkipBlock:boolean;
  var s:string;
  begin
      if (ch<>'{') then begin Result:=false; exit; end;

      s:=UpperCase(getns(11));
      if (not (eoProcessFormFields in Options)) and (ch='{') and (copy(s,1,6)='\FIELD') and ( not ((s[7]>='A') and (s[7]<='Z'))) then
              begin Result:=true; exit; end;
      if (ch='{') and (copy(s,1,10)='\*\FLDINST') and ( not ((s[11]>='A') and (s[11]<='Z'))) then
              begin Result:=true; exit; end;

      if (ch='{') and (copy(s,1,5)='\PICT') and ( not ((s[6]>='A') and (s[6]<='Z'))) then
              begin Result:=true; exit; end;
      if (ch='{') and (copy(s,1,7)='\OBJECT') and ( not ((s[8]>='A') and (s[8]<='Z'))) then
              begin Result:=true; exit; end;
      if (ch='{') and (copy(s,1,8)='\SHPRSLT') and ( not ((s[9]>='A') and (s[9]<='Z'))) then
              begin Result:=true; exit; end;
      Result:=false;
  end;

  function IsBoundary:boolean;
  var s:string;
  begin
      if (ch<>'\') then begin Result:=false; exit; end;

      s:=UpperCase(getns(6));
      //\trowd
      if (ch='\') and (copy(s,1,5)='TROWD') and ( not Letter(s[6])) then
              begin Result:=true; FLastBoundaryPnt:=Pnt-1; exit; end;
      //\row
      if (ch='\') and (copy(s,1,3)='ROW') and ( not Letter(s[4])) then
              begin Result:=true; FLastBoundaryPnt:=Pnt-1; exit; end;
      //\cell
      if (ch='\') and (copy(s,1,4)='CELL') and ( not Letter(s[5])) then
              begin Result:=true; FLastBoundaryPnt:=Pnt-1; exit; end;
      //\page
      if (ch='\') and (copy(s,1,4)='PAGE') and ( not Letter(s[5])) then
              begin Result:=true; FLastBoundaryPnt:=Pnt-1; exit; end;
      //\sect
      if (ch='\') and (copy(s,1,4)='SECT') and ( not Letter(s[5])) then
              begin Result:=true; FLastBoundaryPnt:=Pnt-1; exit; end;
      //\line
      if (ch='\') and (copy(s,1,4)='LINE') and ( not Letter(s[5])) then
              begin Result:=true; FLastBoundaryPnt:=Pnt-1; exit; end;
      //\par
      if (ch='\') and (copy(s,1,3)='PAR') and (not Letter(s[4])) then
              begin Result:=true; FLastBoundaryPnt:=Pnt-1; exit; end;
      Result:=false;
  end;

  procedure ProcessFontTable; //Compiling
    function charset(s:string):integer;
    var p:integer;
        c:string;
     begin
     p:=pos('fcharset',s)+8;
     c:='';
     while (Digit(s[p])) and (p<length(s)) do begin
            c:=c+s[p]; inc(p);
            end;
     try
     Result:=strToint(c);
     except
     raise EBadRtfFormat.Create('Can''t define font charset in input file');
     end;//try
     end;//function charset

     procedure FTReadStrings;
     var s:string;
        DefCharSet:string;
        cnt, nread,t:integer;
        p,ln:integer;
     begin
     try
      ch:=' '; nread:=0;
      DefCharSet:=intToStr(FCharset);

      while (ch<>'}') and (not FileEof()) do
      begin
         while (ch<>'{') and (ch<>'}') and (not FileEof()) do readFB(ch);
         if ch='{' then
         begin
         cnt:=1; s:='{';

         while (cnt>0) and (not FileEof()) do
         begin
         readFb(ch);
         if ch='{' then inc(cnt);
         if ch='}' then dec(cnt);
         s:=s+string(ch);
         end;
         ch:=' ';
         FRTFFont.Add(s); inc(nread);
         end;
      end; //while not eof(f)

      for t:=0 to nread-1 do
      begin
         p:=pos('fcharset',FRTFFont[t]);
         if p>0 then begin
                     s:=FRTFFont[t];
                     ln:=length(s);
                     FRTFFont[t]:=copy(s,1,p-1)+'fcharset'+DefCharSet+copy(s,p+8+length(inttostr(CharSet(s))),ln);
                    end;
      end;

     except
        raise EBadRtfFormat.Create('Can''t read font table from input file');
     end;//try
    end;//FTReadStrings
  Begin//ProcessFontTable
      //fpnt points to '\'  {\fonttbl
      IncPnt(8);
      FTReadStrings;
      CmSaveFontTable; //order of CmSaving is important due to CmPos and Pnt changing
      FIsFontTable:=true;
  end;//ProcessFontTable

  procedure ProcessColorTable; //Compiling
  const ptests: PChar='\colortbl';
  var ch:AnsiChar;
      s,dgc:string;
      cnt, n, i:integer;
      c:TEkColor;
      isautocolor:boolean;
      autostring:string;
  begin
    //fpnt points to '\'  {\colortbl
    IncPnt(9);

          c:=TEkColor.create;

          cnt:=1; s:='';
          while (cnt>0) and (not FileEof()) do
          begin
          readFb(ch);
          if ch='{' then inc(cnt);
          if ch='}' then dec(cnt);
          s:=s+string(ch);
          end;
          if FileEof() then  raise EBadRtfFormat.Create('Can''t read color table from input file');


          isautocolor:=false;
          autostring:='';
          n:=pos('\',s);
          if n>1 then begin
             autostring:=copy(s,1,n-1);
             isautocolor:=true;
          end;

          //string s contains red green blue sequences and final bracket
          n:=pos('red',s);
          while n>0 do
          begin
              inc(FDocColorCount);
              Setlength(FDocColorTable,FDocColorCount);
              c.r:=0; c.g:=0; c.b:=0;
              s[n]:='_'; inc(n,3);
              dgc:='';
                 while Digit(s[n]) do begin dgc:=dgc+s[n]; inc(n); end;
              c.r:=strtoint(dgc);
              FDocColorTable[FDocColorCount-1]:=TEkColor.create;
              FDocColorTable[FDocColorCount-1].color:=c.color;
              n:=pos('red',s)
          end;

          for i:=0 to FDocColorCount-1 do
          begin
              //------green---------
              c.color:=FDocColorTable[i].color;
              n:=pos('green',s);
              s[n]:='_'; inc(n,5);
              dgc:=''; while Digit(s[n]) do begin dgc:=dgc+s[n]; inc(n); end;
              c.g:=strtoint(dgc);
              //----------blue------
              n:=pos('blue',s);
              s[n]:='_'; inc(n,4);
              dgc:=''; while Digit(s[n]) do begin dgc:=dgc+s[n]; inc(n); end;
              c.b:=strtoint(dgc);

              FDocColorTable[i].color:=c.color;
          end;//for
          c.free;

          if isautocolor then FRTFColor.Add(autostring);
          for i:=0 to FDocColorCount-1 do
          begin
          FRTFColor.Add('\red'+inttostr(FDocColorTable[i].r)+'\green'+inttostr(FDocColorTable[i].g)+'\blue'+inttostr(FDocColorTable[i].b)+';');
          end;//for

    CmSaveColorTable;
    FIsColorTable:=true;

  end;//ProcessColorTable

  procedure ProcessStyleSheet; //Compiling
  var  cnt:integer;
         s:string;
  begin
    //fpnt points to '\'  {\stylesheet
    IncPnt(11);

      ch:=' ';
      while (ch<>'}') and (not FileEof()) do
      begin
         while (ch<>'{') and (ch<>'}') and (not FileEof()) do readFB(ch);
         if ch='{' then
         begin
         cnt:=1; s:='{';

         while (cnt>0) and (not FileEof()) do
         begin
         readFb(ch);
         if ch='{' then inc(cnt);
         if ch='}' then dec(cnt);
         s:=s+string(ch);
         end;
         ch:=' ';
         FRTFStyle.Add(s);
         end;
      end; //while not eof(f)

    CmSaveStyleSheet;
    FIsStyle:=true;
  end;//ProcessStyleSheet

  procedure ProcessDocInfo; //Compiling
  var  cnt:integer;
         s:string;
  begin
    //fpnt points to '\'  {\info
    IncPnt(5);

      ch:=' ';
      while (ch<>'}') and (not FileEof()) do
      begin
         while (ch<>'{') and (ch<>'}') and (not FileEof()) do readFB(ch);
         if ch='{' then
         begin
         cnt:=1; s:='{';

         while (cnt>0) and (not FileEof()) do
         begin
         readFb(ch);
         if ch='{' then inc(cnt);
         if ch='}' then dec(cnt);
         s:=s+string(ch);
         end;
         ch:=' ';
         FRTFDocInfo.Add(s);
         end;
      end; //while not eof(f)

    CmSaveDocInfo;
    FIsDocInfo:=true;
  end;//ProcessDocInfo

  procedure SkipBlock(WriteBlock:boolean);
  var np, n, ct:integer;
      binsize:string;
      c:AnsiChar;
      s:string;
  begin
       ct:=1; np:=1;
       // ch='{' first symbol in block
       while (ct<>0) and (not FileEof()) do
       begin
           c:=AnsiChar(Pfile[Pnt+np-1-1]);
              if (c='{') then begin inc(ct);  end;
              if (c='}') then begin dec(ct);  end;

            //if bin control
            s:=UpperCase(getns(4));
            if (c='\') and (copy(s,1,3)='BIN') and ((s[4]>='0') and (s[4]<='9')) then
                begin
                //write bin control
                   n:=4;
                   while (Pfile[Pnt+np-1-1]>=ord('0')) and (Pfile[Pnt+np-1-1]<=ord('9')) do
                   begin
                      s:=getns(n);
                      binsize:=binsize+s[n];
                      inc(n);
                   end;
                   n:=n+1+strtoint(binsize); //n=length of binary block with \bin word
                   np:=np+n;
                end else begin
                         inc(np);
                         end;//if not bin

       end;//while not end of block
       if WriteBlock then begin
                          //D7 Win32 code: Outf.WriteBuffer((Pfile+Pnt-2)^,np);
                          wrBlock(PFile,Pnt-2,np);
                          end;
       IncPnt(np-1);
  end;//proc SkipBlock


begin //---- GetNextReportField

    ch:=' '; Result:='';
    while not FileEof() do
          begin
          readFb(ch);
          IsBoundary();
          if (not FIsFontTable)  and (FontTable())  then begin ProcessFontTable; continue; end;
          if (not FIsColorTable) and (ColorTable()) then begin ProcessColorTable; continue; end;
          if (not FIsStyle)      and (StyleSheet()) then begin ProcessStyleSheet; continue; end;
          if (not FIsDocInfo)    and (DocInfo())    then begin ProcessDocInfo; continue; end;

          if NeedToSkipBlock() then begin SkipBlock(false);
                                          CmSaveBalancedBlocItem;
                                          continue; end;

          //Здесь можно анализировать фигурные скобки. Блоки, которые обрабатываеются выше, не считаем.
          //В стэке отслеживаем количество байт пропускаемых после юникода - управляющее слово \uc
          if ch='{' then begin
             UcStack.Push(UnicodeSkipCount);  //Сюда попадает в том числе самая первая скобка - первый символ файла
          end;

          if ch='}' then begin
             UnicodeSkipCount := UcStack.Pop;
          end;


          if Uc() then begin
             ucs:=getns(20);
             i:=3; decstr:='';
             while (i<=length(ucs)) and (Digit(ucs[i])) do
             begin
                 decstr:=decstr+ucs[i]; inc(i);
             end;
             UnicodeSkipCount := StrToInt(decstr);
          end;

          if TableRow() then begin
                             IncPnt(-1);
                             CmSaveTableBegin;
                             FInTable:=true;
                             FTableRowOpen:=true;
                             IncPnt(1);
                             CmSaveBlocItem;
                             continue;
                             end;

          if TableEndRow() then begin
                                IncPnt(3);
                                CmSaveBlocItem;
                                CmSaveTableEnd;
                                FInTable:=false;
                                FTableRowOpen:=false;
                                continue;
                                end;

          if InTbl() then begin //Microsoft Word often place paragraphs outside of a table row definition,
                                //so we need to process paragraph marked with \intbl keyword the same as
                                //it is placed inside the table
                                //It takes influence to frtf() function
                             IncPnt(-1);
                             CmSaveTableBegin;
                             FInTable:=true;
                             IncPnt(1);
                             CmSaveBlocItem;
                             continue;
                             end;

          if Pard() and (FInTable) and (not FTableRowOpen) then
                                // \pard stops the \intbl keyword effect
                                begin
                                IncPnt(4);
                                CmSaveBlocItem;
                                CmSaveTableEnd;
                                FInTable:=false;
                                continue;
                                end;


          if (not isBackSlash()) then begin CmSaveBlocItem; end
                                 else begin FKwdPnt:=Pnt-1; break; end;
    end; //while 2


    //С этого места фигурные скобки не отслеживаем.
    //Будет или поле отчета между слэшей - тогда отслеживаем в CutRtString
    //Либо запишем найденный первый слэш в поток и пойдем после него снова, если это не имя поля

    if not FileEof() then
    begin
          ReadScan(ch);
          if ch=#39 then begin readscan(ch); readscan(ch); end; //if 5c then read two chars more.

             cnt:=0; Result:=''; ch:=' ';
             MStoredPnt:=Pnt;

             while (cnt<MaxLens) and (not FileEof()) do
             begin
               readScan(ch);
               s:=getns(1);

                 if (FQuoteIndex=0) and (isLeftQuote()) then begin
                    Result:=Result+FQuoteStr;
                    inc(cnt,FQuoteSkip);
                    if FQuoteSkip>1 then IncPnt(FQuoteSkip-1);
                    //in case of \l(dbl)quote skip space after control word if it exists
                    if ((FQuoteIndex=2) or (FQuoteIndex=8)) and (s[1]=#32) then begin
                                                                readScan(ch);
                                                                Result:=Result+string(ch);
                                                                inc(cnt);
                                                                end;
                    continue;
                 end;//if

                 if (FQuoteIndex>0) and (not isRightQuote()) then begin

                      if isBackSlash() then begin
                         Result:=Result+'\'; inc(cnt);
                         readScan(ch);
                         if ch=#39 then begin //if 5c then read two chars more.
                            readscan(ch);
                            Result:=Result+'''5';
                            readscan(ch);
                            Result:=Result+string(ch); inc(cnt,3);  //C or c
                         end else begin
                            Result:=Result+'\'; inc(cnt);
                         end;
                         continue;
                      end;//if

                      s:=getns(1);
                      if (ch='\') and (s[1]=#39) then begin
                          readscan(ch);
                          Result:=Result+'\'+#39;
                          readscan(ch); Result:=Result+string(ch);
                          readscan(ch); Result:=Result+string(ch);
                          inc(cnt,4);
                          continue;
                          end;

                      s:=getns(1);
                      if (ch='\') and (s[1]=#126) then begin
                          readscan(ch);
                          Result:=Result+'\'+#126;
                          inc(cnt,2);
                          continue;
                         end;

                     Result:=Result+string(ch); inc(cnt);
                     continue;
                 end;//if

                 if (FQuoteIndex>0) and (isRightQuote()) then begin
                    Result:=Result+FQuoteStr;
                    inc(cnt,FQuoteSkip);
                    if FQuoteSkip>1 then IncPnt(FQuoteSkip-1);
                    //in case of \l(dbl)quote skip space after control word if it exists
                    s:=getns(1);
                    if ((FQuoteIndex=2) or (FQuoteIndex=8)) and (s[1]=#32) then begin
                                                                readScan(ch);
                                                                Result:=Result+string(ch);
                                                                inc(cnt);
                                                                end;
                    FQuoteIndex:=0; FQuoteStr:=''; FQuoteSkip:=0;
                    continue;
                 end;//if


                 s:=getns(1);
                 if (FQuoteIndex=0) and (not isBackSlash()) then begin
                      if (ch='\') and (s[1]=#39) then begin
                          readscan(ch);
                          Result:=Result+'\'+#39;
                          readscan(ch); Result:=Result+string(ch);
                          readscan(ch); Result:=Result+string(ch);
                          inc(cnt,4);
                          continue;
                          end;

                      s:=getns(1);
                      if (ch='\') and (s[1]=#126) then begin
                          readscan(ch);
                          Result:=Result+'\'+#126;
                          inc(cnt,2);
                          continue;
                         end;

                     Result:=Result+string(ch); inc(cnt);
                 end else break;

                 if (IsBoundary()) or (NeedToSkipBlock()) then break;

             end;//while cnt<MaxLens


             if (not isBackSlash()) then
             begin
               //Not a field name - write '\\' to outf and scan again
               Pnt:=MStoredPnt;
               FQuoteIndex:=0; FQuoteSkip:=0; FQuoteStr:='';
               CmSaveBlocItem;
               Result:='';
             end else begin
                readScan(ch);
                if ch=#39 then begin readscan(ch); readscan(ch); end; //if 5c then read two chars more.
                exit;  //***************** Return
             end;
    end; //if not eof

end; //function GetNextReportField;

procedure TEkBaseRTFReport.SaveToOutTable(fid:longint);
var tlnt, tn1:longint;
begin
    tlnt:=Length(FOutTab);
    if tlnt=0 then begin
       SetLength(FOutTab,1);
       FOutTab[0].n1:=0;
       FOutTab[0].n2:=TmpStream.Position;
       FOutTab[0].id:=fid;
    end else begin
             tn1:=FOutTab[tlnt-1].n2;
             SetLength(FOutTab,tlnt+1);
             FOutTab[tlnt].n1:=tn1;
             FOutTab[tlnt].n2:=TmpStream.Position;
             FOutTab[tlnt].id:=fid;
             end;
end;//SaveToOutTable

function TEkBaseRTFReport.KillPar:string;
var bakpnt:Longint;
    teststr, text, rtf,s:string;
    testch:AnsiChar;
    y0,y:boolean;
begin
        bakpnt:=Pnt;
        teststr:='';

        //Check if there is a text before keyword
        //for example: sometext\scan(a)\
        y0:=true;
        if (FLastBoundaryPnt>-1) and (FKwdPnt>FLastBoundaryPnt) then begin
           Pnt:=FLastBoundaryPnt;
           while Pnt<FKwdPnt do begin
              ReadFb(testch);
              teststr:=teststr+string(testch);
           end;//while
           CutRtString(teststr,text,rtf);
           if length(text)>0 then begin
              y0:=false;  //don't delete the paragraph after keyword
           end;//if
        end;//if

        Pnt:=bakpnt;
        y:=false;
        Result:='';

        ReadFb(testch);
        teststr:=string(testch);
        s:=UpperCase(getns(4));

      while (not FileEof()) and not
        (
        (testch='\')
        and (copy(s,1,3)='PAR')
        and (
             (
             (not Digit(s[4]))  and (not Letter(s[4]))
             )
             or (s[4]=#32)
            )
        ) do
        begin
            ReadFb(testch);
            teststr:=teststr+string(testch);
            s:=UpperCase(getns(4));
        end;//while

        if not FileEof() then
           begin
           CutRtString(copy(teststr,1,length(teststr)-1),text,rtf);
               //if there is no text then kill paragraph
               if (length(text)=0) and (y0) then
               begin
                //set LastBoundaryPnt here as we have found and will remove the "\par"
                FLastBoundaryPnt:=Pnt-1;
                y:=true;
                if s[4]=#32 then IncPnt(4) else IncPnt(3);
                //remove last \
                if length(teststr)>0 then teststr:=copy(teststr,1,length(teststr)-1);
                Result:=teststr;   //chars to save after keyword scan without \par
               end;
           end;
        if not y then Pnt:=bakpnt; //nothing to do - here is the contents of the scan block or after endscan
end;//func KillPar

{------------------ TEkColorStringList ---------------------------}
function TEkColorStringList.UseColor(s: string): longint;
begin
  Result:=IndexOf(s);
  if Result=-1 then begin
     if Count=0 then Add(';');
     Result:=Add(s);
  end;
end;

{-----------------TEkImageFormat-----------------------------}
constructor TEkImageFormat.create(x,y:word);
//var p:double;
begin
  inherited create;
  FSizeX:=x; FSizeY:=y;
  FScaleX:=100; FScaleY:=100;
  FProportional:=true;
  FSizeXmm:=x*0.264596930676; FSizeYmm:=y*0.264596930676;
  //p:=1440/(56.69*Screen.PixelsPerInch);
  //FSizeXmm:=x*p; FSizeYmm:=y*p;
  FBorder.BrType:=brNone; FBorder.Width:=0; FBorder.ColorIndex:=0;
end;

procedure TEkImageFormat.SetScaleX(Value:Word);
var k:Double;
begin
    if Value<1 then Value:=1;
    k:=Value/FScaleX; FScaleX:=Value;
    FSizeX:=round(FSizeX*k);
    FSizeXmm:=FSizeXmm*k;
    if FProportional then begin FScaleY:=round(FScaleY*k);
                                FSizeY:=round(FSizeY*k);
                                FSizeYmm:=FSizeYmm*k;
                          end;
end;

procedure TEkImageFormat.SetScaleY(Value:Word);
var k:Double;
begin
    if Value<1 then Value:=1;
    k:=Value/FScaleY; FScaleY:=Value;
    FSizeY:=round(FSizeY*k);
    FSizeYmm:=FSizeYmm*k;
    if FProportional then begin FScaleX:=round(FScaleX*k);
                                FSizeX:=round(FSizeX*k);
                                FSizeXmm:=FSizeXmm*k;
                          end;
end;

procedure TEkImageFormat.SetSizeXY(x, y: Word);
begin
  FSizeX:=x; FSizeY:=y;
  FScaleX:=100; FScaleY:=100;
  FSizeXmm:=x*0.264596930676; FSizeYmm:=y*0.264596930676;
end;

procedure TEkImageFormat.SetSizeXmm(Value: Double);
var k:Double;
begin
  if (Value>0) and (Value<>FSizeXmm) then
     begin
       if FSizeXmm>0 then k:=Value/FSizeXmm else k:=1;
       FSizeXmm:=Value;
       FSizeX:=round(FSizeX*k);
       FScaleX:=round(FScaleX*k);
       if FProportional then begin FSizeYmm:=round(FSizeYmm*k);
                                   FSizeY:=round(FSizeY*k);
                                   FScaleY:=round(FScaleY*k);
                             end;
     end;
end;

procedure TEkImageFormat.SetSizeYmm(Value: Double);
var k:Double;
begin

  if (Value>0) and (Value<>FSizeYmm) then
     begin
       if FSizeYmm>0 then k:=Value/FSizeYmm else k:=1;;
       FSizeYmm:=Value;
       FSizeY:=round(FSizeY*k);
       FScaleY:=round(FScaleY*k);
       if FProportional then begin FSizeXmm:=round(FSizeXmm*k);
                                   FSizeX:=round(FSizeX*k);
                                   FScaleX:=round(FScaleX*k);
                             end;
     end;
end;

procedure TEkImageFormat.FitScaleToX(x:Word);
var k:Double;
    NewScaleX:Word;
begin
    if x<1 then x:=1;
    k:=x/FSizeX; NewScaleX:=round(100*k);
    SetScaleX(NewScaleX);
end;

procedure TEkImageFormat.FitScaleToY(y:Word);
var k:Double;
    NewScaley:Word;
begin
    if y<1 then y:=1;
    k:=y/FSizeY; NewScaleY:=round(100*k);
    SetScaleY(NewScaleY);
end;

procedure TEkImageFormat.SetBorder(Value:TEkImageBorder);
var wtwip:byte;
begin
      FBorder.BrType:=Value.BrType;
      if value.Width>3.5 then value.Width:=3.5;
      wtwip:=round(20*Value.width);
      if wtwip>75 then wtwip:=75;
      FBorderTwips:=wtwip;
      if wtwip=0 then FBorder.BrType:=brNone;
      FBorder.ColorIndex:=Value.ColorIndex;
end;

procedure TEkImageFormat.SetBorderType(BrType:TEkImageBorderType; BrWidth:Single; ColorIndex:Word);
var B:TEkImageBorder;
begin
   B.BrType:=BrType;
   B.Width:=BrWidth;
   B.ColorIndex:=ColorIndex;
   SetBorder(B);
end;

function TEkBaseReport.ConvertExpression(var ex: string; DotAsColon:boolean): string;
    var nested,n,f,intmath:longint;
        strmath:string;
        nextfield,nextop, prevop, tail, s, nextex, errpart:string;
        udfs:string;
        AllowUnary, IsOperand, PrevIsOperand, completed :boolean;
        c:char;
        DirectExpr,InversExpr:TEkExpression;
        MOperation:TEkOperand;
        OpStack, InvStack:TEkOperationStack;
begin
       //ln:=length(ex);
       DirectExpr:=TEkExpression.Create;
       InversExpr:=TEkExpression.Create;
       OpStack:=TEkOperationStack.Create;
       InvStack:=TEkOperationStack.Create;
      try
       s:='';
       nested:=0; nextfield:='';
       nextop:=#32; prevop:=#32;
       tail:=''; nextex:='';
       PrevIsOperand:=false;
       IsOperand:=true;
       AllowUnary:=true;
       n:=GetNextExprField(ex,nextfield,tail, DotAsColon);
       //-5, -13
       if n=-5 then raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex);
       if n=-13 then begin
          IsOperand:=false;
          if not GetNextExprOperation(ex,nextop,tail,AllowUnary) then
             raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex);
       end;//if n=-13

       //Operand, unary + -, unary ! (not), "("  expected at the beginning
       if not IsOperand then begin
          if not ( (nextop='u+') or (nextop='u-') or (nextop='!') or (nextop='(') ) then
             raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex);
       end;//if not

        //5,4,3,2,1,0,-1,-2, -5
       //--------------------------->
       errpart:=' error at the beginning ';
       completed:=false;
       repeat
          if IsOperand then begin
             if PrevIsOperand then begin //cannot be operand after operand
                raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' operation expected');
             end;
             if nextop=')' then begin //cannot be operand after ")"
                raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' operation expected');
             end;
             //store operand
             //s:=s+nextfield+' fldnum='+inttostr(n)+#13;
             s:=s+nextfield;
             DirectExpr.Add(nextfield,true,0,false,false,false,0,n);

             AllowUnary:=false;

          end else begin

             if (PrevIsOperand) then begin
                if (nextop='!') or (nextop='(') then begin
                  raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' "'+nextop+'" not expected');
                end;
             end;//if

             if not PrevIsOperand then begin
                if CharInSet(prevop[1],['*','/','%','+','-']) then begin
                   if ((nextop='&&') or (nextop='||') or (nextop='<=')
                      or (nextop='=>') or (nextop='>=') or (nextop='<>')
                         or (nextop='!=') or (nextop=':=')) or
                      CharInSet(nextop[1],['*','/','%','=','<','>','!','+','-']) or
                      (nextop=')') then begin
                       raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' "'+nextop+'" not expected');
                   end;
                end;//if prev */%
                if (prevop='&&') or (prevop='||') then begin
                    if (nextop<>'!') and (nextop<>'(') then begin
                       raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' "'+nextop+'" not expected');
                    end;
                end;
                if (prevop='<') or (prevop='>') or (prevop='=') or (prevop='<=')
                    or (prevop='>=') or (prevop='=>') or (prevop='<>') or (prevop='!=') or (prevop=':=') then begin
                    if (nextop<>'(') and (nextop<>'u+') and (nextop<>'u-') then begin
                       raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' "'+nextop+'" not expected');
                    end;
                end;
                if (prevop='u+') or (prevop='u-') then begin
                   if (nextop<>'(') then begin
                      raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' "'+nextop+'" not expected');
                   end;
                end;
                if (prevop='!')  then begin
                    if (nextop<>'!') and (nextop<>'(') then begin
                       raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' "'+nextop+'" not expected');
                    end;
                end;
                if (prevop='(')  then begin
                    if (nextop<>'u+') and (nextop<>'u-') and (nextop<>'!') and (nextop<>'(') then begin
                       raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' "'+nextop+'" not expected');
                    end;
                end;
                if (prevop=')')  then begin
                    if (nextop='u+') or (nextop='u-') or (nextop='!') or (nextop='(') then begin
                       raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+errpart+s+ ' "'+nextop+'" not expected');
                    end;
                end;

             end;// If not PrevIsOperand

             //AllowUnary for some operations
             AllowUnary:=false;
             MOperation.Text:=nextop;
             MOperation.IsOperand:=false;
             MOperation.ArgsNeed:=0;
             MOperation.ReqBoolArg:=false;
             MOperation.AllowBoolArg:=false;
             MOperation.RetBoolRes:=false;
             MOperation.Priority:=0;
             MOperation.Fldnum:=0;

             //Более сильный приоритет с большим Priority

             if nextop='&&' then begin
                MOperation.ArgsNeed:=2;
                MOperation.ReqBoolArg:=true;
                MOperation.AllowBoolArg:=true;
                MOperation.RetBoolRes:=true;
                MOperation.Priority:=3;  //7;
             end;
             if nextop='||' then begin
                MOperation.ArgsNeed:=2;
                MOperation.ReqBoolArg:=true;
                MOperation.AllowBoolArg:=true;
                MOperation.RetBoolRes:=true;
                MOperation.Priority:=3;  //7;
             end;
             if nextop='<=' then begin
                MOperation.ArgsNeed:=2;
                MOperation.ReqBoolArg:=false;
                MOperation.AllowBoolArg:=false;
                MOperation.RetBoolRes:=true;
                MOperation.Priority:=5;  //5;
             end;
             if (nextop='=>') or (nextop='>=') then begin
                MOperation.ArgsNeed:=2;
                MOperation.ReqBoolArg:=false;
                MOperation.AllowBoolArg:=false;
                MOperation.RetBoolRes:=true;
                MOperation.Priority:=5;  //5;
             end;
             if (nextop='<>') or (nextop='!=') then begin
                MOperation.ArgsNeed:=2;
                MOperation.ReqBoolArg:=false;
                MOperation.AllowBoolArg:=true;
                MOperation.RetBoolRes:=true;
                MOperation.Priority:=4;  //6;
             end;
             if (nextop=':=') then begin
                MOperation.ArgsNeed:=2;
                MOperation.ReqBoolArg:=false;
                MOperation.AllowBoolArg:=true;
                MOperation.RetBoolRes:=false;
                MOperation.Priority:=2;      
             end;
             if (nextop='u-') or (nextop='u+') then begin
                MOperation.ArgsNeed:=1;
                MOperation.ReqBoolArg:=false;
                MOperation.AllowBoolArg:=false;
                MOperation.RetBoolRes:=false;
                MOperation.Priority:=8;  //2;
             end;

             if length(nextop)=1 then begin

             case nextop[1] of
              '!':begin
                   MOperation.ArgsNeed:=1;
                   MOperation.ReqBoolArg:=true;
                   MOperation.AllowBoolArg:=true;
                   MOperation.RetBoolRes:=true;
                   MOperation.Priority:=8;  //2;
                  end;
             '*','/','%':begin
                         MOperation.ArgsNeed:=2;
                         MOperation.ReqBoolArg:=false;
                         MOperation.AllowBoolArg:=false;
                         MOperation.RetBoolRes:=false;
                         MOperation.Priority:=7;  //3;
                         AllowUnary:=true;
                         end;
             '+','-':begin
                     MOperation.ArgsNeed:=2;
                     MOperation.ReqBoolArg:=false;
                     MOperation.AllowBoolArg:=false;
                     MOperation.RetBoolRes:=false;
                     MOperation.Priority:=6;  //4;
                     AllowUnary:=true;
                     end;
              '(':begin
                  MOperation.ReqBoolArg:=false;
                  MOperation.AllowBoolArg:=false;
                  MOperation.RetBoolRes:=false;
                  MOperation.Priority:=0;
                   inc(nested);
                   AllowUnary:=true;
                  end;
              ')':begin
                  MOperation.ReqBoolArg:=false;
                  MOperation.AllowBoolArg:=false;
                  MOperation.RetBoolRes:=false;
                  MOperation.Priority:=1;
                   dec(nested);
                   if nested<0 then begin
                               raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+' - number of ")" is more than number of "(" brackets');
                               end;
                  end;
              '>':begin
                  MOperation.ArgsNeed:=2;
                  MOperation.ReqBoolArg:=false;
                  MOperation.AllowBoolArg:=false;
                  MOperation.RetBoolRes:=true;
                  MOperation.Priority:=5;  //5;
                  AllowUnary:=true;
                  end;
              '<':begin
                  MOperation.ArgsNeed:=2;
                  MOperation.ReqBoolArg:=false;
                  MOperation.AllowBoolArg:=false;
                  MOperation.RetBoolRes:=true;
                  MOperation.Priority:=5;  //5;
                  AllowUnary:=true;
                  end;
              '=':begin
                  MOperation.ArgsNeed:=2;
                  MOperation.ReqBoolArg:=false;
                  MOperation.AllowBoolArg:=true;
                  MOperation.RetBoolRes:=true;
                  MOperation.Priority:=4;  //6;
                  AllowUnary:=true;
                  end;
             end;//case
             end;//if lenght()=1


             //store operation
             //s:=s+nextop+#13;
             //s:=s+nextop;
             //debug

             DirectExpr.Add(MOperation);

          end;//if IsOperand or Operation;

          errpart:=' error after ';

          //Get next part of expression
          if length(tail)>0 then begin
             c:=tail[1];
             nextex:=tail;
             PrevIsOperand:=IsOperand;

             if CharInSet(c,['*', '/', '%', '+', '-', '&', '|', '!', '(', ')','<','>','=',':']) then begin

                    prevop:=nextop;
                    if not GetNextExprOperation(nextex,nextop,tail,AllowUnary) then
                             raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+' error after '+s);
                    IsOperand:=false;

             end else begin

                    n:=GetNextExprField(nextex,nextfield,tail,DotAsColon);
                    if n=-5 then begin
                            raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+' error after '+s);
                            end;
                    IsOperand:=true;

             end;//if

          end else begin completed:=true; end;//if

       until completed;
       //--------------------------->

       if nested>0 then begin
          raise EIllegalFunctionUse.Create('Cannot process an expression: '+ex+' ")" expected');
       end;

       //end of expression
       if not ((IsOperand) or ((not IsOperand) and (nextop=')'))) then begin
          raise EIllegalFunctionUse.Create('Unexpected end of expression: '+ex);
       end;


       //showmessage('expression '+s);

       //*** invert expression

       for f:=0 to DirectExpr.Count-1 do begin
           MOperation:=DirectExpr.Operand[f];
           if MOperation.IsOperand then begin
              InversExpr.Add(MOperation);
           end else begin
               if (OpStack.Count>0) and (MOperation.Text=')') and (OpStack.Operation[OpStack.Count-1].Text='(') then
               begin //prevent empty brackets () from being stored in stack
                    OpStack.Pop;
                    continue;
               end;
               if (MOperation.Priority=0)
                  or ((OpStack.Count>0) and (MOperation.Priority > OpStack.Operation[OpStack.Count-1].Priority))
                  or (OpStack.Count=0) then begin
                     OpStack.Push(MOperation);
               end else begin
                     while (OpStack.Count>0) and
                          (OpStack.Operation[OpStack.Count-1].Priority >= MOperation.Priority) do begin
                       InversExpr.Add(OpStack.Pop);
                     end;//while
                     if (OpStack.Count>0) and (OpStack.Operation[OpStack.Count-1].Text='(') then OpStack.Pop;
                     if MOperation.Text<>')' then OpStack.Push(MOperation);
               end;//if
           end;//if
       end;//for

       while OpStack.Count>0 do begin InversExpr.Add(OpStack.Pop); end;
       if InversExpr.Operand[InversExpr.Count-1].IsOperand then begin
          raise EIllegalFunctionUse.Create('Operation or function name missed in expression: '+ex+', operand: '+InversExpr.Operand[InversExpr.Count-1].Text);
       end;

       //***!!! debug
      // s:='';
      // for f:=0 to InversExpr.Count-1 do s:=s+InversExpr.Operand[f].Text+#13;
       //debug

       //*** end invert expression

       udfs:=''; intmath:=0; strmath:='';
       for f:=0 to InversExpr.Count-1 do begin
           if InversExpr.Operand[f].IsOperand then begin
              InvStack.Push(InversExpr.Operand[f]);
           end else begin
                      IdentToInt(InversExpr.Operand[f].Text, intmath, EkMathIDs);
                      IntToIdent(intmath, strmath, EkSysIDs);
                      udfs:=udfs+strmath+'(';
                      for n:=1 to InversExpr.Operand[f].ArgsNeed do begin
                         udfs:=udfs+InvStack.Pop.Text;
                         if n<InversExpr.Operand[f].ArgsNeed then udfs:=udfs+',';
                      end;//for n
                      udfs:=udfs+')';
                      //push result to stack again
                      MOperation.Text:=udfs;
                      MOperation.IsOperand:=true;
                      MOperation.ArgsNeed:=0;
                      MOperation.ReqBoolArg:=false;
                      MOperation.AllowBoolArg:=false;
                      MOperation.RetBoolRes:=false;
                      MOperation.Priority:=0;
                      MOperation.Fldnum:=0;
                      InvStack.Push(MOperation);
                      udfs:='';
                    end;//if
       end;//for f

       udfs:=InvStack.Pop.Text;
       //showmessage(s+#13+udfs);
       Result:=udfs;

      finally
       OpStack.Free;
       InvStack.Free;
       DirectExpr.Free;
       InversExpr.Free;
      end;//try

end;//ConvertExpression

function TEkBaseReport.GetNextExprField(var ex, nextfield, tail: string; DotAsColon:boolean): integer;
var ln,f,lastcf,nested, p:longint;
    inquote, IsDecSp, IsExp, IsExpDigit, IsExpSign, IsNumber, IsBreak:boolean;
    IsVar, IsUDF, IsData:boolean;
    lq,c,cp, dlm:char;
begin

       Result:=-5;
       ex:=trim(ex);
       ln:=length(ex);
       nextfield:=''; tail:=ex;

       if (ln<1) or (ex[1]=')') or (ex[1]=':')
          or (ex[1]='<') or (ex[1]='>') or (ex[1]='=') or (ex[1]='*')
          or (ex[1]='/') or (ex[1]='%') then begin tail:=ex; exit; end;

       //check if data {dddd-dd-dd} expected {yyyy-mm-dd} not checked
       if (ln>=12) and (ex[1]='{') and (ex[12]='}')
          and (digit(ex[2])) and (digit(ex[3])) and (digit(ex[4])) and (digit(ex[5]))
          and (ex[6]='-') and (digit(ex[7])) and (digit(ex[8])) and (ex[9]='-')
          and (digit(ex[10])) and (digit(ex[11])) then begin
          Result:=5;
          nextfield:=copy(ex,1,12);
          tail:='';
          if ln>12 then tail:=copy(ex,13,ln-12);
          exit;
       end; //-----------------------------------------------------------------

       //check if true
       if (ln>=4) and (UpperCase(copy(ex,1,4))='TRUE') then begin
          Result:=4;
          nextfield:='TRUE';
          tail:='';
          if ln>4 then tail:=copy(ex,5,ln-4);
          exit;
       end;

       //check if false
       if (ln>=5) and (UpperCase(copy(ex,1,5))='FALSE') then begin
          Result:=4;
          nextfield:='FALSE';
          tail:='';
          if ln>5 then tail:=copy(ex,6,ln-5);
          exit;
       end; //----------------------------------------------------------------

      //check if numeric constant
       lastcf:=1;
       IsDecSp:=false; IsExp:=false;
       IsExpDigit:=false; IsExpSign:=false;
       IsNumber:=true; IsBreak:=false;
       c:=ex[1];
      if (c='.') or (c='+') or (c='-') or (digit(c)) then begin
       for f:=2 to ln do begin  // ====
        cp:=c;
        c:=ex[f];
        lastcf:=f;
        if not IsExp then begin // before E
             if ((digit(cp)) or (f=2)) and (not IsDecSp) and
                                          ( (digit(c)) or (c='.') or (c='E') or (c='e')
                                           ) then begin continue; end;
             if ((digit(cp)) or (f=2)) and (IsDecSp) and
                                          ( (digit(c)) or (c='E') or (c='e')
                                           ) then begin continue; end;
             if (cp='.') and (not IsDecSp) and ( (digit(c))
                                           ) then begin
                                             IsDecSp:=true; continue;
                                             end;
             if ((cp='E') or (cp='e')) and ( (digit(c)) or (c='+') or (c='-')
                                            ) then begin
                                              IsExp:=true; continue;
                                              end;
             if (not digit(cp)) then IsNumber:=false;
             IsBreak:=true; break;

        end else begin //after E

             if (digit(cp)) and (digit(c)) then begin
                                           IsExpDigit:=true; continue;
                                           end;
             if (not IsExpDigit) and (not IsExpSign) and ((cp='+') or (cp='-')) and (digit(c))
                                              then begin
                                              IsExpSign:=true; continue;
                                              end;
             if (not digit(cp)) then IsNumber:=false;
             IsBreak:=true; break;

        end;//if before/after E

       end;//for                   ====

       if (not IsBreak) and (not digit(c)) then IsNumber:=false;

       if IsNumber then begin
          if IsBreak then begin
                           nextfield:=copy(ex,1,lastcf-1);
                           tail:=copy(ex,lastcf,ln-lastcf+1);
                          end else begin
                           nextfield:=ex;
                           tail:='';
                          end;
          Result:=2; exit;
       end;//if

      end;//if (c='.' ...
      //end if numeric constant -------------------------------------------


   // check if it is quoted constant -----
   if (ln>1) and (LeftQuote(ex[1])) then begin

   inquote:=false; lq:=' ';
   for f:=1 to ln do
   begin
      c:=ex[f];
      if (not inquote) and (LeftQuote(c)) then begin
          inquote:=true; lq:=c;
          continue;
          end;
      if (inquote) and (not RightQuote(lq,c)) then continue;
      if (inquote) and (RightQuote(lq,c)) then begin
         inquote:=false;
         nextfield:=copy(ex,1,f);
         tail:='';
         if f<ln then tail:=copy(ex,f+1,ln-f);
         break;
         end;
    end;//for

       if not inquote then begin
          //right quote was found
          Result:=3;
          exit;
       end;

   end;//if
   // end quoted constant -----------------------------------------------------


   //0 variable
       cp:=ex[1]; c:=cp;
       lastcf:=1; IsVar:=true; IsBreak:=false;
      if (Letter(cp)) or (ord(cp)>191) or (cp='_') then begin

       for f:=2 to ln do begin
        cp:=c;
        c:=ex[f];
        lastcf:=f;
        if (Letter(c)) or (ord(c)>191)
            or (c='_') or (c=#32) or (digit(c))
                                   then begin
                                   continue;
                                   end;
        if (cp=#32) then begin IsVar:=false; end;
        IsBreak:=true; break;
       end;//for

       if (not IsBreak) and (c=#32) then IsVar:=false;

       if (IsVar) and (c<>'(') and (c<>':') and (c<>'.') then begin
          if IsBreak then begin
                           nextfield:=copy(ex,1,lastcf-1);
                           tail:=copy(ex,lastcf,ln-lastcf+1);
                          end else begin
                           nextfield:=ex;
                           tail:='';
                          end;
          Result:=0; exit;
       end;//if
 // A
 // |
 // V
       //1 UDF lastcf='('
       if (IsBreak) and (c='(') and (ln>lastcf) and ((Letter(cp)) or (ord(cp)>191)
                                        or (cp='_') or (digit(cp))
                                       ) then begin
       IsUDF:=true;
       nested:=1; inquote:=false; lq:=' ';
       inc(lastcf);
       for f:=lastcf to ln do
        begin
         c:=ex[f];
         lastcf:=f;
          if (not inquote) and (LeftQuote(c)) then begin
              inquote:=true; lq:=c;
              continue;
              end;
          if (inquote) and (not RightQuote(lq,c)) then continue;
          if (inquote) and (RightQuote(lq,c)) then begin
             inquote:=false; continue;
             end;
          if c='(' then inc(nested);
          if c=')' then dec(nested);
          if nested=0 then break;
       end;//for

       if (nested>0) then IsUDF:=false;

       if IsUDF then begin
          nextfield:=copy(ex,1,lastcf);  // lastcf=')'
          tail:='';
          if lastcf<ln then tail:=copy(ex,lastcf+1,ln-lastcf);
          Result:=1; exit;
       end;

       end;//If UDF


       //-1 -2 datafield  or still maybe var:=...
       if (IsBreak) and ((c=':') or (c='.')) and ((Letter(cp)) or (ord(cp)>191)
                                                   or (cp='_') or (digit(cp))
                                                  ) then begin
         dlm:=c;
         if (ln>lastcf) then c:=ex[lastcf+1];

         if (ln>lastcf) and ((Letter(c)) or (ord(c)>191) or (c='_') or (digit(c))) then begin
             //by name dataset:field
                IsData:=false;
                lastcf:=lastcf+1;
                IsBreak:=false;
                for f:=lastcf to ln do
                begin
                 c:=ex[f];
                 lastcf:=f;
                 if ((Letter(c)) or (ord(c)>191) or (c='_') or (digit(c)) or (c=#32)) then begin
                                                                           IsData:=true;
                                                                           continue;
                                                                           end;
                 IsBreak:=true; break;
                end;//for

                if IsData then begin
                   tail:='';
                   if IsBreak then begin
                      nextfield:=copy(ex,1,lastcf-1);
                      tail:=copy(ex,lastcf,ln-lastcf+1);
                    end else begin
                      nextfield:=copy(ex,1,lastcf);
                      if lastcf<ln then tail:=copy(ex,lastcf+1,ln-lastcf);
                    end;
                    if dlm=':' then Result:=-2 else Result:=-1;
                    if (DotAsColon) and (dlm='.') then begin
                       Result:=-2;
                       p:=pos('.',nextfield);
                       nextfield[p]:=':';
                    end;
                    exit;
                end;//if IsData

         end else begin
             // var:=...
             if (ln>lastcf+1) and (c='=') then begin
                        nextfield:=copy(ex,1,lastcf-1);
                        tail:=copy(ex,lastcf,ln-lastcf+1);
                        Result:=0; exit;
             end;//if

             //datafield by number
             if (ln>lastcf+1) and (c='(') then begin
             //by number dataset:(nnn)
                IsData:=false;
                lastcf:=lastcf+2;

                for f:=lastcf to ln do
                begin
                 c:=ex[f];
                 lastcf:=f;
                 if digit(c) then begin IsData:=true; continue; end;
                 break;
                end;//for

                if c<>')' then IsData:=false;
                if IsData then begin
                    nextfield:=copy(ex,1,lastcf);
                    tail:='';
                    if lastcf<ln then tail:=copy(ex,lastcf+1,ln-lastcf);
                    if dlm=':' then Result:=-2 else Result:=-1;
                    if (DotAsColon) and (dlm='.') then begin
                       Result:=-2;
                       p:=pos('.',nextfield);
                       nextfield[p]:=':';
                    end;
                    exit;
                end;//if IsData

             end;//if (ln>lastcf+1) and c='('
         end;//if

       end;//if datafield

      end;//if variable -- UDF -- datafield --------------------------

      //-13 expression
      if (ex[1]='(') or (ex[1]='-') or (ex[1]='+') or (ex[1]='!') then begin
         Result:=-13; exit;
      end;

end;//GetNextExprField


function TEkBaseReport.GetNextExprOperation(var ex, nextop, tail: string;
  Unary: boolean): boolean;
var ln:longint;
    c:char;
    s:string;
begin
       Result:=false;
       ex:=trim(ex);
       ln:=length(ex);
       nextop:=''; tail:=ex;
       if (ln<1) then exit;

       if (ln>1) then begin
          s:=copy(ex,1,2);
          if (s=':=') or (s='&&') or (s='||') or (s='<=') or (s='>=') or (s='<>') or (s='!=') then begin
             nextop:=s;
             tail:='';
             if (ln>2) then tail:=copy(ex,3,ln-2);
             Result:=true;
             exit;
          end;
       end;//if (ln>1)

       c:=ex[1];
       if CharInSet(c,['(',')','*','/','%','+','-','!','>','<','=']) then begin
          nextop:=c;
          tail:='';
          if (ln>1) then tail:=copy(ex,2,ln-1);
          if (Unary) and CharInSet(c,['+','-']) then nextop:='u'+nextop;
          Result:=true;
       end;
end;//GetNetxExprOperation

procedure TEkBaseReport.DefineProperties(Filer: TFiler);
begin
 inherited;
 Filer.DefineBinaryProperty('VarDataTypes', ReadVarDataType, WriteVarDataType, true);
end;//TEkBaseReport.DefineProperties

procedure TEkBaseReport.ReadVarDataType(St: TStream);
var n,f,dti:integer;
    TmpType:TEkDataType;
begin
  St.Read(n,Szi);
  for f:=0 to n-1 do begin
    St.Read(dti,Szi);
    TmpType:=Int2DataType(dti);
    if FVarList<>nil then begin
        if not Assigned(FVarList.Objects[f])
               then FVarList.Objects[f]:=TEkVarListObject.Create;
        TEkVarListObject(FVarList.Objects[f]).FDataType:=TmpType;
    end;
  end;//for

end;//TEkBaseReport.ReadVarDataType

procedure TEkBaseReport.WriteVarDataType(St: TStream);
var n,f,dti:integer;
    TmpType:TEkDataType;
begin
  n:=0;
  if (FVarList<>nil) and (FVarList.Count>0) then n:=FVarList.Count;
  St.Write(n,Szi);
  for f:=0 to n-1 do begin
    TmpType:=ekdtUnknown;
    if Assigned(FVarList.Objects[f]) then TmpType:=TEkVarListObject(FVarList.Objects[f]).FDataType;
    dti:=DataType2Int(TmpType);
    St.Write(dti,Szi);
  end;//for
end;//TEkBaseReport.WriteVarDataType

procedure TEkBaseReport.ResetIifNumber;
begin
 FiifNumber:=0;
end;//TEkBaseReport.ResetIifNumber;

function TEkBaseReport.GetNextIifNumber: longint;
begin
  Inc(FiifNumber);
  Result:=FiifNumber;
end;//TEkBaseReport.GetNextIifNumber;

{ TEkExpression }

procedure TEkExpression.Add(MText: string; MIsOperand:boolean; MArgsNeed:integer; MReqBoolArg, MAllowBoolArg, MRetBoolRes: boolean;
  MPriority, MFldnum: integer);
begin
 SetLength(FExpression,FCount+1);
 if (MReqBoolArg) and (not MAllowBoolArg) then raise Exception.Create('TEkExpression Add  - cannot set AllowBoolArg to false when ReqBoolArg is true');
 with FExpression[FCount] do begin
    Text:=MText;
    IsOperand:=MIsOperand;
    ArgsNeed:=MArgsNeed;
    ReqBoolArg:=MReqBoolArg;
    AllowBoolArg:=MAllowBoolArg;
    RetBoolRes:=MRetBoolRes;
    Priority:=MPriority;
    Fldnum:=MFldnum;
 end;//with
 Inc(FCount);
end;

procedure TEkExpression.Add(MOperand: TEkOperand);
begin
 SetLength(FExpression,FCount+1);
 if (MOperand.ReqBoolArg) and (not MOperand.AllowBoolArg) then raise Exception.Create('TEkExpression Add  - cannot set AllowBoolArg to false when ReqBoolArg is true');
 FExpression[FCount]:=MOperand;
 Inc(FCount);
end;

constructor TEkExpression.Create;
begin
 inherited Create;
 FCount:=0;
end;

destructor TEkExpression.Destroy;
begin
  FExpression:=nil;
  inherited Destroy;
end;

function TEkExpression.GetOperand(index: integer): TEkOperand;
begin
  if (index>=0) and (index<FCount) then begin
     Result:=FExpression[index];
   end else begin
     raise Exception.Create('TEkExpression GetOperand '+inttostr(index)+' - invalid index of operand');
  end;
end;



{ TEkOperationStack }

constructor TEkOperationStack.Create;
begin
 inherited Create;
 FCount:=0;
end;

destructor TEkOperationStack.Destroy;
begin
  FExpression:=nil;
  inherited Destroy;
end;

function TEkOperationStack.GetOperation(index: integer): TEkOperand;
begin
  if (index>=0) and (index<FCount) then begin
     Result:=FExpression[index];
   end else begin
     raise Exception.Create('TEkOperationStack GetOperation '+inttostr(index)+' - invalid index of operation');
  end;
end;

function TEkOperationStack.Pop: TEkOperand;
begin
 Result:=GetOperation(FCount-1);
 Dec(FCount);
 SetLength(FExpression,FCount+1);
end;

procedure TEkOperationStack.Push(MOperand: TEkOperand);
begin
 SetLength(FExpression,FCount+1);
 FExpression[FCount]:=MOperand;
 Inc(FCount);
end;

{ TEkVarList }

procedure TEkVarList.Clear;
var f:integer;
begin
  for f:=0 to Count-1 do begin
   objects[f].Free;
  end;
  inherited;
end;

procedure TEkVarList.Delete(Index: Integer);
begin
  objects[Index].Free;
  inherited;
end;

{ TEkIntStack }

procedure TEkIntStack.Clear;
begin
  FArray := nil;
  FCount := 0;
end;

constructor TEkIntStack.Create;
begin
inherited create;
 FCount := 0;
end;

destructor TEkIntStack.Destroy;
begin
  FArray := nil;
  inherited;
end;

function TEkIntStack.Pop: longint;
begin
   if FCount>0 then begin
       Result := FArray[FCount-1];
       SetLength(FArray, FCount - 1); //20170209 Igor
       dec(FCount);
   end else Result := 0;
end;

procedure TEkIntStack.Push(i: Integer);
begin
    if (Length(FArray) < (FCount+1)) then
    begin
       inc(FCount);
       SetLength(FArray, FCount);
    end;
    FArray[FCount - 1] := i;
end;

end.
