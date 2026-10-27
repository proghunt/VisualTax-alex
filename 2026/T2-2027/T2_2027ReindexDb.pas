unit T2_2027ReindexDb;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  FileCtrl,Buttons,ExtCtrls;

type
  TReindexDbT2_2027 = class(TForm)
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    DataDirBox: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Label4: TLabel;
    Label2: TLabel;
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DoReindex(DataDir:String);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReindexDb: TReindexDbT2_2027;

implementation

{$R *.DFM}

uses vtMulti,T2_2027,T2_2027Declare,T2_2027TrimStr,vtTrimStr,vtShared;

procedure TReindexDbT2_2027.OkBtnClick(Sender: TObject);
//Var Qry:TADQuery;
begin
 //20150922
 ShowMessage('SQL Database not need reindex');
 Exit;

 If RetInMem>0 then
 begin
  ShowMessage('Please close all files first');
  Exit;
 end;
 If Not SysUtils.DirectoryExists(DataDirBox.Text) then //20150702
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;

 If not FileExists(DataDirBox.Text+'\'+ClientsDBLite) then //20150826 Igor
 begin
  ShowMessage('The '+ DataDirBox.Text+'\'+ClientsDBLite+ //20150826 Igor
    ' does not exist. You may have to Re-build the Clients Data Base');
  exit;
 end;
 DoReindex(DataDirBox.Text);
end;

procedure TReindexDbT2_2027.DoReindex(DataDir:String);
//Var Qry:TADQuery;
begin
 //20150916 Igor
 ShowMessage('SQL Database not need reindex');
 Exit;

 (*rem 20150922 Igor
 Screen.Cursor := crHourGlass;
 Qry:=TADQuery.Create(Application);
 Qry.DataBaseName := DataDir;
 Qry.Sql.Clear;
 {Qry.Sql.LoadFromFile(AppDir+'\'+'Reindex.qry');}

 Qry.Sql.Clear;
 Qry.Sql.Add('DROP INDEX "Clients.DBF".Corp_Name');
 Try Qry.ExecSql; except end;

 Qry.Sql.Clear;
 Qry.Sql.Add('DROP INDEX "Clients.DBF".Due_Date');
 Try Qry.ExecSql; except end;

 Qry.SQL.Clear;
 Qry.Sql.Add('DROP INDEX "Clients.DBF".FILE_NAME');
 Try Qry.ExecSql; except end;

 Qry.SQL.Clear;
 Qry.Sql.Add('DROP INDEX "Clients.DBF".PRP_STATUS');
 Try Qry.ExecSql; except end;

 {now create index again}
 Qry.Sql.Clear;
 Qry.Sql.Add('CREATE INDEX Corp_Name ON "Clients.DBF" (Corp_Name)');
 Try Qry.ExecSql; except end;

 Qry.Sql.Clear;
 Qry.Sql.Add('CREATE INDEX Due_Date ON "Clients.DBF" (Due_Date)');
 Try Qry.ExecSql; except end;

 Qry.SQL.Clear;
 Qry.Sql.Add('CREATE INDEX FILE_NAME ON "Clients.DBF" (FILE_NAME)');
 Try Qry.ExecSql; except end;

 Qry.SQL.Clear;
 Qry.Sql.Add('CREATE INDEX PRP_STATUS ON "Clients.DBF" (PRP_STATUS)');
 Try Qry.ExecSql; except end;

 Qry.Free;
 ShowMessage('Done');
 Screen.Cursor := crDefault;
 *)
end;


procedure TReindexDbT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TReindexDbT2_2027.FormCreate(Sender: TObject);
begin
 DataDirBox.Text := OptRec.Dir_Cur;
end;

end.
