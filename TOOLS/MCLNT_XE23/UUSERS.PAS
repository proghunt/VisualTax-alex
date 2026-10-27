unit Uusers;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Buttons, DBTables, Mask, ExtCtrls,
  TrimStr,UDeclare, Grids, DBGrids;

type
  TUserSetup = class(TForm)
    Label8: TLabel;
    EditPREP_NAME: TDBEdit;
    Table1: TTable;
    DataSource1: TDataSource;
    EditTAX_DIR: TDBEdit;
    EditEFILE_DIR: TDBEdit;
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditM_OFFICE: TDBEdit;
    Label2: TLabel;
    EditBRANCH: TDBEdit;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    EditLOGIN_ID: TDBEdit;
    Label5: TLabel;
    EditPSWD: TDBEdit;
    Label6: TLabel;
    EditAUTH_LEVEL: TDBEdit;
    Label3: TLabel;
    EditPREP_INTLS: TDBEdit;
    Label7: TLabel;
    EditINV_NO: TDBEdit;
    DBGrid1: TDBGrid;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  UserSetup: TUserSetup;

implementation

{$R *.DFM}

procedure TUserSetup.FormCreate(Sender: TObject);
begin
If LicenseLevel <> '3' then
        GroupBox1.Enabled := False;  {Enterprise office}
If Table1.Active = false then
 begin
 Table1.DataBaseName := AppDir;
 Table1.TableName := 'USERS.DBF';
 Table1.Open;
 Table1.Edit;
 end;
end;

procedure TUserSetup.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TUserSetup.OKBtnClick(Sender: TObject);
begin
 Table1.Edit;
 Close;
end;

end.
