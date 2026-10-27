unit fraClientFiles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ImgList, System.Generics.Collections,
  Vcl.ExtCtrls, Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls, ShellAPI, ShlObj,
  Vcl.Imaging.Jpeg, Vcl.Imaging.GIFImg, Vcl.Imaging.PngImage, Vcl.Menus,
  ActiveX, AcroPDFLib_TLB, Vcl.Buttons, System.Masks, StrUtils,
  vtMulti, vtCommon, Vcl.OleCtnrs, vtPDFPrinter;

type

  TPreviewKind = (pkTXT, pkHTML, pkPDF, pkRTF, pkMSOffice, pkImage, pkOther);
  TMode = (mClientDocuments, mAutoFill);

  TSelectableNode = class
  private
    FSelected: Boolean;
  public
    procedure ReloadNode(AItem: TTreeNode; AOnlySlips: Boolean; AReloadChild: Boolean = True); virtual; abstract;
    property Selected: Boolean read FSelected write FSelected;
  end;

  TAutoFillItem = class
  private
    FFormName: String;
    FElementName: String;
    FInstanse: Integer;
    FRowNo: Integer;
    FValue: String;
    FVTMapElement: TVTMapElement;
  protected
  public
    constructor Create(const AFormName, AElementName: String;
      const AInstanse, ARowNo: Integer; const AValue: String);
    destructor Destroy; override;
    property FormName: string read FFormName write FFormName;
    property ElementName: String read FElementName write FElementName;
    property Instanse: Integer read FInstanse write FInstanse;
    property Value: String read FValue write FValue;
    property RowNo: Integer read FRowNo write FRowNo;
    property VTMapElement: TVTMapElement read FVTMapElement write FVTMapElement;
    function FullName: String;
  end;

  TAutoFillItems = TObjectList<TAutoFillItem>;

  TAutoFillGroup = class(TSelectableNode)
  private
    FAutoFillItems: TAutoFillItems;
    FGroupName: String;
    FSubGroupName: String;
    FInstanseCount: Integer;
  protected
  public
    constructor Create(const AGroupName, ASubGroupName: String; ASelected: Boolean);
    destructor Destroy; override;
    procedure ReloadNode(AItem: TTreeNode; AOnlySlips: Boolean; AReloadChild: Boolean = True); override;
    procedure ReloadListItems(AItems: TListItems; AFilter: String);
    property GroupName: String read FGroupName write FGroupName;
    property SubGroupName: String read FSubGroupName write FSubGroupName;
    property AutoFillItems: TAutoFillItems read FAutoFillItems;
    property InstanseCount: Integer read FInstanseCount write FInstanseCount;
    function GetElementCount(AInstance: Integer; AFormName, AElementName: String): Integer;
  end;

  TAutoFillGroups = TObjectList<TAutoFillGroup>;

  TAutoFillReturn = class(TSelectableNode)
  private
    FAutoFillGroups: TAutoFillGroups;
    FLastName: String;
    FSIN: String;
  protected
  public
    constructor Create(const ASIN: String);
    destructor Destroy; override;
    procedure ReloadNode(AItem: TTreeNode; AOnlySlips: Boolean; AReloadChild: Boolean = True); override;
    procedure ReloadListItems(AItems: TListItems; AOnlySlips: Boolean; AFilter: String);
    property AutoFillGroups: TAutoFillGroups read FAutoFillGroups;
    function FindGroupBySubGroupName(ASubGroupName: String; var AGroup: TAutoFillGroup): Boolean;
    property LastName: String read FLastName write FLastName;
    property SIN: String read FSIN write FSIN;
    function FullName: String;
  end;
  TAutoFillReturns = TObjectList<TAutoFillReturn>;

  TAutoFillFile = class
  private
    FAutoFillReturns: TAutoFillReturns;
    FFileName: String;
    procedure DoLoad(AList: TStrings);
    function ExtractSin: String;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(AFileName: String);
    procedure ReloadGUI(AItems: TTreeNodes; AOnlySlips: Boolean); overload;
    procedure ReloadGUI(AItems: TListItems; AOnlySlips: Boolean; AFilter: String); overload;
    property AutoFillReturns: TAutoFillReturns read FAutoFillReturns;
    function FindReturnByName(ASIN: String; var AReturn: TAutoFillReturn): Boolean;
    property FileName: String read FFileName;
  end;


  TScanFolderThread = class(TThread)
  private
    FFolder: String;
    FMask: String;
    FTreeView: TTreeView;
    FOnDestroy: TNotifyEvent;
    FIcns: TDictionary<HICON,Integer>;
    FIcnsExt: TDictionary<String,Integer>;
    function AddNode(AFileName, AFullPath: String; AFileAttr: Integer; AParentNode: TTreeNode): TTreeNode;
  protected
    procedure Execute; override;
  public
    constructor Create(AFolder, AMask: String; ATreeView: TTreeView; AOnDestroy: TNotifyEvent); overload;
    destructor Destroy; override;
  end;

  TClientFilesFrame = class(TFrame)
    tvFileList: TTreeView;
    ilFileIcons: TImageList;
    pnlPreviewContainer: TPanel;
    splTree_Preview: TSplitter;
    pgcPreview: TPageControl;
    tsText: TTabSheet;
    tsHTML: TTabSheet;
    tsPDF: TTabSheet;
    tsRTF: TTabSheet;
    tsMSOffice: TTabSheet;
    tsImage: TTabSheet;
    tsOther: TTabSheet;
    mmoPreviewText: TMemo;
    wbPreviewHTML: TWebBrowser;
    imgPreview: TImage;
    rePreview: TRichEdit;
    tsFolder: TTabSheet;
    lvFolder: TListView;
    tmrPreview: TTimer;
    btnOpenFolder: TButton;
    btnExecuteFile: TButton;
    imgIcon: TImage;
    lblFileName: TLabel;
    pmFileActions: TPopupMenu;
    mniShowinexplorer: TMenuItem;
    mniOpen: TMenuItem;
    pnlPreviewFileName: TPanel;
    panPDF: TPanel;
    btnRefresh: TSpeedButton;
    tsAutoFill_Tree: TTabSheet;
    tvAutoFill: TTreeView;
    pnlAutoFillTools: TPanel;
    btnGoToElement: TSpeedButton;
    btnApplyElement: TSpeedButton;
    btnApplyForm: TSpeedButton;
    btnApplyFile: TSpeedButton;
    ocMSOffice: TOleContainer;
    sbDOC: TScrollBox;
    N1: TMenuItem;
    mniRename: TMenuItem;
    mniDelete: TMenuItem;
    mniCopy: TMenuItem;
    mniPaste: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    mniCreateFolder: TMenuItem;
    tsAutoFill_List: TTabSheet;
    pnlAutoFillTools2: TPanel;
    rbAutoFillDataSlipsOnly: TRadioButton;
    rbAutoFillDataAll: TRadioButton;
    btnAutoFillPrint: TButton;
    lvAotoFillData: TListView;
    pnlAutoFillFilter: TPanel;
    lblAutoFillSerch: TLabel;
    edtAutoFillSearch: TEdit;
    rbAutoFillFilter: TRadioButton;
    rbAutoFillLocate: TRadioButton;
    procedure tvFileListChange(Sender: TObject; Node: TTreeNode);
    procedure lvFolderDblClick(Sender: TObject);
    procedure tmrPreviewTimer(Sender: TObject);
    procedure btnOpenFolderClick(Sender: TObject);
    procedure btnExecuteFileClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure tvFileListCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure tvAutoFillMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvAutoFillChange(Sender: TObject; Node: TTreeNode);
    procedure btnGoToElementClick(Sender: TObject);
    procedure btnApplyElementClick(Sender: TObject);
    procedure btnApplyFormClick(Sender: TObject);
    procedure btnApplyFileClick(Sender: TObject);
    procedure pmFileActionsPopup(Sender: TObject);
    procedure mniPasteClick(Sender: TObject);
    procedure mniCreateFolderClick(Sender: TObject);
    procedure mniCopyClick(Sender: TObject);
    procedure mniRenameClick(Sender: TObject);
    procedure tvFileListEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure mniDeleteClick(Sender: TObject);
    procedure rbAutoFillDataAllClick(Sender: TObject);
    procedure edtAutoFillSearchChange(Sender: TObject);
    procedure rbAutoFillFilterClick(Sender: TObject);
    procedure btnAutoFillPrintClick(Sender: TObject);
  private
    { Private declarations }
    FRootPath: String;
    FScanFolderThread: TScanFolderThread;
    FUpdate: Integer;
    FTryPdfLoad: Boolean;
    FMode: TMode;
    FOwnedAutoFile: String;
    FOwnedAutoFileName: String;
    FLocateAfterFill: String;
    FAutoFillFile: TAutoFillFile;
    FAcroPDF: TAcroPDF;
    FApp: TApp; // 20180530 Igor
    procedure SetRootPath(const Value: String);
    procedure ThreadDestroy(Sender: TObject);
    procedure WaitScanThread;
    function GetFullPath(Node: TTreeNode): String;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure ShowPDF(const AFileName: String);
    procedure ShowMSOffice(const AFileName: String);
    procedure ClearPreview;
    procedure SetOwnedAutoFile(const Value: String);
    function GetFileMasks: String;
    function GetCurrentNode: TTreeNode;
    function GetCurrDir: String;
    function DoMove(const ASrc, ADstPath, ADstName: String): Boolean;
    procedure LocateAutoFill(const ASearchText: String);
    procedure ResizeReviewPanel;
  protected
  //20170727 Igor>>>
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  //20170727 Igor<<<

  public
    { Public declarations }
    destructor Destroy; override;
    procedure Init(AParentControl: TWinControl; AFolder: String); overload;
    procedure Init(AParentControl: TWinControl; AFolder, AOwnedAutoFile: String; AApp: TApp); overload; // 20180530 Igor
    property RootPath: String read FRootPath write SetRootPath;
    property OwnedAutoFile: String read FOwnedAutoFile write SetOwnedAutoFile;
    property App: TApp read FApp write FApp; // 20180530 Igor
    procedure RefillList;
    function Locate(AFileName: String): Boolean;
  end;

