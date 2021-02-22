@echo off
c:
cd \installs\Windows1903
start /wait setup.exe /auto upgrade /Compat IgnoreWarning /installfrom C:\installs\Windows1903\sources\install.esd /dynamicupdate disable /showoobe none /quiet