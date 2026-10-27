{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{      FireDAC SQL script engine standard commands      }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompScriptCommands;

interface

{-------------------------------------------------------------------------------}
implementation

uses
  SysUtils, Classes, DB,
{$IFDEF AnyDAC_D6}
  FmtBCD,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
  uADStanIntf, uADStanParam, uADStanConst, uADStanUtil, uADStanError,
    uADStanOption, uADStanAsync,
  uADDatSManager,
  uADGUIxIntf,
  uADPhysIntf,
  uADCompClient, uADCompScript, uADCompDataMove;

type
  TADSQLScriptCommand = class;
  TADPLSQLScriptCommand = class;
  TADRunScriptCommand = class;
  TADAcceptScriptCommand = class;
  TADConnectScriptCommand = class;
  TADDefineScriptCommand = class;
  TADDisconnectScriptCommand = class;
  TADExecuteScriptCommand = class;
  TADExitScriptCommand = class;
  TADHostScriptCommand = class;
  TADShowTextScriptCommand = class;
  TADPauseScriptCommand = class;
  TADPromptScriptCommand = class;
  TADPrintScriptCommand = class;
  TADSetScriptCommand = class;
  TADSpoolScriptCommand = class;
  TADUndefineScriptCommand = class;
  TADVariableScriptCommand = class;
  TADHelpScriptCommand = class;
  TADRemarkScriptCommand = class;
  TADCopyScriptCommand = class;
  TADDelimiterScriptCommand = class;
  TADIBCreateDBScriptCommand = class;
  TADIBDropDBScriptCommand = class;

  TADSQLScriptCommand = class(TADScriptCommand)
  private
    FSQL: String;
    FIsPLSQL: Boolean;
    procedure DumpParams;
    procedure DumpTableHeader(ATable: TADDatSTable; var ALinesPrinted: Integer);
    procedure DumpTableRows(ATable: TADDatSTable; var ALinesPrinted: Integer);
    procedure DumpServerOutput;
    function PadVal(AColumn: TADDatSColumn; const AVal: String; APadChar: Char = ' '): String;
    procedure DumpMacros;
    function DumpVarBytes(const AVal: Variant): String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump: String; override;
{$ENDIF}
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    property SQL: String read FSQL;
  end;

  TADPLSQLScriptCommand = class(TADSQLScriptCommand)
  public
    constructor Create(AParser: TADScriptParser; AEngine: TADScript); override;
{$IFDEF AnyDAC_MONITOR}
    function Dump: String; override;
{$ENDIF}
  end;

  TADRunScriptCommand = class(TADScriptCommand)
  private
    FFileName: String;
    FArguments: TStrings;
    FUseParentPath: Boolean;
    procedure InternalExecute(ARealExecute: Boolean);
  public
    constructor Create(AParser: TADScriptParser; AEngine: TADScript); override;
    destructor Destroy; override;
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    procedure Validate(); override;
    property FileName: String read FFileName;
    property Arguments: TStrings read FArguments;
    property UseParentPath: Boolean read FUseParentPath;
  end;

  TADAcceptScriptCommand = class(TADScriptCommand)
  private
    FVariable: String;
    FDataType: TFieldType;
    FFmt: String;
    FDef: String;
    FPrompt: String;
    FHide: Boolean;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    property Variable: String read FVariable;
    property DataType: TFieldType read FDataType;
    property Fmt: String read FFmt;
    property Def: String read FDef;
    property Prompt: String read FPrompt;
    property Hide: Boolean read FHide;
  end;

  TADConnectScriptCommand = class(TADScriptCommand)
  private
    FConnectString: String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    property ConnectString: String read FConnectString;
  end;

  TADDefineScriptCommand = class(TADScriptCommand)
  private
    FMode: Integer;
    FName: String;
    FSValue: String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    // -1 - show defs, 0 - show def, 1 - set def
    property Mode: Integer read FMode;
    property Name: String read FName;
    property Value: String read FSValue;
  end;

  TADDisconnectScriptCommand = class(TADScriptCommand)
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    procedure Execute(); override;
  end;

  TADExecuteScriptCommand = class(TADSQLScriptCommand)
  private
    FBlock: String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    property Block: String read FBlock;
  end;

  TADExitScriptCommandAction = (eaNone, eaCommit, eaRollback);
  TADExitScriptCommand = class(TADScriptCommand)
  private
    FAction: TADExitScriptCommandAction;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    procedure Validate(); override;
    property Action: TADExitScriptCommandAction read FAction;
  end;

  TADHostScriptCommand = class(TADScriptCommand)
  private
    FCommand: String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    property Command: String read FCommand;
  end;

  TADShowTextScriptCommand = class(TADScriptCommand)
  private
    FText: String;
  public
    property Text: String read FText;
  end;

  TADPauseScriptCommand = class(TADShowTextScriptCommand)
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
  end;

  TADPromptScriptCommand = class(TADShowTextScriptCommand)
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
  end;

  TADPrintScriptCommand = class(TADScriptCommand)
  private
    FVars: TStrings;
  public
    constructor Create(AParser: TADScriptParser; AEngine: TADScript); override;
    destructor Destroy; override;
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    property Vars: TStrings read FVars;
  end;

  TADSetScriptCommandKind = (skNone, skArraySize, skAutoCommit, skAutoPrint,
    skCharacterSet, skClientLib, skCmdSep, skDropNonexistObj, skDefine, skEcho,
    skEncoding, skFeedback, skHeading, skLineSize, skLong, skParamArraySize,
    skPageSize, skScan, skServerOutput, skSQLDialect, skTermout, skTiming,
    skBreakOnError, skIgnoreError, skTrimConsole, skTrimSpool, skVerify);

  TADSetScriptCommandItem = class(TObject)
    FSetKind: TADSetScriptCommandKind;
    FIValue: Integer;
    FSValue: String;
    FEchoCommands: TADScriptEchoCommands;
  end;
  TADSetScriptCommandItems = array of TADSetScriptCommandItem;

  TADSetScriptCommand = class(TADScriptCommand)
  private
    FItems: TADSetScriptCommandItems;
  public
    constructor Create(AParser: TADScriptParser; AEngine: TADScript); override;
    destructor Destroy; override;
    function AddItem(ASetKind: TADSetScriptCommandKind; AIValue: Integer = 0;
      ASValue: String = ''; AEchoCommands: TADScriptEchoCommands = ecNone): TADSetScriptCommandItem;
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    procedure Validate(); override;
    property Items: TADSetScriptCommandItems read FItems;
  end;

  TADSpoolScriptCommand = class(TADScriptCommand)
  private
    FMode: Integer;
    FFileName: String;
    FAppend: Boolean;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    // -1 - off, 0 - show, 1 - file
    property Mode: Integer read FMode;
    property Append: Boolean read FAppend;
    property FileName: String read FFileName;
  end;

  TADUndefineScriptCommand = class(TADScriptCommand)
  private
    FVars: TStrings;
  public
    constructor Create(AParser: TADScriptParser; AEngine: TADScript); override;
    destructor Destroy; override;
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    property Vars: TStrings read FVars;
  end;

  TADVariableScriptCommand = class(TADScriptCommand)
  private
    FMode: Integer;
    FVariable: String;
    FDataType: TFieldType;
    FSize: Integer;
    FTableSize: Integer;
    FParamType: TParamType;
    FValue: String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    // -1 - show vars, 0 - show var, 1 - def var
    property Mode: Integer read FMode;
    property Variable: String read FVariable;
    property DataType: TFieldType read FDataType;
    property Size: Integer read FSize;
    property TableSize: Integer read FTableSize;
    property ParamType: TParamType read FParamType;
    property Value: String read FValue;
  end;

  TADHelpScriptCommand = class(TADScriptCommand)
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    procedure Execute(); override;
  end;

  TADRemarkScriptCommand = class(TADScriptCommand)
  private
    FText: String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    property Text: String read FText;
  end;

  TADCopyScriptCommand = class(TADScriptCommand)
  private
    FDataMove: TADDataMove;
    FSrcQuery: TADQuery;
    FSrcConnection: TADConnection;
    FDestQuery: TADQuery;
    FDestConnection: TADConnection;
    FSrcConnStr: String;
    FDestConnStr: String;
    FConfigFile: String;
    FConfigParams: String;
    FLogToSpool: Boolean;
    procedure DumpServerOutput;
  public
    constructor Create(AParser: TADScriptParser; AEngine: TADScript); override;
    destructor Destroy; override;
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    procedure AbortJob(const AWait: Boolean); override;
  end;

  TADDelimiterScriptCommand = class(TADScriptCommand)
  private
    FCmdSep: String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; override;
{$ENDIF}
    class function Help(): String; override;
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    procedure Validate(); override;
    property CmdSep: String read FCmdSep;
  end;

  TADIBCreateDBScriptCommand = class(TADScriptCommand)
  private
    FDB, FUser, FPwd, FPageSize, FCharset: String;
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump: String; override;
{$ENDIF}
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
    property DB: String read FDB;
    property User: String read FUser;
    property Pwd: String read FPwd;
    property PageSize: String read FPageSize;
    property Charset: String read FCharset;
  end;

  TADIBDropDBScriptCommand = class(TADScriptCommand)
  public
{$IFDEF AnyDAC_MONITOR}
    function Dump: String; override;
{$ENDIF}
    class procedure Keywords(AKwds: TStrings); override;
    function Parse(const AKwd: String): Boolean; override;
    procedure Execute(); override;
  end;

{-------------------------------------------------------------------------------}
{ TADSQLScriptCommand                                                           }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADSQLScriptCommand.Dump: String;
begin
  Result := '<SQL> [' + FSQL + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADSQLScriptCommand.Parse(const AKwd: String): Boolean;
begin
  FSQL := AKwd;
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADSQLScriptCommand.DumpVarBytes(const AVal: Variant): String;
var
  iLen, i, iText: Integer;
  b: Byte;
  sChar: String;
begin
  if not VarIsArray(AVal) then begin
    Result := VarToStr(AVal);
    Exit;
  end;
  iText := 1;
  iLen := VarArrayHighBound(AVal, 1);
  i := 0;
  SetLength(Result, (iLen + 1) * 4);
  while i <= iLen do begin
    b := AVal[i];
    if (b < Ord(' ')) and not ((b = 13) or (b = 10) or (b = 9)) then begin
      sChar := '#' + IntToStr(b);
      Move(sChar[1], Result[iText], Length(sChar) * SizeOf(Char));
      Inc(iText, Length(sChar));
    end
    else begin
      Result[iText] := Char(b);
      Inc(iText);
    end;
    Inc(i);
  end;
  SetLength(Result, iText - 1);
end;

{-------------------------------------------------------------------------------}
function TADSQLScriptCommand.PadVal(AColumn: TADDatSColumn; const AVal: String;
  APadChar: Char): String;
var
  iDispWidth: Integer;
begin
  if AColumn.DataType in [dtAnsiString, dtWideString, dtByteString,
                          dtBlob, dtMemo, dtWideMemo, dtXML,
                          dtHBlob, dtHMemo, dtWideHMemo,
                          dtHBFile] then
    iDispWidth := Engine.ScriptOptions.MaxStringWidth
  else
    iDispWidth := AColumn.DisplayWidth;
  if iDispWidth < Length(AColumn.Caption) then
    iDispWidth := Length(AColumn.Caption);
  if Length(AVal) > iDispWidth then
    Result := Copy(AVal, 1, iDispWidth - 4) + ' ...'
  else
    Result := AVal;
  if AColumn.DataType in [dtAnsiString, dtWideString, dtByteString,
                          dtBlob, dtMemo, dtWideMemo, dtXML,
                          dtHBlob, dtHMemo, dtWideHMemo,
                          dtHBFile] then
    Result := Result + StringOfChar(APadChar, iDispWidth - Length(Result))
  else
    Result := StringOfChar(APadChar, iDispWidth - Length(Result)) + Result;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScriptCommand.DumpParams;
begin
  { TODO -cSCRIPT : Parameters dumping to be implemented }
  EngineIntf.ConPut('Parameters dumping is not implemented', soError);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScriptCommand.DumpTableHeader(ATable: TADDatSTable; var ALinesPrinted: Integer);
var
  c: Integer;
  s: String;
begin
  { TODO -cSCRIPT : Use LineSize }
  s := '';
  for c := 0 to ATable.Columns.Count - 1 do begin
    if c > 0 then
      s := s + '  ';
    s := s + PadVal(ATable.Columns[c], ATable.Columns[c].Name);
  end;
  EngineIntf.ConPut(s, soData);
  Inc(ALinesPrinted);
  s := '';
  for c := 0 to ATable.Columns.Count - 1 do begin
    if c > 0 then
      s := s + '  ';
    s := s + PadVal(ATable.Columns[c], '', '-');
  end;
  EngineIntf.ConPut(s, soData);
  Inc(ALinesPrinted);
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADSQLScriptCommand.DumpTableRows(ATable: TADDatSTable; var ALinesPrinted: Integer);
var
  i: Integer;
  c: Integer;
  s: String;
  dt: TDateTime;
  oCol: TADDatSColumn;
  oRow: TADDatSRow;
begin
  { TODO -cSCRIPT : Use LineSize }
  for i := 0 to ATable.Rows.Count - 1 do begin
    if (ALinesPrinted = 0) and
       Engine.ScriptOptions.ColumnHeadings and (Engine.ScriptOptions.PageSize > 0) then
      DumpTableHeader(ATable, ALinesPrinted);
    s := '';
    for c := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[c];
      oRow := ATable.Rows[i];
      if c > 0 then
        s := s + '  ';
      if oCol.DataType in [dtByteString, dtBlob, dtHBlob, dtHBFile] then
        s := s + PadVal(oCol, DumpVarBytes(oRow.GetData(c)))
      else if oCol.DataType <> dtTime then
        s := s + PadVal(oCol, VarToStr(oRow.GetData(c)))
      else begin
        dt := VarAsType(oRow.GetData(c), varDate);
        // Delphi does not support negative time value
        if dt < 0 then
          s := s + PadVal(oCol, '-' + TimeToStr(dt))
        else
          s := s + PadVal(oCol, TimeToStr(dt));
      end;
    end;
    EngineIntf.ConPut(s, soData);
    Inc(ALinesPrinted);
    if ALinesPrinted >= Engine.ScriptOptions.PageSize - 1 then begin
      EngineIntf.ConPut('', soSeparator);
      ALinesPrinted := 0;
    end;
  end;
end;
{$IFNDEF AnyDAC_D12}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADSQLScriptCommand.DumpServerOutput;
var
  i: Integer;
begin
  if not (EngineIntf.ConnectionIntf.Options.ResourceOptions as TADTopResourceOptions).ServerOutput or
     (EngineIntf.ConnectionIntf.Messages = nil) or (EngineIntf.ConnectionIntf.Messages.ErrorCount = 0) then
    Exit;
  for i := 0 to EngineIntf.ConnectionIntf.Messages.ErrorCount - 1 do
    EngineIntf.ConPut(EngineIntf.ConnectionIntf.Messages[i].Message, soServerOutput);
  EngineIntf.ConPut('', soSeparator);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScriptCommand.DumpMacros;
var
  oSrc, oDest: TADStringList;
  i: Integer;
begin
  oSrc := TADStringList.Create;
  oDest := TADStringList.Create;
  try
    oSrc.Text := ADFixCRLF(FSQL);
    oDest.Text := ADFixCRLF(EngineIntf.CommandIntf.SQLText);
    for i := 0 to oSrc.Count - 1 do
      if oSrc[i] <> oDest[i] then begin
        EngineIntf.ConPut(Format('old %d:%s', [i + 1, oSrc[i]]), soMacro);
        EngineIntf.ConPut(Format('new %d:%s', [i + 1, oDest[i]]), soMacro);
      end;
  finally
    ADFree(oSrc);
    ADFree(oDest);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScriptCommand.Execute();
var
  iRows: LongWord;
  iLinesPrinted: Integer;
  dwStartTime: LongWord;
  dwExecTime: LongWord;
  lOpen: Boolean;
  sFeedback: String;
  eCmdKind: TADPhysCommandKind;
  lWasRowset: Boolean;
  oExc: EADException;
  oCmd: IADPhysCommand;
  oFtch: TADFetchOptions;
  oRes: TADResourceOptions;
begin
  EngineIntf.CheckCommand;
  EngineIntf.CheckStartTransaction;
  oCmd := EngineIntf.CommandIntf;
  oCmd.Disconnect;

  oFtch := oCmd.Options.FetchOptions;
  oFtch.AutoClose := False;
  oFtch.AutoFetchAll := afAll;
  oFtch.Items := oFtch.Items - [fiMeta];

  oRes := oCmd.Options.ResourceOptions;
  if oRes.CmdExecMode = amAsync then
    oRes.CmdExecMode := amBlocking;
  oRes.DirectExecute := True;
  oRes.MacroCreate := False;
  oRes.MacroExpand := Engine.ScriptOptions.MacroExpand;
  oRes.Persistent := False;

  lOpen := Engine.ScriptOptions.ParamArraySize = 1;
  lWasRowset := False;
  dwExecTime := 0;
  dwStartTime := ADGetTickCount();
  eCmdKind := skUnknown;
  try
    try
      try
        oCmd.CommandText := FSQL;
        oCmd.Params.AssignValues(Engine.Params);
        oCmd.Prepare;
        eCmdKind := oCmd.CommandKind;
        if Engine.ScriptOptions.Verify then
          DumpMacros;
        while oCmd.State <> csInactive do begin
          if lOpen then begin
            iRows := 0;
            iLinesPrinted := 0;
            oCmd.Open;
            if oCmd.State <> csOpen then
              Break;
            lWasRowset := True;
            oCmd.Define(EngineIntf.Table, mmReset);
            repeat
              EngineIntf.ConLockUpdate;
              try
                EngineIntf.Table.Clear;
                oCmd.Fetch(EngineIntf.Table, False);
                Inc(iRows, EngineIntf.Table.Rows.Count);
                DumpTableRows(EngineIntf.Table, iLinesPrinted);
              finally
                EngineIntf.ConUnlockUpdate;
              end;
            until EngineIntf.Table.Rows.Count = 0;
            if iLinesPrinted > 0 then
              EngineIntf.ConPut('', soSeparator);
            if Engine.ScriptOptions.FeedbackCommands then
              if iRows = 0 then
                EngineIntf.ConPut('no rows selected.', soCommand)
              else if iRows = 1 then
                EngineIntf.ConPut('1 row selected.', soCommand)
              else
                EngineIntf.ConPut(IntToStr(iRows) + ' rows selected.', soCommand);
          end
          else
            oCmd.Execute(Engine.ScriptOptions.ParamArraySize, 0);
          oCmd.NextRecordSet := True;
          oCmd.Close;
          lOpen := True;
        end;
        Engine.Params.AssignValues(oCmd.Params, [ptOutput .. ptResult]);
      finally
        dwExecTime := ADGetTickCount() - dwStartTime;
        if Engine.ScriptOptions.RaisePLSQLErrors and
           (EngineIntf.ConnectionIntf.Messages <> nil) and
           // ORA-24344: Compiled with errors
           (EngineIntf.ConnectionIntf.Messages[0].ErrorCode = 24344) then begin
          oExc := nil;
          EngineIntf.ConnectionIntf.Messages.Duplicate(oExc);
          raise oExc;
        end;
        if (EngineIntf.ConnectionIntf <> nil) and
           (EngineIntf.ConnectionIntf.Options.ResourceOptions as TADTopResourceOptions).ServerOutput then
          DumpServerOutput;
      end;
    except
      on E: EADDBEngineException do begin
        if (E.Kind = ekObjNotExists) and Engine.ScriptOptions.DropNonexistObj and
           ((eCmdKind = skUnknown) and (oCmd.CommandKind in [skDrop, skAlter]) or (eCmdKind in [skDrop, skAlter])) then begin
          if Engine.ScriptOptions.FeedbackCommands then
            if E[0].ObjName <> '' then
              EngineIntf.ConPut('[' + E[0].ObjName + '] does not exists.', soCommand)
            else
              EngineIntf.ConPut('Object does not exists. ', soCommand);
        end
        else
          raise;
      end;
    end;
    EngineIntf.CheckCommit(False);
    if Engine.ScriptOptions.FeedbackCommands then begin
      sFeedback := '';
      if not lWasRowset then
        if oCmd.RowsAffectedReal then
          if oCmd.RowsAffected = 0 then
            sFeedback := 'no rows processed'
          else if oCmd.RowsAffected = 1 then
            sFeedback := '1 row processed'
          else
            sFeedback := IntToStr(oCmd.RowsAffected) + ' rows processed'
        else
          sFeedback := 'Ok';
      if Engine.ScriptOptions.Timing then begin
        if sFeedback <> '' then
          sFeedback := sFeedback + ' ';
        sFeedback := sFeedback + Format('[%.2d:%.2d:%.2d.%.3d]', [
          (dwExecTime div 3600000) mod 60, (dwExecTime div 60000) mod 60,
          (dwExecTime div 1000) mod 60, dwExecTime mod 1000]);
      end;
      if sFeedback <> '' then begin
        sFeedback := sFeedback + '.';
        EngineIntf.ConPut(sFeedback, soCommand);
      end;
    end;
    if Engine.ScriptOptions.AutoPrintParams then
      DumpParams;
//      EngineIntf.ConPut('');
  finally
    oCmd.AbortJob(True);
    oCmd.NextRecordSet := False;
    oCmd.Disconnect;
    EngineIntf.Table.Reset;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPLSQLScriptCommand                                                         }
{-------------------------------------------------------------------------------}
constructor TADPLSQLScriptCommand.Create(AParser: TADScriptParser;
  AEngine: TADScript);
