#! /bin/bash

######################################
# Data_Save.sh
# Utilité: ce script sert à faire des sauvegardés de données de façon dynamique
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 02/08/2016
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
LOG_PATH="$HOME_PATH/Logs.d"

LIB_PATH="$HOME_PATH/Lib.d"

EXPORT_PATH="$HOME_PATH/Data_Export"
EXPORT_CKSUM_PATH="$HOME_PATH/CkSum_Export"

REMOTE_EXPORT_PATH="/home/save/azrod/Data"

LISTED_INCREMENTAL_PATH="$HOME_PATH/Lists.d"
SAVE_LIST_PATH="$HOME_PATH/ListSave.d"
EXCLUDE_LIST_PATH="$HOME_PATH/ExcludeSave.d"

SAVE_STATE_PATH="$HOME_PATH/Etats"

# Load all .sh lib, using source command
source $LIB_PATH/exist.sh
source $LIB_PATH/list.sh
source $LIB_PATH/Save.sh
source $LIB_PATH/Export.sh
source $LIB_PATH/required.sh
source $LIB_PATH/Check_Sum.sh

# Writing in the early log
echo "" >> $LOG_PATH/Save.log
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" >> $LOG_PATH/Save.log
echo `date` >> $LOG_PATH/Save.log
echo "" >> $LOG_PATH/Save.log

# Determinéetion of useful variables
Now=$(date -d 'now' +"%d-%m-%Y")
Yesterday=$(date -d 'yesterday' +"%d-%m-%Y")

MonthYesterday=$(echo $Yesterday | cut -d'-' -f2)
MonthNow=$(echo $Now | cut -d'-' -f2)

Day=$(date +"%u" | cut -d' ' -f2)

Go_Save_WE="2130"


# Determining the type of backup
if [ $MonthNow -gt $MonthYesterday ] || [ -f /home/backup/Flags/EX-000 ];
then

	if [ ! -f /home/backup/Flags/PS-001 ] || [ -f /home/backup/Flags/EX-000 ] ;
	then
		# Writing Log File
		if [ -f /home/backup/Flags/EX-000 ];
		then
				echo 'Sauvegarde Exceptionnel (sauvegarde Full) :' >> $LOG_PATH/Save.log
		else
				echo 'Sauvegarde Mensuel (sauvegarde Full) :' >> $LOG_PATH/Save.log
		fi
		
		echo 'Les Répertoires sauvegardés sont :' >> $LOG_PATH/Save.log
	
		if [[ -z "$(echo -e "$(cat $SAVE_LIST_PATH/ListSaveMen)" | tr '\n' ' ' | cut -d ' ' -f1)" ]]; then
			echo -e "\tIl n'y a pas de dossier(s) a sauvegardé(s)" >> $LOG_PATH/Save.log
		else
			
			# Check if directory exist
			for elem in $(cat $SAVE_LIST_PATH/ListSaveMen)
			do
				dir_exist $elem
			done
			
			echo "" >> $LOG_PATH/Save.log
			echo "Eligibilité des dossiers terminée avec succes !" >> $LOG_PATH/Save.log
			echo "-------------Calcul de Volumetrie-------------" >> $LOG_PATH/Save.log
			
			# Calculation of Volumetric
			Size_save $(cat $SAVE_LIST_PATH/ListSaveMen)
			
			# Launch monthly Data Save 
			Data_save "Mensuel"

		fi
		
	else
		echo 'Fanion "Pas de Sauvegarde Mensuel" détecté' >> $LOG_PATH/Save.log
		echo "PS-Mensuel" > $SAVE_STATE_PATH/$(date +"%m_%B/%d")
	fi
	
