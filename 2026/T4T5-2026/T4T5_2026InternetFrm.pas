unit T4T5_2026internetfrm;
//20170217 Igor

interface

uses SysUtils, Forms, Dialogs, StdCtrls, Buttons, Printers, ExtCtrls, Controls,
  Classes, ShellApi, ActiveX, WinTypes, vtMulti;


type
  TInternetFrmT4T5_2026 = class(TForm)
    PrintDialog1: TPrintDialog;
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    PrepBtn: TBitBtn;
    ConnectBtn: TBitBtn;
    Panel2: TPanel;
    Label6: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Panel6: TPanel;
    Panel5: TPanel;
    DataTypeBtn: TRadioGroup;
    Label2: TLabel;
    SubmissionSeqBox: TEdit;
    SubmissionPrefixBox: TEdit;
    Label11: TLabel;
    FlNm: TEdit;
    UrlBox: TEdit;
    ShowXmittalBtn: TBitBtn;
    PrintXmittalBtn: TBitBtn;
    Label1: TLabel;
    SaveDialog1: TSaveDialog;
    Panel7: TPanel;
    ShowXmlBtn: TBitBtn;
    TypeOfReturnBtn: TRadioGroup;
    Label8: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    cbUseXMLValidator: TCheckBox;

    procedure MkFileLocation;
    procedure CancelBtnClick(Sender: TObject);
    procedure PrepBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    Function  MkReferenceNo:String;
    procedure TypeOfReturnBtnClick(Sender: TObject);
    procedure ShowXmlBtnClick(Sender: TObject);
  private
    FRetNo: integer;
    FInstForms: TFRecArray;
    function GetEFillDir: String;
    procedure PrepareSlips;
    function CheckPrepare: Boolean;
    property EFillDir: String read GetEFillDir;
  public
    property RetNo: integer read FRetNo;
  end;

var
  InternetFrm: TInternetFrmT4T5_2026;
  F1 : TextFile;
  SelectedList : TStringList;

  //EmplRec:TEmplRec;

  SubmitRef:String;

implementation

{$R *.DFM}

uses
  vtCommon,
  T4T5_2026TrimStr,
  T4T5_2026PrepareXml,
  T4T5_2026Declare,  //20200210
  uT4T5XMLValidator, //20260121 Igor
  vtTrimStr;

procedure TInternetFrmT4T5_2026.FormCreate(Sender: TObject);
begin
  FRetNo := GetCurrentRetNo;
  If UrlBox.text = '' then
    UrlBox.text :='https://apps.cra-arc.gc.ca/ebci/njfs/ext/disclaimer';  //20250121
    //'https://apps.cra-arc.gc.ca/ebci/leb0/upload/pub/entry-e.do';

  TypeOfReturnBtn.ItemIndex := 0;
  If Not ForceDirectories(EFillDir) then
  begin
    MessageDlg('Can''t create directory "' + EFillDir + '"', mtError, [mbOk], 0);
    close;
    exit;
  end;
  MkFileLocation;
end;

function TInternetFrmT4T5_2026.GetEFillDir: String;
begin
 //Result := IncludeTrailingPathDelimiter(XmlDir) + 'Efile'; //20200210  NO good
 Result := IncludeTrailingPathDelimiter(AppDir) + 'Efile';
end;

procedure TInternetFrmT4T5_2026.MkFileLocation;
Begin
  FlNm.Text := IncludeTrailingPathDelimiter(GetEFillDir) +
    GetCorrectFileName(TypeOfReturnBtn.Items[TypeOfReturnBtn.ItemIndex] + ' ' +
        FetchElm(RetNo, 'EMPL' , EMPL_EMPL_NAME) + '.XML');   //20180114
                      // FetchElm(RetNo, 'EMPL' , EMPL_EMPLNO) + '.XML');
end;

procedure TInternetFrmT4T5_2026.CancelBtnClick(Sender: TObject);
begin
  SelectedList.Free;
  Close;
