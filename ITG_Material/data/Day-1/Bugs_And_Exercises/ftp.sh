#!/bin/sh
HOST='172.17.3.93'
USER='ftpuser'
PASSWD='ftpuser'
tar -zcf "archive-`date +"%m-%d-%Y"`.tar.gz" /home/itg5401/ftpsample
file=`ls | grep 'archive.*.tar.gz'`

ftp -inv $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
cd srikar
put $file
quit
END_SCRIPT
exit 0
