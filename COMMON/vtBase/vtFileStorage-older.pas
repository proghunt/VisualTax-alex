unit vtFileStorage;
(* This unit provides the low-level storage of Return data in files.
  The TFileStorage class encapsulates the file access (stream or FILE),
  and the old and new storage format.
  The new storage format supports Memo and RTF strings.

Old format:
    forms data records, separated by CR/LF:
    { General : Var1, Var2     , Var3  , Var4}
    { Formats : F   , FormName ,       ,     }
    { Formats : O   , 'OVR ? needed'    ,       ,     }
    {           D   , Elm      , Value ,     }
    {         : S   , SlipName , Index , ?   }
New format is binary.
*)

interface

{$H+} //use AnsiString by default

uses
  Classes, Data.SQLExpr, uADCompClient, vtDataBase, Winapi.Windows,
  System.Generics.Collections; //20161207 Igor

type
  eFSFileMode = (fsRead, fsWrite);

  TDataAtom = class
  private
    FFormName: String;
    FElementId: String;
    FRecordType: String;
    FValue: String;
  public
    constructor Create(const AFormName, AElementID, ARecordType, AValue: String);
    property FormName: String read FFormName;
    property ElementId: String read FElementId;
    property RecordType: String read FRecordType;
    property Value: String read FValue;
  end;

  TDataModel = class(TObjectList<TDataAtom>)
  private
    FItemIndex: Integer;
    FLastReadForm: String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Reset;
    procedure SetToStart;
    function ReadNextLine(var var1, var2, var3, var4: String): Boolean;
    function GetValue(const AFormName, ARecordType: String;
      const AElementID: Integer): String;
  end;

  // 20151212 Igor
   //20160415 Igor>>>
  TSQLiteStorage = class
  private
    ADConnection: TADConnection;
//20161206 Igor >>>
//    FQSettings,
    FQData: TADQuery;
//    FQWork: TADQuery;
//20161206 Igor <<<
    FLastError: String;
    FMode: eFSFileMode;
    FPwdArr: Variant;
    FVersion: Integer;
    FStartRead: Boolean;
    FCommonKey: String; //20161206 Igor
    FPrivateKey: String; //20161206 Igor
    FDataBasePrepared: Boolean; //20161207 Igor
    FPreparedTable: TStringList; //20161207 Igor
    FDataModel: TDataModel; //20161207 Igor
    procedure EmptyDataBase; //20161206 Igor
    procedure ReadVersion; //20161206 Igor
    procedure ReadPrivateKey; //20161207 Igor
    function DoReadDataV1(const AFormName, ARecordType: String;
      const AElementID: Integer): String; //20161206 Igor
    function DoReadDataV2(const AFormName, ARecordType: String;
      const AElementID: Integer): String; //20161206 Igor
    function DoReadSettingsV1(const AParamName: String;
      var AParamValue: String): boolean; //20161206 Igor
    function DoReadSettingsV2(const AParamName: String;
      var AParamValue: String): boolean; //20161206 Igor
    function DoWriteDataV1(const AFormName: String; const ARecordType: String; //20161206 Igor
      const AElementID: Integer; const AElementValue: String): Boolean;
    function DoWriteDataV2(const AFormName: String; const ARecordType: String; //20161206 Igor
      const AElementID: Integer; const AElementValue: String): Boolean;
    function DoWriteSettingsV1(const AParamName: String; //20161206 Igor
      const AParamValue: Variant): Boolean;
    function DoWriteSettingsV2(const AParamName: String; //20161206 Igor
      const AParamValue: Variant): Boolean;
    function DoReadNextLineV1(var var1, var2, var3, var4: String): Boolean; //20161206 Igor
    function DoReadNextLineV2(var var1, var2, var3, var4: String): Boolean; //20161206 Igor
    procedure DoStartReadV1; //20161206 Igor
    procedure DoStartReadV2; //20161206 Igor
    procedure PrepareDataBase; //20161207 Igor
    procedure DoPrepareDataBaseV1;//20161207 Igor
    procedure DoPrepareDataBaseV2; //20161207 Igor

    function EncodeMeta(const AMeta: String): String; //20161207 Igor
    function DecodeMeta(const AMeta: String): String; //20161207 Igor

    function EncodeData(const AData: String; Salt: Boolean = False): String; //20161207 Igor
    function DecodeData(const AData: String; const AKey: String = ''; Salt: Boolean = False): String; //20161207 Igor

    function GetCommonKey: String; //20161207 Igor
    procedure GeneratePrivateKey; //20161207 Igor
    function GenerateFakeKey: String; //20161207 Igor

    function PrepareTable(ATableName: String): Boolean;
  public
    constructor Create(const lDirName, lDBName: string;
      const AMode: eFSFileMode; APwdArr: Variant);
    destructor Destroy; override;

    function WriteSettings(const AParamName: String; const AParamValue: Variant):Boolean;
    function WriteData(const AFormName: String; const ARecordType: String;
      const AElementID: Integer; const AElementValue: String):Boolean;
    function ReadSettings(const AParamName: String; var AParamValue: String): Boolean;
    function ReadData(const AFormName: String; const ARecordType: String;
      const AElementID: Integer): String; //20160423 Igor
    property LastError: String read FLastError;
    //20161206 Igor >>>
//    property QData: TADQuery read FQData;
//    property QSettings: TADQuery read FQSettings write FQSettings;
//    property QWork: TADQuery read FQWork;
    function ReadNextLine(var var1, var2, var3, var4: String): Boolean;
    procedure StartRead; //20161206 Igor
    //20161206 Igor >>>
  end;
 //20160415 Igor<<<

  TFileStorage = class
  private
    F1: TEXT;
    strm: TFileStream;
    ss: TStringStream;
    Version: char;
    //fSQL:TSQLiteStorage; //20160121 Igor
  public
    DataDir: string; //for directory checks in ReadReturn
    TextFormat: boolean;
    //constructor Create(const DirName, FileName: string; fWrite: boolean);
    constructor Create(const DirName, FileName: string; fWrite: eFSFileMode;
  ATextFormat: Boolean = False);//20160121 Igor //20160217 Igor
    destructor Destroy; override;
    function ReadLine(var Var1, Var2, Var3, Var4: string): boolean;
    function ReadData(const AFormName: String; const ARecordType: String;
      const AElementID: Integer): String; //20160423 Igor
    procedure WriteLine(const V1, V2, V3, V4: string);
    procedure ResetCursor; //20160423 Igor
    class procedure LoadToStringList(AFileName: String; var AList: TStringList);
  end;

var
  Asked, OldFormat: boolean;

