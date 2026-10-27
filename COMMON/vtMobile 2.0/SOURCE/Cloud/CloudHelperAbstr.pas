unit CloudHelperAbstr;

interface

uses
  System.Classes;
type
  TCloudFile = record
    Path: string;
    FullPath: string;
    IsDir: Boolean;
    Size: Integer;
    ServerModified: TDateTime;
    Url: string;
  end;
  TCloudFileList = array of TCloudFile;
  TGetDataBaseHeadersCallBack = reference to procedure(const AErrorMessage: string; const AList: TCloudFileList);
  TGetFileCallBack  = reference to procedure (const AErrorMessage: string; const AFile: TStream);
  TCallBackLog = procedure(const AMessage: String) of object;
  TCloudHelperAbstr = class
  public
    class function GetToken(AURL: string; out AToken: String): Boolean; virtual; abstract;
    class function AuthorizationURL(ADropBoxClientId: String): string; virtual; abstract;
    class function HelperName: string; virtual; abstract;
    class function DefaultClientID: string; virtual; abstract;
    class procedure GetDataBaseHeaders(AToken, AClientID, ACloudPath, AFile: string;
      ACallBack: TGetDataBaseHeadersCallBack); virtual; abstract;
    class procedure GetFile(AToken, AClientID: string; AWorkDownloadFile: TCloudFile;
      ACallBack: TGetFileCallBack; ACallBackLog: TCallBackLog = nil); virtual; abstract;
  end;

  TCloudHelperClass = class of TCloudHelperAbstr;
implementation

end.
