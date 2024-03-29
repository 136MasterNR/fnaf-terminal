@TITLE FNaF Events
@ECHO OFF
SET TIMER=1
SET CHICA=0
SET BONNIE=0
SET FOXY=0
SET TIMER_FOXY=1
SET S_TIMER_FOXY=0
SET A_TIMER_FOXY=31

SET BATTERY=10000
SET SEND_BATTERY=99
SET OLD_BATTERY=99

SET TIME=12

BREAK>MOVEMENTS.cmd

:: AI difficulty
SET MO_FREDDY=-
SET MO_CHICA=0
SET MO_BONNIE=0
SET MO_FOXY=2

SETLOCAL ENABLEDELAYEDEXPANSION

ECHO.DIFFICULTY: %MO_FREDDY%/%MO_CHICA%/%MO_BONNIE%/%MO_FOXY%
ECHO.MO: "%FREDDY%" FREDDY
ECHO.MO: %CHICA% CHICA
ECHO.MO: %BONNIE% BONNIE
ECHO.MO: %FOXY% FOXY

:TIMER
SET STATES=
SET /P STATES=<office_states
IF EXIST cams_state (
	SET /P CAMS_STATES=<cams_state
) ELSE SET CAMS_STATES=_

:: Battery
SET DRAIN=4
(ECHO.!STATES! | findstr /C:"_doorL") >NUL && SET /A DRAIN+=13
(ECHO.!STATES! | findstr /C:"_doorR") >NUL && SET /A DRAIN+=13
(ECHO.!STATES! | findstr /C:"_lightL") >NUL && SET /A DRAIN+=13
(ECHO.!STATES! | findstr /C:"_lightR") >NUL && SET /A DRAIN+=13
(ECHO.!STATES! | findstr /C:"_bonnie") >NUL && SET /A DRAIN+=13
(ECHO.!STATES! | findstr /C:"_chica") >NUL && SET /A DRAIN+=13
IF EXIST cams_state SET /A DRAIN+=13
SET /A BATTERY-=DRAIN
SET /A SEND_BATTERY=BATTERY/100
IF NOT !OLD_BATTERY! EQU !SEND_BATTERY! (
	ECHO.!SEND_BATTERY!>BATTERY
	>refresh SET /P "=" <NUL
)
SET OLD_BATTERY=!SEND_BATTERY!

