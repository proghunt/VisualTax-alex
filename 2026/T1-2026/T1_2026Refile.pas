unit T1_2026Refile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, OleCtrls, Buttons, ToolWin, {Isp3,}
  ActnList, ImgList, shdocvw, Printers, Db, DBTables, ActiveX,
  T1_2026Declare, T1_2026TrimStr, {UPopList,} T1_2026Common,
  T1_2026Common2, {TeeProcs, TeEngine, Chart,}// 20160119 Igor
  T1_2026T1rtns, T1_2026Calc, T1_2026T1Rtns2,
  {URTU,} ShellApi, T1_2026ChildWinNew, {UBuild813,} FileCtrl, T1_2026EolSetup,
  T1_2026EfileRtns,

  ComObj, MsXml2_TLB, vtShape, System.Actions, uADCompClient;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  TRefileT1_2026 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    BackAction: TAction;
    ForwardAction: TAction;
    StopAction: TAction;
    RefreshAction: TAction;
    ExitProgram: TMenuItem;
    Query1: TQuery;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    LabelEfileType: TLabel;
    ExitBtn: TBitBtn;
    WebServiceserrors1: TMenuItem;
    EfileErrorMessages1: TMenuItem;
    WebBrowser1: TWebBrowser;
    CheckBoxWantToRefile: TCheckBox;
    Label1: TLabel;
    CheckBoxSectionDCompleted: TCheckBox;
    CheckBoxT1013OnFile: TCheckBox;
    SavePreamendedBtn: TBitBtn;
    Label3: TLabel;
    ReviewAmmendedAmounts: TBitBtn;
    Label6: TLabel;
    CheckBoxMadeAdjustments: TCheckBox;
    AmendFolderBox: TEdit;
    Label2: TLabel;
    Label4: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure SavePreamendedBtnClick(Sender: TObject);


  private
  end;

var
  Refile: TRefileT1_2026; // 20160119 Igor
  AmendDir,FlName:String;

  AckRec: TAckRec;
  TedFile: File of TAckRec;
  CurDispatch: IDispatch; { save the interface globally }
  RetNo: Integer;
  OnLineNo, PassWord, { EolFileName, } Url, Refund: String;
  DcnSeqNo: String;
  F1: TextFile;
  SfdNo: Integer;
  EFlines: TStringList;
  // ProdOrTest:String[1];   //global as of 20111204 in Udeclare
  CrLf: String;
  SegmentCnt: Integer;
  NetFileDir: String;
  IsBrowsePage: Boolean;

  CurrentRtn: String;

implementation

uses
  vtCommon,
  T1_2026, T1_2026main,
  vtTrimStr, vtShared, vtDataBase; // 20160119 Igor;

{$R *.DFM}

procedure TRefileT1_2026.FormCreate(Sender: TObject);
begin
 RetNo:=GetCurrentRetNo;
 AmendDir:=Ret[RetNo].SourceDataDir+'\Pre-amended';
 If DirectoryExists(AmendDir) = false then ForceDirectories(AmendDir);

 FlName:=Ret[RetNo].GetDefaultFileName;
 AmendFolderBox.Text:=AmendDir+'\'+FlName;
end;

procedure TRefileT1_2026.SavePreamendedBtnClick(Sender: TObject);
begin
  If CopyFile(Ret[RetNo].SourceDataDir+'\'+FlName, AmendDir+'\'+ FlName) Then
  begin
   ShowMessage('Return was Copied');
   Exit;
  end
  else
  begin
    ShowMessage('Return was not copied... Press any key');
    exit;
  end;
end;

procedure TRefileT1_2026.ExitBtnClick(Sender: TObject);
begin
 (*
  if (CheckBoxMadeAdjustments.checked=True)
  and (CheckBoxWantToRefile.Checked=True)
  and (CheckBoxSectionDCompleted.Checked=True)
  and (CheckBoxT1013OnFile.Checked=true)
  Then
   StoreElm(RetNo,GetFormNo('T183',12,'X')
  Else
   StorElm(RetNo,GetFormNo('T183',12,'');
  Close;
 *)
end;

end.

