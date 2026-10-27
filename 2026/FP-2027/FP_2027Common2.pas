unit FP_2027common2;

{=============================================================}
interface
{=============================================================}
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,
  vtMulti; //20200914 Igor

Procedure GetStatusFromDB(DataDir:string;FlName:string;Var EfSt:string;Var PrepSt:string;Var CreateDate:String);
Function SaveReturn(RetNo: integer; DataDir: string; FlName: string;
  OverrideSw: Boolean; UpdMostRecent: Boolean; ATextFormat: Boolean = False;
  AUpdateClientTable: Boolean = True; AClouds: TArrayOfInteger = nil):integer; //20160405 Igor //20190228 Igor
Function OpenReturn(DataDir,FlName: string;ShowSw:Boolean; AIsAppendix: Boolean = False): Integer; //20160305 Igor
//Function OpenReturn(Var RetNo:Integer;DataDir: String; FlName: string;ShowSw:Boolean): Integer;
Function UpdateClientsTable(RetNo: integer; DataDir: string;FlName:string):Integer;
Procedure AddYearlyInstances(RetNo:Integer);
Procedure InitStatusForm(RetNo:Integer; FNo:Integer);
Function HasDataN(RetNo:integer; FNo:Integer; elm:integer):boolean;
Function HasDataS(RetNo:integer; FNo:Integer; elm:integer):Boolean;
Function IsRetInMemory(Sin:string):Integer;
Procedure MoveForm(FromRetNo: integer;FromFormName: string;ToRetNo: integer;ToFormName:String);
Procedure ClearForm(RetNo:integer;FName:string);
function GetFirstInstIndex(FormNo: integer):Integer;
function GetHighestFormNo:Integer;
Function AddOtherPagesInstance(RetNo: integer; NonInstFormName,FormInst:String):boolean;
Function AddPageInstance(RetNo: integer; NonInstFormName,FormInst: string): integer;
Function GetShortPrv(LPrv: string): String;
Function ReadReturn(DataDir,FlName: string; AIsAppendix: Boolean = False;
  AConvert: Boolean = False):integer; //20160305 Igor //20160704 Igor
//Function ReadReturn(RetNo : integer; Datadir: string; FlName: string):integer;


implementation

uses vtCommon,vtFileStorage,FP_2027,FP_2027TrimStr,FP_2027Declare, //20200914 Igor
     FP_2027Main,FP_2027Common,FP_2027Calc,vtTrimStr,vtShared,vtHelperManager //20190228 Igor
   , vtDataBase, uADCompClient, vtMain; // 20150921 Igor //20160704 Igor

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
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   if RetRec = nil then continue;
   if FetchElm(RetRec.RetNo,FirstFormName,3) = Sin then
     begin Result := RetRec.RetNo;exit;end;
 end;
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

Function AddOtherPagesInstance(RetNo: integer; NonInstFormName,FormInst:String):boolean;
{call procedure in initFormsTable}
Var I:integer;
begin
  Result := False;
  If NonInstFormName = 'TAXP_1' then
  begin
   AddPageInstance(RetNo, 'TAXP_2',FormInst);
  end;


  If NonInstFormName = 'ORD_1' then
  begin
   AddPageInstance(RetNo, 'ORD_2',FormInst);
   AddPageInstance(RetNo, 'ORD_3',FormInst);
   AddPageInstance(RetNo, 'ORD_4',FormInst);
  end;
end;

Function AddPageInstance(RetNo: integer; NonInstFormName,FormInst: string): integer;
begin
  //20160704 Igor >>>
  if RetList[RetNo].isLastYearReturn or
     RetList[RetNo].isAppendix then
    Result := FLastYearList.AddPageInstance(RetNo, NonInstFormName,FormInst)
  else
    Result := FList.AddPageInstance(RetNo, NonInstFormName,FormInst);
  //20160704 Igor <<<
end;

