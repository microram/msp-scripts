::Batch script to run on Domain Controller / Standalone 2012/2016 Servers. Disable client time sync on ESXi.
:: Secondary DC use: w32tm /config /syncfromflags:domhier /update
:: Based on code from https://support.rbtechvt.com/knowledgebase/article/View/236/0/how-to-resolve-incorrect-time-with-windows-domain-controller-running-as-a-vmware-guest
:: and from here https://gooroo.io/GoorooTHINK/Article/17139/Configuring-Time-Settings-on-Domain-Controllers/26731
:: 2008 Servers see here https://support.microsoft.com/en-us/kb/816042
net stop w32time
w32tm /config /syncfromflags:manual /manualpeerlist:”0.pool.ntp.org, 1.pool.ntp.org, 2.pool.ntp.org”
w32tm /config /reliable:yes
net start w32time
w32tm /query /configuration
w32tm /resync