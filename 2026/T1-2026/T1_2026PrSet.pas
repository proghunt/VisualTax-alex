unit T1_2026prset;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls,DB,uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TPrSetT1_2026 = class(TForm)
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
    SlipsBox: TCheckBox;
    FormTypeBox: TRadioGroup;
    Label3: TLabel;
    Label7: TLabel;
    FDConnection: TADConnection;
    Table1: TADTable;
    Procedure LoadScrs;
    Procedure LoadFile(FlName:String);
    Procedure SaveFile(FlName:String);
    //Function AddAForm(FName:string):Boolean;
    procedure AddAForm(FName:string);
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
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Function IncludeThisForm(FrmNm:String):Boolean;
    procedure FormTypeBoxClick(Sender: TObject);
    Function  ShowThisForm(FrmNm:String):Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrSet: TPrSetT1_2026;
  FlName : string; //[20];

implementation

{$R *.DFM}

uses vtDialogs,vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,vtTrimStr,
  vtShared,
  vtDataBase;//20150915 Igor

procedure TPrSetT1_2026.AddBtnClick(Sender: TObject);
begin
StringGrid1DblClick(Sender);
end;

procedure TPrSetT1_2026.RemoveBtnClick(Sender: TObject);
begin
StringGrid2DblClick(Sender);
end;

Procedure TPrSetT1_2026.ClearSet;
Var i,j :integer;
begin
  For i:=0 to StringGrid1.ColCount-1 do
    For j:=1 to StringGrid1.RowCount-1 do
     StringGrid2.Cells[i,j] :='';
  StringGrid2.RowCount :=StringGrid1.RowCount;
end;

procedure TPrSetT1_2026.AddAllBtnClick(Sender: TObject);
Var i,j :integer;s:String;
begin
  ClearSet;
  j:=1;
  For i :=1 to StringGrid1.RowCount-1 do
   begin
    If IncludethisForm(StringGrid1.Cells[0,i]) then
    begin
     StringGrid2.Cells[0,j] := StringGrid1.Cells[0,i];
     StringGrid2.Cells[1,j] := '1';
     j:=j+1;
    end;
   end;
   StringGrid2.TopRow:=1;
end;


Function TPrSetT1_2026.ShowThisForm(FrmNm:String):Boolean;
begin
 Result:=True;
 If (LeftStr(FrmNm,5)='PAGE1')
 or (LeftStr(FrmNm,5)='PAGE3')
 or (LeftStr(FrmNm,5)='PAGE4')
 or (FrmNm ='S1AG')
 or (FrmNm ='S1AN')
 or (FrmNm ='S1BG')
 or (FrmNm ='S1BN')
 or (FrmNm ='ASSETS')
 or (FrmNm ='T2125A')
 or (FrmNm ='T2032A')
 or (FrmNm ='T2124A')
 or (FrmNm ='T2121A')
 or (FrmNm ='T2042A')
 or (FrmNm ='T776A')
 then result:=False;
end;

Function TPrSetT1_2026.IncludeThisForm(FrmNm:String):Boolean;
begin
 Result:=True;
 If (LeftStr(FrmNm,5)='PAGE1')
 or (LeftStr(FrmNm,5)='PAGE3')
 or (LeftStr(FrmNm,5)='PAGE4')
 or (LeftStr(FrmNm,7)='CUSTINV')
 or (FrmNm ='S1AG')
 or (FrmNm ='S1AN')
 or (FrmNm ='S1BG')
 or (FrmNm ='S1BN')
 or (FrmNm ='ASSETS')
 or (LeftStr(FrmNm,6) ='T2124_')
 or (LeftStr(FrmNm,6) ='T2032_')
 or (FrmNm ='T2125A')
 or (FrmNm ='T2032A')
 or (FrmNm ='T2124A')
 or (FrmNm ='T2121A')
 or (FrmNm ='T2042A')
 or (FrmNm ='T776A')
 or (FrmNm ='T1BC')

 or (FrmNm ='T1ON')  //20110218
 or (FrmNm ='T1QC')
 or (FrmNm ='T1GN')
 or (FrmNm ='T1NL')
 or (FrmNm ='T1NS')
 or (FrmNm ='T1NT')
 or (FrmNm ='T1YT')
 or (FrmNm ='T1SK')
 or (FrmNm ='T1NR')
 then result:=False;


 If (SlipsBox.Checked = False)
 and (
     (FRmNm = 'T3MULT')
  or (FRmNm = 'T4')
  or (FRmNm = 'T4A')
  or (FRmNm = 'T4AP')
  or (FRmNm = 'T4AOAS')
  or (FRmNm = 'T4PS')
  or (FRmNm = 'T4RIF')
  or (FRmNm = 'T4RSP')
  or (FRmNm = 'T4U')
  or (LeftStr(FRmNm,6) = 'T4MULT')
  or (FRmNm = 'T5'))
  or (LeftStr(FRmNm,5) = 'T5013')
  then Result:=False;
