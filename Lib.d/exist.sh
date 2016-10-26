#!/bin/bash

######################################
# exist.sh
# Utilité: ce script est utisé par Data_Save.sh, vérifé l'éligibilité de l'argument
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/10/2016
######################################


error(){
        case "$1" in
                0)  echo "'$element' -> Ok pour Sauvegarde" >> $LOG_PATH/Save.log;;
                1)  echo "Code d'erreur 1 :"  >> $LOG_PATH/Save.log
                        echo -e "\t '$element' n'existe pas" >> $LOG_PATH/Save.log
                        State_Save 1
                        exit 1;;
                2)  echo "Code d'erreur 2 :"  >> $LOG_PATH/Save.log
                        echo -e "\t '$element' n'est pas un dossier" >> $LOG_PATH/Save.log
                        State_Save 1
                        exit 2;;
        esac
}

dir_exist(){
        element=$1
        if [ ! -e $1 ];
        then
                error 1
        elif [ -f $1 ];
        then
                error 2
        else
                error 0
        fi
}