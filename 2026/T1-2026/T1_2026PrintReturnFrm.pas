unit T1_2026PrintReturnFrm;

interface

uses
  Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,CheckLst,ExtCtrls,FileCtrl,vtLabel,vtShape, System.IOUtils,//20171031 igor
  vtVirtualTaxOffice, vtCourier;  //20210426 Igor

 Type
  TFrmToPrint = Record
   FName       : String[15];
   FDescr      : String[22];
   Seq         : String[3];
   Copies      : String[2];

 end;

type
  TPrintReturnFrmT1_2026 = class(TForm)
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
    SaveDialog1: TSaveDialog;
    Label2: TLabel;
    PdfFactoryBtn: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    FlagAsPrintedBox: TCheckBox;
    Label7: TLabel;
    CloseAfterPrintBox: TCheckBox;
    Label8: TLabel;
    Label11: TLabel;
    chbAutoSaveToMobileDB: TCheckBox;
    Label9: TLabel;
    BitBtn1: TBitBtn;
    Label10: TLabel;
    Label12: TLabel;
    btnvtCourier: TBitBtn;   //201703010 Igor
    procedure CancelBtnClick(Sender: TObject);
    procedure SelectPrintSetGroupClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure SelectFormsGroupClick(Sender: TObject);
    procedure PrintIt(RetNo:integer;FormsToPrint:TstringList);
    Procedure PopulateFrmToPrintRec(PrintItem:String);
    procedure SavePdfBtnClick(Sender: TObject);
    procedure PdfFactoryBtnClick(Sender: TObject);
    procedure ReadMoreBtnClick(Sender: TObject);
    Procedure GetCRASetFormsToPrint(RetNo:Integer;Var FormsToPrint:TStringList); //(Sender:TObject);
    Procedure PrintFilingCopyInBatch(DataDir:String;FlName:String;RetNo:Integer;FormsToPrint:TStringList);
    procedure CheckListBox1DragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure CheckListBox1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure CheckListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnvtCourierClick(Sender: TObject); //20210426 Igor


  private
    { Private declarations }
    //20210426 Igor >>>
    FTaxPayerCyberId: string;
    FEmail: string;
    procedure InitTaxPayer;
    //20210426 Igor <<<
  public
    { Public declarations }
  end;

var
  PrintReturnFrm: TPrintReturnFrmT1_2026;
  RetNo:Integer;
  i,j: integer; FormsToPrint :TstringList;
  Copies : string[1];
  Template :string[30];
  SelectedSet:String;
  s:String[1];
  FrmToPrint:TFrmToPrint;
  FlagAsPrinted: Boolean;
  OldPrinterName,PDFFullfileName:String; Dir:String;DlName:String;
implementation

{$DEFINE SYNPDF}

uses vtMulti,vtCommon,vtDialogs,fProgres,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026T1Rtns,T1_2026common,Printers,T1_2026Calc,T1_2026Print,T1_2026PdfFrm,
  T1_2026Common2,T1_2026Main,T1_2026ChildWinNew,vtTrimStr,vtShared,
  DateUtils
  ,vtPDFPrinter
  ,vtFillDBMain  //20170310 Igor
  ; //20160905 igor
{$R *.DFM}

procedure TPrintReturnFrmT1_2026.BitBtn1Click(Sender: TObject);
begin
 MainFormT1.actCopyClientsFoldersExecute(Sender); //20200516
end;

procedure TPrintReturnFrmT1_2026.btnvtCourierClick(Sender: TObject);
var FFiles: TArray<string>;
begin
  if PDFFullfileName.IsEmpty then
  Begin
    ShowMessage('You need to create pdf');
    Exit;
  end;

  if Not FileExists(PDFFullfileName) then
  Begin
    ShowMessage('File ' + PDFFullfileName + ' does not exist');
    Exit;
  end;

  SetLength(FFiles, 1);
  FFiles[0] := PDFFullfileName;

  if VirtualTaxOfficeInfo.AccountType = vtoOffice then
  begin
    InitTaxPayer;
    if FTaxPayerCyberId.IsEmpty then Exit;
    RunCourier(FTaxPayerCyberId, FFiles);
  end
  else
    RunCourier(VirtualTaxOfficeInfo.CyberId, FFiles);
