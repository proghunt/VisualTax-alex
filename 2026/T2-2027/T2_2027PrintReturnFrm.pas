unit T2_2027PrintReturnFrm;
//imported 08-01

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,CheckLst,ExtCtrls,FileCtrl,T2_2027Declare,T2_2027TrimStr,vtLabel,
  vtShape,T2_2027common,Printers,T2_2027Calc,T2_2027Print,T2_2027PdfFrm;

 Type
  TFrmToPrint = Record
   FName       : String;//[15]; //20150701
   FDescr      : String;//[22]; //20150701
   Seq         : String;//[3];  //20150701
   Copies      : String;//[2];  //20150701

 end;

type
  TPrintReturnFrmT2_2027 = class(TForm)
    vtShape4: TvtShape;
    vtLabel87: TvtLabel;
    Panel1: TPanel;
    CheckListBox1: TCheckListBox;
    SelectPrintSetGroup: TRadioGroup;
    SelectFormsGroup: TRadioGroup;
    PrintDialog1: TPrintDialog;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    SavePdfBtn: TBitBtn;
    Label2: TLabel;
    PdfFactoryBtn: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    FlagAsPrintedBox: TCheckBox;
    SaveDialog1: TSaveDialog;
    procedure CancelBtnClick(Sender: TObject);
    procedure SelectPrintSetGroupClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure SelectFormsGroupClick(Sender: TObject);
    procedure PrintIt(RetNo:integer;FormsToPrint:TstringList);
    Procedure PopulateFrmToPrintRec(PrintItem:String);
    procedure SavePdfBtnClick(Sender: TObject);
    procedure PdfFactoryBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject); //20200116 Igor
  //  procedure EmailPrintoutBtnClick(Sender: TObject);
  private
    RetNo:Integer;
    i,j: integer; FormsToPrint :TstringList;
    Copies : string[1];
    Template :string;//[30]; //20150701
    SelectedSet:String;
    s:String[1];
    FrmToPrint:TFrmToPrint;

    OldPrinterName,PDFFullfileName:String; Dir:String;DlName:String;
  public
    { Public declarations }
  end;

procedure  PrintReturnFrm(RNo: integer);


implementation

uses
  fProgres,vtCommon,
  T2_2027,T2_2027Main,//T2_2027ChildWinNew,T2_2027progres,
  vtTrimStr,vtShared,
  vtPDFPrinter; //20161211 Igor

{$R *.DFM}

procedure TPrintReturnFrmT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TPrintReturnFrmT2_2027.SelectPrintSetGroupClick(Sender: TObject);
Var TempList:TStringList;Prov:String;
  i: integer;
begin
 Prov:='FED';    //20110131
// If SlipsAvailable(RetNo) then Ret[RetNo]^.FrmHasData[GetFormNo('T4SUM#1')] := True;
 CheckListBox1.Items.Clear;
 Case SelectPrintSetGroup.itemIndex of
  0:   SelectedSet := 'Client';
  1:   SelectedSet := 'Preparer';
  2:   SelectedSet := 'Other 1';
  3:   SelectedSet := 'Other 2';
  4:   SelectedSet := 'Other 3';
 end;

 If SelectFormsGroup.itemIndex =0 then For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=True;
 If SelectFormsGroup.itemIndex =1 then For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=False;

 CheckListBox1.Refresh;
 // If SelectedSet = 'CRA' then            Template := 'CRASET.D'
  if      SelectedSet = 'Client'    then Template := 'CLINTSET.D'
  else if SelectedSet = 'Preparer'  then Template := 'PREPSET.D'
  else if SelectedSet = 'Other 1'   then Template := 'OTH1SET.D'
  else if SelectedSet = 'Other 2'   then Template := 'OTH2SET.D'
  else if SelectedSet = 'Other 3'   then Template := 'OTH3SET.D';
  FormsToPrint := TstringList.Create;
  FormsToPrint.Sorted :=False;
  GetFormsToPrint(RetNo,Template,FormsToPrint,Prov);
  ResortFormsToPrint(FormsToPrint);
  If FormsToPrint.Count =0 then
    begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
  end;
