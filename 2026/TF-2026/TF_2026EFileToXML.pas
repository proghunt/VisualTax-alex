unit TF_2026EFileToXML;

interface

uses
  System.Classes, Xml.XMLIntf;

type
  TFormToEFileConverter = class;

  TVirtualTable = class(TObject)
  private
    FParent: TFormToEFileConverter;
    FFields: TStringList;
  public
    constructor Create(AParent: TFormToEFileConverter);
    destructor Destroy; override;
    procedure AddTableValue(AValues: TArray<string>);
  end;

  TVirtualTables = class(TObject)
  private
    FParent: TFormToEFileConverter;
    FTables: TStringList;
    FNestedTables: TStringList;
  public
    constructor Create(AParent: TFormToEFileConverter);
    destructor Destroy; override;
    procedure FillTables(AList: TStringList);
    procedure Clear;
    procedure AddXMLValue(AValues: TArray<string>);
  end;

  TFormToEFileConverter = class(TObject)
  private
    FTables: TVirtualTables;
    FXML: IXMLDocument;
    FFieldList: TStringList;
    FParentFormName: string;
    FFormName: string;
    FOnLineNo: string;
    FPassword: string;
    FEFPath: string;
    FRetNo: integer;
    FSubmitRef: string;
    FChildrenFormList: TStringList;
    FStrXmlList: TStringList;

    function Init: boolean;
    function LoadFormFields: boolean;
    procedure PrepareT619(var T619XmlList: TStringList; RetNo: Integer; SubmitRef: String);
    procedure CreateXML;
    procedure CreateFormXML;
    procedure AddValueToXML(AValues: TArray<string>; aIsNeedCheckFieldValOnEmpty: Boolean = False);
    function NormalizeStr(AValue: string): string;
    function GetValue(AParams: TArray<string>): string;
    function GetBoolValue(AParams: string; ALength: string = '1'): string;
    function GetStringValue(AParams: string): string;
    function GetArrayValue(AParams: string): string;
    procedure LoadChildrenForm;
    function FindOrCreateNode(AParams: TArray<string>; aIsPredUsing: Boolean = false): IXMLNode;
    procedure FieldCodeAmountRule(ANode: IXMLNode; AParams: TArray<string>);
    procedure FieldCodeCharacter60TextRule(ANode: IXMLNode; AParams: TArray<string>);
    function ReplaceStrParams(AValue: string): string;
    function ReplaceSpace(AValue: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    class procedure Execute(AFormName: string; aRetNo: Integer; aSubmitRef: string; var aStrXmlList: TStringList);
  end;

  function IfThen(AValue: Boolean; const ATrue: IXMLNode; AFalse: IXMLNode = nil): IXMLNode; overload; inline;

implementation

uses
  TF_2026Declare, TF_2026TrimStr, System.SysUtils, System.IOUtils, vtCommon, Xml.XMLDoc,
  System.StrUtils, Dialogs, vtTrimStr, TF_2026;

const
  C_RoleFileName = 'FormToXML.D';
  C_FieldCode = 'ccms:FieldCode';
  C_FieldAmount = 'ccms:FieldAmount';
  C_Character60Text = 'ccms:Character60Text';

// Structure
// 0 - Data type
// 1 - Edit boxes number
// 2 - Max Size
// 3 - Tag
// 4 - Field box number
// 5 - tags for FieldCode & others

function IfThen(AValue: Boolean; const ATrue: IXMLNode; AFalse: IXMLNode): IXMLNode;
begin
  if AValue then
    Result:= ATrue
  else
    Result:= AFalse;
end;

{ TFormToEFileConverter }

procedure TFormToEFileConverter.AddValueToXML(AValues: TArray<string>; aIsNeedCheckFieldValOnEmpty: Boolean = False);

  function IsDFileLineNotEmpty(): Boolean;
  var
    lValueParams: TArray<string>;
    lValParams: string;
  begin
    Result:= False;
    lValueParams:= AValues[1].Split([',']);

    if not AValues[0].Equals('SV') and not AValues[0].Equals('NT') then
    begin
      lValParams:= Format('%s %s %s %s', [AValues[0], AValues[1], AValues[2], 'T']);

      if not GetValue(lValParams.Split([' '])).IsEmpty() then
      begin
        Result:= True;
        Exit;
      end;
    end;
  end;

var
  LNode: IXMLNode;
  LItem: string;
begin
  if Length(AValues) = 0 then
    exit;

  if AValues[0] = 'T' then
  begin
    FTables.AddXMLValue(AValues);
    Exit;
  end;

  if Length(AValues) < 4 then
    exit;

  if aIsNeedCheckFieldValOnEmpty and not IsDFileLineNotEmpty() then Exit;
  if (Length(AValues) <= 4) and  not GetValue(AValues).IsEmpty then //20260220 Igor
    LNode:= FindOrCreateNode(AValues);
  if not Assigned(LNode) then
    Exit;

  if Length(AValues) > 4 then
  begin
    LItem:= AValues[4];

    if LItem.Split([':'])[0] = 'P' then
    begin
      if LItem.Split([':'])[1] = 'FieldCodeAmountRule' then
        FieldCodeAmountRule(LNode, AValues)
      else
      if LItem.Split([':'])[1] = 'FieldCodeCharacter60TextRule' then
        FieldCodeCharacter60TextRule(LNode, AValues);
    end;
  end else
    LNode.NodeValue:= GetValue(AValues);
end;

constructor TFormToEFileConverter.Create;
begin
  inherited;
  FFieldList:= TStringList.Create;
  FChildrenFormList:= TStringList.Create;
  FTables:= TVirtualTables.Create(Self);
  FXML:= NewXMLDocument;
end;

procedure TFormToEFileConverter.CreateFormXML;
var
  LLine: string;
  LValues: TArray<string>;
  i: integer;
begin
  FList.Find(FFormName, i);

  if i < 0 then
  begin
    Exception.CreateFmt('Form not found: %s', [FFormName]);
    Exit;
  end;

  FTables.FillTables(FFieldList);

  for LLine in FFieldList do
  begin
    LValues:= ReplaceStrParams(LLine).Split([' ', #9]);
    AddValueToXML(LValues, (FFormName = 'PS141'));
  end;
end;
//20260107 Igor >>>
procedure TFormToEFileConverter.PrepareT619(var T619XmlList: TStringList; RetNo: Integer; SubmitRef: String);
const
 indent = 3;
 indentM = 6;
 indentMM = 9;
 indentMMM = 12;
 indentMMMM = 15;
 indentMMMMM = 18;

  function ReplaceSpecialChar(aInfo: string): string;
  begin
    aInfo:= ReplaceChar(aInfo, '&', '&amp;');
    aInfo:= ReplaceChar(aInfo, '<', '&lt;' );
    aInfo:= ReplaceChar(aInfo, '"', '&quot;');
    aInfo:= ReplaceChar(aInfo, '>', '&gt;');
    aInfo:= ReplaceChar(aInfo, '''', '&apos;');

    result:= aInfo;
  end;

var
  Info, Lang: string;
  ContName: string[22];
  ContArea: string[3];
  ContPhone: string[10];
begin
  T619XmlList.add(Space(indent) + '<T619>');

  //Required up to 15 alphanumeric
  T619XmlList.add(Space(indentM) + '<TransmitterAccountNumber>');

  if FFormName.Equals('NR4') then
  begin
    T619XmlList.Add(Space(indentMM) + '<nr4>' + UpperCase(FetchElm(RetNo, 'NR4SUM', 3)) + '</nr4>');
  end else
  if not OptRec.Prp_TransmitterNo.IsEmpty() then //20260824 Alex
  begin
    info:= OptRec.Prp_TransmitterNo;
    if (Length(info) = 9) then
      T619XmlList.add(Space(indentMM) + '<bn9>' + OptRec.Prp_TransmitterNo + '</bn9>)')
    else
      T619XmlList.add(Space(indentMM) + '<bn15>' + OptRec.Prp_TransmitterNo + '</bn15>');
  end;
  //<trust></trust> -1 alpha, 8 numeric, example: T00000000

  T619XmlList.add(Space(indentM) + '</TransmitterAccountNumber>');

  if not OptRec.Prp_RepId.IsEmpty() then
  begin
    T619XmlList.add(Space(indentM) + '<TransmitterRepID>');
    //T619XmlList.add(Space(indentMM) + '<RepID>' + OptRec.Prp_TransmitterAccountRepId + '</RepID>'); //20260824 Alex
    T619XmlList.add(Space(indentMM) + '<RepID>' + OptRec.Prp_RepId + '</RepID>'); //20260824 Alex
    T619XmlList.add(Space(indentM) + '</TransmitterRepID>');
  end;

  if OptRec.Prp_RepId.IsEmpty then
    T619XmlList.add(Space(indentM) + '<sbmt_ref_id>' + SubmitRef + '</sbmt_ref_id>');

  T619XmlList.add(Space(indentM) + '<summ_cnt>' + '1' + '</summ_cnt>');
  Lang:= 'E';

  T619XmlList.add(Space(indentM) + '<lang_cd>' + Lang + '</lang_cd>');

  T619XmlList.add(Space(indentM) + '<TransmitterName>');
  info:= ReplaceSpecialChar(LeftStr(OptRec.Prp_Name, 35));
  T619XmlList.add(Space(indentMM) + '<l1_nm>' + info + '</l1_nm>');

  T619XmlList.add(Space(indentM) + '</TransmitterName>');
  T619XmlList.add(Space(indentM) + '<TransmitterCountryCode>CAN</TransmitterCountryCode>');

  T619XmlList.add(Space(indentM) + '<CNTC>');
  info:= ReplaceReservedXMLCharactersAndTruncate(OptRec.Prp_ContactName, 22);

  T619XmlList.add(Space(indentMM) + '<cntc_nm>' + info + '</cntc_nm>');
  ContName:= Info;

  T619XmlList.add(Space(indentMM) + '<cntc_area_cd>' + LeftStr(OptRec.Prp_Area, 3) + '</cntc_area_cd>');
  ContArea:= LeftStr(OptRec.Prp_Area, 3);

  T619XmlList.add(Space(indentMM) + '<cntc_phn_nbr>' + LeftStr(OptRec.Prp_Tel, 8) + '</cntc_phn_nbr>');
  ContPhone:= RemoveChar(LeftStr(OptRec.Prp_Tel, 8), ' ');

  if not OptRec.Prp_Email.IsEmpty() then T619XmlList.add(Space(indentMM) + '<cntc_email_area>' + AllTrim(OptRec.Prp_EMail) + '</cntc_email_area>');
  //<sec_cntc_email_area></sec_cntc_email_area> //Transmitter Second Contact Email. NOT Required parameter - Up to 60 alphanumeric. //20260107 Igor
  T619XmlList.add(Space(indentM) + '</CNTC>');
  T619XmlList.add(Space(indent) + '</T619>');
end;
//20260107 Igor <<<
procedure TFormToEFileConverter.CreateXML;
var
  i: integer;
  lStringStream: TStringStream;
  lXMLHeaderList: TStringList;
begin
  for i:= 0 to pred(FChildrenFormList.Count) do
  begin
    FFormName:= FChildrenFormList[i];

    if LoadFormFields then
    try
      CreateFormXML;
    except on E: Exception do
      ShowMessage(E.Message);
    end;
  end;

//  FXML.SaveToFile('c:\1\T5013\test.xml');

  lStringStream:= TStringStream.Create;
  try
    lXMLHeaderList:= TStringList.Create;
    try
      lXMLHeaderList.Add('<?xml version="1.0" encoding="UTF-8"?>');
      lXMLHeaderList.Add('<Submission xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0"');
      lXMLHeaderList.Add('xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"');
      lXMLHeaderList.Add('xmlns:olT661="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts1="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts1/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts2="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts2/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts3="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts3/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts4="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts4/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts5="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts5/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts6="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts6/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts7="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts7/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts9="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts9/1-0-0"');
      lXMLHeaderList.Add('xmlns:olT661Parts10="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olT661Parts10/1-0-0"');
      lXMLHeaderList.Add('xmlns:ols="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols1="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols1/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols100="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols100/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols12="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols12/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols125="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols125/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols130="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols130/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols140="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols140/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols141="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols141/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols2="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols2/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols5="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols5/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols50="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols50/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols52="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols52/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols58="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols58/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols63="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols63/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols65="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols65/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols6="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols6/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols75="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols75/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols78="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols78/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols8="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols8/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols8-1="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols8-1/1-0-1"');
      lXMLHeaderList.Add('xmlns:ols9="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols9/1-0-1"');
      lXMLHeaderList.Add('xmlns:olsbr="http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olsbr/1-0-1"');
      lXMLHeaderList.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">');

      PrepareT619(lXMLHeaderList, FRetNo, FSubmitRef);

      lXMLHeaderList.SaveToStream(lStringStream);
    finally
      lXMLHeaderList.Free;
    end;

    // Put the generated XML structure to the String Stream
    FXML.SaveToStream(lStringStream);
    // Put the Submission close XML tag to the String Stream
    lXMLHeaderList:= TStringList.Create;
    try
      lXMLHeaderList.Add('</Submission>');
      lXMLHeaderList.SaveToStream(lStringStream);
    finally
      lXMLHeaderList.Free;
    end;

    lStringStream.Position:= 0;
    FStrXmlList.LoadFromStream(lStringStream);
  finally
    lStringStream.Free;
  end;
end;

destructor TFormToEFileConverter.Destroy;
begin
  FXML:= nil;
  FFieldList.Free;
  FChildrenFormList.Free;
  FTables.Free;
  inherited;
end;

class procedure TFormToEFileConverter.Execute(aFormName: string; aRetNo: Integer; aSubmitRef: string; var aStrXmlList: TStringList);
begin
  with TFormToEFileConverter.Create do
  try
    FFormName:= AFormName;
    FRetNo:= aRetNo;
    FSubmitRef:= aSubmitRef;
    FParentFormName:= AFormName;
    FStrXmlList:= aStrXmlList;

    if not Init then
      Exit;

    CreateXML;
  finally
    Free;
  end;
end;

procedure TFormToEFileConverter.FieldCodeAmountRule(ANode: IXMLNode; AParams: TArray<string>);
begin
  if Length(AParams) < 6 then
    Exit;

{  if not FFormName.Equals('PS12') then
  begin}
    ANode.AddChild(C_FieldCode).NodeValue:= AParams[5];
    ANode.AddChild(C_FieldAmount).NodeValue:= GetValue(AParams);
{  end else
  if not GetValue(AParams).IsEmpty then
  begin
    ANode.AddChild(C_FieldCode).NodeValue:= AParams[5];
    ANode.AddChild(C_FieldAmount).NodeValue:= GetValue(AParams);
  end;  }
end;

procedure TFormToEFileConverter.FieldCodeCharacter60TextRule(ANode: IXMLNode; AParams: TArray<string>);
begin
  if Length(AParams) < 6 then
    Exit;

  ANode.AddChild(C_FieldCode).NodeValue:= AParams[5];
  ANode.AddChild(C_Character60Text).NodeValue:= GetValue(AParams);
end;

function TFormToEFileConverter.FindOrCreateNode(AParams: TArray<string>; aIsPredUsing: Boolean = false): IXMLNode;
var
  LTags: TArray<string>;
  i: integer;
  LParentNode: IXMLNode;
  LItem: string;
  LIsNeedAddChild: boolean;
begin
  Result:= nil;

  LItem:= ifThen(aIsPredUsing, AParams[2], AParams[3]);
  if LItem.IsEmpty then
    Exit;

  LItem:= ReplaceStr(LItem, '<', '');
  LTags:= LItem.Split(['>']);

  if Length(LTags) < 1 then
    Exit;

  //Root
  Result:= FXML.ChildNodes.FindNode(LTags[0]);
  if not Assigned(Result) then
    Result:= FXML.AddChild(LTags[0]);

  if aIsPredUsing then
    LIsNeedAddChild:= (Length(AParams) > 4) and ((AParams[3].Split([':'])[0] = 'P') or (AParams[3] = 'T'))
  else
    LIsNeedAddChild:= (Length(AParams) > 4) and ((AParams[4].Split([':'])[0] = 'P') or (AParams[4] = 'T'));

  for i:= succ(Low(LTags)) to High(LTags) do
  begin
    LParentNode:= Result;
    Result:= IfThen(LIsNeedAddChild and (i = High(LTags)), nil, LParentNode.ChildNodes.FindNode(LTags[i]));

    if not Assigned(Result) then
      Result:= LParentNode.AddChild(LTags[i]);
  end;
end;

function TFormToEFileConverter.GetArrayValue(AParams: string): string;
var
  LInParams: TArray<string>;
  LParams: TArray<string>;
  LValues: TArray<string>;
  i: integer;
begin
  Result:= '';
  AParams:= trim(AParams);
  if AParams.IsEmpty then
    Exit;

  LInParams:= AParams.Split([':']);
  LParams:= LInParams[0].Split([',']);
  LValues:= LInParams[1].Split([',']);

  if Length(LParams) <> Length(LValues) then
    raise Exception.Create('TFormToEFileConverter.GetArrayValue -> Length LParams <> LValues AValues');

  for i:= Low(LParams) to High(LParams) do
    if FetchElm(FRetNo, FFormName, StrToInt(LParams[i])) = 'X' then
      Exit(LValues[i]);
end;

function TFormToEFileConverter.GetBoolValue(AParams: string; ALength: string): string;
var
  LParams: TArray<string>;
begin
  Result:= '';
  LParams:= AParams.Split([',']);

  case Length(LParams) of
    1: Result:= IfThen(FetchElm(FRetNo, FFormName, StrToInt(LParams[0])) = 'X', '1', '');
    2: Result:= IfThen(FetchElm(FRetNo, FFormName, StrToInt(LParams[0])) = 'X', '1', IfThen(FetchElm(FRetNo, FFormName, StrToInt(LParams[1])) = 'X', '2',''));
    3:
      begin
        if FetchElm(FRetNo, FFormName, StrToInt(LParams[0])) = 'X' then
          Result:= '1'
        else if FetchElm(FRetNo, FFormName, StrToInt(LParams[1])) = 'X' then
          Result:= '2'
        else if FetchElm(FRetNo, FFormName, StrToInt(LParams[2])) = 'X' then
          Result:= '3'
        else
          Result:= '';
      end;
  end;

  if not Result.IsEmpty and not ALength.IsEmpty and (ALength.ToInteger = 2) then
    Result:= '0' + Result;
end;

function TFormToEFileConverter.GetStringValue(AParams: string): string;
var
  LParams: TArray<string>;
  i: integer;
begin
  Result:= '';
  if AParams.IsEmpty then
    Exit;

  LParams:= AParams.Split([',']);
  if Length(LParams) = 0 then
    Exit;

  for i:= Low(LParams) to High(LParams) do
    Result:= IfThen(Result.IsEmpty, '', Result + ' ') + FetchElm(FRetNo, FFormName, StrToInt(LParams[i]));

  Result:= NormalizeStr(Result);
end;

function TFormToEFileConverter.GetValue(AParams: TArray<string>): string;
var
  lBoolParams: string;
  lParams: TArray<string>;
begin
  Result:= '';

  if Length(AParams) < 4 then
    exit;

  if AParams[0] = 'S' then
    Result:= GetStringValue(AParams[1])
  else
  if AParams[0] = 'S2' then
  begin
    lParams:= AParams[1].Split([',']);
    Result:= GetStringValue(lParams[0]) + ' ' + GetStringValue(lParams[1]);
  end else
  if AParams[0] = 'B' then
    Result:= GetBoolValue(AParams[1], AParams[2])
  else
  if (AParams[0] = 'B0') then
  begin
    if (Pos('|', AParams[1]) > 0) then
    begin
      lBoolParams:= StringReplace(AParams[1], '|', ',', [rfReplaceAll]);
      Result:= GetBoolValue(lBoolParams, AParams[2]);
    end else
      Result:= GetBoolValue(AParams[1], AParams[2]);

    if Result.Equals('') then Result:= '0';
  end else
  //20260220 Igor >>>
  if AParams[0] = 'B1' then
  begin
    Result:= IfThen(GetStringValue(AParams[1]).Equals('Y'), '1', '2');
  end else
  //20260220 Igor <<<
  if (AParams[0] = 'B2') and (Pos('|', AParams[1]) > 0) then
  begin
    lBoolParams:= StringReplace(AParams[1], '|', ',', [rfReplaceAll]);
    Result:= GetBoolValue(lBoolParams, AParams[2]);
  end else
  if AParams[0] = 'AV' then
    Result:= GetArrayValue(AParams[1])
  else
  //20260220 Igor >>>
  if AParams[0] = 'N' then
  begin
    Result:= NormalizeStr(FetchElm(FRetNo, FFormName, StrToInt(AParams[1])));//20260220 Igor
    Result:= ReplaceStr(Result, ' ', '');//20260220 Igor
    Result:= ReplaceStr(Result, ' ', '');//20260220 Igor
  end else
  //20260220 Igor <<<
  if AParams[0] = 'SV' then
    Result:= NormalizeStr(ReplaceStr(AParams[1], '%20%', ' '));
end;

function TFormToEFileConverter.Init: boolean;
begin
  FXML.ChildNodes.Clear;
  GetEOLParms(FOnLineNo, FPassword, FEFPath);
  FEFPath:= TPath.Combine(FEFPath, FFormName);
  ForceDirectories(FEFPath);
  FRetNo:= GetCurrentRetNo;
  LoadChildrenForm;
  Result:= FChildrenFormList.Count > 0;
end;

procedure TFormToEFileConverter.LoadChildrenForm;
begin
  FChildrenFormList.Clear;
  FChildrenFormList.Add(FFormName);
  FChildrenFormList.Add('PS1');
  //if GetBoolValue('65,66') = '1' then
  //if GetBoolValue('71,72') = '1' then
  FChildrenFormList.Add('PS2');
  //if GetBoolValue('73,74') = '1' then
  FChildrenFormList.Add('PS5');
  //if GetBoolValue('75,76') = '1' then
  FChildrenFormList.Add('PS6');
  //if GetBoolValue('77,78') = '1' then
  FChildrenFormList.Add('PS8');
  FChildrenFormList.Add('PS9');
  //if GetBoolValue('81,82') = '1' then
  FChildrenFormList.Add('PS12');
  //if GetBoolValue('87,88') = '1' then
  FChildrenFormList.Add('PS50'); ///???
  FChildrenFormList.Add('PS52');
  //if GetBoolValue('3,4') = '1' then
  FChildrenFormList.Add('PS58');
  //if GetBoolValue('5,6') = '1' then
  FChildrenFormList.Add('PS63');
  //if GetBoolValue('50,51') = '1' then
  FChildrenFormList.Add('PS65');
  FChildrenFormList.Add('PS75');
  FChildrenFormList.Add('PS78');

  FChildrenFormList.Add('PS100'); ///???
  FChildrenFormList.Add('PS125'); ///???
  FChildrenFormList.Add('PS130'); ///??? not found
  FChildrenFormList.Add('PS140'); ///??? not found
  FChildrenFormList.Add('PS141'); ///???
  FChildrenFormList.Add('PS8-1'); ///???
end;

function TFormToEFileConverter.LoadFormFields: boolean;
var
  i: integer;
  LFormName: string;
begin
  FFieldList.Clear;
  FFieldList.LoadFromFile(Appdir + '\' + C_RoleFileName);
  LFormName:= IfThen(FFormName = FParentFormName, FFormName, Format('%s:%s', [FParentFormName, FFormName]));

  for i:= pred(FFieldList.Count) downto 0 do
  begin
    if not FFieldList[i].IsEmpty and (FFieldList[i].Split([' ', #9])[0] = LFormName) then
      FFieldList[i]:= trim(Copy(FFieldList[i], Length(LFormName) + 1, MaxInt))
    else
      FFieldList.Delete(i);
  end;

  Result:= FFieldList.Count > 0;
end;

function TFormToEFileConverter.NormalizeStr(AValue: string): string;
begin
  Result:= ReplaceStr(AValue,  '’', '''');
end;

function TFormToEFileConverter.ReplaceSpace(AValue: string): string;
begin
  if AValue <> trim(AValue) then
    Result:= trim(AValue) + #9
  else
    Result:= AValue;
end;

function TFormToEFileConverter.ReplaceStrParams(AValue: string): string;
var
  LParams: TArray<string>;
  LLine: string;
begin
  Result:= '';
  LParams:= AValue.Split(['"','''']);

  for LLine in LParams do
    Result:= Result + ReplaceStr(ReplaceSpace(LLine), ' ', '%20%');
end;

{ TVirtualTable }

//FieldParams
//0 - DataType
//1 - MaxLength
//2 - Tag
//AValues (table values)
//0 = "T" - table data tape
//1 - Data Array
//2 - Tags - table name

procedure TVirtualTable.AddTableValue(AValues: TArray<string>);
var
  LParams: TArray<string>;
  LFieldParams: TArray<string>;
  i: integer;
  LNode: IXMLNode;
  LFieldTag: string;
  LFieldTagParams: TArray<string>;
  LValueParams: string;
  LItem: string;
  LTags: TArray<string>;
  lXMLNode: IXMLNode;
  lParentNode: IXMLNode;
  ifor: Integer;

  function AddFieldNode(aXMLNode: IXMLNode; aFieldNodeName, aBeforeNodeNames: string): IXMLNode;
  begin
    if Assigned(aXMLNode) then
    begin
      aFieldNodeName:= ReplaceStr(aFieldNodeName, AValues[2], '');

      if not aFieldNodeName.Equals('') then
      begin
        lNode:= aXMLNode.ChildNodes.FindNode(aFieldNodeName);

        if not Assigned(lNode) then
        begin
          lItem:= ReplaceStr(ReplaceStr(aFieldNodeName, '<', ''), '>', '');
          lNode:= aXMLNode.AddChild(lItem);
        end;
      end;

      Result:= lNode;
    end;
  end;

  function GetTTValuesList(aNodesName: string): TStringList;
  var
    lLine: string;
    lValues: TArray<string>;
  begin
    Result:= TStringList.Create;

    for lLine in FParent.FFieldList do
    begin
      lValues:= FParent.ReplaceStrParams(LLine).Split([' ', #9]);

      if (Length(lValues) > 0) and (lValues[0].Equals('TT')) and LowerCase(aNodesName).Equals(LowerCase(lValues[2])) then
        Result.Add(lLine);
    end;
  end;

  function IsTableLineDataFilled(aFields: TStringList; aParams: TArray<string>): Boolean;
  var
    ffor: Integer;
    lFieldValues: TArray<string>;
    lValParams: string;
  begin
    Result:= False;

    if not Assigned(aFields) then Exit;

    for ffor:= 0 to pred(aFields.Count) do
    begin
      lFieldValues:= FParent.ReplaceStrParams(aFields[ffor]).Split([' ', #9]);

      if not lFieldValues[0].Equals('SV') and not lFieldValues[0].Equals('NT') then
      begin
        lValParams:= Format('%s %s %s %s', [lFieldValues[0], aParams[ffor], lFieldValues[1], 'T']);

        if not FParent.GetValue(lValParams.Split([' '])).IsEmpty() then
        begin
          Result:= True;
          Break;
        end;
      end;
    end;
  end;

  procedure AddNTValues(aParentNode: IXMLNode; aTTLineIndex: Integer; aList: TStringList);
  var
    lVTable: TVirtualTable;
    lLNode: IXMLNode;
    lDataLine: string;
    lValues: TArray<string>;
    lTTParams: TArray<string>;
    nfor, yfor, zfor, ffor: Integer;
    lTTLocalParams: TArray<string>;
    lChildNodeName: string;
    lFieldValues: TArray<string>;
    lTTValueParams: string;
  begin
    if (aTTLineIndex > aList.Count) or (aTTLineIndex < 0) then Exit;

    for nfor:= 0 to pred(FParent.FTables.FNestedTables.Count) do
      if LowerCase(FParent.FTables.FNestedTables.Strings[nfor]).Equals(LowerCase(lFieldParams[2])) then
      begin
        lVTable:= TVirtualTable(FParent.FTables.FNestedTables.Objects[nfor]);
        Break;
      end;

    if not Assigned(lVTable) then Exit;

    lDataLine:= aList[aTTLineIndex];
    lValues:= FParent.ReplaceStrParams(lDataLine).Split([' ', #9]);

    if Pos('|', lValues[1]) > 0 then
    begin
      lTTParams:= lValues[1].Split([',']);

      for yfor:= Low(lTTParams) to High(lTTParams) do
      begin
        lTTLocalParams:= lTTParams[yfor].Split(['|']);
        if Length(lTTLocalParams) <= 0 then Break;

        if IsTableLineDataFilled(lVTable.FFields, lTTLocalParams) then
        begin
          lLNode:= AddFieldNode(aParentNode, lValues[2], aValues[2]);

          if not Assigned(lLNode) then
            Exit;

          for ffor:= 0 to pred(lVTable.FFields.Count) do
          begin
            lFieldValues:= FParent.ReplaceStrParams(lVTable.FFields[ffor]).Split([' ', #9]);
            lChildNodeName:= ReplaceStr(lFieldValues[2], lValues[2], '');
            lChildNodeName:= ReplaceStr(ReplaceStr(lChildNodeName, '<', ''), '>', '');

            lTTValueParams:= Format('%s %s %s %s', [lFieldValues[0], lTTLocalParams[ffor], lFieldValues[1], 'T']);
            lNode.AddChild(lChildNodeName).NodeValue:= FParent.GetValue(lTTValueParams.Split([' ']));
          end;
        end;
      end;
    end;
  end;

var
  lTTValues: TStringList;
begin
  if Length(AValues) < 2 then
    Exit;

  LParams:= AValues[1].Split([',']);

  if Length(LParams) < FFields.Count then
    Exit;

  // If details blocks should be repeated every time when new table line start to recognize
  LItem:= AValues[2];
  if LItem.IsEmpty then
    Exit;

  LItem:= ReplaceStr(LItem, '<', '');
  LTags:= LItem.Split(['>']);

  if Length(LTags) < 1 then
    Exit;

  if not IsTableLineDataFilled(FFields, LParams) then Exit;

  //Root
  lXMLNode:= FParent.FXML.ChildNodes.FindNode(LTags[0]);
  if not Assigned(lXMLNode) then
    lXMLNode:= FParent.FXML.AddChild(LTags[0]);

  for ifor:= succ(Low(LTags)) to High(LTags) do
  begin
    lParentNode:= lXMLNode;
    lXMLNode:= lParentNode.ChildNodes.FindNode(LTags[ifor]);

    if not Assigned(lXMLNode) then
      lXMLNode:= LParentNode.AddChild(LTags[ifor])
    else
    if (ifor = High(LTags)) then
      lXMLNode:= LParentNode.AddChild(LTags[ifor]);
  end;
  {}

  for i:= 0 to pred(FFields.Count) do
  begin
    LFieldParams:= FFields[i].Split([' ', #9]);

    if Length(LFieldParams) = 0 then
      Continue;

    if (Length(LFieldParams) > 4) then
    begin
      lNode:= AddFieldNode(lXMLNode, lFieldParams[2], AValues[2]);

      if not Assigned(lNode) then
        Exit;

      lItem:= lFieldParams[3];

      if (lItem.Split([':'])[0] = 'P') and (lItem.Split([':'])[1] = 'FieldCodeAmountRule') then
      begin
        lNode.AddChild(C_FieldCode).NodeValue:= lFieldParams[4];
        lValueParams:= Format('%s %s %s %s', [lFieldParams[0], lParams[i], lFieldParams[1], 'T']);
        lNode.AddChild(C_FieldAmount).NodeValue:= FParent.GetValue(lValueParams.Split([' ']));
      end;
    end else
    begin
      if lFieldParams[0].Equals('NT') then
      begin
        lTTValues:= GetTTValuesList(lFieldParams[2]);
        try
          AddNTValues(lXMLNode, StrToIntDef(LParams[i], -1), lTTValues);
        finally
          lTTValues.Free;
        end;
      end else
      begin
        //20260220 Igor >>>
        lValueParams:= Format('%s %s %s %s', [lFieldParams[0], lParams[i], lFieldParams[1], 'T']);

        if (FParent.GetValue(lValueParams.Split([' '])) = '') then
        begin
        end else
        begin
          lNode:= AddFieldNode(lXMLNode, lFieldParams[2], AValues[2]);

          if not Assigned(lNode) then
            Continue;

          lNode.NodeValue:= FParent.GetValue(lValueParams.Split([' ']));
        end;
        //20260220 Igor <<<
      end;
    end;
  end;
end;

constructor TVirtualTable.Create(AParent: TFormToEFileConverter);
begin
  inherited Create;
  FParent:= AParent;
  FFields:= TStringList.Create;
end;

destructor TVirtualTable.Destroy;
begin
  FFields.Free;
  inherited;
end;

{ TVirtualTables }

procedure TVirtualTables.AddXMLValue(AValues: TArray<string>);
var
  ifor: integer;
begin
  if Length(AValues) < 3 then
    Exit;

  for ifor:= 0 to pred(FTables.Count) do
    if LowerCase(FTables.Strings[ifor]).Equals(LowerCase(AValues[2])) then
    begin
      TVirtualTable(FTables.Objects[ifor]).AddTableValue(AValues);
      Break;
    end;
end;

procedure TVirtualTables.Clear;
var
  i: integer;
begin
  for i:= 0 - 1 to pred(FTables.Count) do
    FTables.Objects[i].Free;

  FTables.Clear;
end;

constructor TVirtualTables.Create(AParent: TFormToEFileConverter);
begin
  FTables:= TStringList.Create;
  FNestedTables:= TStringList.Create;
  FParent:= AParent;
end;

destructor TVirtualTables.Destroy;
begin
  FTables.Free;
  FNestedTables.Free;
  inherited;
end;

procedure TVirtualTables.FillTables(AList: TStringList);
var
  ATable: TVirtualTable;
  i: integer;
begin
  FTables.Clear;
  FNestedTables.Clear;

  if AList.Count = 0 then
    exit;

  for i:= pred(AList.Count) downto 0 do
  begin
    if AList[i].Split([' ', #9])[0] = 'TE' then
    begin
      ATable:= TVirtualTable.Create(FParent);
      FTables.AddObject(AList[i].Split([' ', #9])[1], ATable);
      AList.Delete(i);
    end else
    if AList[i].Split([' ', #9])[0] = 'TS' then
    begin
      ATable:= nil;
      AList.Delete(i);
    end else
    if Assigned(ATable) then
    begin
      ATable.FFields.Insert(0, AList[i]);
      AList.Delete(i);
    end;
  end;

  for i:= pred(AList.Count) downto 0 do
  begin
    if AList[i].Split([' ', #9])[0] = 'NTE' then
    begin
      ATable:= TVirtualTable.Create(FParent);
      FNestedTables.AddObject(AList[i].Split([' ', #9])[1], ATable);
      AList.Delete(i);
    end else
    if AList[i].Split([' ', #9])[0] = 'NTS' then
    begin
      ATable:= nil;
      AList.Delete(i);
    end else
    if Assigned(ATable) then
    begin
      ATable.FFields.Insert(0, AList[i]);
      AList.Delete(i);
    end;
  end;
end;

end.
