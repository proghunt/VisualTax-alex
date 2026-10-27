{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryCompliancePDFA.pas                     }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryCompliancePDFA;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryStructure, DebenuPDFLibrarySmartAccess, Classes, DebenuPDFLibraryXMP;

function CheckCompliancePDFA(InputStream: TStream; const Password: WideString;
  Options: Integer; ResultList: TStringList): Integer;

implementation

function CheckCompliancePDFA(InputStream: TStream; const Password: WideString;
  Options: Integer; ResultList: TStringList): Integer;
var
  FReader: TSmartPDFReader;
  FInfo: TSmartPDFInfo;
  FDoc: TSmartPDFDocument;
  FOkay: Boolean;
  XMP: TDebenuPDFLibraryXMP;
begin
  Result := 0;
  FOkay := False;
  FReader := TSmartPDFReader.Create(InputStream);
  try
    if FReader.ErrorCode = ecNone then
    begin
      FInfo := TSmartPDFInfo.Create(FReader, Password);
      try
        if (FInfo.Encrypted = spEncrypted) then
        begin
          if FInfo.CheckPassword(Password) then
          begin
            FOkay := True;
          end;
        end else
        if (FInfo.Encrypted = spDecrypted) then
        begin
          FOkay := True;
        end;
        if FOkay then
        begin
          FInfo.Password := Password;
          FDoc := TSmartPDFDocument.Create(FReader);
          try
            FDoc.SmartInfo := FInfo;

            if (FReader.HeaderPosition <> 0) then
            begin
              ResultList.Add('00001 File does not start with "%"');
              if (Options = 1) then FOkay := False;
            end;

            if (FOkay) then
            begin
              if (FInfo.Version > '1.4') then
              begin
                ResultList.Add('00002 PDF version greater than 1.4');
                if (Options = 1) then FOkay := False;
              end;
            end;

            if (FOkay) then
            begin
              if (FDoc.HasCatalogEntry('OCProperties')) then
              begin
                ResultList.Add('00003 OCProperties found in the Document Catalog Dictionary');
                if (Options = 1) then FOkay := False;
              end;
            end;

            if (FOkay) then
            begin
              if (FDoc.SearchForFilter('LZWDecode', True)) then
              begin
                ResultList.Add('00004 LZW filter found');
                if (Options = 1) then FOkay := False;
              end;
            end;

            if (FOkay) then
            begin
              XMP := TDebenuPDFLibraryXMP.Create;
              XMP.LoadFromString(FDoc.SmartInfo.GetMetadata);
              if XMP.PDFAID <> '1B' then
              begin
                ResultList.Add('00005 PDFA Mark NOT Found');
                FOkay := false;
              end;
            end;

            if (FOkay) then
            begin
              Result := 100;  // All tests passed
            end;
          finally
            FDoc.Free;
          end;
        end;
      finally
        FInfo.Free;
      end;
    end;
  finally
    FReader.Free;
  end;
end;

end.
