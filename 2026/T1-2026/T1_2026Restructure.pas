unit T1_2026restructure;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,DB,Grids,DBGrids,ExtCtrls;

Const QueryName1 = 'Cl_Alter.Qry';
      QueryName2 = 'CL_Alter.Qry';
type
  TRestructureT1_2026 = class(TForm)
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
    LoadBtn2: TBitBtn;
    DbBox: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure LoadBtn1Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure ClearListBtnClick(Sender: TObject);
    procedure LoadBtn2Click(Sender: TObject);
    procedure RunTheScript;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RestructureT1_2026: TRestructureT1_2026;
  QryName : String;

implementation

{$R *.DFM}

uses T1_2026,T1_2026TrimStr,T1_2026Declare
   , vtTrimStr, vtDataBase, vtShared
   , uADCompClient; // 20150916 Igor

procedure TRestructureT1_2026.FormCreate(Sender: TObject);
begin
 FileBox.text := AppDir+'\'+QueryName1;
end;

procedure TRestructureT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TRestructureT1_2026.SaveBtnClick(Sender: TObject);
begin
SaveDialog1.FileName := AppDir+'\'+QueryName1;
If SaveDialog1.Execute then
 begin
 Memo1.Lines.SaveToFile(SaveDialog1.FileName);
 end;
end;

procedure TRestructureT1_2026.RunBtnClick(Sender: TObject);
begin
 RunTheScript;
end;

procedure TRestructureT1_2026.RunTheScript;
Var i:Integer;
    QrySource:TDataSource;
    ADConnection: TADConnection;
    Qry:TADQuery;
   {Table1:TADTable;}
begin
   Screen.Cursor := crHourGlass;

   //20150916 Igor
   ADConnection:= TADConnection.Create(Application);
   Qry:= TADQuery.Create(Application);

   If DbBox.ItemIndex=0 then
     SqlLoadDBFromFile(ADConnection, Qry, OptRec.Dir_Cur +'\'+ ClientsDBLite, '')  //20150916 Igor
   else
     SqlLoadDBFromFile(ADConnection, Qry, OptRec.Dir_Cur +'\'+ ClientsDBLite, ''); //20150916 Igor

   ListBox1.Clear;

   For i:=0 to memo1.lines.count-1 do   {each line a full statement}
   begin
     Qry.Sql.Clear;
     If (AllTrim(Memo1.lines[i]) >'')
     and (LeftStr(AllTrim(Memo1.Lines[i]),1) <> '{')  {not a comment}
     then
     begin
       Qry.Sql.Add(Memo1.lines[i]); {each field changed}
       Try
         Qry.ExecSql;
         Qry.Close;
         ListBox1.Items.Add(
          PaddR(Alltrim(LeftStr(Memo1.lines[i],40)),40)+'...'+Space(20)+'Done');
       except
         on E: Exception do
          ListBox1.Items.Add(
           PaddR(Alltrim(LeftStr(Memo1.lines[i],40)),40)+'...'+
            MidStr(E.Message,1,80));
       end;
     end;
   end;
   Qry.Free;
  Screen.Cursor := crDefault;
end;

procedure TRestructureT1_2026.ClearListBtnClick(Sender: TObject);
begin
Memo1.Lines.Clear;
end;


procedure TRestructureT1_2026.LoadBtn1Click(Sender: TObject);
begin
Memo1.Clear;
FileBox.Text := AppDir+'\'+QueryName1;
DbBox.ItemIndex :=0;
Memo1.Lines.LoadFromFile(FileBox.Text);
ListBox1.Clear;
end;

procedure TRestructureT1_2026.LoadBtn2Click(Sender: TObject);
begin
 Memo1.Clear;
 FileBox.Text := AppDir+'\'+QueryName2;
 DbBox.ItemIndex :=1;
 Memo1.Lines.LoadFromFile(FileBox.Text);
 ListBox1.Clear;
end;

end.
