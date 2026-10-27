unit T1_2026RollCtxT1;
//updated 07-28

(*
Comments:
Input RollCtxT1.d  format: 005,002S=SIN^PAGE^1
output in TempDir  Format: above+ ^+value
*)

interface

uses Windows,SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,ExtCtrls,DB,StdCtrls,Grids,DBGrids,DBCtrls,Menus, StrUtils, //20260803 Alex
  Buttons,FileCtrl,ShellApi,Mask,ComCtrls,VclTee.TeeProcs,VclTee.TeEngine,VclTee.Chart,ComObj,
  olectnrs,OleServer,vtEditBox,vtCtxReader;

Const
 TempFlExtension  = 'EXP';
 FieldsFlName     = 'RollCtxT1.d';
 TempDirName      = 'TempDir';

type
  TRollCtxT1_2026 = class(TForm)
    OpenDialog1: TOpenDialog;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    OpenBtn: TBitBtn;
    FileListBox1: TFileListBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    LinkToOptionsLbl: TLabel;
    Label5: TLabel;
    ReplaceOptionBox: TRadioGroup;
    CanTaxExtensionBox: TComboBox;
    FromDirBox: TEdit;
    SelectDirBtn1: TBitBtn;
    ToDirBox: TEdit;
    SelectDirBtn2: TBitBtn;
    Label6: TLabel;
    SaveOrOpenOptionBox: TRadioGroup;
    Chart1: TChart;
    Label7: TLabel;

    Procedure SpCaptureCCALastYear(RetNo:Integer);
    Function getCantaxFieldInfo(formField:String;CanTaxInfoList:TStringList):string;
    Function getCantaxFieldInfo1(formField:String;CanTaxInfo:AnsiString):string;

//20150727    function LoadStringFromFile(const filename: string): AnsiString;

    //Function GetNumberOfTableRows(CanTaxFrmNm,CanTaxTableNm:String):Integer;
    Procedure CheckDateFormat;
    Function GetVisualExt(VtYearEnd:String):String;
    Function GetCanTaxFldName(S:String;ClientOrSpouse:String):String;
    function HexToStr(AStr: string): string;
    Function TransChar(AChar: Char): Integer;
    Function ConvertOne(CanTaxFlName:String):Integer;
    Function  ConvertProvOfRes(Valu:String):String;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ImportAllBtnClick(Sender: TObject);
    procedure SaveIt(FlName:String);
    procedure StoreData(ConvList:TStringList);
    Function  ImportOne(ConvertedValues:TStringlist):Integer;
    procedure HelpBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure SelectDirBtn2Click(Sender: TObject);
    procedure ShowFiles;
    procedure FromDirBoxExit(Sender: TObject);
    procedure FromDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure CanTaxExtensionBoxChange(Sender: TObject);

    Procedure FixBusPercent(RetNo:Integer);
    Procedure FixRentalPercent(RetNo:Integer);
    Procedure FixFishingPercent(RetNo:Integer);
    Procedure FixFarmingPercent(RetNo:Integer);

    Function FindAStringInCanTax(CanTaxFlName:String):Integer;
    procedure FindBtnClick(Sender: TObject);
    Function  ShowLOVInForm(CanTaxFlName:String):Integer;
    procedure LovBtnClick(Sender: TObject);
    Function  FixMarStatus(Valu:String):Integer;

    Procedure FixAfterImport(RetNo:Integer);
    Procedure FixBusStatements(RetNo:Integer);
    Function  GetConvertedFlName(CanTaxFlName:String):String;
   // procedure BitBtn1Click(Sender: TObject);
    procedure LinkToOptionsLblClick(Sender: TObject);
    procedure FileListBox1Change(Sender: TObject);
    procedure FileListBox1KeyPress(Sender: TObject; var Key: Char);
    Function  FixValu(valu,valuType:String):String;
  private
    Tables: TCtxItem; //the loaded database
    Selector: RIndex; //the current selector

    { Private declarations }
  public
    RetNo:Integer;
    CtxAppName:String;
    TxtFailed:Boolean;  //if the text file with c/f created or not

    ClientOrSpouse:String;
    //UnclaimedRrspCF:Real;

    ButtonClicked:String;
    CanTaxFlName,ConvertedFlName,VisualFlName: String;
    CanTaxExtension: String;
    CanTaxYearEnd,VTYearEnd:string; //[10];
    Cnt   : integer;
    InitialRowCount :integer;

    TmpList:TStringList;
    StmNo:Integer;
    TempDir:String;
  end;

var
  RollCtx: TRollCtxT1_2026;

implementation

{$R *.DFM}

uses vtMulti,vtCommon,vtMain,vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026Common,T1_2026Common2,T1_2026ChildWinNEW,T1_2026Calc,T1_2026OptionsFrm,
  T1_2026T1W_TLB,T1_2026T1Rtns,T1_2026Main,vtTrimStr,vtShared;

procedure TRollCtxT1_2026.FormCreate(Sender: TObject);
var i:Integer;
begin
 ButtonClicked:='';
 ToDirBox.Text:=OptRec.Dir_Cur;

 FromDirBox.Text:= OptRec.Dir_LastYr;
 //FromDirBox.Text:= 'C:\Documents and Settings\User\My Documents\My Received Files\DoDi';

 CanTaxExtensionBox.items.add('.P24'); //20260803 Alex '.P23');   //20250217 //20211225
 CanTaxExtensionBox.items.add('.*');
 //CanTaxExtensionBox.items.add('*');
 CanTaxExtensionBox.Text:=CanTaxExtensionBox.items[0];

 CanTaxExtension:=CanTaxExtensionBox.Text;

 TempDir:=AppDir+'\'+ TempDirName;
 If DirectoryExists(TempDir) then
 else
  MkDir(TempDir);

 ShowFiles;
end;

