unit T2_2027FSUM;
//imported 08-01

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls;

type
  TFrmSumT2_2027 = class(TForm)
    Panel1: TPanel;
    T2124Btn: TButton;
    T2121Btn: TButton;
    ExitBtn: TBitBtn;
    T2032Btn: TButton;
    T2042Btn: TButton;
    RetNameLbl: TLabel;
    Label1: TLabel;
    SwitchBtn: TBitBtn;
    T776Btn: TButton;
    AutoExpBtn: TButton;
    T2209Btn: TButton;
    T2036Btn: TButton;
    StringGrid1: TStringGrid;
    FNameBox: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure T2121BtnClick(Sender: TObject);
    procedure T2124BtnClick(Sender: TObject);
    procedure T2032BtnClick(Sender: TObject);
    procedure T2042BtnClick(Sender: TObject);

    procedure ExitBtnClick(Sender: TObject);
    procedure ShowFormColumn(FormNo :Integer; FormCol: integer);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Longint;
      var Value: OpenString);
    procedure StringGrid1SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
   { procedure DisplayForm(FName : String);}
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure SwitchBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure T776BtnClick(Sender: TObject);
    procedure AutoExpBtnClick(Sender: TObject);
    procedure T2209BtnClick(Sender: TObject);
    procedure T2036BtnClick(Sender: TObject);
  private
    RetNo: integer;
    FName : String;//[10]; //20150701
    SwitchingForm : boolean;
  public
    { Public declarations }
  end;

var
  FrmSum: TFrmSumT2_2027;


implementation

{$R *.DFM}

uses
  vtCommon,vtMulti,
  T2_2027,T2_2027Declare,T2_2027Common,
  T2_2027Common2,T2_2027Calc,T2_2027TrimStr,//T2_2027ChildWinNew;
  vtTrimStr,vtShared;

procedure TFrmSumT2_2027.Button1Click(Sender: TObject);
var
  I, J: Integer;
begin
 {SetTextAlign(Canvas.Handle,TA_RIGHT);}
end;

procedure TFrmSumT2_2027.ExitClick(Sender: TObject);
begin
close;
end;

(*
procedure TFrmSum.DisplayForm(FName : String);
var
FormCol : integer;
begin
  SwitchingForm := True;
  FormNo := GetFormNo(FName);
  ShowFormFixed(RetNo,FName);
  Invalidate;
  SwitchingForm := False;
 end;
*)

procedure TFrmSumT2_2027.T2124BtnClick(Sender: TObject);
begin
 FName := 'T2124_1'; Invalidate;
end;

procedure TFrmSumT2_2027.T2032BtnClick(Sender: TObject);
begin
FName := 'T2032_1'; Invalidate;
end;

procedure TFrmSumT2_2027.T2042BtnClick(Sender: TObject);
begin
FName := 'T2042_1';Invalidate;
end;

procedure TFrmSumT2_2027.T2121BtnClick(Sender: TObject);
begin
 FName := 'T2121_1';Invalidate;
end;

procedure TFrmSumT2_2027.T776BtnClick(Sender: TObject);
begin
  FName := 'T776_1';Invalidate;
end;
procedure TFrmSumT2_2027.AutoExpBtnClick(Sender: TObject);
begin
  FName := 'AUTOEXP';Invalidate;
end;

procedure TFrmSumT2_2027.T2036BtnClick(Sender: TObject);
begin
 FName := 'T2036';Invalidate;
end;

procedure TFrmSumT2_2027.T2209BtnClick(Sender: TObject);
begin
FName := 'T2209';Invalidate;
end;

procedure TFrmSumT2_2027.ShowFormColumn(FormNo :Integer; FormCol: integer);
var
i,j : integer;
s : string[15];
x : Real;
begin
 (*
  with StringGrid1 do
     for j := 1 to MxFormColumns do
       begin

        x :=Vl(Ret[RetNo]^.Form[FirstFormIndex[FormNo]+FormCol-1].Strings[j]);
        Str(x:12:2,s); if x = 0 then s := '';
        Cells[FormCol,j] := s;
       end;
  *)
 end;


