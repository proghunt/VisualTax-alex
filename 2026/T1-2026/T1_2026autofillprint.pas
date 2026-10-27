unit T1_2026AutoFillPrint;
//introduced //20160327
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, DB, DBTables, {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON};  //20160327

type
  TAutoFillPrintT1_2026 = class(TForm)
    Panel2: TPanel;
    Panel4: TPanel;
    ExitBtn: TBitBtn;
    PrintBtn: TBitBtn;
    OpenDialog: TOpenDialog;
    PrintDialog1: TPrintDialog;
    Panel1: TPanel;
    ListBox1: TListBox;
    FileListBox1: TFileListBox;
    FilterBox: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure FilterBoxClick(Sender: TObject);
   // procedure OpenTheTddElmsTable;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AutoFillPrintT1_2026: TAutoFillPrintT1_2026;
  FileNm,FileNm2:String;
  RNo:Integer;

 // TddElmsTable:TTable;   //relocated to uDeclare

implementation

{$R *.DFM}
uses
  T1_2026Main, vtMain,
  T1_2026TrimStr, vtTrimStr, T1_2026Declare,T1_2026ChildWinNEW,T1_2026DFiles,
  T1_2026T1Rtns,
  //UPopList,
  T1_2026T1Rtns2,
  vtCommon,
  T1_2026; //20170222 Igor
procedure TAutoFillPrintT1_2026.FormCreate(Sender: TObject);
Var s:String;h:Word;
  i:integer;F1,PrnFile: TextFile;
  TempList:TStringList;
  Hdr1,Hdr2,Hdr3:String;
  AutoFillFileName:String;
  RetFound: Boolean;
begin
 OpenTheTddElmsTable;
 FileListBox1.Directory := OptRec.Dir_AutoFill; //20170222 Igor
 FileListBox1.Mask := '*.Txt';

 RetFound:=False;
 RNo:=GetCurrentRetNo;
 FileListBox1.ItemIndex :=0;
 If RNo>0 then
 Begin
  AutoFillFileName:=UpperCase(ExtractFileName(MkTddFileName(RNo,GetSinNo(RNo))));
  For i:=0 to FileListBox1.items.count-1 do
  Begin
   If AutoFillFileName=UpperCase(FileListBox1.items[i]) then
   Begin
    FileListBox1.ItemIndex:=i;
    RetFound:=True;
    Break;
   End;
  end;
  If retFound=False then
  begin
   ShowMessage('The Auto-fill My Return received file '+AutoFillFileName+' was not found');
   FileListBox1.ItemIndex:=0;
   exit; //20160505 Igor
  end;
 end;
 FileListBox1Click(Sender);
end;


