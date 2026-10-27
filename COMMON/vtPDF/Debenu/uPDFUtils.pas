unit uPDFUtils;

interface

uses Vcl.Dialogs, System.IOUtils, System.SysUtils, Vcl.Forms, System.UITypes,
     DebenuPDFLibrary1114, system.regularexpressions;

type
  TPDFBlockProperties = record
    succes:       boolean;
    nPage:        integer;
    nBlock:       integer;
    BottomLeftX:  double;
    BottomLeftY:  double;
    BottomRightX: double;
    BottomRightY: double;
    TopRightX:    double;
    TopRightY:    double;
    TopLeftX:     double;
    TopLeftY:     double;
    FontSize:     double;
    FontName:     string;
  end;

function  SelectPDF(out FileName: string): Boolean;
function  OpenPDF(AFileName: string; var APDF: TDebenuPDFLibrary1114): Boolean;
procedure ReWritePDF(APDF: TDebenuPDFLibrary1114; AFileName: string);
procedure SavePDF(APDF: TDebenuPDFLibrary1114; AFileName: string);
procedure ClosePDF(var APDF: TDebenuPDFLibrary1114);
function  TestDebenuLicense(const aPDF: TDebenuPDFLibrary1114): boolean;
function  FindPDFBlock(aDPL: TDebenuPDFLibrary1114; atxt: String; nPage: integer = 1; countPage: integer=0; nBlock: integer = 1): TPDFBlockProperties;
procedure WritePdfTxt(aPDF:TDebenuPDFLibrary1114; anPage: integer; X, Y: double; aTXT: string);
function  WriteTXTnextToTXT(aPDF:TDebenuPDFLibrary1114; anPage: integer; aFindTXT, aWriteTXT: String; aIndentX: double): integer;
function  LoadImgFromFileToPDF(aFileNameImg, aFileNamePDF: string; anPage: Integer; aIsLandscape: Boolean): boolean;

implementation


const
  rsPDFFilters = 'PDF files|*.pdf';
//  DebenuKey = 'j79186z33w86dc9i98zh7e34y';
//  DebenuKey = 'jj7ri6p197k4gu44n7pu98b3y';
  DebenuKey = 'j75qr68z9i95gq8jw38o55b5y';

function SelectPDF(out FileName: string): Boolean;
begin
//  Result := SelectSourceFile(FileName, rsPDFFilters, '');
end;

function OpenPDF(aFileName: string; var APDF: TDebenuPDFLibrary1114): Boolean;
begin
  if not Assigned(APDF) then
  begin
    APDF := TDebenuPDFLibrary1114.Create;
    if not TestDebenuLicense(APDF) then
    begin
      FreeAndNil(APDF);
      Exit(False);
    end;
  end;
  Result := APDF.LoadFromFile(aFileName, '') = 1;
end;

procedure ClosePDF(var APDF: TDebenuPDFLibrary1114);
begin
  APDF.Free;
  APDF := nil;
end;

procedure ReWritePDF(APDF: TDebenuPDFLibrary1114; AFileName: string);
begin
  if aPDF.AppendToFile(aFileName) = 0 then
    ShowMessage('Error save file, maybe it is open by another program')
  else
    ShowMessage('File append!');
end;

procedure SavePDF(aPDF: TDebenuPDFLibrary1114; aFileName: string);
begin
  DeleteFile(aFileName);
  if aPDF.SaveToFile(aFileName) = 0 then
    ShowMessage('Error save file, maybe it is busy with another program')
  else
    ShowMessage('File created!');
end;

function TestDebenuLicense(const aPDF: TDebenuPDFLibrary1114): Boolean;
var
  Key: string;
begin
  Result := aPDF.UnlockKey(DebenuKey) = 1;
  if not Result then
  begin
    with TTaskDialog.Create(nil) do
      try
        Title := 'DebenuPDF license not valid';
        Caption := Application.Title;
        Text := aPDF.LicenseInfo;
        CommonButtons := [];
        with TTaskDialogButtonItem(Buttons.Add) do
        begin
          Caption := 'New license';
          CommandLinkHint := 'Enter a new license';
          ModalResult := mrYes;
        end;
        with TTaskDialogButtonItem(Buttons.Add) do
        begin
          Caption := 'Cancel';
