unit T1_2026SIC;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,Grids,Outline,Mask,vtEditBox;

type
  TSICT1_2026 = class(TForm)
    Label1: TLabel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label2: TLabel;
    CodeEntered: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    KeyW: TEdit;
    FindBtn: TBitBtn;
    ListBox1: TListBox;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);

    procedure FindBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure KeyWKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SIC: TSICT1_2026;

implementation

{$R *.DFM}

uses vtDialogs,T1_2026Declare,T1_2026TrimStr,vtTrimStr,vtShared;

procedure TSICT1_2026.CancelBtnClick(Sender: TObject);
begin
SelectedString:='';
Close;
end;

procedure TSICT1_2026.FormCreate(Sender: TObject);
begin
// GroupBox1.ItemIndex :=1;

 ListBox1.Items.LoadFromFile(AppDir+'\'+'NAICS.d');

{ does not work
 with Outline1 do
  begin
  Items[1].Expanded := False;
  Items[2].Expanded := True;
  Items[3].Expanded := True;
  end;}
end;

procedure TSICT1_2026.OkBtnClick(Sender: TObject);
Var TempList:TStringList;
begin
  If Length(CodeEntered.text)=6 then
  begin
   SelectedString:=CodeEntered.text;
   TempList:=TStringList.Create;
   TempList.LoadFromFile(Appdir+'\'+'NAICS.D');
   If IsInList(CodeEntered.text,Templist)<0 then
   begin
    ShowMessage('Code is incorrect or No code selected');
    Exit;
   end
   Else
    SelectedString:=CodeEntered.text;
   TempList.free;
  end
  else
  begin
   If ListBox1.ItemIndex>=0 then
    SelectedString := LeftStr(AllTrim(ListBox1.Items[ListBox1.Itemindex]),6)
   Else
    ShowTimedMsg('No code selected',1300);
  end;
  If Not Numeric(SelectedString) then
  begin
   ShowMessage('Code entered is incorrect or No code selected');
   Exit;
  end;

  Close;
end;


procedure TSICT1_2026.FindBtnClick(Sender: TObject);
Var I:Integer;
  //ResultsList:TStringList;
begin
 If KeyW.Text='' then
 begin
  ShowTimedMsg('Please enter a Keyword first',1300);
  Exit;
 end;
 SelectedString := PopMatchingList(KeyW.Text, ListBox1.Items,SomeCaption);
 If SelectedString > '' then
 begin
  SelectedString:=AllTrim(MidStr(AllTrim(SelectedString),4,10)); //20180417
 // SelectedString:=MidStr(AllTrim(SelectedString),6,6);
  If Numeric(LeftStr(SelectedString,1)) = false then
  begin
   ShowMessage ('The selection is incorrect');
   Exit;
  end;
  CodeEntered.text:=SelectedString;
  ShowMessage('Selected: '+SelectedString);
  OkBtnClick(Sender);
 end;
 //ResultsList.Free;
 //SomeList.Free;
end;

procedure TSICT1_2026.ListBox1DblClick(Sender: TObject);
begin
OkBtnClick(Sender);
end;

procedure TSICT1_2026.KeyWKeyPress(Sender: TObject; var Key: Char);
begin
If Key=Chr(13) then FindBtnClick(Sender);
end;

end.
