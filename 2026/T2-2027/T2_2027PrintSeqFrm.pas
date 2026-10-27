unit T2_2027PrintSeqFrm;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,DB,Grids,DBGrids,ExtCtrls,DBCtrls,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TPrintSeqFrmT2_2027 = class(TForm)
    Panel2: TPanel;
    TextRelatedPanel: TPanel;
    Label2: TLabel;
    FlBox: TEdit;
    PrintBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    ListBox1: TListBox;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    FindBtn: TBitBtn;
    Label1: TLabel;
    SaveBtn: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;

    Function  IsFnameInList(AString:String;AList:TStringList):Integer;
    Procedure OpenTheScrDB;
    procedure SaveIt;
    Function  GetSeqFromDb(FName:String):String;
    Procedure RepositionForDisplay;
    Procedure RenumSeq;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FindBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintSeqFrm: TPrintSeqFrmT2_2027;
  StartingPoint : TPoint;
  //rem 20150915 Igor
  //ADConnection: TADConnection;
  //Table1: TADTable;


implementation

{$R *.DFM}

uses vtDialogs,T2_2027Declare,T2_2027Common,T2_2027TrimStr,
     T2_2027CALC,T2_2027ChildWinNew, vtTrimStr, vtShared, vtDataBase;

procedure TPrintSeqFrmT2_2027.CancelBtnClick(Sender: TObject);
begin
 If ListBox1.Items.count=0 then
 begin
  If FileExists(FlBox.text) then SysUtils.DeleteFile(FlBox.Text);
 end;
 Table1.free;
 Close;
end;

procedure TPrintSeqFrmT2_2027.FormCreate(Sender: TObject);
 Var i,ListNdx:integer;S,S1,S2:string;TempList:TStringList;
 FName:String;
begin
 ListBox1.Sorted:=False;
 ListBox1.DragMode := dmAutomatic;
 OpenTheScrDb;

 If FlBox.text='' then FlBox.Text:=AppDir+'\'+'PrintSeq.Txt';
 TempList:=TStringList.Create;
 //20110218
 If FileExists(FlBox.text) then
 begin
  //fffff       sss
  //show from exising txt file
  TempList.LoadFromFile(FlBox.text);
  For i:=0 to TempList.count-1 do
  Begin
   FName:=AllTrim(LeftStr(TempList[i],15));
   If GetSeqFromDB(FName) >'' then ListBox1.items.Add(TempList[i]);
  end;
 end
 Else
 Begin   //pickup from T1Scr.db
  while not Table1.EOF do
  begin
    If  (Table1.FieldByName('FormName').AsString > '')
    and (AllTrim(Table1.FieldByName('PRNSEQ').AsString) > '')
    then
    begin
     //sss       ffffff
     S1 :=Table1.FieldByName('PrnSeq').AsString;
     S2:=Table1.FieldByName('FormName').AsString;
     s :=PaddR(S2,15)+PaddR(s1,15);
     ListBox1.Items.Add(s);
    end;
    Table1.Next;
  end;
  Table1.Close;
 end;
 TempList.Free;
 RepositionForDisplay;
 RenumSeq;
 If ListBox1.Items.count>0 then ListBox1.ItemIndex:=0;
end;

procedure TPrintSeqFrmT2_2027.SaveBtnClick(Sender: TObject);
begin
 SaveIt;
 ShowTimedMsg('Saved/Applied',1000);
end;


procedure TPrintSeqFrmT2_2027.SaveIt;
//put it back in fffff(15)   sss(3)
Var i:Integer;
TempList:TStringList;
begin
 TempList:=TStringList.Create;
 For i:=0 to ListBox1.Items.count-1 do
 Begin
  TempList.Add(ListBox1.Items[i]);
  ListBox1.Items[i]:=PaddR(MidStr(ListBox1.Items[i],16,15),15)+LeftStr(ListBox1.Items[i],15)
 end;
 //20100218
 ListBox1.Items.SaveToFile(FlBox.text);
 ListBox1.clear;
 For i:=0 to TempList.Count-1 do begin ListBox1.Items.add(TempList[i]);end;
 TempList.Free;
end;


