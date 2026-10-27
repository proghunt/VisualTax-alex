unit T1_2026ImportGpT1;
{distribution
 ConvGp.EXE
 ConvGpT1.d
 VB6StKit.DLL  100K
 MSVbvM60.dll  1.3 meg
}


interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,ExtCtrls,DB,StdCtrls,Grids,DBGrids,DBCtrls,Menus,Buttons,
  FileCtrl,ShellApi,VclTee.TeeProcs,VclTee.TeEngine,VclTee.Chart,Mask,ComCtrls;

Const
 ThisPackage      = 'T1';
 TempFlExtension  = 'EXP';
 FieldsFlName     = 'ConvGpT1.d';
 DriverFlName     = 'Conv.d';
 ProfileExtension = '00T';
 TempDirName      = 'TempDir';


type
  TImportGpT1_2026 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    StartBtn: TBitBtn;
    LogBtn: TBitBtn;
    Label4: TLabel;
    Panel2: TPanel;
    ImportOneBtn: TBitBtn;
    ImportAllBtn: TBitBtn;
    ReplaceOptionBox: TRadioGroup;
    ExportedBtn: TBitBtn;
    FileListBox1: TFileListBox;
    Label5: TLabel;
    Label6: TLabel;
    OpenDialog1: TOpenDialog;
    Chart1: TChart;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Label7: TLabel;
    ToDirBox: TEdit;
    FromDirBox: TEdit;
    ProfileExtensionBox: TEdit;
    SelectDirBtn1: TBitBtn;
    SelectDirBtn2: TBitBtn;
    HelpBtn: TBitBtn;
    CancelBtn: TBitBtn;

    Function  FixMarStatus(Valu:String):Integer;
    Function  ConvertProvOfRes(Valu:String):String;
    Function  ConvertDepRelationship(Valu:String):String;
    Function  FixValu(FName,Valu:String;FNo,Elm:Integer):String;
    Procedure CallConversionProgram;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ImportAllBtnClick(Sender: TObject);
    procedure SaveIt(FlName:String);
    procedure StoreData(GpFlName:String);
    procedure ImportOne(GPFlName,Sin:String);
    procedure ImportAll;
    procedure ImportOneBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    Function  GetSinNo(GpFlName:String):String;
    procedure StartBtnClick(Sender: TObject);
    procedure LogBtnClick(Sender: TObject);
    procedure ExportedBtnClick(Sender: TObject);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure SelectDirBtn2Click(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);

  private
    { Private declarations }
  public
    RetNo : integer;
  end;

var
  ImportGpT1: TImportGpT1_2026;
  ConversionPgmName:String;

  FlName: string; //[60];
  Cnt   : integer;
  InitialRowCount :integer;


implementation

{$R *.DFM}

uses vtMulti,vtCommon,vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026Common,T1_2026Common2,T1_2026ChildWinNEW,T1_2026Calc,T1_2026DirOpt,
  vtTrimStr,vtShared;

procedure TImportGpT1_2026.FormCreate(Sender: TObject);
var i:Integer;TempDir:String;
begin
 ConversionPgmName:=AppDir+'\'+'CONVGP.EXE';

 ToDirBox.Text:=OptRec.Dir_Cur;
 ProfileExtensionBox.Text:=ProfileExtension;

 {remove it}
 FromDirBox.Text:= OptRec.Dir_LastYr;

 TempDir:=AppDir+'\'+ TempDirName;
 If DirectoryExists(TempDir) then
 else
  MkDir(TempDir);
end;

