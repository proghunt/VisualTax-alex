Unit T2_2027SaveAsPdf;

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Printers, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, Vcl.Mask, vteditbox, vtLabel, vtShape,
  ShellApi, // 20200425
  ClipBrd, // 20200428
  //vcl.FileCtrl,   //20200429
  vtPDFPrinter; // 20200424

 type
  TSaveAsPdfT2_2027 = class(TForm)
    Panel2: TPanel;
    vtLabel42: TvtLabel;
    vtLabel4: TvtLabel;
    ListBox1: TListBox;
    CreatePdfBtn1: TBitBtn;
    EmailPdfBtn1: TButton;
    DocName1: TvtEdit;
    CancelBtn: TBitBtn;
    vtShape4: TvtShape;
    vtLabel37: TvtLabel;
    vtLabel6: TvtLabel;
    DirGroup: TRadioGroup;
    vtLabel9: TvtLabel;
    FolderName: TvtEdit;
    MapiEmailBox: TCheckBox;
    vtLabel10: TvtLabel;
    vtLabel11: TvtLabel;
    Fr: TvtLabel;
    RecipientEmail: TvtEdit;
    RecipientSalutation: TvtEdit;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    Panel1: TPanel;
    vtShape2: TvtShape;
    vtLabel5: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel20: TvtLabel;
    ListBox2: TListBox;
    CreatePdfBtn2: TBitBtn;
    DocName2: TvtEdit;
    ListBox3: TListBox;
    EmailPdfBtn2: TButton;
    AddAllBtn: TBitBtn;
    RemoveAllbtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CreatePdfBtn1Click(Sender: TObject);
    procedure ShowPdfBTN1Click(Sender: TObject);
    procedure ShowPdfBtN2Click(Sender: TObject);
    procedure CreatePdfBtn2Click(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure RemoveAllBtnoldClick(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure DirGroupClick(Sender: TObject);
    procedure EmailPdfBtn1Click(Sender: TObject);
    procedure EmailPdfBtn2Click(Sender: TObject);
    procedure ShowPdfBtn0Click(Sender: TObject);
    Procedure Printit(RetNo: Integer; FName, FullDocName: String);
    procedure FolderNameExit(Sender: TObject);
    procedure RemoveAllBtnClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure RemoveOneBtnClick(Sender: TObject);
  private
    FRetNo: Integer;
    { Private declarations }
  public
    property RetNo: Integer read FRetNo;
    { Public declarations }
  end;


 var
  SaveAsPdfT2_2027: TSaveAsPdfT2_2027;
  PDF: TvtPDFPrinter;
  // for Email
  SomeSubject, SomeRecipientEMail, SomeSenderEMail, SomeAttachment,
    SomeText: String;
  SomeSalutation: String;
  FullDocName0, FullDocName1, FullDocName2: String;
  DocNameSuffix:String;
  DocTaxPayerId:String;
  //for sorting
  PrintSeqList:TStringList;  //20200504
  UnsortedList:TstringList;
  SortedList:TstringList;
implementation

{$R *.dfm}

Uses
  vtMulti, vtCommon, vtDialogs, vtMain,
  T2_2027, T2_2027Declare, T2_2027Common,
  T2_2027TrimStr,T2_2027Print,
  T2_2027ChildWinNew,
  T2_2027Main,
  MAPI,
  T2_2027printReturnFrm,
  (*
  T1_2026Common2,  T1_2026GetFile, T1_2026T1Rtns, T1_2026T1Rtns2,
  T1_2026FpFind, T1_2026AdvFnd, T1_2026Calc, ,
  T1_2026Main, T1_2026ChartClients,
  MAPI,T1_2026printReturnFrm,
  *)
  vtTrimStr, vtShared, vtDataBase, // 20150826 IGOR
  vtFileStorage, Variants; // 20160422 Igor

procedure TSaveAsPdfT2_2027.RemoveAllBtnClick(Sender: TObject);
begin
ListBox3.Items.Clear;
end;

procedure TSaveAsPdfT2_2027.RemoveAllBtnoldClick(Sender: TObject);
begin
  ListBox3.Items.Clear;
end;

procedure TSaveAsPdfT2_2027.RemoveOneBtnClick(Sender: TObject);
begin
ListBox3DblClick(Sender)
end;



procedure TSaveAsPdfT2_2027.CreatePdfBtn1Click(Sender: TObject);
Var
  i: Integer;
  FName: String;
begin
  FullDocName1 := FolderName.Text + '/' + DocName1.Text;
  PDF := TvtPDFPrinter.Create(AppT2);//AppT2_2027);
  Try
    for i := 0 to ListBox1.Items.count - 1 do
    Begin
      FName := ListBox1.Items[i];
      PDF.PrintForm(RetNo, FName, 99,
        T2_2027Print.AfterReadComponentForPrint,
        T2_2027Print.PrintEditBox, T2_2027Print.PrepareRichEdit,
        T2_2027Print.PrintImageT2, T2_2027Print.PrintHeader);
    end;
    PDF.SaveToFile(FullDocName1, false);
  Finally
    PDF.Free;
    ShellExecute(Application.Handle, 'open', Pchar('' + FullDocName1), Nil, Nil, Sw_Show);
  End;

end;

procedure TSaveAsPdfT2_2027.CreatePdfBtn2Click(Sender: TObject);
Var
  i: Integer;
  FName: String;
begin
  if ListBox3.Items.count <= 0 then
  Begin
    ShowMessage
      ('No forms selected.  Use Select ALL or Double click desired forms');
    Exit;
  End;
  FullDocName2 := FolderName.Text + '/' + DocName2.Text;
  PDF := TvtPDFPrinter.Create(AppT2); //(AppT2_2027);
  Screen.Cursor := CrHourGlass;
  Try
    for i := 0 to ListBox3.Items.count - 1 do
    Begin
      FName := ListBox3.Items[i];
      PDF.PrintForm(RetNo, FName, 99,
        Nil, //T1_2026Print.AfterReadComponentForPrint,
        T2_2027Print.PrintEditBox,
        T2_2027Print.PrepareRichEdit,
        Nil,//T2_2027Print.PrintImageT1,
        T2_2027Print.PrintHeader);
    end;
    PDF.SaveToFile(FullDocName2, false);
  Finally
    PDF.Free;
    Screen.Cursor := CrDefault;
    ShellExecute(Application.Handle, 'open', Pchar('' + FullDocName2), Nil,Nil, Sw_Show);
  End;
end;

procedure TSaveAsPdfT2_2027.DirGroupClick(Sender: TObject);
begin
  if DirGroup.ItemIndex = 0 then
    FolderName.Text := OptRec.Dir_ClientDocs
    // + GetLastName(RetNo) + ',' + GetFirstName(RetNo)
  Else
    FolderName.Text := 'C:/Downloads';
  ForceDirectories(FolderName.Text);
end;

procedure TSaveAsPdfT2_2027.EmailPdfBtn1Click(Sender: TObject);
begin
  if RecipientEmail.Text = '' then
  Begin
    ShowMessage
      ('There is no Email to send it to. Enter it on this form or on the INFO form.');
    Exit;
  End;

  if Not FileExists(FullDocName1) then
  Begin
    ShowMessage('File ' + FullDocName1 + ' does not exist');
    Exit;
  end;

  Clipboard.AsText := FullDocName1;

  ShowMessage('In the upcoming Email, click the Attach button of your Email.' +
    Chr(13) + 'Then navigate your directories until you find the Reference folder '
    + Chr(13) +
    'and double click the PDF files you want to attach to the Email');

  SomeSubject := 'Signature Tax Forms - Our Reference: ' + FullDocName1;
  SomeRecipientEMail := RecipientEmail.Text;
  SomeSenderEMail := '';
  SomeAttachment := FullDocName1;
  SomeText := RecipientSalutation.Text + '%0D%0A'
    + '%0D%0A' + 'Attached are the tax documents which contain your Electronic Signature.'
    + '%0D%0A' + 'Please review them and Forward this Email back to us with the words ACCEPTED.'
    + '%0D%0A' + 'This is your confirmation that we can use these documents for filing your tax returns.'
    + '%0D%0A' + '%0D%0A' + 'Our reference is:  ' + FullDocName1
    + '%0D%0A' + '%0D%0A' + OptRec.Prp_Name + Chr(13) + ' (' + OptRec.Prp_Area + ') ' + OptRec.Prp_Tel;

   //if MainFormT1.SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEmail)
   //Else
   SendEmail(RetNo, SomeSubject, SomeRecipientEMail, SomeSenderEMail, SomeAttachment, SomeText);

end;

procedure TSaveAsPdfT2_2027.EmailPdfBtn2Click(Sender: TObject);
begin
  if RecipientEmail.Text = '' then
  Begin
    ShowMessage
      ('There is no Email to send it to. Enter it on this form or on the T2 form.');
    Exit;
  End;

  if Not FileExists(FullDocName2) then
  Begin
    ShowMessage('File ' + FullDocName2 + ' does not exist');
    Exit;
  end;

  Clipboard.AsText := FullDocName2;

  ShowMessage('In the upcoming Email, click the Attach button of your Email.' +
    Chr(13) + 'Then navigate your directories until you find the Reference folder '
    + Chr(13) +
    'and double click the PDF files you want to attach to the Email');

  SomeSubject := 'Tax return forms - Our Reference: ' + FullDocName2;
  SomeRecipientEMail := RecipientEmail.Text;
  SomeSenderEMail := '';
  SomeAttachment := FullDocName2;
  SomeText := RecipientSalutation.Text + '%0D%0A' +
    'Attached please find tax forms of your tax return in PDF format .' +
    '%0D%0A' + '%0D%0A' + 'Our reference is:  ' + FullDocName2 + '%0D%0A' +
    '%0D%0A' + OptRec.Prp_Name + Chr(13) + ' (' + OptRec.Prp_Area + ') ' +
    OptRec.Prp_Tel;
  if MapiEmailBox.Checked then MainFormT2.SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEmail) //20200505
  Else
  SendEmail(RetNo, SomeSubject, SomeRecipientEMail, SomeSenderEMail,SomeAttachment, SomeText);

end;

procedure TSaveAsPdfT2_2027.FormCreate(Sender: TObject);
begin
  FRetNo := GetCurrentRetNo;
  DocTaxPayerId:=GetCorpName(RetNo);  //20200506
  DocNameSuffix:='.PDF'; //20200504
  PrintSeqList:=TstringList.Create;
  if FileExists(AppDir+'/'+'PrintSeq.txt') then
    PrintSeqList.LoadFromFile(AppDir+'/'+'PrintSeq.txt')
  Else
   ShowMessage('Print Sequence has not been defined. Exit and click Menu item Configure -> Print Sequence');
end;



procedure TSaveAsPdfT2_2027.ListBox2Click(Sender: TObject);
begin
 ListBox2DblClick(Sender);
end;

procedure TSaveAsPdfT2_2027.ListBox2DblClick(Sender: TObject);
Var
  k: Integer;
begin
  k := ListBox2.ItemIndex;
  if k >= 0 then
    ListBox3.Items.Add(ListBox2.Items[k]);
end;

procedure TSaveAsPdfT2_2027.ListBox3DblClick(Sender: TObject);
Var
  k: Integer;
begin
  k := ListBox3.ItemIndex;
  if k >= 0 then
    ListBox3.Items.delete(k);
end;

procedure TSaveAsPdfT2_2027.SelectAllBtnClick(Sender: TObject);
Var
  i: Integer;
begin
  ListBox3.Items.Clear;
  for i := 0 to ListBox2.Items.count - 1 do
  Begin
    ListBox3.Items.Add(ListBox2.Items[i]);
  End;
end;

procedure TSaveAsPdfT2_2027.ShowPdfBtn0Click(Sender: TObject);
begin
  if Not DirectoryExists(FolderName.Text) then
  Begin
    ShowMessage('Folder ' + FolderName.Text + ' does not exist');
    Exit;
  end;

  if Not FileExists(FullDocName0) then
  Begin
    ShowMessage('File ' + FullDocName0 + ' does not exist');
    Exit;
  end;
  ShellExecute(Application.Handle, 'open', Pchar(FullDocName0), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TSaveAsPdfT2_2027.ShowPdfBTN1Click(Sender: TObject);
begin
  if Not DirectoryExists(FolderName.Text) then
  Begin
    ShowMessage('Folder ' + FolderName.Text + ' does not exist');
    Exit;
  end;

  if Not FileExists(FullDocName1) then
  Begin
    ShowMessage('File ' + FullDocName1 + ' does not exist');
    Exit;
  end;

  ShellExecute(Application.Handle, 'open', Pchar(FullDocName1), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TSaveAsPdfT2_2027.ShowPdfBtN2Click(Sender: TObject);
begin
  if Not DirectoryExists(FolderName.Text) then
  Begin
    ShowMessage('Folder ' + FolderName.Text + ' does not exist');
    Exit;
  end;

  if Not FileExists(FullDocName2) then
  Begin
    ShowMessage('File ' + FullDocName2 + ' does not exist');
    Exit;
  end;

  ShellExecute(Application.Handle, 'open', Pchar(FullDocName2), nil, nil,
    SW_SHOWNORMAL);
end;

Procedure TSaveAsPdfT2_2027.Printit(RetNo: Integer; FName, FullDocName: String);
Begin
  {
    PDF := TvtPDFPrinter.Create(AppT1_2026);
    PDF.PrintForm(RetNo,DocName, 99, T1_2026Print.AfterReadComponentForPrint,
    T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
    T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
    PDF.SaveToFile(FullDocName, false);

    //pdffactory
    MainFormT1.StartPrintForm(Retno,FName,99);  //20200428
  }
end;

procedure TSaveAsPdfT2_2027.FolderNameExit(Sender: TObject);
begin
 if DirectoryExists(FolderName.text) = false then
 Begin
   if MessageDlg('Folder '+FolderName.text+' does not exist. Create it?',
      mtInformation, [mbYes, mbNo], 0) = mrYes
   then
     FileCtrl.Forcedirectories(FolderName.text);
 End;
end;

procedure TSaveAsPdfT2_2027.FormActivate(Sender: TObject);
Var
  i: Integer;
begin
  UnSortedList:=TStringList.Create;
  SortedList:=TStringList.Create;

  RecipientEmail.Text := FetchElm(RetNo, 'T2', 263); //20200506
 // DirGroup.ItemIndex := 1;    //20200517
  DirGroupClick(Sender);

  RecipientSalutation.Text := 'Dear ' + FetchElm(RetNo,'T2',743);  //forst nm
  //20200517
  FolderName.text:=optRec.Dir_ClientDocs+'\'+MkDirforClientDocs(RetNo);
  ForceDirectories(FolderName.text);
  DocName1.Text:='Signature Forms'+'.PDF';
  FullDocName1:=FolderName.text+'\'+DocName1.text;
  //'T2 Return-YE-'+LeftStr(GetTaxationYearEnd(RetNo),4);

  {
  DocName1.Text :=DocTaxPayerId+'-'+LeftStr(GetTaxationYearEnd(RetNo),4); // +' (Signature Forms) '+DocNameSuffix; //20200517
  FullDocName1 := FolderName.Text + '\'+DocName1.Text+'\'+'(Signature Forms)'+'.PDF';
  //DocTaxPayerId+' (Signature Forms) '+'.PDF';
  }
  DocName2.Text :='All Forms'+'-'+DocTaxPayerId+DocNameSuffix;
  FullDocName2 := FolderName.Text + '/' + DocName2.Text;

  If Ret[RetNo].FrmHasData[GetFormNo('T183CP')] then
  Begin
    ListBox1.Items.Add('T183CP');
  End;
  If Ret[RetNo].FrmHasData[GetFormNo('T1134')] then  ListBox1.Items.Add('T1134');
  If Ret[RetNo].FrmHasData[GetFormNo('T1135')] then  ListBox1.Items.Add('T1135');
  If Ret[RetNo].FrmHasData[GetFormNo('T106')] then  ListBox1.Items.Add('T106');
  If Ret[RetNo].FrmHasData[GetFormNo('CONSENT#1')] then ListBox1.Items.Add('CONSENT#1');
  If Ret[RetNo].FrmHasData[GetFormNo('CONSENT#2')] then ListBox1.Items.Add('CONSENT#2');
  If Ret[RetNo].FrmHasData[GetFormNo('ACONSENT')] then ListBox1.Items.Add('ACONSENT');

  for i := 0 to (FList.count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then
    Begin
      if FRec.FormName<>'CUSTINV' then  //should not be in the flist
        ListBox2.Items.Add(FRec.FormName + FRec.FormInst);
    End;
  end;
  // Now sort the ListBox2.items
  for i:=0 to ListBox2.Items.count-1 do UnsortedList.Add(ListBox2.Items[i]);
  SortTaxForms(UnsortedList,PrintSeqList,SortedList);
  ListBox2.items.clear;
  for i:=0 to SortedList.count-1 Do ListBox2.Items.Add(SortedList[i]);
  SelectAllBtnClick(Sender);
end;


end.
