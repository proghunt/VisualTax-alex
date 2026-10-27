unit T1_2026SpecialGpT1;
{distribution RollGpT1.d}
(*
Comments:
Input RollGpT1.d  format: T1.S[2]=SIN^PAGE^1
output in TempDir  Format: above+ ^+value
*)

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,ExtCtrls,DB,StdCtrls,Grids,DBGrids,DBCtrls,Menus,Buttons,
  FileCtrl,ShellApi,T1_2026Declare,Mask,ComCtrls,VclTee.TeeProcs,VclTee.TeEngine,VclTee.Chart,ComObj,
  olectnrs,OleServer;

Const
 TempFlExtension  = 'EXP';
 FieldsFlName     = 'SpecialGpT1.d';
 TempDirName      = 'TempDir';

type
  TSpecialGpT1_2026 = class(TForm)
    OpenDialog1: TOpenDialog;
    OptionsGroupBox: TGroupBox;
    ReplaceOptionBox: TRadioGroup;
    ActionsGroupBox: TGroupBox;
    OpenBtn: TBitBtn;
    ImportAllBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FilesGroupBox: TGroupBox;
    FileListBox1: TFileListBox;
    ProfileExtensionBox: TComboBox;
    Label1: TLabel;
    FromDirBox: TEdit;
    SelectDirBtn1: TBitBtn;
    Label3: TLabel;
    ToDirBox: TEdit;
    SelectDirBtn2: TBitBtn;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    Label8: TLabel;
    HelpBtn: TBitBtn;
    ProcessingLbl: TLabel;
    Label5: TLabel;
    HowManyBox: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    SpouseBox: TCheckBox;
    LinkToOptionsLbl: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Psw: TEdit;
    Label12: TLabel;
    Label4: TLabel;

    Procedure ReviseAssetsLinks(RetNo:Integer;ReverseCCA:Boolean);
    Procedure FixT1163T1273(RetNo:Integer);
    Procedure SpCaptureCCALastYear(RetNo:Integer);
    procedure GetHBPandLLP(RetNo:Integer);
    Procedure CheckDateFormat;
    Function FixMarStatus(Valu:String):Integer;
    Function FixValu(FName,Valu:String;FNo,Elm:Integer):String;
    Function ConvertDepRelationship(Valu:String):String;
    Function ConvertProvOfRes(Valu:String):String;

    Function GetVisualExt(VtYearEnd:String):String;
    function GetValue(FldName:WideString):String;
    Function ConvertOne(GpFlName:String;ClientOrSpouse:String):Integer;
    Function  FldNameIsString(FldName:String):Boolean;

    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ImportAllBtnClick(Sender: TObject);
    procedure ImportAll;
    procedure SaveIt(FlName:String);
    procedure StoreData(ConvertedFlName:String);
    Function  ImportOne(ConvertedFlName:String;ClientOrSpouse:String):Integer;
    procedure HelpBtnClick(Sender: TObject);
    Function  GetSinNo(ClientOrSpouse:string):String;
    procedure OpenBtnClick(Sender: TObject);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure SelectDirBtn2Click(Sender: TObject);
    procedure ShowFiles;
    procedure FromDirBoxExit(Sender: TObject);
    procedure FromDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure ProfileExtensionBoxChange(Sender: TObject);
    Procedure FixBusStatements(RetNo:Integer);
    Procedure FixRefundLine(RetNo:Integer);
    Procedure SplitFldLists;
    Procedure ReplaceNdxWithStm(Var TmpList:TStringList;StmId:String;StmNo:Integer);
    Function  IsBusStatement(FldName:String):Boolean;
    Function  OpenAReturn(GpFlName:String;ClientOrSpouse:String):Boolean;
    procedure BitBtn1Click(Sender: TObject);
    Procedure FixNISASin(RetNo:Integer);
    procedure LinkToOptionsLblClick(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo:Integer;
    SpousePrefix:String;
    ProfileFile1:Variant;
    ProfileClient1:Variant;

    FldList,{T4List,T5List,T4AList,T3List,}
    T2125List,T2121List,T2042List,T776List:TStringList;
    T2125CCAList,T2121CCAList,T2042CCAList,T776CCAList,T1164CCAList:TStringList;
    ButtonClicked:String;
    GPFlName,ConvertedFlName,VisualFlName: String;
    ProfileExtension: String;
    GPYearEnd,VTYearEnd:string; //[10];
    Cnt   : integer;
    InitialRowCount :integer;

    TempDir:String;
  end;

var
  SpecialGpT1: TSpecialGpT1_2026;

implementation

{$R *.DFM}

uses vtMulti,vtCommon,vtDialogs,vtMain,T1_2026,T1_2026Common,T1_2026TrimStr,
  T1_2026Common2,T1_2026ChildWinNEW,T1_2026Calc,T1_2026CalcBus,
  T1_2026OptionsFrm,T1_2026Profile_TLB,T1_2026T1Rtns,T1_2026Main,vtTrimStr,
  vtShared;

procedure TSpecialGpT1_2026.FormCreate(Sender: TObject);
var i:Integer;
begin
 //ShortDateFormat:='MM/dd/yyyy';
 SpousePrefix:='';
 ProcessingLbl.Caption:='';
 HowManyBox.Text:='10';
 SplitFldLists;
 ButtonClicked:='';
 ToDirBox.Text:=OptRec.Dir_Cur;
 ProfileExtensionBox.Text:='10T'; //20110217 //{ProfileExtension;}
 ProfileExtension:=ProfileExtensionBox.Text;
 {remove it}
 FromDirBox.Text:=OptRec.Dir_LastYr; //'C:\Documents and Settings\Administrator\My Documents\My ProFile Data\2010T1\SpecialGPT1'; //OptRec.Dir_LastYr;
 TempDir:=AppDir+'\'+ TempDirName;
 If DirectoryExists(TempDir) then
 else
  MkDir(TempDir);

 ShowFiles;
end;

procedure TSpecialGpT1_2026.CancelBtnClick(Sender: TObject);
begin
 FldList.Free;
 Close;
end;

function TSpecialGpT1_2026.GetValue(FldName:WideString):String;
//Var label TryAgain;
begin
 Result:='';
 If FldName='' then exit;
 try
   result:= ProfileClient1.Field[SpousePrefix+FldName];
 except
  on E: Exception do
  begin
   If UpperCase(E.Message)= 'INVALID FORM NAME.' then
   begin ShowMessage('FldName in error='+SpousePrefix+FldName);exit;end;

   MessageDlg(E.Message, mtError, [mbok], 0);
   Try
     result :=FloatToStr(ProfileClient1.Field[SpousePrefix+FldName]);
     If result='0' then result :='';
     ShowMessage('FldName in error='+SpousePrefix+FldName);
   except
      Result:='';
   end;  //second try
  end;
 end; //first try
end;

procedure TSpecialGpT1_2026.ImportAllBtnClick(Sender: TObject);
Begin
 If RetInMem >0 then
 begin
  ShowMessage('Please Exit this form and Close all returns first');
  exit;
 end;
 CheckDateFormat;

 ImportAll;
end;

procedure TSpecialGpT1_2026.ImportAll;
Var i,k:Integer;Rslt:Integer;ClientOrSpouse:String;FNo:Integer;
begin
 If RetInMem>0 then
 begin
  ShowMessage('Please close all returns first');
  exit;
 end;

 If FileListBox1.Items.Count<=0 then
 begin
  ShowMessage('No files are available for Roll-over');
  exit;
 end;

 if MessageDlg('Batch conversion. Are you sure?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;

 ButtonClicked:='IMPORT ALL';
 Screen.Cursor:=crHourGlass;
 Cnt:=0;
 //FileListBox1.ItemIndex:=0;
 k:=FileListBox1.Itemindex;
 FileListBox1.Refresh;
 ClientOrSpouse:='C';
 For i:=k to FileListBox1.Items.Count-1 do
 begin
 Try
  //If FileListBox1.Items.Count>30 then begin Flist.Free;InitFormsTable;;end;  //20090301
  If i>k-1+Vl(HowManyBox.Text) then break;
  FileListBox1.ItemIndex:=i;
  FileListBox1.Refresh;
  ProcessingLbl.Caption:='Processing No :'+IntToStr(i+1);
  ProcessingLbl.Refresh;
  GPFlName:=FromDirBox.Text+'\'+FileListBox1.Items[i];
  ClientOrSpouse:='C';
  If ConvertOne(GpFlName,ClientOrSpouse) = 0 then
  begin
   Rslt:=ImportOne(ConvertedFlName,ClientOrSpouse);
   FNo:=GetFormNo('ASSETSB#1');
   if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);
   StoreElm(RetNo,'ASSETSB#1',10,'N');
   StoreElm(RetNo,'STATUS',4,'01'); //not started
   Ret[RetNo].PrpStatus:='01';

   If RetNo > 0 then
     RemoveReturnFromMemory(RetNo);
  end;

  If (SpouseBox.Checked)
   and
  (ProfileClient1.Field['Spouse.T1Info.S[1]'] >'') then //there is spouse data in file
  //If (SpouseBox.Checked) and (GetValue('Spouse.T1Info.S[1]') >'') then //there is spouse data in file
  begin
      ClientOrSpouse:='S';
      Rslt:=ConvertOne(GpFlName,  ClientOrSpouse);
      If Rslt = 0 then
      begin
        ImportOne(ConvertedFlName,ClientOrSpouse);
        FNo:=GetFormNo('ASSETSB#1');
        if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);
        StoreElm(RetNo,'ASSETSB#1',10,'N');
        StoreElm(RetNo,'STATUS',4,'01'); //not started
        Ret[RetNo].PrpStatus:='01';
        FixBusStatements(RetNo);
        FixRefundLine(RetNo);
        StoreElm(RetNo,'ASSETSB#1',10,'Y');
        FixT1163T1273(RetNo);
        //ReviseAssetsLinks(RetNo,True);
        RecalcEverything(RetNo);
        If RetNo >0 then
          RemoveReturnFromMemory(RetNo);
        Try
        except
        end;  //try
      end; //convertone
  end; //spouse
  Except
  end; //try
  Screen.Cursor:=crHourGlass;
 end; //i
 ProcessingLbl.Caption:='';
 ProcessingLbl.Refresh;
 Screen.Cursor:=crDefault;
 ShowMessage('Total returns rolled-over= '+IntToStr(cnt)
    +Chr(13)+'You can now Exit and use Open from the VisualTax Main Menu');
 ButtonClicked:='';
