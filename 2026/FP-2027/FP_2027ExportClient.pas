unit FP_2027ExportClient;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,Grids,DBGrids,Db,FileCtrl,FP_2027TrimStr,DBCtrls;

type
  TExportClient = class(TForm)
    HeaderBox: TPanel;
    DataSource1: TDataSource;
    Memox: TMemo;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    GroupBox3: TGroupBox;
    AllClientsBtn: TBitBtn;
    SelectClientBtn: TBitBtn;
    AgentBox: TComboBox;
    Label1: TLabel;
    Panel2: TPanel;
    Label4: TLabel;
    ExportOneBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FilesOutBox: TEdit;
    ExportAllBtn: TBitBtn;
    DBMemo1: TDBMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportClient: TExportClient;
  Agent:string; //[5];
  FlName,dir:String;
  FilesInDir,FilesOutDir,FilesInArchives,FilesOutArchives:String;
implementation

{$R *.DFM}

end.
