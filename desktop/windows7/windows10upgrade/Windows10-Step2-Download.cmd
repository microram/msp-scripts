@echo off
:: Windows 10 Upgrade Step 2
set s3w=https://s3.us-east-2.wasabisys.com
set ariaopts=--dir=%temp% --quiet=true --continue=true --max-connection-per-server=4 --log=%temp%\aria2c.log

:: Download tools
if not exist %systemroot%\aria2c.exe ( bitsadmin /transfer S3 %s3b%/dl1/misc/64/aria2c.exe %systemroot%/aria2c.exe )
if not exist %systemroot%\aria2c.exe ( powershell -command "& { iwr %s3b%/dl-msp-tools.cmd -OutFile %systemroot%/aria2c.exe }" )

:: Download files
aria2c %s3w%/dl1/windows/Win10_1903_English_x64.zip %ariaopts%

:: UnZip Windows 10 X64 1903
mkdir c:\installs
mkdir c:\installs\Windows1903
"C:\Program Files\7-Zip\7z" x %temp%\Win10_1903_English_x64.zip -aoa -oc:\installs\Windows1903
