unit FP_2027Common;


{=============================================================}
interface
{=============================================================}
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,FP_2027,vtMulti;

{-------------  Function declarations ---------------------}

Function CreateNewReturn(DataYear: string = ''; AConvert: Boolean = False):Integer; //20160704 Igor
Procedure RemoveReturnFromMemory(RetNo:integer);
{Return}
Procedure RemoveCoupling(RetNo:Integer);
Function IsCouplingOn(RetNo:integer): Boolean;
Function CalcMarStatus(RetNo: integer): Integer;
Function CloseReturn(RetNo : integer; fRemove: boolean): boolean;

Function CountUnsavedReturns: Integer;

{color routines}
procedure InitColorTable;
function GetNextAvailColor:Longint;

{Configuration options}
Function OpenCfg: boolean;

{ Forms - independent of RetNo}



function CountMxInst(NonInstFormName: String): Integer;
function GetHighestInst(NonInstFormName: String): Integer;
function GetFormRlName(FormNo: integer):String;  {plain title: ie Sch 1}
Function GetNextFormPage(FormName: string): String;
Function GetFormMxPg(FormName: string): integer;

Function ExtractFormPageNo(FormName: String): integer;

{other}
Function GetPrvIndex(SPrv: string): Integer;

Procedure DrawTab(ACanvas : TCanvas; TabX,TabY:integer; TabColor:Tcolor; TabText: String);

