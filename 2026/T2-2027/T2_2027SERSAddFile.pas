unit T2_2027SERSAddFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.IOUtils,
  Vcl.Grids, System.Generics.Collections;

const
  cMaxSizeBytes = 150 * 1024 * 1024; // 20250627 Igor
  DocumentTypesShort : array[0..2] of string =
    ('01', '02', '03');
  DocumentTypesFull : array[0..2] of string =
    ('Director’s Resolution', 'Financial Notes', 'Supporting Documents');

type
  TAddFile = function(ADocumentType: integer; AFileName: string): boolean of object;

type
  TSERSAddFileT2_2027 = class(TForm)
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

uses T2_2027TrimStr, vtCommon, vtTrimStr, T2_2027Declare, T2_2027;

{$R *.DFM}

function RunSERSAddFile(AFormType: string; ARetNo: integer; ARemainingSize: int64; AAddFile: TAddFile): boolean;
var FSERSAddFileT2_2027: TSERSAddFileT2_2027;
begin
  FSERSAddFileT2_2027 := TSERSAddFileT2_2027.Create(Screen.ActiveForm);
  try
    FSERSAddFileT2_2027.FormType := AFormType;
    FSERSAddFileT2_2027.FRetNo := ARetNo;
    FSERSAddFileT2_2027.FRemainingSize := ARemainingSize;
    FSERSAddFileT2_2027.FAddFile := AAddFile;
    Result := FSERSAddFileT2_2027.ShowModal = mrOk;
  finally
    FSERSAddFileT2_2027.Free;
  end;
end;

procedure TSERSAddFileT2_2027.btnAttachClick(Sender: TObject);
var LExt: string;
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
  LExt := ExtractFileExt(edFileName.Text);
  if IsNotValidFileExtension(LExt) then
  begin
    ShowMessage(LExt + ' is not an allowable file type. The file type of the SER E-Attachment is not valid. CRA accepts the following file types for SER attachments: pdf, doc, docx, xls, xlsx, rtf, txt, jpeg, jpg, tiff, tif, xps.');
    Exit;
  end;

  if Assigned(FAddFile) then
    if FAddFile(cbDocumentType.ItemIndex, edFileName.Text) then
      ModalResult := mrOk;
end;

function TSERSAddFileT2_2027.IsNotValidFileExtension(AExt: string): Boolean;
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
  Result:= StrInArray(AExt, {arrValidExts}arrInvalidExts);
end;

function TSERSAddFileT2_2027.IsFileSymbolNotValid(aFileName: string): Boolean;
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

procedure TSERSAddFileT2_2027.btnOpenFileClick(Sender: TObject);
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
      ShowMessage('The file size: ' + FormatFloat('#,##0', lFileSize div 1024 div 1024) + ' Mb' + ' is more then 150 Mb. You can select the file that size less then 150 Mb.');
      Exit;
    end;

    if IsFileSymbolNotValid(ExtractFileName(dlgFileOpen.FileName)) then
    begin
      ShowMessage('The file name exist one or more forbidden symbols: \, /,  :,  *, ?,  “,  <,  >, |');
      Exit;
    end;

    lFileExt:= ExtractFileExt(lFileName);
    if IsNotValidFileExtension(lFileExt) then
    begin
      ShowMessage(lFileExt + ' is not an allowable file type. The file type of the SER E-Attachment is not valid. CRA accepts the following file types for SER attachments: pdf, doc, docx, xls, xlsx, rtf, txt, jpeg, jpg, tiff, tif, xps.');
      Exit;
    end else
      edFileName.Text:= dlgFileOpen.FileName;
  end;
end;
// 20250627 Igor <<<

procedure TSERSAddFileT2_2027.FillDocType;
var I: integer;
begin
  cbDocumentType.Items.Clear;
  for I := 0 to Length(DocumentTypesFull) - 1 do
    cbDocumentType.Items.Add(DocumentTypesFull[I]);
end;

procedure TSERSAddFileT2_2027.FormShow(Sender: TObject);
begin
  edNumber.Text := FetchElm(FRetNo, 'T2', 1);
  edFormType.Text := FormType;
  if SameText(FormType, 'T2054') then
    edEFileNumber.Text := FetchElm(FRetNo, 'T2054', 89)
  else if SameText(FormType, 'S89') then
    edEFileNumber.Text := FetchElm(FRetNo, 'S89', 89);
  lbRemaining.Caption := Format('%.2f', [FRemainingSize / 1024 / 1024])+' Mb';
  FillDocType;
end;

end.
