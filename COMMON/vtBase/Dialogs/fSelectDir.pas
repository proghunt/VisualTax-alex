unit fSelectDir;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM OFF}, ExtCtrls, Buttons,//20170811 Igor
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart;

type
  TSelectDir = class(TForm)
    Panel2: TPanel;
    Label5: TLabel;
    DirLabel: TLabel;
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
  private

  public
    SelectedDir: string;
  end;

implementation

{$R *.DFM}

procedure TSelectDir.CancelBtnClick(Sender: TObject);
begin
  SelectedDir := '';
  ModalResult := mrCancel; // Close;
end;

procedure TSelectDir.FormCreate(Sender: TObject);
begin
  RefreshLists;
end;

procedure TSelectDir.RefreshLists;
begin
  FilterComboBox1.Filter := 'All files (*)|*.*';
  FileListBox1.Mask := '*.*';
  FileListBox1.Directory := DirectoryListBox1.Directory;
  DriveComboBox1.DirList := DirectoryListBox1;
  DirectoryListBox1.FileList := FileListBox1;
  DirectoryListBox1.DirLabel := DirLabel;
  FilterComboBox1.FileList := FileListBox1;
  FileListBox1.ItemIndex := 0;
end;

procedure TSelectDir.OKBtnClick(Sender: TObject);
begin
  SelectedDir := DirectoryListBox1.Directory;
  ModalResult := mrOk; // Close;
end;

end.

