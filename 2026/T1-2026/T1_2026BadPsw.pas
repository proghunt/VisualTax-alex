unit T1_2026badpsw;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls;

type
  TBadPswT1_2026 = class(TForm)
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
    Panel4: TPanel;
    Memo1: TMemo;
    PrintBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BadPswT1_2026: TBadPswT1_2026;
  RetNo:Integer;
implementation

{$R *.DFM}

uses vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Calc,T1_2026Features,T1_2026Print,vtPrints,vtTrimStr,
  vtShared;

procedure TBadPswT1_2026.OKBtnClick(Sender: TObject);
var i,j:integer; PrpStatus,EFStatus,Notes :String;
  Psw:String;
  pwdArr: Variant; //20160415 Igor
begin
 If IsDataDirectoryGood(DataDirBox.Text) = False then exit;

 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;
 pwdArr := AppT1_2026.SQLLitePassword.PassRFArray; //20160415 Igor
 OKbtn.Enabled:=False; CancelBtn.Enabled:=False;
 Memo1.Lines.add('     TAX RETURNS THAT MAY HAVE BAD PASSWORDS     ');
 Memo1.Lines.add('-------------------------------------------------');
 for i:=0 to FileListBox1.Items.Count -1 do
  begin
     If Flist.Count>100 then InitFormsTable;
     FileListBox1.ItemIndex :=i;
     FileListBox1.Refresh;
  //   RetNo:=InitNewReturn;
     If (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite))            //20150909 Igor
     and(UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite)+'-JOURNAL') //20150909 Igor
     then
       try
         Begin
          Label7.Caption := '#'+IntToStr(i+1);
          Label7.Refresh;
          Psw:=GetReturnPsw(DatadirBox.Text,FileListBox1.Items[i],pwdArr); //20160415 Igor
          If Psw>'' then
          begin
           If ReturnPswHasEof(Psw)=True then
             Memo1.Lines.add(PaddR(LeftStr(GetClientNameFromDb(FileListBox1.Items[i]),30),30) + ' ' +DatadirBox.Text+'\'+FileListBox1.Items[i]);
          end;
         end
       except
         ShowMessage('Error in processing');
       end;
   //  If RetNo >0 then RemoveReturnFromMemory(RetNo);
   //  RetNo :=0; RetINmem :=0;
  end;
  ShowMessage('Finished');
  OKbtn.Enabled:=True;
  CancelBtn.Enabled:=True;
end;

procedure TBadPswT1_2026.FormCreate(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
DataDirBox.Text := OptRec.Dir_Cur;
DrawList;
Screen.Cursor := crDefault;
end;

procedure TBadPswT1_2026.FormPaint(Sender: TObject);
begin
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList;
 end;
end;

procedure TBadPswT1_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TBadPswT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TBadPswT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
//ReCalc.Invalidate; {DrawList;}
end;

procedure TBadPswT1_2026.PrintBtnClick(Sender: TObject);
Var FlNm:String;
begin
 FlNm:=AppDir+'\'+'Temp.txt';
 Memo1.Lines.SaveToFile(FlNm);
 PrintSomeFile(FlNm);
end;

end.
