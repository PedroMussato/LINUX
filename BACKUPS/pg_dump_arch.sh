#!/bin/bash


# THIS SCIPT MAKE BACKUP EVERY DAY IN ONE WEEK
# THIS SCRIPT WILL MANTEIN THE LAST WEK ENTIRE
# AND EVERY DAY 1 OF EVERY MONTH IN THE LAST YEAR

# YOU CAN CONFIGURE YOUR CRONTAB LIKE THIS
# 30 2 * * * /pg_dmps/mk_dmp.sh >> /var/log_pg_dmp.log
# EVERY DAY AT 2:30 AM

# CONFIGURE THA BACKUP ON postgres USER CONTRAB

# FOLLOW THE FHS OF THIS BACKUP
#/pg_dmps/
#/pg_dmps/diary/
#/pg_dmps/weekly/
#/pg_dmps/monthly/
# REMEMBER TO CREATE THIS DIRECTORIES
# mkdir /pg_dmps/
# mkdir /pg_dmps/diary/
# mkdir /pg_dmps/weekly/
# mkdir /pg_dmps/monthly/
# AND REMEMBER THAT THE OWNER NEEDS TO BE postgres
# CHOWN postgres:postgres -R /pg_dmps/


export LANG="pt_BR.UTF-8"

DATE=`/bin/date +%d-%m-%Y,%A`
WEEK_DAY=`/bin/date +%a`
echo
echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo '@@   Backup |'  $DATE
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

DATE=`/bin/date +%Y-%m-%d`

# LOCAL BACKUP

export WEEK_DAY=`/bin/date +%u`
export DAY=`/bin/date +%d`
export MONTH_DAY=`/bin/date +%d-%m`


cd /pg_dmps/diary/

rm -f pg_dmp$WEEK_DAY.sql

/usr/bin/pg_dump database > /pg_dmps/diary/database_dump_$WEEK_DAY.sql

#####################
## WEEK BACKUP  ##
#####################

if [ "$WEEK_DAY" == "5" ]; then
echo 'DOING WEEK BACKUP'
cp /pg_dmps/diary/database_dump_$WEEK_DAY.sql /pg_dmps/weekly/database_dump_$DATE.tar
fi

#####################
##  MONTH BACKUP  ##
#####################


if [ "$DAY" == "01" ]; then
echo 'DOING MONTH BACKUP'
cp /pg_dmps/diary/database_dump_$WEEK_DAY.sql /pg_dmps/monthly/database_dump_$DATE.tar
fi

#####################
##  YEAR BACKUP   ##
#####################

if [ "$MONTH_DAY" == "01-01" ]; then
echo 'DOING YEAR BACKUP'
cp /pg_dmps/diary/database_dump_$WEEK_DAY.sql /pg_dmps/anual/database_dump_$DATE.tar
fi