const
  OFASI_EDIT = $0001;
  OFASI_OPENDESKTOP = $0002;

{$IFDEF UNICODE}
function ILCreateFromPath(pszPath: PChar): PItemIDList stdcall; external shell32
  name 'ILCreateFromPathW';
{$ELSE}
function ILCreateFromPath(pszPath: PChar): PItemIDList stdcall; external shell32
  name 'ILCreateFromPathA';
{$ENDIF}
procedure ILFree(pidl: PItemIDList) stdcall; external shell32;
function SHOpenFolderAndSelectItems(pidlFolder: PItemIDList; cidl: Cardinal;
  apidl: pointer; dwFlags: DWORD): HRESULT; stdcall; external shell32;

implementation

{$R *.dfm}

uses
  CommCtrl, IOUtils, SyncObjs, vtTrimStr, clipbrd, fCaseDo;
var
  CS: TCriticalSection;

const
  CheckedImageIndexes: array[Boolean] of Integer = (1, 2);

procedure ApplyItem(AItem: TAutoFillItem; APopulate: Boolean = True);
var
  FormName: String;
  ElementNo: Integer;
  M: TVTElement;
  V: String;
begin
  for M in AItem.VTMapElement do
  begin
    V := AItem.Value;
    M.GetRealTarget(AItem.Instanse, AItem.RowNo, FormName, ElementNo, V);
    if RetList[GetCurrentRetNo].FList.ByFormName(FormName).FormNo = 0 then
    begin
      if AItem.Instanse > 0 then
      begin
        if RetList[GetCurrentRetNo].FList.AddPageInstance(GetCurrentRetNo,
            ExtractNonInstFormName(FormName), ExtractFormInst(FormName)) = 0 then
          raise Exception.Create('Form "'+FormName+'" not found!');
      end;
    end;

    StoreElm(GetCurrentRetNo, FormName, ElementNo, V);
  end;
  if APopulate then
  begin
    RetList[GetCurrentRetNo].CalcAll;
    RetList[GetCurrentRetNo].MyChild.ActiveForm.PopulateFormWithData;
  end;
end;

procedure ApplyGroup(AGroup: TAutoFillGroup; APopulate: Boolean = True);
var
  I: TAutoFillItem;
begin
  for I in  AGroup.AutoFillItems do
    ApplyItem(I, False);
  if APopulate then
  begin
    RetList[GetCurrentRetNo].CalcAll;
    RetList[GetCurrentRetNo].MyChild.ActiveForm.PopulateFormWithData;
  end;
end;

procedure ApplyReturn(AReturn: TAutoFillReturn);
var
  G: TAutoFillGroup;
begin
  for G in  AReturn.AutoFillGroups do
    ApplyGroup(G, False);
  RetList[GetCurrentRetNo].CalcAll;
  RetList[GetCurrentRetNo].MyChild.ActiveForm.PopulateFormWithData;
end;

function ExtractPreview(AExt: String): TPreviewKind;
begin
  if SameText(AExt, '.txt') then
    Result := pkTXT
  else
  if SameText(AExt, '.htm') or
     SameText(AExt, '.html') or
     SameText(AExt, '.xml') or
     SameText(AExt, '.xsl') then
    Result := pkHTML
  else
  if SameText(AExt, '.pdf') then
    Result := pkPDF
  else
  if SameText(AExt, '.rtf') then
    Result := pkRTF
  else
  if SameText(AExt, '.doc') or
     SameText(AExt, '.docx') then
    Result := pkMSOffice
  else
  if SameText(AExt, '.xls') or
     SameText(AExt, '.xlsx') then
    Result := pkMSOffice
  else
  if SameText(AExt, '.gif') or
     SameText(AExt, '.cur') or
     SameText(AExt, '.pcx') or
     SameText(AExt, '.ani') or
     SameText(AExt, '.png') or
     SameText(AExt, '.jpg') or
     SameText(AExt, '.jpeg') or
     SameText(AExt, '.gif') or
     SameText(AExt, '.tif') or
     SameText(AExt, '.tiff') or
     SameText(AExt, '.bmp') or
     SameText(AExt, '.tif') or
     SameText(AExt, '.tiff') or
     SameText(AExt, '.ico') or
     SameText(AExt, '.emf') or
     SameText(AExt, '.wmf') then
    Result := pkImage
  else
    Result := pkOther;
end;

function ItemContainText(AItem: TListItem; AText: String): Boolean;
var
  S: String;
begin
  if ContainsText(AItem.Caption, AText) then
    exit(true);
  for S in AItem.SubItems do
    if ContainsText(S, AText) then
      Exit(True);
  Result := False;
end;

procedure TClientFilesFrame.BeginUpdate;
begin
  Inc(FUpdate);
end;

procedure TClientFilesFrame.btnApplyElementClick(Sender: TObject);
var
  I: TAutoFillItem;
  FormName: String;
  ElementNo: Integer;
  M: TVTElement;
  V: String;
begin
  if (tvAutoFill.Selected = nil) or
     (tvAutoFill.Selected.Data = nil) or
     not (TObject(tvAutoFill.Selected.Data) is TAutoFillItem) then
    exit;
  I := TAutoFillItem(tvAutoFill.Selected.Data);
  ApplyItem(I);
