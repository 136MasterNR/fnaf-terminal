GOTO :%1


:READ <"Path": String> ["Array Name": String]
SHIFT
SET FILE_PATH=%1
SET FILE_PATH=%FILE_PATH:"=%

FOR /F "TOKENS=1,*DELIMS==" %%1 IN ('TYPE "%FILE_PATH%"') DO SET %2[%%1]=%%2
EXIT /B 0
