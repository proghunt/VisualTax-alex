unit UCustLtr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, ExtCtrls, FileCtrl, Buttons,
  UDeclare,TrimStr;

type
  TCustLtr = class(TForm)
    RetType: TRadioGroup;
    Line1: TEdit;
    Line2: TEdit;
    Line3: TEdit;
    Line5: TEdit;
    Line6: TEdit;
    Line7: TEdit;
    Line9: TEdit;
    Line10: TEdit;
    Line11: TEdit;
    Line12: TEdit;
    Line13: TEdit;
    Line14: TEdit;
    Line15: TEdit;
    Line4: TEdit;
    Line8: TEdit;
    Label2: TLabel;
    ContentLabel: TLabel;
    Panel2: TPanel;
    ParagraphGroup: TRadioGroup;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ValidateBtn: TBitBtn;
    CancelBtn: TBitBtn;
    InterpretBtn: TBitBtn;
    InsertBtn: TBitBtn;
    RevertBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    SaveBtn: TBitBtn;
   { procedure RefundBtnClick(Sender: TObject);}
{    procedure HdrParaClick(Sender: TObject);}
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ValidateBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    Procedure ClearEditLines;
    procedure ParagraphClick(LetterParagraphName:string);
   { procedure OpenParaClick(Sender: TObject);
    procedure Custom1ParaClick(Sender: TObject);
    procedure SignParaClick(Sender: TObject);
    procedure AttachParaClick(Sender: TObject);
    procedure InstallParaClick(Sender: TObject);
    procedure RrspParaClick(Sender: TObject);
    procedure Custom2ParaClick(Sender: TObject);
    procedure CloseParaClick(Sender: TObject);
    }
    procedure RetTypeClick(Sender: TObject);
    procedure ParagraphGroupClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);

    procedure InterpretBtnClick(Sender: TObject);
    procedure RevertBtnClick(Sender: TObject);
    procedure InsertBtnClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  CustLtr: TCustLtr;
implementation

{$R *.DFM}
(*
procedure TCustLtr.RefundBtnClick(Sender: TObject);
Var TempList :TStringList;
I :integer;
begin
 TempList := TStringList.Create;
 TempList.LoadFromFile('C:\delphi\T1\STDLTR.L');
 For I:=1 to LetterMxParagraphLines do
  With FindComponent('Line'+IntToStr(i+1)) as TEdit do
     Text := TempList[i];

 TempList.Free;

end;
*)
procedure TCustLtr.ParagraphClick(LetterParagraphName:string);
Var TempList :TStringList;
I :integer;
begin
 TempList := TStringList.Create;
 SelectLetterName(LetterReturnType,LetterParagraphName);
 ClearEditLines;
 LoadLetter(TempList,LetterName);

 For I:=0 to TempList.Count-1 do
    With FindComponent('Line'+IntToStr(i+1)) as TEdit do
         Text := TempList[i];

 TempList.Free;
end;


Procedure TCustLtr.ClearEditLines;
Var I:integer;
begin
 For I:=1 to LetterMxParagraphLines do
   begin
    With FindComponent('Line'+IntToStr(i)) as TEdit do
        begin Text := '';Refresh;End;
   end;
 Invalidate;
end;


procedure TCustLtr.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TCustLtr.FormCreate(Sender: TObject);
Var i:integer;
begin
LetterMxParagraphLines := 15;
LoadDataDict;
for i :=0 to (DataDictList.Count - 1) do
   begin
    DataDictRec := DataDictList.Items[i];
    ComboBox1.Items.Add(DataDictRec^.Name);
   end;
ComboBox1.Text:=ComboBox1.Items[0];
RetType.ItemIndex :=0;
ParagraphGroup.ItemIndex :=0;
RevertBtn.Enabled := False;
end;


procedure TCustLtr.ValidateBtnClick(Sender: TObject);
Var j,k,l,Cursor_position,KeyWLength:integer;
 Result :boolean;
begin
 Cursor_position :=0;
 KeyWLength :=0;
 For j:=1 to LetterMxParagraphLines do
   With FindComponent('Line'+IntToStr(j)) as TEdit do
   begin
     Result :=ValidateTextLine(Text,Cursor_position,KeyWLength);
     If Result =false then
     begin
       ShowMessage('There are errors!'+Chr(13)+' Invalid keyword');
       SetFocus;
       SelStart :=Cursor_position-1;
       SelLength := KeyWLength+1;

       break;
     end;
   end;
  If Result = True then ShowMessage('No errors found');
 end;

procedure TCustLtr.RemoveBtnClick(Sender: TObject);
Var i:integer;Templist : TstringList;
begin
 (*
 TempList := TstringList.Create;

 For I:=1 to LetterMxParagraphLines do
   With FindComponent('Line'+IntToStr(i)) as TEdit do
     begin Templist.Add(Text);Text :='';end;
 RemoveEmptyLines(TempList);
 {redisplay}
 For I:=0 to Templist.Count-1 do
  With FindComponent('Line'+IntToStr(i+1)) as TEdit do
     Text := TempList[i];
 TempList.Free;
 *)
