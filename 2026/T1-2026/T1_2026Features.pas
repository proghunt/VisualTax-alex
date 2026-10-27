unit T1_2026Features;
//updated 07-18

interface
uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  StdCtrls,Dialogs,DBctrls,ExtCtrls;

//Procedure SelectFeatures;
Function IsDataDirectoryGood(Dir:String):Boolean;

implementation

uses vtMulti,T1_2026,T1_2026Main,T1_2026Declare,T1_2026TrimStr,vtTrimStr,
  vtShared;

Function IsDataDirectoryGood(Dir:String):Boolean;
begin
 Result:=true;

 If (LicenseLevel in anyLimited)
// and (UpperCase(Dir) <> LimitedVersionDir) then //20160718 Igor
 and not SameText(UpperCase(Dir),LimitedVersionDir) then //20160718 Igor   //20170210
 begin
  result:=False;
  ShowMessage('In the T1 Limited version'
  +Chr(13)+'the current and default data directory must be '+LimitedVersionDir);
  exit;
 end;

 If (IsHomeUse)
// and (UpperCase(Dir) <> LimitedVersionDir) then //20160718 Igor
 and not SameText(UpperCase(Dir), LimitedVersionDir) then   //20170210
 begin
  result:=False;
  ShowMessage('In NetFile version'
  +Chr(13)+'the current and default data directory must be '+LimitedVersionDir);
  exit;
 end;


 If (LicenseLevel = llStd)
 then
 begin
  If  (UpperCase(LeftStr(Dir,1)) <> 'C')
  and (UpperCase(LeftStr(Dir,1)) <> 'D')
  and (UpperCase(LeftStr(Dir,1)) <> 'A')
  and (UpperCase(LeftStr(Dir,1)) <> 'B')
  then
  begin
   result:=False;
   ShowMessage('In T1 Standard, the current and default drive'
   +Chr(13)+'must be C, D, A or B');
  end;
 end;
end;

end.
