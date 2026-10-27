unit T1_2026AutoFillPrintl;
//introduced //20160327
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, DB, DBTables, FileCtrl;  //20160327

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

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AutoFillPrintT1_2026: TAutoFillPrintT1_2026;
  FileNm,FileNm2:String;
  TddElmsTable:TTable;

implementation

{$R *.DFM}
uses
  T1_2026Main, vtMain,
  T1_2026TrimStr, vtTrimStr, T1_2026Declare,T1_2026ChildWinNEW,T1_2026DFiles,
  T1_2026T1Rtns,
  //UPopList,
  T1_2026T1Rtns2,
  vtCommon;
procedure TAutoFillPrintT1_2026.FormCreate(Sender: TObject);
Var s:String;h:Word;
  i:integer;F1,PrnFile: TextFile;
  TempList:TStringList;
  Hdr1,Hdr2,Hdr3:String;
begin
 FileListBox1.Directory := TddFilesDir;
 FileListBox1.Mask := '*.Txt';
 FileListBox1.ItemIndex :=0;
 FileNm := FileListBox1.Items[FileListBox1.ItemIndex];
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


procedure TAutoFillPrintT1_2026.FileListBox1Click(Sender: TObject);
Var s:String;h:Word;
  i:integer;F1,PrnFile: TextFile;
  TempList:TStringList;
  Section,SubSection,DataElmName,BoxNo,Instance,Value,FieldKey:String;
  PrevItem:String;
begin
 ListBox1.Items.clear;
 HorScrollBarInListBox(ListBox1,900);
 FileNm := FileListBox1.Items[FileListBox1.ItemIndex];
 TempList:=TStringList.create;
 TempList.Sorted:=True;
 TempList.LoadFromFile(FileNm);

 OpenTheTddElmsTable;

 PrevItem:='';
 For i:=0 To TempList.Count-1 do
 begin
  s:=TempList[i];
  Section:=AllTrim(LeftStr(s,45));
  SubSection:=AllTrim(MidStr(S,46,35));
  DataElmName:=AllTrim(MidStr(S,81,60));
  Instance:=AllTrim(MidStr(S,141,2));
  If IsDataGroupASlip(SubSection) then
    Instance:='#'+RmvLeadingZeros(Instance)
  Else
    Instance:='';
  Value:=AllTrim(MidStr(S,144,100));

   //get the rest from the tddElms data base i.e boxno
  FieldKey:=SubSection+'-'+DataElmName;
  BoxNo:='';
  s:=PaddR(LeftStr(Section,30)+'-'+SubSection,50)+' '+PaddR(BoxNo,3)+' '+PaddR(DataElmName,30)+' '+PaddR(Instance,4)+' '+Value;

  If FilterBox.ItemIndex=0 then
  Begin
    If LeftStr(S,5)='Slips' then
    Begin
     If (LeftStr(S,20)>PrevItem) then begin ListBox1.Items.Add(' ');PrevItem:=LeftStr(S,20);end;
     ListBox1.Items.Add(s);  //listbox1 is in courier true
    end;
  end
  Else
  Begin
    If LeftStr(S,20)>PrevItem then begin ListBox1.Items.Add(' ');PrevItem:=LeftStr(S,20);end;
    ListBox1.Items.Add(s);  //listbox1 is in courier true
  end;
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
