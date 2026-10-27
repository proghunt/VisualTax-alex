unit MainUIUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TMainForm = class(TForm)
    FileListBox: TListBox;
    DirectoryName: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    ADOConnection: TADOConnection;
    LoadFileName: TButton;
    SQLiteDirectory: TEdit;
    SpeedButton2: TSpeedButton;
    Button1: TButton;
    cbAddRowId: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure LoadFileNameClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses FileCtrl, MainUnit;

procedure TMainForm.Button1Click(Sender: TObject);
var FileName: string;
begin
  FileName := FileListBox.Items[FileListBox.ItemIndex];
  GenSqliteSchema(DirectoryName.Text + '\' + FileName + '.dbf', SQLiteDirectory.Text + '\' + FileName + '.db', cbAddRowId.Checked); //20220622 Igor
  PortDataToSqlite(DirectoryName.Text + '\' + FileName + '.dbf', SQLiteDirectory.Text + '\' + FileName + '.db');
  ShowMessage('Table ' + FileName + ' converted')
end;

procedure TMainForm.FormShow(Sender: TObject); //20220622 Igor
begin
  DirectoryName.Text := ExtractFilePath(Application.ExeName);
  SQLiteDirectory.Text := ExtractFilePath(Application.ExeName);
end;

procedure TMainForm.LoadFileNameClick(Sender: TObject);
begin
   ADOConnection.Close;
   ADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
                     'Data Source=' + DirectoryName.Text + ';' +
                     'Extended Properties="DBASE IV";';
   ADOConnection.Open;
   ADOConnection.GetTableNames(FileListBox.Items);
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var chosenDirectory: string;
begin
  chosenDirectory := DirectoryName.Text; //20220622 Igor
  if SelectDirectory('', DirectoryName.Text, chosenDirectory) then
     DirectoryName.Text := chosenDirectory
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
var chosenDirectory: string;
begin
  chosenDirectory := SQLiteDirectory.Text; //20220622 Igor
  if SelectDirectory('', SQLiteDirectory.Text, chosenDirectory) then
     SQLiteDirectory.Text := chosenDirectory
end;

end.
