unit T1_2026ListBal;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls, Vcl.ComCtrls;

type
  TListBalT1_2026 = class(TForm)
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
    line15000CheckBox: TCheckBox;
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
    xmlDataSaveEditBox: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    vtDataSaveEditBox: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure exrtractfromCraXMLBTNClick(Sender: TObject);
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
var i:integer; PrpStatus,EFStatus, Notes:String;
TmpList :TstringList;
FileNm,Hdr1,Hdr2,Hdr3,s:string;
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
        if (pos('.pdf', FileListBox1.Items[i]) > 0) or (pos('.db', FileListBox1.Items[i]) > 0) then
          continue;

        RetNo:=ReadReturn(DataDirBox.Text,FileListBox1.Items[i]);
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
            s :=  PaddR('LastName',20)    + '| '+
                  PaddR('FirstName',10)   + '| '+
                  PaddR('Prov',13)        + '| '+
                  PaddR('SinNo',12)       + '| '+
                  PaddR('DOB',12)         + '| ';

            if line15000CheckBox.Checked then
              s :=  s + PaddR('LNN[15000]',12)  + '| ';

            if CPPLinesCheckBox.Checked then
            begin
              s :=  s + PaddR('LNN[31000]' ,12) + '| '+
                        PaddR('LNN[22200]' ,12) + '| '+
                        PaddR('LNN[30800]' ,12) + '| '+
                        PaddR('LNN[22215]' ,12) + '| '+
                        PaddR('LNN[44800]' ,12) + '| ';
            end;

            s :=  s + 'Balance';

            TmpList.Add(s);
          end; //end header

         s:='';
         s := PaddR(GetLastName(RetNo),20)       + '| '+  //LAST NAME
              PaddR(GetFirstName(RetNo),10)      + '| '+  //FIRST NAME
              PaddR(FetchElm(RetNo,'T1',1),13)   + '| '+  //PROV
              PaddR(GetSinNo(RetNo),12)          + '| '+  //SIN
              PaddR(FetchElm(RetNo,'T1',9),12)   + '| ';  //DOB

         if line15000CheckBox.Checked then
            s := s + PaddR( FormatFloat('##,###,###.00',vl(FetchElm(RetNo,'T1',236))) ,12) + '| '; //jz 20250131

          //jz 20250204
          if CPPLinesCheckBox.Checked then
          begin
            s :=  s + PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[31000]) ,12) + '| '+
                      PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[22200]) ,12) + '| '+
                      PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[30800]) ,12) + '| '+
                      PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[22215]) ,12) + '| '+
                      PaddR( FormatFloat('##,###,###.00',Ret[RetNo].LNN[44800]) ,12) + '| ';
          end;

         s :=  s + FormatFloat('##,###,###.00',Ret[RetNo].Balance);

         TmpList.Add(s); //jz 20250204

        end;
     except
     end;
     If RetNo > 0 then RemoveReturnFromMemory(RetNo);
     RetNo:=0; //RetInMem :=0;
  end;
  s:= InputBox('', 'Enter report title (up to 50 characters)', 'Balances');
  Hdr1 := S; Hdr2 := ''; Hdr3 := '';
  FileNm :=AppDir+'\'+'BalancesTempFile';
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

FileListBox2.Directory := xmlDataDirEditBox.Text;
FileListBox2.Mask := '*.*';
FileListBox2.ItemIndex :=0;
//Label3.Caption := IntToStr(FileListBox1.Items.Count-2);

end;






procedure TListBalT1_2026.exrtractfromCraXMLBTNClick(Sender: TObject);
 type
   TCPPRelatedRec = record
     CPPRelatedLineNumber : string[10];
     CPPRelatedLineamount : string[20];
   end;

var
i,j,k:integer; FileNm,s,tempString:String;
TmpList,xmldatafileList :TstringList;

lineNumbers : array[1..5] of TCPPRelatedRec;

begin

  lineNumbers[1].CPPRelatedLineNumber := '31000';
  lineNumbers[2].CPPRelatedLineNumber := '22200';
  lineNumbers[3].CPPRelatedLineNumber := '30800';
  lineNumbers[4].CPPRelatedLineNumber := '22215';
  lineNumbers[5].CPPRelatedLineNumber := '44800';

  If Not DirectoryExists(xmlDataDirEditBox.Text) then
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;

  FileListBox2.Directory := xmlDataDirEditBox.Text;

  TmpList          := TStringList.Create;
  xmldatafileList  := TStringList.Create;

  OKbtn.Enabled:=False; CancelBtn.Enabled:=False;

  for i:=0 to FileListBox2.Items.Count -1 do
  begin
     FileListBox2.ItemIndex :=i;
     FileListBox2.Refresh;

     If (pos('.xml', FileListBox2.Items[i]) > 0) and (pos('EFILE', FileListBox2.Items[i]) > 0) then
     begin

       Try
          if (pos('.pdf', FileListBox2.Items[i]) > 0) or (pos('.db', FileListBox2.Items[i]) > 0) then continue;
          xmldatafileList.LoadFromFile(xmlDataDirEditBox.Text + '\' + FileListBox2.Items[i]);

          s := '';
          for k := 1 to length(lineNumbers) do
          begin

            lineNumbers[k].CPPRelatedLineamount := '';

            for j:=0 to xmldatafileList.Count -1 do
            begin
                tempString := '';
                if pos('>'+ lineNumbers[k].CPPRelatedLineNumber +'<', xmldatafileList.Strings[j]) > 0 then
                begin
                  tempString := xmldatafileList.Strings[j+1];
                  tempString := StringReplace(tempString, '<comm:FieldValue>' , '' , [rfReplaceAll, rfIgnoreCase]);
                  tempString := StringReplace(tempString, '</comm:FieldValue>', '' , [rfReplaceAll, rfIgnoreCase]);
                  tempString := trim(tempString);
                  insert('.',tempString,length(tempString)-1);
                  lineNumbers[k].CPPRelatedLineamount := tempString;
                end;
            end;
            //if tempString = '' then tempString := '0.00'; never is a blank
            //if s = '' then s := paddr('0.00',10);
          end;

          s := '';
          for k := 1 to length(lineNumbers) do
          begin
            if lineNumbers[k].CPPRelatedLineamount = '' then lineNumbers[k].CPPRelatedLineamount := '0.00';
            s := s + '|' + paddr(lineNumbers[k].CPPRelatedLineamount,10);
          end;
          TmpList.Add(paddR(FileListBox2.Items[i],35) + s);

       except
       //
       end;


     end;

  end; //end FileListBox2.Items.Count

  FileNm :=AppDir+'\'+'CraXMLLinesTempFile';
  TmpList.SaveToFile(FileNm);
  TmpList.Free;
  xmldatafileList.Free;

  ShowMessage('file saved');

  //Close;


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
