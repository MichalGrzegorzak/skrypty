#==========================================================================================================
# Writes to the System Application Event Log
#
# 1. Register Eevnt/Application with Windows Event Log System
# 2. Write to Log uing supplied parameters
#
# 		EventId 666 = deployment
# 		EventId 667 = rollback
#
# ---------------------------------------------------
# Example usage:
#
# .\Write-EventLog.ps1 -ApplicationName:"Project-Web" -Message:"Message to event log" -EventId:999
#
#==========================================================================================================

# Parameter declarations
param 
(
[ValidateNotNullOrEmpty()]
[string]$ApplicationName = $(throw "Please specify the Application name using the -ApplicationName switch."),
[int]$EventId = $(throw "Please specify the event Id you wish to log using the -EventId switch."),
[ValidateLength(3, 30)]
[string]$VersionNumber = $(throw "Please specify the VersionNumber using the -VersionNumber switch.")
)

if(![System.Diagnostics.EventLog]::SourceExists($ApplicationName))
{
	New-EventLog Application $ApplicationName
}

if ($EventId.Equals(666))
{
	$Message = "Application {0}-{1} was installed" -f $ApplicationName, $VersionNumber
}
if ($EventId.Equals(667))
{
	$Message = "Application {0} was rolled back to version {1}" -f $ApplicationName, $VersionNumber
}

write-eventlog Application -Source $ApplicationName -EventId $EventId -EntryType Information -Message $Message