end;

procedure TClientFilesFrame.btnApplyFileClick(Sender: TObject);
var
  R: TAutoFillReturn;
  G: TAutoFillGroup;
begin
  if FAutoFillFile.AutoFillReturns.Count = 0 then
  begin
    MessageDlg('No return in AutoFill answer', mtInformation, [mbOk], 0);
    exit;
  end;
  for R in FAutoFillFile.AutoFillReturns do
    if SameText(R.SIN, RetList[GetCurrentRetNo].GetSIN) then
    begin
      Applyreturn(R);
      exit;
    end;
end;

procedure TClientFilesFrame.btnApplyFormClick(Sender: TObject);
var
  G: TAutoFillGroup;
begin
  if (tvAutoFill.Selected = nil) or
     (tvAutoFill.Selected.Data = nil) or
     not ((TObject(tvAutoFill.Selected.Data) is TAutoFillItem) or
          (TObject(tvAutoFill.Selected.Data) is TAutoFillGroup)) then
    exit;
  if TObject(tvAutoFill.Selected.Data) is TAutoFillGroup then
    G := TAutoFillGroup(tvAutoFill.Selected.Data)
  else
    G := TAutoFillGroup(tvAutoFill.Selected.Parent.Data);
  ApplyGroup(G);
end;

procedure TClientFilesFrame.btnAutoFillPrintClick(Sender: TObject);
var
  P: TvtPDFPrinter;
begin
  P := TvtPDFPrinter.Create(CurrentApp);
  try
    P.PrintLestView('Auto-Fill data',  ExtractFilename(FAutoFillFile.FileName),
      [], lvAotoFillData);
  finally
    P.Free;
  end;
end;

procedure TClientFilesFrame.btnExecuteFileClick(Sender: TObject);
var
  FileName: String;
  F: TCustomForm;
  Node: TTreeNode;
begin
  F := GetParentForm(Self);
  if F.ActiveControl = lvFolder then
    if lvFolder.Selected <> nil then
      Node := TTreeNode(lvFolder.Selected.Data)
    else
      exit
  else
    Node := tvFileList.Selected;

  if Node = nil then
    exit;
  FileName := GetFullPath(Node);
  ShellExecute(0, PWideChar('open'), PWideChar(FileName), nil, PWideChar(ExtractFileDir(FileName)), SW_NORMAL);
end;

procedure TClientFilesFrame.btnGoToElementClick(Sender: TObject);
var
  I: TAutoFillItem;
begin
  if (tvAutoFill.Selected = nil) or
     (tvAutoFill.Selected.Data = nil) or
     not (TObject(tvAutoFill.Selected.Data) is TAutoFillItem) then
    exit;
  I := TAutoFillItem(tvAutoFill.Selected.Data);
  if (Length(I.VTMapElement) > 0) then
    OpenForm(GetCurrentRetNo, I.VTMapElement[0].FormName, I.VTMapElement[0].ElementNo);
end;

function TClientFilesFrame.GetCurrDir: String;
var
  Node: TTreeNode;
begin
  Node := GetCurrentNode;
  if (Node = nil) AND (FRootPath = '') then
    Result := ''
  else
  if (Node = nil) AND (FRootPath <> '') then
    Result := IncludeTrailingPathDelimiter(FRootPath)
  else
  if faDirectory AND Integer(Node.Data) <> 0 then
    Result := GetFullPath(Node)
  else
    Result := ExtractFilePath(GetFullPath(Node));
end;

function TClientFilesFrame.GetCurrentNode: TTreeNode;
var
  F: TCustomForm;
begin
  F := GetParentForm(Self);
  if F.ActiveControl = lvFolder then
    if lvFolder.Selected <> nil then
      Result := TTreeNode(lvFolder.Selected.Data)
    else
      exit(nil)
  else
    Result := tvFileList.Selected;
end;

procedure TClientFilesFrame.btnOpenFolderClick(Sender: TObject);
var
  IIDL: PItemIDList;
  FileName: String;
  Node: TTreeNode;
begin
   Node := GetCurrentNode;
  if Node = nil then
    exit;
  FileName := GetFullPath(Node);
  IIDL := ILCreateFromPath(PChar(FileName));
  if IIDL <> nil then
    try
      SHOpenFolderAndSelectItems(IIDL, 0, nil, 0);
    finally
      ILFree(IIDL);
    end;
end;

destructor TClientFilesFrame.Destroy;
//20170727 Igor>>>
var
  Ref : Integer;
begin
  if Assigned(FAcroPDF) then
  begin
    Ref := FAcroPDF.ControlInterface._AddRef;
    FAcroPDF.Src := '';
    FAcroPDF.Free;
    FAcroPDF := nil;
  end;
//20170727 Igor<<<
  WaitScanThread;
  inherited Destroy;
end;

procedure TClientFilesFrame.EndUpdate;
begin
  if FUpdate > 0 then
    Dec(FUpdate);
  if FUpdate = 0 then
  begin
    if FLocateAfterFill <> '' then
    begin
      if not Locate(FLocateAfterFill) then
        tvFileList.Selected := nil;
      FLocateAfterFill := '';
    end;
    tvFileListChange(nil, nil);
  end;
end;

procedure TClientFilesFrame.mniCreateFolderClick(Sender: TObject);
var
  CurDir, S: String;
begin
  CurDir := GetCurrDir;
  if CurDir = '' then
    exit;
  S := 'New Folder';
  if not InputQuery('Create new folder', 'Input New folder name', S) then
    exit;

  if Trim(S) = '' then
  begin
    MessageDlg('Empty folder name', TMsgDlgType.mtError, [mbOk], 0);
    exit
  end;
  S := TPath.Combine(CurDir, S);
  if not TPath.HasValidPathChars(S, False) then
  begin
    MessageDlg('Invalid characters in path', TMsgDlgType.mtError, [mbOk], 0);
    exit
  end;
  if TDirectory.Exists(S) then
  begin
    MessageDlg('The specified path was found', TMsgDlgType.mtError, [mbOk], 0);
    exit
  end;

  if ForceDirectories(S) then
    RefillList;
end;

procedure TClientFilesFrame.mniDeleteClick(Sender: TObject);
var
  Node: TTreeNode;
  S: String;
begin
  Node := GetCurrentNode;
  if Node = nil then
    exit;
  S := GetFullPath(Node);
  if (faDirectory AND Integer(Node.Data)) <> 0 then
    TDirectory.Delete(S)
  else
    TFile.Delete(S);
  RefillList;
end;

function TClientFilesFrame.GetFileMasks: String;
begin
  if FMode = mAutoFill then
    Result := '*-AutoFillData-*.txt'
  else
    Result := '*.*'
end;

function TClientFilesFrame.GetFullPath(Node: TTreeNode): String;
var
  N: TTreeNode;
begin
  Result := Node.Text;
  N := Node.Parent;
  while Assigned(N) do
  begin
    Result := TPath.Combine(N.Text, Result);
    N := N.Parent;
  end;
  Result := TPath.Combine(FRootPath, Result);
end;

procedure TClientFilesFrame.Init(AParentControl: TWinControl; AFolder,
  AOwnedAutoFile: String; AApp: TApp); // 20180530 Igor
var
  I: Integer;
