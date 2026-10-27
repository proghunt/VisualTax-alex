unit T1_2026EZTWAIN;
{
  EZTwain for Delphi.

  XDefs translation of \EZTwain\VC\Eztwain.h
  EZTwain 3.30.0.28, XDefs 1.36b1
}
interface

uses Windows,Messages,SysUtils;

// 20150904 igor PChar -> PAnsiChar

type
  HANDLE = Cardinal;
  HCONTAINER = HANDLE;

// EZTWAIN.H - Easy interface to TWAIN library
// Copyright (C) 1999-2009 by Dosadi.
//
// This interface and the library which implements it, are the property of
// Dosadi and are protected by US and International copyright and trademark
// laws and treaties.  Dosadi strives to make this software both reliable,
// comprehensive, efficient, and affordable.  Do not use this software without
// obtaining a license for your use.
// 
// Sales, support and licensing information at: www.dosadi.com
//



function TWAIN_Testing123(s:PAnsiChar; n:Integer; h:Cardinal; d:Double; u:Cardinal): Cardinal;
stdcall; external 'Eztwain3.dll'
// Displays a dialog box showing the parameter values received by the function.
// Pass in any valid values for the parameters - if they are faithfully
// displayed in the dialog box when you call this function, then parameter
// passing from your program to EZTwain is probably working correctly.
//
// Returns the value of the HDIB h parameter.

//--------- Top-Level Calls

function TWAIN_Acquire(hwndApp:HWND): Cardinal;
stdcall; external 'Eztwain3.dll'
// Acquires a single image, from the currently selected Data Source, using
// EZTWAIN's preferred transfer mode.  (Currently the preferred mode is NATIVE)
//
// The parameter is a Win32 Window Handle.  In most applications you
// can use 0 or NULL, but on Citrix and WTS, this must be a top-level window
// or a child of a top level window.
//
// The return value is a handle to global memory containing a DIB - 
// a Device-Independent Bitmap.  Numerous EZTWAIN DIB_xxx functions can
// be used to examine, modify, and save these DIB images.
// Warning: Remember to call DIB_Free on each DIB when you are done with it!
//
// Normally only one image is acquired per call: All Acquire functions shut
// down TWAIN before returning.  Use TWAIN_SetMultiTransfer to change this.
//
// By default, the default data source (DS) is opened, displays its dialog,
// and determines all the parameters of the acquisition and transfer.
// If you want to (try to) hide the DS dialog, see TWAIN_SetHideUI.
// To set acquisition parameters, you need to do something like this:
//     TWAIN_OpenDefaultSource() -or- TWAIN_OpenSource(sourceName)
//     TWAIN_Set*        - one or more capability-setting functions
//     hdib = TWAIN_Acquire(hwnd)
//     if (hdib) then ... process image, TWAIN_FreeNative(hdib); end

function TWAIN_SelectImageSource(hwnd:HWND): BOOL;
stdcall; external 'Eztwain3.dll'
// This is the routine to call when the user chooses the "Select Source..."
// menu command from your application's File menu.
// In the standard implementation of "Select Source...", your application
// doesn't need to do anything except make this one call.
// Note: If only one TWAIN device is installed on a system, it is selected
// automatically, so there is no need for the user to do Select Source.
// You should not require your users to do Select Source before Acquire.
//
// This function posts the Source Manager's Select Source dialog box.
// It returns after the user either OK's or CANCEL's that dialog.
// A return of TRUE(1) indicates OK, FALSE(0) indicates one of the following:
//   a) The user cancelled the dialog
//   b) The Source Manager found no data sources installed
//   c) There was a failure before the Select Source dialog could be posted
//
// If you want to be meticulous, disable your "Acquire" and "Select Source"
// menu items or buttons if TWAIN_IsAvailable() returns false - see below.
//
// To enumerate the available data sources, see:
//     TWAIN_GetSourceList and TWAIN_NextSourceName

function TWAIN_AcquireNative(hwndApp:HWND; wPixTypes:Cardinal): Cardinal;
stdcall; external 'Eztwain3.dll'
// Acquires a single image, from the currently selected Data Source, using
// Native Transfer Mode. It waits until the source closes (if it's modal) or
// forces the source closed if not.  The return value is a handle to the
// acquired image.  Only one image can be acquired per call.
//
// The return value is a handle to global memory containing a DIB - 
// a Device-Independent Bitmap.  Numerous EZTWAIN functions can
// be used to examine, modify, and save these DIBs.  Remember to
// use TWAIN_FreeNative to free each DIB when you are done with it,
// these things eat up a lot of memory.
//
// For the 2nd parameter, you can OR or add together the following
// masks to indicate what kind(s) of image you prefer to receive.
// Caution: Some TWAIN devices will ignore your preference here.
// -- If you care, check the parameters of the DIB.

const
        TWAIN_BW = 1;
        TWAIN_GRAY = 2;
        TWAIN_RGB = 4;
        TWAIN_PALETTE = 8;
        TWAIN_CMY = 16;
        TWAIN_CMYK = 32;

        TWAIN_ANYTYPE = 0;

