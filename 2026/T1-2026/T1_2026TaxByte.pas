unit T1_2026TaxByte;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,ExtCtrls,DB,StdCtrls,Grids,DBGrids,DBCtrls,Menus,Buttons,
  Mask,ComCtrls,T1_2026Declare,VclTee.TeeProcs,VclTee.TeEngine,VclTee.Chart,
  uADStanIntf, uADStanOption, uADStanParam, uADStanError, uADDatSManager,
  uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf,
  uADStanDef, uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;


type
  TTaxbyteT1_2026 = class(TForm)
    MonitorPlanBtn: TChart;
    Label3: TLabel;
    CancelBtn: TBitBtn;
    ConvertOneBtn: TBitBtn;
    ConvertAllBtn: TBitBtn;
    ToDirBox: TEdit;
    ReplaceOptionBox: TRadioGroup;
    ShowFilesBtn: TBitBtn;
    BookBack: TShape;
    RPanel: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    DBText5: TDBText;
    DBText6: TDBText;
    DBText7: TDBText;
    DBText8: TDBText;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    DBText9: TDBText;
    LPanel: TPanel;
    DBGrid1: TDBGrid;
    Panel6: TPanel;
    Image3: TImage;
    Image1: TImage;
    Image2: TImage;
    DataSource1: TDataSource;
    HelpBtn: TBitBtn;
    ClientsQ: TADQuery;


    procedure FormCreate(Sender: TObject);
    procedure OpenClientsQ;
    procedure CancelBtnClick(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure ShowClients;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure ConvertAllBtnClick(Sender: TObject);
    procedure SaveIt(FlName:String);
    procedure MapData(FlName:String);
    Function ConvertDOB(Dob:TDateTime):String;
    procedure ConvertOne(Sin:String);
    procedure ConvertAll;
    procedure ConvertOneBtnClick(Sender: TObject);
    procedure ShowFilesBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);


  private
    { Private declarations }
  public
    RetNo : integer;
  end;

var
  Taxbyte: TTaxbyteT1_2026;

  FlName: String[60];
  Cnt   : integer;
  InitialRowCount :integer;


implementation
{$R *.DFM}
uses vtMulti,vtCommon,T1_2026,T1_2026TrimStr,T1_2026Common,T1_2026Common2,
     T1_2026ChildWinNew,T1_2026Calc
   , vtTrimStr, vtShared, vtDataBase;

procedure TTaxbyteT1_2026.FormCreate(Sender: TObject);
var
 i:Integer;
begin
 ToDirBox.Text:=OptRec.Dir_Cur;
 OpenTaxByteDB('');
 If taxbyteDb.Connected then
  begin
   {ShowMessage('Data Base opened successfully');}
   Screen.Cursor := crHourGlass;
   ShowClients;
   Screen.Cursor := crDefault;
  end
  else
   ShowMessage('Cannot open the TaxByte Data Base');
end;

procedure TTaxbyteT1_2026.OpenClientsQ;
Var WhereClause:String;
begin
 ClientsQ.Connection:=TaxByteDb; //20150923 Igor
 ClientsQ.Close;
 ClientsQ.SQL.Clear;
 WhereClause:='';
 Try
  With ClientsQ do
  begin
    SQL.Add('Select * from '+ClientsTableLite); //20150923 Igor
    SQL.Add( WhereClause);
    SQL.Add( 'ORDER BY LastName');
    Prepare;
    open;
  end;
 except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end; {end try}
end;

procedure TTaxbyteT1_2026.CancelBtnClick(Sender: TObject);
begin
 If ClientsQ.Active then ClientsQ.Close;
 TaxByteDb.Close;
 {CloseDataBase(TaxByteDb);}
 Close;
 ShowMessage('The T1 program will now be closed'+
  Chr(13)+
  'Please run it again once conversion is completed');
 Application.terminate;
end;

procedure TTaxbyteT1_2026.ShowClients;
begin
OpenClientsQ;
Screen.Cursor := crDefault;

If ClientsQ.RecordCount = 0 then
 begin
  ShowMessage('No clients found');
 end;
end;

