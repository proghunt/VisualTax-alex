unit vtDialogs;

// fake vtDialogs, if some function are absent, they should be copied from original vtDialogs

interface

uses
  Dialogs;

procedure ShowMessageInfo(const Msg: string);
procedure ShowMessageWarning(const Msg: string);
procedure ShowMessageError(const Msg: string);

implementation

procedure ShowMessageInfo(const Msg: string);
begin
  MessageDlg(Msg, mtInformation, [mbOk], 0);
end;

procedure ShowMessageWarning(const Msg: string);
begin
  MessageDlg(Msg, mtWarning, [mbOk], 0);
end;

procedure ShowMessageError(const Msg: string);
begin
  MessageDlg(Msg, mtError, [mbOk], 0);
end;

end.