procedure TPrintSeqFrmT2_2027.PrintBtnClick(Sender: TObject);
Var i:integer;FileNm,Hdr1,Hdr2,Hdr3:string; F1:textFile; S:string;
TempList1,TempList2:TstringList;
begin
 FileNm := FlBox.Text;
 If not fileExists(FlBox.Text) then
 begin
  ShowMessage('Print Sequence file does not exit');
  exit;
 end;

 Hdr1 := PaddR('PRINT SEQUENCE - File Name:',30)+
         PaddR(UpperCase(FlBox.Text),30)+PaddR(DateToMonthDayYear(Date),20);

 Hdr2:=' ';
 (*
 Hdr2 := PaddR('FORM',8)
         +PaddR('DESCRIPTION',30)+'   '
         +PaddR('How Charged',18)
         +PaddR('1stForm',8)
         +PaddR('+More',7)
         +PaddR('PerItem',8);
         Hdr3 := FilledStr(81,'=');
 *)
 TempList1:=TStringList.Create;
 TempList2:=TStringList.Create;
 TempList1.LoadFromFile(FlBox.Text);
 For i:=0 to templist1.count-1 do
 begin
  s:=LeftStr(TempList1[i],38)+'  '+MidStr(TempList1[i],39,50);
  TempList2.Add(S);
 end;
 TempList2.SaveToFile(AppDir+'\'+'Temp.txt');
 TempList1.Free;
 TempList2.Free;

 If PrintDialog1.Execute then
 begin
  If PrintAListing(AppDir+'\'+'Temp.txt',Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
 end;

end;


procedure TPrintSeqFrmT2_2027.ListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    DropPosition, StartPosition: Integer;
    DropPoint: TPoint;
 begin
    DropPoint.X := X;
    DropPoint.Y := Y;
    with Source as TListBox do
    begin
      StartPosition := ItemAtPos(StartingPoint,True) ;
      DropPosition := ItemAtPos(DropPoint,True) ;

      Items.Move(StartPosition, DropPosition) ;
    end;
    RenumSeq;
    ListBox1.Update;  //Refresh;
end;

procedure TPrintSeqFrmT2_2027.ListBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
 (*
 //If (y>ListBox1.Height-10) then SendMessage(ListBox1.Handle, WM_VScroll, SB_LINEDOWN, 0); //20110217
 If (y > ListBox1.Height-10) then SendMessage(ListBox1.Handle, WM_VScroll, SB_LINEDOWN, 0); //20110217
 If (y < ListBox1.Top-10) then SendMessage(ListBox1.Handle, WM_VScroll, SB_LINEUP, 0); //20110217
 //SB_PAGEDOWN
 *)
 Accept := Source = ListBox1;
end;

procedure TPrintSeqFrmT2_2027.ListBox1MouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var NewSeqNo:String;CurrentLineText:String;
begin
 StartingPoint.X := X;
 StartingPoint.Y := Y;
end;

Procedure TPrintSeqFrmT2_2027.RenumSeq;
Var s:String; i,Seq:Integer;
begin
 ListBox1.Sorted:=True;
 Seq:=0;
 For i:=0 to ListBox1.Items.count-1 do
 begin
   s:=ListBox1.Items[i];
   Inc(Seq);
   s:=PaddR(AddLeadingZeros(IntToStr(Seq),3),15)+MidStr(S,16,50);
   ListBox1.Items[i]:=s;
 end;
end;

Procedure TPrintSeqFrmT2_2027.RepositionForDisplay;
//Seq(15) and FormNm(15)   The disk file is Form(15) followed by Seq(3)
Var s:String; i,Seq:Integer;
Begin
 For i:=0 to ListBox1.Items.count-1 do
 begin
  s:=ListBox1.Items[i];
  s:=PaddR(MidStr(ListBox1.Items[i],16,3),15)+LeftStr(ListBox1.Items[i],15);
  ListBox1.Items[i]:=S;
 end;
end;


procedure TPrintSeqFrmT2_2027.FindBtnClick(Sender: TObject);
Var i,j:Integer;FName:String;TempList:TStringList;
begin
 TempList:=TStringList.Create;
 For i:=0 to ListBox1.Items.count-1 do TempList.Add(ListBox1.Items[i]);
 FName:= InputBox('Input Box', 'Enter form name', '');
 i:=IsFNameInList(FName,TempList);
 If i >-1 then ListBox1.ItemIndex:=i else ShowMessage(FName + ' not found');
 TempList.Free;
end;


Procedure TPrintSeqFrmT2_2027.OpenTheScrDB;
Begin
  SetTableName(FDConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormName');
  Table1.First;
end;

Function TPrintSeqFrmT2_2027.GetSeqFromDb(FName:String):String;
begin
 Result:='';
 If Table1.FindKey([FName]) then result:=Table1.FieldByName('PrnSeq').AsString;
end;

procedure TPrintSeqFrmT2_2027.ListBox1DblClick(Sender: TObject);
Var CurrentLineText,FName:String; NewSeqNo:String; i,ndx,INewSeqNo:Integer;Templist:TStringList;
begin
 //20100218
  If ListBox1.ItemIndex < 0 then
  begin
    //ShowMessage('First highlight a line and then Right Click it');
    Exit;
  end;

   CurrentLineText:=ListBox1.Items[ListBox1.ItemIndex];
   NewSeqNo:= InputBox('Input a new Sequence Number (1 to 999)',CurrentLineText, '10');
   If Vl(NewSeqNo)=0 then exit;
   NewSeqNo:=LeftStr(NewSeqNo,3);
   ListBox1.Sorted:=False;
   iNewSeqNo:=MyStrToInt(NewSeqNo);
   ndx:=ListBox1.ItemIndex+1;  //item start at 0
   If iNewSeqNo < ndx then
     NewSeqNo:=IntToStr(iNewSeqNo-1)
   Else If iNewSeqNo > ndx then
     NewSeqNo:=IntToStr(iNewSeqNo+1); 
   NewSeqNo:= AddLeadingZeros(NewSeqNo,3);
   CurrentLineText:=NewSeqNo+MidStr(CurrentLineText,4,20);
   FName:=ALLTrim(MidStr(CurrentLineText,4,20));
   ListBox1.Items[ListBox1.ItemIndex]:=CurrentLineText;
   RenumSeq;
   ListBox1.Update;
   //Now position in the form
   TempList:=TStringList.Create;
   For i:=0 to ListBox1.Items.count-1 do TempList.Add(ListBox1.Items[i]);
   i:=IsFNameInList(FName,TempList);
   If i >-1 then ListBox1.ItemIndex:=i else ShowMessage(FName + ' not found');
   TempList.Free;
end;

Function TPrintSeqFrmT2_2027.IsFnameInList(AString:String;AList:TStringList):Integer;
Var i,j,LengthOfFName:Integer;
Begin
   Result:=-1;
   AString:=UpperCase(AllTrim(AString));
   LengthOfFName:=Length(AString);
   For i := 0 to AList.Count-1 do
   begin
    j:=Pos(AString,UpperCase(AList[i]));
    If j>0 then
    begin
      Result:=i;
      Exit;
    end;
   end;
End;


procedure TPrintSeqFrmT2_2027.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//If Key=
end;

end.
