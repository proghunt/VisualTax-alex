unit MSSOAPLib30_TLB;

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
// File generated on 12/18/2010 6:39:07 AM from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll (1)
// IID\LCID: {91147A58-DFE4-47C0-8E76-987FC1A6001B}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v4.0 MSXML2, (C:\Windows\system32\msxml4.dll)
//   (3) v4.0 StdVCL, (C:\Windows\system32\stdvcl40.dll)
// Errors:
//   Hint: Member 'Property' of 'IParserSource' changed to 'Property_'
//   Hint: Member 'Property' of 'IAttachment' changed to 'Property_'
//   Hint: Member 'Property' of 'IComposerDestination' changed to 'Property_'
//   Hint: Member 'type' of 'tagSTATSTG' changed to 'type_'
//   Hint: Member 'String' of 'IStringAttachment' changed to 'String_'
//   Hint: Member 'Array' of 'IByteArrayAttachment' changed to 'Array_'
//   Hint: Member 'type' of 'IWSDLOperation' changed to 'type_'
//   Hint: Member 'Property' of 'ISoapConnector' changed to 'Property_'
//   Error creating palette bitmap of (TFileAttachment30) : Invalid GUID format
//   Error creating palette bitmap of (TStringAttachment30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TByteArrayAttachment30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TStreamAttachment30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSentAttachments30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TReceivedAttachments30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TDataEncoderFactory30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TDimeComposer30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TDimeParser30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSimpleComposer30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSimpleParser30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSoapReader30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSoapSerializer30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSoapServer30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSoapClient30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TWSDLReader30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSoapTypeMapperFactory30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TGenericCustomTypeMapper30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TUDTMapper30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSoapConnector30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (TSoapConnectorFactory30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
//   Error creating palette bitmap of (THttpConnector30) : Server C:\Program Files\Common Files\MSSoap\Binaries\MSSOAP30.dll contains no icons
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL, 
  MSXML2_TLB;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  MSSOAPLib30MajorVersion = 3;
  MSSOAPLib30MinorVersion = 0;

  LIBID_MSSOAPLib30: TGUID = '{91147A58-DFE4-47C0-8E76-987FC1A6001B}';

  IID_ISoapReader: TGUID = '{B21F31CA-0F45-4046-A231-CFB386E9E45F}';
  IID_IMessageParser: TGUID = '{3B2A98E6-F76A-48B1-8F7D-0139A8D0258C}';
  IID_IParserSource: TGUID = '{282C694F-D69F-4044-B076-6F4AC1748A90}';
  IID_ISequentialStream: TGUID = '{0C733A30-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IReceivedAttachments: TGUID = '{176B81CD-4F22-4CA0-9F54-9FE5935A595B}';
  IID_IAttachment: TGUID = '{A2C40FB2-B768-4EC8-809A-6ECB4B89C6A7}';
  IID_IReceivedAttachment: TGUID = '{C0C9F1C0-0039-427B-8ACC-AD172FE557A8}';
  IID_ISoapMapper: TGUID = '{C1E6061A-F8DC-4CA8-A952-FAF7419F1029}';
  IID_ISoapSerializer: TGUID = '{23BDF2B5-2304-4550-BBE2-F197E2CC47B6}';
  IID_IMessageComposer: TGUID = '{906A72B9-FF88-4A49-AFA2-CC4CAB5104EC}';
  IID_IComposerDestination: TGUID = '{8E62C4B1-EE0C-48FB-9161-3EE041A03153}';
  IID_IDataEncoder: TGUID = '{663EB158-8D95-4657-AE32-B7C60DE6122F}';
  IID_IStream: TGUID = '{0000000C-0000-0000-C000-000000000046}';
  IID_IDataEncoderFactory: TGUID = '{456C5AB4-2A2A-4289-9D4C-0C28BF739EE4}';
  IID_IFileAttachment: TGUID = '{D6DEA9EB-28EA-45C7-A46A-72D26668C1EA}';
  CLASS_FileAttachment30: TGUID = '{90A299F3-26C6-457D-A514-404335109EDD}';
  IID_IStringAttachment: TGUID = '{8004A743-6A1E-45E4-B2E2-A6D117F06008}';
  CLASS_StringAttachment30: TGUID = '{722C5A81-4FEC-43F7-8656-E16EC6853073}';
  IID_IByteArrayAttachment: TGUID = '{52088645-8E96-4C18-8621-B46611635303}';
  CLASS_ByteArrayAttachment30: TGUID = '{565FBBE9-8563-4302-BE8A-7C6A64FB0A85}';
  IID_IStreamAttachment: TGUID = '{BE1DBCF5-2260-470A-8E1C-E2406D106E0A}';
  CLASS_StreamAttachment30: TGUID = '{05AE7FB3-C4E9-4F79-A5C3-DAB525E31F2C}';
  IID_ISentAttachments: TGUID = '{95A098C0-EB61-4895-91C7-78873251322E}';
  CLASS_SentAttachments30: TGUID = '{CE071800-E681-4ADF-9422-A3D0BD0D51CB}';
  CLASS_ReceivedAttachments30: TGUID = '{AF9B6377-6505-4934-AD85-BAB87E15EF65}';
  IID_IGetComposerDestination: TGUID = '{9E6CDFEF-4C42-411B-BACA-FE96F7A13C04}';
  IID_IDimeComposer: TGUID = '{ABAADE34-EEF6-408A-8896-65BE669D27FA}';
  IID_ISimpleComposer: TGUID = '{70824404-7A18-412A-9A83-A9EC0F3FF045}';
  IID_IGetParserSource: TGUID = '{BB63287E-1407-40E3-89AB-38CB2746547F}';
  IID_IDimeParser: TGUID = '{E3F8BAA5-8A05-4641-91CE-3FBC533D1EDB}';
  IID_ISimpleParser: TGUID = '{B313A227-0798-4A87-9074-48CA2164D0F7}';
  CLASS_DataEncoderFactory30: TGUID = '{7A51A663-4790-4885-B0E4-124D4BDADB3E}';
  CLASS_DimeComposer30: TGUID = '{B85E6E71-1493-442F-BC97-B511BE0D5D96}';
  CLASS_DimeParser30: TGUID = '{DFC2FA0B-CC72-4486-B9F4-06FE8A75D58F}';
  CLASS_SimpleComposer30: TGUID = '{F7E00C3F-D6C7-4E53-9887-61A2D4EBF0E8}';
  CLASS_SimpleParser30: TGUID = '{4D602A27-DC39-45D6-A6B1-7003DE2E173C}';
  CLASS_SoapReader30: TGUID = '{A8D986B6-9257-11D5-87EA-00B0D0BE6479}';
  CLASS_SoapSerializer30: TGUID = '{B76585B0-9257-11D5-87EA-00B0D0BE6479}';
  IID_ISoapClient: TGUID = '{7F017F92-9257-11D5-87EA-00B0D0BE6479}';
  IID_ISoapServer: TGUID = '{7F017F93-9257-11D5-87EA-00B0D0BE6479}';
  CLASS_SoapServer30: TGUID = '{7F017F96-9257-11D5-87EA-00B0D0BE6479}';
  CLASS_SoapClient30: TGUID = '{7F017F97-9257-11D5-87EA-00B0D0BE6479}';
  IID_ISoapTypeMapperFactory: TGUID = '{FCED9F15-D0A7-4380-87E6-992381ACD213}';
  IID_ISoapTypeMapper: TGUID = '{29D3F736-1C25-44EE-9CEE-3F52F226BA8A}';
  IID_IHeaderHandler: TGUID = '{504D4B91-76B8-4D88-95EA-CEB5E0FE41F3}';
  IID_IEnumSoapMappers: TGUID = '{ACDDCED6-6DB8-497A-BF10-068711629924}';
  IID_IWSDLMessage: TGUID = '{49F9421C-DC88-43E1-825F-70E788E9A9A9}';
  IID_IWSDLOperation: TGUID = '{A0B762A7-9F3E-48D8-B333-770E5FA72A1E}';
  IID_IEnumWSDLOperations: TGUID = '{B0BBA669-55F7-4E9C-941E-49BC4715C834}';
  IID_IWSDLPort: TGUID = '{4D40B730-F5FA-472C-8819-DDCD183BD0DE}';
  IID_IEnumWSDLPorts: TGUID = '{EC189C1C-31B3-4193-BDCA-98EC44FF3EE0}';
  IID_IWSDLService: TGUID = '{9B5D8D63-EA54-41F6-9F12-F77A13111EC6}';
  IID_IEnumWSDLService: TGUID = '{104F6816-093E-41D7-A68B-8E1CC408B279}';
  IID_IWSDLReader: TGUID = '{DE523FD4-AFB8-4643-BA90-9DEB3C7FB4A3}';
  IID_IWSDLBinding: TGUID = '{AB0E0268-304D-43FC-8603-B1105F3A7512}';
  CLASS_WSDLReader30: TGUID = '{EF90A70C-925B-11D5-87EA-00B0D0BE6479}';
  CLASS_SoapTypeMapperFactory30: TGUID = '{EF90A715-925B-11D5-87EA-00B0D0BE6479}';
  CLASS_GenericCustomTypeMapper30: TGUID = '{EF90A716-925B-11D5-87EA-00B0D0BE6479}';
  CLASS_UDTMapper30: TGUID = '{8BCD9554-86C7-435D-A8C8-BCB3C72FBEE9}';
  IID_ISoapConnector: TGUID = '{0AF40C4E-9257-11D5-87EA-00B0D0BE6479}';
  IID_ISoapConnectorFactory: TGUID = '{0AF40C50-9257-11D5-87EA-00B0D0BE6479}';
  CLASS_SoapConnector30: TGUID = '{0AF40C52-9257-11D5-87EA-00B0D0BE6479}';
  CLASS_SoapConnectorFactory30: TGUID = '{0AF40C58-9257-11D5-87EA-00B0D0BE6479}';
  CLASS_HttpConnector30: TGUID = '{0AF40C53-9257-11D5-87EA-00B0D0BE6479}';
  IID_ISoapError: TGUID = '{7F017F94-9257-11D5-87EA-00B0D0BE6479}';
  IID_IErrorInfo: TGUID = '{1CF2B120-547D-101B-8E65-08002B2BD119}';
  IID_ISoapErrorInfo: TGUID = '{C0871607-8C99-4824-92CD-85CBD4C7273F}';
  IID_IGCTMObjectFactory: TGUID = '{3C87B8BE-F2B7-45C5-B34E-4A46A58A80B0}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum __MIDL___MIDL_itf_mssoap30_0135_0001
type
  __MIDL___MIDL_itf_mssoap30_0135_0001 = TOleEnum;
const
  smInput = $FFFFFFFF;
  smOutput = $00000000;
  smInOut = $00000001;

// Constants for enum __MIDL___MIDL_itf_mssoap30_0135_0003
type
  __MIDL___MIDL_itf_mssoap30_0135_0003 = TOleEnum;
const
  enXSDUndefined = $FFFFFFFF;
  enXSDDOM = $00000000;
  enXSDstring = $00000001;
  enXSDboolean = $00000002;
  enXSDfloat = $00000003;
  enXSDDouble = $00000004;
  enXSDdecimal = $00000005;
  enXSDtimeDuration = $00000006;
  enXSDduration = $00000006;
  enXSDrecurringDuration = $00000007;
  enXSDbinary = $00000008;
  enXSDbase64binary = $00000008;
  enXSDuriReference = $00000009;
  enXSDanyURI = $00000009;
  enXSDid = $0000000A;
  enXSDidRef = $0000000B;
  enXSDentity = $0000000C;
  enXSDQName = $0000000D;
  enXSDcdata = $0000000E;
  enXSDnormalizedString = $0000000E;
  enXSDtoken = $0000000F;
  enXSDlanguage = $00000010;
  enXSDidRefs = $00000011;
  enXSDentities = $00000012;
  enXSDnmtoken = $00000013;
  enXSDnmtokens = $00000014;
  enXSDname = $00000015;
  enXSDncname = $00000016;
  enXSDnotation = $00000017;
  enXSDinteger = $00000018;
  enXSDnonpositiveInteger = $00000019;
  enXSDlong = $0000001A;
  enXSDint = $0000001B;
  enXSDshort = $0000001C;
  enXSDbyte = $0000001D;
  enXSDnonNegativeInteger = $0000001E;
  enXSDnegativeInteger = $0000001F;
  enXSDunsignedLong = $00000020;
  enXSDunsignedInt = $00000021;
  enXSDunsignedShort = $00000022;
  enXSDunsignedByte = $00000023;
  enXSDpositiveInteger = $00000024;
  enXSDtimeInstant = $00000025;
  enXSDdatetime = $00000025;
  enXSDtime = $00000026;
  enXSDtimePeriod = $00000027;
  enXSDdate = $00000028;
  enXSDmonth = $00000029;
  enXSDgMonth = $00000029;
  enXSDgYearMonth = $00000029;
  enXSDyear = $0000002A;
  enXSDgYear = $0000002A;
  enXSDcentury = $0000002B;
  enXSDrecurringDate = $0000002C;
  enXSDgMonthDay = $0000002C;
  enXSDrecurringDay = $0000002D;
  enXSDgDay = $0000002D;
  enXSDarray = $0000002E;
  enXSDanyType = $0000002F;
  enTKempty = $00000030;
  enXSDhexbinary = $00000031;
  enXSDEndOfBuildin = $00000032;

// Constants for enum __MIDL___MIDL_itf_mssoap30_0135_0002
type
  __MIDL___MIDL_itf_mssoap30_0135_0002 = TOleEnum;
const
  stNone = $00000000;
  stAttachment = $00000001;
  stSentAttachments = $00000002;
  stReceivedAttachments = $00000003;

// Constants for enum __MIDL___MIDL_itf_mssoap30_0000_0001
type
  __MIDL___MIDL_itf_mssoap30_0000_0001 = TOleEnum;
const
  cdMayRequireResend = $00000001;
  cdRequiresTotalSize = $00000002;

// Constants for enum __MIDL___MIDL_itf_mssoap30_0132_0001
type
  __MIDL___MIDL_itf_mssoap30_0132_0001 = TOleEnum;
const
  elDefaultLocation = $00000000;
  elEndOfEnvelope = $00000001;
  elEndOfBody = $00000002;
  elEndOfHeader = $00000003;

// Constants for enum __MIDL___MIDL_itf_mssoap30_0135_0004
type
  __MIDL___MIDL_itf_mssoap30_0135_0004 = TOleEnum;
const
  enDocumentLiteral = $00000000;
  enDocumentEncoded = $00000001;
  enRPCLiteral = $00000002;
  enRPCEncoded = $00000004;

// Constants for enum __MIDL___MIDL_itf_mssoap30_0135_0005
type
  __MIDL___MIDL_itf_mssoap30_0135_0005 = TOleEnum;
const
  enOneWay = $00000000;
  enRequestResponse = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISoapReader = interface;
  ISoapReaderDisp = dispinterface;
  IMessageParser = interface;
  IParserSource = interface;
  ISequentialStream = interface;
  IReceivedAttachments = interface;
  IReceivedAttachmentsDisp = dispinterface;
  IAttachment = interface;
  IAttachmentDisp = dispinterface;
  IReceivedAttachment = interface;
  IReceivedAttachmentDisp = dispinterface;
  ISoapMapper = interface;
  ISoapSerializer = interface;
  ISoapSerializerDisp = dispinterface;
  IMessageComposer = interface;
  IComposerDestination = interface;
  IDataEncoder = interface;
  IDataEncoderDisp = dispinterface;
  IStream = interface;
  IDataEncoderFactory = interface;
  IDataEncoderFactoryDisp = dispinterface;
  IFileAttachment = interface;
  IFileAttachmentDisp = dispinterface;
  IStringAttachment = interface;
  IStringAttachmentDisp = dispinterface;
  IByteArrayAttachment = interface;
  IByteArrayAttachmentDisp = dispinterface;
  IStreamAttachment = interface;
  IStreamAttachmentDisp = dispinterface;
  ISentAttachments = interface;
  ISentAttachmentsDisp = dispinterface;
  IGetComposerDestination = interface;
  IDimeComposer = interface;
  IDimeComposerDisp = dispinterface;
  ISimpleComposer = interface;
  ISimpleComposerDisp = dispinterface;
  IGetParserSource = interface;
  IDimeParser = interface;
  IDimeParserDisp = dispinterface;
  ISimpleParser = interface;
  ISimpleParserDisp = dispinterface;
  ISoapClient = interface;
  ISoapClientDisp = dispinterface;
  ISoapServer = interface;
  ISoapServerDisp = dispinterface;
  ISoapTypeMapperFactory = interface;
  ISoapTypeMapperFactoryDisp = dispinterface;
  ISoapTypeMapper = interface;
  ISoapTypeMapperDisp = dispinterface;
  IHeaderHandler = interface;
  IHeaderHandlerDisp = dispinterface;
  IEnumSoapMappers = interface;
  IWSDLMessage = interface;
  IWSDLOperation = interface;
  IEnumWSDLOperations = interface;
  IWSDLPort = interface;
  IEnumWSDLPorts = interface;
  IWSDLService = interface;
  IEnumWSDLService = interface;
  IWSDLReader = interface;
  IWSDLBinding = interface;
  ISoapConnector = interface;
  ISoapConnectorDisp = dispinterface;
  ISoapConnectorFactory = interface;
  ISoapConnectorFactoryDisp = dispinterface;
  ISoapError = interface;
  IErrorInfo = interface;
  ISoapErrorInfo = interface;
  IGCTMObjectFactory = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FileAttachment30 = IFileAttachment;
  StringAttachment30 = IStringAttachment;
  ByteArrayAttachment30 = IByteArrayAttachment;
  StreamAttachment30 = IStreamAttachment;
  SentAttachments30 = ISentAttachments;
  ReceivedAttachments30 = IReceivedAttachments;
  DataEncoderFactory30 = IDataEncoderFactory;
  DimeComposer30 = IDimeComposer;
  DimeParser30 = IDimeParser;
  SimpleComposer30 = ISimpleComposer;
  SimpleParser30 = ISimpleParser;
  SoapReader30 = ISoapReader;
  SoapSerializer30 = ISoapSerializer;
  SoapServer30 = ISoapServer;
  SoapClient30 = ISoapClient;
  WSDLReader30 = IWSDLReader;
  SoapTypeMapperFactory30 = ISoapTypeMapperFactory;
  GenericCustomTypeMapper30 = IDispatch;
  UDTMapper30 = IDispatch;
  SoapConnector30 = ISoapConnector;
  SoapConnectorFactory30 = ISoapConnectorFactory;
  HttpConnector30 = ISoapConnector;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PByte1 = ^Byte; {*}
  POleVariant1 = ^OleVariant; {*}
  PWord1 = ^Word; {*}
  PInteger1 = ^Integer; {*}
  PWideString1 = ^WideString; {*}
  PPUserType1 = ^IXMLDOMNode; {*}
  PPUserType2 = ^IMessageComposer; {*}
  PPUserType3 = ^IMessageParser; {*}
  PUINT1 = ^LongWord; {*}
  PHResult1 = ^HResult; {*}

  smIsInputEnum = __MIDL___MIDL_itf_mssoap30_0135_0001; 
  enXSDType = __MIDL___MIDL_itf_mssoap30_0135_0003; 
  enSpecialType = __MIDL___MIDL_itf_mssoap30_0135_0002; 
  ComposerDestinationFlags = __MIDL___MIDL_itf_mssoap30_0000_0001; 
  enElementLocation = __MIDL___MIDL_itf_mssoap30_0132_0001; 
  enEncodingStyle = __MIDL___MIDL_itf_mssoap30_0135_0004; 

  _LARGE_INTEGER = packed record
    QuadPart: Int64;
  end;

  _ULARGE_INTEGER = packed record
    QuadPart: Largeuint;
  end;

  _FILETIME = packed record
    dwLowDateTime: LongWord;
    dwHighDateTime: LongWord;
  end;

  tagSTATSTG = packed record
    pwcsName: PWideChar;
    type_: LongWord;
    cbSize: _ULARGE_INTEGER;
    mtime: _FILETIME;
    ctime: _FILETIME;
    atime: _FILETIME;
    grfMode: LongWord;
    grfLocksSupported: LongWord;
    clsid: TGUID;
    grfStateBits: LongWord;
    reserved: LongWord;
  end;

  enOperationType = __MIDL___MIDL_itf_mssoap30_0135_0005; 

