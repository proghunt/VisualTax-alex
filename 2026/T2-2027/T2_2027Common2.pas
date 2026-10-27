unit T2_2027Common2;
(* updated to revision 2014-07-29
*)

{ ============================================================= }
interface

{ ============================================================= }
uses SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics,
  Controls,
  Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls, Printers, DB, T2_2027TrimStr,
  T2_2027, T2_2027Declare,
  vtMulti; //20200914 Igor



Var AnalysisType:String;SalDivSetFNo:Integer; TaxYear:String;RYY:Integer;TestMode:Boolean; HowMany:Integer;  //for tax year subscript) //20200828B Testmode


Procedure SALDIVSet(RetNo: Integer; FName: string; FNo: Integer);
Procedure CopyT1dataToSalDiv(T2RetNo: Integer; T1RetNo: Integer; Sin: String;
  Salary: Real; Dividends: Real; Age:String; Option: Integer; Multcnt: Integer);
Procedure CopyT2DataToSalDiv(T2RetNo: Integer; T1RetNo: Integer; Sin: String; Salary: Real; Dividends: Real; TotalCpp:Real;TotaEi:Real; Option: Integer; Multcnt: Integer); // 0200815

Function GetSalDivTotalCpp(Age:String;T2RetNo: Integer; Salary: Real; AppYear: String; CPPPeriods: Integer; TotPeriods: Integer; Option: Integer): Real;
Function GetSalDivTotalEI(T2RetNo: Integer; Salary: Real; AppYear: String; Option: Integer): Real;

Procedure SalDivChangeT4(T2RetNo: Integer; T1RetNo: Integer; Sin: String; Salary: Real; Dividends: Real;CPP:Real;EI:Real; Option: Integer);
Procedure SalDivChangeT5(T2RetNo: Integer; T1RetNo: Integer; Sin: String;
  Salary: Real; Dividends: Real; Option: Integer);

Procedure SalDivChangeT2GIFI(T2RetNo: Integer; Salary: Real; Dividends: Real; Option: Integer);

Procedure OpenT1ReturnsForSalDiv(T2RetNo: Integer);
Function GetT1ReturnNo(DataDir: String; FlName: String): Integer;
Function OpenT1Return(T2RetNo: Integer; DataDir: String; FlName: String): Integer;
Procedure ClearT4T5SalDiv(T2RetNo: Integer; T1RetNo: Integer; Sin: String);
Procedure RecalcT1T2AndCopyToSalDiv(T2RetNo: Integer; T1RetNo: Integer;
  Sin: String; Salary: Real; Dividends: Real;Age:String; Option: Integer;
  Multcnt: Integer);

Function SalDivCpp(Age:String;TaxYear: String; PensEarnings: Real; CPPPeriods: Integer;
  TotPeriods: Integer): Real;
Function SalDivEI(T2RetNo: Integer;SIN:String;TaxYear: String; Salary: Real; CPPPeriods: Integer; TotPeriods: Integer): Real;

Procedure SALDIV(RetNo: Integer; FName: string; FNo: Integer);
Function GetSalDivFNo(T2RetNo: Integer; Sin: String): Integer;
Function GetSalDivMFNo(T2RetNo: Integer; Sin: String): Integer;

Function GetT1RetNoFromSin(DataDir, Sin: String): Integer; // T1RetNo
Procedure AddSinToSalDivForm(T2RetNo: Integer; Sin: String);
Procedure AddSinToSalDivMForm(T2RetNo: Integer; Sin: String);
Procedure DeleteSINFromSalDivForms(T2RetNo: Integer; Sin: String);
Procedure CloseAllSalDivT1Returns;
Procedure ClearAllSalDivForms(T2RetNo: Integer);
Procedure ClearAllSalDivMForms(T2RetNo: Integer);
Procedure CreateSalDivForms(T2RetNo: Integer; MaxNo: Integer);
Function GetSalDivMultipleCombinationsString(T2RetNo:Integer):String;
Function CountSalDivShareholders(T2RetNo:Integer):Integer;
Function ValidADDONFeaturesKey:Boolean;
Function EIExempt(T2RetNo: Integer; Sin: String): Boolean;
Procedure CopyMultCombinationsToSalDiv(T2RetNo: Integer; SalDivMFNo:Integer;SalDivFNo:Integer; Salary: Real; Dividends: Real; SIN:String; Option: Integer; Multcnt: Integer);
Procedure ClearMultipleSalDivScenariosSection(T2RetNo: Integer;
  T1RetNo: Integer; Sin: String; SalDivFNo: Integer);

// 20200823
Function GetSalDivEligDivindendsFromT1(T1RetNo: Integer; Option: Integer): Real;



procedure PostToGiFiLine(ARetNo: integer; GifiForm: string; ArrayStartElm: integer; Description, GifiCode, Amount: string); //20190624 Igor
Procedure ConvertTo2006Release2(RetNo: Integer; FName: String; FNo: Integer;
  Elm: Integer; Value: String);

Function GetBlackBoxFunctionLine: String;
Procedure CalcBlackBox(FlName: String; RetNo: Integer);
Function SubstituteOldCT23Jacket(IncomingForm: String): String;
Procedure AddGifiElms(RetNo: Integer; FormNm: String; ElmNo: Integer);
Procedure GetStatusFromDB(DataDir: string; FlName: string; Var EfSt: string;
  Var PrepSt: string);
Procedure InitStatusForm(RetNo: Integer; FNo: Integer);
Function HasDataN(RetNo: Integer; FNo: Integer; Elm: Integer): boolean;
Function HasDataS(RetNo: Integer; FNo: Integer; Elm: Integer): boolean;

Function AddOtherPagesInstance(RetNo: Integer; NonInstFormName: String;
  FormInst: String): boolean;
Function AddPageInstance(RetNo: Integer;
  NonInstFormName, FormInst: string): Integer;
Function GetShortPrv(LPrv: string): String;
Function GetCountry3FromCountry2(ACode: string): String; // 20180703 Igor

Procedure ClearForm(RetNo: Integer; FName: string);
Function SubstituteRelease1Form(IncomingForm: String): String;
// Function FetchElmFNo(RetNo : integer; FNo:integer;Elm :integer): string; //20160222 Igor
Function OpenReturn(DataDir, FlName: string; ShowSw: boolean;
  AIsAppendix: boolean = False): Integer; // 20160305 Igor
Function ReadReturn(DataDir, FlName: string; RecalcFlag, WarnFlag: boolean;
  AIsAppendix: boolean = False; AConvert: boolean = False): Integer;
Function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;
  OverrideSW: boolean; UpdMostRecent: boolean; ATextFormat: boolean = False;
  AUpdateClientTable: boolean = True; AClouds: TArrayOfInteger = nil): Integer;
// 20160405 Igor //20190228 Igor
Function UpdateClientsTable(RetNo: Integer; DataDir: string; FlName: string): Integer;

implementation

uses vtMain, vtCommon, vtDialogs, vtFileStorage, //20200914 Igor
  T2_2027Multi, T2_2027Main, T2_2027Common,
  T2_2027Calc, T2_2027FSum, T2_2027Calc2, T2_2027ChildWinNew, vtTrimStr,
  vtShared, vtHelperManager // 20190228 Igor
    , System.IOUtils, Math // 20190612 Igor
    , vtDataBase, uADCompClient; // 20150922 Igor

Function HasDataN(RetNo: Integer; FNo: Integer; Elm: Integer): boolean;
Begin
  If Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0 then
    Result := True
  else
    Result := False;
end;

Function HasDataS(RetNo: Integer; FNo: Integer; Elm: Integer): boolean;
Begin
  If FetchElmFNo(RetNo, FNo, Elm) > '' then
    Result := True
  else
    Result := False;
end;

Function AddOtherPagesInstance(RetNo: Integer; NonInstFormName: String;
  FormInst: String): boolean;
{ call procedure in initFormsTable }
Var
  I: Integer;
begin
  Result := False;

  If NonInstFormName = 'IS_1' then
  begin
    AddPageInstance(RetNo, 'IS_2', FormInst);
    AddPageInstance(RetNo, 'IS_3', FormInst);
  end;

  If NonInstFormName = 'BS_1' then
  begin
    AddPageInstance(RetNo, 'BS_2', FormInst);
  end;

  If NonInstFormName = 'S48' then
  begin
    AddPageInstance(RetNo, 'S48', FormInst);
  end;

  If NonInstFormName = 'T1163' then
  begin
    AddPageInstance(RetNo, 'T1163', FormInst);

    {
      AddPageInstance('T1163_2',FormInst);
      AddPageInstance('T1163_3',FormInst);
      AddPageInstance('T1163_4',FormInst);
    }
  end;

  If NonInstFormName = 'T1273' then
  begin
    AddPageInstance(RetNo, 'T1273', FormInst);
  end;
end;

Function AddPageInstance(RetNo: Integer;
  NonInstFormName, FormInst: string): Integer;
begin
  if RetList[RetNo].isLastYearReturn or RetList[RetNo].isAppendix then
    Result := FLastYearList.AddPageInstance(RetNo, NonInstFormName, FormInst)
    // 20160704 Igor
  else
    Result := FList.AddPageInstance(RetNo, NonInstFormName, FormInst);
end;

Function GetShortPrv(LPrv: string): String;
Var
  I: Integer;
Begin
  Result := PrvShort[1];
  For I := 1 to High(PrvLong) do
  begin
    If LPrv = PrvLong[I] then
    begin
      Result := PrvShort[I];
      exit;
    end;
  end;
End;
// 20160222 Igor
// Function FetchElmFNo(RetNo : integer; FNo:integer;Elm :integer): string;
// {FNo is coming as parameter,not Fname}
// begin
// Result :='';
// If FNo=0 then Exit;
// If Ret[RetNo].Frm[Fno].Count >0 then
// Result := Ret[RetNo].Frm[FNo].strings[elm];
// (*
// If Ret[RetNo].FrmInitialized[FNo] = False then
// result := ''
// else
// Result := Ret[RetNo].Frm[FNo].strings[elm];
// *)
// end;

Function GetCountry3FromCountry2(ACode: string): String; // 20180703 Igor
var
  FList: TStringList;
  I: Integer;
begin
  Result := ACode;
  FList := TStringList.Create;
  try
    FList.LoadFromFile(AppDir + '\' + 'CountryCodes.d');
    if FList.IndexOfName(ACode) <> -1 then
      Result := FList.Values[ACode];
  finally
    FList.Free;
  end;
end;

Procedure InitStatusForm(RetNo: Integer; FNo: Integer);
begin
  With Ret[RetNo].Frm[FNo] do
  begin
    Strings[4] := '00'; { prpstatus }
    { created }
    Strings[5] := User.UserName; // 20170112 Igor
    Strings[6] := DateToStr(Date);
    Strings[7] := TimeToStr(Time); { created }
    { last update }
    Strings[11] := User.UserName; // 20170112 Igor
    Strings[12] := DateToStr(Date);
    Strings[13] := TimeToStr(Time);
    { Efile }
    Strings[15] := OptRec.Prp_Name;
    Strings[16] := OptRec.Prp_Street;
    Strings[17] := OptRec.Prp_City;
    Strings[18] := OptRec.Prp_Prov;
    Strings[19] := OptRec.Prp_Postal;
    Strings[20] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
    Strings[21] := OptRec.Prp_Fax;

  end;
end;

Function UpdateClientsTable(RetNo: Integer; DataDir: string;FlName: string): Integer;
{ input parms are taken from Save As.. screen }
Var
  FNo: Integer;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  FlName := UpperCase(FlName);
  FNo := GetFormNo('STATUS'); { to preserve status data }
  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  { Update Data Base }

  // 20150922 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite,
    ClientsTableLite, 'File_Name');

  if 1 = 1 then // Table1.State = dsInactive //rem 20150923 Igor
  begin
    if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
    // 20170210 Igor
      Table1.edit
    else
      Table1.Insert;

    Table1.FieldByName('Corp_Name').AsString :=
      UpperCase(FetchElm(RetNo, 'T2', 3));
    Table1.FieldByName('File_Name').AsString := FlName;
    Table1.FieldByName('Year_end').AsString := FetchElm(RetNo, 'T2', 11);
    Table1.FieldByName('Due_Date').AsString := FetchElm(RetNo, 'T2', 11);
    If FetchElm(RetNo, 'T2', 749) > '' then
      Table1.FieldByName('Contact').AsString := FetchElm(RetNo, 'T2', 749)
    else
      Table1.FieldByName('Contact').AsString := FetchElm(RetNo, 'T2', 743) + ' '
        + FetchElm(RetNo, 'T2', 742);

    Table1.FieldByName('Account').AsString :=
      LeftStr(FetchElm(RetNo, 'T2', 1), 9);

    Table1.FieldByName('Pay_InvNo').AsString := FetchElm(RetNo, 'INVOICE', 210);
    // 20160418 changed all 'INV' to 'INVOICE'
    Table1.FieldByName('Pay_Type').AsString := '';
    If FetchElm(RetNo, 'INVOICE', 223) > '' then
      Table1.FieldByName('Pay_Type').AsString := 'Cash'
    else If FetchElm(RetNo, 'INVOICE', 224) > '' then
      Table1.FieldByName('Pay_Type').AsString := 'Cheque'
    else If FetchElm(RetNo, 'INVOICE', 225) > '' then
      Table1.FieldByName('Pay_Type').AsString := 'Visa';

    Table1.FieldByName('Pay_Dt').AsString := FetchElm(RetNo, 'INVOICE', 209);
    Table1.FieldByName('Inv_Amount').AsFloat :=
      Vl(FetchElm(RetNo, 'INVOICE', 222));

    If (FetchElm(RetNo, 'INVOICE', 223) > '') or
      (FetchElm(RetNo, 'INVOICE', 224) > '') or
      (FetchElm(RetNo, 'INVOICE', 225) > '') then
      Table1.FieldByName('Pay_Amount').AsFloat :=
        Vl(FetchElm(RetNo, 'INVOICE', 222))
    Else
      Table1.FieldByName('Pay_Amount').AsFloat := 0;
    Table1.FieldByName('Street').AsString := FetchElm(RetNo, 'T2', 12);
    Table1.FieldByName('City').AsString := FetchElm(RetNo, 'T2', 16);
    Table1.FieldByName('Province').AsString := FetchElm(RetNo, 'T2', 17);
    { from long to short }
    Table1.FieldByName('Postal').AsString :=
      RemoveChar(RemoveChar(FetchElm(RetNo, 'T2', 20), ' '), '-');

    Table1.FieldByName('Area').AsString := FetchElm(RetNo, 'T2', 755);
    Table1.FieldByName('Phone').AsString :=
      RemoveChar(RemoveChar(FetchElm(RetNo, 'T2', 746), ' '), '-');
    Table1.FieldByName('Created_by').AsString := FetchElm(RetNo, 'STATUS', 5);
    Table1.FieldByName('Created_tm').AsString := FetchElm(RetNo, 'STATUS', 7);

    Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo, 'STATUS', 8);
    Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo, 'STATUS', 10);

    Table1.FieldByName('PRP_Status').AsString := FetchElm(RetNo, 'STATUS', 4);
    Table1.FieldByName('Updated_by').AsString := FetchElm(RetNo, 'STATUS', 11);
    Table1.FieldByName('Updated_tm').AsString := FetchElm(RetNo, 'STATUS', 13);
    Table1.FieldByName('Notes').AsString := FetchElm(RetNo, 'STATUS', 14);

    try
      Table1.FieldByName('Created_dt').AsString := FetchElm(RetNo, 'STATUS', 6);
      Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo, 'STATUS', 9);
      Table1.FieldByName('Updated_dt').AsString :=
        FetchElm(RetNo, 'STATUS', 12);
      If Table1.FieldByName('PRP_Status').AsString = '06' then
      begin
        Table1.FieldByName('Compl_by').AsString :=
          Table1.FieldByName('Updated_by').AsString;
        Table1.FieldByName('Compl_dt').AsString :=
          Table1.FieldByName('Updated_dt').AsString;
        Table1.FieldByName('Compl_tm').AsString :=
          Table1.FieldByName('Updated_tm').AsString;
      end;
    except
      on exception do
        showmessage('Data is saved. For best results ensure that data' + Chr(13)
          + 'is saved on a data directory created by the T2-2000 or beyond');
    end;
    Table1.Post;
  end;
  Table1.Free;
  ADConnection.Free;
  Result := 0;
