unit FP_2027ExportOther;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,TabNotBk,StdCtrls,Buttons,ComCtrls,FileCtrl,ExtCtrls,Grids,Db,
  DBGrids,Mask,DBCtrls;

type
  TExportOtherFP_2012 = class(TForm)
    Panel3: TPanel;
    CancelBtn: TBitBtn;
    OKBtn: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    FilesOutBox: TEdit;
    FlNameBox: TEdit;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    BranchListBox: TComboBox;
    Function MkFlName:String;
    Function DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
//    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    Function  EditScreen:Boolean;
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure BranchListBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportOther: TExportOtherFP_2012;
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

Function TExportOtherFP_2012.DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
{MDD  8.3 format}
Const ProductionMonths = 'ABCDEFGHIJKL';
Const testMonths       = 'MNOPQRSTUVXYZ';
Var YYYY,MM,DD:Word; M:string; //[1];
begin
  DecodeDate(Dt,YYYY,MM,DD);
  If TestOrProduction = 1 then m:=TestMonths[mm] else m:=ProductionMonths[mm];
  result := m+PaddZero(IntToStr(DD),2);
end;

Function TExportOtherFP_2012.MkFlName:String;
begin
 result := User.Branch+'-'+BranchListBox.Text+'-'+ //20170112 Igor
        ExtractFileName(FlName);
end;

(*
procedure TExportOther.FormCreate(Sender: TObject);
Var i:Integer;AList:TStringList;
begin
 AList := TStringList.Create;
 If OpenDialog1.Execute then
 begin
  OpenDialog1.InitialDir := 'c:\';
  FlName :=OpenDialog1.FileName;
 end;

 GetListOfBranches(AList);
 BranchListBox.Items.Clear;
 BranchListBox.Items.Add('ALLB');
 For i:=0 to AList.Count-1 do
   BranchListBox.Items.Add(AList[i]);
 BranchListBox.ItemIndex :=0;
 FlNameBox.Text:=MkFlName;
 FilesOutBox.Text := ThisFilesOutDir;
 Alist.Free;
end;
*)
Function TExportOtherFP_2012.EditScreen:Boolean;
begin
  Result:=True;
  {
  FlName := MkFlName;
  FilesOutDir := FilesOutBox.Text;
  }
  If Not DirectoryExists(ThisFilesOutDir) then
  begin
   ShowMessage('FilesOut directory does not exist. Check Set-up');
   FilesOutBox.SetFocus;
   Result:=False;
   exit;
  end;

  If BranchListBox.Text = '' then
  begin
   ShowMessage('A branch is required or ALLB for all Branches');
   Result:=False;
   exit;
  end;


  If FileExists(ThisFilesOutDir+'\'+FlNameBox.Text) then
  begin
   ShowMessage('File name already exists. Try again');
   Result:=False;
   exit;
  end;
end;

procedure TExportOtherFP_2012.OKBtnClick(Sender: TObject);
Var i,j:Integer;
    FilesOutDir:String; F1:TextFile;
begin
  If FlNameBox.Text = '' Then exit;
  If EditScreen = false then exit;
  Screen.Cursor := crHourGlass;
  CopyFile(FlName,ThisFilesOutDir+'\'+FlNameBox.Text);
  Screen.Cursor := crDefault;
  ShowMessage('Completed');
  Close;
end;

procedure TExportOtherFP_2012.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TExportOtherFP_2012.DBGrid1CellClick(Column: TColumn);
begin
FlNameBox.Text := MkFlName;
end;

procedure TExportOtherFP_2012.BranchListBoxChange(Sender: TObject);
begin
FlNameBox.Text:= MkFlName;
end;

end.
