#!/bin/bash
PATH=${PATH}:/home/qicoo/bin:/home/qicoo/.local/bin:/home/qicoo/bin:/usr/local/bin:/usr/bin
export KUBECONFIG=/home/qicoo/.kube/config
export AWS_CONFIG_FILE=/home/qicoo/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/home/qicoo/.aws/credentials

ANSIBLE_CTL="/home/qicoo/.local/bin/ansible-playbook -i localhost, -c local"
ARKRESTORE_LOG_DIR="/home/qicoo/qicoo-ark-restore/"

ARKRESTORE_LOG_FILE+=${ARKRESTORE_LOG_DIR}
ARKRESTORE_LOG_FILE+=${1}

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/ark/create-heptio-restore.yml > ${ARKRESTORE_LOG_FILE}