end;

Function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;
  OverrideSW: boolean; UpdMostRecent: boolean; ATextFormat: boolean = False;
  AUpdateClientTable: boolean = True; AClouds: TArrayOfInteger = nil): Integer;
// 20160405 Igor //20190228 Igor
var
  I, j, jj, k, FNo, SNo, InstNo: Integer;

  S: string; // [16];
  test: boolean;
  SQLite: TSQLiteStorage; // 20160415 Igor
  // 20190228 Igor >>>
  HelperID: Integer;
  HelperClassName: String;
  CloudPath: String;
  ClientID: String;
  Token: String;
  isShareAfterSend: boolean;
  isShareWithPeople: boolean;
  L: TStringList;
  iL: Integer;
  // 20190228 Igor <<<
begin
  if not AppT2.CheckAllowedBN(RetNo) then Exit(-2); //20191015 Igor
  //20281016 Alex >>>
  if MyRollover then
  begin
    UnLockReturn(RetNo);
    StoreElm(RetNo, getFormNo('STATUS'), 4, '00'); //prepstasus
    //StoreElm(RetNo, getFormNo('STATUS'), 15, '00'); //Efstatus //Alex: I am not found the same field for T2 Status form

    //Alex: In the T2 module we have no any date of birthdate and Info or Depend forms, that's why code commented
    //fix birthdates and bus statements
    {Valu:= FetchElm(RetNo, InfoFNo, 9);
    StoreElm(RetNo, InfoFNo, 9, IncrYear(Valu)); //birthdate
    i:= 10;  //birthdates
    repeat
      Valu:= FetchElm(RetNo, DependFNo, i);
      if Valu > '' then StoreElm(RetNo, DependFNo, i, IncrYear(Valu));
      inc(i, 15);
    until i > 130; }
  end;
  //20281016 Alex <<<
 if Ret[RetNo].Locked or
  // Ret[RetNo].IsLastYearReturn or //20160331 Igor //20160623 Igor
    Ret[RetNo].isAppendix then // 20160331 Igor
  begin
    RetList[RetNo].Changed := False;
    Result := iorFileType;
    exit;
  end;

  If FlName = '' then
  begin
    Result := -2; { ? }
    UserMsg('Account is required');
    exit;
  end;

  // 20170902 Igor>>>
  if AppT2.ExceedsMaxReturnsAllowed(False) then
    exit;
  // 20170902 Igor<<<
  If OverrideSW = False then
  begin
    If FileExists(DataDir + '\' + FlName) then
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
  UpdateAllDataIndicators(RetNo);
  { update data base first }

  if GetTaxationYearEndYYYY(RetNo)>=2025 then  //
    StoreElm(RetNo,'S8',227,S8ApplicableVersion); // //20260531

  Try
    if AUpdateClientTable then // 20160405 Igor
      Result := UpdateClientsTable(RetNo, DataDir, FlName);
  Except
    on E: exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;

  // 20160415 Igor >>>
  SQLite := TSQLiteStorage.Create(DataDir, FlName, fsWrite,
    AppT2.SQLLitePassword.PassRFArray);
  if SQLite.LastError <> '' then
  Begin
    showmessage(SQLite.LastError);
    SQLite.Free;
    exit;
  End;
  // 20160415 Igor<<<

  // 20160415 Igor>>>
  if not SQLite.WriteSettings('AppName', AppName) then
  Begin
    MessageDlg(SQLite.LastError, mtError, [mbok], 0);
    exit;
  end;
  if not SQLite.WriteSettings('AppYear', AppYear) then
  Begin
    MessageDlg(SQLite.LastError, mtError, [mbok], 0);
    exit;
  end;
  if not SQLite.WriteSettings('AppVersion', AppVersion) then
  Begin
    MessageDlg(SQLite.LastError, mtError, [mbok], 0);
    exit;
  end;
  if not SQLite.WriteSettings('AppRelease', AppRelease) then
  Begin
    MessageDlg(SQLite.LastError, mtError, [mbok], 0);
    exit;
  end;
  if not SQLite.WriteSettings('FileVersion', 'a') then
  Begin
    MessageDlg(SQLite.LastError, mtError, [mbok], 0);
    exit;
  end;
  if not SQLite.WriteSettings('LastUpdate', FormatDateTime('YYYYMMDD_hhnnss',
    Now)) then
  Begin
    MessageDlg(SQLite.LastError, mtError, [mbok], 0);
    exit;
  end;
  //20260615 Alex >>>
  if not SQLite.WriteSettings('RSIApprovalCode', RSIApprovalCode) then
  begin
    MessageDlg(SQLite.LastError, mtError, [mbok], 0);
    exit;
  end;
  //20260615 Alex <<<
  // 20160415 Igor<<<
  { save forms data }
  { General : Var1, Var2     , Var3  , Var4 }
  { Formats : F   , FormName ,       , }
  { Override: O   , 'OVR ? needed'    ,       , }
  { Data      D   , Elm      , Value , }
  { Slips   : S   , SlipName , Index , ? }
  { Memos     M   , Ln , partial string, cont/EOT? }
  try
    for I := 0 to FList.Count - 1 do
    begin
      FRec := FList.Items[I];
      FNo := FRec.FormNo;
      if (RetList[RetNo].FormHasData[FRec.FormName + FRec.FormInst]) // 20160615
      // if (RetList[RetNo].FormHasData[FRec.FormName]) //20160405 Igor
      // or (Frec.FormName = 'S27_1')   //20150829 This looks wrong/ineffective
      // or (Frec.FormName = 'S60') //FrmHasData should be set!  //must have a project title to be saved //20150829
      // or (FRec.FormName = 'S125') //FrmHasData should be set! //20150829
      then
      begin
        Ret[RetNo].WriteFData(FRec, SQLite); // 20160415 Igor
      end; // if has data
    end; // for i FList count

    Ret[RetNo].WriteLnEtc(LnLowBound, LnHighBound, SQLite); // 20160415 Igor
  finally
    SQLite.Free; // 20160415 Igor
  end;
  // If Result = 0 then
  Ret[RetNo].Changed := False;
  SaveScreenSettings(Sc, ScChar, ScChange, LeftPanelWidth);
  If UpdMostRecent = True then
  begin
    UpdateMostRecentFiles(RetNo, DataDir, FlName, GetAccountNumber(RetNo));
  end;

  // 20170716
  if (Ret[RetNo].FrmHasData[GetFormNo('S9')]) and
    (UpperCase(FetchElm(RetNo, 'S9', 184)) = 'Y') then
    CreateGroupInfoLink(DataDir, FlName, GetCorpName(RetNo));
  // related/assoc info

  // 20190228 Igor <<<
  for I := 0 to length(AClouds) - 1 do
  begin
    if (AClouds[I] >= 1000) then
      Continue;

    isShareAfterSend := False;
    isShareWithPeople := False;
    for j := I to length(AClouds) - 1 do
    begin
      if (AClouds[j] = 1000 + AClouds[I]) then
        isShareAfterSend := True;
      if (AClouds[j] = 2000 + AClouds[I]) then
        isShareWithPeople := True;
    end;

    HelperID := AClouds[I];
    HelperClassName := HelperManager.HelperClassList.Keys.ToArray[AClouds[I]]
      .ClassName;
    CloudPath := HelperManager.Config(HelperClassName, AppT2.AppId,
      User.UserName).Path;
    ClientID := HelperManager.Config(HelperClassName).ClientID;
    Token := HelperManager.Config(AClouds[I], AppT2.AppId, User.UserName).Token;
    if HelperManager.Send(AClouds[I], IncludeTrailingPathDelimiter(DataDir) +
      FlName, CloudPath, Ret[RetNo].GetCloudFileName, ClientID, Token) then

    begin
      if isShareAfterSend then
        HelperManager.SetShare(AClouds[I], Trim(FetchElm(RetNo, 'INFO', 140)),
          CloudPath, Ret[RetNo].GetCloudFileName, ClientID, Token);
      if isShareWithPeople then
      begin
        L := TStringList.Create;
        try
          L.Text := ReplaceStr(FetchElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE),
            ';', #13#10);
          for iL := 0 to L.Count - 1 do
            HelperManager.SetShare(AClouds[I],
              Copy(L.Strings[iL], Pos('|', L.Strings[iL]) + 1,
              length(L.Strings[iL])), CloudPath, Ret[RetNo].GetCloudFileName, ClientID, Token); //20200130 Igor
             //length(L.Strings[iL])), CloudPath, FlName, ClientID, Token);
        finally
          L.Free;
        end;
      end;
      S := S + HelperManager.HelperClassList.Values.ToArray[HelperID] +
        ' upload complete.' + #13
    end
    else
      S := S + HelperManager.HelperClassList.Values.ToArray[HelperID] +
        ' upload failed!' + #13;
    if HelperManager.Config(AClouds[I], AppT2.AppId, User.UserName)
      .SaveToken AND (Token <> '') AND
      (Token <> HelperManager.Config(AClouds[I], AppT2.AppId, User.UserName)
      .Token) then
      HelperManager.Config(AClouds[I], AppT2.AppId, User.UserName)
        .Token := Token;
  end;
  if S <> '' then
    MessageDlg(S, mtInformation, [mbok], 0);
  // 20190228 Igor
end;

Function ReadReturn(DataDir, FlName: string; RecalcFlag, WarnFlag: boolean;
  AIsAppendix: boolean = False; AConvert: boolean = False): Integer;

var
  PrepSt, EfSt: String; // InVersion:String;
  I, j, k, FNo, SNo, BxNo, S4WSFNo, RetNo: Integer;
  lCol221,lCol222,lCol224:Integer;  //20260601
  fs: TFileStorage;
  Converting: boolean;
  ConvertingT661: boolean;
  ConvertingTo2009Release3: boolean;
  ConvertingOITC: boolean;
  { ConvertingS60, } ConvertingS4: boolean; // 20150829
  ConvertingToCombinedForms: boolean;
  OldFormNm: String;
  IncrElmList: TStringList;

  // Table1 : TADTable; //rem 20150922 Igor
  S, FormNm: String;
  Var1, Var2, Var3, Var4, Var5: String; //20260617 Alex

  sElm, Valu: String;

  PrevFormName: String; // 20160415 Igor
  SQLite: TSQLiteStorage; // 20160415 Igor
  SQLiteS8: TSQLiteStorage; // 20260623 Alex
  fsS8: TFileStorage; // 20260623 Alex
  lIsS8Field227Filled: Boolean; // 20260623 Alex

  procedure NextLine;
  begin
    fs.ReadLine(Var1, Var2, Var3, Var4);
  end;
  function ReadNextLine: boolean; // 20160415 Igor
  Begin
    Result := vtFileStorage.ReadNextLine(SQLite, Var1, Var2, Var3, Var4, fs);
  End;

  //20260623 Alex >>>
  function IsS8Field227Filled(): Boolean;
  var
    lVar1, lVar2, lVar3, lVar4, lsElm, lValu, lFormNm, lElm6Val: String; //20260714 Alex
    lFNo: Integer;

    function S8ReadNextLine: boolean;
    begin
      Result:= vtFileStorage.ReadNextLine(SQLiteS8, lVar1, lVar2, lVar3, lVar4, fsS8);
    end;

  begin
    Result:= False;

    if Assigned(SQLiteS8) then
      while S8ReadNextLine do
      begin
        if lVar1 = 'F' then
        begin
          lFNo:= GetFormNo(lVar2, RetNo);
          lFormNm:= lVar2;
        end else
        if lVar1 = 'D' then
        begin
          lsElm:= lVar2;
          lValu:= lVar3;
          lElm6Val:= ''; //20260714 Alex
          if (lFNo > 0) and LeftStr(lFormNm, 3).Equals('S8#') and lsElm.Equals('6') then lElm6Val:= lValu; //20260714 Alex
          if (lFNo > 0) and LeftStr(lFormNm, 3).Equals('S8#') and lsElm.Equals('227') then Result:= lValu.Equals(S8ApplicableVersion);
          if (lFNo > 0) and LeftStr(lFormNm, 3).Equals('S8#') and Result and lsElm.Equals('273') and not lValu.IsEmpty() and not lElm6Val.Equals(lValu) then Result:= False; //20260714 Alex
          //if (lFNo > 0) and LeftStr(lFormNm, 3).Equals('S8#') and lsElm.Equals('227') then Result:= lValu.Equals(S8ApplicableVersion);
        end;
      end;
  end;
  //20260623 Alex <<<

begin

 if IsAuthorizedPreparer=False then Exit;  //20220527

 if AllTrim(OptRec.Prp_Name)='' then  //20200629
  Begin
   ShowMessage('Please click Menu item Configure -> General Options'
   +Chr(13)+'and Complete FULLY the Preparer information');
   Exit;
  End;

  //if IsAuthorizedPreparer=False then Exit;  //20200615
  (* Only error: AppId mismatch = -2
    -4 wrong password?
  *)
  Result := CheckReturnPsw(DataDir, FlName);
  if Result < 0 then
    exit; // file or pwd error
  Result := iorUnknown;

  FNo := 0; // keep compiler happy

  S4WSFNo := GetFormNo('S4WS'); // for speed
  ConvertingT661 := False;
  { ConvertingS60:=False; }  // 20150829
  ConvertingTo2009Release3 := False;
  ConvertingOITC := False;
  ConvertingToCombinedForms := False;
  ConvertingS4 := False;
  IncrElmList := TStringList.Create;
  // IncrElmList.LoadFromFile(AppDir+'\'+'IncrElm.d');

  // SomeList := TStringList.Create; {used to save FNo's of the return} - unused!
  // 20160415 Igor>>>
  PrevFormName := '';
  SQLite := TSQLiteStorage.Create(DataDir, FlName, fsRead,
    AppT2.SQLLitePassword.PassRFArray);
  if SQLite.LastError <> '' then
  Begin
    FreeAndNil(SQLite);
    fs := TFileStorage.Create(DataDir, FlName, fsRead);
  End;
  //20260623 Alex >>>
  SQLiteS8:= TSQLiteStorage.Create(DataDir, FlName, fsRead, AppT2.SQLLitePassword.PassRFArray);
  if not SQLiteS8.LastError.IsEmpty then
  begin
    FreeAndNil(SQLiteS8);
    fsS8:= TFileStorage.Create(DataDir, FlName, fsRead);
  end;
  //20260623 Alex <<<

  // 20160415 Igor<<<
  try // read file
    // check return AppId
    // 20160415 Igor>>>
    if Assigned(SQLite) then
    Begin
      if not SQLite.ReadSettings('AppName', Var1) or
        not SQLite.ReadSettings('AppYear', Var2) or
        not SQLite.ReadSettings('AppVersion', Var3) then
      Begin
        showmessage(SQLite.LastError);
        exit;
      end;

      //20260617 Alex >>>
      if not SQLite.ReadSettings('RSIApprovalCode', Var5) then
      begin
        Var5:= '';
      end;
      //20260617 Alex <<<
    end
    else
      // 20160415 Igor<<<
      NextLine;
    InVersion := Var3;
    If Var1 <> AppName then
    begin
      Result := -2;
      // CloseFile(F1);
      exit;
    end;
    //20281016 Alex >>>
    if MyRollover then
    begin
      // update it evey year to make it look as this year's file so no rollover takes place. it retains the data
      Var2:= AppYear;
      Aconvert:= False;
      AisAppendix:= False;
    end;
    //20281016 Alex <<<
    // now create an new return
    Result := CreateNewReturn(Var2, AConvert); // 20160331 Igor  //20160627 Igor
    if Result < 1 then
      exit;
    RetNo := Result;
    Ret[RetNo].isAppendix := AIsAppendix; // 20160703 Igor
    If ((Var2 <= '2012') and (InVersion < '2012.3')) // 20121208
    // or (InVersion<Var2+'.'+Var3<3.0'))     //20121208
    then
      ConvertingToCombinedForms := True;
    If ConvertingToCombinedForms = True then
    Begin
      // IncrElmList:=TStringList.Create;
      IncrElmList.LoadFromFile(AppDir + '\' + 'IncrElm.d');
    End;

    //20260623 Alex >>>
    lIsS8Field227Filled:= IsS8Field227Filled();
    //20260623 Alex <<<

    while ReadNextLine do // 20160415 Igor
    begin
      if Var1 = 'F' then { Form record }
      begin
        If Var2 = 'FNOTE1' then
          Var2 := 'S141'; // 20160813
        // If Var2='T1134'  then Var2:='T1134#1'; //20160611
        // ShowMessage(Var2);
        If LeftStr(Var2, 5) = 'S422_' then
          Var2 := 'S422#1'; // 20110417
        If LeftStr(Var2, 6) = 'T1131_' then
          Var2 := 'T1131'; // 20110417
        FNo := GetFormNo(Var2, RetNo);
        FormNm := Var2;
        //if UpperCase(Formnm)='USEDFRM' then ShowMessage('UsedFrm');  //20220706

        If (FNo = 0) and (IsFormMultiInst(Var2)) then
        begin
          FNo := AddPageInstance(RetNo, ExtractNonInstFormName(Var2),
            ExtractFormInst(Var2));
          AddOtherPagesInstance(RetNo, ExtractNonInstFormName(Var2),
            ExtractFormInst(Var2));
          // Fno := GetFormNo(Var2); {get it again}
        end;

        If (FNo > 0) and (FNo <= FormsLimit) then
        begin
          InitFormData(RetNo, FNo);
          Ret[RetNo].FrmHasData[FNo] := True;
          // SomeList.Add(IntToStr(FNo)); {record all Fno's}
        end;
      end

      else if Var1 = 'D' then { Detail Form Data }
      begin
        sElm := Var2;
        Valu := Var3;
        If ConvertingToCombinedForms then
          Var2 := IntToStr(ConvertElmNoToCombined(OldFormNm, StrToInt(sElm),
            IncrElmList));

        If FNo > 0 then
        begin
          // 20181119
          If (FormNm = 'T661') and (LeftStr(InVersion, 4) < '2019') then
          Begin
            If sElm = '485' then
            Begin
              StoreElm(RetNo, FNo, 595, Valu);
              StoreElm(RetNo, FNo, 485, '');
            end;
            If sElm = '486' then
            Begin
              StoreElm(RetNo, FNo, 596, Valu);
              StoreElm(RetNo, FNo, 486, '');
            end;
            If sElm = '487' then
            Begin
              StoreElm(RetNo, FNo, 597, Valu);
              StoreElm(RetNo, FNo, 487, '');
            end;
          end

          //Alex 20260601   Converting from old S8 form columns
          Else if LeftStr(FormNm, 3).Equals('S8#') and not lIsS8Field227Filled and Var5.IsEmpty() then //20260623 Alex
          begin
            //202260601 Alex >>>
            i:= 6;
            j:= 6;
            k:= 252;
            lCol221:= 265;    //cz to allow compile
            lCol222:= 278;
            lCol224:= 330;
            repeat
              if (myStrToInt(sElm) = j) then StoreElm(RetNo, FNo, i, Valu); // Col 200
              if (myStrToInt(sElm) = j + 1) then StoreElm(RetNo, FNo, i + 1, Valu); // Col 201
              if (myStrToInt(sElm) = j + 2) then StoreElm(RetNo, FNo, i + 2, Valu); // Col 203
              if (myStrToInt(sElm) = j + 4) then StoreElm(RetNo, FNo, i + 8, Valu); // Col 207

              { //20260618cz
              if (myStrToInt(sElm) = k) then StoreElm(RetNo, FNo, i + 2, Valu); // Col 225
              if (myStrToInt(sElm) = j + 3) then StoreElm(RetNo, FNo, i + 5, Valu); // Col 205
              if (myStrToInt(sElm) = lCol221) then StoreElm(RetNo, FNo, i + 6, Valu); // Col 221
              if (myStrToInt(sElm) = lCol222) then StoreElm(RetNo, FNo, i + 7, Valu); // Col 222
              if (myStrToInt(sElm) = lCol224) then StoreElm(RetNo, FNo, i + 16, Valu); // Col 224
              if (myStrToInt(sElm) = j + 11) then StoreElm(RetNo, FNo, i + 17, Valu); // Col 212
              if (myStrToInt(sElm) = j + 12) then StoreElm(RetNo, FNo, i + 18, Valu); // Col 213
              if (myStrToInt(sElm) = j + 13) then StoreElm(RetNo, FNo, i + 19, Valu); // Col 215
              if (myStrToInt(sElm) = j + 14) then StoreElm(RetNo, FNo, i + 20, Valu); // Col 217
              if (myStrToInt(sElm) = j + 15) then StoreElm(RetNo, FNo, i + 21, Valu); // Col 220}

              inc(i, 22);
              inc(j, 16);
              inc(k, 1);
              inc(lCol221, 1);
              inc(lCol222, 1);
              inc(lCol224, 1);
            until (i > 204);
            //202260601 Alex <<<
          end

        (*
          //20260530 instructions for Alex by cz
          Else if (FormNm = 'S8') and (S8NeedsConversion(RetNo)=True) Then
          begin
             // For Alex
            //values need to be put from the old S8 to the new S8
            //i/e values in boxes 200,201, 203, 207 from the old elm must me insrted
            //stored into the new elms of the same boxes of the new S8.
            //Most of the rest are automatically calcuated.

            // For example values
            ///??? Pattern  StoreElm(RetNo, FNo, StrToInt(Var2), Var3);
           //var2 is the incoming Elm and Var3 its value
          end
         *)

          Else if (FormNm = 'S9') or (FormNm = 'S23') or (FormNm = 'S381') then
          begin
            StoreElm(RetNo, FNo, StrToInt(sElm), Valu);
          end

          else If LeftStr(FormNm, 4) = 'S4' then // 20140531
          begin
            If (myStrToInt(sElm) >= 501) Or
              ((myStrToInt(sElm) >= 44) and (myStrToInt(sElm) <= 100)) then
            Begin
              If Ret[RetNo].Frm[S4WSFNo].Count = 0 then
                InitFormData(RetNo, S4WSFNo);
              If ConvertingS4 then
                ConvertS4(RetNo, FormNm, FNo, myStrToInt(sElm), Valu, S4WSFNo);
              // 20140431
            end
            Else
              StoreElm(RetNo, FNo, StrToInt(Var2), Var3); // 20140409
          end

          else If LeftStr(FormNm, 4) = 'S60#' then
          begin
            StoreElm(RetNo, FNo, StrToInt(Var2), Var3);
          end
          else
          begin
            If (LeftStr(FormNm, 6) = 'GIFIBS') or (LeftStr(FormNm, 6) = 'GIFIIS')
            then
              AddGifiElms(RetNo, FormNm, StrToInt(Var2));
            StoreElm(RetNo, FNo, StrToInt(Var2), Var3);
          end;
        end
      end // d

      else if Var1 = 'M' then // memo field
      begin
        If (FNo > 0) and (Trim(Var3) > '') then // 20160419 Igor
        begin
          // fix problems with old memo storage, depending on form
          BxNo := StrToInt(Var2); // maybe old vtEdit number
          if LeftStr(FormNm, 4) = 'S60#' then
          begin
            // map old vtEdit to new vtMemoBox ElmNo
            // 20150828
            case BxNo of
              242:
                Begin
                  I := 2;
                  RetList[RetNo].SaveMemoFromFile(FNo, I, Var3);
                end;
              244:
                Begin
                  I := 3;
                  RetList[RetNo].SaveMemoFromFile(FNo, I, Var3);
                end;
              246:
                Begin
                  I := 4;
                  RetList[RetNo].SaveMemoFromFile(FNo, I, Var3);
                end; // 20150828
            else // already converted?
              // if BxNo < Memos.Count
              begin
                I := BxNo;
                RetList[RetNo].SaveMemoFromFile(FNo, I, Var3);
              end;
            end;
            // RetList[RetNo].SaveMemoFromFile(FNo,i,Var3) //vtMemo1 //20150828
          end
          else if FormNm = 'FNOTE2' then
          Begin // 20160405 Igor
            I := 1; // the only memobox in this form
            RetList[RetNo].SaveMemoFromFile(FNo, I, Var3); // 20160405 Igor
          end // 20160405 Igor
          else
          Begin // 20160405 Igor
            I := BxNo; // default, assume converted
            RetList[RetNo].SaveMemoFromFile(FNo, I, Var3);
          end // 20160405 Igor
        end
      end

      else if Var1 = 'O' then { Overrides }
      begin
        SetFieldOverride(RetNo, GetFormNo(Var2), StrToInt(Var3));
        SaveFieldOverride(RetNo, GetFormNo(Var2), StrToInt(Var3), Var4);
      end
      else if Var1 = 'R' then { Review marks }
        SetReviewMark(RetNo, GetFormNo(Var2), StrToInt(Var3));
    end;
  finally
    if Assigned(fs) then // 20160415 Igor
      fs.Free;
    if Assigned(SQLite) then // 20160415 Igor
      FreeAndNil(SQLite); // 20160415 Igor
    // If ConvertingToCombinedForms=True then
    if Assigned(fsS8) then fsS8.Free; //20260623 Alex
    if Assigned(SQLiteS8) then FreeAndNil(SQLiteS8); //20260623 Alex
    IncrElmList.Free;
  end;

  { TODO : check pwd! }

  If ConvertingToCombinedForms = True then
    StoreElm(RetNo, GetFormNo('T2'), 203, ''); // remove NAICS 20121208
  // after closing
  FNo := GetFormNo('STATUS');
  if Ret[RetNo].Frm[FNo].Count = 0 then
  begin
    InitFormData(RetNo, FNo);
    InitStatusForm(RetNo, FNo);
  end;
  if not AIsAppendix and not Ret[RetNo].OldGifiDataConverted then
  // 20160704 Igor //20160721 Igor
  begin
    ConvertOldGifiData(RetNo);
    Ret[RetNo].OldGifiDataConverted := True; // 20160721 Igor
  end;

  Ret[RetNo].PrpStatus := FetchElm(RetNo, 'STATUS', 4);
  Ret[RetNo].Notes := FetchElm(RetNo, 'STATUS', 14);
  Ret[RetNo].SourceDataDir := DataDir;
  Ret[RetNo].SourceFlName := FlName;
  Ret[RetNo].isAppendix := AIsAppendix; // 20160305 Igor
  // 20170223 Igor>>>
  if FetchElm(RetNo, 'STATUS', c_ReturnColorElm) <> '' then
    try
      SetRetColor(RetNo, StringToColor(FetchElm(RetNo, 'STATUS',
        c_ReturnColorElm)), c_ReturnColorElm);
      MainForm.GuiCommand(gcColorChanged);
    except
    end;
  // 20170223 Igor<<<
  If (FetchElm(RetNo, 'STATUS', 4) = '09') and (WarnFlag) then // 20110604
  begin
    // 20100530
    If MessageDlg('Return has been Efiled already. Lock it?', mtWarning,
      [mbNo, mbYes], 0) = mrYes then
      LockReturn(RetNo);
  end;
  // 20160503
  // Ret[RetNo].FrmHasData[GetFormNo('S125#2')]:=False;   //20160506 //20180417 Igor
  if not AIsAppendix then // 20160704 Igor
  begin
    CalcFed(RetNo); // 20160506
    CalcOnt(RetNo);
    CalcAlb(RetNo); // 20160506
  end;
  Ret[RetNo].Changed := False; // 20170111 Igor
end;


Function SubstitutePre2005Rel2Ct23(IncomingForm: String): String;
begin
  Result := IncomingForm;
end;

Function SubstituteOldCT23Jacket(IncomingForm: String): String;
Var
  RetNo, FNo: Integer;
begin
  RetNo := GetCurrentRetNo;
  Result := IncomingForm;
end;

Function SubstituteOld2003CT23Jacket(IncomingForm: String): String;
Var
  FNo: Integer;
begin
  Result := IncomingForm;
end;

Function SubstituteRelease1Form(IncomingForm: String): String;
begin
  Result := IncomingForm;
end;

Procedure ClearForm(RetNo: Integer; FName: string);
var
  I, n, FNo: Integer;
begin
  vtShared.ClearForm(RetNo, FName);
end;

Procedure GetStatusFromDB(DataDir: string; FlName: string; Var EfSt: string;
  Var PrepSt: string);
Var
  FNo: Integer;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  EfSt := '00';
  PrepSt := '00';
  If not FileExists(DataDir + '\' + ClientsDBLite) then
    exit; // 20150922 Igor

  // 20150922 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite,
    ClientsTableLite, 'FILE_NAME');

  if 1 = 1 then // Table1.State = dsInactive //rem 20150923 Igor
  begin
    Table1.Open;
    // 20170223 Igor >>>
    // if Table1.FindKey([FlName]) then
    if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
    // 20170223 Igor <<<

    begin
      PrepSt := Table1.FieldByName('PRP_Status').AsString;
      EfSt := '00'; { Table1.FieldByName('EF_Status').AsString; }
      Table1.Close;
    end;
  end;
  Table1.Free;
  ADConnection.Free;
end;

Procedure AddGifiElms(RetNo: Integer; FormNm: String; ElmNo: Integer);
Var
  FNo: Integer;
begin
  FNo := GetFormNo(FormNm);
  if Ret[RetNo].Frm[FNo].Count < ElmNo + 2 then
  begin
    Ret[RetNo].Frm[FNo].Add('');
    Ret[RetNo].Frm[FNo].Add('');
  end;
end;

// Function OpenReturn(Var RetNo:Integer;DataDir: String; FlName: string;ShowSw:Boolean): Integer;
Function OpenReturn(DataDir, FlName: string; ShowSw: boolean;
  AIsAppendix: boolean = False): Integer; // 20160305 Igor
{ result:
  >0: RetNo
  //0=OK,
  -1=File does not exist,
  -2=not a tax return
  -3=exceeds limit
  -4:= password wrong
}
begin
  if not AIsAppendix then // 20160704
    MainForm.GuiCommand(gcHideLastYear); // 20160621 Igor
  ApplicationState := ApplicationState + [asLoadReturn];
  try
    (* Report all errors
    *)
    // 20170502 Igor>>>
    if RetInMem(AppT2, True) >= AppT2.LimitReturns then
      exit(-3);
    // 20170502 Igor>>>
{$IFDEF ReturnsLimit}
    if RetInMem >= ReturnsLimit then
      Result := -3
    else
{$ELSE}
{$ENDIF}
    if (FlName = '') or ReturnFileExists(DataDir + '\' + FlName) = False then
    // 20160415 Igor
      Result := iorFileName // -1
    else
      // 20161108 Igor
      If (LicenseLevel in anyMulti) AND not User.EqualOverloadProperty(AppT2,
        'Dir_Cur', DataDir, True) AND // 20170112 Igor
        (not YouKnowTheAdminPassword) then
        Result := iorPassword // -4
      else
        Result := ReadReturn(DataDir, FlName, True, True, AIsAppendix);
    //
    // begin
    // If DataDir <> User.Tax_Dir then
    // begin
    // If YouKnowTheAdminPassword = false then //exit;
    // Result := iorPassword // -4
    // end
    // end else
    // Result := ReadReturn(DataDir,FlName,True,True,AIsAppendix);
    // 20161108 Igor
    if Result <= 0 then
      ShowOpenReturnFailure(Result, DataDir, FlName)
    else
    Begin
      Ret[Result].isAppendix := AIsAppendix; // 20160305 Igor
      if ShowSw then
      begin
        // open default form?
        if AIsAppendix then // 20160302 Igor
          MainForm.RefreshAuditPanel(Result);
        AddLogAppMon(amtOnRead, Result); //20220519 Igor
      end;
    End;
  finally
    ApplicationState := ApplicationState - [asLoadReturn];
  end;
end;

Procedure CalcBlackBox(FlName: String; RetNo: Integer);
begin
  //
end;

Procedure ConvertTo2006Release2(RetNo: Integer; FName: String; FNo: Integer;
  Elm: Integer; Value: String);
Var
  I, k, NewElm: Integer;
begin
  If FName = 'S23' then
  begin
    If Elm = 65 then
    begin
      StoreElm(RetNo, FNo, 127, Value);
      exit;
    end;
    Case Elm of
      5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60:
        begin
          NewElm := 5 + (Round(Elm div 5) - 1) * 6;
          StoreElm(RetNo, FNo, NewElm, Value);
          exit;
        end; // nm
      6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61:
        begin
          NewElm := 6 + (Round(Elm div 5) - 1) * 6;
          StoreElm(RetNo, FNo, NewElm, Value);
          exit;
        end; // bn
      7, 12, 17, 22, 27, 32, 37, 42, 47, 52, 57, 62:
        begin
          NewElm := 7 + (Round(Elm div 5) - 1) * 6;
          StoreElm(RetNo, FNo, NewElm, Value);
          exit;
        end; // assoc

      69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80:
        begin
          NewElm := 8 + (Elm - 69) * 6;
          StoreElm(RetNo, FNo, NewElm, Value);
          exit;
        end; // bus limit
      82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93:
        begin
          NewElm := 9 + (Elm - 82) * 6;
          StoreElm(RetNo, FNo, NewElm, Value);
          exit;
        end; // %
    end;
    (*
      //bus limit
      k:=0;
      For i:=69 to 80 do
      begin
      If elm=i then begin StoreElm(RetNo,FNo,8+k*6,Value);Exit;end;
      Inc(k,1);
      end;
      //%
      k:=0;
      For i:=82 to 93 do
      begin
      If elm=i then begin StoreElm(RetNo,FNo,9+k*6,Value);Exit;end;
      Inc(k,1);
      end;
    *)
  end;

  If FName = 'S381' then
  begin
    If (Elm > 3) and (Elm < 20) then
    begin
      StoreElm(RetNo, FNo, Elm + 65, Value);
      exit;
    end;
    If (Elm >= 59) and (Elm <= 63) then
    begin
      StoreElm(RetNo, FNo, Elm, Value);
      exit;
    end;
    If (Elm >= 21) and (Elm <= 22) then
      StoreElm(RetNo, FNo, Elm, Value);
    If (Elm = 25) then
      StoreElm(RetNo, FNo, Elm, Value);
    If (Elm = 35) then
      StoreElm(RetNo, FNo, Elm, Value);
  end; // s381
end;

Function GetBlackBoxFunctionLine: String;
begin
  //
end;

procedure PostToGiFiLine(ARetNo: integer; GifiForm: string; ArrayStartElm: integer; Description, GifiCode, Amount: string); //20190624 Igor
var FormNo, BoxesPerRow, I, ArrayNo, Elm: integer;
begin
  FormNo := GetFormNo(GifiForm, ARetNo);
  ArrayNo := ArrayStartElm div 10000;
  if ArrayNo < 1 then
  begin
    ShowMessage('ArrayStartElm is incorrect (must be greater than 10000)');
    Exit;
  end;
  BoxesPerRow := RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
  Elm := ArrayNo * 10000 + 1;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    if SameText(Trim(FetchElm(ARetNo, GifiForm, Elm + 1)), GifiCode) then
    begin
      StoreElm(ARetNo, GifiForm, Elm + 2, Amount);
      Exit;
    end;
    if Trim(FetchElm(ARetNo, GifiForm, Elm)).IsEmpty
       and
       Trim(FetchElm(ARetNo, GifiForm, Elm + 1)).IsEmpty
       and
       Trim(FetchElm(ARetNo, GifiForm, Elm + 2)).IsEmpty then
      break;
    Elm := Elm + BoxesPerRow;
  end;
  StoreElm(ARetNo, GifiForm, Elm, Description);
  StoreElm(ARetNo, GifiForm, Elm + 1, GifiCode);
  StoreElm(ARetNo, GifiForm, Elm + 2, Amount);
end;

Procedure OpenT1ReturnsForSalDiv(T2RetNo: Integer);
Var
  I, j, j1, j2, k, jj,jjj,JM: Integer; //jm for multiple iterations
  DataDir, FlName, Sin, Name, S: String; //20201015 Igor
  T1RetNo: Integer;
  SalDivMFno,Elm, FNo: Integer;
  SalDivFNo: Integer;
  SalDivFName: String;
  x, y, TotCompensation: Real;
  GifiFNo: Integer;
  Option: Integer;
  Salary, Dividends, Compensation: Real;
  Age:String;
  T1DataDir, T2DataDir: String;
  SaveId: String;
  T1App: TApp;
  MultiplePercent: Real;
  Multcnt: Integer;
  SalPercent,DivPercent:Real;

Begin
 //if ValidADDONFeaturesKey=false then Exit;     //20250109

  SalDivSetFNo:=GetFormNo('SALDIVSET');  //20200831 ONE and only assignment
  if TestMode then
  Begin
  If UpperCase(InputBox('Test mode is for Software developer only', 'PSW', '')) <> 'N/A' then exit;
  // ShowMessage('YOU ARE IN TEST MODE - ONLY for Software developer - Remove indicator');
  End;
  Screen.Cursor := crHourGlass; //20200908

  MaxShareholders := 15; // TEMP ???

  CloseAllSalDivT1Returns;
  ClearAllSalDivForms(T2RetNo); // 20200819; Initializethem to blank data //20200829
  ClearAllSalDivMForms(T2RetNo); // 20200901
  CreateSalDivForms(T2RetNo, MaxShareholders);
  if FetchElm(T2RetNo, SalDivSetFNo, 49)>'' then AnalysisType:='SD';
  if FetchElm(T2RetNo, SalDivSetFNo, 9)>'' then AnalysisType:='S';

  I := 51;
  Repeat
    Sin := FetchElm(T2RetNo,SalDivSetFNo, I);
    DeleteSINFromSalDivForms(T2RetNo, Sin); // 20200820
    AddSinToSalDivForm(T2RetNo, Sin); // 20200819
    AddSinToSalDivMForm(T2RetNo, Sin); // 20200831
   (* Did not work. It should
    //get age,name etc
    T1App := AppList.AppFromName('T1');
    if not Assigned(T1App) then begin showmessage('T1 App was not found'); exit;end;
    FlName := LeftStr(Sin, 8) + '.' + RightStr(Sin, 1);
    DataDir := FetchElmFNo(T2RetNo, SalDivSetFNo, 10);
    T1RetNo := GetT1ReturnNo(DataDir, FlName);
    if T1RetNo>0 then
    Begin
     s:=FetchElm(T1RetNo,'TAXSUM',157); //age
     StoreElm(T1RetNo,SalDivSetFNo,jj,S); //age
     StoreElm(T1RetNo,SalDivSetFNo,jjj,FetchElm(T1RetNo,'TAXSUM',2)); //Name
    end;
    *)
    Inc(I, 1);
  until I > 65; // maxShareholders; //65?

  // ******************************************************************

  SalDivMode := True;
  // used by the T2 GIFI to capture the Salaries paid via the salDiv planning. Once calc is done is the switch is turned off

  //saving dirs
  //T1DataDir := FetchElmFNo(T2RetNo, SalDivSetFNo, 11);  //20201212
  //T2DataDir := FetchElmFNo(T2RetNo, SalDivSetFNo, 13);  //20201212
  If FetchElmFNo(T2RetNo,SalDivSetFNo,14)>'' then RYY:=1 else RYY:=0;

  T1RetNo := 0;
  I := 51;
  j := 81; // compensation amount
  j1 := 31; //Salary %
  j2 := 161; //Dividend %
  jj:=66;  //Name
  jjj:=191; //age

  Repeat
    T1App := AppList.AppFromName('T1'); if not Assigned(T1App) then begin showmessage('T1 App was not found'); exit;end;
    Sin := FetchElmFNo(T2RetNo, SalDivSetFNo, I);
    Name := FetchElmFNo(T2RetNo, SalDivSetFNo, jj); //20201015 Igor
    if Sin > '' then
    Begin
      FlName := T1App.GenerateReturnFileName(SIN, Name); //LeftStr(Sin, 8) + '.' + RightStr(Sin, 1); //20201015 Igor
      //DataDir := FetchElmFNo(T2RetNo, SalDivSetFNo, 10);  //20201212
      DataDir:=T1App.Dir_Cur;   //20201212 CON
      if FileExists(DataDir + '\' + FlName) = False then
      Begin
        showmessage('The T1 tax return ' + DataDir + '\' + FlName +
          ' was not found' + Chr(13) + 'First: Press the Exit the SalDiv Analysis button.'
          + Chr(13) + ' ' + Chr(13) +
          'Then create a New return with this SIN, using the T1 tax module,' +
          Chr(13) + 'enter any known tax data but do NOT enter any income from '
          + Chr(13) + GetCorpName(T2RetNo) + Chr(13) +
          'Then Save it, Close it and continue with the SalDiv Analysis');
        CloseAllSalDivT1Returns; // 20200823
        EXIT;
      End;

      SalDivMode := True;
      T1RetNo := GetT1ReturnNo(DataDir, FlName);
      if T1RetNo = -1 then
      Begin
         If testmode then
         Begin
           //T1RetNo := T1App.OpenReturn(DataDir, FlName, True); //20200906 no diffrence
           T1RetNo := T1App.OpenReturn(DataDir, FlName, True, False); //20200826
         end
         else
           T1RetNo := T1App.OpenReturn(DataDir, FlName, False, False);    // this does not show the returns
      end;

      //=======================================
      // *****INITIALIZE**************
      ClearT4T5SalDiv(T2RetNo, T1RetNo, Sin);  //20200827
      ClearMultipleSalDivScenariosSection(T2RetNo, T1RetNo, Sin, SalDivFNo); // 20200823

      HowMany:=0;

      if AnalysisType='SD' then
      Begin
       If FetchElmFNo(T2RetNo,SalDivSetFNo,49)>'' then HowMany := MyStrToInt(FetchElm(T2RetNo, SalDivSetFNo, 46)); //20200901
      End
      Else
      Begin
       If FetchElmFNo(T2RetNo,SalDivSetFNo,9)>'' then HowMany:=MyStrToInt(FetchElm(T2RetNo, SalDivSetFNo, 48));   //20200901
      End;

      Multcnt := 0; // 20200823 counts extra options to be calculated
      // *******************
      for Option := 0 to 2 do
      Begin
        if Option = 0 then  //NO salary NO dividends  Column
        begin
          Multcnt := 0;
          Salary := 0;
          Dividends := 0;
          RecalcT1T2AndCopyToSalDiv(T2RetNo, T1RetNo, Sin, Salary, Dividends,Age,
            Option, Multcnt); // this creates the T4 slip for T1
        end

        Else if Option = 1 then //salary only, NO dividends column
        begin
          Multcnt := 0;
          Salary := Vl(FetchElm(T2RetNo, SalDivSetFNo, j));
          Dividends := 0; // no dividends
          RecalcT1T2AndCopyToSalDiv(T2RetNo, T1RetNo, Sin, Salary, Dividends,Age,Option, Multcnt); // this creates the T4 slip for T1
        end

        Else if (Option = 2) then // SALARY and DIVIDENDS column
        begin
          if HowMany < 2 then  //one scevario only the main detail one
          Begin
            if AnalysisType='SD' then      ///20200831
            Begin
             Multcnt := 0;  //type 'SD'
             SalPercent := Vl(FetchElm(T2RetNo, SalDivSetFNo, j1)); // Salary % //20200829
             Salary    := (Vl(FetchElm(T2RetNo, SalDivSetFNo, j)) * SalPercent) / 100;
             DivPercent := 100-SalPercent;     //dividend %   //20200829
             Dividends := (Vl(FetchElm(T2RetNo, SalDivSetFNo, j)) * DivPercent) / 100;
            end
            Else if AnalysisType='S' then      ///20200829
            Begin
             SalPercent := Vl(FetchElm(T2RetNo, SalDivSetFNo, j1)); // Salary % //20200829
             Salary:=(Vl(FetchElm(T2RetNo, SalDivSetFNo, j)) * SalPercent) / 100;
             DivPercent:=Vl(FetchElmFNo(T2RetNo,SalDivSetFNo,J2)); ////20200829
             Dividends:=Salary*DivPercent/100;   //percent of it
            End;
            RecalcT1T2AndCopyToSalDiv(T2RetNo, T1RetNo, Sin, Salary, Dividends,Age,Option, Multcnt);
          end

          Else  //HowMany >1 scenarios need loop changing % of Dividends or ompensation
          Begin
            SalDivFNo := GetSalDivFNo(T2RetNo, Sin);
            SalDivMFNo := GetSalDivMFNo(T2RetNo, Sin);
            Compensation:=Vl(FetchElm(T2RetNo, SalDivSetFNo, j)); // 20200828
            MultiplePercent := 100 / HowMany;
            //jm is loop index i.e 1 to 10 scenarios
            if AnalysisType='SD' then
            Begin
             For jm := 0 to Howmany do // k is the additional //20200824
             Begin
              DivPercent:=jm*MultiplePercent;
              Dividends:=Compensation*DivPercent/100;//Compensation -(Jm * Compensation *MultiplePercent / 100); //20200829
              Salary := Compensation - Dividends;
              //==========================
              Multcnt := JM;      //needed It is the index to mult enties
              RecalcT1T2AndCopyToSalDiv(T2RetNo, T1RetNo, Sin, Salary, Dividends, Age,Option, Multcnt);
              SALDIV(T2RetNo, 'SALDIV', SalDivFNo); // needed  //20200831
             end;
            End

            Else if AnalysisType='S' then //Varying Salary
            Begin
             For jm := 0 to HowMany do
             Begin
               Salary :=Compensation -(Jm * Compensation *MultiplePercent / 100); //x is compensation from set up //20200828B
               DivPercent:=Vl(FetchElmFNo(T2RetNo,SalDivSetFNo,J2));
               Dividends:=Salary*DivPercent/100;

               Multcnt := Jm;      //needed It is the index to mult enties
               RecalcT1T2AndCopyToSalDiv(T2RetNo, T1RetNo, Sin, Salary,
                 Dividends, Age,Option, Multcnt);
               SALDIV(T2RetNo, 'SALDIV', SalDivFNo); // needed  //20200823
             end;
            End;
          end;
        end;

        //put header info into saldiv forms
        // multCombinations cannot be done here.  It s/b done instate the CopyT2
        // CopyHeader data to SalDiv form
        FNo := GetSalDivFNo(T2RetNo, Sin);
        S := FetchElmFNo(T2RetNo, SalDivSetFNo, I); // sin from saldivset form
        If Sin = S then
        Begin
          // HEADER INFO BEFORE THE TABLE WITH OPTIONS FOR CORP AND SHAREHOLDERS
          Ret[T2RetNo].Frm[FNo].Strings[4] := GetFirstName(T1RetNo) + ' ' + GetLastName(T1RetNo);

          if FetchElmFNo(T2RetNo, SalDivSetFNo, 14) > '' then
            Ret[T2RetNo].Frm[FNo].Strings[7] := 'For tax year ' +
              FetchElmFNo(T2RetNo, SalDivSetFNo, 16)
          Else
            Ret[T2RetNo].Frm[FNo].Strings[7] := 'For tax year ' +
              FetchElmFNo(T2RetNo, SalDivSetFNo, 20);

          Compensation := Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, j));
          Age:=FetchElmFNo(T2RetNo, SalDivSetFNo,jjj);
          Ret[T2RetNo].Frm[FNo].Strings[5] :=
            FormatFloat('#########', Compensation);
          Ret[T2RetNo].Frm[FNo].Strings[25] := Ret[T2RetNo].Frm[FNo].Strings[5];

          // option 2
          x := Compensation * Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, j1)) / 100;
          Ret[T2RetNo].Frm[FNo].Strings[28] := FormatFloat('#########', x);
          x := Compensation * Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, j2)) / 100;
          Ret[T2RetNo].Frm[FNo].Strings[29] := FormatFloat('#########', x);
        End;

        //Init SALDIVM form from multiple
        SalDivMFNo := GetSalDivMFNo(T2RetNo, Sin);
        S := FetchElmFNo(T2RetNo, SalDivSetFNo, I); // sin from saldivset form
        If Sin = S then
        Begin
          FillHeader(T2RetNo,SalDivMFNo,1,2,3);
          Ret[T2RetNo].Frm[SalDivMFNo].Strings[4] := GetFirstName(T1RetNo) + ' ' + GetLastName(T1RetNo);
        End;
        if HowMany < 2 then
        begin
          OpenForm(T2RetNo, GetFormName(FNo), 0) // saldiv form
        end
        Else
        Begin
          OpenForm(T2RetNo, GetFormName(SalDivMFNo),0); // saldivM form
        end;

        if TestMode then
         //ok
        Else
         ClearT4T5SalDiv(T2RetNo, T1RetNo, Sin);
        // remove the adjustments from the T1 //done alredy
        GifiFNo := GetFormNo('S125#1');
        StoreElm(T2RetNo, GifiFNo, 86, '');
        // remove the gifi adjustment for salaries
      end; // options
    End; // sin
    Inc(I, 1);
    Inc(j, 1);
    Inc(j1, 1); // 20200819
    Inc(j2, 1); // 20200819
  Until I > 65; // MaxShareHolders;
  SalDivMode := False;    //20200831
  CloseAllSalDivT1Returns; // put back on 20200824
  Screen.Cursor := crDefault; //20200908
