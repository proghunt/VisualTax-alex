unit FP_2027FsOutFiles;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,ShellApi,FileCtrl;

type
  TFsOutFiles = class(TForm)
    Panel1: TPanel;
    TransmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FileListBox1: TFileListBox;
    Panel3: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    TempMemo: TMemo;
    procedure FormCreate(Sender: TObject);
    Procedure GetFileNames;
    procedure CancelBtnClick(Sender: TObject);
    procedure TransmitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FileListBox1Click(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FsOutFiles: TFsOutFiles;
  FsOutDir :String;

implementation

{$R *.DFM}

uses FP_2027Declare,FP_2027Trimstr,vtTrimStr,vtShared;

procedure TFsOutFiles.FormCreate(Sender: TObject);
begin
 FsOutDir := HoRec.FsOutDir;
 GetFileNames;
end;

Procedure TFSOutFiles.GetFileNames;
begin
  FileListBox1.Directory := FsOutDir;
  FileListBox1.Mask := '*.*';
  FileListBox1.ItemIndex :=0;
  If FileListBox1.Items.Count>0 then FileListBox1Click(Application);
end;


procedure TFsOutFiles.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TFsOutFiles.TransmitBtnClick(Sender: TObject);
Var h:THandle;
begin
h :=ShellExecute(FsOutFiles.Handle, Nil, 'WebSites.exe', Nil,
  Nil, SW_RESTORE);
  if h <=32 then
   ShowMessage('Cannot execute. Error '+IntToStr(h));
{ConnectToFundServ(Self.handle);}
end;

procedure TFsOutFiles.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

procedure TFsOutFiles.FileListBox1Click(Sender: TObject);
Var i:Integer;s:String;
begin
 Memo1.lines.Clear;
 TempMemo.Lines.Clear;
 TempMemo.Lines.LoadFromFile(FsOutDir+'\'+FileListBox1.Items[FileListBox1.ItemIndex]);
 s:='         1         2         3         4         5         6         7         8         9        ';
 Memo1.Lines.Add(s+'10'+s+'20'+s+'30'+s+'40'+s+'50'+s+'60'+s+'70'+s+'80'+s+'90'); {+LeftStr(s,97)+'100'+LeftStr(s,97)+'110');}
 s:='123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
 Memo1.Lines.Add(s+s+s+s+s+s+s+s); {+s+s+s);}
 For i:=0 to TempMemo.Lines.Count-1 do Memo1.Lines.Add(TempMemo.Lines[i]);
 {Memo1.Lines.LoadFromFile(FsOutDir+'\'+FileListBox1.Items[FileListBox1.ItemIndex]);}
 {ListBox1.Items.LoadFromFile(FsOutDir+'\'+FileListBox1.Items[FileListBox1.ItemIndex]);}
end;

procedure TFsOutFiles.Memo1Click(Sender: TObject);
Var Ln:Integer;
begin
  {
  Ln := Memo1.Perform(EM_LINEFROMCHAR,-1,0);
  ShowMessage('Line '+IntToStr(Ln+1));
  }
end;

end.
