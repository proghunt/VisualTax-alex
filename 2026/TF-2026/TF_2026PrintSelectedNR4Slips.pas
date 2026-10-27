unit TF_2026PrintSelectedNR4Slips;

interface
//20170628 Igor (rebuild all unit. use this unit for print any multiInst forms)
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Mask, vtEditBox, vtLabel, vtShape, Buttons,
  CheckLst, vtMulti;

type
  TPrintMultiInstProcedure = reference to procedure(ARetNo, APrintKind: Integer; ASelectedForms: TFRecArray);

  TPrintSelectedNR4SlipsTF_2026 = class(TForm)
    CheckListBox1: TCheckListBox;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    selectedNr4SlipRecipient: TRadioGroup;
    PrintDialogItem: TPrintDialog;
    Panel2: TPanel;
    chbCkeckAll: TCheckBox;
    procedure OKBtnClick(Sender: TObject);
    procedure chbCkeckAllClick(Sender: TObject);
  private
    { Private declarations }
    FNR4: TFRecArray;
    FRetNo: Integer;
    FDopFieldForRowCaprion: Integer;
    FNonInstFormName: String;
    FPrintTypes: TArray<String>;
    FPrintProcedure: TPrintMultiInstProcedure;
    procedure Init;
  public
    { Public declarations }
  end;
//var
//  PrintSelectedNR4Slips: TPrintSelectedNR4SlipsTF_2026;

procedure PrintMultiInstForms(ACaption, ANonInstFormName: String;
  ADopFieldForRowCaprion, ARetNo: Integer; APrintTypes: TArray<String>;
  APrintProcedure: TPrintMultiInstProcedure);
implementation

uses
  vtShared, vtTrimStr;
//  vtCommon, TF_2026, TF_2026print, TF_2026Declare, TF_2026common, TF_2026TrimStr,
//  TF_2026ChildwinNew, TF_2026Common2, TF_2026main, vtTrimStr, vtShared;

{$R *.DFM}

procedure PrintMultiInstForms(ACaption, ANonInstFormName: String;
  ADopFieldForRowCaprion, ARetNo: Integer; APrintTypes: TArray<String>;
  APrintProcedure: TPrintMultiInstProcedure);
begin
  With  TPrintSelectedNR4SlipsTF_2026.Create(Application) do
  begin
    try
      Caption := ACaption;
      FDopFieldForRowCaprion := ADopFieldForRowCaprion;
      FRetNo := ARetNo;
      FPrintTypes := APrintTypes;
      FNonInstFormName := ANonInstFormName;
      FPrintProcedure := APrintProcedure;
      Init;
      ShowModal;
    finally
      free;
    end;
  end;
end;

procedure TPrintSelectedNR4SlipsTF_2026.Init;
var
  R: TFRec;
  S: String;
  I, W: Integer;
  function RowCaption: String;
  begin
    if FDopFieldForRowCaprion > 0 then
      Result := PaddR(R.FormInstName, 10) + ' ' + RetList[FRetNo].Frm[R.FormNo].Elms[FDopFieldForRowCaprion]
    else
      Result := R.FormInstName;
  end;
begin
  FNR4 := RetList[FRetNo].FList.GetAllInstForms(FNonInstFormName);
  For R in FNR4 do
    CheckListBox1.Items.AddObject(RowCaption, R);
  CheckListBox1.ItemIndex := 0;
  chbCkeckAll.Checked := True;
  chbCkeckAllClick(chbCkeckAll);

  selectedNr4SlipRecipient.Items.Clear;
  for S in FPrintTypes do
    selectedNr4SlipRecipient.Items.Add(S);
  selectedNr4SlipRecipient.ItemIndex := 0;
  selectedNr4SlipRecipient.Height := length(FPrintTypes) * 24 + 18;
  W := Canvas.TextWidth(Caption);
  for S in CheckListBox1.Items do
  begin
    I := Canvas.TextWidth(S);
    if W < I then
      W := I;
  end;
  ClientWidth := W + 16 + Panel1.Width;
end;

procedure TPrintSelectedNR4SlipsTF_2026.chbCkeckAllClick(Sender: TObject);
begin
  CheckListBox1.CheckAll(chbCkeckAll.State, False, True);
end;

procedure TPrintSelectedNR4SlipsTF_2026.OKBtnClick(Sender: TObject);
var
  FInst, FNonInst: String;
  i, FNo: integer;
begin
  SetLength(FNR4, 0);
  for I := 0 to CheckListBox1.Items.Count - 1 do
    if CheckListBox1.Checked[i] then
    begin
      SetLength(FNR4, Length(FNR4) + 1);
      FNR4[Length(FNR4) - 1] := TFRec(CheckListBox1.Items.Objects[I]);
    end;
  if length(FNR4) = 0 then
  begin
    MessageDlg('No slips where selected for printing.', mtWarning, [mbOk], 0);
    exit;
  end;
  if Assigned(FPrintProcedure) then
    FPrintProcedure(FRetNo, selectedNr4SlipRecipient.ItemIndex, FNR4);
end;

end.
