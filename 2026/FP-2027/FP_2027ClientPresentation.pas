unit FP_2027ClientPresentation;

interface

uses SysUtils,Windows,Messages,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ComCtrls,ExtCtrls,Menus,ActnList,ToolWin,ImgList,ClipBrd,RichEdit,AppEvnts,
  Buttons,FileCtrl,//20150819 Igor QuickRpt,
  FP_2027RichForm,//wwriched,
  VCLTee.TeeProcs,VCLTee.TeEngine,VCLTee.Chart, vtRichmemobox,  //20150819 Igor

  rxRichEd; //20160819 Igor (Must be last)

type
  TClientPresentationFP_2027 = class(TForm)
    Panel2: TPanel;
    CancelBtn: TBitBtn;
    PrintBtn: TBitBtn;
    RetChartsBtn: TBitBtn;
    MainMenu1: TMainMenu;
    Panel1: TPanel;
    HeaderLbl: TLabel;
    ExecSumBtn: TPanel;
    ExecSumImgBtn: TImage;
    Label1: TLabel;
    RichEdit1: TvtRichMemo;
    procedure FormCreate(Sender: TObject);
    //Procedure ShowIt(LetterName:String);
    {procedure Preview(Var RichMemo:TRichEdit);}
    procedure CancelBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    Function GetPreviousLetter(LetterName:String):String;
    Function GetNextLetter(LetterName:String):String;
    //Procedure LoadLetterNames;
    //procedure PreviousBtnClick(Sender: TObject);
    //procedure NextBtnClick(Sender: TObject);
    procedure RetChartsBtnClick(Sender: TObject);
    //procedure PortfoliosBtnClick(Sender: TObject);
    //procedure ReviseBtnClick(Sender: TObject);
    //procedure ShowLetter(LetterName:String);
    //procedure EngagementLetter1Click(Sender: TObject);
    procedure ExecItemClick(Sender: TObject);
    {procedure ExecutiveSummary1Click(Sender: TObject);}
    procedure ExecSumBtnxClick(Sender: TObject);
    //procedure FPletter1Click(Sender: TObject);
    Procedure DisplayAnRtf(LetterName:String);
    procedure ExecSumBtnClick(Sender: TObject);
    procedure ExecSumImgBtnClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    FileName: string;
  public
    RetNo: integer;
  end;

var
  ClientPresentation: TClientPresentationFP_2027;
  KeyWLength : Byte;
  ReplaceString:string;
  ValidateLetterflag:boolean;
  TemplateDir, TempFile: String;
  LetterNames : TStringList;
//20150819  Igor Report : TQuickRep;

implementation

uses vtCommon,FP_2027,FP_2027TrimStr,FP_2027Declare,FP_2027PopList,
  FP_2027PortFolioReport,FP_2027main,vtTrimStr,vtShared;

{$R *.DFM}


procedure TClientPresentationFP_2027.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
 TemplateDir := AppDir;
 LetterName:= 'ExecSum.Rtf';
 DisplayAnRtf(LetterName);

end;

Procedure TClientPresentationFP_2027.DisplayAnRtf(LetterName:String);
Var i,j:integer; ErrorC : boolean; txt:Ansistring; //[255];
   AList: TstringList;
Begin
 LoadDataDict;
 If RetNo < 1 then exit;
 TempFile := AppDir+'\'+'Temp';
 AList := TstringList.Create;
 RichEdit1.Visible := False;
