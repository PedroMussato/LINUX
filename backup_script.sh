#!/bin/bash


#ORIGIN: The source directory or location from which the backup will be created.
ORIGIN=
#BACKUP_NAME: The name to be given to the backup file.
BACKUP_NAME=
#DAILY_BACKUP_DESTINATION: The destination directory where the daily backups will be stored.
DAILY_BACKUP_DESTINATION=
#WEEKLY_BACKUP_DESTINATION: The destination directory where the weekly backups will be stored.
WEEKLY_BACKUP_DESTINATION=
#MONTHLY_BACKUP_DESTINATION: The destination directory where the monthly backups will be stored.
MONTHLY_BACKUP_DESTINATION=
#YEARLY_BACKUP_DESTINATION: The destination directory where the yearly backup will be stored.
YEARLY_BACKUP_DESTINATION=

DATA=$(/bin/date +%d-%m-%Y,%A)
WEEKDAY=$(/bin/date +%a)
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo '@@   Backup  |'  $DATA
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
export WEEKDAY=$(/bin/date +%u)
export DAY=$(/bin/date +%d)
export DAY_MONTH=$(/bin/date +%d-%m)

# REMOVING PREVIOUS WEEK'S BACKUP, IF EXISTS
rm -f $DAILY_BACKUP_DESTINATION/$BACKUP_NAME-$WEEKDAY.tar.gz
# LOCAL BACKUP
tar -czf $DAILY_BACKUP_DESTINATION/$BACKUP_NAME-$WEEKDAY.tar.gz $ORIGIN

#####################
## WEEKLY BACKUP  ##
#####################
# WEEKDAY 0 - SUNDAY
if [ "$WEEKDAY" == "0" ]; then
    echo 'SAVING SUNDAY BACKUP'
    cp $DAILY_BACKUP_DESTINATION/$BACKUP_NAME-$WEEKDAY.tar.gz $WEEKLY_BACKUP_DESTINATION/$BACKUP_NAME-$DATA.tar.gz
fi

#####################
## MONTHLY BACKUP  ##
#####################
if [ "$DAY" == "01" ]; then
    echo 'SAVING BEGINNING OF MONTH BACKUP'
    cp $DAILY_BACKUP_DESTINATION/$BACKUP_NAME-$WEEKDAY.tar.gz $MONTHLY_BACKUP_DESTINATION/$BACKUP_NAME-$DATA.tar.gz
fi

#####################
## YEARLY BACKUP   ##
#####################
if [ "$DAY_MONTH" == "01-01" ]; then
    echo 'SAVING BEGINNING OF YEAR BACKUP'
    cp $DAILY_BACKUP_DESTINATION/$BACKUP_NAME-$WEEKDAY.tar.gz $YEARLY_BACKUP_DESTINATION/$BACKUP_NAME-$DATA.tar.gz
fi
