unit vtReportBuilder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  vtMulti, vteditbox, vtFileStorage,

  Vcl.Grids, Vcl.ValEdit, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.ComCtrls, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, Data.DB, uADCompClient, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, Vcl.ImgList, Vcl.Menus,
  vtReportBuilderExport, vtReportBuilderFilter, vtScrollBox, vtDragAndDrop,
  vtCashedData,
  System.Generics.Collections, System.Generics.Defaults;

type

  TReportFormElement = class
  private
    FElementNo: Integer;
    FCaption: String;
    FFormName: String;
    FIsSelected: Boolean;
    FNode: TTreeNode;
    function GetStateImageIndex: Integer;
    procedure SetIsSelected(const Value: Boolean);
  public
    property ElementNo: Integer read FElementNo write FElementNo;
    property Caption: String read FCaption write FCaption;
    property FormName: String read FFormName write FFormName;
    property IsSelected: Boolean read FIsSelected write SetIsSelected;
    property StateImageIndex: Integer read GetStateImageIndex;
    property Node: TTreeNode read FNode write FNode;
    procedure RedrawNode;
  end;

  TReportForm = class(TObjectList<TReportFormElement>)
  private
    FFormNo: Integer;
    FFormName: String;
    FormAbrev: String;
    FFormInst: String;
    FFormDfm: String;
    FNode: TTreeNode;
    function GetIsSelected: Boolean;
    function GetStateImageIndex: Integer;
    procedure SetIsSelected(const Value: Boolean);
  public
    property FormNo: Integer read FFormNo write FFormNo;
    property FormName: String read FFormName write FFormName;
    property FormInst: String read FFormInst write FFormInst;
    property FormDfm: String read FFormDfm write FFormDfm;
    property IsSelected: Boolean read GetIsSelected write SetIsSelected;
    property StateImageIndex: Integer read GetStateImageIndex;
    property Node: TTreeNode read FNode write FNode;
    procedure RebuildNode;
    procedure RedrawNode;
  end;

  TReportForms = class(TObjectList<TReportForm>)
  public
    procedure RebuildTree(ATree: TTreeView);
    function FindForm(AFormName: String): TReportForm;
  end;

  TfrmReportBuilder = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    pcMain: TPageControl;
    tsDesignReport: TTabSheet;
    tsPreview: TTabSheet;
    BitBtn3: TBitBtn;
    gbForms: TGroupBox;
    tvFormsData: TTreeView;
    conClients: TADConnection;
    tblClients: TADTable;
    conForms: TADConnection;
    tblForms: TADTable;
    ImageList1: TImageList;
    gbClient: TGroupBox;
    gbFields: TGroupBox;
    chlbFields: TCheckListBox;
    Panel3: TPanel;
    chCheckAll: TCheckBox;
    pnlDataBase: TPanel;
    Label1: TLabel;
    edtDataBase: TEdit;
    btnBrowseDataBase: TButton;
    pnlFormPreview: TPanel;
    Splitter1: TSplitter;
    grReport: TStringGrid;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    lblTemplate: TLabel;
    lblFormHint: TLabel;
    lblTreeHint: TLabel;
    gbFilters: TGroupBox;
    Splitter2: TSplitter;
    sbFilter: TvtScrollBox;
    chbDisableFilter: TCheckBox;
    pnlProgress: TPanel;
    btnCancel: TButton;
    pb: TProgressBar;
    lblProgress: TLabel;
    pmElement: TPopupMenu;
    miAddfieldtoexport: TMenuItem;
    miRemovefieldfromexport: TMenuItem;
    miAddtoFilter: TMenuItem;
    N1: TMenuItem;
    GroupBox1: TGroupBox;
    Panel4: TPanel;
    MainMenu1: TMainMenu;
    miTemplates: TMenuItem;
    miLoadtemplate: TMenuItem;
    miSavetemplate: TMenuItem;
    miSavetemplateas: TMenuItem;
    miExport: TMenuItem;
    Splitter3: TSplitter;
    ListView1: TListView;
    procedure btnBrowseDataBaseClick(Sender: TObject);
    procedure chCheckAllClick(Sender: TObject);
    procedure tvFormsDataDblClick(Sender: TObject);
    procedure tvFormsDataMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure tvFormsDataChange(Sender: TObject; Node: TTreeNode);
    procedure pcMainChange(Sender: TObject);
    procedure btnSaveTemplateClick(Sender: TObject);
    procedure btnLoadTemplateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvFormsDataKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure tvFormsDataMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvFormsDataStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure pmElementPopup(Sender: TObject);
    procedure miAddfieldtoexportClick(Sender: TObject);
    procedure miAddtoFilterClick(Sender: TObject);
    procedure tvFormsDataDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvFormsDataDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvFormsDataEdited(Sender: TObject; Node: TTreeNode;
      var S: string);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

  private
    { Private declarations }
    FApp: TApp;
    FPreview: TForm;
    FCurrentTemplate: String;
    FCurrentFormNode: TTreeNode;
    FFilterDisplay: TFilterDisplay;
    FCashedReturns: TCashedReturns;
    FSSQLite: TSQLiteStorage;
    FS: TFileStorage;
    FBuildStop: Boolean;
    FDragObject: TDragElement;
    FCashedDataFilled: Boolean;
    FReportForms: TReportForms;
    function Init: Boolean;
    function Connect: Boolean;
    function FillFields(ARefill: Boolean = False): Boolean;
    function FillFormsTree: Boolean;
    procedure ToggleState(AElement: TReportFormElement); overload;
    procedure ToggleState(AForm: TReportForm); overload;
    procedure ToggleState(ANode: TTreeNode); overload;
    procedure LoadFormPreviw(ANode: TTreeNode); overload;
    procedure LoadFormPreviw(AForm: TReportForm); overload;
    procedure EditDblClick(Sender: TObject);
    procedure BuildReport;
    function FindEdit(AEditID: Integer): TvtEdit;
    procedure SetColor(AEdit: TvtEdit; AState: Integer);
    procedure ExportItemClick(Sender: TObject);
    procedure OnGetOperatorValue(const AOperatorKind: TOperatorKind; const AOperatorLink: String;
      var AValue: String);
    function HasFilter(AOperatorKinds: TOperatorKinds): Boolean;
    function FilterOk: Boolean;
    procedure ShowProgressPanel;
    procedure HideProgressPanel;
    procedure UpdateProgress(const APosition, AMax: Integer);
    function GetFormElementByEdit(AEdit: TvtEdit): TReportFormElement;
  public
    { Public declarations }
  end;

