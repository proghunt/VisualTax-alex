unit uSignPDF;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls, System.Generics.Collections,
  Vcl.Menus, System.IOUtils, vtCommonPDF, {vtControllerPDF} vtImplPDF, Vcl.ComCtrls,
  Vcl.ExtDlgs, System.UITypes, Jpeg, GIFImg, PngImage, vtVirtualTaxOffice,
  vtCommon, vtCourier, vtMulti; //20210308 Igor


type
  TShape = class(ExtCtrls.TShape)
  protected
    ShapeMove: boolean;
    ShapeSize: boolean;
    OldX: integer;
    OldY: integer;
    procedure Paint; override;
  public
    IsPreview: boolean;
    constructor Create(AOwner: TComponent); override;
  end;

type
  TSignPDF = class(TForm)
    pnlCaption: TPanel;
    OpenPDFDialog: TOpenDialog;
    pnlHeader: TPanel;
    pnlPreview: TPanel;
    PreviewImage: TImage;
    SignatureImage: TImage;
    OpenSignatureDialog: TOpenPictureDialog;
    btnPrevPage: TSpeedButton;
    btnNextPage: TSpeedButton;
    lbCurrentPage: TLabel;
    lbPage: TLabel;
    shDelimiter: TShape;
    shSignaturePreview: TShape;
    btnAddSignature: TSpeedButton;
    shSignature: TShape;
    btnOpen: TSpeedButton;
    btnSelectSignature: TSpeedButton;
    btnSave: TSpeedButton;
    SavePDFDialog: TSaveDialog;
    cbKeepAspectRatio: TCheckBox;
    btnHelp: TSpeedButton;
    btnSaveAndEmail: TSpeedButton;
    pnlWarning: TPanel;
    lbWarning: TLabel;
    btnHowToCreate: TSpeedButton;
    shSignatureDate: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOpenClick(Sender: TObject);
    procedure pnlPreviewResize(Sender: TObject);
    procedure btnSelectSignatureClick(Sender: TObject);
    procedure btnPrevPageClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure btnAddSignatureClick(Sender: TObject);

    procedure shSignatureMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shSignatureMouseLeave(Sender: TObject);
    procedure shSignatureMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure shSignatureMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSaveClick(Sender: TObject);
    procedure cbKeepAspectRatioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnSaveAndEmailClick(Sender: TObject);//20210308 Igor
    procedure btnHowToCreateClick(Sender: TObject); //20210322 Igor
  private
    { Private declarations }
    FPDF: TvtPDF;
    FCurrDPI: integer;
    FSignatureFileName: string;
    FCurrentDocumentId: integer;
    FSignaturePreviewHeight: integer;
    FImageId: integer;
    FCurrPage: integer;
    FTotalPages: integer;
    FNeedRecalcDPI: boolean;
    FLastEmail: string; //20210322 Igor
    //20210326 Igor >>>
    FSignatureDate: String;
    FTextStream: Integer;
    //20210326 Igor <<<

    procedure RefreshPreview;
    procedure RefreshSignaturePreview;
    procedure UpdatePages;
    procedure DrawSignature;
    //20210322 Igor >>>
    function GetTaxPayerCyberId: string; 
    procedure UpdateEnabledButtons;
    //20210322 Igor <<<
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;//20210326 Igor
    //20210330 Igor >>>
    procedure SetNeedRecalcDPI(const Value: boolean);     
    property NeedRecalcDPI: boolean read FNeedRecalcDPI write SetNeedRecalcDPI;
    //20210330 Igor <<<
  public
    { Public declarations }
  end;

var
  FSignPDF: TSignPDF;

procedure RunVtPDF;

implementation

{$R *.DFM}

procedure RunVtPDF;
var
  FSignPDF: TSignPDF;
begin
  FSignPDF := TSignPDF.Create(Application);
  try
    FSignPDF.ShowModal;
  finally
    FSignPDF.Free;
  end;
end;

{ TSignPDF }

