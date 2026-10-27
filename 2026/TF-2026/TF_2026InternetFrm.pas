unit TF_2026internetfrm;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,DBGrids,DB,Printers,ExtCtrls,FileCtrl,
  ShellApi,ActiveX, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;


type
  TInternetFrmTF_2026 = class(TForm)
    PrintDialog1: TPrintDialog;
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    PrepBtn: TBitBtn;
    ConnectBtn: TBitBtn;
    Panel2: TPanel;
    Label6: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    Panel4: TPanel;
    Label3: TLabel;
    Panel6: TPanel;
    Panel5: TPanel;
    DataTypeBtn: TRadioGroup;
    ListBox1: TListBox;
    AddBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    Label2: TLabel;
    SubmissionSeqBox: TEdit;
    SubmissionPrefixBox: TEdit;
    Label11: TLabel;
    FlNm: TEdit;
    UrlBox: TEdit;
    ShowXmittalBtn: TBitBtn;
    PrintXmittalBtn: TBitBtn;
    FilingOptionBtn: TRadioGroup;
    Label1: TLabel;
    SaveDialog1: TSaveDialog;
    Panel7: TPanel;
    Label18: TLabel;
    DataSource1: TDataSource;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    ShowXmlBtn: TBitBtn;
    TypeOfReturnBtn: TRadioGroup;
    Label8: TLabel;
    FDConnection: TADConnection;
    Table1: TADQuery;
    BitBtn1: TBitBtn;
    cbUseXMLValidator: TCheckBox;

    function validateT619Info:boolean;
    function validateInternetFrmInfo:Boolean;
    procedure MkFileLocation;
    procedure CancelBtnClick(Sender: TObject);
    procedure PrepBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    Function ReplaceSpecialChar(info:string):String;
    Function  MkReferenceNo:String;
    procedure TypeOfReturnBtnClick(Sender: TObject);
    procedure ShowXmlBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
  InternetFrm: TInternetFrmTF_2026;
  F1 : TextFile;
  SelectedList : TStringList;

  //EmplRec:TEmplRec;

  SubmitRef:String;

implementation

{$R *.DFM}

uses
  vtCommon,
  TF_2026,TF_2026Calc,TF_2026TrimStr,TF_2026Declare,TF_2026dataGen,
  TF_2026Main,TF_2026ChildWinNew, vtMulti, // 20180722 Igor
//TF_2026poplist,
  vtTrimStr,vtShared
  //20250724 Igor >>>
  , TF_2026EFileToXML
  //20250724 Igor <<<
  , uTFXMLValidator //20260220 Igor
  ;

procedure TInternetFrmTF_2026.BitBtn1Click(Sender: TObject);
begin
 ShowMessage('Exit this form and Open a Special Election (SERS) form directly, such as T2054, T2057, etc)'); //20240616
 Exit;
end;

procedure TInternetFrmTF_2026.CancelBtnClick(Sender: TObject);
begin
SelectedList.Free;
Close;
end;

