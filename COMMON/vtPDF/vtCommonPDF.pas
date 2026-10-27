unit vtCommonPDF;

interface

uses System.Classes;

type
  TvtPDF = class(TObject)
  public
    function OpenFile(AFileName: string) : boolean; virtual; abstract;
    function SaveFile(AFileName: string) : boolean; virtual; abstract;
    function SelectedDocument : integer; virtual; abstract;
    function SelectDocument(ADocumentId: integer) : boolean; virtual; abstract;
    function CloseDocument(ADocumentId: integer) : boolean; virtual; abstract;
    procedure SetDPI(ADPI: integer); virtual; abstract;
    function PageCount: integer; virtual; abstract;
    function SelectedPage: integer; virtual; abstract;
    function SelectPage(APageNumber: integer): boolean; virtual; abstract;
    function AddImageFromFile(AImageFileName: string) : integer; virtual; abstract;
    function SelectImage(AImageId: integer): boolean; virtual; abstract;
    function DrawImage(ALeft, ATop, AWidth, AHeight: integer): boolean; virtual; abstract;
    function ClearImage(AImageId: integer): boolean; virtual; abstract;
    function RenderPageToStream(AMS: TMemoryStream) : boolean; virtual; abstract;
    //20210326 Igor >>>
    function DrawTextBox(ALeft, ATop, AWidth, AHeight: Double; const AText: WideString): Integer;  virtual; abstract;
    function ClearText(ATextStream: Integer): Boolean; virtual; abstract;
    //20210326 Igor <<<
  end;

type
  TCreateVtPDFFunction = function: TvtPDF;

implementation

end.
