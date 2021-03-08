$SafeVersions = "15.2.792.10","15.2.721.13","15.1.2176.9","15.1.2106.13","15.0.1497.12","14.3.513.0"
$Version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$($ENV:ExchangeInstallPath)\bin\Exsetup.exe").FileVersion
if($version -notin $SafeVersions){ write-host "Patch not installed succesfully. Server must be patched."}