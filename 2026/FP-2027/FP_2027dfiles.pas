unit FP_2027dfiles;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,FP_2027Declare,ExtCtrls;

type
  TDFilesFP_2012 = class(TForm)
    ListBox1: TListBox;
    SelectBtn: TBitBtn;
    CancelBtn: TBitBtn;
    AddNewBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    FormLabel: TLabel;
    TopPanel: TPanel;
    DeleteAllBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure SelectBtnClick(Sender: TObject);
    procedure AddNewBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ChangeBtnClick(Sender: TObject);
    procedure DeleteAllBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DFiles: TDFilesFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TDFilesFP_2012.FormCreate(Sender: TObject);
begin
  Caption:=SomeCaption;
  TopPanel.Caption:= SomeCaption;
  FormLabel.Caption:=SomeLabel;
  ListBox1.Items.LoadFromFile(Appdir+'\'+SomeFile);
  ListBox1.ItemIndex := 0;
  If UpperCase(SomeFile)='COMPFRM.D' then
   ListBox1.Font.Name := 'Courier New';
end;

procedure TDFilesFP_2012.SelectBtnClick(Sender: TObject);
begin
 ShowMessage('Selected'+Chr(13)+
    ListBox1.Items[ListBox1.ItemIndex]);
end;

procedure TDFilesFP_2012.AddNewBtnClick(Sender: TObject);
var
 S : string; //[40];
begin
  s :=InputBox('Input Box', 'Enter Name', '');
  If s > '' then
   begin
    ListBox1.Items.Add(s);
    ListBox1.Items.SaveToFile(Appdir+'\'+SomeFile);
   end;
end;

procedure TDFilesFP_2012.DeleteBtnClick(Sender: TObject);
begin
if MessageDlg('Are you sure you want to delete?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
   begin
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    ListBox1.Items.SaveToFile(Appdir+'\'+SomeFile);
    ListBox1.ItemIndex :=0;
   end;
end;

procedure TDFilesFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TDFilesFP_2012.ChangeBtnClick(Sender: TObject);
var
 S : string; //[40];
begin
  s :=InputBox('Input Box', 'Enter New Name',
     ListBox1.Items[ListBox1.ItemIndex]);
  ListBox1.Items.Add(s);
  ListBox1.Items.SaveToFile(Appdir+'\'+SomeFile);
end;

procedure TDFilesFP_2012.DeleteAllBtnClick(Sender: TObject);
begin
if MessageDlg('Are you sure you want to delete?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
   begin
    ListBox1.Items.Clear;
    ListBox1.Items.SaveToFile(Appdir+'\'+SomeFile);
   end;
end;

end.
