unit Authorize;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.Generics.Collections, Vcl.Samples.Spin, VCL.Printers, System.UITypes, Vcl.Clipbrd;

type
  TF1Rec = class(TObject)
    TaxYear: String;
    Name: String;
    Id: String;
    Factor: Integer;
    Factor2: Integer;
    Level: String;
  end;

  TfrmAuthorize = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtRootSourceFolder: TEdit;
    btnBrowse: TButton;
    pgcYears: TPageControl;
    btnRefresh: TButton;
    pnlTools: TPanel;
    GroupBox1: TGroupBox;
    btnCreateSingleKey: TButton;
    btnValidateSingleKey: TButton;
    btnSaveSingleKeyToFile: TButton;
    edtSingleKey: TEdit;
    edtSaveSingleKeyLocation: TEdit;
    mmoValidateSingleKey: TMemo;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    edKeyCount: TSpinEdit;
    btnGenerateXKeys: TButton;
    btnPrintXKeys: TButton;
    lbXKeys: TListBox;
    Splitter2: TSplitter;
    GroupBox3: TGroupBox;
    btnGenerateProductsPHP: TButton;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateSingleKeyClick(Sender: TObject);
    procedure btnValidateSingleKeyClick(Sender: TObject);
    procedure btnSaveSingleKeyToFileClick(Sender: TObject);
    procedure btnGenerateXKeysClick(Sender: TObject);
    procedure btnPrintXKeysClick(Sender: TObject);
    procedure btnGenerateProductsPHPClick(Sender: TObject);
    procedure FillKeyList(AList: TListView; AAppID: string); //20171031 Igor
  private
    { Private declarations }
    FF1RecList: TObjectList<TF1Rec>;
    function FindEditByTag<T: TControl>(AControl: TWinControl; ATag: Integer): T;
    function GetCloudOptions: Integer; //20190305 Igor
    procedure LBClick(Sender: TObject);
    function MakeKey(const AName, AID, ALevel: String; AF1, AF2: Integer;
      ACurrTabSheet: TTabSheet; const AKeyItems: TList<integer>): String;//20171031 Igor
    function ValidateKey(const AKey: String; out AResult: String): Boolean;
    function FindF1RecByAppID(AAppID: String): TArray<TF1Rec>;
    function PrepareKeyGenerate(out AName, AID, ALevel: String; out AF1,
      AF2: Integer; out APage: TTabSheet; out AKeyItems: TList<integer>): Boolean;//20171031 Igor
    function GetF1RecByKey(const AKey: String): TF1Rec;
    function CurrPage: TTabSheet;
  public
    { Public declarations }
  end;

var
  frmAuthorize: TfrmAuthorize;

implementation

{$R *.dfm}

uses
  System.IOUtils, System.Types, System.RegularExpressions, System.IniFiles, StrUtils,
  vtKeyList;//20171031 Igor

const
  c_F2EditTag = 100;
  c_NameEditTag = 101;
  c_IDEditTag = 102;
  c_F1EditTag = 103;
  c_LevelEditTag = 104;
  c_DateExpEditTag = 105;
  c_DateExpEditTagNote = 106;
  c_F2_SEditTag = 107;
  c_DemoLevelName = 'llDemo';
  c_LimitedFormsList = 108; //20171031 Igor
  //20190305 Igor >>>
  c_T1CloudTag = 1;
  c_T2CloudTag = 2;
  c_T3CloudTag = 3;
  c_T4CloudTag = 4;
  c_TFCloudTag = 5;
  c_FPCloudTag = 6;
  c_Helper = 1000;
  //20190305 Igor <<<
  c_LimitedFormsName = 'llLimitedForms'; //20171031 Igor

procedure TfrmAuthorize.btnBrowseClick(Sender: TObject);
begin
{$WARN SYMBOL_PLATFORM OFF}
   with TFileOpenDialog.Create(nil) do
    try
      Title := 'Select Directory';
      Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
      OkButtonLabel := 'Select';
      DefaultFolder := edtRootSourceFolder.Text;
      FileName := edtRootSourceFolder.Text;
      if Execute then
        edtRootSourceFolder.Text := FileName;
    finally
      Free;
    end
{$WARN SYMBOL_PLATFORM ON}
end;

