unit T1_2026rsum;

{
  //20170427 Igor. Fix AV
}
interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls
  //20170427 Igor >>>
  , System.Generics.Collections, vtMulti, Vcl.Menus
  //20170427 Igor <<<
  ;

type
  TRetSumT1_2026 = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    ColorCheckBox: TCheckBox;
    btnOpenFormAndClose: TBitBtn;
    CancelBtn: TBitBtn;
    PopupMenu1: TPopupMenu;
    miOpenForm: TMenuItem;
    Panel2: TPanel;
    btnOpenForm: TBitBtn;
    miOpenFormAndClose: TMenuItem;

    procedure btnOpenFormAndCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    Procedure FillItUp;
    procedure ColorCheckBoxClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
    //20170427 Igor >>>
    FActiveRetList: TObjectList<TRetData>;
    FTitles : TstringList;
    //20170427 Igor <<<

  public
    { Public declarations }
  end;

var
  RetSum: TRetSumT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Common,T1_2026Common2,T1_2026TrimStr,
  T1_2026Declare,T1_2026ChildWinNEW,T1_2026Calc,vtTrimStr,vtShared;

procedure TRetSumT1_2026.btnOpenFormAndCloseClick(Sender: TObject);
Var
  ElmNo: integer;
  FName: String;
  s: string;
begin
  {get Retno}
  If (StringGrid1.Col < 2) or (StringGrid1.Row < 1) then
  begin
    ShowMessage('You must click first on a line below a return');
    exit;
  end;
  Fname :=MidStr(FTitles[StringGrid1.Row - 1], 49, 8);
  If (FName = '') then
    exit;
  if (Sender as TComponent).Tag = 0 then
    Close;
  s := MidStr(FTitles[StringGrid1.Row-1], 59, 3);
  If s > '   ' then
    ElmNo := MyStrToInt(s)
  else
    ElmNo :=0;
  OpenForm(FActiveRetList[StringGrid1.Col - 2].RetNo, FName, ElmNo);
  Screen.Cursor := crDefault;
end;

procedure TRetSumT1_2026.FormCreate(Sender: TObject);
begin
  FTitles := TStringList.Create;
  if FileExists(Appdir+'\T1Tls.d') then
    FTitles.LoadFromFile(Appdir+'\T1Tls.d')
  else
    MessageDlg('Missing file "T1Tls.d". Reinstalling the program will help fix this problem.', mtError, [mbOk], 0);
  FActiveRetList := TObjectList<TRetData>.Create(False);
  FillItUp;
end;

procedure TRetSumT1_2026.FormDestroy(Sender: TObject);
begin
  FTitles.Free;
  FActiveRetList.Free;
end;

Procedure TRetSumT1_2026.FillItUp;
var
  i, j: integer;
  x: real;
  StrValue: String[13];