end;


procedure TCustLtr.SaveBtnClick(Sender: TObject);
Var i:integer;Templist : TstringList;
 InputString: string;
begin
 ValidateBtnClick(Sender);
 TempList := TstringList.Create;
 For I:=1 to LetterMxParagraphLines do
  With FindComponent('Line'+IntToStr(i)) as TEdit do
    Templist.Add(Text);
RemoveLastEmptyLines(TempList);
InputString:= InputBox('Input Box', 'FileName', LetterName);
TempList.SaveToFile(Appdir+'\'+InputString);
TempList.Free;
ShowMessage('File saved');
end;
(*
procedure TCustLtr.OpenParaClick(Sender: TObject);
begin
ParaGraphClick('Opening');
end;

procedure TCustLtr.Custom1ParaClick(Sender: TObject);
begin
ParaGraphClick('Custom1');
end;

procedure TCustLtr.SignParaClick(Sender: TObject);
begin
ParaGraphClick('Signatures');
end;

procedure TCustLtr.AttachParaClick(Sender: TObject);
begin
ParaGraphClick('Attachments');
end;

procedure TCustLtr.InstallParaClick(Sender: TObject);
begin
ParaGraphClick('Instalments');
end;

procedure TCustLtr.RrspParaClick(Sender: TObject);
begin
ParaGraphClick('RRSP');
end;

procedure TCustLtr.Custom2ParaClick(Sender: TObject);
begin
ParaGraphClick('Custom2');
end;

procedure TCustLtr.CloseParaClick(Sender: TObject);
begin
ParaGraphClick('Closing');
end;
*)
procedure TCustLtr.RetTypeClick(Sender: TObject);
begin
 Case RetType.ItemIndex of
  0: LetterReturnType := 'PR';
  1: LetterReturnType := 'PB';
  2: LetterReturnType := 'PN';
  3: LetterReturnType := 'FR';
  4: LetterReturnType := 'FB';
  5: LetterReturnType := 'FN';
 end;
 ParaGraphClick(LetterParagraphName);
 Invalidate;
end;

procedure TCustLtr.ParagraphGroupClick(Sender: TObject);
begin
 LetterParagraphName := ParaGraphGroup.Items[ParaGraphGroup.ItemIndex];
 ParaGraphClick(LetterParagraphName);
 Invalidate;
end;

procedure TCustLtr.FormPaint(Sender: TObject);
begin
ContentLabel.Caption :=
    ParagraphGroup.Items[ParagraphGroup.ItemIndex] +
    ' paragraph for '+  RetType.Items[RetType.ItemIndex];

end;


procedure TCustLtr.InterpretBtnClick(Sender: TObject);
Var i:integer; Txt : string; TempList : TStringList;
begin
If RetInMem <1 then
 begin ShowMessage('You must open a return first');Exit;end;
 TempList := TStringList.Create;
 {temp save}
 For I:=1 to LetterMxParagraphLines do
    With FindComponent('Line'+IntToStr(i)) as TEdit do
        TempList.Add(Text);
TempList.SaveToFile(AppDir+'\'+'Temp.ltr');
TempList.Free;

{Interpret/display}
For i:=1 to LetterMxParagraphLines do
   With FindComponent('Line'+IntToStr(i)) as TEdit do
    begin
     Txt :=Text;
     InterpretTextLine(Txt);
     Text := Txt;
    end;

ValidateBtn.Enabled :=False;
InterpretBtn.Enabled :=False;
SaveBtn.Enabled :=False;
InsertBtn.Enabled := False;
RemoveBtn.Enabled := False;
RetType.Enabled := False;
ParagraphGroup.Enabled := False;
RevertBtn.Enabled :=True;
end;


procedure TCustLtr.RevertBtnClick(Sender: TObject);
Var i:integer; TempList:tstringList;
begin
 TempList := TStringList.Create;
 ClearEditLines;
 LoadLetter(TempList,'Temp.ltr');

 For I:=0 to TempList.Count-1 do
    With FindComponent('Line'+IntToStr(i+1)) as TEdit do
         Text := TempList[i];
 TempList.Free;

 ValidateBtn.Enabled :=True;
 InterpretBtn.Enabled :=True;
 SaveBtn.Enabled :=True;
 InsertBtn.Enabled := True;
 RemoveBtn.Enabled := True;
 RetType.Enabled := True;
 ParagraphGroup.Enabled := True;
 RevertBtn.Enabled :=False;
end;

procedure TCustLtr.InsertBtnClick(Sender: TObject);
Var I:integer;
begin
(*
 For I:=1 to LetterMxParagraphLines do

   With (Sender as TEdit) do
     begin
       ShowMessage(IntToStr(i));
     end;
   *)
end;

end.
