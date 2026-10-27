unit T1_2026merge;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,FileCtrl,Db;

type
  TMergeT1_2026 = class(TForm)
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
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    BrowseBtn1: TBitBtn;
    BrowseBtn2: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure DestDataDirBoxExit(Sender: TObject);
    procedure BrowseBtn1Click(Sender: TObject);
    procedure BrowseBtn2Click(Sender: TObject);
    procedure BrowseBtn1KeyPress(Sender: TObject; var Key: Char);
    procedure BrowseBtn2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Merge: TMergeT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,vtTrimStr,vtShared;
  //20150826 IGOR

procedure TMergeT1_2026.OKBtnClick(Sender: TObject);
Var I:integer;
begin
//20150826 IGOR need to rewrite
 (*
   1. copy clients.d bf from application dir
   2. Get all returns from current data directory
   3. Read and save each return
  *)
 If DataDirBox.text = DestDataDirBox.text then
 begin
   ShowMessage('From and To directories cannot be the same');
   exit;
 end;
 
 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;
(*
 If Not FileExists(DataDirBox.Text+'\'+ClientsTable) then
 begin
  ShowMessage('Source directory must have a CLIENTS.DBF file');
  DataDirBox.SetFocus;
  exit;
 end;

 If Not FileExists(DataDirBox.Text+'\'+'Clients.MDX') then
 begin
  ShowMessage('Source directory must have a CLIENTS.MDX file');
  DataDirBox.SetFocus;
  exit;
 end;


 If Not DirectoryExists(DestDataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist'+
   Chr(13)+'Directory must be created with CONFIGURE|DATA DIRECTORIES');
  DestDataDirBox.SetFocus;
  exit;
 end;

 If Not FileExists(DestDataDirBox.Text+'\'+ClientsTable) then
   CopyDB(ClientsTable, Appdir,DataDirBox.Text);

 OKbtn.Enabled:=False; CancelBtn.Enabled:=False;
 for i:=0 to FileListBox1.Items.Count -1 do
  begin
     InitFormsTable;  //20120621
     FileListBox1.ItemIndex :=i;
     FileListBox1.Refresh;
     If (UpperCase(FileListBox1.Items[i]) <> 'CLIENTS.DBF') and
       (UpperCase(FileListBox1.Items[i]) <> 'CLIENTS.MDX') then
         CopyFile(DataDirBox.text+'\'+FileListBox1.Items[i],
          DestDataDirBox.Text+'\'+FileListBox1.Items[i]);
  end;
  {now merge data bases}
  Table1.DataBaseName := DataDirBox.Text;
  Table1.IndexName := 'File_Name';
  Table2.DataBaseName := DestDataDirBox.Text;
  Table2.IndexName := 'File_Name';

  If Table1.Active then Table1.Close;
  If Table2.Active then Table2.Close;
  Table1.Open;
  Table2.Open;

  Table1.First;
  Repeat
   If not Table2.FindKey([Table1.FieldByName('File_Name').AsString]) then
    begin
     Table2.Insert;
     for I := 0 to Table1.FieldCount - 1 do
         Table2.Fields[I] := Table1.Fields[i];
     Table2.Post;
    end;
    Table1.Next;
  until Table1.Eof;

  Table1.Close;
  Table2.Close;

  ShowMessage('Merging completed');
  OKbtn.Enabled:=True; CancelBtn.Enabled:=True;
  DataDirBox.SetFocus; *)
end;

procedure TMergeT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TMergeT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;

If DirectoryExists(DataDirBox.Text) then
 DrawList
else
 ShowMessage('Directory ' + DataDirBox.Text + ' does not exist');
end;

procedure TMergeT1_2026.FormCreate(Sender: TObject);
begin
DataDirBox.Text := OptRec.Dir_Cur;
DrawList;
end;

procedure TMergeT1_2026.FormPaint(Sender: TObject);
begin
If DataDirBox.Text <> OptRec.Dir_Cur then DrawList;
end;

procedure TMergeT1_2026.DrawList;
begin
If Not DirectoryExists(DataDirBox.Text) then exit;
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
Label7.Caption := '';
end;


procedure TMergeT1_2026.DestDataDirBoxExit(Sender: TObject);
begin
DrawList;
end;

procedure TMergeT1_2026.BrowseBtn1Click(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
  begin
    DataDirBox.Text := DirSelected;
    DataDirBoxExit(Sender);
  end;
end;

procedure TMergeT1_2026.BrowseBtn2Click(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
  begin
    DestDataDirBox.Text := DirSelected;
    DestDataDirBoxExit(Sender);
  end;
end;

procedure TMergeT1_2026.BrowseBtn1KeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

procedure TMergeT1_2026.BrowseBtn2KeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

end.
