@PUSHD "%~dp0"
@TITLE FNaF - Terminal Edition
@CHCP 65001 >NUL
@VERIFY OFF
@ECHO OFF

IF EXIST .\logs.txt DEL /Q .\logs.txt
IF EXIST .\logs.txt EXIT 1

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

2>.\logs.txt CALL :LAUNCH
EXIT 1

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
SET JUMPSCARE=_chica

:: ANIMATRONICS
SET BONNIE=0
SET CHICA=0
SET OLD_BONNIE=%BONNIE%
SET OLD_CHICA=%CHICA%
SET FREDDY=0
SET FOXY=0
SET GOLDENFREDDY=0


:RE
SET STATES=
IF %R_DOOR% EQU 1 SET STATES=%STATES%_doorR
IF %L_DOOR% EQU 1 SET STATES=%STATES%_doorL
IF %R_LIGHTS% EQU 1 IF %CHICA% GEQ 5 (SET STATES=%STATES%_chica) ELSE SET STATES=%STATES%_lightR
IF %L_LIGHTS% EQU 1 IF %BONNIE% GEQ 5 (SET STATES=%STATES%_bonnie) ELSE SET STATES=%STATES%_lightL
IF %GOLDENFREDDY% GEQ 1 SET STATES=%STATES%_goldenfreddy

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
IF %CAMS_STATE%==_2 IF %CHICA% EQU 1 SET CAMS_STATES=%CAMS_STATES%_chica
IF %CAMS_STATE%==_2 IF %BONNIE% EQU 1 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_3 IF %BONNIE% EQU 2 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_4 IF %CHICA% EQU 2 SET CAMS_STATES=%CAMS_STATES%_chica
IF %CAMS_STATE%==_6 IF %BONNIE% EQU 3 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_8 IF %BONNIE% EQU 4 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_11 IF %CHICA% EQU 4 SET CAMS_STATES=%CAMS_STATES%_chica

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
	IF %TAB% EQU 0 ECHO.[3;6HPress TAB to mute voice call
)
REM TITLE [cams%CAMS_STATES%]

:CHOICE
SET OLD_CHICA=%CHICA%
SET OLD_BONNIE=%BONNIE%

