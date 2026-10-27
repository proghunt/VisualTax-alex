unit UserAppSettingsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, Data.DB, uADCompDataSet,
  uADCompClient, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ValEdit,
  System.Rtti, System.TypInfo, Vcl.ImgList, Vcl.ComCtrls;

type
  TCheckEdit = function(const AAsk: Boolean = False): Boolean of Object;
  TFrameState = (fsInit, fsSetValue);
  TFrameStates = set of TFrameState;
  TOptionsAtom = record
    Name: String;
    Caption: String;
    CommonValue: TValue;
    PersonalValue: TValue;
    isOverloaded: Boolean;
  end;
  POptionsAtom = ^TOptionsAtom;

  TframeUserAppSettings = class(TFrame)
    qrySettings: TADQuery;
    lvValues: TListView;
    procedure lvValuesItemChecked(Sender: TObject; Item: TListItem);
    procedure lvValuesDblClick(Sender: TObject);
    procedure lvValuesCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lvValuesCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    FConnection: TADConnection;
    FUser: String;
    FApp: String;
    FCheckEdit: TCheckEdit;
    FrameState:TFrameStates;
    FChanged: Boolean;
    procedure InternalReload;
    procedure SetUser(const Value: String);
    procedure FillList;
    procedure ClearOptionsList;
    procedure EditOverrideValue(AItem: TListItem);
    procedure ClearOverrideValue(AItem: TListItem);
    { Private declarations }
  public
    { Public declarations }
    procedure Init(AConnection: TADConnection; AApp, AUser: String;
      ACheckEdit: TCheckEdit);
    function Save: Boolean;
    property User: String read FUser write SetUser;
    property Changed: Boolean read FChanged;
  end;

implementation

uses
  vtMulti, vtShared;

{$R *.dfm}

function StringToTValue(AValue: String; ATypeKind: TTypeKind): TValue;
var
  I: Integer;
  B: Boolean;
  C: Currency;
begin
  case ATypeKind of
    tkInteger:
      begin
        if not tryStrToInt(AValue, I) then
          I := 0;
        Result := TValue.From(I);
      end;
    tkChar:
      begin
        Result := TValue.From(AValue);
      end;
    tkEnumeration:
      begin
        if not TryStrToBool(AValue, B) then
          B := False;
        Result := TValue.From(B);
      end;
    tkFloat:
      begin
        if not TryStrToCurr(AValue, C) then
          I := 0;
        Result := TValue.From(C);
      end;
    tkString, tkUString:
      begin
        Result := TValue.From(AValue);
      end;
  end;
end;

{ TframeUserAppSettings }

procedure TframeUserAppSettings.ClearOptionsList;
var
  I: Integer;
begin
  for I := 0 to lvValues.Items.Count - 1 do
    if lvValues.Items.Item[I].Data <> nil then
      freeMem(POptionsAtom(lvValues.Items.Item[I].Data));
  lvValues.Items.Clear;
end;

procedure TframeUserAppSettings.ClearOverrideValue(AItem: TListItem);
begin
  FrameState := FrameState + [fsSetValue];
  try
    with POptionsAtom(AItem.Data)^ do
    begin
      isOverloaded := False; //20170130 Igor
      PersonalValue := TValue.Empty; //20170130 Igor
      AItem.SubItems[2] := PersonalValue.ToString; //20170130 Igor
      FChanged := True;//20170130 Igor
    end;
  finally
    FrameState := FrameState - [fsSetValue];
  end;
end;

procedure TframeUserAppSettings.EditOverrideValue(AItem: TListItem);
var
  V: string;
begin
  FrameState := FrameState + [fsSetValue];
  try
    with POptionsAtom(AItem.Data)^ do
    begin
      V := PersonalValue.ToString;
      if not InputQuery('Set override value.', Caption, V) then
        Exit;
      isOverloaded := True;
      PersonalValue := StringToTValue(V, CommonValue.TypeInfo.Kind);
      AItem.Checked := True;
      AItem.SubItems[2] := PersonalValue.ToString;
      FChanged := True;
    end;
  finally
    FrameState := FrameState - [fsSetValue];
  end;
end;

procedure TframeUserAppSettings.Init(AConnection: TADConnection; AApp,
  AUser: String; ACheckEdit: TCheckEdit);
begin
  FConnection := AConnection;
  qrySettings.Connection := FConnection;
  FApp := AApp;
  FUser := AUser;
  FCheckEdit := ACheckEdit;
  InternalReload;
  FChanged := False;
end;

procedure TframeUserAppSettings.InternalReload;
begin
  qrySettings.Close;
  qrySettings.SQL.Text := 'Select * from User_TaxModule Where LOGIN_ID = :LOGIN_ID '+
    ' AND TaxModule = :TaxModule';
  qrySettings.ParamByName('LOGIN_ID').AsString := FUser;
  qrySettings.ParamByName('TaxModule').AsString := FApp;
  qrySettings.Open;
  FillList;
end;

procedure TframeUserAppSettings.lvValuesCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  with (Sender as TListView).Canvas.Font do
    if (Item.Data <> nil) AND
       (POptionsAtom(Item.Data)^.isOverloaded) then
      Style := [fsBold];
end;

