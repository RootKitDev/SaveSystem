#!/bin/bash

######################################
# Export.sh
# Utilité: ce script est utisé par Save.sh ainsi que SaveSQL.sh, transfet vers des hotes pré-défini
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 01/08/2016
######################################


Export_save(){
    export SSHPASS=SavePasswd
    
    Save_User="saveuser"
    
    REMOTE_HOST_TAB=( "host1.domain.tld" "host2.otherdomain.tld" )
    
    for (( i = 0; i < ${#REMOTE_HOST_TAB[@]}; i++ )); do
        REMOTE_HOST=${REMOTE_HOST_TAB[$i]}
    
        SCP_CMD="sshpass -p $SSHPASS scp $EXPORT_PATH/$1 $Save_User@$REMOTE_HOST:$REMOTE_EXPORT_PATH"
    
    
        if [[ "$(Check_Remote_Host)" = 0 ]]; then
            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo "Transfert de la sauvegarde en cours vers \"$REMOTE_HOST\"" >> $LOG_PATH/Save$SUB_LOG.log
            Time=$({ time $(eval $(echo $SCP_CMD)); } 2>&1 | grep real | cut -d 'l' -f2 | cut -c2-)
            echo "Le transfert a duré $Time" >> $LOG_PATH/Save$SUB_LOG.log
            echo "Transfert terminé" >> $LOG_PATH/Save$SUB_LOG.log
            
            if [[ ! -f $EXPORT_CKSUM_PATH/"Demande_CkSum" ]]; then
                echo "" >> $LOG_PATH/Save$SUB_LOG.log
                echo "Création d'une demande de CkSum" >> $LOG_PATH/Save$SUB_LOG.log
                touch $EXPORT_CKSUM_PATH/"Demande_CkSum$SUB_LOG"
                echo "Demande de CkSum$SUB_LOG créée" >> $LOG_PATH/Save$SUB_LOG.log
            fi
            
            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo "Envoie d'une demande de CkSum de la part de \"$REMOTE_HOST\"" >> $LOG_PATH/Save$SUB_LOG.log
            sshpass -p $SSHPASS scp $EXPORT_CKSUM_PATH/"Demande_CkSum$SUB_LOG" $Save_User@$REMOTE_HOST:"/home/save"
            echo "Demande envoyée" >> $LOG_PATH/Save$SUB_LOG.log
            rm $EXPORT_CKSUM_PATH/"Demande_CkSum$SUB_LOG"
        
            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo "En attente du Cksum de l'hôte \"$REMOTE_HOST\"" >> $LOG_PATH/Save$SUB_LOG.log
            echo $(date) >> $LOG_PATH/Save$SUB_LOG.log
            echo "Reprise du script dans 3 min" >> $LOG_PATH/Save$SUB_LOG.log
            sleep 3m
            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo $(date) >> $LOG_PATH/Save$SUB_LOG.log
            echo "Reprise du script" >> $LOG_PATH/Save$SUB_LOG.log
            
            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            echo "Controle des CheckSums :" >> $LOG_PATH/Save$SUB_LOG.log
            
            if [[ "$(Ctrl_ChkSum "$2")" = 0 &&  "$i" > ${#REMOTE_HOST_TAB[@]} ]]; then
                echo "" >> $LOG_PATH/Save$SUB_LOG.log
                echo "Suppression du fichier de sauvegarde local ($1)" >> $LOG_PATH/Save$SUB_LOG.log
                rm $EXPORT_PATH/$1
                echo "Fichier local ($1) supprimé" >> $LOG_PATH/Save$SUB_LOG.log
            fi
        fi
    done
}
