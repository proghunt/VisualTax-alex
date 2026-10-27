unit T2_2027common;
//unchanged 2014-07-30

{=============================================================}
interface
{=============================================================}
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,T2_2027,
  T2_2027TrimStr,T2_2027Declare,T2_2027Common2,T2_2027Features;

{-------------  Function declarations ---------------------}
Procedure InitFrmTree;
procedure InitBmps;
Function CreateNewReturn(AYear: String = ''; AConvert: Boolean = False): integer; //20160331 Igor //20160424 Igor
Procedure RemoveReturnFromMemory(RetNo:integer);
Procedure RemoveCoupling(RetNo:Integer);
Function IsCouplingOn(RetNo:integer): Boolean;
Function CloseReturn(RetNo : integer; fRemove: boolean = True): boolean;
Function GetRetName(RetNo:integer): string;

{color routines}
procedure InitColorTable;
function GetNextAvailColor:Longint;

{ Forms - independent of RetNo}
function GetFormDescr(RlName: String):String;
function GetFormName(FormNo: integer; ARetNo: Integer = 0):String;
function GetFName(AbrevName: String):String;
function GetFormAbrevName(FormNo: integer):String;
function GetFormRlName(FormNo: integer):String;  {plain title: ie Sch 1}
Function GetFormRlNm(FName: String):String;
function GetFormNo(FName: String; ARetNo: Integer = 0):Integer;

function CountMxInst(NonInstFormName: String): Integer;
function GetHighestInst(NonInstFormName: String): Integer;
Function GetFormMxPg(FormName: string): integer;
{function InitFormsTable: boolean;}

Function ExtractFormPageNo(FormName: String): integer;

{other}