End;

Procedure RecalcT1T2AndCopyToSalDiv(T2RetNo: Integer; T1RetNo: Integer;
  Sin: String; Salary: Real; Dividends:Real; Age:String; Option: Integer;
  Multcnt: Integer);
Var
  I, j, k, GifiFNo, SalDivFNo,SaldivMFNo: Integer;
  SalDivFName: String;
  x: Real;
  SinNdx: Integer;
  TotalCpp:Real;
  TotalEi:Real;
  CPP,EI:Real;
Begin
  SalDivFNo := GetSalDivFNo(T2RetNo, Sin); // GetFormNo('SALDIV');  //20200823
  SalDivMFNo := GetSalDivMFNo(T2RetNo, Sin); // GetFormNo('SALDIV');  //20200831 10pm
  // t1
  CPP:=SalDivCpp(Age,TaxYear,Salary,12,12);
  EI:=SalDivEI(T2RetNo,SIN,TaxYear,Salary,12,12);
  //t1
  SalDivChangeT4(T2RetNo, T1RetNo, Sin, Salary,CPP,EI,0, Option); //salary change for t1 and t2
  SalDivChangeT5(T2RetNo, T1RetNo, Sin, 0, Dividends, Option); //only the dividends
  RetList[T1RetNo].RecalcEveryThing;   //calc the T1 in Full
  CopyT1dataToSalDiv(T2RetNo, T1RetNo, Sin, Salary, Dividends, Age, Option, Multcnt);

  // T2
  SalDivChangeT2GIFI(T2RetNo, Salary, Dividends, Option);  //Put salary in S125
  CalcFed(T2RetNo);
  CalcOnt(T2RetNo);
  CalcAlb(T2RetNo); // CalcAll(T2RetNo) may not be wrking
  TotalCpp:=GetSalDivTotalCpp(Age,T2RetNo,Salary,AppYear,12,12,Option); //20200827
  TotalEi:=GetSalDivTotalEI(T2RetNo,Salary,AppYear,Option); //20200827
  x:=Ret[T2RetNo].Ln[360]; //Vl(FetchElm(T2RetNo,'T2',234));  //20201016
  //x:=FormatFloat('##,###,###',Vl(FetchElm(T2RetNo,'T2',232)); //20201016 //Vl(FetchElm(T2RetNo,'T2',234));
  CopyT2DataToSalDiv(T2RetNo, T1RetNo, Sin, Salary,Dividends,TotalCpp,TotalEi,Option, Multcnt);

  SALDIV(T2RetNo, GetFormName(SalDivFNo), SalDivFNo); // 20200823  //moved from above This completes the SalDiv
  if HowMany>1 then CopyMultCombinationsToSalDiv(T2RetNo, SalDivMFNo, SalDivFNo, Salary, Dividends,SIN, Option, Multcnt); //20200901

