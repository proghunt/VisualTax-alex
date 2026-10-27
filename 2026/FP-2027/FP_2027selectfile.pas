unit FP_2027selectfile;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  FileCtrl,ExtCtrls,VClTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, Buttons,FP_2027Declare;

type
  TSelectFileFP_2012 = class(TForm)
    Panel2: TPanel;
    Label5: TLabel;
    SelectedLbl: TLabel;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    MonitorPlanBtn: TChart;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FileListBox1: TFileListBox;
    FilterComboBox1: TFilterComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure RefreshLists;
    procedure FileListBox1Click(Sender: TObject);
    Function GetSelected:String;
    procedure FileListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectFile: TSelectFileFP_2012;
implementation

{$R *.DFM}

procedure TSelectFileFP_2012.CancelBtnClick(Sender: TObject);
begin
SelectedString:='';
Close;
end;

procedure TSelectFileFP_2012.FormCreate(Sender: TObject);
begin
  SelectedString:='';
  RefreshLists;
end;

procedure TSelectFileFP_2012.RefreshLists;
begin
  FilterComboBox1.Filter := 'All files (*)|*.*';
  FileListBox1.Mask := '*.*';
  FileListBox1.Directory := DirectoryListBox1.Directory;
  DriveComboBox1.DirList := DirectoryListBox1;
  DirectoryListBox1.FileList := FileListBox1;
  DirectoryListBox1.DirLabel := SelectedLbl;
  FilterComboBox1.FileList := FileListBox1;
  FileListBox1.ItemIndex :=0;
end;


procedure TSelectFileFP_2012.OKBtnClick(Sender: TObject);
Var i:Integer;
begin
 SelectedString:=GetSelected;
 Close;
end;

procedure TSelectFileFP_2012.FileListBox1Click(Sender: TObject);
begin
 SelectedString:=GetSelected;
 SelectedLbl.Caption:=SelectedString;
end;

Function TSelectFileFP_2012.GetSelected:String;
Var i:Integer;
begin
 Result:='';
 for i := 0 to (FileListBox1.Items.Count - 1) do
 begin
   if FileListBox1.Selected[i] then
     result:=
      DirectoryListBox1.Directory+'\'+FileListBox1.Items.Strings[I];
 end;


end;

procedure TSelectFileFP_2012.FileListBox1DblClick(Sender: TObject);
begin
OKBtnClick(Sender);
end;

end.