begin
  inherited Create(AParser, AEngine);
  FIsPLSQL := True;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADPLSQLScriptCommand.Dump: String;
begin
  Result := '<PL/SQL> [' + FSQL + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADRunScriptCommand                                                           }
{-------------------------------------------------------------------------------}
constructor TADRunScriptCommand.Create(AParser: TADScriptParser;
  AEngine: TADScript);
begin
  inherited Create(AParser, AEngine);
  FArguments := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADRunScriptCommand.Destroy;
begin
  ADFreeAndNil(FArguments);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADRunScriptCommand.Dump(): String;
var
  i: Integer;
begin
  if not FUseParentPath then
    Result := '<@> [' + FFileName + ']'
  else
    Result := '<@@> [' + FFileName + ']';
  for i := 0 to FArguments.Count - 1 do
    Result := Result + ' [' + FArguments[i] + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADRunScriptCommand.Help(): String;
begin
  Result := '(@ | @@ | START | INput) <script> <arguments> - starts execution of specified script';
end;

{-------------------------------------------------------------------------------}
class procedure TADRunScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('@');
  AKwds.Add('@@');
  AKwds.Add('START');
  AKwds.Add('INput');
end;

{-------------------------------------------------------------------------------}
function TADRunScriptCommand.Parse(const AKwd: String): Boolean;
var
  s: String;
