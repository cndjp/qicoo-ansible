#!/bin/bash

ANSIBLE_CTL="ansible-playbook -i localhost, -c local"
TIMESTAMP=$(date "+%Y%m%d%H%M%S")
ALLUP_LOG_DIR="~/qicoo-all-up/"

ALLUP_LOG_FILE+=${ALLUP_LOG_DIR}/
ALLUP_LOG_FILE+=qicoo-all-up_${TIMESTAMP}.log

${ANSIBLE_CTL} eks/setup-eks-env.yml > ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} aws/create-rds-instance.yml > ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} aws/create-elasticache-cluster.yml > ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} ark/create-heptio-deployment.yml > ${ALLUP_LOG_FILE}
${ANSIBLE_CTL} ark/create-heptio-restore.yml > ${ALLUP_LOG_FILE}
hal deploy apply
