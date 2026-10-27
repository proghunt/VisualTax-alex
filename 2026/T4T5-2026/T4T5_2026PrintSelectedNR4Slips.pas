unit T4T5_2026PrintSelectedNR4Slips;
interface
uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,DBCtrls,Mask,vtEditBox,vtLabel,vtShape,Buttons,
  CheckLst;

type
TPrintSelectedNR4SlipsT4T5_2026 = class(TForm)
    CheckListBox1: TCheckListBox;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    selectedNr4SlipRecipient: TRadioGroup;
    PrintDialogItem: TPrintDialog;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure PrintSelectedCCRANR4Slips(RetNo:Integer;CopyType:Integer; var selectedNR4SlipsList:TStringList);
    procedure PrintSelectedTaxPayerNR4Slips(RetNo:Integer;CopyType:Integer; var selectedNR4SlipsList:TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  PrintSelectedNR4Slips: TPrintSelectedNR4SlipsT4T5_2026;
implementation

uses vtCommon,T4T5_2026,T4T5_2026print,T4T5_2026Declare,T4T5_2026common,T4T5_2026TrimStr,
  T4T5_2026ChildwinNew,T4T5_2026Common2,T4T5_2026main,vtTrimStr,vtShared;

{$R *.DFM}

procedure TPrintSelectedNR4SlipsT4T5_2026.FormCreate(Sender: TObject);
var
i : integer;
begin
 Width:=400;
 PrintSelectedNR4Slips.Caption := SomeCaption;
 //Width:=GetLongestLengthItem(SomeList)* 6+100;
 If Width < Length(SomeCaption) * 7 then
   Width:=Length(SomeCaption) * 7+20;
 For i:= 0 to SomeList.Count -1 do
   CheckListBox1.Items.Add(SomeList[i]);
 CheckListBox1.ItemIndex := 0;
 CheckListBox1.State[0] := cbChecked;
 CheckListBox1ClickCheck(CheckListBox1);
end;

procedure TPrintSelectedNR4SlipsT4T5_2026.CancelBtnClick(Sender: TObject);
begin
SelectedString := '';
Close;
end;

procedure TPrintSelectedNR4SlipsT4T5_2026.CheckListBox1ClickCheck(Sender: TObject);
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

procedure TPrintSelectedNR4SlipsT4T5_2026.OKBtnClick(Sender: TObject);
var
FInst, FNonInst:String;
i, FNo, RetNo:integer;
selectedNR4SlipsList:TStringList;
begin
 RetNo:=GetCurrentRetNo;

 selectedNR4SlipsList := TStringList.Create;

 try
  if CheckListBox1.Items.Count > 0 then
  begin
   for i :=0 to CheckListBox1.Items.Count - 1 do
   begin
     if CheckListBox1.State[i] = cbChecked then
     begin
      selectedNR4SlipsList.Add(alltrim(leftStr(CheckListBox1.Items[i], 10)));
     end;
   end;

   if selectedNR4SlipsList.Count = 0 then
   begin
    showmessage('No slips where selected for printing.');
    exit;
   end;
   if (selectedNR4SlipRecipient.itemIndex = 0) or
      (selectedNR4SlipRecipient.itemIndex = 2) then //CRA and Trustee Copy
   begin
     If not PrintDialogItem.Execute then exit;
     PrintSelectedCCRANR4Slips(RetNo,selectedNR4SlipRecipient.itemIndex,selectedNR4SlipsList);  //print copy 1
   end
   else if selectedNR4SlipRecipient.itemIndex = 1 then //Taxpayer Copy
   begin
     If not PrintDialogItem.Execute then
       exit;
     PrintSelectedTaxPayerNR4Slips(RetNo,selectedNR4SlipRecipient.itemIndex,selectedNR4SlipsList);  //print copy 1
   end;
  end;
 finally
  //f.Release;
 end;
end;

Procedure TPrintSelectedNR4SlipsT4T5_2026.PrintSelectedTaxPayerNR4Slips(RetNo:Integer;CopyType:Integer; var selectedNR4SlipsList:TStringList);
var
i,j,FNo,DestFNo: integer;
FromForm,DestForm:string; //[12];
begin
  If  CopyType = 0 then
    DestForm := 'NR4SL23'
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
    If (FRec.FormName = 'NR4DETL') and
       (Ret[RetNo].FrmHasData[FNo]) and
       (FetchElmFNo(RetNo,FNo,1) > '') and   {recepient}
       (FetchElmFNo(RetNo,FNo,41) <> 'N') or
        CertificationMode and (FRec.FormName = 'NR$DET')
    then    {canadian resident}
    begin
      for j := 0 to (selectedNR4SlipsList.Count - 1) do
      begin
        FromForm := Frec.FormInstName;
        if (FromForm = selectedNR4SlipsList.Strings[j]) or  CertificationMode then
        begin
            CopyNR4SlipToDestForm(RetNo,FromForm,DestFNo,1,DestForm);
            CopyNR4SlipToDestForm(RetNo,FromForm,DestFNo,2,DestForm);

            PrintForm(RetNo,DestForm,1,'');  //put back
            ClearForm(RetNo,DestForm);
        end;
      end;
    end;
  end;
end;

Procedure TPrintSelectedNR4SlipsT4T5_2026.PrintSelectedCCRANR4Slips(RetNo:Integer;CopyType:Integer; var selectedNR4SlipsList:TStringList);
Var i,j,FNo,DestFNo,Cnt,SlipsOnPage : integer; FromForm,DestForm:string; //[12];
    PrintedSw :Boolean;
begin

  If      CopyType = 0 then DestForm := 'NR4SL1'
  else if CopyType = 2 then DestForm := 'NR4SL4'
  else exit;

  DestFNo := GetFormNo(DestForm);

  If DestFNo=0 then exit;

  //ClearForm(RetNo,DestForm);
  If Ret[RetNo].Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);

  Cnt:=0;SlipsOnPage:=0;PrintedSw := false;
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := Frec.FormNo;
    If (FRec.FormName = 'NR4DET') and
       (Ret[RetNo].FrmHasData[FNo]) then
    begin
      for j := 0 to (selectedNR4SlipsList.Count - 1) do
      begin
        FromForm := Frec.FormInstName;
        if FromForm = selectedNR4SlipsList.Strings[j] then
        begin
         Inc(Cnt);
         If cnt=1 then
         begin
            CopyNr4SlipToDestForm(RetNo,FromForm,DestFNo,1,DestForm);
            SlipsOnPage:=1;
            PrintedSw := False;
         end
         else if Cnt=2 then
         begin
              CopyNR4SlipToDestForm(RetNo,FromForm,DestFNo,2,DestForm);
              SlipsOnPage:=2;
              PrintedSw := False;

             // if (CopyType = 1) then
              if (CopyType = 0) then
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
         end;
         {
         else if Cnt=3 then
         begin
              CopyNR4SlipToDestForm(RetNo,FromForm,DestFNo,3,DestForm);
              SlipsOnPage:=3;
              PrintedSw := False;
         end;
         }
         If (SlipsOnPage=2) or (i>FList.count) then
         begin
           PrintForm(RetNo,DestForm,1,'');  //put back

           PrintedSw := True;
           ClearForm(RetNo,DestForm);
           SlipsOnPage:=0;
           Cnt:=0;
         end;
       end;
      end;
    end; {NR4DET end}
  end; {for i:= do}

  If PrintedSw = False then
  begin
    PrintForm(RetNo,DestForm,1,'');  //? put back
  end;
end;



end.
