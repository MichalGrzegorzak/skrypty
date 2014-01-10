SET VER=Sprint9

SET STATIC=true
SET CLEAR_CACHE=false
SET REPLACE_FILES=true
SET START_VS=true

iisreset /stop
del current_is_*

echo Create link to Aegon website
junction -d virtual 
junction virtual %VER%\Aegon.Public\Aegon.Public.Website

IF NOT "%STATIC%"=="true" GOTO REPLACE_FILES
echo Create link to static folder
junction -d static
junction static %VER%\static

:REPLACE_FILES
IF NOT "%REPLACE_FILES%"=="true" GOTO CLEAR_CACHE
echo Replacing license file
copy /y replace\*.config virtual\*.*

:CLEAR_CACHE
IF NOT "%CLEAR_CACHE%"=="true" GOTO VERSION
echo Clear Firefox Cache (http://www.catonmat.net/blog/clear-privacy-ie-firefox-opera-chrome-safari/)
set DataDir=C:\Users\%USERNAME%\AppData\Local\Mozilla\Firefox\Profiles
del /q /s /f "%DataDir%"
rd /s /q "%DataDir%"
for /d %%x in (C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles\*) do del /q /s /f %%x\*sqlite

:VERSION
echo Creating a new version..
echo %VER% >> current_is_%VER%
iisreset /start

:START_VS
echo Starting Visual Studio
IF NOT "%START_VS%"=="true" GOTO END
start "" "%CD%\%VER%\Solution Files\Aegon.Public2.sln"

:END
pause

