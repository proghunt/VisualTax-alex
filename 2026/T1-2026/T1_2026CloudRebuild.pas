unit T1_2026CloudRebuild;
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
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls,DB, System.IOUtils;
{$ENDIF}

type
  TCloudRebuildT1_2026 = class(TForm)
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    Panel3: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    DataDirBox: TEdit;
    Label1: TLabel;
    lbFiles: TListBox;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    Function GetBackUpNM:String;
    Procedure GetDcnList(Dir:String;var DcnList:TStringList);
    Procedure RestoreDcnNumbers(Dir:String;DcnList:TStringList);
    Function FigureOutMarStatus(TempList:TStringList): Integer;
    procedure FormShow(Sender: TObject);
  private
    RetNo:Integer;
    FCloudId: integer;
    procedure FillList;
    procedure SetCloudId(const Value: integer);
  public
    ClientId: string;
    CloudPath: string;
    Token: string;
    property CloudId: integer read FCloudId write SetCloudId;
    { Public declarations }
  end;

var
  CloudRebuild: TCloudRebuildT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Features,vtTrimStr,vtShared,vtDataBase, uADCompClient,
  vtFileStorage, vtHelperManager, vtMulti;

procedure TCloudRebuildT1_2026.OKBtnClick(Sender: TObject);
var
  i, k: integer;
  PrpStatus, EFStatus: String[2];
  Notes: String[80];
  DcnList: TStringList;
  ClientName: String;
  RetNo: Integer; //20160429 Igor
