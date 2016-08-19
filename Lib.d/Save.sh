#!/bin/bash

######################################
# Save.sh
# Utilité: ce script est utisé par Data_Save.sh
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 02/08/2016
######################################


Data_save(){

    case "$1" in

        "Journaliere")  EXPORT_NAME="Incremental_Backup_`date -d 'now' +%B`_Week_`date -d 'now' +\"%U\"`_$(date -d 'now' +%Y_%m_%d_%HH%M).tar.gz"
                Listed_Incremental="Backup_`date -d 'now' +%B`_Week_`date -d 'now' +\"%U\"`.list"
                TARGET="Heb"
                ;;
        "Hebdomadaire")  EXPORT_NAME="Full_Backup_`date -d 'now' +%B`_Week_`date -d 'now' +\"%U\"`.tar.gz"
                Listed_Incremental="Backup_`date -d 'now' +%B`_Week_`date -d 'now' +\"%U\"`.list"
                TARGET="Heb"
                ;;
        "Week-End" )  EXPORT_NAME="Incremental_Backup_`date -d 'now' +%B`_WeekEnd_`date -d 'now' +\"%U\"`.tar.gz"
                Listed_Incremental="Backup_`date -d 'now' +%B`.list"
                TARGET="Men"
                ;;
        "Mensuel")  EXPORT_NAME="Full_Backup_`date -d 'now' +%B`.tar.gz"
                Listed_Incremental="Backup_`date -d 'now' +%B`.list"
                TARGET="Men"
                ;;
    esac

    EXCLUDE_LIST=$(eval cat $EXCLUDE_LIST_PATH/ListExclude$TARGET)
    EXCLUDE=$(eval echo $EXCLUDE_LIST | sed "i--exclude=\\'" | tr -d '\n' | sed "s/\ \// --exclude=\\'\//g" | sed "s/\/ /\' /g")

    TAR_CMD="tar $EXCLUDE' -czf $EXPORT_PATH/$EXPORT_NAME --listed-incremental=$LISTED_INCREMENTAL_PATH/$Listed_Incremental $(echo -e "$(cat $SAVE_LIST_PATH/ListSave$TARGET)\n")"

    echo "" >> $LOG_PATH/Save.log
    echo "Sauvegarde en cours" >> $LOG_PATH/Save.log
    Time=$({ time $(eval $(echo $TAR_CMD));  } 2>&1 | grep real | cut -d 'l' -f2 | cut -c2-)
    echo "La sauvegarde a duree $Time" >> $LOG_PATH/Save.log
    echo "Sauvegarde terminé" >> $LOG_PATH/Save.log
    
    echo "" >> $LOG_PATH/Save.log
    echo -n "Le CheckSum de \"$EXPORT_NAME\" a sa création est : " >> $LOG_PATH/Save.log
    echo "$(cksum $EXPORT_PATH/$EXPORT_NAME | cut -d' ' -f1,2)" >> $LOG_PATH/Save.log
    echo "$(cksum $EXPORT_PATH/$EXPORT_NAME | cut -d' ' -f1,2)" > $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Local".cksum
    Export_save "$EXPORT_NAME" "$1"
    
}