begin
  if not Parser.WasBeginningOfLine then begin
    Result := False;
    Exit;
  end;
  FUseParentPath := True;
  if Parser.Ch = '@' then
    Parser.GetChar
  else
    FUseParentPath := False;
  FFileName := Parser.GetString();
  while True do begin
    s := Parser.GetString();
    if s = '' then
      Break;
    FArguments.Add(s);
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADRunScriptCommand.InternalExecute(ARealExecute: Boolean);
var
  oParser: TADScriptParser;
  oArgs: TADStringList;
  oText: TADTextFile;
  sFileName: String;
begin
  if (ExtractFilePath(FFileName) = '') and FUseParentPath then
    sFileName := ExtractFilePath(Parser.FileName) + FFileName
  else
    sFileName := FFileName;
  sFileName := EngineIntf.ExpandString(sFileName);
  oText := nil;
  oArgs := nil;
  EngineIntf.GetText(sFileName, smRead, oText);
  if oText <> nil then
    try
      oParser := TADScriptParser.Create(sFileName, Self, oText, Engine.ScriptOptions);
      try
        if Arguments.Count > 0 then begin
          oArgs := TADStringList.Create;
          oArgs.Assign(Engine.Arguments);
          Engine.Arguments.Assign(Arguments);
        end;
        oParser.TotalSize := Parser.TotalSize;
        if ARealExecute then
          EngineIntf.ExecuteAll(oParser)
        else
          EngineIntf.ValidateAll(oParser);
      finally
        if oArgs <> nil then begin
          Engine.Arguments.Assign(oArgs);
          ADFree(oArgs);
        end;
        Parser.TotalSize := oParser.TotalSize;
        ADFree(oParser);
      end;
    finally
      EngineIntf.ReleaseText(sFileName, smRead, oText);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADRunScriptCommand.Execute();
begin
  InternalExecute(True);
end;

{-------------------------------------------------------------------------------}
procedure TADRunScriptCommand.Validate();
begin
  InternalExecute(False);
end;

{-------------------------------------------------------------------------------}
{ TADAcceptScriptCommand                                                        }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADAcceptScriptCommand.Dump(): String;
begin
  Result := '<accept> [var="' + Variable + '", dt=' + FieldTypeNames[DataType];
  if Fmt <> '' then
    Result := Result + ', fmt="' + Fmt + '"';
  if Def <> '' then
    Result := Result + ', def="' + Def + '"';
  if Prompt <> '' then
    Result := Result + ', pr="' + Prompt + '"';
  if Hide then
    Result := Result + ', hide';
  Result := Result + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADAcceptScriptCommand.Help(): String;
begin
  Result := 'ACCept <var> (NUMber|CHAR|DATE) [FORmat <fmt>] [DEFault <def>]'#13#10 +
            '    [PROmpt ''<prompt>'' | NOPRompt] [HIDE] - asks user to enter a variable value';
end;

{-------------------------------------------------------------------------------}
class procedure TADAcceptScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('ACCept');
end;

{-------------------------------------------------------------------------------}
function TADAcceptScriptCommand.Parse(const AKwd: String): Boolean;
var
  ucS: String;
begin
  FVariable := Parser.GetIdentifier;
  if Variable = '' then
    ADException(Engine, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrAccMustSpecVar, []);
  FDataType := ftUnknown;
  while True do begin
    ucS := Parser.GetUCWord;
    if ucS = '' then
      Break;
    if ADKeywordMatch(ucS, 'NUMBER', 3) then
{$IFDEF AnyDAC_D6}
      FDataType := ftFmtBCD
{$ELSE}
      FDataType := ftFloat
{$ENDIF}
    else if ADKeywordMatch(ucS, 'CHAR', 4) then
      FDataType := ftString
    else if ADKeywordMatch(ucS, 'DATE', 4) then
      FDataType := ftDateTime
    else if ADKeywordMatch(ucS, 'FORMAT', 3) then
      FFmt := Parser.GetString
    else if ADKeywordMatch(ucS, 'DEFAULT', 3) then
      FDef := Parser.GetString
    else if ADKeywordMatch(ucS, 'PROMPT', 3) then
      FPrompt := Parser.GetString
    else if ADKeywordMatch(ucS, 'NOPROMPT', 4) then
      FPrompt := ''
    else if ADKeywordMatch(ucS, 'HIDE', 4) then
      FHide := True;
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADAcceptScriptCommand.Execute();
var
  oPar: TADParam;
  sVal: String;
{$IFDEF AnyDAC_D6}
  rBcd: TADBcd;
{$ENDIF}
{$IFDEF AnyDAC_D7}
  rFS: TFormatSettings;
{$ELSE}
  prevShortDateFmt: String;
{$ENDIF}
begin
  oPar := Engine.Params.ParamByName(EngineIntf.ExpandString(Variable));
  sVal := oPar.AsString;
  if sVal = '' then
    sVal := Def;
  EngineIntf.ConGet(EngineIntf.ExpandString(Prompt), sVal);
  sVal := EngineIntf.ExpandString(sVal);
  if DataType <> ftUnknown then begin
    oPar.Clear();
    oPar.DataType := DataType;
  end;
  case oPar.DataType of
{$IFDEF AnyDAC_D6}
  ftFmtBCD:
    begin
      ADStr2BCD(PChar(sVal), Length(sVal), rBcd, {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator);
      oPar.AsFmtBCD := rBcd;
    end;
{$ENDIF}
  ftFloat:
    oPar.AsFloat := ADStr2Float(sVal, {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator);
  ftString:
    oPar.AsString := sVal;
  ftDateTime:
    if Fmt = '' then
      oPar.AsDateTime := StrToDateTime(sVal)
    else begin
{$IFDEF AnyDAC_D15}
      rFS := TFormatSettings.Create;
      rFS.ShortDateFormat := EngineIntf.ExpandString(Fmt);
      oPar.AsDateTime := StrToDateTime(sVal, rFS);
{$ELSE}
  {$IFDEF AnyDAC_D7}
      GetLocaleFormatSettings(0, rFS);
      rFS.ShortDateFormat := EngineIntf.ExpandString(Fmt);
      oPar.AsDateTime := StrToDateTime(sVal, rFS);
  {$ELSE}
      prevShortDateFmt := ShortDateFormat;
      try
        ShortDateFormat := EngineIntf.ExpandString(Fmt);
        oPar.AsDateTime := StrToDateTime(sVal);
      finally
        ShortDateFormat := prevShortDateFmt;
      end;
  {$ENDIF}
{$ENDIF}
    end;
  else
    ASSERT(False);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADConnectScriptCommand                                                       }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADConnectScriptCommand.Dump: String;
begin
  Result := '<connect> [' + FConnectString + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADConnectScriptCommand.Help(): String;
begin
  Result := 'CONnect <FireDAC connection string> - connects to the specified DBMS';
end;

{-------------------------------------------------------------------------------}
class procedure TADConnectScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('CONnect');
end;

{-------------------------------------------------------------------------------}
function TADConnectScriptCommand.Parse(const AKwd: String): Boolean;
begin
  FConnectString := Parser.GetLine();
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADConnectScriptCommand.Execute();
var
  oMAIntf: IADMoniAdapter;
  sName: String;
  vValue: Variant;
  eKind: TADMoniAdapterItemKind;
  i: Integer;
begin
  EngineIntf.CloseConnection;
  try
    EngineIntf.OpenConnection(EngineIntf.ExpandString(ConnectString));
  except
    on E: Exception do
      EngineIntf.ConPut(E.Message, soError);
  end;
  if (EngineIntf.ConnectionIntf <> nil) and (EngineIntf.ConnectionIntf.State = csConnected) then begin
    EngineIntf.ConPut('Connected to', soConnect);
    EngineIntf.UpdateCommandSeparator;
    if Engine.ScriptOptions.FeedbackCommands then begin
      oMAIntf := EngineIntf.ConnectionIntf as IADMoniAdapter;
      for i := 0 to oMAIntf.ItemCount - 1 do begin
        oMAIntf.GetItem(i, sName, vValue, eKind);
        if eKind = ikSessionInfo then
          EngineIntf.ConPut(sName + ' = ' + VarToStr(vValue), soConnect);
      end;
    end;
  end
  else
    EngineIntf.ConPut('Not logged on', soConnect);
end;

{-------------------------------------------------------------------------------}
{ TADDefineScriptCommand                                                        }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADDefineScriptCommand.Dump: String;
begin
  Result := '<define> [';
  case FMode of
  -1: Result := Result + 'show all';
  0: Result := Result + 'show def="' + FName + '"';
  1: Result := Result + 'set def="' + FName + '", val="' + FSValue + '"';
  end;
  Result := Result + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADDefineScriptCommand.Help(): String;
begin
  Result := 'DEFine [<name> | <name>=<value>] - prints all, the specified or sets the specified macro value';
end;

{-------------------------------------------------------------------------------}
class procedure TADDefineScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('DEFine');
end;

{-------------------------------------------------------------------------------}
function TADDefineScriptCommand.Parse(const AKwd: String): Boolean;
begin
  FName := Parser.GetIdentifier();
  if FName = '' then
    FMode := -1
  else begin
    Parser.SkipWS;
    if Parser.Ch = '=' then begin
      FMode := 1;
      Parser.GetChar;
      FSValue := Parser.GetString();
      if FSValue = '' then
        ADException(Engine, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrDefReqValue, []);
    end
    else begin
      FMode := 0;
      Parser.UnGetChar;
    end;
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDefineScriptCommand.Execute();
var
  i: Integer;
  oMac: TADMacro;
begin
  case FMode of
  -1:
    for i := 0 to Engine.Macros.Count - 1 do
      EngineIntf.ConPut('DEFINE ' + Engine.Macros[i].Name + ' = ' + Engine.Macros[i].AsRaw, soMacro);
  0:
    begin
      oMac := Engine.Macros.FindMacro(EngineIntf.ExpandString(Name));
      if oMac = nil then
        EngineIntf.ConPut('Symbol ' + Name + ' is UNDEFINED', soMacro)
      else
        EngineIntf.ConPut('DEFINE ' + oMac.Name + ' = ' + oMac.AsRaw, soMacro);
    end;
  1:
    begin
      oMac := Engine.Macros.FindMacro(EngineIntf.ExpandString(Name));
      if oMac = nil then begin
        oMac := TADMacro(Engine.Macros.Add);
        oMac.Name := EngineIntf.ExpandString(Name);
      end;
      oMac.AsRaw := EngineIntf.ExpandString(Value);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADDisconnectScriptCommand                                                    }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADDisconnectScriptCommand.Dump: String;
begin
  Result := '<disconnect>';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADDisconnectScriptCommand.Help(): String;
begin
  Result := 'DISconnect - disconnects from the DBMS';
end;

{-------------------------------------------------------------------------------}
class procedure TADDisconnectScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('DISconnect');
end;

{-------------------------------------------------------------------------------}
procedure TADDisconnectScriptCommand.Execute();
begin
  EngineIntf.CloseConnection;
  EngineIntf.ConPut('Not logged on', soConnect);
end;

