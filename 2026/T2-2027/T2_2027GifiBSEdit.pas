unit T2_2027gifibsedit;
//revision 2014-07-29
(*
GIFI BS maintenance i.e. add account
Change the GIFIBS.XLS
Save it.
Then save it as GIFIBS.DB
Use delphi DB to index Line no
Change also GIFIBA.D, GIFIBS1.d GIFIBS2.d
*)
interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  ComCtrls,Printers,StdCtrls,Buttons,Db,Grids,T2_2027ChildWinNew,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient{,
  QuickRpt,qrextra};

Type
  TLineRec = Record
  LineNo        : String;//[4]; //20150701
  Parent      : String;//[4]; //20150701
  Calculated  : String;//[1]; //20150701
  Statement   : String;//[2]; //20150701
  Descr       : String;//[60]; //20150701
end;

type
  TGifiBSEditT2_2027 = class(TForm)
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    TreeView1: TTreeView;
    DataSource1: TDataSource;
    Panel1: TPanel;
    CollapseBtn1: TBitBtn;
    ExpandBtn1: TBitBtn;
    BsNoBox: TRadioGroup;
    CancelBtn: TBitBtn;
    RecalcBtn: TBitBtn;
    FindKeyWBtn: TBitBtn;
    BatchEntryBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    PrintBtn: TBitBtn;
    ClearBtn: TBitBtn;
    ImportBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    LastYrBtn: TBitBtn;
    Panel4: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    FDConnection: TADConnection;
    Table1: TADTable;

    Function GetLastYearValue(Ln:String):String;
    Function GetLineDescription(LineNo:String):String;
    procedure ClearGifi;
    Procedure GetExplodedGifiList(GifiId:String;ParentLine:String;Var ExplodedList:TStringList);
    Procedure OpenGifiTbl;
    procedure FormCreate(Sender: TObject);
    procedure ExpandBtn1Click(Sender: TObject);
    procedure CollapseBtn1Click(Sender: TObject);
    procedure CollapseBtn2Click(Sender: TObject);
    procedure ExpandlBtn2Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    Function GetLineRec(Lin:String;Var LineRec:TLineRec):Boolean;
   { Function GetGifiValFromMem(RetNo:Integer;FNo:Integer;Ln:String):string;}
    Function GetGifiValFromTree(Ln:String):Real;
    Procedure SaveGifiValToMem(RetNo:Integer;FNo:Integer);
    procedure UsedLinesBtnClick(Sender: TObject);
    Procedure UpdateTreeParent(PlineNo:String;OldValStr:String;NewValStr:String);
    procedure TreeView1KeyPress(Sender: TObject; var Key: Char);
    Procedure SetValToATreeLine(Ln:String;Val:real);
    procedure RecalcTree;
    procedure BsNoBoxClick(Sender: TObject);
    Procedure LoadTreeView(RetNo,FNo:Integer);
    Procedure SummarizeGifiTree(GifiId:String);
    procedure RecalcBtnClick(Sender: TObject);
    Function GetParent(Lin:String):String;
    Function GetParentTotal(ParentLine:String;GifiId:String):Real;
    procedure FindKeyWBtnClick(Sender: TObject);
    {procedure FindLineBtnClick(Sender: TObject);}
    Function FindLine(LineNo:String):TTreeNode;
    procedure BatchEntryBtnClick(Sender: TObject);
    procedure EnterValue(LineNo,OldValStr,ValStr:String;Ndx:Integer;AllowMsg:Boolean);
    Procedure PrintBS(SomeList:TStringList);
    procedure GetUsedLines;
    procedure PrintBtnClick(Sender: TObject);
    Function ShouldBeNegative(LineNo,ValStr:String):Boolean;
    procedure ClearBtnClick(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure LastYrBtnClick(Sender: TObject);

    {Function CalcParentTotal(ParentLine:String;GifiId:String):Real;}
  private
    FRetNo: integer;
    FNo : Integer;
    Mask:String;
    //AQRReport : TQuickRep;
  public
   CategoryIndexForBatch: Integer;
    MyChild: TMyChildT2_2027;
  //form to show?
    FormNo:Integer;
    FormName: string;
    property RetNo: integer read FRetNo;
  end;

var //reference to form created somewhere
  GifiBSEdit: TGifiBSEditT2_2027;

implementation

{$R *.DFM}

uses
  vtDialogs,vtMulti,vtMain,vtCommon,
  T2_2027,T2_2027Multi,T2_2027main,T2_2027TrimStr,
  T2_2027Declare,T2_2027Common,T2_2027Common2,T2_2027Calc,T2_2027GifiBatchEntry,
  {T2_2027RepFsBS,}vtTrimStr, vtShared, vtDataBase;

procedure TGifiBSEditT2_2027.FormCreate(Sender: TObject);
Var x:Real;
begin
 FRetNo:=GetCurrentRetNo;
 MyChild := Ret[retNo].MyChild as TMyChildT2_2027;
 OpenGifiTbl;

 begin
  FNo := AddPageInstance(RetNo, 'GIFIBS','#2');
  InitFormData(RetNo,GetFormNo('GIFIBS#2'));
 end;


  BsNoBox.ItemIndex  := 0;
  PageControl1.ActivePage := TabSheet1;
  FNo := GetFormNo('GIFIBS#1'); { TODO -oCon : check inst no }
  LoadTreeView(RetNo,FNo);
  Tabsheet1.Caption:='Closing B/S';
end;

procedure TGifiBSEditT2_2027.BsNoBoxClick(Sender: TObject);
begin
 SaveGifiValToMem(RetNo,FNo); {save the current tree view data #1 or #2}
 If BsNoBox.ItemIndex  = 0 then
 begin
   FNo := GetFormNo('GIFIBS#1');
   Tabsheet1.Caption := 'Closing B/S';
 end
 else
 begin
   FNo := GetFormNo('GIFIBS#2');
   Tabsheet1.Caption := 'Opening B/S';
 end;
 LoadTreeView(RetNo,FNo);
end;

Procedure TGifiBSEditT2_2027.OpenGifiTbl;
begin
 Try
  //20150922 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + GiFibsDBLite, GiFibsTableLite, 'LINENO');
 except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;

procedure TGifiBSEditT2_2027.ExpandBtn1Click(Sender: TObject);
begin
TreeView1.FullExpand;
TreeView1.TopItem:=TreeView1.Items[0];
end;

procedure TGifiBSEditT2_2027.CollapseBtn1Click(Sender: TObject);
begin
TreeView1.FullCollapse;
end;

procedure TGifiBSEditT2_2027.CollapseBtn2Click(Sender: TObject);
begin
{TreeView2.FullCollapse;}
end;

procedure TGifiBSEditT2_2027.ExpandlBtn2Click(Sender: TObject);
begin
{TreeView2.FullExpand;}
end;

procedure TGifiBSEditT2_2027.CancelBtnClick(Sender: TObject);
begin
  SaveGifiValToMem(RetNo,FNo);
  If Vl(FetchGifiElmFNo(RetNo,FNo,'3660'))=0 then  //20110611
  Begin
    if MessageDlg('Any start of Year Retained Earnings (Line 3660)?', mtWarning, [mbNo, mbYes], 0)= mrYes
    then
    begin
      ShowMessage('Click the Find button, enter 3660 and then enter the beginning balance');
      Exit;
    end;
  End;

  Ret[RetNo].FrmHasData[FNo] := True;
  Ret[RetNo].Changed := True;
  If Table1.Active then Table1.Close;
  Screen.Cursor := crHourGlass;

  //20090711
  CalcFed(RetNo); //twice
  CalcFed(RetNo);
  CalcOnt(RetNo);
  CalcAlb(RetNo);

  Screen.Cursor := crDefault;
  If FormNo>0 then
    MyChild.ShowFormData(FormName,FormNo);
  MainForm.RefreshAuditPanel(RetNo);  //20130602
  MyChild.UpdateChildTaxPanel;

  Close;
end;

procedure TGifiBSEditT2_2027.TreeView1DblClick(Sender: TObject);
Var i:Integer;LineNo:String;SourceNode:TTreeNode;ndx:Integer;Rec:String;
CurrentLineRec,ParentLineRec,GrandParentLineRec:TLineRec;
ValStr,OldValStr:String;x:Real;
begin
  SourceNode:= TreeView1.Selected;
  Ndx :=SourceNode.AbsoluteIndex;
  Rec :=TreeView1.Items[ndx].text;
  LineNo :=LeftStr(Rec,4);
  OldValStr :=AllTrim(RemoveChar(MidStr(Rec,94,15),','));   //20091222 instead of 81
  //20100531
  If LineNo='3660' then
  begin
    If Vl(OldValStr)=0 then OldValStr:=GetLastYearValue('3849');
  end;
  ValStr:= InputBox(MidStr(Rec,1,94),                {20091222 instead of 81}
    'Enter without decimals (to remove enter 0)',OldValStr);
  ValStr:= RemoveChar(ValStr,',');
  EnterValue(LineNo,OldValStr,ValStr,Ndx,True);
end;

procedure TGifiBSEditT2_2027.EnterValue(LineNo,OldValStr,ValStr:String;Ndx:Integer;AllowMsg:Boolean);
Var i:Integer;SourceNode:TTreeNode;Rec:String;
CurrentLineRec,ParentLineRec,GrandParentLineRec:TLineRec;
x:Real;repl:string; //[1];
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

  If (LineNo='1061') and (Vl(ValStr) > GetGifiValFromTree('1060')) then
  begin
    If AllowMsg then ShowMessage('Line 1061 cannot exceed line 1060 (Receivables)');
    exit;
  end;

  If (ValStr>'')
  and (ShouldBeNegative(LineNo,ValStr)) then
  begin
   If AllowMsg then
   begin
    Repl:= InputBox('Line should be negative', 'Make it negative? (y/n)', 'Y');
    If UpperCase(Repl) = 'Y' then ValStr := '-'+ValStr;
   end;
  end;

  //validate amortization
  If IsAmortizationLine(LineNo) then
  begin
   If Abs(Vl(ValStr)) > GetGifiValFromTree(IntToStr(MyStrToInt(LineNo)-1)) then
   begin
    ShowMessage('Amortization on line '+LineNo+' cannot exceed Asset value of $'
     +FormatFloat('########0.00',GetGifiValFromTree(IntToStr(MyStrToInt(LineNo)-1)))+ ' at line '+IntToStr(StrToInt(LineNo)-1));
    ValStr:='0';   //it will post 0
   end;
  end;


  If ValStr>'' then
  begin
   ValStr := JustRight(FormatFloat('###,###,##0',Vl(ValStr)),15);
   TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+ValStr; //20091222
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


Function TGifiBSEditT2_2027.GetLineRec(Lin:String;Var LineRec:TLineRec):Boolean;
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

Function TGifiBSEditT2_2027.GetParent(Lin:String):String;
Var LineRec:TLineRec;
begin
 If GetLineRec(Lin,LineRec) then result := LineRec.Parent;
end;


Procedure TGifiBSEditT2_2027.UpdateTreeParent(PlineNo:String;OldValStr:String;NewValStr:String);
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
     If PlineNo='9999' then Mask:='###,###,##0' else Mask:='###,###,###';
     ValStr :=JustRight(FormatFloat(Mask,x),15);
     If ValStr='' then valStr := FilledStr(15,' ');
     TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+ValStr; //20091222
     Exit;
   end;
  end;
end;

Procedure TGifiBSEditT2_2027.SetValToATreeLine(Ln:String;Val:real);
Var i:Integer;x:Real;ValStr:String;
SourceNode:TTreeNode;ndx:Integer;
begin
  For i:=0 to Treeview1.Items.count-1 do
  begin
   SourceNode:= TreeView1.Items[i];
   Ndx :=SourceNode.AbsoluteIndex;
   If LeftStr(TreeView1.Items[ndx].text,4) = Ln then
   begin
     If Ln='9999' then Mask:='###,###,##0' else Mask:='###,###,###';
     ValStr :=JustRight(FormatFloat(Mask,Val),15);
     If ValStr='' then valStr := FilledStr(15,' ');
     TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+ValStr;  //20091222
     Exit;
   end;
  end;
end;

Function TGifiBSEditT2_2027.GetGifiValFromTree(Ln:String):Real;
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

Procedure TGifiBSEditT2_2027.SaveGifiValToMem(RetNo:Integer;FNo:Integer);
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

 ElmNo:=-1;
 For i:=0 to Treeview1.Items.count-1 do
 begin
   SourceNode:= TreeView1.Items[i];
   Ndx :=SourceNode.AbsoluteIndex;
   If (AllTrim(RightStr(TreeView1.Items[ndx].text,15)) >'')
   or (LeftStr(TreeView1.Items[ndx].text,4)='9999')
   then
   begin
    inc(ElmNo,2);
    if Ret[RetNo].Frm[Fno].Count < ElmNo+2 then
     begin
        Ret[RetNo].Frm[FNo].Add('');
        Ret[RetNo].Frm[FNo].Add('');
     end;
    StoreElm(RetNo,FNo,ElmNo,LeftStr(TreeView1.Items[ndx].text,4));
    StoreElm(RetNo,FNo,ElmNo+1,RemoveChar(RightStr(TreeView1.Items[ndx].text,15),','));
   end;
 end;
end;

procedure TGifiBSEditT2_2027.UsedLinesBtnClick(Sender: TObject);
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

procedure TGifiBSEditT2_2027.GetUsedLines;
Var i:Integer;LineNo:String;SourceNode:TTreeNode;ndx:Integer;Rec:String;
CurrentLineRec,ParentLineRec,GrandParentLineRec:TLineRec;
ValStr,OldValStr:String;x:Real;
begin
 Screen.Cursor := CrHourGlass;
 SomeList.Clear;
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

Procedure TGifiBSEditT2_2027.PrintBS(SomeList:TStringList);
Var FileNm,Hdr1,Hdr2,Hdr3,s:string;
begin
 s:='GIFI Balance Sheet Accounts (Do not submit to CCRA)';
 If SomeList.Count =0 then exit;
 Hdr1 := PaddR(S,60)+' '+PaddR(DateToMonthDayYear(Date),20);
 Hdr2 := GetCorpName(RetNo) + ' - '+ Tabsheet1.Caption;
 Hdr3 := FilledStr(80,'=')+FilledStr(14,'=');
 FileNm:=AppDir+'\'+'TempFile';
 SomeList.SaveToFile(FileNm);
 If PrintDialog1.Execute then
 begin
 If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
  ShowMessage('Printing Completed');
 end;
end;

procedure TGifiBSEditT2_2027.TreeView1KeyPress(Sender: TObject; var Key: Char);
begin
TreeView1DblClick(Sender);
end;

procedure TGifiBSEditT2_2027.RecalcTree;
Var x,y:Real;s:string;FNum:Integer;
begin
   (*  20100531
   If ImportREBox.Checked then
   begin
    x:=vl(GetLastYearValue('3600'));  //ending Ret Earnings
    If x<>0 then SetValToATreeLine('3660',x); //beg ret earnings
   end;
   *)
   x:=TotISNetInc(RetNo);
   SetValToATreeLine('9970',x);

   //20111128
   y:=TotGifiMultiple(RetNo,'GIFIIS','7000')+
      TotGifiMultiple(RetNo,'GIFIIS','7002')+
      TotGifiMultiple(RetNo,'GIFIIS','7004')+
      TotGifiMultiple(RetNo,'GIFIIS','7006')+
      TotGifiMultiple(RetNo,'GIFIIS','7008')+
      TotGifiMultiple(RetNo,'GIFIIS','7010')+
      TotGifiMultiple(RetNo,'GIFIIS','7020');
    SetValToATreeLine('9998',Y);
   (* 20111128
   //comprehensive income
   Fnum:=GetFormNo('GIFIIS#1');
   y:=Vl(FetchGifiElmFNo(RetNo,FNum,'7000'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7002'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7004'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7006'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7008'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7010'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7020'));

   Fnum:=GetFormNo('GIFIIS#2');
   If Fnum>0 then
   begin
   y:=Y+
      Vl(FetchGifiElmFNo(RetNo,FNum,'7000'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7002'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7004'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7006'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7008'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7010'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7020'));
   end;
   Fnum:=GetFormNo('GIFIIS#3');
   If Fnum>0 then
   begin
   y:=Y+
      Vl(FetchGifiElmFNo(RetNo,FNum,'7000'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7002'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7004'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7006'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7008'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7010'))
      +Vl(FetchGifiElmFNo(RetNo,FNum,'7020'));
   end;
   SetValToATreeLine('9998',Y);
  *)

  //20111128
     SetValToATreeLine('9970',TotGifiMultiple(RetNo,'GIFIIS','9970'));

     SetValToATreeLine('9975',TotGifiMultiple(RetNo,'GIFIIS','9975'));
     SetValToATreeLine('9976',TotGifiMultiple(RetNo,'GIFIIS','9976'));
     SetValToATreeLine('9980',TotGifiMultiple(RetNo,'GIFIIS','9980'));
     SetValToATreeLine('9985',TotGifiMultiple(RetNo,'GIFIIS','9985'));
     SetValToATreeLine('9990',TotGifiMultiple(RetNo,'GIFIIS','9990'));
     SetValToATreeLine('9995',TotGifiMultiple(RetNo,'GIFIIS','9995'));
     SetValToATreeLine('9998',TotGifiMultiple(RetNo,'GIFIIS','9998'));



   x :=  GetGifiValFromTree('9970')
        -GetGifiValFromTree('9975')
        -GetGifiValFromTree('9976')
        +GetGifiValFromTree('9980')
        -GetGifiValFromTree('9985')
        -GetGifiValFromTree('9990')
        -GetGifiValFromTree('9995')
        +GetGifiValFromTree('9998');   //20111122  //compreh income
   SetValToATreeLine('9999',x);


  {net income/loss}
  If BsNoBox.ItemIndex = 0 then  {Net inc only in closing BS}
  begin
  // x :=  GetGifiValFromTree('9999'); //20111117
 // x :=  GetGifiValFromTree('9999')+GetGifiValFromTree('9998');  //20111117 comprehensive income
  x :=  GetGifiValFromTree('9999')-GetGifiValFromTree('9998');  //20111117 comprehensive income //20111123
   SetValToATreeLine('3680',x);
  end
  else
    SetValToATreeLine('3680',0);
  {ret earnings end}
  x:= GetParentTotal('3849','BS');
  SetValToATreeLine('3849',x);
  SetValToATreeLine('3600',x);
  {Total S/H equity}
  x:=GetParentTotal('3620','BS');
  SetValToATreeLine('3620',x);
  {tot liab and shareholder}
   x := GetGifiValFromTree('3499')+GetGifiValFromTree('3620');
   SetValToATreeLine('3640',x);
end;

(* Error: It picks up 3400 etc thar are not parents}*)

Procedure TGifiBSEditT2_2027.LoadTreeView(RetNo,FNo:Integer);
Var  i,j:Integer;ValStr:String;Ln,s:String;
   SourceNode:TTreeNode;ndx:Integer;

begin
 Treeview1.Visible := False;
 TreeView1.Color := GetRetColor(RetNo);
 BsNoBox.Color := GetRetColor(RetNo);
 If BSNoBox.ItemIndex =0 then
  Treeview1.LoadFromFile(AppDir+'\'+'GifiBs1.d')
 else
  Treeview1.LoadFromFile(AppDir+'\'+'GifiBs2.d');

 For i:=0 to Treeview1.Items.count-1 do
 begin
    SourceNode:= TreeView1.Items[i];
    Ndx :=SourceNode.AbsoluteIndex;
   // Add 13 to length 20091219
    TreeView1.Items[ndx].text := TreeView1.Items[ndx].text   //20091219
      +FilledStr(66-Length(TreeView1.Items[ndx].text),'.'); //+FilledStr(63-Length(TreeView1.Items[ndx].text),'.');  //20130601
    Ln := LeftStr(TreeView1.Items[ndx].text,4);
    If Ln='9999' then Mask:='###,###,##0' else Mask:='###,###,###';
    s:=JustRight(GetLastYearValue(Ln),15);
    TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,78)  //20091219
      +FilledStr(78-Length(TreeView1.Items[ndx].text),'.')+S;

    ValStr :=JustRight(FormatFloat(Mask,Vl(GetGifiValFromMem(RetNo,FNo,Ln))),15);
    If ValStr='' then valStr := FilledStr(15,' ');
    TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+ValStr; //20091219
  end;
  RecalcTree;
  Treeview1.Visible := True;
  TreeView1.FullCollapse;
end;

procedure TGifiBSEditT2_2027.RecalcBtnClick(Sender: TObject);
begin
 Screen.Cursor := crHourGlass;
 SummarizeGifiTree('BS');
 Screen.Cursor := crDefault;
end;

Procedure TGifiBSEditT2_2027.SummarizeGifiTree(GifiId:String);
Var i,j:Integer;s:string;GifiLines:TStringList;X:Real;
ParentLine,Ln:String;ExplodedList:TStringList;
Parents:TStringList;
begin
 RecalcTree;
 ExplodedList:=TStringList.Create;
 Parents:=TStringList.Create;
 GifiLines := TStringList.Create;
 If GifiId='BS' then
  begin
   If BsNoBox.ItemIndex =0 then
    GifiLines.LoadFromFile(AppDir+'\'+'GifiBs1.d')
   else
    GifiLines.LoadFromFile(AppDir+'\'+'GifiBs2.d')
  end
 else
   GifiLines.LoadFromFile(AppDir+'\'+'GifiIs.d');
 {Get second level parents}
 For i:=0 to GifiLines.Count-1 do
 begin
  If (LeftStr(GifiLines[i],1) = Space(1))
  and (MidStr(GifiLines[i],2,1) > Space(1))
  then
    Parents.Add(LeftStr(GifiLines[i],5));
 end;
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
 For i:=0 to GifiLines.Count-1 do
 begin
  If (LeftStr(GifiLines[i],1) > Space(1)) then
    Parents.Add(LeftStr(GifiLines[i],4));
 end;
 {explode parents}
 For i:=0 to Parents.Count-1 do
 begin
  ExplodedList.Clear;
  ParentLine:= LeftStr(Parents[i],4);
  If ParentLine < '9970' then {real first level}
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
 ExplodedList.Free;
 Parents.Free;
 GifiLines.Free;
end;



Function TGifiBSEditT2_2027.GetParentTotal(ParentLine:String;GifiId:String):Real;
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


Procedure TGifiBSEditT2_2027.GetExplodedGifiList(GifiId:String;ParentLine:String;Var ExplodedList:TStringList);
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

procedure TGifiBSEditT2_2027.FindKeyWBtnClick(Sender: TObject);
Var I,Ndx:integer;InputString,LineNo:String;
   GifiList:TStringList;
   SourceNode:TTreeNode;
begin
 InputString:= InputBox('Enter a key word or Line No', '', 'Cash');
 If Length(AllTrim(InputString)) =0 then exit;

 GifiList := TStringList.Create;
 SomeList.Clear;  // := TStringList.Create; {already defined}
 If BsNoBox.ItemIndex =0 then
   GifiList.LoadFromFile(AppDir+'\'+'GifiBS1.d')
 else
   GifiList.LoadFromFile(AppDir+'\'+'GifiBS2.d');

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

Function TGifiBSEditT2_2027.FindLine(LineNo:String):TTreeNode;
Var i:Integer;SourceNode:TTreeNode;

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

procedure TGifiBSEditT2_2027.BatchEntryBtnClick(Sender: TObject);
Var LineNo,ValStr,OldValStr:String;
SourceNode:TTreeNode;ndx:Integer;Rec:String;
begin
 GifiCallingBatchEntry:= 'BS';
 Repeat
  Application.CreateForm(TGifiBatchEntryT2_2027,GifiBatchEntry);
  GifiBatchEntry.ShowModal;
  LineNo:=LeftStr(GifiBatchEntry.LinesBox.Text,4); //GifiBatchEntry.LineBox.Text;
  CategoryIndexForBatch:=GifiBatchEntry.CategoriesBox.ItemIndex;
  ValStr := GifiBatchEntry.AmountBox.Text;
  If LineNo = '' then Exit; //break;

  SourceNode:=FindLine(LineNo);
  If SourceNode = Nil then
  begin
   ShowMessage('Line '+LineNo+ ' not found');
   exit;
  end;
  Ndx :=SourceNode.AbsoluteIndex;
  Rec :=TreeView1.Items[ndx].text;
  OldValStr :=AllTrim(RemoveChar(RightStr(Rec,15),','));  //20100128
     //AllTrim(RemoveChar(MidStr(Rec,94,15),','));  //20091222 instead of 81
  Treeview1.HotTrack:=False;
  SourceNode.Selected := True;
  TreeView1.TopItem := SourceNode;
  EnterValue(LineNo,OldValStr,ValStr,Ndx,True);
 until LineNo='';
end;

procedure TGifiBSEditT2_2027.PrintBtnClick(Sender: TObject);
{var
  RepFSBS: TRepFSBST2_2027;}
begin
 SaveGifiValToMem(RetNo,FNo);
 Try  //20110308
  {Application.CreateForm(TRepFSBST2_2027,RepFSBS);
  AQrReport := RepFSBS.QuickRep1;
  AQRReport.PrinterSettings.PrinterIndex:= Printer.PrinterIndex;
  AQrReport.Preview;
  RepFSBS.Free;}
 Except
 End;
 Exit;
end;

Function TGifiBSEditT2_2027.ShouldBeNegative(LineNo,ValStr:String):Boolean;
Var i:Integer;TempList:TStringList;x:Real;
begin
 Result :=False;
 x:=Vl(ValStr);
 TempList := TStringList.Create;
 Templist.LoadFromFile(AppDir+'\'+'NegBs.d');
 For i:=0 to TempList.Count-1 do
 begin
  If (LineNo = LeftStr(TempList[i],4))
  and (x>0) then
   begin Result := True;Break;end;
 end;
 TempList.Free;
end;

procedure TGifiBSEditT2_2027.ClearBtnClick(Sender: TObject);
Var  i,j,ElmNo,Ndx:Integer;ValStr:String;
   SourceNode:TTreeNode;
begin
  if MessageDlg('This will remove ALL amounts from the GIFI-BS. Proceed??',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
  ClearGifi;
end;

procedure TGifiBSEditT2_2027.ClearGifi;
Var  i,j,ElmNo,Ndx:Integer;ValStr:String;
   SourceNode:TTreeNode;
begin
  For i:=0 to Treeview1.Items.count-1 do
  begin
    SourceNode:= TreeView1.Items[i];
    Ndx :=SourceNode.AbsoluteIndex;
   TreeView1.Items[ndx].text := LeftStr(TreeView1.Items[ndx].text,93)+Space(15);  //20091222
  end;

 ElmNo:=-1;
 For i:=0 to Treeview1.Items.count-1 do
 begin
   SourceNode:= TreeView1.Items[i];
   Ndx :=SourceNode.AbsoluteIndex;
   inc(ElmNo,2);
   if Ret[RetNo].Frm[FNo].Count < ElmNo+2 then
     begin
        Ret[RetNo].Frm[FNo].Add('');
        Ret[RetNo].Frm[FNo].Add('');
     end;
   StoreElm(RetNo,FNo,ElmNo,'');
   StoreElm(RetNo,FNo,ElmNo+1,'');
 end;
 FormCreate(Application);

end;


procedure TGifiBSEditT2_2027.ImportBtnClick(Sender: TObject);
Var i,FNo,ElmNo:Integer;ImportList,WList:TStringList;
    FLName:String;
    LineNo,ValStr,OldValStr:String;
    SourceNode:TTreeNode;ndx:Integer;Rec:String;
    xInt:LongInt; x:real;
begin
 if MessageDlg('This will replace ALL amounts in the GIFI-BS. Proceed??',
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

procedure TGifiBSEditT2_2027.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{CancelBtnClick(Sender);}
end;

procedure TGifiBSEditT2_2027.BitBtn1Click(Sender: TObject);
begin
ShowPdf(AppDir,'RC4088.pdf');
end;

procedure TGifiBSEditT2_2027.LastYrBtnClick(Sender: TObject);
Var i,j:Integer;LineDescr:String;
begin
 SomeList.Clear;  // := TStringList.Create;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName = 'LASTYRBS' then
   begin
    j:=1;
    Repeat
     LineDescr:=GetLineDescription(FetchElmFNo(RetNo,Frec.FormNo,j));
     If FetchElmFNo(RetNo,Frec.FormNo,j+1)>'' then
       SomeList.Add(PaddR(LineDescr,60)
         +' $'+FormatFloat('###,###,###.##',Vl(FetchElmFNo(RetNo,Frec.FormNo,j+1))));
     Inc(j,2);
    Until j>FieldsLimit-3;
   End;
 end; //i
 If SomeList.Count=0 then
 begin
   ShowMessage('No data found. It is captured in the Rollover process');
   //SomeList.Free; //20160704 Igor
   Exit;
 end;
 SomeList.Sorted :=True;
 SomeCaption:='Last year GIFI Balance Sheet amounts';
  SelectedString := PopSomeList(SomeList,SomeCaption);
 SomeList.Clear;  //.Free;
end;

Function TGifiBSEditT2_2027.GetLineDescription(LineNo:String):String;
Var SourceNode:TTreeNode;ndx:Integer;Rec:String;
Begin
  SourceNode:=FindLine(LineNo);
  If SourceNode = Nil then
    Result:='*** LINE NOT FOUND ***'
  else
  begin
   Ndx :=SourceNode.AbsoluteIndex;
   Rec :=TreeView1.Items[ndx].text;
   Result:=Rec;
  end;
end;

Function TGifiBSEditT2_2027.GetLastYearValue(Ln:String):String;
Var limit, i,FNo:Integer;
begin
  Result := GetLastYearLnValue(RetNo,Ln,'LASTYRBS#1');
end;




end.


