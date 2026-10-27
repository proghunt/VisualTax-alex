unit T1_2026Optim;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  ExtCtrls,Forms,Buttons,Dialogs,Grids,T1_2026Declare;

type
  TOptimT1_2026 = class(TForm)
    Panel4: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    CurRetNoName: TLabel;
    SpouseRetNoName: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    Gst0: TCheckBox;
    Gst1: TCheckBox;
    Dependants0: TCheckBox;
    Dependants1: TCheckBox;
    Medical0: TCheckBox;
    Medical1: TCheckBox;
    PrvCr0: TCheckBox;
    PrvCr1: TCheckBox;
    Don0: TCheckBox;
    Don1: TCheckBox;
    Polit0: TCheckBox;
    Polit1: TCheckBox;
    Label18: TLabel;
    Bevel1: TBevel;
    ApplyBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label2: TLabel;
    LblNetInc1: TLabel;
    LblNetInc2: TLabel;
    Label5: TLabel;
    LblTxblInc1: TLabel;
    LblTxblInc2: TLabel;
    Label7: TLabel;
    LblPayable1: TLabel;
    LblPayable2: TLabel;
    LblRef1: TLabel;
    LblRef2: TLabel;
    Bevel3: TBevel;
    Label4: TLabel;
    Label6: TLabel;
    TotPayableLbl: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    CurRetLbl: TLabel;
    Image1: TImage;
    Label8: TLabel;
    Label9: TLabel;

    Procedure ShowCplResults(RetNo:Integer;SpouseRetNo:integer);
    Procedure ApplyCplOptions(RetNo:Integer;SpouseRetNo:integer;
     CplGst,CplMedical,CplDependants,CplPrvCr,CplDon,CplPolit :Boolean);

    Procedure CompareCplResults(PrevTotal,NewTotal:Real);
    Procedure InitPrvCrForms(RetNo:integer;SpouseRetNo:integer;FNo:integer);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure Gst0Click(Sender: TObject);
    procedure Gst1Click(Sender: TObject);
    procedure Dependants0Click(Sender: TObject);
    procedure Medical0Click(Sender: TObject);
    procedure PrvCr0Click(Sender: TObject);
    procedure Don0Click(Sender: TObject);
    procedure Polit0Click(Sender: TObject);
    procedure Dependants1Click(Sender: TObject);
    procedure Medical1Click(Sender: TObject);
    procedure PrvCr1Click(Sender: TObject);
    procedure Don1Click(Sender: TObject);
    procedure Polit1Click(Sender: TObject);
  private
    RetNo:Integer;
  end;

var
  Optim: TOptimT1_2026;
  SpouseRetNo :integer; {return before coupling}
  PrevTotal,NewTotal:Real;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Common,T1_2026Common2,T1_2026TrimStr,
  T1_2026ChildWinNEW,T1_2026CalcCpl,T1_2026T1Rtns,T1_2026Main,T1_2026Calc,
  vtTrimStr,vtShared;

procedure TOptimT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TOptimT1_2026.FormCreate(Sender: TObject);
Var i,j:integer;
begin
 RetNo:=GetCurrentRetNo;
 SpouseRetNo := GetSpRetNo(RetNo);
 CurRetLbl.Caption := GetRetName(RetNo);
 CurRetLbl.Color := GetRetColor(RetNo);
 CurRetNoName.Caption :=FetchElm(RetNo,'T1',2);
 SpouseRetNoName.Caption :=FetchElm(RetNo,'T1',20);
 {Initialize check boxes}
 Gst0.Checked        := FetchElm(RetNo,'T1',29)>'';
 Gst1.Checked        := FetchElm(SpouseRetNo,'T1',29)>'';

 Dependants0.checked :=
       (Vl(FetchElm(RetNo,'DEPEND',1))+
        Vl(FetchElm(RetNo,'DEPEND',2))+
        Vl(FetchElm(RetNo,'DEPEND',3))+
        Vl(FetchElm(RetNo,'DEPEND',4)) >0);
      {ret[RetNo].FrmHasData[GetFormNo('DEPEND')];}
 Dependants1.checked :=
      (Vl(FetchElm(SpouseRetNo,'DEPEND',1))+
       Vl(FetchElm(SpouseRetNo,'DEPEND',2))+
       Vl(FetchElm(SpouseRetNo,'DEPEND',3))+
       Vl(FetchElm(SpouseRetNo,'DEPEND',4)) >0);
    {Ret[SpouseRetNo]^.FrmHasData[GetFormNo('DEPEND')];}

 Medical0.checked    := Ret[RetNo].FormHasData['MEDICAL'];
 Medical1.checked    := Ret[SpouseRetNo].FormHasData['MEDICAL'];

 Don0.checked        :=Ret[RetNo].FormHasData['DON'];
 Don1.checked        :=Ret[SpouseRetNo].FormHasData['DON'];

 {PrvCr0.checked :=Ret[RetNo].FrmHasData[GetFormmNo('DEPEND')];}
 Polit0.checked      :=Ret[RetNo].FormHasData['POLIT'];
 Polit1.checked      :=Ret[SpouseRetNo].FormHasData['POLIT'];
 ShowCplResults(RetNo,SpouseRetNo);
