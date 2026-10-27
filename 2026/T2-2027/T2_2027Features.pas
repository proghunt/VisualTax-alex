unit T2_2027Features;

interface
uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  StdCtrls,Dialogs,DBctrls,ExtCtrls;

Function IsDataDirectoryGood(Dir:String):Boolean;

implementation

uses vtMulti,T2_2027Declare,T2_2027TrimStr,T2_2027Main,vtTrimStr,vtShared,vtCommon; //20190211 Igor

Function IsDataDirectoryGood(Dir:String):Boolean;
begin
  Result:=true;
  Exit; //20191015 Igor
  If (LicenseLevel in anyLimited) and not CheckIsCloud(true) then //20190211 Igor
  begin
    //20160718 Igor >>>
    //If (UpperCase(Dir) = LimitedVersionDir) then
    If not sameText(Dir, LimitedVersionDir) then
    begin
    //20160718 Igor <<<
       result:=False;
       ShowMessage('In the Limited version of the program'+Chr(13)+
                   'the current and default data directory must be '+LimitedVersionDir);
       //exit;
    end;
  end;
end;

end.
