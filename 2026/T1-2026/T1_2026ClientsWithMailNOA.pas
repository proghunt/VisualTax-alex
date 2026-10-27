unit T1_2026ClientsWithMailNOA;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls;

type
  TClientsWithMailNOAT1_2026 = class(TForm)
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
  ClientsWithMailNOA: TClientsWithMailNOAT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Calc,T1_2026T1Rtns,T1_2026T1Rtns2,vtTrimStr,vtShared,
  vtMulti; //20170112 Igor

procedure TClientsWithMailNOAT1_2026.OKBtnClick(Sender: TObject);
var i:integer; PrpStatus,EFStatus, Notes :String;PreparerName:String;
TmpList :TstringList;
T1FNo,StatusFNo:Integer;
FileNm,Hdr1,Hdr2,Hdr3,s:string;
begin
 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;
 StatusFNo:=GetFormNo('STATUS');
 T1FNo:=GetFormNo('T1');

 PreparerName:=OptRec.Prp_Name;
 PreparerName:=ReplaceChar(PreparerName,'.',' ');
 PreparerName:=ReplaceChar(PreparerName,'"',' ');
 PreparerName:=ReplaceChar(PreparerName,',',' ');

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
        if RetNo > 0 then
        begin
         Label7.Caption := '#'+IntToStr(i+1);
         Label7.Refresh;
       if FetchElm(RetNo,INFOFNo,183)>'' then    //NOA = by Mail  //20190505
         Begin
          TmpList.Add(
           PaddR(GetLastName(RetNo),15)+' '+ PaddR(GetFirstName(RetNo),10)+' '+    //last and first nm
           PaddR(FetchElmFNo(RetNo,StatusFNo,19),12)+' '+                                     //transmitted
           PaddR(FetchElmFNo(RetNo,InfoFNo,54)+' '+FetchElmFNo(RetNo,InfoFNo,55),13)+' '+     //phone
           PaddR(FetchElm(RetNo,'T183',21),13)+ '  Taxpayer: '+   //DCN
           PaddR(FormatFloat('####,###.##',Vl(FetchElmFNo(RetNo,T1FNo,429))),11)+' '+     //refund/due
           AllTrim(FetchElmFNo(RetNo,InfoFNo,64)));                                          //20190504 CRA Email
         End;
        end;
     //except see below
     //end;
     If RetNo > 0 then RemoveReturnFromMemory(RetNo);
     RetNo:=0; //RetInMem :=0;
     except
      If RetNo>0 then ShowMessage('some error in '+GetLastName(RetNo));
     end;
  end;

  s:= InputBox('', 'Enter report title (up to 50 characters)', 'DCN of taxpayers requested NOA delivery by MAIL');
  Hdr1 := S; Hdr2 := ''; Hdr3 := '';
  FileNm :=AppDir+'\'+'ClientsWithMailNOA'+' By '+AllTrim(LeftStr(PreparerName,20))+'.txt';
  TmpList.Sorted:=True;
  TmpList.SaveToFile(FileNm);
  ShowMessage('The file created is in '+FileNm);
  TmpList.Free;
  If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
  ShowMessage('Printing Completed');

  OKbtn.Enabled:=True; CancelBtn.Enabled:=True;
  Close;
end;

procedure TClientsWithMailNOAT1_2026.FormCreate(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
DataDirBox.Text := OptRec.Dir_Cur;
DrawList;
Screen.Cursor := crDefault;
end;

procedure TClientsWithMailNOAT1_2026.FormPaint(Sender: TObject);
begin
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList;
 end;
end;

procedure TClientsWithMailNOAT1_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TClientsWithMailNOAT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TClientsWithMailNOAT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
Invalidate; {DrawList;}
end;

end.