End;

// REFERENCE ONLY  ==============

// T1App := AppList.AppFromName('T1');  //switch to t1? //20200805 Igor
// T1App.OpenReturn(DataDir, FlName, True, False); //20200808
// T1RetNo:=OpenT1Return(T2RetNo,DataDir,FlName); //20200809 It works also
// RetList[T1RetNo].Close(True);  //seems to work if not displayed
// CurrentApp := RetList[T1RetNo].MyApp;
// CurrentApp := AppT2;
// RetList[I].SourceFlName:=RetList[I].SourceFlName+'Opt1';
// saving
// SaveId:='SAL-100-Div-000';
// StoreElm(T1RetNo,'INFO',2,'SAL-100-Div-000+GetFirstName(T1RetNo));  //20200808  Change the Name'
// RetList[T1RetNo].DoSave;  //stops does nothing
// RetList[T1RetNo].Close(True);  //seems to work if not displayed
// T1App.SaveReturn(DataDir, FlName, True, False); //20200808  //doe not work
// T1App.doSave(DataDir, FlName, True, False);  //does not pass syntax

{ INTERESTING: Switch Apps?
  ApplicationState := ApplicationState + [asSilentSave];
  try
  CurrentApp := RetList[T1RetNo].MyApp;
  try
  //RetList[T1RetNo].DoSave;  //stops
  //RetList[T1RetNo].Close(True); //one went through
  finally
  CurrentApp := AppT2;
  end;
  finally
  ApplicationState := ApplicationState - [asSilentSave];
  end;
}
//
// SaveReturn(T1RetNo,T1DataDir,SaveId+'-'+FlName,True,False,False,True,nil);
// SaveReturn(T1RetNo,T1DataDir,FlName,OverrideSWTrue,UpdMostRecentFalse,ATextFormatFalse,AUpdateClientTableTruwe,AClouds0);
// SaveReturn(RetNo,DataDir,FlName,OverrideSW,UpdMostRecent,,ATextFormat,AUpdateClientTable,AClouds);
{ Function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;OverrideSW: boolean;
  UpdMostRecent: boolean; ATextFormat: boolean = False;
  AUpdateClientTable: boolean = True; AClouds: TArrayOfInteger = nil): Integer; }