// *********************************************************************//
// Interface: ISoapReader
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B21F31CA-0F45-4046-A231-CFB386E9E45F}
// *********************************************************************//
  ISoapReader = interface(IDispatch)
    ['{B21F31CA-0F45-4046-A231-CFB386E9E45F}']
    function  Load(par_source: OleVariant; const par_soapAction: WideString): WordBool; safecall;
    function  LoadWithParser(par_source: OleVariant; const par_parser: IMessageParser; 
                             const par_soapAction: WideString): WordBool; safecall;
    function  LoadXml(const par_xml: WideString): WordBool; safecall;
    function  Get_Dom: IXMLDOMDocument; safecall;
    function  Get_Envelope: IXMLDOMElement; safecall;
    function  Get_Body: IXMLDOMElement; safecall;
    function  Get_Header: IXMLDOMElement; safecall;
    function  Get_Fault: IXMLDOMElement; safecall;
    function  Get_FaultString: IXMLDOMElement; safecall;
    function  Get_FaultCode: IXMLDOMElement; safecall;
    function  Get_FaultActor: IXMLDOMElement; safecall;
    function  Get_FaultDetail: IXMLDOMElement; safecall;
    function  Get_HeaderEntry(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement; safecall;
    function  Get_MustUnderstandHeaderEntries: IXMLDOMNodeList; safecall;
    function  Get_HeaderEntries: IXMLDOMNodeList; safecall;
    function  Get_BodyEntries: IXMLDOMNodeList; safecall;
    function  Get_BodyEntry(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement; safecall;
    function  Get_RpcStruct: IXMLDOMElement; safecall;
    function  Get_RpcParameter(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement; safecall;
    function  Get_RpcResult: IXMLDOMElement; safecall;
    function  Get_SoapAction: WideString; safecall;
    function  GetContextItem(const par_key: WideString): OleVariant; safecall;
    procedure SetContextItem(const par_key: WideString; par_value: OleVariant); safecall;
    function  Get_Attachments: IReceivedAttachments; safecall;
    function  GetReferencedNode(const par_context: IXMLDOMNode): IXMLDOMNode; safecall;
    function  GetReferencedAttachment(const par_context: IXMLDOMNode): IReceivedAttachment; safecall;
    function  IsAttachmentReference(const par_context: IXMLDOMNode): WordBool; safecall;
    function  IsNodeReference(const par_context: IXMLDOMNode): WordBool; safecall;
    function  Get_Parser: IMessageParser; safecall;
    procedure Set_XmlVersion(const Param1: WideString); safecall;
    property Dom: IXMLDOMDocument read Get_Dom;
    property Envelope: IXMLDOMElement read Get_Envelope;
    property Body: IXMLDOMElement read Get_Body;
    property Header: IXMLDOMElement read Get_Header;
    property Fault: IXMLDOMElement read Get_Fault;
    property FaultString: IXMLDOMElement read Get_FaultString;
    property FaultCode: IXMLDOMElement read Get_FaultCode;
    property FaultActor: IXMLDOMElement read Get_FaultActor;
    property FaultDetail: IXMLDOMElement read Get_FaultDetail;
    property HeaderEntry[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement read Get_HeaderEntry;
    property MustUnderstandHeaderEntries: IXMLDOMNodeList read Get_MustUnderstandHeaderEntries;
    property HeaderEntries: IXMLDOMNodeList read Get_HeaderEntries;
    property BodyEntries: IXMLDOMNodeList read Get_BodyEntries;
    property BodyEntry[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement read Get_BodyEntry;
    property RpcStruct: IXMLDOMElement read Get_RpcStruct;
    property RpcParameter[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement read Get_RpcParameter;
    property RpcResult: IXMLDOMElement read Get_RpcResult;
    property SoapAction: WideString read Get_SoapAction;
    property Attachments: IReceivedAttachments read Get_Attachments;
    property Parser: IMessageParser read Get_Parser;
    property XmlVersion: WideString write Set_XmlVersion;
  end;

// *********************************************************************//
// DispIntf:  ISoapReaderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B21F31CA-0F45-4046-A231-CFB386E9E45F}
// *********************************************************************//
  ISoapReaderDisp = dispinterface
    ['{B21F31CA-0F45-4046-A231-CFB386E9E45F}']
    function  Load(par_source: OleVariant; const par_soapAction: WideString): WordBool; dispid 1;
    function  LoadWithParser(par_source: OleVariant; const par_parser: IMessageParser; 
                             const par_soapAction: WideString): WordBool; dispid 2;
    function  LoadXml(const par_xml: WideString): WordBool; dispid 3;
    property Dom: IXMLDOMDocument readonly dispid 1610743811;
    property Envelope: IXMLDOMElement readonly dispid 1610743812;
    property Body: IXMLDOMElement readonly dispid 1610743813;
    property Header: IXMLDOMElement readonly dispid 1610743814;
    property Fault: IXMLDOMElement readonly dispid 1610743815;
    property FaultString: IXMLDOMElement readonly dispid 1610743816;
    property FaultCode: IXMLDOMElement readonly dispid 1610743817;
    property FaultActor: IXMLDOMElement readonly dispid 1610743818;
    property FaultDetail: IXMLDOMElement readonly dispid 1610743819;
    property HeaderEntry[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement readonly dispid 1610743820;
    property MustUnderstandHeaderEntries: IXMLDOMNodeList readonly dispid 1610743821;
    property HeaderEntries: IXMLDOMNodeList readonly dispid 1610743822;
    property BodyEntries: IXMLDOMNodeList readonly dispid 1610743823;
    property BodyEntry[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement readonly dispid 1610743824;
    property RpcStruct: IXMLDOMElement readonly dispid 1610743825;
    property RpcParameter[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement readonly dispid 1610743826;
    property RpcResult: IXMLDOMElement readonly dispid 1610743827;
    property SoapAction: WideString readonly dispid 1610743828;
    function  GetContextItem(const par_key: WideString): OleVariant; dispid 1610743829;
    procedure SetContextItem(const par_key: WideString; par_value: OleVariant); dispid 1610743830;
    property Attachments: IReceivedAttachments readonly dispid 1610743831;
    function  GetReferencedNode(const par_context: IXMLDOMNode): IXMLDOMNode; dispid 1610743832;
    function  GetReferencedAttachment(const par_context: IXMLDOMNode): IReceivedAttachment; dispid 1610743833;
    function  IsAttachmentReference(const par_context: IXMLDOMNode): WordBool; dispid 1610743834;
    function  IsNodeReference(const par_context: IXMLDOMNode): WordBool; dispid 1610743835;
    property Parser: IMessageParser readonly dispid 1610743836;
    property XmlVersion: WideString writeonly dispid 1610743837;
  end;

// *********************************************************************//
// Interface: IMessageParser
// Flags:     (256) OleAutomation
// GUID:      {3B2A98E6-F76A-48B1-8F7D-0139A8D0258C}
// *********************************************************************//
  IMessageParser = interface(IUnknown)
    ['{3B2A98E6-F76A-48B1-8F7D-0139A8D0258C}']
    function  Initialize(const par_binding: IXMLDOMNode; const par_composer: IXMLDOMNode; 
                         const par_tempFolder: WideString; par_maxSize: Integer): HResult; stdcall;
    function  LoadMessage(const par_source: IParserSource; const par_envelope: ISequentialStream; 
                          out par_att: IReceivedAttachments): HResult; stdcall;
    function  LoadSpecialTypeMapper(const par_soapmapper: ISoapMapper; 
                                    const par_soapreader: ISoapReader; 
                                    const par_context: IXMLDOMNode): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IParserSource
// Flags:     (272) Hidden OleAutomation
// GUID:      {282C694F-D69F-4044-B076-6F4AC1748A90}
// *********************************************************************//
  IParserSource = interface(IUnknown)
    ['{282C694F-D69F-4044-B076-6F4AC1748A90}']
    function  Get_Property_(const par_name: WideString; out par_value: OleVariant): HResult; stdcall;
    function  Set_Property_(const par_name: WideString; par_value: OleVariant): HResult; stdcall;
    function  BeginReceiving(out par_stream: ISequentialStream): HResult; stdcall;
    function  EndReceiving: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ISequentialStream
// Flags:     (0)
// GUID:      {0C733A30-2A1C-11CE-ADE5-00AA0044773D}
// *********************************************************************//
  ISequentialStream = interface(IUnknown)
    ['{0C733A30-2A1C-11CE-ADE5-00AA0044773D}']
    function  RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult; stdcall;
    function  RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IReceivedAttachments
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {176B81CD-4F22-4CA0-9F54-9FE5935A595B}
// *********************************************************************//
  IReceivedAttachments = interface(IDispatch)
    ['{176B81CD-4F22-4CA0-9F54-9FE5935A595B}']
    function  Get_Count: Integer; safecall;
    function  Get_Item(par_index: OleVariant): IReceivedAttachment; safecall;
    function  Get_ItemWithContext(par_index: OleVariant; const par_context: IXMLDOMNode): IReceivedAttachment; safecall;
    function  Get__NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property Item[par_index: OleVariant]: IReceivedAttachment read Get_Item; default;
    property ItemWithContext[par_index: OleVariant; const par_context: IXMLDOMNode]: IReceivedAttachment read Get_ItemWithContext;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IReceivedAttachmentsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {176B81CD-4F22-4CA0-9F54-9FE5935A595B}
// *********************************************************************//
  IReceivedAttachmentsDisp = dispinterface
    ['{176B81CD-4F22-4CA0-9F54-9FE5935A595B}']
    property Count: Integer readonly dispid 1610743808;
    property Item[par_index: OleVariant]: IReceivedAttachment readonly dispid 0; default;
    property ItemWithContext[par_index: OleVariant; const par_context: IXMLDOMNode]: IReceivedAttachment readonly dispid 1610743810;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: IAttachment
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2C40FB2-B768-4EC8-809A-6ECB4B89C6A7}
// *********************************************************************//
  IAttachment = interface(IDispatch)
    ['{A2C40FB2-B768-4EC8-809A-6ECB4B89C6A7}']
    function  Get_Property_(const par_name: WideString): OleVariant; safecall;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant); safecall;
    property Property_[const par_name: WideString]: OleVariant read Get_Property_;
  end;

// *********************************************************************//
// DispIntf:  IAttachmentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2C40FB2-B768-4EC8-809A-6ECB4B89C6A7}
// *********************************************************************//
  IAttachmentDisp = dispinterface
    ['{A2C40FB2-B768-4EC8-809A-6ECB4B89C6A7}']
    property Property_[const par_name: WideString]: OleVariant readonly dispid 1610743808;
  end;

// *********************************************************************//
// Interface: IReceivedAttachment
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C0C9F1C0-0039-427B-8ACC-AD172FE557A8}
// *********************************************************************//
  IReceivedAttachment = interface(IAttachment)
    ['{C0C9F1C0-0039-427B-8ACC-AD172FE557A8}']
    procedure SaveToFile(const par_name: WideString; par_override: WordBool); safecall;
    function  GetAsByteArray: OleVariant; safecall;
    function  GetAsString(const par_ContentCharacterSet: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IReceivedAttachmentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C0C9F1C0-0039-427B-8ACC-AD172FE557A8}
// *********************************************************************//
  IReceivedAttachmentDisp = dispinterface
    ['{C0C9F1C0-0039-427B-8ACC-AD172FE557A8}']
    procedure SaveToFile(const par_name: WideString; par_override: WordBool); dispid 1610809344;
    function  GetAsByteArray: OleVariant; dispid 1610809345;
    function  GetAsString(const par_ContentCharacterSet: WideString): WideString; dispid 1610809346;
    property Property_[const par_name: WideString]: OleVariant readonly dispid 1610743808;
  end;

// *********************************************************************//
// Interface: ISoapMapper
// Flags:     (256) OleAutomation
// GUID:      {C1E6061A-F8DC-4CA8-A952-FAF7419F1029}
// *********************************************************************//
  ISoapMapper = interface(IUnknown)
    ['{C1E6061A-F8DC-4CA8-A952-FAF7419F1029}']
    function  Get_ElementName(out par_ElementName: WideString): HResult; stdcall;
    function  Get_PartName(out par_PartName: WideString): HResult; stdcall;
    function  Get_ElementType(out par_ElementType: WideString): HResult; stdcall;
    function  Get_IsInput(out par_Input: smIsInputEnum): HResult; stdcall;
    function  Get_ComValue(out par_VarOut: OleVariant): HResult; stdcall;
    function  Set_ComValue(par_VarOut: OleVariant): HResult; stdcall;
    function  Get_CallIndex(out par_CallIndex: Integer): HResult; stdcall;
    function  Get_ParameterOrder(out par_paraOrder: Integer): HResult; stdcall;
    function  Get_XmlNamespace(out par_xmlNameSpace: WideString): HResult; stdcall;
    function  Get_VariantType(out par_Type: Integer): HResult; stdcall;
    function  Get_XsdType(out par_Type: enXSDType): HResult; stdcall;
    function  Get_SpecialType(out par_SpecialType: enSpecialType): HResult; stdcall;
    function  Save(const par_ISoapSerializer: ISoapSerializer; const par_encoding: WideString; 
                   par_enSaveStyle: enEncodingStyle; const par_MessageNamespace: WideString; 
                   par_flags: Integer): HResult; stdcall;
    function  Load(const par_ISoapReader: ISoapReader; const par_Node: IXMLDOMNode; 
                   const par_encoding: WideString; par_enStyle: enEncodingStyle; 
                   const par_MessageNamespace: WideString; par_flags: Integer): HResult; stdcall;
    function  Get_SchemaNode(out par_TypeNode: IXMLDOMNode): HResult; stdcall;
    function  Get_SchemaNamespace(out par_Namespace: WideString): HResult; stdcall;
    function  Set_PartName(const par_PartName: WideString): HResult; stdcall;
    function  Set_SpecialType(par_SpecialType: enSpecialType): HResult; stdcall;
    function  Set_CallIndex(par_CallIndex: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ISoapSerializer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {23BDF2B5-2304-4550-BBE2-F197E2CC47B6}
// *********************************************************************//
  ISoapSerializer = interface(IDispatch)
    ['{23BDF2B5-2304-4550-BBE2-F197E2CC47B6}']
    procedure Init(par_output: OleVariant); safecall;
    procedure InitWithComposer(par_output: OleVariant; const par_composer: IMessageComposer); safecall;
    procedure StartEnvelope(const par_Prefix: WideString; const par_enc_style_uri: WideString; 
                            const par_encoding: WideString); safecall;
    procedure EndEnvelope; safecall;
    procedure StartHeader(const par_enc_style_uri: WideString); safecall;
    procedure StartHeaderElement(const par_name: WideString; const par_ns_uri: WideString; 
                                 par_mustUnderstand: SYSINT; const par_actor_uri: WideString; 
                                 const par_enc_style_uri: WideString; const par_Prefix: WideString); safecall;
    procedure EndHeaderElement; safecall;
    procedure EndHeader; safecall;
    procedure StartBody(const par_enc_style_uri: WideString); safecall;
    procedure EndBody; safecall;
    procedure StartElement(const par_name: WideString; const par_ns_uri: WideString; 
                           const par_enc_style_uri: WideString; const par_Prefix: WideString); safecall;
    procedure EndElement; safecall;
    procedure SoapAttribute(const par_name: WideString; const par_ns_uri: WideString; 
                            const par_value: WideString; const par_Prefix: WideString); safecall;
    procedure SoapNamespace(const par_Prefix: WideString; const par_ns_uri: WideString); safecall;
    procedure SoapDefaultNamespace(const par_ns_uri: WideString); safecall;
    procedure WriteString(const par_string: WideString); safecall;
    procedure WriteBuffer(par_len: Integer; var par_buffer: Byte); safecall;
    procedure StartFault(const par_FaultCode: WideString; const par_FaultString: WideString; 
                         const par_FaultActor: WideString; const par_FaultCodeNS: WideString); safecall;
    procedure StartFaultDetail(const par_enc_style_uri: WideString); safecall;
    procedure EndFaultDetail; safecall;
    procedure EndFault; safecall;
    procedure Reset; safecall;
    procedure WriteXml(const par_string: WideString); safecall;
    function  GetPrefixForNamespace(const par_ns_string: WideString): WideString; safecall;
    procedure EndHrefedElement; safecall;
    function  StartHrefedElement(const par_name: WideString; const par_ns_uri: WideString; 
                                 const par_enc_style_uri: WideString; const par_Prefix: WideString; 
                                 par_location: enElementLocation; const par_hrefidinput: WideString): WideString; safecall;
    function  Get_SoapFault: WordBool; safecall;
    function  GetContextItem(const par_key: WideString): OleVariant; safecall;
    procedure SetContextItem(const par_key: WideString; par_value: OleVariant); safecall;
    procedure AddAttachment(const par_att: IAttachment); safecall;
    procedure AddAttachmentAndReference(const par_att: IAttachment); safecall;
    procedure Finished; safecall;
    function  Get_Composer: IMessageComposer; safecall;
    function  CreateHRefId: WideString; safecall;
    property SoapFault: WordBool read Get_SoapFault;
    property Composer: IMessageComposer read Get_Composer;
  end;

// *********************************************************************//
// DispIntf:  ISoapSerializerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {23BDF2B5-2304-4550-BBE2-F197E2CC47B6}
// *********************************************************************//
  ISoapSerializerDisp = dispinterface
    ['{23BDF2B5-2304-4550-BBE2-F197E2CC47B6}']
    procedure Init(par_output: OleVariant); dispid 1;
    procedure InitWithComposer(par_output: OleVariant; const par_composer: IMessageComposer); dispid 2;
    procedure StartEnvelope(const par_Prefix: WideString; const par_enc_style_uri: WideString; 
                            const par_encoding: WideString); dispid 3;
    procedure EndEnvelope; dispid 4;
    procedure StartHeader(const par_enc_style_uri: WideString); dispid 5;
    procedure StartHeaderElement(const par_name: WideString; const par_ns_uri: WideString; 
                                 par_mustUnderstand: SYSINT; const par_actor_uri: WideString; 
                                 const par_enc_style_uri: WideString; const par_Prefix: WideString); dispid 6;
    procedure EndHeaderElement; dispid 7;
    procedure EndHeader; dispid 8;
    procedure StartBody(const par_enc_style_uri: WideString); dispid 9;
    procedure EndBody; dispid 10;
    procedure StartElement(const par_name: WideString; const par_ns_uri: WideString; 
                           const par_enc_style_uri: WideString; const par_Prefix: WideString); dispid 11;
    procedure EndElement; dispid 12;
    procedure SoapAttribute(const par_name: WideString; const par_ns_uri: WideString; 
                            const par_value: WideString; const par_Prefix: WideString); dispid 13;
    procedure SoapNamespace(const par_Prefix: WideString; const par_ns_uri: WideString); dispid 14;
    procedure SoapDefaultNamespace(const par_ns_uri: WideString); dispid 15;
    procedure WriteString(const par_string: WideString); dispid 16;
    procedure WriteBuffer(par_len: Integer; var par_buffer: Byte); dispid 17;
    procedure StartFault(const par_FaultCode: WideString; const par_FaultString: WideString; 
                         const par_FaultActor: WideString; const par_FaultCodeNS: WideString); dispid 18;
    procedure StartFaultDetail(const par_enc_style_uri: WideString); dispid 19;
    procedure EndFaultDetail; dispid 20;
    procedure EndFault; dispid 21;
    procedure Reset; dispid 22;
    procedure WriteXml(const par_string: WideString); dispid 23;
    function  GetPrefixForNamespace(const par_ns_string: WideString): WideString; dispid 24;
    procedure EndHrefedElement; dispid 26;
    function  StartHrefedElement(const par_name: WideString; const par_ns_uri: WideString; 
                                 const par_enc_style_uri: WideString; const par_Prefix: WideString; 
                                 par_location: enElementLocation; const par_hrefidinput: WideString): WideString; dispid 25;
    property SoapFault: WordBool readonly dispid 1610743834;
    function  GetContextItem(const par_key: WideString): OleVariant; dispid 1610743835;
    procedure SetContextItem(const par_key: WideString; par_value: OleVariant); dispid 1610743836;
    procedure AddAttachment(const par_att: IAttachment); dispid 1610743837;
    procedure AddAttachmentAndReference(const par_att: IAttachment); dispid 1610743838;
    procedure Finished; dispid 1610743839;
    property Composer: IMessageComposer readonly dispid 1610743840;
    function  CreateHRefId: WideString; dispid 27;
  end;

// *********************************************************************//
// Interface: IMessageComposer
// Flags:     (256) OleAutomation
// GUID:      {906A72B9-FF88-4A49-AFA2-CC4CAB5104EC}
// *********************************************************************//
  IMessageComposer = interface(IUnknown)
    ['{906A72B9-FF88-4A49-AFA2-CC4CAB5104EC}']
    function  StartComposing(const par_destination: IComposerDestination): HResult; stdcall;
    function  EndComposing: HResult; stdcall;
    function  StartEnvelope(const par_charSet: WideString; out par_envelope: ISequentialStream): HResult; stdcall;
    function  EndEnvelope: HResult; stdcall;
    function  AddAttachment(const par_att: IAttachment; out par_reference: WideString): HResult; stdcall;
    function  SaveSpecialTypeMapper(const par_ISoapMapper: ISoapMapper; 
                                    const par_ISoapSerializer: ISoapSerializer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IComposerDestination
// Flags:     (272) Hidden OleAutomation
// GUID:      {8E62C4B1-EE0C-48FB-9161-3EE041A03153}
// *********************************************************************//
  IComposerDestination = interface(IUnknown)
    ['{8E62C4B1-EE0C-48FB-9161-3EE041A03153}']
    function  Set_TotalSize(Param1: Integer): HResult; stdcall;
    function  Get_Property_(const par_name: WideString; out par_value: OleVariant): HResult; stdcall;
    function  Set_Property_(const par_name: WideString; par_value: OleVariant): HResult; stdcall;
    function  BeginSending(out par_stream: ISequentialStream; 
                           out par_flags: ComposerDestinationFlags): HResult; stdcall;
    function  EndSending: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDataEncoder
// Flags:     (320) Dual OleAutomation
// GUID:      {663EB158-8D95-4657-AE32-B7C60DE6122F}
// *********************************************************************//
  IDataEncoder = interface(IUnknown)
    ['{663EB158-8D95-4657-AE32-B7C60DE6122F}']
    function  Get_Encoding: WideString; safecall;
    procedure SizeToEncode(var par_From: Pointer; par_FromSize: LongWord; out par_To: LongWord); safecall;
    procedure SizeToDecode(var par_From: Pointer; par_FromSize: LongWord; out par_To: LongWord); safecall;
    procedure Encode(var par_From: Pointer; par_FromSize: LongWord; out par_To: Pointer; 
                     var par_ToSize: LongWord); safecall;
    procedure Decode(var par_From: Pointer; par_FromSize: LongWord; out par_To: Pointer; 
                     var par_ToSize: LongWord); safecall;
    procedure SizeToEncodeStream(const par_From: IStream; out par_To: LongWord); safecall;
    procedure SizeToDecodeStream(const par_From: IStream; out par_To: LongWord); safecall;
    procedure EncodeStream(const par_Form: IStream; const par_To: IStream); safecall;
    procedure DecodeStream(const par_From: IStream; const par_To: IStream); safecall;
    property Encoding: WideString read Get_Encoding;
  end;

// *********************************************************************//
// DispIntf:  IDataEncoderDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {663EB158-8D95-4657-AE32-B7C60DE6122F}
// *********************************************************************//
  IDataEncoderDisp = dispinterface
    ['{663EB158-8D95-4657-AE32-B7C60DE6122F}']
    property Encoding: WideString readonly dispid 1610678272;
    procedure SizeToEncode(var par_From: {??Pointer} OleVariant; par_FromSize: LongWord; 
                           out par_To: LongWord); dispid 1610678273;
    procedure SizeToDecode(var par_From: {??Pointer} OleVariant; par_FromSize: LongWord; 
                           out par_To: LongWord); dispid 1610678274;
    procedure Encode(var par_From: {??Pointer} OleVariant; par_FromSize: LongWord; 
                     out par_To: {??Pointer} OleVariant; var par_ToSize: LongWord); dispid 1610678275;
    procedure Decode(var par_From: {??Pointer} OleVariant; par_FromSize: LongWord; 
                     out par_To: {??Pointer} OleVariant; var par_ToSize: LongWord); dispid 1610678276;
    procedure SizeToEncodeStream(const par_From: IStream; out par_To: LongWord); dispid 1610678277;
    procedure SizeToDecodeStream(const par_From: IStream; out par_To: LongWord); dispid 1610678278;
    procedure EncodeStream(const par_Form: IStream; const par_To: IStream); dispid 1610678279;
    procedure DecodeStream(const par_From: IStream; const par_To: IStream); dispid 1610678280;
  end;

// *********************************************************************//
// Interface: IStream
// Flags:     (0)
// GUID:      {0000000C-0000-0000-C000-000000000046}
// *********************************************************************//
  IStream = interface(ISequentialStream)
    ['{0000000C-0000-0000-C000-000000000046}']
    function  RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                         out plibNewPosition: _ULARGE_INTEGER): HResult; stdcall;
    function  SetSize(libNewSize: _ULARGE_INTEGER): HResult; stdcall;
    function  RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; out pcbRead: _ULARGE_INTEGER; 
                           out pcbWritten: _ULARGE_INTEGER): HResult; stdcall;
    function  Commit(grfCommitFlags: LongWord): HResult; stdcall;
    function  Revert: HResult; stdcall;
    function  LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult; stdcall;
    function  UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult; stdcall;
    function  Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult; stdcall;
    function  Clone(out ppstm: IStream): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDataEncoderFactory
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {456C5AB4-2A2A-4289-9D4C-0C28BF739EE4}
// *********************************************************************//
  IDataEncoderFactory = interface(IDispatch)
    ['{456C5AB4-2A2A-4289-9D4C-0C28BF739EE4}']
    procedure AddDataEncoder(const par_encoding: WideString; const par_encoder: IDataEncoder); safecall;
    function  GetDataEncoder(const par_encoding: WideString): IDataEncoder; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDataEncoderFactoryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {456C5AB4-2A2A-4289-9D4C-0C28BF739EE4}
// *********************************************************************//
  IDataEncoderFactoryDisp = dispinterface
    ['{456C5AB4-2A2A-4289-9D4C-0C28BF739EE4}']
    procedure AddDataEncoder(const par_encoding: WideString; const par_encoder: IDataEncoder); dispid 1610743808;
    function  GetDataEncoder(const par_encoding: WideString): IDataEncoder; dispid 1610743809;
  end;

// *********************************************************************//
// Interface: IFileAttachment
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D6DEA9EB-28EA-45C7-A46A-72D26668C1EA}
// *********************************************************************//
  IFileAttachment = interface(IAttachment)
    ['{D6DEA9EB-28EA-45C7-A46A-72D26668C1EA}']
    function  Get_FileName: WideString; safecall;
    procedure Set_FileName(const par_value: WideString); safecall;
    procedure Set_DeleteAfterSending(par_value: WordBool); safecall;
    function  Get_DeleteAfterSending: WordBool; safecall;
    property FileName: WideString read Get_FileName;
    property DeleteAfterSending: WordBool write Set_DeleteAfterSending;
  end;

// *********************************************************************//
// DispIntf:  IFileAttachmentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D6DEA9EB-28EA-45C7-A46A-72D26668C1EA}
// *********************************************************************//
  IFileAttachmentDisp = dispinterface
    ['{D6DEA9EB-28EA-45C7-A46A-72D26668C1EA}']
    property FileName: WideString readonly dispid 1610809344;
    property DeleteAfterSending: WordBool writeonly dispid 1610809346;
    property Property_[const par_name: WideString]: OleVariant readonly dispid 1610743808;
  end;

// *********************************************************************//
// Interface: IStringAttachment
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8004A743-6A1E-45E4-B2E2-A6D117F06008}
// *********************************************************************//
  IStringAttachment = interface(IAttachment)
    ['{8004A743-6A1E-45E4-B2E2-A6D117F06008}']
    function  Get_String_: WideString; safecall;
    procedure Set_String_(const par_value: WideString); safecall;
    function  Get_ContentCharacterSet: WideString; safecall;
    procedure Set_ContentCharacterSet(const par_value: WideString); safecall;
    property String_: WideString read Get_String_;
    property ContentCharacterSet: WideString read Get_ContentCharacterSet;
  end;

// *********************************************************************//
// DispIntf:  IStringAttachmentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8004A743-6A1E-45E4-B2E2-A6D117F06008}
// *********************************************************************//
  IStringAttachmentDisp = dispinterface
    ['{8004A743-6A1E-45E4-B2E2-A6D117F06008}']
    property String_: WideString readonly dispid 1610809344;
    property ContentCharacterSet: WideString readonly dispid 1610809346;
    property Property_[const par_name: WideString]: OleVariant readonly dispid 1610743808;
  end;

// *********************************************************************//
// Interface: IByteArrayAttachment
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {52088645-8E96-4C18-8621-B46611635303}
// *********************************************************************//
  IByteArrayAttachment = interface(IAttachment)
    ['{52088645-8E96-4C18-8621-B46611635303}']
    function  Get_Array_: OleVariant; safecall;
    procedure Set_Array_(par_value: OleVariant); safecall;
    property Array_: OleVariant read Get_Array_;
  end;

// *********************************************************************//
// DispIntf:  IByteArrayAttachmentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {52088645-8E96-4C18-8621-B46611635303}
// *********************************************************************//
  IByteArrayAttachmentDisp = dispinterface
    ['{52088645-8E96-4C18-8621-B46611635303}']
    property Array_: OleVariant readonly dispid 1610809344;
    property Property_[const par_name: WideString]: OleVariant readonly dispid 1610743808;
  end;

// *********************************************************************//
// Interface: IStreamAttachment
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BE1DBCF5-2260-470A-8E1C-E2406D106E0A}
// *********************************************************************//
  IStreamAttachment = interface(IAttachment)
    ['{BE1DBCF5-2260-470A-8E1C-E2406D106E0A}']
    function  Get_Stream: IStream; safecall;
    procedure Set_Stream(const par_value: IStream); safecall;
    property Stream: IStream read Get_Stream;
  end;

// *********************************************************************//
// DispIntf:  IStreamAttachmentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BE1DBCF5-2260-470A-8E1C-E2406D106E0A}
// *********************************************************************//
  IStreamAttachmentDisp = dispinterface
    ['{BE1DBCF5-2260-470A-8E1C-E2406D106E0A}']
    property Stream: IStream readonly dispid 1610809344;
    property Property_[const par_name: WideString]: OleVariant readonly dispid 1610743808;
  end;

// *********************************************************************//
// Interface: ISentAttachments
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {95A098C0-EB61-4895-91C7-78873251322E}
// *********************************************************************//
  ISentAttachments = interface(IDispatch)
    ['{95A098C0-EB61-4895-91C7-78873251322E}']
    function  Get_Count: Integer; safecall;
    function  Get_Item(par_index: Integer): IAttachment; safecall;
    procedure Add(const par_att: IAttachment); safecall;
    property Count: Integer read Get_Count;
    property Item[par_index: Integer]: IAttachment read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  ISentAttachmentsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {95A098C0-EB61-4895-91C7-78873251322E}
// *********************************************************************//
  ISentAttachmentsDisp = dispinterface
    ['{95A098C0-EB61-4895-91C7-78873251322E}']
    property Count: Integer readonly dispid 1610743808;
    property Item[par_index: Integer]: IAttachment readonly dispid 0; default;
    procedure Add(const par_att: IAttachment); dispid 1610743810;
  end;

// *********************************************************************//
// Interface: IGetComposerDestination
// Flags:     (272) Hidden OleAutomation
// GUID:      {9E6CDFEF-4C42-411B-BACA-FE96F7A13C04}
// *********************************************************************//
  IGetComposerDestination = interface(IUnknown)
    ['{9E6CDFEF-4C42-411B-BACA-FE96F7A13C04}']
    function  Get_ComposerDestination(out par_value: IComposerDestination): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDimeComposer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ABAADE34-EEF6-408A-8896-65BE669D27FA}
// *********************************************************************//
  IDimeComposer = interface(IDispatch)
    ['{ABAADE34-EEF6-408A-8896-65BE669D27FA}']
    procedure Initialize(const par_tempFolder: WideString; par_maxSize: Integer; 
                         par_chunkSize: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf:  IDimeComposerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ABAADE34-EEF6-408A-8896-65BE669D27FA}
// *********************************************************************//
  IDimeComposerDisp = dispinterface
    ['{ABAADE34-EEF6-408A-8896-65BE669D27FA}']
    procedure Initialize(const par_tempFolder: WideString; par_maxSize: Integer; 
                         par_chunkSize: Integer); dispid 1610743808;
  end;

// *********************************************************************//
// Interface: ISimpleComposer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {70824404-7A18-412A-9A83-A9EC0F3FF045}
// *********************************************************************//
  ISimpleComposer = interface(IDispatch)
    ['{70824404-7A18-412A-9A83-A9EC0F3FF045}']
  end;

// *********************************************************************//
// DispIntf:  ISimpleComposerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {70824404-7A18-412A-9A83-A9EC0F3FF045}
// *********************************************************************//
  ISimpleComposerDisp = dispinterface
    ['{70824404-7A18-412A-9A83-A9EC0F3FF045}']
  end;

// *********************************************************************//
// Interface: IGetParserSource
// Flags:     (272) Hidden OleAutomation
// GUID:      {BB63287E-1407-40E3-89AB-38CB2746547F}
// *********************************************************************//
  IGetParserSource = interface(IUnknown)
    ['{BB63287E-1407-40E3-89AB-38CB2746547F}']
    function  Get_ParserSource(out par_value: IParserSource): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDimeParser
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E3F8BAA5-8A05-4641-91CE-3FBC533D1EDB}
// *********************************************************************//
  IDimeParser = interface(IDispatch)
    ['{E3F8BAA5-8A05-4641-91CE-3FBC533D1EDB}']
    procedure Initialize(const par_tempFolder: WideString; par_maxSize: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf:  IDimeParserDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E3F8BAA5-8A05-4641-91CE-3FBC533D1EDB}
// *********************************************************************//
  IDimeParserDisp = dispinterface
    ['{E3F8BAA5-8A05-4641-91CE-3FBC533D1EDB}']
    procedure Initialize(const par_tempFolder: WideString; par_maxSize: Integer); dispid 1610743808;
  end;

// *********************************************************************//
// Interface: ISimpleParser
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B313A227-0798-4A87-9074-48CA2164D0F7}
// *********************************************************************//
  ISimpleParser = interface(IDispatch)
    ['{B313A227-0798-4A87-9074-48CA2164D0F7}']
  end;

