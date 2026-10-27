{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{          FireDAC SQL Time Interval data type          }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

{ TODO -cTIMEINT : Implement rounding to Scale }
{ TODO -cTIMEINT : Implement substruction from 2 SQLTimeStamp's }

unit uADStanSQLTimeInt;

interface

{$IFDEF AnyDAC_D6Base}
uses
  Variants;
{$ENDIF}

type
  TADSQLTimeIntervalKind = (itUnknown, itYear, itMonth, itDay, itHour, itMinute,
    itSecond, itYear2Month, itDay2Hour, itDay2Minute, itDay2Second, itHour2Minute,
    itHour2Second, itMinute2Second);

  TADSQLTimeInterval = packed record
    Sign: Shortint;
    case Kind: TADSQLTimeIntervalKind of
    itYear, itMonth, itYear2Month: (
      Years: LongWord;
      Months: LongWord
    );
    itDay, itHour, itMinute, itSecond, itDay2Hour, itDay2Minute,
    itDay2Second, itHour2Minute, itHour2Second, itMinute2Second: (
      Days: LongWord;
      Hours: LongWord;
      Minutes: LongWord;
      Seconds: LongWord;
      Fractions: LongWord
    );
  end;
  PADSQLTimeInterval = ^TADSQLTimeInterval;

{$IFDEF AnyDAC_D6Base}
function ADVarSQLTimeIntervalCreate: Variant; overload;
function ADVarSQLTimeIntervalCreate(const AValue: string): Variant; overload;
function ADVarSQLTimeIntervalCreate(const AValue: TADSQLTimeInterval): Variant; overload;
function ADVarSQLTimeInterval: TVarType;
function ADVarIsSQLTimeInterval(const AValue: Variant): Boolean; overload;
function ADVar2SQLTimeInterval(const AValue: Variant): TADSQLTimeInterval;
{$ENDIF}

function ADStr2SQLTimeInterval(const AValue: String): TADSQLTimeInterval;
function ADSQLTimeInterval2Str(const AValue: TADSQLTimeInterval): String;
function ADSQLTimeIntervalCompare(const AValue1, AValue2: TADSQLTimeInterval): Integer;
function ADSQLTimeIntervalCast(const AValue: TADSQLTimeInterval;
  AKind: TADSQLTimeIntervalKind): TADSQLTimeInterval;

const
  C_NullSQLTimeInterval: TADSQLTimeInterval = (Sign: 0; Kind: itUnknown; Days: 0;
    Hours: 0; Minutes: 0; Seconds: 0; Fractions: 0);

implementation

uses
  SysUtils, Classes, TypInfo, SysConst,
{$IFDEF AnyDAC_D6}
  SQLTimSt,
{$ENDIF}
  uADStanIntf, uADStanUtil;

{ ----------------------------------------------------------------------------- }
{ TADSQLTimeIntervalVariantType                                                 }
{ ----------------------------------------------------------------------------- }
type
{$IFNDEF AnyDAC_D6Base}
  TVarCompareResult = (crLessThan, crEqual, crGreaterThan);
{$ENDIF}  
  TADSQLTimeIntervalData = class(TPersistent)
  private
    FInterval: TADSQLTimeInterval;
    procedure CheckIntervalsCompatibility(const AInt1, AInt2: TADSQLTimeInterval);
    procedure NotInitError;
    function GetIsBlankBase(const AInterval: TADSQLTimeInterval): Boolean;
    function GetIsBlank: Boolean;
    function GetIsNegative: Boolean;
    procedure DoIncrementBase(const AInterval: TADSQLTimeInterval; ASign: Integer); overload;
    procedure DoIncrementBase(const AValue: Integer; ASign: Integer); overload;
    procedure DoAddToBase(var ADateTime: TADSQLTimeStamp; ASign: Integer);
    function GetAsString: string;
    procedure SetAsString(const AValue: string);

  public
    // the many ways to create
    constructor Create(const AText: string); overload;
    constructor Create(const ASQLTimeInterval: TADSQLTimeInterval); overload;
    constructor Create(const ASource: TADSQLTimeIntervalData); overload;

    // access to the private bits
    property Interval: TADSQLTimeInterval read FInterval write FInterval;
    property IsBlank: Boolean read GetIsBlank;
    property IsNegative: Boolean read GetIsNegative;

    // non-destructive operations
    function Compare(const AValue: TADSQLTimeInterval): TVarCompareResult;
    procedure DoAddTo(var ADateTime: TADSQLTimeStamp);
    procedure DoSubFrom(var ADateTime: TADSQLTimeStamp);

    // destructive operations
    procedure DoSubstract(const ADateTime1, ADateTime2: TADSQLTimeStamp); overload;
    procedure DoInc(const AInterval: TADSQLTimeInterval); overload;
    procedure DoInc(const AValue: Integer); overload;
    procedure DoDec(const AInterval: TADSQLTimeInterval); overload;
    procedure DoDec(const AValue: Integer); overload;
    procedure CastToKind(AKind: TADSQLTimeIntervalKind);
    procedure DoMultiply(AValue: Integer);
    procedure DoDivide(AValue: Integer);
    procedure DoNegate;

  published
    // conversion
    property AsString: string read GetAsString write SetAsString;
    property Sign: Shortint read FInterval.Sign write FInterval.Sign;
    property Kind: TADSQLTimeIntervalKind read FInterval.Kind write FInterval.Kind;
    property Years: LongWord read FInterval.Years write FInterval.Years;
    property Month: LongWord read FInterval.Months write FInterval.Months;
    property Days: LongWord read FInterval.Days write FInterval.Days;
    property Hour: LongWord read FInterval.Hours write FInterval.Hours;
    property Minute: LongWord read FInterval.Minutes write FInterval.Minutes;
    property Second: LongWord read FInterval.Seconds write FInterval.Seconds;
    property Fractions: LongWord read FInterval.Fractions write FInterval.Fractions;
  end;

{$IFDEF AnyDAC_D6Base}
  TADSQLTimeIntervalVariantType = class(TPublishableVariantType)
  protected
    function GetInstance(const V: TVarData): TObject; override;
  public
    procedure Clear(var V: TVarData); override;
    procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;
    procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); override;
    function RightPromotion(const V: TVarData; const Operator: TVarOp; out RequiredVarType: TVarType): Boolean; override;
    procedure BinaryOp(var Left: TVarData; const Right: TVarData; const Operator: TVarOp); override;
    procedure UnaryOp(var Right: TVarData; const Operator: TVarOp); override;
    procedure Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult); override;
  end;
{$ENDIF}

