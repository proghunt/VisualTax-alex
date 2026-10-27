unit T1_2026SERSAddFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.IOUtils,
  Vcl.Grids, System.Generics.Collections;

const
  cMaxSizeBytes = 150 * 1024 * 1024; // 20250627 Igor
  DocumentTypesShort : array[0..0] of string = ('03'); //('01', '02', '03'); //20260427 Igor
  DocumentTypesFull : array[0..0] of string = ('Supporting Documents'); //('Director’s Resolution', 'Financial Notes', 'Supporting Documents'); //20260427 Igor

  EOL = #13#10; //line break

type
  TAddFile = function(ADocumentType: integer; AFileName: string): boolean of object;

type
  TSERSAddFileT1_2026 = class(TForm)
    pnlTop: TPanel;
    Label1: TLabel;
    edNumber: TEdit;
    Label2: TLabel;
    edFormType: TEdit;
    Label3: TLabel;
    edEFileNumber: TEdit;
    pnlBottom: TPanel;
    btnAttach: TBitBtn;
    btnCancel: TBitBtn;
    Label8: TLabel;
    lbRemaining: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edFileName: TEdit;
    Label12: TLabel;
    cbDocumentType: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    btnOpenFile: TSpeedButton;
    dlgFileOpen: TFileOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnAttachClick(Sender: TObject);
    function IsNotValidFileExtension(AExt: string): boolean;
    function IsFileSymbolNotValid(aFileName: string): Boolean; // 20250627 Igor
  private
    { Private declarations }
    FormType: string;
    FRetNo: integer;
    FRemainingSize: int64;
    FAddFile: TAddFile;
    FSlipNos: TArray<Integer>;
    procedure FillDocType;
  public
    { Public declarations }
  end;

  function RunSERSAddFile(AFormType: string; ARetNo: integer; ARemainingSize: int64; AAddFile: TAddFile): boolean;

implementation

uses
  T1_2026TrimStr, vtCommon, vtTrimStr, T1_2026Declare, T1_2026;

{$R *.DFM}

function RunSERSAddFile(AFormType: string; ARetNo: integer; ARemainingSize: int64; AAddFile: TAddFile): boolean;
var FSERSAddFileT1_2026: TSERSAddFileT1_2026;
begin
  FSERSAddFileT1_2026:= TSERSAddFileT1_2026.Create(Screen.ActiveForm);
  try
    FSERSAddFileT1_2026.FormType:= AFormType;
    FSERSAddFileT1_2026.FRetNo:= ARetNo;
    FSERSAddFileT1_2026.FRemainingSize:= ARemainingSize;
    FSERSAddFileT1_2026.FAddFile:= AAddFile;
    Result:= FSERSAddFileT1_2026.ShowModal = mrOk;
  finally
    FSERSAddFileT1_2026.Free;
  end;
end;

procedure TSERSAddFileT1_2026.btnAttachClick(Sender: TObject);
var
  lExt: string;
  lFileName: string;
begin
  if cbDocumentType.ItemIndex = -1 then
  begin
    ShowMessage('You need to choose Document Type');
    Exit;
  end;

  if String(edFileName.Text).IsEmpty then
  begin
    ShowMessage('You need to select File');
    Exit;
  end;
  lFileName:= ExtractFileName(edFileName.Text);
  LExt:= ExtractFileExt(edFileName.Text);
  if not IsNotValidFileExtension(LExt) then //20260427 Igor
  begin
    //ShowMessage(LExt + ' is not an allowable file type. The file type of the SER E-Attachment is not valid. CRA accepts the following file types for SER attachments: pdf, doc, docx, xls, xlsx, rtf, txt, jpeg, jpg, tiff, tif, xps.'); //20260427 Igor
    ShowMessage('File type '+ LExt + ' is not valid. CRA accepts the following file types for SER attachments: pdf, doc, docx, xls, xlsx, rtf, txt, jpeg, jpg, tiff, tif, xps.'); //20260427 Igor
    Exit;
  end;

  if Assigned(FAddFile) then
    if FAddFile(cbDocumentType.ItemIndex, edFileName.Text) then
      ModalResult := mrOk;
end;

function TSERSAddFileT1_2026.IsNotValidFileExtension(AExt: string): Boolean;
// 20250627 Igor >>>
const
  arrInvalidExts: array[1..50] of string =
  (
    '.exe', '.ade', '.adp', '.app', '.asx', '.bas', '.bat', '.chm', '.class','.cmd',
    '.com', '.cpl', '.crt', '.dll', '.fxp', '.hlp', '.hta', '.inf', '.ins',  '.isp',
    '.js' , '.jse', '.Ink', '.mda', '.mde', '.mdt', '.mdw', '.mdz', '.msc',  '.msi',
    '.msp', '.mst', '.ops', '.pcd', '.pif', '.prg', '.reg', '.scf', '.scr',  '.sct',
    '.shb', '.shs', '.url', '.vb',  '.vbe', '.vbs', '.wsc', '.wsf', '.ws' ,  '.zip'
  );
  arrValidExts: array[1..12] of string =
  ('.pdf', '.doc', '.docx', '.xls', '.xlsx', '.rtf', '.txt', '.jpg', '.jpeg', '.tiff', '.tif', '.xps');

  function StrInArray(const aValue: String; const aArrayOfString: array of string): Boolean;
  var
    lLoop: string;
  begin
    for lLoop in aArrayOfString do
      if aValue.Equals(lLoop) then
         Exit(true);
    Result:= false;
  end;

