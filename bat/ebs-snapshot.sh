#!/bin/bash

source /home/qicoo/qicoo-ansible/bat/env
PROMEBACKUP_LOG_DIR="/home/qicoo/qicoo-prometheus-backup/"

PROMEBACKUP_LOG_FILE+=${PROMEBACKUP_LOG_DIR}
PROMEBACKUP_LOG_FILE+=${1}

EBS_ID=$(/home/qicoo/.local/bin/aws cloudformation describe-stack-resource --logical-resource-id PrometheusDataVolume --stack-name ebs-prometheus --query 'StackResourceDetail.PhysicalResourceId' | tr -d '"')
echo "Create Snapshot for the ${EBS_ID}" >> ${PROMEBACKUP_LOG_FILE}
SNAPSHOT_DESC="Source_Qicoo_Prometheus_Snapshot_at_$(date +%Y/%m/%d_%H:%M:%S)"
/home/qicoo/.local/bin/aws ec2 create-snapshot --volume-id ${EBS_ID} --description ${SNAPSHOT_DESC} >> ${PROMEBACKUP_LOG_FILE}