procedure ReportBuilder(AApp: TApp);

implementation

uses
  {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON}, vtDataBase, vtShared, vtTrimStr, vtCommon,//20170811 Igor
  Xml.XMLIntf, Xml.XMLDoc, ComObj, ActiveX;
{$R *.dfm}

const
  c_ImageIndex_Uncheck = 1;
  c_ImageIndex_Check = 2;
  c_ImageIndex_NullCheck = 5;
  c_ImageIndex_Form = 3;
  c_ImageIndex_Field = 4;

procedure ReportBuilder(AApp: TApp);
begin
  with TfrmReportBuilder.Create(Application) do
  begin
    try
       FApp := AApp;
       if not Init then
         exit;
       ShowModal;
    finally
      free;
    end;
  end;
end;

{ TfrmReportBuilder }

function TfrmReportBuilder.FindEdit(AEditID: Integer): TvtEdit;
var
  C: TComponent;
begin
  if not Assigned(FPreview) then
    exit(nil);
  C := FPreview.FindComponent('vtEdit' + IntToStr(AEditID));
  if Assigned(C) and (C is TvtEdit) then
    Result := TvtEdit(C)
  else
    Result := nil;
end;

procedure TfrmReportBuilder.SetColor(AEdit: TvtEdit; AState: Integer);
begin
  if not Assigned(AEdit) then
    exit;
  if AState = c_ImageIndex_Uncheck then
    AEdit.Color := clWindow
  else
    AEdit.Color := $004080FF;
end;

procedure TfrmReportBuilder.ShowProgressPanel;
begin
  FBuildStop := False;
  pnlProgress.SetBounds((Self.ClientWidth - pnlProgress.Width) div 2,
                        (Self.ClientHeight - pnlProgress.Height) div 2,
                        pnlProgress.Width, pnlProgress.Height);
  UpdateProgress(1, tblClients.RecordCount);
  pnlProgress.Visible := True;
end;

procedure TfrmReportBuilder.ToggleState(AElement: TReportFormElement);
begin
  if AElement = nil then
    exit;
  AElement.IsSelected := not AElement.IsSelected;
  if AElement.IsSelected AND not Assigned(AElement.Node) then
  begin
    AElement.Node := tvFormsData.Items.AddChildObject(FCurrentFormNode, AElement.Caption, AElement);
    AElement.RedrawNode;
  end
  else
  if not AElement.IsSelected AND Assigned(AElement.Node) then
  begin
    AElement.Node.Free;
    AElement.Node := nil;
  end;
  FReportForms.FindForm(AElement.FormName).RedrawNode;
  SetColor(FindEdit(AElement.ElementNo), AElement.GetStateImageIndex);
end;

procedure TfrmReportBuilder.ToggleState(AForm: TReportForm);
var
  E: TReportFormElement;
begin
  if AForm = nil then
    exit;
  AForm.IsSelected := False; //not AForm.IsSelected; {do not allow select all elements}
  for E in AForm do
    SetColor(FindEdit(E.ElementNo), E.GetStateImageIndex);
end;

procedure TfrmReportBuilder.ToggleState(ANode: TTreeNode);
begin
  if not Assigned(ANode) then
    exit;
  if ANode.Level = 0 then
    ToggleState(TReportForm(ANode.Data))
  else
  if ANode.Level = 1 then
    ToggleState(TReportFormElement(ANode.Data));
end;

procedure TfrmReportBuilder.btnBrowseDataBaseClick(Sender: TObject);
var
  S: String;
begin
  S := edtDataBase.Text;
  if not SelectDirectory(S, [], 0) then
    exit;
  if not FApp.isValidDataDir(S) then
    exit;
  if not FileExists(IncludeTrailingPathDelimiter(S) + FApp.ClientsDBLite) then
  begin
    MessageDlg('Client database not found in this directory.', mtWarning, [mbOk], 0);
    Exit;
  end;
  edtDataBase.Text := S;
  Connect;
  FillFields(True);
end;

procedure TfrmReportBuilder.btnLoadTemplateClick(Sender: TObject);
var
  XML: TXMLDocument;
  Root, ClientData, FormData, Form, Field, Filters: IXMLNode;
  I, J: Integer;
  N: TTreeNode;
  F: TReportForm;
  E: TReportFormElement;