{-------------------------------------------------------------------------------}
{ TADExecuteScriptCommand                                                       }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADExecuteScriptCommand.Dump: String;
begin
  Result := '<execute> [' + FBlock + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADExecuteScriptCommand.Help(): String;
begin
  Result := '(EXECute | CALL) <procedure> - executes the specified stored procedure';
end;

{-------------------------------------------------------------------------------}
class procedure TADExecuteScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('EXECute');
  AKwds.Add('CALL');
end;

{-------------------------------------------------------------------------------}
function TADExecuteScriptCommand.Parse(const AKwd: String): Boolean;
begin
  // Ignore ADS EXECUTE PROCEDURE, FB EXECUTE BLOCK, PgSQL and MSSQL EXECUTE
  if ADKeywordMatch(AKwd, 'EXECUTE', 4) and
     (EngineIntf.RDBMSKind in [mkADS, mkInterbase, mkPostgreSQL, mkMSSQL]) then
    Result := False
  // Ignore Nexus, DB2 and MySQL CALL
  else if ADKeywordMatch(AKwd, 'CALL', 4) and
     (EngineIntf.RDBMSKind in [mkNexus, mkDB2, mkMySQL]) then
    Result := False
  else begin
    FBlock := Parser.GetLine();
    Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADExecuteScriptCommand.Execute();
var
  oGen: IADPhysCommandGenerator;
begin
  EngineIntf.CheckCommand;
  EngineIntf.ConnectionIntf.CreateCommandGenerator(oGen, nil);
  FSQL := oGen.GenerateCall(FBlock);
  inherited Execute();
end;

{-------------------------------------------------------------------------------}
{ TADExitScriptCommand                                                          }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADExitScriptCommand.Dump(): String;
begin
  case FAction of
  eaCommit:   Result := '<commit, exit>';
  eaRollback: Result := '<rollback, exit>';
  eaNone:     Result := '<exit>';
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADExitScriptCommand.Help(): String;
begin
  Result := 'EXIT - stops script execution and commit changes'#13#10 +
            'QUIT - stops script execution and rollback changes'#13#10 +
            'STOP - stops script execution';
end;

{-------------------------------------------------------------------------------}
class procedure TADExitScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('EXIT');
  AKwds.Add('QUIT');
  AKwds.Add('STOP');
end;

{-------------------------------------------------------------------------------}
function TADExitScriptCommand.Parse(const AKwd: String): Boolean;
begin
  if ADKeywordMatch(AKwd, 'EXIT', 4) then
    FAction := eaCommit
  else if ADKeywordMatch(AKwd, 'QUIT', 4) then
    FAction := eaRollback
  else
    FAction := eaNone;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADExitScriptCommand.Execute();
begin
  if EngineIntf.ConnectionIntf <> nil then
    case FAction of
    eaCommit:
      while EngineIntf.ConnectionIntf.Transaction.Active do
        EngineIntf.ConnectionIntf.Transaction.Commit;
    eaRollback:
      while EngineIntf.ConnectionIntf.Transaction.Active do
        EngineIntf.ConnectionIntf.Transaction.Rollback;
    end;
  Engine.Finished := True;
end;

{-------------------------------------------------------------------------------}
procedure TADExitScriptCommand.Validate;
begin
  Engine.Finished := True;
end;

{-------------------------------------------------------------------------------}
{ TADHostScriptCommand                                                          }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADHostScriptCommand.Dump(): String;
begin
  Result := '<host> [' + Command + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADHostScriptCommand.Help(): String;
begin
  Result := '(HOst | !! | SHELL) <command> - executes host command';
end;

{-------------------------------------------------------------------------------}
class procedure TADHostScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('HOst');
  AKwds.Add('SHELL');
  AKwds.Add('!!');
end;

{-------------------------------------------------------------------------------}
function TADHostScriptCommand.Parse(const AKwd: String): Boolean;
begin
  FCommand := Parser.GetLine();
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADHostScriptCommand.Execute();
begin
  EngineIntf.ExecuteHostCommand(EngineIntf.ExpandString(Command));
end;

{-------------------------------------------------------------------------------}
{ TADPauseScriptCommand                                                         }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADPauseScriptCommand.Dump(): String;
begin
  Result := '<pause> [' + Text + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADPauseScriptCommand.Help(): String;
begin
  Result := 'PAUse <prompt> - pauses script execution';
end;

{-------------------------------------------------------------------------------}
class procedure TADPauseScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('PAUse');
end;

{-------------------------------------------------------------------------------}
function TADPauseScriptCommand.Parse(const AKwd: String): Boolean;
begin
  FText := Parser.GetLine();
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADPauseScriptCommand.Execute();
begin
  EngineIntf.ConPause(EngineIntf.ExpandString(Text));
end;

{-------------------------------------------------------------------------------}
{ TADPromptScriptCommand                                                        }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADPromptScriptCommand.Dump(): String;
begin
  Result := '<prompt> [' + Text + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADPromptScriptCommand.Help(): String;
begin
  Result := 'PROmpt <prompt> - prints specified text';
end;

{-------------------------------------------------------------------------------}
class procedure TADPromptScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('PROmpt');
end;

{-------------------------------------------------------------------------------}
function TADPromptScriptCommand.Parse(const AKwd: String): Boolean;
begin
  FText := Parser.GetLine();
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADPromptScriptCommand.Execute();
begin
  EngineIntf.ConPut(EngineIntf.ExpandString(Text), soUserOutput);
end;

{-------------------------------------------------------------------------------}
{ TADPrintScriptCommand                                                         }
{-------------------------------------------------------------------------------}
constructor TADPrintScriptCommand.Create(AParser: TADScriptParser;
  AEngine: TADScript);
begin
  inherited Create(AParser, AEngine);
  FVars := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPrintScriptCommand.Destroy;
begin
  ADFree(FVars);
  FVars := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADPrintScriptCommand.Dump(): String;
var
  i: Integer;
begin
  Result := '<print> [';
  for i := 0 to Vars.Count - 1 do begin
    if i > 0 then
      Result := Result + ', ';
    Result := Result + IntToStr(i) + '="' + Vars[i] + '"';
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADPrintScriptCommand.Help(): String;
begin
  Result := 'PRInt <var 1> [..., <varN>] - prints value of the specified variables';
end;

{-------------------------------------------------------------------------------}
class procedure TADPrintScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('PRInt');
end;

{-------------------------------------------------------------------------------}
function TADPrintScriptCommand.Parse(const AKwd: String): Boolean;
var
  s, sVar: String;
  i: Integer;
