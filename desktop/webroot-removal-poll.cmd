REM Webroot removal script. Disable webroot from RMM and Webroot console. Run this script daily until Webroot is removed.
REM https://community.webroot.com/webroot-business-endpoint-protection-20/agent-uninstall-command-from-console-not-working-342910
if exist "%ProgramFiles(x86)%\Webroot\wrsa.exe" ( "%ProgramFiles(x86)%\Webroot\wrsa.exe" -poll )
if exist "%ProgramFiles%\Webroot\wrsa.exe" ( "%ProgramFiles%\Webroot\wrsa.exe" -poll )