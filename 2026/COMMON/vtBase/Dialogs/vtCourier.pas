Unit vtCourier;

//20201207 Igor a lot of changes in unit

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Printers, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, Vcl.Mask, vteditbox, vtLabel, vtShape, IniFiles, //20201026 Igor
  ShellApi, ClipBrd, ElAES, System.Generics.Collections, System.IOUtils, StrUtils, //20220227 Igor
  IdHashMessageDigest, IdGlobal, vtVirtualTaxOffice, System.UITypes; //20201130 Igor //20210202 Igor

const EncryptedFolder = 'ENCRYPTED';
      //20201028 Igor >>>
      DecryptedFolder = 'DECRYPTED';
      vtCourierDecryptURL = 'https://visualtax.com/Downloads/vtCourier.exe'; //20210202 Igor
      //20201028 Igor <<<

type
  TvtCourier = class(TForm)
    vtShape4: TvtShape;
    vtLabel37: TvtLabel;
    vtLabel1: TvtLabel;
    OpenFilesDialog: TOpenDialog;
    OpenEncryptedDialog: TOpenDialog;
    GroupBox1: TGroupBox;
    CancelBtn: TBitBtn;
    EmailToRecipient: TButton;
    lbFiles: TListBox;
    vtLabel2: TvtLabel;
    AddFiles: TButton;
    EmailSubject: TEdit;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    meMessage: TMemo;
    GenerateMessage: TButton;
    DecryptFileBtn: TButton;
    vtLabel10: TvtLabel;
    RecipientEmail: TEdit;
    vtLabel11: TvtLabel;
    RecipientSalutation: TEdit;
    FolderName: TEdit;
    vtLabel9: TvtLabel;
    DirGroup: TRadioGroup;
    vtLabel7: TvtLabel;
    TransmitAsEncrypted: TCheckBox;
    //20201222 Igor >>>
    SecuritySettingsGroup: TRadioGroup;
    lbAvailable: TLabel;
    AddCurrentReturn: TButton;
    btnHelp: TButton;
    btnSelectDirectory: TSpeedButton;
    WWWLbl: TLabel;
    //20201222 Igor <<<
    procedure FormCreate(Sender: TObject);
    procedure FolderNameExit(Sender: TObject);
    procedure DirGroupClick(Sender: TObject);
    procedure AddFilesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbFilesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EmailToRecipientClick(Sender: TObject);
    procedure GenerateMessageClick(Sender: TObject);
    procedure DecryptFileBtnClick(Sender: TObject); //20201023 Igor
    //20201222 Igor >>>
    procedure SecuritySettingsGroupClick(Sender: TObject);
    procedure AddCurrentReturnClick(Sender: TObject);
    //20201222 Igor <<<
    procedure btnHelpClick(Sender: TObject); //20210118 Igor
    //20210202 Igor >>>
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSelectDirectoryClick(Sender: TObject);
    procedure WWWLblClick(Sender: TObject); //20210204 Igor
    procedure FormShow(Sender: TObject); //20210318 Igor
    //20210202 Igor <<<
  private
    { Private declarations }
    FRetNo: Integer;
    arrFiles: TDictionary<string, string>;
  protected
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
    procedure InitMessage; //20210318 Igor
  public
    TaxPayerCyberId: string;
    procedure AcceptFiles(var Message: TWMDropFiles);
    procedure AddFilesFromArray(AFiles: TArray<string>); //20210201 Igor
    property RetNo: Integer read FRetNo;
    { Public declarations }
  end;

  procedure RunCourier(ATaxPayerCyberId: string; AFiles: TArray<string> = nil); //20210201 Igor
  function DecryptFile(APassword, ASrcFile, ADestFile: string): boolean;
  procedure SendEncryptedEmail(ATaxPayerCyberId, ASubject: string; AFiles: TArray<string>); //20210322 Igor

implementation

{$R *.dfm}

Uses
  vtMulti, vtCommon, vtDialogs, MAPI, vtTrimStr, Variants; //20210120 Igor

function GetFileMD5(const AFileName: string): TIdBytes; //20201028 Igor
var
  FS: TFileStream;
  MD5: TIdHashMessageDigest5;
