@TITLE FNaF Events
@ECHO OFF
SET TIMER=1
SET CHICA=0
SET BONNIE=0
SET FOXY=0
SET TIMER_FOXY=1
SET S_TIMER_FOXY=0

SET BATTERY=10000

BREAK>MOVEMENTS.cmd

:: AI difficulty
SET MO_CHICA=0
SET MO_BONNIE=0
SET MO_FOXY=3

SETLOCAL ENABLEDELAYEDEXPANSION

ECHO.DIFFICULTY: %MO_CHICA%/%MO_BONNIE%/%MO_FOXY%
ECHO.MO: %CHICA% CHICA
ECHO.MO: %BONNIE% BONNIE
ECHO.MO: %FOXY% FOXY

:TIMER
TITLE FNaF Events - TIME: !TIMER!

SET STATES=
SET /P STATES=<office_states
IF EXIST cams_state (
	SET /P CAMS_STATES=<cams_state
) ELSE SET CAMS_STATES=_

SET /A S_CALC=TIMER %% 4

:: Increase MO based on the timer
IF !TIMER! EQU 25 SET /A MO_BONNIE+=1 &:: 0.5 minutes in
IF !TIMER! EQU 60 SET /A MO_CHICA+=1 &:: 1.0 minutes in
IF !TIMER! EQU 150 SET /A MO_BONNIE+=1 &:: 2.5 minutes in
IF !TIMER! EQU 300 SET /A MO_CHICA+=2 &:: 5 minutes in
IF !TIMER! EQU 300 SET /A MO_FOXY+=2 &:: 5 minutes in
IF !TIMER! EQU 420 SET /A MO_CHICA+=1 &:: 7 minutes in
IF !TIMER! EQU 450 SET /A MO_BONNIE+=2 &:: 7.5 minutes in

:: Movement Calculations
IF !S_CALC! EQU 0 (
	SET /A "RND_CHICA=%RANDOM% %% 19 + 1"
	IF !RND_CHICA! LEQ !MO_CHICA! (
		IF !CHICA! LEQ 1 (
			SET /A CHICA+=1
		) ELSE IF !CHICA! GEQ 4 (
			SET /A CHICA+=1
		) ELSE (
			SET /A "RND_CHICA=%RANDOM% %% 2 + 1"
			IF !RND_CHICA! EQU 1 (
				SET /A CHICA+=1
			) ELSE (
				SET /A CHICA-=1
			)
		)
		IF !CHICA! GEQ 5 (ECHO.!STATES! | findstr /C:"doorR") >NUL && SET CHICA=1
		ECHO.MO: !CHICA! CHICA
		>refresh SET /P "=" <NUL
	)
	SET /A "RND_BONNIE=%RANDOM% %% 19 + 1"
	IF !RND_BONNIE! LEQ !MO_BONNIE! (
		IF !BONNIE! EQU 1 (
			SET /A BONNIE=%RANDOM% %% 4 + 1
			IF !BONNIE! EQU 1 SET /A BONNIE+=2
		) ELSE IF !BONNIE! EQU 2 (
			SET /A BONNIE=%RANDOM% %% 4 + 1
			IF !BONNIE! EQU 2 SET /A BONNIE+=2
		) ELSE IF !BONNIE! EQU 3 (
			SET /A BONNIE=%RANDOM% %% 5 + 1
			IF !BONNIE! EQU 3 SET /A BONNIE+=2
			START /B "" CMD /C CALL ".\audiomanager.cmd" START deepsteps.mp3 sfx False 22 ^& EXIT >NUL 2>&1
		) ELSE IF !BONNIE! EQU 4 (
			SET /A BONNIE=%RANDOM% %% 5 + 1
			IF !BONNIE! EQU 4 SET /A BONNIE+=1
			START /B "" CMD /C CALL ".\audiomanager.cmd" START deepsteps.mp3 sfx False 22 ^& EXIT >NUL 2>&1
		) ELSE (
			SET /A BONNIE+=1
		)
		IF !BONNIE! GTR 6 (ECHO.!STATES! | findstr /C:"doorL") >NUL && SET /A BONNIE=%RANDOM% %% 3 + 1
		ECHO.MO: !BONNIE! BONNIE
		>refresh SET /P "=" <NUL
	)
)

