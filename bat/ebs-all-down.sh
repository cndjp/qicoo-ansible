#!/bin/bash

EBS_LIST=($(/home/qicoo/.local/bin/aws ec2 describe-tags --query 'Tags[?Key==`Name`]' | /usr/bin/jq -r '.[] | select( .ResourceType == "volume") | .ResourceId'))

for((i=0; i<${#EBS_LIST[@]}; i++))
do
  echo "Delete Volume for the ${EBS_LIST[i]}"
  /home/qicoo/.local/bin/aws ec2 delete-volume --volume-id ${EBS_LIST[i]}
done
