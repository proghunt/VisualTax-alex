unit T3_2026FindALine;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons;

type
  TFindALineT3_2026 = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    ListBox1: TListBox;
    Panel4: TPanel;
    Label2: TLabel;
    EditBtn: TBitBtn;
    ExitBtn: TBitBtn;
    KeyWBox: TEdit;
    Label5: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    FormBox: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    SectionBox: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure LineBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FindLineNo(LineNo:String);
    procedure ListBox1DblClick(Sender: TObject);
    procedure OpenIt(FName:String;Elm:Integer);
    procedure EditBtnClick(Sender: TObject);
    procedure KeyWBoxKeyPress(Sender: TObject; var Key: Char);
   // procedure LoadEfFields;
    procedure FormBoxKeyPress(Sender: TObject; var Key: Char);
    Procedure LoadRealFormNames;
    procedure FindAForm(ThisForm:String);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure SectionBoxKeyPress(Sender: TObject; var Key: Char);
    //procedure FindFormSynonyms(KeyW:String;ResultsList:TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FindALine: TFindALineT3_2026;
  RetNo:Integer;


  implementation

{$R *.DFM}

uses
  vtCommon,vtDialogs,
  T3_2026TrimStr,T3_2026Declare,T3_2026ChildWinNEW,
  T3_2026DFiles,
//T3_2026PopList,
  vtTrimStr,vtShared;

procedure TFindALineT3_2026.FormCreate(Sender: TObject);
begin
 RetNo:=GetCurrentRetNo;
 LoadRealFormNames; FormBox.TabOrder:=0;
 (*
 If IsFormTheDefaultSearch then
 begin LoadRealFormNames; FormBox.TabOrder:=0;LineBox.TabOrder:=1;end
 else
 begin LoadEffields;LineBox.TabOrder:=0;FormBox.TabOrder:=1;end;
 *)
end;