CALL .\choice.cmd
IF %VIEW%==OFFICE (
	IF /I %CHOICE.INPUT%==E (
		IF %GOLDENFREDDY% EQU 0 (
			CALL :CLOSE_RIGHT
			GOTO :RE
		) ELSE START /B "" CMD /C CALL ".\audiomanager.cmd" START error.mp3 sfx False 100 ^& EXIT >NUL 2>&1
	)
	IF /I %CHOICE.INPUT%==Q (
		IF %GOLDENFREDDY% EQU 0 (
			CALL :CLOSE_LEFT
			GOTO :RE
		) ELSE START /B "" CMD /C CALL ".\audiomanager.cmd" START error.mp3 sfx False 100 ^& EXIT >NUL 2>&1
	)
	IF /I %CHOICE.INPUT%==A (
		IF %GOLDENFREDDY% EQU 0 (
			CALL :LIGHTS_LEFT
			GOTO :RE
		) ELSE START /B "" CMD /C CALL ".\audiomanager.cmd" START error.mp3 sfx False 100 ^& EXIT >NUL 2>&1
	)
	IF /I %CHOICE.INPUT%==D (
		IF %GOLDENFREDDY% EQU 0 (
			CALL :LIGHTS_RIGHT
			GOTO :RE
		) ELSE START /B "" CMD /C CALL ".\audiomanager.cmd" START error.mp3 sfx False 100 ^& EXIT >NUL 2>&1
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

IF /I %CHOICE.INPUT%==SPACE (
	IF %VIEW%==OFFICE (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START camera_up.mp3 camera_up False 100 ^& EXIT >NUL
		SET VIEW=CAMS
	) ELSE (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START camera_down.mp3 camera_down False 100 ^& EXIT >NUL
		START /B "" CMD /C CALL ".\audiomanager.cmd" STOP camera_up ^& EXIT >NUL
		CALL :GOLDENFREDDY
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

:: Get Updates
IF %CHOICE.INPUT%==TIMEOUT (
	:: Win detection
	IF EXIST WIN (
		DEL /Q WIN
		GOTO :WIN
	)

	CALL .\MOVEMENTS.cmd
	SETLOCAL ENABLEDELAYEDEXPANSION

	:: Death detections
	IF !CHICA! GTR 5 (ECHO.%STATES% | findstr /C:"doorR") >NUL || (
		ENDLOCAL
		SET JUMPSCARE=_chica
		GOTO :GAMEOVER
	)
	IF !BONNIE! GTR 5 (ECHO.%STATES% | findstr /C:"doorL") >NUL || (
		ENDLOCAL
		SET JUMPSCARE=_bonnie
		GOTO :GAMEOVER
	)
	
	:: Chica oven SFX updates
	IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 3 START /B "" CMD /C CALL ".\audiomanager.cmd" START oven.mp3 oven True 9 ^& EXIT >NUL 2>&1
	IF %OLD_CHICA% EQU 3 IF !CHICA! NEQ 3 START /B "" CMD /C CALL ".\audiomanager.cmd" STOP oven ^& EXIT >NUL 2>&1

	:: Cams updates
	IF %VIEW%==CAMS (
		IF %CAMS_STATE%==_1 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 1 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_2 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 2 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 2 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_3 (
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 2 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 3 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_4 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 2 ENDLOCAL&GOTO :RE
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 3 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_6 (
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 3 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 4 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_8 (
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 4 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 5 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_11 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 4 ENDLOCAL&GOTO :RE
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 5 ENDLOCAL&GOTO :RE
		)
	)

	:: Office state updates
	IF %VIEW%==OFFICE (
		(ECHO.%STATES% | findstr /C:"lightR" /C:"CHICA") >NUL && (
			IF NOT %OLD_CHICA% EQU !CHICA! (
				IF %OLD_CHICA% EQU 5 IF !CHICA! LSS 5 (
					ENDLOCAL
					GOTO :RE
				)
				IF !CHICA! GEQ 5 (
					ENDLOCAL
					GOTO :RE
				)
			)
		)

		(ECHO.%STATES% | findstr /C:"lightL" /C:"bonnie") >NUL && (
			IF NOT %OLD_BONNIE% EQU !BONNIE! (
				IF %OLD_BONNIE% EQU 5 IF !BONNIE! LSS 5 (
					ENDLOCAL
					GOTO :RE
				)
				IF !BONNIE! GEQ 5 (
					ENDLOCAL
					GOTO :RE
				)
			)
		)
	)

	ENDLOCAL
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


:GOLDENFREDDY
IF %GOLDENFREDDY% EQU 1 (
	SET GOLDENFREDDY=0
	EXIT /B 0
)
SET /A GF_CALC=%RANDOM% %% 100 +1
IF %GF_CALC% LEQ 7 (
	SET GOLDENFREDDY=1
	SET R_DOOR=0
	SET L_DOOR=0
	SET R_LIGHTS=0
	SET L_LIGHTS=0
)
EXIT /B 0


:GAMEOVER
CALL ".\audiomanager.cmd" START XSCREAM.mp3 sfx False 100
TIMEOUT /T 0 >NUL
TYPE ".\assets\jumpscare%JUMPSCARE%.ans" > CON
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP ambience ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP voiceover ^& EXIT >NUL
TIMEOUT /T 4 /NOBREAK >NUL
TYPE ".\assets\gameover.ans" > CON
TASKKILL /F /FI "WINDOWTITLE eq FNaF Events - TIME: *" /IM "cmd.exe" /T >NUL 2>&1
DEL /Q .\refresh >NUL 2>&1
TIMEOUT /T 8 >NUL
GOTO :LAUNCH

:WIN
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP ambience ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP voiceover ^& EXIT >NUL
CALL ".\audiomanager.cmd" START chimes2.mp3 sfx False 100
TYPE ".\assets\5am.ans" > CON
TIMEOUT /T 5 /NOBREAK >NUL
CALL ".\audiomanager.cmd" START CROWD_SMALL_CHIL_EC049202.mp3 sfx False 100
TYPE ".\assets\6am.ans" > CON
TIMEOUT /T 7 >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP sfx ^& EXIT >NUL
GOTO :LAUNCH
