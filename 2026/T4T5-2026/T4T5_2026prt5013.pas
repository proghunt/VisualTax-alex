unit T4T5_2026prt5013;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,CheckLst;

type
  TPrT5013T4T5_2026 = class(TForm)
    Label2: TLabel;
    NumOfT5013Slips: TEdit;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    ListBox1: TListBox;
    Label1: TLabel;
    SlipSelected: TRadioGroup;
    Label5: TLabel;
    CopySelected: TRadioGroup;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
  PrT5013: TPrT5013T4T5_2026;

implementation

{$R *.DFM}
uses
  vtMulti, vtCommon,
  T4T5_2026, T4T5_2026Main,T4T5_2026ChildWinNew,T4T5_2026Declare,T4T5_2026TrimStr,
  vtTrimStr, vtShared,
  Printers; //20160905 igor

end.
