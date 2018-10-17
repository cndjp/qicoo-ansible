#!/bin/bash
PATH=${PATH}:/home/qicoo/bin:/home/qicoo/.local/bin:/home/qicoo/bin:/usr/local/bin:/usr/bin

ANSIBLE_CTL="/home/qicoo/.local/bin/ansible-playbook -i localhost, -c local"
TIMESTAMP=$(date "+%Y%m%d%H%M%S")
ALLDOWN_LOG_DIR="/home/qicoo/qicoo-all-down/"

ALLDOWN_LOG_FILE+=${ALLDOWN_LOG_DIR}
ALLDOWN_LOG_FILE+=qicoo-all-down_${TIMESTAMP}.log

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-backup.yml >> ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/eks/delete-eks-env.yml >> ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/delete-rds-instance.yml >> ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/delete-elasticache-cluster.yml >> ${ALLDOWN_LOG_FILE}
