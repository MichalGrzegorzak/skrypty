#=========================================================================================================================
# 
# This script backs up a SQL Server database hosted on a single SQL Server instance.
#
# Example usage:
#
# .\Backup-SQL-Server-Databases.ps1 -ServerName:"SERVER" -User:"User" -Pwd:"Password" -DBName:"MyDB1" -VersionNumber:"1.0"
#
#=========================================================================================================================

# Parameter declarations

param 
(
[string]$ServerName = $(throw "Please specify the database server using the -ServerName switch."),
[string]$User = $(throw "Please specify the server username using the -User switch."),
[string]$Pwd = $(throw "Please specify the server password using the -Pwd switch."),
[string]$DBName = $(throw "Please specify the database name using the -DBName switch."),
#[string]$VersionNumber = $(throw "Please specify the version number using the -VersionNumber switch."),
[string]$SaveTo = $(throw "Please specify the path, where the file should be stored")
)

# Use SMO objects to allow remote backups

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null

# Get the DB connection

$ServerConn = New-Object Microsoft.SqlServer.Management.Common.ServerConnection
$ServerConn.ServerInstance = $ServerName
$ServerConn.LoginSecure = $false
$ServerConn.Login = $User
$ServerConn.Password = $Pwd

# Get the server reference and backup directory
$Server = New-Object Microsoft.SqlServer.Management.Smo.Server ($ServerConn)

#Create a file name based on the timestamp
$dt = get-date -format yyyy-MM-dd_HHmm
$BackupFileName = "{0}-{1}.bak" -f $DBName, $dt

#Version fileName
#$BackupFileName = "{0}-Pre-{1}.bak" -f $DBName, $VersionNumber.Replace(".", "-")
#$BackupDir = $Server.Settings.BackupDirectory
#$BackupPath = "{0}\{1}" -f $BackupDir, $BackupFileName

$BackupPath = "{0}\{1}" -f $SaveTo, $BackupFileName


# Back up using file naming convention
$DB = $Server.Databases[$DBName]
$SMOBackup = New-Object Microsoft.SqlServer.Management.Smo.Backup
$SMOBackup.Action = "Database"
$SMOBackup.BackupSetDescription = "Full Backup of {0} taken prior to the installation of version" -f $DB.Name
#$SMOBackup.BackupSetName = "Backup taken prior to version {0} install" -f $VersionNumber
$SMOBackup.Database = $DB.Name
$SMOBackup.MediaDescription = "Disk"
$SMOBackup.CompressionOption = 1;
$SMOBackup.Devices.AddDevice($BackupPath, "File")

$SMOBackup.SqlBackup($Server)


# Store backup name in config.ini (file & entry must be present)
$keyLastDB = "lastDBBackup"
$configFileName = "config.ini"

function Get-IniContent ($filePath)
{
    $ini = @{}
    switch -regex -file $FilePath
    {
        "(.+?)\s*=(.*)" # Key
        {
            $name,$value = $matches[1..2]
            $ini[$name] = $value
        }
    }
    return $ini
}

$iniContent = Get-IniContent $configFileName
$oldLine = $keyLastDB + "=" + $iniContent[$keyLastDB]
$newLine = $keyLastDB + "=" + $BackupPath

$newText =(gc $configFileName).Replace($oldLine, $newLine)
$newText > $configFileName
# END -> Store backup name in config.ini (file & entry must be present)