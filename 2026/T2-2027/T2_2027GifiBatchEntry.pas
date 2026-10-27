unit T2_2027GifiBatchEntry;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ComCtrls,Buttons,ExtCtrls,T2_2027Declare,T2_2027TrimStr;
  //,T2_2013PopList;

type
  TGifiBatchEntryT2_2027 = class(TForm)
    AmountBox: TEdit;
    Label2: TLabel;
    Panel3: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    LinesBox: TComboBox;
    Label4: TLabel;
    CategoriesBox: TComboBox;
    Label1: TLabel;
    FindKeyWBtn: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    LastYrAmountBox: TEdit;
    LineDescrLbl: TLabel;
    Label5: TLabel;
    Label8: TLabel;

    Procedure SelectLines(FromLine,ToLine:String);
   // procedure CategoriesGroupClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ShowLineDescr(LineNo:String);
    procedure LineBoxExit(Sender: TObject);
    procedure LineBoxKeyPress(Sender: TObject; var Key: Char);
    procedure AmountBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure LinesBoxKeyPress(Sender: TObject; var Key: Char);
  //  procedure LinesBoxClick(Sender: TObject);
    procedure LinesBoxEnter(Sender: TObject);
    procedure CategoriesBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FindKeyWBtnClick(Sender: TObject);
    procedure AmountBoxEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GifiBatchEntry: TGifiBatchEntryT2_2027;
  Lin:String;
  Amount:String;
  OldCategoryIndex: Integer;

implementation

{$R *.DFM}

uses vtTrimStr,vtDialogs,T2_2027main,{T2_2027GifiBsEdit,T2_2027GifiIsEdit};

procedure TGifiBatchEntryT2_2027.CancelBtnClick(Sender: TObject);
begin
 GifiBatchEntry.LinesBox.Text:=''; //LineBox.Text:='';  //20090607
 AmountBox.Text:='';
 Close;
end;

