@ECHO OFF
TITLE mpg123.%1
ECHO.mpg123.AudioPlayer.ID:"%1"
ECHO.Location:%2
ECHO.
ECHO.
SET PARAMETERS=%3
SET PARAMETERS=%PARAMETERS:"=%
CALL .\binaries\mpg123.exe %PARAMETERS% --no-control --no-visual %2 >NUL
EXIT 0
