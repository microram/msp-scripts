#!/bin/bash
# Backup pfSense routers and firewalls using wget
wget -qO- --keep-session-cookies --save-cookies cookies.txt \
  --no-check-certificate https://192.168.1.1/diag_backup.php \
  | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' > csrf.txt

wget -qO- --keep-session-cookies --load-cookies cookies.txt \
  --save-cookies cookies.txt --no-check-certificate \
  --post-data "login=Login&usernamefld=admin&passwordfld=Pa$$w0rd&__csrf_magic=$(cat csrf.txt)" \
  https://192.168.1.1/diag_backup.php  | grep "name='__csrf_magic'" \
  | sed 's/.*value="\(.*\)".*/\1/' > csrf2.txt

wget --keep-session-cookies --load-cookies cookies.txt --no-check-certificate \
  --post-data "Submit=download&donotbackuprrd=yes&__csrf_magic=$(head -n 1 csrf2.txt)" \
  https://192.168.1.1/diag_backup.php -O config-router-`date +%Y%m%d%H%M%S`.xml
