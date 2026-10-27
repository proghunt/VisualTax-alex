unit uMain;

//20201208 Igor a lot of changes

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, Data.DB,
  uADCompDataSet, uADCompClient, Bde.DBTables, uADStanExprFuncs, uADPhysSQLite,
  uADGUIxFormsWait, uADCompGUIx, Vcl.ExtCtrls, Vcl.DBCtrls,
  IdHTTP, IdSSLOpenSSL, IdSSLOpenSSLHeaders, Data.DBXJSON, HTTPApp, Vcl.ComCtrls,
  ComObj, ActiveX;

const
  VirtualTaxOfficeUrl = 'http://www.visualtaxcloud.com/api.php';
  ADMIN_PARAM = 'Microsophic=Igor';

type
  TVirtualTaxOfficeAccountType = (vtoNone, vtoOffice, vtoPayer);
  TRequestType = (rtGet, rtPost);

type
  TImportThread = class;
  TfMain = class(TForm)
    OpenClientsDBFDialog: TOpenDialog;
    pnlHeader: TPanel;
    btnUpdateTaxOffices: TButton;
    pnlProgress: TPanel;
    pbProgress: TProgressBar;
    btnCancelThread: TButton;
    btnLoadEfilers: TButton;
    OpenExcelDialog: TOpenDialog;
    lbInfo: TLabel;
    procedure btnShowTaxOfficesClick(Sender: TObject);
    procedure btnUpdateTaxOfficesClick(Sender: TObject);
    procedure btnCancelThreadClick(Sender: TObject);
    procedure btnLoadEfilersClick(Sender: TObject);
  private
    { Private declarations }
    FImportThread: TImportThread;
    procedure ProcessError(AError: string);
    procedure ProcessFinish;
    procedure ThreadStart;
    procedure ThreadFinish;
    procedure SetPosition(const Value: integer);
  public
    { Public declarations }
    property Position: integer write SetPosition;
  end;

  TImportThread = class(TThread)
    private
      FForm: TfMain;
      FFileName: string;
    protected
      procedure Execute; override;
      procedure LoadClientsDBF;
      procedure LoadEfilers;
      constructor Create(AFileName: string; AForm: TfMain);
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

function RandomStr(ALen: Integer; AChars: string): string;
begin
  Randomize;
  Result := '';
  repeat
    Result := Result + AChars[Random(Length(AChars)) + 1];
  until (Length(Result) = ALen)
end;

function RequestToVirtualTaxOffice(AParams: TStringList; AType: TRequestType = rtPost; ASilent: boolean = false): TJSONObject;
var
  HTTP: TIdHTTP;
  cResult, cErrorMessage, cParams: string;
  I: integer;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := nil;
  HTTP := TIdHTTP.Create;
//  HTTP.ConnectTimeout := HTTP_TimeOut * 5;
//  HTTP.ReadTimeout := HTTP_TimeOut * 5;
  HTTP.AllowCookies := true;
  HTTP.Request.UserAgent := 'Mozilla/3.0';
//  HTTP.CookieManager := FCookieManager;
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  if not ASilent then
    Screen.Cursor := crHourGlass;
  try
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    try
      case AType of
        rtGet:
          begin
            cParams := '';
            for I := 0 to AParams.Count - 1 do
            begin
              if not cParams.IsEmpty then
                cParams := cParams + '&';
              cParams := cParams + String(HTTPEncode(AnsiString(AParams.Names[I]))) + '=' + String(HTTPEncode(AnsiString(AParams.ValueFromIndex[I])));
            end;
            if not cParams.IsEmpty then
              cParams := '?' + cParams;
            cResult := HTTP.Get(VirtualTaxOfficeUrl + cParams);
          end;
        rtPost:
          cResult := HTTP.Post(VirtualTaxOfficeUrl, AParams);
        else Exit;
      end;
      Result := TJSONObject(TJSONObject.ParseJSONValue(cResult));
      if not Assigned(Result) then
        raise Exception.Create('Wrong JSON package');
    except on E: Exception do
      begin
        if not ASilent then
          Screen.Cursor := crDefault;
        cErrorMessage := E.Message;
        if not cResult.IsEmpty then
          cErrorMessage := cErrorMessage + sLineBreak + sLineBreak + cResult;
        if ASilent then
          raise  Exception.Create(cErrorMessage)
        else
          ShowMessage(cErrorMessage);
      end;
    end;
  finally
    if not ASilent then
      Screen.Cursor := crDefault;
    HTTP.Free;
    IdSSLIOHandlerSocket.Free;
  end;
