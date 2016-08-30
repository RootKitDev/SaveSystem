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
HOME_PATH=""
LOG_PATH=""

LIB_PATH=""
FLAG_PATH=""

EXPORT_PATH=""
EXPORT_CKSUM_PATH=""

REMOTE_EXPORT_PATH=""

LISTED_INCREMENTAL_PATH=""
SAVE_LIST_PATH=""
EXCLUDE_LIST_PATH=""

SAVE_STATE_PATH=""

SUB_LOG=""

# Load all .sh lib, using source command
source $LIB_PATH/exist.sh
source $LIB_PATH/list.sh
source $LIB_PATH/Save.sh
source $LIB_PATH/Export.sh
source $LIB_PATH/required.sh
source $LIB_PATH/Check_Sum.sh
source $LIB_PATH/States.sh

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
if [ $MonthNow -gt $MonthYesterday ] || [ -f $FLAG_PATH/EX-000 ];
then
	
	echo "EC" > $SAVE_STATE_PATH/$MonthSave/$DaySave
	if [ ! -f $FLAG_PATH/PS-001 ] || [ -f $FLAG_PATH/EX-000 ] ;
	then
		# Writing Log File
		if [ -f $FLAG_PATH/EX-000 ];
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
		State_Save 4
	fi
	
elif [[ "$Day" = "1" ]];
then 
	
	echo "EC" > $SAVE_STATE_PATH/$MonthSave/$DaySave
	if [ ! -f $FLAG_PATH/PS-002 ];
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
		State_Save 4
	fi
	
elif [[ "$Day" = "6" ]] && [[ "$(date +%H%M)" -gt $Go_Save_WE ]];
then 
	echo "EC" > $SAVE_STATE_PATH/$MonthSave/$DaySave
	if [ ! -f $FLAG_PATH/PS-003 ];
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
		State_Save 4
	fi

elif [[ ! -e $FLAG_PATH/PS-000 ]]; 
then
	echo "EC" > $SAVE_STATE_PATH/$MonthSave/$DaySave
	if [ ! -f $FLAG_PATH/PS-004 ];
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
		State_Save 4
	fi

fi

echo "" >> $LOG_PATH/Save.log
echo "Fin du script $0" >> $LOG_PATH/Save.log