// *********************************************************************//
// DispIntf:  ISimpleParserDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B313A227-0798-4A87-9074-48CA2164D0F7}
// *********************************************************************//
  ISimpleParserDisp = dispinterface
    ['{B313A227-0798-4A87-9074-48CA2164D0F7}']
  end;

// *********************************************************************//
// Interface: ISoapClient
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F017F92-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapClient = interface(IDispatch)
    ['{7F017F92-9257-11D5-87EA-00B0D0BE6479}']
    procedure MSSoapInit(const par_WSDLFile: WideString; const par_ServiceName: WideString; 
                         const par_Port: WideString; const par_WSMLFile: WideString); safecall;
    function  Get_FaultCode: WideString; safecall;
    function  Get_FaultString: WideString; safecall;
    function  Get_FaultActor: WideString; safecall;
    function  Get_Detail: WideString; safecall;
    function  Get_ClientProperty(const par_PropertyName: WideString): OleVariant; safecall;
    procedure Set_HeaderHandler(const Param1: IDispatch); safecall;
    procedure _Set_ClientProperty(const par_PropertyName: WideString; par_PropertyValue: OleVariant); safecall;
    function  Get_ConnectorProperty(const par_PropertyName: WideString): OleVariant; safecall;
    procedure Set_ConnectorProperty(const par_PropertyName: WideString; 
                                    par_PropertyValue: OleVariant); safecall;
    procedure MSSoapInit2(par_WSDLFile: OleVariant; par_WSMLFile: OleVariant; 
                          const par_ServiceName: WideString; const par_Port: WideString; 
                          const par_Namespace: WideString); safecall;
    function  Get_FaultCodeNamespace: WideString; safecall;
    procedure Set_ClientProperty(const par_PropertyName: WideString; par_PropertyValue: OleVariant); safecall;
    property FaultCode: WideString read Get_FaultCode;
    property FaultString: WideString read Get_FaultString;
    property FaultActor: WideString read Get_FaultActor;
    property Detail: WideString read Get_Detail;
    property ClientProperty[const par_PropertyName: WideString]: OleVariant read Get_ClientProperty;
    property HeaderHandler: IDispatch write Set_HeaderHandler;
    property ConnectorProperty[const par_PropertyName: WideString]: OleVariant read Get_ConnectorProperty;
    property FaultCodeNamespace: WideString read Get_FaultCodeNamespace;
  end;

// *********************************************************************//
// DispIntf:  ISoapClientDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F017F92-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapClientDisp = dispinterface
    ['{7F017F92-9257-11D5-87EA-00B0D0BE6479}']
    procedure MSSoapInit(const par_WSDLFile: WideString; const par_ServiceName: WideString; 
                         const par_Port: WideString; const par_WSMLFile: WideString); dispid 1;
    property FaultCode: WideString readonly dispid 2;
    property FaultString: WideString readonly dispid 3;
    property FaultActor: WideString readonly dispid 4;
    property Detail: WideString readonly dispid 5;
    property ClientProperty[const par_PropertyName: WideString]: OleVariant readonly dispid 1610743813;
    property HeaderHandler: IDispatch writeonly dispid 1610743814;
    property ConnectorProperty[const par_PropertyName: WideString]: OleVariant readonly dispid 1610743816;
    procedure MSSoapInit2(par_WSDLFile: OleVariant; par_WSMLFile: OleVariant; 
                          const par_ServiceName: WideString; const par_Port: WideString; 
                          const par_Namespace: WideString); dispid 7;
    property FaultCodeNamespace: WideString readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ISoapServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F017F93-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapServer = interface(IDispatch)
    ['{7F017F93-9257-11D5-87EA-00B0D0BE6479}']
    procedure Init(const par_WSDLFile: WideString; const par_WSMLFile: WideString); safecall;
    procedure SoapInvoke(par_Input: OleVariant; const par_OutputStream: IUnknown; 
                         const par_soapAction: WideString); safecall;
    procedure SoapInvokeEx(par_Input: OleVariant; const par_OutputStream: IUnknown; 
                           const par_ServerObject: IUnknown; const par_soapAction: WideString; 
                           const par_ContentType: WideString); safecall;
    procedure Set_XmlVersion(const Param1: WideString); safecall;
    property XmlVersion: WideString write Set_XmlVersion;
  end;

// *********************************************************************//
// DispIntf:  ISoapServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F017F93-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapServerDisp = dispinterface
    ['{7F017F93-9257-11D5-87EA-00B0D0BE6479}']
    procedure Init(const par_WSDLFile: WideString; const par_WSMLFile: WideString); dispid 1;
    procedure SoapInvoke(par_Input: OleVariant; const par_OutputStream: IUnknown; 
                         const par_soapAction: WideString); dispid 2;
    procedure SoapInvokeEx(par_Input: OleVariant; const par_OutputStream: IUnknown; 
                           const par_ServerObject: IUnknown; const par_soapAction: WideString; 
                           const par_ContentType: WideString); dispid 3;
    property XmlVersion: WideString writeonly dispid 4;
  end;

// *********************************************************************//
// Interface: ISoapTypeMapperFactory
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FCED9F15-D0A7-4380-87E6-992381ACD213}
// *********************************************************************//
  ISoapTypeMapperFactory = interface(IDispatch)
    ['{FCED9F15-D0A7-4380-87E6-992381ACD213}']
    procedure AddSchema(const par_SchemaNode: IXMLDOMNode); safecall;
    function  GetElementMapperByName(const par_ElementName: WideString; 
                                     const par_ElementNamespace: WideString): ISoapTypeMapper; safecall;
    function  GetTypeMapperByName(const par_TypeName: WideString; 
                                  const par_TypeNamespace: WideString): ISoapTypeMapper; safecall;
    function  GetElementMapper(const par_ElementNode: IXMLDOMNode): ISoapTypeMapper; safecall;
    function  GetTypeMapper(const par_TypeNode: IXMLDOMNode): ISoapTypeMapper; safecall;
    procedure AddType(const par_TypeName: WideString; const par_TypeNamespace: WideString; 
                      const par_ProgID: WideString; const par_IID: WideString); safecall;
    procedure AddElement(const par_ElementName: WideString; const par_ElementNamespace: WideString; 
                         const par_ProgID: WideString; const par_IID: WideString); safecall;
    function  GetMapper(par_xsdType: enXSDType; const par_SchemaNode: IXMLDOMNode): ISoapTypeMapper; safecall;
    procedure AddCustomMapper(const par_ProgID: WideString; const par_WSMLNode: IXMLDOMNode); safecall;
    function  GetDefinitionsNode(const par_BaseName: WideString; const par_Namespace: WideString; 
                                 par_LookForElement: WordBool): IXMLDOMNode; safecall;
  end;

// *********************************************************************//
// DispIntf:  ISoapTypeMapperFactoryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FCED9F15-D0A7-4380-87E6-992381ACD213}
// *********************************************************************//
  ISoapTypeMapperFactoryDisp = dispinterface
    ['{FCED9F15-D0A7-4380-87E6-992381ACD213}']
    procedure AddSchema(const par_SchemaNode: IXMLDOMNode); dispid 6;
    function  GetElementMapperByName(const par_ElementName: WideString; 
                                     const par_ElementNamespace: WideString): ISoapTypeMapper; dispid 1;
    function  GetTypeMapperByName(const par_TypeName: WideString; 
                                  const par_TypeNamespace: WideString): ISoapTypeMapper; dispid 2;
    function  GetElementMapper(const par_ElementNode: IXMLDOMNode): ISoapTypeMapper; dispid 7;
    function  GetTypeMapper(const par_TypeNode: IXMLDOMNode): ISoapTypeMapper; dispid 8;
    procedure AddType(const par_TypeName: WideString; const par_TypeNamespace: WideString; 
                      const par_ProgID: WideString; const par_IID: WideString); dispid 4;
    procedure AddElement(const par_ElementName: WideString; const par_ElementNamespace: WideString; 
                         const par_ProgID: WideString; const par_IID: WideString); dispid 5;
    function  GetMapper(par_xsdType: enXSDType; const par_SchemaNode: IXMLDOMNode): ISoapTypeMapper; dispid 3;
    procedure AddCustomMapper(const par_ProgID: WideString; const par_WSMLNode: IXMLDOMNode); dispid 9;
    function  GetDefinitionsNode(const par_BaseName: WideString; const par_Namespace: WideString; 
                                 par_LookForElement: WordBool): IXMLDOMNode; dispid 10;
  end;

// *********************************************************************//
// Interface: ISoapTypeMapper
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29D3F736-1C25-44EE-9CEE-3F52F226BA8A}
// *********************************************************************//
  ISoapTypeMapper = interface(IDispatch)
    ['{29D3F736-1C25-44EE-9CEE-3F52F226BA8A}']
    procedure Init(const par_Factory: ISoapTypeMapperFactory; const par_Schema: IXMLDOMNode; 
                   const par_WSMLNode: IXMLDOMNode; par_xsdType: enXSDType); safecall;
    function  Read(const par_soapreader: ISoapReader; const par_Node: IXMLDOMNode; 
                   const par_encoding: WideString; par_encodingMode: enEncodingStyle; 
                   par_flags: Integer): OleVariant; safecall;
    procedure Write(const par_ISoapSerializer: ISoapSerializer; const par_encoding: WideString; 
                    par_encodingMode: enEncodingStyle; par_flags: Integer; var par_var: OleVariant); safecall;
    function  VarType: Integer; safecall;
    function  Iid: WideString; safecall;
    function  SchemaNode: IXMLDOMNode; safecall;
    function  XsdType: enXSDType; safecall;
  end;

// *********************************************************************//
// DispIntf:  ISoapTypeMapperDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29D3F736-1C25-44EE-9CEE-3F52F226BA8A}
// *********************************************************************//
  ISoapTypeMapperDisp = dispinterface
    ['{29D3F736-1C25-44EE-9CEE-3F52F226BA8A}']
    procedure Init(const par_Factory: ISoapTypeMapperFactory; const par_Schema: IXMLDOMNode; 
                   const par_WSMLNode: IXMLDOMNode; par_xsdType: enXSDType); dispid 1;
    function  Read(const par_soapreader: ISoapReader; const par_Node: IXMLDOMNode; 
                   const par_encoding: WideString; par_encodingMode: enEncodingStyle; 
                   par_flags: Integer): OleVariant; dispid 2;
    procedure Write(const par_ISoapSerializer: ISoapSerializer; const par_encoding: WideString; 
                    par_encodingMode: enEncodingStyle; par_flags: Integer; var par_var: OleVariant); dispid 3;
    function  VarType: Integer; dispid 4;
    function  Iid: WideString; dispid 5;
    function  SchemaNode: IXMLDOMNode; dispid 6;
    function  XsdType: enXSDType; dispid 7;
  end;

// *********************************************************************//
// Interface: IHeaderHandler
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {504D4B91-76B8-4D88-95EA-CEB5E0FE41F3}
// *********************************************************************//
  IHeaderHandler = interface(IDispatch)
    ['{504D4B91-76B8-4D88-95EA-CEB5E0FE41F3}']
    function  WillWriteHeaders: WordBool; safecall;
    procedure WriteHeaders(const par_ISoapSerializer: ISoapSerializer; const par_Object: IDispatch); safecall;
    function  ReadHeader(const par_Reader: ISoapReader; const par_HeaderNode: IXMLDOMNode; 
                         const par_Object: IDispatch): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IHeaderHandlerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {504D4B91-76B8-4D88-95EA-CEB5E0FE41F3}
// *********************************************************************//
  IHeaderHandlerDisp = dispinterface
    ['{504D4B91-76B8-4D88-95EA-CEB5E0FE41F3}']
    function  WillWriteHeaders: WordBool; dispid 1;
    procedure WriteHeaders(const par_ISoapSerializer: ISoapSerializer; const par_Object: IDispatch); dispid 2;
    function  ReadHeader(const par_Reader: ISoapReader; const par_HeaderNode: IXMLDOMNode; 
                         const par_Object: IDispatch): WordBool; dispid 3;
  end;

// *********************************************************************//
// Interface: IEnumSoapMappers
// Flags:     (256) OleAutomation
// GUID:      {ACDDCED6-6DB8-497A-BF10-068711629924}
// *********************************************************************//
  IEnumSoapMappers = interface(IUnknown)
    ['{ACDDCED6-6DB8-497A-BF10-068711629924}']
    function  Next(par_celt: Integer; out par_soapmapper: ISoapMapper; out par_Fetched: Integer): HResult; stdcall;
    function  Skip(par_celt: Integer): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out par_enum: IEnumSoapMappers): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IWSDLMessage
