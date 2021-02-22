REM Agressive webroot removal script. Disable webroot from RMM and Webroot console. Run this script every 15 minutes while user is away.
REM WARNING - Run this script OVERNIGHT ONLY as it will force reboot after 5 minutes.
REM https://community.webroot.com/webroot-business-endpoint-protection-20/agent-uninstall-command-from-console-not-working-342910
if exist "%ProgramFiles(x86)%\Webroot\wrsa.exe" (echo "Webroot found x86" && shutdown /r /t 300 && "%ProgramFiles(x86)%\Webroot\wrsa.exe" -poll )
if exist "%ProgramFiles%\Webroot\wrsa.exe" (echo "Webroot found x64" && shutdown /r /t 300 &&  "%ProgramFiles%\Webroot\wrsa.exe" -poll )