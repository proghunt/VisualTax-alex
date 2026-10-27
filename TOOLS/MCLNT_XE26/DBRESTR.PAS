unit Dbrestr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB, DBTables, FileCtrl,
  UDeclare, TrimStr;

type
  TRestruct = class(TForm)
    Label1: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataDirBox: TEdit;
    BatchMove1: TBatchMove;
    DataSource1: TDataSource;
    OriginalTbl: TTable;
    EmptyTbl: TTable;
    DataSource2: TDataSource;
    FileListBox1: TFileListBox;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Restruct: TRestruct;

implementation

{$R *.DFM}

procedure TRestruct.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TRestruct.OKBtnClick(Sender: TObject);
Var
NewTbl :TTable;
var MapList: TStringList;

begin

  MapList := TStringList.Create;
  with MapList do
  begin
   Clear;
{
  Add('LAST_NAME');
  Add('FIRST_NAME');
  }
  end;

If FileListBox1.Items.Count =0 then exit;
If FileListBox1.ItemIndex < 0 then exit;
If FileListBox1.Items[FileListBox1.ItemIndex] = '' then exit;

OriginalTbl.DataBaseName := DataDirBox.Text;
OriginalTbl.TableName := FileListBox1.Items[FileListBox1.ItemIndex];

EmptyTbl.DataBaseName := AppDir;
EmptyTbl.TableName := OriginalTbl.TableName;

NewTbl := TTable.Create(Application);
NewTbl.DataBaseName := EmptyTbl.DataBaseName;
NewTbl.TableType := ttDBase;
NewTbl.TableName := 'Temp1.DBF';


{1. Copy empty structure to new}

BatchMove1.Source := EmptyTbl;
BatchMove1.Destination := NewTbl;
BatchMove1.Mode := batCopy;
BatchMove1.Execute;

{2. Append data from original to new}
{BatchMove1.Mappings := MapList;}
BatchMove1.Source := OriginalTbl;
BatchMove1.Destination := NewTbl;
BatchMove1.Mode := batAppend;
BatchMove1.Execute;

{3. Copy New to original}
BatchMove1.Source := NewTbl;
BatchMove1.Destination := OriginalTbl;
BatchMove1.Mode := batCopy;
BatchMove1.Execute;

NewTbl.Free;
MapList.Free;
ShowMessage('Data Base Restructuring is complete');
end;

procedure TRestruct.FormPaint(Sender: TObject);
begin
 FileListBox1.Directory := DataDirBox.Text;
 FileListBox1.Mask := '*.DBF';
end;

procedure TRestruct.DataDirBoxExit(Sender: TObject);
begin
FileListBox1.Refresh;
end;

procedure TRestruct.FormCreate(Sender: TObject);
begin
DataDirBox.Text := CfgRec.Ef_DataDir;
end;

end.
