unit FP_2027ImportIncomingFiles;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,FileCtrl,Db, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TImportIncomingFiles = class(TForm)
    ProcessOneBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HeaderBox: TPanel;
    FileListBox1: TFileListBox;
    InDirBox: TEdit;
    Label1: TLabel;
    Image1: TImage;
    Memo1: TMemo;
    AllBtn: TBitBtn;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    ArchiveDirBox: TEdit;
    Label2: TLabel;
    ArchiveBtn: TBitBtn;
    CopyToOutFilesBtn: TBitBtn;
    Memo2: TMemo;
    DataSource4: TDataSource;
    LongNameBtn: TBitBtn;
    FDConnection: TADConnection;
    Accounts: TADTable;
    AnyTable: TADTable;
    HeadOfficeTbl: TADTable;
    BranchOfficesTbl: TADTable;
    AgentsTbl: TADTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImportIncomingFiles: TImportIncomingFiles;
  FlName:String;
  {InDir : String;}

implementation

{$R *.DFM}

//uses FP_2012ImportFsFiles,FP_2027TrimStr,FP_2027Declare;

end.
