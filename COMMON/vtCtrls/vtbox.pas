unit vtbox;

interface

uses
  WinAPI.Windows, WinAPI.Messages, System.SysUtils, System.Classes, VCL.Graphics,
  VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.StdCtrls, VCL.ComCtrls, VCL.Buttons, VCL.ImgList, VCL.ToolWin,
  WinAPI.RichEdit;

type
  TvtBox = class(TForm)
    RTFControl: TRichEdit;
    Ok: TButton;
    Cancel: TButton;
    ToolBar1: TToolBar;
    Fontname: TComboBox;
    FontSize: TComboBox;
    BoldButton: TToolButton;
    ImageList1: TImageList;
    ItalicButton: TToolButton;
    UnderlineButton: TToolButton;
    LeftAlign: TToolButton;
    CenterAlign: TToolButton;
    RightAlign: TToolButton;
    BulletsButton: TToolButton;
    ToolButton1: TToolButton;
    ColorDialog1: TColorDialog;
    Superscript: TToolButton;
    Subscript: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    procedure BoldButtonClick(Sender: TObject);
    procedure RTFControlSelectionChange(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure UnderlineButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FontnameChange(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure LeftAlignClick(Sender: TObject);
    procedure BulletsButtonClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure SuperscriptClick(Sender: TObject);
    procedure SubscriptClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure RTFControlKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RTFControlKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    italic_flag : boolean;
    procedure GetFontNames;
    function GetOffset:integer;
    procedure SetOffset(offset:integer);
  public
    { Public declarations }
  end;

implementation

//{$IFDEF DELPHIXE2_LVL}
type
  TCharFormat = TCharFormatW;
//{$ENDIF}

{$R *.DFM}

procedure TvtBox.BoldButtonClick(Sender: TObject);
begin
 if BoldButton.Down then
  RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style + [fsBold]
 else
  RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style - [fsBold];
end;

procedure TvtBox.RTFControlSelectionChange(Sender: TObject);
begin
 BoldButton.Down := fsBold in RTFControl.SelAttributes.Style;
 ItalicButton.Down := fsItalic in RTFControl.SelAttributes.Style;
 UnderlineButton.Down := fsUnderline in RTFControl.SelAttributes.Style;
 BulletsButton.Down := Boolean(RTFControl.Paragraph.Numbering);
 FontSize.Text := IntToStr(RTFControl.SelAttributes.Size);
 FontName.Text := RTFControl.SelAttributes.Name;

 case Ord(RTFControl.Paragraph.Alignment) of
   0: LeftAlign.Down := True;
   1: RightAlign.Down := True;
   2: CenterAlign.Down := True;
 end;
 if GetOffset<0 then
   begin
    Superscript.Down:=false;
    SubScript.Down:=true;
   end;
 if GetOffset=0 then
   begin
    Superscript.Down:=false;
    SubScript.Down:=false;
   end;
 if GetOffset>0 then
   begin
    Superscript.Down:=true;
    SubScript.Down:=false;
   end;

end;

procedure TvtBox.ItalicButtonClick(Sender: TObject);
begin
 if ItalicButton.Down then
  RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style + [fsItalic]
 else
  RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style - [fsItalic];
end;

procedure TvtBox.UnderlineButtonClick(Sender: TObject);
begin
 if UnderlineButton.Down then
  RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style + [fsUnderline]
 else
  RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style - [fsUnderline];

end;

procedure TvtBox.FormCreate(Sender: TObject);
begin
 GetFontNames;
 RTFControl.SelStart:=0;
 RTFControl.SelLength:=0;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;
            
procedure TvtBox.GetFontNames;
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FontName.Items));
  ReleaseDC(0, DC);
  FontName.Sorted := True;
end;


procedure TvtBox.FontnameChange(Sender: TObject);
begin
 RTFControl.SelAttributes.Name := FontName.Items[FontName.ItemIndex];
end;

procedure TvtBox.FontSizeChange(Sender: TObject);
var
 i,c:integer;
begin
 val(FontSize.text,i,c);
 if (c<>0) then
   FontSize.Text := IntToStr(RTFControl.SelAttributes.Size)
 else
   RTFControl.SelAttributes.Size :=i;

end;

procedure TvtBox.LeftAlignClick(Sender: TObject);
begin
  RTFControl.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
end;

procedure TvtBox.BulletsButtonClick(Sender: TObject);
begin
 RTFControl.Paragraph.LeftIndent:=10;
 RTFControl.Paragraph.Numbering := TNumberingStyle(BulletsButton.Down);
end;

procedure TvtBox.ToolButton1Click(Sender: TObject);
begin
  ColorDialog1.Color:=RTFControl.SelAttributes.Color;
  if ColorDialog1.Execute then
    RTFControl.SelAttributes.Color:=ColorDialog1.Color;
end;

function TvtBox.GetOffset:integer;
var
  format: TCharFormat; { defined in Unit RichEdit }
begin
  format.cbSize:= Sizeof(format);
  format.dwMask:= CFM_OFFSET;
  Sendmessage(RTFControl.Handle,EM_GETCHARFORMAT, SCF_SELECTION,LParam(@format));
  Result := format.yoffset;
end;

procedure TvtBox.SetOffset(offset:integer);
var
  format: TCharFormat; { defined in Unit RichEdit }
begin
  FillChar(format, sizeof(format), 0);
  format.cbSize:= Sizeof(format);
  format.dwMask:= CFM_OFFSET;
  format.yOffset:= offset; { superscript by 40 twips, negative values give subscripts}
  Sendmessage(RTFControl.handle,EM_SETCHARFORMAT, SCF_SELECTION,LParam(@format));
end;


procedure TvtBox.SuperscriptClick(Sender: TObject);
begin
  if Superscript.Down then
    SetOffset(40)
  else
    SetOffset(0);

  SubScript.Down := false;
end;

procedure TvtBox.SubscriptClick(Sender: TObject);
begin
  if Subscript.Down then
    SetOffset(-40)
  else
    SetOffset(0);
  SuperScript.Down := false;
end;

procedure TvtBox.ToolButton2Click(Sender: TObject);
begin
 if RTFControl.Paragraph.FirstIndent>=10 then
 RTFControl.Paragraph.FirstIndent:=RTFControl.Paragraph.FirstIndent-10;
end;

procedure TvtBox.ToolButton3Click(Sender: TObject);
begin
 RTFControl.Paragraph.FirstIndent:=RTFControl.Paragraph.FirstIndent+10;
end;

procedure TvtBox.RTFControlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

begin
 if (ssAlt in Shift) or (ssCtrl in Shift) then
 case key of
 ord('B'):
   begin
   if fsBold in RTFControl.SelAttributes.Style then
    RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style - [fsBold]
   else
    RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style + [fsBold];
   RTFControlSelectionChange(self);
   end;
 ord('I'):
   begin
    italic_flag := True;
   if fsItalic in RTFControl.SelAttributes.Style then
    RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style - [fsItalic]
   else
    RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style + [fsItalic];
   RTFControlSelectionChange(self);
   end;
 ord('U'):
   begin
   if fsUnderline in RTFControl.SelAttributes.Style then
    RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style - [fsUnderline]
   else
    RTFControl.SelAttributes.Style := RTFControl.SelAttributes.Style + [fsUnderline];
   RTFControlSelectionChange(self);
   end;
 end;
end;

procedure TvtBox.RTFControlKeyPress(Sender: TObject; var Key: Char);
begin
 if italic_flag then
  begin
   italic_flag := False;
   key := #0;  // Neutralize Ctrl+I a.k.a. tab character
  end;
end;

end.