end;

procedure TOptimT1_2026.ApplyBtnClick(Sender: TObject);
Var i, j,FNo,result : Integer;
x :real;
S : string;
CplGst,CplMedical,CplDependants,CplPrvCr,CplDon,CplPolit :Boolean;
begin
 Screen.Cursor := crHourGlass;
 CplGst        := Gst0.Checked;
 CplDependants := Dependants0.checked;
 CplMedical    := Medical0.checked;
 CplDon        := Don0.checked;
 CplPrvCr      := PrvCr0.checked;
 CplPolit      := Polit0.checked;

 Screen.Cursor := crHourGlass;
 PrevTotal := Ret[RetNo].Lnn[420]+Ret[SpouseRetNo].Lnn[420]
            +Ret[RetNo].Lnn[42800]+Ret[SpouseRetNo].Lnn[42800];
            //Ret[RetNo].Lnn[43500]+Ret[SpouseRetNo].Lnn[43500];
 ApplyCplOptions(RetNo,SpouseRetNo,
  CplGst,CplMedical,CplDependants,CplPrvCr,CplDon,CplPolit);
 RecalcEverything(RetNo);
 RecalcEverything(SpouseRetNo);
 //ShowCplResults(RetNo,SpouseRetNo);
 NewTotal := Ret[RetNo].Lnn[420]+Ret[SpouseRetNo].Lnn[420]
            +Ret[RetNo].Lnn[42800]+Ret[SpouseRetNo].Lnn[42800];
            // Ret[RetNo].Lnn[43500]+Ret[SpouseRetNo].Lnn[43500];
 ShowCplResults(RetNo,SpouseRetNo);
 CompareCplResults(PrevTotal,NewTotal);
 Ret[RetNo].MyChild.Invalidate; //SendMessage(MDIHandle,WM_PAINT,0,0);
 Screen.Cursor := crDefault;
end;

Procedure TOptimT1_2026.ApplyCplOptions(RetNo:Integer;SpouseRetNo:integer;
  CplGst,CplMedical,CplDependants,CplPrvCr,CplDon,CplPolit :Boolean);
Var i,FNo:Integer;FInst:String;
Begin
// InfoFNo:=GetFormNo('INFO');
 {reverse GST}
 If CplGst then
  begin
  Ret[RetNo].Frm[InfoFNo].Strings[29] := 'X';
  Ret[SpouseRetNo].Frm[InfoFNo].Strings[29] :='';
  end
  else
  begin
   Ret[SpouseRetNo].Frm[InfoFNo].Strings[29] := 'X';
   Ret[RetNo].Frm[InfoFNo].Strings[29] :='';
  end;
 {medical}
  If CplMedical then
   TransferMedical(RetNo,SpouseRetNo)
  else
   TransferMedical(SpouseRetNo,RetNo);

 (*
 If CplMedical then
   begin
    if Ret[SpouseRetNo].FrmHasData[GetFormNo('MEDICAL')] then MoveForm(SpouseRetNo,'MEDICAL',RetNo);
    For i:=1 to 10 do
    begin
     FInst:='#'+AllTrim(IntToStr(i));
     FNo:=GetFormNo('MEDSUPL'+FInst);
     if Ret[SpouseRetNo].FrmHasData[FNo] then
      begin
        If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
        MoveForm(SpouseRetNo,'MEDSUPL'+FInst,RetNo);
       end;
    end;
   end
 else
   begin
    if Ret[RetNo].FrmHasData[GetFormNo('MEDICAL')] then MoveForm(RetNo,'MEDICAL',SpouseRetNo);
    For i:=1 to 10 do
    begin
     FInst:='#'+AllTrim(IntToStr(i));
     FNo:=GetFormNo('MEDSUPL'+FInst);
     if Ret[RetNo].FrmHasData[FNo] then
      begin
       If Ret[SpouseRetNo].Frm[Fno].Count =0 then InitFormData(SpouseRetNo,FNo);
       MoveForm(RetNo,'MEDSUPL'+FInst,SpouseRetNo);
     end;
    end;
   end;
 *)
{donations}
  If CplDon then
   TransferDonations(RetNo,SpouseRetNo)
  else
   TransferDonations(SpouseRetNo,RetNo);


 (*
 If CplDon then
    begin
     if Ret[SpouseRetNo].FrmHasData[GetFormNo('DON')] then
      MoveForm(SpouseRetNo,'DON',RetNo);
    end
 else
    begin
    if Ret[RetNo].FrmHasData[GetFormNo('DON')] then
     MoveForm(RetNo,'DON',SpouseRetNo);
    end;
 *)
{polit}
 If CplPolit then
    begin
     if Ret[SpouseRetNo].FormHasData['POLIT'] then
      MoveForm(SpouseRetNo,'POLIT',RetNo,'POLIT');
    end
 else
    begin
    if Ret[RetNo].FormHasData['POLIT'] then
     MoveForm(RetNo,'POLIT',SpouseRetNo,'POLIT');
    end;
 RecalcEverything(RetNo);
 RecalcEverything(SpouseRetNo);
