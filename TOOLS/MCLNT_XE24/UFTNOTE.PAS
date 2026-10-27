unit Uftnote;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls;

type
  TFootnote = class(TForm)
    SlipNameLbl: TLabel;
    BoxLbl: TLabel;
    TotLbl: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Footnote: TFootnote;

implementation

{$R *.DFM}

end.
