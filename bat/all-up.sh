#!/bin/bash

ANSIBLE_CTL="ansible-playbook -i localhost, -c local"
TIMESTAMP=$(date "+%Y%m%d%H%M%S")
ALLUP_LOG_DIR="/home/qicoo/qicoo-all-up/"

ALLUP_LOG_FILE+=${ALLUP_LOG_DIR}
ALLUP_LOG_FILE+=qicoo-all-up_${TIMESTAMP}.log

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/eks/setup-eks-env.yml > ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-rds-instance.yml > ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-elasticache-cluster.yml > ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-deployment.yml > ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-restore.yml > ${ALLUP_LOG_FILE}
hal deploy apply
