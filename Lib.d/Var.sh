#!/bin/bash

######################################
# Save.sh
# Utilité: ce script défini les variable d'environnement du SaveSystem
# Auteur: RootKitDev <RootKit.Dev@gmail.com>
# Mise à jour le: 26/10/2016
######################################

FLAG_PATH="$HOME_PATH/Flags"
LISTED_INCREMENTAL_PATH="$HOME_PATH/Lists.d"
EXPORT_CKSUM_PATH="$HOME_PATH/CkSum_Export"
SAVE_LIST_PATH="$HOME_PATH/ListSave.d"
EXCLUDE_LIST_PATH="$HOME_PATH/ExcludeSave.d"
SAVE_STATE_PATH="$HOME_PATH/Etats"
LOG_PATH="$HOME_PATH/Logs.d"
PARTENAIRE="$HOME_PATH/Hosts"

if [[ -z $SUB_LOG ]]; then
    EXPORT_PATH="$HOME_PATH/Data_Export"
    REMOTE_EXPORT_PATH="/remote/path/to/export/Data"
else
    EXPORT_PATH="$HOME_PATH/Dumps_Export"
    REMOTE_EXPORT_PATH="/remote/path/to/export/Dumps"
fi
