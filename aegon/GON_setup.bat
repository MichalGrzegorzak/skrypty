rem Version 2.3
echo off
echo validating params...
IF "%1"=="" GOTO ERROR
IF "%2"=="" GOTO ERROR
IF "%3"=="" GOTO ERROR
IF "%4"=="" GOTO ERROR
IF "%5"=="" GOTO ERROR
IF "%6"=="" GOTO ERROR

rem Issue - static.aegon.local links on wrong folder

rem CONFIG
SET ADD_TO_HOSTS=true
SET CRETE_APP_POOL=true
SET LINK_TO_32bit=true
SET LINK_TO_64bit=false

cd c:
rem Initial create links required by static.aegon.local
echo Create links to Aegon website
junction virtual %VER%\Aegon.Public\Aegon.Public.Website
junction static %VER%\static

rem SYMLINKS FOR EPISERVER
IF NOT "%LINK_TO_32bit%"=="true" GOTO LINK_TO_64bits
echo Create simlink for 32-bits
junction "c:\Program Files\EPiServer" "c:\Program Files (x86)\EPiServer"
GOTO APPPOOL

:LINK_TO_64bits
IF NOT "%LINK_TO_64bit%"=="true" GOTO APPPOOL
echo Create simlink for 32-bits
mkdir "c:\Program Files (x86)"
junction "c:\Program Files (x86)\EPiServer" "c:\Program Files\EPiServer"

:APPPOOL
echo changing directory
cd C:\Windows\System32\inetsrv

IF NOT "%CRETE_APP_POOL%"=="true" GOTO WEBSITES
echo creating app pool
appcmd add apppool /name:aegon.%1 /managedPipelineMode:Integrated /managedRuntimeVersion:v4.0 /processModel.identityType:SpecificUser /processModel.userName:%4 /processModel.password:%5

:WEBSITES
echo creating websites
appcmd add site /name:__aegon.%1 /bindings:http://aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__slovakia.aegon.%1 /bindings:http://slovakia.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__czech.aegon.%1 /bindings:http://czech.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__aegoncan.aegon.%1 /bindings:http://aegoncan.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__sandbox.aegon.%1 /bindings:http://sandbox.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__turkey.aegon.%1 /bindings:http://turkey.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__germany.aegon.%1 /bindings:http://germany.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__poland.aegon.%1 /bindings:http://poland.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__spain.aegon.%1 /bindings:http://spain.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__agp.aegon.%1 /bindings:http://agp.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__aam.aegon.%1 /bindings:http://aam.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__aegoninvestments.aegon.%1 /bindings:http://aegoninvestments.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__aegonrealty.aegon.%1 /bindings:http://aegonrealty.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__webcommunity.aegon.%1 /bindings:http://webcommunity.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
echo creating new websites
appcmd add site /name:__romania.aegon.%1 /bindings:http://romania.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__bluesquare.aegon.%1 /bindings:http://bluesquare.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__ukraine.aegon.%1 /bindings:http://ukraine.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__tlbhk.aegon.%1 /bindings:http://tlbhk.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__tlbsg.aegon.%1 /bindings:http://tlbsg.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:__ireland.aegon.%1 /bindings:http://ireland.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2

rem SPECIFIC STATICS FILES
appcmd add site /name:__static.aegon.%1 /bindings:http://static.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%6

rem NOT FREQUENT SITES
rem appcmd add site /name:__vereniging.aegon.%1 /bindings:http://vereniging.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__admsasia.aegon.%1 /bindings:http://admsasia.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__admshkaffinity.aegon.%1 /bindings:http://admshkaffinity.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__admshk.aegon.%1 /bindings:http://admshk.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__admsau.aegon.%1 /bindings:http://admsau.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__admsth.aegon.%1 /bindings:http://admsth.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__admsjp.aegon.%1 /bindings:http://admsjp.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__admstw.aegon.%1 /bindings:http://admstw.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem UNUSED
rem appcmd add site /name:__japan.aegon.%1 /bindings:http://japan.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__admsin.aegon.%1 /bindings:http://admsin.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__france.aegon.%1 /bindings:http://france.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__belgium.aegon.%1 /bindings:http://belgium.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__italy.aegon.%1 /bindings:http://italy.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__brazil.aegon.%1 /bindings:http://brazil.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__china.aegon.%1 /bindings:http://china.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:__india.aegon.%1 /bindings:http://india.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2

IF NOT "%ADD_TO_HOSTS%"=="true" GOTO FINISH
echo Updating hosts file
echo.%3 aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 static.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 slovakia.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 sandbox.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 agp.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 czech.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 aegoncan.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 turkey.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 germany.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 aam.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 poland.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 webcommunity.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsasia.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 vereniging.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 aegoninvestments.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 aegonrealty.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admshk.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 france.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 spain.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsau.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsth.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsjp.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsin.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admstw.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admshkaffinity.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 romania.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 bluesquare.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 ukraine.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 tlbhk.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 tlbsg.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 ireland.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts

rem UNUSED
rem echo.%3 japan.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
rem echo.%3 belgium.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
rem echo.%3 italy.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
rem echo.%3 brazil.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
rem echo.%3 china.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
rem echo.%3 india.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts

GOTO FINISH

:ERROR
echo please use this batch file as AEGON_setup.bat URL_suffix WEBSITE_PATH IP_ADDRESS_FOR_HOSTFILE USER_NAME_FOR_APP_POOL PASSWORD_FOR_APP_POOL
echo EXAMPE: AEGON_setup.bat maintenance C:\websites\Aegon.Maintenance 127.0.0.1 FCUK.Local\Jaydeep.Jadeja TEST123

:FINISH
cd c:\PROJECTS\Aegon
Pause