function TInternetFrmTF_2026.validateT619Info:boolean;
begin
 result:= true;
 If OptRec.Prp_Name = '' then
 begin
  ShowMessage('Complete Company Name information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end
 else If OptRec.Prp_ContactName = '' then
 begin
  ShowMessage('Complete Contact Name information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end

 Else if Length(OptRec.Prp_Tel) <>8 then  //20110524
 begin
   ShowMessage('see Configure->Preparer->Telephone must be entered in format 999-9999');
   Result:=False;
 end

 Else If AllTrim(OptRec.Prp_Fax) >'' then
 begin
   If Length(OptRec.Prp_Fax) <>8 then
   Begin
    ShowMessage('see Configure->Preparer->Fax must be entered in format 999-9999');
    Result:=False;
   end;
 end

 else If (length(OptRec.Prp_Area) <> 3) or (OptRec.Prp_Tel = '') then
 begin
  ShowMessage('Complete Area Code and Phone Number information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end

 else If OptRec.Prp_City = '' then
 begin
  ShowMessage('Complete City information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end

 else If OptRec.Prp_Postal = '' then
 begin
  ShowMessage('Complete Postal Code information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end
 else If length(OptRec.Prp_Countr) <> 3 then
 begin
  ShowMessage('Country Code must be 3 characters in accordance to ISO 3166-3'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end
 else If (Length(OptRec.Prp_TransmitterNo) <> 9) and (Length(OptRec.Prp_TransmitterNo) <> 15) and OptRec.Prp_RepId.IsEmpty then //jz//20250323 Length(OptRec.Prp_TransmitterNo) <> 6 then //20260727 Alex
 begin
  ShowMessage('Transmitter number must be 9 or 15 characters or Rep Id must be entered'+ //20260727 Alex
  Chr(13)+
  Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end

 else If Length(OptRec.Prp_Email) =0 then
 begin
  ShowMessage('Transmitter Email number is required'+
  Chr(13)+
  Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end;

end;

Function TInternetFrmTF_2026.validateInternetFrmInfo:boolean;
begin
 result:= true;

 If FlNm.Text='' then
 begin
    ShowMessage('Please select a File Location');
    result:= false;
 end;
 If DataTypeBtn.ItemIndex <0 then
 begin
    ShowMessage('Please select Data Type');
    result:= false;
 end;
end;

procedure TInternetFrmTF_2026.PrepBtnClick(Sender: TObject);
var
  FNo:Integer;
  DataTypeCode:string; //[1];
  XmlList:Tstringlist;
  //20260220 Igor >>>
  lXMLValidationErrorList: TStringList;
  ifor: Integer;
  lErrorsString: string;
  lXSDFilesList: TStringList;
  //20260220 Igor <<<
begin
 If TypeofReturnBtn.ItemIndex <0 then
 begin
  ShowMessage('Please select type of return');
  Exit;
 end;

 MkFileLocation;

 if not validateT619Info then
 begin
    Close;
    Exit;
 end;

 if not validateInternetFrmInfo then
 begin
    Exit;
 end;

 If FileExists(FlNm.Text) then  //20110524
 begin
  if MessageDlg('File exists. Override?',mtInformation, [mbYes, mbNo], 0) = mrNo then
  Begin
    Exit;
  End;
 end;

 SubmissionPrefixBox.Text:=MkReferenceNo;

 Case DataTypeBtn.itemindex of
  0: DataTypeCode := 'O'; {original}
  1: DataTypeCode := 'A'; {Amended}
 end;

 Screen.Cursor := crHourGlass;
 SubmitRef := SubmissionPrefixBox.Text+SubmissionSeqBox.Text;
 XmlList := Tstringlist.create();

 Case TypeOfReturnBtn.ItemIndex of
 0:begin //T5018
     if CountT5018Slips(RetNo) = 0 then
     begin
        ShowMessage('There are no T5018 Slips prepared to file.');
        Close;
        Exit;
     end;
     If (LeftStr(FetchElm(RetNo,'T5018S',21),1) <> '3') then
     begin
        ShowMessage('Please Exit and first set the status of the T5018 Summary to '+Chr(39)+'Ready for Efile'+Chr(39));
        OpenForm(RetNo,GetFormNo('T5018S'),21);
        Close;
        Exit; //needs both to work?
     end;
     createT5018XML(RetNo, DataTypeCode, SubmitRef, XmlList);
   end;
  //20180314 Igor >>>
  1:Begin //NR4
     If CountNR4Slips(RetNo) = 0 then
     begin
        ShowMessage('There are no NR4 Slips prepared to file.');
        Close;
        Exit;
     end;
     createNR4XML(RetNo, DataTypeCode, SubmitRef, XmlList);
   end;
  //20240305 Igor >>> 
  2:Begin //T5013
     If CountT5013Slips(RetNo) = 0 then
     begin
        ShowMessage('There are no T5013 Slips prepared to file.');
        Close;
        Exit;
     end;
     //20250731 Igor >>>
//     createT5013XML(RetNo, DataTypeCode, SubmitRef, XmlList); // Old schema
     TFormToEFileConverter.Execute('T5013FIN', RetNo, SubmitRef, XmlList);
     //20250731 Igor <<<
   end;
  //20240305 Igor <<<
  //20250519 Igor >>>
  3:Begin //T3010
     createT3010XML(RetNo, DataTypeCode, SubmitRef, XmlList);
   end;
  //20250519 Igor <<<
 end; //case

 XmlList.savetofile(FlNm.Text);

  // 20260220 Igor >>>
  if cbUseXMLValidator.Checked then
  begin
    lXMLValidationErrorList:= TStringList.Create;
    lXSDFilesList:= TStringList.Create;
    try
      case TypeOfReturnBtn.ItemIndex of
        0: //T5018
        begin
          lXSDFilesList.Add(',T619_T5018.xsd'); //20260224 Igor
          lXSDFilesList.Add(',t5018.xsd'); //20260224 Igor
        end;
        1: //NR4
        begin
          lXSDFilesList.Add(',T619_NR4.xsd');
          lXSDFilesList.Add(',nr4.xsd');
        end;
        2: //T5013FIN
        begin
          lXSDFilesList.Add(',T619_T5013main.xsd');
          lXSDFilesList.Add('http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols/1-0-1,t5013fin.xsd');
        end;
      end;

      TTFXMLValidator.XMLValidate(ExtractFilePath(ParamStr(0)) + TF_2026Declare.AppName + '-' + TF_2026Declare.AppYear, lXSDFilesList, FlNm.text, lXMLValidationErrorList);

      if (lXMLValidationErrorList.Count > 0) and not lXMLValidationErrorList[0].StartsWith('XSD file not found:') then
      begin
       TTFXMLValidator.ShowErrorsInHTML(lXMLValidationErrorList);
       Exit;
      end;
    finally
      lXMLValidationErrorList.Free;
      lXSDFilesList.Free;
    end;
  end;
  // 20260220 Igor <<<
 ShowMessage('XML file has been completed and saved as '+FlNm.Text);
 Screen.Cursor := crDefault;
end;

procedure TInternetFrmTF_2026.FormCreate(Sender: TObject);
begin
 FRetNo := GetCurrentRetNo;
 FilingOptionBtn.ItemIndex:=0;

 If UrlBox.text='' then
    UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/njfs/ext/disclaimer';   //jz//20250323
    //UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/leb0/upload/pub/entry-e.do';  //20130227
    //UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/leb0/upload/T05iDisclaimerRender-e';

 If Not DirectoryExists(AppDir+'\'+'Efile') then CreateDir(AppDir+'\'+'Efile');

end;


procedure TInternetFrmTF_2026.DBGrid1DblClick(Sender: TObject);
begin
AddBtnClick(Sender);
end;

procedure TInternetFrmTF_2026.AddBtnClick(Sender: TObject);
Var s:String;
begin
  ListBox1.Clear;
  s:=PaddR(Table1.FieldByName('EmplNo').AsString,3)
     +' '+Table1.FieldByName('Empl_Name').AsString;

  If (ListBox1.Items.Count <1) then
  begin
   If (IsInList(s,SelectedList) = -1) then   //20101231 instead of false
   begin
     ListBox1.Items.Add(s);
   end
   else
     ShowMessage('Already selected!. Press any key')

  end
  else
  begin
     ShowMessage('Maximum of 1 employers allowed at a time');
  end;
  MkFileLocation;
  SubmissionPrefixBox.Text:=MkReferenceNo;
end;

procedure TInternetFrmTF_2026.MkFileLocation;
Begin
 Case TypeOfReturnBtn.ItemIndex of
  0: FlNm.Text := AppDir+'\Efile\'+'T5018 '+FetchElm(RetNo,'T5018S',3);
  //20180314 Igor >>>
  1: FlNm.Text := AppDir+'\Efile\'+'NR4 '+FetchElm(RetNo,'NR4SUM',3);
  //1: FlNm.Text := AppDir+'\Efile\'+'T3 '+FetchElm(RetNo,'T3',1);
  //20180314 Igor <<<
  2: FlNm.Text := AppDir+'\Efile\'+'T5013 '+FetchElm(RetNo,'T5013SUM',3); //20240305 Igor
  3: FlNm.Text := AppDir + '\Efile\' + 'T3010 ' + FetchElm(RetNo, 'T3010', 3); //20250519 Igor
//  2: FlNm.Text := AppDir + '\Efile\' + 'T3010 ' + FetchElm(RetNo, 'T3010', 3); //20250519 Igor
//  3: FlNm.Text := AppDir+'\Efile\'+'T5013 '+FetchElm(RetNo,'T5013SUM',3); //20240305 Igor //20250519 Igor
 end;

 FlNm.text:=ReplaceStr(FlNm.Text,'.','');
 FlNm.text:=ReplaceStr(FlNm.Text,'/','');
 FlNm.text:=ReplaceStr(FlNm.Text,'&','');
 //20251229 Igor >>>
 case TypeOfReturnBtn.ItemIndex of
   3: FlNm.text:= FlNm.text + '.txt';
   else
     FlNm.text:= FlNm.text + '.XML';
 end;
 //20251229 Igor <<<
end;

procedure TInternetFrmTF_2026.RemoveBtnClick(Sender: TObject);
begin
 ListBox1.Clear;
end;

procedure TInternetFrmTF_2026.ListBox1DblClick(Sender: TObject);
begin
RemoveBtnClick(Sender);
end;

procedure TInternetFrmTF_2026.ConnectBtnClick(Sender: TObject);
Var h:THandle;
begin

 If TypeofReturnBtn.ItemIndex <0 then
 begin
  ShowMessage('Please select type of return');
  Exit;
 end;

 If Not FileExists(FlNm.Text) then
 begin
   ShowMessage('Please select a valid File Location');
   Exit;
 end;

 h := ShellExecute(Application.MainForm.Handle,'open',PChar(UrlBox.Text),Nil,Nil,Sw_Show);
 // 20180722 Igor >>>
 If H<=32 then ShowMessage('Connection failed')
 Else AddLogAppMon(amtOnEfile, FRetNo); //20220519 Igor
 // 20180722 Igor <<<
end;

Function TInternetFrmTF_2026.ReplaceSpecialChar(info:String):String;
Begin
 info := ReplaceStr(info,'&','&amp;');
 info := ReplaceStr(info, '<' , '&lt;' );
 info := ReplaceStr(info,'"','&quot;');
 info := ReplaceStr(info,'>','&gt;');
 info := ReplaceStr(info,'''','&apos;');
 info := ReplaceStr(info,'.','');

 result := info;

End;

Function TInternetFrmTF_2026.MkReferenceNo:String;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SSec, SYYYY : string;
Begin
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  SYYYY := LTrim(RTrim(IntToStr(YYYY)));
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  Result :=RightStr(Syyyy,2)+SMM+SDD+SSec;
end;

procedure TInternetFrmTF_2026.TypeOfReturnBtnClick(Sender: TObject);
begin
 MkFileLocation;
 //20250519 Igor >>>
 {case TypeOfReturnBtn.ItemIndex of
   3:
     UrlBox.text:='http://www.cra-arc.gc.ca/xmlns/cha/t3010/5-0-0';
   else
     UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/njfs/ext/disclaimer';
 end; }
 //20250519 Igor <<<
end;

procedure TInternetFrmTF_2026.ShowXmlBtnClick(Sender: TObject);
Var FlName:String; h:THandle;
begin
 If TypeofReturnBtn.ItemIndex <0 then
 begin
  ShowMessage('Please select type of return');
  Exit;
 end;

 If FlNm.text='' then exit;
 FlName:=FlNm.text;
 h := ShellExecute(Internetfrm.Handle,'Open',PChar(''+FlName),Nil,Nil,Sw_Show);
 If H<=32 then ShowMessage('File not found (You must click Prepare XML first)');
end;

End.
