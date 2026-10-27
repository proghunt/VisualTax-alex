unit T1_2026T1W_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 01/11/2008 9:44:57 PM from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\PROGRA~1\2006T1W\T1W.exe (1)
// IID\LCID: {50C3C4A0-56A7-11D2-9762-00104B70F34A}\0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 stdole, (C:\WINDOWS\System32\stdole32.tlb)
//   (2) v1.0 StdVCL, (C:\WINDOWS\System32\STDVCL32.DLL)
// Errors:
//   Hint: Parameter 'Index' of ICANTAXT1Data.GetString changed to 'Index_'
//   Hint: Parameter 'Str' of ICANTAXT1Data.PutString changed to 'Str_'
//   Hint: Parameter 'Index' of ICANTAXT1Data.GetReal changed to 'Index_'
//   Hint: Parameter 'Value' of ICANTAXT1Data.PutReal changed to 'Value_'
//   Hint: Parameter 'Index' of ICANTAXT1Data.GetByte changed to 'Index_'
//   Hint: Parameter 'Value' of ICANTAXT1Data.PutByte changed to 'Value_'
//   Hint: Parameter 'Index' of ICANTAXT1Data.GetOver changed to 'Index_'
//   Hint: Parameter 'Value' of ICANTAXT1Data.PutOver changed to 'Value_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows,ActiveX,Classes,Graphics,OleServer,OleCtrls,StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  T1WMajorVersion = 1;
  T1WMinorVersion = 0;

  LIBID_T1W: TGUID = '{50C3C4A0-56A7-11D2-9762-00104B70F34A}';

  IID_ICANTAXT1App: TGUID = '{50C3C4A1-56A7-11D2-9762-00104B70F34A}';
  CLASS_CANTAXT1App: TGUID = '{50C3C4A2-56A7-11D2-9762-00104B70F34A}';
  IID_ICANTAXT1Data: TGUID = '{50C3C4A3-56A7-11D2-9762-00104B70F34A}';
  CLASS_CANTAXT1Data: TGUID = '{50C3C4A4-56A7-11D2-9762-00104B70F34A}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICANTAXT1App = interface;
  ICANTAXT1AppDisp = dispinterface;
  ICANTAXT1Data = interface;
  ICANTAXT1DataDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CANTAXT1App = ICANTAXT1App;
  CANTAXT1Data = ICANTAXT1Data;


// *********************************************************************//
// Interface: ICANTAXT1App
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {50C3C4A1-56A7-11D2-9762-00104B70F34A}
// *********************************************************************//
  ICANTAXT1App = interface(IDispatch)
    ['{50C3C4A1-56A7-11D2-9762-00104B70F34A}']
    procedure MinimizeApp; safecall;
    procedure RestoreApp; safecall;
    function  LoadTaxReturn(const FileName: WideString): OleVariant; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICANTAXT1AppDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {50C3C4A1-56A7-11D2-9762-00104B70F34A}
// *********************************************************************//
  ICANTAXT1AppDisp = dispinterface
    ['{50C3C4A1-56A7-11D2-9762-00104B70F34A}']
    procedure MinimizeApp; dispid 1;
    procedure RestoreApp; dispid 2;
    function  LoadTaxReturn(const FileName: WideString): OleVariant; dispid 3;
  end;

// *********************************************************************//
// Interface: ICANTAXT1Data
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {50C3C4A3-56A7-11D2-9762-00104B70F34A}
// *********************************************************************//
  ICANTAXT1Data = interface(IDispatch)
    ['{50C3C4A3-56A7-11D2-9762-00104B70F34A}']
    function  GetString(Group: Integer; Index: Integer): WideString; safecall;
    function  PutString(Group: Integer; Index: Integer; const Str: WideString): OleVariant; safecall;
    function  GetReal(Group: Integer; Index: Integer): Double; safecall;
    function  PutReal(Group: Integer; Index: Integer; Value: Double): OleVariant; safecall;
    function  GetByte(Group: Integer; Index: Integer): Byte; safecall;
    function  PutByte(Group: Integer; Index: Integer; Value: Byte): OleVariant; safecall;
    function  GetOver(Group: Integer; Index: Integer): WordBool; safecall;
    function  PutOver(Group: Integer; Index: Integer; Value: WordBool): OleVariant; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICANTAXT1DataDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {50C3C4A3-56A7-11D2-9762-00104B70F34A}
// *********************************************************************//
  ICANTAXT1DataDisp = dispinterface
    ['{50C3C4A3-56A7-11D2-9762-00104B70F34A}']
    function  GetString(Group: Integer; Index: Integer): WideString; dispid 1;
    function  PutString(Group: Integer; Index: Integer; const Str: WideString): OleVariant; dispid 2;
    function  GetReal(Group: Integer; Index: Integer): Double; dispid 3;
    function  PutReal(Group: Integer; Index: Integer; Value: Double): OleVariant; dispid 4;
    function  GetByte(Group: Integer; Index: Integer): Byte; dispid 5;
    function  PutByte(Group: Integer; Index: Integer; Value: Byte): OleVariant; dispid 6;
    function  GetOver(Group: Integer; Index: Integer): WordBool; dispid 7;
    function  PutOver(Group: Integer; Index: Integer; Value: WordBool): OleVariant; dispid 8;
  end;

// *********************************************************************//
// The Class CoCANTAXT1App provides a Create and CreateRemote method to          
// create instances of the default interface ICANTAXT1App exposed by              
// the CoClass CANTAXT1App. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCANTAXT1App = class
    class function Create: ICANTAXT1App;
    class function CreateRemote(const MachineName: string): ICANTAXT1App;
  end;

// *********************************************************************//
// The Class CoCANTAXT1Data provides a Create and CreateRemote method to          
// create instances of the default interface ICANTAXT1Data exposed by              
// the CoClass CANTAXT1Data. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCANTAXT1Data = class
    class function Create: ICANTAXT1Data;
    class function CreateRemote(const MachineName: string): ICANTAXT1Data;
  end;

implementation

uses ComObj;

class function CoCANTAXT1App.Create: ICANTAXT1App;
begin
  Result := CreateComObject(CLASS_CANTAXT1App) as ICANTAXT1App;
end;

class function CoCANTAXT1App.CreateRemote(const MachineName: string): ICANTAXT1App;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CANTAXT1App) as ICANTAXT1App;
end;

class function CoCANTAXT1Data.Create: ICANTAXT1Data;
begin
  Result := CreateComObject(CLASS_CANTAXT1Data) as ICANTAXT1Data;
end;

class function CoCANTAXT1Data.CreateRemote(const MachineName: string): ICANTAXT1Data;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CANTAXT1Data) as ICANTAXT1Data;
end;

end.