begin
  if (EngineIntf.RDBMSKind = mkMSSQL) and (UpperCase(AKwd) = 'PRINT') then
    Result := False
  else begin
    s := Parser.GetLine();
    i := 1;
    while i <= Length(s) do begin
      sVar := Trim(ADStrToken(s, ', '#9, i));
      if sVar <> '' then
        Vars.Add(sVar);
    end;
    Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPrintScriptCommand.Execute();
var
  i, j, iWidth: Integer;
  oPar: TADParam;
  lAlignRight: Boolean;

  function PadStr(const AStr: String; AWidth: Integer; ARight: Boolean): String;
  begin
    if ARight then
      Result := Copy(StringOfChar(' ', AWidth - Length(AStr)) + AStr, 1, AWidth)
    else
      Result := Copy(AStr + StringOfChar(' ', AWidth - Length(AStr)), 1, AWidth);
  end;

begin
  for i := 0 to Vars.Count - 1 do
    try
      oPar := Engine.Params.ParamByName(EngineIntf.ExpandString(Vars[i]));
      iWidth := 20;
      lAlignRight := False;
      case oPar.DataType of
{$IFDEF AnyDAC_D6}
      ftFmtBCD,
{$ENDIF}
      ftBCD,
      ftCurrency,
      ftFloat,
      ftInteger,
      ftSmallint,
      ftWord,
      ftAutoInc,
      ftLargeint:
        begin
          if oPar.Precision > 0 then
            iWidth := oPar.Precision;
          lAlignRight := True;
        end;
      ftWideString,
      ftString:
        if oPar.Size > 0 then
          iWidth := oPar.Size;
      end;
      EngineIntf.ConPut(PadStr(oPar.Name, iWidth, lAlignRight), soParam);
      EngineIntf.ConPut(StringOfChar('-', iWidth), soParam);
      EngineIntf.ConPut(PadStr(oPar.AsString, iWidth, lAlignRight), soParam);
      if oPar.ArraySize > 1 then
        for j := 1 to oPar.ArraySize - 1 do
          EngineIntf.ConPut(Format('  [%d]: %s', [j, PadStr(oPar.AsStrings[j], iWidth, lAlignRight)]), soParam);
      EngineIntf.ConPut('', soSeparator);
    except
      on E: Exception do
        EngineIntf.ConPut(E.Message, soError);
    end;
end;

{-------------------------------------------------------------------------------}
{ TADSetScriptCommand                                                           }
{-------------------------------------------------------------------------------}
constructor TADSetScriptCommand.Create(AParser: TADScriptParser;
  AEngine: TADScript);
begin
  inherited Create(AParser, AEngine);
end;

{-------------------------------------------------------------------------------}
destructor TADSetScriptCommand.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FItems) - 1 do
    FItems[i].Free;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADSetScriptCommand.AddItem(ASetKind: TADSetScriptCommandKind;
  AIValue: Integer; ASValue: String; AEchoCommands: TADScriptEchoCommands): TADSetScriptCommandItem;
begin
  SetLength(FItems, Length(FItems) + 1);
  Result := TADSetScriptCommandItem.Create;
  FItems[Length(FItems) - 1] := Result;
  Result.FSetKind := ASetKind;
  Result.FIValue := AIValue;
  Result.FSValue := ASValue;
  Result.FEchoCommands := AEchoCommands;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADSetScriptCommand.Dump(): String;
var
  s: String;
  i: Integer;
  oItem: TADSetScriptCommandItem;
begin
  Result := '<set> [';
  s := '';
  for i := 0 to Length(FItems) - 1 do begin
    if i > 0 then
      s := s + ', ';
    oItem := FItems[i];
    case oItem.FSetKind of
    skNone:           ;
    skArraySize:      s := s + 'arraysize=' + IntToStr(oItem.FIValue);
    skAutoCommit:     s := s + 'autocommit=' + IntToStr(oItem.FIValue);
    skAutoPrint:      s := s + 'autoprint=' + IntToStr(oItem.FIValue);
    skCharacterSet:   s := s + 'characterset=' + oItem.FSValue;
    skClientLib:      s := s + 'clientlib=' + oItem.FSValue;
    skCmdSep:         s := s + 'cmdsep=' + oItem.FSValue;
    skDefine:         s := s + 'define=' + IntToStr(oItem.FIValue);
    skEcho:           s := s + 'echo=' + IntToStr(oItem.FIValue);
    skEncoding:       s := s + 'encoding=' + IntToStr(oItem.FIValue);
    skFeedback:       s := s + 'feedback=' + IntToStr(oItem.FIValue);
    skHeading:        s := s + 'heading=' + IntToStr(oItem.FIValue);
    skLineSize:       s := s + 'linesize=' + IntToStr(oItem.FIValue);
    skLong:           s := s + 'long=' + IntToStr(oItem.FIValue);
    skParamArraySize: s := s + 'paramarraysize=' + IntToStr(oItem.FIValue);
    skPageSize:       s := s + 'pagesize=' + IntToStr(oItem.FIValue);
    skScan:           s := s + 'scan=' + IntToStr(oItem.FIValue);
    skServerOutput:   s := s + 'serveroutput=' + IntToStr(oItem.FIValue);
    skSQLDialect:     s := s + 'sqldialect=' + IntToStr(oItem.FIValue);
    skTermout:        s := s + 'termout=' + IntToStr(oItem.FIValue);
    skTiming:         s := s + 'timing=' + IntToStr(oItem.FIValue);
    skBreakOnError:   s := s + 'breakonerror=' + IntToStr(oItem.FIValue);
    skIgnoreError:    s := s + 'ignoreerror=' + IntToStr(oItem.FIValue);
    skTrimConsole:    s := s + 'trimconsole=' + IntToStr(oItem.FIValue);
    skTrimSpool:      s := s + 'trimspool=' + IntToStr(oItem.FIValue);
    skVerify:         s := s + 'verify=' + IntToStr(oItem.FIValue);
    end;
  end;
  Result := Result + s + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADSetScriptCommand.Help(): String;
// show
begin
  Result := 'SET - sets script execution mode'#13#10 +
            '    ARRAY <value> - specifies the rowset size'#13#10 +
            '    AUTOcommit OFF|ON|<value> - set auto commit off, on or to commit each N commands'#13#10+
            '    AUTOPrint OFF|ON - show variable values after command execution'#13#10 +
            '    BREAK OFF|ON - stop script execution on error'#13#10 +
            '    (CHARACTERset | NAMES) <value> - specifies client character set'#13#10 +
            '    CLIENTlib <value> - specifies driver CLI library'#13#10 +
            '    (CMDSeparator | TERMinator) <value> - specifies commands separator. TERM is for IB/FB only'#13#10 +
            '    (DEFine | SCAN) OFF|ON - controls macros expansion'#13#10 +
            '    DROPnonexistent ON|OFF - allow to drop non existent objects'#13#10 +
            '    ECHO OFF|(ON [SQL|ALL] [TRIM 50|<value>]) - shows command text before it execution with optional trimming'#13#10 +
            '    ENCoding ANSI | UTF8 | UTF16 - sets text file encoding'#13#10 +
            '    (FEEDback|COUNT) 6|<value>|OFF|ON - show feedback after command execution'#13#10 +
            '    HEAding OFF|ON - show column names for dataset'#13#10 +
            '    LINESize 0|<value> - set line width'#13#10 +
            '    (WIDTH|LONG) 80|<value> - show specified amount of characters for character or binary values'#13#10 +
            '    PAGESize 24|<value> - set the page size when printing dataset'#13#10 +
            '    PARAMARRAY 1|<value> - specifies the size of parameters array'#13#10 +
            '    SERVEROUTPUT OFF|(ON [SIZE <value>]) - show server output after command execution'#13#10 +
            '    SQL DIALECT <value> - specifies the SQL dialect. For IB/FB connection only'#13#10 +
            '    (TERMout|CONsole) OFF|ON - output command execution result to console'#13#10 +
            '    TIMing OFF|ON - show command executin time'#13#10 +
            '    TRIMout OFF|ON - trim spaces from strings at console output'#13#10 +
            '    TRIMSpool ON|OFF - trim spaces from strings at spool output'#13#10 +
            '    VERify OFF|ON - show SQL command before execution with substituted macros';
end;

{-------------------------------------------------------------------------------}
class procedure TADSetScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('SET');
end;

{-------------------------------------------------------------------------------}
function TADSetScriptCommand.Parse(const AKwd: String): Boolean;
var
  ucS, s: String;
  iLastBmk: Integer;
  oItem: TADSetScriptCommandItem;
  lEQREquired: Boolean;
begin
  while True do begin
    ucS := Parser.GetUCWord;
    if ucS = '' then
      Break;

    Parser.SkipWS;
    iLastBmk := Parser.GetBookmark;
    lEQREquired := False;
    if Parser.Ch = ':' then begin
      Parser.GetChar;
      lEQREquired := True;
    end;
    if Parser.Ch = '=' then
      Parser.GetChar
    else if lEQREquired then
      Parser.SetBookmark(iLastBmk);

    if ADKeywordMatch(ucS, 'ARRAY', 5) then
      // n
      AddItem(skArraySize, Parser.GetNumber(15))
    else if ADKeywordMatch(ucS, 'AUTOCOMMIT', 4) then
      // OFF(-1) | ON(1) | n
      AddItem(skAutoCommit, Parser.GetNumber(1))
    else if ADKeywordMatch(ucS, 'AUTOPRINT', 5) then
      // OFF(-1) | ON(1)
      AddItem(skAutoPrint, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'CHARACTERSET', 9) or ADKeywordMatch(ucS, 'NAMES', 5) then
      // charset
      AddItem(skCharacterSet, 0, Parser.GetString(True))
    else if ADKeywordMatch(ucS, 'CLIENTLIB', 6) then
      // clientlib
      AddItem(skClientLib, 0, Parser.GetString(True))
    else if ADKeywordMatch(ucS, 'CMDSEPARATOR', 4) or
            ADKeywordMatch(ucS, 'TERMINATOR', 4) and (EngineIntf.RDBMSKind = mkInterbase) then begin
      // ';' | c | OFF(-1) | ON(ord(';'))
      s := Parser.GetString(True);
      if UpperCase(s) = 'OFF' then
        s := #255
      else if UpperCase(s) = 'ON' then
        s := ''
      else if s = '' then
        s := Parser.ScriptOptions.CommandSeparator;
      AddItem(skCmdSep, 0, s)
    end
    else if ADKeywordMatch(ucS, 'DEFINE', 3) or ADKeywordMatch(ucS, 'SCAN', 4) then
      // SQL*Plus: '&' | c | OFF(-1) | ON(ord('&'))
      // FireDAC: OFF(-1) | ON(1)
      AddItem(skDefine, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'DROPNONEXISTENT', 4) then
      // OFF(-1) | ON(1)
      AddItem(skDropNonexistObj, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'ECHO', 4) then begin
      // OFF(-1) | ON(1) [SQL|ALL] [TRIM <size>]
      oItem := AddItem(skEcho, Parser.GetOnOff);
      if oItem.FIValue = 1 then begin
        oItem.FEchoCommands := ecAll;
        oItem.FIValue := 50;
        while True do begin
          iLastBmk := Parser.GetBookmark;
          ucS := Parser.GetUCWord;
          if ucS = 'SQL' then
            oItem.FEchoCommands := ecSQL
          else if ucS = 'ALL' then
            oItem.FEchoCommands := ecAll
          else if ucS = 'TRIM' then
            oItem.FIValue := Parser.GetNumber
          else begin
            Parser.SetBookmark(iLastBmk);
            Break;
          end;
        end;
      end
      else
        oItem.FEchoCommands := ecNone;
    end
    else if ADKeywordMatch(ucS, 'ENCODING', 3) then begin
      oItem := AddItem(skEncoding);
      ucS := Parser.GetUCWord;
      if ADKeyWordMatch(ucS, 'UTF8', 4) then
        oItem.FIValue := Integer(ecUTF8)
      else if ADKeyWordMatch(ucS, 'UTF16', 5) then
        oItem.FIValue := Integer(ecUTF16)
      else
        oItem.FIValue := Integer(ecANSI);
    end
    else if ADKeywordMatch(ucS, 'FEEDBACK', 4) or ADKeywordMatch(ucS, 'COUNT', 5) then
      // 6 | n | OFF(-1) | ON(6)
      AddItem(skFeedback, Parser.GetNumber(6))
    else if ADKeywordMatch(ucS, 'HEADING', 3) then
      // OFF(-1) | ON(1)
      AddItem(skHeading, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'LINESIZE', 5) then
      // 0 | n
      AddItem(skLineSize, Parser.GetNumber(0))
    else if ADKeywordMatch(ucS, 'LONG', 4) or ADKeywordMatch(ucS, 'WIDTH', 5) then
      // 80 | n
      AddItem(skLong, Parser.GetNumber(80))
    else if ADKeywordMatch(ucS, 'PARAMARRAY', 10) then
      // n
      AddItem(skParamArraySize, Parser.GetNumber(1))
    else if ADKeywordMatch(ucS, 'PAGESIZE', 5) then
      // n
      AddItem(skPageSize, Parser.GetNumber(24))
    else if ADKeywordMatch(ucS, 'SERVEROUTPUT', 9) then begin
      // [OFF | ON] [SIZE n]
      oItem := AddItem(skServerOutput, Parser.GetOnOff);
      iLastBmk := Parser.GetBookmark;
      ucS := Parser.GetUCWord;
      if ADKeywordMatch(ucS, 'SIZE', 4) then
        oItem.FIValue := Parser.GetNumber
      else begin
        oItem.FIValue := 1024;
        Parser.SetBookmark(iLastBmk);
      end;
    end
    else if ADKeywordMatch(ucS, 'SQL', 3) then begin
      // DIALECT n
      oItem := AddItem(skSQLDialect);
      iLastBmk := Parser.GetBookmark;
      ucS := Parser.GetUCWord;
      if ucS = 'DIALECT' then
        oItem.FIValue := Parser.GetNumber(3)
      else begin
        oItem.FIValue := 3;
        Parser.SetBookmark(iLastBmk);
      end;
    end
    else if ADKeywordMatch(ucS, 'TERMOUT', 4) or ADKeywordMatch(ucS, 'CONSOLE', 3) then
      // OFF(-1) | ON(1)
      AddItem(skTermout, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'TIMING', 3) then
      // OFF(-1) | ON(1)
      AddItem(skTiming, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'BREAK', 5) then
      // OFF(-1) | ON(1)
      AddItem(skBreakOnError, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'IGNORE', 6) then
      // OFF(-1) | ON(1)
      AddItem(skIgnoreError, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'TRIMOUT', 4) then
      // OFF(-1) | ON(1)
      AddItem(skTrimConsole, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'TRIMSPOOL', 5) then
      // OFF(-1) | ON(1)
      AddItem(skTrimSpool, Parser.GetOnOff)
    else if ADKeywordMatch(ucS, 'VERIFY', 3) then
      // OFF(-1) | ON(1)
      AddItem(skVerify, Parser.GetOnOff)

    // ********************************************************
    // ******** just ignore next SET's ************************
    else if ADKeywordMatch(ucS, 'NUMWIDTH', 3) then
      // n
      Parser.GetNumber
    else if ADKeywordMatch(ucS, 'TAB', 3) then
      // OFF(-1) | ON(1)
      Parser.GetOnOff;

  end;
  Result := Length(FItems) > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADSetScriptCommand.Execute();
var
  i: Integer;
  oItem: TADSetScriptCommandItem;
  oRes: TADTopResourceOptions;
begin
  for i := 0 to Length(FItems) - 1 do begin
    oItem := FItems[i];
    case oItem.FSetKind of
    skArraySize:
      begin
        EngineIntf.CheckCommand;
        EngineIntf.CommandIntf.Options.FetchOptions.RowsetSize := oItem.FIValue;
      end;
    skAutoCommit:
      begin
        if EngineIntf.ConnectionIntf = nil then
          Engine.Connection.TxOptions.AutoCommit := (oItem.FIValue >= 1)
        else begin
          EngineIntf.CheckCommand;
          EngineIntf.CheckCommit(True);
          EngineIntf.ConnectionIntf.Transaction.Options.AutoCommit := (oItem.FIValue >= 1);
        end;
        if oItem.FIValue > 1 then
          Engine.ScriptOptions.CommitEachNCommands := oItem.FIValue
        else
          Engine.ScriptOptions.CommitEachNCommands := 0;
        Engine.ProcessedAfterCommit := 0;
      end;
    skAutoPrint:
      Engine.ScriptOptions.AutoPrintParams := (oItem.FIValue = 1);
    skCharacterSet:
      Engine.ScriptOptions.CharacterSet := oItem.FSValue;
    skClientLib:
      Engine.ScriptOptions.ClientLib := oItem.FSValue;
    skCmdSep:
      begin
        Parser.ScriptOptions.CommandSeparator := oItem.FSValue;
        EngineIntf.UpdateCommandSeparator;
      end;
    skDropNonexistObj:
      Engine.ScriptOptions.DropNonexistObj := (oItem.FIValue = 1);
    skEcho:
      begin
        Engine.ScriptOptions.EchoCommandTrim := 0;
        Engine.ScriptOptions.EchoCommands := oItem.FEchoCommands;
        if oItem.FEchoCommands <> ecNone then
          Engine.ScriptOptions.EchoCommandTrim := oItem.FIValue;
      end;
    skEncoding:
      Engine.ScriptOptions.FileEncoding := TADEncoding(oItem.FIValue);
    skFeedback:
      Engine.ScriptOptions.FeedbackCommands := (oItem.FIValue > 0);
    skHeading:
      Engine.ScriptOptions.ColumnHeadings := (oItem.FIValue > 0);
    skLineSize:
      Engine.ScriptOptions.LineSize := oItem.FIValue;
    skLong:
      Engine.ScriptOptions.MaxStringWidth := oItem.FIValue;
    skParamArraySize:
      begin
        Engine.ScriptOptions.ParamArraySize := oItem.FIValue;
        Engine.Params.ArraySize := oItem.FIValue;
      end;
    skPageSize:
      Engine.ScriptOptions.PageSize := oItem.FIValue;
    skDefine,
    skScan:
      Engine.ScriptOptions.MacroExpand := (oItem.FIValue > 0);
    skServerOutput:
      begin
        EngineIntf.CheckCommand;
        oRes := EngineIntf.ConnectionIntf.Options.ResourceOptions as TADTopResourceOptions;
        if oItem.FIValue > 1 then
          oRes.ServerOutputSize := oItem.FIValue;
        oRes.ServerOutput := (oItem.FIValue > 0);
      end;
    skSQLDialect:
      Engine.ScriptOptions.SQLDialect := oItem.FIValue;
    skTermout:
      Engine.ScriptOptions.ConsoleOutput := (oItem.FIValue > 0);
    skTiming:
      Engine.ScriptOptions.Timing := (oItem.FIValue > 0);
    skBreakOnError:
      Engine.ScriptOptions.BreakOnError := (oItem.FIValue > 0);
    skIgnoreError:
      Engine.ScriptOptions.IgnoreError := (oItem.FIValue > 0);
    skTrimConsole:
      Engine.ScriptOptions.TrimConsole := (oItem.FIValue > 0);
    skTrimSpool:
      Engine.ScriptOptions.TrimSpool := (oItem.FIValue > 0);
    skVerify:
      Engine.ScriptOptions.Verify := (oItem.FIValue > 0);
    else
      ASSERT(False);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSetScriptCommand.Validate();
var
  i: Integer;
  oItem: TADSetScriptCommandItem;
begin
  for i := 0 to Length(FItems) - 1 do begin
    oItem := FItems[i];
    case oItem.FSetKind of
    skCmdSep:
      begin
        Parser.ScriptOptions.CommandSeparator := oItem.FSValue;
        EngineIntf.UpdateCommandSeparator;
      end;
    skEncoding:
      Engine.ScriptOptions.FileEncoding := TADEncoding(oItem.FIValue);
    skBreakOnError:
      Engine.ScriptOptions.BreakOnError := (oItem.FIValue > 0);
    skIgnoreError:
      Engine.ScriptOptions.IgnoreError := (oItem.FIValue > 0);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADSpoolScriptCommand                                                         }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADSpoolScriptCommand.Dump: String;