procedure TSignPDF.btnHelpClick(Sender: TObject); //20210308 Igor
begin
  ConnectToWeb('https://www.visualtax.com/vtSignPDF.php');
end;

procedure TSignPDF.btnHowToCreateClick(Sender: TObject); //20210322 Igor
begin
  ConnectToWeb('https://visualtax.com/vtSignatureCreate.php');
end;

procedure TSignPDF.btnNextPageClick(Sender: TObject);
begin
  if FCurrPage < FTotalPages then
  begin
    inc(FCurrPage);
    FPDF.SelectPage(FCurrPage);
    UpdatePages;
    NeedRecalcDPI := true; //20210330 Igor
    RefreshPreview;
  end;
end;

procedure TSignPDF.btnOpenClick(Sender: TObject); //20210322 Igor
var cFileName, cEncryptedFileName, cTaxPayerCyberId, cPassword: string;
    nPasswordId: integer;
begin
  try
    OpenPDFDialog.InitialDir := VirtualTaxOfficeInfo.ReadClientDocs; //20210205 Igor
    if not OpenPDFDialog.Execute then Exit;
    //20210322 Igor >>>
    cFileName := OpenPDFDialog.FileName;
    if SameText(ExtractFileExt(cFileName), '.encrypted') then
    begin
      cTaxPayerCyberId := GetTaxPayerCyberId;
      if cTaxPayerCyberId.IsEmpty then Exit;
      cEncryptedFileName := Copy(cFileName, 1, Length(cFileName) - 10);
      cPassword := '';
      nPasswordId := 0;
      if not VirtualTaxOfficeInfo.GetEncrPsw(cTaxPayerCyberId, cPassword, nPasswordId, false) then Exit;
      if not DecryptFile(cPassword, cFileName, cEncryptedFileName) then
      begin
        ShowMessage('File "'+ cFileName + '" was not decrypted. Make sure that you enter correct password');
        if FileExists(cEncryptedFileName) then
          DeleteFile(PChar(cEncryptedFileName));
        Exit;
      end;
      DeleteFile(PChar(cFileName));
      VirtualTaxOfficeInfo.DecFileEncrPsw(nPasswordId);
      OpenPDFDialog.FileName := cEncryptedFileName;
    end;
    //20210322 Igor <<<
    if FCurrentDocumentId >= 0 then
    begin
      FPDF.CloseDocument(FCurrentDocumentId);
      FCurrentDocumentId := -1;
      FCurrPage := 0;
      FTotalPages := 0;
      UpdatePages;
    end;
    if FPDF.OpenFile(OpenPDFDialog.FileName) then
    begin
      FCurrentDocumentId := FPDF.SelectedDocument;
      FCurrPage := FPDF.SelectedPage;
      FTotalPages := FPDF.PageCount;
      UpdatePages;
    end;
  finally
    RefreshPreview;
  end;
end;

procedure TSignPDF.btnPrevPageClick(Sender: TObject);
begin
  if FCurrPage > 1 then
  begin
    inc(FCurrPage, -1);
    FPDF.SelectPage(FCurrPage);
    UpdatePages;
    NeedRecalcDPI := true; //20210330 Igor
    RefreshPreview;
  end;
end;

procedure TSignPDF.btnSaveAndEmailClick(Sender: TObject); //20210308 Igor
var A: TArray<string>;
    cTaxPayerCyberId, cEmail: string;