{$IFDEF AnyDAC_D6Base}
  PADSQLTimeIntervalVarData = ^TADSQLTimeIntervalVarData;
  TADSQLTimeIntervalVarData = packed record
    VType: TVarType;
    Reserved1, Reserved2, Reserved3: Word;
    VInterval: TADSQLTimeIntervalData;
    Reserved4: LongWord;
  end;

var
  GSQLTimeIntervalVariantType: TADSQLTimeIntervalVariantType = nil;
{$ENDIF}  

{-------------------------------------------------------------------------------}
{ TADSQLTimeIntervalData                                                        }
{-------------------------------------------------------------------------------}
constructor TADSQLTimeIntervalData.Create(const AText: string);
begin
  inherited Create;
  SetAsString(AText);
end;

{-------------------------------------------------------------------------------}
constructor TADSQLTimeIntervalData.Create(const ASQLTimeInterval: TADSQLTimeInterval);
begin
  inherited Create;
  FInterval := ASQLTimeInterval;
end;

{-------------------------------------------------------------------------------}
constructor TADSQLTimeIntervalData.Create(const ASource: TADSQLTimeIntervalData);
begin
  Create(ASource.FInterval);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.CheckIntervalsCompatibility(
  const AInt1, AInt2: TADSQLTimeInterval);
begin
  if not (
     (AInt1.Kind in [itYear, itMonth, itYear2Month]) and
     (AInt2.Kind in [itYear, itMonth, itYear2Month]) or
     (AInt1.Kind in [itDay, itHour, itMinute, itSecond, itDay2Hour, itDay2Minute,
                     itDay2Second, itHour2Minute, itHour2Second, itMinute2Second]) and
     (AInt2.Kind in [itDay, itHour, itMinute, itSecond, itDay2Hour, itDay2Minute,
                     itDay2Second, itHour2Minute, itHour2Second, itMinute2Second])) then
    raise EVariantError.Create('Cannot substruct intervals of incompatible kinds');
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.NotInitError;
begin
  raise EVariantError.Create('Cannot perform operation on non initialized interval value');
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalData.GetIsBlankBase(const AInterval: TADSQLTimeInterval): Boolean;
begin
  Result := (AInterval.Sign = 0) and (AInterval.Kind = itUnknown) or
    (AInterval.Days = 0) and (AInterval.Hours = 0) and (AInterval.Minutes = 0) and
    (AInterval.Seconds = 0) and (AInterval.Fractions = 0);
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalData.GetIsBlank: Boolean;
begin
  Result := GetIsBlankBase(FInterval);
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalData.GetIsNegative: Boolean;
begin
  Result := FInterval.Sign < 0;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoSubstract(const ADateTime1, ADateTime2: TADSQLTimeStamp);
