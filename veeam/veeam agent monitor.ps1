# Create a Syncro RMMAlert when a backup fails, set Backup Status to latest message. 
# Req Asset custom field "Backup Status". Must be run daily as the event log search is limited to 1 day back.
# Optional pass in $prev_status platform variable from {asset_custom_field_backup_status}
# Optional pass in $num_days runtime variable to allow a few days between backups for some machines. Default 4 days

if (Test-Path variable:$num_days) { $num_days = -5 }
if ($num_days -gt 0) { $num_days *= -1 }
Import-Module $env:SyncroModule

$event = Get-EventLog "Veeam Agent" -InstanceID 190 -newest 1
##$event = Get-EventLog "Veeam Agent" -newest 1 -After (Get-Date).AddDays(-1) | Where-Object {$_.EventID -eq 190}

if($event.entrytype -eq "Error") {
    write-host "Veeam Agent Error: $($event.message)"
    Rmm-Alert -Category "veeam_backup_failed" -Body "Veeam Backup Error: $($event.message)"
}

if ($event) {
    Set-Asset-Field -Name "Backup Status" -Value "$($event.timegenerated) $($event.entrytype) $($event.message)"
}

if ($prev_status) {
    $prev_date = [datetime]::parseexact($prev_status.substring(0, 10), 'MM/dd/yyyy', $null)
    if ($prev_date -lt (Get-Date).AddDays($num_days)) {
        write-host "Veeam Backup Missing Last backup: $($prev_status.substring(0, 10))"
        Rmm-Alert -Category "veeam_backup_failed" -Body "Veeam Backup Missing. Last backup: $($prev_status.substring(0, 10))"
    }
}
