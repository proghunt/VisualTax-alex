unit TF_2026Common2;

{=============================================================}
interface
{=============================================================}
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,
  vtMulti; //20200914 Igor

Procedure GetStatusFromDB(DataDir:string;FlName:string;Var PrepSt:string;Var CreateDate:String);
Function OpenReturn(DataDir,FlName: string;ShowSw:Boolean; AIsAppendix: Boolean = False): Integer; //20160305 Igor
Procedure ClearForm(RetNo:integer;FName:string);
Procedure InitStatusForm(RetNo:Integer; FNo:Integer);
Function HasDataN(RetNo:integer; FNo:Integer; elm:integer):boolean;
Function HasDataS(RetNo:integer; FNo:Integer; elm:integer):Boolean;
Function IsRetInMemory(Sin:string):boolean;
function GetFormNumberFields(FormNo: integer; Var GapFields:Integer):integer;
function GetFirstInstIndex(FormNo: integer):Integer;
function GetHighestFormNo:Integer;
Function AddOtherPagesInstance(NonInstFormName:String;FormInst:String):boolean;
Function AddPageInstance(RetNo: integer; NonInstFormName,FormInst: string): integer;
Function GetShortPrv(LPrv: string): String;

//Function ReadReturn(RetNo : integer; DataDir: string; FlName: string):integer;
Function ReadReturn(DataDir, FlName: string; RecalcFlag: boolean;
  AIsAppendix: Boolean = False; AConvert: Boolean = False):integer; //20160305 Igor //20160629 Igor
//Function ReadReturn(RetNo : integer; DataDir: string; FlName: string;RecalcFlag:string):integer;
//Function ReadReturn(RetNo : integer; Datadir: string; FlName: string):integer;
Function SaveReturn(RetNo : integer; DataDir: string; FlName: string;
  OverrideSw: Boolean; UpdMostRecent: Boolean; ATextFormat: Boolean = False;
  AUpdateClientTable: Boolean = True; AClouds: TArrayOfInteger = nil):integer; //20160405 Igor  //20190228 Igor
//Function SaveReturn(RetNo : integer; DataDir: string;FlName: string;OverrideSW:Boolean):integer;
Function UpdateClientsTable(RetNo: integer; DataDir: string;FlName:string):Integer;

implementation

uses vtMain,vtCommon,vtFileStorage,TF_2026,TF_2026TrimStr, //20200914 Igor
     TF_2026Declare,TF_2026Main,TF_2026Common,TF_2026Calc,TF_2026ChildWinNew,
     TF_2026FrmType,vtTrimStr,vtShared,vtHelperManager //20190228 Igor
   , vtDataBase, uADCompClient; // 20150923 Igor

Function HasDataN(RetNo:integer; FNo:Integer; elm:integer):boolean;
Begin
 If Vl(FetchElmFNo(RetNo,Fno,elm)) <> 0 then Result := True else Result := False;
end;

Function HasDataS(RetNo:integer; FNo:Integer; elm:integer):Boolean;
Begin
 If FetchElmFNo(RetNo,Fno,elm) > '' then result := True else Result := false;
end;


Function IsRetInMemory(Sin:string):boolean;
var
i : integer;
begin
  Result := False;
  for i :=1 to (RetList.Count - 1) do
  begin
   RetRec := RetList.Items[i]; if RetRec = nil then continue;
   if FetchElm(RetRec.RetNo,FirstFormName,2) = Sin then
     begin Result := True;exit;end;
  end;
end;

function GetFormNumberFields(FormNo: integer; Var GapFields:Integer):integer;
var
 i: Integer;
 begin
 Result := FList.FieldsLimit;   //20090421
 GapFields:=0;
 (*
  for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if (FRec^.FormNo = FormNo) then
        begin Result := FRec^.FormFields;GapFields :=FRec^.FormFields;end;
    end;
 *)
end;

function GetFirstInstIndex(FormNo: integer):Integer;
var
i: Integer;
begin
  FRec := FList.ByFormNoNil(FormNo);
  if FRec<>nil then
    Result := FList.FirstInstNo(FRec.FormName)
  else
    Result := 0;
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