begin
  FMode := mAutoFill;
  for I := 0 to pgcPreview.PageCount - 1 do
    pgcPreview.Pages[I].TabVisible := False;
  if (Parent <> AParentControl) then
  begin
    Parent := AParentControl;
    Align := alClient;
  end;
  // 20180530 Igor >>>
  if (App <> AApp) then
    App := AApp;
  if Assigned(App) then
  begin
    if SameText(App.AppName, 'T2') then
    begin
      rbAutoFillDataAll.Checked := true;
      rbAutoFillDataAll.Visible := false;
      rbAutoFillDataSlipsOnly.Visible := false;
      lvAotoFillData.Columns[0].Caption := 'Section';
      lvAotoFillData.Columns[2].Caption := 'Box';
      lvAotoFillData.Columns[3].Caption := '';
      lvAotoFillData.Columns[0].Width := 140;
      lvAotoFillData.Columns[1].Width := 60;
      lvAotoFillData.Columns[2].Width := 60;
      lvAotoFillData.Columns[3].Width := 0;
      lvAotoFillData.Columns[4].Width := 200;
    end
    else
    begin
      rbAutoFillDataAll.Visible := true;
      rbAutoFillDataSlipsOnly.Visible := true;
      lvAotoFillData.Columns[0].Caption := 'Group';
      lvAotoFillData.Columns[2].Caption := 'Element Name';
      lvAotoFillData.Columns[3].Caption := 'Box No';
      lvAotoFillData.Columns[0].Width := 60;
      lvAotoFillData.Columns[1].Width := 80;
      lvAotoFillData.Columns[2].Width := 250;
      lvAotoFillData.Columns[3].Width := 55;
      lvAotoFillData.Columns[4].Width := 60;
    end;
  end;
  // 20180530 Igor <<<
  if (RootPath <> AFolder) then
  begin
    ClearPreview;
    RootPath := AFolder;
  end;
  if OwnedAutoFile <> AOwnedAutoFile then
  begin
    FLocateAfterFill := AOwnedAutoFile;
    OwnedAutoFile := AOwnedAutoFile;
    if FUpdate = 0 then
      EndUpdate;
  end;
end;

function TClientFilesFrame.Locate(AFileName: String): Boolean;
var
  A: TArray<String>;
  I: Integer;
  N: TTreeNode;
begin
  if not StartsText(FRootPath, AFileName) then
    exit(False);
  System.Delete(AFileName, 1, length(IncludeTrailingPathDelimiter(FRootPath)));
  A := AFileName.Split([TPath.DirectorySeparatorChar]);
  N := tvFileList.Items.GetFirstNode;
  for I := 0 to length(A) - 1 do
  begin
    while Assigned(N) do
    begin
      if SameText(N.Text, A[I]) then
      begin
        if I < length(A) - 1 then
          N := N.getFirstChild;
        break;
      end
      else
        N := N.getNextSibling;
    end;
    if not Assigned(N) then
      exit(False);
  end;
  if Assigned(N) then
  begin
    tvFileList.Selected := N;
    N.Focused := True;
    Result := True;
  end
  else
    Result := False;
end;

procedure TClientFilesFrame.Init(AParentControl: TWinControl; AFolder: String);
var
  I: Integer;
begin
  FMode := mClientDocuments;
  App := nil; // 20180530 Igor
  for I := 0 to pgcPreview.PageCount - 1 do
    pgcPreview.Pages[I].TabVisible := False;
  if (Parent <> AParentControl) then
  begin
    Parent := AParentControl;
    Align := alClient;
  end;
  if (RootPath <> AFolder) then
  begin
    ClearPreview;
    RootPath := AFolder;
  end;
end;

procedure TClientFilesFrame.lvFolderDblClick(Sender: TObject);
begin
  if lvFolder.Selected = nil then
    exit;
  tvFileList.Selected := TTreeNode(lvFolder.Selected.Data);
end;

procedure TClientFilesFrame.Notification(AComponent: TComponent;
  Operation: TOperation);//20170727 Igor
begin
  if (AComponent = FAcroPDF) and (Operation = opRemove) then
    FAcroPDF := nil;
  inherited;
end;

procedure TClientFilesFrame.mniPasteClick(Sender: TObject);
var
  f: THandle;
  buffer: Array [0..MAX_PATH] of Char;
  i, numFiles: Integer;
  CurrDir, SrcFile, DestFileName, UniqueName: String;
  isFile: Boolean;
  function GenerateUniqueName(AFileName: String): String;
  var
    lPath, lSuf, lExt: String;
    I: Integer;
  begin
    I := 0;
    lSuf := '';
    lPath := ChangeFileExt(AFileName, '');
    lExt := ExtractFileExt(AFilename);
    while TFile.Exists(lPath + lSuf + lExt) or TDirectory.Exists(lPath + lSuf + lExt) do
    begin
      inc(I);
      lSuf := '('+IntToStr(I)+')';
    end;
    Result := lPath + lSuf + lExt;
  end;
begin
  CurrDir := GetCurrDir;
  Clipboard.Open;
  try
    f := Clipboard.GetAsHandle(CF_HDROP);
    if f <> 0 then
    begin
      numFiles := DragQueryFile(f, $FFFFFFFF, nil, 0);
      for i:= 0 to numfiles - 1 do
      begin
        ZeroMemory(@buffer[0], sizeof(buffer));
        buffer[0] := #0;
        DragQueryFile(f, i, buffer, sizeof(buffer));
        SrcFile := string(buffer);
        isFile := TFile.Exists(SrcFile);
        DestFileName := ChangeFilePath(SrcFile, CurrDir);

        if isFile then
        begin
          if TFile.Exists(DestFileName) then
          begin
            UniqueName := GenerateUniqueName(DestFileName);
            case CaseDo('File with name "' + ExtractFileName(DestFileName) + '" exists!',
                        ['Overwrite', 'Skip', 'Rename to "' + ExtractFileName(UniqueName) + '"'],
                        function(const ACaseID: Integer): Boolean
                        begin
                          Result := True;
                          case ACaseID of
                            0: TFile.Copy(Buffer, DestFileName, True);
                            1:; //nothing
                            2: TFile.Copy(Buffer, UniqueName, True);
                          end;
                        end) of
              0, 2: RefillList;
            end;
          end
          else
          if TDirectory.Exists(DestFileName) then
          begin
            UniqueName := GenerateUniqueName(DestFileName);
            case CaseDo('Directory with name "' + ExtractFileName(DestFileName) + '" exists!',
                        ['Skip', 'Rename to "' + ExtractFileName(UniqueName) + '"'],
                        function(const ACaseID: Integer): Boolean
                        begin
                          Result := True;
                          case ACaseID of
                            0:; //nothing
                            1: TFile.Copy(Buffer, UniqueName, True);
                          end;
                        end) of
              1: RefillList;
            end;
          end
          else
          begin
            TFile.Copy(Buffer, DestFileName, True);
            RefillList;
          end;
        end
        else
        begin
          if TFile.Exists(DestFileName) or TDirectory.Exists(DestFileName) then
          begin
            UniqueName := GenerateUniqueName(DestFileName);
            case CaseDo('Directory or file with name "' + ExtractFileName(DestFileName) + '" exists!',
                        ['Skip', 'Rename to "' + ExtractFileName(UniqueName) + '"'],
                        function(const ACaseID: Integer): Boolean
                        begin
                          Result := True;
                          case ACaseID of
                            0:; //nothing
                            1: Tdirectory.Copy(Buffer, UniqueName);
                          end;
                        end) of
              1: RefillList;
            end;
          end
          else
          begin
            Tdirectory.Copy(Buffer, DestFileName);
            RefillList;
          end;
        end;
      end;
    end;
  finally
    Clipboard.close;
  end;
end;

function TClientFilesFrame.DoMove(const ASrc, ADstPath, ADstName: String): Boolean;
var
  dst: String;
