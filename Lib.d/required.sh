#!/bin/bash

######################################
# required.sh
# Utilité: ce script est utisé par Data_Save.sh ainsi que SQL_Save.sh, vérifie la disponibilité des hotes
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/10/2016
######################################

Check_Remote_Host(){

    IP=$(cat "$PARTENAIRE/Partenaires" | grep $REMOTE_HOST| cut -d':' -f2)
    
    Res=$(traceroute $REMOTE_HOST | grep $IP | sed '1d')
    
    if [[ -z "$Res" ]]; then
        Res=$(traceroute $REMOTE_HOST -I | grep $IP | sed '1d')
    fi
    
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