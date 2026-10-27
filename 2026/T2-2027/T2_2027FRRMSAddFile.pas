unit T2_2027FRRMSAddFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.IOUtils,
  Vcl.Grids, System.Generics.Collections;

const
  DocumentTypesShort : array[0..4] of string =
    ('FINANCIAL_STMT', 'ORG_CHART', 'TAXPAYER_LETTER', 'TRUST_AGREEMENT', 'OTHER');
  DocumentTypesFull : array[0..4] of string =
    ('FINANCIAL STATEMENT', 'ORG CHART', 'TAXPAYER LETTER', 'TRUST AGREEMENT', 'OTHER');

type
  TAddFile = function(ASequence, ADocumentType: integer; AFileName, AFormName: string): boolean of object; //20230109 Igor

type
  TFRRMSAddFileT2_2027 = class(TForm)
    pnlTop: TPanel;
    Label1: TLabel;
    edNumber: TEdit;
    Label2: TLabel;
    edFormType: TEdit;
    Label3: TLabel;
    edEFileNumber: TEdit;
    Label4: TLabel;
    edStartDate: TEdit;
    Label5: TLabel;
    edEndDate: TEdit;
    pnlBottom: TPanel;
    btnAttach: TBitBtn;
    btnCancel: TBitBtn;
    Label8: TLabel;
    lbRemaining: TLabel;
    Label7: TLabel;
    edSequence: TEdit;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edFileName: TEdit;
    Label12: TLabel;
    cbDocumentType: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    btnOpenFile: TSpeedButton;
    dlgFileOpen: TFileOpenDialog;
    cbForms: TComboBox;
    Label16: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnAttachClick(Sender: TObject);

    function isNotValidFileExtension(aExt:string):boolean;

    procedure cbFormsChange(Sender: TObject); //20230109 Igor
  private
    { Private declarations }
    FormType: string;
    FRetNo: integer;
    FRemainingSize: int64;
    FAddFile: TAddFile;
    FSlipNos: TArray<Integer>; //20230109 Igor
    procedure FillDocType;
    //20230109 Igor >>>
    procedure FillForms;
    function GetSequence: Integer;
    procedure SetSequence(const Value: Integer);
    //20230109 Igor <<<
  public
    { Public declarations }
    property Sequence: Integer read GetSequence write SetSequence; //20230109 Igor
  end;

  function RunFRRMSAddFile(AFormType: string; ARetNo: integer; ARemainingSize: int64; AAddFile: TAddFile; ASequence: integer): boolean;

implementation

uses T2_2027TrimStr, vtCommon, vtTrimStr, T2_2027Declare, T2_2027; //20230109 Igor

{$R *.DFM}

function RunFRRMSAddFile(AFormType: string; ARetNo: integer; ARemainingSize: int64; AAddFile: TAddFile; ASequence: integer): boolean;
var FFRRMSAddFileT2_2027: TFRRMSAddFileT2_2027;
begin
  FFRRMSAddFileT2_2027 := TFRRMSAddFileT2_2027.Create(Screen.ActiveForm);
  try
    FFRRMSAddFileT2_2027.FormType := AFormType;
    FFRRMSAddFileT2_2027.FRetNo := ARetNo;
    FFRRMSAddFileT2_2027.FRemainingSize := ARemainingSize;
    FFRRMSAddFileT2_2027.FAddFile := AAddFile;
    FFRRMSAddFileT2_2027.Sequence := ASequence; //20230109 Igor
    Result := FFRRMSAddFileT2_2027.ShowModal = mrOk;
  finally
    FFRRMSAddFileT2_2027.Free;
  end;
end;

procedure TFRRMSAddFileT2_2027.btnAttachClick(Sender: TObject);
var nSequence: integer; afileExtention:string;
begin
  nSequence := StrToIntDef(edSequence.Text, -1);
  if nSequence < 0 then
  begin
    ShowMessage('Enter valid sequence number');
    Exit;
  end;
  if cbDocumentType.ItemIndex = -1 then
  begin
    ShowMessage('You need to choose Document Type');
    Exit;
  end;
  //20230109 Igor >>>
  if (nSequence = 0) and (cbDocumentType.ItemIndex = 0) then
  begin
    ShowMessage('Foreign Affiliates financial statements cannot be attached to the Summary');
    Exit;
  end;
  //20230109 Igor <<<
  if String(edFileName.Text).IsEmpty then
  begin
    ShowMessage('You need to select File');
    Exit;
  end;

  afileExtention:= (ExtractFileExt(string(edFileName.Text)));
  if isNotValidFileExtension(afileExtention) then
  begin
    ShowMessage(afileExtention + ' is not an allowable file type');
    Exit;
  end;

  if Assigned(FAddFile) then
    if FAddFile(nSequence, cbDocumentType.ItemIndex, edFileName.Text, cbForms.Text) then //20230109 Igor
      ModalResult := mrOk;