begin
  FS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  MD5 := TIdHashMessageDigest5.Create;
  try
    Result := MD5.HashStream(FS);
  finally
    MD5.Free;
    FS.Free;
  end;
end;

function DecryptFile(APassword, ASrcFile, ADestFile: string): boolean;
var Key: TAESKey256;
    Source, Dest: TFileStream;
    Hash, RealHash: TIdBytes;
    Size, I: integer;
    FPassword: AnsiString; //20201109 Igor
begin
  Result := false;
  //20201109 Igor >>>
  FPassword := AnsiString(APassword);
  FPassword := FPassword + StringOfChar('_', 32);
  FPassword := Copy(FPassword, 1, 32);
  //20201109 Igor <<<
  SetLength(Hash, 16);
  Source := TFileStream.Create(ASrcFile, fmOpenRead);
  try
    Source.ReadBuffer(Hash[0], 16);
    Source.ReadBuffer(Size, SizeOf(Size));
    Dest := TFileStream.Create(ADestFile, fmCreate);
    try
      FillChar(Key, SizeOf(Key), 0);
      Move(PChar(FPassword)^, Key, Min(SizeOf(Key), Length(FPassword))); //20201109 Igor

      DecryptAESStreamECB(Source, Source.Size - Source.Position, Key, Dest);
      Dest.Size := Size;
    finally
      Dest.Free;
    end;
    RealHash := GetFileMD5(ADestFile);
    if Length(Hash) <> Length(RealHash) then Exit;
    for I := 0 to Length(Hash) - 1 do
      if Hash[I] <> RealHash[I] then Exit;
    Result := true;
  finally
    Source.Free;
  end;
end;

procedure SendEncryptedEmail(ATaxPayerCyberId, ASubject: string; AFiles: TArray<string>); //20210322 Igor
var
  FCourier: TvtCourier;
begin
  if ATaxPayerCyberId.IsEmpty then
  begin
    ShowMessage('Virtual Client Id is not specified');
    Exit;
  end;
  if VirtualTaxOfficeInfo.AccountType = vtoPayer then
    if not VirtualTaxOfficeInfo.CheckTaxOfficeStatus(VirtualTaxOfficeInfo.TaxOffice.CyberId) then Exit;
  if VirtualTaxOfficeInfo.AccountType = vtoOffice then
    if not VirtualTaxOfficeInfo.CheckTaxPayerStatus(ATaxPayerCyberId) then Exit;
  if not Assigned(Application.MainForm) then
    Application.CreateForm(TvtCourier, FCourier)
  else
    FCourier := TvtCourier.Create(Application);
  try
    FCourier.TaxPayerCyberId := ATaxPayerCyberId;
    if Assigned(AFiles) then
      FCourier.AddFilesFromArray(AFiles);
    FCourier.InitMessage;
    FCourier.EmailSubject.Text := ASubject;
    FCourier.EmailToRecipient.Click;
  finally
    FCourier.Free;
  end;
end;

procedure RunCourier(ATaxPayerCyberId: string; AFiles: TArray<string> = nil); //20210201 Igor
var
  FCourier: TvtCourier;
begin
  if ATaxPayerCyberId.IsEmpty then
  begin
    ShowMessage('Virtual Client Id is not specified'); //20210201 Igor
    Exit;
  end;
  //20201222 Igor >>>
  if VirtualTaxOfficeInfo.AccountType = vtoPayer then
    if not VirtualTaxOfficeInfo.CheckTaxOfficeStatus(VirtualTaxOfficeInfo.TaxOffice.CyberId) then Exit;
  //20201222 Igor <<<
  //20210201 Igor >>>
  if VirtualTaxOfficeInfo.AccountType = vtoOffice then
    if not VirtualTaxOfficeInfo.CheckTaxPayerStatus(ATaxPayerCyberId) then Exit;
  //20210201 Igor <<<
  //20210308 Igor >>>
  if not Assigned(Application.MainForm) then
    Application.CreateForm(TvtCourier, FCourier)
  else
    FCourier := TvtCourier.Create(Application);
  //20210308 Igor <<<
  try
    FCourier.TaxPayerCyberId := ATaxPayerCyberId;
    //20210201 Igor >>>
    if Assigned(AFiles) then
      FCourier.AddFilesFromArray(AFiles);
    //20210201 Igor <<<
    FCourier.ShowModal;
  finally
    FCourier.Free;
  end;
