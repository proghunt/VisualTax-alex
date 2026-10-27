unit FP_2027exportorganization;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,TabNotBk,StdCtrls,Buttons,ComCtrls,FileCtrl,ExtCtrls,Grids,Db,
  DBGrids,Mask,DBCtrls, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TExportOrganizationFP_2012 = class(TForm)
    Panel3: TPanel;
    CancelBtn: TBitBtn;
    OKBtn: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    FilesOutBox: TEdit;
    FlNameBox: TEdit;
    Label1: TLabel;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    hFDConnection: TADConnection;
    HeadOfficeTbl: TADTable;
    bFDConnection: TADConnection;
    BranchOfficesTbl: TADTable;
    aFDConnection: TADConnection;
    AgentsTbl: TADTable;
    Function MkFlName:String;
    Function DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    Function  EditScreen:Boolean;
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportOrganization: TExportOrganizationFP_2012;
  BranchId : string; //[4];
  FlName:String;
  {
  FSOutDir   :String;
  RecCount:Integer;
  BufferRec : AnsiString;
  }

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027Common,vtTrimStr,vtShared,
  vtMulti; //20170112 Igor

Function TExportOrganizationFP_2012.DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
{MDD  8.3 format}
Const ProductionMonths = 'ABCDEFGHIJKL';
Const testMonths       = 'MNOPQRSTUVXYZ';
Var YYYY,MM,DD:Word; M:string; //[1];
begin
  DecodeDate(Dt,YYYY,MM,DD);
  If TestOrProduction = 1 then m:=TestMonths[mm] else m:=ProductionMonths[mm];
  result := m+PaddZero(IntToStr(DD),2);
end;

Function TExportOrganizationFP_2012.MkFlName:String;
begin
 result := User.Branch //20170112 Igor
             +'-'+BranchOfficesTbl['Branch']
             +'-'+ConvertDateToMdd(Now)
             +'.'+'ORG';
end;

procedure TExportOrganizationFP_2012.FormCreate(Sender: TObject);
begin
 hFDConnection.Params.Values['DataBase']:= cfgClientsDbLite_noUse;//20150921 Igor
 bFDConnection.Params.Values['DataBase']:= cfgClientsDbLite_noUse;//20150921 Igor
 aFDConnection.Params.Values['DataBase']:= cfgClientsDbLite_noUse;//20150921 Igor

 If Not HeadOfficeTbl.Active then HeadOfficeTbl.Open;
 If Not BranchOfficesTbl.Active then BranchOfficesTbl.Open;
 If Not AgentsTbl.Active then AgentsTbl.Open;
 BranchOfficesTbl.First;
 BranchId := UpperCase(BranchOfficesTbl['Branch']);
 FlName :=MkFlName;
 FlNameBox.Text := FlName;
 If WhichModule = 'D' then
  FilesOutBox.Text := HoRec.FilesOutDir
 else
  FilesOutBox.Text := ThisFilesOutDir;
    {GetBranchFilesOutDir(User.Branch);}
end;