function ReadNextLine(SQLite: TSQLiteStorage; var Var1, Var2, Var3, Var4: String; f: TFileStorage): Boolean; //20160820 Igor
Procedure BuildExperience(FrmNm: String; FromElm, ToElm, ByElm: Integer;
  FlName: String; SQLite: TSQLiteStorage; f: TFileStorage); overload; //20160820 Igor

implementation

uses
  SysUtils, Dialogs, Controls, DB, Variants,
  vtCommon, vtMulti, vtMain, vtTrimStr, vtShared, //uDeclare; //for Delimiter
  IdHashMessageDigest, uEncrypt; //20161207 Igor

const
  NewFileVersion = #1; //increment with every change of the file format.
  Delimiter: string = Chr(127); {in file i/o between variables}

  c_currentVersion: integer = 1; //20161207 Igor  //20161211 Igor
  SETTINGS_TABLE_NAME: String = 'Settings'; //20161207 Igor
  PARAMNAME_COLUMN_NAME: String = 'Key'; //20161207 Igor
  PARAMVALUE_COLUMN_NAME: String = 'Value'; //20161207 Igor

  ELEMENTID_COLUMN_NAME: String = 'Number';
  RECORDTYPE_COLUMN_NAME: String = 'Mark';
  RECORDVALUE_COLUMN_NAME: String = 'Data';
 //20160415 Igor>>>

function StringHashMD5(AText: String): String; //20161207 Igor
begin
  with TIdHashMessageDigest5.Create do
    try
      result := HashStringAsHex(AText);
    finally
      Free;
    end;
end;

{ TSQLiteStorage }

constructor TSQLiteStorage.Create(const lDirName, lDBName: string;
  const AMode: eFSFileMode; APwdArr: Variant);
var
  _DbFullName: String;
  I: Integer;
begin
  FDataBasePrepared := False;
  FLastError := '';
  FMode := AMode;
  _DbFullName := lDirName + '\' + lDBName;
//  if not sameText(ExtractFileExt(_DbFullName),'.sqlite') then
//    _DbFullName := _DbFullName + '.sqlite';

  if (FMode = fsRead) AND
     not FileExists(_DbFullName) then
  Begin
    FLastError := 'File ['+_DbFullName+'] not exists';
    exit;
  End;
  FPwdArr := APwdArr;

  ADConnection := TADConnection.Create(nil);
  ADConnection.DriverName := 'Sqlite';
  ADConnection.LoginPrompt := false;
  ADConnection.Params.Values['Database'] := _DbFullName;
  ADConnection.Params.Values['Password'] := '';
  ADConnection.Params.Values['Password'] := VarArrayGet(FPwdArr, [VarArrayHighBound(FPwdArr, 1)]);
  try
    ADConnection.Open;
  except ON E: Exception do
    Begin
      for I := VarArrayHighBound(FPwdArr, 1)-1 downto VarArrayLowBound(FPwdArr, 1) do
      Begin
        ADConnection.Close;
        ADConnection.Params.Values['Password'] := VarArrayGet(FPwdArr, [I]);
        ADConnection.Params.Values['NewPassword'] := VarArrayGet(FPwdArr, [VarArrayHighBound(FPwdArr, 1)]);
        try
          ADConnection.Connected := True;
          if ADConnection.Connected then
            break;
        Except
        end;
      end;
      if not ADConnection.Connected then
      Begin
        if FMode = fsWrite then
        Begin
          RenameFile(_DbFullName,_DbFullName+'.old');
          ADConnection.Params.Values['Password'] := '';
          ADConnection.Params.Values['Password'] := VarArrayGet(FPwdArr, [VarArrayHighBound(FPwdArr, 1)]);
          try
            ADConnection.Connected := True;
            DeleteFile(_DbFullName+'.old');
          Except
            FLastError := 'Error open file: ' + _DbFullName+#13+E.Message; //20161206 Igor
            RenameFile(_DbFullName+'.old', _DbFullName);
            exit;
          end;
        End
        else
        Begin
          FLastError := 'Error open file: ' + _DbFullName+#13+E.Message;  //20161206 Igor
          exit;
        End;
      End;
    End;
  end;
  if FMode = fsWrite then
  Begin
//20161206 Igor>>>
    FVersion := c_currentVersion;
    PrepareDataBase;

(*
    try
      ADConnection.ExecSQL(
        'create table if not exists ReturnData('+
//          'RowID Integer PRIMARY KEY AUTOINCREMENT NOT NULL,'+
//          'Del INTEGER NOT NULL DEFAULT(0),'+
          'FormName VARCHAR(25) NOT NULL,'+
          'ElementID INTEGER NOT NULL,'+
          'RecordType VARCHAR(1) NOT NULL,'+
          'Value TEXT,'+
          'PRIMARY KEY (FormName,ElementID,RecordType)'+
        ' )');
    except ON E: Exception DO
    Begin
      FLastError := 'Error create table: [ReturnData]'+#13+E.Message;
      exit;
    End;
    end;
    try
      ADConnection.ExecSQL(
        'create table if not exists ReturnSettings('+
          'ParamName VarChar(100) PRIMARY KEY NOT NULL, '+
          //'Del INTEGER NOT NULL DEFAULT(0),'+
          'ParamValue TEXT'+
        ' )');
    except ON E: exception do
    Begin
      FLastError := 'Error create table: [ReturnSettings]'+#13+E.Message;
      exit;
    End;
    end;
*)
  end
  else
    ReadVersion;
//  FQWork := TADQuery.Create(nil);
//  FQWork.Connection := ADConnection;

//  if FMode = fsWrite then
//  Begin
//    ADConnection.StartTransaction;
//    FQWork.SQL.Text := 'Delete from ReturnSettings';
//    FQWork.ExecSQL;
//
//    FQWork.SQL.Text := 'Delete from ReturnData';
//    FQWork.ExecSQL;

//    FQWork.SQL.Text := 'Update ReturnSettings SET Del = 1';
//    FQWork.ExecSQL;
//
//    FQWork.SQL.Text := 'Update ReturnData SET Del = 1';
//    FQWork.ExecSQL;
//  End;
  FStartRead := False;
//  FQSettings := TADQuery.Create(nil);
//  FQSettings.Connection := ADConnection;
//  FQSettings.SQL.Text := 'Select * from ReturnSettings';
//  try
//    FQSettings.Open;
//  except on E: Exception do
//  begin
//    FLastError := 'Error open table: [ReturnSettings]'+#13+E.Message;
//    exit;
//  end
//  end;
//
//  FQData := TADQuery.Create(nil);
//  FQData.Connection := ADConnection;
//  FQData.SQL.Text := 'Select * from ReturnData Order By FormName, ElementID';
//  try
//    FQData.Open;
//  except on E: Exception do
//  Begin
//    FLastError := 'Error open table: [ReturnData]'+#13+E.Message;
//    exit;
//  End;
//  end;
//20161206 Igor <<<
end;

