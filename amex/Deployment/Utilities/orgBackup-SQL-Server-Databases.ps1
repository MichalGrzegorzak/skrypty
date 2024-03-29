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
[string]$VersionNumber = $(throw "Please specify the version number using the -VersionNumber switch.")
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
$BackupDir = $Server.Settings.BackupDirectory
$BackupFileName = "{0}-Pre-{1}.bak" -f $DBName, $VersionNumber.Replace(".", "-")
$BackupPath = "{0}\{1}" -f $BackupDir, $BackupFileName

# Back up using file naming convention
$DB = $Server.Databases[$DBName]
$SMOBackup = New-Object Microsoft.SqlServer.Management.Smo.Backup
$SMOBackup.Action = "Database"
$SMOBackup.BackupSetDescription = "Full Backup of {0} taken prior to the installation of version {1}" -f $DB.Name, $VersionNumber
$SMOBackup.BackupSetName = "Backup taken prior to version {0} install" -f $VersionNumber
$SMOBackup.Database = $DB.Name
$SMOBackup.MediaDescription = "Disk"
$SMOBackup.Devices.AddDevice($BackupPath, "File")

$SMOBackup.SqlBackup($Server)