end;

procedure TPrintReturnFrmT1_2026.CancelBtnClick(Sender: TObject);
begin
PrintingFilingCopy:=False;  //20160120
Close;
end;


procedure TPrintReturnFrmT1_2026.SelectPrintSetGroupClick(Sender: TObject);
Var TempList:TStringList;
begin
 PrintingFilingCopy:=False; //20160120
 FormsToPrint := TstringList.Create;
 If SlipsAvailable(RetNo) then Ret[RetNo].FrmHasData[GetFormNo('T4SUM#1')] := True;
 CheckListBox1.Items.Clear;
 Case SelectPrintSetGroup.itemIndex of
  {
  0: begin
      If UpperCase(InputBox('Enter password', 'PSW', 'Under review by CRA Certification')) <> 'N/A' then exit;
     end;
  //ShowMessage('Filing copy is currently under review by CRA for Certification purposes.');Exit;end;   //20240131
  }
  0:   begin
       //20250406
        {
        //20250312
        if VL(FetchElm(RetNo,'S3',339))<>0  then //20250312 gains or losses)
        begin
         ShowMessage('Return has capital dispositions. CRA may not accept it now.'); //20250401
         If UpperCase(InputBox('Enter Password', 'PSW', '')) <> 'N/A' then exit; //20260401Exit;
        end;
        }
        //20250313
        {
        if IsNonResident(RetNo) then //20250312 gains or losses)
        begin
         ShowMessage('This is a Non-Resident return. CRA may not accept it for now.');
         If UpperCase(InputBox('Enter Password', 'PSW', '')) <> 'N/A' then exit; //20260401
        end;
        }
        SelectedSet := 'CRA';
        PrintingFilingCopy:=True;
       end;   //20240131
  1:   SelectedSet := 'Client';
  2:   SelectedSet := 'Preparer';
  3:   SelectedSet := 'C+P (Client and Preparer)';
  4:   SelectedSet := 'All (CRA, Client and Preparer)';
  5:   SelectedSet := 'Other 1';
  6:   SelectedSet := 'Other 2';
  7:   SelectedSet := 'Other 3';
  //20200516
  8:   SelectedSet := 'Signature Forms';
  9:  SelectedSet := 'All Used Forms';
 end;

 FormsToPrint.Clear;
 CheckListBox1.Items.Clear;
  //For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=False;

 CheckListBox1.Refresh;

 If ((UpperCase(LeftStr(SelectedSet,8)) <> 'ALL (CRA')  //20200516
 and (UpperCase(LeftStr(SelectedSet,3)) <> 'C+P')) then
 Begin
  If SelectedSet = 'CRA' then            Template := 'CRASET.D'
  else if SelectedSet = 'Client'    then Template := 'CLINTSET.D'
  else if SelectedSet = 'Preparer'  then Template := 'PREPSET.D'
  else if SelectedSet = 'Other 1'   then Template := 'OTH1SET.D'
  else if SelectedSet = 'Other 2'   then Template := 'OTH2SET.D'
  else if SelectedSet = 'Other 3'   then Template := 'OTH3SET.D'
  else if SelectedSet = 'Signature Forms' then Template := 'ESIGNSET.D'
  else if SelectedSet = 'All Used Forms' then Template := 'ALLFORMSSET.D';
  {
  Begin
   Template := 'AllFormsSet.D';
   Begin
    FormsToPrint.Clear;
    for i := 0 to (FList.count - 1) do
    begin
      FRec := FList.Items[i];
      If Ret[RetNo].FrmHasData[FRec.FormNo] then
      Begin
        //if FRec.FormName<>'CUSTINV' then  //should not be in the flist
          FormsToPrint.Add('1'+FRec.FormName + FRec.FormInst);
      End;
    End; //i
  End;
  }