begin
  Dst := TPath.Combine(ADstPath, ADstName);
  if SameText(Dst, ASrc) then
    exit(False);
  if Trim(ADstName) = '' then
  begin
    MessageDlg('Empty name', TMsgDlgType.mtError, [mbOk], 0);
    exit(False)
  end;
  if not TPath.HasValidFileNameChars(ADstName, False) then
  begin
    MessageDlg('Invalid characters in name', TMsgDlgType.mtError, [mbOk], 0);
    exit(False)
  end;
  if TDirectory.Exists(Dst) or TFile.Exists(Dst) then
  begin
    MessageDlg('The specified path was found', TMsgDlgType.mtError, [mbOk], 0);
    exit(False)
  end;

  if TDirectory.Exists(ASrc) then
    TDirectory.Move(ASrc, Dst)
  else
    TFile.Move(ASrc, Dst);
  Result := True;
end;

procedure TClientFilesFrame.LocateAutoFill(const ASearchText: String);
var
  I: TListItem;
begin
  for I in lvAotoFillData.Items do
    if ItemContainText(I, ASearchText) then
    begin
      lvAotoFillData.ItemIndex := I.Index;
      I.MakeVisible(True);
      break;
    end;
end;

procedure TClientFilesFrame.edtAutoFillSearchChange(Sender: TObject);
begin
  if rbAutoFillFilter.Checked then
    FAutoFillFile.ReloadGUI(lvAotoFillData.Items, rbAutoFillDataSlipsOnly.Checked, edtAutoFillSearch.Text)
  else
    LocateAutoFill(edtAutoFillSearch.Text);
end;

procedure TClientFilesFrame.mniRenameClick(Sender: TObject);
var
  Node: TTreeNode;
  S, CurDir: String;
begin
  Node := GetCurrentNode;
  if Node = nil then
    exit;
  S := Node.Text;
  if not InputQuery('Rename', 'Enter new name', S) then
    exit;
  CurDir := GetCurrDir;
  if DoMove(GetFullPath(Node), ExtractFilePath(GetFullPath(Node)), S) then
    Node.Text := S;
end;

procedure TClientFilesFrame.pmFileActionsPopup(Sender: TObject);
var
  Node: TTreeNode;
  Attr, NodeType: Integer;
  I: Integer;
  f: THandle;
  numFiles: Integer;
const
  cRoot = $1;
  cFolder = $2;
  cFile = $4;

begin
  Node := GetCurrentNode;
  if Node <> nil then
  begin
    Attr := Integer(Node.Data);
    if (faDirectory AND Attr) <> 0 then
      NodeType := cFolder
    else
      NodeType := cFile
  end
  else
  if FRootPath <> '' then
    NodeType := cRoot
  else
    NodeType := 0;
  for I := 0 to TPopupMenu(Sender).Items.Count - 1 do
    TPopupMenu(Sender).Items[I].Visible := (TPopupMenu(Sender).Items[I].Tag AND NodeType) <> 0;


  Clipboard.Open;
  try
    f := Clipboard.GetAsHandle(CF_HDROP);
    if f <> 0 then
      numFiles := DragQueryFile(f, $FFFFFFFF, nil, 0)
    else
      numFiles := 0;

  finally
    Clipboard.close;
  end;
end;

procedure TClientFilesFrame.rbAutoFillDataAllClick(Sender: TObject);
begin
  tvFileListChange(tvFileList, tvFileList.Selected);
end;

procedure TClientFilesFrame.rbAutoFillFilterClick(Sender: TObject);
begin
  if rbAutoFillFilter.Checked then
    FAutoFillFile.ReloadGUI(lvAotoFillData.Items, rbAutoFillDataSlipsOnly.Checked, edtAutoFillSearch.Text)
  else
  begin
    FAutoFillFile.ReloadGUI(lvAotoFillData.Items, rbAutoFillDataSlipsOnly.Checked, '');
    LocateAutoFill(edtAutoFillSearch.Text);
  end;
end;

procedure TClientFilesFrame.RefillList;
begin
  WaitScanThread;
  BeginUpdate;
  if tvFileList.Selected <> nil then
    FLocateAfterFill := GetFullPath(tvFileList.Selected);
  FScanFolderThread := TScanFolderThread.Create(FRootPath, GetFileMasks, tvFileList, ThreadDestroy);
end;

procedure TClientFilesFrame.ClearPreview;
begin
  pgcPreview.ActivePage := nil;
  imgIcon.Picture.Bitmap := nil;
  lblFileName.Caption := '';
end;

procedure ClipboardError;
begin
  raise Exception.Create('Could not complete clipboard operation.');
  // substitute something more specific that Exception in your code
end;

procedure CheckClipboardHandle(Handle: HGLOBAL);
begin
  if Handle=0 then begin
    ClipboardError;
  end;
end;

procedure CheckClipboardPtr(Ptr: Pointer);
begin
  if not Assigned(Ptr) then begin
    ClipboardError;
  end;
end;

procedure PutInClipboard(ClipboardFormat: UINT; Buffer: Pointer; Count: Integer);
var
  Handle: HGLOBAL;
  Ptr: Pointer;
begin
  Clipboard.Open;
  Try
    Handle := GlobalAlloc(GMEM_MOVEABLE, Count);
    Try
      CheckClipboardHandle(Handle);
      Ptr := GlobalLock(Handle);
      CheckClipboardPtr(Ptr);
      Move(Buffer^, Ptr^, Count);
      GlobalUnlock(Handle);
      Clipboard.SetAsHandle(ClipboardFormat, Handle);
    Except
      GlobalFree(Handle);
      raise;
    End;
  Finally
    Clipboard.Close;
  End;
end;

function DoubleNullTerminatedString(const Values: array of string): string;
var
  Value: string;
begin
  Result := '';
  for Value in Values do
    Result := Result + Value + #0;
  Result := Result + #0;
end;

procedure CopyFileNamesToClipboard(const FileNames: array of string);
var
  Size: Integer;
  FileList: string;
  DropFiles: PDropFiles;
begin
  FileList := DoubleNullTerminatedString(FileNames);
  Size := SizeOf(TDropFiles) + ByteLength(FileList);
  DropFiles := AllocMem(Size);
  try
    DropFiles.pFiles := SizeOf(TDropFiles);
    DropFiles.fWide := True;
    Move(Pointer(FileList)^, (PByte(DropFiles) + SizeOf(TDropFiles))^,
      ByteLength(FileList));
    PutInClipboard(CF_HDROP, DropFiles, Size);
  finally
    FreeMem(DropFiles);
  end;
end;

procedure TClientFilesFrame.mniCopyClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  Node := GetCurrentNode;
  if Node = nil then
    exit;
  CopyFileNamesToClipboard([GetFullPath(Node)]);
end;

procedure TClientFilesFrame.WaitScanThread;
begin
  CS.Enter;
  try
    if Assigned(FScanFolderThread) then
      FScanFolderThread.Terminate;
  finally
    CS.Leave;
  end;
  while Assigned(FScanFolderThread) do
  begin
    sleep(100);
    Application.ProcessMessages;
  end;
end;

procedure TClientFilesFrame.SetOwnedAutoFile(const Value: String);
begin
  if FOwnedAutoFile <> Value then
  begin
    FOwnedAutoFile := Value;
    FOwnedAutoFileName := ExtractFileName(Value);
    tvFileList.Invalidate;
  end;
end;

procedure TClientFilesFrame.SetRootPath(const Value: String);
begin
  if FRootPath <> Value then
  begin
    FRootPath := Value;
    RefillList;
  end;
end;

procedure TClientFilesFrame.ShowMSOffice(const AFileName: String);
begin
  if ocMSOffice.Caption <> AFileName then
    try
      ocMSOffice.CreateObjectFromFile(AFileName, false);
      ocMSOffice.Caption := AFileName;
      pgcPreview.ActivePage := tsMSOffice;
    except
      pgcPreview.ActivePage := tsOther;
    end;
end;

