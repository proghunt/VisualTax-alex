unit T2_2027vtscan;
//revision 2014-07-29

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,jpeg,ExtCtrls, FileCtrl,ShellApi,
  T2_2027ChildWinNew,T2_2027TrimStr,T2_2027Declare,T2_2027EzTwain,
  VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart;

type
  TVtScanT2_2027 = class(TForm)
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
    DocCategoryBox: TEdit;
    ClientNameBox: TEdit;
    StaticText6: TStaticText;
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
    E_SIGNATUREHOLDER: TImage;
    EnlargeBtn: TBitBtn;
    RotateBtn: TBitBtn;
    SignatureBox: TCheckBox;
    ShowSignatureBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    Procedure CreateFlName;
    procedure ListDocsbtnClick(Sender: TObject);
    procedure DocCategoryBoxChange(Sender: TObject);
    procedure ScanFormatBoxClick(Sender: TObject);
    Procedure ShowSignature;
    procedure ShowSignatureBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VtScanT2_2027: TVtScanT2_2027;
  ScanFormat:String;
  RetNo:Integer;
  DocCategory:String;
//  DocName:String;
  Dir:String;
  FlName:String;
  zFlName: Array[0..160] of AnsiChar; //20160905 Igor
  pzFlName:PAnsiChar; //20160301 Igor
implementation

uses vtCommon,T2_2027,T2_2027main;

{$R *.DFM}

procedure TVtScanT2_2027.FormCreate(Sender: TObject);
Var
    zSource:Array[0..120] of AnsiChar;SSource:String; //20160301 Igor
begin
 //license
// TWAIN_SetAppTitle('VisualTax');
// TWAIN_SetApplicationKey(-1440230794);
 TWAIN_ApplicationLicense('VisualTax',-1440230794);
 //OCR seetings/tests
 // If OCR_IsEngineAvailable(0) = True then ShowMessage('OCR available');
 // If OCR_SelectEngine(1)  = True then ShowMessage('selected OCR engine 1');
 // ShowMessage('Selected engine name: '+OCR_EngineName(1));
 //get source
 TWAIN_SelectImageSource(0);
 TWAIN_GetDefaultSourceName(zSource);
 Ssource:=String(zsource);
 SourceImageBox.Text:=sSource;
 //get file name
 RetNo:=GetCurrentRetNo;
 ClientNameBox.Text:=GetCorpName(RetNo);  //20160526
 Case ScanFormatBox.Itemindex of
  0: ScanFormat:='PDF';
  1: ScanFormat:='TIF';
 end;

 CreateFlName;
end;

Procedure TVtScanT2_2027.CreateFlName;
Var AImage:TImage;SignPath,FullName:String;
begin
 If optRec.Dir_ClientDocs='' then
 begin
  ShowMessage('Please Exit and define ClientDocs directory in Configure->General Optios->Data Directories');
  Exit;
 end;

 ShowSignature;

 If SignatureBox.checked then
 Begin
   DocCategoryBox.text := 'Signature';
   ScanFormat := 'BMP';
 end;

 If DocCategoryBox.text='' then DocCategoryBox.text:='Variety';
 DocCategory:=DocCategoryBox.text;
 //20100202
 Dir:=optRec.Dir_ClientDocs+'\'+MkDirForClienTdocs(RetNo);
 FlName:=dir+'\'+DocCategory+'.'+ScanFormat;   //PDF
 FlNameBox.text:=FlName;
 pzFlName := PAnsiChar(StrPCopy(ZFlName,AnsiString(FlNameBox.text))); //20160301 Igor //20160905 Igor
 FlNameBox.update;
end;



Procedure TVtScanT2_2027.ShowSignature;
Var FullPath:String;
Begin
 FullPath:=GetSignatureFilePath(RetNo);
 if FullPath>'' then e_signatureHolder.Picture.LoadFromFile(FullPath);
End;

procedure TVtScanT2_2027.ShowSignatureBtnClick(Sender: TObject);
begin
 ShowSignature;
end;

procedure TVtScanT2_2027.StartBtnClick(Sender: TObject);
Var k:Integer;ErrMsg1,ErrMsg2:String;hdib:Word;
begin
 CreateFlName;
 If Dir='' then
 begin
  ShowMessage('Please Enter Document Folder (or set up via Configure');
 end;
 SysUtils.ForceDirectories(ExtractFilePath(Dir)); //20150701