// END OF REFERENCE ONLY  ==============

Function OpenT1Return(T2RetNo: Integer; DataDir: String; FlName: String)
  : Integer; // T1RetNo
Var
  I: Integer;
  T1RetNo: Integer;
  T1App: TApp;
Begin
  if FlName = '' then
    exit;

  T1App := AppList.AppFromName('T1'); // Get the T1App
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;

  Result := -1;
  for I := 0 to RetList.Count - 1 do
  Begin
    if Assigned(RetList[I]) and (RetList[I].MyApp = T1App) and
      SameText(RetList[I].SourceFlName, FlName) and
      SameText(RetList[I].SourceDataDir, DataDir) { not sure if it is needed }
    // 20200808
    then
    begin
      Result := I;
      break;
    end;
  End;

  if Result = -1 then
  begin
    if not FileExists(TPath.Combine(DataDir, FlName)) then
    begin
      showmessage('File ' + QuotedStr(FlName) + ' was not found in ' +
        QuotedStr(DataDir));
      exit;
    end;
    try
      Begin
       If testMode then
         Result := T1App.OpenReturn(DataDir, FlName, True, False) // 20200826 //show it
       Else
         Result := T1App.OpenReturn(DataDir, FlName, False, False) // 20200808  //does not show it
      end
    except
      on E: exception do
      begin
        showmessage('Error occured while opening return: ' + E.Message);
        exit;
      end;
    end;
  end;
  OpenForm(T2RetNo, 'SALDIVSET', 0); // 20200801
end;

Function GetT1RetNoFromSin(DataDir, Sin: String): Integer; // T1RetNo
Var
  I: Integer;
  T1RetNo: Integer;
  T1App: TApp;
  FlName: String;
Begin
  Result := -1;
  FlName := LeftStr(Sin, 8) + '.' + RightStr(Sin, 1);
  If FlName = '' then
    exit;

  T1App := AppList.AppFromName('T1'); // Get the T1App
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;
  // 20200730
  Result := -1;
  for I := 0 to RetList.Count - 1 do
  Begin
    // ShowMessage('Source= '+RetList[I].SourceDataDir);  //abends
    if Assigned(RetList[I]) and not RetList[I].Destroying and
      (RetList[I].MyApp = T1App) and SameText(RetList[I].SourceDataDir, DataDir)
    // SameText(RetList[I].SourceFlName, FlName)
    then
    begin
      Result := RetList[I].RetNo;
      exit;
    end;
  End;
end;

Procedure SALDIVSet(RetNo: Integer; FName: string; FNo: Integer);
var
  I, j, ii, iii, iiii, k: Integer;
  Sin, FlName, CalcBox: String;
  SinNdx, NameNdx, PercentOfTotalNdx, CompensationAmountNdx, PercentSalaryNdx,
    PercentDividendsNdx,EmployeeNdx,AgeNdx:Integer;
  T1App: TApp;
  T1RetNo, T2RetNo, GifiFNo: Integer; // 20190621 Igor
begin
  if SalDivMode = False then ClearAllSalDivForms(T2RetNo); // 20200820

  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    if Strings[15]>'' then TestMode:=True else TestMode:=False;  //20200828B Testmode

    FillHeader(RetNo, FNo, 1, 2, 3);

    //20200901
    if Strings[49]+Strings[9]='' then Strings[49]:='X';
    if strings[49]>'' then
    begin
        If Strings[46]='' then Strings[46]:='1';
        If Strings[48]='' then Strings[48]:='1';
    end;

    if Vl(Strings[46])>48 then strings[46]:='48';  //max how many
    if Vl(Strings[48])>48 then strings[48]:='48';  //max how many

    //2025010921231
    Strings[16] := '2024';   //20201211
    Strings[20] := '2025';    //20201211
    //Strings[14] := 'X'; // t1 tax rates Only current year //20201211
    if Strings[14] + Strings[19] = '' then Strings[19] := 'X'; // t1 tax rates [14] is the current T1 app
    if Strings[21] + Strings[22] = '' then Strings[21] := 'X';
    if Strings[14] > '' then
      RY := 1
    else
      RY := 0;

    // get payroll gifi accounts
    GifiFNo := GetFormNo('S125#1');
    k := GifiLineToElm(RetNo, GifiFNo, '9066');
    If k > 0 then
      Tv[23] := Vl(FetchElmFNo(RetNo, GifiFNo, k + 1));

    k := GifiLineToElm(RetNo, GifiFNo, '9060');
    If k > 0 then
      Tv[24] := Vl(FetchElmFNo(RetNo, GifiFNo, k + 1));

    k := GifiLineToElm(RetNo, GifiFNo, '9065');
    If k > 0 then
      Tv[25] := Vl(FetchElmFNo(RetNo, GifiFNo, k + 1));

    k := GifiLineToElm(RetNo, GifiFNo, Strings[18]);
    If k > 0 then
      Tv[26] := Vl(FetchElmFNo(RetNo, GifiFNo, k + 1));

    Tv[27] := 0;
    for k := 23 to 26 do
    begin
      Tv[27] := Tv[27] + Tv[k];
    end;
    Tv[47]:=Tv[27];  //20200827

    // populate SINS  from s50 or the T1 //20200802

    SinNdx := 51;
    NameNdx := 66; // Name ndx
    AgeNdx:=191;
    FlName := LeftStr(Strings[SinNdx], 8) + '.' + RightStr(Strings[SinNdx], 1);
    Sin:=Strings[SinNdx];
    j := 4; // ndx to S50
    Repeat
      Sin:=Strings[SinNdx];
      if (Sin>'') and (Strings[AgeNdx]='') then Strings[AgeNdx]:='50';
      if FetchElm(RetNo, 'S50', j + 2) > '' then
      Begin
        Strings[SinNdx] := FetchElm(RetNo, 'S50', j + 2); // sin
        Strings[NameNdx] := FetchElm(RetNo, 'S50', j); // name
      end;

    (* N/A here
      //get age,name etc
      T1App := AppList.AppFromName('T1');
      if not Assigned(T1App) then begin showmessage('T1 App was not found'); exit;end;
      T1RetNo := GetT1ReturnNo(Strings[10], FlName);
      if T1RetNo>0 then
      Begin
       Strings[AgeNdx]:=FetchElm(T1RetNo,'TAXSUM',157); //age
       Strings[NameNdx]:=FetchElm(T1RetNo,'TAXSUM',2); //Name
      end;
     *)
      Inc(SinNdx, 1);
      Inc(NameNdx, 1);
      Inc(AgeNdx, 1);
      Inc(j, 5);
    Until SinNdx > 65;

    MaxShareholders := 0;
    SinNdx := 51;
    Repeat
      if Strings[SinNdx] > '' then
        MaxShareholders := MaxShareholders + 1;
      Inc(SinNdx, 1);
    until SinNdx > 65;

    Tv[7] := 0;
    Tv[30] := 0;
    PercentOfTotalNdx := 101; // % amount
    CompensationAmountNdx := 81; // compensation
    PercentSalaryNdx := 31; // % of compens
    PercentDividendsNdx := 161; // Dividend %
    EmployeeNdx:=141;   //20200824
    SinNdx := 51;
    AgeNdx:=191;
    Repeat
      if Strings[SinNdx] > '' then
      Begin
        if Vl(Strings[PercentSalaryNdx]) + Vl(Strings[PercentDividendsNdx]) = 0
        then
        Begin
          Strings[PercentSalaryNdx] := '100';
          Strings[PercentDividendsNdx] := '0';
        end;

        if (Strings[4] > '') and (Strings[PercentOfTotalNdx] > '') then
          Tv[CompensationAmountNdx] := Tv[8] *
            Vl(Strings[PercentOfTotalNdx]) / 100;

        Strings[PercentSalaryNdx] := FormatFloat('####.##',
          (100 - Vl(Strings[PercentDividendsNdx])));

        if Vl(Strings[PercentSalaryNdx]) > 100 then
          Strings[PercentSalaryNdx] := '0';

        if Vl(Strings[PercentDividendsNdx]) > 100 then
          Strings[PercentDividendsNdx] := '0';
        if Vl(Strings[PercentSalaryNdx]) + Vl(Strings[PercentDividendsNdx]) > 100
        then
          Strings[PercentDividendsNdx] := '0';

        if Strings[EmployeeNdx]='' then Strings[employeeNdx]:='Y';
      End
      Else //No sin    //20200829
      Begin
       Strings[PercentSalaryNdx] := '';
       Strings[PercentDividendsNdx] := '';
       Strings[NameNdx]:='';
       Strings[AgeNdx]:='';
       Strings[EmployeeNdx]:='';
       Tv[CompensationAmountNdx]:=0;
       Tv[PercentOfTotalNdx]:=0;
      End;

      Tv[7] := Tv[7] + Tv[CompensationAmountNdx];
      Tv[30] := Tv[30] + Vl(Strings[101]);
      Inc(SinNdx, 1);
      Inc(PercentOfTotalNdx, 1);
      Inc(CompensationAmountNdx, 1);
      Inc(PercentSalaryNdx, 1);
      Inc(PercentDividendsNdx, 1);
      Inc(EmployeeNdx, 1);
      Inc(AgeNdx, 1);
    Until SinNdx > 65;

    // Open the T1 returns
    T1App := AppList.AppFromName('T1'); // Get the T1App

    if not Assigned(T1App) then
    begin
      showmessage('T1 App was not found');
      exit;
    end;

    //201201212
    {
    if Assigned(T1App) then
    Begin
      Strings[10] := T1App.Dir_Cur;
      Strings[11] := T1App.Dir_Cur + 'Planner'; // 20200811
    End;
    }
   {20201212
    // T2 data dir
    if Strings[12] = '' then
      Strings[12] := OptRec.Dir_Cur;
    if Strings[13] = '' then
      Strings[11] := OptRec.Dir_Cur + 'Planner';
    // OptRec.Dir_Planner; //20200811
   }

  end; // with
  SaveTv(RetNo, FName, FNo);