procedure TClientFilesFrame.ResizeReviewPanel;
begin
  pnlPreviewContainer.Height := Self.Height - 100;
  tvFileList.Selected.MakeVisible;
end;

procedure TClientFilesFrame.ShowPDF(const AFileName: String);
var
  V: String;
begin
  if (FAcroPDF = nil) and not FTryPdfLoad then
  begin
    FTryPdfLoad := True;
    try
      FAcroPDF := TAcroPDF.Create(Self);
      FAcroPDF.FreeNotification(Self);
      FAcroPDF.Visible := False;
      V := FAcroPDF.ControlInterface.GetVersions;
      FAcroPDF.src := AFileName;
      FAcroPDF.Parent := panPDF;
      FAcroPDF.Align := alCLient;
      FAcroPDF.Visible := True;
      ResizeReviewPanel;
      exit;
    except
      FreeAndNil(FAcroPDF);
      pgcPreview.ActivePage := tsOther;
      exit;
    end;
  end;
  if not Assigned(FAcroPDF) or not FAcroPDF.LoadFile(AFileName) then
    pgcPreview.ActivePage := tsOther
  else
    ResizeReviewPanel;
end;

procedure TClientFilesFrame.btnRefreshClick(Sender: TObject);
begin
  RefillList;
end;

procedure TClientFilesFrame.ThreadDestroy(Sender: TObject);
begin
  if Sender = FScanFolderThread then
    FScanFolderThread := nil;
  EndUpdate;
end;

procedure TClientFilesFrame.tmrPreviewTimer(Sender: TObject);
var
  Node: TTreeNode;
  ext: String;
begin
  tmrPreview.Enabled := False;
  Node := tvFileList.Selected;
  imgIcon.Picture.Bitmap := nil;
  if (Node = nil) or (Integer(Node.Data) and System.SysUtils.faDirectory <> 0) then
  begin
    lvFolder.Items.BeginUpdate;
    try
      lvFolder.Items.Clear;
      if Node <> nil then
      begin
        ilFileIcons.GetBitmap(Node.ImageIndex, imgIcon.Picture.Bitmap);
        imgIcon.Invalidate;
        lblFileName.Caption := GetFullPath(Node);
        with lvFolder.Items.Add do
        begin
          Caption := '..';
          ImageIndex := 0;
          Data := Node.Parent;
        end;
        Node := Node.getFirstChild
      end
      else
      begin
        if FRootPath <> '' then
        begin
          ilFileIcons.GetBitmap(0, imgIcon.Picture.Bitmap);
          imgIcon.Invalidate;
          lblFileName.Caption := FRootPath;
          Node := tvFileList.Items.GetFirstNode;
        end;
      end;

      while Assigned(Node) do
      begin
        with lvFolder.Items.Add do
        begin
          Caption := Node.Text;
          ImageIndex := Node.ImageIndex;
          Data := Node;
        end;
        Node := Node.getNextSibling;
      end
    finally
      lvFolder.Items.EndUpdate;
    end;
    pgcPreview.ActivePage := tsFolder;
  end
  else
  begin
    ilFileIcons.GetBitmap(Node.ImageIndex, imgIcon.Picture.Bitmap);
    imgIcon.Invalidate;
    lblFileName.Caption := GetFullPath(Node);
    if FMode = mAutoFill then
    begin
      if not Assigned(FAutoFillFile) then
        FAutoFillFile := TAutoFillFile.Create;
      FAutoFillFile.LoadFromFile(GetFullPath(Node));
//      FAutoFillFile.ReloadGUI(tvAutoFill.Items);
      FAutoFillFile.ReloadGUI(lvAotoFillData.Items, rbAutoFillDataSlipsOnly.Checked, edtAutoFillSearch.Text);
      ResizeReviewPanel;
      pgcPreview.ActivePage := tsAutoFill_List;
    end
    else
    begin
      ext := ExtractFileExt(Node.Text);
      case ExtractPreview(ext) of
        pkTXT :
          begin
            pgcPreview.ActivePage := tsText;
            mmoPreviewText.Lines.LoadFromFile(GetFullPath(Node));
          end;
        pkHTML :
          begin
            pgcPreview.ActivePage := tsHTML;
            wbPreviewHTML.Navigate(GetFullPath(Node));
          end;
        pkPDF :
          begin
            pgcPreview.ActivePage := tsPDF;
            ShowPDF(GetFullPath(Node));
          end;
        pkRTF :
          begin
            pgcPreview.ActivePage := tsRTF;
            rePreview.Lines.LoadFromFile(GetFullPath(Node));
          end;
        //20170728 Igor>>>
        pkMSOffice :
          ShowMSOffice(GetFullPath(Node));
        //20170728 Igor<<<
        pkImage :
          begin
            pgcPreview.ActivePage := tsImage;
            try
              imgPreview.Picture.LoadFromFile(GetFullPath(Node));
            except
            end;
          end;
      else
        begin
          pgcPreview.ActivePage := tsOther;
        end;
      end;
    end;
  end;
end;

procedure TClientFilesFrame.tvAutoFillChange(Sender: TObject; Node: TTreeNode);
begin
  btnGoToElement.Enabled := (Node <> nil) and (Node.Data <> nil) and (TObject(Node.Data) is TAutoFillItem);
  btnApplyElement.Enabled := (Node <> nil) and (Node.Data <> nil) and (TObject(Node.Data) is TAutoFillItem);
  btnApplyForm.Enabled := (Node <> nil) and (Node.Data <> nil) and
    ((TObject(Node.Data) is TAutoFillItem) or (TObject(Node.Data) is TAutoFillGroup));
  btnApplyFile.Enabled := (tvAutoFill.Items.Count > 0);
end;

procedure TClientFilesFrame.tvAutoFillMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  HT: THitTests;
  N: TTreeNode;
  G: TSelectableNode;
begin
  HT := tvAutoFill.GetHitTestInfoAt(X, Y);
  if (htOnIcon in HT) then
  begin
    N := tvAutoFill.GetNodeAt(X, Y);
    if (N <> nil) and (N.Data <> nil) and (TObject(N.Data) is TSelectableNode) then
    begin
      G := TSelectableNode(N.Data);
      G.Selected := not G.Selected;
      G.ReloadNode(N, False, False);
    end;
  end;
end;

procedure TClientFilesFrame.tvFileListChange(Sender: TObject; Node: TTreeNode);
begin
  ClearPreview;
  tmrPreview.Enabled := False;
  tmrPreview.Enabled := True;
end;

procedure TClientFilesFrame.tvFileListCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if FMode = TMode.mAutoFill then
  begin
    if SameText(Node.Text, FOwnedAutoFileName) then
    begin
      Sender.Canvas.Font.Color := clBlack;
      Sender.Canvas.Font.Style := [fsBold];
    end
    else
    begin
      Sender.Canvas.Font.Color := clGray;
      Sender.Canvas.Font.Style := [];
    end;
  end;
  if Node = tvFileList.Selected then
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsUnderline];
end;

procedure TClientFilesFrame.tvFileListEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
begin
  if not DoMove(GetFullPath(Node), ExtractFilePath(GetFullPath(Node)), S) then
    S := Node.Text;

end;

{ TScanFolderThread }

function TScanFolderThread.AddNode(AFileName, AFullPath: String; AFileAttr: Integer;
  AParentNode: TTreeNode): TTreeNode;
var
  N: TTreeNode;
  Icon: TIcon;
  FileInfo: SHFILEINFO;
  ImageIndex: Integer;
  dummy: word;
  H: HICON;
  ext: String;
