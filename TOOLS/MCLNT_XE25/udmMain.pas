unit udmMain;

interface

uses
  System.SysUtils, System.Classes, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanExprFuncs, uADGUIxFormsWait, uADCompGUIx,
  uADPhysSQLite, Data.DB, uADCompClient;

type
  TdmMain = class(TDataModule)
    FConnection: TADConnection;
    ADPhysSQLiteDriverLink1: TADPhysSQLiteDriverLink;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    FLastYearConnection: TADConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Connect(AConnection: TADConnection; APath: string);
  end;

var
  dmMain: TdmMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmMain }

procedure TdmMain.Connect(AConnection: TADConnection; APath: string);
begin
  with AConnection do
  begin
    Connected := False;
    Params.Clear;
    Params.Values['Database'] := APath;
    Params.Values['LockingMode'] := 'normal';
    DriverName := 'SQLite';
    ResourceOptions.MacroCreate := False;
    ResourceOptions.MacroExpand := False;
    ResourceOptions.AssignedValues := ResourceOptions.AssignedValues + [rvMacroCreate, rvMacroExpand];
    FetchOptions.Mode := fmAll;
    FormatOptions.SortLocale := 0;

    Connected := True;
  end;
end;

end.