Function GetShortPrv(LPrv: string): String;
Var i : integer;
Begin
  Result := PrvShort[1];
  For i := 1 to High(PrvLong) do
   begin
    If LPrv = PrvLong[i] then
    begin Result := PrvShort[i];exit;end;
   end;
End;


Procedure InitStatusForm(RetNo:Integer; FNo:Integer);
begin
  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[4] := '00';  {prpstatus}
   {created}
   Strings[5] := User.UserName;  //20170112 Igor
   Strings[6] := DateToStr(Date);
   Strings[7] := TimeToStr(Time); {created}
   {last update}
   Strings[11] := User.UserName; //20170112 Igor
   Strings[12] := DateToStr(Date);
   Strings[13] := TimeToStr(Time);
   {Efile}
  { Strings[15] := '00';}
  end;
end;


Procedure ClearForm(RetNo:integer;FName:string);
var i,n,FNo :integer;
begin
  Fno := GetFormNo(FName);
  If (Fno >0) and (Ret[RetNo].Frm[FNo].Count >0)  then
  begin
    vtShared.ClearForm(RetNo, FName);
    CalcAll(RetNo);
  end;
end;

Procedure MoveForm(FromRetNo: integer;FromFormName: string;ToRetNo: integer;ToFormName:String);
begin
 CloneForm(FromRetNo,FromFormName,ToRetNo,ToFormName);
 ClearForm(FromRetNo,FromFormName);
 Ret[FromRetNo].changed :=True;
 Ret[ToRetNo].changed :=True;
 Calc(FromRetNo,FromFormName);
 CalcAll(FromRetNo);
 Calc(ToRetNo,ToFormName);
 CalcAll(ToRetNo);
 Ret[FromRetNo].FrmHasData[GetFormNo(FromFormName)] := False;
 Ret[ToRetNo].FrmHasData[GetFormNo(ToFormName)] := True;
 Ret[FromRetNo].changed :=True;
 Ret[ToRetNo].changed :=True;
end;


Function ReadReturn(DataDir,FlName: string; AIsAppendix: Boolean = False;
  AConvert: Boolean = False):integer;  //20160305 Igor //20160704 Igor
var
  i,j,k,FNo, SNo, BxNo : integer;
 { ClientsTbl : T Table;}
  S : String;
  FName:String;
  Var1,Var2,Var3,Var4,InAppYear,InAppVersion : String;
  RetNo: integer absolute Result;
  fs: TFileStorage;
  PrevFormName: String; //20160415 Igor
  SQLite: TSQLiteStorage; //20160415 Igor

  function ReadNextLine: Boolean; //20160415 Igor
  Begin
    //20161206 Igor >>>
    Result := vtFileStorage.ReadNextLine(SQLite, Var1, Var2, Var3, Var4, fs);
    //20161206 Igor <<<
  End;

  Procedure StoreThisData(RetNo,FNo:integer;FName,InAppYear,InAppVersion,Elem,Valu:String);
  begin
     If FNo =0 then exit;
     If Elem='' then exit;
     If (InAppVersion = '0.0') and
     ((Fname = 'PASS_1') or (Fname = 'PASS_2') or (Fname = 'PASS_3')) then
        exit;
     //StoreElm(RetNo,FNo,StrToInt(Elem),Valu);
     RetList[RetNo].SaveElmFromFile(FNo,StrToInt(Elem),Valu);
  end;