//j???
Function AddOtherPagesInstance(NonInstFormName:String;FormInst:String):boolean;
//call procedure in initFormsTable
Var I:integer;
begin
end;

Function AddPageInstance(RetNo: integer; NonInstFormName,FormInst: string): integer;
begin
  //20160629 Igor >>>
  if RetList[RetNo].isLastYearReturn or
     RetList[RetNo].isAppendix then
    Result := FLastYearList.AddPageInstance(RetNo, NonInstFormName,FormInst)
  else
    Result := FList.AddPageInstance(RetNo, NonInstFormName,FormInst);
  //20160629 Igor <<<
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
   Strings[5] := User.UserName; //20170112 Igor
   Strings[6] := DateToStr(Date);
   Strings[7] := TimeToStr(Time); {created}
   {last update}
   Strings[11] := User.UserName; //20170112 Igor
   Strings[12] := DateToStr(Date);
   Strings[13] := TimeToStr(Time);
   {Efile}
   {Strings[15] := '00';}
  end;
end;

Function UpdateClientsTable(RetNo: integer; DataDir: string; FlName:string):Integer;
{input parms are taken from Save As.. screen}
Var FNo :Integer;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  FNo :=GetFormNo('STATUS'); {to preserve status data}
  If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
  {Update Data Base}
  //20150923 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'FILE_NAME');

   if 1=1 then // Table1.State = dsInactive //rem 20150921 Igor
   begin
     if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then //20170210 Igor
       Table1.edit
     else
       Table1.Insert;

     Table1.FieldByName('Corp_Name').AsString :=  GetRetName(RetNo);
     //FlName; //FileDescr;
       //UpperCase(GetReturnName(RetNo));  //
     Table1.FieldByName('File_Name').AsString := UpperCase(FlName);
     Table1.FieldByName('Year_end').AsString := GetYearEnd(RetNo);
     try
      Table1.FieldByName('Created_dt').AsString := FetchElm(RetNo,'STATUS',6);
      Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
      Table1.FieldByName('Updated_dt').AsString := FetchElm(RetNo,'STATUS',12);
     except
       on exception do
        showmessage('Date must be M/D/YY in Windows control panel'+
        Chr(13)+'or revise dates in Forms|Status');
     end;

     {make it comp}
     Table1.FieldByName('Due_Date').AsString :=
        MidStr(FetchElm(RetNo,'T3',17),6,2)+
        '-'+RightStr(FetchElm(RetNo,'T3',17),2)+
         '-'+LeftStr(FetchElm(RetNo,'T3',17),4);

     Table1.FieldByName('Contact').AsString :=
        FetchElm(RetNo,'T3',3);
     Table1.FieldByName('Account').AsString := GetAccountNumber(RetNo);
     Table1.FieldByName('Pay_InvNo').AsString := FetchElm(RetNo,'INVOICE',210);
     Table1.FieldByName('Pay_Type').AsString := '';
     If FetchElm(RetNo,'INVOICE',223) > '' then
        Table1.FieldByName('Pay_Type').AsString := 'Cash'
     else If FetchElm(RetNo,'INVOICE',224) > '' then
           Table1.FieldByName('Pay_Type').AsString := 'Cheque'
     else If FetchElm(RetNo,'INVOICE',225) > '' then
           Table1.FieldByName('Pay_Type').AsString := 'Visa';

     Table1.FieldByName('Pay_Dt').AsString :=
       FetchElm(RetNo,'INVOICE',209);
     Table1.FieldByName('Inv_Amount').AsFloat :=
       vl(FetchElm(RetNo,'INVOICE',222));

     If (FetchElm(RetNo,'INVOICE',223) > '') or
      (FetchElm(RetNo,'INVOICE',224) > '') or
     (FetchElm(RetNo,'INVOICE',225) > '')  then
     Table1.FieldByName('Pay_Amount').AsFloat :=
       vl(FetchElm(RetNo,'INVOICE',222))
     Else
      Table1.FieldByName('Pay_Amount').AsFloat := 0;
     Table1.FieldByName('Street').AsString := FetchElm(RetNo,FirstFormName,4);
     Table1.FieldByName('City').AsString := FetchElm(RetNo,FirstFormName,7);
     {tax province}
     Table1.FieldByName('Province').AsString :=
       GetShortPrv(FetchElm(RetNo,FirstFormName,9)); {from long to short}
     Table1.FieldByName('Postal').AsString := FetchElm(RetNo,FirstFormName,8);
     Table1.FieldByName('Area').AsString := FetchElm(RetNo,'T3',5);
     Table1.FieldByName('Phone').AsString := FetchElm(RetNo,'T3',6);
     Table1.FieldByName('Created_by').AsString := FetchElm(RetNo,'STATUS',5);
     Table1.FieldByName('Created_tm').AsString := FetchElm(RetNo,'STATUS',7);

     Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
     Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);

     Table1.FieldByName('PRP_Status').AsString := FetchElm(RetNo,'STATUS',4);
     Table1.FieldByName('Updated_by').AsString := User.UserName; //20170112 Igor
     Table1.FieldByName('Updated_dt').AsString := FetchElm(RetNo,'STATUS',12);
     Table1.FieldByName('Updated_tm').AsString := FetchElm(RetNo,'STATUS',13);
     Table1.FieldByName('Notes').AsString := FetchElm(RetNo,'STATUS',14);

     Table1.Post;
    end;
   Table1.Free;
   ADConnection.Free;
   Result := 0;