// End;

  FormsToPrint.Sorted :=False;

  If Template='CRASET.D' then
    GetCraSetFormsToPrint(RetNo,FormsToPrint)
  else
    GetFormsToPrint(RetNo,Template,FormsToPrint);


  ResortFormsToPrint(FormsToPrint);
  If FormsToPrint.Count =0 then
    begin
    ShowTimedMsg('Selected template has no forms for printing',1600);
    FormsToPrint.Free;
    exit;
  end;
 End
 Else  //C+P
 If LeftStr(SelectedSet,3) = 'C+P' then
 begin
   //client
   Template := 'CLINTSET.D';
   FormsToPrint.Clear;
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

 else if UpperCase(LeftStr(SelectedSet,8)) = 'ALL (CRA' then  //20200516
 begin
   FormsToPrint.Clear;
   CheckListBox1.Items.Clear;
   //cra
   Template := 'CRASET.D';
   TempList := TstringList.Create;
   TempList.Sorted :=False;
  // FormsToPrint.Clear;
   //FormsToPrint.Sorted :=False;
   GetCRASetFormsToPrint(RetNo,TempList);  // GetCRASetFormsToPrint(RetNo,FormsToPrint);
   TempList.Add('  -----------------------------------------');
   ResortFormsToPrint(TempList);
   For i:=0 to TempList.count-1 do FormsToPrint.Add(TempList[i]);
   TempList.Free;
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
   {
   If FormsToPrint.Count =0 then   //20200516
   begin
    ShowTimedMsg('Selected template has no forms for printing',1600);
    FormsToPrint.Free;
    exit;
   end;
   }
 end;
 {
 Else If Template = 'AllFormsSet.D' then
 Begin
    FormsToPrint.Clear;
    for i := 0 to (FList.count - 1) do
    begin
     FRec := FList.Items[i];
     If Ret[RetNo].FrmHasData[FRec.FormNo] then
     Begin
       //if FRec.FormName<>'CUSTINV' then  //should not be in the flist
         FormsToPrint.Add('1'+FRec.FormName + FRec.FormInst);
     End;
   end;
 End;
 }
 If FormsToPrint.Count =0 then
   begin
    ShowTimedMsg('Selected template has no forms for printing',1600);
    FormsToPrint.Free;
    exit;
 end;

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


