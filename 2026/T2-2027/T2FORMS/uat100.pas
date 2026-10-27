unit uAT100;
interface
uses
    SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
    Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
    vtShape, Buttons, uFlagFrameAB;
type
TAT100 = class(TForm)
   VTEDIT19: TVTEDIT;
   VTEDIT18: TVTEDIT;
   VTEDIT17: TVTEDIT;
   VTEDIT16: TVTEDIT;
   VTEDIT15: TVTEDIT;
   VTEDIT14: TVTEDIT;
   VTEDIT13: TVTEDIT;
   VTEDIT12: TVTEDIT;
   VTEDIT11: TVTEDIT;
   VTEDIT10: TVTEDIT;
   VTEDIT9: TVTEDIT;
   VTEDIT8: TVTEDIT;
   VTEDIT7: TVTEDIT;
   VTEDIT6: TVTEDIT;
   VTEDIT5: TVTEDIT;
   VTEDIT4: TVTEDIT;
   VTEDIT3: TVTEDIT;
   VTEDIT2: TVTEDIT;
   VTEDIT1: TVTEDIT;
   vtShapePB1: TvtShape;
   VTEDIT101: TVTEDIT;
   vtShapePB2: TvtShape;
    vtShape1: TvtShape;
    vtShape2: TvtShape;
    vtAT1_1Label5: TvtLabel;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    FlagFrameAB1: TFlagFrameAB;
private
  { Private declarations }
public
  { Public declarations }
end;
var
AT100: TAT100;
implementation
{$R *.DFM}
end.