begin
  OpenDialog1.Filter := 'ReportBuilder template files|*.' + FApp.AppId + 'RB';
  if not OpenDialog1.Execute then
    exit;
  XML := TXMLDocument.Create(Self);
  try
    try
      XML.LoadFromFile(OpenDialog1.FileName);
      XML.Active := True;
      Root := XML.ChildNodes.FindNode('TEMPLATE');
      if Root = nil then
        raise Exception.Create('Bad file format');
      ClientData := Root.ChildNodes.FindNode('ClientData');
      FormData := Root.ChildNodes.FindNode('FormData');
      Filters := Root.ChildNodes.FindNode('Filters');
      if (ClientData = nil) or (FormData = nil) then
        raise Exception.Create('Bad file format');
      for I := 0 to chlbFields.Count - 1 do
        chlbFields.Checked[I] := ClientData.ChildNodes.FindNode(chlbFields.Items[I]) <> nil;
      for F in FReportForms do
      begin
        Form := FormData.ChildNodes.FindNode('Form_' + F.FormName);
        if (Form <> nil) then
        begin
          if F.Count = 0 then
            LoadFormPreviw(F);
          for E in F do
          begin
            Field := Form.ChildNodes.FindNode('Field_' + IntToStr(E.ElementNo));
            E.IsSelected := Assigned(Field);
            if (Field <> nil) AND
               (Field.AttributeNodes.FindNode('Caption') <> nil) and
               (VarToStr(Field.Attributes['Caption']) <> '') then
              E.Caption := VarToStr(Field.Attributes['Caption']);
            SetColor(FindEdit(E.ElementNo), E.StateImageIndex);
          end;
          F.RebuildNode;
        end;
      end;
      if Filters <> nil then
      begin
        if Filters.AttributeNodes.FindNode('Disabled') <> nil then
          chbDisableFilter.Checked := Boolean(Filters.Attributes['Disabled']);
        FFilterDisplay.LoadFromXML(Filters.ChildNodes.First);
      end;

      FCurrentTemplate := OpenDialog1.FileName;
      lblTemplate.Caption := 'Template: ' + OpenDialog1.FileName;
    except
      MessageDlg('Bad file format', mtError, [mbOk], 0);
      exit;
    end;
  finally
    XML.Free;
  end;
end;

procedure TfrmReportBuilder.btnSaveTemplateClick(Sender: TObject);
var
  FileName: String;
  XML: TXMLDocument;
  Root, ClientData, FormData, Form, Filters: IXMLNode;
  I, J: Integer;
  N: TTreeNode;
  F: TReportForm;
  E: TReportFormElement;