end;

Procedure SetUpSalDivInstances(RetNo: Integer); // FName: string; FNo: Integer);
var
  Sin, FlName, DataDir: String;
  // SinNdx,SalNdx,DivNdx, CalcBoxNdx:Integer;
  Salary, Dividends: Real;
  T1App: TApp;
  I, j, Inst, T1RetNo: Integer;
  jj, jjj: Integer;
  // for detal calculations
  SalDivFName: String;
  SalDivFInst: String;
  SalDivFNo: Integer;
  AmountRequired: Real;
begin
  DataDir := FetchElmFNo(RetNo, SalDivSetFNo, 10);

  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;

  // 20200803
  // copy from set up form
  T1RetNo := 0;
  I := 51;
  j := 81; // for amount required
  Inst := 1;
  Repeat
    Sin := FetchElmFNo(RetNo, SalDivSetFNo, I);
    T1RetNo := GetT1RetNoFromSin(DataDir, Sin); // get the t1retNo
    // Now calc detail schedules
    if (Sin > '') and (T1RetNo > 0) then
    Begin
      SalDivFName := 'SALDIV' + '#' + IntToStr(Inst);
      SalDivFNo := GetFormNo(SalDivFName);
      StoreElm(RetNo, SalDivFNo, 12, IntToStr(T1RetNo));
      StoreElm(RetNo, SalDivFNo, 13, IntToStr(SalDivFNo));
      OpenForm(RetNo, SalDivFName, 0); // 20200801
    End;
    // prepare the next SalDiv form
    Inc(Inst, 1);
    SalDivFNo := AddNextInstance(RetNo, SalDivFName); // previous fno
    if GetFormNo(SalDivFName) = 0 then
      showmessage('Cannot create form ' + SalDivFName);
    Inc(I, 1);
    Inc(j, 1);
  Until I > 65;
End;

Function SalDivCpp(Age:String;TaxYear: String; PensEarnings: Real; CPPPeriods: Integer;
  TotPeriods: Integer): Real;
Var
  GrossPerPeriod, ExemptPerPeriod, CPPPerPeriod: Real;
  ProrBasicExemption: Real;
  CppRate: Real;
  MaxCppPremium, MaxCppEarnings: Real;
Begin
  If (Age<'18') or (Age>'70') then begin Result:=0;Exit;end; //20200827
  ExemptPerPeriod := 3500 / TotPeriods; // 20171223
  ProrBasicExemption := ExemptPerPeriod * CPPPeriods;
  Result := MaxR(0, PensEarnings - ProrBasicExemption) * T1Constant[RY].CppRate;
  if Abs(Result - T1Constant[RY].MaxCppPremium) < 0.02 then
    Result := T1Constant[RY].MaxCppPremium;
  Result := MinR(Result, T1Constant[RY].MaxCppPremium);
end;

{ // REFERENCE ONLY -----------------------------------------------------
  T2RetNo := GetCurrentRetNo;
  // T2Salary := FetchElm(T2RetNo, 'TESTFRM', 14);
  StoreElm(T2RetNo,'S125#1', GifiLineToElm(T2RetNo, GetFormNo('S125#1'), '9066'), Salary);
  CalcFed(T2RetNo);
  CalcAlb(T2RetNo);
  //UpdateAllVisibleForms;  //in ntMulti uses PopulateFormWithData;
}
(* IGOR original
  T2RetNo := GetCurrentRetNo;
  PrepareForeignreturn(FD);
  if Assigned(FD) then
  begin
  T1RetNo := FD.RetNo;
  T2Salary := FetchElm(T2RetNo, 'TESTFRM', c_Element_TESTFRM_Salary);
  StoreElm(T1RetNo, 'T4#1', c_Element_T1T41_2, T2Salary);
  RetList[T1RetNo].CalcAll;
  StoreElm(RetNo,'S125#1', GifiLineToElm(RetNo, GetFormNo('S125#1'), '8960'), T2Salary);
  CalcFed(RetNo);
  CalcAlb(RetNo);
  RetList[T2RetNo].CalcAll;
  ApplicationState := ApplicationState + [asSilentSave];
  try
  CurrentApp := RetList[T1RetNo].MyApp;
  try
  RetList[T1RetNo].DoSave;
  RetList[T1RetNo].Close(True);
  finally
  CurrentApp := AppT2;
  end;
  finally
  ApplicationState := ApplicationState - [asSilentSave];
  end;
  PopulateFormWithData;
  end;
*)     // END OF REFERENCE ----------------------------------------------------
// end;

Function GetSalDivFNo(T2RetNo: Integer; Sin: String): Integer;
// sin not used
Var
  I: Integer;
  FName: String;
  FNo: Integer;
Begin

  Result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = 'SALDIV' then
    Begin
      FNo := FRec.FormNo;
      If FetchElm(T2RetNo, FNo, 6) = Sin then
      Begin
        Result := FNo;
        break; // exit;
      End;
    End;
  end;
End;

Function GetSalDivMFNo(T2RetNo: Integer; Sin: String): Integer;
// sin not used
Var
  I: Integer;
  FName: String;
  FNo: Integer;
Begin

  Result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = 'SALDIVM' then
    Begin
      FNo := FRec.FormNo;
      If FetchElm(T2RetNo, FNo, 6) = Sin then
      Begin
        Result := FNo;
        break; // exit;
      End;
    End;
  end;
End;



Procedure SalDivChangeT2GIFI(T2RetNo: Integer; Salary: Real; Dividends: Real;
  Option: Integer);
Var
  Elm, GifiFNo:integer;
  x, y: Real;
Begin
  // 20200816
  GifiFNo := GetFormNo('S125#1');
  if SalDivMode then
  Begin
    x := Salary; //Dividends must not be added; // 20200819 8PM   //20200826
    // dividends are not affecting the return, but they affecr the Retained earnings
    StoreElm(T2RetNo, GifiFNo, 86, FormatFloat('#########', x));
    y:=Vl(FetchElmFNo(T2RetNo, GifiFNo, 86));  //to see / confirm
  End;
End;




Procedure SALDIV(RetNo: Integer; FName: string; FNo: Integer);
var
  T1App: TApp;
  I, j, jj, jjj, j1, j2, k: Integer; // 20190621 Igor
  Sin: String;
  DataDir: String;
  S: String;
  AmountRequired: Real;
  T1RetNo: Integer;
  // T1FNo:Integer;  ? how do I get it?
  // 20200805 Igor >>>
  T1SINElementNo: Integer;
  SalDivInstanceNo: Integer;
  NeedCloseT1Ret: Boolean;
  // 20200805 Igor <<<
  T1TaxableIncome: Real; // 20200807
  x: Real;
  Compensation: Real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    for I := 1 to 229 do // 231 do  //20200823
    begin
      Tv[I] := 0;
    end; // LoadTv(RetNo, FName, FNo);  //20200819 INSTEAD of LoadTv

    // =========  //Get T2 data   ==========================
    FillHeader(RetNo, FNo, 1, 2, 3);
    // % and Div
    Tv[5] := Vl(Ret[RetNo].Frm[FNo].Strings[5]); //

    // ========Get T1 data ===========================
    T1App := AppList.AppFromName('T1'); // switch to t1? //20200805 Igor
    if not Assigned(T1App) then
    begin
      showmessage('T1 App was not found');
      exit;
    end;

    SalDivInstanceNo := ExtractFormInstNo(FName);
    T1SINElementNo := 50 + SalDivInstanceNo;
    Sin := FetchElmFNo(RetNo, SalDivSetFNo, T1SINElementNo);
    if Sin = '' then
    Begin
       Sin := FetchElmFNo(RetNo, SalDivSetFNo, T1SINElementNo+1);  //20201212 CON Thre is no 0 elm Starts from 51
     // exit; //20201212
    end;

    // 20200805 Igor <<<
    DataDir := T1App.Dir_cur; // 20201212 //FetchElmFNo(RetNo, SalDivSetFNo, 10);
    T1RetNo := GetT1RetNoFromSin(DataDir, Sin);
    If (T1RetNo < 1) { or (T1RetNo>15) } then // exit;  //20200731 //20200805 Igor
    begin
      T1RetNo := T1App.OpenReturn(DataDir, LeftStr(Sin, 8) + '.' + RightStr(Sin,1), False);
      NeedCloseT1Ret := True;
    end
    else
      NeedCloseT1Ret := False;

    if T1RetNo = -1 then exit;

    // ============  Do the rest of calculations  ================
    // All other data come from CopyData to strings arrays of the form
    for I := 31 to 275 do // 229 do  //20200823
    begin
      Tv[I] := Vl(Ret[RetNo].Frm[FNo].Strings[I]);
    End; // 20200814

    // After fetching all, do other calcs on the form
    // for the convenience of coding - so we can can use the global variable TV

    I := 127; // total inc tax
    j := 109; // feder tax
    jj := 121; // prov tax
    Repeat
      Tv[I] := Tv[j] + Tv[jj]; // tot inc tax shareolder only
      Inc(I, 1);
      Inc(j, 1);
      Inc(jj, 1);
    until I > 131;

    I := 139; // tfsa
    j := 133;
    Repeat
      if FetchElm(RetNo, SalDivSetFNo, 29) > '' then
        Tv[I] := Tv[j] // conditional on tfsa indicator
      Else
        Tv[I] := 0;
      Inc(I, 1);
      Inc(j, 1);
    Until I > 143;

    Tv[163] := Tv[79] - Tv[127] - Tv[133];
    Tv[164] := Tv[80] - Tv[128] - Tv[134] - Tv[140];
    Tv[165] := Tv[81] + Tv[87] - Tv[129] - Tv[135] - -Tv[141];

    I := 43; // avlbl for dividends
    j := 31; // income before taxes
    jj := 187; // Cpp
    jjj:=114;  //ei
    j1:=61;   //fed tax
    J2:=67;   //prov tax
    Repeat
      Tv[I] := Tv[j] - Tv[jj]-Tv[jjj]-Tv[j1]-Tv[j2];
      Inc(I, 1);
      Inc(j, 1);
      Inc(jj, 1);
      Inc(jjj, 1);
      Inc(j1, 1);
      Inc(j2, 1);
    until I > 45;

    Tv[146]:=Tv[43]-0;
    Tv[147]:=Tv[44]-0;
    Tv[148]:=Tv[45]-Tv[40];

    //end of page
    I := 49; // corp tax
    j := 61; // Corp fed tax
    jj := 67; // Corp prov tax
    Repeat
      Tv[I] := Tv[j] + Tv[jj]; // corp tax=crp fed+Corp provincial
      Inc(I, 1);
      Inc(j, 1);
      Inc(jj, 1);
    until I > 51;

    I := 216; // pers tax
    j := 109; // pers fed tax
    jj := 121; // pers prov tax
    Repeat
      Tv[I] := Tv[j] + Tv[jj];
      Inc(I, 1);
      Inc(j, 1);
      Inc(jj, 1);
    until I > 219;

    I := 221; // corp cpp
    j := 187; // corp cpp
    jj:=114;
    Repeat
      Tv[I] := Tv[j]+Tv[jj];  //20200825
      Inc(I, 1);
      Inc(j, 1);
      Inc(jj,1);
    until I > 224;

    I := 193; // empl cpp
    j := 133; // empl cpp  above
    Repeat
      Tv[I] := Tv[j];
      Inc(I, 1);
      Inc(j, 1);
    until I > 196;

    I := 169; // Grand tot income tax
    j := 49; //
    jj := 216; //
    jjj := 221; //
    j1 := 193; //
    j2 := 139; //    //20200829
    Repeat
      Tv[I] := Tv[j] + Tv[jj] + Tv[jjj] + Tv[j1] + Tv[j2];
      Inc(I, 1);
      Inc(j, 1);
      Inc(jj, 1);
      Inc(jjj, 1);
      Inc(j1, 1);
      Inc(j2, 1);
    until I > 172;

    I := 199; // after tax of shareholder
    j := 163;
    Repeat
      Tv[I] := Tv[j];
      Inc(I, 1);
      Inc(j, 1);
    until I > 202;

    Tv[35]:=Tv[170]-Tv[171];  //20200828

    Tv[76]:=Tv[146]+Tv[163];  //20200828
    Tv[77]:=Tv[147]+Tv[164];
    Tv[78]:=Tv[148]+Tv[165];

    // put the TV's back on the form
    for I := 31 to 275 do
    begin
      Ret[RetNo].Frm[FNo].Strings[I] := FormatFloat('#########', Tv[I]);
    End;
    // if (RetList[RetNo].MyApp = AppT2) then //20160323 Igor
    // if (RetList[RetNo].Frm[Fno].Count = 0) then
    // SaveTv(RetNo,FName,FNo);  //20200807 con experiment
    // 20200805 igor >>>
    if NeedCloseT1Ret then
      RetList.Items[T1RetNo].Close(True);
    // 20200805 Igor <<<
    // ***********************  DO NOT use SAVETV ON THE SALDIV  ****************
  end;
