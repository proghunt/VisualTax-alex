unit VirtualUI_Mediator;
{$I VirtualUI.inc}
interface

procedure DownloadFiles(AFiles: TArray<String>; AZipFileName: String = 'Files.zip'); //20190123 Igor
procedure DownloadFile(const LocalFilename: WideString; const RemoteFilename: WideString);
function UploadFile(const ServerDirectory: WideString; AClearDirectoryBeforeUpload: Boolean): TArray<String>; //20181130 Igor
procedure VUIPrintPDF(const AFileName: WideString);
function UploadSetupExe(ServerDirectory, SetupExe: String): boolean; //20190205 Igor

implementation

uses
{$IFDEF UseVirtualUI}
  VirtualUI_SDK,
{$ENDIF}
  Vcl.Dialogs, System.IOUtils, System.SysUtils, Winapi.Windows, Winapi.SHFolder, System.Types,
  System.Zip, //20190123 Igor
  Vcl.Controls; //20181130 Igor

procedure DownloadFiles(AFiles: TArray<String>; AZipFileName: String); //20190123 Igor
var Z: TZipFile;
    I: Integer;
begin
  if Length(AFiles) = 0 then
    ShowMessage('File list is empty')
  else if (Length(AFiles) = 1) and not SameText(ExtractFileExt(AFiles[0]), '') then
  begin
    DownloadFile(AFiles[0], ExtractFileName(AFiles[0]))
  end
  else
  begin
    Z := TZipFile.Create;
    try
      if Length(AFiles) = 1 then
        AZipFileName := ExtractFileName(AFiles[0]) + '.zip'; //20190212 Igor
      if SameText(ExtractFilePath(AZipFileName), '') then
        AZipFileName := TPath.Combine(ExtractFilePath(AFiles[0]), AZipFileName);
      if FileExists(AZipFileName) then
        DeleteFile(PWideChar(AZipFileName));
      Z.Open(AZipFileName, zmWrite);
      for I := 0 to Length(AFiles) - 1 do
        Z.Add(AFiles[I]);
      Z.Close;
    finally
      FreeAndNil(Z);
    end;
    DownloadFile(AZipFileName, ExtractFileName(AZipFileName));
  end;
end;

procedure DownloadFile(const LocalFilename: WideString; const RemoteFilename: WideString);
begin
{$IFDEF UseVirtualUI}
  VirtualUI.DownloadFile(LocalFilename, RemoteFilename);
{$ENDIF}
end;

{$IFDEF UseVirtualUI}
type
  TDummyObject = class
    FBuffer: WideString;
  public
    constructor Create;
    procedure GetDirectory(Sender: TObject; var Directory: string; var Handled: Boolean);
    procedure DeleteAfterDownloadEnd(Sender: TObject; const filename: string);
    property Buffer: WideString read FBuffer write FBuffer;
  end;

{ TDummyObject }

function GetCommonDocumentPath: string;
var
  LStr: array[0 .. MAX_PATH] of Char;
begin
  SetLastError(ERROR_SUCCESS);
  if SHGetFolderPath(0, CSIDL_COMMON_APPDATA, 0, 0, @LStr) = S_OK then
    Result := TPath.Combine(LStr, 'VirtualUIShared' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName)
  else
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

constructor TDummyObject.Create;
begin
  Inherited Create;
  FBuffer := GetCommonDocumentPath;
end;

procedure TDummyObject.GetDirectory(Sender: TObject; var Directory: string;
  var Handled: Boolean);
begin
  if not ForceDirectories(FBuffer) then
    raise Exception.Create(SysErrorMessage(GetLastError));
  Directory := FBuffer;
  Handled := True;
end;

procedure TDummyObject.DeleteAfterDownloadEnd(Sender: TObject; const filename: string);
begin
  VirtualUI.OnDownloadEnd := nil;
  TDirectory.Delete(ExtractFileDir(Buffer), True);
  Self.Free;
end;

{$ENDIF}

function UploadSetupExe(ServerDirectory, SetupExe: String): boolean; //20190205 Igor 
{$IFDEF UseVirtualUI}
var
  O: TDummyObject;
  FDialog: TOpenDialog;
  A: TStringDynArray;
  S: string;
{$ENDIF}
begin
  Result := false;
{$IFDEF UseVirtualUI}
  O := TDummyObject.Create;
  try
    FDialog := TOpenDialog.Create(nil);
    try
      FDialog.Name := 'dlgOpen';
      FDialog.Options := [ofHideReadOnly, ofEnableSizing];
      FDialog.Filename := SetupExe;
      FDialog.Filter := SetupExe + '|' + SetupExe + '|All files (*.*)|*.*';
      VirtualUI.OnGetUploadDir := O.GetDirectory;
      if FDialog.Execute then
      begin
        try
          A := TDirectory.GetFiles(O.Buffer);
          for S in A do
          begin
            if FileExists(ChangeFilePath(S, ServerDirectory)) then
              DeleteFile(PChar(ChangeFilePath(S, ServerDirectory)));
            TFile.Move(S, ChangeFilePath(S, ServerDirectory));
            if SameText(ExtractFileName(S), SetupExe) then
              Result := true;
          end;
        finally
          TDirectory.Delete(O.Buffer, True);
        end;
      end;
    finally
      FDialog.Free;
    end;
  finally
    VirtualUI.OnGetUploadDir := nil;
    O.Free;
  end;
{$ENDIF}
end;