begin
  Result:= StrInArray(AExt, arrValidExts{arrInvalidExts}); //20260427 Igor
end;

function TSERSAddFileT1_2026.IsFileSymbolNotValid(aFileName: string): Boolean;
const
  arrInvalidFileNameSymbols: array[1..9] of string =
  (
    '\' , '/',  ':',  '*', '?',  '“',  '<',  '>',  '|');

var
  lLoop: string;
begin
    for lLoop in arrInvalidFileNameSymbols do
      if Pos(lLoop, aFileName) > 0 then
         Exit(true);
    Result:= false;
  //
end;
// 20250627 Igor <<<

procedure TSERSAddFileT1_2026.btnOpenFileClick(Sender: TObject);
// 20250627 Igor >>>
var
  lFileName: string;
  lFileExt: string;
  lFileStream: TFileStream;
  lFileSize: Int64;
begin
  if not dlgFileOpen.Execute then Exit;
  lFileName:= dlgFileOpen.FileName;

  if not lFileName.IsEmpty() then
  begin
    lFileStream:= TFileStream.Create(lFileName, fmOpenRead or fmShareDenyNone);
    try
      lFileSize:= lFileStream.Size;
    finally
      lFileStream.Free;
    end;

    if lFileSize > cMaxSizeBytes then
    begin
      ShowMessage('The file size: ' + FormatFloat('#,##0', lFileSize div 1024 div 1024) + ' Mb' + ' is more then 150 Mb.' + EOL +
                                                  'Total selected file size must less than 150 Mb.');
      Exit;
    end;

    //jz
    if pos(' ',ExtractFileName(dlgFileOpen.FileName)) > 0 then
    begin
      ShowMessage('The file name of the SER E-Attachment is not valid.'  + EOL +
                  'Please ensure the file name does not have blank spaces in it.');
      Exit;
    end;


    if IsFileSymbolNotValid(ExtractFileName(dlgFileOpen.FileName)) then
    begin
      //ShowMessage('The file name exist one or more forbidden symbols: \, /,  :,  *, ?,  “,  <,  >, |'); //20260427 Igor
      ShowMessage('The file name of the SER E-Attachment is not valid.' + EOL +
                  'Please ensure that the file name does not contain any special characters: \ / : * ? “ < > |'); //20260427 Igor
      Exit;
    end;

    lFileExt:= ExtractFileExt(lFileName);
    if not IsNotValidFileExtension(lFileExt) then //20260427 Igor
    begin
      //ShowMessage(lFileExt + ' is not an allowable file type. The file type of the SER E-Attachment is not valid. CRA accepts the following file types for SER attachments: pdf, doc, docx, xls, xlsx, rtf, txt, jpeg, jpg, tiff, tif, xps.'); //20260427 Igor
      ShowMessage('File type "' + lFileExt + '" is not valid.' + EOL +
                             'CRA only accepts the following file types for SER attachments: pdf, doc, docx, xls, xlsx, rtf, txt, jpeg, jpg, tiff, tif, xps.'); //20260427 Igor
      Exit;
    end else
      edFileName.Text:= dlgFileOpen.FileName;
  end;
end;
// 20250627 Igor <<<

procedure TSERSAddFileT1_2026.FillDocType;
var I: integer;
begin
  cbDocumentType.Items.Clear;
  for I := 0 to Length(DocumentTypesFull) - 1 do
    cbDocumentType.Items.Add(DocumentTypesFull[I]);
  if cbDocumentType.Items.Count > 0 then cbDocumentType.ItemIndex:= 0;
end;

procedure TSERSAddFileT1_2026.FormShow(Sender: TObject);
begin
  edNumber.Text:= FetchElm(FRetNo, 'INFO', 3);//FetchElm(FRetNo, 'T1', 1);
  edFormType.Text:= FormType;

  if SameText(FormType, 'T2054') then
    edEFileNumber.Text := FetchElm(FRetNo, 'T2054', 89)
  else
  if SameText(FormType, 'S89') then
    edEFileNumber.Text:= FetchElm(FRetNo, 'S89', 89)
  else
  if SameText(FormType, 'T217') or LeftStr(FormType, 5).Equals('T2057') or SameText(FormType, 'T2059') then
    edEFileNumber.Text:= FetchElm(FRetNo, FormType, 59);

  lbRemaining.Caption:= Format('%.2f', [FRemainingSize / 1024 / 1024]) + ' Mb';
  FillDocType;
end;

end.
