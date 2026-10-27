unit T4T5_2026FILEVU;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,ShellApi,T4T5_2026Common,T4T5_2026Common2,
  T4T5_2026Declare,T4T5_2026TrimStr,
  {$WARN UNIT_PLATFORM OFF}FileCtrl;{$WARN UNIT_PLATFORM ON} //20170612 Igor

type
  TFileVuT4T5_2026 = class(TForm)
    Memo1: TMemo;
    CancelBtn: TBitBtn;
    OkBtn: TBitBtn;
    FileListBox1: TFileListBox;
    SaveBtn: TBitBtn;
    BitBtn1: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Const HelpTopic = 'Edit_supporting_files';
var
  FileVu: TFileVuT4T5_2026;
  FileName :String;
implementation

{$R *.DFM}

procedure TFileVuT4T5_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TFileVuT4T5_2026.OkBtnClick(Sender: TObject);
begin
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

procedure TFileVuT4T5_2026.FormCreate(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
FileListBox1.Directory :=Appdir;
FileListBox1.Mask := '*.LTR;*.D';
FileListBox1.ItemIndex :=0;
FileName := FileListBox1.Items[FileListBox1.ItemIndex];
Screen.Cursor := crDefault;
end;


procedure TFileVuT4T5_2026.FileListBox1DblClick(Sender: TObject);
begin
OkBtnClick(Sender);
Invalidate;
end;

procedure TFileVuT4T5_2026.SaveBtnClick(Sender: TObject);
begin
 Memo1.Lines.SaveToFile(FileListBox1.Directory+'\'+FileName);
 ShowMessage('File Saved');
end;

procedure TFileVuT4T5_2026.FormPaint(Sender: TObject);
begin
If Memo1.Lines.Count >0 then
 SaveBtn.Enabled := True
else
 SaveBtn.Enabled := False;
end;

procedure TFileVuT4T5_2026.BitBtn1Click(Sender: TObject);
begin
ShowHelp('TfHelp',HelpTopic);
end;

end.
