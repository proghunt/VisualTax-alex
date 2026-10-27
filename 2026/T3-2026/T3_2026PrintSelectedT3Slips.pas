unit T3_2026PrintSelectedT3Slips;
interface
uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,DBCtrls,Mask,vtEditBox,vtLabel,vtShape,Buttons,
  CheckLst;

type
TPrintSelectedT3SlipsT3_2026 = class(TForm)
    CheckListBox1: TCheckListBox;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    selectedT3SlipRecipient: TRadioGroup;
    PrintDialogItem: TPrintDialog;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure PrintSelectedCCRAT3Slips(RetNo:Integer;CopyType:Integer; var selectedT3SlipsList:TStringList);
    procedure PrintSelectedTaxPayerT3Slips(RetNo:Integer;CopyType:Integer; var selectedT3SlipsList:TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
PrintSelectedT3SlipsT3_2026: TPrintSelectedT3SlipsT3_2026;

implementation

uses vtCommon,T3_2026,T3_2026print,T3_2026Declare,T3_2026common,T3_2026TrimStr,
  T3_2026ChildwinNew,T3_2026Common2,T3_2026main,vtTrimStr,vtShared;

{$R *.DFM}
procedure TPrintSelectedT3SlipsT3_2026.FormCreate(Sender: TObject);
var
i : integer;
begin
 Width:=400;
 Caption := SomeCaption;
 //Width:=GetLongestLengthItem(SomeList)* 6+100;
 If Width < Length(SomeCaption) * 7 then
   Width:=Length(SomeCaption) * 7+20;
 For i:= 0 to SomeList.Count -1 do
   CheckListBox1.Items.Add(SomeList[i]);
 CheckListBox1.ItemIndex := 0;
 CheckListBox1.State[0] := cbChecked;
 CheckListBox1ClickCheck(CheckListBox1);
end;

procedure TPrintSelectedT3SlipsT3_2026.CancelBtnClick(Sender: TObject);
begin
SelectedString := '';
Close;
end;

procedure TPrintSelectedT3SlipsT3_2026.CheckListBox1ClickCheck(Sender: TObject);
var
i:integer;
begin
 if (CheckListBox1.itemIndex = 0) and (CheckListBox1.State[0] = cbChecked) then
 begin
  for i:=1 to CheckListBox1.Items.Count -1 do
  begin
   CheckListBox1.Checked[i] := True;
   CheckListBox1.ItemEnabled[i] := False;
  end;
 end
 else if (CheckListBox1.itemIndex = 0) and (CheckListBox1.State[0] = cbUnchecked) then
 begin
  for i:=1 to CheckListBox1.Items.Count -1 do
  begin
   CheckListBox1.Checked[i] := False;
   CheckListBox1.ItemEnabled[i] := True;
  end;
 end;
 CheckListBox1.Repaint;
end;

procedure TPrintSelectedT3SlipsT3_2026.OKBtnClick(Sender: TObject);
var
FInst, FNonInst:String;
i, FNo, RetNo:integer;
selectedT3SlipsList:TStringList;
begin
 RetNo:=GetCurrentRetNo;

 selectedT3SlipsList := TStringList.Create;

 try
  if CheckListBox1.Items.Count > 0 then
  begin
   for i :=0 to CheckListBox1.Items.Count - 1 do
   begin
     if CheckListBox1.State[i] = cbChecked then
     begin
      selectedT3SlipsList.Add(alltrim(leftStr(CheckListBox1.Items[i], 10)));
     end;
   end;

   if selectedT3SlipsList.Count = 0 then
   begin
    showmessage('No slips where selected for printing.');
    exit;
   end;
   if (selectedT3SlipRecipient.itemIndex = 0) or
      (selectedT3SlipRecipient.itemIndex = 2) then //CRA and Trustee Copy
   begin
     If not PrintDialogItem.Execute then exit;
     PrintSelectedCCRAT3Slips(RetNo,selectedT3SlipRecipient.itemIndex,selectedT3SlipsList);  //print copy 1
   end
   else if selectedT3SlipRecipient.itemIndex = 1 then //Taxpayer Copy
   begin
     If not PrintDialogItem.Execute then exit;
     PrintSelectedTaxPayerT3Slips(RetNo,selectedT3SlipRecipient.itemIndex,selectedT3SlipsList);  //print copy 1
   end;
  end;
 finally
  //f.Release;
 end;
end;

Procedure TPrintSelectedT3SlipsT3_2026.PrintSelectedTaxPayerT3Slips(RetNo:Integer;CopyType:Integer; var selectedT3SlipsList:TStringList);
var
i,j,n,FNo,DestFNo: integer;
FromForm,DestForm:string; //[12];
begin
  If  CopyType = 1 then
    DestForm := 'T3SL23'
  else
    exit;

  DestFNo := GetFormNo(DestForm);

  If DestFNo=0 then exit;

  ClearForm(RetNo,DestForm);
  If Ret[RetNo].Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);

  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := Frec.FormNo;
    If (FRec.FormName = 'T3SUPL') and
       (Ret[RetNo].FrmHasData[FNo]) and
       (FetchElmFNo(RetNo,FNo,1) > '') and   {recepient}
       (FetchElmFNo(RetNo,FNo,41) <> 'N') or
        CertificationMode and (FRec.FormName = 'T3SUPL')
    then    {canadian resident}
    begin
      for j := 0 to (selectedT3SlipsList.Count - 1) do
      begin
        FromForm := Frec.FormInstName;
        if (FromForm = selectedT3SlipsList.Strings[j]) or  CertificationMode then
        begin


            //20170321
            // InitFormData and ClearForm above do not seem to work
            //InitFormData(RetNo,DestFNo);
            //ClearForm(RetNo,DestForm);
            // manually set to zero
            with Ret[RetNo].Frm[DestFNo] do
            begin
              for n := 23 to 34 do
                Tv[n] := 0;
              for n := 73 to 84 do
                Tv[n] := 0;
            end;


            CopyT3SlipToDestForm(RetNo,FromForm,DestFNo,1,DestForm); //20170610
            CopyT3SlipToDestForm(RetNo,FromForm,DestFNo,2,DestForm);  //20170610

            PrintForm(RetNo,DestForm,1,'');  //page 1)
            if LeftStr(DestForm,6)='T3SL23' then PrintForm(RetNo,DestForm,2,'');  //20231130 (has 2 pages
            ClearForm(RetNo,DestForm);
        end;
      end;
    end;
  end;
