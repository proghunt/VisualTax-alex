{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryFileSpec.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryFileSpec;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryStructure;

type
  TQPLFileSpec = class
  private
    FSource: TPDFObject;
  public
    constructor Create(Source: TPDFObject);
    function ValidFileSpec: Boolean;
    function IsSimpleFileSpec: Boolean;
    function GetFileSystem: AnsiString;
    procedure SetFileSystem(const NewFileSystem: AnsiString);
    function GetURL: WideString;
    procedure SetURL(const NewURL: WideString);
  end;

implementation

uses
  DebenuPDFLibraryEncoding;

{ TQPLFileSpec }

constructor TQPLFileSpec.Create(Source: TPDFObject);
begin
  if (Source is TPDFDictionary) or (Source is TPDFString) then
  begin
    FSource := Source;
  end else
  begin
    FSource := nil;
  end;
end;

function TQPLFileSpec.GetFileSystem: AnsiString;
var
  Obj: TPDFObject;
begin
  Result := '';
  if FSource is TPDFDictionary then
  begin
    Obj := TPDFDictionary(FSource).FindValueByKeyName('FS', True);
    if Obj is TPDFName then
    begin
      Result := TPDFName(Obj).Name;
    end;
  end;
end;

function TQPLFileSpec.GetURL: WideString;
var
  Obj: TPDFObject;
begin
  Result := '';
  if FSource is TPDFString then
  begin
    Result := TPDFString(FSource).AsTextString;
  end else
  if FSource is TPDFDictionary then
  begin
    Obj := TPDFDictionary(FSource).FindValueByKeyName('F', True);
    if Obj is TPDFString then
    begin
      Result := TPDFString(Obj).AsTextString;
    end;
  end;
end;

function TQPLFileSpec.IsSimpleFileSpec: Boolean;
begin
  Result := FSource is TPDFString;
end;

procedure TQPLFileSpec.SetFileSystem(const NewFileSystem: AnsiString);
var
  Obj: TPDFObject;
begin
  if FSource is TPDFDictionary then
  begin
    Obj := TPDFDictionary(FSource).FindValueByKeyName('FS', True);
    if Obj is TPDFName then
    begin
      TPDFName(Obj).SetTo(NewFileSystem);
    end else
    begin
      TPDFDictionary(FSource).Add('FS', FSource.Owner.NewName(NewFileSystem));
    end;
  end;
end;

procedure TQPLFileSpec.SetURL(const NewURL: WideString);
var
  Obj: TPDFObject;
begin
  if (FSource is TPDFString) then
  begin
    TPDFString(FSource).SetTo(QPLEncodePDFDoc(NewURL));
  end else
  if (FSource is TPDFDictionary) then
  begin
    if (GetFileSystem <> 'URL') then
    begin
      SetFileSystem('URL');
    end;
    TPDFDictionary(FSource).PurgeKey('UF');
    Obj := TPDFDictionary(FSource).FindValueByKeyName('F', True);
    if Obj is TPDFString then
    begin
      TPDFString(Obj).SetTo(QPLEncodePDFDoc(NewURL));
    end else
    begin
      TPDFDictionary(FSource).Add('F', FSource.Owner.NewString(QPLEncodePDFDoc(NewURL)));
    end;
  end;
end;

function TQPLFileSpec.ValidFileSpec: Boolean;
begin
  Result := (FSource is TPDFString) or (FSource is TPDFDictionary);
end;

end.
