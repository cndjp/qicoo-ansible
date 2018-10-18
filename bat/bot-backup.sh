#!/bin/bash
source /home/qicoo/qicoo-ansible/bat/env
ARKBACKUP_LOG_DIR="/home/qicoo/qicoo-ark-backup/"

ARKBACKUP_LOG_FILE+=${ARKBACKUP_LOG_DIR}
ARKBACKUP_LOG_FILE+=${1}

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-backup.yml > ${ARKBACKUP_LOG_FILE}
echo 'hal backup create' >> ${ARKBACKUP_LOG_FILE}
/home/qicoo/qicoo-ansible/bat/hal-backup.sh >> ${ARKBACKUP_LOG_FILE}
