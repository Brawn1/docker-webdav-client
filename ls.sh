#! /usr/bin/env sh

IFS=","
PERIOD=${1:-30}
DEST=${WEBDRIVE_MOUNT:-/mnt/webdrive}
SCANNER=${SCANNER_MOUNT:-/mnt/scanner}
FOLDERS=${SCANNER_FOLDERS:-}

. trap.sh

copy_scanner(){
    echo "start move scanner items"
    for FOLDER in ${FOLDERS}
    do
        chmod -R 775 ${SCANNER}/${FOLDER}
        mv "${SCANNER}/${FOLDER}/"* ${DEST}/${FOLDER}/
        echo "move items from ${FOLDER}"
    done
}


while true; do
    echo "while loop started"
    copy_scanner
    ls $DEST
    sleep $PERIOD
done
