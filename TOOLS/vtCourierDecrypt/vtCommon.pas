unit vtCommon;

// fake vtCommon, if some function are absent, they should be copied from original vtCommon

interface

uses Windows, Forms, ShellApi, Dialogs, Controls, Vcl.Graphics, System.SysUtils; //20220227 Igor

const HTTP_TimeOut = 5000;
      AllowVtClientUpdate = false;

var
  GetCurrentRetNo: integer;

function ConnectToWeb(const Url: string): Boolean;
function CopyFile(const SourceFile, DestinationFile: string): BOOLEAN;

//20220227 Igor >>>
function TColorToWeb(AColor: TColor): string;
function WebToTColor(AColor: string): TColor;
//20220227 Igor <<<

implementation


function TColorToWeb(AColor: TColor): string; //20220227 Igor
begin
  Result := '#' +
    IntToHex(GetRValue(AColor), 2) +
    IntToHex(GetGValue(AColor), 2) +
    IntToHex(GetBValue(AColor), 2);
end;

function WebToTColor(AColor: string): TColor; //20220227 Igor
var nRed, nGreen, nBlue: byte;
begin
  AColor := AColor.Replace('#', '');
  nRed := StrToIntDef('$' + Copy(AColor, 1, 2), 0);
  nGreen := StrToIntDef('$' + Copy(AColor, 3, 2), 0);
  nBlue := StrToIntDef('$' + Copy(AColor, 5, 2), 0);
  Result := Rgb(nRed, nGreen, nBlue);
end;

function ConnectToWeb(const Url: string): Boolean;
var
  h: THandle;
begin
  Result := True;
  Screen.Cursor := crHourGlass;
  h := ShellExecute(Application.MainForm.Handle, 'open', Pchar('' + Url), nil, nil, Sw_Show);
  Screen.Cursor := crDefault;
  if H <= 32 then
  begin ShowMessage('Connection failed');
    Result := False;
  end;
end;

function CopyFile(const SourceFile, DestinationFile: string): BOOLEAN;
begin
  RESULT := Windows.CopyFile(pChar(SourceFile),
    pChar(DestinationFile),
    False);
end;

end.
