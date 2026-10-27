unit fCalcWatch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, vtMulti;

type
  TCalcWatch = class(TForm)
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    edFormName: TEdit;
    edFields: TEdit;
    gbRetName: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lbBefore: TListBox;
    lbAfter: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure edFormNameChange(Sender: TObject);
    procedure edFieldsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public
    FormName, FieldList: string;
    lbFields: TStringList;
    function ShowTV(RetNo: integer; FName: string; const TV: array of real; fBefore: boolean): boolean;
  end;

var
  CalcWatch: TCalcWatch;

implementation

{$R *.DFM}

{ TCalcWatch }

function TCalcWatch.ShowTV(RetNo: integer; FName: string; const TV: array of real; fBefore: boolean): boolean;
var
  lb: TListBox;
  i, fld, FNo: integer;
begin
  Result := False; //nothing to show
  if not assigned(Self) or (UpperCase(FName) <> FormName) then //20160531 Igor
    exit;
  FNo := GetRetFormNo(RetNo, FormName);
  if fBefore then
  begin
    lb := lbBefore;
    lbBefore.Clear;
    lbAfter.Clear;
    gbRetName.Caption := RetList[RetNo].GetReturnCaption;
  end
  else
    lb := lbAfter;
  for i := 0 to lbFields.Count - 1 do
  begin
    fld := StrToInt(lbFields[i]);
    if fld > 0 then
      lb.Items.Add(Format('TV[%d] = %m (%s)', [fld, TV[fld], RetList[RetNo].Frm[FNo].Strings[fld]]))
    else if fld < 0 then
      lb.Items.Add(Format('Ln[%d] = %m', [-fld, RetList[RetNo].Ln[-fld]]));
  end;
  Result := not fBefore;
end;

procedure TCalcWatch.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TCalcWatch.edFormNameChange(Sender: TObject);
begin
  FormName := UpperCase(edFormName.Text);
  Caption := 'Watch ' + FormName + ' calculations';
end;

procedure TCalcWatch.edFieldsChange(Sender: TObject);
begin
  FieldList := edFields.Text;
  lbFields.CommaText := FieldList;
end;

procedure TCalcWatch.FormCreate(Sender: TObject);
begin
  lbFields := TStringList.Create;
  //disable
    //FormName := UpperCase(edFormName.Text);
  FieldList := edFields.Text;
  lbFields.CommaText := FieldList;
end;

procedure TCalcWatch.FormDestroy(Sender: TObject);
begin
  lbFields.Free;
end;

end.