end;


Function TSpecialGpT1_2026.GetVisualExt(VtYearEnd:String):String;
Var i:Integer;TwoDigitYE:string; //[2];
begin
 TwoDigitYE:= MidStr(VTYearEnd,3,2);
 Result := FillLeftZeros(AllTrim(TwoDigitYE),2);
end;



procedure TSpecialGpT1_2026.SaveIt(FlName:String);
begin
 //If FlName='' then FlName:='00000000.0';
 If not SaveReturn(RetNo,ToDirBox.Text,FlName,True,True) =0 then
   ShowMessage('Save of data failed')
 else
  Inc(Cnt);
end;

procedure TSpecialGpT1_2026.ShowFiles;
begin
FileListBox1.Directory := FromDirBox.Text;
FileListBox1.Mask := '*.'+ProfileExtensionBox.text;
FileListBox1.ItemIndex :=0;
FilesGroupBox.Caption := 'FILES: '+IntTostr(FileListBox1.Items.count);
end;

procedure TSpecialGpT1_2026.HelpBtnClick(Sender: TObject);
begin
  ShowHelp(AppT1_2026.ModuleHelpUpdFile,'Converting_from_Profile', True); //20160801 Igor
  {
  Application.HelpFile := AppDir+'\'+'T1UPDHLP.HLP';
  Application.HelpJump('Converting_from_Profile');
  }
end;


Function TSpecialGpT1_2026.GetSinNo(ClientOrSpouse:String):String;
Var i:Integer;ConvList,WList:TStringList;Sin:String;
begin
 If ClientOrSpouse = 'C' then
   Sin:=ProfileClient1.Field['T1Info.S[1]']
 Else
   Sin:=ProfileClient1.Field['Spouse.T1Info.S[1]'];
 result:=LeftStr(AllTrim(RemoveChar(Sin,' ')),9);
end;

procedure TSpecialGpT1_2026.OpenBtnClick(Sender: TObject);
Var i:Integer;Rslt:Boolean; AssetFNo:Integer;
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

 CheckDateFormat;
 GPFlName:=FromDirBox.Text+'\'+FileListBox1.Items[FileListBox1.ItemIndex];
 //ShowMessage('GPFlName='+GPFlName);
 Rslt:=OpenAReturn(GpFlName,'C');
 If Rslt=True  then
 begin
   If (SpouseBox.Checked)
   and
  (ProfileClient1.Field['Spouse.T1Info.S[1]'] >'') then //there is spouse data in file
   begin
    ShowTimedMsg('Now opening spousal return',1200);
    ButtonClicked:='OPEN';
    OpenAReturn(GpFlName,'S');
    ShowMessage('Both spouses are now open'+
      Chr(13)+'You may save (F3), swap (F8) or start coupling');
   end;
 end;
 ButtonClicked:='';
 Close;
end;

Function TSpecialGpT1_2026.OpenAReturn(GpFlName:String;ClientOrSpouse:String):Boolean;
Var i,FNo:Integer;
begin
 Result:=False;
 ButtonClicked:='OPEN';
 Screen.Cursor:= crHourGlass;
 If (ConvertOne(GpFlName,ClientOrSpouse) = 0)
 and (ImportOne(ConvertedFlName,ClientOrSpouse) = 0) then
 begin
  FNo:=GetFormNo('ASSETSB#1');
  if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);
  StoreElm(RetNo,'ASSETSB#1',10,'N');
  StoreElm(RetNo,'STATUS',4,'01'); //not started
  Ret[RetNo].PrpStatus:='01';

  FixBusStatements(RetNo);
  FixRefundLine(RetNo);
  FixNisaSin(RetNo);
  StoreElm(RetNo,'ASSETSB#1',10,'Y');
  FixT1163T1273(RetNo);
  //ReviseAssetsLinks(RetNo,True);
  RecalcEverything(RetNo);
  UpdateAllDataIndicators(RetNo);
  //If MainForm.AuditPanel.Visible then
    MainForm.RefreshAuditPanel(RetNo);
  OpenForm(RetNo,'INFO',0);
  Ret[RetNo].Changed := True;
  Screen.Cursor:= crDefault;
  Result:=True;
 end;
end;

Procedure TSpecialGpT1_2026.ReviseAssetsLinks(RetNo:Integer;ReverseCCA:Boolean);
var i,FNo:Integer;OldStmt,NewStmt:String; TempList:TStringList;FInst:String;
Begin
{

 //now revise assetsb
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   FNo :=Frec.FormNo;
   If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
   begin
     //AssetsB
     if FRec.FormName = 'ASSETSB' then
     begin
       OldStmt:=FetchElmFNo(RetNo,FNo,215);
       FInst:=AllTrim(MidStr(OldStmt,6,2));
       If OldStmt>'' then
       begin
        If LeftStr(OldStmt,5)='T2124' then
        begin
          StoreElm(RetNo,FNo,215,'T2125'+FInst);
          Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
        If LeftStr(OldStmt,5)='T2032' then
        begin
          StoreElm(RetNo,FNo,215,'T2125'+FInst);
          Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
       end;

       OldStmt:=FetchElmFNo(RetNo,FNo,221);
       FInst:=AllTrim(MidStr(OldStmt,6,2));
       If OldStmt>'' then
       begin
        If LeftStr(OldStmt,5)='T2124' then
        begin
         StoreElm(RetNo,FNo,221,'T2125'+FInst);
         Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
        If LeftStr(OldStmt,5)='T2032' then
        begin
          StoreElm(RetNo,FNo,221,'T2125'+FInst);
          Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
       end;

       OldStmt:=FetchElmFNo(RetNo,FNo,227);
       FInst:=AllTrim(MidStr(OldStmt,6,2));
       If OldStmt>'' then
       begin
        If LeftStr(OldStmt,5)='T2124' then
        begin
          StoreElm(RetNo,FNo,227,'T2125'+FInst);
          Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;

        If LeftStr(OldStmt,5)='T2032' then
        begin
          StoreElm(RetNo,FNo,227,'T2125'+FInst);
          Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
       end;
       OldStmt:=FetchElmFNo(RetNo,FNo,215);
       ShowMessage('Old stmt before checking T1175='+OldStmt);
      // FInst:=AllTrim(MidStr(OldStmt,6,2));
       If OldStmt>'' then
       begin
        If LeftStr(OldStmt,5)='T1175' then
        begin
         ShowMessage('old link='+OldStmt);
         FInst:=AllTrim(MidStr(OldStmt,6,2));
         StoreElm(RetNo,FNo,215,'T1163'+FInst);
         Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
        If LeftStr(OldStmt,6)='T1175H' then
        begin
         ShowMessage('old link='+OldStmt);
         FInst:=AllTrim(MidStr(OldStmt,7,2));
         StoreElm(RetNo,FNo,215,'T1273'+FInst);
         Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
       end;

      Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=True;
      Calc(RetNo,Frec.FormName);
     end;
  end; //Assets has data
 end; //i
 }
