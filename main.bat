@PUSHD "%~dp0"
@TITLE FNaF - Terminal Edition
@CHCP 65001 >NUL
@VERIFY OFF
@ECHO OFF

IF EXIST .\logs.txt DEL /Q .\logs.txt
IF EXIST .\logs.txt EXIT 1

IF NOT EXIST .\temp MD .\temp

IF NOT %1.==READY. IF %1.==LAUNCH. (
	CLS
	TITLE Launcher
	ECHO.This is the game's launcher, do not close.
	START /WAIT "Launcher" "conhost.exe" -- "%~dpnx0" READY
	ECHO.Shutting down...
	(TASKKILL /F /FI "WINDOWTITLE eq mpg123*" /IM "cmd.exe" /T | FINDSTR ":" && (
		TASKKILL /F /FI "WINDOWTITLE eq Administrator:  mpg123*" /IM "cmd.exe" /T
	))
	TASKKILL /F /FI "WINDOWTITLE eq FNaF Events - TIME: *" /IM "cmd.exe" /T
	RD "./temp" /S /Q
	DEL /Q ".\office_states"
	DEL /Q ".\cams_state"
	DEL /Q ".\MOVEMENTS.cmd"
	DEL /Q ".\refresh"
	DEL /Q ".\SEEN_FOXY"
	DEL /Q ".\BATTERY"
	DEL /Q ".\TIME"
	DEL /Q ".\saw_freddy"
	DEL /Q ".\saw_cams"
	DEL /Q ".\WIN"
	EXIT 0
) ELSE (
	(START /MIN "Launcher" conhost.exe -- "%~dpnx0" LAUNCH) && (ECHO. Launched [√]
	) || (ECHO. There was an unexpected error, failed to launch [X])
	EXIT /B 0
)

2>.\logs.txt CALL :LAUNCH
EXIT 1