procedure TTaxbyteT1_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
{ If Key = #13 then OpenClientsQ;}
end;



procedure TTaxbyteT1_2026.DBGrid1CellClick(Column: TColumn);
begin
{Client := ClientsQ['ClientId'];}
end;



procedure TTaxbyteT1_2026.ConvertAllBtnClick(Sender: TObject);
begin
 Cnt:=0;
 ConvertAll;
 ShowMessage('Import completed.'+Chr(13)+
    'Total returns converted/added= '+IntTostr(cnt));
 {SendMessage(MDIHandle,WM_PAINT,0,0);}
end;

procedure TTaxbyteT1_2026.ConvertOneBtnClick(Sender: TObject);
Var Sin:String;
begin
  Cnt:=0;
  Sin := AllTrim(RemoveChar(ClientsQ.FieldByName('SIN').AsString,'-'));
  ConvertOne(Sin);
  ShowMessage('Import completed.'+Chr(13)+
    'Total returns converted/added= '+IntTostr(cnt));
  {SendMessage(MDIHandle,WM_PAINT,0,0);}
end;

procedure TTaxbyteT1_2026.ConvertOne(Sin:String);
Var i,j,FNo: integer; Msg:string;
PrPStatus,EfStatus :String[2];Notes:String[80];
LastYrDir:String[60];
begin
 If RetInMem>0 then
 begin
  ShowMessage('Please close all returns first');
  exit;
 end;

  FlName:=LeftStr(sin,8)+'.'+RightStr(sin,1);
  If FlName = '' then exit;
  RetNo:=CreateNewReturn;
  if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', FlName); exit; end;

  Try
      Ret[RetNo].SourceDataDir := ToDirBox.Text; {fooli t}
      MapData(FlName);

      CalcAll(RetNo);
      FNo :=GetFormNo('STATUS');
      For j:=8 to 10 do StoreElm(RetNo,FNo,j,'');
      For j:=18 to 30 do StoreElm(RetNo,FNo,j,'');
      For j:=16 to 16 do StoreElm(RetNo,FNo,j,'');
      For j:=14 to 14 do StoreElm(RetNo,FNo,j,'');
      For j:=31 to 31 do StoreElm(RetNo,FNo,j,'');

      For j:=11 to 11 do StoreElm(RetNo,FNo,j,User.UserName); //20170112 Igor
      For j:=12 to 12 do StoreElm(RetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
      {DateToStr(Date));}
      For j:=13 to 13 do StoreElm(RetNo,FNo,j,TimeToStr(Time));


      If FileExists(ToDirBox.Text+'\'+FlName) then
      begin
       if ReplaceOptionBox.ItemIndex=0 then SaveIt(FlName);
      end
      else
       SaveIt(FlName);
  except
  end;
  If RetNo >0 then RemoveReturnFromMemory(RetNo);
  RetNo :=0; //RetINmem :=0;
  //SendMessage(MDIHandle,WM_PAINT,0,0);
end;


procedure TTaxbyteT1_2026.ConvertAll;
Var i,j,FNo: integer; Sin : string;Msg:string;
  PrPStatus,EfStatus,Notes,LastYrDir:String;
begin
 if MessageDlg('Import all. Are you sure?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;
 Cnt :=0;
 If RetInMem>0 then
 begin
  ShowMessage('Please close all returns first');
  exit;
 end;

 ClientsQ.First;
 Repeat
  Sin := AllTrim(RemoveChar(ClientsQ.FieldByName('SIN').AsString,'-'));
  ConvertOne(Sin);
  RetNo :=0; //RetINmem :=0;
  ClientsQ.Next;
 until ClientsQ.Eof;
end;

procedure TTaxbyteT1_2026.SaveIt(FlName:String);
begin
 If not SaveReturn(RetNo,ToDirBox.Text,FlName,True,False) =0 then
   ShowMessage('Return cannot be saved')
 else
  Inc(Cnt);
end;

procedure TTaxbyteT1_2026.MapData(FlName:String);
Var FNo:Integer; dob:String; MaritalSt:Integer;PrvNdx:integer;
begin
 Try
  FNo:=GetFormNo('T1');
  With ClientsQ do
  begin
   StoreElm(RetNo,FNo,2,FieldByName('FirstName').AsString);
   StoreElm(RetNo,FNo,5,FieldByName('LastName').AsString);
   StoreElm(RetNo,FNo,3,RemoveChar(FieldByName('SIN').AsString,'-'));
   Dob:= ConvertDob(FieldByName('DOB').AsDateTime);
   StoreElm(RetNo,FNo,9,Dob);
   PrvNdx:=GetPrvIndex(FieldByName('ProvRes').AsString);
   StoreElm(RetNo,FNo,1,PrvLong[PrvNdx]);
   StoreElm(RetNo,FNo,33,FieldByName('Salutation').AsString);
   MaritalSt:= MyStrToInt(FieldByName('MaritalSt').AsString);
   case MaritalSt of
     1:  StoreElm(RetNo,FNo,11,'X');
     2:  StoreElm(RetNo,FNo,12,'X');
     3:  StoreElm(RetNo,FNo,13,'X');
     4:  StoreElm(RetNo,FNo,16,'X');
     5:  StoreElm(RetNo,FNo,17,'X');
     6:  StoreElm(RetNo,FNo,18,'X');
   end;  {case}
   StoreElm(RetNo,FNo,4,RemoveChar(FieldByName('SpouseSin').AsString,'-'));
   StoreElm(RetNo,FNo,20,FieldByName('SpouseNm').AsString);

   StoreElm(RetNo,FNo,6,FieldByName('Address').AsString);
   StoreElm(RetNo,FNo,10,FieldByName('City').AsString);
   StoreElm(RetNo,FNo,14,FieldByName('Prov').AsString);
   StoreElm(RetNo,FNo,15,FieldByName('PCode').AsString);

  end;
 except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;

Function TTaxbyteT1_2026.ConvertDOB(Dob:TDateTime):String;
{m/d/yyyy to d/m/yyyy}
Var i:Integer;dd,mm:String;
begin
 result:='';
 Result:=FormatDateTime('yyyy-mm-dd',DOB);
 {
 dd:='';mm:='';
 i:=1;
 Repeat
  mm:=mm+dob[i];
  Inc(i);
 until dob[i]='/';

 i:=i+1;
 Repeat
  dd:=dd+dob[i];
  Inc(i);
 until dob[i]='/';

 result:=RightStr(dob,4)+'-'+mm+'-'+dd;
 }
end;


procedure TTaxbyteT1_2026.ShowFilesBtnClick(Sender: TObject);
begin
  If taxbyteDb.Connected then
  begin
   Screen.Cursor := crHourGlass;
   ShowClients;
   Screen.Cursor := crDefault;
  end
  else
   ShowMessage('Cannot open the Data Base');

end;

procedure TTaxbyteT1_2026.DBGrid1DblClick(Sender: TObject);
begin
 ConvertOneBtnClick(Sender);
end;

procedure TTaxbyteT1_2026.HelpBtnClick(Sender: TObject);
begin
  ShowHelp(AppT1_2026.ModuleHelpUpdFile,'Converting_from_Taxbyte_T1', True); //20160801 Igor
 {
  Application.HelpFile := AppDir+'\'+'T1UPDHlp.HLP';
  Application.HelpJump('Converting_from_Taxbyte_T1');
 }
end;

end.
