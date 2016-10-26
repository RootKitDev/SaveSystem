#!/bin/bash

######################################
# Check_Sum.sh
# Utilité: ce script est utisé par Export.sh
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/10/2016
######################################


Ctrl_ChkSum(){
    
    if [[ -e $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Local.cksum" ]]; then
        Local=$(cat $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Local.cksum")
    fi
    
    if [[ -e $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum" ]]; then
        Remote=$(cat $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum")
    fi
    
    if [[ -n $SUB_LOG ]]; then
        EXPORT_NAME=$1
    fi
    
    echo "" >> $LOG_PATH/Save$SUB_LOG.log
    echo "Controle des CheckSums en cours pour \"$EXPORT_NAME\"" >> $LOG_PATH/Save$SUB_LOG.log
    
    if [[ "$Local" = "$Remote" ]]; then
        echo "Les CheckSums de la sauvegarde $1 du $(date -d 'now' +%d/%m/%Y) en Local et sur \"$REMOTE_HOST\" sont identitiques :" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Local  : $Local" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Remote : $Remote" >> $LOG_PATH/Save$SUB_LOG.log
        
        if [[ $(($i + 1)) = ${#REMOTE_HOST_TAB[@]} ]]; then
            echo "Suppression des fichiers .cksum" >> $LOG_PATH/Save$SUB_LOG.log
            rm $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Local.cksum"
            rm $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum"
            echo "Fichiers .cksum supprimés" >> $LOG_PATH/Save$SUB_LOG.log
        elif [[ $(($i + 1)) < ${#REMOTE_HOST_TAB[@]} ]]; then
            echo "Suppression du fichiers .cksum Remote" >> $LOG_PATH/Save$SUB_LOG.log
            rm $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Remote.cksum"
            echo "Fichier .cksum Remote supprimé" >> $LOG_PATH/Save$SUB_LOG.log
        fi
        
        
        if [[ -z $SUB_LOG ]]; then
            State_Save 0
        else
            echo "" >> $LOG_PATH/Save$SUB_LOG.log
            State_Save 5
        fi
        
        echo 0
    else
        echo "Les CheckSums de la sauvegarde $1 du $(date -d 'now' +%d/%m/%Y) en Local et sur \"$REMOTE_HOST\" sont différents :" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Local : $Local" >> $LOG_PATH/Save$SUB_LOG.log
        echo "Remote : $Remote" >> $LOG_PATH/Save$SUB_LOG.log
        mv $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Local.cksum" $EXPORT_CKSUM_PATH"/"$1"_"$(date -d 'now' +%Y_%m_%d)"_Local-001.cksum"
        echo "Merci de relance manuellement la sauvegarde et de vérifier le nouveau CkSum Local ($EXPORT_CKSUM_PATH/${1}_$(date -d 'now' +%Y_%m_%d)_Local.cksum) avec l'ancien ($EXPORT_CKSUM_PATH/${1}_$(date -d 'now' +%Y_%m_%d)_Local-001.cksum)" >> $LOG_PATH/Save$SUB_LOG.log
        
        if [[ -z $SUB_LOG ]]; then
            State_Save 3
        else
            State_Save 7
        fi
        
        echo 1
        
    fi
}