procedure TAutoFillPrintT1_2026.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TAutoFillPrintT1_2026.PrintBtnClick(Sender: TObject);
Var  Hdr1,Hdr2,Hdr3:String;
begin
 Hdr1 := Space(30)+'Auto-fill data '+FileNm;
 Hdr2 := ' ';
 Hdr3 := ' ';

 If PrintAListing(FileNm2,Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
end;

procedure TAutoFillPrintT1_2026.FilterBoxClick(Sender: TObject);
begin
 FileListBox1Click(Sender);
end;

(*  //20160327 relocated to TrimStr
procedure TAutoFillPrintT1_2026.OpenTheTddElmsTable;
begin
 TddElmsTable := TTable.Create(Application);
 TddElmsTable.DataBaseName := AppDir;
 TddElmsTable.TableName := 'TddElms.dbf';
 TddElmsTable.IndexName := 'FieldKey';      //Subsection-and-data element
 If TddElmsTable.Active then TddElmsTable.Close;
 If not TddElmsTable.Active then TddElmsTable.Open;
end;
*)
procedure TAutoFillPrintT1_2026.FileListBox1Click(Sender: TObject);
Var s:String;h:Word;
  i:integer;F1,PrnFile: TextFile;
  TempList:TStringList;
  Section,SubSection,DataElmName,BoxNo,Instance,Value,FieldKey:String;
  PrevItem:String;
  A: TArray<string>; //20210309 Igor
begin
 if FileListBox1.Count = 0 then exit;
 ListBox1.Items.clear;
 MainFormT1.SetHorScrollBarInListBox(ListBox1,900);
 FileNm := FileListBox1.Items[FileListBox1.ItemIndex];
 TempList:=TStringList.create;
 //TempList.Sorted:=True;
 TempList.LoadFromFile(FileNm);

 PrevItem:='';
 For i:=0 To TempList.Count-1 do
 begin
  s:=TempList[i];
  //20210309 Igor >>>
  A := s.Split([AFRStringDelimiter]);
  if Length(A) >= 5 then
  begin
    Section:=AllTrim(A[0]);
    SubSection:=AllTrim(A[1]);
    DataElmName:=AllTrim(A[2]);
    Instance:='';  // AllTrim(A[3]);
    Value:=AllTrim(A[4]);
  end
  else
  begin
    Section:=AllTrim(LeftStr(s,45));
    SubSection:=AllTrim(MidStr(S,46,35));
    DataElmName:=AllTrim(MidStr(S,81,60));


    Instance:='';  // AllTrim(MidStr(S,141,2));
     {
    If IsDataGroupASlip(SubSection) then
      Instance:='#'+RmvLeadingZeros(Instance)
    Else
      Instance:='';

    }

    Value:=AllTrim(MidStr(S,144,100));
  end;
  //20210309 Igor <<<

   //get the rest from the tddElms data base i.e boxno
  FieldKey:=SubSection+'-'+DataElmName;
  BoxNo:='';

  If FieldKey<>'-' then
  Begin
   If TddElmsTable.FindKey([FieldKey]) = True then
     BoxNo:=TddElmsTable.FieldByName('BoxNo').AsString;
  end;

   s:=PaddR(AllTrim(Section)+'-'+AllTrim(SubSection)+'-'+AllTrim(DataElmName),50)+'  '+PaddR(BoxNo,3)+' '+PaddR(Instance,4)+' '+Value;
  //s:=PaddR(LeftStr(Section,30)+'-'+SubSection,40)+' '+PaddR(BoxNo,3)+' '+PaddR(DataElmName,30)+' '+PaddR(Instance,4)+' '+Value;

  If FilterBox.ItemIndex=0 then
  Begin
    If LeftStr(S,5)='Slips' then
    Begin
     If AllTrim(DataElmName)='TaxYear' then begin ListBox1.Items.Add(' ');{PrevItem:=AllTrim(LeftStr(S,20));}end;
     ListBox1.Items.Add(s);  //listbox1 is in courier true
    end;
  end
  Else
  Begin
    If LeftStr(S,5)='Slips' then
    Begin
     If AllTrim(DataElmName)='TaxYear' then begin ListBox1.Items.Add(' ');{PrevItem:=AllTrim(LeftStr(S,20));}end;
    end
    Else
    Begin
     If (AllTrim(LeftStr(S,20))>AllTrim(PrevItem)) then begin ListBox1.Items.Add(' ');PrevItem:=AllTrim(LeftStr(S,20));end;
    end;
    ListBox1.Items.Add(s);  //listbox1 is in courier true
  end;
  {
   s:=PaddR(Section,40)+' '+PaddR(SubSection,30)+' '+PaddR(DataElmName,40)+' '+PaddR(Instance,2)+Value;
   s:=PaddR(MidStr(TempList[i],46,35),35)+MidStr(TempList[i],81,150);
   ListBox1.Items.Add(s);  //listbox1 is in courier true
  }
 end;
 {open output file}
 FileNm2:=AppDir+'\'+'TempFile';
 AssignFile(F1,FileNm2);
 Rewrite(F1);
 For i:=0 To ListBox1.Items.Count-1 do WriteLn(F1,ListBox1.Items[i]);
 CloseFile(F1);
 TempList.free;
end;


end.
