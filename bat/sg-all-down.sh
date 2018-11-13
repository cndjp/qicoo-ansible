#!/bin/bash

SG_LIST=`/home/qicoo/.local/bin/aws ec2 describe-security-groups`
GROUP_ID_LIST=(`echo ${SG_LIST} | jq -r '.SecurityGroups[].GroupId'`)
DESCRIPTION_LIST=(`echo ${SG_LIST} | jq -r '.SecurityGroups[].Description' | tr ' ' '$'`)

for((i=0; i<${#DESCRIPTION_LIST[@]}; i++))
do
  if echo ${DESCRIPTION_LIST[i]} | tr '$' ' ' | grep 'Security group for Kubernetes ELB' >/dev/null 2>&1; then
    /home/qicoo/.local/bin/aws ec2 delete-security-group --group-id ${GROUP_ID_LIST[i]}
    echo "Delete the Security Group is Created by EKS, ${GROUP_ID_LIST[i]}"
  fi
done
