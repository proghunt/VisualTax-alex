unit T2_2027prset;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls,T2_2027,T2_2027Declare,T2_2027TrimStr,
  DB, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager, uADCompClient,
  uADCompDataSet;

type
  TPrSetT2_2027 = class(TForm)
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
    BitBtn1: TBitBtn;
    Table1_notOpened: TADTable;
    FDConnection: TADConnection;
    Procedure LoadScrs;
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
Const HelpTopic='print_templates';
var
  PrSet: TPrSetT2_2027;
  FlName : string;//[20]; //20150701
  
implementation

{$R *.DFM}

uses vtMulti, vtTrimStr, vtShared, vtDataBase;

procedure TPrSetT2_2027.AddBtnClick(Sender: TObject);
begin
StringGrid1DblClick(Sender);
end;

procedure TPrSetT2_2027.RemoveBtnClick(Sender: TObject);
begin
StringGrid2DblClick(Sender);
end;

Procedure TPrSetT2_2027.ClearSet;
Var i,j :integer;
begin
  For i:=0 to StringGrid1.ColCount-1 do
    For j:=1 to StringGrid1.RowCount-1 do
     StringGrid2.Cells[i,j] :='';
  StringGrid2.RowCount :=StringGrid1.RowCount;
end;

procedure TPrSetT2_2027.AddAllBtnClick(Sender: TObject);
Var i,j :integer;
begin
  ClearSet;
  For i :=1 to StringGrid1.RowCount-1 do
   begin
     If (StringGrid1.Cells[0,i] = 'OS8ALL')
     or (StringGrid1.Cells[0,i] = 'OT2014') then
     // nothing
     else
     begin
      StringGrid2.Cells[0,i] := StringGrid1.Cells[0,i];
      StringGrid2.Cells[1,i] := '1';
     end;
   end;
end;

procedure TPrSetT2_2027.RemoveAllBtnClick(Sender: TObject);
begin
ClearSet;
StringGrid2.Update;
end;

Function TPrSetT2_2027.AddAForm(FName:string):Boolean;
Var I:integer;
begin
 result := false;
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
     begin
       Cells[0,i]:=FName;
       Cells[1,i] := '1';
       result := true;
       exit;
     end;

    Update;
 end;
end;

procedure TPrSetT2_2027.ListBox1DblClick(Sender: TObject);
begin
{
ListBox1.Items.Delete(ListBox1.ItemIndex);
RefreshScreen(FilterDescr);
}
end;

procedure TPrSetT2_2027.FormCreate(Sender: TObject);
Var I:integer;
begin
 // Revise print sets to get rid of page underscore
 //20121207
 If StillOldPrintSets then RevisePrintSets;
 StringGrid1.ColWidths[1] := StringGrid1.DefaultColWidth * 2;
 StringGrid1.Cells[0,0] := 'Form Name';
 StringGrid1.Cells[1,0] := 'Description';
 StringGrid1.RowCount := Flist.Count+1;

 LoadScrs;
 StringGrid2.RowCount := Flist.Count;
 StringGrid2.Cells[0,0]:= 'Form Name';
 StringGrid2.Cells[1,0]:= 'Copies 1-9';
 RadioGroup1.ItemIndex :=0;
 FlName := 'RvCanSet.d';
 LoadFile(FlName);
end;

procedure TPrSetT2_2027.FormPaint(Sender: TObject);
begin
If FlName>'' then SaveFile(FlName);
 Case RadioGroup1.ItemIndex of
 0: begin CurrentSetLabel.Caption := 'CCRA';FlName :='RvCanSet.d';end;
 1: begin CurrentSetLabel.Caption := 'Client';    FlName :='ClintSet.d';end;
 2: begin CurrentSetLabel.Caption := 'Preparer';  FlName :='PrepSet.d';end;
 3: begin CurrentSetLabel.Caption := 'Other purpose 1';FlName :='Oth1Set.d';end;
 4: begin CurrentSetLabel.Caption := 'Other purpose 2';FlName :='Oth2Set.d';end;
 5: begin CurrentSetLabel.Caption := 'Other purpose 3';FlName :='Oth3Set.d';end;
 else
 end;
 LoadFile(FlName);
end;

Procedure TPrSetT2_2027.LoadFile(FlName:String);
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

Procedure TPrSetT2_2027.SaveFile(FlName:String);
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

procedure TPrSetT2_2027.StringGrid1DblClick(Sender: TObject);
begin
 AddAForm(StringGrid1.Cells[0,StringGrid1.Row]);
        {+StringGrid1.Cells[2,StringGrid1.Row]);}
end;

procedure TPrSetT2_2027.RadioGroup1Click(Sender: TObject);
begin
{If FlName >'' then SaveFile(FlName);}
Invalidate;
end;

procedure TPrSetT2_2027.StringGrid2DblClick(Sender: TObject);
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
procedure TPrSetT2_2027.CancelBtnClick(Sender: TObject);
begin
If FlName>'' then SaveFile(FlName);
end;

Procedure TPrSetT2_2027.LoadScrs;
 var i : integer;
     ADConnection: TADConnection;
     Table1: TADTable;
begin
   //20150920 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormName');

  {load in memory}
  Table1.First;
  i:=0;
  Repeat
    If (LTrim(RTrim(Table1.FieldByName('FormInst').AsString)) <'#2') and
       NotOldGifiForm(Table1.FieldByName('FormName').AsString)  then //20160720 Igor
    begin
      StringGrid1.Cells[0,i+1] :=
        UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
      StringGrid1.Cells[1,i+1] :=Table1.FieldByName('FormAbrev').AsString;
      StringGrid1.Cells[2,i+1] :=LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
      Inc(i);
    end;
    Table1.Next;
  until Table1.EOF;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;

procedure TPrSetT2_2027.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T2Help',HelpTopic);
end;

end.
