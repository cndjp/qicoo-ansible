#!/bin/bash

CHECK_LOG_FILE=${1}

function check_rds_status() {
  RDS_STATUS=`/home/qicoo/.local/bin/aws rds describe-db-instances --db-instance-identifier ${1} | jq '.DBInstances[].DBInstanceStatus'`
  echo "RDS for MySQL ${1} Status " >> ${CHECK_LOG_FILE}
  if [ -z ${RDS_STATUS} ];then
    echo '"May be not exists"' >> ${CHECK_LOG_FILE}
  else
    echo ${RDS_STATUS} >> ${CHECK_LOG_FILE}
  fi
  echo "" >> ${CHECK_LOG_FILE}
}

check_rds_status 'qicoo-rds-01'   
check_rds_status 'qicoo-rds-s01'   
check_rds_status 'qicoo-rds-d01'    