end;

Procedure SALDIVM(RetNo: Integer; FName: string; FNo: Integer);
var i:Integer;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    for i:=51 to 434 do Tv[i]:=0;
    for i:=51 to 434 do Tv[i]:=Vl(Strings[I]);
  end;
end;


// 20200815
Procedure CopyT2DataToSalDiv(T2RetNo: Integer; T1RetNo: Integer; Sin: String;
  Salary: Real; Dividends: Real; TotalCpp:Real; TotaEi:Real; Option: Integer; Multcnt: Integer); // 0200815
Var
  FNo, jj,k: Integer;
  S, S0, S1, S2: String; // integer;
  x, y: Real;
  EarningsForCpp: Real;
Begin
  //if MultCnt >1 then Exit;  //20200831 7pm

  FNo := GetSalDivFNo(T2RetNo, Sin);
  Ret[T2RetNo].Frm[FNo].Strings[37] := '';  //salay
  Ret[T2RetNo].Frm[FNo].Strings[38] := Ret[T2RetNo].Frm[FNo].Strings[25];
  Ret[T2RetNo].Frm[FNo].Strings[39] := Ret[T2RetNo].Frm[FNo].Strings[28];
  Ret[T2RetNo].Frm[FNo].Strings[40] := Ret[T2RetNo].Frm[FNo].Strings[29];

  if Option=0 then   //20200829  //but 214 this is Net Income
  Begin   //income tax before
   Ret[T2RetNo].Frm[FNo].Strings[31] := FormatFloat('#########',Vl(FetchElmFNo(T2RetNo, T2FNo, 214)));
   Ret[T2RetNo].Frm[FNo].Strings[32] := Ret[T2RetNo].Frm[FNo].Strings[31];
   Ret[T2RetNo].Frm[FNo].Strings[33] := Ret[T2RetNo].Frm[FNo].Strings[31];
   Ret[T2RetNo].Frm[FNo].Strings[34] := Ret[T2RetNo].Frm[FNo].Strings[31];
  End;
  // income before taxes and salaries s:=Ret[T2RetNo].Frm[FNo].Strings[31+k];  //test only

  EarningsForCpp := Vl(Ret[T2RetNo].Frm[FNo].Strings[37 + Option]);
  Ret[T2RetNo].Frm[FNo].Strings[187 + Option] :=
    FormatFloat('#########', TotalCpp);  //20200827

  Ret[T2RetNo].Frm[FNo].Strings[114 + Option] :=
    FormatFloat('#########', GetSalDivTotalEI(T2RetNo, Salary, AppYear, Option)); // 20200824

  x:=Vl(FetchElmFNo(T2RetNo, T2FNo, 234));       //taxable income
  Ret[T2RetNo].Frm[FNo].Strings[55 + Option] :=
         FormatFloat('#########', Vl(FetchElmFNo(T2RetNo, T2FNo, 232))); //20201212
 //   FormatFloat('#########', Vl(FetchElmFNo(T2RetNo, T2FNo, 234)));
  // taxable income

  x := Vl(FetchElmFNo(T2RetNo, T2FNo, 709));
  y := Vl(FetchElmFNo(T2RetNo, T2FNo, 711));
  Ret[T2RetNo].Frm[FNo].Strings[61 + Option] :=
    FormatFloat('#########', Vl(FetchElmFNo(T2RetNo, T2FNo, 709)));
  // Federal taxes\

  Ret[T2RetNo].Frm[FNo].Strings[67 + Option] :=
    FormatFloat('#########', Vl(FetchElmFNo(T2RetNo, T2FNo, 711)));
  // Provincial taxes
End;

Procedure CopyT1dataToSalDiv(T2RetNo: Integer; T1RetNo: Integer; Sin: String;
  Salary: Real; Dividends: Real; Age:String; Option: Integer; Multcnt: Integer);
Var
  I, k, FNo:Integer;
  x: Real;
  jj: Integer;
Begin
  FNo := GetSalDivFNo(T2RetNo, Sin);
  Ret[T2RetNo].Frm[FNo].Strings[42]:= Ret[T2RetNo].Frm[FNo].Strings[4]; //20200828B  //sharh name
  // salary
  Ret[T2RetNo].Frm[FNo].Strings[79] := '';
  Ret[T2RetNo].Frm[FNo].Strings[80] := Ret[T2RetNo].Frm[FNo].Strings[38];
  // 20200821  //Ret[T2RetNo].Frm[FNo].Strings[25];
  Ret[T2RetNo].Frm[FNo].Strings[81] := Ret[T2RetNo].Frm[FNo].Strings[28];//Ret[T2RetNo].Frm[FNo].Strings[39]; //20200826
  // 20200821; // Ret[T2RetNo].Frm[FNo].Strings[28];
  // dividends
  Ret[T2RetNo].Frm[FNo].Strings[85] := '';
  Ret[T2RetNo].Frm[FNo].Strings[86] := '';
  Ret[T2RetNo].Frm[FNo].Strings[87] := Ret[T2RetNo].Frm[FNo].Strings[29];

  Ret[T2RetNo].Frm[FNo].Strings[73 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'T1', 236)));

  Ret[T2RetNo].Frm[FNo].Strings[142 + Option] :=FormatFloat('#########',Vl(FetchElm(T1RetNo, 'T1', 321))); //Clawback //0 if negative //20200929

  Ret[T2RetNo].Frm[FNo].Strings[100 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'T1', 307))); //child care

  x:=Vl(FetchElm(T1RetNo, 'RRSPNXT', 3));
  if x<0 then x:=0;
  Ret[T2RetNo].Frm[FNo].Strings[118 + Option] :=FormatFloat('#########', x); //RRSP NEXT year

  Ret[T2RetNo].Frm[FNo].Strings[52 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'T1033', 24))); //Instalments


  Ret[T2RetNo].Frm[FNo].Strings[151 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'T1', 322))); // net income
  // T1 net income /20200807
  Ret[T2RetNo].Frm[FNo].Strings[91 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'T1', 339)));
  // T1 taxable income
  Ret[T2RetNo].Frm[FNo].Strings[157 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'T1', 143)));
  // T1 fed div tax credi
  Ret[T2RetNo].Frm[FNo].Strings[97 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'T1', 55)));
  // T1 fed nor rf creits
  Ret[T2RetNo].Frm[FNo].Strings[109 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'T1', 128)));
  // T1 federal tax
  Ret[T2RetNo].Frm[FNo].Strings[103 + Option] :=
    FormatFloat('#########', Vl(FetchElm(T1RetNo, 'DTC', 9))); // T1 prov dtc // T1 tot prov credits
  //Total prov tax //20200829
  Ret[T2RetNo].Frm[FNo].Strings[121 + Option] :=
    FormatFloat('#########',
     Vl(FetchElm(T1RetNo, 'T1', 412))    //cpp
     +Vl(FetchElm(T1RetNo, 'T1', 453))    //ei
     +Vl(FetchElm(T1RetNo, 'T1', 413))    //clawback
     +Vl(FetchElm(T1RetNo, 'T1', 416))    //prov tax from Prov428
     +Vl(FetchElm(T1RetNo, 'T1', 403))); // Yukon first nation

  Ret[T2RetNo].Frm[FNo].Strings[133 + Option] :=
    FormatFloat('#########', SalDivCpp(Age,AppYear, Salary, 12, 12)); // empl CPP

  // tfsa 20200823
  if FetchElm(T2RetNo, SalDivSetFNo, 29) > '' then  //tfsa
  Begin
    Ret[T2RetNo].Frm[FNo].Strings[139 + Option] := Ret[T2RetNo].Frm[FNo].Strings[133 + Option];
    //Ret[T2RetNo].Frm[FNo].Strings[226 + Option] := Ret[T2RetNo].Frm[FNo].Strings[133 + Option];  //Out 20200829}
  End
  else
  Begin
    Ret[T2RetNo].Frm[FNo].Strings[139 + Option] := '';
    //Ret[T2RetNo].Frm[FNo].Strings[226 + Option] := '';  //20200829
  End;

End;

Procedure SalDivChangeT4(T2RetNo: Integer; T1RetNo: Integer; Sin: String; Salary: Real; Dividends: Real;CPP:Real;EI:Real; Option: Integer);
Var
  I, Elm,GifiFNo: Integer;
  T1App: TApp;
  FNo: Integer;
  HighestT5Inst: String;
  Found: Boolean;
  x, y,z: Real;
Begin
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;
  //change salary in T1 via T1SalDiv
  for I := 0 to (T1App.FList.Count - 1) do
  begin
    FRec := T1App.FList.Items[I];
    FNo := FRec.FormNo;
    If FRec.FormName = 'T1SALDIV' then // T1 picks up the taxable dividends
    Begin
      StoreElm(T1RetNo, FNo, 4, FormatFloat('#########',Salary));
      StoreElm(T1RetNo, FNo, 7, FormatFloat('#########',CPP));
      StoreElm(T1RetNo, FNo, 8, FormatFloat('#########',EI));
      //z:=Vl(FetchElm(T1RetNo, 'T1SALDIV',5));
      Break;
     end;
  end; //i



End;


(*
Procedure SalDivChangeT4(T2RetNo: Integer; T1RetNo: Integer; Sin: String;
  Salary: Real; Dividend: Real; Option: Integer);
Var
  I: Integer;
  T1App: TApp;
  FNo: Integer;
  HighestT4Inst: String;
  Found: Boolean;
  EI: Real;
Begin
  HighestT4Inst := '';
  Found := False;
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;
  Found := False; // 20200821
  if (Found = False) then
  begin
    if (Option = 1) Or (Option = 2)
    or (Option = 0)                    //20200828B
    then // 20200822A
    Begin
      FNo := AddNextInstance(T1RetNo, 'T4' + HighestT4Inst);
      If FNo > 0 then
      Begin
        StoreElm(T1RetNo, FNo, 2, FormatFloat('#########', Salary));
        if EIExempt(T2RetNo, Sin) then
          StoreElm(T1RetNo, FNo, 18, 'X');
        If Salary > 0 then // 20200821
          StoreElm(T1RetNo, FNo, 1, GetCorpName(T2RetNo));
      End;
    end;
  end;
End;
*)
Procedure SalDivChangeT5(T2RetNo: Integer; T1RetNo: Integer; Sin: String;
  Salary: Real; Dividends: Real; Option: Integer);
Var
  I, Elm: Integer;
  T1App: TApp;
  FNo: Integer;
  HighestT5Inst: String;
  Found: Boolean;
  x, y,z: Real;
  // --Main-------------
Begin
  //HighestT5Inst := '';   //Found := False;  //20200828B
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;
  for I := 0 to (T1App.FList.Count - 1) do
  begin
    FRec := T1App.FList.Items[I];
    FNo := FRec.FormNo;
    If FRec.FormName = 'T1SALDIV' then // T1 picks up the taxable dividends
    Begin
      if FetchElmFNo(T2RetNo, SalDivSetFNo, 21) > '' then  //20200828B
      Begin
        x:=T1Constant[RYY].EligDivGrossUpRate;
        y:=Dividends * x;
        StoreElm(T1RetNo, FNo, 5, FormatFloat('#########',Y)); //20200828B
        //z:=Vl(FetchElm(T1RetNo, 'T1SALDIV',5));
      end
      Else
        StoreElm(T1RetNo, FNo, 6, FormatFloat('#########',Dividends * T1Constant[RYY].NonEligDivGrossUpRate));  //20200828B
      Break;   //20200828B
    End;
  end; //i
End;

Function GetT1ReturnNo(DataDir: String; FlName: String): Integer;
Var
  I: Integer;
  T1App: TApp;
Begin
  Result := -1;
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;
  for I := 0 to RetList.Count - 1 do
  Begin
    if Assigned(RetList[I]) and (RetList[I].MyApp = T1App) and
      SameText(RetList[I].SourceFlName, FlName) and
      SameText(RetList[I].SourceDataDir, DataDir) { not sure if it is needed }
    // 20200808
    then
    begin
      Result := I;
      exit;
    end;
  End;
end;

Procedure ClearAllSalDivForms(T2RetNo: Integer);
Var
  I, j, FNo: Integer;
Begin
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if (FRec.FormName = 'SALDIV')
    then
    begin
      FNo := FRec.FormNo;
      if FNo > 0 then
      begin
        For j := 1 to 434 do // 20200823  //229 //20200828
          StoreElm(T2RetNo, FNo, j, ''); // 20200823 J not I
      end;
    end;
  end;
end;

Procedure ClearAllSalDivMForms(T2RetNo: Integer);
Var
  I, j, FNo: Integer;
Begin
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'SALDIVM'  //20200901
    then
    begin
      FNo := FRec.FormNo;
      if FNo > 0 then
      begin
        For j := 1 to 434 do // 20200823  //229 //20200828
          StoreElm(T2RetNo, FNo, j, ''); // 20200823 J not I
      end;
    end;
  end;
end;

Procedure CreateSalDivForms(T2RetNo: Integer; MaxNo: Integer);
Var
  I, FNo: Integer;
Begin
  I := 1;
  Repeat
    FNo := AddNextInstance(T2RetNo, 'SALDIV#' + IntToStr(I)); // creates #2
    Inc(I, 1);
  until I > MaxNo;

  I := 1;
  Repeat
    FNo := AddNextInstance(T2RetNo, 'SALDIVM#' + IntToStr(I)); // creates #2
    Inc(I, 1);
  until I > MaxNo;
end;

Procedure AddSinToSalDivForm(T2RetNo: Integer; Sin: String);
Var
  I, FNo: Integer;
Begin
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if (FRec.FormName = 'SALDIV')
  //  or (FRec.FormName = 'SALDIVM')
    then
    begin
      FNo := FRec.FormNo;
      // ShowMessage('elm 6 '+FetchElmFNo(T2RetNo,FNo,6));
      If FetchElmFNo(T2RetNo, FNo, 6) = '' then
      begin
        StoreElm(T2RetNo, FNo, 6, Sin);
        // ShowMessage('Stored on elm 6 of '+IntToStr(FNo)+' this sin'+Sin);
        exit;
      end;
    end;
  end;
End;

Procedure AddSinToSalDivMForm(T2RetNo: Integer; Sin: String);
Var
  I, FNo: Integer;
Begin
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if (FRec.FormName = 'SALDIVM')
    then
    begin
      FNo := FRec.FormNo;
      // ShowMessage('elm 6 '+FetchElmFNo(T2RetNo,FNo,6));
      If FetchElmFNo(T2RetNo, FNo, 6) = '' then
      begin
        StoreElm(T2RetNo, FNo, 6, Sin);
        // ShowMessage('Stored on elm 6 of '+IntToStr(FNo)+' this sin'+Sin);
        exit;
      end;
    end;
  end;
End;




Procedure DeleteSINFromSalDivForms(T2RetNo: Integer; Sin: String);
Var
  I, FNo: Integer;
  T1App: TApp;