begin
  // if IsAuthorizedPreparer=False then Exit;  //20220527  //NOT SUPPORTED needs routines
  //SomeList.clear; // := TStringList.Create; {used to save FNo's of the return}

 // If UpperCase(InputBox('FP Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20260505

  Result := CheckReturnPsw(DataDir,FlName);
  if Result < 0 then
  begin
    ShowMessage('Invalid return PSW');
    exit; //file or psw error
  end;

  Result := iorUnknown;

 //20160415 Igor >>>
  PrevFormName := '';
  SQLite := TSQLiteStorage.Create(DataDir, FlName, fsRead, AppFP.SQLLitePassword.PassRFArray);
  if SQLite.LastError <> '' then
  Begin
    FreeAndNil(SQLite);
    fs := TFileStorage.Create(DataDir,FlName,fsRead);
  End;
 //20160415 Igor<<<

  try //finally
     //NextLine;
      //20160415 Igor>>>
     if Assigned(SQLite) then
     Begin
       if not SQLite.ReadSettings('AppName', Var1) or
          not SQLite.ReadSettings('AppYear', Var2) or
          not SQLite.ReadSettings('AppVersion', Var3) then
       Begin
         ShowMessage(SQLite.LastError);
         exit;
       end;
    end
    else
 //20160415 Igor<<<
     fs.ReadLine(var1,var2,var3,var4);

    If Var1 <> AppName then
    begin
      Result := iorFileType;  // -2;
      //CloseFile(F1);
      exit;
    end;
    InAppYear := Var2;
    InAppVersion := Var3;

   RetNo:=CreateNewReturn(InAppYear, AConvert);
   //if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;
    if RetNo < 1 then
      exit;
   Ret[RetNo].isAppendix := AIsAppendix; //20160704 Igor
   Try //except
   while ReadNextLine do //20160415 Igor
   begin
       if Var1 = 'F' then   {Form record}
         begin
          Fname := UpperCase(Var2);
          Fno := GetFormNo(FName, RetNo);
            If (FNo = 0) and (IsFormMultiInst(FName)) then
           begin
            Fno := AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));
            AddOtherPagesInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));
            //Fno := GetFormNo(FName); {get it again}
           end;

          If FNo > 0 then
            begin
             InitFormData(RetNo,FNo);
             Ret[RetNo].FrmHasData[FNo] := True;
             //SomeList.Add(IntToStr(FNo)); {record all Fno's}
            end;
         end

       else if Var1 = 'D' then  {Detail Form Data}
         Try
           begin
            If FNo > 0 then
               StoreThisData(RetNo,FNo,FName,InAppYear,InAppVersion,Var2,Var3)
           end
         except
         end

       else if Var1 = 'M' then  //memo field
       begin
        If FNo >0 then
        begin
           //StoreMemoElm(RetNo,FormNm,FNo,StrToInt(Var2),Var3);   //var3 is too big?
           RetList[RetNo].SaveMemoFromFile(FNo,StrToInt(Var2),Var3);
        end
       end

       else if Var1 = 'O' then  {Overrides}
           begin
           SetFieldOverride(RetNo,GetFormNo(Var2),MyStrToInt(Var3));
           SaveFieldOverride(RetNo,GetFormNo(Var2),MyStrToInt(Var3),Var4);
           end
       else if Var1 = 'R' then  {Review marks}
              SetReviewMark(RetNo,GetFormNo(Var2),MyStrToInt(Var3))
       else if Var1 = 'L' then Ret[RetNo].Ln[StrToInt(Var2)] := vl(Var3);
    end;
   Except
    //on E: Exception do MessageDlg(E.Message+' '+FName+' '+InputLin, mtError, [mbok], 0);
     UserMsg('Reading of data may be incomplete '+ FName);
   end;
  finally
    if assigned(fs) then //20160415 Igor
      fs.free;
    if assigned(SQLite) then //20160415 Igor
      freeAndNil(SQLite);
  end;
    FNo:=GetFormNo('STATUS');
    if Ret[RetNo].Frm[Fno].Count = 0 then
      begin
       InitFormData(RetNo,FNo);
       InitStatusForm(RetNo,FNo);
      end;
    Ret[RetNo].PrpStatus := FetchElm(RetNo,'STATUS',4);
    Ret[RetNo].Notes := FetchElm(RetNo,'STATUS',14);
    Ret[RetNo].SourceDataDir := DataDir;
    Ret[RetNo].SourceFlName := FlName;
    ret[RetNo].isAppendix := AIsAppendix;
    //20170225 Igor >>>
    if FetchElm(RetNo, 'STATUS', c_ReturnColorElm) <> '' then
    try
      SetRetColor(RetNo, StringToColor(FetchElm(RetNo, 'STATUS', c_ReturnColorElm)), c_ReturnColorElm);
      MainForm.GuiCommand(gcColorChanged);
    except
    end;
    //20170225 Igor <<<
    if not AIsAppendix then //20160704 Igor
    Begin
      CalcAll(RetNo);
      CalcAll(RetNo); //twice for cashfl
    end;
    Ret[RetNo].changed := False; // 20170112 Igor
