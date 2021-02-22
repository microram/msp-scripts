# Brother laser printers
# Models: HL-L2310D,HL-L2325DW,HL-L2330D,HL-L2335D,HL-L2350DW,HL-L2357DW,HL-L2370DN,HL-L2370DW,HL-L2371DN,HL-L2375DW,HL-L2385DW,HL-B2000D,HL-B2050DN,HL-B2080DW,HL-2290,HL-2295D,HL-2590DN,HL-2595DW
# Note Upload a copy to your own server for alt download.
# -A -S -X -! -DC:\ -e -n -r
#"Brother HL-L2310D series" = BRSHL2310D17A.DSI,USBPRINT\BROTHERHL-L2310D_SER7315,BROTHERHL-L2310D_SER7315
#"Brother HL-L2325DW Printer" = BRSHL2325DW17A.DSI,USBPRINT\BROTHERHL-L2325DWB21B,BROTHERHL-L2325DWB21B
#"Brother HL-L2330D series" = BRSHL2330D17A.DSI,USBPRINT\BROTHERHL-L2330D_SERB9B4,BROTHERHL-L2330D_SERB9B4
#"Brother HL-L2335D series" = BRSHL2335D17A.DSI,USBPRINT\BROTHERHL-L2335D_SERE98B,BROTHERHL-L2335D_SERE98B
#"Brother HL-L2350DW series" = BRSHL2350DW17A.DSI,USBPRINT\BROTHERHL-L2350DW_SEAF7D,BROTHERHL-L2350DW_SEAF7D
#"Brother HL-L2357DW Printer" = BRSHL2357DW17A.DSI,USBPRINT\BROTHERHL-L2357DW06BB,BROTHERHL-L2357DW06BB
#"Brother HL-L2370DN series" = BRSHL2370DN17A.DSI,USBPRINT\BROTHERHL-L2370DN_SE71B7,BROTHERHL-L2370DN_SE71B7
#"Brother HL-L2370DW series" = BRSHL2370DW17A.DSI,USBPRINT\BROTHERHL-L2370DW_SE1776,BROTHERHL-L2370DW_SE1776
#"Brother HL-L2371DN Printer" = BRSHL2371DN17A.DSI,USBPRINT\BROTHERHL-L2371DN759B,BROTHERHL-L2371DN759B
#"Brother HL-L2375DW series" = BRSHL2375DW17A.DSI,USBPRINT\BROTHERHL-L2375DW_SE0766,BROTHERHL-L2375DW_SE0766
#"Brother HL-L2385DW series" = BRSHL2385DW17A.DSI,USBPRINT\BROTHERHL-L2385DW_SE1356,BROTHERHL-L2385DW_SE1356
#"Brother HL-B2000D series" = BRSHB2000D17A.DSI,USBPRINT\BROTHERHL-B2000D_SER7C5D,BROTHERHL-B2000D_SER7C5D
#"Brother HL-B2050DN series" = BRSHB2050DN17A.DSI,USBPRINT\BROTHERHL-B2050DN_SE03B7,BROTHERHL-B2050DN_SE03B7
#"Brother HL-B2080DW series" = BRSHB2080DW17A.DSI,USBPRINT\BROTHERHL-B2080DW_SEC94D,BROTHERHL-B2080DW_SEC94D
#"Brother HL-2290 Printer" = BRSH229017A.DSI,USBPRINT\BROTHERHL-2290EB3F,BROTHERHL-2290EB3F
#"Brother HL-2295D Printer" = BRSH2295D17A.DSI,USBPRINT\BROTHERHL-2295D73A8,BROTHERHL-2295D73A8
#"Brother HL-2590DN Printer" = BRSH2590DN17A.DSI,USBPRINT\BROTHERHL-2590DN4B57,BROTHERHL-2590DN4B57
#"Brother HL-2595DW Printer" = BRSH2595DW17A.DSI,USBPRINT\BROTHERHL-2595DW8286,BROTHERHL-2595DW8286


$printers = @( ("Brother HL-2350DW Main Floor", "192.168.1.100"),("Brother HL-2350DW 2nd Floor", "192.168.1.101"),("Brother HL-2350DW 3rd Floor", "192.168.1.102") )
#cd $env:temp
$global:progressPreference = 'silentlyContinue' # Hide irw progress bar
try { Invoke-WebRequest -Uri https://download.brother.com/welcome/dlf103395/Y17B_C1-hostm-160.EXE -OutFile $env:temp\Y17B_C1-hostm-160.EXE  } catch {
    try { Invoke-WebRequest -Uri https://example.com/Y17B_C1-hostm-160.EXE  -OutFile $env:temp\Y17B_C1-hostm-160.EXE  } catch {
        Write-Host "ERROR - Unable to download the printer driver."
        exit 1
    }
}

$hash = Get-FileHash $env:temp\Y17B_C1-hostm-160.EXE
if ( $hash.Hash -ne "9FE63E2705AA3A0934CCE3D128407885AA499096BE3D34C0B56996B00CEE350B" )
{
    Write-Host "ERROR - File failed has verification."
    exit 1
}

# Decompress
Start-Process -Wait -WorkingDirectory $env:temp -FilePath "$env:temp\Y17B_C1-hostm-160.EXE" -ArgumentList "-r -d$env:temp\brother"

# Install the INF file
$pnpcmd = "pnputil -a $env:temp\brother\gdi\BROHL17A.INF" 
Invoke-Command { $pnpcmd }

# Add the driver
Add-PrinterDriver -Name "Brother HL-L2330D series"

foreach($printer in $printers)
{
    $portname = "IP_" + $printer[1]
    Write-Host 'Installing printer ' $printer[0] ' on IP:' $printer[1] ' port:' $portname
    # Remove old printer and port
    if (Get-Printer | Where-Object {$_.NAME -EQ $printer[0]}) { Remove-Printer -name $printer[0] }
    if (Get-PrinterPort | Where-Object {$_.NAME -EQ $portname}) { Remove-PrinterPort -name $portname }
    # Install new printer and port
    Add-PrinterPort -name $portname -printerhostaddress $printer[1]
    Add-Printer -name $printer[0] -port $portname -driver "Brother HL-L2330D series"
}
# Clean up
#Remove-Item "$env:temp\brother" -Recurse
#Remove-Item "$env:temp\Y17B_C1-hostm-160.EXE"