IF !CAMS_STATES!==_5 SET TIMER_FOXY=0
SET /A F_CALC=TIMER_FOXY %% 5
SET /A "RND_FOXY=%RANDOM% %% 19 + 1"

:: Specifically for Foxy
IF !F_CALC! EQU 0 IF !RND_FOXY! LEQ !MO_FOXY! IF !FOXY! LSS 3 (
	SET /A "RND_FOXY=%RANDOM% %% 19 + 1"
	IF !RND_FOXY! LEQ !MO_FOXY! (
		IF NOT !CAMS_STATES!==_5 (
			SET /A FOXY+=1
			>refresh SET /P "=" <NUL
			ECHO.MO: !FOXY! FOXY, TIMER: !TIMER_FOXY!
		)
	)
)

IF EXIST SEEN_FOXY (
	IF !S_TIMER_FOXY! EQU 1 (
		SET S_TIMER_FOXY=5
		SET /A FOXY+=1
		>refresh SET /P "=" <NUL
		ECHO.MO: !FOXY! FOXY, TIMER: !TIMER_FOXY!
	) ELSE IF !S_TIMER_FOXY! EQU 3 (
		(ECHO.!STATES! | findstr /C:"doorL") >NUL && (
			START /B "" CMD /C CALL ".\audiomanager.cmd" START knock2.mp3 sfx False 95 ^& EXIT >NUL 2>&1
			SET FOXY=0
			SET S_TIMER_FOXY=0
			DEL /Q ".\SEEN_FOXY"
		) || (
			SET /A FOXY+=1
			DEL /Q ".\SEEN_FOXY"
		)
		>refresh SET /P "=" <NUL
		ECHO.MO: !FOXY! FOXY, TIMER: !TIMER_FOXY!
	) ELSE (
		IF !S_TIMER_FOXY! LSS 3 (
			SET /A S_TIMER_FOXY+=1
		)
		IF !S_TIMER_FOXY! GTR 3 (
			SET /A S_TIMER_FOXY-=1
		)
	)
)


:: Send the new movements to the main game
IF EXIST .\refresh (
		ECHO SET CHICA=!CHICA!
		ECHO SET BONNIE=!BONNIE!
		ECHO SET FOXY=!FOXY!
) >MOVEMENTS.cmd


:: Battery
SET /A B_CALC=TIMER %% 5

SET DRAIN=4
(ECHO.!STATES! | findstr /C:"_doorL") >NUL && SET /A DRAIN+=12
(ECHO.!STATES! | findstr /C:"_doorR") >NUL && SET /A DRAIN+=12
(ECHO.!STATES! | findstr /C:"_lightL") >NUL && SET /A DRAIN+=12
(ECHO.!STATES! | findstr /C:"_lightR") >NUL && SET /A DRAIN+=12
(ECHO.!STATES! | findstr /C:"_bonnie") >NUL && SET /A DRAIN+=12
(ECHO.!STATES! | findstr /C:"_chica") >NUL && SET /A DRAIN+=12
IF EXIST cams_state SET /A DRAIN+=12
SET /A BATTERY-=DRAIN
SET /A SEND_BATTERY=BATTERY/100
ECHO.Battery: !SEND_BATTERY! (Real: %BATTERY% - Drain: %DRAIN%)
ECHO.!SEND_BATTERY!>BATTERY
IF !BATTERY! LEQ 0 >refresh SET /P "=" <NUL

:: Send a "refesh animatronic movements" signal to the main game, if needed (forced)
:FORCE_REFRESH
IF EXIST .\refresh (
	TASKKILL /IM xcopy.exe /F >NUL 2>&1 && (
		DEL /Q .\refresh
		ECHO.[+] Sent update to the main process^^^!
	) || (
		ECHO.[-] Attempting to update the main process...
		GOTO :FORCE_REFRESH
	)
)

IF !BATTERY! LEQ 0 EXIT 0

:: If survived 530 seconds, send a "win" signal to the main game (forced)
:FORCE_REFRESH_
IF !TIMER! GEQ 530 (
	IF NOT EXIST WIN BREAK>WIN
	TASKKILL /IM xcopy.exe /F || GOTO :FORCE_REFRESH_
	ENDLOCAL
	EXIT 0
)

:: Timers
SET /A TIMER+=1
SET /A TIMER_FOXY+=1
TIMEOUT /T 1 >NUL

:: Repeat
GOTO :TIMER