var
  dVal: Double;
  lNeg: Boolean;
  wHour, wMin, wSec, wMSec: Word;
begin
  dVal := ADSQLTimeStamp2DateTime(ADateTime1) - ADSQLTimeStamp2DateTime(ADateTime2);
  if dVal < 0 then begin
    lNeg := True;
    dVal := Abs(dVal);
  end
  else
    lNeg := False;

  if lNeg then
    FInterval.Sign := -1
  else
    FInterval.Sign := 1;
  FInterval.Kind := itDay2Second;
  FInterval.Days := Trunc(dVal);

  DecodeTime(Frac(dVal), wHour, wMin, wSec, wMSec);
  FInterval.Hours := wHour;
  FInterval.Minutes := wMin;
  FInterval.Seconds := wSec;
  FInterval.Fractions := wMSec;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoAddToBase(var ADateTime: TADSQLTimeStamp;
  ASign: Integer);
var
  iSign, iVal: Integer;
  d: TDateTime;
begin
  if IsBlank then
    Exit;

  if (ASign < 0) xor (FInterval.Sign < 0) then
    iSign := -1
  else
    iSign := 1;
  case Kind of
  itYear,
  itMonth,
  itYear2Month:
    begin
      ADateTime.Year := ADateTime.Year + iSign * Integer(FInterval.Years);
      iVal := Integer(ADateTime.Month) + iSign * Integer(FInterval.Months);
      ADateTime.Year := ADateTime.Year + iVal div 12;
      iVal := iVal mod 12;
      if iVal < 0 then begin
        Dec(ADateTime.Year);
        ADateTime.Month := Word(12 + iVal);
      end
      else
        ADateTime.Month := Word(iVal);
    end;
  itDay,
  itHour,
  itMinute,
  itSecond,
  itDay2Hour,
  itDay2Minute,
  itDay2Second,
  itHour2Minute,
  itHour2Second,
  itMinute2Second:
    begin
      d := ADSQLTimeStamp2DateTime(ADateTime);
      d := d + iSign * Integer(FInterval.Days);
      d := d + iSign * MSecsPerDay / (((FInterval.Hours * 60 + FInterval.Minutes) * 60 + FInterval.Seconds) * 1000 + FInterval.Fractions);
      ADateTime := ADDateTime2SQLTimeStamp(d);
    end;
  else
    NotInitError;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoAddTo(var ADateTime: TADSQLTimeStamp);
begin
  DoAddToBase(ADateTime, 1);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoSubFrom(var ADateTime: TADSQLTimeStamp);
begin
  DoAddToBase(ADateTime, -1);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoIncrementBase(const AInterval: TADSQLTimeInterval;
  ASign: Integer);
var
  iMonths: Int64;
  iFractions: Int64;
  iSignMy, iSignArg: Integer;