procedure TframeUserAppSettings.lvValuesCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  with (Sender as TListView).Canvas.Font do
    if (Item.Data <> nil) AND
       (POptionsAtom(Item.Data)^.isOverloaded) then
      Style := [fsBold];
end;

procedure TframeUserAppSettings.lvValuesDblClick(Sender: TObject);
begin
  if lvValues.Selected = nil then
    Exit;
  EditOverrideValue(lvValues.Selected)
end;

procedure TframeUserAppSettings.lvValuesItemChecked(Sender: TObject;
  Item: TListItem);
begin
  if (fsInit in frameState) or (fsSetValue in frameState) then
    Exit;
  if Item.Checked then
    EditOverrideValue(Item)
  else
    if MessageDlg('Use common value?', mtConfirmation, [mbYes, mbCancel],0) <> mrYes then
    begin
      FrameState := FrameState + [fsSetValue];
      try
        Item.Checked := False;
      finally
        FrameState := FrameState - [fsSetValue];
      end;
    end
    else
      ClearOverrideValue(Item);
end;

function TframeUserAppSettings.Save: Boolean;
var
  I: Integer;
  P: POptionsAtom;
begin
  if not FChanged then
    Exit(True);
  TAppProfiles.AddApp(FConnection, FUser, FApp);
  TAppProfile.DeleteAllOverloadProperty(FConnection, FUser, FApp);
  for I := 0 to lvValues.Items.Count - 1 do
  begin
    P := lvValues.Items.Item[I].Data;
    if P^.isOverloaded then
      try
        TAppProfile.SetOverloadProperty(FConnection, FUser, FApp,
          P^.Name, P^.PersonalValue.ToString);
      except ON E: Exception DO
        begin
          MessageDlg(E.Message, mtError, [mbOk], 0);
          Exit(False);
        end;
      end;
  end;
  Result := True;
end;

procedure TframeUserAppSettings.SetUser(const Value: String);
begin
  FUser := Value;
  InternalReload;
end;

procedure TframeUserAppSettings.FillList;
var
  ctx: TRttiContext;
  objType: TRttiType;
  Field: TRttiField;
  FieldName: String;
  FieldValue: TValue;

  App: TApp;
  P: POptionsAtom;
  CommonOptionsList, AppOptionsList: TStringList;
const
  SavedTypes: TTypeKinds = [tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkUString];



function GetCommonValue(AValueName: String; ATypeKind: TTypeKind): TValue;
  var
    S, R: String;
    I: Integer;
begin
  R := '';
  i := CommonOptionsList.IndexOfName(AValueName);
  if i <> -1 then
    R := CommonOptionsList.ValueFromIndex[I]
  else
    for S in AppOptionsList do
      if SameText(Trim(Copy(S, 1, 20)), AValueName) then
        R:= Copy(S, 21, maxInt);
  Result := StringToTValue(R, ATypeKind);
end;

begin
  FrameState := FrameState + [fsInit];
  try
    qrySettings.Close;
    qrySettings.SQL.Text := 'Select OptionsName, OptionsValue from Overload_Options '+
      'where LOGIN_ID = :LOGIN_ID AND TaxModule = :TaxModule '+
      'order By OptionsName';
    qrySettings.Open;

    ClearOptionsList;

    App := AppList.AppFromID(FApp);
    if App = nil then
      exit;
    CommonOptionsList := TStringList.Create;
    AppOptionsList := TStringList.Create;
    try
      if FileExists(IncludeTrailingPathDelimiter(ExeDir) +
                    OptionsFlName) then
        CommonOptionsList.loadFromFile(IncludeTrailingPathDelimiter(ExeDir) +
                                       OptionsFlName);
      if FileExists(IncludeTrailingPathDelimiter(App.AppDir) +
                    OptionsFlName) then
        AppOptionsList.loadFromFile(IncludeTrailingPathDelimiter(App.AppDir) +
                                    OptionsFlName);

      ctx := TRttiContext.Create;
      objType := ctx.GetType(App.ClassInfo);
      for Field in objType.GetFields do
      Begin
        if (Field.FieldType.TypeKind in SavedTypes) AND
           (Field.Visibility = mvPublic) AND
           (App.HaveOptions(Field.Name) AND
           not MainOptions.HaveOptions(Field.Name)) then
        begin
          New(P);
          P^.Name := Field.Name;
          P^.Caption := App.GetOptionsCaption(Field.Name);
          P^.CommonValue := GetCommonValue(Field.Name, Field.FieldType.TypeKind);
          if qrySettings.Locate('OptionsName', Field.Name, [loCaseInsensitive]) then
          begin
            P^.PersonalValue := StringToTValue(qrySettings.FieldByName('OptionsValue').AsString,
              Field.FieldType.TypeKind);
            P^.isOverloaded := True;
          end
          else
            P^.isOverloaded := False;
          with lvValues.Items.Add do
          begin
            Caption := P^.Name;
            SubItems.Add(P^.Caption);
            SubItems.Add(P^.CommonValue.ToString);
            SubItems.Add(P^.PersonalValue.ToString);
            Checked := P^.isOverloaded;
            Data := P;
          end;
        end;
      End;
      lvValues.SortType := stText;
    finally
      CommonOptionsList.Free;
      AppOptionsList.Free;
    end;
  finally
    FrameState := FrameState - [fsInit];
  end;
end;

end.
