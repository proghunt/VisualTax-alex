unit T1_2026CopyFrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TCopyFrmT1_2026 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    CopyBtn: TBitBtn;
    BitBtn2: TBitBtn;
    MoveBtn: TBitBtn;
    Panel2: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label2: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Frmlist: TListBox;
    ListBoxLbl: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ToFormNameBox: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblWarning: TLabel; //20170219 Igor
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FrmlistClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure ToFormNameBoxChange(Sender: TObject);//20170219 Igor
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RetNo:Integer;
  CopyFrmT1_2026: TCopyFrmT1_2026;
  FromRetNo,ToRetNo : integer;
  FromFormName, ToFormName :string;

procedure CopyFrm(RNo: integer; FName: string);

implementation

{$R *.DFM}

uses
  vtMulti,vtCommon,T1_2026,T1_2026Common,T1_2026Common2,T1_2026TrimStr,
  T1_2026Declare,T1_2026calc,T1_2026ChildWinNEW,vtTrimStr,vtShared;

procedure CopyFrm(RNo: integer; FName: string);
begin
  with TCopyFrmT1_2026.Create(Application) do
  begin
    FromRetNo := RNo;
    FromFormName := FName;
    ShowModal;
    Free;
  end;
end;

procedure TCopyFrmT1_2026.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TCopyFrmT1_2026.FormCreate(Sender: TObject);
Var I: integer; RNo:Integer;
begin
   //If RetInMem=1 then MoveBtn.Enabled :=false;
   RNo:=GetCurrentRetNo;
   for i :=0 to (FList.Count - 1) do
   begin
     FRec := FList.Items[i];
     if FRec.FormNo <= 0 then  Continue; //20170130 Igor
     If Ret[RNo].FrmHasData[Frec.FormNo] then
     begin
      If RetInMem=1 then
      begin
       if Frec.FormInst>'' then
         FrmList.Items.Add(FRec.FormName+FRec.FormInst);
      end
      else
      begin
        FrmList.Items.Add(FRec.FormName+FRec.FormInst);
      end;
     end; //has data
   end;

   for i := 0 to (RetList.Count - 1) do
   begin
     RetRec := RetList.Items[i];
     //20170130 Igor >>>
     if not Assigned(RetRec) or
        RetRec.Destroying or
        (RetRec.MyApp <> CurrentApp) then
       Continue;
     //20170130 Igor <<<
     ListBox1.Items.add(GetRetName(RetRec.RetNo));
     ListBox2.Items.add(IntToStr(RetRec.RetNo));
     ListBox3.Items.add(GetRetName(RetRec.RetNo));
     ListBox4.Items.add(IntToStr(RetRec.RetNo));
   end;
   If FrmList.Items.count=0 then exit;

   {Position in current Formname}
   FrmList.ItemIndex  :=0;
//   FromFormName := FRec.FormName; {at time of entering copy}
   For i:=0 to FrmList.Items.Count-1 do
      If FromFormName = FrmList.Items[i] then
       begin FrmList.ItemIndex :=i;break;end;
   ListBox1.ItemIndex := 0;
   ListBox3.ItemIndex := 0;
   FrmlistClick(Sender); {in case not found}
end;

procedure TCopyFrmT1_2026.CopyBtnClick(Sender: TObject);
begin
 If FromFormName ='' then exit;
 ToFormName:=ToFormNameBox.Text;
 FromRetNo :=StrToInt(ListBox2.Items[ListBox1.ItemIndex]);
 ToRetNo :=StrToInt(ListBox4.Items[ListBox3.ItemIndex]);
 If ((FromFormName = ToFormName)
 and (FromRetNo = ToRetNo))
 then
 begin
  ShowMessage('Copy not allowed to the same form of the same return');
  Exit;
 end;

 If Ret[ToRetNo].FRmHasData[GetFormNo(ToFormName)] then
 begin
  if MessageDlg('Destination form already has data.  Proceed anyway?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     //continue
  else
   Exit;
 end;

 If Ret[FromRetNo].FRmHasData[GetFormNo(FromFormName)] then
 begin
  CloneForm(FromRetNo,FromFormName, ToRetNo, ToFormName, True); {fromR,FromF,ToR} //20170219 Igor
  SumSlips(ToRetNo,'ALL');
  CalcAll(ToRetNo);
  ShowMessage('Form has been copied and return recalculated.'+
    Chr(13)+'Press any key...');
  RetNo := ToRetNo;
  OpenForm(ToRetNo,GetFormNo(FromFormName),0);
 end
 Else
  ShowMessage('Form: '+FromFormName+' is empty'+Chr(13)+'Data not copied');
end;

procedure TCopyFrmT1_2026.MoveBtnClick(Sender: TObject);
begin
 FromRetNo :=StrToInt(ListBox2.Items[ListBox1.ItemIndex]);
 ToRetNo :=StrToInt(ListBox4.Items[ListBox3.ItemIndex]);
 ToFormName:=ToFormNameBox.Text;
 If ((FromFormName = ToFormName)
 and (FromRetNo = ToRetNo)) then
 begin
  ShowMessage('Move not allowed to the same form of the same return');
  Exit;
 end;

 If Ret[ToRetNo].FRmHasData[GetFormNo(ToFormName)] then
 begin
  if MessageDlg('Destination form already has data.  Proceed anyway?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     //continue
  else
   Exit;
 end;

 If Ret[FromRetNo].FRmHasData[GetFormNo(FromFormName)] then
 begin
  MoveForm(FromRetNo,FromFormName,ToRetNo,ToFormName);
  SumSlips(ToRetNo,'ALL');
  CalcAll(ToRetNo);
  ShowMessage('Form data moved and returns recalculated.'+
   Chr(13)+'Press any key...');
  RetNo := ToRetNo;
  OpenForm(ToRetNo,GetFormNo(FromFormName),0);
 end
 Else
  ShowMessage('Form: '+FromFormName+' is empty'+Chr(13)+'Data not moved');
end;

procedure TCopyFrmT1_2026.ToFormNameBoxChange(Sender: TObject);
var
  F: TFrec;
  R: Integer;
begin
  R :=StrToInt(ListBox4.Items[ListBox3.ItemIndex]);

  F := RetList[R].FList.ByFormName(ToFormNameBox.Text);
  if F.FormNo = 0 then
  begin
    lblWarning.Caption := 'Form "'+ToFormNameBox.Text+'" not found!';
    lblWarning.Visible := True;
    lblWarning.Top := lblWarning.Parent.Height+1;
  end
  else
  if Ret[R].FRmHasData[F.FormNo] then
  begin
    lblWarning.Caption := 'Form "'+ToFormNameBox.Text+'" has data!';
    lblWarning.Visible := True;
    lblWarning.Top := lblWarning.Parent.Height+1;
  end
  else
    lblWarning.Visible := False;
end;

procedure TCopyFrmT1_2026.FrmlistClick(Sender: TObject);
Var I :integer;
begin
  for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If FrmList.Items[FrmList.ItemIndex] = FRec.FormName+FRec.FormInst
      then
      begin
       FromFormName :=FRec.FormName+FRec.FormInst;
       ToFormNameBox.Text:=FromFormName;
       ListBoxLbl.Caption := FRec.FormDescr;
      end;
   end;
end;

procedure TCopyFrmT1_2026.FormPaint(Sender: TObject);
begin
If ListBox1.ItemIndex > -1 then
  begin CopyBtn.Enabled := True;MoveBtn.Enabled := True;end
  else begin CopyBtn.Enabled := False;MoveBtn.Enabled := False;end;
end;


end.