procedure TImportGpT1_2026.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TImportGpT1_2026.ImportAllBtnClick(Sender: TObject);
begin
 If RetInMem>0 then
 begin
  ShowMessage('Please close all returns first');
  exit;
 end;

 If FilelistBox1.Items.Count<=0 then
 begin
  ShowMessage('No files are available for inport');
  exit;
 end;

 if MessageDlg('Import all. Are you sure?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;

 Cnt:=0;
 ImportAll;
 ShowMessage('Import completed.'+Chr(13)+
    'Total returns imported= '+IntToStr(cnt)
    +Chr(13)+'You can now Exit and use Open from the Main Menu');
end;

procedure TImportGpT1_2026.ImportOneBtnClick(Sender: TObject);
Var Sin,GpFlName:String;
begin
  If FileListBox1.ItemIndex >-1 then
   GpflName := FileListBox1.Items[FileListBox1.ItemIndex]
  else
  begin
   GpFlName := '';
   ShowMessage('No file selected');
   Exit;
  end;

  Cnt:=0;
  Sin := GetSinNo(GpFlName);
  If Sin >'' then
  begin
   ImportOne(GpFlName,Sin);
   ShowMessage('Import completed.'+Chr(13)+
     'Total returns imported= '+IntTostr(cnt)
     +Chr(13)+'You can now Exit and use Open from the Main Menu');
  end
  else
   begin
    ShowMessage('Cannot determine SIN number. Failed');
    exit;
   end;
end;

procedure TImportGpT1_2026.ImportOne(GPFlName,Sin:String);
Var i,j,FNo: integer; Msg:string;
PrPStatus,EfStatus, Notes,LastYrDir:String;
begin
 If RetInMem>0 then
 begin
  ShowMessage('Please close all returns first');
  exit;
 end;

  FlName:=LeftStr(sin,8)+'.'+RightStr(sin,1);
  If FlName = '' then exit;
  RetNo:=CreateNewReturn;
  if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;
  
  Try
      Ret[RetNo].SourceDataDir := ToDirBox.Text; {fooli t}
      StoreData(GPFlName);

      If Vl(FetchElm(RetNo,'T776#1',47)) >0 then
      begin
       StoreElm(RetNo,'T776#1',47,'1');
       StoreElm(RetNo,'T776#1',56,'1');
      end;
      FNo:=GetFormNo('T776#2');
      If FNo>0 then
      Begin
       If Vl(FetchElm(RetNo,'T776#2',47)) >0 then
       begin
        StoreElm(RetNo,'T776#2',47,'1');
        StoreElm(RetNo,'T776#2',56,'1');
       end;
      end;
      CalcAll(RetNo);
      FNo :=GetFormNo('STATUS');
      For j:=8 to 10 do StoreElm(RetNo,FNo,j,'');
      For j:=18 to 30 do StoreElm(RetNo,FNo,j,'');
      For j:=16 to 16 do StoreElm(RetNo,FNo,j,'');
      For j:=14 to 14 do StoreElm(RetNo,FNo,j,'');
      For j:=31 to 31 do StoreElm(RetNo,FNo,j,'');
      For j:=11 to 11 do StoreElm(RetNo,FNo,j, User.UserName); //20170112 Igor
      For j:=12 to 12 do StoreElm(RetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
      {DateToStr(Date));}
      For j:=13 to 13 do StoreElm(RetNo,FNo,j,TimeToStr(Time));

      If FileExists(ToDirBox.Text+'\'+FlName) then
      begin
       if ReplaceOptionBox.ItemIndex=0 then SaveIt(FlName);
      end
      else {does not exist}
       SaveIt(FlName);
  except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
  If RetNo >0 then RemoveReturnFromMemory(RetNo);
  RetNo :=0; //RetINmem :=0;
  //SendMessage(MDIHandle,WM_PAINT,0,0);
end;


procedure TImportGpT1_2026.ImportAll;
Var i: integer; Sin,GpflName : string;
begin
 For i:=0 to FilelistBox1.Items.Count-1 do
 begin
  FileListBox1.ItemIndex:=0;
  GpflName := FileListBox1.Items[i];

  Sin := GetSinNo(GpFlName);
  If Sin >'' then
   ImportOne(GpFlName,Sin)
  else
    ShowMessage('Cannot determine SIN number for '+GpFlName+' skipped');
 end;
end;

procedure TImportGpT1_2026.SaveIt(FlName:String);
begin
 If not SaveReturn(RetNo,ToDirBox.Text,FlName,True,True) =0 then
   ShowMessage('Return cannot be saved')
 else
  Inc(Cnt);
end;

procedure TImportGpT1_2026.StoreData(GPFlName:String);
Var i,FNo,Elm:Integer;FName,Valu:String;
TempList,WList:TStringList;
begin
Try
 TempList:=TStringList.Create;
 WList:=TStringList.Create;
 TempList.LoadFromFile(FileListBox1.Directory+'\'+GPFlName);

 InitFormData(RetNo,GetFormNo('T1'));
 InitFormData(RetNo,GetFormNo('DEPEND'));
 InitFormData(RetNo,GetFormNo('CFR'));
 InitFormData(RetNo,GetFormNo('T1M#1'));
 InitFormData(RetNo,GetFormNo('RRSP'));
 InitFormData(RetNo,GetFormNo('DIRECT'));
 InitFormData(RetNo,GetFormNo('S3'));
 InitFormData(RetNo,GetFormNo('S11'));
 InitFormData(RetNo,GetFormNo('T2038'));
 InitFormData(RetNo,GetFormNo('T1229'));
 InitFormData(RetNo,GetFormNo('DON'));
 InitFormData(RetNo,GetFormNo('STATUS'));

 InitFormData(RetNo,GetFormNo('T1139#1'));

 InitFormData(RetNo,GetFormNo('T776#1'));

 For i:=0 to Templist.Count-1 do
 begin
  If AllTrim(TempList[i])>'' then
  begin
    valu:='';
    FNo:=0;
    Try
    ParseWords(TempList[i]+'','',WList);   {added a last delim in case no value}
    FName :=AllTrim(WList[1]);
    Elm   :=MyStrToInt(AllTrim(Wlist[2]));
    If WList.Count>=3 then
      Valu  :=AllTrim(WList[3])
    else
      Valu :='';
    except
       on E: Exception do MessageDlg(Templist[i]+' '+
                   E.Message, mtError, [mbok], 0);
    end;

    FNo:= GetFormNo(FName);
    If (FNo>0) then begin
     If (Ret[RetNo].Frm[Fno].Count = 0) then InitFormData(RetNo,FNo);
    end;

    If (FNo>0) and (Valu >'') then
    begin
     If (FName='T1') and (Elm=11) then
        begin Elm:=FixMarStatus(Valu);Valu:='X';end;


     Valu := FixValu(FName,Valu,FNo,Elm);
     Try
      If (LeftStr(FName,6) = 'T776')   {addresses in rental}
       and ((elm=45) or (Elm=48) or (elm=51)) then
      {nothing}
      else
       StoreElm(RetNo,FNo,Elm,Valu);
      If Length(FetchElm(RetNo,'T776#1',15))>5 then
            StoreElm(RetNo,'T776#1',15,LeftStr(Valu,5));
      If GetFormNo('T776#2')>0 //20101020
      then
      begin
       If Length(FetchElm(RetNo,'T776#2',15))>5 then StoreElm(RetNo,'T776#2',15,LeftStr(Valu,5));
      end;

     except
      on E: Exception do MessageDlg(Templist[i]+' '+ E.Message, mtError, [mbok], 0);
     end;
     Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=True;
   end; {valu > ''}
  end; {alltrim of temp rec}
 end; {i}
except
      on E: Exception do MessageDlg(Templist[i]+' '+
                    E.Message, mtError, [mbok], 0);
end; {Try}
end;

procedure TImportGpT1_2026.HelpBtnClick(Sender: TObject);
begin
  ShowHelp(AppT1_2026.ModuleHelpUpdFile,'Converting_from_Profile', True); //20160801 Igor
  {
  Application.HelpFile := AppDir+'\'+'T1UPDHLP.HLP';
  Application.HelpJump('Converting_from_Profile');
  }
end;

Function TImportGpT1_2026.GetSinNo(GpFlName:String):String;
Var i:Integer;Templist,WList:TStringList;
begin
 Result:='';
 TempList:=TStringList.Create;
 WList:=TStringList.Create;
 TempList.LoadFromFile(GpFlName);
 For i:=0 to Templist.Count-1 do
 begin
  If UpperCase(LeftStr(Templist[i],3)) = 'SIN' then
  begin
   ParseWords(TempList[i],'^',WList);
   Result:=RemoveChar(WList[3],' ');
   Break;
  end;
 end;
 TempList.Free;
 WList.Free;
end;

procedure TImportGpT1_2026.StartBtnClick(Sender: TObject);
Var i:integer;TempList,FieldsList:TStringList;TempDir:String;
begin
Try
 If Not DirectoryExists(FromDirBox.Text) then
 begin
  ShowMessage('From Directory '+FromDirBox.Text+' does not exist');
  exit;
 end;

 TempDir:=AppDir+'\'+ TempDirName;
 If DirectoryExists(TempDir) then
 (*
 begin
  {$I-}
   RmDir(TempDir);
   if IOResult <> 0 then
     ShowMessage('Please delete directory '+TempDir+' with the explorer first');
   exit;
 end;
 *)
 else
  MkDir(TempDir);

 TempList  :=TstringList.Create;
 FieldsList:=TstringList.Create;

 TempList:=TstringList.Create;
 TempList.Add('[General]');
 TempList.Add('Conversion='+ThisPackage);
 TempList.Add('FileExtension='+ProfileExtensionBox.Text);
 TempList.Add('Input='+FromDirBox.text);
 TempList.Add('Output='+TempDir);
 TempList.Add('OutputFileExtension='+TempFlExtension);

 FieldsList.LoadFromFile(AppDir+'\'+FieldsFlName);
 For i:=0 to FieldsList.count-1 do
 begin
  If UpperCase(LeftStr(FieldsList[i],3))='KEY' then
   TempList.Add('Key=ADEL')
  else
   TempList.Add(FieldsList[i]);
 end;
 TempList.SaveToFile(AppDir+'\'+DriverFlName);

 Templist.free;
 FieldsList.Free;

 Screen.Cursor:= crHourGlass;
 CallConversionProgram;
 Screen.Cursor:= crDefault;

 {following already in the fields file
 [Security]
 Key=
 SelectedFiles=
 ConvertedFiles=
 ReturnStatus=
 ReturnMessage=
 }
except
 on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
end; {try}

end;

Procedure TImportGpT1_2026.CallConversionProgram;
Var h : THandle; ClickedOK : Boolean;EFMethod:string;
     ZString : Array[0..80] of Char;
     PZString : Pchar;
begin
  PZString := StrPCopy(ZString,conversionPgmName);

  Screen.Cursor := crHourGlass;
  h := ShellExecute(Application.MainForm.Handle, Nil, PzString, Nil,
  Nil, SW_RESTORE);

  If H<=32 then
  Begin
   ShowMessage('Program cannot execute. Error Code = '+IntToStr(h)
   +Chr(13)+'Please exit the Visual T1 program and run it again');

   SomeCaption := 'Error codes';
   PopSomeFile(AppDir+'\'+'SHELLERR.D',SomeCaption);

  end;
  Screen.Cursor := crHourGlass;
  (*
  If H <= 32 then
  begin
  ShowMessage('Conversion failed');
  end;
  *)
  {
  If H > 32 then
  begin
    ShowMessage('Conversion done')
  end
  else
    ShowMessage('Conversion failed');
  }
end;

procedure TImportGpT1_2026.LogBtnClick(Sender: TObject);
Var s1,s2,TempDir:String;templist:Tstringlist;
begin
 TempDir:=AppDir+'\'+ TempDirName;
 {Screen.Cursor := crHourGlass;}
 FileListBox1.Directory :=TempDir;
 FileListBox1.Mask := '*.*'; {LTR;*.D;*.TPL';}
 FileListBox1.ItemIndex :=0;
 {Screen.Cursor := crDefault;}

If FileExists(AppDir+'\'+'CONV.LOG') then
 begin
  Memo1.lines.LoadFromFile(AppDir+'\'+'CONV.LOG');
  Templist:=TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'CONV.D');
  If TempList.Count>3 then
  begin
   Memo1.Lines.add(' ');
   Memo1.Lines.add(Templist[Templist.count-2]);
   Memo1.Lines.add(Templist[Templist.count-1]);
  end;
  Templist.Free;
 end
else
 ShowMessage('The file was not created yet');
end;

procedure TImportGpT1_2026.ExportedBtnClick(Sender: TObject);
Var fileName:String;
begin
 If FileListBox1.ItemIndex >-1 then
  FileName := FileListBox1.Items[FileListBox1.ItemIndex]
 else
  FileName := '';
 If FileName > '' then
 begin
  Memo1.Clear;
  Memo1.Lines.LoadFromFile(FileListBox1.Directory+'\'+FileName);
 end;
end;

procedure TImportGpT1_2026.SelectDirBtn1Click(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := SelectDir;
 If SelectedDir >'' then
  FromDirBox.Text := SelectedDir;
end;

procedure TImportGpT1_2026.SelectDirBtn2Click(Sender: TObject);
begin
  ExecuteForm(TDirOptT1_2026);
 ToDirBox.Text:=OptRec.Dir_Cur;
end;

procedure TImportGpT1_2026.FileListBox1DblClick(Sender: TObject);
begin
 ImportOneBtnClick(Sender);
end;

Function TImportGpT1_2026.FixValu(FName,Valu:String;FNo,Elm:Integer):String;
begin
 Result:=Valu;

 If FName='T1' then
 begin
  Case Elm of
   1: result:=GetLongPrv(ConvertProvOfRes(UpperCase(Valu)));
   14: result := UpperCase(Valu);
   9: result:=JulianDaysToBirthDate(Valu);  {birthdate}
   59: result:=JulianDaysToBirthDate(Valu);  {sp birthdate}
   23: If MyStrToInt(valu)=1 then result:='M' else Result:='F';
   3,4: result:=RemoveChar(Valu,' ');  {Sin}
   46: If AllTrim(valu)='1' then result := 'Y' else result:='N'; {efile}
   58: If AllTrim(valu)='1' then result := 'Y' else result:='N'; {represent}
   49: If Length(valu)=1 then result := '0'+Valu;  {NOA}
   43: If valu='1' then result := 'X' else result:=''; {elections}
   47: If valu='1' then result := '3' else result:='1';  {discounting}
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
  end;
 end;



 If LeftStr(FName,4)='T776' then
 begin
   Case Elm of
   3,6: begin
        Result:=JulianDaysToBirthDate(Valu);
        If Result='2001-01-00' then result:='2000-12-31';
        result:=IncrYear(Result);
        end;

   15: begin
           StoreElm(RetNo,FNo,15,LeftStr(Valu,5));
           StoreElm(RetNo,FNo,16,MidStr(Valu,6,4));
           StoreElm(RetNo,FNo,17,RightStr(Valu,6));
       end;
   45,48,51: {in one spot}
       StoreElm(RetNo,FNo,Elm,FetchElm(RetNo,FName,elm)+' '+Valu);
   end; {case}
 end;


end;

Function TImportGpT1_2026.ConvertProvOfRes(Valu:String):String;
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
  12:Result:='NW';
  13:Result:='NU';
  14:Result:='ZZ';
  15:Result:='ZZ';
  16:Result:='ZZ';
  17:Result:='ZZ';
 end;
end;


Function TImportGpT1_2026.ConvertDepRelationship(Valu:String):String;
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

Function TImportGpT1_2026.FixMarStatus(Valu:String):Integer;
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


end.
