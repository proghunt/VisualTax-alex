unit FP_2027OpFlNm;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons;

type
  TOpenFlNameFP_2012 = class(TForm)
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
    { Private declarations }
  public
    FlName : String;
    RetNo: integer;
  end;

var
  OpenFlName: TOpenFlNameFP_2012;

implementation

uses vtCommon,vtMain,FP_2027,FP_2027cntErr,FP_2027Declare,FP_2027Common,
  FP_2027Common2,FP_2027TrimStr,FP_2027ChildWinNew,FP_2027main,vtTrimStr,
  vtShared, vtMulti;//20160222 Igor

{$R *.DFM}

procedure TOpenFlNameFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := 0;
 If OpenDialog1.Execute then
    FlNameBox.Text := OpenDialog1.FileName;

  DirectoryListBox1.Drive := DriveComboBox1.Drive;
  FileListBox1.Drive := DriveComboBox1.Drive;
  FileListBox1.Directory := DirectoryListBox1.Directory;

  FlName := '';
  FlNameBox.Text := '';
  DataDirBox.Text := OptRec.Dir_Cur;
end;

procedure TOpenFlNameFP_2012.OKBtnClick(Sender: TObject);
var
  sin:String;
begin
 Sin:=FlNameBox.Text;
 FlName := LeftStr(Sin,8)+'.'+RightStr(Sin,1);
 If IsOkToOpenReturn(DataDirBox.Text,FlName,Sin) = False then Exit;
 RetNo:=OpenReturn(DataDirBox.Text,FlName,False);
 If RetNo < 1 then exit;

   LockWindowUpdate(Application.MainForm.Handle);
   CountDiagnostics(RetNo);
   OpenForm(RetNo,'PAGE_1',0);
   MainForm.GuiCommand(gcShowLeftPanel); //MainForm.LeftPanel.Visible:=True; //20160222 Igor
   MainForm.FormPaint(Application);
   Close;
end;

procedure TOpenFlNameFP_2012.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

end.