//          CommandLinkHint := 'Cancel input';
          ModalResult := mrNo;
        end;
        Flags := [tfUseCommandLinks];
        MainIcon := tdiNone;
        if Execute then
        begin
          if (ModalResult = mrYes) then
          begin
            if InputQuery(Application.Title, 'Please, enter DebenuPDF license', Key) then
              Result := aPDF.UnlockKey(Key) = 1;
          end
          else
            Exit(False);
        end
        else
          Exit(False)
      finally
        Free;
      end;

    if not Result then
      Showmessage(aPDF.LicenseInfo)
//    else
//      Settings['DebenuKey'].Value := Key;
  end;
end;

function FindPDFBlock(aDPL: TDebenuPDFLibrary1114; atxt: String; nPage: integer = 1; countPage: integer=0; nBlock: integer = 1): TPDFBlockProperties;

  function SplitWithDash(atxt: String): TArray<String>; // Разделить так, что б тире выделилось отдельным словом
  var
    W, d: TArray<String>;
    i, ld, CountDash: integer;
  begin
    CountDash := 0;
    W := tregex.Split(atxt, '\W+');  // разделяем на отдельные слова
    d := tregex.Split(atxt, '\w+');  // выделяем символы (пока интересует тире)
    ld := Length(d);
    if ld = Length(W) then
      exit(W);
    for i := 0 to ld-1 do
      if d[i] = '-' then
      begin
        SetLength(Result, Length(Result)+1);
        Result[i] := d[i];
        countDash := CountDash + 1;
      end
      else
      begin
        if (i - CountDash) < Length(W) then
        begin
          SetLength(Result, Length(Result)+1);
          Result[i] := W[i - CountDash];
        end;
      end;
  end;

  function CompareAllWord(const aPDF: TDebenuPDFLibrary1114; aid: integer; aWords: TArray<String>; anBlock, aMaxBlock: integer): boolean;
  var
    i, L: integer;
    ltxt : string;
  begin
    L := Length(aWords)-1;
    if (aMaxBlock - anBlock) < L then
      exit(false);
    for I := 1 to L do
    begin
      ltxt := aDPL.GetTextBlockText(aid, anBlock + i);
      if not SameText(aWords[i], ltxt.Trim) then
        exit(false);
    end;
    result := true;
  end;

var
  i, f, maxPage, maxBlock, id : integer;
  txt: string;
  words: TArray<String>;
begin
  Result.succes := false;
  Result.nPage  := 0;
  Result.nBlock := 0;
  Result.BottomLeftX  := 0;
  Result.BottomLeftY  := 0;
  Result.BottomRightX := 0;
  Result.BottomRightY := 0;
  Result.TopRightX    := 0;
  Result.TopRightY    := 0;
  Result.TopLeftX     := 0;
  Result.TopLeftY     := 0;
  Result.fontSize     := 0;
  Result.fontName     := '';

//  words := SplitWithDash(atxt);
  words := tregex.Split(atxt, '\s');
  maxPage := aDPL.PageCount;
  if (CountPage > 0) and ((nPage + CountPage - 1) < maxPage) then
    maxPage := nPage + CountPage - 1;
  for i := nPage to maxPage do
  begin
    if aDPL.SelectPage(i) = 1 then
    begin
      id := aDPL.ExtractPageTextBlocks(4);
      maxBlock := aDPL.GetTextBlockCount(id);
      for f := nBlock to maxBlock do
      begin
        txt := aDPL.GetTextBlockText(id, f);
        if SameText(words[0], txt.Trim) then
          if CompareAllWord(aDPL, id, words, f, maxBlock) then
          begin
            Result.nPage  := i;
            Result.nBlock := f;
            Result.succes := true;
            Result.BottomLeftX  := aDPL.GetTextBlockBound(id, f, 1);
            Result.BottomLeftY  := aDPL.GetTextBlockBound(id, f, 2);
            Result.BottomRightX := aDPL.GetTextBlockBound(id, f, 3);
            Result.BottomRightY := aDPL.GetTextBlockBound(id, f, 4);
            Result.TopRightX    := aDPL.GetTextBlockBound(id, f, 5);
            Result.TopRightY    := aDPL.GetTextBlockBound(id, f, 6);
            Result.TopLeftX     := aDPL.GetTextBlockBound(id, f, 7);
            Result.TopLeftY     := aDPL.GetTextBlockBound(id, f, 8);
            Result.fontSize     := aDPL.GetTextBlockFontSize(id, f);
            Result.fontName     := aDPL.GetTextBlockFontName(id, f);
            exit;
          end;
      end;
    end;
  end;
