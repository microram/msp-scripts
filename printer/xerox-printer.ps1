# Xerox Printers - Upload a copy to your own server for alt download.
## https://download.support.xerox.com/pub/drivers/GLOBALPRINTDRIVER/drivers/win10x64/ar/UNIV_5.759.5.0_PCL6_x64.zip 9E571307D6FE87A5EB70E7F4F21F7BF35087198E1CF21D1DD08485A3A0097A26
## https://download.support.xerox.com/pub/drivers/GLOBALPRINTDRIVER/drivers/win10x64/ar/UNIV_5.759.5.0_PS_x64.zip FAB315882F9CD20D62D25705FB9CC9E29C8983FD2796DFBA28453D65AF30024A
$printers = @(, ("Xerox Phaser", "192.168.1.102") )
cd $env:temp
$global:progressPreference = 'silentlyContinue' # Hide irw progress bar
try { Invoke-WebRequest -Uri https://download.support.xerox.com/pub/drivers/GLOBALPRINTDRIVER/drivers/win10x64/ar/UNIV_5.759.5.0_PS_x64.zip -OutFile $env:temp\UNIV_5.759.5.0_PS_x64.zip } catch {
    try { Invoke-WebRequest -Uri https://download.support.xerox.com/pub/drivers/GLOBALPRINTDRIVER/drivers/win10x64/ar/UNIV_5.759.5.0_PS_x64.zip -OutFile $env:temp\UNIV_5.759.5.0_PS_x64.zip } catch {
        Write-Host "ERROR - Unable to download the printer driver."
        exit 1
    }
}

$hash = Get-FileHash .\UNIV_5.759.5.0_PS_x64.zip
if ( $hash.Hash -ne "FAB315882F9CD20D62D25705FB9CC9E29C8983FD2796DFBA28453D65AF30024A" )
{
    Write-Host "ERROR - File failed has verification."
    exit 1
}

# Decompress
Expand-Archive $env:temp\UNIV_5.759.5.0_PS_x64.zip -DestinationPath $env:temp\UNIV_5.759.5.0_PS_x64\ -Force
# Install the INF file
Invoke-Command { pnputil -a $env:temp\UNIV_5.759.5.0_PS_x64\UNIV_5.759.5.0_PS_x64_Driver.inf\x3UNIVP.inf }
# Add the driver
Add-PrinterDriver -Name "Xerox Global Print Driver PS"

foreach($printer in $printers)
{
    $portname = "IP_" + $printer[1]
    Write-Host 'Installing printer ' $printer[0] ' on IP:' $printer[1] ' port:' $portname
    # Remove old printer and port
    if (Get-Printer | Where-Object {$_.NAME -EQ $printer[0]}) { Remove-Printer -name $printer[0] }
    if (Get-PrinterPort | Where-Object {$_.NAME -EQ $portname}) { Remove-PrinterPort -name $portname }
    # Install new printer and port
    Add-PrinterPort -name $portname -printerhostaddress $printer[1]
    Add-Printer -name $printer[0] -port $portname -driver "Xerox Global Print Driver PS"
}
# Clean up
Remove-Item "UNIV_5.759.5.0_PS_x64" -Recurse
Remove-Item "UNIV_5.759.5.0_PS_x64.zip"