end;

Procedure TOptimT1_2026.CompareCplResults(PrevTotal,NewTotal:Real);
Begin
 ShowMessage('Total Family Refund/Balance Due (before )'+FormatFloat('##,###,###.00',PrevTotal)+
     Chr(13)+'Total Family Refund/Balance Due (current)'+FormatFloat('##,###,###.00',NewTotal));
end;

Procedure TOptimT1_2026.ShowCplResults(RetNo:Integer;SpouseRetNo:integer);
begin
   LblNetInc1.Caption := FormatFloat('##,###,###.00',Ret[RetNo].Lnn[23600]);
   LblNetInc2.Caption := FormatFloat('##,###,###.00',Ret[SpouseRetNo].Lnn[23600]);
   LblTxblInc1.Caption:= FormatFloat('##,###,###.00',Ret[RetNo].Lnn[26000]);
   LblTxblInc2.Caption:= FormatFloat('##,###,###.00',Ret[SpouseRetNo].Lnn[26000]);
   LblPayable1.Caption:= FormatFloat('##,###,###.00',Ret[RetNo].Lnn[43500]);
   LblPayable2.Caption:= FormatFloat('##,###,###.00',Ret[SpouseRetNo].Lnn[43500]);
   TotPayableLbl.Caption:= FormatFloat('##,###,###.00',Ret[RetNo].Lnn[43500]+Ret[SpouseRetNo].Lnn[43500]);
   If Ret[RetNo].Balance >0 then
      LblRef1.Caption:= FormatFloat('##,###,###.00',-Ret[RetNo].Lnn[48500])
   else
      LblRef1.Caption:= FormatFloat('##,###,###.00',Ret[RetNo].Lnn[48400]);
   If Ret[SpouseRetNo].Balance >0 then
      LblRef2.Caption:= FormatFloat('##,###,###.00',-Ret[SpouseRetNo].Lnn[48500])
   else
      LblRef2.Caption:= FormatFloat('##,###,###.00',Ret[SpouseRetNo].Lnn[48400]);
end;

Procedure TOptimT1_2026.InitPrvCrForms(RetNo:integer;SpouseRetNo:integer;FNo:integer);
begin
 If Ret[RetNo].Frm[FNo].Count =0 then InitFormData(RetNo,FNo);
 If Ret[SpouseRetNo].Frm[FNo].Count =0 then InitFormData(SpouseRetNo,FNo);
end;


procedure TOptimT1_2026.Gst0Click(Sender: TObject);
begin
Gst1.Checked := Not Gst0.Checked;
end;

procedure TOptimT1_2026.Gst1Click(Sender: TObject);
begin
Gst0.Checked := Not Gst1.Checked;
end;

procedure TOptimT1_2026.Dependants0Click(Sender: TObject);
begin
Dependants1.Checked := Not Dependants0.Checked;
end;

procedure TOptimT1_2026.Medical0Click(Sender: TObject);
begin
Medical1.Checked := Not Medical0.Checked;
end;

procedure TOptimT1_2026.PrvCr0Click(Sender: TObject);
begin
PrvCr1.Checked := Not PrvCr0.Checked;
end;

procedure TOptimT1_2026.Don0Click(Sender: TObject);
begin
Don1.Checked := Not Don0.Checked;
end;

procedure TOptimT1_2026.Polit0Click(Sender: TObject);
begin
Polit1.Checked := Not Polit0.Checked;
end;

procedure TOptimT1_2026.Dependants1Click(Sender: TObject);
begin
Dependants0.Checked := Not Dependants1.Checked;
end;

procedure TOptimT1_2026.Medical1Click(Sender: TObject);
begin
Medical0.Checked := Not Medical1.Checked;
end;

procedure TOptimT1_2026.PrvCr1Click(Sender: TObject);
begin
PrvCr0.Checked := Not PrvCr1.Checked;
end;

procedure TOptimT1_2026.Don1Click(Sender: TObject);
begin
Don0.Checked := Not Don1.Checked;
end;

procedure TOptimT1_2026.Polit1Click(Sender: TObject);
begin
Polit0.Checked := Not Polit1.Checked;
end;

end.
