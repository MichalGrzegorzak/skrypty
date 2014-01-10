@echo off
::--------------------------------------------------------
::-- GLOBAL PARAMS
::--------------------------------------------------------
set CONFIG="config.ini"

::--------------------------------------------------------
::-- START
::--------------------------------------------------------
setlocal

set "key=latestBackup"
call :readConfig %key% latestBackup
set "key=siteParentFolderLocation"
call :readConfig %key% siteParentFolderLocation

::call :wait 1
call :unpack %latestBackup% %siteParentFolderLocation%

pause
exit /b

::--------------------------------------------------------
::-- EXAMPLES
::--------------------------------------------------------
:: call :writeConfig propertyName propValue
:: call :readConfig propertyName result
:: echo propertyName value is %result%
::pause


::--------------------------------------------------------
::-- FUNCTIONS
::--------------------------------------------------------

:test
setlocal
set /a "sum=%1 + %CONFIG%, type=sum %% 2"
if %type%==0 (set "type=even") else (set "type=odd")
( endlocal
  set "%2=%sum%"
  set "%3=%type%"
)
exit /b

::--------------------------------------------------------

:unpack - (zipPath, outputPath)
setlocal
7za x -y %1  -o%2
echo Unpacked file=%1 to location=%2
exit /b

::--------------------------------------------------------

:pack - (zipPath, targetFolder)
setlocal
7za a -tzip %1 %2
echo Packed folder=%2 to file=%1
exit /b

::--------------------------------------------------------

:readConfig - (iniKey, return valaue)
setlocal

find "%1=" %CONFIG% | sort /r | date | find "=" > en#er.bat
echo set value=%%6> enter.bat
call en#er.bat
del en?er.bat > nul
( endlocal
  set "%2=%value%"
)
exit /b

::--------------------------------------------------------

:writeConfig - (key, value)
setlocal

rem Find & replace ini file value
type %CONFIG% | find /v "%1=" > config.tmp
copy /y config.tmp %CONFIG%
echo %1=%2>> %CONFIG%
rem cleanup
del config.tmp > nul

exit /b

::--------------------------------------------------------

:wait - (seconds)
setlocal
set /a "seconds = %1 * 1000"
echo Waiting %1 seconds
PING 1.1.1.1 -n 1 -w %seconds% >NUL
exit /b

::--------------------------------------------------------

::--------------------------------------------------------

::--------------------------------------------------------