begin
  if FCurrentDocumentId = -1 then
  begin
    ShowMessage('There is nothing to save');
    Exit;
  end;
  cTaxPayerCyberId := GetTaxPayerCyberId; //20210322 Igor
  if cTaxPayerCyberId.IsEmpty then Exit;
  SavePDFDialog.InitialDir := VirtualTaxOfficeInfo.ReadClientDocs;
  SavePDFDialog.FileName := ExtractFileName(OpenPDFDialog.FileName);
  if not SavePDFDialog.Execute then Exit;
  if FileExists(SavePDFDialog.FileName) then
    DeleteFile(PChar(SavePDFDialog.FileName));
  if FPDF.SaveFile(SavePDFDialog.FileName) then
  begin
    SetLength(A, 1);
    A[0] := SavePDFDialog.FileName;
    //20210322 Igor >>>
    //RunCourier(cTaxPayerCyberId, A);
    SendEncryptedEmail(cTaxPayerCyberId,
        'vtCourier-Forms Signed–'+
        VirtualTaxOfficeInfo.GetCurrentName +
        '-'+
        FormatDateTime('yyyy-mm-dd', Now) +' Time: '+ FormatDateTime('hh:nn:ss', Now), A);
    //20210322 Igor <<<
  end
  else
    MessageDlg('File was not saved due to internal error', mtWarning, [mbOk], 0)

end;

procedure TSignPDF.btnSaveClick(Sender: TObject);
begin
  if FCurrentDocumentId = -1 then
  begin
    ShowMessage('There is nothing to save');
    Exit;
  end;
  SavePDFDialog.InitialDir := VirtualTaxOfficeInfo.ReadClientDocs; //20210205 Igor
  SavePDFDialog.FileName := ExtractFileName(OpenPDFDialog.FileName);
  if not SavePDFDialog.Execute then Exit;
  if FileExists(SavePDFDialog.FileName) then
    DeleteFile(PChar(SavePDFDialog.FileName));
  if FPDF.SaveFile(SavePDFDialog.FileName) then
    MessageDlg('File was successfully saved!', mtInformation, [mbOk], 0)
  else
    MessageDlg('File was not saved due to internal error', mtWarning, [mbOk], 0)
end;

procedure TSignPDF.btnSelectSignatureClick(Sender: TObject);
begin
  OpenSignatureDialog.InitialDir := VirtualTaxOfficeInfo.ReadClientDocs; //20210205 Igor
  if not OpenSignatureDialog.Execute then Exit;
  FSignatureFileName := OpenSignatureDialog.FileName;
  VirtualTaxOfficeInfo.SaveOption('LastUsedSignature', FSignatureFileName);
  RefreshSignaturePreview;
end;

procedure TSignPDF.btnAddSignatureClick(Sender: TObject); //20210322 Igor
begin
  if not shSignature.Visible and (FCurrentDocumentId = -1) then
  begin
    ShowMessage('Please, open PDF document first!');
    Exit;
  end;
  shSignature.Visible := not shSignature.Visible;
  shSignatureDate.Visible := shSignature.Visible; //20210326 Igor

  if shSignature.Visible then
  begin
    btnAddSignature.Caption := 'Remove signature';
    shSignature.Width := shSignaturePreview.Width;
    shSignature.Height := shSignaturePreview.Height;
    if shSignature.Left < PreviewImage.Left then
      shSignature.Left := PreviewImage.Left
    else if shSignature.Left + shSignature.Width > PreviewImage.Left + PreviewImage.Width then
      shSignature.Left := PreviewImage.Left + PreviewImage.Width - shSignature.Width;

    //20210326 Igor >>>
    shSignatureDate.Top := shSignature.Top;
    shSignatureDate.Left := shSignature.Left + shSignature.Width;
    if shSignatureDate.Left + shSignatureDate.Width > PreviewImage.Left + PreviewImage.Width then
      shSignatureDate.Left := PreviewImage.Left + PreviewImage.Width - shSignatureDate.Width;
    FSignatureDate := FormatDateTime('yyyy-mm-dd', Date);
    //20210326 Igor <<<

  end
  else
    btnAddSignature.Caption := 'Add signature to document';
  RefreshSignaturePreview;
end;

procedure TSignPDF.cbKeepAspectRatioClick(Sender: TObject);
var nHeight: integer;
begin
  if cbKeepAspectRatio.Checked and shSignature.Visible then
  begin
    nHeight := Trunc(shSignature.Width * SignatureImage.Picture.Height / SignatureImage.Picture.Width);
    if shSignature.Height <> nHeight then
    begin
      shSignature.Height := nHeight;
      RefreshPreview;
    end;
  end;
end;

