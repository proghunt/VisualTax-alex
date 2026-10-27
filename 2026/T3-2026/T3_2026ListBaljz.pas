unit T3_2026ListBaljz;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls, Vcl.ComCtrls, Vcl.ExtDlgs,
  StrUtils, Math; //20251219 Igor

type
  TListBalT3jz_2025 = class(TForm)
    PrintDialog1: TPrintDialog;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    FileListBox1: TFileListBox;
    DataDirBox: TEdit;
    CPPLinesCheckBox: TCheckBox;
    netIncomeCheckBox: TCheckBox;
    HeaderCheckBox: TCheckBox;
    OKBtn: TBitBtn;
    Panel1: TPanel;
    Label4: TLabel;
    Label8: TLabel;
    xmlDataDirEditBox: TEdit;
    Label9: TLabel;
    exrtractfromCraXMLBTN: TBitBtn;
    CancelBtn: TBitBtn;
    FileListBox2: TFileListBox;
    CRABalCheckBox: TCheckBox;
    craCPPLinesCheckBox: TCheckBox;
    Label10: TLabel;
    browseDataDirButton: TButton;
    xmlDataDirButton: TButton;
    ln15000checkbox: TCheckBox;
    Label11: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList1;
    procedure DrawList2;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure exrtractfromCraXMLBTNClick(Sender: TObject);
    procedure browseDataDirButtonClick(Sender: TObject);
    procedure xmlDataDirButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  ListBal: TListBalT3jz_2025;

implementation

{$R *.DFM}

uses
  vtCommon,
  T3_2026, T3_2026Declare,T3_2026TrimStr,T3_2026Common,
  T3_2026Common2,T3_2026Calc,
  //T1_2026T1Rtns,T1_2026T1Rtns2,
  vtTrimStr,vtShared, vtMulti; //20170112 Igor

procedure TListBalT3jz_2025.OKBtnClick(Sender: TObject);
var i:integer; PrpStatus,EFStatus, Notes:String;
TmpList :TstringList;
FileNm,Hdr1,Hdr2,Hdr3,s:string;
saveDialog : TSaveDialog;
  lCraBal: Real; //20251219 Igor
  lRtnBal: Real; //20251219 Igor
begin
 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;
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

        //ignore other file types that may be present
        if  (pos('.pdf',  FileListBox1.Items[i]) > 0) or
            (pos('.db',   FileListBox1.Items[i]) > 0) or
            (pos('.xlsx', FileListBox1.Items[i]) > 0)
        then continue;

        RetNo:=ReadReturn(DataDirBox.Text,FileListBox1.Items[i],true);
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

          if (HeaderCheckBox.checked) and (i = 0) then
          begin
            s :=  PaddR('FileName'  ,25)  + '| '+  //FILE NAME
                  PaddR('Account'   ,12)  + '| '+
                  PaddR('FirstName' ,10)  + '| '+
                  PaddR('Prov'      ,13)  + '| ';
                  //PaddR('LastName'  ,20)  + '| '+
                  //PaddR('DOB'       ,12)  + '| ';

            if netIncomeCheckBox.Checked then
              s :=  s + PaddR('Net Income',12)  + '| ';


{
            if CPPLinesCheckBox.Checked then
            begin
              s :=  s + PaddR('LNN[31000]' ,12) + '| '+
                        PaddR('LNN[22200]' ,12) + '| '+
                        PaddR('LNN[30800]' ,12) + '| '+
                        PaddR('LNN[22215]' ,12) + '| '+
                        PaddR('LNN[44800]' ,12) + '| ';
            end;
}
            s :=  s + 'Balance';

            TmpList.Add(s);
          end; //end header

         s:='';
         s := PaddR(FileListBox1.Items[i]     ,25)   + '| '+  //FILE NAME
              PaddR(GetT3AccountNumber(RetNo) ,12)   + '| '+  //ACCOUNT NUMBER
              PaddR(GetFirstName(RetNo)       ,10)   + '| '+  //FIRST NAME
              PaddR(FetchElm(RetNo,'T3',9)    ,13)   + '| ';  //PROV
              //PaddR(GetLastName(RetNo)        ,20)   + '| '+  //LAST NAME
              //PaddR(FetchElm(RetNo,'T1',9)    ,12)   + '| ';  //DOB

         if netIncomeCheckBox.Checked then
            s := s + PaddR( FormatFloat('##,###,###.00',vl(FetchElm(RetNo,'T3',256))) ,12) + '| '; //jz 20250131

