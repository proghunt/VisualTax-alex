unit T2_2027merge;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,FileCtrl;

type
  TMergeT2_2027 = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    FileListBox1: TFileListBox;
    DataDirBox: TEdit;
    Image1: TImage;
    DestDataDirBox: TEdit;
    Label4: TLabel;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel3: TPanel;
    Label9: TLabel;
    Panel4: TPanel;
    Label5: TLabel;
    Label8: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MergeT2_2027: TMergeT2_2027;

implementation

{$R *.DFM}

uses T2_2027,T2_2027Declare,T2_2027TrimStr,T2_2027Common,T2_2027Common2,
  vtTrimStr,vtShared;

procedure TMergeT2_2027.OKBtnClick(Sender: TObject);
//20170811 Igor>>>
Var
  RetNo, I: integer;
  Err: String;
begin
 (*
   1. copy clients.d bf from application dir
   2. Get all returns from current data directory
   3. Read and save each return
  *)
  if not SysUtils.DirectoryExists(DataDirBox.Text) then //20150702
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;
  if not SysUtils.DirectoryExists(DestDataDirBox.Text) then //20150702
  begin
    ShowMessage('Data directory does not exist');
    DestDataDirBox.SetFocus;
    exit;
  end;

  if UpperCase(DataDirBox.Text) = UpperCase(DestDataDirBox.Text) then
  begin
    ShowMessage('Source and destination cannot be the same!');
    DestDataDirBox.SetFocus;
    exit;
  end;

  if not SysUtils.FileExists(DestDataDirBox.Text + '\' + ClientsDBLite) then //20150922 Igor
    if not CopyDB(ClientsDBLite, Appdir, DataDirBox.Text, Err) then
    begin
      ShowMessage(Err);
      exit;
    end;
  OKbtn.Enabled := False;
  CancelBtn.Enabled := False;
  Busy;
  for I := 0 to FileListBox1.Items.Count - 1 do
  begin
    FileListBox1.ItemIndex := I;
    FileListBox1.Refresh;
    if (UpperCase(FileListBox1.Items[I]) <> UpperCase(ClientsDBLite)) then //20150923 Igor
    begin
      RetNo := ReadReturn(DataDirBox.Text, FileListBox1.Items[I], True, False); //'Y','N') =0 then
      if RetNo > 0 then
      begin
        try
          Label7.Caption := '#' + IntToStr(I + 1);
          Label7.Refresh;
          CopyFile(IncludeTrailingPathDelimiter(DataDirBox.text) + FileListBox1.Items[I],
                   IncludeTrailingPathDelimiter(DestDataDirBox.Text) + FileListBox1.Items[I]);
          UpdateClientsTable(RetNo, DestDataDirBox.Text, FileListBox1.Items[I]);   {prpstatus,efstatus,notes}
        finally
          RemoveReturnFromMemory(RetNo);
        end;
      end;
    end;
  end;
  Done;
  ShowMessage('Merging completed');
  OKbtn.Enabled := True;
  CancelBtn.Enabled := True;
//20170811 Igor<<<
end;

procedure TMergeT2_2027.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMergeT2_2027.DataDirBoxExit(Sender: TObject);
begin
  If DataDirBox.Text = OptRec.Dir_Cur then exit;
  DrawList;
end;

procedure TMergeT2_2027.FormCreate(Sender: TObject);
begin
  FileListBox1.Mask:='*.db'; //20150923 Igor
  DataDirBox.Text := OptRec.Dir_Cur;
  DestDataDirBox.Text := OptRec.Dir_Cur;
  DrawList;
end;

procedure TMergeT2_2027.FormPaint(Sender: TObject);
begin
  If DataDirBox.Text <> OptRec.Dir_Cur then DrawList;
end;

procedure TMergeT2_2027.DrawList;
begin
  FileListBox1.Directory := DataDirBox.Text;
  FileListBox1.Mask := '*.*';
  FileListBox1.ItemIndex :=0;
  Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;


end.
