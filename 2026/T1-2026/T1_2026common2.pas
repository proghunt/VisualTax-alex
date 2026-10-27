unit T1_2026Common2;
//converted 07-21

{=============================================================}
interface
{=============================================================}
uses SysUtils,{$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON},WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,
 vtFileStorage, vtMulti; //20160819 Igor //20200914 Igor


Function GetCRABal(FlName:String):String;  //20251230
procedure CreatetheREFILEVform(RetNo:Integer);  //20170322
Function OpenReturn(DataDir,FlName: string;ShowSw:Boolean; AIsAppendix: Boolean = False;
  AConvert: Boolean = False; SkipUnlock: boolean = false): Integer; //20160305 Igor //20190605 Igor
function OpenReturnCoupled(DirName,FlName: string; fShow: boolean; SkipUnlock: boolean = false): integer; //20171130 Igor //20190605 Igor
Procedure ConvertT5ToMult(RetNo:Integer);
procedure CreatetheT1ADJform(RetNo:Integer);

Function UpdateFPAssist(RetNo: integer; DataDir: string;FlName:string):Integer;
Procedure GetStatusFromDB(DataDir:string;FlName:string;Var EfSt:string;Var PrepSt:string;Var CreateDate:String);
Procedure InitStatusForm(RetNo:Integer; FNo:Integer);
Function HasDataN(RetNo:integer; FNo:Integer; elm:integer):boolean;
Function HasDataS(RetNo:integer; FNo:Integer; elm:integer):Boolean;
Function IsRetInMemory(Sin:string):Integer;
Function CopyAForm(FromRetNo: integer;FromFormName: string;ToRetNo: integer;ToFormName: string):Integer;
Procedure MoveForm(FromRetNo: integer;FromFormName: string;ToRetNo: integer;ToFormName:String);
Procedure ClearForm(RetNo:integer;FName:string);
function GetFirstInstIndex(FormNo: integer):Integer;
function GetHighestFormNo:Integer;
Function AddOtherPagesInstance(RetNo: integer; NonInstFormName:String;FormInst:String):boolean;
Function AddPageInstance(RetNo: integer; NonInstFormName,FormInst: string): integer;

Function ReadReturn(DataDir,FlName: string; AIsAppendix: Boolean = False;
  AConvert: Boolean = False):integer; //20160302 Igor //20160329 Igor
Function SaveReturn(RetNo : integer; DataDir: string;FlName: string;OverrideSw:Boolean;UpdMostRecent:Boolean;
  ATextFormat: Boolean = False; AUpdateClientTable: Boolean = True; AClouds: TArrayOfInteger = nil):integer;//20160121 Igor //20161208 Igor

  Function UpdateClientsTable(RetNo: integer; DataDir: string;FlName:string):Integer;
Procedure CloseUnusedForms(RetNo: integer);

//20170315 Igor >>>
procedure StartSilentRead;
procedure EndSilentRead;
//20170315 Igor <<<

procedure BringSlipDataFromT4T5APP(ASIN: integer; ASlipType: string); //20180223 Igor
function IsCloudStorageEnabled : boolean; //20190507 Igor
function ReturnsCountInDb: integer; //20210202 Igor

implementation

uses {,vtFileStorage}vtCommon,vtMain,vtDialogs,T1_2026,T1_2026TrimStr, //20160819 Igor //20200914 Igor
  T1_2026Declare,T1_2026T1Rtns,T1_2026T1Rtns2,T1_2026Logging,T1_2026Cpl,
  T1_2026Common,T1_2026Calc,T1_2026Calc4,T1_2026childwinNEW,T1_2026Main,
  vtTrimStr, vtShared, vtDataBase,
  uADCompClient, // 20150823 igor
  vtHelperManager, //20161208 Igor
  vtChild, //20170130 Igor
  vtLockManager, //20170307 Igor
  System.IOUtils, System.Types; //20180223 Igor

var
  SilentRead: Boolean = False;  //20170307 Igor

function ReturnsCountInDb: integer; //20210202 Igor
var Conn: TADConnection;
    Q: TADQuery;
begin
  Result := 0;
  if TFile.Exists(TPath.Combine(OptRec.Dir_Cur, AppT1_2026.ClientsDBLite)) then
  begin
    Conn := TADConnection.Create(Nil);
    Q := TADQuery.Create(Nil);
    try
      Conn.LoginPrompt := false;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] :=
        TPath.Combine(OptRec.Dir_Cur, AppT1_2026.ClientsDBLite);
      Conn.Params.Values['Password'] :=
        Pswd(GC_SQLLitePasswordVersion, false);

      try
        Conn.Connected := True;
      except
        Conn.Params.Values['Password'] := '';
        Conn.Connected := True;
      end;
      if not Conn.Connected then Exit;
      Q.Connection := Conn;
      Q.SQL.Text := 'SELECT COUNT(*) AS TotalCount FROM Clients';
      Q.Open;
      Result := Q.FieldByName('TotalCount').AsInteger;
    finally
      Q.Free;
      Conn.Free;
    end;
  end;
end;

procedure BringSlipDataFromT4T5APP(ASIN: integer; ASlipType: string); //20180223 Igor
// Import T4, T4A, T5 slip

const MapFile = 'MapT4T5.d';

type TMapStage = (msDirectMap, msBoxAndAmount, msBoxToID);

type TDirectMapRecord = record
  ToElm: integer;
  ToElms: TArray<integer>;
  FromElm: integer;
  Value: string;
  ElmOverride: integer;
end;

type TBoxAndAmountMapRecord = record
  Box: integer;
  Amount: integer;
end;

type TBoxToIDMapRecord = record
  Box: integer;
  ID: integer;
  IDs: TArray<integer>;
  ElmOverride: integer;
end;

