unit vtTransformNOA;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.OleCtrls, SHDocVw,
  Vcl.StdCtrls, MSHTML; // 20180625 Igor

type
  TfTransformNOA = class(TForm)
    WB: TWebBrowser;
    Panel: TPanel;
    procedure FormShow(Sender: TObject);
    procedure WBNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
  private
    FXMLFile: string;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure TransformNOA(AXMLFile: string);

implementation

{$R *.dfm}

procedure TransformNOA(AXMLFile: string);
var
  fShowMessageHTML: TfTransformNOA;
begin
  fShowMessageHTML := TfTransformNOA.Create(Application);
  try
    fShowMessageHTML.FXMLFile := AXMLFile;
    fShowMessageHTML.ShowModal;
  finally
    fShowMessageHTML.Free;
  end;
end;

procedure TfTransformNOA.FormShow(Sender: TObject);
begin
  WB.Navigate(FXMLFile);
end;

procedure TfTransformNOA.WBNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  TThread.CreateAnonymousThread(procedure
    begin
      Sleep(1000);
      TThread.Synchronize(nil, procedure
        var
          XMLDOMDocument: IHtmldocument2;
          i: integer;
          HTMLResult: string;
          cStr: string;
        begin
          try
            if not Assigned(WB.Document) then exit;
            HTMLResult := '';
            XMLDOMDocument := WB.Document as IHtmldocument2;

            for i := 1 to 2 do
            begin
              cStr := (XMLDOMDocument.all.item(i,i) as IHTMLElement).outerHTML;
              HTMLResult := HTMLResult + (XMLDOMDocument.all.item(i,i) as IHTMLElement).outerHTML ;
            end;

            with TStringStream.Create(HTMLResult, TEncoding.UTF8) do
            try
              SaveToFile(ChangeFileExt(FXMLFile, '.html'));
            finally
              free;
            end;
          except ON E: Exception DO
            begin
              ShowMessage(E.Message);
            end;
          end;
          Close;
        end);
    end).Start;
end;

end.