(*
 Else  //C+P  and All
 If LeftStr(SelectedSet,3) = 'C+P' then
 begin
   //client
   Template := 'CLINTSET.D';
   FormsToPrint := TstringList.Create;
   FormsToPrint.Sorted :=False;
   GetFormsToPrint(RetNo,Template,FormsToPrint);
   ResortFormsToPrint(FormsToPrint);
   //Preparer
   Template := 'PREPSET.D';
   TempList := TstringList.Create;
   TempList.Sorted :=False;
   GetFormsToPrint(RetNo,Template,TempList);
   TempList.Add('  -----------------------------------------');
   ResortFormsToPrint(TempList);
   For i:=0 to TempList.count-1 do FormsToPrint.Add(TempList[i]);
   TempList.Free;

   If FormsToPrint.Count =0 then
   begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
   end;
 end //C+P
 else if UpperCase(LeftStr(SelectedSet,3)) = 'ALL' then
 begin
   //cra
   Template := 'CRASET.D';
   FormsToPrint := TstringList.Create;
   FormsToPrint.Sorted :=False;
   GetFormsToPrint(RetNo,Template,FormsToPrint);
   ResortFormsToPrint(FormsToPrint);
   //Client
   Template := 'CLINTSET.D';
   TempList := TstringList.Create;
   TempList.Sorted :=False;
   GetFormsToPrint(RetNo,Template,TempList);
   TempList.Add('  -----------------------------------------');
   ResortFormsToPrint(TempList);
   For i:=0 to TempList.count-1 do FormsToPrint.Add(TempList[i]);
   TempList.Free;
   //Preparer
   Template := 'PREPSET.D';
   TempList := TstringList.Create;
   TempList.Sorted :=False;
   GetFormsToPrint(RetNo,Template,TempList);
   TempList.Add('  -----------------------------------------');
   ResortFormsToPrint(TempList);
   For i:=0 to TempList.count-1 do FormsToPrint.Add(TempList[i]);
   TempList.Free;

   If FormsToPrint.Count =0 then
   begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
   end;
 end;
 *)
 CheckListBox1.Items.Clear;
 For i:=0 to FormsToPrint.count-1 do
 Begin
   PopulateFrmToPrintRec(FormsToPrint[i]);
   If Length(AllTrim(FrmToPrint.FName)) >1 then  //20110124
     CheckListBox1.Items.add(PaddR(FrmToPrint.FName,12)+PaddR(FrmToPrint.FDescr,22)+Space(30)+FrmToPrint.Seq+FrmToPrint.Copies);
 end;
 If SelectFormsGroup.itemIndex =0 then For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=True;
 If SelectFormsGroup.itemIndex =1 then For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=False;
 CheckListBox1.Refresh;
end;

procedure SaveToPDFIt(ARetNo: Integer; AFormsToPrint: TStrings; AFileName: String); //20161211 Igor
var
  FName: String;
  FCopies: Integer;
  i, j: Integer;
  ConfigBarCodeIndicator: Boolean;
  PDF: TvtPDFPrinter;
begin
  PDF := TvtPDFPrinter.Create(AppT2);
  try
    for i := 0 to (AFormsToPrint.Count - 1) do
    begin
      FName := Midstr(AFormsToPrint[i],5,10);
      FCopies := MyStrToInt(Midstr(AFormsToPrint[i],4,1));
      Calc(ARetNo,FName);

      For j := 1 to FCopies do
      begin
          PDF.PrintForm(ARetNo, FName, 99, T2_2027Print.AfterReadComponentForPrint,
            T2_2027Print.PrintEditBox, T2_2027Print.PrepareRichEdit,
            T2_2027Print.PrintImageT2, T2_2027Print.PrintHeader);
      end;
    end;
    if AFileName <> '' then
      PDF.SaveToFile(AFileName, false);
  finally
    PDF.free;
  end;