begin
  if ((Sender is TComponent) and (TComponent(Sender).Tag = 1))
     or
     (FCurrentTemplate = '') then
  begin
    SaveDialog1.Filter := 'ReportBuilder template files|*.' + FApp.AppId + 'RB';
    if System.SysUtils.ForceDirectories(IncludeTrailingPathDelimiter(FApp.AppDir) + 'ReportTemplates\') then//20170811 Igor
      SaveDialog1.InitialDir := IncludeTrailingPathDelimiter(FApp.AppDir) + 'ReportTemplates'
    else
      SaveDialog1.InitialDir := IncludeTrailingPathDelimiter(MyDocument);
    SaveDialog1.FileName := 'NewTemplate.' + FApp.AppId + 'RB';
    if not SaveDialog1.Execute then
      exit;
    FileName := SaveDialog1.FileName;
    if not SameText(ExtractFileExt(FileName), '.' + FApp.AppId + 'RB') then
      FileName := FileName + '.' + FApp.AppId + 'RB';
  end
  else
    FileName := FCurrentTemplate;
  XML := TXMLDocument.Create(Self);
  try
    XML.Active := True;
    XML.Encoding := 'utf-8';
    XML.Version := '1.0';
    Root := XML.AddChild('TEMPLATE');
    ClientData := Root.AddChild('ClientData');
    for I := 0 to chlbFields.Count - 1 do
      if chlbFields.Checked[I] then
        ClientData.AddChild(chlbFields.Items[I]);
    FormData := Root.AddChild('FormData');

    for F in FReportForms do
    begin
      if not F.IsSelected then
        Continue;
      Form := FormData.AddChild('Form_' + F.FormName);
      for E in F do
      begin
        if E.IsSelected then
          with Form.AddChild('Field_' + IntToStr(E.ElementNo)) do
            Attributes['Caption'] := E.Caption;
      end;
    end;
    Filters := Root.AddChild('Filters');
    Filters.Attributes['Disabled'] := chbDisableFilter.Checked;
    FFilterDisplay.SaveToXML(Filters);
    XML.SaveToFile(FileName);
    FCurrentTemplate := FileName;
    lblTemplate.Caption := 'Template: ' + FileName;
  finally
    XML.Free;
  end;
end;

procedure TfrmReportBuilder.BuildReport;
type
  TFormElement = record
    FormNo: Integer;
    FormName: String;
    FormInst: String;
    ElementNo: Integer;
    ColNo: Integer;
  end;
var

  I, J, R, I2: Integer;

  A: TArray<TFormElement>;
  LastFormNo: Integer;
  F: TReportForm;
  E: TReportFormElement;
const
  AddW = 12;
begin
  ShowProgressPanel;
  try
    grReport.RowCount := 1;
    grReport.ColCount := 1;
    try
      grReport.Cells[0, 0] := '#';
      grReport.ColWidths[0] := grReport.Canvas.TextWidth('#') + AddW;
      for I := 0 to chlbFields.Count - 1 do
      begin
        if chlbFields.Checked[I] then
        begin
          grReport.ColCount := grReport.ColCount + 1;
          grReport.Cells[grReport.ColCount - 1, 0] := chlbFields.Items[I];
          grReport.ColWidths[grReport.ColCount - 1] := grReport.Canvas.TextWidth(chlbFields.Items[I]) + AddW;
        end;
      end;
      SetLength(A, 0);
      for F in FReportForms do
      begin
        Application.ProcessMessages;
        if FBuildStop then
          exit;
        if F.IsSelected then
        begin
          for E in F do
          begin
            if E.IsSelected then
            begin
              grReport.ColCount := grReport.ColCount + 1;
              grReport.Cells[grReport.ColCount - 1, 0] := F.FormName + ' | ' + E.Caption;
              grReport.ColWidths[grReport.ColCount - 1] := grReport.Canvas.TextWidth(grReport.Cells[grReport.ColCount - 1, 0]) + AddW;
              SetLength(A, Length(A) + 1);
              with A[Length(A) - 1] do
              begin
                FormNo := F.FormNo;
                FormName := F.FormName;
                FormInst := F.FormInst;
                ElementNo := E.ElementNo;
                ColNo := grReport.ColCount - 1;
              end;
            end;
          end;
        end;
      end;
      R := 1;
      tblClients.First;
      FSSQLite := nil;
      FS := nil;
      I2 := 1;

      while not tblClients.Eof do
      begin
        UpdateProgress(I2, tblClients.RecordCount);
        inc(I2);
        if FBuildStop then
          exit;
        if HasFilter([okFormField]) or (length(A) > 0) and not FCashedDataFilled then
        begin
          if FileExists(IncludeTrailingPathDelimiter(edtDataBase.Text) + tblClients.FieldByName('FILE_NAME').AsString) then
          begin
            FSSQLite := TSQLiteStorage.Create(edtDataBase.Text, tblClients.FieldByName('FILE_NAME').AsString, fsRead, FApp.SQLLitePassword.PassRFArray);
            if FSSQLite.LastError <> '' then
            begin
              FreeAndNil(FSSQLite);
              try
                FS := TFileStorage.Create(edtDataBase.Text, tblClients.FieldByName('FILE_NAME').AsString, fsRead);
              except
                FreeAndNil(FS);
              end;
            end;
          end;
        end;
        try
          if not FCashedDataFilled and (Assigned(FSSQLite) or Assigned(FS)) then
            CashReturn(FCashedReturns.AddCashedReturn(tblClients.FieldByName('FILE_NAME').AsString), FSSQLite, FS);
          if not HasFilter([]) or FilterOk then
          begin
            grReport.RowCount := grReport.RowCount + 1;
            J := 1;
            grReport.Cells[0, R] := IntToStr(R);
            for I := 0 to chlbFields.Count - 1 do
            begin
              if chlbFields.Checked[I] then
              begin
                grReport.Cells[J, R] := FApp.MaskClientDataForBuildReport(
                  TField(chlbFields.Items.Objects[I]).FieldName, TField(chlbFields.Items.Objects[I]).AsString);
                inc(J);
              end;
            end;

            if (length(A) > 0) then
            begin
              Application.ProcessMessages;
              if FBuildStop then
                exit;
              //read return
              if Assigned(FSSQLite) or Assigned(FS) then
              begin
                {TODO: Make export sleeps and tables}
                for I := 0 to length(A) - 1 do
                begin
                  grReport.Cells[J, R] := FApp.MaskFormDataForBuildReport(A[I].FormName,
                    A[I].ElementNo, vtFileStorage.ReadElementValue(A[I].FormName, A[I].ElementNo, FSSQLite, FS));
                  Application.ProcessMessages;
                  inc(J);
                end;
              end
              else
              if FCashedDataFilled then
              begin
                for I := 0 to length(A) - 1 do
                begin
                  grReport.Cells[J, R] := FApp.MaskFormDataForBuildReport(
                    A[I].FormName,
                    A[I].ElementNo,
                    FCashedReturns.GetValue(tblClients.FieldByName('FILE_NAME').AsString,
                                            A[I].FormName,
                                            ['O','D','M'],
                                            A[I].ElementNo));
                  Application.ProcessMessages;
                  inc(J);
                end;
              end;
              begin
                for I := 0 to length(A) - 1 do
                begin
                  grReport.Cells[J, R] := '';
                  inc(J);
                end;
              end;
              //fillData
            end;
            inc(R);
          end;
        finally
          FreeAndNil(FSSQLite);
          FreeAndNil(FS);
        end;
        tblClients.Next;
        FCashedDataFilled := FCashedDataFilled or (tblClients.Eof AND (FCashedReturns.Count > 0));
      end;
    finally
      if grReport.RowCount = 1 then
      begin
        tsPreview.Caption := Format('Preview (%d rows)', [0]);
        grReport.RowCount := 2;
        grReport.Rows[1].Clear;
      end
      else
        tsPreview.Caption := Format('Preview (%d rows)', [grReport.RowCount - 1]);
      grReport.FixedRows := 1;
    end;
  finally
    HideProgressPanel;
    if not FCashedDataFilled then
      FCashedReturns.Clear;
  end;

end;

procedure TfrmReportBuilder.chCheckAllClick(Sender: TObject);
begin
  if chCheckAll.Checked then
    chlbFields.CheckAll(cbChecked)
  else
    chlbFields.CheckAll(cbUnchecked);
end;

function TfrmReportBuilder.Connect: Boolean;
begin
  FCashedReturns.Clear;
  FCashedDataFilled := False;
  conClients.Close;
  Result := SetTableName(conClients, tblClients, IncludeTrailingPathDelimiter(edtDataBase.Text) + FApp.ClientsDBLite,
    ClientsTableLite, '', false);
  if Result then
    if not conForms.Connected then
    begin
      Result := SetTableName(conForms, tblForms, IncludeTrailingPathDelimiter(FApp.AppDir) + FApp.FormsDBLite,
        FApp.FormsTableLite, '', false)
    end;
  if not Result then
  begin
    conClients.Close;
    conForms.Close;
  end;
end;

procedure TfrmReportBuilder.EditDblClick(Sender: TObject);
begin
  if not Assigned(Sender) then
    exit;
  if not (Sender is TvtEdit) then
    exit;

  if FCurrentFormNode = nil then
    exit;
  ToggleState(GetFormElementByEdit(TvtEdit(Sender)));
end;

procedure TfrmReportBuilder.ExportItemClick(Sender: TObject);
begin
  Assert(Assigned(Sender));
  Assert(Sender is TMenuItem);
  if pcMain.ActivePage <> tsPreview then
    BuildReport;
  ExportWorkerManager.ExportTo((Sender as TMenuItem).Tag, grReport, FApp.Dir_ClientDocs,
    FFilterDisplay.FilterElement.AsString);
end;

function TfrmReportBuilder.FillFields(ARefill: Boolean = False): Boolean;
var
  F: TField;
  I: Integer;
  Checked: array of string;

  function AllowExport(const AFieldName: String): Boolean;
  begin
    Result := not (SameText(AFieldName, 'FILE_NAME') or
                   SameText(AFieldName, 'SIN') or
                   SameText(AFieldName, 'BIRTHDATE'))
              or FApp.AllowAllFieldsForBuildReport; //20210121 Igor
  end;

  function DefaultChecked(const AFieldName: String): Boolean;
  begin
    Result := SameText(AFieldName, 'FIRST_NAME') or
              SameText(AFieldName, 'LAST_NAME');
  end;

  function isChecked(AFieldName: string): Boolean;
  var
    S: String;
  begin
    if not ARefill then
      Result :=  DefaultChecked(AFieldName)
    else
    begin
      for S in Checked do
        if SameText(S, AFieldName) then
          Exit(True);
      Result := False;
    end;
  end;

begin
  if ARefill then
  begin
    SetLength(Checked, 0);
    for I := 0 to chlbFields.Count - 1 do
      if chlbFields.Checked[I] then
      begin
        SetLength(Checked, Length(Checked) + 1);
        Checked[Length(Checked) - 1] := chlbFields.Items[I];
      end;
  end;
  chlbFields.Items.BeginUpdate;
  try
    chlbFields.Items.Clear;
    if not tblClients.Active then
      exit(False);
    for F in tblClients.Fields do
      if AllowExport(F.FieldName) then
        chlbFields.Checked[chlbFields.Items.AddObject(F.FieldName, F)] := isChecked(F.FieldName);
    Result := True;
  finally
    chlbFields.Items.EndUpdate;
  end;
end;

function TfrmReportBuilder.FillFormsTree: Boolean;
var
  F: TReportForm;
  Comparer: IComparer<TReportFormElement>;
begin
  try
    tblForms.First;
    Comparer := TDelegatedComparer<TReportFormElement>.Create(
        function(const Left, Right: TReportFormElement): Integer
        begin
          Result := Left.ElementNo - Right.ElementNo;
        end);
    while not tblForms.Eof do
    begin
      if (tblForms.FieldByName('FORMSHOW').AsInteger = 1) AND
         FApp.AllowFormForBuildReport(tblForms.FieldByName('FORMNAME').AsString)  then
      begin
        F := TReportForm.Create(Comparer);
        F.FormNo := tblForms.FieldByName('FORMNO').AsInteger;
        F.FormName := tblForms.FieldByName('FORMNAME').AsString;
        F.FormAbrev := tblForms.FieldByName('FormAbrev').AsString;
        F.FormInst := tblForms.FieldByName('FORMINST').AsString;
        F.FormDfm := IncludeTrailingPathDelimiter(FApp.AppDir);
        If IsDevelopmentMode then
          F.FormDfm := IncludeTrailingPathDelimiter(F.FormDfm + FApp.AppName + 'Forms');//20170731 Igor
        F.FormDfm := F.FormDfm + 'u' + F.FormName + '.dfm';
        FReportForms.Add(F);
      end;
      tblForms.Next;
    end;
    FReportForms.RebuildTree(tvFormsData);
    Result := True;
  except ON E: Exception do
    begin
      Result := False;
      MessageDlg(E.Message, mtError, [mbOk], 0);
    end;
  end;
end;

function TfrmReportBuilder.FilterOk: Boolean;
begin
  Result := FFilterDisplay.FilterElement.Result;
end;

procedure TfrmReportBuilder.FormCreate(Sender: TObject);
var
  I: Integer;
  mi: TMenuItem;
begin
  for I := 0 to ExportWorkerManager.ExportWorkers.Count - 1 do
  begin
    mi := TMenuItem.Create(MainMenu1);
    mi.Caption := ExportWorkerManager.ExportWorkers[I].ExporterCaption;
    mi.OnClick := ExportItemClick;
    mi.Tag := I;
    miExport.Add(mi);
  end;

  FFilterDisplay := TFilterDisplay.CreateAsRoot(Self);
  FFilterDisplay.Parent := sbFilter;
  FFilterDisplay.Top := 0;
  FFilterDisplay.Left := 0;
  FFilterDisplay.Width := 360;
  FFilterDisplay.FilterElement := TFilterGroup.CreateNew(nil, nil);
  FFilterDisplay.OnGetOperatorValue := Self.OnGetOperatorValue;
  FCashedReturns := TCashedReturns.Create;
  FCashedDataFilled := False;
  FReportForms := TReportForms.Create;
end;

procedure TfrmReportBuilder.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPreview);
  FreeAndNil(FFilterDisplay);
  FreeAndNil(FDragObject);
  FreeAndNil(FCashedReturns);
  FreeAndNil(FReportForms);
