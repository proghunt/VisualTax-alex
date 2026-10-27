{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 4.0 for Delphi and C++Builder               ::
  ::                                                         ::
  :: QRDEFS.PAS - CONDITIONAL DEFINES, INCLUDED IN ALL FILES ::
  ::                                                         ::
  :: Copyright (c) 2014 QBS Software Ltd                     ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.quickreport.co.uk                       ::
  ::                                                         ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }
{$WARN SYMBOL_DEPRECATED OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

{$define BDETABLES}

{$ifdef VER220}
  {$define DXE}
{$endif}

{$ifdef ver130}
{$define ver120}
{$endif}
{$IFDEF VER125}
{$DEFINE VER110}
{$ENDIF}
{$IFDEF VER120}
{$DEFINE VER110}
{$ENDIF}
//{$DEFINE VER110}
{$define VER36PRO}
{$define VER36}

