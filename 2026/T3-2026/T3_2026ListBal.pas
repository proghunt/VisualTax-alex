Unit T3_2026ListBal;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, Buttons, ExtCtrls, StrUtils, Math;

type
  TListBalT3_2026 = class(TForm)
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
  ListBal: TListBalT3_2026;

implementation

{$R *.DFM}

uses
  vtCommon, T3_2026, T3_2026Declare, T3_2026TrimStr, T3_2026Common,
  T3_2026Common2, T3_2026Calc, vtTrimStr, vtShared,
  vtMulti;

procedure TListBalT3_2026.OKBtnClick(Sender: TObject);
var
  i: Integer;
  PrpStatus, EFStatus, Notes: string;
  ShowStar: string;  //20251227
  TmpList: TstringList;
  FileNm, Hdr1, Hdr2, Hdr3, s, s1: string;
  RetFlName: string;
  //CraBalancesList:Tstringlist;  //one time use
  T3FNo: Integer;
  EfmemoFNo: Integer;
  CRAExpTotIncome: Real; //20260109 Igor
  VTCalcTotIncome: Real; //20260109 Igor
  CRAExpNetIncome: Real; //20260109 Igor
  VTCalcNetIncome: Real; //20260109 Igor
  CRAExpTaxIncome: Real; //20260109 Igor
  VTCalcTaxIncome: Real; //20260109 Igor
  CRAExpBalance: Real; //20260109 Igor
  VTCalcBalance: Real; //20260109 Igor