end;

procedure TPrintReturnFrmT2_2027.PrintBtnClick(Sender: TObject);
var
  i: integer;
begin
 If FormsToPrint.Count=0 then begin ShowMessage('No Forms to print');Exit;End;

 FormsToPrint.clear;
 For i:=0 to CheckListBox1.Items.count-1 do
 begin
   If CheckListBox1.Checked[i] then
   begin
    //reassemple in originl format sssCFFFFFFFFF
    FormstoPrint.add(MidStr(CheckListBox1.Items[i],65,3)  //seq
      +MidStr(CheckListBox1.Items[i],68,1)
      +AllTrim(MidStr(CheckListBox1.Items[i],1,12)));  //
   end;
 end;
 //20161211 Igor >>>
 If (Sender = PrintBtn) then
   PrintIt(RetNo,FormsToPrint)
 else
   SaveToPDFIt(RetNo, FormsToPrint, PDFFullfileName);
 //20161211 Igor <<<
end;

procedure  PrintReturnFrm(RNo: integer);
begin
  with TPrintReturnFrmT2_2027.Create(Application) do
  begin
    RetNo := RNo;
    ShowModal;
    Free;
  end;
end;

procedure TPrintReturnFrmT2_2027.FormCreate(Sender: TObject);
begin

 FlagAsPrintedBox.Checked:=False;
 FastPrint:= True;
 //SelectPrintSetGroup.ItemIndex:=0; //20200116 Igor
end;

procedure TPrintReturnFrmT2_2027.FormShow(Sender: TObject); //20200116 Igor
begin
  SelectPrintSetGroup.ItemIndex:=0;
end;

procedure TPrintReturnFrmT2_2027.SelectFormsGroupClick(Sender: TObject);
var
  i: integer;
begin
 If SelectFormsGroup.itemIndex =0 then For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=True;
 If SelectFormsGroup.itemIndex =1 then For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=False;
 CheckListBox1.Refresh;
end;

procedure TPrintReturnFrmT2_2027.PrintIt(RetNo:integer;FormsToPrint:TstringList);
var
  i,j,FCopies:integer;
  FName :string;//[12]; //20150701
begin
   If Not PrintDialog1.Execute then Exit;
   Screen.Cursor := crHourGlass;
   Progress.Show;  {Show progress window}
   AbortSw := False;  {Initialize}
   PauseSw := False;
   Progress.Caption := 'Print progress...';
   Progress.Label1.Caption := 'Printing Return:'+IntToStr(RetNo);
   Progress.Label2.Caption := GetRetName(RetNo);
   Progress.Gauge1.MinValue := 0;
   Progress.Gauge1.MaxValue := FormsToPrint.Count;
   Progress.Gauge1.Progress :=0;
   Progress.ListBox1.Visible := True;
   Progress.Gauge1.Visible := True;
   Progress.ListBox1.Clear;
   Progress.ListBox1.Clear;
   For j :=0 to FormsToPrint.Count-1 do  {show list to be done}
     begin
      If AllTrim(Midstr(FormsToPrint[j],5,10))>'' then
       Progress.ListBox1.Items.Add(Midstr(FormsToPrint[j],5,10));  //20100113
     end;
   //If FastPrint = True then Printer.BeginDoc; //20160905 Igor
   NeedNewPage := False; //20160905 Igor
   for i :=0 to (FormsToPrint.Count - 1) do
   begin
      Application.ProcessMessages;  {allows abort click on progrees screen }
      If AbortSw then
      begin
       Progress.Close;

       If Printer.Printing then
       begin
         Printer.Abort;
       end;
      end;
      FName := Midstr(FormsToPrint[i],5,10);
      FCopies := MyStrToInt(Midstr(FormsToPrint[i],4,1));
      Progress.Label3.Caption := 'Form Name:';
      Progress.Label4.Caption := FName;
      Progress.Label5.Caption := '';
      Progress.Label6.Caption := '';
      Progress.ListBox1.ItemIndex :=i;  {movable focus on list}
      Progress.Refresh;

      Calc(RetNo,FName);
      For j:=1 to FCopies do
       begin
        PrintForm(RetNo,FName,99,'');//20200521
      //  PrintForm(RetNo,FName,1,''); //PrintForm(RetNo,FName,1); //20150622 //20200116 Igor
      //  If UpperCase(GetAddBlankPg(FName))='Y' then PrintForm(RetNo,'BLANKPG',1);  // 20100210
        //20100210
       end;
      Progress.Gauge1.Progress :=i+1;
      Progress.Gauge1.Refresh;
   end;
   If Printer.Printing then Printer.EndDoc; //20160905 Igor
   Progress.Close;
   If FlagAsPrintedBox.Checked = True then   //20110130
   begin
    Ret[RetNo].Frm[GetFormNo('STATUS')].Strings[4] := '03';
    Ret[RetNo].PrpStatus :='03';
    If FlagAsPrintedBox.Checked =True then //20110130
     UpdatePrintDate(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName);
   end;
   Screen.Cursor := crDefault;
