
               Paint_Form(hdc,nVscrollPos,Form[npWndData->Formno].FormName,"DATA");
//================  PAINT_FORM=====
boolean PaintForm(hdc: Word; scrollpos: integer; Frmnm: String; ResType: String)
{
LOGFONT    logfont;
HFONT      hLarge_Font,hNormal_Font,hNormal_Bold,hfont; //handles
PLOGFONT   pNormal_Font,pLarge_Font,pNormal_Bold;  //pointers
char far *cpTemp;
int retcode;
int len,i,j,x;
char buf[20];
int far *bufer;
static HANDLE hResource;
char far *lpResource;
int far *ipResource;
int far *ipTemp;
char far *cpFormStrings;
}
{load resource}
UnlockResource(hResource);
FreeResource(hResource);  {remove any previuos resource}

hResource = LoadResource (hInst,
                        FindResource (hInst,Frmnm,'RCDATA'));
if (hResource == NULL) then
      begin
       ShowMessageBox('Form resource not found');
       return False;
      end;


if (hResource != NULL) then
begin
  lpResource=LockResource(hResource);
  ipResource=(int far *)lpResource;  {convert to integer pointer}

  if (ipResource != NULL) then  {resource found}
  begin
    ipHdrData=&hdr.numb_labels;
    _fmemcpy(ipHdrData,ipResource,sizeof(hdr)); {copy into structure}
    numb_labels=hdr.numb_labels;
    numb_lines=hdr.numb_lines;
    numb_flds=hdr.numb_flds;
    FormHeight=hdr.FormHeight;

    {find pointer of strings}
    x=(numb_labels * sizeof(lbl))+(numb_lines * sizeof(lin))+(numb_flds * sizeof(fld));
    cpTemp=lpResource + sizeof(hdr)+ x ;

    {positioned pointer at label data}
    ipTemp=ipResource+sizeof(hdr)/2; {pointer at labels}
    for(j=0;j<numb_labels;j++) do
     begin
        ipLblData=&lbl.x;
        _fmemcpy(ipLblData,ipTemp,sizeof(lbl)); {copy into structure}

        {convert y to client coordinates}
        if (lbl.y>(scrollpos+wndHeight))  {if below window}
          exit;
        if (lbl.y>scrollpos) then
          begin
          while (lbl.y>wndHeight)
            lbl.y -= wndHeight;   {subtract wndheight until within client}


          SelectObject(hdc,hNormal_Font);
          if (lbl.fsize == 1) then
              i=SelectObject(hdc,hNormal_Bold);

          if (lbl.fsize ==2) then
              i=SelectObject(hdc,hLarge_Font); {default}
         ipTemp +=(sizeof(lbl)/2);   {advance to next lbl buckets /pointer arithmetic}
         cpTemp +=(lbl.length+1);    {advance by length of string/ zero delimiter add 1}

      }
      NUMLINES = 512;//(*ipLblY[numb_labels]) / iLineHeight;
      DeleteObject(hLarge_Font);
      DeleteObject(hNormal_Font);
      LocalFree((LOCALHANDLE) pLarge_Font);
      LocalFree((LOCALHANDLE) pNormal_Font);
      return True;
   end;
