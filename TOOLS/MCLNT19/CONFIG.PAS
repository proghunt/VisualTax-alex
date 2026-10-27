unit Config;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TabNotBk, StdCtrls, Buttons, Mask, DBCtrls, DB, DBTables;

type
  Toptions = class(TForm)
    Config: TTabbedNotebook;
    Button1: TButton;
    Button2: TButton;
    ScrollBox: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    EditPRP_NAME: TDBEdit;
    EditPRP_STREET: TDBEdit;
    EditPRP_CITY: TDBEdit;
    EditPRP_PROV: TDBEdit;
    EditPRP_POSTAL: TDBEdit;
    EditPRP_COUNTR: TDBEdit;
    EditPRP_AREA: TDBEdit;
    EditPRP_TEL: TDBEdit;
    EditPRP_FAX: TDBEdit;
    EditPROV_DEF: TDBEdit;
    EditPROV_CUR: TDBEdit;
    ScrollBox1: TScrollBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DataSource1: TDataSource;
    Table1: TTable;
    procedure ScrollBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  options: Toptions;

implementation

{$R *.DFM}

procedure Toptions.ScrollBox1Click(Sender: TObject);
var
table1 : TTable;
begin
  Table1 := TTable.Create(Application);
 { Flist  := TList.Create;}
  Table1.DataBaseName := 'C:\delphi\t1';
  Table1.TableName := 'T1CFG.DBF';
  Table1.Open;
end;

end.
