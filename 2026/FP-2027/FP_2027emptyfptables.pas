unit FP_2027emptyfptables;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,Db,FP_2027Declare,FP_2027TrimStr;

type
  TEmptyFpTables = class(TForm)
    ListBox1: TListBox;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    EmptyAllBtn: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EmptyFpTables: TEmptyFpTables;
  TblName:String;
implementation

{$R *.DFM}


end.
