program TDDGetData;

uses
  Forms,
//  VirtualUI_AutoRun,
  ABOUT in 'ABOUT.PAS' {AboutBox},
  Crypt2 in 'Crypt2.pas',
  JwaNtStatus in 'JediWinApi\Source\JwaNtStatus.pas',
  JwaWinBase in 'JediWinApi\Source\JwaWinBase.pas',
  JwaWinCrypt in 'JediWinApi\Source\JwaWinCrypt.pas',
  JwaWinDLLNames in 'JediWinApi\Source\JwaWinDLLNames.pas',
  JwaWinNT in 'JediWinApi\Source\JwaWinNT.pas',
  JwaWinType in 'JediWinApi\Source\JwaWinType.pas',
  UTDDMain in 'UTDDMain.PAS' {TDDMain},
  Reminder in 'Reminder.pas' {frmReminder}, //20170303 Igor
  vtShowMessageHTML in '..\vtBase\vtShowMessageHTML.pas' {fShowMessageHTML}; //20180220 Igor

{$R *.RES}

{$IFDEF WITH_MUTEX} //20170212 Igor
 var
  MutexHandle : THandle;
  //TddMutexName:PWideChar;  //20160222  CON  //20170212 Igor
{$ENDIF WITH_MUTEX} //20170212 Igor
begin
   //20160221 Igor >>>
 {$IFDEF WITH_MUTEX} //20170212 Igor
  MutexHandle := OpenMutex(MUTEX_ALL_ACCESS, false, TDDMutexName);
  if MutexHandle <> 0 then
  begin
    CloseHandle(MutexHandle);
    halt;
  end;
  MutexHandle := CreateMutex(nil, false, TDDMutexName);
 {$ENDIF WITH_MUTEX} //20170212 Igor
   //20160221 Igor <<<
  Application.Initialize;
 // Application.CreateForm(TAboutBox, AboutBox);   //it keeps asking for info
  Application.CreateForm(TTDDMain, TDDMain);
  Application.Run;
{$IFDEF WITH_MUTEX} //20170212 Igor
  ReleaseMutex(MutexHandle); //20160221 Igor
  CloseHandle(MutexHandle); //20160221 Igor
{$ENDIF WITH_MUTEX} //20170212 Igor
 end.