end;



procedure TSpecialGpT1_2026.SelectDirBtn1Click(Sender: TObject);
Var DirSelected:String;
begin
 DirSelected := fromDirBox.text;

 //openDialog1.InitialDir := fromDirBox.text;
 //if SelectDirectory('Select a folder:', '', DirSelected) then
 if SelectDirectory(DirSelected, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
 //20150727begin
  FromDirBox.Text := DirSelected;
//20150727 end;
 ShowFiles;

end;

procedure TSpecialGpT1_2026.SelectDirBtn2Click(Sender: TObject);
 Var DirSelected:String;
begin

  if SelectDirectory('Select a folder:', '', DirSelected) then
    ToDirBox.Text:=DirSelected;
end;

procedure TSpecialGpT1_2026.FromDirBoxExit(Sender: TObject);
begin
ShowFiles;
end;

procedure TSpecialGpT1_2026.FromDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If Key=#13 then ShowFiles;
end;

Function TSpecialGpT1_2026.ImportOne(ConvertedFlName:String;ClientOrSpouse:String):Integer;
Var i,j,FNo,AssetFNo: integer; Msg:string;
    PrPStatus,EfStatus,Notes:String;
    LastYrDir:string; //[60];
    Sin:String;
begin
 Result:=9;
 Sin := GetSinNo(ClientOrSpouse);
 If Sin ='' then
 begin
   ShowMessage('This return does not have a SIN');
   sin:='000000000';
  end;

  VisualFlName:=LeftStr(Sin,8) + '.' +RightStr(Sin,1); //GetVisualExt(VtYearEnd);
  If (FileExists(ToDirBox.Text+'\'+VisualFlName))
  and (ReplaceOptionBox.ItemIndex=1)
  and (ButtonClicked <> 'OPEN')
  then
  begin
    ShowTimedMsg('Already exists in VisualTax. Skipped',700);
    result:=2;
    Exit;
  end;

  If ButtonClicked = 'OPEN' then
    RetNo := FileNew
  else
   RetNo:=CreateNewReturn;
   if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;

  Try
      StoreElm(RetNo,'ASSETSB#1',10,'N');
      GetHBPandLLP(RetNo);
      Ret[RetNo].SourceDataDir := ToDirBox.Text; {fooli t}
      StoreData(ConvertedFlName);
      FNo :=GetFormNo('STATUS');
      //created
      StoreElm(RetNo,'STATUS',4,'01'); //not started
      Ret[RetNo].PrpStatus:='01';
      For j:=5 to 5 do StoreElm(RetNo,FNo,j,'CONV-PROF');
      For j:=6 to 6 do StoreElm(RetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
      For j:=7 to 7 do StoreElm(RetNo,FNo,j,TimeToStr(Time));
      //updated
      For j:=11 to 11 do StoreElm(RetNo,FNo,j, User.UserName); //20170112 Igor
      For j:=12 to 12 do StoreElm(RetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
      For j:=13 to 13 do StoreElm(RetNo,FNo,j,TimeToStr(Time));

      RecalcEverything(RetNo);   //needed
      If ButtonClicked <> 'OPEN' then
      begin
       FixBusStatements(RetNo);
       FixRefundLine(RetNo);
       FixNisaSin(RetNo);
       StoreElm(RetNo,'ASSETSB#1',10,'Y');
       FixT1163T1273(RetNo);
       //ReviseAssetsLinks(RetNo,True);
       FixT1163T1273(RetNo);
       RecalcEverything(RetNo);
       UpdateAllDataIndicators(RetNo);
       SaveIt(VisualFlName);
      end;

  except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
  If ButtonClicked <> 'OPEN' then
  begin
   If RetNo >0 then
     //RemoveReturnFromMemory(RetNo);  //causes errors
  end;
  Result:=0;
end;


Function TSpecialGpT1_2026.FldNameIsString(FldName:String):Boolean;
Var i:Integer;
//coming in as xxx.s[
begin
 Result:=False;
 For i:=1 to Length(FldName) do
   If FldName[i] = '[' then
   begin
     If UpperCase(FldName[i-1]) = 'S' then
     begin result:=True;exit;end;
   end;
end;

procedure TSpecialGpT1_2026.FileListBox1DblClick(Sender: TObject);
begin
OpenBtnClick(Sender);
end;

procedure TSpecialGpT1_2026.ProfileExtensionBoxChange(Sender: TObject);
begin
ProfileExtension:=ProfileExtensionBox.text;
ShowFiles;
end;


Function TSpecialGpT1_2026.FixValu(FName,Valu:String;FNo,Elm:Integer):String;
begin
 Result:=Valu;

 If FName='INFO' then
 begin
  Case Elm of
   1: result:=GetLongPrv(ConvertProvOfRes(UpperCase(Valu)));
   14: result := UpperCase(Valu);
   15: result := UpperCase(Valu);
   9: result:=JulianDaysToBirthDate(Valu);  {birthdate}
   59: result:=JulianDaysToBirthDate(Valu);  {sp birthdate}
   23: If MyStrToInt(valu)=1 then result:='M' else Result:='F';
   3,4: result:=RemoveChar(Valu,' ');  {Sin}
   46: If AllTrim(valu)='1' then result := 'Y' else result:='N'; {efile}
   58: If AllTrim(valu)='1' then result := 'Y' else result:='N'; {represent}
   49: If Length(valu)=1 then result := '0'+Valu;  {NOA}
   43: If valu='1' then result := 'X' else result:=''; {elections}
   47: If valu='1' then result := '3' else result:='1';  {discounting}
   87: begin
        If AllTrim(valu)='1' then result := 'X' else result:='';  {disability}
       end;
   54: result:= MidStr(Valu,2,3); {ph area}
   55: result:= RightStr(Valu,8);  {phone}
   62: result:= MidStr(Valu,2,3);  {fax area}
   63: result:= RightStr(Valu,8);  {fax no}
  end;
 end;

 If FName='DEPEND' then
 begin
  Case Elm of
   10,25,40,55: Result:=JulianDaysToBirthDate(Valu);  {birthdate}
   7,22,37,52: Result:=RemoveChar(Valu,' '); {sin}
   11,26,41,56: result :=ConvertDepRelationship(Valu);
   19,34,49,64,79,94,109,124,139:
    If valu='1' then result := 'Y'  else  result:=''; //equiv to spouse
  end;
 end; //depend

 If (FName='DISAB18') and (Elm=26) then
 begin
   If valu='1' then result := 'Y'  else  result:=''; //disability
 end;


 If LeftStr(FName,5)='T2125' then  //20101214
 begin
  Case Elm of
   4,5:begin
      Result:=JulianDaysToBirthDate(Valu);
      If Result='2001-01-00' then result:='2000-12-31';
      If Result='2002-01-00' then result:='2001-12-31';
      If Result='2003-01-00' then result:='2002-12-31';
      If Result='2004-01-00' then result:='2003-12-31';
      //result:=IncrYear(Result);
   end;
   73:  If Valu ='0' then Result:='X' else result:='';    {bus or comm}
  end;
 end;

 If LeftStr(FName,5)='T2125' then   //20101214
 begin
  Case Elm of
   162,165,168,171: Result:=RemoveChar(Valu,' '); {Sin}
  end;
 end;

 If LeftStr(FName,5)='T2121' then
 begin
  Case Elm of
   4,5:begin
      Result:=JulianDaysToBirthDate(Valu);
      If Result='2001-01-00' then result:='2000-12-31';
      If Result='2002-01-00' then result:='2001-12-31';
      If Result='2003-01-00' then result:='2002-12-31';
      If Result='2004-01-00' then result:='2003-12-31';
      //result:=IncrYear(Result);
   end;
{
   15:begin
      StoreElm(RetNo,FNo,15,LeftStr(Valu,5));
      StoreElm(RetNo,FNo,16,MidStr(Valu,6,4));
      StoreElm(RetNo,FNo,17,RightStr(Valu,6));
      end;
}
  end;
 end;

 If LeftStr(FName,5)='T2042' then
 begin
  Case Elm of
   4,5:begin
      Result:=JulianDaysToBirthDate(Valu);
      If Result='2001-01-00' then result:='2000-12-31';
      If Result='2002-01-00' then result:='2001-12-31';
      If Result='2003-01-00' then result:='2002-12-31';
      If Result='2004-01-00' then result:='2003-12-31';
      //result:=IncrYear(Result);
   end;
{
      21:begin
      StoreElm(RetNo,FNo,21,LeftStr(Valu,5));
      StoreElm(RetNo,FNo,22,MidStr(Valu,6,4));
      StoreElm(RetNo,FNo,23,RightStr(Valu,6));
      end;
}
  end;
 end;

 If LeftStr(FName,4)='T776' then
 begin
   Case Elm of
   3,6: begin
        Result:=JulianDaysToBirthDate(Valu);
        If Result='2001-01-00' then result:='2000-12-31';
        If Result='2002-01-00' then result:='2001-12-31';
        If Result='2003-01-00' then result:='2002-12-31';
        If Result='2004-01-00' then result:='2003-12-31';
        //result:=IncrYear(Result);
        end;

{
   15: begin
           StoreElm(RetNo,FNo,15,LeftStr(Valu,5));
           StoreElm(RetNo,FNo,16,MidStr(Valu,6,4));
           StoreElm(RetNo,FNo,17,RightStr(Valu,6));
       end;
}
   45: //,48,51: {in one spot}
      begin
       //owMessage('BEFORE='+FetchElmFNo(RetNo,FNo,elm)+Chr(13)+'NEW VAL='+valu);
       result:=LeftStr(FetchElmFNo(RetNo,FNo,elm)+' '+Valu,70);
       //StoreElm(RetNo,FNo,Elm,FetchElmFNo(RetNo,FNo,elm)+' '+Valu);
       //owMessage('After='+ FetchElmFNo(RetNo,FNo,elm));
      end;
   end; {case}
 end;
end;

Function TSpecialGpT1_2026.ConvertProvOfRes(Valu:String):String;
Var n:Integer;
begin
 Result:=valu;
 n:=MyStrToInt(AllTrim(Valu));
 Case n of
  0: Result:='NA';
  1: Result:='BC';
  2: Result:='AB';
  3: Result:='SK';
  4: Result:='MB';
  5: Result:='ON';
  6: Result:='QC';
  7: Result:='NB';
  8: Result:='NS';
  9: Result:='PE';
  10:Result:='NL';
  11:Result:='YK';
  12:Result:='NT';
  13:Result:='ZZ';
  14:Result:='ZZ';
  15:Result:='ZZ';
  16:Result:='ZZ';
  17:Result:='NU';
 end;
end;


Function TSpecialGpT1_2026.ConvertDepRelationship(Valu:String):String;
Var n:Integer;
begin
 n:=MyStrToInt(AllTrim(Valu));
 Case n of
  0: Result:='NA';
  1: Result:='Son';
  2: Result:='Daughter';
  3: Result:='Parent';
  4: Result:='GrandParent';
  5: Result:='GrandChild';
  6: Result:='Brother';
  7: Result:='Sister';
 end;
end;

Function TSpecialGpT1_2026.FixMarStatus(Valu:String):Integer;
{returns the right elm for the X indicator}
Var n:Integer;
begin
 n:=MyStrToInt(AllTrim(Valu));
 Case n of
   1:  Result:=11;
   2:  Result:=12;
   3:  Result:=13;
   4:  Result:=16;
   5:  Result:=17;
   6:  Result:=18;
  end;  {case}
end;

Procedure TSpecialGpT1_2026.FixRefundLine(RetNo:Integer);
Var i:Integer;inst:String;FName:String;FNo:Integer;
begin
 FNo:=GetFormNo('YRSUM');
 For i:=744 to 747 do
 begin
  If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then
  begin
    StoreElm(RetNo,FNo,i-5,
      FormatFloat('###,###,###.00',ABS(Vl(FetchElmFNo(RetNo,FNo,i)))));
    StoreElm(RetNo,FNo,i,'')
  end;
 end;
end;

Procedure TSpecialGpT1_2026.FixBusStatements(RetNo:Integer);
Var i:Integer;inst:String;FName:String;FNo:Integer;
begin
 //T2125
 Try
 For i:=1 to ProfileClient1.FormCount['T2125']+1 do
 begin
  Inst:='#'+AllTrim(IntToStr(i));
  FName:='T2125'+Inst;
  FNo:=GetFormNo(FName);
  If FNo >0 then
  begin
    If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
    begin
     If Vl(FetchElmFNo(RetNo,FNo,23)) <> 0 then
     begin
       StoreElm(RetNo,FNo,23,''); //remove amount
       If FetchElmFNo(RetNo,FNo,8)='' then StoreElm(RetNo,FNo,8,'???');
     end;
{
     StoreElm(RetNo,FNo,19,LeftStr(FetchElmFNo(RetNo,FNo,19),5));
     StoreElm(RetNo,FNo,20,MidStr(FetchElmFNo(RetNo,FNo,20),6,4));
     If Length(FetchElmFNo(RetNo,FNo,21))=15 then
       StoreElm(RetNo,FNo,21,RightStr(FetchElmFNo(RetNo,FNo,21),6)) //i.e. rc0001
     else
       StoreElm(RetNo,FNo,21,'');
}
     Calc(RetNo,'T2125'+Inst);
    end;  //has data
  end; //Fno>0
 end;  //i
except
 //
end;

 //T2121
//ShowMessage('fixing T2121');
Try
 For i:=1 to ProfileClient1.FormCount['T2121']+1 do
 begin
  Inst:='#'+AllTrim(IntToStr(i));
  FName:='T2121'+Inst;
  FNo:=GetFormNo(FName);

  If FNo>0 then
  begin
    If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
    begin
     If Vl(FetchElmFNo(RetNo,FNo,20)) <> 0 then
     begin
       StoreElm(RetNo,FNo,20,''); //remove amount
       If FetchElmFNo(RetNo,FNo,61)='' then StoreElm(RetNo,FNo,61,'???');
     end;
     StoreElm(RetNo,FNo,15,LeftStr(FetchElmFNo(RetNo,FNo,15),5));
     StoreElm(RetNo,FNo,16,MidStr(FetchElmFNo(RetNo,FNo,16),6,4));
     If Length(FetchElmFNo(RetNo,FNo,17))=15 then
       StoreElm(RetNo,FNo,17,RightStr(FetchElmFNo(RetNo,FNo,17),6))
     else
       StoreElm(RetNo,FNo,17,'');
    end;
  end;  //Fno
 end;
except
 //
end;

 //T2042
 //ShowMessage('fixing T2042');
Try
 For i:=1 to ProfileClient1.FormCount['T2042']+1 do
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
       If FetchElmFNo(RetNo,FNo,8)='' then StoreElm(RetNo,FNo,8,'???');
     end;
     StoreElm(RetNo,FNo,21,LeftStr(FetchElmFNo(RetNo,FNo,21),5));
     StoreElm(RetNo,FNo,22,MidStr(FetchElmFNo(RetNo,FNo,22),6,4));
     If Length(FetchElmFNo(RetNo,FNo,23))=15 then
       StoreElm(RetNo,FNo,23,RightStr(FetchElmFNo(RetNo,FNo,23),6))
     else
       StoreElm(RetNo,FNo,23,'');
    
    end;
  end; //FNo
 end;
except
 //
end;

 //T776
 //ShowMessage('fixing T776');
Try
 For i:=1 to ProfileClient1.FormCount['T776']+1 do
 begin
  Inst:='#'+AllTrim(IntToStr(i));
  FName:='T776'+Inst;
  FNo:=GetFormNo(FName);
  If FNo >0 then
  begin
    If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
    begin
     If Vl(FetchElmFNo(RetNo,FNo,47)) <> 0 then
     begin
       StoreElm(RetNo,FNo,47,''); //remove amount
       If FetchElmFNo(RetNo,FNo,109)='' then StoreElm(RetNo,FNo,109,
       GetFirstName(RetNo)+' '+GetLastName(RetNo));
     end;

     If Vl(FetchElmFNo(RetNo,FNo,47)) <> 0 then StoreElm(RetNo,FNo,47,''); //remove amount
     If Vl(FetchElmFNo(RetNo,FNo,50)) <> 0 then StoreElm(RetNo,FNo,50,''); //remove amount
     If Vl(FetchElmFNo(RetNo,FNo,53)) <> 0 then StoreElm(RetNo,FNo,53,''); //remove amount
     StoreElm(RetNo,FNo,15,LeftStr(FetchElmFNo(RetNo,FNo,15),5));
     StoreElm(RetNo,FNo,16,MidStr(FetchElmFNo(RetNo,FNo,16),6,4));
     StoreElm(RetNo,FNo,17,RightStr(FetchElmFNo(RetNo,FNo,17),6));
    
    end;
  end; //FNo
 end; //i
except
 //
end;

end;

Procedure TSpecialGpT1_2026.SplitFldLists;
var i:integer;FullList:TStringList;
begin
 FullList:=TStringList.Create;
 FldList:=TStringList.Create;
 T2125List:=TStringList.Create;
 T2121List:=TStringList.Create;
 T2042List:=TStringList.Create;
 T776List:=TStringList.Create;


 T2125CCAList:=TStringList.Create;
 T2121CCAList:=TStringList.Create;
 T2042CCAList:=TStringList.Create;
 T776CCAList:=TStringList.Create;
 T1164CCAList:=TStringList.Create;

 FullList.LoadFromFile(AppDir+'\'+ FieldsFlName);
 For i:=0 to FullList.Count-1 do
 begin
  //normal statements
  If ((LeftStr(FullList[i],5) = 'T2125')
  and (LeftStr(FullList[i],13) <> 'T2125CCAClass')) then
     T2125List.Add(FullList[i])
  Else If ((LeftStr(FullList[i],5) = 'T2121')
  and (LeftStr(FullList[i],13) <> 'T2121CCAClass')) then
       T2121List.Add(FullList[i])
  Else If ((LeftStr(FullList[i],5) = 'T2042')
  and (LeftStr(FullList[i],13) <> 'T2042CCAClass')) then
     T2042List.Add(FullList[i])


  Else If ((LeftStr(FullList[i],4) = 'T776')
  and (LeftStr(FullList[i],12) <> 'T776CCAClass')) then
     T776List.Add(FullList[i])
  //now cca
  Else if LeftStr(FullList[i],13) = 'T2125CCAClass' then
     T2125CCAList.Add(FullList[i])
  Else if LeftStr(FullList[i],13) = 'T2121CCAClass' then
     T2121CCAList.Add(FullList[i])
  Else if LeftStr(FullList[i],13) = 'T2042CCAClass' then
     T2042CCAList.Add(FullList[i])
  Else if LeftStr(FullList[i],13) = 'T1164CCAClass' then
     T1164CCAList.Add(FullList[i])
  Else if LeftStr(FullList[i],12) = 'T776CCAClass' then
     T776CCAList.Add(FullList[i])
  else
     FldList.Add(FullList[i]);
 end;
 FullList.Free;
end;


Function TSpecialGpT1_2026.ConvertOne(GpFlName:String;ClientOrSpouse:String):Integer;
var k:Integer;s:String;GpSin:String;Percent:Real;
    FldName: String;
    x:Real;
    Item:Variant;
    OutList,TmpList:TStringList;
    i,j,ii,StmNo,VisualInst,VisualIncr,FCount,TableRows,MaxVisualRowsPerInst:Integer;
    ProfileFrmNm,VisualFrmNm,ProfileTableNm,VisualFldDescr,ProfileInstance:String;
begin
  If ClientOrSpouse ='C' then
    SpousePrefix:=''
  else
    SpousePrefix:='Spouse.';

  Result:=9;

  If ProfileExtensionBox.Text = '12T' then   //20130306
  begin
    ProfileFile1:={Profile_tlb.}CoT2012T1File.Create;
    If Psw.text>'' then ProfileFile1.FilePassword:=Psw.text;
  end


  else If ProfileExtensionBox.Text = '11T' then   //20120328
  begin
    ProfileFile1:={Profile_tlb.}CoT2011T1File.Create;     //use 8
    If Psw.text>'' then ProfileFile1.FilePassword:=Psw.text;
  end

  Else If ProfileExtensionBox.Text = '10T' then   //20110217
  begin
    ProfileFile1:={Profile_tlb.}CoT2010T1File.Create;     //use 8
    If Psw.text>'' then ProfileFile1.FilePassword:=Psw.text;
  end

  Else If ProfileExtensionBox.Text = '09T' then
  begin
    ProfileFile1:={Profile_tlb.}CoT2009T1File.Create;     //use 8
    If Psw.text>'' then ProfileFile1.FilePassword:=Psw.text;
  end

  Else If ProfileExtensionBox.Text = '08T' then
  begin
    ProfileFile1:={Profile_tlb.}CoT2008T1File.Create;
    If Psw.text>'' then ProfileFile1.FilePassword:=Psw.text;
  end

  Else If ProfileExtensionBox.Text = '07T' then
  begin
    ProfileFile1:={Profile_tlb.}CoT2007T1File.Create;
    If Psw.text>'' then ProfileFile1.FilePassword:=Psw.text;
  end

  else If ProfileExtensionBox.Text = '*' then
  begin
    //ShowMessage('Loading 2008 lib');
    ProfileFile1:={Profile_tlb.}CoT2008T1File.Create;
    If Psw.text>'' then ProfileFile1.FilePassword:=Psw.text;
  end
  else
  begin
   ShowMessage('Cannot roll-over this file');
   exit;
  end;

  //ProfileClient1 :=ProfileFile1.Client;

//  ShowMessage('Loading GpFlName='+GpFlName);
  ProfileFile1.LoadFile(GpFlName,True);
//  ShowMessage('Loaded GpFlName='+GpFlName);
  ProfileClient1 :=ProfileFile1.Client;
//  ShowMessage('Loaded Client1='+GpFlName);
  //this one can throw the Catastrophic exception
  if False then begin
    try
     ProfileClient1.Calculate;
    except
      on E: Exception do begin
        //Application.ShowException(E);
       ShowMessage('Calculate problem: '+E.Message);
      end;
    end;
  end;
//  ShowMessage('Calculated Client1='+GpFlName);
  (*
  // example
  If ClientOrSpouse='C' then
   ShowMessage('Birthdate='+GetValue('T1[5]'))
  else
   ShowMessage('Birthdate='+GetValue('Spouse.T1[5]'));
  *)

  OutList:=TStringList.Create;

  FldName:= 'T1Info.B[11]';   //prov
  k:=MyStrToInt(GetValue(FldName));
  FldName:='';
  Case k of
    1: FldName:='BCS11[16]'; //Result:='BC';
    2: FldName:='ABS11[16]'; //Result:='AB';
    3: FldName:='SKS11[16]'; //Result:='SK';
    4: FldName:='MBS11[16]'; //Result:='MB';
    5: FldName:='ONS11[16]'; //Result:='ON';
   //6: FldName:='BCS11[16]'; //Result:='QC';
    7: FldName:='NBS11[16]'; //Result:='NB';
    8: FldName:='NSS11[16]'; //Result:='NS';
    9: FldName:='PES11[16]'; //Result:='PE';
   10:FldName:='NLS11[16]'; //Result:='NF';
   11:FldName:='YTS11[16]'; //Result:='YT';
   12:FldName:='NTS11[16]'; //Result:='NT';
   13:FldName:='NUS11[16]'; //Result:='NU';
  end;

  FldList.add(Fldname+'=S11 Prv'+''+'S11PRV'+''+'13');

  For i:=0 to FldList.Count-1 do
  begin

   FldName:=GetProfileFldName(FldList[i],ClientOrSpouse);

   If (FldName>'') and (Not IsBusStatement(FldName)) then
   begin
    //ShowMessage(FldName);
    s:=GetValue(FldName);
    OutList.add(FldList[i]+''+S);
   end;
  end;

  //T2125
  //ShowMessage('T2125');
  TmpList:=TstringList.Create;
  FCount:=0;
  Try
   FCount:=ProfileClient1.FormCount['T2125'];  //no spousePrfix ob FormCount
   For StmNo:=0 to FCount-1 do
   begin
     //ShowMessage(ClientOrSpouse+ ' T2125 Stmt '+IntToStr(StmNo));
     If StmNo=0 then
     begin
      x:= Vl(GetValue('T2125['+'0'+',12]'));
      s:= GetValue('T2125.S['+'0'+',3]');
      Percent:=Vl(GetValue('T2125Owners['+'0,0,0'+']'));
     // ShowMessage(FormatFloat('###.##',Percent));
     end
     else
      begin
      x:= Vl(GetValue('T2125['+AllTrim(IntToStr(StmNo))+',12]'));
      s:= GetValue('T2125.S['+AllTrim(IntToStr(StmNo))+',5]');
      Percent:=Vl(GetValue('T2125Owners['+AllTrim(IntToStr(StmNo))+',0,0'+']'));
     // ShowMessage(FormatFloat('###.##',Percent));
     end;
    If {((X <> 0) or (s>'')) and} (Percent>0) then //sales><0 or bus name present
    begin
       ReplaceNdxWithStm(TmpList,'T2125',StmNo);  //modified temp list
       For i:=0 to TmpList.Count-1 do
       begin
         FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
         If FldName>'' then
         begin
          s:=GetValue(FldName);
          OutList.add(TmpList[i]+''+S);
         end;
       end; //i
    end; //applicable
   end; //stm
   Except
    //ShowMessage('T2125 failed');
   end;


  //T2125SUM  //20110217
  //  ShowMessage('T1125SUM');
  Fcount:=0;
  Try
  TmpList:=TstringList.Create;
  FCount:=ProfileClient1.FormCount['T21255year'];
// ShowMessage('Profile T2125SUM Fcount='+IntToStr(FCount));
  For StmNo:=0 to FCount-1 do
  begin
      ReplaceNdxWithStm(TmpList,'T2125SUM',StmNo);  //modified temp list
      For i:=0 to TmpList.Count-1 do
      begin
        FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
        If FldName>'' then
        begin
         s:=GetValue(FldName);
         OutList.add(TmpList[i]+''+S);
        end;
      end; //i
  end; //stm
  except
   // ShowMessage('Error in importing 5 year T2125 Summary');
  end;



  //T2121
  //If ClientOrSpouse='S' then ShowMessage('T2121');
   FCount:=0;
  Try
  TmpList:=TstringList.Create;
  FCount:=ProfileClient1.FormCount['T2121'];
//  If Vl(GetValue('T1[45]')) <=0 then FCount:=0;
  For StmNo:=0 to FCount-1 do
  begin
    If StmNo=0 then
    begin
     x:= Vl(GetValue('T2121['+'0'+',17]'));
     s:= GetValue('T2121.S['+'0'+',3]');
     Percent:=Vl(GetValue('T2121Owners['+'0,0,0'+']'));
    end
    else
     begin
     x:= Vl(GetValue('T2121['+AllTrim(IntToStr(StmNo))+',17]'));
     s:= GetValue('T2121.S['+AllTrim(IntToStr(StmNo))+',3]');
     Percent:=Vl(GetValue('T2121Owners['+AllTrim(IntToStr(StmNo))+',0,0'+']'));
    end;
    If {(X <> 0) or (s>'')} Percent>0 then //sales><0 or bus name present
    begin
      ReplaceNdxWithStm(TmpList,'T2121',StmNo);  //modified temp list
      For i:=0 to TmpList.Count-1 do
      begin
        FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
        If FldName>'' then
        begin
         //ShowMessage(IntToStr(StmNo)+' '+FldName);
         s:=GetValue(FldName);
         OutList.add(TmpList[i]+''+S);
        end;
      end; //i
    end; //applicable
  end; //stm
  except
  end;

   //T2042
  FCount:=0;
  Try
  TmpList:=TstringList.Create;
  FCount:=ProfileClient1.FormCount['T2042'];
  For StmNo:=0 to FCount-1 do
  begin
    If StmNo=0 then
    begin
     x:= Vl(GetValue('T2042['+'0'+',43]'));
     s:= GetValue('T2042.S['+'0'+',3]');
     Percent:=Vl(GetValue('T2042Owners['+'0,0,0'+']'));
    end
    else
     begin
     x:= Vl(GetValue('T2042['+AllTrim(IntToStr(StmNo))+',43]'));
     s:= GetValue('T2042.S['+AllTrim(IntToStr(StmNo))+',3]');
     Percent:=Vl(GetValue('T2042Owners['+AllTrim(IntToStr(StmNo))+',0,0'+']'));
    end;
    If {(X <> 0) or (s>'')} Percent>0 then //sales><0 or bus name present
    begin
      ReplaceNdxWithStm(TmpList,'T2042',StmNo);  //modified temp list
      For i:=0 to TmpList.Count-1 do
      begin
        FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
        If FldName>'' then
        begin
         s:=GetValue(FldName);
         OutList.add(TmpList[i]+''+S);
        end;
      end; //i
    end; //applicable
  end; //stm
  except
  end;



  //T776
  //If ClientOrSpouse='S' then ShowMessage('T776');
  FCount:=0;
  Try
  TmpList:=TstringList.Create;
  FCount:=ProfileClient1.FormCount['T776'];
  //ShowMessage('Rent cnt='+IntToStr(FCount));
 // If Vl(GetValue('T1[31]')) <=0 then FCount:=0;
  For StmNo:=0 to FCount-1 do
  begin
    If StmNo=0 then
    begin
     x:= Vl(GetValue('T776['+'0'+',31]'));
     Percent:=Vl(GetValue('T776Owners['+'0,0,0'+']'));
    end
    else
     begin
      x:= Vl(GetValue('T776['+AllTrim(IntToStr(StmNo))+',31]'));
      Percent:=Vl(GetValue('T776Owners['+AllTrim(IntToStr(StmNo))+',0,0'+']'));
     end;

    //ShowMessage('rent sin='+GetValue('T776Client.s[2,2]')+'info sin='+GetValue('T1Info.s[1]'));
    If {(X <> 0)} Percent>0 then
    begin
      ReplaceNdxWithStm(TmpList,'T776',StmNo);  //modified temp list
      For i:=0 to TmpList.Count-1 do
      begin
        FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
        If FldName>'' then
        begin
         s:=GetValue(FldName);
         OutList.add(TmpList[i]+''+S);
        end;
      end; //i
    end; //applicable
  end; //stm
  except
  end;

  //T2125CCA
  //If ClientOrSpouse='S' then ShowMessage('T2125CCA');
  FCount:=0;
  Try
  TmpList:=TstringList.Create;
  FCount:=ProfileClient1.FormCount['T2125CCA'];
 // If (Vl(GetValue('T1[37]')) <=0) and  (Vl(GetValue('T1[41]')) <=0) then FCount:=0;
  For StmNo:=0 to FCount-1 do
  begin
    If StmNo=0 then
    begin
     x:= Vl(GetValue('T2125['+'0'+',12]'));
     s:= GetValue('T2125.S['+'0'+',3]');
    end
    else
     begin
     x:= Vl(GetValue('T2125['+AllTrim(IntToStr(StmNo))+',12]'));
     s:= GetValue('T2125.S['+AllTrim(IntToStr(StmNo))+',5]');
    end;
    If (X <> 0) or (s>'') then //sales><0 or bus name present
    begin
      ReplaceNdxWithStm(TmpList,'T21254CCA',StmNo);  //modified temp list
      For i:=0 to TmpList.Count-1 do
      begin
        FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
        If FldName>'' then
        begin
         s:=GetValue(FldName);
         OutList.add(TmpList[i]+''+S);
        end;
      end; //i
    end; //applicable
  end; //stm
  except
  end;

  //T2121CCA
  //If ClientOrSpouse='S' then ShowMessage('T2121CCA');
  FCount:=0;
  Try
  TmpList:=TstringList.Create;
  FCount:=ProfileClient1.FormCount['T2121CCA'];
 // If Vl(GetValue('T1[45]')) <=0 then FCount:=0;
  For StmNo:=0 to FCount-1 do
  begin
    If StmNo=0 then
    begin
     x:= Vl(GetValue('T2121['+'0'+',17]'));
     s:= GetValue('T2121.S['+'0'+',3]');
    end
    else
     begin
     x:= Vl(GetValue('T2121['+AllTrim(IntToStr(StmNo))+',17]'));
     s:= GetValue('T2121.S['+AllTrim(IntToStr(StmNo))+',3]');
    end;
    If (X <> 0) or (s>'') then //sales><0 or bus name present
    begin
      ReplaceNdxWithStm(TmpList,'T2121CCA',StmNo);  //modified temp list
      For i:=0 to TmpList.Count-1 do
      begin
        FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
        If FldName>'' then
        begin
         s:=GetValue(FldName);
         OutList.add(TmpList[i]+''+S);
        end;
      end; //i
    end; //applicable
  end; //stm
  except
  end;

  //T2042CCA
  FCount:=0;
  Try
  FCount:=ProfileClient1.FormCount['T2042CCA'];
  TmpList:=TstringList.Create;
 // If Vl(GetValue('T1[43]')) <=0 then FCount:=0;
  For StmNo:=0 to FCount-1 do
  begin
    If StmNo=0 then
    begin
     x:= Vl(GetValue('T2042['+'0'+',43]'));
     s:= GetValue('T2042.S['+'0'+',3]');
    end
    else
     begin
     x:= Vl(GetValue('T2042['+AllTrim(IntToStr(StmNo))+',43]'));
     s:= GetValue('T2042.S['+AllTrim(IntToStr(StmNo))+',3]');
    end;
    If (X <> 0) or (s>'') then //sales><0 or bus name present
    begin
      ReplaceNdxWithStm(TmpList,'T2042CCA',StmNo);  //modified temp list
      For i:=0 to TmpList.Count-1 do
      begin
        FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
        If FldName>'' then
        begin
         s:=GetValue(FldName);
         OutList.add(TmpList[i]+''+S);
        end;
      end; //i
    end; //applicable
  end; //stm
  except
  end;

  //T776CCA
  //If ClientOrSpouse='S' then ShowMessage('T776CCA');
  FCount:=0;
  Try
  TmpList:=TstringList.Create;
  FCount:=ProfileClient1.FormCount['T776CCA'];
 // If Vl(GetValue('T1[31]')) <=0 then FCount:=0;
  For StmNo:=0 to FCount-1 do
  begin
    If StmNo=0 then
    begin
     x:= Vl(GetValue('T776['+'0'+',31]'));
    end
    else
     begin
     x:= Vl(GetValue('T776['+AllTrim(IntToStr(StmNo))+',31]'));
     end;

    If (X <> 0) or (s>'') then //sales><0 or bus name present
    begin
      ReplaceNdxWithStm(TmpList,'T776CCA',StmNo);  //modified temp list
      For i:=0 to TmpList.Count-1 do
      begin
        FldName:=GetProfileFldName(TmpList[i],ClientOrSpouse);
        If FldName>'' then
        begin
         s:=GetValue(FldName);
         OutList.add(TmpList[i]+''+S);
        end;
      end; //i
    end; //applicable
  end; //stm
  except
  end;



  //ShowMessage('convert one finished');

  ConvertedFlName:=GpFlName;
  ConvertedFlName := ExtractFileName(GpFlName);
  If ClientOrSpouse='S' then ConvertedFlName:='S-'+ConvertedFlName;
  ConvertedFlName := ChangeFileExt(ConvertedFlName,'.'+TempFlExtension);
  ConvertedFlName := TempDir+'\'+ConvertedFlName;

  //ShowMessage('save to '+ConvertedFlName);
  OutList.SaveToFile(ConvertedFlName);
  OutList.Free;
  Result:=0;
  //ShowMessage('Convertion finished='+ConvertedFlName);
end;

Procedure TSpecialGpT1_2026.ReplaceNdxWithStm(Var TmpList:TStringList;StmId:String;StmNo:Integer);
Var i:Integer;j,k:Integer;s,StmStr:String;
begin
 StmStr:=AllTrim(IntToStr(StmNo));
 If StmStr='' then StmStr:='0';
 TmpList.Clear;

 If StmId = 'T2125' then
 begin
   For i:=0 to T2125List.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T2125List[i]);
    If k>0 then
     s:=LeftStr(T2125List[i],k-1)+'['+StmStr+MidStr(T2125List[i],k+2,255)
    else
      s:=T2125List[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //t2125

 If StmId = 'T2121' then
 begin
   For i:=0 to T2121List.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T2121List[i]);
    If k>0 then
     s:=LeftStr(T2121List[i],k-1)+'['+StmStr+MidStr(T2121List[i],k+2,255)
    else
      s:=T2121List[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //T2121

 If StmId = 'T2042' then
 begin
   For i:=0 to T2042List.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T2042List[i]);
    If k>0 then
     s:=LeftStr(T2042List[i],k-1)+'['+StmStr+MidStr(T2042List[i],k+2,255)
    else
      s:=T2042List[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //T2042



 If StmId = 'T776' then
 begin
   For i:=0 to T776List.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T776List[i]);
    If k>0 then
     s:=LeftStr(T776List[i],k-1)+'['+StmStr+MidStr(T776List[i],k+2,255)
    else
      s:=T776List[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //t776

 If StmId = 'T2125CCA' then
 begin
   For i:=0 to T2125CCAList.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T2125CCAList[i]);
    If k>0 then
     s:=LeftStr(T2125CCAList[i],k-1)+'['+StmStr+MidStr(T2125CCAList[i],k+2,255)
    else
      s:=T2125CCAList[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //t2125CCA

 If StmId = 'T2121CCA' then
 begin
   For i:=0 to T2121CCAList.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T2121CCAList[i]);
    If k>0 then
     s:=LeftStr(T2121CCAList[i],k-1)+'['+StmStr+MidStr(T2121CCAList[i],k+2,255)
    else
      s:=T2121CCAList[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //T2121CCA

 If StmId = 'T2042CCA' then
 begin
   For i:=0 to T2042CCAList.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T2042CCAList[i]);
    If k>0 then
     s:=LeftStr(T2042CCAList[i],k-1)+'['+StmStr+MidStr(T2042CCAList[i],k+2,255)
    else
      s:=T2042CCAList[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //T2042CCA

{
 If StmId = 'T1164CCA' then
 begin
   For i:=0 to T1164CCAList.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T1164CCAList[i]);
    If k>0 then
     s:=LeftStr(T1164CCAList[i],k-1)+'['+StmStr+MidStr(T1164CCAList[i],k+2,255)
    else
      s:=T1164CCAList[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //t1164CCA
}
 If StmId = 'T776CCA' then
 begin
   For i:=0 to T776CCAList.count -1 do
   begin
    //profile fldname ndx
    k:=Pos('[x',T776CCAList[i]);
    If k>0 then
     s:=LeftStr(T776CCAList[i],k-1)+'['+StmStr+MidStr(T776CCAList[i],k+2,255)
    else
      s:=T776CCAList[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
     s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
   end;
 end; //T776CCA

end;

Function TSpecialGpT1_2026.IsBusStatement(FldName:String):Boolean;
begin
 result:=False;
 if (LeftStr(FldName,5)= 'T2125')
 or (LeftStr(FldName,5)= 'T2121')
 or (LeftStr(FldName,5)= 'T2042')
 or (LeftStr(FldName,4) = 'T776')

 or (LeftStr(FldName,12)= 'Spouse.T2125')
 or (LeftStr(FldName,12)= 'Spouse.T2121')
 or (LeftStr(FldName,12)= 'Spouse.T2042')
 or (LeftStr(FldName,11) = 'Spouse.T776')
 then result := True;

end;

procedure TSpecialGpT1_2026.BitBtn1Click(Sender: TObject);
begin
 ShowHelp('T1Help','Conversion_from_Profile');
{ Application.HelpFile :=AppDir+'\'+'T1Help.HLP';
 Application.HelpJump('Conversion_from_Profile');
 }
end;

Procedure TSpecialGpT1_2026.CheckDateFormat;
Var WinBootDir:String;
Begin
(*
 If (UpperCase(ShortDateFormat) <> 'MM/DD/YYYY')
 then
  ShowMessage('For best rollover of BirthDates etc. the Date format in the Windows'+
    Chr(13)+'Control Panel should be MM/DD/YYYY'
    +Chr(13)+'See Control Panel -> Regional Settings -> Customize -> Date -> Short Date Format');
 *)

 WinBootDir:=GetWinBootDir;
 If (UpperCase(GetWinIniString(WinBootDir+'\'+'Win.Ini','intl','sShortDate')) <> 'MM/DD/YYYY')
 then
  ShowMessage('For best rollover of BirthDates etc. the Date format in the Windows'+
    Chr(13)+'Control Panel should be MM/DD/YYYY.'
    +Chr(13)+'See Control Panel -> Regional Settings -> Customize -> Date -> Short Date Format');
end;


Procedure TSpecialGpT1_2026.FixNISASin(RetNo:Integer);
Var i,FNo:Integer;FName:String;
Begin
  FName:='T1163#1';
  FNo:=GetFormNo(FName);
  If FNo >0 then
  begin
    If Ret[RetNo].FormHasData['T1163#1'] then
    begin
    i:=634;
    Repeat  //remove blanks from sin
    If FetchElmFNo(RetNo,FNo,i)>'' then
      StoreElm(RetNo,FNo,i,RemoveChar(FetchElmFNo(RetNo,FNo,i),' '));
    Inc(i,5);
    until i>654;
    end;
  end;
end;

procedure TSpecialGpT1_2026.LinkToOptionsLblClick(Sender: TObject);
begin
 ExecuteForm(TOptionsFrmT1_2026);
 Close;
end;

procedure TSpecialGpT1_2026.GetHBPandLLP(RetNo:Integer);
Var FNo:Integer;FldName,s:String;
begin
   //HBP
     FNo:=GetFormNo('RRSP');
     If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);

     StoreElm(RetNo,FNo,81,
         FormatFloat('######0.00',
          Vl(GetValue('T1RRSPDeduction[56]'))
          +Vl(GetValue('T1RRSPDeduction[57]'))));
     //LLP
     FNo:=GetFormNo('RRSP');
     If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
     //with drawals

     StoreElm(RetNo,FNo,85,
         FormatFloat('######0.00',
          Vl(GetValue('T1RRSPDeduction[79]'))
          +Vl(GetValue('T1RRSPDeduction[80]'))));

 end;


procedure TSpecialGpT1_2026.StoreData(ConvertedFlName:String);
Var i,j,FNo,AssetFNo,Elm:Integer;FName,Valu:String;
ConvList,WList:TStringList;
begin
Try
 ConvList:=TStringList.Create;
 WList:=TStringList.Create;
 ConvList.LoadFromFile(ConvertedFlName);

 For i:=0 to ConvList.Count-1 do
 begin
  If AllTrim(ConvList[i])>'' then
  begin
    valu:='';
    FNo:=0;

    ParseWords(ConvList[i]+'','',WList);   {added a last delim in case no value}
    FName :=AllTrim(WList[1]);
    Elm   :=MyStrToInt(AllTrim(Wlist[2]));
    If WList.Count>=3 then
      Valu  :=AllTrim(WList[3])
    else
      Valu :='';

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
     Valu := FixValu(FName,Valu,FNo,Elm);
     StoreElm(RetNo,FNo,Elm,Valu);
    // If LeftStr(FName,5) <> 'YRSUM' then Calc(RetNo,FName); //bad!
     If Valu >'' then Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=True;
   end; {valu > ''}
  end; {alltrim of temp rec}
 end; {i}
 //20090128
      For i:=1 to 15 do
      begin
       AssetFNo:=GetFormNo('ASSETSB#'+AllTrim(IntToStr(i)));
       If AssetFNo>0 then InitFormData(RetNo,AssetFNo);
      end;
      StoreElm(RetNo,'ASSETSB#1',10,'N');
      SpCaptureCCALastYear(RetNo);
      PopulateAssets(RetNo);
except
      on E: Exception do MessageDlg(ConvList[i]+' '+
                    E.Message, mtError, [mbok], 0);
end; {Try}
end;



Procedure TSpecialGpT1_2026.SpCaptureCCALastYear(RetNo:Integer);
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

Procedure TSpecialGpT1_2026.FixT1163T1273(RetNo:Integer);
var
OldStmt, FInst:string;
i, FNo:integer;
begin
 //T1163 Convert to T1273 of T1163.B[0,30] is 1
 If Ret[RetNo].FormHasData['T1163#1'] then
 begin
  If GetValue('T1163.B[0,30]') = '1' then  //T1273
  begin  // move T1163 to T1273 and CCA etc.
   ClearForm(RetNo,'T1163#1');
   Ret[RetNo].FormHasData['T1163#1']:=False;

   ClearForm(RetNo,'T1175#1');
   Ret[RetNo].FormHasData['T1175#1']:=False;

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   FNo :=Frec.FormNo;
   If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
   begin
     //AssetsB
     if FRec.FormName = 'ASSETSB' then
     begin
       OldStmt:=FetchElmFNo(RetNo,FNo,215);
       //ShowMessage('Old stmt before checking T1175='+OldStmt);
       If OldStmt>'' then
       begin
        If LeftStr(OldStmt,5)='T1163' then
        begin
         ShowMessage('old link='+OldStmt);
         FInst:=AllTrim(MidStr(OldStmt,6,2));
         StoreElm(RetNo,FNo,215,'');
         Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
       end;

      //Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=True;
      Calc(RetNo,Frec.FormName);
     end;
  end; //Assets has data
 end; //i

  end;
 end;

 If Ret[RetNo].FormHasData['T1273#1'] then
 begin
  If GetValue('T1163.B[0,30]') = '0' then  //T1163 only
  begin
   ClearForm(RetNo,'T1273#1');
   Ret[RetNo].FormHasData['T1273#1']:=False;

   ClearForm(RetNo,'T1175H#1');
   Ret[RetNo].FormHasData['T1175H#1']:=False;

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   FNo :=Frec.FormNo;
   If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
   begin
     //AssetsB
     if FRec.FormName = 'ASSETSB' then
     begin
       OldStmt:=FetchElmFNo(RetNo,FNo,215);
       //ShowMessage('Old stmt before checking T1175='+OldStmt);
       If OldStmt>'' then
       begin
        If LeftStr(OldStmt,5)='T1273' then
        begin
         ShowMessage('old link='+OldStmt);
         FInst:=AllTrim(MidStr(OldStmt,6,2));
         StoreElm(RetNo,FNo,215,'');
         Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
        end;
       end;

      //Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=True;
      Calc(RetNo,Frec.FormName);
     end;
  end; //Assets has data
 end; //i

  end;
 end;
end;
end.
