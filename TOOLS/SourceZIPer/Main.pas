unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, System.strUtils, IniFiles,
  Vcl.ImgList, Masks, Winapi.ShellAPI;

type
  TfrmMain = class(TForm)
    TreeView: TTreeView;
    Panel1: TPanel;
    RootPath: TEdit;
    Label1: TLabel;
    lastZipDate: TDateTimePicker;
    Label2: TLabel;
    LastZipTime: TDateTimePicker;
    Label3: TLabel;
    Filter: TEdit;
    Splitter1: TSplitter;
    toZip: TMemo;
    ImageList1: TImageList;
    btnZip: TButton;
    edtDestination: TEdit;
    Label4: TLabel;
    lblHavetext: TLabel;
    edtHaveText: TEdit;
    chbMakeSubfolder: TCheckBox;
    edSubfolderName: TEdit;
    chbAddDateTimeToName: TCheckBox;
    chbMakeZip: TCheckBox;
    Label5: TLabel;
    edZipExecutor: TEdit;
    edZipParams: TEdit;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RootPathChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnZipClick(Sender: TObject);
    procedure RootPathExit(Sender: TObject);
  private
    { Private declarations }
    IsZipped: Boolean;
    procedure ReloadTree;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure WaitUntilSignaled(Handle: THandle; ProcessMessages: Boolean);
var
  retval: DWORD;
begin
  if ProcessMessages then
  begin
    Application.ProcessMessages;//in case there are messages already in the queue
    while True do
    begin
      retval := MsgWaitForMultipleObjects(1, Handle, False, INFINITE, QS_ALLEVENTS);
      case retval of
        WAIT_OBJECT_0,WAIT_ABANDONED_0:
          break;
        WAIT_OBJECT_0+1:
          Application.ProcessMessages;
        WAIT_FAILED:
          RaiseLastOSError;
      end;
    end;
  end
  else
  begin
    Win32Check(WaitForSingleObject(Handle, INFINITE) <> WAIT_FAILED);
  end;
end;

procedure ExecuteProcess(const ExecutablePath: string; const Arguments: string;
  const CurrentDirectory: string; const Wait: Boolean; const CreationFlags: DWORD);
var
  si: TStartupInfo;
  pi: TProcessInformation;
  MyCurrentDirectory: PChar;
begin
  ZeroMemory(@si, SizeOf(si));
  si.cb := SizeOf(si);

  if CurrentDirectory <> '' then
  begin
    MyCurrentDirectory := PChar(CurrentDirectory);
  end
  else
  begin
    MyCurrentDirectory := nil;
  end;

  Win32Check(CreateProcess(
    nil,
    PChar('"' + ExecutablePath + '" ' + Arguments),
    nil,
    nil,
    False,
    CreationFlags,
    nil,
    MyCurrentDirectory,
    si,
    pi));
  try
    if Wait then
    begin
      WaitUntilSignaled(pi.hProcess, True);
    end;
  finally
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
  end;
end;

procedure TfrmMain.btnZipClick(Sender: TObject);
var
  I: Integer;
  s, Dst: String;
begin
  Dst := edtDestination.text;
  if chbMakeSubfolder.Checked then
  begin
    Dst := Dst + '\';
    if Trim(edSubfolderName.text) <> '' then
      Dst := Dst + Trim(edSubfolderName.text);
    if chbAddDateTimeToName.Checked then
      Dst := Dst + '_' + FormatDateTime('YYYYMMDD_hhnn', Now);
  end;

  for I := 0 to toZip.Lines.Count - 1 do
  Begin
    s := toZip.Lines[I];
    s := ReplaceText(s, RootPath.text, Dst);
    if not ForceDirectories(ExtractFileDir(s)) then
    Begin
      ShowMessage('Can''t create directory ' + ExtractFileDir(s) + '!');
      exit;
    End;
    if not CopyFile(PWideChar(toZip.Lines[I]), PWideChar(s), false) then
    Begin
      ShowMessage('Can''t copy file ' + s + '!');
    End;
  End;

  if chbMakeZip.Checked and (edZipExecutor.Text <> '') then
  begin
    ExecuteProcess(
      edZipExecutor.Text,
      edZipParams.Text +
      ' "' + ExcludeTrailingPathDelimiter(Dst) + '.zip"'+
      ' "' + ExcludeTrailingPathDelimiter(Dst) + '"',
      '',
      True,
      0);
  end;
  IsZipped := True;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.exeName) + 'setup.ini');
  try
    ini.WriteString('Main', 'RootPath', RootPath.text);
    if IsZipped then
      ini.WriteDateTime('Main', 'LastZip', Now);
    ini.WriteString('Main', 'Filter', Filter.text);
    ini.WriteString('Main', 'Destination', edtDestination.text);
    ini.WriteString('Main', 'HaveText', edtHaveText.text);
    ini.WriteBool('Main', 'MakeSubfolder', chbMakeSubfolder.Checked);
    ini.WriteString('Main', 'SubfolderName', edSubfolderName.text);
    ini.WriteBool('Main', 'AddDateTime', chbAddDateTimeToName.Checked);
    ini.WriteBool('Main', 'MakeZip', chbMakeZip.Checked);
    ini.WriteString('Main', 'ZipExecutor', edZipExecutor.Text);
    ini.WriteString('Main', 'ZipParams', edZipParams.Text);
  finally
    ini.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  s: String;
  ini: TIniFile;
