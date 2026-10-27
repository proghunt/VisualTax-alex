{***************************************************************************}
{                                                                           }
{                                                                           }
{ Unit containst TShowDocument class which implement ,                      }
{     interface IShowDocument for Windows                                   }
{                                                                           }
{***************************************************************************}
unit ShowDocumentWindows;

interface

uses ShowDocumentInterface;

type
  ///	<summary>
  ///	Class for work with user Documents
  ///	</summary>
  TShowDocument = class(TInterfacedObject, IShowDocument)
  protected
    ///	<summary>
    ///	Open file with program which assosiated with the file extension
    ///	</summary>
    /// <param name="FileName">
    ///    File for open
    ///	</param>
     procedure ShowDocument(FileName: string);
  end;

implementation

{ TShowDocument }
uses
  ActiveX, ShellApi, Windows, SysUtils;

// procedure executed standart ShellExecuteEx WinApi procedure,
// and return Windows errorcode in case of error
procedure ShellExecute(const AWnd: HWND; const AOperation, AFileName: String; const AParameters: String = ''; const ADirectory: String = ''; const AShowCmd: Integer = SW_SHOWNORMAL);
var
  ExecInfo: TShellExecuteInfo;
  NeedUninitialize: Boolean;
begin
  Assert(AFileName <> '');

  NeedUninitialize := SUCCEEDED(CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE));
  try
    FillChar(ExecInfo, SizeOf(ExecInfo), 0);
    ExecInfo.cbSize := SizeOf(ExecInfo);

    ExecInfo.Wnd := AWnd;
    ExecInfo.lpVerb := Pointer(AOperation);
    ExecInfo.lpFile := PChar(AFileName);
    ExecInfo.lpParameters := Pointer(AParameters);
    ExecInfo.lpDirectory := Pointer(ADirectory);
    ExecInfo.nShow := AShowCmd;
    ExecInfo.fMask := SEE_MASK_NOASYNC
                   or SEE_MASK_FLAG_NO_UI;
    {$IFDEF UNICODE}
    ExecInfo.fMask := ExecInfo.fMask or SEE_MASK_UNICODE;
    {$ENDIF}

    {$WARN SYMBOL_PLATFORM OFF}
    Win32Check(ShellExecuteEx(@ExecInfo));
    {$WARN SYMBOL_PLATFORM ON}
  finally
    if NeedUninitialize then
       CoUninitialize;
  end;
end;

procedure TShowDocument.ShowDocument(FileName: string);
begin
  ShellExecute(0, 'open', FileName);
end;

end.
