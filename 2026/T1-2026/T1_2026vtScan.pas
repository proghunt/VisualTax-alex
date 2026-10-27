unit T1_2026vtScan;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, jpeg, ExtCtrls, VclTee.TeeProcs, VclTee.TeEngine,
  VclTee.Chart, FileCtrl, ShellApi, VclTee.TeeGDIPlus;

type
  TvtScanT1_2026 = class(TForm)
    SourceImageBox: TEdit;
    StartBtn: TBitBtn;
    StaticText1: TStaticText;
    ExitBtn: TBitBtn;
    Chart1: TChart;
    Label4: TLabel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    ClientNameBox: TEdit;
    FlNameBox: TEdit;
    StaticText7: TStaticText;
    ListDocsbtn: TBitBtn;
    OpenDialog: TOpenDialog;
    StaticText2: TStaticText;
    UseADFBtn: TCheckBox;
    ScanFormatBox: TRadioGroup;
    EnableduplexLbl: TStaticText;
    EnableDuplexBox: TCheckBox;
    GroupBox1: TGroupBox;
    ClientPhotoId: TCheckBox;
    EnlargeBtn: TBitBtn;
    RotateBtn: TBitBtn;
    DocCategoryBox: TComboBox;
    AddYourOwnBtn: TBitBtn;
    StaticText6: TStaticText;
    PermanentBox: TCheckBox;
    ListPermantDocsbtn: TBitBtn;
    SignatureBox: TCheckBox;
    e_SignatureHolder: TImage;
    StaticText5: TStaticText;
    PhotoImage: TImage;
    ShowSignatureBtn: TBitBtn;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    Procedure CreateFlName;
    procedure ListDocsbtnClick(Sender: TObject);
    procedure DocCategoryBoxChange(Sender: TObject);
    procedure ScanFormatBoxClick(Sender: TObject);
    procedure ShowPhotoId;
    procedure EnlargeBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure RotateBtnClick(Sender: TObject);
    procedure AddYourOwnBtnClick(Sender: TObject);
    Procedure MergeLists;
    procedure PermanentBoxClick(Sender: TObject);
    procedure ClientPhotoIdClick(Sender: TObject);
    procedure ListPermantDocsbtnClick(Sender: TObject);
    procedure DocCategoryBoxEnter(Sender: TObject);
    procedure ShowSignatureBtnClick(Sender: TObject);

  private
    { Private declarations }
    FMoreCategoriesDate: TDateTime; //20170130 Igor
  public
    { Public declarations }
  end;


var
  vtScanT1_2026: TvtScanT1_2026;
  MoreCategoriesFile:String;
  ScanFormat:String;
  RetNo:Integer;
  DocCategory:String;
  Dir:String;
  FlName:String;
  zFlName: Array[0..160] of AnsiChar;
  pzFlName:PAnsiChar;
implementation

uses
  vtCommon, T1_2026, T1_2026ChildWinNew, T1_2026TrimStr, T1_2026Declare,
  T1_2026EzTwain, T1_2026main;

{$R *.DFM}

procedure TvtScanT1_2026.FormCreate(Sender: TObject);
Var
    zSource: Array[0..120] of AnSiChar;
    SSource: String;
    PredefinedList, TempList: TstringList;
    i: Integer;
    ScanCategoriesFile: String;
begin
  If DocCategoryBox.text = '' then
    DocCategoryBox.text := 'Unspecified';
  MergeLists;
  TWAIN_SetApplicationKey(-1440230794);
  TWAIN_ApplicationLicense('VisualTax', -1440230794);
  TWAIN_SelectImageSource(0);
  TWAIN_GetDefaultSourceName(zSource);
  Ssource := String(zsource);
  SourceImageBox.Text := sSource;
  RetNo := GetCurrentRetNo;
  ClientNameBox.Text := GetLastName(retNo) + ','+ GetFirstName(retNo);
  Case ScanFormatBox.Itemindex of
    0: ScanFormat:='PDF';
    1: ScanFormat:='TIF';
  end;
  ShowPhotoId;
  CreateFlName;
end;

Procedure TvtScanT1_2026.MergeLists;
Var
  PredefinedList, TempList: TstringList;
  i: Integer;
  ScanCategoriesFile: String;