elif [[ "$Day" = "1" ]];
then 

	if [ ! -f /home/backup/Flags/PS-002 ];
	then
		# Writing Log File
		echo 'Sauvegarde Hebdomadaire (sauvegarde Full) :' >> $LOG_PATH/Save.log
		echo "" >> $LOG_PATH/Save.log
		echo 'Les Répertoires sauvegardés sont :' >> $LOG_PATH/Save.log
		
		if [[ -z "$(echo -e "$(cat $SAVE_LIST_PATH/ListSaveHeb)" | tr '\n' ' ' | cut -d ' ' -f1)" ]]; then
			echo "Il n'y a pas de dossier(s) a sauvegardé(s)" >> $LOG_PATH/Save.log
		else
			
			# Check if directory exist
			for elem in $(cat $SAVE_LIST_PATH/ListSaveHeb)
			do
				dir_exist $elem
			done
			
			echo "" >> $LOG_PATH/Save.log
			echo "Eligibilité des dossiers terminée avec succes !" >> $LOG_PATH/Save.log
			echo "-------------Calcul de Volumetrie-------------" >> $LOG_PATH/Save.log
			
			# Calculation of Volumetric
			Size_save $(cat $SAVE_LIST_PATH/ListSaveHeb)
			
			# Launch weekly Data Save 
			Data_save "Hebdomadaire"

		fi
		
	else
		echo 'Fanion "Pas de Sauvegarde Hebdomadaire" détecté' >> $LOG_PATH/Save.log
		echo "PS-Hebdo" > $SAVE_STATE_PATH/$(date +"%m_%B/%d")
	fi
	
elif [[ "$Day" = "6" ]] && [[ "$(date +%H%M)" -gt $Go_Save_WE ]];
then 
	if [ ! -f /home/backup/Flags/PS-003 ];
	then
		# Writing Log File
		echo 'Sauvegarde Week-End (sauvegarde Incrementiel => Mensuel) :' >> $LOG_PATH/Save.log
		echo 'Les Répertoires sauvegardés sont :' >> $LOG_PATH/Save.log
		
		if [[ -z "$(echo -e "$(cat $SAVE_LIST_PATH/ListSaveMen)" | tr '\n' ' ' | cut -d ' ' -f1)" ]]; then
			echo "Il n'y a pas de dossier(s) a sauvegardé(s)" >> $LOG_PATH/Save.log
		else
			
			# Check if directory exist
			for elem in $(cat $SAVE_LIST_PATH/ListSaveMen)
			do
				dir_exist $elem
			done
			
			echo "" >> $LOG_PATH/Save.log
			echo "Eligibilité des dossiers terminée avec succes !" >> $LOG_PATH/Save.log
			echo "-------------Calcul de Volumetrie-------------" >> $LOG_PATH/Save.log
			
			# Calculation of Volumetric
			Size_save $(cat $SAVE_LIST_PATH/ListSaveMen)
			
			# Launch weekly-end Data Save 
			Data_save "Week-End"
		fi
		
	else
		echo 'Fanion "Pas de Sauvegarde Week-End" détecté' >> $LOG_PATH/Save.log
		echo "PS-WE" > $SAVE_STATE_PATH/$(date +"%m_%B/%d")
	fi

else

	if [ ! -f /home/backup/Flags/PS-004 ];
	then
		# Writing Log File
		echo 'Sauvegarde Journaliere (sauvegarde Incrementiel => Hebdomadaire) :'  >> $LOG_PATH/Save.log
		echo 'Les Répertoires sauvegardés sont :'  >> $LOG_PATH/Save.log
		
		if [[ -z "$(echo -e "$(cat $SAVE_LIST_PATH/ListSaveHeb)" | tr '\n' ' ' | cut -d ' ' -f1)" ]]; then
			echo "Il n'y a pas de dossier(s) a sauvegardé(s)" >> $LOG_PATH/Save.log
		else
			
			# Check if directory exist
			for elem in $(cat $SAVE_LIST_PATH/ListSaveHeb)
			do
				dir_exist $elem
			done
			
			echo "" >> $LOG_PATH/Save.log
			echo "Eligibilité des dossiers terminée avec succes !" >> $LOG_PATH/Save.log
			echo "-------------Calcul de Volumetrie-------------" >> $LOG_PATH/Save.log
			
			# Calculation of Volumetric
			Size_save $(cat $SAVE_LIST_PATH/ListSaveHeb)
			
			# Launch daily Data Save 
			Data_save "Journaliere"
		fi
		
	else
		echo 'Fanion "Pas de Sauvegarde Journaliere" détecté' >> $LOG_PATH/Save.log
		echo "PS-Journa" > $SAVE_STATE_PATH/$(date +"%m_%B/%d")
	fi
	
fi

echo "" >> $LOG_PATH/Save.log
echo "Fin du script $0" >> $LOG_PATH/Save.log