#==========================================================================================================
# Creates an full release package including installer and rollback script written to the specified location
#
# 1. Create package parameters and local paths from convention
# 2. MSBUILD for required environments
# 3. Create Environment aware Installers/Rollback scripts from templates
# 4. Zip full installer package into one zip file
# 5. Move Zip to package location if specified - otherwise will be written locally
#
# Creates Package with following convention
# > Utilities 	- Backup-SQL-Server-Databases.ps1
# 				- Restore-SQL-Server-Databases.ps1
# > Templates	- NetJets-Web-Installer-Template.ps1
#				- NetJets-Web-Rollback-Template.ps1
#
#
# ---------------------------------------------------
# Example usage:
#
# .\Create-Package.ps1 -ApplicationName:"Project-Web" -VersionNumber:"1.0" -PackageLocation:"C:\Releases"
#
#==========================================================================================================

# Parameter declarations
param 
(
[ValidateNotNullOrEmpty()]
[string]$ApplicationName = $(throw "Please specify the Application name using the -ApplicationName switch."),
[ValidateLength(3, 30)]
[string]$VersionNumber = $(throw "Please specify the application VersionNumber using the -VersionNumber switch."),
$PackageLocation
)

#================================================================
# 1. Create package parameters and local paths from convention
#================================================================

# Set Package name
$PackageName = $ApplicationName + "-" + $VersionNumber

# Get the current script directory and make it the working directory
$Invocation = (Get-Variable MyInvocation).Value 
$ScriptPath = Split-Path $Invocation.MyCommand.Path 
Set-Location $ScriptPath

# Create package folder named as version number
New-Item $VersionNumber -type directory

# Copy Utilities directory contents into package folder
New-Item $VersionNumber\Utilities -type directory
Copy-Item .\Utilities\*.ps1 .\$VersionNumber\Utilities

#=================================================================
# 2. Create UAT/Production package
#=================================================================

# Builds batch file run MSBuild 
Function CreateBuildPackage()
{
	#Get csproj build file for this project
	$ProjectFilePath = Get-Item ..\AmexMerchant.Web\AmexMerchant.Web.csproj
	$MSBuildPath = "C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
	
	#Check ASP.NET 4 is installed
	If ((Test-Path $MSBuildPath) -eq $false)
	{
		throw "ASP.NET 4.0 must be installed to create BuildPackages for this project"
	} 
	#Set Package Location path
	$LocalPackageLocation = "{0}\{1}\Package-{2}\{3}.zip" -f $ScriptPath, $VersionNumber, $PackageEnvironment, $ApplicationName
	# MSBuild arguments
	$BuildArgs ="/t:Package /p:PackageLocation=""{0}"" /p:Configuration={1}" -f $LocalPackageLocation, $PackageEnvironment
	
	#Full MSBuild command
	$MSBuildExecCommand = "{0} ""{1}"" {2}" -f $MSBuildPath, $ProjectFilePath, $BuildArgs
	
	# Hack - create bat file to run the MSBuild cmd
	Set-Content $PackageEnvironment-buildpackage.bat $MSBuildExecCommand
	# Run bat - file - no way of checking for build errors
	Start-Process -FilePath $PackageEnvironment-buildpackage.bat -Wait
	# Hack ensure Package is created - otherwise means build failed
	If ((Test-Path $LocalPackageLocation) -eq $false)
	{
		throw "MSBuild task failed. Are you sure the build will run locally?"
	} 
	#remove batch file
	Remove-Item $PackageEnvironment-buildpackage.bat
}

# Create Build package for UAT
$PackageEnvironment = "QA"
CreateBuildPackage
# Create Build package for Release
$PackageEnvironment = "Release"
CreateBuildPackage

#=======================================================================
# 3. Create Environment-aware Installers/Rollback scripts from templates
#=======================================================================
(Get-Content ./Templates/Installer-Template.txt) | Foreach-Object {$_ -replace "{{VersionNumber}}", $VersionNumber} | Foreach-Object {$_ -replace "{{ApplicationName}}", $ApplicationName} | Set-Content ($VersionNumber + "\\" + $PackageName + "-Installer.ps1")
(Get-Content ./Templates/Rollback-Template.txt) | Foreach-Object {$_ -replace "{{VersionNumber}}", $VersionNumber} | Foreach-Object {$_ -replace "{{ApplicationName}}", $ApplicationName} | Set-Content ($VersionNumber + "\\" + $PackageName + "-Rollback.ps1")

#============================================================================
# 4. Zip full package into one zip file - uses external Ionic.Zip.dll library
#============================================================================

# Add Reference to external zip library - http://dotnetzip.codeplex.com
[System.Reflection.Assembly]::LoadFrom($ScriptPath + "\\References\\Ionic.Zip.dll");

$ZipFileName = $ScriptPath + "\\" + $PackageName + ".zip"
$DirectoryToZip = $ScriptPath + "\\" + $VersionNumber

$ZipFile = new-object Ionic.Zip.ZipFile
$ZipFile.AddDirectory($DirectoryToZip, $PackageName)
$ZipFile.Save($ZipFileName)
$ZipFile.Dispose()

#=================================================================================
# 5. Move Zip to package location if specified - otherwise will be written locally
#=================================================================================
if ($PackageLocation)
{
	If ((Test-Path $PackageLocation) -eq $true)
	{
		Move-Item $ZipFileName $PackageLocation
		$FinalLocation = $PackageLocation
	}
	else
	{
		$FinalLocation = $ScriptPath
	}
}

$VersionFolder = "{0}\{1}" -f $ScriptPath, $VersionNumber
if ((Test-Path $VersionFolder) -eq $true)
{
	# Tidy up - remove local Package Folder
	Remove-Item -Path $VersionFolder -recurse
} 

# FINISHED
Write-Host -ForegroundColor Green "* ======================================================================" 
Write-Host -ForegroundColor Green "* CREATED DEPLOYMENT PACKAGE AT $FinalLocation"
Write-Host -ForegroundColor Green "* ======================================================================" 

# Set success exit code
exit 1

