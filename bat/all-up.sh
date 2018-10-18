#!/bin/bash
PATH=${PATH}:/home/qicoo/bin:/home/qicoo/.local/bin:/home/qicoo/bin:/usr/local/bin:/usr/bin
export KUBECONFIG=/home/qicoo/.kube/config
alias a='ansible-playbook -i localhost, -c local --vault-password-file /homw/qicoo/.vault_password'
export AWS_CONFIG_FILE=/home/qicoo/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/home/qicoo/.aws/credentials

ANSIBLE_CTL="/home/qicoo/.local/bin/ansible-playbook -i localhost, -c local"
TIMESTAMP=$(date "+%Y%m%d%H%M%S")
ALLUP_LOG_DIR="/home/qicoo/qicoo-all-up/"

ALLUP_LOG_FILE+=${ALLUP_LOG_DIR}
ALLUP_LOG_FILE+=qicoo-all-up_${TIMESTAMP}.log

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-elasticache-cluster.yml >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/aws/create-rds-instance.yml >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/eks/setup-eks-env.yml >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-deployment.yml >> ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-restore.yml >> ${ALLUP_LOG_FILE}
hal deploy apply