{
          //jz 20250204
          if CPPLinesCheckBox.Checked then
          begin
            s :=  s + PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[31000]) ,12) + '| '+
                      PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[22200]) ,12) + '| '+
                      PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[30800]) ,12) + '| '+
                      PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[22215]) ,12) + '| '+
                      PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[44800]) ,12) + '| ';
          end;
}
         //lCraBal:= vl(FetchElm(RetNo, 'INFO', 300));
         //lRtnBal:= Ret[RetNo].Balance;

         s := s + FormatFloat('##,###,###.00', vl(FetchElm(RetNo, 'T3', 324)));  //Ret[RetNo].Balance);
         //s:= s + IfThen(lCraBal <> 0, IfThen(((lRtnBal > lCraBal + 1.50) or (lRtnBal < lCraBal - 1.50)), '| ' + FormatFloat('##,###,###.00', lCraBal) + '*', '| ' + FormatFloat('##,###,###.00', lCraBal)), '| 0*'); //20251219 Igor

         TmpList.Add(s); //jz 20250204

        end;
     except
     end;
     If RetNo > 0 then RemoveReturnFromMemory(RetNo);
     RetNo:=0; //RetInMem :=0;
  end;

  //s:= InputBox('', 'Enter report title (up to 50 characters)', 'Balances');
  //Hdr1 := S; Hdr2 := ''; Hdr3 := '';

  saveDialog              := TSaveDialog.Create(self);
  saveDialog.Title        := 'Save file';
  saveDialog.InitialDir   := AppDir; //AppDir+'\'+'BalancesTempFile';
  saveDialog.FileName     := 'BalancesTempFile';
  saveDialog.Filter       := 'Text file|*.txt';
  saveDialog.DefaultExt   := 'txt';
  // Select text files as the starting filter type ??
  saveDialog.FilterIndex  := 1;

  if saveDialog.Execute then
  begin
    //ShowMessage('File : '+saveDialog.FileName);
    FileNm := saveDialog.FileName;
    TmpList.SaveToFile(FileNm);
  end
  else
    ShowMessage('Save file cancelled');

  saveDialog.Free;
  TmpList.Free;

  {
  // If PrintDialog1.Execute then
  // begin
  If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
  ShowMessage('Printing Completed');
  // end;
  }

  OKbtn.Enabled:=True; CancelBtn.Enabled:=True;

  Close;
end;



