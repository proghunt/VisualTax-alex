unit T1_2026rebuild;
//imported 07-17

//20130420  New unit to handle large volume > 1,800 returns and also speed
interface

{$IFDEF v2013}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, FileCtrl, Buttons, ExtCtrls,
  UDeclare,TrimStr,Common,Common2,UFeatures,DB;
{$ELSE}
uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls,DB,System.IOUtils; //20200921 Igor
{$ENDIF}

type
  TRebuildT1_2026 = class(TForm)
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    Panel3: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    DataDirBox: TEdit;
    Label1: TLabel;
    //20200921 Igor >>>
    FileNameFormat: TRadioGroup;
    cbRename: TCheckBox;
    //20200921 Igor <<<
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    Function GetBackUpNM:String;
    Procedure GetDcnList(Dir:String;var DcnList:TStringList);
    Procedure RestoreDcnNumbers(Dir:String;DcnList:TStringList);
//    Function  UpdateDB(RetNo: integer; DataDir: string;FlName:string{;TempList:TStringList}):Integer; //20160429 Igor
    Function FigureOutMarStatus(TempList:TStringList): Integer;
    procedure FormDestroy(Sender: TObject); //20170223 Igor
    procedure cbRenameClick(Sender: TObject); //20200921 Igor
  private
    RetNo:Integer;
  public
    { Public declarations }
  end;

var
  Rebuild: TRebuildT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Features,vtTrimStr,vtShared,vtDataBase, uADCompClient,
  vtFileStorage; //20160301 Igor

procedure TRebuildT1_2026.OKBtnClick(Sender: TObject);
var
  i, k: integer;
  PrpStatus, EFStatus: String[2];
  Notes: String[80];
  DcnList: TStringList;
//  TempList: TStringList; //20160429 Igor
  ClientName: String;
  RetNo: Integer; //20160429 Igor
  cFileName, cNewFileName: string; //20200921 Igor
