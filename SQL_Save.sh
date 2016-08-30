#! /bin/bash


######################################
# SQL_Save.sh
# Utilité: ce script sert à faire des sauvegardes SQL de façon dynamique
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 01/08/2016
######################################

# Verbose mode
for param in $@
do
        if [ $param = "-v" ]
        then
    		set -vx            
        fi
done

# Define PATH
HOME_PATH=""
LOG_PATH=""

LIB_PATH=""

EXPORT_PATH=""
EXPORT_CKSUM_PATH=""

REMOTE_EXPORT_PATH=""

SAVE_STATE_PATH=""

SUB_LOG=""

# Load all .sh lib, using source command
source $LIB_PATH/Save_SQL.sh
source $LIB_PATH/Export.sh
source $LIB_PATH/required.sh
source $LIB_PATH/Check_Sum.sh
source $LIB_PATH/States.sh

echo "EC" > $SAVE_STATE_PATH/$MonthSave/$DaySave

# Writing in the early log
echo "" >> $LOG_PATH/Save_SQL.log
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save_SQL.log
echo `date` >> $LOG_PATH/Save_SQL.log

echo "" >> $LOG_PATH/Save.log
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save.log
echo `date` >> $LOG_PATH/Save.log
echo "Sauvegarde SQL" >> $LOG_PATH/Save.log
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save.log

echo 'Sauvegarde SQL Week-End (Sauvegarde Full de chaque base)' >> $LOG_PATH/Save.log

# Launch SQL Save
SQL_save "all"

echo "" >> $LOG_PATH/Save_SQL.log
echo "" >> $LOG_PATH/Save.log
echo "Fin du script $0" >> $LOG_PATH/Save.log
echo "Fin du script $0" >> $LOG_PATH/Save_SQL.log