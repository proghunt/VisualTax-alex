{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{          FireDAC sources configuration file           }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}

{$B-} // Boolean short-circuit evaluation ON
{$H+} // Long strings ON
{$T-} // Type-checked pointers OFF
{$X+} // Extended syntax ON

{$IFNDEF VER130}
  {$ALIGN 8}
{$ELSE}
  {$ALIGN ON}
{$ENDIF}
{$MINENUMSIZE 4}
{$WARNINGS ON}
{$HINTS ON}

{$IFDEF VER130}      // C++ Builder 5 & Delphi 5
  {$DEFINE AnyDAC_D5}
  {$DEFINE MSWINDOWS}
  // App built with Delphi5 & OptimizationOn raises AV's in random places
  {$O-}
{$ENDIF}

{$IFDEF VER140}      // Delphi 6 and C++ Builder 6
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  // App built with Delphi6 & OptimizationOn raises AV's in random places
  {$O-}
{$ENDIF}

{$IFDEF VER150}      // Delphi 7
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_DELPHI}
{$ENDIF}

{$IFDEF VER160}      // Delphi 8
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_DELPHI}
{$ENDIF}

{$IFDEF VER170}      // Delphi 2005
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$Q-} // otherwise possible internal error C6662 on uADStanOption, line 2434
{$ENDIF}

{$IFDEF VER180} // Delphi 2006
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$DEFINE AnyDAC_D10}
{$ENDIF}

{$IFDEF VER185} // Delphi 2007
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$DEFINE AnyDAC_D10}
  {$DEFINE AnyDAC_D11}
{$ENDIF}

{$IFDEF VER200} // Delphi 2009
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$DEFINE AnyDAC_D10}
  {$DEFINE AnyDAC_D11}
  {$DEFINE AnyDAC_D12}
{$ENDIF}

{$IFDEF VER210} // Delphi 2010
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$DEFINE AnyDAC_D10}
  {$DEFINE AnyDAC_D11}
  {$DEFINE AnyDAC_D12}
  {$DEFINE AnyDAC_D14}
{$ENDIF}

{$IFDEF VER220} // Delphi XE
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$DEFINE AnyDAC_D10}
  {$DEFINE AnyDAC_D11}
  {$DEFINE AnyDAC_D12}
  {$DEFINE AnyDAC_D14}
  {$DEFINE AnyDAC_D15}
{$ENDIF}

{$IFDEF VER230} // Delphi XE2
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$DEFINE AnyDAC_D10}
  {$DEFINE AnyDAC_D11}
  {$DEFINE AnyDAC_D12}
  {$DEFINE AnyDAC_D14}
  {$DEFINE AnyDAC_D15}
  {$DEFINE AnyDAC_D16}
  {$DEFINE AnyDAC_XPLAT}
{$ENDIF}

{$IFDEF VER240} // Delphi XE3
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$DEFINE AnyDAC_D10}
  {$DEFINE AnyDAC_D11}
  {$DEFINE AnyDAC_D12}
  {$DEFINE AnyDAC_D14}
  {$DEFINE AnyDAC_D15}
  {$DEFINE AnyDAC_D16}
  {$DEFINE AnyDAC_D17}
  {$DEFINE AnyDAC_XPLAT}
  {$LEGACYIFEND ON}
{$ENDIF}

{$IFDEF VER250} // Delphi XE4
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_D6}
  {$DEFINE AnyDAC_D7}
  {$DEFINE AnyDAC_D8}
  {$DEFINE AnyDAC_D9}
  {$DEFINE AnyDAC_D10}
  {$DEFINE AnyDAC_D11}
  {$DEFINE AnyDAC_D12}
  {$DEFINE AnyDAC_D14}
  {$DEFINE AnyDAC_D15}
  {$DEFINE AnyDAC_D16}
  {$DEFINE AnyDAC_D17}
  {$DEFINE AnyDAC_D18}
  {$DEFINE AnyDAC_XPLAT}
  {$LEGACYIFEND ON}
{$ENDIF}

{$IFDEF FPC}    // FPC
  {$DEFINE AnyDAC_D5}
  {$DEFINE AnyDAC_D6Base}
  {$DEFINE AnyDAC_FPC}
  // protect from doubling FPC mode setting in FireDAC DAD
  // otherwise gives an error
  {$IFNDEF RO_FPC_MODE_SET}
    {$MODE Delphi}
    {$DEFINE RO_FPC_MODE_SET}
  {$ENDIF}
  {$DEFINE AnyDAC_XPLAT}
{$ENDIF}