begin
  ScanCategoriesFile := AppDir+'\' + 'vtScanCategories.d';
  MoreCategoriesFile := AppDir+'\' + 'vtScanMoreCategories.txt';

  //create empty file
  If FileExists(MoreCategoriesFile) = false then
  begin
    TempList:=TstringList.Create;
    try
      TempList.Add('');
      TempList.SaveToFile(MoreCategoriesFile);
    finally
      TemplIst.Free;
    end;
  end;

  //merge with predefined
  If FileExists(MoreCategoriesFile) then
  begin
    PredefinedList := TStringList.create;
    try
      //20170130 Igor >>>
      if not FileExists(ScanCategoriesFile) then
      begin
        PredefinedList.Add('Business');
        PredefinedList.Add('Business Assets');
        PredefinedList.Add('DayCare');
        PredefinedList.Add('Dependants');
        PredefinedList.Add('Employment Expenses');
        PredefinedList.Add('Investments');
        PredefinedList.Add('Miscellaneous');
        PredefinedList.Add('Moving');
        PredefinedList.Add('Rental');
        PredefinedList.Add('T3 Slips');
        PredefinedList.Add('T4 Slips');
        PredefinedList.Add('T5 Slips');
        PredefinedList.Add('Tslips');
        PredefinedList.Add('Unspecified');
      end
      else
      //20170130 Igor <<<
        PredefinedList.LoadFromFile(ScanCategoriesFile);
      TempList := TstringList.Create;
      try
        TempList.LoadFromFile(MoreCategoriesFile);
        For i:=0 to TempList.count - 1 do
        Begin
          If PredefinedList.IndexOf(TempList[i]) = -1 then
            PredefinedList.Add(TempList[i]); //item does not exist
        end;
        PredefinedList.SaveToFile(ScanCategoriesFile);
      finally
        TempList.free;
      end;
    finally
      PredefinedList.Free;
    end;
  end;
  //Show the merged list
  DocCategoryBox.items.LoadFromFile(ScanCategoriesFile);
  DocCategoryBox.Refresh;
  FileAge(MoreCategoriesFile, FMoreCategoriesDate);
end;

Procedure TvtScanT1_2026.CreateFlName;
begin
  //20190320
  If (SignatureBox.checked) then
  Begin
    DocCategoryBox.text := 'Signature';
    ScanFormat := 'BMP';
  end;

  //20250131
  If (ClientPhotoId.checked) then
  Begin
    DocCategoryBox.text := 'Photo Id'; //'PhotoId'; //20250530 Igor alex
    ScanFormat := 'BMP';
  end;

  if SignatureBox.checked then ClientPhotoId.checked:=false;
  if ClientPhotoId.checked then SignatureBox.checked:=false;

  //20250131
  if (SignatureBox.checked)
  or (ClientPhotoId.checked) then
   ScanFormat := 'BMP'
  Else //20250131
  Begin
   Case ScanFormatBox.Itemindex of
    0: ScanFormat:='PDF';
    1: ScanFormat:='TIF';
   end;
  end;

  DocCategory := DocCategoryBox.text;
  Dir := optRec.Dir_ClientDocs + '\' + GetLastName(retNo) + ',' + GetFirstName(retNo);
  If DirectoryExists(Dir)= false then  ForceDirectories(Dir);  //20141211 //create sub folder
  If (PermanentBox.Checked)
  Or (ClientPhotoId.checked)
  then
  begin
    Dir := optRec.Dir_PermanentDocs + '\' + GetLastName(retNo) + ','+ GetFirstName(retNo);
    If DirectoryExists(Dir)= false then  ForceDirectories(Dir);  //20141211 //create a Permanent sub folder
  end;
  FlName := dir + '\' + DocCategory + '.' + ScanFormat;   //PDF

  FlNameBox.text := FlName;
  pzFlName := StrPCopy(ZFlName, FlNameBox.text);
  FlNameBox.refresh; //20120127
end;

procedure TvtScanT1_2026.StartBtnClick(Sender: TObject);
Var
  k: Integer;
  ErrMsg1, ErrMsg2: String;
  hdib: Word;
