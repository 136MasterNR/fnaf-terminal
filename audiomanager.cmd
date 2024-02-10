@ECHO OFF
SET "DATA_AUDPLAYER=%CD%\audioplayer.cmd"
SET "DATA_AUD=%CD%\audio"
CALL :%*
EXIT /B 0

:STOPALL
(TASKKILL /F /FI "WINDOWTITLE eq mpg123*" /IM "cmd.exe" /T | FINDSTR ":" && (
	TASKKILL /F /FI "WINDOWTITLE eq Administrator:  mpg123*" /IM "cmd.exe" /T>NUL
)) >NUL
EXIT /B 0

:STOP <"Identifier": String>
(TASKKILL /F /FI "WINDOWTITLE eq mpg123.%1" /IM "cmd.exe" /T | FINDSTR ":" && (
	TASKKILL /F /FI "WINDOWTITLE eq Administrator:  mpg123.%1" /IM "cmd.exe" /T>NUL
)) >NUL
EXIT /B 0


:START <"Path": String> <"Identifier": String> <"Loop": Boolean> <"Volume": Integer>

SET "TARGETAUDIO=%DATA_AUD%\%1"
IF NOT EXIST "%TARGETAUDIO%" EXIT /B 0

SET PARAMETERS=
IF /I %3==True (
	SET PARAMETERS=--loop -1
) ELSE SET PARAMETERS=--loop 1

SET /A VOLUME=(%4 * 32768) / 100

SET PARAMETERS=%PARAMETERS% -f %VOLUME%

START /MIN "mpg123.%2" CMD /C CALL "%DATA_AUDPLAYER%" %2 "%TARGETAUDIO%" "%PARAMETERS%"

EXIT /B 0