begin
  FActiveRetList.Clear;
  for I := 0 to RetList.Count - 1 do
    if Assigned(RetList[I]) AND
       not RetList[I].Destroying AND
       not RetList[I].isAppendix AND
       (RetList[I].MyApp = AppT1_2026) then
      FActiveRetList.Add(RetList[I]);
  {Size of grid}
  StringGrid1.ColCount := 2 + FActiveRetList.Count; {columns: Title, Line and retinMem}
  StringGrid1.RowCount := 1 + FTitles.Count; {rows}
  StringGrid1.ColWidths[0] := 230;  {13 * 44;}
  StringGrid1.ColWidths[1] := 50; {for line numbers} //20190709 Igor
  For i := 2 to StringGrid1.ColCount - 1 do
    StringGrid1.ColWidths[i] := 75; { 95;} {13 * 10;}
  {StringGrid1.FixedColor := GetRetColor(RetNo);}
  {Color}
  ColorCheckBox.Checked := True;

  {Put Headings ,Names of returns on grid}
  StringGrid1.Cells[0,0] := '          T1 GENERAL';
  StringGrid1.Cells[1,0] := 'Line';
  For i := 2 to StringGrid1.ColCount-1 do
    StringGrid1.Cells[i, 0] := FetchElm(FActiveRetList[I - 2].RetNo, 'T1', 2) + ', ' +
      LeftStr(FetchElm(FActiveRetList[I - 2].RetNo, 'T1', 5), 1) + '.';

  {Put titles and lines on grid}
  for i := 0 to FTitles.Count - 1 do
  begin
    StringGrid1.Cells[0, i + 1] := LeftStr(FTitles[i], 44);
    StringGrid1.Cells[1, i + 1] := Trim(MidStr(FTitles[i], 45, 5)); //20190709 Igor
  end;

  {Put line values on grid}
  For i := 2 to StringGrid1.ColCount - 1 do
  begin
    If not FActiveRetList[I - 2].CalcStatus then
      FActiveRetList[I - 2].CalcAll;
    for j := 1 to StringGrid1.RowCount - 1 do
      if vl(Trim(MidStr(FTitles[j - 1], 45, 5))) > 0 then //20190709 Igor
      begin
        x := FActiveRetList[I - 2].Lnn[StrToInt(Trim(MidStr(FTitles[j - 1], 45, 5)))]; //20190709 Igor
        If x = 0 then
          StringGrid1.Cells[i,j] := ''
        else
        begin
          Str(x : 12 : 2, StrValue);
          If x = 0 then
            StrValue := '';
          StringGrid1.Cells[i, j] := JustRight(FormatAmount(StrValue, False), 13);
        end;
      end;
  end;
end;

procedure TRetSumT1_2026.StringGrid1DrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
begin
  If not ColorCheckBox.Checked then
    exit;

  With (Sender as TStringGrid).Canvas do
  begin
    if Col > 1 then
    begin
      if (gdSelected in State) or (gdFocused in State) then
        Brush.Color := clBlue
      else
        Brush.Color := FActiveRetList[Col - 2].RetColor;
      Font.Name := 'Arial';
      FillRect(Rect);
      if (gdSelected in State) or (gdFocused in State) then
        Font.Color := clWhite
      else
        Font.Color := ClBlack;
      TextOut(Rect.Left, Rect.Top, StringGrid1.Cells[Col, Row]);
    end;

    if (Row = 0) then
    begin
      Brush.Color := clWindow;
      FillRect(Rect);
      Font.Color := clRed;
      Font.Style := [fsBold];
      TextOut(Rect.Left, Rect.Top, StringGrid1.Cells[Col, Row]);
    end;
    if (gdFocused in State) then
      Font.Color := clWhite
    else
      Font.Color := ClBlack;
    Font.Style := [];
    //20190709 Igor >>>
    if (StringGrid1.Cells[1, Row] = '15000') or
       (StringGrid1.Cells[1, Row] = '23600') or
       (StringGrid1.Cells[1, Row] = '26000') or
       (StringGrid1.Cells[1, Row] = '33500') or
       (StringGrid1.Cells[1, Row] = '33800') or
       (StringGrid1.Cells[1, Row] = '35000') or
       (StringGrid1.Cells[1, Row] = '42800') or
       (StringGrid1.Cells[1, Row] = '43500') or
       (StringGrid1.Cells[1, Row] = '48400') or
       (StringGrid1.Cells[1, Row] = '48500')  then
    begin
      FillRect(Rect);
      Font.Color := clRed;
      Font.Style := [fsBold];
      TextOut(Rect.Left, Rect.Top, StringGrid1.Cells[Col, Row]);
    end;
    //20190709 Igor <<<
  end;

end;

procedure TRetSumT1_2026.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  btnOpenForm.Enabled := (ACol >= 2) and (ARow >= 1) and not StringGrid1.Cells[0, ARow].IsEmpty;
  btnOpenFormAndClose.Enabled := btnOpenForm.Enabled;
  miOpenForm.Enabled := btnOpenForm.Enabled;
  miOpenFormAndClose.Enabled := btnOpenForm.Enabled;
end;

procedure TRetSumT1_2026.ColorCheckBoxClick(Sender: TObject);
begin
  StringGrid1.Invalidate;
end;

end.