end;

function TfrmReportBuilder.HasFilter(AOperatorKinds: TOperatorKinds): Boolean;
begin
  Result := not chbDisableFilter.Checked AND FFilterDisplay.FilterElement.HasConditionFilters(AOperatorKinds);
end;

procedure TfrmReportBuilder.HideProgressPanel;
begin
  pnlProgress.Visible := False;
end;

function TfrmReportBuilder.Init: Boolean;
begin
  edtDataBase.Text := FApp.Dir_Cur;
  pcMain.ActivePage := tsDesignReport;
  Result := Connect and
            FillFields and
            FillFormsTree;
end;

procedure TfrmReportBuilder.LoadFormPreviw(AForm: TReportForm);
var
  C: TComponent;
  E: TReportFormElement;
  NeedFeelForm: Boolean;
begin
  NeedFeelForm := AForm.Count = 0;
  FreeAndNil(FPreview);
  if not FileExists(AForm.FormDfm) then
    exit;
  FCurrentFormNode := AForm.Node;

  FPreview := TForm.Create(Self);
  try
    ReadComponentResFile(AForm.FormDfm, FPreview);
  except
    FreeAndNil(FPreview);
  end;
  FPreview.Parent := pnlFormPreview;
  FPreview.BorderStyle := bsNone;
  FPreview.Align := alClient;
  for C in FPreview do
    if (C is TvtEdit) AND TvtEdit(C).Visible then
    begin
      if NeedFeelForm then
      begin
        E := TReportFormElement.Create;
        E.ElementNo := TvtEdit(C).FieldId;
        E.Caption := 'Element #' + IntToStr(E.ElementNo);
        E.FormName := AForm.FormName;
        E.IsSelected := False;
        AForm.Add(E);
      end;
      TvtEdit(C).Text := ShowFieldId(IntToStr(TvtEdit(C).FieldId));
      TvtEdit(C).OnDblClick := EditDblClick;
      TvtEdit(C).ReadOnly := True;
      TvtEdit(C).DragMode := dmManual;
      TvtEdit(C).OnMouseDown := tvFormsDataMouseDown;
      TvtEdit(C).OnStartDrag := tvFormsDataStartDrag;
      TvtEdit(C).PopupMenu := pmElement;
    end;
  for E in AForm do
    SetColor(FindEdit(E.ElementNo), E.StateImageIndex);
  FPreview.visible := True;
  FPreview.AutoScroll := True;
