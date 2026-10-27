unit TF_2026PrSet;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls;

type
  TPrSetTF_2026 = class(TForm)
    AddAllBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    AddBtn: TBitBtn;
    RemoveAllBtn: TBitBtn;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    RadioGroup1: TRadioGroup;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    CurrentSetLabel: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Procedure LoadFile(FlName:String);
    Procedure SaveFile(FlName:String);
    Function AddAForm(FName:string):Boolean;
    Procedure ClearSet;
    procedure AddBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure AddAllBtnClick(Sender: TObject);
    procedure RemoveAllBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Const HelpTopic = 'Print_templates';
var
  PrSet: TPrSetTF_2026;
  FlName : string; //[20];

implementation

{$R *.DFM}

uses vtCommon,vtTrimStr,TF_2026Declare,TF_2026TrimStr;

procedure TPrSetTF_2026.AddBtnClick(Sender: TObject);
begin
StringGrid1DblClick(Sender);
end;

procedure TPrSetTF_2026.RemoveBtnClick(Sender: TObject);
begin
StringGrid2DblClick(Sender);
end;

Procedure TPrSetTF_2026.ClearSet;
Var i,j :integer;
begin
  For i:=0 to StringGrid1.ColCount-1 do
    For j:=1 to StringGrid1.RowCount-1 do
     StringGrid2.Cells[i,j] :='';
  StringGrid2.RowCount :=StringGrid1.RowCount;
end;

procedure TPrSetTF_2026.AddAllBtnClick(Sender: TObject);
Var i,j :integer;
begin
  ClearSet;
  For i :=1 to StringGrid1.RowCount-1 do
   begin
    StringGrid2.Cells[0,i] := StringGrid1.Cells[0,i];
     {+StringGrid1.Cells[2,i];}
    StringGrid2.Cells[1,i] := '1';
   end;
end;

procedure TPrSetTF_2026.RemoveAllBtnClick(Sender: TObject);
begin
ClearSet;
StringGrid2.Update;
end;

Function TPrSetTF_2026.AddAForm(FName:string):Boolean;
Var I:integer;
begin
 With StringGrid2 do
 begin
   For i:=1 to RowCount-1 do
    If Fname = Cells[0,i] then
      begin
       ShowMessage('Form '+FName+' is already in the print set!');
       exit;
      end
    else
     If Cells[0,i]='' then
      begin Cells[0,i]:=FName; Cells[1,i] := '1';exit;end;
    Update;
 end;
end;

procedure TPrSetTF_2026.ListBox1DblClick(Sender: TObject);
begin
{
ListBox1.Items.Delete(ListBox1.ItemIndex);
RefreshScreen(FilterDescr);
}
end;

procedure TPrSetTF_2026.FormCreate(Sender: TObject);
Var I:integer;
begin
 StringGrid1.ColWidths[1] := StringGrid1.DefaultColWidth * 5;
 StringGrid1.Cells[0,0] := 'Form Name';
 StringGrid1.Cells[1,0] := 'Description';
 StringGrid1.RowCount := Flist.Count+1;
 for i :=0 to FList.Count - 1 do
 begin
   FRec := FList.Items[i];
   If Frec.FormInst <'#2' then {only single forms and #1}
     begin
     StringGrid1.Cells[0,i+1] := Frec.FormName;
     StringGrid1.Cells[1,i+1] := Frec.FormAbrev;
     StringGrid1.Cells[2,i+1] := Frec.FormInst;
     end;
 end;
StringGrid2.RowCount := Flist.Count;
StringGrid2.Cells[0,0]:= 'Form Name';
StringGrid2.Cells[1,0]:= 'Copies 1-9';
RadioGroup1.ItemIndex :=0;
FlName := 'RvCanSet.d';
LoadFile(FlName);
end;

procedure TPrSetTF_2026.FormPaint(Sender: TObject);
begin
If FlName>'' then SaveFile(FlName);
 Case RadioGroup1.ItemIndex of
 0: begin CurrentSetLabel.Caption := 'Rev Canada';FlName :='RvCanSet.d';end;
 1: begin CurrentSetLabel.Caption := 'Client';    FlName :='ClintSet.d';end;
 2: begin CurrentSetLabel.Caption := 'Preparer';  FlName :='PrepSet.d';end;
 3: begin CurrentSetLabel.Caption := 'Other purpose 1';FlName :='Oth1Set.d';end;
 4: begin CurrentSetLabel.Caption := 'Other purpose 2';FlName :='Oth2Set.d';end;
 5: begin CurrentSetLabel.Caption := 'Other purpose 3';FlName :='Oth3Set.d';end;
 else
 end;
 LoadFile(FlName);
end;

Procedure TPrSetTF_2026.LoadFile(FlName:String);
Var i:integer;Templist :TstringList;
begin
 If FileExists(Appdir+'\'+FlName) then
 begin
  TempList :=TStringList.Create;
  TempList.LoadFromFile(Appdir+'\'+FlName);
  ClearSet;
  For i:=0 to Templist.Count-1 do
   begin
    StringGrid2.Cells[1,i+1] := Leftstr(TempList[i],1);
    StringGrid2.Cells[0,i+1] := MidStr(TempList[i],2,20);
   end;
  TempList.Free;
 end
 else
  ClearSet;
end;

Procedure TPrSetTF_2026.SaveFile(FlName:String);
Var i:integer;Templist :TstringList;
begin
 TempList :=TStringList.Create;
 For i:=1 to StringGrid2.RowCount-1 do
  begin
   If (StringGrid2.Cells[0,i] >'') and
    (Vl(AllTrim(StringGrid2.Cells[1,i]))>0) and
    (Vl(AllTrim(StringGrid2.Cells[1,i]))<10) then
     TempList.Add(
       AllTrim(StringGrid2.Cells[1,i])+StringGrid2.Cells[0,i]);
  end;
 TempList.SaveToFile(Appdir+'\'+FlName);
 TempList.Free;
end;

procedure TPrSetTF_2026.StringGrid1DblClick(Sender: TObject);
begin
 AddAForm(StringGrid1.Cells[0,StringGrid1.Row]);
        {+StringGrid1.Cells[2,StringGrid1.Row]);}
end;

procedure TPrSetTF_2026.RadioGroup1Click(Sender: TObject);
begin
{If FlName >'' then SaveFile(FlName);}
Invalidate;
end;

procedure TPrSetTF_2026.StringGrid2DblClick(Sender: TObject);
begin
 If StringGrid2.Row >0 then
 begin
   StringGrid2.Cells[0,StringGrid2.Row] := '';
   StringGrid2.Cells[1,StringGrid2.Row] := '';
   Update;
   SaveFile(FlName);
   ClearSet;
   LoadFile(FlName);
 end;
end;
procedure TPrSetTF_2026.CancelBtnClick(Sender: TObject);
begin
If FlName>'' then SaveFile(FlName);
end;

procedure TPrSetTF_2026.BitBtn1Click(Sender: TObject);
begin
ShowHelp('TfHelp',HelpTopic);
end;

end.
