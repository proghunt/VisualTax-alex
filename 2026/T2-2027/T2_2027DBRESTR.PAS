unit T2_2027DBRESTR;
//imported 08-01

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,DB,FileCtrl, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient, uADCompDataMove;

type
  TRestructT2_2027 = class(TForm)
    Label1: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataDirBox: TEdit;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    FileListBox1: TFileListBox;
    Label2: TLabel;
    BatchMove1: TADDataMove;
    EmptyFDConnection: TADConnection;
    OriginalFDConnection: TADConnection;
    OriginalTbl: TADTable;
    EmptyTbl: TADTable;
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
  Restruct: TRestructT2_2027;

implementation

{$R *.DFM}

uses
  vtCommon,vtMulti,
  T2_2027,T2_2027Declare,T2_2027TrimStr,
//T2_2027ChildWinNew,
  T2_2027Common,T2_2027Common2,
  vtTrimStr, vtShared, vtDataBase;

procedure TRestructT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TRestructT2_2027.OKBtnClick(Sender: TObject);
Var
  // MapList: TStringList; // rem 20150922 Igor
  i :integer;
  newADConnection: TADConnection;
  NewTbl: TADTable;
begin

If FileListBox1.Items.Count =0 then exit;
If FileListBox1.ItemIndex < 0 then exit;
If FileListBox1.Items[FileListBox1.ItemIndex] = '' then exit;

  //20150922 Igor
  SetTableName(OriginalFDConnection, OriginalTbl, DataDirBox.Text + '\' + FileListBox1.Items[FileListBox1.ItemIndex], ReplaceStr(UpperCase(FileListBox1.Items[FileListBox1.ItemIndex]), '.DB', ''), '');
  //20150922 Igor
  SetTableName(EmptyFDConnection, EmptyTbl, AppDir + '\' + FileListBox1.Items[FileListBox1.ItemIndex], ReplaceStr(UpperCase(FileListBox1.Items[FileListBox1.ItemIndex]), '.DB', ''), '');
  //20150922 Igor
  newADConnection:= TADConnection.Create(Application);
  newTbl:= TADTable.Create(Application);
  SetTableName(newADConnection, newTbl, DataDirBox.Text + '\' + ClientsBkDBLite, ClientsBkTableLite, '');

{ rem 20150922 Igor
MapList := TStringList.Create;
OriginalTbl.GetFieldNames(Maplist);
For i:=0 to Maplist.Count-1 do
  MapList[i] := MapList[i] + ' = ' + MapList[i];
}
  (*
  For i:=0 to Maplist.Count-1 do
     ShowMessage(MapList[i]);
  *)
   {
  Add('LAST_NAME');
  Add('FIRST_NAME');
  }

{1. Copy empty structure to new}

BatchMove1.Source := EmptyTbl;
BatchMove1.Destination := NewTbl;
BatchMove1.Mode := dmAppendUpdate; // batCopy; //20150922 Igor
BatchMove1.Execute;

{2. Append data from original to new}
//BatchMove1.Mappings := MapList; // rem 20150922 Igor
BatchMove1.Source := OriginalTbl;
BatchMove1.Destination := NewTbl;
BatchMove1.Mode := dmAppend; // batAppend; //20150922 Igor
BatchMove1.Execute;

{3. Copy New to original}
BatchMove1.Source := NewTbl;
BatchMove1.Destination := OriginalTbl;
BatchMove1.Mode := dmAppendUpdate; // batCopy; //20150922 Igor
BatchMove1.Execute;

NewTbl.Free;
newADConnection.Free;
//MapList.Free; // rem 20150916 Igor
ShowMessage('Data Base Restructuring is complete');
end;

procedure TRestructT2_2027.FormPaint(Sender: TObject);
begin
 FileListBox1.Directory := DataDirBox.Text;
 FileListBox1.Mask := '*.DB'; //20150922 Igor
end;

procedure TRestructT2_2027.DataDirBoxExit(Sender: TObject);
begin
FileListBox1.Refresh;
end;

procedure TRestructT2_2027.FormCreate(Sender: TObject);
begin
DataDirBox.Text := OptRec.Dir_Cur;
end;

end.
