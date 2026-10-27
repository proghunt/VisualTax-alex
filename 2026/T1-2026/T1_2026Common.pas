unit T1_2026Common;
//unchanged 07-24

{=============================================================}
interface
{=============================================================}
uses SysUtils,{$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON},WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB;

{-------------  Function declarations ---------------------}
Procedure StoreRetColorInStatus(RetNo:Integer);

{Return}
Procedure RemoveReturnFromMemory(RetNo:integer);
Procedure RemoveCoupling(RetNo:Integer);
Function CalcMarStatus(RetNo: integer): Integer;
//Function CloseReturn(RetNo : integer): boolean;
Function CloseReturn(RetNo : integer; fRemove: boolean = True): boolean;
Function IsRetNoListed(RetNo: integer): boolean;
Procedure InitRichEditStorage(RetNo:Integer);
Function GetRetName(RetNo:integer): string;

Function GetFieldOverride(RetNo: Integer; FormNo: Integer; FieldId:integer): string;
procedure InitColorTable;
function GetRetColor(RetNo: Integer): Longint;

{Forms -depend on RetNo}

{ Forms - independent of RetNo}

function CountMxInst(NonInstFormName: String): Integer;
function GetHighestInst(NonInstFormName: String): Integer;
function GetFormRlName(FormNo: integer):String;  {plain title: ie Sch 1}
Function GetFormMxPg(FormName: string): integer;
Function ExtractFormPageNo(FormName: String): integer;
Function StripInstNo(FormName: String): string;

