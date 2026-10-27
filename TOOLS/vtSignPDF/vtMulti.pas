unit vtMulti;

// fake vtMulti, if some function are absent, they should be copied from original vtMulti

interface

uses SysUtils;

const ShowVtLoginMessage = false;

function IsvtClient: boolean;

type TApp = class
  public
    GetCourierRecipientEmail: string;
    GetCourierRecipientSalutation: string;
    GetCourierClientDocumentsFolder: string;
    function vtClientUpdateDate: string;
    function Dir_Cur: string;
    procedure SetSilentRead(Value: boolean);
    function OpenReturn(ADataDir, AFileName: string; AShow: boolean): integer;
end;

type
  TRetData = record
    SourceFlName: string;
    SourceDataDir: string;
    procedure Close(AValue: boolean);
  end;

type
  TRetList = class
  private
    function GetRet(RetNo: integer): TRetData;
  public
    property Items[RetNo: integer]: TRetData read GetRet; default;
  end;


var CurrentApp: TApp;
    RetList: TRetList;
    FIsvtClient: boolean = true; //20210304 Igor

implementation

function IsvtClient: boolean;
begin
  Result := FIsvtClient; //20210304 Igor
end;

{ TApp }

function TApp.Dir_Cur: string;
begin
  Result := '';
end;

function TApp.OpenReturn(ADataDir, AFileName: string; AShow: boolean): integer;
begin
  Result := 0;
end;

procedure TApp.SetSilentRead(Value: boolean);
begin
end;

function TApp.vtClientUpdateDate: string;
begin
  Result := '1990/01/01';
end;

{ TRetList }

function TRetList.GetRet(RetNo: integer): TRetData;
var FRetData: TRetData;
begin
  Result := FRetData;
end;

{ TRetData }

procedure TRetData.Close(AValue: boolean);
begin
end;

initialization
  CurrentApp := TApp.Create;
  RetList := TRetList.Create;

finalization
  if Assigned(CurrentApp) then
    FreeAndNil(CurrentApp);
  if Assigned(RetList) then
    FreeAndNil(RetList);

end.
