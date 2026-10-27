(*****************************************)
(*           Ek UDF List v 3.11          *)
(*   (C) Eugene Kuchugurov, 2000-2011    *)
(*****************************************)
unit ekfunc;

interface
uses
  SysUtils, Classes, conscom;

 //----------- Component -------------------------------

type

 TEkUDFList=class;

 TEkUDFArgs=array of TObject;
 TEkUDFResult=TObject;
 TEkUDFOnCalculate=procedure(Sender:TObject; Args:TEkUDFArgs; ArgCount:integer; UDFResult:TEkUDFResult) of object;
 TEkUDFName=string;

 TEkUDF=class(TCollectionItem)
 private
   FOnCalculate:TEkUDFOnCalculate;
   FName:TEkUDFName;
   FArgMinCount:word;
   FArgMaxCount:word;
   FResultType:TEkUDFResultType;
 protected
   function GetDisplayName: string; override;
   function CheckName(s:string):boolean;
   procedure SetName(Value:TEkUDFName);
   procedure SetArgMinCount(Value:word);
   procedure SetArgMaxCount(Value:word);
 public
   constructor Create(Collection:TCollection);override;
   destructor Destroy;override;
   procedure Assign(Source:TPersistent);override;
 published
   property OnCalculate:TEkUDFOnCalculate read FOnCalculate write FOnCalculate;
   property Name:TEkUDFName read FName write SetName;
   property ArgMinCount:word read FArgMinCount write SetArgMinCount;
   property ArgMaxCount:word read FArgMaxCount write SetArgMaxCount;
   property ResultType:TEkUDFResultType read FResultType write FResultType;
 end;

 TEkUDFCollection=class(TCollection)
 private
   FEkUDFList:TEkUDFList;
 protected
   function  GetOwner: TPersistent; override;
   function GetItem(Index:Integer):TEkUDF;
   procedure SetItem(Index:Integer; Value:TEkUDF);
   procedure Update(Item:TCollectionItem);override;
   property EkUDFList:TEkUDFList read FEkUDFList;
 public
   constructor Create(FnList:TEkUDFList);
   function Add:TEkUDF;
   property Items[Index:integer]:TEkUDF read GetItem write SetItem;default;
 end;


  //---------- Component List-----------------
  TEkUDFList = class(TComponent)
  private
    FFunctions:TEkUDFCollection;
    procedure SetFunctions(Value:TEkUDFCollection);
  protected
    function GetCount:integer;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    property Count:integer read GetCount;
    function FindFunction(Name:string):integer;
    function Version:longint;
  published
    property Functions:TEkUDFCollection read FFunctions write SetFunctions;
  end;


procedure Register;

implementation


//----------------------TEkUDF --------------------------
constructor TEkUDF.create(Collection: TCollection);
begin
 inherited create(Collection);
 FOnCalculate:=nil;
 FArgMinCount:=0;
 FArgMaxCount:=0;
 FResultType:=udfrTEkReportVariable;
end;

destructor TEkUDF.destroy;
begin
 //
 inherited Destroy;
end;

function TEkUDF.GetDisplayName: string;
begin
  Result:=Name;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TEkUDF.CheckName(s:string):boolean;
var f,ln:longint;
    ch:char;
begin
  Result:=true;
  ln:=length(s);
  for f:=1 to ln do begin
     ch:=s[f];
     if ((ch>='A') and (ch<='Z')) or
        ((ch>='a') and (ch<='z')) or (ch='_') or
        ((ch>='0') and (ch<='9') and (f>1))
        then continue else begin
                             Result:=false;
                             break;
                           end;

  end;//for
end;

procedure TEkUDF.SetName(Value: TEkUDFName);
begin
  If FName<>Value then begin
     Value:=Trim(Value);
     if TEkUDFCollection(Self.Collection).EkUDFList.FindFunction(Value)>-1
          then raise EIllegalFunctionUse.create('User defined function with name '+Value+' already exists');
     if (Value>'') and (not CheckName(Value)) then raise EIllegalFunctionUse.create('Illegal function name '+Value)
                                              else FName:=Value;
  end;
end;

procedure TEkUDF.SetArgMaxCount(Value: word);
begin
  if FArgMaxCount<>Value then begin
     FArgMaxCount:=Value;
     if FArgMinCount>FArgMaxCount then FArgMinCount:=FArgMaxCount;
  end;
end;

procedure TEkUDF.SetArgMinCount(Value: word);
begin
  if FArgMinCount<>Value then begin
     FArgMinCount:=Value;
     if FArgMaxCount<FArgMinCount then FArgMaxCount:=FArgMinCount;
  end;
end;

procedure TEkUDF.Assign(Source: TPersistent);
begin
  if Source is TEkUDF then
  begin
     FOnCalculate:=TEkUDF(Source).OnCalculate;
     FName:=TEkUDF(Source).Name;
     FArgMinCount:=TEkUDF(Source).ArgMinCount;
     FArgMaxCount:=TEkUDF(Source).ArgMaxCount;
     FResultType:=TEkUDF(Source).ResultType;
     Exit;
  end;
  inherited Assign(Source);
end;

//------------------ TEkUDFCollection (Collection) -------------------------
constructor TEkUDFCollection.create(FnList: TEkUDFList);
begin
  inherited create(TEkUDF);
  FEkUDFList:=FnList;
end;

function TEkUDFCollection.GetOwner: TPersistent;
begin
 Result:=FEkUDFList;
end;

function TEkUDFCollection.Add: TEkUDF;
begin
  Result:=TEkUDF(inherited Add);
end;

function TEkUDFCollection.GetItem(Index: Integer): TEkUDF;
begin
  Result:=TEkUDF(inherited GetItem(Index));
end;

procedure TEkUDFCollection.SetItem(Index: Integer; Value: TEkUDF);
begin
  inherited SetItem(Index,Value);
end;

procedure TEkUDFCollection.Update(Item: TCollectionItem);
begin
//
end;


//----------- TEkUDFList ---------------------------
constructor TEkUDFList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFunctions:=TEkUDFCollection.Create(Self);
end;

destructor TEkUDFList.Destroy;
begin
  FFunctions.Free;
  inherited Destroy;
end;

function TEkUDFList.GetCount: integer;
begin
 Result:=Functions.Count;
end;

function TEkUDFList.FindFunction(Name: string): integer;
var i:integer;
begin
  name:=Trim(UpperCase(name));
  Result:=-1;
  for i:=0 to Functions.Count-1 do begin
      if name=Trim(UpperCase(Functions[i].name)) then
         begin Result:=i; break; end;
  end;
end;

procedure TEkUDFList.SetFunctions(Value: TEkUDFCollection);
begin
 FFunctions.Assign(Value);
end;

function TEkUDFList.Version:longint;
begin
Result:=311;
end;

//-----------------------------------------------------
procedure Register;
begin
  RegisterComponents('Data Access', [TEkUDFList]);
end;

end.
