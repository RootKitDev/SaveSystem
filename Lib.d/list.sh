#!/bin/bash

######################################
# list.sh
# Utilité: ce script est utisé par Data_Save.sh
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/10/2016
######################################


Size_save(){
    size=$(tar -tzvf $1 | gawk ' BEGIN {sum=0} //{sum+=$3} END{print sum} ')
	unit="o"

	while [[ $size -gt 1024 ]];
	do
		size=$(($size / 1024))
	
		case $unit in
			"o")
				unit="Ko"
			;;
			"Ko")
				unit="Mo"
			;;
			"Mo")
				unit="Go"
			;;
			"Go")
				unit="To"
			;;
			"To")
				unit="Po"
			;;
			"Po")
				unit="Eo"
			;;
			"Eo")
				unit="Zo"
			;;
			"Zo")
				unit="Yo"
			;;
		esac
		
	done

	echo ""  >> $LOG_PATH/Save.log
	echo "-------------Calcul de Volumetrie-------------" >> $LOG_PATH/Save.log
	echo "$size$unit ont été sauvegardés"  >> $LOG_PATH/Save.log
}