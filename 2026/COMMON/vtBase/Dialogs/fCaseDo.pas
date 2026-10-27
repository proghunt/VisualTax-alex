unit fCaseDo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TCaseDoFunc = reference to function (const ACaseID: Integer): Boolean;

  TfrmCaseDo = class(TForm)
    lblText: TLabel;
  private
    { Private declarations }
    FPressedButtonID: Integer;
    FFunc: TCaseDoFunc;
    procedure ButtonClick(Sender: TObject);
    procedure Init(AText: String; AButtons: Array of String);
  public
    { Public declarations }
  end;

var CaseDoStayOnTop: boolean; //20200305 Igor

function CaseDo(AText: String; AButtons: Array of String; AFunc: TCaseDoFunc): Integer;

implementation

{$R *.dfm}

function CaseDo(AText: String; AButtons: Array of String; AFunc: TCaseDoFunc): Integer;
begin
  with TfrmCaseDo.Create(Application) do
  Begin
    try
      //20200305 Igor >>>
      if CaseDoStayOnTop then
        FormStyle := fsStayOnTop;
      //20200305 Igor <<<
      FFunc := AFunc;
      Init(AText, AButtons);
      ShowModal;
      if ModalResult = mrOk then
        Result := FPressedButtonID
      else
        Result := -1;
    finally
      Free;
    end;
  End;

end;

{ TfrmCaseDo }

procedure TfrmCaseDo.ButtonClick(Sender: TObject);
begin
  FPressedButtonID := (Sender as TButton).Tag;
  if Assigned(FFunc) then
    if FFunc(FPressedButtonID) then
      ModalResult := mrOk
    else
  else
    ModalResult := mrOk;
end;

procedure TfrmCaseDo.Init(AText: String; AButtons: array of String);
var
  B: TButton;
  I, T: Integer;
begin
  lblText.Caption := AText;
  lblText.Refresh;
  T := lblText.Top + lblText.Height + 4;
  for I := Low(AButtons) to High(AButtons) do
  begin
    B := TButton.Create(Self);
    B.Parent := Self;
    B.Caption := AButtons[I];
    B.Tag := I;
    B.OnClick := ButtonClick;
    B.Font.Size := 12;
    B.Anchors := [akLeft, akTop, akRight];
    B.WordWrap := True;
    B.SetBounds(4, T, Self.ClientWidth - 8, 50);
    Inc(T, 50 + 4);
  end;
  Self.ClientHeight := T;
end;

end.