end;


procedure TInternetFrmT4T5_2026.PrepareSlips;
var
  s, CurrentSlip: String;
begin
  CurrentSlip := TypeOfReturnBtn.Items[TypeOfReturnBtn.ItemIndex];
  FInstForms := FList.GetAllInstForms(CurrentSlip);
  If Length(FInstForms) = 0 then
  begin
    ShowMessage('Employer ' + FetchElm(RetNo, 'EMPL' , EMPL_EMPL_NAME) +
      ' does not have ' + CurrentSlip + ' slips');
    Exit;
  end;
  s := ValidateSlips(FRetNo, CurrentSlip);
  If s > '' then
  begin
    ShowMessage('Slips ' + s + ' does not have any $ amounts');
    Exit;
  end;
  MkFileLocation;
  SubmissionPrefixBox.Text := MkReferenceNo;
end;

function TInternetFrmT4T5_2026.CheckPrepare: Boolean;
var
  msg: String;
Begin
  msg := '';
  Result := True;
  If FlNm.Text='' then
    msg := msg + #13 + 'Please select a File Location';

  If not IsPhoneFormat(FetchElm(RetNo, 'EMPL' , EMPL_TELEPHONE)) then
    msg := msg + #13 + 'Please exit and enter Phone Number in 999-9999 format in the employer record.';
  If DataTypeBtn.ItemIndex <0 then
    msg := msg + #13 + 'Please select Data Type';
  If TypeOfReturnBtn.ItemIndex < 0 then
    msg := msg + #13 + 'Please select Type of Return';
  MkFileLocation;
  If FileExists(FlNm.Text) and
     (MessageDlg('File exists. Override?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
    Result := False;
  Result := Result AND (msg = '');
  if msg <> '' then
    MessageDlg(msg, mtWarning, [mbOk], 0);
End;

procedure TInternetFrmT4T5_2026.PrepBtnClick(Sender: TObject);
var
  DataTypeCode: String;
  //20260121 Igor >>>
  lXMLValidationErrorList: TStringList;
  ifor: Integer;
  lErrorsString: string;
  lXSDFilesList: TStringList;
  //20260121 Igor <<<
begin

  if Not CheckPrepare then exit;
  Case DataTypeBtn.itemindex of
    0: DataTypeCode := 'O'; {original}
    1: DataTypeCode := 'A'; {Amended}
    2: DataTypeCode := 'C'; {Cancelled}  //20190322
  else
    DataTypeCode := '';
  end;
  SubmissionPrefixBox.Text:=MkReferenceNo; //20180106

  AssignFile(F1, FlNm.text);
  ReWrite(F1);
  try
    SubmitRef := SubmissionPrefixBox.Text + SubmissionSeqBox.Text;
    PrepareXmitterinfo(FRetNo, F1, DataTypeCode, SubmitRef);
    //20180106
    Case TypeOfReturnBtn.ItemIndex of
      0:
      Begin
       if (IsReadyForEfile(FRetNo,'T4')=False) or (IsAlreadyEfiled(FRetNo,'T4')=True) then
        begin ShowMessage('T4 slips are not "Ready for Efile" or already Efiled. Change Filing status on the EMPL form');Exit;end;

       PrepareT4Xml(FRetNo, F1, DataTypeCode);
      end;
      1:
      Begin
       if (IsReadyForEfile(FRetNo,'T4A')=False) or (IsAlreadyEfiled(FRetNo,'T4A')=True) then
         begin ShowMessage('T4A slips are not "Ready for Efile" or already Efiled. Change Filing status on the EMPL form');Exit;end;
       PrepareT4AXML(FRetNo, F1, DataTypeCode);
      end;
      2:
      Begin
       if (IsReadyForEfile(FRetNo,'T5')=False) or (IsAlreadyEfiled(FRetNo,'T5')=True) then
         begin ShowMessage('T5 slips are not "Ready for Efile" or already Efiled. Change Filing status on the EMPL form');Exit;end;
       PrepareT5XML(FRetNo, F1, DataTypeCode);
      end;
    end;
  finally
    CloseFile(F1);
  end;

  // 20260121 Igor >>>
  if cbUseXMLValidator.Checked then
  begin
    lXMLValidationErrorList:= TStringList.Create;
    lXSDFilesList:= TStringList.Create;
    try
      case TypeOfReturnBtn.ItemIndex of
        0:
        begin
          lXSDFilesList.Add(',T619_T4.xsd');
          lXSDFilesList.Add(',T4.xsd');
        end;
        1:
        begin
          lXSDFilesList.Add(',T619_T4A.xsd');
          lXSDFilesList.Add(',T4A.xsd');
        end;
        2:
        begin
          lXSDFilesList.Add(',T619_T5.xsd');
          lXSDFilesList.Add(',T5.xsd');
        end;
      end;

      TT4T5XMLValidator.XMLValidate(ExtractFilePath(ParamStr(0)) + T4T5_2026Declare.AppName + '-' + T4T5_2026Declare.AppYear, lXSDFilesList, FlNm.text, lXMLValidationErrorList);

      if (lXMLValidationErrorList.Count > 0) and not lXMLValidationErrorList[0].StartsWith('XSD file not found:') then
      begin
       TT4T5XMLValidator.ShowErrorsInHTML(lXMLValidationErrorList);
       Exit;
      end;
    finally
      lXMLValidationErrorList.Free;
      lXSDFilesList.Free;
    end;
  end;
  // 20260121 Igor <<<

  MessageDlg('XML file has been completed and saved as ' + FlNm.Text, mtInformation, [mbOk], 0);
end;

procedure TInternetFrmT4T5_2026.ConnectBtnClick(Sender: TObject);
var
  h: THandle;
begin
  if not FileExists(FlNm.Text) then
  begin
    ShowMessage('Please select a valid File Location');
    Exit;
  end;

  h := ShellExecute(0, 'open', PChar(UrlBox.Text), Nil, Nil, Sw_Show);
  if H <= 32 then begin ShowMessage('Connection failed');Exit;end;
  AddLogAppMon(amtOnEfile, FRetNo); // 20180722 Igor //20220519 Igor
end;

Function TInternetFrmT4T5_2026.MkReferenceNo:String;
Var
  YYYY, MM, DD, Hour, Min, Sec, Msec: word;
  SMM, SDD, SSec: string;
  SYYYY: string;
Begin
  DecodeDate(Now, YYYY, MM, DD);
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SYYYY := LTrim(RTrim(IntToStr(YYYY)));
  SMM := LTrim(RTrim(IntToStr(MM)));
  SDD := Ltrim(Rtrim(IntToStr(dd)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM) = 1 then
    SMM := '0' + SMM;
  If Length(SDD) = 1 then
    SDD := '0' + Sdd;
  If Length(SSec) = 1 then
    SSec := '0' + SSec;
  Result := RightStr(Syyyy, 2) + SMM + SDD + SSec;
end;

procedure TInternetFrmT4T5_2026.TypeOfReturnBtnClick(Sender: TObject);
begin
  MkFileLocation;
end;

procedure TInternetFrmT4T5_2026.ShowXmlBtnClick(Sender: TObject);
Var
  FlName: String;
  h: THandle;
begin
  If TypeofReturnBtn.ItemIndex < 0 then
  begin
    ShowMessage('Please select type of return');
    Exit;
  end;

  If FlNm.text = '' then
    exit;
  FlName := FlNm.text;
  h := ShellExecute(Internetfrm.Handle, 'Open', PChar(''+FlName), Nil, Nil, Sw_Show);
  If H <= 32 then
    ShowMessage('File not found (You must click Prepare XML first)');
end;

End.
