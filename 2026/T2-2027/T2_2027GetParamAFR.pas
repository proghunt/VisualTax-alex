unit T2_2027GetParamAFR;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  Buttons, ExtCtrls;

type
  TGetParamAFR = class(TForm)
    BottomPanel: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    pnlMain: TPanel;
    Label1: TLabel;
    pnlReturnDataFileAll: TPanel;
    cbReturnDataFile: TCheckBox;
    pnlReturnDataFile: TPanel;
    lblReturnDataFile: TLabel;
    cboxReturnDataFile: TComboBox;
    pnlReturnBalances: TPanel;
    cbReturnBalances: TCheckBox;
    pnlCorporationBalances: TPanel;
    cbAccountBalances: TCheckBox;
    pnlBNData: TPanel;
    cbBNData: TCheckBox;
    pnlNOA: TPanel;
    cbNOA: TCheckBox;
    Panel2: TPanel;
    lblNOA: TLabel;
    cboxNOA: TComboBox;
    pnlSelect: TPanel;
    rbAutofill: TRadioButton;
    rbNOA: TRadioButton;
    rbBoth: TRadioButton;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbReturnDataFileClick(Sender: TObject);
    procedure cbNOAClick(Sender: TObject); //20220608 Igor
    procedure rbAutofillClick(Sender: TObject); //20220609 Igor
    procedure FormShow(Sender: TObject); //20220609 Igor
    procedure cbDisabledClick(Sender: TObject); //20220610 Igor
  private
    procedure RefreshCheckBoxes; //20220609 Igor
  public
    procedure SetTYEList(aTYEList: TStringList);
    procedure SetNOAList(aNOAList: TStringList); //20220608 Igor
  end;

function GetParamAFR(const aTYEList: TStringList; out aTYE: string; out aT2ReturnBalanceIndicator,
  aCorporationAccountBalanceIndicator, aCorporationBNDataIndicator: boolean;
  const aNOAList: TStringList; out aNOA: string): boolean; //20220608 Igor

implementation

{$R *.DFM}

uses
  vtMulti, vtTrimStr, vtForm;

function GetParamAFR(const aTYEList: TStringList; out aTYE: string; out aT2ReturnBalanceIndicator,
  aCorporationAccountBalanceIndicator, aCorporationBNDataIndicator: boolean;
  const aNOAList: TStringList; out aNOA: string): boolean; //20220608 Igor
var
  aFrm: TGetParamAFR;
begin
  aFrm := TGetParamAFR.Create(Application.MainForm);
  try
    aFrm.SetTYEList(aTYEList);
    aFrm.SetNOAList(aNOAList); //20220608 Igor
    Result := aFrm.ShowModal = mrOk;
    if Result then
    begin
      if aFrm.cbReturnDataFile.Checked then
        aTYE := aFrm.cboxReturnDataFile.Text;
      aT2ReturnBalanceIndicator := aFrm.cbReturnBalances.Checked;
      aCorporationAccountBalanceIndicator := aFrm.cbAccountBalances.Checked;
      aCorporationBNDataIndicator := aFrm.cbBNData.Checked;
      //20220608 Igor >>>
      if aFrm.cbNOA.Checked then
        aNOA := aFrm.cboxNOA.Text;
      //20220608 Igor <<<
    end;
  finally
    aFrm.Free;
  end;
end;


procedure TGetParamAFR.OKBtnClick(Sender: TObject);
begin
  //20220608 Igor >>>
  if (cbReturnDataFile.Checked) and (cboxReturnDataFile.Text = '') then
  begin
    ShowMessage('Select "Tax Year End" for T2 Returns data file please.');
    ModalResult := mrNone;
  end
  else if (cbNOA.Checked) and (cboxNOA.Text = '') then
  begin
    ShowMessage('Select "Tax Year End" for T2 Available NOA please.');
    ModalResult := mrNone;
  end
  //20220608 Igor <<<
  else
    ModalResult := mrOK;
end;

procedure TGetParamAFR.rbAutofillClick(Sender: TObject);
begin
  RefreshCheckBoxes;
end;

procedure TGetParamAFR.RefreshCheckBoxes; //20220609 Igor
begin
  cbReturnDataFile.Checked := rbAutofill.Checked or rbBoth.Checked;
  cbReturnBalances.Checked := cbReturnDataFile.Checked;
  cbAccountBalances.Checked := cbReturnDataFile.Checked;
  cbBNData.Checked := cbReturnDataFile.Checked;
  cbNOA.Checked := rbNOA.Checked or rbBoth.Checked;
  cbReturnDataFileClick(cbReturnDataFile);
  cbNOAClick(cbNOA);
end;

procedure TGetParamAFR.SetNOAList(aNOAList: TStringList); //20220608 Igor
var
  I: Integer;
begin
  cboxNOA.Items.Clear;
  cboxNOA.Items.AddStrings(aNOAList);
  cboxNOA.Sorted := True;
  cboxNOA.ItemIndex := cboxNOA.Items.Count - 1;
end;

procedure TGetParamAFR.SetTYEList(aTYEList: TStringList);
var
  I: Integer;
begin
  cboxReturnDataFile.Items.Clear;
  cboxReturnDataFile.Items.AddStrings(aTYEList);
  cboxReturnDataFile.Sorted := True;
  cboxReturnDataFile.ItemIndex := cboxReturnDataFile.Items.Count - 1;
end;

procedure TGetParamAFR.cbDisabledClick(Sender: TObject); //20220610 Igor
begin
  RefreshCheckBoxes;
end;

procedure TGetParamAFR.cbNOAClick(Sender: TObject); //20220608 Igor
begin
  cboxNOA.Enabled := cbNOA.Checked;
  lblNOA.Enabled := cboxNOA.Enabled;
end;

procedure TGetParamAFR.cbReturnDataFileClick(Sender: TObject);
begin
  cboxReturnDataFile.Enabled := cbReturnDataFile.Checked;
  lblReturnDataFile.Enabled := cboxReturnDataFile.Enabled;
end;

procedure TGetParamAFR.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    CancelBtnClick(Self);
  end;
end;

procedure TGetParamAFR.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    OKBtnClick(nil);
  end;
end;

procedure TGetParamAFR.FormShow(Sender: TObject); //20220609 Igor
begin
  RefreshCheckBoxes;
end;

procedure TGetParamAFR.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