TITLE FNaF Events - Time: !TIMER! Power: !SEND_BATTERY! ^(Real: %BATTERY% - Drain: %DRAIN%^)

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
		IF !CHICA! GTR 5 (ECHO.!STATES! | findstr /C:"doorR") >NUL && SET CHICA=1
		ECHO.MO: !CHICA! CHICA
		>refresh SET /P "=" <NUL
	)
	SET /A "RND_BONNIE=%RANDOM% %% 19 + 1"
	IF !RND_BONNIE! LEQ !MO_BONNIE! (
		IF !BONNIE! EQU 1 (
			SET /A BONNIE=%RANDOM% %% 4 + 1
			IF !BONNIE! EQU 1 SET /A BONNIE+=2
			START /B "" CMD /C CALL ".\audiomanager.cmd" START deepsteps.mp3 sfx False 22 ^& EXIT >NUL 2>&1
		) ELSE IF !BONNIE! EQU 2 (
			SET /A BONNIE=%RANDOM% %% 4 + 1
			IF !BONNIE! EQU 2 SET /A BONNIE+=2
			START /B "" CMD /C CALL ".\audiomanager.cmd" START deepsteps.mp3 sfx False 22 ^& EXIT >NUL 2>&1
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

:: Specifically for Foxy
REM TITLE FOXY=%FOXY% S_TIMER_FOXY=%S_TIMER_FOXY% A_TIMER_FOXY=%A_TIMER_FOXY%

IF !FOXY! GEQ 5 (ECHO.!STATES! | findstr /C:"doorL") >NUL && (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START knock2.mp3 sfx False 95 ^& EXIT >NUL 2>&1
	SET FOXY=0
	SET S_TIMER_FOXY=31
	DEL /Q ".\SEEN_FOXY"
	>refresh SET /P "=" <NUL
) || (
	SET /A FOXY+=1
	>refresh SET /P "=" <NUL
)

IF !CAMS_STATES!==_5 SET TIMER_FOXY=0
SET /A F_CALC=TIMER_FOXY %% 6
SET /A "RND_FOXY=%RANDOM% %% 19 + 1"

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
	IF !FOXY! GEQ 3 (
		IF !A_TIMER_FOXY! NEQ 31 SET A_TIMER_FOXY=31
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
	) ELSE DEL /Q ".\SEEN_FOXY"
) ELSE IF !FOXY! GEQ 3 (
	IF !A_TIMER_FOXY! EQU 29 (
		IF !FOXY! EQU 4 (
			(ECHO.!STATES! | findstr /C:"doorL") >NUL && (
				START /B "" CMD /C CALL ".\audiomanager.cmd" START knock2.mp3 sfx False 95 ^& EXIT >NUL 2>&1
				SET FOXY=0
				SET A_TIMER_FOXY=0
				DEL /Q ".\SEEN_FOXY"
			) || (
				SET /A FOXY+=1
				DEL /Q ".\SEEN_FOXY"
			)
			ECHO.MO: !FOXY! FOXY, TIMER: !TIMER_FOXY!
			>refresh SET /P "=" <NUL
		) ELSE IF !FOXY! EQU 3 (
			START /B "" CMD /C CALL ".\audiomanager.cmd" START run.mp3 sfx False 100 ^& EXIT >NUL 2>&1
			SET /A FOXY+=1
			ECHO.MO: !FOXY! FOXY, TIMER: !TIMER_FOXY!
			>refresh SET /P "=" <NUL
		)
	) ELSE IF !A_TIMER_FOXY! GTR 29 (
		SET A_TIMER_FOXY=0
	) ELSE SET /A A_TIMER_FOXY+=1
)


:: Send the new movements to the main game
IF EXIST .\refresh (
		ECHO SET CHICA=!CHICA!
		ECHO SET BONNIE=!BONNIE!
		ECHO SET FOXY=!FOXY!
)>.\MOVEMENTS.cmd

IF %TIMER% EQU 89 (
	ECHO.1>TIME
	ECHO.Time: 1 AM
	>refresh SET /P "=" <NUL
) ELSE IF %TIMER% EQU 178 (
	ECHO.2>TIME
	ECHO.Time: 2 AM
	>refresh SET /P "=" <NUL
) ELSE IF %TIMER% EQU 267 (
	ECHO.3>TIME
	ECHO.Time: 3 AM
	>refresh SET /P "=" <NUL
) ELSE IF %TIMER% EQU 356 (
	ECHO.4>TIME
	ECHO.Time: 4 AM
	>refresh SET /P "=" <NUL
) ELSE IF %TIMER% EQU 445 (
	ECHO.5>TIME
	ECHO.Time: 5 AM
	>refresh SET /P "=" <NUL
)

:: Send a "refesh animatronic movements" signal to the main game, only if needed (forced)
:FORCE_REFRESH
IF !SEND_BATTERY! LEQ 0 (
	TASKKILL /IM xcopy.exe /F >NUL 2>&1 && (
		ECHO. [Q] Events safely stopped.
		EXIT
	) || (
		ECHO.[-] Attempting to update the main process...
		GOTO :FORCE_REFRESH
	)
)
IF EXIST .\refresh (
	TASKKILL /IM xcopy.exe /F >NUL 2>&1 && (
		DEL /Q .\refresh
		ECHO.[+] Sent update to the main process^^^!
	) || (
		ECHO.[-] Attempting to update the main process...
		GOTO :FORCE_REFRESH
	)
)

:: If survived 534 seconds, send a "win" signal to the main game (forced)
:FORCE_REFRESH_
IF !BATTERY! LEQ -1 EXIT
IF !TIMER! GEQ 534 (
	IF NOT EXIST WIN BREAK>WIN
	TASKKILL /IM xcopy.exe /F || GOTO :FORCE_REFRESH_
	ENDLOCAL
	EXIT 0
)

:: Random Sounds
SET /A RND_SFX=%RANDOM% %% 350 +1
IF !RND_SFX! EQU 1 START /B "" CMD /C CALL ".\audiomanager.cmd" START circus.mp3 sfx False 14 ^& EXIT >NUL 2>&1
SET /A RND_SFX=%RANDOM% %% 175 +1
IF !RND_SFX! EQU 1 START /B "" CMD /C CALL ".\audiomanager.cmd" START pirate_song2.mp3 sfx False 18 ^& EXIT >NUL 2>&1


:: Timers
SET /A TIMER+=1
SET /A TIMER_FOXY+=1
TIMEOUT /T 1 >NUL

:: Repeat
GOTO :TIMER
