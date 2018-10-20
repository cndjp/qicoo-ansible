#!/bin/bash
source /home/qicoo/qicoo-ansible/bat/env
ALLUP_LOG_DIR="/home/qicoo/qicoo-all-up/"

ALLUP_LOG_FILE+=${ALLUP_LOG_DIR}
ALLUP_LOG_FILE+=${1}

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/eks/setup-eks-env.yml --skip-tags "no-routine" >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-deployment.yml >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-rds-instance.yml >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-elasticache-cluster.yml >> ${ALLUP_LOG_FILE}
echo "hal config restore" >> ${ALLUP_LOG_FILE}
/home/qicoo/qicoo-ansible/bat/hal-restore.sh >> ${ALLUP_LOG_FILE}
echo "hal deploy apply" >> ${ALLUP_LOG_FILE}
hal deploy apply >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-restore.yml >> ${ALLUP_LOG_FILE}
