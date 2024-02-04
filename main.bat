@PUSHD "%~dp0"
@TITLE FNaF - Terminal Edition
@CHCP 65001 >NUL
@VERIFY OFF
@ECHO OFF

IF NOT %1.==READY. IF %1.==LAUNCH. (
	CLS
	TITLE Launcher
	ECHO.This is the game's launcher, do not close.
	START /WAIT "Launcher" "conhost.exe" -- "%~dpnx0" READY
	ECHO.Shutting down...
	(TASKKILL /F /FI "WINDOWTITLE eq WSAudio*" /IM "cmd.exe" /T | FINDSTR ":" && (
		TASKKILL /F /FI "WINDOWTITLE eq Administrator:  WSAudio*" /IM "cmd.exe" /T
	))
	TASKKILL /F /FI "WINDOWTITLE eq FNaF Events - TIME: *" /IM "cmd.exe" /T
	EXIT 0
) ELSE (
	(START /MIN "Launcher" conhost.exe -- "%~dpnx0" LAUNCH) && (ECHO. Launched [√]
	) || (ECHO. There was an unexpected error, failed to launch [X])
	EXIT 0
)

:LAUNCH
ECHO.[?25l
MODE CON: COLS=185 LINES=53
SET TITLE_STATE=_new
START /B "" CMD /C CALL ".\audiomanager.cmd" START coldprescb.mp3 title True 100 ^& EXIT >NUL 2>&1

TYPE ".\assets\title%TITLE_STATE%_o.ans"
:TITLE
TYPE ".\assets\title%TITLE_STATE%.ans" > CON
CALL .\choice.cmd
IF %CHOICE.INPUT%.==. GOTO :START
IF %CHOICE.INPUT%==SPACE GOTO :START
IF /I %CHOICE.INPUT%==A GOTO :START

IF /I %CHOICE.INPUT%==W SET TITLE_STATE=_continue_half
IF /I %CHOICE.INPUT%==S SET TITLE_STATE=_new_half
IF /I %CHOICE.INPUT%==C SET TITLE_STATE=_continue_half
IF /I %CHOICE.INPUT%==N SET TITLE_STATE=_new_half
IF /I %CHOICE.INPUT%==1 SET TITLE_STATE=_continue_half
IF /I %CHOICE.INPUT%==2 SET TITLE_STATE=_new_half

GOTO :TITLE

:START
CALL ".\audiomanager.cmd" STOP title
IF %TITLE_STATE:~0,4%==_new GOTO :NEWSPAPER
GOTO :GAME

:NEWSPAPER
TYPE ".\assets\newspaper.ans" > CON
TIMEOUT /T 5 >NUL

:GAME
DEL /Q "%CD%\temp\TMP_AUDIO.vbs" >NUL
DEL /Q "%CD%\temp\TMP_AUDIO2.vbs" >NUL
CALL ".\audiomanager.cmd" START ambience2.mp3 ambience True 90
CALL ".\audiomanager.cmd" START voiceover1c.mp3 voiceover False 100

START /MIN .\events.cmd

:: UI
SET "RGB=[48;2;"
SET TAB=0
SET REVERSE=
SET R_DOOR=0
SET L_DOOR=0
SET R_LIGHTS=0
SET L_LIGHTS=0
SET STATE=office
SET CAMS_STATE=_1
SET CAMS_STATES=
SET VIEW=OFFICE

:: ANIMATRONICS
SET BONNIE=0
SET CHICA=0
SET OLD_BONNIE=%BONNIE%
SET OLD_CHICA=%CHICA%
SET FREDDY=0
SET FOXY=0

:RE
SET STATES=
IF %R_DOOR% EQU 1 SET STATES=%STATES%_doorR
IF %L_DOOR% EQU 1 SET STATES=%STATES%_doorL
IF %R_LIGHTS% EQU 1 IF %CHICA% GEQ 5 (SET STATES=%STATES%_chica) ELSE SET STATES=%STATES%_lightR
IF %L_LIGHTS% EQU 1 IF %BONNIE% GEQ 5 (SET STATES=%STATES%_bonnie) ELSE SET STATES=%STATES%_lightL

IF %VIEW%==OFFICE (
	TYPE ".\assets\office%STATES%%REVERSE%.ans" > CON
	ECHO.[51;77H%RGB%0;0;0mPress SPACE to open the cams
	ECHO.[27;6H[0m%RGB%94;4;9mQ[0m
	ECHO.[34;6H[0m%RGB%67;53;78mA[0m
	ECHO.[27;175H[0m%RGB%94;4;9mE[0m
	ECHO.[34;175H[0m%RGB%67;53;78mD[0m
	IF %TAB% EQU 0 ECHO.[3;6H%RGB%22;19;40mPr%RGB%28;25;46mes%RGB%24;20;43ms TAB to mut%RGB%15;12;29me vo%RGB%9;7;21mice %RGB%0;0;0mcall
	TITLE [office%STATES%%REVERSE%]
	IF DEFINED REVERSE SET REVERSE=
	>office_states SET /P "=%STATES%" <NUL
)

SET CAMS_STATES=%CAMS_STATE%
IF %CAMS_STATE%==_1 IF %CHICA% GTR 0 SET CAMS_STATES=%CAMS_STATES%_chica
IF %CAMS_STATE%==_1 IF %BONNIE% GTR 0 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %VIEW%==CAMS (
	TYPE ".\assets\cams%CAMS_STATES%.ans" > CON
	ECHO.[49;67H%RGB%53;55;62m[1mPress SPACE to close the cams[0m
	IF NOT %CAMS_STATE%==_1 ECHO.[26;143H%RGB%67;67;67m[1m1[0m
	IF NOT %CAMS_STATE%==_2 ECHO.[30;140H%RGB%67;67;67m[1m2[0m
	IF NOT %CAMS_STATE%==_3 ECHO.[32;125H%RGB%67;67;67m[1m3[0m
	IF NOT %CAMS_STATE%==_4 ECHO.[32;174H%RGB%67;67;67m[1m4[0m
	IF NOT %CAMS_STATE%==_5 ECHO.[36;135H%RGB%67;67;67m[1m5[0m
	IF NOT %CAMS_STATE%==_6 ECHO.[43;131H%RGB%67;67;67m[1m6[0m
	IF NOT %CAMS_STATE%==_7 ECHO.[42;172H%RGB%67;67;67m[1m7[0m
	IF NOT %CAMS_STATE%==_8 ECHO.[44;143H%RGB%67;67;67m[1m8[0m
	IF NOT %CAMS_STATE%==_9 ECHO.[47;143H%RGB%67;67;67m[1m9[0m
	IF NOT %CAMS_STATE%==_10 ECHO.[44;158H%RGB%67;67;67m[1m10[0m
	IF NOT %CAMS_STATE%==_11 ECHO.[47;158H%RGB%67;67;67m[1m11[0m
	IF %TAB% EQU 0 ECHO.[3;6HPress TAB to mute voicecall
)

:CHOICE
CALL .\choice.cmd
IF %VIEW%==OFFICE (
	IF /I %CHOICE.INPUT%==E (
		CALL :CLOSE_RIGHT
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==Q (
		CALL :CLOSE_LEFT
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==A (
		CALL :LIGHTS_LEFT
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==D (
		CALL :LIGHTS_RIGHT
		GOTO :RE
	)
)
IF %VIEW%==CAMS (
	IF /I %CHOICE.INPUT%==1 IF NOT %CAMS_STATE%==_1 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_1
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==2 IF NOT %CAMS_STATE%==_2 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_2
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==3 IF NOT %CAMS_STATE%==_3 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_3
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==4 IF NOT %CAMS_STATE%==_4 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_4
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==5 IF NOT %CAMS_STATE%==_5 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_5
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==6 IF NOT %CAMS_STATE%==_6 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_6
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==7 IF NOT %CAMS_STATE%==_7 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_7
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==8 IF NOT %CAMS_STATE%==_8 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_8
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==9 IF NOT %CAMS_STATE%==_9 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_9
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==0 IF NOT %CAMS_STATE%==_10 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_10
		GOTO :RE
	)
	IF /I %CHOICE.INPUT%==- IF NOT %CAMS_STATE%==_11 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START blip3.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		SET CAMS_STATE=_11
		GOTO :RE
	)
)

IF /I %CHOICE.INPUT%==B (
	IF %BONNIE% EQU 0 (SET BONNIE=5) ELSE SET BONNIE=0
)
IF /I %CHOICE.INPUT%==N (
	IF %CHICA% EQU 0 (SET CHICA=5) ELSE SET CHICA=0
)

IF /I %CHOICE.INPUT%==SPACE (
	IF %VIEW%==OFFICE (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START camera_up.mp3 camera_up False 100 ^& EXIT >NUL
		SET VIEW=CAMS
	) ELSE (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START camera_down.mp3 camera_down False 100 ^& EXIT >NUL
		START /B "" CMD /C CALL ".\audiomanager.cmd" STOP camera_up ^& EXIT >NUL
		SET VIEW=OFFICE
	)
	GOTO :RE
)

IF /I %CHOICE.INPUT%==TAB IF %TAB% EQU 0 (
	SET TAB=1
	START /B "" CMD /C CALL ".\audiomanager.cmd" STOP voiceover ^& EXIT >NUL
	GOTO :RE
)

IF /I %CHOICE.INPUT%== EXIT /B 0

IF %CHOICE.INPUT%==TIMEOUT (
	CALL .\MOVEMENTS.cmd
	
	SETLOCAL ENABLEDELAYEDEXPANSION
	IF !CHICA! GTR 5 ENDLOCAL&GOTO :GAMEOVER
	IF !BONNIE! GTR 5 ENDLOCAL&GOTO :GAMEOVER

	IF %VIEW%==CAMS (
		IF %CAMS_STATE%==_1 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 1 ENDLOCAL&GOTO :RE
		)
	)
	IF %VIEW%==OFFICE (
		IF NOT %OLD_CHICA% EQU !CHICA! (ECHO.%STATES% | findstr /C:"lightR") >NUL && ENDLOCAL&GOTO :RE
		IF NOT %OLD_BONNIE% EQU !BONNIE! (ECHO.%STATES% | findstr /C:"lightL") >NUL && ENDLOCAL&GOTO :RE
	)
	ENDLOCAL
	SET OLD_CHICA=%CHICA%
	SET OLD_BONNIE=%BONNIE%
)

GOTO :CHOICE


:CLOSE_RIGHT
IF %R_DOOR% EQU 1 (
	SET R_DOOR=0
	SET REVERSE=_rev
) ELSE (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START door.mp3 menu False 100 ^& EXIT >NUL
	SET R_DOOR=1
)
EXIT /B 0

:CLOSE_LEFT
IF %L_DOOR% EQU 1 (
	SET L_DOOR=0
	SET REVERSE=_rev
) ELSE (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START door.mp3 menu False 100 ^& EXIT >NUL
	SET L_DOOR=1
)
EXIT /B 0


:LIGHTS_RIGHT
IF %R_LIGHTS% EQU 1 (
	SET R_LIGHTS=0
) ELSE SET R_LIGHTS=1
EXIT /B 0

:LIGHTS_LEFT
IF %L_LIGHTS% EQU 1 (
	SET L_LIGHTS=0
) ELSE SET L_LIGHTS=1
EXIT /B 0


:GAMEOVER
TYPE ".\assets\gameover.ans" > CON
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP ambience ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP voiceover ^& EXIT >NUL
TASKKILL /F /FI "WINDOWTITLE eq FNaF Events - TIME: *" /IM "cmd.exe" /T >NUL 2>&1
DEL /Q .\refresh >NUL 2>&1
PAUSE>NUL
GOTO :LAUNCH