{other}
Procedure DrawTab(ACanvas : TCanvas; TabX,TabY:integer; TabColor:Tcolor; TabText: String);
Function GetDescrFromCode(Code: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
Function GetCodeFromDescr(Description: String; Var codes : Array of string;
   Var Descriptions :Array of string):String;
Function ChangeDataDir(NewDataDir: String): Boolean;

procedure RequestSignature(ARetNo:Integer); //20210408 Igor

{==============================================================}
implementation
{==============================================================}

uses vtMulti,vtCommon,T1_2026,T1_2026TrimStr,T1_2026Declare,T1_2026Common2,
  T1_2026T1Rtns,T1_2026Features,T1_2026Main,T1_2026ChildWinNew,
  T1_2026OptionsFrm,T1_2026ImportConfig,T1_2026SaveAs,vtTrimStr,vtShared,
  vtVirtualTaxOffice, vtChild; //20210408 Igor

procedure RequestSignature(ARetNo:Integer); //20210408 Igor //20210409 Igor
var FTaxPayerEmail: string;
    FTaxPayerCyberId: string;
begin
  If ARetNo = 0 then
  begin
    ShowMessage('Open return first');
    exit;
  end;
  FTaxPayerEmail := FetchElm(ARetNo,'INFO', 140);
  if FTaxPayerEmail.IsEmpty then
  begin
    ShowMessage('Email is not specified. Please, enter email before signature request');
    GetChild(ARetNo).BringExistingTabSheetToFront('INFO', GetFormNo('INFO'), 140);
  end;
  FTaxPayerCyberId := VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(FTaxPayerEmail);
  if FTaxPayerCyberId.IsEmpty then Exit;
  //20220201 Igor >>>
  if not GetSignatureFilePath(GetLastName(ARetNo),GetFirstName(ARetNo)).IsEmpty then
    if MessageDlg('Signature is already available in the Client Docs. Do you want to request another one ?', mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit; //20210410 Igor
  VirtualTaxOfficeInfo.RequestSignature(FTaxPayerEmail);
  //20220201 Igor <<<
end;

Function CalcMarStatus(RetNo:Integer): Integer;
Var i : integer;
Begin
 Result := 6; {single}
 For i := 11 to 13 do
  If FetchElm(RetNo,'INFO',i) > '' then
      result := i - 10;
 For i := 16 to 18 do
  If FetchElm(RetNo,'INFO',i) > '' then
      result := i -15 + 3;
end;



Function GetRetName(RetNo:integer): string;
begin
 Result := Rtrim(FetchElm(RetNo,'INFO',5))+', '
   +Rtrim(FetchElm(RetNo,'INFO',2));
 If Result =',' then result := '(Un-named)';
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

 If not FileExists(NewDataDir+'\'+ClientsDbLite) then
 begin
  ShowMessage(NewDataDir + CHR(13)
    +'Directory does not contain a Client Data Base');     //201602267 Igor
  Result := False;
  exit;
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


Function GetFieldOverride(RetNo: Integer; FormNo: Integer; FieldId:integer): string;
begin
  Result := GetOvrValue(RetNo, FormNo, FieldId);
end;


procedure RemoveReturnFromMemory(RetNo: integer);
Var i,RNo :Integer;CouplingSins:TStringList;ClosedLastYearRno:Boolean; //march  17 2008
begin
  //If RetNo<1 then Exit;
  ClosedLastYearRno := False;
  if not assigned(RetList[RetNo]) then exit; //20160711 Igor

  //if last year's return remove the link from this year's return. HOW?
  If ShowUnconvertedLastYear(RetNo) then
  begin
   RemoveLinkToLastYearRetNo(RetNo);
   ClosedLastYearRNo:=True;  //march  17 2008
  end;
  Ret[RetNo].CouplingSw := False;  //??
  //march  17 2008
  //other members
  If ClosedLastYearRno = false then
  Begin
   CouplingSins:=TStringList.Create;
   GetCouplingSins(RetNo,CouplingSins);
   For i:=0 to CouplingSins.Count-1 do
   begin
    RNo:=GetRetNoFromSin(CouplingSins[i]);
    //GetCouplingSins(RNo,CouplingSins);
    If RNo>0 then Ret[RNo].CouplingSw := False;
   end;
   CouplingSins.free;
  end;
//finally destroy the return
  DeEnlistReturn(RetNo); //dec(RetInMem);
end;

Function CloseReturn(RetNo : integer; fRemove: boolean): boolean;
var sinno :string;Reply : Word;SpRetNo:Integer;
begin
(* prevent recursive call!
*)
  Result := True;
  If RetNo < 1 then Exit;
  Result := not assigned(RetList[RetNo]) or RetList[RetNo].Destroying;
  if Result then
    exit; //already destroying, recursive call!

 if (RetList[RetNo].Changed = False) or //20160711 Igor
    (ShowUnconvertedLastYear(RetNo)) or
    RetList[RetNo].isAppendix then //20160711 Igor
 begin
   Result := True;  //RemoveReturnFromMemory(RetNo);  Exit;
 end
 else begin
   {Data changed}
   Reply := MessageDlg('Return will be closed'
            +Chr(13)+'Save data for '+GetFirstName(RetNo)+
            ', '+GetLastName(RetNo)+'?',
            mtInformation, [mbYes, mbNo, mbCancel], 0);
   Case Reply of
   mrYes:
     begin
       If MainFormT1.EditBeforeSave(RetNo) = false then //exit;
       begin
          if MessageDlg('Mandatory data are missing. Close without saving?',
             mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
           Result:= True; //RemoveReturnFromMemory(RetNo); Exit;
          end
          Else
          begin
           Result:= False;
           Exit;
          end;
       end //edit=false

       Else //no edit problem
       begin
        T4Sum(RetNo,'T4SUM',GetFormno('T4SUM'));
          ExecuteForm(TSaveAsT1_2026);
        Result:= True;  //RemoveReturnFromMemory(RetNo);  Exit;
       end; //
     end; //wanted to save

   mrNo : Result:= True;  //RemoveReturnFromMemory(RetNo);Exit;End;
   mrCancel: Result:=False; //exit;end;
   //else
   end; //case
 end;
 if Result then
  RetList[RetNo].Changed := False; //prevent second question
//check for remove, only here
  if Result and fRemove then
    RemoveReturnFromMemory(RetNo);
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

{------------}
Procedure InitRichEditStorage(RetNo:Integer);
//strings will hold ponters to richdit fields
Var i:Integer;
begin
  // for i := 1 to FormsLimit do  Ret[RetNo].RichFrm[i] := TstringList.Create;
 {
   for i :=0 to (FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    If GetRichElms(Frec.FormName)>'' then
    begin

    end;
   end;
}
end;

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


procedure InitColorTable;
var
  Colors: TColorTable absolute ColorList;
begin
  Colors[0] := RGB(221,247,244);  {light cyan gp}  //0
  Colors[1] := Rgb(204,220,227); {pastel blue}   //1
  Colors[2] := MyBeige; {RGB(255,255,0);}  {mybeige}        //2
  Colors[3] := RGB(224,223,227);  {light btnface}    //8
  Colors[4] := RGB(192,192,192); {grey}      //4
  Colors[5] := RGB(192,220,192);  {pastel green}       //5
  Colors[6] := RGB(128,255,255);  {cyan}                //6
  Colors[7] := $00E7CFCF; (* $00F1E4E4;*) (* $00C08080; *)    {mauve}  //7
  Colors[8] := RGB(255,236,236);  {Pink}  //8
  Colors[9] := MyBronze;  {mybronge}        //9
  Colors[10] := MyYellow;  {light YELLOW}    //10
  Colors[11] := RGB(255,255,255);  {WHITE}           //11
end;

Procedure StoreRetColorInStatus(RetNo:Integer);
Var i,FNo:Integer;
begin
  FNo:=GetFormNo('STATUS');
  StoreElm(RetNo,FNo,34,IntToStr(Ret[RetNo].RetColor));
end;

//function GetRetColor(RetNo: Integer; fInit: boolean): Longint;
function GetRetColor(RetNo: Integer): Longint;
var
i,j: Integer; Clr:LongInt;
begin
(* init only once (fInit=True)
*)
 result := RGB(255,255,255);  {if RetNo not found}
 If RetNo=0 then exit;
 If Ret[RetNo].IsLastYearReturn then Exit; //20160314 Igor
  Result := RetList[RetNo].RetColor;
  //assume explicit init!
end;



Function ExtractFormPageNo(FormName: String): integer;
var
i :integer;
begin
 RESULT:=0;  //20101218
 (*
 If GetFormMxPg(FormName) <2 then begin Result := 0;exit; end;
 i := 1;
 while (i <= Length(FormName)) and not (FormName[i] ='_') do inc(i);
 Result := MyStrToInt(copy(FormName,i+1,1));
 *)
end;


Function StripInstNo(FormName: String): string;
var   {T4#1  yields T4}
i :integer;
begin
 i := 1;
 while (i <= Length(FormName)) and not (FormName[i] ='#') do inc(i);
 Result := copy(FormName,1,i-1);
end;


Function GetFormMxPg(FormName: string): integer;
var
i: Integer;
begin
   Result := 0;
  FRec := FList.ByFormName(FormName);
  if assigned(FRec) then
    Result := FRec.FormMxPg;
end;

Function IsRetNoListed(RetNo: integer): boolean;
begin
  Result := assigned(RetList[RetNo]);
end;


Procedure RemoveCoupling(RetNo:Integer);
var
 i : integer;
begin
   Ret[RetNo].CouplingSw := False;
end;

end.