procedure TSignPDF.CMDialogKey(var Message: TCMDialogKey);
begin
  if not (Message.CharCode in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN]) then
    inherited;
end;

procedure TSignPDF.DrawSignature;
var pt: TPoint;
    nSignTop, nSignLeft, nSignWidth, nSignHeight: integer;
begin
  if not Assigned(FPDF) then Exit;
  if FCurrentDocumentId = -1 then Exit;
  if FImageId <> -1 then
    FPDF.ClearImage(FImageId);
  //20210326 Igor >>>
  if FTextStream >= 0 then
  begin
    FPDF.ClearText(FTextStream);
    FTextStream := -1;
  end;
  //20210326 Igor <<<

  if shSignature.Visible and not FSignatureFileName.IsEmpty then
  begin
    FImageId := FPDF.AddImageFromFile(FSignatureFileName);
    if FPDF.SelectImage(FImageId) then
    begin
        //20210326 Igor Not used
//      pt := Mouse.CursorPos;
//      pt := PreviewImage.ScreenToClient(pt);


      nSignTop := PreviewImage.Height - shSignature.Top;
      nSignLeft := shSignature.Left - PreviewImage.Left;

      nSignTop := Trunc(nSignTop / FCurrDPI * 72);
      nSignLeft := Trunc(nSignLeft / FCurrDPI * 72);
      nSignWidth := Trunc(shSignature.Width / FCurrDPI * 72);
      nSignHeight := Trunc(shSignature.Height / FCurrDPI * 72);

      if not FPDF.DrawImage(nSignLeft, nSignTop, nSignWidth, nSignHeight) then
        ShowMessage('Error on drawing image');
      //20210326 Igor >>> Draw signature date
      nSignTop := PreviewImage.Height - shSignatureDate.Top;
      nSignLeft := shSignatureDate.Left - PreviewImage.Left;

      nSignTop := Trunc(nSignTop / FCurrDPI * 72);
      nSignLeft := Trunc(nSignLeft / FCurrDPI * 72);
      nSignWidth := Trunc(shSignatureDate.Width / FCurrDPI * 72);
      nSignHeight := Trunc(shSignatureDate.Height / FCurrDPI * 72);

      FTextStream := FPDF.DrawTextBox(nSignLeft, nSignTop, nSignWidth, nSignHeight, FSignatureDate);
      //20210326 Igor >>>
    end;
  end;
end;

procedure TSignPDF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FPDF) then
    FPDF.Free;
end;

procedure TSignPDF.FormCreate(Sender: TObject);
begin
  FCurrentDocumentId := -1;
  FImageId := -1;
  FCurrDPI := 72;
  {if not Assigned(PDF_Create) then
    LoadVtPDF;
  if not Assigned(PDF_Create) then
    raise Exception.Create('vtPDF module is not loaded');
  FPDF := PDF_Create();}
  FPDF := TvtImplPDF.Create;
  FSignaturePreviewHeight := SignatureImage.Height;
  FCurrPage := 0;
  FTotalPages := 0;
  UpdatePages;
  shSignature.IsPreview := true;
  FSignatureFileName := VirtualTaxOfficeInfo.ReadOption('LastUsedSignature');
  //20210326 Igor >>>
  shSignatureDate.IsPreview := true;
  FTextStream := -1;
  //20210326 Igor <<<
  RefreshSignaturePreview;
end;

procedure TSignPDF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var nInc: integer;
begin
  if shSignature.Visible then
  begin
    if ssCtrl in Shift then
      nInc := 10
    else if ssAlt in Shift then
      nInc := 5
    else
      nInc := 1;
    if Key = VK_UP then
      shSignature.Top := shSignature.Top - nInc
    else if Key = VK_DOWN then
      shSignature.Top := shSignature.Top + nInc
    else if Key = VK_LEFT then
      shSignature.Left := shSignature.Left - nInc
    else if Key = VK_RIGHT then
      shSignature.Left := shSignature.Left + nInc
    else
      Exit;
    RefreshPreview;
  end;
end;

