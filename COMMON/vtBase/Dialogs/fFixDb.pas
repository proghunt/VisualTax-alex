unit fFixDb;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,DBGrids,DB,ExtCtrls,DBCtrls,
  vtLabel, vtDialogs;

type
  TFixDBForm = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Label3: TLabel;
    VariableLabel1: TvtLabel;
    VariableLabel2: TvtLabel;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DBNavigator1: TDBNavigator;
    SortBy: TRadioGroup;
    DataSource1: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SortByClick(Sender: TObject);
  public
    FixDbName,FixDbDir: string;
    FixDBType: eDataBaseType;
  end;

//var  FixDBFormT1_2012: TFixDBFormT1_2012;

implementation

{$R *.DFM}

uses
  //T1_2012,T1_2012Declare, T1_2012TrimStr,
  vtTrimStr,vtShared;


procedure TFixDBForm.FormShow(Sender: TObject);
begin
  Caption := 'Modify ' + FixDBName;
  VariableLabel1.Caption:='';
  VariableLabel2.Caption:='';

  //Table1.TableName := FixDBName;
  SortBy.Visible := False;
  case FixDBType of
  dbtForms:
   begin
    SortBy.Visible := True;
    SortBy.ItemIndex := 0;
    SortByClick(Sender);
   end;

  dbtDataDict:  //  If FixDbName = DictTable then
   begin
    //Table1.IndexName := 'KeyWord';
    VariableLabel1.Caption:='KeyWords: use words separated with underscore ( _ ). Do not use the # symbol. Example: Total_Income OR TotalIncome';
    VariableLabel2.Caption:='The easiest way to add keyWords is to Open a form and Right Click on a data field. KeyWords are used in Client Letters';
   end;
  end; //case

  //Table1.Open; Table1.Edit;
  //Table1.First;
end;

procedure TFixDBForm.SaveBtnClick(Sender: TObject);
begin
  //Table1.Post; - not required?
  //Table1.Free;
  ModalResult := mrOk;  // Close;
end;

procedure TFixDBForm.CancelBtnClick(Sender: TObject);
begin
  //Table1.Close;
  ModalResult := mrCancel;  //  Close;
end;

procedure TFixDBForm.SortByClick(Sender: TObject);
begin
(* FormsList only!
*)
  if FixDBType <> DBtForms then
    exit;
{ Case SortBy.ItemIndex of
 0: Table1.IndexName := 'FormName';
 1: Table1.IndexName := 'FormNo';
 2: Table1.IndexName := 'PrnSeq';
 else
  Table1.IndexName := 'FormName';
 end;
 If Table1.Active then Table1.First;   }
end;


end.