procedure TGifiBatchEntryT2_2027.OKBtnClick(Sender: TObject);
Var LineNo:String;
TempList:TStringList;
begin
 TempList:=TsTringList.Create;
 If GifiCallingBatchEntry ='IS' THEN
  TempList.LoadFromFile(AppDir+'\'+'GIFIIS.d')
 Else If GifiCallingBatchEntry ='BS' THEN
  TempList.LoadFromFile(AppDir+'\'+'GIFIBS.d');

 LineNo:=LeftStr(LinesBox.Text,4);  //LineBox.Text; 20090607
 If LineNo='' then
 begin
  ShowMessage('GIFI Line was not entered');
  TempList.Free;
  LinesBox.SetFocus;
  Exit;
 end;

 If IsInList(LineNo,TempList) <0 then
 begin
  ShowMessage('GIFI Line was not found');
  TempList.Free;
  LinesBox.SetFocus;
  Exit;
 end;

 If AmountBox.text='' then
 begin ShowMessage('Amount was not entered');
  TempList.Free;
  AmountBox.SetFocus;Exit;
 end;

 //ShowLineDescr(LineNo);

 TempList.Free;
 Close;
 //ShowTimedMsg('Done',1200);
end;

procedure TGifiBatchEntryT2_2027.ShowLineDescr(LineNo:String);
Var SourceNode:TTreeNode;ndx:Integer;Rec:String;
begin
 If GifiCallingBatchEntry ='IS' THEN
 BEGIN
  SourceNode:=GifiIsEdit.FindLine(LineNo);
  If SourceNode = Nil then
    LineDescrLbl.Caption:='*** LINE NOT FOUND ***'
  else
  begin
   Ndx :=SourceNode.AbsoluteIndex;
   Rec :=GifiIsEdit.TreeView1.Items[ndx].text;
   LineDescrLbl.Caption:=Rec;
  end;
 END
 Else If GifiCallingBatchEntry ='BS' THEN
 BEGIN
   SourceNode:=GifiBSEdit.FindLine(LineNo);
  If SourceNode = Nil then
    LineDescrLbl.Caption:='*** LINE NOT FOUND ***'
  else
  begin
   Ndx :=SourceNode.AbsoluteIndex;
   Rec :=GifiBSEdit.TreeView1.Items[ndx].text;
   LineDescrLbl.Caption:=Rec;
  end;
 END;
end;


procedure TGifiBatchEntryT2_2027.LineBoxExit(Sender: TObject);
begin
 ShowLineDescr(LeftStr(LinesBox.Text,4));
end;

procedure TGifiBatchEntryT2_2027.LineBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then
  Begin
    If HiWord(GetKeyState(VK_SHIFT)) <> 0 then
     SelectNext(Sender as TWinControl,False,True)
    else
     SelectNext(Sender as TWinControl,True,True) ;
    Key := #0;
   end;
end;

procedure TGifiBatchEntryT2_2027.AmountBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 Then
 Begin
    If HiWord(GetKeyState(VK_SHIFT)) <> 0 then
     SelectNext(Sender as TWinControl,False,True)
    else
     SelectNext(Sender as TWinControl,True,True) ;
    Key := #0;
 end;
end;


Procedure TGifiBatchEntryT2_2027.SelectLines(FromLine,ToLine:String);
Var i:Integer;TempList:TStringList;
begin
 SomeList.Clear;  //:=TStringList.Create;
 TempList:=TStringList.Create;

 If GifiCallingBatchEntry ='IS' THEN
  TempList.LoadFromFile(AppDir+'\'+'GIFIIS.d')
 Else If GifiCallingBatchEntry ='BS' THEN
  TempList.LoadFromFile(AppDir+'\'+'GIFIBS.d');

 For i:=0 to TempList.count-1 do
 begin
  If (LeftStr(AllTrim(TempList[i]),4) >= FromLine)
  and (LeftStr(AllTrim(TempList[i]),4) <= ToLine) then SomeList.Add(AllTrim(TempList[i]));
 end;
 If FromLine='3460' then SomeList.add('3470 Amounts held in trust');
 TempList.Free;
end;

procedure TGifiBatchEntryT2_2027.FormCreate(Sender: TObject);
begin
 If GifiCallingBatchEntry ='IS' THEN
 BEGIN
  CategoriesBox.Items.Add('Sales of goods and Services');
  CategoriesBox.Items.Add('Other Revenue');
  CategoriesBox.Items.Add('Cost of Sales');
  CategoriesBox.Items.Add('Operating Expenses');
  CategoriesBox.Items.Add('Farming Income');
  CategoriesBox.Items.Add('Farming Expenses');
  CategoriesBox.ItemIndex:=GifiIsEdit.CategoryIndexForBatch;
 END
 Else If GifiCallingBatchEntry ='BS' THEN
 Begin
  CategoriesBox.Items.Add('Current Assets');
  CategoriesBox.Items.Add('Tangible Capital Assets');
  CategoriesBox.Items.Add('Intangible Capital Assets');
  CategoriesBox.Items.Add('Long Term Assets');
  CategoriesBox.Items.Add('Assets held in trust');
  CategoriesBox.Items.Add('Current Liabilities');
  CategoriesBox.Items.Add('Long Term Liabilities');
  CategoriesBox.Items.Add('Other Liabilities');
  CategoriesBox.Items.Add('Shareholder Equity');
  CategoriesBox.Items.Add('Retained Earnings');
  CategoriesBox.Items.Add('Other Items and Income Tax');
  CategoriesBox.ItemIndex:=GifiBSEdit.CategoryIndexForBatch;
 END;
// CategoriesBox.ItemIndex:=0;
end;

procedure TGifiBatchEntryT2_2027.LinesBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key = #13 Then
  Begin
    If HiWord(GetKeyState(VK_SHIFT)) <> 0 then
     SelectNext(Sender as TWinControl,False,True)
    else
     SelectNext(Sender as TWinControl,True,True) ;
    Key := #0;
  end;

end;


procedure TGifiBatchEntryT2_2027.LinesBoxEnter(Sender: TObject);
Var i:Integer; //inserts selected into somelist
begin
 LinesBox.Items.Clear;
 If GifiCallingBatchEntry ='IS' THEN
 BEGIN
  Case CategoriesBox.itemIndex+1 of
   1: SelectLines('8000','8053');  //Into some list
   2: SelectLines('8090','8250');
   3: SelectLines('8300','8503');
   4: SelectLines('8520','9286');
   5: SelectLines('9370','9650');
   6: SelectLines('9660','9870');
   else
    //Exit;
  end; //case
  If CategoriesBox.Text='' then SelectLines('8000','9870');
 end
 Else If GifiCallingBatchEntry ='BS' THEN
 BEGIN
  Case CategoriesBox.itemIndex+1 of
   1: SelectLines('1000','1486');  //Into some list
   2: SelectLines('1600','1922');
   3: SelectLines('2010','2077');
   4: SelectLines('2180','2427');
   5: SelectLines('2590','2590');
   6: SelectLines('2600','2966');
   7: SelectLines('3140','3328');
   8: SelectLines('3460','3460');
   9: SelectLines('3500','3600');
   10: SelectLines('3660','3745');
   11: SelectLines('9970','9999');
   else
    //Exit;
  end; //case
  If CategoriesBox.Text='' then SelectLines('1000','9999');
 end;
 SomeList.Sorted:=True;
 For i:=0 to SomeList.Count-1 do LinesBox.items.add(Somelist[i]);
 //SomeList.Free; //20160704 Igor
 LinesBox.Refresh;
end;

procedure TGifiBatchEntryT2_2027.CategoriesBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key = #13 Then
  Begin
    If HiWord(GetKeyState(VK_SHIFT)) <> 0 then
     SelectNext(Sender as TWinControl,False,True)
    else
     SelectNext(Sender as TWinControl,True,True) ;
    Key := #0;
  end;
end;

procedure TGifiBatchEntryT2_2027.FindKeyWBtnClick(Sender: TObject);
Var I,Ndx:integer;InputString,LineNo:String;
   GifiList:TStringList;
  // SourceNode:TTreeNode;
begin
 InputString:= InputBox('Enter a key word or Line No', '', 'Sales');
 If Length(AllTrim(InputString)) =0 then exit;

 GifiList := TStringList.Create;
 SomeList.Clear;  // := TStringList.Create; {already defined}
 If GifiCallingBatchEntry ='IS' THEN
  GifiList.LoadFromFile(AppDir+'\'+'GIFIIS.d')
 Else If GifiCallingBatchEntry ='BS' THEN
  GifiList.LoadFromFile(AppDir+'\'+'GIFIBS.d');
 For i:=0 to GifiList.Count-1 do
 begin
  If FindWord(InputString,GifiList[i])>0 then
    SomeList.Add(GifiList[i]);
 end;
 GifiList.Free;
  SelectedString := PopSomeList(SomeList,'Entries with keyword: '+InputString);
 //SomeList.Free; //20160704 Igor

 If SelectedString > '' then
 begin
  LinesBox.Text:=SelectedString;
  SelectNext(Sender as TWinControl,True,True) ;
 end;

end;

procedure TGifiBatchEntryT2_2027.AmountBoxEnter(Sender: TObject);
begin
 If GifiCallingBatchEntry ='IS' THEN
  LastYrAmountBox.Text:=GifiISEdit.GetLastYearValue(LeftStr(LinesBox.Text,4))
 Else
  LastYrAmountBox.Text:=GifiBSEdit.GetLastYearValue(LeftStr(LinesBox.Text,4));
end;

end.