end;

procedure WritePdfTxt(aPDF:TDebenuPDFLibrary1114; anPage: integer; X, Y: double; aTXT: string);
begin
  aPDF.SelectPage(anPage);
  aPDF.DrawText(X, Y, aTXT);
end;

function WriteTXTnextToTXT(aPDF:TDebenuPDFLibrary1114; anPage: integer; aFindTXT, aWriteTXT: String; aIndentX: double): integer;
var
  B: TPDFBlockProperties;
begin
    B := FindPDFBlock(aPDF, aFindTXT, anPage);
    if B.succes then
    begin
      {TODO: возможно нужно будет добавить Поискать не занято ли место}

      WritePdfTxt(aPDF, anPage, B.BottomLeftX + aIndentX, B.BottomLeftY, aWriteTXT);
      Result := 0;
    end
    else
      Result := 1; // aFindTXT not found
end;

function  LoadImgFromFileToPDF(aFileNameImg, aFileNamePDF: string; anPage: Integer; aIsLandscape: Boolean): boolean;
const
  spaceX = 10;
  spaceY = 10;
var
  PDF: TDebenuPDFLibrary1114;
  imgX, imgY, imgHeight, imgWidth, AspectRatioImg, AspectRatioPage: Double;
//  PDFfileHandle, i, idImgList, imgID: integer;
begin
  PDF := TDebenuPDFLibrary1114.Create;
  try
    if not TestDebenuLicense(PDF) then
      Exit(False);

    Result := PDF.LoadFromFile(aFileNamePDF, '') = 1;
    if not Result then
      Result := PDF.NewDocument > 0;
    if Result then
      while PDF.PageCount < anPage do
      begin
        Result := PDF.NewPage > 0;
        if Not Result then
        begin
          ShowMessage('Can not Add Page '+ IntToStr(anPage));
          exit(false);
        end;
      end;

    // for delete images
    PDF.DeletePages(anPage, 1);
    PDF.InsertPages(anPage, 1);
    if aIsLandscape then
      PDF.SetPageSize('A4 Landscape')
    else
      PDF.SetPageSize('A4');

    Result := PDF.SelectPage(anPage) <> 0;
    if Not Result then
    begin
      ShowMessage('Can not Select Page '+ IntToStr(anPage));
      exit(false);
    end;

//    idImgList := PDF.GetPageImageList(0);
//    if idImgList > 0 then
//      Result := PDF.ReleaseImageList(idImgList) = 1;

   //    while PDF.GetImageListCount(idImgList) > 0 do
//       PDF.ReleaseImage(PDF.GetImageID(1));
{    for I := 1 to PDF.GetImageListCount(idImgList) do
      begin
        imgID :=  PDF.GetImageListItemIntProperty(idImgList, i, 405);
        PDF.ReleaseImage(ImgID);
      end;
}    //Result := PDF.ReleaseImageList(idImgList) = 1;

    Result := PDF.AddImageFromFile(aFileNameImg,0) <> 0;
    if not Result then
    begin
      ShowMessage('Can not Add img to file '+aFileNamePDF);
      exit(false);
    end;

    imgX := spaceX;
    imgY := PDF.PageHeight - spaceY;
    AspectRatioPage := PDF.PageWidth / PDF.PageHeight;
    AspectRatioImg  := PDF.ImageWidth / PDF.ImageHeight;

    if AspectRatioPage < AspectRatioImg then
    begin
      imgWidth  := PDF.PageWidth - spaceX * 2;
      if AspectRatioImg < 0 then
        imgHeight := imgWidth * AspectRatioImg
      else
        imgHeight := imgWidth / AspectRatioImg;
    end
    else
    begin
      imgHeight := PDF.PageHeight - spaceY * 2;
      if AspectRatioImg < 0 then
        imgWidth  := imgHeight * AspectRatioImg
      else
        imgWidth  := imgHeight / AspectRatioImg;
    end;

    Result := PDF.DrawImage(imgX, imgY, imgWidth, imgHeight) = 1;
    if not Result then
    begin
      ShowMessage('Can not Draw img');
      exit(false);
    end;
    if Result then
      Result := PDF.SaveToFile(aFileNamePDF) = 1;
    if not Result then
      ShowMessage('Can not Save img to file '+aFileNamePDF);
  finally
    FreeandNil(PDF);
  end;
end;

end.