end;

Procedure AddYearlyInstances(RetNo:Integer);
Var FName:String; FNo:Integer;
  begin
      FName := 'PNONSH#2';
      Fno := GetFormNo(FName);
      If (FNo = 0) and (IsFormMultiInst(FName)) then
        AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));
      FName := 'PNONSH#3';
      Fno := GetFormNo(FName);
      If (FNo = 0) and (IsFormMultiInst(FName)) then
        AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));

      FName := 'PSHELT#2';
      Fno := GetFormNo(FName);
      If (FNo = 0) and (IsFormMultiInst(FName)) then
        AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));
      FName := 'PSHELT#3';
      Fno := GetFormNo(FName);
      If (FNo = 0) and (IsFormMultiInst(FName)) then
        AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));

      FName := 'PSEMSH#2';
      Fno := GetFormNo(FName);
      If (FNo = 0) and (IsFormMultiInst(FName)) then
        AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));
      FName := 'PSEMSH#3';
      Fno := GetFormNo(FName);
      If (FNo = 0) and (IsFormMultiInst(FName)) then
        AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));

{ TODO -oCon : POTHER does not exist }
  if FList.IndexOf('POTHER') >= 0 then
  begin
      FName := 'POTHER#2';
      Fno := GetFormNo(FName);
      If (FNo = 0) and (IsFormMultiInst(FName)) then
        AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));
      FName := 'POTHER#3';
      Fno := GetFormNo(FName);
      If (FNo = 0) and (IsFormMultiInst(FName)) then
        AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));
  end;
end;

