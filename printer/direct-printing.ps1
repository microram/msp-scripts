## Loop through all printers and set to direct printing (-direct to reverse)
$Printers = Get-Printer
foreach ($Printer in $Printers){
    $cmd = 'printui.dll,PrintUIEntry /Xs /n "' + $Printer.Name + '" attributes +direct'
    Write-Host $cmd
    Start-Process -Filepath C:\Windows\System32\rundll32.exe -ArgumentList $cmd -WorkingDirectory C:\Windows\System32
}