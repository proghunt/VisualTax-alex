program Authorize;

uses
  Forms,
  UAuthor in 'UAuthor.pas' {AuthorFrm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TAuthorFrm, AuthorFrm);
  Application.Run;
end.
