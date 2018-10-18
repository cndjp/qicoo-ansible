#!/bin/bash
PATH=${PATH}:/home/qicoo/bin:/home/qicoo/.local/bin:/home/qicoo/bin:/usr/local/bin:/usr/bin
export KUBECONFIG=/home/qicoo/.kube/config
export AWS_CONFIG_FILE=/home/qicoo/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/home/qicoo/.aws/credentials


ANSIBLE_CTL="/home/qicoo/.local/bin/ansible-playbook -i localhost, -c local"
ALLDOWN_LOG_DIR="/home/qicoo/qicoo-all-down/"

ALLDOWN_LOG_FILE+=${ALLDOWN_LOG_DIR}
ALLDOWN_LOG_FILE+=${1}

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-backup.yml >> ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/eks/delete-eks-env.yml >> ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/delete-rds-instance.yml >> ${ALLDOWN_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/delete-elasticache-cluster.yml >> ${ALLDOWN_LOG_FILE}
