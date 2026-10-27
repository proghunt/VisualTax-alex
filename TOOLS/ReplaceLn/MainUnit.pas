unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls, ShellApi, Registry, //20191121 Igor
  {$WARN UNIT_PLATFORM OFF}
  FileCtrl,
  {$WARN UNIT_PLATFORM ON}
  System.IOUtils, System.Types, Vcl.Samples.Spin, IniFiles, System.UITypes,
  Vcl.ComCtrls;

type TLn = record
  FromValue: string;
  ToValue: string;
end;

type
  TMainForm = class(TForm)
    lbFolder: TLabel;
    pnlTop: TPanel;
    edFolder: TEdit;
    btnSelectFolder: TSpeedButton;
    lbFiles: TLabel;
    edFiles: TEdit;
    meReplace: TMemo;
    pnlBottom: TPanel;
    pnlCenter: TPanel;
    meLog: TMemo;
    btnReplace: TButton;
    btnAddSpace: TButton;
    SpacePos: TSpinEdit;
    cbOnlyFirst: TCheckBox;
    FirstChars: TSpinEdit;
    lbDelimiter: TLabel;
    edDelimiter: TEdit;
    btnReplacePas: TButton;
    btnReplaceD: TButton;
    btnReplaceRtf: TButton;
    btnReplaceDfm: TButton;
    cbDeveloperMode: TCheckBox;
    cbReplaceSpaceBeforeReplace: TCheckBox;
    pbProgress: TProgressBar;
    cbRevert: TCheckBox;//20191112 Igor
    //20191115 Igor >>>
    btnBinaryToText: TButton;
    btnTextToBinary: TButton;
    GroupBox1: TGroupBox;
    //20191115 Igor <<<
    //20191121 Igor >>>
    cbOneByOne: TCheckBox;
    Label1: TLabel;
    edDelphi5: TEdit;
    btnOpenDelphi5: TSpeedButton;
    OpenDelphi5Dialog: TOpenDialog;
    btnFromRegistry: TSpeedButton;
    //20191121 Igor <<<    
    procedure btnSelectFolderClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnAddSpaceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbDeveloperModeClick(Sender: TObject);
    procedure btnReplacePasClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnReplaceDClick(Sender: TObject);
    procedure btnReplaceRtfClick(Sender: TObject);
    procedure btnReplaceDfmClick(Sender: TObject);
    procedure btnBinaryToTextClick(Sender: TObject); //20191115 Igor
    //20191121 Igor >>>
    procedure btnOpenDelphi5Click(Sender: TObject);
    procedure btnFromRegistryClick(Sender: TObject);
    //20191121 Igor <<<
  private
    { Private declarations }
    FLn: TArray<TLn>;
    function GetIniFile: TIniFile;
    procedure LoadSettings;
    procedure SaveSettings;
    function GetDelphi5Path: string; //20191121 Igor
  public
    { Public declarations }
    procedure LoadLn;
    function Replace(AFile: string): boolean;
    function AddSpace(AFile: string; APos: integer; AValue: string = ' '): boolean;
    function ReplaceFirst(AFile: string; AFirst: integer): boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

// returns true if dfm file is in a binary format
function IsDFMBinary(FileName: string): Boolean;
var
  F: TFileStream;
  B: Byte;
begin
  B := 0;
  F := TFileStream.Create(FileName, fmOpenRead);
  try
    F.Read( B, 1 );
    Result := B = $FF;
  finally
    F.Free;
  end;
end;

// convert a binary dfm file to a text dfm file
function Dfm2Txt(Src, Dest: string): boolean;
var
  SrcS, DestS: TFileStream;
