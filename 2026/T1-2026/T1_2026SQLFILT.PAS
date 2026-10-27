unit T1_2026SQLFILT;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Spin,ExtCtrls,Buttons;

type
  TsqlFiltT1_2026 = class(TForm)
    Panel1: TPanel;
    Label6: TLabel;
    GroupBox7: TGroupBox;
    datadir: TComboBox;
    GroupBox1: TGroupBox;
    EFStatus: TComboBox;
    GroupBox2: TGroupBox;
    efstat: TComboBox;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpinButton1: TSpinButton;
    upddate: TEdit;
    prepby: TComboBox;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Edit2: TEdit;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit3: TEdit;
    GroupBox4: TGroupBox;
    ComboBox1: TComboBox;
    ComboBox7: TComboBox;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    Edit4: TEdit;
    Edit5: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  sqlFilt: TsqlFiltT1_2026;

implementation

{$R *.DFM}


procedure TsqlFiltT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
