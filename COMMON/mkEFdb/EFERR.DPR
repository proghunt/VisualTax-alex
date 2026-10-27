program Eferr;

uses
  Forms,
  Efer in 'EFER.PAS' {eferrform};

{$R *.RES}

begin
  Application.CreateForm(Teferrform, eferrform);
  Application.Run;
end.