procedure TListBalT3jz_2025.FormCreate(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  DataDirBox.Text := OptRec.Dir_Cur;
  if not DirectoryExists(DataDirBox.Text) then
    DataDirBox.Text := ''
  else
    DrawList1;

  //xmlDataDirEditBox.text := 'C:\Users\XPSWINDOWSPRO\Documents\VTdocs\CRASpecs\T1-2025\T1-2025-TESTCASES-ALL-REBUILT';
  if not DirectoryExists(xmlDataDirEditBox.text) then
    xmlDataDirEditBox.text := ''
  else
    DrawList2;

  Screen.Cursor := crDefault;

end;

procedure TListBalT3jz_2025.FormPaint(Sender: TObject);
begin
 {
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList1;

 end;
 }
end;

procedure TListBalT3jz_2025.DrawList1;
begin
  FileListBox1.Directory := DataDirBox.Text;
  FileListBox1.Mask := '*.*';
  FileListBox1.ItemIndex :=0;
  Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TListBalT3jz_2025.DrawList2;
begin
  FileListBox2.Directory := xmlDataDirEditBox.Text;
  FileListBox2.Mask := '*.*';
  FileListBox2.ItemIndex :=0;
  //Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;






procedure TListBalT3jz_2025.exrtractfromCraXMLBTNClick(Sender: TObject);
  type
     TT3LineInfoRec = record
       T3LineNumber : string[10];
       T3LineAmount : string[20];
     end;

  var
    i,j,k:integer;
    fileExt,FileNm,s,tempString:String;
    TmpList,xmldatafileList :TstringList;

    //lineNumbers : array[1..5] of TCPPRelatedRec;

    T3LineInfo    : array[0..1] of TT3LineInfoRec;

    //ln15000 : TCPPRelatedRec;

    saveDialog : TSaveDialog;
begin

{
  if not(ln15000CheckBox.checked) and not(CRABalCheckBox.checked) and not(craCPPLinesCheckBox.checked) then
  begin
    showmessage('Select what to extract');
    exit;
  end;
}

  T3LineInfo[0].T3LineNumber := '50';
  T3LineInfo[1].T3LineNumber := '94';

  If Not DirectoryExists(xmlDataDirEditBox.Text) then
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;

  FileListBox2.Directory := xmlDataDirEditBox.Text;
  //FileListBox2.Directory := 'C:\MyProject\Files\';

  // Set the file mask to show only wanted file type
  fileExt:='json';
  FileListBox2.Mask := '*.'+fileExt;


  TmpList          := TStringList.Create;
  xmldatafileList  := TStringList.Create;

  OKbtn.Enabled:=False; CancelBtn.Enabled:=False;

  for i:=0 to FileListBox2.Items.Count -1 do
  begin
     FileListBox2.ItemIndex :=i;
     FileListBox2.Refresh;

     If (pos('.'+fileExt, FileListBox2.Items[i]) > 0) and (pos('T3_RET', FileListBox2.Items[i]) > 0) then
     begin

       Try
          if  (pos('.pdf',  FileListBox2.Items[i]) > 0) or
              (pos('.db',   FileListBox2.Items[i]) > 0) or
              (pos('.xlsx', FileListBox2.Items[i]) > 0)
          then continue;

          xmldatafileList.LoadFromFile(xmlDataDirEditBox.Text + '\' + FileListBox2.Items[i]);

          T3LineInfo[0].T3LineAmount := '';
          T3LineInfo[1].T3LineAmount := '';

          //get balances
          //if CRABalCheckBox.checked then
          begin
            s := '';

            for j:=0 to xmldatafileList.Count -1 do
            begin

              for k := 0 to Length(T3LineInfo)-1 do
              begin

                tempString := '';
                if pos('"fieldCode":"'+ T3LineInfo[k].T3LineNumber +'"', xmldatafileList.Strings[j]) > 0 then
                begin
                  tempString := xmldatafileList.Strings[j+1];
                  tempString := StringReplace(tempString, '"fieldValue":' , '' , [rfReplaceAll, rfIgnoreCase]);
                  //tempString := StringReplace(tempString, '</comm:FieldValue>', '' , [rfReplaceAll, rfIgnoreCase]);
                  tempString := trim(tempString);
                  //insert('.',tempString,length(tempString)-1); //to take into account decimal
                  //balance[k].CPPRelatedLineamount := tempString;
                  T3LineInfo[k].T3LineAmount := tempString;
                end;
              end;

            end; //end for j
            //if tempString = '' then tempString := '0.00'; never is a blank
            //if s = '' then s := paddr('0.00',10);

            s := '';
            s := paddr(T3LineInfo[0].T3LineAmount,10) + '|' + paddr(T3LineInfo[1].T3LineAmount,10) + '|';

            TmpList.Add(s + paddR(FileListBox2.Items[i],45));

          end; //end if CRABalCheckBox.checked

       except
       //
       end;


     end;

  end; //end FileListBox2.Items.Count

  saveDialog              := TSaveDialog.Create(self);
  saveDialog.Title        := 'Save file';
  saveDialog.InitialDir   := AppDir; //AppDir+'\'+'CraXMLLinesTempFile';
  saveDialog.FileName     := 'CraXMLLinesTempFile';
  saveDialog.Filter       := 'Text file|*.txt';
  saveDialog.DefaultExt   := 'txt';
  // Select text files as the starting filter type ??
  saveDialog.FilterIndex  := 1;

  if saveDialog.Execute then
  begin
    //ShowMessage('File : '+saveDialog.FileName);
    FileNm := saveDialog.FileName;
    TmpList.SaveToFile(FileNm);
  end
  else
    ShowMessage('Save file cancelled');

  saveDialog.Free;
  TmpList.Free;
  xmldatafileList.Free;

  //Close;
end;


procedure TListBalT3jz_2025.browseDataDirButtonClick(Sender: TObject);
var dir:string;
begin

  if SelectDirectory('Select document folder', 'C:\VT\T3-2025\', Dir) then
  begin
    DataDirBox.Text := Dir;
    DrawList1;
  end;

end;

procedure TListBalT3jz_2025.xmlDataDirButtonClick(Sender: TObject);
var dir:string;
begin

  if SelectDirectory('Select document folder', 'C:\Users\XPSWINDOWSPRO\Documents\VTdocs\CRASpecs\', Dir) then
  begin
    xmlDataDirEditBox.Text:=dir;
    DrawList2;
  end;
end;


procedure TListBalT3jz_2025.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TListBalT3jz_2025.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
Invalidate; {DrawList;}

end;

end.
