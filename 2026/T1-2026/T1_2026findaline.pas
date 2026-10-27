unit T1_2026findaline;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons;

type
  TFindALineT1_2026 = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    ListBox1: TListBox;
    Panel4: TPanel;
    Label1: TLabel;
    LineBox: TEdit;
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
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    SectionBox: TEdit;
    Label4: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure LineBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FindLineNo(LineNo:String);
    procedure ListBox1DblClick(Sender: TObject);
    procedure OpenIt(FName:String;Elm:Integer);
    procedure EditBtnClick(Sender: TObject);
    procedure KeyWBoxKeyPress(Sender: TObject; var Key: Char);
    procedure LoadEfFields;
    procedure FormBoxKeyPress(Sender: TObject; var Key: Char);
    Procedure LoadRealFormNames;
    procedure FindAForm(ThisForm:String);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure SectionBoxKeyPress(Sender: TObject; var Key: Char);
    //procedure FindFormSynonyms(KeyW:String;ResultsList:TStringList);
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  FindALine: TFindALineT1_2026;


implementation

{$R *.DFM}

uses vtTrimStr,vtCommon,vtDialogs,T1_2026,T1_2026TrimStr,T1_2026Declare,
  T1_2026ChildWinNEW,T1_2026DFiles,T1_2026T1Rtns,
  vtShared; //20160907 igor

procedure TFindALineT1_2026.FormCreate(Sender: TObject);
begin
 RetNo:=GetCurrentRetNo;
 If IsFormTheDefaultSearch then
 begin LoadRealFormNames; FormBox.TabOrder:=0;LineBox.TabOrder:=1;end
 else
 begin LoadEffields;LineBox.TabOrder:=0;FormBox.TabOrder:=1;end;
end;

procedure TFindALineT1_2026.LoadEfFields;
begin
 ListBox1.Items.Clear;
 ListBox1.Items.LoadFromFile(AppDir+'\'+'EFFields.d');
end;

procedure TFindALineT1_2026.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TFindALineT1_2026.LineBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key=#13) then
  begin
    ListBox1.Sorted := False;
    LoadEffields;
    If LineBox.Text>'' then FindLineNo(LineBox.text);
  end;
end;

procedure TFindALineT1_2026.FindLineNo(LineNo:String);
Var i,k,FNo,TheLength:Integer;FName:String;Elm:Integer;
  Linefound:Boolean; TempList:TStringList;
  Label ModifySearch;
begin
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
 LineNo:= LineNo+Ret[RetNo].Province;
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
end;

procedure TFindALineT1_2026.OpenIt(FName:String;Elm:Integer);
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

procedure TFindALineT1_2026.ListBox1DblClick(Sender: TObject);
Var FName:String;Elm:Integer;
begin
 FName:=UpperCase(AllTrim(MidStr(ListBox1.Items[ListBox1.ItemIndex],81,9)));
 Elm:=MyStrToInt(AllTrim(MidStr(ListBox1.Items[ListBox1.ItemIndex],91,5)));
 OpenIt(FName,Elm);
end;

procedure TFindALineT1_2026.EditBtnClick(Sender: TObject);
begin
 SomeCaption:='T1 Line numbers';
 SomeLabel:='Used for finding/jumping to a line number';
 SomeFile:='EFFields.d';

 Application.CreateForm(TDFilesT1_2026,DFiles);
 DFiles.ShowModal;
 DFiles.Free;
end;

procedure TFindALineT1_2026.KeyWBoxKeyPress(Sender: TObject; var Key: Char);
Var i,k:integer;TempList:TStringList;FoundW:Boolean;
begin
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
end;

Procedure TFindALineT1_2026.LoadRealFormNames;
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

procedure TFindALineT1_2026.FormBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If (Key=#13) then
 // and (FormBox.Text>'') then
  begin
    LoadRealFormNames;
    If FormBox.Text>'' then FindAForm(FormBox.text);
  end;
end;


procedure TFindALineT1_2026.FindAForm(ThisForm:String);
Var i,Elm,FNo,TheLength:Integer;FName:String;
  //FormRecs,ResultsList:TStringList;
begin
 TheLength:=Length(ThisForm);
 ThisForm:=UpperCase(ThisForm);
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
    SomeCaption := 'Form or KeyWord found in following';
    SelectedString := PopMatchingList(ThisForm,ListBox1.Items,SomeCaption);
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

procedure TFindALineT1_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
 If key = #13 then ListBox1DblClick(Sender);
end;

procedure TFindALineT1_2026.SectionBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If (Key=#13) then
 begin
    ListBox1.Items.LoadFromFile(AppDir+'\'+'LblSect.d');
   // If SectionBox.Text>'' then FindSection(SecitonBox.text);
 end;
end;

end.