procedure TSignPDF.FormShow(Sender: TObject);
begin
  RefreshSignaturePreview; //20210322 Igor
end;

function TSignPDF.GetTaxPayerCyberId: string; //20210322 Igor
begin
  Result := '';
  if VirtualTaxOfficeInfo.AccountType = vtoPayer then
  begin
    Result := VirtualTaxOfficeInfo.CyberId;
    CurrentApp.GetCourierRecipientEmail := VirtualTaxofficeInfo.TaxOffice.Email;
  end
  else
  begin
    FLastEmail := '';
    if not InputQuery('Enter Virtual Client Email', 'Virtual Client Email', FLastEmail) then Exit;
    Result := VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(FLastEmail);
    CurrentApp.GetCourierRecipientEmail := FLastEmail;
  end;
end;

procedure TSignPDF.pnlPreviewResize(Sender: TObject);
begin
  NeedRecalcDPI := true; //20210330 Igor
  RefreshPreview;
end;

procedure TSignPDF.RefreshPreview;
var MS: TMemoryStream;
    BM: TBitmap;
begin
  UpdateEnabledButtons; //20210322 Igor
  if FCurrentDocumentId = -1 then Exit;
  //20210330 Igor >>>
  if not FNeedRecalcDPI then
    DrawSignature;
  //20210330 Igor <<<
  PreviewImage.Left := 0;
  PreviewImage.Top := 0;
  if Assigned(FPDF) then
  begin
    MS := TMemoryStream.Create;
    try
      if FNeedRecalcDPI then
      begin
        FPDF.SetDPI(72);
        FPDF.RenderPageToStream(MS);
        MS.Seek(0, soFromBeginning);
        BM := TBitmap.Create;
        try
          BM.LoadFromStream(MS);
          FCurrDPI := Trunc(72 * pnlPreview.Height / BM.Height);
          FPDF.SetDPI(FCurrDPI);
        finally
          BM.Free;
        end;
        MS.Seek(0, soFromBeginning);
        MS.Clear;
        NeedRecalcDPI := false; //20210330 Igor
      end;
      FPDF.RenderPageToStream(MS);
      MS.Seek(0, soFromBeginning);
      BM := TBitmap.Create;
      try
        BM.LoadFromStream(MS);
        PreviewImage.Picture.Assign(BM);
        PreviewImage.Height := BM.Height;
        PreviewImage.Width := BM.Width;
        PreviewImage.Left := (pnlPreview.Width - BM.Width) div 2;
      finally
        BM.Free;
      end;
    finally
      MS.Free;
    end;
  end;
end;

procedure TSignPDF.RefreshSignaturePreview; //20210322 Igor
begin
  shSignaturePreview.Visible := false;
  if FSignatureFileName.IsEmpty then
    SignatureImage.Picture := nil
  else
  begin
    pnlWarning.Visible := false;
    SignatureImage.Picture.LoadFromFile(FSignatureFileName);
    SignatureImage.Width := Trunc(FSignaturePreviewHeight * SignatureImage.Picture.Width / SignatureImage.Picture.Height);
    SignatureImage.Height := FSignaturePreviewHeight;
    btnSelectSignature.Left := SignatureImage.Left + SignatureImage.Width + 10;
    btnAddSignature.Left := btnSelectSignature.Left;
    btnHelp.Left := btnAddSignature.Left + btnAddSignature.Width - btnHelp.Width;
    cbKeepAspectRatio.Left := btnSelectSignature.Left;
    shSignaturePreview.Left := SignatureImage.Left;
    shSignaturePreview.Top := SignatureImage.Top;
    shSignaturePreview.Width := SignatureImage.Width;
    shSignaturePreview.Height := SignatureImage.Height;
    shSignaturePreview.Visible := true;
    btnAddSignature.Visible := true;
    cbKeepAspectRatio.Visible := true;
  end;
  RefreshPreview;
end;

procedure TSignPDF.SetNeedRecalcDPI(const Value: boolean); //20210330 Igor
begin
  FNeedRecalcDPI := Value;
  if FNeedRecalcDPI then
    RefreshPreview;
