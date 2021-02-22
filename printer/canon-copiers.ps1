# Canon Copiers - Note downloads.canon.com is Akamai CDN. Upload a copy to your own server for alt download.
$printers = @( ("Canon IR6575", "192.168.1.100"),("Canon IRC7565 Color", "192.168.1.101"),("Canon IR6565", "192.168.1.102") )
cd $env:temp
$global:progressPreference = 'silentlyContinue' # Hide irw progress bar
try { Invoke-WebRequest -Uri https://downloads.canon.com/bicg2020/drivers/Generic_Plus_PCL6_v2.30_Set-up_x64.exe -OutFile $env:temp\Generic_Plus_PCL6_v2.30_Set-up_x64.exe } catch {
    try { Invoke-WebRequest -Uri https://example.com/Generic_Plus_PCL6_v2.30_Set-up_x64.exe -OutFile $env:temp\Generic_Plus_PCL6_v2.30_Set-up_x64.exe } catch {
        Write-Host "ERROR - Unable to download the printer driver."
        exit 1
    }
}

$hash = Get-FileHash .\Generic_Plus_PCL6_v2.30_Set-up_x64.exe
if ( $hash.Hash -ne "8A18551FCDAC697CBEE8E5E77AE8FEABB1D9FD9D77C27A2B1FB60FF7BE835688" )
{
    Write-Host "ERROR - File failed has verification."
    exit 1
}

# Decompress
Start-Process -Wait -WorkingDirectory $env:temp -FilePath "Generic_Plus_PCL6_v2.30_Set-up_x64.exe" -ArgumentList "-y"
# Install the INF file
Invoke-Command { pnputil -a .\Generic_Plus_PCL6_v2.30_Set-up_x64\Driver\CNP60MA64.INF }
# Add the driver
Add-PrinterDriver -Name "Canon Generic Plus PCL6"

foreach($printer in $printers)
{
    $portname = "IP_" + $printer[1]
    Write-Host 'Installing printer ' $printer[0] ' on IP:' $printer[1] ' port:' $portname
    # Remove old printer and port
    if (Get-Printer | Where-Object {$_.NAME -EQ $printer[0]}) { Remove-Printer -name $printer[0] }
    if (Get-PrinterPort | Where-Object {$_.NAME -EQ $portname}) { Remove-PrinterPort -name $portname }
    # Install new printer and port
    Add-PrinterPort -name $portname -printerhostaddress $printer[1]
    Add-Printer -name $printer[0] -port $portname -driver "Canon Generic Plus PCL6"
}
# Clean up
Remove-Item "Generic_Plus_PCL6_v2.30_Set-up_x64" -Recurse
Remove-Item "Generic_Plus_PCL6_v2.30_Set-up_x64.exe"