end;

Function SaveReturn(RetNo: integer; DataDir: string; FlName: string;
  OverrideSw: Boolean; UpdMostRecent: Boolean; ATextFormat: Boolean = False;
  AUpdateClientTable: Boolean = True; AClouds: TArrayOfInteger = nil):integer; //20160405 Igor //20190228 Igor
//Function SaveReturn(RetNo : integer; DataDir: string;FlName: string;OverrideSw:Boolean):integer;
var
  i,j,k,FNo, SNo : integer;
  SQLite: TSQLiteStorage; //20160415 Igor
  S : string; //[16];
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
  //If UpperCase(InputBox('TF Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20250119

  if RetList[RetNo].Locked then
  begin
    RetList[RetNo].Changed := False;
    Result := iorFileType;
    exit;
  end;
   If FlName = '' then
    begin
     Result := -2; {?}
     ShowMessage('Account is required');
     exit;
    end;
  //20170902 Igor>>>
  if AppTF_2026.ExceedsMaxReturnsAllowed(False) then
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
    SQLite := TSQLiteStorage.Create(DataDir, FlName, fsWrite, AppTF_2026.SQLLitePassword.PassRFArray);
    if SQLite.LastError <> '' then
    Begin
      ShowMessage(SQLite.LastError);
      SQLite.Free;
      exit;
    End;
     //20160415 Igor<<<

try
 //20160415 Igor>>>
    if not SQLite.WriteSettings('AppName',AppName) then
    Begin
      MessageDlg(SQLite.LastError,mtError,[mbOk],0);
      exit;
    end;
    if not SQLite.WriteSettings('TAXFORMS','TAXFORMS') then
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
     {ShowMessage('processing form '+Frec.FormInstName);}
      if Ret[RetNo].FrmHasData[FNo] then
      Begin
        RetList[RetNo].WriteFData(FRec, SQLite); //20160415 Igor
      end;
    end;
    RetList[RetNo].WriteLnEtc(0,-1, SQLite); //20160415 Igor
  finally
  //unlock the file
    SQLite.free; //20160415 Igor
  end;
    If Result = 0 then Ret[RetNo].Changed := False;

   // SaveScreenSettings(Sc,ScChar,ScChange,LeftPanelWidth);

    If UpdMostRecent = true then
    begin
     UpdateMostRecentFiles(RetNo,DataDir,FlName,GetAccountNumber(RetNo));
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
    CloudPath := HelperManager.Config(HelperClassName, AppTF_2026.AppId, User.UserName).Path;
    ClientID := HelperManager.Config(HelperClassName).ClientID;
    Token := HelperManager.Config(AClouds[I], AppTF_2026.AppId, User.UserName).Token;
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
    if HelperManager.Config(AClouds[I], AppTF_2026.AppId, User.UserName).SaveToken AND
       (Token <> '') AND
       (Token <> HelperManager.Config(AClouds[I], AppTF_2026.AppId, User.UserName).Token) then
      HelperManager.Config(AClouds[I], AppTF_2026.AppId, User.UserName).Token := Token;
  end;
  if S <> '' then
    MessageDlg(S, mtInformation, [mbOk], 0);
  //20190228 Igor