begin
  if not Assigned(FTreeView) then
    exit(nil);
  if Terminated then
    exit(nil);

  // Get icon and copy into ImageList
  if FTreeView.Images <> nil then
  begin
    if AFileAttr and System.SysUtils.faDirectory <> 0 then
    begin
      H := ExtractAssociatedIconW(0, PWideChar(AFullPath), dummy);
      if not FIcns.TryGetValue(H, ImageIndex) then
      begin
        Icon := TIcon.Create;
        try
          Icon.Handle := H;
          Synchronize(procedure
            begin
              ImageIndex := FTreeView.Images.AddIcon(Icon);
            end);
          FIcns.Add(H, ImageIndex)
        finally
          Icon.Free;
        end;
      end;
    end
    else
    begin
      ext := ExtractFileExt(AFileName).ToLower;
      if not FIcnsExt.TryGetValue(ext, ImageIndex) then
      begin
        SHGetFileInfo(PChar(AFullPath),
                      FILE_ATTRIBUTE_NORMAL,
                      FileInfo,
                      SizeOf(FileInfo),
                      SHGFI_ICON or SHGFI_SMALLICON or
                      SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES
                      );
        if not FIcns.TryGetValue(FileInfo.hIcon, ImageIndex) then
        begin
          Icon := TIcon.Create;
          try
            Icon.Handle := FileInfo.hIcon;
            Synchronize(procedure
              begin
                ImageIndex := FTreeView.Images.AddIcon(Icon);
              end);
            FIcns.Add(FileInfo.hIcon, ImageIndex)
          finally
            Icon.Free;
          end;
        end;
        if (ext <> '.exe') and (ext <> '.lnk') then
          FIcnsExt.Add(ext, ImageIndex)
      end;
    end;
  end
  else
    ImageIndex := -1;

  Synchronize(procedure
    begin
      N := FTreeView.Items.AddChildObject(AParentNode, AFileName, TObject(AFileAttr));
      N.ImageIndex := ImageIndex;
      N.SelectedIndex := ImageIndex;
    end);
  Result := N;
end;

constructor TScanFolderThread.Create(AFolder, AMask: String; ATreeView: TTreeView; AOnDestroy: TNotifyEvent);
begin
  inherited Create(False);
  FFolder := AFolder;
  FMask := AMask;
  FTreeView := ATreeView;
  FOnDestroy := AOnDestroy;
  FreeOnTerminate := True;
  FIcns := TDictionary<HICON,Integer>.Create;
  FIcnsExt := TDictionary<String,Integer>.Create;
end;

destructor TScanFolderThread.Destroy;
begin
  FreeAndNil(FIcns);
  FreeAndNil(FIcnsExt);
  CS.Enter;
  try
    Synchronize(procedure
      begin
        if Assigned(FOnDestroy) then
          FOnDestroy(Self);
      end);
  finally
    CS.Leave;
  end;
  inherited;
end;

procedure TScanFolderThread.execute;
  procedure WalkThroughDirectory(APath: String; AParentNode: TTreeNode);
  var
    SearchRec: TSearchRec;
    CurrNode: TTreeNode;
    Folders, Files: TStringList;
    I: Integer;
  begin
    Folders := TStringList.CReate;
    Files := TStringList.CReate;
    try
      if FindFirst(TPath.Combine(APath, '*'), faAnyFile, SearchRec) = 0 then
      try
        repeat
          if (SearchRec.Name <> '.') and
             (SearchRec.Name <> '..') then
          begin
            if (SearchRec.Attr and System.SysUtils.faDirectory <> 0) then
              Folders.AddObject(SearchRec.Name, TObject(SearchRec.Attr))
            else
            if MatchesMask(SearchRec.Name, FMask) then
              Files.AddObject(SearchRec.Name, TObject(SearchRec.Attr));
          end;
        until Terminated or (FindNext(SearchRec) <> 0);
        Folders.Sort;
        Files.Sort;
        for I := 0 to Folders.Count - 1 do
        begin
          CurrNode := AddNode(Folders[I], TPath.Combine(APath, Folders[I]), Integer(Folders.Objects[I]), AParentNode);
          WalkThroughDirectory(TPath.Combine(APath, Folders[I]), CurrNode);
        end;
        for I := 0 to Files.Count - 1 do
        begin
          AddNode(Files[I], TPath.Combine(APath, Files[I]), Integer(Files.Objects[I]), AParentNode);
        end;
      finally
        FindClose(SearchRec);
      end;
    finally
      Folders.Free;
      Files.Free;
    end;
  end;
begin
  Synchronize(procedure
    begin
      if Assigned(FTreeView) then
      begin
        FTreeView.Items.BeginUpdate;
        FTreeView.Items.Clear;
      end;
    end);
  try
    if FFolder <> '' then
      WalkThroughDirectory(FFolder, nil);
  finally
    Synchronize(procedure
      begin
        if Assigned(FTreeView) then
          FTreeView.Items.EndUpdate;
      end);
  end;
end;

{ TAutoFillItem }

constructor TAutoFillItem.Create(const AFormName, AElementName: String;
  const AInstanse, ARowNo: Integer; const AValue: String);
begin
  inherited Create;
  FFormName := AFormName;
  FElementName := AElementName;
  FInstanse := AInstanse;
  FRowNo := ARowNo;
  FValue := AValue;
  RetList[GetCurrentRetNo].MyApp.AutoFillToVtAddr(AFormName, AElementName, FVTMapElement);
end;

destructor TAutoFillItem.Destroy;
begin
  inherited Destroy;
end;

function TAutoFillItem.FullName: String;
begin
  if Instanse > 0 then
    Result := '[' + Instanse.ToString + '] '
  else
    Result := '';
  Result := Result + ElementName;
  if length(VTMapElement) > 0 then
    Result := Result + '(' + VTMapElement[0].FormName + '.' + VTMapElement[0].ElementNo.ToString + ')';
  Result := Result + ': ' + Value;
end;

{ TAutoFillGroup }

constructor TAutoFillGroup.Create(const AGroupName, ASubGroupName: String; ASelected: Boolean);
begin
  inherited Create;
  FGroupName := AGroupName;
  FSubGroupName := ASubGroupName;
  FSelected := ASelected;
  FAutoFillItems := TAutoFillItems.Create(True);
  FInstanseCount := 0;
end;

destructor TAutoFillGroup.Destroy;
begin
  FreeAndNil(FAutoFillItems);
  inherited;
end;

procedure TAutoFillGroup.ReloadListItems(AItems: TListItems; AFilter: String);
var
  I: TAutoFillItem;
  FLastForm: String;
  FLastInstance: Integer;
begin
  if not Assigned(AItems) then
    exit;
  if Self.FAutoFillItems.Count = 0 then
    exit;
  FLastForm := Self.FAutoFillItems.First.FormName;
  FLastInstance := Self.FAutoFillItems.First.Instanse;//20170811 Igor
  for I in Self.FAutoFillItems do
  begin
    if AFilter.Trim.IsEmpty or
       ContainsText(Self.GroupName, AFilter) or
       ContainsText(I.FormName, AFilter) or
       ContainsText(I.ElementName, AFilter) or
       ContainsText(I.Value, AFilter) or
       ((Length(I.VTMapElement) > 0) AND ContainsText(I.VTMapElement[0].BoxNo, AFilter)) then
    begin
      if FLastForm <> I.FormName then
      begin
        AItems.Add;
        FLastForm := I.FormName;
        FLastInstance := I.Instanse;
      end
      else
      if (FLastInstance <> I.Instanse) AND (I.Instanse > 1) then
      begin
        AItems.Add;
        FLastInstance := I.Instanse;
      end;

      with AItems.Add do
      begin
        Caption := Self.GroupName;
        SubItems.Add(I.FormName);
        SubItems.Add(I.ElementName);
        if Length(I.VTMapElement) > 0 then
          SubItems.Add(I.VTMapElement[0].BoxNo)
        else
          SubItems.Add('');
        SubItems.Add(I.Value);
        Data := I;
      end;
    end;
  end
