unit T1_2026filevu;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,ShellApi,FileCtrl;

type
  TFileVuT1_2026 = class(TForm)
    Memo1: TMemo;
    CancelBtn: TBitBtn;
    OkBtn: TBitBtn;
    FileListBox1: TFileListBox;
    SaveBtn: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FileVu: TFileVuT1_2026;
  FileName :String;
  
implementation

{$R *.DFM}

uses vtCommon,T1_2026Common,T1_2026Common2,T1_2026Declare,T1_2026TrimStr,
  T1_2026Dfiles,vtTrimStr,vtShared;

procedure TFileVuT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TFileVuT1_2026.OkBtnClick(Sender: TObject);
begin
(*
SomeCaption:= FileListBox1.Items[FileListBox1.ItemIndex];
SomeLabel:=''; //'Used for predictive entry in T5, T3 and Sch. 4';
SomeFile:= FileListBox1.Items[FileListBox1.ItemIndex];

Application.CreateForm(TDFiles,DFiles);
DFiles.ShowModal;
DFiles.Free;
*)

If FileListBox1.ItemIndex >-1 then
 FileName := FileListBox1.Items[FileListBox1.ItemIndex]
else
  FileName := '';
If FileName > '' then
 begin
  Memo1.Clear;
  Memo1.Lines.LoadFromFile(FileListBox1.Directory+'\'+FileName);
 end;

end;

procedure TFileVuT1_2026.FormCreate(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
FileListBox1.Directory :=Appdir;
FileListBox1.Mask := '*.LTR;*.D;*.TPL';
FileListBox1.ItemIndex :=0;
FileName := FileListBox1.Items[FileListBox1.ItemIndex];
Screen.Cursor := crDefault;
end;


procedure TFileVuT1_2026.FileListBox1DblClick(Sender: TObject);
begin
OkBtnClick(Sender);
Invalidate;
end;

procedure TFileVuT1_2026.SaveBtnClick(Sender: TObject);
begin
 Memo1.Lines.SaveToFile(FileListBox1.Directory+'\'+FileName);
 ShowMessage('File Saved');
end;

procedure TFileVuT1_2026.FormPaint(Sender: TObject);
begin
If Memo1.Lines.Count >0 then
 SaveBtn.Enabled := True
else
 SaveBtn.Enabled := False;
end;

end.