{$IFDEF BCB}
  {$DEFINE AnyDAC_BCB}      // C++ Builder
  {$OBJEXPORTALL ON}
  {$IFNDEF AnyDAC_D6}
    {$DEFINE AnyDAC_SkipIUnk}
  {$ENDIF}
{$ELSE}
  {$IFNDEF FPC}
    {$DEFINE AnyDAC_DELPHI} // Delphi
  {$ENDIF}
{$ENDIF}

{$IFDEF AnyDAC_D7}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

{$IFDEF AnyDAC_D12}
  {$DEFINE AnyDAC_Unicode}
  {$IFNDEF NEXTGEN}
    {$DEFINE AnyDAC_UseAsAnsiString}
  {$ENDIF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}
{$IFDEF AnyDAC_D17}
  {$ZEROBASEDSTRINGS OFF}
{$ENDIF}
{$IFDEF AnyDAC_D10}
  {$DEFINE AnyDAC_WIDEMEMO}
  {$DEFINE AnyDAC_FullIPS}
{$ENDIF}
{$IFDEF AnyDAC_FPC}
  {$DEFINE AnyDAC_WIDEMEMO}
  {$DEFINE AnyDAC_FullIPS}
{$ENDIF}

{$UNDEF AnyDAC_32}
{$UNDEF AnyDAC_64}
{$UNDEF AnyDAC_ASM}
{$IFDEF AnyDAC_FPC}
  {$IFDEF CPU64}
    {$DEFINE AnyDAC_64}
  {$ELSE}
    {$DEFINE AnyDAC_32}
  {$ENDIF}
{$ELSE}
  {$IFDEF CPUX64}
    {$DEFINE AnyDAC_64}
  {$ELSE}
    {$DEFINE AnyDAC_32}
  {$ENDIF}
{$ENDIF}

{$IFDEF MSWINDOWS}
  {$IFDEF AnyDAC_32}
    {$DEFINE AnyDAC_ASM}
  {$ENDIF}
{$ENDIF}

{$IFDEF AnyDAC_FPC}
  {$IFDEF DARWIN}
    {$DEFINE MACOS}
  {$ENDIF}
  {$IFDEF UNIX}
    {$DEFINE AnyDAC_POSIX}
    {$DEFINE AnyDAC_NATIVE_UTF8}
    {$DEFINE AnyDAC_INTF_CDECL}
  {$ENDIF}
  {$IFDEF MACOS}
    {$DEFINE AnyDAC_POSIX}
    {$DEFINE AnyDAC_INTF_CDECL}
  {$ENDIF}
{$ENDIF}
{$IFDEF POSIX}
  {$DEFINE AnyDAC_POSIX}
{$ENDIF}

{$IFNDEF AnyDAC_FPC}
  {$IFDEF IOS}
    {$DEFINE AnyDAC_Mobile}
  {$ENDIF}
{$ENDIF}

{$I uADVer.inc}
{$I uADEnv.inc}

{------------------------------------------------------------------------------}
{ Common                                                                       }
{------------------------------------------------------------------------------}
{.$DEFINE AnyDAC_NOLOCALE_DATA}   // define, to use binary data comparision
{$DEFINE AnyDAC_NOLOCALE_META}    // define, to use binary metadata comparision
{.$DEFINE AnyDAC_DEBUG}           // define, to profile using AQTime
{$DEFINE AnyDAC_MONITOR}          // define, to enable FireDAC tracing
{$IFDEF AnyDAC_MONITOR}
  {$DEFINE AnyDAC_MONITOR_Comp}   // define, to enable FireDAC components tracing
{$ENDIF}
{$IFNDEF AnyDAC_FPC}
  {$DEFINE AnyDAC_VarBytes}       // define, to enable ftVarBytes support
{$ENDIF}
{.$DEFINE AnyDAC_CyrillicSupport} // define, to enable extended support for
                                  // cyrillic characters in expressions, SQL, etc
{$DEFINE AnyDAC_STATIC_CDECL}     // define, to declare static linking code cdecl
{$DEFINE AnyDAC_DesignTimeMenu}   // define, to enable FireDAC IDE menu
{$IFDEF AnyDAC_D6}
  {$DEFINE AnyDAC_STRG_XML}       // define, to enable FireDAC XML storage format
{$ENDIF}
{$DEFINE AnyDAC_STRG_BIN}         // define, to enable FireDAC BIN storage format