end;

procedure TvtCourier.WMDropFiles(var Message: TWMDropFiles);
begin
  AcceptFiles(Message);
end;

procedure TvtCourier.WWWLblClick(Sender: TObject); //20210204 Igor
begin
  ConnectToWeb('www.VisualTax.com');
end;

procedure TvtCourier.FormClose(Sender: TObject; var Action: TCloseAction); //20210202 Igor
begin
  if not DirGroup.Enabled then
    VirtualTaxOfficeInfo.SaveOption('ClientDocs', FolderName.Text); //20210205 Igor
end;

procedure TvtCourier.FormCreate(Sender: TObject);
begin
  arrFiles := TDictionary<string, string>.Create;
  FRetNo := GetCurrentRetNo;
  RecipientEmail.Text := CurrentApp.GetCourierRecipientEmail;
  RecipientSalutation.Text := CurrentApp.GetCourierRecipientSalutation;
  //20210202 Igor >>>
  if CurrentApp.GetCourierClientDocumentsFolder.IsEmpty then
  begin
    DirGroup.ItemIndex := 1;
    DirGroup.Enabled := false;
    FolderName.Text := VirtualTaxOfficeInfo.ReadClientDocs; //20210205 Igor
  end
  else
    DirGroup.ItemIndex := 0;
  //20210202 Igor <<<
  DragAcceptFiles(Handle, true);
  //20201222 Igor >>>
  if true {VirtualTaxOfficeInfo.AllowedEncryption} then //20210308 Igor
  begin
    SecuritySettingsGroup.ItemIndex := 0;
    SecuritySettingsGroup.Enabled := true;
    lbAvailable.Visible := false;
  end
  else
  begin
    SecuritySettingsGroup.ItemIndex := 1;
    SecuritySettingsGroup.Enabled := false;
    lbAvailable.Visible := true;
  end;
  SecuritySettingsGroupClick(SecuritySettingsGroup);
  //20201222 Igor <<<
end;

procedure TvtCourier.FormDestroy(Sender: TObject);
begin
  if Assigned(arrFiles) then
    FreeAndNil(arrFiles);
end;

procedure TvtCourier.FormShow(Sender: TObject); //20210318 Igor
begin
  InitMessage;
end;

procedure TvtCourier.GenerateMessageClick(Sender: TObject); //20201023 Igor
begin
  //20201028 Igor >>>
  //20201207 Igor >>>
  //20210205 Igor >>>
  if VirtualTaxOfficeInfo.AccountType = vtoOffice then
    meMessage.Text :=
      RecipientSalutation.Text + sLineBreak +
      'We are sending you an Email via vtCourier with encrypted attachments. '+ sLineBreak +
      'The attached files are encrypted and you need to install on your machine the vtClient2020 program '+
      'or the vtCourier program as described in the vcHelp link.' + slineBreak +
      'Open chosen program and then click ''Decrypt files''. '+ sLineBreak + sLineBreak +
       VirtualTaxOfficeInfo.GetDoNotAnswerMessage //20220202 Igor
  else
    meMessage.Text :=
      RecipientSalutation.Text + sLineBreak +
      'We are sending you an Email via vtCourier with encrypted attachments. '+ sLineBreak +
      'Open the VisualTax, click the "Virtual Tax Office" - "Send files and messages" of the top menu and then click ''Decrypt files''.'+ sLineBreak + sLineBreak +
      VirtualTaxOfficeInfo.GetDoNotAnswerMessage; //20220202 Igor
  //20210205 Igor <<<
  //20201207 Igor <<<
  //20201028 Igor <<<
end;

procedure TvtCourier.InitMessage; //20210322 Igor
var FMessage: string;
begin
  FMessage := '';
  if lbFiles.Count = 0 then Exit;
  if VirtualTaxOfficeInfo.AccountType = vtoOffice then
  begin
    if SameText(ExtractFileExt(lbFiles.Items.Strings[0]), '.pdf') then
    begin
      FMessage :=
      'a. If not done already, please install ''vtSignPdf'' ( https://www.visualtax.com/Downloads/vtSignPDFSetup.exe ) '+ #13#10 +
      'b. Save the attachments in your computer folder C:/VT/T1-2023/ClientDocs '+ #13#10 +
      'c. If you do not have an Electronic Signature, you can find some instruction here - https://visualtax.com/vtSignatureCreate.php' + #13#10 +
      'd. Once ready with the above, click your vtSignPdf icon of your desktop '+ #13#10 +
      'e. Login to Virtual Tax Office'+ #13#10 +
      'f. Click "Open PDF" and choose received file. If it encrypted, program will decrypt it automatically';

