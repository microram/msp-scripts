REM Hide D: & E: drive letters. Usually these are recovery & diagnostic partitions that users don't need to see.
REM Partitions are NOT deleted. Only removes the drive letter designations. Can be restored via disk managment.
echo select disk 0 > diskpart.txt
echo list partition >> diskpart.txt
echo list volume >> diskpart.txt
echo select volume 2 >> diskpart.txt
echo remove letter=d >> diskpart.txt
diskpart /s diskpart.txt > diskpart_log.txt

echo select disk 0 > diskpart.txt
echo select volume 3 >> diskpart.txt
echo remove letter=d >> diskpart.txt
diskpart /s diskpart.txt >> diskpart_log.txt

echo select disk 0 > diskpart.txt
echo select volume 3 >> diskpart.txt
echo remove letter=e >> diskpart.txt
diskpart /s diskpart.txt >> diskpart_log.txt

echo select disk 0 > diskpart.txt
echo select volume 4 >> diskpart.txt
echo remove letter=e >> diskpart.txt
diskpart /s diskpart.txt >> diskpart_log.txt

echo select disk 0 > diskpart.txt
echo list partition >> diskpart.txt
echo list volume >> diskpart.txt
diskpart /s diskpart.txt >> diskpart_log.txt
