unit FP_2027MERGE;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,FileCtrl,FP_2027Declare,FP_2027TrimStr,
  FP_2027Common,FP_2027Common2;

type
  TMerge = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    FileListBox1: TFileListBox;
    DataDirBox: TEdit;
    Image1: TImage;
    DestDataDirBox: TEdit;
    Label4: TLabel;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label5: TLabel;
    Label8: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Merge: TMerge;

implementation

{$R *.DFM}


procedure TMerge.OKBtnClick(Sender: TObject);
Var I:integer;
begin
end;

procedure TMerge.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TMerge.DataDirBoxExit(Sender: TObject);
begin
{If DataDirBox.Text = CfgRec.Dir_Cur then exit;}
DrawList;
end;

procedure TMerge.FormCreate(Sender: TObject);
begin
{DataDirBox.Text := CfgRec.Dir_Cur;}
DrawList;
end;

procedure TMerge.FormPaint(Sender: TObject);
begin
{If DataDirBox.Text <> CfgRec.Dir_Cur then DrawList;}
end;

procedure TMerge.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;


end.
