unit T2_2027rollover;
//revision 2014-07-29

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,ExtCtrls,Buttons,Grids,T2_2027Common,T2_2027Declare,
  T2_2027Common2,T2_2027TrimStr,T2_2027ChildWinNew,T2_2027Calc,DB,
  DBGrids, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient, //20150622
  VKDBFDataSet, //20160327 Igor
  vtDynData, System.RegularExpressions, Variants;  //20170904 Igor

  type
  TRolloverT2_2027 = class(TForm)
    RetCntLabel: TLabel;
    DataSource1: TDataSource;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    LastYearDirBox: TEdit;
    Label3: TLabel;
    ThisYearDirBox: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Label2: TLabel;
    SearchBox: TEdit;
    SelectDirBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label4: TLabel;
    Bevel1: TBevel;
    FDConnection: TADConnection;
    Table1: TADTable;
    ADMemTable1: TADMemTable; //20160913 Igor

    procedure DoConversion;
    Procedure Convert(OldRetNo:Integer;RetNo:Integer);
    Function LastYearDirExists(S:string):Boolean;
    procedure ShowFiles;
    {procedure CalcImported(RetNo:Integer);}
    Function ValidDirectories:Boolean;
    {procedure OpenIt(FlName:String);}
    {procedure SaveIt(FlName:String);}
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LastYearDirBoxExit(Sender: TObject);
    procedure LastYearDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1DblClick(Sender: TObject);
    {procedure DosFileBtnClick(Sender: TObject);}
    {procedure BitBtn1Click(Sender: TObject);}
    procedure SearchBoxChange(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure Table1FilterRecord(DataSet: TDataSet; var Accept: Boolean); //20160327 igor

   { procedure FindSinBtnClick(Sender: TObject);}  {Screen, element, valu}
  private
    FRetNo: integer;
    DBFTable: TVKSmartDBF; //20160327 Igor
    WorkTable: TDataSet; //20160327 Igor
    CurrentDataBase: String; //20160913 Igor
  public
    property RetNo: integer read FRetNo;
  end;

var
  RolloverT2_2027: TRolloverT2_2027;
  FlName: String; //[60];
  Cnt   : integer;
  InitialRowCount :integer;

implementation

{$R *.DFM}
uses vtCommon,vtDialogs,T2_2027,T2_2027Main,vtMain,vtTrimStr,vtShared, vtDataBase,
  vtMulti, T2_2027Features; //20170902 Igor

procedure TRolloverT2_2027.FormCreate(Sender: TObject);
Var
  slash :string[1];
begin
  FRetNo := GetCurrentRetNo;
  FlName := '';
  {OverrideOption.itemIndex :=0;}
  LastYearDirBox.Text := OptRec.Dir_LastYr;
  ThisYearDirBox.Text := OptRec.Dir_Cur;
  If (UpperCase(LastYearDirBox.Text) = 'A:') or
     (UpperCase(LastYearDirBox.Text) = 'B:') then
    slash :='' else slash := '\';

  ShowFiles;
end;

procedure TRolloverT2_2027.CancelBtnClick(Sender: TObject);
begin
  WorkTable.Close; //20160327 Igor
  Close;
end;

procedure TRolloverT2_2027.StringGrid1DblClick(Sender: TObject);
begin
OKBtnClick(Sender);
end;

procedure TRolloverT2_2027.Table1FilterRecord(DataSet: TDataSet; //20160327 Igor
  var Accept: Boolean);
begin
  Accept := (SearchBox.Text = '') or (pos(UpperCase(SearchBox.Text),UpperCase(DataSet.fieldByname('Corp_Name').asString))>0);
end;

Function TRolloverT2_2027.ValidDirectories:Boolean;
Var i,j: integer; Sin : string;
begin
 Result := False;
 If Not SysUtils.DirectoryExists(ThisYearDirBox.Text) then
 begin
  ShowMessage('Directory does not exist');
  ThisYearDirBox.SetFocus;
  exit;
 end;
 //20170902 Igor>>>
 if IsDataDirectoryGood(ThisYearDirBox.Text) = False then
   exit;
 //20170902 Igor<<<

 If Not LastYearDirExists(LastYearDirBox.Text) then
  begin
   ShowMessage('Directory does not exist');
   LastYearDirBox.SetFocus;
   exit;
  end;
 Result := True;
end;

Function TRolloverT2_2027.LastYearDirExists(S:string):Boolean;
begin
 If (UpperCase(s) ='A:') or (UpperCase(s) ='B:') then
   begin result :=true;exit;end;
 If SysUtils.DirectoryExists(S) then result := true
 else result := false;
end;

procedure TRolloverT2_2027.ShowFiles;
Var
  i,j:integer;
begin
  if CurrentDataBase = LastYearDirBox.Text then exit; //20160913 igor
  CurrentDataBase := LastYearDirBox.Text;             //20160913 igor
  //20160327 Igor >>>
  //20170310 Igor >>>
  If FileExists(LastYearDirBox.Text+'\'+ClientsTable_dbf) then
  Begin
    if not assigned(DBFTable) then //20160913 Igor
      DBFTable := TVKSmartDBF.Create(Self);
    DBFTable.Close; //20160913 Igor
    DBFTable.DBFFileName := LastYearDirBox.Text+'\'+ClientsTable_dbf;
    try
      DBFTable.Open;
    except
      ShowMessage ('Error open: ' + LastYearDirBox.Text+'\'+ClientsTable_dbf);
      exit;
    end;
    ADMemTable1.CopyDataSet(DBFTable, [coStructure, coRestart, coAppend]); //20160913 Igor
    ADMemTable1.IndexFieldNames := 'CORP_NAME';                            //20160913 Igor
    WorkTable := ADMemTable1;                                              //20160913 Igor
  End
  else
  If FileExists(LastYearDirBox.Text+'\'+ClientsDBLite) then //20150922 Igor
  begin
    SetTableName(FDConnection, Table1, LastYearDirBox.Text + '\' + ClientsDBLite,
      ClientsTableLite, 'CORP_NAME', False); //20170112 Igor
    WorkTable := Table1;
  end
  else
  Begin
    ShowMessage('Last year directory does not contain VisualTax files');
    exit;
  End;
  //20170310 Igor <<<
  WorkTable.OnFilterRecord := Table1FilterRecord;
  DataSource1.DataSet := WorkTable;
  WorkTable.First;
  //20160327 Igor <<<
  Refresh;
end;

procedure TRolloverT2_2027.LastYearDirBoxExit(Sender: TObject);
begin
If not LastYearDirExists(LastYearDirBox.text) then
 begin
  ShowMessage('Directory '+ LastYearDirBox.text+ ' does not exist');
  LastYearDirBox.text := OptRec.Dir_lastYr;
  {exit}
 end;
 ShowFiles;
end;

procedure TRolloverT2_2027.LastYearDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If key = #13 then LastYearDirBoxExit(Application);
end;

procedure TRolloverT2_2027.DBGrid1DblClick(Sender: TObject);
begin
 OKBtnClick(Application);
end;

procedure TRolloverT2_2027.SearchBoxChange(Sender: TObject);
begin
//20160327 Igor >>>
//  with Table1 do
//  begin
//    SetKey;
//    FieldByName('Corp_Name').AsString := UpperCase(SearchBox.Text);
//    GotoNearest;
//  end;

  WorkTable.filtered := False; //20160913 Igor
  WorkTable.filtered := true;
  WorkTable.first; //20160913 Igor
//20160327 Igor <<<
end;

procedure TRolloverT2_2027.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then OKBtnClick(Sender);
end;

procedure TRolloverT2_2027.OKBtnClick(Sender: TObject);
begin
 Screen.Cursor := crHourglass;
 DoConversion;
 Screen.Cursor := crDefault;
 WorkTable.Close; //20160327 Igor
 Close;

 MainForm.RecalcBtnClick(Sender);
 CountDiagnostics(RetNo);
 //MainForm.TileVertical1Click();  //20150801  causes display problems if clicked a tiled window
 //Problem also happens in T1 if tiled multiple returns. //20150801
 MainForm.GuiCommand(gcShowLeftPanel); //MainForm.LeftPanel.Visible:=True; //20160222 Igor
 MainFormT2.RecalcBtnClick(Sender);  //20150801  This shows the data and also does the diagnostics
 LockWindowUpdate(0);
end;

procedure TRolloverT2_2027.DoConversion;
Var i,j,k,OpenResult,OldRetNo:Integer; RetNo:Integer;
  FormNo,FNo1,FNo2:Integer;
  FormName, sin:String;
begin
 FlName := WorkTable.FieldByName('FILE_NAME').AsString; //20160327 Igor
 Sin:=FlName;   //20121220
// If IsOkToOpenReturn(LastYearDirBox.Text,FlName,Sin) = False then Exit; //20121220 //20130202
 If AllTrim(FlName) = '' then exit;
//20170901 Igor>>>
 If AppT2.ExceedsMaxReturnsAllowed(not AppT2.ExistReturnInDB(ThisYearDirBox.text, FlName)) then
 begin
//   ShowMessage('Number of returns exceeds maximum allowed '
//   +'('+IntToStr(LimitedVersionReturns)+')'+
//   Chr(13)+' in the T2 Limited version');
   Exit;
 end;
 //20170901 Igor<<<

 //RetNo:=InitNewReturn;
 //Openresult :=OpenReturn(RetNo,LastYearDirBox.Text,FlName,True);
 Openresult :=OpenReturn(LastYearDirBox.Text,FlName,True);
 RetList[Openresult].SourceForRollOver := True;//20170904 Igor
 LockWindowUpdate(MainForm.Handle);
 If OpenResult > 0 then //old return opened
 begin
  RetNo := OpenResult;
  OpenForm(RetNo,GetFormNo('T2'),0); //new child
  OldRetNo :=RetNo;
  CalcFed(OldRetNo);
  CalcOnt(OldRetNo);
  CalcAlb(OldRetNo);
  LockReturn(OldRetNo);
  k:=FileNew; //InitNewReturn;   //new return
  If K>0 then
  begin
    RetNo:=k;
    LockWindowUpdate(MainForm.Handle);
    //MainForm.LeftPanel.Visible:=True;
    FormName := 'T2';
    FormNo := GetFormNo(FormName);
    InitFormData(RetNo,FormNo);
    OpenForm(RetNo,FormNo,0); //new child
    UpdateAllDataIndicators(RetNo);
    Convert(OldRetNo,RetNo);
    Ret[RetNo].SourceDataDir := OptRec.Dir_Cur; {fool it}
    Ret[RetNo].Changed := True;
  end;
 end
 else
 begin
    ShowOpenReturnFailure(OpenResult,LastYearDirBox.Text,FlName);
    exit;
 end;
 //20090606  copy last years gifi to last years gifi forms
 //incease capacity of forms
 FNo1:=GetFormNo('LASTYRIS#1');
 FNo2:=GetFormNo('LASTYRBS#1');
 For i:=0 to FieldsLimit-1 do
 begin
   Ret[RetNo].Frm[FNo1].Add('');
   Ret[RetNo].Frm[FNo2].Add('');
 end;
 For j := 0 to FieldsLimit-1 do
 begin
  //20091219
  If FetchElm(OldRetNo,'GIFIIS#1',j)>'' then StoreElm(RetNo,FNo1,j,FetchElm(OldRetNo,'GIFIIS#1',j));
  If FetchElm(OldRetNo,'GIFIBS#1',j)>'' then StoreElm(RetNo,FNo2,j,FetchElm(OldRetNo,'GIFIBS#1',j));
 end;
end;

Procedure TRolloverT2_2027.Convert(OldRetNo:Integer;RetNo:Integer);
//20160327 Igor (Reload from D5)
Var I,j,k,jj,KK,J0,J00,K0,K00,FNo,FNumb,ThisFNo:integer;FrmNm,s:string; ADate:TDateTime;
 ArrayNo,ArrayElm,MaxRowsPerArray,BoxesPerRow:Integer; Value:String; //for dynamic forms
 FirstYear:String;
  //20170904 Igor>>>
  function IsOldDateFormat(AStr: String): Boolean;
  begin
    Result := TRegEx.isMatch(AStr, '^/d{8,8}$');
  end;
  //20170904 Igor<<<
begin
  FNo :=1; {initialize/needed}
  With Ret[RetNo].Frm[FNo] do
  begin
    FrmNm := 'T2';
    FNo:= GetFormNo(FrmNm);
    //20200408
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
       Ret[OldRetNo].CloneForm(FrmNm, RetNo,FrmNm,true);
       StoreElm(RetNo,FNo,10,AdvanceYearEnd(Strings[10]));
       StoreElm(RetNo,FNo,11,AdvanceYearEnd(Strings[11]));

       StoreElm(RetNo,FNo,152,''); //530 ERDTOH
       StoreElm(RetNo,FNo,154,''); //535 NERDTO

       { 20211205
       // RfDTH  //20200614
       If (GetBegYearEnd(OldRetNo)<'2019/01/01')
       and (GetBegYearEnd(RetNo)>='2019/01/01')
       then
       Begin
         StoreElm(RetNo,FNo,267,'Y'); //First year Indicator
        // ShowMessage('Rdtoh='+FetchElmFNo(OldRetNo,Fno,539));
         StoreElm(RetNo,FNo,142,FetchElmFNo(OldRetNo,Fno,536)); //460 NERDTOH //20200909
        // StoreElm(RetNo,FNo,142,FetchElmFNo(OldRetNo,Fno,539)); //460 NERDTOH
         StoreElm(RetNo,FNo,120,FetchElmFNo(OldRetNo,Fno,540)); //465 NERDTOH
       end;
      }

       StoreElm(RetNo,FNo,165,'');  //amalgamation  //20211206


       If  (GetBegYearEnd(OldRetNo)>='2019/01/01')
       and (GetBegYearEnd(RetNo)>='2019/01/01')
       then
       Begin
         StoreElm(RetNo,FNo,267,'N'); //First year Indicator
         StoreElm(RetNo,FNo,142,''); //460 NERDTOH
         StoreElm(RetNo,FNo,152,FetchElmFNo(OldRetNo,Fno,190)); //530 ERDTOH
         StoreElm(RetNo,FNo,154,FetchElmFNo(OldRetNo,Fno,186)); //535 NERDTO

         //prev year dividend refund
        StoreElm(RetNo,FNo,166,FetchElmFNo(OldRetNo,Fno,198)); //570 Elig dividend refund  //20211207
        StoreElm(RetNo,FNo,182,FetchElmFNo(OldRetNo,Fno,235)); //575 Elig dividend refund  //20211207
       end;

      StoreElm(RetNo,FNo,8,''); {address change}
      StoreElm(RetNo,FNo,28,''); {first year}
      StoreElm(RetNo,FNo,29,''); {first year}
      StoreElm(RetNo,FNo,30,''); {first year}
      StoreElm(RetNo,FNo,31,''); {first year}

      StoreElm(RetNo,FNo,61,''); {chg during yr}
      StoreElm(RetNo,FNo,745,''); {sign date} //20130201
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;


    //S125   20160519
    FrmNm := 'S125#1';  //capture last yer's GIFI amounts
    FNo:= GetFormNo(FrmNm);
    InitFormData(RetNo,FNo);
    For ArrayNo:=1 to 6 do
     Begin
      BoxesPerRow := 4;
      MaxRowsPerArray := DynamicRowCount(OldRetNo, FNo, ArrayNo); //80; //20160430 Igor//MaxRowsPerArray := 80;
      ArrayElm := ArrayNo * 10000 + StrToInt('1');
      For i := 0 to MaxRowsPerArray do
      begin
        StoreElm(RetNo, FNo, ArrayElm,FetchElmFNo(OldRetNo, FNo, ArrayElm));
        StoreElm(RetNo, FNo, ArrayElm + 1,FetchElmFNo(OldRetNo, FNo, ArrayElm+1));
        StoreElm(RetNo, FNo, ArrayElm + 3,FetchElmFNo(OldRetNo, FNo, ArrayElm+2)); //capture last year's amount only
        ArrayElm := ArrayElm + BoxesPerRow;
      end;  //i
    End;  //arrayno
    //fixed lines
    j:=42;
    Repeat
     StoreElm(RetNo, FNo, j,FetchElmFNo(OldRetNo, FNo, j-1));
     Inc(j,3);
    Until J>60;

    j:=66;  //20160520
    Repeat
     StoreElm(RetNo, FNo, j,FetchElmFNo(OldRetNo, FNo, j-1));
     Inc(j,3);
    Until J>81;


    Ret[RetNo].FrmHasData[FNo]:=True;

    //S125   20160519
    FrmNm := 'S100';  //capture last yer's GIFI amounts
    FNo:= GetFormNo(FrmNm);
    InitFormData(RetNo,FNo);  // Ret[OldRetNo].CloneForm(FrmNm, RetNo,FrmNm,true); //it does not work well
    For ArrayNo:=1 to 8 do
     Begin
      BoxesPerRow := 4;
      MaxRowsPerArray := DynamicRowCount(OldRetNo, FNo, ArrayNo); //80; //20160430 Igor//MaxRowsPerArray := 80;
      ArrayElm := ArrayNo * 10000 + StrToInt('1');
      For i := 0 to MaxRowsPerArray do
      begin
        StoreElm(RetNo, FNo, ArrayElm,FetchElmFNo(OldRetNo, FNo, ArrayElm));
        StoreElm(RetNo, FNo, ArrayElm + 1,FetchElmFNo(OldRetNo, FNo, ArrayElm+1));
        StoreElm(RetNo, FNo, ArrayElm + 3,FetchElmFNo(OldRetNo, FNo, ArrayElm+2)); //capture last year's amount only
        ArrayElm := ArrayElm + BoxesPerRow;
      end;  //i
    End;  //arrayno
    //fixed lines
    //20160521
    StoreElm(RetNo, FNo, 48,FetchElmFNo(OldRetNo, FNo, 47));  //held in trust
    StoreElm(RetNo, FNo, 58,FetchElmFNo(OldRetNo, FNo, 57));  //held in trust
    //equity
    StoreElm(RetNo, FNo, 30,FetchElmFNo(OldRetNo, FNo, 29));  //Shares

    StoreElm(RetNo, FNo, 36,FetchElmFNo(OldRetNo, FNo, 35));
    StoreElm(RetNo, FNo, 39,FetchElmFNo(OldRetNo, FNo, 38));
    StoreElm(RetNo, FNo, 42,FetchElmFNo(OldRetNo, FNo, 41));

    StoreElm(RetNo, FNo, 45,FetchElmFNo(OldRetNo, FNo, 44));
    StoreElm(RetNo, FNo, 52,FetchElmFNo(OldRetNo, FNo, 51));
    StoreElm(RetNo, FNo, 55,FetchElmFNo(OldRetNo, FNo, 54));

    StoreElm(RetNo, FNo, 44,FetchElmFNo(OldRetNo, FNo, 54));  //R/E Start //20160521

    Ret[RetNo].FrmHasData[FNo]:=True;
   //---------------------------------------------------

   {STATUS}
    FrmNm := 'STATUS';FNo:= GetFormNo(FrmNm);
    InitFormData(RetNo,FNo);
    StoreElm(RetNo,FNo,11, User.UserName); //20170112 Igor
    StoreElm(RetNo,FNo,12,FormatDateTime('yyyy-mm-dd',Now));
    StoreElm(RetNo,FNo,13,TimeToStr(Time));
    If FetchElmFNo(RetNo,FNo,4)='' then StoreElm(RetNo,FNo,4,'00');
    Ret[RetNo].FrmHasData[FNo]:=True;

    {Donations}
    FrmNm := 'S2';FNo:= GetFormNo(FrmNm);    //pg3
    If (Ret[OldRetNo].FrmHasData[FNo]) then
     begin
       InitFormData(RetNo,FNo);
       j:=204;  {don}
       Repeat
        StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+5)); {yr}
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+9)); {cf amount}
       { For i:=24 to 28 do StoreElm(RetNo,FNo,i,'');}
        Inc(j,5);
       until j> 224;
       j:=238;  {gifts}
       Repeat
        StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+5)); {yr}
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+9)); {cf amount}
        {For i:=58 to 62 do StoreElm(RetNo,FNo,i,'');}
        Inc(j,5);
       until j> 258;

       j:=272;  {cult}
       Repeat
        StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+5)); {yr}
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+9)); {cf amount}
        {For i:=92 to 96 do StoreElm(RetNo,FNo,i,'');}
        Inc(j,5);
       until j> 292;

       j:=306;  {ecolog}
       Repeat
        StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+5)); {yr}
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+9)); {cf amount}
        {For i:=126 to 127 do StoreElm(RetNo,FNo,i,'');}
        Inc(j,5);
       until j> 326;
       Ret[RetNo].FrmHasData[FNo]:=True;
     end;

    //non cap losses
    FrmNm := 'S4WS';FNo:= GetFormNo(FrmNm); //pg5 //???
    If (Ret[OldRetNo].FrmHasData[FNo]) then
     begin
       InitFormData(RetNo,FNo);
       StoreElm(RetNo,FNo,500,FetchElmFNo(OldRetNo,FNo,500)); //auto calc indicator
       j:=501;  {non cap}
       Repeat
        StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+7-00)); {yr}
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+13-00)); {cf amount}
        //If Vl(FetchElmFNo(OldRetNo,FNo,j+13))>0 then ShowMessage('end bal = '+ IntToStr(j+13)+'  ='+FetchElmFNo(OldRetNo,FNo,j+13));
        StoreElm(RetNo,FNo,j+2,'');
        StoreElm(RetNo,FNo,j+4,'');
        Inc(j,7);
       until j> 648; //641; //20190411


       j:=662; //563;  {farm}
       Repeat
        StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+7-00)); {yr}
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+13-00)); {cf amount}
        StoreElm(RetNo,FNo,j+2,'');
        StoreElm(RetNo,FNo,j+4,'');
        Inc(j,7);
       until j> 809; //802; //626;  //20190411


       j:=823;  //646;  {rest farm}
       Repeat
        StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+7-00)); {yr}
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+13-00)); {cf amount}
        StoreElm(RetNo,FNo,j+2,'');
        StoreElm(RetNo,FNo,j+4,'');
        Inc(j,7);
       until j> 970; //709;

       //Listed property
       StoreElm(RetNo,FNo,92,FetchElmFNo(OldRetNo,FNo,49));
       j:=44;
       Repeat
        StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+6-00)); {yr}
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+11-00)); {cf amount}
        StoreElm(RetNo,FNo,j+2,'');
        StoreElm(RetNo,FNo,j+4,'');
        Inc(j,6);
       until j> 86; //80;         //20190411
     end;  //s4ws

     FrmNm := 'S4';FNo:= GetFormNo(FrmNm);
     If (Ret[OldRetNo].FrmHasData[FNo]) then
     begin
       InitFormData(RetNo,FNo);            //20141021
       //20190411
      // StoreElm(RetNo,GetFormNo('S4WS'),642,FetchElmFNo(OldRetNo,FNo,34)); //20190311 //no cap lost last year
       //net cap loss
       StoreElm(RetNo,FNo,101,FetchElmFNo(OldRetNo,FNo,116)); {beg bal}  //20121210
       For j:=102 to 115 do StoreElm(RetNo,FNo,j,'');
       For j:=113 to 147 do StoreElm(RetNo,FNo,j,'');

       StoreElm(RetNo,FNo,217,FetchElmFNo(OldRetNo,FNo,229)); {beg bal}  //20121210
       j:=372;
       Repeat
        StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+5)); {beg bal}
        StoreElm(RetNo,FNo,j+2,'');
        StoreElm(RetNo,FNo,j+3,'');
        StoreElm(RetNo,FNo,j+4,'');
        Inc(j,7);
       until j>400;
       Ret[RetNo].FrmHasData[FNo]:=True;
     end; //s4


    {S9}
    FrmNm := 'S9';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm, True); //20160829 Igor
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;


   // Closing bal elm 37 must go tp 21 and elm 15 set to 'Y'
    //s508 Ont RD
    FrmNm := 'S508';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,21,FetchElm(OldRetNo,FNo,37));
      StoreElm(RetNo,FNo,15,'Y');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;



    {CCA}
    //202260629 Alex >>>
    FrmNm:= 'S8#1';
    FNo:= GetFormNo(FrmNm);
    if Ret[OldRetNo].FrmHasData[FNo] then
    begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      ClearForm(RetNo,FrmNm);

      i:= 6;  //class new return  same in both old and new
      j:= 27; //ending ucc on old return //20260731
      repeat
        if not FetchElmFNo(OldRetNo, FNo, i).IsEmpty() then
        begin
          StoreElm(RetNo, FNo, i, FetchElmFNo(OldRetNo, FNo, i)); // class  //20260731CZ
          StoreElm(RetNo, FNo, i + 1, FetchElmFNo(OldRetNo, FNo, j)); //20260731CZ Bigiining UCC on new return
        end;

        inc(i, 22);
        Inc(j, 22); //20260731
      until (i > 204);
      Ret[RetNo].FrmHasData[Fno]:= True;
    end;

    FrmNm:= 'S8#2';
    FNo:= GetFormNo(FrmNm);
    if Ret[OldRetNo].FrmHasData[FNo] then
    begin
      CloneForm(OldRetNo, FrmNm, RetNo, FrmNm);
      ClearForm(RetNo, FrmNm);
      i:= 6;
      j:= 27; //ending ucc on old return //20260731
      repeat
        if not FetchElmFNo(OldRetNo, FNo, i).IsEmpty() then
        begin
          StoreElm(RetNo, FNo, i, FetchElmFNo(OldRetNo, FNo, i)); // class  //20260731CZ
          xx:=Vl(FetchElmFNo(OldRetNo, FNo, j));   //*****   DOES NOT WORK  //20260731
          StoreElm(RetNo, FNo, i + 1, FetchElmFNo(OldRetNo, FNo, j)); //20260731CZ Bigiining UCC on new return
        end;

        inc(i, 22);
        Inc(j, 22); //20260731
      until (i > 204);
      Ret[RetNo].FrmHasData[Fno]:= True;
    end;
    //202260629 Alex <<<

    {Leaseholds}
    (* //20260718
    FrmNm := 'S8LH';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
    begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm, True); //20160811 Igor
      j:=4; {UCC start}
      jj:=151; //First yr indicator
      Repeat
       StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+6));
       StoreElm(RetNo,FNo,jj,'N');  //20121221
       Inc(j,11);
       Inc(jj,1);
      until j>125;
      j:=5; {clear adj, proceeds, CCA}
      Repeat
       StoreElm(RetNo,FNo,j,'');
       StoreElm(RetNo,FNo,j+1,'');
       StoreElm(RetNo,FNo,j+4,'');
       Inc(j,11);
      until j>126; //125;  //20160809
      StoreElm(RetNo,FNo,149,''); {override}
      Ret[RetNo].FrmHasData[Fno]:=True;
    end;
 *)
    {RC59}
    FrmNm := 'RC59';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,64,LeftStr(GetPrevYearEnd(GetTaxationYearEnd(RetNo),1),4));
      StoreElm(RetNo,FNo,66,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    {s10}
    FrmNm := 'S10';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,4,FetchElmFNo(OldRetNo,FNo,13));
      For j:=5 to 27 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
      Calc(RetNo,'S10');
     end;

    {Resource}
    FrmNm := 'S12';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
    begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,4,FetchElmFNo(OldRetNo,FNo,13));
      StoreElm(RetNo,FNo,5,FetchElmFNo(OldRetNo,FNo,14));
      For j:=6 to 14 do StoreElm(RetNo,FNo,j,'');
      StoreElm(RetNo,FNo,15,FetchElmFNo(OldRetNo,FNo,21));
      For j:=16 to 21 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;

      //CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,101,FetchElmFNo(OldRetNo,FNo,123));
      StoreElm(RetNo,FNo,102,FetchElmFNo(OldRetNo,FNo,124));
      For j:=103 to 124 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;

      //CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,201,FetchElmFNo(OldRetNo,FNo,225));
      StoreElm(RetNo,FNo,202,FetchElmFNo(OldRetNo,FNo,226));
      For j:=203 to 226 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;



      //CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,301,FetchElmFNo(OldRetNo,FNo,321));
      StoreElm(RetNo,FNo,302,FetchElmFNo(OldRetNo,FNo,322));
      For j:=303 to 322 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;

    //  CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,401,FetchElmFNo(OldRetNo,FNo,413));
      StoreElm(RetNo,FNo,402,FetchElmFNo(OldRetNo,FNo,414));
      For j:=403 to 416 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
    end;

    {Associated s23}
    If IsAssociated(OldRetNo) then
    begin
      FrmNm := 'S23';
      FNo:= GetFormNo(FrmNm);
      CloneForm(OldRetNo, FrmNm, RetNo, FrmNm, True); //20160829 Igor
      For j:=2 to 2 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
    end;

    {ITC}
    FrmNm := 'S31';FNo:= GetFormNo(FrmNm); //pg3
    If (Ret[OldRetNo].FrmHasData[FNo]) then
    begin
       InitFormData(RetNo,FNo);
       StoreElm(RetNo,FNo,237,FetchElmFNo(OldRetNo,FNo,258)); //20121229
       StoreElm(RetNo,FNo,520,FetchElmFNo(OldRetNo,FNo,539)); //20121229
       StoreElm(RetNo,FNo,1139,FetchElmFNo(OldRetNo,FNo,1155));  //20121229
       StoreElm(RetNo,FNo,1020,FetchElmFNo(OldRetNo,FNo,1023));  //20121229
       Ret[RetNo].FrmHasData[FNo]:=True;
    end;
    FrmNm := 'S49';FNo:= GetFormNo(FrmNm);
    If (Ret[OldRetNo].FrmHasData[FNo]) then
     begin
       CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
       StoreElm(RetNo,FNo,2,''); //yr 20130201
       Ret[RetNo].FrmHasData[FNo]:=True;
     end;

    FrmNm := 'S50';FNo:= GetFormNo(FrmNm); {shareholders}
    If (Ret[OldRetNo].FrmHasData[FNo]) then
     begin
       CloneForm(OldRetNo,FrmNm, RetNo,FrmNm, true); //20160722 Igor
       Ret[RetNo].FrmHasData[FNo]:=True;
     end;


    FrmNm := 'S53';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,25);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,4,FetchElmFNo(OldRetNo,FNo,25));
      Calc(RetNo,FrmNm);
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    FrmNm := 'S54';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,109);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,4,FetchElmFNo(OldRetNo,FNo,109));
      Calc(RetNo,FrmNm);
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;


    //20170509 cmt loss      needs more..
    FrmNm := 'S510';FNo:= GetFormNo(FrmNm);
    If (Ret[OldRetNo].FrmHasData[FNo]) then
    begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      For i:=1 to 119 do StoreElm(RetNo,FNo,i,'');
      For i:=121 to 153 do StoreElm(RetNo,FNo,i,'');
      StoreElm(RetNo,FNo,111,FetchElmFNo(OldRetNo,FNo,120));
      Ret[RetNo].FrmHasData[FNo]:=True;
    end;

     (* did not work
    //20160201 cmt loss
    FrmNm := 'S510';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,120);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,111,FetchElmFNo(OldRetNo,FNo,120));
      Calc(RetNo,FrmNm);
      Ret[RetNo]^.FrmHasData[Fno]:=True;
     end;
    *)

    FrmNm := 'T661';FNo:= GetFormNo(FrmNm);
    If (Ret[OldRetNo].FrmHasData[FNo]) then
     begin
       CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
       For i:=106 to 136 do StoreElm(RetNo,FNo,i,'');
       For i:=138 to 307 do StoreElm(RetNo,FNo,i,'');
       StoreElm(RetNo,FNo,132,FetchElmFNo(OldRetNo,FNo,137));
       StoreElm(RetNo,FNo,370,'N');
       Ret[RetNo].FrmHasData[FNo]:=True;
     end;


    {CDA}
    FrmNm := 'CDA';
    FNo:= GetFormNo(FrmNm);
    If (Ret[OldRetNo].FrmHasData[FNo]) then
     begin
       InitFormData(RetNo,FNo);
       i:=4;
       Repeat
        StoreElm(RetNo,FNo,i,FetchElmFNo(OldRetNo,FNo,i+2));
        Inc(i,3);
       until i>13;

       StoreElm(RetNo,FNo,63,FetchElmFNo(OldRetNo,FNo,30));   //20150213
      // StoreElm(RetNo,FNo,63,FetchElmFNo(OldRetNo,FNo,64));
       StoreElm(RetNo,FNo,59,'');
       StoreElm(RetNo,FNo,61,'');

       i:=31;
       Repeat
        StoreElm(RetNo,FNo,i,FetchElmFNo(OldRetNo,FNo,i+2));
        Inc(i,3);
       until i>55;
       Ret[RetNo].FrmHasData[FNo]:=True;
     end;




    {pRIVATE NOTEPAD}
    for j:=1 to 1 do
    begin
    FrmNm := 'PRIVAT#'+IntToStr(j);FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
     end;
    end;

    {other provinces}
    FrmNm := 'S321';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,38);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,21,FetchElmFNo(OldRetNo,FNo,38));
      Calc(RetNo,FrmNm);
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    FrmNm := 'S360';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,21);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,5,FetchElmFNo(OldRetNo,FNo,21));
      Calc(RetNo,FrmNm);
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    FrmNm := 'S380';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,19);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,4,FetchElmFNo(OldRetNo,FNo,19));
      Calc(RetNo,FrmNm);
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    FrmNm := 'S381';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,38);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,21,FetchElmFNo(OldRetNo,FNo,38));
      Calc(RetNo,FrmNm);
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    FrmNm := 'S402';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,38);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,21,FetchElmFNo(OldRetNo,FNo,38));
      Calc(RetNo,FrmNm);
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    FrmNm := 'S403';FNo:= GetFormNo(FrmNm);
    s:=FetchElmFNo(OldRetNo,FNo,28);
    If Vl(s) <>0 then
     begin
      InitFormData(RetNo,FNo);
      StoreElm(RetNo,FNo,11,FetchElmFNo(OldRetNo,FNo,28));
      Calc(RetNo,FrmNm);
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    (*
    FrmNm := 'S546';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      ClearForm(RetNo,FrmNm);
      j:=4;
      Repeat
       StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j));
       Inc(j,1);
      until j>15;
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;
    *)

    //compsum
    FrmNm := 'COMPSUM';FNo:= GetFormNo(FrmNm);
    InitFormData(RetNo,FNo);

    j:=19;
    Repeat
      StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j));
      Inc(j,5);
    until j>199;

    j:=20;
    Repeat
      StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j));
      Inc(j,5);
    until j>200;

    j:=21;
    Repeat
      StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j));
      Inc(j,5);
    until j>201;

    j:=22;
    Repeat
      StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j));
      Inc(j,5);
    until j>202;


    {Alberta}
    FrmNm := 'AT1';FNo:= GetFormNo(FrmNm);
    If FetchElmFNo(OldRetNo,FNo,9) >'' then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,9,FetchElmFNo(OldRetNo,FNo,9));  //20171130
      //StoreElm(RetNo,FNo,58,FetchElmFNo(OldRetNo,FNo,58));
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;


    {alb as5_1}
    FrmNm := 'AS5';FNo:= GetFormNo(FrmNm);
    {alb cca}
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      s:=FetchELmFNo(OldRetNo,FNo,15);
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      ClearForm(RetNo,FrmNm);
      StoreElm(RetNo,FNo,37,s);
      If s>'' then Ret[RetNo].FrmHasData[Fno]:=True;
     end;

    FrmNm := 'AS13#1';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      ClearForm(RetNo,FrmNm);
      StoreElm(RetNo,FNo,3,'Y'); {FetchElmFNo(OldRetNo,FNo,3));} {y/n indic}
      j:=6;
      Repeat
       StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j));
       StoreElm(RetNo,FNo,j+1,FetchElmFNo(OldRetNo,FNo,j+15));
       Inc(j,16);
      until j>198;
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;
   {Alb CGE}
    FrmNm := 'AS14';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,21,'Y'); {FetchElmFNo(OldRetNo,FNo,21));} {y/n indic}
      StoreElm(RetNo,FNo,4,FetchElmFNo(OldRetNo,FNo,13));
      For j:=5 to 20 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;
    {Alb Resource}
    FrmNm := 'AS15';FNo:= GetFormNo(FrmNm);
    If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,3,FetchElmFNo(OldRetNo,FNo,3)); {y/n indic}
      StoreElm(RetNo,FNo,4,FetchElmFNo(OldRetNo,FNo,13));
      StoreElm(RetNo,FNo,5,FetchElmFNo(OldRetNo,FNo,14));
      For j:=6 to 14 do StoreElm(RetNo,FNo,j,'');
      StoreElm(RetNo,FNo,15,FetchElmFNo(OldRetNo,FNo,21));
      For j:=16 to 21 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

     FrmNm := 'AS15';FNo:= GetFormNo(FrmNm);
     If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,101,FetchElmFNo(OldRetNo,FNo,23));
      StoreElm(RetNo,FNo,102,FetchElmFNo(OldRetNo,FNo,24));
      For j:=103 to 124 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

     FrmNm := 'AS15';FNo:= GetFormNo(FrmNm);
     If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,201,FetchElmFNo(OldRetNo,FNo,25));
      StoreElm(RetNo,FNo,202,FetchElmFNo(OldRetNo,FNo,26));
      For j:=203 to 226 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

     FrmNm := 'AS15';FNo:= GetFormNo(FrmNm);
     If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,301,FetchElmFNo(OldRetNo,FNo,21));
      StoreElm(RetNo,FNo,302,FetchElmFNo(OldRetNo,FNo,22));
      For j:=303 to 322 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

     FrmNm := 'AS15';FNo:= GetFormNo(FrmNm);
     If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,401,FetchElmFNo(OldRetNo,FNo,13));
      StoreElm(RetNo,FNo,402,FetchElmFNo(OldRetNo,FNo,14));
      For j:=403 to 416 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

     {Alb Donations}
     FrmNm := 'AS20';FNo:= GetFormNo(FrmNm);
     If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,22,'Y'); {FetchElmFNo(OldRetNo,FNo,22));} {y/n indic}
      StoreElm(RetNo,FNo,3,FetchElmFNo(OldRetNo,FNo,11));
      For j:=4 to 21 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

     FrmNm := 'AS20';FNo:= GetFormNo(FrmNm);
     If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,103,FetchElmFNo(OldRetNo,FNo,11));
      For j:=104 to 111 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;
     {Alb losses}
     FrmNm := 'AS21';FNo:= GetFormNo(FrmNm);
     If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      ClearForm(RetNo,FrmNm);
      StoreElm(RetNo,FNo,28,'Y'); {FetchElmFNo(OldRetNo,FNo,28));} {y/n indic}
      StoreElm(RetNo,FNo,13,FetchElmFNo(OldRetNo,FNo,19));
      StoreElm(RetNo,FNo,14,FetchElmFNo(OldRetNo,FNo,24));
      For j:=4 to 11 do StoreElm(RetNo,FNo,j,'');
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;

     FrmNm := 'AS21';FNo:= GetFormNo(FrmNm); //pg2
     If Ret[OldRetNo].FrmHasData[FNo] then
     begin
      CloneForm(OldRetNo,FrmNm, RetNo,FrmNm);
      StoreElm(RetNo,FNo,123,FetchElmFNo(OldRetNo,FNo,3));
      StoreElm(RetNo,FNo,104,FetchElmFNo(OldRetNo,FNo,24));
      StoreElm(RetNo,FNo,125,FetchElmFNo(OldRetNo,FNo,33));
      For j:=105 to 124 do StoreElm(RetNo,FNo,j,'');
      For j:=126 to 133 do StoreElm(RetNo,FNo,j,'');

      j:=135; //add 100 to j
      Repeat
       StoreElm(RetNo,FNo,j,FetchElmFNo(OldRetNo,FNo,j+4-100)); //subtract 100 from j for old form
       StoreElm(RetNo,FNo,j+1,'');
       StoreElm(RetNo,FNo,j+2,'');
       StoreElm(RetNo,FNo,j+3,'');
       Inc(J,6);
      until j>159;
      Ret[RetNo].FrmHasData[Fno]:=True;
     end;
 end;


 CalcFed(RetNo);
 CalcOnt(RetNo);
 CalcAlb(RetNo);
 //20160327 Igor (reload from D5)
end;


procedure TRolloverT2_2027.SelectDirBtn1Click(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
 begin
  LastYearDirBox.Text :=DirSelected;
 end;
 ShowFiles;
end;

procedure TRolloverT2_2027.BitBtn2Click(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
 begin
  ThisYearDirBox.Text :=DirSelected;
 end;
end;

procedure TRolloverT2_2027.HelpBtnClick(Sender: TObject);
begin
 ShowHelp('T2Help','Rollover');
end;

end.