// Flags:     (256) OleAutomation
// GUID:      {49F9421C-DC88-43E1-825F-70E788E9A9A9}
// *********************************************************************//
  IWSDLMessage = interface(IUnknown)
    ['{49F9421C-DC88-43E1-825F-70E788E9A9A9}']
    function  Get_EncodingStyle(out par_enStyle: enEncodingStyle): HResult; stdcall;
    function  Get_EncodingNamespace(out par_encodingNamespace: WideString): HResult; stdcall;
    function  Get_MessageName(out par_messageName: WideString): HResult; stdcall;
    function  Get_MessageNamespace(out par_MessageNamespace: WideString): HResult; stdcall;
    function  Get_MessageParts(out par_IEnumSoapMappers: IEnumSoapMappers): HResult; stdcall;
    function  GetComposer(const par_tempFolder: WideString; par_maxSize: Integer; 
                          out par_composer: IMessageComposer): HResult; stdcall;
    function  GetParser(const par_tempFolder: WideString; par_maxSize: Integer; 
                        out par_parser: IMessageParser): HResult; stdcall;
    function  AddAttachmentCollection(const par_bstrPartName: WideString; 
                                      par_lserverSideCallIndex: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IWSDLOperation
// Flags:     (256) OleAutomation
// GUID:      {A0B762A7-9F3E-48D8-B333-770E5FA72A1E}
// *********************************************************************//
  IWSDLOperation = interface(IUnknown)
    ['{A0B762A7-9F3E-48D8-B333-770E5FA72A1E}']
    function  Get_Documentation(out par_Documentation: WideString): HResult; stdcall;
    function  Get_Name(out par_OperationName: WideString): HResult; stdcall;
    function  Get_SoapAction(out par_soapAction: WideString): HResult; stdcall;
    function  Get_ObjectProgId(out par_ObjectProgId: WideString): HResult; stdcall;
    function  Get_ObjectMethod(out par_ObjectMethod: WideString): HResult; stdcall;
    function  Get_InputMessage(out par_InputMessage: IWSDLMessage): HResult; stdcall;
    function  Get_OutputMessage(out par_OutputMessage: IWSDLMessage): HResult; stdcall;
    function  Get_PreferredEncoding(out par_preferredEncoding: WideString): HResult; stdcall;
    function  GetOperationParts(out par_IEnumSoapMappers: IEnumSoapMappers): HResult; stdcall;
    function  ExecuteOperation(const par_ISoapReader: ISoapReader; 
                               const par_ISoapSerializer: ISoapSerializer): HResult; stdcall;
    function  ExecuteOperationEx(const par_ISoapReader: ISoapReader; 
                                 const par_ISoapSerializer: ISoapSerializer; 
                                 const par_ServerObject: IUnknown): HResult; stdcall;
    function  Save(const par_ISoapSerializer: ISoapSerializer; par_Input: WordBool): HResult; stdcall;
    function  Load(const par_ISoapReader: ISoapReader; par_Input: WordBool): HResult; stdcall;
    function  GetNameRef: PWord1; stdcall;
    function  Get_type_(out par_Type: enOperationType): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumWSDLOperations
// Flags:     (256) OleAutomation
// GUID:      {B0BBA669-55F7-4E9C-941E-49BC4715C834}
// *********************************************************************//
  IEnumWSDLOperations = interface(IUnknown)
    ['{B0BBA669-55F7-4E9C-941E-49BC4715C834}']
    function  Next(par_celt: Integer; out par_WSDLOperation: IWSDLOperation; 
                   out par_Fetched: Integer): HResult; stdcall;
    function  Skip(par_celt: Integer): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out par_enum: IEnumWSDLOperations): HResult; stdcall;
    function  Find(const par_OperationToFind: WideString; out par_IWSDLOperation: IWSDLOperation): HResult; stdcall;
    function  Size(out par_Size: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IWSDLPort
// Flags:     (256) OleAutomation
// GUID:      {4D40B730-F5FA-472C-8819-DDCD183BD0DE}
// *********************************************************************//
  IWSDLPort = interface(IUnknown)
    ['{4D40B730-F5FA-472C-8819-DDCD183BD0DE}']
    function  Get_Name(out par_PortName: WideString): HResult; stdcall;
    function  Get_Address(out par_PortAddress: WideString): HResult; stdcall;
    function  Get_BindStyle(out par_BindStyle: WideString): HResult; stdcall;
    function  Get_Transport(out par_Transport: WideString): HResult; stdcall;
    function  Get_Documentation(out par_Documentation: WideString): HResult; stdcall;
    function  GetSoapOperations(out par_IWSDLOperations: IEnumWSDLOperations): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumWSDLPorts
// Flags:     (256) OleAutomation
// GUID:      {EC189C1C-31B3-4193-BDCA-98EC44FF3EE0}
// *********************************************************************//
  IEnumWSDLPorts = interface(IUnknown)
    ['{EC189C1C-31B3-4193-BDCA-98EC44FF3EE0}']
    function  Next(par_celt: Integer; out WSDLPort: IWSDLPort; var par_Fetched: Integer): HResult; stdcall;
    function  Skip(par_celt: Integer): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out par_enum: IEnumWSDLPorts): HResult; stdcall;
    function  Find(const par_PortToFind: WideString; out par_IWSDLPort: IWSDLPort): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IWSDLService
// Flags:     (256) OleAutomation
// GUID:      {9B5D8D63-EA54-41F6-9F12-F77A13111EC6}
// *********************************************************************//
  IWSDLService = interface(IUnknown)
    ['{9B5D8D63-EA54-41F6-9F12-F77A13111EC6}']
    function  Get_Name(out par_ServiceName: WideString): HResult; stdcall;
    function  Get_Documentation(out par_Documentation: WideString): HResult; stdcall;
    function  GetSoapPorts(out par_IWSDLPorts: IEnumWSDLPorts): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumWSDLService
// Flags:     (256) OleAutomation
// GUID:      {104F6816-093E-41D7-A68B-8E1CC408B279}
// *********************************************************************//
  IEnumWSDLService = interface(IUnknown)
    ['{104F6816-093E-41D7-A68B-8E1CC408B279}']
    function  Next(par_celt: Integer; out par_IWSDLService: IWSDLService; var par_Fetched: Integer): HResult; stdcall;
    function  Skip(par_celt: Integer): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out par_enum: IEnumWSDLService): HResult; stdcall;
    function  Find(const par_ServiceToFind: WideString; out par_WSDLService: IWSDLService): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IWSDLReader
// Flags:     (256) OleAutomation
// GUID:      {DE523FD4-AFB8-4643-BA90-9DEB3C7FB4A3}
// *********************************************************************//
  IWSDLReader = interface(IUnknown)
    ['{DE523FD4-AFB8-4643-BA90-9DEB3C7FB4A3}']
    function  Load(const par_WSDLFile: WideString; const par_WSMLFile: WideString): HResult; stdcall;
    function  Load2(par_WSDLFile: OleVariant; par_WSMLFile: OleVariant; 
                    const par_StartingNamespace: WideString): HResult; stdcall;
    function  GetSoapServices(out par_IWSDLServiceEnum: IEnumWSDLService): HResult; stdcall;
    function  ParseRequest(const par_ISoapReader: ISoapReader; out par_IWSDLPort: IWSDLPort; 
                           out par_IWSDLOperation: IWSDLOperation): HResult; stdcall;
    function  SetProperty(const par_PropertyName: WideString; par_PropValue: OleVariant): HResult; stdcall;
    function  Get_TypeFactory(out par_Factory: ISoapTypeMapperFactory): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IWSDLBinding
// Flags:     (272) Hidden OleAutomation
// GUID:      {AB0E0268-304D-43FC-8603-B1105F3A7512}
// *********************************************************************//
  IWSDLBinding = interface(IUnknown)
    ['{AB0E0268-304D-43FC-8603-B1105F3A7512}']
    function  Initialize(const pWSMLBindingNode: IXMLDOMNode; var pbstrNamespace: WideString): HResult; stdcall;
    function  ParseBinding(const pWSDLInputOutputNode: IXMLDOMNode; var ppSoapBodyNode: IXMLDOMNode): HResult; stdcall;
    function  ApplyBinding(const pWSDLMessage: IWSDLMessage; 
                           const pWSDLInputOutputNode: IXMLDOMNode; 
                           const pWSMLOperationNode: IXMLDOMNode): HResult; stdcall;
    function  GetComposer(const bstrTemporaryAttachmentFolder: WideString; 
                          lMaxAttachmentSize: Integer; lReserved: Integer; 
                          var ppComposer: IMessageComposer): HResult; stdcall;
    function  GetParser(const bstrTemporaryAttachmentFolder: WideString; 
                        lMaxAttachmentSize: Integer; var ppParser: IMessageParser): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ISoapConnector
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AF40C4E-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapConnector = interface(IDispatch)
    ['{0AF40C4E-9257-11D5-87EA-00B0D0BE6479}']
    function  Get_InputStream: IStream; safecall;
    function  Get_OutputStream: IStream; safecall;
    function  Get_Property_(const par_name: WideString): OleVariant; safecall;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant); safecall;
    procedure ConnectWSDL(const par_Port: IWSDLPort); safecall;
    procedure BeginMessageWSDL(const par_operation: IWSDLOperation); safecall;
    procedure EndMessage; safecall;
    procedure Reset; safecall;
    procedure Connect; safecall;
    procedure BeginMessage; safecall;
    property InputStream: IStream read Get_InputStream;
    property OutputStream: IStream read Get_OutputStream;
    property Property_[const par_name: WideString]: OleVariant read Get_Property_ write Set_Property_;
  end;

// *********************************************************************//
// DispIntf:  ISoapConnectorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AF40C4E-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapConnectorDisp = dispinterface
    ['{0AF40C4E-9257-11D5-87EA-00B0D0BE6479}']
    property InputStream: IStream readonly dispid 1;
    property OutputStream: IStream readonly dispid 2;
    property Property_[const par_name: WideString]: OleVariant dispid 3;
    procedure ConnectWSDL(const par_Port: IWSDLPort); dispid 4;
    procedure BeginMessageWSDL(const par_operation: IWSDLOperation); dispid 6;
    procedure EndMessage; dispid 7;
    procedure Reset; dispid 5;
    procedure Connect; dispid 8;
    procedure BeginMessage; dispid 9;
  end;

// *********************************************************************//
// Interface: ISoapConnectorFactory
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AF40C50-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapConnectorFactory = interface(IDispatch)
    ['{0AF40C50-9257-11D5-87EA-00B0D0BE6479}']
    function  CreatePortConnector(const par_Port: IWSDLPort): ISoapConnector; safecall;
  end;

// *********************************************************************//
// DispIntf:  ISoapConnectorFactoryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AF40C50-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapConnectorFactoryDisp = dispinterface
    ['{0AF40C50-9257-11D5-87EA-00B0D0BE6479}']
    function  CreatePortConnector(const par_Port: IWSDLPort): ISoapConnector; dispid 1;
  end;

// *********************************************************************//
// Interface: ISoapError
// Flags:     (256) OleAutomation
// GUID:      {7F017F94-9257-11D5-87EA-00B0D0BE6479}
// *********************************************************************//
  ISoapError = interface(IUnknown)
    ['{7F017F94-9257-11D5-87EA-00B0D0BE6479}']
    function  Get_FaultCode(out par_FaultCode: WideString): HResult; stdcall;
    function  Get_FaultString(out par_FaultString: WideString): HResult; stdcall;
    function  Get_FaultActor(out par_Actor: WideString): HResult; stdcall;
    function  Get_Detail(out par_Detail: WideString): HResult; stdcall;
    function  Get_FaultCodeNamespace(out par_Namespace: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IErrorInfo
// Flags:     (0)
// GUID:      {1CF2B120-547D-101B-8E65-08002B2BD119}
// *********************************************************************//
  IErrorInfo = interface(IUnknown)
    ['{1CF2B120-547D-101B-8E65-08002B2BD119}']
    function  GetGUID(out pGUID: TGUID): HResult; stdcall;
    function  GetSource(out pBstrSource: WideString): HResult; stdcall;
    function  GetDescription(out pBstrDescription: WideString): HResult; stdcall;
    function  GetHelpFile(out pBstrHelpFile: WideString): HResult; stdcall;
    function  GetHelpContext(out pdwHelpContext: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ISoapErrorInfo
// Flags:     (256) OleAutomation
// GUID:      {C0871607-8C99-4824-92CD-85CBD4C7273F}
// *********************************************************************//
  ISoapErrorInfo = interface(IErrorInfo)
    ['{C0871607-8C99-4824-92CD-85CBD4C7273F}']
    function  SetActor(const par_Actor: WideString): HResult; stdcall;
    function  SetFaultCode(const par_FaultCode: WideString): HResult; stdcall;
    function  AddErrorEntry(const par_Description: WideString; const par_Component: WideString; 
                            par_ErrorCode: HResult): HResult; stdcall;
    function  AddSoapError(const par_FaultString: WideString; const par_FaultActor: WideString; 
                           const par_Detail: WideString; const par_FaultCode: WideString; 
                           const par_Namespace: WideString): HResult; stdcall;
    function  AddErrorInfo(const par_Description: WideString; const par_source: WideString; 
                           const par_Helpfile: WideString; par_HelpContext: LongWord; 
                           par_hrFromErrorInfo: HResult): HResult; stdcall;
    function  LoadFault(const par_Document: IXMLDOMDocument): HResult; stdcall;
    function  GetHresult(out par_HR: HResult): HResult; stdcall;
    function  GetErrorEntry(par_EntryID: LongWord; out par_Description: WideString; 
                            out par_Component: WideString; out par_HR: HResult): HResult; stdcall;
    function  GetActor(out par_Actor: WideString): HResult; stdcall;
    function  GetErrorInfo(var par_Description: WideString; var par_source: WideString; 
                           var par_Helpfile: WideString; var par_HelpContext: LongWord; 
                           var par_hrFromErrorInfo: HResult): HResult; stdcall;
    function  GetSoapError(var par_FaultString: WideString; var par_FaultActor: WideString; 
                           var par_Detail: WideString; var par_FaultCode: WideString; 
                           var par_Namespace: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGCTMObjectFactory
// Flags:     (256) OleAutomation
// GUID:      {3C87B8BE-F2B7-45C5-B34E-4A46A58A80B0}
// *********************************************************************//
  IGCTMObjectFactory = interface(IUnknown)
    ['{3C87B8BE-F2B7-45C5-B34E-4A46A58A80B0}']
    function  CreateObject(const par_WSMLNode: IXMLDOMNode; out par_Object: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoFileAttachment30 provides a Create and CreateRemote method to          
// create instances of the default interface IFileAttachment exposed by              
// the CoClass FileAttachment30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFileAttachment30 = class
    class function Create: IFileAttachment;
    class function CreateRemote(const MachineName: string): IFileAttachment;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFileAttachment30
// Help String      : File attachment
// Default Interface: IFileAttachment
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFileAttachment30Properties= class;
{$ENDIF}
  TFileAttachment30 = class(TOleServer)
  private
    FIntf:        IFileAttachment;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFileAttachment30Properties;
    function      GetServerProperties: TFileAttachment30Properties;
{$ENDIF}
    function      GetDefaultInterface: IFileAttachment;
  protected
    procedure InitServerData; override;
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
    function  Get_FileName: WideString;
    procedure Set_FileName(const par_value: WideString);
    procedure Set_DeleteAfterSending(par_value: WordBool);
    function  Get_DeleteAfterSending: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFileAttachment);
    procedure Disconnect; override;
    property  DefaultInterface: IFileAttachment read GetDefaultInterface;
    property Property_[const par_name: WideString]: OleVariant read Get_Property_ write Set_Property_;
    property FileName: WideString read Get_FileName write Set_FileName;
    property DeleteAfterSending: WordBool read Get_DeleteAfterSending write Set_DeleteAfterSending;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFileAttachment30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TFileAttachment30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TFileAttachment30Properties = class(TPersistent)
  private
    FServer:    TFileAttachment30;
    function    GetDefaultInterface: IFileAttachment;
    constructor Create(AServer: TFileAttachment30);
  protected
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
    function  Get_FileName: WideString;
    procedure Set_FileName(const par_value: WideString);
    procedure Set_DeleteAfterSending(par_value: WordBool);
    function  Get_DeleteAfterSending: WordBool;
  public
    property DefaultInterface: IFileAttachment read GetDefaultInterface;
  published
    property FileName: WideString read Get_FileName write Set_FileName;
    property DeleteAfterSending: WordBool read Get_DeleteAfterSending write Set_DeleteAfterSending;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoStringAttachment30 provides a Create and CreateRemote method to          
// create instances of the default interface IStringAttachment exposed by              
// the CoClass StringAttachment30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoStringAttachment30 = class
    class function Create: IStringAttachment;
    class function CreateRemote(const MachineName: string): IStringAttachment;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TStringAttachment30
// Help String      : String attachment
// Default Interface: IStringAttachment
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TStringAttachment30Properties= class;
{$ENDIF}
  TStringAttachment30 = class(TOleServer)
  private
    FIntf:        IStringAttachment;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TStringAttachment30Properties;
    function      GetServerProperties: TStringAttachment30Properties;
{$ENDIF}
    function      GetDefaultInterface: IStringAttachment;
  protected
    procedure InitServerData; override;
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
    function  Get_String_: WideString;
    procedure Set_String_(const par_value: WideString);
    function  Get_ContentCharacterSet: WideString;
    procedure Set_ContentCharacterSet(const par_value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStringAttachment);
    procedure Disconnect; override;
    property  DefaultInterface: IStringAttachment read GetDefaultInterface;
    property Property_[const par_name: WideString]: OleVariant read Get_Property_ write Set_Property_;
    property String_: WideString read Get_String_ write Set_String_;
    property ContentCharacterSet: WideString read Get_ContentCharacterSet write Set_ContentCharacterSet;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TStringAttachment30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TStringAttachment30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TStringAttachment30Properties = class(TPersistent)
  private
    FServer:    TStringAttachment30;
    function    GetDefaultInterface: IStringAttachment;
    constructor Create(AServer: TStringAttachment30);
  protected
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
    function  Get_String_: WideString;
    procedure Set_String_(const par_value: WideString);
    function  Get_ContentCharacterSet: WideString;
    procedure Set_ContentCharacterSet(const par_value: WideString);
  public
    property DefaultInterface: IStringAttachment read GetDefaultInterface;
  published
    property String_: WideString read Get_String_ write Set_String_;
    property ContentCharacterSet: WideString read Get_ContentCharacterSet write Set_ContentCharacterSet;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoByteArrayAttachment30 provides a Create and CreateRemote method to          
// create instances of the default interface IByteArrayAttachment exposed by              
// the CoClass ByteArrayAttachment30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoByteArrayAttachment30 = class
    class function Create: IByteArrayAttachment;
    class function CreateRemote(const MachineName: string): IByteArrayAttachment;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TByteArrayAttachment30
// Help String      : Byte Array attachment
// Default Interface: IByteArrayAttachment
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TByteArrayAttachment30Properties= class;
{$ENDIF}
  TByteArrayAttachment30 = class(TOleServer)
  private
    FIntf:        IByteArrayAttachment;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TByteArrayAttachment30Properties;
    function      GetServerProperties: TByteArrayAttachment30Properties;
{$ENDIF}
    function      GetDefaultInterface: IByteArrayAttachment;
  protected
    procedure InitServerData; override;
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
    function  Get_Array_: OleVariant;
    procedure Set_Array_(par_value: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IByteArrayAttachment);
    procedure Disconnect; override;
    property  DefaultInterface: IByteArrayAttachment read GetDefaultInterface;
    property Property_[const par_name: WideString]: OleVariant read Get_Property_ write Set_Property_;
    property Array_: OleVariant read Get_Array_ write Set_Array_;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TByteArrayAttachment30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TByteArrayAttachment30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TByteArrayAttachment30Properties = class(TPersistent)
  private
    FServer:    TByteArrayAttachment30;
    function    GetDefaultInterface: IByteArrayAttachment;
    constructor Create(AServer: TByteArrayAttachment30);
  protected
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
    function  Get_Array_: OleVariant;
    procedure Set_Array_(par_value: OleVariant);
  public
    property DefaultInterface: IByteArrayAttachment read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoStreamAttachment30 provides a Create and CreateRemote method to          
// create instances of the default interface IStreamAttachment exposed by              
// the CoClass StreamAttachment30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoStreamAttachment30 = class
    class function Create: IStreamAttachment;
    class function CreateRemote(const MachineName: string): IStreamAttachment;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TStreamAttachment30
// Help String      : Stream attachment
// Default Interface: IStreamAttachment
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TStreamAttachment30Properties= class;
{$ENDIF}
  TStreamAttachment30 = class(TOleServer)
  private
    FIntf:        IStreamAttachment;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TStreamAttachment30Properties;
    function      GetServerProperties: TStreamAttachment30Properties;
{$ENDIF}
    function      GetDefaultInterface: IStreamAttachment;
  protected
    procedure InitServerData; override;
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
    function  Get_Stream: IStream;
    procedure Set_Stream(const par_value: IStream);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStreamAttachment);
    procedure Disconnect; override;
    property  DefaultInterface: IStreamAttachment read GetDefaultInterface;
    property Property_[const par_name: WideString]: OleVariant read Get_Property_ write Set_Property_;
    property Stream: IStream read Get_Stream write Set_Stream;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TStreamAttachment30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TStreamAttachment30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TStreamAttachment30Properties = class(TPersistent)
  private
    FServer:    TStreamAttachment30;
    function    GetDefaultInterface: IStreamAttachment;
    constructor Create(AServer: TStreamAttachment30);
  protected
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
    function  Get_Stream: IStream;
    procedure Set_Stream(const par_value: IStream);
  public
    property DefaultInterface: IStreamAttachment read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSentAttachments30 provides a Create and CreateRemote method to          
// create instances of the default interface ISentAttachments exposed by              
// the CoClass SentAttachments30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSentAttachments30 = class
    class function Create: ISentAttachments;
    class function CreateRemote(const MachineName: string): ISentAttachments;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSentAttachments30
// Help String      : Sent attachment
// Default Interface: ISentAttachments
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSentAttachments30Properties= class;
{$ENDIF}
  TSentAttachments30 = class(TOleServer)
  private
    FIntf:        ISentAttachments;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSentAttachments30Properties;
    function      GetServerProperties: TSentAttachments30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISentAttachments;
  protected
    procedure InitServerData; override;
    function  Get_Count: Integer;
    function  Get_Item(par_index: Integer): IAttachment;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISentAttachments);
    procedure Disconnect; override;
    procedure Add(const par_att: IAttachment);
    property  DefaultInterface: ISentAttachments read GetDefaultInterface;
    property Count: Integer read Get_Count;
    property Item[par_index: Integer]: IAttachment read Get_Item; default;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSentAttachments30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSentAttachments30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSentAttachments30Properties = class(TPersistent)
  private
    FServer:    TSentAttachments30;
    function    GetDefaultInterface: ISentAttachments;
    constructor Create(AServer: TSentAttachments30);
  protected
    function  Get_Count: Integer;
    function  Get_Item(par_index: Integer): IAttachment;
  public
    property DefaultInterface: ISentAttachments read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoReceivedAttachments30 provides a Create and CreateRemote method to          
// create instances of the default interface IReceivedAttachments exposed by              
// the CoClass ReceivedAttachments30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoReceivedAttachments30 = class
    class function Create: IReceivedAttachments;
    class function CreateRemote(const MachineName: string): IReceivedAttachments;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TReceivedAttachments30
// Help String      : Received attachment
// Default Interface: IReceivedAttachments
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TReceivedAttachments30Properties= class;
{$ENDIF}
  TReceivedAttachments30 = class(TOleServer)
  private
    FIntf:        IReceivedAttachments;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TReceivedAttachments30Properties;
    function      GetServerProperties: TReceivedAttachments30Properties;
{$ENDIF}
    function      GetDefaultInterface: IReceivedAttachments;
  protected
    procedure InitServerData; override;
    function  Get_Count: Integer;
    function  Get_Item(par_index: OleVariant): IReceivedAttachment;
    function  Get_ItemWithContext(par_index: OleVariant; const par_context: IXMLDOMNode): IReceivedAttachment;
    function  Get__NewEnum: IUnknown;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IReceivedAttachments);
    procedure Disconnect; override;
    property  DefaultInterface: IReceivedAttachments read GetDefaultInterface;
    property Count: Integer read Get_Count;
    property Item[par_index: OleVariant]: IReceivedAttachment read Get_Item; default;
    property ItemWithContext[par_index: OleVariant; const par_context: IXMLDOMNode]: IReceivedAttachment read Get_ItemWithContext;
    property _NewEnum: IUnknown read Get__NewEnum;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TReceivedAttachments30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TReceivedAttachments30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TReceivedAttachments30Properties = class(TPersistent)
  private
    FServer:    TReceivedAttachments30;
    function    GetDefaultInterface: IReceivedAttachments;
    constructor Create(AServer: TReceivedAttachments30);
  protected
    function  Get_Count: Integer;
    function  Get_Item(par_index: OleVariant): IReceivedAttachment;
    function  Get_ItemWithContext(par_index: OleVariant; const par_context: IXMLDOMNode): IReceivedAttachment;
    function  Get__NewEnum: IUnknown;
  public
    property DefaultInterface: IReceivedAttachments read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoDataEncoderFactory30 provides a Create and CreateRemote method to          
