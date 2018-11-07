#!/bin/bash

HOSTED_ZONE_ID=Z36M600IDI6K7I
CHECK_LOG_FILE=${1}

function check_route53_record() {
  echo "Route53 Record ${1} type ${2}" >> ${CHECK_LOG_FILE}
  /home/qicoo/.local/bin/aws route53 test-dns-answer --hosted-zone-id ${HOSTED_ZONE_ID} --record-name ${1} --record-type ${2} | jq ."RecordData" >> ${CHECK_LOG_FILE}
  echo "" >> ${CHECK_LOG_FILE}
}

check_route53_record 'spinnaker.qicoo.tokyo' 'A'
check_route53_record 'db.qicoo.tokyo'        'CNAME'
check_route53_record 'db-s.qicoo.tokyo'      'CNAME'
check_route53_record 'db-d.qicoo.tokyo'      'CNAME'
check_route53_record 'cache.qicoo.tokyo'     'CNAME'
check_route53_record 'cache-s.qicoo.tokyo'   'CNAME'
check_route53_record 'cache-d.qicoo.tokyo'   'CNAME'
