unit T4T5_2026statusFrm;
//20171223 Igor
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, StdCtrls, Buttons,
  T4T5_2026Declare,T4T5_2026TrimStr, ExtCtrls, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf,
  uADStanAsync, uADDAptManager, uADCompDataSet, uADCompClient, uADGUIxIntf,
  uADStanDef, uADStanPool, uADPhysManager;

type
  TStatusFrmT4T5_2026 = class(TForm)
    DataSource1: TDataSource;
    Q: TADQuery;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    OkBtn: TBitBtn;
    T4Btn: TBitBtn;
    T4ABtn: TBitBtn;
    T5Btn: TBitBtn;
    EmpllBtn: TBitBtn;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    printBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    Conn: TADConnection;
    Label5: TLabel;
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure EmpllBtnClick(Sender: TObject);
    procedure T4BtnClick(Sender: TObject);
    procedure T4ABtnClick(Sender: TObject);
    procedure T5BtnClick(Sender: TObject);
    procedure printBtnClick(Sender: TObject);
    function SwitchToForm(AForm: string): boolean;
  private
    { Private declarations }
    CurrentFile_Name: string;
  public
    { Public declarations }
  end;

var
  StatusFrmT4T5_2026: TStatusFrmT4T5_2026;

  function GetRetNoByName(AFileName: string): integer;
  function OpenReturnAndGetRetNo(AFileName: string): integer;

implementation

{$R *.DFM}
Uses T4T5_2026Main, vtTrimStr, vtDataBase, T4T5_2026, vtShared,
  T4T5_2026print, vtCommon, vtMulti, T4T5_2026Common2, vtMain, vtChild;

function GetRetNoByName(AFileName: string): integer;
var i: integer;
begin
  Result := 0;
  for i := 1 to RetList.Count - 1 do
  begin
    if Assigned(RetList[i]) and
       not RetList[i].Destroying
       and (RetList[i].MyApp = AppT4T5_2026)
       and SameText(RetList[i].SourceFlName, AFileName)
       and SameText(RetList[i].SourceDataDir, OptRec.Dir_Cur) then
    begin
      Result := i;
      break;
    end;
  end;
end;

function OpenReturnAndGetRetNo(AFileName: string): integer;
begin
  Result := GetRetNoByName(AFileName);
  if Result = 0 then
  begin
    Screen.Cursor:= crHourGlass;
    try
      Result := OpenReturn(OptRec.Dir_Cur, AFileName, True);
      if Result > 0 then
      begin
        Busy; //LockWindowUpdate(MainForm.Handle);
        try
          vtChild.CreateNewMDIChild(Result, '').HideAllControls;
          try
            CountDiagnostics(Result);
            MainForm.ReduceTutorialHeight(Application);
            OpenForm(Result, AppT4T5_2026.FirstForm, 0);
            OpenUsedForms(Result);
            Ret[Result].MyChild.UpdateChildTaxPanel;
            MainForm.FormPaint(Application);
            MainForm.GuiCommand(gcReturns);
          finally
            vtChild.CreateNewMDIChild(Result, '').ShowAllControls;
          end;
        finally
          Done;  //LockWindowUpdate(MainForm.Handle);
        end;
        MainForm.GuiCommand(gcShowLeftPanel);  // MainForm.LeftPanel.Visible:=True;
      end
      else
        ShowOpenReturnFailure(Result, OptRec.Dir_Cur, AFileName)
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TStatusFrmT4T5_2026.OkBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TStatusFrmT4T5_2026.FormCreate(Sender: TObject);
begin
  SetConnection(Conn, OptRec.Dir_Cur + '\' + ClientsDBLite, 'Clients', false, false);
  Q.SQL.Text := GenerateEmployerIssueSQL;
  Q.Open;
  if Q.Active = false then
  begin
    ShowMessage('Data Base not found'+
      Chr(13)+'Define data directories under Config | Data Directories');
    Close;
    exit;
  end;
end;

procedure TStatusFrmT4T5_2026.DBGrid1CellClick(Column: TColumn);
begin
  CurrentFile_Name := Q.FieldByName('File_Name').AsString;
end;

procedure TStatusFrmT4T5_2026.DBGrid1DblClick(Sender: TObject);
begin
  CurrentFile_Name := Q.FieldByName('File_Name').AsString;
end;

procedure TStatusFrmT4T5_2026.EmpllBtnClick(Sender: TObject);
begin
  if SwitchToForm('EMPL') then
    Close;
end;

procedure TStatusFrmT4T5_2026.T4BtnClick(Sender: TObject);
var nRetNo: integer;
begin
  if SwitchToForm('T4') then
    Close;
end;

procedure TStatusFrmT4T5_2026.T4ABtnClick(Sender: TObject);
begin
  if SwitchToForm('T4A') then
    Close;
end;

procedure TStatusFrmT4T5_2026.T5BtnClick(Sender: TObject);
begin
  if SwitchToForm('T5') then
    Close;
end;

procedure TStatusFrmT4T5_2026.printBtnClick(Sender: TObject);
begin
  PrintEmployerIssuer;
end;

function TStatusFrmT4T5_2026.SwitchToForm(AForm: string): boolean;
var RetNo: integer;
begin
  Result := false;
  if CurrentFile_Name > '' then
  begin
    RetNo := OpenReturnAndGetRetNo(CurrentFile_Name);
    if RetNo > 0 then
    begin
      OpenForm(RetNo, GetFormNo(AForm), 0);
      Result := true;
    end;
  end;
end;

end.
