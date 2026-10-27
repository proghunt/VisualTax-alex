unit fSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls;

type
  TSplash = class(TForm)
    Pages: TPageControl;
    procedure Configure(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PagesChange(Sender: TObject);
    procedure PagesChanging(Sender: TObject; var AllowChange: Boolean); //20160519 Igor
  private
    PrevActivePageIndex: Integer; //20160519 Igor
    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND; //20180201 Igor
  public
    procedure SetActiveAppPage(AAppName: String); //20160323 Igor
    procedure UpdatePosition; //20180201 Igor

  end;

var
  Splash: TSplash;

implementation

{$R *.DFM}

uses vtMulti, vtMain
   , fVTnoSplash, vtCommon; // 20151030 Igor

procedure TSplash.Configure(Sender: TObject);
var
  i: integer;
  app: TApp;
  pnl: TControl;
  page: TTabSheet;
  MaxX,MinX: Integer; //20160209 Igor
begin
  //Pages.Pages.clear;
  if not Assigned(Self) then exit; //20160222 Igor

  for i := Pages.PageCount - 1 downto 0 do
  Begin
    if Pages.Pages[i].ControlCount > 0 then
      Pages.Pages[i].Controls[0].Parent := TForm(Pages.Pages[i].Controls[0].Owner); //20160222 Igor
    Pages.Pages[i].Free;
  End;
  Pages.Images := MainForm.AppImages;
  while vtnosplash.TabControl1.Tabs.Count > 1 do //20160209 Igor
    vtnosplash.TabControl1.Tabs.Delete(vtnosplash.TabControl1.Tabs.Count-1);//20160209 Igor

  for i := 0 to AppList.Count - 1 do
  begin
    app := AppList.GetApp(i);
    if assigned(app) and (app.LicenseLevel > llNone) and not App.Disabled then //20160526 Igor
    begin
      pnl := app.GetSplash;
      if pnl = nil then
        continue;
      page := TTabSheet.Create(Pages);
      page.PageControl := Pages;
      page.Align := alClient;
      page.Caption := app.AppId;
      page.Tag := i;
      page.ImageIndex := ord(app.AppIdx);
      //page.ImageIndex ...
      pnl.Parent := page;
      pnl.Align := alClient;
      vtnosplash.TabControl1.Tag := ord(app.AppIdx); //20160209 Igor
      vtnosplash.TabControl1.Tabs.Add(app.AppId);//20160209 Igor
    end;
  end;
  //20160519 Igor >>>
  //Last year
  page := TTabSheet.Create(Pages);
  page.PageControl := Pages;
  page.Align := alClient;
  page.Caption := 'Prior Years';
  page.Tag := -1;
  page.ImageIndex := 0;
  //20160519 Igor <<<

//20160209 Igor >>>
  MaxX := 0;
  MinX := MaxInt;
  for I := 0 to vtnosplash.TabControl1.Tabs.Count - 1 do
  Begin
    if vtnosplash.TabControl1.TabRect(I).Left < MinX then
      MinX := vtnosplash.TabControl1.TabRect(I).Left;
    if vtnosplash.TabControl1.TabRect(I).Right > MaxX then
      MaxX := vtnosplash.TabControl1.TabRect(I).Right;
  End;
  vtnosplash.TabControl1.Width := MaxX - MinX;
//20160209 Igor <<<  
end;

procedure TSplash.FormShow(Sender: TObject);
begin
  if Pages.PageCount = 0 then
    Configure(Sender);
  PagesChange(nil); //20160209 Igor
  UpdatePosition; //20180201 Igor
end;

procedure TSplash.PagesChange(Sender: TObject);
var i:Integer;
begin
  if Pages.ActivePage.Tag <> -1 then //20160519 Igor
  Begin
    CurrentApp := AppList.GetApp(Pages.ActivePage.Tag);
    MainForm.GuiCommand(gcAppIdChanged);
//20161116 Igor >>>
//    {$IFNDEF VT2016}
//    // 20151030 Igor
//    for i:=0 to vtnosplash.TabControl1.Tabs.Count - 1 do
//      if Splash.Pages.Pages[Splash.Pages.ActivePageIndex].Caption = vtnosplash.TabControl1.Tabs[i] then
//      begin
//        if vtnosplash.TabControl1.TabIndex <> I then //20160316 Igor
//          vtnosplash.TabControl1.TabIndex:=i;
//        break;
//      end;
//    //20160323 Igor
//    if GetCurrentRetNo > 0 then
//    Begin
//      if RetList[GetCurrentRetNo].MyApp <> CurrentApp then
//      Begin
//        for I := 1 to RetList.Count - 1 do
//        Begin
//          if Assigned(RetList[I]) AND
//            not RetList[I].Destroying AND
//            (RetList[I].MyApp = CurrentApp) then
//          Begin
//            RetList[I].MyChild.BringToFront;
//            Splash.BringToFront; //20160805 Igor
//            break;
//          End
//        End;
//      End;
//    End;
//    {$ENDIF}
//20161116 Igor <<<

  End
  else //prior Year
  Begin
    MainForm.GuiCommand(gcShowPriorYearList); //20160519 Igor
    Pages.ActivePageIndex := PrevActivePageIndex;
  End;
end;


procedure TSplash.PagesChanging(Sender: TObject; var AllowChange: Boolean); //20160519 Igor
begin
  PrevActivePageIndex := Pages.ActivePageIndex;
end;

procedure TSplash.SetActiveAppPage(AAppName: String); //20160323 Igor
var i:Integer;
begin
  for i:=0 to Pages.PageCount - 1 do
    if Pages.Pages[i].Caption = AAppName then
    begin
      if Pages.ActivePageIndex <> i then
      Begin
        Pages.ActivePageIndex:=i;
        if screen.ActiveForm = Self then //20161111 Igor
          PagesChange(Pages);
      End;
      break;
    end;
end;

procedure TSplash.UpdatePosition; //20180201 Igor
var nClientHeight: Integer;
    P: TPoint;
begin
  nClientHeight := vtnosplash.StatusBar1.Top - (vtnosplash.pnlToolBarParent.Top + vtnosplash.pnlToolBarParent.Height);
  // Splash height is 95% of area between toolbar and statusbar
  Height := Trunc(nClientHeight * 0.95);
  // splash width is 80% of vtnosplash.Width
  //Width := Trunc(vtnosplash.Width * 0.8); // not sure if it is needed
  P.X := vtnosplash.pnlToolBarParent.Left;
  P.Y := vtnosplash.pnlToolBarParent.Top + vtnosplash.pnlToolBarParent.Height;
  P := vtnosplash.ClientToScreen(P);
  Top := P.Y + (nClientHeight - Height) div 2;
  Left := P.X + (vtnosplash.Width - Width) div 2;
end;

procedure TSplash.WMSysCommand(var Message: TMessage); //20180201 Igor
begin
  if Message.WParam = SC_MINIMIZE then
    ShowMessage('Do not minimize this window. You can drag it to another spot if you want.'+
                Chr(13)+' '+Chr(13)+
                'You can always click any item you need from the Main window behind it')
  else
    inherited;
end;

end.

