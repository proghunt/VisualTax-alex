unit T3_2026Features;

interface
uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  StdCtrls,Dialogs,DBctrls,ExtCtrls;

Procedure SelectFeatures;
//20170901 Igor>>>
//{$IFDEF ReturnsLimit}
//Function ExceedsMaxReturnsAllowed:Boolean;
//{$ELSE}
//{$ENDIF}
//20170901 Igor<<<
Function IsDataDirectoryGood(Dir:String):Boolean;

implementation

uses T3_2026,T3_2026Main,T3_2026Declare,T3_2026TrimStr,vtTrimStr,vtShared,
  vtMulti; //20170803 Igor

Procedure SelectFeatures;
Var gap:Longint;
Begin
 {Main Menu}
 {Efile, EFile-online}
 With MainFormT3 do
 begin
   ZoomStr:=IntToStr(OptRec.FormZoom)+'%'; //20180118 Igor
   ShowMostRecentReturns; //20170112 Igor
 end; {with}
end;

Function IsDataDirectoryGood(Dir:String):Boolean;
//20170803 Igor>>>
begin
  Result:=true;
  If (LicenseLevel in anyLimited) then
  begin
    If not SamePath(Dir, LimitedVersionDir) then
    begin
       result:=False;
       ShowMessage('In the Limited version of the program'+Chr(13)+
                   'the current and default data directory must be '+LimitedVersionDir);
    end;
  end;
//20170803 Igor<<<
end;

//20170901 Igor>>>
//{$IFDEF ReturnsLimit}
//Function ExceedsMaxReturnsAllowed:Boolean;
//begin
//  Result := RetInMem > ReturnsLimit;
//  //Result:=false;
//end;
//{$ELSE}
//{$ENDIF}
//20170901 Igor<<<

end.