begin
  If IsDataDirectoryGood(DataDirBox.Text) = False then exit;

  If Not DirectoryExists(DataDirBox.Text) then
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;
  //20160429 Igor
  if FileExists(IncludeTrailingBackslash(DataDirBox.Text)+ClientsTable_dbf) then
  Begin
    ShowMessage('The program does not allow a Re-build on a folder that contains '+
                'the a Clients.dbf data base and the old format of data'); //20160522 Igor
    DataDirBox.SetFocus;
    exit;
  End;

  DcnList:=TStringList.Create; //extract DCN numbers, otherwize they are lost
  If (FileExists(DataDirBox.Text+'\'+ClientsDbLite)) // 20150916 Igor
  and (FileExists(DataDirBox.Text+'\'+ClientsDbLite))// 20150916 Igor
  then
  begin
    GetDcnList(DataDirBox.Text,DcnList);
  end;


  // 20150909 Igor
  If FileExists(DataDirBox.Text+'\'+ClientsDbLite) then
  begin
    ListBox1.Items.add('Taking a back up of the current Database...');
    If CopyFile(DataDirBox.Text+'\'+ClientsDbLite,
       OptRec.BackupDir+'\'+ClientsDbLite+'-BackUp-'+GetBackUpNm+'.db') then
    begin
      ListBox1.Items.add('DB backed up as '+OptRec.BackupDir+'\'+ClientsTableLite+'Db-BackUp-'+GetBackUpNm+'.db');
      ListBox1.Refresh;
    end
    else
    Begin
      ListBox1.Items.add('Back up failed');
      ListBox1.Refresh;
      Exit;
    end;
    SysUtils.DeleteFile(DataDirBox.Text+'\'+ClientsDbLite);
  end;

  // 20150909
  {If FileExists(DataDirBox.Text+'\'+'Clients.MDX') then
  begin
   If CopyFile(DataDirBox.Text+'\'+'Clients.mdx',
     OptRec.BackupDir+'\'+'ClientsMdx-BackUp-'+GetBackUpNm+'.mdx') then
    begin
     ListBox1.Items.add('MDX backed up as '+OptRec.BackupDir+'\'+'ClientsMdx-BackUp-'+GetBackUpNm+'.mdx');
     ListBox1.Refresh;
    end
    else
    Begin
     ListBox1.Items.add('Back up of MDX failed');
     ListBox1.Refresh;
     Exit;
   end;
   SysUtils.DeleteFile(DataDirBox.Text+'\'+'Clients.MDX');
  end;}

 // 20150909 Igor
  //20200914 Igor >>>
  If CopyFile(Appdir+'\'+ClientsDbLite, DataDirBox.Text+'\'+ClientsDbLite) then
  begin
    UpdateDbStructure;
    ListBox1.Items.add('The new '+ClientsDbLite+' was initialized');
  end
  //20200914 Igor <<<
  else
  begin
    ListBox1.Items.add('The new '+ClientsDbLite+' was not initialized properly');
    ListBox1.Refresh;
    Exit;
  end;

  // 20150909
 {If CopyFile(Appdir+'\'+'Clients.MDX', DataDirBox.Text+'\'+'Clients.MDX') then
    ListBox1.Items.add('The new Clients.MDX was initialized')
 else
 begin
    ListBox1.Items.add('The new Clients.MDX was not initialized properly');
    ListBox1.Refresh;
    Exit;
 end;}

  OKbtn.Enabled:=False; CancelBtn.Enabled:=False;
  ListBox1.Items.add(' ');
  ListBox1.Items.add('Rebuilding the new data base...');
  ListBox1.Refresh;
  //InitFormsTable;  //20130420
//  TempList:=TStringList.Create;  //20130420 //20160429 Igor
  for i:=0 to FileListBox1.Items.Count -1 do
  begin
    RetNo := -1; //20160522 Igor
    FileListBox1.ItemIndex :=i;
    FileListBox1.Refresh;
    //  RetNo:=InitNewReturn;
    If (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite))              //20150909 Igor
        and(UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite) + '-JOURNAL') //20150909 Igor
        and (UpperCase(FileListBox1.Items[i]) <> 'DBDWORK.INI')
    then
      try
        If FileExists(DataDirBox.Text+'\'+FileListBox1.Items[i]) then
        Begin
          try
            RetNo:=ReadReturn(DataDirBox.Text,FileListBox1.Items[i]);
          except
          end;
          if RetNo < 1 then
          Begin
            ShowMessage('Cannot READ '+FileListBox1.Items[i]);
            continue;
          End;
          ///////////////
          ClientName:=FetchElm(RetNo,'INFO',5)+', '+FetchElm(RetNo,'INFO',2);
          Label7.Caption := '#'+IntToStr(i+1)+ ' '+ClientName;
          Label7.Refresh;

          PrpStatus :=FetchElm(RetNo,'STATUS',4);
          If (PrpStatus='') Or (Not Numeric(PrpStatus)) then PrpStatus :='00';  //20131130
          EFStatus  :=FetchElm(RetNo,'STATUS',15);
          If (EFStatus='') Or (Not Numeric(EFStatus)) then EFStatus :='00';  //20131130
          Notes     := FetchElm(RetNo,'STATUS',14);
          //20200921 Igor >>>
          cFileName := FileListBox1.Items[i];
          if cbRename.Checked then
          begin
            cNewFileName := GenerateReturnFileName(RetNo, IntToStr(FileNameFormat.ItemIndex));
            if not SameText(cNewFileName, cFileName) then
            begin
              if FileExists(TPath.Combine(DataDirBox.Text,cNewFileName)) then
                ListBox1.Items.Add('Cannot rename file '+ FileListBox1.Items[i] +' to '+ cNewFileName +
                                   ' because there is a file with this name in '+ DataDirBox.Text)
              else
              begin
                RenameFile(TPath.Combine(DataDirBox.Text,cFileName), TPath.Combine(DataDirBox.Text,cNewFileName));
                cFileName := cNewFileName;
              end;
            end;
          end;
          UpdateClientsTable(RetNo,DataDirBox.Text,cFileName);//20160429 Igor
          //20200921 Igor <<<
//          UpdateDb(RetNo,DataDirBox.Text,FileListBox1.Items[i]{,TempList}); //20160429 Igor
          ///////////////
//          TFileStorage.LoadToStringList(DataDirBox.Text+'\'+FileListBox1.Items[i],TempList); //20160301 Igor
//  //         TempList.LoadFromFile(DataDirBox.Text+'\'+FileListBox1.Items[i]); //20160301 Igor
//          If LeftStr(TempList[0],2)='T1' then
//          Begin
//            ClientName:=GetValueFromDisk(RetNo,'INFO',5,TempList)+', '+GetValueFromDisk(RetNo,'INFO',2,TempList);
//            Label7.Caption := '#'+IntToStr(i+1)+ ' '+ClientName;
//            Label7.Refresh;
//
//            PrpStatus :=GetValueFromDisk(RetNo,'STATUS',4,TempList);
//            If (PrpStatus='') Or (Not Numeric(PrpStatus)) then PrpStatus :='00';  //20131130
//            EFStatus  :=GetValueFromDisk(RetNo,'STATUS',15,TempList);
//            If (EFStatus='') Or (Not Numeric(EFStatus)) then EFStatus :='00';  //20131130
//            Notes     := GetValueFromDisk(RetNo,'STATUS',14,TempList);
//            UpdateDb(RetNo,DataDirBox.Text,FileListBox1.Items[i],TempList);
//          end;
          RemoveReturnFromMemory(RetNo);
        end
        Else
        Begin
          ListBox1.Items.Add('Cannot process file '+ FileListBox1.Items[i]);
          ShowMessage('Cannot process file '+ FileListBox1.Items[i]);
        End;
      except
        ShowMessage('Failed on file: '+ClientName+' '+DataDirBox.Text+'\'+FileListBox1.Items[i]);
      end;

//    TempList.Clear; //20160429 Igor
    // If RetNo >0 then  RemoveReturnFromMemory(RetNo);
    // RetNo :=0; RetINmem :=0;
  end; //i
  RestoreDCNNumbers(DataDirBox.Text,DcnList);
  ListBox1.Items.add('Efile DCN numbers restored');
  ListBox1.Items.add(' ');
  ListBox1.Items.add('Data Base rebuild successfully');
  ListBox1.Refresh;
  ShowMessage('Client Data Base has been rebuilt');
  DcnList.Free;
//  TempList.Free; //20160429 Igor
  OKbtn.Enabled:=True;
  CancelBtn.Enabled:=True;
  Close;
end;

procedure TRebuildT1_2026.FormCreate(Sender: TObject);
begin
 Screen.Cursor := crHourGlass;
 DataDirBox.Text := OptRec.Dir_Cur;
 DrawList;
 Screen.Cursor := crDefault;
 FileNameFormat.ItemIndex := StrToIntDef(OptRec.FileNameFormat, 0); //20200921 Igor

end;

procedure TRebuildT1_2026.FormDestroy(Sender: TObject);//20170223 Igor
begin
  SetCurrentDir(ExtractFileDir(Application.exeName));
end;

procedure TRebuildT1_2026.FormPaint(Sender: TObject);
begin
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList;
 end;
end;

procedure TRebuildT1_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TRebuildT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TRebuildT1_2026.cbRenameClick(Sender: TObject); //20200921 Igor
begin
  FileNameFormat.Enabled := cbRename.Checked;
end;

procedure TRebuildT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
Rebuild.Invalidate; {DrawList;}
end;


Function TRebuildT1_2026.GetBackUpNM:String;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec,SMSec : string[2];
 Syyyy:String[4];
begin
   DecodeDate(Now,YYYY,MM,DD);
   DecodeTime(Now,Hour,Min,Sec,Msec);
   Syyyy:=AllTrim(IntToStr(YYYY));
   SMM   := LTrim(RTrim(IntToStr(MM)));
   SDD   := Ltrim(Rtrim(IntToStr(dd)));
   SMIN  := Ltrim(Rtrim(IntToStr(Min)));
   SSec   := AllTrim(IntToStr(Sec));
   SMSec:=LTrim(RTrim(IntToStr(MSec)));
   If Length(SMM)   =1 then SMM   := '0'+SMM;
   If Length(SDD)   =1 then SDD   := '0'+Sdd;
   If Length(SMIN)  =1 then SMin  := '0'+SMin;
   If Length(SSec)  =1 then SSec  := '0'+SSec;
   If Length(SMSec) =1 then SMSec:= '0'+SMSec;
   Result:=syyyy+smm+Sdd+SMin+SMSec;
end;

Procedure TRebuildT1_2026.GetDcnList(Dir:String;var DcnList:TStringList);
Var i:Integer;
  FDConnection: TADConnection;//20150909
  Table1: TADTable;           //20150909
begin
  DcnList.clear;

  //20150909 Igor
  FDConnection:= TADConnection.Create(Application);
  Table1:= TADTable.Create(Application);
  SetTableName(FDConnection, Table1, Dir + '\' + ClientsDbLite, ClientsTableLite, '');

  Table1.First;
  while not Table1.EOF do
  begin
   If UpperCase(Table1.FieldByName('DCN_No').AsString) >''  then
   begin
    DcnList.Add(PaddR(Table1.FieldByName('DCN_No').AsString,15)
      +Table1.FieldByName('File_Name').AsString);
   end;
   Table1.Next;
  end;
  DcnList.SaveToFile(AppDir+'\'+'TempDcn.txt');

  Table1.Close;
  Table1.Free;
  FDConnection.Free;
end;

Procedure TRebuildT1_2026.RestoreDcnNumbers(Dir:String;DcnList:TStringList);
Var i:Integer;DcnNo:String;FlName:String;
    FDConnection: TADConnection;//20150909
    Table1: TADTable;           //20150909
begin
  //20150909 Igor
  FDConnection:= TADConnection.Create(Application);
  Table1:= TADTable.Create(Application);
  SetTableName(FDConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDbLite
             , ClientsTableLite, 'File_Name');

  For i:=0 to DcnList.count-1 do
  begin
   DcnNo:=AllTrim(LeftStr(DcnList[i],15));
   FlName:=AllTrim(MidStr(DcnList[i],16,50));
   //20170223 Igor >>>
   //if Table1.FindKey([FlName]) then
   if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
   //20170223 igor <<<
   Begin
    Table1.Edit;
    Table1.FieldByName('Dcn_no').AsString:=DcnNo;
   end;
  end;
  //DcnList.Free;
  Table1.Close;
  Table1.Free;
  FDConnection.Free;
end;

//Function TRebuildT1_2026.UpdateDB(RetNo: integer; DataDir: string;
//  FlName: string{;TempList:TStringList}):Integer; //20160429 Igor
//{input parms are taken from Save As.. screen}
//Var
//  FNo :Integer;
//  FDConnection: TADConnection;//20150909
//  Table1: TADTable;           //20150909
//begin
//  (*
//  FNo :=GetFormNo('STATUS'); {to preserve status data}
//  If ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
//  *)
//
//  {Update Data Base}
//
//  //20150909 Igor
//  FDConnection:= TADConnection.Create(Application);
//  Table1:= TADTable.Create(Application);
//
//  if SetTableName(FDConnection, Table1, DataDir + '\' + ClientsDbLite
//                , ClientsTableLite, 'FILE_NAME') //20150909 Igor
//  then begin
//    TRY     //20090301
//     if Table1.FindKey([FlName]) then Table1.edit else Table1.Insert;
//
//     Table1.FieldByName('Last_Name').AsString :=UpperCase(Uppercase(GetLastName(RetNo)));
//       //does not help +','+Table1.FieldByName('First_Name').AsString;
//     Table1.FieldByName('First_Name').AsString := GetFirstName(RetNo); //20160429 Igor
//     Table1.FieldByName('File_Name').AsString := UpperCase(FlName);
//
//     Table1.FieldByName('MarStatus').AsInteger := ret[RetNo].MarStatus;
//
//     Table1.FieldByName('BirthDate').AsString := FetchElm(RetNo,'INFO',9);
//     Table1.FieldByName('SIN').AsString := FetchElm(RetNo,'INFO',3);
//
//     Table1.FieldByName('Pay_InvNo').AsString := FetchElm(RetNo,'INVOICE',210);
//
//     Table1.FieldByName('Pay_Type').AsString := '';
//     If FetchElm(RetNo,'INVOICE',223) > '' then
//        Table1.FieldByName('Pay_Type').AsString := 'Cash'
//     else If FetchElm(RetNo,'INVOICE',224) > '' then
//           Table1.FieldByName('Pay_Type').AsString := 'Cheque'
//     else If FetchElm(RetNo,'INVOICE',225) > '' then
//           Table1.FieldByName('Pay_Type').AsString := 'Visa'
//     else If FetchElm(RetNo,'INVOICE',271) > '' then
//           Table1.FieldByName('Pay_Type').AsString := 'Charge'
//     else If FetchElm(RetNo,'INVOICE',282) > '' then
//           Table1.FieldByName('Pay_Type').AsString := 'Debit';
//
//     Table1.FieldByName('Inv_Amount').AsFloat :=
//       vl(FetchElm(RetNo,'INVOICE',222));
//
//     If (FetchElm(RetNo,'INVOICE',223) > '') or
//      (FetchElm(RetNo,'INVOICE',224) > '') or
//     (FetchElm(RetNo,'INVOICE',225) > '')  then
//     Table1.FieldByName('Pay_Amount').AsFloat :=
//       vl(FetchElm(RetNo,'INVOICE',222))
//     Else
//      Table1.FieldByName('Pay_Amount').AsFloat := 0;
//     Table1.FieldByName('Street').AsString := FetchElm(RetNo,'INFO',6);
//     Table1.FieldByName('Apartment').AsString := FetchElm(RetNo,'INFO',22);
//     Table1.FieldByName('City').AsString := FetchElm(RetNo,'INFO',10);
//     Table1.FieldByName('Province').AsString := FetchElm(RetNo,'INFO',14); {from long to short}
//       {GetShortPrv(FetchElm(RetNo,'INFO',14));} {from long to short}
//
//     Table1.FieldByName('Postal').AsString := FetchElm(RetNo,'INFO',15);
//     Table1.FieldByName('Area').AsString := FetchElm(RetNo,'T1',441);  //GetAreaCode(RetNo);
//     Table1.FieldByName('Phone').AsString := FetchElm(RetNo,'T1',442); //GetPhoneNo(RetNo);
//     Table1.FieldByName('Fax').AsString := FetchElm(RetNo,'INFO',63); //GetFaxNo(RetNo);
//     //try    20090301
//     Table1.FieldByName('Updated_by').AsString := FetchElm(RetNo,'STATUS',11);
//     Table1.FieldByName('Updated_dt').AsString := FetchElm(RetNo,'STATUS',12);
//     Table1.FieldByName('Updated_tm').AsString := FetchElm(RetNo,'STATUS',13);
//
//     Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
//     Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
//     Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);
//     Table1.FieldByName('Pay_Dt').AsString := FetchElm(RetNo,'INVOICE',209);
//
//     Table1.FieldByName('PRP_Status').AsString := FetchElm(RetNo,'STATUS',4);
//     If AllTrim(Table1.FieldByName('PRP_Status').AsString)='' then Table1.FieldByName('PRP_Status').AsString:='01'; //20131130
//
//     Table1.FieldByName('EF_Status').AsString  := FetchElm(RetNo,'STATUS',15);
//     If AllTrim(Table1.FieldByName('EF_Status').AsString)='' then Table1.FieldByName('EF_Status').AsString:='00';  //20131130
//
//     Table1.FieldByName('CATEGORY').AsString  := FetchElm(RetNo,'STATUS',33);
//
//     Table1.FieldByName('RTUSENT_by').AsString := FetchElm(RetNo,'STATUS',18);
//     Table1.FieldByName('RTUSENT_Dt').AsString := FetchElm(RetNo,'STATUS',19);
//     Table1.FieldByName('RTUSENT_Tm').AsString := FetchElm(RetNo,'STATUS',20);
//
//     Table1.FieldByName('ACKRCVD_by').AsString := FetchElm(RetNo,'STATUS',21);
//     Table1.FieldByName('ACKRCVD_Dt').AsString := FetchElm(RetNo,'STATUS',22);
//     Table1.FieldByName('ACKRCVD_Tm').AsString := FetchElm(RetNo,'STATUS',23);
//
//     Table1.FieldByName('Notes').AsString := FetchElm(RetNo,'STATUS',14);
//     If FetchElm(RetNo,'INFO',102) > '' then
//      Table1.FieldByName('Discounted').AsString := 'Y'
//     else
//       Table1.FieldByName('Discounted').AsString := 'N';
//
//     Table1.FieldByName('FAMILYHEAD').AsString := FetchElm(RetNo,'INFO',37);
//     Table1.FieldByName('Due_Dt').AsString := FetchElm(RetNo,'INFO',124);
//     Table1.FieldByName('CLIENT_ID').AsString := FetchElm(RetNo,'INFO',67);
//     Table1.FieldByName('TITLE').AsString := FetchElm(RetNo,'INFO',33);
//     Table1.FieldByName('EMAIL').AsString := FetchElm(RetNo,'INFO',64);
//     Table1.FieldByName('TAXPROV').AsString := FetchElm(RetNo,'INFO',1);
//
//
//     If FetchElm(RetNo,'INFO',108) = 'F' then
//       Table1.FieldByName('GENDER').AsString := 'F'
//     else
//       Table1.FieldByName('GENDER').AsString := 'M';
//
//     Table1.FieldByName('FAXAREA').AsString := FetchElm(RetNo,'INFO',62);
//
//     Table1.FieldByName('Created_dt').AsString := FetchElm(RetNo,'STATUS',6);
//     Table1.FieldByName('Created_by').AsString := FetchElm(RetNo,'STATUS',5);
//     Table1.FieldByName('Created_tm').AsString := FetchElm(RetNo,'STATUS',7);
//     If AllTrim(Table1.FieldByName('Created_By').AsString)='' then
//       Table1.FieldByName('Created_by').AsString:=Table1.FieldByName('Updated_by').AsString;
//     If AllTrim(Table1.FieldByName('Created_dt').AsString)='' then
//       Table1.FieldByName('Created_dt').AsString:=Table1.FieldByName('Updated_Dt').AsString;
//     If AllTrim(Table1.FieldByName('Created_Tm').AsString)='' then
//       Table1.FieldByName('Created_Tm').AsString:=Table1.FieldByName('Updated_Tm').AsString;
//
//     Table1.Post;
//     except
//       on E: Exception do MessageDlg('Save failed '+E.Message, mtError, [mbok], 0);
//     end;
//   end;
//   Table1.Close;
//   Table1.Free;
//   FDConnection.Free;
//   Result := 0;
//end;


Function TRebuildT1_2026.FigureOutMarStatus(TempList:TStringList): Integer;
Var i : integer;
Begin
 Result := 6; {single}
 For i := 11 to 13 do
  If GetValueFromDisk(RetNo,'INFO',i,TempList)> ''  //FetchElm(RetNo,'INFO',i) > ''
   then result := i - 10;
 For i := 16 to 18 do
  If GetValueFromDisk(RetNo,'INFO',i,TempList)> ''  //FetchElm(RetNo,'INFO',i) > ''
  then result := i -15 + 3;
end;

end.
