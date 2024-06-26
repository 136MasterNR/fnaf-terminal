@TITLE FNaF Events
@ECHO OFF
SET TIMER=1
SET FREDDY=0
SET TIMER_FREDDY=0
SET CHICA=0
SET BONNIE=0
SET FOXY=0
SET TIMER_FOXY=1
SET S_TIMER_FOXY=0
SET A_TIMER_FOXY=31
SET FOXY_ATTACKS=0
SET PLAYED_BG=

SET BATTERY=10000
SET SEND_BATTERY=99
SET OLD_BATTERY=99
SET WIN=0

BREAK>MOVEMENTS.cmd

CALL ".\io.cmd" READ "%APPDATA%\fnaf-terminal\freddy" freddy

:: ::::::::::::: ::
:: AI difficulty ::
SET MO_FREDDY=%1
SET MO_CHICA=%2
SET MO_BONNIE=%3
SET MO_FOXY=%4

SETLOCAL ENABLEDELAYEDEXPANSION

ECHO.freddy[level]=%freddy[level]%
ECHO.DIFFICULTY: %MO_FREDDY%/%MO_CHICA%/%MO_BONNIE%/%MO_FOXY%
ECHO.MO: %FREDDY% FREDDY
ECHO.MO: %CHICA% CHICA
ECHO.MO: %BONNIE% BONNIE
ECHO.MO: %FOXY% FOXY

:TIMER
:: :::::::::::: ::
:: Share States ::
SET STATES=
SET /P STATES=<office_states
IF EXIST cams_state (
	SET /P CAMS_STATES=<cams_state
) ELSE SET CAMS_STATES=_


:: ::::::: ::
:: Battery ::
SET DRAIN=5
(ECHO.!STATES! | findstr /C:"_doorL") >NUL && SET /A DRAIN+=15
(ECHO.!STATES! | findstr /C:"_doorR") >NUL && SET /A DRAIN+=15
(ECHO.!STATES! | findstr /C:"_lightL") >NUL && SET /A DRAIN+=15
(ECHO.!STATES! | findstr /C:"_lightR") >NUL && SET /A DRAIN+=15
(ECHO.!STATES! | findstr /C:"_bonnie") >NUL && SET /A DRAIN+=15
(ECHO.!STATES! | findstr /C:"_chica") >NUL && SET /A DRAIN+=15
IF EXIST cams_state SET /A DRAIN+=13
SET /A BATTERY-=DRAIN
SET /A SEND_BATTERY=BATTERY/100
IF NOT !OLD_BATTERY! EQU !SEND_BATTERY! (
	ECHO.!SEND_BATTERY!>BATTERY
	BREAK>refresh
)
SET OLD_BATTERY=!SEND_BATTERY!

:: ::::: ::
:: Title ::
TITLE FNaF Events - Time: !TIMER! Power: !SEND_BATTERY! ^(Real: %BATTERY% - Drain: %DRAIN%^)

:: :::::::::::::::::::::::::::::: ::
:: Increase MO based on the timer ::
IF %freddy[level]% GEQ 2 IF NOT !MO_BONNIE! GTR 19 IF !TIMER! EQU 25 SET /A MO_BONNIE+=1&ECHO.DIFFICULTY: !MO_BONNIE! BONNIE &:: 0.5 minutes in
IF %freddy[level]% GEQ 2 IF NOT !MO_CHICA! GTR 19 IF !TIMER! EQU 60 SET /A MO_CHICA+=1&ECHO.DIFFICULTY: !MO_CHICA! CHICA&:: 1.0 minutes in
IF %freddy[level]% GEQ 1 IF NOT !MO_BONNIE! GTR 19 IF !TIMER! EQU 150 SET /A MO_BONNIE+=1&ECHO.DIFFICULTY: !MO_BONNIE! BONNIE &:: 2.5 minutes in
IF %freddy[level]% GEQ 4 IF NOT !MO_FREDDY! GTR 19 IF !TIMER! EQU 240 SET /A MO_FREDDY+=1&ECHO.DIFFICULTY: !MO_FREDDY! FREDDY&:: 4 minutes in
IF %freddy[level]% GEQ 2 IF NOT !MO_CHICA! GTR 19 IF !TIMER! EQU 300 SET /A MO_CHICA+=1&ECHO.DIFFICULTY: !MO_CHICA! CHICA&:: 5 minutes in
IF %freddy[level]% GEQ 3 IF NOT !MO_FOXY! GTR 19 IF !TIMER! EQU 300 SET /A MO_FOXY+=1&ECHO.DIFFICULTY: !MO_FOXY! FOXY&:: 5 minutes in
IF %freddy[level]% GEQ 5 IF NOT !MO_FREDDY! GTR 19 IF !TIMER! EQU 330 SET /A MO_FREDDY+=1&ECHO.DIFFICULTY: !MO_FREDDY! FREDDY &:: 5.5 minutes in
IF %freddy[level]% GEQ 4 IF NOT !MO_FOXY! GTR 19 IF !TIMER! EQU 360 SET /A MO_FOXY+=1&ECHO.DIFFICULTY: !MO_FOXY! FOXY&:: 6 minutes in
IF %freddy[level]% GEQ 1 IF NOT !MO_CHICA! GTR 19 IF !TIMER! EQU 420 SET /A MO_CHICA+=1&ECHO.DIFFICULTY: !MO_CHICA! CHICA&:: 7 minutes in
IF %freddy[level]% GEQ 3 IF NOT !MO_BONNIE! GTR 19 IF !TIMER! EQU 450 SET /A MO_BONNIE+=1&ECHO.DIFFICULTY: !MO_BONNIE! BONNIE &:: 7.5 minutes in
IF %freddy[level]% GEQ 4 IF NOT !MO_FREDDY! GTR 19 IF !TIMER! EQU 480 SET /A MO_FREDDY+=1&ECHO.DIFFICULTY: !MO_FREDDY! FREDDY &:: 8 minutes in

