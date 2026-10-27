unit FP_2027DBRESTR;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,DB,FileCtrl, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataMove, uADCompDataSet, uADCompClient;

type
  TRestructFP_2012 = class(TForm)
    Label1: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataDirBox: TEdit;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    FileListBox1: TFileListBox;
    Label2: TLabel;
    EmptyFDConnection: TADConnection;
    EmptyTbl: TADTable;
    OriginalFDConnection: TADConnection;
    OriginalTbl: TADTable;
    BatchMove1: TADDataMove;
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
  Restruct: TRestructFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027ChildWinNew,
  FP_2027Common,FP_2027Common2,vtTrimStr,vtShared;

procedure TRestructFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;
(*
procedure TRestruct.OKBtnClick(Sender: TObject);
Var
i :integer;
MdxName:String;
begin
  If FileListBox1.Items.Count =0 then exit;
  If FileListBox1.ItemIndex < 0 then exit;
  If FileListBox1.Items[FileListBox1.ItemIndex] = '' then exit;

  OriginalTbl.DataBaseName := DataDirBox.Text;
  OriginalTbl.TableName := FileListBox1.Items[FileListBox1.ItemIndex];

  EmptyTbl.DataBaseName := AppDir;
  EmptyTbl.TableName := OriginalTbl.TableName;

  ShowMessage(IntToStr(EmptyTbl.BatchMove(OriginalTbl, batAppend)));
  CopyFile(AppDir+'\'+EmptyTbl.TableName,DataDirBox.Text+'\'+EmptyTbl.TableName);
  {form mdx name}
  Mdxname := ExtractNonExtensionFileName(EmptyTbl.TableName+'.'+'MDX');
  CopyFile(AppDir+'\'+MdxName,DataDirBox.Text+'\'+MdxName);
  EmptyTbl.Exclusive:=True;
  EmptyTbl.EmptyTable;
  EmptyTbl.Exclusive:=False;
end;
*)


procedure TRestructFP_2012.OKBtnClick(Sender: TObject);
Var i :integer;
    ADConnection: TADConnection;
    NewTbl: TADTable;
var MapList: TStringList;
 {does not work if different structures/indexes}
begin
(*
If FileListBox1.Items.Count =0 then exit;
If FileListBox1.ItemIndex < 0 then exit;
If FileListBox1.Items[FileListBox1.ItemIndex] = '' then exit;

OriginalTbl.DataBaseName := DataDirBox.Text;
OriginalTbl.TableName := FileListBox1.Items[FileListBox1.ItemIndex];

EmptyTbl.DataBaseName := AppDir;
EmptyTbl.TableName := OriginalTbl.TableName;

NewTbl := T Table.Create(Application);
NewTbl.DataBaseName := OriginalTbl.DataBaseName;
NewTbl.TableType := ttDBase;
NewTbl.TableName := ClientBk.DB F;


MapList := TStringList.Create;
OriginalTbl.GetFieldNames(Maplist);
For i:=0 to Maplist.Count-1 do
  MapList[i] := MapList[i] + ' = ' + MapList[i];
   {
  Add('LAST_NAME');
  Add('FIRST_NAME');
  }

{1. Copy empty structure to new}

BatchMove1.Source := EmptyTbl;
BatchMove1.Destination := NewTbl;
BatchMove1.Mode := batCopy;
BatchMove1.Execute;

{2. Append data from original to new}
BatchMove1.Mappings := MapList;
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
*)
end;

procedure TRestructFP_2012.FormPaint(Sender: TObject);
begin
 FileListBox1.Directory := DataDirBox.Text;
 FileListBox1.Mask := '*.DB'; //20150921 Igor
end;

procedure TRestructFP_2012.DataDirBoxExit(Sender: TObject);
begin
FileListBox1.Refresh;
end;

procedure TRestructFP_2012.FormCreate(Sender: TObject);
begin
DataDirBox.Text := OptRec.Dir_Cur;
end;

end.
