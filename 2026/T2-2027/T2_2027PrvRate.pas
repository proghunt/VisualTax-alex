unit T2_2027prvrate;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,T2_2027TrimStr,T2_2027Declare;

type
  TPrvRatesT2_2027 = class(TForm)
    StringGrid1: TStringGrid;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
  PrvRates: TPrvRatesT2_2027;

implementation

{$R *.DFM}

uses vtCommon,T2_2027Main,vtTrimStr,vtShared;

procedure TPrvRatesT2_2027.FormCreate(Sender: TObject);
Var i:Integer;TempList:TstringList;
begin
  FRetNo := GetCurrentRetNo;
 With StringGrid1 do
 begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'PRVRATES.D');

  cells[0,0] := 'Province';
  cells[1,0] := 'Low Rate';
  cells[2,0] := 'High Rate';
  cells[3,0] := 'YYYY/MM/DD';
  cells[4,0] := 'New Low Rate';
  cells[5,0] := 'New High Rate';

  For i:=1 to 15 do
   begin
    Cells[0,i] := PrvShort[i];
  end;

  For i:=0 to 14 do {TempList.Count-1 do}
   begin
    Cells[1,i+1] := AllTrim(MidStr(TempList[i],5,7));
    Cells[2,i+1] := AllTrim(MidStr(TempList[i],12,7));
    Cells[3,i+1] := AllTrim(MidStr(TempList[i],19,11));
    Cells[4,i+1] := AllTrim(MidStr(TempList[i],30,7));
    Cells[5,i+1] := AllTrim(MidStr(TempList[i],38,7));
   end;
  TempList.Free;

 end; {with}
end;

procedure TPrvRatesT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TPrvRatesT2_2027.SaveBtnClick(Sender: TObject);
Var i:Integer;TempList : TStringList;
begin
 TempList := TStringList.Create;
 With StringGrid1 do
 begin
  For i:=0 to 14 do
   begin
    TempList.Add(
     AllTrim(PaddR(AllTrim(Cells[0,i+1]),4)
            +PaddR(AllTrim(Cells[1,I+1]),7)
            +PaddR(AllTrim(Cells[2,I+1]),8)
            +PaddR(AllTrim(Cells[3,I+1]),11)
            +PaddR(AllTrim(Cells[4,I+1]),8)
            +PaddR(AllTrim(Cells[5,I+1]),7)));
   end;{i}
 end; {with}
 TempList.SaveToFile(AppDir+'\'+'PRVRATES.D');
 TempList.Free;
 InitPrvRates(RetNo);
 Close;
 //If RetNo>0 then MainForm.RecalcBtnClick(Application);
end;

end.