function TSQLiteStorage.DecodeData(const AData: String; const AKey: String = ''; Salt: Boolean = False): String;
var
  key: String;
begin
  if AKey = '' then
    Key := FPrivateKey
  else
    Key := AKey;
  case FVersion of
    1: Result := AData;
    2: Result := uEncrypt.Decrypt(AData, Key, Salt);
  else
    Result := AData;
  end;
end;

function TSQLiteStorage.DecodeMeta(const AMeta: String): String;
begin
  case FVersion of
    1: Result := AMeta;
    2: Result := uEncrypt.Decrypt(AMeta, GetCommonKey);
  else
    Result := AMeta;
  end;
end;

destructor TSQLiteStorage.Destroy;
begin
  FLastError := '';
  if FMode = fsWrite then
  Begin
    ADConnection.Commit;
//    FQWork.SQL.Text := 'Delete from ReturnData Where Del = 1';
//    try
//      FQWork.ExecSQL;
//    except on e: exception do
//      ShowMessage (E.Message);
//    end;
//    FQWork.SQL.Text := 'Delete from ReturnSettings Where Del = 1';
//    try
//      FQWork.ExecSQL;
//    except on e: exception do
//      ShowMessage (E.Message);
//    end;
  End;
//20161206 Igor >>>
//  if Assigned(FQSettings) then
//  Begin
//    FQSettings.Close;
//    FreeAndNil(FQSettings);
//  End;
  if Assigned(FQData) then
  Begin
    FQData.Close;
    FreeAndNil(FQData);
  End;
//  if Assigned(FQWork) then
//  Begin
//    FQWork.Close;
//    FreeAndNil(FQWork);
//  End;
//20161206 Igor <<<
  if Assigned(ADConnection) then
  Begin
    ADConnection.Close;
    FreeAndNil(ADConnection);
  End;
  FDataModel.Free; //20161207 Igor
  FPreparedTable.Free; //20161207 Igor
  inherited;
end;

procedure TSQLiteStorage.EmptyDataBase;
var
  sl: TStringList;
  I: Integer;
begin
  with TADQuery.Create(nil) do
  begin
    try
      Connection := ADConnection;
      SQL.Text := 'Select `name` from `sqlite_master` where `type` = ''table''';
      Open;
      SL := TStringList.Create;
      try
        while Not eof do
        begin
          if pos('sqlite_', lowerCase(fieldByName('name').asString)) <> 1 then
            SL.Add(fieldByName('name').AsString);
          next;
        end;
        close;
        for I := 0 to SL.Count - 1 do
          ADConnection.ExecSQL('drop table if exists `'+SL[I]+'`');
      finally
        SL.Free;
      end;
    finally
      free;
    end;
  end;
end;

function TSQLiteStorage.EncodeData(const AData: String; Salt: Boolean = False): String;
begin
  case FVersion of
    1: Result := AData;
    2: Result := uEncrypt.Encrypt(AData, FPrivateKey, Salt);
  else
    Result := AData;
  end;
end;

function TSQLiteStorage.EncodeMeta(const AMeta: String): String;
begin
  case FVersion of
    1: Result := AMeta;
    2: Result := uEncrypt.Encrypt(AMeta, GetCommonKey);
  else
    Result := AMeta;
  end;
end;

function TSQLiteStorage.GenerateFakeKey: String;
var
  G: TGUID;
  S: String;
begin
  CreateGUID(G);
  S := GUIDToString(G);
  Delete(S,1,1);
  Delete(S,length(S),1);
  S := StringReplace(S, '-', '', [rfReplaceAll]);
  Result := S;
end;

procedure TSQLiteStorage.GeneratePrivateKey; //20161207 Igor
var
  G: TGUID;
  S: String;
begin
  CreateGUID(G);
  S := GUIDToString(G);
  Delete(S,1,1);
  Delete(S,length(S),1);
  S := StringReplace(S, '-', '', [rfReplaceAll]);
  FPrivateKey := S;
end;

function TSQLiteStorage.GetCommonKey: String;
  function CommonKeyV2: string;
  begin
    result := 'f'+chr(112)+'U'+chr(107)+'x'+chr(73)+'Y'+chr(67)+''+chr(81)+chr(66)+chr(57)+chr(99)+'K'+chr(67);
  end;
  function CommonSubKeyV2: Integer;
  begin
    result := strToInt(''+'7'+chr(56)+chr(55)+chr(56));
  end;
begin
  {TODO -oIgor : Generate common key}
  case FVersion of
    1: Result := '';
    2: Result := Decrypt(CommonKeyV2, CommonSubKeyV2);
    else Result := '';
  end;
end;


procedure TSQLiteStorage.PrepareDataBase;
begin
  case FVersion of
    1: DoPrepareDataBaseV1;
    2: DoPrepareDataBaseV2;
  end;
end;

function TSQLiteStorage.PrepareTable(ATableName: String): Boolean;
const
  SQL_CREATE = 'Create table if not exists `%s` (`%s` VARCHAR(50) NOT NULL, `%s` VARCHAR(50) NOT NULL, `%s` TEXT NULL, PRIMARY KEY (`%s`,`%s`))';
begin
  if FPreparedTable.IndexOf(ATableName) <> -1 then
    Result := True
  else
  begin
    try
      ADConnection.ExecSQL(Format(SQL_CREATE, [EncodeData(ATableName),
                                               EncodeData(ELEMENTID_COLUMN_NAME),
                                               EncodeData(RECORDTYPE_COLUMN_NAME),
                                               EncodeData(RECORDVALUE_COLUMN_NAME),
                                               EncodeData(ELEMENTID_COLUMN_NAME),
                                               EncodeData(RECORDTYPE_COLUMN_NAME)]));
      FPreparedTable.Add(ATableName);
      Result := True;
    except ON E: Exception DO
      begin
        result := False;
        exit;
      end;
    end;
  end;
end;

function TSQLiteStorage.ReadData(const AFormName, ARecordType: String;
  const AElementID: Integer): String; //20160423 Igor
begin
  Result := '';
  FLastError := '';
  if not ADConnection.Connected then
  Begin
    FLastError := 'Not connected';
    exit;
  End;
  //20161206 Igor >>>
  case FVersion of
    1: Result := DoReadDataV1(AFormName, ARecordType, AElementID);
    2: Result := DoReadDataV2(AFormName, ARecordType, AElementID);
    else
      Result := '';
  end;
//  if not FQData.Active then
//  Begin
//    FLastError := 'Not opened setting table';
//    exit;
//  End;
//  if FQData.Locate('FormName;RecordType;ElementID',VarArrayOf([AFormName,ARecordType,AElementID]),[loCaseInsensitive]) then
//    Result := FQData.FieldByName('Value').AsString;
    //20161206 Igor <<<
end;

