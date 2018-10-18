#!/bin/bash
source /home/qicoo/qicoo-ansible/bat/env
ALLDOWN_LOG_DIR="/home/qicoo/qicoo-all-down/"

ALLDOWN_LOG_FILE+=${ALLDOWN_LOG_DIR}
ALLDOWN_LOG_FILE+=${1}

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-backup.yml >> ${ALLDOWN_LOG_FILE}
echo 'hal backup create' >> ${ALLDOWN_LOG_FILE}
/home/qicoo/qicoo-ansible/bat/hal-backup.sh
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/eks/delete-eks-env.yml >> ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/delete-rds-instance.yml >> ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/delete-elasticache-cluster.yml >> ${ALLDOWN_LOG_FILE}