Try
 AList.LoadFromFile(AppDir+'\'+LetterName);
 For i:=0 to AList.count-1 do
 begin
  Txt:=AList[i];
  InterpretTextLine(Txt);    //modifies txt
  AList[i]:=Txt;
 end;
 ResolveConditions(AList);
 //!!! needs to be saved and then loded to richedit
 AList.SaveToFile(TempFile);
 RichEdit1.lines.Clear;
 RichEdit1.lines.LoadFromFile(TempFile);
 RichEdit1.Visible := True;
 except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
 AList.Free;
end;

(*
Procedure TClientPresentation.ShowIt(LetterName:String);
Var i,j:integer; ErrorC : boolean;txt:Ansistring; //[255];
   AList: TstringList;
Begin
 TempFileName := AppDir+'\'+'Temp';
 If RetNo < 1 then exit;

 AList := TstringList.Create;
 RichEdit1.Visible := False;
 RichEdit1.Lines.LoadFromFile(TemplateDir+'\'+LetterName);
 RichEdit1.Lines.SaveToFile(TempFileName);
 Memo1.Clear;
 Memo1.Lines.LoadFromFile(TempFileName);

 {Copy memo to AList}
 For i:=0 to Memo1.Lines.Count-1 do
    AList.Add(Memo1.Lines[i]);
 LoadDataDict;
 Memo1.Clear;
 For i :=0 to AList.Count-1 do {first pass:conditions stay in}
   begin
    txt :=AList[i];
    InterpretTextLine(txt);
    AList[i] :=txt;
   end;

  ResolveConditions(AList);
  For i :=0 to AList.Count-1 do
   Memo1.Lines.Add(AList[i]);

  Memo1.Lines.SaveToFile(TempFileName);
  RichEdit1.Clear;
  RichEdit1.Lines.LoadFromFile(TempFileName);
  RichEdit1.Visible := True;
  AList.Free;
end;
*)

procedure TClientPresentationFP_2027.CancelBtnClick(Sender: TObject);
begin
LetterNames.Free;
Close;
end;

procedure TClientPresentationFP_2027.PrintBtnClick(Sender: TObject);
begin
 Exit;
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Select';
 SomeList.Add('Engagement Letter');
 SomeList.Add('Covering FP Letter');
 SomeList.Add('Executive Summary');
 SomeList.Add('Detail Attachments');
 ExecuteForm(TPopListFP_2012);
 //SomeList.Free; //20160704 Igor
// If LeftStr(SelectedString,5) = 'Engag' then MainForm.FPEngagementLetter1Click(Sender);
 If LeftStr(SelectedString,5) = 'Cover' then;
//  MainForm.FPCoveringLetter1Click(Sender);
  //MainForm.PrintRichLetter('FPCover.ltr');
 If LeftStr(SelectedString,5) = 'Execu' then
//  MainForm.ExecutiveSummary1Click(Sender);
   //MainForm.PrintRichLetter('ExecSum.ltr');
// If LeftStr(SelectedString,5) = 'Detai' then  MainForm.PrintDetailAttachmentsClick(Sender);
   //MainForm.PrintRichLetter('Attach.ltr');
end;

(*
Procedure TShowRichForm.LoadLetterNames;
begin
 LetterNames := TStringList.Create;
 LetterNames.Add('Default_CurrentPosition.Ltr');
 LetterNames.Add('Default_GoalsObjectives.Ltr');
 LetterNames.Add('Default_Analysis.Ltr');
 LetterNames.Add('Default_ActionPlan.Ltr');
end;
*)

Function TClientPresentationFP_2027.GetPreviousLetter(LetterName:String):String;
Var i:Integer;
begin
 Result :=LetterName;
 For i :=0 to letterNames.Count-1 do
 begin
   If LetterNames[i] = LetterName then
   begin
    If i-1>-1 then
      begin result:=LetterNames[i-1];exit;end;
   end;
 end;
end;

Function TClientPresentationFP_2027.GetNextLetter(LetterName:String):String;
Var i:Integer;
begin
 Result :=LetterName;
 For i :=0 to letterNames.Count-1 do
 begin
   If LetterNames[i] = LetterName then
   begin
    If i+1 <= LetterNames.Count-1 then
      begin result:=LetterNames[i+1];exit;end;
   end;
 end;
end;

(*
procedure TShowRichForm.PreviousBtnClick(Sender: TObject);
begin
 LetterName := GetPreviousLetter(LetterName);
 ShowIt(LetterName);
end;

procedure TShowRichForm.NextBtnClick(Sender: TObject);
begin
 LetterName := GetNextLetter(LetterName);
 ShowIt(LetterName);
end;
*)

procedure TClientPresentationFP_2027.RetChartsBtnClick(Sender: TObject);
begin
// ExecuteForm(TProjectionCharts);
// ExecuteForm(TRetirementCharts);
end;



(*
procedure TClientPresentation.PortfoliosBtnClick(Sender: TObject);
Var i:Integer;AList:TStringList;
begin
 AList := TStringList.Create;
 SomeList := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := 'Select Porfolio';
 Client:=Ret[RetNo]^.ClientId;
 GetPortFolioNamesList(Ret[RetNo]^.ClientId,AList);
 for i :=0 to (AList.Count - 1) do SomeList.Add(AList[i]);

 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
 If SelectedString > '' then
 begin
   PortfolioNameToChart:=SelectedString;
   ClientNameToChart := ClientIdName;
   Application.CreateForm(TPortfolioReport,PortfolioReport);
   Report := PortfolioReport.QuickRep1;
   Report.Preview;
   PortfolioReport.Free;
 end;
 AList.Free;
end;
*)

(*
procedure TClientPresentation.ReviseBtnClick(Sender: TObject);
begin
 Screen.Cursor := crHourGlass;
 ExecuteForm(TRtfEditor);
 //ExecuteForm(TRichForm);
end;
*)

(*
procedure TClientPresentation.EngagementLetter1Click(Sender: TObject);
begin
 LetterName:='Engagement.ltr';
 DisplayAnRtf(LetterName);
 HeaderLbl.Caption := 'Engagement Letter (Engagement.ltr)';
end;
*)
procedure TClientPresentationFP_2027.ExecItemClick(Sender: TObject);
begin
LetterName:='ExecSum.ltr';
DisplayAnRtf(LetterName);
HeaderLbl.Caption := 'Executive Summary (ExecSum.ltr)';
end;

procedure TClientPresentationFP_2027.ExecSumBtnxClick(Sender: TObject);
begin
LetterName:= 'ExecSum.Rtf';
DisplayAnRtf(LetterName);
(*
LetterName:='ExecSum.ltr';
ShowLetter(LetterName);
HeaderLbl.Caption := 'Executive Summary (ExecSum.ltr)';
*)
end;

(*
procedure TClientPresentation.FPletter1Click(Sender: TObject);
begin
 LetterName:='FPCover.ltr';
 DisplayAnRtf(LetterName);
 HeaderLbl.Caption := 'FP covering client letter (FpCover.ltr)';
end;
*)
procedure TClientPresentationFP_2027.ExecSumBtnClick(Sender: TObject);
begin
ExecSumBtnxClick(Sender);
end;

procedure TClientPresentationFP_2027.ExecSumImgBtnClick(Sender: TObject);
begin
ExecSumBtnxClick(Sender);
end;

procedure TClientPresentationFP_2027.Label1Click(Sender: TObject);
begin
ExecSumBtnClick(Sender);
end;

end.