begin
  if Not DirectoryExists(DataDirBox.Text) then
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;
  // CraBalancesList:=Tstringlist.Create; //20251230  one time use

  TmpList:= TStringList.Create;
  OKbtn.Enabled:= False;
  CancelBtn.Enabled:= False;
  try
    TmpList.Add(
          'Trust Name' + '|  ' + 'Trust Account' + '|  ' + 'Province' + '|  ' + 'CRA exp Tot Income' + '|  ' + 'VT calc Tot Income' + '|  ' +
          'CRA exp Net Income' + '|  ' + 'VT calc Tot Income' + '|  ' + 'CRA exp Tax Income' + '|  ' + 'VT calc Tax Income' + '|  ' +
          'CRA exp Balance' + '|  ' + 'VT calc Balance');

    for i:= 0 to pred(FileListBox1.Items.Count) do
    begin
      FileListBox1.ItemIndex:= i;
      FileListBox1.Refresh;

      if not UpperCase(FileListBox1.Items[i]).Equals(UpperCase(ClientsDBLite)) and not UpperCase(FileListBox1.Items[i]).Equals(UpperCase(ClientsDBLite) + '-JOURNAL') then
      try
        RetNo:= ReadReturn(DataDirBox.Text, FileListBox1.Items[i], False);
        //RetFlName:=LeftStr(FileListBox1.Items[i],12); //20251230 ONETIME use
        if (RetNo > 0) then
        begin
          Label7.Caption:= '#' + IntToStr(succ(i));
          Label7.Refresh;
          PrpStatus:= FetchElm(RetNo, 'STATUS', 4);

          if not Numeric(PrpStatus) then PrpStatus:= '00';
          EFStatus:= FetchElm(RetNo, 'STATUS', 15);

          if not Numeric(EFStatus) then EFStatus:= '00';
          Notes:= FetchElm(RetNo, 'STATUS', 14);

          CalcAll(RetNo);
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[11]:= 'Rcalc-' + LeftStr(User.UserName, 5); //20170112 Igor
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[12]:= DateToStr(Date);
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[13]:= TimeToStr(Time);

          T3FNo:= GetFormNo('T3');
          EfmemoFNo:= GetFormNo('EFMEMO');

          CRAExpTotIncome:= vl(FetchElmFNo(RetNo, EfmemoFNo, 65)); //20260109 Igor
          VTCalcTotIncome:= vl(FetchElmFNo(RetNo, T3FNo, 126)); //20260109 Igor
          CRAExpNetIncome:= vl(FetchElmFNo(RetNo, EfmemoFNo, 66)); //20260109 Igor
          VTCalcNetIncome:= vl(FetchElmFNo(RetNo, T3FNo, 256)); //20260109 Igor
          CRAExpTaxIncome:= vl(FetchElmFNo(RetNo, EfmemoFNo, 67)); //20260109 Igor
          VTCalcTaxIncome:= vl(FetchElmFNo(RetNo, T3FNo, 272)); //20260109 Igor
          CRAExpBalance:= vl(FetchElmFNo(RetNo, EfmemoFNo, 68)); //20260109 Igor
          VTCalcBalance:= vl(FetchElmFNo(RetNo, T3FNo, 326)); //20260109 Igor

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
          if {(FileExists(AppDir + '\' + 'CraBalances.txt')) and} ((ABS(ABS(CRAExpTotIncome) - ABS(VTCalcTotIncome)) > 1.50) or
             (ABS(ABS(CRAExpNetIncome) - ABS(VTCalcNetIncome)) > 1.50) or (ABS(ABS(CRAExpTaxIncome) - ABS(VTCalcTaxIncome)) > 1.50) or
             (ABS(ABS(CRAExpBalance) - ABS(VTCalcBalance)) > 1.50)) then ShowStar:= ' *' else ShowStar:= '';

          TmpList.Add(
            PaddR(FetchElmFNo(RetNo, T3FNo, 1), 20) + '|  ' +
            PaddR('T' + FetchElmFNo(RetNo, T3FNo, 2), 10) + '|  ' +
            PaddR(FetchElmFNo(RetNo, T3FNo, 9), 2) + '|  ' +
            PaddR(FormatFloat('##,###,###.00', VTCalcTotIncome), 12) + '| ' +
            PaddR(FormatFloat('##,###,###.00', CRAExpTotIncome), 12) + '| ' +
            PaddR(FormatFloat('##,###,###.00', VTCalcNetIncome), 12) + '| ' +
            PaddR(FormatFloat('##,###,###.00', CRAExpNetIncome), 12) + '| ' +
            PaddR(FormatFloat('##,###,###.00', VTCalcTaxIncome), 12) + '| ' +
            PaddR(FormatFloat('##,###,###.00', CRAExpTaxIncome), 12) + '| ' +
            PaddR(FormatFloat('##,###,###.00', VTCalcBalance), 12) + '| ' +
            PaddR(FormatFloat('##,###,###.00', CRAExpBalance), 12) + '| ' +
            ShowStar);

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

      if (RetNo > 0) then RemoveReturnFromMemory(RetNo);
      RetNo:= 0;
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
    Hdr1:= S;
    Hdr2:= '';
    Hdr3:= '';
    FileNm:= AppDir + '\' + 'TempFile';
    TmpList.SaveToFile(FileNm);
  finally
    TmpList.Free;
  end;
  // If PrintDialog1.Execute then
  // begin
  if PrintAListing(FileNm, Hdr1, Hdr2, Hdr3) = True then ShowMessage('Printing Completed. Saved to: ' + FileNm);
  // end;

  OKbtn.Enabled:= True;
  CancelBtn.Enabled:= True;
  Close;
end;

procedure TListBalT3_2026.FormCreate(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  DataDirBox.Text := OptRec.Dir_Cur;
  DrawList;
  Screen.Cursor := crDefault;
end;

procedure TListBalT3_2026.FormPaint(Sender: TObject);
begin
  If DataDirBox.Text <> OptRec.Dir_Cur then
  begin
    If not DirectoryExists(DataDirBox.Text) then
    begin
      ShowMessage('Invalid Directory');
      exit;
    end;
    DrawList;
  end;
end;

procedure TListBalT3_2026.DrawList;
begin
  FileListBox1.Directory := DataDirBox.Text;
  FileListBox1.Mask := '*.*';
  FileListBox1.ItemIndex :=0;
  Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TListBalT3_2026.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TListBalT3_2026.DataDirBoxExit(Sender: TObject);
begin
  If DataDirBox.Text = OptRec.Dir_Cur then exit;
  Invalidate; {DrawList;}
end;

end.