Function GetDescrFromCode(Code: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
Function GetCodeFromDescr(Description: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
Function GetQueryName(QDescr: string): string;
Function ChangeDataDir(NewDataDir: String): Boolean;
Function MouseOnBox(x,y,X1,Y1,X2,Y2: integer):boolean;

{==============================================================}
implementation

uses vtCommon,vtMain,FP_2027TrimStr,FP_2027Declare,FP_2027Common2,
     FP_2027Features,FP_2027Main,FP_2027SaveAs,FP_2027CalcTax, vtTrimStr, vtShared
   , vtDataBase, uADCompClient; // 20150921 Igor

{==============================================================}
(*
Implementation of functions and procedures in a DLL
procedure DrawApi; external 'SELECT';
function MinR; external 'T1DLL';
function MaxR; external 'T1DLL';
*)

Function CalcMarStatus(RetNo:Integer): Integer;
Var i : integer;
Begin
 Result := 6; {single}
 For i := 11 to 13 do
  If FetchElm(RetNo,FirstFormName,i) > '' then
      result := i - 10;
 For i := 16 to 18 do
  If FetchElm(RetNo,FirstFormName,i) > '' then
      result := i -15 + 3;
end;


Function CopyReturn(DataDir:String;FileName:String;DestinationDir:string):boolean;
begin
  ShowMessage('Copying: '+FileName);
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
  //20160518 Igor >>>
// If DirectoryExists(NewDataDir) = False then
// begin
//  ShowMessage(NewDataDir + CHR(13)+'does not exist');
//  Result := False;
//  exit;
// end;
//
// If not FileExists(NewDataDir+'\'+ClientsDBLite) then //20150922 Igor
// begin
//  ShowMessage(NewDataDir + CHR(13)
//    +'Directory does not contain a Client Data Base'); //201602267 Igor
//  Result := False;
//  exit;
// end;
  //20160518 Igor <<<
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
 (*
 For i:= Low(EFQueries) to High(EFQueries) do
   If QDescr = EFStatusDescr[i] then
    begin
     Result := EFqueries[i];
     break;
    end;
 *)
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

(*
Function GetEfStatusDescr(EFStatusCode: String):String;
var i: integer;
begin
 result := '';
 For i:= Low(EFStatusCodes) to High(EFStatusCodes) do
   If EFStatusCodes[i] = EFStatusCode then
    begin
     Result := EFStatusDescr[i];
     exit;
    end;
end;

Function GetEfStatusCode(EFStatusDescr: String):String;
var i: integer;
begin
 result := '';
 For i:= Low(EFStatusCodes) to High(EFStatusCodes) do
   If EFStatusDescr[i] = EFStatusDescr then
    begin
     Result := EFStatusCodes[i];
     exit;
    end;
end;

Function GetPRPStatusDescr(PRPStatusCode: String):String;
var i: integer;
begin
 result := '';
 For i:= Low(PRPStatusCodes) to High(PRPStatusCodes) do
   If PRPStatusCodes[i] = PRPStatusCode then
    begin
     Result := PRPStatusDescr[i];
     exit;
    end;
end;

Function GetPRPStatusCode(PRPStatusDescr: String):String;
var i: integer;
begin
 result := '';
 For i:= Low(PRPStatusCodes) to High(PRPStatusCodes) do
   If PRPStatusDescr[i] = PRPStatusDescr then
    begin
     Result := PRPStatusCodes[i];
     exit;
    end;
end;
*)
Function CountUnsavedReturns: Integer;
var
i : integer;
begin
Result := 0;
for i :=0 to (RetList.Count - 1) do   //20220306
//for i :=1 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   if Retrec <>Nil then //20220306
   Begin
   if RetList[RetRec.RetNo].Changed then Inc(Result); //20160711 Igor
   end;
 end;
end;

Function CloseReturn(RetNo : integer; fRemove: boolean): boolean;
var sinno :string;Reply : Word;SpRetNo:Integer;
begin
 Result := False;
 If RetNo = 0 then Exit;
 //20160711 Igor
 if not assigned(RetList[RetNo]) then
 begin
   result := True;
   exit;
 end;

 if (RetList[RetNo].Changed = False) or RetList[RetNo].isAppendix then //20160711 Igor
  begin Result := True;RemoveReturnFromMemory(RetNo);Exit;end;
 {Data changed}
 Reply := MessageDlg('File will be closed'
          +Chr(13)+'Save data for '+GetFirstName(RetNo)+
          ', '+GetLastName(RetNo)+'?',
          mtInformation, [mbYes, mbNo, mbCancel], 0);
 Case Reply of
   mrYes:
   begin
     If MainFormFP.EditBeforeSave(RetNo) = false then //exit;
     begin
        if MessageDlg('Mandatory data are missing. Close without saving?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
         Result:= True;
         RemoveReturnFromMemory(RetNo);
         Exit;
        end
        Else
        begin
         Result:= False;
         Exit;
        end;
     end //edit=false

     Else //no edit problem
     begin
      Application.CreateForm(TSaveAsFP_2012,SaveAs);
      SaveAs.ShowModal;
      SaveAs.Free;
      Result:= True;
      RemoveReturnFromMemory(RetNo);
      Exit;
     end; //
   end; //wanted to save

   mrNo : Begin Result:= True;RemoveReturnFromMemory(RetNo);Exit;End;
   mrCancel: Begin Result:=False;exit;end;
 else
 end; //case
end;

Procedure RemoveReturnFromMemory(RetNo:integer);
Var i,RNo :Integer;CouplingSins:TStringList;
begin
  if RetList[RetNo].Destroying then
    exit; //recursive call!
{$IFDEF org}
  FreeUpColor(GetRetColor(RetNo));
  DeEnlistReturn(RetNo);
  RemoveRetOverrides(RetNo);
  RemoveRetReviewMarks(RetNo);
  RemoveFormList(RetNo);  //does not seem to do anything
  dec(RetInMem);
{$ELSE}
  DeEnlistReturn(RetNo);
  //RetList.RemoveReturn(RetNo); //also called internally from TRetData destructor
{$ENDIF}
end;

Function CreateNewReturn(DataYear: string = ''; AConvert: Boolean = False):Integer; //20160704 Igor
//Function InitNewReturn: TRetFP_2012;
//Var {RetNo:Integer;}InputString:String;
var
  MyRet: TRetData;
begin
//20170902 Igor>>>
//  //20170502 Igor >>>
//  if RetInMem(AppFP, True) >= AppFP.LimitReturns then
//    Exit(-3);
//  //20170502 Igor <<<
//20170902 Igor<<<
//  If UpperCase(InputBox('FP Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20260505

  Result:= iorReported; // 0;
  If IsDataDirectoryGood(OptRec.Dir_Deflt) = False then exit;

  //20170901 Igor>>>
//  If ExceedsMaxReturnsAllowed then
//  begin
//   ShowMessage('Number of files exceeds maximum allowed '
//   +'('+IntToStr(LimitedVersionReturns-1)+')'+
//   Chr(13)+' in the FP Limited version'
//   +Chr(13)+'Please delete some files');
//   Exit;
//  end;
  //20170901 Igor<<<

  //20160704 Igor >>>
  if (DataYear = '') //new return
     or (DataYear = AppFP.AppYear) //from read return
     or AConvert then
  begin
    If IsDataDirectoryGood(OptRec.Dir_Deflt) = False then exit;
    MyRet := TRetFP_2027.Create(AppFP);
  end
  else
  if StrToInt(DataYear) = StrToInt(AppFP.AppYear)-1 then
  begin
    //last year return
    MyRet := TRetFP_LastYear.Create(AppFP);
  end
  else
    exit;

//  MyRet := TRetFP_2027.Create(AppFP);

  //20160629 Igor <<<


  if MyRet = nil then
    Result := iorCountExceeded //?
  else
    Result := MyRet.RetNo;
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

Function OpenCfg: boolean;
begin

  Result := False;

  //20150921 Igor
  CfgADConnection:= TADConnection.Create(Application);
  CfgTbl := TADTable.Create(Application);
  SetTableName(CfgADConnection, CfgTbl, cfgClientsDbLite_noUse, FormsCfgTableLite, ''); {AppDir;}

  {ShowMessage('Opening CFG');}
  try
     CfgTbl.Open;
     Result := True;

  except
        ShowMessage(cfgADConnection.Params.Values['DataBase'] + ' ' + CfgTbl.TableName + ' can not be opened');
   end;
 end;

Function GetPrvIndex(SPrv: string): Integer;
Var i : integer;
Begin
  Result := 5;  {Ontario}
  For i := 1 to High(PrvShort) do
   begin
    If UpperCase(SPrv) = PrvShort[i] then
    begin Result := i;exit;end;
   end;
End;

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
         {ShowMessage(FRec.FormInstName);}
         if FRec.FormName = NonInstFormName then Inc(Result);
         end;
   end;
end;

 {------------}


function GetFormRlName(FormNo: integer):String;
var
 i: Integer;
 begin
 Result := '';
  for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if (FRec.FormNo = FormNo) then
        Result := FRec.FormRlNm+' ' +Frec.FormInst;
    end;
 end;

{----------------}


procedure InitColorTable;
begin
  ColorList[0] := Rgb(236,237,231); //pastel grey
  ColorList[1] := RGB(254,243,214); {light YELLOW}
  ColorList[2] := Rgb(204,220,227); {pastel blue/CYAN} {RGB(205,225,226);} {RGB(0,255,255);}
  ColorList[3] := MyBeige; {RGB(255,255,0);}
  ColorList[4] := RGB(192,220,192); {pastel green}
  ColorList[5] := RGB(192,192,192); {light grey}
  ColorList[6] := MyLightBlue; {light blue}{RGB(164,200,240);}
  ColorList[7] := RGB(216,239,192); {light green}
  ColorList[8] := RGB(255,255,255); {WHITE}
  ColorList[9] := MyBronze;
  ColorList[10] := RGB(182,203,191);  {LIGHT green}
  ColorList[11] := $00E7CFCF; {mauve} (* $00F1E4E4;*) (* $00C08080; *)
end;

function GetNextAvailColor:Longint;
begin
  Result := NextAvailColor(ColorList);
end;

Function MouseOnBox(x,y,X1,Y1,X2,Y2: integer):boolean;
begin
 Result := (x>X1) and (x<X2) and (y>Y1) and (y<y2);
end;

Function ExtractFormPageNo(FormName: String): integer;
var
i :integer;
begin
 If GetFormMxPg(FormName) <2 then begin Result := 0;exit; end;
 i := 1;
 while (i <= Length(FormName)) and not (FormName[i] ='_') do inc(i);
 Result := MyStrToInt(copy(FormName,i+1,1));
end;



Function GetFormMxPg(FormName: string): integer;
begin
  Result := FList.ByFormName(FormName).FormMxPg;
end;

Function GetNextFormPage(FormName: string): String;
var
 PgNo: Integer;
begin
   Result := FormName;
   PgNo := ExtractFormPageNo(FormName);
   if pgno < GetFormMxPg(FormName) then
      begin
      inc(PgNo);
      result := ExtractFormRootName(FormName)
         +'_'+IntToStr(PgNo)+ ExtractFormInst(FormName);
      end;
end;

Procedure RemoveCoupling(RetNo:Integer);
var
 i : integer;
begin
  for i :=0 to (RetList.Count - 1) do
    begin
      RetRec := RetList.Items[i];
      if (RetRec.RetNo = RetNo) and
       (Ret[RetRec.RetNo].CouplingSw = True) then
          Ret[RetNo].CouplingSw := False;
    end;
end;


Function IsCouplingOn(RetNo:integer): Boolean;
var
 i : integer;
begin
  Result := False;
  for i :=0 to (RetList.Count - 1) do
    begin
      RetRec := RetList.Items[i];
      if (RetRec.RetNo = RetNo) and
       (Ret[RetNo].CouplingSw) then begin Result := True;exit; end;
    end;
end;

end.