function TSQLiteStorage.ReadNextLine(var var1, var2, var3,
  var4: String): Boolean;
begin
  case FVersion of
    1: Result := DoReadNextLineV1(var1, var2, var3, var4);
    2: Result := DoReadNextLineV2(var1, var2, var3, var4);
    else
      Result := False;
  end;
//    Result := not SQLite.QData.Eof;
//    if Result then
//    Begin
//      if (SQLite.QData.FieldByName('FormName').AsString <> 'Z_LINES') and
//         not SameText(SQLite.QData.FieldByName('FormName').AsString, PrevFormName) then
//      Begin
//        Var1 := 'F';
//        Var2 := SQLite.QData.FieldByName('FormName').AsString;
//        Var3 := '';
//        Var4 := '';
//        PrevFormName := SQLite.QData.FieldByName('FormName').AsString;
//      End
//      else
//      Begin
//        if (SQLite.QData.FieldByName('RecordType').AsString = 'O') or
//           (SQLite.QData.FieldByName('RecordType').AsString = 'R') then  //20160419 Igor
//        Begin
//          Var1 := SQLite.QData.FieldByName('RecordType').AsString;
//          Var2 := SQLite.QData.FieldByName('FormName').AsString;
//          Var3 := SQLite.QData.FieldByName('ElementID').AsString;
//          Var4 := SQLite.QData.FieldByName('Value').AsString;
//        End
//        else
//        begin
//          Var1 := SQLite.QData.FieldByName('RecordType').AsString;
//          Var2 := SQLite.QData.FieldByName('ElementID').AsString;
//          Var3 := SQLite.QData.FieldByName('Value').AsString;
//        end;
//        SQLite.QData.Next;
//      end;
//    End;
end;

procedure TSQLiteStorage.ReadPrivateKey;
  function ValidateKey(AKey, AConfirm: String): Boolean;
  Begin
    Result := StringHashMD5(DecodeMeta(AKey)) = DecodeData(AConfirm,DecodeMeta(AKey));
  End;
  procedure DoReadPrivateKeyV2;
  begin
    With TADQuery.Create(nil) do
    begin
      try
        Connection := ADConnection;
        SQL.Text := 'Select * from `'+EncodeMeta(SETTINGS_TABLE_NAME)+'`';
        Open;
        while not eof do
        begin
          if ValidateKey(Fields[0].asString, Fields[1].asString) then
          begin
            FPrivateKey := DecodeMeta(Fields[0].asString);
            break;
          end;
          next;
        end;
      finally
        free;
      end;
    end;
  end;
begin
  case FVersion of
    1:;
    2:DoReadPrivateKeyV2;
  end;
end;

procedure TSQLiteStorage.DoPrepareDataBaseV1; //20161207 Igor
begin
  try
    ADConnection.ExecSQL(
      'create table if not exists `ReturnData`('+
        '`FormName` VARCHAR(25) NOT NULL,'+
        '`ElementID` INTEGER NOT NULL,'+
        '`RecordType` VARCHAR(1) NOT NULL,'+
        '`Value` TEXT,'+
        'PRIMARY KEY (`FormName`,`ElementID`,`RecordType`)'+
      ' )');
  except ON E: Exception DO
    Begin
      FLastError := 'An error occurred during file preparation for recording.';
      exit;
    End;
  end;

  try
    ADConnection.ExecSQL(
      'create table if not exists `ReturnSettings`('+
        '`ParamName` VarChar(100) PRIMARY KEY NOT NULL, '+
        '`ParamValue` TEXT'+
      ' )');
  except ON E: exception do
    Begin
      FLastError := 'An error occurred during file preparation for recording.';
      exit;
    End;
  end;
end;

procedure TSQLiteStorage.DoPrepareDataBaseV2; //20161207 Igor
var
  PrivateKey: String;
  I, J, z: Integer;
begin
  EmptyDataBase;
  ADConnection.ExecSQL(
      'create table if not exists `'+EncodeMeta(SETTINGS_TABLE_NAME)+'`('+
        '`'+EncodeMeta(PARAMNAME_COLUMN_NAME)+'` VarChar(100) PRIMARY KEY NOT NULL, '+
        '`'+EncodeMeta(PARAMVALUE_COLUMN_NAME)+'` TEXT'+
      ' )');
  GeneratePrivateKey;
  Randomize;
  I := Random(10) + 3;
  J := Random(I - 3) + 3;
  for z := 0 to I do
    if z = J then
      WriteSettings(FPrivateKey, StringHashMD5(FPrivateKey))
    else
      WriteSettings(GenerateFakeKey, StringHashMD5(GenerateFakeKey));
 FDataBasePrepared := True;
 FPreparedTable := TStringList.Create;
end;

function TSQLiteStorage.DoReadDataV1(const AFormName, ARecordType: String;  //20161206 Igor
  const AElementID: Integer): String;
begin
  with TADQuery.Create(nil) do
  begin
    try
      Connection := ADConnection;
      SQL.Text := 'Select `Value` from `ReturnData` where lower(`FormName`) = '+QuotedStr(LowerCase(AFormName))+
                  ' AND lower(`RecordType`) = '+QuotedStr(LowerCase(ARecordType))+
                  ' AND `ElementID` = ' + IntToStr(AElementID);
      open;
      if not IsEmpty then
        Result := FieldByName('Value').AsString
      else
        Result := '';
    finally
      free;
    end;
  end;
end;

function TSQLiteStorage.DoReadDataV2(const AFormName, ARecordType: String;
  const AElementID: Integer): String;
begin
  if not FStartRead then
    DoStartReadV2;
  result := FDataModel.GetValue(AFormName, ARecordType, AElementID);
end;

function TSQLiteStorage.DoReadNextLineV1(var var1, var2, var3, var4: String): Boolean;
begin
  if not FStartRead then
    DoStartReadV1;
  Result := not FQData.Eof;
  if Result then
  Begin
    if (FQData.FieldByName('FormName').AsString <> 'Z_LINES') and
       not SameText(FQData.FieldByName('FormName').AsString, PrevFormName) then
    Begin
      Var1 := 'F';
      Var2 := FQData.FieldByName('FormName').AsString;
      Var3 := '';
      Var4 := '';
      PrevFormName := FQData.FieldByName('FormName').AsString;
    End
    else
    Begin
      if (FQData.FieldByName('RecordType').AsString = 'O') or
         (FQData.FieldByName('RecordType').AsString = 'R') then  //20160419 Igor
      Begin
        Var1 := FQData.FieldByName('RecordType').AsString;
        Var2 := FQData.FieldByName('FormName').AsString;
        Var3 := FQData.FieldByName('ElementID').AsString;
        Var4 := FQData.FieldByName('Value').AsString;
      End
      else
      begin
        Var1 := FQData.FieldByName('RecordType').AsString;
        Var2 := FQData.FieldByName('ElementID').AsString;
        Var3 := FQData.FieldByName('Value').AsString;
      end;
      FQData.Next;
    end;
  End;