end;


procedure TfMain.btnLoadEfilersClick(Sender: TObject);
begin
  if Assigned(FImportThread) then Exit;
  if not OpenExcelDialog.Execute then Exit;
  FImportThread := TImportThread.Create(OpenExcelDialog.FileName, Self);
  ThreadStart;
end;

procedure TfMain.btnShowTaxOfficesClick(Sender: TObject);
var FParams: TStringList;
    Res, Row: TJSONObject;
    Values: TJSONArray;
    ArrayElement: TJSONValue;
begin
  FParams := TStringList.Create;
  try
    FParams.Add('action=LIST_OFFICES');
    FParams.Add(ADMIN_PARAM);
    Res := RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(Res.Get('success').JSONValue.Value, 'true') then
      begin
        Values := TJSONArray(Res.Get('result').JSONValue);
        if Assigned(Values) then
        begin
          for ArrayElement in Values do
            if Assigned(ArrayElement) then
            begin
              Row := TJSONObject(ArrayElement);
              ShowMessage(Row.Get('CyberId').JSONValue.Value);
            end;
        end;
      end
      else
        ShowMessage(Res.Get('error_message').JSONValue.Value);
    end;
  finally
    FParams.Free;
  end;
end;

procedure TfMain.btnUpdateTaxOfficesClick(Sender: TObject);
begin
  if Assigned(FImportThread) then Exit;
  if not OpenClientsDBFDialog.Execute then Exit;
  FImportThread := TImportThread.Create(OpenClientsDBFDialog.FileName, Self);
  ThreadStart;
end;

procedure TfMain.btnCancelThreadClick(Sender: TObject);
begin
  FImportThread.Terminate;
  FImportThread := nil;
  ThreadFinish;
end;

procedure TfMain.ProcessError(AError: string);
begin
  FImportThread.Terminate;
  FImportThread := nil;
  ShowMessage(AError);
  ThreadFinish;
end;

procedure TfMain.ProcessFinish;
begin
  if Assigned(FImportThread) then
  begin
    FImportThread.Terminate;
    FImportThread := nil;
    ShowMessage('File was successfully imported to Virtual Tax Office database');
    ThreadFinish;
  end;
end;


procedure TfMain.SetPosition(const Value: integer);
begin
  pbProgress.Position := Value;
  lbInfo.Caption := 'Record '+ IntToStr(Value) + ' of ' + IntToStr(pbProgress.Max);
end;

procedure TfMain.ThreadFinish;
var I: integer;
begin
  for I := 0 to pnlHeader.ControlCount - 1 do
  begin
    if pnlHeader.Controls[I] is TButton then
      TButton(pnlHeader.Controls[I]).Enabled := true;
    if pnlHeader.Controls[I] is TSpeedButton then
      TSpeedButton(pnlHeader.Controls[I]).Enabled := true;
    if pnlHeader.Controls[I] is TEdit then
      TEdit(pnlHeader.Controls[I]).Enabled := true;
  end;
  pnlProgress.Visible := false;
end;

procedure TfMain.ThreadStart;
var I: integer;
begin
  for I := 0 to pnlHeader.ControlCount - 1 do
  begin
    if pnlHeader.Controls[I] is TButton then
      TButton(pnlHeader.Controls[I]).Enabled := false;
    if pnlHeader.Controls[I] is TSpeedButton then
      TSpeedButton(pnlHeader.Controls[I]).Enabled := false;
    if pnlHeader.Controls[I] is TEdit then
      TEdit(pnlHeader.Controls[I]).Enabled := false;
  end;
  pnlProgress.Visible := true;
end;

{ TImportThread }

constructor TImportThread.Create(AFileName: string; AForm: TfMain);
begin
  FFileName := AFileName;
  FForm := AForm;
  inherited Create(false);