Procedure DrawTab(ACanvas : TCanvas; TabX,TabY:integer; TabColor:Tcolor; TabText: String);
Function GetDescrFromCode(Code: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
Function GetCodeFromDescr(Description: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
Function GetQueryName(QDescr: string): string;
Function ChangeDataDir(NewDataDir: String): Boolean;
Procedure InitSwitches;
procedure InitLists;

{==============================================================}

implementation

uses vtMulti,vtCommon,vtMain,T2_2027SaveAs,T2_2027Calc,T2_2027Main,vtTrimStr,
  vtShared;

{==============================================================}
(*
Implementation of functions and procedures in a DLL
procedure DrawApi; external 'SELECT';
function MinR; external 'T1DLL';
function MaxR; external 'T1DLL';
*)


Function GetRetName(RetNo:integer): string;
begin
 Result := Rtrim(FetchElm(RetNo,'T2',3));
 If Result ='' then result := '(Un-named)';
end;

Function ResourcesLow:Boolean;
begin
 Result := false;
{
 If (GetFreeSystemResources(GFSR_USERRESOURCES) < 7) or
  (GetFreeSystemResources(GFSR_GDIRESOURCES) < 7)  or
  (GetFreeSystemResources(GFSR_SYSTEMRESOURCES) < 7)
  then Result := True;
 }
end;

Function IsFormMultiInst(FormName: String): Boolean;
Var
I : integer;
begin
 Result := False;
 i := Length(FormName);
 While i >0 do
  begin
   If FormName[i] = '#' then begin Result := True; exit; end;
   Dec(i);
  end;
end;

Function ChangeDataDir(NewDataDir: String): Boolean;
begin
Result := True;
If NewDataDir = AppDir then
  begin
   ShowMessage('You cannot use the Program Directory as Data Directory');
   Result := False;
   exit;
  end;
 If SysUtils.DirectoryExists(NewDataDir) = False then //20150701
 begin
  ShowMessage(NewDataDir + CHR(13)+'does not exist');
  Result := False;
  exit;
 end;

 If not FileExists(NewDataDir+'\'+ClientsDBLite) then //20150922 Igor
 begin
  ShowMessage(NewDataDir + CHR(13)
    +'Directory does not contain a Client Data Base');  //201602267 Igor
  Result := False;
  exit;
 end;
end;

Function GetQueryName(QDescr: string): string;
var i: integer;
begin
 result := '';
 If QDescr = 'All' then
 begin
  Result:= 'All';
  exit;
 end;

 For i:= Low(PRPQueries) to High(PRPQueries) do
   If QDescr = PRPStatusDescr[i] then
    begin
     Result := PRPqueries[i];
     break;
    end;
end;



Function GetDescrFromCode(Code: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
var i: integer;
begin
 result := '';
 For i:= Low(Codes) to High(Codes) do
   If Codes[i] = Code then
    begin
     Result := Descriptions[i];
     exit;
    end;
end;

Function GetCodeFRomDescr(Description: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
var i: integer;
begin
 result := '';
 For i:= Low(Codes) to High(Codes) do
   If Descriptions[i] = Description then
    begin
     Result := Codes[i];
     exit;
    end;
end;

Function CloseReturn(RetNo : integer; fRemove: boolean): boolean;
var Reply : Word;
begin
  Result := True;
 If RetNo = 0 then Exit;

//check for already removed or already destroying return
 Result := (RetList[RetNo] = nil) or (RetList[RetNo].Destroying);
 if Result then
  exit; //bad call

 if not RetList[RetNo].Changed or //20160711 Igor
    (RetList[RetNo].IsAppendix) then //20160608 Igor //20160711 Igor
  begin
    Result := True;
  end else begin
   {Data changed}
   Reply := MessageDlg('Save data?',mtInformation, [mbYes, mbNo, mbCancel], 0);
   Case Reply of
     mrYes:
        begin
         Screen.Cursor := crHourGlass;
         If Ret[RetNo].FedCalcStatus=False then
          CalcFed(RetNo);
         If Ret[RetNo].OntCalcStatus=False then
          CalcOnt(RetNo);
         If Ret[RetNo].AlbCalcStatus=False then
          CalcAlb(RetNo);
         UpdateAllDataIndicators(RetNo);

         If Ret[RetNo].MandatoryErrorCount>0 then
         begin
          ShowMessage('Mandatory items must be cleared before saving the return');
          exit;
         end;

         ExecuteForm(TSaveAsT2_2027);
         Result := True;
        end;
      mrNo : Result:= True; //RemoveReturnFromMemory(RetNo);Exit;End;
      mrCancel: Result:=False;  //exit;end;
    else
    end;
  end;
  if Result and fRemove then
    RemoveReturnFromMemory(RetNo);
end;

Procedure RemoveReturnFromMemory(RetNo:integer);
var
  I: Integer;
begin
  if RetList[RetNo].Destroying then
    exit; //recursive call!
  //20160608 Igor
  //if last year's return remove the link from this year's return.
  for i :=1 to (RetList.Count - 1) do
    if assigned(RetList.Items[i]) AND
       (RetList.Items[i].LastYearRetNo = RetNo) then
      RetList.Items[i].LastYearRetNo := 0;

  RemoveCoupling(RetNo);
  DeEnlistReturn(RetNo);
end;

Function CreateNewReturn(AYear: String = ''; AConvert: Boolean = False):Integer; //20160331 Igor //20160424 Igor
var
  MyRet: TRetData;
begin
//20170902 Igor>>>
//  //20170502 Igor >>>
//  if RetInMem(AppT2, True) >= AppT2.LimitReturns then
//    Exit(-3);
//  //20170502 Igor <<<
  If IsDataDirectoryGood(OptRec.Dir_Deflt) = False then
    Result := 0 //error already shown
  else
//  If AppT2.ExceedsMaxReturnsAllowed(True) then
//    Result := 0 //message shown on errors
//  else
//{$IFDEF ReturnsLimit}
//  if RetInMem >= ReturnsLimit then
//    Result := -3
//  else
//{$ELSE}
//{$ENDIF}
//20170902 Igor<<<
  begin
  //20161225 Igor >>>
  (*
    if (AYear = '') //new return
       or (AYear = AppT2.AppYear) //from read return
       or AConvert  //20160329 Igor
    then
    begin
      If IsDataDirectoryGood(OptRec.Dir_Deflt) = False then exit;
      MyRet := TRetT2_2027.Create(AppT2);
    end
    else if StrToInt(AYear) = StrToInt(AppT2.AppYear)-1 then
    begin
      //last year return
      MyRet := TRetT2_LastYear.Create(AppT2);
    end
    else
      exit;
   *)
   if not AConvert AND
      (AYear <> '') AND
      (StrToInt(AYear) = StrToInt(AppT2.AppYear) - 1) then
   begin
     MyRet := TRetT2_LastYear.Create(AppT2);
   end
   else
     MyRet := TRetT2_2027.Create(AppT2);
   //20161225 Igor <<<
//    MyRet := TRetT2_2027.Create(AppT2);
//    if (AYear <> '') AND (StrToInt(AYear) = StrToInt(AppT2.AppYear)-1) then //20160331 Igor
//      MyRet.IsLastYearReturn := true;                                     //20160331 Igor
    if MyRet = nil then
      Result := -3 //???
    else
      Result := MyRet.RetNo;
  end;
end;

Procedure DrawTab(ACanvas : TCanvas; TabX,TabY:integer; TabColor:Tcolor; TabText: String);
var
i :integer;
TabLength, TabWidth,StartTextY : integer;

begin
ACanvas.Brush.Color := TabColor;
TabLength := Length(TabText) * 15; TabWidth := 20;
ACanvas.Polygon([
     Point(TabX,TabY),
     Point(TabX+TabWidth,TabY+(TabLength div 8)),
     Point(TabX+TabWidth,TabY+TabLength-(TabLength div 8)),
     Point(TabX,TabY+TabLength)
     ]);
ACanvas.Font.Name := 'Arial';
ACanvas.Font.Size := 8;
ACanvas.Font.Style := [FsBold];
StartTextY := TabY + TabLength div 10;
ACanvas.Textout(TabX + TabWidth div 2,StartTextY,TabText[1]);
for i :=2 to Length(TabText) do
    ACanvas.Textout(TabX + TabWidth div 2,StartTextY+12*(i-1),TabText[i]);

end;

procedure InitBmps;
{var LogoBmp:Tbitmap;}
begin
end;

procedure InitLists;
{MUST create the data lists AND also initialize them before using them}
var
i,j,k : integer;
s : string;
begin
  //TabNo        := 0;
  //StringLists.AddSingle(@AuditEfileList, TSingleStringList);
  //StringLists.AddSingle(@ElmsInError, TSingleStringList);
  //OverList     := TList.Create;
  //ReviewList   := TList.Create;
  //FormList     := Tlist.Create;
  //StringLists.AddSingle(@AffectedList, TSingleStringList);
  //AffectedList.LoadFromFile(AppDir +'\'+ 'Affected.D');
//20170515 Igor >>>
  TaxSumList := TSingleStringList.Create;
//  StringLists.AddSingle(@TaxSumList, TSingleStringList);
  {TaxSumList.LoadFromFile(AppDir +'\'+ 'TAXSUM.D');}
//  StringLists.AddSingle(@T2_2027Declare.SomeList, TSingleStringList); //or single in vtMulti? //20160907 igor
  VList := TSingleStringList.Create;
//  StringLists.AddSingle(@VList, TSingleStringList);
//20170515 Igor <<<
  InitFrmTree;
  InitCCARates;
  InitPrvRates(0); //no RetNo available here!
  InitPredictiveFiles;
  T2FNo:=GetFormNo('T2');   //20201212
end;

procedure FreeLists;
begin
(* destroy all TLists
*)
  //FreeAndNil(ElmsInError);
  //FreeAndNil(OverList);
  //FreeAndNil(ReviewList);
  //FreeAndNil(FormList);
  FreeAndNil(DataDictList);
  //FreeAndNil(FList);
  //20170515 Igor >>>
  FreeAndNil(TaxSumList);
  FreeAndNil(VList);
  //20170515 Igor <<<
end;

Procedure InitSwitches;
begin
  //shared MainForm switches
end;

{------------}

function GetHighestInst(NonInstFormName: String): Integer;
var
i , InstNo: Integer;
begin
   Result := 0;
   for i :=0 to (FList.Count - 1) do
   begin
        FRec := FList.Items[i];
        if FRec.FormName = NonInstFormName then
         if LeftStr(FRec.FormInst,1) =  '#' then
          begin
           InstNo := StrToInt(MidStr(FRec.FormInst,2,1));
           if InstNo > result then Result := InstNo;
          end;
   end;
end;

function CountMxInst(NonInstFormName: String): Integer;
var i : Integer;
begin
   Result := 0;
   NonInstFormName := Ltrim(RTrim(NonInstFormName));
   for i :=0 to (FList.Count - 1) do
   begin
        FRec := FList.Items[i];
        if LeftStr(FRec.FormInst,1) = '#' then
         begin
         {ShowMessage(FRec.FormName +','+FRec.FormInst);}
         if FRec.FormName = NonInstFormName then Inc(Result);
         end;
   end;
end;


function GetFormDescr(RlName: String):String;
Var I :integer;
begin
Result :='';
RlName :=RTrim(RlName);
for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If RlName = FRec.FormRlNm
      then Result := FRec.FormAbrev;
   end;
End;

function GetFName(AbrevName: String):String;
var
 i: Integer;
begin
 Result := '';
 AbrevName := RTrim(AbrevName);
  for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if LeftStr(FRec.FormAbrev,Length(AbrevName)) = AbrevName then
        begin Result := FRec.FormInstName;exit;end;
    end;
end;

function GetFormName(FormNo: integer; ARetNo: Integer = 0):String;
begin
  //20160704 Igor >>>
//  Result := FList.ByFormNoDummy(FormNo).FormInstName;
  if (ARetNo > 0) and Ret[ARetNo].IsLastYearReturn then //20160704 Igor
    Result := FLastYearList.ByFormNoDummy(FormNo).FormInstName
  else
    Result := FList.ByFormNoDummy(FormNo).FormInstName
  //20160704 Igor <<<
end;

function GetLastYearFormName(FormNo: integer):String; //20160704 Igor
begin
  Result := FLastYearList.GetFormName(FormNo);
end;

function GetFormAbrevName(FormNo: integer):String;
begin
 Result := '';
  FRec := FList.ByFormNoNil(FormNo);
  if FRec<>nil then
    Result := FRec.FormAbrev+' ' +Frec.FormInst;
end;

function GetFormRlName(FormNo: integer):String;
begin
 Result := '';
  FRec := FList.ByFormNoNil(FormNo);
  if FRec<>nil then
    Result := FRec.FormRlNm+' ' +Frec.FormInst;
end;

Function GetFormRlNm(FName: String):String;
Var I :integer;
begin
  //Result :='';
  Result:=RTrim(FName);
  FRec := FList.ByFormName(FName);
  if FRec.FormNo > 0 then
    Result := FRec.FormRlNm;
End;

function GetFormNo(FName: String; ARetNo: Integer = 0):Integer;
begin
  //20160704 Igor >>>
//  Result := FList.ByFormName(FName).FormNo;
  if (ARetNo > 0) and Ret[ARetNo].IsLastYearReturn then //20160704 Igor
  begin
    //20160710 Igor
    if not AppT2.InitLastYear then
    begin
      Result := 0;
      exit;
    end;
    Result := FLastYearList.ByFormName(FName).FormNo
  end
  else
    Result := FList.ByFormName(FName).FormNo
  //20160704 Igor <<<
end;


{----------------}

procedure InitColorTable;
var
  Colors: TColorTable absolute ColorList;
begin
  Colors[0] := RGB(254,243,214); {light YELLOW}    //10
  Colors[1] := RGB(222,234,235);     {light grey}  //0
  Colors[2] := Rgb(255,255,223); //Rgb(204,220,227);   {pastel yellow}   //1
  Colors[3] := RGB(195,255,255);        {light cyan gp}  //0
  Colors[4] := MyBeige; {RGB(255,255,0);}      {mybeige}        //2
  Colors[5] := RGB(224,223,227);      {light btnface}    //8
  Colors[6] := RGB(192,192,192);      {grey}      //4
  Colors[7] := RGB(192,220,192);      {pastel green}       //5
  Colors[8] := RGB(128,255,255);      {cyan}                //6
  Colors[9] := $00E7CFCF; (* $00F1E4E4;*) (* $00C08080; *)      {mauve}  //7
  Colors[10] := RGB(255,236,236);      {Pink}  //8
  Colors[11] := MyBronze;      {mybronge}        //9
end;

function GetNextAvailColor:Longint;
begin
  Result := NextAvailColor(ColorList);
end;

Function ExtractFormPageNo(FormName: String): integer;
var i :integer; s:string;
begin
 If GetFormMxPg(FormName) <2 then begin Result := 0;exit; end;
 s:='';
 For i:=1 to Length(FormName) do
 begin
  If FormName[i] = '#' then break else s:=s+FormName[i];
 end;

 i := 1;
 while (i <= Length(s)) and not (s[i] ='_') do inc(i);
 Result := MyStrToInt(copy(AllTrim(s),i+1,2));
end;


Function GetFormMxPg(FormName: string): integer;
var
i: Integer;
begin
   Result := 0;
   for i :=0 to (FList.Count - 1) do
   begin
        FRec := FList.Items[i];
        if FRec.FormInstName = FormName then
          begin Result := FRec.FormMxPg; exit; end;
   end;
end;

Procedure RemoveCoupling(RetNo:Integer);
var
 i : integer;
begin
  Ret[RetNo].CouplingSw := False;
end;


Function IsCouplingOn(RetNo:integer): Boolean;
var
 i : integer;
begin
  Result := Ret[RetNo].CouplingSw;
end;

Procedure InitFrmTree;
Var i:Integer;{TempList:TStringList;}
begin
//20170512 igor >>>
//  StringLists.AddSingle(@FrmTreeDescr, TSingleStringList);  // :=TStringList.Create;
//  StringLists.AddSingle(@FrmTreeForms, TSingleStringList);  // :=TStringList.Create;
//20170512 Igor <<<
  FrmTreeDescr.LoadFromFile(AppDir+'\'+'Treeview.d');
  For i:=0 to FrmTreeDescr.Count-1 do
  begin
    FrmTreeForms.Add(MidStr(FrmTreeDescr[i],62,9));
    FrmTreeDescr[i] := LeftStr(FrmTreeDescr[i],61);
  end;
  FrmTreeDescr.SaveToFile(AppDir+'\'+'TreeView2.d');
end;

initialization
//20170512 Igor>>>
  FrmTreeForms := TSingleStringList.create;
  FrmTreeDescr := TSingleStringList.create;  //mine on 20150702 //20170512 Igor

Finalization
  FreeAndNil(FrmTreeForms);
  FreeAndNil(FrmTreeDescr);
//20170512 Igor <<<
  FreeLists;
end.

