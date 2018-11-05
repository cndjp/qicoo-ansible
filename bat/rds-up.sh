#!/bin/bash
source /home/qicoo/qicoo-ansible/bat/env
ALLUP_LOG_DIR="/home/qicoo/qicoo-all-up/"

ALLUP_LOG_FILE+=${ALLUP_LOG_DIR}
ALLUP_LOG_FILE+=${1}

if [ -z ${2} ]; then
  ALLUP_ZENBU_FLAG+="--skip-tags zenbu"
fi

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-rds-development.yml ${ALLUP_ZENBU_FLAG} >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-rds-staging.yml ${ALLUP_ZENBU_FLAG} >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-rds-production.yml ${ALLUP_ZENBU_FLAG} >> ${ALLUP_LOG_FILE}