function UploadFile(const ServerDirectory: WideString; AClearDirectoryBeforeUpload: Boolean): TArray<String>; //20181130 Igor
{$IFDEF UseVirtualUI}
var
  O: TDummyObject;
  dlgOpenLastYear: TOpenDialog;
  A: TStringDynArray;
  S: string;
  Z: TZipFile; //20190123 Igor
  HasAnswer, Answer: boolean; //20190214 Igor 
{$ENDIF}
begin
  SetLength(Result, 0); //20181130 Igor
{$IFDEF UseVirtualUI}
  //20190214 Igor >>>
  HasAnswer := false;
  Answer := false;
  //20190214 Igor <<<
  O := TDummyObject.Create;
  try
    dlgOpenLastYear := TOpenDialog.Create(nil);
    try
      dlgOpenLastYear.Name := 'dlgOpen';
      dlgOpenLastYear.Options := [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing];
      VirtualUI.OnGetUploadDir := O.GetDirectory;
      if dlgOpenLastYear.Execute then
      begin
        try
          if not ForceDirectories(ServerDirectory) then
            raise Exception.Create('Can not create destination folder!');
          if AClearDirectoryBeforeUpload and
             not TDirectory.IsEmpty(ServerDirectory) then
          begin
            A := TDirectory.GetFiles(ServerDirectory);
            for S in A do
            begin
              try
                TFile.Delete(S);
              except
              end;
            end;
          end;
          A := TDirectory.GetFiles(O.Buffer);
          //20190123 Igor >>>
          // unzip all files
          for S in A do
          begin
            if SameText(ExtractFileExt(S), '.zip') then
            begin
              try
                Z := TZipFile.Create;
                try
                  Z.Open(S, zmRead);
                  Z.ExtractAll(O.Buffer);
                  Z.Close;
                finally
                  Z.Free;
                end;
                DeleteFile(PChar(S));
              except on E: Exception do
                ShowMessage('Error occured during extracting files from '+ ExtractFileName(S) +
                            #13#10 + #13#10 + E.Message);
              end;
            end;
          end;
          A := TDirectory.GetFiles(O.Buffer);
          //20190123 Igor <<<
          //20181130 Igor >>>
          for S in A do
          begin
            if FileExists(ChangeFilePath(S, ServerDirectory)) then
            begin
              //20190214 Igor >>>
              if not HasAnswer then
              begin
                HasAnswer := true;
                Answer := MessageDlg('The file '+ ExtractFileName(S) +' already exists in the remote dir. Overwrite it (and all next existing files)?',
                            mtConfirmation, [mbYes, mbNo], 0) = mrYes;
              end;
              if not Answer then continue;
              //20190214 Igor <<<
              DeleteFile(PChar(ChangeFilePath(S, ServerDirectory)));
            end;
            SetLength(Result, Length(Result) + 1);
            Result[Length(Result) - 1] := ExtractFileName(S);
            TFile.Move(S, ChangeFilePath(S, ServerDirectory));
          end;
          //20181130 Igor <<<
        finally
          TDirectory.Delete(O.Buffer, True);
        end;
      end;
    finally
      dlgOpenLastYear.Free;
    end;
  finally
    VirtualUI.OnGetUploadDir := nil;
    O.Free;
  end;
{$ENDIF}
end;

procedure VUIPrintPDF(const AFileName: WideString);
{$IFDEF UseVirtualUI}
var
  tmpPath: string;
  O: TDummyObject;
{$ENDIF}
begin
{$IFDEF UseVirtualUI}
  tmpPath := GetCommonDocumentPath;
  if not ForceDirectories(tmpPath) then
    raise Exception.Create(SysErrorMessage(GetLastError));
  TFile.Copy(AFileName, ChangeFilePath(AFileName, tmpPath));
  O := TDummyObject.Create;
  O.Buffer := ChangeFilePath(AFileName, tmpPath);
  VirtualUI.OnDownloadEnd := O.DeleteAfterDownloadEnd;
  VirtualUI.DownloadFile(O.Buffer, ExtractFileName(O.Buffer), 'application/pdf');
{$ENDIF}
end;

end.