// create instances of the default interface IDataEncoderFactory exposed by              
// the CoClass DataEncoderFactory30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDataEncoderFactory30 = class
    class function Create: IDataEncoderFactory;
    class function CreateRemote(const MachineName: string): IDataEncoderFactory;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDataEncoderFactory30
// Help String      : Data Encoder Factory
// Default Interface: IDataEncoderFactory
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDataEncoderFactory30Properties= class;
{$ENDIF}
  TDataEncoderFactory30 = class(TOleServer)
  private
    FIntf:        IDataEncoderFactory;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDataEncoderFactory30Properties;
    function      GetServerProperties: TDataEncoderFactory30Properties;
{$ENDIF}
    function      GetDefaultInterface: IDataEncoderFactory;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDataEncoderFactory);
    procedure Disconnect; override;
    procedure AddDataEncoder(const par_encoding: WideString; const par_encoder: IDataEncoder);
    function  GetDataEncoder(const par_encoding: WideString): IDataEncoder;
    property  DefaultInterface: IDataEncoderFactory read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDataEncoderFactory30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDataEncoderFactory30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDataEncoderFactory30Properties = class(TPersistent)
  private
    FServer:    TDataEncoderFactory30;
    function    GetDefaultInterface: IDataEncoderFactory;
    constructor Create(AServer: TDataEncoderFactory30);
  protected
  public
    property DefaultInterface: IDataEncoderFactory read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoDimeComposer30 provides a Create and CreateRemote method to          
// create instances of the default interface IDimeComposer exposed by              
// the CoClass DimeComposer30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDimeComposer30 = class
    class function Create: IDimeComposer;
    class function CreateRemote(const MachineName: string): IDimeComposer;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDimeComposer30
// Help String      : Dime message composer
// Default Interface: IDimeComposer
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDimeComposer30Properties= class;
{$ENDIF}
  TDimeComposer30 = class(TOleServer)
  private
    FIntf:        IDimeComposer;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDimeComposer30Properties;
    function      GetServerProperties: TDimeComposer30Properties;
{$ENDIF}
    function      GetDefaultInterface: IDimeComposer;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDimeComposer);
    procedure Disconnect; override;
    procedure Initialize(const par_tempFolder: WideString; par_maxSize: Integer; 
                         par_chunkSize: Integer);
    property  DefaultInterface: IDimeComposer read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDimeComposer30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDimeComposer30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDimeComposer30Properties = class(TPersistent)
  private
    FServer:    TDimeComposer30;
    function    GetDefaultInterface: IDimeComposer;
    constructor Create(AServer: TDimeComposer30);
  protected
  public
    property DefaultInterface: IDimeComposer read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoDimeParser30 provides a Create and CreateRemote method to          
// create instances of the default interface IDimeParser exposed by              
// the CoClass DimeParser30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDimeParser30 = class
    class function Create: IDimeParser;
    class function CreateRemote(const MachineName: string): IDimeParser;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDimeParser30
// Help String      : Dime message parser
// Default Interface: IDimeParser
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDimeParser30Properties= class;
{$ENDIF}
  TDimeParser30 = class(TOleServer)
  private
    FIntf:        IDimeParser;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDimeParser30Properties;
    function      GetServerProperties: TDimeParser30Properties;
{$ENDIF}
    function      GetDefaultInterface: IDimeParser;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDimeParser);
    procedure Disconnect; override;
    procedure Initialize(const par_tempFolder: WideString; par_maxSize: Integer);
    property  DefaultInterface: IDimeParser read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDimeParser30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDimeParser30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDimeParser30Properties = class(TPersistent)
  private
    FServer:    TDimeParser30;
    function    GetDefaultInterface: IDimeParser;
    constructor Create(AServer: TDimeParser30);
  protected
  public
    property DefaultInterface: IDimeParser read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSimpleComposer30 provides a Create and CreateRemote method to          
// create instances of the default interface ISimpleComposer exposed by              
// the CoClass SimpleComposer30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSimpleComposer30 = class
    class function Create: ISimpleComposer;
    class function CreateRemote(const MachineName: string): ISimpleComposer;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSimpleComposer30
// Help String      : Simple message composer
// Default Interface: ISimpleComposer
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSimpleComposer30Properties= class;
{$ENDIF}
  TSimpleComposer30 = class(TOleServer)
  private
    FIntf:        ISimpleComposer;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSimpleComposer30Properties;
    function      GetServerProperties: TSimpleComposer30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISimpleComposer;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISimpleComposer);
    procedure Disconnect; override;
    property  DefaultInterface: ISimpleComposer read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSimpleComposer30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSimpleComposer30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSimpleComposer30Properties = class(TPersistent)
  private
    FServer:    TSimpleComposer30;
    function    GetDefaultInterface: ISimpleComposer;
    constructor Create(AServer: TSimpleComposer30);
  protected
  public
    property DefaultInterface: ISimpleComposer read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSimpleParser30 provides a Create and CreateRemote method to          
// create instances of the default interface ISimpleParser exposed by              
// the CoClass SimpleParser30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSimpleParser30 = class
    class function Create: ISimpleParser;
    class function CreateRemote(const MachineName: string): ISimpleParser;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSimpleParser30
// Help String      : Simple message parser
// Default Interface: ISimpleParser
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSimpleParser30Properties= class;
{$ENDIF}
  TSimpleParser30 = class(TOleServer)
  private
    FIntf:        ISimpleParser;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSimpleParser30Properties;
    function      GetServerProperties: TSimpleParser30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISimpleParser;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISimpleParser);
    procedure Disconnect; override;
    property  DefaultInterface: ISimpleParser read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSimpleParser30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSimpleParser30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSimpleParser30Properties = class(TPersistent)
  private
    FServer:    TSimpleParser30;
    function    GetDefaultInterface: ISimpleParser;
    constructor Create(AServer: TSimpleParser30);
  protected
  public
    property DefaultInterface: ISimpleParser read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSoapReader30 provides a Create and CreateRemote method to          
// create instances of the default interface ISoapReader exposed by              
// the CoClass SoapReader30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSoapReader30 = class
    class function Create: ISoapReader;
    class function CreateRemote(const MachineName: string): ISoapReader;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSoapReader30
// Help String      : SoapReader Class
// Default Interface: ISoapReader
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSoapReader30Properties= class;
{$ENDIF}
  TSoapReader30 = class(TOleServer)
  private
    FIntf:        ISoapReader;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSoapReader30Properties;
    function      GetServerProperties: TSoapReader30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISoapReader;
  protected
    procedure InitServerData; override;
    function  Get_Dom: IXMLDOMDocument;
    function  Get_Envelope: IXMLDOMElement;
    function  Get_Body: IXMLDOMElement;
    function  Get_Header: IXMLDOMElement;
    function  Get_Fault: IXMLDOMElement;
    function  Get_FaultString: IXMLDOMElement;
    function  Get_FaultCode: IXMLDOMElement;
    function  Get_FaultActor: IXMLDOMElement;
    function  Get_FaultDetail: IXMLDOMElement;
    function  Get_HeaderEntry(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement;
    function  Get_MustUnderstandHeaderEntries: IXMLDOMNodeList;
    function  Get_HeaderEntries: IXMLDOMNodeList;
    function  Get_BodyEntries: IXMLDOMNodeList;
    function  Get_BodyEntry(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement;
    function  Get_RpcStruct: IXMLDOMElement;
    function  Get_RpcParameter(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement;
    function  Get_RpcResult: IXMLDOMElement;
    function  Get_SoapAction: WideString;
    function  Get_Attachments: IReceivedAttachments;
    function  Get_Parser: IMessageParser;
    procedure Set_XmlVersion(const Param1: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISoapReader);
    procedure Disconnect; override;
    function  Load(par_source: OleVariant; const par_soapAction: WideString): WordBool;
    function  LoadWithParser(par_source: OleVariant; const par_parser: IMessageParser; 
                             const par_soapAction: WideString): WordBool;
    function  LoadXml(const par_xml: WideString): WordBool;
    function  GetContextItem(const par_key: WideString): OleVariant;
    procedure SetContextItem(const par_key: WideString; par_value: OleVariant);
    function  GetReferencedNode(const par_context: IXMLDOMNode): IXMLDOMNode;
    function  GetReferencedAttachment(const par_context: IXMLDOMNode): IReceivedAttachment;
    function  IsAttachmentReference(const par_context: IXMLDOMNode): WordBool;
    function  IsNodeReference(const par_context: IXMLDOMNode): WordBool;
    property  DefaultInterface: ISoapReader read GetDefaultInterface;
    property Dom: IXMLDOMDocument read Get_Dom;
    property Envelope: IXMLDOMElement read Get_Envelope;
    property Body: IXMLDOMElement read Get_Body;
    property Header: IXMLDOMElement read Get_Header;
    property Fault: IXMLDOMElement read Get_Fault;
    property FaultString: IXMLDOMElement read Get_FaultString;
    property FaultCode: IXMLDOMElement read Get_FaultCode;
    property FaultActor: IXMLDOMElement read Get_FaultActor;
    property FaultDetail: IXMLDOMElement read Get_FaultDetail;
    property HeaderEntry[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement read Get_HeaderEntry;
    property MustUnderstandHeaderEntries: IXMLDOMNodeList read Get_MustUnderstandHeaderEntries;
    property HeaderEntries: IXMLDOMNodeList read Get_HeaderEntries;
    property BodyEntries: IXMLDOMNodeList read Get_BodyEntries;
    property BodyEntry[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement read Get_BodyEntry;
    property RpcStruct: IXMLDOMElement read Get_RpcStruct;
    property RpcParameter[const par_LocalName: WideString; const par_NamespaceURI: WideString]: IXMLDOMElement read Get_RpcParameter;
    property RpcResult: IXMLDOMElement read Get_RpcResult;
    property SoapAction: WideString read Get_SoapAction;
    property Attachments: IReceivedAttachments read Get_Attachments;
    property Parser: IMessageParser read Get_Parser;
    property XmlVersion: WideString write Set_XmlVersion;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSoapReader30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSoapReader30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSoapReader30Properties = class(TPersistent)
  private
    FServer:    TSoapReader30;
    function    GetDefaultInterface: ISoapReader;
    constructor Create(AServer: TSoapReader30);
  protected
    function  Get_Dom: IXMLDOMDocument;
    function  Get_Envelope: IXMLDOMElement;
    function  Get_Body: IXMLDOMElement;
    function  Get_Header: IXMLDOMElement;
    function  Get_Fault: IXMLDOMElement;
    function  Get_FaultString: IXMLDOMElement;
    function  Get_FaultCode: IXMLDOMElement;
    function  Get_FaultActor: IXMLDOMElement;
    function  Get_FaultDetail: IXMLDOMElement;
    function  Get_HeaderEntry(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement;
    function  Get_MustUnderstandHeaderEntries: IXMLDOMNodeList;
    function  Get_HeaderEntries: IXMLDOMNodeList;
    function  Get_BodyEntries: IXMLDOMNodeList;
    function  Get_BodyEntry(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement;
    function  Get_RpcStruct: IXMLDOMElement;
    function  Get_RpcParameter(const par_LocalName: WideString; const par_NamespaceURI: WideString): IXMLDOMElement;
    function  Get_RpcResult: IXMLDOMElement;
    function  Get_SoapAction: WideString;
    function  Get_Attachments: IReceivedAttachments;
    function  Get_Parser: IMessageParser;
    procedure Set_XmlVersion(const Param1: WideString);
  public
    property DefaultInterface: ISoapReader read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSoapSerializer30 provides a Create and CreateRemote method to          
// create instances of the default interface ISoapSerializer exposed by              
// the CoClass SoapSerializer30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSoapSerializer30 = class
    class function Create: ISoapSerializer;
    class function CreateRemote(const MachineName: string): ISoapSerializer;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSoapSerializer30
// Help String      : SoapSerializer Class
// Default Interface: ISoapSerializer
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSoapSerializer30Properties= class;
{$ENDIF}
  TSoapSerializer30 = class(TOleServer)
  private
    FIntf:        ISoapSerializer;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSoapSerializer30Properties;
    function      GetServerProperties: TSoapSerializer30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISoapSerializer;
  protected
    procedure InitServerData; override;
    function  Get_SoapFault: WordBool;
    function  Get_Composer: IMessageComposer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISoapSerializer);
    procedure Disconnect; override;
    procedure Init(par_output: OleVariant);
    procedure InitWithComposer(par_output: OleVariant; const par_composer: IMessageComposer);
    procedure StartEnvelope(const par_Prefix: WideString; const par_enc_style_uri: WideString; 
                            const par_encoding: WideString);
    procedure EndEnvelope;
    procedure StartHeader(const par_enc_style_uri: WideString);
    procedure StartHeaderElement(const par_name: WideString; const par_ns_uri: WideString; 
                                 par_mustUnderstand: SYSINT; const par_actor_uri: WideString; 
                                 const par_enc_style_uri: WideString; const par_Prefix: WideString);
    procedure EndHeaderElement;
    procedure EndHeader;
    procedure StartBody(const par_enc_style_uri: WideString);
    procedure EndBody;
    procedure StartElement(const par_name: WideString; const par_ns_uri: WideString; 
                           const par_enc_style_uri: WideString; const par_Prefix: WideString);
    procedure EndElement;
    procedure SoapAttribute(const par_name: WideString; const par_ns_uri: WideString; 
                            const par_value: WideString; const par_Prefix: WideString);
    procedure SoapNamespace(const par_Prefix: WideString; const par_ns_uri: WideString);
    procedure SoapDefaultNamespace(const par_ns_uri: WideString);
    procedure WriteString(const par_string: WideString);
    procedure WriteBuffer(par_len: Integer; var par_buffer: Byte);
    procedure StartFault(const par_FaultCode: WideString; const par_FaultString: WideString; 
                         const par_FaultActor: WideString; const par_FaultCodeNS: WideString);
    procedure StartFaultDetail(const par_enc_style_uri: WideString);
    procedure EndFaultDetail;
    procedure EndFault;
    procedure Reset;
    procedure WriteXml(const par_string: WideString);
    function  GetPrefixForNamespace(const par_ns_string: WideString): WideString;
    procedure EndHrefedElement;
    function  StartHrefedElement(const par_name: WideString; const par_ns_uri: WideString; 
                                 const par_enc_style_uri: WideString; const par_Prefix: WideString; 
                                 par_location: enElementLocation; const par_hrefidinput: WideString): WideString;
    function  GetContextItem(const par_key: WideString): OleVariant;
    procedure SetContextItem(const par_key: WideString; par_value: OleVariant);
    procedure AddAttachment(const par_att: IAttachment);
    procedure AddAttachmentAndReference(const par_att: IAttachment);
    procedure Finished;
    function  CreateHRefId: WideString;
    property  DefaultInterface: ISoapSerializer read GetDefaultInterface;
    property SoapFault: WordBool read Get_SoapFault;
    property Composer: IMessageComposer read Get_Composer;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSoapSerializer30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSoapSerializer30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSoapSerializer30Properties = class(TPersistent)
  private
    FServer:    TSoapSerializer30;
    function    GetDefaultInterface: ISoapSerializer;
    constructor Create(AServer: TSoapSerializer30);
  protected
    function  Get_SoapFault: WordBool;
    function  Get_Composer: IMessageComposer;
  public
    property DefaultInterface: ISoapSerializer read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSoapServer30 provides a Create and CreateRemote method to          
// create instances of the default interface ISoapServer exposed by              
// the CoClass SoapServer30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSoapServer30 = class
    class function Create: ISoapServer;
    class function CreateRemote(const MachineName: string): ISoapServer;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSoapServer30
// Help String      : SoapServer Class
// Default Interface: ISoapServer
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSoapServer30Properties= class;
{$ENDIF}
  TSoapServer30 = class(TOleServer)
  private
    FIntf:        ISoapServer;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSoapServer30Properties;
    function      GetServerProperties: TSoapServer30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISoapServer;
  protected
    procedure InitServerData; override;
    procedure Set_XmlVersion(const Param1: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISoapServer);
    procedure Disconnect; override;
    procedure Init(const par_WSDLFile: WideString; const par_WSMLFile: WideString);
    procedure SoapInvoke(par_Input: OleVariant; const par_OutputStream: IUnknown; 
                         const par_soapAction: WideString);
    procedure SoapInvokeEx(par_Input: OleVariant; const par_OutputStream: IUnknown; 
                           const par_ServerObject: IUnknown; const par_soapAction: WideString; 
                           const par_ContentType: WideString);
    property  DefaultInterface: ISoapServer read GetDefaultInterface;
    property XmlVersion: WideString write Set_XmlVersion;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSoapServer30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSoapServer30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSoapServer30Properties = class(TPersistent)
  private
    FServer:    TSoapServer30;
    function    GetDefaultInterface: ISoapServer;
    constructor Create(AServer: TSoapServer30);
  protected
    procedure Set_XmlVersion(const Param1: WideString);
  public
    property DefaultInterface: ISoapServer read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSoapClient30 provides a Create and CreateRemote method to          
// create instances of the default interface ISoapClient exposed by              
// the CoClass SoapClient30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSoapClient30 = class
    class function Create: ISoapClient;
    class function CreateRemote(const MachineName: string): ISoapClient;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSoapClient30
// Help String      : SoapClient Class
// Default Interface: ISoapClient
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSoapClient30Properties= class;
{$ENDIF}
  TSoapClient30 = class(TOleServer)
  private
    FIntf:        ISoapClient;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSoapClient30Properties;
    function      GetServerProperties: TSoapClient30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISoapClient;
  protected
    procedure InitServerData; override;
    function  Get_FaultCode: WideString;
    function  Get_FaultString: WideString;
    function  Get_FaultActor: WideString;
    function  Get_Detail: WideString;
    function  Get_ClientProperty(const par_PropertyName: WideString): OleVariant;
    procedure Set_HeaderHandler(const Param1: IDispatch);
    procedure _Set_ClientProperty(const par_PropertyName: WideString; par_PropertyValue: OleVariant);
    function  Get_ConnectorProperty(const par_PropertyName: WideString): OleVariant;
    procedure Set_ConnectorProperty(const par_PropertyName: WideString; 
                                    par_PropertyValue: OleVariant);
    function  Get_FaultCodeNamespace: WideString;
    procedure Set_ClientProperty(const par_PropertyName: WideString; par_PropertyValue: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISoapClient);
    procedure Disconnect; override;
    procedure MSSoapInit(const par_WSDLFile: WideString; const par_ServiceName: WideString; 
                         const par_Port: WideString; const par_WSMLFile: WideString);
    procedure MSSoapInit2(par_WSDLFile: OleVariant; par_WSMLFile: OleVariant; 
                          const par_ServiceName: WideString; const par_Port: WideString; 
                          const par_Namespace: WideString);
    property  DefaultInterface: ISoapClient read GetDefaultInterface;
    property FaultCode: WideString read Get_FaultCode;
    property FaultString: WideString read Get_FaultString;
    property FaultActor: WideString read Get_FaultActor;
    property Detail: WideString read Get_Detail;
    property ClientProperty[const par_PropertyName: WideString]: OleVariant read Get_ClientProperty write Set_ClientProperty;
    property HeaderHandler: IDispatch write Set_HeaderHandler;
    property ConnectorProperty[const par_PropertyName: WideString]: OleVariant read Get_ConnectorProperty write Set_ConnectorProperty;
    property FaultCodeNamespace: WideString read Get_FaultCodeNamespace;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSoapClient30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSoapClient30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSoapClient30Properties = class(TPersistent)
  private
    FServer:    TSoapClient30;
    function    GetDefaultInterface: ISoapClient;
    constructor Create(AServer: TSoapClient30);
  protected
    function  Get_FaultCode: WideString;
    function  Get_FaultString: WideString;
    function  Get_FaultActor: WideString;
    function  Get_Detail: WideString;
    function  Get_ClientProperty(const par_PropertyName: WideString): OleVariant;
    procedure Set_HeaderHandler(const Param1: IDispatch);
    procedure _Set_ClientProperty(const par_PropertyName: WideString; par_PropertyValue: OleVariant);
    function  Get_ConnectorProperty(const par_PropertyName: WideString): OleVariant;
    procedure Set_ConnectorProperty(const par_PropertyName: WideString; 
                                    par_PropertyValue: OleVariant);
    function  Get_FaultCodeNamespace: WideString;
    procedure Set_ClientProperty(const par_PropertyName: WideString; par_PropertyValue: OleVariant);
  public
    property DefaultInterface: ISoapClient read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoWSDLReader30 provides a Create and CreateRemote method to          
// create instances of the default interface IWSDLReader exposed by              
// the CoClass WSDLReader30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoWSDLReader30 = class
    class function Create: IWSDLReader;
    class function CreateRemote(const MachineName: string): IWSDLReader;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TWSDLReader30
// Help String      : WSDLReader Class
// Default Interface: IWSDLReader
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TWSDLReader30Properties= class;
{$ENDIF}
  TWSDLReader30 = class(TOleServer)
  private
    FIntf:        IWSDLReader;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TWSDLReader30Properties;
    function      GetServerProperties: TWSDLReader30Properties;
{$ENDIF}
    function      GetDefaultInterface: IWSDLReader;
  protected
    procedure InitServerData; override;
    function  Get_TypeFactory(out par_Factory: ISoapTypeMapperFactory): HResult;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IWSDLReader);
    procedure Disconnect; override;
    function  Load(const par_WSDLFile: WideString; const par_WSMLFile: WideString): HResult;
    function  Load2(par_WSDLFile: OleVariant; par_WSMLFile: OleVariant; 
                    const par_StartingNamespace: WideString): HResult;
    function  GetSoapServices(out par_IWSDLServiceEnum: IEnumWSDLService): HResult;
    function  ParseRequest(const par_ISoapReader: ISoapReader; out par_IWSDLPort: IWSDLPort; 
                           out par_IWSDLOperation: IWSDLOperation): HResult;
    function  SetProperty(const par_PropertyName: WideString; par_PropValue: OleVariant): HResult;
    property  DefaultInterface: IWSDLReader read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TWSDLReader30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TWSDLReader30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TWSDLReader30Properties = class(TPersistent)
  private
    FServer:    TWSDLReader30;
    function    GetDefaultInterface: IWSDLReader;
    constructor Create(AServer: TWSDLReader30);
  protected
    function  Get_TypeFactory(out par_Factory: ISoapTypeMapperFactory): HResult;
  public
    property DefaultInterface: IWSDLReader read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSoapTypeMapperFactory30 provides a Create and CreateRemote method to          
// create instances of the default interface ISoapTypeMapperFactory exposed by              
// the CoClass SoapTypeMapperFactory30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSoapTypeMapperFactory30 = class
    class function Create: ISoapTypeMapperFactory;
    class function CreateRemote(const MachineName: string): ISoapTypeMapperFactory;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSoapTypeMapperFactory30
// Help String      : Typemapperfactory Class
// Default Interface: ISoapTypeMapperFactory
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSoapTypeMapperFactory30Properties= class;
{$ENDIF}
  TSoapTypeMapperFactory30 = class(TOleServer)
  private
    FIntf:        ISoapTypeMapperFactory;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSoapTypeMapperFactory30Properties;
    function      GetServerProperties: TSoapTypeMapperFactory30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISoapTypeMapperFactory;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISoapTypeMapperFactory);
    procedure Disconnect; override;
    procedure AddSchema(const par_SchemaNode: IXMLDOMNode);
    function  GetElementMapperByName(const par_ElementName: WideString; 
                                     const par_ElementNamespace: WideString): ISoapTypeMapper;
    function  GetTypeMapperByName(const par_TypeName: WideString; 
                                  const par_TypeNamespace: WideString): ISoapTypeMapper;
    function  GetElementMapper(const par_ElementNode: IXMLDOMNode): ISoapTypeMapper;
    function  GetTypeMapper(const par_TypeNode: IXMLDOMNode): ISoapTypeMapper;
    procedure AddType(const par_TypeName: WideString; const par_TypeNamespace: WideString; 
                      const par_ProgID: WideString; const par_IID: WideString);
    procedure AddElement(const par_ElementName: WideString; const par_ElementNamespace: WideString; 
                         const par_ProgID: WideString; const par_IID: WideString);
    function  GetMapper(par_xsdType: enXSDType; const par_SchemaNode: IXMLDOMNode): ISoapTypeMapper;
    procedure AddCustomMapper(const par_ProgID: WideString; const par_WSMLNode: IXMLDOMNode);
    function  GetDefinitionsNode(const par_BaseName: WideString; const par_Namespace: WideString; 
                                 par_LookForElement: WordBool): IXMLDOMNode;
    property  DefaultInterface: ISoapTypeMapperFactory read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSoapTypeMapperFactory30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSoapTypeMapperFactory30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSoapTypeMapperFactory30Properties = class(TPersistent)
  private
    FServer:    TSoapTypeMapperFactory30;
    function    GetDefaultInterface: ISoapTypeMapperFactory;
    constructor Create(AServer: TSoapTypeMapperFactory30);
  protected
  public
    property DefaultInterface: ISoapTypeMapperFactory read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGenericCustomTypeMapper30 provides a Create and CreateRemote method to          
// create instances of the default interface IDispatch exposed by              
// the CoClass GenericCustomTypeMapper30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGenericCustomTypeMapper30 = class
    class function Create: IDispatch;
    class function CreateRemote(const MachineName: string): IDispatch;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGenericCustomTypeMapper30
// Help String      : GenericCustomTypeMapper Class
// Default Interface: IDispatch
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGenericCustomTypeMapper30Properties= class;
{$ENDIF}
  TGenericCustomTypeMapper30 = class(TOleServer)
  private
    FIntf:        IDispatch;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TGenericCustomTypeMapper30Properties;
    function      GetServerProperties: TGenericCustomTypeMapper30Properties;
{$ENDIF}
    function      GetDefaultInterface: IDispatch;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDispatch);
    procedure Disconnect; override;
    property  DefaultInterface: IDispatch read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGenericCustomTypeMapper30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGenericCustomTypeMapper30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGenericCustomTypeMapper30Properties = class(TPersistent)
  private
    FServer:    TGenericCustomTypeMapper30;
    function    GetDefaultInterface: IDispatch;
    constructor Create(AServer: TGenericCustomTypeMapper30);
  protected
  public
    property DefaultInterface: IDispatch read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoUDTMapper30 provides a Create and CreateRemote method to          
// create instances of the default interface IDispatch exposed by              
// the CoClass UDTMapper30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoUDTMapper30 = class
    class function Create: IDispatch;
    class function CreateRemote(const MachineName: string): IDispatch;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TUDTMapper30
// Help String      : UDTMapper Class
// Default Interface: IDispatch
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TUDTMapper30Properties= class;
{$ENDIF}
  TUDTMapper30 = class(TOleServer)
  private
    FIntf:        IDispatch;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TUDTMapper30Properties;
    function      GetServerProperties: TUDTMapper30Properties;
{$ENDIF}
    function      GetDefaultInterface: IDispatch;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDispatch);
    procedure Disconnect; override;
    property  DefaultInterface: IDispatch read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TUDTMapper30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TUDTMapper30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TUDTMapper30Properties = class(TPersistent)
  private
    FServer:    TUDTMapper30;
    function    GetDefaultInterface: IDispatch;
    constructor Create(AServer: TUDTMapper30);
  protected
  public
    property DefaultInterface: IDispatch read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSoapConnector30 provides a Create and CreateRemote method to          
// create instances of the default interface ISoapConnector exposed by              
// the CoClass SoapConnector30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSoapConnector30 = class
    class function Create: ISoapConnector;
    class function CreateRemote(const MachineName: string): ISoapConnector;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSoapConnector30
// Help String      : SoapConnector Class
// Default Interface: ISoapConnector
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSoapConnector30Properties= class;
{$ENDIF}
  TSoapConnector30 = class(TOleServer)
  private
    FIntf:        ISoapConnector;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSoapConnector30Properties;
    function      GetServerProperties: TSoapConnector30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISoapConnector;
  protected
    procedure InitServerData; override;
    function  Get_InputStream: IStream;
    function  Get_OutputStream: IStream;
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISoapConnector);
    procedure Disconnect; override;
    procedure ConnectWSDL(const par_Port: IWSDLPort);
    procedure BeginMessageWSDL(const par_operation: IWSDLOperation);
    procedure EndMessage;
    procedure Reset;
    procedure Connect1;
    procedure BeginMessage;
    property  DefaultInterface: ISoapConnector read GetDefaultInterface;
    property InputStream: IStream read Get_InputStream;
    property OutputStream: IStream read Get_OutputStream;
    property Property_[const par_name: WideString]: OleVariant read Get_Property_ write Set_Property_;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSoapConnector30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSoapConnector30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSoapConnector30Properties = class(TPersistent)
  private
    FServer:    TSoapConnector30;
    function    GetDefaultInterface: ISoapConnector;
    constructor Create(AServer: TSoapConnector30);
  protected
    function  Get_InputStream: IStream;
    function  Get_OutputStream: IStream;
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
  public
    property DefaultInterface: ISoapConnector read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSoapConnectorFactory30 provides a Create and CreateRemote method to          
// create instances of the default interface ISoapConnectorFactory exposed by              
// the CoClass SoapConnectorFactory30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSoapConnectorFactory30 = class
    class function Create: ISoapConnectorFactory;
    class function CreateRemote(const MachineName: string): ISoapConnectorFactory;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSoapConnectorFactory30
// Help String      : Soap Connector Factory Class
// Default Interface: ISoapConnectorFactory
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSoapConnectorFactory30Properties= class;
{$ENDIF}
  TSoapConnectorFactory30 = class(TOleServer)
  private
    FIntf:        ISoapConnectorFactory;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSoapConnectorFactory30Properties;
    function      GetServerProperties: TSoapConnectorFactory30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISoapConnectorFactory;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISoapConnectorFactory);
    procedure Disconnect; override;
    function  CreatePortConnector(const par_Port: IWSDLPort): ISoapConnector;
    property  DefaultInterface: ISoapConnectorFactory read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSoapConnectorFactory30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSoapConnectorFactory30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSoapConnectorFactory30Properties = class(TPersistent)
  private
    FServer:    TSoapConnectorFactory30;
    function    GetDefaultInterface: ISoapConnectorFactory;
    constructor Create(AServer: TSoapConnectorFactory30);
  protected
  public
    property DefaultInterface: ISoapConnectorFactory read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoHttpConnector30 provides a Create and CreateRemote method to          