function TWAIN_AcquireToClipboard(hwndApp:HWND; wPixTypes:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// Like AcquireNative, but puts the resulting image, if any, into the
// system clipboard as a CF_DIB item. If this call fails, the clipboard is
// either empty or retains its previous content.
// Returns TRUE(1) for success, FALSE(0) for failure.
//
// Useful for environments like Visual Basic where it is hard to make direct
// use of a DIB handle.  In fact, TWAIN_AcquireToClipboard uses
// TWAIN_AcquireNative for all the hard work.

function TWAIN_AcquireMemory(hwnd:HWND): Cardinal;
stdcall; external 'Eztwain3.dll'
// Like TWAIN_Acquire, but always specifies a 'memory mode' transfer.

// Functions to do a memory transfer in individual blocks:
function TWAIN_BeginAcquireMemory(hwnd:HWND; nRows:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Begin a memory transfer.
// Returns TRUE(1) if the transfer is ready to proceed (using
// TWAIN_AcquireMemoryBlock, below.)
// Returns FALSE(0) if the transfer could not be started for some reason.
//
// Loads TWAIN if necessary, opens the default source if no source is open.
// If it opens a source, it negotiates any 'pending' settings (resolution,
// pixel type, etc.) that were specified before the device was open.
// Enables the device if not already enabled.
// Waits for a 'transfer ready' message from the device.
// Tells the driver to begin transferring in blocks of nRows rows or less.
// If nRows is <= 0, lets the driver pick the optimal block size.

function TWAIN_AcquireMemoryBlock: HANDLE;
stdcall; external 'Eztwain3.dll'
// Acquire the next block of data in a memory transfer.
// If there is an error or there is no more data, returns NULL(0).
// Only valid after a successful call to TWAIN_BeginAcquireMemory (above.)
// Asks the device to deliver another block of pixels, and returns
// those pixels as a DIB represented by its handle.  This is the same
// image format returned by TWAIN_AcquireNative, TWAIN_AcquireMemory, etc.
// See the DIB_* functions for what can be done with the returned handle.

function TWAIN_EndAcquireMemory: BOOL;
stdcall; external 'Eztwain3.dll'
// Clean up after a block-by-block memory transfer.
// Only valid after a successful call to TWAIN_BeginAcquireMemory (above.)
// Frees any temporary storage, and tells the device the transfer
// is over.  In Multi-transfer mode, the device will move to
// State 6 if more images are available, or State 5 if not.
// In single-transfer mode (the default) the device is automatically closed.


function TWAIN_AcquireToFilename(hwndApp:HWND; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Acquire an image and save it to a file.
// If the filename is NULL or an empty string, the user is prompted for
// the file name using a standard Save File dialog.
//
// The minimal use of EZTwain is to call this function with both arguments NULL (0).
//
// If the filename passed as a parameter or entered by the user contains a
// standard extension (.bmp, .jpg/.jpeg, .tif/.tiff, .png, .pdf, .gif, .dcx)
// then the file is saved in the implied format.
// Otherwise the file is saved in the current SaveFormat - see TWAIN_SetSaveFormat.

// See also TWAIN_AcquireFile below.
//
// Return values:
//   0  success.
//  -1  the Acquire failed.
//  -2  file open error (invalid path or name, or access denied)
//  -3  invalid DIB, or image incompatible with file format, or...
//  -4  writing failed, possibly output device is full.
// -10  user cancelled File Save dialog


function TWAIN_AcquireMultipageFile(hwndApp:HWND; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Acquire (scan) all available images to a multipage file.
// If the filename is NULL or points to the null string, the user is
// prompted for the filename.
// If the filename ends with ".tif", ".tiff", or
// ".mpt" the file is written in TIFF format.
// If the filename ends with ".pdf" the file is written in PDF format.
// Otherwise, the default multipage format is used, as set by SetMultipageFormat.
// If it has not been set, the default multipage format is TIFF.
//
// If scanning fails or is cancelled before the first writable page
// is received, no file action is taken: The output filename is not prompted for,
// the file is not created, if it exists it is not touched.
//
// The function TWAIN_MultipageCount can be called during or after
// writing a multipage file, it reports the number of images written to the file.
// See also TWAIN_AcquireCount and TWAIN_BlankDiscardCount for other info.
//
// Return values:
//   0  success
//  -1  the Acquire failed, or the device closed or quit after 0 pages.
//      If 0 pages were written but no other error was diagnosed,
//      TWAIN_LastErrorCode will be EZTEC_0_PAGES.
//  -2  file open error (invalid path or name, or access denied)
//  -3  could not load file-format module (EZTiff.dll or EZPdf.dll)
//      Either the DLL was not found, or the version is out-of-date,
//      For PDF output, EZJpeg.dll is also required.
//      Less likely: The device returned an invalid DIB handle, or
//      the transferred image has a bit depth of 9..15 bits per pixel (??)
//  -4  writing failed, possibly output device is full.
//  -7  Multipage support is not installed.
// -10  user cancelled - This can be during the filename prompt, if you
//      did not supply a filename, or it can be when the scanner dialog
//      is first displayed.  If the scanner dialog is visible, the user
//      can cancel during a scan and the dialog will just stay open (usually)
//      allowing another try.  If the user closed the scan dialog without
//      scanning, TWAIN_LastErrorCode will be EZTEC_USER_CANCEL.
//
// This function respects TWAIN_SetHideUI as follows:
// If SetHideUI(1), then the device UI is hidden, AcquireMultipageFile
// will transfer images until the device indicates that it has no
// more images ready.  (Technically, it goes to State 5).
// Exception: If a device seems to be one-image-at-a-time (such as a flatbed)
// the user will be asked if they want to acquire another image.
//
// If SetHideUI(0) [the default case] then the device UI is shown,
// and AcquireMultipageFile will transfer images until the user
// closes the device dialog.
//
// This function respects SetMultiTransfer() as follows:
// If SetMultiTransfer(1), the DS is left open on return.
// Otherwise (the default case), the DS is closed and TWAIN is unloaded.
//
// If you want to set scanning parameters (resolution, pixeltype...)
// first open the source (see OpenDefaultSource or OpenSource)
// then negotiate the settings using the Capability functions, and
// then call AcquireMultipageFile.
//
// Caution: It is not recommended to use this function on webcams
// if the UI is hidden.  Some will crash, others may supply images
// endlessly (until disk full.)

function TWAIN_AcquireImagesToFiles(hwndApp:HWND; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Similar to TWAIN_AcquireMultipageFile above, but writes each
// image to a separate file.  The format of the output files is
// determined by the extension of the filename, as with AcquireToFilename.
//
// If the filename is NULL or points to the null string, the user is
// prompted for the name of the first file.
//
// Files after the first are given names 'incremented' from the name
// of the first file according to this pattern:
// document.pdf increments to document1.pdf
// document99.pdf increments to document100.pdf
// document0001.tif increments to document0002.tif.
//
// Return values:
// IMPORTANT: If successful, returns the number of files written.
// Note that this could be 0 if the scanner dialog is displayed and
// the user closes the dialog without any scans.
// Otherwise, return value same as TWAIN_AcquireMultipageFile, and
// details available from TWAIN_LastErrorCode & related functions.
// 
// See also: TWAIN_AcquiredFileCount
//           TWAIN_AcquireCount
//           TWAIN_BlankDiscardCount.

function TWAIN_AcquirePagesToFiles(hwnd:HWND; nPPF:Integer; sFile:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Similar to AcquireImagesToFiles, but can acquire duplex or multipage files.
//
// hwnd     = parent window. Use 0 (NULL) if you can't obtain the window handle.
//
// nPPF     = *pages* per file.
//            If the scanner is scanning duplex, 1 page = 2 images
//            otherwise 1 page = 1 image.
//
// pzFile   = filename.  We recommend including the extension to specify the format.
//            If the filename is NULL or points to the empty string, the user is
//            prompted for the name of the first file.
//
// Return: If successful, returns the number of files written.
// Otherwise, same as TWAIN_AcquireMultipageFile, with
// details available from TWAIN_LastErrorCode & related functions.

function TWAIN_AcquiredFileCount: Integer;
stdcall; external 'Eztwain3.dll'
// Returns the number of files successfully written by the last call to
// TWAIN_AcquireImagesToFiles or TWAIN_AcquirePagesToFiles.


function TWAIN_AcquireCompressed(hwndApp:HWND): HANDLE;
stdcall; external 'Eztwain3.dll'
// Acquire the next available image from the open (or default) device,
// accepting a compressed memory transfer if one is selected.
// (Use TWAIN_SetCompression to select the compression algorithm.)
// 
// The DIB handle which is returned will normally reference a compressed
// DIB, which is acceptable to very few other EZTwain functions.
// See also: DIB_IsCompressed
//
// Recommended use of this function:
// Open a device with TWAIN_OpenSource or TWAIN_OpenDefaultSource.
// Set any other scanning parameters such as PixelType, resolution, etc.
// Select memory transfer mode, using TWAIN_SetXferMech.
// Select a compression algorithm, using TWAIN_SetCompression.
// Call this function (possibly in a loop) to acquire images.


function TWAIN_AcquireCount: Integer;
stdcall; external 'Eztwain3.dll'
// Returns the number of images acquired by the last call to
// TWAIN_AcquireMultipageFile, TWAIN_AcquireImagesToFiles,
// or TWAIN_AcquirePagesToFiles.
//
// This includes only "keeper" pages - it *excludes*
// any discarded blank pages, separator pages, etc.
//
// Therefore it may differ from the value of TWAIN_MultipageCount.

function TWAIN_SetDefaultScanAnotherPagePrompt(fYes:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Controls an aspect of TWAIN_AcquireMultipageFile - When used
// with a non-feeder device, with UI suppressed, that function
// asks the user if they want to scan another page, [Yes] or [No].
// This function controls which answer is the default:
// fYes = 1         [Yes] is the default button/answer*
// fYes = 0         [No] is the default button/answer.
//
// * EZTwain initial setting.
//  
// Return value: Previous value of the setting.

function TWAIN_AcquireFile(hwndApp:HWND; nFF:Integer; sFileName:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Acquire an image directly to a file, using the given format and filename.
// * Unlike AcquireToFilename, this function uses TWAIN File Transfer Mode.
// * The image is written to disk by the Data Source, not by EZTWAIN.
// * Warning: This mode is -not- supported by all TWAIN devices.
// 
// Use TWAIN_SupportsFileXfer to see if the open DS supports File Transfer.
//
// You can use TWAIN_Get(ICAP_IMAGEFILEFORMAT) to get an enumeration of
// the available file formats, and CONTAINER_ContainsValue to check for
// a particular format you are interested in.
//
// nFF can be any file format supported by the DS, see the TWFF_* constants
// in twain.h for the list of allowed formats.  A compliant DS should
// at least support TWFF_BMP, but as usual there are no guarantees.
//
// If the filename is NULL or an empty string, the user is prompted for
// the file name in a standard Save File dialog.
//
// Return values (N.B. A Boolean, not an error code like AcquireToFilename!)
//  TRUE(1) for success
//  FALSE(0) for failure - use GetResultCode/GetConditionCode for details.
//  If the user cancels the Save File dialog, the result code is TWRC_CANCEL

function TWAIN_DoSettingsDialog(hwnd:HWND): Integer;
stdcall; external 'Eztwain3.dll'
// Run the device's settings dialog, if this is supported, and return
// when the user closes the dialog.  See return codes below.
//
// If a device is open, work with that device.  If no device is currently
// open, work with the default device.  (See GetDefaultSourceName)
// This is an *optional* TWAIN feature - To check if a device supports this,
// open the device and call TWAIN_GetCapBool(CAP_ENABLEDSUIONLY, FALSE) -
// if that call returns TRUE(1) then this feature is supported.
// Return values:
//    1     dialog was displayed and user clicked OK
//    0     dialog was displayed and user clicked Cancel
//   -1     dialog not displayed - some error.  Call LastErrorCode,
//          ReportLastError, or similar function for more details.

function TWAIN_EnableSourceUiOnly(hwnd:HWND): BOOL;
stdcall; external 'Eztwain3.dll'
// The underlying 'asynchronous' function for TWAIN_DoSettingsDialog.
// Opens the device's settings dialog, if this is supported.
// Returns TRUE (1) if successful, FALSE (0) otherwise.
// NOTE: If successful, this call leaves the dialog open, so your
// program must run a message pump at least until the user closes it.
// If you don't understand what that means, don't call this guy.

//--------- Global Options

procedure TWAIN_SetMultiTransfer(bYes:BOOL);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetMultiTransfer: BOOL;
stdcall; external 'Eztwain3.dll'
// This function controls the 'multiple transfers' flag.
// By default, this feature is set to FALSE (0).
//
// If this flag is zero, the input device is closed when
// any TWAIN_AcquireXXX function finishes.
//
// If this flag is non-zero: After an Acquire, the input device
// is not closed, but is left open to allow additional images
// to be acquired.  In this case the programmer should
// close the input device after all images have been
// transferred, by calling either
//     TWAIN_CloseSource or
//     TWAIN_UnloadSourceManager
//
// See also: TWAIN_UserClosedSource()

function TWAIN_WaitForImage(hwnd:HWND): BOOL;
stdcall; external 'Eztwain3.dll'
// ** Experimental - Use with caution **
//
// Returns TRUE(1) if TWAIN device is ready to deliver an image.
//   -- TWAIN_State() will be 6 in this case.
// Returns FALSE(1) if the application should stop acquiring and close the DS.
//
// If no device is open, the default device is opened.
// If the device is interacting with the user, waits for the user
// to either start a transfer, or close the device dialog.
// This function is primarily useful for multiple transfers, in loops like:
//     IF TWAIN_OpenDefaultSource() AND NegotiateSettings() THEN
//         WHILE TWAIN_WaitForImage(hwnd)
//             TWAIN_AcquireToFilename(hwnd, filename)
//             increment(filename)
//         END WHILE
//         TWAIN_CloseSource()
//     END IF

procedure TWAIN_SetHideUI(bHide:BOOL);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetHideUI: BOOL;
stdcall; external 'Eztwain3.dll'
// These functions control the 'hide source user interface' flag.
// This flag is cleared initially, but if you set it non-zero, then when
// a device is enabled it will be asked to hide its user interface.
// Note that this is only a request - some devices will ignore it!
// This affects AcquireNative, AcquireToClipboard, and EnableSource.
// If the user interface is hidden, you will probably want to set at least
// some of the basic acquisition parameters yourself - see
// SetUnits, SetPixelType, SetBitDepth and SetResolution below.
// See also: HasControllableUI

procedure TWAIN_DisableParent(bYes:BOOL);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetDisableParent: BOOL;
stdcall; external 'Eztwain3.dll'
// Set or get the "DisableParent" flag.
// When this flag is set (non-zero), EZTwain attempts to
// disable the parent window during any Acquire function.
// (The parent window is the window you pass to the Acquire function.
// Typically this is your main application window or dialog.)
// This flag is TRUE (1) by default.
//
// Note 1: If you set this to FALSE, your window can receive user input while
// an Acquire is in progress, and your code must be prepared for this.
// Note 2: Some TWAIN data sources will disable the parent window on their
// own, and EZTWAIN cannot prevent this.


//--------- Basic TWAIN Inquiries

function TWAIN_EasyVersion: Integer;
stdcall; external 'Eztwain3.dll'
// Returns the version number of EZTWAIN.DLL, multiplied by 100.
// So e.g. version 2.01 will return 201 from this call.
function TWAIN_EasyBuild: Integer;
stdcall; external 'Eztwain3.dll'
// Returns the build number within the version.

function TWAIN_IsAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// Call this function any time to find out if TWAIN is installed on the
// system.  It takes a little time on the first call, after that it's fast,
// just testing a flag.  It returns 1 if the TWAIN Source Manager is
// installed & can be loaded, 0 otherwise. 

function TWAIN_IsMultipageAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if EZTwain 'multipage' services are installed.
// This allows writing of multipage TIFF (if TIFF is available)
// and multipage PDF (if PDF is available).
// It also enables TWAIN_AcquireMultipageFile

function TWAIN_State: Integer;
stdcall; external 'Eztwain3.dll'
// Returns the TWAIN Protocol State per the spec.
const
        TWAIN_PRESESSION = 1;
        TWAIN_SM_LOADED = 2;
        TWAIN_SM_OPEN = 3;
        TWAIN_SOURCE_OPEN = 4;
        TWAIN_SOURCE_ENABLED = 5;
        TWAIN_TRANSFER_READY = 6;
        TWAIN_TRANSFERRING = 7;

function TWAIN_IsDone: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if there is a device open, and it is in
// the state that indicates that no more scans should be requested
// at this time.  This call can be used as the test at the *bottom*
// of a do-until loop, for multipage scanning:
//   If TWAIN_OpenDefaultSource() Then
//      TWAIN_SetMultiTransfer(1)
//      Do
//         TWAIN_AcquireToFilename(0, NextFileName())
//      Until TWAIN_IsDone()
//      TWAIN_CloseSource()
//   End If
//

function TWAIN_SourceName: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Returns a pointer to the name of the currently or last opened source.

procedure TWAIN_GetSourceName(sName:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Like TWAIN_SourceName, but copies current/last source name into its parameter.
// The parameter is a string variable (char array in C/C++).
// You are responsible for allocating room for 33 8-bit characters
// in the string variable before calling this function.

//--------- DIB handling utilities ---------

function DIB_Depth(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_BitsPerPixel(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// 'depth' of image - number of bits used to store one pixel

function DIB_PixelType(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// TWAIN PixelType that describes this DIB: TWPT_BW, TWPT_GRAY, TWPT_RGB,
// TWPT_PALETTE, TWPT_CMYK, TWPT_CMY, etc.

function DIB_Width(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Width of DIB, in pixels (columns)
function DIB_Height(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Height of DIB, in lines (rows)

procedure DIB_SetResolution(hdib:Cardinal; xdpi:Double; ydpi:Double);
stdcall; external 'Eztwain3.dll'
procedure DIB_SetResolutionInt(hdib:Cardinal; xdpi:Integer; ydpi:Integer);
stdcall; external 'Eztwain3.dll'
// Sets the horizontal and vertical resolution of the DIB.

function DIB_XResolution(hdib:Cardinal): Double;
stdcall; external 'Eztwain3.dll'
// Horizontal (x) resolution of DIB, in DPI (dots per inch)
function DIB_YResolution(hdib:Cardinal): Double;
stdcall; external 'Eztwain3.dll'
// Vertical (y) resolution of DIB, in DPI (dots per inch)

function DIB_XResolutionInt(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_YResolutionInt(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Return the nearest integer value to the x or y resolution of an image.

// Physical or 'implied' image size
function DIB_PhysicalWidth(hdib:Cardinal; nUnits:Integer): Double;
stdcall; external 'Eztwain3.dll'
function DIB_PhysicalHeight(hdib:Cardinal; nUnits:Integer): Double;
stdcall; external 'Eztwain3.dll'
// Return the width(height), in the specified units, of the given
// image, calculated using its pixel width(height) and X(Y) resolution.
// If the resolution is 0, these functions return 0.
// nUnits is one of the TWUN_ values - see TWAIN_GetCurrentUnits.
// nUnits=0 is inches, and nUnits=1 is centimeters(cm).

function DIB_RowBytes(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Number of bytes needed to store one row of the DIB.

function DIB_ColorCount(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Number of colors in color table of DIB.
// Primarily useful for B&W, gray, and palette images.
// 16-bit gray, RGB, CMY & CMYK images have no color table: DIB_ColorCount returns 0

function DIB_SamplesPerPixel(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Number of 'samples' or components or color channels in each pixel.
// B&W and gray pixels have 1 sample, RGB and CMY have 3.
// CMYK has 4, and palette-color images are treated as having 3 channels.

function DIB_BitsPerSample(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Number of bits per 'channel'.  For B&W and gray images this is
// the same as the DIB_Depth, because those formats have only one channel.
// For palette images, this will be 8, because the color values in a
// palette image are stored with 8 bits each for R, G, and B.
// For RGB, CMY, and CMYK images, this function returns the number of bits
// used to represent each color channel or component - almost always 8, but
// EZTwain has a limited ability to handle 16-bit per channel images.

function DIB_IsCompressed(hdib:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// Return 1(True) if image is compressed in memory 0(False) otherwise.

function DIB_Compression(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Return the TWCP_xxx code representing the compression algorithm
// of this image.  Uncompressed images yield TWCP_NONE.



function DIB_Size(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Return the size in memory of the given DIB.

procedure DIB_ReadData(hdib:Cardinal; pdata:Pointer; nbMax:Integer);
stdcall; external 'Eztwain3.dll'
// Read up to nbMax bytes from the given DIB into the given buffer.
// The data is read 'verbatim' from the first byte of the DIB.
// To read pixel data, see DIB_ReadRowxxx below.

procedure DIB_ReadRow(hdib:Cardinal; r:Integer; prow:Pointer);
stdcall; external 'Eztwain3.dll'
procedure DIB_ReadRowRGB(hdib:Cardinal; r:Integer; prow:Pointer);
stdcall; external 'Eztwain3.dll'
procedure DIB_ReadRowGray(hdib:Cardinal; r:Integer; prow:Pointer);
stdcall; external 'Eztwain3.dll'
procedure DIB_ReadRowChannel(hdib:Cardinal; r:Integer; prow:Pointer; nChannel:Integer);
stdcall; external 'Eztwain3.dll'
procedure DIB_ReadRowSample(hdib:Cardinal; r:Integer; prow:Pointer; nSample:Integer);
stdcall; external 'Eztwain3.dll'
// Read row r of the given DIB into buffer at prow.
// Caller is responsible for ensuring buffer is large enough.
// ReadRowRGB always reads 3 bytes (24 bits) for each pixel,
// ReadRowGray and ReadRowChannel always read 1 byte (8 bits) per pixel.
// Row 0 is the *top* row of the image, as it would be displayed.
// The first variant reads the data exactly as-is from the DIB, including
// BGR pixels from 24-bit DIBs, 16-bit grayscale, 1-bit B&W, etc.
// The RGB variant unpacks every DIB pixel into 3-byte RGB pixels.
// The Gray variant converts every pixel to its 8-bit gray value.
// Channel codes are: 0=Gray(Luminance), 1=Red, 2=Green, 3=Blue.  See
// 'Component codes' below.
// Samples are the bytes of the pixel: A grayscale pixel has sample 0,
// an RGB image has samples 0, 1 and 2 (which are actually Green, Red and Blue).

procedure DIB_ReadPixelRGB(hdib:Cardinal; x:Integer; y:Integer; buffer:Pointer);
stdcall; external 'Eztwain3.dll'
procedure DIB_ReadPixelGray(hdib:Cardinal; x:Integer; y:Integer; buffer:Pointer);
stdcall; external 'Eztwain3.dll'
procedure DIB_ReadPixelChannel(hdib:Cardinal; x:Integer; y:Integer; buffer:Pointer; nChannel:Integer);
stdcall; external 'Eztwain3.dll'
// Read the value of the pixel at column x row y of the DIB into the buffer.
// RGB form reads 3 bytes R,G,B
// Gray form reads 1 byte of 'equivalent gray'
// Channel form reads 1 byte of channel/component, see COMPONENT_xxx codes.


procedure DIB_WriteRow(hdib:Cardinal; r:Integer; pdata:Pointer);
stdcall; external 'Eztwain3.dll'
// Write data from buffer into row r of the given DIB.
// Caller is responsible for ensuring buffer and row exist, etc.

procedure DIB_WriteRowChannel(hdib:Cardinal; r:Integer; pdata:Pointer; nChannel:Integer);
stdcall; external 'Eztwain3.dll'
// Write data from buffer into one color channel of row r of the given DIB.
// This function should only be used on 24-bit RGB, 32-bit RGBA, 24-bit CMY,
// 32-bit CMYK, or 8-bit grayscale images.  Its behavior on any other image is undefined.
// Channels are: 0=gray, 1=Red, 2=Green, 3=Blue, 4=Alpha or
// 1=C, 2=M, 3=Y, 4=K.

procedure DIB_WriteRowSample(hdib:HANDLE; r:Integer; psrc:Pointer; nSample:Integer);
stdcall; external 'Eztwain3.dll'
// Write row of data into one sample of an image.
// Only handles 8-bit data and images with 1 or more samples of 8 bits each.
// Channels are somewhat logical properties of an image, samples are
// just the bytes in a pixel - sample 0 is byte 0, sample 1 is byte 1, etc.

// Safe versions of ReadRow and WriteRow, handy for .NET languages
procedure DIB_WriteRowSafe(hdib:HANDLE; r:Integer; pdata:Pointer; nbMax:Integer);
stdcall; external 'Eztwain3.dll'
procedure DIB_ReadRowSafe(hdib:HANDLE; nRow:Integer; prow:Pointer; nbMax:Integer);
stdcall; external 'Eztwain3.dll'

function DIB_Allocate(nDepth:Integer; nWidth:Integer; nHeight:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Create a DIB with the given dimensions.  Resolution is set to 0.  A default
// color table is provided if depth <= 8.
// The image data is uninitialized i.e. garbage.

function DIB_Create(nPixelType:Integer; nWidth:Integer; nHeight:Integer; nDepth:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Create a DIB of the given pixel type and dimensions.
// If nDepth <= 0, uses the default depth for the given pixel type.
// Resolution is set to 0.
// For TWPT_GRAY images, a standard black-to-white color table is set.
// For TWPT_PALETTE images, a Windows-standard 256-entry color table is set.

procedure DIB_Free(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'
// Release the storage of the DIB.

function DIB_InUseCount: Integer;
stdcall; external 'Eztwain3.dll'
// Return the number of DIBs 'outstanding' - allocated but not disposed of.
// Note that a DIB that is put on the clipboard becomes the property of the
// clipboard and is considered 'disposed of'.
// This function can be used to detect leaks in application DIB management.

function DIB_Copy(hdib:Cardinal): Cardinal;
stdcall; external 'Eztwain3.dll'
// Create and return a byte-for-byte copy of a DIB.

function DIB_Equal(hdib1:Cardinal; hdib2:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if the two dibs are valid, have the same parameters,
// and are the same color pixel-for-pixel.

function DIB_MaxError(hdib1:Cardinal; hdib2:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// return the largest difference between two samples in the two images.

procedure DIB_SetGrayColorTable(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'
// Fill the DIB's color table with a gray ramp - so color 0 is black, and
// the last color (largest pixel value) is white.  No effect if depth > 8.
procedure DIB_SetColorTableRGB(hdib:Cardinal; i:Integer; R:Integer; G:Integer; B:Integer);
stdcall; external 'Eztwain3.dll'
// Set the ith entry in the DIB's color table to the specified color.
// R G and B range from 0 to 255.

function DIB_IsVanilla(hdib:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// TRUE if in this DIB, pixel value 0 means 'white'.
function DIB_IsChocolate(hdib:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// TRUE if in this DIB, pixel value 0 means 'black'.

function DIB_ColorTableR(hdib:Cardinal; i:Integer): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_ColorTableG(hdib:Cardinal; i:Integer): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_ColorTableB(hdib:Cardinal; i:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return the R,G, or B component of the ith color table entry of a DIB.
// If i < 0 or >= DIB_ColorCount(hdib), returns 0.

procedure DIB_FlipVertical(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'
// Flip (mirror) the bitmap vertically.
// Top and bottom rows are exchanged, etc.

procedure DIB_FlipHorizontal(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'
// Flip (mirror) the bitmap horizontally.
// Leftmost pixels become rightmost, etc.

procedure DIB_Rotate180(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'
// Rotate image 180 degrees

function DIB_Rotate90(hOld:Cardinal; nSteps:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Return a copy of hOld rotated clockwise nSteps * 90 degrees.
// If nSteps is 0, the result is a copy of hOld.
// Negative values of nSteps rotate counterclockwise.
// Note that *hOld is not destroyed*

procedure DIB_Fill(hdib:Cardinal; R:Integer; G:Integer; B:Integer);
stdcall; external 'Eztwain3.dll'
// Fill the DIB with the specified color

procedure DIB_Negate(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'

procedure DIB_AdjustBC(hdib:Cardinal; nB:Integer; nC:Integer);
stdcall; external 'Eztwain3.dll'
// *** BETA - new in 3.08b8 - use with caution.
// Adjust the brightness and/or contrast of the image.
// nB and nC are -1000 to 1000, with a value of 0 meaning 'no change'.
// Positive nB push all pixels toward white, negative toward black.
// Positive nC push all pixels away from mid-value, toward black and white.
// Negative nC pushes all pixels toward the mid-value.
// Works on grayscale, RGB, CMY(K) images - no effect on B&W and palette.

function DIB_AutoContrast(hdib:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// Automatically adjust the values in the image to make
// the dominant light color into white, and the primary dark tone into black.

procedure DIB_Convolve(hdibDst:Cardinal; hdibKernel:Cardinal; dNorm:Double; nOffset:Integer);
stdcall; external 'Eztwain3.dll'
// Apply hdibKernel as a convolution kernel to hdibDst.
// At each pixel in hdibDst, hdibKernel is convolved with the neighborhood
// and the result is stored back into hdibDst.
// The point value of the convolution is normalized by dividing by dNorm, and
// then nOffset is added, before clipping to the pixel range of hdibDst.

procedure DIB_Correlate(hdibDst:Cardinal; hdibKernel:Cardinal);
stdcall; external 'Eztwain3.dll'
// Similar to DIB_Convolve, but performs a correlation between hdibDst and hdibKernel,
// assuming that hdibKernel is image data (preferably grayscale), and putting
// the result into hdibDst.

procedure DIB_CrossCorrelate(hdibDst:Cardinal; hdibTemplate:Cardinal; dScale:Double; nMin:Integer);
stdcall; external 'Eztwain3.dll'
// Similar to DIB_Convolve, but performs a cross-correlation between hdibDst and hdibTemplate,
// assuming that hdibTemplate is grayscale image data, and putting
// the result into hdibDst.  In the output, a value of 255 signifies perfect correlation,
// 0 signifies perfect non-correlation (actually, a perfect opposite).
// All output values are divided by dScale.
// If nMin > 0, the correlation at each output pixel stops as soon as the value at that
// pixel is known to be <= nMin.  If you know that the values of interest are (say) > 200,
// setting a dMin of 128 can speed up the correlation greatly.

procedure DIB_HorizontalDifference(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'

procedure DIB_HorizontalCorrelation(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'
procedure DIB_VerticalCorrelation(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'

procedure DIB_MedianFilter(hdib:Cardinal; W:Integer; H:Integer; nStyle:Integer);
stdcall; external 'Eztwain3.dll'
// Apply a median filter to hdib using an W x H neighborhood.
// nStyle is currently ignored, but should be 0 for future compatibility.

procedure DIB_MeanFilter(hdib:Cardinal; W:Integer; H:Integer);
stdcall; external 'Eztwain3.dll'
// Replace each pixel with the average of a W x H pixel neighborhood.
// We recommend you use odd value for W and H.

procedure DIB_Smooth(hdib:Cardinal; sigma:Double; opacity:Double);
stdcall; external 'Eztwain3.dll'
// Apply a (gaussian) smoothing filter to the image.
// sigma is the controlling parameter of the Gaussian
// G(x,y) = exp(-(x^2+y^2) / 2*sigma^2) / (2 * pi * sigma^2)
// opacity is the fraction of the filter output that is blended
// back into the image i.e. out = in*(1-opacity) + f(in)*opacity

function DIB_ScaledCopy(hOld:Cardinal; w:Integer; h:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Create and return a new image - which is a copy of hOld
// but scaled (resampled) to have width w and height h.
// The input image must be of type TWPT_BW, TWPT_GRAY, or TWPT_RGB.
// If the input image is of type TWPT_BW, the returned image will be
// 8-bit grayscale.
// Otherwise the output image has the same type and depth as the input.
// *Don't forget to DIB_Free the old DIB when you are done with it.

function DIB_Resample(hOld:Cardinal; xdpi:Double; ydpi:Double): Cardinal;
stdcall; external 'Eztwain3.dll'
// Return a new image which is a copy of the old image, but resampled
// to the specified resolution.
// "Resampling" is the technical term for recomputing the pixels of
// an image, when you want to change the number of pixels in the image
// but not the physical size (like 8.5" x 11").
// If you resample from 300DPI to 100DPI, you will have 1/3 as many rows,
// 1/3 as many columns, 1/9 as many pixels - but the pixels will be
// marked in the image as being 3 times as 'wide' and 'tall' - so the
// physical size of the image stays the same.
// This is the same as DIB_ScaledCopy, just looked at in a different way.
// DIB_Resample will fail if the input image as either resolution <= 0,
// or if either xdpi or ydpi is <= 0.  It can also fail with insufficient memory.
// Remember to DIB_Free the old DIB when you are done with it.

function DIB_RegionCopy(hOld:Cardinal; leftx:Integer; topy:Integer; w:Integer; h:Integer; FillByte:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Create and return a portion of DIB hOld.  The copied region is a rectangle
// w pixels wide, h pixels high, starting at (x, y) in the hOld image,
// where (0,0) is the upper-left corner of hOld, visually.
// Pixels that don't fit into the new DIB are discarded.
// (So this function can be used to crop an image.)
// If the new DIB is taller or wider than the old, the new
// pixels are filled with bytes = fill.  Common values for
// fill are:
//      -1 (or 255 or 0xFF) which fills with 1's producing white
//   0 which produces black fill.

function DIB_AutoCrop(hOld:Cardinal; nOptions:Integer): HANDLE;
stdcall; external 'Eztwain3.dll'
// Return a copy of the image in hOld, with the surrounding border
// of uniform color (if there is one) removed.
// Uses RegionCopy (above).
// After this call, remember to DIB_Free(hOld) if you don't need it.
// nOptions is currently unused and must be 0 (zero).

const
        AUTOCROP_DARK = 1;
        AUTOCROP_LIGHT = 2;
        AUTOCROP_EDGE = 4;

function DIB_GetCropRect(hdib:Cardinal; nOptions:Integer; var cropx:Integer; var cropy:Integer; var cropw:Integer; var croph:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Return a suggested crop rectangle to remove a dark border from the image.
// The rectangle is defined by an upper-left point and a width and height, in pixels.
// (As needed by DIB_RegionCopy above.)
// nOptions is currently unused and must be 0.
// DIB_AutoCrop uses this function to decide what to crop.
// A return of FALSE means no crop rectangle was found - generally this means
// that the image has content that extends to the edges, or has no definite borders
// of dark color.  For convenience, when this function returns FALSE it
// still returns a valid crop rectangle containing the entire image.

function DIB_AutoDeskew(hOld:Cardinal; nOptions:Integer): HANDLE;
stdcall; external 'Eztwain3.dll'
// Returns a copy of the image in hOld, possibly 'deskewed'.
// If it can be determined that the input image is consistently
// skewed (rotated by a small angle) then the returned image is rotated
// to eliminate that skew.
// The depth and pixel type of the image are not changed.
// The dimensions of the returned image may be slightly changed.
// nOptions is currently unused and must be 0 (zero).

function DIB_DeskewAngle(hdib:Cardinal): Double;
stdcall; external 'Eztwain3.dll'
// Compute and return the small clockwise rotation that would best
// 'deskew' the given image.  The return value is that angle
// in radians.  Only rotations in the range +-4 degrees are considered.

procedure DIB_SkewByDegrees(hdib:Cardinal; dAngle:Double);
stdcall; external 'Eztwain3.dll'
// Skew the given image clockwise in place by the specified angle (in degrees)

function DIB_ConvertToPixelType(hOld:Cardinal; nPT:Integer): HANDLE;
stdcall; external 'Eztwain3.dll'
// Create and return a new DIB containing the hOld image converted
// to the specified pixel type.  Supported pixel types are:
// TWPT_BW, TWPT_GRAY, TWPT_RGB, TWPT_PALETTE, TWPT_CMY or TWPT_CMYK.
// When converting to black & white (TWPT_BW) the default conversion
// is simple thresholding - each pixel is converted to grayscale,
// then values 0..127 => Black, 128..255 => White.

function DIB_ConvertToFormat(hOld:Cardinal; nPT:Integer; nBPP:Integer): HANDLE;
stdcall; external 'Eztwain3.dll'
// Create and return a new DIB containing the hOld image converted
// to the specified pixel type and bits per pixel.
// Unsupported and impossible combinations cause a NULL return.

function DIB_SmartThreshold(hdib:Cardinal): Cardinal;
stdcall; external 'Eztwain3.dll'
// Apply automatic, adaptive thresholding to hdib, return
// the resulting 1-bit image.  This function is optimized for
// thresholding scanned text.
// ** Remember to free the input image if you are done with it.

function DIB_SimpleThreshold(hdib:Cardinal; nT:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Threshold hdib against nT and return the resulting 1-bit image.
// nT should be in the range 0 to 255.
// Pixels that are darker than nT become black in the output,
// pixels that are equal to or lighter than nT become white.
// ** Remember to free the input image if you are done with it.

function DIB_SetConversionThreshold(nT:Integer): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_ConversionThreshold: Integer;
stdcall; external 'Eztwain3.dll'
// Set/Get the threshold used by DIB_ConvertToPixelType above
// when converting to B&W.  The default value is 128 which means '50%'.
// Pixels lighter than 50% => white, darker => black.
// DIB_SetConversionThreshold returns the previous value of the threshold.

function DIB_FindAdaptiveGlobalThreshold(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Find the adaptive threshold for input image

function DIB_ErrorDiffuse(hdib:Cardinal): Cardinal;
stdcall; external 'Eztwain3.dll'
// Create and return a new DIB containing the input image rendered
// to 1-bit B&W using error diffusion. The input image is not modified.

procedure DIB_SetConversionColorCount(n:Integer);
stdcall; external 'Eztwain3.dll'
function DIB_ConversionColorCount: Integer;
stdcall; external 'Eztwain3.dll'
// Set/Get the number of colors that will be used in the next
// call to DIB_ConvertToPixelType or DIB_ConvertToFormat, if
// the output type is TWPT_PALETTE.

function DIB_ScaleToGray(hdibOld:Cardinal; nRatio:Integer): HANDLE;
stdcall; external 'Eztwain3.dll'
// Create and return a new DIB containing the hdibOld image
// converted to grayscale and reduced in width & height by nRatio.
// Works well on B&W images.

function DIB_Thumbnail(hdibSource:Cardinal; MaxWidth:Integer; MaxHeight:Integer): HANDLE;
stdcall; external 'Eztwain3.dll'
// Return a DIB containing a copy of hdibSource, scaled so that its width
// is no more than MaxWidth, and height is no more than MaxHeight.
// B&W images are converted to grayscale thumbnails.
// Remember to DIB_Free hdibSource and the thumbnail, when you are done with them.

procedure DIB_SwapRedBlue(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'
// For 24-bit DIB only, exchange R and B components of each pixel.

function DIB_CreatePalette(hdib:Cardinal): HPALETTE;
stdcall; external 'Eztwain3.dll'
// Create and return a logical palette to be used for drawing the DIB.
// For 1, 4, and 8-bit DIBs the palette contains the DIB color table.
// For 24-bit DIBs, a default halftone palette is returned.

procedure DIB_SetColorModel(hdib:Cardinal; nCM:Integer);
stdcall; external 'Eztwain3.dll'
function DIB_ColorModel(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
const
        EZT_CM_RGB = 0;
        EZT_CM_GRAY = 3;
        EZT_CM_CMYK = 5;

procedure DIB_SetColorCount(hdib:Cardinal; n:Integer);
stdcall; external 'Eztwain3.dll'

procedure DIB_Blt(hdibDst:Cardinal; dx:Integer; dy:Integer; hdibSrc:Cardinal; sx:Integer; sy:Integer; w:Integer; h:Integer; uRop:Cardinal);
stdcall; external 'Eztwain3.dll'
// Transfer pixels from hdibSrc into hdibDst, starting at
// (dx,dy) in the destination, and (sx,sy) in the source,
// and transferring w columns x h rows.
// Any pixels that fall outside the actual bounds of the source
// and destination DIBs are ignored.
// The operations available are:
const
        EZT_ROP_COPY = 0;
        EZT_ROP_OR = 1;
        EZT_ROP_AND = 2;
        EZT_ROP_XOR = 3;
        EZT_ROP_ANDNOT = $12;

procedure DIB_BltMask(hdibDst:Cardinal; dx:Integer; dy:Integer; hdibSrc:Cardinal; sx:Integer; sy:Integer; w:Integer; h:Integer; uRop:Cardinal; hdibMask:Cardinal);
stdcall; external 'Eztwain3.dll'
// Like DIB_Blt, but hdibMask contains an 8-bit alpha mask that controls
// how hdibSrc and hdibDst pixels are blended.  hdibMask must be the
// same size as hdibSrc, and be 8-bits deep.
// NOTE: The only uRop currently supported is EZT_ROP_COPY

procedure DIB_PaintMask(hdibDst:Cardinal; dx:Integer; dy:Integer; R:Integer; G:Integer; B:Integer; sx:Integer; sy:Integer; w:Integer; h:Integer; uRop:Cardinal; hdibMask:Cardinal);
stdcall; external 'Eztwain3.dll'
// Like DIB_BltMask - but paints a solid color into the destination DIB
// using hdibMask as a mask or stencil.  The mask must be an 8-bit
// grayscale image. The each mask pixel controls how much paint is mixed
// into the corresponding destination pixel: white=100%, black=0%.
// if w == -1 or h == -1 it means "as much as possible"
// NOTE: The only uRop currently supported is EZT_ROP_COPY
// See the User Guide for details.

procedure DIB_DrawLine(hdibDst:Cardinal; x1:Integer; y1:Integer; x2:Integer; y2:Integer; R:Integer; G:Integer; B:Integer);
stdcall; external 'Eztwain3.dll'

procedure DIB_DrawText(hdibDst:Cardinal; sText:PAnsiChar; leftx:Integer; topy:Integer; w:Integer; h:Integer);
stdcall; external 'Eztwain3.dll'
// Draw the text string into the DIB inside the given rectangle.
// If w or h is 0, the rectangle is extended to the bottom or right of the DIB.
// Default height is 14 pixels.  Default typeface is "Arial".
// Default color is black (R=G=B=0)
// See the following functions to override the default text settings.

// The following functions modify the default settings for DIB_DrawText:
procedure DIB_SetTextColor(R:Integer; G:Integer; B:Integer);
stdcall; external 'Eztwain3.dll'

procedure DIB_SetTextAngle(nDegrees:Integer);
stdcall; external 'Eztwain3.dll'
// Set the rotation of text within the drawing rectangle, clockwise.
// NOTE: Currently only multiples of 90 degrees are supported.

procedure DIB_SetTextHeight(nH:Integer);
stdcall; external 'Eztwain3.dll'
// Set the text character height in pixels.
// If you want to set the text height in physical units (inches)
// multiply the physical height in inches by the DIB_YResolution.
// Note! Some files have resolution=0, which can often be treated as 72dpi

procedure DIB_SetTextFace(sTypeface:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Specify a typeface - Use a typeface that is available on the host system,
// or use a standard face such as Arial, MS San Serif, MS Serif.
// You can also specify "Courier" or "Times" as shortcuts for the classic
// fixed-width and serif fonts.

procedure DIB_SetTextFormat(nFlags:Integer);
stdcall; external 'Eztwain3.dll'
// Sets text format according to the following flags.  The default
// format is normal, top, left
const
        EZT_TEXT_NORMAL = $0;
        EZT_TEXT_BOLD = $1;
        EZT_TEXT_ITALIC = $2;
        EZT_TEXT_UNDERLINE = $4;
        EZT_TEXT_STRIKEOUT = $8;
        EZT_TEXT_BOTTOM = $100;
        EZT_TEXT_VCENTER = $200;
        EZT_TEXT_TOP = $0;
        EZT_TEXT_LEFT = $0;
        EZT_TEXT_CENTER = $1000;
        EZT_TEXT_RIGHT = $2000;
        EZT_TEXT_WRAP = $4000;


///////////////////////////////////////////////////////////////////////
// Image viewing services

function DIB_View(hdib:Cardinal; sTitle:PAnsiChar; hwndParent:HWND): Integer;
stdcall; external 'Eztwain3.dll'
// Display the given image in a window with the given title.
// hwndParent is the window handle of the parent window - if you
// use 0 (NULL) for this parameter, EZTwain uses the active window
// of the application if there is one, or no parent window.
// By default, the window contains just an [OK] button.
// The style of the window is a resizable dialog box.
// 0    = the [Cancel] button was pressed.
// 1    = the [OK] button was pressed.

function DIB_SetViewOption(sOption:PAnsiChar; sValue:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Same as TWAIN_SetViewOption.

function DIB_SetViewImage(hdib:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// If the image viewer is open, change the displayed image to this one.

function DIB_IsViewOpen: BOOL;
stdcall; external 'Eztwain3.dll'
// Return True if the image-view window is open, False otherwise.
// Note that the image viewer can be hidden, so it could be open
// and not be visible.

function DIB_ViewClose: BOOL;
stdcall; external 'Eztwain3.dll'
// Close the image viewer window, if it is open.
// Only applies if the image viewer has been opened with the modeless option.
// Same as TWAIN_ViewClose.

procedure DIB_DrawOnWindow(hdib:Cardinal; hwnd:HWND);
stdcall; external 'Eztwain3.dll'
// Draw the DIB on the window.
// The image is scaled to just fit inside the window, while
// keeping the correct aspect ratio.  Any part of the window
// not covered by the image is left untouched (so it will normally
// be filled with the window's background color.)

procedure DIB_DrawToDC(hdib:Cardinal; hDC:HDC; dx:Integer; dy:Integer; w:Integer; h:Integer; sx:Integer; sy:Integer);
stdcall; external 'Eztwain3.dll'
// Draws DIB on a device context.
// You should call CreateDibPalette, select that palette
// into the DC, and do a RealizePalette(hDC) first.

///////////////////////////////////////////////////////////////////////
// Printing services

function DIB_SpecifyPrinter(sPrinterName:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Specify the printer to be used when printing to the 'default printer'
// with the following functions.
// This does not change the user's default printer - it just tells
// EZTwain which printer to use as 'default'.
// Setting the printer name to NULL or the empty string tells EZTwain to
// use the user's default printer as its default printer.

function DIB_EnumeratePrinters: Integer;
stdcall; external 'Eztwain3.dll'
// Return the number of available printers

function DIB_PrinterName(i:Integer): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return the name of the ith available printer, as found
// by a previous call to DIB_EnumeratePrinters.

function DIB_GetPrinterName(i:Integer; PrinterName:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Get the name of the ith available printer, as found by a previous
// call to DIB_EnumeratePrinters.
// You must allocate 256 characters for the printer name, and in many
// languages (especially Basic dialects) you must initialize the
// PrinterName variable with 256 spaces.

procedure DIB_SetPrintToFit(bYes:BOOL);
stdcall; external 'Eztwain3.dll'
function DIB_GetPrintToFit: BOOL;
stdcall; external 'Eztwain3.dll'
// Get/Set the 'Print To Fit' flag.
// When this flag is non-zero, EZTwain reduces the size of images
// to fit within the printer page.  This only affects images that
// are too large to fit on the page.
// By default, this flag is FALSE (0)

function DIB_Print(hdib:Cardinal; sJobname:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Prompt the user with a Print Dialog, then print the DIB.
// Normally prints the DIB at 'actual size' - meaning the resolution
// values are used to convert the width and height from pixels to physical
// units (e.g. inches.)
// If the PrintToFit flag (see DIB_SetPrintToFit) is set and the image
// is larger than the printer page, the image is scaled to fit on the page.
// If the DIB has resolution values of 0, 72 DPI is assumed.
// The image is printed centered on the page.
// Return values:
//   0  success, no error
//  -2  specified printer not recognized or could not be opened
//  -3  invalid DIB handle (null, or DIB has been freed, or isn't a DIB handle)
//  -4  could not start document or start page error during printing
// -10  user cancelled a dialog (probably the Print dialog)

function DIB_PrintNoPrompt(hdib:Cardinal; sJobname:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Identical to DIB_Print, but prints on the default printer with
// default settings - the user is not prompted.


function TWAIN_PrintFile(sFilename:PAnsiChar; sJobname:PAnsiChar; bNoPrompt:BOOL): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_PrintFile(sFilename:PAnsiChar; sJobname:PAnsiChar; bNoPrompt:BOOL): Integer;
stdcall; external 'Eztwain3.dll'
// Print the specified file as a print job with the specified job name.
// If the filename is null or empty, the user is prompted to select a file.
// If the jobname is null or empty, the actual filename is used as the jobname.
// If bNoPrompt is non-zero (True) the job is sent to the default printer,
// If bNoPrompt is zero (False) the user is prompted with the standard Print dialog.

// Printing - Multi-Page
//

function DIB_PrintArray(var ahdib:Cardinal; nCount:Integer; sJobname:PAnsiChar; bNoPrompt:BOOL): Integer;
stdcall; external 'Eztwain3.dll'
// Print the first nCount images in the array ahdib, under the given print-job name.
//
// If the job-name parameter is NULL or the empty string, the application title is used.
// If bNoPrompt is TRUE(non-zero), prints to the default printer without prompting the user,
// If bNoPrompt is FALSE(0) this function displays the standard print dialog.
//
// Return value is same as DIB_Print above.

procedure DIB_SetNextPrintJobPageCount(nPages:Integer);
stdcall; external 'Eztwain3.dll'
// If you are about to call DIB_PrintJobBegin, you can call this function
// *before* calling that one, to set the page count for the next print job.
// This allows the print dialog to enable the page-range controls, so the
// user can designate a range of pages to print.
//
// Do not call this function unless you are calling DIB_PrintJobBegin directly.
//
// A page count of 0 or less means 'unknown page count', which disables
// the page-range controls.
// If you enable print-range selection in the print dialog, EZTwain
// automatically suppresses printing of all non-selected pages.

function DIB_PrintJobBegin(sJobname:PAnsiChar; bUseDefaultPrinter:BOOL): Integer;
stdcall; external 'Eztwain3.dll'
// Begin creating a multi-page print job.
//
// Jobname is the name of the print job.
// The jobname appears in the job-queue of the printer.
// In some environments it also appears on a job-separator
// page that is printed out ahead of each job.
// If Jobname is null or empty, the application title is used.
// (See TWAIN_SetAppTitle)
//
// If bUseDefaultPrinter is true (non-zero) the default printer
// is used, otherwise the user is prompted with a standard Print dialog.
//
// If you have called DIB_SetNextPrintJobPageCount (above) then the print
// dialog will offer the user the option of specifying a range of pages
// to print.  Otherwise that option is disabled and all pages are printed.
//
// If there is already a print job open when this function is called,
// it calls DIB_PrintJobEnd() to close that job before starting the new one.
//
// Return values:
//  0       success
// -2       could not open/access printer
// -4       printing output error
//-10       user cancelled Print dialog

function DIB_PrintPage(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Add a page to the current print job.
//
// Only valid after a successful call to DIB_PrintJobBegin and
// before the matching DIB_PrintJobEnd.
//
// See DIB_Print for more details.
//  0       success
// -3       the DIB is null or invalid
// -4       printing output error
// -5       no print job is open

function DIB_PrintJobEnd: Integer;
stdcall; external 'Eztwain3.dll'
// End the current print job and release it for printing.
// (Some environments will start printing as soon as a page is available.)
//  0       success
// -4       printing output error
// -5       no print job is open

///////////////////////////////////////////////////////////////////////
// Clipboard functions
//
function DIB_PutOnClipboard(hdib:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// Place DIB on the clipboard (format CF_DIB)
// ** IMPORTANT ** After this call, the clipboard owns the
// DIB and you do not - do not attempt any
// further operations on the hdib handle.
// Treat this call just as you would a call to DIB_Free.
// Returns TRUE(1) for success, FALSE(0) otherwise.

function DIB_CanGetFromClipboard: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE(1) if there is something on the clipboard that
// can be delivered as a DIB (by DIB_GetFromClipboard below.)
// Return FALSE(0) if not.

function DIB_GetFromClipboard: Cardinal;
stdcall; external 'Eztwain3.dll'
function DIB_FromClipboard: Cardinal;
stdcall; external 'Eztwain3.dll'
// Create and return a DIB with the contents of the clipboard.
// This is the first step of a 'paste' function for images.
// Returns NULL in case of error, or if no image on clipboard.

// Working with a DIB through a DC
//
function DIB_OpenInDC(hdib:Cardinal; hdc:HDC): Integer;
stdcall; external 'Eztwain3.dll'
procedure DIB_CloseInDC(hdib:Cardinal; hdc:HDC);
stdcall; external 'Eztwain3.dll'

// DIB File I/O
//
function DIB_WriteToFilename(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Write image to file, using format implied by the filename extension.
//
// If the filename is NULL or points to a null string, the user is
// prompted for the filename and format with a standard Windows
// file-save dialog.
//
// If the final filename has a standard extension (.bmp, .jpg, .jpeg, .tif,
// .tiff, .png, .pdf, .gif, .dcx) then the file is saved in that format.
// Otherwise, the current SaveFormat is used - see TWAIN_SetSaveFormat.
//
// Return values:
//       0      success
//      -1      user cancelled File Save dialog
//      -2      file open error (invalid path or name, or access denied)
//      -3      a) image is invalid (null or invalid DIB handle)
//      b) support for the save format is not configured
//      c) DIB format incompatible with save format e.g. B&W to JPEG.
//      -4      writing data failed, possibly output device is full
//  -5  other unspecified internal error

function DIB_WriteToBmp(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_WriteToBmpFile(hdib:Cardinal; fh:HFILE): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_WriteToJpeg(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_WriteToPng(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_WriteToTiff(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_WriteToPdf(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_WriteToGif(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_WriteToDcx(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Note: a return value of -3 indicates an invalid hdib handle, or
// 'no support for this format'.  -3 is also returned when attempting
// to write a Jpeg file from an image that is not 24-bit color or
// 8-bit grayscale.  1-bit B&W images cannot be saved as JPEG.
// 24-bit color images are 'quantized' to 8-bit color when written to GIF.
// All image types are converted to 1-bit B&W when written to DCX.
// Other internal errors will return -5, including insufficient memory.
// Check TWAIN_LastErrorCode for more details (maybe)

function DIB_LoadFromFilename(sFileName:PAnsiChar): Cardinal;
stdcall; external 'Eztwain3.dll'
// Load an image from a file and return its handle.
// The file can be in any format supported by EZTwain Pro.
// If the file is multipage, normally this function loads page 0,
// but a preceding call to DIB_SelectPageToLoad changes that.
// A return of NULL(0) indicates failure, see TWAIN_LastErrorCode
// and related functions for more details.
// If the filename is an empty string (or NULL) the user is prompted
// with a standard file-open dialog.
// EZTwain should read any variant of its supported formats,
// except for PDF: We only claim to support reading images
// from PDFs if they were created by EZTwain Pro.

function DIB_FormatOfFile(sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Returns the TWFF_ code for the format of the specified file.
// A return < 0 indicates 'unrecognized format' or some error
// when opening or reading the file.

procedure DIB_SelectPageToLoad(nPage:Integer);
stdcall; external 'Eztwain3.dll'
// For use when loading multipage files.  Tells DIB_LoadFromFilename
// and DIB_LoadFromBuffer which page to load next, from a multipage file.
// Default is page 0 (first page in file).
// This value is reset to 0 after any call that tries to load a page.

function DIB_GetFilePageCount(sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_FilePageCount(sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Return the number of pages in the specified file.
// If the file is a recognized multipage format
// (TIFF, PDF, DCX), the pages in the file are counted.
// All other recognized formats return a page count of 1.
// If the file cannot be opened, read, recognized, etc.
// this function records an error and returns -1.

function DIB_LoadPage(sFileName:PAnsiChar; nPage:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Short for DIB_SelectPageToLoad, DIB_LoadFromFilename.
// Load the specified page from the specified file.
// Page 0 is the first page in a file.  Multiple
// pages are only supported in TIFF, PDF and DCX files, all other file
// formats have a single page, page #0.

function DIB_LoadArrayFromFilename(var ahdib:Cardinal; nMax:Integer; sFilename:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Load up to nMax images as DIBs into an array, reading from the specified file.
// If filename is null or the empty string, the user is prompted to select a file.
//
// If the user is prompted and cancels, this function returns -10.
// Otherwise if successful it returns the number of pages (images) loaded.
// Otherwise it returns -1 and you should call TWAIN_ReportLastError, TWAIN_LastErrorCode,etc.
//
// If this function returns < 0, the first nMax entries of the DIB array will be NULL (0).
// If returns N >= 0, the first N entries of the DIB array will
// contain handles to DIBs representing the first N images in the file.
// The remaining nMax-N entries in the DIB array will be NULL (0).
//
// Make sure you eventually call DIB_Free on all the loaded DIBs!

function DIB_LoadPagesFromFilename(var ahdib:Cardinal; start:Integer; count:Integer; sFilename:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'

function DIB_FormatOfBuffer(pBuffer:Pointer; nBytes:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Assuming the buffer contains something like an image file, return
// the format implied by the leading bytes.
// nBytes = number of bytes of data in buffer.

function DIB_PageCountOfBuffer(pBuffer:Pointer; nBytes:Integer): Integer;
stdcall; external 'Eztwain3.dll'
function DIB_BufferPageCount(pBuffer:Pointer; nBytes:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Assuming the buffer contains something like an image file, return
// the number of pages (images technically) in it.
// nBytes = number of bytes of data in buffer.

function DIB_LoadFromBuffer(pBuffer:Pointer; nBytes:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Load an image from a buffer, presumably formatted like an image file.
// If DIB_SelectPageToLoad was called just before, the
// designated page is loaded from the buffer.
// nBytes = number of bytes of data in buffer.

function DIB_LoadPageFromBuffer(pBuffer:Pointer; nBytes:Integer; nPage:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Load the specified page from a buffer - the buffer must contain an image
// file.  If the image format is one that can hold only one image, the page
// number is ignored.
// nBytes = number of bytes of data in buffer.

function DIB_LoadArrayFromBuffer(var ahdib:Cardinal; nMax:Integer; pBuffer:Pointer; nBytes:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Load up to nMax images as DIBs into an array, reading from a file in memory.
// pBuffer is the address of the buffer (memory block) holding the file to read.
// nBytes is the number of bytes of data in the buffer.
//
// Returns the number of images loaded if successful, otherwise
// it returns -1 and you should call TWAIN_ReportLastError, TWAIN_LastErrorCode, or similar.
//
// Make sure you eventually call DIB_Free on all the loaded DIBs.

function DIB_LoadFaxData(hdib:Cardinal; pBuffer:Pointer; nBytes:Integer; nFlags:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Load a DIB's contents from a buffer of CCITT fax-encoded data.
// pBuffer is the address of the buffer in memory.
// nBytes is the number of bytes of data in the buffer.
// nFlags are decoding options:
// Override with flags:
const
        FAX_GROUP3_2D = $20;
        FAX_GROUP4 = $40;
        FAX_BYTE_ALIGNED = $80;
        FAX_REQUIRE_EOLS = $100;
        FAX_EXPECT_EOB = $200;
        FAX_VANILLA = $400;
// default is Group3 1D, chocolate, not byte-aligned, EOLs not required, EOB not expected.


function DIB_WriteToBuffer(hdib:Cardinal; nFormat:Integer; pBuffer:Pointer; nbMax:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Write the image into the buffer in the format, not more than nbMax bytes.
// The return value is the actual size of the image - this may be more or less
// than nbMax.  If the return value > nbMax, it means only part of the image
// was written, and the buffer needs to be bigger.
// If pBuffer is NULL, no data is written - the function just returns the required
// buffer size in bytes.
// A return value of <= 0 indicates an error, such as
//   The image is invalid (null or invalid DIB handle)
//   The format is unrecognized, not supported, not installed, etc.
//   You can't save that image in that format e.g. B&W image to JPEG format.
//   Insufficient memory for temporary data structures (or corrupted heap)
//   Other internal failure.
// You can call TWAIN_LastErrorCode and similar functions for more details.

function DIB_WriteArrayToBuffer(var ahdib:Cardinal; n:Integer; nFormat:Integer; pBuffer:Pointer; nbMax:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// A combination of DIB_WriteArrayToFilename and DIB_WriteToBuffer.
// Writes n images to a memory buffer in the specified format.
// See DIB_WriteToBuffer above for the meaning of pBuffer and nbMax.
// Return value: See DIB_WriteToBuffer above.



function DIB_ToDibSection(hdib:Cardinal): HBitmap;
stdcall; external 'Eztwain3.dll'
// Converts the given DIB into a kind of bitmap called a DibSection.
// *** IMPORTANT: The input DIB is consumed and becomes invalid ***
// A DibSection is a special kind of HBITMAP.  Many languages
// and imaging classes (such as GDI+, .NET Image, Delphi TBitmap) do
// not easily accept DIBs but readily accept a DibSection/HBITMAP.

function DIB_FromBitmap(hbm:HBitmap; hdc:HDC): Cardinal;
stdcall; external 'Eztwain3.dll'
// Create a DIB with the contents of a GDI bitmap (preferably a DibSection).
// >> The input bitmap is NOT deleted - the returned DIB is a copy.
// If hdc = 0 (NULL) a default HDC is used.
// See also: DIB_ToDibSection

function DIB_IsBlank(hdib:Cardinal; dDarkness:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE(1) if the DIB has less than dDarkness fraction of 'dark' pixels.
// Return FALSE(0) otherwise.
// A typical value of dDarkness would be 0.02 which means 2% dark pixels.
// A page with less than 2% dark pixels is probably blank.

function DIB_Darkness(hdibFull:Cardinal): Double;
stdcall; external 'Eztwain3.dll'
// Returns the fraction of an image that consists of 'dark' pixels.
// These are pixels that would be black, if the image was converted
// to B&W using a smart thresholding.  See DIB_SmartThreshold.
// Used by DIB_IsBlank to decide if an image is blank.
// A return of 0.0 means none, 1.0 means all.  A typical office
// document is 0.02 (2%) to 0.32 (32%) dark pixels.

procedure DIB_GetHistogram(hdib:Cardinal; nComponent:Integer; var histo:Integer);
stdcall; external 'Eztwain3.dll'
// Count the number of occurences of each value of the specified component
// in the given DIB (see component codes below).  Put the counts
// of each value (0..255) into the histo array.
// The histo array *must* be an array of 256 32-bit integers.
// Only works on B&W, grayscale, palette, and 24-bit RGB images.
// Example: If hdib contains 237 pixels with a grayscale value of 17, then
// this call will return histo[17] = 237.  Components are normalized
// into the range 0..255.
// Note: If hdib is a 1-bit B&W image, then histo will be all 0's, except
// for hist[0] (black) and hist[255] (white).
//
// Component codes:
const
        COMPONENT_GRAY = 0;
        COMPONENT_RED = 1;
        COMPONENT_GREEN = 2;
        COMPONENT_BLUE = 3;
        COMPONENT_LUMINANCE = 0;
        COMPONENT_SAT = 4;
        COMPONENT_HUE = 5;

// For gray and B&W images, R, G, and B components are equal, and Hue and Sat are 0.
// Other components available upon request: support@dosadi.com


function DIB_ComponentCopy(hdib:Cardinal; nComponent:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Extract and return one component (channel) of the given image.
// The returned image is an 8-bit grayscale image containing the
// specified channel of the input image, with the same width,
// height, and DPI.
// 
// Note: In future this function may return a 16-bit deep image
// when given a 16 bit/channel input image.

function DIB_Avg(hdib:Cardinal; nComp:Integer): Double;
stdcall; external 'Eztwain3.dll'
function DIB_AvgRegion(hdib:Cardinal; nComp:Integer; leftx:Integer; topy:Integer; w:Integer; h:Integer): Double;
stdcall; external 'Eztwain3.dll'
function DIB_AvgRow(hdib:Cardinal; nComp:Integer; rowy:Integer): Double;
stdcall; external 'Eztwain3.dll'
function DIB_AvgColumn(hdib:Cardinal; nComp:Integer; colx:Integer): Double;
stdcall; external 'Eztwain3.dll'
// Average the values of pixels in an image, region, row or column.
// Note that row 0 is the visually top-most row of an image.
// Averages either intensity (brightness) or individual color channels,
// or saturation.
// See component codes above, for DIB_GetHistogram.
// Regardless of image format, white = 255.0 and black = 0, even
// for 1-bit B&W or 16-bit grayscale or color images.
// DOES NOT SUPPORT: 4-bit/pixel images, CMY(K) images.

function DIB_ProjectRows(hdib:Cardinal; nComp:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
function DIB_ProjectColumns(hdib:Cardinal; leftx:Integer; topy:Integer; w:Integer; h:Integer; nComp:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// These functions create and return a 1 row x N column image, containing
// the average value of the rows (columns) of the input image, in the
// specified channel (component).
// If the source image is <= 8-bit/sample, the result image is 8-bit/sample.
// If the source image is 16 bit/sample, so is the result image.

function DIB_Posterize(hdib:Cardinal; nLevels:Integer): Integer;
stdcall; external 'Eztwain3.dll'


//--- EXPERIMENTAL: The following functions may be removed or changed at any time.
function DIB_ForwardDCT(hdib:HANDLE): HANDLE;
stdcall; external 'Eztwain3.dll'

//--- OBSOLETE: The following functions are for backward compatibility only:
function TWAIN_WriteNativeToFilename(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_LoadNativeFromFilename(sFileName:PAnsiChar): Cardinal;
stdcall; external 'Eztwain3.dll'
//HDIB EZTAPI TWAIN_LoadNativeFromFile(HFILE fh);
// removed - contact Dosadi if this causes problems for you.
function TWAIN_NegotiateXferCount(nXfers:Integer): Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_DibDepth(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_DibWidth(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_DibHeight(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_DibNumColors(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_DibRowBytes(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
procedure TWAIN_DibReadRow(hdib:Cardinal; nRow:Integer; prow:Pointer);
stdcall; external 'Eztwain3.dll'
function TWAIN_CreateDibPalette(hdib:Cardinal): HPALETTE;
stdcall; external 'Eztwain3.dll'
procedure TWAIN_DrawDibToDC(hDC:HDC; dx:Integer; dy:Integer; w:Integer; h:Integer; hdib:Cardinal; sx:Integer; sy:Integer);
stdcall; external 'Eztwain3.dll'

//--------- File Read/Write

//---- File Formats
const
        TWFF_TIFF = 0;
        TWFF_BMP = 2;
        TWFF_JFIF = 4;
        TWFF_PNG = 7;
        TWFF_DCX = 97;
        TWFF_GIF = 98;
        TWFF_PDF = 99;
// PDF & GIF support is only provided by EZTwain.
// Note: BMP support is built into EZTwain, so is always available.

function TWAIN_IsJpegAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if JPEG/JFIF image files can be read and written.
// Returns 0 if JPEG support has not been installed.

function TWAIN_IsPngAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if PNG format support is available.

function TWAIN_IsTiffAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if TIFF format support is available.

function TWAIN_IsPdfAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if PDF format support is available.

function TWAIN_IsGifAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if GIF format support is available.

function TWAIN_IsDcxAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if DCX format support is available.
// Note that DCX files can only hold 1-bit
// B&W images - EZTwain converts the image data as needed.

function TWAIN_IsFormatAvailable(nFF:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if the specified file format support
// is available for writing and possibly reading files.
// A format is considered available if EZTwain can load
// the necessary DLLs.  See the 

function TWAIN_FormatVersion(nFF:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return the format module version * 100.

function TWAIN_IsFileExtensionAvailable(sExt:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if the file format corresponding to the given
// file extension ("TIF", ".gif", "jpeg", etc.) is available.
// Case does not matter, leading '.' is optional.

function TWAIN_FormatFromExtension(sExt:PAnsiChar; nFF:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return the file-format code (see File Formats above) for
// the given extension.  If pzExt is unrecognized, returns nFF.
// Case does not matter, leading '.' is optional.

function TWAIN_ExtensionFromFormat(nFF:Integer; sDefExt:PAnsiChar): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return the default extension associated with a file format.(See File Formats above.)
// Note: The leading '.' is included e.g. ".bmp", ".tif", etc.
// If nFF is not a valid value, returns its second parameter.

procedure TWAIN_GetExtensionFromFormat(nFF:Integer; sDefExt:PAnsiChar; szExtension:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Return the default extension for the given file-format code, in the 3rd parameter.
// The caller is responsible for allocating a string of at least 5 characters for the 3rd parameter.
// If the file format is not recognized, returns the value of the 2nd parameter.

function TWAIN_SetSaveFormat(nFF:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetSaveFormat: Integer;
stdcall; external 'Eztwain3.dll'
// Select the default file format for DIB_WriteToFilename
// and TWAIN_WriteToFilename to use, when they do not
// recognize the file extension.
// Displays a warning message if the format is not available.
// Returns TRUE (1) if ok, FALSE (0) if format is invalid or not available.
// See list of file formats above.  Some formats are not supported
// by some versions of EZTWAIN, or require external DLLs be installed.

procedure TWAIN_SetJpegQuality(nQ:Integer);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetJpegQuality: Integer;
stdcall; external 'Eztwain3.dll'
// Set the 'quality' of subsequently saved JPEG/JFIF image files.
// nQ = 100 is maximum quality & minimum compression.
// nQ = 75 is 'good' quality, the default.
// nQ = 1 is minimum quality & maximum compression.

//- Special TIFF options ------------------------------------------

procedure TWAIN_SetTiffStripSize(nBytes:Integer);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetTiffStripSize: Integer;
stdcall; external 'Eztwain3.dll'
// Set/Get the size of the 'strips' that TIFF files are divided into.
// Some (bogus) TIFF readers cannot handle multiple strips, to make
// them happy set the strip size to -1.
// Default value = 32768 (subject to change, in theory.)

function TWAIN_SetTiffImageDescription(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiffDocumentName(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Set the TIFF ImageDescription or DocumentName tags for output.
// These values apply only to the next TIFF file written, and are cleared
// once the file is closed.

function TWAIN_SetTiffCompression(nPT:Integer; nComp:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetTiffCompression(nPT:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Set/Get the compression mode to use when writing TIFF files.
// Set returns TRUE (1) if successful, FALSE (0) otherwise.
// nPT specifies the Pixel Type - See the TWPT_* constants.
// Different compressions apply to different pixel types - see below.
// Using nPT=-1 means 'for all applicable pixel types.'
// nComp specifies the compression, here are the codes:
const
        TIFF_COMP_NONE = 1;
        TIFF_COMP_CCITTRLE = 2;
        TIFF_COMP_CCITTFAX3 = 3;
        TIFF_COMP_CCITTFAX4 = 4;
        TIFF_COMP_LZW = 5;
        TIFF_COMP_JPEG = 7;
        TIFF_COMP_PACKBITS = 32773;

// Default for BW is TIFF_COMP_CCITTFAX4
// Default for all other pixel types is TIFF_COMP_NONE.

// Setting TIFF tags explicitly, including custom/private tags:
function TWAIN_SetTiffTagShort(nTagId:Integer; sValue:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiffTagLong(nTagId:Integer; nValue:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiffTagString(nTagId:Integer; sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiffTagDouble(nTagId:Integer; dValue:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiffTagRational(nTagId:Integer; dValue:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiffTagRationalArray(nTagId:Integer; var dValues:Double; n:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiffTagBytes(nTagId:Integer; pdata:Pointer; nBytes:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiffTagUndefined(nTagId:Integer; pdata:Pointer; nBytes:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Note: It works to use SetTiffTagDouble to set standard TIFF tags that are of
// type RATIONAL, but we recommend using SetTiffTagRational.
// If you have trouble setting a custom private tag, it may help to
// define it to EZTwain - see TWAIN_DefineCustomTiffTag, below.

procedure TWAIN_ResetTiffTags;
stdcall; external 'Eztwain3.dll'
// The functions above allow specific TIFF tags to be set.
// Whatever value(s) you set will be used in *each image written to TIFF*
// until you call TWAIN_ResetTiffTags.
// Note that integer values are appropriately converted to 16- or 32-bit
// signed or unsigned as needed by the specific tag.

function TWAIN_GetTiffTagAscii(sFilename:PAnsiChar; nPage:Integer; nTag:Integer; nLen:Integer; buffer:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Read the value of the specified tag from the given page of the given TIFF file,
// copying the string into buffer, which has room for len characters.
// Returns True(1) if successful, False(0) otherwise.

function TWAIN_TiffTagAscii(sFilename:PAnsiChar; nPage:Integer; nTag:Integer): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return the value of the specified tag from the given page of the given TIFF file,
// as a human-readable string.
// Numeric values are converted to decimal numeric representation.
// In case of failure, it returns the empty string.
// In case of error, call TWAIN_ReportLastError to display details,
// or call TWAIN_LastErrorCode and related functions.

procedure TWAIN_SetFileAppendFlag(bAppend:BOOL);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetFileAppendFlag: BOOL;
stdcall; external 'Eztwain3.dll'
// Set or get the File Append Flag.
// When this flag is non-zero and EZTwain writes to an existing TIFF, PDF or DCX
// file, the new images are *appended* to the existing file.
// When this flag is False (0), writing to any existing file replaces the file.
//
// The default state of this flag is: False (0).
//
// Note: Only TIFF, PDF, and DCX formats are affected.
// This applies to all functions that write images, primarily:
//  TWAIN_AcquireToFilename, TWAIN_AcquireMultipageFile,
//  DIB_WriteToFilename, TWAIN_BeginMultipageFile, etc.

//- PDF Specific ------------------------------------------

// These functions configure or add information to the next output PDF file:
function TWAIN_SetPdfTitle(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetPdfAuthor(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetPdfSubject(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetPdfKeywords(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetPdfCreator(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetPdfProducer(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'

// Writing metadata into PDF:
function PDF_SetTitle(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function PDF_SetAuthor(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function PDF_SetSubject(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function PDF_SetKeywords(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function PDF_SetCreator(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function PDF_SetProducer(sText:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'

function PDF_SetCompression(nPT:Integer; nComp:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function PDF_GetCompression(nPT:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Select the compression algorithm to use for images with the given pixel format.
// See the TWPT_* constants for the various pixel formats.
// Note that a pixel format of -1 means 'all applicable formats'.
// Available values of nComp are:
const
        COMPRESSION_DEFAULT = -1;
        COMPRESSION_NONE = 1;
        COMPRESSION_FLATE = 5;
        COMPRESSION_JPEG = 7;

function PDF_SelectPageSize(nPaper:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function PDF_SelectedPageSize: Integer;
stdcall; external 'Eztwain3.dll'
// Set/Get the standard page-size for subsequent PDF output pages.
// The values are PAPER_ values defined elsewhere
// in this file, search for PAPER_A4 etc.
// EZTwain initializes this to PAPER_NONE (0).
// With PAPER_NONE selected, EZTwain writes each output image into a
// page the same size as the image.  Setting a page size tells
// EZTwain to center each output image within a page of the
// specified size, shrinking larger images to fit.
// Calling PDF_SelectPageSize(PAPER_NONE) clears the page-size
// back to the default i.e. 'no specific size'.

procedure PDF_SetOpenPassword(sPassword:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Set the password to be used to open subsequent PDF files.
// This password is used until reset to the empty string.
// If you have set an OpenPassword, the user will not be prompted
// for a password when an encrypted PDF is opened for reading.

// To suppress prompting by EZTwain, use this function to set
// an extremely unlikely password string, such as " " or "\t".

function PDF_SetPDFACompliance(nLevel:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function PDF_GetPDFACompliance: Integer;
stdcall; external 'Eztwain3.dll'
// Set/Get the PDF/A Compliance level.
// Level 0 is 'no particular compliance'. (*default*)
// Level 1 is PDF/A-1(b) - the PDF/A Part 1 level suitable for
// scanned documents.
// No other nLevel values are accepted at this time.
// When PDFA compliance is set to 1, PDF output is made to comply with
// ISO 19005-1 PDF/A-1.  For the most part this is invisible, but certain
// PDF settings and operations become illegal, and there are optional
// function calls that make your PDF's "more" PDF/A compliant.

procedure PDF_SetUserPassword(sPassword:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Define a user password for the next/current output PDF file.
// This turns on encryption for the file.
// When a PDF file is completed and closed, the user password is cleared.

procedure PDF_SetOwnerPassword(sPassword:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Define an owner password for the next/current output PDF file.
// This turns on encryption for the file.
// When a PDF file is completed and closed, the user password is cleared.

procedure PDF_SetPermissions(nPermission:Integer);
stdcall; external 'Eztwain3.dll'
function PDF_GetPermissions: Integer;
stdcall; external 'Eztwain3.dll'
// Set or Get the permissions mask to be written into the next/current
// output PDF file. This mask specifies operations to be allowed or
// prevented on the file - see the PDF_PERMIT constants.
//
// Important Notes
//
// * Permissions are only written if you set a User or Owner password.
// * Acrobat honors these restrictions, but other PDF readers may not.
// * Any permissions you set only apply to the next PDF file you write.
// * The default permissions mask is 'allow everything' (-1)
// * Setting permissions=0 means 'prevent everything'
//
// You can use bitwise operations, or +/- to combine these constants.
// For example, to disallow copying text and graphics from the file:
//    PDF_SetPermissions(PDF_PERMIT_ALL - PDF_PERMIT_COPY)
//
//      named constant                  value   if restricted, Acrobat will prevent:
const
        PDF_PERMIT_PRINT = 4;
        PDF_PERMIT_MODIFY = 8;
        PDF_PERMIT_COPY = 16;
        PDF_PERMIT_ANNOTS = 32;
// You can also use this nPermission value, by itself:
        PDF_PERMIT_ALL = -1;


//-- Writing text into PDF. ------------------------
//
// The following functions apply to the next PDF file or page that is output,
// so you make them *before* you write the PDF page they apply to.

procedure PDF_DrawText(leftx:Double; topy:Double; sText:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Draw text into the next PDF page, x pixels from the left edge
// and y pixels down from the top of the page.
// Note 1: This is not 'native' PDF coordinates, which are
// usually in points, from the lower-left corner of the page.
// Note 2: This call only makes sense if followed at some point
// by a call that writes an image to PDF.

procedure PDF_DrawInvisibleText(leftx:Double; topy:Double; sText:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Like PDF_DrawText, but text is drawn in invisible mode.

procedure PDF_SetTextVisible(bVisible:BOOL);
stdcall; external 'Eztwain3.dll'
function PDF_GetTextVisible: BOOL;
stdcall; external 'Eztwain3.dll'
// Set the visibility of the text written by subsequent PDF_DrawText
// calls. A parameter of True (non-0) means make text visible, a parameter
// of False (0) means make text invisible.

procedure PDF_SetTextSize(dfs:Double);
stdcall; external 'Eztwain3.dll'
// Set the size of the current font, for subsequent PDF_DrawText calls.
// Normally this is a traditional size in points, like 10.
procedure PDF_SetTextHorizontalScaling(dhs:Double);
stdcall; external 'Eztwain3.dll'

function PDF_WriteOcrText(text:PAnsiChar; var ax:Integer; var ay:Integer; var aw:Integer; var ah:Integer; xdpi:Double; ydpi:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Write previously OCR'd text to the next PDF output page.
// ---parameters---
// text is the text, of course - as returned by OCR_Text.
// ax and ay are arrays of x,y positions of the characters in text - as returned
// by OCR_GetCharPositions.  These are pixel coordinates relative to the top-left of the page.
// aw and ah are arrays of (width,height) information as returned by OCR_GetCharSizes.
// xdpi and ydpi are the resolution values (DPI) of the source image, required to map the text
// size from pixels into PDF font sizes.  The resolution can be obtained from the image
// using DIB_XResolution and DIB_YResolution, or you can call OCR_GetResolution at the
// same time you call OCR_GetCharPositions and OCR_GetCharSizes.

//---------------------------------------------------------

function TWAIN_WriteToFilename(hdib:Cardinal; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Writes the specified image to a file.
// This is the same as DIB_WriteToFilename - please refer to that function.

function TWAIN_LoadFromFilename(sFileName:PAnsiChar): Cardinal;
stdcall; external 'Eztwain3.dll'
// Load a .BMP file, or any other available format.
// Accepts a filename (including path & extension).
// If the filename is NULL or points to a null string, the user is
// prompted to choose a file with a standard File Open dialog.
// Returns a DIB handle if successful, otherwise NULL.

function TWAIN_LoadPage(sFileName:PAnsiChar; nPage:Integer): Cardinal;
stdcall; external 'Eztwain3.dll'
// Short for DIB_SelectPageToLoad, DIB_LoadFromFilename.
// Load the specified page from the specified file.
// Page 0 is the first page in a file.  Multiple
// pages are only supported in TIFF, PDF and DCX files, all other file
// formats have a single page, page #0.

function TWAIN_FormatOfFile(sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Return the format of the specified file.
// See the TWFF_* codes elsewhere in this file.
// A return value < 0 means 'unrecognized format'.

function TWAIN_PagesInFile(sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Return the number of pages in the specified file.
// For multipage formats (TIFF, PDF, DCX), the pages are counted.
// All other recognized formats return a page count of 1.
// If the file cannot be opened, read, recognized, etc.
// this function records an error and returns -1.

function TWAIN_PromptForOpenFilename(sFileName:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Prompt the user for a file to open.
// Returns TRUE(1) if user selected a file, FALSE(0) if user cancelled.
// If it returns TRUE, the fully-qualified filepath & name is returned
// in the buffer referenced by the parameter.
// The caller is responsible for allocating (and deallocating) the
// buffer of at least 260 characters.
// The file dialog has a file-type list, which is loaded based
// on the formats that are currently supported for loading.
// The default file-type is "any supported format".

//--------- File View Dialog

function TWAIN_ViewFile(sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Display the specified file in a viewer window that allows the
// user to browse to all pages (if more than one).
// If the file name is NULL or the null string, the user is prompted
// with a standard file-open dialog, offering all the filetypes that
// EZTwain believes it can open.
// The default dialog has an OK button only.
// Return values:
//  1   [OK] button pressed (in modal dialog)
//  1   File displayed - in case of modeless dialog.
//  0   [Cancel] button pressed
// -1   user cancelled file-open prompt (if you supplied a null filename)
// -2   error displaying dialog, opening file, etc.

function TWAIN_SetViewOption(sOption:PAnsiChar; sValue:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Set various options and parameters for the viewer window.
// See TWAIN_ViewFile above.
//
// option                       form    meaning
// title                        string  the title (caption) of the viewer window
// left                         x|x%    left(x) coordinate of window, in pixels or as a percent of screen.
// top                          y|y%    top coordinate of window
// bottom                       y|y%
// right                        x|x%
// width                        w|w%    width of viewer window, in pixels or as a percent of screen.
// height                       h|h%
// size                         w,h             width and height together, pixels or percentages
// topleft                      x,y             x and y together, pixels or percentages
// position                     x,y,w,h left,top,width,height - in pixels or percentages
// pos                                  same as position
// pos.remember         bool    if true, remember viewer position between showings. Default: false.
// timeout                      n               in seconds. Currently ignored.
// visible                      bool    if viewer is open, show or hide it.  Default: true
// ok.visible           bool    if true, include an [OK] button in the viewer. Default: true.
// cancel.visible       bool    if true, include a [Cancel] button. Default: false
// print.visible        bool    if true, include a [Print] button. Default: false.
// modeless                     bool    if true, leave viewer open until TWAIN_ViewClose. Default: false.
// modal                        bool    opposite of modeless.
// reset                        ...             setting this option resets all options to default value.


function TWAIN_IsViewOpen: BOOL;
stdcall; external 'Eztwain3.dll'
// Return True if the viewer window is open, False otherwise.

function TWAIN_ViewClose: BOOL;
stdcall; external 'Eztwain3.dll'
// If the viewer window is open (as a modeless dialog), close it.
// The viewer window is normally modal, but can be made modeless
// with TWAIN_SetViewOption("modeless", "true")
// No effect if no viewer window is open.
// Returns True(1) if it closed the viewer window, False(0) otherwise.

function TWAIN_GetLastViewPosition(var pleft:Integer; var ptop:Integer; var pwidth:Integer; var pheight:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Return the screen coordinates, in pixels, of the last known position of the
// viewer window (the dialog displayed by TWAIN_ViewFile and DIB_View functions.)
// The four parameters are pointers to 32-bit integers or if your language
// prefers, four 32-bit integers passed by reference.
// The four returned values are the left edge, the top edge (counting down from screen top)
// the width, and the height of the View window, the last time it was closed or resized.
//
// This function can be used in conjunction with TWAIN_SetViewOption("position","x,y,w,h") to
// remember and restore the view window position.

//--------- Multipage File Output

const
        MULTIPAGE_TIFF = 0;
        MULTIPAGE_PDF = 1;
        MULTIPAGE_DCX = 2;

function TWAIN_SetMultipageFormat(nFF:Integer): Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetMultipageFormat: Integer;
stdcall; external 'Eztwain3.dll'
// Select/query the default multipage file save format.
// The default when EZTwain is loaded is MULTIPAGE_TIFF.
// Note that if you use a recognized extension in the name
// of your multipage file - such as .tif, .pdf or .dcx, then
// the file will be written in that format.  The file
// extension overrides SetMultipageFormat.
//
// SetMultipageFormat returns:
//  0 = success,
// -1 = invalid/unrecognized format
// -3 = format is currently unavailable (missing/bad DLL)

procedure TWAIN_SetLazyWriting(bYes:BOOL);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetLazyWriting: BOOL;
stdcall; external 'Eztwain3.dll'
// Get/Query the value of the 'LazyWriting' flag.
// NOTE: The default value of this flag is: TRUE.
// When the LazyWriting flag is set (TRUE), multipage files
// are written by a background thread, allowing your
// program to continue executing (scanning for example).
// Only when EndMultipageFile is called does the program
// wait until all the pages of the file have actually
// been written to disk.
// This also applies to AcquireMultipageFile, which internally
// uses these multipage output functions.

function DIB_WriteArrayToFilename(var ahdib:Cardinal; n:Integer; sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Write n images from array ahdib to the specified file.
// If n is 1, this is exactly equivalent to calling DIB_WriteToFilename.
// If n > 1, this is a shortcut for calling
//    TWAIN_BeginMultipageFile,
//      TWAIN_DibWritePage (for each image)
//    TWAIN_EndMultipageFile
// ...with appropriate error handling, of course.
//
// Return values:
//       0      success
//      -1      user cancelled File Save dialog
//      -2      file open error (invalid path or name, or access denied)
//      -3      a) image is invalid (null or invalid DIB handle)
//      b) support for the save format is not available
//      c) DIB format incompatible with save format e.g. B&W to JPEG.
//      -4      writing data failed, possibly output device is full
//  -5  other unspecified internal error
//  -6  a multipage file is already open
//  -7  multipage support is not installed.

function TWAIN_BeginMultipageFile(sFileName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Create an empty multipage file of the given name.
// If the filename is NULL or points to the null string, the user
// is prompted with a standard File Save dialog.
// If the filename includes an extension (.tif, .tiff, .mpt, .pdf or .dcx)
// then the corresponding format is used for the file.
// If you do not supply an extension, the default multipage format is used.

// Return values:
//       0      success
//      -1      user cancelled File Save dialog
//      -2      file open error (invalid path or name, or access denied)
//  -3  file format not available
//  -5  other unspecified internal error
//  -6  multipage file already open
//  -7  Multipage support is not installed.

function TWAIN_DibWritePage(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
//   0  success
//  -2  internal limit exceeded or insufficient memory
//  -3  File format is not available (EZxxx DLL not found)
//  -4  Write error: Output device is full?
//  -5  invalid/unrecognized file format or 'other' - internal
//  -6  multipage file not open
//  -7  Multipage support is not installed.

function TWAIN_EndMultipageFile: Integer;
stdcall; external 'Eztwain3.dll'
//   0  success
//  -3  File format is not available
//  -4  Write error - drive offline, or ?? (very unlikely)
//  -5  invalid/unrecognized file format or other internal error
//  -6  multipage file not open
//  -7  Multipage support is not installed.

function TWAIN_MultipageCount: Integer;
stdcall; external 'Eztwain3.dll'
// Return the number of images (scans) written to the most recently
// started multipage file.  In other words, this returns a counter
// which is reset by BeginMultipageFile, and is incremented by DibWritePage.

function TWAIN_IsMultipageFileOpen: BOOL;
stdcall; external 'Eztwain3.dll'
// Return True if a multipage output file is open, False otherwise.
// Only one multipage output file can be open at a time (per process.)


function TWAIN_LastOutputFile: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return the name of the last file written by EZTwain.
// Useful if you pass NULL or the empty string as a filename to
// DIB_WriteToFilename or TWAIN_AcquireToFilename, etc.


procedure TWAIN_SetOutputPageCount(nPages:Integer);
stdcall; external 'Eztwain3.dll'
// Tell EZTwain how many pages you are about to write to a file.
// This is OPTIONAL: The only effect is to add PageNumber tags
// to TIFF files.  You can use nPages=0, which means "I don't know".

function TWAIN_FileCopy(sInFile:PAnsiChar; sOutFile:PAnsiChar; nOptions:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Read all the images or pages from the in file and write them to the out file.
// nOptions is currently not used and should be 0.
// The formats need not be the same, in fact this function is most often
// used to convert for example from TIFF to PDF.  If you specify a single-image
// output format (BMP, GIF, PNG, JPG) the input file must have only one page.
// Return values:
//       0      success
//      -1      user cancelled
//      -2      file open error (invalid path or name, or access denied)
//  -3  file format not available or inappropriate (e.g. copying 5-page TIF to JPEG)
//  -5  other unspecified internal error
//  -7  Multipage support is not installed.

//--------- Network file transfer services
//
// These functions require EZCurl.dll to be
// in the same folder as Eztwain3.dll

function UPLOAD_IsAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// TRUE(1) if uploading services are available (= EZCurl.dll can be loaded.)
// Returns FALSE(0) otherwise.

function UPLOAD_Version: Integer;
stdcall; external 'Eztwain3.dll'
// Return the upload module version * 100.

function UPLOAD_MaxFiles: Integer;
stdcall; external 'Eztwain3.dll'
// Return the maximum number of files that can be uploaded in one UPLOAD operation.
// i.e. UPLOAD_FilesToURL, UPLOAD_DibsSeparatelyToURL.

function UPLOAD_AddFormField(fieldName:PAnsiChar; fieldValue:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Set a form field to a value in the next Upload (see below).
// The name of the field must be expected by the page/script you upload to.
// All fields set with this function are discarded and forgotten after
// the next upload that uses them.
//
// For example, suppose you have been uploading scanned documents to your server
// using a web form like this:
// <form name="form1" method="post" action="http://server.com/newdoc.php" >
// <input type="hidden" name="key" value="12345678">
// <input type="text" name="vendor id">
// <input type="file" name="file">
// <input type="submit" name="submit" value="Submit">
// </form>
//
// You might automate the upload of a just-scanned image in memory (hdib)
// with vendor id = 1290331, with code similar to this:
//    UPLOAD_AddFormField("key", "12345678")
//    UPLOAD_AddFormField("vendor id", "1290331")
//    UPLOAD_DibToURL(hdib, "http://server.com/newdoc.php", "document.pdf", "file")

function UPLOAD_AddHeader(header:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Add a header line to the next HTTP upload.
// You should have some understanding of HTTP protocol to use this!
// Don't include any line-break characters.
// To send a cookie, use UPLOAD_AddCookie (below).

function UPLOAD_AddCookie(cookie:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Add a cookie line to the next HTTP upload.
// Often used to provide session id's e.g.
//    UPLOAD_AddCookie("ASP.NET_SessionID=" & strSessionID)
// or
//    UPLOAD_AddCookie("JSESSIONID=" & strSessionID)

procedure UPLOAD_EnableProgressBar(bEnable:BOOL);
stdcall; external 'Eztwain3.dll'
function UPLOAD_IsEnabledProgressBar: BOOL;
stdcall; external 'Eztwain3.dll'
// Enable or disable the progress-bar during uploads.
// Default state is enabled (TRUE).

function UPLOAD_DibToURL(hdib:Cardinal; URL:PAnsiChar; fileName:PAnsiChar; fieldName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function UPLOAD_DibsToURL(var ahdib:Cardinal; n:Integer; URL:PAnsiChar; fileName:PAnsiChar; fieldName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function UPLOAD_DibsSeparatelyToURL(var ahdib:Cardinal; n:Integer; URL:PAnsiChar; fileName:PAnsiChar; fieldName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
function UPLOAD_FilesToURL(files:PAnsiChar; URL:PAnsiChar; fieldName:PAnsiChar): Integer;
stdcall; external 'Eztwain3.dll'
// Upload an image, set of images, or some files on disk, to a script on a server,
// AS IF a form was being submitted via HTTP-POST, with a field or fields of type 'file'.
//
// Important Note - This confuses some people, don't let it happen to you!
// Only UPLOAD_FilesToURL looks for actual disk files and uploads them.
// All the other UPLOAD functions upload image data, *pretending* it is from a file - no such
// file is read, used, or created on the client machine.
//
// UPLOAD_DibsSeparatelyToURL uploads each image as a separate file, appending '1', '2', etc.
// to both the filename and the fieldname.  So if you upload n images with fileName="page.jpg"
// and fieldName="file", it will upload files as "file1"="page1.jpg", "file2=page2.jpg", etc.
//
// Similarly, UPLOAD_FilesToURL uploads multiple files, appending the counter to the fieldName.
// If you specify a fieldName of "file", UPLOAD_FilesToURL will use "file1", "file2", etc.
// Note that this applies even if you upload just one file.
//
// hdib      = handle to image to upload.
// ahdib     = address or reference to array of hdibs (image handles).
// n         = number of images in array ahdib.
// fileName  = name of (imaginary) file being uploaded.
//             Note: the extension on the filename determines the file format.
// files     = a string containing one or more filenames, separated by semicolons (;) or vertical bars (|)
// URL       = URL to POST the file to, such as http://www.dosadi.com/upload.php
// fieldName = name of the form-field. If null or blank, "file" is used.
//
// NOTE: When uploading multiple images as a single file, you must of course
// use a file format that supports multiple pages: TIFF, PDF, or DCX.
//
// Return values:
//    0    success (transaction completed)
//         Important: A success return (0) means only that the data was sent to the
//         server and a response was received, not that the receiving script
//         necessarily accepted the submitted file.  See DIB_UploadResponse below. 
//   -1    user cancelled File Save dialog (should never happen)
//   -2    could not write temp file - access denied, volume protected, etc.
//   -3    a) image is invalid (null or invalid DIB handle)
//         b) The DLL(s) needed to save that format failed to load
//         c) DIB format incompatible with save format e.g. uploading a B&W image as JPEG.
//         d) fileName does not have a recognized extension (.tif, .jpg, .gif, etc)
//   -4    writing data failed, maybe the disk with the temp folder is full?
//   -5    other unspecified internal error
// -100+n  libcurl returned error code n
//         for example:
// -106    could not resolve host
// -107    couldn't connect
// -126    could not open/read local file

procedure UPLOAD_SetProxy(hostport:PAnsiChar; userpwd:PAnsiChar; bTunnel:BOOL);
stdcall; external 'Eztwain3.dll'

function UPLOAD_Response: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return the text received from the server in response to the last upload.
// You can check this text to see if the server-script accepted the upload.
// There is no predefined limit to the length of the returned string - please
// code defensively.  This call is extremely fast, 
// (See DIB_PostToURL above.)

function UPLOAD_ResponseLength: Integer;
stdcall; external 'Eztwain3.dll'
// Return the length of the last server response string, as returned
// by UPLOAD_Response.

procedure UPLOAD_GetResponse(ResponseText:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Retrieve the text received from the server in response to the last upload.
// * This text is limited to 1024 characters. *
// (See DIB_PostToURL above.)

procedure UPLOAD_ClearResponse;
stdcall; external 'Eztwain3.dll'

// Upload callback support

//--------- Application Registration and Licensing

procedure TWAIN_SetAppTitle(sAppTitle:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// The short form of Application/Product name registration.
// Sets the product name as far as EZTwain and TWAIN are concerned.
// This title is used in several ways:
// As the title (caption) of any EZTwain dialog boxes / error boxes.
// In the progress box of some devices as they transfer images.
// In the 'software' field of saved image files in some formats,
// including TIFF.

procedure TWAIN_SetApplicationKey(nKey:Integer);
stdcall; external 'Eztwain3.dll'
// Unlock EZTwain Pro for use with the current application - call this AFTER
// calling RegisterApp or SetAppTitle above:  The nKey value must match
// the application title (product name) passed to one of those functions.

procedure TWAIN_ApplicationLicense(sAppTitle:PAnsiChar; nAppKey:Integer);
stdcall; external 'Eztwain3.dll'
// Unlock EZTwain using a Single Application License.

procedure TWAIN_SetVendorKey(sVendorName:PAnsiChar; nKey:Integer);
stdcall; external 'Eztwain3.dll'
// Unlock EZTwain using a Universal Application / Vendor License

procedure TWAIN_OrganizationLicense(sOrganization:PAnsiChar; nKey:Integer);
stdcall; external 'Eztwain3.dll'
// Unlock EZTwain using an Organization / In-House Application License.

function TWAIN_RenewTrialLicense(uKey:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Renew or recreate the EZTwain Pro trial license in this computer,
// if the Key parameter is a valid trial-renewal key.
// Such keys are valid only for some number of days after issue.
// Contact Dosadi Support (support@dosadi.com) for such a key.

function TWAIN_SingleMachineLicense(sMsg:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// If no valid EZTwain Pro license is found on this computer, prompt
// the user with a dialog box asking for a single-machine license key.
// If the user supplies a key, try to record & validate it.
// Return value:
// TRUE if EZTwain Pro is licensed for use on this computer.
// (Note this could be because of a trial license, or an organization license).
// FALSE if EZTwain Pro is not licensed for use on this computer.

procedure TWAIN_RegisterApp(nMajorNum:Integer; nMinorNum:Integer; nLanguage:Integer; nCountry:Integer; sVersion:PAnsiChar; sMfg:PAnsiChar; sFamily:PAnsiChar; sAppTitle:PAnsiChar);
stdcall; external 'Eztwain3.dll'
//
// TWAIN_RegisterApp can be called *AS THE FIRST CALL*, to register the
// application. If this function is not called, the application is given a
// 'generic' registration by EZTWAIN.
// Registration only provides this information to the Source Manager and any
// sources you may open - it is used for debugging, and possibly by some
// sources to give special treatment to certain applications.

//--------- Error Analysis and Reporting ------------------------------------

function TWAIN_GetResultCode: Cardinal;
stdcall; external 'Eztwain3.dll'
// Return the result code (TWRC_xxx) from the last triplet sent to TWAIN

function TWAIN_GetConditionCode: Cardinal;
stdcall; external 'Eztwain3.dll'
// Return the condition code from the last triplet sent to TWAIN.
// (To be precise, from the last call to TWAIN_DS below)
// If a source is NOT open, return the condition code of the source manager.

function TWAIN_UserClosedSource: BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) if during the last acquire the user asked
// the DataSource to close.  0 otherwise of course.
// This flag is cleared each time you start any kind of acquire,
// and it is set if EZTWAIN receives a
// MSG_CLOSEDSREQ message through TWAIN.

procedure TWAIN_ErrorBox(sMsg:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Post an error message dialog with an OK button.
// pzMsg points to a null-terminated message string.
// The box caption is the current AppTitle - see SetAppTitle.
// If messages are suppressed (see below) this function does nothing.

function TWAIN_SuppressErrorMessages(bYes:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// Enable or disable EZTWAIN error messages to the user.
// When bYes = FALSE(0), error messages are displayed.
// When bYes = TRUE(non-0), error messages are suppressed.
// By default, error messages are displayed.
// Returns the previous state of the flag.
//
// EZTWAIN cannot suppress messages from TWAIN or TWAIN device drivers.

procedure TWAIN_ReportLastError(msg:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// If EZTwain has recorded an error and that error has not been
// reported to the user, this function displays a modal error dialog
// with information about that error.
// If msg is non-null and not the empty string, it is included
// in the dialog box.
// Many EZTwain errors record additional details, and those details
// are also inserted in the error dialog.
//
// If the recorded error is EZTEC_NONE (no error) or EZTEC_USER_CANCEL,
// no error dialog is displayed.
// If the recorded error information indicates that the user cancelled
// a TWAIN operation, *or* that the user has already seen an error
// message about the error, then no error dialog is displayed.
//
// This function *clears* the recorded error, whether or
// not it displays a message, by calling TWAIN_ClearError.

procedure TWAIN_GetLastErrorText(sMsg:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Get a string that describes the last error detected by EZTwain.
// Note: This function is called by TWAIN_ReportLastError.
// Note: The returned string may contain end-of-line characters.
// The parameter is a string variable (char array in C/C++).
// You are responsible for allocating room for 512 8-bit characters
// in the string variable before calling this function.

function TWAIN_LastErrorText: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return a string that describes the last error detected by EZTwain -
// see Notes for TWAIN_GetLastErrorText.

function TWAIN_LastErrorCode: Integer;
stdcall; external 'Eztwain3.dll'
// Return the last internal EZTWAIN error code. (see EZTEC_ codes below)

procedure TWAIN_ClearError;
stdcall; external 'Eztwain3.dll'
// Set the EZTWAIN internal error code to EZTEC_NONE

function TWAIN_ReportLeaks: BOOL;
stdcall; external 'Eztwain3.dll'
// Display a message box if EZTwain can detect any memory leaks.
// Currently this only counts image handles (DIBs) that have been
// allocated but never freed.
// Returns True(1) if a problem is detected, False(0) otherwise.

////////////////////////////////////////////////////////
// EZTwain Error codes
const
        EZTEC_NONE = 0;
        EZTEC_START_TRIPLET_ERRS = 1;
        EZTEC_CAP_GET = 2;
        EZTEC_CAP_SET = 3;
        EZTEC_DSM_FAILURE = 4;
        EZTEC_DS_FAILURE = 5;
        EZTEC_XFER_FAILURE = 6;
        EZTEC_END_TRIPLET_ERRS = 7;
        EZTEC_OPEN_DSM = 8;
        EZTEC_OPEN_DEFAULT_DS = 9;
        EZTEC_NOT_STATE_4 = 10;
        EZTEC_NULL_HCON = 11;
        EZTEC_BAD_HCON = 12;
        EZTEC_BAD_CONTYPE = 13;
        EZTEC_BAD_ITEMTYPE = 14;
        EZTEC_CAP_GET_EMPTY = 15;
        EZTEC_CAP_SET_EMPTY = 16;
        EZTEC_INVALID_HWND = 17;
        EZTEC_PROXY_WINDOW = 18;
        EZTEC_USER_CANCEL = 19;
        EZTEC_RESOLUTION = 20;
        EZTEC_LICENSE = 21;
        EZTEC_JPEG_DLL = 22;
        EZTEC_SOURCE_EXCEPTION = 23;
        EZTEC_LOAD_DSM = 24;
        EZTEC_NO_SUCH_DS = 25;
        EZTEC_OPEN_DS = 26;
        EZTEC_ENABLE_FAILED = 27;
        EZTEC_BAD_MEMXFER = 28;
        EZTEC_JPEG_GRAY_OR_RGB = 29;
        EZTEC_JPEG_BAD_Q = 30;
        EZTEC_BAD_DIB = 31;
        EZTEC_BAD_FILENAME = 32;
        EZTEC_FILE_NOT_FOUND = 33;
        EZTEC_FILE_ACCESS = 34;
        EZTEC_MEMORY = 35;
        EZTEC_JPEG_ERR = 36;
        EZTEC_JPEG_ERR_REPORTED = 37;
        EZTEC_0_PAGES = 38;
        EZTEC_UNK_WRITE_FF = 39;
        EZTEC_NO_TIFF = 40;
        EZTEC_TIFF_ERR = 41;
        EZTEC_PDF_WRITE_ERR = 42;
        EZTEC_NO_PDF = 43;
        EZTEC_GIFCON = 44;
        EZTEC_FILE_READ_ERR = 45;
        EZTEC_BAD_REGION = 46;
        EZTEC_FILE_WRITE = 47;
        EZTEC_NO_DS_OPEN = 48;
        EZTEC_DCXCON = 49;
        EZTEC_NO_BARCODE = 50;
        EZTEC_UNK_READ_FF = 51;
        EZTEC_DIB_FORMAT = 52;
        EZTEC_PRINT_ERR = 53;
        EZTEC_NO_DCX = 54;
        EZTEC_APP_BAD_CON = 55;
        EZTEC_LIC_KEY = 56;
        EZTEC_INVALID_PARAM = 57;
        EZTEC_INTERNAL = 58;
        EZTEC_OUT_SEQ = 59;
        EZTEC_CURL = 60;
        EZTEC_MULTIPAGE_OPEN = 61;
        EZTEC_BAD_SHUTDOWN = 62;
        EZTEC_DLL_VERSION = 63;
        EZTEC_OCR_ERR = 64;
        EZTEC_ONLY_TO_PDF = 65;
        EZTEC_APP_TITLE = 66;
        EZTEC_PATH_CREATE = 67;
        EZTEC_LATE_LIC = 68;
        EZTEC_PDF_PASSWORD = 69;
        EZTEC_PDF_UNSUPPORTED = 70;
        EZTEC_PDF_BAFFLED = 71;
        EZTEC_PDF_INVALID = 72;
        EZTEC_PDF_COMPRESSION = 73;
        EZTEC_NOT_ENOUGH_PAGES = 74;




//--------- TWAIN State Control ------------------------------------

procedure TWAIN_Shutdown;
stdcall; external 'Eztwain3.dll'
// Shuts down and cleans up all EZTwain operations.
// All memory allocations are freed, all I/O operations
// are completed, any threads are terminated, and
// TWAIN is closed and unloaded.

function TWAIN_LoadSourceManager: BOOL;
stdcall; external 'Eztwain3.dll'
// Finds and loads the Data Source Manager, TWAIN.DLL.
// If Source Manager is already loaded, does nothing and returns TRUE(1).
// This can fail if TWAIN.DLL is not installed (in the right place), or
// if the library cannot load for some reason (insufficient memory?) or
// if TWAIN.DLL has been corrupted.

function TWAIN_OpenSourceManager(hwnd:HWND): BOOL;
stdcall; external 'Eztwain3.dll'
// Opens the Data Source Manager, if not already open.
// If the Source Manager is already open, does nothing and returns TRUE.
// This call will fail if the Source Manager is not loaded.

function TWAIN_OpenDefaultSource: BOOL;
stdcall; external 'Eztwain3.dll'
// This opens the source selected in the Select Source dialog.
// If some source is already open, does nothing and returns TRUE.
// Will load and open the Source Manager if needed.
// If this call returns TRUE, TWAIN is in STATE 4 (TWAIN_SOURCE_OPEN)

// These two functions allow you to enumerate the available data sources:
function TWAIN_GetSourceList: BOOL;
stdcall; external 'Eztwain3.dll'
// Fetches the list of sources into memory, so they can be returned
// one by one by TWAIN_GetNextSourceName, below.
// Returns TRUE (1) if successful, FALSE (0) otherwise.
// Note: In the special (and very unusual) case of an empty list,
// this function returns TRUE(1) if there was no other error.

function TWAIN_GetNextSourceName(sName:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Copies the next source name in the list into its parameter.
// The parameter is a string variable (char array in C/C++).
// You are responsible for allocating room for 33 8-bit characters
// in the string variable before calling this function.
// Returns TRUE (1) if successful, FALSE (0) if there are no more.

function TWAIN_NextSourceName: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Returns the next source name in the list.
// Returns the empty string when it comes to the end of the list.

function TWAIN_GetDefaultSourceName(sName:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Copies the name of the TWAIN default source into its parameter.
// The parameter is a string variable (char array in C/C++).
// You are responsible for allocating room for 33 8-bit characters
// in the string variable before calling this function.
// Normally returns TRUE (1) but will return FALSE (0) if:
//   - the TWAIN Source Manager cannot be loaded & initialized or
//   - there is no current default source (e.g. no sources are installed)

function TWAIN_DefaultSourceName: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Returns the name of the TWAIN default source device, as a string

function TWAIN_OpenSource(sName:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Opens the source with the given name.
// If that source is already open, does nothing and returns TRUE.
// If another source is open, closes it and attempts to open the specified source.
// Will load and open the Source Manager if needed.

function TWAIN_EnableSource(hwnd:HWND): BOOL;
stdcall; external 'Eztwain3.dll'
// Enables the open Data Source. This posts the source's user interface
// and allows image acquisition to begin.  If the source is already enabled,
// this call does nothing and returns TRUE.

function TWAIN_DisableSource: BOOL;
stdcall; external 'Eztwain3.dll'
// Disables the open Data Source, if any.
// This closes the source's user interface.
// If successful or the source is already disabled, returns TRUE(1).

function TWAIN_CloseSource: BOOL;
stdcall; external 'Eztwain3.dll'
// Closes the open Data Source, if any.
// If the source is enabled, disables it first.
// If successful or source is already closed, returns TRUE(1).

function TWAIN_CloseSourceManager(hwnd:HWND): BOOL;
stdcall; external 'Eztwain3.dll'
// Closes the Data Source Manager, if it is open.
// If a source is open, disables and closes it as needed.
// If successful (or if source manager is already closed) returns TRUE(1).

function TWAIN_UnloadSourceManager: BOOL;
stdcall; external 'Eztwain3.dll'
// Unloads the Data Source Manager i.e. TWAIN.DLL - releasing
// any associated memory or resources.
// If necessary, it will abort transfers, close the open source
// if any, and close the Source Manager.
// If successful, it returns TRUE(1)


function TWAIN_IsTransferReady: BOOL;
stdcall; external 'Eztwain3.dll'

function TWAIN_EndXfer: BOOL;
stdcall; external 'Eztwain3.dll'

function TWAIN_AbortAllPendingXfers: BOOL;
stdcall; external 'Eztwain3.dll'

//--------- High-level Capability Negotiation Functions --------

// These functions should only be called in State 4 (TWAIN_SOURCE_OPEN)

function TWAIN_SetXferCount(nXfers:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Negotiate with open Source the number of images application will accept.
// nXfers = -1 means any number
// Returns: TRUE(1) for success, FALSE(0) for failure.

function TWAIN_NegotiatePixelTypes(wPixTypes:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// Negotiate with the source to restrict pixel types that can be acquired.
// This tries to restrict the source to a *set* of pixel types.
// Returns: TRUE(1) for success, FALSE(0) for failure.
// See TWAIN_AcquireNative for some mask constants.
// A parameter of 0 (TWAIN_ANYTYPE) causes no negotiation & no restriction.
// You should not assume that the source will honor your restrictions, even
// if this call succeeds!

//----- Unit of Measure
// TWAIN unit codes (from twain.h)
const
        TWUN_INCHES = 0;
        TWUN_CENTIMETERS = 1;
        TWUN_PICAS = 2;
        TWUN_POINTS = 3;
        TWUN_TWIPS = 4;
        TWUN_PIXELS = 5;

function TWAIN_GetCurrentUnits: Integer;
stdcall; external 'Eztwain3.dll'
// Return the current unit of measure: inches, cm, pixels, etc.
// Many TWAIN parameters such as resolution are set and returned
// in the current unit of measure.
// There is no error return - in case of error it returns 0 (TWUN_INCHES)

function TWAIN_SetUnits(nUnits:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetCurrentUnits(nUnits:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Set the current unit of measure for the source.
// Returns: TRUE(1) for success, FALSE(0) for failure.
// Common unit codes (TWUN_*) are given above.
// Notes:
// 1. Most sources do not support all units, some support *only* inches!
// 2. If you want to get or set resolution in DPI (dots per *inch*), make
// sure the current units are inches, or you might get Dots-Per-cm!
// 3. Ditto (same comment) for ImageLayout, see below.

function TWAIN_GetBitDepth: Integer;
stdcall; external 'Eztwain3.dll'
// Get the current bitdepth, which can depend on the current PixelType.
// Bit depth is per color channel e.g. 24-bit RGB has bit depth 8.
// If anything goes wrong, this function returns 0.

function TWAIN_SetBitDepth(nBits:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// (Try to) set the current bitdepth (for the current pixel type).
// Note: You should set a PixelType, then set the bitdepth for that type.
// Returns: TRUE(1) for success, FALSE(0) for failure.

//------- TWAIN Pixel Types (from twain.h)
const
        TWPT_BW = 0;
        TWPT_GRAY = 1;
        TWPT_RGB = 2;
        TWPT_PALETTE = 3;
        TWPT_CMY = 4;
        TWPT_CMYK = 5;

function TWAIN_GetPixelType: Integer;
stdcall; external 'Eztwain3.dll'
// Ask the source for the current pixel type.
// If anything goes wrong (it shouldn't), this function returns 0 (TWPT_BW).

function TWAIN_SetPixelType(nPixType:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetCurrentPixelType(nPixType:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Try to set the current pixel type for acquisition.
// The source may select this pixel type, but don't assume it will.

function TWAIN_GetCurrentResolution: Double;
stdcall; external 'Eztwain3.dll'
// Ask the source for the current (horizontal) resolution.
// Resolution is in dots per current unit! (See TWAIN_GetCurrentUnits above)
// If anything goes wrong (it shouldn't) this function returns 0.0

function TWAIN_GetXResolution: Double;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetYResolution: Double;
stdcall; external 'Eztwain3.dll'
// Returns the current horizontal or vertical resolution, in dots per *current unit*.
// In the event of failure, returns 0.0.

function TWAIN_SetResolution(dRes:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetResolutionInt(nRes:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetCurrentResolution(dRes:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Try to set the current resolution (in both x & y).
// Resolution is in dots per current unit! (See TWAIN_GetCurrentUnits above)
// Note: The source may select this resolution, but don't assume it will.

// You can also set the resolution in X and Y separately, if your TWAIN
// device can handle this:
function TWAIN_SetXResolution(dxRes:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetYResolution(dyRes:Double): BOOL;
stdcall; external 'Eztwain3.dll'

function TWAIN_SetContrast(dCon:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Try to set the current contrast for acquisition.
// The TWAIN standard *says* that the range for this cap is -1000 ... +1000

function TWAIN_SetBrightness(dBri:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Try to set the current brightness for acquisition.
// The TWAIN standard *says* that the range for this cap is -1000 ... +1000

function TWAIN_SetThreshold(dThresh:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Try to set the threshold for black and white scanning.
// Should only affect 1-bit scans i.e. PixelType == TWPT_BW.
// The TWAIN default threshold value is 128.
// After staring at the TWAIN 1.6 spec for a while, I imagine that it implies
// that for 8-bit samples, values >= nThresh are thresholded to 1, others to 0.

function TWAIN_GetCurrentThreshold: Double;
stdcall; external 'Eztwain3.dll'
// Try to get and return the current value (MSG_GETCURRENT) of the
// ICAP_THRESHOLD capability.  If this fails for any reason, it
// will return -1.  *VERSIONS BEFORE 2.65 RETURNED 128.0*

//--------------------------------------------------------------
// Automatic post-processing of scanned pages
//
//
// Automatic deskewing of scanned pages
//
procedure TWAIN_SetAutoDeskew(nMode:Integer);
stdcall; external 'Eztwain3.dll'
// Select the 'auto-deskew' mode.
// Auto-deskew attempts to straighten up scans that are slightly crooked,
// up to about 10 degrees.
// The currently defined modes are:
//  0   - no auto deskew (default)
//  1   - auto deskew using EZTwain software algorithms

function TWAIN_GetAutoDeskew: Integer;
stdcall; external 'Eztwain3.dll'
// Return the current AutoDeskew mode.

//
// Automatic discarding of blank pages
//
procedure TWAIN_SetBlankPageMode(nMode:Integer);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetBlankPageMode: Integer;
stdcall; external 'Eztwain3.dll'
// Sets or gets the 'Skip Blank Pages' mode.
// The currently defined modes are:
//   0 = no special treatment for blank pages (default)
//   1 = blank pages are discarded by TWAIN_AcquireMultipageFile.
// See TWAIN_SetBlankPageThreshold below for more details.

procedure TWAIN_SetBlankPageThreshold(dDarkness:Double);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetBlankPageThreshold: Double;
stdcall; external 'Eztwain3.dll'
// Sets or gets the blank page 'darkness' threshold.
// In 'Skip Blank Pages' mode (see above), each page of a multipage
// scan is measured for 'darkness'.  If the darkness of a page
// is below the BlankPageThreshold, it is considered blank.
// See the related functions DIB_IsBlank and DIB_Darkness.
// 
// The default BlankPageThreshold is 0.02 (= 2% dark pixels).

function TWAIN_BlankDiscardCount: Integer;
stdcall; external 'Eztwain3.dll'
// Return the number of blank pages discarded (skipped) during
// the most recent multipage scan.
// Of course this only reports pages skipped by software, not
// any pages discarded as 'blank' inside the scanner - if such
// a feature is enabled.
//
// Automatic cropping of scanned pages
//
procedure TWAIN_SetAutoCrop(nMode:Integer);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetAutoCrop: Integer;
stdcall; external 'Eztwain3.dll'
// Select the AutoCrop mode.
// Auto-crop attempts to trim off black areas on the outside
// edges of each incoming image during scanning.
// It will not be effective on scanners that have white
// background outside the scanned document.
// The currently defined modes are:
//  0   - no auto crop (default)
//  1   - auto crop using EZTwain software algorithms
//  2   - use scanner autocrop if possible, otherwise no autocrop
//  3   - use scanner autocrop if possible, otherwise do software autocrop.

//
// Automatic contrast adjustment of scanned pages
//
procedure TWAIN_SetAutoContrast(nMode:Integer);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetAutoContrast: Integer;
stdcall; external 'Eztwain3.dll'
// Select the AutoContrast mode.
// Automatically adjust the contrast of each image - see
// DIB_AutoContrast for more information.
// The currently defined modes are:
//  0   - no autocontrast.
//  1   - autocontrast using EZTwain software algorithms

//
// Automatic OCR of scanned pages.
//
procedure TWAIN_SetAutoOCR(nMode:Integer);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetAutoOCR: Integer;
stdcall; external 'Eztwain3.dll'
// Sets or gets the auto-OCR mode
// By default this mode is 0 = OFF.
// When this mode is on (1), EZTwain applies OCR, if available, to each incoming
// scanned page or image and temporarily stores the result.  In this mode,
// if you are scanning directly to PDF format using TWAIN_AcquireToFilename
// or TWAIN_AcquireMultipageFile, the OCR'd text is also written to each
// PDF page as invisible text, to facilitate indexing and searching.
// If you are scanning individual pages you can call OCR_Text or OCR_GetText
// to retrieve the text found on the most recently scanned page.
// In this mode, any Acquire call discards any previous OCR text.
//
// The currently selected OCR engine is used: See OCR_SelectEngine and co.
// Caution: If OCR fails for some reason in auto-OCR mode, an error is recorded
// (see TWAIN_LastErrorCode, TWAIN_ReportLastError) but the scanning function
// may report success.

//
// Automatic negation of scanned pages
//
procedure TWAIN_SetAutoNegate(bYes:BOOL);
stdcall; external 'Eztwain3.dll'
function TWAIN_GetAutoNegate: BOOL;
stdcall; external 'Eztwain3.dll'
// Set or get the "AutoNegate" flag: When this flag is set (non-zero)
// EZTwain automatically 'negates' any B&W scanned image that is > 80% black
// i.e. it exchanges black & white in the image.
// This flag is TRUE (1) by default.

//--------------------------------------------------------------


function TWAIN_SetXferMech(mech:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_XferMech: Integer;
stdcall; external 'Eztwain3.dll'
// Try to set or get the transfer mode - one of the following:
const
        XFERMECH_NATIVE = 0;
        XFERMECH_FILE = 1;
        XFERMECH_MEMORY = 2;
// You should not need to set this mode directly - using
// TWAIN_Acquire, TWAIN_AcquireNative and TWAIN_AcquireFile will set
// the appropriate transfer mode for you.

function TWAIN_SupportsFileXfer: BOOL;
stdcall; external 'Eztwain3.dll'
// Returns TRUE(1) if the open DS claims to support file transfer mode (XFERMECH_FILE)
// Returns FALSE(0) otherwise.
// This mode is optional.  If TRUE, you can use AcquireFile.

function TWAIN_SetPaperSize(nPaper:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// During the next scan, request that the scanner scan the specified paper size.
// Most scanners support the first few paper sizes, excluding any that are
// larger than their physical scan capacity.
// To determine the paper sizes supported by a particular scanner, see
// "Working with Capabilities" in the EZTwain User Guide.
//
// Note - These are synonyms form the TWSS_* constants in TWAIN.H
const
        PAPER_NONE = 0;
        PAPER_A4LETTER = 1;
        PAPER_A4 = 1;
        PAPER_B5LETTER = 2;
        PAPER_JISB5 = 2;
        PAPER_USLETTER = 3;
        PAPER_USLEGAL = 4;
        PAPER_A5 = 5;
        PAPER_B4 = 6;
        PAPER_ISOB4 = 6;
        PAPER_B6 = 7;
        PAPER_ISOB6 = 7;
        PAPER_USLEDGER = 9;
        PAPER_USEXECUTIVE = 10;
        PAPER_A3 = 11;
        PAPER_B3 = 12;
        PAPER_ISOB3 = 12;
        PAPER_A6 = 13;
        PAPER_C4 = 14;
        PAPER_C5 = 15;
        PAPER_C6 = 16;
        PAPER_4A0 = 17;
        PAPER_2A0 = 18;
        PAPER_A0 = 19;
        PAPER_A1 = 20;
        PAPER_A2 = 21;
        PAPER_A7 = 22;
        PAPER_A8 = 23;
        PAPER_A9 = 24;
        PAPER_A10 = 25;
        PAPER_ISOB0 = 26;
        PAPER_ISOB1 = 27;
        PAPER_ISOB2 = 28;
        PAPER_ISOB5 = 29;
        PAPER_ISOB7 = 30;
        PAPER_ISOB8 = 31;
        PAPER_ISOB9 = 32;
        PAPER_ISOB10 = 33;
        PAPER_JISB0 = 34;
        PAPER_JISB1 = 35;
        PAPER_JISB2 = 36;
        PAPER_JISB3 = 37;
        PAPER_JISB4 = 38;
        PAPER_JISB6 = 39;
        PAPER_JISB7 = 40;
        PAPER_JISB8 = 41;
        PAPER_JISB9 = 42;
        PAPER_JISB10 = 43;
        PAPER_C0 = 44;
        PAPER_C1 = 45;
        PAPER_C2 = 46;
        PAPER_C3 = 47;
        PAPER_C7 = 48;
        PAPER_C8 = 49;
        PAPER_C9 = 50;
        PAPER_C10 = 51;
        PAPER_USSTATEMENT = 52;
        PAPER_BUSINESSCARD = 53;

function TWAIN_GetPaperDimensions(nPaper:Integer; nUnits:Integer; var pdW:Double; var pdH:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Retrieve the width and height of a standard paper size.
// 1st parameter is a PAPER_ code.
// 2nd parameter is a unit code, TWUN_INCHES, TWUN_CENTIMETERS, etc.
// 3rd & 4th parameter are pointers to double variables that receive the width
// and height of the specified paper size, in the specified units.
// Returns TRUE(1) if successful, FALSE(0) otherwise.

//-------- Document Feeder -------

function TWAIN_HasFeeder: BOOL;
stdcall; external 'Eztwain3.dll'
// Returns TRUE(1) if the source indicates it has a document feeder.
// Note: A FALSE(0) is returned if the source does not handle this inquiry.

function TWAIN_ProbablyHasFlatbed: BOOL;
stdcall; external 'Eztwain3.dll'
// Returns TRUE(1) if we think the source has a flatbed available.
// It's a good guess but not a guarantee - we could be wrong.

function TWAIN_IsFeederSelected: BOOL;
stdcall; external 'Eztwain3.dll'
// Returns TRUE(1) if the document feeder is selected.

function TWAIN_SelectFeeder(bYes:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// (Try to) select or deselect the document feeder.
// The document feeder, if any, is selected if bYes is non-zero.
// The flatbed, if any, is selected if bYes is zero.
// Note: A few of the scanners that have both a flatbed and 
// a feeder ignore this request in some circumstances.
// Returns TRUE(1) if successful, FALSE(0) otherwise.

function TWAIN_IsAutoFeedOn: BOOL;
stdcall; external 'Eztwain3.dll'
// Returns TRUE(1) if automatic feeding is enabled, otherwise FALSE(0).
// Make sure the feeder is selected before calling this function.

function TWAIN_SetAutoFeed(bYes:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// (Try to) turn on/off automatic feeding thru the feeder.
// Returns TRUE(1) if successful, FALSE(0) otherwise.
// Note: TWAIN_AcquireMultipageFile calls TWAIN_SetAutoFeed(True).

function TWAIN_IsFeederLoaded: BOOL;
stdcall; external 'Eztwain3.dll'
// Returns TRUE(1) if there are documents in the feeder.
// Make sure the feeder is selected before calling this function.

function TWAIN_SetAutoScan(bYes:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// Setting this to TRUE gives the scanner permission to 'scan ahead'
// i.e. to pull pages from the feeder and scan them before 
// they have been requested.  On high-speed scanners, you may
// have to enable AutoScan to achieve the maximum scanning rate.
// Returns TRUE(1) if successful, FALSE(0) otherwise.
// This call will fail on most flatbeds & cameras, and some 'feeder'
// scanners.
// TWAIN_AcquireMultipageFile calls TWAIN_SetAutoScan(True).

//-------- Duplex Scanning -------

function TWAIN_GetDuplexSupport: Integer;
stdcall; external 'Eztwain3.dll'
// Query the device for duplex scanning support.
//   Return values:
// 0    = no support (or error, or query not recognized)
// 1    = 1-pass duplex
// 2    = 2-pass duplex

function TWAIN_EnableDuplex(bYes:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// Enable (bYes not 0) or disable (bYes=0) duplex scanning.
// Returns TRUE(1) if successful, FALSE(0) otherwise.

function TWAIN_IsDuplexEnabled: BOOL;
stdcall; external 'Eztwain3.dll'
// Returns TRUE(1) if the device supports duplex scanning
// and duplex scanning is enabled.  FALSE(0) otherwise.

//--------- Other 'exotic' capabilities --------

function TWAIN_HasControllableUI: Integer;
stdcall; external 'Eztwain3.dll'
// Return 1 if source claims UI can be hidden (see SetHideUI above)
// Return 0 if source says UI *cannot* be hidden
// Return -1 if source (pre TWAIN 1.6) cannot answer the question.

function TWAIN_SetIndicators(bVisible:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// Tell the device to show or hide progress indicators during acquisition.
// Default is TRUE, which gives the device permission to show a progress
// box or similar, but does not require it.
// Returns: TRUE(1) for success, FALSE(0) for failure.

function TWAIN_Compression: Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetCompression(compression:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Set/Get compression style for transferred data
// Set returns TRUE(1) for success, FALSE(0) for failure.

function TWAIN_Tiled: BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetTiled(bTiled:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// Set/Get whether source does memory xfer via strips or tiles.
// bTiled = TRUE if it uses tiles for transfer.
// Set returns: TRUE(1) for success, FALSE(0) for failure.

function TWAIN_PlanarChunky: Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetPlanarChunky(shape:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Set/Get current pixel shape (TWPC_CHUNKY or TWPC_PLANAR), or -1.
// Set returns TRUE(1) for success, FALSE(0) for failure.

const
        CHUNKY_PIXELS = 0;
        PLANAR_PIXELS = 1;

function TWAIN_PixelFlavor: Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetPixelFlavor(flavor:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Set/Get pixel 'flavor' - whether a '0' pixel value means black or white:
// Set returns: TRUE(1) for success, FALSE(0) for failure.

const
        CHOCOLATE_PIXELS = 0;
        VANILLA_PIXELS = 1;


function TWAIN_SetLightPath(bTransmissive:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// Tries to select transparent or reflective media on the open source.
// A parameter of TRUE(1) means transparent, FALSE(0) means reflective.
// Returns: TRUE(1) for success, FALSE(0) for failure.

function TWAIN_SetAutoBright(bOn:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetGamma(dGamma:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetShadow(d:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetHighlight(d:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Set auto-brightness, gamma, shadow, and highlight values.
// Refer to the TWAIN specification for definitions of these settings.
// Returns: TRUE(1) for success, FALSE(0) for failure.

//--------- Image Layout (Region of Interest) --------

procedure TWAIN_SetRegion(L:Double; T:Double; R:Double; B:Double);
stdcall; external 'Eztwain3.dll'
// Specify the region to be acquired, in current unit of measure.
// This is the recommended most-general way to scan a region.
// Tries to use TWAIN_SetImageLayout and TWAIN_SetFrame (see below).
// If the device ignores those, the specified region is extracted
// after each scan completes, by software cropping. (DIB_RegionCopy)
// In other words, this call should *always* produce scans of
// the requested region, unless you specify a region in inches or
// centimeters and the device is a camera whose only unit is pixels.

procedure TWAIN_ResetRegion;
stdcall; external 'Eztwain3.dll'
// Clear any region set with TWAIN_SetRegion above.

function TWAIN_SetImageLayout(L:Double; T:Double; R:Double; B:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Specify the area to scan, sometimes called the ROI (Region of Interest)
// Returns: TRUE(1) for success, FALSE(0) for failure.
// This call is only valid in State 4.
// L, T, R, B = distance to left, top, right, and bottom edge of
// area to scan, measured in the current unit of measure,
// from the top-left corner of the 'original page' (TWAIN 1.6 8-22)

function TWAIN_GetImageLayout(var L:Double; var T:Double; var R:Double; var B:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetDefaultImageLayout(var L:Double; var T:Double; var R:Double; var B:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Get the current or default (power-on) area to scan.
// Returns: TRUE(1) for success, FALSE(0) for failure.
// This call is valid in States 4-6.
// Supposedly the returned values (see above)
// are in the current unit of measure (ICAP_UNITS), but I observe that
// many DS's ignore ICAP_UNITS when dealing with Image Layout.

function TWAIN_ResetImageLayout: BOOL;
stdcall; external 'Eztwain3.dll'
// Reset the area to scan to the default (power-on) settings.
// This call is only valid in State 4.
// Returns: TRUE(1) for success, FALSE(0) for failure.


// Closely related:
function TWAIN_SetFrame(L:Double; T:Double; R:Double; B:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// This is an alternative way to set the scan area.
// Some scanners will respond to this instead of SetImageLayout.
// Returns: TRUE(1) for success, FALSE(0) for failure.
// This call is only valid in State 4.
// L, T, R, B = distance to left, top, right, and bottom edge of
// area to scan, measured in the current unit of measure,


//--------- Tone Response Curves --------

function TWAIN_SetGrayResponse(var pcurve:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Define a translation of gray pixel values.
// When device digitizes a pixel with value V, that
// pixel is translated to value pcurve[V] before it
// is returned to the application.
// Device must be open (State 4),
// Current PixelType must be TWPT_GRAY or TWPT_RGB,
// current BitDepth should be 8.
// pcurve must be a table (array, vector) of 256 entries.
// Returns: TRUE(1) for success, FALSE(0) for failure.

function TWAIN_SetColorResponse(var pred:Integer; var pgreen:Integer; var pblue:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Define a translation of color values.
// Like TWAIN_SetGrayResponse (above) but separate translation can
// be applied to each color channel.
// Returns: TRUE(1) for success, FALSE(0) for failure.

function TWAIN_ResetGrayResponse: BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_ResetColorResponse: BOOL;
stdcall; external 'Eztwain3.dll'
// These two functions reset the response curve to map every
// value V to itself i.e. a 'do nothing' translation.
// Returns: TRUE(1) for success, FALSE(0) for failure.

//--------- Barcode Recognition -------

function BARCODE_IsAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// TRUE(1) if barcode recognition is available.
// Returns FALSE(0) otherwise.

function BARCODE_Version: Integer;
stdcall; external 'Eztwain3.dll'
// Return the barcode module version * 100.

// Barcode recognition engines supported by EZTwain:
const
        EZBAR_ENGINE_NONE = 0;
        EZBAR_ENGINE_DOSADI = 1;
        EZBAR_ENGINE_AXTEL = 2;
        EZBAR_ENGINE_LEADTOOLS = 3;
        EZBAR_ENGINE_BLACKICE = 4;

// The Axtel barcode engine has been discontinued by Axtel.
// The LEADTOOLS engine must be separately licensed from LEADTOOLS - www.leadtools.com
// The Black Ice barcode engine must be separately licensed from Black Ice. 

function BARCODE_IsEngineAvailable(nEngine:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function BARCODE_SelectEngine(nEngine:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function BARCODE_SelectedEngine: Integer;
stdcall; external 'Eztwain3.dll'

function BARCODE_EngineName(nEngine:Integer): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Returns the short name ("None", "Dosadi", "Axtel", "LEADTOOLS", "Black Ice") of the specified
// engine, or the empty string if nEngine is not a recognized barcode engine code.

procedure BARCODE_SetLicenseKey(sKey:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Supply your license key for the currently selected engine.
// The Dosadi engine does not currently require a key.
// For LeadTools, this is a 1D Barcode Module key obtained from LeadTools

function BARCODE_ReadableCodes: Integer;
stdcall; external 'Eztwain3.dll'
// Return the sum of the barcode types recognized by the current selected engine.
//
// Barcode types:
const
        EZBAR_EAN_13 = $1;
        EZBAR_EAN_8 = $2;
        EZBAR_UPCA = $4;
        EZBAR_UPCE = $8;
        EZBAR_CODE_39 = $10;
        EZBAR_CODE_39FA = $20;
        EZBAR_CODE_128 = $40;
        EZBAR_CODE_I25 = $80;
        EZBAR_CODA_BAR = $100;
        EZBAR_UCCEAN_128 = $200;
        EZBAR_CODE_93 = $400;
        EZBAR_ANY = -1;

function BARCODE_TypeName(nType:Integer): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return a human-readable name for the specified barcode type/symbology.

function BARCODE_SetDirectionFlags(nDirFlags:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function BARCODE_GetDirectionFlags: Integer;
stdcall; external 'Eztwain3.dll'
function BARCODE_AvailableDirectionFlags: Integer;
stdcall; external 'Eztwain3.dll'
// Set/Get the directions the engine will scan for barcodes.
// The default is left-to-right ONLY.
// Scanning for barcodes in multiple directions can slow the
// recognition process.  BARCODE_SetDirectionFlags will return TRUE if
// completely successful, FALSE if any direction is invalid or not supported.
// Setting the direction flags to -1 is interpreted as "select all supported
// directions."

// Barcode direction flags - can be or'ed together
const
        EZBAR_LEFT_TO_RIGHT = $1;
        EZBAR_RIGHT_TO_LEFT = $2;
        EZBAR_TOP_TO_BOTTOM = $4;
        EZBAR_BOTTOM_TO_TOP = $8;
        EZBAR_DIAGONAL = $10;
// some common combinations:
        EZBAR_HORIZONTAL = $3;
        EZBAR_VERTICAL = $C;

procedure BARCODE_SetZone(left:Integer; top:Integer; w:Integer; h:Integer);
stdcall; external 'Eztwain3.dll'
// Restrict barcode recognition to one zone (in pixels) of each image.

procedure BARCODE_NoZone;
stdcall; external 'Eztwain3.dll'
// Cancel any zone restriction - subsequent barcode recognition
// applies to the entire image.

function BARCODE_Recognize(hdib:Cardinal; nMaxCount:Integer; nType:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Find and recognize barcodes in the given image.
// Don't look for more than nMaxCount barcodes (-1 means 'any number')
// Expect barcodes of the specified type (-1 means 'any recognized type')
// You can add or 'or' together barcode types.
//
// Return values:
//   n>0    n barcodes found
//   0      no barcodes found
//  -1      barcode services not available.
//      -2              -not used-
//  -3      invalid or null image
//      -4              memory error (low memory?)
//  -5          internal error, or error from 3rd party barcode engine.

function BARCODE_Text(n:Integer): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return the text of the nth barcode recognized by the last BARCODE_Recognize.
// barcodes are numbered from 0.
// If there is any problem of any kind, returns the empty string.

function BARCODE_GetText(n:Integer; Text:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Get the text of the nth barcode recognized by the last BARCODE_Recognize.
// Please allow 64 characters in your text buffer.  Use a smaller buffer
// only if you *know* that the barcode type is limited to shorter strings.

function BARCODE_Type(n:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return the type (symbology) of the nth barcode recognized.

function BARCODE_GetRect(n:Integer; var L:Double; var T:Double; var R:Double; var B:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Get the rectangle bounding the nth barcode found in the last BARCODE_Recognize.
// Returns TRUE(1) if successful, FALSE(0) otherwise.  The only likely cause
// of a FALSE return would be an invalid value of n, or a null reference.
// L    = left edge
// T    = top edge
// R    = right edge
// B    = bottom edge
// Note: Returned coordinates are in pixels, relative to the upper-left corner
// of the image given to BARCODE_Recognize.

//--------- OCR (Optical Character Recognition) -------

// Note: Requires the Transym OCR engine (TOCR) which must be separately
// licensed from Transym - See www.transym.com

function OCR_IsAvailable: BOOL;
stdcall; external 'Eztwain3.dll'
// TRUE(1) if OCR recognition is available in some form.
// Returns FALSE(0) otherwise.

function OCR_Version: Integer;
stdcall; external 'Eztwain3.dll'
// Returns version * 100 of the EZTwain OCR module.

// ----- OCR engines supported by EZTwain -----
const
        EZOCR_ENGINE_NONE = 0;
        EZOCR_ENGINE_TRANSYM = 1;

function OCR_IsEngineAvailable(nEngine:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function OCR_SelectEngine(nEngine:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function OCR_SelectedEngine: Integer;
stdcall; external 'Eztwain3.dll'
function OCR_SelectDefaultEngine: BOOL;
stdcall; external 'Eztwain3.dll'

function OCR_EngineName(nEngine:Integer): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Returns the short name ("None", "Transym TOCR") of the specified
// engine, or the empty string if nEngine is not a recognized OCR engine code.

procedure OCR_SetEngineKey(sKey:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Set the license key to be passed to the OCR engine.
// * If you are using the reseller version of Transym's TOCR, pass the
//   RegNo provided by Transym, as a string e.g. "0123-4567-89AB-CDEF"

procedure OCR_SetLineBreak(sEOL:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Set the character sequence to use for line breaks in
// the returned OCR'd text (as returned by OCR_Text and OCR_GetText).
//
// The default OCR line break is \n (LF, 0x0A)
// Other commonly used line breaks are \r (CR, 0x0D) or CRLF.
// Set this *before* doing OCR - it does not modify already
// recognized text.

function OCR_RecognizeDib(hdib:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
function OCR_RecognizeDibZone(hdib:Cardinal; left:Integer; top:Integer; w:Integer; h:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Find and recognize text in the given image, or
// in a designated zone of an image.
//
// Return values:
//   0          no error, but no text found
//   n > 0      n characters found (including spaces and returns)
//  -1          OCR services not available
//  -3          invalid or null image
//  -5          internal error or error returned by OCR engine
//
// In case of error, call TWAIN_ReportLastError to display details,
// or call TWAIN_LastErrorCode and related functions.

function OCR_Text: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return the text found by the last OCR_RecognizeDib
// If there is any problem of any kind, returns the empty string.

function OCR_GetText(TextBuffer:PAnsiChar; nBufLen:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Read the text recognized by the last OCR_RecognizeDib
// into the TextBuffer, which is allocated to hold nBufLen chars.
// Returns the number of characters actually returned.
// Always appends a trailing 0 (NUL).
// Will return 0 if the available text does not fit.

function OCR_TextLength: Integer;
stdcall; external 'Eztwain3.dll'
// Returns the number of characters in OCR_Text.
// Does not count the terminal NUL,
// for those of you working with C-style strings.

function OCR_TextOrientation: Integer;
stdcall; external 'Eztwain3.dll'
// Returns the orientation of the text found by the last OCR_RecognizeDib.
// The value is the number of degrees clockwise that the input
// image was auto-rotated before OCR was performed.
// Currently, the returned value is always a multiple of 90,
// The only possible values are 0, 90, 180 and 270.
// Example: If the original was turned 90 degrees clockwise before scanning,
// it will be auto-rotated 90 degrees *counter-clockwise* before OCR, so
// then the value of this function will be 270.

function OCR_GetCharPositions(var charx:Integer; var chary:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function OCR_GetCharSizes(var charw:Integer; var charh:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Return the coordinates or sizes of the characters found by the last
// OCR_RecognizeDib call.
// For each character of the string returned by OCR_Text or OCR_GetText,
// these functions return the x and y coordinates in the array charx and chary,
// and the width and height in the arrays charw and charh.
// So (charx[i],chary[i]) will be the position of the ith character.
// Coordinates are for the top-left corner of the character, relative
// to the top-left corner of the OCR'd image.
// Width and height are in pixels.
//
// Please make *sure* that you pass in (the address/reference of)
// two arrays allocated to hold n values, where n is the return
// value from the last call to OCR_Recognize.

procedure OCR_GetResolution(var xdpi:Double; var ydpi:Double);
stdcall; external 'Eztwain3.dll'
// Return the resolution (in DPI) of the last image given to OCR_RecognizeDib.
// Useful for translating pixel coordinates and sizes into physical (inch) values.

procedure OCR_ClearText;
stdcall; external 'Eztwain3.dll'
// Clear any currently stored OCR text.

function OCR_WritePage(hdib:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// If an OCR engine is selected and available, and there is
// a PDF file open for writing (by TWAIN_BeginMultipageFile), then
// this function OCRs the image, and writes both the image and
// the text to the output PDF.
//
// Returns TRUE if successful, FALSE otherwise:
// In case of error, call TWAIN_ReportLastError to display details,
// or call TWAIN_LastErrorCode and related functions.

function OCR_WriteTextToPDF: BOOL;
stdcall; external 'Eztwain3.dll'
// Write the text from the last OCR to the next PDF page.
// Returns TRUE if successful, FALSE in case of error.
// If there is no OCR text to write, does nothing & returns TRUE.

//--------- Fun With Containers --------

// Capability values are passed thru the TWAIN API in complex global
// memory structures called 'containers'.  EZTWAIN abstracts these
// containers with a handle (an integer) called an HCONTAINER.
// If you are coding in VB or similar, this is a 32-bit integer.
// The following functions provide reasonably comprehensive access
// to the contents of containers.  See also TWAIN_Get, TWAIN_Set.
//
// There are four shapes of containers, which I call 'formats'.
// Depending on its format, a container holds some 'items' - these
// are simple data values, all the same type in a given container.
// Item types are enumerated by TWTY_*

// Container formats, same codes as in TWAIN.H
const
        TWON_ARRAY = 3;
        TWON_ENUMERATION = 4;
        TWON_ONEVALUE = 5;
        TWON_RANGE = 6;


procedure CONTAINER_Free(hcon:HCONTAINER);
stdcall; external 'Eztwain3.dll'
// Free the memory and resources of a capability container.

function CONTAINER_Copy(hcon:HCONTAINER): HCONTAINER;
stdcall; external 'Eztwain3.dll'
// Create an exact copy of the container.

function CONTAINER_Equal(hconA:HCONTAINER; hconB:HCONTAINER): BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE (1) iff all properties of hconA and hconB are the same.

function CONTAINER_Format(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
// Return the 'format' of this container: TWON_ONEVALUE, etc.

function CONTAINER_ItemCount(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
// Return the number of values in the container.
// For a ONEVALUE, return 1.

function CONTAINER_ItemType(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
// Return the item type (what exact kind of values are in the container.)
// See the TWTY_* definitions in TWAIN.H

function CONTAINER_TypeSize(nItemType:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return the size in bytes of an item of the specified type (TWTY_*)

procedure CONTAINER_GetStringValue(hcon:HCONTAINER; n:Integer; sText:PAnsiChar);
stdcall; external 'Eztwain3.dll'
function CONTAINER_FloatValue(hcon:HCONTAINER; n:Integer): Double;
stdcall; external 'Eztwain3.dll'
function CONTAINER_IntValue(hcon:HCONTAINER; n:Integer): Integer;
stdcall; external 'Eztwain3.dll'
function CONTAINER_StringValue(hcon:HCONTAINER; n:Integer): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Get the value of the nth item in the container.
// n is forced into the range 0 to ItemCount(hcon)-1.
// For string values, if the container items are not strings, they
// are converted to an equivalent string (e.g. "TRUE", "23", "2.37", etc.)


function CONTAINER_ContainsValue(hcon:HCONTAINER; d:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function CONTAINER_ContainsValueInt(hcon:HCONTAINER; n:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE(1) if the value is one of the items in the container.
function CONTAINER_FindValue(hcon:HCONTAINER; d:Double): Integer;
stdcall; external 'Eztwain3.dll'
function CONTAINER_FindValueInt(hcon:HCONTAINER; n:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return the 0-origin index of the value in the container.
// Return -1 if not found.

function CONTAINER_CurrentValue(hcon:HCONTAINER): Double;
stdcall; external 'Eztwain3.dll'
function CONTAINER_DefaultValue(hcon:HCONTAINER): Double;
stdcall; external 'Eztwain3.dll'
function CONTAINER_CurrentValueInt(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
function CONTAINER_DefaultValueInt(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
// Return the container's current or power-up (default) value.
// Array containers do not have these and will return -1.0.
// OneValue containers always return their (one) value.

function CONTAINER_DefaultIndex(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
function CONTAINER_CurrentIndex(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
// Return the index of the Default or Current value.
// Works on Enumerations, Ranges and OneValues.
// (Always returns 0 for a OneValue)
// Returns -1 for an Array.


function CONTAINER_MinValue(hcon:HCONTAINER): Double;
stdcall; external 'Eztwain3.dll'
function CONTAINER_MaxValue(hcon:HCONTAINER): Double;
stdcall; external 'Eztwain3.dll'
function CONTAINER_MinValueInt(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
function CONTAINER_MaxValueInt(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
// Return the smallest/largest value in the container.
// For a OneValue, this is just the value.
// For a Range, these are the Min and Max values of the range.
// For an Array or Enumeration, the container is searched to find
// the smallest/largest value.

function CONTAINER_StepSize(hcon:HCONTAINER): Double;
stdcall; external 'Eztwain3.dll'
function CONTAINER_StepSizeInt(hcon:HCONTAINER): Integer;
stdcall; external 'Eztwain3.dll'
// Return the 'step' value of a Range container.
// Returns -1 if the container is not a Range.

// The following four functions create containers from scratch:
// nItemType is one of the TWTY_* item types from TWAIN.H
// nItems is the number of items, in an array or enumeration.
// dMin, dMax, dStep are the beginning, ending, and step value of a range.
function CONTAINER_OneValue(nItemType:Integer; dVal:Double): HCONTAINER;
stdcall; external 'Eztwain3.dll'
function CONTAINER_Range(nItemType:Integer; dMin:Double; dMax:Double; dStep:Double): HCONTAINER;
stdcall; external 'Eztwain3.dll'
function CONTAINER_Array(nItemType:Integer; nItems:Integer): HCONTAINER;
stdcall; external 'Eztwain3.dll'
function CONTAINER_Enumeration(nItemType:Integer; nItems:Integer): HCONTAINER;
stdcall; external 'Eztwain3.dll'

function CONTAINER_SetItem(hcon:HCONTAINER; n:Integer; dVal:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function CONTAINER_SetItemInt(hcon:HCONTAINER; n:Integer; nVal:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
function CONTAINER_SetItemString(hcon:HCONTAINER; n:Integer; sVal:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function CONTAINER_SetItemFrame(hcon:HCONTAINER; n:Integer; l:Double; t:Double; r:Double; b:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function CONTAINER_GetItemFrame(hcon:HCONTAINER; n:Integer; var L:Double; var T:Double; var R:Double; var B:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Set(or get) the nth item of the container to dVal or pzText, or frame(l,t,r,b).
// NOTE: A OneValue is treated as an array with 1 element. 
// Return TRUE(1) if successful. FALSE(0) for error such as:
//    The container is not an array, enumeration, or onevalue
//    n < 0 or n >= CONTAINER_ItemCount(hcon)
//    the value cannot be represented in this container's ItemType.
// Frame operations fail if the CONTAINER_ItemType is not TWTY_FRAME.

function CONTAINER_SelectCurrentValue(hcon:HCONTAINER; dVal:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function CONTAINER_SelectCurrentItem(hcon:HCONTAINER; n:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Select the current value within an enumeration or range,
// by specifying either the value, or its index.
// Returns TRUE(1) if successful, FALSE(0) otherwise.
// This will fail if:
//    The container is not an enumeration or range.
//    dVal is not one of the values in the container
//    n < 0 or n >= CONTAINER_ItemCount(hcon)

function CONTAINER_SelectDefaultValue(hcon:HCONTAINER; dVal:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function CONTAINER_SelectDefaultItem(hcon:HCONTAINER; n:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Select the default value in an enumeration or range.
// We're not sure what this would be good for, since an application
// cannot change the default value of a capability - that value is
// determined by the device TWAIN driver.
// So these functions are for logical completeness only.

function CONTAINER_DeleteItem(hcon:HCONTAINER; n:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Delete the nth item from an Array or Enumeration container.
// Returns TRUE(1) for success, FALSE(0) otherwise. Failure causes:
//   invalid container handle
//   container is not an array or enumeration
//   n < 0 or n >= ItemCount(hcon)

function CONTAINER_InsertItem(hcon:HCONTAINER; n:Integer; dVal:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Insert an item with value dVal into the container at position n.
// If n < 0, the item is inserted at the end of the container.
// Return TRUE(1) on success, FALSE(0) on failure.
// Possible causes of failure:
//   NULL or invalid container handle
//   container format is not enumeration or array
//   memory allocation failed - heap corrupted, or out of memory.

//--- Very low level CONTAINER functions you probably won't need:
function CONTAINER_Wrap(nFormat:Integer; hcon:HANDLE): HCONTAINER;
stdcall; external 'Eztwain3.dll'
// Wrap a TWAIN container handle into an HCONTAINER object.
// Note: *Do Not* free the hcon - it is now owned by the HCONTAINER.
function CONTAINER_Unwrap(hcon:HCONTAINER): HANDLE;
stdcall; external 'Eztwain3.dll'
// Unwrap a TWAIN container from an HCONTAINER object - free the
// HCONTAINER and return the original TWAIN container handle.
function CONTAINER_Handle(hcon:HCONTAINER): HANDLE;
stdcall; external 'Eztwain3.dll'
// Retrieve the handle of the TWAIN container wrapped in our HCONTAINER
function CONTAINER_IsValid(hcon:HCONTAINER): BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE if the argument seems to be a valid HCONTAINER object.

//--------- Low-level Capability Negotiation Functions --------

// Setting a capability is valid only in State 4 (TWAIN_SOURCE_OPEN)
// Getting a capability is valid in State 4 or any higher state.

function TWAIN_IsCapAvailable(uCap:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// Test if open device responds to a 'Get' on a capability.
// Only valid in State 4 or higher.
// Returns TRUE(1) if the capability can be queried, FALSE(0) if not.

function TWAIN_Get(uCap:Cardinal): HCONTAINER;
stdcall; external 'Eztwain3.dll'
// Issue a DAT_CAPABILITY/MSG_GET to the open source.
// Return a capability 'container' - the 'MSG_GET' value of the capability.
// Use CONTAINER_* functions to examine and modify the container object.
// Use CONTAINER_Free to release it when you are done with it.
// A return value of 0 indicates failure:  Call GetConditionCode
// or ReportLastError above.

function TWAIN_GetDefault(uCap:Cardinal): HCONTAINER;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetCurrent(uCap:Cardinal): HCONTAINER;
stdcall; external 'Eztwain3.dll'
// Issue a DAT_CAPABILITY/MSG_GETDEFAULT or MSG_GETCURRENT.  See Get above.

function TWAIN_Set(uCap:Cardinal; hcon:HCONTAINER): BOOL;
stdcall; external 'Eztwain3.dll'
// Issue a DAT_CAPABILITY/MSG_SET to the open source,
// using the specified capability and container.
// Return value as for TWAIN_DS

function TWAIN_Reset(uCap:Cardinal): BOOL;
stdcall; external 'Eztwain3.dll'
// Issue a MSG_RESET on the specified capability.
// State must be 4.  Returns TRUE(1) if successful, FALSE(0) otherwise.

function TWAIN_QuerySupport(uCap:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Issue a MSG_QUERYSUPPORT on the specified capability.
// State must be 4 or higher.  Returns the integer value that the device
// returned, which can be 0.
// A return < 0 indicates an error.

function TWAIN_SetCapability(cap:Cardinal; dValue:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// The most general capability-setting function, it negotiates
// with the open device to set the given capability to the specified value.
// If successful, returns TRUE(1), otherwise FALSE(0).
// There must be a device open and in state 4, or an error is recorded.
// (See TWAIN_ReportLastError.)

function TWAIN_SetCapString(cap:Cardinal; sValue:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Set the value of a capability that takes a string value.
// You don't need to specify the 'itemType', EZTwain asks the driver
// which itemType it wants.

function TWAIN_SetCapBool(cap:Cardinal; bValue:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// Shorthand for TWAIN_SetCapOneValue(cap, TWTY_BOOL, bValue);

function TWAIN_GetCapBool(cap:Cardinal; bDefault:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetCapFix32(cap:Cardinal; dDefault:Double): Double;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetCapUint16(cap:Cardinal; nDefault:Integer): Integer;
stdcall; external 'Eztwain3.dll'
function TWAIN_GetCapUint32(cap:Cardinal; lDefault:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Issue a DAT_CAPABILITY/MSG_GETCURRENT on the specified capability,
// assuming the value type is Bool, Fix32, etc..
// If successful, return the returned value.  Otherwise return bDefault.
// This is only valid in State 4 (TWAIN_SOURCE_OPEN) or higher.

function TWAIN_SetCapFix32(Cap:Cardinal; dVal:Double): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetCapOneValue(Cap:Cardinal; ItemType:Cardinal; ItemVal:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Do a DAT_CAPABILITY/MSG_SET, on capability 'Cap' (e.g. ICAP_PIXELTYPE,
// CAP_AUTOFEED, etc.) using a TW_ONEVALUE container with the given item type
// and value.  Use SetCapFix32 for capabilities that take a FIX32 value,
// use SetCapOneValue for the various ints and uints.  These functions
// do not support FRAME or STR items.
// Return Value: TRUE (1) if successful, FALSE (0) otherwise.

function TWAIN_SetCapFix32R(Cap:Cardinal; Numerator:Integer; Denominator:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Just like TWAIN_SetCapFix32, but uses the value Numerator/Denominator
// This is useful for languages that make it hard to pass double parameters.

function TWAIN_GetCapCurrent(Cap:Cardinal; ItemType:Cardinal; pVal:Pointer): BOOL;
stdcall; external 'Eztwain3.dll'
// Do a DAT_CAPABILITY/MSG_GETCURRENT on capability 'Cap'.
// Copy the current value out of the returned container into *pVal.
// If the operation fails (the source refuses the request), or if the
// container is not a ONEVALUE or ENUMERATION, or if the item type of the
// returned container is incompatible with the expected TWTY_ type in nType,
// returns FALSE.  If this function returns FALSE, *pVal is not touched.

function TWAIN_ToFix32(d:Double): Integer;
stdcall; external 'Eztwain3.dll'
// Convert a floating-point value to a 32-bit TW_FIX32 value that can be passed
// to e.g. TWAIN_SetCapOneValue
function TWAIN_ToFix32R(Numerator:Integer; Denominator:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Convert a rational number to a 32-bit TW_FIX32 value.
// Returns a TW_FIX32 value that approximates Numerator/Denominator

function TWAIN_Fix32ToFloat(nfix:Integer): Double;
stdcall; external 'Eztwain3.dll'
// Convert a TW_FIX32 value (as returned from some capability inquiries)
// to a double (floating point) value.


//--------- Custom DS Data
//
// The following functions support the relatively exotic CUSTOMDSDATA feature
// introduced in TWAIN 1.7.  This feature, if supported by a device, allows
// the application to read and set, all the settings of the device
// simultaneously with one block of data.  *The format of the data is defined
// by each device* and is undocumented.  So this is just a way to capture
// a snapshot of a particular device's settings, and then to
// restore that state at a later time.
//
// To find out if a device supports this feature, open the device and see if
// TWAIN_GetCapBool(CAP_CUSTOMDSDATA, FALSE) returns TRUE.
//
// The TWAIN_State() must be 4 or these functions will display an error.
//
function TWAIN_GetCustomDataToFile(sFilename:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
function TWAIN_SetCustomDataFromFile(sFilename:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Both functions return TRUE(1) if successful, FALSE(0) otherwise.
// These functions will display an error message if called outside State 4.
// In case of failure, call LastErrorCode, ReportLastError, etc. for details.
// No file extension is assumed, you should provide one, such as ".dat".

//--------- Extended Image Info
//
// The following functions support the 'Extended Image Info' feature of TWAIN,
// which is implemented by only a few TWAIN drivers.  This consists of special
// information, sometimes called 'metadata' which can be collected about
// each scanned image, in addition to the image itself.
// Examples of extended image info include
// TWEI_BARCODETEXT - text of a barcode found in the scan
// TWEI_SKEWORIGINALANGLE - the amount of 'skew' in the original raw scan
// See the TWAIN Specification (version 1.9 or later) for details.

function TWAIN_IsExtendedInfoSupported: BOOL;
stdcall; external 'Eztwain3.dll'
// Asks the currently open device if it supports Extended Image Info.
// Returns TRUE(1) if yes, FALSE(0) if not.

function TWAIN_EnableExtendedInfo(eiCode:Integer; enabled:BOOL): BOOL;
stdcall; external 'Eztwain3.dll'
// Enable or disable collection of a particular kind of extended image info.
// Each type of information is represented by an integer constant with
// prefix TWEI_ see the list of constants elsewhere in this file.
// There is a limit to how many different info types can be enabled at the
// same time.  If this limit is exceeded, this function returns FALSE
// and has no effect.  Otherwise (if successful) it returns TRUE.

function TWAIN_IsExtendedInfoEnabled(eiCode:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Return TRUE if the specified extended image type is enabled
// (for collection)

procedure TWAIN_DisableExtendedInfo;
stdcall; external 'Eztwain3.dll'
// Disables all extended image info - none is collected after this.

// After a successful scan, you can use the following functions to
// retrieve the extended image info associated with that scan:
function TWAIN_ExtendedInfoItemCount(eiCode:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return the number of items of data available of the given info type.

function TWAIN_ExtendedInfoItemType(eiCode:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return a number indicating the type of data returned for the specified extended info.
// Returns the same TWTY_ codes as CONTAINER_ItemType.

function TWAIN_ExtendedInfoInt(eiCode:Integer; n:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Return the (integer) value of the 'nth' item of the specified extended info.

function TWAIN_ExtendedInfoFloat(eiCode:Integer; n:Integer): Double;
stdcall; external 'Eztwain3.dll'
// Return the (floating point) value of the 'nth' item of the specified extended info.

function TWAIN_GetExtendedInfoString(eiCode:Integer; n:Integer; Buffer:PAnsiChar; Bufsize:Integer): BOOL;
stdcall; external 'Eztwain3.dll'
// Read the (string) value of the nth item of the specified info type into Buffer,
// which has been allocated by the caller to hold Bufsize characters.
// Note that the value returned is ASCII (byte) text, not unicode, and *always*
// includes an ending 0 byte, even if it must be truncated to fit.
// Returns TRUE if the data was retrieved and could fit in the buffer.
// Returns FALSE otherwise.

function TWAIN_ExtendedInfoString(eiCode:Integer; n:Integer): PAnsiChar;
stdcall; external 'Eztwain3.dll'
// As above, but the string is returned as a temporary pointer to a
// 0-terminated ASCII string.
// In case of any failure, returns the empty string ("").

function TWAIN_GetExtendedInfoFrame(eiCode:Integer; n:Integer; var L:Double; var T:Double; var R:Double; var B:Double): BOOL;
stdcall; external 'Eztwain3.dll'
// Fetch the TW_FRAME value of the 'nth' item of the specified extended info.
// This is rarely used, but is here for completeness.

// Extended Image Info codes
const
        TWEI_BARCODEX = $1200;
        TWEI_BARCODEY = $1201;
        TWEI_BARCODETEXT = $1202;
        TWEI_BARCODETYPE = $1203;
        TWEI_DESHADETOP = $1204;
        TWEI_DESHADELEFT = $1205;
        TWEI_DESHADEHEIGHT = $1206;
        TWEI_DESHADEWIDTH = $1207;
        TWEI_DESHADESIZE = $1208;
        TWEI_SPECKLESREMOVED = $1209;
        TWEI_HORZLINEXCOORD = $120A;
        TWEI_HORZLINEYCOORD = $120B;
        TWEI_HORZLINELENGTH = $120C;
        TWEI_HORZLINETHICKNESS = $120D;
        TWEI_VERTLINEXCOORD = $120E;
        TWEI_VERTLINEYCOORD = $120F;
        TWEI_VERTLINELENGTH = $1210;
        TWEI_VERTLINETHICKNESS = $1211;
        TWEI_PATCHCODE = $1212;
        TWEI_ENDORSEDTEXT = $1213;
        TWEI_FORMCONFIDENCE = $1214;
        TWEI_FORMTEMPLATEMATCH = $1215;
        TWEI_FORMTEMPLATEPAGEMATCH = $1216;
        TWEI_FORMHORZDOCOFFSET = $1217;
        TWEI_FORMVERTDOCOFFSET = $1218;
        TWEI_BARCODECOUNT = $1219;
        TWEI_BARCODECONFIDENCE = $121A;
        TWEI_BARCODEROTATION = $121B;
        TWEI_BARCODETEXTLENGTH = $121C;
        TWEI_DESHADECOUNT = $121D;
        TWEI_DESHADEBLACKCOUNTOLD = $121E;
        TWEI_DESHADEBLACKCOUNTNEW = $121F;
        TWEI_DESHADEBLACKRLMIN = $1220;
        TWEI_DESHADEBLACKRLMAX = $1221;
        TWEI_DESHADEWHITECOUNTOLD = $1222;
        TWEI_DESHADEWHITECOUNTNEW = $1223;
        TWEI_DESHADEWHITERLMIN = $1224;
        TWEI_DESHADEWHITERLAVE = $1225;
        TWEI_DESHADEWHITERLMAX = $1226;
        TWEI_BLACKSPECKLESREMOVED = $1227;
        TWEI_WHITESPECKLESREMOVED = $1228;
        TWEI_HORZLINECOUNT = $1229;
        TWEI_VERTLINECOUNT = $122A;
        TWEI_DESKEWSTATUS = $122B;
        TWEI_SKEWORIGINALANGLE = $122C;
        TWEI_SKEWFINALANGLE = $122D;
        TWEI_SKEWCONFIDENCE = $122E;
        TWEI_SKEWWINDOWX1 = $122F;
        TWEI_SKEWWINDOWY1 = $1230;
        TWEI_SKEWWINDOWX2 = $1231;
        TWEI_SKEWWINDOWY2 = $1232;
        TWEI_SKEWWINDOWX3 = $1233;
        TWEI_SKEWWINDOWY3 = $1234;
        TWEI_SKEWWINDOWX4 = $1235;
        TWEI_SKEWWINDOWY4 = $1236;
        TWEI_BOOKNAME = $1238;
        TWEI_CHAPTERNUMBER = $1239;
        TWEI_DOCUMENTNUMBER = $123A;
        TWEI_PAGENUMBER = $123B;
        TWEI_CAMERA = $123C;
        TWEI_FRAMENUMBER = $123D;
        TWEI_FRAME = $123E;
        TWEI_PIXELFLAVOR = $123F;



//--------- Lowest-level functions for TWAIN protocol --------


function TWAIN_DS(DG:Cardinal; DAT:Cardinal; MSG:Cardinal; pData:Pointer): BOOL;
stdcall; external 'Eztwain3.dll'
// Pass the triplet (DG, DAT, MSG, pData) to the open data source if any.
// Returns TRUE(1) if the result code is TWRC_SUCCESS, FALSE(0) otherwise.
// The last result code can be retrieved with TWAIN_GetResultCode(), and the
// corresponding condition code can be retrieved with TWAIN_GetConditionCode().
// If no source is open this call will fail, result code TWRC_FAILURE,
// condition code TWCC_NODS.

function TWAIN_Mgr(DG:Cardinal; DAT:Cardinal; MSG:Cardinal; pData:Pointer): BOOL;
stdcall; external 'Eztwain3.dll'
// Pass a triplet to the Data Source Manager (DSM).
// Returns TRUE(1) for success, FALSE(0) otherwise.
// See GetResultCode, GetConditionCode, and ReportLastError functions
// for diagnosing and reporting a TWAIN_Mgr failure.
// If the Source Manager is not open, this call fails setting result code
// TWRC_FAILURE, and condition code=TWCC_SEQERROR (triplet out of sequence).


//--------- Advanced / Exotic --------

function TWAIN_SetImageReadyTimeout(nSec:Integer): Integer;
stdcall; external 'Eztwain3.dll'
// Set the maximum seconds to wait for an image-ready notification,
// (when one is expected i.e. after an enable) before posting a
// dialog that says 'Waiting for <device>' - with a Cancel button.
// Returns the previous setting.
// ** Default is -1 which disables this feature.
// With certain scanners there is a long delay between when the scanner
// is enabled and when it says "ready to scan".  Also, we have found
// a few scanners that intermittently fail to send "ready to scan" - by
// setting this timeout, you give your users a way to recover from
// this failure (otherwise the application has to be forcibly terminated.)

procedure TWAIN_AutoClickButton(sButtonName:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Calling this function before scanning tells EZTwain to attempt to
// automatically press a button when the device dialog appears.
// If you pass a null button name, EZTwain tries a number
// of likely choices (in English) including:
// "Scan" "Capture" "Acquire" "Scan Now" "Start Scan"  "Start Scanning"
// Case is ignored in the comparison ("SCAN" and "scan" are equivalent.)
// This function is useful when you want to automate operation of
// a device that insists on showing its user interface. 

procedure TWAIN_BreakModalLoop;
stdcall; external 'Eztwain3.dll'
// Expert: If EZTwain is hung inside an Acquire or GetMessage loop waiting for
// something to happen, this function will break the loop, as if the pending
// transfer had failed.  TWAIN_State() will be valid, and you will need to
// call appropriate functions to transition TWAIN as desired.

procedure TWAIN_EmptyMessageQueue;
stdcall; external 'Eztwain3.dll'
// Expert: Get and process any pending Windows messages for this thread.
// For example, keystrokes or mouse clicks.  Calling this during
// long processes will allow the user to interact with the UI.
// Use only if you understand the message pump.

//--------- Dosadi Special --------

function TWAIN_BuildName: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return a string describing the build of EZTWAIN e.g. "Release - Build 6"

procedure TWAIN_GetBuildName(sName:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Like TWAIN_BuildName, but copies the build string into its parameter.
// The parameter is a string variable (char array in C/C++).
// You are responsible for allocating room for 128 8-bit characters
// in the string variable before calling this function.

function TWAIN_GetSourceIdentity(ptwid:Pointer): Integer;
stdcall; external 'Eztwain3.dll'

function TWAIN_GetImageInfo(ptwinfo:Pointer): Integer;
stdcall; external 'Eztwain3.dll'
// Issue a DG_IMAGE / DAT_IMAGEINFO / MSG_GET placing the returned data
// at ptwinfo.  The returned structure is a TW_IMAGEINFO - see twain.h.

procedure TWAIN_LogFile(fLog:Integer);
stdcall; external 'Eztwain3.dll'
// Turn logging eztwain.log on or off.
// By default the log file is written to C:\ but this
// can be overridden, see TWAIN_SetLogFolder below.
//
// fLog = 0    close log file and turn off logging
// The following flags can be combined to enable logging:
// 1            basic logging of TWAIN and EZTwain operations.
// 2            flush log constantly (use if EZTwain crashes)
// 4            log Windows messages flowing through EZTwain
const
        EZT_LOG_ON = 1;
        EZT_LOG_FLUSH = 2;
        EZT_LOG_DETAIL = 4;


function TWAIN_SetLogFolder(sFolder:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Specify the folder (directory) where the log file
// should be placed.  Default is "c:\" - the root of the C: drive.
// EZTwain appends a trailing 'slash' if needed.
// Passing NULL or "" resets to the default: "c:\"
//
// If the file cannot be created in this folder, EZTwain tries
// to create it in the Windows temp folder - this varies somewhat
// by Windows version, search for the Windows API call GetTempPath.

function TWAIN_SetLogName(sName:PAnsiChar): BOOL;
stdcall; external 'Eztwain3.dll'
// Set the filename or path & filename of the EZTwain log file.
// If there is a log file open, it is closed, renamed & re-opened.
// The default extension is ".log".
// The default log filename is "eztwain.log".
//
// You can specify a fully-qualified filename, which changes
// both the folder and filename for logging:
// TWAIN_SetLogName("c:\temp\scan2tape.log")

function TWAIN_LogFileName: PAnsiChar;
stdcall; external 'Eztwain3.dll'
// Return the (fully qualified) file path and name for logging.

procedure TWAIN_WriteToLog(sText:PAnsiChar);
stdcall; external 'Eztwain3.dll'
// Write text to the EZTwain log file (c:\eztwain.log)
// If the text does not end with a newline, one is supplied.
// If logging is turned off, this call has no effect.
// Logging is controlled by TWAIN_LogFile - see above.


function TWAIN_SelfTest(f:Cardinal): Integer;
stdcall; external 'Eztwain3.dll'
// Perform internal self-test.
//   f      ignored for now
// Return value:
//   0      success
//   other  internal test failed.

function TWAIN_Blocked: BOOL;
stdcall; external 'Eztwain3.dll'
// Returns TRUE(1) if processing is inside TWAIN (Source Manager or a DS)
// FALSE(0) otherwise.  If the former, making any TWAIN call will
// fail immediately or deadlock the application (Not recommended.)


// Deprecated - still work, don't use in new code.
procedure TWAIN_FreeNative(hdib:Cardinal);
stdcall; external 'Eztwain3.dll'
// superceded by DIB_Free.


// From twain.h:
//****************************************************************************
//* Capabilities                                                             *
//****************************************************************************

const
        CAP_CUSTOMBASE = $8000;

// all data sources are REQUIRED to support these caps 
        CAP_XFERCOUNT = $1;

// image data sources are REQUIRED to support these caps 
        ICAP_COMPRESSION = $100;
        ICAP_PIXELTYPE = $101;
        ICAP_UNITS = $102;
        ICAP_XFERMECH = $103;

// all data sources MAY support these caps 
        CAP_AUTHOR = $1000;
        CAP_CAPTION = $1001;
        CAP_FEEDERENABLED = $1002;
        CAP_FEEDERLOADED = $1003;
        CAP_TIMEDATE = $1004;
        CAP_SUPPORTEDCAPS = $1005;
        CAP_EXTENDEDCAPS = $1006;
        CAP_AUTOFEED = $1007;
        CAP_CLEARPAGE = $1008;
        CAP_FEEDPAGE = $1009;
        CAP_REWINDPAGE = $100A;
        CAP_INDICATORS = $100B;
        CAP_SUPPORTEDCAPSEXT = $100C;
        CAP_PAPERDETECTABLE = $100D;
        CAP_UICONTROLLABLE = $100E;
        CAP_DEVICEONLINE = $100F;
        CAP_AUTOSCAN = $1010;
        CAP_THUMBNAILSENABLED = $1011;
        CAP_DUPLEX = $1012;
        CAP_DUPLEXENABLED = $1013;
        CAP_ENABLEDSUIONLY = $1014;
        CAP_CUSTOMDSDATA = $1015;
        CAP_ENDORSER = $1016;
        CAP_JOBCONTROL = $1017;
        CAP_ALARMS = $1018;
        CAP_ALARMVOLUME = $1019;
        CAP_AUTOMATICCAPTURE = $101A;
        CAP_TIMEBEFOREFIRSTCAPTURE = $101B;
        CAP_TIMEBETWEENCAPTURES = $101C;
        CAP_CLEARBUFFERS = $101D;
        CAP_MAXBATCHBUFFERS = $101E;
        CAP_DEVICETIMEDATE = $101F;
        CAP_POWERSUPPLY = $1020;
        CAP_CAMERAPREVIEWUI = $1021;
        CAP_DEVICEEVENT = $1022;
        CAP_SERIALNUMBER = $1024;
        CAP_PRINTER = $1026;
        CAP_PRINTERENABLED = $1027;
        CAP_PRINTERINDEX = $1028;
        CAP_PRINTERMODE = $1029;
        CAP_PRINTERSTRING = $102A;
        CAP_PRINTERSUFFIX = $102B;
        CAP_LANGUAGE = $102C;
        CAP_FEEDERALIGNMENT = $102D;
        CAP_FEEDERORDER = $102E;
        CAP_REACQUIREALLOWED = $1030;
        CAP_BATTERYMINUTES = $1032;
        CAP_BATTERYPERCENTAGE = $1033;

// image data sources MAY support these caps 
        ICAP_AUTOBRIGHT = $1100;
        ICAP_BRIGHTNESS = $1101;
        ICAP_CONTRAST = $1103;
        ICAP_CUSTHALFTONE = $1104;
        ICAP_EXPOSURETIME = $1105;
        ICAP_FILTER = $1106;
        ICAP_FLASHUSED = $1107;
        ICAP_GAMMA = $1108;
        ICAP_HALFTONES = $1109;
        ICAP_HIGHLIGHT = $110A;
        ICAP_IMAGEFILEFORMAT = $110C;
        ICAP_LAMPSTATE = $110D;
        ICAP_LIGHTSOURCE = $110E;
        ICAP_ORIENTATION = $1110;
        ICAP_PHYSICALWIDTH = $1111;
        ICAP_PHYSICALHEIGHT = $1112;
        ICAP_SHADOW = $1113;
        ICAP_FRAMES = $1114;
        ICAP_XNATIVERESOLUTION = $1116;
        ICAP_YNATIVERESOLUTION = $1117;
        ICAP_XRESOLUTION = $1118;
        ICAP_YRESOLUTION = $1119;
        ICAP_MAXFRAMES = $111A;
        ICAP_TILES = $111B;
        ICAP_BITORDER = $111C;
        ICAP_CCITTKFACTOR = $111D;
        ICAP_LIGHTPATH = $111E;
        ICAP_PIXELFLAVOR = $111F;
        ICAP_PLANARCHUNKY = $1120;
        ICAP_ROTATION = $1121;
        ICAP_SUPPORTEDSIZES = $1122;
        ICAP_THRESHOLD = $1123;
        ICAP_XSCALING = $1124;
        ICAP_YSCALING = $1125;
        ICAP_BITORDERCODES = $1126;
        ICAP_PIXELFLAVORCODES = $1127;
        ICAP_JPEGPIXELTYPE = $1128;
        ICAP_TIMEFILL = $112A;
        ICAP_BITDEPTH = $112B;
        ICAP_BITDEPTHREDUCTION = $112C;
        ICAP_UNDEFINEDIMAGESIZE = $112D;
        ICAP_IMAGEDATASET = $112E;
        ICAP_EXTIMAGEINFO = $112F;
        ICAP_MINIMUMHEIGHT = $1130;
        ICAP_MINIMUMWIDTH = $1131;
        ICAP_FLIPROTATION = $1136;
        ICAP_BARCODEDETECTIONENABLED = $1137;
        ICAP_SUPPORTEDBARCODETYPES = $1138;
        ICAP_BARCODEMAXSEARCHPRIORITIES = $1139;
        ICAP_BARCODESEARCHPRIORITIES = $113A;
        ICAP_BARCODESEARCHMODE = $113B;
        ICAP_BARCODEMAXRETRIES = $113C;
        ICAP_BARCODETIMEOUT = $113D;
        ICAP_ZOOMFACTOR = $113E;
        ICAP_PATCHCODEDETECTIONENABLED = $113F;
        ICAP_SUPPORTEDPATCHCODETYPES = $1140;
        ICAP_PATCHCODEMAXSEARCHPRIORITIES = $1141;
        ICAP_PATCHCODESEARCHPRIORITIES = $1142;
        ICAP_PATCHCODESEARCHMODE = $1143;
        ICAP_PATCHCODEMAXRETRIES = $1144;
        ICAP_PATCHCODETIMEOUT = $1145;
        ICAP_FLASHUSED2 = $1146;
        ICAP_IMAGEFILTER = $1147;
        ICAP_NOISEFILTER = $1148;
        ICAP_OVERSCAN = $1149;
        ICAP_AUTOMATICBORDERDETECTION = $1150;
        ICAP_AUTOMATICDESKEW = $1151;
        ICAP_AUTOMATICROTATE = $1152;
        ICAP_JPEGQUALITY = $1153;

// Container and Extended Info item types:
        TWTY_INT8 = $0;
        TWTY_INT16 = $1;
        TWTY_INT32 = $2;
        TWTY_UINT8 = $3;
        TWTY_UINT16 = $4;
        TWTY_UINT32 = $5;
        TWTY_BOOL = $6;
        TWTY_FIX32 = $7;
        TWTY_FRAME = $8;
        TWTY_STR32 = $9;
        TWTY_STR64 = $A;
        TWTY_STR128 = $B;
        TWTY_STR255 = $C;
        TWTY_STR1024 = $D;
        TWTY_UNI512 = $E;



// EZTwain History: See History.txt
implementation

end.
