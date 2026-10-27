unit FP_2027features;

interface
uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  StdCtrls,Dialogs,DBctrls,ExtCtrls;

//Procedure SelectFeatures; - NOP, moved into main
Function IsDataDirectoryGood(Dir:String):Boolean;

implementation

uses vtMulti,FP_2027,FP_2027Common,FP_2027Declare,FP_2027TrimStr,FP_2027Main,
  vtTrimStr;

Procedure SelectFeatures;
Var gap:Longint;
Begin
 {Main Menu}
 (*
 With MainForm do
 begin
  BackOffice1.Enabled:=False;
  If (LicenseLevel = 'FP Agent') or (LicenseLevel = 'FP Dealer')
  then
  begin
    BackOffice1.Enabled:=True;
    If (LicenseLevel = 'FP Dealer')
    then
     Dealer1.Enabled := True
    else
     Dealer1.Enabled := False;
  end;
 *)

 (*
  Efile.Enabled:=True;
  EFileOnline.Enabled:=True;
  EfileBox.Enabled:=True;

  {netfile for individuals}
  If (LicenseLevel <> 'T1 NetFile') then
   NetFileForIndividuals1.Enabled:=False;

  If (LicenseLevel= 'T1 PaperFile') then
  begin
   Efile.Visible:=False;
   EFileOnline.Visible:=False;
   EfileBox.Enabled:=False;
  end;

  If (LicenseLevel= 'T1 Limited') then
  begin
   Efile.Visible:=False;
   EfileBox.Enabled:=False;
   NetFileForIndividuals1.Enabled:=False;
  end;

  If IsHomeUse then
  begin
   LicenseLevelLbl.Caption := 'Home use - Netfile Version';
   Efile.Visible := False;
   Preparer.Visible := False;
   NetFilePro.Visible := False;
   OpenByFileName1.Visible := False;
   FeeSchedule1.Visible := false;
   ClientLetter1.Visible := false;
   DataDictionary1.Visible := false;
   EFileBox.Visible := False;
   Gap := (MainForm.Width-(FileMgtBox.Width+NavigationBox.Width+CouplingBox.Width
                      +ReviewBox.Width+DeskTopBox.Width)) div 6;
   NavigationBox.Left := FileMgtBox.Left+FileMgtBox.Width + gap;
   CouplingBox.Left := NavigationBox.Left+navigationBox.Width + gap;
   ReviewBox.Left := CouplingBox.Left+CouplingBox.Width + gap;
   DeskTopBox.Left := ReviewBox.Left+ReviewBox.Width + gap;
  end;
 *)

 (*
 {Open by file Name}
  If (LicenseLevel = 'T1 NetFile')
  Or (LicenseLevel = 'T1 Limited') then
    OpenByFileName1.Visible := False;

 {PlanNextYear}
  If (LicenseLevel = 'T1 NetFile')
  Or (LicenseLevel = 'T1 Limited')
  Or (LicenseLevel = 'T1 Standard') then
   PlanNextYear.Visible:=False;

 {Data Base Analyser/statistics/mailing labels/return balances}
  If (LicenseLevel = 'T1 NetFile')
  Or (LicenseLevel = 'T1 Limited')
  Or (LicenseLevel = 'T1 Standard') then
  begin
    DataBaseAnalyser1.Visible := False;
    ClientStatistics1.Visible := False;
    MailingLabels1.Visible := False;
    PrintReturnBalances1.visible :=False;
  end;

  {Cash reports}
  If (LicenseLevel = 'T1 NetFile')
  Or (LicenseLevel = 'T1 Limited')
  Or (LicenseLevel = 'T1 Standard') then
    CashReports1.Visible := False;

  {multi office}
  If (LeftStr(LicenseLevel,8) <> 'T1 Multi')
  then
  begin
    CopyDailyCashReport1.Visible := False;
    SubmitDailyCashReport1.Visible := False;
    YTDCashReports1.Visible := False;
    UserSetUp1.Visible := False;
    YtdDirectorySetUp1.Visible := False;
    InvoiceAdjustments1.Visible := False;
  end;

 {Utilities}
  If (LicenseLevel = 'T1 NetFile')
  Or (LicenseLevel = 'T1 Limited')
  Or (LicenseLevel = 'T1 Standard') then
  begin
    CopyBackUp1.Visible := False;
    MergeDataBases1.Visible := False;
  end;
 end; {with}
 *)
end;

Function IsDataDirectoryGood(Dir:String):Boolean;
begin
  Result:=true;

  If (LicenseLevel = llLimited)  // 'FP Limited')
      and
      //(UpperCase(Dir) <> LimitedVersionDir) then //20160718 Igor
      not SameText(Dir, LimitedVersionDir) then //20160718 Igor
  begin
    result:=False;
    ShowMessage('In FP Limited version'+Chr(13)+
                'the current and default data directory must be '+LimitedVersionDir);
    exit;
  end;

  If (LicenseLevel = llStd) then // 'FP Standard')
  begin
    If  (UpperCase(LeftStr(Dir,1)) <> 'C')
    and (UpperCase(LeftStr(Dir,1)) <> 'D')
    and (UpperCase(LeftStr(Dir,1)) <> 'A')
    and (UpperCase(LeftStr(Dir,1)) <> 'B') then
    begin
      result:=False;
      ShowMessage('In FP Standard, the current and default drive'+Chr(13)+
                  'must be C, D, A or B');
    end;
  end;
end;

end.