begin
  Result := '<spool> [';
  case FMode of
  -1: Result := Result + 'off';
   0: Result := Result + 'show';
   1:
    begin
      Result := Result + 'on fl="' + FileName + '"';
      if Append then
        Result := Result + ', append';
    end;
  end;
  Result := Result + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADSpoolScriptCommand.Help(): String;
begin
  Result := '(SPOol | OUTput) [OFF|[APPend] <spool name>] - turns spooling off, print it status'#13#10 +
            '                                               or redirect it to the name';
end;

{-------------------------------------------------------------------------------}
class procedure TADSpoolScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('SPOol');
  AKwds.Add('OUTput');
end;

{-------------------------------------------------------------------------------}
function TADSpoolScriptCommand.Parse(const AKwd: String): Boolean;
var
  iLastBmk: Integer;
  ucS: string;
begin
  iLastBmk := Parser.GetBookmark;
  ucS := Parser.GetUCWord;
  if ucS = 'OFF' then
    FMode := -1
  else if ucS = '' then
    FMode := 0
  else begin
    FMode := 1;
    FAppend := ADKeyWordMatch(ucS, 'APPEND', 3);
    if not FAppend then
      Parser.SetBookmark(iLastBmk);
    FFileName := Parser.GetLine();
    if FFileName = '' then
      FMode := -1;
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADSpoolScriptCommand.Execute();
begin
  case FMode of
  -1:
    begin
      Engine.ScriptOptions.SpoolOutput := smNone;
      EngineIntf.UpdateSpool;
    end;
   0:
    if Engine.ScriptOptions.SpoolOutput <> smNone then
      EngineIntf.ConPut('currently spooling to ' + Engine.ScriptOptions.SpoolFileName, soInfo)
    else
      EngineIntf.ConPut('not spooling currently', soInfo);
   1:
    begin
      if FAppend then
        Engine.ScriptOptions.SpoolOutput := smOnAppend
      else
        Engine.ScriptOptions.SpoolOutput := smOnReset;
      Engine.ScriptOptions.SpoolFileName := EngineIntf.ExpandString(FileName);
      EngineIntf.UpdateSpool;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADUndefineScriptCommand                                                      }
{-------------------------------------------------------------------------------}
constructor TADUndefineScriptCommand.Create(AParser: TADScriptParser;
  AEngine: TADScript);
begin
  inherited Create(AParser, AEngine);
  FVars := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADUndefineScriptCommand.Destroy;
begin
  ADFree(FVars);
  FVars := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADUndefineScriptCommand.Dump(): String;
var
  i: Integer;
begin
  Result := '<undefine> [';
  for i := 0 to FVars.Count - 1 do begin
    if i > 0 then
      Result := Result + ', ';
    Result := Result + IntToStr(i) + '="' + FVars[i] + '"';
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADUndefineScriptCommand.Help(): String;
begin
  Result := 'UNDEFine <var1> [..., <varN>] - undefines specified macros';
end;

{-------------------------------------------------------------------------------}
class procedure TADUndefineScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('UNDEFine');
end;

{-------------------------------------------------------------------------------}
function TADUndefineScriptCommand.Parse(const AKwd: String): Boolean;
var
  s, sVar: String;
  i: Integer;
begin
  s := Parser.GetLine();
  i := 1;
  while i <= Length(s) do begin
    sVar := Trim(ADStrToken(s, ', '#9, i));
    if sVar <> '' then
      Vars.Add(sVar);
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADUndefineScriptCommand.Execute();
var
  i: Integer;
  oMac: TADMacro;
begin
  for i := 0 to Vars.Count - 1 do begin
    oMac := Engine.Macros.FindMacro(EngineIntf.ExpandString(Vars[i]));
    if oMac <> nil then
      ADFree(oMac);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADVariableScriptCommand                                                      }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADVariableScriptCommand.Dump(): String;
begin
  Result := '<variable> [';
  case FMode of
  -1: Result := Result + 'show all';
  0: Result := Result + 'show var="' + Variable + '"';
  1: Result := Result + 'set var="' + Variable + '", dt=' + FieldTypeNames[DataType] +
      ', sz=' + IntToStr(Size) + ', tabsz=' + IntToStr(TableSize) + ', partp=' +
      InttoStr(Integer(ParamType)) + ', val=' + FValue;
  end;
  Result := Result + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADVariableScriptCommand.Help(): String;
begin
  Result := 'VARiable [<name> (NUMber|CHAR|NCHAR) [(<size>)]] [TABle <size>]'#13#10 +
            '    [IN|OUT|INOUT] [=<value>] - prints all variables or defines variable';
end;

{-------------------------------------------------------------------------------}
class procedure TADVariableScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('VARiable');
end;

{-------------------------------------------------------------------------------}
function TADVariableScriptCommand.Parse(const AKwd: String): Boolean;
var
  ucS: String;
begin
  FVariable := Parser.GetIdentifier();
  if FVariable = '' then
    // print all
    FMode := -1
  else begin
    ucS := Parser.GetUCWord;
    if ucS = '' then begin
      // print var
      FMode := 0;
      Parser.UnGetChar;
    end
    else begin
      // declare var
      FMode := 1;
      while ucS <> '' do begin
        if ADKeyWordMatch(ucS, 'NUMBER', 3) then
{$IFDEF AnyDAC_D6}
          FDataType := ftFmtBCD
{$ELSE}
          FDataType := ftFloat
{$ENDIF}
        else if ADKeyWordMatch(ucS, 'CHAR', 4) or ADKeyWordMatch(ucS, 'NCHAR', 5) or
                ADKeyWordMatch(ucS, 'VARCHAR2', 7) or ADKeyWordMatch(ucS, 'NVARCHAR2', 8) then begin
          if ucS[1] = 'N' then
            FDataType := ftWideString
          else
            FDataType := ftString;
          FSize := -1;
          Parser.SkipWS;
          if Parser.Ch = '(' then begin
            Parser.GetChar;
            FSize := Parser.GetNumber;
            Parser.SkipWS;
            if Parser.Ch <> ')' then
              ADException(Engine, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrVarMissedCloseBrace, []);
            Parser.GetChar;
          end;
        end
        else if ADKeyWordMatch(ucS, 'TABLE', 3) then
          FTableSize := Parser.GetNumber
        else if ADKeyWordMatch(ucS, 'INPUT', 2) then
          FParamType := ptInput
        else if ADKeyWordMatch(ucS, 'OUTPUT', 3) then
          FParamType := ptOutput
        else if ADKeyWordMatch(ucS, 'INOUT', 3) then
          FParamType := ptInputOutput
        else
          ADException(Engine, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrVarUnsupType, []);
        ucS := Parser.GetUCWord;
      end;
      if Parser.Ch = '=' then
        FValue := Parser.GetString();
    end;
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADVariableScriptCommand.Execute();
var
  i: Integer;
  sVar: String;
  oPar: TADParam;

  procedure PrintPar(APar: TADParam);
  var
    s: String;
  begin
    EngineIntf.ConPut('variable     ' + APar.Name, soParam);
    case APar.DataType of
{$IFDEF AnyDAC_D6}
      ftFmtBCD,
{$ENDIF}
      ftFloat:      s := 'NUMBER';
      ftString:     s := 'CHAR(' + IntToStr(APar.Size) + ')';
      ftWideString: s := 'NCHAR(' + IntToStr(APar.Size) + ')';
      else          s := FieldTypeNames[APar.DataType];
    end;
    EngineIntf.ConPut('datatype     ' + s, soParam);
    if APar.ParamType <> ptUnknown then begin
      case APar.ParamType of
        ptInput:       s := 'INPUT';
        ptOutput:      s := 'OUTPUT';
        ptInputOutput: s := 'INOUT';
      end;
      EngineIntf.ConPut('direction    ' + s, soParam);
    end;
    if APar.ArraySize <> 1 then
      EngineIntf.ConPut('array size' + IntToStr(APar.ArraySize), soParam);
  end;

begin
  case FMode of
  -1:
    for i := 0 to Engine.Params.Count - 1 do begin
      if i > 0 then
        EngineIntf.ConPut('', soSeparator);
      PrintPar(Engine.Params[i]);
    end;
   0:
    PrintPar(Engine.Params.ParamByName(EngineIntf.ExpandString(Variable)));
   1:
    begin
      sVar := EngineIntf.ExpandString(Self.Variable);
      oPar := Engine.Params.FindParam(sVar);
      if oPar = nil then begin
        oPar := Engine.Params.Add;
        oPar.Name := sVar;
      end;
      if (oPar.DataType = ftUnknown) or (DataType <> ftUnknown) then
        oPar.DataType := DataType;
      if (ParamType = ptUnknown) and (EngineIntf.RDBMSKind = mkOracle) then
        FParamType := ptInputOutput;
      if (oPar.ParamType = ptUnknown) or (ParamType <> ptUnknown) then
        oPar.ParamType := ParamType;
      if (oPar.Size = 0) or (Size <> 0) then
        oPar.Size := Size;
      if TableSize <> 0 then begin
        oPar.ArrayType := atPLSQLTable;
        oPar.ArraySize := TableSize;
      end
      else
        oPar.ArraySize := Engine.ScriptOptions.ParamArraySize;
      if FValue <> '' then
        if CompareText(FValue, 'null') = 0 then
          oPar.Clear()
        else
          oPar.Value := FValue;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADHelpScriptCommand                                                          }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADHelpScriptCommand.Dump(): String;
