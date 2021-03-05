if ($(Get-ScheduledTask -TaskName "SyncroRestart" -ErrorAction SilentlyContinue).TaskName -eq "SyncroRestart") {
    Unregister-ScheduledTask -TaskName "SyncroRestart" -Confirm:$False
}
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-command "Restart-Service -Name Syncro -Force; Restart-Service -Name SyncroLive -Force"'
$trigger =  New-ScheduledTaskTrigger -Daily -At 2am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "SyncroRestart" -Description "Daily Restart the Syncro Services" -RunLevel "Highest" -Force -User "System"