end;

Procedure TPrintReturnFrmT2_2027.PopulateFrmToPrintRec(PrintItem:String);
Begin
     FrmToPrint.FName:=AllTrim(MidStr(PrintItem,5,20));
     FrmToPrint.FDescr:=GetFormAbbrevDescr(ExtractNonInstFormName(FrmToPrint.FName));  //20110124
     FrmToPrint.Seq:=LeftStr(PrintItem,3);
     FrmToPrint.Copies:=MidStr(PrintItem,4,1);
End;


procedure TPrintReturnFrmT2_2027.SavePdfBtnClick(Sender: TObject);
Var flName:String;
  FileNameSuffix:String;
  D: TDateTime; //20160910 igor
begin
  Showmessage('Click the Print button, select the PdfFactory print driver'
  +Chr(13)+'Then Select the Save button of the PdfFactory');
EXIT;
  //20180503 Igor >>>
  Dir:=optRec.Dir_ClientDocs;  //20200519
  //Dir := TPath.Combine(optRec.Dir_ClientDocs, GetLastName(retNo) + ','+ GetFirstName(retNo));//20171031 igor
  ForceDirectories(Dir);
  case SelectPrintSetGroup.itemindex of  //20200506
   0: FileNameSuffix:='Client Copy';
   1: FileNameSuffix:='Preparer Copy';
   2: FileNameSuffix:='Other Print Set 1';
   3: FileNameSuffix:='Other Print Set 2';
   4: FileNameSuffix:='Other Print Set 3';
  end;

  FlName:=' T2-'+GetTaxationYearEnd(RetNo)+' ('+FileNameSuffix+')';

  if CheckIsCloud(true) then
    PDFFullfileName := ChangeFilePath(FlName, Dir)
  else
  begin
    SaveDialog1.Title    := 'Save to PDF';
    SaveDialog1.InitialDir := Dir;
    SaveDialog1.Filter :=  'PDF|*.pdf';
    SaveDialog1.FileName :=FlName;
    SaveDialog1.DefaultExt := '.pdf';
    SaveDialog1.Options := [ofOverwritePrompt,ofPathMustExist];
    //If not SaveDialog1.Execute then exit;
    PDFFullfileName := SaveDialog1.FileName;
  end;

  //20180503 Igor <<<
  PrintBtnClick(Sender);
  (* ???  CON //20200519
  //20170310 Igor >>>
  if chbAutoSaveToMobileDB.Checked then
    SilentAddFile(AppT2_2027, RetList[GetCurrentRetNo].SourceFlName, PDFFullfileName);
  //20170310 Igor <<<
  *)

  {
  if MessageDlg('Return printout has been saved in "' + PDFFullfileName + '".'+#13+
                'Review it?', mtInformation, [mbYes, mbCancel], 0) = mrYes then
    OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
  }
  EXIT;
  //  STOPS HERE?