:: ::::::::::::::::::::: ::
:: Movement Calculations :: [Bonnie & Chica]
SET /A S_CALC=TIMER %% 4
IF !S_CALC! EQU 0 (
	SET /A "RND_CHICA=%RANDOM% %% 19 + 1"
	IF !RND_CHICA! LEQ !MO_CHICA! (
		IF !CHICA! LEQ 1 (
			SET /A CHICA+=1
		) ELSE IF !CHICA! GEQ 5 (
			SET /A CHICA+=1
		) ELSE (
			START /B "" CMD /C CALL ".\audiomanager.cmd" START deepsteps.mp3 sfx False 22 ^& EXIT >NUL 2>&1
			SET /A "RND_CHICA=%RANDOM% %% 5 + 1"
			IF !RND_CHICA! LEQ 3 (
				SET /A CHICA+=1
			) ELSE (
				SET /A CHICA-=1
			)
		)
		IF !CHICA! GTR 6 (ECHO.!STATES! | findstr /C:"doorR") >NUL && SET CHICA=1
		ECHO.MO: !CHICA! CHICA
		BREAK>refresh
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
		BREAK>refresh
	)
)

:: :::: ::
:: Foxy ::

IF !FOXY! GEQ 5 (ECHO.!STATES! | findstr /C:"doorL") >NUL && (
	START /B "" CMD /C CALL ".\audiomanager.cmd" START knock2.mp3 sfx False 95 ^& EXIT >NUL 2>&1
	SET FOXY=0
	SET S_TIMER_FOXY=31
	DEL /Q ".\SEEN_FOXY"
	BREAK>refresh
) || (
	SET /A FOXY+=1
	BREAK>refresh
)

IF EXIST cams_state SET TIMER_FOXY=0
IF EXIST saw_cams (
	SET TIMER_FOXY=0
	DEL /Q ".\saw_cams"
)

IF !TIMER_FOXY! GEQ 5 (SET /A F_CALC=TIMER_FOXY %% 5) ELSE SET F_CALC=1
SET /A "RND_FOXY=%RANDOM% %% 19 + 1"


IF !F_CALC! EQU 0 IF !RND_FOXY! LEQ !MO_FOXY! IF !FOXY! LSS 3 (
	IF NOT EXIST cams_state (
		SET /A FOXY+=1
		BREAK>refresh
		ECHO.MO: !FOXY! FOXY
	)
)