end;

Function ReadReturn(DataDir,FlName: string;RecalcFlag:boolean;
  AIsAppendix: Boolean = False; AConvert: Boolean = False):integer; //20160305 Igor //20160629 Igor
var
  Converting : Boolean;FormNm :string; //[12];
  selm,valu,DataVers,DataYear:String;
  i,j,k,FNo, SNo, BxNo,T5013SumFNo : integer;
  //Table1 : TADTable;
  ConvertingToCombinedForms:Boolean;
  IncrElmList:TStringList;
  S,OldFormNm : String;
  Var1,Var2,Var3,Var4 : String;
  RetNo: integer absolute Result;
  fs: TFileStorage;
 //20160415 Igor>>>
  PrevFormName: String;
  SQLite: TSQLiteStorage;
  function ReadNextLine: Boolean;
  Begin
  // If UpperCase(InputBox('TF Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20250119
    //20161206 Igor >>>
    Result := vtFileStorage.ReadNextLine(SQLite, Var1, Var2, Var3, Var4, fs);
    //20161206 Igor <<<
  End;
   //20160415 Igor<<<

begin
  if IsAuthorizedPreparer=False then exit; //20220512 Igor
  Result := CheckReturnPsw(DataDir,FlName);
  if Result < 0 then
    exit;

  Result := iorUnknown;
