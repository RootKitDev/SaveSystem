#!/bin/bash

######################################
# Save.sh
# Utilité: ce script est utisé par Data_Save.sh
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/10/2016
######################################

State_Save(){
    
    
    MonthSave=$(date +"%m_%B")
    DaySave=$(date +"%d")

    case "$1" in
        0)  echo "OK" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
        
        1)  
            if [[ "$(cat "$SAVE_STATE_PATH/$MonthSave/$DaySave")" != "OK" ]]; then
                echo "KO" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            fi
            ;;
        
        2)  
            if [[ "$(cat "$SAVE_STATE_PATH/$MonthSave/$DaySave")" != "OK" ]]; then
                echo "KT" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            fi        
            ;;
        
        3)  
            if [[ "$(cat "$SAVE_STATE_PATH/$MonthSave/$DaySave")" != "OK" ]]; then
                echo "OK-NE" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            fi
            ;;
        
        4)  echo "PS" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;  
        
        5)  echo "SQL_OK" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            ;;
        
        6)  
            if [[ "$(cat "$SAVE_STATE_PATH/$MonthSave/$DaySave")" != "SQL_OK" ]]; then
                echo "SQL_KO" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            fi
            ;;
        7)  
            if [[ "$(cat "$SAVE_STATE_PATH/$MonthSave/$DaySave")" != "SQL_OK" ]]; then
                echo "SQL_KTT" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            fi
            ;;
        8)  
            if [[ "$(cat "$SAVE_STATE_PATH/$MonthSave/$DaySave")" != "SQL_OK" ]]; then
                echo "SQL_OK-NE" > $SAVE_STATE_PATH/$MonthSave/$DaySave
            fi
            ;;
    esac
    
}