(*
  //20160912 CON
  Showmessage('SaveToPrd function is currently unavailable'
  +Chr(13)+'Use normal print, select the PdfFactory print driver'
  +Chr(13)+'Enter a file path and Click the PdfFactory Save button');
//  Exit;

  OldPrinterName:=GetDefaultPrinterName;
  If IsPrinterInstalled('PDFFactory') then
  begin
   SetDefaultPrinter('PdfFactory');
  end
  Else
  begin
   ShowMessage('The PDFFactory printer Driver has not been installed');
  // ExecuteForm(TPDFFrmT2_2020);
  // If CloseAfterPrintBox.checked then Close;  //20110226
   Exit;
 end;

  //20180503 Igor >>>
  FlName:=GetLastName(retNo) + ','+ GetFirstName(retNo)+ ' T1-'+AppYear;
  if CheckIsCloud(true) then
    PDFFullfileName := ChangeFilePath(FlName, Dir)
  else
  begin
    SaveDialog1.Title    := 'Save to PDF';
    Dir:=optRec.Dir_ClientDocs+'\'+GetLastName(retNo) + ','+ GetFirstName(retNo);
    ForceDirectories(Dir);
    SaveDialog1.InitialDir := Dir;
    SaveDialog1.Filter :=  'PDF|*.pdf';
    SaveDialog1.FileName :=FlName;
    SaveDialog1.DefaultExt := '.pdf';
    SaveDialog1.Options := [ofOverwritePrompt,ofPathMustExist];
    //20160910 Igor >>>
    If not SaveDialog1.Execute then
      exit;
    PDFFullfileName := SaveDialog1.FileName;
  end;
  //20180503 Igor <<<

  AdjustFinePrintRegistrySettings(PDFFullfileName);
  try
    //20160910 igor <<<
    PrintBtnClick(Sender);
  finally
    AdjustFinePrintRegistrySettings('');
    D := Now;
  end;
//20160910 Igor <<<
  SetDefaultPrinter(OldPrinterName);
  //20160905 Igor >>>
  If not AbortSw and  //20160910 Igor
     (PdfFullfileName > '') and
     Fileexists(PDFFullfileName) and
     (FileDateToDateTime(FileAge(PDFFullfileName)) >= IncSecond(D, -10))   then  //20160910 Igor
    if MessageDlg('Return printout has been saved in "' + PDFFullfileName + '".'+#13+
                  'Review it?', mtInformation, [mbYes, mbCancel], 0) = mrYes then
      OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName))
    else
  else
  if not AbortSw and  //20160910 Igor
     (PdfFullfileName > '') and
     (not Fileexists(PDFFullfileName) or
       (FileDateToDateTime(FileAge(PDFFullfileName)) < IncSecond(Now, -5))) then
    MessageDlg('An error occurred while saving the file "'+PDFFullfileName+'".', mtError, [mbOk], 0);
  //20160905 Igor <<<
*)
end;

//------------------------------------
(*20200519  Doe not work
Var flName:String;
begin
//20161211 Igor>>>
  //20180503 Igor >>>
  Dir:=optRec.Dir_ClientDocs+'\'; //20200519
  //+GetLastName(retNo) + ','+ GetFirstName(retNo);
  ForceDirectories(Dir);
  FlName:='T2-'+GetTaxationYearEnd(RetNo); //20200519
    //GetLastName(retNo) + ','+ GetFirstName(retNo)+ ' T1-'+AppYear;
  if CheckIsCloud then
    PDFFullfileName := ChangeFilePath(FlName, Dir)
  else
  begin
    SaveDialog1.Title    := 'Save to PDF';
    SaveDialog1.InitialDir := Dir;
    SaveDialog1.Filter :=  'PDF|*.pdf';
    SaveDialog1.FileName :=FlName;
    SaveDialog1.DefaultExt := '.pdf';
    SaveDialog1.Options := [ofOverwritePrompt,ofPathMustExist];
    If not SaveDialog1.Execute then exit;
    PDFFullfileName := SaveDialog1.FileName;
  end;
  //20180503 Igor <<<
  PrintBtnClick(Sender);
  if MessageDlg('Return printout has been saved in "' + PDFFullfileName + '".'+#13+
                'Review it?', mtInformation, [mbYes, mbCancel], 0) = mrYes then
    OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
  exit;
 End;
*) //--------------------------------------

 //20161211 Igor<<<