end;

procedure TfrmReportBuilder.LoadFormPreviw(ANode: TTreeNode);
begin
  if ANode.Level = 1 then
    ANode := ANode.Parent;
  if FCurrentFormNode = ANode then
    exit;
  LoadFormPreviw(TReportForm(ANode.Data));
end;

procedure TfrmReportBuilder.miAddfieldtoexportClick(Sender: TObject);
begin
  if pmElement.PopupComponent = tvFormsData then
    ToggleState(tvFormsData.Selected)
  else
  if (pmElement.PopupComponent = chlbFields) and (chlbFields.ItemIndex >= 0) then
    chlbFields.Checked[chlbFields.ItemIndex] := not chlbFields.Checked[chlbFields.ItemIndex]
  else
  if pmElement.PopupComponent is TvtEdit then
    ToggleState(GetFormElementByEdit(TvtEdit(pmElement.PopupComponent)));
end;

procedure TfrmReportBuilder.miAddtoFilterClick(Sender: TObject);
var
  E: TReportFormElement;
  FE: TFilterCommonElement;
  V: string;
begin
  if (pmElement.PopupComponent = tvFormsData) or (pmElement.PopupComponent is TvtEdit) then
  begin
    if (pmElement.PopupComponent = tvFormsData) then
    begin
      if tvFormsData.Selected = nil then
        exit;
      if tvFormsData.Selected.Level = 0 then
        V := TReportForm(tvFormsData.Selected.Data).FormName
      else
      if tvFormsData.Selected.Level = 1 then
        V := TReportFormElement(tvFormsData.Selected.Parent.Data).FormName + '.' +
          TReportFormElement(tvFormsData.Selected.Data).ElementNo.ToString
      else
        exit;
    end
    else
    if (pmElement.PopupComponent is TvtEdit) then
    begin
      E := GetFormElementByEdit(TvtEdit(pmElement.PopupComponent));
      if not Assigned(E) then
        Exit;
      V := E.FormName + '.' + E.ElementNo.ToString;
    end
    else
      Exit;
    FFilterDisplay.AddCondition;
    FE := FFilterDisplay.ChildDisplays.Last.FilterElement;
    if FE is TFilterCondition then
      TFilterCondition(FE).SetValues(okFormField, V, okConst, '', opEqual);
  end
  else
  if (pmElement.PopupComponent = chlbFields) and (chlbFields.ItemIndex >= 0) then
  begin
    FFilterDisplay.AddCondition;
    FE := FFilterDisplay.ChildDisplays.Last.FilterElement;
    if FE is TFilterCondition then
    begin
      TFilterCondition(FE).SetValues(okDBField, TField(chlbFields.Items.Objects[chlbFields.ItemIndex]).FieldName,
                                     okConst, '', opEqual);
    end;
  end;
end;

procedure TfrmReportBuilder.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FFilterDisplay) and (Operation = opRemove) then
    FFilterDisplay := nil;
end;

procedure TfrmReportBuilder.OnGetOperatorValue(
  const AOperatorKind: TOperatorKind; const AOperatorLink: String;
  var AValue: String);
  const
    c_badFormat = 'Bed format "%s". (need "<Form Name>.<Element No>" ex. "T1.1")';
  function GetFormName(AStr: String): String;
  begin
    if pos('.', AStr) > 0 then
      Result := Copy(AStr, 1, pos('.', AStr) - 1)
    else
      raise Exception.Create(format(c_badFormat,[AStr]));
  end;
  function GetElementNo(AStr: String): Integer;
  begin
    if pos('.', AStr) > 0 then
    begin
      Delete(AStr, 1, pos('.', AStr));
      if not TryStrToInt(ASTr, Result) then
        raise Exception.Create(format(c_badFormat,[AStr]));
    end
    else
      raise Exception.Create(format(c_badFormat,[AStr]));
  end;