begin
  if Src = Dest then
  begin
    MessageDlg('Error converting dfm file to binary!. '
      + 'The source file and destination file names are the same.',
      mtError, [mbOK], 0);
    result := False;
    exit;
  end;
  SrcS := TFileStream.Create(Src, fmOpenRead);
  DestS := TFileStream.Create(Dest, fmCreate);
  try
    ObjectResourceToText(SrcS, DestS);
    if FileExists(Src) and FileExists(Dest) then
      Result := True
    else
      Result := False;
  finally
    SrcS.Free;
    DestS.Free;
  end;
end;

// convert a text DFM file to a binary DFM file
function Txt2DFM(Src, Dest: string): boolean;
var
  SrcS, DestS: TFileStream;
begin
  if Src = Dest then
  begin
    MessageDlg('Error converting dfm file to binary!. '
      + 'The source file and destination file names are the same.',
      mtError, [mbOK], 0);
    Result := False;
    exit;
  end;
  SrcS := TFileStream.Create(Src, fmOpenRead);
  DestS := TFileStream.Create(Dest, fmCreate);
  try
    ObjectTextToResource(SrcS, DestS);
    if FileExists(Src) and FileExists(Dest) then
      Result := True
    else
      Result := False;
  finally
    SrcS.Free;
    DestS.Free;
  end;
end;

function TMainForm.AddSpace(AFile: string; APos: integer;
  AValue: string): boolean;
var I: integer;
    cStr: string;
    SourceFile: TStringList;
begin
  Result := false;
  SourceFile := TStringList.Create;
  try
    SourceFile.LoadFromFile(AFile);
    for I := 0 to SourceFile.Count - 1 do
    begin
      cStr := SourceFile.Strings[I];
      if Trim(cStr).StartsWith('//') then continue;
      SourceFile.Strings[I] := Copy(cStr, 1, APos) + AValue + Copy(cStr, APos + 1, Length(cStr));
      Result := true;
    end;
    if Result then
      SourceFile.SaveToFile(AFile);
  finally
    SourceFile.Free;
  end;
end;

procedure TMainForm.btnReplaceClick(Sender: TObject); //20191115 Igor
var FileList: TStringDynArray;
    I, Count: integer;