// create instances of the default interface ISoapConnector exposed by              
// the CoClass HttpConnector30. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoHttpConnector30 = class
    class function Create: ISoapConnector;
    class function CreateRemote(const MachineName: string): ISoapConnector;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : THttpConnector30
// Help String      : Soap Http Connector Class
// Default Interface: ISoapConnector
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  THttpConnector30Properties= class;
{$ENDIF}
  THttpConnector30 = class(TOleServer)
  private
    FIntf:        ISoapConnector;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       THttpConnector30Properties;
    function      GetServerProperties: THttpConnector30Properties;
{$ENDIF}
    function      GetDefaultInterface: ISoapConnector;
  protected
    procedure InitServerData; override;
    function  Get_InputStream: IStream;
    function  Get_OutputStream: IStream;
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISoapConnector);
    procedure Disconnect; override;
    procedure ConnectWSDL(const par_Port: IWSDLPort);
    procedure BeginMessageWSDL(const par_operation: IWSDLOperation);
    procedure EndMessage;
    procedure Reset;
    procedure Connect1;
    procedure BeginMessage;
    property  DefaultInterface: ISoapConnector read GetDefaultInterface;
    property InputStream: IStream read Get_InputStream;
    property OutputStream: IStream read Get_OutputStream;
    property Property_[const par_name: WideString]: OleVariant read Get_Property_ write Set_Property_;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: THttpConnector30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : THttpConnector30
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 THttpConnector30Properties = class(TPersistent)
  private
    FServer:    THttpConnector30;
    function    GetDefaultInterface: ISoapConnector;
    constructor Create(AServer: THttpConnector30);
  protected
    function  Get_InputStream: IStream;
    function  Get_OutputStream: IStream;
    function  Get_Property_(const par_name: WideString): OleVariant;
    procedure Set_Property_(const par_name: WideString; par_value: OleVariant);
  public
    property DefaultInterface: ISoapConnector read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

implementation

uses ComObj;

class function CoFileAttachment30.Create: IFileAttachment;
begin
  Result := CreateComObject(CLASS_FileAttachment30) as IFileAttachment;
end;

class function CoFileAttachment30.CreateRemote(const MachineName: string): IFileAttachment;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FileAttachment30) as IFileAttachment;
end;

procedure TFileAttachment30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{90A299F3-26C6-457D-A514-404335109EDD}';
    IntfIID:   '{D6DEA9EB-28EA-45C7-A46A-72D26668C1EA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFileAttachment30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFileAttachment;
  end;
end;

procedure TFileAttachment30.ConnectTo(svrIntf: IFileAttachment);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFileAttachment30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFileAttachment30.GetDefaultInterface: IFileAttachment;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TFileAttachment30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFileAttachment30Properties.Create(Self);
{$ENDIF}
end;

destructor TFileAttachment30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFileAttachment30.GetServerProperties: TFileAttachment30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TFileAttachment30.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TFileAttachment30.Set_Property_(const par_name: WideString; par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

function  TFileAttachment30.Get_FileName: WideString;
begin
  Result := DefaultInterface.Get_FileName;
end;

procedure TFileAttachment30.Set_FileName(const par_value: WideString);
begin
  DefaultInterface.Set_FileName(par_value);
end;

procedure TFileAttachment30.Set_DeleteAfterSending(par_value: WordBool);
begin
  DefaultInterface.Set_DeleteAfterSending(par_value);
end;

function  TFileAttachment30.Get_DeleteAfterSending: WordBool;
begin
  Result := DefaultInterface.Get_DeleteAfterSending;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFileAttachment30Properties.Create(AServer: TFileAttachment30);
begin
  inherited Create;
  FServer := AServer;
end;

function TFileAttachment30Properties.GetDefaultInterface: IFileAttachment;
begin
  Result := FServer.DefaultInterface;
end;

function  TFileAttachment30Properties.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TFileAttachment30Properties.Set_Property_(const par_name: WideString; 
                                                    par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

function  TFileAttachment30Properties.Get_FileName: WideString;
begin
  Result := DefaultInterface.Get_FileName;
end;

procedure TFileAttachment30Properties.Set_FileName(const par_value: WideString);
begin
  DefaultInterface.Set_FileName(par_value);
end;

procedure TFileAttachment30Properties.Set_DeleteAfterSending(par_value: WordBool);
begin
  DefaultInterface.Set_DeleteAfterSending(par_value);
end;

function  TFileAttachment30Properties.Get_DeleteAfterSending: WordBool;
begin
  Result := DefaultInterface.Get_DeleteAfterSending;
end;

{$ENDIF}

class function CoStringAttachment30.Create: IStringAttachment;
begin
  Result := CreateComObject(CLASS_StringAttachment30) as IStringAttachment;
end;

class function CoStringAttachment30.CreateRemote(const MachineName: string): IStringAttachment;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_StringAttachment30) as IStringAttachment;
end;

procedure TStringAttachment30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{722C5A81-4FEC-43F7-8656-E16EC6853073}';
    IntfIID:   '{8004A743-6A1E-45E4-B2E2-A6D117F06008}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TStringAttachment30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStringAttachment;
  end;
end;

procedure TStringAttachment30.ConnectTo(svrIntf: IStringAttachment);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TStringAttachment30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TStringAttachment30.GetDefaultInterface: IStringAttachment;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TStringAttachment30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TStringAttachment30Properties.Create(Self);
{$ENDIF}
end;

destructor TStringAttachment30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TStringAttachment30.GetServerProperties: TStringAttachment30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TStringAttachment30.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TStringAttachment30.Set_Property_(const par_name: WideString; par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

function  TStringAttachment30.Get_String_: WideString;
begin
  Result := DefaultInterface.Get_String_;
end;

procedure TStringAttachment30.Set_String_(const par_value: WideString);
begin
  DefaultInterface.Set_String_(par_value);
end;

function  TStringAttachment30.Get_ContentCharacterSet: WideString;
begin
  Result := DefaultInterface.Get_ContentCharacterSet;
end;

procedure TStringAttachment30.Set_ContentCharacterSet(const par_value: WideString);
begin
  DefaultInterface.Set_ContentCharacterSet(par_value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TStringAttachment30Properties.Create(AServer: TStringAttachment30);
begin
  inherited Create;
  FServer := AServer;
end;

function TStringAttachment30Properties.GetDefaultInterface: IStringAttachment;
begin
  Result := FServer.DefaultInterface;
end;

function  TStringAttachment30Properties.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TStringAttachment30Properties.Set_Property_(const par_name: WideString; 
                                                      par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

function  TStringAttachment30Properties.Get_String_: WideString;
begin
  Result := DefaultInterface.Get_String_;
end;

procedure TStringAttachment30Properties.Set_String_(const par_value: WideString);
begin
  DefaultInterface.Set_String_(par_value);
end;

function  TStringAttachment30Properties.Get_ContentCharacterSet: WideString;
begin
  Result := DefaultInterface.Get_ContentCharacterSet;
end;

procedure TStringAttachment30Properties.Set_ContentCharacterSet(const par_value: WideString);
begin
  DefaultInterface.Set_ContentCharacterSet(par_value);
end;

{$ENDIF}

class function CoByteArrayAttachment30.Create: IByteArrayAttachment;
begin
  Result := CreateComObject(CLASS_ByteArrayAttachment30) as IByteArrayAttachment;
end;

class function CoByteArrayAttachment30.CreateRemote(const MachineName: string): IByteArrayAttachment;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ByteArrayAttachment30) as IByteArrayAttachment;
end;

procedure TByteArrayAttachment30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{565FBBE9-8563-4302-BE8A-7C6A64FB0A85}';
    IntfIID:   '{52088645-8E96-4C18-8621-B46611635303}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TByteArrayAttachment30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IByteArrayAttachment;
  end;
end;

procedure TByteArrayAttachment30.ConnectTo(svrIntf: IByteArrayAttachment);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TByteArrayAttachment30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TByteArrayAttachment30.GetDefaultInterface: IByteArrayAttachment;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TByteArrayAttachment30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TByteArrayAttachment30Properties.Create(Self);
{$ENDIF}
end;

destructor TByteArrayAttachment30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TByteArrayAttachment30.GetServerProperties: TByteArrayAttachment30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TByteArrayAttachment30.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TByteArrayAttachment30.Set_Property_(const par_name: WideString; par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

function  TByteArrayAttachment30.Get_Array_: OleVariant;
begin
  Result := DefaultInterface.Get_Array_;
end;

procedure TByteArrayAttachment30.Set_Array_(par_value: OleVariant);
begin
  DefaultInterface.Set_Array_(par_value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TByteArrayAttachment30Properties.Create(AServer: TByteArrayAttachment30);
begin
  inherited Create;
  FServer := AServer;
end;

function TByteArrayAttachment30Properties.GetDefaultInterface: IByteArrayAttachment;
begin
  Result := FServer.DefaultInterface;
end;

function  TByteArrayAttachment30Properties.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TByteArrayAttachment30Properties.Set_Property_(const par_name: WideString; 
                                                         par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

function  TByteArrayAttachment30Properties.Get_Array_: OleVariant;
begin
  Result := DefaultInterface.Get_Array_;
end;

procedure TByteArrayAttachment30Properties.Set_Array_(par_value: OleVariant);
begin
  DefaultInterface.Set_Array_(par_value);
end;

{$ENDIF}

class function CoStreamAttachment30.Create: IStreamAttachment;
begin
  Result := CreateComObject(CLASS_StreamAttachment30) as IStreamAttachment;
end;

class function CoStreamAttachment30.CreateRemote(const MachineName: string): IStreamAttachment;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_StreamAttachment30) as IStreamAttachment;
end;

procedure TStreamAttachment30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{05AE7FB3-C4E9-4F79-A5C3-DAB525E31F2C}';
    IntfIID:   '{BE1DBCF5-2260-470A-8E1C-E2406D106E0A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TStreamAttachment30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStreamAttachment;
  end;
end;

procedure TStreamAttachment30.ConnectTo(svrIntf: IStreamAttachment);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TStreamAttachment30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TStreamAttachment30.GetDefaultInterface: IStreamAttachment;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TStreamAttachment30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TStreamAttachment30Properties.Create(Self);
{$ENDIF}
end;

destructor TStreamAttachment30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TStreamAttachment30.GetServerProperties: TStreamAttachment30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TStreamAttachment30.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TStreamAttachment30.Set_Property_(const par_name: WideString; par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

function  TStreamAttachment30.Get_Stream: IStream;
begin
  Result := DefaultInterface.Get_Stream;
end;

procedure TStreamAttachment30.Set_Stream(const par_value: IStream);
begin
  DefaultInterface.Set_Stream(par_value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TStreamAttachment30Properties.Create(AServer: TStreamAttachment30);
begin
  inherited Create;
  FServer := AServer;
end;

function TStreamAttachment30Properties.GetDefaultInterface: IStreamAttachment;
begin
  Result := FServer.DefaultInterface;
end;

function  TStreamAttachment30Properties.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TStreamAttachment30Properties.Set_Property_(const par_name: WideString; 
                                                      par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

function  TStreamAttachment30Properties.Get_Stream: IStream;
begin
  Result := DefaultInterface.Get_Stream;
end;

procedure TStreamAttachment30Properties.Set_Stream(const par_value: IStream);
begin
  DefaultInterface.Set_Stream(par_value);
end;

{$ENDIF}

class function CoSentAttachments30.Create: ISentAttachments;
begin
  Result := CreateComObject(CLASS_SentAttachments30) as ISentAttachments;
end;

class function CoSentAttachments30.CreateRemote(const MachineName: string): ISentAttachments;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SentAttachments30) as ISentAttachments;
end;

procedure TSentAttachments30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{CE071800-E681-4ADF-9422-A3D0BD0D51CB}';
    IntfIID:   '{95A098C0-EB61-4895-91C7-78873251322E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSentAttachments30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISentAttachments;
  end;
end;

procedure TSentAttachments30.ConnectTo(svrIntf: ISentAttachments);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSentAttachments30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSentAttachments30.GetDefaultInterface: ISentAttachments;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSentAttachments30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSentAttachments30Properties.Create(Self);
{$ENDIF}
end;

destructor TSentAttachments30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSentAttachments30.GetServerProperties: TSentAttachments30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TSentAttachments30.Get_Count: Integer;
begin
  Result := DefaultInterface.Get_Count;
end;

function  TSentAttachments30.Get_Item(par_index: Integer): IAttachment;
begin
  Result := DefaultInterface.Get_Item(par_index);
end;

procedure TSentAttachments30.Add(const par_att: IAttachment);
begin
  DefaultInterface.Add(par_att);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSentAttachments30Properties.Create(AServer: TSentAttachments30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSentAttachments30Properties.GetDefaultInterface: ISentAttachments;
begin
  Result := FServer.DefaultInterface;
end;

function  TSentAttachments30Properties.Get_Count: Integer;
begin
  Result := DefaultInterface.Get_Count;
end;

function  TSentAttachments30Properties.Get_Item(par_index: Integer): IAttachment;
begin
  Result := DefaultInterface.Get_Item(par_index);
end;

{$ENDIF}

class function CoReceivedAttachments30.Create: IReceivedAttachments;
begin
  Result := CreateComObject(CLASS_ReceivedAttachments30) as IReceivedAttachments;
end;

class function CoReceivedAttachments30.CreateRemote(const MachineName: string): IReceivedAttachments;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ReceivedAttachments30) as IReceivedAttachments;
end;

procedure TReceivedAttachments30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{AF9B6377-6505-4934-AD85-BAB87E15EF65}';
    IntfIID:   '{176B81CD-4F22-4CA0-9F54-9FE5935A595B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TReceivedAttachments30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IReceivedAttachments;
  end;
end;

procedure TReceivedAttachments30.ConnectTo(svrIntf: IReceivedAttachments);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TReceivedAttachments30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TReceivedAttachments30.GetDefaultInterface: IReceivedAttachments;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TReceivedAttachments30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TReceivedAttachments30Properties.Create(Self);
{$ENDIF}
end;

destructor TReceivedAttachments30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TReceivedAttachments30.GetServerProperties: TReceivedAttachments30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TReceivedAttachments30.Get_Count: Integer;
begin
  Result := DefaultInterface.Get_Count;
end;

function  TReceivedAttachments30.Get_Item(par_index: OleVariant): IReceivedAttachment;
begin
  Result := DefaultInterface.Get_Item(par_index);
end;

function  TReceivedAttachments30.Get_ItemWithContext(par_index: OleVariant; 
                                                     const par_context: IXMLDOMNode): IReceivedAttachment;
begin
  Result := DefaultInterface.Get_ItemWithContext(par_index, par_context);
end;

function  TReceivedAttachments30.Get__NewEnum: IUnknown;
begin
  Result := DefaultInterface.Get__NewEnum;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TReceivedAttachments30Properties.Create(AServer: TReceivedAttachments30);
begin
  inherited Create;
  FServer := AServer;
end;

function TReceivedAttachments30Properties.GetDefaultInterface: IReceivedAttachments;
begin
  Result := FServer.DefaultInterface;
end;

function  TReceivedAttachments30Properties.Get_Count: Integer;
begin
  Result := DefaultInterface.Get_Count;
end;

function  TReceivedAttachments30Properties.Get_Item(par_index: OleVariant): IReceivedAttachment;
begin
  Result := DefaultInterface.Get_Item(par_index);
end;

function  TReceivedAttachments30Properties.Get_ItemWithContext(par_index: OleVariant; 
                                                               const par_context: IXMLDOMNode): IReceivedAttachment;
begin
  Result := DefaultInterface.Get_ItemWithContext(par_index, par_context);
end;

function  TReceivedAttachments30Properties.Get__NewEnum: IUnknown;
begin
  Result := DefaultInterface.Get__NewEnum;
end;

{$ENDIF}

class function CoDataEncoderFactory30.Create: IDataEncoderFactory;
begin
  Result := CreateComObject(CLASS_DataEncoderFactory30) as IDataEncoderFactory;
end;

class function CoDataEncoderFactory30.CreateRemote(const MachineName: string): IDataEncoderFactory;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DataEncoderFactory30) as IDataEncoderFactory;
end;

procedure TDataEncoderFactory30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{7A51A663-4790-4885-B0E4-124D4BDADB3E}';
    IntfIID:   '{456C5AB4-2A2A-4289-9D4C-0C28BF739EE4}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDataEncoderFactory30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDataEncoderFactory;
  end;
end;

procedure TDataEncoderFactory30.ConnectTo(svrIntf: IDataEncoderFactory);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDataEncoderFactory30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDataEncoderFactory30.GetDefaultInterface: IDataEncoderFactory;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TDataEncoderFactory30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDataEncoderFactory30Properties.Create(Self);
{$ENDIF}
end;

destructor TDataEncoderFactory30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDataEncoderFactory30.GetServerProperties: TDataEncoderFactory30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TDataEncoderFactory30.AddDataEncoder(const par_encoding: WideString; 
                                               const par_encoder: IDataEncoder);
begin
  DefaultInterface.AddDataEncoder(par_encoding, par_encoder);
end;

function  TDataEncoderFactory30.GetDataEncoder(const par_encoding: WideString): IDataEncoder;
begin
  Result := DefaultInterface.GetDataEncoder(par_encoding);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDataEncoderFactory30Properties.Create(AServer: TDataEncoderFactory30);
begin
  inherited Create;
  FServer := AServer;
end;

function TDataEncoderFactory30Properties.GetDefaultInterface: IDataEncoderFactory;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoDimeComposer30.Create: IDimeComposer;
begin
  Result := CreateComObject(CLASS_DimeComposer30) as IDimeComposer;
end;

class function CoDimeComposer30.CreateRemote(const MachineName: string): IDimeComposer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DimeComposer30) as IDimeComposer;
end;

procedure TDimeComposer30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B85E6E71-1493-442F-BC97-B511BE0D5D96}';
    IntfIID:   '{ABAADE34-EEF6-408A-8896-65BE669D27FA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDimeComposer30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDimeComposer;
  end;
end;

procedure TDimeComposer30.ConnectTo(svrIntf: IDimeComposer);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDimeComposer30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDimeComposer30.GetDefaultInterface: IDimeComposer;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TDimeComposer30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDimeComposer30Properties.Create(Self);
{$ENDIF}
end;

destructor TDimeComposer30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDimeComposer30.GetServerProperties: TDimeComposer30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TDimeComposer30.Initialize(const par_tempFolder: WideString; par_maxSize: Integer; 
                                     par_chunkSize: Integer);
begin
  DefaultInterface.Initialize(par_tempFolder, par_maxSize, par_chunkSize);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDimeComposer30Properties.Create(AServer: TDimeComposer30);
begin
  inherited Create;
  FServer := AServer;
end;

function TDimeComposer30Properties.GetDefaultInterface: IDimeComposer;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoDimeParser30.Create: IDimeParser;
begin
  Result := CreateComObject(CLASS_DimeParser30) as IDimeParser;
end;

class function CoDimeParser30.CreateRemote(const MachineName: string): IDimeParser;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DimeParser30) as IDimeParser;
end;

procedure TDimeParser30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{DFC2FA0B-CC72-4486-B9F4-06FE8A75D58F}';
    IntfIID:   '{E3F8BAA5-8A05-4641-91CE-3FBC533D1EDB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDimeParser30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDimeParser;
  end;
end;

procedure TDimeParser30.ConnectTo(svrIntf: IDimeParser);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDimeParser30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDimeParser30.GetDefaultInterface: IDimeParser;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TDimeParser30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDimeParser30Properties.Create(Self);
{$ENDIF}
end;

destructor TDimeParser30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDimeParser30.GetServerProperties: TDimeParser30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TDimeParser30.Initialize(const par_tempFolder: WideString; par_maxSize: Integer);
begin
  DefaultInterface.Initialize(par_tempFolder, par_maxSize);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDimeParser30Properties.Create(AServer: TDimeParser30);
begin
  inherited Create;
  FServer := AServer;
end;

function TDimeParser30Properties.GetDefaultInterface: IDimeParser;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSimpleComposer30.Create: ISimpleComposer;
begin
  Result := CreateComObject(CLASS_SimpleComposer30) as ISimpleComposer;
end;

class function CoSimpleComposer30.CreateRemote(const MachineName: string): ISimpleComposer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SimpleComposer30) as ISimpleComposer;
end;

procedure TSimpleComposer30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F7E00C3F-D6C7-4E53-9887-61A2D4EBF0E8}';
    IntfIID:   '{70824404-7A18-412A-9A83-A9EC0F3FF045}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSimpleComposer30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISimpleComposer;
  end;
end;

procedure TSimpleComposer30.ConnectTo(svrIntf: ISimpleComposer);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSimpleComposer30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSimpleComposer30.GetDefaultInterface: ISimpleComposer;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSimpleComposer30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSimpleComposer30Properties.Create(Self);
{$ENDIF}
end;

destructor TSimpleComposer30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSimpleComposer30.GetServerProperties: TSimpleComposer30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSimpleComposer30Properties.Create(AServer: TSimpleComposer30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSimpleComposer30Properties.GetDefaultInterface: ISimpleComposer;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSimpleParser30.Create: ISimpleParser;
begin
  Result := CreateComObject(CLASS_SimpleParser30) as ISimpleParser;
end;

class function CoSimpleParser30.CreateRemote(const MachineName: string): ISimpleParser;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SimpleParser30) as ISimpleParser;
end;

procedure TSimpleParser30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4D602A27-DC39-45D6-A6B1-7003DE2E173C}';
    IntfIID:   '{B313A227-0798-4A87-9074-48CA2164D0F7}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSimpleParser30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISimpleParser;
  end;