end;

procedure TPrSetT1_2026.RemoveAllBtnClick(Sender: TObject);
begin
ClearSet;
StringGrid2.Update;
end;

//Function TPrSetT1_2026.AddAForm(FName:string):Boolean;
procedure TPrSetT1_2026.AddAForm(FName:string);
Var I:integer;
begin
  UndefMsg('TPrSetT1_2026.AddAForm');
 With StringGrid2 do
 begin
   For i:=1 to RowCount-1 do
    If Fname = Cells[0,i] then
      begin
       ShowTimedMsg('Form '+FName+' is already in the print set!',1200);
       exit;
      end
    else
     If Cells[0,i]='' then
      begin Cells[0,i]:=FName; Cells[1,i] := '1';exit;end;
    Update;
 end;
end;

procedure TPrSetT1_2026.ListBox1DblClick(Sender: TObject);
begin
{
ListBox1.Items.Delete(ListBox1.ItemIndex);
RefreshScreen(FilterDescr);
}
end;

procedure TPrSetT1_2026.FormCreate(Sender: TObject);
Var I:integer;
begin
 StringGrid1.ColWidths[1] := StringGrid1.DefaultColWidth * 4;
 StringGrid1.Cells[0,0] := 'Form Name';
 StringGrid1.Cells[1,0] := 'Description';
 StringGrid1.RowCount := Flist.Count+1;
 LoadScrs;

 StringGrid2.RowCount := Flist.Count;
 StringGrid2.Cells[0,0]:= 'Form Name';
 StringGrid2.Cells[1,0]:= 'Copies 1-9';
 RadioGroup1.ItemIndex :=1;
 FlName := 'CRASet.d';
 LoadFile(FlName);
end;

procedure TPrSetT1_2026.FormPaint(Sender: TObject);
begin
If FlName>'' then SaveFile(FlName);
 Case RadioGroup1.ItemIndex of
 0: begin CurrentSetLabel.Caption := 'Rev Canada';FlName :='CRASet.d';end;
 1: begin CurrentSetLabel.Caption := 'Client';    FlName :='ClintSet.d';end;
 2: begin CurrentSetLabel.Caption := 'Preparer';  FlName :='PrepSet.d';end;
 3: begin CurrentSetLabel.Caption := 'Other purpose 1';FlName :='Oth1Set.d';end;
 4: begin CurrentSetLabel.Caption := 'Other purpose 2';FlName :='Oth2Set.d';end;
 5: begin CurrentSetLabel.Caption := 'Other purpose 3';FlName :='Oth3Set.d';end;
 else
 end;
 LoadFile(FlName);
 end;

Procedure TPrSetT1_2026.LoadFile(FlName:String);
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

Procedure TPrSetT1_2026.SaveFile(FlName:String);
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

procedure TPrSetT1_2026.StringGrid1DblClick(Sender: TObject);
begin
 AddAForm(StringGrid1.Cells[0,StringGrid1.Row]);
 StringGrid2.TopRow:=1;
        {+StringGrid1.Cells[2,StringGrid1.Row]);}
end;

procedure TPrSetT1_2026.RadioGroup1Click(Sender: TObject);
begin
Invalidate;
end;

procedure TPrSetT1_2026.StringGrid2DblClick(Sender: TObject);
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

procedure TPrSetT1_2026.CancelBtnClick(Sender: TObject);
begin
If FlName>'' then SaveFile(FlName);
end;