begin
  IsZipped := false;
  ini := TIniFile.Create(ExtractFilePath(Application.exeName) + 'setup.ini');
  try
    s := ini.ReadString('Main', 'RootPath', '');
    if s = '' then
    Begin
      s := ExtractFileDir(Application.exeName);
      s := ReverseString(s);
      Delete(s, 1, pos('\', s));
      s := ReverseString(s);
    End;
    RootPath.text := s;

    lastZipDate.DateTime := ini.ReadDateTime('Main', 'LastZip', Now);
    LastZipTime.DateTime := ini.ReadDateTime('Main', 'LastZip', Now);

    Filter.text := ini.ReadString('Main', 'Filter',
      '*.pas;*.dfm;*.dpr;*.dproj;*.res;*.dpk;*.groupproj;*.ico');
    edtDestination.text := ini.ReadString('Main', 'Destination',
      edtDestination.text);
    edtHaveText.text := ini.ReadString('Main', 'HaveText', '');
    chbMakeSubfolder.Checked := ini.ReadBool('Main', 'MakeSubfolder', True);
    edSubfolderName.text := ini.ReadString('Main', 'SubfolderName', 'Source');
    chbAddDateTimeToName.Checked := ini.ReadBool('Main', 'AddDateTime', True);
    chbMakeZip.Checked := ini.ReadBool('Main', 'MakeZip', True);
    edZipExecutor.Text := ini.ReadString('Main', 'ZipExecutor', 'C:\Program Files\7-Zip\7z.exe');
    edZipParams.Text := ini.ReadString('Main', 'ZipParams', 'a -tzip -mx5 -r0');
  finally
    ini.Free;
  end;
  ReloadTree;
end;

procedure FindFiles(StartFolder: String; Mask: TStrings; ATreeNodes: TTreeNodes;
  AParentNode: TTreeNode; ADateChange: TDateTime; AHaveText: string;
  AList: TStrings; ScanSubFolders: Boolean = True);
var
  SearchRec: TSearchRec;
  FindResult: Integer;
  N: TTreeNode;
  idx: Integer;
  function isMatchesMask(Name: String; Mask: TStrings): Boolean;
  var
    I: Integer;
  Begin
    if Mask.text = '' then
    Begin
      result := True;
    End
    else
    Begin
      result := false;
      for I := 0 to Mask.Count - 1 do
      Begin
        result := MatchesMask(Name, Mask[I]);
        if result then
          break;
      End;
    End;
  End;

  function FileHaveText(AName: String): Boolean;
  var
    SL: TStringList;
  begin
    if AHaveText = '' then
      exit(True);
    if SameText(ExtractFileExt(AName), '.pas') then
    begin
      SL := TStringList.Create;
      try
        SL.LoadFromFile(StartFolder + AName);
        result := pos(AHaveText, SL.text) > 0;
      finally
        SL.Free;
      end;
    end
    else
      result := false;
  end;

begin
  StartFolder := IncludeTrailingPathDelimiter(StartFolder);
  FindResult := FindFirst(StartFolder + '*.*', faAnyFile, SearchRec);
  try
    while FindResult = 0 do
      with SearchRec do
      begin
        if (Attr and faDirectory) <> 0 then
        begin
          if ScanSubFolders and (Name <> '.') and (Name <> '..') then
          Begin
            N := ATreeNodes.AddChild(AParentNode, Name);
            N.ImageIndex := 2;
            N.SelectedIndex := 2;
            FindFiles(StartFolder + Name, Mask, ATreeNodes, N, ADateChange,
              AHaveText, AList, ScanSubFolders);
          End;
        end
        else
        begin
          if isMatchesMask(Name, Mask) then
          Begin
            if (SearchRec.TimeStamp >= ADateChange) and
              FileHaveText(Name) then
            Begin
              idx := 0;
              AList.Add(StartFolder + Name);
            end
            else
              idx := 1;
            N := ATreeNodes.AddChild(AParentNode, Name);
            N.ImageIndex := idx;
            N.SelectedIndex := idx;
          End;
        end;
        FindResult := FindNext(SearchRec);
      end;
  finally
    FindClose(SearchRec);
  end;
end;

procedure TfrmMain.ReloadTree;
var
  tl: TStringList;
begin
  tl := TStringList.Create;
  toZip.Lines.BeginUpdate;
  TreeView.Items.BeginUpdate;
  try
    tl.Delimiter := ';';
    tl.DelimitedText := Filter.text;
    TreeView.Items.Clear;
    toZip.Clear;
    FindFiles(RootPath.text, tl, TreeView.Items, nil, lastZipDate.DateTime,
      edtHaveText.text, toZip.Lines, True);
  finally
    tl.Free;
    toZip.Lines.EndUpdate;
    TreeView.Items.EndUpdate;
  end;
end;

procedure TfrmMain.RootPathChange(Sender: TObject);
begin
  if Sender = lastZipDate then
  Begin
    if LastZipTime.DateTime <> lastZipDate.DateTime then
      LastZipTime.DateTime := lastZipDate.DateTime;
  End
  else if Sender = LastZipTime then
  Begin
    if lastZipDate.DateTime <> LastZipTime.DateTime then
      lastZipDate.DateTime := LastZipTime.DateTime;
  End
  else if (Sender = RootPath) AND (ActiveControl <> RootPath) then
  Begin
    RootPathExit(Sender);
  End;
  if not Self.Visible then
    exit;
  ReloadTree;
end;

procedure TfrmMain.RootPathExit(Sender: TObject);
begin
  if RootPath.text <> '' then
    if RootPath.text[length(RootPath.text)] = '\' then
      RootPath.text := Copy(RootPath.text, 1, length(RootPath.text) - 1);
end;

end.
