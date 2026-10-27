unit T1_2026Recalc;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls;

type
  TRecalcT1_2026 = class(TForm)
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
    Label10: TLabel;
    Panel4: TPanel;
    BackUpBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure IncreaseYear(Frm:String;Elm:Integer);
    procedure BackUpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  Recalc: TRecalcT1_2026;

implementation

uses vtMulti,vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Calc,T1_2026Features,T1_2026main,vtTrimStr,vtShared;

{$R *.DFM}

procedure TRecalcT1_2026.OKBtnClick(Sender: TObject);
var i,j:integer; PrpStatus,EFStatus, Notes :String;
begin
 If IsDataDirectoryGood(DataDirBox.Text) = False then exit;

 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;

 OKbtn.Enabled:=False; CancelBtn.Enabled:=False;
 for i:=0 to FileListBox1.Items.Count -1 do
  begin
   Try
     If Flist.Count>50 then InitFormsTable;  //100  //20190124
     FileListBox1.ItemIndex :=i;
     FileListBox1.Refresh;
     If (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite))              //20150909 Igor
     and(UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite) + '-JOURNAL') //20150909 Igor
     then
     try
        RetNo:=ReadReturn(DataDirBox.Text,FileListBox1.Items[i]);
        if RetNo > 0 then
        begin
         // ShowMessage(FileListBox1.Items[i]);
          Label7.Caption := '#'+IntToStr(i+1);
          Label7.Refresh;
          // CalcAll(RetNo);    //20161201  not be needed . Read does it all
          //Calc(RetNo,'INFO');
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[11]:=User.UserName; //20170112 Igor
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[12]:=FormatDateTime('yyyy-mm-dd',Now);
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[13]:=TimeToStr(Time);

          (* Fred's Efiler no  //20171209
          if UpperCase(LeftStr(FetchElm(RetNo,'T183',21),5))='C1219' then
          Begin
           StoreElm(RetNo, getFormNo('T183'),21,'B0864'+RightStr(FetchElm(RetNo,'T183',21),8));
          end;
          *)
          If not SaveReturn(RetNo,DataDirBox.Text,FileListBox1.Items[i],True,False) =0
           then ShowMessage('Return cannot be saved');
         end;
     except
     end;
     If RetNo >0 then RemoveReturnFromMemory(RetNo);
     RetNo :=0; //RetINmem :=0;
   Except
      ShowMessage(FileListBox1.Items[i]);
   end;
  end; //i
  ShowMessage('Re-calculation completed');
  OKbtn.Enabled:=True; CancelBtn.Enabled:=True;
  InitFormsTable;
  Close;
end;


procedure TRecalcT1_2026.IncreaseYear(Frm:String;Elm:Integer);
Var s:String;
begin
 s:= '1998'+midStr(FetchElm(RetNo,Frm,elm),5,6);
 StoreElm(retNo,Frm,elm,s);
end;

procedure TRecalcT1_2026.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
  Screen.Cursor := crHourGlass;
  DataDirBox.Text := OptRec.Dir_Cur;
  DrawList;
  Screen.Cursor := crDefault;
end;

procedure TRecalcT1_2026.FormPaint(Sender: TObject);
begin
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList;
 end;
end;

procedure TRecalcT1_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TRecalcT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TRecalcT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
ReCalc.Invalidate; {DrawList;}
end;

procedure TRecalcT1_2026.BackUpBtnClick(Sender: TObject);
begin
 MainFormT1.Backupthetaxdata1Click(Sender);
end;

end.
