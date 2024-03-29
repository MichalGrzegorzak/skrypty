#==========================================================================================================================
# 
# This script restores a SQL Server databases hosted on a single SQL Server instance.
#
# Example usage:
#
# .\Restore-SQL-Server-Databases.ps1 -ServerName:"SERVER" -User:"User" -Pwd:"Password" -DBName:"MyDB1" -VersionNumber:"1.0"
#
#==========================================================================================================================

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

$BackupDevice = New-Object ("Microsoft.SqlServer.Management.Smo.BackupDeviceItem") ($BackupPath, "File")

$SMORestore = new-object("Microsoft.SqlServer.Management.Smo.Restore")
# settings for restore
$SMORestore.NoRecovery = $false;
$SMORestore.ReplaceDatabase = $true;
$SMORestore.Action = "Database" 
$SMORestore.Devices.Add($BackupDevice)  
$SMORestore.Database = $DBName

# Verify backup file
if (!$SMORestore.SqlVerify($server))
{ 
	throw "The backup set on file " + $BackupPath + " is invalid."
}

$Server.KillDatabase($DBName)
# Restore
$SMORestore.SqlRestore($server)
