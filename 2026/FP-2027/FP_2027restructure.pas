unit FP_2027restructure;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,DB,FP_2027Declare,Grids,DBGrids,ExtCtrls;

Const QueryName1 = 'Fp_Alter.Qry';
      QueryName2 = 'FD_Alter.Qry';
type
  TRestructureFP_2012 = class(TForm)
    Memo1: TMemo;
    FileBox: TEdit;
    LoadBtn1: TBitBtn;
    CancelBtn: TBitBtn;
    RunBtn: TBitBtn;
    ClearListBtn: TBitBtn;
    SaveBtn: TBitBtn;
    SaveDialog1: TSaveDialog;
    HeaderBox: TPanel;
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    FundCodeLengthBtn: TBitBtn;
    LoadBtn2: TBitBtn;
    DbBox: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure LoadBtn1Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure ClearListBtnClick(Sender: TObject);
    procedure FundCodeLengthBtnClick(Sender: TObject);
    procedure LoadBtn2Click(Sender: TObject);
    procedure RunTheScript;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Restructure: TRestructureFP_2012;
  QryFlName : String;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,vtTrimStr,vtShared
   , uADCompClient; // 20150923 Igor

procedure TRestructureFP_2012.FormCreate(Sender: TObject);
begin
{FileBox.text := AppDir+'\'+QryName;}
end;

procedure TRestructureFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;



procedure TRestructureFP_2012.SaveBtnClick(Sender: TObject);
begin

SaveDialog1.FileName := QryFlName;
If SaveDialog1.Execute then
 begin
 Memo1.Lines.SaveToFile(SaveDialog1.FileName);
 end;
end;

procedure TRestructureFP_2012.RunBtnClick(Sender: TObject);
begin
 RunTheScript;
end;


procedure TRestructureFP_2012.RunTheScript;
Var i:Integer;
    ADConnection: TADConnection; //20150923 Igor
    Qry: TADQuery;
    QrySource:TDataSource;
begin
 (*
   Screen.Cursor := crHourGlass;

   Qry := TADQuery.Create(Application);
   Qry.ConnectionString:=FpClientsConnectionString;
   {
   If DbBox.ItemIndex=0 then
     Qry.DataBaseName := ClientsDb
   else
     Qry.DataBaseName := FundsDb;
   }
   ListBox1.Clear;
   {
   If DbBox.ItemIndex=0 then
     ListBox1.Items.Add(PaddR(Alltrim('DELETE an index'),40)+
        '...'+DeleteAnIndex(ClientsDb,'Clients','FileName'));
   }

   For i:=0 to memo1.lines.count-1 do   {each line a full statement}
   begin
     Qry.Sql.Clear;
     If (AllTrim(Memo1.lines[i]) >'')
     and (LeftStr(AllTrim(Memo1.Lines[i]),2) <> '//')  {not a comment}
     then
     begin
       //Qry.AdoCommand.CommandText:=Memo1.lines[i];
       //Qry.Sql.Add(Memo1.lines[i]); {each field changed}
       Qry.Sql.Text:=Memo1.lines[i]; {each field changed}
       Try
        //Qry.AdoCommand.Execute;
        Qry.ExecSql;
        Qry.Close;
        ListBox1.Items.Add(
        PaddR(Alltrim(LeftStr(Memo1.lines[i],40)),40)+'...'+Space(20)+'Done');
       except
         on E: Exception do
          ListBox1.Items.Add(
           PaddR(Alltrim(LeftStr(Memo1.lines[i],40)),40)+'...'+
            MidStr(E.Message,21,80));
       end;
     end;
   end;
   Qry.Free;
  Screen.Cursor := crDefault;
 *) 
end;

procedure TRestructureFP_2012.ClearListBtnClick(Sender: TObject);
begin
Memo1.Lines.Clear;
end;

procedure TRestructureFP_2012.FundCodeLengthBtnClick(Sender: TObject);
begin
 {db,tbl,ndx}
// ReviseFundCodeLength(ClientsDb,'PortfolioDetails');
end;

procedure TRestructureFP_2012.LoadBtn1Click(Sender: TObject);
begin
Memo1.Clear;
FileBox.Text := AppDir+'\'+QueryName1;
QryFlName:=FileBox.text;
DbBox.ItemIndex :=0;
Memo1.Lines.LoadFromFile(FileBox.Text);
ListBox1.Clear;
end;

procedure TRestructureFP_2012.LoadBtn2Click(Sender: TObject);
begin
 Memo1.Clear;
 FileBox.Text := AppDir+'\'+QueryName2;
 QryFlName:=FileBox.text;
 DbBox.ItemIndex :=1;
 Memo1.Lines.LoadFromFile(FileBox.Text);
 ListBox1.Clear;
end;

end.
