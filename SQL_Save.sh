#! /bin/bash


######################################
# SQL_Save.sh
# Utilité: ce script sert à faire des sauvegardes SQL de façon dynamique
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/10/2016
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

HOME_PATH="/home/backup"

LIB_PATH="$HOME_PATH/Lib.d"

SUB_LOG="_SQL"

# Load Var lib, for all var path (log, flag, ...)
source $LIB_PATH/Var.sh

# Load all the others .sh lib
source $LIB_PATH/Save_SQL.sh
source $LIB_PATH/Export.sh
source $LIB_PATH/required.sh
source $LIB_PATH/Check_Sum.sh
source $LIB_PATH/States.sh

MonthSave=$(date +"%m_%B")
DaySave=$(date +"%d")

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

echo "" >> $LOG_PATH/Save.log
echo "Arret de MySQL" >> $LOG_PATH/Save.log

# Launch SQL Save
SQL_save "all"

echo "" >> $LOG_PATH/Save_SQL.log
echo "" >> $LOG_PATH/Save.log
echo "Fin du script $0" >> $LOG_PATH/Save.log
echo "Fin du script $0" >> $LOG_PATH/Save_SQL.log