// TWAIN_SetAutoOCR(1);

 if TWAIN_OpenDefaultSource() = false then
 begin
  ShowMessage('Unable to open scanner');
  Exit;
 end;
 //20140405
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
     mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
   end;
   TWAIN_SetHideUI(True); // ask for no user interface
   TWAIN_SetResolution(300); // ask for 300 DPI
   TWAIN_SetPixelType(TWPT_BW); // black & white
   TWAIN_SelectFeeder(True); // from feeder (if possible)
   TWAIN_EnableDuplex(True); // both sides (if supported)
   TWAIN_SetFileAppendFlag(True);   //MINE
   hdib:=TWAIN_AcquireMultipageFile(0, pzFlName);
   If hdib<>0 then ShowMessage('scanning failed '+IntToStr(hdib));
   if TWAIN_LastErrorCode() <> 0 then TWAIN_ReportLastError('Error during scanning.');
   TWAIN_CloseSource();
   Exit;
  end;
 end;

 (*ADF
 TWAIN_SetHideUI(True); // hide the user interface
 TWAIN_SetMultiTransfer(True); // leave device open after Acquire
 TWAIN_SelectFeeder(True); // tell device: ‘use feeder’
 TWAIN_SetAutoFeed(True); // tell device: ‘feed automatically’
 TWAIN_SetAutoScan(True); // tell device: ‘scan ahead’
 TWAIN_EnableDuplex(True); // tell device: ‘both sides, if you can’
 // OK - start scanning
 Repeat
  hdib :=TWAIN_Acquire(0);
  If hdib<>0 then
  begin
   ShowMessage('scanning failed '+IntToHtr(hdib));
   break;
  end;
  ProcessThisPage(hdib);  //NOT documented
  DIB_Free(hdib);
  until TWAIN_State() > 5;
  TWAIN_CloseSource();
 *)

 If FileExists(flName) then
 begin
  if MessageDlg('File exists with the same document category. Append documents?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
 //combine documents
   TWAIN_SetFileAppendFlag(True);
   hdib := TWAIN_AcquireToFilename(0, pzFlName); //20160905 Igor
//   hdib:=TWAIN_AcquireMultipageFile(0, pzFlName); //20160905 Igor
   If hdib<>0 then
   begin
    ShowMessage('scan failed '+IntToStr(hdib));
    TWAIN_CloseSource();
   end;
  end;
 end
 Else
 begin  //new file one document
 // TWAIN_SetResolution(600); // ask for 300 DPI
  k:=TWAIN_AcquireToFilename(0,pzFlName);
  If k<>0 then ShowMessage('Scan failed '+IntToStr(k));
  TWAIN_CloseSource();
  (*
  //INTO MEMORY
  hdib = TWAIN_Acquire(0);
  hdib<>0 then
  begin
    DIB_WriteToFilename(hdib, pzFlName);
    //read slip data
    //FAILS
    //  k:=OCR_RecognizeDib(hdib);
    //ShowMessage('hdib = '+IntToStr(k));
    //ShowMessage(OCR_Text());
    DIB_Free(hdib);
    hdib :=0;
  end
 *)
 end;
end;

procedure TVtScanT2_2027.ExitBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TVtScanT2_2027.ListDocsbtnClick(Sender: TObject);
Var FullFlName,FlName:String;h:Word;PgmPath:String;PgmFile:String;
begin
 //20100202
 OpenDialog.InitialDir:=optRec.Dir_ClientDocs+'\'+MkDirforClientDocs(RetNo);
 //20160526  some comments removed  from here
 If OpenDialog.Execute then
 begin
  FullFlName :=OpenDialog.FileName;
  PgmPath:=ExtractFileDir(FullFlName);
  PgmFile:=ExtractFileName(FullFlName);
  OpenAnyFile(PgmPath,PgmFile);
 end;
end;

procedure TVtScanT2_2027.DocCategoryBoxChange(Sender: TObject);
begin
 CreateFlName;
end;

procedure TVtScanT2_2027.ScanFormatBoxClick(Sender: TObject);
begin
 Case ScanFormatBox.Itemindex of
  0: ScanFormat:='PDF';
  1: ScanFormat:='TIF';
 end;
 CreateFlName;
 FlNameBox.refresh;
end;

end.
