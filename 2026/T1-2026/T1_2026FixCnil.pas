unit T1_2026FixCnil;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls;

type
  TFixCnilT1_2026 = class(TForm)
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    DataDirBox: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    DoOnlyBox: TCheckBox;
    Label5: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    PrintDialog1: TPrintDialog;
    Label15: TLabel;
    Label16: TLabel;
    LastYrDataDirBox: TEdit;
    Label17: TLabel;
    LastYearYesNo: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure IncreaseYear(Frm:String;Elm:Integer);
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  FixCnil: TFixCnilT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Calc,T1_2026Features,T1_2026T1Rtns2,vtTrimStr,vtShared;

procedure TFixCnilT1_2026.OKBtnClick(Sender: TObject);
var i,j,Cnt:integer; PrpStatus,EFStatus, Notes :String;
  LastYrCnilExp,LastYrCNILInc:string;
  FullFlName:String;TempList:TstringList;
  Hdr1,Hdr2,Hdr3,s:string;
begin
 Cnt:=0;
 If IsDataDirectoryGood(DataDirBox.Text) = False then exit;
 If (AllTrim(LastYrDataDirBox.Text) = '')
 and (UpperCase(LastYearYesNo.text)='Y')
 then
 begin
  ShowMessage('The T1-2002 data directory must be entered in Config | T1-2002 box');
  exit;
 end;
 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;
 If (UpperCase(LastYearYesNo.text)='Y')
     //20150826 IGOR
 and (FileExists(LastYrDataDirBox.Text+'\'+ClientsDbLite)=False) then
 begin
  ShowMessage('Data directory does not contain a VisualTax dataBase');
  LastYrDataDirBox.SetFocus;
  exit;
 end;

  OKbtn.Enabled:=False; CancelBtn.Enabled:=False;
  TempList:=TstringList.Create;
  TempList.Sorted:=True;
  for i:=0 to FileListBox1.Items.Count -1 do
  begin
     LastYrCnilExp:='';
     LastYrCnilInc:='';
     FileListBox1.ItemIndex :=i;
     FileListBox1.Refresh;
     If (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite))            //20150909 Igor
     and(UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite)+'-JOURNAL') //20150909 Igor
     then
     try
        RetNo:=ReadReturn(DataDirBox.Text,FileListBox1.Items[i]);
        if RetNo > 0 then
        begin
          Label7.Caption := '#'+IntToStr(i+1);
          Label7.Refresh;
          FullFlName:=LastYrDataDirBox.Text+'\'+LeftStr(GetSinNo(RetNo),8)+'.'+RightStr(GetSinNo(RetNo),1);
          If Ret[RetNo].Frm[GetFormNo('CFR')].Count =0 then InitFormData(RetNo,GetFormNo('CFR'));
          If Ret[RetNo].Frm[GetFormNo('T936')].Count =0 then InitFormData(RetNo,GetFormNo('T936'));
          If UpperCase(LastYearYesNo.text)='Y' then
           GetT12002CNIL(RetNo,LastYrCnilExp,LastYrCnilInc,FullFlName);
          If (Vl(FetchElm(RetNo,'T936',143)) <> Vl(FetchElm(RetNo,'CFR',29)))
          or (Vl(FetchElm(RetNo,'T936',147)) <> Vl(FetchElm(RetNo,'CFR',30)))
          or ((Vl(FetchElm(RetNo,'T936',143)) <> vl(LastYrCnilExp)) and (vl(LastYrCnilExp)>0))
          or ((Vl(FetchElm(RetNo,'T936',147)) <> Vl(LastYrCnilInc)) and (vl(LastYrCnilInc)>0))
          then
          begin
            If Vl(LastYrCnilExp)>0 then
             StoreElm(RetNo,'CFR',29,FormatFloat('########.##',Vl(LastYrCnilExp)));
            If Vl(LastYrCnilInc)>0 then
             StoreElm(RetNo,'CFR',30,FormatFloat('########.##',Vl(LastYrCnilInc)));

            If Vl(LastYrCnilExp)>0 then
             StoreElm(RetNo,'T936',143,FormatFloat('########.##',Vl(LastYrCnilExp)));
            If Vl(LastYrCnilInc)>0 then
             StoreElm(RetNo,'T936',147,FormatFloat('########.##',Vl(LastYrCnilInc)));

            Ret[RetNo].FormHasData['CFR']:=True;
            Ret[RetNo].FormHasData['T936']:=True;
            Calc(RetNo,'T936');
            CalcAll(RetNo);
            If not SaveReturn(RetNo,DataDirBox.Text,FileListBox1.Items[i],True,True) =0
             then ShowMessage('Return cannot be saved');
            Inc(Cnt,1);
            TempList.Add(AllTrim(GetLastName(RetNo))+' '+GetFirstName(RetNo)+' '+GetSinNo(RetNo));
          end;
         end;
     except
     end;
     If RetNo >0 then RemoveReturnFromMemory(RetNo);
     RetNo :=0; //RetINmem :=0;
  end;
  ShowMessage('Completed. ' +IntTostr(Cnt)+' returns fixed');
  TempList.SaveToFile(AppDir+'\'+'TempFile');
  If (TempList.Count >0)
  and (MessageDlg('Print listing of fixed returns?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes)
  then
  begin
   Hdr1 := PaddR(S,60)+' '+PaddR(DateToMonthDayYear(Date),20);
   Hdr2 := 'CNIL was fixed for the following tax returns';
   Hdr3 := FilledStr(80,'=')+FilledStr(14,'=');
   If PrintDialog1.Execute then
   begin
   If PrintAListing(AppDir+'\'+'TempFile',Hdr1,Hdr2,Hdr3) = True then
    ShowMessage('Printing Completed');
   end;
  end;
  TempList.Free;
  OKbtn.Enabled:=True; CancelBtn.Enabled:=True;
  Close;
end;

procedure TFixCnilT1_2026.IncreaseYear(Frm:String;Elm:Integer);
Var s:String;
begin
 s:= '1998'+midStr(FetchElm(RetNo,Frm,elm),5,6);
 StoreElm(retNo,Frm,elm,s);
end;

procedure TFixCnilT1_2026.FormCreate(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
DataDirBox.Text := OptRec.Dir_Cur;
LastYrDataDirBox.Text := OptRec.Dir_LastYr;
DrawList;
Screen.Cursor := crDefault;
end;

procedure TFixCnilT1_2026.FormPaint(Sender: TObject);
begin
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList;
 end;
end;

procedure TFixCnilT1_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TFixCnilT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TFixCnilT1_2026.DataDirBoxExit(Sender: TObject);
begin
 If DataDirBox.Text = OptRec.Dir_Cur then exit;
 //ReCalc.Invalidate; {DrawList;}
end;

end.
