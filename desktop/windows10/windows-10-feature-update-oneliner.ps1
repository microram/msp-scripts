IWR https://go.microsoft.com/fwlink/?LinkID=799445 -OutFile $env:temp\wu.exe; Start-Process $env:temp\wu.exe -ArgumentList "/QuietInstall /skipeula /auto upgrade /Finalize"

#Invoke-WebRequest https://go.microsoft.com/fwlink/?LinkID=799445 -OutFile $env:temp\Win10Upgrade.exe; Start-Process -FilePath $env:temp\Win10Upgrade.exe -ArgumentList "/quietinstall /skipeula /auto upgrade /copylogs $($env:temp)"
