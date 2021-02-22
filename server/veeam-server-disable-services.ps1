# Run this script to shudown all Veeam services before installing an upgrade
$servicelist = @("VeeamBackupSvc", "VeeamFilesysVssSvc", "VeeamBrokerSvc", "VeeamCloudSvc", "VeeamGateSvc", "VeeamTransportSvc", "VeeamDistributionSvc", "VeeamCatalogSvc", "VeeamDeploySvc","VeeamMountSvc", "VeeamNFSSvc")

Write-Host "Checking Veeam Service Status..."
$VeeamService = Get-Service -Name "VeeamBackupSvc" | Select-Object "Status"
if ($VeeamService.Status -eq "Running")
{
    Write-Host "Disabling: " -NoNewline
    foreach ($service in $servicelist) {
        Write-Host "$service " -NoNewline
	    Stop-Service -Name $service -Force
	    Set-Service -Name $service -StartupType Disabled
    }
    Write-Host "DONE."
    Restart-Computer -Confirm
}
else
{
    Write-Host "Veeam Backup Service is not running. No changes made."
}