unit T1_2026Signature;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls;

type
  TSignatureT1_2026 = class(TForm)
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    Panel4: TPanel;
    PrintBtn: TBitBtn;
    Panel3: TPanel;
    DataDirBox: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    e_SignatureHolder: TImage;
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
  SignatureT1_2026: TSignatureT1_2026;
  RetNo:Integer;
implementation

{$R *.DFM}

uses vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Calc,T1_2026Features,T1_2026Print,vtPrints,vtTrimStr,
  vtShared;

procedure TSignatureT1_2026.OKBtnClick(Sender: TObject);
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
 OKbtn.Enabled:=True;
 CancelBtn.Enabled:=True;
end;

procedure TSignatureT1_2026.FormCreate(Sender: TObject);
Var RetNo:Integer;
begin
{
//RetNo := GetCurrentRetNo;
Screen.Cursor := crHourGlass;
DataDirBox.Text := optRec.Dir_PermanentDocs + '\' + GetLastName(retNo) + ','+ GetFirstName(retNo);
GetSignatureFilePath(RetNo):String;//20200320
DrawList;
Screen.Cursor := crDefault;
}
end;

procedure TSignatureT1_2026.FormPaint(Sender: TObject);
begin
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList;
 end;
end;

procedure TSignatureT1_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
//Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TSignatureT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TSignatureT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
//ReCalc.Invalidate; {DrawList;}
end;

procedure TSignatureT1_2026.PrintBtnClick(Sender: TObject);
Var FlNm:String;
begin

end;

end.
