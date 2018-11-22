#!/bin/bash

source /home/qicoo/qicoo-ansible/bat/env
PROMEBACKUP_LOG_DIR="/home/qicoo/qicoo-prometheus-backup/"

PROMEBACKUP_LOG_FILE+=${PROMEBACKUP_LOG_DIR}
PROMEBACKUP_LOG_FILE+=${2}

PV_LIST=($(kubectl --namespace monitoring get persistentvolumes | grep 'monitoring/prometheus-k8s-db-prometheus-k8s' | awk '{print $1}'))

for((i=0; i<${#PV_LIST[@]}; i++))
do
  EBS_ID=$(kubectl --namespace monitoring describe persistentvolumes ${PV_LIST[i]} | grep 'VolumeID:' | cut -c 34-)
  if [ ${1} = 'snapshot' ]; then
    echo "Create Snapshot for the ${EBS_ID}" >> ${PROMEBACKUP_LOG_FILE}
    SNAPSHOT_DESC='Source Qicoo'\''s Prometheus Snapshot at '$(date +%Y/%m/%d_%H:%M:%S)
    /home/qicoo/.local/bin/aws ec2 create-snapshot --volume-id ${EBS_ID} --description ${SNAPSHOT_DESC} >> ${PROMEBACKUP_LOG_FILE}zz
  elif [${1} = 'delete' ]; then
    echo "Delete Volume for the ${EBS_ID}" >> ${PROMEBACKUP_LOG_FILE}
    /home/qicoo/.local/bin/aws ec2 delete-volume --volume-id ${EBS_ID} >> ${PROMEBACKUP_LOG_FILE}
  fi
done