Function UpdateClientsTable(RetNo: integer; DataDir: string;FlName:string):Integer;
{input parms are taken from Save As.. screen}
Var FNo :Integer;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  If FlName=ModelPortfoliosSin then exit;
  FlName := AllTrim(UpperCase(FlName));
  FNo :=GetFormNo('STATUS'); {to preserve status data}
  If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
  {Update Data Base}
  //20150921 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');

  if 1=1 then // Table1.State = dsInactive //rem 20150921 Igor
   begin
     if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then //20170210 Igor
      Table1.edit
     else
      Table1.Insert;

     Table1.FieldByName('First_Name').AsString :=Uppercase(FetchElm(RetNo,'PROFILE',1));
     Table1.FieldByName('Last_Name').AsString :=Uppercase(FetchElm(RetNo,'PROFILE',2));
     Table1.FieldByName('PlanDate').AsString := GetPlanDate(RetNo);
     Table1.FieldByName('File_Name').AsString := FlName;

    // Table1.FieldByName('Year_end').AsString := FetchElm(RetNo,'PAGE_1',11);
    // Table1.FieldByName('Due_Date').AsString := FetchElm(RetNo,'PAGE_1',11);
     {
     If FetchElm(RetNo,'PAGE_8',49)>'' then
       Table1.FieldByName('Contact').AsString :=FetchElm(RetNo,'PAGE_8',49)
     else
      Table1.FieldByName('Contact').AsString := FetchElm(RetNo,'PAGE_8',43)+' '+ FetchElm(RetNo,'PAGE_8',42);
     }
     //Table1.FieldByName('Account').AsString :=LeftStr(FetchElm(RetNo,'PAGE_1',1),9);

     Table1.FieldByName('Pay_InvNo').AsString := FetchElm(RetNo,'Inv_2',10);
     Table1.FieldByName('Pay_Type').AsString := '';
     If FetchElm(RetNo,'Inv_2',23) > '' then Table1.FieldByName('Pay_Type').AsString := 'Cash'
     else If FetchElm(RetNo,'Inv_2',24) > '' then Table1.FieldByName('Pay_Type').AsString := 'Cheque'
     else If FetchElm(RetNo,'Inv_2',25) > '' then Table1.FieldByName('Pay_Type').AsString := 'Visa';

     Table1.FieldByName('Pay_Dt').AsString := FetchElm(RetNo,'Inv_2',9);
     Table1.FieldByName('Inv_Amount').AsFloat := vl(FetchElm(RetNo,'Inv_2',22));

     If (FetchElm(RetNo,'Inv_2',23) > '') or (FetchElm(RetNo,'Inv_2',24) > '') or
     (FetchElm(RetNo,'Inv_2',25) > '')  then
     Table1.FieldByName('Pay_Amount').AsFloat := vl(FetchElm(RetNo,'Inv_2',22))
     Else
      Table1.FieldByName('Pay_Amount').AsFloat := 0;
     Table1.FieldByName('Street').AsString := FetchElm(RetNo,'PROFILE',5);
     Table1.FieldByName('City').AsString := FetchElm(RetNo,'PROFILE',6);
     Table1.FieldByName('Province').AsString := FetchElm(RetNo,'PROFILE',8); {from long to short}
     Table1.FieldByName('Postal').AsString := RemoveChar(RemoveChar(FetchElm(RetNo,'PROFILE',12),' '),'-');

     Table1.FieldByName('Area').AsString :=FetchElm(RetNo,'PROFILE',15);
     Table1.FieldByName('Phone').AsString := RemoveChar(RemoveChar(FetchElm(RetNo,'PROFILE',16),' '),'-');
     Table1.FieldByName('Created_by').AsString := FetchElm(RetNo,'STATUS',5);
     Table1.FieldByName('Created_tm').AsString := FetchElm(RetNo,'STATUS',7);

     Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
     Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);

     Table1.FieldByName('PRP_Status').AsString := FetchElm(RetNo,'STATUS',4);
     Table1.FieldByName('Updated_by').AsString := FetchElm(RetNo,'STATUS',11);
     Table1.FieldByName('Updated_tm').AsString := FetchElm(RetNo,'STATUS',13);
     Table1.FieldByName('Notes').AsString := FetchElm(RetNo,'STATUS',14);

     try
     Table1.FieldByName('Created_dt').AsString := FetchElm(RetNo,'STATUS',6);
     Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
     Table1.FieldByName('Updated_dt').AsString := FetchElm(RetNo,'STATUS',12);
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
        showmessage('Data is saved. For best results ensure that data'
        +Chr(13)+'is saved on a data directory created by the FP-2006 or beyond');
     end;
     Table1.Post;
    end;
   Table1.Free;
   ADConnection.Free;
   Result := 0;
end;

Function OpenReturn(DataDir,FlName: string;ShowSw:Boolean; AIsAppendix: Boolean = False): Integer; //20160305 Igor
{result:
 0=OK,
 -1=File does not exist,
 -2=not a valid file
 -3=exceeds limit
 -4:= password wrong
 }

var
  i, FNo : integer; s:string;
