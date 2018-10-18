#!/bin/bash
source /home/qicoo/qicoo-ansible/bat/env
ARKRESTORE_LOG_DIR="/home/qicoo/qicoo-ark-restore/"

ARKRESTORE_LOG_FILE+=${ARKRESTORE_LOG_DIR}
ARKRESTORE_LOG_FILE+=${1}

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-restore.yml > ${ARKRESTORE_LOG_FILE}
