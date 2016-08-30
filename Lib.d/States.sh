#!/bin/bash

######################################
# Save.sh
# Utilité: ce script est utisé par Data_Save.sh
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 02/08/2016
######################################

State_Save(){
    
    
    MonthSave=$(date +"%m_%B")
    DaySave=$(date +"%d")

    case "$1" in
        0)  echo "OK" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
        
        1)  echo "KO" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
        
        2)  echo "KT" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
        
        3)  echo "OK-NE" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
        
        4)  echo "PS" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;  
        
        5)  echo "SQL_OK" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
        
        6)  echo "SQL_KO" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;

        7)  echo "SQL_KT" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
        
        8)  echo "SQL_OK-NE" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
    esac
    
}

