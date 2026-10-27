unit T2_2027dfiles;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,T2_2027Declare,T2_2027TrimStr,ExtCtrls;

type
  TDFilesT2_2027 = class(TForm)
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
  DFiles: TDFilesT2_2027;

implementation

{$R *.DFM}
uses
  vtShared;

procedure TDFilesT2_2027.FormCreate(Sender: TObject);
begin
  Caption:=SomeCaption;
  TopPanel.Caption:= SomeCaption;
  FormLabel.Caption:=SomeLabel;
  ListBox1.Items.LoadFromFile(Appdir+'\'+SomeFile);
  ListBox1.ItemIndex := 0;
end;

procedure TDFilesT2_2027.SelectBtnClick(Sender: TObject);
begin
 ShowMessage('Selected'+Chr(13)+
    ListBox1.Items[ListBox1.ItemIndex]);
end;

procedure TDFilesT2_2027.AddNewBtnClick(Sender: TObject);
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

procedure TDFilesT2_2027.DeleteBtnClick(Sender: TObject);
begin
if MessageDlg('Are you sure you want to delete?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
   begin
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    ListBox1.Items.SaveToFile(Appdir+'\'+SomeFile);
    ListBox1.ItemIndex :=0;
   end;
end;

procedure TDFilesT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TDFilesT2_2027.ChangeBtnClick(Sender: TObject);
var
 S : string; //[40];
begin
  s :=InputBox('Input Box', 'Enter New Name',
     ListBox1.Items[ListBox1.ItemIndex]);
  ListBox1.Items.Add(s);
  ListBox1.Items.SaveToFile(Appdir+'\'+SomeFile);
end;

procedure TDFilesT2_2027.DeleteAllBtnClick(Sender: TObject);
begin
if MessageDlg('Are you sure you want to delete?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
   begin
    ListBox1.Items.Clear;
    ListBox1.Items.SaveToFile(Appdir+'\'+SomeFile);
   end;
end;

end.