begin
  Result := '<help>';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADHelpScriptCommand.Help(): String;
begin
  Result := 'HELP - shows help for all registered commands';
end;

{-------------------------------------------------------------------------------}
class procedure TADHelpScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('HELP');
  AKwds.Add('?');
end;

{-------------------------------------------------------------------------------}
procedure TADHelpScriptCommand.Execute();
var
  i: Integer;
  oReg: TADScriptCommandRegistry;
begin
  oReg := ADScriptCommandRegistry();
  for i := 0 to oReg.Count - 1 do
    EngineIntf.ConPut(oReg.Commands[i].Help(), soInfo);
end;

{-------------------------------------------------------------------------------}
{ TADRemarkScriptCommand                                                        }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADRemarkScriptCommand.Dump(): String;
begin
  Result := '<remark> [' + FText + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADRemarkScriptCommand.Help(): String;
begin
  Result := 'REMark <text> - adds comment to the script';
end;

{-------------------------------------------------------------------------------}
class procedure TADRemarkScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('REMark');
end;

{-------------------------------------------------------------------------------}
function TADRemarkScriptCommand.Parse(const AKwd: String): Boolean;
begin
  FText := Parser.GetLine;
  Result := True;
end;

{-------------------------------------------------------------------------------}
{ TADCopyScriptCommand                                                          }
{-------------------------------------------------------------------------------}
constructor TADCopyScriptCommand.Create(AParser: TADScriptParser; AEngine: TADScript);
var
  oDef: TADTextDataDef;
begin
  inherited Create(AParser, AEngine);
  FDataMove := TADDataMove.Create(nil);
  FSrcQuery := TADQuery.Create(nil);
  FSrcConnection := TADConnection.Create(nil);
  FDestQuery := TADQuery.Create(nil);
  FDestConnection := TADConnection.Create(nil);
  oDef := FDataMove.TextDataDef;
  oDef.WithFieldNames := True;
  oDef.FormatSettings.DecimalSeparator := '.';
  oDef.FormatSettings.DateSeparator := '-';
  oDef.FormatSettings.TimeSeparator := ':';
  oDef.FormatSettings.ShortDateFormat := 'yyyy/mm/dd';
  oDef.FormatSettings.ShortTimeFormat := 'hh:mm:ss';
  FDataMove.Options := [poOptimiseSrc, poOptimiseDest, poIdentityInsert];
end;

{-------------------------------------------------------------------------------}
destructor TADCopyScriptCommand.Destroy;
begin
  ADFreeAndNil(FDataMove);
  ADFreeAndNil(FSrcQuery);
  ADFreeAndNil(FSrcConnection);
  ADFreeAndNil(FDestQuery);
  ADFreeAndNil(FDestConnection);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADCopyScriptCommand.Dump: String;
begin
  Result := '';
  { TODO -cSCRIPT : Copy command dumping to be implemented  }
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADCopyScriptCommand.Help: String;
begin
  Result := 'COPY FROM (FILE ''<file>'' | SQL ''<sql>'' [CONnect ''<connection>''])'#13#10 +
            '     TO   (FILE ''<file>'' | TABle ''<table name>'' [CONnect ''<connection>''])'#13#10 +
            '     [TRUNCate | CLEar | ALWAYSinsert | APPend | UPDate | APPENDUPDate | DELete]'#13#10 +
            '     [LOG  (OFF | (SPOol|OUTput) | ([APPend] <log file name>)]'#13#10 +
            '     [USING FILE ''config file'' | PARAMS ''<definition>''] - move data between databases or text files';
end;

{-------------------------------------------------------------------------------}
class procedure TADCopyScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('COPY');
end;

{-------------------------------------------------------------------------------}
function TADCopyScriptCommand.Parse(const AKwd: String): Boolean;
var
  iPrevBmk, iPrevBmk2: Integer;
  ucS: String;
begin
  // Source
  ucS := Parser.GetUCWord;
  if ucS <> 'FROM' then
    Parser.InvalidSyntax;
  ucS := Parser.GetUCWord;
  if ucS = 'FILE' then begin
    FDataMove.SourceKind := skText;
    FDataMove.TextFileName := Parser.GetString();
  end
  else if ucS = 'SQL' then begin
    FDataMove.SourceKind := skDataSet;
    FDataMove.Source := FSrcQuery;
    FSrcQuery.SQL.Text := Parser.GetString();
    iPrevBmk := Parser.GetBookmark;
    ucS := Parser.GetUCWord;
    if ADKeyWordMatch(ucS, 'CONNECT', 3) then begin
      FSrcQuery.Connection := FSrcConnection;
      FSrcConnStr := Parser.GetString();
    end
    else
      Parser.SetBookmark(iPrevBmk);
  end;

  // Destination
  ucS := Parser.GetUCWord;
  if ucS <> 'TO' then
    Parser.InvalidSyntax;
  ucS := Parser.GetUCWord;
  if ucS = 'FILE' then begin
    FDataMove.DestinationKind := skText;
    FDataMove.TextFileName := Parser.GetString();
  end
  else if ADKeyWordMatch(ucS, 'TABLE', 3) then begin
    FDataMove.DestinationKind := skDataSet;
    FDataMove.Destination := FDestQuery;
    FDestQuery.SQL.Text := Parser.GetString();
    iPrevBmk := Parser.GetBookmark;
    ucS := Parser.GetUCWord;
    if ADKeyWordMatch(ucS, 'CONNECT', 3) then begin
      FDestQuery.Connection := FDestConnection;
      FDestConnStr := Parser.GetString();
    end
    else
      Parser.SetBookmark(iPrevBmk);
  end;

  // Mode
  iPrevBmk := Parser.GetBookmark;
  ucS := Parser.GetUCWord;
  if ADKeyWordMatch(ucS, 'CLEAR', 3) then begin
    FDataMove.Options := FDataMove.Options + [poClearDest];
    FDataMove.Mode := dmAlwaysInsert;
  end
  else if ADKeyWordMatch(ucS, 'TRUNCATE', 5) then begin
    FDataMove.Options := FDataMove.Options + [poClearDest, poClearDestNoUndo];
    FDataMove.Mode := dmAlwaysInsert;
  end
  else if ADKeyWordMatch(ucS, 'ALWAYSINSERT', 6) then
    FDataMove.Mode := dmAlwaysInsert
  else if ADKeyWordMatch(ucS, 'APPEND', 3) then
    FDataMove.Mode := dmAppend
  else if ADKeyWordMatch(ucS, 'UPDATE', 3) then
    FDataMove.Mode := dmUpdate
  else if ADKeyWordMatch(ucS, 'APPENDUPDATE', 9) then
    FDataMove.Mode := dmAppendUpdate
  else if ADKeyWordMatch(ucS, 'DELETE', 3) then
    FDataMove.Mode := dmDelete
  else begin
    FDataMove.Options := FDataMove.Options + [poClearDest, poClearDestNoUndo];
    FDataMove.Mode := dmAlwaysInsert;
    Parser.SetBookmark(iPrevBmk);
  end;

  // Log file
  iPrevBmk := Parser.GetBookmark;
  ucS := Parser.GetUCWord;
  if ucS = 'LOG' then begin
    iPrevBmk2 := Parser.GetBookmark;
    ucS := Parser.GetUCWord;
    if ucS = 'OFF' then
      FDataMove.LogFileAction := laNone
    else if ADKeyWordMatch(ucS, 'SPOOL', 3) or ADKeyWordMatch(ucS, 'OUTPUT', 3) then begin
      FDataMove.LogFileAction := laAppend;
      FLogToSpool := True;
    end
    else begin
      if ADKeyWordMatch(ucS, 'APPEND', 3) then
        FDataMove.LogFileAction := laAppend
      else begin
        FDataMove.LogFileAction := laCreate;
        Parser.SetBookmark(iPrevBmk2);
      end;
      FDataMove.LogFileName := Parser.GetString();
    end;
  end
  else begin
    FDataMove.LogFileAction := laNone;
    Parser.SetBookmark(iPrevBmk);
  end;

  // Config file
  iPrevBmk := Parser.GetBookmark;
  ucS := Parser.GetUCWord;
  if ucS = 'USING' then begin
    ucS := Parser.GetUCWord;
    if ucS = 'FILE' then
      FConfigFile := Parser.GetString()
    else if ucS = 'PARAMS' then
      FConfigParams := Parser.GetString()
    else
      Parser.InvalidSyntax;
  end
  else
    Parser.SetBookmark(iPrevBmk);
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCopyScriptCommand.DumpServerOutput;
var
  i: Integer;
begin
  if not (EngineIntf.ConnectionIntf.Options.ResourceOptions as TADTopResourceOptions).ServerOutput or
     (EngineIntf.ConnectionIntf.Messages = nil) or (EngineIntf.ConnectionIntf.Messages.ErrorCount = 0) then
    Exit;
  for i := 0 to EngineIntf.ConnectionIntf.Messages.ErrorCount - 1 do
    EngineIntf.ConPut(EngineIntf.ConnectionIntf.Messages[i].Message, soServerOutput);
  EngineIntf.ConPut('', soSeparator);
end;

{-------------------------------------------------------------------------------}
procedure TADCopyScriptCommand.Execute;
var
  oStr: TStream;
  s, sFeedback, sTabSrc, sTabDest: String;
  dwStartTime: LongWord;
  dwExecTime: LongWord;

  function DefineFileName(const ADir, AFile, AExt: String): String;
  begin
    Result := AFile;
    if (ExtractFilePath(Result) = '') and (ADir <> '') then
      Result := ADNormPath(ADir) + Result;
    if (ExtractFileExt(Result) = '') and (AExt <> '') then
      Result := Result + '.' + AExt;
    Result := EngineIntf.ExpandString(Result);
  end;

