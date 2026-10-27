unit uData;

interface

uses
  System.SysUtils, System.Classes, uADGUIxIntf, uADGUIxFormsWait,
  uADStanExprFuncs, uADStanIntf, uADStanOption, uADStanError, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, Data.DB, uADCompDataSet,
  uADCompClient, uADPhysSQLite, uADCompGUIx, Dialogs;

const
  TRTOC_PWD = 'rc5fxD2FVwpucQww';
  //TRTOC_PWD = '';

type
  TdmData = class(TDataModule)
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    ADPhysSQLiteDriverLink1: TADPhysSQLiteDriverLink;
    MainConn: TADConnection;
    QTitles: TADQuery;
    QURLs: TADQuery;
    QURLsId: TADAutoIncField;
    QURLsCaption: TStringField;
    QURLsURL: TStringField;
    QURLsParentTitleId: TIntegerField;
    QURLsSeqNo: TIntegerField;
    dsURLs: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConnectTo(AFileName: string);
    function GetOrAddTitle(AParentTitleId: integer; ATitle: string): integer;
    function GetOrAddURL(AParentTitleId: integer; ACaption, AURL: string): integer;
    function GetMaxTitleSeqNo(AParentTitleId: integer): integer;
    function GetMaxURLSeqNo(AParentTitleId: integer): integer;
    procedure ExecSQL(ASQL: string);
    function Exists(ASQL: string): boolean;

    procedure UpdateTitleSeqNo;
    procedure UpdateURLSeqNo;
    function ExportToFile(AFileName: string): boolean;
  end;

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmData }

procedure TdmData.ConnectTo(AFileName: string);
begin
  MainConn.Connected := false;
  try
    MainConn.LoginPrompt := False;
    MainConn.DriverName := 'SQLite';
    MainConn.Params.Values['Database'] := AFileName;
    MainConn.Params.Values['Password'] := TRTOC_PWD;
    MainConn.Params.Values['LockingMode'] := 'Normal';
    MainConn.Connected := True;
    MainConn.ExecSQL(
        ' CREATE TABLE IF NOT EXISTS Titles ( '+
        '    Id                  INTEGER       PRIMARY KEY AUTOINCREMENT '+
        '                                      UNIQUE '+
        '                                      NOT NULL, '+
        '    Title               VARCHAR (255), '+
        '    ParentTitleId       INT           REFERENCES Titles (Id) ON DELETE CASCADE, '+
        '    SeqNo               INT '+
        ' )');
    MainConn.ExecSQL(
        ' CREATE TABLE IF NOT EXISTS Urls ( '+
        '    Id                  INTEGER       PRIMARY KEY AUTOINCREMENT '+
        '                                      UNIQUE '+
        '                                      NOT NULL, '+
        '    Caption             VARCHAR (255), '+
        '    URL                 VARCHAR (4000), '+
        '    ParentTitleId       INT           REFERENCES Titles (Id) ON DELETE CASCADE, '+
        '    SeqNo               INT '+
        ' )');
  Except on E: Exception do
    ShowMessage('Error occured at connecting to '+ AFileName + ':' + #13#13 + E.Message);
  end;
end;

procedure TdmData.ExecSQL(ASQL: string);
begin
  MainConn.ExecSQL(ASQL);
end;

function TdmData.Exists(ASQL: string): boolean;
var Q: TADQuery;
begin
  Q := TADQuery.Create(nil);
  try
    Q.Connection := MainConn;
    Q.SQL.Text := ASQL;
    Q.Open;
    Result := Q.RecordCount > 0;
  finally
    Q.Free;
  end;
end;

function TdmData.ExportToFile(AFileName: string): boolean;
var L: TStringList;
    QRoot: TADQuery;

    procedure AddLine(ACaption, AURL: string);
    begin
      L.Add('  |'+ ACaption + '  |' + AURL);
    end;

    procedure ProcessTitle(APrefix: string; AParentTitleId: integer);
    var QTitle, QURL: TADQuery;
    begin
      QTitle := TADQuery.Create(nil);
      QURL := TADQuery.Create(nil);
      try
        QTitle.Connection := MainConn;
        QTitle.SQL.Text :=
          ' SELECT * FROM Titles '+
          ' WHERE ParentTitleId = '+ IntToStr(AParentTitleId) +
          ' ORDER BY SeqNo ';
        QTitle.Open;
        while not QTitle.Eof do
        begin
          AddLine(APrefix + Trim(QTitle.FieldByName('Title').AsString), '');
          ProcessTitle(APrefix + ' ', QTitle.FieldByName('Id').AsInteger);
          QTitle.Next;
        end;

        QURL.Connection := MainConn;
        QURL.SQL.Text :=
          ' SELECT * FROM URLs '+
          ' WHERE ParentTitleId = '+ IntToStr(AParentTitleId) +
          ' ORDER BY SeqNo ';
        QURL.Open;
        while not QURL.Eof do
        begin
          AddLine(APrefix + Trim(QURL.FieldByName('Caption').AsString), Trim(QURL.FieldByName('URL').AsString));
          QURL.Next;
        end;
      finally
        QTitle.Free;
        QURL.Free
      end;
    end;

begin
  Result := false;
  L := TStringList.Create;
  QRoot := TADQuery.Create(nil);
  try
    QRoot.Connection := MainConn;
    QRoot.SQL.Text :=
      ' SELECT * FROM Titles '+
      ' WHERE ParentTitleId IS NULL '+
      ' ORDER BY SeqNo ';
    QRoot.Open;
    while not QRoot.Eof do
    begin
      AddLine(Trim(QRoot.FieldByName('Title').AsString), '');
      ProcessTitle(' ', QRoot.FieldByName('Id').AsInteger);
      QRoot.Next;
    end;
    try
      L.SaveToFile(AFileName);
      Result := true;
    except on E: Exception do
      ShowMessage('Error occured on saving to file: '+ sLineBreak + E.Message);
    end;
  finally
    L.Free;
    QRoot.Free;
  end;
end;

function TdmData.GetMaxTitleSeqNo(AParentTitleId: integer): integer;
var Q: TADQuery;
begin
  Q := TADQuery.Create(nil);
  try
    Q.Connection := MainConn;
    Q.SQL.Text :=
      ' SELECT MAX(SeqNo) AS "SeqNo::INTEGER" FROM Titles '+
      ' WHERE IFNULL(ParentTitleId, 0) = :ParentTitleId ';
    Q.ParamByName('ParentTitleId').Value := AParentTitleId;
    Q.Open;
    Result := Q.FieldByName('SeqNo').AsInteger;
  finally
    Q.Free;
  end;
end;

function TdmData.GetMaxURLSeqNo(AParentTitleId: integer): integer;
var Q: TADQuery;
begin
  Q := TADQuery.Create(nil);
  try
    Q.Connection := MainConn;
    Q.SQL.Text :=
      ' SELECT MAX(SeqNo) AS "SeqNo::INTEGER" FROM Urls '+
      ' WHERE IFNULL(ParentTitleId, 0) = :ParentTitleId ';
    Q.ParamByName('ParentTitleId').Value := AParentTitleId;
    Q.Open;
    Result := Q.FieldByName('SeqNo').AsInteger;
  finally
    Q.Free;
  end;

end;

function TdmData.GetOrAddTitle(AParentTitleId: integer; ATitle: string): integer;
var Q: TADQuery;
begin
  Q := TADQuery.Create(nil);
  try
    Q.Connection := MainConn;
    Q.SQL.Text :=
      ' SELECT * FROM Titles '+
      ' WHERE IFNULL(ParentTitleId, 0) = :ParentTitleId '+
      '   AND Title = :Title';
    Q.ParamByName('ParentTitleId').Value := AParentTitleId;
    Q.ParamByName('Title').Value := ATitle;
    Q.Open;
    if Q.RecordCount = 0 then
    begin
      Q.Append;
      Q.FieldByName('Title').Value := ATitle;
      if AParentTitleId <> 0 then
        Q.FieldByName('ParentTitleId').Value := AParentTitleId;
      Q.FieldByName('SeqNo').AsInteger := GetMaxTitleSeqNo(AParentTitleId) + 1;
      Q.Post;
    end;
    Result := Q.FieldByName('Id').AsInteger;
  finally
    Q.Free;
  end;
end;

function TdmData.GetOrAddURL(AParentTitleId: integer; ACaption, AURL: string): integer;
var Q: TADQuery;
begin
  Q := TADQuery.Create(nil);
  try
    Q.Connection := MainConn;
    Q.SQL.Text :=
      ' SELECT * FROM Urls '+
      ' WHERE IFNULL(ParentTitleId, 0) = :ParentTitleId '+
      '   AND Caption = :Caption';
    Q.ParamByName('ParentTitleId').Value := AParentTitleId;
    Q.ParamByName('Caption').Value := ACaption;
    Q.Open;
    if Q.RecordCount = 0 then
    begin
      Q.Append;
      Q.FieldByName('Caption').Value := ACaption;
      Q.FieldByName('URL').Value := AURL;
      if AParentTitleId <> 0 then
        Q.FieldByName('ParentTitleId').Value := AParentTitleId;
      Q.FieldByName('SeqNo').AsInteger := GetMaxURLSeqNo(AParentTitleId) + 1;
      Q.Post;
    end;
    Result := Q.FieldByName('Id').AsInteger;
  finally
    Q.Free;
  end;
end;

procedure TdmData.UpdateTitleSeqNo;
var Q: TADQuery;
    CurrTitleId, I: integer;
begin
  Q := TADQuery.Create(nil);
  try
    Q.Connection := MainConn;
    Q.SQL.Text :=
      ' SELECT * FROM Titles '+
      ' ORDER BY ParentTitleId, CASE WHEN SeqNo IS NULL THEN 1 ELSE 0 END, SeqNo, Id';
    Q.Open;
    if Q.RecordCount = 0 then Exit;
    I := 0;
    CurrTitleId := Q.FieldByName('ParentTitleId').AsInteger;
    while not Q.Eof do
    begin
      if CurrTitleId <> Q.FieldByName('ParentTitleId').AsInteger then
      begin
        CurrTitleId := Q.FieldByName('ParentTitleId').AsInteger;
        I := 0;
      end;
      inc(I);
      if Q.FieldByName('SeqNo').AsInteger <> I then
        ExecSQL(
          ' UPDATE Titles '+
          ' SET SeqNo = '+ IntToStr(I) +
          ' WHERE Id = '+ IntToStr(Q.FieldByName('Id').AsInteger));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TdmData.UpdateURLSeqNo;
var Q: TADQuery;
    CurrTitleId, I: integer;
begin
  Q := TADQuery.Create(nil);
  try
    Q.Connection := MainConn;
    Q.SQL.Text :=
      ' SELECT * FROM URLs '+
      ' ORDER BY ParentTitleId, CASE WHEN SeqNo IS NULL THEN 1 ELSE 0 END, SeqNo, Id';
    Q.Open;
    if Q.RecordCount = 0 then Exit;
    I := 0;
    CurrTitleId := Q.FieldByName('ParentTitleId').AsInteger;
    while not Q.Eof do
    begin
      if CurrTitleId <> Q.FieldByName('ParentTitleId').AsInteger then
      begin
        CurrTitleId := Q.FieldByName('ParentTitleId').AsInteger;
        I := 0;
      end;
      inc(I);
      if Q.FieldByName('SeqNo').AsInteger <> I then
        ExecSQL(
          ' UPDATE URLs '+
          ' SET SeqNo = '+ IntToStr(I) +
          ' WHERE Id = '+ IntToStr(Q.FieldByName('Id').AsInteger));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

end.