end;

function TSQLiteStorage.DoReadNextLineV2(var var1, var2, var3, var4: String): Boolean;
begin
  if not FStartRead then
    DoStartReadV2;
  result := FDataModel.ReadNextLine(var1, var2, var3, var4);
end;

function TSQLiteStorage.DoReadSettingsV1(const AParamName: String; //20161206 Igor
  var AParamValue: String): boolean;
begin
  with TADQuery.Create(nil) do
  begin
    try
      Connection := ADConnection;
      SQL.Text := 'Select `ParamValue` from `ReturnSettings` where lower(`ParamName`) = ' +
        QuotedStr(LowerCase(AParamName));
      Open;
      if not isEmpty then
      begin
        AParamValue := fieldByName('ParamValue').AsString;
        result := true;
      end
      else
      begin
        FLastError := 'Param ['+AParamName+'] not found';
        result := False;
        exit;
      end;
    finally
      free;
    end;
  end;
end;

function TSQLiteStorage.ReadSettings(const AParamName: String;
  var AParamValue: String): Boolean;
begin
  Result := False;
  FLastError := '';
  if not ADConnection.Connected then
  Begin
    FLastError := 'Not connected';
    exit;
  End;
  //20161206 Igor >>>
  case FVersion of
    1: result := DoReadSettingsV1(AParamName, AParamValue);
    2: result := DoReadSettingsV2(AParamName, AParamValue);
    else
      Result := False;
  end;
(*
  if not QSettings.Active then
  Begin
    FLastError := 'Not opened setting table';
    exit;
  End;
  if not QSettings.Locate('ParamName',AParamName,[loCaseInsensitive]) then
  Begin
    FLastError := 'Param ['+AParamName+'] not found';
    exit;
  End;
//  if (QSettings.FieldByName('Del').AsInteger = 1) then
//  Begin
//    FLastError := 'Param ['+AParamName+'] is deleted';
//    exit;
//  End;

  AParamValue := QSettings.FieldByName('ParamValue').AsString;
  Result := True;
*)
//20161206 Igor <<<
end;

function TSQLiteStorage.DoReadSettingsV2(const AParamName: String;  //20161206 Igor
  var AParamValue: String): boolean;
begin
  with TADQuery.Create(nil) do
  begin
    try
      Connection := ADConnection;
      SQL.Text := 'Select `'+EncodeMeta(PARAMVALUE_COLUMN_NAME)+'` from `'+
        EncodeMeta(SETTINGS_TABLE_NAME)+'` where lower(`'+EncodeMeta(PARAMNAME_COLUMN_NAME)+'`) = ' +
        QuotedStr(LowerCase(EncodeData(AParamName)));
      Open;
      if not isEmpty then
      begin
        AParamValue := DecodeData(fields[0].AsString);
        result := true;
      end
      else
      begin
        FLastError := 'Param ['+AParamName+'] not found';
        result := False;
        exit;
      end;
    finally
      free;
    end;
  end;

end;

function TSQLiteStorage.DoWriteDataV1(const AFormName, ARecordType: String;
  const AElementID: Integer; const AElementValue: String): Boolean;
begin
  try
    ADConnection.ExecSQL('Insert or replace into `ReturnData` (`FormName`, `ElementID`, `RecordType`, `Value`) Values '+
      '('+QuotedStr(AFormName)+', '+IntToStr(AElementID) + ', '+ QuotedStr(ARecordType)+', '+QuotedStr(AElementValue)+')');
    result := true;
  except ON E: Exception DO
    Begin
      FLastError := 'Write data error';
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteStorage.DoWriteDataV2(const AFormName, ARecordType: String;
  const AElementID: Integer; const AElementValue: String): Boolean;
begin
  if not PrepareTable(AFormName) then
  begin
    FLastError := 'Write data error';
    Result := False;
    Exit;
  end;
  try
    ADConnection.ExecSQL('Insert or replace into `' + EncodeData(AFormName) + '` '+
                         '(`' + EncodeData(ELEMENTID_COLUMN_NAME) + '`, ' +
                         '`' + EncodeData(RECORDTYPE_COLUMN_NAME) + '`, ' +
                         '`' + EncodeData(RECORDVALUE_COLUMN_NAME) + '`) '+
                  'Values (' + QuotedStr(EncodeData(IntToStr(AElementID), True)) + ', ' +
                               QuotedStr(EncodeData(ARecordType, True)) + ', ' +
                               QuotedStr(EncodeData(AElementValue, True)) + ')');
    result := true;
  except ON E: Exception DO
    Begin
      FLastError := 'Write data error';
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteStorage.DoWriteSettingsV1(const AParamName: String;
  const AParamValue: Variant): Boolean;
begin
  try
    ADConnection.ExecSQL('Insert or replace into `ReturnSettings` (`ParamName`, `ParamValue`) Values ' +
      '(' + QuotedStr(AParamName) + ', ' + QuotedStr(AParamValue) + ')');
    result := true;
  except ON E: Exception DO
    Begin
      FLastError := 'Write data error';
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteStorage.DoWriteSettingsV2(const AParamName: String;
  const AParamValue: Variant): Boolean;
var S:String;
begin
  try
    if FDataBasePrepared then
      S := EncodeData(AParamName)
    else
      S := EncodeMeta(AParamName);
    ADConnection.ExecSQL('Insert or replace into `'+EncodeMeta(SETTINGS_TABLE_NAME)+'` (`'+
      EncodeMeta(PARAMNAME_COLUMN_NAME)+'`, `'+EncodeMeta(PARAMVALUE_COLUMN_NAME)+'`) Values ' +
      '(' + QuotedStr(S) + ', ' + QuotedStr(EncodeData(AParamValue)) + ')');
    result := true;
  except ON E: Exception DO
    Begin
      FLastError := 'Write data error';
      Result := False;
      Exit;
    End;
  end;
end;

procedure TSQLiteStorage.ReadVersion;
begin
  with TADQuery.Create(nil) do
  begin
    try
      Connection := ADConnection;
      SQL.Text := 'Select `name` from `sqlite_master` where type = ''table'' and lower(`name`) = lower(''ReturnData'')';
      open;
      if not IsEmpty then
        FVersion := 1
      else
        FVersion := 2;
    finally
      free;
    end;
  end;
  //Read private Key
  ReadPrivateKey;
end;

procedure TSQLiteStorage.StartRead;
begin
  case FVersion of
    1: DoStartReadV1;
    2: DoStartReadV2;
  end;
end;