end;

procedure TSignPDF.shSignatureMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if (X >= TShape(Sender).Width - 10) and (X <= TShape(Sender).Width)
     and
     (Y >= TShape(Sender).Height - 10) and (Y <= TShape(Sender).Height) then
    TShape(Sender).ShapeSize := true
  else
    TShape(Sender).ShapeMove := true;
  TShape(Sender).OldX := X;
  TShape(Sender).OldY := Y;
end;

procedure TSignPDF.shSignatureMouseLeave(Sender: TObject);
begin
  if Screen.Cursor <> crDefault then
    Screen.Cursor := crDefault;
end;

procedure TSignPDF.shSignatureMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var nWidth, nHeight: integer;
begin
  if not TShape(Sender).ShapeMove and not TShape(Sender).ShapeSize then
  begin
    if (X >= TShape(Sender).Width - 10) and (X <= TShape(Sender).Width)
       and
       (Y >= TShape(Sender).Height - 10) and (Y <= TShape(Sender).Height) then
      Screen.Cursor := crSizeNWSE
    else if Screen.Cursor <> crDefault then
      Screen.Cursor := crDefault;
    Exit;
  end;
  if TShape(Sender).ShapeMove then
  begin
    TShape(Sender).Left := TShape(Sender).Left + (X - TShape(Sender).OldX);
    TShape(Sender).Top := TShape(Sender).Top + (Y - TShape(Sender).OldY);
  end
  else if TShape(Sender).ShapeSize then
  begin
    if cbKeepAspectRatio.Checked then
    begin
      nWidth := TShape(Sender).Width + (X - TShape(Sender).OldX);
      if nWidth < 10 then
        nWidth := 10;
      nHeight := Trunc(nWidth * SignatureImage.Picture.Height / SignatureImage.Picture.Width);
      TShape(Sender).Width := nWidth;
      TShape(Sender).Height := nHeight;
    end
    else
    begin
      TShape(Sender).Width := TShape(Sender).Width + (X - TShape(Sender).OldX);
      TShape(Sender).Height := TShape(Sender).Height + (Y - TShape(Sender).OldY);
      if TShape(Sender).Width < 10 then
        TShape(Sender).Width := 10;
      if TShape(Sender).Height < 10 then
        TShape(Sender).Height := 10;
    end;
    TShape(Sender).OldX := X;
    TShape(Sender).OldY := Y;
  end;
end;

procedure TSignPDF.shSignatureMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TShape(Sender).ShapeMove := false;
  TShape(Sender).ShapeSize := false;
  RefreshPreview;
end;

procedure TSignPDF.UpdateEnabledButtons; //20210322 Igor
begin
  btnSave.Enabled := FCurrentDocumentId <> -1;
  btnSaveAndEmail.Enabled := btnSave.Enabled;
  btnPrevPage.Enabled := btnSave.Enabled;
  btnNextPage.Enabled := btnSave.Enabled;
  lbPage.Enabled := btnSave.Enabled;
  lbCurrentPage.Enabled := btnSave.Enabled;
  btnAddSignature.Enabled := btnSave.Enabled;
end;

procedure TSignPDF.UpdatePages;
begin
  lbCurrentPage.Caption := IntToStr(FCurrPage) + ' / ' + IntToStr(FTotalPages);
  btnPrevPage.Enabled := FCurrPage > 1;
  btnNextPage.Enabled := FCurrPage < FTotalPages;
end;

{ TShape }

constructor TShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsPreview := false;
end;

procedure TShape.Paint;
var FPenStyle: TPenStyle;
    FPenWidth: integer;
begin
  inherited;
  if not IsPreview then Exit;
  FPenStyle := Pen.Style;
  FPenWidth := Pen.Width;
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 2;
  Canvas.Rectangle(Width - 5, Height - 5, Width, Height);
  Canvas.Pen.Style := FPenStyle;
  Canvas.Pen.Width := FPenWidth;
end;

end.