//      'If you use vtClient2020, follow the next steps:'+ #13#10 +
//      '  1. Run vtClient2020 and login to Virtual Tax Office'+ #13#10 +
//      '  2. Press Sign button and choose “Sign specific PDF documents”'+ #13#10 +
//      '  3. Click "Open PDF" and choose received file. If it encrypted, program will decrypt it automatically'+ #13#10#13#10 +


      EmailSubject.Text := 'vtCourier-Forms for Signature–'+ VirtualTaxOfficeInfo.GetNameForCyberId(TaxPayerCyberId) +'-'+FormatDateTime('yyyy-mm-dd', Now);
    end
    else
      FMessage :=
      'This Email has encrypted attachments'+ #13#10#13#10 +
      'If you use vtClient2020, follow the next steps:'+ #13#10 +
      '  1. Run vtClient2020 and login to Virtual Tax Office'+ #13#10 +
      '  2. Click “vtCourier” button'+ #13#10 +
      '  3. In vtCourier form click “Decrypt files”' + #13#10 +
      '  4. Choose encrypted file (Note that you should not decrypt the same encrypted file twice or more, it will ruin encryption chains)'+ #13#10 +
      '  5. Program will decrypt it and put to DECRYPTED subfolder'+ #13#10#13#10 +

      'If you use vtCourier, follow the next steps:'+ #13#10 +
      '  1. Run vtCourier program and login to Virtual Tax Office'+ #13#10 +
      '  2. In vtCourier form click “Decrypt files”' + #13#10 +
      '  3. Choose encrypted file (Note that you should not decrypt the same encrypted file twice or more, it will ruin encryption chains)'+ #13#10 +
      '  4. Program will decrypt it and put to DECRYPTED subfolder';
  end
  else
  begin
    if SameText(ExtractFileExt(lbFiles.Items.Strings[0]), '.pdf') then
      FMessage := 'Attached please find the Signed forms for your clientDocs records'+ #13#10#13#10;
    FMessage := FMessage +
      'This Email has encrypted attachments'+ #13#10#13#10 +
      '  1. Open tax return for '+ VirtualTaxOfficeInfo.GetCurrentName + #13#10 +
      '  2. Click menu Virtual Tax Office'+ #13#10 +
      '  3. Login to Virtual Tax Office' + #13#10 +
      '  4. After that click menu Virtual Tax Office and select “Send files and messages to Virtual Client”'+ #13#10 +
      '  5. Press “Decrypt files” button and choose your encrypted files (Note that you should not decrypt the same encrypted file twice or more, it will ruin encryption chains)'+ #13#10 +
      '  6. Program will decrypt it and put to DECRYPTED subfolder';
  end;
  FMessage := FMessage + #13#10#13#10 + VirtualTaxOfficeInfo.GetDoNotAnswerMessage; //20220202 Igor
  if SecuritySettingsGroup.ItemIndex = 0 then
    meMessage.Text := FMessage;
end;