end;

Procedure TPrintSelectedT3SlipsT3_2026.PrintSelectedCCRAT3Slips(RetNo:Integer;CopyType:Integer; var selectedT3SlipsList:TStringList);
Var i,j,n,FNo,DestFNo,Cnt,SlipsOnPage : integer; FromForm,DestForm:string; //[12];
    PrintedSw :Boolean;
begin

  If      CopyType = 0 then DestForm := 'T3SL1'
  else if CopyType = 2 then DestForm := 'T3SL4'
  else exit;

  DestFNo := GetFormNo(DestForm);

  If DestFNo=0 then exit;

  ClearForm(RetNo,DestForm);
  If Ret[RetNo].Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);

  Cnt:=0;SlipsOnPage:=0;PrintedSw := false;
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := Frec.FormNo;
    If (FRec.FormName = 'T3SUPL') and
       (Ret[RetNo].FrmHasData[FNo]) and
       (FetchElmFNo(RetNo,FNo,1) > '') and   {recepient}
       (FetchElmFNo(RetNo,FNo,41) <> 'N') then    {canadian resident}
    begin
      for j := 0 to (selectedT3SlipsList.Count - 1) do
      begin
        FromForm := Frec.FormInstName;
        if FromForm = selectedT3SlipsList.Strings[j] then
        begin
         Inc(Cnt);
         If cnt=1 then
         begin
            //20170321
            // InitFormData and ClearForm do not seem to work
            //InitFormData(RetNo,DestFNo);
            //ClearForm(RetNo,DestForm);
            // manually set to zero
            with Ret[RetNo].Frm[DestFNo] do
            begin
              for n := 23 to 34 do
                Tv[n] := 0;
              for n := 73 to 84 do
                Tv[n] := 0;
              for n := 123 to 134 do
                Tv[n] := 0;
            end;
            CopyT3SlipToDestForm(RetNo,FromForm,DestFNo,1,DestForm); //20170610
            SlipsOnPage:=1;
            PrintedSw := False;
         end
         else if Cnt=2 then
         begin
              CopyT3SlipToDestForm(RetNo,FromForm,DestFNo,2,DestForm); //20170610
              SlipsOnPage:=2;
              PrintedSw := False;

              if (CopyType = 1) then
              begin
                if (SlipsOnPage=2) or (i>FList.count) then
                begin
                 PrintForm(RetNo,DestForm,1,'');  //put back
                 PrintedSw := True;
                 ClearForm(RetNo,DestForm);
                 SlipsOnPage:=0;
                 Cnt:=0;
                end;
              end;
         end
         else if Cnt=3 then
         begin
              CopyT3SlipToDestForm(RetNo,FromForm,DestFNo,3,DestForm);
              SlipsOnPage:=3;
              PrintedSw := False;
         end;

         If (SlipsOnPage=3) or (i>FList.count) then
         begin
           PrintForm(RetNo,DestForm,1,'');  //put back
           PrintedSw := True;
           ClearForm(RetNo,DestForm);
           SlipsOnPage:=0;
           Cnt:=0;
         end;
       end;
      end;
    end; {T3supl end}
  end; {for i:= do}

  If PrintedSw = False then
  begin
    PrintForm(RetNo,DestForm,1,'');  //? put back
  end;
end;



end.