function Unqote(S: String; B: Char = ''''; E: Char = ''''): String;
begin
  if (length(S) > 0) and (S[1] = B) then
    Delete(S, 1, 1);
  if (length(S) > 0) and (S[Length(S)] = E) then
    Delete(S, Length(S), 1);
  Result := S;
end;


function PaddZero(S: String; Len: Integer): String;
begin
  Result := S;
  while length(Result) < Len do
    Result := '0' + Result;
end;

function GetRandomNum(BaseNum: Integer): Integer;
begin
  Randomize;
  Result := Random(BaseNum);
end;

function GetHash(const AID, ARandom1, ARandom2: String; Factor, Factor2: Integer): String;
var
  HashNum: Integer;
begin
  HashNum :=  (StrToInt(AID[3]) + StrToInt(AID[4])) * (Factor + Factor2)
           + Factor2
           + (StrToInt(ARandom1[1]) + StrToInt(ARandom1[2]) + StrToInt(ARandom1[3]) + StrToInt(ARandom1[4])) * Factor
           + (StrToInt(ARandom2[1]) + StrToInt(ARandom2[2]) + StrToInt(ARandom2[3]) + StrToInt(ARandom2[4])) * Factor;
  Result := PaddZero(Trim(IntToStr(HashNum)),4);
end;

function GetHelperHash(const AID, ARandom1, ARandom2, ARandom3: String; Factor, Factor2: Integer): String; //20190305 Igor
var
  HashNum: Integer;
begin
  HashNum :=  (StrToInt(AID[3]) + StrToInt(AID[4])) * (Factor + Factor2)
           + Factor2
           + (StrToInt(ARandom1[1]) + StrToInt(ARandom1[2]) + StrToInt(ARandom1[3]) + StrToInt(ARandom1[4])) * Factor
           + (StrToInt(ARandom2[1]) + StrToInt(ARandom2[2]) + StrToInt(ARandom2[3]) + StrToInt(ARandom2[4])) * Factor
           + (StrToInt(ARandom3[1]) + StrToInt(ARandom3[2]) + StrToInt(ARandom3[3]) + StrToInt(ARandom3[4]));
  Result := PaddZero(Trim(IntToStr(HashNum)),4);
end;

function CommonMakeKey(const AID, ARandom1, ARandom2: String; Factor, Factor2: Integer): String;
begin
  Result := AID + '-' + ARandom1 + '-' + ARandom2 + '-' + GetHash(AID, ARandom1, ARandom2, Factor, Factor2);
end;

function HelperMakeKey(const AID, ARandom1, ARandom2, ARandom3: String; Factor, Factor2: Integer): String; //20190305 Igor
begin
  Result := AID + '-' + ARandom1 + '-' + ARandom2 + '-' + ARandom3 + '-' + GetHelperHash(AID, ARandom1, ARandom2, ARandom3, Factor, Factor2);
end;

procedure MyXOR(var S: String; const r1, r2, r3: Integer); overload; //20190305 Igor
var
  X: Integer;
begin
  X := r1 * 1000 + r2 * 100 + r3 * 10 + r2 + r1 + ((r1 + r2 + r3) mod 5) * 10000;
  S := PaddZero(IntToStr(StrToInt(S) xor X), 5);
end;

procedure MyXOR(var S: String; const r1, r2: Integer); overload; //20190305 Igor
var
  X: Integer;
begin
  X := r1 * 10 + r2;
  S := PaddZero(IntToStr(StrToInt(S) xor X), 2);
end;

procedure GenerateMid(ADate: TDateTime; out ARandom1, ARandom2: String); overload;//20171031 Igor
var
  S: String;
  r1, r2, r3: Integer;
begin
  repeat
    S := IntToStr(Trunc(ADate));
    randomize;
    r1 := Random(9);
    r2 := Random(9);
    r3 := Random(9);
    MyXOR(S, r1, r2, r3);
  until Length(S) = 5;

  ARandom1 := copy(S, 1, 4);
  ARandom2 := copy(S, 5, 1) + IntToStr(r1) + IntToStr(r2) +IntToStr(r3);
end;

function GenerateCloudOptions(ACloudOptions: Integer): string; //20190305 Igor
var
  S: String;
  r1, r2: Integer;
begin
  repeat
    S := IntToStr(ACloudOptions);
    randomize;
    r1 := Random(9);
    r2 := Random(9);
    MyXOR(S, r1, r2);
  until Length(S) = 2;

  Result := S + IntToStr(r1) + IntToStr(r2);
end;

function DoMakeDemoKey(const AID: String; ADateExp: TDateTime; const AF1, AF2: Integer): String;
var
  Random1, Random2: String;
begin
  GenerateMid(ADateExp, Random1, Random2);
  Result := CommonMakeKey(AID, Random1, Random2, AF1, AF2);
end;

function DoMakeNormalKey(const AID: String; const AF1, AF2: Integer): String;
begin
  Result := CommonMakeKey(AID, PaddZero(IntToStr(GetRandomNum(9999)), 4), PaddZero(IntToStr(GetRandomNum(8888)), 4), AF1, AF2);
end;

function DoMakeHelperDemoKey(const AID: String; ADateExp: TDateTime; const AF1, AF2, ACloudOptions: Integer): String; //20190305 Igor
var
  Random1, Random2: String;
begin
  GenerateMid(ADateExp, Random1, Random2);
  Result := HelperMakeKey(AID, Random1, Random2, GenerateCloudOptions(ACloudOptions), AF1, AF2);
end;

function DoMakeHelperKey(const AID: String; const AF1, AF2, ACloudOptions: Integer): string; //20190305 Igor
begin
  Result := HelperMakeKey(AID, PaddZero(IntToStr(GetRandomNum(8888)), 4), PaddZero(IntToStr(GetRandomNum(7777)), 4), PaddZero(GenerateCloudOptions(ACloudOptions), 4), AF1, AF2);
end;

function TfrmAuthorize.GetF1RecByKey(const AKey: String): TF1Rec; //20190305 Igor
var
  F1Recs: TArray<TF1Rec>;
  F1Rec: TF1Rec;
  A: TArray<String>;
begin
  A := AKey.Split(['-']);
  if length(A) = 4 then
  begin
    F1Recs := FindF1RecByAppID(A[0]);
    for F1Rec in F1Recs do
      if GetHash(A[0], A[1], A[2], F1Rec.Factor, F1Rec.Factor2) = A[3] then
        exit(F1Rec);
  end
  else
  begin
    F1Recs := FindF1RecByAppID(A[0]);
    for F1Rec in F1Recs do
      if GetHelperHash(A[0], A[1], A[2], A[3], F1Rec.Factor, F1Rec.Factor2) = A[4] then
        exit(F1Rec);
  end;
  Result := nil;
end;

//20171031 Igor>>>
procedure ExtractKeyItemFromInt(const aValue: integer; const aKeyItems: TList<integer>);
  function GetBit(Value: Word; Index: Byte): Boolean;
  begin
    Result := ((Value shr Index) and 1) = 1;
  end;
var
  i: integer;
begin
  for I := 0 to 15 do
  begin
    if GetBit(aValue, i) then
      aKeyItems.Add(i);
  end;
end;

procedure GenerateMid(AValue: string; out ARandom1, ARandom2: String); overload;
var
  S: String;
  r1, r2, r3: Integer;
begin
  repeat
    S := AValue;
    randomize;
    r1 := Random(9);
    r2 := Random(9);
    r3 := Random(9);
    MyXOR(S, r1, r2, r3);
  until Length(S) = 5;

  ARandom1 := copy(S, 1, 4);
  ARandom2 := copy(S, 5, 1) + IntToStr(r1) + IntToStr(r2) +IntToStr(r3);
end;

function DoMakeNewItemKey(const AID: String; const aKeyItems: TList<integer>; const AF1, AF2: integer): string;
  procedure SetBit(var Value: Word; Index: Byte);
  begin
    Value:=  Value or (Word(1) shl Index);
  end;
var
  Rights: Word;
  i: integer;
  Random1, Random2: String;
begin
  Rights := 0;
  for I := 0 to aKeyItems.Count - 1 do
    SetBit(Rights, aKeyItems[i]);
  GenerateMid(PaddZero(IntToStr(Rights), 5), Random1, Random2);
  Result := CommonMakeKey(AID, Random1, Random2, AF1, AF2);
end;
//20171031 Igor<<<

function TfrmAuthorize.ValidateKey(const AKey: String; out AResult: String): Boolean; //20190305 Igor
var
  A: TArray<String>;
  r1, r2, r3, I, l: Integer;//20171031 Igor
  S: String;
  D: TDate;
  F1Recs: TArray<TF1Rec>;
  F1Rec: TF1Rec;
  AKeyItems: TList<integer>; //20171031 Igor
  TS: TTabSheet; //20171031 Igor
begin
  A := AKey.Split(['-']);
  if Length(A) = 4 then
  begin
    if (length(A[0]) <> 4) or (length(A[1]) <> 4) or (length(A[2]) <> 4) or (length(A[3]) <> 4) then
    begin
      AResult := 'The key should be of the form "ееее-ееее-ееее-ееее".';
      exit(False);
    end;
  end
  else if Length(A) = 5 then
  begin
    if (length(A[0]) <> 4) or (length(A[1]) <> 4) or (length(A[2]) <> 4) or (length(A[3]) <> 4) or (length(A[4]) <> 4) then
    begin
      AResult := 'The key should be of the form "ееее-ееее-ееее-ееее-XXXX".';
      exit(False);
    end;
  end
  else
  begin
    AResult := 'The key should be of the form "ееее-ееее-ееее-ееее".';
    exit(False);
  end;

  F1Recs := FindF1RecByAppID(A[0]);
  F1Rec := GetF1RecByKey(AKey);
  if Not Assigned(F1Rec) then
  begin
    AResult := 'Invalid key!';
    Exit(False);
  end;
  AResult := 'Key Valid; TaxYear: ' + F1Rec.TaxYear +
    '; AppName: ' + F1Rec.Name +
    '; App ID: ' + F1Rec.Id +
    '; Level: ' + F1Rec.Level;
  if Length(A) = 4 then
  begin
    if SameText(F1Rec.Level, c_DemoLevelName) then
    begin
      S := A[1] + Copy(A[2], 1, 1);
      r1 := StrToInt(A[2][2]);
      r2 := StrToInt(A[2][3]);
      r3 := StrToInt(A[2][4]);
      MyXOR(S, r1, r2, r3);
      I := StrToInt(S);
      D := I;
      AResult := AResult + '; Exp. date: ' + FormatDateTime('YYYY-MM-DD', D);
    end;
    //20171031 Igor>>>
    TS := CurrPage;
    if (SameText(F1Rec.Level, c_LimitedFormsName)) and Assigned(TS) then
    begin
      S := A[1] + Copy(A[2], 1, 1);
      r1 := StrToInt(A[2][2]);
      r2 := StrToInt(A[2][3]);
      r3 := StrToInt(A[2][4]);
      MyXOR(S, r1, r2, r3);
      I := StrToInt(S);
      AKeyItems := TList<integer>.Create;
      try
        ExtractKeyItemFromInt(I, AKeyItems);
        S := '';
        for I := 0 to AKeyItems.Count - 1 do
          for l := 0 to Length(KeyList) -1 do
            if (KeyList[l].AppID = TS.Caption) and (KeyList[l].ID = TSubKeyID(AKeyItems[i])) then
              S := S + IfThen(S = '', '', '; ') + ArrToString(KeyList[l].FormList);
        if S <> '' then
          AResult := AResult + '; Forms: ' + S;
      finally
        AKeyItems.Free;
      end;
    end;
  end
  else if Length(A) = 5 then
  begin
    if SameText(F1Rec.Level, c_DemoLevelName) then
    begin
      S := A[1] + Copy(A[2], 1, 1);
      r1 := StrToInt(A[2][2]);
      r2 := StrToInt(A[2][3]);
      r3 := StrToInt(A[2][4]);
      MyXOR(S, r1, r2, r3);
      I := StrToInt(S);
      D := I;
      AResult := AResult + '; Exp. date: ' + FormatDateTime('YYYY-MM-DD', D);
    end;

  end;
  //20171031 Igor<<<
  { //for the future
  else
  if SameText(F1Rec.Level, c_LimitFormsLevelName) then
    //Check forms limit
  else
  if SameText(F1Rec.Level, c_LimitReturnsLevelName) then
    //Check returns limit
  else}

  Result := True;
end;

function TfrmAuthorize.PrepareKeyGenerate(out AName, AID, ALevel: String;
  out AF1, AF2: Integer; out APage: TTabSheet; out AKeyItems: TList<integer>): Boolean;//20171031 Igor
var
  aLV: TListView; //20171031 Igor
  i: Integer;
begin
  Result := False;
  APage := CurrPage;
  if not Assigned(APage) then
    Exit;
  AName := FindEditByTag<TEdit>(APage, c_NameEditTag).Text;
  AID := FindEditByTag<TEdit>(APage, c_IDEditTag).Text;
  ALevel := FindEditByTag<TEdit>(APage, c_LevelEditTag).Text;
  AF1 := StrToIntDef(FindEditByTag<TEdit>(APage, c_F1EditTag).Text, 0);
  if not AID.isEmpty and SameText(AID[1], 'S') then
    AF2 := StrToIntDef(FindEditByTag<TEdit>(APage, c_F2_SEditTag).Text, 0)
  else
    AF2 := StrToIntDef(FindEditByTag<TEdit>(APage, c_F2EditTag).Text, 0);
  Result := (AF1 > 0) AND (AF2 > 0);
  //20171031 Igor>>>
  aLV := FindEditByTag<TListView>(APage, c_LimitedFormsList);
  if Assigned(aLV) and (aLV.Visible) and (Result) then
  begin
    Result := False;
    for I := 0 to aLV.Items.Count - 1 do
      if aLV.Items[i].Checked then
      begin
        AKeyItems.Add(integer(aLV.Items[i].Data));
        Result := True;
      end;
  end;
  //20171031 Igor<<<
end;

procedure TfrmAuthorize.btnCreateSingleKeyClick(Sender: TObject);
var
  Name, ID, Level: String;
  F1, F2: Integer;
  Page: TTabSheet;
  KeyItems: TList<integer>; //20171031 Igor
begin
  KeyItems := TList<integer>.Create;
  try//20171031 Igor
    if not PrepareKeyGenerate(Name, ID, Level, F1, F2, Page, KeyItems) then //20171012 Igor
    begin
      edtSingleKey.Text := '';
      exit;
    end;
    edtSingleKey.Text := MakeKey(Name, ID, Level, F1, F2, page, KeyItems); //20171012 Igor
  finally//20171031 Igor
    KeyItems.Free; //20171031 Igor
  end;//20171031 Igor
end;

procedure TfrmAuthorize.btnGenerateXKeysClick(Sender: TObject);
var
  Name, ID, Level: String;
  I, F1, F2: Integer;
  Page: TTabSheet;
  KeyItems: TList<integer>; //20171031 Igor
begin
  KeyItems := TList<integer>.Create; //20171031 Igor
  Screen.Cursor := crHourGlass;
  try
    if not PrepareKeyGenerate(Name, ID, Level, F1, F2, Page, KeyItems) then//20171031 Igor
      exit;
    lbXKeys.Items.BeginUpdate;
    try
      lbXKeys.Clear;
      For i := 1 to edKeyCount.Value do
      begin
        lbXKeys.Items.Add(MakeKey(Name, ID, Level, F1, F2, page, KeyItems));//20171031 Igor
      end;
    finally
      lbXKeys.Items.EndUpdate;
    end;
  finally
    Screen.Cursor:=crDefault;
    KeyItems.Free;//20171031 Igor
  end;
end;

procedure TfrmAuthorize.btnPrintXKeysClick(Sender: TObject);
var
  PixPerInX, PixPerInY, TopMargin, LeftMargin, LabelHeight, LabelWidth,
  LabelPosX, LabelPosY, VertIncr, HorizLabelGap,

  RecNo: Integer;

  Key: String;
  F1Rec: TF1Rec;

  Procedure PrintALabel(LabelPosX, LabelPosY: integer;
    Line1, Line2, Line3, Line4, Line5: String);
  Var
    XPos, YPos: Integer;
  begin
    XPos := LabelPosX + 2;
    YPos := LabelPosY + 2;
    Printer.Canvas.Font.Style := [fsBold];
    Printer.Canvas.TextOut(XPos, YPos, Line1);
    Printer.Canvas.Font.Style := [];
    Printer.Canvas.TextOut(XPos, YPos + 1 * VertIncr, Line2);
    Printer.Canvas.TextOut(XPos, YPos + 2 * VertIncr, Line3);
    Printer.Canvas.TextOut(XPos, YPos + 3 * VertIncr, Line4);
    Printer.Canvas.TextOut(XPos, YPos + 4 * VertIncr, Line5);
  end;

begin
  Screen.Cursor := crHourGlass;
  try
    {Set up label parameters}
    PixPerInX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
    PixPerInY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
    TopMargin  := Trunc(0.5 * PixPerInY);
    LeftMargin := Trunc(1 / 8 * PixPerInY);
    LabelHeight:= Trunc(1 * PixPerInY);  {1 inch}
    LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
    VertIncr :=  Trunc(PixPerInY * (1 / 6));   {6 lines per inch}
    HorizLabelGap := Trunc(1 / 8 *  PixPerInX);

    {start printer}
    Printer.BeginDoc;
    try
      RecNo := 0;
      Printer.Canvas.Font.Name := 'Arial';
      For Key in lbXKeys.Items do
      begin
        F1Rec := GetF1RecByKey(Key);
        if not Assigned(F1Rec) then
          Continue;
        Inc(RecNo);
        If RecNo > 30 then
        begin
          RecNo := 1;
          Printer.NewPage;
        end;

        If RecNo < 11 then  {left label}
        begin
          LabelPosX := LeftMargin;
          LabelPosY := TopMargin + (RecNo - 1) * LabelHeight;
        end
        else
        If (RecNo < 21) then  {Midle label}
        begin
          LabelPosX := LeftMargin + LabelWidth + HorizLabelGap;
          LabelPosY := TopMargin + (RecNo - 11) * LabelHeight;
        end
        else
        begin
          LabelPosX := LeftMargin + 2 * LabelWidth + 3 * HorizLabelGap;
          LabelPosY := TopMargin + (RecNo - 21) * LabelHeight;
        end;
        PrintALabel(LabelPosX, LabelPosY, F1Rec.TaxYear + ' - ' + F1Rec.Name,
          'Authorization Key', Key, ' ', ' ');
      end; {end while}
    finally
      Printer.EndDoc;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfrmAuthorize.btnRefreshClick(Sender: TObject);
var
  DirsYear, DirsApp: TStringDynArray;
  S, DirYear, DirApp, AppFile, F1, F2, F2_S: String; //20190307 Igor
  p: TTabSheet;
  pgc: TPageControl;
  LB: TListBox;
  M: TMatch;
  MC: TMatchCollection;
  App, F1Arr, FVal: TArray<String>;
  lbl: TLabel;
  ed: TEdit;
  dtp: TDateTimePicker;
  clb: TListView;//20171031 Igor
  cb: TCheckBox; //20190305 Igor
  I, J, Lvl, AI, Year: Integer; //20190307 Igor
  F1Rec: TF1Rec;
  HelperName: string; //20180113 Igor
  A: TArray<String>; //20190307 Igor

  procedure CreateCheckBox(ATop, ALeft, ATag: Integer; ACaption: String); //20190305 Igor
  begin
    cb := TCheckBox.Create(Self);
    cb.Parent := P;
    cb.Top := ATop;
    cb.Left := ALeft;
    cb.Caption := ACaption;
    cb.Tag := ATag;
  end;

  procedure CreateLabel(ATop, ALeft, ATag: Integer; ACaption: String);
  begin
    lbl := TLabel.Create(Self);
    lbl.Parent := P;
    lbl.Top := ATop;
    lbl.Left := ALeft;
    lbl.Caption := ACaption;
    lbl.AutoSize := True;
    lbl.Tag := ATag;
  end;

  procedure CreateEdit(ATop, ALeft, AWidth, ATag: Integer);
  begin
    ed := TEdit.Create(Self);
    ed.Parent := p;
    ed.Top := ATop;
    ed.Left := ALeft;
    ed.ReadOnly := True;
    ed.Width := AWidth;
    ed.Tag := ATag;
  end;

  procedure CreateDateTimePicker(ATop, ALeft, AWidth, ATag: Integer);
  begin
    dtp := TDateTimePicker.Create(Self);
    dtp.Parent := p;
    dtp.Top := ATop;
    dtp.Left := ALeft;
    dtp.Width := AWidth;
    dtp.Tag := ATag;
    dtp.Date := Date + 30;
    dtp.Time := 0;
  end;

  procedure CreatePareControl(ATop, ALeft, AWidth, ATag: Integer; ACaption: String);
  begin
    CreateLabel(ATop, ALeft, ATag, ACaption);
    CreateEdit(lbl.Top + lbl.Height + 4, lbl.Left, AWidth, ATag);
  end;
  //20171031 Igor>>>
  procedure CreateListView(ATop, ALeft, AWidth, aTag: Integer);
  begin
    clb := TListView.Create(Self);
    clb.Parent := p;
    clb.Top := ATop;
    clb.Left := ALeft;
    clb.Width := AWidth;
    clb.Tag := aTag;
    clb.Align := alRight;
    clb.Anchors := [akLeft, akRight];
    clb.ViewStyle := vsReport;
    clb.Checkboxes := True;
  end;
  //20171031 Igor<<<
begin
  //Clear
  FF1RecList.Clear;

  while pgcYears.PageCount > 0 do
    pgcYears.Pages[0].Free;
  DirsYear := TDirectory.GetDirectories(edtRootSourceFolder.Text);
  for DirYear in DirsYear do
  begin
    S := ExtractFileName(DirYear);
    if TRegEx.IsMatch(S, '^\d{4,4}$') then
    begin
      P := TTabSheet.Create(Self);
      P.Caption := 'VT-' + S;
      P.PageControl := pgcYears;
      pgc := TPageControl.Create(Self);
      pgc.Parent := P;
      pgc.Align := alClient;
      DirsApp := TDirectory.GetDirectories(DirYear);
      for DirApp in DirsApp do
      begin
        S := ExtractFileName(DirApp);
        if TRegEx.IsMatch(S, '^([a-zA-Z](\d|[a-zA-Z])){1,}\-\d{4,4}$') then
        begin
          AppFile := TPath.Combine(DirApp, StringReplace(S, '-', '_', [rfIgnoreCase]) + '.pas');
          if TFile.Exists(AppFile) then
          begin
            P := TTabSheet.Create(Self);
            P.Caption := S;
            P.PageControl := pgc;
            App := S.Split(['-']);

            LB := TListBox.Create(Self);
            LB.Parent := P;
            LB.Align := alLeft;
            LB.Width := 200;

            CreatePareControl(4, LB.Left + LB.Width + 4, 60, c_F2EditTag, 'Factor 2:');
            CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 60, c_F2_SEditTag, 'Factor 2(vtScan):');
            CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 150, c_NameEditTag, 'Name:');
            CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 150, c_IDEditTag, 'ID:');
            CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 60, c_F1EditTag, 'Factor 1:');
            CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 150, c_LevelEditTag, 'Level:');

            CreateLabel(4, LB.Left + LB.Width + 4 + 150 + 4, c_DateExpEditTag, 'Date expiring:');
            CreateDateTimePicker(lbl.Top + lbl.Height + 4, lbl.Left, 100, c_DateExpEditTag);
            CreateLabel(dtp.Top + dtp.Height + 4, LB.Left + LB.Width + 4 + 150 + 4, c_DateExpEditTagNote,
              'For an unlimited key, set the expiration date' + #13 +
              'in the far future. For example, January 31, 2100');
            CreateListView(4, 4, 350, c_LimitedFormsList);//20171031 Igor


            //clear comments
            S := TFile.ReadAllText(AppFile);
            S := TRegEx.Replace(S, '\(\*.{0,}?\*\)', '', [roSingleLine]);
            S := TRegEx.Replace(S, '\{.{0,}?\}', '', [roSingleLine]);
            S := TRegEx.Replace(S, '\/\/.{0,}?\r\n', #13#10, []);
            //Factory 2
            M := TRegEx.Match(S, ' *' + App[0] + 'F(2\_){0,1}' + App[1] + ' *= *\d{2,3} *;');
            if M.Success then
            begin
              F2 := M.Value;
              Delete(F2, 1, pos('=', F2));
              FindEditByTag<TEdit>(P, c_F2EditTag).Text := TRegEx.Match(F2, '\d*').Value;
            end;

            //Factory 2 for Scan
            M := TRegEx.Match(S, ' *' + ReplaceStr(App[0], 'T', 'S') + 'F(2\_){0,1}' + App[1] + ' *= *\d{2,3} *;');
            if M.Success then
            begin
              F2_S := M.Value;
              Delete(F2_S, 1, pos('=', F2_S));
              FindEditByTag<TEdit>(P, c_F2_SEditTag).Text := TRegEx.Match(F2_S, '\d*').Value;
            end;

            M := TRegEx.Match(S, 'PgmLicenses\: *array\[0\.\.\d{1,}\] +of +RPgmLicenseData *=');
            if M.Success then
            begin
              I := M.Index + M.Length;
              while S[I] <> '(' do
                inc(I);
              J := 0;
              Lvl := 1;
              repeat
                inc(J);
                if S[I + J] = '(' then
                  inc(Lvl)
                else
                if S[I + J] = ')' then
                  Dec(Lvl);
              until Lvl = 0;
              F1 := StringReplace(Copy(S, I + 1, J - 2), #13#10, '', [rfReplaceAll]);
              //F1 := StringReplace(F1, ' ', '', [rfReplaceAll]);
              MC := TRegEx.Matches(F1, '\(.*?\)');
              for M in MC do
              begin
                F1Arr := M.Value.Split([';']);
                for I := 0 to length(F1Arr) - 1 do
                  F1Arr[I] := Trim(F1Arr[I]);
                F1Rec := TF1Rec.Create;
                F1Rec.TaxYear := P.Caption;
                for I := 0 to length(F1Arr) - 1 do
                begin
                  FVal := unqote(F1Arr[I], '(', ')').Split([':']);
                  if Length(FVal) <2 then
                    continue;
                  if SameText(FVal[0].Trim, 'name') then//20171031 Igor
                    F1Rec.Name := unqote(FVal[1].Trim)//20171031 Igor
                  else
                  if SameText(FVal[0].Trim, 'Id') then//20171031 Igor
                    F1Rec.Id := unqote(FVal[1].Trim)//20171031 Igor
                  else
                  if SameText(FVal[0].Trim, 'Factor') then//20171031 Igor
                    F1Rec.Factor := StrToIntDef(unqote(FVal[1].Trim), 0)//20171031 Igor
                  else
                  if SameText(FVal[0].Trim, 'Level') then//20171031 Igor
                    F1Rec.Level := unqote(FVal[1].Trim)//20171031 Igor
                end;
                if not F1Rec.Id.IsEmpty and SameText(F1Rec.Id[1], 'S') then
                  F1Rec.Factor2 := StrToIntDef(FindEditByTag<TEdit>(P, c_F2_SEditTag).Text, 0)
                else
                  F1Rec.Factor2 := StrToIntDef(FindEditByTag<TEdit>(P, c_F2EditTag).Text, 0);

                LB.Items.AddObject(F1Rec.Name, F1Rec);
                FF1RecList.Add(F1Rec);
              end;
            end;
            LB.OnClick := LBClick;
            if LB.Count > 0 then
            begin
              LB.ItemIndex := 0;
              LBClick(LB);
            end
          end;
        end;
      end;
    end
    //20180113 Igor >>>
    //20190307 Igor >>>
    else if SameText(S, 'COMMON') then
    begin
      DirsApp := TDirectory.GetDirectories(DirYear);
      for DirApp in DirsApp do
      begin
        S := ExtractFileName(DirApp);
        if TRegEx.IsMatch(S, '^(.*?)Helper') then
        begin
          HelperName := Copy(S, 1, Pos('Helper', S) - 1);
          AppFile := TPath.Combine(DirApp, HelperName + 'License' + '.pas');
          if TFile.Exists(AppFile) then
          begin
            P := TTabSheet.Create(Self);
            P.Caption := HelperName;
            P.PageControl := pgcYears;
            pgc := TPageControl.Create(Self);
            pgc.Parent := P;
            pgc.Align := alClient;

            //clear comments
            S := TFile.ReadAllText(AppFile);
            A := S.Split(['|']);
            for AI:= 0 to Length(A) do
            begin
              S := A[AI];
              S := TRegEx.Replace(S, '\(\*.{0,}?\*\)', '', [roSingleLine]);
              S := TRegEx.Replace(S, '\{.{0,}?\}', '', [roSingleLine]);
              S := TRegEx.Replace(S, '\/\/.{0,}?\r\n', #13#10, []);
              //Year
              M := TRegEx.Match(S, ' *F2_' + UpperCase(HelperName) + '_(\d{4}) *=');
              if M.Success then
                Year := StrToIntDef(Trim(ReplaceStr(ReplaceStr(M.Value, 'F2_'+ UpperCase(HelperName) + '_', ''), '=', '')), 0)
              else
                continue;

              P := TTabSheet.Create(Self);
              P.Caption := IntToStr(Year);
              P.PageControl := pgc;
              P.Tag := c_Helper;

              LB := TListBox.Create(Self);
              LB.Parent := P;
              LB.Align := alLeft;
              LB.Width := 200;

              CreatePareControl(4, LB.Left + LB.Width + 4, 60, c_F2EditTag, 'Factor 2:');
              CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 60, c_F2_SEditTag, 'Factor 2(vtScan):');
              CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 150, c_NameEditTag, 'Name:');
              CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 150, c_IDEditTag, 'ID:');
              CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 60, c_F1EditTag, 'Factor 1:');
              CreatePareControl(ed.Top + ed.Height + 4, LB.Left + LB.Width + 4, 150, c_LevelEditTag, 'Level:');

              CreateLabel(4, LB.Left + LB.Width + 4 + 150 + 4, c_DateExpEditTag, 'Date expiring:');
              CreateDateTimePicker(lbl.Top + lbl.Height + 4, lbl.Left, 100, c_DateExpEditTag);
              CreateLabel(dtp.Top + dtp.Height + 4, LB.Left + LB.Width + 4 + 150 + 4, c_DateExpEditTagNote,
                'For an unlimited key, set the expiration date' + #13 +
                'in the far future. For example, January 31, 2100');
              CreateListView(4, 4, 350, c_LimitedFormsList);//20171031 Igor

              //20190305 Igor >>>
              CreateCheckBox(lbl.Top + lbl.Height + 8, LB.Left + LB.Width + 4 + 160, c_T1CloudTag, 'T1');
              CreateCheckBox(cb.Top + cb.Height + 4, LB.Left + LB.Width + 4 + 160, c_T2CloudTag, 'T2');
              CreateCheckBox(cb.Top + cb.Height + 4, LB.Left + LB.Width + 4 + 160, c_T3CloudTag, 'T3');
              CreateCheckBox(cb.Top + cb.Height + 4, LB.Left + LB.Width + 4 + 160, c_T4CloudTag, 'T4');
              CreateCheckBox(cb.Top + cb.Height + 4, LB.Left + LB.Width + 4 + 160, c_TFCloudTag, 'TF');
              CreateCheckBox(cb.Top + cb.Height + 4, LB.Left + LB.Width + 4 + 160, c_FPCloudTag, 'FP');
              //20190305 Igor <<<

              //Factory 2
              M := TRegEx.Match(S, ' *F2_' + UpperCase(HelperName) + '_' + IntToStr(Year) + ' *= *\d{2,3} *;');
              if M.Success then
              begin
                F2 := M.Value;
                Delete(F2, 1, pos('=', F2));
                FindEditByTag<TEdit>(P, c_F2EditTag).Text := TRegEx.Match(F2, '\d*').Value;
              end
              else
                continue;

              M := TRegEx.Match(S, 'PgmLicenses_'+ IntToStr(Year) +'\: *array\[0\.\.\d{1,}\] +of +RPgmLicenseData *=');
              if M.Success then
              begin
                I := M.Index + M.Length;
                while S[I] <> '(' do
                  inc(I);
                J := 0;
                Lvl := 1;
                repeat
                  inc(J);
                  if S[I + J] = '(' then
                    inc(Lvl)
                  else
                  if S[I + J] = ')' then
                    Dec(Lvl);
                until Lvl = 0;
                F1 := StringReplace(Copy(S, I + 1, J - 2), #13#10, '', [rfReplaceAll]);
                //F1 := StringReplace(F1, ' ', '', [rfReplaceAll]);
                MC := TRegEx.Matches(F1, '\(.*?\)');
                for M in MC do
                begin
                  F1Arr := M.Value.Split([';']);
                  for I := 0 to length(F1Arr) - 1 do
                    F1Arr[I] := Trim(F1Arr[I]);
                  F1Rec := TF1Rec.Create;
                  F1Rec.TaxYear := P.Caption;
                  for I := 0 to length(F1Arr) - 1 do
                  begin
                    FVal := unqote(F1Arr[I], '(', ')').Split([':']);
                    if Length(FVal) <2 then
                      continue;
                    if SameText(FVal[0].Trim, 'name') then//20171031 Igor
                      F1Rec.Name := unqote(FVal[1].Trim)//20171031 Igor
                    else
                    if SameText(FVal[0].Trim, 'Id') then//20171031 Igor
                      F1Rec.Id := unqote(FVal[1].Trim)//20171031 Igor
                    else
                    if SameText(FVal[0].Trim, 'Factor') then//20171031 Igor
                      F1Rec.Factor := StrToIntDef(unqote(FVal[1].Trim), 0)//20171031 Igor
                    else
                    if SameText(FVal[0].Trim, 'Level') then//20171031 Igor
                      F1Rec.Level := unqote(FVal[1].Trim)//20171031 Igor
                  end;
                  if not F1Rec.Id.IsEmpty and SameText(F1Rec.Id[1], 'S') then
                    F1Rec.Factor2 := StrToIntDef(FindEditByTag<TEdit>(P, c_F2_SEditTag).Text, 0)
                  else
                    F1Rec.Factor2 := StrToIntDef(FindEditByTag<TEdit>(P, c_F2EditTag).Text, 0);

                  LB.Items.AddObject(F1Rec.Name, F1Rec);
                  FF1RecList.Add(F1Rec);
                end;
              end;
              LB.OnClick := LBClick;
              if LB.Count > 0 then
              begin
                LB.ItemIndex := 0;
                LBClick(LB);
              end;
            end;
          end;
        end;
      end;
    end;
    //20190307 Igor <<<
    //20180113 Igor <<<
  end;
end;

procedure TfrmAuthorize.btnSaveSingleKeyToFileClick(Sender: TObject);
Var
  SL: TStringList;
begin
  If (edtSingleKey.Text = '') or (GetF1RecByKey(edtSingleKey.Text) = nil) then
  begin
    MessageDlg('Key cannot be saved!', mtWarning, [mbOk], 0);
    exit;
  end;
  SL := TStringList.Create;
  try
    SL := TStringList.Create;
    SL.Add(edtSingleKey.Text);
    SL.SaveToFile(edtSaveSingleKeyLocation.Text);
    MessageDlg('Key saved!', mtInformation, [mbOk], 0);
  finally
    SL.Free;
  end;
end;

procedure TfrmAuthorize.btnValidateSingleKeyClick(Sender: TObject);
var
  S: String;
begin
  if edtSingleKey.Text = '' then
  begin
    mmoValidateSingleKey.Color := clWindow;
    mmoValidateSingleKey.Text := '';
    exit;
  end;
  if ValidateKey(edtSingleKey.Text, S) then
    mmoValidateSingleKey.Color := $00CAFFCA
  else
    mmoValidateSingleKey.Color := clRed;
  mmoValidateSingleKey.Text := S;
end;

function TfrmAuthorize.GetCloudOptions: Integer; //20190305 Igor
  procedure CheckTag(ATag: Integer);
  begin
    if FindEditByTag<TCheckBox>(CurrPage, ATag).Checked then
      Result := Result or (1 shl (ATag - 1));
  end;
begin
  Result := 0;
  CheckTag(c_T1CloudTag);
  CheckTag(c_T2CloudTag);
  CheckTag(c_T3CloudTag);
  CheckTag(c_T4CloudTag);
  CheckTag(c_TFCloudTag);
  CheckTag(c_FPCloudTag);
end;

function TfrmAuthorize.CurrPage: TTabSheet;
var
  pgc: TPageControl;
  I: Integer;
begin
  if pgcYears.ActivePage = nil then
    exit(nil);
  pgc := nil;
  for I := 0 to pgcYears.ActivePage.ControlCount - 1 do
  begin
    if pgcYears.ActivePage.Controls[I] is TPageControl then
    begin
      pgc := pgcYears.ActivePage.Controls[I] as TPageControl;
      break
    end;
  end;
  if pgc = nil then
    exit(nil);
  Result := pgc.ActivePage;
end;

procedure TfrmAuthorize.btnGenerateProductsPHPClick(Sender: TObject);
var
  S: string;
  I: Integer;
  P: TTabSheet;
  LB: TListBox;
begin
{$REGION 'example'}
(*
T12017=>array(
  id=>"1",
  name=>"T1-2017",
  L1=>array(
    id    => "1",
    name  => "without Efile",
    print_name => "T1-2016 without Efile",
    price => "99",
    price2 => "99",
    boundle => "false"
    ),
  L2=>array(
    id    => "2",
    name  => "with Efile",
    print_name => "T1-2016 with Efile",
    price => "169",
    price2 => "169",
    boundle => "false"
    ),
  L3=>array(
    id    => "3",
    name  => "T1 Standard",
    print_name => "T1-2016 Standard",
    price => "249",
    price2 => "249",
    boundle => "false"
    ),
  L4=>array(
    id    => "4",
    name  => "T1 Power + TR",
    print_name => "T1-2016 Power + TR",
    price => "379",
    price2 => "379",
    boundle => "true"
    ),
  L5=>array(
    id    => "5",
    name  => "T1 Multi-office + TR",
    print_name => "T1-2016 Multi-office + TR",
    price => "499",
    price2 => "499",
    boundle => "true"
    ),
  CD=>array(
    id    => "6",
    name  => "",
    print_name => "CD with T1-2016 installation files",
    price => "20",
    price2 => "20",
    boundle => "false"
    ),
  SCAN=>array(
    id    => "7",
    name  => "For T1-2016:",
    print_name => "Scan and manage client documents electronically for T1",
    price => "89",
    price2 => "89",
    boundle => "false"
    )
  )
*)
{$ENDREGION}
  P := CurrPage;
  if not Assigned(P) then
    Exit;
  LB := nil;
  for I := 0 to P.ControlCount - 1 do
  begin
    if P.Controls[I] is TListBox then
    begin
      LB := P.Controls[I] as TListBox;
      Break;
    end;
  end;
  if not Assigned(LB) then
    Exit;

  S :=
    TRegEx.Replace(P.Caption, '\W', '') + '=>array(' + #13#10 +
    '  id=>"1",' + #13#10 +
    '  name=>"'+P.Caption+'",' + #13#10;
  for I := 0 to LB.Count - 1 do
  begin
    S := S +
      '    L' + I.ToString + '=>array(' + #13#10 +
      '      id         => "' + I.ToString + '",' + #13#10 +
      '      name       => "' + LB.Items[I] + '",' + #13#10 +
      '      print_name => "' + LB.Items[I] + '",' + #13#10 +
      '      price      => "1",' + #13#10 +
      '      price2     => "1",' + #13#10 +
      '      boundle    => "false"' + #13#10 +
      '    ),'+ #13#10;
  end;
  Vcl.Clipbrd.Clipboard.AsText := S;
  MessageDlg(S, mtInformation, [mbOk], 0);
end;
//20171031 Igor>>>
procedure TfrmAuthorize.FillKeyList(AList: TListView; AAppID: string);
var
  Item: TListItem;
  i: Integer;
begin
  aList.Columns.Clear;
  aList.Items.Clear;
  aList.Columns.Add.Caption := 'Name';
  aList.Columns[0].Width := -1;
  aList.Columns.Add.Caption := 'Desc';
  aList.Columns[1].Width := -1;
  for I := 0 to Length(KeyList) - 1 do
  begin
    if KeyList[i].AppID = AAppID then
    begin
      Item := aList.Items.Add;
      Item.Data := Pointer(KeyList[i].ID);
      Item.Caption := KeyList[i].ShortName;
      Item.SubItems.Add(ArrToString(KeyList[i].FormList));
    end;
  end;
end;
//20171031 Igor<<<
function TfrmAuthorize.FindEditByTag<T>(AControl: TWinControl;
  ATag: Integer): T;
var
  I: Integer;
begin
  Assert(Assigned(AControl));
  for I := 0 to AControl.ControlCount - 1 do
    if (AControl.Controls[I] is T) and (AControl.Controls[I].Tag = ATag) then
      Exit((AControl.Controls[I] as T));
  raise Exception.Create(Format('Edit by Tag %d not found', [ATag]));
end;

function TfrmAuthorize.FindF1RecByAppID(AAppID: String): TArray<TF1Rec>;
var
  F: TF1Rec;
begin
  SetLength(Result, 0);
  for F in FF1RecList do
    if SameText(F.Id, AAppID) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := F;
    end;
end;

procedure TfrmAuthorize.FormCreate(Sender: TObject);
var
  ini: TIniFile;
  S: String;
  I, J, Z: Integer;
begin
  FF1RecList := TObjectList<TF1Rec>.Create(True);
  ini := TIniFIle.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    edtRootSourceFolder.Text := ini.ReadString('PARAMS', 'RootSourceFolder', ExtractFileDir(Application.ExeName));
    edtSaveSingleKeyLocation.Text := ini.ReadString('PARAMS', 'SaveSingleKeyLocation', ExtractFilePath(Application.ExeName) + 'LVerf.EX_');
    btnRefreshClick(btnRefresh);

    S := ini.ReadString('INTERFACE', 'pgcYearsActivePage', '');
    if S <> '' then
    begin
      for I := 0 to pgcYears.PageCount - 1 do
        if SameText(pgcYears.Pages[I].Caption, S) then
        begin
          pgcYears.ActivePageIndex := I;
          S := ini.ReadString('INTERFACE', 'pgcAppsActivePage', '');
          if S <> '' then
          begin
            for J := 0 to pgcYears.Pages[I].ControlCount - 1 do
            begin
              if pgcYears.Pages[I].Controls[J] is TPageControl then
              begin
                for Z := 0 to TPageControl(pgcYears.Pages[I].Controls[J]).PageCount - 1 do
                begin
                  if SameText(TPageControl(pgcYears.Pages[I].Controls[J]).Pages[Z].Caption, S) then
                  begin
                    TPageControl(pgcYears.Pages[I].Controls[J]).ActivePageIndex := Z;
                    break;
                  end;
                end;
                break;
              end;
            end;
          end;
          break;
        end;
    end;
    if pgcYears.ActivePage <> nil then
    begin
      ini.WriteString('INTERFACE', 'pgcYearsActivePage', pgcYears.ActivePage.Caption);
      for I := 0 to pgcYears.ActivePage.ControlCount - 1 do
      begin
        if pgcYears.ActivePage.Controls[I] is TPageControl then
        begin
          if TPageControl(pgcYears.ActivePage.Controls[I]).ActivePage <> nil then
            ini.WriteString('INTERFACE', 'pgcAppsActivePage', TPageControl(pgcYears.ActivePage.Controls[I]).ActivePage.Caption);
          break
        end;
      end;
    end;

  finally
    ini.Free;
  end;
end;

procedure TfrmAuthorize.FormDestroy(Sender: TObject);
var
  ini: TIniFile;
  I: Integer;
begin
  FreeAndNil(FF1RecList);
  ini := TIniFIle.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    ini.WriteString('PARAMS', 'RootSourceFolder', edtRootSourceFolder.Text);
    ini.WriteString('PARAMS', 'SaveSingleKeyLocation', edtSaveSingleKeyLocation.Text);
    if pgcYears.ActivePage <> nil then
    begin
      ini.WriteString('INTERFACE', 'pgcYearsActivePage', pgcYears.ActivePage.Caption);
      for I := 0 to pgcYears.ActivePage.ControlCount - 1 do
      begin
        if pgcYears.ActivePage.Controls[I] is TPageControl then
        begin
          if TPageControl(pgcYears.ActivePage.Controls[I]).ActivePage <> nil then
            ini.WriteString('INTERFACE', 'pgcAppsActivePage', TPageControl(pgcYears.ActivePage.Controls[I]).ActivePage.Caption);
          break
        end;
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TfrmAuthorize.LBClick(Sender: TObject);
var
  LB: TListBox;
  R: TF1Rec;
  isLimitedForm: boolean;//20171031 Igor
  TS: TTabSheet;//20171031 Igor
begin
  TS := CurrPage;//20171031 Igor
  LB := (Sender as TListBox);
  if LB.ItemIndex = -1 then
  begin
    FindEditByTag<TEdit>(LB.Parent, c_NameEditTag).Text := '';
    FindEditByTag<TEdit>(LB.Parent, c_IDEditTag).Text := '';
    FindEditByTag<TEdit>(LB.Parent, c_F1EditTag).Text := '';
    FindEditByTag<TEdit>(LB.Parent, c_LevelEditTag).Text := '';
    FindEditByTag<TLabel>(LB.Parent, c_DateExpEditTag).Visible := False;
    FindEditByTag<TDateTimePicker>(LB.Parent, c_DateExpEditTag).Visible := False;
    FindEditByTag<TLabel>(LB.Parent, c_DateExpEditTagNote).Visible := False;
    FindEditByTag<TListView>(LB.Parent, c_LimitedFormsList).Visible := False;//20171031 Igor
  end
  else
  begin
    R := TF1Rec(LB.Items.Objects[LB.ItemIndex]);
    isLimitedForm := SameText(R.Level, c_LimitedFormsName);//20171031 Igor
    FindEditByTag<TEdit>(LB.Parent, c_NameEditTag).Text := R.Name;
    FindEditByTag<TEdit>(LB.Parent, c_IDEditTag).Text := R.ID;
    FindEditByTag<TEdit>(LB.Parent, c_F1EditTag).Text := R.Factor.ToString;
    FindEditByTag<TEdit>(LB.Parent, c_LevelEditTag).Text := R.Level;
    //20171031 Igor>>>
    FindEditByTag<TLabel>(LB.Parent, c_DateExpEditTag).Visible := SameText(R.Level, c_DemoLevelName) and (not isLimitedForm);
    FindEditByTag<TDateTimePicker>(LB.Parent, c_DateExpEditTag).Visible := SameText(R.Level, c_DemoLevelName) and (not isLimitedForm);
    FindEditByTag<TLabel>(LB.Parent, c_DateExpEditTagNote).Visible := SameText(R.Level, c_DemoLevelName) and (not isLimitedForm);
    FindEditByTag<TListView>(LB.Parent, c_LimitedFormsList).Visible := isLimitedForm;
    FillKeyList(FindEditByTag<TListView>(LB.Parent, c_LimitedFormsList), TS.Caption);
    //20171031 Igor<<<
  end
end;

function TfrmAuthorize.MakeKey(const AName, AID, ALevel: String; AF1,
  AF2: Integer; ACurrTabSheet: TTabSheet; const AKeyItems: TList<integer>): String;//20171031 Igor //20190305 Igor
var
  D: TdateTime;
begin
  //20171031 Igor>>>
  if SameText(ALevel, c_LimitedFormsName) then
  begin
    Result := DoMakeNewItemKey(AID, AKeyItems, AF1, AF2);
  end
  else
  //20171031 Igor<<<
  if SameText(ALevel, c_DemoLevelName) then
  begin
    D := FindEditByTag<TDateTimePicker>(ACurrTabSheet, c_DateExpEditTag).Date;

    if ACurrTabSheet.Tag = c_Helper then
      Result := DoMakeHelperDemoKey(AID, D, AF1, AF2, GetCloudOptions)
    else
      Result := DoMakeDemoKey(AID, D, AF1, AF2);
  end
  else if ACurrTabSheet.Tag = c_Helper then
    Result := DoMakeHelperKey(AID, AF1, AF2, GetCloudOptions)
  else
{ //for the future
  if SameText(ALevel, c_LimitFormsLevelName) then
    Result := DoMakeLimitFormsKey(AID, AF1, AF2)
  else
  if SameText(ALevel, c_LimitReturnsLevelName) then
    Result := DoMakeLimitReturnsKey(AID, AF1, AF2)
  else}
    Result := DoMakeNormalKey(AID, AF1, AF2)
end;

end.
