unit vtChooseFileForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Types, System.IOUtils;

type
  TChooseFileForm = class(TForm)
    lblDir: TLabel;
    edDir: TEdit;
    lblFilesInDirectory: TLabel;
    lbFiles: TListBox;
    btnChoose: TButton;
    btnCancel: TButton;
    procedure btnChooseClick(Sender: TObject);
  private
    { Private declarations }
    FDir: String;
    procedure InitFiles;
    function GetSelectedFile: string;
    procedure SetSelectedFile(const Value: string);
    procedure SetDir(const Value: string);
  public
    { Public declarations }
    property Dir: string read FDir write SetDir;
    property SelectedFile: string read GetSelectedFile write SetSelectedFile;
  end;

function ChooseFile(ADir: string; var AFileName: String): boolean;

implementation

{$R *.dfm}

function ChooseFile(ADir: string; var AFileName: String): boolean;
var FChooseFileForm: TChooseFileForm;
begin
  FChooseFileForm := TChooseFileForm.Create(Screen.ActiveForm);
  try
    FChooseFileForm.Dir := ADir;
    FChooseFileForm.InitFiles;
    FChooseFileForm.SelectedFile := AFileName;
    Result := FChooseFileForm.ShowModal = mrOk;
    if Result then
      AFileName := FChooseFileForm.SelectedFile;
  finally
    FChooseFileForm.Free;
  end;
end;

{ TChooseFileForm }

procedure TChooseFileForm.btnChooseClick(Sender: TObject);
begin
  if SameText(SelectedFile, '') then
  begin
    ShowMessage('You need to select file from the list');
    Exit;
  end;
  ModalResult := mrOk;
end;

function TChooseFileForm.GetSelectedFile: string;
begin
  Result := '';
  if lbFiles.ItemIndex = -1 then Exit;
  Result := lbFiles.Items[lbFiles.ItemIndex];
end;

procedure TChooseFileForm.InitFiles;
var A: TStringDynArray;
    S: String;
begin
  A := TDirectory.GetFiles(Dir);
  lbFiles.Clear;
  for S in A do
    lbFiles.Items.Add(ExtractFileName(S));
end;

procedure TChooseFileForm.SetDir(const Value: string);
begin
  FDir := Value;
  edDir.Text := Dir;
end;

procedure TChooseFileForm.SetSelectedFile(const Value: string);
begin
  lbFiles.ItemIndex := lbFiles.Items.IndexOf(Value);
end;

end.