end;

procedure TAutoFillGroup.ReloadNode(AItem: TTreeNode; AOnlySlips: Boolean; AReloadChild: Boolean = True);
var
  I: TAutoFillItem;
begin
  if not Assigned(AItem) then
    exit;
  AItem.Text := FGroupName;
  AItem.ImageIndex := CheckedImageIndexes[FSelected];
  AItem.SelectedIndex := AItem.ImageIndex;
  if AReloadChild then
  begin
    while AItem.Count > 0 do
      AItem.Item[0].Free;
    for I in Self.FAutoFillItems do
      with AItem.Owner.AddChildObject(AItem, I.FullName, I) do
      begin
        ImageIndex := -1;
        SelectedIndex := -1;
      end;
  end;
end;

{ TAutoFillReturn }

constructor TAutoFillReturn.Create(const ASIN: String);
begin
  inherited Create;
  FSIN := ASIN;
  FSelected := True;
  FAutoFillGroups := TAutoFillGroups.Create;
end;

destructor TAutoFillReturn.Destroy;
begin
  FreeAndNil(FAutoFillGroups);
  inherited;
end;

function TAutoFillReturn.FindGroupBySubGroupName(ASubGroupName: String;
  var AGroup: TAutoFillGroup): Boolean;
var
  G: TAutoFillGroup;
begin
  for G in FAutoFillGroups do
    if SameText(G.SubGroupName, ASubGroupName) then
    begin
      AGroup := G;
      exit(True);
    end;
  Result := False;
end;

function TAutoFillReturn.FullName: String;
begin
  result := Self.LastName + '[' + Self.SIN + ']'
end;

procedure TAutoFillReturn.ReloadListItems(AItems: TListItems;
  AOnlySlips: Boolean; AFilter: String);
var
  G: TAutoFillGroup;
begin
  for G in Self.FAutoFillGroups do
    if not AOnlySlips or SameText(G.GroupName, 'Slips') then
    begin
      if AItems.Count > 0 then
        AItems.Add;
      G.ReloadListItems(AItems, AFilter);
    end;
end;

procedure TAutoFillReturn.ReloadNode(AItem: TTreeNode; AOnlySlips: Boolean; AReloadChild: Boolean = True);
var
  G: TAutoFillGroup;
begin
  AItem.Text := Self.FullName;
  AItem.ImageIndex := CheckedImageIndexes[FSelected];
  AItem.SelectedIndex := AItem.ImageIndex;
  if AReloadChild then
  begin
    while AItem.Count > 0 do
      AItem.Item[0].free;
    for G in Self.FAutoFillGroups do
      if not AOnlySlips or SameText(G.GroupName, 'Slips') then
        G.ReloadNode(AItem.Owner.AddChildObject(AItem, G.GroupName, G), AOnlySlips);
  end;
end;

{ TAutoFillFile }

constructor TAutoFillFile.Create;
begin
  inherited Create;
  FAutoFillReturns := TAutoFillReturns.Create;
end;

destructor TAutoFillFile.Destroy;
begin
  FreeAndNil(FAutoFillReturns);
  inherited;
end;

procedure TAutoFillFile.DoLoad(AList: TStrings);
var
  R: TAutoFillReturn;

  procedure InternalLoad;
  var
    S, GroupName, SubGroupName, ElementName, Inst, Value: String;
    G: TAutoFillGroup;
  begin
    for S in AList do
    begin
      GroupName := Trim(Copy(S, 1, 45));
      SubGroupName := Trim(Copy(S, 46, 35));
      ElementName := Trim(Copy(S, 81, 60));
      Inst := Trim(Copy(S, 141, 2));
      Value := Trim(Copy(S, 144, 100));
      if SameText(GroupName, 'EFileTaxData') AND
         SameText(SubGroupName, 'EFileIndividualIncomeTaxDataItem') AND
         SameText(ElementName, 'IndividualTaxpayerIdentifier') then
      begin
        R := TAutoFillReturn.Create(Value);
        FAutoFillReturns.Add(R);
      end
      else
      if Assigned(R) then
      begin
        if not R.FindGroupBySubGroupName(SubGroupName, G) then
        Begin
          G := TAutoFillGroup.Create(GroupName, SubGroupName, True);
          R.FAutoFillGroups.Add(G);
        end;
        if SameText(ElementName, 'TaxYear') AND
           SameText(GroupName, 'Slips') then
          G.InstanseCount := G.InstanseCount + 1;
        G.AutoFillItems.Add(TAutoFillItem.Create(G.SubGroupName, ElementName, G.InstanseCount,
          G.GetElementCount(G.InstanseCount, G.SubGroupName, ElementName),  Value));
      end;
    end;
  end;
begin
  R := nil;
  InternalLoad;
  if not Assigned(R) then //Single file
  begin
    R := TAutoFillReturn.Create(ExtractSin);
    FAutoFillReturns.Add(R);
    InternalLoad;
  end;
end;

function TAutoFillFile.ExtractSin: String;
var
  S: String;
begin
  S := ChangeFileExt(ExtractFileName(FFileName), '');
  System.Delete(S, 1, pos('-AutoFillData-', S) + length('-AutoFillData-') - 1);
  Result := S;
end;

function TAutoFillFile.FindReturnByName(ASIN: String;
  var AReturn: TAutoFillReturn): Boolean;
var
  R: TAutoFillReturn;
begin
  for R in FAutoFillReturns do
    if SameText(R.SIN, ASIN) then
    begin
      AReturn := R;
      exit(True);
    end;
  Result := False;
end;

procedure TAutoFillFile.LoadFromFile(AFileName: String);
var
  S: String;
  SL: TStringList;
begin
  if not TFile.Exists(AFileName) then
    Exit;
  FFileName := AFileName;
  S := ExtractFileName(AFileName);
  S := ChangeFileExt(S, '');
  FAutoFillReturns.Clear;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(AFileName);
    DoLoad(SL);
  finally
    SL.Free;
  end;
end;

procedure TAutoFillFile.ReloadGUI(AItems: TListItems; AOnlySlips: Boolean; AFilter: String);
var
  R: TAutoFillReturn;
begin
  AItems.BeginUpdate;
  try
    AItems.Clear;
    for R in Self.FAutoFillReturns do
    begin
      if AItems.Count > 0 then
        AItems.Add;
      if Self.FAutoFillReturns.Count > 1 then
        AItems.Add.Caption := R.SIN;
      R.ReloadListItems(AItems, AOnlySlips, AFilter);
    end
  finally
    AItems.EndUpdate;
  end;
end;

procedure TAutoFillFile.ReloadGUI(AItems: TTreeNodes; AOnlySlips: Boolean);
var
  R: TAutoFillReturn;
begin
  AItems.BeginUpdate;
  try
    AItems.Clear;
    for R in Self.FAutoFillReturns do
      R.ReloadNode(AItems.AddObject(nil, R.FullName, R), AOnlySlips);
    if Self.FAutoFillReturns.Count = 1 then
      AItems.GetFirstNode.Expand(False);
  finally
    AItems.EndUpdate;
  end;
end;

function TAutoFillGroup.GetElementCount(AInstance: Integer; AFormName,
  AElementName: String): Integer;
var
  E: TAutoFillItem;
begin
  Result := 0;
  for E in FAutoFillItems do
    if Sametext(E.FormName, AFormName) AND
       SameText(E.ElementName, AElementName) AND
       (E.Instanse = AInstance) then
      inc(Result);
end;

initialization
  CS := TCriticalSection.Create;

finalization
  FreeAndNil(CS);

end.