(*
procedure TFindALine.LoadEfFields;
begin
 ListBox1.Items.Clear;
 //ListBox1.Items.LoadFromFile(AppDir+'\'+'EFFields.d');
end;
*)
procedure TFindALineT3_2026.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TFindALineT3_2026.LineBoxKeyPress(Sender: TObject; var Key: Char);
begin
 (*
  If (Key=#13) then
  begin
    ListBox1.Sorted := False;
    LoadEffields;
    If LineBox.Text>'' then FindLineNo(LineBox.text);
  end;
  *)
end;

procedure TFindALineT3_2026.FindLineNo(LineNo:String);
Var i,k,FNo,TheLength:Integer;FName:String;Elm:Integer;
  Linefound:Boolean; TempList:TStringList;
  Label ModifySearch;
begin
(*
 TheLength:=Length(LineNo);
 LineFound:=False;
 For i:=0 to ListBox1.Items.count-1 do
 begin
  If LineNo = LeftStr(ListBox1.Items[i],TheLength) then
  begin
    //check if there is a province suffix
   LineFound:=True;
   If ValidShortProvince(MidStr(ListBox1.Items[i],TheLength+1,2)) then
     goto ModifySearch;

   FName:=UpperCase(AllTrim(MidStr(ListBox1.Items[i],81,9)));
   Elm:=MyStrToInt(AllTrim(MidStr(ListBox1.Items[i],91,5)));
   if FName='' then
   begin
    ShowTimedMsg('Form ID is not available for this line',1000);
    ListBox1.ItemIndex:=i;
    Exit;
   end;

   OpenIt(FName,Elm);
   Break;
  end; //found
 end; //i ;
 If LineFound=False then //ShowTimedMsg('Line not found',1000);
 begin
   TempList:=TStringList.Create;
   For i:=0 to ListBox1.Items.count-1 do
   begin
    k:=FindWord(LineBox.Text,ListBox1.Items[i]);
    If K>0 then TempList.Add(ListBox1.Items[i]);
   end; //i

   If TempList.count>0 then
   begin
     ListBox1.Items.Clear;
     For i:=0 to templist.count-1 do ListBox1.Items.add(TempList[i]);
   end
   else
    ShowTimedMsg('No entries found',1200);

  TempList.Free;
 end;
 Exit;

 ModifySearch:
 LineNo:= LineNo+Ret[RetNo]^.Province;
 TheLength:=Length(LineNo);
 For i:=0 to ListBox1.Items.count-1 do
 begin
  If LineNo = LeftStr(ListBox1.Items[i],TheLength) then
  begin
   FName:=UpperCase(AllTrim(MidStr(ListBox1.Items[i],81,9)));
   Elm:=MyStrToInt(AllTrim(MidStr(ListBox1.Items[i],91,5)));
   OpenIt(FName,Elm);
   Break;
  end; //found
 end; //i
*)
end;

procedure TFindALineT3_2026.OpenIt(FName:String;Elm:Integer);
Var Fno:Integer;
begin
   FNo := GetFormNo(FName);
   If FNo>0 then
   begin
    OpenForm(RetNo,FNo,Elm);
    Close;
   end
   Else
    ShowTimedMsg('Form ID is missing for this line',1200);
end;

procedure TFindALineT3_2026.ListBox1DblClick(Sender: TObject);
Var FName:String;Elm:Integer;
begin
 FName:=UpperCase(AllTrim(MidStr(ListBox1.Items[ListBox1.ItemIndex],81,9)));
 Elm:=MyStrToInt(AllTrim(MidStr(ListBox1.Items[ListBox1.ItemIndex],91,5)));
 OpenIt(FName,Elm);
end;

procedure TFindALineT3_2026.EditBtnClick(Sender: TObject);
begin
 SomeCaption:='T1 Line numbers';
 SomeLabel:='Used for finding/jumping to a line number';
 SomeFile:='EFFields.d';

 Application.CreateForm(TDFilesT3_2026,DFiles);
 DFiles.ShowModal;
 DFiles.Free;
end;

procedure TFindALineT3_2026.KeyWBoxKeyPress(Sender: TObject; var Key: Char);
Var i,k:integer;TempList:TStringList;FoundW:Boolean;
begin
(*
  If KeyWBox.Text='' then exit;
  If Key<>#13 then exit;
  LoadEfFields;

  TempList:=TStringList.Create;
  For i:=0 to ListBox1.Items.count-1 do
  begin
    k:=FindWord(KeyWBox.Text,ListBox1.Items[i]);
    If K>0 then TempList.Add(ListBox1.Items[i]);
  end; //i

  If TempList.count>0 then
  begin
    ListBox1.Items.Clear;
    For i:=0 to templist.count-1 do ListBox1.Items.add(TempList[i]);
  end
  else
   ShowTimedMsg('No entries found',1200);
  TempList.Free;
 *)
end;

Procedure TFindALineT3_2026.LoadRealFormNames;
Var i:Integer;
Begin
 ListBox1.Items.Clear;
 ListBox1.Sorted := True;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormShow then
     ListBox1.Items.Add(PaddR(Frec.FormRlNm,10)
                       +PaddR(Frec.FormAbrev,70)
                       +Frec.FormInstName);

 end; //i
end;

procedure TFindALineT3_2026.FormBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If (Key=#13) then
 // and (FormBox.Text>'') then
  begin
    LoadRealFormNames;
    If FormBox.Text>'' then FindAForm(FormBox.text);
  end;
end;


procedure TFindALineT3_2026.FindAForm(ThisForm:String);
Var i,Elm,FNo,TheLength:Integer;FName:String;
//FormRecs,ResultsList:TStringList;
begin
 ThisForm:=UpperCase(ThisForm);
 If ThisForm='S1' then ThisForm:='S01';
 If ThisForm='S2' then ThisForm:='S02';
 If ThisForm='S3' then ThisForm:='S03';
 If ThisForm='S4' then ThisForm:='S04';
 If ThisForm='S5' then ThisForm:='S05';
 If ThisForm='S6' then ThisForm:='S06';
 If ThisForm='S7' then ThisForm:='S07';
 If ThisForm='S8' then ThisForm:='S08';
 If ThisForm='S9' then ThisForm:='S09';
 TheLength:=Length(ThisForm);
 For i:=0 to ListBox1.Items.count-1 do
 begin
  If ThisForm = LeftStr(ListBox1.Items[i],TheLength) then
  begin
   FName:=UpperCase(AllTrim(MidStr(ListBox1.Items[i],81,10)));
   FNo := GetFormNo(FName);
   If FNo>0 then
   begin
    OpenForm(RetNo,FNo,0);
    Close;
    exit;
   end;
  end; //found the line with this form
 end; //i
 //not found as formname
    SomeList.Clear; //:=TStringList.Create;
    SomeCaption := 'Form or KeyWord found in following';
    IsAnyWhereInList(ThisForm,ListBox1.Items,SomeList);
    if SomeList.Count = 0 then
    begin
      ShowTimedMsg('Not found!',1300);
      Exit;
    end;
    SelectedString := PopSomeList(SomeList,SomeCaption);
    If SelectedString > '' then
    begin
     FName:=UpperCase(AllTrim(MidStr(SelectedString,85,10)));
     FNo := GetFormNo(FName);
     If FNo>0 then
     begin
      OpenForm(RetNo,FNo,0);
      Close;
      exit;
     end;
    end;
 //ShowTimedMsg('Form not found',1000);
end;

(*
procedure TFindALine.FindFormSynonyms(KeyW:String;FormRecs:TStringList;ResultsList:TStringList);
Var i:Integer;FName:String;Elm:Integer;
begin
 FormRecs:=TStringList.Create;
 For i:=0 to ListBox1.Items.count -1 do FormRecs.Add(ListBox1.Items[i]);
 IsAnyWhereInList(KeyW,FormRecs,ResultsList);

 For i:=0 to ResultsList.Count-1 do
   SomeList.Add(ResultsList[i]);
 SomeCaption := 'Form or KeyWord found in following';
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
 If SelectedString > '' then
 begin
  FName:=UpperCase(AllTrim(MidStr(SelectedString,81,9)));
  Elm:=MyStrToInt(AllTrim(MidStr(SelectedString,91,5)));
  OpenIt(FName,Elm);
 end;
end;
*)
procedure TFindALineT3_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
 If key = #13 then ListBox1DblClick(Sender);
end;

procedure TFindALineT3_2026.SectionBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If (Key=#13) then
 begin
    ListBox1.Items.LoadFromFile(AppDir+'\'+'LblSect.d');
   // If SectionBox.Text>'' then FindSection(SecitonBox.text);
 end;
end;

end.