begin
  case AOperatorKind of
    okDBField:
      Begin
        if tblClients.FindField(AOperatorLink) <> nil then
          AValue := tblClients.FieldByName(AOperatorLink).AsString
        else
          raise Exception.Create('Field "' + AOperatorLink + '" not found!');
      end;
    okFormField:
      begin
        if FCashedDataFilled then
          AValue := FCashedReturns.GetValue(tblClients.FieldByName('FILE_NAME').AsString,
                                            GetFormName(AOperatorLink),
                                            ['O','D','M'],
                                            GetElementNo(AOperatorLink))
        else
          AValue := vtFileStorage.ReadElementValue(GetFormName(AOperatorLink), GetElementNo(AOperatorLink), FSSQLite, FS)
      end;
    okConst:
      begin
        AValue := AValue;
      end;
  end;
end;

procedure TfrmReportBuilder.pcMainChange(Sender: TObject);
begin
  if pcMain.ActivePage = tsPreview then
    BuildReport;
end;

function TfrmReportBuilder.GetFormElementByEdit(AEdit: TvtEdit): TReportFormElement;
var
  I: Integer;
  F: TReportForm;
  E: TReportFormElement;
begin
  if FCurrentFormNode = nil then
    Exit(nil);
  F := TReportForm(FCurrentFormNode.Data);
  I := AEdit.FieldId;
  for E in F do
    if E.ElementNo = I then
      Exit(E);
  Result := nil;
end;

procedure TfrmReportBuilder.pmElementPopup(Sender: TObject);
var
  E: TReportFormElement;
begin
  if pmElement.PopupComponent = tvFormsData then
  begin
    miAddfieldtoexport.Enabled := (tvFormsData.Selected <> nil) AND
                                  //(tvFormsData.Selected.Level = 1) AND
                                  (tvFormsData.Selected.StateIndex <> c_ImageIndex_Check);
    miRemovefieldfromexport.Enabled := (tvFormsData.Selected <> nil) AND
                                       //(tvFormsData.Selected.Level = 1) AND
                                       (tvFormsData.Selected.StateIndex = c_ImageIndex_Check);
    miAddtoFilter.Enabled := (tvFormsData.Selected <> nil) AND
                             (tvFormsData.Selected.Level = 1);
  end
  else
  if pmElement.PopupComponent = chlbFields then
  begin
    miAddfieldtoexport.Enabled := (chlbFields.ItemIndex >= 0) AND
                                  not (chlbFields.Checked[chlbFields.ItemIndex]);
    miRemovefieldfromexport.Enabled := (chlbFields.ItemIndex >= 0) AND
                                  (chlbFields.Checked[chlbFields.ItemIndex]);
    miAddtoFilter.Enabled := (chlbFields.ItemIndex >= 0);
  end
  else
  if pmElement.PopupComponent is TvtEdit then
  begin
    E := GetFormElementByEdit(TvtEdit(pmElement.PopupComponent));

    miAddfieldtoexport.Enabled := Assigned(E) AND not E.IsSelected;
    miRemovefieldfromexport.Enabled := Assigned(E) AND E.IsSelected;
    miAddtoFilter.Enabled := Assigned(E);
  end;
end;

procedure TfrmReportBuilder.tvFormsDataChange(Sender: TObject; Node: TTreeNode);
var
  FieldID: Integer;
  C: TComponent;
begin
  if Node = nil then
    exit;
  LoadFormPreviw(Node);

  if (Node.Level = 1) and Assigned(FPreview) then
  begin
    FieldID := TReportFormElement(Node.Data).ElementNo;
    C := FPreview.FindComponent('vtEdit' + IntToStr(FieldID));
    if Assigned(C) AND (C is TvtEdit) AND TvtEdit(C).CanFocus then
    begin
      FPreview.ScrollInView(TvtEdit(C));
      TvtEdit(C).SetFocus;
    end;
  end;
end;

procedure TfrmReportBuilder.tvFormsDataDblClick(Sender: TObject);
begin
  ToggleState(tvFormsData.Selected);
end;

procedure TfrmReportBuilder.tvFormsDataDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  E: TReportFormElement;
begin
  if (Source is TDragElement) AND (TDragElement(Source).OriginalSender is TvtEdit) then
  begin
    E := GetFormElementByEdit(TvtEdit(TDragElement(Source).OriginalSender));
    if not E.IsSelected then
      ToggleState(E);
  end;
end;

procedure TfrmReportBuilder.tvFormsDataDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TDragElement) AND (TDragElement(Source).OriginalSender is TvtEdit);
end;

procedure TfrmReportBuilder.tvFormsDataEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
begin
  if Node.Level = 1 then
    TReportFormElement(Node.Data).Caption := S;
end;

procedure TfrmReportBuilder.tvFormsDataKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F2 then
    if tvFormsData.Selected <> nil then
      tvFormsData.Selected.EditText;

end;

procedure TfrmReportBuilder.tvFormsDataMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender = nil) then
    Exit;
  if not({(ssCtrl in Shift) and }(Button = mbLeft)) then
    Exit;
  if (Sender is TTreeView) then
  begin
    if ((Sender as TTreeView).Selected <> nil) and
       ((Sender as TTreeView).Selected.Level = 1) then
      (Sender as TTreeView).BeginDrag(False, 1);
  end
  else
  if (Sender is TvtEdit) then
  begin
    (Sender as TvtEdit).BeginDrag(False, 1);
  end
  else
  if (Sender is TCheckListBox) and
     ((Sender as TCheckListBox).ItemIndex <> -1) then
  begin
    (Sender as TCheckListBox).BeginDrag(False, 1);
  end;
