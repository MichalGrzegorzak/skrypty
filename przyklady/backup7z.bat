set target=D:\Websites\Funeralcare\wwwroot\
set backupTo=d:\DeploymentPackages

For /f "tokens=1-4 delims=- " %%a in ('date /t') do (set mydate=%%a-%%b-%%c)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set datetime=%mydate%_%mytime%

7za a -tzip %backupTo%\bkp_FNC_%datetime%.zip %target%
pause
