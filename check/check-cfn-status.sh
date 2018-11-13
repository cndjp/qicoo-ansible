#!/bin/bash

CHECK_LOG_FILE=${1}

function check_cfn_status() {
  CFN_STATUS=`/home/qicoo/.local/bin/aws cloudformation describe-stacks`
  STACK_LIST=(`echo ${CFN_STATUS} | jq -r '.Stacks[].StackName'`)
  STATUS_LIST=(`echo ${CFN_STATUS} | jq '.Stacks[].StackStatus'`)

  for((i=0; i<${#STACK_LIST[@]}; i++))
  do
    echo "Cloudformation ${STACK_LIST[i]} Status " >> ${CHECK_LOG_FILE}
    echo ${STATUS_LIST[i]} >> ${CHECK_LOG_FILE}
    echo "" >> ${CHECK_LOG_FILE}
  done
}

check_cfn_status