procedure TPrintReturnFrmT1_2026.FormCreate(Sender: TObject);
begin
 PrintingCondensed:=false;  //20200129
 RetNo:=GetCurrentRetNo;
 If FileExists(AppDir+'\'+'PrintSeq.txt') = false then  //20110207
 Begin
  ShowMessage('Print Sequence has not been defined. See Configure -> Print Sequence -> Click Save/Apply');        //20160320
  Exit;
 end;

 FlagAsPrintedBox.Checked:=True;
 FlagAsPrinted:=FlagAsPrintedBox.Checked;
 CloseAfterPrintBox.Checked:=False; //True;  //20200516

 If RetNo=0 then
 Begin
  ShowMessage('Please Open a tax return first');
  Exit;
 End;
 FastPrint:= True;
 SelectPrintSetGroup.ItemIndex:=0;
end;

procedure TPrintReturnFrmT1_2026.SelectFormsGroupClick(Sender: TObject);
begin
 If SelectFormsGroup.itemIndex =0 then For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=True;
 If SelectFormsGroup.itemIndex =1 then For i:=0 to CheckListBox1.Items.count-1 do CheckListBox1.Checked[i]:=False;
 CheckListBox1.Refresh;
end;

procedure SaveToPDFIt(ARetNo: Integer; AFormsToPrint: TStrings; AFileName: String);
var
  FName: String;
  FCopies: Integer;
  i, j: Integer;
  ConfigBarCodeIndicator: Boolean;
  PDF: TvtPDFPrinter;
begin
  PDF := TvtPDFPrinter.Create(AppT1_2026);
  try
    for i := 0 to (AFormsToPrint.Count - 1) do
    begin
      FName := Midstr(AFormsToPrint[i],5,10);
      FCopies := MyStrToInt(Midstr(AFormsToPrint[i],4,1));
      Calc(ARetNo,FName);

      For j := 1 to FCopies do
      begin
        If LeftStr(FName,3)='T1C' then          //jz//20260504 - lefttrim T1C because when NR province is added to Fname
        begin
          ConfigBarCodeIndicator:=OptRec.NoBarCode;  //20120115
          OptRec.NoBarCode:=False;
          PDF.PrintForm(ARetNo, SubstituteT1CForm(RetNo,'T1'), 1, T1_2026Print.AfterReadComponentForPrint,
            T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
            T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
          PDF.PrintForm(ARetNo, SubstituteT1CForm(RetNo,'T1'), 2, T1_2026Print.AfterReadComponentForPrint,
            T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
            T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
          PrintT1C(RetNo,'T1C_3', PDF);
          PDF.PrintForm(ARetNo, SubstituteT1CForm(RetNo,'T1'), 3, T1_2026Print.AfterReadComponentForPrint,
            T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
            T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
          OptRec.NoBarCode:=ConfigBarCodeIndicator;  //20120115
        end
        Else
          PDF.PrintForm(ARetNo, FName, 99, T1_2026Print.AfterReadComponentForPrint,
            T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
            T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
        If GetAddBlankPg(FName) then
          PDF.PrintForm(ARetNo, 'BLANKPG', 1, T1_2026Print.AfterReadComponentForPrint,
            T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
            T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
      end;
    end;
    if AFileName <> '' then
      PDF.SaveToFile(AFileName, false);
  finally
    PDF.free;
  end;
end;

procedure TPrintReturnFrmT1_2026.PrintBtnClick(Sender: TObject);
Var
  Prn_DateHBack:Boolean;  //20160121
begin
  If FormsToPrint.Count = 0 then
  begin
    ShowMessage('No Forms to print');
    Exit;
  End;

  If (SelectPrintSetGroup.ItemIndex = 0) and (IsMultJurisdiction(RetNo)) then  //20220429
  Begin
   //ShowMessage('The T2203(MJ) barcoded paper-filing is not released yet. It is currently under CRA review');
   //If UpperCase(InputBox('T2203 (MJ) barcoded paper filing is not released yet', 'PSW', '')) <> 'MJ' then exit; //20210220
  // Exit;
  End;

   //201412
  // ShowMessage('You must not print the CRA copy with the Draft version');
  // If UpperCase(InputBox('Printing not released yet', '', 'Full printing not released yet-Press Enter')) <> 'N/A' then exit;  //20180114

  //20230218
  If (SelectPrintSetGroup.ItemIndex = 0)
  Or (SelectPrintSetGroup.ItemIndex = 4)
  then
  Begin
   // ShowMessage('CRA Filing copy not available in this version of the program');
   // If UpperCase(InputBox('Press Enter', 'Press Enter', '')) <> 'N/A' then  exit; //20180113
  End;

  If (SelectPrintSetGroup.ItemIndex = 0) then PrintingCondensed:=True  else PrintingCondensed:=False; //20200129

  //20200601
  If (SelectPrintSetGroup.ItemIndex = 0)
  and (OptRec.PRN_HideSin=True) then
  Begin
   if MessageDlg('You cannot Hide the Sin when you Paper-File the return to CRA'
               +Chr(13)+'Exit and Click Configure->General Options->Printing'
               +Chr(13)+'and enter No to Hide Sin'
               +Chr(13)+' '
               +Chr(13)+'Click Cancel to exit, Or Yes if you are printing for other purposes',
               mtInformation, [mbYes, mbCancel], 0) = mrYes
            then
            //ok
            Else
            Exit;
  End;

  //20160121
  Prn_DateHBack := OptRec.Prn_DateH;
  If SelectPrintSetGroup.ItemIndex = 0 then
    OptRec.Prn_DateH := False;  //20160121 not allowed on filing copy


  FormsToPrint.clear;
  For i := 0 to CheckListBox1.Items.count - 1 do
  begin
    If CheckListBox1.Checked[i] then
    begin
      //reassemple in originl format sssCFFFFFFFFF
      FormstoPrint.add(MidStr(CheckListBox1.Items[i],65,3)  //seq
                      +MidStr(CheckListBox1.Items[i],68,1)  //fcopies
                      +AllTrim(MidStr(CheckListBox1.Items[i],1,12)));  //
     // ShowMessage(CheckListBox1.Items[i]); //20220226
    end;
  end;

  If (Sender = PrintBtn) then //20160905 Igor
  begin
    if Not PrintDialog1.Execute then
      Exit;
    Try
      FastPrint := True;
      NeedNewPage := False;
      //Printer.beginDoc; //20160721 Igor
      Screen.Cursor := crHourGlass; //20120131
      PrintIt(RetNo,FormsToPrint);
    Finally
      if printer.Printing then //20160905 Igor
        Printer.EndDoc;
      NeedNewPage := False; //20160721 Igor
    end;
  end
  else
  begin
    SaveToPDFIt(RetNo, FormsToPrint, PDFFullfileName);
  end;
  PrintingFilingCopy := False;    //20160320
  Screen.Cursor := crDefault;
  If SelectPrintSetGroup.ItemIndex=0 then
    OptRec.Prn_DateH := Prn_DateHBack; //20160121
  If CloseAfterPrintBox.checked then
    Close;  //20110226  //????

end;


procedure TPrintReturnFrmT1_2026.PrintIt(RetNo:integer;FormsToPrint:TstringList);
var i,j,FCopies:integer; FName,LastFormToPrint :string[12];
ConfigBarCodeIndicator:Boolean;
begin
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
   for i :=0 to (FormsToPrint.Count - 1) do
   begin
      Application.ProcessMessages;  {allows abort click on progrees screen }
      If AbortSw then
      begin
       Progress.Close;
       If Printer.Printing then
         Printer.Abort;
       break; //20160910 Igor
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

        //20110301
        if (i = FormsToPrint.Count - 1) and (j=FCopies) then     //when reaches last form to print set LastFormToPrint variable
          LastFormToPrint := Midstr(FormsToPrint[FormsToPrint.Count - 1],5,10)
        else
          LastFormToPrint := '';

        If LeftStr(FName,3)='T1C' then         //jz//20260504 - lefttrim T1C because when NR province is added to Fname
        begin
         ConfigBarCodeIndicator:=OptRec.NoBarCode;  //20120115
         OptRec.NoBarCode:=False;
         MainFormT1.StartPrintForm(Retno,SubstituteT1CForm(RetNo,'T1'),1);

         MainFormT1.StartPrintForm(Retno,SubstituteT1CForm(RetNo,'T1'),2);
         PrintT1C(RetNo,'T1C_3');
         MainFormT1.StartPrintForm(Retno,SubstituteT1CForm(RetNo,'T1'),3);

         OptRec.NoBarCode:=ConfigBarCodeIndicator;  //20120115

        end
        Else
         PrintForm(RetNo,FName,99,LastFormToPrint);
        If GetAddBlankPg(FName) then
          PrintForm(RetNo,'BLANKPG',1,'');
      end;
      Progress.Gauge1.Progress :=i+1;
      Progress.Gauge1.Refresh;
  end;
  if Printer.Printing then  //20160905 Igor
    Printer.EndDoc;         //20160905 Igor
   Progress.Close;
   If (FlagAsPrinted = True) and not AbortSw then   //20120127 //20160910 Igor
   begin
    Ret[RetNo].Frm[GetFormNo('STATUS')].Strings[4] := '03';
    Ret[RetNo].PrpStatus :='03';
    MainFormT1.UpdatePrintDate(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName);
   end;
  // Screen.Cursor := crDefault;  //20120131
end;

Procedure TPrintReturnFrmT1_2026.PopulateFrmToPrintRec(PrintItem:String);
Begin
     FrmToPrint.FName:=AllTrim(MidStr(PrintItem,5,20));
     FrmToPrint.FDescr:=GetFormAbbrevDescr(ExtractNonInstFormName(FrmToPrint.FName));  //20110124
     FrmToPrint.Seq:=LeftStr(PrintItem,3);
     FrmToPrint.Copies:=MidStr(PrintItem,4,1);
End;

(*
//20130425 experimental
procedure TPrintReturnFrm.SavePdfBtnClick(Sender: TObject);
Var flName:String;
begin
{
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
   If CloseAfterPrintBox.checked then Close;  //20110226
   Exit;
 end;
 }
 // RetNo:=GetCurrentRetNo;
  SaveDialog1.Title    := 'Save to PDF';
  Dir:=optRec.Dir_ClientDocs+'\'+GetLastName(retNo) + ','+ GetFirstName(retNo);
  ForceDirectories(Dir);
  SaveDialog1.InitialDir := Dir;
  SaveDialog1.Filter :=  'PDF|*.pdf';
  FlName:=GetLastName(retNo) + ','+ GetFirstName(retNo)+ ' T1-'+AppYear;
  SaveDialog1.FileName :=FlName;
  SaveDialog1.DefaultExt := '.pdf';
  SaveDialog1.Options := [ofOverwritePrompt,ofPathMustExist];

  If SaveDialog1.Execute then PDFFullfileName := SaveDialog1.FileName;

  AdjustFinePrintRegistrySettings(PDFFullfileName,2,0,999); //20130425

  PrintBtnClick(Sender);
  If PdfFullfileName>'' then ShowMessage('Return printout has been saved in'+Chr(13)+PDFFullfileName); //20110129
  //PrintCurrentReturn1Click(Sender);

  //-1 to stop collecting
  //Begin and End printer to force/flush collected pdfs to be saved
  //---------------------------------------------------------
//  AdjustFinePrintRegistrySettings(PDFFullfileName,2,0,-1); //20130425
  Printer.BeginDoc;
  Printer.EndDoc;
  //---------------------------------------------------------
  AdjustFinePrintRegistrySettings('',0,1,0);
 // ShowMessage('Return printout has been saved in'+Chr(13)+PDFFullfileName); //20110129
//  SetDefaultPrinter(OldPrinterName);   //20130425
end;
*)

procedure TPrintReturnFrmT1_2026.SavePdfBtnClick(Sender: TObject);
Var flName:String;
  FileNameSuffix:String;
  D: TDateTime; //20160910 igor
begin
  //20180503 Igor >>>
  Dir := TPath.Combine(optRec.Dir_ClientDocs, GetLastName(retNo) + ','+ GetFirstName(retNo));//20171031 igor
  ForceDirectories(Dir);
  case SelectPrintSetGroup.itemindex of  //20200506
   0: FileNameSuffix:='CRA Filing Copy';
   1: FileNameSuffix:='Client Copy';
   2: FileNameSuffix:='Preparer Copy';
   3: FileNameSuffix:='Client and Preparer copy';
   4: FileNameSuffix:='All CRA-Client-Preparer Copy';
   5: FileNameSuffix:='Other Print Set 1';
   6: FileNameSuffix:='Other Print Set 2';
   7: FileNameSuffix:='Other Print Set 3';
   8: FileNameSuffix:='Signature Forms';
   9: FileNameSuffix:='All Used Forms';
  end;

  FlName:=GetLastName(retNo) + ','+ GetFirstName(retNo)+' T1-'+AppYear+' ('+FileNameSuffix+')'; //' T1-'+AppYear;  //20200506

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
    If not SaveDialog1.Execute then
      exit;
    PDFFullfileName := SaveDialog1.FileName;
  end;
  //20180503 Igor <<<
  PrintBtnClick(Sender);
  //20170310 Igor >>>
  if chbAutoSaveToMobileDB.Checked then
    SilentAddFile(AppT1_2026, RetList[GetCurrentRetNo].SourceFlName, PDFFullfileName);
  //20170310 Igor <<<

  if MessageDlg('Return printout has been saved in "' + PDFFullfileName + '".'+#13+
                'Review it?', mtInformation, [mbYes, mbCancel], 0) = mrYes then
    OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
  exit;
  //  STOPS HERE?



  //20160912 CON
  Showmessage('SaveToPrd function is currently unavailable'
  +Chr(13)+'Use normal print, select the PdfFactory print driver'
  +Chr(13)+'Enter a file path and Click the PdfFactory Save button');

  OldPrinterName:=GetDefaultPrinterName;
  If IsPrinterInstalled('PDFFactory') then
  begin
   SetDefaultPrinter('PdfFactory');
  end
  Else
  begin
   ShowMessage('The PDFFactory printer Driver has not been installed');
   ExecuteForm(TPDFFrmT1_2026);
   If CloseAfterPrintBox.checked then Close;  //20110226
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

end;      //20200519  moved above

procedure TPrintReturnFrmT1_2026.PdfFactoryBtnClick(Sender: TObject);
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


procedure TPrintReturnFrmT1_2026.ReadMoreBtnClick(Sender: TObject);
begin
 ConnectToWeb('www.visualtax.com/Configure.asp');
end;


//20190211
Procedure TPrintReturnFrmT1_2026.GetCRASetFormsToPrint(RetNo:Integer;Var FormsToPrint:TStringList); //(Sender:TObject);
  Var TempList:TStringList;
    i,j:Integer; sSeq:String; PrintIt:Boolean;
    nSeq:string; //nSeq:Integer;
    s:String; //20240515
begin
  nSeq:='1';
  sSeq:=addLeadingZeros(nSeq,3); //sSeq:=addLeadingZeros(IntToStr(nSeq),3);
  TempList:=TStringList.Create;
  TempList.Add(Sseq+'1'+SubstituteT1CForm(RetNo,'T1C'));
  //Inc(nSeq);
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   {//Not useful
   if (Frec.FormName = 'MB428A') and (IsMultJurisdiction(RetNo)=True) then //20240515
   begin
    Frec.FormName:='MBMJA';
    Frec.FormNo:=GetFormNo(Frec.FormName);
   end;
   }

   PrintIt:=Ret[RetNo].FrmHasData[Frec.FormNo];
   If (Frec.FormName = 'T1013') and (FetchElmFNo(RetNo,Frec.FormNo,26)='') then PrintIt:=False; //20120209
   If (Frec.FormName = 'RC381') and (IncludeRc381InT1cPrintedForms(RetNo)=False) then PrintIt:=False;   //20170204
   If Frec.AddInT1C then
   Begin
    If PrintIt then
      begin
       nSeq := GetPrintSequence(Frec.FormName); //Frec.PrnSeq; //??is blank? //Inc(nSeq); //??doenst do anything?
       sSeq:=addLeadingZeros(nSeq,3); //sSeq:=addLeadingZeros(IntToStr(nSeq),3);
       s:=Frec.FormName; //20240515
       if (Frec.FormName='MB428A') and (isMultJurisdiction(RetNo)=True) then s:='MBMJA'; //20240515 Atach the MJ instead
       TempList.Add(sSeq+'1'+S+Frec.FormInst);
       //TempList.Add(sSeq+'1'+Frec.FormName+Frec.FormInst);
      end;
   end;
  end; //i

  FormsToPrint.Clear;
  For j:=0 to TempList.Count-1 do FormsToPrint.Add(TempList[j]);
  TempList.Free;
end;


procedure TPrintReturnFrmT1_2026.InitTaxPayer;
var FRetNo: integer;
begin
  FRetNo := GetCurrentRetNo;
  If FRetNo = 0 then
  begin
    ShowMessage('Open return first');
    exit;
  end;
  FEmail := FetchElm(FRetNo,'INFO', 140);
  if FEmail.IsEmpty then
  begin
    ShowMessage('Please, enter email first in INFO form');
    exit;
  end;
  FTaxPayerCyberId := VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(FEmail);
end;

(* 20190211
Procedure TPrintReturnFrmT1_2026.GetCRASetFormsToPrint(RetNo:Integer;Var FormsToPrint:TStringList); //(Sender:TObject);
Var TempList:TStringList;
Var i,j:Integer; sSeq:String; nSeq:Integer; PrintIt:Boolean;
begin
  nSeq:=1;sSeq:=addLeadingZeros(IntToStr(nSeq),3);
  TempList:=TStringList.Create;
  TempList.Add(Sseq+'1'+SubstituteT1CForm(RetNo,'T1C'));
  Inc(nSeq);
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   PrintIt:=Ret[RetNo].FrmHasData[Frec.FormNo];
   If (Frec.FormName = 'T1013') and (FetchElmFNo(RetNo,Frec.FormNo,26)='') then PrintIt:=False;   //20120209
   If (Frec.FormName = 'RC381') and (IncludeRc381InT1cPrintedForms(RetNo)=False) then PrintIt:=False;   //20170204
   If Frec.AddInT1C then
   Begin
    If PrintIt then
      begin
       Inc(nSeq);
       sSeq:=addLeadingZeros(IntToStr(nSeq),3);
       TempList.Add(sSeq+'1'+Frec.FormName+Frec.FormInst);
      end;
   end;
  end; //i

  FormsToPrint.Clear;
  For j:=0 to TempList.Count-1 do FormsToPrint.Add(TempList[j]);
  TempList.Free;
end;
*)
Procedure TPrintReturnFrmT1_2026.PrintFilingCopyInBatch(DataDir:String;FlName:String;RetNo:Integer;FormsToPrint:TStringList);
Var FNo:Integer;
Begin
 FormsToPrint.Clear;
 FormsToPrint.Sorted:=False;
 GetFormsToPrint(RetNo,'CRASET.d',FormsToPrint);
 //PrintReturnFrm.
 GetCraSetFormsToPrint(RetNo,FormsToPrint);
 ResortFormsToPrint(FormsToPrint);
 PrintReturnFrm.PopulateFrmToPrintRec(FormsToPrint[i]);

 FastPrint:=True;
 //Printer.beginDoc; //20160721 Igor
 NeedNewPage := False; //20160721 Igor
 FlagAsPrinted:= True;
 try
   PrintReturnFrm.PrintIt(RetNo,FormsToPrint);
 finally
   if Printer.Printing then //20170127 Igor
     Printer.EndDoc;
   NeedNewPage := False;//20160721 Igor
 end;

 //update the status
 FNo := GetFormNo('STATUS');
 Ret[RetNo].Frm[Fno].Strings[4] := '03';
 Ret[RetNo].Frm[Fno].Strings[8] := User.UserName; //20170112 Igor
 Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
 Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);
 SaveReturn(RetNo,DataDir,FlName,True,True);   //april 16 2005
 UpdateClientsTable(RetNo,DataDir,FlName);
 RemoveReturnFromMemory(RetNo);  //20120126
end;

procedure TPrintReturnFrmT1_2026.CheckListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
 if (Sender is TForm) and (Source is TCheckListBox) then
  begin
//    CheckListBox1.items.add((Source as TcheckListBox).Items.Text);
  end;
end;

procedure TPrintReturnFrmT1_2026.CheckListBox1EndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  CheckListBox1.Refresh;
end;

procedure TPrintReturnFrmT1_2026.CheckListBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
 Accept:=True;
end;


end.



