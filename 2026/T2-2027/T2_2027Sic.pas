unit T2_2027Sic;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, T2_2027Declare, T2_2027TrimStr, ExtCtrls, Grids, Outline,
  Mask, vtEditBox;

type
  TSICT2_2027 = class(TForm)
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
  SIC: TSICT2_2027;

implementation

{$R *.DFM}

uses vtDialogs, vtTrimStr, T2_2027main,
  vtShared; //20160907 Igor

procedure TSICT2_2027.CancelBtnClick(Sender: TObject);
begin
  SelectedString := '';
  Close;
end;

procedure TSICT2_2027.FormCreate(Sender: TObject);
begin
  // GroupBox1.ItemIndex :=1;

  ListBox1.Items.LoadFromFile(AppDir + '\' + 'NAICS.d');

  { does not work
   with Outline1 do
    begin
    Items[1].Expanded := False;
    Items[2].Expanded := True;
    Items[3].Expanded := True;
    end;}
end;

procedure TSICT2_2027.OkBtnClick(Sender: TObject);
var
  TempList: TStringList;
begin
  if Length(CodeEntered.text) = 6 then
  begin
    SelectedString := CodeEntered.text;
    TempList := TStringList.Create;
    TempList.LoadFromFile(Appdir + '\' + 'NAICS.D');
    if IsInList(CodeEntered.text, Templist) < 0 then
    begin
      ShowMessage('Code is incorrect or No code selected');
      Exit;
    end
    else
      SelectedString := CodeEntered.text;
    TempList.free;
  end
  else
  begin
    if ListBox1.ItemIndex >= 0 then
      SelectedString := MidStr(ListBox1.Items[ListBox1.Itemindex], 2, 6)
        //LeftStr(AllTrim(ListBox1.Items[ListBox1.Itemindex]),6)
    else
      ShowTimedMsg('No code selected', 1300);
  end;
  if not Numeric(SelectedString) then
  begin
    ShowMessage('Code entered is incorrect or No code selected');
    Exit;
  end;

  Close;
end;

procedure TSICT2_2027.FindBtnClick(Sender: TObject);
var
  I: Integer;
  //ResultsList:TStringList;
begin
  if KeyW.Text = '' then
  begin
    ShowTimedMsg('Please enter a Keyword first', 1300);
    Exit;
  end;
  SomeList.Clear; //:=TStringList.Create;


  SelectedString := PopMatchingList(KeyW.Text, ListBox1.Items);

  if SelectedString > '' then
  begin
    SelectedString := MidStr(AllTrim(SelectedString), 6, 6);
    if Numeric(LeftStr(SelectedString, 1)) = false then
    begin
      ShowMessage('The selection is incorrect');
      Exit;
    end;
    CodeEntered.text := SelectedString;
    ShowMessage('Selected: ' + SelectedString);
    OkBtnClick(Sender);
  end;
  //ResultsList.Free;
 // SomeList.Free;  //20121208
end;

procedure TSICT2_2027.ListBox1DblClick(Sender: TObject);
begin
  OkBtnClick(Sender);
end;

procedure TSICT2_2027.KeyWKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(13) then
    FindBtnClick(Sender);
end;

end.