end;

procedure TImportThread.Execute;
begin
  inherited;
  if UpperCase(FFileName).EndsWith('.DBF') then
    LoadClientsDBF
  else
    LoadEfilers;
end;

procedure TImportThread.LoadClientsDBF;
var FQuery: TQuery;
    FCyberId: string;
    FParams: TStringList;
    Res: TJSONObject;
    IsNew: boolean;
    I: integer;

    function GetYN(AValue: string): string;
    begin
      if Trim(AValue).IsEmpty then
        Result := 'N'
      else
        Result := 'Y';
    end;
begin
  try
    Synchronize(
      procedure
      begin
        FForm.Position := 0;
        FForm.lbInfo.Caption := 'Opening ' + FFileName;
      end
    );
    FParams := TStringList.Create;
    FQuery := TQuery.Create(nil);
    try
      FQuery.DatabaseName := ExtractFilePath(FFileName);
      FQuery.SQL.Text := 'SELECT * FROM Clients';
      FQuery.Prepare;
      FQuery.Open;
      Synchronize(
        procedure
        begin
          FForm.pbProgress.Max := FQuery.RecordCount;
        end
      );
      I := 0;
      IsNew := false;
      while not FQuery.Eof and not Terminated do
      begin
        FParams.Clear;
        FParams.Add('action=REGISTER_OFFICE');
        FParams.Add(ADMIN_PARAM);
        FParams.Add('BusinessName='+ FQuery.FieldByName('Name').Value);
        FParams.Add('Password='+ RandomStr(12, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'));
        Res := RequestToVirtualTaxOffice(FParams, rtPost, true);
        if Assigned(Res) then
        begin
          if SameText(Res.Get('success').JSONValue.Value, 'true')
             or
             SameText(Res.Get('type').JSONValue.Value, 'already_registered') then
          begin
            FCyberId := Res.Get('cyberid').JSONValue.Value;
            IsNew := SameText(Res.Get('success').JSONValue.Value, 'true');
          end
          else
          begin
            Synchronize(
              procedure
              begin
                FForm.ProcessError(Res.Get('error_message').JSONValue.Value);
              end
            );
            Exit;
          end;
        end;

        FParams.Clear;
        FParams.Add('action=SAVE_PROFILE');
        FParams.Add(ADMIN_PARAM);
        FParams.Add('CyberId='+ FCyberId);
        FParams.Add('BusinessName='+ FQuery.FieldByName('Name').AsString);
        if IsNew then
          FParams.Add('Status=I');
        FParams.Add('T1='+GetYN(FQuery.FieldByName('T2').AsString));
        FParams.Add('T2='+ GetYN(FQuery.FieldByName('T2').AsString));
        FParams.Add('T3='+ GetYN(FQuery.FieldByName('T3').AsString));
        FParams.Add('T4T5='+ GetYN(FQuery.FieldByName('T4').AsString));
        FParams.Add('Email='+ FQuery.FieldByName('EMAIL').AsString);
        FParams.Add('Contact='+ FQuery.FieldByName('CONTACT').AsString);
        FParams.Add('Area='+ FQuery.FieldByName('AREAP').AsString);
        FParams.Add('Phone='+ FQuery.FieldByName('PHONE').AsString);
        FParams.Add('Street='+ FQuery.FieldByName('STREET').AsString);
        FParams.Add('City='+ FQuery.FieldByName('CITY').AsString);
        FParams.Add('Province='+ FQuery.FieldByName('PROVINCE').AsString);
        FParams.Add('Postal='+ FQuery.FieldByName('POSTAL').AsString);

        Res := RequestToVirtualTaxOffice(FParams, rtPost, true);
        if Assigned(Res) then
          if not SameText(Res.Get('success').JSONValue.Value, 'true') then
          begin
            Synchronize(
              procedure
              begin
                FForm.ProcessError(Res.Get('error_message').JSONValue.Value);
              end
            );
            Exit;
          end;

        FQuery.Next;
        inc(I);
        Synchronize(
          procedure
          begin
            FForm.Position := I;
          end
        );
      end;
    finally
      FQuery.Free;
      FParams.Free;
    end;
    Synchronize(
      procedure
      begin
        FForm.ProcessFinish;
      end
    );
  except on E: Exception do
    Synchronize(
      procedure
      begin
        FForm.ProcessError(E.Message);
      end
    );
  end;
end;

procedure TImportThread.LoadEfilers;
const
  xlCellTypeLastCell = $0000000B;
var
  XLApp, Sheet: OLEVariant;
  RangeMatrix: Variant;
  RowCount, ColCount, J, I :integer;
  BusinessName, Street, City, Province, Postal, Phone: string;
  FParams: TStringList;
  Res: TJSONObject;
begin
  CoInitialize(nil);
  try
    Synchronize(
      procedure
      begin
        FForm.Position := 0;
        FForm.lbInfo.Caption := 'Opening ' + FFileName;
      end
    );
    FParams := TStringList.Create;
    XLApp := CreateOleObject('Excel.Application');
    try
      XLApp.Visible := False;
      XLApp.DisplayAlerts := false;
      XLApp.Workbooks.Open(FFileName);
      Sheet := XLApp.Workbooks[ExtractFileName(FFileName)].WorkSheets[1];
      Sheet.Cells.SpecialCells(xlCellTypeLastCell, EmptyParam).Activate;
      RowCount := XLApp.ActiveCell.Row;
      ColCount := XLApp.ActiveCell.Column;

      // check if spreadsheet is valid
      if (RowCount < 2) or (ColCount < 6) then
        raise Exception.Create('Spreadsheet is not valid, it should contain 6 columns (BusinessName, BusinessAddress, City, Province, Postal and Phone)')
      else
      begin
        Synchronize(
          procedure
          begin
            FForm.pbProgress.Max := RowCount - 1;
          end
        );
        I := 0;
        RangeMatrix := XLApp.Range['A1', XLApp.Cells.Item[RowCount, ColCount]].Value;
        for J := 2 to RowCount do
        begin
          if Terminated then break;

          BusinessName := VarToStr(RangeMatrix[J,1]);
          Street := VarToStr(RangeMatrix[J,2]);
          City := VarToStr(RangeMatrix[J,3]);
          Province := VarToStr(RangeMatrix[J,4]);
          Postal := VarToStr(RangeMatrix[J,5]);
          Phone := VarToStr(RangeMatrix[J,6]);

          if not BusinessName.IsEmpty then
          begin
            FParams.Clear;
            FParams.Add('action=REGISTER_EFILER');
            FParams.Add(ADMIN_PARAM);
            FParams.Add('BusinessName='+ BusinessName);
            FParams.Add('Street='+ Street);
            FParams.Add('City='+ City);
            FParams.Add('Province='+ Province);
            FParams.Add('Postal='+ Postal);
            FParams.Add('Phone='+ Phone);
            Res := RequestToVirtualTaxOffice(FParams, rtPost, true);
            if Assigned(Res) then
            begin
              if not
                  (SameText(Res.Get('success').JSONValue.Value, 'true')
                   or
                   SameText(Res.Get('type').JSONValue.Value, 'already_registered')) then
              begin
                Synchronize(
                  procedure
                  begin
                    FForm.ProcessError(Res.Get('error_message').JSONValue.Value + #13#10 +
                                      'Row = '+ IntToStr(J) + ', Business Name = '+ BusinessName);
                  end
                );
                Exit;
              end;
            end;
          end;

          inc(I);
          Synchronize(
            procedure
            begin
              FForm.Position := I;
            end
          );
        end;

      end;
    finally
      FParams.Free;
      RangeMatrix := Unassigned;
      if not VarIsEmpty(XLApp) then
      begin
        XLApp.Quit;
        XLApp.DisplayAlerts := true;
        XLAPP := Unassigned;
        Sheet := Unassigned;
      end;
      CoUninitialize;
    end;
    Synchronize(
      procedure
      begin
        FForm.ProcessFinish;
      end
    );
  except on E: Exception do
    Synchronize(
      procedure
      begin
        FForm.ProcessError(E.Message);
      end
    );
  end;
end;

end.
