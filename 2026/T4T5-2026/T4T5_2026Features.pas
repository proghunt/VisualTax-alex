unit T4T5_2026Features;

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

uses T4T5_2026,T4T5_2026Main,T4T5_2026Declare,T4T5_2026TrimStr,vtTrimStr,vtShared;

Procedure SelectFeatures;
Var gap:Longint;
Begin
 {Main Menu}
 {Efile, EFile-online}
 With MainFormT4T5 do
 begin
   ZoomStr:=IntToStr(OptRec.FormZoom)+'%'; //20180122 Igor
   ShowMostRecentReturns; //20170112 Igor
 end; {with}
end;

Function IsDataDirectoryGood(Dir:String):Boolean;
begin
 Result:=true;
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