{------------------------------------------------------------------------------}
{ SynEdit                                                                      }
{------------------------------------------------------------------------------}
{.$UNDEF AnyDAC_SynEdit}          // undefine, to disable SynEdit usage
{$IFDEF AnyDAC_FPC}               // FPC comes with prepackaged SynEdit
  {$DEFINE AnyDAC_SynEdit}
{$ELSE}
  {$IFNDEF WIN32}                 // SynEdit is supported only for Win32
    {$UNDEF AnyDAC_SynEdit}
  {$ENDIF}
{$ENDIF}

{------------------------------------------------------------------------------}
{ dbExpress driver                                                             }
{------------------------------------------------------------------------------}
{$DEFINE AnyDAC_DBX}              // define, to enable dbExpress usage
{$DEFINE AnyDAC_DBX_GETPARBUG}    // define to workaround getParameter bug
{$DEFINE AnyDAC_DBX_GETINDBUG}    // define to workaround MSSQL getIndices (uniq/pk/nonuniq) bug
{$DEFINE AnyDAC_DBX_ORACATBUG}    // define to workaround Oracle catalog representation
{$DEFINE AnyDAC_DBX_ORASCHBUG}    // define to workaround Oracle schema representation
{$DEFINE AnyDAC_DBX_MYSQLCMDBUG}  // define to workaround MySQL ISQLCommand.Close bug
{$DEFINE AnyDAC_DBX_ODBCINDBUG}   // define to wrokaround Open ODBC driver getIndices bug

{------------------------------------------------------------------------------}
{ Oracle driver                                                                }
{------------------------------------------------------------------------------}
{.$DEFINE AnyDAC_OCI_USE_BINDDYNAMIC} // define when dynamic bind will be stable
{.$DEFINE AnyDAC_OCI_NLSParams}       // define to output V$NLS_PARAMETERS to trace
{.$DEFINE AnyDAC_OCI_Versions}        // define to output V$VERSION to trace

{------------------------------------------------------------------------------}
{ SQLite driver                                                                }
{------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
  {$IFNDEF AnyDAC_POSIX}
    {$DEFINE AnyDAC_SQLITE_STATIC}    // Use SQLite3 static linking library
  {$ENDIF}
{$ENDIF}
{.$UNDEF AnyDAC_SQLITE_STATIC}        // remove '.' to enable dynamic linking
// The following defines keep in sync with the sqlite3.c compilation defines
{$IFDEF AnyDAC_SQLITE_STATIC}
  {$DEFINE AnyDAC_SQLITE_HAS_CODEC}
  {$DEFINE AnyDAC_SQLITE_ENABLE_COLUMN_METADATA}
  {$DEFINE AnyDAC_SQLITE_OMIT_LOAD_EXTENSION}
{$ELSE}
  {$DEFINE AnyDAC_SQLITE_HAS_CODEC}
  {$DEFINE AnyDAC_SQLITE_ENABLE_COLUMN_METADATA}
  {$DEFINE AnyDAC_SQLITE_OMIT_LOAD_EXTENSION}
{$ENDIF}

{------------------------------------------------------------------------------}
{ PostgreSQL driver                                                            }
{------------------------------------------------------------------------------}
//{$IFDEF AnyDAC_FPC}
  {$UNDEF AnyDAC_PGSQL_STATIC}
//{$ELSE}
//  {$DEFINE AnyDAC_PGSQL_STATIC}     // Use libpq static linking library
//{$ENDIF}

{------------------------------------------------------------------------------}
{ ODBC driver                                                                  }
{------------------------------------------------------------------------------}
{$DEFINE AnyDAC_ODBC_ALLMETA}         // define to link known DBMS metainfo's

{------------------------------------------------------------------------------}
{ IB / FB driver                                                               }
{------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
  {$IFDEF IOS}
    {$IFDEF CPUARM}
      {$DEFINE AnyDAC_IB_STATIC}          // Use IB driver static linking
      {$DEFINE AnyDAC_IB_STATIC_IBBRAND}  // Use IbTogo static linking library
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

