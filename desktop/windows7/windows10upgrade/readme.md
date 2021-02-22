### Disable Webroot

Webroot has been known to block Windows 10 upgrade
- Disable Webroot AV from RMM
- Disable Webroot AV from Webroot console
- Run the polling script on 15 min intervals for up to 24 hours or uninstall manually with the next command
- Uninstall Webroot AV from Run prompt. Works in SAFE and Normal Windows mode. "C:\Program Files (x86)\Webroot\WRSA.exe" –uninstall

### Scripts

 - Script Windows10-Step-1-Prep Run as many times as needed (1-4 common). Expect timeouts ~15min. Reboot After each run. 
 - Script Windows10-Step-2-Download <15min on cable modem. Downloads our cached copy of 1903. 1903 still has the silent and ignore modes. 1909 broke something here. Wait to upgrade to 1909 until after 1903 is up.
- Run C:\install\setup.exe. Next, Accept, DON'T CLICK INSTALL at Ready to Install screen. RED X to Close. Clean up any incompatible issues and re-run until you get a Ready to install screen. But don't actually proceed. Stop and use the script next.
- Script Windows10-Step-3-Install (~25 minutes on a 4th Gen Intel. 60-90min on Core2Duo)

### Post Windows 10 1903

- Delete Temp files can be 40-50GB. Settings search for "delete temp". Click on Temporary files. Purge away.
- Delete the C:\Installs folder
- Run updates