REM Delete CBS Log files on Windows 7
net stop TrustedInstaller
cmd /k echo y | del C:\Windows\Logs\CBS\*.* /s
net start TrustedInstaller