Try  //except
  Converting := False;
  ConvertingToCombinedForms :=False;

  IncrElmList:=TStringList.Create;
  IncrElmList.LoadFromFile(AppDir+'\'+'IncrElm.d');
 // SomeList := TStringList.Create; {used to save FNo's of the return}

 //20160415 Igor>>>
  PrevFormName := '';
  SQLite := TSQLiteStorage.Create(DataDir, FlName, fsRead, AppTF_2026.SQLLitePassword.PassRFArray);
  if SQLite.LastError <> '' then
  Begin
    FreeAndNil(SQLite);
    fs := TFileStorage.Create(DataDir,FlName,fsRead);
  End;
   //20160415 Igor<<<

  try
    //NextLine;
     //20160415 Igor>>>
    if Assigned(SQLite) then
    Begin
       if not SQLite.ReadSettings('TAXFORMS', Var1) or
          not SQLite.ReadSettings('AppYear', Var2) or
          not SQLite.ReadSettings('AppRelease', Var3) then
       Begin
         ShowMessage(SQLite.LastError);
         exit;
       end;
    end
    else
     //20160415 Igor<<<
      fs.ReadLine(Var1,Var2,Var3,var4);

    DataVers:=Var3;
    DataYear := Var2;
   // If (DataYear <='2011') {and (DataVers <'2.0'))} then ConvertingToCombinedForms:=True;

    If (Var1 <> 'TAXFORMS')
    then
     begin
      Result := iorFileType;  // -2;
      exit;
     end;

    Result := CreateNewReturn(DataYear, AConvert);

    if Result < 1 then
      exit;

    If (Var2 < IntToStr(StrToInt(AppYear))) AND not AIsAppendix then //20160629 Igor
    begin
      Converting := True;
      ShowMessage('Converting from previous year'+Chr(13)+' '+Chr(13)+'ALWAYS SAVE ON THE '+Appyear+' DATA DIRECTORY'+
                  Chr(13)+'Press any key');
      CFZeroAmounts; //20201221
    end;

    { Temp to avoid conversion  **************
    If (Var2 < IntToStr(StrToInt(AppYear))) AND not AIsAppendix then //20160629 Igor
    begin
      Converting := False;
      CFZeroAmounts; //20201221
    end;
    }

    Ret[RetNo].isAppendix := AIsAppendix; //20160703 Igor

    while ReadNextLine do //20160415 Igor
    begin
       if Var1 = 'F' then   {Form record}
       begin
        OldFormNm:=Var2;
        If ConvertingToCombinedForms then
        Begin
         Var2:=ConvertFNameToCombined(OldFormNm);
         If LeftStr(Var2,4)='PAGE' then Var2:='T3';
         If Var2='INV_2' then Var2:='INVOICE';
         If Var2='INV_1' then Var2:='INVFORMS';
        end;

        FormNm := Var2;
       // ShowMessage(FormNm);
        Fno := GetFormNo(Var2, true, RetNo); //20160704 Igor

        {ShowMessage(FormNm);}
        If (FNo = 0) and (IsFormMultiInst(Var2)) then
         begin
          AddPageInstance(RetNo, ExtractNonInstFormName(Var2),ExtractFormInst(Var2));
          AddOtherPagesInstance(ExtractNonInstFormName(Var2),ExtractFormInst(Var2));
          Fno := GetFormNo(Var2); {get it again}
         end;

        If FNo > 0 then
          begin
           If FormNm<>'T3' then //20130119
            InitFormData(RetNo,FNo);  //20130119
           Ret[RetNo].FrmHasData[FNo] := True;
          end;
       end

       else if Var1 = 'D' then  {Detail Form Data}
       begin
         sElm:=Var2;
         Valu:=Var3;
         if UpperCase(valu)='ETC' then
         begin
          UserMsg('Reading of data may be incomplete: Form '+ FormNm
          +' Var1= '+Var1  //20220109
          +' Var2= '+Var2
          +' Var3= '+Var3
          +' Var4= '+Var4);
         end;
        // If ConvertingToCombinedForms then sElm:=IntToStr(ConvertElmNoToCombined(OldFormNm,StrToInt(sElm),IncrElmList)); //20220109

         If FNo > 0 then
         begin
             If Converting then
             begin
               CFFilterLastYrAndStore(RetNo,FormNm,FNo,StrToInt(sElm),Valu) //20120119
               //CFFilterLastYrAndStore(RetNo,FormNm,FNo,StrToInt(Var2),Var3)
             end
             else
               StoreElm(RetNo,FNo,StrToInt(sElm),Valu); //20120119
                //StoreElm(RetNo,FNo,StrToInt(Var2),Var3);
          end
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
          if not converting then
           begin
           SetFieldOverride(RetNo,GetFormNo(Var2),StrToInt(Var3));
           SaveFieldOverride(RetNo,GetFormNo(Var2),StrToInt(Var3),Var4);
           end;
       end
       else if Var1 = 'R' then  {Review marks}
       begin
        if not converting then
        SetReviewMark(RetNo,GetFormNo(Var2),StrToInt(Var3))
       end
    end;
  finally
    if Assigned(fs) then //20160415 Igor
      fs.Free;
    if Assigned(SQLite) then //20160415 Igor
      FreeAndNil(SQLite); //20160415 Igor
    IncrElmList.Free;
  end;

    FNo:=GetFormNo('STATUS');
    if Ret[RetNo].Frm[Fno].Count = 0 then
    begin
       InitFormData(RetNo,FNo);
       InitStatusForm(RetNo,GetFormNo('STATUS'));
    end;

    Ret[RetNo].PrpStatus := FetchElm(RetNo,'STATUS',4);
    If Vl(Ret[RetNo].PrpStatus)=6 then LockReturn(RetNo);
    Ret[RetNo].Notes := FetchElm(RetNo,'STATUS',14);
    Ret[RetNo].SourceDataDir := DataDir;
    Ret[RetNo].SourceFlName := FlName;
    Ret[RetNo].isAppendix := AIsAppendix; //20160305 Igor
    //20170225 Igor >>>
    if FetchElm(RetNo, 'STATUS', c_ReturnColorElm) <> '' then
    try
      SetRetColor(RetNo, StringToColor(FetchElm(RetNo, 'STATUS', c_ReturnColorElm)), c_ReturnColorElm);
      MainForm.GuiCommand(gcColorChanged);
    except
    end;
    //20170225 Igor <<<
    If Converting then
     begin
      CFReformatLastYearData(RetNo);
      Ret[RetNo].SourceDataDir := OptRec.Dir_Cur;
      RelocateCharityForms(RetNo); //20130216
     end;

    If (DataVers<'2.0') and (AppYear='2006')
    then CopyT5015ToS50(RetNo);

    CalcAll(RetNo);  //20170502  //CON after igor's update
  if RecalcFlag AND not AIsAppendix then //20160704 Igor
  begin
    CalcAll(RetNo);
    if AIsAppendix then  //20160305Igor
      MainForm.AuditOpenBtnClick(Application); //?
  end;

 except
     //Result := 0; - RetNo still valid!!!
     //ShowMessage('Reading of data may be incomplete '+ Formname);
     UserMsg('Reading of data may be incomplete: Form '+ FormNm
        +' Var1= '+Var1  //20220109
        +' Var2= '+Var2
        +' Var3= '+Var3
        +' Var4= '+Var4);
 end;
 Ret[RetNo].changed := False; // 20170112 Igor
end;

Procedure ClearForm(RetNo:integer;FName:string);
var i,n,FNo :integer;
begin
  Fno := GetFormNo(FName);
  If (Fno >0) and (Ret[RetNo].Frm[FNo].Count >0)  then
  begin
    vtShared.ClearForm(RetNo,FName);
    CalcAll(RetNo);
  end;
end;

Function OpenReturn(DataDir,FlName: string;ShowSw:Boolean; AIsAppendix: Boolean = False): Integer; //20160305 Igor
{result:
 0=OK,
 -1=File does not exist,
 -2=not a tax return
 -3=exceeds limit
 -4:= password wrong
 }

begin
  //20170502 Igor >>>
  if RetInMem(AppTF_2026, True) >= AppTF_2026.LimitReturns then
    Exit(-3);
  //20170502 Igor <<<

  if not AIsAppendix then
    MainForm.GUICommand(gcHideLastYear); //20160621 Igor
  ApplicationState := ApplicationState + [asLoadReturn];
  try
    {$IFDEF ReturnsLimit}
    if RetInMem >= ReturnsLimit then begin Result := -3; exit; end;
    {$ELSE}
    {$ENDIF}
    Result := ReadReturn(DataDir,FlName,ShowSw, AIsAppendix); //recalc only if showing? //20160305 Igor
    if Result < 1 then
      ShowOpenReturnFailure(Result,DataDir,FlName)
    else
    Begin
      Ret[Result].IsAppendix := AIsAppendix; //20160302 Igor
      if not AIsAppendix then
        MainForm.GuiCommand(gcRetNoChanged);
      AddLogAppMon(amtOnRead, Result); //20220519 Igor
    End;
  finally
    ApplicationState := ApplicationState - [asLoadReturn];
  end;
end;

Procedure GetStatusFromDB(DataDir:string;FlName:string;Var PrepSt:string;Var CreateDate:String);
Var FNo :Integer;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  PrepSt :='00';
  If not FileExists(DataDir+'\'+ClientsDBLite) then exit;
  //20150923 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'FILE_NAME');

  if 1=1 then // Table1.State = dsInactive //rem 20150923 Igor
  begin
     Table1.Open;
     if Table1.FindKey([FlName]) then
     begin
      PrepSt := Table1.FieldByName('PRP_Status').AsString;
      CreateDate:=Table1.FieldByName('Created_Dt').AsString;
      Table1.Close;
     end;
  end;
  Table1.Free;
  ADConnection.Free;
end;

end.
