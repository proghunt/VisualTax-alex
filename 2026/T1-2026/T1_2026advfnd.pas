unit T1_2026advfnd;
//imported 07-19

//New unit 20130420
interface

{$IFDEF v2013}
uses
  SysUtils,FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, DB, DBCtrls,
  Grids, DBGrids, UDECLARE,COMMOn,Common2,TrimStr,ChildWinNew,UCalc,vtEditBox;
{$ELSE}
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,ExtCtrls,DB,DBCtrls,Grids,DBGrids, Vcl.ComCtrls,
  vtFileStorage, Variants;
{$ENDIF}

type
  TMyForm = class(TScrollBox)
  private
    FCaption: String;
    FOldCreateOrder: Boolean;
    FPixelsPerInch: Integer;
    FTextHeight: Integer;
    FClientHeight: integer;
    FClientWidth: Integer;
  published
    property Caption: String read FCaption write FCaption;
    property OldCreateOrder: Boolean read FOldCreateOrder write FOldCreateOrder;
    property PixelsPerInch: Integer read FPixelsPerInch write FPixelsPerInch;
    property TextHeight: Integer read FTextHeight write FTextHeight;
    property ClientHeight: Integer read FClientHeight write FClientHeight;
    property ClientWidth: Integer read FClientWidth write FClientWidth;
  end;
  TadvfndT1_2026 = class(TForm)
    Label6: TLabel;
    ClearBtn: TBitBtn;
    Panel5: TPanel;
    Panel1: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Frm1: TEdit;
    Fld1: TEdit;
    Condition1: TComboBox;
    Value1: TEdit;
    Frm2: TEdit;
    Fld2: TEdit;
    Condition2: TComboBox;
    Value2: TEdit;
    Frm3: TEdit;
    Fld3: TEdit;
    Condition3: TComboBox;
    Value3: TEdit;
    Frm4: TEdit;
    Fld4: TEdit;
    Condition4: TComboBox;
    Value4: TEdit;
    FldType1: TComboBox;
    FldType2: TComboBox;
    FldType3: TComboBox;
    FldType4: TComboBox;
    Label12: TLabel;
    Panel3: TPanel;
    FindBtn: TBitBtn;
    BitBtn1: TBitBtn;
    FileListBox1: TFileListBox;
    doing: TLabel;
    Label14: TLabel;
    DataDirBox: TEdit;
    Label20: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label21: TLabel;
    Label23: TLabel;
    Label1: TLabel;
    Label25: TLabel;
    Sample1Btn: TBitBtn;
    Sample2Btn: TBitBtn;
    Sample3Btn: TBitBtn;
    Sample4Btn: TBitBtn;
    Label13: TLabel;
    Label19: TLabel;
    Label24: TLabel;
    BirthdateBtn: TBitBtn;
    mm: TEdit;
    dd: TEdit;
    AndOrOrBox: TRadioGroup;
    pgc: TPageControl;
    tabFilter: TTabSheet;
    pnlClosePage: TPanel;
    btnClosePage: TSpeedButton;
    procedure ListFldBt1Click(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Function EvaluateCondition(Frm: String; FldNo: Integer; FldType: String;
      Cond: String; Val: String; AF: TFileStorage; ASQLite: TSQLiteStorage): Boolean;
  //  Function EvaluateCondition(Frm:String;FldNo:Integer;ldType:String;Cond:String;Val:String;TempList:TStringList):Boolean;
    procedure Sample3BtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    Procedure DrawList;
    procedure DataDirBoxExit(Sender: TObject);
    procedure Sample2BtnClick(Sender: TObject);
    procedure Sample1BtnClick(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ShowAform(FrmName:String);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure BirthdateBtnClick(Sender: TObject);
    procedure Sample4BtnClick(Sender: TObject);
    procedure btnClosePageClick(Sender: TObject);
    procedure pgcChange(Sender: TObject);
  private
    RetNo:Integer;
  public
    { Public declarations }
  end;

var
  advfnd: TadvfndT1_2026;

implementation
{$R *.DFM}

uses
  vtEditBox,
  T1_2026,T1_2026DECLARE,T1_2026COMMOn,T1_2026Common2,T1_2026TrimStr,
  T1_2026ChildWinNew,T1_2026Calc,
  vtTrimStr,vtShared, vtMemoBox;

procedure TadvfndT1_2026.ListFldBt1Click(Sender: TObject);
begin
  (*
  InitNewReturn(RetNo);
  OpenForm(Retno,GetFormNo('T1'));
  ShowMessage('Mark the field Number down and press enter');
  RemoveReturnFromMemory(RetNo);
 *)
end;


procedure TadvfndT1_2026.pgcChange(Sender: TObject);
begin
  pnlClosePage.Visible := pgc.ActivePage <> tabFilter;
end;

procedure TadvfndT1_2026.FindBtnClick(Sender: TObject);  //20160423 Igor (All procedure)
Const
  NonNumMsg = 'Field No must be numeric';
  InvalidFrmMsg = 'Invalid Form Name';
  MxLength = 15;
Var
  Qlf1, Qlf2, Qlf3, Qlf4: Boolean;
  I: Integer;
  LastFirstName: String[45];
  Telephone: String; // 20140105
  FlName: String[12];
  AdvList: TStringList;

  F: TFileStorage;
  SQLite: TSQLiteStorage;
  Var1, Var2, Var3, Var4, FormName: String;
begin
  AdvList := TStringList.Create;
  If DirectoryExists(DataDirBox.Text) = False then
  begin
    ShowMessage('Directory does not exist');
    DataDirBox.SetFocus;
    Exit;
  end;

  Qlf1 := False;
  Qlf2 := False;
  Qlf3 := False;
  Qlf4 := False;
  If (Frm1.Text = '') and (Frm2.Text = '') and (Frm3.Text = '')
  { and (Frm4.Text ='') } then
    Exit;

  { edit data entered }
  If (Fld1.Text > '') and (Vl(Fld1.Text) = 0) then
  begin
    ShowMessage(NonNumMsg);
    Fld1.SetFocus;
    Exit;
  end;
  If (Fld2.Text > '') and (Vl(Fld2.Text) = 0) then
  begin
    ShowMessage(NonNumMsg);
    Fld2.SetFocus;
    Exit;
  end;
  If (Fld3.Text > '') and (Vl(Fld3.Text) = 0) then
  begin
    ShowMessage(NonNumMsg);
    Fld3.SetFocus;
    Exit;
  end;
  If (Fld4.Text > '') and (Vl(Fld4.Text) = 0) then
  begin
    ShowMessage(NonNumMsg);
    Fld4.SetFocus;
    Exit;
  end;

  // 20140402
  If (Frm1.Text > '') then
  Begin
    If (IsFormMultiInst(Frm1.Text)) then
    begin
      if (GetFormNo(UpperCase(ExtractNonInstFormName(Frm1.Text) + '#1')) = 0)
      then
      begin
        ShowMessage(InvalidFrmMsg);
        Frm1.SetFocus;
        Exit;
      end
    end
    Else
    Begin
      If GetFormNo(UpperCase(ExtractNonInstFormName(Frm1.Text))) = 0 then
      begin
        ShowMessage(InvalidFrmMsg);
        Frm1.SetFocus;
        Exit;
      end;
    end;
  end; // frm text

  // 20140402
  If (Frm2.Text > '') then
  Begin
    If (IsFormMultiInst(Frm2.Text)) then
    begin
      if (GetFormNo(UpperCase(ExtractNonInstFormName(Frm2.Text) + '#1')) = 0)
      then
      begin
        ShowMessage(InvalidFrmMsg);
        Frm2.SetFocus;
        Exit;
      end
    end
    Else
    Begin
      If GetFormNo(UpperCase(ExtractNonInstFormName(Frm2.Text))) = 0 then
      begin
        ShowMessage(InvalidFrmMsg);
        Frm2.SetFocus;
        Exit;
      end;
    end;
  end; // frm text

  // 20140402
  If (Frm3.Text > '') then
  Begin
    If (IsFormMultiInst(Frm3.Text)) then
    begin
      if (GetFormNo(UpperCase(ExtractNonInstFormName(Frm3.Text) + '#1')) = 0)
      then
      begin
        ShowMessage(InvalidFrmMsg);
        Frm3.SetFocus;
        Exit;
      end
    end
    Else
    Begin
      If GetFormNo(UpperCase(ExtractNonInstFormName(Frm3.Text))) = 0 then
      begin
        ShowMessage(InvalidFrmMsg);
        Frm3.SetFocus;
        Exit;
      end;
    end;
  end; // frm text

  // 20140402
  If (Frm4.Text > '') then
  Begin
    If (IsFormMultiInst(Frm4.Text)) then
    begin
      if (GetFormNo(UpperCase(ExtractNonInstFormName(Frm4.Text) + '#1')) = 0)
      then
      begin
        ShowMessage(InvalidFrmMsg);
        Frm4.SetFocus;
        Exit;
      end
    end
    Else
    Begin
      If GetFormNo(UpperCase(ExtractNonInstFormName(Frm4.Text))) = 0 then
      begin
        ShowMessage(InvalidFrmMsg);
        Frm4.SetFocus;
        Exit;
      end;
    end;
  end; // frm text

  (*
    If (Frm2.Text > '') and (GetFormNo(UpperCase(ExtractNonInstFormName(Frm2.Text)+'#1')) =0) then
    begin showMessage(InvalidFrmMsg);Frm2.SetFocus;exit;end;

    If (Frm3.Text > '') and (GetFormNo(UpperCase(ExtractNonInstFormName(Frm3.Text)+'#1')) =0) then
    begin showMessage(InvalidFrmMsg);Frm3.SetFocus;exit;end;

    If (Frm4.Text > '') and (GetFormNo(UpperCase(ExtractNonInstFormName(Frm4.Text)+'#1')) =0) then
    begin showMessage(InvalidFrmMsg);Frm4.SetFocus;exit;end;
  *)
  { read the return files }
  Screen.Cursor := crHourGlass;
  AdvList.Clear;
  for I := 0 to FileListBox1.Items.Count - 1 do
  begin
    FileListBox1.ItemIndex := I;
    FileListBox1.Refresh;
    // RetNo:=InitNewReturn;
    FlName := AllTrim(FileListBox1.Items[I]);
    If (UpperCase(FlName) <> UpperCase(ClientsDBLite)) // 20150909 Igor
      and (UpperCase(FlName) <> UpperCase(ClientsDBLite) + '-JOURNAL')
    // 20150909 Igor
    then
      Try
        if not FileExists(DataDirBox.Text + '\' + FlName) then
          continue;

        SQLite := TSQLiteStorage.Create(DataDirBox.Text, FlName, fsRead,
          AppT1_2026.SQLLitePassword.PassRFArray);
        if SQLite.LastError <> '' then
        Begin
          freeAndNil(SQLite);
          F := TFileStorage.Create(DataDirBox.Text, FlName, fsRead);
        End;
        if assigned(SQLite) then
        Begin
          if not SQLite.ReadSettings('AppName', Var1) then
          Begin
            ShowMessage(SQLite.LastError);
            Continue;
          End;
        End
        else
          F.ReadLine(Var1, Var2, Var3, Var4);
        if Var1 <> AppName then
        Begin
          if assigned(SQLite) then
            freeAndNil(SQLite);
          if assigned(F) then
            freeAndNil(F);
          Continue;
        End;

        if Assigned(SQLite) then
        Begin
          LastFirstName := SQLite.ReadData('INFO','D',5) + ' ' + SQLite.ReadData('INFO','D',2);
          Telephone := SQLite.ReadData('INFO','D',54) + ' ' + SQLite.ReadData('INFO','D',55);
        End
        else
        Begin
          LastFirstName := F.ReadData('INFO','D',5) + ' ' +F.ReadData('INFO','D',2);
          Telephone := F.ReadData('INFO','D',54) + ' ' + F.ReadData('INFO','D',55);
        End;

        { Evaluate conditions }
        Qlf1 := EvaluateCondition(Frm1.Text, MyStrToInt(Fld1.Text),
          FldType1.Text, Condition1.Text, Value1.Text, F, SQLite);
        Qlf2 := EvaluateCondition(Frm2.Text, MyStrToInt(Fld2.Text),
          FldType2.Text, Condition2.Text, Value2.Text, F, SQLite);
        Qlf3 := EvaluateCondition(Frm3.Text, MyStrToInt(Fld3.Text),
          FldType3.Text, Condition3.Text, Value3.Text, F, SQLite);
        Qlf4 := EvaluateCondition(Frm4.Text, MyStrToInt(Fld4.Text),
          FldType4.Text, Condition4.Text, Value4.Text, F, SQLite);
        { add to the list }
        // 20140402
        If AndOrOrBox.ItemIndex = 0 then // use AND
        Begin
          If Frm1.Text = '' then
            Qlf1 := True;
          If Frm2.Text = '' then
            Qlf2 := True;
          If Frm3.Text = '' then
            Qlf3 := True;
          If Frm4.Text = '' then
            Qlf4 := True;
          If (Qlf1 = True) and (Qlf2 = True) and (Qlf3 = True) and
            (Qlf4 = True) then
            AdvList.Add(PaddR(LastFirstName, MxLength) + '-' + PaddR(FlName,
              15) + Space(5) + PaddR(Telephone, 15));
        end
        else // use OR
        Begin
          If Frm1.Text = '' then
            Qlf1 := False;
          If Frm2.Text = '' then
            Qlf2 := False;
          If Frm3.Text = '' then
            Qlf3 := False;
          If Frm4.Text = '' then
            Qlf4 := False;
          If (Qlf1 = True) Or (Qlf2 = True) Or (Qlf3 = True) Or (Qlf4 = True)
          then
            AdvList.Add(PaddR(LastFirstName, MxLength) + '-' + PaddR(FlName,
              15) + Space(5) + PaddR(Telephone, 15));
        end;

      Except
      end;
      if Assigned(SQLite) then
        freeAndNil(SQLite);
      if Assigned(F) then
        freeAndNil(F);
  end; { end db scan }
  doing.Caption := 'All Done';
  SomeList.Clear;
  SomeList.AddStrings(AdvList);
  ShowMessage('All returns checked' + Chr(13) + IntToStr(SomeList.Count) +
    ' returns meet the filter criteria');
  AdvList.Free;
  Screen.Cursor := crDefault;
  Close;
end;


Function TadvfndT1_2026.EvaluateCondition(Frm: String; FldNo: Integer;  //20160423 Igor (All function)
  FldType: String; Cond: String; Val: String; AF: TFileStorage;
  ASQLite: TSQLiteStorage): Boolean;
Var
  ReturnValue:String;
begin
  If Frm ='' then
  begin
    Result :=True;
    exit;
  end;
  Result :=False;
  Frm := UpperCase(AllTrim(Frm));
  If FldType = 'Amount' then
  begin
    if Assigned(ASQLite) then
    Begin
      ReturnValue := AllTrim(ASQLIte.ReadData(Frm,'D',FldNo));
    End
    else
    Begin
      ReturnValue := AllTrim(AF.ReadData(Frm,'D',FldNo));
    End;
    Val := AllTrim(Val);
    If (Cond = '>') then
      If Vl(ReturnValue) > Vl(Val) then
        result :=true;
    If (Cond = '=') then
      If Vl(ReturnValue) = Vl(Val) then
        result :=true;
    If (Cond = '<') then
      If Vl(ReturnValue) < Vl(Val) then
        result :=true;
    If (Cond = '>=') then
      If Vl(ReturnValue) >= Vl(Val) then
        result :=true;
    If (Cond = '<=') then
      If Vl(ReturnValue) <= Vl(Val) then
        result :=true;
  end;

  If FldType = 'Character' then
  begin
    if Assigned(ASQLite) then
    Begin
      ReturnValue := AllTrim(UpperCase(ASQLIte.ReadData(Frm,'D',FldNo)));
    End
    else
    Begin
      ReturnValue := AllTrim(UpperCase(AF.ReadData(Frm,'D',FldNo)));
    End;
    If Length(Val)>0 then
      ReturnValue := LeftStr(ReturnValue,length(Val));

    Val := AllTrim(UpperCase(Val));
    If (Cond = '>') then
      If ReturnValue > Val then
        result :=true;
    If (Cond = '=') then
      If ReturnValue = Val then
        result :=true;
    If (Cond = '<') then
      If ReturnValue < Val then
        result :=true;
    If (Cond = '>=') then
      If ReturnValue >= Val then
        result :=true;
    If (Cond = '<=') then
      If ReturnValue <= Val then
        result :=true;
  end;
end;

procedure TadvfndT1_2026.FormCreate(Sender: TObject);
Var i:Integer; Dt: String;
begin
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
    ListBox2.Items.Add(Frec.FormName+Frec.FormInst);
 end;
 DataDirBox.Text := OptRec.Dir_Cur;
 Doing.Caption :='';
 DrawList;

 Dt:= FormatDateTime('yyyy-mm-dd',Date);
 If mm.text='' then mm.text:=MidStr(Dt,6,2);
 If dd.text='' then dd.text:=MidStr(Dt,9,2);
 ClearBtnClick(Sender);  //20140105

(*
Sample1BtnClick(Sender);
Table2.DataBaseName := AppDir;
Table2.TableName := T1SCR.DB F;
Table2.IndexName := 'FormName';    //20130420
If not Table2.Active then Table2.Open;
DataDirBox.Text := OptRec.Dir_Cur;
Doing.Caption :='';
DrawList;
ClearBtnClick(Sender);  //20140105
*)
end;

Procedure TadvfndT1_2026.DrawList;
begin
 FileListBox1.Directory := DataDirBox.Text;
 FileListBox1.Mask := '*.*';
 FileListBox1.ItemIndex :=0;
end;


procedure TadvfndT1_2026.Sample3BtnClick(Sender: TObject);
begin
ClearBtnClick(Sender);

Frm1.Text := 'INFO';Fld1.Text := '64';
FldType1.text := 'Character';Condition1.text := '=';
Value1.Text :='';
end;

procedure TadvfndT1_2026.ClearBtnClick(Sender: TObject);
begin
 Frm1.Text := ''; Fld1.Text := ''; FldType1.text := 'Amount';
 Condition1.text := '>'; Value1.Text :='';
Frm2.Text := ''; Fld2.Text := ''; FldType2.text := 'Amount';
 Condition2.text := '>'; Value2.Text :='';
Frm3.Text := ''; Fld3.Text := ''; FldType3.text := 'Amount';
 Condition3.text := '>'; Value3.Text :='';
Frm4.Text := ''; Fld4.Text := ''; FldType4.text := 'Amount';
 Condition4.text := '>'; Value4.Text :='';
end;

procedure TadvfndT1_2026.BitBtn1Click(Sender: TObject);
begin
//InitFormsTable; //re-initialize
Close;
end;

procedure TadvfndT1_2026.btnClosePageClick(Sender: TObject);
begin
  if pgc.ActivePage = tabFilter then exit;
  while pgc.ActivePage.ControlCount > 0 do
    pgc.ActivePage.Controls[0].Free;
  pgc.ActivePage.Free;
  pgc.ActivePage := tabFilter;
  pgcChange(pgc);
end;

procedure TadvfndT1_2026.DataDirBoxExit(Sender: TObject);
begin
 If DataDirBox.Text = OptRec.Dir_Cur then exit;
 DrawList;
end;

procedure TadvfndT1_2026.Sample2BtnClick(Sender: TObject);
begin
ClearBtnClick(Sender);
Frm1.Text := 'INFO';Fld1.Text := '11';
FldType1.text := 'Character';Condition1.text := '=';
Value1.Text :='X';

Frm2.Text := 'INFO';Fld2.Text := '30';
FldType2.text := 'Character';Condition2.text := '=';
Value2.Text :='X';
end;

procedure TadvfndT1_2026.Sample1BtnClick(Sender: TObject);
begin
ClearBtnClick(Sender);
Frm1.Text := 'INFO';Fld1.Text := '15';
FldType1.text := 'Character';Condition1.text := '=';
Value1.Text :='L4W';
end;

procedure TadvfndT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

procedure TadvfndT1_2026.ShowAform(FrmName:String);
Var
  aForm: TMyForm;
  j: Integer;
  TS: TTabSheet;
begin
  for j := 1 to pgc.PageCount - 1 do
  Begin
    if pgc.Pages[J].Caption = FrmName then
    Begin
      pgc.ActivePage := pgc.Pages[J];
      exit;
    End;
  end;
  TS := TTabSheet.Create(Self);
  TS.Caption := FrmName;
  TS.PageControl := pgc;
//  SB := TScrollbox.Create(Self);
//  SB.Parent := TS;
//  SB.Align := alClient;
  AForm := TMyForm.Create(TS);
  AForm.Parent := TS;
  try
    Classes.ReadComponentResFile(GetDfmFileName(FrmName), AForm);
  except ON E: Exception DO
    Begin
      ShowMessage('Form '+FrmName + ' is damaged. Contact VisualTax'+#13+E.Message);
      freeAndNil(AForm);
      freeAndNil(TS);
      exit;
    End;
  end;
  AForm.Align := alClient;

//  AForm.AutoSize := True;
  For j:=0 to AForm.ComponentCount-1 do
  begin
    if AForm.Components[j] is TvtEdit then
    begin
      with TvtEdit(AForm.Components[j]) do
      begin
        Text := IntToStr(GetFieldId(Name));
        ReadOnly := True;
      end;
    end
    else
    if AForm.Components[j] is TvtMemo then
    begin
      with TvtMemo(AForm.Components[j]) do
      begin
        Lines.Text := IntToStr(GetFieldId(Name));
        ReadOnly := True;
      end;
    end
    else
    if AForm.Components[j] is TFrame then
    begin
      (AForm.Components[j] as TFrame).Enabled := False;
    end;
  end;
  pgc.ActivePage := TS;
  pgcChange(pgc);
end;

procedure TadvfndT1_2026.ListBox1Click(Sender: TObject);
Var FrmName:String;
begin
 If ListBox1.ItemIndex>-1 then
 begin
   FrmName:=ListBox1.Items.Strings[ListBox1.ItemIndex];
   If FrmName>'' then ShowAform(FrmName);
 end;

end;

procedure TadvfndT1_2026.ListBox2Click(Sender: TObject);
Var FrmName:String;
begin
 If ListBox2.ItemIndex>-1 then
 begin
   FrmName:=ListBox2.Items.Strings[ListBox2.ItemIndex];
   If FrmName>'' then ShowAform(FrmName);
 end;
end;

procedure TadvfndT1_2026.ListBox1DblClick(Sender: TObject);
Var FrmName:String;
begin
 If ListBox1.ItemIndex>-1 then
 begin
   FrmName:=ListBox1.Items.Strings[ListBox1.ItemIndex];
   If FrmName>'' then ShowAform(FrmName);
 end;
end;

procedure TadvfndT1_2026.ListBox2DblClick(Sender: TObject);
Var FrmName:String;
begin
 If ListBox2.ItemIndex>-1 then
 begin
   FrmName:=ListBox2.Items.Strings[ListBox2.ItemIndex];
   If FrmName>'' then ShowAform(FrmName);
 end;
end;

procedure TadvfndT1_2026.BirthdateBtnClick(Sender: TObject);
begin
Frm1.Text := 'INFO';Fld1.Text := '200';
FldType1.text := 'Character';Condition1.text := '=';
Value1.Text :=PaddZero(mm.text,2);

Frm2.Text := 'INFO';Fld2.Text := '201';
FldType2.text := 'Character';Condition2.text := '=';
Value2.Text :=PaddZero(dd.text,2);


end;

procedure TadvfndT1_2026.Sample4BtnClick(Sender: TObject);
begin
ClearBtnClick(Sender);

Frm1.Text := 'INFO';Fld1.Text := '64';
FldType1.text := 'Character';Condition1.text := '>';
Value1.Text :='';

end;

end.