end;

procedure TSimpleParser30.ConnectTo(svrIntf: ISimpleParser);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSimpleParser30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSimpleParser30.GetDefaultInterface: ISimpleParser;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSimpleParser30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSimpleParser30Properties.Create(Self);
{$ENDIF}
end;

destructor TSimpleParser30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSimpleParser30.GetServerProperties: TSimpleParser30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSimpleParser30Properties.Create(AServer: TSimpleParser30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSimpleParser30Properties.GetDefaultInterface: ISimpleParser;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSoapReader30.Create: ISoapReader;
begin
  Result := CreateComObject(CLASS_SoapReader30) as ISoapReader;
end;

class function CoSoapReader30.CreateRemote(const MachineName: string): ISoapReader;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SoapReader30) as ISoapReader;
end;

procedure TSoapReader30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A8D986B6-9257-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{B21F31CA-0F45-4046-A231-CFB386E9E45F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSoapReader30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISoapReader;
  end;
end;

procedure TSoapReader30.ConnectTo(svrIntf: ISoapReader);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSoapReader30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSoapReader30.GetDefaultInterface: ISoapReader;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSoapReader30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSoapReader30Properties.Create(Self);
{$ENDIF}
end;

destructor TSoapReader30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSoapReader30.GetServerProperties: TSoapReader30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TSoapReader30.Get_Dom: IXMLDOMDocument;
begin
  Result := DefaultInterface.Get_Dom;
end;

function  TSoapReader30.Get_Envelope: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_Envelope;
end;

function  TSoapReader30.Get_Body: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_Body;
end;

function  TSoapReader30.Get_Header: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_Header;
end;

function  TSoapReader30.Get_Fault: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_Fault;
end;

function  TSoapReader30.Get_FaultString: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_FaultString;
end;

function  TSoapReader30.Get_FaultCode: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_FaultCode;
end;

function  TSoapReader30.Get_FaultActor: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_FaultActor;
end;

function  TSoapReader30.Get_FaultDetail: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_FaultDetail;
end;

function  TSoapReader30.Get_HeaderEntry(const par_LocalName: WideString; 
                                        const par_NamespaceURI: WideString): IXMLDOMElement;
begin
  Result := DefaultInterface.Get_HeaderEntry(par_LocalName, par_NamespaceURI);
end;

function  TSoapReader30.Get_MustUnderstandHeaderEntries: IXMLDOMNodeList;
begin
  Result := DefaultInterface.Get_MustUnderstandHeaderEntries;
end;

function  TSoapReader30.Get_HeaderEntries: IXMLDOMNodeList;
begin
  Result := DefaultInterface.Get_HeaderEntries;
end;

function  TSoapReader30.Get_BodyEntries: IXMLDOMNodeList;
begin
  Result := DefaultInterface.Get_BodyEntries;
end;

function  TSoapReader30.Get_BodyEntry(const par_LocalName: WideString; 
                                      const par_NamespaceURI: WideString): IXMLDOMElement;
begin
  Result := DefaultInterface.Get_BodyEntry(par_LocalName, par_NamespaceURI);
end;

function  TSoapReader30.Get_RpcStruct: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_RpcStruct;
end;

function  TSoapReader30.Get_RpcParameter(const par_LocalName: WideString; 
                                         const par_NamespaceURI: WideString): IXMLDOMElement;
begin
  Result := DefaultInterface.Get_RpcParameter(par_LocalName, par_NamespaceURI);
end;

function  TSoapReader30.Get_RpcResult: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_RpcResult;
end;

function  TSoapReader30.Get_SoapAction: WideString;
begin
  Result := DefaultInterface.Get_SoapAction;
end;

function  TSoapReader30.Get_Attachments: IReceivedAttachments;
begin
  Result := DefaultInterface.Get_Attachments;
end;

function  TSoapReader30.Get_Parser: IMessageParser;
begin
  Result := DefaultInterface.Get_Parser;
end;

procedure TSoapReader30.Set_XmlVersion(const Param1: WideString);
begin
  DefaultInterface.Set_XmlVersion(Param1);
end;

function  TSoapReader30.Load(par_source: OleVariant; const par_soapAction: WideString): WordBool;
begin
  Result := DefaultInterface.Load(par_source, par_soapAction);
end;

function  TSoapReader30.LoadWithParser(par_source: OleVariant; const par_parser: IMessageParser; 
                                       const par_soapAction: WideString): WordBool;
begin
  Result := DefaultInterface.LoadWithParser(par_source, par_parser, par_soapAction);
end;

function  TSoapReader30.LoadXml(const par_xml: WideString): WordBool;
begin
  Result := DefaultInterface.LoadXml(par_xml);
end;

function  TSoapReader30.GetContextItem(const par_key: WideString): OleVariant;
begin
  Result := DefaultInterface.GetContextItem(par_key);
end;

procedure TSoapReader30.SetContextItem(const par_key: WideString; par_value: OleVariant);
begin
  DefaultInterface.SetContextItem(par_key, par_value);
end;

function  TSoapReader30.GetReferencedNode(const par_context: IXMLDOMNode): IXMLDOMNode;
begin
  Result := DefaultInterface.GetReferencedNode(par_context);
end;

function  TSoapReader30.GetReferencedAttachment(const par_context: IXMLDOMNode): IReceivedAttachment;
begin
  Result := DefaultInterface.GetReferencedAttachment(par_context);
end;

function  TSoapReader30.IsAttachmentReference(const par_context: IXMLDOMNode): WordBool;
begin
  Result := DefaultInterface.IsAttachmentReference(par_context);
end;

function  TSoapReader30.IsNodeReference(const par_context: IXMLDOMNode): WordBool;
begin
  Result := DefaultInterface.IsNodeReference(par_context);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSoapReader30Properties.Create(AServer: TSoapReader30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSoapReader30Properties.GetDefaultInterface: ISoapReader;
begin
  Result := FServer.DefaultInterface;
end;

function  TSoapReader30Properties.Get_Dom: IXMLDOMDocument;
begin
  Result := DefaultInterface.Get_Dom;
end;

function  TSoapReader30Properties.Get_Envelope: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_Envelope;
end;

function  TSoapReader30Properties.Get_Body: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_Body;
end;

function  TSoapReader30Properties.Get_Header: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_Header;
end;

function  TSoapReader30Properties.Get_Fault: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_Fault;
end;

function  TSoapReader30Properties.Get_FaultString: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_FaultString;
end;

function  TSoapReader30Properties.Get_FaultCode: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_FaultCode;
end;

function  TSoapReader30Properties.Get_FaultActor: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_FaultActor;
end;

function  TSoapReader30Properties.Get_FaultDetail: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_FaultDetail;
end;

function  TSoapReader30Properties.Get_HeaderEntry(const par_LocalName: WideString; 
                                                  const par_NamespaceURI: WideString): IXMLDOMElement;
begin
  Result := DefaultInterface.Get_HeaderEntry(par_LocalName, par_NamespaceURI);
end;

function  TSoapReader30Properties.Get_MustUnderstandHeaderEntries: IXMLDOMNodeList;
begin
  Result := DefaultInterface.Get_MustUnderstandHeaderEntries;
end;

function  TSoapReader30Properties.Get_HeaderEntries: IXMLDOMNodeList;
begin
  Result := DefaultInterface.Get_HeaderEntries;
end;

function  TSoapReader30Properties.Get_BodyEntries: IXMLDOMNodeList;
begin
  Result := DefaultInterface.Get_BodyEntries;
end;

function  TSoapReader30Properties.Get_BodyEntry(const par_LocalName: WideString; 
                                                const par_NamespaceURI: WideString): IXMLDOMElement;
begin
  Result := DefaultInterface.Get_BodyEntry(par_LocalName, par_NamespaceURI);
end;

function  TSoapReader30Properties.Get_RpcStruct: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_RpcStruct;
end;

function  TSoapReader30Properties.Get_RpcParameter(const par_LocalName: WideString; 
                                                   const par_NamespaceURI: WideString): IXMLDOMElement;
begin
  Result := DefaultInterface.Get_RpcParameter(par_LocalName, par_NamespaceURI);
end;

function  TSoapReader30Properties.Get_RpcResult: IXMLDOMElement;
begin
  Result := DefaultInterface.Get_RpcResult;
end;

function  TSoapReader30Properties.Get_SoapAction: WideString;
begin
  Result := DefaultInterface.Get_SoapAction;
end;

function  TSoapReader30Properties.Get_Attachments: IReceivedAttachments;
begin
  Result := DefaultInterface.Get_Attachments;
end;

function  TSoapReader30Properties.Get_Parser: IMessageParser;
begin
  Result := DefaultInterface.Get_Parser;
end;

procedure TSoapReader30Properties.Set_XmlVersion(const Param1: WideString);
begin
  DefaultInterface.Set_XmlVersion(Param1);
end;

{$ENDIF}

class function CoSoapSerializer30.Create: ISoapSerializer;
begin
  Result := CreateComObject(CLASS_SoapSerializer30) as ISoapSerializer;
end;

class function CoSoapSerializer30.CreateRemote(const MachineName: string): ISoapSerializer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SoapSerializer30) as ISoapSerializer;
end;

procedure TSoapSerializer30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B76585B0-9257-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{23BDF2B5-2304-4550-BBE2-F197E2CC47B6}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSoapSerializer30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISoapSerializer;
  end;
end;

procedure TSoapSerializer30.ConnectTo(svrIntf: ISoapSerializer);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSoapSerializer30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSoapSerializer30.GetDefaultInterface: ISoapSerializer;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSoapSerializer30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSoapSerializer30Properties.Create(Self);
{$ENDIF}
end;

destructor TSoapSerializer30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSoapSerializer30.GetServerProperties: TSoapSerializer30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TSoapSerializer30.Get_SoapFault: WordBool;
begin
  Result := DefaultInterface.Get_SoapFault;
end;

function  TSoapSerializer30.Get_Composer: IMessageComposer;
begin
  Result := DefaultInterface.Get_Composer;
end;

procedure TSoapSerializer30.Init(par_output: OleVariant);
begin
  DefaultInterface.Init(par_output);
end;

procedure TSoapSerializer30.InitWithComposer(par_output: OleVariant; 
                                             const par_composer: IMessageComposer);
begin
  DefaultInterface.InitWithComposer(par_output, par_composer);
end;

procedure TSoapSerializer30.StartEnvelope(const par_Prefix: WideString; 
                                          const par_enc_style_uri: WideString; 
                                          const par_encoding: WideString);
begin
  DefaultInterface.StartEnvelope(par_Prefix, par_enc_style_uri, par_encoding);
end;

procedure TSoapSerializer30.EndEnvelope;
begin
  DefaultInterface.EndEnvelope;
end;

procedure TSoapSerializer30.StartHeader(const par_enc_style_uri: WideString);
begin
  DefaultInterface.StartHeader(par_enc_style_uri);
end;

procedure TSoapSerializer30.StartHeaderElement(const par_name: WideString; 
                                               const par_ns_uri: WideString; 
                                               par_mustUnderstand: SYSINT; 
                                               const par_actor_uri: WideString; 
                                               const par_enc_style_uri: WideString; 
                                               const par_Prefix: WideString);
begin
  DefaultInterface.StartHeaderElement(par_name, par_ns_uri, par_mustUnderstand, par_actor_uri, 
                                      par_enc_style_uri, par_Prefix);
end;

procedure TSoapSerializer30.EndHeaderElement;
begin
  DefaultInterface.EndHeaderElement;
end;

procedure TSoapSerializer30.EndHeader;
begin
  DefaultInterface.EndHeader;
end;

procedure TSoapSerializer30.StartBody(const par_enc_style_uri: WideString);
begin
  DefaultInterface.StartBody(par_enc_style_uri);
end;

procedure TSoapSerializer30.EndBody;
begin
  DefaultInterface.EndBody;
end;

procedure TSoapSerializer30.StartElement(const par_name: WideString; const par_ns_uri: WideString; 
                                         const par_enc_style_uri: WideString; 
                                         const par_Prefix: WideString);
begin
  DefaultInterface.StartElement(par_name, par_ns_uri, par_enc_style_uri, par_Prefix);
end;

procedure TSoapSerializer30.EndElement;
begin
  DefaultInterface.EndElement;
end;

procedure TSoapSerializer30.SoapAttribute(const par_name: WideString; const par_ns_uri: WideString; 
                                          const par_value: WideString; const par_Prefix: WideString);
begin
  DefaultInterface.SoapAttribute(par_name, par_ns_uri, par_value, par_Prefix);
end;

procedure TSoapSerializer30.SoapNamespace(const par_Prefix: WideString; const par_ns_uri: WideString);
begin
  DefaultInterface.SoapNamespace(par_Prefix, par_ns_uri);
end;

procedure TSoapSerializer30.SoapDefaultNamespace(const par_ns_uri: WideString);
begin
  DefaultInterface.SoapDefaultNamespace(par_ns_uri);
end;

procedure TSoapSerializer30.WriteString(const par_string: WideString);
begin
  DefaultInterface.WriteString(par_string);
end;

procedure TSoapSerializer30.WriteBuffer(par_len: Integer; var par_buffer: Byte);
begin
  DefaultInterface.WriteBuffer(par_len, par_buffer);
end;

procedure TSoapSerializer30.StartFault(const par_FaultCode: WideString; 
                                       const par_FaultString: WideString; 
                                       const par_FaultActor: WideString; 
                                       const par_FaultCodeNS: WideString);
begin
  DefaultInterface.StartFault(par_FaultCode, par_FaultString, par_FaultActor, par_FaultCodeNS);
end;

procedure TSoapSerializer30.StartFaultDetail(const par_enc_style_uri: WideString);
begin
  DefaultInterface.StartFaultDetail(par_enc_style_uri);
end;

procedure TSoapSerializer30.EndFaultDetail;
begin
  DefaultInterface.EndFaultDetail;
end;

procedure TSoapSerializer30.EndFault;
begin
  DefaultInterface.EndFault;
end;

procedure TSoapSerializer30.Reset;
begin
  DefaultInterface.Reset;
end;

procedure TSoapSerializer30.WriteXml(const par_string: WideString);
begin
  DefaultInterface.WriteXml(par_string);
end;

function  TSoapSerializer30.GetPrefixForNamespace(const par_ns_string: WideString): WideString;
begin
  Result := DefaultInterface.GetPrefixForNamespace(par_ns_string);
end;

procedure TSoapSerializer30.EndHrefedElement;
begin
  DefaultInterface.EndHrefedElement;
end;

function  TSoapSerializer30.StartHrefedElement(const par_name: WideString; 
                                               const par_ns_uri: WideString; 
                                               const par_enc_style_uri: WideString; 
                                               const par_Prefix: WideString; 
                                               par_location: enElementLocation; 
                                               const par_hrefidinput: WideString): WideString;
begin
  Result := DefaultInterface.StartHrefedElement(par_name, par_ns_uri, par_enc_style_uri, 
                                                par_Prefix, par_location, par_hrefidinput);
end;

function  TSoapSerializer30.GetContextItem(const par_key: WideString): OleVariant;
begin
  Result := DefaultInterface.GetContextItem(par_key);
end;

procedure TSoapSerializer30.SetContextItem(const par_key: WideString; par_value: OleVariant);
begin
  DefaultInterface.SetContextItem(par_key, par_value);
end;

procedure TSoapSerializer30.AddAttachment(const par_att: IAttachment);
begin
  DefaultInterface.AddAttachment(par_att);
end;

procedure TSoapSerializer30.AddAttachmentAndReference(const par_att: IAttachment);
begin
  DefaultInterface.AddAttachmentAndReference(par_att);
end;

procedure TSoapSerializer30.Finished;
begin
  DefaultInterface.Finished;
end;

function  TSoapSerializer30.CreateHRefId: WideString;
begin
  Result := DefaultInterface.CreateHRefId;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSoapSerializer30Properties.Create(AServer: TSoapSerializer30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSoapSerializer30Properties.GetDefaultInterface: ISoapSerializer;
begin
  Result := FServer.DefaultInterface;
end;

function  TSoapSerializer30Properties.Get_SoapFault: WordBool;
begin
  Result := DefaultInterface.Get_SoapFault;
end;

function  TSoapSerializer30Properties.Get_Composer: IMessageComposer;
begin
  Result := DefaultInterface.Get_Composer;
end;

{$ENDIF}

class function CoSoapServer30.Create: ISoapServer;
begin
  Result := CreateComObject(CLASS_SoapServer30) as ISoapServer;
end;

class function CoSoapServer30.CreateRemote(const MachineName: string): ISoapServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SoapServer30) as ISoapServer;
end;

procedure TSoapServer30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{7F017F96-9257-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{7F017F93-9257-11D5-87EA-00B0D0BE6479}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSoapServer30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISoapServer;
  end;
end;

procedure TSoapServer30.ConnectTo(svrIntf: ISoapServer);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSoapServer30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSoapServer30.GetDefaultInterface: ISoapServer;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSoapServer30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSoapServer30Properties.Create(Self);
{$ENDIF}
end;

destructor TSoapServer30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSoapServer30.GetServerProperties: TSoapServer30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TSoapServer30.Set_XmlVersion(const Param1: WideString);
begin
  DefaultInterface.Set_XmlVersion(Param1);
end;

procedure TSoapServer30.Init(const par_WSDLFile: WideString; const par_WSMLFile: WideString);
begin
  DefaultInterface.Init(par_WSDLFile, par_WSMLFile);
end;

procedure TSoapServer30.SoapInvoke(par_Input: OleVariant; const par_OutputStream: IUnknown; 
                                   const par_soapAction: WideString);
begin
  DefaultInterface.SoapInvoke(par_Input, par_OutputStream, par_soapAction);
end;

procedure TSoapServer30.SoapInvokeEx(par_Input: OleVariant; const par_OutputStream: IUnknown; 
                                     const par_ServerObject: IUnknown; 
                                     const par_soapAction: WideString; 
                                     const par_ContentType: WideString);
begin
  DefaultInterface.SoapInvokeEx(par_Input, par_OutputStream, par_ServerObject, par_soapAction, 
                                par_ContentType);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSoapServer30Properties.Create(AServer: TSoapServer30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSoapServer30Properties.GetDefaultInterface: ISoapServer;
begin
  Result := FServer.DefaultInterface;
end;

procedure TSoapServer30Properties.Set_XmlVersion(const Param1: WideString);
begin
  DefaultInterface.Set_XmlVersion(Param1);
end;

{$ENDIF}

class function CoSoapClient30.Create: ISoapClient;
begin
  Result := CreateComObject(CLASS_SoapClient30) as ISoapClient;
end;

class function CoSoapClient30.CreateRemote(const MachineName: string): ISoapClient;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SoapClient30) as ISoapClient;
end;

procedure TSoapClient30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{7F017F97-9257-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{7F017F92-9257-11D5-87EA-00B0D0BE6479}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSoapClient30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISoapClient;
  end;
end;

procedure TSoapClient30.ConnectTo(svrIntf: ISoapClient);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSoapClient30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSoapClient30.GetDefaultInterface: ISoapClient;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSoapClient30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSoapClient30Properties.Create(Self);
{$ENDIF}
end;

destructor TSoapClient30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSoapClient30.GetServerProperties: TSoapClient30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TSoapClient30.Get_FaultCode: WideString;
begin
  Result := DefaultInterface.Get_FaultCode;
end;

function  TSoapClient30.Get_FaultString: WideString;
begin
  Result := DefaultInterface.Get_FaultString;
end;

function  TSoapClient30.Get_FaultActor: WideString;
begin
  Result := DefaultInterface.Get_FaultActor;
end;

function  TSoapClient30.Get_Detail: WideString;
begin
  Result := DefaultInterface.Get_Detail;
end;

function  TSoapClient30.Get_ClientProperty(const par_PropertyName: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_ClientProperty(par_PropertyName);
end;

procedure TSoapClient30.Set_HeaderHandler(const Param1: IDispatch);
begin
  DefaultInterface.Set_HeaderHandler(Param1);
end;

procedure TSoapClient30._Set_ClientProperty(const par_PropertyName: WideString; 
                                            par_PropertyValue: OleVariant);
begin
  DefaultInterface._Set_ClientProperty(par_PropertyName, par_PropertyValue);
end;

function  TSoapClient30.Get_ConnectorProperty(const par_PropertyName: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_ConnectorProperty(par_PropertyName);
end;

procedure TSoapClient30.Set_ConnectorProperty(const par_PropertyName: WideString; 
                                              par_PropertyValue: OleVariant);
begin
  DefaultInterface.Set_ConnectorProperty(par_PropertyName, par_PropertyValue);
end;

function  TSoapClient30.Get_FaultCodeNamespace: WideString;
begin
  Result := DefaultInterface.Get_FaultCodeNamespace;
end;

procedure TSoapClient30.Set_ClientProperty(const par_PropertyName: WideString; 
                                           par_PropertyValue: OleVariant);
begin
  DefaultInterface.Set_ClientProperty(par_PropertyName, par_PropertyValue);
end;

procedure TSoapClient30.MSSoapInit(const par_WSDLFile: WideString; 
                                   const par_ServiceName: WideString; const par_Port: WideString; 
                                   const par_WSMLFile: WideString);
begin
  DefaultInterface.MSSoapInit(par_WSDLFile, par_ServiceName, par_Port, par_WSMLFile);
end;

procedure TSoapClient30.MSSoapInit2(par_WSDLFile: OleVariant; par_WSMLFile: OleVariant; 
                                    const par_ServiceName: WideString; const par_Port: WideString; 
                                    const par_Namespace: WideString);
begin
  DefaultInterface.MSSoapInit2(par_WSDLFile, par_WSMLFile, par_ServiceName, par_Port, par_Namespace);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSoapClient30Properties.Create(AServer: TSoapClient30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSoapClient30Properties.GetDefaultInterface: ISoapClient;
begin
  Result := FServer.DefaultInterface;
end;

function  TSoapClient30Properties.Get_FaultCode: WideString;
begin
  Result := DefaultInterface.Get_FaultCode;
end;

function  TSoapClient30Properties.Get_FaultString: WideString;
begin
  Result := DefaultInterface.Get_FaultString;
end;

function  TSoapClient30Properties.Get_FaultActor: WideString;
begin
  Result := DefaultInterface.Get_FaultActor;
end;

function  TSoapClient30Properties.Get_Detail: WideString;
begin
  Result := DefaultInterface.Get_Detail;
end;

function  TSoapClient30Properties.Get_ClientProperty(const par_PropertyName: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_ClientProperty(par_PropertyName);
end;

procedure TSoapClient30Properties.Set_HeaderHandler(const Param1: IDispatch);
begin
  DefaultInterface.Set_HeaderHandler(Param1);
end;

procedure TSoapClient30Properties._Set_ClientProperty(const par_PropertyName: WideString; 
                                                      par_PropertyValue: OleVariant);
begin
  DefaultInterface._Set_ClientProperty(par_PropertyName, par_PropertyValue);
end;

function  TSoapClient30Properties.Get_ConnectorProperty(const par_PropertyName: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_ConnectorProperty(par_PropertyName);
end;

procedure TSoapClient30Properties.Set_ConnectorProperty(const par_PropertyName: WideString; 
                                                        par_PropertyValue: OleVariant);
begin
  DefaultInterface.Set_ConnectorProperty(par_PropertyName, par_PropertyValue);
end;

function  TSoapClient30Properties.Get_FaultCodeNamespace: WideString;
begin
  Result := DefaultInterface.Get_FaultCodeNamespace;
end;

procedure TSoapClient30Properties.Set_ClientProperty(const par_PropertyName: WideString; 
                                                     par_PropertyValue: OleVariant);
begin
  DefaultInterface.Set_ClientProperty(par_PropertyName, par_PropertyValue);
end;

{$ENDIF}

class function CoWSDLReader30.Create: IWSDLReader;
begin
  Result := CreateComObject(CLASS_WSDLReader30) as IWSDLReader;
end;

class function CoWSDLReader30.CreateRemote(const MachineName: string): IWSDLReader;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WSDLReader30) as IWSDLReader;
end;

procedure TWSDLReader30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{EF90A70C-925B-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{DE523FD4-AFB8-4643-BA90-9DEB3C7FB4A3}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TWSDLReader30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IWSDLReader;
  end;
end;

procedure TWSDLReader30.ConnectTo(svrIntf: IWSDLReader);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TWSDLReader30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TWSDLReader30.GetDefaultInterface: IWSDLReader;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TWSDLReader30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TWSDLReader30Properties.Create(Self);
{$ENDIF}
end;

destructor TWSDLReader30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TWSDLReader30.GetServerProperties: TWSDLReader30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TWSDLReader30.Get_TypeFactory(out par_Factory: ISoapTypeMapperFactory): HResult;
begin
  Result := DefaultInterface.Get_TypeFactory(par_Factory);
end;

function  TWSDLReader30.Load(const par_WSDLFile: WideString; const par_WSMLFile: WideString): HResult;
begin
  Result := DefaultInterface.Load(par_WSDLFile, par_WSMLFile);
end;

function  TWSDLReader30.Load2(par_WSDLFile: OleVariant; par_WSMLFile: OleVariant; 
                              const par_StartingNamespace: WideString): HResult;
begin
  Result := DefaultInterface.Load2(par_WSDLFile, par_WSMLFile, par_StartingNamespace);
end;

function  TWSDLReader30.GetSoapServices(out par_IWSDLServiceEnum: IEnumWSDLService): HResult;
begin
  Result := DefaultInterface.GetSoapServices(par_IWSDLServiceEnum);
end;

function  TWSDLReader30.ParseRequest(const par_ISoapReader: ISoapReader; 
                                     out par_IWSDLPort: IWSDLPort; 
                                     out par_IWSDLOperation: IWSDLOperation): HResult;
begin
  Result := DefaultInterface.ParseRequest(par_ISoapReader, par_IWSDLPort, par_IWSDLOperation);
end;

function  TWSDLReader30.SetProperty(const par_PropertyName: WideString; par_PropValue: OleVariant): HResult;
begin
  Result := DefaultInterface.SetProperty(par_PropertyName, par_PropValue);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TWSDLReader30Properties.Create(AServer: TWSDLReader30);
begin
  inherited Create;
  FServer := AServer;
end;

function TWSDLReader30Properties.GetDefaultInterface: IWSDLReader;
begin
  Result := FServer.DefaultInterface;
end;

function  TWSDLReader30Properties.Get_TypeFactory(out par_Factory: ISoapTypeMapperFactory): HResult;
begin
  Result := DefaultInterface.Get_TypeFactory(par_Factory);
end;

{$ENDIF}

class function CoSoapTypeMapperFactory30.Create: ISoapTypeMapperFactory;
begin
  Result := CreateComObject(CLASS_SoapTypeMapperFactory30) as ISoapTypeMapperFactory;
end;

class function CoSoapTypeMapperFactory30.CreateRemote(const MachineName: string): ISoapTypeMapperFactory;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SoapTypeMapperFactory30) as ISoapTypeMapperFactory;
end;

procedure TSoapTypeMapperFactory30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{EF90A715-925B-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{FCED9F15-D0A7-4380-87E6-992381ACD213}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSoapTypeMapperFactory30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISoapTypeMapperFactory;
  end;
end;

procedure TSoapTypeMapperFactory30.ConnectTo(svrIntf: ISoapTypeMapperFactory);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSoapTypeMapperFactory30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSoapTypeMapperFactory30.GetDefaultInterface: ISoapTypeMapperFactory;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSoapTypeMapperFactory30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSoapTypeMapperFactory30Properties.Create(Self);
{$ENDIF}
end;

destructor TSoapTypeMapperFactory30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSoapTypeMapperFactory30.GetServerProperties: TSoapTypeMapperFactory30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TSoapTypeMapperFactory30.AddSchema(const par_SchemaNode: IXMLDOMNode);
begin
  DefaultInterface.AddSchema(par_SchemaNode);
end;

function  TSoapTypeMapperFactory30.GetElementMapperByName(const par_ElementName: WideString; 
                                                          const par_ElementNamespace: WideString): ISoapTypeMapper;
begin
  Result := DefaultInterface.GetElementMapperByName(par_ElementName, par_ElementNamespace);
end;

function  TSoapTypeMapperFactory30.GetTypeMapperByName(const par_TypeName: WideString; 
                                                       const par_TypeNamespace: WideString): ISoapTypeMapper;
begin
  Result := DefaultInterface.GetTypeMapperByName(par_TypeName, par_TypeNamespace);
end;

function  TSoapTypeMapperFactory30.GetElementMapper(const par_ElementNode: IXMLDOMNode): ISoapTypeMapper;
begin
  Result := DefaultInterface.GetElementMapper(par_ElementNode);
end;

function  TSoapTypeMapperFactory30.GetTypeMapper(const par_TypeNode: IXMLDOMNode): ISoapTypeMapper;
begin
  Result := DefaultInterface.GetTypeMapper(par_TypeNode);
end;

procedure TSoapTypeMapperFactory30.AddType(const par_TypeName: WideString; 
                                           const par_TypeNamespace: WideString; 
                                           const par_ProgID: WideString; const par_IID: WideString);
begin
  DefaultInterface.AddType(par_TypeName, par_TypeNamespace, par_ProgID, par_IID);
end;

procedure TSoapTypeMapperFactory30.AddElement(const par_ElementName: WideString; 
                                              const par_ElementNamespace: WideString; 
                                              const par_ProgID: WideString; 
                                              const par_IID: WideString);
begin
  DefaultInterface.AddElement(par_ElementName, par_ElementNamespace, par_ProgID, par_IID);
end;

function  TSoapTypeMapperFactory30.GetMapper(par_xsdType: enXSDType; 
                                             const par_SchemaNode: IXMLDOMNode): ISoapTypeMapper;
begin
  Result := DefaultInterface.GetMapper(par_xsdType, par_SchemaNode);
end;

procedure TSoapTypeMapperFactory30.AddCustomMapper(const par_ProgID: WideString; 
                                                   const par_WSMLNode: IXMLDOMNode);
begin
  DefaultInterface.AddCustomMapper(par_ProgID, par_WSMLNode);
end;

function  TSoapTypeMapperFactory30.GetDefinitionsNode(const par_BaseName: WideString; 
                                                      const par_Namespace: WideString; 
                                                      par_LookForElement: WordBool): IXMLDOMNode;
begin
  Result := DefaultInterface.GetDefinitionsNode(par_BaseName, par_Namespace, par_LookForElement);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSoapTypeMapperFactory30Properties.Create(AServer: TSoapTypeMapperFactory30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSoapTypeMapperFactory30Properties.GetDefaultInterface: ISoapTypeMapperFactory;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoGenericCustomTypeMapper30.Create: IDispatch;
begin
  Result := CreateComObject(CLASS_GenericCustomTypeMapper30) as IDispatch;
end;

class function CoGenericCustomTypeMapper30.CreateRemote(const MachineName: string): IDispatch;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GenericCustomTypeMapper30) as IDispatch;
end;

procedure TGenericCustomTypeMapper30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{EF90A716-925B-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{00020400-0000-0000-C000-000000000046}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGenericCustomTypeMapper30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDispatch;
  end;
end;

procedure TGenericCustomTypeMapper30.ConnectTo(svrIntf: IDispatch);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGenericCustomTypeMapper30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGenericCustomTypeMapper30.GetDefaultInterface: IDispatch;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TGenericCustomTypeMapper30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGenericCustomTypeMapper30Properties.Create(Self);
{$ENDIF}
end;

destructor TGenericCustomTypeMapper30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGenericCustomTypeMapper30.GetServerProperties: TGenericCustomTypeMapper30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGenericCustomTypeMapper30Properties.Create(AServer: TGenericCustomTypeMapper30);
begin
  inherited Create;
  FServer := AServer;
end;

function TGenericCustomTypeMapper30Properties.GetDefaultInterface: IDispatch;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoUDTMapper30.Create: IDispatch;
begin
  Result := CreateComObject(CLASS_UDTMapper30) as IDispatch;
end;

class function CoUDTMapper30.CreateRemote(const MachineName: string): IDispatch;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_UDTMapper30) as IDispatch;
end;

procedure TUDTMapper30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{8BCD9554-86C7-435D-A8C8-BCB3C72FBEE9}';
    IntfIID:   '{00020400-0000-0000-C000-000000000046}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TUDTMapper30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDispatch;
  end;
end;

procedure TUDTMapper30.ConnectTo(svrIntf: IDispatch);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TUDTMapper30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TUDTMapper30.GetDefaultInterface: IDispatch;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TUDTMapper30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TUDTMapper30Properties.Create(Self);
{$ENDIF}
end;

destructor TUDTMapper30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TUDTMapper30.GetServerProperties: TUDTMapper30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TUDTMapper30Properties.Create(AServer: TUDTMapper30);
begin
  inherited Create;
  FServer := AServer;
end;

function TUDTMapper30Properties.GetDefaultInterface: IDispatch;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSoapConnector30.Create: ISoapConnector;
begin
  Result := CreateComObject(CLASS_SoapConnector30) as ISoapConnector;
end;

class function CoSoapConnector30.CreateRemote(const MachineName: string): ISoapConnector;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SoapConnector30) as ISoapConnector;
end;

procedure TSoapConnector30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0AF40C52-9257-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{0AF40C4E-9257-11D5-87EA-00B0D0BE6479}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSoapConnector30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISoapConnector;
  end;
end;

procedure TSoapConnector30.ConnectTo(svrIntf: ISoapConnector);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSoapConnector30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSoapConnector30.GetDefaultInterface: ISoapConnector;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSoapConnector30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSoapConnector30Properties.Create(Self);
{$ENDIF}
end;

destructor TSoapConnector30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSoapConnector30.GetServerProperties: TSoapConnector30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TSoapConnector30.Get_InputStream: IStream;
begin
  Result := DefaultInterface.Get_InputStream;
end;

function  TSoapConnector30.Get_OutputStream: IStream;
begin
  Result := DefaultInterface.Get_OutputStream;
end;

function  TSoapConnector30.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TSoapConnector30.Set_Property_(const par_name: WideString; par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

procedure TSoapConnector30.ConnectWSDL(const par_Port: IWSDLPort);
begin
  DefaultInterface.ConnectWSDL(par_Port);
end;

procedure TSoapConnector30.BeginMessageWSDL(const par_operation: IWSDLOperation);
begin
  DefaultInterface.BeginMessageWSDL(par_operation);
end;

procedure TSoapConnector30.EndMessage;
begin
  DefaultInterface.EndMessage;
end;

procedure TSoapConnector30.Reset;
begin
  DefaultInterface.Reset;
end;

procedure TSoapConnector30.Connect1;
begin
  DefaultInterface.Connect;
end;

procedure TSoapConnector30.BeginMessage;
begin
  DefaultInterface.BeginMessage;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSoapConnector30Properties.Create(AServer: TSoapConnector30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSoapConnector30Properties.GetDefaultInterface: ISoapConnector;
begin
  Result := FServer.DefaultInterface;
end;

function  TSoapConnector30Properties.Get_InputStream: IStream;
begin
  Result := DefaultInterface.Get_InputStream;
end;

function  TSoapConnector30Properties.Get_OutputStream: IStream;
begin
  Result := DefaultInterface.Get_OutputStream;
end;

function  TSoapConnector30Properties.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure TSoapConnector30Properties.Set_Property_(const par_name: WideString; par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

{$ENDIF}

class function CoSoapConnectorFactory30.Create: ISoapConnectorFactory;
begin
  Result := CreateComObject(CLASS_SoapConnectorFactory30) as ISoapConnectorFactory;
end;

class function CoSoapConnectorFactory30.CreateRemote(const MachineName: string): ISoapConnectorFactory;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SoapConnectorFactory30) as ISoapConnectorFactory;
end;

procedure TSoapConnectorFactory30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0AF40C58-9257-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{0AF40C50-9257-11D5-87EA-00B0D0BE6479}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSoapConnectorFactory30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISoapConnectorFactory;
  end;
end;

procedure TSoapConnectorFactory30.ConnectTo(svrIntf: ISoapConnectorFactory);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSoapConnectorFactory30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSoapConnectorFactory30.GetDefaultInterface: ISoapConnectorFactory;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSoapConnectorFactory30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSoapConnectorFactory30Properties.Create(Self);
{$ENDIF}
end;

destructor TSoapConnectorFactory30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSoapConnectorFactory30.GetServerProperties: TSoapConnectorFactory30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TSoapConnectorFactory30.CreatePortConnector(const par_Port: IWSDLPort): ISoapConnector;
begin
  Result := DefaultInterface.CreatePortConnector(par_Port);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSoapConnectorFactory30Properties.Create(AServer: TSoapConnectorFactory30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSoapConnectorFactory30Properties.GetDefaultInterface: ISoapConnectorFactory;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoHttpConnector30.Create: ISoapConnector;
begin
  Result := CreateComObject(CLASS_HttpConnector30) as ISoapConnector;
end;

class function CoHttpConnector30.CreateRemote(const MachineName: string): ISoapConnector;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HttpConnector30) as ISoapConnector;
end;

procedure THttpConnector30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0AF40C53-9257-11D5-87EA-00B0D0BE6479}';
    IntfIID:   '{0AF40C4E-9257-11D5-87EA-00B0D0BE6479}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure THttpConnector30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISoapConnector;
  end;
end;

procedure THttpConnector30.ConnectTo(svrIntf: ISoapConnector);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure THttpConnector30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function THttpConnector30.GetDefaultInterface: ISoapConnector;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor THttpConnector30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := THttpConnector30Properties.Create(Self);
{$ENDIF}
end;

destructor THttpConnector30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function THttpConnector30.GetServerProperties: THttpConnector30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  THttpConnector30.Get_InputStream: IStream;
begin
  Result := DefaultInterface.Get_InputStream;
end;

function  THttpConnector30.Get_OutputStream: IStream;
begin
  Result := DefaultInterface.Get_OutputStream;
end;

function  THttpConnector30.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure THttpConnector30.Set_Property_(const par_name: WideString; par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

procedure THttpConnector30.ConnectWSDL(const par_Port: IWSDLPort);
begin
  DefaultInterface.ConnectWSDL(par_Port);
end;

procedure THttpConnector30.BeginMessageWSDL(const par_operation: IWSDLOperation);
begin
  DefaultInterface.BeginMessageWSDL(par_operation);
end;

procedure THttpConnector30.EndMessage;
begin
  DefaultInterface.EndMessage;
end;

procedure THttpConnector30.Reset;
begin
  DefaultInterface.Reset;
end;

procedure THttpConnector30.Connect1;
begin
  DefaultInterface.Connect;
end;

procedure THttpConnector30.BeginMessage;
begin
  DefaultInterface.BeginMessage;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor THttpConnector30Properties.Create(AServer: THttpConnector30);
begin
  inherited Create;
  FServer := AServer;
end;

function THttpConnector30Properties.GetDefaultInterface: ISoapConnector;
begin
  Result := FServer.DefaultInterface;
end;

function  THttpConnector30Properties.Get_InputStream: IStream;
begin
  Result := DefaultInterface.Get_InputStream;
end;

function  THttpConnector30Properties.Get_OutputStream: IStream;
begin
  Result := DefaultInterface.Get_OutputStream;
end;

function  THttpConnector30Properties.Get_Property_(const par_name: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Property_(par_name);
end;

procedure THttpConnector30Properties.Set_Property_(const par_name: WideString; par_value: OleVariant);
begin
  DefaultInterface.Set_Property_(par_name, par_value);
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents('ActiveX',[TFileAttachment30, TStringAttachment30, TByteArrayAttachment30, TStreamAttachment30, 
    TSentAttachments30, TReceivedAttachments30, TDataEncoderFactory30, TDimeComposer30, TDimeParser30, 
    TSimpleComposer30, TSimpleParser30, TSoapReader30, TSoapSerializer30, TSoapServer30, 
    TSoapClient30, TWSDLReader30, TSoapTypeMapperFactory30, TGenericCustomTypeMapper30, TUDTMapper30, 
    TSoapConnector30, TSoapConnectorFactory30, THttpConnector30]);
end;

end.