begin
  CreateFlName;
  If Dir = '' then
  begin
    ShowMessage('Please Enter Document Folder (or set up via Configure');
    Exit;
  end;
  ForceDirectories(ExtractFilePath(Dir));

  //20120127
  If (FileExists(flName)) and (DocCategory='PHOTO ID') then  //20120209
  begin
    if MessageDlg('Photo Id already scanned. Delete the old one?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit
    Else
    Begin
      SysUtils.DeleteFile(FlName);
      ShowMessage('Old file deleted. Click Start again');
      ShowPhotoId;
      PhotoImage.Picture := Nil;
      PhotoImage.Refresh;
      Refresh;
      Exit;
    end;
  end;

  If DocCategory = 'PHOTO ID' then
  begin
    TWAIN_SetPaperSize(53);
    TWAIN_SetResolution(600);
  end;

  if TWAIN_OpenDefaultSource() = false then
  begin
    ShowMessage('Unable to open scanner');
    Exit;
  end;

  If EnableDuplexBox.checked then
    TWAIN_EnableDuplex(True) // both sides (if supported)  //20100222
  else
    TWAIN_EnableDuplex(False);


  //multiple pages in feeder
  If UseAdfBtn.Checked then
  begin
    if TWAIN_OpenDefaultSource() = true then
    begin
      If FileExists(flName) then
      begin
       if MessageDlg('File exists with the same document category. Append documents?',
                      mtConfirmation, [mbYes, mbNo], 0) = mrNo then end;
      TWAIN_SetHideUI(True); // ask for no user interface
      TWAIN_SetResolution(300); // ask for 300 DPI
      TWAIN_SelectFeeder(True); // from feeder (if possible)
      TWAIN_SetFileAppendFlag(True);   //MINE
      hdib := TWAIN_AcquireMultipageFile(0, pzFlName);
      If hdib <> 0 then
        ShowMessage('scanning failed '+IntToStr(hdib));
      if TWAIN_LastErrorCode() <> 0 then
        TWAIN_ReportLastError('Error during scanning.');
      TWAIN_CloseSource();
      Exit;
    end;
  end;

  If FileExists(flName) then
  begin
    if MessageDlg('File exists with the same document category. Append documents?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      //combine documents
      TWAIN_SetFileAppendFlag(True);
      hdib := TWAIN_AcquireToFilename(0, pzFlName); //20160905 Igor
      //hdib:=TWAIN_AcquireMultipageFile(0, pzFlName);
      If hdib<>0 then
      begin
        ShowMessage('scan failed '+IntToStr(hdib));
        TWAIN_CloseSource();
      end;
    end;
  end
  Else
  begin  //new file one document
    k := TWAIN_AcquireToFilename(0,pzFlName);
    If k <> 0 then
      ShowMessage('Scan failed ' + IntToStr(k));

    TWAIN_CloseSource();   //put at the end
  end;
  ShowPhotoId; //after scanning
  PermanentBox.checked:=False;  //20141211
end;

procedure TvtScanT1_2026.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TvtScanT1_2026.ListDocsbtnClick(Sender: TObject);
Var InitDire:String;
begin
 MainFormT1.actCopyClientsFoldersExecute(Sender);  //20200322
// MainFormT1.ReviewfilesinClientDocumentFolder1Click(Sender);
end;

procedure TvtScanT1_2026.DocCategoryBoxChange(Sender: TObject);
begin
  CreateFlName;
end;

procedure TvtScanT1_2026.DocCategoryBoxEnter(Sender: TObject); //20170130 Igor
var
  D : TDateTime;
begin
  if FileExists(AppDir+'\' + 'vtScanMoreCategories.txt') then
  begin
    FileAge(AppDir+'\' + 'vtScanMoreCategories.txt', D);
    if D <> FMoreCategoriesDate then
      MergeLists;
  end;
end;

procedure TvtScanT1_2026.ScanFormatBoxClick(Sender: TObject);
begin
  Case ScanFormatBox.Itemindex of
    0: ScanFormat:='PDF';
    1: ScanFormat:='TIF';
  end;
  CreateFlName;
  FlNameBox.refresh;
end;

procedure TvtScanT1_2026.ShowPhotoId;
Var
  s: String;
Begin
  s := GetPhotoIdFlName(RetNo);
  If (FileExists(s)) then
  Begin
    PhotoImage.Picture.LoadFromFile(s);
    PhotoImage.Stretch:=True;
  End;
end;

procedure TvtScanT1_2026.ShowSignatureBtnClick(Sender: TObject);
Var FullPath:String;
begin
 FullPath:=GetSignatureFilePath(GetLastName(RetNo),GetFirstName(RetNo));
 //FullPath:=GetSignatureFilePath(RetNo,GetLastName(RetNo),GetFirstName(RetNo));
 if FullPath>'' then
   e_SignatureHolder.Picture.LoadFromFile(FullPath)
 Else
   ShowMessage('There is no file with name Signature and extension JPG, BMP,PNG, or GIF) in the Client Documents folder'
      +Chr(13)+FullPath
      +Chr(13)+'(Onnce finalized delete duplicate formats/extensions or rename them)');
end;


procedure TvtScanT1_2026.EnlargeBtnClick(Sender: TObject);
Var
  PhotoIdFlName: String;
begin
  PhotoIdFlName := GetPhotoIdFlName(RetNo);
  ShowClientPhotoId(PhotoIdFlName);
end;


procedure TvtScanT1_2026.FormPaint(Sender: TObject);
begin
  If FileExists(GetPhotoIdFlName(RetNo)) then
    EnlargeBtn.Visible := True
  Else
    EnlargeBtn.Visible := False;
end;

procedure TvtScanT1_2026.RotateBtnClick(Sender: TObject);
begin
  RotateImage(GetPhotoIdFlName(RetNo), 1);  //20120131
  ShowPhotoId;
end;

procedure TvtScanT1_2026.AddYourOwnBtnClick(Sender: TObject);
Var
  h: THandle;
begin
  H := ShellExecute(Handle, 'open', PChar('notepad'), Pchar(''+MoreCategoriesFile), nil, SW_SHOW);
  If H < 32 then
    ShowMessage(MoreCategoriesFile +' not found');
  MergeLists;
end;

procedure TvtScanT1_2026.PermanentBoxClick(Sender: TObject);
begin
  CreateFlName;
  FlNameBox.Refresh;
end;

procedure TvtScanT1_2026.ClientPhotoIdClick(Sender: TObject);
begin
  CreateFlName;
  FlNameBox.Refresh;
end;

procedure TvtScanT1_2026.ListPermantDocsbtnClick(Sender: TObject);
begin
  MainFormT1.ReviewfilesinPermanentClientDocumentsfolder1Click(Sender);
end;

end.
