#!/bin/bash

CHECK_LOG_FILE=${1}

function check_eks_status() {
  echo "EKS ${1} Status " >> ${CHECK_LOG_FILE}
  EKS_STATUS=`/home/qicoo/.local/bin/aws eks describe-cluster --name ${1} | jq '.cluster.status'`
  if [ -z ${EKS_STATUS} ];then
    echo '"May be not exists"' >> ${CHECK_LOG_FILE}
  else
    echo ${EKS_STATUS} >> ${CHECK_LOG_FILE}
  fi
  echo "" >> ${CHECK_LOG_FILE}
}

check_eks_status 'qicoo-eks-01'