begin
  //20170502 Igor >>>
  if RetInMem(AppFP, True) >= AppFP.LimitReturns then
    Exit(-3);
  //20170502 Igor <<<
  if not AIsAppendix then                 //20160704 Igor
    MainForm.GUICommand(gcHideLastYear); //20160704 Igor
  ApplicationState := ApplicationState + [asLoadReturn]; //20160704 Igor
  try
    Result := ReadReturn(DataDir,FlName, AIsAppendix, asConvertFromLastYear in ApplicationState); //20170412 Igor
    If Result < 1 then
      //ShowMessage('File not found or File is not a FP file or incompatible year');
      ShowOpenReturnFailure(Result,DataDir,FlName)
    else
      RetList[Result].isAppendix := AisAppendix;    //20160305 Igor
  AddLogAppMon(amtOnRead, Result); //20220519 Igor
  finally
    ApplicationState := ApplicationState - [asLoadReturn]; //20160704 Igor
  end;
end;

Function SaveReturn(RetNo: integer; DataDir: string; FlName: string;
  OverrideSw: Boolean; UpdMostRecent: Boolean; ATextFormat: Boolean = False;
  AUpdateClientTable: Boolean = True; AClouds: TArrayOfInteger = nil):integer; //20160405 Igor //20190228 Igor
var
  i,j,k,FNo, SNo : integer;
  S : String;
  SQLite: TSQLiteStorage; //20160415 Igor
  //20190228 Igor >>>
  HelperID: Integer;
  HelperClassName: String;
  CloudPath: String;
  ClientID: String;
  Token: String;
  isShareAfterSend: Boolean;
  isShareWithPeople: boolean;
  L: TStringList;
  iL: integer;
  //20190228 Igor <<<