begin
  if GetIsBlankBase(AInterval) then
    Exit;

  if (ASign < 0) xor (AInterval.Sign < 0) then
    iSignArg := -1
  else
    iSignArg := 1;
  if IsBlank then begin
    FInterval := AInterval;
    FInterval.Sign := iSignArg;
    Exit;
  end;

  CheckIntervalsCompatibility(FInterval, AInterval);
  iMonths := 0;
  iFractions := 0;
  if FInterval.Sign < 0 then
    iSignMy := -1
  else
    iSignMy := 1;
  case Kind of
  itYear,
  itMonth,
  itYear2Month:
    begin
      iMonths :=
        iSignMy * (Int64(FInterval.Years) * 12 + Int64(FInterval.Months)) +
        iSignArg * (Int64(AInterval.Years) * 12 + Int64(AInterval.Months));
      if iMonths < 0 then begin
        iMonths := Abs(iMonths);
        iSignMy := -1;
      end
      else
        iSignMy := 1;
    end;
  itDay,
  itHour,
  itMinute,
  itSecond,
  itDay2Hour,
  itDay2Minute,
  itDay2Second,
  itHour2Minute,
  itHour2Second,
  itMinute2Second:
    begin
      iFractions :=
        iSignMy * ((((Int64(FInterval.Days) * 24 + Int64(FInterval.Hours)) * 60 + Int64(FInterval.Minutes)) * 60 +
          Int64(FInterval.Seconds)) * 1000 + Int64(FInterval.Fractions)) +
        iSignArg * ((((Int64(AInterval.Days) * 24 + Int64(AInterval.Hours)) * 60 + Int64(AInterval.Minutes)) * 60 +
          Int64(AInterval.Seconds)) * 1000 + Int64(AInterval.Fractions));
      if iFractions < 0 then begin
        iFractions := Abs(iFractions);
        iSignMy := -1;
      end
      else
        iSignMy := 1;
    end;
  else
    NotInitError;
  end;

  FInterval.Sign := iSignMy;
  FInterval.Days := 0;
  FInterval.Hours := 0;
  FInterval.Minutes := 0;
  FInterval.Seconds := 0;
  FInterval.Fractions := 0;

  case FInterval.Kind of
  itYear:
    FInterval.Years := iMonths div 12;
  itMonth:
    FInterval.Months := iMonths;
  itYear2Month:
    begin
      FInterval.Years := iMonths div 12;
      FInterval.Months := iMonths mod 12;
    end;
  itDay:
    FInterval.Days := iFractions div (1000 * SecsPerDay);
  itHour:
    FInterval.Hours := iFractions div (1000 * SecsPerHour);
  itMinute:
    FInterval.Hours := iFractions div (1000 * SecsPerMin);
  itSecond:
    FInterval.Hours := iFractions div 1000;
  itDay2Hour:
    begin
      FInterval.Days := iFractions div (1000 * SecsPerDay);
      iFractions := iFractions - Int64(FInterval.Days) * 1000 * SecsPerDay;
      FInterval.Hours := iFractions div (1000 * SecsPerHour);
    end;
  itDay2Minute:
    begin
      FInterval.Days := iFractions div (1000 * SecsPerDay);
      iFractions := iFractions - Int64(FInterval.Days) * 1000 * SecsPerDay;
      FInterval.Hours := iFractions div (1000 * SecsPerHour);
      iFractions := iFractions - Int64(FInterval.Hours) * 1000 * SecsPerHour;
      FInterval.Minutes := iFractions div (1000 * SecsPerMin);
    end;
  itDay2Second:
    begin
      FInterval.Days := iFractions div (1000 * SecsPerDay);
      iFractions := iFractions - Int64(FInterval.Days) * 1000 * SecsPerDay;
      FInterval.Hours := iFractions div (1000 * SecsPerHour);
      iFractions := iFractions - Int64(FInterval.Hours) * 1000 * SecsPerHour;
      FInterval.Minutes := iFractions div (1000 * SecsPerMin);
      iFractions := iFractions - Int64(FInterval.Minutes) * 1000 * SecsPerMin;
      FInterval.Seconds := iFractions div 1000;
      FInterval.Fractions := iFractions - Int64(FInterval.Seconds) * 1000;
    end;
  itHour2Minute:
    begin
      FInterval.Hours := iFractions div (1000 * SecsPerHour);
      iFractions := iFractions - Int64(FInterval.Hours) * 1000 * SecsPerHour;
      FInterval.Minutes := iFractions div (1000 * SecsPerMin);
    end;
  itHour2Second:
    begin
      FInterval.Hours := iFractions div (1000 * SecsPerHour);
      iFractions := iFractions - Int64(FInterval.Hours) * 1000 * SecsPerHour;
      FInterval.Minutes := iFractions div (1000 * SecsPerMin);
      iFractions := iFractions - Int64(FInterval.Minutes) * 1000 * SecsPerMin;
      FInterval.Seconds := iFractions div 1000;
      FInterval.Fractions := iFractions - Int64(FInterval.Seconds) * 1000;
    end;
  itMinute2Second:
    begin
      FInterval.Minutes := iFractions div (1000 * SecsPerMin);
      iFractions := iFractions - Int64(FInterval.Minutes) * 1000 * SecsPerMin;
      FInterval.Seconds := iFractions div 1000;
      FInterval.Fractions := iFractions - Int64(FInterval.Seconds) * 1000;
    end;
  else
    NotInitError;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoInc(const AInterval: TADSQLTimeInterval);