IF EXIST SEEN_FOXY (
	IF !FOXY! GEQ 3 (
		IF !A_TIMER_FOXY! NEQ 31 SET A_TIMER_FOXY=31
		IF !S_TIMER_FOXY! EQU 0 (
			START /B "" CMD /C CALL ".\audiomanager.cmd" START run.mp3 sfx False 100 ^& EXIT >NUL 2>&1
		)
		IF !S_TIMER_FOXY! EQU 1 (
			SET S_TIMER_FOXY=5
			SET /A FOXY+=1
			BREAK>refresh
			ECHO.MO: !FOXY! FOXY
		) ELSE IF !S_TIMER_FOXY! EQU 5 (
			(ECHO.!STATES! | findstr /C:"doorL") >NUL && (
				START /B "" CMD /C CALL ".\audiomanager.cmd" START knock2.mp3 sfx False 95 ^& EXIT >NUL 2>&1
				SET FOXY=0
				SET S_TIMER_FOXY=0
				SET /A FOXY_ATTACKS+=1
				SET /A "FOXY_DRAIN=(FOXY_ATTACKS*2)*100"
				SET /A BATTERY-=FOXY_DRAIN
				ECHO.FOXY DRAINED: !FOXY_DRAIN!
				DEL /Q ".\SEEN_FOXY"
			) || (
				SET /A FOXY+=1
				DEL /Q ".\SEEN_FOXY"
			)
			BREAK>refresh
			ECHO.MO: !FOXY! FOXY
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
		SET /A A_TIMER_FOXY+=1
		IF !FOXY! EQU 3 (
			START /B "" CMD /C CALL ".\audiomanager.cmd" START run.mp3 sfx False 100 ^& EXIT >NUL 2>&1
			SET /A FOXY+=1
			ECHO.MO: !FOXY! FOXY
			BREAK>refresh
		)
	) ELSE IF !A_TIMER_FOXY! EQU 31 (
		SET /A A_TIMER_FOXY+=1
		IF !FOXY! EQU 4 (
			(ECHO.!STATES! | findstr /C:"doorL") >NUL && (
				START /B "" CMD /C CALL ".\audiomanager.cmd" START knock2.mp3 sfx False 95 ^& EXIT >NUL 2>&1
				SET FOXY=0
				SET A_TIMER_FOXY=0
				SET /A FOXY_ATTACKS+=1
				SET /A "FOXY_DRAIN=(FOXY_ATTACKS*2)*100"
				SET /A BATTERY-=FOXY_DRAIN
				ECHO.FOXY DRAINED: !FOXY_DRAIN!
				DEL /Q ".\SEEN_FOXY"
			) || (
				SET /A FOXY+=1
				DEL /Q ".\SEEN_FOXY"
			)
			ECHO.MO: !FOXY! FOXY
			BREAK>refresh
		)
	) ELSE IF !A_TIMER_FOXY! GTR 31 (
		SET A_TIMER_FOXY=0
	) ELSE SET /A A_TIMER_FOXY+=1
)


:: :::::: ::
:: Freddy ::

SET /A "RND_FREDDY=%RANDOM% %% 19 + 1"

SET /A F_CALC=TIMER %% 5
IF !FREDDY! GTR 0 (
	IF !FREDDY! LEQ 3 (
		IF !TIMER_FREDDY! GTR 1 (
			IF NOT EXIST saw_freddy (
				SET /A TIMER_FREDDY-=1*MO_FREDDY
				IF !FREDDY! EQU 1 IF !CAMS_STATES!==_2 SET /A TIMER_FREDDY+=1*MO_FREDDY
				IF !FREDDY! EQU 2 IF !CAMS_STATES!==_4 SET /A TIMER_FREDDY+=1*MO_FREDDY
				IF !FREDDY! EQU 3 IF !CAMS_STATES!==_10 SET /A TIMER_FREDDY+=1*MO_FREDDY
				IF !TIMER_FREDDY! LSS 1 SET TIMER_FREDDY=1
			) ELSE DEL /Q ".\saw_freddy"
		)
		
		IF !TIMER_FREDDY! EQU 1 (
			SET /A RND=!RANDOM! %% 3 + 1
			START /B "" CMD /C CALL ".\audiomanager.cmd" START running_fast3.mp3 sfx False 40 ^& EXIT >NUL 2>&1
			IF !RND! EQU 1 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_1d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
			IF !RND! EQU 2 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_2d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
			IF !RND! EQU 3 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_8d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
			SET /A FREDDY+=1,TIMER_FREDDY=0
			BREAK>refresh
			ECHO.MO: !FREDDY! FREDDY
		)

		IF !F_CALC! EQU 0 IF !RND_FREDDY! LEQ !MO_FREDDY! IF !TIMER_FREDDY! EQU 0 (
			SET TIMER_FREDDY=10
		)

	) ELSE IF !FREDDY! EQU 4 (
		IF !F_CALC! EQU 0 IF !RND_FREDDY! LEQ !MO_FREDDY! IF NOT EXIST saw_freddy (
			IF NOT !CAMS_STATES!==_11 (ECHO.!STATES! | findstr /C:"doorR") >NUL && (
				SET /A RND=!RANDOM! %% 3 + 1
				START /B "" CMD /C CALL ".\audiomanager.cmd" START running_fast3.mp3 sfx False 40 ^& EXIT >NUL 2>&1
				IF !RND! EQU 1 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_1d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
				IF !RND! EQU 2 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_2d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
				IF !RND! EQU 3 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_8d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
				SET /A FREDDY-=!RND!
				BREAK>refresh
				ECHO.MO: !FREDDY! FREDDY
			) || (
				SET /A FREDDY+=1
				BREAK>refresh
			)
		) ELSE DEL /Q ".\saw_freddy"
	) ELSE SET /A FREDDY-=1
) ELSE (
	IF !F_CALC! EQU 0 IF !RND_FREDDY! LEQ !MO_FREDDY! IF !TIMER_FREDDY! EQU 0 IF !BONNIE! GTR 0 IF !CHICA! GTR 0 (
		SET /A RND=!RANDOM! %% 3 + 1
		START /B "" CMD /C CALL ".\audiomanager.cmd" START running_fast3.mp3 sfx False 40 ^& EXIT >NUL 2>&1
		IF !RND! EQU 1 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_1d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
		IF !RND! EQU 2 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_2d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
		IF !RND! EQU 3 START /B "" CMD /C CALL ".\audiomanager.cmd" START Laugh_Giggle_Girl_8d.mp3 sfx False 40 ^& EXIT >NUL 2>&1
		SET /A FREDDY+=1
		ECHO.MO: !FREDDY! FREDDY
		BREAK>refresh
	)
)

:: :::::::::::::::: ::
:: Movement Signals ::
IF EXIST .\refresh (
		ECHO SET FREDDY=!FREDDY!
		ECHO SET BONNIE=!BONNIE!
		ECHO SET CHICA=!CHICA!
		ECHO SET FOXY=!FOXY!
)>.\MOVEMENTS.cmd

IF %TIMER% EQU 89 (
	ECHO.1>TIME
	ECHO.Time: 1 AM
	BREAK>refresh
) ELSE IF %TIMER% EQU 178 (
	ECHO.2>TIME
	ECHO.Time: 2 AM
	BREAK>refresh
) ELSE IF %TIMER% EQU 267 (
	ECHO.3>TIME
	ECHO.Time: 3 AM
	BREAK>refresh
) ELSE IF %TIMER% EQU 356 (
	ECHO.4>TIME
	ECHO.Time: 4 AM
	BREAK>refresh
) ELSE IF %TIMER% EQU 445 (
	ECHO.5>TIME
	ECHO.Time: 5 AM
	BREAK>refresh
)

:: Send a "refesh animatronic movements" signal to the main game, only if needed (forced)
:FORCE_REFRESH
IF !SEND_BATTERY! LEQ 0 (
	TASKKILL /IM xcopy.exe /F >NUL 2>&1 && (
		ECHO. [Q] Events safely stopped.
		GOTO :AfterOutage
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
	IF !WIN! EQU 0 BREAK>WIN
	SET WIN=1
	TASKKILL /IM xcopy.exe /F || GOTO :FORCE_REFRESH_
	ENDLOCAL
	EXIT 0
)

:: ::::::::::::: ::
:: Random Sounds ::
SET /A RND_SFX=%RANDOM% %% 770 +1
IF !RND_SFX! EQU 1 START /B "" CMD /C CALL ".\audiomanager.cmd" START circus.mp3 sfx False 10 ^& EXIT >NUL 2>&1
SET /A RND_SFX=%RANDOM% %% 770 +1
IF !RND_SFX! EQU 1 START /B "" CMD /C CALL ".\audiomanager.cmd" START pirate_song2.mp3 sfx False 14 ^& EXIT >NUL 2>&1
SET /A RND_SFX=%RANDOM% %% 550 +1
IF !RND_SFX! EQU 1 IF NOT DEFINED PLAYED_BG (
	SET PLAYED_BG=1
	START /B "" CMD /C CALL ".\audiomanager.cmd" START EerieAmbienceLargeSca_MV005.mp3 sfx False 75 ^& EXIT >NUL 2>&1
)


:: :::::: ::
:: Timers ::
SET /A TIMER+=1
SET /A TIMER_FOXY+=1
TIMEOUT /T 1 /NOBREAK >NUL

:: Repeat
GOTO :TIMER



:AfterOutage
TIMEOUT /T 1 /NOBREAK >NUL

IF !TIMER! GEQ 534 (
	BREAK>WIN
	EXIT 0
)

ECHO.After Outage Timer: !TIMER!

:: Timers
SET /A TIMER+=1
GOTO :AfterOutage