begin

 // If UpperCase(InputBox('FP Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20260505

  if RetList[RetNo].Locked then
  begin
    RetList[RetNo].Changed := False;
    Result := iorFileType;
    exit;
  end;
   //If LeftStr(LicenseLevel,8)='FP Demo' then
   If LicenseLevel = llDemo then
   begin
     Result := -2; {?}
     ShowMessage('The FP Demo does not allow saving of data');
     exit;
   end;

   If FlName = '' then
    begin
     Result := -2; {?}
     ShowMessage('Account is required');
     exit;
    end;
  //20170902 Igor>>>
  if AppFP.ExceedsMaxReturnsAllowed(False) then
    exit;
  //20170902 Igor<<<

    If OverrideSw = false then
    begin
     If FileExists(DataDir+'\'+FlName) and not SkipReplaceFileQuestion then //20190701 Igor
     begin
       case MessageDlg(
        'File exists. Override?',mtInformation, [mbYes, mbNo,mbCancel], 0) of
       mrNo: begin Result := -1;exit;end;
       mrCancel: begin Result := -3;exit;end;
       end;
     end;
    end;
    UpdateAllDataIndicators(RetNo);
    {update data base first}

    Try
      if AUpdateClientTable then //20160405 Igor
        result := UpdateClientsTable(RetNo,DataDir,FlName);
    Except
      on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
    end;

 //20160415 Igor>>>
    SQLite := TSQLiteStorage.Create(DataDir, FlName, fsWrite, AppFP.SQLLitePassword.PassRFArray);
    if SQLite.LastError <> '' then
    Begin
      ShowMessage(SQLite.LastError);
      SQLite.Free;
      exit;
    End;

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
    if not SQLite.WriteSettings('AppVersion',AppVersion) then
    Begin
      MessageDlg(SQLite.LastError,mtError,[mbOk],0);
      exit;
    end;
    if not SQLite.WriteSettings('AppRelease',AppRelease) then
    Begin
      MessageDlg(SQLite.LastError,mtError,[mbOk],0);
      exit;
    end;
    if not SQLite.WriteSettings('FileVerion','a') then
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

    {save forms data}
    { General : Var1, Var2     , Var3  , Var4}
    { Formats : F   , FormName ,       ,     }
    { Formats : O   , 'OVR ? needed'    ,       ,     }
    {           D   , Elm      , Value ,     }
    {         : S   , SlipName , Index , ?   }

  for i :=0 to FList.Count -1 do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    if (Ret[RetNo].FrmHasData[FNo]) then
    begin
      Ret[RetNo].WriteFData(FRec,SQLite); //20160415 Igor
    end;
  end;

    Ret[RetNo].WriteLnEtc(LnLowBound,LnHighBound, SQLite); //20160415 Igor
    SQLite.Free; //20160415 Igor
    //If Result = 0 then
    Ret[RetNo].Changed := False;
   // SaveScreenSettings(Sc,ScChar,ScChange,LeftPanelWidth);
    If UpdMostRecent = true then
    begin
     UpdateMostRecentFiles(RetNo,DataDir,FlName,GetSinNo(RetNo));
    end;

  //20190228 Igor <<<
  for I := 0 to length(AClouds) - 1 do
  begin
    if (AClouds[I] >= 1000) then
      Continue;

    isShareAfterSend := False;
    isShareWithPeople := False;
    for j := i to length(AClouds) - 1 do
    begin
      if (AClouds[j] = 1000 + AClouds[I]) then
        isShareAfterSend := True;
      if (AClouds[j] = 2000 + AClouds[I]) then
        isShareWithPeople := True;
    end;

    HelperID := AClouds[I];
    HelperClassName := HelperManager.HelperClassList.Keys.ToArray[AClouds[I]].ClassName;
    CloudPath := HelperManager.Config(HelperClassName, AppFP.AppId, User.UserName).Path;
    ClientID := HelperManager.Config(HelperClassName).ClientID;
    Token := HelperManager.Config(AClouds[I], AppFP.AppId, User.UserName).Token;
    if HelperManager.Send(AClouds[I],
        IncludeTrailingPathDelimiter(DataDir) + FlName,
        CloudPath,
        FlName,
        ClientID,
        Token) then
    begin
      if isShareAfterSend then
        HelperManager.SetShare(AClouds[I],
        Trim(FetchElm(RetNo, 'INFO', 140)),
        CloudPath,
        FlName,
        ClientID,
        Token);
      if isShareWithPeople then
      begin
        L := TStringList.Create;
        try
          L.Text := ReplaceStr(FetchElm(RetNo,'STATUS',SHARE_WITH_PEOPLE), ';', #13#10);
          for iL := 0 to L.Count - 1 do
            HelperManager.SetShare(AClouds[I],
              Copy(L.Strings[iL], Pos('|', L.Strings[iL]) + 1, Length(L.Strings[iL])),
              CloudPath,
              FlName,
              ClientID,
              Token);
        finally
          L.Free;
        end;
      end;
      S := S + HelperManager.HelperClassList.Values.ToArray[HelperId] + ' upload complete.'+#13
    end
    else
      S := S + HelperManager.HelperClassList.Values.ToArray[HelperId] + ' upload failed!'+#13;
    if HelperManager.Config(AClouds[I], AppFP.AppId, User.UserName).SaveToken AND
       (Token <> '') AND
       (Token <> HelperManager.Config(AClouds[I], AppFP.AppId, User.UserName).Token) then
      HelperManager.Config(AClouds[I], AppFP.AppId, User.UserName).Token := Token;
  end;
  if S <> '' then
    MessageDlg(S, mtInformation, [mbOk], 0);
  //20190228 Igor
end;


Procedure GetStatusFromDB(DataDir:string;FlName:string;Var EfSt:string;Var PrepSt:string;Var CreateDate:String);
Var FNo :Integer;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  PrepSt :='00';
  If not FileExists(DataDir+'\'+ClientsDBLite) then exit; //20150922 Igor

  //20150921 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');

  if 1=1 then // Table1.State = dsInactive //rem 20150921 Igor
  begin
     if Table1.FindKey([FlName]) then
     begin
      PrepSt := Table1.FieldByName('PRP_Status').AsString;
      CreateDate:=Table1.FieldByName('Created_Dt').AsString;
      Table1.Close;
     end;
  end;
  Table1.Free;
end;

end.
