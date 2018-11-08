#!/bin/bash

CHECK_LOG_FILE=${1}

function check_ec2_status() {
  EC2_STATUS=`/home/qicoo/.local/bin/aws ec2 describe-instance-status`
  INSTANCE_LIST=(`echo ${EC2_STATUS} | jq -r '.InstanceStatuses[].InstanceId'`)
  STATUS_LIST=(`echo ${EC2_STATUS} | jq '.InstanceStatuses[].InstanceStatus.Status'`)

  INDEX=1
  #echo ${INSTANCE_LIST} | while read INSTANCE
  for((i=0; i<${#INSTANCE_LIST[@]}; i++))
  do
    echo "EC2 Instace ${INSTANCE_LIST[i]} Status " >> ${CHECK_LOG_FILE}
    echo ${STATUS_LIST[i]} >> ${CHECK_LOG_FILE}
    echo "" >> ${CHECK_LOG_FILE}
  done
}

check_ec2_status
