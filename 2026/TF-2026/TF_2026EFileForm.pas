unit TF_2026EFileForm;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,DBGrids,DB,Printers,ExtCtrls,FileCtrl,
  ShellApi,ActiveX, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;


type
  TEFileForm = class(TForm)
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    PrepBtn: TBitBtn;
    ConnectBtn: TBitBtn;
    ShowXmittalBtn: TBitBtn;
    PrintXmittalBtn: TBitBtn;
    EfileType: TPanel;
    BitBtn5: TBitBtn;
    lblMSXML: TLabel;
    pnlMSXML: TPanel;
    Label9: TLabel;
    lblUrl: TLabel;
    UrlBox: TEdit;
    TestOrProductionGroup: TRadioGroup;
    procedure PrepBtnClick(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FRetNo: integer;
    FXMLList: TStringList;
    FFormName: string;
    FShortFormName: string;
    FFieldList: TStringList;
    FEFPath: string;
    FOnLineNo: string;
    FPassword: string;
    FFileName: string;
    procedure InitSERS;
    procedure createXML;
    function GetBasicAuthorization(AUserName, APassword: string): string;
    procedure GetUrlBox;
    procedure Test;
    function GetShortFormName: string;
    property ShortFormName: string read GetShortFormName;
  public
    constructor Create(AOwner: TComponent; AFormName: string); reintroduce;
    destructor Destroy; override;
    property RetNo: integer read FRetNo;
  end;

var
  EFileForm: TEFileForm;

implementation

{$R *.DFM}

uses
  vtCommon,
  TF_2026,TF_2026Calc,TF_2026TrimStr,TF_2026Declare,TF_2026dataGen,
  TF_2026Main,TF_2026ChildWinNew, vtMulti,
  vtTrimStr,vtShared, StrUtils, vtDynData, MSXML2_TLB, ComObj, IdCoderMIME;

const
 indent = 3;
 indentM = 6;
 indentMM = 9;
 indentMMM = 12;
 indentMMMM = 15;
 indentMMMMM = 18;

{ TEFileForm }

procedure TEFileForm.BitBtn5Click(Sender: TObject);
var
  Url: String;
  h: THandle;
begin
  Url := 'http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor := crHourGlass;
  try
    h := ShellExecute(self.Handle, 'open', Pchar('' + Url), Nil, Nil, Sw_Show);
    If h <= 32 then
      ShowMessage('Connection failed');
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TEFileForm.ConnectBtnClick(Sender: TObject);
var
  ObjHTTP: ixmlHttpRequest;
  LMessage: string;
  LTemp: TStringList;
  s: string;
begin
  if not FileExists(FFileName) then
  begin
    ShowMessage('Please select a valid File Location');
    Exit;
  end;

  LTemp := TStringList.Create;
  try
    LTemp.LoadFromFile(FFileName);
    LMessage := LTemp.Text;
  finally
    LTemp.Free;
  end;

  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  try
    ObjHTTP.open('POST', UrlBox.Text, False, '', '');
    ObjHTTP.setRequestHeader('Content-Type','application/xml');
    objHttp.setRequestHeader('Authorization', 'Basic ' + GetBasicAuthorization(FOnLineNo, FPassword));
    try
      ObjHTTP.send(LMessage);
    except on E: Exception do
      begin
        Application.MessageBox(PChar('It seems that there is no internet connection to the web site' + #13#13 + E.Message), 'Error', MB_OK or MB_ICONERROR);
        Exit;
      end;
    end;
  finally
    ObjHTTP := nil;
  end;
end;

constructor TEFileForm.Create(AOwner: TComponent; AFormName: string);
begin
  inherited Create(AOwner);
  FXMLList := TStringList.Create;
  FFormName := AFormName;
  FFieldList := TStringList.Create;
  InitSERS;
end;

procedure TEFileForm.createXML;
var
  s: string;

  procedure AddBeginTagwithValue(AIndent: integer; AName, AValue: string);
  begin
    FXMLList.Add(Space(AIndent) + '<'+ AName + ' ' + AValue + '>');
  end;

  procedure AddBeginTag(AIndent: integer; AName: string);
  begin
    FXMLList.Add(Space(AIndent) + '<'+ AName +'>');
  end;

  procedure AddEndTag(AIndent: integer; AName: string);
  begin
    FXMLList.Add(Space(AIndent) + '</'+ AName +'>');
  end;

  procedure AddTag(AIndent: integer; AName, AValue: string);
  begin
    if SameText(Trim(AValue), '') then Exit;
    if SameText(Trim(AValue), '') then
      FXMLList.Add(Space(AIndent) + '<'+ AName +'/>')
    else
      FXMLList.Add(Space(AIndent) + '<'+ AName +'>' + ReplaceSpecialChar(AValue) + '</'+ AName +'>');
  end;

  procedure NormalizeArray(var AValue: TArray<string>);
  var
    i: integer;
  begin
    for i := Low(AValue) to High(AValue) do
      AValue[i] := trim(AValue[i]);
  end;

  function GetBoolValue3(ATrue, AFalse, ANAcc: string): string;
  begin
    if FetchElm(RetNo, FFormName, StrToInt(ATrue)) = 'X' then
      Result := '1'
    else if FetchElm(RetNo, FFormName, StrToInt(AFalse)) = 'X' then
      Result := '2'
    else if FetchElm(RetNo, FFormName, StrToInt(ANAcc)) = 'X' then
      Result := '3'
    else
      Result := '';
  end;

  function GetBoolValue2(ATrue, AFalse: string): string;
  begin
    Result := IfThen(FetchElm(RetNo, FFormName, StrToInt(ATrue)) = 'X', '1', IfThen(FetchElm(RetNo, FFormName, StrToInt(AFalse)) = 'X', '2',''));
  end;

  function GetBoolValue1(AValue: string): string;
  begin
    Result := IfThen(FetchElm(RetNo, FFormName, StrToInt(AValue)) = 'X', '1', '2');
  end;

  procedure SaveField(AIndent: integer; AValue, ACode, ARow: string);
  begin
    if not AValue.IsEmpty then
    begin
      AddBeginTag(AIndent, 'FieldCode');
      AddTag(AIndent + 3, 'Line', ACode);
      AddTag(AIndent + 3, 'Row', ARow);
      AddTag(AIndent + 3, 'Value', AValue);
      AddEndTag(AIndent, 'FieldCode');
    end;
  end;

  function NormalizeStr(AValue: string): string;
  begin
    Result := StrUtils.ReplaceStr(AValue,  '’', '''');
  end;

  function GetValue(AType: string; AParams: TArray<string>): string;
  begin
    if AType = 'B1' then
      Result := GetBoolValue1(AParams[0])
    else if AType = 'B2' then
      Result := GetBoolValue2(AParams[0], AParams[1])
    else if AType = 'B3' then
      Result := GetBoolValue3(AParams[0], AParams[1], AParams[2])
    else if AType = 'S' then
      Result := NormalizeStr(FetchElm(RetNo, FFormName, StrToInt(AParams[0])))
    else if AType = 'N' then
      Result := NormalizeStr(FetchElm(RetNo, FFormName, StrToInt(AParams[0])))
    else if AType.Split([','])[0] = 'A' then
      Result := 'A'
    else
      Result := '';
  end;

  procedure AddDynArray(AIndent: integer; AValue: string);
  var
    LCodes: TArray<string>;
    LTypes: TArray<string>;
    LValues: TArray<string>;
    LRow: string;
    LParams: TArray<string>;
    LArrayNo: integer;
    BoxesPerRow: integer;
    RowCount: integer;
    FNo: integer;
    i, j, x: integer;
    Elm: integer;
    LValue: string;
  begin
    FNo := Ret[RetNo].Form[FFormName].FormNo;
    LParams := AValue.Split([chr(9)]);
    NormalizeArray(LParams);
    LCodes := LParams[0].Split([',']);
    NormalizeArray(LCodes);
    LTypes := LParams[1].Split([',']);
    NormalizeArray(LTypes);
    LValues := LParams[2].Split([',']);
    NormalizeArray(LValues);
    LArrayNo := StrToInt(LValues[0]) div 10000;
    RowCount := DynamicRowCount(RetNo, FNo, LArrayNo);
    if RowCount = 0 then
      Exit;
    BoxesPerRow := Ret[RetNo].Form[FFormName].FormDataRec.BoxesPerRow[LArrayNo];
    for i := 0 to RowCount - 1 do
    begin
      Elm := StrToInt(LValues[0]) + BoxesPerRow * i;
      LRow := FetchElmFNo(RetNo, FNo, Elm);
      for j := 1 to High(LTypes) do
      begin
        LParams := LValues[j].Split([':']);
        NormalizeArray(LParams);
        for x := Low(LParams) to High(LParams) do
        begin
          Elm := StrToInt(LParams[x]) + BoxesPerRow * i;
          LParams[x] := IntToStr(Elm);
        end;
        LValue := GetValue(LTypes[j], LParams);
        SaveField(AIndent, LValue, LCodes[j], LRow);
      end;
    end;
  end;

  procedure AddField(AIndent: integer; AValue: string);
  var
    LCode: string;
    LType: string;
    LValue: string;
    LRow: string;
    LParams: TArray<string>;
  begin
    LRow := '0';
    LParams := AValue.Split([chr(9)]);
    NormalizeArray(LParams);
    LCode := LParams[0];
    LType := LParams[1];
    LValue := LParams[2];
    LParams := LValue.Split([',']);
    NormalizeArray(LParams);

    LValue := GetValue(LType, LParams);

    if LValue = 'A' then
    begin
      AddDynArray(AIndent, AValue);
      Exit;
    end;

    SaveField(AIndent, LValue, LCode, LRow);
  end;
var
  LFormName: string;
begin
  FRetNo := GetCurrentRetNo;
  FXMLList.Clear;
  LFormName := FShortFormName;
  if FShortFormName.StartsWith('T') then
    LFormName := Copy(LFormName, 2, MaxInt);

  AddBeginTagwithValue(0, 'FileReturnRequest', 'xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" xmlns:common="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0"');

  AddTag(indent, 'common:SoftwareCode', 'B0865');
  AddTag(indent, 'common:TaxYear', '2023');
  AddTag(indent, 'common:ClientId', '870000247');

  AddBeginTag(indent, 'Form');

  AddTag(indentM, 'common:FormSequenceNumber', '1');
  AddTag(indentM, 'common:FormNumber', LFormName);

  for s in FFieldList do
    AddField(indentM, s);

  AddEndTag(indent, 'Form');

  AddEndTag(0, 'FileReturnRequest');
end;

destructor TEFileForm.Destroy;
begin
  FFieldList.Free;
  FXMLList.Free;
  inherited;
end;

procedure TEFileForm.FormCreate(Sender: TObject);
begin
  UrlBox.OnClick(nil);
end;

function TEFileForm.GetBasicAuthorization(AUserName, APassword: string): string;
var
  Encoder: TIdEncoderMIME;
begin
  Encoder := TIdEncoderMIME.Create(nil);
  try
    Result := Encoder.EncodeString(AUserName + ':' + APassword);
  finally
    Encoder.Free;
  end;
end;

function TEFileForm.GetShortFormName: string;
begin

end;

procedure TEFileForm.GetUrlBox;
begin
 If TestOrProductionGroup.ItemIndex = 0 then
    UrlBox.Text := 'https://apps.cra-arc.gc.ca/ebci/sres/ws/api/sersnet/fileReturn'
  else
    UrlBox.Text := 'https://apps-ct.cra-arc.gc.ca/ebci/sres/ws/api/sersnet/fileReturn';
end;

procedure TEFileForm.InitSERS;
var
  LTemp: TStringList;
  i: integer;
begin
  GetEOLParms(FOnLineNo, FPassword, FEFPath);
  FEFPath := IncludeTrailingPathDelimiter(FEFPath);
  ForceDirectories(FEFPath);
  FShortFormName := LeftStr(FFormName, 5);
  FFileName := Format('%sSERS%s.xml', [FEFPath, FShortFormName]);
  FFieldList.Clear;
  FFieldList.LoadFromFile(Appdir + '\' + 'SERS.D');
  for i := FFieldList.Count - 1 downto 0 do
    if Pos(FShortFormName, FFieldList[i]) = 1 then
      FFieldList[i] := trim(Copy(FFieldList[i], Length(FShortFormName) + 1, MaxInt))
    else
      FFieldList.Delete(i);
end;

procedure TEFileForm.PrepBtnClick(Sender: TObject);
begin
  If FileExists(FFileName) and (MessageDlg('File exists. Override?', mtInformation, [mbYes, mbNo], 0) = mrNo) then
    Exit;

  createXML;
  FXMLList.SaveToFile(FFileName);
end;

procedure TEFileForm.Test;
var LRequest, LResponse: string;
    objHttp: IXMLHTTPRequest;
begin
  LRequest :=
    '<?xml version="1.0" encoding="UTF-8"?>'+ #13#10 +
    '<FileReturnRequest xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" '+ #13#10 +
    '                   xmlns:common="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0"> '+ #13#10 +
    '  <common:SoftwareCode>AA00</common:SoftwareCode> '+ #13#10 +
    '  <common:ClientId>123456789RC0001</common:ClientId> '+ #13#10 +
    '  <Form> '+ #13#10 +
//    '    <common:FormSequenceNumber>'+ edFormSequenceNumber.Text +'</common:FormSequenceNumber> '+ #13#10 +
//    '    <common:FormNumber>'+ GetFormNumber +'</common:FormNumber> '+ #13#10 +
    //AddFields +
    '  </Form> '+ #13#10 +
    '</FileReturnRequest> ';
//  SaveToFile(LRequest, FileReturnSubmittedFileName);
//  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
//  objHttp.open('POST', FileReturnUrl, False, '', '');
//  objHttp.setRequestHeader('Content-Type', 'application/xml');
//  objHttp.setRequestHeader('Authorization', 'Basic ' + GetBasicAuthorization(edDAC.Text, ''));
//  objHttp.send(LRequest);
//  LResponse := objHttp.ResponseText;
//  SaveToFile(LResponse, FileReturnReceivedFileName);
//  Response := ParseResponse(LResponse);
//  ShowHTML(Response, FileReturnReceivedHTMLFileName);
  //InitFileNames;
end;

procedure TEFileForm.TestOrProductionGroupClick(Sender: TObject);
begin
  GetUrlBox;
end;

end.