(*
  OldPrinterName:=GetDefaultPrinterName;
  If IsPrinterInstalled('PDFFactory') then
  begin
   SetDefaultPrinter('PdfFactory');
  end
  Else
  begin
   ShowMessage('The PDFFactory printer Driver has not been installed');
   Application.CreateForm(TPdfFrm,PdfFrm);
   PdfFrm.ShowModal;
   PdfFrm.Free;
   Exit;
 end;

  SaveDialog1.Title    := 'Save to PDF';
  Dir:=optRec.Dir_ClientDocs+'\'+GetBusName(retNo);   //20110131
  ForceDirectories(Dir);
  SaveDialog1.InitialDir := Dir;
  SaveDialog1.Filter :=  'PDF|*.pdf';
  FlName:=GetLastName(retNo) + ','+ GetFirstName(retNo)+ ' T1-'+AppYear;
  SaveDialog1.FileName :=FlName;
  SaveDialog1.DefaultExt := '.pdf';
  SaveDialog1.Options := [ofOverwritePrompt,ofPathMustExist];

  If SaveDialog1.Execute then PDFFullfileName := SaveDialog1.FileName;
  AdjustFinePrintRegistrySettings(PDFFullfileName,2,0,999);

  PrintBtnClick(Sender);
  If PdfFullfileName>'' then ShowMessage('Return printout has been saved in'+Chr(13)+PDFFullfileName); //20110129
  //PrintCurrentReturn1Click(Sender);

  //-1 to stop collecting
  //Begin and End printer to force/flush collected pdfs to be saved
  //---------------------------------------------------------
  AdjustFinePrintRegistrySettings(PDFFullfileName,2,0,-1);
  Printer.BeginDoc;
  Printer.EndDoc;
  //---------------------------------------------------------
  AdjustFinePrintRegistrySettings('',0,1,0);
 // ShowMessage('Return printout has been saved in'+Chr(13)+PDFFullfileName); //20110129
  SetDefaultPrinter(OldPrinterName);
end;
*)

procedure TPrintReturnFrmT2_2027.PdfFactoryBtnClick(Sender: TObject);
begin
 ConnectToWeb('https://fineprint.com/pdf/');
end;

(*
procedure TPrintReturnFrm.EmailPrintoutBtnClick(Sender: TObject);
Var flName:String;
begin
  OldPrinterName:=GetDefaultPrinterName;
  If IsPrinterInstalled('PDFFactory') then
  begin
   SetDefaultPrinter('PdfFactory');
  end
  Else
  begin
   ShowMessage('The PDFFactory printer Driver has not been installed');
   Application.CreateForm(TPdfFrm,PdfFrm);
   PdfFrm.ShowModal;
   PdfFrm.Free;
   Exit;
 end;

  AdjustFinePrintRegistrySettings(PDFFullfileName,2,0,999);

  ShowMessage('Once completed, click SEND to EMAIL it');
  PrintBtnClick(Sender);

  //-1 to stop collecting
  //Begin and End printer to force/flush collected pdfs to be saved
  //---------------------------------------------------------
  AdjustFinePrintRegistrySettings(PDFFullfileName,2,0,-1);
  Printer.BeginDoc;
  Printer.EndDoc;
  //---------------------------------------------------------
  AdjustFinePrintRegistrySettings('',0,1,0);
  SetDefaultPrinter(OldPrinterName);
end;
*)


end.