procedure TSQLiteStorage.DoStartReadV1;
begin
  if not Assigned(FQData) then
  begin
    FQData := TADQuery.Create(nil);
    FQData.Connection := ADConnection;
  end;
  FQData.Close;
  FQData.SQL.Text := 'Select * from ReturnData Order By FormName, ElementID';
  FQData.Open;
  FStartRead := True;
end;

procedure TSQLiteStorage.DoStartReadV2;
var
  Q1, Q2: TADQuery;
  TableName, DecodedTableName, ElmField, TypeField, ValueField: String;
begin
  if not assigned(FDataModel) then
    FDataModel := TDataModel.Create;
  FDataModel.Reset;
  ElmField := EncodeData(ELEMENTID_COLUMN_NAME);
  TypeField := EncodeData(RECORDTYPE_COLUMN_NAME);
  ValueField := EncodeData(RECORDVALUE_COLUMN_NAME);
  Q1 := TADQuery.Create(nil);
  try
    Q1.Connection := ADConnection;
    Q1.SQL.Text := 'Select `name` from `sqlite_master` where `type` = ''table''';
    Q1.Open;

    Q2 := TADQuery.Create(nil);
    try
      Q2.Connection := ADConnection;
      while Not Q1.Eof do
      Begin
        TableName := Q1.FieldByName('name').AsString;
        DecodedTableName := DecodeData(TableName);
        if (pos('sqlite_', lowercase(TableName)) <> 1) and
           (Q1.FieldByName('name').AsString <> EncodeMeta(SETTINGS_TABLE_NAME)) then
        begin
          Q2.SQL.Text := 'Select * from `'+Q1.FieldByName('name').AsString+'`';
          Q2.Open;
          while not Q2.Eof do
          Begin
            FDataModel.Add(TDataAtom.Create(DecodedTableName,
                                            DecodeData(Q2.FieldByName(ElmField).AsString, '', True),
                                            DecodeData(Q2.FieldByName(TypeField).AsString, '', True),
                                            DecodeData(Q2.FieldByName(ValueField).AsString, '', True)));
            Q2.Next;
          End;
        end;
        Q1.Next;
      End;
    finally
      Q2.Free;
    end;
  finally
    Q1.Free;
  end;
  FDataModel.SetToStart;
  FStartRead := True;
end;

function TSQLiteStorage.WriteData(const AFormName: String; const ARecordType: String;
  const AElementID: Integer; const AElementValue: String): Boolean;
begin
  Result := False;
  FLastError := '';
  if not ADConnection.Connected then
  Begin
    FLastError := 'Not connected';
    exit;
  End;
  if FMode <> fsWrite then
  Begin
    FLastError := 'Connection opened in readonly mode';
    exit;
  End;
  //20161206 Igor >>>
  case FVersion of
    1: DoWriteDataV1(AFormName, ARecordType, AElementID, AElementValue);
    2: DoWriteDataV2(AFormName, ARecordType, AElementID, AElementValue);
    else
      Result := False;
  end;

//  if QData.Locate('FormName;ElementID;RecordType',VarArrayOf([AFormName,AElementID,ARecordType]),[]) then
//    QData.Edit
//  else
//  begin
//    QData.Append;
//    QData.FieldByname('FormName').AsString := AFormName;
//    QData.FieldByname('ElementID').AsInteger := AElementID;
//    QData.FieldByname('RecordType').AsString := ARecordType;
//  End;
////  QData.FieldByName('Del').AsInteger := 0;
//  QData.FieldByName('Value').AsString := AElementValue;
//  try
//    QData.Post;
//  except on E: Exception do
//  Begin
//    QData.Cancel;
//    FLastError := E.Message;
//    exit;
//  end;
//  end;

  //20161206 Igor <<<
  result := True;
end;

function TSQLiteStorage.WriteSettings(const AParamName: String;
  const AParamValue: Variant): Boolean;
begin
  Result := False;
  FLastError := '';
  if not ADConnection.Connected then
  Begin
    FLastError := 'Not connected';
    exit;
  End;
  if FMode <> fsWrite then
  Begin
    FLastError := 'Connection opened in readonly mode';
    exit;
  End;
  //20161206 Igor >>>
  case FVersion of
    1: Result := DoWriteSettingsV1(AParamName, AParamValue);
    2: Result := DoWriteSettingsV2(AParamName, AParamValue);
    else
      Result := False;
  end;
(*
  if QSettings.Locate('ParamName',AParamName,[loCaseInsensitive]) then
    QSettings.Edit
  else
  begin
    QSettings.Append;
    QSettings.FieldByname('ParamName').AsString := AParamName;
  End;
//  QSettings.FieldByName('Del').AsInteger := 0;
  QSettings.FieldByName('ParamValue').AsString := VarToStr(AParamValue);
  try
    QSettings.Post;
  except on E: Exception do
  Begin
    QSettings.Cancel;
    FLastError := E.Message;
    exit;
  end;
  end;
  result := True;
*)
  //20161206 Igor <<<
end;
 //20160415 Igor<<<
{  TFileStorage  }

constructor TFileStorage.Create(const DirName, FileName: string; fWrite: eFSFileMode;
  ATextFormat: Boolean = False);//20160121 Igor //20160217 Igor
//constructor TFileStorage.Create(const DirName, FileName: string; fWrite: boolean);
const
  //mode: array[boolean] of word = (fmOpenRead, fmCreate);
  mode: array[eFSFileMode] of word = (fmOpenRead, fmCreate);
begin
//  fSQL := TSQLiteStorage.Create(DirName, FileName, fWrite); // 20151212 Igor
  TextFormat := ATextFormat;//20160121 Igor
  DataDir := DirName;
  //strm := TFileStream.Create(DirName + '\' + FileName, mode[fWrite]);
    //don't open in write mode!
  if fWrite = fsWrite then
  begin