begin
  if (FDataMove.Source <> nil) and (TADQuery(FDataMove.Source).Connection = nil) then begin
    TADQuery(FDataMove.Source).Connection := Engine.Connection;
    TADQuery(FDataMove.Source).Transaction := Engine.Transaction;
  end;
  sTabSrc := EngineIntf.ExpandString(Trim(FSrcQuery.SQL.Text));
  if (sTabSrc <> '') and not ADKeyWordMatch('SELECT ', sTabSrc, 7) then
    FSrcQuery.SQL.Text := 'SELECT * FROM ' + sTabSrc
  else
    FSrcQuery.SQL.Text := sTabSrc;

  if (FDataMove.Destination <> nil) and (TADQuery(FDataMove.Destination).Connection = nil) then begin
    TADQuery(FDataMove.Destination).Connection := Engine.Connection;
    TADQuery(FDataMove.Destination).Transaction := Engine.Transaction;
  end;
  sTabDest := EngineIntf.ExpandString(Trim(FDestQuery.SQL.Text));
  if (sTabDest <> '') and not ADKeyWordMatch('SELECT ', sTabDest, 7) then
    FDestQuery.SQL.Text := 'SELECT * FROM ' + sTabDest
  else
    FDestQuery.SQL.Text := sTabDest;

  if FSrcConnStr <> '' then begin
    FSrcConnection.Close;
    FSrcConnection.ResultConnectionDef.Params.Clear;
    FSrcConnection.ResultConnectionDef.ParseString(EngineIntf.ExpandString(FSrcConnStr));
    FSrcConnection.LoginPrompt := False;
    FSrcConnection.Close;
  end;

  if FDestConnStr <> '' then begin
    FSrcConnection.Close;
    FDestConnection.ResultConnectionDef.Params.Clear;
    FDestConnection.ResultConnectionDef.ParseString(EngineIntf.ExpandString(FDestConnStr));
    FDestConnection.LoginPrompt := False;
    FSrcConnection.Close;
  end;

  if FDataMove.TextFileName <> '' then begin
    s := EngineIntf.ExpandString(FDataMove.TextFileName);
    if FDataMove.SourceKind = skText then begin
      if not FileExists(s) then begin
        s := DefineFileName(Engine.ScriptOptions.DefaultDataPath, s, 'csv');
        if not FileExists(s) then
          s := DefineFileName(Engine.ScriptOptions.DefaultDataPath, s, 'txt');
      end;
    end
    else
      s := DefineFileName(Engine.ScriptOptions.DefaultDataPath, s, 'txt');
    FDataMove.TextFileName := s;
  end;

  if FConfigFile <> '' then begin
    oStr := TADFileStream.Create(EngineIntf.ExpandString(FConfigFile),
      fmOpenRead or fmShareDenyWrite);
    try
      oStr.ReadComponent(FDataMove);
    finally
      ADFree(oStr);
    end;
  end
  else if FConfigParams <> '' then begin
    oStr := TStringStream.Create(EngineIntf.ExpandString(FConfigParams));
    try
      oStr.ReadComponent(FDataMove);
    finally
      ADFree(oStr);
    end;
  end;

  FDataMove.CommitCount := Engine.ScriptOptions.CommitEachNCommands;
  if Engine.ScriptOptions.BreakOnError then
    FDataMove.Options := FDataMove.Options + [poAbortOnExc]
  else
    FDataMove.Options := FDataMove.Options - [poAbortOnExc];
  FDataMove.LogFileName := EngineIntf.ExpandString(FDataMove.LogFileName);

  if FLogToSpool then
    if Engine.ScriptOptions.SpoolOutput <> smNone then begin
      FDataMove.LogFileName := EngineIntf.ExpandString(Engine.LastSpoolFileName);
      Engine.ScriptOptions.SpoolOutput := smOnAppend;
      EngineIntf.CloseSpool;
    end
    else
      FDataMove.LogFileAction := laNone;

  if Engine.ScriptOptions.FeedbackCommands then begin
    sFeedback := '';
    case FDataMove.Mode of
    dmAlwaysInsert: sFeedback := 'Insert data into';
    dmAppend:       sFeedback := 'Append data into';
    dmUpdate:       sFeedback := 'Update data in';
    dmAppendUpdate: sFeedback := 'Append or update data in';
    dmDelete:       sFeedback := 'Delete data in';
    end;
    case FDataMove.DestinationKind of
    skDataSet: sFeedback := sFeedback + ' table ' + sTabDest;
    skText:    sFeedback := sFeedback + ' file ' + FDataMove.TextFileName;
    end;
    sFeedback := sFeedback + ' from ';
    case FDataMove.SourceKind of
    skDataSet: sFeedback := sFeedback + 'table ' + sTabDest;
    skText:    sFeedback := sFeedback + 'file ' + FDataMove.TextFileName;
    end;
    sFeedback := sFeedback + ' ...';
    EngineIntf.ConPut(sFeedback, soCommand);
  end;

  try
    dwStartTime := ADGetTickCount();
    FDataMove.Execute;
    dwExecTime := ADGetTickCount() - dwStartTime;
  finally
    if (EngineIntf.ConnectionIntf.Options.ResourceOptions as TADTopResourceOptions).ServerOutput then
      DumpServerOutput;

    if FLogToSpool then
      if Engine.ScriptOptions.SpoolOutput <> smNone then
        EngineIntf.UpdateSpool;
  end;

  if Engine.ScriptOptions.FeedbackCommands then begin
    sFeedback := Format('Rows read: %d. Rows written: %d (inserted: %d, updated: %d, deleted: %d)'#13#10,
      [FDataMove.ReadCount, FDataMove.WriteCount, FDataMove.InsertCount,
       FDataMove.UpdateCount, FDataMove.DeleteCount]);
    if FDataMove.ExceptionCount = 0 then
      sFeedback := sFeedback + 'Ok'
    else
      sFeedback := sFeedback + Format('Errors: %d', [FDataMove.ExceptionCount]);
    if Engine.ScriptOptions.Timing then
      sFeedback := sFeedback + Format(' [%.2d:%.2d:%.2d.%.3d]', [
        (dwExecTime div 3600000) mod 60, (dwExecTime div 60000) mod 60,
        (dwExecTime div 1000) mod 60, dwExecTime mod 1000]);
    sFeedback := sFeedback + '.';
    EngineIntf.ConPut(sFeedback, soCommand);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCopyScriptCommand.AbortJob(const AWait: Boolean);
begin
  FDataMove.AbortJob;
end;

{-------------------------------------------------------------------------------}
{ TADDelimiterScriptCommand                                                     }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADDelimiterScriptCommand.Dump: String;
begin
  Result := '<delimiter> [' + FCmdSep + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADDelimiterScriptCommand.Help: String;
begin
  Result := 'DELIMiter <text> - sets script command delimiter';
end;

{-------------------------------------------------------------------------------}
class procedure TADDelimiterScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('DELIMiter')
end;

{-------------------------------------------------------------------------------}
function TADDelimiterScriptCommand.Parse(const AKwd: String): Boolean;
begin
  FCmdSep := Parser.GetStringInFull;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDelimiterScriptCommand.Execute();
begin
  Parser.ScriptOptions.CommandSeparator := FCmdSep;
  EngineIntf.UpdateCommandSeparator;
end;

{-------------------------------------------------------------------------------}
procedure TADDelimiterScriptCommand.Validate();
begin
  Execute();
end;

{-------------------------------------------------------------------------------}
{ TADIBCreateDBScriptCommand                                                    }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADIBCreateDBScriptCommand.Dump: String;
begin
  Result := '<create IB database> [' + FDB + ']';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class procedure TADIBCreateDBScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('CREATE DATABASE');
end;

{-------------------------------------------------------------------------------}
function TADIBCreateDBScriptCommand.Parse(const AKwd: String): Boolean;
var
  ucS: String;
begin
  if EngineIntf.RDBMSKind <> mkInterbase then begin
    Result := False;
    Exit;
  end;
  Result := True;
  FDB := Parser.GetString(True);
  while True do begin
    Parser.SkipWSLF;
    ucS := Parser.GetUCWord;
    if ucS = '' then
      Break;
    if ADKeywordMatch(ucS, 'USER', 4) then
      FUser := Parser.GetString(True)
    else if ADKeywordMatch(ucS, 'PASSWORD', 8) then
      FPwd := Parser.GetString(True)
    else if ADKeywordMatch(ucS, 'PAGE_SIZE', 9) then
      FPageSize := Parser.GetString(True)
    else if ADKeywordMatch(ucS, 'DEFAULT', 7) then begin
      ucS := Parser.GetUCWord;
      if ucS = 'CHARACTER' then begin
        ucS := Parser.GetUCWord;
        if ucS = 'SET' then
          FCharset := Parser.GetString(True);
      end;
    end
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIBCreateDBScriptCommand.Execute;
var
  oDef: IADStanConnectionDef;
begin
  Engine.Connection.Close;
  oDef := Engine.Connection.ResultConnectionDef;
  oDef.AsYesNo[S_AD_ConnParam_IB_CreateDatabase] := True;
  oDef.Database := EngineIntf.ExpandString(FDB);
  oDef.UserName := EngineIntf.ExpandString(FUser);
  oDef.Password := EngineIntf.ExpandString(FPwd);
  oDef.AsString[S_AD_ConnParam_IB_PageSize] := EngineIntf.ExpandString(FPageSize);
  EngineIntf.OpenConnection('');
end;

{-------------------------------------------------------------------------------}
{ TADIBDropDBScriptCommand                                                      }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADIBDropDBScriptCommand.Dump: String;
begin
  Result := '<drop IB database>';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class procedure TADIBDropDBScriptCommand.Keywords(AKwds: TStrings);
begin
  AKwds.Add('DROP DATABASE');
end;

{-------------------------------------------------------------------------------}
function TADIBDropDBScriptCommand.Parse(const AKwd: String): Boolean;
begin
  Result := EngineIntf.RDBMSKind = mkInterbase;
end;

{-------------------------------------------------------------------------------}
procedure TADIBDropDBScriptCommand.Execute;
var
  prevChanging: TNotifyEvent;
  oDef: IADStanConnectionDef;
begin
  oDef := Engine.Connection.ResultConnectionDef;
  prevChanging := oDef.OnChanging;
  oDef.OnChanging := nil;
  try
    oDef.AsYesNo[S_AD_ConnParam_IB_DropDatabase] := True;
    Engine.Connection.Close;
  finally
    oDef.AsYesNo[S_AD_ConnParam_IB_DropDatabase] := False;
    oDef.OnChanging := prevChanging;
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  ADScriptCommandRegistry().DefaultSQLCommandClass := TADSQLScriptCommand;
  ADScriptCommandRegistry().DefaultPLSQLCommandClass := TADPLSQLScriptCommand;

  ADScriptCommandRegistry().AddCommand(TADRunScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADAcceptScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADConnectScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADCopyScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADDefineScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADDelimiterScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADDisconnectScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADExecuteScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADExitScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADHelpScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADHostScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADPauseScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADPromptScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADPrintScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADRemarkScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADSetScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADSpoolScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADUndefineScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADVariableScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADIBCreateDBScriptCommand);
  ADScriptCommandRegistry().AddCommand(TADIBDropDBScriptCommand);

end.
