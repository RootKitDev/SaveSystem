#!/bin/bash

######################################
# list.sh
# Utilité: ce script est utisé par Data_Save.sh
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/07/2016
######################################


Size_save(){
    size=$(du -hc -s $(echo -e "$1\n") | grep total | awk -F [KMG] '{print $1}')
	unit=$(du -hc -s $(echo -e "$1\n") | grep total | awk -F [0-9]* '{print $2}' | cut -c1)
	if [[ "$unit" = "." ]]; then
		unit=$(du -hc -s "$1" | grep total | awk -F [0-9]* '{print $3}' | cut -c1)
	fi
	echo " Il y a un total de $size "$unit"o à sauvegarder"  >> $LOG_PATH/Save.log
}