Begin
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;

  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    FNo := FRec.FormNo;
    if FRec.FormName = 'SALDIV' then
    begin
      If FetchElm(T2RetNo, FNo, 6) = Sin then
        StoreElm(T2RetNo, FNo, 6, '');
    end;
  end;
End;

Procedure ClearT4T5SalDiv(T2RetNo: Integer; T1RetNo: Integer; Sin: String);
Var
  I, j, FNo: Integer;
  T1App: TApp;
Begin
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;

  //T2
  StoreElm(T2RetNo,'S125#1',86,'');  //thats where the Salaries are temporarily stored //20200828

  //T1
  // 20200822
  for I := 0 to (T1App.FList.Count - 1) do
  begin
    FRec := T1App.FList.Items[I];
    FNo := FRec.FormNo;
    if FRec.FormName = 'T1SALDIV' then
    begin
      // StoreElm(T1RetNo, FNo, 4, '');
      StoreElm(T1RetNo, FNo, 5, '');  // taxable elig dividends stored in t1saldiv
      StoreElm(T1RetNo, FNo, 6, '');  // taxable non-elig dividends stored in t1saldiv
    end // t5mult

    Else if FRec.FormName = 'T4' then // fno is the t4
    begin
      If (FetchElm(T1RetNo, FNo, 21) = Sin) // sin
        and (UpperCase(FetchElm(T1RetNo, FNo, 1))
        = UpperCase(GetCorpName(T2RetNo))) // employer nm //20200825
      then
      begin
        For j := 1 to 67 do // 20200821
        begin
          StoreElm(T1RetNo, FNo, j, ''); // delete the data of that t4
        end; // j
      end;
    end; // t4
  end;
End;

(*
  Else if FRec.FormName = 'T5MULT' then
  begin
  If (FetchElm(T1RetNo, FNo, 39) = Sin) and
  (UpperCase(FetchElm(T1RetNo, FNo, 1)) = UpperCase(GetCorpName(T1RetNo)))
  then
  begin
  For j := 1 to 174 do //20200821
  begin
  StoreElm(T1RetNo, FNo, j, '');
  end; // elig taxable dividents
  {
  StoreElm(T2RetNo, FNo, 6, '');
  StoreElm(T2RetNo, FNo, 28, '');
  StoreElm(T2RetNo, FNo, 50, '');
  StoreElm(T2RetNo, FNo, 72, '');
  StoreElm(T2RetNo, FNo, 94, '');
  }
  end; // sin
  end; // t5mult
  end; // i
  End; // procedure
*)
Procedure CloseAllSalDivT1Returns;
Var
  I: Integer;
  T1App: TApp;
Begin
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;
  for I := 0 to RetList.Count - 1 do
  Begin
    if Assigned(RetList[I]) and (RetList[I].MyApp = T1App)
    // and SameText(RetList[I].SourceFlName, FlName)
    // and SameText(RetList[I].SourceDataDir,DataDir) {not sure if it is needed} //20200808
    then
    begin
      if TestMode then  //20200826
       //ok
      Else
       RetList[I].Close(True); // close the return
    end;
  End;
End;

Procedure CloseT1ReturnSalDiv(T1RetNo: Integer); // 20200821 NOT used?
Var
  I: Integer;
  T1App: TApp;
Begin
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;
  for I := 0 to RetList.Count - 1 do
  Begin
    if (I = T1RetNo) and (RetList[I].MyApp = T1App) then
    Begin
     If TestMode then  //20200826
      //ok
     Else
       RetList[I].Close(True);
    End;
  End;
End;

// 20200821 KEEP THIS SAMPLE
Function GetSalDivEligDivindendsFromT1(T1RetNo: Integer; Option: Integer): Real;
// 20200821 NOT used?
Var
  I, FNo: Integer;
  T1App: TApp;
  x: Real;
  S: String;
Begin
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    showmessage('T1 App was not found');
    exit;
  end;

  x := 0;
  for I := 0 to T1App.FList.Count - 1 do
  Begin
    FRec := T1App.FList.Items[I];
    FNo := FRec.FormNo;
    if FRec.FormName = 'INFO' then
      S := FetchElm(T1RetNo, FNo, 5);
    if FRec.FormName = 'T5MULT' then
      x := x + Vl(FetchElm(T1RetNo, FNo, 141));
  end;
  // ShowMessage('Name in T1 '+s+' Option '+IntToStr(Option)+' '+FormatFloat('#########',x));
  Result := x;
End;

Procedure CopyMultCombinationsToSalDiv(T2RetNo: Integer; SalDivMFNo:Integer;SalDivFNo:Integer; Salary: Real; Dividends: Real; SIN:String; Option: Integer; Multcnt: Integer);
Var  jm, k:integer; x:Real;
  Begin
  // populate the each line from the SALDIV# tht has been created for each successive scenario of Dal and Div
  if  (Option = 2)
  and (HowMany > 1)
  then
  Begin
    jm := 43 + Multcnt * 8;
   // jj := 225 + Multcnt * 6; // starts off with 230 for multCnt=1
    Ret[T2RetNo].Frm[SalDivMFNo].Strings[jm] := FormatFloat('#########', Salary);
    Ret[T2RetNo].Frm[SalDivMFNo].Strings[jm + 1] :=FormatFloat('#########', Dividends);
    x:=Vl(Ret[T2RetNo].Frm[SalDivFNo].Strings[218]);   //pers taxes
    Ret[T2RetNo].Frm[SalDivMFNo].Strings[jm + 2] :=Ret[T2RetNo].Frm[SalDivFNo].Strings[218]; // Personal Taxes
    Ret[T2RetNo].Frm[SalDivMFNo].Strings[jm + 3] :=Ret[T2RetNo].Frm[SalDivFNo].Strings[51];  // Corp taxes
    Ret[T2RetNo].Frm[SalDivMFNo].Strings[jm + 4] :=Ret[T2RetNo].Frm[SalDivFNo].Strings[171];
    Ret[T2RetNo].Frm[SalDivMFNo].Strings[jm + 5] :=Ret[T2RetNo].Frm[SalDivFNo].Strings[144];  // Clawback  //20200930
    Ret[T2RetNo].Frm[SalDivMFNo].Strings[jm + 6] :=Ret[T2RetNo].Frm[SalDivFNo].Strings[201];// After cash to shareholder
  end;
end;

Procedure ClearMultipleSalDivScenariosSection(T2RetNo: Integer;
  T1RetNo: Integer; Sin: String; SalDivFNo: Integer);
Var
  I: Integer;SalDivMFNo:Integer;
Begin
  SalDivMFNo:=GetFormNo('SALDIVM');  //20200930
  for I := 231 to 604 do   //20200828
  begin
    StoreElm(T2RetNo, SalDivFNo, I, '');
  end; // 20200823
End;


//20201212
Function ValidADDONFeaturesKey:Boolean;
Var
  T2LicenseKey: String; List1:TstringList;
  FirstLetter, SecondLetter, ThirdLetter: String;
  CalculatedKey,EnteredKey:String;
  FlName:String;
Begin
Result:=True;  //controlled by form name
EXIT;
 T2LicenseKey:=AppT2.GetLicenseKey;  //not picking up the correct t2 key

 //20201219
 CalculatedKey := '22'+MidStr(T2LicenseKey,11,1) //CalculatedKey := '21'+MidStr(T2LicenseKey,11,1) //202221230
                       //22 + 5 digits after T2xx reversed
                       +MidStr(T2LicenseKey,9,1)+MidStr(T2LicenseKey,8,1)
                       +MidStr(T2LicenseKey,7,1)+MidStr(T2LicenseKey,6,1);


 List1:=TStringList.Create;
 if AddOnEnabled = false then ////20231031
 //If FileExists(Appdir+'\'+FlName) = false then  //20231031
 Begin
    ShowMessage('You need an upgrade to use the Add-on schedules and features'
    +Chr(13)+' '
     +Chr(13)+'These schedules and features are not part of the standard or Power tax modules.'
     +Chr(13)+'If you have a need for them, you can Order them by Email'
     +Chr(13)+'and submitting an e-transfer payment to Sales@VisualTax.com'
     +Chr(13)+' '
     +Chr(13)+'If you received an AddOn Password'
     +Chr(13)+'you can enter it by clicking the Add-On menu item -> Enter the Add-On Password');
   Exit;
 End;

 List1.LoadFromFile(Appdir+'\'+t2enterpriseflname);  //20231031

 If (CalculatedKey=UpperCase(List1[0]))
 Or (UpperCase(List1[0])='221282')    //generic  //20221231
 then
  Result:=True
 Else
 Begin
  Result:=False;
  ShowMessage('If you received an Add-On Password'
  +Chr(13)+'you can enter it by clicking the Add-On top menu item -> Enter the Add-On Password');
 End;
 List1.Free;
end;

Function EIExempt(T2RetNo: Integer; Sin: String): Boolean;
Var
  I, j: Integer;
  S: String;
Begin
  Result := False;
  I := 51;
  j := 141;
  Repeat
    Result := False;
    S := FetchElmFNo(T2RetNo, SalDivSetFNo, I); // sin from saldivset form
    If S = Sin then
    Begin
      if UpperCase(FetchElmFNo(T2RetNo, SalDivSetFNo, j)) <> 'Y' then //not an employee
       Result:=True  //no employee, then EI exempt
      Else
       Result:=False;
      exit;
    End;
    Inc(I, 1);
    Inc(j, 1)
  Until I > 65;
End;

Function SalDivEI(T2RetNo: Integer; SIN:String; TaxYear: String; Salary: Real;
  CPPPeriods: Integer; TotPeriods: Integer): Real;
Var
  MaxEIEarnings: Real;
Begin
  If EIExempt(T2RetNo, Sin) then
  Begin
    Result:= 0;
    exit;
  End;
  //RY := 1;
  T1Constant[0].UIRate := 0.0158; // 2020
  T1Constant[1].UIRate := 0.0158; // 2021

  T1Constant[0].MaxUIEarn52 := 54200; // 2020
  T1Constant[1].MaxUIEarn52 := 54200; // 2021

  (*
    Constant[0].MaxUI52 := 860.22; // 2019
    Constant[1].MaxUI52 := 856.36; // 2020

    // http://www.taxtips.ca/cppandei/eirates.htm
    Constant[0].QCUIRate := 0.0125;  // 2019
    Constant[1].QCUIRate := 0.0125; // 2020

    // http://www.taxtips.ca/cppandei/eirates.htm

    Constant[0].QCMaxUI52 := 663.75; // 2019                                                                                      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    Constant[1].QCMaxUI52 := 663.75; // 2020

    // same including qc //http://www.taxtips.ca/cppandei/eirates.htm                                             AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    Constant[0].MaxUIEarn52 := 53100; // 2019
    Constant[1].MaxUIEarn52 := 54200; // 2020
  *)

  MaxEIEarnings := MinR(T1Constant[RYY].MaxUIEarn52, Salary);
  Result := MaxEIEarnings * T1Constant[RYY].UIRate;
End;

Function GetSalDivTotalEI(T2RetNo: Integer; Salary: Real; AppYear: String; Option: Integer): Real;
Var
  I, j, jj:Integer;
  sin:String;
  TotEI: Real; // 20200816
Begin
  Result := 0;

  TotEI := 0;
  I := 51; // pointer to settings
  j := 81; // Full salary compensation index
  jj := 31; // combination salary index
  Salary := 0; // option 0 and 2
  TotEI := 0;
  Repeat
    if Option = 1 then
    Begin
      Sin:=FetchElmFNo(T2RetNo, SalDivSetFNo, i);
      Salary := Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, j)); // 20200821
      TotEI := TotEI + SalDivEI(T2RetNo,SIN,AppYear, Salary, 12, 12);
    End
    Else
    Begin
      if Option = 2 then // 20200822A
      Begin
        Sin:=FetchElmFNo(T2RetNo, SalDivSetFNo, i);
        Salary := Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, j)) *
          Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, jj)) / 100; // 20200821
        TotEI := TotEI + SalDivEI(T2RetNo,SIN, AppYear, Salary, 12, 12);
      End;
    End;
    Inc(I, 1);
    Inc(j, 1);
    Inc(jj, 1);
  Until I > 65;
  Result := TotEI;
end;


Function GetSalDivTotalCpp(Age:String;T2RetNo: Integer; Salary: Real; AppYear: String;
  CPPPeriods: Integer; TotPeriods: Integer; Option: Integer): Real;
// Function GetTotalSalDivCpp(T2RetNo:Integer;AppYear:String;CPPPeriods:Integer;TotPeriods:Integer;Option:integer):Real;
// Salary type: 1=Full, 3:=Combination)
Var
  // Earnings: Real;    //**** INCOMING SALARY IS NOT USED *******
  I, j, jj:Integer;
  TotCpp: Real; // 20200816
Begin
  Result := 0;
  TotCpp := 0;
  I := 51; // pointer to sin in settings
  j := 81; // Full salary compensation index
  jj := 31; // combination salary index
  Salary := 0; // option 0 and 2
  TotCpp := 0;
  Repeat
    if Option = 1 then
    Begin
      Salary := Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, j)); // 20200821
      TotCpp := TotCpp + SalDivCpp(Age,AppYear, Salary, 12, 12);
    End
    Else
    Begin
      if Option = 2 then // 20200822A
      Begin
        Salary := Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, j)) *
          Vl(FetchElmFNo(T2RetNo, SalDivSetFNo, jj)) / 100; // 20200821
        TotCpp := TotCpp + SalDivCpp(Age,AppYear, Salary, 12, 12);
      End;
    End;
    Inc(I, 1);
    Inc(j, 1);
    Inc(jj, 1);
  Until I > 65;
  Result := TotCpp;
end;

(*
Function FindSalDivClawback(T2RetNo:Integer;SalDivFno:Integer;SalaryReal;Dividends:Real):String;
Var i:Integer;s1,S2:String;Amount:Real;
Begin
 Result:='';
 Amount:=Vl(FetchElm(T2RetNo,SalDivFno,144));
 S1:=FetchElm(T2RetNo,SalDivFno,28);
 S2:=FetchElm(T2RetNo,SalDivFno,28);
 if s1='' then s1:='0';
 if s2='' then s2:='0';

 if Amount>0 then
  Result:='Amount '+FormatFloat('#########',Amount)
           +' For Salary =$'+S1
           +' and Dividends =$'+S2;
End;
*)


Function CountSalDivShareholders(T2RetNo:Integer):Integer;
Var i,SalDivSetFNo:Integer;
Begin
  SalDivSetFNo:=GetFormNo('SALDIVSET');
  Result:=0;
  I := 51;
  Repeat
    if FetchElm(T2RetNo,SalDivSetFNo,i)>'' then result:=Result+1;
    Inc(I, 1);
  until I > 65; // maxShareholders; //65?
end;

Function GetSalDivMultipleCombinationsString(T2RetNo:Integer):String;
var Shareholders:Integer; Suggested:String;
Begin
 Shareholders:=CountSalDivShareholders(T2RetNo);
 if Shareholders=1 then Suggested:='5 to 40'
 Else if (Shareholders>1) and (Shareholders<5) then Suggested:='5 to 20'
 Else if (Shareholders>=5) and (Shareholders<10) then Suggested:='5 to 10'
 Else if (Shareholders>=10) then Suggested:='5 to 7';

 Result:=UpperCase(InputBox('Enter desired Number of combinations ', 'Number:'+Suggested, AllTrim(LeftStr(Suggested,2)))); //AllTrim(LeftStr(Suggested,2))));

 //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20200113

 End;

end.