begin
  If IsDataDirectoryGood(OptRec.Dir_Cur) = False then exit;

  If Not DirectoryExists(OptRec.Dir_Cur) then
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;

  DcnList:=TStringList.Create; //extract DCN numbers, otherwize they are lost
  If (FileExists(OptRec.Dir_Cur+'\'+ClientsDbLite))
  and (FileExists(OptRec.Dir_Cur+'\'+ClientsDbLite))
  then
  begin
    GetDcnList(OptRec.Dir_Cur,DcnList);
  end;

  If FileExists(OptRec.Dir_Cur+'\'+ClientsDbLite) then
  begin
    ListBox1.Items.add('Taking a back up of the current Database...');
    If CopyFile(OptRec.Dir_Cur+'\'+ClientsDbLite,
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
    SysUtils.DeleteFile(OptRec.Dir_Cur+'\'+ClientsDbLite);
  end;

 // 20150909 Igor
  If CopyFile(ExeDir + '\' + AppT1_2026.AppId +'\'+ClientsDbLite, OptRec.Dir_Cur+'\'+ClientsDbLite) then
    ListBox1.Items.add('The new '+ClientsDbLite+' was initialized')
  else
  begin
    ListBox1.Items.add('The new '+ClientsDbLite+' was not initialized properly');
    ListBox1.Refresh;
    Exit;
  end;


  OKbtn.Enabled:=False; CancelBtn.Enabled:=False;
  ListBox1.Items.add(' ');
  ListBox1.Items.add('Rebuilding the new data base...');
  ListBox1.Refresh;
  for i:=0 to lbFiles.Items.Count -1 do
  begin
    RetNo := -1;
    lbFiles.ItemIndex :=i;
    lbFiles.Refresh;
    If (UpperCase(lbFiles.Items[i]) <> UpperCase(ClientsDBLite))
        and(UpperCase(lbFiles.Items[i]) <> UpperCase(ClientsDBLite) + '-JOURNAL')
        and (UpperCase(lbFiles.Items[i]) <> 'DBDWORK.INI')
    then
      try
        HelperManager.Get(CloudID, IncludeTrailingPathDelimiter(optRec.Dir_Cur)+lbFiles.Items[i],
            CloudPath, lbFiles.Items[i], ClientID, Token);
        If FileExists(OptRec.Dir_Cur+'\'+lbFiles.Items[i]) then
        Begin
          try
            RetNo:=ReadReturn(OptRec.Dir_Cur,lbFiles.Items[i]);
          except
          end;
          if RetNo < 1 then
          Begin
            ShowMessage('Cannot READ '+lbFiles.Items[i]);
            continue;
          End;

          ClientName:=FetchElm(RetNo,'INFO',5)+', '+FetchElm(RetNo,'INFO',2);
          Label7.Caption := '#'+IntToStr(i+1)+ ' '+ClientName;
          Label7.Refresh;

          PrpStatus :=FetchElm(RetNo,'STATUS',4);
          If (PrpStatus='') Or (Not Numeric(PrpStatus)) then PrpStatus :='00';
          EFStatus  :=FetchElm(RetNo,'STATUS',15);
          If (EFStatus='') Or (Not Numeric(EFStatus)) then EFStatus :='00';
          Notes     := FetchElm(RetNo,'STATUS',14);
          UpdateClientsTable(RetNo,OptRec.Dir_Cur, RetList[RetNo].GetDefaultFileName);
          if FileExists(TPath.Combine(OptRec.Dir_Cur, RetList[RetNo].GetDefaultFileName)) then
            DeleteFile(PChar(TPath.Combine(OptRec.Dir_Cur, RetList[RetNo].GetDefaultFileName)));
          if not CheckIsCloud(True) then
            SaveReturn(RetNo, OptRec.Dir_Cur, RetList[RetNo].GetDefaultFileName, False, True);
          RemoveReturnFromMemory(RetNo);
          DeleteFile(PChar(OptRec.Dir_Cur + '\' + lbFiles.Items[i]));
        end
        Else
        Begin
          ListBox1.Items.Add('Cannot process file '+ lbFiles.Items[i]);
          ShowMessage('Cannot process file '+ lbFiles.Items[i]);
        End;
      except
        ShowMessage('Failed on file: '+ClientName+' '+OptRec.Dir_Cur+'\'+lbFiles.Items[i]);
      end;
  end;
  RestoreDCNNumbers(OptRec.Dir_Cur,DcnList);
  ListBox1.Items.add('Efile DCN numbers restored');
  ListBox1.Items.add(' ');
  ListBox1.Items.add('Data Base rebuild successfully');
  ListBox1.Refresh;
  ShowMessage('Client Data Base has been rebuilt');
  DcnList.Free;
  OKbtn.Enabled:=True;
  CancelBtn.Enabled:=True;
  Close;
end;

procedure TCloudRebuildT1_2026.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TCloudRebuildT1_2026.DataDirBoxExit(Sender: TObject);
begin
  If DataDirBox.Text = CloudPath then exit;
  CloudPath := DataDirBox.Text;
  FillList;
end;


Function TCloudRebuildT1_2026.GetBackUpNM:String;
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

Procedure TCloudRebuildT1_2026.GetDcnList(Dir:String;var DcnList:TStringList);
Var i:Integer;
  FDConnection: TADConnection;
  Table1: TADTable;
begin
  DcnList.clear;

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

Procedure TCloudRebuildT1_2026.RestoreDcnNumbers(Dir:String;DcnList:TStringList);
Var i:Integer;DcnNo:String;FlName:String;
    FDConnection: TADConnection;
    Table1: TADTable;
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

procedure TCloudRebuildT1_2026.SetCloudId(const Value: integer);
var hconf: THelperAppUserConfig;
begin
  FCloudId := Value;
  hconf := HelperManager.Config(FCloudId, AppT1_2026.AppId, User.UserName);
  ClientId := HelperManager.Config(CloudId).ClientID;
  CloudPath := hconf.Path;
  Token := hconf.Token;
  DataDirBox.Text := CloudPath;
end;

Function TCloudRebuildT1_2026.FigureOutMarStatus(TempList:TStringList): Integer;
Var i : integer;
Begin
 Result := 6; {single}
 For i := 11 to 13 do
  If GetValueFromDisk(RetNo,'INFO',i,TempList)> ''
   then result := i - 10;
 For i := 16 to 18 do
  If GetValueFromDisk(RetNo,'INFO',i,TempList)> ''
  then result := i -15 + 3;
end;

procedure TCloudRebuildT1_2026.FillList;
var FileList: TStringList;
    I: integer;
begin
  lbFiles.Clear;
  FileList := TStringList.Create;
  try
    HelperManager.List(CloudID, CloudPath, HelperManager.Config(CloudId).ClientID, Token, FileList);
    for i := 0 to FileList.Count - 1 do
      If FileList[i][1] <> '*' then
        lbFiles.Items.Add(FileList[I]);
  finally
    FileList.Free;
  end;
end;

procedure TCloudRebuildT1_2026.FormShow(Sender: TObject);
begin
  FillList;
end;

end.
