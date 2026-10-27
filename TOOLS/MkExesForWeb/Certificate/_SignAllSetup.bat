signtool.exe sign /f VisualTax.pfx /p vtSecret2015 /v /t http://timestamp.sectigo.com "..\..\ReadyForWeb\vtCourierSetup.exe"
signtool.exe sign /f VisualTax.pfx /p vtSecret2015 /v /t http://timestamp.sectigo.com "..\..\ReadyForWeb\vtSignPDFSetup.exe"
pause