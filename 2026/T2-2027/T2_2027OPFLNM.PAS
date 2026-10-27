unit T2_2027OPFLNM;
//imported 08-01

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons;

type
  TOpenFlNameT2_2027 = class(TForm)
    Label1: TLabel;
    FlNameBox: TEdit;
    Label2: TLabel;
    DataDirBox: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    FlName : String;
  public
    { Public declarations }
  end;


function OpenFlName: string;


implementation

uses
  vtCommon,vtMain,
  T2_2027,T2_2027cntErr,T2_2027Declare,T2_2027Common,
  T2_2027Common2,T2_2027TrimStr,//T2_2027ChildWinNew;
  T2_2027main,
  vtTrimStr,vtShared, vtMulti; //20160222 Igor

{$R *.DFM}

function OpenFlName: string;
begin
  with TOpenFlNameT2_2027.Create(Application) do
  begin
    ShowModal;
    Result := flname;
    Free;
  end;
end;

procedure TOpenFlNameT2_2027.FormCreate(Sender: TObject);
begin

 If OpenDialog1.Execute then
    FlNameBox.Text := OpenDialog1.FileName;

  DirectoryListBox1.Drive := DriveComboBox1.Drive;
  FileListBox1.Drive := DriveComboBox1.Drive;
  FileListBox1.Directory := DirectoryListBox1.Directory;

  FlName := '';
  FlNameBox.Text := '';
  DataDirBox.Text := OptRec.Dir_Cur;
end;

procedure TOpenFlNameT2_2027.OKBtnClick(Sender: TObject);
var
 result : integer;s:String;sin, DataDir:String;
 RetNo:Integer;
begin
 Sin:=FlNameBox.Text;
 FlName := LeftStr(Sin,8)+'.'+RightStr(Sin,1);

  DataDir := DataDirBox.Text;
  If IsOkToOpenReturn(DataDir,FlName) = False then Exit;
  RetNo:=OpenReturn(DataDir,FlName,False);
  If RetNo < 1 then
  begin
    //ShowOpenReturnFailure(RetNo,DataDir,FlName); - already done
    exit;
  end;
   CountDiagnostics(RetNo);
   MainForm.GuiCommand(gcShowLeftPanel); //MainForm.LeftPanel.Visible:=True; //20160222 Igor
   OpenForm(RetNo,'T2',0);
   MainForm.FormPaint(Application);
   Close;

end;

procedure TOpenFlNameT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
