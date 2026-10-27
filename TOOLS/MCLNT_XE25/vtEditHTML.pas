Unit vtEditHTML;

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Printers, ClipBrd,
  SHDocVw, MSHTML, ActiveX, ActnList, OleCtrls, System.Actions;

type TSaveProc = function (AHTML: string): boolean of object;

type
  TvtEditHTML = class(TForm)
    pnlActions: TPanel;
    pnlButtons: TPanel;
    pnlContent: TPanel;
    WB: TWebBrowser;
    btnBold: TSpeedButton;
    btnItalic: TSpeedButton;
    SpeedButton3: TSpeedButton;
    btnSave: TButton;
    btnCancel: TButton;
    alActions: TActionList;
    actBold: TAction;
    actItalic: TAction;
    actAddLink: TAction;
    actUnderline: TAction;
    btnUnderline: TSpeedButton;
    cbFontSizes: TComboBox;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    actSetTextColor: TAction;
    SelectColorDialog: TColorDialog;
    Shape1: TShape;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure WBCommandStateChange(ASender: TObject; Command: Integer;
      Enable: WordBool);
    procedure actBoldExecute(Sender: TObject);
    procedure actItalicExecute(Sender: TObject);
    procedure actAddLinkExecute(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure actUnderlineExecute(Sender: TObject);
    procedure actSetTextColorExecute(Sender: TObject);
    procedure cbFontSizesChange(Sender: TObject);
  private
    { Private declarations }
    SaveProc: TSaveProc;
    HTML: string;
    Editor: IHTMLDocument2;
  public
    { Public declarations }
  end;

function RunEditHTML(AHTML: string; ASaveProc: TSaveProc): boolean;

implementation

{$R *.dfm}


function TColorToWeb(AColor: TColor): string; 
begin
  Result := '#' +
    IntToHex(GetRValue(AColor), 2) +
    IntToHex(GetGValue(AColor), 2) +
    IntToHex(GetBValue(AColor), 2);
end;

function RunEditHTML(AHTML: string; ASaveProc: TSaveProc): boolean;
var FEditHTML: TvtEditHTML;
begin
  if not Assigned(ASaveProc) then
  begin
    ShowMessage('Save procedure is not assigned!');
    Exit;
  end;
  FEditHTML := TvtEditHTML.Create(Screen.ActiveForm);
  try
    FEditHTML.HTML := AHTML;
    FEditHTML.SaveProc := ASaveProc;
    Result := FEditHTML.ShowModal = mrOk;
  finally
    FEditHTML.Free;
  end;
end;


procedure TvtEditHTML.actAddLinkExecute(Sender: TObject);
var
  Range: IHTMLTxtRange;
  Url: string;
begin
  Range := (Editor.Selection.CreateRange as IHTMLTxtRange);
  if String(Range.text) = '' then
    ShowMessage('Please, select text that should be transformed into url')
  else
  begin
    Url := '';
    if not InputQuery('Enter url', 'Url', Url) then Exit;
    Range.execCommand('CreateLink', false, Url);
  end;
end;

procedure TvtEditHTML.actBoldExecute(Sender: TObject);
var
  Range: IHTMLTxtRange;
begin
  Range := (Editor.Selection.CreateRange as IHTMLTxtRange);
  Range.execCommand('bold', false, 1);
end;

procedure TvtEditHTML.actItalicExecute(Sender: TObject);
var
  Range: IHTMLTxtRange;
begin
  Range := (Editor.Selection.CreateRange as IHTMLTxtRange);
  Range.execCommand('italic', false, 1);
end;

procedure TvtEditHTML.actSetTextColorExecute(Sender: TObject);
var
  Range: IHTMLTxtRange;
begin
  if not SelectColorDialog.Execute then Exit;
  Range := (Editor.Selection.CreateRange as IHTMLTxtRange);
  Range.execCommand('forecolor', false, TColorToWeb(SelectColorDialog.Color));
end;

procedure TvtEditHTML.actUnderlineExecute(Sender: TObject);
var
  Range: IHTMLTxtRange;
begin
  Range := (Editor.Selection.CreateRange as IHTMLTxtRange);
  Range.execCommand('underline', false, 1);
end;

procedure TvtEditHTML.btnSaveClick(Sender: TObject);
begin
  if not SaveProc(Editor.body.innerHTML) then Exit;
  ModalResult := mrOk;
end;

procedure TvtEditHTML.cbFontSizesChange(Sender: TObject);
var
  Range: IHTMLTxtRange;
begin
  Range := (Editor.Selection.CreateRange as IHTMLTxtRange);
  Range.execCommand('fontsize', false, cbFontSizes.ItemIndex + 1);
end;

procedure TvtEditHTML.FormShow(Sender: TObject);
var
  Doc: Variant;
begin
  if not Assigned(WB.Document) then
    WB.Navigate('about:blank');

  Doc := WB.Document;
  Doc.Clear;
  Doc.Write(HTML);
  Doc.Close;
  (WB.Document as IHTMLDocument2).designMode := 'on';
  Editor := (WB.Document as IHTMLDocument2);
end;

procedure TvtEditHTML.WBCommandStateChange(ASender: TObject; Command: Integer;
  Enable: WordBool);
var Sel: IHTMLSelectionObject;
    C: TControl;
    Range: IHTMLTxtRange;
    FSelectedSource: string;
begin
  if not Assigned(ASender) or not (ASender is TWebBrowser) then
    Exit;
  if TOleEnum(Command) <> CSC_UPDATECOMMANDS then
    Exit;
  if not Assigned(Editor) then
    Exit;
  Sel := Editor.Selection as IHTMLSelectionObject;
  C := FindVCLWindow(Mouse.CursorPos);
  if Assigned(Sel) and ((Sel.type_ = 'Text') or (C = ASender) or (C = TControl(ASender).Parent)) then
    ActiveControl := WB;
//  if Assigned(Sel) and (Sel.type_ = 'Text') then
//  begin
//    Range := (Editor.Selection.CreateRange as IHTMLTxtRange);
//    FSelectedSource := Range.HTMLText;
//    actBold.Checked := UpperCase(FSelectedSource).Contains('<STRONG>');
//    actItalic.Checked := UpperCase(FSelectedSource).Contains('<I>');
//  end;
end;

end.
