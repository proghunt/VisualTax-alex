unit T1_2026EFMErr;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,DBCtrls,DB,Buttons,Grids,DBGrids,ExtCtrls,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TEFMErrorsT1_2026 = class(TForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    ListBox1: TListBox;
    Label3: TLabel;
    Panel2: TPanel;
    DBMemo1: TDBMemo;
    ErrorTypeGroup: TRadioGroup;
    CancelBtn: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    SwapBtn: TBitBtn;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel3: TPanel;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ErrorTypeGroupClick(Sender: TObject);
    Procedure GetMstErrors;
    procedure GetRetEfErrors(RetNo:Integer);
    procedure Edit1Change(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure SwapBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EFMErrors: TEFMErrorsT1_2026;
  RetNo:Integer;
  EFErrList : TStringList; {holds errors for current return}
  EfMstList : TStringList;  {holds master list}
  FirstTime : Boolean;
implementation

{$R *.DFM}

uses vtMulti,vtCommon,vtMain,T1_2026,T1_2026Common,T1_2026TrimStr,
     T1_2026Declare,T1_2026ChildWinNew,T1_2026main
   , vtTrimStr, vtShared, vtDataBase;

procedure TEFMErrorsT1_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
EFErrList.Free;
EfMstList.Free;
Close;
end;

procedure TEFMErrorsT1_2026.FormCreate(Sender: TObject);
begin
 RetNo:=GetCurrentRetNo;
 FirstTime := true;
 EFErrList :=TStringList.Create;
 EFMstList :=TStringList.Create;
 GetMstErrors; {all errors into list}
 If LicenseLevel <> llLimited then GetRetEfErrors(RetNo);
end;

procedure TEFMErrorsT1_2026.GetRetEfErrors(RetNo:Integer);
Var i:Integer;EfErrFlName:string;
begin
  ErrorTypeGroup.ItemIndex := 0;
   EfErrFlName := OptRec.EF_dataDir+'\'+LeftStr(GetSinNo(RetNo),8)+'.'+
                  RightStr(GetSinNo(RetNo),1)+'EF';
   If (RetInMem >0) and (FileExists(EFErrFlName)) then
      EfErrList.LoadFromFile(EfErrFlName)
   else
     EfErrList.Clear;

  If EfErrList.count =0 then
  begin
   For i:=24 to 30 do
    EferrList.Add(AllTrim(FetchElm(RetNo,'STATUS',i)));
   If EfErrList.Count=0 then
     EfErrList.Clear;
  end;

  Invalidate;
end;

procedure TEFMErrorsT1_2026.FormPaint(Sender: TObject);
begin
 If (ErrorTypeGroup.ItemIndex = 0) then
 begin
    If RetInMem > 0 then
    begin
      ListBox1.Clear;
      Label3.Caption := GetRetName(RetNo);
      Label3.Color := GetRetColor(RetNo);
      ListBox1.Items.AddStrings(EfErrList);
      If not FirstTime then
      begin
       If EfErrList.Count=0 then
        ShowMessage('No errors found on this return');
      end
      else
       FirstTime:=false;
    end
    else
    begin
    ShowMessage('You must open an EFile rejected return first');
    ErrorTypeGroup.ItemIndex := 1;
    end;
 end
 Else
  begin
  Label3.Caption := 'Efile errors (Master List)';
  ListBox1.Clear;
  ListBox1.Items.AddStrings(EfMstList);
  end;
  ListBox1.ItemIndex :=0;
  ListBox1Click(Sender);
end;

procedure TEFMErrorsT1_2026.ErrorTypeGroupClick(Sender: TObject);
begin
FormPaint(Sender);
end;


Procedure TEFMErrorsT1_2026.GetMstErrors;
begin
 Table1.Close;
 If Table1.Active = False then
 begin
  //20150916 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + EfErrorsDBLite, EfErrorsTableLite, 'Code');

  {Load master codes into list}
  Table1.First;
  while not Table1.EOF do
   begin
    EfMstList.Add(Table1.FieldByName('Code').AsString);
    Table1.Next;
   end;
  Table1.First;
 end;
end;

procedure TEFMErrorsT1_2026.Edit1Change(Sender: TObject);
begin
//20170522 Igor >>>
  Table1.Locate('CODE', Edit1.Text, [loCaseInsensitive]);
// with Table1 do
//  begin
//  SetKey;
//  FieldByName('Code').AsString := UpperCase(Edit1.Text);
//  GotoKey; {GotoNearest;}
//  end;
//20170522 igor <<<
end;

procedure TEFMErrorsT1_2026.ListBox1Click(Sender: TObject);
begin
If ListBox1.Items.Count =0 then exit;
//20170522 Igor >>>
  Table1.Locate('CODE', ListBox1.Items[ListBox1.ItemIndex], [loCaseInsensitive, loPartialKey]);

// with Table1 do
//  begin
//  SetKey;
//  FieldByName('Code').AsString := UpperCase(ListBox1.Items[ListBox1.ItemIndex]);
//  GotoNearest;
//  end;
end;

procedure TEFMErrorsT1_2026.SwapBtnClick(Sender: TObject);
begin
If RetInMem=1 then
 begin ShowMessage('This is the only return in memory!');exit;end;

 MainFormT1.SwapReturns1Click(Sender);
 GetRetEfErrors(RetNo);
end;

end.