var FApp: TApp;
    FileList: TStringDynArray;
    i, j: integer;
    FRetNo, FFormNo: integer;
    T4T5RetNo: integer;
    F: TFRecArray;
    R: TFRec;
    cFile, FValue, AT1Form: string;
    arrDirectMap: array of TDirectMapRecord;
    arrBoxAndAmountMap: array of TBoxAndAmountMapRecord;
    arrBoxToIDMap: array of TBoxToIDMapRecord;
    FDMap: TDirectMapRecord;
    FBAMap: TBoxAndAmountMapRecord;
    FBIMap: TBoxToIDMapRecord;
    ASinIndex, ASlipNo: integer;
    ToElmIndex: integer;
    nBoxValue: integer;

  procedure InitMap;
  {
    init mappings for import data
    MapT4T5.d contains three section:
    - section with direct map "index in T1 form - index in T4T5 form"
    - section with index for box and amount entry in T4T5 form
    - section with relation of box number to index in T1 form

    T5 form in T1 is multi form so all indices presented as 5 number separated by coma
  }
  var SL: TStringList;
      A, arr: TArray<string>;
      arrElms1, arrElms2: TArray<integer>;
      S, cValue, cElm: string;
      Elm1, Elm2, ElmOverride: integer;
      AStage: TMapStage;
      cMapFile: string;
  begin
    cMapFile := TPath.Combine(AppDir, MapFile);
    if not FileExists(cMapFile) then
    begin
      ShowMessage('There is no file '+ cMapFile);
      Exit;
    end;
    SL := TStringList.Create;
    try
      SL.LoadFromFile(cMapFile);
      AStage := msDirectMap;
      for S in SL do
      begin
        if AllTrim(S) = '' then continue;
        if S.StartsWith('//') then continue;
        // section detection
        if S.StartsWith('BOX_AND_AMOUNTS') then
        begin
          AStage := msBoxAndAmount;
          continue;
        end
        else if S.StartsWith('BOX_TO_ID') then
        begin
          AStage := msBoxToID;
          continue;
        end;

        SetLength(arrElms1, 0);
        SetLength(arrElms2, 0);
        A := ReplaceStr(S, #9, ' ').Split([' '], ExcludeEmpty);
        if Length(A) >= 3 then
        begin
          if A[0] = ASlipType then
          begin
            // parsing second element
            cValue := '';
            arr := A[1].Split([','], ExcludeEmpty);
            if Length(arr) = 1 then
              Elm1 := StrToIntDef(arr[0], -1)
            else
            begin
              Elm1 := -2;
              for cElm in arr do
              begin
                SetLength(arrElms1, Length(arrElms1) + 1);
                arrElms1[Length(arrElms1) - 1] := StrToIntDef(cElm, -1);
              end;
            end;

            // parsing third element
            if A[2].StartsWith('#') then
            begin
              Elm2 := -1;
              cValue := Copy(A[2], 2, Length(A[2]));
            end
            else
            begin
              arr := A[2].Split([','], ExcludeEmpty);
              if Length(arr) = 1 then
                Elm2 := StrToIntDef(arr[0], -1)
              else
              begin
                Elm2 := -2;
                for cElm in arr do
                begin
                  SetLength(arrElms2, Length(arrElms2) + 1);
                  arrElms2[Length(arrElms2) - 1] := StrToIntDef(cElm, -1);
                end;
              end;
            end;

            // parsing override index
            ElmOverride := -1;
            if (Length(A) >= 4) and (A[3] <> '_') then
              ElmOverride := StrToIntDef(A[3], -1);

            // save data to corresponding array
            if (A[0] <> '') and (Elm1 <> -1) and ((Elm2 <> -1) or (cValue <> '')) then
            begin
              if AStage = msDirectMap then
              begin
                SetLength(arrDirectMap, Length(arrDirectMap) + 1);
                arrDirectMap[Length(arrDirectMap) - 1].ToElm := Elm1;
                arrDirectMap[Length(arrDirectMap) - 1].ToElms := Copy(arrElms1, 0, MaxInt);
                arrDirectMap[Length(arrDirectMap) - 1].FromElm := Elm2;
                arrDirectMap[Length(arrDirectMap) - 1].Value := cValue;
                arrDirectMap[Length(arrDirectMap) - 1].ElmOverride := ElmOverride;
              end
              else if AStage = msBoxAndAmount then
              begin
                SetLength(arrBoxAndAmountMap, Length(arrBoxAndAmountMap) + 1);
                arrBoxAndAmountMap[Length(arrBoxAndAmountMap) - 1].Box := Elm1;
                arrBoxAndAmountMap[Length(arrBoxAndAmountMap) - 1].Amount := Elm2;
              end
              else if AStage = msBoxToID then
              begin
                SetLength(arrBoxToIDMap, Length(arrBoxToIDMap) + 1);
                arrBoxToIDMap[Length(arrBoxToIDMap) - 1].Box := Elm1;
                arrBoxToIDMap[Length(arrBoxToIDMap) - 1].ID := Elm2;
                arrBoxToIDMap[Length(arrBoxToIDMap) - 1].IDs := Copy(arrElms2, 0, MaxInt);
                arrBoxToIDMap[Length(arrBoxToIDMap) - 1].ElmOverride := ElmOverride;
              end;
            end;
          end;
        end;
      end;
    finally
      SL.Free;
    end;
  end;

  function GetEmptySlotForT5(ARetNo, AFormNo: integer): integer;
  // look for empty slot in multi form
  begin
    if FetchElmFNo(ARetNo, AFormNo, 131) = '' then
      Result := 0
    else if FetchElmFNo(ARetNo, AFormNo, 132) = '' then
      Result := 1
    else if FetchElmFNo(ARetNo, AFormNo, 133) = '' then
      Result := 2
    else if FetchElmFNo(ARetNo, AFormNo, 134) = '' then
      Result := 3
    else if FetchElmFNo(ARetNo, AFormNo, 135) = '' then
      Result := 4
    else
      Result := -1;
  end;

  function GetNewFormNo(ARetNo: integer; AFormName: string): integer;
  // create new or get existing form no with empty slot
  var I: integer;
      FRec: TFRec;
  begin
    Result := 0;
    if AFormName <> 'T5MULT' then
      Result := AddNewInstance(ARetNo, AFormName)
    else
    begin
      for I := 0 to (FList.Count - 1) do
      begin
        FRec := FList.Items[I];
        if AFormName = Frec.FormName then
        begin
          if GetEmptySlotForT5(ARetNo, FRec.FormNo) >= 0 then
          begin
            Result := FRec.FormNo;
            Exit;
          end;
        end;
      end;
      if Result = 0 then
        Result := AddNewInstance(ARetNo, AFormName);
    end;
  end;

begin
  FRetNo := GetCurrentRetNo;
  if FRetNo = 0 then
  begin
    ShowMessage('Open return before importing data');
    Exit;
  end;
  FApp := AppList.AppFromName('T4T5');
  if not Assigned(FApp) then Exit;
  InitMap;

  // search for returns in T4T5 Dir_Cur
  FileList := TDirectory.GetFiles(FApp.Dir_Cur);
  for cFile in FileList do
  begin
    try
      T4T5RetNo := FApp.OpenReturn(FApp.Dir_Cur, TPath.GetFileName(cFile), False, False);
    except on E: Exception do
      continue;
    end;
    if T4T5RetNo <= 0 then
      continue;
    try
      AT1Form := ASlipType;
      // index to SIN
      if ASlipType = 'T4' then
        ASinIndex := 7
      else if ASlipType = 'T4A' then
        ASinIndex := 4
      else if ASlipType = 'T5' then
      begin
        ASinIndex := 11;
        AT1Form := 'T5MULT';
      end
      else
      begin
        ShowMessage('Importing data from ' + ASlipType + ' is not implemented');
        Exit;
      end;

      F := RetList[T4T5RetNo].FList.GetAllInstForms(ASlipType);
      for R in F do
      begin
        if not RetList[T4T5RetNo].FrmHasData[R.FormNo] then
          continue;
        if not SameText(AddLeadingZeros(IntToStr(ASIN), 9), AllTrim(FetchElmFNo(T4T5RetNo, R.FormNo, ASinIndex))) then
          continue;
        FFormNo := GetNewFormNo(FRetNo, AT1Form);
        if ASlipType = 'T5' then
          ASlipNo := GetEmptySlotForT5(FRetNo, FFormNo);
        // direct map
        for FDMap in arrDirectMap do
        begin
          if ASlipType = 'T5' then
          begin
            if FDMap.ToElm = -2 then
              ToElmIndex := FDMap.ToElms[ASlipNo]
            else
              ToElmIndex := FDMap.ToElm;
          end
          else
            ToElmIndex := FDMap.ToElm;

          if FDMap.FromElm <> -1 then
            FValue := FetchElm(T4T5RetNo, R.FormNo, FDMap.FromElm)
          else
            FValue := FDMap.Value;

          if FDMap.ElmOverride <> -1 then
            StoreElm(FRetNo, FFormNo, FDMap.ElmOverride, 'Y');
          StoreElm(FRetNo, FFormNo, ToElmIndex, FValue);
        end;
        // box and amounts section
        for FBAMap in arrBoxAndAmountMap do
        begin
          nBoxValue := StrToIntDef(FetchElm(T4T5RetNo, R.FormNo, FBAMap.Box), -1);
          for FBIMap in arrBoxToIDMap do
            if FBIMap.Box = nBoxValue then
            begin
              if FBIMap.ElmOverride <> -1 then
                StoreElm(FRetNo, FFormNo, FBIMap.ElmOverride, 'Y');
              if FBIMap.ID = -2 then
                ToElmIndex := FBIMap.IDs[ASlipNo]
              else
                ToElmIndex := FBIMap.ID;

              StoreElm(FRetNo, FFormNo, ToElmIndex, FetchElm(T4T5RetNo, R.FormNo, FBAMap.Amount));
            end;
        end;
        RetList[FRetNo].FrmHasData[FFormNo] := true;
        CalcNo(FRetNo, FFormNo);
        OpenForm(FRetNo, FFormNo, 0);
      end;

    finally
      RetList[T4T5RetNo].Close(true);
    end;
  end;
end;

//20170315 Igor >>>
procedure StartSilentRead;
begin
  SilentRead := True;
end;

procedure EndSilentRead;
begin
  SilentRead := False;
end;
//20170315 Igor <<<

Function HasDataN(RetNo:integer; FNo:Integer; elm:integer):boolean;
Begin
 If Vl(FetchElmFNo(RetNo,Fno,elm)) <> 0 then Result := True else Result := False;
end;

Function HasDataS(RetNo:integer; FNo:Integer; elm:integer):Boolean;
Begin
 If FetchElmFNo(RetNo,Fno,elm) > '' then result := True else Result := false;
end;


Function IsRetInMemory(Sin:string):Integer;
var
i : integer;
begin
  Result := 0;
  for i :=1 to (RetList.Count - 1) do
  begin
   RetRec := RetList.Items[i]; if RetRec = nil then continue;
   if FetchElm(RetRec.RetNo,'INFO',3) = Sin then
     begin Result := RetRec.RetNo;exit;end;
  end;
end;

Procedure CloseUnusedForms(RetNo: integer);
var
i: Integer;
WinList : TStringList;
begin
end;

function GetFirstInstIndex(FormNo: integer):Integer;
var
i: Integer;
begin
   Result := 0;  {FormNo;}  {the old forno in case it does not find it}
  { FormName := UpperCase(FormName);}
   for i :=0 to (FList.Count - 1) do
   begin
        FRec := FList.Items[i];
        if FRec.FormNo = FormNo then
          begin Result := i; exit; end;
   end;
end;


function GetHighestFormNo:Integer;
var
i: Integer;
begin
   Result := 0;
   for i :=0 to (FList.Count - 1) do
   begin
        FRec := FList.Items[i];
        if FRec.FormNo > Result then Result := FRec.FormNo;
   end;
end;

Function AddOtherPagesInstance(RetNo: integer; NonInstFormName:String;FormInst:String):boolean;
Var I:integer;
begin
  Result := False;

  If NonInstFormName = 'T1M' then
  begin
   AddPageInstance(RetNo, 'T1M',FormInst);
  end;
end;

Function AddPageInstance(RetNo: integer; NonInstFormName,FormInst: string): integer;
begin
  if RetList[RetNo].isLastYearReturn or
     RetList[RetNo].isAppendix then
    Result := FLastYearList.AddPageInstance(RetNo, NonInstFormName,FormInst)
  else
    Result := FList.AddPageInstance(RetNo, NonInstFormName,FormInst);
end;


Procedure InitStatusForm(RetNo:Integer; FNo:Integer);
begin
  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[4] := '00';  {prpstatus}
   {created}
   Strings[5] := User.UserName; //20170112 Igor
   Strings[6] := DateToStr(Date);
   Strings[7] := TimeToStr(Time); {created}
   {last update}
   Strings[11] := User.UserName; //20170112 Igor
   Strings[12] := DateToStr(Date);
   Strings[13] := TimeToStr(Time);
   //created
   If Strings[5]='' then strings[5]:=Strings[11];
   If Strings[6]='' then strings[6]:=Strings[12];
   If Strings[7]='' then strings[7]:=Strings[13];
   {Efile}
   Strings[15] := '00';
  end;
end;

Function UpdateClientsTable(RetNo: integer; DataDir: string;
  FlName:string):Integer;
{input parms are taken from Save As.. screen}
//20170606 Igor >>>
var
  FDConnection: TADConnection;
  Q: TADQuery;
  FNo :Integer;
const
  c_SQLSaveCClientTable: String =
    'SELECT * FROM `' + ClientsTableLite + '` WHERE FILE_NAME = :FILE_NAME';

  function MapValue(AFormName: String; AElements: Array of Integer;
    AValues: Array of Variant; AElseValue: Variant): Variant;
  var
    I: Integer;
  begin
    Assert(length(AElements) = Length(AValues));
    Assert(not AFormName.IsEmpty);
    for I := Low(AElements) to High(AElements) do
      if not FetchElm(RetNo, AFormName, AElements[I]).IsEmpty then
        exit(AValues[I]);
    Result := AElseValue;
  end;
  function IfNotEmpty(AFormName: String; AElements: Array of Integer;
    AValue, AElseValue: Variant): Variant;
  var
    I: Integer;
  begin
    Assert(not AFormName.IsEmpty);
    for I := Low(AElements) to High(AElements) do
      if not FetchElm(RetNo, AFormName, AElements[I]).IsEmpty then
        exit(AValue);
    Result := AElseValue;
  end;
  function IfThen(ACondition: Boolean; AValueTrue, AValueFalse: Variant): Variant;
  begin
    if ACondition then
      Result := AValueTrue
    else
      Result := AValueFalse;
  end;
begin
  if not fileexists(DataDir + '\' + ClientsDbLite) then
  Begin
    ErrorMsg('Client database "'+DataDir + '\' + ClientsDbLite+'" not found.'+#13+
            'Operation aborted!');
    exit(-1);
  End;
  FNo :=GetFormNo('STATUS'); {to preserve status data}
  If Ret[RetNo].Frm[Fno].Count =0 then
    InitFormData(RetNo,FNo);
  {Update Data Base}
  FDConnection := TADConnection.Create(nil);
  try
    if not SetConnection(FDConnection, IncludeTrailingPathDelimiter(DataDir) + ClientsDbLite,
                        ClientsTableLite) then
      exit(-1);
    Q := TADQuery.Create(nil);
    try
      Q.Connection := FDConnection;
      Q.SQL.Text := c_SQLSaveCClientTable;
      Q.ParamByName('FILE_NAME').AsString := UpperCase(FlName);
      Q.UpdateOptions.UpdateTableName := ClientsTableLite;
      Q.UpdateOptions.KeyFields := 'FILE_NAME';
      try
        Q.Open;
        if Q.IsEmpty then
        Begin
          Q.Append;
          Q.FieldByName('FILE_NAME').AsString  := UpperCase(FlName);
          Q.FieldByName('CREATED_DT').AsString := FetchElm(RetNo, 'STATUS', 6);
          Q.FieldByName('CREATED_BY').AsString := FetchElm(RetNo, 'STATUS', 5);
          Q.FieldByName('CREATED_TM').AsString := FetchElm(RetNo, 'STATUS', 7);
        end
        else
        begin
          Q.Edit;
          Q.FieldByName('UPDATED_BY').AsString := FetchElm(RetNo, 'STATUS', 11);
          Q.FieldByName('UPDATED_DT').AsString := FetchElm(RetNo, 'STATUS', 12);
          Q.FieldByName('UPDATED_TM').AsString := FetchElm(RetNo, 'STATUS', 13);
        end;
        Q.FieldByName('LAST_NAME').AsString  := Uppercase(GetLastName(RetNo));
        Q.FieldByName('FIRST_NAME').AsString := GetFirstName(RetNo);
        Q.FieldByName('MARSTATUS').AsInteger := Ret[RetNo].MarStatus;
        Q.FieldByName('BIRTHDATE').AsString  := FetchElm(RetNo, 'INFO', 9);
        Q.FieldByName('SIN').AsString        := GetSinNo(RetNo);
        Q.FieldByName('PAY_INVNO').AsString  := FetchElm(RetNo, 'INVOICE', 210);
        {
        Q.FieldByName('PAY_TYPE').AsString   := MapValue('INVOICE',
        [223,       224,     225,    271,      282],
        ['Cash', 'Cheque', 'Visa', 'Charge', 'Debit'], '');
        }

        //20210228
        Q.FieldByName('PAY_TYPE').AsString   := MapValue('INVOICE',
        [289,           223,    224,      225,         282,         271,      286],
        ['eTransfer', 'Cash', 'Cheque', 'CreditCard', 'DebitCard', 'Charge', 'Joint'],'');


        Q.FieldByName('INV_AMOUNT').AsFloat  := vl(FetchElm(RetNo, 'INVOICE', 222));
        Q.FieldByName('PAY_AMOUNT').AsFloat  := IfNotEmpty('INVOICE', [223, 224, 225],
                                                                      vl(FetchElm(RetNo,'INVOICE',222)), 0);
        Q.FieldByName('PAY_DT').AsString     := FetchElm(RetNo, 'INVOICE', 209);
        Q.FieldByName('STREET').AsString     := FetchElm(RetNo, 'INFO', 6);
        Q.FieldByName('APARTMENT').AsString  := FetchElm(RetNo, 'INFO', 22);
        Q.FieldByName('CITY').AsString       := FetchElm(RetNo, 'INFO', 10);
        Q.FieldByName('PROVINCE').AsString   := FetchElm(RetNo, 'INFO', 14);

        Q.FieldByName('POSTAL').AsString     := FetchElm(RetNo, 'INFO', 15);
        Q.FieldByName('AREA').AsString       := GetAreaCode(RetNo);
        Q.FieldByName('PHONE').AsString      := GetPhoneNo(RetNo);
        Q.FieldByName('FAXAREA').AsString    := FetchElm(RetNo, 'INFO', 62);
        Q.FieldByName('FAX').AsString        := GetFaxNo(RetNo);


        Q.FieldByName('PRINTED_BY').AsString := FetchElm(RetNo, 'STATUS', 8);
        Q.FieldByName('PRINTED_DT').AsString := FetchElm(RetNo, 'STATUS', 9);
        Q.FieldByName('PRINTED_TM').AsString := FetchElm(RetNo, 'STATUS', 10);

        Q.FieldByName('PRP_STATUS').AsString := FetchElm(RetNo, 'STATUS', 4);
        Q.FieldByName('EF_STATUS').AsString  := FetchElm(RetNo, 'STATUS', 15);
        Q.FieldByName('CATEGORY').AsString   := FetchElm(RetNo, 'STATUS', 33);

        Q.FieldByName('RTUSENT_BY').AsString := FetchElm(RetNo, 'STATUS', 18);
        Q.FieldByName('RTUSENT_DT').AsString := FetchElm(RetNo, 'STATUS', 19);
        Q.FieldByName('RTUSENT_TM').AsString := FetchElm(RetNo, 'STATUS', 20);

        Q.FieldByName('ACKRCVD_BY').AsString := FetchElm(RetNo, 'STATUS', 21);
        Q.FieldByName('ACKRCVD_DT').AsString := FetchElm(RetNo, 'STATUS', 22);
        Q.FieldByName('ACKRCVD_TM').AsString := FetchElm(RetNo, 'STATUS', 23);

        Q.FieldByName('NOTES').AsString      := FetchElm(RetNo, 'STATUS', 14);

        Q.FieldByName('DISCOUNTED').AsString := IfNotEmpty('INFO', [102], 'Y', 'N');
        Q.FieldByName('FAMILYHEAD').AsString := FetchElm(RetNo, 'INFO', 37);
        Q.FieldByName('DUE_DT').AsString     := FetchElm(RetNo, 'INFO', 124);
        Q.FieldByName('CLIENT_ID').AsString  := FetchElm(RetNo, 'INFO', 67);
        Q.FieldByName('TITLE').AsString      := FetchElm(RetNo, 'INFO', 33);
        Q.FieldByName('EMAIL').AsString      := FetchElm(RetNo, 'INFO', 64);
        Q.FieldByName('EMAIL2').AsString     := FetchElm(RetNo, 'INFO', 140);    //20180311
        Q.FieldByName('TAXPROV').AsString    := GetShortPrv(FetchElm(RetNo,'INFO',1));
        Q.FieldByName('GENDER').AsString     := IfThen(FetchElm(RetNo, 'INFO', 108) = 'M', 'M', 'F');

        if Assigned(Q.FindField('CRABAL')) then //20251219 Igor
          Q.FieldByName('CRABAL').AsFloat:= vl(FetchElm(RetNo, 'INFO', 300)); //20251219 Igor


         {
        //20210801
        If (FetchElm(RetNo, 'AUTHREP#1', 11)>'') or (FetchElm(RetNo, 'AUTHREP#1', 39)>'')
        then
          Q.FieldByName('T1013OL').AsString    := 'Y'
         Else
          Q.FieldByName('T1013OL').AsString    := 'N';
        }



{TODO: check not saved fields}
//      DCN_NO,
//      AUTOFILLED,
//      T1013OL,  //done in 20210801
//      COUNTRY,
//      EF_ELGBL,
//      RTUFILE,
//      ACKFILE,
//      COMPL_BY,
//      COMPL_DT,
//      COMPL_TM,
//      EMAIL2,

        Q.Post;
        Result := 0;
      except ON E: Exception DO
        begin
          Result := -1;
          MessageDlg(E.Message, mtError, [mbOk], 0);
        end;
      end;
    finally
      Q.Free;
    end;
  finally
    FDConnection.Free;
  end;
(*
  if not SetTableName(FDConnection, Table1,DataDir + '\' + ClientsDbLite,
                      ClientsTableLite, UpperCase('File_Name')) then
  Begin
    if assigned(FDConnection) then
      FreeAndNil(FDConnection);
    if assigned(Table1) then
      FreeAndNil(Table1);
    result := -1;
    exit;
  End;

//
//  FDConnection := TADConnection.Create(nil);
//  FDConnection.DriverName := 'SQLite';
//  Table1 := TADTable.Create(nil);
//  Table1.Connection := FDConnection;
//  try
//    FDConnection.Params.Values['DataBase'] := DataDir + '\' + ClientsDbLite;
//    Table1.TableName := ClientsTableLite;
//    Table1.IndexName := UpperCase('File_Name'); // 20150920 Igor
//    Table1.Open;
  Table1.Close;
//  Except
//   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
//  end;
  //20160226 Igor <<<<<
  if Table1.State = dsInactive then
   begin
    TRY     //20090301
     Table1.Open;
     if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then //20170210 Igor
       Table1.edit
     else
       Table1.Insert;

     Table1.FieldByName('Last_Name').AsString := Uppercase(GetLastName(RetNo));
       //does not help +','+Table1.FieldByName('First_Name').AsString;
     Table1.FieldByName('First_Name').AsString := GetFirstName(RetNo);
     Table1.FieldByName('File_Name').AsString := UpperCase(FlName);

     Table1.FieldByName('MarStatus').AsInteger := Ret[RetNo].MarStatus;

     Table1.FieldByName('BirthDate').AsString := FetchElm(RetNo,'INFO',9);
     Table1.FieldByName('SIN').AsString := GetSinNo(RetNo);

     Table1.FieldByName('Pay_InvNo').AsString := FetchElm(RetNo,'INVOICE',210);

     Table1.FieldByName('Pay_Type').AsString := '';
     If FetchElm(RetNo,'INVOICE',223) > '' then
        Table1.FieldByName('Pay_Type').AsString := 'Cash'
     else If FetchElm(RetNo,'INVOICE',224) > '' then
           Table1.FieldByName('Pay_Type').AsString := 'Cheque'
     else If FetchElm(RetNo,'INVOICE',225) > '' then
           Table1.FieldByName('Pay_Type').AsString := 'Visa'
     else If FetchElm(RetNo,'INVOICE',271) > '' then
           Table1.FieldByName('Pay_Type').AsString := 'Charge'
     else If FetchElm(RetNo,'INVOICE',282) > '' then
           Table1.FieldByName('Pay_Type').AsString := 'Debit';

     Table1.FieldByName('Inv_Amount').AsFloat :=
       vl(FetchElm(RetNo,'INVOICE',222));

     If (FetchElm(RetNo,'INVOICE',223) > '') or
      (FetchElm(RetNo,'INVOICE',224) > '') or
     (FetchElm(RetNo,'INVOICE',225) > '')  then
     Table1.FieldByName('Pay_Amount').AsFloat :=
       vl(FetchElm(RetNo,'INVOICE',222))
     Else
      Table1.FieldByName('Pay_Amount').AsFloat := 0;
     Table1.FieldByName('Street').AsString := FetchElm(RetNo,'INFO',6);
     Table1.FieldByName('Apartment').AsString := FetchElm(RetNo,'INFO',22);
     Table1.FieldByName('City').AsString := FetchElm(RetNo,'INFO',10);
     Table1.FieldByName('Province').AsString :=
       FetchElm(RetNo,'INFO',14); {from long to short}
       {GetShortPrv(FetchElm(RetNo,'INFO',14));} {from long to short}

     Table1.FieldByName('Postal').AsString := FetchElm(RetNo,'INFO',15);
     Table1.FieldByName('Area').AsString := GetAreaCode(RetNo);
     Table1.FieldByName('Phone').AsString := GetPhoneNo(RetNo);
     Table1.FieldByName('Fax').AsString := GetFaxNo(RetNo);
     //try    20090301
     Table1.FieldByName('Updated_by').AsString := FetchElm(RetNo,'STATUS',11);
     Table1.FieldByName('Updated_dt').AsString := FetchElm(RetNo,'STATUS',12);
     Table1.FieldByName('Updated_tm').AsString := FetchElm(RetNo,'STATUS',13);

     Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
     Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
     Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);

     Table1.FieldByName('Pay_Dt').AsString := FetchElm(RetNo,'INVOICE',209);
     Table1.FieldByName('PRP_Status').AsString := FetchElm(RetNo,'STATUS',4);
     Table1.FieldByName('EF_Status').AsString  := FetchElm(RetNo,'STATUS',15);
     Table1.FieldByName('CATEGORY').AsString  := FetchElm(RetNo,'STATUS',33);

     Table1.FieldByName('RTUSENT_by').AsString := FetchElm(RetNo,'STATUS',18);
     Table1.FieldByName('RTUSENT_Dt').AsString := FetchElm(RetNo,'STATUS',19);
     Table1.FieldByName('RTUSENT_Tm').AsString := FetchElm(RetNo,'STATUS',20);

     Table1.FieldByName('ACKRCVD_by').AsString := FetchElm(RetNo,'STATUS',21);
     Table1.FieldByName('ACKRCVD_Dt').AsString := FetchElm(RetNo,'STATUS',22);
     Table1.FieldByName('ACKRCVD_Tm').AsString := FetchElm(RetNo,'STATUS',23);

     Table1.FieldByName('Notes').AsString := FetchElm(RetNo,'STATUS',14);
     If FetchElm(RetNo,'INFO',102) > '' then
      Table1.FieldByName('Discounted').AsString := 'Y'
     else
       Table1.FieldByName('Discounted').AsString := 'N';

     Table1.FieldByName('FAMILYHEAD').AsString := FetchElm(RetNo,'INFO',37);
     Table1.FieldByName('Due_Dt').AsString := FetchElm(RetNo,'INFO',124);
     Table1.FieldByName('CLIENT_ID').AsString := FetchElm(RetNo,'INFO',67);
     Table1.FieldByName('TITLE').AsString := FetchElm(RetNo,'INFO',33);
     Table1.FieldByName('EMAIL').AsString := FetchElm(RetNo,'INFO',64);
     Table1.FieldByName('TAXPROV').AsString := GetShortPrv(FetchElm(RetNo,'INFO',1));


     If FetchElm(RetNo,'INFO',108) ='M' then
       Table1.FieldByName('GENDER').AsString := 'M'
     else
       Table1.FieldByName('GENDER').AsString := 'F';

     Table1.FieldByName('FAXAREA').AsString := FetchElm(RetNo,'INFO',62);

     Table1.FieldByName('Created_dt').AsString := FetchElm(RetNo,'STATUS',6);
     Table1.FieldByName('Created_by').AsString := FetchElm(RetNo,'STATUS',5);
     Table1.FieldByName('Created_tm').AsString := FetchElm(RetNo,'STATUS',7);
     If AllTrim(Table1.FieldByName('Created_By').AsString)='' then
       Table1.FieldByName('Created_by').AsString:=Table1.FieldByName('Updated_by').AsString;
     If AllTrim(Table1.FieldByName('Created_dt').AsString)='' then
       Table1.FieldByName('Created_dt').AsString:=Table1.FieldByName('Updated_Dt').AsString;
     If AllTrim(Table1.FieldByName('Created_Tm').AsString)='' then
       Table1.FieldByName('Created_Tm').AsString:=Table1.FieldByName('Updated_Tm').AsString;

     Table1.Post;
     except
       on E: Exception do MessageDlg('Save failed '+E.Message, mtError, [mbok], 0);
     end;
   end;
   Table1.Free;
   FDConnection.Free;
   Result := 0;
*)
  //20170606 Igor <<<
end;

Function UpdateFPAssist(RetNo: integer; DataDir: string; FlName: string): Integer;
//20170811 Igor>>>
Var
  ADConnection: TADConnection;
  Table1: TADTable;
  Err: String;
begin
  If Not SysUtils.FileExists(IncludeTrailingPathDelimiter(DataDir) + AssistDBLite) then
  begin
    if not CopyDB(AssistDBLite, AppDir, DataDir, Err) then
    begin
      MessageDlg(Err, mtError, [mbOk], 0);
      exit(-1);
    end;
  end;
  Try
    {Update Data Base}
    ADConnection := TADConnection.Create(Application);
    Table1 := TADTable.Create(Application);
    try
      if not SetTableName(ADConnection, Table1, IncludeTrailingPathDelimiter(DataDir) + AssistDBLite, AssistTableLite, 'File_Name') then
        exit(-1);
      if not Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
        Table1.Append
      else
        Table1.Edit;
      Table1.FieldByName('File_Name').AsString := UpperCase(FlName);
      Table1.FieldByName('Services').AsInteger := StrToInt(FetchElm(RetNo, 'FPCHECK', 35));
      Table1.Post;
      Result := 0;
    finally
      Table1.Free;
      ADConnection.Free;
    end;
  except on E: Exception do
    begin
      Result := -1;
      MessageDlg(E.Message, mtError, [mbok], 0);
    end;
  end;
//20170811 Igor<<<
end;


Function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;
  OverrideSw: Boolean; UpdMostRecent: Boolean; ATextFormat: Boolean = False;
  AUpdateClientTable: Boolean = True; AClouds: TArrayOfInteger = nil): Integer; // 20160121 Igor //20161208 Igor