procedure TRollCtxT1_2026.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TRollCtxT1_2026.ImportAllBtnClick(Sender: TObject);
Var i,k,EndPos:Integer;Ext:String;
begin
 If RetInMem>0 then
 begin
  ShowMessage('Please close all returns first');
  exit;
 end;

 If FileListBox1.Items.Count<=0 then
 begin
  ShowMessage('No files are available for inport');
  exit;
 end;

 if MessageDlg('Roll-over ' + 'howmanybox.text' + ' starting from selected return? Are you sure?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;

 ButtonClicked:='IMPORT ALL';
 Screen.Cursor:=crHourGlass;

 OpenBtn.Enabled:=False;

 K:= filelistbox1.itemindex;
 Cnt:=0;

 CanTaxFile1:= {T1W_tlb.}CoCanTaxT1App.Create;
 CanTaxData1:= {T1W_tlb.}CoCanTaxT1Data.Create;
 CanTaxAppCreated := True;
 //doBatchRoll(k, strtoint(HowManyBox.text));

 OpenBtn.Enabled:=True;

 Screen.Cursor:=crDefault;
 ShowMessage('Total returns Rolled Over = '+IntToStr(cnt)
    +Chr(13)+'You can now Exit and use Open from the VisualTax Main Menu');
 ButtonClicked:='';

 //Close active return
 //   AppActivate( pchar('' + CtxAppName) );
 //  SendKeys('%{F3}',True);
end;

Function TRollCtxT1_2026.GetVisualExt(VtYearEnd:String):String;
Var i:Integer;TwoDigitYE:string; //[2];
begin
 TwoDigitYE:= MidStr(VTYearEnd,3,2);
 Result := FillLeftZeros(AllTrim(TwoDigitYE),2);
end;


procedure TRollCtxT1_2026.SaveIt(FlName:String);
begin
 If not SaveReturn(RetNo,ToDirBox.Text,FlName,True,True) =0 then
   ShowMessage('Save of data failed')
 else
  Inc(Cnt);
end;

procedure TRollCtxT1_2026.ShowFiles;
begin
  //20260803 Alex >>>
  if DirectoryExists(FromDirBox.Text) then
  begin
    FileListBox1.Directory:= FromDirBox.Text;
    FileListBox1.Mask:= '*' + CanTaxExtensionBox.text;
    FileListBox1.ItemIndex:= 0;
    //FilesGroupBox.Caption:= 'FILES: '+IntTostr(FileListBox1.Items.count);
  end;
  //20260803 Alex <<<
end;

Function TRollCtxT1_2026.fixValu(valu,valuType:String):String;
begin

 Result:=Valu;

 if valuType = 'SIN' then
 begin
  Result:= AllTrim(RemoveChar(Valu,' ')); //sin
  Result:= AllTrim(RemoveChar(Result,'-')); //sin
 end;

 if valuType = 'UPPERCASE' then
  Result:=Uppercase(valu);

 if valuType = 'PROVINCE' then
  Result:=ConvertProvOfRes(Valu);

 if valuType = 'YESNO' then
  if Valu='0' then Result:='N' else Result:='Y';

 if valuType = 'X' then
  if Valu='1' then Result:='X' else Result:='';  //elections

 if valuType = 'DATE' then
  Result:=CanTaxJulianDaysToYYYYMMDD(Valu);

 if valuType = 'AREA' then
 begin
  valu:=RemoveChar(valu,' ');
  valu:=RemoveChar(valu,'-');
  If Length(valu) >7 then
   Result:= LeftStr(valu,3)
  else
   Result:= '';
 end;

 if valuType = 'PHONE' then
 begin
  Result:=RemoveChar(valu,' ');
  Result:=RemoveChar(Result,'-');
  If Length(valu) >7 then
   Result:= MidStr(Result,4,10);

 end;


 if valuType = 'INCYEAR' then
 begin
  //Result:=IncrYear(Result); //doesnt work?
  Result:=IntToStr(MyStrToInt(Result)+365);
  Result:=CanTaxJulianDaysToYYYYMMDD(result);
 end;


 if valuType = 'RELATIONSHIP' then
 begin
  Case strtoint(valu) of
    1: Result:='Child';
    2: Result:='Son';
    3: Result:='Daughter';
    4: Result:='Parent';
    5: Result:='GrandParent';
    6: Result:='GrandChild';
    7: Result:='Brother';
    8: Result:='Sister';
    9: Result:='Niece';
    10:Result:='Nephew';
    11:Result:='Aunt';
    12:Result:='Uncle';
  end;
 end;

 if valuType = 'NAICS' then
 begin
    if valu = '0' then
        Result :=''
 end;

end;


procedure TRollCtxT1_2026.StoreData(ConvList:TStringList);
Var i,j,FNo,Elm,AssetFNo:Integer;FName,valuType,Valu:String;
WList:TStringList;
ZString  : Array[0..80] of Char;
PZString : Pchar;
begin
Try
 WList:=TStringList.Create;

 For i:=0 to ConvList.Count-1 do
 begin
  If AllTrim(ConvList[i])>'' then
  begin
    valu:='';
    FNo:=0;
    Try
     ParseWords(ConvList[i]+'^','^',WList);   {added a last delim in case no value}

     valuType := AllTrim(WList[1]);
     FName :=AllTrim(WList[2]);
     Elm   :=MyStrToInt(AllTrim(Wlist[3]));

     // IF valuType = 'TEST' then showmessage(FName + ' ' + Wlist[3]);
     //IF pos('Dep#', ConvList[i]) > 0 then showmessage(ConvList[i]);
     //IF Elm = 4 then showmessage('stop elm:' + inttostr(Elm));
     //IF Elm = 16 then showmessage('stop elm:' + inttostr(Elm));

     If WList.Count>4 then
     begin
       Valu  :=AllTrim(WList[4]);
       Valu  := fixValu(Valu,valuType)
     end
     else
       Valu :='';

    except
       on E: Exception do MessageDlg(ConvList[i]+' '+
                   E.Message, mtError, [mbok], 0);
    end;

    FNo:= GetFormNo(FName);
    If (FNo>0) then
    begin
     If (Ret[RetNo].Frm[Fno].Count = 0) then InitFormData(RetNo,FNo);
    end;

    If (FNo < 1) and (IsFormMultiInst(FName)) then
    begin
      Fno := AddPageInstance(RetNo, ExtractNonInstFormName(FName),ExtractFormInst(FName));
      AddOtherPagesInstance(RetNo,ExtractNonInstFormName(FName),ExtractFormInst(FName));
      //Fno := GetFormNo(FName); {get it again}
      InitFormData(RetNo,FNo); //June 2002
    end;

    Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=False;

    If (FNo>0) and (Valu >'') then
    begin
     If (FName='INFO') and (Elm=11) then
       begin Elm:=FixMarStatus(Valu);Valu:='X';end;

     Try
      StoreElm(RetNo,FNo,Elm,Valu);
      If LeftStr(FName,5) <> 'YRSUM' then
      begin
       If LeftStr(Fname,5)='T2125' then FixBusPercent(RetNo);
       If LeftStr(Fname,4)='T776'  then FixRentalPercent(RetNo);
       If LeftStr(Fname,5)='T2121' then FixFishingPercent(RetNo);
       If LeftStr(Fname,5)='T2042' then FixFarmingPercent(RetNo);
      // Calc(RetNo,FName);
      end;
     except
      on E: Exception do MessageDlg(ConvList[i]+' '+
                    E.Message, mtError, [mbok], 0);
     end;
     If Valu >'' then Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=True;
   end; {valu > ''}
  end; {alltrim of temp rec}
 end; {i}
except
      on E: Exception do MessageDlg(ConvList[i]+' '+
                    E.Message, mtError, [mbok], 0);
end; {Try}

WList.free;

end;

procedure TRollCtxT1_2026.HelpBtnClick(Sender: TObject);
begin
  //20190220
  ShellExecute(0, 'open', PWideChar('http://www.visualtax.com/Vt2018HELP/T1Help/Website/T1Help.html'), nil, nil, SW_SHOW);
  //ShowHelp('www.visualtax.com/Vt2018HELP/T1Help/Website/'+'T1Help.html?Conversion_from_CanTax.html');  //wrong parameters   //20181221
  //ShowHelp(AppT1_2026.ModuleHelpUpdFile,'Converting_from_CanTax', True); //20160801 Igor
  {
  Application.HelpFile := AppDir+'\'+'T1UPDHLP.HLP';
  Application.HelpJump('Converting_from_CanTax');
  }
end;

procedure TRollCtxT1_2026.OpenBtnClick(Sender: TObject);
Var FNo,j,i:Integer;SelectedCount:Integer;
begin
 If Not DirectoryExists(FromDirBox.Text) then
 begin
  ShowMessage('From Directory '+FromDirBox.Text+' does not exist');
  exit;
 end;
 If FileListBox1.ItemIndex<0 then
 begin
  ShowMessage('You must select a file first');
  exit;
 end;


// CheckDateFormat;

 FileListBox1.enabled := False;

 ButtonClicked:='OPEN';

 SelectedCount:=0;
 for i := 0 to (FileListBox1.Items.Count - 1) do
 begin
  if FileListBox1.Selected[i] then Inc(selectedCount,1);
 end;

 If SelectedCount>1 then  //20171215   //to be re-estabkished
 begin
  ShowMessage('You can only Rollover one by one, in this Preliminary version');
  exit;
 end;

 If (Selectedcount>3) and (SaveOrOpenOptionBox.ItemIndex=0)
 then
 begin
  ShowMessage('You must set the option Save Returns Directly to file');
  exit;
 end;

 Screen.Cursor:= crHourGlass;

 for i := 0 to (FileListBox1.Items.Count - 1) do
 begin
  if FileListBox1.Selected[i] then
  begin
   CanTaxFlName:=FromDirBox.Text+'\'+FileListBox1.Items[i];
   If ConvertOne(CanTaxFlName) = 0 then
   begin
     Screen.Cursor:= crHourGlass;
   end;
  end; //if selected
 end; //for FileListBox1.Items.Count
 If SaveOrOpenOptionBox.ItemIndex=1 then
   ShowMessage('Done.'+Chr(13)+'Now you can open any of the rolled-over returns');

 Screen.Cursor:= crDefault;
 Close;
 ButtonClicked:='';
 LockWindowUpdate(0);
end;

procedure TRollCtxT1_2026.SelectDirBtn1Click(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    FromDirBox.Text := DirSelected;
 ShowFiles;
end;

procedure TRollCtxT1_2026.SelectDirBtn2Click(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    ToDirBox.Text:= DirSelected;
end;

Function TRollCtxT1_2026.ConvertProvOfRes(Valu:String):String;
Var n:Integer;
begin
 Result:='';
 n:=MyStrToInt(AllTrim(Valu));
 Case n of
 1:  Result:='Newfoundland';
 2:  Result:='Prince Edward Island';
 3:  Result:='Nova Scotia';
 4:  Result:= 'New Brunswick';
 5:  Result:='Quebec';
 6:  Result:='Ontario';
 7:  Result:='Manitoba';
 8:  Result:='Saskatchewan';
 9:  Result:='Alberta';
 10: Result:='British Columbia';
 11: Result:='Yukon Territory';
 12: Result:='Northwest Territories';
 13: Result:='Nunavut';
 14: Result:='Multiple';
 15: Result:='N.S. Offshore';
 16: Result:='Outside Canada';
 17: Result:='NFLD Offshore';
 18: Result:='Nunavut';
 end;
 Result:=UpperCase(Result);
end;



procedure TRollCtxT1_2026.FromDirBoxExit(Sender: TObject);
begin
ShowFiles;
end;

procedure TRollCtxT1_2026.FromDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If Key=#13 then ShowFiles;
end;

Function TRollCtxT1_2026.GetCanTaxFldName(S:String;ClientOrSpouse:String):String;
Var WList:TStringList;
begin
 If s='' then begin Result:='';exit;end;
 If LeftStr(s,2) ='//' then begin result:='';Exit;end;
 WList:=TstringList.Create;
 ParseWords(S,'=',WList);
 Result:=Wlist[0];
 WList.Free;
end;


(*
Function TRollCtxT1.GetNumberOfTableRows(CanTaxFrmNm,CanTaxTableNm:String):Integer;
var i,FCount:Integer;
begin
  FCount:=CanTaxClient1.FormCount[CanTaxFrmNm];
  Result:=0;
  For i:=0 to FCount-1 do
  begin
   Result:=Result+CanTaxClient1.TableItemCount[CanTaxTableNm,i];
  end;
end;
*)

Function TRollCtxT1_2026.getCantaxFieldInfo(formField:String;CanTaxInfoList:TStringList):string;
var
 i, StartPos,EndPos,EndPos2,EndPos3:Integer;
 temp:String;
begin
 result:='';
 for i:=0 to CanTaxInfoList.count -1 do
 begin
   if Pos(uppercase(formField), uppercase(CanTaxInfoList[i])) > 0 then
   begin
   temp := CanTaxInfoList[i];
   StartPos := pos(formField, temp) + Length(formField) + 1;
   temp := alltrim(midstr(temp, StartPos, Length(temp)));

   EndPos :=  Pos('     ',temp);
   EndPos2 := Pos('FC'   ,temp);
   EndPos3 := Pos('|'    ,temp);
   if (EndPos3 > 0) then
    temp := alltrim(LeftStr(temp, EndPos3))
   else if EndPos > 0 then
    temp := alltrim(LeftStr(temp, EndPos))
   else if EndPos2 > 0 then
    temp := alltrim(LeftStr(temp, EndPos2));

   result := temp;
   exit;
  end;
 end;
end;

Function TRollCtxT1_2026.getCantaxFieldInfo1(formField:String;CanTaxInfo:AnsiString):string;
var
 i, StartPos,EndPos,EndPos2,EndPos3,tempfrontPos:Integer;
 temp,tempFront:AnsiString;
begin
   result:='';
   FormField:=UpperCase(FormField);
   StartPos:=pos(formField, CanTaxInfo);
   if StartPos > 0 then
   begin
    StartPos := StartPos + Length(formField) + 1;
    tempFront := midStr(CanTaxInfo, StartPos, Length(CanTaxInfo));
    EndPos :=  Pos('|',tempFront) -1;
    temp := alltrim(LeftStr(tempFront, EndPos));
    if temp = '' then
    begin
     tempfrontPos:= Pos('|(',tempfront);
     if (tempfrontPos > 0) and (tempfrontPos < 3 ) then
     begin
      StartPos := tempfrontPos + 2;
      tempFront := midStr(tempfront, StartPos, Length(tempFront));
      EndPos :=  Pos('|)',tempFront) - 1;
      temp := alltrim(LeftStr(tempFront, EndPos));
     end;
    end;
   //temp := ConvertToProper(temp);
   result := temp;
   exit;
  end;
end;
//20150727
{
function TRollCtxT1_2026.LoadStringFromFile(const filename: string): String;
var
  fs: TFilestream;
begin
  fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Result, fs.Size);
    fs.ReadBuffer(Result[1], Length(Result));
  finally
    fs.free
  end;
end; { LoadStringFromFile }

function TRollCtxT1_2026.HexToStr(AStr: string): string;
var
  I : Integer;
  CharValue: Word;
begin
   Result := '';
  For I := 1 to Trunc(Length(Astr)/2) do
  begin
   Result := Result + ' ';
   CharValue := TransChar(AStr[2*I-1])*16 + TransChar(AStr[2*I]);
   Result[I] := Char(CharValue);
  end;
 end;

Function TRollCtxT1_2026.TransChar(AChar: Char): Integer;
begin
  if AChar in ['0'..'9'] then
  Result := Ord(AChar) - Ord('0')
  else
   Result := 10 + Ord(AChar) - Ord('A');
end;

Function TRollCtxT1_2026.ConvertOne(CanTaxFlName:String):Integer;
var
i,c,n,CantaxFormNumber,CloneCount, l: integer; //20260803 Alex
okay:boolean;
CantaxFieldCode,tempCantaxFieldCode,VisualTaxFieldCode:String;
ClientInFile,CanTaxInfoList,ConvertedValuesList:TStringList;
  lRecPtr: PCtxRec; //20260803 Alex
begin
CanTaxInfoList := TStringList.Create;
ConvertedValuesList := TStringList.Create;

//CanTaxInfoList.LoadFromFile(AppDir+'\rollctxt1.d');
CanTaxInfoList.LoadFromFile(AppDir+'\'+FieldsFlName);

try
  //load the file
  Tables.Free;
  Tables := LoadCtx(CanTaxFlName);
  ClientInFile := TStringList.Create;
  Tables.PutClients(ClientInFile);
except
  Showmessage('error loading file');
  result := -1;
  //exit;
end;

For c := 0 to ClientInFile.count - 1 do
begin
 Try
  ConvertedValuesList.clear;
  for i := 0 to CanTaxInfoList.Count-1 do
  begin
    if (Copy(CanTaxInfoList[i], 0, 2) <> '//') and (CanTaxInfoList[i] > '') then
    begin
      CantaxFieldCode := Copy(CanTaxInfoList[i], 0, Pos('=',CanTaxInfoList[i])-1);

      //if i > 101 then showmessage(inttostr(i));

      CantaxFormNumber := strtoint(Copy(CantaxFieldCode, 3, 3));

      CloneCount := Tables.CloneCount(c, CantaxFormNumber);


//      if (CantaxFormNumber = 35) or (CantaxFormNumber = 36) then
//       showmessage(inttostr(CantaxFormNumber) + ' CloneCount:' + inttostr(CloneCount));

      //for n := 0 to CloneCount-1 do
      //begin
      n:=1;
      repeat //check first instance and repeat if has clones
        tempCantaxFieldCode := CantaxFieldCode;
        if n > 1 then
        begin
          //20260803 Alex >>>
          if (CantaxFormNumber = 148) then
          begin
            if n = 2 then l:= 4;
            if n = 3 then l:= 7;
            if n = 4 then l:= 10;
            if n = 5 then l:= 13;
            if n = 6 then l:= 16;
            Insert('#' + inttostr(l), tempCantaxFieldCode, 6);
          end else
            Insert('#' + inttostr(n), tempCantaxFieldCode, 6);
          //20260803 Alex <<<
        end;
        okay := ParseKey(tempCantaxFieldCode, c, Selector);
        //write value
        if okay and Assigned(Tables) then
        begin
          VisualTaxFieldCode := Copy(CanTaxInfoList[i], Pos('=',CanTaxInfoList[i])+1,Length(CanTaxInfoList[i]));
          VisualTaxFieldCode := StringReplace(VisualTaxFieldCode, '#y', '#'+inttostr(n),[rfReplaceAll, rfIgnoreCase]);

          lRecPtr:= Tables.GetRecord(Selector); //20260803 Alex
          Try
            case Selector.ft of
            //20170321 Igor >>>
             ftCurr: ConvertedValuesList.Add( VisualTaxFieldCode + '^' + CurrToStr(Tables.GetReal(Selector)) );
             //20260803 Alex >>>
             ftByte:
             begin
               if (CantaxFormNumber = 148) then
                 ConvertedValuesList.Add( VisualTaxFieldCode + '^' + IfThen(Tables.GetByte(Selector) = 1, 'X', '') )
               else
                 ConvertedValuesList.Add( VisualTaxFieldCode + '^' + IntToStr(Tables.GetByte(Selector)) );
             end;
             //20260803 Alex <<<
             ftInt:  ConvertedValuesList.Add( VisualTaxFieldCode + '^' + IntToStr(Tables.GetLong(Selector)) );
             ftStr:  ConvertedValuesList.Add( VisualTaxFieldCode + '^' + Tables.GetString(Selector) );
             //20170321 Igor <<<
            end;
          except
            //showmessage('Failed to read code ' + tempCantaxFieldCode);
          end;

        end; //if okay and Assigned(Tables)

        inc(n);
      until n > clonecount+1;
      //end;   //for CloneCount


    end; //<> '//'
  end; //CanTaxInfoList

 except
 end;

 ConvertedFlName := GetConvertedFlName(TempDir +'\'+ClientInFile[c]);
 ConvertedValuesList.savetoFile(ConvertedFlName);

 ImportOne(ConvertedValuesList);

end; //for clientsInFile

CanTaxInfoList.free;
ConvertedValuesList.free;
//showmessage('Cantax Values File Created');

end;

Function TRollCtxT1_2026.GetConvertedFlName(CanTaxFlName:String):String;
Var s:String;
Begin
  s:= CanTaxFlName;
  s:= ExtractFileName(CanTaxFlName);
  s:= ChangeFileExt(s,'.'+TempFlExtension);
  result:=TempDir+'\'+s;
end;

Function TRollCtxT1_2026.ImportOne(ConvertedValues:TStringlist):Integer;
Var i,j,FNo,AssetFNo: integer; Msg:string;
    PrPStatus,EfStatus,Notes,LastYrDir,Sin:String;
begin
  Result:=9;

  If SaveOrOpenOptionBox.ItemIndex = 0 then
    RetNo := FileNew
  else
    RetNo:=CreateNewReturn;
  if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;

  Try
      Ret[RetNo].SourceDataDir := ToDirBox.Text; {fooli t}

      StoreData(ConvertedValues);
      
      FNo :=GetFormNo('STATUS');
      //created
      For j:=5 to 5 do StoreElm(RetNo,FNo,j,'CONV-CTAX');
      For j:=6 to 6 do StoreElm(RetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
      For j:=7 to 7 do StoreElm(RetNo,FNo,j,TimeToStr(Time));
      //updated
      For j:=11 to 11 do StoreElm(RetNo,FNo,j,User.UserName); //20170112 Igor
      For j:=12 to 12 do StoreElm(RetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
      For j:=13 to 13 do StoreElm(RetNo,FNo,j,TimeToStr(Time));

    // RecalcEverything(RetNo); //needed   //20091214
    //20091214
      For i:=1 to 15 do
      begin
       AssetFNo:=GetFormNo('ASSETSB#'+AllTrim(IntToStr(i)));
       If AssetFNo>0 then InitFormData(RetNo,AssetFNo);
      end;
      StoreElm(RetNo,'ASSETSB#1',10,'N');
      SpCaptureCCALastYear(RetNo);
      PopulateAssets(RetNo);
      RecalcEverything(RetNo); //needed   //20091214

      UpdateAllDataIndicators(RetNo);

  except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;

    FixAfterImport(RetNo);

    FNo:=GetFormNo('ASSETSB#1');
    if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);
    StoreElm(RetNo,FNo,10,'Y');

    RecalcEverything(RetNo);

    If SaveOrOpenOptionBox.ItemIndex = 0 then
    begin
     //open
     OpenForm(RetNo,'INFO',0);
     MainForm.RefreshAuditPanel(RetNo);
     Ret[RetNo].Changed := True;
    end
    else
    begin
     //save to file
     Sin := AllTrim(FetchElm(RetNo,'INFO',3));
     VisualFlName:=LeftStr(Sin,8) + '.' +RightStr(Sin,1);
     If (FileExists(ToDirBox.Text+'\'+VisualFlName)) and (ReplaceOptionBox.ItemIndex=1) then
       ShowTimedMsg('File: '+Chr(13)+CanTaxFlName+Chr(13)+ 'already exists',1500)
     else
       SaveIt(VisualFlName);
     If RetNo >0 then RemoveReturnFromMemory(RetNo);
     RetNo :=0; //RetINmem :=0;
     //SendMessage(MDIHandle,WM_PAINT,0,0);
    end;

    Result:=0;
end;

procedure TRollCtxT1_2026.FileListBox1DblClick(Sender: TObject);
begin
OpenBtnClick(Sender);
end;

procedure TRollCtxT1_2026.CanTaxExtensionBoxChange(Sender: TObject);
begin
CanTaxExtension:=CanTaxExtensionBox.text;
ShowFiles;
end;


procedure TRollCtxT1_2026.FindBtnClick(Sender: TObject);
begin
 CanTaxFlName:=FromDirBox.Text+'\'+FileListBox1.Items[FileListBox1.ItemIndex];
 FindAStringInCanTax(CanTaxFlName);
end;

Function TRollCtxT1_2026.FindAStringInCanTax(CanTaxFlName:String):Integer;
var s:String;
    FldName,FldType: String;
    Item:Variant;
    FNo,ElmNo:Integer;
    OutList:TStringList;
    i,j,ii,VisualInst,VisualIncr,FCount,TableRows,MaxVisualRowsPerInst:Integer;
    CanTaxFrmNm,VisualFrmNm,CanTaxTableNm,VisualFldDescr,CanTaxInstance:String;

    Txt:String;
    FromFNo,ToFNo,Elms:Integer;
 begin
  Result:=9;
  Try
   If CanTaxAppCreated = false then
   begin
    CanTaxFile1:= {T1W_tlb.}CoCanTaxT1App.Create;
    CanTaxAppCreated := True;
    CanTaxFile1.MinimizeApp;
    CanTaxFile1.LoadTaxReturn(CanTaxFlName);
    CanTaxData1:= {T1W_tlb.}CoCanTaxT1Data.Create;
   end;
  except
   ShowMessage('CanTax cannot be started properly');
  end;
  //GENERAL SEARCH FOR A STRING in cantax:
  //check 300 form no and 1500 elements

  Txt:= UpperCase(InputBox('Input Box', 'Input text', ''));
  If Txt='' then exit;
  FromFNo:= MyStrToInt(UpperCase(InputBox('Input Box', 'From FNo', '1')));
  ToFNo:= MyStrToInt(UpperCase(InputBox('Input Box', 'To FNo', '100')));


  SomeList.Clear; // := TStringList.Create;
  ShowMessage('Starting loop');
  Screen.Cursor := crHourGlass;
  i:=FromFNo;
  Repeat
    j:=1;
    Repeat
    Try
     s:= CanTaxData1.GetString(i,j);

     If LeftStr(UpperCase(S),Length(Txt)) = UpperCase(Txt) then
         SomeList.Add('Form='+IntToStr(i)+' '+'Elm='+IntToStr(j)+' '+s);

    Except
      on EOLESysError do
      begin
       //ShowMessage('ERROR: i='+IntToStr(i)+' '+'Elm='+IntToStr(j));
       ii:=i;  //handled
      end;
    end;  //try
    Inc(j);
    until j>300; //5000;  //1500;
  Inc(i);
  until i>ToFNo;
  Screen.Cursor := crDefault;
  SomeList.SaveToFile('C:\test\Cantax.txt');
  PopSomeList(SomeList,SomeCaption);
  // SomeList.Free;  //20160301 Igor
end;

procedure TRollCtxT1_2026.LovBtnClick(Sender: TObject);
begin
 CanTaxFlName:=FromDirBox.Text+'\'+FileListBox1.Items[FileListBox1.ItemIndex];
 ShowLovInForm(CanTaxFlName);
end;

Function TRollCtxT1_2026.ShowLOVInForm(CanTaxFlName:String):Integer;
var s:String;
    FldName,FldType: String;
    Item:Variant;
    FNo,ElmNo:Integer;
    OutList:TStringList;
    i,j,ii,VisualInst,VisualIncr,FCount,TableRows,MaxVisualRowsPerInst:Integer;
    CanTaxFrmNm,VisualFrmNm,CanTaxTableNm,VisualFldDescr,CanTaxInstance:String;

    Txt:String;
    FromFNo,ToFNo,FromElm,Elms:Integer;
 begin
  Result:=9;
  Try
   If CanTaxAppCreated = false then
   begin
    CanTaxFile1:= {T1W_tlb.}CoCanTaxT1App.Create;
    CanTaxAppCreated := True;
    CanTaxFile1.MinimizeApp;
    CanTaxFile1.LoadTaxReturn(CanTaxFlName);
    CanTaxData1:= {T1W_tlb.}CoCanTaxT1Data.Create;
   end;
  except
   ShowMessage('CanTax cannot be started properly');
  end;
  //GENERAL SEARCH FOR A STRING in cantax:
  //check 300 form no and 1500 elements

  FromFNo:= MyStrToInt(UpperCase(InputBox('Input Box', 'From FNo', '')));
  If FromFNo=0 then exit;
  ToFNo:= MyStrToInt(UpperCase(InputBox('Input Box', 'To FNo', '23')));
  FromElm:= MyStrToInt(UpperCase(InputBox('Input Box', 'From Elm', '1')));
  Elms:= MyStrToInt(UpperCase(InputBox('Input Box', 'HowMany Elms', '1500')));

  SomeList.Clear; // := TStringList.Create;
  //SomeList.Sorted := True;


  Screen.Cursor := crHourGlass;
  ShowMessage('Starting loop');
  i:=FromFNo;
  Repeat
    j:=FromElm;
    Repeat
    Try

     s:= CanTaxData1.GetString(i,j);
     If (Length(s)>0) and (Length(s)<20) then
       SomeList.Add('Form='+IntToStr(i)+' '+'ElmString='+IntToStr(j)+' '+s);

     (*
     s:= FloatToStr(CanTaxData1.GetReal(i,j));
     If Vl(S)<>0 then
     begin
      If Abs(Vl(S)) < 9999999 then
       SomeList.Add('Form='+IntToStr(i)+' '+'ElmReal='+IntToStr(j)+' '+s);
     end;
     s:= IntToStr(CanTaxData1.GetByte(i,j));
     If Vl(S)<>0 then SomeList.Add('Form='+IntToStr(i)+' '+'ElmByte='+IntToStr(j)+' '+s);
     *)
    Except
      on EOLESysError do ii:=i;  //handled
    end;  //try
    Inc(j);
    until j>FromElm+Elms;
  Inc(i);
  until i>ToFNo;
  Screen.Cursor := crDefault;
  SomeList.SaveToFile('C:\test\Cantax-LOV.txt');
  PopSomeList(SomeList,SomeCaption);
  //SomeList.Free; //20160301 Igor
end;


Function TRollCtxT1_2026.FixMarStatus(Valu:String):Integer;
Var n:Integer;
begin
 n:=MyStrToInt(AllTrim(Valu));
 Case n of
   0:  Result:=11;
   1:  Result:=12;
   2:  Result:=13;
   3:  Result:=16;
   4:  Result:=17;
   5:  Result:=18;
  end;  {case}
end;

Procedure TRollCtxT1_2026.FixAfterImport(RetNo:Integer);
Var s:String; FNo:Integer;
begin
 FixBusStatements(RetNo);
 //spouse birthdate
 If Ret[RetNo].MarStatus >2 then
  StoreElm(RetNo,'INFO',59,'');
end;

Procedure TRollCtxT1_2026.FixBusStatements(RetNo:Integer);
Var i,j:Integer;inst:String;FName:String;FNo:Integer;x:Real;s:String;
begin
 //T2125
 For i:=1 to 9 do
 begin
  Inst:='#'+AllTrim(IntToStr(i));
  FName:='T2125'+Inst;
  FNo:=GetFormNo(FName);
  If FNo >0 then
  begin
    If (Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]) then
    begin
     // Post to bus or commission
     If FetchElmFNo(RetNo,FNo,73) ='0' then
      Begin
       StoreElm(RetNo,FNo,82,'X');StoreElm(RetNo,FNo,90,'');StoreElm(RetNo,FNo,73,'X');
      end
     else If FetchElmFNo(RetNo,FNo,73) ='2' then
     begin
      StoreElm(RetNo,FNo,90,'X');StoreElm(RetNo,FNo,82,'');
      StoreElm(RetNo,FNo,73,'');StoreElm(RetNo,FNo,74,'');
     end
     else If FetchElmFNo(RetNo,FNo,73) ='1' then  //commission
     begin
      StoreElm(RetNo,FNo,82,'X');StoreElm(RetNo,FNo,90,'');
      StoreElm(RetNo,FNo,73,'');StoreElm(RetNo,FNo,74,'X');
     end;

    If FetchElmFNo(RetNo,FNo,4) >'' then
      AdvanceYearEnd(FetchElmFNo(RetNo,FNo,4));
    If FetchElmFNo(RetNo,FNo,5) >'' then
      AdvanceYearEnd(FetchElmFNo(RetNo,FNo,5));

    If Vl(FetchElmFNo(RetNo,FNo,23)) <> 0 then  //sales
     begin
       StoreElm(RetNo,FNo,23,''); //remove amount
       //If FetchElmFNo(RetNo,FNo,8)='' then StoreElm(RetNo,FNo,8,'???');  //bus name
     end;
     //Business Number (bn)
     StoreElm(RetNo,FNo,19,LeftStr(FetchElmFNo(RetNo,FNo,19),3));
     StoreElm(RetNo,FNo,20,MidStr(FetchElmFNo(RetNo,FNo,20),4,3));
     StoreElm(RetNo,FNo,21,RightStr(FetchElmFNo(RetNo,FNo,21),3));
    end;  //has data
  end; //Fno>0

  FName:='T2125'+Inst;
  FNo:=GetFormNo(FName);
  If FNo >0 then
  begin
    j:=301;
    repeat
     If Vl(FetchElmFNo(RetNo,FNo,j))=0 then StoreElm(RetNo,FNo,j,'');
     Inc(j,10);
    until j>371;
  end; //Fno>0
 end;  //i

 //T2121
 // ShowMessage('fixing T2121');
 For i:=1 to 4 do
 begin
  Inst:='#'+AllTrim(IntToStr(i));
  FName:='T2121'+Inst;
  FNo:=GetFormNo(FName);

  If FNo>0 then
  begin
    If (Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]) then
    begin
     If Vl(FetchElmFNo(RetNo,FNo,20)) <> 0 then
     begin
       StoreElm(RetNo,FNo,20,''); //remove amount

     end;
     StoreElm(RetNo,FNo,15,LeftStr(FetchElmFNo(RetNo,FNo,15),3));
     StoreElm(RetNo,FNo,16,MidStr(FetchElmFNo(RetNo,FNo,16),4,3));
     StoreElm(RetNo,FNo,17,RightStr(FetchElmFNo(RetNo,FNo,17),3));
    end  //hasdata
    Else
     ClearAnyForm(RetNo,'T2121');
  end;  //Fno
 end;

 //T2042
 //ShowMessage('fixing T2042');
 For i:=1 to 4 do
 begin
  Inst:='#'+AllTrim(IntToStr(i));
  FName:='T2042'+Inst;
  FNo:=GetFormNo(FName);
  If FNo >0 then
  begin
    If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
    begin
     If Vl(FetchElmFNo(RetNo,FNo,26)) <> 0 then
     begin
       StoreElm(RetNo,FNo,26,''); //remove amount
       //If FetchElmFNo(RetNo,FNo,8)='' then StoreElm(RetNo,FNo,8,'???');
     end;
    //If FetchElmFNo(RetNo,FNo,4) >'' then AdvanceYearEnd(FetchElmFNo(RetNo,FNo,4));
    //If FetchElmFNo(RetNo,FNo,5) >'' then AdvanceYearEnd(FetchElmFNo(RetNo,FNo,5));

     StoreElm(RetNo,FNo,21,LeftStr(FetchElmFNo(RetNo,FNo,21),3));
     StoreElm(RetNo,FNo,22,MidStr(FetchElmFNo(RetNo,FNo,22),4,3));
     StoreElm(RetNo,FNo,23,RightStr(FetchElmFNo(RetNo,FNo,23),3));
    end;
  end; //FNo
 end;

 //T776
 //ShowMessage('fixing T776');
 For i:=1 to 6 do
 begin
  Inst:='#'+AllTrim(IntToStr(i));
  FName:='T776'+Inst;
  FNo:=GetFormNo(FName);
  If FNo >0 then
  begin
    If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
    begin
     If Vl(FetchElmFNo(RetNo,FNo,47)) <> 0 then StoreElm(RetNo,FNo,47,''); //remove amount
     If Vl(FetchElmFNo(RetNo,FNo,50)) <> 0 then StoreElm(RetNo,FNo,50,''); //remove amount
     If Vl(FetchElmFNo(RetNo,FNo,53)) <> 0 then StoreElm(RetNo,FNo,53,''); //remove amount
     StoreElm(RetNo,FNo,15,LeftStr(FetchElmFNo(RetNo,FNo,15),3));
     StoreElm(RetNo,FNo,16,MidStr(FetchElmFNo(RetNo,FNo,16),4,3));
     StoreElm(RetNo,FNo,17,RightStr(FetchElmFNo(RetNo,FNo,17),3));
    end;
  end; //FNo
 end; //i

 For i:=1 to 6 do
 begin
  Inst:='#'+AllTrim(IntToStr(i));
  FName:='T776'+Inst;
  FNo:=GetFormNo(FName);
  If FNo >0 then
  begin
    j:=201;
    Repeat
     If AllTrim(FetchElmFNo(RetNo,FNo,j))='0' then
      begin
       StoreElm(RetNo,FNo,j,'');
       StoreElm(RetNo,FNo,j+1,'');
      end;
     Inc(j,9);
    until j>255;
  end; //FNo
 end; //i

end;


(*
procedure TRollCtxT1_2026.BitBtn1Click(Sender: TObject);
begin
  ShowHelp('T1Help','Conversion_from_CanTax');
  ShowHelp('www.visualtax.com/Vt2018HELP/T1Help/Website/'
      +'T1Help.html?Conversion_from_CanTax.html');
  {
  Application.HelpFile := AppDir+'\'+'T1Help.HLP';
  Application.HelpJump('Conversion_from_CanTax');
  }
end;
*)

Procedure TRollCtxT1_2026.CheckDateFormat;
Var WinBootDir:String;
Begin
(*
 WinBootDir:=GetWinBootDir;
 If (UpperCase(GetWinIniString(WinBootDir+'\'+'Win.Ini','intl','sShortDate'))
     <> 'MM/DD/YYYY')
 then
  ShowMessage('For best rollover of BirthDates etc. the Date format in the Windows'+
    Chr(13)+'Control Panel should be MM/DD/YYYY'
    +Chr(13)+'See Control Panel -> Regional Settings -> Customize -> Date -> Short Date Format');
*)
end;

procedure TRollCtxT1_2026.LinkToOptionsLblClick(Sender: TObject);
begin
 ExecuteForm(TOptionsFrmT1_2026);
 Close;
end;

Procedure TRollCtxT1_2026.FixRentalPercent(RetNo:Integer);
var i,FNo:Integer;x:Real; s,Fname:String; Inst:String;
Begin

 For i:=1 to 9 do
 begin
      Inst:='#'+AllTrim(IntToStr(i));
      FName:='T776'+Inst;
      FNo:=GetFormNo(FName);
      If FNo >0 then
      begin
       //ShowMessage('sp percent='+FetchElmFNo(RetNo,FNo,38));
       x:=vl(FetchElmFNo(RetNo,FNo,24))
       +vl(FetchElmFNo(RetNo,FNo,28))
       +vl(FetchElmFNo(RetNo,FNo,32))
       +vl(FetchElmFNo(RetNo,FNo,36))
       +vl(FetchElmFNo(RetNo,FNo,40))
       +vl(FetchElmFNo(RetNo,FNo,44));
       s:=FormatFloat('###.##',100-x);
       //ShowMessage(s);
       StoreElm(RetNo,'T776'+Inst,18,s);
      end;
 end;
end;


Procedure TRollCtxT1_2026.FixBusPercent(RetNo:Integer);
var i,FNo:Integer;x:Real; s,Fname:String; Inst:String;
Begin

 For i:=1 to 9 do
 begin
      Inst:='#'+AllTrim(IntToStr(i));
      FName:='T2125'+Inst;
      FNo:=GetFormNo(FName);
      If FNo >0 then
      begin
       //ShowMessage('sp percent='+FetchElmFNo(RetNo,FNo,38));
       x:=vl(FetchElmFNo(RetNo,FNo,238))
       +vl(FetchElmFNo(RetNo,FNo,241))
       +vl(FetchElmFNo(RetNo,FNo,244))
       +vl(FetchElmFNo(RetNo,FNo,247))
       +vl(FetchElmFNo(RetNo,FNo,250));
       s:=FormatFloat('###.##',100-x);
       //ShowMessage(s);
       StoreElm(RetNo,'T2125'+Inst,18,s);
      end;
 end;
end;

Procedure TRollCtxT1_2026.FixFishingPercent(RetNo:Integer);
var i,FNo:Integer;x:Real; s,Fname:String; Inst:String;
Begin
 For i:=1 to 9 do
 begin
      Inst:='#'+AllTrim(IntToStr(i));
      FName:='T2121'+Inst;
      FNo:=GetFormNo(FName);
      If FNo >0 then
      begin
       //ShowMessage('sp percent='+FetchElmFNo(RetNo,FNo,38));
       x:=vl(FetchElmFNo(RetNo,FNo,505))
       +vl(FetchElmFNo(RetNo,FNo,509))
       +vl(FetchElmFNo(RetNo,FNo,513))
       +vl(FetchElmFNo(RetNo,FNo,517))
       +vl(FetchElmFNo(RetNo,FNo,521));
       s:=FormatFloat('###.##',100-x);
       //ShowMessage(s);
       StoreElm(RetNo,'T2121'+Inst,18,s);
      end;
 end;
end;

Procedure TRollCtxT1_2026.FixFarmingPercent(RetNo:Integer);
var i,FNo:Integer;x:Real; s,Fname:String; Inst:String;
Begin
 For i:=1 to 9 do
 begin
      Inst:='#'+AllTrim(IntToStr(i));
      FName:='T2042'+Inst;
      FNo:=GetFormNo(FName);
      If FNo >0 then
      begin
       //ShowMessage('sp percent='+FetchElmFNo(RetNo,FNo,38));
       x:=vl(FetchElmFNo(RetNo,FNo,642))
       +vl(FetchElmFNo(RetNo,FNo,646))
       +vl(FetchElmFNo(RetNo,FNo,650))
       +vl(FetchElmFNo(RetNo,FNo,654))
       +vl(FetchElmFNo(RetNo,FNo,658))
       +vl(FetchElmFNo(RetNo,FNo,662));
       s:=FormatFloat('###.##',100-x);
       //ShowMessage(s);
       StoreElm(RetNo,'T2042'+Inst,24,s);
      end;
 end;
end;

procedure TRollCtxT1_2026.FileListBox1Change(Sender: TObject);
begin
if FileListBox1.SelCount > 0 then
 OpenBtn.enabled := true
else
 OpenBtn.enabled := false;
end;

procedure TRollCtxT1_2026.FileListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0; //prevent beep
    OpenBtnClick(nil);
  end;
end;

Procedure TRollCtxT1_2026.SpCaptureCCALastYear(RetNo:Integer);
Var i,rowndx,FNo:Integer;
Begin
   FNo:=GetFormNo('CCALIST');
   InitFormData(RetNo,FNo);  //20090129
   For i:=1 to 171 do begin StoreElm(RetNo,FNo,i,'');end;  //init
   RowNdx:=1;
   //Other
   ExtractCCAList(RetNo,RowNdx,'T776',201,237,9);
   ExtractCCAList(RetNo,RowNdx,'T2125',301,371,10);   //20090201
   ExtractCCAList(RetNo,RowNdx,'T2121',137,207,10);
   ExtractCCAList(RetNo,RowNdx,'T2042',401,471,10);
   ExtractCCAList(RetNo,RowNdx,'T1175',1,71,10);
   ExtractCCAList(RetNo,RowNdx,'T1175H',1,71,10);
End;


end.
