#!/bin/bash

######################################
# required.sh
# Utilité: ce script est utisé par Data_Save.sh ainsi que SQL_Save.sh, vérifie la disponibilité des hotes
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 01/08/2016
######################################

Check_Remote_Host(){

    Res=$(traceroute $REMOTE_HOST | grep "$(nslookup $REMOTE_HOST | grep Address | sed '1d' | cut -d' ' -f2)" | sed '1d')
    echo "" >> $LOG_PATH/Save$SUB_LOG.log
    
    if [[ -z "$Res" ]]; then
        echo "L'hôte $REMOTE_HOST est injoignable" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Transfert annulé" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Merci de réaliser le transfert manuellement" >> $LOG_PATH/Save$SUB_LOG.log
        State_Save 2
        echo 1
    else
        echo "L'hôte $REMOTE_HOST est joignable" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Lancement du transfert vers $REMOTE_HOST" >> $LOG_PATH/Save$SUB_LOG.log
        echo 0
    fi
}