//    if not Asked then
//    begin
//     OldFormat := True;   //20150704
//      {
//      case MessageDlg('Save returns in new (binary) format?',
//        mtConfirmation, [mbYes, mbNo], 0) of
//        mrYes: OldFormat := False;
//      else
//        OldFormat := True;
//      end;
//      }
//      Asked := True;
//    end;
//    TextFormat := OldFormat;
//    TextFormat := false; // !!!20151212 Igor
    if TextFormat then
    try //filename problems?
      AssignFile(F1, DirName + '\' + FileName+'.old'); //20160419 Igor
      Rewrite(F1);
    except
      errormsg('Cannot save in old format: ' + DirName + '\' + FileName);
      TextFormat := False;
    end;
    if not TextFormat then
    begin
      strm := TFileStream.Create(DirName + '\' + FileName+'.old', mode[fWrite]); //20160419 Igor
      Version := NewFileVersion;
      strm.Write(Version, 1); //write the file header
    end;
    exit; //write mode
  end;
  //read file, check the file format
  strm := TFileStream.Create(DirName + '\' + FileName, mode[fWrite]);
  ss := TStringStream.Create; //20160217 Igor
  ss.CopyFrom(strm, strm.Size); //20160217 Igor
  ss.Position := 0; //20160217 Igor
  ss.Read(Version,1); //20160217 Igor

//  strm.Position := 0;
//  strm.Read(Version, 1);

  TextFormat := Version >= '0'; //new files start with a flag < '0'
  if TextFormat then
  begin
    FreeAndNil(strm); //use F instead
    FreeAndNil(ss);

    AssignFile(F1, DirName + '\' + FileName);
    Reset(F1);
  end;
end;

destructor TFileStorage.Destroy;
begin
//  fSQL.Free; // 20151212 Igor  //20160121 Igor
  //close the file
  if strm = nil then
    CloseFile(F1);
  FreeAndNil(strm);
  FreeAndNil(ss);

  inherited;
  //MainForm.GuiCommand(gcHideFlash);//20160530 Igor
end;

class procedure TFileStorage.LoadToStringList(AFileName: String;  //20160301 Igor
  var AList: TStringList);
var
  Mystrm : TFileStream;
  Myss : TStringStream;
  S, val1, val2, val3, val4: String;
  ver: Char;
  function ReadS4(var v: string): Boolean;
  var
    n,i: integer;
  begin
    Result := Myss.Read(n, 4) = 4;
    if Result and (n > 0) then
      v := Myss.ReadString(n)
    else
      v := '';
  end;
begin
  if not assigned(AList) then
    AList := TStringList.Create;
  AList.Clear;
  if not FileExists(AFileName) then exit;
  Mystrm := TFileStream.Create(AFileName, 0);
  Myss := TStringStream.Create;
  try
    Myss.CopyFrom(Mystrm, Mystrm.Size);
    Myss.Position := 0;
    Myss.Read(ver,1);

    if Ver >= '0' then
      AList.LoadFromFile(AFileName)
    else
    Begin
//      MySS.Position := 0;
      While ReadS4(Val1) AND ReadS4(Val2) AND ReadS4(Val3) AND ReadS4(Val4) do
      Begin
        S := Val3;
        while Length(S) > 250 do
        begin
          AList.Add(val1+Delimiter+Val2+Delimiter+Copy(S, 1, 250)+Delimiter+Val4);
          S := Copy(S, 251, Length(S));
        end;
        AList.Add(val1+Delimiter+Val2+Delimiter+S+Delimiter+Val4);
      end;
    End;
  finally
    FreeAndNil(Mystrm);
    FreeAndNil(Myss);
  end;

end;

function TFileStorage.ReadData(const AFormName, ARecordType: String;
  const AElementID: Integer): String; //20160423 Igor
var
  var1, var2, var3, var4, FormName: String;
begin
  ResetCursor;
  FormName := '';
  Result := '';
  while ReadLine(var1, var2, var3, var4) do
  Begin
    if Var1 = 'F' then
      FormName := Var2
    else
    if (Var1 = ARecordType) AND
       (FormName = AFormName) AND
       (Var2 = intTosTr(AElementID)) then
    Begin
      Result := Var3;
      break;
    End;
  End;
end;

function TFileStorage.ReadLine(var Var1, Var2, Var3, Var4: string): boolean;

  procedure OldRead;
  var
    InputLin: string;
    i, j: integer;
    Ndx: array[1..3] of byte;
  begin
    Readln(F1, InputLin);
    {Break up into variables}
    j := 0;
    for i := 1 to Length(InputLin) do
    begin
      if InputLin[i] = Delimiter then
      begin
        inc(j);
        if (j > 3) or (i > high(byte)) then //20160820 Igor //bad format
        begin
          Var1 := '';
          Var2 := '';
          Var3 := '';
          Var4 := '';
          exit;
        end;
        ndx[j] := i;
      end;
    end;
    Var1 := Copy(InputLin, 1, Ndx[1] - 1);
    Var2 := Copy(InputLin, Ndx[1] + 1, Ndx[2] - Ndx[1] - 1);
    Var3 := Copy(InputLin, Ndx[2] + 1, Ndx[3] - Ndx[2] - 1);
    Var4 := Copy(InputLin, Ndx[3] + 1, 255);
  end;

  procedure ReadS4(var v: string);
  var
    n,i: integer;
    //a:Char;  //20160217 Igor
  begin
//    Result := strm.Read(n, 4) = 4;
    Result := ss.Read(n, 4) = 4; //20160217 Igor
    if Result and (n > 0) then
    begin
      //SetLength(v, n);                                   // rem 20151212 Igor
      //strm.Read(v[1], n);                                // rem 20151212 Igor
      v:='';                                               // add 20151212 Igor
//      for i := 1 to n do begin strm.Read(a, 1);v:=v+a;end; // add 20151212 Igor
      v := ss.ReadString(n); //20160217 Igor
    end
    else
      v := '';
  end;

begin
  // 20151215 Igor
//  if fSQL.strmSql.DataString <> '' then  //20160121 Igor
//  begin
//        Result:= fSQL.ReadS4(Var1); //ReadS1? ReadChar for first argument?
//        if Result then Result:= fSQL.ReadS4(Var2) else Var2:='';
//        if Result then Result:= fSQL.ReadS4(Var3) else Var3:='';
//        if Result then Result:= fSQL.ReadS4(Var4) else Var4:='';
//        exit;
//  end;

  case Version of
    #1:
      begin
        ReadS4(Var1); //ReadS1? ReadChar for first argument?
        if not Result then
          exit; //reached EOF, don't try to read more
        ReadS4(Var2);
        ReadS4(Var3);
        ReadS4(Var4);
      end;
    #0, #2..pred('0'): Result := False; //unhandled file format!
  else //old format
    Result := not eof(F1);
    if Result then
      OldRead;
    //20160820 Igor >>>
    if (Var1 = '') and
       (Var2 = '') and
       (Var3 = '') and
       (Var4 = '') then
      Result := False;
    //20160820 Igor <<<
  end;
end;

procedure TFileStorage.ResetCursor; //20160423 Igor
begin
  if TextFormat then
  Begin
    CloseFile(F1);
    Reset(F1);
  End
  else
  Begin
    ss.Position := 0;
    ss.Read(Version,1);
  End;
end;

procedure TFileStorage.WriteLine(const V1, V2, V3, V4: string);

  procedure WriteS4(const v: string);
  var
    n, i: integer;
    C: AnsiChar; //20160311 Igor
  begin
    n := Length(V);
    strm.Write(n, 4);
    if n > 0 then
    Begin
      //strm.Write(v[1], n);                  // rem 20151212 Igor
      for i := 1 to n do
      Begin
        C := AnsiChar(AnsiString(V)[i]); //20160311 Igor
        strm.Write(C, 1); // add 20151212 Igor //20160311 Igor
      end;
    end;
  end;

var
  s: string;
begin
  if TextFormat then
  begin
    s := v3; //assume: M,Ln,str,''
    while Length(s) > 250 do
    begin
      WriteLn(F1, v1, Delimiter, V2, Delimiter, Copy(s, 1, 250), Delimiter, V4);
      s := Copy(s, 251, Length(s));
    end;
    WriteLn(F1, v1, Delimiter, V2, Delimiter, s, Delimiter, V4)
  end
  else
  begin
    // 20151212 Igor
//    fSQL.WriteS4(V1);   //20160121 Igor
//    fSQL.WriteS4(V2);
//    fSQL.WriteS4(V3);
//    fSQL.WriteS4(V4);

    WriteS4(V1);
    WriteS4(V2);
    WriteS4(V3);
    WriteS4(V4);
  end;
end;

function ReadNextLine(SQLite: TSQLiteStorage; var Var1, Var2, Var3, Var4: String; f: TFileStorage): Boolean; //20160820 Igor
Begin
  if Assigned(SQLite) then
  Begin
    //20161206 Igor >>>
    Result := SQLite.ReadNextLine(Var1, Var2, Var3, Var4);
(*
    Result := not SQLite.QData.Eof;
    if Result then
    Begin
      if (SQLite.QData.FieldByName('FormName').AsString <> 'Z_LINES') and
         not SameText(SQLite.QData.FieldByName('FormName').AsString, PrevFormName) then
      Begin
        Var1 := 'F';
        Var2 := SQLite.QData.FieldByName('FormName').AsString;
        Var3 := '';
        Var4 := '';
        PrevFormName := SQLite.QData.FieldByName('FormName').AsString;
      End
      else
      Begin
        if (SQLite.QData.FieldByName('RecordType').AsString = 'O') or
           (SQLite.QData.FieldByName('RecordType').AsString = 'R') then  //20160419 Igor
        Begin
          Var1 := SQLite.QData.FieldByName('RecordType').AsString;
          Var2 := SQLite.QData.FieldByName('FormName').AsString;
          Var3 := SQLite.QData.FieldByName('ElementID').AsString;
          Var4 := SQLite.QData.FieldByName('Value').AsString;
        End
        else
        begin
          Var1 := SQLite.QData.FieldByName('RecordType').AsString;
          Var2 := SQLite.QData.FieldByName('ElementID').AsString;
          Var3 := SQLite.QData.FieldByName('Value').AsString;
        end;
        SQLite.QData.Next;
      end;
    End;
*)
    //20161206 Igor <<<
  End
  else
    Result := f.ReadLine(Var1, Var2, Var3, Var4)
End;

Procedure BuildExperience(FrmNm: String; FromElm, ToElm, ByElm: Integer;
  FlName: String; SQLite: TSQLiteStorage; f: TFileStorage); overload; //20160820 Igor
var
  Var1, Var2, Var3, Var4: String;
  StartFill: Boolean;
  TempList: TStringList;
Begin
  TempList:=TStringList.Create;
  try
    if FileExists(FlName) then
      TempList.LoadFromFile(FlName);
    StartFill := False;
    if assigned(SQLite) then
//      SQLite.QData.First //20161206 Igor
      SQLite.StartRead     //20161206 Igor
    else
    if assigned(F) then
      F.ResetCursor;
    while ReadNextLine(SQLite, Var1, Var2, Var3, Var4, f) do
    Begin
      if SameText(Var1,'F') AND SameText(Var2, FrmNm) then
        StartFill := true
      else
      if StartFill AND
         (Var1 = 'D') AND
         (StrToInt(Var2) >= FromElm) AND
         (StrToInt(Var2) <= ToElm) AND
         (((StrToInt(Var2) - FromElm) mod ByElm) = 0) then
      Begin
        If (Var3 > '') and
           (TempList.IndexOf(Var3) = -1) and
           (Var3 <> '"') then
          TempList.Add(Var3);
      End
      else
      if StartFill AND
         ((Var1 = 'F') or
          ((Var1 = 'D') AND
           (StrToInt(Var2) >= ToElm))) then
       break;
    End;
    If SameText(ExtractFileName(FlName), 'FIRSTNM.txt') then
      TempList.Text := UpperCase(TempList.Text);
    TempList.Sorted:=True;
    TempList.SaveToFile(FlName);
  finally
    freeAndNil(TempList);
  end;
End;

{ TDataModel }

constructor TDataModel.Create;
begin
  Inherited Create;
  Self.OwnsObjects := True;
  SetToStart;
end;

destructor TDataModel.Destroy;
begin
  Reset;
  inherited;
end;

function TDataModel.GetValue(const AFormName, ARecordType: String;
  const AElementID: Integer): String;
var
  C: TDataAtom;
begin
  for C in Self do
  begin
    if (C.FormName = AFormName) and (C.RecordType = ARecordType) AND (C.ElementID = IntToSTr(AElementId)) then
    begin
      Result := C.Value;
      exit;
    end;
  end;
  result := '';
end;

function TDataModel.ReadNextLine(var var1, var2, var3,
  var4: String): Boolean;
begin
  Result := FItemIndex < Self.Count;
  if Result then
  Begin
    if (Items[FItemIndex].FormName <> 'Z_LINES') and
       not SameText(Items[FItemIndex].FormName, FLastReadForm) then
    Begin
      Var1 := 'F';
      Var2 := Items[FItemIndex].FormName;
      Var3 := '';
      Var4 := '';
      FLastReadForm := Items[FItemIndex].FormName;
    End
    else
    Begin
      if (Items[FItemIndex].RecordType = 'O') or
         (Items[FItemIndex].RecordType = 'R') then
      Begin
        Var1 := Items[FItemIndex].RecordType;
        Var2 := Items[FItemIndex].FormName;
        Var3 := Items[FItemIndex].ElementID;
        Var4 := Items[FItemIndex].Value;
      End
      else
      begin
        Var1 := Items[FItemIndex].RecordType;
        Var2 := Items[FItemIndex].ElementID;
        Var3 := Items[FItemIndex].Value;
        Var4 := '';
      end;
      inc(FItemIndex);
    end;
  End;
end;

procedure TDataModel.Reset;
begin
  Self.Clear;
  SetToStart;
end;

procedure TDataModel.SetToStart;
begin
  FItemIndex := 0;
  FLastReadForm := '';
end;

{ TDataAtom }

constructor TDataAtom.Create(const AFormName, AElementID, ARecordType,
  AValue: String);
begin
  inherited Create;
  FFormName := AFormName;
  FElementID := AElementID;
  FRecordType := ARecordType;
  FValue := AValue;
end;

end.

