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
appcmd add site /name:aegon.%1 /bindings:http://aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:slovakia.aegon.%1 /bindings:http://slovakia.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:admshkaffinity.aegon.%1 /bindings:http://admshkaffinity.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:sandbox.aegon.%1 /bindings:http://sandbox.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:czech.aegon.%1 /bindings:http://czech.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:aegoncan.aegon.%1 /bindings:http://aegoncan.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:agp.aegon.%1 /bindings:http://agp.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:turkey.aegon.%1 /bindings:http://turkey.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:germany.aegon.%1 /bindings:http://germany.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:poland.aegon.%1 /bindings:http://poland.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:spain.aegon.%1 /bindings:http://spain.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2

appcmd add site /name:aam.aegon.%1 /bindings:http://aam.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:admsasia.aegon.%1 /bindings:http://admsasia.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:vereniging.aegon.%1 /bindings:http://vereniging.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:aegoninvestments.aegon.%1 /bindings:http://aegoninvestments.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:aegonrealty.aegon.%1 /bindings:http://aegonrealty.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:admshk.aegon.%1 /bindings:http://admshk.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:webcommunity.aegon.%1 /bindings:http://webcommunity.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:admsau.aegon.%1 /bindings:http://admsau.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:admsth.aegon.%1 /bindings:http://admsth.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:admsjp.aegon.%1 /bindings:http://admsjp.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:admsin.aegon.%1 /bindings:http://admsin.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
appcmd add site /name:admstw.aegon.%1 /bindings:http://admstw.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2

rem SPECIAL TRETMENT FOR STATIC
appcmd add site /name:static.aegon.%1 /bindings:http://static.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%6

rem UNUSED
appcmd add site /name:japan.aegon.%1 /bindings:http://japan.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:france.aegon.%1 /bindings:http://france.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:belgium.aegon.%1 /bindings:http://belgium.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:italy.aegon.%1 /bindings:http://italy.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:brazil.aegon.%1 /bindings:http://brazil.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:china.aegon.%1 /bindings:http://china.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2
rem appcmd add site /name:india.aegon.%1 /bindings:http://india.aegon.%1:80 /applicationDefaults.applicationPool:aegon.%1 /physicalPath:%2

IF NOT "%ADD_TO_HOSTS%"=="true" GOTO FINISH
echo Updating hosts file
echo.%3 aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 static.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts

echo.%3 japan.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 czech.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 aegoncan.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsasia.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 vereniging.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 aegoninvestments.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 aegonrealty.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 agp.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 turkey.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 germany.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 aam.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 poland.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admshk.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 france.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 webcommunity.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 spain.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsau.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsth.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsjp.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admsin.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admstw.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 slovakia.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 admshkaffinity.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts
echo.%3 sandbox.aegon.%1 >> c:\Windows\System32\drivers\etc\hosts

rem UNUSED
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