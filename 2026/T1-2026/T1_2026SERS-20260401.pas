unit T1_2026SERS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, System.IOUtils;

type
  TResponse = record
    Success: boolean;
    ReturnCode: integer;
    Description: string;
    Text: string;
    ErrorReason: string;
    ErrorReasonDescription: string;
    ErrorReasonText: string;
  end;

  TfrmSERS2025 = class(TForm)
    pnlTop: TPanel;
    ProductionOrTestGroup: TRadioGroup;
    URLForWebServices: TEdit;
    EFile: TBitBtn;
    MemoLog: TMemo;
    MemoFile: TMemo;
    btnSubmit: TBitBtn;
    pnlSubmit: TPanel;
    pnlReceive: TPanel;
    Panel4: TPanel;
    edSubmittedFile: TEdit;
    Label1: TLabel;
    pnlReceiveFile: TPanel;
    Label2: TLabel;
    edReceivedFile: TEdit;
    pnlReceiveHTML: TPanel;
    Label3: TLabel;
    edReceivedHTMLFile: TEdit;
    btnViewHTML: TSpeedButton;
    pnlInfo: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edNumber: TEdit;
    edFormType: TEdit;
    edConfirmationNumber: TEdit;
    edFormSequenceNumber: TEdit;
    procedure ProductionOrTestGroupClick(Sender: TObject);
    procedure btnSubmitClick(Sender: TObject);
    procedure btnViewHTMLClick(Sender: TObject);
    procedure EFileClick(Sender: TObject);
  private
    { Private declarations }
    RetNo: integer;
    FFormName: string;
    FXMLList: TStringList;
    FFieldList: TStringList;
    FOnLineNo: string;
    FPassword: string;
    FEFPath: string;
    FClientID: string;
    procedure Submit;
    function ReplacePredefinedXMLEntities(info: string): string;
    function PrepareValue(Value: string; MaxLength: integer = 0): string;
    function GetSubmittedFileName: string;
    function GetReceivedFileName: string;
    function GetReceivedHTMLFileName: string;
    procedure SaveToFile(AText, AFileName: string);
    function GetShortFormName: string;
    function CreateXML: boolean;
    function GetFormNumber: string;
    procedure Init;
    function GetBasicAuthorization(AUserName, APassword: string): string;
    procedure CreateHTML(AResponse: TResponse; AFileName: string);
    function ParseResponse(AResponse: string): TResponse;
    procedure InitFileNames;
    function GetSoftwareCode: string;
  protected
    property ShortFormName: string read GetShortFormName;
    property FormNumber: string read GetFormNumber;
    property SubmittedFileName: string read GetSubmittedFileName;
    property ReceivedFileName: string read GetReceivedFileName;
    property ReceivedHTMLFileName: string read GetReceivedHTMLFileName;
    property SoftwareCode: string read GetSoftwareCode;
  public
    constructor Create(AOwner: TComponent; AFormName: string); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses vtCommon, MSXML2_TLB, ComObj, System.RegularExpressions,
  Xml.XMLDoc, Xml.XMLIntf, StrUtils, vtTrimStr, T1_2026, vtMulti, vtShowMessageHTML,
  vtDynData, T1_2026TrimStr, T1_2026Declare, IdCoderMIME;

{$R *.dfm}

const
 indent = 3;
 indentM = 6;
 indentMM = 9;
 indentMMM = 12;
 indentMMMM = 15;
 indentMMMMM = 18;