procedure TFrmSumT2_2027.ExitBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TFrmSumT2_2027.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
 NonZeroValue : string[20];
begin
 (*
 If SwitchingForm then exit;
 NonZeroValue := Value; If NonZeroValue = '0.00' then NonZeroValue := '';
  If NonZerovalue <>
      Ret[RetNo]^.Form[FirstFormIndex[FormNo]+Acol- 1].Strings[ARow] then
    Begin
     Ret[RetNo]^.Form[FirstFormIndex[FormNo]+Acol-1].Strings[ARow] := NonZeroValue;
     RepaintGrid := True;
    end;
 *)
end;

procedure TFrmSumT2_2027.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Longint; var Value: OpenString);
{numeric formatting}
begin
  (*
  if ARow = 1 then exit; {no formatting on the description line}
  If (FName = 'T4A') and (ARow = 2) then exit;
  If (FName = 'T5') then
    begin
     if (ARow = 3) or (ARow = 5) then exit;
    end;
  If (FName = 'T4AP') and (ARow < 4) then exit;
  If (FName = 'T3') then
    begin
     if (ARow = 3) or (ARow = 5) then exit;
    end;
  Str(vl(Value):12:2,Value);
  if Vl(Value) = 0 then Value := '';
  *)
end;



procedure TFrmSumT2_2027.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
 {exit if numeric validation not needed on strings}
 (*
 if StringGrid1.Row = 1 then exit;
 If FName = 'T3' then
  begin
   if (StringGrid1.Row = 3) or (StringGrid1.Row = 5) then exit;
  end;
 If FName = 'T5' then
  begin
   if (StringGrid1.Row = 3) or (StringGrid1.Row = 5) then exit;
  end;

 if ValidateAmountField(key) = False then key := CHR(0);
 *)
end;

procedure TFrmSumT2_2027.StringGrid1SelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
var
i : integer;
begin
(*
 If RepaintGrid then
  begin
   For i :=2 to MxFormColumns-1 do SummarizeFormRow(RetNo,FName,i);
   ShowFormColumn(FormNo,Col);  {current column}
   ShowFormColumn(FormNo,MxForms-1);  {total column}
   CalcAll(RetNo);
   SendMessage(MDIHandle,WM_PAINT,0,0);  {update status}
   RepaintGrid := False;
  end;
 *)
end;

procedure TFrmSumT2_2027.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{If Key = VK_RETURN then Key := VK_TAB;}

end;

procedure TFrmSumT2_2027.SwitchBtnClick(Sender: TObject);
begin
If RetInMem <1 then exit;
RetNo := GetNextReturn(RetNo);
RetNameLbl.Caption := GetRetName(RetNo);
RetNameLbl.Color := GetRetColor(RetNo);
Invalidate;
end;


procedure TFrmSumT2_2027.StringGrid1DblClick(Sender: TObject);
begin
 {FName := ExtractNonInstFormName(FName)+StringGrid1.Cells[0,StringGrid1.Row];}
 {ShowMessage(FName);}
 Close;
 OpenForm(RetNo,GetFormNo(FName),0);
end;

procedure TFrmSumT2_2027.FormPaint(Sender: TObject);
Var i: integer; Tot : real;
  FormNo: integer;
