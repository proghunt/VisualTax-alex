unit FP_2027Rebuild;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls;

type
  TRebuildFP_2012 = class(TForm)
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
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Rebuild: TRebuildFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027Common,
  FP_2027Common2,vtTrimStr,vtShared;

procedure TRebuildFP_2012.OKBtnClick(Sender: TObject);
//20170803 Igor>>>
var
  i: integer;
  Err: string;
  RetNo: Integer;
begin
  (*
   1. copy clients.d b f from application dir
   2. Get all returns from current data directory
   3. Read and save each return
  *)
  if not SysUtils.DirectoryExists(DataDirBox.Text) then
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;
  //20160429 Igor
  if SysUtils.FileExists(IncludeTrailingBackslash(DataDirBox.Text) + ClientsTable_dbf) then
  begin
    ShowMessage('The program does not allow a Re-build on a folder that contains ' +
                'the a Clients.dbf data base and the old format of data'); //20160522 Igor
    DataDirBox.SetFocus;
    exit;
  end;
  if not CopyDB(ClientsDBLite, Appdir, DataDirBox.Text, Err) then
  begin
    ShowMessage(Err);
    DataDirBox.SetFocus;
    exit;
  end;
  OKbtn.Enabled := False;
  CancelBtn.Enabled := False;
  try
    for i := 0 to FileListBox1.Items.Count - 1 do
    begin
      RetNo := -1; //20160522 Igor
      FileListBox1.ItemIndex := i;
      FileListBox1.Refresh;
      if (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite)) then // 20150922 Igor
      begin
        try
          RetNo := ReadReturn(DataDirBox.Text, FileListBox1.Items[i]);
        except
        end;
        if RetNo < 1 then
        begin
          ShowMessage('Cannot READ ' + FileListBox1.Items[i]);
          continue;
        end;
        try
          Label7.Caption := '#' + IntToStr(i + 1);
          Label7.Refresh;
          UpdateClientsTable(RetNo, DataDirBox.Text, FileListBox1.Items[i]);
        finally
          RemoveReturnFromMemory(RetNo);
        end;
      end;
    end;
    ShowMessage('Client Data Base has been rebuilt');
  finally
    OKbtn.Enabled := True;
    CancelBtn.Enabled := True;
  end;
  Close;
//20170803 Igor<<<
end;

procedure TRebuildFP_2012.FormCreate(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
DataDirBox.Text := OptRec.Dir_Cur;
DrawList;
Screen.Cursor := crDefault;
end;

procedure TRebuildFP_2012.FormPaint(Sender: TObject);
begin
If DataDirBox.Text <> OptRec.Dir_Cur then
begin
If not DirectoryExists(DataDirBox.Text) then
 begin ShowMessage('Invalid Directory');exit;end;
 DrawList;
end;
end;

procedure TRebuildFP_2012.DrawList;
begin
  FileListBox1.Directory := DataDirBox.Text;
  FileListBox1.Mask := '*.*';
  FileListBox1.ItemIndex :=0;
  Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TRebuildFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TRebuildFP_2012.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
  Invalidate; {DrawList;}
end;

end.
