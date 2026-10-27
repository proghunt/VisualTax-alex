unit Ulabels;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DB, DBTables, StdCtrls, Buttons,
  TrimStr,Udeclare;

type
  TLabels = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    LabelsBtn: TBitBtn;
    BitBtn1: TBitBtn;
    ListBox1: TListBox;
    PrintDialog1: TPrintDialog;
    DataDirBox: TEdit;
    Label1: TLabel;
    procedure LabelsBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Labels: TLabels;

implementation

{$R *.DFM}

procedure TLabels.LabelsBtnClick(Sender: TObject);
Const  MxLength = 40;
Var i,ndx,FNo:Integer; Tbl:TTable;FlName,FName :String;
  FileNm:String;F1:textFile; S:string;
  KeysForLabels: TStringList;

begin
 if MessageDlg('Load laser printer label sheets (2 5/8" X 1" (3 columns)'+
        Chr(13)+'Ready?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then
        exit;

 If ListBox1.Items.Count =0 then exit;
 KeysForLabels := TstringList.Create;
 For i := 0 to ListBox1.Items.Count-1 do
  KeysForLabels.Add(AllTrim(ListBox1.Items[i]));
 FileNm:=AppDir+'\'+'TempFile';
 KeysForLabels.SaveToFile(FileNm);
 KeysForLabels.Free;
 If PrintDialog1.Execute then PrintLabels(DataDirBox.Text,FileNm);
 exit;

end;

procedure TLabels.FormCreate(Sender: TObject);
begin
 Datadirbox.Text := AppDir;
 if Table1.State = dsInactive then
  begin
  Table1.DataBaseName := DataDirBox.Text;
  Table1.TableName := 'T4.DBF';
  Table1.IndexName := 'LASTNAME';

   try
     Table1.Open;
   Except
     on EDataBaseError do
        ShowMessage(Table1.TableName + ' can not be opened');
     end;
  end;
end;

procedure TLabels.DBGrid1DblClick(Sender: TObject);
begin
ListBox1.Items.Add(Table1.FieldByName('NAME').AsString);
end;

end.