end;

procedure TfrmReportBuilder.tvFormsDataMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  H: THitTests;
begin
  H := tvFormsData.GetHitTestInfoAt(X,Y);
  if htOnStateIcon in H then
    ToggleState(tvFormsData.Selected);
end;

procedure TfrmReportBuilder.tvFormsDataStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  FormName: string;
  ElementNo: Integer;
begin
  FreeAndNil(FDragObject);
  if not Assigned(Sender) then
    Exit;
  if not((Sender is TTreeView) or (Sender is TvtEdit) or (Sender is TCheckListBox)) then
    Exit;
  FDragObject := TDragElement.Create(Self);
  if (Sender is TTreeView) or (Sender is TvtEdit) then
  begin
    FDragObject.ElementKind := okFormField;
    if (Sender is TTreeView) then
      if ((Sender as TTreeView).Selected <> nil) and
         ((Sender as TTreeView).Selected.Level = 1) then
      begin
        FormName := TReportFormElement((Sender as TTreeView).Selected.Data).FormName;
        ElementNo := TReportFormElement((Sender as TTreeView).Selected.Data).ElementNo;
      end
      else
        exit//20170811 Igor
    else
    //if (Sender is TvtEdit) then//20170811 Igor
    begin
      FormName := TReportForm(FCurrentFormNode.Data).FormName;
      ElementNo := (Sender as TvtEdit).FieldId;
    end;
    FDragObject.ElementFullName := FormName + '.' + IntToStr(ElementNo);
  end
  else
  if (Sender is TCheckListBox) then
  begin
    FDragObject.ElementKind := okDBField;
    FDragObject.ElementFullName := TField(TCheckListBox(Sender).Items.Objects[TCheckListBox(Sender).ItemIndex]).FieldName;
  end;
  FDragObject.OriginalSender := Sender;
  DragObject := FDragObject;
end;

procedure TfrmReportBuilder.UpdateProgress(const APosition, AMax: Integer);
begin
  if pb.Max <> AMax then
    pb.Max := AMax;
  if pb.Position <> APosition then
    pb.Position := APosition;
  lblProgress.Caption := Format('%d of %d', [APosition, AMax]);
  Application.ProcessMessages;
end;

procedure TfrmReportBuilder.btnCancelClick(Sender: TObject);
begin
  FBuildStop := True;
end;

{ TReportForm }

function TReportForm.GetIsSelected: Boolean;
var
  E: TReportFormElement;
begin
  for E in Self do
    if E.IsSelected then
      Exit(True);
  Result := False;
end;

function TReportForm.GetStateImageIndex: Integer;
var
  E: TReportFormElement;
  I: Integer;
begin
  I := 0;
  for E in Self do
    if E.IsSelected then
      inc(I);
  if I = 0 then
    Result := c_ImageIndex_Uncheck
  else
  if I = Self.Count then
    Result := c_ImageIndex_Check
  else
    Result := c_ImageIndex_NullCheck;
end;

procedure TReportForm.RebuildNode;
var
  E: TReportFormElement;
begin
  if not Assigned(FNode) then
    exit;
  FNode.Owner.BeginUpdate;
  try
    RedrawNode;
    while FNode.Count > 0 do
      FNode.getFirstChild.Free;
    for E in Self do
    begin
      if E.IsSelected then
      begin
        E.Node := FNode.Owner.AddChildObject(FNode, E.Caption, E);
        E.RedrawNode;
      end
      else
        E.Node := nil;
    end;
  finally
    FNode.Owner.EndUpdate;
  end;
end;

procedure TReportForm.RedrawNode;
begin
  if not Assigned(FNode) then
    exit;
  FNode.ImageIndex := c_ImageIndex_Form;
  FNode.SelectedIndex := c_ImageIndex_Form;
  FNode.StateIndex := Self.StateImageIndex;
end;

procedure TReportForm.SetIsSelected(const Value: Boolean);
var
  E: TReportFormElement;
begin
  for E in Self do
    E.IsSelected := Value;
  RebuildNode;
end;

{ TReportForms }

function TReportForms.FindForm(AFormName: String): TReportForm;
var
  F: TReportForm;
begin
  for F in Self do
    if SameText(AFormName, F.FormName) then
      exit(F);
  Result := nil;
end;

procedure TReportForms.RebuildTree(ATree: TTreeView);
var
  F: TReportForm;
  N: TTreeNode;
begin
  if not Assigned(ATree) then
    exit;
  ATree.Items.BeginUpdate;
  try
    ATree.Items.Clear;
    for F in Self do
    begin
      N := ATree.Items.AddObject(nil, F.FormAbrev, F);
      F.Node := N;
      F.RebuildNode;
    end;
  finally
    ATree.Items.EndUpdate;
  end;
end;

{ TReportFormElement }

function TReportFormElement.GetStateImageIndex: Integer;
begin
  if Self.IsSelected then
    Result := c_ImageIndex_Check
  else
    Result := c_ImageIndex_Uncheck;
end;

procedure TReportFormElement.RedrawNode;
begin
  if not assigned(FNode) then
    exit;
  FNode.Text := Caption;
  FNode.ImageIndex := c_ImageIndex_Field;
  FNode.SelectedIndex := c_ImageIndex_Field;
  FNode.StateIndex := StateImageIndex;
end;

procedure TReportFormElement.SetIsSelected(const Value: Boolean);
begin
  if FIsSelected <> Value then
  begin
    FIsSelected := Value;
    RedrawNode;
  end;
end;

end.
