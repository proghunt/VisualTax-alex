unit fNewReturn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  vtMulti;

type
  TSelApp = class(TForm)
    lbApps: TListBox;
    buCreate: TButton;
    buCancel: TButton;
    procedure lbAppsClick(Sender: TObject);
    procedure lbAppsDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

function SelectApp: TApp;
function SelectNew: TApp;
function QueryApp(const ACaption, AOK: string): TApp;

implementation

{$R *.DFM}

var
  SelApp: TSelApp;

function QueryApp(const ACaption, AOK: string): TApp;
begin
  (* Select an AppId.
    Select the only one automatically
  *)
    //assert(CurrentApp <> nil, 'no CurrentApp');
  //this should go into program start
  case AppList.Count of
    0: Result := nil; //show error?
    1: Result := AppList.GetApp(0);
  else
    Application.CreateForm(TSelApp, SelApp);
    SelApp.Caption := ACaption; // 'Select Application';
    SelApp.buCreate.Caption := AOK; // 'OK';
    AppList.AssignTo(SelApp.lbApps.Items);
    SelApp.lbApps.ItemIndex := SelApp.lbApps.Items.IndexOfObject(CurrentApp);
    case SelApp.ShowModal of
      mrOk: TObject(Result) := SelApp.lbApps.Items.Objects[SelApp.lbApps.itemIndex];
    else
      Result := nil;
    end;
    SelApp.Release;
    //Change CurrentApp? - only on succ, NewReturn may be rejected!
  end;
end;

function SelectApp: TApp;
begin
  Result := QueryApp('Select Application...', 'OK');
end;

function SelectNew: TApp;
begin
  Result := QueryApp('New Return...', 'Create');
end;

procedure TSelApp.lbAppsClick(Sender: TObject);
begin
  buCreate.Enabled := lbApps.ItemIndex >= 0;
end;

procedure TSelApp.lbAppsDblClick(Sender: TObject);
begin
  //select and close on DblClick
  if lbApps.ItemIndex >= 0 then
    ModalResult := mrOk;
end;

procedure TSelApp.FormShow(Sender: TObject);
begin
  buCreate.Enabled := lbApps.ItemIndex >= 0;
end;

end.

