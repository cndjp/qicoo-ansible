#!/bin/bash

LAST_HAL_BACKUP+="/home/qicoo/hal-backup/"
LAST_HAL_BACKUP+=$(ls -1 /home/qicoo/hal-back/ | grep halbackup- | sort -r | head -n1)
hal backup restore -q --backup-path ${LAST_HAL_BACKUP}