begin
  DoIncrementBase(AInterval, 1);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoDec(const AInterval: TADSQLTimeInterval);
begin
  DoIncrementBase(AInterval, -1);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoIncrementBase(const AValue: Integer; ASign: Integer);
var
  rInt: TADSQLTimeInterval;
begin
  ADFillChar(rInt, SizeOf(rInt), 0);
  rInt.Sign := 1;
  rInt.Kind := FInterval.Kind;
  case FInterval.Kind of
  itYear:
    rInt.Years := AValue;
  itMonth,
  itYear2Month:
    rInt.Months := AValue;
  itDay:
    rInt.Days := AValue;
  itHour,
  itDay2Hour:
    rInt.Hours := AValue;
  itMinute,
  itDay2Minute,
  itHour2Minute:
    rInt.Minutes := AValue;
  itSecond,
  itDay2Second,
  itHour2Second,
  itMinute2Second:
    rInt.Seconds := AValue;
  else
    NotInitError;
  end;
  DoIncrementBase(rInt, ASign);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoInc(const AValue: Integer);
begin
  DoIncrementBase(AValue, 1);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoDec(const AValue: Integer);
begin
  DoIncrementBase(AValue, -1);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoDivide(AValue: Integer);
begin
  if AValue < 0 then begin
    AValue := Abs(AValue);
    DoNegate;
  end;
  case FInterval.Kind of
  itYear,
  itMonth,
  itYear2Month:
    begin
      FInterval.Years := FInterval.Years div LongWord(AValue);
      FInterval.Months := FInterval.Months div LongWord(AValue);
    end;
  itDay,
  itHour,
  itMinute,
  itSecond,
  itDay2Hour,
  itDay2Minute,
  itDay2Second,
  itHour2Minute,
  itHour2Second,
  itMinute2Second:
    begin
      FInterval.Days := FInterval.Days div LongWord(AValue);
      FInterval.Hours := FInterval.Hours div LongWord(AValue);
      FInterval.Minutes := FInterval.Minutes div LongWord(AValue);
      FInterval.Seconds := FInterval.Seconds div LongWord(AValue);
      FInterval.Fractions := FInterval.Fractions div LongWord(AValue);
    end;
  else
    NotInitError;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoMultiply(AValue: Integer);
begin
  if AValue < 0 then begin
    AValue := Abs(AValue);
    DoNegate;
  end;
  case FInterval.Kind of
  itYear,
  itMonth,
  itYear2Month:
    begin
      FInterval.Years := FInterval.Years * LongWord(AValue);
      FInterval.Months := FInterval.Months * LongWord(AValue);
    end;
  itDay,
  itHour,
  itMinute,
  itSecond,
  itDay2Hour,
  itDay2Minute,
  itDay2Second,
  itHour2Minute,
  itHour2Second,
  itMinute2Second:
    begin
      FInterval.Days := FInterval.Days * LongWord(AValue);
      FInterval.Hours := FInterval.Hours * LongWord(AValue);
      FInterval.Minutes := FInterval.Minutes * LongWord(AValue);
      FInterval.Seconds := FInterval.Seconds * LongWord(AValue);
      FInterval.Fractions := FInterval.Fractions * LongWord(AValue);
    end;
  else
    NotInitError;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.DoNegate;
begin
  if FInterval.Sign < 0 then
    FInterval.Sign := 1
  else
    FInterval.Sign := -1;
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalData.Compare(const AValue: TADSQLTimeInterval): TVarCompareResult;
var
  oData: TADSQLTimeIntervalData;