begin
  Screen.Cursor := crHourGlass;
  try
    FileList := TDirectory.GetFiles(edFolder.Text, edFiles.Text);
    Count := 0;
    pbProgress.Position := 0;
    pbProgress.Min := 0;
    pbProgress.Max := Length(FileList) - 1;
    Repaint;
    for I := 0 to Length(FileList) - 1 do
    begin
      try
        if SameText(ExtractFileName(FileList[I]), 'OldToNewLN.d') then
        begin
          meReplace.Lines.SaveToFile(FileList[I]);
          meLog.Lines.Add('OldToNewLN.d was updated');
          inc(Count);
        end
        else if not cbOnlyFirst.Checked then
        begin
          if Replace(FileList[I]) then
          begin
            meLog.Lines.Add(FileList[I] + ' was processed');
            inc(Count);
          end;
        end
        else
        begin
          if ReplaceFirst(FileList[I], FirstChars.Value) then
          begin
            meLog.Lines.Add(FileList[I] + ' was processed');
            inc(Count);
          end;
        end;
      except on E: Exception do
        meLog.Lines.Add(FileList[I] + ' Error occured: '+ E.Message);
      end;
      pbProgress.Position := I;
      Repaint;
    end;
    if Count = 0 then
      meLog.Lines.Add('There are no files that contain search values')
    else
      meLog.Lines.Add('Processed files: '+ IntToStr(Count));
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.btnReplaceDClick(Sender: TObject);
var I: integer;
begin
  meLog.Clear; //20191115 Igor
  // first 5 chars
  edFiles.Text := 'EFLINE.D;eflineT2203.d';
  edDelimiter.Text := '=';
  cbOnlyFirst.Checked := true;
  FirstChars.Value := 5;
  cbReplaceSpaceBeforeReplace.Checked := false;
  meReplace.Clear;
  meReplace.Lines.BeginUpdate;
  try
    for I := 0 to Length(FLn) - 1 do
      meReplace.Lines.Add(FLn[I].FromValue +'='+ FLn[I].ToValue);
  finally
    meReplace.Lines.EndUpdate;
  end;
  btnReplaceClick(nil);
  // ~Old~~ replace
  edFiles.Text := 'comp2yr.d;t1tls.d';
  edDelimiter.Text := '=';
  cbOnlyFirst.Checked := false;
  cbReplaceSpaceBeforeReplace.Checked := true;
  meReplace.Clear;
  meReplace.Lines.BeginUpdate;
  try
    for I := 0 to Length(FLn) - 1 do
      meReplace.Lines.Add('~'+FLn[I].FromValue +'~~=~'+ FLn[I].ToValue);
  finally
    meReplace.Lines.EndUpdate;
  end;
  btnReplaceClick(nil);
  // ~Old replace
  edFiles.Text := 'taxsum.d;yrsum.d';
  edDelimiter.Text := '=';
  cbOnlyFirst.Checked := false;
  cbReplaceSpaceBeforeReplace.Checked := true;
  meReplace.Clear;
  meReplace.Lines.BeginUpdate;
  try
    for I := 0 to Length(FLn) - 1 do
      meReplace.Lines.Add('~'+FLn[I].FromValue +'=~'+ FLn[I].ToValue);
  finally
    meReplace.Lines.EndUpdate;
  end;
  btnReplaceClick(nil);
  // OldToNewLN.d
  edFiles.Text := 'OldToNewLN.d';
  edDelimiter.Text := '=';
  cbOnlyFirst.Checked := false;
  cbReplaceSpaceBeforeReplace.Checked := true;
  meReplace.Clear;
  meReplace.Lines.BeginUpdate;
  try
    for I := 0 to Length(FLn) - 1 do
      meReplace.Lines.Add(FLn[I].FromValue +' '+ FLn[I].ToValue);
  finally
    meReplace.Lines.EndUpdate;
  end;
  btnReplaceClick(nil);
end;

