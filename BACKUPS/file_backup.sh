#!/bin/bash

# YOU CAN SET THIS BACKUP WITH ROOT USER

# THIS SCIPT MAKE BACKUP EVERY DAY IN ONE WEEK
# THIS SCRIPT WILL MANTEIN THE LAST WEK ENTIRE
# AND EVERY DAY 1 OF EVERY MONTH IN THE LAST YEAR

# YOU CAN CONFIGURE YOUR CRONTAB LIKE THIS
# 0 2 * * * /backup/file_backup.sh >> /var/log_file_backup.log
# EVERY DAY AT 2 AM

# FOLLOW THE FHS OF THIS BACKUP
#/backup/
#/backup/diary/
#/backup/weekly/
#/backup/monthly/
# REMEMBER TO CREATE THIS DIRECTORIES
# mkdir /backup/
# mkdir /backup/diary/
# mkdir /backup/weekly/
# mkdir /backup/monthly/
# AND REMEMBER THAT THE OWNER NEEDS TO BE postgres

DATE=`/bin/date +%d-%m-%Y,%A`
WEEK_DAY=`/bin/date +%a`
echo
echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo '@@   Backup fontes |'  $DATE
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

DATE=`/bin/date +%Y-%m-%d`


# BACKUP LOCAL

export WEEK_DAY=`/bin/date +%u`
export DAY=`/bin/date +%d`
export DAY_MES=`/bin/date +%d-%m`


cd /backup/diary/

rm -f backup$WEEK_DAY.tar


find /opt/venv/ -print > bkp_list.txt

tar -czf backup$WEEK_DAY.tar -T bkp_list.txt

#####################
## BACKUP weekly  ##
#####################

if [ "$WEEK_DAY" == "5" ]; then
echo 'doing backup weekly'
cp /backup/diary/backup$WEEK_DAY.tar  /backup/weekly/backup_$DATE.tar
fi

#####################
##  BACKUP monthly  ##
#####################


if [ "$DAY" == "01" ]; then
echo 'doing backup monthly'
cp /backup/diary/backup$WEEK_DAY.tar  /backup/monthly/backup_$DATE.tar
fi

#####################
##  BACKUP yearly   ##
#####################

if [ "$DAY_MES" == "01-01" ]; then
echo 'doing backup yearly'
cp /backup/diary/backup$WEEK_DAY.tar  /backup/yearly/backup_$DATE.tar
fi