procedure TvtCourier.lbFilesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var cFile: string;
begin
  if Key = VK_DELETE then
  begin
    if lbFiles.ItemIndex >= 0 then
    begin
      cFile := lbFiles.Items[lbFiles.ItemIndex];
      if MessageDlg('Are you sure you want to remove '+ cFile + ' from the list?',
          mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
      lbFiles.Items.Delete(lbFiles.ItemIndex);
      arrFiles.Remove(cFile);
    end;
  end;
end;

procedure TvtCourier.SecuritySettingsGroupClick(Sender: TObject); //20201222 Igor
begin
  if SecuritySettingsGroup.ItemIndex = 0 then
  begin
    TransmitAsEncrypted.Enabled := true;
    GenerateMessage.Enabled := true;
  end
  else
  begin
    TransmitAsEncrypted.Checked := false;
    TransmitAsEncrypted.Enabled := false;
    GenerateMessage.Enabled := false;
  end;
end;

procedure TvtCourier.AcceptFiles(var Message: TWMDropFiles);
var
  FCount, I: integer;
  FName: array[0..MAX_PATH-1] of char;
  cFileName, cFullName: string;
  bShowWarning: boolean;
begin
  inherited;
  FCount := DragQueryFile(Message.Drop, $FFFFFFFF, FName, MAX_PATH);

  if FCount = 0 then
  begin
    ShowMessage('Please, select file');
    Exit;
  end;

  bShowWarning := false;
  for I := 0 to FCount - 1 do
  begin
    if DragQueryFile(Message.Drop, I, FName, MAX_PATH) = 0 then continue;
    cFullName := FName;
    cFileName := ExtractFileName(cFullName);
    if arrFiles.ContainsKey(cFileName) then
    begin
      bShowWarning := true;
      continue;
    end;
    arrFiles.AddOrSetValue(cFileName, cFullName);
    lbFiles.Items.Add(cFileName);
  end;

  if bShowWarning then
    ShowMessage('You cannot add the same file name twice');
end;

procedure TvtCourier.AddCurrentReturnClick(Sender: TObject); //20201222 Igor
var FRetNo: integer;
    cFileName, cFullName: string;
begin
  FRetNo := GetCurrentRetNo;
  if FRetNo = 0 then
  begin
    ShowMessage('Open return first');
    exit;
  end;
  if RetList[FRetNo].SourceFlName.IsEmpty then
  begin
    ShowMessage('Please, save return before adding to list');
    Exit;
  end;
  cFullName := TPath.Combine(RetList[FRetNo].SourceDataDir, RetList[FRetNo].SourceFlName);
  cFileName := RetList[FRetNo].SourceFlName;
  if arrFiles.ContainsKey(cFileName) then
  begin
    ShowMessageWarning('You cannot add the same file name twice');
    Exit;
  end;
  arrFiles.AddOrSetValue(cFileName, cFullName);
  lbFiles.Items.Add(cFileName);
end;

procedure TvtCourier.AddFilesClick(Sender: TObject);
var I: integer;
    cFileName, cFullName: string;
    bShowWarning: boolean;
begin
  OpenFilesDialog.InitialDir := FolderName.Text; //20210203 Igor
  if OpenFilesDialog.Execute then
  begin
    bShowWarning := false;
    for I := 0 to OpenFilesDialog.Files.Count - 1 do
    begin
      cFullName := OpenFilesDialog.Files.Strings[I];
      cFileName := ExtractFileName(cFullName);
      if arrFiles.ContainsKey(cFileName) then
      begin
        bShowWarning := true;
        continue;
      end;
      arrFiles.AddOrSetValue(cFileName, cFullName);
      lbFiles.Items.Add(cFileName);
    end;
    if bShowWarning then
      ShowMessageWarning('You cannot add the same file name twice'); //20201222 Igor
  end;
end;

procedure TvtCourier.AddFilesFromArray(AFiles: TArray<string>); //20210201 Igor
var I: integer;
    cFileName, cFullName: string;
    bShowWarning: boolean;
begin
  bShowWarning := false;
  for I := 0 to Length(AFiles) - 1 do
  begin
    cFullName := AFiles[I];
    cFileName := ExtractFileName(cFullName);
    if arrFiles.ContainsKey(cFileName) then
    begin
      bShowWarning := true;
      continue;
    end;
    arrFiles.AddOrSetValue(cFileName, cFullName);
    lbFiles.Items.Add(cFileName);
  end;
  if bShowWarning then
    ShowMessageWarning('You cannot add the same file name twice'); //20201222 Igor
end;

procedure TvtCourier.btnHelpClick(Sender: TObject); //20210118 Igor
begin
  ConnectToWeb('https://www.visualtax.com/vtCourier.php');
end;

procedure TvtCourier.btnSelectDirectoryClick(Sender: TObject); //20210202 Igor
var cFolder: string;
begin
  cFolder := FolderName.Text;
  if SelectDirectory('Choose Folder', '', cFolder) then
    FolderName.Text := cFolder;
end;

procedure TvtCourier.DecryptFileBtnClick(Sender: TObject); //20201028 Igor
var I, PasswordId: integer;
    Password: string;
    nDecryptedFilesCount: integer;
    //20201222 Igor >>>
    SrcFile, DestFile, cDecFolder, DestReturnFile: string; //20201028 Igor
    nRetNo: integer;
    bCopyReturn: boolean;
    cReturnFiles, cOtherFiles, cMessage: string;
    nReturnFilesCount, nOtherFilesCount: integer;
    //20201222 Igor <<<
begin
  if String(FolderName.Text).IsEmpty then
  begin
    ShowMessage('Please, specify Folder Name for decrypted files');
    Exit;
  end;
  OpenEncryptedDialog.InitialDir := FolderName.Text; //20210203 Igor
  if OpenEncryptedDialog.Execute then
  begin
    Password := '';
    PasswordId := 0;
    if not VirtualTaxOfficeInfo.GetEncrPsw(TaxPayerCyberId, Password, PasswordId, false) then Exit;

    //20201028 Igor >>>
    cDecFolder := TPath.Combine(FolderName.Text, DecryptedFolder);
    if not SysUtils.ForceDirectories(cDecFolder) then Exit;
    nDecryptedFilesCount := 0;
    //20201028 Igor <<<

    //20201222 Igor >>>
    cReturnFiles := '';
    cOtherFiles := '';
    nReturnFilesCount := 0;
    nOtherFilesCount := 0;
    //20201222 Igor <<<

    for I := 0 to OpenEncryptedDialog.Files.Count - 1 do
    begin
      SrcFile := OpenEncryptedDialog.Files.Strings[I];
      DestFile := ExtractFileName(SrcFile);
      DestFile := TPath.Combine(cDecFolder, ChangeFileExt(DestFile, ''));  //20201028 Igor

      if FileExists(DestFile) then
        DeleteFile(PChar(DestFile));

      //20201026 Igor >>>
      if not DecryptFile(Password, SrcFile, DestFile) then
      begin
        ShowMessage('File "'+ SrcFile + '" was not decrypted. Make sure that you enter correct password');
        if FileExists(DestFile) then
          DeleteFile(PChar(DestFile));
        continue;
      end
      else
      begin
        VirtualTaxOfficeInfo.DecFileEncrPsw(PasswordId);
        //20201222 Igor >>>
        CurrentApp.SetSilentRead(true);
        try
          nRetNo := CurrentApp.OpenReturn(cDecFolder, ExtractFileName(DestFile), false);
          if nRetNo  > 0 then
          begin
            bCopyReturn := true;
            RetList[nRetNo].Close(true);
            DestReturnFile := TPath.Combine(CurrentApp.Dir_Cur, ExtractFileName(DestFile));
            if FileExists(DestReturnFile) then
            begin
              if MessageDlg('Return '+ ExtractFileName(DestFile) + ' already exists in '+ CurrentApp.Dir_Cur + '. ' + #13#10 +
                            'Do you want to replace it?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                DeleteFile(PChar(DestReturnFile))
              else
                bCopyReturn := false;
            end;
            if bCopyReturn then
            begin
              if CopyFile(PChar(DestFile), PChar(DestReturnFile)) then
              begin
                DeleteFile(PChar(DestFile));
                if not cReturnFiles.IsEmpty then
                  cReturnFiles := cReturnFiles + #13#10;
                cReturnFiles := cReturnFiles + ExtractFileName(DestFile);
                inc(nReturnFilesCount);
              end;
            end
            else
            begin
              if not cOtherFiles.IsEmpty then
                cOtherFiles := cOtherFiles + #13#10;
              cOtherFiles := cOtherFiles + ExtractFileName(DestFile);
              inc(nOtherFilesCount);
            end;
          end
          else
          begin
            if not cOtherFiles.IsEmpty then
              cOtherFiles := cOtherFiles + #13#10;
            cOtherFiles := cOtherFiles + ExtractFileName(DestFile);
            inc(nOtherFilesCount);
          end;
        finally
          CurrentApp.SetSilentRead(false);
        end;
        //20201222 Igor <<<
      end;
      inc(nDecryptedFilesCount);
//      if Sender = OpenFile then
//        ShellExecute(Application.MainForm.Handle, 'open', PChar(DestFile), Nil, Nil, SW_SHOW);
      //20201026 Igor <<<
    end;
    //20201028 Igor >>>
    //20201109 Igor >>>
    if {(Sender <> OpenFile) and} (nDecryptedFilesCount > 0) then
    begin
      //20201222 Igor >>>
      cMessage := '';
      if not cOtherFiles.IsEmpty then
      begin
        if nOtherFilesCount = 1 then
          cMessage := cMessage + 'File was decrypted'
        else
          cMessage := cMessage + 'Files were decrypted';
        cMessage := cMessage + ' in folder '+ cDecFolder;
        if nOtherFilesCount = 1 then
          cMessage := cMessage + ' with name: '
        else
          cMessage := cMessage + ' with names:';
        cMessage := cMessage + #13#10 + cOtherFiles;
      end;
      if not cReturnFiles.IsEmpty then
      begin
        if not cMessage.IsEmpty then
          cMessage := cMessage + #13#10#13#10;
        if nReturnFilesCount = 1 then
          cMessage := cMessage + 'Return was decrypted'
        else
          cMessage := cMessage + 'Returns were decrypted';
        cMessage := cMessage + ' in folder '+ CurrentApp.Dir_Cur;
        if nReturnFilesCount = 1 then
          cMessage := cMessage + ' with name: '
        else
          cMessage := cMessage + ' with names:';
        cMessage := cMessage + #13#10 + cReturnFiles;
      end;
      ShowMessageInfo(cMessage);
      //20201222 Igor <<<
    end;
    //20201109 Igor <<<
    //20201028 Igor <<<
  end;
  Screen.Cursor := crDefault; //20201223 Igor
end;

procedure TvtCourier.DirGroupClick(Sender: TObject); //20210202 Igor
begin
  if DirGroup.ItemIndex = 0 then
  begin
    FolderName.Readonly := true;
    FolderName.Text := CurrentApp.GetCourierClientDocumentsFolder;
    btnSelectDirectory.Enabled := false;
  end
  else
  begin
    FolderName.Readonly := false;
    btnSelectDirectory.Enabled := true;
  end;
end;

procedure TvtCourier.EmailToRecipientClick(Sender: TObject); //20201026 Igor //20201109 Igor
var Attachments, Body, cEncFolder, SrcFile, DestFileName: string;
    I, FilesCount: integer;
    MessageFlName: string;
    Password: string;
    PasswordId: integer;
    SenderEmail: string; //20210211 Igor


    function EncodeFile(AFileName: string): string; //20201028 Igor //20201109 Igor
    var Key: TAESKey256;
        Source, Dest: TFileStream;
        DestFile: string;
        Size: integer;
        Hash: TIdBytes;
        FPassword: AnsiString;
    begin
      FPassword := AnsiString(Password);
      FPassword := FPassword + StringOfChar('_', 32);
      FPassword := Copy(FPassword, 1, 32);
      DestFile := TPath.Combine(cEncFolder, ExtractFileName(AFileName) + '.encrypted');
      if FileExists(DestFile) then
        DeleteFile(PChar(DestFile));
      Hash := GetFileMD5(AFileName);
      Source := TFileStream.Create(AFileName, fmOpenRead);
      try
        Dest := TFileStream.Create(DestFile, fmCreate);
        try
          Dest.WriteBuffer(Hash[0], Length(Hash));

          Size := Source.Size;
          Dest.WriteBuffer(Size, SizeOf(Size));

          FillChar(Key, SizeOf(Key), 0);
          Move(PChar(FPassword)^, Key, Min(SizeOf(Key), Length(FPassword)));

          EncryptAESStreamECB(Source, 0, Key, Dest);
          if not Attachments.IsEmpty then
            Attachments := Attachments + sLineBreak;
          Attachments := Attachments + DestFile;
        finally
          FreeAndNil(Dest);
        end;
      finally
        FreeAndNil(Source);
      end;
      Result := DestFile;
      inc(FilesCount);
    end;
begin
  //20210202 Igor >>>
  if String(FolderName.Text).IsEmpty then
  begin
    ShowMessage('Folder is not specified');
    Exit;
  end;
  //20210202 Igor <<<
  if String(RecipientEmail.Text).IsEmpty then
  begin
    ShowMessage('Recipient Email is not specified');
    Exit;
  end;
  if String(meMessage.Text).IsEmpty then
  begin
    ShowMessage('Email message is not specified');
    Exit;
  end;
  FilesCount := 0;
  cEncFolder := TPath.Combine(FolderName.Text, EncryptedFolder);
  if not SysUtils.ForceDirectories(cEncFolder) then Exit;

  Password := '';
  PasswordId := 0;
  if not VirtualTaxOfficeInfo.GetEncrPsw(TaxPayerCyberId, Password, PasswordId, true) then Exit;

  Attachments := '';
  if TransmitAsEncrypted.Checked then
  begin
    MessageFlName := 'Email message-'+FormatDateTime('yyyy-mm-dd-hh-nn-ss', Now) + '.txt';
    meMessage.Lines.SaveToFile(MessageFlName);
    EncodeFile(MessageFlName);
    VirtualTaxOfficeInfo.IncFileEncrPsw(PasswordId);
    //20201028 Igor >>>
    //20210112 Igor >>>
    //20210205 Igor >>>
    if VirtualTaxOfficeInfo.AccountType = vtoOffice then
      Body := 'The actual message is provided as an attachment: '+ MessageFlName + sLineBreak +
              'The attached files are encrypted and you need to install on your machine the vtClient2020 program '+
              'or the vtCourier program as described in the vcHelp link.' + slineBreak +
              'Open chosen program and then click ''Decrypt files''. '+ sLineBreak + sLineBreak
    else
      Body := 'The actual message is provided as an attachment: '+ MessageFlName + sLineBreak +
              'Open the VisualTax program, click the "Virtual Tax Office" - "Send files and messages" of the top menu and then click ''Decrypt files''.'+ sLineBreak + sLineBreak;
    Body := Body + VirtualTaxOfficeInfo.GetDoNotAnswerMessage; //20220202 Igor
    //20210205 Igor <<<
    //20210112 Igor <<<
    //20201028 Igor <<<
  end
  else
    Body := meMessage.Text;

  for I := 0 to lbFiles.Items.Count - 1 do
  begin
    if not arrFiles.TryGetValue(lbFiles.Items[I], SrcFile) then continue;
    //20201222 Igor >>>
    if SecuritySettingsGroup.ItemIndex = 0 then
    begin
      DestFileName := EncodeFile(SrcFile);
      VirtualTaxOfficeInfo.IncFileEncrPsw(PasswordId);
    end
    else
    begin
      if not Attachments.IsEmpty then
        Attachments := Attachments + sLineBreak;
      Attachments := Attachments + SrcFile;
    end;
    //20201222 Igor <<<
  end;

  //20201222 Igor >>>
  if SecuritySettingsGroup.ItemIndex = 0 then
  begin
    if FilesCount = 1 then
      ShowMessage('File was encrypted in folder '+ cEncFolder + ' with name '+ ExtractFileName(DestFileName))
    else
      ShowMessage('Files were encrypted in folder '+ cEncFolder);
  end;
  //20201222 Igor <<<

  //20210211 Igor >>>
  SenderEmail := VirtualTaxOfficeInfo.GetCurrentEmail;
  //20220202 Igor >>>
  //if VirtualTaxOfficeInfo.SendMapiMail(EmailSubject.Text,Body,Attachments,'',SenderEmail,'',RecipientEmail.Text) in [SUCCESS_SUCCESS{, MAPI_USER_ABORT}] then
  Body := '<html><body>'+ ReplaceStr(Body, #13#10, '<br>') + '</body></html>';
  if VirtualTaxOfficeInfo.SendEmail(RecipientEmail.Text, EmailSubject.Text, Body, Attachments) then
  begin
    meMessage.Clear;
    ShowMessageInfo('Email was successfully sent');
  end;
  //20220202 Igor <<<
  //20210211 Igor <<<
end;

procedure TvtCourier.FolderNameExit(Sender: TObject);
begin
  if String(FolderName.text).IsEmpty then
    if SysUtils.DirectoryExists(FolderName.text) = false then
    begin
      if MessageDlg('Folder '+FolderName.text+' does not exist. Create it?',
         mtInformation, [mbYes, mbNo], 0) = mrYes
      then
        SysUtils.Forcedirectories(FolderName.text);
    end;
end;

end.