procedure TMainForm.btnReplaceDfmClick(Sender: TObject); //20191121 Igor
var I, Count: integer;
    FileList: TStringDynArray;
    bReplaced: boolean;
    cPasFile: string;

    procedure PrepareCaption;
    var I: integer;
    begin
      // Caption = 'Value'
      edDelimiter.Text := '#';
      cbOnlyFirst.Checked := false;
      cbReplaceSpaceBeforeReplace.Checked := false;
      meReplace.Clear;
      meReplace.Lines.BeginUpdate;
      try
        for I := 0 to Length(FLn) - 1 do
          meReplace.Lines.Add('Caption = '''+ FLn[I].FromValue +'''#Caption = '''+ FLn[I].ToValue + '''');
      finally
        meReplace.Lines.EndUpdate;
      end;
    end;

    procedure PrepareLine;
    var I: integer;
    begin
      // Line Value
      edDelimiter.Text := '=';
      cbOnlyFirst.Checked := false;
      cbReplaceSpaceBeforeReplace.Checked := false;
      meReplace.Clear;
      meReplace.Lines.BeginUpdate;
      try
        for I := 0 to Length(FLn) - 1 do
          meReplace.Lines.Add('Line '+ FLn[I].FromValue +'=Line '+ FLn[I].ToValue);
      finally
        meReplace.Lines.EndUpdate;
      end;
    end;

begin
  meLog.Clear; //20191115 Igor
  edFiles.Text := '*.dfm';
  if cbOneByOne.Checked then
  begin
    Screen.Cursor := crHourGlass;
    try
      FileList := TDirectory.GetFiles(edFolder.Text, edFiles.Text);
      pbProgress.Position := 0;
      pbProgress.Min := 0;
      pbProgress.Max := Length(FileList) - 1;
      Repaint;
      Count := 0;
      for I := 0 to Length(FileList) - 1 do
      begin
        try
          bReplaced := false;
          PrepareCaption;
          if Replace(FileList[I]) then
            bReplaced := true;
          PrepareLine;
          if Replace(FileList[I]) then
            bReplaced := true;
          if bReplaced then
          begin
            meLog.Lines.Add(FileList[I] + ' was processed');
            inc(Count);
            cPasFile := ChangeFileExt(FileList[I], '.pas');
            if String(edDelphi5.Text).IsEmpty then
              ShellExecute(Handle, 'open', Pchar(cPasFile), '', '', SW_SHOWNORMAL)
            else
              ShellExecute(Handle, 'open', Pchar(edDelphi5.Text), Pchar(cPasFile), '', SW_SHOWNORMAL);
            Screen.Cursor := crDefault;
            if MessageDlg(FileList[I] + ' was processed. Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0, mbYes) <> mrYes then
              Exit;
            Screen.Cursor := crHourGlass;
          end;
        except on E: Exception do
          meLog.Lines.Add(FileList[I] + ' Error occured: '+ E.Message);
        end;
        pbProgress.Position := I;
        Repaint;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
    if Count = 0 then
      meLog.Lines.Add('There are no files that contain search values')
    else
      meLog.Lines.Add('Processed files: '+ IntToStr(Count));
  end
  else
  begin
    PrepareCaption;
    btnReplaceClick(nil);
    PrepareLine;
    btnReplaceClick(nil);
  end;
end;

procedure TMainForm.btnReplacePasClick(Sender: TObject);
var I: integer;
begin
  meLog.Clear; //20191115 Igor
  edFiles.Text := '*.pas';
  edDelimiter.Text := '=';
  cbOnlyFirst.Checked := false;
  cbReplaceSpaceBeforeReplace.Checked := false;
  meReplace.Clear;
  meReplace.Lines.BeginUpdate;
  try
    for I := 0 to Length(FLn) - 1 do
      meReplace.Lines.Add('Ln['+ FLn[I].FromValue +']=Lnn['+ FLn[I].ToValue + ']');
  finally
    meReplace.Lines.EndUpdate;
  end;
  btnReplaceClick(nil);
end;

procedure TMainForm.btnReplaceRtfClick(Sender: TObject);
var I: integer;
begin
  meLog.Clear; //20191115 Igor
  edFiles.Text := '*.rtf';
  edDelimiter.Text := '=';
  cbOnlyFirst.Checked := false;
  cbReplaceSpaceBeforeReplace.Checked := false;
  meReplace.Clear;
  meReplace.Lines.BeginUpdate;
  try
    for I := 0 to Length(FLn) - 1 do
      meReplace.Lines.Add('Line_'+ FLn[I].FromValue +'=Line_'+ FLn[I].ToValue);
  finally
    meReplace.Lines.EndUpdate;
  end;
  btnReplaceClick(nil);
end;

procedure TMainForm.btnSelectFolderClick(Sender: TObject);
var cFolder: string;
begin
  cFolder := edFolder.Text;
  if not SelectDirectory(cFolder, [], 0) then Exit;
  edFolder.Text := cFolder;
end;

procedure TMainForm.cbDeveloperModeClick(Sender: TObject);
begin
  btnAddSpace.Enabled := cbDeveloperMode.Checked;
  SpacePos.Enabled := cbDeveloperMode.Checked;
  cbOnlyFirst.Enabled := cbDeveloperMode.Checked;
  FirstChars.Enabled := cbDeveloperMode.Checked;
  btnReplace.Enabled := cbDeveloperMode.Checked;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  LoadSettings;
  LoadLn;
end;

function TMainForm.GetDelphi5Path: string; //20191121 Igor
var
  Registry: TRegistry;
begin
  Result := '';
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CLASSES_ROOT;
    if not Registry.OpenKeyReadOnly('\Applications\delphi32.exe\shell\open\command') then Exit;
    Result := Registry.ReadString('');
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  if SameText(Result[1], '"') then
  begin
    Result := Copy(Result, 2, Length(Result));
    Result := Copy(Result, 1, Pos('"', Result) - 1);
  end
  else
    Result := Copy(Result, 1, Pos(' ', Result) - 1);
end;

function TMainForm.GetIniFile: TIniFile;
begin
  Result := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
end;

procedure TMainForm.LoadLn;
var L: TStringList;
    cFile: string;
    A: TArray<string>;
    I: integer;

    procedure AddLn(AFromValue, AToValue: string);
    begin
      if AFromValue.IsEmpty or AToValue.IsEmpty then Exit;
      SetLength(FLn, Length(FLn) + 1);
      FLn[Length(FLn) - 1].FromValue := AFromValue;
      FLn[Length(FLn) - 1].ToValue := AToValue;
    end;

begin
  cFile := TPath.Combine(ExtractFilePath(Application.ExeName), 'Ln.ini');
  if not FileExists(cFile) then
  begin
    ShowMessage('File '+ QuotedStr(cFile) + ' is missing');
    Exit;
  end;
  SetLength(FLn, 0);
  L := TStringList.Create;
  try
    L.LoadFromFile(cFile);
    for I := 0 to L.Count - 1 do
    begin
      A := L.Strings[I].Split(['='],ExcludeEmpty);
      if Length(A) < 2 then continue;
      AddLn(Trim(A[0]), Trim(A[1]));
    end;
  finally
    L.Free;
  end;
end;

procedure TMainForm.LoadSettings;
var FIniFile: TIniFile;
begin
  FIniFile := GetIniFile;
  try
    edFolder.Text := FIniFile.ReadString('Main', 'Folder', edFolder.Text);
    edFiles.Text := FIniFile.ReadString('Main', 'Files', edFiles.Text);
    edDelimiter.Text := FIniFile.ReadString('Main', 'Delimiter', edDelimiter.Text);
    edDelphi5.Text := FIniFile.ReadString('Main', 'Delphi5', edDelphi5.Text); //20191121 Igor
  finally
    FIniFile.Free;
  end;
end;

procedure TMainForm.btnAddSpaceClick(Sender: TObject);
var FileList: TStringDynArray;
    I, Count: integer;
begin
  FileList := TDirectory.GetFiles(edFolder.Text, edFiles.Text);
  meLog.Clear;
  Count := 0;
  for I := 0 to Length(FileList) - 1 do
    if AddSpace(FileList[I], SpacePos.Value) then
    begin
      meLog.Lines.Add(FileList[I] + ' was processed');
      inc(Count);
    end;
  if Count = 0 then
    meLog.Lines.Add('There are no files')
  else
    meLog.Lines.Add('Processed files: '+ IntToStr(Count));
end;

procedure TMainForm.btnBinaryToTextClick(Sender: TObject); //20191115 Igor
var FileList: TStringDynArray;
    I, Count: integer;
    cFile, cTempFile: string;
begin
  meLog.Clear;
  Screen.Cursor := crHourGlass;
  try
    FileList := TDirectory.GetFiles(edFolder.Text, '*.dfm');
    meLog.Clear;
    Count := 0;
    pbProgress.Position := 0;
    pbProgress.Min := 0;
    pbProgress.Max := Length(FileList) - 1;
    Repaint;
    for I := 0 to Length(FileList) - 1 do
    begin
      cFile := FileList[I];
      cTempFile := cFile + '.tempfile';
      if Sender = btnBinaryToText then
      begin
        if IsDFMBinary(cFile) then
        begin
          Dfm2Txt(cFile, cTempFile);
          DeleteFile(cFile);
          RenameFile(cTempFile, cFile);
          meLog.Lines.Add(cFile + ' was converted');
          inc(Count);
        end;
      end
      else if Sender = btnTextToBinary then
      begin
        if not IsDFMBinary(cFile) then
        begin
          Txt2Dfm(cFile, cTempFile);
          DeleteFile(cFile);
          RenameFile(cTempFile, cFile);
          meLog.Lines.Add(cFile + ' was converted');
          inc(Count);
        end;
      end;
      pbProgress.Position := I;
      Repaint;
    end;
    if Count = 0 then
      meLog.Lines.Add('There are no files for conversion')
    else
      meLog.Lines.Add('Processed files: '+ IntToStr(Count));
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.btnFromRegistryClick(Sender: TObject); //20191121 Igor
begin
  edDelphi5.Text := GetDelphi5Path;
end;

procedure TMainForm.btnOpenDelphi5Click(Sender: TObject); //20191121 Igor
begin
  if not OpenDelphi5Dialog.Execute then Exit;
  edDelphi5.Text := OpenDelphi5Dialog.FileName;
end;

function TMainForm.Replace(AFile: string): boolean; //20191112 Igor
var I: integer;
    cFrom, cTo, cSave, cNew, cFileRestore: string;
    SourceFile: TStringList;
    A: TArray<string>;
    bIsBinary, bIsDFM: boolean;

    procedure ReplaceChar(ACharCode: integer; AChar: string); //20191115 Igor
    begin
      SourceFile.Text := SourceFile.Text.Replace('Caption = #'+IntToStr(ACharCode)+'''', 'Caption = '''+ AChar +'');
      SourceFile.Text := SourceFile.Text.Replace('Caption = '+Chr(ACharCode)+'''', 'Caption = '''+ AChar);
      SourceFile.Text := SourceFile.Text.Replace('Caption = #'+IntToStr(ACharCode), 'Caption = '''+ AChar +'''');
      SourceFile.Text := SourceFile.Text.Replace('vtPrefix = #'+IntToStr(ACharCode), 'vtPrefix = '''+ AChar +'''');
      SourceFile.Text := SourceFile.Text.Replace('''#'+IntToStr(ACharCode)+'''', AChar);
      SourceFile.Text := SourceFile.Text.Replace(' #'+IntToStr(ACharCode)+'''', '''' + AChar);
      SourceFile.Text := SourceFile.Text.Replace('#'+IntToStr(ACharCode)+'''', AChar);
      SourceFile.Text := SourceFile.Text.Replace('''#'+IntToStr(ACharCode) + #13, AChar + '''');
      SourceFile.Text := SourceFile.Text.Replace('''#'+IntToStr(ACharCode), AChar);
      SourceFile.Text := SourceFile.Text.Replace('#'+IntToStr(ACharCode), AChar);
    end;
begin
  Result := false;
  bIsBinary := false;
  bIsDFM := false;
  if SameText(ExtractFileExt(AFile), '.dfm') then
  begin
    bIsDFM := true;
    if IsDFMBinary(AFile) then
    begin
      cFileRestore := AFile;
      AFile := AFile + '.tempfile';
      bIsBinary := true;
      Dfm2Txt(cFileRestore, AFile);
    end;
  end;
  SourceFile := TStringList.Create;
  try
    SourceFile.LoadFromFile(AFile);
    if bIsDFM then
    begin
      cSave := SourceFile.Text;
      //20191115 Igor >>>
      ReplaceChar(215, '*');
      ReplaceChar(19, '-');
      ReplaceChar(247, '/');
      ReplaceChar(8211, '-');
      ReplaceChar(8217, '''''');
      ReplaceChar(224, 'a');
      ReplaceChar(231, 'c');
      ReplaceChar(8220, '"');
      ReplaceChar(8221, '"');
      ReplaceChar(8226, '');
      ReplaceChar(229, 'a');
      ReplaceChar(238, 'i');
      ReplaceChar(244, 'o');
      ReplaceChar(246, 'o');
      ReplaceChar(236, 'i');
      ReplaceChar(244, 'o');
      ReplaceChar(232, 'e');
      ReplaceChar(244, 'o');
      ReplaceChar(233, 'e');
      ReplaceChar(234, 'e');
      ReplaceChar(173, '-');
      ReplaceChar(8212, '-');
      //20191121 Igor >>>
      ReplaceChar(1063, '*');
      SourceFile.Text := SourceFile.Text.Replace('Caption = '''' 10%', 'Caption = ''* 10%');
      //20191121 Igor <<<
      //20191115 Igor <<<
      if not SameText(cSave, SourceFile.Text) then
        Result := true;
    end;
    for I := 0 to meReplace.Lines.Count - 1 do
    begin
      A := meReplace.Lines.Strings[I].Split([edDelimiter.Text],ExcludeEmpty);
      if Length(A) < 2 then
      begin
        meLog.Lines.Add('Search and replace values should be split by "'+ edDelimiter.Text +'" char');
        Abort;
      end;
      cFrom := Trim(A[0]);
      cTo := Trim(A[1]);
      if cbReplaceSpaceBeforeReplace.Checked then
        SourceFile.Text := SourceFile.Text.Replace(' ', '~');
      if (SourceFile.Text.Contains(cFrom) and not cbRevert.Checked)
         or
         (SourceFile.Text.Contains(cTo) and cbRevert.Checked) then
      begin
        cSave := SourceFile.Text;
        if cbRevert.Checked then
          cNew := cSave.Replace(cTo, cFrom)
        else
          cNew := cSave.Replace(cTo, cFrom).Replace(cFrom, cTo);
        if not SameText(cSave, cNew) then
        begin
          Result := true;
  //        SourceFile.Text := SourceFile.Text.Replace(cFrom, cTo);
          SourceFile.Text := cNew;
        end;
      end;
      if cbReplaceSpaceBeforeReplace.Checked then
        SourceFile.Text := SourceFile.Text.Replace('~', ' ');
    end;
    if Result then
      SourceFile.SaveToFile(AFile);
  finally
    SourceFile.Free;
    if bIsBinary then
    begin
      Txt2Dfm(AFile, cFileRestore);
      DeleteFile(AFile);
    end;
  end;
end;

function TMainForm.ReplaceFirst(AFile: string; AFirst: integer): boolean;
var I, J: integer;
    cFrom, cTo, cLine: string;
    SourceFile: TStringList;
    A: TArray<string>;
begin
  Result := false;
  SourceFile := TStringList.Create;
  try
    SourceFile.LoadFromFile(AFile);
    for J := 0 to SourceFile.Count - 1 do
      for I := 0 to meReplace.Lines.Count - 1 do
      begin
        A := meReplace.Lines.Strings[I].Split([edDelimiter.Text],ExcludeEmpty);
        if Length(A) < 2 then
        begin
          meLog.Lines.Add('Search and replace values should be split by "'+ edDelimiter.Text +'" char');
          Abort;
        end;
        cFrom := Trim(A[0]);
        cTo := Trim(A[1]);
        cLine := SourceFile.Strings[J];
        if SameText(Trim(Copy(cLine, 1, AFirst)), cFrom) then
        begin
          Result := true;
          SourceFile.Strings[J] := cTo.PadLeft(AFirst) + Copy(cLine, AFirst + 1, Length(cLine));
        end;
      end;
    if Result then
      SourceFile.SaveToFile(AFile + '.test');
  finally
    SourceFile.Free;
  end;
end;

procedure TMainForm.SaveSettings;
var FIniFile: TIniFile;
begin
  FIniFile := GetIniFile;
  try
    FIniFile.WriteString('Main', 'Folder', edFolder.Text);
    FIniFile.WriteString('Main', 'Files', edFiles.Text);
    FIniFile.WriteString('Main', 'Delimiter', edDelimiter.Text);
    FIniFile.WriteString('Main', 'Delphi5', edDelphi5.Text); //20191121 Igor
  finally
    FIniFile.Free;
  end;
end;

end.