function ReplaceSpecialChar(info: String): String;
begin
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
  info := ReplaceChar(info, '''', '&apos;');
  result := info;
end;

function ClearXML(AXML: String): string;
begin
  Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
  Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
end;

function TfrmSERS2025.ReplacePredefinedXMLEntities(info: string): string;
begin
  info := Trim(info);
  info := HTMLEscape(info);
  info := ReplaceChar(info, '''', '&apos;');
  Result := info;
end;

procedure TfrmSERS2025.SaveToFile(AText, AFileName: string);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := AText;
    L.SaveToFile(AFileName, TEncoding.UTF8);
  finally
    L.Free;
  end;
end;

procedure TfrmSERS2025.Submit;
var
  objHttp: IXMLHTTPRequest;
  LResponse: String;
  ResponseXmlFile: String;
  ConfirmNumber: string;
  Response: TResponse;
begin
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
  Screen.Cursor := crHourGlass;
  try
    objHttp.open('POST', URLForWebServices.Text, False, '', '');
    ObjHTTP.setRequestHeader('Content-Type','application/xml');
    objHttp.setRequestHeader('Authorization', 'Basic ' + GetBasicAuthorization(FOnLineNo, FPassword));
    FXMLList.SaveToFile(SubmittedFileName);
    objHttp.send(FXMLList.Text);
    delay(2000);
    LResponse := objHttp.ResponseText;
    SaveToFile(LResponse, ReceivedFileName);
    Response := ParseResponse(LResponse);
    CreateHTML(Response, ReceivedHTMLFileName);
    MemoLog.Clear;
    MemoLog.Text := ReplaceStr(LResponse, '><', '>' + #13#10 + '<');
    InitFileNames;
    OpenForm(RetNo, FFormName, 0);
  finally
    objHttp := nil;
    Screen.Cursor := crDefault;
  end;
end;

function TfrmSERS2025.ParseResponse(AResponse: string): TResponse;
var
  X: XML.XMLDoc.TXMLDocument;
  Node: IXMLNode;
begin
  Result.Success := false;
  Result.ReturnCode := -1;
  Result.Description := '';
  Result.Text := '';
  Result.ErrorReason := '';
  Result.ErrorReasonDescription := '';
  Result.ErrorReasonText := '';

  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;
      X.XML.Add(ClearXML(AResponse));
      if not(X.Active) then
        X.Active := true;
      Node := X.DocumentElement;

      if not Assigned(Node) then
        Result.Text := 'Response has incorrect structure: <br><br>' + HTMLEscape(AResponse)
      else if SameText(Node.NodeName, 'FileReturnResponse') then
      begin
        if Assigned(Node.ChildNodes.FindNode('Form')) then
        begin
          Node := Node.ChildNodes.FindNode('Form');
          if Assigned(Node.ChildNodes.FindNode('ConfirmationNumber')) then
          begin
            edConfirmationNumber.Text := Node.ChildNodes.FindNode('ConfirmationNumber').NodeValue;
            Result.Success := true;
            Result.Text := 'Confirmation Number: ' + edConfirmationNumber.Text;
            //if (ShortFormName = 'T2057') or (ShortFormName = 'T2059') then
            StoreElm(RetNo, Ret[RetNo].Form[FFormName].FormNo, 59, edConfirmationNumber.Text);
            Ret[RetNo].Changed := True;
            Exit;
          end
          else if Assigned(Node.ChildNodes.FindNode('Error')) then
            Node := Node.ChildNodes.FindNode('Error');
        end
        else if Assigned(Node.ChildNodes.FindNode('Error')) then
          Node := Node.ChildNodes.FindNode('Error')
        else
          Node := nil;
        if Assigned(Node) then
        begin
          Result.ErrorReason := Node.ChildNodes.FindNode('ErrorId').NodeValue;
          Result.Text := Node.ChildNodes.FindNode('ErrorEnglishDesc').NodeValue;
        end;
      end
      else
      begin
        Result.Text := HTMLEscape(AResponse);
      end;
    except on E: Exception do
      begin
        Result.Text := HTMLEscape(AResponse);
        ShowMessage('Error occured while processing CRA response: '+ #13 + E.Message + #13#13 + 'Response: '+ AResponse);
      end;
    end;
  finally
    X.Free;
  end;
end;

function TfrmSERS2025.PrepareValue(Value: string;
  MaxLength: integer = 0): string;
begin
  Value := ReplacePredefinedXMLEntities(Trim(Value));
  if MaxLength > 0 then
    Value := Copy(Value, 1, MaxLength);
  Result := Value;
end;

procedure TfrmSERS2025.btnSubmitClick(Sender: TObject);
begin
  Submit;
end;

constructor TfrmSERS2025.Create(AOwner: TComponent; AFormName: string);
begin
  inherited Create(AOwner);
  FXMLList := TStringList.Create;
  FFormName := AFormName;
  FFieldList := TStringList.Create;
  Caption := 'EFile ' + ShortFormName;
  ProductionOrTestGroup.ItemIndex := 0;
  Init;
end;

procedure TfrmSERS2025.CreateHTML(AResponse: TResponse; AFileName: string);
var L: TStringList;
    A: TArray<string>;
    I: integer;
    cColor, cBody: string;
    cCaption: string;
begin
  if AResponse.Success then
  begin
    cColor := 'green';
    cCaption := 'Confirmation';
  end
  else
  begin
    cColor := 'red';
    cCaption := 'Error';
  end;
  L := TStringList.Create;
  try
    L.Add('<HTML><HEAD>');
    L.Add('<META CHARSET="UTF-8">');
    L.Add('<TITLE>T2 EFile Service</TITLE>');
    L.Add('</HEAD>');
    L.Add('<BODY>');
    L.Add('<DIV id="contentheader">');
    L.Add('<H1><FONT size=5><STRONG>SERS Results</STRONG></FONT></H1>');
    L.Add('<P>Client Number: <STRONG>'+ HTMLEscape(edNumber.Text) +'</STRONG></P>'); //20260327 Igor
    L.Add('<P>Form Type: <STRONG>'+ HTMLEscape(ShortFormName) +'</STRONG></P>');
    L.Add('<H2><FONT color='+ cColor +' size=5><STRONG>'+ cCaption +'</STRONG></FONT></H2>');
    if AResponse.Success then
    begin
      L.Add('<P><FONT size=3>'+ AResponse.Text +'</FONT></P>');
    end
    else
    begin
      if AResponse.ReturnCode <> -1 then
        L.Add('<P><FONT size=3><strong>Result Code:</strong> '+ IntToStr(AResponse.ReturnCode) +' - '+ AResponse.Description +'</FONT></P>');

      L.Add('<P><FONT size=3>'+ AResponse.Text +'</FONT></P>');

      if not AResponse.ErrorReason.IsEmpty then
        if AResponse.ErrorReasonDescription.IsEmpty then
          L.Add('<P><FONT size=3><strong>Error Reason:</strong> '+ AResponse.ErrorReason +'</FONT></P>')
        else
          L.Add('<P><FONT size=3><strong>Error Reason:</strong> '+ AResponse.ErrorReason +' - '+ AResponse.ErrorReasonDescription +'</FONT></P>');
      if not AResponse.ErrorReasonText.IsEmpty then
        L.Add('<P><FONT size=3>'+ HTMLEscape(AResponse.ErrorReasonText) +'</FONT></P>');
    end;
    L.Add('<HR>');
    L.Add('<P>Received: '+ DateTimeToStr(Now) +'</P>');
    L.Add('</DIV></BODY></HTML>');
    L.SaveToFile(AFileName, TEncoding.UTF8);
    ShowMessageHTML(L.Text, 600);
  finally
    L.Free;
  end;
end;

function TfrmSERS2025.CreateXML: boolean;
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
    if (ShortFormName = 'T2057') then //20260227 Igor
      Result:= IfThen(FetchElm(RetNo, FFormName, StrToInt(AValue)) = 'X', '1', '2') //20260227 Igor
    else //20260227 Igor
      Result:= IfThen(FetchElm(RetNo, FFormName, StrToInt(AValue)) = 'X', '1', ''); //20260227 Igor
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
  //20260226 Igor >>>
  function CheckSymbolsAfterPoint(aFloatVal: string = '0'): string;
  begin
    if (Length(aFloatVal) > 0) and (Pos('.', aFloatVal) = 0) then
      Result:= aFloatVal + '.00'
    else
    if (Pos('.', aFloatVal) > 0) then
    begin
      if ((Length(aFloatVal) - Pos('.', aFloatVal)) = 1) then
        Result:= aFloatVal + '0'
      else
        Result:= aFloatVal;
    end else
      Result:= aFloatVal;
  end;
  //20260226 Igor <<<

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
      Result:= CheckSymbolsAfterPoint(NormalizeStr(FetchElm(RetNo, FFormName, StrToInt(AParams[0])))) //20260226 Igor
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
    LParams := AValue.Split([chr(9), ' ']);
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
begin
  FXMLList.Clear;
  Init;
  AddBeginTagwithValue(0, 'FileReturnRequest', 'xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" xmlns:common="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0"');

  AddTag(indent, 'common:SoftwareCode', SoftwareCode);
  if FormNumber = '2900' then
    AddTag(indent, 'common:TaxYear', FetchElm(RetNo, FFormName, 2))
  else
    AddTag(indent, 'common:TaxYear', CurrentApp.AppYear);
  AddTag(indent, 'common:ClientId', FClientID);

  AddBeginTag(indent, 'Form');

  AddTag(indentM, 'common:FormSequenceNumber', '1');
  AddTag(indentM, 'common:FormNumber', FormNumber);

  for s in FFieldList do
    AddField(indentM, s);

  AddEndTag(indent, 'Form');

  AddEndTag(0, 'FileReturnRequest');
  Result := FXMLList.Count > 9;
end;

destructor TfrmSERS2025.Destroy;
begin
  FXMLList.Free;
  FFieldList.Free;
  inherited;
end;

procedure TfrmSERS2025.EFileClick(Sender: TObject);
begin
  CreateXML;
  MemoFile.Lines.Assign(FXMLList);
  MemoFile.Lines.SaveToFile(SubmittedFileName);
  btnSubmit.Enabled := MemoFile.Lines.Count > 0;
end;

function TfrmSERS2025.GetBasicAuthorization(AUserName, APassword: string): string;
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

function TfrmSERS2025.GetFormNumber: string;
begin
  Result := '';
  if SameText(ShortFormName, 'T2057') then
    Result := '2057'
  else if SameText(ShortFormName, 'T2059') then
    Result := '2059'
  else if SameText(ShortFormName, 'UHT2900') then
    Result := '2900'
  else if SameText(ShortFormName, 'T217') then
    Result := '0217';
end;

function TfrmSERS2025.GetReceivedFileName: string;
begin
  Result := TPath.Combine(FEFPath, ShortFormName + '-RECEIVED.XML');
end;

function TfrmSERS2025.GetReceivedHTMLFileName: string;
begin
  Result := TPath.Combine(FEFPath, ShortFormName + '-RECEIVED.HTML');
end;
//20260226 Igor >>>
function TfrmSERS2025.GetShortFormName: string;
begin
  if LeftStr(FFormName, 5) = 'T2057' then Result := 'T2057'
  else if LeftStr(FFormName, 4) = 'UHT#' then Result := 'UHT' //'UHT2900'
  else Result := FFormName;
end;
//20260226 Igor <<<
function TfrmSERS2025.GetSoftwareCode: string;
begin
  //20250109
  if ShortFormName = 'T2057' then Result := '064AC'
  else if ShortFormName = 'T2059' then Result := '064AD'
  else if ShortFormName = 'UHT' then Result := '064AE'
  //else if ShortFormName = 'UHT2900' then Result := '064AE'
  else if ShortFormName = 'T217' then Result := '064AB'
  else
    Result := '';
end;

function TfrmSERS2025.GetSubmittedFileName: string;
begin
  Result := TPath.Combine(FEFPath, ShortFormName + '-SUBMITTED.XML');
end;

procedure TfrmSERS2025.Init;
var
  i: integer;
  LUrl: string; //for compatibility, not used
begin
  RetNo := GetCurrentRetNo;
  FClientID := GetSinNo(RetNo);
  FFieldList.Clear;
  FFieldList.LoadFromFile(Appdir + '\' + 'SERS.D');
  for i := FFieldList.Count - 1 downto 0 do
    if Pos(ShortFormName, FFieldList[i]) = 1 then
      FFieldList[i] := trim(Copy(FFieldList[i], Length(ShortFormName) + 1, MaxInt))
    else
      FFieldList.Delete(i);
  GetEOLParms(FOnLineNo, FPassword, LUrl, FEFPath);
  FEFPath := TPath.Combine(FEFPath, ShortFormName);
  ForceDirectories(FEFPath);
  InitFileNames;
  if FileExists(SubmittedFileName) then
  begin
    MemoFile.Lines.LoadFromFile(SubmittedFileName);
    btnSubmit.Enabled := MemoFile.Lines.Count > 0;
  end;
  if FileExists(ReceivedFileName) then
  begin
    MemoLog.Lines.LoadFromFile(ReceivedFileName);
    MemoLog.Text := ReplaceStr(ClearXML(MemoLog.Text), '><', '>' + #13#10 + '<');
  end;
  edNumber.Text := FClientID;
  edConfirmationNumber.Text := FetchElm(RetNo, FFormName, 59);
  edFormType.Text := FFormName;
  edFormSequenceNumber.Text := '1';
end;

procedure TfrmSERS2025.InitFileNames;
  procedure SetFileNameEditValue(AEdit: TEdit; AFileName: string);
  begin
    if FileExists(AFileName) then
      AEdit.Text := AFileName;
  end;
begin
  SetFileNameEditValue(edSubmittedFile, SubmittedFileName);
  SetFileNameEditValue(edReceivedFile, ReceivedFileName);
  SetFileNameEditValue(edReceivedHTMLFile, ReceivedHTMLFileName);
end;

procedure TfrmSERS2025.ProductionOrTestGroupClick(Sender: TObject);
begin
  if (FormNumber = '2057') or (FormNumber = '2059') or (FormNumber = '0217') then
  begin
    if ProductionOrTestGroup.ItemIndex = 0 then
      URLForWebServices.Text := 'https://apps.cra-arc.gc.ca/ebci/sres/ws/api/sersnet/fileReturn'
    else
      URLForWebServices.Text := 'https://apps-ct.cra-arc.gc.ca/ebci/sres/ws/api/sersnet/fileReturn';
  end
  else if (FormNumber = '2900') then
  begin
    if ProductionOrTestGroup.ItemIndex = 0 then
      URLForWebServices.Text := 'https://apps.cra-arc.gc.ca/ebci/sres/ws/api/sersnet/fileUhtReturn'
    else
      URLForWebServices.Text := 'https://apps-ct.cra-arc.gc.ca/ebci/sres/ws/api/sersnet/fileUhtReturn';
  end;
end;

procedure TfrmSERS2025.btnViewHTMLClick(Sender: TObject);
var
  L: TStringList;
begin
  if FileExists(edReceivedHTMLFile.Text) then
  begin
    L := TStringList.Create;
    try
      L.LoadFromFile(edReceivedHTMLFile.Text);
      ShowMessageHTML(L.Text, 600);
    finally
      L.Free;
    end;
  end;
end;

end.
