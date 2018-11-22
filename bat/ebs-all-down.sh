#!/bin/bash

PV_LIST=($(kubectl --namespace monitoring get persistentvolumes | grep 'monitoring/prometheus-k8s-db-prometheus-k8s' | awk '{print $1}'))

for((i=0; i<${#PV_LIST[@]}; i++))
do
  EBS_ID=$(kubectl --namespace monitoring describe persistentvolumes ${PV_LIST[i]} | grep 'VolumeID:' | cut -c 34-)
  echo "Delete Volume for the ${EBS_ID}"
  /home/qicoo/.local/bin/aws ec2 delete-volume --volume-id ${EBS_ID}
done