end;

function TFRRMSAddFileT2_2027.isNotValidFileExtension(aExt:string):boolean;
    const
      invalidExt : array[1..50] of string =
      (
        '.exe', '.ade', '.adp', '.app', '.asx', '.bas', '.bat', '.chm', '.class','.cmd',
        '.com', '.cpl', '.crt', '.dll', '.fxp', '.hlp', '.hta', '.inf', '.ins',  '.isp',
        '.js' , '.jse', '.Ink', '.mda', '.mde', '.mdt', '.mdw', '.mdz', '.msc',  '.msi',
        '.msp', '.mst', '.ops', '.pcd', '.pif', '.prg', '.reg', '.scf', '.scr',  '.sct',
        '.shb', '.shs', '.url', '.vb',  '.vbe', '.vbs', '.wsc', '.wsf', '.ws' ,  '.xxx'
      ) ;

    function StrInArray(const Value : String;const ArrayOfString : Array of String) : Boolean;
    var
     Loop : String;
    begin
      for Loop in ArrayOfString do
      begin
        if Value = Loop then
        begin
           Exit(true);
        end;
      end;
      result := false;
    end;

begin
  result := false;
  if  StrInArray(aExt,invalidExt) then
    result := true;
end;


procedure TFRRMSAddFileT2_2027.btnOpenFileClick(Sender: TObject);
begin
  if not dlgFileOpen.Execute then Exit;
  edFileName.Text := dlgFileOpen.FileName;
end;

procedure TFRRMSAddFileT2_2027.cbFormsChange(Sender: TObject); //20230109 Igor
begin
  Sequence := FSlipNos[cbForms.ItemIndex];
end;

procedure TFRRMSAddFileT2_2027.FillDocType;
var I: integer;
begin
  cbDocumentType.Items.Clear;
  for I := 0 to Length(DocumentTypesFull) - 1 do
    cbDocumentType.Items.Add(DocumentTypesFull[I]);
end;

procedure TFRRMSAddFileT2_2027.FillForms; //20230109 Igor
var I, FNo: integer;
    SlipFormName, FNonInst, DisplayCaption: string;

    procedure AddSlipNo(ASlipNo: Integer);
    begin
      SetLength(FSlipNos, Length(FSlipNos) + 1);
      FSlipNos[Length(FSlipNos) - 1] := ASlipNo;
    end;
begin
  cbForms.Items.Clear;
  cbForms.Items.Add('Summary');
  SetLength(FSlipNos, 0);
  AddSlipNo(0);
  if SameText(FormType, 'T106') then
    SlipFormName := 'T106SL'
  else if SameText(FormType, 'T1134') then
    SlipFormName := 'T1134S'
  else
    SlipFormName := '';

  if not SlipFormName.IsEmpty then
    for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if SameText(SlipFormName, Frec.FormName) then
      begin
        FNo := Frec.FormNo;
        if Ret[FRetNo].FrmHasData[FNo] then
        begin
          DisplayCaption := FRec.FormInstName;
          if SameText(FormType, 'T106') then
            DisplayCaption := DisplayCaption + ' ' + FetchElm(FRetNo, FNo, 13);
          cbForms.Items.Add(DisplayCaption);
          AddSlipNo(FRec.InstNo);
          if FRec.InstNo = Sequence then
            cbForms.ItemIndex := cbForms.Items.Count - 1;
        end;
      end;
    end;

  if cbForms.ItemIndex < 0 then
  begin
    cbForms.ItemIndex := 0;
    cbFormsChange(cbForms);
  end;
end;

procedure TFRRMSAddFileT2_2027.FormShow(Sender: TObject);
begin
  edNumber.Text := FetchElm(FRetNo, 'T2', 1);
  edFormType.Text := FormType;
  if SameText(FormType, 'T106') then
    edEFileNumber.Text := FetchElm(FRetNo, 'T106', 64)
  else if SameText(FormType, 'T1134') then
    edEFileNumber.Text := FetchElm(FRetNo, 'T1134', 26)
  else if SameText(FormType, 'T1135') then
    edEFileNumber.Text := FetchElm(FRetNo, 'T1135', 39);
  edStartDate.Text := FetchElm(FRetNo, 'T2', 10);
  edEndDate.Text := FetchElm(FRetNo, 'T2', 11);
  lbRemaining.Caption := Format('%.2f', [FRemainingSize / 1024 / 1024])+' Mb';
  FillDocType;
  FillForms; //20230109 Igor
end;

function TFRRMSAddFileT2_2027.GetSequence: Integer; //20230109 Igor
begin
  Result := StrToIntDef(edSequence.Text, -1);
end;

procedure TFRRMSAddFileT2_2027.SetSequence(const Value: Integer); //20230109 Igor
begin
  edSequence.Text := IntToStr(Value);
end;

end.
