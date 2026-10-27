unit T2_2027Rebuild;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls, System.IOUtils; //20201013 Igor

type
  TRebuildT2_2027 = class(TForm)
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
    BitBtn1: TBitBtn;
    Panel3: TPanel;
    Label9: TLabel;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    FileNameFormat: TRadioGroup;
    cbRename: TCheckBox;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure cbRenameClick(Sender: TObject); //20201013 Igor
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Const HelpTopic = 'Rebuild_the_clients_data_base';
var
  RebuildT2_2027: TRebuildT2_2027;

implementation

{$R *.DFM}

uses vtCommon,T2_2027,T2_2027Declare,T2_2027TrimStr,T2_2027Common,
  T2_2027Common2,vtTrimStr,vtShared;

procedure TRebuildT2_2027.OKBtnClick(Sender: TObject);
//20170811 Igor>>>
var
  RetNo: Integer;
  i: Integer;
  Err: String;
  cFileName, cNewFileName: string; //20201013 Igor
begin
  (*
    1. copy clients.d bf from application dir
    2. Get all returns from current data directory
    3. Read and save each return
  *)
  If Not SysUtils.DirectoryExists(DataDirBox.Text) then // 20150702
  begin
    ShowMessage('Data directory does not exist');
    DataDirBox.SetFocus;
    exit;
  end;
  // 20160429 Igor
  if FileExists(IncludeTrailingPathDelimiter(DataDirBox.Text) + ClientsTable_dbf)
  then
  Begin
    ShowMessage
      ('The program does not allow a Re-build on a folder that contains ' +
      'the a Clients.dbf data base and the old format of data');  //20160522 Igor
    DataDirBox.SetFocus;
    exit;
  End;
  if not CopyDB(ClientsDBLite, Appdir, DataDirBox.Text, Err) then
  begin
    MessageDlg(Err, mtError, [mbOk], 0);
    Exit;
  end;
  UpdateDbStructure; //20201015 Igor
  OKBtn.Enabled := False;
  CancelBtn.Enabled := False;
  for i := 0 to FileListBox1.Items.Count - 1 do
  begin
    RetNo := -1; //20160522 Igor
    FileListBox1.ItemIndex := i;
    FileListBox1.Refresh;
    If (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite)) then
    // 20150923 Igor
    begin
      try
        RetNo := ReadReturn(DataDirBox.Text, FileListBox1.Items[i], True, False); // 'Y','N');
      except
      end;
    end;
    if RetNo > 0 then
    begin
      try
        Label7.Caption := '#' + IntToStr(i + 1);
        Label7.Refresh;
        //20201013 Igor >>>
        cFileName := FileListBox1.Items[i];
        if cbRename.Checked then
        begin
          cNewFileName := GenerateReturnFileName(RetNo, IntToStr(FileNameFormat.ItemIndex));
          if not SameText(cNewFileName, cFileName) then
          begin
            if FileExists(TPath.Combine(DataDirBox.Text,cNewFileName)) then
              ShowMessage('Cannot rename file '+ FileListBox1.Items[i] +' to '+ cNewFileName +
                                 ' because there is a file with this name in '+ DataDirBox.Text)
            else
            begin
              RenameFile(TPath.Combine(DataDirBox.Text,cFileName), TPath.Combine(DataDirBox.Text,cNewFileName));
              cFileName := cNewFileName;
            end;
          end;
        end;
        UpdateClientsTable(RetNo,DataDirBox.Text,cFileName);
        //20201013 Igor <<<
      finally
        RemoveReturnFromMemory(RetNo);
      end;
    end
    else
    begin
      ShowMessage('Cannot READ ' + FileListBox1.Items[i]);
    end;
  end;
  ShowMessage('Client Data Base has been rebuilt');
  OKBtn.Enabled := True;
  CancelBtn.Enabled := True;
  Close;
//20170811 Igor<<<
end;

procedure TRebuildT2_2027.FormCreate(Sender: TObject);
begin
FileNameFormat.ItemIndex:=0; //20201212 CON
Screen.Cursor := crHourGlass;
DataDirBox.Text := OptRec.Dir_Cur;
DrawList;
Screen.Cursor := crDefault;
FileNameFormat.ItemIndex := StrToIntDef(OptRec.FileNameFormat, 0); //20201013 Igor
end;

procedure TRebuildT2_2027.FormPaint(Sender: TObject);
begin
If DataDirBox.Text <> OptRec.Dir_Cur then
begin
If not SysUtils.DirectoryExists(DataDirBox.Text) then //20150702
 begin ShowMessage('Invalid Directory');exit;end;
 DrawList;
end;
end;

procedure TRebuildT2_2027.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TRebuildT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TRebuildT2_2027.cbRenameClick(Sender: TObject); //20201013 Igor
begin
  FileNameFormat.Enabled := cbRename.Checked;
end;

procedure TRebuildT2_2027.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
Invalidate; {DrawList;}
end;

procedure TRebuildT2_2027.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T2Help',HelpTopic);
end;

end.
