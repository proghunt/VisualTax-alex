unit T3_2026Common;

{=============================================================}
interface
{=============================================================}
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,vtMulti;

{-------------  Function declarations ---------------------}

Procedure LoadOthOpt;
//Procedure InitCfgOptions;
Procedure InitFrmTree;
procedure InitBmps;

Function CreateNewReturn(DataYear: string = ''; AConvert: Boolean = False):Integer;
Function CloseReturn(RetNo : integer; fRemove: boolean): boolean;

Procedure RemoveReturnFromMemory(RetNo:integer);

//T3 still has paged forms!
Function GetNextFormPage(FormName: string): String;
Function GetFormMxPg(FormName: string): integer;

{color routines}
procedure InitColorTable;
function GetNextAvailColor:Longint;

{Configuration options}

{ Forms - independent of RetNo}


function CountMxInst(NonInstFormName: String): Integer;
function GetHighestInst(NonInstFormName: String): Integer;
function GetFormRlName(FormNo: integer):String;  {plain title: ie Sch 1}
{function InitFormsTable: boolean;}

{other}
Function GetPrvIndex(SPrv: string): Integer;

Procedure DrawTab(ACanvas : TCanvas; TabX,TabY:integer; TabColor:Tcolor; TabText: String);
Function GetDescrFromCode(Code: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
Function GetCodeFromDescr(Description: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
Function GetQueryName(QDescr: string): string;
Function ChangeDataDir(NewDataDir: String): Boolean;
Procedure InitSwitches;

{==============================================================}
implementation
{==============================================================}
(*
Implementation of functions and procedures in a DLL
procedure DrawApi; external 'SELECT';
function MinR; external 'T1DLL';
function MaxR; external 'T1DLL';
*)
uses vtCommon,T3_2026,T3_2026TrimStr,T3_2026Declare,T3_2026Common2,
  T3_2026Features,T3_2026Main,T3_2026SaveAs,T3_2026Calc,vtTrimStr,vtShared;

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

Function ChangeDataDir(NewDataDir: String): Boolean;
begin
  Result := True;
  If NewDataDir = AppDir then
  begin
    ShowMessage('You cannot use the Program Directory as Data Directory');
    Result := False;
    exit;
  end;
  If DirectoryExists(NewDataDir) = False then
  begin
    ShowMessage(NewDataDir + CHR(13)+'does not exist');
    Result := False;
    exit;
  end;

  If not FileExists(NewDataDir+'\'+ClientsDBLite) then //20150923 Igor
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

Function CreateNewReturn(DataYear: string = ''; AConvert: Boolean = False):Integer;
Var
  InputString:String;
  MyRet: RetPtr;
begin
//20170902 Igor>>>
//  //20170502 Igor >>>
//  if RetInMem(AppT3_2026, True) >= AppT3_2026.LimitReturns then
//    Exit(-3);
//  //20170502 Igor <<<

// If UpperCase(InputBox('T3 Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20241126 //20241229
  Result:= iorReported; // 0;
  If IsDataDirectoryGood(OptRec.Dir_Deflt) = False then exit;

//  {$IFDEF ReturnsLimit}
//  //20170901 Igor>>>
//  If AppT3_2026.ExceedsMaxReturnsAllowed then
//  begin
////    UserMsg('Number of returns exceeds maximum allowed ('+IntToStr(ReturnsLimit)+')'+
////          Chr(13)+' in the Limited version of the program' +
////          Chr(13)+'Please delete some returns');
//    Exit;
//  end;
//  //20170901 Igor<<<
//  {$ELSE}
//  {$ENDIF}
//20170902 Igor<<<

  //20160629 Igor >>>
  if (DataYear = '') //new return
     or (DataYear = AppT3_2026.AppYear) //from read return
     or AConvert then
  begin
    If IsDataDirectoryGood(OptRec.Dir_Deflt) = False then exit;
    MyRet := TRetT3_2026.Create(AppT3_2026);
  end
  else
  if StrToInt(DataYear) = StrToInt(AppT3_2026.AppYear)-1 then
  begin
    //last year return
    MyRet := TRetT3_LastYear.Create(AppT3_2026);
  end
  else
    exit;

  if MyRet = nil then
    Result := iorCountExceeded
  else
  begin
    Result := MyRet.RetNo
  end;
  //20160629 Igor <<<
end;

Function CloseReturn(RetNo : integer; fRemove: boolean): boolean;
//Function CloseReturn(RetNo : integer): boolean;
var Reply : Word;
begin
(* prevent recursive call!
*)
  Result := True;
  If RetNo = 0 then Exit;
  if not assigned(RetList[RetNo]) then exit; //20160711 Igor

  Result := RetList[RetNo].Destroying;
  if Result then
    exit; //already destroying, recursive call!

 if not RetList[RetNo].Changed then //20160711 Igor
  begin
    Result := True;//RemoveReturnFromMemory(RetNo);Exit;
  end
 else begin
 {Data changed}
  Reply := MessageDlg('Save data?',mtInformation, [mbYes, mbNo, mbCancel], 0);
  Case Reply of
   mrYes:
      begin
       Screen.Cursor := crHourGlass;
       If RetList[RetNo].CalcStatus=False then CalcAll(RetNo);
       UpdateAllDataIndicators(RetNo);

       If RetList[RetNo].MandatoryErrorCount>0 then
       begin
        ShowMessage('Mandatory items must be cleared before saving the return');
        Result := False;
        exit;
       end;

       Application.CreateForm(TSaveAsT3_2026,SaveAs);
       SaveAs.ShowModal;
       SaveAs.Free;

       //RemoveReturnFromMemory(RetNo);
       Result := True;
       //Exit;
      end;
    mrNo : Result:= True; //RemoveReturnFromMemory(RetNo);Exit;End;
    mrCancel: Begin Result:=False;exit;end;
    else //case
    end;
  end;

//check for remove, only here
  if Result and fRemove then
    RemoveReturnFromMemory(RetNo);
end;

Procedure RemoveReturnFromMemory(RetNo:integer);
begin
  DeEnlistReturn(RetNo);
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

//20231227
Function GetPrvIndex(SPrv: string): Integer;
Var
  i: Integer;
Begin
  Result := 6; { Ontario }
  For i := 1 to High(PrvShort) do
  begin
    If UpperCase(SPrv) = PrvShort[i] then
    begin
      Result := i;
      exit;
    end;
  end;
  If UpperCase(SPrv) = 'NU' then Result := 14;
End;

(*
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
*)



procedure InitBmps;
{var LogoBmp:Tbitmap;}
begin
  (*
  LogoBmp := TBitmap.Create;
  LogoBmp.LoadFromFile(AppDir+'\'+'MyLogo.BMP');
  *)
end;

Procedure InitSwitches;
begin
  ToolBarSw := True;
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
           InstNo := StrToInt(MidStr(FRec.FormInst,2,3));
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


function GetFormRlName(FormNo: integer):String;
begin
  FRec := FList.ByFormNoDummy(FormNo);
  Result := FRec.FormRlNm+' ' +Frec.FormInst;
end;

procedure InitColorTable;
begin
  ColorList[0] := Rgb(236,237,231); //pastel grey
  ColorList[1] := Rgb(204,220,227);  {pastel blue/CYAN}
  ColorList[2] := MyBeige; {RGB(255,255,0);}
  ColorList[3] := MyYellow;
  ColorList[4] := RGB(192,220,192);  {pastel green}
  ColorList[5] := RGB(192,192,192); {light grey}
  ColorList[6] := MyLightBlue; {RGB(164,200,240);}
  ColorList[7] := RGB(216,239,192); {light green}
  ColorList[8] := RGB(255,255,255); {WHITE}
  ColorList[9] := MyBronze;
  ColorList[10] := RGB(182,203,191); {LIGHT green}
  ColorList[11] := $00E7CFCF; {mauve}
end;
function GetNextAvailColor:Longint;
begin
  Result := NextAvailColor(ColorList);
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

Procedure LoadOthOpt;
Var TempList:TStringList;
begin

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

Procedure InitFrmTree;
Var i:Integer;
   FrmTreeDescr  : TStringList;
   //FrmTreeForms  : TStringList;
begin
  FrmTreeDescr :=TStringList.Create;
//  FrmTreeForms :=TStringList.Create; //20170628 Igor
  FrmTreeDescr.LoadFromFile(AppDir+'\'+'Treeview.d');
  For i:=0 to FrmTreeDescr.Count-1 do
  begin
    FrmTreeForms.Add(MidStr(FrmTreeDescr[i],62,15));
    FrmTreeDescr[i] := LeftStr(FrmTreeDescr[i],61);
  end;
   FrmTreeDescr.SaveToFile(AppDir+'\'+'TreeView2.d');
  FrmTreeDescr.Free;
end;

initialization
  FrmTreeForms := TStringList.Create;   //20170512 Igor

finalization
  FreeAndNil(FrmTreeForms); //20170512 Igor

end. {end of unit}

