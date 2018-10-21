#!/bin/bash
source /home/qicoo/qicoo-ansible/bat/env
ARKRESTORE_LOG_DIR="/home/qicoo/qicoo-ark-restore/"

ARKRESTORE_LOG_FILE+=${ARKRESTORE_LOG_DIR}
ARKRESTORE_LOG_FILE+=${1}

/home/qicoo/qicoo-ansible/bat/hal-restore.sh > ${ARKRESTORE_LOG_FILE}
echo "hal deploy clean" >> ${ARKRESTORE_LOG_FILE}
hal deploy clean -q >> ${ARKRESTORE_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-restore.yml >> ${ARKRESTORE_LOG_FILE}
echo "hal deploy apply" >> ${ARKRESTORE_LOG_FILE}
hal deploy apply -q >> ${ARKRESTORE_LOG_FILE}