begin
  oData := TADSQLTimeIntervalData.Create(FInterval);
  try
    oData.DoDec(AValue);
    if oData.IsBlank then
      Result := crEqual
    else if oData.IsNegative then
      Result := crLessThan
    else
      Result := crGreaterThan;
  finally
    ADFree(oData);
  end;
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalData.GetAsString: string;
begin
  if IsBlank then
    Result := ''
  else begin
    case FInterval.Kind of
    itYear,
    itMonth,
    itYear2Month:
      Result := Format('%u-%.2u', [FInterval.Years, FInterval.Months]);
    itDay:
      Result := Format('%u', [FInterval.Days]);
    itDay2Hour,
    itDay2Minute,
    itDay2Second:
      begin
        Result := Format('%u %.2u:%.2u:%.2u', [FInterval.Days, FInterval.Hours,
          FInterval.Minutes, FInterval.Seconds]);
        if FInterval.Fractions <> 0 then
          Result := Result + Format('.%.3u', [FInterval.Fractions]);
      end;
    itHour,
    itMinute,
    itSecond,
    itHour2Minute,
    itHour2Second,
    itMinute2Second:
      begin
        Result := Format('%u:%.2u:%.2u', [FInterval.Hours, FInterval.Minutes,
          FInterval.Seconds]);
        if FInterval.Fractions <> 0 then
          Result := Result + Format('.%.3u', [FInterval.Fractions]);
      end;
    else
      NotInitError;
    end;
    if FInterval.Sign < 0 then
      Result := '-' + Result;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.SetAsString(const AValue: string);
var
  pCh, pSep: PChar;
  iSign: Integer;

  procedure NextGroup;
  begin
    while pCh^ = ' ' do
      Inc(pCh);
    if pCh^ = '-' then begin
      iSign := -1;
      Inc(pCh);
    end
    else if pCh^ = '+' then
      Inc(pCh);
  end;

  function NextItem(out APart: LongWord; ADelim: Char; ARequired: Boolean): Boolean;
  begin
    if pCh^ = #0 then begin
      Result := False;
      Exit;
    end;
    pSep := StrScan(pCh, ADelim);
    Result := pSep <> nil;
    if not Result then
      if ARequired then
        Exit
      else
        pSep := PChar(AValue) + Length(AValue);
    ADStr2Int(pCh, pSep - pCh, @APart, SizeOf(APart), True);
    if pSep^ = #0 then
      pCh := pSep
    else
      pCh := pSep + 1;
  end;

  procedure Error;
  begin
    raise EVariantError.CreateFmt('[%s] is not a valid interval', [AValue]);
  end;

