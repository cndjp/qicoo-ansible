#!/bin/bash

ANSIBLE_CTL="ansible-playbook -i localhost, -c local"
TIMESTAMP=$(date "+%Y%m%d%H%M%S")
ALLDOWN_LOG_DIR="/home/qicoo/qicoo-all-down/"

ALLDOWN_LOG_FILE+=${ALLDOWN_LOG_DIR}
ALLDOWN_LOG_FILE+=qicoo-all-down_${TIMESTAMP}.log

touch ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-backup.yml > ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/eks/delete-eks-env.yml > ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/delete-rds-instance.yml > ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/delete-elasticache-cluster.yml > ${ALLDOWN_LOG_FILE}
