Unit T1_2026ListBal;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls, StrUtils, Math; //20251219 Igor

type
  TListBalT1_2026 = class(TForm)
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    DataDirBox: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    PrintDialog1: TPrintDialog;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  ListBal: TListBalT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Calc,T1_2026T1Rtns,T1_2026T1Rtns2,vtTrimStr,vtShared,
  vtMulti; //20170112 Igor

procedure TListBalT1_2026.OKBtnClick(Sender: TObject);
var i:integer; PrpStatus,EFStatus, Notes :String;
 ShowStar:String;  //20251227
 TmpList :TstringList;
 FileNm,Hdr1,Hdr2,Hdr3,s,s1:string;
 RetFlName:String;
 lCraBal: Real; //20251219 Igor
 lRtnBal: Real; //20251219 Igor
 //CraBalancesList:Tstringlist;  //one time use
begin
 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;
// CraBalancesList:=Tstringlist.Create; //20251230  one time use
 TmpList := TStringList.Create;
 OKbtn.Enabled:=False; CancelBtn.Enabled:=False;
 for i:=0 to FileListBox1.Items.Count -1 do
  begin
     FileListBox1.ItemIndex :=i;
     FileListBox1.Refresh;
     If (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite))              //20150909 Igor
     and(UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite) + '-JOURNAL') //20150909 Igor
     then
     Try
        RetNo:=ReadReturn(DataDirBox.Text,FileListBox1.Items[i]);
        //RetFlName:=LeftStr(FileListBox1.Items[i],12); //20251230 ONETIME use
        if RetNo > 0 then
        begin
         Label7.Caption := '#'+IntToStr(i+1);
         Label7.Refresh;
         PrpStatus := FetchElm(RetNo,'STATUS',4);
         If Not Numeric(PrpStatus) then PrpStatus :='00';
         EFStatus  := FetchElm(RetNo,'STATUS',15);
         If Not Numeric(EFStatus) then EFStatus :='00';
         Notes     := FetchElm(RetNo,'STATUS',14);
         CalcAll(RetNo);
         Ret[retNo].Frm[GetFormNo('STATUS')].Strings[11]:='Rcalc-'+LeftStr(User.UserName,5); //20170112 Igor
         Ret[retNo].Frm[GetFormNo('STATUS')].Strings[12]:=DateToStr(Date);
         Ret[retNo].Frm[GetFormNo('STATUS')].Strings[13]:=TimeToStr(Time);
         lCraBal:= vl(FetchElm(RetNo, 'INFO', 300)); //20251219 Igor
         lRtnBal:= Ret[RetNo].Balance; //20251219 Igor
         //--------------------------------------------------------
         //20251230   THIS is A ONE TOME routine to create the CRABANACES.TX from the Certif25-All that had the balances
         {
         CraBalancesList.Add(PaddR(retflName,15)
                            +PaddR(FormatFloat('########.00',lCraBal),12)
                            +PaddR(GetFirstName(RetNo),10)
                            +PaddR(GetLastName(RetNo),15)
                            +CHR(13)); //+Chr(10)); //20251231

         //20251230CZ
         }
         if (FileExists(AppDir+'\'+'CraBalances.txt'))
         and (ABS(ABS(LrtnBal) - ABS(LCraBal)) >1.50) then ShowStar:=' *' else ShowStar:='';

         TmpList.Add(
         PaddR(GetLastName(RetNo),15)+ '|  '+  //PaddR(GetLastName(RetNo),20)+ '| '+
         PaddR(GetFirstName(RetNo),10)+ '| '+
         PaddR(FetchElm(RetNo,'T1',1),13)+ '| '+
         PaddR(GetSinNo(RetNo),12)+ '| '+
         PaddR(FetchElm(RetNo,'T1',9),12)+ '| '+
         PaddR(FormatFloat('##,###,###.00',vl(FetchElm(RetNo,'T1',236))) ,12) + '| '+
         PaddR(FormatFloat('##,###,###.00',Lrtnbal),12) + '| ' +
         PaddR(FormatFloat('##,###,###.00',lCraBal),12) + '| '
         +Showstar);

         {
         //20251225CZ space before * CZ
         FormatFloat('##,###,###.00',Ret[RetNo].Balance)
         + IfThen(lCraBal <> 0, IfThen(((lRtnBal > lCraBal + 1.50) or (lRtnBal < lCraBal - 1.50)), '| '
          + FormatFloat('##,###,###.00', lCraBal) + ' *', '| ' + FormatFloat('##,###,###.00', lCraBal)),  '| 0 *') //20251219 Igor
         );
         }
        end;
     except
     end;
     If RetNo > 0 then RemoveReturnFromMemory(RetNo);
     RetNo:=0; //RetInMem :=0;

    // CraBalancesList.SaveToFile(AppDir+'\CraBalances.txt'); //20251230 One time use
  end;
  //-------------------------------------

  (*
  //20251231 Temp
  ShowMessage('*** Testing the CraBalancesList after creating the CraBalances.txt');
  InfoFNo:=GetFormNo('INFO');
  CraBalancesList.clear;;//CraBalancesList:=TStringList.Create;
  //Result:='';
  CraBalancesList.loadfromFile(AppDir+'\'+'CraBalances.txt');
  for I := 0 to CraBalancesList.Count - 1 do
  begin
   FileNm:=LeftStr(FileListBox1.Items[i],12); //*********important
   s:=AllTrim(CraBalancesList[i]);
   if UpperCase(FileNm)= Uppercase(LeftStr(s,12)) then
   begin
    S1:=MidStr(S,16,12); //cra balance amount as string
    CraBalancesList.free;
    Exit;
   end;
  end;
 *)
//===========================
  s:= InputBox('', 'Enter report title (up to 50 characters)', 'Balances');
  Hdr1 := S; Hdr2 := ''; Hdr3 := '';
  FileNm :=AppDir+'\'+'TempFile';
  TmpList.SaveToFile(FileNm);
  TmpList.Free;
 // If PrintDialog1.Execute then
 // begin
  If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
  ShowMessage('Printing Completed');
 // end;
  OKbtn.Enabled:=True; CancelBtn.Enabled:=True;
  Close;
end;

procedure TListBalT1_2026.FormCreate(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
DataDirBox.Text := OptRec.Dir_Cur;
DrawList;
Screen.Cursor := crDefault;
end;

procedure TListBalT1_2026.FormPaint(Sender: TObject);
begin
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList;
 end;
end;

procedure TListBalT1_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TListBalT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TListBalT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
Invalidate; {DrawList;}
end;

end.