Function TExportOrganizationFP_2012.EditScreen:Boolean;
Var FilesOutDir:String;
begin
  Result:=True;
  FlName := MkFlName;
  FilesOutDir := FilesOutBox.Text;
  If Not DirectoryExists(FilesOutDir) then
  begin
   ShowMessage('FilesOut directory does not exist. Check Set-up');
   FilesOutBox.SetFocus;
   Result:=False;
   exit;
  end;

  If LeftStr(FilesOutDir,1) = '?' then
  begin
   ShowMessage('Cannot determine the FilesOut directory or invalid Branch code');
   Result:=False;
   exit;
  end;

  If FileExists(FilesOutDir+'\'+FlName) then
  begin
   ShowMessage('File name already exists. Try again');
   Result:=False;
   exit;
  end;
end;

procedure TExportOrganizationFP_2012.OKBtnClick(Sender: TObject);
Const DbName='FpClients';
Var i,j:Integer;{TblNames:TStringList;}
    FilesOutDir:String; F1:TextFile;
begin
  If EditScreen = false then exit;
  BranchId := BranchOfficesTbl['Branch'];
  FlName := MkFlName;
  FilesOutDir := FilesOutBox.Text;

  Screen.Cursor := crHourGlass;
  {Now Create file}
  AssignFile(F1, FilesOutDir+'\'+FlName);
  Rewrite(F1);
  {Write header rec}
  WriteLn(F1,AppName+Delimiter+AppYear+Delimiter+AppRelease+Delimiter+'');

  {HO}
  WriteLn(F1,'T'+Delimiter+DBName+Delimiter+'HEADOFFICE'+Delimiter+'');
    {get the fieldt value}
  For j:=0 to HeadOfficeTbl.FieldCount-1 do
  begin
      WriteLn(F1, 'E'+Delimiter+HeadOfficeTbl.Fields[j].FieldName+Delimiter+
        HeadOfficeTbl.Fields[j].AsString+Delimiter+'');
  end;
  {Branch off}
  WriteLn(F1,'T'+Delimiter+DBName+Delimiter+'BranchOffices'+Delimiter+'');
  WriteLn(F1,'K'+Delimiter+'Branch'+Delimiter+BranchId+Delimiter+'');
  For j:=0 to BranchOfficesTbl.FieldCount-1 do
  begin
     If (UpperCase(BranchOfficesTbl.Fields[j].FieldName) = 'COMMISSIONRATE') then
       WriteLn(F1, 'E'+Delimiter+BranchOfficesTbl.Fields[j].FieldName+Delimiter+
        '0'+Delimiter+'')
     else
      WriteLn(F1, 'E'+Delimiter+BranchOfficesTbl.Fields[j].FieldName+Delimiter+
        BranchOfficesTbl.Fields[j].AsString+Delimiter+'');
  end;
  {Agents}
  AgentsTbl.First;
  Repeat
   If UpperCase(AgentsTbl['Branch']) = BranchId  then
   begin
   WriteLn(F1,'T'+Delimiter+DBName+Delimiter+'Agents'+Delimiter+'');
   WriteLn(F1,'K'+Delimiter+'AgentCode'+Delimiter+AgentsTbl['AgentCode']+Delimiter+'');
   For j:=0 to AgentsTbl.FieldCount-1 do
    begin
      If (UpperCase(AgentsTbl.Fields[j].FieldName) = 'AGENTRATE')
      Or (UpperCase(AgentsTbl.Fields[j].FieldName) = 'BRANCHMANAGERRATE')
      Or (UpperCase(AgentsTbl.Fields[j].FieldName) = 'MANAGERRATE')
      then
        WriteLn(F1, 'E'+Delimiter+AgentsTbl.Fields[j].FieldName+Delimiter+
           '0'+Delimiter+'')
      else
        WriteLn(F1, 'E'+Delimiter+AgentsTbl.Fields[j].FieldName+Delimiter+
        AgentsTbl.Fields[j].AsString+Delimiter+'');
    end; {end element writing}
   end; {right branch}
   AgentsTbl.Next;
  until AgentsTbl.Eof;

  CloseFile(F1);
  Screen.Cursor := crDefault;
  ShowMessage('Completed');
end;

procedure TExportOrganizationFP_2012.CancelBtnClick(Sender: TObject);
begin
 If HeadOfficeTbl.Active then HeadOfficeTbl.Close;
 If BranchOfficesTbl.Active then BranchOfficesTbl.Close;
 If AgentsTbl.Active then AgentsTbl.Close;
 Close;
end;

procedure TExportOrganizationFP_2012.DBGrid1CellClick(Column: TColumn);
begin
FlNameBox.Text := MkFlName;
BranchId := BranchOfficesTbl['Branch'];
end;

end.
