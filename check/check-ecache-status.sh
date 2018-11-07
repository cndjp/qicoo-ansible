#!/bin/bash

CHECK_LOG_FILE=${1}

function check_ecache_status() {
  ECACHE_STATUS=`aws elasticache describe-cache-clusters --cache-cluster-id ${1} | jq '.CacheClusters[].CacheClusterStatus'`
  echo "ElastiCache ${1} Status " >> ${CHECK_LOG_FILE}
  if [ -z ${ECACHE_STATUS} ];then
    echo '"May be not exists"' >> ${CHECK_LOG_FILE}
  else
    echo ${ECACHE_STATUS} >> ${CHECK_LOG_FILE}
  fi
  echo "" >> ${CHECK_LOG_FILE}
}

check_ecache_status 'qicoo-ecache-01'   
check_ecache_status 'qicoo-ecache-s01'   
check_ecache_status 'qicoo-ecache-d01'    