Procedure TPrSetT1_2026.LoadScrs;
var i,j : integer; FType:String;
begin
      //20150915 Igor
      SetTableName(FDConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite,'FormName');

      If Table1.Active then Table1.Close;
      Table1.Open;

     //clear grid
      For i:=0 to 2 do
      begin
       For j:=1 to Table1.RecordCount do StringGrid1.Cells[i,j] :='';
      end;


      FType:= AllTrim(LeftStr(FormTypeBox.Items[FormTypeBox.ItemIndex],3));
      If Ftype = 'CRA' then
      begin
       Table1.First;
       i:=1;
       Repeat
       If (LTrim(RTrim(Table1.FieldByName('FormInst').AsString)) <'#2') then
        begin
         If (Table1.FieldByName('CRAFORM').AsString = 'Y') then
         begin
          If ShowThisForm(UpperCase(AllTrim(Table1.FieldByName('FormName').AsString))) then
          begin
           StringGrid1.Cells[0,i] :=
             UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
           StringGrid1.Cells[1,i] :=Table1.FieldByName('FormAbrev').AsString;
           StringGrid1.Cells[2,i] :=LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
           Inc(i);
          end;
         end;
        end;
        Table1.Next;
       until Table1.EOF;
       Table1.Close;
       StringGrid1.TopRow := 1;
       Exit;
      end;

      If Ftype = 'NON' then
      begin
       Table1.First;
       i:=1;
       Repeat
       If (LTrim(RTrim(Table1.FieldByName('FormInst').AsString)) <'#2') then
        begin
         If (Table1.FieldByName('CRAFORM').AsString <> 'Y') then
         begin
          If ShowThisForm(UpperCase(AllTrim(Table1.FieldByName('FormName').AsString))) then
          begin
           StringGrid1.Cells[0,i] :=
             UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
           StringGrid1.Cells[1,i] :=Table1.FieldByName('FormAbrev').AsString;
           StringGrid1.Cells[2,i] :=LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
           Inc(i);
          end;
         end;
        end;
        Table1.Next;
       until Table1.EOF;
       Table1.Close;
       StringGrid1.TopRow := 1;
       Exit;
      end;

     {load in memory}
     Table1.First;
     i:=1;
     Repeat
       If (LTrim(RTrim(Table1.FieldByName('FormInst').AsString)) <'#2') then
       begin
        If Ftype <> 'ALL' then
        begin
         If (Table1.FieldByName('FormType').AsString = FType) then
         begin
          If ShowThisForm(UpperCase(AllTrim(Table1.FieldByName('FormName').AsString))) then
          begin
           StringGrid1.Cells[0,i] :=
             UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
           StringGrid1.Cells[1,i] :=Table1.FieldByName('FormAbrev').AsString;
           StringGrid1.Cells[2,i] :=LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
           Inc(i);
          end;
         end  // = FTYPE
        end
        else
        begin
          If ShowThisForm(UpperCase(AllTrim(Table1.FieldByName('FormName').AsString))) then
          begin
           StringGrid1.Cells[0,i] :=
             UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
           StringGrid1.Cells[1,i] :=Table1.FieldByName('FormAbrev').AsString;
           StringGrid1.Cells[2,i] :=LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
           Inc(i);
          end;
        end;    // <#2
       End;  // #2
       Table1.Next;
     until Table1.EOF;
     Table1.Close;
     StringGrid1.TopRow := 1;
end;

procedure TPrSetT1_2026.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #32 then
begin
 StringGrid1DblClick(Application);
 If StringGrid1.Row < StringGrid1.RowCount-1 then
   StringGrid1.Row := StringGrid1.Row +1;
end;
end;

procedure TPrSetT1_2026.StringGrid2KeyPress(Sender: TObject; var Key: Char);
begin
 if key = #32 then
 begin
  Key :=#0;
  StringGrid2DblClick(Application);
 end;
end;

procedure TPrSetT1_2026.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T1Help','print_templates');
end;

procedure TPrSetT1_2026.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{CancelBtnClick(Sender);}
end;

procedure TPrSetT1_2026.FormTypeBoxClick(Sender: TObject);
begin
LoadScrs;
end;

end.
