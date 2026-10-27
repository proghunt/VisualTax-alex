unit T3_2026internetfrm;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,DBGrids,DB,Printers,ExtCtrls,FileCtrl,
  ShellApi,ActiveX, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;


type
  TInternetFrmT3_2026 = class(TForm)
    PrintDialog1: TPrintDialog;
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    PrepBtn: TBitBtn;
    ConnectBtn: TBitBtn;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    Panel4: TPanel;
    Panel6: TPanel;
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
    Label1: TLabel;
    SaveDialog1: TSaveDialog;
    Panel7: TPanel;
    Label18: TLabel;
    DataSource1: TDataSource;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    ShowXmlBtn: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADQuery;
    Panel5: TPanel;
    DataTypeBtn: TRadioGroup;
    FilingOptionBtn: TRadioGroup;
    TypeOfReturnBtn: TRadioGroup;
    Panel2: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label3: TLabel;
    Label8: TLabel;

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
    procedure EligibilityBtnClick(Sender: TObject);
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
  InternetFrm: TInternetFrmT3_2026;
  F1 : TextFile;
  SelectedList : TStringList;

  //EmplRec:TEmplRec;

  SubmitRef:String;

implementation

{$R *.DFM}

uses
  vtCommon,
  T3_2026,T3_2026Calc,T3_2026TrimStr,T3_2026Declare,T3_2026dataGen,
  T3_2026Main,T3_2026ChildWinNew, vtMulti, // 20180722 Igor
//T3_2026poplist,
  vtTrimStr,vtShared;

procedure TInternetFrmT3_2026.EligibilityBtnClick(Sender: TObject);
begin
 //20180316
// ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/e-services/filing-information-returns-electronically-t4-t5-other-types-returns-overview/upcoming-year-t619/t3ret.html'); //20181217
 //ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/e-services/filing-information-returns-electronically-t4-t5-other-types-returns-overview/t619-2018/t3ret-2018.html'); //20180317

end;

procedure TInternetFrmT3_2026.CancelBtnClick(Sender: TObject);
begin
SelectedList.Free;
Close;
end;

function TInternetFrmT3_2026.validateT619Info:boolean;
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
 else If (Length(OptRec.Prp_TransmitterNo) <> 9) and (Length(OptRec.Prp_TransmitterNo) <> 15) then //jz//20250323 Length(OptRec.Prp_TransmitterNo) <> 6 then
 begin
  ShowMessage('Transmitter number must be 9 or 15 characters'+
  Chr(13)+
  Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end;

end;

Function TInternetFrmT3_2026.validateInternetFrmInfo:boolean;
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

procedure TInternetFrmT3_2026.PrepBtnClick(Sender: TObject);
Var
 FNo:Integer;
 DataTypeCode:string; //[1];
 XmlList:Tstringlist;
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
  0: createT3XML(RetNo, DataTypeCode, SubmitRef, XmlList);  //20220116
 // 1: createT3RetXML(RetNo, DataTypeCode, SubmitRef, XmlList);
 End;
 XmlList.savetofile(FlNm.text);
 ShowMessage('XML file has been completed and saved as '+FlNm.Text);
 Screen.Cursor := crDefault;
end;

procedure TInternetFrmT3_2026.FormCreate(Sender: TObject);
begin
 FRetNo := GetCurrentRetNo;
 FilingOptionBtn.ItemIndex:=0;

 If UrlBox.text='' then
    UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/njfs/ext/disclaimer';   //jz//20250323
   // UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/leb0/upload/pub/entry-e.do';  //20130227
   // UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/leb0/upload/T05iDisclaimerRender-e';

 If Not DirectoryExists(AppDir+'\'+'Efile') then CreateDir(AppDir+'\'+'Efile');
 //20180315
 If CountResidentSlips(RetNo) =0 then ShowMessage('There are no T3 Slips to Efile.');
 if T3EfileEligible(RetNo)=False then  ShowMessage('This Trust Return is not eligible for Efile');
end;


procedure TInternetFrmT3_2026.DBGrid1DblClick(Sender: TObject);
begin
AddBtnClick(Sender);
end;

procedure TInternetFrmT3_2026.AddBtnClick(Sender: TObject);
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

procedure TInternetFrmT3_2026.MkFileLocation;
Begin
 Case TypeOfReturnBtn.ItemIndex of
  0: FlNm.Text := AppDir+'\Efile\'+'T3Slips  - '+FetchElm(RetNo,'T3',1);
  1: FlNm.Text := AppDir+'\Efile\'+'T3Return - '+FetchElm(RetNo,'T3',1); //20180314 Igor
 end;

 FlNm.text:=ReplaceStr(FlNm.Text,'.','');
 FlNm.text:=ReplaceStr(FlNm.Text,'/','');
 FlNm.text:=ReplaceStr(FlNm.Text,'&','');
 FlNm.text:=FlNm.text+'.XML';
end;

procedure TInternetFrmT3_2026.RemoveBtnClick(Sender: TObject);
begin
 ListBox1.Clear;
end;

procedure TInternetFrmT3_2026.ListBox1DblClick(Sender: TObject);
begin
RemoveBtnClick(Sender);
end;

procedure TInternetFrmT3_2026.ConnectBtnClick(Sender: TObject);
Var h:THandle;
begin
 If TypeofReturnBtn.ItemIndex <0 then
 begin
  ShowMessage('Please select type of return');
  Exit;
 end;

 //20190401
 If TypeofReturnBtn.ItemIndex =1 then  //efile return
 begin
  If T3EfileEligible(RetNo)=false then
  Begin
   ShowMessage('This T3 Return is Not eligible for Efile');
   Exit;
  End;
 end;


 If Not FileExists(FlNm.Text) then
 begin
   ShowMessage('Please select a valid File Location');
   Exit;
 end;

 h := ShellExecute(Application.MainForm.Handle,'open',PChar(UrlBox.Text),Nil,Nil,Sw_Show);
 // 20180722 Igor >>>
 If H<=32 then ShowMessage('Connection failed')
 else AddLogAppMon(amtOnEfile, RetNo); //20220519 Igor
 // 20180722 Igor <<<
end;

Function TInternetFrmT3_2026.ReplaceSpecialChar(info:String):String;
Begin
 info := ReplaceStr(info,'&','&amp;');
 info := ReplaceStr(info, '<' , '&lt;' );
 info := ReplaceStr(info,'"','&quot;');
 info := ReplaceStr(info,'>','&gt;');
 info := ReplaceStr(info,'''','&apos;');
 info := ReplaceStr(info,'.','');

 result := info;

End;

Function TInternetFrmT3_2026.MkReferenceNo:String;
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

procedure TInternetFrmT3_2026.TypeOfReturnBtnClick(Sender: TObject);
begin
 MkFileLocation;

end;

procedure TInternetFrmT3_2026.ShowXmlBtnClick(Sender: TObject);
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