var
  i, j, k, FNo, SNo: Integer;
  S: String;
  SQLite: TSQLiteStorage; //20160415 Igor
  //20161210 Igor >>>
  HelperID: Integer;
  HelperClassName: String;
  CloudPath: String;
  ClientID: String;
  Token: String;
  Valu:String;
  //20161210 Igor <<<
  lm : TLockManager; //20170315 Igor
  isShareAfterSend: Boolean; //20171215 Igor
  //20171224 Igor >>>
  isShareWithPeople: boolean;
  L: TStringList;
  iL: integer;
  InfoFno:Integer;
  DependFNo:Integer;
  Elm:Integer;
  CraBalList:TstringList;
  //20171224 Igor <<<
begin
 // 20241203 If UpperCase(InputBox('T1 Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20241126

  InfoFNo:=GetFormNo('INFO');
  DependFNo:=GetFormNo('DEPEND');
  Result := iorFileType; // -2; //locked

  if myrollover=True then  //20251127
  begin
    unlockReturn(RetNo);  //20251127
    StoreElm(RetNo,getFormNo('STATUS'),4,'00'); //prepstasus
    StoreElm(RetNo,getFormNo('STATUS'),15,'00'); //Efstatus

   //fix birthdates and bus statements
   Valu :=FetchElm(RetNo,InfoFNo,9); StoreElm(RetNo,InfoFNo,9,IncrYear(Valu)); //birthdate
   i:=10;  //birthdates
   Repeat
    Valu :=FetchElm(RetNo,DependFNo,i);
    If Valu>'' then StoreElm(RetNo,DependFNo,i,IncrYear(Valu));
    inc(i,15);
   Until i>130;
  end;

  If FlName = '' then
  begin
   Result := iorFileName; // -2; {?}
   ShowMessage('SIN is required');
   exit;
  end;

  //20170902 Igor>>>
  if AppT1_2026.ExceedsMaxReturnsAllowed(False) then
  begin
    exit;
  //20170902 Igor<<<
  end;

 (*   //20260609
  //20251230   //eyter crabal to the INFO form
  InfoFNo:=GetFormNo('INFO');
  if FetchelmFNo(RetNo,InfoFNo,300)='' then  //no crabal on info
  begin
   if FileExists(AppDir+'\CraBalances.txt')=True then //if the file exists that contains the balances of certification test cases
   begin
    CraBalList:=TStringList.Create;
   // Result:='';
    CraBalList.loadfromFile(AppDir+'\'+'CraBalances.txt');
    for I := 0 to CraBalList.Count - 1 do
    begin
     s:=AllTrim(CraBalList[i]);
     if Length(s)>12 then
     Begin
     if UpperCase(FlName)= Uppercase(AllTrim(LeftStr(s,12))) then
      begin
       StoreElm(RetNo,INFOFNo,300,MidStr(S,16,12));  //cra balance amount as string
      end;
     end;
    end;
   end;
  end;  //no bal in info

  CraBalList.free;

  //Test it   //20251230
  CraBalList:=TStringList.Create;
  CraBalList.loadfromFile(AppDir+'\'+'CraBalances.txt');
  for I := 0 to CraBalList.Count - 1 do
  begin
   s:=AllTrim(CraBalList[i]);
  end;
 //-------------------------
 *)
  If OverrideSw = False then
  begin
    If fileexists(DataDir + '\' + FlName) and not SkipReplaceFileQuestion then //20190701 Igor
    begin
      case MessageDlg('File exists. Override?', mtInformation,
        [mbYes, mbNo, mbCancel], 0) of
        mrNo:
          begin
            Result := -1;
            exit;
          end;
        mrCancel:
          begin
            Result := -3;
            exit;
          end;
      end;
    end;
  end;
  //20170315 Igor >>>
  if Ret[RetNo].LockManager = nil then
  begin
    lm := TLockManager.Create(IncludeTrailingPathDelimiter(DataDir) + FlName, lmCreate);
    if lm.LockMode = lmNoAccess then
    begin
      lm.Free;
      Exit;
    end;
    Ret[RetNo].LockManager := lm;
  end;
  if Ret[RetNo].LockManager.FileChanged then
  begin
    if MessageDlg('The return has been changed by another user since it was opened.' + #13 +
                  'Continue saving (Changes by another user will be lost)?',
                  mtWarning, [mbYes, mbCancel], 0) <> mrYes then
      Exit;
  end;
  //20170315 Igor <<<
  UpdateAllDataIndicators(RetNo);
  UpdateAllIndicatorsForMJ(RetNo); //20190328
  { update data base first }
  Try
    if AUpdateClientTable then // 20160121 Igor
      Result := UpdateClientsTable(RetNo, DataDir, FlName); //20201202 CON
     // Result := UpdateClientsTable(RetNo, DataDir, RetList[RetNo].GetDefaultFileName); //20200914 Igor
  Except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;

  // 20160121 Igor
   //20160415 Igor>>>
  SQLite := TSQLiteStorage.Create(DataDir, FlName, fsWrite, AppT1_2026.SQLLitePassword.PassRFArray);
  if SQLite.LastError <> '' then
  Begin
    ShowMessage(SQLite.LastError);
    SQLite.Free;
    exit;
  End;
   //20160415 Igor

  try
 //20160415 Igor >>>
    if not SQLite.WriteSettings('AppName',AppName) then
    Begin
      MessageDlg(SQLite.LastError,mtError,[mbOk],0);
      exit;
    end;
    if not SQLite.WriteSettings('AppYear',AppYear) then
    Begin
      MessageDlg(SQLite.LastError,mtError,[mbOk],0);
      exit;
    end;
    if not SQLite.WriteSettings('AppRelease',AppRelease) then
    Begin
      MessageDlg(SQLite.LastError,mtError,[mbOk],0);
      exit;
    end;
    if not SQLite.WriteSettings('LastUpdate',FormatDateTime('YYYYMMDD_hhnnss',Now)) then
    Begin
      MessageDlg(SQLite.LastError,mtError,[mbOk],0);
      exit;
    end;
 //20160415 Igor<<<
    { save forms data }
    { General : Var1, Var2     , Var3  , Var4 }
    { Formats : F   , FormName ,       , }
    { Formats : O   , 'OVR ? needed'    ,       , }
    { D   , Elm      , Value , }
    { : S   , SlipName , Index , ? }



    for i := 0 to FList.Count - 1 do
    begin
      FRec := FList.Items[i];
      FNo := FRec.FormNo;
      If FNo > 0 then // 20111211
      Begin
        if (Ret[RetNo].FormHasData[FRec.FormName+Frec.FormInst])   //20160813 CON
        or (FRec.FormName = 'CTB')
        or ((FRec.FormName = 'S6') and (FetchElm(RetNo, 'S6', 66) > ''))  //20190504
        or ((FRec.FormName = 'S6') and (FetchElm(RetNo, 'S6', 68) > ''))
        or ((FRec.FormName = 'S6QC') and (FetchElm(RetNo, 'S6QC', 66) > ''))  //20190504
        or ((FRec.FormName = 'S6QC') and (FetchElm(RetNo, 'S6QC', 68) > '')) //20171205
        then
        begin
          RetList[RetNo].WriteFData(FRec,SQLite); //20160415 Igor
        end;
      end
      { Save some forms/no data for printing but have indicators }
      // FNo :=GetFormNo('T1A');
      else If (FRec.FormName = 'T1A') and
        ((Vl(FetchElmFNo(RetNo, FNo, 49)) <> 0) or
        (Vl(FetchElmFNo(RetNo, FNo, 118)) <> 0) or
        (Vl(FetchElmFNo(RetNo, FNo, 128)) <> 0) or
        (Vl(FetchElmFNo(RetNo, FNo, 138)) <> 0) or
        (Vl(FetchElmFNo(RetNo, FNo, 148)) <> 0)) then
        RetList[RetNo].WriteFData(FRec,SQLite)
      else if (FRec.FormName = 'ON479') and
        ((UpperCase(FetchElm(RetNo, FNo, 42)) = 'N') or
        (UpperCase(FetchElm(RetNo, FNo, 43)) = 'N') or
        (UpperCase(FetchElm(RetNo, FNo, 44)) = 'N')) then
        RetList[RetNo].WriteFData(FRec,SQLite)
      else if (FRec.FormName = 'BC479') and
        ((UpperCase(FetchElm(RetNo, FNo, 19)) = 'N') or
        (UpperCase(FetchElm(RetNo, FNo, 20)) = 'N') or
        (UpperCase(FetchElm(RetNo, FNo, 21)) = 'N')) then
        RetList[RetNo].WriteFData(FRec,SQLite)
      else if (FRec.FormName = 'MB479') and
        ((UpperCase(FetchElm(RetNo, FNo, 50)) = 'N') or
        (UpperCase(FetchElm(RetNo, FNo, 51)) = 'N') or
        (UpperCase(FetchElm(RetNo, FNo, 53)) = 'N')) then
        RetList[RetNo].WriteFData(FRec, SQLite)
    end;
    RetList[RetNo].WriteLnEtc(LnLowBound, LnHighBound, SQLite); //20160415 Igor
    Result := 0; // all done
  finally
    // unlock the file
    SQLite.Free; //20160415 Igor
  end;
  Ret[RetNo].LockManager.UpdateFileAge; //20170315 Igor
  // If Result = 0 then - has been saved!
  Ret[RetNo].Changed := False;
  If LicenseLevel in anyMulti then
    AddRecordToLog(RetNo);
  If UpdMostRecent = True then
  begin
    UpdateMostRecentFiles(RetNo, DataDir, FlName, GetSinNo(RetNo));
  end;

  //20170106  CON  Export Data for BCJ
  //20170112 Igor >>>
  if AllowExportToFile(RetNo) then
    RetList[RetNo].ExportToFile(AppT1_2026.GetExportForms);
  //20170112 Igor <<<
  //20161210 Igor >>> Save To Cloud
  S := '';
  //20171215 Igor>>
  // 201800205 Igor >>>
  { // 20180102 Igor >>>
  isShareAfterSend := False;
  isShareWithPeople := False; //20171224 Igor
  for I := 0 to length(AClouds) - 1 do
  begin
    if (AClouds[I] >= 1000) and (AClouds[I] < 2000) then
      isShareAfterSend := True;
    //20171224 Igor >>>
    if (AClouds[I] >= 2000) then
      isShareWithPeople := True;
    //20171224 Igor <<<
  end;
  } // 20180102 Igor <<<
  //20171215 Igor<<
  //20190222 Igor >>>
  if CheckIsCloud(true) and (Length(AClouds) > 0) then
    ClearExplorerData;
  //20190222 Igor <<<
  for I := 0 to length(AClouds) - 1 do
  begin
    //20171215 Igor>>
    if (AClouds[I] >= 1000) then //20171224 Igor //20180102 Igor
      Continue;
    // 20180102 Igor >>>
    isShareAfterSend := False;
    isShareWithPeople := False;
    for j := i to length(AClouds) - 1 do
    begin
      if (AClouds[j] = 1000 + AClouds[I]) then
        isShareAfterSend := True;
      if (AClouds[j] = 2000 + AClouds[I]) then
        isShareWithPeople := True;
    end;
    // 20180102 Igor <<<
    // 20180205 Igor <<<

    //20171215 Igor<<
    HelperID := AClouds[I];
    HelperClassName := HelperManager.HelperClassList.Keys.ToArray[AClouds[I]].ClassName;
    CloudPath := HelperManager.Config(HelperClassName, AppT1_2026.AppId, User.UserName).Path; //20170112 Igor
    ClientID := HelperManager.Config(HelperClassName).ClientID;
    Token := HelperManager.Config(AClouds[I], AppT1_2026.AppId, User.UserName).Token; //20170112 Igor
    if HelperManager.Send(AClouds[I],
        IncludeTrailingPathDelimiter(DataDir) + FlName,
        CloudPath,
        Ret[RetNo].GetCloudFileName, //20190312 Igor
        ClientID,
        Token) then
    begin//20171215 Igor>>
      (* // dont need it anymore, cloud and desktop file names are equal
      //20190522 Igor >>>
      HelperManager.DeleteCloudFile(AClouds[I],
        CloudPath,
        Ret[RetNo].GetDefaultFileName,
        ClientID,
        Token,
        true); //20200430 Igor
      //20190522 Igor <<<
      *)
      if isShareAfterSend then
        HelperManager.SetShare(AClouds[I],
        Trim(FetchElm(RetNo, 'INFO', 140)),
        CloudPath,
        Ret[RetNo].GetCloudFileName, //20190312 Igor
        ClientID,
        Token);
      //20171224 Igor >>>
      if isShareWithPeople then
      begin
        L := TStringList.Create;
        try
          L.Text := ReplaceStr(FetchElm(RetNo,'STATUS',SHARE_WITH_PEOPLE), ';', #13#10);
          for iL := 0 to L.Count - 1 do
            HelperManager.SetShare(AClouds[I],
              Copy(L.Strings[iL], Pos('|', L.Strings[iL]) + 1, Length(L.Strings[iL])),
              CloudPath,
              Ret[RetNo].GetCloudFileName, //FlName 20200130 Igor   FlName,
              ClientID,
              Token);
        finally
          L.Free;
        end;
      end;
      //20171224 Igor <<<
      //S := S + HelperManager.HelperClassList.Values.ToArray[HelperId] + ' upload complete.'+#13 //20190517 Igor
    end//20171215 Igor<<
    else
      S := S + HelperManager.HelperClassList.Values.ToArray[HelperId] + ' upload failed!'+#13;
    if HelperManager.Config(AClouds[I],
          AppT1_2026.AppId, User.UserName).SaveToken AND //20170112 Igor
       (Token <> '') AND
       (Token <> HelperManager.Config(AClouds[I],
          AppT1_2026.AppId, User.UserName).Token) then //20170112 Igor
      HelperManager.Config(AClouds[I],
          AppT1_2026.AppId, User.UserName).Token := Token; //20170112 Igor

  end;
  if S <> '' then
    MessageDlg(S, mtInformation, [mbOk], 0);
  //20161210 Igor
end;

Function CopyAForm(FromRetNo: integer;FromFormName: string;ToRetNo: integer;ToFormName: string):Integer;
Var I,j,FromFNo,ToFNo:integer;CInst:Integer;
begin
  UndefMsg('CopyAForm');
  Result := 0; //???
   If FromRetNo=0 then exit;  //20101220
   ToFNo := GetFormNo(ToFormName);
   FromFNo := GetFormNo(FromFormName);   //20110125
   If ToFNo=0 then
   begin
    CInst := StrToInt(MidStr(ExtractFormInst(ToFormName),2,2));
    begin
      ToFNo := AddPageInstance(ToRetNo, ExtractNonInstFormName(ToFormName),'#'+IntToStr(CInst));
    end;
   end;
   InitFormData(ToRetNo,ToFNo);

    If (ToRetNo>0) and (ToFNo>0) and (FromRetNo>0) and (FromFNo>0)
    then  //20101220
    begin
      FRec := FList.ByFormName(FromFormName);
      if (FRec.FormNo > 0)
      and (Ret[FromRetNo].FormHasData[Frec.FormName])  //20101220
      then
      begin
        RetList[ToRetNo].Frm[ToFNo].Assign(RetList[FromRetNo].Frm[FromFNo]);
          Calc(ToRetNo,ToFormName);
          Ret[ToRetNo].FormHasData[ToFormName]:=True;
          Result := ToFNo;
          exit;
      end;
   end;
end;



Procedure ClearForm(RetNo:integer;FName:string);
var i,n,FNo :integer;
begin
 Fno := GetFormNo(FName);
 If (Fno >0) and (Ret[RetNo].Frm[FNo].Count >0)  then
 begin
    vtShared.ClearForm(RetNo,FName);
   Sumslips(RetNo,'ALL');  {in case it is a slip}
   CalcAll(RetNo);
   Ret[RetNo].Changed := True;
 end;
 //20090406
 If Ret[RetNo].CouplingSw then
 begin
   //If (LeftStr(Fname,8)='ASSETSB#')
   If (LeftStr(Fname,5)='RC62#')
   or (LeftStr(Fname,7)='FITNESS')
   or (LeftStr(Fname,6)='DEPEND')
   then
    ShowMessage('This form is attached to both spouses. To remove it from both spouses, STOP the coupling first');
 end;
end;

Procedure MoveForm(FromRetNo: integer;FromFormName: string;ToRetNo: integer;ToFormName:String);
begin
 CopyAForm(FromRetNo,FromFormName,ToRetNo,ToFormName);  //20110112
// CloneForm(FromRetNo,FromFormName,ToRetNo,ToFormName);
 ClearForm(FromRetNo,FromFormName);
 Ret[FromRetNo].changed :=True;
 Ret[ToRetNo].changed :=True;
 Calc(FromRetNo,FromFormName);
 CalcAll(FromRetNo);
 Calc(ToRetNo,FromFormName);
 CalcAll(ToRetNo);
 Ret[FromRetNo].FormHasData[FromFormName] := False;
 Ret[ToRetNo].FormHasData[FromFormName] := True;
 Ret[FromRetNo].changed :=True;
 Ret[ToRetNo].changed :=True;
end;

Function OpenReturn(DataDir,FlName: string;ShowSw:Boolean; AIsAppendix: Boolean = False;
  AConvert: Boolean = False; SkipUnlock: boolean = false): Integer; //20160305 Igor //20190605 Igor
{result:
 0=OK,
 -1=File does not exist,
 -2=not a tax return
 -3=exceeds limit
 -4:= password wrong
 }

var
  i, FNo : integer; s:string;
  FormName: string;
  FormNo: integer;
  RetNo: integer absolute Result;
  Psw:String;
begin
 (*
   //20231217
  ShowMessage(
     'This Draft T1 release includes expected tax rates and other changes, but it has not been reviewed nor approved by CRA.'
     +Chr(13)+Chr(13)+'Details for the following new schedules, are hidden for now to comply with the Non-disclosure Ageement of CRA:'
     +Chr(13)+'S12 (Multigenerational home renovation), First Home Savings Account (S15),'
     +' First Home Contributions (T4FHSA)  and Flipping Property details (S3).'
     +Chr(13)+'The T1-2023 Guide is not yet available by CRA.'
     +Chr(13)+' For now, you can rollover selectively VT T1-2022 returns only one at a time. Batch rollover will be released later.'
     +Chr(13)+Chr(13)+'You can use this product for tax planning, data entry, selective roll-over from last year or training purposes.'
     +' The CRA-certified version is expected to be released the second week of February, 2024.'
     );
 *)



  //20170502 Igor >>>
  if RetInMem(AppT1_2026, True) >= AppT1_2026.LimitReturns then
    Exit(-3);
  //20170502 Igor <<<

  if not AIsAppendix then
    MainForm.GUICommand(gcHideLastYear); //20160621 Igor
  ApplicationState := ApplicationState + [asLoadReturn];
  try
  {$IFDEF ReturnsLimit}
    if RetInMem >= ReturnsLimit then
      begin Result := -3; exit; end;
  {$ELSE}
  {$ENDIF}
  (* create LastYear return - based on what???
  *)
    Result := ReadReturn(DataDir,FlName, AIsAppendix, AConvert);
    If Result < 1 then
      //20170307 Igor >>>
    begin
      if not SilentRead then
        ShowOpenReturnFailure(Result, DataDir, FlName);
      //ShowMessage('File not found or File is not a tax return or incompatible year')
    end
    //20170307 Igor <<<
    else
    begin
     Ret[RetNo].Province := GetShortPrv(FetchElm(RetNo,'INFO',1));
     Ret[RetNo].MarStatus := CalcMarStatus(RetNo);
     Ret[RetNo].Age := CalcAge(FetchElm(RetNo,'INFO',9));
     Ret[RetNo].IsAppendix := AIsAppendix; //20160302 Igor

     FormName := 'INFO';
     FormNo := GetFormNo(FormName);
     //FormNameNo(RetNo, 'INFO');
     Calc(RetNo,'INFO');
     If ShowSw=True then OpenForm(RetNo,FormNo,0); //new child
     if not AisAppendix then //20160305 Igor
       UpdateAllDataIndicators(RetNo);
     //If MainForm.LeftPanel.Visible then MainForm.RefreshAuditPanel(RetNo);
      //20170226 Igor >>>
      If (Ret[RetNo].Locked = True) and not Ret[RetNo].ReadOnly
         and not Ret[RetNo].isAppendix //20170511 Igor
         //and ShowSw //20180402 Igor //20180412 Igor
         and not SkipUnlock //20190605 Igor
       then //20170307 Igor
      begin

        If MessageDlg('This return is locked and it cannot be changed'
                      +Chr(13)+'It has been already Efiled and accepted.'
                      +Chr(13)+'Unlock it for changes'
                      +Chr(13)+'or Unlock it for ReFILE?',  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          UnlockReturn(RetNo);
      end;
      //20170226 Igor <<<
    end;
    //If MainForm.AuditPanel.Visible then
    if not AIsAppendix then //20160305 Igor
      MainForm.RefreshAuditPanel(RetNo);
     AddLogAppMon(amtOnRead, RetNo); //20220518 Igor //20220519 Igor
  finally
    ApplicationState := ApplicationState - [asLoadReturn];
  end;
end;

//function  OpenReturnCoupled(DirName,FlName: string): RetPtr;
function OpenReturnCoupled(DirName,FlName: string; fShow: boolean; SkipUnlock: boolean = false): integer;//20171130 Igor
Var
  sin, FormName:String;
  RetNo,FormNo:Integer;
  DataDir: string absolute DirName;
  ws: TWindowState;
begin
(* From main, perform coupling after open.
  Create and read the return, then try coupling

  Various checks collected from various calling procedures
*)
{ TODO : return RetNo/RetPtr? }
  //20170307 Igor >>>
  SilentRead := True;
  try
    //20170307 Igor <<<

    RetNo := 0;
    If Length(FlName) = 10 then
      Sin := LeftStr(FlName,8)+MidStr(FlName,10,1)
    else
      sin := '';
    If IsOkToOpenReturn(DirName,FlName,Sin) = False then Exit;

    If Not ReturnFileExists(DirName+'\'+FlName) then //20160415 Igor
    begin
     ShowMessage('File '+DirName+'\'+FlName+' does not exist');
     Exit;
    end;

    If LicenseLevel in anyMulti then
    begin
     If not User.EqualOverloadProperty(AppT1_2026, 'Dir_Cur', DirName, true) then //20170112 Igor
     begin
      If YouKnowTheAdminPassword = false then exit;
     end;
    end;

    RetNo:=OpenReturn(DataDir,FlName, False, False, False, SkipUnlock); //20170130 Igor //20190605 Igor
    If RetNo < 1 then
    begin
      ShowOpenReturnFailure(RetNo,DataDir,FlName);
      exit;
    end;
    if not fShow then
      exit; //don't do anything more
    //20170130 Igor >>>
    vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
    try
    //20170130 Igor <<<
     CountDiagnostics(RetNo);
     //MainForm.LeftPanel.Visible:=True;
     MainForm.GuiCommand(gcShowLeftPanel); //20160220 Igor
     //MainForm.GuiCommand(gcShowLeftPanel);
     //FormNameNo(RetNo, 'INFO');
     FormName := 'INFO';
     FormNo := GetFormNo(FormName);

     Busy;

  { TODO : flicker??? }

  {$IFDEF test}
     ws := RetList[RetNo].MyChild.WindowState;
     RetList[RetNo].MyChild.WindowState := wsMinimized; //too late?
     OpenForm(RetNo,FormNo,0);
     OpenUsedForms(RetNo);
     RetList[RetNo].MyChild.WindowState := ws;
  {$ELSE}
     OpenForm(RetNo,FormNo,0);
     OpenUsedForms(RetNo);
  {$ENDIF}

     If Ret[RetNo].FormHasData['FAMSET'] then
     begin
      {20110306}
       If OptRec.OpenCouple=False then
       Begin
        if MessageDlg('Last time it was processed as Family'+
         Chr(13)+'Process as Family again?',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          DoCoupling(RetNo);
        end
        else
          ApplicationState := ApplicationState - [asFamilyOpen]; //20160818 Igor
       end  //couple false
       Else
       begin
          DoCoupling(RetNo);
       end;
     end; //family on
    //end  //opened first return
     MainForm.RefreshAuditPanel(RetNo);
     MainForm.FormPaint(Application);
     Done;
    //20170130 Igor >>>
    finally
      RetList[RetNo].MyChild.ShowAllControls;
    end;
    //20170130 Igor <<<
  finally
    Result := RetNo; //20171130 Igor
    SilentRead := False;
  end;
  //20170307 Igor <<<
end;

Procedure GetStatusFromDB(DataDir:string;FlName:string;Var EfSt:string;Var PrepSt:string;Var CreateDate:String);
var
  //20150824 igor
  FDConnection: TADConnection;
  Table: TADTable;
  FNo :Integer;
begin
  EfSt :='00'; PrepSt :='00';
  If not FileExists(DataDir+'\'+ClientsDbLite) then exit;

  FDConnection := TADConnection.Create(nil);
  Table := TADTable.Create(nil);
  try
    //20150925 Igor
    //20160226 Igor >>>>
    if not SetTableName(FDConnection, Table, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'FILE_NAME') then
    Begin
      if assigned(FDConnection) then
        freeAndNil(FDConnection);
      if assigned(Table) then
        freeAndNil(Table);
      exit;
    End;

    if 1=1 then // Table.State = dsInactive //rem 20150925 Igor
    begin
       //Table.Open; //rem 20150925 Igor
       //20170223 Igor >>>
       //if Table.FindKey([FlName]) then
       if Table.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
       //20170223 Igor <<<
       begin
        PrepSt := Table.FieldByName('PRP_Status').AsString;
        EfSt:=Table.FieldByName('EF_Status').AsString;
        CreateDate:=Table.FieldByName('Created_Dt').AsString;
        Table.Close;
       end;
    end;
  finally
    FDConnection.Free;
    Table.Free;
  end;
end;

//20170322
procedure CreatetheREFILEVform(RetNo:Integer);
Var i,j,k,FNo,MaxInst,FInst,FromNetListNdx, LnIdx : integer; //20190709 Igor
    S,SnapShotDir,FileNm,ln,FName:String;
    PrevAmount,RevisedAmount:Real;
    LnList,AmtList,BeforeList,AfterList,NetList:TStringList;
    AdjLines:TStringList;
    LnDescrList:TStringList;
begin
    FormatSettings.DecimalSeparator:='.';
    RetNo:=GetCurrentRetNo;
    //check snapshot
    SnapShotDir:=AppDir+'\'+'AdjSnapshots';
    FileNm:=SnapShotDir+'\'+GetSinNo(RetNo)+'-'
      +GetLastName(RetNo)+'-'+GetFirstName(RetNo)
      +'.'+'Bfr';


    If (FileExists(FileNm)=False) then
    begin
     ShowMessage('The before-adjustment snapshot has not been created'
     +Chr(13)+'Open the ReFILEQ form and Create the Snapshot item');
     Exit;
    end;

    //there is snapshot
     BeforeList:=TStringList.Create;
     AfterList:=TStringList.Create;
     NetList:=TStringList.Create;
     LnList:=TStringList.Create;
     AmtList:=TStringList.Create;
     //create before list
     BeforeList.LoadFromFile(FileNm);

     //create after list
     //20190709 Igor >>>
     For i:=101 to 486 do
     begin
      LnIdx := ConvertOldToNewLn(I);
      If Ret[RetNo].Lnn[LnIdx] <> 0 then
      begin
       If (LnIdx<>16700) and (LnIdx<>16900) and (LnIdx<>429) then
       begin
        LnList.Add(IntToStr(LnIdx));
        AmtList.Add(FormatFloat('########.##',Ret[RetNo].Lnn[LnIdx]));
       end;
      end;
     end;
     //20190709 Igor <<<

     for i:=0 to LnList.Count-1 do
     begin
      s:=PaddR(LnList[i],6)+' '+PaddR(AmtList[i],13);
      AfterList.Add(s);
     end;

     //get net list and move data to form

     GetRefileVNetList(BeforeList,AfterList,NetList);//GetT1AdjNetList(BeforeList,AfterList,NetList);
     FNo:=GetFormNo('REFILEV#1');
     //Clear prev entries in first instance
     i:=23;
     repeat
       StoreElm(RetNo,FNo,i,'');
       Inc(i);
     until i>252; //i>112;  //20170404

     MaxInst:=Round(NetList.count/18+0.5);
     // create instances
     For i:=2 to MaxInst do
     begin
      FNo:=AddPageInstance(RetNo, 'REFILEQ','#'+AllTrim(IntToStr(i)));
      InitFormData(RetNo,FNo);
     end;
     //clear any previous data since max may be less than previously
     For i:=2 to 6 do
     begin
      If GetFormNo('REFILEV'+'#'+AllTrim(IntToStr(i)))>0 then
        ClearForm(RetNo,'REFILEV'+'#'+AllTrim(IntToStr(i)));
     end;

     FromNetListNdx:=0;
     For FInst:=1 to MaxInst do
     Begin
       FName:='REFILEV'+'#'+AllTrim(IntToStr(FInst));
       FNo:=GetFormNo(FName);
       //FNo:=GetFormNo('REFILEV'+'#'+AllTrim(IntToStr(FInst)));
       If FromNetListNdx > NetList.Count-1 then break;
       NetListToREFILEV(RetNo,FNo,NetList,FromNetListNdx);
       Inc(FromNetListNdx,18);
       Calc(RetNo,FName);  //20170404
     end;


   {
    LnDescrList:=TStringList.Create;
    LnDescrList.LoadFromFile(AppDir+'\'+'T1Tls.d');
    i:=23;
    repeat
     If (Strings[i]>'') and (Strings[i+1] ='') then
       Strings[i+1]:=GetLineDescription(MyStrToInt(Strings[i]),LnDescrList);
     Tv[i+3]:=Tv[i+4]-Tv[i+2];
     Strings[i]:=LeftStr(Strings[i],4);
     Strings[i]:=RemoveChar(Strings[i],'*');
     Inc(i,5);
    until i>248; //108;
    LnDescrList.Free;
   }
     //free lists
     BeforeList.Clear;
     AfterList.Clear;
     NetList.Clear;
     LnList.Clear;
     AmtList.Clear;

end;



procedure CreatetheT1ADJform(RetNo:Integer);
Var i,j,k,FNo,MaxInst,FInst,FromNetListNdx, LnIdx : integer; //20190709 Igor
    S,SnapShotDir,FileNm,ln:String;
    PrevAmount,RevisedAmount:Real;
    LnList,AmtList,BeforeList,AfterList,NetList:TStringList;
    AdjLines:TStringList;
begin
    FormatSettings.DecimalSeparator:='.';
    RetNo:=GetCurrentRetNo;
    //check snapshot
    SnapShotDir:=AppDir+'\'+'AdjSnapshots';
    FileNm:=SnapShotDir+'\'+GetSinNo(RetNo)+'-'
      +GetLastName(RetNo)+'-'+GetFirstName(RetNo)
      +'.'+'Bfr';

    If (FileExists(FileNm)=False) then
    begin
     ShowMessage('The before-adjustment snapshot has not been created'
     +Chr(13)+'First click on the Create Snapshot item');
     Exit;
    end;

    //there is snapshot
     BeforeList:=TStringList.Create;
     AfterList:=TStringList.Create;
     NetList:=TStringList.Create;
     LnList:=TStringList.Create;
     AmtList:=TStringList.Create;
     //create before list
      BeforeList.LoadFromFile(FileNm);

     //create after list
     //20190709 Igor >>>
     For i:=101 to 486 do
     begin
      LnIdx := ConvertOldToNewLn(I);
      If Ret[RetNo].Lnn[LnIdx] <> 0 then
      begin
       If (LnIdx<>16700) and (LnIdx<>16900) and (LnIdx<>429) then
       begin
        LnList.Add(IntToStr(LnIdx));
        AmtList.Add(FormatFloat('########.##',Ret[RetNo].Lnn[LnIdx]));
       end;
      end;
     end;
     //20190709 Igor <<<

     for i:=0 to LnList.Count-1 do
     begin
      s:=PaddR(LnList[i],6)+' '+PaddR(AmtList[i],13);
      AfterList.Add(s);
     end;

     //get net list and move data to form
     GetT1AdjNetList(BeforeList,AfterList,NetList);
     FNo:=GetFormNo('T1ADJ#1');
     //Clear prev entries in first instance
     i:=23;
     repeat
       StoreElm(RetNo,FNo,i,'');
       Inc(i);
     until i>112;

     MaxInst:=Round(NetList.count/18+0.5);
     // create instances
     For i:=2 to MaxInst do
     begin
      FNo:=AddPageInstance(RetNo, 'T1ADJ','#'+AllTrim(IntToStr(i)));
      //FNo:=GetFormNo('T1ADJ'+'#'+AllTrim(IntToStr(i)));    //the new inst
      InitFormData(RetNo,FNo);
     end;
     //clear any previous data since max may be less than previously
     For i:=2 to 6 do
     begin
      If GetFormNo('T1ADJ'+'#'+AllTrim(IntToStr(i)))>0 then
        ClearForm(RetNo,'T1ADJ'+'#'+AllTrim(IntToStr(i)));
     end;

     FromNetListNdx:=0;
     For FInst:=1 to MaxInst do
     Begin
       FNo:=GetFormNo('T1ADJ'+'#'+AllTrim(IntToStr(FInst)));
       If FromNetListNdx > NetList.Count-1 then break;
       NetListToT1Adj(RetNo,FNo,NetList,FromNetListNdx);
       Inc(FromNetListNdx,18);
     end;
     //free lists
     BeforeList.Clear;
     AfterList.Clear;
     NetList.Clear;
     LnList.Clear;
     AmtList.Clear;
end;

Procedure ConvertT5ToMult(RetNo:Integer);
Var I,j,T5Cnt,MultCnt,FNo,MultFNo:Integer;
begin
 MultCnt:=1;
 MultFNo:=GetFormNo('T5MULT#'+IntToStr(MultCnt));
 InitFormData(RetNo,MultFNo);

 T5Cnt:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   FNo:=Frec.FormNo;
   If (Frec.FormName = 'T5') and (FetchElmFNo(RetNo,FNo,1)>'') then
   begin
    Inc(T5Cnt);
    If T5Cnt>5 then
     begin
      T5Cnt:=1;
      Inc(MultCnt);
      MultFNo:=AddPageInstance(RetNo, 'T5MULT','#'+IntToStr(MultCnt));
      //MultFNo:=GetFormNo('T5MULT#'+IntToStr(MultCnt));
      InitFormData(RetNo,MultFNo);
     end;
     StoreElm(RetNo,MultFNo,1+(T5Cnt-1)*22,FetchElmFNo(RetNo,FNo,1));
     StoreElm(RetNo,MultFNo,14+(T5Cnt-1)*22,FetchElmFNo(RetNo,FNo,14));
   End;  //found t5
 end; //i flist
end;

//20190507 Igor >>>
function IsCloudStorageEnabled : boolean;
var
  iHelperIndex : integer;
begin
  result := false;
  with HelperManager do
  begin
    for iHelperIndex := 0 to HelperClassList.Count - 1 do
    begin
      if HelperManager.AllowSend(iHelperIndex) then
      begin
        result := true;
        break;
      end;
    end;
  end;
end;

Function ReadReturn(DataDir, FlName: string; AIsAppendix: Boolean = False;
  AConvert: Boolean = False): Integer; // 20160305 Igor //20160329 Igor
var
  EfSt, PrepSt: string; // [2];
  Clr: LongInt;
  DataVers: string; // [5];
  DataYear: string; // [5];
  CreateDate: string; // [10];
  ConvertingFromPrvYear, ConvertingToCombinedForms: Boolean; // 20100616
  i, j, k, FNo, SNo, BxNo: Integer;
  f: TFileStorage;
  S, FormNm: String;
  Var1, Var2, Var3, Var4: String;
  IncrElmList: TStringList;
  OldFormNm: String;
  sElm, Valu: String;
  RetNo: Integer absolute Result;
 //20160415 Igor>>>
  PrevFormName: String;
  SQLite: TSQLiteStorage;

   //20160415 Igor<<<

   LockManager: TLockManager; //201770307 Igor
begin
  //20241203 If UpperCase(InputBox('T1 Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20241126
  //20210514
  if IsAuthorizedPreparer=False then exit;
  //20170315 Igor >>>
  if not FileExists(IncludeTrailingPathDelimiter(DataDir) + FlName) then
  begin
    Result := iorFileName;
    exit;
  end;

  //20170315 Igor <<<
  //201700307 Igor >>>
  LockManager := TLockManager.Create(IncludeTrailingPathDelimiter(DataDir) + FlName, lmReadWrite);
  if LockManager.LockMode = lmNoAccess then
  Begin
    FreeAndNil(LockManager);
    Result := iorReported;
    exit;
  End;
  try
    //201700307 Igor <<<
    Result := CheckReturnPsw(DataDir, FlName, AppT1_2026.SQLLitePassword.PassRFArray);  //2024116
    //Result := CheckReturnPsw(DataDir, FlName, AppT1_2023.SQLLitePassword.PassRFArray);
    if Result <> iorReported then
      exit;
    Result := iorUnknown; // until CreateNewReturn

    ConvertingFromPrvYear := False;
    ConvertingToCombinedForms := False;
    IncrElmList := TStringList.Create;
    IncrElmList.LoadFromFile(AppDir + '\' + 'IncrElm.d');
     //20160415 Igor>>>
    PrevFormName := '';
    SQLite := TSQLiteStorage.Create(DataDir, FlName, fsRead, AppT1_2026.SQLLitePassword.PassRFArray);
    if SQLite.LastError <> '' then
    Begin
      FreeAndNil(SQLite);
      f := TFileStorage.Create(DataDir, FlName, fsRead);
    End;
   //20160415 Igor<<<
    Try // except
      try
       //20160415 Igor>>>
        if assigned(SQLite) then
        Begin
          if not SQLite.ReadSettings('AppName', Var1) or
             not SQLite.ReadSettings('AppYear', Var2) or
             not SQLite.ReadSettings('AppRelease', Var4) or
             (Var1 <> AppName) then
          Begin
            Result := iorFileType;
            exit;
          End;
        End
        else
        Begin
        //20160415 Igor<<<
          if not f.ReadLine(Var1, Var2, Var3, Var4) // NextLine;
            or (Var1 <> AppName) then
          begin
            Result := iorFileType; // -2;
            // CloseFile(F1); - in finally
            exit;
          end;
        End;

        { Determine LastYear return before CreateNewReturn.
          - DataYear for interpretation of FormName --> Ret.IsLastYearRetNo --> ShowUnconvertedLastYear
          - ShowUnconverted to enable/suppress conversion during read --> ConvertingFromPrvYear
          Conversion does what? (create new year forms?)
          !after conversion: reset FList?
        }

        DataYear := Var2;

       if MyRollover then //20241116
       begin
        DataYear:='2025';   //20251108  update it evey year to make it look as this year's file so no rollover takes place. it retains the data
        Var2:='2025'; //VAR4:=DataYear;   //20251127
        Aconvert:=False;
        AisAppendix:=False;
       end;

        // ================================================
       //20161110 Igor >>>
        // if return is prev year - need init PrevYear FList
        if (StrToInt(DataYear) <= (AppYearInt - 1)) and //if prev year
           not AConvert and                             //and no convert
           not AisAppendix then                         // and no show in right panel
        Begin
          //20190209
          MessageDlg('Wrong Data Directory in Configure? This file belongs to' + AppName + '-' + DataYear + ' and it can not be opened as a normal return', mtWarning, [mbOk], 0);
          Result := iorReported;
          //If MyRollover=false then exit;  //20251127
        end;

        //If MyRollover=False then
        //Begin
        if (StrToInt(DataYear) <= (AppYearInt - 1)) and //if prev year
           not AConvert and                             //and no rollover 1 return
           AisAppendix and                              // and show in right panel
           not AppT1_2026.InitLastYear then   //20241116          // and no init last yead (no forms, no dfm, no T1SCR.DB)
              //not AppT1_2023.InitLastYear then // and no init last yead (no forms, no dfm, no T1SCR.DB)
        Begin
          Result := iorReported;
          //If MyRollover=false then exit;    //20251127
        end;

        Result := CreateNewReturn(DataYear, AConvert); // 20160329 Igor

        if Result < 1 then exit;

       {
        if MyRollover=True then Var2:='2025'; //20251109
        If MyRollover=True then   //retain all data
          ConvertingFromPrvYear := FALSE; //20251127
        }
        If Var2 <= IntToStr(StrToInt(AppYear) - 1) then
        begin
           If (ShowUnconvertedLastYear(RetNo) = True) then
           begin
             ConvertingFromPrvYear := False; // take it as is without cary forward
           end
           else
           begin
             {?? dummy out the following for full rollover to keep all data - HAS PROBLEMS}
             ConvertingFromPrvYear := True;
             CFZeroAmounts;
           end;
        end;

        Ret[RetNo].isAppendix := AIsAppendix; // 20160703 Igor
        DataVers := Var4;
        If ((DataYear <= '2009') and (DataVers < '2.0')) then ConvertingToCombinedForms := True;

       //==========================================
       {
       //ALLOW open with NO CONVERSION
        if MyRollover=False then //20251127
        Begin
         DataYear:='2025';
         Var4:='2025';
         Aconvert:=False;
         AisAppendix:=False;
         ConvertingFromPrvYear := FALSE;
        end;
        }
       //==========================================

        While ReadNextLine(SQLite, Var1, Var2, Var3, Var4, f) do //20160415 Igor //20160819 Igor
        begin
          if Var1 = 'F' then { Form record }
          begin
            //20160430 Igor
            If (Var2='T1206N')then var2:='T1206';   //20181220
            If (Var2='T2201')then var2:='T2201#1';   //20160411
           // If (Var2='T2201H')then var2:='T2201H#1';   //20220220
            if LeftStr(Var2,8)='S5SUPPL#' then Var2:='OBSOLETE'; //20180120
            if Var2='T4164' then Var2:='OBSOLETE'; //20221216
            if Var2='T777' then Var2:='T777#1'; //20200511 Multiinstance
            OldFormNm := Var2;
            If ConvertingToCombinedForms then
            Begin
              Var2 := ConvertFNameToCombined(OldFormNm);
              If LeftStr(Var2, 4) = 'PAGE' then Var2 := 'T1';
            end;
            FormNm := Var2;
            FNo := GetFormNo(FormNm, RetNo);
            if FormNm='OBSOLETE' then FNo:=0;

            If (FNo = 0) and (IsFormMultiInst(FormNm)) then // 20101220
            begin
              FNo := AddPageInstance(RetNo, ExtractNonInstFormName(FormNm),
                ExtractFormInst(FormNm));
            end;

            If FNo > 0 then
            begin
              InitFormData(RetNo, FNo);
              Ret[RetNo].FormHasData[FormNm] := True;
            end;
          end

          else if Var1 = 'D' then { Detail Form Data }
          begin
            sElm := Var2;
            Valu := Var3;
            If ConvertingToCombinedForms then
              sElm := IntToStr(ConvertElmNoToCombined(OldFormNm, StrToInt(sElm),
                IncrElmList));

            If FNo > 0 then
            begin

              If ConvertingFromPrvYear then
                CFFilterLastYrAndStore(RetNo, FormNm, FNo, StrToInt(sElm), Valu)
              else
                Try
                  If ((Ret[RetNo].isLastYearReturn = False) or AIsAppendix)
                  // 20160314 Igor
                    and (sElm <> '') then
                     RetList[RetNo].SaveElmFromFile(FNo, StrToInt(sElm), Valu);
                except
                  ShowMessage('Error in Form:' + FormNm);
                end;
            end;
          end

          else if Var1 = 'M' then // memo field
          begin

            If FNo > 0 then
            begin
              RetList[RetNo].SaveMemoFromFile(FNo, StrToInt(Var2), Var3);
            end
          end

          else if Var1 = 'O' then { Overrides }
          begin
            if not ConvertingFromPrvYear then
            begin
              SaveFieldOverride(RetNo, GetFormNo(Var2), StrToInt(Var3), Var4);
            end;
          end
          else if Var1 = 'R' then { Review marks }
          begin
            if not ConvertingFromPrvYear then
              SetReviewMark(RetNo, GetFormNo(Var2), StrToInt(Var3));
          end
          else if Var1 = 'L' then
          begin
            if not ConvertingFromPrvYear then
              Ret[RetNo].Lnn[ConvertOldToNewLn(StrToInt(Var2))] := Vl(Var3); //20190709 Igor
          end;
        end; // While not EOF(F1)
      finally
        if assigned(f) then //20160415 Igor
          f.Free;
        IncrElmList.Free;
        if assigned(SQLite) then //20160415 Igor
          FreeAndNil(SQLite);
      end;

    except
      UserMsg('Reading of data may be incomplete ' + FormNm);
    end;
    if Ret[RetNo].FormHasData['FAMSET'] AND not AIsAppendix then //20170511 Igor
      ApplicationState := ApplicationState + [asFamilyOpen]; //20160724 Igor
    // 20100627

    //if MyRollover=True then UnlockReturn(RetNo); //20251127 FILS the rollover

    If OptRec.RetainRetColor = True then
    Begin
      If FetchElm(RetNo, 'STATUS', 34) > '' then
      begin
        Clr := StrToInt(FetchElm(RetNo, 'STATUS', 34));
        if Clr <> 0 then
          RetList[RetNo].RestoreRetColor(Clr);
      end;
    End;

    FNo := GetFormNo('STATUS');
    if Ret[RetNo].Frm[FNo].Count = 0 then
    begin
      InitFormData(RetNo, FNo);
      InitStatusForm(RetNo, FNo);
    end;
    { get status from data base }

    Ret[RetNo].EFStatus := FetchElmFNo(RetNo, FNo, 15);
    Ret[RetNo].PrpStatus := FetchElmFNo(RetNo, FNo, 4);

    If (Ret[RetNo].EFStatus = '02') or (ShowUnconvertedLastYear(RetNo)) then
      LockReturn(RetNo);

    StoreElm(RetNo, GetFormNo('STATUS'), 6, CreateDate);

    Ret[RetNo].DataVersion := DataVers;
    Ret[RetNo].Notes := FetchElm(RetNo, 'STATUS', 14);
    Ret[RetNo].RTUFile := FetchElm(RetNo, 'STATUS', 16);
    Ret[RetNo].AckFile := FetchElm(RetNo, 'STATUS', 31);
    Ret[RetNo].SourceDataDir := DataDir;
    Ret[RetNo].SourceFlName := FlName;
    Ret[RetNo].isAppendix := AIsAppendix; // 20160305 Igor
    if FetchElm(RetNo, 'STATUS', c_ReturnColorElm) <> '' then
    try
      SetRetColor(RetNo, StringToColor(FetchElm(RetNo, 'STATUS', c_ReturnColorElm)), c_ReturnColorElm);
      MainForm.GuiCommand(gcColorChanged);
    except
    end;
    If ConvertingFromPrvYear then CFReformatPrvYearData(RetNo);

    Auto777ToAuto777Multiple(RetNo);  //20200511 allocate statement from T777 to T777#1 one time change

   // ShowMessage('READ Bfr Recalc 2043A#1  '+FetchElm(RetNo,'T2043A#1',7)); //20220220

    if not AIsAppendix then // 20160314 Igor
    Begin
      FNo := GetFormNo('INFO');
      INFO(RetNo, 'INFO', FNo);
      RecalcEverything(RetNo); // 20100605
      CalcAll(RetNo); // 20130126
      UpdateAllDataIndicators(RetNo); { added in 1997 }
    End;
    Ret[RetNo].changed := False; // 20170112 Igor (RecalcEverything  set Changed to True )
  //  ShowMessage('READ AFTER Recalc 2043A#1  '+FetchElm(RetNo,'T2043A#1',7)); //20220220
  //20170307 Igor >>>
  finally
    if Result <= 0 then  //20170310 Igor
      freeAndNil(LockManager)
    else
      RetList[Result].LockManager := LockManager;
  end;
  //20170307 Igor <<<
end;

//20251230
Function GetCraBal(FlName:String):String; //flname  = File being saved
Var i:Integer;CraBalList:TStringList;
S,CraBalancesFlName:String;
begin
 //20260609
 Result:='';
 EXIT;
 {
 InfoFNo:=GetFormNo('INFO');
 CraBalList:=TStringList.Create;
 Result:='';
 CraBalList.loadfromFile(AppDir+'\'+'CraBalances.txt');
 for I := 0 to CraBalList.Count - 1 do
 begin
  s:=AllTrim(CraBalList[i]);
  if UpperCase(FlName)= Uppercase(LeftStr(s,12)) then
  begin
   Result:=MidStr(S,16,12); //cra balance amount as string
   CraBalList.free;
   Exit;
  end;
 end;
 }
end;

end.
