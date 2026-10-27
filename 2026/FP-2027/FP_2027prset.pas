unit FP_2027prset;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls,Db, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TPrSetFP_2012 = class(TForm)
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
    DataSource1: TDataSource;
    FDConnection: TADConnection;
    Table1: TADTable;
    Procedure LoadFile(FlName:String);
    Procedure SaveFile(FlName:String);
    Function AddAForm(FName:string):Boolean;
    Procedure ClearSet;
    Procedure LoadScrs;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrSet: TPrSetFP_2012;
  FlName : string; //[20];

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr
    ,vtTrimStr, vtShared, vtDataBase;

procedure TPrSetFP_2012.AddBtnClick(Sender: TObject);
begin
StringGrid1DblClick(Sender);
end;

procedure TPrSetFP_2012.RemoveBtnClick(Sender: TObject);
begin
StringGrid2DblClick(Sender);
end;

Procedure TPrSetFP_2012.ClearSet;
Var i,j :integer;
begin
  For i:=0 to StringGrid1.ColCount-1 do
    For j:=1 to StringGrid1.RowCount-1 do
     StringGrid2.Cells[i,j] :='';
  StringGrid2.RowCount :=StringGrid1.RowCount;
end;

procedure TPrSetFP_2012.AddAllBtnClick(Sender: TObject);
Var i,j :integer;
begin
  ClearSet;
  For i :=1 to StringGrid1.RowCount-1 do
   begin
     If  (LeftStr(UpperCase(StringGrid1.Cells[0,i]),7) <> 'FPCOVER')
     and (LeftStr(UpperCase(StringGrid1.Cells[0,i]),4) <> 'LETR')
     and (LeftStr(UpperCase(StringGrid1.Cells[0,i]),3) <> 'INV')
     then
     begin
       If GetFormType(UpperCase(StringGrid1.Cells[0,i])) <> 'TX' then
       begin
         StringGrid2.Cells[0,i] := StringGrid1.Cells[0,i];
         StringGrid2.Cells[1,i] := '1';
       end;
     end;
   end;
end;

procedure TPrSetFP_2012.RemoveAllBtnClick(Sender: TObject);
begin
ClearSet;
StringGrid2.Update;
end;

Function TPrSetFP_2012.AddAForm(FName:string):Boolean;
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

procedure TPrSetFP_2012.ListBox1DblClick(Sender: TObject);
begin
{
ListBox1.Items.Delete(ListBox1.ItemIndex);
RefreshScreen(FilterDescr);
}
end;


procedure TPrSetFP_2012.FormCreate(Sender: TObject);
Var I:integer;
begin
 StringGrid1.ColWidths[1] := StringGrid1.DefaultColWidth * 4;
 StringGrid1.Cells[0,0] := 'Form Name';
 StringGrid1.Cells[1,0] := 'Description';
 StringGrid1.RowCount := Flist.Count+1;
 LoadScrs;
 (*
 for i :=0 to FList.Count - 1 do
 begin
   FRec := FList.Items[i];
   If Frec^.FormInst <'#2' then {only single forms and #1}
     begin
     StringGrid1.Cells[0,i+1] := Frec^.FormName;
     StringGrid1.Cells[1,i+1] := Frec^.FormAbrev;
     StringGrid1.Cells[2,i+1] := Frec^.FormInst;
     end;
 end;
 *)
StringGrid2.RowCount := Flist.Count;
StringGrid2.Cells[0,0]:= 'Form Name';
StringGrid2.Cells[1,0]:= 'Copies 1-9';
RadioGroup1.ItemIndex :=0;
FlName := 'ClintSet.d';
LoadFile(FlName);
end;

Procedure TPrSetFP_2012.LoadScrs;
var i : integer; sDBFPath,sCnnStr:String;
begin
     //20150920 Igor
     SetTableName(FDConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormName');

     {load in memory}
     Table1.First;
     i:=1;
      Repeat
       If (LTrim(RTrim(Table1.FieldByName('FormInst').AsString)) <'#2')
       and (LTrim(RTrim(Table1.FieldByName('DelphiForm').AsString)) <>'Y')  then //20110226
       begin
        StringGrid1.Cells[0,i] :=
          UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
        StringGrid1.Cells[1,i] :=Table1.FieldByName('FormAbrev').AsString;
        StringGrid1.Cells[2,i] :=LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
        Inc(i);
       end;
       Table1.Next;
      until Table1.EOF;
      Table1.Close;
end;


procedure TPrSetFP_2012.FormPaint(Sender: TObject);
begin
If FlName>'' then SaveFile(FlName);
 Case RadioGroup1.ItemIndex of
 0: begin CurrentSetLabel.Caption := 'Client';    FlName :='ClintSet.d';end;
 1: begin CurrentSetLabel.Caption := 'Preparer';  FlName :='PrepSet.d';end;
 2: begin CurrentSetLabel.Caption := 'Other purpose 1';FlName :='Oth1Set.d';end;
 3: begin CurrentSetLabel.Caption := 'Other purpose 2';FlName :='Oth2Set.d';end;
 4: begin CurrentSetLabel.Caption := 'Other purpose 3';FlName :='Oth3Set.d';end;
 else
 end;
 LoadFile(FlName);
end;

Procedure TPrSetFP_2012.LoadFile(FlName:String);
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

Procedure TPrSetFP_2012.SaveFile(FlName:String);
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

procedure TPrSetFP_2012.StringGrid1DblClick(Sender: TObject);
begin
 AddAForm(StringGrid1.Cells[0,StringGrid1.Row]);
        {+StringGrid1.Cells[2,StringGrid1.Row]);}
end;

procedure TPrSetFP_2012.RadioGroup1Click(Sender: TObject);
begin
{If FlName >'' then SaveFile(FlName);}
Invalidate;
end;

procedure TPrSetFP_2012.StringGrid2DblClick(Sender: TObject);
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
procedure TPrSetFP_2012.CancelBtnClick(Sender: TObject);
begin
If FlName>'' then SaveFile(FlName);
end;

end.
