#!/bin/bash

######################################
# Export.sh
# Utilité: ce script est utisé par Save.sh ainsi que SaveSQL.sh, transfet vers des hotes pré-défini
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 01/08/2016
######################################


Export_save(){
    export SSHPASS=AzrodSave
    
    Save_User="save"
    REMOTE_HOST="backup.rootkit-lab.org"

    SCP_CMD="sshpass -e scp $EXPORT_PATH/$1 $Save_User@$REMOTE_HOST:$REMOTE_EXPORT_PATH"

    Check_Remote_Host

    if [[ Check_Remote_Host ]]; then
        echo "" >> $LOG_PATH/Save.log
        echo "Transfert de la sauvegarde en cours vers \"$REMOTE_HOST\"" >> $LOG_PATH/Save.log
        Time=$({ time $(eval $(echo $SCP_CMD));  } 2>&1 | grep real | cut -d 'l' -f2 | cut -c2-)
        echo "Le transfert a duré $Time" >> $LOG_PATH/Save.log
        echo "Transfert terminé" >> $LOG_PATH/Save.log
        
        if [[ ! -f $EXPORT_CKSUM_PATH/"Demande_CkSum" ]]; then
            echo "" >> $LOG_PATH/Save.log
            echo "Création d'une demande de CkSum" >> $LOG_PATH/Save.log
            touch $EXPORT_CKSUM_PATH/"Demande_CkSum"
            echo "Demande de CkSum créée" >> $LOG_PATH/Save.log
        fi
        
        echo "" >> $LOG_PATH/Save.log
        echo "Envoie d'une demande de CkSum de la part de \"$REMOTE_HOST\"" >> $LOG_PATH/Save.log
        sshpass -e scp $EXPORT_CKSUM_PATH/"Demande_CkSum" $Save_User@$REMOTE_HOST:"/home/save"
        echo "Demande envoyée" >> $LOG_PATH/Save.log
        
        echo "" >> $LOG_PATH/Save.log
        echo "Suppresion de la demande de CkSum" >> $LOG_PATH/Save.log
        rm $EXPORT_CKSUM_PATH/"Demande_CkSum"
        echo "Demande de CkSum supprimée" >> $LOG_PATH/Save.log    
    
        echo "" >> $LOG_PATH/Save.log
        echo "En attente du Cksum de l'hôte \"$REMOTE_HOST\"" >> $LOG_PATH/Save.log
        echo $(date) >> $LOG_PATH/Save.log
        echo "Reprise du script dans 3 min" >> $LOG_PATH/Save.log
        sleep 3m
        echo "" >> $LOG_PATH/Save.log
        echo $(date) >> $LOG_PATH/Save.log
        echo "Reprise du script" >> $LOG_PATH/Save.log
        
        echo "" >> $LOG_PATH/Save.log
        echo "Controle des CheckSums :" >> $LOG_PATH/Save.log
        
        if [[ "$(Ctrl_ChkSum "$2")" = 0 ]]; then
            echo "" >> $LOG_PATH/Save.log
            echo "Suppression du fichier de sauvaegarde local ($1)" >> $LOG_PATH/Save.log
            rm $EXPORT_PATH/$1
            echo "Fichier local ($1) supprimé" >> $LOG_PATH/Save.log
        fi
    fi
}