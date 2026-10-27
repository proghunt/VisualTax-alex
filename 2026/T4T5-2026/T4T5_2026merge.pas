unit T4T5_2026merge;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,
  {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON}; //20170612 Igor

type
  TMergeT4T5_2026 = class(TForm)
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
  Merge: TMergeT4T5_2026;

implementation

{$R *.DFM}

uses vtCommon,T4T5_2026,T4T5_2026Declare,T4T5_2026TrimStr,T4T5_2026Common,
  T4T5_2026Common2,vtTrimStr,vtShared;

procedure TMergeT4T5_2026.OKBtnClick(Sender: TObject);
//20170803 Igor>>>
var
  I, RetNo: integer;
  Err: String;
begin
 (*
   1. copy clients.d bf from application dir
   2. Get all returns from current data directory
   3. Read and save each return
  *)
  if not SysUtils.DirectoryExists(DataDirBox.Text) then //20170612 Igor
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;
  if not SysUtils.DirectoryExists(DestDataDirBox.Text) then //20170612 Igor
  begin
    ShowMessage('Data directory does not exist');
    DestDataDirBox.SetFocus;
    exit;
  end;
  if not FileExists(DestDataDirBox.Text + '\' + ClientsDBLite) then //20150923 Igor
    if not CopyDB(ClientsDBLite, Appdir, DataDirBox.Text, Err) then //20150923 Igor
    begin
      ShowMessage(Err);
      DestDataDirBox.SetFocus;
      exit;
    end;

  OKbtn.Enabled := False;
  CancelBtn.Enabled := False;
  try
    for I := 0 to FileListBox1.Items.Count - 1 do
    begin
      FileListBox1.ItemIndex := I;
      FileListBox1.Refresh;
      if (UpperCase(FileListBox1.Items[I]) <> UpperCase(ClientsDBLite)) then //20150923 Igor
      begin
        RetNo := ReadReturn(DataDirBox.Text, FileListBox1.Items[I], True);
        if RetNo < 1 then
          continue;
        try
          Label7.Caption := '#' + IntToStr(I + 1);
          Label7.Refresh;
          CopyFile(DataDirBox.text + '\' + FileListBox1.Items[I], DestDataDirBox.Text + '\' + FileListBox1.Items[I]);
          UpdateClientsTable(RetNo, DestDataDirBox.Text, FileListBox1.Items[I]);   {prpstatus,efstatus,notes}
        finally
          RemoveReturnFromMemory(RetNo);
        end;
      end;
    end;
    ShowMessage('Merging completed');
  finally
    OKbtn.Enabled := True;
    CancelBtn.Enabled := True;
  end;
//20170803 Igor<<<
end;

procedure TMergeT4T5_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TMergeT4T5_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
DrawList;
end;

procedure TMergeT4T5_2026.FormCreate(Sender: TObject);
begin
DataDirBox.Text := OptRec.Dir_Cur;
DrawList;
end;

procedure TMergeT4T5_2026.FormPaint(Sender: TObject);
begin
If DataDirBox.Text <> OptRec.Dir_Cur then DrawList;
end;

procedure TMergeT4T5_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;


end.
