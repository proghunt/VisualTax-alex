unit FP_2027GETFILE;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,FileCtrl,Grids,Outline,DirOutln,StdCtrls,Buttons,ExtCtrls,
  FP_2027Declare;

type
  TgetfileFP_2012 = class(TForm)
    Panel1: TPanel;
    ListBox1: TListBox;
    Label1: TLabel;
    ClearBtn: TButton;
    Panel2: TPanel;
    FileNameBox: TEdit;
    Label2: TLabel;
    FileListBox1: TFileListBox;
    FilterComboBox1: TFilterComboBox;
    Label3: TLabel;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    Label4: TLabel;
    Label5: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DirLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FileNameBoxDblClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  getfile: TgetfileFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027Common,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TgetfileFP_2012.FormCreate(Sender: TObject);
{Needs global: SomeList, SomeFilter, SomeCaption, SomeFileMask}
begin
  Screen.Cursor := crHourGlass;
  SomeList.Clear; // := TstringList.Create;
  FilterComboBox1.Filter := SomeFilter;
  FileListBox1.Mask := SomeFileMask;
  Caption := SomeCaption; {global variable set by calling unit}
  DirectoryListBox1.Directory := SomeDir;
  FileListBox1.Directory := DirectoryListBox1.Directory;
  DriveComboBox1.DirList := DirectoryListBox1;
  DirectoryListBox1.FileList := FileListBox1;
  DirectoryListBox1.DirLabel := DirLabel;
  FileListBox1.FileEdit := FileNameBox;
  FilterComboBox1.FileList := FileListBox1;
  FileListBox1.ItemIndex :=0;
  Screen.Cursor := crDefault;
end;

procedure TgetfileFP_2012.CancelBtnClick(Sender: TObject);
begin
SomeList.Clear;
Close;
end;

procedure TgetfileFP_2012.OKBtnClick(Sender: TObject);
Var
i : integer;
{SomeList is a global TstringList;
 Everything in the ListBox on the screen is duplicated
 in the SomeList as well}
begin
Close;
(*
For i :=0 to SomeList.Count -1 do
  ShowMessage(SomeList[i]);
{it should be freed by the calling unit}
 SomeList.Free;
*)
end;

procedure TgetfileFP_2012.FileListBox1DblClick(Sender: TObject);
begin
If IsInList(FileNameBox.text,SomeList) > -1
then
  ShowMessage(FileNameBox.text+ CHR(13)+ 'Already selected!')
else
  begin
  ListBox1.Items.Add(FileNameBox.text);
  SomeList.Add(FileNameBox.text);
  ListBox1.Refresh;
  end;
end;

procedure TgetfileFP_2012.ClearBtnClick(Sender: TObject);
begin
ListBox1.Clear;
SomeList.Clear;
end;

procedure TgetfileFP_2012.ListBox1DblClick(Sender: TObject);
var i:integer;
begin
 For i :=0 to Somelist.Count-1 do {do not have the same index}
  If SomeList[i] = ListBox1.Items[ListBox1.ItemIndex]
   then begin SomeList.Delete(i);break; end;
 ListBox1.Items.Delete(ListBox1.ItemIndex);
 ListBox1.Refresh;
end;

procedure TgetfileFP_2012.FileNameBoxDblClick(Sender: TObject);
begin
FileListBox1DblClick(sender);
end;

procedure TgetfileFP_2012.FileListBox1Click(Sender: TObject);
begin
 FileListBox1.FileEdit := FileNameBox;
end;

end.