:LAUNCH
ECHO.[?25l
:: Real Size: w185 h104
MODE CON: COLS=185 LINES=53
SET TITLE_STATE=_new
START /B "" CMD /C CALL ".\audiomanager.cmd" START darkness_music.mp3 title True 95 ^& EXIT >NUL 2>&1
START /B "" CMD /C CALL ".\audiomanager.cmd" START coldprescb.mp3 title True 75 ^& EXIT >NUL 2>&1
START /B "" CMD /C CALL ".\audiomanager.cmd" START static2.mp3 title False 75 ^& EXIT >NUL 2>&1

TYPE ".\assets\title%TITLE_STATE%_o.ans"
:TITLE
TYPE ".\assets\title%TITLE_STATE%.ans" > CON
CALL .\choice.cmd
IF %CHOICE.INPUT%.==. GOTO :START
IF %CHOICE.INPUT%==SPACE (
	SET DIFFICULTY=0 0 0 2
	GOTO :START
)
IF /I %CHOICE.INPUT%==A (
	SET DIFFICULTY=0 0 0 2
	GOTO :START
)
IF /I %CHOICE.INPUT%== (
	SET DIFFICULTY=20 20 20 20
	GOTO :START
)

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
IF "%DIFFICULTY%"=="20 20 20 20" (
	CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_8d.mp3 sfx False 35 >NUL 2>&1
	TYPE ".\assets\twenty.ans" > CON
	TIMEOUT /T 3 >NUL
	START /B "" CMD /C CALL ".\audiomanager.cmd" STOP sfx ^& EXIT >NUL 2>&1
) ELSE (
	TYPE ".\assets\newspaper.ans" > CON
	TIMEOUT /T 5 >NUL
)

:GAME
CALL ".\audiomanager.cmd" START ambience2.mp3 ambience True 90
CALL ".\audiomanager.cmd" START voiceover1c.mp3 voiceover False 100

START /MIN .\events.cmd %DIFFICULTY%

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
SET BATTERY=99
SET TIME=12

:: ANIMATRONICS
SET BONNIE=0
SET OLD_BONNIE=%BONNIE%
SET WS_BONNIE=0
SET CHICA=0
SET OLD_CHICA=%CHICA%
SET WS_CHICA=0
SET FREDDY=0
SET OLD_FREDDY=%FREDDY%
SET FOXY=0
SET OLD_FOXY=%FOXY%
SET GOLDENFREDDY=0

:RE
SET STATES=
IF %R_DOOR% EQU 1 SET STATES=%STATES%_doorR
IF %L_DOOR% EQU 1 SET STATES=%STATES%_doorL
IF %R_LIGHTS% EQU 1 IF %CHICA% GEQ 5 (SET STATES=%STATES%_chica) ELSE SET STATES=%STATES%_lightR
IF %L_LIGHTS% EQU 1 IF %BONNIE% GEQ 6 (SET STATES=%STATES%_bonnie) ELSE SET STATES=%STATES%_lightL
IF %GOLDENFREDDY% GEQ 1 SET STATES=%STATES%_goldenfreddy

IF %VIEW%==OFFICE (
	>office_states SET /P "=%STATES%" <NUL
	IF %BONNIE% EQU 6 (ECHO.%STATES% | findstr /C:"bonnie") >NUL && IF %WS_BONNIE% EQU 1 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START windowscare.mp3 sfx False 75 ^& EXIT >NUL 2>&1
		SET WS_BONNIE=0
	)
	IF %CHICA% EQU 5 (ECHO.%STATES% | findstr /C:"chica") >NUL && IF %WS_CHICA% EQU 1 (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START windowscare.mp3 sfx False 75 ^& EXIT >NUL 2>&1
		SET WS_CHICA=0
	)
	TYPE ".\assets\office%STATES%%REVERSE%.ans" > CON
	ECHO.[51;77H%RGB%0;0;0mPress SPACE to open the cams
	ECHO.[27;6H[0m%RGB%94;4;9mQ[0m
	ECHO.[34;6H[0m%RGB%67;53;78mA[0m
	ECHO.[27;175H[0m%RGB%94;4;9mE[0m
	ECHO.[34;175H[0m%RGB%67;53;78mD[0m
	IF %TAB% EQU 0 ECHO.[3;6H%RGB%22;19;40mPr%RGB%28;25;46mes%RGB%24;20;43ms TAB to mut%RGB%15;12;29me vo%RGB%9;7;21mice %RGB%0;0;0mcall
	REM TITLE [office%STATES%%REVERSE%]
	IF DEFINED REVERSE SET REVERSE=
)


SET CAMS_STATES=%CAMS_STATE%
IF %CAMS_STATE%==_1 IF %FREDDY% GTR 0 SET CAMS_STATES=%CAMS_STATES%_freddy
IF %CAMS_STATE%==_1 IF %CHICA% GTR 0 SET CAMS_STATES=%CAMS_STATES%_chica
IF %CAMS_STATE%==_1 IF %BONNIE% GTR 0 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_2 IF %CHICA% EQU 1 SET CAMS_STATES=%CAMS_STATES%_chica
IF %CAMS_STATE%==_2 IF %BONNIE% EQU 1 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATES%==_2 IF %FREDDY% EQU 1 SET CAMS_STATES=%CAMS_STATES%_freddy&BREAK>saw_freddy
IF %CAMS_STATE%==_3 IF %BONNIE% EQU 2 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_4 IF %CHICA% EQU 2 SET CAMS_STATES=%CAMS_STATES%_chica
IF %CAMS_STATES%==_4 IF %FREDDY% EQU 2 SET CAMS_STATES=%CAMS_STATES%_freddy&BREAK>saw_freddy
IF %CAMS_STATE%==_5 IF %FOXY% EQU 1 SET CAMS_STATES=%CAMS_STATES%_foxy_1
IF %CAMS_STATE%==_5 IF %FOXY% EQU 2 SET CAMS_STATES=%CAMS_STATES%_foxy_2
IF %CAMS_STATE%==_5 IF %FOXY% GEQ 3 SET CAMS_STATES=%CAMS_STATES%_foxy_3
IF %CAMS_STATE%==_6 IF %BONNIE% EQU 3 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_8 IF %BONNIE% EQU 4 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_8 IF %FOXY% EQU 3 SET CAMS_STATES=%CAMS_STATE%_foxy
IF %CAMS_STATE%==_9 IF %BONNIE% EQU 5 SET CAMS_STATES=%CAMS_STATES%_bonnie
IF %CAMS_STATE%==_10 IF %CHICA% EQU 4 SET CAMS_STATES=%CAMS_STATES%_chica
IF %CAMS_STATES%==_10 IF %FREDDY% EQU 3 SET CAMS_STATES=%CAMS_STATES%_freddy&BREAK>saw_freddy
IF %CAMS_STATE%==_11 IF %CHICA% EQU 5 SET CAMS_STATES=%CAMS_STATES%_chica
IF %CAMS_STATES%==_11 IF %FREDDY% EQU 4 SET CAMS_STATES=%CAMS_STATES%_freddy&BREAK>saw_freddy

IF %VIEW%==CAMS (
	>cams_state SET /P "=%CAMS_STATE%" <NUL
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
	IF %CAMS_STATES%==_8_foxy (
		BREAK>SEEN_FOXY
	)
)
REM TITLE [cams%CAMS_STATES%]

:CHOICE
:: Update battery and time
IF EXIST BATTERY SET /P BATTERY=<BATTERY
IF %BATTERY% LEQ 0 GOTO :OUTAGE
IF %VIEW%==OFFICE ( ECHO.[3;172H%RGB%26;22;45mPower:%RGB%25;21;44m %RGB%34;30;53m%BATTERY%%% ) ELSE ECHO.[4;171H%RGB%40;40;40mPower: %BATTERY%%% 

IF EXIST TIME SET /P TIME=<TIME
IF %VIEW%==OFFICE ( ECHO.[2;178H%RGB%32;26;50m%TIME% AM ) ELSE ECHO.[3;177H%RGB%40;40;40m%TIME% AM 

SET OLD_CHICA=%CHICA%
SET OLD_BONNIE=%BONNIE%
SET OLD_FOXY=%FOXY%
SET OLD_FREDDY=%FREDDY%

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
	IF /I %CHOICE.INPUT%==H START /B "" CMD /C CALL ".\audiomanager.cmd" START PartyFavorraspyPart_AC01__3.mp3 sfx False 95 ^& EXIT >NUL 2>&1
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
		BREAK>saw_cams
		IF %GOLDENFREDDY% EQU 1 (
			START /B "" CMD /C CALL ".\audiomanager.cmd" STOP golden ^& EXIT >NUL 2>&1
		)
	) ELSE (
		START /B "" CMD /C CALL ".\audiomanager.cmd" START camera_down.mp3 camera_down False 100 ^& EXIT >NUL
		START /B "" CMD /C CALL ".\audiomanager.cmd" STOP camera_up ^& EXIT >NUL
		CALL :GOLDENFREDDY
		SET VIEW=OFFICE
		DEL /Q ".\cams_state"
	)
	GOTO :RE
)

IF /I %CHOICE.INPUT%==TAB IF %TAB% EQU 0 (
	SET TAB=1
	START /B "" CMD /C CALL ".\audiomanager.cmd" STOP voiceover ^& EXIT >NUL
	GOTO :RE
)

IF /I %CHOICE.INPUT%== (
	SET JUMPSCARE=_chica
	GOTO :GAMEOVER
)
IF /I %CHOICE.INPUT%== (
	SET JUMPSCARE=_bonnie
	GOTO :GAMEOVER
)
IF /I %CHOICE.INPUT%== (
	SET JUMPSCARE=_foxy
	GOTO :GAMEOVER
)
IF /I %CHOICE.INPUT%== (
	TASKKILL /F /FI "WINDOWTITLE eq FNaF Events - TIME: *" /IM "cmd.exe" /T
	GOTO :OUTAGE
)
IF /I %CHOICE.INPUT%== GOTO :WIN

IF /I %CHOICE.INPUT%== EXIT /B 0

:: Get Updates
IF %CHOICE.INPUT%==TIMEOUT (
	:: Win detection
	IF EXIST WIN GOTO :WIN

	CALL .\MOVEMENTS.cmd
	
	SETLOCAL ENABLEDELAYEDEXPANSION
	
	:: Window Scares
	IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 6 (
		ENDLOCAL
		SET WS_BONNIE=1
		SETLOCAL ENABLEDELAYEDEXPANSION
	)
	IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 5 (
		ENDLOCAL
		SET WS_CHICA=1
		SETLOCAL ENABLEDELAYEDEXPANSION
	)


	:: Death detections
	IF !CHICA! GTR 6 (ECHO.%STATES% | findstr /C:"doorR") >NUL || (
		ENDLOCAL
		SET JUMPSCARE=_chica
		GOTO :GAMEOVER
	)
	IF !FREDDY! EQU 5 (ECHO.%STATES% | findstr /C:"doorR") >NUL || (
		ENDLOCAL
		SET JUMPSCARE=_freddy
		GOTO :GAMEOVER
	)
	IF !BONNIE! GTR 6 (ECHO.%STATES% | findstr /C:"doorL") >NUL || (
		ENDLOCAL
		SET JUMPSCARE=_bonnie
		GOTO :GAMEOVER
	)
	IF !FOXY! EQU 5 (ECHO.%STATES% | findstr /C:"doorL") >NUL || (
		ENDLOCAL
		SET JUMPSCARE=_foxy
		GOTO :GAMEOVER
	)
	
	
	:: Chica oven SFX updates
	IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 3 START /B "" CMD /C CALL ".\audiomanager.cmd" START oven.mp3 oven True 9 ^& EXIT >NUL 2>&1
	IF %OLD_CHICA% EQU 3 IF !CHICA! NEQ 3 START /B "" CMD /C CALL ".\audiomanager.cmd" STOP oven ^& EXIT >NUL 2>&1

	:: Cams updates
	IF %VIEW%==CAMS (
		IF %CAMS_STATE%==_1 (
			IF %OLD_CHICA% EQU 0 IF !CHICA! GEQ 1 ENDLOCAL&GOTO :RE
			IF %OLD_BONNIE% EQU 0 IF !BONNIE! GEQ 1 ENDLOCAL&GOTO :RE
			IF %OLD_FREDDY% EQU 0 IF !FREDDY! GEQ 1 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_2 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !OLD_CHICA! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !OLD_BONNIE! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT !BONNIE! EQU 1 IF NOT !CHICA! EQU 1 IF NOT %OLD_FREDDY% EQU !FREDDY! IF !OLD_FREDDY! EQU 1 ENDLOCAL&GOTO :RE
			IF NOT !BONNIE! EQU 1 IF NOT !CHICA! EQU 1 IF NOT %OLD_FREDDY% EQU !FREDDY! IF !FREDDY! EQU 1 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_3 (
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !OLD_BONNIE! EQU 2 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 2 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_4 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !OLD_CHICA! EQU 2 ENDLOCAL&GOTO :RE
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 2 ENDLOCAL&GOTO :RE
			IF NOT !CHICA! EQU 2 IF NOT %OLD_FREDDY% EQU !FREDDY! IF !OLD_FREDDY! EQU 2 ENDLOCAL&GOTO :RE
			IF NOT !CHICA! EQU 2 IF NOT %OLD_FREDDY% EQU !FREDDY! IF !FREDDY! EQU 2 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_5 (
			IF NOT %OLD_FOXY% EQU !FOXY! IF !FOXY! GTR 0 IF !FOXY! LEQ 3 ENDLOCAL&GOTO :RE
			IF NOT %OLD_FOXY% EQU !FOXY! IF !OLD_FOXY! EQU 4 IF !FOXY! LEQ 2 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_6 (
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !OLD_BONNIE! EQU 3 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 3 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_8 (
			IF NOT %OLD_FOXY% EQU !FOXY! IF !FOXY! EQU 3 ENDLOCAL&GOTO :RE
			IF NOT %OLD_FOXY% EQU !FOXY! IF !FOXY! EQU 4 (
				ENDLOCAL
				SET VIEW=OFFICE
				SET /A FOXY+=1
				START /B "" CMD /C CALL ".\audiomanager.cmd" START camera_down.mp3 camera_down False 100 ^& EXIT >NUL
				START /B "" CMD /C CALL ".\audiomanager.cmd" STOP camera_up ^& EXIT >NUL
				GOTO :RE
			)
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !OLD_BONNIE! EQU 4 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 4 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_9 (
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !OLD_BONNIE! EQU 5 ENDLOCAL&GOTO :RE
			IF NOT %OLD_BONNIE% EQU !BONNIE! IF !BONNIE! EQU 5 ENDLOCAL&GOTO :RE

		)
		IF %CAMS_STATE%==_10 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !OLD_CHICA! EQU 4 ENDLOCAL&GOTO :RE
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 4 ENDLOCAL&GOTO :RE
			IF NOT !CHICA! EQU 5 IF NOT %OLD_FREDDY% EQU !FREDDY! IF !OLD_FREDDY! EQU 3 ENDLOCAL&GOTO :RE
			IF NOT !CHICA! EQU 5 IF NOT %OLD_FREDDY% EQU !FREDDY! IF !FREDDY! EQU 3 ENDLOCAL&GOTO :RE
		)
		IF %CAMS_STATE%==_11 (
			IF NOT %OLD_CHICA% EQU !CHICA! IF !OLD_CHICA! EQU 5 ENDLOCAL&GOTO :RE
			IF NOT %OLD_CHICA% EQU !CHICA! IF !CHICA! EQU 5 ENDLOCAL&GOTO :RE
			IF NOT !CHICA! EQU 6 IF NOT %OLD_FREDDY% EQU !FREDDY! IF !OLD_FREDDY! EQU 4 ENDLOCAL&GOTO :RE
			IF NOT !CHICA! EQU 6 IF NOT %OLD_FREDDY% EQU !FREDDY! IF !FREDDY! EQU 4 ENDLOCAL&GOTO :RE
		)
		
	)

	:: Office state updates
	IF %VIEW%==OFFICE (
		(ECHO.%STATES% | findstr /C:"lightR" /C:"chica") >NUL && (
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
				IF %OLD_BONNIE% EQU 6 IF !BONNIE! LSS 5 (
					ENDLOCAL
					GOTO :RE
				)
				IF !BONNIE! GEQ 6 (
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
IF %GF_CALC% LEQ 6 (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START whispering2.mp3 golden True 100 ^& EXIT >NUL 2>&1
	SET GOLDENFREDDY=1
	SET R_DOOR=0
	SET L_DOOR=0
	SET R_LIGHTS=0
	SET L_LIGHTS=0
)
EXIT /B 0


:OUTAGE
START /B "" CMD /C CALL ".\audiomanager.cmd" START powerdown.mp3 powerdown False 100 ^& EXIT >NUL 2>&1
IF NOT %VIEW%==OFFICE (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START camera_down.mp3 camera_down False 100 ^& EXIT >NUL
	START /B "" CMD /C CALL ".\audiomanager.cmd" STOP camera_up ^& EXIT >NUL
)
TYPE ".\assets\office_outage.ans" > CON
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP ambience ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP voiceover ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP oven ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP golden ^& EXIT >NUL

SET /A RND=%RANDOM% %% 2 +1
IF %RND% EQU 1 (
	TIMEOUT /T 2 /NOBREAK >NUL
	START /B "" CMD /C CALL ".\audiomanager.cmd" START running_fast3.mp3 sfx False 22 ^& EXIT >NUL 2>&1
	TIMEOUT /T 3 /NOBREAK >NUL
) ELSE (
	TIMEOUT /T 3 /NOBREAK >NUL
	START /B "" CMD /C CALL ".\audiomanager.cmd" START deepsteps.mp3 sfx False 22 ^& EXIT >NUL 2>&1
	TIMEOUT /T 6 /NOBREAK >NUL
)
SET /A RND=%RANDOM% %% 2 +1
IF %RND% EQU 1 (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START running_fast3.mp3 sfx False 22 ^& EXIT >NUL 2>&1
	TIMEOUT /T 3 /NOBREAK >NUL
) ELSE (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START deepsteps.mp3 sfx False 22 ^& EXIT >NUL 2>&1
	TIMEOUT /T 6 /NOBREAK >NUL
)
SET /A RND=%RANDOM% %% 2 +1
IF %RND% EQU 1 (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START running_fast3.mp3 sfx False 22 ^& EXIT >NUL 2>&1
	TIMEOUT /T 3 /NOBREAK >NUL
)
START /B "" CMD /C CALL ".\audiomanager.cmd" START deepsteps.mp3 sfx False 22 ^& EXIT >NUL 2>&1
TIMEOUT /T 7 /NOBREAK >NUL
CALL ".\audiomanager.cmd" START musicbox.mp3 musicbox False 90

(
	ECHO @ECHO OFF
	ECHO :L
	ECHO TYPE ".\assets\office_outage_freddy.ans" ^> CON
	ECHO HELP^>NUL
	ECHO HELP^>NUL
	ECHO TYPE ".\assets\office_outage_half.ans" ^> CON
	ECHO TYPE ".\assets\office_outage_freddy.ans" ^> CON
	ECHO HELP^>NUL
	ECHO HELP^>NUL
	ECHO TYPE ".\assets\office_outage_half.ans" ^> CON
	ECHO IF EXIST .\temp\STOP EXIT
	ECHO TIMEOUT /T 0 /NOBREAK ^>NUL
	ECHO TYPE ".\assets\office_outage_freddy.ans" ^> CON
	ECHO HELP^>NUL
	ECHO HELP^>NUL
	ECHO TYPE ".\assets\office_outage_half.ans" ^> CON
	ECHO IF EXIST .\temp\STOP EXIT
	ECHO TIMEOUT /T 0 /NOBREAK ^>NUL
	ECHO TYPE ".\assets\office_outage_freddy.ans" ^> CON
	ECHO HELP^>NUL
	ECHO HELP^>NUL
	ECHO TYPE ".\assets\office_outage_half.ans" ^> CON
	ECHO TYPE ".\assets\office_outage_freddy.ans" ^> CON
	ECHO HELP^>NUL
	ECHO HELP^>NUL
	ECHO TYPE ".\assets\office_outage_half.ans" ^> CON
	ECHO IF EXIST .\temp\STOP EXIT
	ECHO TYPE ".\assets\office_outage_freddy.ans" ^> CON
	ECHO HELP^>NUL
	ECHO HELP^>NUL
	ECHO TYPE ".\assets\office_outage_half.ans" ^> CON
	ECHO IF EXIST .\temp\STOP EXIT
	ECHO TIMEOUT /T 0 /NOBREAK ^>NUL
	ECHO TYPE ".\assets\office_outage_freddy.ans" ^> CON
	ECHO HELP^>NUL
	ECHO HELP^>NUL
	ECHO TYPE ".\assets\office_outage_half.ans" ^> CON
	ECHO IF EXIST .\temp\STOP EXIT
	ECHO TIMEOUT /T 0 /NOBREAK ^>NUL
	ECHO GOTO :L
)>".\temp\outagefreddy.cmd"
SET /A RND=%RANDOM% %% 9 +11
START /B "" CMD /C CALL ".\temp\outagefreddy.cmd" ^& EXIT 2>NUL
TIMEOUT /T %RND% /NOBREAK >NUL
ECHO.>.\temp\STOP
TIMEOUT /T 1 /NOBREAK >NUL
DEL /Q ".\temp\outagefreddy.cmd" >NUL 2>&1
DEL /Q ".\temp\STOP" >NUL 2>&1
CALL ".\audiomanager.cmd" STOP musicbox
TYPE ".\assets\office_outage.ans" > CON
SET /A RND=%RANDOM% %% 4 +8
TIMEOUT /T %RND% /NOBREAK >NUL
IF EXIST WIN (GOTO :WIN) ELSE (
	SET JUMPSCARE=_freddy
	GOTO :GAMEOVER
)


:GAMEOVER
DEL /Q ".\SEEN_FOXY"
CALL ".\audiomanager.cmd" START XSCREAM.mp3 sfx False 100
HELP >NUL
HELP >NUL
TYPE ".\assets\jumpscare%JUMPSCARE%.ans" > CON
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP ambience ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP voiceover ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP oven ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP golden ^& EXIT >NUL
	DEL /Q ".\office_states"
	DEL /Q ".\cams_state"
	DEL /Q ".\MOVEMENTS.cmd"
	DEL /Q ".\refresh"
	DEL /Q ".\SEEN_FOXY"
	DEL /Q ".\BATTERY"
	DEL /Q ".\TIME"
	DEL /Q ".\saw_freddy"
	DEL /Q ".\saw_cams"
TASKKILL /F /FI "WINDOWTITLE eq FNaF Events - TIME: *" /IM "cmd.exe" /T >NUL 2>&1
TIMEOUT /T 4 /NOBREAK >NUL
TYPE ".\assets\gameover.ans" > CON
TIMEOUT /T 9 /NOBREAK >NUL
GOTO :LAUNCH

:WIN
DEL /Q ".\SEEN_FOXY"
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP ambience ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP voiceover ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP oven ^& EXIT >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP golden ^& EXIT >NUL
	DEL /Q ".\office_states"
	DEL /Q ".\cams_state"
	DEL /Q ".\MOVEMENTS.cmd"
	DEL /Q ".\refresh"
	DEL /Q ".\SEEN_FOXY"
	DEL /Q ".\BATTERY"
	DEL /Q ".\TIME"
	DEL /Q ".\saw_freddy"
	DEL /Q ".\saw_cams"
	DEL /Q ".\WIN"
CALL ".\audiomanager.cmd" START chimes2.mp3 sfx False 100
TYPE ".\assets\5am.ans" > CON
TASKKILL /F /FI "WINDOWTITLE eq FNaF Events - TIME: *" /IM "cmd.exe" /T >NUL 2>&1
TIMEOUT /T 4 /NOBREAK >NUL
CALL ".\audiomanager.cmd" START CROWD_SMALL_CHIL_EC049202.mp3 sfx False 100
CALL ".\assets\6am.cmd"
TIMEOUT /T 7 >NUL
START /B "" CMD /C CALL ".\audiomanager.cmd" STOP sfx ^& EXIT >NUL
GOTO :LAUNCH
