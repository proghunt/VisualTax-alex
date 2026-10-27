unit FP_2027rtfform;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ComCtrls,Buttons,ExtCtrls,FP_2027Declare,ShellApi,FileCtrl,
  vtRichmemobox,

  rxRichEd; //20160819 Igor (Must be last)

type
  TRTFFormFP_2027 = class(TForm)
    Panel1: TPanel;
    ExitBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    FileNameLbl: TLabel;
    Label2: TLabel;
    FileListBox1: TFileListBox;
    SelectDirBtn1: TBitBtn;
    ExtensionBox: TComboBox;
    Label1: TLabel;
    FromDirBox: TEdit;
    Label3: TLabel;
    OpenBtn: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    SelectFileBtn: TBitBtn;
    ARichEdit: TvtRichMemo;
    //procedure SelectFileBtnClick(Sender: TObject);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure ShowFiles;
    procedure FormCreate(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure ExtensionBoxClick(Sender: TObject);
    procedure FromDirBoxExit(Sender: TObject);
    procedure FromDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure SelectFileBtnClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RTFForm: TRTFFormFP_2027;
  FileName:String;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TRTFFormFP_2027.SelectDirBtn1Click(Sender: TObject);
Var DirSelected: String; //20150818 igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   FromDirBox.Text := DirSelected;
 ShowFiles;
end;

procedure TRTFFormFP_2027.ShowFiles;
begin
 FileListBox1.Directory := FromDirBox.Text;
 FileListBox1.Mask := '*.'+ExtensionBox.text;
 FileListBox1.ItemIndex :=0;
end;


procedure TRTFFormFP_2027.FormCreate(Sender: TObject);
begin
 FromDirBox.Text:=AppDir;
 ExtensionBox.Text:='TXT';
 ShowFiles;
end;

procedure TRTFFormFP_2027.FileListBox1DblClick(Sender: TObject);
begin
 OpenBtnClick(Sender);
(*
 If Not DirectoryExists(FromDirBox.Text) then
 begin
  ShowMessage('From Directory '+FromDirBox.Text+' does not exist');
  exit;
 end;

 If FileListBox1.ItemIndex<0 then
 begin
  ShowMessage('You must select a file first');
  exit;
 end;
 *)
end;

procedure TRTFFormFP_2027.OpenBtnClick(Sender: TObject);
Var h:THandle;
begin
   If FileListBox1.ItemIndex <>-1 then
    FileName:=FromDirBox.Text+'\'+FileListBox1.Items[FileListBox1.ItemIndex];

   FileNameLbl.Caption:=FileName;

   If FileName>'' then
   begin
     If (UpperCase(ExtractFileExt(FileName))='.LTR')
     Or (UpperCase(ExtractFileExt(FileName))='.TXT')
     {Or (UpperCase(ExtractFileExt(FileName))='.RTF')}
      then
     begin
     FileNameLbl.Caption:=FileName;
     ARichEdit.Lines.LoadFromFile(FileName);
     end
   else
   begin
     h := ShellExecute(Self.Handle,'open',Pchar(''+FileName),Nil,Nil,Sw_ShowNormal);
     If h<=32 then begin ShowMessage('File open failed');end;
   end;
   end;

end;

procedure TRTFFormFP_2027.ExtensionBoxClick(Sender: TObject);
begin
 //Extension:=ExtensionBox.text;
 ShowFiles;
end;

procedure TRTFFormFP_2027.FromDirBoxExit(Sender: TObject);
begin
ShowFiles;
end;

procedure TRTFFormFP_2027.FromDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If Key=#13 then ShowFiles;
end;


procedure TRTFFormFP_2027.SelectFileBtnClick(Sender: TObject);
Var h:THandle;
begin
EXIT;
 With OpenDialog1 do
 begin
  InitialDir:=AppDir;
  Filter:='*.TXT;*.LTR;*.RTF;*.DOC';
  If Execute then
  Begin
   If FileName>'' then
   begin
     If (UpperCase(ExtractFileExt(FileName))='.LTR')
     Or (UpperCase(ExtractFileExt(FileName))='.TXT') then
     begin
     FileNameLbl.Caption:=FileName;
     ARichEdit.Lines.LoadFromFile(FileName);
     end
   else
   begin
     h := ShellExecute(Self.Handle,'open',Pchar(''+FileName),Nil,Nil,Sw_Show);
     If h<=32 then begin ShowMessage('File open failed');end;
     Close;
     Exit;
   end;
   end;
  end;
 end;
end;


procedure TRTFFormFP_2027.FileListBox1Click(Sender: TObject);
begin
 FileName:=FromDirBox.Text+'\'+FileListBox1.Items[FileListBox1.ItemIndex];
 FileNameLbl.Caption:=FileName;
end;

end.
