unit T1_2026MobileUtils;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, Data.DB, uADCompClient, Vcl.StdCtrls;

type
  TMobileUtilsT1_2026 = class(TForm)
    btnGenerateDatabase: TButton;
    conn: TADConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MobileUtilsT1_2026: TMobileUtilsT1_2026;

implementation

{$R *.dfm}

end.
