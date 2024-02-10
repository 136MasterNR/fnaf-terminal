@TITLE FNaF Events
@ECHO OFF
SET CNT=1
SET CHICA=0
SET BONNIE=0
SET FOXY=0

ECHO.MO: %CHICA% CHICA
ECHO.MO: %BONNIE% BONNIE

BREAK>MOVEMENTS.cmd

:: AI difficulty
SET MO_CHICA=0
SET MO_BONNIE=0
SET MO_FOXY=20

SETLOCAL ENABLEDELAYEDEXPANSION


:TIMER
TITLE FNaF Events - TIME: !CNT!

SET /A S_CALC=CNT %% 5

SET STATES=
SET /P STATES=<office_states
IF EXIST cams_state (
	SET /P CAMS_STATES=<cams_state
) ELSE SET CAMS_STATES=_

:: Increase MO based on the timer
REM IF !CNT! EQU 25 SET /A MO_BONNIE+=1 &:: 0.5 minutes in
REM IF !CNT! EQU 60 SET /A MO_CHICA+=1 &:: 1.0 minutes in
REM IF !CNT! EQU 150 SET /A MO_BONNIE+=1 &:: 2.5 minutes in
REM IF !CNT! EQU 300 SET /A MO_CHICA+=2 &:: 5 minutes in
REM IF !CNT! EQU 420 SET /A MO_CHICA+=1 &:: 7 minutes in
REM IF !CNT! EQU 450 SET /A MO_BONNIE+=2 &:: 7.5 minutes in

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
		IF !BONNIE! EQU 0 (
			SET /A BONNIE+=1
		) ELSE IF !BONNIE! EQU 3 (
			SET /A BONNIE=%RANDOM% %% 3 + 2
		) ELSE IF !BONNIE! EQU 4 (
			(ECHO.!STATES! | findstr /C:"doorL") >NUL && SET /A BONNIE=%RANDOM% %% 2 + 3 || SET /A BONNIE+=1
		) ELSE IF !BONNIE! EQU 5 (
			SET /A BONNIE+=1
		) ELSE (
			SET /A BONNIE+=1
		)
		IF !BONNIE! GEQ 5 (ECHO.!STATES! | findstr /C:"doorL") >NUL && SET /A BONNIE=%RANDOM% %% 3 + 1
		ECHO.MO: !BONNIE! BONNIE
		>refresh SET /P "=" <NUL
	)
)

:: Specifically for foxy
IF !S_CALC! EQU 0 (
	IF %FOXY% LSS 3 (
		SET /A "RND_FOXY=%RANDOM% %% 19 + 1"
		IF !RND_FOXY! LEQ !MO_FOXY! (
			IF NOT !CAMS_STATES!==_5 (
				SET /A FOXY+=1
				ECHO.MO: !FOXY! FOXY
				>refresh SET /P "=" <NUL
			)
		)
	) ELSE IF EXIST FOXY_SEEN (
		(ECHO.!STATES! | findstr /C:"doorL") >NUL && SET FOXY=0
		DEL /Q ".\FOXY_SEEN"
		>refresh SET /P "=" <NUL
	) ELSE (
		SET /A FOXY+=1
	)
)

:: Send the new movements to the main game
IF !S_CALC! EQU 0 (
		ECHO SET CHICA=!CHICA!
		ECHO SET BONNIE=!BONNIE!
		ECHO SET FOXY=!FOXY!
) >MOVEMENTS.cmd

:: Send a "refesh animatronic movements" signal to the main game, if needed (forced)
:FORCE_REFRESH
IF EXIST .\refresh (
	TASKKILL /IM xcopy.exe /F && DEL /Q .\refresh || GOTO :FORCE_REFRESH
)

:: If survived 530 seconds, send a "win" signal to the main game (forced)
:FORCE_REFRESH_
IF !CNT! GEQ 530 (
	IF NOT EXIST WIN BREAK>WIN
	TASKKILL /IM xcopy.exe /F || GOTO :FORCE_REFRESH_
	ENDLOCAL
	EXIT 0
)

:: Timer
SET /A CNT+=1
TIMEOUT /T 1 >NUL

:: Repeat
GOTO :TIMER
