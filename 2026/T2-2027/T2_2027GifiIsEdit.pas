unit T2_2027gifiisedit;
//revision 2014-07-29
(*
April 2005
Revise GIFI accounts
Edit GIFiIs.d

//GifiIs.xls
Revise also GIFIIS.DB // from GifiIs.Xls (Save xls as DBF 4.0

Same for GIFIBs
*)
interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  ComCtrls,Printers,StdCtrls,Buttons,Db,Grids, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef,
  uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet{,QuickRpt,qrextra};


Type
  TLineRec = Record
  LineNo        : string; //[4];
  Parent      : string; //[4];
  Calculated  : string; //[1];
  Statement   : string; //[2];
  Descr       : string; //[60];
end;

type
  TGifiISEditT2_2027 = class(TForm)
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    TreeView1: TTreeView;
    DataSource1: TDataSource;
    Panel1: TPanel;
    CollapseBtn1: TBitBtn;
    ExpandBtn1: TBitBtn;
    NextStatementBtn: TSpeedButton;
    PrevStatementBtn: TSpeedButton;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    SeqNoBox: TEdit;
    OperNameBox: TEdit;
    RecalcBtn: TBitBtn;
    FindKeyWBtn: TBitBtn;
    BatchEntryBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    PrintBtn: TBitBtn;
    ClearBtn: TBitBtn;
    ImportBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    DescriptionBox: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    LastYrBtn: TBitBtn;
    Panel4: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Table1: TADTable;
    FDConnection: TADConnection;

   // Procedure SelectLines(FromLine,ToLine:String);
    Function  GetLastYearValue(const Ln:String):String;
    Function  GetLineDescription(LineNo:String):String;
    procedure ClearGifi;
    Function  FindLine(LineNo:String):TTreeNode;
    procedure EnterValue(LineNo,OldValStr,ValStr:String;Ndx:Integer;AllowMsg:Boolean);
    {procedure FindLineBtnClick(Sender: TObject);}
    Procedure GetExplodedGifiList(GifiId:String;ParentLine:String;Var ExplodedList:TStringList);
    procedure FormCreate(Sender: TObject);
    procedure ExpandBtn1Click(Sender: TObject);
    procedure CollapseBtn1Click(Sender: TObject);
    procedure CollapseBtn2Click(Sender: TObject);
    procedure ExpandlBtn2Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    Function GetLineRec(Lin:String;Var LineRec:TLineRec):Boolean;
    Function GetGifiValFromMem(RetNo:Integer;FNo:Integer;Ln:String):string;
    Function GetGifiValFromTree(Ln:String):Real;
    Procedure SaveGifiValToMem(RetNo:Integer;FNo:Integer);
    procedure UsedLinesBtnClick(Sender: TObject);
    Procedure UpdateTreeParent(PlineNo:String;OldValStr:String;NewValStr:String);
    procedure TreeView1KeyPress(Sender: TObject; var Key: Char);
    Procedure SetValToATreeLine(Ln:String;Val:real);
    procedure RecalcTree;
    procedure NextStatementBtnClick(Sender: TObject);
    procedure PrevStatementBtnClick(Sender: TObject);
    Procedure OpenGifiTbl;
    Procedure LoadTreeView(RetNo,FNo:Integer);
    procedure RecalcBtnClick(Sender: TObject);
    Procedure SummarizeGifiTree(GifiId:String);
    Function  GetParentTotal(ParentLine:String;GifiId:String):Real;
    Function GetParent(Lin:String):String;
    procedure FindKeyWBtnClick(Sender: TObject);
    procedure BatchEntryBtnClick(Sender: TObject);
    Procedure PrintIS(SomeList:TStringList);
    procedure PrintBtnClick(Sender: TObject);
    procedure GetUsedLines;
    Function  ShouldBeNegative(LineNo,ValStr:String):Boolean;
    procedure ClearBtnClick(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure LastYrBtnClick(Sender: TObject);
    //procedure CategoriesGroupClick(Sender: TObject);
  private
    RetNo:Integer;
    //AQRReport : TQuickRep;
    GifiFNo : Integer;
  public
   CategoryIndexForBatch: Integer;
  end;

var //direct references to form created somewhere
  GifiISEdit: TGifiISEditT2_2027;

implementation

{$R *.DFM}

uses
  vtDialogs,vtMulti,vtCommon,
  T2_2027,T2_2027main,T2_2027TrimStr,
  T2_2027Declare,T2_2027Common,T2_2027Common2,T2_2027Calc,T2_2027GifiBatchEntry,
  T2_2027GifiBsEdit,{T2_2027RepFsIs,}T2_2027ChildWinNew,
  T2_2027Multi,
  vtTrimStr, vtShared, vtDataBase;

procedure TGifiISEditT2_2027.FormCreate(Sender: TObject);
Var  i,j:Integer;ValStr:String;Ln:string; //[4];
   SourceNode:TTreeNode;ndx:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenGifiTbl;
 PageControl1.ActivePage := TabSheet1;
 If GetFormNo('GIFIIS#1') =0 then InitFormData(RetNo,GetFormNo('GIFIIS#1'));
 GifiFNo := GetFormNo('GIFIIS#1');
 LoadTreeView(RetNo,GifiFNo);
 Tabsheet1.Caption := 'Statement #1';
 SeqNoBox.Text:= '01';
 RecalcBtnClick(Sender);   //20111127
 {TotStatementBox.Text := AllTrim(IntToStr(CountIncStatements(RetNo)));}
 end;

procedure TGifiISEditT2_2027.ExpandBtn1Click(Sender: TObject);
begin
TreeView1.FullExpand;
TreeView1.TopItem:=TreeView1.Items[0];
end;

procedure TGifiISEditT2_2027.CollapseBtn1Click(Sender: TObject);
begin
TreeView1.FullCollapse;
end;

procedure TGifiISEditT2_2027.CollapseBtn2Click(Sender: TObject);
begin
{TreeView2.FullCollapse;}
end;

procedure TGifiISEditT2_2027.ExpandlBtn2Click(Sender: TObject);
begin
{TreeView2.FullExpand;}
end;

procedure TGifiISEditT2_2027.CancelBtnClick(Sender: TObject);
begin
 SaveGifiValToMem(RetNo,GifiFNo);
 Ret[RetNo].FrmHasData[GifiFNo] := True;
 Ret[RetNo].Changed := True;
 If Table1.Active then Table1.Close;
 Close;
 Application.CreateForm(TGifiBSEditT2_2027,GifiBSEdit);
 GifiBSEdit.ExpandBtn1Click(Sender); //20131026
 GifiBSEdit.ShowModal;
 GifiBSEdit.Free;
end;

procedure TGifiISEditT2_2027.TreeView1DblClick(Sender: TObject);
Var i:Integer;LineNo:String;
  SourceNode:TTreeNode;ndx:Integer;Rec:String;
CurrentLineRec,ParentLineRec,GrandParentLineRec:TLineRec;
ValStr,OldValStr:String;x:Real;
begin
  SourceNode:= TreeView1.Selected;
  Ndx :=SourceNode.AbsoluteIndex;
  Rec :=TreeView1.Items[ndx].text;
  LineNo :=LeftStr(Rec,4);
  OldValStr :=AllTrim(RemoveChar(MidStr(Rec,94,15),','));  //20091222 instead of 81
  ValStr:= InputBox(MidStr(Rec,1,94),                {20091222 instead of 81}
   'Enter without decimals (to remove enter 0)',OldValStr);
  ValStr:= RemoveChar(ValStr,',');
  EnterValue(LineNo,OldValStr,ValStr,Ndx,True);
end;

procedure TGifiISEditT2_2027.EnterValue(LineNo,OldValStr,ValStr:String;Ndx:Integer;AllowMsg:Boolean);
Var i:Integer;SourceNode:TTreeNode;Rec:String;
CurrentLineRec,ParentLineRec,GrandParentLineRec:TLineRec;
x:Real;Repl:string; //[1];
begin
  If GetLineRec(LineNo,CurrentLineRec)= false then
  begin
    If AllowMsg then ShowMessage('Line not found on the Gifi data base');
    exit;
  end;
  If CurrentLineRec.Calculated = 'Y' then
  begin
    If AllowMsg then ShowMessage('This Line is automatically calculated');
    exit;
  end;
  If ValStr >'' then
  begin
   If not Numeric(ValStr) then
   begin
    If AllowMsg then ShowMessage('Value is not numeric');
    exit;
   end;
  end;

  If (ValStr>'')
  and (ShouldBeNegative(LineNo,ValStr)) then
  begin
   If AllowMsg then
   begin
    Repl:= InputBox('Line should be negative', 'Make it negative? (Y/N)', 'Y');
    If UpperCase(Repl) = 'Y' then ValStr := '-'+ValStr;
   end;
  end;

  If ValStr>'' then
  begin
   ValStr := JustRight(FormatFloat('###,###,##0',Vl(ValStr)),15);
   TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+ValStr;  //20091222
   UpdateTreeParent(CurrentLineRec.Parent,OldValStr,ValStr);
   If GetLineRec(CurrentLineRec.Parent,CurrentLineRec)= True then
   begin
     If AllTrim(CurrentLineRec.Parent) >'' then
      begin
      UpdateTreeParent(CurrentLineRec.Parent,OldValStr,ValStr);
      end;
   end;
   RecalcTree;
   Ret[RetNo].Changed := True;
   Ret[Retno].FedCalcStatus := False;
   Ret[Retno].OntCalcStatus := False;
   Ret[Retno].AlbCalcStatus := False;

  end;
end;



procedure TGifiISEditT2_2027.RecalcTree;
Var x:Real;
begin
  {gross profit}
   x := GetGifiValFromTree('8089')-GetGifiValFromTree('8518');
   //x := GetGifiValFromTree('8299')-GetGifiValFromTree('8518');
   SetValToATreeLine('8519',x);
  {total expenses}
   x := GetGifiValFromTree('8518')+GetGifiValFromTree('9367');
   SetValToATreeLine('9368',x);

  {Net non farm income}
   x := GetGifiValFromTree('8299')-GetGifiValFromTree('9368');
   SetValToATreeLine('9369',x);

   {Net farm income}
   x := GetGifiValFromTree('9659')-GetGifiValFromTree('9898');
   SetValToATreeLine('9899',x);

   //before tax etc       //20111128
   x:=GetGifiValFromTree('9369')+GetGifiValFromTree('9899');
   SetValToATreeLine('9970',x);
   //20111127
   x := GetGifiValFromTree('9998');
   SetValToATreeLine('9998',x);


   // 20111128
   x :=  GetGifiValFromTree('9970')
        -GetGifiValFromTree('9975')
        -GetGifiValFromTree('9976')
        +GetGifiValFromTree('9980')
        -GetGifiValFromTree('9985')
        -GetGifiValFromTree('9990')
        -GetGifiValFromTree('9995')
        +GetGifiValFromTree('9998');   //20111122  //compreh income
   SetValToATreeLine('9999',x);

  (*
   //20111128
   x := GetGifiValFromTree('9369')+GetGifiValFromTree('9899')+GetGifiValFromTree('9998');
   SetValToATreeLine('9999',x);
   *)
end;

Function TGifiISEditT2_2027.GetLineRec(Lin:String;Var LineRec:TLineRec):Boolean;
begin
  result := false;
  If Table1.FindKey([Lin]) then
  begin
   Result := True;
   LineRec.Lineno:= Table1['LineNo'];
   LineRec.Parent:= Table1.FieldByName('Parent').AsString;
   LineRec.Calculated:= Table1.FieldByName('Calculated').AsString; {variant problem?}
   LineRec.Statement:= Table1['Statement'];
   LineRec.Descr:= Table1['Descr'];
  end;
end;

Procedure TGifiISEditT2_2027.UpdateTreeParent(PlineNo:String;OldValStr:String;NewValStr:String);
Var i:Integer;x:Real;ValStr:String;
SourceNode:TTreeNode;ndx:Integer;
begin
  For i:=0 to Treeview1.Items.count-1 do
  begin
   SourceNode:= TreeView1.Items[i];
   Ndx :=SourceNode.AbsoluteIndex;
   If LeftStr(TreeView1.Items[ndx].text,4) = PlineNo then
   begin
     x:=Vl(AllTrim(RemoveChar(RightStr(TreeView1.Items[ndx].text,15),',')));
     x:=x-Vl(AllTrim(RemoveChar(AllTrim(OldValStr),',')));
     x:=x+Vl(AllTrim(RemoveChar(AllTrim(NewValStr),',')));
     ValStr :=JustRight(FormatFloat('###,###,###',x),15);
     If ValStr='' then valStr := FilledStr(15,' ');
     TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+ValStr;  //20091222
     Exit;
   end;
  end;
end;

Procedure TGifiISEditT2_2027.SetValToATreeLine(Ln:String;Val:real);
Var i:Integer;x:Real;ValStr:String;
SourceNode:TTreeNode;ndx:Integer;
begin
  For i:=0 to Treeview1.Items.count-1 do
  begin
   SourceNode:= TreeView1.Items[i];
   Ndx :=SourceNode.AbsoluteIndex;
   If LeftStr(TreeView1.Items[ndx].text,4) = Ln then
   begin
     ValStr :=JustRight(FormatFloat('###,###,##0',Val),15);
     If ValStr='' then valStr := FilledStr(15,' ');
     TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+ValStr;  //20091222
     Exit;
   end;
  end;
end;

Function TGifiISEditT2_2027.GetGifiValFromTree(Ln:String):Real;
Var i:Integer;x:Real;ValStr:String;
SourceNode:TTreeNode;ndx:Integer;
begin
  result :=0;
  For i:=0 to Treeview1.Items.count-1 do
  begin
   SourceNode:= TreeView1.Items[i];
   Ndx :=SourceNode.AbsoluteIndex;
   If LeftStr(TreeView1.Items[ndx].text,4) = ln then
   begin
     result:=Vl(AllTrim(RemoveChar(RightStr(TreeView1.Items[ndx].text,15),',')));
     Exit;
   end;
  end;
end;


Function TGifiISEditT2_2027.GetGifiValFromMem(RetNo:Integer;FNo:Integer;Ln:String):String;
Var i:Integer;
begin
 Result :='';
 SeqNoBox.Text:= FetchElmFNo(RetNo, GifiFNo,1);
 OperNameBox.Text:= FetchElmFNo(RetNo, GifiFNo,2);
 DescriptionBox.Text:= FetchElmFNo(RetNo, GifiFNo,3);
 If Ret[RetNo].Frm[GifiFNo].Count <5 then exit;
 i:=5;
 Repeat
  If FetchElmFNo(RetNo, GifiFNo,i) = Ln then
   Try
   begin result := FetchElmFNo(RetNo, GifiFNo,i+1);exit;end;
   except
   end;
  Inc(i,2);
 until i>Ret[RetNo].Frm[GifiFNo].Count-1;

end;

Procedure TGifiISEditT2_2027.SaveGifiValToMem(RetNo:Integer;FNo:Integer);
Var  i,j,ElmNo,Ndx:Integer;ValStr:String;
   SourceNode:TTreeNode;
begin
 {increase capacity to 2 times for line and value}
 i:=2;
 Repeat
  if Ret[RetNo].Frm[FNo].Count < i+2 then
  begin
      Ret[RetNo].Frm[FNo].Add('');
      Ret[RetNo].Frm[FNo].Add('');
  end;
  Inc(i,2);
 until i>12;

 //if Ret[RetNo].Frm[GifiFNo].Count < 13 then for i:=1 to 12 do Ret[RetNo].Frm[GifiFNo].Add('');
 //if Ret[RetNo].Frm[GifiFNo].Count < 5 then for i:=1 to 4 do Ret[RetNo].Frm[GifiFNo].Add('');

 StoreElm(RetNo,GifiFNo,1,AllTrim(SeqNoBox.Text));  {elm 1}
 StoreElm(RetNo,GifiFNo,2,AllTrim(OperNameBox.Text));  {elm 2}
 StoreElm(RetNo,GifiFNo,3,AllTrim(DescriptionBox.Text));  {elm 3}
 StoreElm(RetNo,GifiFNo,4,'');
 ElmNo:=3;
 For i:=0 to Treeview1.Items.count-1 do
 begin
   SourceNode:= TreeView1.Items[i];
   Ndx :=SourceNode.AbsoluteIndex;
   If AllTrim(RightStr(TreeView1.Items[ndx].text,15)) >'' then
   begin
    inc(ElmNo,2);
    if Ret[RetNo].Frm[GifiFNo].Count < ElmNo+2 then
     begin
        Ret[RetNo].Frm[GifiFNo].Add('');
        Ret[RetNo].Frm[GifiFNo].Add('');
     end;
    StoreElm(RetNo,GifiFNo,ElmNo,LeftStr(TreeView1.Items[ndx].text,4));
    StoreElm(RetNo,GifiFNo,ElmNo+1,RemoveChar(RightStr(TreeView1.Items[ndx].text,15),','));
   end;
 end;
end;

procedure TGifiISEditT2_2027.UsedLinesBtnClick(Sender: TObject);
begin
 (*
 SomeList := TStringList.Create; {already defined}
 SomeCaption := 'Accounts used';
 GetUsedLines; {into some list}
 Application.CreateForm(TPoplist,PopList);
 PopList.Width := Screen.Width - 50;
 PopList.ShowModal;
 PopList.Release;
 SomeList.Free;
 *)
end;

procedure TGifiISEditT2_2027.GetUsedLines;
Var i:Integer;LineNo:String;SourceNode:TTreeNode;ndx:Integer;Rec:String;
CurrentLineRec,ParentLineRec,GrandParentLineRec:TLineRec;
ValStr,OldValStr:String;x:Real;
begin
 Screen.Cursor := CrHourGlass;
 SourceNode := Treeview1.Items.GetFirstNode;
 While SourceNode <> nil do
 begin
  LineNo:=LeftStr(AllTrim(LeftStr(SourceNode.Text,7)),4);
  If GetGifiValFromTree(LineNo) <> 0 then
   SomeList.Add(SourceNode.Text);
  SourceNode := SourceNode.GetNext;
 end;  {while}
 Screen.Cursor := CrDefault;
end;

Procedure TGifiISEditT2_2027.PrintIS(SomeList:TStringList);
Var FileNm,Hdr1,Hdr2,Hdr3,s:string;
begin
 s:='GIFI Income Statement Accounts (Do Not Submit to CCRA)';
 If SomeList.Count =0 then exit;
 Hdr1 := PaddR(S,60)+' '+PaddR(DateToMonthDayYear(Date),20);
 Hdr2 := GetCorpName(RetNo) + ' - '+'#'+SeqNoBox.Text+ ' '+OperNameBox.Text;
 Hdr3 := FilledStr(80,'=')+FilledStr(14,'=');
 FileNm:=AppDir+'\'+'TempFile';
 SomeList.SaveToFile(FileNm);
 If PrintDialog1.Execute then
 begin
 If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
  ShowMessage('Printing Completed');
 end;
end;



Procedure TGifiISEditT2_2027.OpenGifiTbl;
begin
 Try
  //20150922 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + GiFiisDBLite, GiFiisTableLite, 'LINENO');// 'PRNSEQ'; //'LINENO';  //20111116
 except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;


procedure TGifiISEditT2_2027.TreeView1KeyPress(Sender: TObject; var Key: Char);
begin
TreeView1DblClick(Sender);
end;


Procedure TGifiISEditT2_2027.LoadTreeView(RetNo,FNo:Integer);
Var  i,j:Integer;ValStr:String;Ln,S:String;
   SourceNode:TTreeNode;ndx:Integer;
   //TreeviewText:String;
begin
 Treeview1.Visible := False;
 TreeView1.Color := GetRetColor(RetNo);
 Treeview1.LoadFromFile(AppDir+'\'+'GifiIs.d');
 For i:=0 to Treeview1.Items.count-1 do
 begin
    SourceNode:= TreeView1.Items[i];
    Ndx :=SourceNode.AbsoluteIndex;
    //20091219 add 13 to length
    TreeView1.Items[ndx].text := TreeView1.Items[ndx].text   //20090607
      +FilledStr(66-Length(TreeView1.Items[ndx].text),'.'); //+FilledStr(63-Length(TreeView1.Items[ndx].text),'.'); //20130601
    Ln := LeftStr(TreeView1.Items[ndx].text,4);
    s:=JustRight(GetLastYearValue(Ln),15);
    TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,78)  //20090607
      +FilledStr(78-Length(TreeView1.Items[ndx].text),'.')+S;
    ValStr :=JustRight(FormatFloat('###,###,###',Vl(GetGifiValFromMem(RetNo,GifiFNo,Ln))),15);
    If ValStr='' then valStr := FilledStr(15,' ');
    TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+ValStr; //20070607
 end;
 RecalcTree;
 Treeview1.Visible := True;
 TreeView1.FullCollapse;
end;

procedure TGifiISEditT2_2027.PrevStatementBtnClick(Sender: TObject);
Var CInst:Integer;FNm,NewFnm:string; //[12];
begin
 SaveGifiValToMem(RetNo,GifiFNo);
 FNm:= GetFormName(GifiFNo);
 CInst := StrToInt(MidStr(ExtractFormInst(Fnm),2,2));

 If CInst>1 then
 begin
  Dec(CInst);
  NewFnm:=ExtractNonInstFormName(FNm)+'#'+IntToStr(CInst);
  GifiFNo := GetFormNo(NewFnm);
  LoadTreeView(RetNo,GifiFNo);
 end;
 TabSheet1.Caption := 'Statement #'+ AllTrim(IntToStr(CInst));
 SeqNoBox.Text:= PaddZero(IntToStr(CInst),2);
end;

procedure TGifiISEditT2_2027.NextStatementBtnClick(Sender: TObject);
Var CInst:Integer;FNm,NewFnm,s:String;
begin
 SaveGifiValToMem(RetNo,GifiFNo); {save the current tree view data #1 or #2}
 FNm:= GetFormName(GifiFNo);
 CInst := StrToInt(MidStr(ExtractFormInst(Fnm),2,2));
 Inc(CInst);
 NewFnm:=ExtractNonInstFormName(FNm)+'#'+IntToStr(CInst);
 begin
  GifiFNo:= AddPageInstance(RetNo, 'GIFIIS','#'+IntToStr(CInst));
  InitFormData(RetNo,GetFormNo(NewFnm));
 end;
 //GifiFNo:= GetFormNo(NewFnm);
 LoadTreeView(RetNo,GifiFNo);
 TabSheet1.Caption := 'Statement #'+ AllTrim(IntToStr(CInst));
 SeqNoBox.Text:= PaddZero(IntToStr(CInst),2);
 RecalcBtnClick(Sender); //20111127
end;

procedure TGifiISEditT2_2027.RecalcBtnClick(Sender: TObject);
Var InputString:string; //[1];
begin
 {
 InputString:= InputBox('Input Box', 'Recalculation is lengthy. Needed only if data is corrupt. Enter Y to proceed', 'N');
 If UpperCase(InputString) <> 'Y' then exit;
 }
 Screen.Cursor := crHourGlass;
 SummarizeGifiTree('IS');
 Screen.Cursor := crDefault;
end;

Procedure TGifiISEditT2_2027.SummarizeGifiTree(GifiId:String);
Var i,j:Integer;s:string;GifiLines:TStringList;X:Real;
ParentLine,Ln:String;ExplodedList:TStringList;
Parents:TStringList;
begin
 RecalcTree;
 ExplodedList:=TStringList.Create;
 Parents:=TStringList.Create;
 GifiLines := TStringList.Create;
 If GifiId='BS' then
   GifiLines.LoadFromFile(AppDir+'\'+'GifiBs.d')
 else
   GifiLines.LoadFromFile(AppDir+'\'+'GifiIs.d');
 {Get second level parents}
 For i:=0 to GifiLines.Count-1 do
 begin
  If (LeftStr(GifiLines[i],1) = Space(1))
  and (MidStr(GifiLines[i],2,1) > Space(1))
  //20111128
  and (LeftStr(GifiLines[i],4) <> '9975')
  and (LeftStr(GifiLines[i],4) <> '9976')
  and (LeftStr(GifiLines[i],4) <> '9980')
  and (LeftStr(GifiLines[i],4) <> '9985')
  and (LeftStr(GifiLines[i],4) <> '9990')
  and (LeftStr(GifiLines[i],4) <> '9995')
  then
    Parents.Add(LeftStr(GifiLines[i],5));
 end;
 GifiLines.Free;

 For i:=0 to Parents.Count-1 do
 begin
  ExplodedList.Clear;
  ParentLine:= LeftStr(Parents[i],5);
  If GetParent(ParentLine) > Space(1) then
     GetExplodedGifiList(GifiId,ParentLine,ExplodedList);
  x:=0;
  For j:=0 to ExplodedList.Count-1 do
  begin
    Ln:= AllTrim(ExplodedList[j]);
    If AllTrim(GetParent(Ln)) = AllTrim(ParentLine) then
      x:=x+GetGifiValFromTree(Ln);
  end;
  SetValToATreeLine(ParentLine,x);
 end;

 {Get First Level parents}
 Parents.Clear;
 GifiLines := TStringList.Create;
 If GifiId='BS' then
   GifiLines.LoadFromFile(AppDir+'\'+'GifiBs.d')
 else
   GifiLines.LoadFromFile(AppDir+'\'+'GifiIs.d');

 For i:=0 to GifiLines.Count-1 do
 begin
  If (LeftStr(GifiLines[i],1) > Space(1))
  and (LeftStr(GifiLines[i],4) <> '9975') //20111128
  and (LeftStr(GifiLines[i],4) <> '9976')
  and (LeftStr(GifiLines[i],4) <> '9980')
  and (LeftStr(GifiLines[i],4) <> '9985')
  and (LeftStr(GifiLines[i],4) <> '9990')
  and (LeftStr(GifiLines[i],4) <> '9995')
  then
    Parents.Add(LeftStr(GifiLines[i],4));
 end;
 {explode parents}
 For i:=0 to Parents.Count-1 do
 begin
  ExplodedList.Clear;
  ParentLine:= LeftStr(Parents[i],4);
  If ParentLine < '9999' then {real first level}  //20111127
 // If ParentLine < '9998' then {real first level}  //20111115
  //If ParentLine < '9970' then {real first level}
  begin
   GetExplodedGifiList(GifiId,ParentLine,ExplodedList);
   x:=0;
   For j:=0 to ExplodedList.Count-1 do
   begin
     Ln:= AllTrim(ExplodedList[j]);
     If AllTrim(GetParent(Ln)) = AllTrim(ParentLine) then
       x:=x+GetGifiValFromTree(Ln);
   end;
   SetValToATreeLine(ParentLine,x);
  end; {real first level}
 end;
 RecalcTree;
 GifiLines.Free;
 ExplodedList.Free;
 Parents.Free;
end;


Function TGifiISEditT2_2027.GetParentTotal(ParentLine:String;GifiId:String):Real;
Var i,j:Integer;s:string;GifiLines:TStringList;X:Real;
Ln:String;ExplodedList:TStringList;
begin
    ExplodedList:=TStringList.Create;
    GifiLines := TStringList.Create;
    GetExplodedGifiList(GifiId,ParentLine,ExplodedList);
    x:=0;
    For j:=0 to ExplodedList.Count-1 do
    begin
      Ln:= AllTrim(ExplodedList[j]);
      If AllTrim(GetParent(Ln)) = AllTrim(ParentLine) then
        x:=x+GetGifiValFromTree(Ln);
    end;
    ExplodedList.Free;
    GifiLines.Free;
    result :=x;
end;

Function TGifiISEditT2_2027.GetParent(Lin:String):String;
Var LineRec:TLineRec;
begin
 If GetLineRec(Lin,LineRec) then result := LineRec.Parent;
end;

Procedure TGifiISEditT2_2027.GetExplodedGifiList(GifiId:String;ParentLine:String;Var ExplodedList:TStringList);
begin
 With Table1 do
 begin
  First;
  repeat
   If AllTrim(FieldByName('Parent').AsString) = AllTrim(ParentLine) then
     ExplodedList.Add(FieldByName('LineNo').AsString);
   Next;
   until Table1.Eof;
 end;
end;

procedure TGifiISEditT2_2027.FindKeyWBtnClick(Sender: TObject);
Var I,Ndx:integer;InputString,LineNo:String;
   GifiList:TStringList;
   SourceNode:TTreeNode;
begin
 InputString:= InputBox('Enter a key word or Line No such as Sales, Interest, etc', '', 'Sales');
 If Length(AllTrim(InputString)) =0 then exit;

 GifiList := TStringList.Create;
 SomeList.Clear;  // := TStringList.Create; {already defined}
 GifiList.LoadFromFile(AppDir+'\'+'GifiIS.d');
 For i:=0 to GifiList.Count-1 do
 begin
  If FindWord(InputString,GifiList[i])>0 then
    SomeList.Add(GifiList[i]);
 end;
 GifiList.Free;

 SomeCaption := 'Entries with keyword: '+InputString;
  SelectedString := PopSomeList(SomeList, SomeCaption);
 SomeList.Clear;  //.Free;

 If SelectedString > '' then
 begin
  LineNo := LeftStr(AllTrim(LeftStr(SelectedString,7)),4);
  SourceNode:=FindLine(LineNo);
  Ndx :=SourceNode.AbsoluteIndex;
  Treeview1.HotTrack:=False;
  SourceNode.Selected := True;
  TreeView1.TopItem := SourceNode;
 end;
end;

Function TGifiISEditT2_2027.FindLine(LineNo:String):TTreeNode;
Var i:Integer;SourceNode:TTreeNode;ndx:Integer;Rec:String;
CurrentLineRec,ParentLineRec,GrandParentLineRec:TLineRec;
ValStr,OldValStr:String;x:Real;
begin
 SourceNode := Treeview1.Items.GetFirstNode;
 While SourceNode <> nil do
 begin
  If LeftStr(AllTrim(LeftStr(SourceNode.Text,7)),4) = LineNo then
  begin
   Result := SourceNode;
   exit;
  end;
  SourceNode := SourceNode.GetNext;
 end;  {while}
 Result := SourceNode;
end;

procedure TGifiISEditT2_2027.BatchEntryBtnClick(Sender: TObject);
Var LineNo,ValStr,OldValStr:String;
SourceNode:TTreeNode;ndx:Integer;Rec:String;
begin
  GifiCallingBatchEntry:= 'IS';
 Repeat
  Application.CreateForm(TGifiBatchEntryT2_2027,GifiBatchEntry);
  GifiBatchEntry.ShowModal;
  LineNo:=LeftStr(GifiBatchEntry.LinesBox.Text,4); //GifiBatchEntry.LineBox.Text;
  CategoryIndexForBatch:=GifiBatchEntry.CategoriesBox.ItemIndex;
  ValStr := GifiBatchEntry.AmountBox.Text;
  If LineNo = '' then Exit; //break;  20090607

  SourceNode:=FindLine(LineNo);
  If SourceNode = Nil then
  begin
   ShowMessage('Line '+LineNo+ ' not found');
   exit;
  end;
  Ndx :=SourceNode.AbsoluteIndex;
  Rec :=TreeView1.Items[ndx].text;
  OldValStr :=AllTrim(RemoveChar(RightStr(Rec,15),',')); //20100128
    //AllTrim(RemoveChar(MidStr(Rec,91,15),',')); //20091222

  Treeview1.HotTrack:=False;
  SourceNode.Selected := True;
  TreeView1.TopItem := SourceNode;
  EnterValue(LineNo,OldValStr,ValStr,Ndx,True);
 until LineNo='';
end;

procedure TGifiISEditT2_2027.PrintBtnClick(Sender: TObject);
{var
  RepFSIS: TRepFSIST2_2027;}
begin
 If Vl(FetchGifiElm(RetNo,'GIFIBS#1','2599')) =0 then
   ShowMessage('The final income will show once you complete the Balance Sheet also');

 SaveGifiValToMem(RetNo,GifiFNo);
 Try //20110308
  {Application.CreateForm(TRepFSIST2_2027,RepFSIS);
  AQrReport := RepFSIS.QuickRep1;
  AQRReport.PrinterSettings.PrinterIndex:= Printer.PrinterIndex;
  AQrReport.Preview;
  RepFSIS.Free;}
 Except
 end;
  exit;
end;

Function TGifiISEditT2_2027.ShouldBeNegative(LineNo,ValStr:String):Boolean;
Var i:Integer;TempList:TstringList;x:Real;
begin
 Result :=False;
 x:=Vl(ValStr);
 If ((LineNo = '8501')
 or (LineNo = '8502')
 or (LineNo = '8503')
 or (LineNo = '8500'))
 and (x>0) then Result := True
end;

procedure TGifiISEditT2_2027.ClearBtnClick(Sender: TObject);
begin
  if MessageDlg('This will remove ALL amounts from the GIFI-IS. Proceed??',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
  ClearGifi;
end;

procedure TGifiISEditT2_2027.ClearGifi;
Var  i,j,ElmNo,Ndx:Integer;ValStr:String;
   SourceNode:TTreeNode;
begin

  For i:=0 to Treeview1.Items.count-1 do
  begin
    SourceNode:= TreeView1.Items[i];
    Ndx :=SourceNode.AbsoluteIndex;
   TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+Space(15); //20091222
  end;


 {increase capacity to 2 times for line and value}
 if Ret[RetNo].Frm[GifiFNo].Count < 5 then
    for i:=1 to 4 do Ret[RetNo].Frm[GifiFNo].Add('');

 StoreElm(RetNo,GifiFNo,1,AllTrim(SeqNoBox.Text));
 StoreElm(RetNo,GifiFNo,2,AllTrim(OperNameBox.Text));
 StoreElm(RetNo,GifiFNo,3,'');
 StoreElm(RetNo,GifiFNo,4,'');
 ElmNo:=3;
 For i:=0 to Treeview1.Items.count-1 do
 begin
   SourceNode:= TreeView1.Items[i];
   Ndx :=SourceNode.AbsoluteIndex;
   inc(ElmNo,2);
   if Ret[RetNo].Frm[GifiFNo].Count < ElmNo+2 then
     begin
        Ret[RetNo].Frm[GifiFNo].Add('');
        Ret[RetNo].Frm[GifiFNo].Add('');
     end;
   StoreElm(RetNo,GifiFNo,ElmNo,'');
   StoreElm(RetNo,GifiFNo,ElmNo+1,'');
 end;
 FormCreate(Application);
end;

procedure TGifiISEditT2_2027.ImportBtnClick(Sender: TObject);
Var i,FNo,ElmNo:Integer;ImportList,WList:TStringList;
    FLName:String;
    LineNo,ValStr,OldValStr:String;
    SourceNode:TTreeNode;ndx:Integer;Rec:String;
    xInt:LongInt; x:real;
begin

 if MessageDlg('This will replace ALL amounts in the GIFI-IS. Proceed??',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
 If OpenDialog1.Execute then
   FlName := OpenDialog1.FileName;
 If FlName='' then exit;
 ImportList:=TStringList.create;
 WList := TStringList.create;
 Try
  ImportList.LoadFromFile(FlName);
 except
   ShowMessage('Import failed');
 end;
  ClearGifi;
  {ignore first and last record}
  Screen.Cursor := crHourGlass;
  For i:=1 to ImportList.count-2 do
  begin
    ParseWords(ImportList[i],',',WList);
    LineNo:=AllTrim(RemoveChar(WList[0],'"'));

    {With enter value like batch entry}
    xInt:= Round(Vl(AllTrim(RemoveChar(WList[1],'"'))));
    ValStr := IntToStr(xInt);
    //LockWindowUpdate(FormHandle); FormHandle never set
    SourceNode:=FindLine(LineNo);

    If SourceNode = Nil then
     {ShowMessage('Line '+LineNo+ ' not found')}
    else
    begin
     Ndx :=SourceNode.AbsoluteIndex;
     Treeview1.HotTrack:=False;
     {SourceNode.Selected := True;}
     {TreeView1.TopItem := SourceNode;}
     EnterValue(LineNo,'',ValStr,Ndx,False);
    end;
  end;
  {LoadTreeView(RetNo,FNo);  with forms method}
  Wlist.Free;
  ImportList.Free;
  Screen.Cursor := crDefault;
end;

procedure TGifiISEditT2_2027.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{CancelBtnClick(Sender);}
end;

procedure TGifiISEditT2_2027.BitBtn1Click(Sender: TObject);
begin
ShowPdf(AppDir,'RC4088.pdf');
end;

procedure TGifiISEditT2_2027.LastYrBtnClick(Sender: TObject);
Var i,j:Integer;LineDescr:String;
begin
 SomeList.Clear;  // := TStringList.Create;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName = 'LASTYRIS' then
   begin
    j:=1;
    Repeat
     LineDescr:=GetLineDescription(FetchElmFNo(RetNo,Frec.FormNo,j));
     If FetchElmFNo(RetNo,Frec.FormNo,j+1)>'' then
       SomeList.Add(PaddR(LineDescr,60)
         +' $'+PaddR(FormatFloat('###,###,###.##',Vl(FetchElmFNo(RetNo,Frec.FormNo,j+1))),14));
     Inc(j,2);
    Until j>FieldsLimit-3;
   End;
 end; //i
 If SomeList.Count=0 then
 begin
   ShowMessage('No data found. Data is captured only during a new Roll over from the previous year');
   //SomeList.Free;
   Exit;
 end;
 SomeList.Sorted:=True;
 SomeCaption:='Last year GIFI Income Statement amounts';
  SelectedString := PopSomeList(SomeList,SomeCaption);
 SomeList.Clear;  //.Free;
end;

Function TGifiISEditT2_2027.GetLineDescription(LineNo:String):String;
Var SourceNode:TTreeNode;ndx:Integer;Rec:String;
Begin
  SourceNode:={GifiIsEdit.}FindLine(LineNo);
  If SourceNode = Nil then
    Result:='*** LINE NOT FOUND ***'
  else
  begin
   Ndx :=SourceNode.AbsoluteIndex;
   Rec :={GifiIsEdit.}TreeView1.Items[ndx].text;
   Result:=Rec;
  end;
end;

Function TGifiISEditT2_2027.GetLastYearValue(const Ln:String):String;
Var i,limit,FNo:Integer;
begin
  Result := GetLastYearLnValue(RetNo,Ln,'LASTYRIS#1');
end;

(*
Procedure TGifiISEdit.SelectLines(FromLine,ToLine:String);
Var i:Integer;TempList:TStringList;
begin
 SomeList:=TStringList.Create;
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'GIFIIS.d');
 For i:=0 to TempList.count-1 do
 begin
  If (LeftStr(AllTrim(TempList[i]),4) >= FromLine)
  and (LeftStr(AllTrim(TempList[i]),4) <= ToLine) then
   SomeList.Add(AllTrim(TempList[i]));
 end;
 TempList.Free;
end;
*)
(*
procedure TGifiISEdit.CategoriesGroupClick(Sender: TObject);
Var i:Integer; //inserts selected into somelist
begin
 ComboBox1.Items.Clear;
 Case CategoriesGroup.itemIndex+1 of
  1: SelectLines('8000','8053');  //Into some list
  2: SelectLines('8090','8250');
  3: SelectLines('8300','8503');
  4: SelectLines('8520','9286');
  5: SelectLines('9370','9650');
  6: SelectLines('9660','9870');
  else
  Exit;
 end; //case
 For i:=0 to SomeList.Count-1 do ComboBox1.items.add(Somelist[i]);
 SomeList.Free;
 Combobox1.Text:=ComboBox1.Items[0];
 ComboBox1.Refresh;
 //Edit2.Text:=
end;
*)
end.