begin
  T776Btn.Enabled := False;
  AutoexpBtn.Enabled := False;
  T2209Btn.Enabled := False;
  T2036Btn.Enabled := False;

  FormNo := GetFormNo(FName);  {Came from calling program}
  RetNameLbl.Caption := GetRetName(RetNo);
  RetNameLbl.Color := GetRetColor(RetNo);
  {Caption}
  If      FName = 'T2124_1' then FNameBox.Caption := T2124Btn.Caption
  else if FName = 'T2032_1' then FNameBox.Caption := T2032Btn.Caption
  else if FName = 'T2042_1' then FNameBox.Caption := T2042Btn.Caption
  else if FName = 'T2121_1' then FNameBox.Caption := T2121Btn.Caption
  else if FName = 'T776_1' then FNameBox.Caption  := T776Btn.Caption
  else if FName = 'AUTOEXP' then FNameBox.Caption := AutoExpBtn.Caption
  else if FName = 'T2209' then FNameBox.Caption   := T2209Btn.Caption
  else if FName = 'T2036' then FNameBox.Caption   := T2036Btn.Caption
  ;


  {SwitchingForm := True;}
  for i := 1 to StringGrid1.RowCount-1 do  {?}
          StringGrid1.Cells[0,i] := '';

  If (FName = 'T2124_1')
   {or (FName = 'T2032_1') or
      (FName = 'T2042_1') or (FName = 'T2121_1') or
      (FName = 'T776_1')}
    then
    begin
      StringGrid1.ColCount := 4;
      StringGrid1.RowCount := 1+2;
        {GetHighestInst(ExtractNonInstFormName(FName))+2;}
       { CountMxInst(ExtractNonInstFormName(FName))+1;}
      StringGrid1.ColWidths[0] := 70; {270;}
      StringGrid1.ColWidths[1] := 150; {270;}
      For i := 2 to StringGrid1.ColCount-1 do
        StringGrid1.ColWidths[i] := 13 * 7;
      StringGrid1.FixedColor := GetRetColor(RetNo);
      StringGrid1.Cells[0,0] := 'Statement';
      For i :=1 to StringGrid1.RowCount-2 do StringGrid1.Cells[0,i] := '#'+IntToStr(i);
      StringGrid1.Cells[0,StringGrid1.RowCount-1] := 'Total';
      StringGrid1.Cells[1,0] := ' Name/Description';
      StringGrid1.Cells[2,0] := ' Gross Income';
      StringGrid1.Cells[3,0] := ' Net Income';
   end;
   {T2124 data}
   If FName = 'T2124_1' then
   begin
      For i := 1 to 1 do {? second form not found: StringGrid1.RowCount -2 do}
       begin
         StringGrid1.Cells[1,i] :=
          FetchElm(RetNo,'T2124_1',8); {Name}
         StringGrid1.Cells[2,i] :=
           JustRight(FetchElm(RetNo,'T2124_1',32),11); {gross income}
         StringGrid1.Cells[3,i] :=
           JustRight(FetchElm(RetNo,'T2124_2',6),11); {net income}
        (*
         StringGrid1.Cells[1,i] :=
          FetchElm(RetNo,'T2124_1'+'#'+IntToStr(i),8);} {Name}
         StringGrid1.Cells[2,i] :=
           JustRight(FetchElm(RetNo,'T2124_1'+'#'+IntToStr(i),32),15); {gross income}
         StringGrid1.Cells[2,i] :=
           JustRight(FetchElm(RetNo,'T2124_2'+'#'+IntToStr(i),6),15); {net income}
        *)
       end;
        {Total Gross}
       Tot :=0;
       For i := 1 to StringGrid1.RowCount -2 do
          Tot := Tot + Vl(StringGrid1.Cells[2,i]);
         StringGrid1.Cells[2,StringGrid1.RowCount-1] :=
             JustRight(FormatFloat('##,###,###.00',Tot),11);
         {Total Net}
         Tot :=0;
       For i := 1 to StringGrid1.RowCount -2 do
           Tot := Tot + Vl(StringGrid1.Cells[3,i]);
       StringGrid1.Cells[3,StringGrid1.RowCount-1] :=
           JustRight(FormatFloat('##,###,###.00',Tot),11);
   end;
end;

procedure TFrmSumT2_2027.FormCreate(Sender: TObject);
begin
 FName := 'T2124_1';
 Invalidate;
end;


end.