begin
  ADFillChar(FInterval, SizeOf(FInterval), 0);
  if AValue = '' then
    Exit;

  pCh := PChar(AValue);
  iSign := 1;
  NextGroup;
  if NextItem(FInterval.Years, '-', True) then begin
    NextItem(FInterval.Months, ' ', False);
    FInterval.Kind := itYear2Month;
  end
  else begin
    NextGroup;
    if NextItem(FInterval.Days, ' ', True) then
      FInterval.Kind := itDay;

    NextGroup;
    if NextItem(FInterval.Hours, ':', True) then begin
      NextItem(FInterval.Minutes, ':', False);
      NextItem(FInterval.Seconds, '.', False);
      NextItem(FInterval.Fractions, #0, False);
      if FInterval.Kind = itDay then
        FInterval.Kind := itDay2Second
      else
        FInterval.Kind := itHour2Second;
    end;
  end;
  if (pCh^ <> #0) or (FInterval.Kind = itUnknown) then
    Error;
  FInterval.Sign := iSign;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalData.CastToKind(AKind: TADSQLTimeIntervalKind);
var
  oData: TADSQLTimeIntervalData;
begin
  oData := TADSQLTimeIntervalData.Create(C_NullSQLTimeInterval);
  try
    oData.Kind := AKind;
    oData.DoInc(Interval);
    Interval := oData.Interval;
  finally
    ADFree(oData);
  end;
end;

{$IFDEF AnyDAC_D6Base}
{-------------------------------------------------------------------------------}
{ TADSQLTimeIntervalVariantType                                                 }
{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalVariantType.GetInstance(const V: TVarData): TObject;
begin
  Result := PADSQLTimeIntervalVarData(@V)^.VInterval;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalVariantType.Clear(var V: TVarData);
begin
  V.VType := varEmpty;
  ADFreeAndNil(PADSQLTimeIntervalVarData(@V)^.VInterval);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalVariantType.Cast(var Dest: TVarData; const Source: TVarData);
var
  LSource: TVarData;
begin
  VarDataInit(LSource);
  try
    VarDataCopyNoInd(LSource, Source);
    if VarDataIsStr(LSource) then
      PADSQLTimeIntervalVarData(@Dest)^.VInterval := TADSQLTimeIntervalData.Create(VarDataToStr(LSource))
    else
      RaiseCastError;
    Dest.VType := VarType;
  finally
    VarDataClear(LSource);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalVariantType.CastTo(var Dest: TVarData;
  const Source: TVarData; const AVarType: TVarType);
begin
  if Source.VType = VarType then
    case AVarType of
{$IFNDEF NEXTGEN}
      varOleStr:
        VarDataFromOleStr(Dest, PADSQLTimeIntervalVarData(@Source)^.VInterval.AsString);
{$ELSE}
      varOleStr,
{$ENDIF}
{$IFDEF AnyDAC_D12}
      varUString,
{$ENDIF}
      varString:
        VarDataFromStr(Dest, PADSQLTimeIntervalVarData(@Source)^.VInterval.AsString);
      else
        RaiseCastError;
    end
  else
    inherited;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalVariantType.Copy(var Dest: TVarData;
  const Source: TVarData; const Indirect: Boolean);
begin
  if Indirect and VarDataIsByRef(Source) then
    VarDataCopyNoInd(Dest, Source)
  else begin
    PADSQLTimeIntervalVarData(@Dest)^.VType := VarType;
    PADSQLTimeIntervalVarData(@Dest)^.VInterval :=
      TADSQLTimeIntervalData.Create(PADSQLTimeIntervalVarData(@Source)^.VInterval);
  end;
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalVariantType.RightPromotion(const V: TVarData;
  const Operator: TVarOp; out RequiredVarType: TVarType): Boolean;
begin
  RequiredVarType := VarType;
  Result := True;
{$IFDEF AnyDAC_D6}
  case Operator of
    opAdd:
      if VarIsSQLTimeStamp(Variant(V)) then
        RequiredVarType := VarSQLTimeStamp;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalVariantType.BinaryOp(var Left: TVarData;
  const Right: TVarData; const Operator: TVarOp);
{$IFDEF AnyDAC_D6}
var
  rTS: TSQLTimeStamp;
{$ENDIF}
begin
  case Operator of
    opAdd:
{$IFDEF AnyDAC_D6}
      if VarIsSQLTimeStamp(Variant(Right)) then begin
        rTS := VarToSQLTimeStamp(Variant(Right));
        PADSQLTimeIntervalVarData(@Left)^.VInterval.DoAddTo(rTS);
        Variant(Left) := VarSQLTimeStampCreate(rTS);
      end
      else
{$ENDIF}
      if ADVarIsSQLTimeInterval(Variant(Right)) then
        PADSQLTimeIntervalVarData(@Left)^.VInterval.DoInc(
          PADSQLTimeIntervalVarData(@Right)^.VInterval.Interval)
      else if VarDataIsNumeric(Right) then
        PADSQLTimeIntervalVarData(@Left)^.VInterval.DoInc(Integer(Variant(Right)))
      else
        RaiseInvalidOp;
    opSubtract:
{$IFDEF AnyDAC_D6}
      if VarIsSQLTimeStamp(Variant(Right)) then begin
        rTS := VarToSQLTimeStamp(Variant(Right));
        PADSQLTimeIntervalVarData(@Left)^.VInterval.DoSubFrom(rTS);
        Variant(Left) := VarSQLTimeStampCreate(rTS);
      end
      else
{$ENDIF}
      if ADVarIsSQLTimeInterval(Variant(Right)) then
        PADSQLTimeIntervalVarData(@Left)^.VInterval.DoDec(
          PADSQLTimeIntervalVarData(@Right)^.VInterval.Interval)
      else if VarDataIsNumeric(Right) then
        PADSQLTimeIntervalVarData(@Left)^.VInterval.DoDec(Integer(Variant(Right)))
      else
        RaiseInvalidOp;
    opMultiply:
      if VarDataIsNumeric(Right) then
        PADSQLTimeIntervalVarData(@Left)^.VInterval.DoMultiply(Integer(Variant(Right)))
      else
        RaiseInvalidOp;
    opDivide:
      if VarDataIsNumeric(Right) then
        PADSQLTimeIntervalVarData(@Left)^.VInterval.DoDivide(Integer(Variant(Right)))
      else
        RaiseInvalidOp;
  else
    RaiseInvalidOp;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalVariantType.UnaryOp(var Right: TVarData;
  const Operator: TVarOp);
begin
  case Operator of
  opNegate:
    if ADVarIsSQLTimeInterval(Variant(Right)) then
      PADSQLTimeIntervalVarData(@Right)^.VInterval.DoNegate
    else
      RaiseInvalidOp;
  else
    RaiseInvalidOp;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalVariantType.Compare(const Left, Right: TVarData;
  var Relationship: TVarCompareResult);
begin
  Relationship := PADSQLTimeIntervalVarData(@Left)^.VInterval.Compare(
    PADSQLTimeIntervalVarData(@Right)^.VInterval.Interval);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ Utilities                                                                     }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6Base}
function ADVarSQLTimeIntervalCreate: Variant;
begin
  Result := ADVarSQLTimeIntervalCreate('');
end;

{-------------------------------------------------------------------------------}
function ADVarSQLTimeIntervalCreate(const AValue: string): Variant;
begin
  VarClear(Result);
  TVarData(Result).VType := GSQLTimeIntervalVariantType.VarType;
  TADSQLTimeIntervalData(TVarData(Result).VPointer) := TADSQLTimeIntervalData.Create(AValue);
end;

{-------------------------------------------------------------------------------}
function ADVarSQLTimeIntervalCreate(const AValue: TADSQLTimeInterval): Variant;
begin
  VarClear(Result);
  TVarData(Result).VType := GSQLTimeIntervalVariantType.VarType;
  TADSQLTimeIntervalData(TVarData(Result).VPointer) := TADSQLTimeIntervalData.Create(AValue);
end;

{-------------------------------------------------------------------------------}
function ADVarSQLTimeInterval: TVarType;
begin
  Result := GSQLTimeIntervalVariantType.VarType;
end;

{-------------------------------------------------------------------------------}
function ADVarIsSQLTimeInterval(const AValue: Variant): Boolean; overload;
begin
  Result := TVarData(AValue).VType = GSQLTimeIntervalVariantType.VarType;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADVar2SQLTimeInterval(const AValue: Variant): TADSQLTimeInterval;
var
  oData: TADSQLTimeIntervalData;
begin
  case TVarData(AValue).VType of
  varNull,
  varEmpty:
    Result := C_NullSQLTimeInterval;
{$IFDEF AnyDAC_D12}
  varUString,
{$ENDIF}
  varString,
  varOleStr:
    begin
      oData := TADSQLTimeIntervalData.Create(String(AValue));
      try
        Result := oData.Interval;
      finally
        ADFree(oData);
      end;
    end;
  else
{$IFDEF AnyDAC_D6Base}
    if TVarData(AValue).VType = GSQLTimeIntervalVariantType.VarType then
      Result := TADSQLTimeIntervalData(TVarData(AValue).VPointer).Interval
    else
{$ENDIF}    
      raise EVariantError.Create(SInvalidVarCast);
  end;
end;

{-------------------------------------------------------------------------------}
function ADStr2SQLTimeInterval(const AValue: String): TADSQLTimeInterval;
var
  oData: TADSQLTimeIntervalData;
begin
  oData := TADSQLTimeIntervalData.Create(AValue);
  try
    Result := oData.Interval;
  finally
    ADFree(oData);
  end;
end;

{-------------------------------------------------------------------------------}
function ADSQLTimeInterval2Str(const AValue: TADSQLTimeInterval): String;
var
  oData: TADSQLTimeIntervalData;
begin
  oData := TADSQLTimeIntervalData.Create(AValue);
  try
    Result := oData.AsString;
  finally
    ADFree(oData);
  end;
end;

{-------------------------------------------------------------------------------}
function ADSQLTimeIntervalCompare(const AValue1, AValue2: TADSQLTimeInterval): Integer;
var
  oData: TADSQLTimeIntervalData;
begin
  oData := TADSQLTimeIntervalData.Create(AValue1);
  try
    case oData.Compare(AValue2) of
    crLessThan:    Result := -1;
    crGreaterThan: Result := 1;
    else           Result := 0;
    end;
  finally
    ADFree(oData);
  end;
end;

{-------------------------------------------------------------------------------}
function ADSQLTimeIntervalCast(const AValue: TADSQLTimeInterval;
  AKind: TADSQLTimeIntervalKind): TADSQLTimeInterval;
var
  oData: TADSQLTimeIntervalData;
begin
  oData := TADSQLTimeIntervalData.Create(AValue);
  try
    oData.CastToKind(AKind);
    Result := oData.Interval;
  finally
    ADFree(oData);
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
initialization
  GSQLTimeIntervalVariantType := TADSQLTimeIntervalVariantType.Create;

finalization
  ADFreeAndNil(GSQLTimeIntervalVariantType);
{$ENDIF}

end.
