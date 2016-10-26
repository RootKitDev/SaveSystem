#!/bin/bash

######################################
# Save_SQL.sh
# Utilité: ce script est utisé par SQL_Save.sh
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/10/2016
######################################


SQL_save(){
    echo "" >> $LOG_PATH/Save_SQL.log
    if [[ -z $1 ]]
    then
        echo "Aucune base n'a ete fournis" >> $LOG_PATH/Save_SQL.log
    else
        databases=$(echo 'show databases' | mysql --defaults-extra-file=/etc/mysql/user.cnf | grep -v -E '(information_schema|performance_schema|Database)')

        for database in ${databases[@]}
        do
            echo "dump : $database" >> $LOG_PATH/Save_SQL.log
            echo "Dump en cours" >> $LOG_PATH/Save_SQL.log
            
            SQL_DUMP_CMD="mysqldump --defaults-extra-file=/etc/mysql/user.cnf --quick --add-locks --lock-tables --extended-insert '$database' > $EXPORT_PATH/${database}_dump.sql"
    
            Time=$({ time $(eval $(echo $SQL_DUMP_CMD));
            $(tar -czf $EXPORT_PATH/${database}_export_$(date -d "now" +%Y_%m_%d_%HH%M).tar.gz $EXPORT_PATH/{$database}_dump.sql);
            $(rm "$EXPORT_PATH/"$database"_dump.sql");} 2>&1 | grep real | cut -d 'l' -f2 | cut -c2-)
    
            echo "Le Dump de la base $database a dure $Time" >> $LOG_PATH/Save_SQL.log
            
            File_Name="$(ls $EXPORT_PATH | grep $database)"
            
            if [[ -f $EXPORT_PATH/$File_Name ]];
            then
                echo "Dump fini avec succes" >> $LOG_PATH/Save_SQL.log
                echo -n "Le fichier $File_Name disponible, acet emplacement "$EXPORT_PATH >> $LOG_PATH/Save_SQL.log
                
                echo "" >> $LOG_PATH/Save_SQL.log
                echo -n "Le CheckSum de \"$database\" a sa création est : " >> $LOG_PATH/Save_SQL.log
                echo "$(cksum $EXPORT_PATH/$File_Name | cut -d' ' -f1,2)" >> $LOG_PATH/Save_SQL.log
                echo "$(cksum $EXPORT_PATH/$File_Name | cut -d' ' -f1,2)" > $EXPORT_CKSUM_PATH"/"$database"_"$(date -d 'now' +%Y_%m_%d)"_Local".cksum
                Export_save $File_Name $database

            else
                echo "Des erreurs ont été detectees :" >> $LOG_PATH/Save_SQL.log
                echo "Le fichier $File_Name introuvable !" >> $LOG_PATH/Save_SQL.log
                echo "" >> $LOG_PATH/Save_SQL.log
                State_Save 6

            fi
            
        done
    fi
}