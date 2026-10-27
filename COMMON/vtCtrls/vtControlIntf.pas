unit vtControlIntf;

interface

//20170407 Igor >>>
uses
  VCL.Menus,
  VCL.Forms;//20170727 Igor
//20170407 Igor <<<

type
  IvtControl = interface(IUnknown)
  ['{DA606ED1-4845-40E3-A593-231CC8FDF362}']
    function GetvtIsPrintable: Boolean;
  end;
  //20170321 Igor >>>
  IvtConditionalControl = interface(IUnknown)
  ['{AF053E72-444D-403A-8F24-87E04BBD543A}']
    procedure InvalidateConditionalValues(ASender: TObject);
  end;
  //20170407 Igor >>>
  TAdditionalMenuItems = Array of TMenuItem;
  IvtPopupedControl = interface(IUnknown)
  ['{10B1603C-E155-454A-87F1-D515A8CA1C7B}']
    function AdditionalMenuItems: TAdditionalMenuItems;
  end;
  TEditButtonAction = (ebaInsertRow, ebaRowUp, ebaRowDown, ebaDeleteRow, ebaMove);//20170411 Igor
  //20170407 Igor <<<
  IvtForm = interface(IUnknown)
  ['{41B223FF-1C71-4FF6-9302-FD724F1E7A8F}']
    procedure ConditionCalc(AIdentificator: String; var AValue: Boolean); overload;
    procedure ConditionCalc(AIdentificator: String; var AValue: Integer); overload;
    procedure ConditionCalc(AIdentificator: String; var AValue: String); overload;
    procedure ConditionCalc(AIdentificator: String; var AValue: Real); overload;

    procedure EditButtonClick(AEdit: TObject; AAction: TEditButtonAction; AEdit2: TObject); //20170411 Igor
    //20170411 Igor >>>
    function SameTable(AField1, AField2: Integer): Boolean;
    function SameColumn(AField1, AField2: Integer): Boolean;
    function isLastRow(AFieldID: Integer): Boolean;
    //20170411 Igor <<<

  end;

  TScaledFunct = function(X: Longint): LongInt;
  //20170321 Igor <<<
//20170727 Igor>>>
  IvtAdoptableControl = interface
    ['{C7821EF8-B387-4993-A7AA-11C0A4107BFE}']
    procedure AdoptMe(AChild: TCustomForm; AAppIds: Array of string; ARetNos: Array of Integer);
    procedure UnAdoptMe(AChild: TCustomForm);
  end;
  //20170727 Igor<<<
//20170407 Igor >>>
CONST
  C_VtControlsMenuTag: NativeInt = -9898;
//20170407 Igor <<<

implementation



end.
